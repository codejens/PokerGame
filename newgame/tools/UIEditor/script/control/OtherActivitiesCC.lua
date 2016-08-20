-- OtherActivitiesCC.lua
-- created by hcl on 2014-2-15
-- 其他活动 149


OtherActivitiesCC = {}

-- c->s 149,1 获取登录礼包信息
function OtherActivitiesCC:req_login_gift()
	local pack = NetManager:get_socket():alloc(149,1);
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 149,1 发送登录礼包信息
function OtherActivitiesCC:do_login_gift( pack )
	local award_state = pack:readByte();		-- 0不可领取1可领取2已领取
	BigActivityModel:set_activity_data( ServerActivityConfig.ACT_TYPE_HEFUHUODONG, {award_state} )
end

-- c->s 149,2 领取登录礼包
function OtherActivitiesCC:req_get_login_gift_award()
	local pack = NetManager:get_socket():alloc(149,2);
	NetManager:get_socket():SendToSrv(pack)	
end

-- c->s 149,3 获取阵营试炼排行榜信息
function OtherActivitiesCC:req_camp_battle_rank_info( )
	local pack = NetManager:get_socket():alloc(149,3);
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 149,3 发动阵营试炼排行榜信息
function OtherActivitiesCC:do_camp_battle_rank_info(pack)
	local rank_num = pack:readInt();		 -- 多少项   
	local cell_t = {}                        -- 排行榜项
	for i = 1, rank_num do 
		local cell = BigActivityRankStruct( pack )
		table.insert( cell_t, cell )
	end
	BigActivityModel:set_rank_date( ServerActivityConfig.ACT_TYPE_HEFUHUODONG, 14, cell_t )
end

-- c->s 149,4 领取阵营试炼奖励
function OtherActivitiesCC:req_camp_battle_rank__award( rank_index )
	print("领取阵营试炼奖励")
	local pack = NetManager:get_socket():alloc(149,4);
	pack:writeInt(rank_index);
	NetManager:get_socket():SendToSrv(pack)	
end

-- c->s 149,5 获取充值礼包信息
function OtherActivitiesCC:req_recharge_gift_info(  )
	local pack = NetManager:get_socket():alloc(149,5);
	NetManager:get_socket():SendToSrv(pack)		
end

-- s->c 149,5 发送充值礼包信息
function OtherActivitiesCC:do_recharge_gift_info( pack )
	local recharge_yuanbao = pack:readInt();		--已充值多少元宝
	local get_award_left_yuanbao = pack:readInt();	--还差多少元宝可以领奖
	local award_state = pack:readByte();			--领奖状态
	BigActivityModel:set_activity_data( ServerActivityConfig.ACT_TYPE_HEFUHUODONG, {award_state} )
end

-- c->s 149,6 领取充值礼包
function OtherActivitiesCC:req_recharge_gift()
	local pack = NetManager:get_socket():alloc(149,6);
	NetManager:get_socket():SendToSrv(pack)		
end

-- c->s 149,7 获取天元之战信息
function OtherActivitiesCC:req_tyzz_info(  )
	print(" OtherActivitiesCC:req_tyzz_info(  )")
	local pack = NetManager:get_socket():alloc(149,7);
	NetManager:get_socket():SendToSrv(pack)		
end

-- s->c 149,7 发送天元之战信息
function OtherActivitiesCC:do_tyzz_info( pack )
	local tyzz_info_tab = {};
	tyzz_info_tab.guild_master_award_state = pack:readInt();		-- 第一名宗主奖励信息 第0位表示是否有这个奖励 0没有1有
															-- 第1位表示是否已领取 0 没有1有
	tyzz_info_tab.guild_member_award_state = pack:readInt();		-- 成员奖励信息 0-9位表示是否有某一名次的奖励 10 位表示是否已领取
	local rank_num = pack:readInt();						-- 排行榜项个数
	tyzz_info_tab.guild_names = {};
	for i=1,rank_num do
		-- 为了和模板的排行数据一样。。。特意写成这样
		tyzz_info_tab.guild_names[i] = {};
		tyzz_info_tab.guild_names[i].player_name = pack:readString();		--仙宗名称
		-- tyzz_info_tab.guild_names[i].player_name = "山勘道具";		--仙宗名称
	end
	print("guild_master_award_state,guild_member_award_state",tyzz_info_tab.guild_master_award_state,
		tyzz_info_tab.guild_member_award_state,#tyzz_info_tab.guild_names)
	BigActivityModel:set_rank_date( ServerActivityConfig.ACT_TYPE_HEFUHUODONG, 15, tyzz_info_tab )
end

-- c->s 149,8 领取天元之战奖励
function OtherActivitiesCC:req_get_tyzz_award( award_type,ranking )
	local pack = NetManager:get_socket():alloc(149,8);
	pack:writeInt( award_type );		-- 领取奖励类型		0成员奖励 1第一名宗主奖励
	pack:writeInt( ranking );			-- 仙宗排名
	NetManager:get_socket():SendToSrv(pack)		
end


--s->c 149,9
-- --七日狂欢
-- 同 200,10
function OtherActivitiesCC:do_seven_day_activity_info( pack)
local remain_time = pack:readInt() - 1
	local num = pack:readInt()
	local get_state = {}
	print("remain_time,num",remain_time,num)
	for i = 1, num do
		local tlevel = pack:readInt()
		local tstate = pack:readInt()
		get_state[i] = { level = tlevel, state = tstate }
		print("get_state[i].level, get_state[i].state",get_state[i].level, get_state[i].state)
	end
	sevenDayAwardModel:update_info( remain_time, get_state )
end


--c->s 149,9  查看或者领取七日活动礼包
function OtherActivitiesCC:check_seven_day_award_state(ttype, index)
	-- print("ClosedBateActivityCC:check_seven_day_award_state ttype, index",ttype, index)
	local pack = NetManager:get_socket():alloc( 149, 9)
	pack:writeInt( ttype )
	pack:writeInt( index )
	NetManager:get_socket():SendToSrv(pack)
end

