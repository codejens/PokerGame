-- FriendsDrawWin
-- create by chj 
-- 消费返回活动
super_class.FriendsDrawWin(NormalStyleWindow);

local panel_w = 882
local panel_h = 560
local panel_in_h = 530
local panel_left_w = 425
local panel_right_w = 425
local panel_scroll_h = 140

local font_size = 16

--构造函数
function FriendsDrawWin:__init( window_name, window_info )
    self.btn_table = {}  --保存的按钮
    self.btn_txt_table = {}
    self.panel = ZBasePanel:create( self.view,UILH_COMMON.normal_bg_v2 , 10, 10, panel_w, panel_h, 600, 600)

    -- 距离第二天倒计时
    self.timer_label_day = nil

    -- 抽奖是控制状态为
    self.is_drawing = false

    -- 创建左右面板
    self:create_panel_left()
    self:create_panel_right()
end

-- =============================
-- 创建左面板
-- =============================
function FriendsDrawWin:create_panel_left()
    self.panel_left = ZBasePanel:create(self.panel, UILH_COMMON.bottom_bg, 15, 15, panel_left_w, panel_in_h, nil, 500, 500)

    -- 活动倒计时 & TimerLabel
    ZLabel:create( self.panel_left, LH_COLOR[2] .. Lang.f_draw[1], 20, 505, font_size, ALIGN_LEFT)
    local time_remain = FriendsDrawModel:get_activity_time()
    if time_remain == 0 then
        ZLabel:create( self.panel_left, LH_COLOR[6] .. Lang.f_draw[2], 175, 505, font_size, ALIGN_LEFT )
    else
        local function end_call_func()
            ZLabel:create( self.panel_left, LH_COLOR[6] .. Lang.f_draw[2], 175, 505, font_size, ALIGN_LEFT )
        end
        self.timer_label = TimerLabel:create_label( self.panel_left, 175, 505, 16, time_remain, LH_COLOR[6], end_call_func )
    end


    -- 每天抽奖次数
    ZLabel:create( self.panel_left, LH_COLOR[6] .. Lang.f_draw[3], 20, 480, font_size, ALIGN_LEFT )
    ZLabel:create( self.panel_left, LH_COLOR[6] .. Lang.f_draw[4], 345, 480, font_size, ALIGN_RIGHT )
    self.num_drawn = ZLabel:create( self.panel_left, LH_COLOR[6] .. Lang.f_draw[5], 355, 480, font_size, ALIGN_LEFT )

    -- 抽奖奖品栏(道具)
    local function draw_end_func(num_sld)
        self.is_drawing = false
        local item_effect_table = {}
        item_effect_table[1] = 1
        item_effect_table[2] = FriendsDrawModel:get_id_by_index( num_sld )
        item_effect_table[3] = 1
        LuaEffectManager:play_get_items_effect( item_effect_table )
    end
    local item_data = { num_all= 16, num_row = 4, item_conf = {} }
    item_data.item_conf = FriendsDrawModel:get_item_conf()
    self.panel_draw = FriendsDrawPage:create(self.panel_left, item_data, draw_end_func, 50, 160, 320, 320, "")

    -- 提示((?)每天抽次抽奖不消耗次数)
    local function help_btn_callback( ... )
        -- print("help_btn click")
        HelpPanel:show( 3, UILH_CALLFRIEND.cf_title_draw_intro, LH_COLOR[2] .. Lang.f_draw[6].."#r" .. LH_COLOR[2] .. Lang.f_draw[7].."#r" .. LH_COLOR[2] .. Lang.f_draw[8], 18 )
    end
    self.help_btn = ZButton:create(self.panel_left, UILH_NORMAL.wenhao, help_btn_callback, 20, 130, -1, -1)
    -- ZLabel:create( self.panel_left, "每天抽次抽奖不消耗次数", 60, 140, font_size, ALIGN_LEFT )
    self.evety_img = ZBasePanel:create(self.panel_left, UILH_CALLFRIEND.cf_every_day, 60, 138, -1, -1 )
    self.evety_img.view:setScale(0.8)


    -- 首抽的状态
    self.free_draw_state = CCBasePanel:panelWithFile( 298, 134, -1, -1, UILH_CALLFRIEND.cf_draw_free_d)
    self.panel_left:addChild(self.free_draw_state)

    -- 3个btn(抽奖&赠送次数)
    -- 抽奖
    local function btn_draw_func()
        -- self.panel_draw:set_sld_item_roll(15, 2)
        Instruction:handleUIComponentClick(instruct_comps.FRIENDS_MIYOU_AWARD2)
        if self.is_drawing == false then
            FriendsDrawModel:req_friend_draw( )
        else
            GlobalFunc:create_screen_notic( Lang.FriendsDraw[1])
        end
    end
    self.btn_draw = ZButton:create(self.panel_left, UILH_CALLFRIEND.cf_btn, btn_draw_func, 50, 41, 85, 85)
    self.btn_draw_txt = CCBasePanel:panelWithFile(5, 35, -1, -1, UILH_CALLFRIEND.cf_draw)
    self.btn_draw.view:addChild(self.btn_draw_txt)
    ZLabel:create( self.panel_left, LH_COLOR[2] .. Lang.f_draw[9], 125, 20, font_size, ALIGN_RIGHT )
    self.num_draw_remain = ZLabel:create( self.panel_left, LH_COLOR[2] .."0", 128, 20, font_size, ALIGN_LEFT )

    -- 索要次数
    local function btn_draw_func()
        -- require "UI/component/AlertWin"
        -- local panel_tip = CCBasePanel:panelWithFile( 20, 20, -1, -1,  )
        -- AlertWin:show_new_alert( panel_tip )
        -- ConfirmWin2:show( 10, 2, "",  confirm2_func, nil, nil, UILH_CALLFRIEND.cf_getnum_intro)
        ConfirmWin2:show( 99, 0, LH_COLOR[2] .. Lang.FriendsDraw[2])
    end
    self.btn_get_num = ZButton:create(self.panel_left, UILH_CALLFRIEND.cf_btn, btn_draw_func, 167, 41, 85, 85)
    self.btn_get_num_txt = CCBasePanel:panelWithFile(5, 35, -1, -1, UILH_CALLFRIEND.cf_getnum)
    self.btn_get_num.view:addChild(self.btn_get_num_txt)

    -- 赠送次数
    local function btn_send_func()
        print("--赠送")
        local function confirm_fun( txt )
            FriendsDrawModel:req_send_draw_chance( txt )
        end
        InputDialog:show(confirm_fun, UILH_CALLFRIEND.cf_num_send, LH_COLOR[2] .. Lang.f_draw[10] );
    end
    self.btn_send = ZButton:create(self.panel_left, UILH_CALLFRIEND.cf_btn, btn_send_func, 280, 41, 85, 85)
    self.btn_send_txt = CCBasePanel:panelWithFile(5, 35, -1, -1, UILH_CALLFRIEND.cf_draw_intro)
    self.btn_send.view:addChild(self.btn_send_txt)
    ZLabel:create( self.panel_left, LH_COLOR[2] .. Lang.f_draw[11], 320, 20, font_size, ALIGN_CENTER )
end

-- ========================
-- 创建右面板
-- ========================
function FriendsDrawWin:create_panel_right() 
    self.panel_right = ZBasePanel:create(self.panel, UILH_COMMON.bottom_bg, 440, 15, panel_left_w, panel_in_h, nil, 500, 500)

    -- 参与抽奖有机会活动~~
    ZBasePanel:create(self.panel_right, UILH_CALLFRIEND.cf_partner, 80, 490, -1, -1 )
    -- ZLabel:create( self.panel_right, LH_COLOR[1] .. "参与抽奖有机会获得至尊伙伴", 20, 480, font_size, ALIGN_LEFT)

    --伙伴模型展示
    local pet_file = string.format("scene/monster/%d", 1300);
    local action = {0,0,9,0.2};
    self.spr = MUtils:create_animation(200,375,pet_file,action )
    self.panel_right:addChild( self.spr,1 );


    -- 连续七天
    ZBasePanel:create(self.panel_right, UILH_CALLFRIEND.cf_large_gift, 80, 315, -1, -1 )
    -- ZLabel:create( self.panel_right, LH_COLOR[1] .. "连续七天收到同一密友赠送更可获得密友大礼包", 20, 350, font_size, ALIGN_LEFT)

    -- 4个item
    self.panel_item_4 = CCBasePanel:panelWithFile(25, 235, 400, 70, "")
    self.panel_right:addChild(self.panel_item_4)
    self.slot_item_t = {}
    local gift_conf = FriendsDrawModel:get_gift_conf( )
    for i=1, 4 do
        self.slot_item_t[i] = SlotItem( 60, 60 )
        self.slot_item_t[i]:setPosition( 35+85*(i-1), 10 )
        self.slot_item_t[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -10, -10, 83, 83 )
        self.slot_item_t[i]:set_color_frame(gift_conf[i].itemid, -1, -1, 65, 65)
        self.slot_item_t[i]:set_icon( gift_conf[i].itemid )
        self.slot_item_t[i]:set_item_count( gift_conf[i].count )
        self.panel_item_4:addChild(self.slot_item_t[i].view)

        local function item_tips_fun(...)
            local a, b, arg = ...
            local click_pos = Utils:Split(arg, ":")
            local world_pos = self.slot_item_t[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
            if gift_conf[i].itemid ~= 0 then
                TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, gift_conf[i].itemid )
            else
                local temp_data = { item_id = 1, item_count = gift_conf[i].count }
                TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
            end
        end
        self.slot_item_t[i]:set_click_event(item_tips_fun)
    end

    -- 可领取礼包数
    ZLabel:create( self.panel_right, LH_COLOR[2] .. Lang.f_draw[12], 150, 190, font_size, ALIGN_RIGHT )
    self.num_gift =  ZLabel:create( self.panel_right, LH_COLOR[2] .. "0", 153, 190, font_size, ALIGN_LEFT )

    -- 领取按钮
    local function get_award_func( )
       FriendsDrawModel:req_get_gift()
    end
    self._right_bgn_role = ZTextButton:create( self.panel_right, "", UILH_NORMAL.special_btn, get_award_func, 225, 175, -1, -1, 1)
    self._gift_get_txt = CCBasePanel:panelWithFile(39, 14, -1, -1, UILH_ACHIEVE.reward)
    self._right_bgn_role.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    self._right_bgn_role.view:addTexWithFile(CLICK_STATE_UP, UILH_NORMAL.special_btn)
    self._right_bgn_role.view:setCurState(CLICK_STATE_DISABLE)
    self._right_bgn_role.view:addChild(self._gift_get_txt)
    ZLabel:create( self.panel_right,  LH_COLOR[2] .. Lang.f_draw[13], 300, 160, font_size, ALIGN_CENTER )

    -- 获赠名单
    -- self:create_send_order( order_gift );
        -- base Panel
    self.panel_base = CCBasePanel:panelWithFile( 10, 10, panel_right_w-20, panel_scroll_h, UILH_COMMON.bg_11, 500, 500 );
    self.panel_right:addChild( self.panel_base )

    -- title
    self.title_order = CCBasePanel:panelWithFile( 0, panel_scroll_h-33, panel_right_w-20, 30, UILH_NORMAL.title_bg4 )
    self.panel_base:addChild(self.title_order)
    ZLabel:create(self.title_order, LH_COLOR[2] .. Lang.f_draw[14], (panel_right_w-20)*0.5, 10, font_size, ALIGN_CENTER)

    -- 名字title,次数title
    self.panel_title_in = CCBasePanel:panelWithFile(5, panel_scroll_h-60, panel_right_w-20, 25, "" )
    self.panel_base:addChild(self.panel_title_in)
    ZLabel:create(self.panel_title_in, Lang.f_draw[15], 354*0.5, 8, font_size, ALIGN_CENTER)
end

-- =============================
-- 获赠名单 scroll
-- =============================
function FriendsDrawWin:create_send_order(order_gift)
    -- 如果没有记录，下面的scroll不执行
    if not order_gift or #order_gift == 0 then
        return
    end

    -- 如果主面板有记录，清除
    if self.scroll_order then
        self.scroll_order:removeFromParentAndCleanup(true)
        self.scroll_order = nil
    end

    -- 记录列表
    local row_num = #order_gift
    local _scroll_info = { x = 10, y = 15, width = panel_right_w-20, height = panel_scroll_h-60 , maxnum = row_num, 
                        image = "", stype= TYPE_HORIZONTAL }
    self.scroll_order = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, 
            _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    -- self.scroll_order:setScrollLump( UIResourcePath.FileLocate.common .. "common_progress.png", UIResourcePath.FileLocate.common .. "input_frame_bg.png", 8, 50, 72)
    
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = tonumber(temparg[1])+1  --行数
        if row == nil then 
            return false;
        end
        if eventType == SCROLL_CREATE_ITEM then
            local cell = self:create_scroll_item( row, order_gift );
            self.scroll_order:addItem(cell)
            self.scroll_order:refresh()
        end
        return true
    end
    
    self.scroll_order:registerScriptHandler(scrollfun)
    self.scroll_order:refresh()
    self.panel_right:addChild(self.scroll_order);
end

-- scroll_view
function FriendsDrawWin:create_scroll_item( index, order_gift )
    local panel_item = CCBasePanel:panelWithFile(5, 0, panel_right_w-20, 25, "" )

    -- 序号
    local index_lab = ZLabel:create( panel_item, LH_COLOR[2] .. index, 20, 5, font_size, ALIGN_LEFT )
    -- 名字
    local name_lab = ZLabel:create( panel_item, LH_COLOR[2] .. order_gift[index].name, 70, 5, font_size, ALIGN_LEFT )

    -- 数字
    local num_lab = ZLabel:create( panel_item, LH_COLOR[2] .. order_gift[index].num_get, 285, 5, font_size, ALIGN_CENTER )

    -- 分割线
    -- local split_line = CCZXImage:imageWithFile( 20, 0, panel_right_w-60, 3, UILH_COMMON.split_line )
    -- panel_item:addChild(split_line)
    return panel_item
end

-- =============================================
function FriendsDrawWin:update( update_type)
    if update_type == "main" then
        local dataModel = FriendsDrawModel:get_data_model()
        self:update_main_data( dataModel )
    elseif update_type == "draw" then
        local dataModel = FriendsDrawModel:get_data_model()
        self:update_draw_result( dataModel )
    elseif update_type == "order" then
        local order_gift = FriendsDrawModel:get_order_gift()
        self:update_order_gift( order_gift )
    end
end

-- 更新主面板信息
function FriendsDrawWin:update_main_data( dataModel )
    self.num_draw_remain:setText( dataModel.num_draw )
    if dataModel.num_draw_free == 1 then
        self.free_draw_state:setTexture(UILH_CALLFRIEND.cf_draw_free)
    elseif dataModel.num_draw_free == 0 then
        self.free_draw_state:setTexture(UILH_CALLFRIEND.cf_draw_free_d)
        if not self.timer_label_day then
            local time_tomorrow = FriendsDrawModel:get_time_away_tomorrow( )
            self.timer_label_day = TimerLabel:create_label( self.panel_left, 340, 147, 12, time_tomorrow, LH_COLOR[6], nil, true )
        end
    end
    self.num_gift:setText(dataModel.num_gift)
    self.num_drawn:setText( LH_COLOR[6] .. dataModel.num_drawn .. "/5")
    if dataModel.num_gift == 0 then
        self._right_bgn_role:setCurState(CLICK_STATE_DISABLE)
    else
        self._right_bgn_role:setCurState(CLICK_STATE_UP)
    end
end

-- 显示抽奖结构
function FriendsDrawWin:update_draw_result( dataModel )
    -- 跳2圈后定位数字
    if not dataModel.result_item_index or dataModel.result_item_index == 0 then
        print(Lang.f_draw[16])
        GlobalFunc:create_screen_notic( Lang.f_draw[17] );
    else
        -- 随机，判断一圈后，还是2圈后
        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        local num_row_temp = 1
        local num_1 = math.random( 1, 100 )
        local num_2 = math.random( 1, 100 )
        local num_3 = math.random( 1, 100 )
        local num_rand = math.random( 1, 100 )
        if num_rand < 50 then
            num_row_temp = 1
        else
            num_row_temp = 2
        end
        self.is_drawing = true
        self.panel_draw:set_sld_item_roll(dataModel.result_item_index, num_row_temp)
    end
end

-- 更新好友赠送(给我次数)记录
function FriendsDrawWin:update_order_gift( order_gift )
    -- if #order_gift == 0 then
    --     return 
    -- end
    self:create_send_order( order_gift )
end

-- 当界面被UIManager:show_window, hide_window的时候调用
function FriendsDrawWin:active(show)
	if show then
        self.is_drawing = false
        FriendsDrawModel:req_main_info()
	end
end

--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function FriendsDrawWin:destroy()
    if self.timer_label_day then
        self.timer_label_day:destroy()
        self.timer_label_day = nil
    end
    if self.timer_label then
        self.timer_label:destroy()
        self.timer_label = nil
    end
    if self.panel_draw then
        self.panel_draw:destroy()
        self.panel_draw = nil
    end
	Window.destroy(self);
end
