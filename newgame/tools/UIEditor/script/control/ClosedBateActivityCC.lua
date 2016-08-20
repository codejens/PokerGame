-- ClosedBateActivityCC.lua
-- created by fjh on 2013-7-23
-- 封测活动

ClosedBateActivityCC = {}


-- 领取等级奖励
-- c->s 200,1
function ClosedBateActivityCC:req_level_award( type, index )
	local pack = NetManager:get_socket():alloc(200, 1);
	-- print("领取等级奖励",type,index);
	pack:writeInt( type );
	if type == 1 then
		-- print("------领取等级奖励",index);
		pack:writeInt( index );
	end
	NetManager:get_socket():SendToSrv(pack);
end
-- s->c 200,1
function ClosedBateActivityCC:do_level_award( pack )
	local count = pack:readInt();
	local level_award = {};
	for i=1,count do
		local level = pack:readInt();
		-- 領取狀態，0不能領取，1可領取，2已經領取
		local get_status = pack:readInt();
		level_award[i] = { level = level, status = get_status};
		--print("等级奖励",level,get_status);
	end
	ClosedBateActivityModel:do_level_award( level_award );
end

-- 领取登录奖励
-- c->s 200,2
function ClosedBateActivityCC:req_daily_login_award( type, index )
	local pack = NetManager:get_socket():alloc(200, 2);
	pack:writeInt( type );
	if type == 1 then
		pack:writeInt( index );
	end
	NetManager:get_socket():SendToSrv(pack);
end
-- s->c 200,2
function ClosedBateActivityCC:do_daily_login_award( pack )
	local count = pack:readInt();

	local login_award = {};
	for i=1,count do
		-- 登陸的天數
		local day_count = pack:readInt();
		-- 領取狀態，0不能領取，1可領取，2已經領取
		local get_status = pack:readInt();
		login_award[i] = {day = day_count, status = get_status};
		-- print("登录奖励",day_count,get_status);
	end
	ClosedBateActivityModel:do_daily_login_award( login_award )

end

-- 领取每日时段奖励
-- c->s 200,3
function ClosedBateActivityCC:req_online_period_award( type, index )
	local pack = NetManager:get_socket():alloc(200, 3);
	pack:writeInt( type );
	if type == 1 then
		pack:writeInt(index);
	end
	NetManager:get_socket():SendToSrv(pack);
end
-- s->c 200,3
function ClosedBateActivityCC:do_online_period_award( pack )
	--第一個時段的領取狀態
	local first_period_status = pack:readInt();
	-- 第二個時段的領取狀態
	local second_period_status = pack:readInt();
	-- print("每日时段奖励",first_period_status,second_period_status);
	local data = {{status = first_period_status},{status = second_period_status}};

	ClosedBateActivityModel:do_online_period_award( data );
end

-- 领取活跃奖励
-- c->s 200,4
function ClosedBateActivityCC:req_activity_award( type, index )
	local pack = NetManager:get_socket():alloc(200, 4);
	pack:writeInt(type);
	if type == 1 then
		pack:writeInt( index );
	end
	NetManager:get_socket():SendToSrv(pack);


end
-- s->c 200,4
function ClosedBateActivityCC:do_activity_award( pack )
	-- 
	local count = pack:readInt();
	local activity_award = {};
	for i=1,count do
		-- 活躍度
		local activity_num = pack:readInt();
		-- 
		local get_status = pack:readInt();
		activity_award[i] = { activity_num = activity_num, status = get_status };
		--print("活躍度奖励",activity_num,get_status);
	end
	ClosedBateActivityModel:do_activity_award( activity_award )

end

-- 领取在线时长奖励
-- c->s 200,5
function ClosedBateActivityCC:req_onlin_duration_award( type, index )
	local pack = NetManager:get_socket():alloc(200, 5);
	pack:writeInt(type);
	if type == 1 then
		pack:writeInt( index );
	end
	NetManager:get_socket():SendToSrv(pack);
end
-- s->c 200,5
function ClosedBateActivityCC:do_online_duration_award( pack )

	local online_time = pack:readInt();
	-- print("在线时长,",online_time);
	local count = pack:readInt();
	local online_award = {};
	for i=1,count do
		local online_duration = pack:readInt();
		local get_status = pack:readInt();
		online_award[i] = {time = online_duration, status = get_status};
		-- print("在线奖励",online_duration,get_status);
	end
	ClosedBateActivityModel:do_online_duration_award( online_time, online_award );

end

-- 活动开启或关闭
-- s->c 200,6 
function ClosedBateActivityCC:do_fc_activity_is_open( pack )
	local is_open = pack:readInt();
	-- print("活动开启或关闭",is_open);
	ClosedBateActivityModel:set_activity_open_status( is_open )
end


-- 获取封测修仙奖励状态
-- c->s 200,7
function ClosedBateActivityCC:req_xiuxian_award_status(  )
	local pack = NetManager:get_socket():alloc(200, 7);
	NetManager:get_socket():SendToSrv(pack);
end
-- s->c 200,7
function ClosedBateActivityCC:do_xiuxian_award_status( pack )
	
	local count = pack:readInt();
	local xiuxian_award_dict = {};
	for i=1,count do
		--1 人物等级 2 人物战斗力 3 宠物战斗力 4 坐骑战斗力 5 翅膀战斗力 6 法宝战斗力 7 成就 8 灵根 9 渡劫 10 封神台
		local target_id = pack:readInt();
		--0 未领取1 可领取2 已领取
		local award_status = pack:readInt();
		-- print("修仙初成",target_id,award_status);
		xiuxian_award_dict[i] = {id = target_id, status = award_status};
	end

	ClosedBateActivityModel:do_xiuxian_award_status( xiuxian_award_dict );
end
-- 领取修仙初成
-- c->s 200,8
function ClosedBateActivityCC:req_get_xiuxian_award( award_id )
	-- print("领取了修仙初成",award_id);
	local pack = NetManager:get_socket():alloc(200, 8);
	pack:writeInt(award_id);
	NetManager:get_socket():SendToSrv(pack);
end


-- 获取媒体礼包/激活cdkey
-- c->s 138,46
function ClosedBateActivityCC:req_active_cd_key( key )
	local pack = NetManager:get_socket():alloc(138, 46);
	pack:writeString( key );
	NetManager:get_socket():SendToSrv(pack);
end

function ClosedBateActivityCC:req_meitilibao(index)
	local pack = NetManager:get_socket():alloc(200, 9)
	pack:writeInt( index )
	NetManager:get_socket():SendToSrv( pack )
end

function ClosedBateActivityCC:do_meitilibao(pack)
	local state = pack:readInt()
	ClosedBateActivityModel:update_meitilibao(state)
end

function ClosedBateActivityCC:check_seven_day_award_state(ttype, index)
	print("ClosedBateActivityCC:check_seven_day_award_state ttype, index",ttype, index)
	local pack = NetManager:get_socket():alloc( 200, 10)
	pack:writeInt( ttype )
	pack:writeInt( index )
	NetManager:get_socket():SendToSrv(pack)
end

function ClosedBateActivityCC:update_seven_day_award_info(pack)
	local remain_time = pack:readInt() - 1
	local num = pack:readInt()
	local get_state = {}
	-- print("remain_time,num",remain_time,num)
	for i = 1, num do
		local tlevel = pack:readInt()
		local tstate = pack:readInt()
		get_state[i] = { level = tlevel, state = tstate }
		-- print("get_state[i].level, get_state[i].state",get_state[i].level, get_state[i].state)
	end
	sevenDayAwardModel:update_info( remain_time, get_state )
end

-- 200,11 通知登录好礼活动的开启或者关闭
function ClosedBateActivityCC:do_login_award_win_visible(pack)
	local open_or_close = pack:readInt();		--0关闭1开启
	if open_or_close == 1 then 
		local win = UIManager:find_visible_window( "right_top_panel" )
		if win then
			-- win:insert_btn(6)
		end
	elseif open_or_close == 0 then
		local win = UIManager:find_window( "right_top_panel" )
		if win then
			win:remove_btn(6)
		end
	end
end

-- 200,12 获取每天的登录好礼翻牌的剩余次数
function ClosedBateActivityCC:req_fp_count(  )
	print("ClosedBateActivityCC:req_fp_count(  )")
	local pack = NetManager:get_socket():alloc( 200, 12)
	NetManager:get_socket():SendToSrv(pack)	
end

-- 200,12 获取每天的登录好礼剩余次数
function ClosedBateActivityCC:do_fp_count( pack )
	local count = pack:readInt();
	local day = pack:readInt();
	local week_day = pack:readInt();
	print("ClosedBateActivityCC:do_fp_count( pack )",count)
	LoginAwardModel:set_fp_count( count,day,week_day );
end

-- 200,13 登录好礼开始翻牌
function ClosedBateActivityCC:req_start_fp( index )
	print("ClosedBateActivityCC:req_start_fp()");
	local pack = NetManager:get_socket():alloc( 200, 13)
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)		
end

-- 200,13 登录好礼开始翻牌返回
function ClosedBateActivityCC:do_start_fp( pack )
	local item_id = pack:readInt();

	print("ClosedBateActivityCC:do_start_fp()",item_id);
	local win = UIManager:find_visible_window( "login_award_win" )
	if win then
		win:on_fp_result( item_id );
	end
end

-- 200,14
function ClosedBateActivityCC:req_login_award_p( )
	print("ClosedBateActivityCC:req_login_award_p( )")
	local pack = NetManager:get_socket():alloc( 200, 14)
	NetManager:get_socket():SendToSrv(pack)	
end

function ClosedBateActivityCC:do_login_award_p( pack )
	print("ClosedBateActivityCC:do_login_award_p( pack )")
	local num = pack:readInt();
	print("num = ",num)
	local item_tab = {};
	for i=1,9 do
		item_tab[i] = {};
		item_tab[i].item_id = pack:readInt();		-- 物品id
		item_tab[i].type = pack:readInt();		-- 是否已翻牌 1已经翻牌 0没有翻
		print("item_tab[i].item_id,item_tab[i].type",item_tab[i].item_id,item_tab[i].type)
	end
	LoginAwardModel:set_login_award_item_tab( item_tab );
end

-- 200,15 获取登录好礼累计登录的奖励
function ClosedBateActivityCC:req_accept_login_award( _type )
	local pack = NetManager:get_socket():alloc( 200, 15)
	pack:writeInt(_type)
	NetManager:get_socket():SendToSrv(pack)		
end

function ClosedBateActivityCC:do_accept_login_award( pack )
	local state = pack:readInt();
	print("ClosedBateActivityCC:do_accept_login_award( pack )",state)
	LoginAwardModel:set_award_state( state );
	local win = UIManager:find_visible_window("login_award_win")
	if win then 
		if state == 0 or state == 2 then
			win:update_lj_btn_state( false )
		else
			win:update_lj_btn_state( true )
		end
	end
end

-- 幸运猜猜功能下发协议，暂时去掉该功能.
-- 200,16 
function ClosedBateActivityCC:do_luck_guess_win_visible( pack )

	-- local state = pack:readInt();
	-- if state == 1 then 
	-- 	local win = UIManager:find_visible_window( "right_top_panel" )
	-- 	if win then
	-- 		win:insert_btn(7)
	-- 	end
	-- elseif state == 0 then
	-- 	local win = UIManager:find_visible_window( "right_top_panel" )
	-- 	if win then
	-- 		win:remove_btn(7)
	-- 	end
	-- end
end

-- 200,17
function ClosedBateActivityCC:req_luck_guess_count()
	print("ClosedBateActivityCC:req_luck_guess_count( )")
	local pack = NetManager:get_socket():alloc( 200, 17)
	NetManager:get_socket():SendToSrv(pack)		
end

function ClosedBateActivityCC:do_luck_guess_count( pack )
	local count = pack:readInt();
	print("ClosedBateActivityCC:do_luck_guess_count( pack )",count)
	LoginAwardModel:set_guest_count( count )
end

-- 200,18 获取幸运猜猜的牌
function ClosedBateActivityCC:req_luck_guess_p(  )
	local pack = NetManager:get_socket():alloc( 200, 18)
	NetManager:get_socket():SendToSrv(pack)			
end

function ClosedBateActivityCC:do_luck_guess_p( pack )
	print("ClosedBateActivityCC:do_luck_guess_p( pack )")
	local num = pack:readInt();
	local item_tab = {};
	for i=1,num do
		item_tab[i] = pack:readInt();
		print("item_tab[i]",item_tab[i]);
	end
	LoginAwardModel:set_guest_item_tab( item_tab )
end

-- 200,19 开始猜猜
function ClosedBateActivityCC:req_start_guess()
	local pack = NetManager:get_socket():alloc( 200, 19)
	NetManager:get_socket():SendToSrv(pack)			
end

function ClosedBateActivityCC:do_start_guess( pack )
	local num = pack:readInt();
	local item_tab = {};
	for i=1,num do
		item_tab[i] = pack:readInt();
	end
	local win = UIManager:find_visible_window("luck_guest_win")
	if win then
		win:play_animation( item_tab )	
	end
end

-- 200,20
function ClosedBateActivityCC:req_open_b( index )
	print(" ClosedBateActivityCC:req_open_b( index )",index)
	local pack = NetManager:get_socket():alloc( 200, 20)
	pack:writeInt( index );
	NetManager:get_socket():SendToSrv(pack)		
end

function ClosedBateActivityCC:do_open_b( pack )

	local item_id = pack:readInt();
	print(" ClosedBateActivityCC:do_open_b(  )",item_id)
	local win = UIManager:find_visible_window("luck_guest_win")
	if win then
		win:on_open_b( item_id );
	end
end

-- 200,21 申请服务器洗牌
function ClosedBateActivityCC:req_start_xp(  )
	print(" ClosedBateActivityCC:req_start_xp")
	local pack = NetManager:get_socket():alloc( 200, 21)
	NetManager:get_socket():SendToSrv(pack)		
end

function ClosedBateActivityCC:do_start_xp( pack )
	print(" ClosedBateActivityCC:do_start_xp")
	local num = pack:readInt();
	print("num = ",num)
	local item_tab = {};
	for i=1,9 do
		item_tab[i] = {};
		item_tab[i].item_id = pack:readInt();		-- 物品id
		item_tab[i].type = pack:readInt();		-- 是否已翻牌 1已经翻牌 0没有翻
		print("item_tab[i].item_id,item_tab[i].type",item_tab[i].item_id,item_tab[i].type)
	end
	LoginAwardModel:set_login_award_item_tab( item_tab,true );
	local win = UIManager:find_visible_window("login_award_win")
	if win then
		win:start_fp_action()
	end
end
