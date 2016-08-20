
selectionComponent = simple_class()

--全局开关
OPEN_EDIT = true

function selectionComponent:__init(view)
	self.root_class = ''
	self.comp_class = ''
	self.params = {}
end

function selectionComponent:setTarget(target)
	self.parent_lua_obj = nil
	self.target = target
	self.lua_obj = UIEditModel:get_cobj_for_luaobj(target)
	if target then
		local parent = self.target:getParent()
		if parent then
			self.parent_lua_obj = UIEditModel:get_cobj_for_luaobj(parent)
			-- print("x,y=",self.parent_lua_obj.layout.pos[1],self.parent_lua_obj.layout.pos[2])
		end
	end
	self.target_children = {}
	if target then
		local count = target:getChildrenCount()
		array = tolua.cast(array,'CCMutableArray<CCObject*>')

		for i=0, count do
			local node = ZXLuaUtils:getCCNodeChildrenByIndex(target,i)
			if node and node:getTag() >= 0 then
				self.target_children[#self.target_children+1] = node
				print('>>>>',node)
			end
		end

		local root = ZXLuaUtils:compareCCNodeRoot(UIEditor.UIRoot,target)
		--print('>>>> root',root)
		self.root_class = ''
		self.comp_class = ''
		local wins = Window.getCreatedWindows()
		for k, v in pairs(wins) do
			if k.view == root then
				--print(k,k.__classname)
				self.root_class = k.__classname
			elseif k.view == target then
				--print(k,k.__classname)
				self.comp_class = k.__classname
			end
		end

		local info = ZXLuaUtils:getCCNodeName(root,target)

		local _type, _depth, _index, _texture = string.match(info,"(%Z*)@(%Z*)@(%Z*)@(%Z*)")

		
		local comp_id = _type .. numberbit(_depth,2) .. numberbit(_index,3) 
		
		self.texture = _texture
		self.comp_id = comp_id
		self:record(true)
		self:send()
	else
		------------------------------
		self:send()
	end
end

function selectionComponent:getPosition()
	if self.lua_obj.getPosition then
		return self.lua_obj:getPosition()
	else
		return self.target:getPosition()
	end
end

function selectionComponent:receive(args)
	if not OPEN_EDIT then
		return
	end
	args = Utils:Split(args,",")
	print("args!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", args[1], args[2], args[3] == "",args[3], type(args[3]))
	local name = args[1] --参数名
	-- print(name,args[2],args[3])
	if name == "pos" then
		self:setPosition(args[2],args[3])
	elseif name == "size" then
		self:setSize(args[2],args[3],args[4])
		-- self:setSize(args[2],args[3])
	elseif name == "img_n" then
		self:setTexture(args[2])
	elseif name == "str" then
		self:setText(args[2])
	elseif name == "fontsize" then
		self:setFontSize(args[2])
	elseif name == "name" then
		self:setName(args[2])
	elseif name == "parent" then
		self:setParent(args[2])
	elseif name == "is_nine" then
		self:setNine(args[2])
	elseif name == "align" then
		self:setAlign(args[2])
	elseif name == "img_s" then
		self:setImgd(args[2])
	elseif name == "save" then
		if args[3] == "" then
			args[3] = "uieditor_test"
		end
		UIEditModel:save_layout_file(args[3])
	elseif name == "open" then
		self:oepn_file(args[2])
	elseif name == "flip" then
		self:setFlip(args[2], args[3])
	elseif name =="isVisible" then
		self:setVisible(args[2])
	elseif name == "x_distance" then
		UIEditor:x_distance(args[2])
	elseif name == "y_distance" then
		UIEditor:y_distance(args[2])
	elseif name == "scroll_type" then
		self:set_scroll_type(args[2])
	elseif name == "auto_load" then
		self:set_auto_load(args[3])
	end
end

function selectionComponent:set_auto_load(value)
	self.lua_obj.layout.auto_load = value
	if self.lua_obj.setText then
		self.lua_obj:setText(str)
	end
	
end

function selectionComponent:set_scroll_type(value)
	self.lua_obj.layout.scroll_type = value
	self:re_create()
end

function selectionComponent:oepn_file(path)
	print("path",path)
	local tempPath = path
	local index = string.find(path,"resource")
	path = string.sub(path,index,string.len(path))
	local index2, index3 = string.find(path, "uieditor")
	local index4, index5 = string.find(path, ".lua")	
	local fileName = string.sub(path,index3 + 2, index4 - 1)
	-- path = Utils:Split(path,"\\")
	local  first,second = string.find(CCFileUtils:getWriteablePath(),"UIEditor")
	local str = string.sub(CCFileUtils:getWriteablePath(),1,second+1)
	local flag = string.find(tempPath,"tools")
	if flag == nil then --该路径是游戏正式目录下
		-- pcall(os.execute("COPY "..tempPath.." "..str.."resource\\data\\uieditor\\"))  --坑爹的bat复制
		UIEditModel:copyfile(tempPath,str.."resource\\data\\uieditor\\"..fileName..".lua")
	else  --在工具目录下
		-- UIEditModel:copyfile(str.."resource\\data\\uieditor\\"..fileName..".lua",tempPath)
		-- pcall(os.execute("COPY "..str.."resource\\data\\uieditor\\"..fileName..".lua".." "..tempPath))
	end
    require ("../resource/data/uieditor/"..fileName)
	UIEditModel:read_layout(_G[fileName])
	UIEditModel.filePath = tempPath
	local dict = {fileName = fileName }
	dict = table_serialize(dict)
	local cmd1 = string.format('>refreshFileName(%s)',dict)
	ZXLuaUtils:SendRemoteDebugMessage(cmd1)
end

function selectionComponent:setImgd(img_s)
	self.lua_obj.layout.img_s = img_s
	--进度条需要重新创建
	if self.lua_obj.layout.class == "SProgress" 
	   or self.lua_obj.layout.class == "SSwitchBtn" then
		return self:re_create(zOrder)
	end

	if self.target.addTexWithFile then
		--self.lua_obj.layout.img_s = img_s
		self.target:addTexWithFile(CLICK_STATE_DOWN,img_s)
	end
end

function selectionComponent:setAlign(align)
	if self.lua_obj.layout.class == "SLabel" then
		self.lua_obj.layout.align = align
		UIEditModel:set_is_nine(self.target)
	end
end

function selectionComponent:setNine(is_nine)
	local value = false
	if is_nine == "true" then
		value = true
	end
	self.lua_obj.layout.is_nine = value
	UIEditModel:set_is_nine(self.target)
end

function selectionComponent:setFlip(args1, args2)
	-- UIEditModel:setFlip()
	local flipx = false
	local flipy = false

	if args1 == "true" then
		flipx = true
	end

	if args2 == "true" then
		flipy = true
	end

	self.lua_obj.layout.flip = {}
	self.lua_obj.layout.flip[1] = flipx
	self.lua_obj.layout.flip[2] = flipy

	UIEditModel:set_flip(self.target)
end

function selectionComponent:setVisible(isVisible)
	local temp = true
	if isVisible == "true" then
		temp = true
	elseif isVisible == "false" then
		temp = false
	end
	self.lua_obj.layout.isVisible = temp

	UIEditModel:set_IsVisible(self.target)
end

function selectionComponent:setName(name)
	UIEditModel:setName(self.lua_obj.layout,name)
end

function selectionComponent:setParent(parent)
	--self.lua_obj.layout.parent = parent
	UIEditModel:setParent(self.target,parent)

end

function selectionComponent:setFontSize(size)
	if self.lua_obj.setText then
		self.lua_obj.layout.fontsize = size
		self.lua_obj:setFontSize(size)
	end
end

function selectionComponent:setText(str)
	if self.lua_obj.setText then
		self.lua_obj.layout.str = str
		self.lua_obj:setText(str)
	
	end
end

function selectionComponent:setPosition(x, y, dontSend)
	if self.lua_obj.setPosition then
		self.lua_obj:setPosition(x, y)
	else
		self.target:setPosition(x, y)
	end
	self.lua_obj.layout.pos = {x, y}
	if not dontSend then
		self:send()
	end
end

function selectionComponent:setSize(w,h,zOrder)
	
	local is_zOrder = false

	if tonumber(zOrder) >= 1 then
		is_zOrder = true
		self.lua_obj.layout.zOrder = tonumber(zOrder)
	end

	if tonumber(w) == 0  then
		local parent = self.target:getParent()
		self.target:retain()
		self.target:removeFromParentAndCleanup(true)
		parent:addChild(self.target, zOrder)
		self.target:release()
		return
	end
	if w == "-1" then
		local tempW = ZXResMgr:sharedManager():getTextureSize(self.lua_obj.layout.img_n).width
		w = tostring(tempW)
		is_zOrder  = true
	end

	if h == "-1" then
		local tempH = ZXResMgr:sharedManager():getTextureSize(self.lua_obj.layout.img_n).height
		h = tostring(tempH)
		is_zOrder  = true
	end

	self.lua_obj.layout.size = {w,h}
	--进度条需要重新创建
	if self.lua_obj.layout.class == "SProgress" then
		self:re_create(zOrder)
		return
	end

	if self.lua_obj.setSize then
		self.lua_obj:setSize(w,h)
	elseif self.target.setSize then
		self.target:setSize(w,h)
	else
		self.target:setContentSize(CCSizeMake(w,h))
	end

	if is_zOrder then
		local parent = self.target:getParent()
		self.target:retain()
		self.target:removeFromParentAndCleanup(true)
		parent:addChild(self.target, zOrder)
		self.target:release()
	end
end

function selectionComponent:re_create(zOrder)
	local parent = self.target:getParent()
	UIEditModel:delete_one_widget(self.target)
	local node = UIEditModel:create_by_layout(self.lua_obj.layout)
	local parent_layout = UIEditModel:get_cobj_for_luaobj(parent).layout
	table.insert(parent_layout.child,self.lua_obj.layout)
	parent:addChild(node.view,zOrder or 1)
end

function selectionComponent:getParent()
	return self.target:getParent()
end

function selectionComponent:setTexture(t)
	--进度条需要重新创建
	self.lua_obj.layout.img_n = t
	if self.lua_obj.layout.class == "SProgress"
	or self.lua_obj.layout.class == "SSwitchBtn" then
		return self:re_create(zOrder)
	end

	if self.lua_obj.setTexture then
		self.lua_obj:setTexture(t)
	elseif self.target.getSize then
		if self.target.setTexture then
			self.target:setTexture(t)
			self:record()
		end	
	else
		if self.target.replaceTexture then
			self.target:replaceTexture(t)
			self:record()
		end	
	end
end

function selectionComponent:record(params_only)
	self.params = self.lua_obj.layout
end

function selectionComponent:send()
	self.params = {}
	if self.lua_obj and self.lua_obj.layout then
		for k,v in pairs(self.lua_obj.layout) do
			if k~= "child" then
				self.params[k] = v
			end
		end
	end
	if self.lua_obj then
		if self.params.size == nil or self.params.size[1] == nil or self.params.size[2] == nil then
			local s = self.lua_obj.view:getContentSize()
			self.params.size = self.params.size or {}
			self.params.size[1] = s.width
			self.params.size[2] = s.height
		end
	end
	if self.parent_lua_obj and self.parent_lua_obj.layout then
		-- for k , v in pairs(self.parent_lua_obj.layout) do
		
		self.params.parent_layout = {}
		self.params.parent_layout.size = {self.parent_lua_obj.layout.size[1],self.parent_lua_obj.layout.size[2]}
		if self.params.parent_layout.size == nil or self.params.parent_layout.size[1] == nil or self.params.parent_layout.size[2] == nil then
			local s = self.parent_lua_obj.view:getContentSize()
			self.params.parent_layout.size = self.params.parent_layout.size or {}
			self.params.parent_layout.size[1] = s.width
			self.params.parent_layout.size[2] = s.height
		end
		self.params.parent_layout.pos = {self.parent_lua_obj.layout.pos[1],self.parent_lua_obj.layout.pos[2],}
		-- end
	end

	local params = table_serialize(self.params)
	if not self.target then 
		params = ''
	end
	local cmd1 = string.format('>refreshGUI(%s)',params)
	--print("tt==",cmd1)
	ZXLuaUtils:SendRemoteDebugMessage(cmd1)
	--print("************", cmd1)
	--ZXLuaUtils:SendRemoteDebugMessage(
	--[[
	ZXLuaUtils:SendRemoteDebugMessage(
		string.format('>setSelected(%d,%d,%d,%d,%d)',
		tag,x,y,size.width,size.height))

		]]--
	-- local cmd = '>setSelectedChild({'
	-- for i, v in ipairs(self.target_children) do
	-- 	cmd = cmd .. string.format('%d,',i)
	-- end
	-- cmd = cmd .. '})'
	-- ZXLuaUtils:SendRemoteDebugMessage(cmd)

	--[[]
	local cmd = '>setCompClasses({'
	ZXLuaUtils:SendRemoteDebugMessage(
		string.format('>setCompClasses(%q,%q)',
		self.root_class,self.comp_class))
	]]--
end

function selectionComponent:setSelectedChild(ii)
	--for i,v in ipairs(self.target_children) do
	--	print(i,ii)
	--end
	UIEditor:setSelected(self.target_children[ii])
end