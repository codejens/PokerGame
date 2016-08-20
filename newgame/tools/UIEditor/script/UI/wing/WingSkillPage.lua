-- WingSkillPage.lua
-- created by yongrui.liang on 2014-8-19
-- 翅膀技能页面

super_class.WingSkillPage()

local _autoBuyBtn = nil
local _buyBtn = 1

function WingSkillPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

    local upPanel = self:createUpPanel(373, 316)
    upPanel:setPosition(10, 240)
    panel:addChild(upPanel)

    local dwnPanel = self:createDwnPanel(373, 228)
    dwnPanel:setPosition(10, 10)
    panel:addChild(dwnPanel)
end

function WingSkillPage:createUpPanel( width, height )
	local parent = ZBasePanel.new("", width, height).view
	local size = parent:getSize()

	local skillBg = ZImage:create(parent, "ui/common/wzk-4.png", size.width/2, 220, -1, -1).view
	skillBg:setAnchorPoint(0.5, 0)

	self.skillItem = MUtils:create_slot_item(parent, UIPIC_ITEMSLOT, size.width/2-5, 234, 72, 72)
	self.skillItem.view:setAnchorPoint(0.5, 0)

	self.skillName = ZLabel:create(parent, "技能名称", size.width/2-10, 194, 18, 3, 1)
	self.skillLevel = ZLabel:create(parent, "技能等级", size.width/2+10, 194, 18, 1, 1)

	--技能效果
  	self.curLvDesc = ZDialog:create( parent, "技能效果：人物生命上限提升100%啊啊啊啊啊啊啊啊啊啊啊", 10, 174, size.width-20, 40, 17 )
  	self.curLvDesc:setAnchorPoint(0, 1)
  	self.curLvDesc.view:setLineEmptySpace(2)
  	--下级效果
  	self.nexLvDesc = ZDialog:create( parent, "下级效果：人物生命上限提升100%啊啊啊啊啊啊啊啊啊啊啊", 10, 174-60, size.width-20, 40, 17 )
  	self.nexLvDesc:setAnchorPoint(0, 1)
  	self.nexLvDesc.view:setLineEmptySpace(2)
  	--10级效果
  	self.tenLvDesc = ZDialog:create( parent, "10级效果：人物生命上限提升100%啊啊啊啊啊啊啊啊啊啊啊", 10, 174-60*2, size.width-20, 40, 17 )
  	self.tenLvDesc:setAnchorPoint(0, 1)
  	self.tenLvDesc.view:setLineEmptySpace(2)

	return parent
end

-- 更新上面板
function WingSkillPage:updateUpPanel( )
	local skillID = WingModel:getSelectedWingSkill()

	-- 更新技能图标
	local itemIcon = WingConfig:get_wing_skill_icon_by_id( skillID )
	print('-- itemIcon --', itemIcon)
	self.skillItem:set_icon_texture( itemIcon )

	-- 更新技能名称
	local name = WingModel:get_skill_name_by_index(skillID)
	self.skillName:setText(string.format("#cfff000%s", name))

	-- 更新技能等级
	local level = WingModel:getSkillLevelById(skillID)
	self.skillLevel:setText(string.format(LangGameString[2175], level))

	-- 更新描述
	local curLvDesc, nexLvDesc, tenLvDesc = self:getSkillDesc(skillID, level)
	print("-cur", curLvDesc)
	self.curLvDesc:setText(LangGameString[2179] .. curLvDesc)
	self.nexLvDesc:setText(LangGameString[2180] .. nexLvDesc)
	self.tenLvDesc:setText(LangGameString[2181] .. tenLvDesc)
end

function WingSkillPage:getSkillDesc( skillID, skillLevel )
	local curLvDesc = ""
	local nexLvDesc = ""
	local tenLvDesc = ""

	-- [2179]="#r#c00ff00技能效果："  [2180]="#r#c00ff00下级效果："  [2181]="#r#c00ff0010级效果："
	local effectName = {LangGameString[2179], LangGameString[2180], LangGameString[2181]}
	local skillDesc, effects, otherEffect, sign = WingModel:getSkillEffectById(skillID);

    curLvDesc = skillDesc[1] .. effects[1] .. sign ..skillDesc[2] .. otherEffect[1] .. skillDesc[3]
	nexLvDesc = skillDesc[1] .. effects[2] .. sign ..skillDesc[2] .. otherEffect[2] .. skillDesc[3]
	tenLvDesc = skillDesc[1] .. effects[3] .. sign ..skillDesc[2] .. otherEffect[3] .. skillDesc[3]

	local maxLevel = WingConfig:getSkillMaxLevelById(skillID)
	if skillLevel >= maxLevel then
		nexLvDesc = "已满级"
	end

	if skillLevel == 0 then
		curLvDesc = string.format(LangGameString[2178],skillID+1); -- [2178]="#cfff000式神%d阶开启"
	end

    return curLvDesc, nexLvDesc, tenLvDesc;
end

-- 创建下面板
function WingSkillPage:createDwnPanel( width, height )
	local parent = ZBasePanel.new("", width, height).view
	local size = parent:getSize()

	ZLabel:create(parent, LangGameString[2167], 60, 176, 17, 1, 1) 		-- "技能书："
	ZLabel:create(parent, LangGameString[2169], 60, 120, 17, 1, 1) 		-- "熟练度："

	self.needItem = MUtils:create_slot_item(parent, UIPIC_ITEMSLOT, size.width/2, 150, 72, 72)
	self.needItem.view:setAnchorPoint(0.5, 0)

	-- 购买按钮
    _buyBtn = ZTextButton.new("ui/common/button2.png", nil, nil, "购买")
    _buyBtn:setPosition(260, 160)
    parent:addChild(_buyBtn.view)
    local buyBtnCallback = function( )
        self:update("addItem")
    end
    local buyFunc = function( )
    	local skillID = WingModel:getSelectedWingSkill()
		local skillLevel = WingModel:getSkillLevelById(skillID)
        local itemID = WingModel:get_skill_book_id_by_skill_level(skillLevel)
        BuyKeyboardWin:show(itemID, buyBtnCallback)
    end
    _buyBtn:setTouchClickFun(buyFunc)

	self.progress = MUtils:create_progress_bar(140, 120, 170, 16, "ui/common/di.png", "ui/common/progress_green.png", 100, {14}, {1,1,1,1}, true)
    self.progress.set_max_value(100)
    self.progress.set_current_value(0)
    parent:addChild(self.progress.view)

    -- 提升技能按钮
	self.upSkillBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	self.upSkillBtn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/dan_d.png")
	self.upSkillBtn:setPosition(130, 45)
	parent:addChild(self.upSkillBtn.view)
	local upSkillFunc = function( )
		print('-- upSkillBtn clicked --')
		local skillID = WingModel:getSelectedWingSkill()
		WingModel:req_upgrade_skill(skillID, _autoBuyBtn.if_selected)
	end
	self.upSkillBtn:setTouchClickFun(upSkillFunc)
	local btnSize = self.upSkillBtn.view:getSize()
	local txtImg = ZImage:create(self.upSkillBtn.view, "ui/wing/18.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	ZLabel:create(parent, LangGameString[2168], 135, 15, 16, 1, 1) 		-- "需要忍币："
	self.needBindYinlang = ZLabel:create(parent, "123456", 225, 15, 16, 1, 1)

	-- 是否自动购买材料
    _autoBuyBtn = UIButton:create_switch_button(10, 15, 100, 44, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        "", 50, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    parent:addChild(_autoBuyBtn.view, 2);

    self.autoBuyTxt1 = ZLabel:create(parent, "自动购", 55, 40, 16, 1, 1)
    self.autoBuyTxt2 = ZLabel:create(parent, "买材料", 55, 20, 16, 1, 1)

	return parent
end

-- 更新下面板
function WingSkillPage:updateDwnPanel( )
	local skillID = WingModel:getSelectedWingSkill()
	local maxLevel = WingConfig:getSkillMaxLevelById(skillID)
	local skillLevel = WingModel:getSkillLevelById(skillID)

	if skillLevel > 0 and skillLevel < maxLevel then
		-- 更新技能升级材料
		local itemID = WingModel:get_skill_book_id_by_skill_level(skillLevel)
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

		-- 更新熟练度
		local exp = WingModel:get_exp_values(skillID)
		local curExp, maxExp = exp[1], exp[2]
		self.progress.set_max_value(maxExp)
	    self.progress.set_current_value(curExp)

	    -- 更新忍币
	    local needMoney = WingModel:get_xb_value_by_skill_index(skillID)
	    self.needBindYinlang:setText(string.format("#cfff000%d", needMoney))

	    -- 更新按钮
	    self.upSkillBtn.view:setCurState(CLICK_STATE_UP)
	    local canAutoBuy = WingModel:getCanAutoBuySkillItem(skillLevel)
	    if canAutoBuy then
	    	_buyBtn.view:setIsVisible(true)
	    	_autoBuyBtn.view:setIsVisible(true)
	    	self.autoBuyTxt1.view:setIsVisible(true)
	    	self.autoBuyTxt2.view:setIsVisible(true)
	    else
	    	_buyBtn.view:setIsVisible(false)
	    	_autoBuyBtn.set_state(false, true)
	    	_autoBuyBtn.view:setIsVisible(false)
	    	self.autoBuyTxt1.view:setIsVisible(false)
	    	self.autoBuyTxt2.view:setIsVisible(false)
	    end
	else
		self.needItem:set_icon(nil)
		self.needItem:set_icon_texture("")
		self.needItem:set_item_count(0)
		self.needItem:set_click_event(nil)

		self.progress.set_max_value(100)
	    self.progress.set_current_value(0)

	    self.needBindYinlang:setText(string.format("#cfff000", 0))

	    self.upSkillBtn.view:setCurState(CLICK_STATE_DISABLE)
	end
end

function WingSkillPage:playLvUpSkillEffect( parent, x, y )
    LuaEffectManager:stop_view_effect(10015, parent)
    LuaEffectManager:play_view_effect(10015, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end

function WingSkillPage:update( updateType )
	print('-- WingSkillPage:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "LvUpSkillEffect" then
		self:playLvUpSkillEffect(self.view, 175+25+30-10, 200-58)
	elseif updateType == "addItem" then
		local skillID = WingModel:getSelectedWingSkill()
		local skillLevel = WingModel:getSkillLevelById(skillID)
        local itemID = WingModel:get_skill_book_id_by_skill_level(skillLevel)
        local count = ItemModel:get_item_count_by_id( itemID )
        self.needItem:set_item_count(count)
        if count > 0 then
			self.needItem:set_icon_light_color()
		else
			self.needItem:set_icon_dead_color()
		end
	end
end

function WingSkillPage:destroy( )

end