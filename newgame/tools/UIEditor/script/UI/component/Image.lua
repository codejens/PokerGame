---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------图像类
super_class.Image(AbstractBasePanel)
---------
---------
local function ImageCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
	self.view = CCZXImage:imageWithFile( tPosX, tPosY, tWidth, tHeight, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)

end
---------
---------
function Image:__init(fatherPanel)
end
---------
---------图像类不接收任何消息，所以不用注册消息函数
function Image:create(fatherPanel, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	------print("fatherPanel, x, y, width, height, image",fatherPanel, x, y, width, height, image)
	local sprite = Image(fatherPanel)
	ImageCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	return sprite
end