----PlantModel.lua
----CHJ
----2013-8-8
----
OnlineAwardModel = {}
------------------

-- 数据
local award_index = nil
local count_time = nil
local remain_num = nil
local count_timer = nil

-- 时候可领取
local is_get_award = false

-- 初始化
function OnlineAwardModel:init( )
	award_index = nil
	count_time = nil
	remain_num = nil
	is_get_award = nil
	if count_timer then
		count_timer:stop()
		count_timer = nil
	end
end

-- 登陆保存数据
function OnlineAwardModel:set_data( award_index_, count_time_, remain_num_ )
	-- 没事重置数据设置为is_get_award 为false
	is_get_award = false

	award_index = award_index_
	count_time = count_time_
	remain_num = remain_num_
	local win = UIManager:find_visible_window( "right_top_panel" )
	if count_time == 0 then
		is_get_award = true
		if remain_num > 0 then
			if win then
				win:shanshuo_btn(5, true)
			end
		elseif win then
			win:shanshuo_btn(5, false)
		end
	elseif win then
		win:shanshuo_btn(5, false)
	end
	-- 开始倒计时
	self:count_time_func()

	local win = UIManager:find_visible_window( "award_win" )
	if win then
		win:update_online_award()
	end
	--无在线奖励和七天奖励的时候隐藏主界面领奖按钮
	print('remain_num-----', remain_num, sevenDayAwardModel:check_can_get_award())
	local right_top_panel = UIManager:find_window("right_top_panel")
	if remain_num == 0 and not sevenDayAwardModel:check_can_get_award() then
		if right_top_panel ~= nil then
			right_top_panel:remove_btn(5)
		end
	else
		if right_top_panel ~= nil then
			right_top_panel:insert_btn(5)
		end
	end
end

-- 获取数据
function OnlineAwardModel:get_data()
	return award_index, count_time, remain_num
end

-- 设置可领取 & 获取时候可领取
function OnlineAwardModel:set_award_state( state )
	is_get_award = state
end

function OnlineAwardModel:get_award_state( )
	return is_get_award
end

-- 倒计时开始
function OnlineAwardModel:count_time_func( )
	local function count_func( dt )
		count_time = count_time - dt
		if (count_time < 0) or (count_time == 0) then
			count_time = 0
			is_get_award = true
			if count_timer then
				count_timer:stop()
				count_timer = nil
			end
			local win = UIManager:find_visible_window( "right_top_panel" )
			if remain_num > 0 then
				if win then
					win:shanshuo_btn(5, true)
				end
			elseif win then
				win:shanshuo_btn(5, false)
			end
		end
	end
	count_timer = timer()
	count_timer:start(1, count_func)
end

-- 结束
function OnlineAwardModel:fini( )

end
