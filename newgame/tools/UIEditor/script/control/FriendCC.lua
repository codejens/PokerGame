-------------------------------
------------HJH
------------2013-1-16
------------
-- super_class.FriendCC()

FriendCC = {}

------------服务器获取好友、仇人、隔离列表
function FriendCC:receive_friend_enemy_black_info(pack)
	local num = pack:readInt()
	local info = {}
	-- print("receive friend and enemy and black info")
	--print("num",num)
	require "struct/FriendStruct"
	require "model/FriendModel/FriendModel"
	for i = 1 , num do
		info[i] = FriendStruct(pack)
	end
	--print("run refresh friend info")
	FriendModel:refresh_friend_info(info)
end
------------客户端获取好友、仇人、隔离列表
function FriendCC:request_friend_enemy_black_info()
	local pack = NetManager:get_socket():alloc(25, 1)
	NetManager:get_socket():SendToSrv(pack)
	print("request_friend_enemy_black_info-------")
end
------------客户端发送聊天信息
function FriendCC:send_chat_info(id, type, info)
	local pack = NetManager:get_socket():alloc(25, 2)
	pack:writeInt(id)
	pack:writeInt(type)
	pack:writeString(info)
	NetManager:get_socket():SendToSrv(pack)
end
------------server send chat info
function FriendCC:receive_chat_info(pack)
	local id = pack:readInt()
	local info = pack:readString()
	print("receive chat info")
end
------------client add enemy
function FriendCC:send_add_enemy(id, name)
	local pack = NetManager:get_socket():alloc(25, 3)
	pack:writeInt(id)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack)
end
------------client add friend
function FriendCC:request_add_friend(targetId, targetName)
	local pack = NetManager:get_socket():alloc(25, 4)
	pack:writeInt(targetId)
	pack:writeString(targetName)
	NetManager:get_socket():SendToSrv(pack)
end
------------服务器某人关注（加好友）了你
function FriendCC:receive_add_friend(pack)
	local request_id = pack:readInt()													----邀请人ID
	local request_type = pack:readInt()													----邀请类型
	local request_camp = pack:readInt()													----阵营ID
	local request_level = pack:readInt()												----等级
	local request_name = pack:readString()												----邀请人角色名	
	require "model/FriendModel/FriendAddModel"
	print("receive add friend")
	print("request_id",request_id)
	print("request_name",request_name)
	FriendAddModel:add_friend(request_id, request_type, request_camp, request_level, request_name)

end
-------------回应加好友
function FriendCC:send_add_friend(id, result, resultType)
	local pack = NetManager:get_socket():alloc(25, 5)
	pack:writeInt(id)
	pack:writeShort(result)
	pack:writeShort(resultType)
	NetManager:get_socket():SendToSrv(pack)
	-- local request_id = pack:readInt()													----请求人ID
	-- local result = pack:readWord()														----请求类结果1：接受，0：拒绝
	-- local request_type = pack:readWord()												----请求类型 1：加好友，2：加群
end
-------------server ????
function FriendCC:receive_friend_enemy_black_info_sevent(pack)
	print("receive_friend_enemy_black_info_sevent")
	local info = FriendStruct(pack)
	require "struct/FriendStruct"
	require "model/FriendModel/FriendModel"
	FriendModel:refresh_index_info(info.ttype, info)
	--FriendCC:receive_friend_enemy_black_info(pack)
end
-------------client add black list if succeed return receive_friend_enemy_black_info
function FriendCC:send_add_black_list(id, name)
	local pack = NetManager:get_socket():alloc(25, 6)
	pack:writeInt(id)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack)
end
--------------client delete friend or black list or enemy
function FriendCC:send_delete_friend_black_enemy(id, ttype)
	local pack = NetManager:get_socket():alloc(25, 8)
	pack:writeInt(id)
	pack:writeInt(ttype)
	NetManager:get_socket():SendToSrv(pack)
end
--------------server delete friend or black list or enemy
function FriendCC:receive_delete_friend_black_enemy(pack)
	print("receive_delete_friend_black_enemy")
	local id = pack:readInt()
	local temptype = pack:readInt()
	require "model/FriendModel/FriendModel"
	FriendModel:delete_friend_info({roleId = id,ttype = temptype})
end
--------------server friend online
function FriendCC:receive_friend_online(pack)
	local id = pack:readInt()
	local ttype = pack:readInt()
	print("receive_friend_online, id, ttype", id, ttype)
	require "model/FriendModel/FriendModel"
	FriendModel:data_update_my_friend_online_info(id, ttype)
end
--------------server friend online change
function FriendCC:receive_friend_online_change(pack)
	local id = pack:readInt()
	local level = pack:readByte()
	local icon = pack:readByte()
	local new_name = pack:readString()
	print("receive_friend_online_change")
	require "model/FriendModel/FriendModel"
	FriendModel:date_update_my_friend_info_info(id, level, icon, new_name)
end
--------------server update friend num
function FriendCC:receive_friend_number(pack)
	local id = pack:readInt()
	local ttype = pack:readInt()
	local value = pack:readUint()
	print("receive_friend_number")

end
--------------client friend update celebrating
function FriendCC:send_friend_update_celebrate(id, level)
 	local pack = NetManager:get_socket():alloc(25, 11)
 	pack:writeInt(id)
 	pack:writeInt(level)
 	NetManager:get_socket():SendToSrv(pack)
 end
 -------------server friend update notic
 function FriendCC:receive_friend_update_notic(pack)
 	local temp_info = FriendCelerbrateInfo(pack)
 	-- local id = pack:readInt()
 	-- local level = pack:readInt()
 	-- local num = pack:readInt()
 	-- local exp = pack:readInt()
 	-- local name = pack:readString()
 	print("receive_friend_update_notic")
 	--require "model/FriendModel/FriendCelerbrateModel"
 	FriendCelerbrateModel:add_friend_celerbrate( temp_info )--id, level, num, exp, name )
 end
 -------------client check friend
 function FriendCC:send_check_friend(name)
 	local pack = NetManager:get_socket():alloc(25, 12)
 	pack:writeString(name)
 	NetManager:get_socket():SendToSrv(pack)
 end
 -------------server friend info
 function FriendCC:receive_friend_info(pack)
 	local id = pack:readInt()
 	local level = pack:readInt()
 	local camp = pack:readInt()
 	local job = pack:readInt()
 	local sex = pack:readInt()
 	local name = pack:readString()
 	local xzname = pack:readString()
 	-- print("receive_friend_info")
 	require "model/FriendModel/FriendModel"
 	FriendModel:show_friend_info(id, level, camp, job, sex, name, xzname)
 end
 -------------server today get friend num
 function FriendCC:receive_today_get_friend_num(pack)
 	local num = pack:readInt()
 	-- print("receive_today_get_friend_num:",num)
 	require "model/FriendModel/FriendModel"
 	FriendModel:update_get_times_num(num)
 end
--------------client get friend
function FriendCC:send_get_friend()
	local pack = NetManager:get_socket():alloc(25, 13)
 	NetManager:get_socket():SendToSrv(pack)
end

--------------雷达征友 client
function FriendCC:radar_get_friend()
	local pack = NetManager:get_socket():alloc(25, 14)
 	NetManager:get_socket():SendToSrv(pack)
end

--------------雷达征友 server
function FriendCC:receive_radar_get(pack)
	local num = pack:readInt()
	local search_info = {}
	if num > 0 then
		for i = 1, num do
			local avatar = {}
			avatar.id = pack:readInt()
		 	avatar.camp = pack:readInt()
		 	avatar.level = pack:readInt()
		 	avatar.sex = pack:readInt()
		 	avatar.job = pack:readInt()
		 	avatar.vip = pack:readInt()
		 	avatar.name = pack:readString()
		 	table.insert(search_info, avatar)
		end
	end
	FriendModel:set_radar_info(search_info)
end