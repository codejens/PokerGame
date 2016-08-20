----PlantModel.lua
----CHJ
----2015-1-22
----

LoginLuckyDrawModel = {}
------------------
LoginLuckyDrawModel._num_t = {}

-- 活动id
LoginLuckyDrawModel.ACTIVITY_ID = 2
-- 活动开始时间和结束时间
LoginLuckyDrawModel.is_open = false
LoginLuckyDrawModel.time_start = 0
LoginLuckyDrawModel.time_end = 0


-- 初始化
function LoginLuckyDrawModel:init( )
	-- 存储数据
	self._is_get = nil
	self._num_t = {}
end

function LoginLuckyDrawModel:req_login_award_data()
	MiscCC:req_login_award_data()
end

function LoginLuckyDrawModel:update_login_page( is_get, num_1, num_2, num_3 )
	print("chj", is_get, num_1, num_2, num_3)
	if is_get ==  0 then
		self._is_get = false
	else
		self._is_get = true
	end
	self._num_t[1] = num_1
	self._num_t[2] = num_2
	self._num_t[3] = num_3

	local win = UIManager:find_visible_window("award_win")
	if win then
		win:update("login_draw")
	end
end

-- 获取数据方法
function LoginLuckyDrawModel:get_data()
	return 	self._is_get, self._num_t
end

-- 抽奖请求
function LoginLuckyDrawModel:req_lucky_draw( index )
	MiscCC:req_lucky_draw( index )
end

-- 领奖请求
function LoginLuckyDrawModel:req_get_award()
	MiscCC:req_get_award( )
end

-- 设置开始时间和结束时间, onlineAwardCC
function LoginLuckyDrawModel:set_start_and_end_time( time_start, time_end, is_open )
print("----LoginLuckyDrawModel:set_start_and_end_time-", is_open)
	self.is_open = is_open
	if time_start ~= 0 then
		self.time_start = time_start + MINI_DATE_TIME_BASE
	else
		self.time_start = time_start
	end
	if time_end ~= 0 then
		self.time_end = time_end + MINI_DATE_TIME_BASE
	else
		self.time_end = time_end
	end
end

-- 获取活动开始时间和结束时间
function LoginLuckyDrawModel:get_start_and_end()
	-- return SmallOperationModel:get_start_end_time(LoginLuckyDrawModel.ACTIVITY_ID)
	return self.time_start, self.time_end
end

-- 获取活动是否开启，状态位
function LoginLuckyDrawModel:judge_is_open()
	return self.is_open
end

-- 获取开始时间到结束时间的字符串
function LoginLuckyDrawModel:get_open_time_str( )
	local time_start, time_end = LoginLuckyDrawModel:get_start_and_end()
	if time_start == 0 and time_end == 0 then
		return "活动已结束"
	end
	local st_year, st_month, st_day = Utils:second_to_year_month_day( time_start )
	local end_year, end_month, end_day = Utils:second_to_year_month_day( time_end )
	return st_year .. "年" .. st_month .. "月" .. st_day .. "日 -- " .. end_year .. "年" .. end_month .. "月" .. end_day .. "日"
end

-- 计算分页是否显示
function LoginLuckyDrawModel:is_show( )
	local time_start, time_end = LoginLuckyDrawModel:get_start_and_end()
	local is_open_temp = LoginLuckyDrawModel:judge_is_open()
	print("-0------is_show:", time_start, os.time(), time_end, is_open_temp)
	-- if time_start == 0 and time_end == 0 then
	-- 	return false
	-- end
	if is_open_temp == false then
		return false
	end
	local player = EntityManager:get_player_avatar()
	if player.level < 21 then
		return false
	end
	return true
end

-- 结束
function LoginLuckyDrawModel:fini( )

end
