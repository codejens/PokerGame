---------liuguowang
---------2014.3.26
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------下拉控件
---------
---------
local function ComBoxCreateFunction(self, width, height, x, y, image_bg,image_pullDown, fontSize, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
	-- local tImage = image
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
	-- if image == nil then
	-- 	tImage = ""
	-- end
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
		tImage_bg = UIPIC_GRID_nine_grid_bg3
	end
	if image_pullDown == nil then
		image_pullDown = UIResourcePath.FileLocate.common .. "xiala.png"
	end
	---------
	require "UI/commonwidge/ZRadioButtonGroup"
	require "UI/commonwidge/ZTextButton"
    

    local text_image_bg = ZBasePanel:create( nil, tImage_bg,  x, y, width, height, 600, 600 )
	local text_image_bg_size = text_image_bg:getSize()
	local function click_fun()
		if self.click_control ~= nil then
			if self.isPull == nil or self.isPull == false then
				self.isPull = true --已下拉状态
			else
				self.isPull = false --收起状态
			end
			self.click_control(self.isPull);
		end
	end
	text_image_bg:setTouchClickFun(click_fun)

    local pullDown_image = ZImage:create( text_image_bg, image_pullDown,nil,0,0,-1,-1)
	local pullDown_image_size = pullDown_image:getSize()
	pullDown_image.view:setPosition(text_image_bg_size.width - pullDown_image_size.width,0)

    ZImage:create( nil, image_pullDown, 236+100, 147, -1, -1 )

	local image = ZImage:create(nil, tImage, 0, 0, -1, -1 )



	self.view = button.view
end
---------
---------
function ZCombox:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZCombox:create(fatherPanel, image_bg,image_pullDown, fun, x, y, width, height, z, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZCombox(fatherPanel)
	ComBoxCreateFunction( sprite, width, height, x, y, image_bg,image_pullDown, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
function ZCombox:set_image_gapsize(x, y)
	if self.image ~= nil then
		local image_pos = self.image:getPosition()
		self.image:setPosition( image_pos.x + x, image_pos.y + y)
	end
end

function ZCombox:set_image_texture( path )
	self.image.view:removeFromParentAndCleanup(true);
	self.image = ZImage:create(self.view, path, 0, 0, -1, -1 )
	local imagesize = self.image:getSize()
	local buttonsize = self.view:getSize()
	self.image.view:setPosition( (buttonsize.width - imagesize.width) / 2, (buttonsize.height - imagesize.height) / 2 )
end


--点击控件开始下拉响应的
function ZCombox:set_click_control_event( fn )
	self.click_control = fn;
end

--点击选择某项响应的
function ZCombox:set_click_control_event( fn )
	self.click_item = fn;
end