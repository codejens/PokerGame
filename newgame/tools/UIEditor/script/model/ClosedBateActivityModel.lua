-- ClosedBateActivityModel.lua
-- created by fjh on 2013-7-23
-- 封測活動

ClosedBateActivityModel = {};

local _xiuxian_award_data = nil; -- 修仙奖励
local _level_award_data = nil;	--等级奖励
local _login_award_data = nil;	--登录奖励
local _period_award_data = nil;  --时段奖励
local _active_award_data = nil;  --活跃度奖励
local _online_award_data = nil;	--在线奖励
local _online_time = 0;		--在线时长
local _meitilibao_award_data = nil --媒体礼包

local _is_open = false;

function ClosedBateActivityModel:fini(  )
	
	_xiuxian_award_data = nil;	--修仙奖励
	_level_award_data = nil;	--等级奖励
	_login_award_data = nil;	--登录奖励
	_period_award_data = nil;  --时段奖励
	_active_award_data = nil;  --活跃度奖励
	_online_award_data = nil;	--在线奖励
	_online_time = 0;		--在线时长
	_meitilibao_award_data = nil --媒体礼包
end


-- 设置活动的开启状态
function ClosedBateActivityModel:set_activity_open_status( v )
	if v == 1 then
		_is_open = true;
		ClosedBateActivityModel:check_fc_activity(  )
	else
		_is_open = false;
	end	
end

function ClosedBateActivityModel:check_fc_activity(  )

	-- 封测活动
	_is_open = false;

	local win = UIManager:get_win_obj("activity_menus_panel");
	if win then

		if _is_open then
			win:insert_btn(6);
		else
			win:remove_btn(6);
		end
	end
end

-- 拉去所有领取状态
function ClosedBateActivityModel:req_all_activity_award_status(  )
	-- 请求修仙初成的奖励状态
	ClosedBateActivityModel:req_xiuxian_award_status(  )
	-- 领取等级奖励状态
	ClosedBateActivityModel:req_level_award( 0 )
	-- 领取登录奖励
	ClosedBateActivityModel:req_daily_login_award( 0 )
	-- 领取时段奖励
	ClosedBateActivityModel:req_online_period_award( 0 )
	-- 领取活跃度奖励
	ClosedBateActivityModel:req_activity_award( 0 )
	-- 领取在线时长奖励
	ClosedBateActivityModel:req_onlin_duration_award( 0 )
	ClosedBateActivityModel:check_meitilibao()
end


-- 请求修仙初成的奖励状态
function ClosedBateActivityModel:req_xiuxian_award_status(  )
	
	ClosedBateActivityCC:req_xiuxian_award_status(  )
end
function ClosedBateActivityModel:do_xiuxian_award_status( data )
	_xiuxian_award_data = data;
	local open_ser_win = UIManager:find_window("open_ser_win")
	if open_ser_win ~= nil then
		open_ser_win:force_update_scroll()
	end
end
function ClosedBateActivityModel:get_xiuxian_data(  )
	return _xiuxian_award_data;
end
-- 领取修仙初成奖励
function ClosedBateActivityModel:req_get_xiuxian_award( award_id )
	ClosedBateActivityCC:req_get_xiuxian_award( award_id )
end
-- 


-- 领取等级奖励
-- type = 1 ，表示查询领取状态，type = 2，表示领取奖励，index为领取第几个奖励
-- 以下协议雷同
function ClosedBateActivityModel:req_level_award( type, index)
	ClosedBateActivityCC:req_level_award( type, index )
end
--  
function ClosedBateActivityModel:do_level_award( data )
	_level_award_data = data;
	local open_ser_win = UIManager:find_window("open_ser_win")
	if open_ser_win ~= nil then
		open_ser_win:force_update_scroll()
	end
end
function ClosedBateActivityModel:get_level_award(  )
	return _level_award_data;
end
function ClosedBateActivityModel:req_get_level_award( index )
	ClosedBateActivityCC:req_level_award( 1, index );
end



-- 领取登录奖励
function ClosedBateActivityModel:req_daily_login_award( type, index )
	ClosedBateActivityCC:req_daily_login_award( type, index )
end
function ClosedBateActivityModel:do_daily_login_award( data )
	_login_award_data = data;
	local open_ser_win = UIManager:find_window("open_ser_win")
	if open_ser_win ~= nil then
		open_ser_win:force_update_scroll()
	end
end
function ClosedBateActivityModel:get_login_award(  )
	return _login_award_data;
end

function ClosedBateActivityModel:req_get_login_award( index )
	ClosedBateActivityCC:req_daily_login_award( 1, index )
end

-- 领取时段奖励
function ClosedBateActivityModel:req_online_period_award( type, index )
	ClosedBateActivityCC:req_online_period_award( type )
end
function ClosedBateActivityModel:do_online_period_award( data )
	_period_award_data = data;
	local open_ser_win = UIManager:find_window("open_ser_win")
	if open_ser_win ~= nil then
		open_ser_win:force_update_scroll()
	end
end
function ClosedBateActivityModel:get_online_period_award(  )
	return _period_award_data;
end
function ClosedBateActivityModel:req_get_online_period_award( index )
	ClosedBateActivityCC:req_online_period_award( 1, index )
end

-- 领取活跃度奖励
function ClosedBateActivityModel:req_activity_award( type, index)
	ClosedBateActivityCC:req_activity_award( type, index )
end
function ClosedBateActivityModel:do_activity_award( data )
	_active_award_data = data;
	local open_ser_win = UIManager:find_window("open_ser_win")
	if open_ser_win ~= nil then
		open_ser_win:force_update_scroll()
	end
end
function ClosedBateActivityModel:get_activity_award(  )
	return _active_award_data;
end

function ClosedBateActivityModel:req_get_activity_award( index )
	ClosedBateActivityCC:req_activity_award( 1, index )
end


-- 领取在线时长奖励
function ClosedBateActivityModel:req_onlin_duration_award( type, index )
	ClosedBateActivityCC:req_onlin_duration_award( type, index )

end
function ClosedBateActivityModel:do_online_duration_award( online_time, data )
	_online_time = online_time;
	_online_award_data = data;
	local open_ser_win = UIManager:find_window("open_ser_win")
	--local win = UIManager:find_visible_window("open_ser_win");
	if open_ser_win then
		open_ser_win:update_online_time_label(_online_time);
		open_ser_win:force_update_scroll()
	end 
end

function ClosedBateActivityModel:get_online_duration_award(  )
	return _online_award_data;
end
function ClosedBateActivityModel:get_online_time(  )
	return _online_time ;
end

function ClosedBateActivityModel:req_get_online_duration_award( index )
	ClosedBateActivityCC:req_onlin_duration_award( 1, index )
end

-- 激活cdkey
function ClosedBateActivityModel:req_active_cd_key( key )
	ClosedBateActivityCC:req_active_cd_key( key )
end





-- 获取对应子活动的领取状态
function ClosedBateActivityModel:get_award_data_by_index( act_index )
	if act_index == 1 then
		--第一個活動是修仙初成
		return _xiuxian_award_data;
	elseif act_index == 2 then 
		--第二個活動是平臺禮包
		return _meitilibao_award_data
	elseif act_index == 3 then
		--第三個活動是等級獎勵
		return _level_award_data;
	elseif act_index == 4 then
		--第四個活動登陸獎勵
		return _login_award_data;
	elseif act_index == 5 then
		--第五個活動是時段獎勵
		return _period_award_data;
	elseif act_index == 6 then
		-- 第六個活動是活躍度獎勵
		return _active_award_data;
	elseif act_index == 7 then
		-- 第七個活動是在線時長獎勵
		return _online_award_data;
	end
end

--

function ClosedBateActivityModel:check_meitilibao()
	ClosedBateActivityCC:req_meitilibao(0)
end

function ClosedBateActivityModel:get_meitilibao()
	ClosedBateActivityCC:req_meitilibao(1)
end

function ClosedBateActivityModel:update_meitilibao(state)
	_meitilibao_award_data = state
	local open_ser_win = UIManager:find_window("open_ser_win")
	if open_ser_win ~= nil then
		open_ser_win:force_update_scroll()
	end
end