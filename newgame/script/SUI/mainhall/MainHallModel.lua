MainHallModel = {}

function MainHallModel:init()
	print("MainHallModel:init")
end

function MainHallModel:show_mainhall_win()
	UIManager:show_window("mainhall_win")
end

function MainHallModel:close_mainhall_win()
	UIManager:hide_window("mainhall_win")
end

local function player_leave(index)
	print("index=",index)
end