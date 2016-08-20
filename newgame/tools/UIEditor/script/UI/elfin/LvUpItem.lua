-- LvUpItem.lua
-- created by yongrui.liang on 2014-8-25
-- 升级装备页面

super_class.LvUpItem()

function LvUpItem:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	-- 上面板
    local upPanel = self:createUpPanel(320, 340)
    upPanel:setPosition(10, 215)
    panel:addChild(upPanel)

    -- 下面板
    local dwnPanel = self:createDwnPanel(320, 200)
    dwnPanel:setPosition(10, 10)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function LvUpItem:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	
	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	local bg = ZImage:create(parent, "ui/elfin/14.png", width/2, height, -1, -1).view
	bg:setAnchorPoint(0.5, 1.0)

	local skillBg = ZImage:create(parent, "ui/common/wzk-4.png", width/2, height-108, -1, -1).view
	skillBg:setAnchorPoint(0.5, 0)

	self.curLvItem = ElfinEquipItem()
	self.curLvItem.view:setAnchorPoint(0.5, 0)
	self.curLvItem.view:setPosition(width/2, height-90)
	parent:addChild(self.curLvItem.view)

	self.curNameAndLv = ZLabel:create(parent, "", width/2, height-132, 17, 2)
	self.curAttrLimit = ZLabel:create(parent, "", width/2, height-157, 17, 2)

	-- 提升按钮
	local upgradeBtn = ZTextButton.new("ui/common/button3.png", nil, nil, "提  升")
	upgradeBtn.view:setAnchorPoint(0.5, 0)
	upgradeBtn:setPosition(width/2, 110)
	parent:addChild(upgradeBtn.view)
	local upgradeFunc = function( )
		print('-- upgradeBtn clicked --')
		ElfinModel:reqLevelUpEquip()
	end
	upgradeBtn:setTouchClickFun(upgradeFunc)

	self.curSmeltTxt = ZLabel:create(parent, "#cf1e7d4当前熔炼值：", width/2+10, 85, 16, 3)
	self.curSmeltVal = ZLabel:create(parent, "", width/2+10, 85, 16, 1)
	self.needSmeltTxt = ZLabel:create(parent, "#cf1e7d4需要熔炼值：", width/2+10, 55, 16, 3)
	self.needSmeltVal = ZLabel:create(parent, "", width/2+10, 55, 16, 1)
	self.needMoneyTxt = ZLabel:create(parent, "#cf1e7d4需要忍币：", width/2+10, 25, 16, 3)
	self.needMoney = ZLabel:create(parent, "", width/2+10, 25, 16, 1)

	self.noEquipmentTips = ZImage:create(parent, "ui/elfin/45.png", width/2, 50).view
	self.noEquipmentTips:setAnchorPoint(0.5, 0.5)
	self.noEquipmentTips:setIsVisible(false)

	return parent
end

function LvUpItem:playLvUpEffect( parent, x, y )
    LuaEffectManager:stop_view_effect(10014, parent)
    LuaEffectManager:play_view_effect(10014, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end

-- 更新上面板
function LvUpItem:updateUpPanel( )
	local leftItem = ElfinModel:getClickElfinItem()
	self.curLvItem:setOpenStatus(true)
	self.curLvItem:copyFrom(leftItem)

	if leftItem then
		self.noEquipmentTips:setIsVisible(false)
		self.curSmeltTxt.view:setIsVisible(true)
		self.needSmeltTxt.view:setIsVisible(true)
		self.needMoneyTxt.view:setIsVisible(true)

		local typeId = leftItem:getType()
		local name = ElfinConfig:getEquipNameByType(typeId)

		local index = leftItem:getIndex()
		local item = ElfinModel:getEquipItemByIndex(index)
		local level = item.itemLevel
		self.curNameAndLv:setText(string.format("#cfff000%s #ce519cb+%d", name, level))

		local attrName = ElfinConfig:getEquipAttrName(typeId)
		local attrVal = ElfinConfig:getEquipAttrVal(typeId, item.itemQlty, level)
		self.curAttrLimit:setText(string.format("#cfff000%s #ce519cb+%d", attrName, attrVal))

		local smelt = ElfinModel:getSmeltVal()
		self.curSmeltVal:setText(string.format("#cfff000%d", smelt))

		local maxLv = ElfinModel:getEquipItemMaxLevel()
		if level >= maxLv then
			level = maxLv - 1
		end
		local needSmelt = ElfinConfig:getEquipLvUpSmelt(typeId, item.itemQlty, level)
		self.needSmeltVal:setText(string.format("#cfff000%d", needSmelt))

		local needMoney = ElfinConfig:getEquipLvUpMoney(typeId, item.itemQlty, level)
		self.needMoney:setText(string.format("#cfff000%d", needMoney))
	else
		self.noEquipmentTips:setIsVisible(true)
		self.curNameAndLv:setText("")
		self.curAttrLimit:setText("")
		self.curSmeltTxt.view:setIsVisible(false)
		self.curSmeltVal:setText("")
		self.needSmeltTxt.view:setIsVisible(false)
		self.needSmeltVal:setText("")
		self.needMoneyTxt.view:setIsVisible(false)
		self.needMoney:setText("")
	end
end

-- 创建下面板
function LvUpItem:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	-- 标题
	local titleBg = ZImage:create(parent, "ui/transform/new24.png", width/2, height-16, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)
    ZLabel:create(parent, "#cfff000属性预览", width/2, height-23, 16, 2)

    ZImage:create(parent, "ui/common/jgt_line.png", 5, 85, width-10, 2)

	self.nexLvItem = ElfinEquipItem()
	self.nexLvItem.view:setPosition(12, 96)
	parent:addChild(self.nexLvItem.view)
	self.nexNameAndLv = ZLabel:create(parent, "", 90, 145, 16, 1)
	self.nexSmeltVal = ZLabel:create(parent, "", 90, 120, 16, 1)
	self.nexAttrLimit = ZLabel:create(parent, "", 90, 95)

	self.maxLvItem = ElfinEquipItem()
	self.maxLvItem.view:setPosition(12, 10)
	parent:addChild(self.maxLvItem.view)
	self.maxNameAndLv = ZLabel:create(parent, "", 90, 145-82, 16, 1)
	self.maxSmeltVal = ZLabel:create(parent, "", 90, 120-82, 16, 1)
	self.maxAttrLimit = ZLabel:create(parent, "", 90, 95-82)

	return parent
end

-- 更新下面板
function LvUpItem:updateDwnPanel( )
	local leftItem = ElfinModel:getClickElfinItem()
	self.nexLvItem:setOpenStatus(true)
	self.maxLvItem:setOpenStatus(true)
	self.nexLvItem:copyFrom(leftItem)
	self.maxLvItem:copyFrom(leftItem)

	if leftItem then
		local typeId = leftItem:getType()
		local name = ElfinConfig:getEquipNameByType(typeId)
		local attrName = ElfinConfig:getEquipAttrName(typeId)

		local index = leftItem:getIndex()
		local item = ElfinModel:getEquipItemByIndex(index)

		local maxLv = ElfinModel:getEquipItemMaxLevel()
		local nexLv = item.itemLevel + 1
		if nexLv > maxLv then
			nexLv = maxLv
		end
		self.nexNameAndLv:setText(string.format("#cfff000%s #ce519cb+%d", name, nexLv))
		self.maxNameAndLv:setText(string.format("#cfff000%s #ce519cb+%d", name, maxLv))

		local nexSmelt = ElfinConfig:getEquipSmeltByLevel(typeId, item.itemQlty, nexLv)
		self.nexSmeltVal:setText(string.format("#cf1e7d4熔炼值：#cfff000%d", nexSmelt))

		local nexAttrVal = ElfinConfig:getEquipAttrVal(typeId, item.itemQlty, nexLv)
		self.nexAttrLimit:setText(string.format("#cf1e7d4效  果：#cfff000%s #ce519cb+%d", attrName, nexAttrVal))

		local maxSmelt = ElfinConfig:getEquipSmeltByLevel(typeId, item.itemQlty, maxLv)
		self.maxSmeltVal:setText(string.format("#cf1e7d4熔炼值：#cfff000%d", maxSmelt))

		local maxAttrVal = ElfinConfig:getEquipAttrVal(typeId, item.itemQlty, maxLv)
		self.maxAttrLimit:setText(string.format("#cf1e7d4效  果：#cfff000%s #ce519cb+%d", attrName, maxAttrVal))
	else
		self.nexNameAndLv:setText("")
		self.maxNameAndLv:setText("")
		self.nexSmeltVal:setText("")
		self.nexAttrLimit:setText("")
		self.maxSmeltVal:setText("")
		self.maxAttrLimit:setText("")
	end
end

function LvUpItem:update( updateType )
	print('-- LvUpItem:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
    elseif updateType == "LvUpEffect" then
        self:playLvUpEffect(self.view, 190+15-32, 446-15+54)
    elseif updateType == "dropEquipment" then
    	self:updateUpPanel()
		self:updateDwnPanel()
	end
end

function LvUpItem:destroy( )
end