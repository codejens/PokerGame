-- SeriesChongZhiWin.lua
-- created by chj on 2015-3-10
-- 连续充值

super_class.SeriesChongZhiWin(NormalStyleWindow)

local font_size = 16

function SeriesChongZhiWin:__init( window_name, texture_name )


	-- 大背景 =============================
	self.panel_bg = CCBasePanel:panelWithFile( 10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( self.panel_bg)

    -- UP =================================
    ZLabel:create( self.panel_bg, LH_COLOR[2] .. "在活动期间，玩家连续充值3天，5天，7天，可领取丰富的奖励。", 30, 515, 16, ALIGN_LEFT, 1)
    ZLabel:create( self.panel_bg, LH_COLOR[6] .. "活动时间：", 30, 490, 16, ALIGN_LEFT, 1)
    local time_str = SeriesChongZhiModel:get_acti_time()
    ZLabel:create( self.panel_bg, LH_COLOR[6] .. time_str, 120, 490, 16, ALIGN_LEFT, 1)
    -- 获取说明
    --疑问按钮
    local function question_btn_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            HelpPanel:show( 3, UILH_NORMAL.title_tips, Lang.series_cz.shuoming )
        end
    end
    self.shuoming = CCBasePanel:panelWithFile( 690, 485, -1, -1, UILH_NORMAL.wenhao)
    self.panel_bg:addChild( self.shuoming)
    self.shuoming:registerScriptHandler(question_btn_fun)
    self.explain = CCBasePanel:panelWithFile( 735, 495, -1, -1, UILH_NORMAL.explain)
    self.panel_bg:addChild( self.explain)
    self.explain:registerScriptHandler(question_btn_fun)

    -- CENTER ===================================
    -- 配置
    self.scz_conf = SeriesChongZhiModel:get_conf( )
    -- 面板table
    self.panel_child = {}
    -- 面板中的面板
    self.panel_child_child = {} 
    -- 道具table
    self.item_slot = {}
    -- 领取按钮table
    self.btn_get_t = {}
    for i=1, #self.scz_conf do
        self:create_panel_day( self.scz_conf[i], i )
    end

    -- DOWN ===========================
    self.lab_cz = ZLabel:create( self.panel_bg, LH_COLOR[2] .. "已连续充值" .. 123 .. "天，累计充值金额 " .. 123 .. "元宝", 45, 70, 16, ALIGN_LEFT, 1)
    -- 活动剩余时间
    ZLabel:create( self.panel_bg, LH_COLOR[6] .. "活动剩余时间：", 45, 40, 16, ALIGN_LEFT, 1)
    local time_remain =  SeriesChongZhiModel:get_acti_remain_time()
    if time_remain == 0 then
        ZLabel:create( self.panel_bg, LH_COLOR[6] .. "活动已结束", 170, 40, 16, ALIGN_LEFT )
    else
        local function end_call_func()
            ZLabel:create( self.panel_bg, LH_COLOR[6] .. "活动已结束", 170, 40, 16, ALIGN_LEFT )
        end
        if self.timer_label then
            self.timer_label:destroy()
            self.timer_label = nil
        end
        self.timer_label = TimerLabel:create_label( self.panel_bg, 170, 40, 16, time_remain, LH_COLOR[6], end_call_func )
    end

    -- 立即充值按钮
    local function chongzhi_func( eventType)
        UIManager:show_window("pay_win")
    end
    self.btn_chongzhi = ZTextButton:create(self.panel_bg, LH_COLOR[2] .. "立即充值", UILH_COMMON.lh_button_4_r, chongzhi_func, 650, 20, -1, -1, 1)

end

-- 创建连续充值面板
function SeriesChongZhiWin:create_panel_day( data_t, i )
    -- 有连续充值面板背景
    self.panel_child[i] = CCBasePanel:panelWithFile( data_t.x, data_t.y, data_t.w, data_t.h, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_child[i])

    local title_bg = CCBasePanel:panelWithFile( 20, 325, 240, 40, UILH_NORMAL.title_bg_selected, 500, 500)
    self.panel_child[i]:addChild(title_bg)
    local num_str = self:num_to_chinese( data_t.num_day)
    ZLabel:create( title_bg, LH_COLOR[2] .. "连续充值" .. num_str .. "天", 240*0.5, 15, 16, ALIGN_CENTER, 1)

    -- 充值小面板
    self.panel_child_child[i] = {}
    self.item_slot[i] = {}
    self.btn_get_t[i] = {}

    self:create_cz_scroll( self.panel_child[i], data_t, i)
    -- for j=1, #data_t.item_conf do
    --     self:create_panel_day_ltt( self.panel_child[i], data_t.item_conf[j], i, j )
    -- end
end

-- 创建连续充值面板 中的scroll_view
function SeriesChongZhiWin:create_cz_scroll( panel, data_t, i )
    -- 技能个数（写成7个，屏蔽后面几个）
    -- local skill_num = WingConfig:getWingSkillNum( )
    local item_num = #data_t.item_conf
    -- scroll view 大小
    local _scr_info = { x = 10, y = 10, width = 255, height = 310, 
                    maxnum = 1, image = nil, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scr_info.x, _scr_info.y, _scr_info.width, 
                    _scr_info.height, _scr_info.maxnum, _scr_info.image, _scr_info.stype )
    panel:addChild( scroll )
    -- scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)
    -- scroll_view 里面的 panel
    local item_w = 255
    local item_h = 105

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 1行(此处创建只有一行)
            -- 一个item大面板，放入n个技能item
            local panel_all = CCBasePanel:panelWithFile( 0, 0, item_w, item_h*item_num, "" )
            for j=1, #data_t.item_conf do
                self:create_panel_day_ltt( panel_all, data_t.item_conf[j], i, j, item_h*item_num )
            end
            scroll:addItem(panel_all)
            scroll:refresh()

            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    -- 添加滚动条上下箭头
    -- local scrollbar_up = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_up,168,502,-1,-1)
    -- local scrollbar_down = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_down,168,2,-1,-1)
end


-- 创建连续充值面板中的小面板
function SeriesChongZhiWin:create_panel_day_ltt( panel, item_conf, i, j, h )
    self.panel_child_child[i][j] = CCBasePanel:panelWithFile( 5, h+5-105*j, 250, 100, UILH_COMMON.bg_11, 500, 500)
    panel:addChild( self.panel_child_child[i][j])

    -- desc
    ZLabel:create( self.panel_child_child[i][j], LH_COLOR[2] .. item_conf.yb, 95, 65, 16, ALIGN_LEFT, 1)

    -- item_slot
    self.item_slot[i][j] = SlotItem( 65, 65 )
    self.item_slot[i][j]:setPosition( 15, 15)
    self.item_slot[i][j]:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 83, 83 )
    self.item_slot[i][j]:set_color_frame( item_conf.item.id, -2, -2, 70, 70 )
    self.item_slot[i][j]:set_icon( item_conf.item.id )
    self.item_slot[i][j]:set_item_count(  item_conf.item.count )
    self.panel_child_child[i][j]:addChild( self.item_slot[i][j].view )

    local function item_tips_fun(...)
        local a, b, arg = ...
        local click_pos = Utils:Split(arg, ":")
        local world_pos = self.item_slot[i][j].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        if item_conf.item.id ~= 0 then
            TipsModel:show_shop_tip( world_pos.x/2, world_pos.y+130, item_conf.item.id )
        else
            local temp_data = { item_id = 1, item_count = item_conf.item.count }
            TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
        end
    end
    self.item_slot[i][j]:set_click_event(item_tips_fun)

    -- 领取按钮
    local function get_gift_func( )
        local num_day = self.scz_conf[i].num_day
        SeriesChongZhiModel:req_get_gift( num_day, j)
    end
    self.btn_get_t[i][j] = ZTextButton:create( self.panel_child_child[i][j], "领取奖励", UILH_COMMON.btn4_nor, get_gift_func, 105, 5, -1, -1, 1)
    self.btn_get_t[i][j]:addImage(CLICK_STATE_UP, UILH_COMMON.btn4_nor)
    self.btn_get_t[i][j]:addImage(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)

    return 
end

-- 更新数据： 参数：更新的类型
function SeriesChongZhiWin:update( update_type )
	if update_type == "init" then
        local data_t = SeriesChongZhiModel:get_data( )
        self.lab_cz.view:setText( LH_COLOR[2] .. "已连续充值" .. data_t.num_day .. "天，累计充值金额 " .. data_t.num_yb .. "元宝")

        -- 更新领取按钮状态
        for i=1, #self.btn_get_t do
            if self.btn_get_t[i] then
                for j=1, #self.btn_get_t[i] do
                    -- self.btn_get_t[i][j]:setCurState( CLICK_STATE_DISABLE)
                    self:setBtnState( self.btn_get_t[i][j], data_t.btn_state[i][j])
                end
            end
        end
	end
end

-- 设置按钮点击状态
function SeriesChongZhiWin:setBtnState( btn_view, state )
    if state == SeriesChongZhiModel.NOT_GET then
        btn_view.view:setCurState( CLICK_STATE_DISABLE)
        btn_view:setText( "领取奖励")
    elseif state == SeriesChongZhiModel.CAN_GET then
        btn_view.view:setCurState( CLICK_STATE_UP)
        btn_view:setText( "领取奖励")
    elseif state == SeriesChongZhiModel.ALD_GET then
        btn_view.view:setCurState( CLICK_STATE_DISABLE)
        btn_view:setText( "已领取")
    end
end

function SeriesChongZhiWin:active( show )
    if show then
        SeriesChongZhiModel:req_acti_info( )
    end
end

function SeriesChongZhiWin:destroy()
    if self.timer_label then
        self.timer_label:destroy()
        self.timer_label = nil
    end
    Window.destroy(self)
end



-- 数字转中文
function SeriesChongZhiWin:num_to_chinese( num)
    if num == 1 then
        return "一"
    elseif num == 2 then
        return "二"
    elseif num == 3 then
        return "三"
    elseif num == 4 then
        return "四"
    elseif num == 5 then
        return "五"
    elseif num == 6 then
        return "六"
    elseif num == 7 then
        return "七"
    elseif num == 8 then 
        return "八"
    elseif num == 9 then 
        return "九"
    end       
end
