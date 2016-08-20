---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------按钮类
super_class.Button(AbstractBasePanel)
---------
---------
local function ButtonCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
		tImageUp = ""
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
	------print("image",image)
	if type(image) == 'table' and  #image > 1 then
		tImageUp = image[1]
		tImageDown = image[2]
	else
		tImageUp = image
	end
	---------
	-- ----print("tHeight",tHeight)
	-- ----print("tImageUp",tImageUp)
	self.view = CCNGBtnMulTex:buttonWithFile(tPosX, tPosY, tWidth, tHeight, tImageUp, TYPE_MUL_TEX, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	if tImageDown ~= nil then
		self.view:addTexWithFile(CLICK_STATE_DOWN, tImageDown)
	end
end
---------
---------
function Button:__init(fatherPanel)
end
---------
---------按钮类中image项可为一个list
---------当image长度大于2时第一张为TOUCH_UP状态图片，第二张为TOUCH_DOWN状态图片。
---------当image长度小于等于1时,image为TOUCH_UP状态图片
function Button:create(fatherPanel, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = Button(fatherPanel)
	ButtonCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	return sprite
end
---------
---------添加对应状态图片
function Button:addImage(state, image)
	if self.view ~= nil then
		self.view:addTexWithFile(state, image)
	end
end
---------
---------添加对应状态变灰图片
function Button:addGrayImage(state, image)
	if self.view ~= nil then
		self.view:addTexWithFileEx(state, TYPE_GRAY, image)
	end
end