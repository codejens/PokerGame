-- RenZheJiJinModel.lua
-- 忍者基金

RenZheJiJinModel = {}


-- 活动开始时间
RenZheJiJinModel.start_time = 0
-- 活动结束时间
RenZheJiJinModel.end_time	= 0

local jijin_kind = RenZheJiJinConfig.NONE_JIJIN;
local jijin_reward = {};
local jijin_can_buy = 3

function RenZheJiJinModel:fini()
	is_buy = false;
	jijin_can_buy = 3
	jijin_kind = RenZheJiJinConfig.NONE_JIJIN;
	jijin_reward = {};
	RenZheJiJinModel.start_time = 0
	RenZheJiJinModel.end_time	= 0
end

function RenZheJiJinModel:update_win_info( icon_state, buy_state )
	if buy_state == 1 then
		-- 请求服务器发送基金购买信息
		MissCC:send_tzfl_info();
	end
end

function RenZheJiJinModel:update_jijin_info( kind, info, can_buy )
	--xiehande  标记
	-- 保存基金类型
	if kind == 0 then
		jijin_kind = RenZheJiJinConfig.NONE_JIJIN;
	elseif kind == 1 then
		jijin_kind = RenZheJiJinConfig.n30DAY;
	elseif kind == 2 then
		jijin_kind = RenZheJiJinConfig.n7DAY;
	end
	-- 保存奖励领取记录( 0: 可领, 1: 已领, 2: 不可领 )
	for i=1, #info do
		jijin_reward[i] = info[i];
	end
	-- if #info < 7 and #info > 0 then
	-- 	for j=#info, 7 do
	-- 		jijin_reward[j] = 2
	-- 	end
	-- end
	jijin_can_buy = can_buy

	local rzjj_win = UIManager:find_visible_window("renzhe_jijin_win");
	if rzjj_win then
		rzjj_win:update();
	end

	-- 如果当前已领取完所有的返还基金,则将主界面的基金入口按钮隐藏
	local is_all_award_complete = RenZheJiJinModel:is_all_award_complete()
	if is_all_award_complete then
		local win = UIManager:find_window("right_top_panel")
		if win then
			win:set_renzhejijin_btn_visible(false)
		end
	end
end

function RenZheJiJinModel:get_jijin_can_buy( jijin_type )
	if jijin_can_buy == 3 then
		return false
	end
	if jijin_type == RenZheJiJinConfig.n30DAY then
		return jijin_can_buy ~= 1
	elseif jijin_type == RenZheJiJinConfig.n7DAY then
		return jijin_can_buy ~= 2
	end
	return false
end

function RenZheJiJinModel:get_jijin_kind()
	return jijin_kind;
end

function RenZheJiJinModel:get_jijin_reward()
	return jijin_reward;
end

function RenZheJiJinModel:get_jijin_reward_by_day( day )
	-- if day >=1 and day <= 7 then
		return jijin_reward[day];
	-- end
end

-- 0:参数非法 1:已购买 2:可购买
function RenZheJiJinModel:check_is_can_buy_or_can_get( kind )
	local can_buy,can_get;
	-- 购买的基金类型是否有效
	if kind ~= 1 and kind ~= 2 and kind ~= 3 then
		return;
	end
	-- 是否已购买基金
	if jijin_kind ~= RenZheJiJinConfig.NONE_JIJIN then
		if kind == jijin_kind then
			can_buy = false;
			can_get = self:check_next_can_get_reward();
		end
	else
		can_buy = true;
	end
	return can_buy,can_get;
end

function RenZheJiJinModel:check_next_can_get_reward()
	if jijin_kind == RenZheJiJinConfig.NONE_JIJIN then
		return;
	end

	for i=1, #jijin_reward do
		if jijin_reward[i] == 0 then
			return i
		end
	end
end

function RenZheJiJinModel:whether_have_reward_can_get( kind )
	if jijin_kind == RenZheJiJinConfig.NONE_JIJIN then
		return false;
	end

	for i=1, #jijin_reward do
		if jijin_reward[i] == 0 then
			return true;
		end
	end
	return false;
end

function RenZheJiJinModel:get_start_time()
	return self.start_time;
end

function RenZheJiJinModel:set_start_time( t )
	self.start_time = t;
end

function RenZheJiJinModel:get_end_time()
	return self.end_time;
end

function RenZheJiJinModel:set_end_time( t )
	self.end_time = t;
end

function RenZheJiJinModel:get_remain_time()
	local remain_time = self.end_time - self.start_time - ( os.time() - self.start_time - MINI_DATE_TIME_BASE );

	if remain_time < 0 then
		remain_time = 0;
	end
	
	return remain_time;
end

-- 是否所有的奖励都已经领取完毕
function RenZheJiJinModel:is_all_award_complete()
	if jijin_kind == RenZheJiJinConfig.NONE_JIJIN then
		return false;
	end
	for i=1, #jijin_reward do
		if jijin_reward[i] ~= 1 then
			return false
		end
	end
	-- 还有基金可以买的情况下,基金活动仍然有效
	if jijin_can_buy == 1 or jijin_can_buy == 2 then
		return false
	end
	return true
end