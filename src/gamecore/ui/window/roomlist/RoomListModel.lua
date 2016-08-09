RoomListModel = {}

function RoomListModel:init()
	self.win_name = "room_list_win"
end

function RoomListModel:show_game_win()
	GUIManager:show_window(self.win_name)
end

function RoomListModel:close_game_win()
	GUIManager:hide_window(self.win_name)
end

function RoomListModel:get_window()
	return GUIManager:find_window(self.win_name)
end

function RoomListModel:update_window(param1,param2,param3)
	GUIManager:update_window(self.win_name,param1,param2,param3)
end

RoomListModel:init()