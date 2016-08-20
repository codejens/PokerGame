---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文字按钮类
super_class.TextButton(AbstractBasePanel)
---------
---------
local function TextButtonCreateFunction(self, width, height, x, y, text, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tImageUp = ""
	local tImageDown = nil
	local tTopLeftWidth = topLeftWidth
	local tTopLeftHeight = topLeftHeight
	local tTopRightWidth = topRightWidth
	local tTopRightHeight = topRightHeight
	local tBottomLeftWidth = bottomLeftWidth
	local tBottomLeftHeight = bottomLeftHeight
	local tBottomRightWidth = bottomRightWidth
	local tBottomRightHeight = bottomRightHeight
	local tText = text
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
		image = ""
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
	if text == nil then
		tText = ""
	end
	if type(image) == 'table' and  #image > 1 then
		tImageUp = image[1]
		tImageDown = image[2]
	else
		tImageUp = image
	end
	---------
	self.view = CCTextButton:textButtonWithFile( tPosX, tPosY, tWidth, tHeight, tText, tImageUp, TYPE_MUL_TEX, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	if tImageDown ~= nil then
		self.view:addTexWithFile(CLICK_STATE_DOWN, tImageDown)
	end
end
---------
---------
function TextButton:__init(fatherPanel)
end
---------
---------
function TextButton:create(fatherPanel, x, y, width, height, text, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = TextButton(fatherPanel)
	TextButtonCreateFunction(sprite, width, height, x, y, text, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	return sprite
end	
---------
---------设置文字
function TextButton:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文字大小，当文字大于图片大小时，文字左下角位置处于，图片左下角1/10位置
function TextButton:setFontSize(size)
	if self.view ~= nil then
		self.view:setFontSize(size)
	end
end
---------
---------取得文字内容
function TextButton:getText()
	if self.view ~= nil then
		return self.view:getText()
	end
end