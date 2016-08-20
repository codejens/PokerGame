----ChatCC.lua
----HJH
----2012-12-3
----
-- super_class.ChatCC()

ChatCC = {}
local chat_send_max_num = 255
local function text_out_of_range()
	GlobalFunc:create_screen_notic(LangGameString[430]) -- [430]="输入超出长度"
end

----客户端发送聊天信息
----c->s 9,1
function ChatCC:send_chat(chanel, needmoney, msg)
	--print( string.format("ChatCC:send_chat msg=%s,len=%d",msg, string.len(msg) ) )
	if string.len(msg) > chat_send_max_num then
		text_out_of_range()
		return
	end
	if zxDebugger.acceptCmd(msg) then
		return
	end
	local pack = NetManager:get_socket():alloc(9, 1)
	pack:writeChar(chanel)											----频道ID
	pack:writeChar(needmoney)										----是否扣钱
	pack:writeString(msg)											----聊天内容
	NetManager:get_socket():SendToSrv(pack)
	--print("send_chat:",chanel,needmoney,msg)
end
----客户发送私聊
function ChatCC:send_private_chat(player_id, needmoney, tarname,msg)
	local pack = NetManager:get_socket():alloc(9, 2)
	pack:writeInt(player_id)										----对方ID
	pack:writeInt(needmoney)										----是否扣钱
	pack:writeString(tarname)										----对方玩家名字
	pack:writeString(msg)											----私聊
	NetManager:get_socket():SendToSrv(pack)
	--print("send_private_chat:",msg)
end
----发送GM公告
function ChatCC:send_gm_chat(msg, tip_pos)
	if string.len(msg) > chat_send_max_num then
		text_out_of_range()
		return
	end
	local pack = NetManager:get_socket():alloc(9,3)
	pack:writeString(msg)											----公告内容
	pack:writeInt(tip_pos)											----公告显示位置掩码
	NetManager:get_socket():SendToSrv(pack)
	--print("send_gm_chat:",msg)
end


----上传VIP表情
function ChatCC:sent_vip_icon(icon_id)
	local pack = NetManager:get_socket():alloc(9,4)
	pack:writeChar(icon_id)											----聊天表情ID
	NetManager:get_socket():SendToSrv(pack)
end


---上发灵泉仙浴表情和消息内容
function ChatCC:sent_happy_hour_chat(msg)
	if string.len(msg) > chat_send_max_num then
		text_out_of_range()
		return
	end
	local pack = NetManager:get_socket():alloc(9,5)
	pack:writeString(msg)											----内容
	NetManager:get_socket():SendToSrv(pack)
end

----服务器向客户端发送聊天信息
----s->c 9,1
function ChatCC:receive_message(pack)
	local id = pack:readInt()										----玩家ID
	local chanel_id = pack:readChar()								----频道ID
	local sex = pack:readChar()										----性别
	local flg = pack:readChar()										----标志位
	local camp_id = pack:readChar()									----阵营ID
	local job = pack:readChar()										----职业
	local level = pack:readChar()									----等级
	local icon = pack:readChar()									----头像ID
	local yeallow_dimond = pack:readInt()							----蓝黄钻信息
	local name = pack:readString()									----玩家名字
	local msg = pack:readString()									----聊天内容
	---------safe check
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	-----------------------------
	-- if msg ~= nil then
	-- 	print( string.format("ChatCC:receive_message msg=%s, len=%d",msg,string.len(msg) ) )
	-- end
	-- print("chanel_id",chanel_id)
	require "model/ChatModel/ChatModel"
	local temp_result = ChatModel:receive_normal_chat_info(id, chanel_id, sex, flg, camp_id, job, level, icon, yeallow_dimond, name, msg)
	--ChatMode:set_message(1, {id, chanel_id, sex, flg, camp_id, job, level, icon, yeallow_dimod, name, msg})
	if temp_result == false then
		return
	end
	-- 显示人物头顶的对话框
	local avatar = EntityManager:get_entity_by_id( id );
	if ( avatar ) then
		--print("===================找到实体==================")
		require "UI/common/EntityDialog"
		EntityDialog(avatar.model:getBillboardNode(), msg );
	end
end


---系统提示
function ChatCC:receive_sys_chat(pack)
	local player_level = pack:readChar()							----玩家等级
	local show_pos = pack:readByte()								----显示位置
	local msg = pack:readString()									----系统提示信息
	--------------------------------
	print("receive_sys_chat show_pos:",show_pos)
	print( string.format( "ChatCC : receive_sys_chat player_level =%s, show_pos = %s, msg = %s",player_level, show_pos, msg) )
	require "model/ChatModel/ChatModel"
	--print("ChatCC:receive_sys_chat msg", msg)
	ChatModel:receive_sys_chat_info(player_level, show_pos, msg)
	--ChatMode:set_message(2, {player_level, show_pos, msg})
end


---下发私聊消息
function ChatCC:receive_private_chat(pack)
	local id = pack:readInt()										----发送玩家ID
	local sex = pack:readChar()										----性别
	local job = pack:readChar()										----职业
	local camp_id = pack:readChar()									----阵营ID
	local level = pack:readChar()									----等级
	local icon = pack:readChar()									----头像
	local group_id = pack:readUInt()								----队们ID
	local qqvip = pack:readInt()									----QQVIP
	local name = pack:readString()									----玩家名字
	local msg = pack:readString()									----私聊内容
	---------------------------------
--	print("receive_private_chat",msg)
	--require "model/ChatModel/ChatModel"
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	ChatModel:receive_private_chat_info(id, sex, job, camp_id, level, icon, group_id, qqvip, name, msg)
	
	--ChatMode:set_message(3, {id, sex, job, camp_id, level, icon, group_id, name, msg})
	--local tempMsg = ChatMode:format_private_chat_info(name, msg)
	--print("tempMsg",tempMsg)
	--ChatMode:set_message(3, tempMsg)
	--print("recive_private_chat:",msg)
end


---下发附近非玩家消息
function ChatCC:receive_area_chat(pack)
	local handle = pack:readUint64()								----实体handle
	local msg = pack:readString()									----聊天消息
	-------------------------------
	--print("receive_area_chat:",msg)
	--ChatMode:receive_near_npc_chat_info(handle, msg)
	--ChatMode:set_message(4, {handle, msg})
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	local entity_ = EntityManager:get_entity(handle)
	if ( entity_ ) then 
		EntityDialog(entity_.model:getBillboardNode(), msg );
	end
end


---下发公告
function ChatCC:receive_announcement(pack)
	local msg = pack:readString()									----公告内容 
	local pos = pack:readInt()										----公告显示位置
	-------------------------------
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	--print("receive_announcement:",msg)
	--ChatMode:receive_announcement_chat_info(msg, pos)
	--ChatMode:set_message(5, {msg, pos})
end


---广播VIP表情
function ChatCC:receive_vip_icon(pack)
	local handle = pack:readUint64()								----玩家句柄
	local id = pack:readUint64()									----表情ID
	-------------------------------
	--ChatMode:receive_vip_icon_chat_info(handle, id)
	--ChatMode:set_message(6, {handle, id})
end


---客户端弹出飞出提示框
function ChatCC:receive_tip(pack)
	local msg = pack:readString()									----内容
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	------------------------------
	--print("receive_tip:",msg)
	--ChatMode:receive_fly_chat_info(msg)
	--ChatMode:set_message(7, msg)
end


---广播灵泉表情
function ChatCC:receive_happy_hour_msg(pack)
	
	local handle = pack:readUint64()								----广播者handle
	local msg = pack:readString()									----广播内容

	--  
	local entity_ = EntityManager:get_entity(handle)
	if ( entity_ ) then 
		EntityDialog(entity_.model:getBillboardNode(), msg );
	end
	-----------------------------------
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	--print("receive_happy_hour_msg:",msg)
	--ChatMode:receive_happy_time_chat_info(handle, msg)
	--ChatMode:set_message(8, {handle, msg})
end


---播放最后一条聊天消息
function ChatCC:receive_last_msg(pack)
	local id = pack:readInt()										----玩家ID
	local chanel_id = pack:readChar()								----频道ID
	local sex = pack:readChar()										----性别
	local flg = pack:readChar()										----标志位
	local job = pack:readChar()										----阵营ID
	local level = pack:readInt()									----职业
	local icon = pack:readChar()									----等级
	local yeallow_dimond = pack:readInt()							----头像ID
	local name = pack:readString()									----玩家名字
	local msg = pack:readString()									----聊天内容
	--------------------------------
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	--print("receive_last_msg:",msg)
	--ChatMode:receive_last_chat_info(id, chanel_id, sex, flg, job, level, icon, yeallow_dimond, name, msg)
	--ChatMode:set_message(9, {id, chanel_id, sex, flg, job, level, icon, yeallow_dimond, name, msg})
	---------safe check
	-- if string.len(msg) > chat_send_max_num then
	-- 	return
	-- end
	-----------------------------
	-- if msg ~= nil then
	-- 	print( string.format("ChatCC:receive_message msg=%s, len=%d",msg,string.len(msg) ) )
	-- end
	-- print("chanel_id",chanel_id)
	require "model/ChatModel/ChatModel"
	local temp_result = ChatModel:receive_normal_chat_info(id, chanel_id, sex, flg, camp_id, job, level, icon, yeallow_dimond, name, msg)
	--ChatMode:set_message(1, {id, chanel_id, sex, flg, camp_id, job, level, icon, yeallow_dimod, name, msg})
	if temp_result == false then
		return
	end
	-- 显示人物头顶的对话框
	local avatar = EntityManager:get_entity_by_id( id );
	if ( avatar ) then
		--print("===================找到实体==================")
		require "UI/common/EntityDialog"
		EntityDialog(avatar.model:getBillboardNode(), msg );
	end
end

---
function ChatCC:send_flower(number, selecttype, name)
	local pack = NetManager:get_socket():alloc(139,21)
	pack:writeShort(number)
	pack:writeChar(selecttype)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack)
	--print("send_flower:",number, selecttype, name)
end
---
function ChatCC:receive_flower(pack)
	local flower_num = pack:readShort()
	local resive_role_name = pack:readString()
	local send_rold_id = pack:readInt()
	local send_camp_id = pack:readInt()
	local send_job 		= pack:readInt()
	local send_level	= pack:readInt()
	local send_sex		= pack:readInt()
	local send_ico		= pack:readInt()
end
----------------------------------------------------
----------------------------------------------------
