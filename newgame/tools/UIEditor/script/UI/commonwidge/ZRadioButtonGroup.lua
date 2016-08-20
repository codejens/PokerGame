---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------单选按钮组
super_class.ZRadioButtonGroup(ZAbstractBasePanel)
---------
---------
local function RadioButtonCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tImage = image
	local tTopLeftWidth = topLeftWidth
	local tTopLeftHeight = topLeftHeight
	local tTopRightWidth = topRightWidth
	local tTopRightHeight = topRightHeight
	local tBottomLeftWidth = bottomLeftWidth
	local tBottomLeftHeight = bottomLeftHeight
	local tBottomRightWidth = bottomRightWidth
	local tBottomRightHeight = bottomRightHeight
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
	if image == nil then
		tImage = ""
	end
	if topLeftWidth == nil then
		tTopLeftWidth = 0
	end
	if topLeftHeight == nil then
		tTopLeftHeight = 0
	end
	if topRightWidth == nil then
		tTopRightWidth = 0
	end
	if topRightHeight == nil then
		tTopRightHeight = 0
	end
	if bottomLeftWidth == nil then
		tBottomLeftWidth = 0
	end
	if bottomLeftHeight == nil then
		tBottomLeftHeight = 0
	end
	if bottomRightWidth == nil then
		tBottomRightWidth = 0
	end
	if bottomRightHeight == nil then
		tBottomRightHeight = 0
	end
	---------
	self.view = CCRadioButtonGroup:buttonGroupWithFile( tPosX, tPosY, tWidth, tHeight, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	
end
---------
---------
function ZRadioButtonGroup:__init(fatherPanel, addType)
	self.father_panel = fatherPanel
	self.click_num = 0
	if addType == nil then
		addType = 0
	end
	self.add_type = addType
	self.item_group = {}
end
---------
---------addType == 0 时为横向 addType == 1 时为纵向
function ZRadioButtonGroup:create(fatherPanel, x, y, width, height, addType, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZRadioButtonGroup(fatherPanel, addType)
	RadioButtonCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
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
function ZRadioButtonGroup:getCurSelect()
	if self.view ~= nil then 
		return self.view:getCurSelect()
	else
		return nil
	end
end
---------
---------
function ZRadioButtonGroup:selectItem(index)
	if self.view ~= nil then 
		self.view:selectItem(index)
	end
end
---------
---------如果addType == 1 时X轴会居中
function ZRadioButtonGroup:addItem(item, grap, addType, itemSelect)
	local tSelect
	local tGrap = grap
	if grap == nil then
		tGrap = 0
	end
	if addType == nil then
		addType = 0
	end
	if itemSelect ~= nil then
		tSelect = true
	else
		tSelect = false
	end
	if self.view ~= nil then
		local tempsprite = self.view:getIndexItem(-1)
		local selfSize = self.view:getSize()
		local itemSize = item.view:getSize()
		if tempsprite ~= nil and tempsprite ~= nil then
			local temppos = tempsprite:getPositionS()
			local tempsize = tempsprite:getSize()
	
			if self.add_type == 0 then
				item.view:setPosition(temppos.x + tempsize.width + tGrap, temppos.y)
			else
				if addType == 1 then
					item.view:setPosition( (selfSize.width - itemSize.width) / 2, temppos.y - tempsize.height - tGrap )
				else
					item.view:setPosition(temppos.x , temppos.y - tempsize.height - tGrap)
				end
			end
		else
			if addType == 1 then
				item.view:setPosition( (selfSize.width - itemSize.width) / 2, self.view:getSize().height - item.view:getSize().height)
			else
				item.view:setPosition(0, self.view:getSize().height - item.view:getSize().height)
			end
		end
		self.view:addGroup(item.view, tSelect)
		table.insert(self.item_group, item)
	end
end
---------
---------
function ZRadioButtonGroup:getCurNum()
	if self.view ~= nil then
		return self.view:getCurNum()
	else
		return nil
	end
end
---------
---------
function ZRadioButtonGroup:getIndexItem(index)
	if self.view ~= nil then
		return self.item_group[index + 1]
	else
		return nil
	end
end

function ZRadioButtonGroup:setGrap( grap )
    self.grap = grap;
end
