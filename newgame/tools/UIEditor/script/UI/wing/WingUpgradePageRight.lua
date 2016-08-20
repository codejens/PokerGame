-- WingUpgradePageRight.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统升阶右页面

super_class.WingUpgradePageRight()

function WingUpgradePageRight:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

    -- ZBasePanel:create(panel, "", 10, 10, 373, 545, 500, 500)

    local upPanel = self:createUpPanel(393, 565-216)
    upPanel:setPosition(0, 216)
    panel:addChild(upPanel)

    local dwnPanel = self:createDwnPanel(393, 216)
    dwnPanel:setPosition(0, 0)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function WingUpgradePageRight:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZImage:create(parent, "ui/wing/15.png", 5, size.height-90, -1, -1, 0, 0)

	-- 战斗力
	self.fightVal = ZXLabelAtlas:createWithString("99999", "ui/normal/numbig")
    self.fightVal:setPosition(CCPointMake(180, size.height-72))
    self.fightVal:setAnchorPoint(CCPointMake(0, 0))
    parent:addChild(self.fightVal)

    --星星
	ZImage:create(parent, "ui/wing/14.png", 20, 220, 352, -1, -1, 500, 500)
	self.star = CCBasePanel:panelWithFile(72, 215, 250, 16, nil)
	MUtils:drawStart(self.star, 0)
	parent:addChild(self.star)

	ZLabel:create(parent, LangGameString[2158], 130, 182, 17, 1, 1) 	-- "当前属性加成："
	self.addAttr = ZLabel:create(parent, "", 270, 182, 17, 1, 1)

	-- 提升等级按钮
	local upgradeBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	upgradeBtn:setPosition(130, 105)
	parent:addChild(upgradeBtn.view)
	local upgradeFunc = function( )
		print('-- upgradeBtn clicked --')
		WingModel:req_upgrade_stage()
	end
	upgradeBtn:setTouchClickFun(upgradeFunc)
	local btnSize = upgradeBtn.view:getSize()
	local txtImg = ZImage:create(upgradeBtn.view, "ui/wing/17.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	ZLabel:create(parent, LangGameString[2160], 120, 75, 16, 1, 1) 		-- "当前声望："
	self.shengWang = ZLabel:create(parent, "", 220, 75, 16, 1, 1)

	ZLabel:create(parent, LangGameString[2161], 30, 25, 16, 1, 1) 		-- "需要声望："
	self.needShengWang = ZLabel:create(parent, "", 120, 25, 16, 1, 1)

	ZLabel:create(parent, LangGameString[2162], 215, 25, 16, 1, 1) 		-- "需要忍币："
	self.needBindYinlang = ZLabel:create(parent, "", 305, 25, 16, 1, 1)

	return parent
end

-- 更新上面板
function WingUpgradePageRight:updateUpPanel( )
	-- 更新属性加成
	local star = WingModel:get_curr_wing_star()
	local stage = WingModel:get_curr_wing_stage()
	local addTxt = WingModel:get_curr_attr_add()
	self.addAttr:setText(string.format("%d%%", addTxt))

	-- 更新声望
	local shengWangTxt = WingModel:get_user_renown()
	self.shengWang:setText(string.format("#cfff000%d", shengWangTxt))

	-- 更新需要声望
	local needShengWangTxt = WingModel:need_renown_upgrade_star()
	self.needShengWang:setText(string.format("#cfff000%d", needShengWangTxt))

	-- 更新需要忍币
	local needMoney = WingModel:need_xb_upgrade_star()
	self.needBindYinlang:setText(string.format("#cfff000%d", needMoney))

	-- 更新战斗力
	local fight = WingModel:get_curr_wing_score()
	self.fightVal:init(tostring(fight))

	-- 更新星星
	local starNum = WingModel:get_curr_wing_star()
	MUtils:drawStart(self.star, starNum)

end

function WingUpgradePageRight:playUpgradeEffect( parent, x, y )
	LuaEffectManager:stop_view_effect(16, parent)
	LuaEffectManager:play_view_effect(16, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end

-- 创建下面板
function WingUpgradePageRight:createDwnPanel(width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

    local rowBg = ZImage:create(nil, "ui/common/ht_bg.png", 2, size.height-40, size.width-4, 39, 0, 500, 500).view
    parent:addChild(rowBg)

    ZLabel:create(rowBg, LangGameString[2163], 60, 14, 17, 1, 1) -- "当前品阶"
    ZLabel:create(rowBg, LangGameString[2159], 240, 14, 17, 1, 1) -- "下一品阶"

    ZLabel:create(parent, LangGameString[2164], 10, 140, 15, 1, 1) -- "品        阶："
    ZLabel:create(parent, LangGameString[2165], 10, 140-55, 15, 1, 1) -- "最高属性加成："
    ZLabel:create(parent, LangGameString[2166], 10, 140-55*2, 15, 1, 1) -- "翅膀最高等级："

    self.grade = ZLabel:create(parent, "", 10+120, 140, 15, 1, 1)
    self.maxAddAttr = ZLabel:create(parent, "", 10+120, 140-55, 15, 1, 1)
    self.maxLevel = ZLabel:create(parent, "", 10+120, 140-55*2, 15, 1, 1)

    ZLabel:create(parent, LangGameString[2164], size.width/2+10, 140, 15, 1, 1) -- "品        阶："
    ZLabel:create(parent, LangGameString[2165], size.width/2+10, 140-55, 15, 1, 1) -- "最高属性加成："
    ZLabel:create(parent, LangGameString[2166], size.width/2+10, 140-55*2, 15, 1, 1) -- "翅膀最高等级："

    self.nexGrade = ZLabel:create(parent, "", size.width/2+10+120, 140, 15, 1, 1)
    self.nexMaxAddAttr = ZLabel:create(parent, "", size.width/2+10+120, 140-55, 15, 1, 1)
    self.nexMaxLevel = ZLabel:create(parent, "", size.width/2+10+120, 140-55*2, 15, 1, 1)

    return parent
end

-- 更新下面板
function WingUpgradePageRight:updateDwnPanel( )
	-- 更新品阶
	local maxStage = WingModel:get_max_win_stage()
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	self.grade:setText(string.format("#cfe8300%d阶", stage))
	self.nexGrade:setText(string.format("#cfe8300%d阶", (stage+1)>maxStage and maxStage or (stage+1)))

	-- 更新最高属性加成
	local maxAddAttrTxt = WingModel:get_curr_attr_add_limit()
	local nexMaxAddAttrTxt = WingModel:get_next_attr_add_limit()
	self.maxAddAttr:setText(string.format("#cfe8300%d%%", maxAddAttrTxt))
	self.nexMaxAddAttr:setText(string.format("#cfe8300%d%%", nexMaxAddAttrTxt))

	-- 更新翅膀最高等级
	local maxLevelTxt = WingModel:get_curr_stage_max_level()
	local nexMaxLevelTxt = WingModel:get_next_stage_max_level()
	self.maxLevel:setText(string.format("#cfe8300%d", maxLevelTxt))
	self.nexMaxLevel:setText(string.format("#cfe8300%d", nexMaxLevelTxt))
end

function WingUpgradePageRight:update( updateType )
	print('-- WingUpgradePageRight:update --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "UpgradeEffect" then
		self:playUpgradeEffect(self.view, 190, 446)
	elseif updateType == "fight" then
		-- 更新战斗力
		local fight = WingModel:get_curr_wing_score()
		self.fightVal:init(tostring(fight))
	elseif updateType == "renown" then
		-- 更新声望
		local shengWangTxt = WingModel:get_user_renown()
		self.shengWang:setText(string.format("#cfff000%d", shengWangTxt))
	end
end

function WingUpgradePageRight:destroy( )
	
end