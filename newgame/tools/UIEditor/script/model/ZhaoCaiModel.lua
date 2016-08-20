-- ZhaoCaiModel.lua
-- created by fjh on 2013-1-10
-- 招财进宝信息模型 动态数据

-- super_class.ZhaoCaiModel()
ZhaoCaiModel = {}

local today_has_zc_num = 0; --今天已经招财的次数
local today_has_jb_num = 0; --今天已经进宝的次数

local zhao_cai_counts = { 2,4,6,8,10,12,14,16,18,20,
						 20,20,20,20,20,20,20,20,20,20,
						 30,30,30,30,30,30,30,30,30,30,
						 40,40,40,40,40,40,40,40,40,40,
						 50,50,50,50,50,50,50,50,50,50,
						 60,60,60,60,60,60,60,60,60,60,
						 70,70,70,70,70,70,70,70,70,70,
						 80,80,80,80,80,80,80,80,80,80,
						 80,80,80,80,80,80,80,80,80,80,
						 80,80,80,80,80,80,80,80,80,80,
};

-- 进宝的时候，当前次数和需要花费的元宝数量的映射,越界的一律当成20
local jinbao_count_map_to_cost = {
	2,4,6,8,10,12,14,16,18,20,
}

--vip等级对应每天可招财的次数，从vip0开始到vip10
local vip_to_zhaocaiNum_table = {2,3,5,7,9,30,40,50,60,70,100};
--vip等级对应每天可进宝的次数，从vip0开始到vip10
local vip_to_jinbaoNum_table = {2,3,5,7,9,30,40,50,60,70,100};

-- 招財次數对应的仙币数量,越界的一律当成28500
local zhaocai_count_map_to_money = {
	3500,4000,4500,5000,5500,
	6000,6500,7000,7500,8000,
}
-- 进宝次數对应的银两数量,越界的一律当成8000
local jinbao_count_map_to_money = {
	15000,16500,18000,19500,21000,
	22500,24000,25500,27000,28500,
}
-- added by aXIng on 2013-5-25
function ZhaoCaiModel:fini( ... )
	today_has_zc_num = 0
	today_has_jb_num = 0
end
--招财次数
function ZhaoCaiModel:set_has_zc_num( num )
	-- print("更新招财次数",num);
	today_has_zc_num = num;
end
function ZhaoCaiModel:get_has_zc_num(  )
	return today_has_zc_num ;
end
--进宝次数
function ZhaoCaiModel:set_has_jinbao_num( num )
	today_has_jb_num = num
end
function ZhaoCaiModel:get_has_jinbao_num(  )
	return today_has_jb_num ;
end

-- 根据当前招财了几次来取得需要消耗的元宝
function ZhaoCaiModel:get_cost_yb_by_zhaocai_times( times )
	return zhao_cai_counts[times];
end
-- 根据当前进宝了几次来取得需要消耗的元宝
function ZhaoCaiModel:get_cost_yb_by_jinbao_times( times )
	local length = #jinbao_count_map_to_cost;
	if times > length then
		return jinbao_count_map_to_cost[length];
	else
		return jinbao_count_map_to_cost[times];
	end
end
-- vip等级对应每天可招财次数
function ZhaoCaiModel:get_max_zhaocai_count(  )
	return vip_to_zhaocaiNum_table[VIPModel:get_vip_info().level+1];
end
-- vip等级对应每天可进宝次数
function ZhaoCaiModel:get_max_jinbao_count(  )
	return vip_to_jinbaoNum_table[VIPModel:get_vip_info().level+1];
end
-- 还可以招财多少次
function ZhaoCaiModel:get_can_zhaocai_count(  )
	 return ZhaoCaiModel:get_max_zhaocai_count() - today_has_zc_num ;
end
-- 还可以进宝多少次
function ZhaoCaiModel:get_can_jinbao_count( )
	return ZhaoCaiModel:get_max_jinbao_count() - today_has_jb_num 
end
function ZhaoCaiModel:get_current_gain1()
	local length = #zhaocai_count_map_to_money;
	if today_has_zc_num > length then
		return zhaocai_count_map_to_money[length];
	else
		return zhaocai_count_map_to_money[today_has_zc_num];
	end
end
function ZhaoCaiModel:get_current_gain2()
	local length = #zhaocai_count_map_to_money;
	if today_has_jb_num > length then
		return jinbao_count_map_to_money[length];
	else
		return jinbao_count_map_to_money[today_has_jb_num];
	end
end
-- 获取下一次招财可以得到的仙币收益
function ZhaoCaiModel:get_current_zhaocai_gain()
	local length = #zhaocai_count_map_to_money;
	if today_has_zc_num + 1 > length then
		return zhaocai_count_map_to_money[length];
	else
		return zhaocai_count_map_to_money[today_has_zc_num + 1];
	end
end

-- 获取下一次进宝可以得到的银两收益
function ZhaoCaiModel:get_current_jinbao_gain()
	local length = #jinbao_count_map_to_money;
	if today_has_jb_num + 1 > length then
		return jinbao_count_map_to_money[length];
	else
		return jinbao_count_map_to_money[today_has_jb_num + 1];
	end
end

-----  网络请求

-- 招财1次
function ZhaoCaiModel:req_zhaocai_1( need_yb_num, lave_count )
	if lave_count <= 0 then
		GlobalFunc:create_screen_notic( LangModelString[484] ); -- [484]="你今天的招财次数已用完，提升仙尊等级可以增加招财次数"
		return;
	end
	local player = EntityManager:get_player_avatar();
	if player.yuanbao < need_yb_num then
		-- GlobalFunc:create_screen_notic( "元宝不足" );
		local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
            --UIManager:show_window( "chong_zhi_win" )
    	end
    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
	else 
		MiscCC:request_zhaocai(2);
	end
end

-- 进宝一次
function ZhaoCaiModel:req_jinbao_1( need_yb_num, remain_count )
	if remain_count <= 0 then
		GlobalFunc:create_screen_notic( LangModelString[485] ); -- [484]="你今天的招财次数已用完，提升仙尊等级可以增加招财次数"
		return;
	end
	local player = EntityManager:get_player_avatar();
	if player.yuanbao < need_yb_num then
		local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
    	end
    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
	else
		MiscCC:request_zhaocai(1);
	end
end
function ZhaoCaiModel:do_zhaocai_success(  )
	local window = UIManager:find_window("zhaocai_win");
	if window ~= nil then
		window:update();
		window:do_zhaocai_callback(money);
	end
end
function ZhaoCaiModel:do_jinbao_success(money)
	local window = UIManager:find_window("zhaocai_win");
	if window ~= nil then
		window:update();
		window:do_jinbao_callback(money);
	end
end

