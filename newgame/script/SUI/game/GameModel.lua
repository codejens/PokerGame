GameModel = {}

function GameModel:init()
	self.win_name = "game_win"
	print("GameModel:init")
end

function GameModel:show_game_win()
	UIManager:show_window(self.win_name)
end

function GameModel:close_game_win()
	UIManager:hide_window(self.win_name)
end

function GameModel:req_enter_game(flag)
	GameCC:req_enter_game(flag)
end

function GameModel:set_cur_room_data(data)
	self.room_data = data
	MainHallModel:close_mainhall_win()
	self:show_game_win()
end

function GameModel:get_cur_player_array()
	return self.room_data.player_array
end

function GameModel:add_player(player_info)
	self.room_data.player_array[player_info.index] = player_info
	self:update_window("add_player",player_info.index)
end

function GameModel:get_window()
	return UIManager:find_window(self.win_name)
end

function GameModel:update_window(param1,param2,param3)
	UIManager:update_window(self.win_name,param1,param2,param3)
end

function GameModel:delete_player(index)
	self.room_data.player_array[index] = nil
	self:update_window("delete_player",index)
end

GameModel:init()