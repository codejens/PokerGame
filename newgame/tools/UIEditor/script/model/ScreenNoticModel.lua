-------------------------HJH
-------------------------2013-1-16
-------------------------
-------------------------
ScreenNoticModel = {}
function ScreenNoticModel:fini( ... )
	local screen_notic_win = UIManager:find_window("screen_notic_win")
	print("ScreenNoticModel:fini screen_notic_win",screen_notic_win)
	if screen_notic_win == nil then
		return
	end
	screen_notic_win:clear_all_item()
end
CenterNoticModel = {}
function CenterNoticModel:fini( ... )
	local center_notic_win = UIManager:find_window("center_notic_win")
	if center_notic_win == nil then
		return 
	end
	center_notic_win:clear_all_item()
end
ScreenNoticRunModel = {}
function ScreenNoticRunModel:fini( ... )
	local screen_run_notic_win = UIManager:find_window("screen_run_notic_win")
	if screen_run_notic_win == nil then
		return
	end
	screen_run_notic_win:clear_all_item()
end