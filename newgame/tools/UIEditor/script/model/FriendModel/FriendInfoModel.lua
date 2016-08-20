---------------HJH
---------------2013-1-16
---------------
---------------
-- super_class.FriendInfoModel()
FriendInfoModel = {}

local _cur_friend_info = {}
---------------
--_cur_friend_info : role_id, level, camp, job, sex, player name , xz name
---------------
-- added by aXing on 2013-5-25
function FriendInfoModel:fini( ... )
	_cur_friend_info = {}
end
---------------
function FriendInfoModel:data_set_friend_info(tid, tlevel, tcamp, tjob, tsex, tname, txz)
	_cur_friend_info = {id = tid, level = tlevel, camp = tcamp, job = tjob, sex = tsex, name = tname, xz = txz}
end
---------------
function FriendInfoModel:get_set_friend_info()
	return _cur_friend_info
end
---------------
function FriendInfoModel:exit_fun()
	UIManager:hide_window("friend_info_win")
end
---------------
function FriendInfoModel:check_data_fun()
	require "control/OthersCC"
	print("params.roleId, params.roleName",_cur_friend_info.id, _cur_friend_info.name)
	OthersCC:check_player_info(_cur_friend_info.id, _cur_friend_info.name)
	UIManager:hide_window("friend_info_win")
end
---------------
function FriendInfoModel:add_friend_fun()
	require "control/FriendCC"
	FriendCC:request_add_friend(_cur_friend_info.id, _cur_friend_info.name)
	UIManager:hide_window("friend_info_win")
end
---------------
function FriendInfoModel:black_list_fun()
	--params[1] = id,params[2] = name
	require "control/FriendCC"
	FriendCC:send_add_black_list(_cur_friend_info.id, _cur_friend_info.name)
	UIManager:hide_window("friend_info_win")
end
---------------
function FriendInfoModel:init_friend_info(id, level, camp, job, sex, name, xz)
	local friend_info_win = UIManager:show_window("friend_info_win")
	friend_info_win:init_info(name, level, camp, job, sex, xz)
	FriendInfoModel:data_set_friend_info(id, level, camp, job, sex, name, xz)
	--tid, tlevel, tcamp, tjob, tsex, tname, txz
end