----ZhanBuStruct.lua
----HJH
----2013-9-6
----
--	
--------------------------
super_class.ZhanBuEventStruct()
--------------------------
function ZhanBuEventStruct:__init(pack)
	if pack == nil then
		return
	end
	self.name = pack:readString()
	self.event_id = pack:readInt()
end
--------------------------
function ZhanBuEventStruct:create( name, event_id )
	local temp_info = ZhanBuEventStruct()
	temp_info.name = name
	temp_info.event_id = event_id
	return temp_info
end
--------------------------
super_class.ZhanBuStruct()
--------------------------
function ZhanBuStruct:__init()
	self.cur_time = 0
	self.event_info = {}
end
--------------------------
super_class.ZhanBuBuffStruct()
--------------------------
function ZhanBuBuffStruct:__init()
	self.buff_type = 0
	self.add_rate = 0
	self.time = 0
end