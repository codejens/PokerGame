--SButton.lua
--create by tjh on 2015.7.13
--基本按钮控件 

SButton = simple_class(STouchBase)

function SButton:__init(view, layout)
	STouchBase.__init(self, view, layout)
end

--创建按钮函数
--@param nor_img 正常图片
--@param down_img按下图片 可选 默认跟正常图片一样

function SButton:create(nor_img, down_img, dis_img, width, height)
	local nor_img = nor_img or ""

	local w,h = -1,-1
	if not nor_img or nor_img == "" then
		w = 1
		h = 1
	end
	if width and height then
		w = width
		h = height
	end
	local view = CCNGBtnMulTex:buttonWithFile(0, 0, w, h, nor_img)
	
	if down_img then
		view:addTexWithFile(CLICK_STATE_DOWN, down_img)
	else
		view:addTexWithFile(CLICK_STATE_DOWN, nor_img)
	end
	if dis_img then
		view:addTexWithFile(CLICK_STATE_DISABLE, dis_img)
	end

	local obj = self(view)
	obj:auto_set_sound(nor_img)
	if w == -1 then
		obj.w = view:getContentSize().width
	end
	if h == -1 then
		obj.h = view:getContentSize().height
	end
	return obj
end

function SButton:quick_create(str, x, y, w, h, nor_img, down_img, parent, zOrder, is_nine)
	local nor_img = nor_img or ""
	w = w or -1
	h = h or -1
	if not nor_img or nor_img == "" then
		w = 1
		h = 1
	end
	local is_nine_x = 500
	local is_nine_y = 500
	if is_nine == false then
		is_nine_x = 0
		is_nine_y = 0
	end
	local view = CCNGBtnMulTex:buttonWithFile(x, y, w, h, nor_img, TYPE_MUL_TEX, is_nine_x, is_nine_y)
	if w == -1 then
		w = view:getContentSize().width
	end
	if h == -1 then
		h = view:getContentSize().height
	end
	if down_img then
		view:addTexWithFile(CLICK_STATE_DOWN, down_img)
	else
		view:addTexWithFile(CLICK_STATE_DOWN, nor_img)
	end
	if dis_img then
		view:addTexWithFile(CLICK_STATE_DISABLE, dis_img)
	end
	local obj = self(view)
	obj:auto_set_sound(nor_img)
	obj.w = w
	obj.h = h
	if str ~= nil then
		local f_size = 16
		local label = SLabel:quick_create(str, w/2, h/2, obj)
		label:setAnchorPoint(0.5, 0.5)
		obj.label = label
	end
	obj:addTo(parent, zOrder)
	return obj
end

function SButton:create_by_layout(layout)
	local nor_img = layout.img_n or ""
	local w,h = -1,-1
	if not nor_img or nor_img == "" then
		w = 1
		h = 1
	end
	local view
	if layout.is_nine == true then
		view = CCNGBtnMulTex:buttonWithFile(layout.pos[1], layout.pos[2], layout.size[1], layout.size[2],nor_img,TYPE_MUL_TEX,500,500)
	else
		view = CCNGBtnMulTex:buttonWithFile(layout.pos[1], layout.pos[2], layout.size[1], layout.size[2],nor_img)
	end
	if layout.img_s then
		view:addTexWithFile(CLICK_STATE_DOWN, layout.img_s)
	end
	if layout.flip then
		view:setFlipX(layout.flip[1])
		view:setFlipY(layout.flip[2])
	end
	local obj = self(view, layout)
	obj:auto_set_sound(nor_img)
	obj.w = layout.size[1]
	obj.h = layout.size[2]
	if layout.str ~= nil then
		obj:setText(layout.str)
	end
	if layout.fontsize ~= nil then
		obj:setFontSize(layout.fontsize)
	end
	return obj
	-- return self(view,layout)
end

--设置某个状态的图片
function SButton:set_state_img(state,image)
	if self.view then
		self.view:addTexWithFile(state, image)
	end
end

--设置为某个状态
function SButton:setCurState(state)
	self.view:setCurState(state)
end

--获取文字
function SButton:getText()
	if self.label then
		return self.label:getText()
	end
end

--设置文字
function SButton:setText(str)
	if str == "领取" then
		self:set_sound_id(5)
	end
	if self.label then
		self.label:setText(str)
	else
		if self.w and self.h then
			local f_size = 16
			local label = SLabel:create(str)
			label:setPosition(self.w/2, self.h/2)
			label:setAnchorPoint(0.5, 0.5)
			self.view:addChild(label.view)
			self.label = label
		end
	end
end

--设置文字大小
function SButton:setFontSize(f_size)
	if self.label then
		self.label:setFontSize(f_size)
	end
end

--设置文字方向类型
function SButton:setComposeType(type)
	if self.label then
		self.label:setComposeType(type)
	end
end

-- 设置锚点
function SButton:setAnchorPoint(x, y)
	if self.view then
		self.view:setAnchorPoint(x, y)
	end
end

function SButton:getSize()
	if self.view then
		return self.view:getSize()
	end
end

function SButton:setIsVisible(flag)
	if self.view then
		self.view:setIsVisible(flag)
	end
end

function SButton:auto_set_sound(img )
	self:set_sound_id(4)
	if img == "sui/public/close_btn.png" or img == "sui/common/close.png" or img == "sui/common/close2.png" then
		self:set_sound_id(3)
	end
end
