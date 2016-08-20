---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------图像图像类
super_class.ImageImage(AbstractBasePanel)
---------
---------
local function ImageImageCreateFunction(self, width, height, x, y, image, image_bg, sw, sh)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tImage = image
	local tImage_bg = image_bg
	local tSw = sw
	local tSh = sh
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = -1
	end
	if height == nil then
		tHeight = -1
	end
	if image == nil then
		tImage = ""
	end
	if image_bg == nil then
		tImage_bg = ""
	end
	if sw == nil then
		tSw = 0
	end
	if sh == nil then
		tSh = 0
	end
	--float posx, float posy, float sizew, float sizeh, const char *file
	--float posx, float posy, const char *text = "", unsigned char fontsize = g_ucDefaultFontSize, FONTALIGN aligntype = ALIGN_LEFT
	self.view = CCZXImage:imageWithFile( tPosX, tPosY, tWidth, tHeight, tImage_bg, tSw, tSh )
	local image_bg_size = self.view:getSize()
	self.image = CCZXImage:imageWithFile( 0, 0, -1, -1, tImage)
	local image_size = self.image:getSize()
	self.image:setPosition( (image_bg_size.width - image_size.width) / 2, (image_bg_size.height - image_size.height) / 2 )
	self.view:addChild(self.image)
end
---------
---------
function ImageImage:__init(fatherPanel)
	self.check_button = nil
end
---------
---------参数说明：x、y代表位置。width、height代表图片长宽,image代表图片路径,text代表文本内容,fontSize代表文本字体字号
function ImageImage:create(fatherPanel, x, y, width, height, image, image_bg, sw, sh)
	local sprite = ImageImage(fatherPanel)
	ImageImageCreateFunction(sprite, width, height, x, y, image, image_bg, sw, sh)
	--sprite:registerScriptFun()
	return sprite
end
---------
---------
function ImageImage:setGapSize(x, y)
	if self.image ~= nil then
		local image_pos = self.image:getPositionS()
		self.image:setPosition( image_pos.x + x, image_pos.y + y )
	end
end