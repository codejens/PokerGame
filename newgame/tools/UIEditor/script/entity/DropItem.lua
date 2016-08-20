-- DropItem.lua
-- created by aXing on 2013-2-25
-- 游戏场景上面的掉落物品

require "entity/Entity"

DropItem = simple_class(Entity)

function DropItem:__init( handle )
	Entity.__init(self,handle)
end

-- 实体更改自己的属性
function DropItem:change_entity_attri( attri_type, attri_value )

	local old_value 	= self[attri_type]
	Entity.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	if attri_type == "model" then
		self.model = ZXEntityMgr:toDropItem(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换drop item出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "item_id" then
		if self.model ~= nil then
			-- 掉落物品设置名字和图标
			local item 	= ItemConfig:get_item_by_id(attri_value)
			local color = ItemModel:get_item_color(attri_value)
			print("item_id",attri_value,"color",color,item.name);
			if self.name_lab ~= nil then
				self.name_lab.view:setText( color .. item.name )
			else
				local bill_board_node = self.model:getBillboardNode()
				local bill_board_node_size = bill_board_node:getContentSize()
				local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
				local name_lab = Label:create( nil, 0, 0, color ..item.name )
				self.name_lab = name_lab
				local name_lab_size = name_lab:getSize()			
				bill_board_node:addChild(name_lab.view)
			   	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
			end
			--self.model:setName(color .. item.name)
			local icon 	= ItemConfig:get_item_icon(attri_value)
			self.model:changeIcon(icon)
		end
	end
end

-- 注册选中事件
function DropItem:register_click_event(  )
	local function on_click( entity_handler )
		DropItemCC:req_pick_up_drop_item( entity_handler )
	end
	self.model:setClickEvent(GetLuaFuncID(on_click))
end
