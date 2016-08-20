-- PlantEx.lua
-- create by hwl 2015-1-6
-- 游戏场景中的采集怪(需要2帧的采集物)的实体类

require "entity/Actor"

PlantEx = simple_class(Actor)

local frameloc = "scene/monster/"
local eAnimationXHorse = 5

function PlantEx:__init( handle )
	Actor.__init(self,handle)
	self.type = "PlantEx"
end

-- 实体更改自己的属性
function PlantEx:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		print('+++++++++attri_value', attri_value)
		self.model = ZXEntityMgr:toMonster(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换Monster出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "body" then
		if self.model ~= nil then
			self._body_id = attri_value
			EntityManager.setNPCBody(self)
		end
	end
end

function PlantEx:setBody()
	local attri_value = self._body_id
	if self.model ~= nil then
		local path = frameloc .. attri_value
		self.model:changeBody(path)
	end
end

function PlantEx:setName(name_color,name)
	name = Utils:parseNPCName(name)
	local model = self.model
	local bill_board_node = model:getBillboardNode()
	local bill_board_node_size = bill_board_node:getContentSize()
	
	local temp = "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	self:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
	
	local name_lab = Label:create( nil, 0, 0, temp )
	self.name_lab = name_lab
	local name_lab_size = name_lab:getSize()			
	bill_board_node:addChild(name_lab.view)
	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
end