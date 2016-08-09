RoomListConfig = {}

function RoomListConfig:init()
	require "../data/prop_room_list"
end

function RoomListConfig:get_room_info_by_type(grade,type)
	local big_room_list = prop_room_list[grade]
	if not big_room_list then
		return
	end
	local room_info = big_room_list[type]
	if not room_info then
		return
	end
	return Utils:table_deepcopy(room_info)
end

RoomListConfig:init()