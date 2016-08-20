---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文字图像
super_class.ZImageButton(ZAbstractBasePanel)

local BTN_PATH = { 
	[UISTYLE_ZIMAGEBUTTON_TWO_WORD] = UILH_COMMON.tab_gray,
	[UISTYLE_ZIMAGEBUTTON_THREE_WORD] =	UILH_COMMON.tab_gray,
	[UISTYLE_ZIMAGEBUTTON_FOUR_WORD] = UILH_COMMON.tab_gray, --美术字按钮
	[UISTYLE_ZIMAGEBUTTON_TWO_WORD2] = UILH_COMMON.tab_gray,
	[UISTYLE_ZIMAGEBUTTON_RADIOBTN] = { UILH_COMMON.tab_gray, UILH_COMMON.tab_light},
}
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
		tWidth = -1
	end
	if height == nil then
		tHeight = -1
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
	require "UI/commonwidge/ZImage"
	require "UI/commonwidge/ZButton"
	local image = ZImage:create(nil, tImage, 0, 0, -1, -1 )
	local imagesize = image:getSize()
	self.image = image
	local button = ZButton:create(nil, tImage_bg, nil, tPosX, tPosY, tWidth, tHeight, nil, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	local buttonsize = button:getSize()
	image:setPosition( (buttonsize.width - imagesize.width) / 2, (buttonsize.height - imagesize.height) / 2 )
	button.view:addChild(image.view)
	self.view = button.view
end
---------
---------
function ZImageButton:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZImageButton:create(fatherPanel, image_bg, image, fun, x, y, width, height, z, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZImageButton(fatherPanel)
	ImageButtonCreateFunction( sprite, width, height, x, y, image_bg, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			if z ~= nil then 
				fatherPanel.view:addChild( sprite.view, z )
			else
				fatherPanel.view:addChild( sprite.view )
			end
		else
			if z ~= nil then
				fatherPanel:addChild( sprite.view, z )
			else
				fatherPanel:addChild( sprite.view )
			end
		end
	end
	if fun ~= nil then
		sprite:setTouchClickFun( fun )
	end
	return sprite
end
---------
---------
function ZImageButton:set_image_gapsize(x, y)
	if self.image ~= nil then
		local image_pos = self.image:getPosition()
		self.image:setPosition( image_pos.x + x, image_pos.y + y)
	end
end

function ZImageButton:set_image_texture( path )
	self.image.view:removeFromParentAndCleanup(true);
	self.image = ZImage:create(self.view, path, 0, 0, -1, -1 )
	local imagesize = self.image:getSize()
	local buttonsize = self.view:getSize()
	self.image.view:setPosition( (buttonsize.width - imagesize.width) / 2, (buttonsize.height - imagesize.height) / 2 )
end

---------------------------------------------------------------------
--------创建样式按钮
---------------------------------------------------------------------
function ZImageButton:createByStyle( _style,layout )
	-- print("ZImageButton:createByStyle( _style,layout )",_style)
	local path = BTN_PATH[ _style ]
	if path then
		local btn = ZImageButton(fatherPanel)
		ImageButtonCreateFunction( btn, -1, -1, layout.posX, layout.posY, path, layout.image)
		btn:registerScriptFun()
		return btn;	
	else
		print("ZImageButton:没有这种样式",_style)
	end

end
