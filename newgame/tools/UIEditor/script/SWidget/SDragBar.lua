--SDragBar.lua
--拖动条(方便UI编辑器编辑)

SDragBar = simple_class(SWidgetBase)

local _is_no_zero = false
function SDragBar:__init(view, layout, dragbar)
	SWidgetBase.__init(self, view, layout)
	self.dragbar  = dragbar
end

function SDragBar:create_by_layout(layout)
	local x               = tonumber(layout.pos[1])
	local y               = tonumber(layout.pos[2])
	local width           = tonumber(layout.size[1])
	local height          = tonumber(layout.size[2])
	local bar_image_di    = layout.img_s
	local bar_image       = layout.img_n
	local max_value       = tonumber(layout.str)
	local btn_img_n       = "sui/systemset/slidebar_btn.png"
	local btn_img_s       = "sui/systemset/slidebar_btn.png"
	local num_text        = nil
	local num_text_color  = "#c8d4408"
	local but_current_x   = 0  --记录按钮当前的位置
	local value_move_bar  = {} --数字滑动条对象
	value_move_bar.usedis = false
	--整个响应区域
	value_move_bar.view   = CCBasePanel:panelWithFile(x, y, width, height, "", 500, 500)
	--按钮
	local move_but        = CCZXImage:imageWithFile(0, 0, -1, -1, btn_img_n, 500, 500 )
	value_move_bar.view:addChild(move_but, 10)
	self.move_btn         = move_but
	--进度条底
	local bg_bar          = CCZXImage:imageWithFile(0, 0, width, height, bar_image_di, 500, 500)
	value_move_bar.view:addChild(bg_bar)
	--进度条
	local move_value_img  = CCZXImage:imageWithFile(2, 2, but_current_x, height-4, bar_image, 500, 500)
	value_move_bar.view:addChild(move_value_img)
	local pos_x           = 0
	local pos_y           = 0
	local base_w          = 0
	local base_h          = 0
	local but_image_w     = 0
	local but_image_h     = 0
	local btn_dis         = 0
	--刷新布局
	local function update_layout()
		local but_image_size = move_but:getSize()
		but_image_w    = but_image_size.width
		but_image_h    = but_image_size.height
		if value_move_bar.usedis == false then
			btn_dis = but_image_w/2
		end
		pos_x                = x-btn_dis
		pos_y                = y
		base_w               = width+btn_dis*2
		base_h               = height
		local move_but_y     = (height-but_image_h)/2
		if but_image_h > height then
			pos_y      = y-(but_image_h-height)/2
			base_h     = but_image_h
			move_but_y = 0
		end
		value_move_bar.view:setSize(base_w, base_h)
		value_move_bar.view:setPosition(pos_x, pos_y)
		move_but:setPosition(0, move_but_y)
		bg_bar:setSize(width, height)
		bg_bar:setPosition(btn_dis, (base_h-height)/2)
		move_value_img:setSize(but_current_x, height-4)
		move_value_img:setPosition(btn_dis+2, (base_h-height)/2+2)
	end
	update_layout()
	--计算当前值
	local function calulate_current_value()
		local percentage = but_current_x/(base_w-but_image_w)
		local curr_value = percentage*max_value
		curr_value = math.floor(curr_value)
		if _is_no_zero == true then
			curr_value = curr_value + 1
		end
		return curr_value
	end
	--调用回调函数
	local function do_callback_func()
		local curr_value = calulate_current_value()
		if num_text then
			num_text:setText(num_text_color..curr_value.."%")
		end
		if curr_value <= 0 then
			move_but:setTexture(btn_img_n)
		else
			move_but:setTexture(btn_img_s)
		end
		if value_move_bar.callback_func then
			value_move_bar.callback_func(curr_value)
		end
	end
	--设置按钮的位置
	local function set_but_position(pos_x)
        if pos_x < 0 then
            pos_x = 0
        end
        local max_pos = base_w-but_image_w
        if pos_x > max_pos then
            pos_x = max_pos
        end
        but_current_x = pos_x
		move_but:setPositionX(pos_x)
		move_value_img:setSize(but_current_x, height-4)
		do_callback_func()
	end
	--触摸事件
	local pos_temp = {}
	local x_temp   = 0
	value_move_bar.is_can_touch = true
	local function touch_event_func(eventType, touch_x_y)
		if eventType == TOUCH_BEGAN and not self.touch_all then
			value_move_bar.view:setHittestType(2)
			self.touch_all = true
		end
		if (eventType == TOUCH_CANCEL or eventType == TOUCH_ENDED) and self.touch_all then
			value_move_bar.view:setHittestType(0)
			self.touch_all = false
		end
		if not value_move_bar.is_can_touch then return end

		if eventType == TOUCH_BEGAN or eventType == TOUCH_MOVED or eventType == TOUCH_ENDED then
			if not touch_x_y then
				return
			end
			pos_temp = Utils:Split(touch_x_y,":")
			x_temp = tonumber(pos_temp[1])
			set_but_position(x_temp-x)
		end
	end
	value_move_bar.view:registerScriptHandler(touch_event_func) 
	--设置大小
	value_move_bar.setSize = function(w, h)
		if width == w and height == h then
			return
		end
		width  = w
		height = h
		update_layout()
		set_but_position(but_current_x)
	end
	--设置坐标X,Y
	value_move_bar.setPosition = function(new_x, new_y)
		if x == new_x and y == new_y then
			return
		end
		x = new_x
		y = new_y
		update_layout()
		set_but_position(but_current_x)
	end
	--设置坐标X
	value_move_bar.setPositionX = function(new_x)
		if x == new_x then
			return
		end
		x = new_x
		update_layout()
		set_but_position(but_current_x)
	end
	--设置坐标Y
	value_move_bar.setPositionY = function(new_y)
		if y == new_y then
			return
		end
		y = new_y
		update_layout()
		set_but_position(but_current_x)
	end
	--获取坐标
	value_move_bar.getPosition = function()
		return x, y
	end
	--获取当前值
	value_move_bar.get_current_value = function()
		return calulate_current_value()
	end
	--设置当前值
	value_move_bar.set_current_value = function(curr_value)
		local curr_pox_x = (curr_value/max_value)*width
		set_but_position(curr_pox_x)
	end
	value_move_bar.set_current_value(50)
	--进度条纹理
	value_move_bar.setTexture = function(file)
		move_value_img:setTexture(file)
	end
	--按钮纹理
	value_move_bar.setBtnTexture = function(file_n, file_s, dis)
		btn_img_n  = file_n
		btn_img_s  = file_s
		btn_dis    = dis or 9
		value_move_bar.usedis = true
		move_but:setTexture(btn_img_n)
		local size_btn = SImage:create(btn_img_n):getContentSize()
		move_but:setSize(size_btn.width, size_btn.height)
		update_layout()
		set_but_position(but_current_x)
	end
	--添加百分比显示
	value_move_bar.addPercentText = function(fontsize, color)
		if num_text then
			return
		end
		fontsize       = fontsize or 18
		color          = color or "#c8d4408"
		num_text_color = color
		num_text       = UILabel:create_lable_2("", base_w, (base_h-fontsize)/2, fontsize, ALIGN_LEFT)
		value_move_bar.view:addChild(num_text)
	end
	--设置最大值
	value_move_bar.set_max_value = function(value)
		if _is_no_zero == true then
			value = value - 1
		end
		max_value = value
		update_layout()
	end

	return self(value_move_bar.view, layout, value_move_bar)
end

function SDragBar:setSize(w, h)
	if self.dragbar.setSize then
		self.dragbar.setSize(tonumber(w or 0), tonumber(h or 0))
	end
end

function SDragBar:set_is_no_zero(no_zero)
	_is_no_zero = no_zero
end

function SDragBar:setPosition(x, y)
	if self.dragbar.setPosition then
		self.dragbar.setPosition(tonumber(x or 0), tonumber(y or 0))
	end
end

function SDragBar:setPositionX(x)
	if self.dragbar.setPositionX then
		self.dragbar.setPositionX(tonumber(x or 0))
	end
end

function SDragBar:setPositionY(y)
	if self.dragbar.setPositionY then
		self.dragbar.setPositionY(tonumber(y or 0))
	end
end

function SDragBar:getPosition()
	if self.dragbar.getPosition then
		return self.dragbar.getPosition()
	end
end

function SDragBar:set_click_func(func)
	self.dragbar.callback_func = func
end

function SDragBar:set_current_value(cur_value)
	if self.dragbar.set_current_value then
		self.dragbar.set_current_value(cur_value)
	end
end

function SDragBar:get_current_value()
	if self.dragbar.get_current_value then
		return self.dragbar.get_current_value()
	end
	return 0
end

function SDragBar:setTexture(file)
	if self.dragbar.setTexture then
		self.dragbar.setTexture(file)
	end
end

function SDragBar:setBtnTexture(file_n, file_s, dis)
	if self.dragbar.setBtnTexture then
		self.dragbar.setBtnTexture(file_n, file_s, dis)
	end
end

function SDragBar:addPercentNum(node)
	if self.move_btn and node then
		local parent = node:getParent()
		if parent then
			parent:safeRemoveChild(node, false)
		end
		self.move_btn:addChild(node)
		local size = self.move_btn:getSize()
		node:setAnchorPoint(0.5, 0)
		node:setPosition(size.width/2, size.height)
	end
end

function SDragBar:addPercentText(fontsize, color)
	if self.dragbar.addPercentText then
		self.dragbar.addPercentText(fontsize, color)
	end
end

function SDragBar:set_max_value(value)
	if self.dragbar.set_max_value then
		self.dragbar.set_max_value(value)
	end
end

function SDragBar:set_can_move(bool, btn_img)
	self.dragbar.is_can_touch = bool
	if btn_img then
		self:setBtnTexture(btn_img)
	end
end