--SImage.lua
--create by tjh on 2015.7.13
--图片控件 实际上就是pannel

SImage = simple_class(SWidgetBase)

function SImage:__init(view,layout)
	SWidgetBase.__init(self, view,layout)
end

function SImage:create(img, is_nine, w, h)
	if not w then w = -1 end
	if not h then h = -1 end

	local nine_size = 0
	if is_nine then
		nine_size = 500
	end

	local view = CCZXImage:imageWithFile(0, 0, w, h, img, nine_size, nine_size)

	return self(view)
end

function SImage:quick_create(x, y, img, parent, zOrder, is_nine, w, h)
	if not w then w = -1 end
	if not h then h = -1 end

	local nine_size = 0
	if is_nine then
		nine_size = 500
	end

	local view = CCZXImage:imageWithFile(x, y, w, h, img, nine_size, nine_size)
	local obj = self(view)
	obj.x = x
	obj.y = y
	obj.size = view:getContentSize()
	obj:addTo(parent,zOrder)
	return obj
end

function SImage:create_by_layout(layout)
	local nine_size = 0
	if layout.is_nine then
		nine_size = 500
	end

	local view = CCZXImage:imageWithFile(layout.pos[1], layout.pos[2],layout.size[1], layout.size[2], 
		layout.img_n, nine_size, nine_size)

	return self(view,layout)
end

function SImage:setTexture(img)
	self.view:setTexture(img)
end

--类似按钮 可以设置禁用 灰色 找_d文件
function SImage:setCurState(state)
	self.view:setCurState(state)
end

function SImage:setAnchorPoint(x,y)
	self.view:setAnchorPoint(x,y)
end