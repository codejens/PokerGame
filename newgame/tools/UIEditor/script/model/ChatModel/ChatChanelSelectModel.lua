-------------------------HJH
-------------------------2013-1-16
-------------------------频道选择MODE
-- super_class.ChatChanelSelectModel()
ChatChanelSelectModel = {}
local show_type = 1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- added by aXing on 2013-5-25
function ChatChanelSelectModel:fini()
	-- TODO:: something
end
------------------------------------------------------------------------------------------
----------------
----------------附近频道按钮函数
function ChatChanelSelectModel:chanel_select_near_fun()
	local chat_win = UIManager:find_window("chat_win")
	--local chanel_select = chat_win:get_chanel_select_target()
	local insert = chat_win:get_insert_target()
	--chanel_select.view:setIsVisible(false)
	insert:set_cur_chanel_info(Lang.chat.chanel_name[5]) -- Lang.chat.chanel_name[5]="附近"
	--_chanel_select = ChatConfig.Chat_chanel.CHANNEL_MAP
	require "model/ChatModel/ChatModel"
	UIManager:hide_window("chat_chanel_select_win")
	ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_MAP)
end
----------------
----------------世界频道按钮函数
function ChatChanelSelectModel:chanel_select_world_fun()
	local chat_win = UIManager:find_window("chat_win")
	--local chanel_select = chat_win:get_chanel_select_target()
	local insert = chat_win:get_insert_target()
	--chanel_select.view:setIsVisible(false)
	insert:set_cur_chanel_info(Lang.chat.chanel_name[1]) -- Lang.chat.chanel_name[1]="世界"
	--_chanel_select = ChatConfig.Chat_chanel.CHANNEL_WORLD
	require "model/ChatModel/ChatModel"
	UIManager:hide_window("chat_chanel_select_win")
	ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_WORLD)
end
----------------
----------------阵营频道按钮函数
function ChatChanelSelectModel:chanel_select_camp_fun()
	local chat_win = UIManager:find_window("chat_win")
	--local chanel_select = chat_win:get_chanel_select_target()
	local insert = chat_win:get_insert_target()
	--chanel_select.view:setIsVisible(false)
	insert:set_cur_chanel_info(Lang.chat.chanel_name[2]) -- Lang.chat.chanel_name[2]="阵营"
	--_chanel_select = ChatConfig.Chat_chanel.CHANNEL_SCHOOL
	require "model/ChatModel/ChatModel"
	UIManager:hide_window("chat_chanel_select_win")
	ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_SCHOOL)
end
----------------
----------------仙宗频道按钮函数 
function ChatChanelSelectModel:chanel_select_xz_fun()
	local chat_win = UIManager:find_window("chat_win")
	--local chanel_select = chat_win:get_chanel_select_target()
	local insert = chat_win:get_insert_target()
	--chanel_select.view:setIsVisible(false)
	insert:set_cur_chanel_info(Lang.chat.chanel_name[3]) -- Lang.chat.chanel_name[3]="仙宗"
	--_chanel_select = ChatConfig.Chat_chanel.CHANNEL_GUILD
	require "model/ChatModel/ChatModel"
	UIManager:hide_window("chat_chanel_select_win")
	ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_GUILD)
end
----------------
----------------队伍频道按钮函数
function ChatChanelSelectModel:chanel_select_group_fun()
	local chat_win = UIManager:find_window("chat_win")
	--local chanel_select = chat_win:get_chanel_select_target()
	local insert = chat_win:get_insert_target()
	--chanel_select.view:setIsVisible(false)
	insert:set_cur_chanel_info(Lang.chat.chanel_name[4]) -- [4]="队伍"
	require "model/ChatModel/ChatModel"
	UIManager:hide_window("chat_chanel_select_win")
	ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_TEAM)
	--_chanel_select = ChatConfig.Chat_chanel.CHANNEL_TEAM
end

function ChatChanelSelectModel:set_show_type(type)
	show_type = type
end

function ChatChanelSelectModel:get_show_type()
	return show_type
end

