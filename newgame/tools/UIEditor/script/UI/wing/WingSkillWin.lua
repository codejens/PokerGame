-- WingSkillWin.lua 
-- createed by chj at 2014-10.31
-- 翅膀技能面板

super_class.WingSkillWin(Window)

local win_w = 900
local main_win_w = 440


function WingSkillWin:__init( window_name, texture_name )

	-- 关闭按钮事件
    local function close_win_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            UIManager:hide_window("wing_skill_win");
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end

    -- 无所作为事件，main_win
    local function do_nill_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end

	-- 灰暗的背景背景
    self.bg_img = CCBasePanel:panelWithFile( -150, -50,
    				GameScreenConfig.ui_screen_width+200, GameScreenConfig.ui_screen_height+100, UILH_FUBEN.result_bg, 500, 500)
    self.view:addChild(self.bg_img)
    self.bg_img:registerScriptHandler( close_win_fun )  --注册

    -- 主窗口界面
    self.main_win = CCBasePanel:panelWithFile(win_w*0.5, -15, main_win_w, 625, UILH_COMMON.style_bg, 500, 500)
    self.main_win:setAnchorPoint(0.5, 0)
    self.view:addChild( self.main_win )
    self.main_win:registerScriptHandler(do_nill_fun)

    -- title 标题：307,60
    self.main_title = CCBasePanel:panelWithFile( main_win_w*0.5, 581, -1, -1, UILH_COMMON.title_bg )
    self.main_title:setAnchorPoint( 0.5, 0)
    self.main_win:addChild( self.main_title )
    local title_lab = CCZXImage:imageWithFile(307*0.5, 19, -1, -1, UILH_WING.cb_skill )
    title_lab:setAnchorPoint( 0.5, 0)
    self.main_title:addChild( title_lab)


    -- 关闭按钮
    local exit_btn = MUtils:create_btn(self.main_win, UILH_COMMON.close_btn_z , UILH_COMMON. close_btn_z ,close_win_fun, 373, 585,60,60);

    -- 创建窗口元素
    self:create_skill_win()
end

-- 创建窗口元素方法
function WingSkillWin:create_skill_win()
	-- 主面板bg
	self.panel_all = CCBasePanel:panelWithFile(20, 20, 405, 565, UILH_COMMON.bottom_bg, 500, 500)
	self.main_win:addChild( self.panel_all )

	self:create_left_panel( self.panel_all )
	self:create_right_panel( self.panel_all )
end

-- 创建左面板================================================
function WingSkillWin:create_left_panel( panel )
    -- 技能列表
    self.t_skill_item = {}

	-- 面板背景
	self.panel_left = CCBasePanel:panelWithFile(11, 11, 180, 543, UILH_COMMON.bg_10, 500, 500)
	panel:addChild( self.panel_left )

	-- 左面板title
	self.skillTitle = CCBasePanel:panelWithFile( 0, 510, 180, -1, UILH_NORMAL.title_bg4, 500, 500)
    self.panel_left:addChild( self.skillTitle )
    local skill_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[23], 180*0.5, 10, 16, ALIGN_CENTER )
    self.skillTitle:addChild( skill_lab)

    -- scroll_view
    self:create_skill_scroll( self.panel_left )
end

-- 创建scroll_view
function WingSkillWin:create_skill_scroll( panel )
	-- 技能个数（写成7个，屏蔽后面几个）
	-- local skill_num = WingConfig:getWingSkillNum( )
    local skill_num = 7
	-- scroll view 大小
	local _scr_info = { x = 3, y = 2, width = 165, height = 510, 
        			maxnum = 1, image = nil, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scr_info.x, _scr_info.y, _scr_info.width, 
        			_scr_info.height, _scr_info.maxnum, _scr_info.image, _scr_info.stype )
    panel:addChild( scroll )
    scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)
    -- scroll_view 里面的 panel
    local item_w = 165
    local item_h = 87

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 1行(此处创建只有一行)
            -- 一个item大面板，放入n个技能item
            local panel_all = CCBasePanel:panelWithFile( 0, 0, item_w, item_h*skill_num, UILH_COMMON.bg_07, 500, 500 )
            for i=1, skill_num do
                -- item create
                local panel_item = CCBasePanel:panelWithFile( 0, item_h*(skill_num-i), item_w, item_h, "", 500, 500 )
                panel_all:addChild( panel_item )
                self:create_item_panel(panel_item, 0, 0, item_w, item_h, i)

                -- 分割线
                local line = CCZXImage:imageWithFile( 10, 0, 190, 3, UILH_COMMON.split_line )
                panel_item:addChild(line)
            end
            scroll:addItem(panel_all)
            scroll:refresh()

            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    -- 添加滚动条上下箭头
    local scrollbar_up = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_up,168,502,-1,-1)
    local scrollbar_down = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_down,168,2,-1,-1)
end

-- 左面板scrollview的item
function WingSkillWin:create_item_panel( panel, x, y, w, h, index )
    -- 初始化 t_skill_item 表格
    self.t_skill_item[index] =  self.t_skill_item[index] or {}

    -- 翅膀数据
    local skills = WingConfig:get_wing_skills()

    -- 技能图标
    -- local skillItem = CCBasePanel:panelWithFile( 0, 0, -1, -1, UILH_NORMAL.skill_bg1)
    -- panel:addChild( skillItem )
    local skillItem = WingSkillItem:create_item( panel, x, y, 96, 94, index)
    skillItem:set_lock()
    self.t_skill_item[index].item = skillItem

    -- skillItem 注册
    skillItem.item:set_click_event( function( ... )
        self:select_skill(index)
    end )


    local level = skills[index].level
    local skills = WingConfig:get_wing_skills()

    local skill_name = UILabel:create_lable_2( skills[index].name, 90, 53, 14, ALIGN_LEFT )
    panel:addChild( skill_name )
    self.t_skill_item[index].name = skill_name

    local skill_desc = UILabel:create_lable_2( Lang.wing[25], 90, 20, 14, ALIGN_LEFT )
    panel:addChild( skill_desc )
    self.t_skill_item[index].desc = skill_desc

    -- panel事件注册
    local function item_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            
            self:select_skill(index)
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    panel:registerScriptHandler( item_btn_fun )  --注册

    -- 添加item选中框
    local slt_frame = CCBasePanel:panelWithFile(0, 0, w, h, UILH_COMMON.slot_focus, 500, 500)
    slt_frame:setIsVisible(false)
    self.t_skill_item[index].slt_frame = slt_frame
    panel:addChild( slt_frame )
end

-- 技能选择
function WingSkillWin:select_skill( skill_id )
    for i=1, #self.t_skill_item do
        self.t_skill_item[i].slt_frame:setIsVisible(false)
    end
    self.t_skill_item[skill_id].slt_frame:setIsVisible(true)
    WingModel:setSelectedWingSkill(skill_id)
    self:update_skill_info_byid(skill_id)
end

-- 创建右面板 ===========================================
function WingSkillWin:create_right_panel( panel )
	-- 面板背景
	self.panel_right = CCBasePanel:panelWithFile(192, 11, 205, 543, "")
	panel:addChild( self.panel_right )

	-- 技能效果描述 ------------------------------------------------------------
	ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[48], 15, 520, 14, 1, 1)
    self.cur_effect = CCDialogEx:dialogWithFile(15, 515, 185, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.cur_effect:setAnchorPoint(0,1);
    self.cur_effect:setFontSize(14);
    self.cur_effect:setText( "增加人物生命值" );  -- "#cffff00当前效果:#cffffff:"
    self.cur_effect:setTag(0)
    self.cur_effect:setLineEmptySpace (5)
    self.panel_right:addChild(self.cur_effect)
	-- self.cur_effect = ZLabel:create(self.panel_right, "增加人物生命值", 15, 490, 14, 1, 1)

	-- 下级效果 --
	ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[49], 15, 430, 14, 1, 1)
    self.next_effect = CCDialogEx:dialogWithFile(15, 425, 185, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.next_effect:setAnchorPoint(0,1);
    self.next_effect:setFontSize(14);
    self.next_effect:setText( "增加人物生命值" );  -- "#cffff00当前效果:#cffffff:"
    self.next_effect:setTag(0)
    self.next_effect:setLineEmptySpace (5)
    self.panel_right:addChild(self.next_effect)
	-- self.next_effect = ZLabel:create(self.panel_right, "增加人物生命值", 15, 430, 14, 1, 1)

	-- -- 满级效果 --
	-- ZLabel:create(self.panel_right, LH_COLOR[2] .. "满级效果：", 15, 400, 14, 1, 1)
	-- self.full_effect = ZLabel:create(self.panel_right, "增加人物生命值", 15, 370, 14, 1, 1)

	-- 分割线 -------------------------------------------------------------
    local line = CCZXImage:imageWithFile( 10, 350, 185, 3, UILH_COMMON.split_line )
    self.panel_right:addChild(line)

    -- 熟练度 --
    ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[50], 15, 320, 14, 1, 1)
    -- 熟练度进度条
    self.process_bar = ZXProgress:createWithValueEx(10,100,185,16,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_orange, true);
	self.process_bar:setPosition(CCPointMake(10,290));
	self.process_bar:setProgressValue( 5, 100 )
	self.panel_right:addChild(self.process_bar,1)

	-- 羽翼晶石tips --------------------------------------------------------
  	local function needItemTipsFunc(  )
  		local needItemId = WingModel:get_cur_level_crystal_item_id()
  		if needItemId then
	   		TipsModel:show_shop_tip( 400, 240, needItemId, TipsModel.LAYOUT_LEFT )
	   	end
	end
    -- 羽翼晶石 slotItem
	local needItemId = WingModel:get_cur_level_crystal_item_id()
	self.needItem = MUtils:create_slot_item(self.panel_right, UILH_COMMON.slot_bg, 65, 190, 81, 81, needItemId, needItemTipsFunc)

	-- 购买按钮 ---
    local buyBtnCallback = function( )
        self:update("addItem")
    end
    local buyFunc = function( )
        local skillID = WingModel:getSelectedWingSkill()
        local skillLevel = WingModel:getSkillLevelById(skillID)
        local itemID = WingModel:get_skill_book_id_by_skill_level(skillLevel)
        BuyKeyboardWin:show(itemID, buyBtnCallback)
    end
    self.btn_buy = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.wing[33], UILH_COMMON.button4, 
        buyFunc, 66, 140, -1, -1)
    self.btn_buy.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis )

    -- 是否自动购买材料勾选按钮
    self.autoBuyBtn = UIButton:create_switch_button(25, 95, 150, 44, 
        UILH_COMMON.dg_sel_1, 
        UILH_COMMON.dg_sel_2, 
        "", 0, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    self.panel_right:addChild(self.autoBuyBtn.view, 2);

    self.autoButLab = ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[35], 65, 107, 14, 1, 1)

    -- 技能升级按钮 --------------------------------------------------------
    local function btn_skill_upgrade_fun()
    	local skillID = WingModel:getSelectedWingSkill()
        WingModel:req_upgrade_skill(skillID, self.autoBuyBtn.if_selected)
    end 
    self.btn_upGrade = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.wing[24], UILH_COMMON.btn4_nor, 
        btn_skill_upgrade_fun, 40, 35, -1, -1)
    self.btn_upGrade.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis )

    -- 需要铜币 --
    ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[37], 25, 15, 14, 1, 1)
    self.need_bi = ZLabel:create(self.panel_right, "100", 115, 15, 14, 1, 1)
end

-- ============================================
-- 更新面板
-- ============================================
-- 更新左面板( 更新scrollview数据 )
function WingSkillWin:update_left_panel_data()

    -- 技能等级
    local wingData = nil
    local isShowOther = WingModel:getIsShowOtherWing()
    if isShowOther then
        wingData = WingModel:getOtherWingData()
    else
        wingData = WingModel:get_wing_item_data()
    end

    -- 技能个数（写成7个，屏蔽后面几个）
    -- for i=1, #wingData.skills_level do
    for i=1, 7 do
        local level = wingData.skills_level[i]
        if level ~= nil and level ~= 0 then
            self.t_skill_item[i].name:setIsVisible(true)
            self.t_skill_item[i].desc:setText( LH_COLOR[15] .. "Lv." .. tostring(level) .. "" ) -- [2046]="   等级"
            self.t_skill_item[i].item:set_open()
        else
            self.t_skill_item[i].name:setIsVisible(false)
            self.t_skill_item[i].desc:setText( LH_COLOR[3] .. tostring(i+1) .. Lang.wing[51] )
            self.t_skill_item[i].item:set_lock()
        end
    end
end

-- 
function WingSkillWin:update_right_panel_data()
    local skillID = WingModel:getSelectedWingSkill()
    self:select_skill( skillID )
end

-- 根据指定技能 更新右面板 技能信息
function WingSkillWin:update_skill_info_byid( skill_id )
    local skill_level = WingModel:getSkillLevelById( skill_id )
    local skill_max_level = WingConfig:getSkillMaxLevelById(skill_id)

    -- 效果技能 
    local curLvDesc, nexLvDesc, tenLvDesc = self:getSkillDesc(skill_id, skill_level)
    self.cur_effect:setText( curLvDesc )
    self.next_effect:setText( nexLvDesc )
    -- self.full_effect:setText( tenLvDesc )

    if skill_level > 0 and skill_level < skill_max_level then
        -- 更新技能升级材料  ---------
        local itemID = WingModel:get_skill_book_id_by_skill_level(skill_level)
        self.needItem:set_icon(itemID)
        self.needItem:set_color_frame(itemID, -2, -2, 68, 68)
        local count = ItemModel:get_item_count_by_id( itemID )
        self.needItem:set_item_count(count)
        if count > 0 then
            self.needItem:set_icon_light_color()
        else
            self.needItem:set_icon_dead_color()
        end
        self.needItem:set_click_event(function( ... )
            local skillID = WingModel:getSelectedWingSkill()
            local skillLevel = WingModel:getSkillLevelById(skillID)
            local itemID = WingModel:get_skill_book_id_by_skill_level(skillLevel)
            TipsModel:show_shop_tip( 400, 240, itemID )
        end)

        -- 更新当前熟练度
        local exp = WingModel:get_exp_values(skill_id)
        local curExp, maxExp = exp[1], exp[2]
        self.process_bar:setProgressValue( curExp, maxExp )

        -- 需要的铜币
        local needBi = WingModel:get_xb_value_by_skill_index(skill_id)
        self.need_bi:setText( needBi )

        -- 更新按钮
        self.btn_buy.view:setCurState(CLICK_STATE_UP)
        self.btn_upGrade.view:setCurState(CLICK_STATE_UP)

        local canAutoBuy = WingModel:getCanAutoBuySkillItem(skill_level)
        if canAutoBuy then
            self.btn_buy.view:setIsVisible(true)
            self.autoBuyBtn.view:setIsVisible(true)
            self.autoButLab.view:setIsVisible(true)
        else
            self.btn_buy.view:setIsVisible(false)
            self.autoBuyBtn.set_state(false, true)
            self.autoBuyBtn.view:setIsVisible(false)
            self.autoButLab.view:setIsVisible(false)
        end
    else
        -- 升级材料置空
        self.needItem:set_icon(nil)
        self.needItem:set_icon_texture("")
        self.needItem:set_item_count(0)
        self.needItem:set_click_event(nil)

        self.process_bar:setProgressValue( 0, 0 )

        -- 更新按钮无效
        self.btn_buy.view:setCurState(CLICK_STATE_DISABLE)
        self.btn_upGrade.view:setCurState(CLICK_STATE_DISABLE)
    end
end

-- 根据技能id, 技能等级获取数据
function WingSkillWin:getSkillDesc( skillID, skillLevel )
    local curLvDesc = ""
    local nexLvDesc = ""
    local tenLvDesc = ""

    -- [2179]="#r#c00ff00技能效果："  [2180]="#r#c00ff00下级效果："  [2181]="#r#c00ff0010级效果："
    -- local effectName = {LangGameString[2179], LangGameString[2180], LangGameString[2181]}
    local skillDesc, effects, otherEffect, sign = WingModel:getSkillEffectById(skillID);

    curLvDesc = skillDesc[1] .. LH_COLOR[6] .. effects[1] .. sign.. LH_COLOR[15]  ..skillDesc[2] .. LH_COLOR[6] ..  otherEffect[1] .. LH_COLOR[15].. skillDesc[3]
    nexLvDesc = skillDesc[1] .. LH_COLOR[6] .. effects[2] .. sign.. LH_COLOR[15]  ..skillDesc[2] .. LH_COLOR[6] ..  otherEffect[2] .. LH_COLOR[15].. skillDesc[3]
    tenLvDesc = skillDesc[1] .. LH_COLOR[6] .. effects[3] .. sign.. LH_COLOR[15]  ..skillDesc[2] .. LH_COLOR[6] ..  otherEffect[3] .. LH_COLOR[15].. skillDesc[3]

    local maxLevel = WingConfig:getSkillMaxLevelById(skillID)
    if skillLevel >= maxLevel then
        nexLvDesc = Lang.wing[52]
    end
    
    if skillLevel == 0 then
        curLvDesc = string.format(LangGameString[2178],skillID+1); -- [2178]="#cfff000式神%d阶开启"
    end

    return curLvDesc, nexLvDesc, tenLvDesc;
end

-- 更新材料数量
function WingSkillWin:update_item( )
    local skill_id = WingModel:getSelectedWingSkill()
    local skill_level = WingModel:getSkillLevelById(skill_id)
    local itemID = WingModel:get_skill_book_id_by_skill_level(skill_level)
    local count = ItemModel:get_item_count_by_id( itemID )
    self.needItem:set_item_count(count)
    if count > 0 then
        self.needItem:set_icon_light_color()
    else
        self.needItem:set_icon_dead_color()
    end
end


-- update
function WingSkillWin:update( updateType)
    if updateType == "all" then
        self:update_left_panel_data()
        self:update_right_panel_data()
    elseif updateType == "skill_info" then
        self:update_right_panel_data()
    elseif updateType == "addItem" then
        self:update_item()
    end
end


-- 播放提升翅膀技能暴击特效
function WingSkillWin:play_cri_effect()
    LuaEffectManager:play_view_effect( 10015,550,325,self.view,false,5 );
end

-- 激活时更新数据
function WingSkillWin:active( show )
	if show then
		self:update("all")
	end
end

-- 销毁窗体
function WingSkillWin:destroy()
    Window.destroy(self)
end
