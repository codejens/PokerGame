RoomListModel = {}

function RoomListModel:init()
	self.win_name = "room_list_win"
	print("RoomListModel:init")
end

function RoomListModel:show_win()
	UIManager:show_window(self.win_name)
end

function RoomListModel:close_win()
	UIManager:hide_window(self.win_name)
end

function RoomListModel:get_win_name()
	return self.win_name
end

RoomListModel:init()