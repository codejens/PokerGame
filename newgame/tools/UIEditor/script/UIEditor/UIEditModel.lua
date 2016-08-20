--UIEditModel.lua

UIEditModel = {}

local _is_select_widget = false
local _index = 0

INDEX_BTN = 1
INDEX_PANEL = 2
INDEX_LABEL = 3
INDEX_IMG = 4
INDEX_EDITEBOX = 5
INDEX_TEXBTN= 6
INDEX_TEXT = 7
INDEX_SCROLL = 8
INDEX_SCROLL = 8
INDEX_GROUPBTN = 9
INDEX_RADIOBTN = 10
INDEX_SLOTITEM = 11
INDEX_PROGRESS = 12
INDEX_SWITCHBTN = 13
INDEX_SWITCHBTN_NEW = 14
INDEX_DRAGBAR = 15
INDEX_TOUCHPANEL = 16

local filePath = nil 

local _create_class = {
	SButton,SPanel,SLabel,SImage,SEditBox,STextButton,STextArea,SScroll,SRadioButtonGroup,SRadioButton,
	SSlotItem,SProgress,SSwitchBtn,SSwitchBtnNew,SDragBar,STouchPanel
}

--每个类创个的个数 用来命名
local _class_num = {
	
}

--拷贝次数 用来命名 保证名字唯一性
local _copy_num = 1

local _layout_t = {}

--c++对象对应的lua对象
local _cobj_for_luaobj = {}

--保存所有控件名字
local _widget_name = {}

--自动保存time
local _time = nil
local _passtime = 0

function UIEditModel:init()
	_time = timer()
	local function time_cb_func(dt)
		UIEditModel:auto_save(dt)
	end
	_time:start(0,time_cb_func)
end

function UIEditModel:destroy()
	_time:stop()
end

function UIEditModel:set_cobj_for_luaobj(widget)

	_cobj_for_luaobj[widget.view] = widget
end

function UIEditModel:get_cobj_for_luaobj(view)

	return _cobj_for_luaobj[view]
end

function UIEditModel:select_widget(index)
	_is_select_widget = true
	_index = index
end

function UIEditModel:unselect_widget()
	_is_select_widget = false
	_index = 0
end


function UIEditModel:hava_select_widget()
	return _is_select_widget
end

--添加一个控件
function UIEditModel:add_widget(x,y,root,d_root)
	if _is_select_widget then

		--如果在菜单上面
		local node = ZXLuaUtils:selectCCNode(d_root,CCPointMake(x,y))
		if node then
			UIEditModel:unselect_widget()
			return
		end

		local node = UIEditModel:selectCCNode(root,x,y)
		--ZXLuaUtils:selectCCNode(root,CCPointMake(x,y))
		if node then
			--local x,y = 

			local pos = node:convertToNodeSpace(CCPointMake(x,y))
	
			local widget = UIEditModel:create_a_widget(_index,pos.x,pos.y)
			if widget then
				local lua_obj = _cobj_for_luaobj[node]
				lua_obj:addChild(widget.view)
				UIEditModel:set_cobj_for_luaobj(widget)
				--_cobj_for_luaobj[widget.view] = widget
				local parent_layout = _cobj_for_luaobj[node].layout
				widget.layout.name = UIEditModel:new_a_name(widget.layout.name,_index)

				widget.layout.parent = parent_layout.name
				if not parent_layout.child then
					parent_layout.child = {}
				end
				table.insert(parent_layout.child,widget.layout)
			end
			UIEditModel:unselect_widget()
		end
	end
end

--生成一个唯一性的名字
function UIEditModel:new_a_name(name,index)
	if not _class_num[index] then
		_class_num[index] = 0
	end
	_class_num[index] = _class_num[index] + 1
	local widget_name = string.format("%s%d",name,_class_num[index])
	if not _widget_name[widget_name] then
		_widget_name[widget_name] = true
		return widget_name
	end
	return UIEditModel:new_a_name(name,index)
end

--创建一个控件
function UIEditModel:create_a_widget(index,x,y)
	local layout = {}
	local widget = nil

	layout = Utils:table_clone(UIEditConfig[index])
	layout.pos[1] = x
	layout.pos[2] = y

	widget = _create_class[index]:create_by_layout(layout)

	return widget
end

--通过布局文件创建控件
function UIEditModel:create_by_layout(layout)
	print("layout.class",layout.class)
	local node  = _G[layout.class]:create_by_layout(layout)
	UIEditModel:set_cobj_for_luaobj(node)
	_widget_name[layout.name] = true
	if layout.flip then
		node.view:setFlipX(layout.flip[1])
		node.view:setFlipY(layout.flip[2])
	end

	if layout.child then
		for i=1,#layout.child do
			child = UIEditModel:create_by_layout(layout.child[i])
			node:addChild(child,layout.child[i].zOrder or 0)
		end
	end
	return node
end

--移动事件
function UIEditModel:move_event(x,y )
	if _is_select_widget then
		UIEditWin:move_icon(x,y)
	end
end

--选中控件 如果自己不能被编辑就查找父节点
function UIEditModel:selectCCNode(node,x,y)
	node = ZXLuaUtils:selectCCNode(node,CCPointMake(x,y))
	if node then
		--print("---------",node)
		local pnode = UIEditModel:get_lua_obj(node)
		--print("----------",pnode)
		return pnode
	end
end

--获取lua对象
function UIEditModel:get_lua_obj(node)
	local lua_obj =  UIEditModel:get_cobj_for_luaobj(node)
	if not lua_obj then

		local pnode = node:getParent()

		return UIEditModel:get_lua_obj(pnode)
	else

		return node
	end
end

--设置是否九宫格，这个只有创建的时候确定了 所有要重新创建
function UIEditModel:set_is_nine(widget)
	local layout = _cobj_for_luaobj[widget].layout
	local parent = widget:getParent()
	widget:removeFromParentAndCleanup(true)
	_cobj_for_luaobj[widget] = nil
	local node  = UIEditModel:create_by_layout(layout)--_G[layout.class]:create_by_layout(layout)
	--UIEditModel:set_cobj_for_luaobj(node)
	parent:addChild(node.view)
end

-- 设置是否X轴或者Y轴翻转
function  UIEditModel:set_flip(widget)
	local layout = _cobj_for_luaobj[widget].layout
	local layout = _cobj_for_luaobj[widget].layout
	widget:setFlipX(layout.flip[1])
	widget:setFlipY(layout.flip[2])
end

-- 设置是否可视
function UIEditModel:set_IsVisible(widget)
	local layout = _cobj_for_luaobj[widget].layout
	widget:setIsVisible(layout.isVisible)
end

--删除一个控件
function UIEditModel:delete_one_widget(widget)
	local parent = widget:getParent()
	if not _cobj_for_luaobj[parent] then
		widget:removeFromParentAndCleanup(true)
		return
	end
	
	local parent_layout = _cobj_for_luaobj[parent].layout

	for i=1,#parent_layout.child do
		if parent_layout.child[i] == _cobj_for_luaobj[widget].layout then
			table.remove(parent_layout.child,i)
		end
	end
	_cobj_for_luaobj[widget] = nil
	widget:removeFromParentAndCleanup(true)
end

--设置自己的名字
function UIEditModel:setName(layout,name)
	--检查名字是否重复
	local _root_layout = UIEditWin:get_root_layout()
	local _layout = UIEditModel:find_name_in_layout(_root_layout,name)
	if _layout or _widget_name[name] then
		CCMessageBox('Name already exists','Name already exists')
		return
	end

	_widget_name[layout.name] = false
	--修改名字
	layout.name = name
	local childs = layout.child or {}
	for i=1,#childs do
		childs[i].parent = name
	end
end

--重新设置父节点
function UIEditModel:setParent(widget,parent)
	local layout = nil
	local mylayout = _cobj_for_luaobj[widget].layout
	for k,v in pairs(_cobj_for_luaobj) do
		layout = v.layout
		if layout.name == parent then
			UIEditModel:delete_one_widget(widget)
	
			mylayout.pos = {0,0}
			mylayout.parent = parent
			local node = UIEditModel:create_by_layout(mylayout)
			k:addChild(node.view)
			if not layout.child then
				layout.child = {}
			end
			table.insert(layout.child,mylayout)
		end
	end
end

--根据名字查找到布局文件
function UIEditModel:find_name_in_layout(layout,name)
	if layout.name == name then
		return layout
	end
	if layout.child then
		for i=1,#layout.child do
			local clayout = UIEditModel:find_name_in_layout(layout.child[i],name) 
			if clayout then
				return clayout
			end
		end
	end
end

--读取配置文件
function UIEditModel:read_layout(layout)
	_cobj_for_luaobj = {}
	local node = UIEditModel:create_by_layout(layout)
	UIEditWin:create_by_layout(node)
end

--保存配置文件到文件
function UIEditModel:save_layout_file(fileName)
	if not fileName then fileName = "auto_save" end
	local layout = UIEditWin:get_root_layout()
	local str = fileName .. " = {\n"
	str = string.format("%s%s\n}",str,UIEditModel:table_to_string(layout,'\t'))
		-- local f = io.open("resource/data/uieditor/uieditor_test.lua",'wb+')
	local file = tostring(fileName)

	local f
	-- if flag == nil then
	--	f = io.open(UIEditModel.filePath,'wb+')  --从正式路径打开
	-- else
		f = io.open("resource/data/uieditor/"..file..".lua",'wb+') --从工具路径打开
	-- end

    if f then
        f:write(str)
       f:close()
        print("保存成功")
    end
    local flag = nil
	if UIEditModel.filePath == nil then --不是修改操作  当纯编辑保存
		local  index1,index2 = string.find(CCFileUtils:getWriteablePath(),"tools")
		local  path1 = string.sub(CCFileUtils:getWriteablePath(),1,index1-1)
		print("path1=",path1)
		UIEditModel.filePath = path1--.."Android\\client\\develop\\resource\\data\\uieditor\\"..fileName..".lua"
	else
		flag = string.find(UIEditModel.filePath,"tools")
	end

    local  first,second = string.find(CCFileUtils:getWriteablePath(),"UIEditor")
	local sub_path = string.sub(CCFileUtils:getWriteablePath(),1,second+1)
    if flag == nil then
    	if fileName ~='auto_save' then --自动保存只保存到工具路径
    		print("UIEditModel.filePath=",UIEditModel.filePath)
    		UIEditModel:copyfile(sub_path.."resource\\data\\uieditor\\"..fileName..".lua",UIEditModel.filePath)
    	end
    end
end 

--把table转成string用来保存到文件
function UIEditModel:table_to_string(t_date,flags)
	local str = ""
	local k_s = ""
	local v_s = "\t"
	for k,v in pairs(t_date) do
		if type(k) == "string" then
			k_s = string.format("%s=",k)
		end
		if type(v) == "table" then
			if k == "child" then
				v_s = "\n"
			end
			local tmp = UIEditModel:table_to_string(v,v_s)
			-- str = string.format("%s%s%s{%s},%s",str,flags,k_s,tmp,flags)
			str = string.format("%s%s%s{%s},%s",str,flags,k_s,tmp,"\n")
		elseif type(v) == "string" then
			str = string.format("%s%s%s%q,%s",str,flags,k_s,v,"\n")
		elseif (v == true or v == false) and k ~= 1 and k ~= 2 then
			str = string.format("%s%s%s%s,%s",str,flags,k_s,tostring(v),"\n")
		else
			str = string.format("%s%s%s%s,%s",str,flags,k_s,tostring(v),"\t")
		end

	end
	return str
end

--x对齐 --参数一个table
function UIEditModel:x_align(node_t)
	if #node_t > 1 then
		local minx,miny = UIEditModel:find_min_x_y(node_t)
		for i=1,#node_t do
			--设置位置
			local x,y = node_t[i]:getPosition()
			node_t[i]:setPosition(CCPointMake(minx,y))
			--修改配置文件
			local layout = _cobj_for_luaobj[node_t[i]].layout
			layout.pos[1] = minx
		end
	end
end

--y对齐
function UIEditModel:y_align(node_t)
	if #node_t > 1 then
		local minx,miny = UIEditModel:find_min_x_y(node_t)
		for i=1,#node_t do
			--设置位置
			local x,y = node_t[i]:getPosition()
			node_t[i]:setPosition(CCPointMake(x,miny))
			--修改配置文件
			local layout = _cobj_for_luaobj[node_t[i]].layout
			layout.pos[2] = miny
		end
	end
end

--查找最小的x y
function UIEditModel:find_min_x_y(node_t)
	local minx = 960
	local miny = 960
	local pos
	for i=1,#node_t do
		x,y= node_t[i]:getPosition()

		minx = math.min(x,minx)
		miny = math.min(y,miny)
	end
	return minx,miny
end

--设置x间距 锚点是0，0
function UIEditModel:x_distance(node_t,x_distance)
	table.sort(node_t, function(a,b) 
		local x1,y= a:getPosition()
		local x2,y= b:getPosition()
		return a:getPositionX()<b:getPositionX() end)

	for i=2,#node_t do
		local width = node_t[i-1]:getContentSize().width
		local x = node_t[i-1]:getPositionX()

		node_t[i]:setPositionX(x+x_distance+width)

		local layout = _cobj_for_luaobj[node_t[i]].layout
		layout.pos[1] = x+x_distance+width
	end
end

--设置y间距 锚点是0，0
function UIEditModel:y_distance(node_t,y_distance)
	table.sort(node_t, function(a,b) 
		local x1,y= a:getPosition()
		local x2,y= b:getPosition()
		return a:getPositionY()<b:getPositionY() end)

	for i=2,#node_t do
		local height = node_t[i-1]:getContentSize().height
		local y = node_t[i-1]:getPositionY()

		node_t[i]:setPositionY(y+y_distance+height)

		local layout = _cobj_for_luaobj[node_t[i]].layout
		layout.pos[2] = y+y_distance+height
	end
end

--复制一个控件
function UIEditModel:copy_widget(widget)
	local layout = Utils:table_clone(_cobj_for_luaobj[widget].layout)
	layout.pos[1] = layout.pos[1] + 10
	layout.pos[2] = layout.pos[2] + 10
	layout.name = UIEditModel:new_a_name("copy_",0)
	local node = UIEditModel:create_by_layout(layout)
	local parent = widget:getParent()
	local parent_layout = UIEditModel:get_cobj_for_luaobj(parent).layout
	table.insert(parent_layout.child,layout)
	parent:addChild(node.view)

	local childs = layout.child or {}
	for i=1,#childs do
		childs[i].parent = layout.name
	end
end

--保存删除控件
function UIEditModel:save_del_widget(widget)
	return Utils:table_clone(_cobj_for_luaobj[widget].layout)
end

--还原一个控件
function UIEditModel:re_del_widget(widget, parent)
	local layout = widget
	local node = UIEditModel:create_by_layout(layout)
	local parent_layout = UIEditModel:get_cobj_for_luaobj(parent).layout
	table.insert(parent_layout.child, layout)
	parent:addChild(node.view)

	local childs = layout.child or {}
	for i=1,#childs do
		childs[i].parent = layout.name
	end
end

--自动保存
function UIEditModel:auto_save(dt)
	_passtime = _passtime + dt
	if _passtime > 60  then
		print("自动保存")
		UIEditModel:save_layout_file("auto_save")
		_passtime = 0
	end
end

local _child_date = {}
function UIEditModel:get_child_date()
	-- print("get_child_date",#_child_date)
	return _child_date
end

function UIEditModel:get_parent_name(name)
	local layout = UIEditWin:get_root_layout()
	local clayout = UIEditModel:find_name_in_layout(layout,name)
	return clayout.parent
end

function UIEditModel:update_scroll(name,utype)
	local layout = UIEditWin:get_root_layout()
	local clayout = UIEditModel:find_name_in_layout(layout,name)
	if utype == 1 then
		--print("clayout.child",#clayout.child)
		if clayout.child then
			_child_date = clayout.child 
			return true
		end
	else
		local parent = UIEditModel:find_name_in_layout(layout,clayout.parent)
		if parent then
			_child_date = parent.child 
			return true
		end
	end

	return false
end

function UIEditModel:set_selected_by_name(name)
	for k,v in pairs(_cobj_for_luaobj) do
		if v.layout.name == name then
			UIEditor:setSelected(k)
		end
	end
end

--框选多个
function UIEditModel:rect_selected_group(UIRoot,sx,sy,ex,ey)
	local pos = {
		{sx,sy},
		{sx,ey},
		{ex,ey},
		{ex,sy},
	}

	if sx > ex then
		sx,ex = ex,sx
	end
	if sy > ey then
		sy,ey = ey,sy
	end
	local srect = CCRect(sx,sy,ex-sx,ey-sy)

	local snode = {}

	for i=sx,ex,10 do
		for j=sy,ey,10 do
			local node = UIEditModel:selectCCNode(UIRoot,i,j)

			if node then
				for i=1,#snode do
					if snode[i] == node then
						node = nil
					end
				end
			end
			--检查节点是不是在选择框之外
			if node then
				local flags = true
				local rect = node:boundingBox()
				local point = {
					{rect.origin.x,rect.origin.y},
					{rect.origin.x,rect.origin.y+rect.size.height},
					{rect.origin.x+rect.size.width,rect.origin.y},
					{rect.origin.x+rect.size.width,rect.origin.y+rect.size.height},
				}
				for i=1,#point do
					point[i] = node:getParent():convertToWorldSpace(CCPointMake(point[i][1],point[i][2]))
					if not CCRect:CCRectContainsPoint(srect,point[i]) then
						flags = false
						break
					end
				end
				if flags then
					snode[#snode+1] = node
				end
			end
		end
	end

	return snode
end


function UIEditModel:copyfile(source,destination)
	print("source,destination=",source,destination)
		sourcefile = io.open(source,'r')
		destinationfile = io.open(destination,'wb+')
		for line in sourcefile:lines() do
		destinationfile:write(line.."\n")
		end
		sourcefile:close()
		destinationfile:close()
end
