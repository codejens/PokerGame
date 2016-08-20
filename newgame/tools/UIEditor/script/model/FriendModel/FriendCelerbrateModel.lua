-----friendcelerbreatemode.lua
-----HJH
-----2013-2-17
-----------
-- super_class.FriendCelerbrateModel()
FriendCelerbrateModel = {}
-----------
-----------
-----------friend celerbrate info : id, name, level, exp, num
local _friend_celerbrate_info = {}
local _friend_celerbrate_max_num = 20
local _cur_celerbrate_role_id = nil
-----------
function FriendCelerbrateModel:fini( ... )
	_friend_celerbrate_info = {}
	_cur_celerbrate_role_id = nil
end
-----------
function FriendCelerbrateModel:get_friend_celerbrate_info_num()
	return #_friend_celerbrate_info
end
-----------
function FriendCelerbrateModel:get_index_celerbrate_info(index)
	return _friend_celerbrate_info[index]
end
-----------数据区操作
function FriendCelerbrateModel:data_add_celerbrate_info(info)
	if _friend_celerbrate_info == nil then
		_friend_celerbrate_info = {}
	end
	table.insert(_friend_celerbrate_info, info)
	if #_friend_celerbrate_info > _friend_celerbrate_max_num then
		table.remove(_friend_celerbrate_info, 1)
	end
end
-----------
function FriendCelerbrateModel:data_delete_celerbrate_info()
	--table.remove(_friend_celerbrate_info)
end
-----------
function FriendCelerbrateModel:data_delete_celerbrate_info_by_id(id)
	for i = 1, #_friend_celerbrate_info do
		if _friend_celerbrate_info[i].role_id == id then
			table.remove( _friend_celerbrate_info, i )
			return
		end
	end	
end
-----------
function FriendCelerbrateModel:data_get_celerbrate_num()
	return #_friend_celerbrate_info
end
-----------
function FriendCelerbrateModel:data_get_celerbrate_info_by_id(id)
	for i = 1, #_friend_celerbrate_info do
		print("_friend_celerbrate_info[i].role_id ",_friend_celerbrate_info[i].role_id )
		if _friend_celerbrate_info[i].role_id == id then
			return _friend_celerbrate_info[i]
		end
	end
	return
end
-----------
-----------非数据区操作
-----------
function FriendCelerbrateModel:add_friend_celerbrate(temp_info) --tid, tlevel, tnum, texp, tname)
	--local temp_info = { id = tid, level = tlevel, num = tnum, exp = texp, name = tname }
	FriendCelerbrateModel:data_add_celerbrate_info(temp_info)
	MiniBtnWin:show(2, FriendCelerbrateModel.open_friend_celerbrate_scroll, #_friend_celerbrate_info )
end
-----------
function FriendCelerbrateModel:format_celerbrate_info(id)
	local last_info = FriendCelerbrateModel:data_get_celerbrate_info_by_id(id)
	if last_info == nil then
		return ""
	else
		--return string.format("您的好友%s升到%d级，给他发送祝福,即可获得%d经验奖励（今天成功发送%d个祝福,每天最多发送40个!）", "last_info.name", 123, 111, 11 )
		return string.format(Lang.friend.model[6], last_info.name, last_info.level, last_info.exp, last_info.num ) -- [6]="您的好友%s升到%d级，给他发送祝福,即可获得%d经验奖励（今天成功发送%d个祝福,每天最多发送40个!）"
	end
end
-----------
function FriendCelerbrateModel:open_friend_celerbrate(id)
	UIManager:hide_window("friend_celerbreate_scroll")
	local celerbrate_win = UIManager:show_window("friend_celerbreate_win")
	local temp_info = FriendCelerbrateModel:format_celerbrate_info(id)
	print("temp_info",temp_info)
	if celerbrate_win ~= nil and temp_info ~= "" then
		_cur_celerbrate_role_id = id
		celerbrate_win:init_info(temp_info)
	end
end
-----------
function FriendCelerbrateModel:btn_one_click_function()
	local id = _cur_celerbrate_role_id
	--require "control/FriendCC"
	if _friend_celerbrate_info ~= nil and id ~= nil then
		local last_info = FriendCelerbrateModel:data_get_celerbrate_info_by_id(id)
		FriendCC:send_friend_update_celebrate(last_info.role_id, last_info.level)
		FriendCelerbrateModel:data_delete_celerbrate_info_by_id(id)		
	end
	UIManager:hide_window("friend_celerbreate_win")
	if #_friend_celerbrate_info > 0 then
		MiniBtnWin:show(2, FriendCelerbrateModel.open_friend_celerbrate_scroll, #_friend_celerbrate_info)
	end
end
-----------
-----------
function FriendCelerbrateModel:btn_two_click_function()
	local id = _cur_celerbrate_role_id
	--require "control/FriendCC"
	if _friend_celerbrate_info ~= nil and id ~= nil then
		local last_info = FriendCelerbrateModel:data_get_celerbrate_info_by_id(id)
		FriendCC:send_friend_update_celebrate(last_info.role_id, last_info.level)
		FriendCelerbrateModel:data_delete_celerbrate_info_by_id(id)	
	end
	UIManager:hide_window("friend_celerbreate_win")
	if #_friend_celerbrate_info > 0 then
		MiniBtnWin:show(2, FriendCelerbrateModel.open_friend_celerbrate_scroll, #_friend_celerbrate_info )
	end
end
-----------
-----------
function FriendCelerbrateModel:btn_three_click_function()
	local id = _cur_celerbrate_role_id
	--require "control/FriendCC"
	if _friend_celerbrate_info ~= nil and id ~= nil then
		local last_info = FriendCelerbrateModel:data_get_celerbrate_info_by_id(id)
		FriendCC:send_friend_update_celebrate(last_info.role_id, last_info.level)
		FriendCelerbrateModel:data_delete_celerbrate_info_by_id(id)	
		UIManager:hide_window("friend_celerbreate_win")
	end
	if #_friend_celerbrate_info > 0 then
		MiniBtnWin:show(2, FriendCelerbrateModel.open_friend_celerbrate_scroll, #_friend_celerbrate_info )
	end
end
-----------
-----------
function FriendCelerbrateModel:exit_click_fun()
	UIManager:hide_window("friend_celerbreate_win")
	_cur_celerbrate_role_id = nil
	--FriendCelerbrateModel:data_delete_celerbrate_info()
	if #_friend_celerbrate_info > 0 then
		MiniBtnWin:show(2, FriendCelerbrateModel.open_friend_celerbrate_scroll, #_friend_celerbrate_info )
	end
end
-----------
-----------
function FriendCelerbrateModel:open_friend_celerbrate_scroll()
	UIManager:show_window("friend_celerbreate_scroll")
end
-----------
-----------
function FriendCelerbrateModel:celerbrate_all()
	for i = 1, #_friend_celerbrate_info do
		FriendCC:send_friend_update_celebrate(_friend_celerbrate_info[i].role_id, _friend_celerbrate_info[i].level)
	end	
	_friend_celerbrate_info = nil 
	_friend_celerbrate_info = {}
	UIManager:hide_window("friend_celerbreate_scroll")
end
-----------
-----------
function FriendCelerbrateModel:ignore_all()
	_friend_celerbrate_info = nil 
	_friend_celerbrate_info = {}
	UIManager:hide_window("friend_celerbreate_scroll")
end
