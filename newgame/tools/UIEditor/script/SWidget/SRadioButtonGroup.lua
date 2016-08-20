--SRadioButtonGroup.lua
--create by tjh on 2015.7.13
--组选按钮 配合SRadioButton使用

SRadioButtonGroup = simple_class(STouchBase)

function SRadioButtonGroup:__init(view, layout)
	STouchBase.__init(self,view,layout)
	local function touch_func()
		self:touch_end_func()
	end
	self:set_touch_func(TOUCH_ENDED, touch_func)
end

function SRadioButtonGroup:create(tImage, tWidth, tHeight)
	local view = CCRadioButtonGroup:buttonGroupWithFile(0, 0, tWidth, tHeight, tImage)
	return self(view)
end

function SRadioButtonGroup:create_by_layout(layout)
	local nine_size = 0
	if layout.is_nine then
		nine_size   = 500
	end
	local view = CCRadioButtonGroup:buttonGroupWithFile(layout.pos[1], layout.pos[2], layout.size[1], layout.size[2], layout.img_n, nine_size, nine_size)
	return self(view,layout)
end

function SRadioButtonGroup:quick_create(x, y, w, h, parent, zOrder)
	local view = CCRadioButtonGroup:buttonGroupWithFile(x, y, w, h, "")
	local obj  = self(view)
	obj:addTo(parent, zOrder)
	return obj
end

function SRadioButtonGroup:add_button(btn)
	local view = btn.view or btn
	self.view:addGroup(view)
end

function SRadioButtonGroup:addChild(node)
	 self:add_button(node)
end

function SRadioButtonGroup:selectItem(index)
	self.view:selectItem(index)
	self:touch_end_func()
end

function SRadioButtonGroup:getCurNum()
	return self.view:getCurNum()
end

function SRadioButtonGroup:getCurSelect()
	return self.view:getCurSelect()
end

function SRadioButtonGroup:set_labels(date, fontType, x, y, setPosTag, font_size, sel_color, no_sel_color, isChangeBig)
	self.label        = self.label or {}
	self.sel_color    = sel_color or S_COLOR[28]
	self.no_sel_color = no_sel_color or S_COLOR[29]
	self.font_size    = font_size or 24
	self.isChangeBig  = true
	if isChangeBig ~= nil then
		self.isChangeBig = isChangeBig
	end
	for i=1,#date do
		local item = self.view:getIndexItem(i-1)
		if item then
			if self.label[i] then
				self.label[i]:setText(self.no_sel_color..date[i])
				self.label[i]:setFontSize(self.font_size)
			else
				self.label[i] = SLabel:create(self.no_sel_color..date[i], self.font_size, ALIGN_LEFT, fontType or FONT_VERTICAL)
				self.label[i]:setAnchorPoint(0.5,0.5)
				item:addChild(self.label[i].view)
			end
			local size = item:getSize()
			local pos_x = x
			if type(x) == "table" then
				pos_x = x[i] or 0
			end
			local pos_y = y
			if type(y) == "table" then
				pos_y = y[i] or 0
			end
			if pos_x and pos_y and setPosTag then
				self.label[i]:setPosition(pos_x, pos_y)
			else
				if fontType and fontType == 1 then
					self.label[i]:setPosition(size.width/2.65, size.height/2)
				else
					self.label[i]:setPosition(size.width/2.65, size.height/2)
				end
			end
			
		end
	end
	local index = self.view:getCurSelect()+1
	if self.label[index] then
		self.label[index]:set_color(self.sel_color)
		if self.isChangeBig then
			self.label[index]:setFontSize(self.font_size+2)
		else
			self.label[index]:setFontSize(self.font_size)
		end
	end
end

function SRadioButtonGroup:touch_end_func()
	if not self.label then
		return
	end
	local index = self.view:getCurSelect()+1
	for i=1,#self.label do
		if i == index then
			self.label[i]:set_color(self.sel_color)
			if self.isChangeBig then
				self.label[i]:setFontSize(self.font_size+2)
			else
				self.label[i]:setFontSize(self.font_size)
			end
		else
			self.label[i]:set_color(self.no_sel_color)
			self.label[i]:setFontSize(self.font_size)
		end
	end
end

function SRadioButtonGroup:touch_end_func_by_disable(dis_index)
	if not self.label then
		return
	end

	for i=1,#self.label do
		if i == dis_index then
			self.label[i]:setIsVisible(false)
		end
	end
end