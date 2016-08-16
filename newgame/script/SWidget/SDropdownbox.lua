--SDropdownbox.lua
--create by zengsi on 2016.4.20
--下拉框

SDropdownbox = simple_class(SWidgetBase)

function SDropdownbox:__init( view,layout)
	SWidgetBase.__init(self, view,layout)
end

function SDropdownbox:create(x,y,w,h,n_type,normal_obj)
	local view = CCBasePanel:panelWithFile(x,y,w,h,"",500,500)
	local parent = self(view)
	parent.x = x
	parent.y = y
	parent.w = w
	parent.h = h
	parent.type = n_type

	parent.item_obj_list = {}

	normal_obj.size = normal_obj:getContentSize()
	local normal_y = 1
	if n_type == 1 then
		normal_y = normal_obj.size.height/2
	else
		normal_y = h - normal_obj.size.height/2
	end
	normal_obj:setAnchorPoint(0.5,0.5)
	normal_obj.x = normal_obj.size.width/2
	normal_obj.y = normal_y
	normal_obj:setPosition(normal_obj.x,normal_obj.y)
	normal_obj:set_click_func(bind(parent.click_dropdown,parent))

	parent.cur_y = normal_y
	parent.normal_obj = normal_obj
	parent:addChild(normal_obj,1)
	parent:set_distance(0)
	parent:set_action_time(0.1,0.025)
	return parent
end

function SDropdownbox:addItem(item_obj)
	if item_obj then
		local insert = table.insert
		self:addChild(item_obj)
		item_obj.size = item_obj:getContentSize()
		item_obj:setAnchorPoint(0.5,0.5)
		insert(self.item_obj_list,item_obj)
		local num = #self.item_obj_list
		local last_item_obj = self.item_obj_list[num - 1]
		local last_y = 0
		if last_item_obj then --有上一个的话,就取
			last_y = last_item_obj.y
			last_y = self:auto_change_y(last_y,item_obj.size.height/2+last_item_obj.size.height/2)
		else
			last_y = self:auto_change_y(self.cur_y,item_obj.size.height/2+self.normal_obj.size.height/2)
		end
		item_obj.x = item_obj.size.width/2
		item_obj.y = last_y
		item_obj:setPosition(item_obj.x,item_obj.y)
		self:auto_compute_size()
		item_obj:set_click_func(bind(self.click_select,self,num))
		self._is_unfold = true
		self:click_dropdown()
	end
end

--设置间隔,默认为0
function SDropdownbox:set_distance(distance)
	self.distance = distance
end

--自动根据纵向类型获取y位置
function SDropdownbox:auto_change_y(base_y,y)
	if self.type == 1 then 
		y = base_y + y + self.distance
	else
		y = base_y - y - self.distance
	end
	return y
end

--自动计算大小跟位置
function SDropdownbox:auto_compute_size()
	local all_height = self.normal_obj.size.height
	for _ , v in pairs(self.item_obj_list) do
		all_height = all_height + v.size.height
	end
	local last_h = self.h
	self.h = all_height
	self.view:setSize(self.w,self.h)
	if self.type ~= 1 then --从上往下
		local offset_h = self.h - last_h
		self.normal_obj.y = self.normal_obj.y + offset_h
		self.normal_obj:setPosition(self.normal_obj.x,self.normal_obj.y)
		for _ , v in pairs(self.item_obj_list) do
			v.y = v.y + offset_h
			v:setPosition(v.x,v.y)
		end
	end
end

--设置点击事件
function SDropdownbox:set_click_func(func)
	self.func = func
end

--选择
function SDropdownbox:click_select(i)
	if self.func then
		self.func(i,self._is_unfold)
	end
	self:click_dropdown()
end

--点击下拉
function SDropdownbox:click_dropdown()
	if self._is_unfold == false then
        --展开
        self:unfold_action()
        self._is_unfold = true
    else
        --收缩
        self:shrink_action()
        self._is_unfold = false
    end
    if self.func then
    	self.func(0,self._is_unfold)
    end
end

--获取当前是展开还是收缩
function SDropdownbox:is_unfold()
	return self._is_unfold == true
end

--设置动作时间
function SDropdownbox:set_action_time(normal_time,add_time)
	self.normal_time = normal_time
	self.add_time = add_time
end

--展开动作
function SDropdownbox:unfold_action()
	local item = 0.1
	for i , node in pairs(self.item_obj_list) do
    	time = self.normal_time + self.add_time*i
    	node:runAction(CCMoveTo:actionWithDuration(time,CCPointMake(node.x,node.y)))
    	node:setIsVisible(true)
    end
end

--收缩动作
function SDropdownbox:shrink_action()
    -- node:runAction(CCMoveTo:actionWithDuration(0.1,CCPointMake(self.textbtn_select.x,self.textbtn_select.y)))
    local time = 0.1
    for i , node in pairs(self.item_obj_list) do
    	time = self.normal_time + self.add_time*i
    	node:runAction(CCMoveTo:actionWithDuration(time,CCPointMake(self.normal_obj.x,self.normal_obj.y)))
    	node:setIsVisible(false)
    end
end




function SDropdownbox:create_by_layout(layout )
	-- local nine_size = 0
	-- if layout.is_nine then
	-- 	nine_size = 500
	-- end

	-- local view = CCZXImage:imageWithFile( layout.pos[1], layout.pos[2],layout.size[1], layout.size[2], 
	-- 	layout.img_n, nine_size, nine_size)

	-- return self(view,layout)
end
