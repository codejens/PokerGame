-- BuffView.lua
-- create by hcl on 2012-5-9
-- 控制buff的view

require "utils/MUtils"

super_class.BuffView()

function BuffView:__init( parent,pos_x,pos_y )
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 127, 40, "", 500, 500 );

	--不可见的buf list
	self.buff_invisible = {}
	--所有的buf struct为key, 控件为view
	self.all_buff = {}
	--可见的buf list
	self.buff_visible = {}

	self.scroll_info = {}

	local function btn_fun()
		local win = UIManager:show_window("user_buff_tips")
		if win then
			win:update(self.scroll_info)
		end
	end

	self.buff_btn = ZButton:create(self.view, UILH_MAIN.buff_bg, btn_fun, 0, 0, 38, 38)
	self.buff_img = CCZXImage:imageWithFile(3, 3, 32, 32, "")
	self.view:addChild(self.buff_img)
	parent:addChild(self.view);
	self.handle = 0;
	return self;
end

local function sort_fun1(a, b)
	return (a.alive_time - BuffModel:get_past_time(a.buff_type)) < (b.alive_time - BuffModel:get_past_time(b.buff_type))
end

local function sort_fun2(a, b)
	return (a.alive_time - BuffModel:get_past_time(a.buff_type)) > (b.alive_time - BuffModel:get_past_time(b.buff_type))
end

function BuffView:add_buff( buff_struct )
	local buff_type = buff_struct.buff_type;
	local buff_group = buff_struct.buff_group;
	-- 如果已经有这个buff了就直接返回
	for k, v in pairs(self.all_buff) do
		-- print("k.buff_type",k.buff_type,k.buff_group);
		if buff_type == k.buff_type and buff_group == k.buff_group then
			-- print("如果已经有这个buff了就直接返回")
			return
		end
	end
	for i, v in ipairs(self.scroll_info) do
		if v.buff_type == buff_type  and buff_group == v.buff_groupthen then return end
	end

	-- 目前把所有buff添加到可视窗口中
	if buff_struct.buff_value then
		self.scroll_info[#self.scroll_info+1] = buff_struct
		table.sort(self.scroll_info, sort_fun1)
		local icon_path = string.format("icon/buff/%05d.jd",self.scroll_info[1].buff_type);
		self.buff_img:setTexture(icon_path)
		self.buff_img:setSize(32,32)
		-- if #self.scroll_info == 1 then self.buff_btn.view:setIsVisible(true) end
		local win = UIManager:find_window("user_buff_tips")
		if win then
			win:update(self.scroll_info)
		end
	else
		-- 添加控件
		local icon_path = string.format("icon/buff/%05d.jd",buff_struct.buff_type);
		--local icon_path = string.format("icon/buff/%05d.jpg",buff_struct.buff_type);
		local buf_tab = {}
		-- local bufview = MUtils:create_sprite(self.view,icon_path,0,0);
		local bufview = ZImage:create(self.view, icon_path, 0, 0, 40, 40)
		bufview.view:setAnchorPoint(0.0,0.0)
		buf_tab.view = bufview.view
		buf_tab.alive_time = buff_struct.alive_time
		-- local spr = MUtils:create_sprite(bufview,"ui/main/buff_bg.png",10,10,-1)
		-- spr:setScale(1.2)
		--记录
		self.buff_visible[#self.buff_visible+1] = buf_tab
		self.all_buff[buff_struct] = buf_tab
		table.sort(self.buff_visible, sort_fun2)

		-- 最多显示2个buff，如果超过2个，就删除时间最短的
		if ( #self.buff_visible > 2 ) then
			local temp = table.remove(self.buff_visible)
			temp.view:setIsVisible(false)
			self.buff_invisible[#self.buff_invisible+1] = temp
			table.sort(self.buff_invisible, sort_fun2)
		end
		--排序
		for i=1,#self.buff_visible do
			local view = self.buff_visible[i].view
			view:setPosition(i * 42,0);
		end
	end
end

function BuffView:delete_buff( buff_type,buff_group )
	
	for _buffstruct, _bufview in pairs(self.all_buff) do
		print(_buffstruct.buff_type , _buffstruct.buff_group,buff_type,buff_group);
		if ( _buffstruct.buff_type == buff_type and ( buff_group==nil or _buffstruct.buff_group == buff_group) ) then
			-- print("BuffView::delete_buff buff_type = ",buff_type,buff_group);
			self:delete_buff_view( _buffstruct, _bufview.view )
			return
		end
	end

	for i, v in ipairs(self.scroll_info) do
		if v.buff_type == buff_type then
			table.remove(self.scroll_info, i)
			local win = UIManager:find_window("user_buff_tips")
			if win then
				win:update(self.scroll_info)
			end
			if #self.scroll_info == 0 then
				self.buff_img:setTexture("")
			else
				local icon_path = string.format("icon/buff/%05d.jd",self.scroll_info[1].buff_type);
				self.buff_img:setTexture(icon_path)
				self.buff_img:setSize(32,32)
			end
			break
		end
	end
end

function BuffView:delete_buff_view( dstruct, dview )
	-- body
	
	local delete_i = nil

	--从总和移除
	self.all_buff[dstruct] = nil

	--从不可见列表移除目标buff
	for i, invView in ipairs(self.buff_invisible) do
		if invView.view == dview then
			table.remove(self.buff_invisible,i)
			return
		end
	end

	--从可见列表删除目标buff
	for i,v in ipairs(self.buff_visible) do
		if v.view == dview then
			delete_i = i
			break;
		end
	end
	if delete_i then
		table.remove(self.buff_visible,delete_i)
	end

	dview:removeFromParentAndCleanup(true)

	--从不可见列表拿一个加到可见列表
	if #self.buff_invisible > 0 then
		local view =  table.remove(self.buff_invisible)
		view.view:setIsVisible(true)
		table.insert(self.buff_visible,view)
	end
	for i,v in ipairs(self.buff_visible) do
		v.view:setPosition(i*42,0);
	end
end

function BuffView:is_need_clear( handle )
	--print("BuffView:60:self.handle,handle",self.handle,handle)
	if ( self.handle == handle )then

	else
		-- 重新更新buff
		self.view:removeAllChildrenWithCleanup(true);
		self.buff_invisible = {}
		self.all_buff = {}
		self.buff_visible = {}
		
		-- 重新添加buff
		local entity = EntityManager:get_entity(handle);
		if ( entity and entity.buff_dict ) then
			--print("重新添加buff")
			for k,v in pairs(entity.buff_dict) do
				self:add_buff( v );
			end
		end
	end
end

function BuffView:GetScrollInfo(index)
	if index then
		return self.scroll_info[index]
	else
		return self.scroll_info
	end
end