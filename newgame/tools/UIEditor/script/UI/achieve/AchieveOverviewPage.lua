-- AchieveOverviewPage.lua
-- created by charles on 2013-1-5
-- 成就总览页面

-- require "UI/component/Window"
super_class.AchieveOverviewPage(Window)

-- require "../data/achieve_group"

local _lable_total_point; -- 成就点
local fight;--完成度
local _progress_total_finish; -- 成就点进度条
local _progress_hp;
local _progress_bind_yuanbao;
local _get_achieve_button;

local font_size = 17

function AchieveOverviewPage:create(  )
    return AchieveOverviewPage("AchieveOverviewPage", "", false, 880, 504 )
end

function AchieveOverviewPage:create_one_panel(self, x, y, width, height, info)
    local panel = {}
    info = LH_COLOR[2] .. info
    local panel_bg = CCBasePanel:panelWithFile(x, y, width, height, UILH_COMMON.bg_10, 500, 500)
    panel.view = panel_bg

    local title_bg = ZImage:create(panel_bg, UILH_NORMAL.title_bg4, 6, height - 35, width-12, -1, nil, 500, 500)
    local title = ZLabel:create(panel_bg, info, width/2, height-26, 18, 2)
    -- 进度条
    local lab1 = ZLabel:create(panel_bg, Lang.achieve.overview[2], 10, 26, 15)
    panel.progress = MUtils:create_progress_bar(75, 22, 210, 18, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_orange, 100, {14}, nil, true);
    panel_bg:addChild(panel.progress.view)
    -- 成就点数
    local lab2 = ZLabel:create(panel_bg, Lang.achieve.overview[6], 290, 26, 15)
    panel.score = ZLabel:create(panel_bg, '', 370, 26, 15)
    self:addChild(panel_bg)

    function panel:show_effect(flag)
        if flag then
            LuaEffectManager:stop_view_effect(11045, panel_bg)
            LuaEffectManager:play_view_effect(11045, width/2-1, height/2-5, panel_bg, true)
        else
            LuaEffectManager:stop_view_effect(11045, panel_bg)
        end
    end
    return panel
end

function AchieveOverviewPage:__init()
    local page = self.view;
    -- 底板
    self.temp_panel = {}
    local panel_bg = CCBasePanel:panelWithFile( 0, 0, 884, 514, UILH_COMMON.normal_bg_v2, 500, 500 )
    page:addChild(panel_bg)

    local bg_up = ZImage:create(panel_bg, UILH_COMMON.bottom_bg, 11, 105, 860, 380, nil, 500, 500)
    -- local bg_down = ZImage:create(panel_bg, UILH_COMMON.bg_02, 11, 10, 860, 110, nil, 500, 500)

    local bg_size = panel_bg:getSize()
    local notice_bg = ZImage:create(panel_bg, UILH_NORMAL.title_bg3, 265, bg_size.height-55, -1, -1, nil, 500, 500)
    local notice = ZImage:create(panel_bg, UILH_ACHIEVE.info, 387, bg_size.height-45, -1, -1, nil, 500, 500)

    ZLabel:create(panel_bg, Lang.achieve.overview[1], 110, bg_size.height-85, 16)
    self.achieve_num = ZLabel:create(panel_bg, "", 220, bg_size.height-85, 16)
    -- 完成值
    local dimensions = CCSize(60, 20);

    local lable_temp = UILabel:create_label_1(Lang.achieve.overview[2], dimensions, 475, bg_size.height-75, font_size, CCTextAlignmentLeft, 255, 255, 0); -- [535]="完成度"
    panel_bg:addChild(lable_temp);
    --进度条
    -- _progress_total_finish = ZXProgress:createWithValueEx(0, 100, 140, 22, "ui/common/di.png", "ui/common/progress_green.png", true);
    -- _progress_total_finish:setPosition(234, 448);
    -- panel_bg:addChild(_progress_total_finish);
    _progress_total_finish = MUtils:create_progress_bar(675, 425, 300, 23, UILH_NORMAL.progress_bg, UILH_NORMAL.progress_bar_blue, 100, {14}, {11,11,5,6}, true)
    panel_bg:addChild(_progress_total_finish.view)
    _progress_total_finish.view:setAnchorPoint(0.5, 0)
    dimensions = CCSize(180, 20);
    local beg_x = 20
    local beg_y = 315
    local int_w = 422
    local int_h = 100
    local achieve_group = AchieveConfig:get_achieve_group(  )

    for i = 1, 6 do
        local dx = math.fmod(i+1,2)
        local dy = math.ceil(i/2)-1
        local temp = self:create_one_panel(page, beg_x + int_w*dx, beg_y - int_h*dy, int_w-5, int_h-5, Lang.achieve.tab_text[i+1])
        self.temp_panel[#self.temp_panel + 1] = temp
    end

    -- 已获得生命点数
    ZLabel:create(panel_bg, Lang.achieve.overview[3], 25, 81, 16)
    _progress_hp = MUtils:create_progress_bar(165, 79, 450, 18, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_green2, 100, {14}, nil, true);
    panel_bg:addChild(_progress_hp.view)

    ZLabel:create(panel_bg, Lang.achieve.overview[4], 25, 53, 16)
    _progress_bind_yuanbao = MUtils:create_progress_bar(165, 51, 450, 18, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_blue2, 100, {14}, nil, true);
    panel_bg:addChild(_progress_bind_yuanbao.view)
    -- 领取奖励按钮
    local but_award = CCNGBtnMulTex:buttonWithFile( 679, 52, -1, -1, UILH_NORMAL.special_btn)
    but_award:addTexWithFile(CLICK_STATE_DOWN, UILH_NORMAL.special_btn)
    but_award:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    _get_achieve_button = but_award
    local function but_click_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_ENDED then
            require "control/AchieveCC"
            Instruction:handleUIComponentClick(instruct_comps.ACHIEVE_BTN_GET)
            Analyze:parse_click_main_menu_info(257)
            AchieveCC:get_point_award();
            return true
        end
    end
    but_award:registerScriptHandler(but_click_fun)    --注册
    panel_bg:addChild(but_award)

    ZCCSprite:create(but_award, UILH_ACHIEVE.reward, 162/2, 53/2)

    -- dimensions = CCSize(130, 20);
    -- lable_temp = UILabel:create_label_1(Lang.achieve.overview[5], dimensions, 15, 20, font_size, CCTextAlignmentLeft, 54, 166, 238);
    -- panel_bg:addChild(lable_temp);
    ZLabel:create(panel_bg, Lang.achieve.overview[5], 25, 27, 14)

    -- 可兑换成就:
    self.can_exchange = ZLabel:create(panel_bg, "", 760, 25, 14, 2)
end

function AchieveOverviewPage:update()
    --获取完成值
    -- fight:init(tostring(AchieveModel.getUserAchievePoint()));
    self.achieve_num:setText(tostring(AchieveModel.getUserAchievePoint()))
    -- _progress_total_finish:setProgressValue(AchieveModel:getUserFinishNum(), AchieveModel:getConfigAchieveNum());
    _progress_total_finish.set_max_value(AchieveModel:getConfigAchieveNum())
    _progress_total_finish.set_current_value(AchieveModel:getUserFinishNum())

    -- _progress_hp:setProgressValue(AchieveModel:getUserAchievePoint(), AchieveModel:getConfigAchievePoint());
    _progress_hp.set_max_value(AchieveModel:getConfigAchievePoint())
    _progress_hp.set_current_value(AchieveModel:getUserAchievePoint())

    -- _progress_bind_yuanbao:setProgressValue(AchieveModel:getUserAchievePoint(), AchieveModel:getConfigAchievePoint());
    _progress_bind_yuanbao.set_max_value(AchieveModel:getConfigAchievePoint())
    _progress_bind_yuanbao.set_current_value(AchieveModel:getUserAchievePoint())

    local get_group = AchieveModel:getAchieveExistGroup()

    -- 先清除特效,在添加
    self:stop_effect()
    for key, temp in ipairs(self.temp_panel) do
        if get_group[key] then
            temp:show_effect(true)
        else
            temp:show_effect(false)
        end
    end


    for i=1,6 do
        self.temp_panel[i].score:setText(tostring(AchieveModel:getUserAchievePoint(i)));
        self.temp_panel[i].progress.set_max_value(AchieveModel:getConfigAchieveNum(i))
        self.temp_panel[i].progress.set_current_value(AchieveModel:getUserFinishNum(i))
    end
    self.can_exchange:setText(Lang.achieve.overview[7] .. LH_COLOR[15] .. AchieveModel:getAchieveExistNum())
    if AchieveModel:isExistGetAward() == false then
        _get_achieve_button:setCurState(CLICK_STATE_DISABLE)
    else
        _get_achieve_button:setCurState(CLICK_STATE_UP)

    end
end

function AchieveOverviewPage:stop_effect()
    for i, temp in ipairs(self.temp_panel) do
        LuaEffectManager:stop_view_effect(11045, temp.view)
    end
end

function AchieveOverviewPage:destroy( )
    self:stop_effect()
    Window.destroy(self)
end