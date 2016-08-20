---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文字图像
super_class.ZTextImage(ZAbstractBasePanel)
---------
---------
local function TextImageCreateFunction(self, width, height, fontSize, x, y, text, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
	local tText = text
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
	if text == nil then
		tText = ""
	end
	---------
	require "UI/commonwidge/ZLabel"
	require "UI/commonwidge/ZImage"
	local label = ZLabel:create(nil, tText, 0, 0,  tFontSize,2)
	local labelsize = label:getSize()
	local image = ZImage:create(nil, tImage, tPosX, tPosY, tWidth, tHeight, nil, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	local imagesize = image:getSize()
	label:setPosition( imagesize.width  / 2, (imagesize.height - labelsize.height) / 2 +3)
	image.view:addChild(label.view)
	self.view = image.view
	self.label = label;
end
---------
---------
function ZTextImage:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZTextImage:create(fatherPanel, text, image, fontsize, x, y, width, height, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZTextImage(fatherPanel)
	TextImageCreateFunction( sprite, width, height, fontsize, x, y, text, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			fatherPanel.view:addChild( sprite.view )
		else
			fatherPanel:addChild( sprite.view )
		end
	end
	return sprite
end

function ZTextImage:setText( text )
	self.label:setText(text);
end