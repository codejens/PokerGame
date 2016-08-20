-- FubenActivityPage.lua  
-- created by lyl on 2013-2-20
-- 副本活动页  

super_class.FubenActivityPage(Window)

-- 副本图标尺寸
local icon_width = 102
local icon_height = 112
-- 副本图标间隔
local icon_space_x = 54+14
local icon_space_y = 22-8
-- 每行显示的图标个数
local icon_count_per_line = 4
-- 建议等级坐标
local sugLv_x = 60
local sugLv_y = 38
-- 页面期望宽度
local exp_width = 743

-- ui param
local panel_w = 860
local panel_h = 500
local panel_up_h = 330
local panel_bttm_h = 500-panel_up_h-6
local line_y = 70

local fb_item = UILH_ACTIVITY.minimap_list
-- local fb_item = 1

function FubenActivityPage:create(  )
	return FubenActivityPage( "FubenActivityPage", "", false, panel_w, panel_h )
end

function FubenActivityPage:__init( window_name, window_info )

    -- 副本item以及选中的item
    self._t_fb_item = {}
    self._t_fb_tipnum = {}
    self._index_sld = nil  -- 选择的index
    self._act_id_sld = nil -- 选择的部分id

    -- 外部调用时item上显示"荐"
    self._jian = nil

    -- 副本配置数据
    local fuben_list_data = ActivityModel:get_activity_info_by_class( "fuben" )
    self._fuben_list_data = fuben_list_data
    -- 上面板界面，副本列表
    self:create_up_panel()
    self:create_bttm_panel()

    self:slt_fb_item(1)
end

-- 上部面板 ===========================================
function FubenActivityPage:create_up_panel( )
    self.panel_up = CCBasePanel:panelWithFile(3, panel_bttm_h+6, panel_w-6, panel_up_h-15, UILH_COMMON.bottom_bg, 500, 500);
    self.view:addChild(self.panel_up);

    -- title(354, 44) & (75, 22)
    self.title_up = CCBasePanel:panelWithFile( 248, 286,  -1, -1, UILH_NORMAL.title_bg3 )
    local title_txt = CCZXImage:imageWithFile( (354-75)*0.5, (44-22)*0.5,-1, -1, UILH_ACTIVITY.fuben_activity )
    self.title_up:addChild( title_txt )

    self.panel_up:addChild( self.title_up )
    -- local title_txt = ZLabel:create(self.title_up, Lang.wanfadating[1], 178, 17, 16, 2)

    -- 创建 scrollview
    self:create_scroll_area(self.panel_up, 0, line_y+5, panel_w-10, panel_up_h-line_y-40, "", self._fuben_list_data )
    -- 分割线
    local line = CCZXImage:imageWithFile( 10, line_y, panel_w-25, 3, UILH_COMMON.split_line )
    self.panel_up:addChild(line)

    -- 道具提示
    ZLabel:create(self.panel_up, LH_COLOR[2] .. Lang.wanfadating[37], 15, 40, 16, 1, 1)
    ZLabel:create(self.panel_up, LH_COLOR[2] .. Lang.wanfadating[38], 15, 20, 16, 1, 1)
    -- 道具
    -- local item_t = ActivityModel:get_fuben_activity_award_items( self._fuben_list_data[1].id )
    -- if #item_t > 0 then
    --     self.award_item_list = self:create_item_scroll( item_t , 225, 10, 55, 55, 3, "")
    --     self.panel_up:addChild( self.award_item_list )
    -- end
end

-- 创建可拖动区域                  
function FubenActivityPage:create_scroll_area( panel , pos_x, pos_y, size_w, size_h, bg_name, list_date)
    -- ui param
    local row_h = 90 
    local row_w = 135
    local row_inter_h = 15
    local row_num = 6
    local item_num = #list_date --self.fuben_config
    local line_num = math.ceil(item_num/row_num)
    local panel_scr_h = row_h*line_num+row_inter_h*line_num

    --总行数，每列的最大值
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = 1, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype, 500, 500 )
    scroll:setEnableScroll(false)
    -- scroll:setScrollLump(UIResourcePath.FileLocate.common .. "common_progress.png", UIResourcePath.FileLocate.common .. "input_frame_bg.png", 10, 40, 42)
    --scroll:setEnableCut(true)
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1
            local panel_items = CCBasePanel:panelWithFile( 0, 0, panel_w-10, panel_scr_h, "" )
            scroll:addItem(panel_items)

            for i=1, item_num do
                local num_y = math.ceil(i/row_num)
                local num_x = math.mod(i,row_num)
                if num_x == 0 then
                    num_x = row_num
                end
                self:create_fb_item( panel_items, 6+(num_x-1)*(row_w+5), panel_scr_h - num_y*(row_h+row_inter_h), row_w, row_h, i , list_date[i])
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    panel:addChild( scroll )

    return scroll
end

-- 创建副本item -----------------
function FubenActivityPage:create_fb_item( panel, x, y, w, h, index, item_data )
    local fb_item = {}
    -- 背景框
    local fb_item_gb = CCBasePanel:panelWithFile( x, y, w, h, "ui2/login/lh_ser_bg.png", 500, 500 )
    panel:addChild( fb_item_gb )
    fb_item.bg = fb_item_gb

    -- 地图
    local lttl_map = CCBasePanel:panelWithFile( 11, 11, 110, 68, fb_item[index] )
    fb_item_gb:addChild(lttl_map)
    fb_item.lttl_map = lttl_map

    -- 标志
    -- fb_item.item_sign = CCZXImage:imageWithFile( 3, 93, -1, -1, UILH_ACTIVITY.un_start )
    -- fb_item.item_sign:setAnchorPoint(0, 1)
    -- fb_item.bg:addChild( fb_item.item_sign )

    -- 副本名字背景
    fb_item.name_bg = CCBasePanel:panelWithFile( 10, 10, -1, -1, UILH_ACTIVITY.font_bg) -- 114， 22
    fb_item.bg:addChild( fb_item.name_bg )

    -- 副本名字
    fb_item.name = ZLabel:create(fb_item.name_bg, LH_COLOR[1] .. item_data.location.entityName, 114*0.5, 5, 14, 2)

    -- 选中标志
    fb_item.frame_sld = CCZXImage:imageWithFile( -3, -3, w+6, h+6, UILH_COMMON.slot_focus, 500, 500 )
    fb_item.bg:addChild(fb_item.frame_sld)
    fb_item.frame_sld:setIsVisible(false)

    fb_item.lock = CCZXImage:imageWithFile( 19, 0, -1, -1, UILH_ACTIVITY.lock_link )
    fb_item.bg:addChild(fb_item.lock)
    fb_item.lock:setIsVisible(false)

    -- 副本item事件 ------------------------------------------------------
    local function fb_item_func(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            Instruction:handleUIComponentClick(instruct_comps.FUBEN_CHALLENGE_BASE + index)
            self:slt_fb_item( index )
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    fb_item.bg:registerScriptHandler( fb_item_func )  --注册 -------------

    self._t_fb_item[index] = fb_item
    -- 密宗佛塔
    -- if item_data.id == 110 then
    --     fb_item.bg:setIsVisible(false)
    -- end
    return fb_item
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function FubenActivityPage:create_item_scroll( panel_table_para , pos_x, pos_y, item_w, item_h, item_inter, img_bg)
    require "UI/activity/ActivityCommon"
    local item_panel = ActivityCommon:create_item_horizontal(panel_table_para, pos_x, pos_y, item_w, item_h, item_inter, img_bg)
    return item_panel
end

-- 底部列表 ===========================================
function FubenActivityPage:create_bttm_panel(  )
    self.panel_bttm = CCBasePanel:panelWithFile(3, 3, panel_w-6, panel_bttm_h, UILH_COMMON.bottom_bg, 500, 500);
    self.view:addChild(self.panel_bttm);

    -- 分割线
    local line = CCZXImage:imageWithFile( (panel_w-20)*0.5, 5, 3, 155, UILH_COMMON.split_line_v )
    self.panel_bttm:addChild(line)

    -- 左边title -------------- 149, 31
    self.title_left = CCBasePanel:panelWithFile( 0, 130, 425, -1, UILH_NORMAL.title_bg4, 500, 500 )
    self.panel_bttm:addChild( self.title_left )
    local title_txt_left = ZLabel:create(self.title_left, Lang.wanfadating[5], 425*0.5, (31-16)*0.5, 16, 2)

    -- 活动介绍
    self.act_desc = CCDialogEx:dialogWithFile( 15, 130, 380, 75, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.act_desc:setAnchorPoint(0,1);
    self.act_desc:setFontSize(16);
    self.act_desc:setText( "我是介绍" );  -- "#cffff00当前效果:#cffffff:"
    self.act_desc:setTag(0)
    self.act_desc:setLineEmptySpace (5)
    self.panel_bttm:addChild(self.act_desc)

    -- 是否自动购买材料勾选按钮
    self.transmit_but = UIButton:create_switch_button(10, 10, 150, 44, 
        UILH_COMMON.dg_sel_1, 
        UILH_COMMON.dg_sel_2, 
        Lang.wanfadating[6], 40, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    self.panel_bttm:addChild(self.transmit_but.view, 2);

    -- ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "", 50, 22, 16, 1, 1)
    self.trans_item = ZLabel:create(self.panel_bttm, LH_COLOR[15] .. "(小飞鞋剩余5个)", 170, 22, 16, 1, 1)

    -- 右边title --------------
    self.title_right = CCBasePanel:panelWithFile( 430, 130, 425, -1, UILH_NORMAL.title_bg4, 500, 500 )
    self.panel_bttm:addChild( self.title_right )
    local title_txt_right = ZLabel:create(self.title_right, Lang.wanfadating[7], 425*0.5, (31-16)*0.5, 16, 2)

    -- 经验 & 道具 & 剩余次数
    -- self.star_name_1 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "经验：", 445, 105, 14, 1, 1)
    -- self.star_name_2 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "道具：", 445, 77, 14, 1, 1)
    -- -- -- 经验5颗星
    -- self.exp_star = CCBasePanel:panelWithFile(495, 93, 185, 45, "")
    -- self.panel_bttm:addChild( self.exp_star )
    -- MUtils:drawStart3(self.exp_star, 5)
    -- -- 道具5颗星
    -- self.exp_star = CCBasePanel:panelWithFile(495, 60, 185, 45, "")
    -- self.panel_bttm:addChild( self.exp_star )
    -- MUtils:drawStart3(self.exp_star, 5)

    -- 星星 第一列
    self.star_name_1   = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[8], 445, 105, 14, 1, 1)
    self.star_range_1  = MUtils:create_star_range( self.panel_bttm, 495, 100, 25, 25, 4 ) 
    self.star_range_1.change_star_interval( 10 )

    -- 星星 第二列
    self.star_name_2 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[9], 445, 77, 14, 1, 1)
    self.star_range_2  = MUtils:create_star_range( self.panel_bttm, 495, 70, 25, 25, 5 ) 
    self.star_range_2.change_star_interval( 10 )


    -- 剩余次数
    ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[10], 680, 60, 14, 1, 1)
    self.go_num = ZLabel:create(self.panel_bttm, LH_COLOR[15] .. "0/3", 765, 60, 14, 1, 1)

    -- btn 委托 & 前往副本
    local function entrust_func()
        if self._act_id_sld then
            ActivityModel:open_fuben_entrust( self._act_id_sld )
        end
    end
    self.btn_entrust = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[11], UILH_COMMON.btn4_nor, 
        entrust_func, 490, 3, -1, -1)

    --前往副本
     local function goto_func()
        Instruction:handleUIComponentClick(instruct_comps.TIAOZHANG )
        Analyze:parse_click_main_menu_info(280+self._index_sld)
        local item_data = self._fuben_list_data[self._index_sld]
        -- if self._index_sld == 8 or self._index_sld == 9 or self._index_sld == 10 then
        --     GlobalFunc:create_screen_notic("未开启")
        --     return 
        -- end

        -- #1
        -- GameLogicCC:req_talk_to_npc( 0, string.format("OnEnterFubenFunc, %d",item_data.FBID ))
        -- #2
        local if_transmit = self.transmit_but.if_selected     -- 是否选择了传送
        ActivityModel:go_to_activity( item_data.location.sceneid, item_data.location.entityName, if_transmit )
    end
    self.btn_goto = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[12], UILH_COMMON.btn4_nor, 
        goto_func, 680, 3, -1, -1)
end

-- =====================================================================================================================
-- 更新 数据
-- =====================================================================================================================
function FubenActivityPage:update( update_type )
    if update_type == "all" then
        self:update_fuben_status()
        -- 请求各个副本次数
        ActivityModel:request_enter_fuben_times()
    elseif update_type == "fuben_times" then
        self:update_time()
    end
end

-- 更新各个副本item的状态
function FubenActivityPage:update_fuben_status()
    for i=1,#self._t_fb_item do
        -- if i ~= self._fb_item_sld then
            local require_level = self._fuben_list_data[i].level
            local player_level = EntityManager:get_player_avatar().level
            if player_level<require_level then
                -- self._t_fb_item[i].times_bg:setIsVisible(false)
                -- self._t_fb_item[i].view:setCurState(CLICK_STATE_DISABLE)
                -- self._t_fb_item[i].item_sign:setIsVisible(false)
                self._t_fb_item[i].name_bg:setIsVisible(false)
                self._t_fb_item[i].lttl_map:setTexture( fb_item[i] )
                self._t_fb_item[i].lock:setIsVisible(true)
            else
                -- self._t_fb_item[i].times_bg:setIsVisible(true)
                -- self._t_fb_item[i].view:setCurState(CLICK_STATE_UP)
                -- self._t_fb_item[i].item_sign:setIsVisible(true)

                -- 暂时屏蔽
                -- if i == 8 or i == 9 or i == 10 then
                --     self._t_fb_item[i].name_bg:setIsVisible(false)
                --     self._t_fb_item[i].lttl_map:setTexture( fb_item[i] )
                --     self._t_fb_item[i].lock:setIsVisible(true)
                -- else

                    self._t_fb_item[i].name_bg:setIsVisible(true)
                    self._t_fb_item[i].lttl_map:setTexture( fb_item[i] )
                    self._t_fb_item[i].lock:setIsVisible(false)

                    -- 增加角标提示（副本剩余次数）
                    local enter_times, max_times, extra_award = ActivityModel:get_enter_fuben_count( self._fuben_list_data[i].FBID ) 

                    self:create_num_tip( self._t_fb_item[i].bg, enter_times, i)
                -- end
            end 
            -- self._t_fb_item[i].frame_sld:setIsVisible(false)
        -- else
            -- self._t_fb_item[i].frame_sld:setIsVisible(true)
        -- end 
    end
end

-- 创建数字提示
function FubenActivityPage:create_num_tip( panel, num, index )
    if self._t_fb_tipnum[index] then
        self._t_fb_tipnum[index]:removeFromParentAndCleanup(true)
        self._t_fb_tipnum[index] = nil
    end
    self._t_fb_tipnum[index] = CCBasePanel:panelWithFile(95, 50, -1, -1, UILH_MAIN.remain_bg)
    panel:addChild( self._t_fb_tipnum[index])
    -- 战斗力value
    local num_tip = ZXLabelAtlas:createWithString( num, "ui/lh_other/tip_num_" )
    num_tip:setPosition(CCPointMake( 14, 12))
    num_tip:setAnchorPoint( CCPointMake(0, 0) )
    self._t_fb_tipnum[index]:addChild( num_tip )
end

-- 副本选择
-- index: 第几个item
-- jian : 是否外部推荐
function FubenActivityPage:slt_fb_item( index, jian )
    self._act_id_sld = self._fuben_list_data[index].id
    self._index_sld = index
    for i=1, #self._t_fb_item do
        self._t_fb_item[i].frame_sld:setIsVisible(false)
    end
    self._t_fb_item[index].frame_sld:setIsVisible(true)
    self:update_introduce( self._act_id_sld ) 
    self:update_award( self._act_id_sld )
    self:update_time( self._act_id_sld )
    self:update_cloud_num()

    if jian then
        if self._jian then
            self._jian:removeFromParentAndCleanup(true)
            self._jian = nil
        end
        self._jian = CCBasePanel:panelWithFile( 60, 55, -1, -1, UILH_THEHELPER.jian )
        self._t_fb_item[index].bg:addChild(self._jian)
    end
end

-- 更新介绍
function FubenActivityPage:update_introduce( activity_id )
    local activity_introduce = ActivityModel:get_activity_introduce_by_id( activity_id )
    self.act_desc:setText( "" )
    self.act_desc:setText( activity_introduce )
end

-- 更新副本奖励
function FubenActivityPage:update_award( activity_id )
    -- 星星
    local stars_info_ret_t = ActivityModel:get_activity_star( activity_id )
    if stars_info_ret_t[1] then
        self.star_name_1:setText( LH_COLOR[2] ..stars_info_ret_t[1].name .. ": " )
        self.star_range_1.change_star_num( stars_info_ret_t[1].num )
    else
        self.star_name_1:setText("")
        self.star_range_1.change_star_num( 0 )
    end
    if stars_info_ret_t[2] then
        self.star_name_2:setText( LH_COLOR[2] .. stars_info_ret_t[2].name .. ": " )
        self.star_range_2.change_star_num( stars_info_ret_t[2].num )
    else
        self.star_name_2:setText("")
        self.star_range_2.change_star_num( 0 )
    end

    self.panel_up:removeChild( self.award_item_list, true)
    -- 道具
    local item_t = ActivityModel:get_fuben_activity_award_items( activity_id )
    
    if #item_t > 0 then
        self.award_item_list = self:create_item_scroll( item_t , 225-60, 3, 55, 55, 7, "")
        self.panel_up:addChild( self.award_item_list )
    end
end

-- 更新次数 
function FubenActivityPage:update_time( activity_id )
    local enter_times, max_times, extra_award = ActivityModel:get_enter_fuben_count( self._fuben_list_data[self._index_sld].FBID ) 
    -- print("更新所有副本的进入次数", activity_id, enter_times, max_times, extra_award )
    self.go_num:setText( string.format("%d/%d", enter_times, max_times) )
end

-- 更新筋斗云个数
function FubenActivityPage:update_cloud_num(  )
    local cloud_num = ActivityModel:get_cloud_num(  )
    -- self.transmit_but.setString( LangGameString[545]..cloud_num..LangGameString[546] ) -- [545]="自动传送(筋斗云剩余" -- [546]="个)"
    self.trans_item:setText( Lang.wanfadating[13] .. cloud_num .. Lang.wanfadating[14] )
end

function FubenActivityPage:update_selected( activity_id )

end

--更新 锁定标志的显示
function FubenActivityPage:update_locks(  )

end

-- 更新活动图标上的提示剩余次数的标志
function FubenActivityPage:update_tips_count()

end

function FubenActivityPage:destroy()
    for i=1, #self._t_fb_item do
        if self._t_fb_item[i].refresh_time then
            self._t_fb_item[i].refresh_time:destroy()
            self._t_fb_item[i].refresh_time = nil
        end
    end
    Window.destroy(self)
end
