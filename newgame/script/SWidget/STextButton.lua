--STextButton.lua
--create by tjh on 2015.7.13
--文字按钮

STextButton = simple_class(SButton)

function STextButton:__init( view,layout )
	SButton.__init(self,view,layout)
	self:set_sound_id(4)
end

function STextButton:create( str,img_n,img_d,img_dis )

	local img_n = img_n or ""
	local str = str or ""
	local view = CCTextButton:textButtonWithFile( 0, 0, -1, -1, str, img_n, TYPE_MUL_TEX)
	if img_d then
		view:addTexWithFile(CLICK_STATE_DOWN, img_d)
	else
		view:addTexWithFile(CLICK_STATE_DOWN, img_n)
	end
	if img_dis then
		view:addTexWithFile(CLICK_STATE_DOWN, img_n)
	end
	view:setFontSize(FONT_DEF_SIZE)
	local btn = self(view)
	if str == "领取" then
		btn:set_sound_id(5)
	end
	return btn
end

function STextButton:quick_create(str,x,y,w,h,img_n,img_d,parent,zOrder)
	local img_n = img_n or ""
	w = w or -1
	h = h or -1
	local str = str or ""
	local view = CCTextButton:textButtonWithFile( x,y,w,h, str, img_n, TYPE_MUL_TEX, 500, 500)
	if img_d then
		view:addTexWithFile(CLICK_STATE_DOWN, img_d)
	else
		view:addTexWithFile(CLICK_STATE_DOWN, img_n)
	end
	if img_dis then
		view:addTexWithFile(CLICK_STATE_DOWN, img_n)
	end
	view:setFontSize(FONT_DEF_SIZE)
	local obj = self(view)
	if str == "领取" then
		obj:set_sound_id(5)
	end
	obj:addTo(parent,zOrder)
	return obj
end

function STextButton:create_by_layout( layout )
	local view = CCTextButton:textButtonWithFile( layout.pos[1], layout.pos[2],layout.size[1], layout.size[2],
		 layout.str, layout.img_n, TYPE_MUL_TEX)
	if layout.img_s then
		view:addTexWithFile(CLICK_STATE_DOWN, layout.img_s)
	else
		view:addTexWithFile(CLICK_STATE_DOWN, layout.img_n)
	end
	view:setFontSize(layout.fontsize or FONT_DEF_SIZE )
	return self(view,layout)
end

function STextButton:setText( str )
	if self.view ~= nil then
		self.view:setText(str)
		if str == "领取" then
			self:set_sound_id(5)
		end
	end
end

function STextButton:getText()
	if self.view ~= nil then
		return self.view:getText()
	end
end

---------设置文字大小，当文字大于图片大小时，文字左下角位置处于，图片左下角1/10位置
--@param FontSize字体大中 可选 默认FONT_DEF_SIZE 参考SWidgetConfig文件
function STextButton:setFontSize(size)
	if self.view ~= nil then
		self.view:setFontSize(size)
	end
end

function STextButton:getSize()
	if self.view then
		return self.view:getSize()
	end
end

function STextButton:addTexWithFile( state, img_path)
	if self.view then
		self.view:addTexWithFile( state, img_path)
	end
end