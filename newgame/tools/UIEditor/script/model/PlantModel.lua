----PlantModel.lua
----HJH
----2013-8-8
----
PlantModel = {}
----------------------
local _my_plant_room_info = nil
local _cur_plant_room_info = nil
local _init_plant_room_info = false
local _update_list = {}
----------------------
function PlantModel:fini( ... )
	_init_plant_room_info = false
	-- _my_plant_room_info = nil
	-- _my_plant_room_info = PlantMyRoleStruct()
	-- _cur_plant_room_info = nil
	-- _cur_plant_room_info = PlantRoleStruct()
end
----------------------
function PlantModel:get_update_list()
	return _update_list
end
----------------------
function PlantModel:clear_update_list()
	_update_list = nil
	_update_list = {}
end
----------------------
function PlantModel:show_plant_win()
	if GameSysModel:isSysEnabled( GameSysModel.DongFu, true ) then
		UIManager:show_window("plant_win")
	end
end
----------------------
function PlantModel:data_add_my_friend_info(info)
	for i = 1, #info do
		local is_same = false
		for j = 1, #_my_plant_room_info.plant_friend_info do
			if _my_plant_room_info.plant_friend_info[j].id == info[i].id then
				_my_plant_room_info.plant_friend_info[j].state = info[i].state
				is_same = true
			end
		end
		if is_same == false then
			table.insert( _my_plant_room_info.plant_friend_info, info[i] )
		end
	end
end
----------------------
function PlantModel:get_init_plant_room_info()
	return _init_plant_room_info
end
----------------------
function PlantModel:set_init_plant_room_info(result)
	_init_plant_room_info = result
end
----------------------
function PlantModel:reinit_plant_room_info()
	local cur_play = EntityManager:get_player_avatar()
	_my_plant_room_info = nil
	_my_plant_room_info = PlantMyRoleStruct:create( cur_play.id, cur_play.name )
	_cur_plant_room_info = nil
	_cur_plant_room_info = PlantRoleStruct:create( cur_play.id, cur_play.name )
	_init_plant_room_info = true
	PlantModel:clear_update_list()
end
----------------------
function PlantModel:get_cur_plant_room_info()
	if _cur_plant_room_info.role_id == _my_plant_room_info.role_id then
		return _my_plant_room_info
	else
		return _cur_plant_room_info
	end
end
----------------------
function PlantModel:get_is_my_room()
	if _cur_plant_room_info.role_id == _my_plant_room_info.role_id then
		return true
	else
		return false
	end 
end
----------------------
function PlantModel:set_cur_plant_room_info(info)
	_cur_plant_room_info = nil
	_cur_plant_room_info = info
	print("PlantModel:set_cur_plant_room_info info.rold_id, _my_plant_room_info.role_id", info.role_id, _my_plant_room_info.role_id, info.role_name, _my_plant_room_info.role_name)
	if info.rold_id == _my_plant_room_info.rold_id then
		_my_plant_room_info.level = info.level
		_my_plant_room_info.cur_water_power = info.cur_water_power
		_my_plant_room_info.max_water_power = info.max_water_power
		_my_plant_room_info.water_cd = info.water_cd
		_my_plant_room_info.luck_type = info.luck_type
		_my_plant_room_info.luck_time = info.luck_time
		_my_plant_room_info.land_num = info.land_num
		_my_plant_room_info.land_info = info.land_info
	end
end
----------------------
function PlantModel:set_cur_luck_type_select(index)
	_my_plant_room_info.luck_type_select = index
end
----------------------
function PlantModel:get_my_empty_land()
	local temp_land = 0
	for i = 1, #_my_plant_room_info.land_info do
		print("_my_plant_room_info.land_info[i].seed_type",_my_plant_room_info.land_info[i].seed_type)
		if _my_plant_room_info.land_info[i].seed_type <= 0 then
			temp_land = temp_land + 1
		end
	end
	return temp_land
end
----------------------
function PlantModel:get_quick_plant_num()
	local temp_land = 0
	local cur_time = os.time()
	for i = 1, #_my_plant_room_info.land_info do
		if cur_time - _my_plant_room_info.land_info[i].seed_time < 0 then
			temp_land = temp_land + 1
		end
	end
	return temp_land
end
----------------------
function PlantModel:get_init_event_result()
	return _my_plant_room_info.init_event
end
----------------------
function PlantModel:set_init_event_result(result)
	_my_plant_room_info.init_event = result
end
----------------------
function PlantModel:get_my_friend_info()
	return _my_plant_room_info.plant_friend_info
end
----------------------
function PlantModel:get_my_event_info()
	return _my_plant_room_info.plant_event_info
end
----------------------
function PlantModel:check_is_plant_friend(id)
	for i = 1, #_my_plant_room_info.plant_friend_info do
		if _my_plant_room_info.plant_friend_info[i].id == id then
			return _my_plant_room_info.plant_friend_info
		end
	end
	return nil
end
----------------------
function PlantModel:check_water_finish_friend_state()
	if PlantModel:get_is_my_room() == false then
		if _cur_plant_room_info.water_cd - os.time() <= 0 then
			PlantModel:set_my_friend_water_time( _cur_plant_room_info.role_id, _cur_plant_room_info.water_cd )
			local plant_win = UIManager:find_visible_window("plant_win")
			if plant_win ~= nil then
				plant_win:update_fun( PlantUpdateType.update_friend )
			else
				table.insert( _update_list, PlantUpdateType.update_friend )
			end
		end
	end
end
----------------------
function PlantModel:set_my_friend_water_time(id, time)
	for i = 1, #_my_plant_room_info.plant_friend_info do
		if _my_plant_room_info.plant_friend_info[i].id == id then
			local water_state = Utils:get_bit_by_position( _my_plant_room_info.plant_friend_info[i].state, 1 )
			local grass_state = Utils:get_bit_by_position( _my_plant_room_info.plant_friend_info[i].state, 2 )
			local worm_state = Utils:get_bit_by_position( _my_plant_room_info.plant_friend_info[i].state, 3 )
			local water_num = 0
			local grass_num = 0
			local worm_num = 0
			----------------------
			if time - os.time() <= 0 then
				water_num = 1
			else
				water_num = 0
			end
			----------------------
			if grass_state > 0 then
				grass_num = 2
			end
			----------------------
			if worm_state > 0 then
				worm_num = 4
			end
			----------------------
			_my_plant_room_info.plant_friend_info[i].state = water_num + grass_num + worm_num 
		end
	end
end
----------------------
function PlantModel:check_cur_plant_state()
	local tgrass_state = 0
	local tworm_state = 0
	for i = 1, #_cur_plant_room_info.land_info do
		local temp_grass_state = Utils:get_bit_by_position( _cur_plant_room_info.land_info[i].seed_state, 1 )
		local temp_worm_state = Utils:get_bit_by_position( _cur_plant_room_info.land_info[i].seed_state, 2 )
		if temp_grass_state >= 1 then
			tgrass_state = tgrass_state + 1
		end
		if temp_worm_state >= 1 then
			tworm_state = tworm_state + 1
		end
	end
	return { grass_state = tgrass_state, worm_state = tworm_state }
end
----------------------
function PlantModel:set_my_friend_worm_and_grass_state(id)
	for i = 1, #_my_plant_room_info.plant_friend_info do
		if _my_plant_room_info.plant_friend_info[i].id == id and _cur_plant_room_info.role_id == id then
			local water_state = Utils:get_bit_by_position( _my_plant_room_info.plant_friend_info[i].state, 1 )
			local water_num = water_state
			local grass_num = 0
			local worm_num = 0
			local temp_info = PlantModel:check_cur_plant_state()
			if temp_info.grass_state >= 1 then
				grass_num = 2
			end
			if temp_info.worm_state >= 1 then
				worm_num = 4
			end
			_my_plant_room_info.plant_friend_info[i].state = water_num + grass_num + worm_num
		end
	end
end
----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
----------------------
function PlantModel:exit_fun()
	UIManager:hide_window("plant_win")
end
----------------------
function PlantModel:xian_panel_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:set_xian_panel_visible()
	end
end
----------------------
function PlantModel:qiuck_panel_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:set_qiuck_panel_visible()
	end
end
----------------------
function PlantModel:build_all_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:set_build_all_visible()
	end
end
----------------------
function PlantModel:build_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:set_build_visible()
	end
end
----------------------
function PlantModel:event_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:set_event_panel_visible()
	end
end	
----------------------
function PlantModel:help_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:set_help_panel_visible()
	end
end
----------------------
function PlantModel:level_up_btn_fun()
	local player = EntityManager:get_player_avatar()
	local cur_yb = player.yuanbao
	local need_money = PlantConfig:get_level_up_money( _my_plant_room_info.level )
	local temp_level_info = { LangModelString[394], LangModelString[395] } -- [394]="中" -- [395]="高"
	local temp_info = string.format( Lang.plant.plant_level_up, temp_level_info[ _my_plant_room_info.level ], need_money )
	local function temp_fun()
		if cur_yb < PlantConfig:get_level_up_money( _my_plant_room_info.level ) then
			GlobalFunc:create_screen_notic(LangModelString[396]) -- [396]="元宝不足"
		else
			PlantCC:client_level_up()
		end 
	end
	NormalDialog:show( temp_info, temp_fun )
end
----------------------
function PlantModel:exit_plant_room()
	PlantCC:client_exit()
	PlantModel:send_enter_my_plant()
end
----------------------
function PlantModel:send_enter_my_plant()
	local cur_play = EntityManager:get_player_avatar()
	if cur_play.id ~= nil then
		PlantCC:client_etner_room( cur_play.id )
	end
end
----------------------
function PlantModel:enter_plant_room(info)
	PlantModel:set_cur_plant_room_info(info)
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:hide_other_panel()
		plant_win:update_fun( PlantUpdateType.update_all )
		PlantModel:check_water_finish_friend_state()
	end
end
----------------------
function PlantModel:update_my_plant_room_level(level)
	if PlantModel:get_is_my_room() == true then
		_my_plant_room_info.level = level
	else
		_cur_plant_room_info.level = level
	end
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_level )
	end
end
----------------------
function PlantModel:send_water_power()
	if PlantModel:get_is_my_room() == true then
		if _my_plant_room_info.cur_water_power < _my_plant_room_info.max_water_power then
			if _my_plant_room_info.my_water_num >= PlantConfig:get_self_water_max_num() then
				GlobalFunc:create_screen_notic(LangModelString[397]) -- [397]="今天的灌溉次数已经用完"
			else
				PlantCC:client_water_power()
				PlantModel:get_event_info()
			end
		elseif _my_plant_room_info.is_get_price <= 0 then
			PlantModel:get_price()
		end	
	else
		if _cur_plant_room_info.cur_water_power >= _cur_plant_room_info.max_water_power then
			GlobalFunc:create_screen_notic(LangModelString[397]) -- [397]="今天的灌溉次数已经用完"
		else
			PlantCC:client_water_power()
		end
	end
end
----------------------
function PlantModel:update_water_power(id, num, time)
	--------set_data
	--------update_water_power_num
	time = time + Utils:get_mini_bate_time_base()
	if id == _cur_plant_room_info.role_id then
		_cur_plant_room_info.cur_water_power = num
		_cur_plant_room_info.water_cd = time
		if id == _my_plant_room_info.role_id then
			_my_plant_room_info.cur_water_power = num
			_my_plant_room_info.water_cd = time
		end
		local plant_win = UIManager:find_visible_window("plant_win")
		if plant_win ~= nil then
			plant_win:update_fun( PlantUpdateType.update_water_num )
			plant_win:update_fun( PlantUpdateType.update_water_cd )
			local friend_info = PlantModel:check_is_plant_friend( id ) 
			if friend_info ~= nil then
				PlantModel:set_my_friend_water_time( id, time )
				plant_win:update_fun( PlantUpdateType.update_friend )
			end
		end

	end
end
----------------------
function PlantModel:select_seed_type()
	PlantCC:client_seed_select_type( _my_plant_room_info.cur_plant_seed_type )
end
----------------------
function PlantModel:update_cur_seed_select(seed_type, seed_quality)
	_my_plant_room_info.cur_plant_seed_type = seed_type
	_my_plant_room_info.cur_plant_seed_quality = seed_quality
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_plant_build_win()
	end
end
----------------------
function PlantModel:refresh_seed_quality()
	PlantCC:client_refresh_seed_quality(_my_plant_room_info.cur_plant_seed_type)
end
----------------------
function PlantModel:one_key_refresh_seed_quality()
	PlantCC:client_seed_full_level(_my_plant_room_info.cur_plant_seed_type)
end
----------------------
function PlantModel:build_seed()
	if _my_plant_room_info.cur_build_num > 0 then
		PlantModel:build_btn_fun()
		PlantCC:client_plant(_my_plant_room_info.cur_plant_seed_type, _my_plant_room_info.cur_land_select)
	else
		GlobalFunc:create_screen_notic(LangModelString[398]) -- [398]="仙露不足"
	end
end
----------------------
function PlantModel:update_build_seed(id, build_num, land_id, seed_type, seed_quality, time)
	if id == _cur_plant_room_info.role_id then
		_cur_plant_room_info.cur_build_num = build_num
		_cur_plant_room_info.land_info[land_id].seed_type = seed_type
		_cur_plant_room_info.land_info[land_id].seed_quality = seed_quality
		_cur_plant_room_info.land_info[land_id].seed_time = time + Utils:get_mini_bate_time_base()
	end
	if id == _my_plant_room_info.role_id then
		_my_plant_room_info.cur_build_num = build_num
		_my_plant_room_info.land_info[land_id].seed_type = seed_type
		_my_plant_room_info.land_info[land_id].seed_quality = seed_quality
		_my_plant_room_info.land_info[land_id].seed_time = time + Utils:get_mini_bate_time_base()
	end
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_land )
		plant_win:update_fun( PlantUpdateType.update_xianlu )
	end
end
----------------------
function PlantModel:build_all_seed_type_select(index)
	_my_plant_room_info.cur_build_all_select = index
end
----------------------
function PlantModel:send_buill_all()	
	if PlantModel:get_my_empty_land() > 0 then
		if  _my_plant_room_info.cur_build_num > 0 then
			PlantModel:build_all_btn_fun()
			PlantCC:client_plant_all( 1, _my_plant_room_info.cur_build_all_select )
		else
			GlobalFunc:create_screen_notic(LangModelString[398]) -- [398]="仙露不足"
		end
	end
end
----------------------
function PlantModel:send_get_all()
	if _my_plant_room_info.level >= PlantConfig:get_dong_fu_max_level() then
		PlantCC:client_get_all()
	end
end
----------------------
function PlantModel:update_plant_sick_state(plant_type)
	--_cur_plant_room_info.
end
----------------------
function PlantModel:update_plant_state(id, land_id, plant_state)
	if id == _my_plant_room_info.role_id then
		_my_plant_room_info.land_info[land_id].seed_state = plant_state
	elseif id == _cur_plant_room_info.role_id then
		_cur_plant_room_info.land_info[land_id].seed_state = plant_state 
	end
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_land )
		local friend_info = PlantModel:check_is_plant_friend(id)
		if friend_info ~= nil then
			PlantModel:set_my_friend_worm_and_grass_state( id )
			plant_win:update_fun(PlantUpdateType.update_friend)
		end
	end
end
----------------------
function PlantModel:send_kill_worm(index)
	--if _my_plant_room_info.cur_land_select ~= nil then
		PlantCC:client_kill_worm( index )
		if PlantModel:get_is_my_room() == true then
			PlantModel:get_event_info()
		end
	--end
end
----------------------
function PlantModel:qiuck_plant()
	PlantModel:qiuck_panel_btn_fun()
	print("_my_plant_room_info.cur_plant_select",_my_plant_room_info.cur_plant_select)
	if _my_plant_room_info.cur_plant_select ~= nil then
		PlantCC:client_quick( _my_plant_room_info.cur_plant_select )
		_my_plant_room_info.cur_plant_select = nil
	end
end
----------------------
function PlantModel:update_plant_quick_info( id, land_id, ttime )
	if id == _my_plant_room_info.role_id then
		_my_plant_room_info.land_info[land_id].seed_time = ttime
	elseif _cur_plant_room_info.role_id == id then
		_cur_plant_room_info.land_info[land_id].seed_time = ttime
	end
	if ttime <= 0 then
		local plant_win = UIManager:find_visible_window("plant_win")
		if plant_win ~= nil then
			plant_win:update_fun( PlantUpdateType.update_land )
		end
	end
end
----------------------
function PlantModel:clear_plant(index)
	--if _my_plant_room_info.cur_land_select ~= nil then
		PlantCC:client_clear( index )
	--end
end
----------------------
function PlantModel:update_clear_info(id, land_id)
	if _cur_plant_room_info.role_id == id then
		_cur_plant_room_info.land_info[land_id].seed_type = 0
		_cur_plant_room_info.land_info[land_id].seed_quality = 0
		_cur_plant_room_info.land_info[land_id].seed_state = 0
		_cur_plant_room_info.land_info[land_id].seed_time = 0
		local plant_win = UIManager:find_visible_window("plant_win")
		if plant_win ~= nil then
			plant_win:update_fun( PlantUpdateType.update_land )
		end
	end
end
----------------------
function PlantModel:get_plant()
	if _my_plant_room_info.level >= PlantConfig:get_dong_fu_max_level() then
		PlantModel:send_get_all()
	else
		if _my_plant_room_info.cur_land_select ~= nil then
			PlantCC:client_get( _my_plant_room_info.cur_land_select )
		end
	end
end
----------------------
function PlantModel:update_get( role_id, land_id )
	if _cur_plant_room_info.role_id == role_id then
		_cur_plant_room_info.land_info[ land_id ].seed_type = 0
		_cur_plant_room_info.land_info[ land_id ].seed_quality = 0
		_cur_plant_room_info.land_info[ land_id ].seed_state = 0
		_cur_plant_room_info.land_info[ land_id ].seed_time = 0
		local plant_win = UIManager:find_visible_window( "plant_win" )
		if plant_win ~= nil then
			plant_win:update_fun( PlantUpdateType.update_land )
		end
	end
end
----------------------
function PlantModel:get_price()
	if _my_plant_room_info.is_get_price <= 0 then
		PlantCC:client_water_get_price()
	end
end
----------------------
function PlantModel:get_luck()
	PlantModel:xian_panel_btn_fun()
	--if _my_plant_room_info.luck_time <= 0 then
	PlantCC:client_luck( _my_plant_room_info.luck_type_select )
	--end
end
----------------------
function PlantModel:update_luck( index, ttime )
	_my_plant_room_info.luck_type = index
	_my_plant_room_info.luck_time = ttime + Utils:get_mini_bate_time_base()
	local plant_win = UIManager:find_visible_window( "plant_win" )
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_luck )
	end
end
----------------------
function PlantModel:housekeeper_save()

end
----------------------
function PlantModel:get_event_info()
	PlantCC:client_event()
end
----------------------
function PlantModel:update_event_info(info)
	_my_plant_room_info.plant_event_info = nil
	_my_plant_room_info.plant_event_info = info
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_event )
	end
end
----------------------
function PlantModel:cancel_auto_plant()
	PlantCC:client_cancel_auto_plant()
end
----------------------
function PlantModel:get_auto_plant()
	PlantCC:client_get_auto_plant_info()
end
----------------------
function PlantModel:update_auto_plant(is_save, auto_get, auto_plant)

end
----------------------
function PlantModel:update_return_plant_room_friend_info(info) 
	PlantModel:data_add_my_friend_info(info)
	-- _my_plant_room_info.plant_friend_info = nil
	-- _my_plant_room_info.plant_friend_info = info
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_friend )
	else
		table.insert( _update_list, PlantUpdateType.update_friend )
	end
end
----------------------
function PlantModel:update_cur_plant_room(id, water_num)
	if _my_plant_room_info.role_id == id then
		_my_plant_room_info.cur_water_power = water_num
	end
	_cur_plant_room_info.cur_water_power = water_num
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun( PlantUpdateType.update_water_num )
	end
end
----------------------
function PlantModel:sum_plant_all_time()
	local temp_time = 0
	local cur_time = os.time()
	for i = 1, #_my_plant_room_info.land_info do
		if _my_plant_room_info.land_info[i].seed_time - cur_time > 0 then
			temp_time = temp_time + _my_plant_room_info.land_info[i].seed_time - cur_time
		end
	end
	return temp_time / 60
end
----------------------
function PlantModel:one_key_quick()
	if _my_plant_room_info.level >= PlantConfig:get_dong_fu_max_level() and PlantModel:get_quick_plant_num() > 0 then
		local sum_time = PlantModel:sum_plant_all_time()
		if sum_time > 0 then
			local temp_info = string.format( Lang.plant.plant_qiuck_all_info, sum_time * PlantConfig:get_quick_per_yb() )
			NormalDialog:show(temp_info,PlantCC.client_one_key_quick)
		end
	else
		GlobalFunc:create_screen_notic(LangModelString[399]) -- [399]="当前没有植物可摧熟"
	end
end
----------------------
function PlantModel:update_my_plant_room(build_num, power_num, get_price)
	_my_plant_room_info.cur_build_num = build_num
	_my_plant_room_info.my_water_num = power_num
	_my_plant_room_info.is_get_price = get_price
	if _cur_plant_room_info.role_id == _my_plant_room_info.role_id then
		local plant_win = UIManager:find_visible_window("plant_win")
		if plant_win ~= nil then
			plant_win:update_fun( PlantUpdateType.update_water_num )
			plant_win:update_fun( PlantUpdateType.update_xianlu )
		end
	end
end
----------------------
function PlantModel:plant_click_fun(index)
	local cur_time = os.time()
	if PlantModel:get_is_my_room () == true and cur_time - _my_plant_room_info.land_info[index].seed_time < 0 then
		print("PlantModel:plant_click_fun index", index)
		_my_plant_room_info.cur_plant_select = index
		PlantModel:qiuck_panel_btn_fun()
	end
end
----------------------
function PlantModel:plant_state_fun(index)
	if PlantModel:get_is_my_room() == true then
		_my_plant_room_info.cur_land_select = index
		print("_my_plant_room_info.land_info[index].seed_state",_my_plant_room_info.land_info[index].seed_state)
		if _my_plant_room_info.land_info[index].seed_state == 2 then
			PlantModel:send_kill_worm(index)
			return
		elseif _my_plant_room_info.land_info[index].seed_state == 1 then
			PlantModel:send_kill_worm(index)
			return
		end
		if os.time() - _my_plant_room_info.land_info[index].seed_time >= 0 then
			PlantModel:get_plant()
			return
		end
	else
		if _cur_plant_room_info.land_info[index].seed_state == 2 then
			PlantModel:send_kill_worm(index)
			return
		elseif _cur_plant_room_info.land_info[index].seed_state == 1 then
			PlantModel:send_kill_worm(index)
			return
		end
	end
end
----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
----------------------
function PlantModel:init_build_info(index)
	_my_plant_room_info.cur_land_select = index
	--_my_plant_room_info.cur_plant_seed_type = 1
	PlantModel:select_seed_type()
end
----------------------
function PlantModel:update_plant_build_select_info()
	if PlantModel:get_is_my_room() == true then
		local plant_win = UIManager:find_visible_window("plant_win")
		if plant_win ~= nil then
			plant_win:update_plant_build_win()
		end
	end
end
----------------------
function PlantModel:update_plant_build_yb()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win ~= nil then
		plant_win:update_fun(PlantUpdateType.update_build_yb)
	end
end