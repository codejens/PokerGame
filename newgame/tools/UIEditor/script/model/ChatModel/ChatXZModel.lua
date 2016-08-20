---------------HJH
---------------2013-1-16
---------------
---------------
-- super_class.ChatXZModel()
ChatXZModel = {}
---------------
local _xz_chat_info ={}
local _xz_chat_info_max_num = 100
local _xz_chat_info_num = 0
---------------
-- added by aXing on 2013-5-25
function ChatXZModel:fini( ... )
	_xz_chat_info ={}
	_xz_chat_info_num = 0
end
---------------
function ChatXZModel:data_insert_data_info(info)
	if _xz_chat_info == nil then
		_xz_chat_info = {}
	end
	table.insert(_xz_chat_info, info)
	if #_xz_chat_info > _xz_chat_info_max_num then
		table.remove( _xz_chat_info, 1)
	end
end
---------------
function ChatXZModel:data_clear_info()
	_xz_chat_info = nil
	_xz_chat_info = {}
	_xz_chat_info_num = 0
end
---------------
function ChatXZModel:reinit_panel_info(info)
	local xz_win = UIManager:find_window("chat_xz_win")
	if xz_win ~= nil then
		xz_win:set_notic_info(info)
	end
end
---------------
function ChatXZModel:send_btn_fun()
	local xz_win = UIManager:find_visible_window("chat_xz_win")
	if xz_win ~= nil then
		--require "model/ChatModel/ChatModel"
		local chat_info = xz_win:get_insert_text_info()
		if chat_info == "" or chat_info == nil then
			return 
		end
		print("chat_info", chat_info)
		-- require "control/ChatCC"
		-- require "config/ChatConfig"
		-- ChatCC:send_chat(ChatConfig.Chat_chanel.CHANNEL_GUILD, 0, chat_info)
		--require "control/GuildCC"
		chat_info = ChatModel:format_chat_send_info(chat_info)
		GuildCC:request_guild_chat("1",chat_info)
		xz_win:set_insert_text("")
	end
end
---------------
function ChatXZModel:min_btn_fun()
	UIManager:hide_window("chat_xz_win")
	MiniBtnWin:show(7, ChatXZModel.open_xz_chat)
	ChatFaceModel:hide_face_fun(UIManager:find_window("chat_xz_win"))
end
---------------
function ChatXZModel:reinit_scroll_info()
	local xz_win = UIManager:find_visible_window("chat_xz_win")
	if xz_win ~= nil then
		xz_win.scroll:clear()
		xz_win.scroll:refresh()
	end
end
---------------
function ChatXZModel:open_xz_chat()
	local xz_win = UIManager:show_window("chat_xz_win")
	if xz_win ~= nil and _xz_chat_info ~= nil  and #_xz_chat_info > 0 then
		for i = 1, #_xz_chat_info do
			local temp_info = ""
			temp_info = temp_info .. _xz_chat_info[i]
			--if i <= #_xz_chat_info - 1 then
				temp_info = temp_info .. "#r"
				-- print("temp_info",temp_info)
				xz_win:set_dialog_info(temp_info)
			--end
		end
		--print("#_xz_chat_info,temp_info", #_xz_chat_info, temp_info)
		--xz_win:set_dialog_info(temp_info)
		-- ChatXZModel:data_clear_info()
		_xz_chat_info_num = 0
	end
	require "model/GuildModel"
	local guild_info = GuildModel:get_user_guild_info()
	xz_win:set_notic_info(guild_info.notice)
	xz_win.scroll:clear()
	xz_win.scroll:refresh()
end
---------------
function ChatXZModel:exit_btn_fun()
	ChatXZModel:data_clear_info()
	_xz_chat_info_num = 0
	UIManager:hide_window("chat_xz_win")
	ChatFaceModel:hide_face_fun(UIManager:find_window("chat_xz_win"))
end
---------------
function ChatXZModel:set_chat_info(ttype, name, qqvip, info)
	local xz_win = UIManager:find_visible_window("chat_xz_win")
	--require "model/GuildModel"
	local temp_info = ChatXZModel:format_chat_info( ttype, name, qqvip, info )
	print("ChatXZModel:set_chat_info info",info)
	print("ChatXZModel:set_chat_info temp_info",temp_info)
	if xz_win ~= nil then
		xz_win:set_dialog_info(temp_info)
		ChatXZModel:data_insert_data_info(temp_info)
	else
		ChatXZModel:data_insert_data_info(temp_info)
		_xz_chat_info_num = _xz_chat_info_num + 1
		if _xz_chat_info_num > 0 then
			MiniBtnWin:show(7, ChatXZModel.open_xz_chat, _xz_chat_info_num )
		end
	end
end
---------------
function ChatXZModel:create_scroll_item(width, height, info)
	require "UI/component/ListVertical"
	require "UI/component/Label"
	local size_info = {120, 58}
	local temp_item = ListVertical:create( nil, 0, 0, width, height, size_info, 1, 1 )
	local name_info = string.format("#ca9a9a9%s",info.name)
	if info.line == 1 then
		name_info = string.format("#c00ff00%s",info.name)
	end
	--local name_label = QQVIPName:create_qq_vip_info( info.qqvip, name_info ) --Label:create( nil, 0, 0, name_info)
	local name_label = QQVipInterface:create_qq_vip_info( info.qqvip, name_info )
	local onlien_info = Lang.chat.mode_str[12] -- [12]="#ca9a9a9离线"
	if info.line == 1 then
		onlien_info = Lang.chat.mode_str[13] -- [13]="#c00ff00在线"
	end
	local online_label = Label:create( nil, 0, 0, onlien_info)
	temp_item:addItem(name_label)
	temp_item:addItem(online_label)
	return temp_item
end
---------------
function ChatXZModel:scroll_create_fun(index)
	local xz_win = UIManager:find_window("chat_xz_win")
	local scroll_info = xz_win:get_scroll_info()
	local list_info = {vertical = 1, horizontal = 6}
	-------------------------
	require "UI/component/List"
	require "model/GuildModel"
	local page = List:create( nil, 0, 0, scroll_info.width, scroll_info.height, list_info.vertical, list_info.horizontal)
	local xz_info, online_num, offline_num = GuildModel:get_memb_infos()
	local xz_info = ChatXZModel:order_xz_member_info(xz_info,  online_num, offline_num)
	local scroll_num = (online_num + offline_num) / list_info.horizontal
	if scroll_num > 0 and scroll_num < 1 then
		scroll_num = 1
	end
	xz_win.scroll:setMaxNum(scroll_num)
	local size_info = { width = scroll_info.width, scroll_info.height / list_info.horizontal }
	-------------------------
	for i = 1 , list_info.vertical * list_info.horizontal do
		local tempIndex = index * list_info.vertical * list_info.horizontal + i
		if tempIndex > #xz_info then
			break
		end
		local item = ChatXZModel:create_scroll_item( size_info.width, size_info.height, xz_info[tempIndex] )
		page:addItem(item)
	end
	return page
end
---------------
function ChatXZModel:format_chat_info(ttype, name, qqvip, info)
	--local temp_info = name .. Lang.guild_info[ ttype + 1 ]
	--require "model/ChatModel/ChatModel"
	local cur_time = os.date("%X")
	local temp_info = ChatModel:AnalyzeInfo(info)
	local return_value
	local vip_info = QQVipInterface:get_qq_vip_platform_info(qqvip)
	local vip_img_info = QQVipInterface:get_qq_vip_image_info(qqvip)
	-- local vip_info = QQVIPName:get_user_qq_vip_info(qqvip)
	-- local vip_img_info = QQVIPName:get_qq_vip_image_info(qqvip)
	if vip_info.is_vip == 1 or vip_info.is_super_vip == 1 then
		if vip_info.is_year_vip == 1 then
			return_value = string.format( "##image,-1,-1,%s####image,-1,-1,%s###c00ff00%s#cff2cb6[%s]#c00ff00%s#r#cffffff%s",
			 vip_img_info.vip_icon, vip_img_info.year_icon, name, Lang.guild_info.position_name_t[ ttype + 1 ], cur_time, temp_info )
		else
			return_value = string.format( "##image,-1,-1,%s###c00ff00%s#cff2cb6[%s]#c00ff00%s#r#cffffff%s",
			 vip_img_info.vip_icon, name, Lang.guild_info.position_name_t[ ttype + 1 ], cur_time, temp_info )
		end
	else
		if vip_info.is_year_vip == 1 then
			return_value = string.format( "##image,-1,-1,%s###c00ff00%s#cff2cb6[%s]#c00ff00%s#r#cffffff%s",
			 vip_img_info.year_icon, name, Lang.guild_info.position_name_t[ ttype + 1 ], cur_time, temp_info )
		else
			return_value = string.format( "#c00ff00%s#cff2cb6[%s]#c00ff00%s#r#cffffff%s",
			 name, Lang.guild_info.position_name_t[ ttype + 1 ], cur_time, temp_info )
		end
	end
	return return_value
end
---------------
function ChatXZModel:order_xz_member_info(info, online_num, offline_num)
	local temp_info = info
	---------------
	if info == nil then
		return temp_info
	end
	---------------
	for i = 1, #info do
		if online_num ~= nil and i <= online_num then
			temp_info[i].line = 1
		else
			temp_info[i].line = 0
		end
	end
	---------------
	local function sort_fun(a, b)
		if a.line ~= nil and b.line ~= nil and a.level ~= nil and b.level ~= nil then
			if a.line > b.line then
				return true
			elseif a.line < b.line then
				return false
			elseif a.line == b.line and a.level > b.level then
				return true
			else
				return false
			end
		end
	end
	---------------
	table.sort( temp_info, sort_fun )
	return temp_info
end
---------------
function ChatXZModel:self_pos_fun()
	GuildCC:request_guild_chat("1", ChatModel:get_self_pos_info())
end
---------------
function ChatXZModel:face_btn_fun()
	ChatFaceModel:set_chat_face_type(1)
	local face_win = UIManager:show_window("chat_face_win", true)
	face_win:set_exit_btn_visible(true)
	-- face_win:clear_scroll()
	-- face_win:refresh_scroll()
	local face_win_pos = face_win:getPosition()
	face_win:setPosition( face_win_pos.x , 140)
	-- UIManager:show_window("chat_face_win")
	ChatFaceModel:set_cur_atcive_win( UIManager:find_window("chat_xz_win") )
end
---------------
function ChatXZModel:insert_info(info)
	local chat_xz_win = UIManager:find_window("chat_xz_win")
	if chat_xz_win ~= nil then
		chat_xz_win:set_insert_info(info)
	end
end
