----PlantStruct.lua
----HJH
----2013-7-25
----
-- 种植
--------------------------
super_class.PlantFriendInfo()
--------------------------
function PlantFriendInfo:__init(pack)
	if pack == nil then
		return
	end
	self.id = pack:readInt()
	self.state = pack:readByte()
	print("PlantFriendInfo id,state", self.id, self.state)
end
--------------------------
super_class.PlantEventInfo()
--------------------------
function PlantEventInfo:__init(pack)
	if pack == nil then
		return
	end
	self.time = pack:readInt() + Utils:get_mini_bate_time_base()
	self.op_type = pack:readByte()
	self.name = pack:readString()
end
--------------------------
super_class.PlantLandStruct()
--------------------------
function PlantLandStruct:__init(pack)
	if pack == nil then
		return
	end
	self.seed_type = pack:readByte()
	self.seed_quality = pack:readByte()
	self.seed_state = pack:readByte()
	self.seed_time = pack:readInt() + Utils:get_mini_bate_time_base()
end
--------------------------
super_class.PlantRoleStruct()
--------------------------
function PlantRoleStruct:__init(pack)
	if pack == nil then
		return
	end
	self.role_id = pack:readInt()
	self.role_name = pack:readString()
	self.level = pack:readByte()
	self.cur_water_power = pack:readWord()
	self.max_water_power = pack:readWord()
	self.water_cd = pack:readUInt() + Utils:get_mini_bate_time_base()
	self.luck_type = pack:readByte()
	self.luck_time = pack:readUInt() + Utils:get_mini_bate_time_base()
	self.land_num = pack:readInt()
	self.land_info = {}
	for i = 1, self.land_num do
		self.land_info[i] = PlantLandStruct(pack)
	end
	print("self.role_id,self.role_name,self.level, self.cur_water_power, self.max_water_power, self.water_cd",self.role_id, self.role_name, self.level, self.cur_water_power, self.max_water_power, self.water_cd)
end
--------------------------
function PlantRoleStruct:create( id, name )
	local temp = PlantRoleStruct()
	temp.role_id = id
	temp.role_name = name
	temp.level = 0
	temp.cur_water_power = 0
	temp.max_water_power = 0
	temp.water_cd = 0
	temp.luck_type = 0
	temp.luck_time = 0
	temp.land_num = 0
	temp.land_info = {}
	return temp
end
--------------------------
super_class.PlantMyRoleStruct()
--------------------------
function PlantMyRoleStruct:__init(pack)
	if pack == nil then
		return
	end
	self.role_id = pack:readInt()
	self.role_name = pack:readString()
	self.level = pack:readByte()
	self.cur_water_power = pack:readWord()
	self.max_water_power = pack:readWord()
	self.water_cd = pack:readUInt() + Utils:get_mini_bate_time_base()
	self.luck_type = pack:readByte()
	self.luck_type_select = 1
	self.luck_time = pack:readUInt() + Utils:get_mini_bate_time_base()
	self.land_num = pack:readInt()
	self.land_info = {}
	for i = 1, self.land_num do
		self.land_info[i] = PlantLandStruct(pack)
	end
	self.cur_land_select = nil
	--self.cur_plant_seed_select = nil
	self.cur_plant_seed_type = 1
	self.cur_plant_seed_quality = 1
	--self.cur_luck_index_select = 1
	self.cur_plant_select = nil
	self.cur_build_all_select = 1
	self.plant_event_info = {}
	self.plant_friend_info = {}
	self.my_water_num = 0
	self.is_get_price = 0
	self.init_event = false
	self.cur_build_num = PlantConfig:get_xianlu_max_num( self.level )
end
--------------------------
function PlantMyRoleStruct:create(id, name)
	local temp = PlantMyRoleStruct()
	temp.role_id = id
	temp.role_name = name
	temp.level = 0
	temp.cur_water_power = 0
	temp.max_water_power = 0
	temp.water_cd = 0
	temp.luck_type = 0
	temp.luck_type_select = 1
	temp.luck_time = 0
	temp.land_num = 0
	temp.land_info = {}
	temp.cur_land_select = nil
	temp.cur_plant_seed_type = 1
	--self.cur_luck_index_select = 1
	temp.cur_plant_select = nil
	temp.cur_build_all_select = 1
	temp.plant_event_info = {}
	temp.plant_friend_info = {}
	temp.my_water_num = 0
	temp.is_get_price = 0
	temp.init_event = false
	temp.cur_build_num = PlantConfig:get_xianlu_max_num( PlantConfig:get_dong_fu_max_level() )
	return temp
end