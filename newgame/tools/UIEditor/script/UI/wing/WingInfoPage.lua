-- WingInfoPage.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统信息左页面

super_class.WingInfoPage()

-- ui param
local win_w = 900
local win_h = 605
local align_x = 10
local aligh_x_2 = 10
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45
local panel_w = 900-align_x*2
local panel_h = win_h-radio_b_h -35

-- 小面板 param
local panel_lt_h = panel_h-aligh_x_2*2
local panel_l_w = 230
local panel_m_w = 400
local panel_r_w = 230

local wingNumPerPage = 4 -- 每页显示技能个数

local wing_index = { 1, 2, 3, 4, 5, 6 }
-- local wing_index = { 1, 2, 3, 4, 5, 6, 7, 8 }
local wing_path = { "icon/item/11400.pd", "icon/item/11401.pd", "icon/item/11402.pd" ,
			"icon/item/11403.pd", "icon/item/11404.pd", "icon/item/11405.pd", 
			"icon/item/11406.pd", "icon/item/11407.pd" }

-- 翅膀主界面窗口

function WingInfoPage:__init()
	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_w, panel_h).view

    -- 技能列表
    self.t_skill_item = {}
    WingModel:set_cur_show_stage( self:get_put_on_wing_id() )

    self.root_win = UIManager:find_visible_window("wing_win")
	-- 创建 3个面板
	self:create_left_panel()
	self:create_middle_panel()
	self:create_right_panel()
end

-- 获取当前穿戴翅膀
function WingInfoPage:get_put_on_wing_id()
    local modelID = nil
    local isShowOther = WingModel:getIsShowOtherWing()
    if isShowOther then
    -- 判断是否是其他人的翅膀
    local otherWingData = WingModel:getOtherWingData()
        modelID = otherWingData.modelId
    else
        modelID = WingModel:get_curr_modelId()
    end
    return modelID
end

-- 左面板 
function WingInfoPage:create_left_panel()
	self.panel_left = CCBasePanel:panelWithFile( aligh_x_2, aligh_x_2, panel_l_w, panel_lt_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_left )

	-- 战斗力title ---------------------------------------------
	self.fightTitle = CCZXImage:imageWithFile(15, panel_lt_h-65, -1, -1, UILH_MOUNT.zhandouli)
	self.panel_left:addChild( self.fightTitle )
	-- 战斗力value
	self.fightVal = ZXLabelAtlas:createWithString( "99999", "ui/lh_other/number2_" )
    self.fightVal:setPosition(CCPointMake( 100, panel_lt_h-62) )
    self.fightVal:setAnchorPoint( CCPointMake(0, 0) )
    self.panel_left:addChild( self.fightVal )

    -- 当前属性title ------------------------------------------
    self.attrTitle = CCBasePanel:panelWithFile( 0, 175, panel_l_w, -1, UILH_NORMAL.title_bg4, 500, 500)
    self.panel_left:addChild( self.attrTitle )
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[4], panel_l_w*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    self.attrTitle:addChild( attr_lab)

    -- 攻击
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[5], 20, 365-220, 14, ALIGN_LEFT )
    self.panel_left:addChild( attr_lab)
    self.attack = ZLabel:create(self.panel_left, "44444444444", 105, 365-220, 14, 1, 1)

    -- 外功防御
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[6], 20, 335-225, 14, ALIGN_LEFT )
    self.panel_left:addChild( attr_lab)
    self.phyDef = ZLabel:create(self.panel_left, "8888888888", 105, 335-225, 15, 1, 1)

    -- 内功防御
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[7], 20, 305-230, 14, ALIGN_LEFT )
    self.panel_left:addChild( attr_lab)
    self.magDef = ZLabel:create(self.panel_left, "8888888888", 105, 305-230, 14, 1, 1)

    -- 生命
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[8], 20, 275-235, 14, ALIGN_LEFT )
    self.panel_left:addChild( attr_lab)
    self.hp = ZLabel:create(self.panel_left, "444444444", 105, 275-235, 14, 1, 1)

    -- 详情资料title ------------------------------------------
    self.infoTitle = CCBasePanel:panelWithFile( 0, 390, panel_l_w, -1, UILH_NORMAL.title_bg4, 500, 500)
    self.panel_left:addChild( self.infoTitle )
    local info_lab = UILabel:create_lable_2( Lang.wing[9], panel_l_w*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    self.infoTitle:addChild( info_lab )

    -- 名称
    local wing_name = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[10], 20, 360, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_name)
    self.wing_name_v = ZLabel:create(self.panel_left, Lang.wing[11], 100, 360, 14, 1, 1)

    -- 翅膀等级
    local wing_level_title = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[12], 20,330, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_level_title )
    self.wing_level_v = ZLabel:create(self.panel_left, "10", 100, 330, 14, 1, 1)

    -- 翅膀品阶
    local wing_degree = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[13], 20, 263, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_degree)
    self.wing_degree_v = ZLabel:create(self.panel_left, "十阶", 100, 263, 14, 1, 1)
    self.wing_start_v = ZLabel:create(self.panel_left, "4星", 140, 263, 14, 1, 1)

    -- 升级按钮 和 升阶按钮 ------------------------------------
    local function btn_grade_fun()
        self.root_win:change_page(2)
    end 
    self.btn_upGrade = ZTextButton:create(self.panel_left, LH_COLOR[2] .. Lang.wing[14], UILH_COMMON.button4, 
        btn_grade_fun, 145, 285, -1, -1)

    local function btn_degree_fun()
    	self.root_win:change_page(3)
    end
    self.btn_upDegree = ZTextButton:create(self.panel_left, LH_COLOR[2] .. Lang.wing[15], UILH_COMMON.button4, 
        btn_degree_fun, 145, 213, -1, -1)

end

-- 中间面板 =====================================
function WingInfoPage:create_middle_panel()
	self.panel_middle = CCBasePanel:panelWithFile( panel_l_w+aligh_x_2, aligh_x_2, panel_m_w, panel_lt_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_middle )

	-- 翅膀名字title -------------------------------------------356
	self.nameTitle = CCBasePanel:panelWithFile( 25, 455, -1, -1, UILH_NORMAL.title_bg3)
    self.panel_middle:addChild( self.nameTitle )
    self.name_lab = UILabel:create_lable_2( LH_COLOR[1] .. Lang.wing[17], 356*0.5, (44-16)*0.5, 16, ALIGN_CENTER )
    self.nameTitle:addChild( self.name_lab, 1 )
    
        -- self.name_lab:setRotation(90)

    -- 背景 195, 329
    -- local left_bg = CCZXImage:imageWithFile(4, 145, -1, -1, UILH_WING.cb_bg)
    -- self.panel_middle:addChild( left_bg )
    -- local right_bg = CCZXImage:imageWithFile(195+4, 145, -1, -1, UILH_WING.cb_bg)
    -- right_bg:setFlipX(true)
    -- self.panel_middle:addChild( right_bg )

   	-- 4个角标
	local LTCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, 10, panel_lt_h-80)
	LTCorner.view:setFlipX(false)
	LTCorner.view:setFlipY(true)
	local LBCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, 10, 150)
	LBCorner.view:setFlipX(false)
	LBCorner.view:setFlipY(false)
	local RTCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, panel_m_w-55, panel_lt_h-80)
	RTCorner.view:setFlipX(true)
	RTCorner.view:setFlipY(true)
	local RBCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, panel_m_w-55, 150)
	RBCorner.view:setFlipX(true)
	RBCorner.view:setFlipY(false)

	-- 人物模型
	self.curPlayerModel = self:createPlayerModel(200, 220)
	self.panel_middle:addChild(self.curPlayerModel.avatar)

    -- 炫耀  按钮
    local function btn_flaunt_fun()
        -- print('-- 炫耀 clicked --')
        WingModel:send_wing_to_char( )
    end 
    self.btn_flaunt = ZTextButton:create(self.panel_middle, LH_COLOR[2] .. Lang.wing[18], UILH_COMMON.lh_button2, 
        btn_flaunt_fun, 60, 145, -1, -1)
    --& 化形(更换翅膀)
    local function btn_show_fun()
        -- print('-- huaxing  clicked -- do nothing --:', self.curShowStage)
        WingModel:req_hua_xing( WingModel:get_cur_show_stage() )
        self.btn_show.view:setCurState(CLICK_STATE_DISABLE)
    end 
    self.btn_show = ZTextButton:create(self.panel_middle, LH_COLOR[2] .. Lang.wing[19], UILH_COMMON.lh_button2, 
        btn_show_fun, 235, 145, -1, -1)
    self.btn_show.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis )
    self.btn_show.view:setCurState(CLICK_STATE_DISABLE)


    -- 翅膀化形title --------------------------------------------
    self.formTitle = CCBasePanel:panelWithFile( -1, 110, panel_m_w, -1, UILH_NORMAL.title_bg4, 500, 500)
    self.panel_middle:addChild( self.formTitle )
    local form_lab = UILabel:create_lable_2( Lang.wing[20], panel_m_w*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    self.formTitle:addChild( form_lab )

    self:create_wing_scroll( self.panel_middle )
end


-- 创建人物模型 middle
function WingInfoPage:createPlayerModel( x, y )
    require "entity/ShowAvatar"
    local showAvatar = ShowAvatar:create_wing_panel_avatar( x, y )
    showAvatar.avatar:setActionStept(ZX_ACTION_STEPT)
    showAvatar.avatar:playAction(ZX_ACTION_IDLE, 4, true)
    return showAvatar
end

-- 创建下方翅膀滚动按钮item
function WingInfoPage:create_wing_scroll( panel )

	-- 回调更新名字
	local createItem = function( index, newComp )
		if not newComp then
			newComp = self:createWingItem(index)
			newComp.update(index)
		else
			newComp.update(index)
		end
		return newComp
	end
	

	self.wingScroll = TouchListHorizontal(34, 20, 332, 83, 83, 15)
	self.wingScroll:BuildList(83, 0, wingNumPerPage, wing_index, createItem )
	panel:addChild(self.wingScroll.view)

	-- 左翻按钮
	local function left_btn_func()
        local leftIndex = self.wingScroll:getLeftIndex()
        if leftIndex > 1 then
        	if leftIndex - 1 > 0 then
        		self.wingScroll:setIndex(leftIndex-1)
        	else
        		self.wingScroll:setIndex(1)
        	end
        else
        	GlobalFunc:create_screen_notic( Lang.wing[21] )
        end
    end
    self.leftBtn = ZButton:create(panel, UILH_COMMON.arrow_normal, left_btn_func , 5, 15, -1, -1)

	-- 右翻按钮
	local function right_btn_func()
        local wingNum = #wing_index
        local leftIndex = self.wingScroll:getLeftIndex()
        if leftIndex <= wingNum-wingNumPerPage then
			self.wingScroll:setIndex(leftIndex+1)
        else
        	GlobalFunc:create_screen_notic( Lang.wing[22] )
        end
    end
    self.rightBtn = ZButton:create(panel, UILH_COMMON.arrow_normal, right_btn_func, 332+30, 15, -1, -1 )
    self.rightBtn.view:setFlipX(true)
end

function WingInfoPage:createWingItem( index )
	local WingItem = ZBasePanel.new(nil, 80, 80)
	local item = MUtils:create_slot_item(WingItem.view, UILH_COMMON.slot_bg, 3, 3, 81, 81, nil, nil)

	WingItem.update = function( index )
        if item.lock then
            item.lock:removeFromParentAndCleanup(true)
            item.lock = nil
        end

        local cur_index = WingModel:get_curr_wing_stage()
		local itemIcon = wing_path[index]
		item:set_icon_texture( itemIcon )
        item:set_select_effect_state(false)
        if index>(cur_index+1)  or index == 7 or index == 8 then
        -- if index>(cur_index+1) then
            item.lock = CCBasePanel:panelWithFile( -8, -8, -1, -1, UILH_NORMAL.lock)
            item.view:addChild(item.lock, 3)
        end

        -- 选中特效
        local isShowOther = WingModel:getIsShowOtherWing()
        if not isShowOther then
            local selected = WingModel:get_cur_show_stage()
            if selected == index then
                local slotEffect = SlotEffectManager.play_effect_by_slot_item(item)
                slotEffect:setPosition(CCPointMake(34, 32))
                -- slotEffect:setScale(1.28)
            elseif math.abs(selected-index) >= wingNumPerPage then
                SlotEffectManager.stop_current_effect()
            end
        end
            -- item 点击触发函数
        item:set_click_event( function( )
            -- if index > cur_index + 1 then
            if index > (cur_index + 1) or index == 7 or index == 8 then
                return 
            end

            local isShowOther = WingModel:getIsShowOtherWing()
            if not isShowOther then
                local slotEffect = SlotEffectManager.play_effect_by_slot_item(item)
                slotEffect:setPosition(CCPointMake(34, 32))
                -- slotEffect:setScale(1.28)

                -- 判断是否是当前佩戴翅膀
                -- print("--------WingModel:get_curr_wing_stage() -", WingModel:get_curr_wing_stage() ,index)
                if index == self:get_put_on_wing_id() or index > WingModel:get_curr_wing_stage() then
                    self.btn_show.view:setCurState(CLICK_STATE_DISABLE)
                else
                    self.btn_show.view:setCurState(CLICK_STATE_UP)
                end

                -- 翅膀名字
                local wingNameTxt = WingConfig:get_wing_name(index)
                self.name_lab:setText(LH_COLOR[1].. wingNameTxt)

                -- 设置选中翅膀
                WingModel:set_cur_show_stage(index)
                self.curPlayerModel:update_wing(index)
                self.curPlayerModel:change_attri("body")
                -- self:update_middle_panel_data()
            end
        end )
	end

	return WingItem
end

-- 右面板 ================================================
function WingInfoPage:create_right_panel()
	self.panel_right = CCBasePanel:panelWithFile( panel_l_w+panel_m_w+aligh_x_2, aligh_x_2, panel_r_w, panel_lt_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_right )

	-- 附带技能 --------------------------------
	self.skillTitle = CCBasePanel:panelWithFile( 0, 473, panel_r_w, -1, UILH_NORMAL.title_bg4, 500, 500)
    self.panel_right:addChild( self.skillTitle )
    local skill_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[23], panel_r_w*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    self.skillTitle:addChild( skill_lab)

    -- 分割线
    local isShowOther = WingModel:getIsShowOtherWing()
    if not isShowOther then
        local line = CCZXImage:imageWithFile(5, 70, panel_r_w-10, 3, UILH_COMMON.split_line )
        self.panel_right:addChild( line )
    end

    -- 翅膀附带技能scrollview
    self:create_right_skill_scroll( self.panel_right )

    -- 技能升级按钮
    local function btn_skill_upgrade_fun()
    	UIManager:show_window("wing_skill_win")
    end 
    self.btn_skill_upGrade = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.wing[24], UILH_COMMON.btn4_nor, 
        btn_skill_upgrade_fun, 55, 10, -1, -1)
end

-- 创建右面板scrolliview
function WingInfoPage:create_right_skill_scroll( panel )

	-- 技能个数
	local skill_num = WingConfig:getWingSkillNum( )
	-- scroll view 大小
    local isShowOther = WingModel:getIsShowOtherWing()
    local scroll_h = nil
    local scroll_y = nil
    local scrollbar_up_y = nil
    if isShowOther then
        scroll_h = 470
        scroll_y = 5
        scrollbar_up_y = scroll_h-5
    else
        scroll_h = 400
        scroll_y = 75
        scrollbar_up_y = 465
    end
	local _scr_info = { x = 5, y = scroll_y, width = 210, height = scroll_h, 
        			maxnum = 1, image = nil, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scr_info.x, _scr_info.y, _scr_info.width, 
        			_scr_info.height, _scr_info.maxnum, _scr_info.image, _scr_info.stype )
    panel:addChild( scroll )
    scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)
    -- scroll_view 里面的 panel
    local item_w = 210
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
    local scrollbar_up = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_up,215,scrollbar_up_y,-1,-1)
    local scrollbar_down = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_down,215,scroll_y,-1,-1)
end

-- 右面板scrollview的item
function WingInfoPage:create_item_panel( panel, x, y, w, h, index )

    -- 初始化 t_skill_item 表格
    self.t_skill_item[index] =  self.t_skill_item[index] or {}

	-- 翅膀数据
	local skills = WingConfig:get_wing_skills()

	-- 技能图标
    local skillItem = WingSkillItem:create_item( panel, x, y, 96, 94, index)
    skillItem:set_lock()
    self.t_skill_item[index].item = skillItem
    -- 点击触发函数
    skillItem.item:set_click_event( function( ... )
        -- 显示Tips
        local wingData = nil
        local isShowOther = WingModel:getIsShowOtherWing()
        if isShowOther then
            wingData = WingModel:getOtherWingData()
        else
            wingData = WingModel:get_wing_item_data()
        end
        wingData.skills[index].level = wingData.skills_level[index]
        wingData.skills[index].skillId = index

        local a, b, args = ...
        local click_pos = Utils:Split(args, ":")
        local world_pos = skillItem.item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                
        TipsModel:show_wing_skill_tip(world_pos.x, world_pos.y, wingData.skills[index])
    end )


	local level = skills[index].level
    local skills = WingConfig:get_wing_skills()

    local skill_name = UILabel:create_lable_2( skills[index].name, 90, 53, 16, ALIGN_LEFT )
    panel:addChild( skill_name )
    self.t_skill_item[index].name = skill_name

    local skill_desc = UILabel:create_lable_2( Lang.wing[25], 90, 20, 16, ALIGN_LEFT )
    panel:addChild( skill_desc )
    self.t_skill_item[index].desc = skill_desc

end

-- ========================================================================
-- 数据更新方法 ===========================================================
-- ========================================================================
function WingInfoPage:update_left_panel_data()
    local curAttr = nil
    local curAddAttr = nil
    local wingNameTxt = nil
    local wingLevelTxt = nil
    local wingStageTxt = nil
    local wingStarTxt = nil
    -- 更新战斗力 --------------------------------------
    local isShowOther = WingModel:getIsShowOtherWing()
    if not isShowOther then
        curAttr = WingModel:get_curr_attr()
        curAddAttr = WingModel:get_curr_attr_append()
        local fight = WingModel:get_curr_wing_score()
        self.fightVal:init(tostring(fight))

        wingNameTxt = WingModel:get_wing_name()
        wingLevelTxt = WingModel:get_curr_wing_level()
        wingStageTxt = WingModel:get_curr_wing_stage()
        wingStarTxt = WingModel:get_curr_wing_star()

        -- 处理按钮
        self.btn_upGrade.view:setIsVisible(true)
        self.btn_upDegree.view:setIsVisible(true)
    else
        -- 属性
        curAttr = WingModel:getOtherWingCurAttr()
        curAddAttr = WingModel:getOtherWingCurAttrAppend()
        -- 战斗力
        local fight = WingModel:getOtherWingScore()
        self.fightVal:init(tostring(fight))
        -- 名字
        wingNameTxt = WingModel:getOtherWingName()
        wingLevelTxt =WingModel:getOtherWingLevel()
        wingStageTxt = WingModel:getOtherWingStage()
        wingStarTxt = WingModel:getOtherWingStar()

        -- 处理按钮
        self.btn_upGrade.view:setIsVisible(false)
        self.btn_upDegree.view:setIsVisible(false)
    end

    -- 更新属性 --------------------------------------
    self.attack:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[1], curAddAttr[1]))
    self.phyDef:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[2], curAddAttr[2]))
    self.magDef:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[3], curAddAttr[3]))
    self.hp:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[4], curAddAttr[4]))

    -- 翅膀详细资料
    self.wing_name_v:setText(string.format( LH_COLOR[15] .. "%s", wingNameTxt))
    self.wing_level_v:setText(string.format( LH_COLOR[15] .. "%d", wingLevelTxt))
    self.wing_degree_v:setText(string.format( LH_COLOR[15] .. "%s" .. Lang.wing[26], self:to_word(wingStageTxt)) )  -- #c0edc09%s阶
    self.wing_start_v:setText(string.format( LH_COLOR[15] .. "%d" .. Lang.wing[27], wingStarTxt))
end

-- 数值转化为中文
function WingInfoPage:to_word( num )
    local word_t = Lang.wing[28]
    return word_t[num]
end

-- 更新中间面板 ============================================
function WingInfoPage:update_middle_panel_data()

    -- 翅膀模型
    -- local modelID = nil
    -- local isShowOther = WingModel:getIsShowOtherWing()
    -- if isShowOther then
    --     -- 判断是否是其他人的翅膀
    --     local otherWingData = WingModel:getOtherWingData()
    --     modelID = otherWingData.modelId
    -- else
        -- modelID = WingModel:get_curr_modelId()
    -- end

    -- self.curshowStage = WingModel:get_cur_show_stage()
    -- self.curPlayerModel:update_wing(self.curshowStage)
    -- self.curPlayerModel:change_attri("body")

    -- 更新人物模型
    local modelID = nil
    local isShowOther = WingModel:getIsShowOtherWing()
    if isShowOther then
        -- 判断是否是其他人的翅膀
        local otherWingData = WingModel:getOtherWingData()
        modelID = otherWingData.modelId
        self.btn_flaunt.view:setIsVisible(false)
        self.btn_show.view:setIsVisible(false)
    else
        modelID = WingModel:get_curr_modelId()
        -- 更新化形按钮
        if self.curshowStage == modelID then
            self.btn_show.view:setCurState(CLICK_STATE_DISABLE)
        end
    end
    self.curshowStage = modelID
    self.curPlayerModel:update_wing(modelID)
    self.curPlayerModel:change_attri("body")



    -- 翅膀名字
    local wingNameTxt = WingConfig:get_wing_name( self.curshowStage )
    self.name_lab:setText(LH_COLOR[1].. wingNameTxt)
end

-- 更新右界面 ===========================================
-- 更新右界面板，就是更新scrolloview中的item
function WingInfoPage:update_right_panel_data()
    -- 技能等级
    local wingData = nil
    local isShowOther = WingModel:getIsShowOtherWing()
    if isShowOther then
        wingData = WingModel:getOtherWingData()
        self.btn_skill_upGrade.view:setIsVisible(false)
    else
        wingData = WingModel:get_wing_item_data()
    end

    for i=1, WingConfig:getWingSkillNum() do
        local level = wingData.skills_level[i]
        if level ~= nil and level ~= 0 then
            self.t_skill_item[i].name:setIsVisible(true)
            self.t_skill_item[i].desc:setText( LH_COLOR[15] .. "Lv." .. tostring(level).."" ) -- [2046]="   等级"
            self.t_skill_item[i].item:set_open()
        else
            self.t_skill_item[i].name:setIsVisible(false)
            self.t_skill_item[i].desc:setText( LH_COLOR[3] .. Lang.wing[29] .. tostring(i+1) .. Lang.wing[30] )
            self.t_skill_item[i].item:set_lock()
        end
    end
end

-- 更新 翅膀选择按钮列表
function WingInfoPage:update_wing_scroll( )
    if self.wingScroll then
        self.wingScroll.view:removeFromParentAndCleanup(true)
        self.wingScroll:destroy()
        self.wingScroll = nil
    end
    local createItem = function( index, newComp )
        if not newComp then
            newComp = self:createWingItem(index)
            newComp.update(index)
        else
            newComp.update(index)
        end
        return newComp
    end

    self.wingScroll = TouchListHorizontal(34, 20, 332, 83, 83, 15)
    self.wingScroll:BuildList(83, 0, wingNumPerPage, wing_index, createItem )
    self.panel_middle:addChild(self.wingScroll.view)
end


-- 界面更新
function WingInfoPage:update( updateType )
    if updateType == "all" then
        self:update_left_panel_data()
        self:update_middle_panel_data()
        self:update_right_panel_data()

        -- ================
        self:update_wing_scroll()
        -- ================
    end
end

function WingInfoPage:destroy( )
    if self.wingScroll then
        self.wingScroll:destroy()
    end
end

----------------------------------
