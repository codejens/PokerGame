---------LKH
---------2014-9-10
---------
---------排版工具类 --返回一个排好所有子节点的basepanel 
super_class.ZLayoutTools(ZAbstractBasePanel)
---------
---------
ZLayoutTools.LAYOUT_TYPE_HZL 	= 1;		--横向排版
ZLayoutTools.LAYOUT_TYPE_VTL 	= 2;		--纵向排版


--创建排版工具
local function LyoutToolsCreateFunction(self,node_table,tImage)
	-------
	--面板的宽和高
	self.panel_width = 0
	self.panel_height = 0
	--所有子节点
	if node_table ~= nil then
		for i=1,#node_table do
			--将所有传进来的节点保存到自身的数组里面
			self.all_child_table[#self.all_child_table+1] = node_table[i]
			local size = node_table[i]:getSize()
			self.panel_width = self.panel_width + size.width
			if size.height > self.panel_height then
				self.panel_height = size.height
			end
		end
	end
	
	-------create basepanel
	self.view = CCBasePanel:panelWithFile(0, 0, self.panel_width, self.panel_height, tImage)
	-------
	--添加所有节点
	self:AddNodeFunction()
end

---------
---------
function ZLayoutTools:__init()
	self.view = nil
	self.panel_width 	= 0	--面板宽
	self.panel_height	= 0	--面板高
	self.node_interval 	= 0 --每个子节点之前的间隙
	self.max_index		= 0 --最大的索引
	self.all_child_table = {}
end

--添加所有节点
function ZLayoutTools:AddNodeFunction()
	if self == nil or self.view == nil then
		return
	end
	self.panel_width = 0
	self.panel_height = 0
	local posx = 0
	for i=1,#self.all_child_table do
		if self.all_child_table[i] then
     		print("sssssssssss===============",i,self.all_child_table[i],posx)
			--self.all_child_table[i]:setAnchorPoint(CCPointMake(0.0,0.0))
			self.all_child_table[i]:setPosition(posx,0)
			self.view:addChild(self.all_child_table[i])
			local size = self.all_child_table[i]:getSize()
			posx = posx + size.width + self.node_interval
			self.panel_width = self.panel_width + size.width
			if size.height > self.panel_height then
				self.panel_height = size.height
			end
		end
	end
	self.view:setSize(self.panel_width,self.panel_height)
end

--排列所有节点
function ZLayoutTools:LayoutFunction()
	if self == nil or self.view == nil then
		return
	end
	self.panel_width = 0
	self.panel_height = 0
	local posx = 0
	for i=1,self.max_index do
		if self.all_child_table[i] then
			self.all_child_table[i]:setPosition(posx,0)
			local size = self.all_child_table[i]:getSize()
			posx = posx + size.width + self.node_interval
			self.panel_width = self.panel_width + size.width
			if size.height > self.panel_height then
				self.panel_height = size.height
			end
		end
	end
	self.view:setSize(self.panel_width,self.panel_height)
end

function ZLayoutTools:addChild( node,index )
	if index ~= nil then
		if index > self.max_index then
			self.max_index = index
		end
		table.insert(self.all_child_table,index,node)
	else
		self.max_index = self.max_index+1
		table.insert(self.all_child_table,self.max_index,node)
		--self.all_child_table[count] = node
	end
	self.view:addChild(node)
	self:LayoutFunction()
end

function ZLayoutTools:removeChild( node )
	if node == nil then
		return
	end
	for i=1,self.max_index do
		if self.all_child_table[i] == node then
			self.view:removeChild(node,true)
			self.all_child_table[i] = nil
			break;
		end
	end
	self:LayoutFunction()
	--print("ZLayoutTools:removeChild( node )",node,#self.all_child_table)
end

function ZLayoutTools:removeAllChild(  )
	for i=1,#self.max_index do
		if self.all_child_table[i] then
			self.view:removeChild(self.all_child_table[i],true)
		end
	end
	self.all_child_table = {}
	self:LayoutFunction()
end

function ZLayoutTools:getSize(  )
	if self.view == nil then
		return nil
	end
	return self.view:getSize()
end

---------
---------
function ZLayoutTools:create(interval,node_table,bg_image) --参数：所有需要排版的子节点table
	local panel = ZLayoutTools()
	panel.node_interval = interval
	LyoutToolsCreateFunction(panel,node_table,bg_image)
	panel:registerScriptFun()
	return panel;
end