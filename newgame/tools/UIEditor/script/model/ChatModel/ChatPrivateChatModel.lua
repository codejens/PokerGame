-------------------------HJH
-------------------------2013-1-16
-------------------------聊天私聊息栏MODE
-------------------------格式化聊天私聊信息
-- super_class.ChatPrivateChatModel()
ChatPrivateChatModel = {}
-----------------------
--当前聊天对象信息
local _cur_private_chat_info = nil		
-----------------------
--所有聊天对象信息
local _private_chat_info = {}
-----------------------
--私聊信息最大数量			
local _private_chat_max_info_num = 50	
-----------------------
-------自动回复
local _auto_chat_to_other = false
-----------------------
------拒绝陌生人私聊
local _reject_other_private_chat = false	
-----------------------
-- added by aXing on 2013-5-25
function ChatPrivateChatModel:fini( ... )
	_cur_private_chat_info = nil
	_private_chat_info = nil
	_private_chat_info = {}
	_auto_chat_to_other = false
	_reject_other_private_chat = false
end
-----------------------
-----------------------
function ChatPrivateChatModel:get_private_chat_info()
	return _private_chat_info
end
-----------------------
-----------------------
function ChatPrivateChatModel:set_cur_chat_info(id)
	local temp_info = ChatPrivateChatModel:data_find_info(id)
	if temp_info ~= nil then
		_cur_private_chat_info = _private_chat_info[temp_info]
	end
end
-----------------------
-----------------------设置自动回复状态
function ChatPrivateChatModel:set_auto_chat_to_other(auto)
	_auto_chat_to_other = auto
end
-----------------------
-----------------------取得自动回复状态
function ChatPrivateChatModel:get_auto_chat_to_other()
	return _auto_chat_to_other
end
-----------------------
-----------------------设置拒绝陌生人私聊状态
function ChatPrivateChatModel:set_reject_other_private_chat(reject)
	_reject_other_private_chat = reject
end
-----------------------
-----------------------取得拒绝陌生人私聊状态
function ChatPrivateChatModel:get_reject_other_private_chat()
	return _reject_other_private_chat
end
-----------------------
-----------------------邀请组队函数
function ChatPrivateChatModel:invote_btn_fun()
	TeamCC:req_invate_join_team( _cur_private_chat_info.name );
end
-----------------------
-----------------------查看他人信息按钮函数
function ChatPrivateChatModel:check_data_btn_fun()
	OthersCC:check_player_info(_cur_private_chat_info.id, _cur_private_chat_info.name)
	ChatPrivateChatModel:min_btn_fun()
end
-----------------------
-----------------------添加好友按钮函数
function ChatPrivateChatModel:add_friend_btn_fun()
	if FriendModel:is_my_friend(_cur_private_chat_info.id) == false then
		FriendCC:request_add_friend(_cur_private_chat_info.id, _cur_private_chat_info.name)
	else
		GlobalFunc:create_screen_notic(Lang.friend_info.Is_My_Friend)
	end
end
-----------------------
-----------------------初始化私聊信息
function ChatPrivateChatModel:reinit_panel_info()
	if _cur_private_chat_info == nil then
		return
	end
	local name, qqvip, level, camp, job, sex = _cur_private_chat_info.name, _cur_private_chat_info.qqvip, _cur_private_chat_info.level, _cur_private_chat_info.camp, _cur_private_chat_info.job, _cur_private_chat_info.sex
	local campname = nil
	local campIndex = tonumber(camp)
	local jobIndex = tonumber(job)
	--------
	local iconFile = string.format(UIResourcePath.FileLocate.lh_normal .. "head/head%d%d.png",jobIndex,sex)
	local returnInfo = {}
	-------------
	local vip_info = QQVipInterface:get_qq_vip_platform_info(qqvip)
	local vip_img_info = QQVipInterface:get_qq_vip_image_info(qqvip)
	-- local vip_info = QQVIPName:get_user_qq_vip_info(qqvip)
	-- local vip_img_info = QQVIPName:get_qq_vip_image_info(qqvip)
	if vip_info.is_vip == 1 or vip_info.is_super_vip == 1 then
		if vip_info.is_year_vip == 1 then
			returnInfo[1] = string.format(Lang.chat.mode_str[5], -- [5]="与##image,-1,-1,%s####image,-1,-1,%s###cfff000%s#cffffff私聊中"
					vip_img_info.vip_icon,vip_img_info.year_icon, name)
		else
			returnInfo[1] = string.format(Lang.chat.mode_str[6], -- [563]="与##image,-1,-1,%s###cfff000%s#cffffff私聊中"
					vip_img_info.vip_icon, name)
		end
	else
		if vip_info.is_year_vip == 1 then
			returnInfo[1] = string.format(Lang.chat.mode_str[6], -- [6]="与##image,-1,-1,%s###cfff000%s#cffffff私聊中"
					vip_img_info.year_icon, name)
		else
			returnInfo[1] = string.format(Lang.chat.mode_str[7],name) -- [7]="与#cfff000%s#cffffff私聊中"
		end		
	end
	returnInfo[2] = "#cfff000" .. name
	returnInfo[3] = Lang.chat.mode_str[8] .. level -- [55]="#c00ff00等级:"
	returnInfo[4] = Lang.chat.mode_str[9]  .. Lang.camp_info[campIndex] -- [56]="#c00ff00阵营:"
	returnInfo[5] = Lang.chat.mode_str[10] .. Lang.job_info[jobIndex] -- [57]="#c00ff00职业:"
	returnInfo[6] = iconFile
	-------
	local private_win = UIManager:find_visible_window("chat_private_win")
	print("private_win",private_win)
	if private_win ~= nil then
		private_win:reinit_info(returnInfo[1], returnInfo[2], returnInfo[3], returnInfo[4], returnInfo[5], returnInfo[6])
	end
	--return returnInfo
end
-----------------------
-----------------------格式化私聊聊天信息
function ChatPrivateChatModel:format_private_chat_info(playerName, msgInfo, qqvip)
	local returnInfo
	local fontcolor
	local curTime = os.date("%X")
	local myName = EntityManager:get_player_avatar().name
	--print("ChatPrivateChatModel:format_private_chat_info",msgInfo)
	local vip_info = QQVipInterface:get_qq_vip_platform_info(qqvip)
	local vip_img_info = QQVipInterface:get_qq_vip_image_info(qqvip)	
	-- local vip_info = QQVIPName:get_user_qq_vip_info(qqvip)
	-- local vip_img_info = QQVIPName:get_qq_vip_image_info(qqvip)	
	local temp_msginfo = ChatModel:AnalyzeInfo(msgInfo)
	-----------------------
	if myName == playerName then
		fontcolor = "#cffff00"
		--returnInfo = string.format("#cffff00%s  %s#r#c00ff00%s", playerName, curTime, temp_msginfo)
	else
		fontcolor = "#c00bfff"
		--returnInfo = string.format("#c00bfff%s  %s#r#c00ff00%s", playerName, curTime, temp_msginfo)
	end
	-----------------------
	if vip_info.is_vip == 1 or vip_info.is_super_vip == 1 then
		if vip_info.is_year_vip == 1 then
			returnInfo = string.format( "##image,-1,-1,%s####image,-1,-1,%s##%s%s  %s#r#cffffff%s",
			 vip_img_info.vip_icon, vip_img_info.year_icon, fontcolor, playerName, curTime, temp_msginfo )
		else
			returnInfo = string.format( "##image,-1,-1,%s##%s%s  %s#r#cffffff%s",
			 vip_img_info.vip_icon, fontcolor, playerName, curTime, temp_msginfo )	
		end
	else
		if vip_info.is_year_vip == 1 then
			returnInfo = string.format( "##image,-1,-1,%s##%s%s  %s#r#cffffff%s",
			 vip_img_info.year_icon, fontcolor, playerName, curTime, temp_msginfo )
		else
			returnInfo = string.format( "%s%s  %s#r#cffffff%s",
			 fontcolor, playerName, curTime, temp_msginfo )	
		end
	end
	print("ChatPrivateChatModel:format_private_chat_info", returnInfo)	
	return returnInfo
end
-----------------------
-----------------------发送按钮函数
function ChatPrivateChatModel:send_btn_fun()
	local private_panel = UIManager:find_window("chat_private_win")	
	--require "model/ChatModel/ChatModel"
	local chatInfo = private_panel:get_insert_text_info()
	--print("chatInfo",chatInfo)
	if chatInfo == "" or chatInfo == nil then
		return
	end
	chatInfo = ChatModel:format_chat_send_info(chatInfo)
	ChatCC:send_private_chat(_cur_private_chat_info.id, 0, _cur_private_chat_info.name, chatInfo)
	--require "model/ChatModel/ChatModel"
	--local temp = ChatModel:AnalyzeInfo(chatInfo)
	--_chat_win_panel:setChatPrivateChatInsetMsg("")
	-- local msgInfo = ChatPrivateChatModel:format_private_chat_info(EntityManager:get_player_avatar().name, chatInfo)
	-- print("msgInfo",msgInfo)
	-- private_panel:set_dialog_info(msgInfo)
	private_panel:set_insert_text("")
	--ChatMode:runDefaultFun()
end
-----------------------
-----------------------最小化按钮函数
function ChatPrivateChatModel:min_btn_fun()
	local userpanel = UIManager:find_window("user_panel")
	userpanel:set_whisper_btn_visible(true)
	local private_win = UIManager:find_window("chat_private_win")
	if private_win ~= nil then
		private_win:set_dialog_info("")
	end
	UIManager:hide_window("chat_private_win")
	ChatFaceModel:hide_face_fun(UIManager:find_window("chat_private_wine"))
end
-----------------------
-----------------------打开私聊函数
function ChatPrivateChatModel:open_private_chat()
	print("begin run open private chat")
	if _cur_private_chat_info ~= nil then
		local private_chat_panel = UIManager:show_window("chat_private_win")
		--if _last_role_id ~= _parivate_chat_info.id then
			print("clear private chat dialog info")
			--local private_chat_panel = UIManager:find_window("chat_private_win")
			ChatPrivateChatModel:reinit_panel_info(_cur_private_chat_info.name, _cur_private_chat_info.qqvip, _cur_private_chat_info.level, _cur_private_chat_info.camp,
			 _cur_private_chat_info.job, _cur_private_chat_info.sex)
			private_chat_panel:set_dialog_info("")	
		--end
		--local tempinfo = ""
		--for i = 1, #_private_chat_chat_info do 
			--if _private_chat_chat_info[i].id == _parivate_chat_info.id then
		for j = 1 , #_cur_private_chat_info.chat_info do
			local tempinfo = ""
			print("_cur_private_chat_info.chat_info",_cur_private_chat_info.chat_info[j])
			local msgInfo = _cur_private_chat_info.chat_info[j]--ChatPrivateChatModel:format_private_chat_info(_private_chat_chat_info[i].role_info.name, _private_chat_chat_info[i].chat_info[j])	
			local can_add = true
			if j == 1 and _cur_private_chat_info.chat_info[j] == "" then
				can_add = false
			end
			if can_add == true then
				-- print("tempinfo",tempinfo)
				-- print("msgInfo", msgInfo)
				tempinfo = tempinfo .. msgInfo
				--if j < #_private_chat_chat_info[i].chat_info then
				tempinfo = tempinfo .. "#r"
				private_chat_panel:set_dialog_info(tempinfo)
				--end
			end
		end
				--table.remove( _private_chat_chat_info, i)
				-- _private_chat_chat_info[i] = nil
				-- _private_chat_chat_info[i] = {}
				--break
			--end
		--end
		--print("tempinfo",tempinfo)
		--_last_role_id = _parivate_chat_info.id
		-- if tempinfo ~= "" then
		-- 	print("add info:tempinfo",tempinfo)
		-- 	private_chat_panel:set_dialog_info(tempinfo)
		-- end
	end
end
-----------------------
-----------------------退出按钮函数
function ChatPrivateChatModel:exit_btn_fun()
	--_role_id = nil
	--_last_role_id = _parivate_chat_info.id
	local i = 1
	print("#_private_chat_chat_info",#_private_chat_info)
	for i = 1, #_private_chat_info do
		print("_private_chat_info[i].id",_private_chat_info[i].id)
		if _private_chat_info[i].id == _cur_private_chat_info.id then
			table.remove(_private_chat_info, i)
			break
		end
	end
	-- if #_private_chat_info > 0 and _private_chat_chat_info[i] ~= nil then
	-- 	local font_data = _private_chat_chat_info[i]
	-- 	print("font_data",font_data.role_info)
	-- 	--id = tid, name = tname, camp = tcamp, level = tlevel, sex = tsex, job = tjob
	-- 	_parivate_chat_info = { id = font_data.id, name = font_data.role_info.name, 
	-- 	camp = font_data.role_info.camp, level = font_data.role_info.level, 
	-- 	sex = font_data.role_info.sex, job = font_data.role_info.job }
	-- else
	_cur_private_chat_info = nil
	--_last_role_id = nil
	--end
	--require "UI/main/UserPanel"
	local private_chat_win = UIManager:find_window("chat_private_win")
	print("private_chat_win", private_chat_win)
	if private_chat_win ~= nil then
		private_chat_win:set_dialog_info("")
	end
	local userpanel = UIManager:find_window("user_panel")
	if #_private_chat_info > 0 then
		userpanel:set_whisper_btn_visible( true )
	else
		userpanel:set_whisper_btn_visible( false )
	end
	UIManager:hide_window("chat_private_win")
	ChatFaceModel:hide_face_fun(UIManager:find_window("chat_private_win"))
	--ChatMode:exit_chat_win_fun()
end
-----------------------
-----------------------
function ChatPrivateChatModel:data_find_info(id)
	for i = 1, #_private_chat_info do
		if _private_chat_info[i].id == id then
			return i
		end
	end
	return nil
end
-----------------------
-----------------------数据操作 设置聊天信息
function ChatPrivateChatModel:data_set_data_info(tid, tname, tqqvip, tlevel, tcamp, tjob, tsex)
	--_last_role_id = tid
	--_parivate_chat_info = {id = tid, name = tname, qqvip = tqqvip, camp = tcamp, level = tlevel, sex = tsex, job = tjob}
	local temp_tar_info = ChatPrivateStruct( tid, tname, tqqvip, tcamp, tlevel, tsex, tjob )
	local target_exist = ChatPrivateChatModel:data_find_info( tid )
	if target_exist == nil then
		table.insert( _private_chat_info, temp_tar_info )
	end
end
-----------------------
-----------------------表情按钮函数
function ChatPrivateChatModel:face_btn_fun()
	ChatFaceModel:set_chat_face_type(1)
	ChatFaceModel:set_cur_atcive_win( UIManager:find_window("chat_private_win") )
	local face_win = UIManager:show_window("chat_face_win", true)
	face_win:set_exit_btn_visible(true)
	-- face_win:clear_scroll()
	-- face_win:refresh_scroll()
	local face_win_pos = face_win:getPosition()
	face_win:setPosition( face_win_pos.x , 200)
	--UIManager:show_window("chat_face_win")
	
end
-----------------------
-----------------------自身位置按钮函数
function ChatPrivateChatModel:self_pos_fun()
	ChatCC:send_private_chat( _cur_private_chat_info.id, 0, _cur_private_chat_info.name, ChatModel:get_self_pos_info() )
end
-----------------------
-----------------------设置私聊激活状态
function ChatPrivateChatModel:get_private_is_active()
	local chat_private_scroll = UIManager:find_visible_window("chat_private_scroll")
	if chat_private_scroll ~= nil or #_private_chat_info == 0 then
		return false
	else
	 	return true
	end
end
-----------------------
-----------------------
function ChatPrivateChatModel:data_add_private_chat_chat_info(id, info)
	local index = ChatPrivateChatModel:data_find_info(id)
	if index ~= nil then
		table.insert( _private_chat_info[index].chat_info, info )
	end
end
-----------------------
-----------------------
function ChatPrivateChatModel:data_add_new_message_num(id)
	local index = ChatPrivateChatModel:data_find_info(id)
	if index ~= nil then
		_private_chat_info[index].new_message_num = _private_chat_info[index].new_message_num + 1
		if _private_chat_info[index].new_message_num > _private_chat_max_info_num then
			_private_chat_info[index].new_message_num = _private_chat_max_info_num
		end
	end
end
-----------------------
-----------------------设置私聊信息
function ChatPrivateChatModel:set_private_chat_info(tid, tname, tqqvip, tlevel, tcamp, tjob, tsex, tchatinfo)
	ChatPrivateChatModel:data_set_data_info(tid, tname, tqqvip, tlevel, tcamp, tjob, tsex)
	ChatPrivateChatModel:data_add_private_chat_chat_info(tid, tchatinfo)
	-----------------------
	local private_chat_win = UIManager:find_visible_window("chat_private_win")
	if private_chat_win ~= nil and _cur_private_chat_info.id == tid then
		private_chat_win:set_dialog_info(tchatinfo)
	else
		ChatPrivateChatModel:data_add_new_message_num(tid)
	end
	local chat_private_scroll = UIManager:find_visible_window("chat_private_scroll")
	if chat_private_scroll ~= nil then
		chat_private_scroll:update_scroll()
	end
end
-----------------------
-----------------------重设私聊标题信息
function ChatPrivateChatModel:reinit_title_info()
	if _cur_private_chat_info ~= nil then
		ChatPrivateChatModel:reinit_panel_info(_cur_private_chat_info.name, _cur_private_chat_info.qqvip,
			_cur_private_chat_info.level, _cur_private_chat_info.camp, _cur_private_chat_info.job, _cur_private_chat_info.sex)
	end
end
-----------------------
-----------------------
function ChatPrivateChatModel:cancell_all_fun()
	_private_chat_info = nil
	_private_chat_info = {}
	_cur_private_chat_info = nil
	UIManager:hide_window("chat_private_scroll")
	local userpanel = UIManager:find_window("user_panel")
	userpanel:set_whisper_btn_visible( false )
end
