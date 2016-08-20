-----friendselectmode.lua
-----HJH
-----2013-2-17
-----------
-- super_class.FriendPersonalSetModel()
FriendPersonalSetModel = {}
-----------
local _auto_chat = false
local _reject_other = false
local _receive_auto_chat = false
local _auto_chat_selected_info = ""
local _auto_chat_selected_index = 0
-----------
-- added by aXing on 2013-5-25
function FriendPersonalSetModel:fini( ... )
	_auto_chat = false
	_reject_other = false
	_receive_auto_chat = false
end
-----------
function FriendPersonalSetModel:set_receive_auto_chat(auto_chat)
	_receive_auto_chat = auto_chat
end
-----------
function FriendPersonalSetModel:get_receive_auto_chat()
	return _receive_auto_chat
end
-----------
function FriendPersonalSetModel:get_auto_chat_msg()
	-- local personal_set_win = UIManager:find_window("friend_set_win")
	-- local cur_select = personal_set_win.radiobutton:getCurSelect()
	-- local select_item = personal_set_win.radiobutton:getIndexItem(cur_select)
	-- --print("cur_select", cur_select)
	-- return select_item:getText()
	return _auto_chat_selected_info
end

function FriendPersonalSetModel:get_auto_chat_index(  )
	return _auto_chat_selected_index
end
-----------
function FriendPersonalSetModel:get_auto_chat()
	return _auto_chat
end
-----------
function FriendPersonalSetModel:get_reject_other()
	return _reject_other
end
-----------
function FriendPersonalSetModel:open_auto_click_fun()
	if _auto_chat == true then
		_auto_chat = false
	else
		_auto_chat = true
	end
	-- print("run open_auto_click_fun _auto_chat",_auto_chat)
	-- require "model/ChatModel/ChatPrivateChatModel"
	-- local result = ChatPrivateChatModel:get_auto_chat_to_other()
	-- if result == true then
	-- 	ChatPrivateChatModel:set_auto_chat_to_other(false)
	-- else
	-- 	ChatPrivateChatModel:set_auto_chat_to_other(true)
	-- end
end
-----------
-----------
function FriendPersonalSetModel:reject_other_click_fun()
	if _reject_other == true then
		_reject_other = false
	else
		_reject_other = true
	end
	--print("run reject_other_click_fun _reject_other",_reject_other)
	-- require "model/ChatModel/ChatPrivateChatModel"
	-- local result = ChatPrivateChatModel:get_reject_other_private_chat()
	-- if result == true then
	-- 	ChatPrivateChatModel:set_reject_other_private_chat(false)
	-- else
	-- 	ChatPrivateChatModel:set_reject_other_private_chat(true)
	-- end
end
-----------
-----------
function FriendPersonalSetModel:ok_click_fun()
	local private_chat = UIManager:find_window("friend_set_win")
	if private_chat ~= nil then
		--print("FriendPersonalSetModel:ok_click_fun _auto_chat", _auto_chat)
		if _auto_chat == true then	
			private_chat.open_auto_reply:setCurState(CLICK_STATE_DOWN)
		else
			private_chat.open_auto_reply:setCurState(CLICK_STATE_UP)
		end
		--print("FriendPersonalSetModel:ok_click_fun _reject_other", _reject_other)
		if _reject_other == true then
			private_chat.reject_other_msg:setCurState(CLICK_STATE_DOWN)
		else
			private_chat.reject_other_msg:setCurState(CLICK_STATE_UP)
		end

		_auto_chat_selected_index = private_chat.radiobutton:getCurSelect()
		local selected_item = private_chat.radiobutton:getIndexItem(_auto_chat_selected_index)
		_auto_chat_selected_info = selected_item:getText()
	end
	-- require "model/ChatModel/ChatPrivateChatModel"
	-- local result = ChatPrivateChatModel:get_auto_chat_to_other()
	-- ChatPrivateChatModel:set_auto_chat_to_other(_auto_chat)
	-- ChatPrivateChatModel:set_reject_other_private_chat(_reject_other)
	UIManager:hide_window("friend_set_win")
end
-----------
-----------
function FriendPersonalSetModel:exit_click_fun()
	local private_chat = UIManager:find_window("friend_set_win")
	if private_chat ~= nil then
		--print("FriendPersonalSetModel:exit_click_fun _auto_chat", _auto_chat)
		if _auto_chat == true then	
			private_chat.open_auto_reply:setCurState(CLICK_STATE_DOWN)
		else
			private_chat.open_auto_reply:setCurState(CLICK_STATE_UP)
		end
		--print("FriendPersonalSetModel:exit_click_fun _reject_other", _reject_other)
		if _reject_other == true then
			private_chat.reject_other_msg:setCurState(CLICK_STATE_DOWN)
		else
			private_chat.reject_other_msg:setCurState(CLICK_STATE_UP)
		end
	end
	UIManager:hide_window("friend_set_win")
end
-----------
-----------
