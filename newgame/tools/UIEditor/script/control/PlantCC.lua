----PlantCC.lua
----HJH
----2013-7-25
----
-- 	
PlantCC = {}
------------------------
--c->s 157-1洞府进入
function PlantCC:client_etner_room(id)
	print("PlantCC:enter_room id",id)
	local pack = NetManager:get_socket():alloc(157, 1)
	pack:writeInt(id)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-1洞府返回信息
function PlantCC:server_enter_info(pack)
	print("PlantCC:server_enter_info")
	local temp_info = PlantRoleStruct(pack)
	PlantModel:enter_plant_room( temp_info )
end
------------------------
--c->s 157-2 退出
function PlantCC:client_exit()
	print("PlantCC:client_exit")
	local pack = NetManager:get_socket():alloc(157, 2)
	NetManager:get_socket():SendToSrv(pack)	
end
------------------------
--c->s 157-3升级
function PlantCC:client_level_up()
	print("PlantCC:client_level_up")
	local pack = NetManager:get_socket():alloc(157, 3)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-3升级通知
function PlantCC:server_level_up(pack)
	local cur_level = pack:readByte()
	print("PlantCC:server_level_up cur_level",cur_level)
	PlantModel:update_my_plant_room_level( cur_level )
end
------------------------
--c->s 157-4灵泉充能
function PlantCC:client_water_power()
	print("PlantCC:client_water_power")
	local pack = NetManager:get_socket():alloc(157, 4)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-4灵泉充能更新
function PlantCC:server_water_power(pack)
	local id = pack:readInt()
	local num = pack:readWord()
	local time = pack:readUInt()
	print("PlantCC:server_water_power id, num, time", id, num, time)
	PlantModel:update_water_power(id, num, time)
end
------------------------
--c->s 157-5种子类型
function PlantCC:client_seed_select_type(index)
	print("PlantCC:client_seed_select_type index", index)
	local pack = NetManager:get_socket():alloc(157, 5)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-5种子品质
function PlantCC:server_seed_select_type(pack)
	local seed_type = pack:readByte()
	local seed_quality = pack:readByte()
	print("PlantCC:server_seed_select_type seed_type, seed_quality", seed_type, seed_quality )
	PlantModel:update_cur_seed_select( seed_type, seed_quality )
end
------------------------
--c->s 157-6刷新种子品质
function PlantCC:client_refresh_seed_quality(index)
	print("PlantCC:client_refresh_seed_quality index", index)
	local pack = NetManager:get_socket():alloc(157, 6)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-7种子品质一键满级
function PlantCC:client_seed_full_level(index)
	print("PlantCC:client_seed_full_level index",index)
	local pack = NetManager:get_socket():alloc(157, 7)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-8种植
function PlantCC:client_plant(index, land_index)
	print("PlantCC:client_plant index,land_index", index, land_index )
	local pack = NetManager:get_socket():alloc(157, 8)
	pack:writeByte(index)
	pack:writeByte(land_index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-8种植通知
function PlantCC:server_plant(pack)
	local id = pack:readInt()
	local build_num = pack:readWord()
	local land_id = pack:readByte()
	local seed_type = pack:readByte()
	local seed_quality = pack:readByte()
	local time = pack:readUInt()
	print("PlantCC:server_plant id, build_num, land_id, seed_type, seed_quality, time", id, build_num, land_id, seed_type, seed_quality, time)
	PlantModel:update_build_seed( id, build_num, land_id, seed_type, seed_quality, time )
end
------------------------
--c->s 157-9批量种植
function PlantCC:client_plant_all(seed_type, seed_quality)
	print("PlantCC:client_plant_all seed_type, seed_quality", seed_type, seed_quality)
	local pack = NetManager:get_socket():alloc(157, 9)
	pack:writeByte(seed_type)
	pack:writeByte(seed_quality)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-10一键收获
function PlantCC:client_get_all()
	print("PlantCC:client_get_all")
	local pack = NetManager:get_socket():alloc(157, 10)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-11植物可种可收状态
function PlantCC:server_plant_state(pack)
	--byte：bit0 灵泉，bit1 草，bit2 虫，bit4 可种，bit5 可收获
	local plant_state = pack:readByte()
	print("PlantCC:server_plant_state plant_state", plant_state)
end
------------------------
--s->c 157-12植物病态通知
function PlantCC:server_plant_event(pack)
	local id = pack:readInt()
	local land_id = pack:readByte()
	local plant_state = pack:readByte()
	print("PlantCC:server_plant_event id, land_id, plant_state", id, land_id, plant_state)
	PlantModel:update_plant_state( id, land_id, plant_state )
end
------------------------
--c->s 157-12除草虫
function PlantCC:client_kill_worm(index)
	print("PlantCC:client_kill_worm index", index)
	local pack = NetManager:get_socket():alloc(157, 12)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-13催熟
function PlantCC:client_quick(index)
	print("PlantCC:client_quick index", index)
	local pack = NetManager:get_socket():alloc(157, 13)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-13植物成熟通知
function PlantCC:server_quick(pack)
	local role_id = pack:readInt()
	local plant_index = pack:readByte()
	local time = pack:readInt()
	print("PlantCC:server_quick role_id,plant_index, time", role_id, plant_index, time)
	PlantModel:update_plant_quick_info( role_id, plant_index, time )
end
------------------------
--c->s 157-14铲除
function PlantCC:client_clear(index)
	print("PlantCC:client_clear index", index)
	local pack = NetManager:get_socket():alloc(157, 14)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-14铲除通知
function PlantCC:server_clear(pack)
	local id = pack:readInt()
	local land_id = pack:readByte()
	print("PlantCC:server_clear id, land_id", id, land_id)
	PlantModel:update_clear_info(id, land_id)
end
------------------------
--c->s 157-15收获
function PlantCC:client_get(index)
	print("PlantCC:client_get index", index)
	local pack = NetManager:get_socket():alloc(157, 15)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-15收获通知
function PlantCC:server_get(pack)
	local id = pack:readInt()
	local land_id = pack:readByte()
	print("PlantCC:server_get id, land_id", id, land_id)
	PlantModel:update_get( id, land_id )
end
------------------------
--c->s 157-16灵泉领取奖励
function PlantCC:client_water_get_price()
	print("PlantCC:client_water_get_price")
	local pack = NetManager:get_socket():alloc(157, 16)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-17召唤土地
function PlantCC:client_luck(index)
	print("PlantCC:client_luck")
	local pack = NetManager:get_socket():alloc(157, 17)
	pack:writeByte(index)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-17召唤通知
function PlantCC:server_luck(pack)
	local ttype = pack:readByte()
	local time = pack:readUInt()
	print("PlantCC:server_luck ttype, time", ttype, time)
	PlantModel:update_luck( ttype, time )
end
------------------------
--c->s 157-18管家保存
function PlantCC:client_housekeeper(auto_get, auto_plant, seed_type, seed_quality, num)
	print("PlandCC:client_housekeeper auto_get, auto_plant, seed_type, seed_quality, num", auto_get, auto_plant, seed_type, seed_quality, num)
	local pack = NetManager:get_socket():alloc(157, 18)
	pack:writeByte(auto_get)
	pack:writeByte(auto_plant)
	pack:writeByte(seed_type)
	pack:writeByte(seed_quality)
	pack:writeUInt(num)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-19查看事件
function PlantCC:client_event()
	print("PlantCC:client_event")
	local pack = NetManager:get_socket():alloc(157, 19)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-19洞府事件
function PlantCC:server_event(pack)
	local num = pack:readInt()
	local temp_info = {}
	for i = 1, num do
		temp_info[i] = PlantEventInfo(pack)
	end
	print("PlantCC:server_event num ", num)
	PlantModel:update_event_info(temp_info)
end
------------------------
--c->s 157-20取消自动保存
function PlantCC:client_cancel_auto_plant()
	print("PlantCC:client_cancel_auto_plant")
	local pack = NetManager:get_socket():alloc(157, 20)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--c->s 157-21获取自动保存信息
function PlantCC:client_get_auto_plant_info()
	print("PlantCC:client_get_auto_plant_info")
	local pack = NetManager:get_socket():alloc(157, 21)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s->c 157-21返回自动保存信息
function PlantCC:server_get_auto_plant_info(pack)
	local is_save = pack:readByte()
	local auto_get = pack:readByte()
	local auto_plant = pack:readByte()
	print("PlantCC:server_get_auto_plant_info is_save, auto_get, auto_plant", is_save, auto_get, auto_plant)
	PlantModel:update_auto_plant(is_save, auto_get, auto_plant)
end
------------------------
--s->c 157-22返回好友洞府
function PlantCC:server_return_friend_state(pack)
	local num = pack:readInt()
	local friend_info = {}
	for i = 1, num do
		friend_info[i] = PlantFriendInfo(pack)
	end
	print("PlantCC:server_return_friend_state num", num)
	PlantModel:update_return_plant_room_friend_info(friend_info)
end
------------------------
--s->c 157-23更新当前洞府
function PlantCC:server_update_cur_state(pack)
	local id = pack:readInt()
	local water_num = pack:readWord()
	print("PlantCC:server_update_cur_state id, water_num", id, water_num)
	PlantModel:update_cur_plant_room( id, water_num )
end
------------------------
--c->s 157-24一键催熟
function PlantCC:client_one_key_quick()
	print("PlantCC:client_one_key_quick")
	local pack = NetManager:get_socket():alloc(157, 24)
	NetManager:get_socket():SendToSrv(pack)
end
------------------------
--s-.c 157-25更新自己洞府
function PlantCC:server_update_my_state(pack)
	local build_num = pack:readWord()
	local power_num = pack:readByte()
	local get_price = pack:readByte()
	print("PlantCC:server_update_my_state build_num, power_num, get_price", build_num, power_num, get_price)
	PlantModel:update_my_plant_room(build_num, power_num, get_price)
end