-- LoginAwardModel.lua
-- create by hcl on 2013-10-29
-- 登录福利model

LoginAwardModel = {}

-- 登录福利数据
local login_award_item_tab = {};
local fp_count = 0;
local _award_state = -1;

-- 幸运猜猜数据
local guest_count = 0;
local guest_item_tab = {}

function LoginAwardModel:fini(  )
	-- 登录福利数据
	login_award_item_tab = {};
	fp_count = 0;
	_award_state = -1;

	-- 幸运猜猜数据
	guest_count = 0;
	guest_item_tab = {}	
end

function LoginAwardModel:set_login_award_item_tab( item_tab,is_not_need_update )
	login_award_item_tab = item_tab;
	if ( is_not_need_update == nil ) then
		local win = UIManager:find_visible_window("login_award_win");
		if win == nil then
			win = UIManager:show_window("login_award_win");
		end
		local is_fp = false;
		for i=1,9 do
			if login_award_item_tab[i].type == 1 then
				is_fp = true;
				break;
			end
		end
		win:update_all( is_fp );
	end
end

function LoginAwardModel:get_login_award_item_tab()
	return login_award_item_tab;
end

function LoginAwardModel:set_award_state( award_state )
	_award_state = award_state;
end

function LoginAwardModel:set_fp_count( count,day,week_day ,is_fp)
	fp_count = count;
	if fp_count == 0 and _award_state == 2 or _award_state == 0 then
		local win = UIManager:find_window( "right_top_panel" )
		if win then
			win:remove_btn(6)
		end
	end
	local win = UIManager:find_visible_window("login_award_win");
	if win == nil then
		win = UIManager:show_window("login_award_win");
	end
	win:update_fp_count( count,day,week_day ,is_fp);
end

function LoginAwardModel:get_fp_count()
	return fp_count;
end

function LoginAwardModel:set_guest_count( count )
	guest_count = count;
	if guest_count == 0 then
		local win = UIManager:find_window( "right_top_panel" )
		if win then
			win:remove_btn(7)
		end
	end
	local win = UIManager:find_visible_window("luck_guest_win");
	if win == nil then
		win = UIManager:show_window("luck_guest_win");
	end
	win:update_guest_count( guest_count );
end

function LoginAwardModel:get_guest_count()
	return guest_count;
end

function LoginAwardModel:set_guest_item_tab( item_tab )
	-- print("LoginAwardModel:set_guest_item_tab( item_tab )")
	guest_item_tab = item_tab;
	local win = UIManager:find_visible_window("luck_guest_win");
	if win == nil then
		win = UIManager:show_window("luck_guest_win");
	end
	win:update_all( guest_item_tab );
end

function LoginAwardModel:get_guest_item_tab()
	return guest_item_tab;
end