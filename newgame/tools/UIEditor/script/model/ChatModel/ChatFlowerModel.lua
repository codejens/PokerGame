-------------------------HJH
-------------------------2013-1-16
-------------------------鲜花MODE
-- super_class.ChatFlowerModel()
ChatFlowerModel = {}
-------------------------
local _send_num = 1
local _send_type = 1
-------------------------
-- added by aXing on 2013-5-25
function ChatFlowerModel:fini(  )
	_send_num = 1
	_send_type = 1
end
-------------------------
function ChatFlowerModel:one_flower_fun()
	_send_num = 1
end
-------------------------
function ChatFlowerModel:two_flower_fun()
	_send_num = 9
end
-------------------------
function ChatFlowerModel:three_flower_fun()
	_send_num = 99
end
-------------------------
function ChatFlowerModel:four_flower_fun()
	_send_num = 999
end
-------------------------
function ChatFlowerModel:name_send_fun()
	_send_type = 1
end
-------------------------
function ChatFlowerModel:unname_send_fun()
	_send_type = 0
end
-------------------------鲜花发送按钮函数
function ChatFlowerModel:send_btn_fun()
	-------------------------
	local bagData,bagNum = ItemModel:get_bag_data()
	local cur_item_id = nil
	local exist_item = false
	if _send_num == 1 then
		cur_item_id = 18608
	elseif _send_num == 9 then
		cur_item_id = 18609
	elseif _send_num == 99 then
		cur_item_id = 18610
	elseif _send_num == 999 then
		cur_item_id = 18611
	end
	-------------------------
	for i = 1, bagNum do
		if bagData[i] ~= nil  and bagData[i].item_id == cur_item_id then
			exist_item = true
			break
		end
	end
	-------------------------没有道具则进入快速购买
	if exist_item == false then 
		local function ok_fun()
			local it_id = cur_item_id
			BuyKeyboardWin:show(it_id,nil, 1, 99)
		end
		local text = Lang.chat.flowers[7] -- [7]="你背包没有此类型鲜花, 是否快速购买"
		require "UI/common/ConfirmWin"
		--confirm_type, fath_panel, notice_content, fun, param, pos_x, pos_y
		ConfirmWin( "select_confirm", nil, text, ok_fun, nil, 250, 130)
		return
	end
	-------------------------
	local flower_win = UIManager:find_window("chat_flower_send_win")
	local name = flower_win:get_send_name()
	print("_send_num, _send_type, name",_send_num, _send_type, name)
	MiscCC:send_send_flower(_send_num, _send_type, name)
	--ChatCC:send_flower(_send_num, _send_type, name)
	-- _send_num = 1
	-- _send_type = 0
	-- flower_win:set_num_index(0)
	-- flower_win:set_send_type_index(0)
	--UIManager:hide_window("chat_flower_send_win")
end
-------------------------鲜花退出按钮函数
function ChatFlowerModel:exit_btn_fun()
	local flower_win = UIManager:find_window("chat_flower_send_win")
	_send_num = 1
	_send_type = 1
	-- flower_win:set_num_index(0)
	-- flower_win:set_send_type_index(0)
	UIManager:hide_window("chat_flower_send_win")
end
-- -------------------------
-- local _chat_win_panel = nil
-- -------------------------
-- function ChatFlowerMode:set_chat_win_panel(panel)
-- 	_chat_win_panel = panel
-- end
-- ---------------赠送鲜花
-- function ChatFlowerMode:run_send(selfPanel, number, sendType, name)
-- 	ChatMode:exit_chat_win_fun()
-- 	--print("number,sendType",number,sendType)
-- 	if number ~= nil and sendType >= 0 then
-- 		ChatCC:send_flower(number, sendType, name)
-- 		selfPanel.send_flower_select_number = 0
-- 		selfPanel.send_flower_to_select_type = 0
-- 	end
-- end
-- ---------------
-- function ChatFlowerMode:run_exit(selfPanel, number, sendType, name)
-- 	ChatMode:exit_chat_win_fun()
-- 	if number ~= nil and sendType >= 0 then
-- 		ChatCC:send_flower(number, sendType, name)
-- 		selfPanel.send_flower_select_number = 0
-- 		selfPanel.send_flower_to_select_type = 0
-- 	end
-- end
-- ---------------
