-- Entity.lua
-- created by aXing on 2012-12-1
-- 游戏场景中实体基类
-- 它主要负责管理场景中的实体的位置信息，创建跟消亡等

Entity = simple_class()

function Entity:__init( handle )
	self.handle = handle
	self._lod = 0

	self.__classname = "Entity"

	--操作优先级，用于控制操作，输入优先级>=当前操作优先级，操作才可执行
	--影响函数
	-- setIsVisible
	-- setModelIsVisible
	self._op_priority  = 0
end

-- 实体析构
function Entity:destroy(  )
	ZXEntityMgr:sharedManager():destroyEntity(self.handle)
	self.model = nil
	self.role_name_panel = nil
end

-- 实体更改自己的属性
function Entity:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	self[attri_type]	= attri_value
end

function Entity:isActionBlocking()
	return false
end

function Entity:setName(name_color,name)
	local model = self.model
	local bill_board_node = model:getBillboardNode()
	local bill_board_node_size = bill_board_node:getContentSize()
	
	local temp = "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	self:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
		print("Entity:setName name_color,name,temp", name_color,name,temp)
	local name_lab = Label:create( nil, 0, 0, temp )
	self.name_lab = name_lab
	local name_lab_size = name_lab:getSize()			
	bill_board_node:addChild(name_lab.view)
	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
end

--
-- 隐藏一个entity
--
function Entity:setIsVisible(state, opp)
	opp = opp or 0
	local model = self.model
	local old_priority = self._op_priority

	if opp >= self._op_priority then
		model:setIsVisible(state)
		model:showShadow(state)
		self._op_priority = opp
	end

	return old_priority
end

--
-- 隐藏一个entity
-- 保留阴影
--
function Entity:setModelIsVisible(state, opp)
	opp = opp or 0
	local old_priority = self._op_priority

	if opp >= self._op_priority then
		local model = self.model
		model:setIsVisible(state)
		self._op_priority = opp
	end

	-- 返回老的model优先级(在本次设置之前的优先级)
	return old_priority
end

-- 
-- 隐藏一个entity的影子
-- 保留model
--
function Entity:setShadowIsVisible(state)
	local model = self.model
	model:showShadow(state)
end

-- 设置model可见性优先级
function Entity:setOperationPriority(val)
	self._op_priority = val or 0
end

function Entity:getOperationPriority()
	return self._op_priority
end

function Entity:talk(msg,delay,emote)
	msg = movieParseDialogText(msg,emote)
	EntityDialog(self.model:getBillboardNode(), msg , delay);
end