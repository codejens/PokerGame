----QQBlueDiamonTimeAwardModel.lua
----HJH 2013-12-14
----蓝钻尊贵活动model
QQBlueDiamonTimeAwardModel = {}
----------------------------------
local _remian_time = 0
local _reward_state = 0
----------------------------------
function QQBlueDiamonTimeAwardModel:fini(...)
	_remian_time = 0
end
----------------------------------
function QQBlueDiamonTimeAwardModel:set_reward_state(result)
	_reward_state = result
end
----------------------------------
function QQBlueDiamonTimeAwardModel:set_remain_time(result)
	local cur_time = os.time()
	_remian_time = result + cur_time
	local right_top_panel = UIManager:find_window("right_top_panel")
	print("_remian_time,_reward_state", _remian_time,_reward_state)
	if result <= 0 or _reward_state > 0 then	
		if right_top_panel ~= nil then
			right_top_panel:remove_btn(9)
		end
		UIManager:hide_window("blue_diamond_win")
	else
		right_top_panel:insert_btn(9)
	end
end
----------------------------------
function QQBlueDiamonTimeAwardModel:get_remian_time()
	local temp_time = _remian_time - os.time()
	if temp_time < 0 then
		temp_time = 0
	end
	return temp_time
end
----------------------------------
function QQBlueDiamonTimeAwardModel:open_win()
	if _remian_time > 0 then
		UIManager:show_window("blue_diamond_win")
	end
end