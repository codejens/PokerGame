--MainWin.lua
MainWin = simple_class(GUIWindow)

function MainWin:__init()
	GameLogicCC:login_game()
	-- print("MainWin:__init()")
end

function MainWin:init(is_fini)
	if is_fini then
	end
end

function MainWin:registered_envetn_func()
	local function btn_zhanghao_func()
		-- LoginModel:do_login("a","123456")
		-- print("btn_zhanghao_func")
		MainHallModel:show_mainhall_win()
		LoginModel:close_login_win()
		-- GUIManager:hide_window("login_win")
		-- print(LoginModel:getInstance():get_test())

	end
	self.btn_zhanghao:set_click_func(btn_zhanghao_func)
	local function btn_youke_func()
	end
	self.btn_youke:set_click_func(btn_youke_func)
end