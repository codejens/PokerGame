-----------------------------------------------
-----------------------------------------------
--------------HJH
--------------2013-5-20
SCLBModel = {}

-- 二进制表示
-- can_get_award_state 可领取的标志位
-- get_award_state 是否已领取的标志位
local can_get_award_state = 0;
local get_award_state = 0;
-----------------------------------------------
-- added by aXIng on 2013-5-25
function SCLBModel:fini( ... )
	can_get_award_state = 0;
	get_award_state = 0;
end

function SCLBModel:get_award_info()
	return can_get_award_state,get_award_state;
end

function SCLBModel:set_award_info( _can_get_award_state, _get_award_state )
	-- _can_get_award_state : 0表示什么都不可以领，1表示可以领首充礼包，7表示可以领3w礼包（当然，如果达到7，前面的1-6礼包都可以领的）
	can_get_award_state = _can_get_award_state
	get_award_state     = _get_award_state

	local win = UIManager:find_visible_window("sclb_win")
	if win then
		win:update_state();
	end
end

-----------------------------------------------
-- function SCLBModel:set_award_state( get_state )
-- 	--local state = ZXLuaUtils:lshift(get_state, 31)
-- 	--state = ZXLuaUtils:rshift(state, 31)
-- 	-- print("sclb state",math.abs(state))
-- 	--state = math.abs(state)
-- 	local state = Utils:get_bit_by_position( get_state, 1 );

-- 	-- is_get_award为true的时候，表示首冲奖励还没有被领取，玩家可以通过点击首冲按钮，打开首冲界面
-- 	local is_get_award;
-- 	-- 没有领取首冲奖励
-- 	if state == 0 then
-- 		is_get_award = true
-- 	else
-- 		is_get_award = false
-- 	end
-- 	local win = UIManager:find_visible_window("right_top_panel");
-- 	if win then
-- 		win:set_yunyinhuodong_btn_visible( is_get_award );
-- 	end
-- end

function SCLBModel:exit_btn_function()
	UIManager:hide_window("sclb_win")
end
-----------------------------------------------
-----------------------------------------------
function SCLBModel:send_money_btn_function()
	Analyze:parse_click_main_menu_info(202)
	UIManager:hide_window("sclb_win")
	GlobalFunc:chong_zhi_enter_fun()
	--UIManager:show_window("chong_zhi_win")
end

-- 由于首充界面是否可见,还要依赖玩家是否已领取首充奖励的2阶翅膀,所以此处写了一个
-- 新的判断首充按钮是否可见的方法,但是由于首充消息与式神消失,是两条独立的消息,即有分
-- 先后的到达客户端(蛋碎)
function SCLBModel:set_sclb_btn_visible()
	-- 首充按钮是否可见
	local is_visible = true
	-- 首冲按钮是否需要添加特效
	local need_effect = true
	if can_get_award_state ~= 0 then
		need_effect = false
		for i = 1, 3 do
			local can_get_record = Utils:get_bit_by_position( can_get_award_state, i )
			local get_record = Utils:get_bit_by_position( get_award_state, i )
			if can_get_record == 1 and get_record == 0 then
				need_effect =  true
				break
			end
		end
	end
	-- 是否已领取首充奖励
	if get_award_state == 7 then
		is_visible = false
		-- 首充奖励中的翅膀奖励是否已领取
		-- local free_get, shouchong_get = WingModel:getGotWingStatus()
		-- if not shouchong_get then
		-- 	is_visible = true
		-- end
	end

	-- 设置主界面首充按钮的可见性
	local win = UIManager:find_window("right_top_panel");
	if win then
		win:set_yunyinhuodong_btn_visible( is_visible );
		print('need_effect:', need_effect)
		win:shanshuo_btn(1, need_effect)
	end
end