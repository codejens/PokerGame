---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------半透明面板
super_class.ArcRect(AbstractBasePanel)
---------
---------
local function ArcRectCreateFunction(self, width, height, x, y, color)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tColor = color
	---------
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
	if color == nil then
		tColor = 0xffffff
	end
	---------
	self.view = CCArcRect:arcRectWithColor( tPosX, tPosY, tWidth, tHeight, tColor)
end
---------
---------
function ArcRect:__init(fatherPanel)
end
---------
---------说明：color为RGBA
function ArcRect:create(fatherPanel, x, y, width, height, color)
	local sprite = ArcRect(fatherPanel)
	ArcRectCreateFunction( sprite, width, height, x, y, color)
	sprite:registerScriptFun()
	return sprite
end
---------
---------设置颜色
function ArcRect:setColor(color)
	if self.view ~= nil then
		self.view:setColor(color)
	end
end
---------
---------取得颜色
function ArcRect:getColor()
	if self.view ~= nil then
		return self.view:getColor()
	end
end
