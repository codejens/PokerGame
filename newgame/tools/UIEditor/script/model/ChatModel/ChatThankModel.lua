-----chatthankmodel.lua
-----HJH
-----2013-2-25
-----------
-- super_class.ChatThankModel()
ChatThankModel = {}
-----------
local _thank_info = {}
-----------
-- added by aXing on 2013-5-25
function ChatThankModel:fini( ... )
	_thank_info = {}
end
-----------
function ChatThankModel:exit_btn_fun()
	UIManager:hide_window("chat_thank_win")
end
-----------
function ChatThankModel:thank_btn_fun()
	UIManager:hide_window("chat_thank_win")
	local thank_msg = Lang.chat.mode_str[11] -- [11]="好感动啊!谢谢你送的花,真的好漂亮,我好喜欢!"
	thank_msg = string.format("%d%s%s", ChatConfig.PrivateChatType.TYPE_THANK_CHAT_INFO, ChatConfig.message_split_target.CHAT_INFO_PRIVAT_TARGET, thank_msg)
	ChatCC:send_private_chat(_thank_info.id, 0, _thank_info.name, thank_msg)
end
-----------
function ChatThankModel:resend_btn_fun()
	UIManager:hide_window("chat_thank_win")
	local flower_send_win = UIManager:show_window("chat_flower_send_win")
	flower_send_win:reinit_info(_thank_info.name)
end
-----------
function ChatThankModel:open_thank_info(tid, tcamp, tjob, tlevel, tsex, tnum, tname, ticon)
	_thank_info = {id = tid, camp = tcamp, job = tjob, level = tlevel, sex = tsex, num = tnum, name = tname, icon = ticon}
	local thank_win = UIManager:show_window("chat_thank_win")
	thank_win:reinit_info(tname, tnum)
end
