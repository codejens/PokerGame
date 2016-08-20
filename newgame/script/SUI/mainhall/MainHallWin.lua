--MainWin.lua
super_class.MainHallWin(BaseEditWin)
-- MainHallWin = simple_class(GUIWindow)

function MainHallWin:__init()
	print("MainWin:__init()")
	GameModel:req_enter_game(GameConfig.QUICK_GAME)


	-- local tt = 1
	-- local function do_func()

	-- 	GlobalFunc:create_screen_notic("aaaaaaaa"..tt)
	-- 	GlobalFunc:create_center_notic("bbbbbbbbb"..tt)
	-- 	GlobalFunc:create_screen_run_notic("cccccccccccc"..tt)
	-- 	tt = tt + 1
	-- end
	-- local t = timer()
	-- t:start(1,do_func)
	local call = callback:new()
	local function go_game_win_func()
		GameModel:req_enter_game(GameConfig.QUICK_GAME)
	end
	call:start(1,go_game_win_func)
end

function MainHallWin:init(is_fini)
	if is_fini then
	end
end

function MainHallWin:save_widget()
	self:init()
	self.btn_quick_start = self:get_widget_by_name("btn_quick_start")
	self.btn_free = self:get_widget_by_name("btn_free")
	self.btn_sport = self:get_widget_by_name("btn_sport")
end

function MainHallWin:registered_envetn_func()
	local function btn_quick_start_func() 	--快速开始
		GameModel:req_enter_game(GameConfig.QUICK_GAME)
		-- MainHallModel:close_window()
		-- GameModel:show_game_win()
	end
	self.btn_quick_start:set_click_func(btn_quick_start_func)
	local function btn_free_func() 			--自由场
		RoomListModel:show_win()
		-- GameModel:req_enter_game(GameConfig.FREE_GAME)
	end
	self.btn_free:set_click_func(btn_free_func)
	local function btn_sport_func() 			--竞技场
		GameModel:req_enter_game(GameConfig.SPORT_GAME)
	end
	self.btn_sport:set_click_func(btn_sport_func)
end

function MainHallWin:destory()

end