-- BeautyCardWin.lua
-- created by chj on 2015-3-16
-- 昆仑神树窗口

require "UI/component/Window"
super_class.BeautyCardWin(NormalStyleWindow)

-- 黄金宝箱免费次数状态

-- 初始化
function BeautyCardWin:__init( window_name, texture_name )

	-- 大背景 =============================
	self.panel_bg = CCBasePanel:panelWithFile( 10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( self.panel_bg)

    -- 卡牌存储
    self.card_show = {}
    self.card_open = {}
end

function BeautyCardWin:create_card(index, x, y) 
    local card_info = BeautyCardConfig:get_card_info( index)

    local panel_card = CCBasePanel:panelWithFile( x, y, 284, 507+15, "")
    self.view:addChild(panel_card)

        -- touchPanel
    local panel_touch = CCTouchPanel:touchPanel( 0, 0, 284, 507)
    panel_card:addChild(panel_touch)

    self:create_card_open( panel_touch, index, x, y)
    self:create_card_show( panel_touch, index, x, y)

    -- title
    local panel_title = CCBasePanel:panelWithFile(-5, 444, -1, -1, UILH_BEAUTYCARD.bc_card_title)
    panel_card:addChild(panel_title)
    -- ZLabel:create( panel_title, LH_COLOR[2] .. card_info.name, 130, 15, 16, ALIGN_CENTER);
    local title_img = CCBasePanel:panelWithFile(103, 22, -1, -1, card_info.name)
    panel_title:addChild( title_img)
end

-- 创建卡牌展示界面
function BeautyCardWin:create_card_show( panel, index, x, y )
    local card_info = BeautyCardConfig:get_card_info( index)

    local panel_show = CCBasePanel:panelWithFile( 0, 20, 275, 490, UILH_BEAUTYCARD.bc_bg)
    panel:addChild( panel_show)
    self.card_show[index] = panel_show

    -- 活动时间
    if index == 3 then
        -- 活动倒计时 & TimerLabel
        ZLabel:create( panel_show, LH_COLOR[2] .. "活动时间", 150, 420, font_size, ALIGN_CENTER)
        local time_remain = BeautyCardModel:get_actvity_time()
        if time_remain == 0 then
            ZLabel:create( panel_show, LH_COLOR[6] .. "本活动已结束", 150, 400, font_size, ALIGN_CENTER )
        else
            local function end_call_func()
                ZLabel:create( panel_show, LH_COLOR[6] .. Lang.f_draw[2], 150, 400, font_size, ALIGN_CENTER )
            end
            self.timer_label = TimerLabel:create_label( panel_show, 150, 400, 16, time_remain, LH_COLOR[6], end_call_func, nil, ALIGN_CENTER )
        end

    end

    -- 免费倒计时（黄金宝箱有免费倒计时）
    if index == 2 then
        local time_t = BeautyCardModel:get_cd_times()
        if time_t[index] then
            print("-----time_t:", time_t[index])
            if time_t[index] ~= 0 then
                self.lab_gold_free = ZLabel:create( panel_show, LH_COLOR[2] .. "后免费", 150, 400, font_size, ALIGN_CENTER)
                local function end_call_func()
                    if self.lab_gold_free then
                        self.lab_gold_free:setText("拥有一次免费机会")
                        BeautyCardModel:set_gf_time( 0)
                    end
                end
                self.timer_gold_free = TimerLabel:create_label( panel_show, 150, 420, 16, time_t[index], LH_COLOR[6], end_call_func, nil, ALIGN_CENTER )
            else
                self.lab_gold_free = ZLabel:create( panel_show, LH_COLOR[2] .. "拥有一次免费机会", 150, 400, font_size, ALIGN_CENTER)
            end
        end
    end

    -- 宝箱
    if card_info.box_id then
        local box_img = CCBasePanel:panelWithFile( 53, 235, -1, -1, card_info.box_id)
        panel_show:addChild( box_img)
    end

    -- tip
    if card_info.label_1 then
        local tip_img = CCBasePanel:panelWithFile( 8, 165, -1, -1, card_info.label_1)
        panel_show:addChild( tip_img)
    end

    if card_info.item_ids then
        for i=1, #card_info.item_ids do
            local slot = SlotItem( 50, 50 )
            slot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -6, -6, 63, 63 )   -- 背框
            slot:set_icon( card_info.item_ids[1])
            slot:setPosition(43+(i-1)*72, 150 )
            slot:set_color_frame( card_info.item_ids[1], 0, 0, 50, 50 )    -- 边框颜色
            local function item_click_fun ()
                -- ActivityModel:show_mall_tips( panel_date.id )
                TipsModel:show_shop_tip( 200, 200, card_info.item_ids[1] )
            end
            slot:set_click_event(item_click_fun)
            panel_show:addChild( slot.view )
        end
    end

    -- 消费
    local panel_cost = CCBasePanel:panelWithFile(35, 100, 210, 45, UILH_BEAUTYCARD.bc_cost_bg, 100)
    panel_show:addChild(panel_cost)
    ZLabel:create( panel_cost, LH_COLOR[2] .. card_info.cost_type, 50, 14, 16, ALIGN_LEFT)
    ZLabel:create( panel_cost, LH_COLOR[2] .. card_info.cost_num, 115, 14, 16, ALIGN_LEFT)

    function check_func () 
        -- self.card_show[index]:setIsVisible(false)
        self.card_open[index]:setIsVisible(true)
        local move_to_1 = CCMoveTo:actionWithDuration( 0.2,CCPoint(0, 0) )
        local move_to_2 = CCMoveTo:actionWithDuration( 0.2,CCPoint(0, 507+20) )
        local act_up  = CCArray:array()
        act_up:addObject(move_to_1)
        act_up:addObject(move_to_2)
        local seq_up = CCSequence:actionsWithArray(act_up)
        self.card_show[index]:runAction(seq_up)
    end
    local btn_check = ZTextButton:create( panel_show, "查  看", UILH_COMMON.btn4_nor, check_func, 80, 40)
end

-- 创建卡牌翻牌后的界面
function BeautyCardWin:create_card_open( panel, index, x, y )
    local card_info = BeautyCardConfig:get_card_info_open( index )

    local panel_open = CCBasePanel:panelWithFile(0, 20, 275, 490, UILH_BEAUTYCARD.bc_bg)
    panel:addChild(panel_open)
    self.card_open[index] = panel_open
    self.card_open[index]:setIsVisible(false)

    -- 不做处理，拦截事件
    local function title_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            return false
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    panel_open:registerScriptHandler(title_btn_fun)  --注册

    -- 下拉按钮
    function down_func ()
        self.card_open[index]:setIsVisible(false)
        local move_to_1 = CCMoveTo:actionWithDuration( 0.2, CCPoint(0, 0))
        local move_to_2 = CCMoveTo:actionWithDuration( 0.2, CCPoint(0, 20))
        local act_down  = CCArray:array()
        act_down:addObject(move_to_1)
        act_down:addObject(move_to_2)
        local seq_down = CCSequence:actionsWithArray(act_down)
        self.card_show[index]:runAction(seq_down)
    end
    local btn_down = ZTextButton:create( panel_open, "", UILH_BEAUTYCARD.bc_down, down_func, 115, 375)

    -- 开启1次
    local panel_cost_1 = CCBasePanel:panelWithFile(35, 270, 210, 45, UILH_BEAUTYCARD.bc_cost_bg, 100)
    panel_open:addChild(panel_cost_1)
    ZLabel:create( panel_cost_1, LH_COLOR[2] .. card_info.cost_type_1, 50, 14, 16, ALIGN_LEFT)
    ZLabel:create( panel_cost_1, LH_COLOR[2] .. card_info.cost_num_1, 115, 14, 16, ALIGN_LEFT)
    function open_one_func () 
        -- 1:令牌，直接请求；2，(黄金宝箱),判断是否有免费次数
        if index == 1 then
            BeautyCardCC:req_draw_card( index, BeautyCardModel.DRAW_ONE )
            return
        elseif index == 2 then
            local cd_times = BeautyCardModel:get_cd_times()
            if cd_times[index] == 0 then
                BeautyCardCC:req_draw_card( index, BeautyCardModel.DRAW_ONE )
                return 
            end
        end
        -- 如果没有免费次数，判断 元宝是否足够
        local avatar = EntityManager:get_player_avatar();--角色拥有元宝
        if avatar.yuanbao < card_info.cost_num_1 then     -- 判断元宝是否充实
            local function confirm2_func()
                GlobalFunc:chong_zhi_enter_fun()
            end
            ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
        else
            BeautyCardCC:req_draw_card( index, BeautyCardModel.DRAW_ONE )
        end
    end
    local open_one = ZTextButton:create( panel_open, LH_COLOR[2] .. card_info.btn_label_1, UILH_COMMON.btn4_nor, open_one_func, 80, 210)

    -- 判断是否有tip
    if card_info.tip_label then
        ZLabel:create( panel_open, LH_COLOR[2] .. card_info.tip_label, 140, 180, 16, ALIGN_CENTER)
    end

    -- 开启10次
    local panel_cost_10 = CCBasePanel:panelWithFile(35, 100, 210, 45, UILH_BEAUTYCARD.bc_cost_bg, 100)
    panel_open:addChild(panel_cost_10)
    ZLabel:create( panel_cost_10, LH_COLOR[2] .. card_info.cost_type_10, 50, 14, 16, ALIGN_LEFT)
    ZLabel:create( panel_cost_10, LH_COLOR[2] .. card_info.cost_num_10, 115, 14, 16, ALIGN_LEFT)
    function open_ten_func () 
        if index == 1 then
            BeautyCardCC:req_draw_card( index, BeautyCardModel.DRAW_TEN )
            return
        end
        
        local avatar = EntityManager:get_player_avatar();--角色拥有元宝
        if avatar.yuanbao < card_info.cost_num_10 then     -- 判断元宝是否充实
            local function confirm2_func()
                GlobalFunc:chong_zhi_enter_fun()
            end
            ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
        else
            BeautyCardCC:req_draw_card( index, BeautyCardModel.DRAW_TEN )
        end
    end
    local open_ten = ZTextButton:create( panel_open, LH_COLOR[2] .. card_info.btn_label_10, UILH_COMMON.btn4_nor, open_ten_func, 80, 40)

end


-- 更新数据： 参数：更新的类型
function BeautyCardWin:update( update_type )
    -- 主界面信息
    if update_type == "create" then
        self:update_createUI()
    elseif update_type == "result" then
        -- self:show_result_win()
        UIManager:show_window("beauty_card_result_win")
    elseif update_type == "gf_time" then
        self:update_gf_time()
    end
end

-- 创建界面
function BeautyCardWin:update_createUI()
    -- local type_card, num_card = BeautyCardConfig:get_beautycard_type_num( )
    local num_card = BeautyCardModel:get_card_num()
    local pos_card = BeautyCardConfig:get_card_pos(num_card)
    for i=1, num_card do
        self:create_card(i, pos_card[i].x, pos_card[i].y)
    end
end

-- 更新黄金宝箱免费时间
function BeautyCardWin:update_gf_time( )
    local gf_time = BeautyCardModel:get_gf_time( )
    if gf_time then
        if gf_time ~= 0 then
            self.lab_gold_free:setText(LH_COLOR[2] .."后免费")
            if self.timer_gold_free then
                self.timer_gold_free:setText(gf_time)
            else
                local function end_call_func()
                    if self.lab_gold_free then
                        self.lab_gold_free:setText(LH_COLOR[2] .. "拥有一次免费机会")
                    end
                    -- 清除计时器
                    if self.timer_gold_free then
                        self.timer_gold_free:destroy()
                        self.timer_gold_free = nil
                    end
                end
                self.timer_gold_free = TimerLabel:create_label( self.card_show[2], 150, 420, 16, gf_time, LH_COLOR[6], end_call_func, nil, ALIGN_CENTER )
            end
        else
            self.lab_gold_free:setText(LH_COLOR[2] .."拥有一次免费机会")
        end
    end
end

function BeautyCardWin:active( show )
    if show then
        BeautyCardCC:req_beautycard_info()
    end
end



function BeautyCardWin:destroy()
    if self.timer_label then
        self.timer_label:destroy()
        self.timer_label = nil
    end
    if self.timer_gold_free then
        self.timer_gold_free:destroy()
        self.timer_gold_free = nil
    end
    Window.destroy(self)
end
