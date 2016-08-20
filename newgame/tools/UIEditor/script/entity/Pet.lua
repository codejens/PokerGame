
-- Pet.lua
-- created by aXing on 2012-12-1
-- 游戏场景中的宠物实体类

require "entity/Monster"

Pet = simple_class(Monster)

local PET_GUANGHUAN_TAG = 666;

function Pet:__init( handle )
	Monster.__init(self,handle)
	self.type = "Pet";
end

function Pet:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toPet(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换actor出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "body" then
		self._body_id = attri_value
		EntityManager.setNPCBody(self)
	end
end

function Pet:setBody()
	attri_value = self._body_id
	if self.model ~= nil then
		self.body = attri_value;
		print("他人宠物的body id",self.body);
		local body_effect_id = ZXLuaUtils:highByte( self.body );
		if ( body_effect_id ~= 0 ) then 
			-- 播放特效
			local ani_table = effect_config[body_effect_id]
			-- 先删除之前的特效
			self.model:stopEffect(PET_GUANGHUAN_TAG);
			-- 特定副本不显示宠物光环
			if SetSystemModel:is_fuben_optimize() == false then 
				-- 宠物特效tag
				self.model:playEffect( ani_table[1],PET_GUANGHUAN_TAG,7,ani_table[3],nil,0 ,0,0,ani_table[2]);
			end
		end

		local body_id	= ZXLuaUtils:lowByte( self.body );
		if self.model ~= nil then
			local path = "scene/monster/"..body_id;
			self.model:changeBody( path);
		end
	end
end

function Pet:setName(name_color,name,level,display_name)

	local model = self.model
	local bill_board_node = model:getBillboardNode()
	local bill_board_node_size = bill_board_node:getContentSize()

	self:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
	--print("new_entity.name_color",new_entity.name_color,name_table[2],name);
	local name_lab = Label:create( nil, 0, 0, "#c" .. Utils:c3_dec_to_hex(name_color) ..display_name..LangGameString[437].. name ) -- [437]="的"
	self.name_lab = name_lab
	local name_lab_size = name_lab:getSize()			
	bill_board_node:addChild(name_lab.view)
	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
end

function Pet:remove_guanghuan()
	-- 先删除之前的特效
	self.model:stopEffect(PET_GUANGHUAN_TAG);	
end