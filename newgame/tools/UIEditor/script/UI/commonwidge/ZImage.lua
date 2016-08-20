---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------图像类
super_class.ZImage(ZAbstractBasePanel)
---------
---------
local function ImageCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x or 0
	local tPosY = y or 0 
	local tWidth = width or -1
	local tHeight = height or -1
	local tImage = image or '' 
	local tTopLeftWidth = topLeftWidth or 0
	local tTopLeftHeight = topLeftHeight or 0
	local tTopRightWidth = topRightWidth or 0
	local tTopRightHeight = topRightHeight or 0
	local tBottomLeftWidth = bottomLeftWidth or 0
	local tBottomLeftHeight = bottomLeftHeight or 0
	local tBottomRightWidth = bottomRightWidth or 0
	local tBottomRightHeight = bottomRightHeight or 0
	---------
	self.view = CCZXImage:imageWithFile( tPosX, tPosY, tWidth, tHeight, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
end
---------
---------
function ZImage:__init(fatherPanel)
	self.father_panel = fatherPanel
	-- ImageCreateFunction(self)
end
---------
---------图像类不接收任何消息，所以不用注册消息函数
function ZImage:create(fatherPanel, image, x, y, width, height, z, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	--print("fatherPanel, x, y, width, height, image",fatherPanel, x, y, width, height, image)
	local sprite = ZImage(fatherPanel)
	ImageCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
	return sprite
end

-- 设置图片
function ZImage:setTexture( texture )
	if self.view ~= nil then
		self.view:setTexture(texture)

		-- edited by aXing on 2014-5-13
		-- 这个考虑是否需要
		if texture then
			local tSize = ZXResMgr:sharedManager():getTextureSize(texture)
			self.view:setSize(tSize.width, tSize.height)
			self.view:setScaleX(self._scale_x or 1.0)
			self.view:setScaleY(self._sclae_y or 1.0)
		end
	end
end

function ZImage:setSize(width, height)
	
	self.view:setSize(width, height)

	local tScaleX = self.view:getSpriteScaleX()
	local tScaleY = self.view:getSpriteScaleY()

	if tScaleX > 0 then
		self._scale_x = tScaleX
	end

	if tScaleY > 0 then 
		self._sclae_y = tScaleY
	end

end

-- 新创建的构造函数
function ZImage.new( texture )

	local tImage = texture or ""
	local tWidth = 64
	local tHeight = 64

	if tImage then
		local tempSize = ZXResMgr:sharedManager():getTextureSize(tImage)
		tWidth = tempSize.width
		tHeight = tempSize.height
	end

	local image = ZImage()
	image.view = CCZXImage:imageWithFile( 0, 0, tWidth, tHeight, tImage, 0, 0, 0, 0, 0, 0, 0, 0 )
	image._scale_x = 1
	image._sclae_y = 1
	return image
end

-- 创建样式
function ZImage:createByStyle( conf )
	local nineArg = 0;
	local width = -1;
	local height = -1;
	local _style = conf.style;
	local layout = conf.layout
	if layout.isNineGrid then
		nineArg = 500;
	end
	if layout.width and layout.height then
		width = layout.width;
		height = layout.height;
	end
	local image = ZImage:create( nil,layout.image,layout.posX,layout.posY,width,height,0,nineArg,nineArg )
	return image
end

