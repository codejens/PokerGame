-- XianDaoHuiCC.lua
-- create by hcl on 2013-8-9
-- 仙道会系统 147

XianDaoHuiCC = {}

-- 请求我的自由赛信息 147,1
function XianDaoHuiCC:req_match_info()
	-- print("===========================请求我的自由赛信息===========================")
	local pack = NetManager:get_socket():alloc(147, 1);
	NetManager:get_socket():SendToSrv(pack);
end
-- 服务器下发自由赛信息
function XianDaoHuiCC:do_match_info( pack)
	-- print("===========================服务器下发自由赛信息===========================")
	local my_info_table = {};
	my_info_table.rank = pack:readInt();		--名次
	my_info_table.score = pack:readInt();		--积分
	my_info_table.match_num = pack:readInt();	--累计次数
	my_info_table.victory_num = pack:readInt(); --累计胜利
	XDHModel:set_my_xdh_info( my_info_table );
	-- 如果当前场景是在自由赛（在自由赛PK副本id=71也刷新 add by gzn）
	if SceneManager:get_cur_scene() == 18 or SceneManager:get_cur_fuben() == 71 then
		MiniTaskPanel:get_miniTaskPanel():update_tongji_panel(0,my_info_table);
	end
end

-- 获取自由赛排行榜 147,2
function XianDaoHuiCC:req_rank_top_info( page )
	local pack = NetManager:get_socket():alloc(147, 2);
	pack:writeInt(page);
	NetManager:get_socket():SendToSrv(pack);
end

-- 服务器下发自由赛排行榜
function XianDaoHuiCC:do_rank_top_info( pack )
	-- print("===========================服务器下发自由赛排行榜===========================")
	local zys_top_info = {};
	zys_top_info.total_page = pack:readInt();
	zys_top_info.curr_page = pack:readInt();
	zys_top_info.num = pack:readInt();
	zys_top_info.top_info = {};
	local num = zys_top_info.num;
	-- print(" zys_top_info.num", zys_top_info.num,zys_top_info.curr_page);
	if num > 0 then
		for i=1,num do
			zys_top_info.top_info[i] = XDHUserStruct(pack);
		end
		XDHModel:set_zys_top_info( zys_top_info.curr_page,zys_top_info.top_info );
	elseif num == 0 and zys_top_info.curr_page == 1 then
		XDHModel:set_zys_top_info( zys_top_info.curr_page,zys_top_info.top_info );
	end
end

-- 获取争霸赛信息 147,3
function XianDaoHuiCC:req_zbs_info(  )
	-- print("XianDaoHuiCC:req_zbs_info(  )")
	local pack = NetManager:get_socket():alloc(147, 3);
	NetManager:get_socket():SendToSrv(pack);
end

-- 
function XianDaoHuiCC:do_zbs_info( pack)
	-- print("===========================服务器下发争霸赛信息===========================")
	local zbs_info = {};
	zbs_info.turn = pack:readInt();	--第几轮
	zbs_info.lt_state = pack:readByte();	--擂台赛状态
	zbs_info.state_left_time = pack:readUInt(); -- 状态结束时间
	local str = Utils:format_time_to_time( zbs_info.state_left_time , ":")
	-- print(" 状态结束时间",zbs_info.state_left_time,str);
	local player_num = pack:readInt();	--玩家数据
	 -- print("玩家数据的数量....",player_num);
	zbs_info.xdhzbs_player_table = {};
	for i=1,player_num do
		zbs_info.xdhzbs_player_table[i] = XDHZBSUserStruct(pack)
	end
	local pk_state_info_num = pack:readInt();
	zbs_info.pk_state_info = {};
	for i=1,pk_state_info_num do
		zbs_info.pk_state_info[i] = {};
		zbs_info.pk_state_info[i].player_index = pack:readByte();		-- 胜利玩家序号
		zbs_info.pk_state_info[i].my_bet = pack:readByte();				-- 我下注的玩家序号0表示未下注
	end
	XDHModel:set_zbs_info( zbs_info )
end

-- 获取上届16强排名 147,4
function XianDaoHuiCC:req_last_zbs_16_info(  )
	local pack = NetManager:get_socket():alloc(147, 4);
	NetManager:get_socket():SendToSrv(pack);
end

function XianDaoHuiCC:do_last_zbs_16_info( pack )
	local info_num = pack:readInt();
	local last_zbs_16_info_table = {};
	for i=1,info_num do
		last_zbs_16_info_table[i] = XDHUserStruct(pack,XDHUserStruct.TYPE_16Q);
	end
	XDHModel:set_slq_info( last_zbs_16_info_table );
end
-- 获取历届仙王 147,5
function XianDaoHuiCC:req_xw_info()
	local pack = NetManager:get_socket():alloc(147, 5);
	NetManager:get_socket():SendToSrv(pack);
end

function XianDaoHuiCC:do_xw_info( pack )
	local info_num = pack:readInt();
	local xw_info_table = {};
	for i=1,info_num do
		xw_info_table[i] = XDHXWStruct(pack);
	end
	XDHModel:set_ljxw_info( xw_info_table )
end

-- 取消匹配 147,6
function XianDaoHuiCC:cancel_matching()
	local pack = NetManager:get_socket():alloc(147, 6);
	NetManager:get_socket():SendToSrv(pack);
end
-- 匹配开始 147,6
function XianDaoHuiCC:do_matching_start()
	-- print("XianDaoHuiCC:do_matching_start().................")
	PiPeiDialog:show()
end

-- pk开始 147,7
function XianDaoHuiCC:do_pk_start( pack )
	local pk_type = pack:readByte();
	UIManager:hide_window("pipei_dialog");
	--开始pk，显示开始pk
	local pk_time,count_down_time = 0,0;
	if pk_type == 0 then
		pk_time,count_down_time = XDHModel:get_zys_time()
	elseif pk_type == 1 then
		pk_time,count_down_time = XDHModel:get_zbs_time()
	end
	print("--------------PK开始-----------pk_time,count_down_time",pk_time,count_down_time);
	CountDownView:show( count_down_time,pk_time )
end

-- pk结束 147,8
function XianDaoHuiCC:do_pk_end( pack )

	-- 特殊处理
	-- 仙道会自由赛和争霸赛pk结束后，停止玩家当前的所有动作
	local player = EntityManager:get_player_avatar();
	if player then
		player:stop_all_action();

		-- 禁止继续挂机
		local ai_state = AIManager:get_comman_state(  );
		if ( ai_state == AIConfig.COMMAND_GUAJI or ai_state == AIConfig.COMMAND_FUBEN_GUAJI ) then
			AIManager:set_state(AIConfig.COMMAND_IDLE);
		end
	end

	local pk_type = pack:readByte();	--类型
	local result = pack:readByte();		--胜负
	-- 当前玩家信息
	local my_info = {};
	my_info.left_hp = pack:readInt();	--剩余血量百分比 * 10000
	my_info.score = pack:readInt();		--获得积分  
	my_info.total_score = pack:readInt();		--总积分  
	my_info.ry = pack:readInt();		--获得荣誉

	-- 对手玩家信息
	local other_player_info = {};
	other_player_info.camp = pack:readByte();		--阵营
	other_player_info.id = pack:readInt();			--id
	other_player_info.lv = pack:readInt();			--等级
	other_player_info.sex = pack:readInt();			--性别
	other_player_info.job = pack:readByte();		--职业
	other_player_info.fight_value = pack:readInt();	--战斗力
	other_player_info.left_hp = pack:readInt();		--剩余血量百分比*10000
	other_player_info.score = pack:readInt();		--获得积分
	other_player_info.total_score = pack:readInt();	--总积分
	other_player_info.ry = pack:readInt();	--总积分
	other_player_info.name = pack:readString();		--玩家名
	other_player_info.guild_name = pack:readString();--仙宗名
	print("other_player_info.ry,other_player_info.name",other_player_info.ry,other_player_info.name);
	-- 先删除倒计时
	UIManager:destroy_window("count_down_view");

	ResultDialog:show( {pk_type,result,my_info,other_player_info} );
end

-- 下注 147,9
function XianDaoHuiCC:req_xz( turn,player_index )
	local pack = NetManager:get_socket():alloc(147, 9);
	pack:writeInt(turn)
	pack:writeInt(player_index)
	NetManager:get_socket():SendToSrv(pack);
	print("开始下注.............",turn,player_index);
end

function XianDaoHuiCC:do_xz( pack )
	local turn = pack:readInt();
	local player_index = pack:readInt();
	GlobalFunc:create_screen_notic( "下注成功" ); -- [461]="下注成功"
	print("turn=",turn,"player_index=",player_index);
end

-- 擂台赛状态改变
function XianDaoHuiCC:do_lt_state_change( pack ) 
	local turn = pack:readInt();
	local state = pack:readByte();
	local time = pack:readUInt();

	XDHModel:set_xdh_lt_state( turn,state,time )
	print("------------------------------------------擂台赛状态改变----------------------------------------",turn,state,time);
	-- 更新争霸赛数据
	--XianDaoHuiCC:req_zbs_info(  )
	-- 
end

-- 送鲜花或丢鸡蛋 147,11
function XianDaoHuiCC:req_flower( _type,name )
	print("XianDaoHuiCC:req_flower( _type,name )",_type,name)
	local pack = NetManager:get_socket():alloc(147, 11);
	pack:writeInt(_type)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack);
end

-- 送鲜花或丢鸡蛋
function XianDaoHuiCC:do_flower( pack )

	local _type = pack:readInt();
	local is_result = pack:readInt();
	local handle = pack:readInt64();
	print("XianDaoHuiCC:do_flower",_type,is_result,handle)
	local win = UIManager:find_visible_window("zbs_action_win")
	if is_result == 0 and win then
		win:cd_time( _type+1,120 )
	end
end

-- 自由赛状态改变 147,12
function XianDaoHuiCC:do_zys_state_change( pack )
	local state = pack:readInt();		-- 0,未开始1,自由赛开始2,自由赛结束
	-- print("-----------------------自由赛状态改变------------------",state)
end

-- 领取荣誉奖励 147,13
function XianDaoHuiCC:req_ry_award( )
	local pack = NetManager:get_socket():alloc(147, 13);
	NetManager:get_socket():SendToSrv(pack);
end

function XianDaoHuiCC:do_ry_award( pack )
	local top = pack:readInt();		--排名
	local is_get = pack:readInt();		--是否领奖
	local money_award = pack:readInt();		--金钱奖励
	local ry_award = pack:readInt();		--荣誉值奖励
	if is_get == 0 then
		local win = UIManager:find_window("right_top_panel")
		if win then
			win:insert_btn(8)
		end
	end
end

-- 进入自由赛报名场景 147,14
function XianDaoHuiCC:req_enter_zys_scene()
	local pack = NetManager:get_socket():alloc(147, 14);
	NetManager:get_socket():SendToSrv(pack);
end

-- 进入争霸赛副本 147,15
function XianDaoHuiCC:req_enter_zbs_scene()
	local pack = NetManager:get_socket():alloc(147, 15);
	NetManager:get_socket():SendToSrv(pack);

	XianDaoHuiCC:req_zbs_info(  )
end

-- 下发身价排行榜 147,16
function XianDaoHuiCC:do_value_top( pack )
	local num = pack:readInt();
	local player_value_top_info = {};
	for i=1,num do
		player_value_top_info[i] = {};
		player_value_top_info[i].name = pack:readString();	--名字
		player_value_top_info[i].value = pack:readInt();	--身价
		player_value_top_info[i].flower = pack:readInt();	--鲜花
		player_value_top_info[i].egg = pack:readInt();		--鸡蛋
		player_value_top_info[i].camp = pack:readInt();		--阵营
	end
	-- print("下发身价排名榜.......")
	MiniTaskPanel:get_miniTaskPanel():update_tongji_panel(998,player_value_top_info);
end

-- 退出自由赛报名场景 147,17
function XianDaoHuiCC:req_exit_zys_scene( )
	local pack = NetManager:get_socket():alloc(147, 17);
	NetManager:get_socket():SendToSrv(pack);
	print("XianDaoHuiCC:req_exit_zys_scene( )")
end

-- 竞技场活动开启时间147,18 
function XianDaoHuiCC:do_jjc_start_time( pack )
	local time = pack:readUInt();
	-- print("竞技场活动开启时间...",time);
end

-- 仙道会数据刷新 147,19
function XianDaoHuiCC:do_xdh_info_refresh( pack )
	print("-----------------------仙道会数据刷新------------------")
end

-- 20 通知客户端剩余鲜花或鸡蛋次数
function XianDaoHuiCC:do_flower_num( pack )
	local flower_num = pack:readInt();
	local egg_num = pack:readInt();
	print("-----------------------通知客户端剩余鲜花或鸡蛋次数,------------------",flower_num,egg_num)
	XDHModel:set_xh_and_jd_count( flower_num,egg_num )
	local win = UIManager:find_visible_window("zbs_action_win")
	if win then
		win:update_flower_and_egg_count(flower_num,egg_num);
	end
end

-- 21广播玩家的身价
function XianDaoHuiCC:do_player_value( pack )
	local player_index = pack:readInt();	--第几个玩家
	local player_value = pack:readInt();	--玩家身价
	print("广播玩家的身价...............",player_index,player_value);
	XDHModel:update_player_value( player_index , player_value )
	local win = UIManager:find_visible_window("xiazhu_dialog");
	if ( win ) then
		win:update_money( player_index,player_value );
	end
end

-- 22 发送争霸赛pk结果
function XianDaoHuiCC:do_zbs_pk_result( pack )
	local turn = pack:readInt();	--第几轮
	local group = pack:readInt();	--第几组
	local index = pack:readInt();	--第几个
	-- 更新争霸赛数据
	print("发送争霸赛pk结果",turn,group,index);
	XDHModel:update_zbs_pk_result( turn,group,index )
end

-- 23 争霸赛场数变更
function XianDaoHuiCC:do_zbs_change( pack )
	local turn = pack:readInt();	--第几轮
	local index = pack:readInt();	--第几场

	XDHModel:set_xdh_state( turn,index )
	print("--------------------------争霸赛场数变更----------------------",turn,index);
	-- 因为16强的时候，服务器不会更新擂台状态，所以只能自己请求争霸赛信息
	XianDaoHuiCC:req_zbs_info(  )
end
