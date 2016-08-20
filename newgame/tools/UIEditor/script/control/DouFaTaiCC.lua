-- DouFaTaiCC.lua
-- create by hcl on 2013-1-14
-- 斗法台 39

-- super_class.DouFaTaiCC()

DouFaTaiCC = {}

-- 1获取斗法台信息
function DouFaTaiCC:req_get_info()
	local pack = NetManager:get_socket():alloc(39,1);
	NetManager:get_socket():SendToSrv(pack);
end

-- 1获取斗法台信息
function DouFaTaiCC:do_get_info(pack)
	--print("DouFaTaiCC:得到斗法台信息");
	-- 对手个数
	-- require "struct/DouFaTaiStruct"
	-- require "model/DFTModel"
	local num = pack:readInt(); 
	--print("DouFaTaiCC:可挑战的对手数量 = " .. num);
	local dft_table = {};
	for i=1,num do
		-- 排序
		local dft_struct = DouFaTaiStruct(pack);
		if ( i == 1 ) then 
			dft_table[1] = dft_struct;
		else
			if ( dft_table[ 1 ].top < dft_struct.top ) then
				table.insert(dft_table,1,dft_struct);
			else
				table.insert(dft_table,dft_struct);
			end
		end
	end
	-- 把数据放到model中
	--require "model/DFTModel"
	DFTModel:set_dft_info(dft_table);
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then
		win:update(2);
	end
end

-- 2 开始pk
function DouFaTaiCC:req_start_pk( enemy_id )
	local pack = NetManager:get_socket():alloc(39,2);
	pack:writeInt(enemy_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 2 到计时结束，开始pk
function DouFaTaiCC:do_start_pk( pack )
	-- 斗法台开始pk后，自动帮玩家挂机
	AIManager:guaji()
end

-- 3 消除cd时间
function DouFaTaiCC:req_clear_cd()
	local pack = NetManager:get_socket():alloc(39,3);
	NetManager:get_socket():SendToSrv(pack);
end

-- 3 更新cd时间
function DouFaTaiCC:do_clear_cd( pack )
	local cd = pack:readInt();
--	print("斗法台，更新cd时间...",cd);
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then 
		win:update_cd_time( cd )
	end
	
end

-- 4 增加挑战次数
function DouFaTaiCC:req_add_fight_num()
	local pack = NetManager:get_socket():alloc(39,4);
	NetManager:get_socket():SendToSrv(pack);
end

-- 4 增加挑战次数结果
function DouFaTaiCC:do_add_fight_num( pack )
	-- print("DouFaTaiCC:do_add_fight_num...................................");
	local num = pack:readInt();		--剩余挑战次数
	local money_need = pack:readInt()	--下次购买需要的元宝数
--	require "UI/doufatai/DouFaTaiWin"
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then 
		win:update(5,{num,money_need});
	end
	DFTModel:set_dft_tz_count( num )
end

-- 5 查看排行榜
function DouFaTaiCC:req_top_info( page_num )
	local pack = NetManager:get_socket():alloc(39,5);
	pack:writeInt( page_num );
	NetManager:get_socket():SendToSrv(pack);
end

-- 5 返回排行榜
function DouFaTaiCC:do_top_info( pack )
	local total_pages = pack:readInt();		--总共多少页
	local page_index = pack:readInt()	--第几页
	local item_num = pack:readInt()	--这页多少项
	local table = DFTModel:get_dft_top_info();
	local len = #table;
	--print("total_pages = " .. total_pages .. " page_index = " .. page_index.. " item_num="..item_num);
--	require "struct/DFTTopStruct"
	for i=1,item_num do
		table[i + len] = DFTTopStruct(pack);
	end
	DFTModel:set_dft_top_info(table);
	--print("DouFaTaiCC.len = " .. #table);
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then 
		win:update(3);
	end
end

-- 6 查看玩家战绩记录
function DouFaTaiCC:req_get_zj_info( )
	local pack = NetManager:get_socket():alloc(39,6);
	NetManager:get_socket():SendToSrv(pack);
end

-- 6 查看玩家战绩记录结果
function DouFaTaiCC:do_get_zj_info( pack )
--	print("do_get_zj_info................................................")
	local item_num = pack:readInt()	--这页多少项
	-- print("服务器下发",item_num,"条玩家挑战历史数据")
	local table = {}
	--require "struct/DFTZJStruct"
	for i=1,item_num do
		table[i] = DFTZJStruct(pack);
		-- print("名字为：",table[i].enemy_name)
	end
	DFTModel:set_dft_ZJ_info(table);
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then 
		win:update(4);
	end
end

-- 7 领取排行奖励信息
function DouFaTaiCC:req_get_reward_info( )
	local pack = NetManager:get_socket():alloc(39,7);
	NetManager:get_socket():SendToSrv(pack);
end

-- 7 取得领取排行奖励信息结果
function DouFaTaiCC:do_get_reward_info( pack )
--	print("DouFaTaiCC:do_get_reward_info")
	local top = pack:readInt();
	local is_get = pack:readByte();
	local money  = pack:readInt();
	local sw 	 = pack:readInt();
	local time   = pack:readInt();
	--require "UI/doufatai/DouFaTaiWin"
	-- require "model/PetModel"
	-- local pet_name = PetModel:get_current_pet_name()
	-- DouFaTaiWin:update(1,{top,10000,pet_name,money,sw,time});
	local table = {top,is_get,money,sw,time};
--	require "model/DFTModel"
	DFTModel:set_reward_info( table )
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then
		-- 更新斗法台 左上角信息
		win:update(1);
	end
	--print("is_get.............................................. = ",is_get)
	if ( is_get == 0 ) then 
		-- 判断是否领取，如果未领取就显示按钮
		local win = UIManager:find_window("right_top_panel");
		if ( win ) then
			win:show_dft_award_btn();
		end
	end
end

-- 9 添加战绩记录
function DouFaTaiCC:do_add_zj(pack)
	
--	require "model/DFTModel"
	local dftzj_struct = DFTZJStruct(pack);
	DFTModel:add_dft_ZJ_info( dftzj_struct );
	local win = UIManager:find_visible_window("doufatai_win");
	if ( win ) then 
		win:update(4);
	end

--	print("添加战绩记录",dftzj_struct.result);
	-- 如果排名被抢了，要在主界面飘个字
	if ( dftzj_struct.type ==1 and dftzj_struct.result == 0 ) then
		local function cb_fun()
			local time_str = "#cfff000"..Utils:get_custom_format_time( LangGameString[431] ,dftzj_struct.time ).."#c66ff66"; -- [431]="%Y年%m月%d日 %H时%M分"
			NormalDialog:show( time_str .. dftzj_struct.str ,nil,2);
		end
		MiniBtnWin:show( 3 , cb_fun  );
	end
	
end

-- 10 挑战结果
function DouFaTaiCC:do_fight_result(pack)
	local result = pack:readInt();
	local money  = pack:readInt();
	local sw 	 = pack:readInt();

	DouFaTaiResult:show( result ,money,sw ); 
end

-- 11 捉捕结果
function DouFaTaiCC:do_catch_result(pack)
	local result = pack:readInt();
	DouFaTaiResult:show( result ); 
end

