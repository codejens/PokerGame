MainHallModel = {}

function MainHallModel:init()
	print("MainHallModel:init")
end

function MainHallModel:show_window()
	UIManager:show_window("mainhall_win")
end

function MainHallModel:close_window()
	UIManager:destroy_window("mainhall_win")
end

local function player_leave(index)
	print("index=",index)
end