GameModel = {}

function GameModel:init()
	self.win_name = "game_win"
	print("GameModel:init")
end

function GameModel:show_game_win()
	GUIManager:show_window(self.win_name)
end

function GameModel:close_game_win()
	GUIManager:hide_window(self.win_name)
end

function GameModel:req_enter_game(flag)
	GameCC:req_enter_game(flag)
end

function GameModel:set_cur_player_array(player_array)
	self.cur_player_array = player_array
	MainHallModel:close_mainhall_win()
	self:show_game_win()
end

function GameModel:get_cur_player_array()
	return self.cur_player_array
end

function GameModel:add_player(player_info)
	self.cur_player_array[player_info.index] = player_info
end

function GameModel:delete_player(index)
	self.cur_player_array[index] = nil
end

GameModel:init()