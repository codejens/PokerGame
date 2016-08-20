-- TaoBaoWin
-- create by chj 
-- 消费返回活动
super_class.TaoBaoWin(NormalStyleWindow);

local panel_w = 440
local panel_h = 560

local font_size = 16

TaoBaoWin.ACTIVITY_ID = 23

--构造函数
function TaoBaoWin:__init( window_name, window_info )
    -- 背景图
    self.panel_bg = CCBasePanel:panelWithFile( 10, 10, panel_w, panel_h, UILH_COMMON.normal_bg_v2, 500, 500)
    self.view:addChild( self.panel_bg)

    self.panel_in = CCBasePanel:panelWithFile( 15, 15, panel_w-30, panel_h-30, UILH_COMMON.bottom_bg, 500, 500)
    self.panel_bg:addChild( self.panel_in)

    require "../data/activity_config/taobaotree_config"
    -- 活动时间
    ZLabel:create( self.panel_bg, LH_COLOR[1] .. Lang.TaoBaoWin[1], 25, 505, font_size, ALIGN_LEFT)
    local time_start, time_end = SmallOperationModel:getActivityTimeDescEx_2( TaoBaoWin.ACTIVITY_ID)
    print("---", time_start, time_end )
    ZLabel:create( self.panel_bg, LH_COLOR[2] .. time_start, 120, 505, font_size, ALIGN_LEFT)
    -- 活动介绍
    ZLabel:create( self.panel_bg, LH_COLOR[1] .. Lang.TaoBaoWin[2], 25, 480, font_size, ALIGN_LEFT)
    self.act_dec = CCDialogEx:dialogWithFile(120, 500, 300, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP)
    self.act_dec:setAnchorPoint(0,1)
    self.act_dec:setFontSize(font_size)
    self.act_dec:setText( LH_COLOR[2] .. taobaotree_config.activity_desc .. LH_COLOR[15] )  -- "#cffff00当前效果:#cffffff:"
    self.act_dec:setTag(0)
    self.act_dec:setLineEmptySpace (5)
    self.panel_bg:addChild(self.act_dec)


    -- 活动倒计时 & TimerLabel
    ZLabel:create( self.panel_bg, LH_COLOR[1] .. Lang.TaoBaoWin[3], 25, 435, font_size, ALIGN_LEFT)
    local time_remain = SmallOperationModel:get_act_time( TaoBaoWin.ACTIVITY_ID)
    print("--------time:", time_remain)
    if time_remain == nil or time_remain == 0 then
        ZLabel:create( self.panel_bg, LH_COLOR[6] .. Lang.f_draw[2], 120, 435, font_size, ALIGN_LEFT )
    else
        local function end_call_func()
            ZLabel:create( self.panel_bg, LH_COLOR[6] .. Lang.f_draw[2], 120, 435, font_size, ALIGN_LEFT )
        end
        self.timer_label = TimerLabel:create_label( self.panel_bg, 120, 435, 16, time_remain, LH_COLOR[6], end_call_func )
    end

    -- 淘宝树
    self.tree_img = CCBasePanel:panelWithFile( 592, 190, -1, -1, "scene/npc/59/591.pd", 500, 500)
    self.tree_img:setRotation(-90)
    self.view:addChild( self.tree_img)

    -- 六个展示道具
    local items_width = 360
    local num_item = #taobaotree_config.items
    local item_width = items_width/num_item - 10
    self.slot_item_t = {}
    for i=1, num_item do
        self.slot_item_t[i] = SlotItem( item_width, item_width )
        self.slot_item_t[i]:setPosition( 45 + (item_width+13)*(i-1), 125 )
        self.slot_item_t[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, item_width+15, item_width+15 )
        self.slot_item_t[i]:set_color_frame( taobaotree_config.items[i].itemid, -1, -1, item_width, item_width )
        self.slot_item_t[i]:set_icon( taobaotree_config.items[i].itemid )
        self.slot_item_t[i]:set_item_count( taobaotree_config.items[i].count )
        -- self.slot_sld_t[i] = CCBasePanel:panelWithFile(-8, -8, 70, 70, UILH_COMMON.slot_focus)
        -- self.slot_item_t[i].view:addChild(self.slot_sld_t[i])
        self.view:addChild( self.slot_item_t[i].view )

        local function item_tips_fun(...)
            local a, b, arg = ...
            local click_pos = Utils:Split(arg, ":")
            local world_pos = self.slot_item_t[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
            if taobaotree_config.items[i].itemid ~= 0 then
                TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, taobaotree_config.items[i].itemid )
            else
                local temp_data = { item_id = 1, item_count = taobaotree_config.items[i].count }
                TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
            end
        end
        self.slot_item_t[i]:set_click_event(item_tips_fun)
    end

    -- 可恶的分割线
    local line = CCZXImage:imageWithFile( 30, 100, 400-25, 3, UILH_COMMON.split_line )
    self.panel_bg:addChild( line)

    -- 立即传送按钮
    local function transmit_func()
        --判断活动是否结束,如果结束直接返回
        local t_remainTime = SmallOperationModel:getActivityRemainTime( TaoBaoWin.ACTIVITY_ID)
        if t_remainTime == 0 then
            return
        end

        --获取场景信息
        local scene_info = taobaotree_config.sceneInfo
        --传送到目的地
        GlobalFunc:teleport_to_target_scene( scene_info.sceneId, scene_info.sceneX, scene_info.sceneY)

        --获取NPC名称
        local t_npcName = scene_info.npcName
        --如果NPC名称存在，拉起对话框
        if t_npcName then
            AIManager:set_after_pos_change_command(scene_info.sceneId, AIConfig.COMMAND_ASK_NPC,scene_info.npcName)
        end
    end
    self.btn_transmit = ZTextButton:create( self.panel_bg, LH_COLOR[2] .. Lang.TaoBaoWin[4], UILH_COMMON.lh_button_4_r, transmit_func, 60, 30, -1, -1, 1)

    -- 立即前往按钮
    local function forward_func()
        --判断活动是否结束,如果结束直接返回
        local t_remainTime = SmallOperationModel:getActivityRemainTime( TaoBaoWin.ACTIVITY_ID)

        print("self._activityId",self._activityId)
        if t_remainTime == nil or t_remainTime == 0 then
            GlobalFunc:create_screen_notic( Lang.TaoBaoWin[5])
            return
        end
        --获取场景信息
        local scene_info = taobaotree_config.sceneInfo
        --移动到目的地
        GlobalFunc:move_to_target_scene(scene_info.sceneId,scene_info.sceneX * SceneConfig.LOGIC_TILE_WIDTH,scene_info.sceneY * SceneConfig.LOGIC_TILE_HEIGHT)      
    end
    self.btn_forward = ZTextButton:create( self.panel_bg, LH_COLOR[2] .. Lang.TaoBaoWin[6], UILH_COMMON.btn4_nor, forward_func, 265, 30, -1, -1, 1)

end

-- =============================
-- 获赠名单 scroll
-- =============================
-- =============================================
function TaoBaoWin:update( update_type)
    if update_type == "main" then

    end
end


-- 当界面被UIManager:show_window, hide_window的时候调用
function TaoBaoWin:active(show)
	if show then

	end
end

--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function TaoBaoWin:destroy()
    if self.timer_label then
        self.timer_label:destroy()
        self.timer_label = nil
    end
	Window.destroy(self);
end
