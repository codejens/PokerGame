---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
super_class.ZListVertical(ZAbstractBasePanel)
---------
---------
local function ListVerticalCreateFunction(self, width, height, x, y)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = 0
	end
	if height == nil then
		tHeight = 0
	end
	---------
	self.view = CCBasePanel:panelWithFile(tPosX, tPosY, tWidth, tHeight, "" )
end
---------
---------
function ZListVertical:__init(fatherPanel)
	self.father_panel = fatherPanel
	self.sizeInfo = nil
	self.spriteInfo = {}
	self.curIndex = 0
	self.verticalAlignment = 2
	self.horizontalAlignment = 2
end
---------
---------verticalAlignment 1:代表向左对齐 2：代表中对齐 3：代表向右对齐
---------horizontalAlignment 1:代表向下对齐 2：代表中对齐 3：代表向上对齐
function ZListVertical:create(fatherPanel, x, y, width, height, sizeInfo, verticalAlignment, horizontalAlignment)
	local sprite = ZListVertical(fatherPanel)
	self.sizeInfo = sizeInfo
	local va = verticalAlignment
	local ha = horizontalAlignment
	if va == nil then
		va = 2
	end
	if ha == nil then
		ha = 2
	end
	ListVerticalCreateFunction(sprite, width, height, x, y)
	sprite:registerScriptFun()
	sprite.verticalAlignment = va
	sprite.horizontalAlignment = ha
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			fatherPanel.view:addChild( sprite.view )
		else
			fatherPanel:addChild( sprite.view )
		end
	end
	return sprite
end
---------
---------
function ZListVertical:addItem(item, adjustx, adjusty)
	local temp_adjust_x = adjustx
	local temp_adjust_y = adjusty
	if adjustx == nil then
		temp_adjust_x = true
	end
	if adjusty == nil then
		temp_adjust_y = true
	end
	if self.view ~= nil and self.curIndex < #self.sizeInfo then
		local selfsize = self.view:getSize()
		local itemsize = item.view:getSize()
		local curposx = 0
		local curposy = 0
		local lastindex = #self.spriteInfo + 1
		if self.curIndex > 0 then
			for i = 1 , self.curIndex do
				curposx = curposx + self.sizeInfo[i]
			end
		end
		if self.verticalAlignment == 2 and temp_adjust_x then
			curposx = curposx + ( self.sizeInfo[lastindex] - itemsize.width ) / 2
		elseif self.verticalAlignment == 3 and temp_adjust_x then
			curposx = curposx + self.sizeInfo[lastindex] - itemsize.width
		end
		if self.horizontalAlignment == 2 and temp_adjust_y then
			curposy = ( selfsize.height - itemsize.height ) / 2
		elseif self.horizontalAlignment == 3 and temp_adjust_y then
			curposy = selfsize.height - itemsize.height
		end
		item:setPosition(curposx, curposy)
		self.view:addChild(item.view)
		table.insert(self.spriteInfo, item)
		--self.spriteInfo[self.curIndex] = item
		self.curIndex = self.curIndex + 1
	end
end
---------
---------
function ZListVertical:addItemEx(item)
	if self.view ~= nil and self.curIndex < #self.sizeInfo then
		local curposx = 0
		local curposy = 0
		if self.curIndex > 0 then
			for i = 1 , self.curIndex do
				curposx = curposx + self.sizeInfo[i]
			end
		end
		item:setPosition(curposx, curposy)
		self.view:addChild(item)
		self.spriteInfo[self.curIndex] = item
		self.curIndex = self.curIndex + 1
	end
end
---------
---------
function ZListVertical:getIndexItem(index)
	-- print("#self.spriteInfo",#self.spriteInfo)
	-- print("index",index)
	if #self.spriteInfo >= index then
		return self.spriteInfo[index]
	else
		return nil
	end
end

function ZListVertical:addItemNew(item)
	-- body
	if self.view ~= nil and self.curIndex < #self.sizeInfo then
		local selfsize = self.view:getSize()
		local itemsize = item.view:getSize()
		local curposx = 0
		local curposy = ( selfsize.height - itemsize.height ) / 2;

		-- 设定x坐标
		if self.curIndex >= 0 then
			curposx = self.sizeInfo[self.curIndex+1]
		end

		item:setPosition(curposx, curposy)
		self.view:addChild(item.view)
		self.spriteInfo[self.curIndex] = item
		self.curIndex = self.curIndex + 1
	end
end