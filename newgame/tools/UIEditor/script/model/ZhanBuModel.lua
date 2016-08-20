----ZhanBuModel.lua
----HJH
----2013-9-6
----
ZhanBuModel = {}
ZhanBuModel.buff_type_index =
{
	item_add = 1,
	wing_add = 2,
	pet_grow_add = 3,
	pet_wuxin_add = 4,
}
----------------------
local _reinit_win_info = true
local _panel_info = ZhanBuStruct()
local _limit_event_size = 20
local _panel_update_list = {}
local _buff_info = ZhanBuBuffStruct()
----------------------
function ZhanBuModel:fini( ... )
	print("run ZhanBuModel:fini")
	_reinit_win_info = true
end
----------------------取得占卜BUFF信息
function ZhanBuModel:get_buff_info()
	return _buff_info
end
----------------------重设BUFF信息
function ZhanBuModel:reset_buff_info()
	_buff_info = nil 
	_buff_info = ZhanBuBuffStruct()
end
----------------------取得占卜面板更新列表
function ZhanBuModel:get_update_list()
	return _panel_update_list
end
----------------------清除占卜面板更新列表
function ZhanBuModel:clear_update_list()
	_panel_update_list = nil
	_panel_update_list = {}
end
----------------------重设窗口信息
function ZhanBuModel:reinit_win_info()
	print("ZhanBuModel:reinit_win_info")
	_reinit_win_info = false
	_panel_info = nil
	_panel_info = ZhanBuStruct()
	_buff_info = nil
	_buff_info = ZhanBuBuffStruct()
	ZhanBuModel:get_zhanbu_info()
	ZhanBuModel:get_zhanbu_event_info()
	ZhanBuModel:clear_update_list()
end
----------------------打开占卜窗口
function ZhanBuModel:open_zhan_bu_win()
	if GameSysModel:isSysEnabled( GameSysModel.ZhanBu, true ) then
		UIManager:show_window("zhanbu_win")
	end
end
----------------------
-- function ZhanBuModel:sort_info()
-- 	local function sort_fun(a,b)
-- 		if a
-- 	end
-- end
----------------------数据操作：添加占卜事件信息
function ZhanBuModel:date_add_event_info(info)
	--------------------------------
	-- for i = 1, #_panel_info.event_info do
	-- 	print("before info name,event_id", _panel_info.event_info[i].name, _panel_info.event_info[i].event_id)
	-- end
	--------------------------------
	for i = 1, #info do
		table.insert( _panel_info.event_info, 1, info[i] )
		if #_panel_info.event_info > _limit_event_size then
			table.remove( _panel_info.event_info )
		end
	end
	--------------------------------
	-- for i = 1, #_panel_info.event_info do
	-- 	print("after info name,event_id", _panel_info.event_info[i].name, _panel_info.event_info[i].event_id)
	-- end

	--------------------------------
end
----------------------取得占卜事件信息
function ZhanBuModel:get_panel_info()
	return _panel_info
end
----------------------
function ZhanBuModel:set_reinit_info(result)
	_reinit_win_info = result
end
----------------------
function ZhanBuModel:get_reinit_info()
	return _reinit_win_info
end
----------------------请求占卜CD信息
function ZhanBuModel:get_zhanbu_info()
	OnlineAwardCC:client_get_zhanbu_info()
end	
----------------------更新占卜CD信息
function ZhanBuModel:update_zhanbu_info(info)
	local cur_time = os.time()
	_panel_info.cur_time = info + cur_time-- + Utils:get_mini_bate_time_base()
	local zhanbu_win = UIManager:find_visible_window("zhanbu_win")
	if zhanbu_win ~= nil then
		zhanbu_win:update_fun( ZhanBuUpdateType.update_time )
	elseif _panel_info.cur_time - cur_time <= 0 then
		-- MiniBtnWin:show( 20, ZhanBuModel.open_zhan_bu_win )
	end
end
----------------------请求占卜事件信息
function ZhanBuModel:get_zhanbu_event_info()
	OnlineAwardCC:client_get_zhanbu_event_info()
end	
----------------------更新占卜事件信息
function ZhanBuModel:update_zhanbu_event_info(info)
	_panel_info.event_info = nil
	_panel_info.event_info = {}
	ZhanBuModel:date_add_event_info( info )
	local zhanbu_win = UIManager:find_visible_window( "zhanbu_win" )
	if zhanbu_win ~= nil then
		zhanbu_win:update_fun( ZhanBuUpdateType.update_scroll )
	end
end
----------------------占卜
function ZhanBuModel:zhanbu_button_fun()
	if _panel_info.cur_time - os.time() <= 0 then
		OnlineAwardCC:client_zhanbu()
		local zhanbu_win = UIManager:find_visible_window("zhanbu_win")
		if zhanbu_win ~= nil then
			LuaEffectManager:play_view_effect( 11024,360,200,zhanbu_win.view,false,999 )
		end
	else
		GlobalFunc:create_screen_notic( Lang.zhan_bu.zhanbu_notic )
	end
end
----------------------更新占卜结果
function ZhanBuModel:update_zhanbu_result(event_id)
	for i = 1, #_panel_info.event_info do
		print("update_zhanbu_result info name,event_id", _panel_info.event_info[i].name, _panel_info.event_info[i].event_id)
	end
	--local temp_info = ZhanBuConfig:get_index_event_info( event_id )
	local cur_player_name = EntityManager:get_player_avatar().name
	local temp_info = ZhanBuEventStruct:create( cur_player_name, event_id )
	local temp_lnfo_list = {}
	table.insert( temp_lnfo_list, temp_info )
	ZhanBuModel:date_add_event_info( temp_lnfo_list )
	local zhanbu_win = UIManager:find_visible_window( "zhanbu_win" )
	if zhanbu_win ~= nil then
		zhanbu_win:update_fun( ZhanBuUpdateType.update_scroll )
	else
		table.insert( _panel_update_list, ZhanBuUpdateType.update_scroll )
	end
	local temp_event_info = ZhanBuConfig:get_index_event_info( event_id )
	if temp_event_info.ttype == 3 then
		ZhanBuModel:get_zhanbu_buff_info()
	end
end
----------------------请求占卜BUFF信息
function ZhanBuModel:get_zhanbu_buff_info()
	OnlineAwardCC:client_zhanbu_add_rate()
end
----------------------更新占卜BUFF信息
function ZhanBuModel:update_zhanbu_buff_info( index, add_rate, limit_time )
	_buff_info.buff_type = index
	_buff_info.add_rate = add_rate
	_buff_info.time = limit_time + os.time()
	local zhanbu_win = UIManager:find_window("zhanbu_win")
	if index ~= 0 and limit_time > 0 then		
		if zhanbu_win ~= nil then
			zhanbu_win:active_time(true)
		end
		if index == ZhanBuModel.buff_type_index.item_add then 				--装备强化
			local forge_win = UIManager:find_window("forge_win")
			if forge_win ~= nil then
				forge_win:update_zhan_bu_buff_info(1)
			end
		elseif index == ZhanBuModel.buff_type_index.wing_add then 			--翅膀升级
			local wing_uplevel_win = UIManager:find_window("wing_uplevel_win")
			if wing_uplevel_win ~= nil then
				wing_uplevel_win:update(  )
			end
		elseif index == ZhanBuModel.buff_type_index.pet_grow_add then 		--宠物成长
			local pet_win = UIManager:find_window("pet_win")
			if pet_win ~= nil then
				pet_win:update_zhan_bu_buff_info(3)
			end
		elseif index == ZhanBuModel.buff_type_index.pet_wuxin_add then 		--宠物悟性
			local pet_win = UIManager:find_window("pet_win")
			if pet_win ~= nil then
				pet_win:update_zhan_bu_buff_info(2)
			end
		end
	else
		if zhanbu_win ~= nil then
			zhanbu_win:active_time(false)
		end
	end
end
----------------------
function ZhanBuModel:check_buff_out_of_time()
	local temp_time = os.time()
	if temp_time - _buff_info.time > 0 then
		return true
	else
		return false
	end
end
----------------------检查指定BUFF
function ZhanBuModel:check_index_item_add_buff(index)
	print("ZhanBuModel:check_index_item_add_buff index", index, _buff_info.buff_type, os.time(),  _buff_info.time)
	if _buff_info.buff_type == index and os.time() - _buff_info.time < 0 then
		return _buff_info
	else
		return nil
	end
end
----------------------
function ZhanBuModel:reset_buff_panel()
	ZhanBuModel:update_zhanbu_buff_info( _buff_info.buff_type, 0, 0 )
end