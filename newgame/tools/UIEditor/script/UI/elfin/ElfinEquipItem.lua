-- ElfinEquipItem.lua
-- created by yongrui.liang on 2014-8-31
-- 式神一件装备

super_class.ElfinEquipItem()

function ElfinEquipItem:__init( )
	local equipItem = SlotItem(64, 64)
	equipItem:set_icon_bg_texture(UIPIC_ITEMSLOT, -4, -4, 72, 72)

	-- 显示未开放图片
	local notOpenImg = ZImage:create(equipItem.view, UIPIC_ITEMSLOT_DISABLE, -4, -4, -1, -1, 10).view
	notOpenImg:setIsVisible(true)

	local notOpenStr1 = ZLabel:create(notOpenImg, "", 35, 40, 13, 2)
	local notOpenStr2 = ZLabel:create(notOpenImg, "", 35, 20, 13, 2)

	-- 装备的品质框
	local colorFrame = ZImage:create(equipItem.view, "", -2, -2, 68, 68, 3, 500, 500).view
	colorFrame:setIsVisible(false)

	-- 向上标志
	local upImg = ZImage:create(equipItem.view, "ui/elfin/37.png", 0, 0, -1, -1, 5).view
	upImg:setIsVisible(false)

	local lockPanel = CCBasePanel:panelWithFile( -2, -2, 68, 68, nil, 500, 500 )
	equipItem.view:addChild(lockPanel, 9)
	local black = CCArcRect:arcRectWithColor(0, 0, 68, 68, 0x000000bb)
	lockPanel:addChild(black)
	lockPanel:setIsVisible(false)
	lockPanel:setDefaultMessageReturn(true)
	black:setDefaultMessageReturn(true)
	ZLabel:create(lockPanel, "熔炼", 34, 40, 15, 2, 2)
	ZLabel:create(lockPanel, "锁定", 34, 15, 15, 2, 2)

	self.item = equipItem
	self.view = equipItem.view
	self.notOpenSign = notOpenImg
	self.colorFrame = colorFrame
	self.upSign = upImg
	self.lockPanel = lockPanel
	self.open = false
	self.index = 1
	self.quality = nil
	self.typeId = nil
	self.count = 1
	self.lock = false
	self.notOpenStr = {notOpenStr1, notOpenStr2}
end

function ElfinEquipItem:initItem( )
	self:setIcon(nil)
	self:setOpenStatus(false)
	self:setQuality(nil)
	self:setClickFun(nil)
	self:setDoubleClickFun(nil)
	self:setUpSignEnabled(false)
	self:setItemLocked(false)
end

function ElfinEquipItem:setIcon( typeId )
	if typeId then
		local itemIcon = ElfinConfig:getEquipIconByType(typeId)
		if itemIcon then
			self.item:set_icon_texture(itemIcon)
			self.item:set_select_effect_state(true)
			self.typeId = typeId
			return
		end
	end
	self.item:set_icon_texture("")
	self.item:set_select_effect_state(false)
end

function ElfinEquipItem:getType( )
	return self.typeId
end

function ElfinEquipItem:setOpenStatus( status, strT )
	if status then
		self.notOpenSign:setIsVisible(false)
		self.open = true
		for i,v in ipairs(self.notOpenStr) do
			v:setText("")
		end
	else
		self.notOpenSign:setIsVisible(true)
		self.open = false
		if strT then
			for i,v in ipairs(self.notOpenStr) do
				v:setText(strT[i] or "")
			end
		else
			for i,v in ipairs(self.notOpenStr) do
				v:setText("")
			end
		end
	end
end

function ElfinEquipItem:getOpenStatus( )
	return self.open
end

function ElfinEquipItem:setQuality( qlty )
	if qlty then
		local colorImg = ElfinConfig:getColorFrameImgByQlty(qlty)
		if colorImg then
			self.colorFrame:setIsVisible(true)
			self.colorFrame:setTexture(colorImg)
			self.quality = qlty
			return
		end
	end
	self.colorFrame:setIsVisible(false)
	self.quality = nil
end

function ElfinEquipItem:getQuality( )
	return self.quality
end

function ElfinEquipItem:setIndex( idx )
	self.index = idx
end

function ElfinEquipItem:getIndex( )
	return self.index
end

function ElfinEquipItem:setCount( count )
	self.item:set_item_count(count)
	self.count = count
end

function ElfinEquipItem:getCount( )
	return self.count
end

function ElfinEquipItem:update( data )
	if data then
		self:setOpenStatus(true)
		self:setIcon(data.itemType)
		self:setQuality(data.itemQlty)
		self:setCount(data.itemNum or 1)
	else
		self:setIcon(nil)
		self:setQuality(nil)
		self:setCount(1)
		self:setClickFun(nil)
		self:setDoubleClickFun(nil)
	end
end

function ElfinEquipItem:copyFrom( other )
	if other then
		self:setIndex(other:getIndex())
		self:setOpenStatus(other:getOpenStatus())
		self:setIcon(other:getType())
		self:setQuality(other:getQuality())
	else
		self:setIcon(nil)
		self:setQuality(nil)
		self:setCount(1)
		self:setClickFun(nil)
		self:setDoubleClickFun(nil)
	end
end

function ElfinEquipItem:setClickFun( fun )
	self.item:set_click_event(fun)
end

function ElfinEquipItem:setDoubleClickFun( fun )
	self.item:set_double_click_event(fun)
end

function ElfinEquipItem:setUpSignEnabled( enabled )
	if enabled then
		self.upSign:setIsVisible(true)
	else
		self.upSign:setIsVisible(false)
	end
end

function ElfinEquipItem:setItemLocked( isLocked )
	if isLocked then
		self.lockPanel:setIsVisible(true)
		self.lock = true
	else
		self.lockPanel:setIsVisible(false)
		self.lock = false
	end
end

function ElfinEquipItem:getItemLocked( )
	return self.lock
end
