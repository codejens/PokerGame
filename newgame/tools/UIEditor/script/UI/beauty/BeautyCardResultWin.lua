-- BeautyCardResultWin.lua
-- created by chj on 2015-3-16
-- 美人抽卡结果界面（窗口）

require "UI/component/Window"
super_class.BeautyCardResultWin(Window)

-- 初始化
function BeautyCardResultWin:__init( window_name, texture_name )

        -- 关闭按钮事件
    -- local function close_win_fun(eventType,x,y)
    --     if eventType == TOUCH_BEGAN then
    --         return true;
    --     elseif eventType == TOUCH_CLICK then
    --         UIManager:hide_window("beauty_card_result_win");
    --         return true;
    --     elseif eventType == TOUCH_ENDED then
    --         return true;
    --     end
    -- end

    -- 灰暗的背景背景
    self.panel_result = CCBasePanel:panelWithFile( -100, -50,
                    GameScreenConfig.ui_screen_width+200, GameScreenConfig.ui_screen_height+100, UILH_FUBEN.result_bg, 500, 500)
    self.view:addChild(self.panel_result)
    -- self.panel_result:registerScriptHandler( close_win_fun )  --注册

    -- 小宝箱播放特效
    self:create_box_effect( self.panel_result)

    -- 服务器数据
    local result_info = BeautyCardModel:get_result_info( )

    -- 获取 配置数据:draw_type:1是抽1次，10是10连抽
    local result_conf = BeautyCardConfig:get_result_info( result_info.draw_type)
    -- 消费
    local panel_cost = CCBasePanel:panelWithFile(208, 135, 150, 45, UILH_BEAUTYCARD.bc_cost_bg)
    self.panel_result:addChild( panel_cost)
    ZLabel:create( panel_cost, LH_COLOR[2] .. result_conf.cost_type[result_info.result_cost_type], 30, 14, 16, ALIGN_LEFT)
    ZLabel:create( panel_cost, LH_COLOR[2] .. result_conf.cost_num[result_info.result_cost_type], 80, 14, 16, ALIGN_LEFT)

    -- 道具展示
    -- 道具tabel
    self.slot_t = {}

    -- 再开（1 or 10）次按钮
    function open_again_func () 

        -- 如果是令牌宝箱，直接抽取
        if result_info.result_cost_type == 1 then
            BeautyCardCC:req_draw_card( result_info.result_cost_type, result_info.draw_type )
            return
        end

        -- 如果没有免费次数，判断 元宝是否足够
        local card_info = BeautyCardConfig:get_card_info_open( result_info.result_cost_type )

        local temp_cost = card_info.cost_num_1
        if result_info.draw_type == BeautyCardModel.DRAW_TEN then
            temp_cost = card_info.cost_num_10
        end

        local avatar = EntityManager:get_player_avatar() --角色拥有元宝
        if avatar.yuanbao < temp_cost then     -- 判断元宝是否充实
            UIManager:hide_window("beauty_card_result_win")
            local function confirm2_func()
                GlobalFunc:chong_zhi_enter_fun()
            end
            ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面

        else
            BeautyCardCC:req_draw_card( result_info.result_cost_type, result_info.draw_type )
        end
    end
    local open_again = ZTextButton:create( self.panel_result, LH_COLOR[2] .. result_conf.btn_label, UILH_COMMON.btn4_nor, open_again_func, 360, 130)

    --  确定按钮
    function sure_func () 
        UIManager:hide_window("beauty_card_result_win")
    end
    local btn_sure = ZTextButton:create( self.panel_result, LH_COLOR[2] .. "确  定", UILH_COMMON.btn4_nor, sure_func, 620, 130)
end

--结构界面播放特效
function BeautyCardResultWin:create_box_effect(panel)
    if panel then
        local result_box = CCBasePanel:panelWithFile(555, 560, -1, -1, UILH_BEAUTYCARD.bc_result_box)
        panel:addChild( result_box)
        result_box:setAnchorPoint( 0.5,0.5)
        local scale_1 = CCScaleTo:actionWithDuration(1.2,1.8)
        local scale_2 = CCScaleTo:actionWithDuration(1.2,1.5)
        local act_scale  = CCArray:array()
        act_scale:addObject(scale_1)
        act_scale:addObject(scale_2)
        local seq_scale = CCSequence:actionsWithArray(act_scale)
        local fev_scale = CCRepeatForever:actionWithAction(seq_scale)
        result_box:runAction(fev_scale)
    end
end


-- 更新数据： 参数：更新的类型
function BeautyCardResultWin:update( update_type )
    -- 主界面信息
    if update_type == "re_draw" then
        self:cleanup_create_items()
    end
end

-- 清除道具
function BeautyCardResultWin:cleanup_create_items( )
    -- 清除数据
    if self.slot_t then
        for i=1, #self.slot_t do
            if self.slot_t[i] then
                self.slot_t[i].view:removeFromParentAndCleanup(true)
                self.slot_t[i] = nil
            end
        end
    end
    -- 创建 道具展示 & 道具tabel
    local result_info = BeautyCardModel:get_result_info( )

    self.slot_t = {}
    if result_info.draw_type == BeautyCardModel.DRAW_ONE then
        local pos_temp = BeautyCardConfig:get_result_item_pos( result_info.draw_type)
        self.slot_t[1] = SlotItem( 65, 65 )
        self.slot_t[1].view:setAnchorPoint( 0.5, 0.5)
        self.slot_t[1]:set_icon_bg_texture( UILH_COMMON.slot_bg, -9, -9, 83, 83 )   -- 背框
        self.slot_t[1]:set_icon( result_info.result_items[1].item_id)
        self.slot_t[1]:setPosition( pos_temp[1].x, pos_temp[1].y )
        self.slot_t[1]:set_color_frame( result_info.result_items[1].item_id, 0, 0, 65, 65 )    -- 边框颜色
        local function item_click_fun ()
        -- ActivityModel:show_mall_tips( panel_date.id )
            TipsModel:show_shop_tip( 200, 200, result_info.result_items[1].item_id)
        end
        self.slot_t[1]:set_click_event(item_click_fun)
        self.panel_result:addChild( self.slot_t[1].view )
        self.slot_t[1].view:setScale(0.2)
        -- 添加动态
        local scale_1 = CCScaleTo:actionWithDuration(0.2,1.3)
        local scale_2 = CCScaleTo:actionWithDuration(0.1,1.0)
        local act_scale  = CCArray:array()
        act_scale:addObject(scale_1)
        act_scale:addObject(scale_2)
        local seq_scale = CCSequence:actionsWithArray(act_scale)
        self.slot_t[1].view:runAction( seq_scale)

    elseif result_info.draw_type == BeautyCardModel.DRAW_TEN then
        local pos_temp = BeautyCardConfig:get_result_item_pos( result_info.draw_type)
        for i=1, # result_info.result_items do
            self.slot_t[i] = SlotItem( 65, 65 )
            self.slot_t[i].view:setAnchorPoint( 0.5, 0.5)
            self.slot_t[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -9, -9, 83, 83 )   -- 背框
            self.slot_t[i]:set_icon( result_info.result_items[i].item_id)
            self.slot_t[i]:setPosition( pos_temp[i].x, pos_temp[i].y )
            self.slot_t[i]:set_color_frame( result_info.result_items[i].item_id, 0, 0, 65, 65)    -- 边框颜色
            local function item_click_fun ()
                -- ActivityModel:show_mall_tips( panel_date.id )
                TipsModel:show_shop_tip( 200, 200, result_info.result_items[i].item_id)
            end
            self.slot_t[i]:set_click_event(item_click_fun)
            self.panel_result:addChild( self.slot_t[i].view )
            self.slot_t[i].view:setScale(0.2)
            -- 添加动态
            local scale_1 = CCScaleTo:actionWithDuration(0.2, 1.2)
            local scale_2 = CCScaleTo:actionWithDuration(0.1, 1.0)
            local act_scale  = CCArray:array()
            act_scale:addObject(scale_1)
            act_scale:addObject(scale_2)
            local seq_scale = CCSequence:actionsWithArray(act_scale)
            self.slot_t[i].view:runAction( seq_scale)
        end
    end
end

function BeautyCardResultWin:active( show )
    if show then
    end
end



function BeautyCardResultWin:destroy()
    Window.destroy(self)
end
