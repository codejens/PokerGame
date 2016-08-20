---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------列表类
super_class.List(AbstractBasePanel)
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
function List:__init(fatherPanel)
end
---------
---------
function List:create(fatherPanel, x, y, width, height, vertical, horizontal, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = List(fatherPanel)
	ListCreateFunction(sprite, width, height, x, y, vertical, horizontal, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	return sprite
end
---------
---------取得
function List:getVertical()
	if self.view ~= nil then
		return self.view:getVertical()
	else
		return 0
	end
end
---------
---------
function List:getHorizontal()
	if self.view ~= nil then
		return self.view:getHorizontal()
	else
		return 0
	end
end
---------
---------添加对像
function List:addItem(item)
	if self.view ~= nil then
		self.view:addItem(item.view)
	end
end
---------
---------添加对像
function List:additemEx(item)
	if self.view ~= nil then
		self.view:addItem(item)
	end
end