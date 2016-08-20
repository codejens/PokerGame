-- LGXiulianPage.lua
-- created by chj @2015-2-3
-- 灵根真气修炼

super_class.LGXiulianPage()

-- ui param
local win_w = 900
local win_h = 605
local align_x = 10
local aligh_x_2 = 10
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45
local panel_w = 900-align_x*2
local panel_h = win_h-radio_b_h -35

local is_zhuanhua_tip = false

-- 12个小时 = n秒
local second_hour_12 = 12 * 60 * 60
local full_rm_time_view = 100

function LGXiulianPage:__init(window_name, texture_name)

    self.btn_effect = nil
    self.btn_effect_index = 0 
    -- 消费的铜币
    self.zhenqi_get = 0
    self.zhenqi_count = LinggenModel:get_xiulian_zhenqi()

	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_w, panel_h).view
    -- self.view = CCBasePanel:panelWithFile( 0, 0, panel_w, panel_h, UILH_COMMON.normal_bg_v2, 500, 500)
    -- self.view = ZBasePanel.new( "", 850, 500).view

    -- local panel_w = 870
    -- local panel_h = 525

    -- self.view = ZBasePanel.new( "", panel_w, panel_h).view

    -- basePanel = self.view
    -- 背景
    self.panel_left = CCBasePanel:panelWithFile( 15, 10, 385, 500, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(self.panel_left)

    self.panel_right = CCBasePanel:panelWithFile( 400, 10, 465, 500, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(self.panel_right)

    self.panel_in_in = CCBasePanel:panelWithFile(30, 160, 355, 310, UILH_COMMON.bg_11, 500, 500)
    self.view:addChild( self.panel_in_in)
    -- 背景图画(梦境<遗迹> 同)
    self.panelbg_1 = CCBasePanel:panelWithFile( -30, 30, -1, -1, "nopack/BigImage/dreamland_bg.png")
    self.panel_in_in:addChild(self.panelbg_1)
    self.panelbg_1:setScale(0.7)
    self.panelbg_2 = CCBasePanel:panelWithFile( 171, 30, -1, -1, "nopack/BigImage/dreamland_bg.png")
    self.panel_in_in:addChild(self.panelbg_2)
    self.panelbg_2:setFlipX(true)
    self.panelbg_2:setScale(0.7)

    -- 每天
    ZLabel:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_title, 205, panel_h-45, 16, ALIGN_CENTER)

    -- 丹炉
    ZImage:create( self.view, UILH_LINGGEN.danlu, 85, 205, -1, -1)

    -- 修炼值满还需
    self.full_need_tip = ZLabel:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_full_time_1, 175, 140, 16, ALIGN_RIGHT)
    self.counter_full = TimerLabel:create_label( self.view, -260, -180, 16, 60 * 60 * 24, LH_COLOR[6] )
    
    -- 修炼进度条
    -- 修炼值 & 进度 & state
    -- ZLabel:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_value, panel_w*0.5-180, panel_h-235, 16, ALIGN_RIGHT)
    self.item_xlz = CCBasePanel:panelWithFile( 40, 110, -1, -1 , UILH_LINGGEN.xiulianzhi)
    self.view:addChild(self.item_xlz)

    self.process_bar = ZXProgress:createWithValueEx(1,200,230,17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar, true);
    self.process_bar:setPosition(CCPointMake(140, 110));
    self.process_bar:setProgressValue( 1, 100 )
    self.view:addChild(self.process_bar,1)
    -- local pro_left = ZBasePanel:create(self.process_bar, UILH_NORMAL.progress_left, )
    local pro_left = CCBasePanel:panelWithFile( -15, -7, -1, -1 , UILH_NORMAL.progress_left )
    self.process_bar:addChild(pro_left)
    pro_left:setScale(0.8)
    -- local pro_right = ZBasePanel:create(self.process_bar, UILH_NORMAL.progress_left, 275, -7, -1, -1 )
    local pro_right = CCBasePanel:panelWithFile( 215, -7, -1, -1 , UILH_NORMAL.progress_left )
    self.process_bar:addChild(pro_right)
    pro_right:setScale(0.8)
    pro_right:setFlipX(true)

    -- self.xiuliang_zhong = ZLabel:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_state, panel_w*0.5+180, panel_h-235, 16, ALIGN_LEFT)
    -- self.xiuliang_zhong.view:setIsVisible(false)
    -- 个item
    -- self.item_bg_f3 = ZBasePanel:create(self.view, UILH_COMMON.bg_11, 155, 145, 570, 125, 500, 500 )    
    -- self.item_bg_f3 = CCBasePanel:panelWithFile( 455, 145, 570, 125, UILH_COMMON.bg_11, 500, 500 )
    -- self.view:addChild(self.item_bg_f3)
    -- self.award_linggen = 
    for i=1, 3 do
        self:create_item(self.panel_right, i)
    end

    -- 分割线
    local line = CCZXImage:imageWithFile( 9, 165, 445, 3, UILH_COMMON.split_line )
    self.panel_right:addChild(line)
    
    -- 说明 & 内容
    ZLabel:create( self.panel_right, LH_COLOR[2] .. Lang.lenggen.xl_shuoming, 20, 145, 14, ALIGN_LEFT)
    local sm_cont = CCDialogEx:dialogWithFile(35, 145, 415, 130, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    sm_cont:setAnchorPoint(0,1);
    sm_cont:setFontSize(14);
    sm_cont:setLineEmptySpace(3)
    sm_cont:setText( Lang.lenggen.xl_sm_cont );  -- "#cffff00当前效果:#cffffff:"
    sm_cont:setTag(0)
    self.panel_right:addChild(sm_cont)


    -- 下次加速
    -- ZLabel:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_spe_up_time, 30, 80, 16, ALIGN_LEFT)
    self.counter_sp = TimerLabel:create_label( self.view, 200, 420, 16, 60 * 60 * 24, LH_COLOR[1], nil, nil, ALIGN_CENTER )

    -- 潜心修炼2个小时内速度翻倍
    local function qianxin_func( )
        self:remove_xiulian_btn_effect(2)
        LinggenModel:req_qx_xiulian()
    end 
    -- ZLabel:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_double,300, 110, 16, ALIGN_CENTER)
    self.btn_qianxin = ZTextButton:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_btn_1, UILH_COMMON.btn4_nor, qianxin_func, 50, 50, -1, -1, 1)
    self.btn_qianxin.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    self.btn_qianxin.view:addTexWithFile(CLICK_STATE_UP, UILH_COMMON.btn4_nor)
    ZLabel:create( self.view, LH_COLOR[1] .. Lang.lenggen.xl_cost_1, 113, 30, 16, ALIGN_CENTER)

    -- 开关
    local function switch_func( if_selected )
        is_zhuanhua_tip = if_selected
    end

    local function zhuanhua_sure_func()
        print("请求转化")
        LinggenModel:req_change_zhenqi( )
    end

    -- 潜心修炼2个小时内速度翻倍
    local function zhuanhua_func( )
        self:remove_xiulian_btn_effect(1)
        if self.zhenqi_get == 0 then
            GlobalFunc:create_screen_notic( Lang.LGXiulian[1])
        else
            if is_zhuanhua_tip == false then
                local str = string.format( Lang.LGXiulian[2], self.zhenqi_get )
                ConfirmWin2:show( 1, nil, str, zhuanhua_sure_func, switch_func)  
            else
                zhuanhua_sure_func()
            end
        end
    end 
    -- ZLabel:create( self.view, LH_COLOR[1] .. Lang.lenggen.xl_double, panel_w*0.5+250, panel_h-310, 18, ALIGN_RIGHT)
    self.btn_change = ZTextButton:create( self.view, LH_COLOR[2] .. Lang.lenggen.xl_btn_2, UILH_COMMON.btn4_nor, zhuanhua_func, 250, 50, -1, -1, 1)
    self.btn_change.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    self.btn_change.view:setCurState(CLICK_STATE_DISABLE)
    self.cost_change = ZLabel:create( self.view, LH_COLOR[1] .. Lang.lenggen.xl_cost_2, 310, 30, 16, ALIGN_CENTER)

end

-- 创建item
local percent_t = LinggenModel:get_xiulian_percent( )
function LGXiulianPage:create_item( panel, index )
    local award_linggen = LinggenModel:get_item_config()
    -- local zhenqi_count = LinggenModel:get_xiulian_zhenqi()
    -- local item_bg = ZBasePanel:create( panel, "", 15+180*(index-1), 5, 180, 115 )
    local item_bg = CCBasePanel:panelWithFile( 15, 185+95*(3-index), 180, 105, "")
    panel:addChild(item_bg)

    local item_slot = MUtils:create_value_slot_item(item_bg, UILH_COMMON.slot_bg, 20, 5)
    local item_t = { show_type = 1 , type = 1, icon_count = self.zhenqi_count[index], icon_path=1 };
    item_slot:set_icon_and_num(item_t.show_type, item_t.icon_path, item_t.icon_count)

    local str = LH_COLOR[2] .. Lang.LGXiulian[3] .. LH_COLOR[1] .. percent_t[index] .. "%".. LH_COLOR[2] .. "可点击转化后获得"
    ZLabel:create( item_bg, str, 125, 25, 14, ALIGN_LEFT)

    -- local item_slot = MUtils:create_slot_item2(item_bg, 
    --                         UILH_COMMON.slot_bg, 53, 15, 64, 64,nil,nil,9.5);
    -- item_slot:set_color_frame( award_linggen[index].id, -2, -2, 67, 67 )
    -- item_slot:set_icon( award_linggen[index].id )
    -- item_slot:set_item_count( award_linggen[index].count )

    -- function
    -- local function item_tips_func(...)
    --     if award_linggen[index].id ~= 0 then
    --         TipsModel:show_shop_tip( 15+180*(index-1), 300, award_linggen[index].id )
    --     else
    --         local temp_data = { item_id = award_item_info[temp_item_index].type, item_count = award_item_info[temp_item_index].count }
    --         TipsModel:show_money_tip( 15+180*(index-1), 300, award_linggen[index].id )
    --     end
    -- end
    -- item_slot:set_click_event(item_tips_func)
    --end
    -- if index ~= 3 then
    --     local line = CCZXImage:imageWithFile( 180, 5, 3, 100, UILH_COMMON.split_line_v )
    --     item_bg:addChild(line)
    -- end
    return item_bg
end


-- ========================================================================
-- 数据更新方法 ===========================================================
-- ========================================================================
-- 界面更新
function LGXiulianPage:update_data()
    local xl_btn_state, counter_full, counter_sp, is_speed_up = LinggenModel:get_zhenqi_data()
    print("-----zhenqi:", xl_btn_state, counter_full, counter_sp, is_speed_up )
    -- 刷新两个定时器
    if self.counter_full then
        self.counter_full:destroy()
        self.counter_full = nil
    end
    if counter_full ~= 0 then
        if is_speed_up then
            self.counter_full = TimerLabel:create_label( self.view, 200, 140, 16, 
                counter_full, LH_COLOR[6], nil, nil, nil, nil, nil, 2 )
        else
            self.counter_full = TimerLabel:create_label( self.view, 200, 140, 16, 
                counter_full, LH_COLOR[6] )
        end
    end
    if self.counter_sp then
        self.counter_sp:destroy()
        self.counter_sp = nil
    end
    if counter_sp ~= 0 then
        self.counter_sp = TimerLabel:create_label( self.view, 200, 420, 16, counter_sp, LH_COLOR[1], nil, nil, ALIGN_CENTER )
    end

    -- 潜心修炼btn状态
    if xl_btn_state then
        self.btn_qianxin.view:setCurState(CLICK_STATE_UP)
        self:remove_qianxin_effect();
        -- self.xiuliang_zhong.view:setIsVisible(false)
    else
        self.btn_qianxin.view:setCurState(CLICK_STATE_DISABLE)
        self:play_qianxin_effect();
        -- self.xiuliang_zhong.view:setIsVisible(true)
    end

    -- 定时器，刷新进度条
    full_rm_time_view = counter_full
    local function update_xiulian_value()
        if full_rm_time_view == 0 then
            self.process_bar:setProgressValue( 100, 100 )
            self:remove_qianxin_effect();
            self.full_need_tip:setText( LH_COLOR[2] .. Lang.lenggen.xl_full_time_2 )
            if self.process_timer then
                self.process_timer:stop()
                self.process_timer = nil
            end
        else
            self.full_need_tip:setText( LH_COLOR[2] .. Lang.lenggen.xl_full_time_1 )
        end
        -- 不等于0是，计算
        local percent = (second_hour_12-full_rm_time_view)/second_hour_12*100
        if percent >=60 then
            if percent >= 100 then
                self.zhenqi_get = self.zhenqi_count[3]
                self.cost_change:setText(LH_COLOR[1] .. Lang.LGXiulian[4] .. LinggenModel:get_cost_tongbi( 3 ) .. "银两")
            elseif percent >= 80 then
                self.zhenqi_get = self.zhenqi_count[2]
                self.cost_change:setText(LH_COLOR[1] .. Lang.LGXiulian[4] .. LinggenModel:get_cost_tongbi( 2 ) .. "银两")
            elseif percent >= 60 then
                self.zhenqi_get = self.zhenqi_count[1]
                self.cost_change:setText(LH_COLOR[1] .. Lang.LGXiulian[4] .. LinggenModel:get_cost_tongbi( 1 ) .. "银两")
            end
            -- 根据进度设置转化btn
            -- self.cost_change.view:setIsVisible(true)
            -- self.btn_change.view:setCurState(CLICK_STATE_UP)
        else
            self.zhenqi_get = 0
            -- self.btn_change.view:setCurState(CLICK_STATE_DISABLE)
            -- self.cost_change.view:setIsVisible(false)
        end
        self.process_bar:setProgressValue( percent, 100 )
    end

    self.btn_change.view:setCurState(CLICK_STATE_UP)

    if self.process_timer then
        self.process_timer:stop()
        self.process_timer = nil
    end
    self.process_timer = timer()
    self.process_timer:start(1, update_xiulian_value)
    update_xiulian_value()
end

function LGXiulianPage:update( updateType )
    if updateType == "all" then
        LinggenModel:req_zhenqi_data()
    elseif updateType == "zhen_qi" then
        self:update_data()
    end
end

function LGXiulianPage:destroy( )
    if self.timer_qianxin then
        self.timer_qianxin:stop()
        self.timer_qianxin = nil
    end
    if self.process_timer then
        self.process_timer:stop()
        self.process_timer = nil
    end
    if self.counter_full then
        self.counter_full:destroy()
        self.counter_full = nil
    end
    if self.counter_sp then
        self.counter_sp:destroy()
        self.counter_sp = nil
    end
end

-- 转化成功特效 ==========================================
function LGXiulianPage:play_change_success_effect()
    LuaEffectManager:play_view_effect( 10014, 440, 385, self.view, false,5 );
end

-- 潜心修炼特效 ===================================
function LGXiulianPage:play_qianxin_effect()
    -- 如果已有过特效 删除
    self:remove_qianxin_effect()

    self.xiuliang_zhong = ZLabel:create( self.view, LH_COLOR[1] .. Lang.lenggen.xl_state, 150, 440, 16, ALIGN_LEFT)
    self.timer_qianxin = timer()
    local qianxin_index = 0 
    local function timer_qianxin_func( )
        qianxin_index = qianxin_index + 1
        if qianxin_index == 1 then
            self:setTextEx( self.xiuliang_zhong, LH_COLOR[1] .. Lang.LGXiulian[5] )
        elseif qianxin_index == 2 then
            self:setTextEx( self.xiuliang_zhong, LH_COLOR[1] .. Lang.LGXiulian[6] )
        elseif qianxin_index == 3 then
            self:setTextEx( self.xiuliang_zhong, LH_COLOR[1] .. Lang.LGXiulian[7] )
        elseif qianxin_index == 4 then
            self:setTextEx( self.xiuliang_zhong, LH_COLOR[1] .. Lang.LGXiulian[8] )
        end
        if qianxin_index == 4 then
            qianxin_index = 0
        end
    end
    self.timer_qianxin:start( 1, timer_qianxin_func)
end

-- 控件设置字体
function LGXiulianPage:setTextEx( widget, text )
    if widget then
        widget.view:setText(text)
    end
end

-- 去除潜心的effect
function LGXiulianPage:remove_qianxin_effect()
    if self.timer_qianxin then
        self.timer_qianxin:stop()
        self.timer_qianxin = nil
    end
    print("---------")
    if self.xiuliang_zhong then
        self.xiuliang_zhong.view:removeFromParentAndCleanup(true)
        self.xiuliang_zhong = nil
    end
end

-- 潜心成功特效
function LGXiulianPage:player_qx_progress_effect()
    LuaEffectManager:play_view_effect( 16, panel_w*0.5, 300, self.view ,false);
end

-- btn 特效  1,转化btn 2. 潜心修炼btn
function LGXiulianPage:play_xiulian_btn_effect( btn_index )
    if btn_index == 1 then
        -- LuaEffectManager:stop_view_effect(11045, self.btn_change)
        self.btn_effect = LuaEffectManager:play_view_effect(9, 0+121*0.5, 0+53*0.5, self.btn_change.view, true)
        self.btn_effect_index = 1
    elseif btn_index == 2 then
        -- LuaEffectManager:stop_view_effect(11045, self.btn_qianxin)
        self.btn_effect = LuaEffectManager:play_view_effect(9, 0+121*0.5, 0+53*0.5, self.btn_qianxin.view, true)
        self.btn_effect_index = 2
    end
end

-- 去除按钮特效
function LGXiulianPage:remove_xiulian_btn_effect( btn_index )
    if btn_index == 1 then
        if self.btn_effect then
            LuaEffectManager:stop_view_effect(9, self.btn_change.view)
            self.btn_effect = nil
            self.btn_effect_index = 0
        end
        -- LuaEffectManager:play_view_effect(9, 0+121*0.5, 0+53*0.5, self.btn_change.view, true)
    elseif btn_index == 2 then
        if self.btn_effect then
            LuaEffectManager:stop_view_effect(9, self.btn_qianxin.view)
            self.btn_effect = nil
            self.btn_effect_index = 0
        end
        -- LuaEffectManager:play_view_effect(9, 0+121*0.5, 0+53*0.5, self.btn_qianxin.view, true)
    end
end
----------------------------------
