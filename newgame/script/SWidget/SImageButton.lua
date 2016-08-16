--SImageButton.lua
--create by tjh on 2015.7.13
--图片按钮控件


SImageButton = simple_class(SButton)

function SImageButton:__init( view, img )
	SButton.__init(self,view)

	self.image = SImage:create(img)
	self:addChild(self.image)

	self:update_img_pos()
end

--创建图片按钮控件
--@param img 上层图片
--@param nor_img按钮正常图片
--@param down_img 按钮按下图片 可选 默认正常图片
--@param dis_img 按钮禁用图片 可选
function SImageButton:create( img,nor_img,down_img,dis_img )

	local view = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, nor_img)
	if down_img then
		view:addTexWithFile(CLICK_STATE_DOWN,down_img)
	else
		view:addTexWithFile(CLICK_STATE_DOWN,nor_img)
	end
	if dis_img then
		view:addTexWithFile(CLICK_STATE_DISABLE, dis_img)
	end
	return self(view,img)
end

function SImageButton:setContentSize( w,h )
	SButton.setContentSize(self,w,h)
	self:update_img_pos()
end

--更新图片位置 居中
function SImageButton:update_img_pos( ... )
	local imagesize = self.image:getSize()
	local buttonsize = self.view:getSize()
	self.image:setPosition( (buttonsize.width - imagesize.width) / 2, (buttonsize.height - imagesize.height) / 2 )
end

function SImageButton:setTexture( img )
	self.image:setTexture(img)
end