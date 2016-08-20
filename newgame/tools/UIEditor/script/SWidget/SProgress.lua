--SProgress.lua
--create by tjh on 2015.7.31
--进度条控件
SProgress = simple_class(SWidgetBase)

--@param p_view 真正的进度条
function SProgress:__init(view, layout)
	SWidgetBase.__init(self,view,layout)
	self:init()
end

function SProgress:init(color)
	self.color = color or "#c7f501e"
	self.max_percentage = 100
	self.one_percentage_width = self.layout.size[1]/self.max_percentage
	self.is_show_light = true
end

function SProgress:create_by_layout(layout)
	--面板
	local parent = CCBasePanel:panelWithFile(layout.pos[1], layout.pos[2], layout.size[1], layout.size[2], "")
	--进度条底
	local bg = CCBasePanel:panelWithFile(0, 0, layout.size[1], layout.size[2], layout.img_s, 500, 500)
	parent:addChild(bg)
	
	--发光边
	local x,y = 0,0
	local light = ZImage:create(parent,"sui/common/light.png", nil, nil, nil, nil, 10086)
	local s_light = light.view:getContentSize()
	x = -s_light.width/4
	y = layout.size[2]/2
	light:setPosition(x,y)
	light.view:setAnchorPoint(0,0.5)
	light.x = x
	light.y = y
	
	--遮罩板
	local mask_panel = CCTouchPanel:touchPanel(0, 0, layout.size[1]+1, layout.size[2])
	parent:addChild(mask_panel)

	--进度值
	local progress = CCBasePanel:panelWithFile(2, 2, layout.size[1]-4, layout.size[2]-4, layout.img_n, 500, 500)
	mask_panel:addChild(progress)
	progress:setSize(layout.size[1]-4, layout.size[2]-4)

	--文本
	local normal_value = 50
	local normal_style_lab = 2
	local obj = self(parent,layout)
	obj.f_size = 16
	local lab = ZLabel:create(parent,obj.color .. normal_value .. "/" .. normal_value,layout.size[1]/2,layout.size[2]/2,obj.f_size,ALIGN_LEFT,100000)
	lab.view:setAnchorPoint(CCPointMake(0.5,0.5))

	-- lab.view:setAnchorPoint(CCPointMake(0.5,0.5))

	--隐藏发光效果，听说都不要了
	obj.is_show_light = false
	light.view:setIsVisible(false)
		
	obj.mask_panel = mask_panel
	obj.light = light
	obj.progress = progress
	obj.parent = parent
	obj.bg = bg
	obj.lab = lab
	obj:set_cur_style_lab(normal_style_lab)
	obj:set_value(normal_value, normal_value*2) 	
	obj:set_progress_size(layout.size[1]-4, layout.size[2]-4)
	return obj
end

--设置当前值,默认 10/100
--要显示百分比,就先改变style样式
function SProgress:set_value(cur_percentage, max_percentage)
	-- if cur_percentage == 0 then
	-- 	cur_percentage = 1
	-- end
	max_percentage = max_percentage or 100
	local percentage = math.ceil((cur_percentage / max_percentage)*100)
	if percentage >= 100 then
		percentage = 100
		self:show_light(false)
	else
		-- if percentage == 0 then
		-- 	self.light.view:setIsVisible(false)
		-- else
			self:show_light(true)
		-- end
	end
	if self.style_label == 2 then
		self:setText(self.color .. cur_percentage .. "/" .. max_percentage)
	else
		self:set_cur_value(percentage)
	end
	if cur_percentage == 0 then
		--self.mask_panel:setSize(1,self.layout.size[2])
		if self.is_FlipX then
			self.mask_panel:setPositionX(self.layout.size[1])
		else
			self.mask_panel:setPositionX(self.layout.size[1])
		end
		self.progress:setPositionX(self.layout.size[1]+1)
		self.light.view:setPosition(self.light.x,self.light.y)
		self:show_light(false)
	else
		--self.mask_panel:setSize(percentage*self.one_percentage_width,self.layout.size[2])
		if not self.is_FlipX then
			self.mask_panel:setPositionX(percentage*self.one_percentage_width -self.layout.size[1])
			local w = self.progress_pos and self.progress_pos.offset_w or 0
			local x = self.progress_pos and self.progress_pos.offset_x or 0
			--print (">>>>>>>>>>>>>>>>>>>", x)
			self.progress:setPositionX(w/2 +x + self.layout.size[1] -percentage*(self.one_percentage_width))
			self.light.view:setPosition(percentage*self.one_percentage_width+self.light.x,self.light.y)
		else
			self.mask_panel:setPositionX((100-percentage)*self.one_percentage_width)
			local w = self.progress_pos and self.progress_pos.offset_w or 0
			local x = self.progress_pos and self.progress_pos.offset_x or 0
			--print (">>>>>>>>>>>>>>>>>>>", x)
			self.progress:setPositionX(w/2 -x - (100 -percentage)*(self.one_percentage_width))
			self.light.view:setPosition(percentage*self.one_percentage_width+self.light.x,self.light.y)
		end
	end
end

--设置进度条值的大小,这个只能手动调用修改
function SProgress:set_progress_size(w, h, offset_x, offset_y)
	local old_h = self.progress:getSize().height
	local old_w = self.progress:getSize().width
	local offset_h = old_h - h
	local offset_w = old_w - w
	local old_x,old_y = self.progress:getPosition()
	self.progress:setSize(w-2, h-2)
	self.progress_pos = {x=old_x + offset_w/2 +(offset_x or 0),y=old_y + offset_h/2 + (offset_y or 0),
						 offset_w = offset_w, offset_y = offset_y, offset_x = (offset_x or 0), offset_y = (offset_y or 0)}
	self.progress:setPosition(self.progress_pos.x+2,self.progress_pos.y+2 )
	--self.progress:setPosition(old_x ,old_y + offset_h/2)
end

function SProgress:set_is_show_light(isShow)
	self:show_light(isShow)
	self.is_show_light = isShow
end

function SProgress:show_light(isShow)
	if self.is_show_light then
		self.light.view:setIsVisible(isShow)
	end
end

function SProgress:doFlip(bx, by)
	self.progress:setFlipX(bx)
	self.progress:setFlipY(by)
	self.bg:setFlipX(bx)
	self.bg:setFlipY(by)
	self.is_FlipX = bx
end

function SProgress:setOffset(offset_w, offset_h)
	self.bg:setSize(self.bg:getSize().width+offset_w, self.bg:getSize().height+offset_h)
	self.bg:setPosition(-offset_w/2, -offset_h/2)
end

--重新设置全部大小
function SProgress:setSize(w,h)
	self.parent:setSize(w,h)
	self.bg:setSize(w,h)
	self.mask_panel:setSize(w,h)
	self.progress:setSize(w,h)
	self.layout.size[1] = w
	self:reset_init()
end

--重新初始化某些数据
--param 可选参数color
function SProgress:reset_init(color)
	self:init(color)
end

--设置文本是否隐藏
function SProgress:set_lab_visible(visible)
	self.lab.view:setIsVisible(visible)
end

--设置文字,只有是自定义文字情况下才能调用这里,自定义的自己要加颜色
function SProgress:setText(str)
	if self.style_label == 2 then
		self.lab:setText(str)
	end
end

--设置文本样式 1 50% , 2自定义
function SProgress:change_lab_style(style)
	self:set_cur_style_lab(style)
end

--设置当前值
function SProgress:set_cur_value(value)
	self.cur_value = value or self.cur_value
	if self.style_label == 1 then --只有是第一种文字样式的时候才去设置
		self.lab:setText(self.color .. self.cur_value .. "%")
	end
end

--设置当前lab样式
function SProgress:set_cur_style_lab(style)
	self.style_label = style or self.style_label
end

--获取当前值
function SProgress:get_cur_value()
	return self.cur_value
end

--设置文字大小,需要重新设置位置
function SProgress:setFontSize(f_size)
	self.lab.view:setFontSize(f_size)
	self.f_size = f_size
	--self.lab.view:setPosition(self.layout.size[1]/2,self.layout.size[2]/2 - self.f_size/2)
	self.lab.view:setPosition(self.layout.size[1]/2,math.ceil(self.layout.size[2]%2 == 0 and self.layout.size[2]/2 +1 or self.layout.size[2]/2) )
end

--设置颜色
function SProgress:set_color(color)
	self.color = color
end

function SProgress:set_lab_position(x, y)
	self.lab.view:setPosition(x, y)
end

-- --SProgress.lua
-- --create by tjh on 2015.7.31
-- --进度条控件
-- --由于编辑器中无法选中 只能放在一个面板上面
-- SProgress = simple_class(SWidgetBase)

-- --@param p_view 真正的进度条
-- function SProgress:__init( view,layout,p_view )
-- 	SWidgetBase.__init(self,view,layout)
-- 	if p_view then
-- 		self.p_view = p_view
-- 	else
-- 		self.p_view = self.view
-- 	end
-- end

-- function SProgress:create( tWidth,tHeight,img_n,img_s)
-- 	local view = ZXProgress:createWithValueEx( 0, 100, tWidth, tHeight,img_s,img_n)
-- 	return self(view)
-- end

-- function SProgress:create_by_layout( layout )
-- 	local view = CCBasePanel:panelWithFile(0, 0, layout.size[1], layout.size[2], "")
-- 	local p_view = ZXProgress:createWithValueEx( 25, 100, layout.size[1], layout.size[2],
-- 		layout.img_s,layout.img_n)
-- 	view:addChild(p_view)
-- 	view:setPosition(layout.pos[1],layout.pos[2])
-- 	return self(view,layout,p_view)
-- end

-- --设置当前值
-- function SProgress:set_value( cur_value,max_value )
-- 	self.p_view:setProgressValue(cur_value,max_value)
-- end

-- --隐藏文字
-- function SProgress:set_lab_visable( visable )
-- 	self.p_view:setLabVisable(visable)
-- end