--TestTips.lua
TestTips = simple_class(GUIWindow)

function TestTips:__init()
end

function TestTips:init(is_fini)
	if is_fini then
	end
end

function TestTips:registered_envetn_func()
	local function close_window_func()
		GUIManager:hide_window("test_tips")
	end
	self.btn_1:set_click_func(close_window_func)

	local function send_server_func()
		local msg_main_id = self.editbox_1:getString()
		local msg_child_id = self.editbox_2:getString()
		if msg_main_id == "" or msg_child_id == "" then
			print("消息id不能为空")
			return 
		end
		local func = protocol_func_map_client[tonumber(msg_main_id)][tonumber(msg_child_id)]
		if func then
			func()
		end
	end
	self.btn_2:set_click_func(send_server_func)
end