----PlantModel.lua
----HJH
----2013-8-8
----
sevenDayAwardModel = {}
------------------
local _cur_award_info = {}
local _sum_login_day = 0
local _remain_time = 0
local _cur_select_index = 1
local _reinit = false
local _first_show = false
local _add_icon = false
------------------
function sevenDayAwardModel:fini()
	_reinit = true
	_add_icon = false
	_is_add_btn = false
	_first_show = false
	_sum_login_day = 0
	_remain_time = 0
	_cur_select_index = 1
	_is_get_award = false
end
------------------
function sevenDayAwardModel:set_first_show(result)
	_first_show = result
end
------------------
function sevenDayAwardModel:get_reinit()
	return _reinit
end
------------------
function sevenDayAwardModel:reinit_panel()
	_reinit = false
	-- _sum_login_day = 0
	-- _remain_time = 0
	-- _cur_select_index = 1
	-- _is_get_award = false
	--ClosedBateActivityCC:check_seven_day_award_state(0)
end
------------------
function sevenDayAwardModel:get_sum_login_day()
	local temp_index = 0
	for i = 1, #_cur_award_info do
		-- print("_cur_award_info[i].state",_cur_award_info[i].state)
		if _cur_award_info[i].state == 1 or _cur_award_info[i].state == 2 then
			temp_index = temp_index + 1
		end
	end
	return temp_index
end
------------------
function sevenDayAwardModel:get_remain_time()
	return _remain_time
end
------------------
function sevenDayAwardModel:set_cur_select_index(index)
	_cur_select_index = index
end
------------------
function sevenDayAwardModel:get_cur_select_index()
	return _cur_select_index
end
------------------
function sevenDayAwardModel:get_item_info()
	local temp_index = sevenDayAwardModel:check_award_info()
	if ItemModel:check_bag_if_full() then
		GlobalFunc:create_screen_notic(Lang.award[5]) -- [5]="背包已满!"
	elseif _cur_award_info[temp_index].state == 1 then
		-- ClosedBateActivityCC:check_seven_day_award_state(1, temp_index)
		OtherActivitiesCC:check_seven_day_award_state(1, temp_index)
	else
		if temp_index ~= 7 then
			GlobalFunc:create_screen_notic(LangModelString[444]) -- [444]="亲！请明天再来！"
		else
			GlobalFunc:create_screen_notic(LangModelString[445]) -- [445]="礼包已领取完"
		end
	end
end

function sevenDayAwardModel:get_award_state( index )
	if not _cur_award_info or not _cur_award_info[index] then return 2 end
	return _cur_award_info[index].state
end

------------------
function sevenDayAwardModel:get_can_get_index()
	local temp_index = 0
	for i = 1, #_cur_award_info do
		-- print("_cur_award_info[i].state",_cur_award_info[i].state)
		if _cur_award_info[i].state == 2 then
			temp_index = _cur_award_info[i].level
		end
	end
	return temp_index
end
------------------
function sevenDayAwardModel:check_can_get_award()
	for i = 1, #_cur_award_info do
		if ( _cur_award_info[i].state == 1 or _cur_award_info[i].state == 0 ) and i < 8 then
			return true
		end
	end
	return false
end
------------------
function sevenDayAwardModel:check_award_info()
	local can_get = nil
	local unget = nil
	for i = 1, #_cur_award_info do
		if _cur_award_info[i].state == 1 and can_get == nil then
			can_get = _cur_award_info[i].level
		end
		if _cur_award_info[i].state == 0 and unget == nil then
			unget = _cur_award_info[i].level
		end
	end
	if can_get ~= nil then
		return can_get
	elseif unget ~= nil then
		return unget
	else
		return _cur_award_info[#_cur_award_info].level
	end
end
------------------
function sevenDayAwardModel:qian_dao_award(info)
	-- if _add_icon == true then
	-- 	print("sevenDayAwardModel:qian_dao_award info",info)
	-- 	if info >= 2 then
	-- 		MiscCC:req_accept_award( 1 );
	-- 	end
	-- 	if info >= 5 then
	-- 		MiscCC:req_accept_award( 2 );
	-- 	end
	-- end
end
------------------
function sevenDayAwardModel:update_info(remain_time, info)
	------------------
	_remain_time = os.time() + remain_time
	_cur_award_info = info
	--sevenDayAwardModel:get_sum_login_day
	_sum_login_day = sevenDayAwardModel:get_sum_login_day()-- 7 - math.floor( remain_time / 86400 )
	-- if _sum_login_day > 7 then
	-- 	_sum_login_day = 7
	-- end
	
	print("_sum_login_day",_sum_login_day)
	_cur_select_index = sevenDayAwardModel:check_award_info()
	--在线时长领奖信息
	local award_index, count_time, remain_num = OnlineAwardModel:get_data()
	if _first_show == false then
		--UIManager:show_window("seven_day_award")
	end
	-- local seven_day_award = UIManager:find_window("seven_day_award")
	local award_win = UIManager:find_window("award_win")
	if award_win then
		if award_win.all_page_t[2] then
			seven_day_award = award_win.all_page_t[2] 
		end

	    if seven_day_award ~= nil then
		   seven_day_award:update_fun(1)
	    end

	end

	print("_add_icon",_add_icon)
	if _add_icon == false and (remain_time > 0 or remain_num > 0)then
		_add_icon = true
		local right_top_panel = UIManager:find_window("right_top_panel")
		if right_top_panel ~= nil then
			right_top_panel:insert_btn(5)
		end
	end

	if ( sevenDayAwardModel:check_can_get_award() == false and (remain_time <= 0 and remain_num <= 0)) and _add_icon == true then
		local right_top_panel = UIManager:find_window("right_top_panel")
		if right_top_panel ~= nil then
			right_top_panel:remove_btn(5)
		end
	end
end
------------------
function sevenDayAwardModel:sum_time_request()
	local cur_time = os.time()
	local temp_time =  7 - math.floor( ( _remain_time - cur_time ) / 86400 )
	if temp_time - _sum_login_day >= 1 then
		ClosedBateActivityCC:check_seven_day_award_state(0, 0)
	end
end
--------------------
function sevenDayAwardModel:auto_qian_dao()
	-- print("QianDaoModel:is_today_qd()",QianDaoModel:is_today_qd(),_remain_time)
	if QianDaoModel:get_request_qian_dao() == false and _remain_time - os.time() > 0 and QianDaoModel:is_today_qd() == false then
		-- print("run auto_qian_dao")
		MiscCC:req_qd()
	end
end
