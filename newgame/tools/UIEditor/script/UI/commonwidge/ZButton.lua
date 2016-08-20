---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------按钮类
super_class.ZButton(ZAbstractBasePanel)
---------
---------
local function ButtonCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x or 0
	local tPosY = y or 0
	local tWidth = width or -1
	local tHeight = height or -1
	local tImageUp = image or ""
	local tImageDown = nil
	local tTopLeftWidth = topLeftWidth or 0
	local tTopLeftHeight = topLeftHeight or 0
	local tTopRightWidth = topRightWidth or 0
	local tTopRightHeight = topRightHeight or 0
	local tBottomLeftWidth = bottomLeftWidth or 0
	local tBottomLeftHeight = bottomLeftHeight or 0
	local tBottomRightWidth = bottomRightWidth or 0
	local tBottomRightHeight = bottomRightHeight or 0


	if type(image) == 'table' and  #image > 1 then
		tImageUp = image[1]
		tImageDown = image[2]
	else
		tImageUp = image
	end
	---------
	self.view = CCNGBtnMulTex:buttonWithFile(tPosX, tPosY, tWidth, tHeight, tImageUp, TYPE_MUL_TEX, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	if tImageDown ~= nil then
		self.view:addTexWithFile(CLICK_STATE_DOWN, tImageDown)
	end
end
---------
---------
function ZButton:__init( fatherPanel )
	self.father_panel = fatherPanel
	-- ButtonCreateFunction(self)
end
---------
---------按钮类中image项可为一个list
---------当image长度大于2时第一张为TOUCH_UP状态图片，第二张为TOUCH_DOWN状态图片。
---------当image长度小于等于1时, image为TOUCH_UP状态图片
function ZButton:create(fatherPanel, image, fun, x, y, width, height, z, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZButton(fatherPanel)
	ButtonCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
---------添加对应状态图片
function ZButton:addImage(state, image)
	if self.view ~= nil then
		self.view:addTexWithFile(state, image)
		self.view:setCurState(state)
	end
end
---------
---------
function ZButton:setImage(image)
	local temp_state = self.view:getCurState()
	local temp_image_file = {}
	if type(image) == 'table' and  #image > 1 then
		for i = 1, #image do
			if i == 1 then
				self:addImage( CLICK_STATE_UP, image[i] )
			elseif i == 2 then
				self:addImage( CLICK_STATE_DOWN, image[i] )
			elseif i == 3 then
				self:addImage( CLICK_STATE_DISABLE, image[i] )
			end
		end
	else
		self:addImage( CLICK_STATE_UP, image )
	end
	self.view:setCurState( temp_state )
end

---------
---------添加对应状态变灰图片
-- function Button:addGrayImage(state, image)
-- 	if self.view ~= nil then
-- 		self.view:addTexWithFileEx(state, TYPE_GRAY, image)
-- 	end
-- end

-- 新的构造函数
function ZButton.new( imageUp, imageDown, imageDisable )

	local tImageUp = imageUp or ""
	local tWidth = 64
	local tHeight = 64

	if imageUp then
		local tempSize = ZXResMgr:sharedManager():getTextureSize(imageUp)
		tWidth = tempSize.width
		tHeight = tempSize.height
	end

	local button = ZButton()
	button.view  = CCNGBtnMulTex:buttonWithFile( 0, 0, tWidth, tHeight, tImageUp, TYPE_MUL_TEX, 0, 0, 0, 0, 0, 0 )

	if imageDown and imageDown ~= "" then
		button.view:addTexWithFile(CLICK_STATE_DOWN, imageDown)
	end

	if imageDisable and imageDisable ~= "" then
		button.view:addTexWithFile(CLICK_STATE_DISABLE, imageDisable)
	end

	button._scale_x = 1
	button._sclae_y = 1
	button:registerScriptFun()

	return button
end
