
selectionComponent = simple_class()

function selectionComponent:__init(view)
	self.root_class = ''
	self.comp_class = ''
	self.params = {}
end

function selectionComponent:setTarget(target)
	self.target = target
	self.target_children = {}
	if target then
		local count = target:getChildrenCount()
		array = tolua.cast(array,'CCMutableArray<CCObject*>')

		for i=0, count do
			local node = ZXLuaUtils:getCCNodeChildrenByIndex(target,i)
			if node and node:getTag() >= 0 then
				self.target_children[#self.target_children+1] = node
			ZXLog('>>>>',node)

			end
		end

		local root = ZXLuaUtils:compareCCNodeRoot(UIEditor.UIRoot,target)
		ZXLog('>>>> root',root)

		self.root_class = ''
		self.comp_class = ''
		local wins = Window.getCreatedWindows()
		for k, v in pairs(wins) do
			if k.view == root then
				ZXLog(k,k.__classname)

				self.root_class = k.__classname
			elseif k.view == target then
				ZXLog(k,k.__classname)

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
	return self.target:getPosition()
end

function selectionComponent:setPosition( x,y , dontSend)
	self.target:setPosition(x,y)
	self:record()
	if not dontSend then
		self:send()
	end
end

function selectionComponent:setSize(w,h)
	self:record()
	if self.target.setSize then
		self.target:setSize(w,h)
	else
		self.target:setContentSize(CCSizeMake(w,h))
	end
end

function selectionComponent:getParent()
	return self.target:getParent()
end

function selectionComponent:setTexture(t)
	if self.target.getSize then
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

	local x,y = self.target:getPosition()
	local absPos = self.target:getParent():convertToWorldSpace(CCPoint(x,y))
	local tag = self.target:getTag()
	local size = self.target:getContentSize()
	self.params = {}
	self.params.rect = { x, y, absPos.x, absPos.y, size.width, size.height}
	self.params.tag = tag
	self.params.root_class = self.root_class 
	self.params.comp_class = self.comp_class 
	self.params.comp_id = self.comp_id 
	self.params.texture = self.texture

	if params_only then return end
	--------------------------------------------
	local info = windowsLayouts[self.root_class]
	if not info then
		info = {}
	end

	local comp_id = self.comp_id

	local layoutData = info[comp_id]
	if not layoutData then
		layoutData = {}
	end

	if self.target.getSize then
		local x,y = self.target:getPosition()
		local size = self.target:getSize()
		layoutData.rect = { x, y, size.width, size.height }
		layoutData.texture = self.texture
	else
		local x,y = self.target:getPosition()
		local size = self.target:getContentSize()
		layoutData.rect = { x, y, size.width, size.height }
		layoutData.texture = self.texture
	end
	info[comp_id] = layoutData
	windowsLayouts[self.root_class] = info
	-------------------------------------------
end

function selectionComponent:send()
	local params = table_serialize(self.params)
	if not self.target then 
		params = ''
	end
	local cmd1 = string.format('>refreshGUI(%s)',params)
	ZXLuaUtils:SendRemoteDebugMessage(cmd1)
	ZXLog("************", cmd1)

	--ZXLuaUtils:SendRemoteDebugMessage(
	--[[
	ZXLuaUtils:SendRemoteDebugMessage(
		string.format('>setSelected(%d,%d,%d,%d,%d)',
		tag,x,y,size.width,size.height))

		]]--
	local cmd = '>setSelectedChild({'
	for i, v in ipairs(self.target_children) do
		cmd = cmd .. string.format('%d,',i)
	end
	cmd = cmd .. '})'
	ZXLuaUtils:SendRemoteDebugMessage(cmd)

	--[[]
	local cmd = '>setCompClasses({'
	ZXLuaUtils:SendRemoteDebugMessage(
		string.format('>setCompClasses(%q,%q)',
		self.root_class,self.comp_class))
	]]--


end
--[[
function selectionComponent:record()



end
]]--
function selectionComponent:setSelectedChild(ii)

	--for i,v in ipairs(self.target_children) do
	--	print(i,ii)
	--end
	UIEditor:setSelected(self.target_children[ii])
end