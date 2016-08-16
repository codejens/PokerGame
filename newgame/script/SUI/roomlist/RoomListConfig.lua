RoomListConfig = {}

function RoomListConfig:init()
	self.is_load = self.is_load or false
	if not self.is_load then
		require "../data/prop_room_list"
	end
end

function RoomListConfig:get_main_room_config(main_id)
	self:init()
	return Utils:table_deepcopy(prop_room_list[main_id])
end 

function RoomListConfig:get_child_room_config(main_id,child_id)
	self:init()
	local main_room_config = self:get_main_room_config()
	if main_room_config then
		return main_room_config[child_id]
	end
end
