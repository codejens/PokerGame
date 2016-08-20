---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------列表类
super_class.ZList(ZAbstractBasePanel)
---------
---------
local function ListCreateFunction(self, width, height, x, y, vertical, horizontal, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth ,bottomRightHeight)
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
	local tVertical = vertical
	local tHorizontal = horizontal
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
	if vertical == nil then
		tVertical = 1
	end
	if horizontal == nil then
		tHorizontal = 1
	end
	---------
	self.view = CCZXList:listWithFile( tPosX, tPosY, tWidth, tHeight, tVertical, tHorizontal, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)

end
---------
---------
function ZList:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZList:create(fatherPanel, x, y, width, height, vertical, horizontal, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZList(fatherPanel)
	ListCreateFunction(sprite, width, height, x, y, vertical, horizontal, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
---------取得
function ZList:getVertical()
	if self.view ~= nil then
		return self.view:getVertical()
	else
		return 0
	end
end
---------
---------
function ZList:getHorizontal()
	if self.view ~= nil then
		return self.view:getHorizontal()
	else
		return 0
	end
end
---------
---------添加对像
function ZList:addItem(item)
	if self.view ~= nil then
		self.view:addItem(item.view)
	end
end
---------
---------添加对像
function ZList:additemEx(item)
	if self.view ~= nil then
		self.view:addItem(item)
	end
end