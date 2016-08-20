---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文字按钮类
super_class.ZTextButton(ZAbstractBasePanel)

ZTextButton.STYLE_TEXT_BTN_TWO = 1;
ZTextButton.STYLE_TEXT_BTN_THREE = 2;
ZTextButton.STYLE_TEXT_BTN_FOUR = 3;
ZTextButton.STYLE_TEXT_BTN_RED_TWO = 4;
local BTN_PATH = { 
	[UISTYLE_ZTEXTBUTTON_TWO_WORD] = UILH_COMMON.lh_button2,
	[UISTYLE_ZTEXTBUTTON_THREE_WORD] = UILH_COMMON.btn4_nor,
	[UISTYLE_ZTEXTBUTTON_FOUR_WORD] = UILH_COMMON.btn4_nor, --程序字按钮
	[UISTYLE_ZTEXTBUTTON_RED_TWO_WORD] = UILH_COMMON.button2_sel,
	[UISTYLE_ZTEXTBUTTON_MARRIAGE] = UILH_COMMON.button2_sel,
}
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
		tWidth = -1
	end
	if height == nil then
		tHeight = -1
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
function ZTextButton:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZTextButton:create(fatherPanel, text, image, fun, x, y, width, height, z, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZTextButton(fatherPanel)
	TextButtonCreateFunction(sprite, width, height, x, y, text, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
---------设置文字
function ZTextButton:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文字大小，当文字大于图片大小时，文字左下角位置处于，图片左下角1/10位置
function ZTextButton:setFontSize(size)
	if self.view ~= nil then
		self.view:setFontSize(size)
	end
end
---------
---------取得文字内容 
function ZTextButton:getText()
	if self.view ~= nil then
		return self.view:getText()
	end
end

-- 新的创建函数
function ZTextButton.new( imageUp, imageDown, imageDisable, text )

	local tImageUp 	= imageUp or ""
	local tText		= text or ""
	local tWidth 	= 64
	local tHeight 	= 64

	if imageUp then
		local tempSize = ZXResMgr:sharedManager():getTextureSize(imageUp)
		tWidth = tempSize.width
		tHeight = tempSize.height
	end

	local button = ZTextButton()
	button.view  = CCTextButton:textButtonWithFile( 0, 0, tWidth, tHeight, tText, tImageUp, TYPE_MUL_TEX, 0, 0, 0, 0, 0, 0, 0, 0)

	if imageDown and imageDown ~= "" then
		button.view:addTexWithFile(CLICK_STATE_DOWN, imageDown)
	end

	if imageDisable and imageDisable ~= "" then
		button.view:addTexWithFile(CLICK_STATE_DISABLE, imageDisable)
	end

	button:registerScriptFun()

	return button
end

-- 通用按钮一(两个字)
local TEXTBUTTON_STYLE_1 = { up 	= UIResourcePath.FileLocate.common.."button2.png",
							 down 	= UIResourcePath.FileLocate.common.."button2.png",
							 disable= UIResourcePath.FileLocate.common.."button2.png", }
function ZTextButton.create_style_1( text )
	text = text or ""
	local button = ZTextButton.new( TEXTBUTTON_STYLE_1.up,
									TEXTBUTTON_STYLE_1.down,
									TEXTBUTTON_STYLE_1.disable,
									text )
	return button
end

-- 通用按钮二(四个字)
local TEXTBUTTON_STYLE_2 = { up 	= UIResourcePath.FileLocate.common.."button3.png",
							 down 	= UIResourcePath.FileLocate.common.."button3.png",
							 disable= UIResourcePath.FileLocate.common.."button3.png", }
function ZTextButton.create_style_2( text )
	text = text or ""
	local button = ZTextButton.new( TEXTBUTTON_STYLE_2.up,
									TEXTBUTTON_STYLE_2.down,
									TEXTBUTTON_STYLE_2.disable,
									text )
	return button
end						

-- add by chj tjxs
function ZTextButton:addImage(state, image)
	if self.view ~= nil then
		self.view:addTexWithFile(state, image)
		self.view:setCurState(state)
	end
end

---------------------------------------------------------------------
--------创建样式按钮
---------------------------------------------------------------------
function ZTextButton:createByStyle( _style ,layout)
	local path = BTN_PATH[ _style ]
	if path then
		local btn = ZTextButton()
		TextButtonCreateFunction(btn, -1, -1, layout.posX, layout.posY, layout.text, path)
		btn:registerScriptFun()	
		return btn	
	else
		print("ZTextButton:没有这种样式",_style)
	end
end
