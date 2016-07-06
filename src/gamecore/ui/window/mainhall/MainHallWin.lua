--MainWin.lua
MainHallWin = simple_class(GUIWindow)

function MainHallWin:__init()
	print("MainWin:__init()")
end

function MainHallWin:init(is_fini)
	if is_fini then
	end
end

function MainHallWin:registered_envetn_func()
	local function btn_quick_start_func() 	--快速开始
		GameModel:req_enter_game(GameConfig.QUICK_GAME)
		-- MainHallModel:close_mainhall_win()
		-- GameModel:show_game_win()
	end
	self.btn_quick_start:set_click_func(btn_quick_start_func)
	local function btn_free_func() 			--自由场
		GameModel:req_enter_game(GameConfig.FREE_GAME)
	end
	self.btn_free:set_click_func(btn_free_func)
	local function btn_sport_func() 			--竞技场
		GameModel:req_enter_game(GameConfig.SPORT_GAME)
	end
	self.btn_sport:set_click_func(btn_sport_func)
end