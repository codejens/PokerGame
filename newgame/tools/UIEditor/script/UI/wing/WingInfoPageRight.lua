-- WingInfoPageRight.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统信息右页面

super_class.WingInfoPageRight()

-- 查看他人翅膀需要隐藏的东西
local _NO_OTHER_SHOW = {}

function WingInfoPageRight:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

    -- ZBasePanel:create(panel, "", 10, 10, 373, 545, 500, 500)

    local upPanel = self:createUpPanel(393, 565/2)
    upPanel:setPosition(0, 565/2)
    panel:addChild(upPanel)

    local dwnPanel = self:createDwnPanel(393, 565/2)
    dwnPanel:setPosition(0, 0)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function WingInfoPageRight:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZImage:create(parent, "ui/wing/15.png", 5, size.height-90, -1, -1, 0, 0)

	-- 战斗力
	self.fightVal = ZXLabelAtlas:createWithString("99999", "ui/normal/numbig")
    self.fightVal:setPosition(CCPointMake(180, size.height-72))
    self.fightVal:setAnchorPoint(CCPointMake(0, 0))
    parent:addChild(self.fightVal)

	ZLabel:create(parent, LangGameString[2139], 20, 150, 17, 1, 1)  -- 名字
	ZLabel:create(parent, LangGameString[2135], 20, 90, 17, 1, 1) 	-- 等级
	ZLabel:create(parent, LangGameString[2136], 20, 30, 17, 1, 1) 	-- 品阶
	ZLabel:create(parent, LangGameString[2137], 140, 90, 17, 1, 1) 	-- 祝福值
	ZLabel:create(parent, LangGameString[2138], 140, 30, 17, 1, 1) 	-- 星级数

	self.wingName = ZLabel:create(parent, "", 20+60, 150, 17, 1, 1)
	self.wingLevel = ZLabel:create(parent, "", 20+60, 90, 17, 1, 1)
	self.wingStage = ZLabel:create(parent, "", 20+60, 30, 17, 1, 1)
	self.wingWish = ZLabel:create(parent, "", 140+80, 90, 17, 1, 1)
	self.wingStar = ZLabel:create(parent, "", 140+80, 30, 17, 1, 1)

	-- 升级按钮
	 --xiehande btn_lang2 ->button2
	local lvUpBtn = ZTextButton.new("ui/common/button2.png", nil, nil, "升级")
	lvUpBtn.view:setPosition(size.width-110, 70)
	parent:addChild(lvUpBtn.view)
	local lvUpFunc = function( )
		print('-- lvUpBtn clicked --')
		WingModel:changeLeftPage( WingModel.WING_LEVEL_UP )
	end
	lvUpBtn:setTouchClickFun(lvUpFunc)
	table.insert(_NO_OTHER_SHOW, lvUpBtn.view)

	-- 升阶按钮
	--xiehande  通用按钮修改  --btn_lang2.png ->button2.png
	local upgradeBtn = ZTextButton.new("ui/common/button2.png", nil, nil, "进阶")
	upgradeBtn.view:setPosition(size.width-110, 10)
	parent:addChild(upgradeBtn.view)
	local upgradeFunc = function( )
		print('-- upgradeBtn clicked --')
		WingModel:changeLeftPage( WingModel.WING_UPGRADE )
	end
	upgradeBtn:setTouchClickFun(upgradeFunc)
	table.insert(_NO_OTHER_SHOW, upgradeBtn.view)

	return parent
end

-- 更新上面板
function WingInfoPageRight:updateUpPanel( )
	local isShowOther = WingModel:getIsShowOtherWing()
	if not isShowOther then
		-- 更新翅膀名字
		local wingNameTxt = WingModel:get_wing_name()
		self.wingName:setText(string.format("#c0edc09%s", wingNameTxt))

		-- 更新翅膀等级
		local wingLevelTxt = WingModel:get_curr_wing_level()
		self.wingLevel:setText(string.format("#c0edc09%d", wingLevelTxt))

		-- 更新翅膀品阶
		local wingStageTxt = WingModel:get_curr_wing_stage()
		self.wingStage:setText(string.format("#c0edc09%s阶", wingStageTxt)) 	-- #c0edc09%s阶

		-- 更新翅膀祝福值
		local wingWishTxt = WingModel:get_curr_level_wishes()
		local maxWingWishTxt = 10
		self.wingWish:setText(string.format("#c0edc09%d/%d", wingWishTxt, maxWingWishTxt))

		-- 更新翅膀星级
		local wingStarTxt = WingModel:get_curr_wing_star()
		local maxWingStarTxt = 10
		self.wingStar:setText(string.format("#c0edc09%d/%d", wingStarTxt, maxWingStarTxt))

		-- 更新战斗力
		local fight = WingModel:get_curr_wing_score()
		self.fightVal:init(tostring(fight))
	else
		local name = WingModel:getOtherWingName()
		self.wingName:setText(string.format("#c0edc09%s", name))
		local level = WingModel:getOtherWingLevel()
		self.wingLevel:setText(string.format("#c0edc09%d", level))
		local wingStageTxt = WingModel:getOtherWingStage()
		self.wingStage:setText(string.format("#c0edc09%s阶", wingStageTxt))
		local fight = WingModel:getOtherWingScore()
		self.fightVal:init(tostring(fight))
		local wingStarTxt = WingModel:getOtherWingStar()
		local maxWingStarTxt = 10
		self.wingStar:setText(string.format("#c0edc09%d/%d", wingStarTxt, maxWingStarTxt))
		local wingWishTxt = WingModel:getOtherWingWishes()
		local maxWingWishTxt = 10
		self.wingWish:setText(string.format("#c0edc09%d/%d", wingWishTxt, maxWingWishTxt))
	end
end

function WingInfoPageRight:createDwnPanel(width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

    local rowBg = ZImage:create(nil, "ui/common/ht_bg.png", 2, size.height-40, size.width-4, 39, 0, 500, 500).view
    parent:addChild(rowBg)

    ZLabel:create(rowBg, LangGameString[2141], 60, 14, 17, 1, 1) 		-- "当前属性"
    ZLabel:create(rowBg, LangGameString[2142], 240, 14, 17, 1, 1) 	-- "下级属性"

    ZLabel:create(parent, LangGameString[2146], 10, 195, 15, 1, 1) 	-- "生    命："
    ZLabel:create(parent, LangGameString[2143], 10, 195-55, 15, 1, 1) 	-- "攻    击："
    ZLabel:create(parent, LangGameString[2144], 10, 195-55*2, 15, 1, 1) -- "物理防御："
    ZLabel:create(parent, LangGameString[2145], 10, 195-55*3, 15, 1, 1) -- "精神防御："

    self.hp = ZLabel:create(parent, "", 10+80, 195, 15, 1, 1)
    self.attack = ZLabel:create(parent, "", 10+80, 195-55, 15, 1, 1)
    self.phyDef = ZLabel:create(parent, "", 10+80, 195-55*2, 15, 1, 1)
    self.magDef = ZLabel:create(parent, "", 10+80, 195-55*3, 15, 1, 1)

    ZLabel:create(parent, LangGameString[2146], size.width/2+10, 195, 15, 1, 1)
    ZLabel:create(parent, LangGameString[2143], size.width/2+10, 195-55, 15, 1, 1)
    ZLabel:create(parent, LangGameString[2144], size.width/2+10, 195-55*2, 15, 1, 1)
    ZLabel:create(parent, LangGameString[2145], size.width/2+10, 195-55*3, 15, 1, 1)

    self.nexHp = ZLabel:create(parent, "", size.width/2+10+80, 195, 15, 1, 1)
    self.nexAttack = ZLabel:create(parent, "", size.width/2+10+80, 195-55, 15, 1, 1)
    self.nexPhyDef = ZLabel:create(parent, "", size.width/2+10+80, 195-55*2, 15, 1, 1)
    self.nexMagDef = ZLabel:create(parent, "", size.width/2+10+80, 195-55*3, 15, 1, 1)

    return parent
end

function WingInfoPageRight:updateDwnPanel( )
	local isShowOther = WingModel:getIsShowOtherWing()
	local curAttr = nil
	local curAddAttr = nil
	local nexAttr = nil
	local nexAddAttr = nil
	if not isShowOther then
		curAttr = WingModel:get_curr_attr()
		curAddAttr = WingModel:get_curr_attr_append()
		nexAttr = WingModel:get_next_attr()
		nexAddAttr = WingModel:get_next_attr_append()
	else
		curAttr = WingModel:getOtherWingCurAttr()
		curAddAttr = WingModel:getOtherWingCurAttrAppend()
		nexAttr = WingModel:getOtherWingNexAttr()
		nexAddAttr = WingModel:getOtherWingNexAttrAppend()
	end

	self.hp:setText(string.format("#cffffff%d#cfe8300+%d", curAttr[4], curAddAttr[4]))
	self.attack:setText(string.format("#cffffff%d#cfe8300+%d", curAttr[1], curAddAttr[1]))
	self.phyDef:setText(string.format("#cffffff%d#cfe8300+%d", curAttr[2], curAddAttr[2]))
	self.magDef:setText(string.format("#cffffff%d#cfe8300+%d", curAttr[3], curAddAttr[3]))

	self.nexHp:setText(string.format("#cffffff%d#cfe8300+%d", nexAttr[4], nexAddAttr[4]))
	self.nexAttack:setText(string.format("#cffffff%d#cfe8300+%d", nexAttr[1], nexAddAttr[1]))
	self.nexPhyDef:setText(string.format("#cffffff%d#cfe8300+%d", nexAttr[2], nexAddAttr[2]))
	self.nexMagDef:setText(string.format("#cffffff%d#cfe8300+%d", nexAttr[3], nexAddAttr[3]))
end

function WingInfoPageRight:update( updateType )
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "fight" then
		-- 更新战斗力
		local fight = WingModel:get_curr_wing_score()
		self.fightVal:init(tostring(fight))
	end
end

-- 如果是查看他人的翅膀，则隐藏一些东西
function WingInfoPageRight:setIsShowOtherWing( showOther )
	for k,v in pairs(_NO_OTHER_SHOW) do
		if v then
			v:setIsVisible(not showOther)
		end
	end
end

function WingInfoPageRight:destroy( )
	_NO_OTHER_SHOW = {}
end