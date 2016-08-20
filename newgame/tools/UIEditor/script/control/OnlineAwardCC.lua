-- OnlineAwardCC.lua
-- created by lyl on 2013-3-5
-- 在线奖励系统
-- super_class.OnlineAwardCC()
OnlineAwardCC = {}

-- c->s 138,6  请求连续登录领奖列表
function OnlineAwardCC:request_login_award_list()
	local pack = NetManager:get_socket():alloc( 138, 6 )
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 138,6 服务器下发连续登录领奖列表
function OnlineAwardCC:do_result_login_award_list( pack )
	local item_list_count = pack:readInt()
	local award_list = {}                     -- 普通玩家物品
	require "struct/LoginAwardStruct"
	for i = 1, item_list_count do 
        award_list[i] = LoginAwardStruct(pack)
	end
	local vip_item_count = pack:readInt()
	local award_list_vip = {}                 -- vip玩家物品
	for i = 1, vip_item_count do 
        award_list_vip[i] = LoginAwardStruct(pack)
	end
	local continuity_days = pack:readInt()
    
    --下发之后普通玩家和VIP玩家的奖励列表
    require "model/WelfareModel"
    WelfareModel:set_login_award_list( award_list, continuity_days )
    WelfareModel:set_login_award_list_vip( award_list_vip )

end

-- c->s 138,7  请求领取连续登录奖品 （非vip）  参数：第几个，从1开始
function OnlineAwardCC:rquest_get_login_award_item( index )
	local pack = NetManager:get_socket():alloc( 138, 7 )
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,8  请求领取连续登录奖品 （vip）    参数：第几个，从1开始
function OnlineAwardCC:rquest_get_login_award_vip_item( index )
	local pack = NetManager:get_socket():alloc( 138, 8 )
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

--  c->s 138,10  查询有多少离线经验
function OnlineAwardCC:request_off_line_exp(  )
	local pack = NetManager:get_socket():alloc( 138, 10 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,10 下发离线经验
function OnlineAwardCC:do_result_off_line_exp( pack )
	local off_line_hours = pack:readUInt()
    local off_line_exp   = pack:readUInt()
    local half_exp       = pack:readUInt()
    local one_exp        = pack:readUInt()
    local one_point_five_exp       = pack:readUInt()
    local two_exp        = pack:readUInt()
    
    require "model/WelfareModel"
    -- print("OnlineAwardCC:do_result_off_line_exp( pack )",off_line_hours,off_line_exp)
    WelfareModel:set_off_line_exp_date( off_line_hours, off_line_exp, half_exp, one_exp, one_point_five_exp, two_exp )
end

--  c->s 138,11  请求获取离线经验  rate 1: 0.5倍    2: 1倍     3: 1.5倍    4: 2倍   hours 小时数
function OnlineAwardCC:request_get_off_line_exp( rate, hours, money_type )
	local pack = NetManager:get_socket():alloc( 138, 11 )
	pack:writeInt( rate )
	pack:writeInt( hours )
	pack:writeByte( money_type )
	NetManager:get_socket():SendToSrv(pack)

	-- print("OnlineAwardCC:request_get_off_line_exp",rate,hours)
end

-- s->c 138,12 连续登录显示当前物品
function OnlineAwardCC:do_result_login_current_item( pack )
	local continue_days         = pack:readInt()
	local award_state_count     = pack:readInt()
    local award_state_list      = {}                          -- 领奖状态 0表示不可领取，1表示未领取，2表示已领取
    for i = 1, award_state_count do
        award_state_list[i]     = pack:readByte()
    end
    local vip_award_state_count = pack:readInt()
    local vip_award_state_list  = {}                          -- vip 领奖状态 0表示不可领取，1表示未领取，2表示已领取
    for i = 1, award_state_count do
        vip_award_state_list[i]     = pack:readByte()
    end

    require "model/WelfareModel"
    --added  by xiehande
    WelfareModel:set_award_get_state_list( award_state_list,vip_award_state_list ) 
    if WelfareModel:get_longin_award_had_not_get() > 0 then
    	BenefitModel:show_benefit_miniBtn()
    end
end

--  c->s 138,12  请求连续登录当前物品 的领奖情况
function OnlineAwardCC:request_login_current_item(  )
	local pack = NetManager:get_socket():alloc( 138, 12 )
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,13  领取vip用户每天登录奖励 
function OnlineAwardCC:get_vip_day_login_award(  )
	local pack = NetManager:get_socket():alloc( 138, 13 )
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,14  查询是否已经领取vip登录奖励
function OnlineAwardCC:query_if_had_get_vip_award(  )
	local pack = NetManager:get_socket():alloc( 138, 14 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,14 返回是否已经领取vip用户登录奖励
function OnlineAwardCC:do_result_if_had_get_vip_award( pack )
	local result = pack:readInt()           -- 1：已经领取    0：未领取   -1：不是VIP用户
	require "model/WelfareModel"
	WelfareModel:set_if_had_get_vip_award( result )
end

-- s->c 138,16 服务器下发充值礼包的领取情况和剩余时间（游戏启动时会自动下发）
function OnlineAwardCC:do_recharge_award_date( pack )
	-- print("s->c 138,16 服务器下发充值礼包的领取情况和剩余时间（游戏启动时会自动下发）")
	local max_award_level = pack:readInt()        -- 0表示什么都不可以领，1表示可以领首充礼包，7表示可以领3w礼包（当然，如果达到7，前面的1-6礼包都可以领的）
	local get_state       = pack:readInt()        -- 对应的位为1表示已领取，第一个礼包从第0位开始，第一个礼包是首充礼包
	local remain_time     = pack:readInt()        -- 活动剩余时间
	-- print("max_award_level",max_award_level)
	---check sclb state
	-- print("get_state", get_state)

    require "model/WelfareModel"
	WelfareModel:set_recharge_award_date( max_award_level, get_state, remain_time )
	-- 首冲礼包领取状态
	local get_award_state = pack:readInt();
	-- 首冲礼包是否可领
	local can_get_award_state = pack:readInt();
	-- print('can_get_award_state, get_award_state:', can_get_award_state,get_award_state )
	SCLBModel:set_award_info( can_get_award_state, get_award_state )
	SCLBModel:set_sclb_btn_visible()
end

-- c->s 138,16  领取充值礼包  从0开始
function OnlineAwardCC:get_recharge_award( index ,sub_item_index)
	-- print("138,16  领取充值礼包  从0开始  OnlineAwardCC:get_recharge_award( index )   ", index)
	local pack = NetManager:get_socket():alloc( 138, 16 )
	pack:writeInt( index )
	-- 首充礼包需要这个字段
	if sub_item_index then
		pack:writeInt(sub_item_index);
	end
	NetManager:get_socket():SendToSrv(pack)
end


-- s->c 138,18 服务器下发排行榜活动的大概数据
function OnlineAwardCC:do_rank_list_award_data( pack )
	--距离开服7天22时剩余的时间，0表示超过了
	local seven_day_time = pack:readInt();
	--距离开服10天剩余的时间，0表示超过了
	local ten_day_time = pack:readInt();

	--用位表示，第0位表示战力排行榜是否上榜，1表示上榜，0表示否
	local is_has_award = pack:readInt();
	--int表示，共32位，0表示排行榜1（战力）的领取情况，1表示已领取
	local award_status = pack:readInt();

	OpenSerModel:do_rank_list_award_data( ten_day_time, seven_day_time, is_has_award, award_status )


end

-- c->s 138,19 向服务器请求具体的排行榜的数据
function OnlineAwardCC:req_someone_rank_data( rank_id )
	
	local pack = NetManager:get_socket():alloc( 138, 19 );
	pack:writeInt( rank_id );
	NetManager:get_socket():SendToSrv(pack);

end

-- s->c 138,19 下发具体的排行榜数据
function OnlineAwardCC:do_someone_rank_data( pack )
	--用位表示，第0位表示战力排行榜是否上榜，1表示上榜，0表示否
	local is_has_award = pack:readInt();
	--
	local rank_id = pack:readInt();
	local count = pack:readInt();
	
	local rank_dict = {};
	for i=1,count do
		local award_item_id = pack:readInt();
		local _player_id = pack:readInt();
		local _player_name = pack:readString();

		rank_dict[i] = { item_id = award_item_id, player_id = _player_id, player_name = _player_name};
	end

	OpenSerModel:do_someone_rank_data( is_has_award, rank_id, rank_dict );

end


-- c->s 138,20 领取排行榜奖励
function OnlineAwardCC:req_get_rank_award( rank_id )
	local pack = NetManager:get_socket():alloc( 138, 20 );
	pack:writeInt( rank_id );
	NetManager:get_socket():SendToSrv(pack);


end
-- s->c 138,20  排行榜领奖之后的回调
function OnlineAwardCC:do_get_rank_award( pack )
	--一个int表示，共32位，0表示排行榜1（战力）的领取情况，1表示已领取
	local award_status = pack:readInt();
	OpenSerModel:do_get_rank_award( award_status )
end


-- c->s 138,22 请求仙宗的奖励信息
function OnlineAwardCC:req_guild_award_info(  )
	-- print("请求仙宗的奖励信息")
	local pack = NetManager:get_socket():alloc( 138, 22 );
	NetManager:get_socket():SendToSrv(pack);

end

-- s->c 138,22 下发仙宗的奖励信息
function OnlineAwardCC:do_guild_award_info( pack )
	--int型，第一位为1时表示有会员奖励，第二位为1时表示有宗主奖励,
	--第三位为1表示已经领过会员奖励，第4位为1表示已经领过宗主奖励

	local is_has_award = pack:readInt();

	-- 当前你的仙宗等级
	local guild_lv = pack:readByte();

	OpenSerModel:do_guild_award_data( is_has_award, guild_lv );
	-- print("下发仙宗的奖励信息", guild_lv );

end

-- c->s 138,23  领取仙宗奖励
function OnlineAwardCC:req_get_guild_award( award_type )
	--0表示成员奖，1表示宗主奖
	local pack = NetManager:get_socket():alloc( 138, 23 );
	pack:writeInt(award_type);
	NetManager:get_socket():SendToSrv(pack);
end

-- c->s 138,24 请求套装奖励信息
function OnlineAwardCC:req_suit_award_info(  )
	-- print("请求套装奖励信息")
	local pack = NetManager:get_socket():alloc( 138, 24 );
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 138,24 下发套装奖励信息
function OnlineAwardCC:do_suit_award_info( pack )
	-- print("下发套装奖励信息");
	--3个位分别标记3种奖励，如000是指没有奖励，第一位表示有4套装收集奖励，111表示有3个奖励
	local is_has_award = pack:readInt();

	local award_status = pack:readInt();

	OpenSerModel:do_suit_award_data( is_has_award, award_status );

end

-- c->s 138,25 领取套装奖励
function OnlineAwardCC:req_get_suit_award( index )
	--index 0-2，分别表示3种奖励
	local pack = NetManager:get_socket():alloc( 138, 25 );
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack);
end

-- c->s 138,26 请求渡劫奖励信息
function OnlineAwardCC:req_dujie_award_info(  )
	
	local pack = NetManager:get_socket():alloc( 138, 26 );
	NetManager:get_socket():SendToSrv(pack);

end

-- s->c 138,26 下发渡劫奖励信息
function OnlineAwardCC:do_dujie_award_info( pack )
	-- print("下发渡劫奖励信息");
	--3个位分别标记3种奖励，如000是指没有奖励，第一位表示有4套装收集奖励，111表示有3个奖励
	local is_has_award = pack:readInt();
	local award_status = pack:readInt();

	OpenSerModel:do_dujie_award_data( is_has_award, award_status  );

end
-- c->s 138,27
function OnlineAwardCC:req_get_dujie_award( index )
	
	--index 0-2，分别表示3种奖励
	local pack = NetManager:get_socket():alloc( 138, 27 );
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack);
end

-- add tjxs

-- (万圣节&开服) 每天在线奖励 ---------
-- s->c 138, 32
function OnlineAwardCC:do_award_state( pack )
	print( "s->c 138, 32  OnlineAwardCC:do_award_state" )
	local state = pack:readInt()
	print( "----state:", state )
end

-- s->c 138, 33
function OnlineAwardCC:do_award_info( pack )
	print("s->c 138, 33  OnlineAwardCC:do_award_info")
	local award_index = pack:readChar()
	local count_time = pack:readInt()
	local remain_num = pack:readInt()
	OnlineAwardModel:set_data( award_index, count_time, remain_num )
end

-- c->s 138, 34
function OnlineAwardCC:request_get_award_oneday()
	print("c->s 138, 34  OnlineAwardCC:request_get_award_oneday")
	local pack = NetManager:get_socket():alloc( 138, 34 );
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 138, 34
function OnlineAwardCC:do_get_award_oneday( pack )
	print("s->c 138, 34  OnlineAwardCC:do_get_award_oneday")
	local num = pack:readInt()
	local award_table = {}
	for i=1, num do
		award_table[i].award_type = pack:readInt()
		award_table[i].item_type = pack:readInt()
		award_table[i].item_num = pack:readInt()
		print("----award_table:", award_table[i].award_type, award_table[i].item_type, award_table[i].item_num )
	end
end

-- s->c 138-37
function OnlineAwardCC:server_blue_qqvip_info(pack)
	local info = pack:readInt()
	local open_result = pack:readInt()
	QQVIPModel:update_qqvip_award_info( info, open_result )
end


-- c->s 138-37
function OnlineAwardCC:client_get_blue_award(index, level)
	local pack = NetManager:get_socket():alloc( 138, 37 )
	pack:writeInt(index)
	if level ~= nil then
		pack:writeInt(level)
	end
	NetManager:get_socket():SendToSrv(pack)
end
--密友事件
--c->s,138,38
function OnlineAwardCC:request_miyou( )
	print(" req 密友事件");
	local pack = NetManager:get_socket():alloc(138, 38);
	NetManager:get_socket():SendToSrv(pack);

end

--密友事件回调
-- s->c 138,38
function OnlineAwardCC:do_miyou( pack )
	MiyouCC:do_miyou_gift_List( pack )
end

--密友事件  赠送按钮
--c->s,138,39
function OnlineAwardCC:request_miyou_sendGift(index ,roleid)
	local pack = NetManager:get_socket():alloc(138, 39);
	pack:writeInt(index)
	pack:writeInt(roleid)
	NetManager:get_socket():SendToSrv(pack);

end

--密友事件回调  赠送
-- s->c 138,39
function OnlineAwardCC:do_miyou_sendGift( pack )
	MiyouCC:do_miyou_sendGift_Result( pack );
end


--密友事件  领取按钮
--c->s,138,40
function OnlineAwardCC:request_miyou_get(index )
	local pack = NetManager:get_socket():alloc(138, 40);
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack);

end

--密友事件回调 领取按钮
-- s->c 138,40
function OnlineAwardCC:do_miyou_get( pack )
	--print("密友事件回调 领取按钮  ,密友事件回调 领取按钮 ,密友事件回调 领取按钮")

	MiyouCC:do_miyou_getGift_result( pack );
end


--密友事件回调 剩余时间
-- s->c 138,42
function OnlineAwardCC:do_miyou_remainTime( pack )
	MiyouCC:do_miyou_remain_Time( pack );
end

-- c->s 138,46 领取活动礼包
function OnlineAwardCC:req_get_huodonglibao(cdkey)
	local pack = NetManager:get_socket():alloc( 138, 46 );
	pack:writeString(cdkey);
	print("领取活动礼包",cdkey);
	NetManager:get_socket():SendToSrv(pack);	
end

-- s->c 138,46
function OnlineAwardCC:do_get_huodonglibao(pack)
	print(" s->c 138,46")
	local result = pack:readInt();
	-- 	0：成功
	-- -1:key不存在
	-- -2：key已经使用
	-- -3,：今天已经领取过
	local str = "";
	if result == 0 then
		str = "领取成功";
	elseif result == -1 then
		str = "cdkey不存在";
	elseif result == -2 then
		str = "cdkey已使用";
	elseif result == -3 then
		str = "今天已经领取过礼包了";
	end
	GlobalFunc:create_screen_notic( str )
end

-- c->s 138,47 请求修仙初成奖励信息
function OnlineAwardCC:req_xiuxian_award_info(  )
	-- print("请求修仙初成奖励信息");
	local pack = NetManager:get_socket():alloc( 138, 47 );
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 138,47 下发修仙初成的奖励信息
function OnlineAwardCC:do_xiuxian_award_info( pack )

	-- print("下发修仙初成的奖励信息")
	-- 奖励个数
	local count = pack:readInt();
	-- 活动时间
	local act_time = pack:readInt();

	local xiuxian_award_dict = {};
	for i=1,count do
		--1 人物等级 2 人物战斗力 3 宠物战斗力 4 坐骑战斗力 5 翅膀战斗力 6 法宝战斗力 7 成就 8 灵根 9 渡劫 10 斗法台
		local target_id = pack:readInt();
		--0 未领取1 可领取2 已领取
		local award_status = pack:readInt();
		-- print("第",target_id,"项",award_status);
		xiuxian_award_dict[i] = {id = target_id, status = award_status};
	end

	OpenSerModel:do_xiuxian_award_data( act_time, xiuxian_award_dict )

end

-- c->s 138,48 领取修仙初成的奖励
function OnlineAwardCC:req_get_xiuxian_award( award_id )
	-- award_id 1 人物等级 2 人物战斗力 3 宠物战斗力 4 坐骑战斗力 5 翅膀战斗力 6 法宝战斗力 7 成就 8 灵根 9 渡劫 10 斗法台
	-- print("领取修仙初成的奖励",award_id);
	local pack = NetManager:get_socket():alloc( 138, 48 );
	pack:writeInt(award_id);
	NetManager:get_socket():SendToSrv(pack);

end

-- c->s 138,49 查询离线灵气奖励
function OnlineAwardCC:request_lingqi_not_online(  )
	-- print("c->s 138,49 查询离线灵气奖励")
	local pack = NetManager:get_socket():alloc( 138, 49 );
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 138,49 下发离线灵气
function OnlineAwardCC:do_result_lingqi_not_online( pack )
	-- print("s->c 138,49 下发离线灵气")
	local not_online_hours   = pack:readInt()    -- 离线小时数
	local lingqi_total       = pack:readInt()    -- 离线灵气总数
    local ratio_1_vip_level  = pack:readInt()    -- 离线1倍灵气所需要仙尊等级
    local ratio_2_vip_level  = pack:readInt()    -- 离线2倍灵气所需要仙尊等级
    local ratio_3_vip_level  = pack:readInt()    -- 离线3倍灵气所需要仙尊等级
    
    WelfareModel:set_off_line_lingqi_date( not_online_hours, lingqi_total, ratio_1_vip_level, ratio_2_vip_level, ratio_3_vip_level  )
    ActivityWin:update_page_tips()
end

-- 获取离线灵气 lingqi_type: 灵气类型。 1：1倍领取  2: 1.5倍领取  3: 2倍领取
function OnlineAwardCC:request_get_lingqi( lingqi_type, hours )
	-- print("获取离线灵气......", lingqi_type, hours )
	local pack = NetManager:get_socket():alloc( 138, 50 );
	pack:writeInt(lingqi_type)
	pack:writeInt(hours)
	NetManager:get_socket():SendToSrv(pack);
end
-- c-> 138,51领取消费礼包
function OnlineAwardCC:send_consume_item(index)
	local pack = NetManager:get_socket():alloc( 138, 51 )
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end	

-- s->c 138,51消费礼包领取情况和剩余时间
function OnlineAwardCC:receive_consume_item(pack)
	local level_item = pack:readInt( )
	local item_state = pack:readInt()
	local time = pack:readInt()
	local spend_money = pack:readInt( )
	-- print("run OnlineAwardCC:receive_consume_item level_item, item_state, time, spend_money!!!!!!!!!!!!!!!!!!",
		-- level_item, item_state, time, spend_money)
	ActivityModel:change_chongzhilibao_state(level_item, item_state, time, spend_money)
end

-- c->s 138,52 获取活动列表
function OnlineAwardCC:req_get_activitys_list()
	-- print("c->s (138,52) OnlineAwardCC:req_get_activitys_list")
	local pack = NetManager:get_socket():alloc( 138, 52 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,52
function OnlineAwardCC:do_activitys_list( pack )
	print("s->c (138,52) OnlineAwardCC:do_activitys_list")
	local activitys_num = pack:readInt();
	print(" lua << activitys_num:", activitys_num)
	-- print("OnlineAwardCC:do_activitys_list( pack )",activitys_num);
	local jijin_visible = false
	local activity_info_table = {};
	--剔除id 为1 和 2 的活动 xiehande
	local temp_activity_info_table = {}
	for i=1,activitys_num do
		local  id = pack:readInt()
		print("id ",id)
		local  start_time = pack:readInt()
		local end_time = pack:readInt()
		temp_activity_info_table[i] = {};
		temp_activity_info_table[i].id =id
		temp_activity_info_table[i].start_time =start_time
		temp_activity_info_table[i].end_time =end_time
         
	end

	for i=1,#temp_activity_info_table do
		-- if  temp_activity_info_table[i].id ~= 2 and  temp_activity_info_table[i].id ~= 1 then
		if temp_activity_info_table[i].id ~= 1 then
            table.insert(activity_info_table,temp_activity_info_table[i])
		end
	end

    for i=1,#activity_info_table do
    	SmallOperationModel:add_act_id( i,activity_info_table[i].id )
    	SmallOperationModel:add_act_time( activity_info_table[i].id,  activity_info_table[i].end_time )
	    SmallOperationModel:save_start_end_time( activity_info_table[i].id, activity_info_table[i].start_time, activity_info_table[i].end_time )
    end

	-- ActivityMenusPanel.Set_RenZheJiJin_exist(jijin_visible)
	SCLBModel:set_sclb_btn_visible()

	-- 给活动入口图标添加活动提示
	-- local win = UIManager:find_visible_window("right_top_panel");
	-- if  win  then
	-- 	win:update_activity_show_mark( );
	-- end
    
	local win = UIManager:find_visible_window("activity_menus_panel");
	if ( win ) then
		win:init_with_params( activity_info_table );
	end

	-- 活动id=2为登陆送元宝，特殊处理(不放在活动大厅界面), 设置登陆送元宝是否打开分页
	LoginLuckyDrawModel:set_start_and_end_time( 0, 0 , false)
	if #activity_info_table > 0 then
		for k, v in pairs(activity_info_table) do
			if v.id == 2 then
				LoginLuckyDrawModel:set_start_and_end_time( v.start_time, v.end_time, true )	
			end
		end
	end
			


	-- local client_version = CCVersionConfig:sharedVersionConfig():getStringForKey('current_version');
	-- print("当前版本",client_version)
	-- local version = string.sub(client_version,string.len(client_version),-1)
	-- if tonumber(version)>=2 then
	--一直让活动入口存在
	-- print("总的多少个",#activity_info_table)
		-- if #activity_info_table  > 0 then
		 	local win = UIManager:find_visible_window("right_top_panel")
		 	if win then
				win:insert_btn(14,activity_info_table)
			end
		-- end
	-- end


end

-- c->s 138,53 获取强者之路活动数据
function OnlineAwardCC:req_get_strong_hero(  )
	local pack = NetManager:get_socket():alloc( 138, 53 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,53 下发强者之路活动数据
function OnlineAwardCC:do_strong_hero( pack )
	
	local can_get_record = pack:readInt() 	-- 是否达成奖励
	local had_get_record = pack:readInt() 	-- 是否领过	
	local arg = pack:readInt() 				-- 全身强化加几
	local data = {can_get_record = can_get_record, had_get_record = had_get_record, arg=arg};

	SmallOperationModel:do_strong_hero( data );

end

-- c->s 138,54 领取强者之路奖励
function OnlineAwardCC:req_get_strong_hero_award( index )
	print("领取强者之路奖励",index)
	local pack = NetManager:get_socket():alloc( 138, 54 )
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,55 拉取至强宠物活动面板
function OnlineAwardCC:req_get_power_pet(  )

	local pack = NetManager:get_socket():alloc( 138, 55 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,55 获取至强宠物活动面板
function OnlineAwardCC:do_get_power_pet( pack )
	local can_get_record = pack:readInt() 	-- 是否达成奖励
	local had_get_record = pack:readInt() 	-- 是否领过	
	local arg 			 = pack:readInt() 		-- 当前宠物最高的成长等级

	local data = {can_get_record = can_get_record, had_get_record = had_get_record,
				 arg = arg};

	SmallOperationModel:do_get_power_pet( data )
end

-- c->s 138,56 领取至强宠物奖励
function OnlineAwardCC:req_get_power_pet_award( index )
	local pack = NetManager:get_socket():alloc( 138, 56 )
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,57 拉去终极法宝活动面板
function OnlineAwardCC:req_get_power_fabao(  )
	local pack = NetManager:get_socket():alloc( 138, 57 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,57 获取终极法宝活动面板
function OnlineAwardCC:do_get_power_fabao( pack )

	local can_get_record = pack:readInt() 	-- 是否达成奖励
	local had_get_record = pack:readInt() 	-- 是否领过	
	local arg 			= pack:readInt() 		-- 当前法宝的等级
	local data = {can_get_record = can_get_record, had_get_record = had_get_record,
				 arg = arg};
	SmallOperationModel:do_get_power_fabao( data );
end

-- c->s 138,58 领取终极法宝奖励
function OnlineAwardCC:req_get_power_fabao_award( index )
	local pack = NetManager:get_socket():alloc( 138, 58 )
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138-68
function OnlineAwardCC:client_get_zhanbu_info()
	local pack = NetManager:get_socket():alloc( 138, 68 )
	NetManager:get_socket():SendToSrv( pack )
	print("138-68 OnlineAwardCC:client_get_zhanbu_info")
end 

-- s->c 138-68
function OnlineAwardCC:server_get_zhanbu_info(pack)
	local time = pack:readInt()
	print("138-68 OnlineAwardCC:server_get_zhanbu_info time", time)
	ZhanBuModel:update_zhanbu_info(time)
end

-- c->s 138-69
function OnlineAwardCC:client_get_zhanbu_event_info()
	local pack = NetManager:get_socket():alloc( 138, 69 )
	NetManager:get_socket():SendToSrv( pack )
	print("138-69 OnlineAwardCC:client_get_zhanbu_event_info")
end

-- s->c 138-69
function OnlineAwardCC:server_get_zhanbu_event_info(pack)
	local num = pack:readInt()
	local info = {}
	for i = 1, num do
		info[i] = ZhanBuEventStruct(pack)
	end
	print("138-69 OnlineAwardCC:server_get_zhanbu_event_info num",num)
	ZhanBuModel:update_zhanbu_event_info( info )
end

-- c->s 138-70
function OnlineAwardCC:client_zhanbu()
	local pack = NetManager:get_socket():alloc( 138, 70 )
	NetManager:get_socket():SendToSrv( pack )
	print("138-70 OnlineAwardCC:client_zhanbu")
end

-- s->c 138-70
function OnlineAwardCC:server_zhanbu_result(pack)
	local event_id = pack:readInt()
	print("138-70 OnlineAwardCC:server_zhanbu_result event_id", event_id)
	ZhanBuModel:update_zhanbu_result( event_id )
end

-- c->s 138-71
function OnlineAwardCC:client_zhanbu_add_rate()
	local pack = NetManager:get_socket():alloc( 138, 71 )
	NetManager:get_socket():SendToSrv( pack )
	-- print("138-71 OnlineAwardCC:client_zhanbu_add_rate")
end

-- s->c 138-71
function OnlineAwardCC:server_zhanbu_add_rate(pack)
-- 	0--无加成
-- 	1--装备强化
-- 	2--翅膀升级
--	3--宠物成长
-- 	4--宠物悟性
	local index = pack:readByte()
	local add_rate = pack:readInt()
	local limit_time = pack:readInt()
	print("138-71 OnlineAwardCC:server_zhanbu_add_rate index, add_rate, limit_time", index, add_rate, limit_time)
	ZhanBuModel:update_zhanbu_buff_info( index, add_rate, limit_time )
end

-- s->c 138,72 打开宝盒抽奖界面
function OnlineAwardCC:do_open_bh_window( pack )
	local item_series = pack:readInt64();
	local items = {};
	for i=1,10 do
		items[i] = pack:readInt();
	end
	local award_item = pack:readInt();
	print("OnlineAwardCC:do_open_bh_window award_item = ",award_item);
	XianDaoBaoHeWin:show( item_series,items,award_item );
end

-- c->s 138,73 宝盒抽奖
function OnlineAwardCC:req_choujiang( item_series,is_remove_five_item )
	local pack = NetManager:get_socket():alloc( 138, 73 )
	pack:writeInt64(item_series);
	pack:writeInt(is_remove_five_item);
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,73 宝盒抽奖结果
function OnlineAwardCC:do_choujiang( pack )
	local item_series = pack:readInt64();
	local result_item = pack:readInt();
	print("OnlineAwardCC:do_open_bh_window result_item = ",result_item);
	local win = UIManager:find_visible_window("xiandaobaohe_win");
	if ( win ) then
		win:update_result_item(result_item);
	end
end

-- c->s 138,74 结束抽奖
function OnlineAwardCC:req_finish_choujiang( item_series )
	local pack = NetManager:get_socket():alloc( 138, 74 )
	pack:writeInt64(item_series);
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,75 拉起国庆活动的界面
function OnlineAwardCC:req_open_guoqing_activity_win()
	-- print("OnlineAwardCC:req_open_guoqing_activity_win()")
	local pack = NetManager:get_socket():alloc( 138, 75 )
	-- pack:writeInt(0);
	NetManager:get_socket():SendToSrv(pack)	
end

-- s->c 138,75 拉起国庆活动的界面
function OnlineAwardCC:do_open_guoqing_activity_win( pack )
	local data = {};
	data.activity_id = pack:readInt();	--活动id
	data.can_get_award = pack:readInt();	--可领取记录
	data.has_get_award = pack:readInt();	--已领取的记录
	data.level = pack:readInt();	--附加参数
	-- print("---------------------OnlineAwardCC:do_open_guoqing_activity_win",data.can_get_award,data.has_get_award,data.level);
	SmallOperationModel:do_open_guoqing_activity_win( data )
end

-- c->s 138,76 领取国庆活动奖励
function OnlineAwardCC:req_accept_gq_award( award_index )
	local pack = NetManager:get_socket():alloc( 138, 76 )
	pack:writeInt( 0 );
	pack:writeInt(award_index);
	NetManager:get_socket():SendToSrv(pack)	
	print(" OnlineAwardCC:req_accept_gq_award( award_index )",award_index);
end


--  c->s 138,80 活动奖励数据   （大型活动通用接口）
function OnlineAwardCC:req_activity_data_com( activity_id, activity_child_id)
	print("c->s 138,80 活动奖励数据 （大型活动通用接口）", activity_id, activity_child_id)
	local pack = NetManager:get_socket():alloc( 138, 80 )
	pack:writeInt( activity_id )
	pack:writeInt( activity_child_id )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,80 下发活动数据  （大型活动通用接口）
function OnlineAwardCC:do_result_activity_data_com( pack )
	print("s->c 138,80 下发活动数据  （大型活动通用接口）")
	local activity_id = pack:readInt( )           -- 活动id
	local activity_data = BigActivityStruct( pack )
	-- print("activity_data.can_get_record=",activity_data.can_get_record)
	-- print("activity_data.had_get_record=",activity_data.had_get_record)
	BigActivityModel:set_activity_data( activity_id, activity_data )
end

--  c->s 138,81 领取活动奖励  （大型活动，通用接口）
function OnlineAwardCC:req_get_activity_award_com( activity_id, activity_child_id, award_id, paihang_id )
	print("c->s 138,81 领取活动奖励 大型活动，通用接口）", activity_id, activity_child_id, award_id)
	local pack = NetManager:get_socket():alloc( 138, 81 )
	pack:writeInt( activity_id )
	pack:writeInt( activity_child_id )
	if award_id then
		pack:writeInt( award_id )
	end
	if paihang_id then
   	 	pack:writeInt( paihang_id )
   	end 
	NetManager:get_socket():SendToSrv(pack)
end

--  c->s 138,82 拉取活动排行榜    （大型活动，通用接口）
function OnlineAwardCC:req_get_activity_rank_com( activity_id ,paihang_id)
	print("c->s 138,82 拉取活动排行榜    （大型活动，通用接口）", activity_id,paihang_id)
	local pack = NetManager:get_socket():alloc( 138, 82 )
	pack:writeInt( activity_id )
	pack:writeInt( paihang_id )
	NetManager:get_socket():SendToSrv(pack)
end



-- s->c 138,82 服务器下排行活动的数据
function OnlineAwardCC:do_result_activity_rank_com( pack )
	print("s->c 138,82 服务器下发国庆魅力活动的数据")
	local activity_id = pack:readInt()
	local paihang_id = pack:readInt()			 -- 排行ID （是什么排行）
	local count = pack:readInt()                 -- 多少项    
	local cell_t = {}                            -- 排行榜项
	for i = 1, count do 
		local cell = BigActivityRankStruct( pack )
		table.insert( cell_t, cell )
	end
	print("activity_id  paihang_id count",activity_id,paihang_id,count)
	BigActivityModel:set_rank_date( activity_id, paihang_id, cell_t )
end

-- c->s 138,85 神秘礼包抽奖
function OnlineAwardCC:req_smlbcj( item_series )
	print("OnlineAwardCC:req_smlbcj( item_series,type )",item_series,type)
	local pack = NetManager:get_socket():alloc( 138, 85 )
	pack:writeInt64( item_series );
	NetManager:get_socket():SendToSrv(pack)		
end

-- s->c 138,85 神秘礼包抽奖结果
function OnlineAwardCC:do_smlbcj( pack )
	local item_series = pack:readInt64();
	local result = pack:readInt();
	local count = pack:readInt();
	print("OnlineAwardCC:do_smlbcj",item_series,result,count)
	OpenBoxWin:update_result( result,count )
end

-- c->s 138,88 结束神秘礼包抽奖
function OnlineAwardCC:req_finish_smlb_cj( item_series )
	local pack = NetManager:get_socket():alloc( 138, 86 )
	pack:writeInt64( item_series );
	NetManager:get_socket():SendToSrv(pack)			
end

-- c->s 138,87 神秘百宝抽奖
function OnlineAwardCC:req_smbbcj( item_series,type )
	print("OnlineAwardCC:req_smbbcj( item_series,type )",item_series,type)
	local pack = NetManager:get_socket():alloc( 138, 87 )
	pack:writeInt64( item_series );
	pack:writeInt( type );
	NetManager:get_socket():SendToSrv(pack)		
end

-- s->c 138,87 神秘百宝抽奖结果
function OnlineAwardCC:do_smbbcj( pack )
	local item_series = pack:readInt64();
	local result = pack:readInt();
	local count = pack:readInt();
	print("OnlineAwardCC:do_smbbcj",item_series,result,count)
	OpenBoxWin:update_result( result,count )
end

-- c->s 138,88 结束神秘百宝箱抽奖
function OnlineAwardCC:req_finish_cj( item_series )
	local pack = NetManager:get_socket():alloc( 138, 88 )
	pack:writeInt64( item_series );
	NetManager:get_socket():SendToSrv(pack)			
end

-- s->c 138,91 蓝钻开通或续费
function OnlineAwardCC:server_qq_blue_vip_open_state(pack)
	local state = pack:readInt()
	print("s->c 138,91 OnlineAwardCC:server_qq_blue_vip_open_state", state)
	QQVIPModel:set_vip_open_state(state)
end
-- s->c 138,94 尊贵蓝钻活动开启
function OnlineAwardCC:server_get_blue_activity_open(pack)
	local remain_time = pack:readUInt()
	print("s->c 138,94 OnlineAwardCC:server_get_blue_activity_open remain_time", remain_time)
	QQBlueDiamonTimeAwardModel:set_remain_time(remain_time)
end

-- c->s 138,95 尊贵蓝钻活动领取奖励
function OnlineAwardCC:server_get_blue_activity_award()
	print("c->s 138,95 OnlineAwardCC:server_get_blue_activity_award ")
	local pack = NetManager:get_socket():alloc( 138, 95 )
	pack:writeInt(1)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,95 
function OnlineAwardCC:client_get_blue_activity_award(pack)
	local result = pack:readInt()
	print("s->c 138,95  OnlineAwardCC:client_get_blue_activity_award",result)
	QQBlueDiamonTimeAwardModel:set_reward_state(result)
	if result == 1 then
		QQBlueDiamonTimeAwardModel:set_remain_time(0)
	end
end

-- c->s 138,96
function OnlineAwardCC:req_sdsl_data()
	print("c->s 138,95 OnlineAwardCC:req_sdsl_data ")
	local pack = NetManager:get_socket():alloc( 138, 96 )
	NetManager:get_socket():SendToSrv(pack)
end
-- 圣诞送礼
function OnlineAwardCC:do_sdsl_data( pack )
	local award_num = pack:readInt();
	local first_time_state = pack:readInt();
	local second_time_state = pack:readInt();
	local third_time_state = pack:readInt();
	local activity_data = { first_time_state,second_time_state}
	BigActivityModel:set_activity_data( 24, activity_data )
end

-- c->s 138,97 领取圣诞送礼奖励
function OnlineAwardCC:req_get_sdsl_data( index )
	print("c->s 138,97 OnlineAwardCC:req_get_sdsl_data ",index)
	local pack = NetManager:get_socket():alloc( 138, 97 )
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)
end


--QQ浏览器 点击领取事件
--c->s,138  106

function OnlineAwardCC:req_get_award( )
	print("c->s,138  106")
	local pack = NetManager:get_socket():alloc(138, 106);
	NetManager:get_socket():SendToSrv(pack);
end

--QQ浏览器领取事件回调
-- s->c 138,106
function OnlineAwardCC:do_qqbrowser_award( pack )
	-- local Gift_ID = pack:readInt();
	-- print("Gift_ID=",Gift_ID)
	print("s->c,138  106")
	local btn_state = pack:readInt();
	local win = UIManager:find_window("qq_browser_dialog");
	if win then 
		win:update(btn_state) --_QQ_BTN_HAD_GET =2
	end
end	



--QQ浏览器 申请按钮状态
--c->s,138  107

function OnlineAwardCC:req_get_award_state(bClick) 
	print("c->s,138  107")
	local pack = NetManager:get_socket():alloc(138, 107);
	pack:writeInt(bClick) -- 0：玩家只打开界面不安装，1：玩家安装浏览器
	NetManager:get_socket():SendToSrv(pack);
end

--QQ浏览器下发按钮状态
-- s->c 138,107
function OnlineAwardCC:do_get_award_state( pack )
	local btn_state = pack:readByte();
	print("btn_state=",btn_state)

	local win = UIManager:find_window("qq_browser_dialog");
	if win then 
		win:update(btn_state)
	end
end	



--QQ微信 
--c->s,138  108

function OnlineAwardCC:req_get_weixin_libao(cdkey) 
	print("c->s,138  108")
	local pack = NetManager:get_socket():alloc(138, 108);
	pack:writeString(cdkey)  
	NetManager:get_socket():SendToSrv(pack);
end

--聚宝袋  申请排行榜
--c->s,138  110

function OnlineAwardCC:req_get_jubaodai_rank() 
	ZXLog("c->s,138  110")
	local pack = NetManager:get_socket():alloc(138, 110);
	NetManager:get_socket():SendToSrv(pack);
end

--QQ聚宝袋
-- s->c 138,110
function OnlineAwardCC:do_get_jubaodai_rank( pack )
	ZXLog("s->c,138  110")
	local count  =  pack:readInt();
	print("count=",count)
	local other_data = {}
	for i=1,count do
		other_data[i]={}
		other_data[i].player_id = pack:readInt();
		other_data[i].player_name = pack:readString();
		other_data[i].player_score = pack:readInt();
		print("i=",i)
		print("player_id=",other_data[i].player_id)
		print("player_name=",other_data[i].player_name)
		print("player_score=",other_data[i].player_score)
	end
	local my_data = {}
	my_data.rank = pack:readInt() + 1 ; --名次  从0 开始 所以要加1
	my_data.score =pack:readInt(); --自己积分
	-- local count = pack:readInt(); --自己积分
	print("名次=",my_data.rank)
	print("自己积分=",my_data.score)
	-- local btn_state = pack:readByte();

	local win = UIManager:find_window("jubao_bag_win");
	if win then 
		win:update(1,my_data,other_data)
	end
end	

-- c->s 138,112  请求平台奖励
function OnlineAwardCC:request_get_platform_award( platform_id, openid )
	-- ZXLog('OnlineAwardCC:request_get_platform_award', platform_id,openid)
	if platform_id == nil then
		-- qq专用的，如果不是qq平台，不需要走这步
		return 
	end
	local pack = NetManager:get_socket():alloc( 138, 112 )
	pack:writeInt(platform_id)
	pack:writeString(openid)
	NetManager:get_socket():SendToSrv(pack)
end

-- 刷新新手副本小兵
function OnlineAwardCC:req_enter_birth_fuben()
	print("请求刷新新手副本小兵")
	local pack = NetManager:get_socket():alloc(138, 113);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 进入新手村
function OnlineAwardCC:req_enter_xinshoucun()
	local pack = NetManager:get_socket():alloc(138, 114);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 进入新手村成功
function OnlineAwardCC:do_enter_xinshoucun( pack )
	local player = EntityManager:get_player_avatar();
	if player then
		player:update_default_body(player.body )
		player:update_weapon(player.weapon)
		UIManager:show_window("welcome_win")
		UIManager:show_window("right_top_panel")
	else
		print("主角没有创建成功")
	end
end

-- 请求新手武器
function OnlineAwardCC:req_get_weapon()
	local pack = NetManager:get_socket():alloc(138, 115);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 请求加满怒气
function OnlineAwardCC:req_max_anger_value(  )
	local pack = NetManager:get_socket():alloc(138, 116);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 请求刷新新手副本boss
function OnlineAwardCC:req_create_boss(  )
	local pack = NetManager:get_socket():alloc(138, 117);
	NetManager:get_socket():SendToSrv(pack);	
end

--c->s 138,113
--请求累计登陆奖励信息
function OnlineAwardCC:req_login_benefit(  )
	local pack = NetManager:get_socket():alloc(138, 113);
	NetManager:get_socket():SendToSrv(pack);	
end

--s-> 138,113
--下发累计登陆奖励信息
function OnlineAwardCC:do_login_benefit( pack )
	local benefit_type = pack:readChar()
	local login_days = pack:readShort() 
	local get_status_flags = pack:readInt()
	print("OnlineAwardCC:do_login_benefit(benefit_type,login_days,get_status_flags)",benefit_type,login_days,get_status_flags)
	BenefitModel:set_login_info(benefit_type,login_days,get_status_flags)
end
--c->s 138,113
--领取登陆奖励信息
function OnlineAwardCC:req_get_login_benefit(days_index)
	local pack = NetManager:get_socket():alloc(138, 114);
	pack:writeChar(days_index)
	NetManager:get_socket():SendToSrv(pack)	
end

-- 九宫神藏 ===================================
-- c->s 请求九宫神藏格子数据与刷新次数  type 0 代表请求数据，1 代表刷新
function OnlineAwardCC:req_jiugong_info(type)
	print("请求九宫神藏格子数据与刷新次数")
	local pack = NetManager:get_socket():alloc(138, 181);
	pack:writeInt(type)
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c下发九宫神藏格子数据与刷新次数
function OnlineAwardCC:do_send_jiugong_info( pack)
    print("c下发九宫神藏格子数据与刷新次数")
	local shuaxin_count = pack:readByte()  --刷新次数
	print("刷新次数",shuaxin_count)
	local gezi_info = {} --格子信息
	for i=1,9 do
		local one_gezi_info = {} --单个格子信息
		local item_id = pack:readInt()  --物品ID
		print("下发九宫神藏物品ID",item_id)
		local status = pack:readByte()  --物品状态 0代表没抽到，1代表已经抽到
		one_gezi_info ={item_id=item_id,status=status}
		table.insert( gezi_info, one_gezi_info )
	end
    
    JiuGongModel:set_gezi_info( gezi_info)
	JiuGongModel:set_shuaxin_count( shuaxin_count)

	local win = UIManager:find_visible_window("jiu_gong_left_win");
	if win then 
		win:update_slot_info()
		win:update_xiaofei_yuanbao(  )
		win.chou_jiang_btn:setCurState(CLICK_STATE_UP)
	end
end

-- 团购 ================================
--功能：c->s,请求团购积分排行榜,138,200
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function OnlineAwardCC:reqGroupBuyPointQueue()
	--创建138主协议，200子协议的数据包
	local pack = NetManager:get_socket():alloc( 138, 200 )
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

--功能：s->c,接收团购积分排行榜,138,200
--参数：pack	数据包
--返回：无
--作者：陈亮
--时间：2014.08.18
function OnlineAwardCC:receiverGroupBuyPointQueue(pack)
	print("s->c(138,200) OnlineAwardCC:receiverGroupBuyPointQueue")
	--解析数据包,我的排名，我的仙宗积分，排行榜数量，排行榜数据
	local t_myGuildQueue = pack:readByte()
	local t_myGuildPoint = pack:readInt()
	local t_queueCount = pack:readByte()

	print("----------t_myGuildQueue:", t_myGuildQueue, t_myGuildPoint,t_queueCount)
	local t_queueDataGroup = {
		guildName = {},
		guildPoint = {}
	}
	--遍历获取排行榜数据
	for t_index = 1,t_queueCount do
		t_queueDataGroup.guildName[t_index] = pack:readString()
		t_queueDataGroup.guildPoint[t_index] = pack:readInt()
	end

	--更新团购积分窗口数据
	SuperGroupBuyModel:updateMyGuildInfo(t_myGuildQueue,t_myGuildPoint)
	SuperGroupBuyModel:updatePointQueue(t_queueCount,t_queueDataGroup)
end


--功能：c->s,请求团购信息,138,201
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
--创建138主协议，201子协议的数据包
function OnlineAwardCC:reqGroupBuyInfo()
	print("c->s OnlineAwardCC:reqGroupBuyInfo")
	local pack = NetManager:get_socket():alloc( 138, 201 )
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end


--功能：s->c,接收团购信息,138,201
--参数：pack	数据包
--返回：无
--作者：陈亮
--时间：2014.08.18
function OnlineAwardCC:receiverGroupBuyInfo(pack)
	print("s->c 138,201 OnlineAwardCC:receiverGroupBuyInfo")
	--解析接收到的数据,配置类型，实惠礼品数量，超值礼品数量，我的积分，积分礼包状态
	local t_configType = pack:readByte()
	local t_cheapGiftCount = pack:readInt()
	local t_superGiftCount = pack:readInt()
	local t_myPoint = pack:readInt()
	local t_pointGiftStatus = pack:readInt()
	local t_isShowQueue = pack:readByte()
	print("------------t_cheapGiftCount:", t_cheapGiftCount)

	--对团购活动进行更新基础信息、礼包购买和领取状态和我的积分
	SuperGroupBuyModel:updateGroupBuyBaseInfo(t_configType,t_isShowQueue)
	SuperGroupBuyModel:updateBuyButtonStatus(t_cheapGiftCount,t_superGiftCount)
	SuperGroupBuyModel:updateMyPointViewGroup(t_myPoint,t_pointGiftStatus)
end

--功能：c->s,请求购买礼包,138,202
--参数：1、giftType		礼包类型
--返回：无
--作者：陈亮
--时间：2014.08.18
function OnlineAwardCC:reqBuyGift(giftIndex)
	--创建138主协议，202子协议的数据包
	local pack = NetManager:get_socket():alloc( 138, 202 )
	print("----giftIndex:", giftIndex)
	pack:writeInt(giftIndex)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

--功能：c->s,请求领取积分礼包,138,203
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function OnlineAwardCC:reqGainPointGift()
	--创建138主协议，203子协议的数据包
	local pack = NetManager:get_socket():alloc( 138, 203 )
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

-- =====================================
-- 密友抽奖协议
-- =====================================
-- 赠送密友抽奖次数
function OnlineAwardCC:req_send_draw_chance( friend_name )
	print( "c->s( 138, 204 ) OnlineAwardCC:req_send_draw_chance" )
	local pack = NetManager:get_socket():alloc( 138, 204 )
	print("-----c->s:", friend_name )
	pack:writeString(friend_name)
	NetManager:get_socket():SendToSrv(pack)
end

-- 更新密友面板信息
function OnlineAwardCC:req_main_info()
	print( "c->s ( 138, 205 )OnlineAwardCC:req_main_info" )
	local pack = NetManager:get_socket():alloc( 138, 205 )
	NetManager:get_socket():SendToSrv(pack)
end

-- 下发密友面板信息(服务器下发)
function OnlineAwardCC:do_main_info( pack )
	print( "s->c( 138, 205 ) OnlineAwardCC:do_main_info" )
	local num_draw = pack:readInt()
	local num_draw_free = pack:readInt()
	local num_drawn = pack:readInt() -- 一抽过
	local num_send = pack:readInt()
	local num_gift = pack:readInt()
	local num_time = pack:readInt()
	print("-------num_drawn:", num_draw, num_draw_free, num_drawn, num_send, num_gift, num_time )
	FriendsDrawModel:update_main_info(num_draw, num_draw_free, num_drawn, num_send, num_gift, num_time )
end

-- 下发密友获赠记录(服务器下发)
function OnlineAwardCC:do_gift_order( pack )
	print( "s->c( 138, 206 ) OnlineAwardCC:do_gift_order" )
	local num_order = pack:readInt()
	print("-----num_order:", num_order)
	local arr_order = {}
	for i=1, num_order do
		arr_order[i] = {}
		arr_order[i].name = pack:readString()
		arr_order[i].num_get = pack:readInt()
		print("--name:", arr_order[i].name )
		print("---num:", arr_order[i].num_get )
		-- local name = pack:readString()
		-- local num_get = pack:readInt()
		-- print("--name:", name )
		-- print("---num:", num_get )
	end
	FriendsDrawModel:update_gift_order( arr_order )
end

-- 请求密友抽奖
function OnlineAwardCC:req_friend_draw( ... )
	print( "c->s( 138, 207 ) OnlineAwardCC:req_friend_draw" )
	local pack = NetManager:get_socket():alloc( 138, 207 )
	NetManager:get_socket():SendToSrv(pack)
end

-- 下发密友抽奖结果(服务器下发)
function OnlineAwardCC:do_draw_result( pack )
	print( "s->c( 138, 207 ) OnlineAwardCC:do_draw_result" )
	local item_id = pack:readInt()
	print("--------item_id:", item_id)
	FriendsDrawModel:update_draw_result( item_id )
end

-- 密友礼包领取请求
function OnlineAwardCC:req_get_gift( ... )
	print( "c->s( 138, 208 ) OnlineAwardCC:req_get_gift" )
	local pack = NetManager:get_socket():alloc( 138, 208 )
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138,223 请求数据--光棍节(送花排行)
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.28
function OnlineAwardCC:req_get_sendFlowerRanking()
	print("请求送花排行榜数据")
	local pack = NetManager:get_socket():alloc( 138, 223 )
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,223 返回数据--光棍节(送花排行)
--参数：1、pack		数据包
--返回：无
--作者：肖进超
--时间：2014.10.28
function OnlineAwardCC:receiveSendFlowerRanking(pack)
	--解析数据包
	local t_myRanking = pack:readByte()              --我的排名
	local t_mySendNum = pack:readInt()              --我的送花数量
	local t_allRankingNum = pack:readByte()          --排名总数    {[玩家排名] = {玩家名，送花数量}}
    local t_rankingGroup = {}                       --排名信息
	for idx = 1,t_allRankingNum do
		local playerName = pack:readString()
        local playerSendNum = pack:readInt()
        t_rankingGroup[idx] = {playerName, playerSendNum}
	end
    local t_rewardNum = pack:readByte()           --累计送花领取奖励状态总数
    local t_rewardStateGroup = {}                 --累计送花奖励领取状态
    for idx = 1,t_rewardNum do
        t_rewardStateGroup[idx] = pack:readByte()    --0、不能领取，1、未领取，2、已领取
	end
	local t_activityId = pack:readInt()
	print("下发送花排行榜数据。玩家排名：",t_myRanking,"玩家送花数量：",t_mySendNum)

	--更新活动ID，用于区别新老服
	SendFlowerModel:refreshActivityId(t_activityId)
    --更新我的送花排名,我的送花数量
    SendFlowerModel:updateMySendFlowerInfo(t_myRanking, t_mySendNum)
	--更新送花排行榜
	SendFlowerModel:updateRanking(t_rankingGroup)
    --更新累计送花奖励领取状态
	SendFlowerModel:updateRewardState(t_rewardStateGroup)

	-- 情人节活动数据刷新
	ValentineDayModel:refreshPageInfo(CommonActivityConfig.TypeSendFlowerQueue)
	ValentineWhiteDayModel:refreshPageInfo(CommonActivityConfig.TypeSendFlowerQueue)
end

-- -- c->s 138,240 请求收花数据(被九祥废弃)
-- function OnlineAwardCC:req_get_ReceiveFlowerData()
-- 	print("请求收花数据")
-- 	local pack = NetManager:get_socket():alloc( 138, 240 )
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- -- s->c 138,240 请求收花数据返回数据(被九祥废弃)
-- function OnlineAwardCC:do_get_ReceiveFlowerData(pack)
-- 	local t_myReceiveNum = pack:readInt()   --我的收花数量
-- 	local t_award_num = pack:readChar()	-- 奖励数量（char类型读取后，t_award_num的type是number类型）
-- 	print("收花数据返回收花数量：",t_myReceiveNum,"奖励个数：",t_award_num)
-- 	local t_award_state_table = {}
-- 	for i=1,t_award_num do
-- 		t_award_state_table[i] = pack:readChar(); -- 0未领取、1可领取、2已领取
-- 		print("第",i,"个奖励的领取状态",t_award_state_table[i])
-- 	end
-- 	BAReceiveFlowerModel:set_receive_flower_info(t_myReceiveNum,t_award_num,t_award_state_table)
-- end

-- c->s 138,241 请求收花奖励(被九祥废弃)
-- function OnlineAwardCC:req_get_ReceiveFlower_award(index)
-- 	print("请求收花奖励",index)
-- 	local pack = NetManager:get_socket():alloc( 138, 241 )
-- 	pack:writeInt(index)
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- c->s 138,247 请求收花排行榜数据
-- add by gzn 2015.2.9
function OnlineAwardCC:req_get_ReceiveFlowerRank()
	print("请求收花数据")
	local pack = NetManager:get_socket():alloc( 138, 247 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138,247 请求收花数据返回数据
-- add by gzn 2015.2.9
function OnlineAwardCC:do_get_ReceiveFlowerRank(pack)
	print("下发收花数据")
	local t_myRanking = pack:readByte()	--我的排名
	local t_myNum = pack:readInt()              --我的收花数量
	local t_allRankingNum = pack:readByte()          --排名总数    {[玩家排名] = {玩家名，送花数量}}
    local t_rankingGroup = {}                       --排名信息
	for idx = 1,t_allRankingNum do
		local playerName = pack:readString()
        local playerNum = pack:readInt()
        t_rankingGroup[idx] = {playerName, playerNum}
	end
	local t_activityId = pack:readInt()
	-- 时间太紧，没时间写struct了
	BAReceiveFlowerModel:set_receive_flower_info(t_myRanking,t_myNum,t_allRankingNum,t_rankingGroup,t_activityId);
end

--功能：c->s,请求获取全部消费奖励,138,211
--参数：1、activityId		活动ID
--		2、childActivityID	子活动ID
--返回：无
--作者：陈亮
--时间：2014.08.30
function OnlineAwardCC:reqGainAllAward(activityId,childActivityID)
	--创建138主协议，211子协议的数据包
	local pack = NetManager:get_socket():alloc( 138, 211 )
	pack:writeInt(activityId)
	pack:writeInt(childActivityID)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end


--功能：c->s,请求兑换物品信息,138,226
--参数：1、activityId	活动ID
--返回：无
--作者：陈亮
--时间：2014.08.30
function OnlineAwardCC:reqExchangeInfoList(activityId)
	print(">>>-----------138, 225:", activityId)
	--创建138主协议，209子协议的数据包
	local pack = NetManager:get_socket():alloc( 138, 225 )
	pack:writeInt(activityId)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

--功能：s->c,接收兑换物品信息,138,225
--参数：1、pack	数据包
--返回：无
--作者：陈亮
--时间：2014.08.30
function OnlineAwardCC:receiveExchangeInfoList(pack)
	--解析数据包
	local cur_num = pack:readInt()  -- 当前红包数量
	local cost = pack:readInt()	-- 没用
	LonelyDayModel:refreshTGExchangeInfo(cur_num)
	LanternDayModel:refreshTGExchangeInfo(cur_num)

	-- 如果是神树活动，返回的是积分
	MagicTreeModel:set_point( cur_num )
end

--功能：c->s,请求兑换物品,138,210
--参数：1、propId		物品ID
--		2、activityId	活动ID
--返回：无
--作者：陈亮
--时间：2014.08.30
function OnlineAwardCC:reqExchangeProp(propId, activityId)
	print(">>>-----------138, 226:", propId, activityId)
	--创建138主协议，210子协议的数据包
	local pack = NetManager:get_socket():alloc( 138, 226 )
	pack:writeChar(propId)
	pack:writeInt(activityId)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

---===========================================每日限购====================================------------------

-- c->s 138,235 请求限制购买数量
--参数：1、activityId    活动ID
--返回：无
--作者：陈亮
--时间：2014.12.23
function OnlineAwardCC:reqLimitBuyCount(activityId)   
	print("OnlineAwardCC:reqLimitBuyCount(activityId) ",activityId)
	local pack = NetManager:get_socket():alloc( 138, 235 )
	pack:writeInt(activityId)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end


--功能：s->c,接收限制购买数量,138,235
--参数：1、pack		数据包
--返回：无
--作者：陈亮
--时间：2014.12.23
function OnlineAwardCC:recvLimitBuyCount(pack)
	print("OnlineAwardCC:recvLimitBuyCount ")

	--解析数据包：活动ID，限制购买数量
	local t_activityId = pack:readInt()
	local t_limitPropCount = pack:readByte()
	local t_limitBuyCountGroup = {}
    
    print("t_activityId",t_activityId)
    print("t_limitPropCount",t_limitPropCount)




	for t_limitIndex = 1,t_limitPropCount do
		local t_limitBuyCount = pack:readInt()
		t_limitBuyCountGroup[t_limitIndex] = t_limitBuyCount
	end
    print("t_limitBuyCountGroup",#t_limitBuyCountGroup)
        for i=1,#t_limitBuyCountGroup do
    	print("t_limitBuyCountGroup",t_limitBuyCountGroup[i])
    end
	BigActivityModel:updateCommonLimitBuyInfo(t_activityId,t_limitPropCount,t_limitBuyCountGroup)
end

-- c->s 138,236 请求购买限购道具
--参数：1、activityId    活动ID
--		2、propId		 限购道具ID
--返回：无
--作者：陈亮
--时间：2014.12.23
function OnlineAwardCC:reqBuyLimitProp(activityId,propId)  
	print("请求购买限购道具")
	local pack = NetManager:get_socket():alloc( 138, 236 )
	pack:writeInt(activityId)
	pack:writeInt(propId)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end



-- c->s 138,239 请求活动标签
--参数：1、activityId    活动ID
--返回：无
--作者：肖进超
--时间：2015.1.7
function OnlineAwardCC:reqActivityTag(activityId)   
	print("请求活动标签,",activityId)
	local pack = NetManager:get_socket():alloc( 138, 239 )
    pack:writeInt(activityId)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end


--功能：s->c,接收活动标签,138,239
--参数：1、pack		数据包
--返回：无
--作者：肖进超
--时间：2015.1.7
function OnlineAwardCC:recvActivityTag(pack)
	local t_activityId = pack:readInt()
	local t_tag = pack:readInt()
	local t_day = pack:readInt()
    -- print("t_activityId t_tag t_day",t_activityId,t_tag,t_day)
	BigActivityModel:updateActivityTag(t_activityId,t_tag,t_day)
end


---===========================================每日限购====================================------------------


---===========================================破冰活动====================================------------------

--138,245
--拉取充值送元宝活动界面
function OnlineAwardCC:request_chongzhi_value()   
	print("OnlineAwardCC:request_chongzhi_value ")
	local pack = NetManager:get_socket():alloc( 138, 245 )
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end


--功能：s->c,接收限制购买数量,138,235
--参数：1、pack		数据包
--作者：xiehande
--时间：2015.2.7
function OnlineAwardCC:rechieve_chongzhi_value(pack)
    require "model/PobingModel"
	
	print("OnlineAwardCC:rechieve_chongzhi_value ")
	--解析数据包：活动ID，限制购买数量
	local pobingValue = {}
	local today_money = pack:readInt()
	local count_money = pack:readInt()
	local first_flag = pack:readInt()
	local second_flag = pack:readInt()
	local third_flag = pack:readInt()
	print("today_money",today_money)
	print("count_money",count_money)
	print("first_flag",first_flag)
	print("second_flag",second_flag)
	print("third_flag",third_flag)

	pobingValue.today_money = today_money
	pobingValue.count_money = count_money
	pobingValue.first_flag = first_flag
	pobingValue.second_flag = second_flag
	pobingValue.third_flag = third_flag
    PobingModel:rechieve_chongzhi_value( pobingValue )
    
end

--138,246
--领取充值送元宝奖励
function OnlineAwardCC:request_lignqu(index)   
	-- print("OnlineAwardCC:request_lignqu ",index)
	local pack = NetManager:get_socket():alloc( 138, 246 )
		pack:writeInt(index)
	--发送请求包
	NetManager:get_socket():SendToSrv(pack)
end

-- 连续充值 ----
function OnlineAwardCC:req_seriescz_info( )
	print("c->s(138, 248)OnlineAwardCC:req_seriescz_info ")
	local pack = NetManager:get_socket():alloc( 138, 248 )
	NetManager:get_socket():SendToSrv(pack)
end

function OnlineAwardCC:do_seriescz_info( pack )
	print("s->c(138, 248)OnlineAwardCC:do_seriescz_info ")
	local num_yb = pack:readInt()  --连续累记充值元宝数
	local num_day = pack:readInt()  --连续充值天数
	local gift_3 = pack:readInt()   --连续充值3天奖励数
	local gift_3_t = {}
	for i=1, gift_3 do
		gift_3_t[i] = pack:readInt()
	end
	local gift_5 = pack:readInt()  --连续充值5天奖励数
	local gift_5_t = {}
	for i=1, gift_5 do
		gift_5_t[i] = pack:readInt()
	end
	local gift_7 = pack:readInt()   --连续充值7天奖励数
	local gift_7_t = {}  
	for i=1, gift_7 do
		gift_7_t[i] = pack:readInt()
	end

	SeriesChongZhiModel:set_data( num_yb, num_day, gift_3_t, gift_5_t, gift_7_t)
end

-- 连续充值领取礼包
function OnlineAwardCC:req_seriescz_get_gift( num_day, index)
	print("c->s(138, 249)OnlineAwardCC:req_seriescz_get_gift ", num_day, index)
	local pack = NetManager:get_socket():alloc( 138, 249 )
	pack:writeInt(num_day)
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

--c->s 138, 250 神龙密塔 请求数据 
function OnlineAwardCC:req_tower_info( activityId )
	local pack = NetManager:get_socket():alloc( 138, 250 )
	pack:writeInt(activityId)
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 138, 250
function OnlineAwardCC:receive_tower_info( pack )
	print('138, 250 receive_tower_info')
	local activityId = pack:readInt()
	local award_num = pack:readInt()	--奖励数量
	local awards_state = {}	--奖励领取状态
	for i = 1, award_num do
		awards_state[i] = pack:readByte()
	end
	local items_state = {}		--条件完成表
	local items_num = pack:readInt()	--条件数量
	for i = 1, items_num do
		local item_id = pack:readInt()	--物品id
		local num = pack:readInt()		--道具数量
		items_state[item_id] = num
	end
	local win = UIManager:find_visible_window("dragon_tower")
	if win then
		win:update(awards_state, items_state)
	end
end

--c->s 138, 251 请求领取神龙密塔奖励
function OnlineAwardCC:req_tower_award(activityId, index)
	print('138, 251')
	local pack = NetManager:get_socket():alloc( 138, 251 )
	pack:writeInt(activityId)
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

-------------- 乾坤兑换
-- c->s 138, 242 请求兑换奖励
function OnlineAwardCC:req_qiankun_award(item_id, item_num)
	local pack = NetManager:get_socket():alloc( 138, 242 )
	pack:writeInt(item_id)
	pack:writeInt(item_num)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 138, 243 请求乾坤兑换信息
function OnlineAwardCC:req_qiankun_info()
	local pack = NetManager:get_socket():alloc( 138, 243 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138, 243 请求乾坤兑换信息返回
function OnlineAwardCC:receive_qiankun_info(pack)
	local chongzhi = pack:readInt()
	local xiaofei = pack:readInt()
	local score = pack:readInt()
	QianKunModel:set_act_info(chongzhi, xiaofei, score)
end

-- c->s 138, 244 请求乾坤兑换物品数量信息
function OnlineAwardCC:req_qiankun_items()
	local pack = NetManager:get_socket():alloc( 138, 244 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 138, 244 请求乾坤兑换物品数量返回
function OnlineAwardCC:rec_qiankun_items(pack)
	local num = tonumber(pack:readChar())
	local tab = {}
	for i = 1, num do
		tab[i] = pack:readInt()
	end
	QianKunModel:set_items(tab)
end