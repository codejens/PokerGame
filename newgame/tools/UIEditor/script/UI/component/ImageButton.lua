---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文字图像
super_class.ImageButton(AbstractBasePanel)
---------
---------
local function ImageButtonCreateFunction(self, width, height, x, y, image_bg, image, fontSize, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tTopLeftWidth = topLeftWidth
	local tTopLeftHeight = topLeftHeight
	local tTopRightWidth = topRightWidth
	local tTopRightHeight = topRightHeight
	local tBottomLeftWidth = bottomLeftWidth
	local tBottomLeftHeight = bottomLeftHeight
	local tBottomRightWidth = bottomRightWidth
	local tBottomRightHeight = bottomRightHeight
	local tFontSize = fontSize
	local tImage = image
	local tImage_bg = image_bg
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
	if fontSize == nil then
		tFontSize = 16
	end
	if image_bg == nil then
		tImage_bg = ""
	end
	---------
	require "UI/component/Image"
	require "UI/component/Button"
	local image = Image:create(nil, 0, 0, -1, -1, tImage)
	local imagesize = image:getSize()
	self.image = image
	local button = Button:create(nil, tPosX, tPosY, tWidth, tHeight, tImage_bg, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	local buttonsize = button:getSize()
	image:setPosition( (buttonsize.width - imagesize.width) / 2, (buttonsize.height - imagesize.height) / 2 )
	button.view:addChild(image.view)
	self.view = button.view
end
---------
---------
function ImageButton:__init(fatherPanel)
end
---------
---------
function ImageButton:create(fatherPanel, x, y, width, height, image_bg, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ImageButton(fatherPanel)
	ImageButtonCreateFunction( sprite, width, height, x, y, image_bg, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	return sprite
end
---------
---------
function ImageButton:set_image_gapsize(x, y)
	if self.image ~= nil then
		local image_pos = self.image:getPosition()
		self.image:setPosition( image_pos.x + x, image_pos.y + y)
	end
end