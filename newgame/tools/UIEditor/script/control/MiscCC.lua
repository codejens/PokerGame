-- MiscCC.lua
-- create by hcl on 2013-1-29
-- Misc子系统 139

-- super_class.MiscCC()
MiscCC = {}

-- c->s 139,7
-- 立即传送
function MiscCC:req_teleport(scene_id,scene_name,scene_x,scene_y)
	-- print("立即传送",scene_id,scene_name,scene_x,scene_y)
	local pack = NetManager:get_socket():alloc(139,7);
	pack:writeWord(scene_id);
	pack:writeString(scene_name);
	pack:writeWord(scene_x);
	pack:writeWord(scene_y);
	NetManager:get_socket():SendToSrv(pack);
end

-- 复活框使用什么复活 139.40
function MiscCC:req_relive(type, money_type)
	-- 使用什么复活,1复活点复活,2原地复活(需要复活石),3原地复活(消耗元宝)
	-- print("我要复活", type, money_type)
	local pack = NetManager:get_socket():alloc(139,40);
	pack:writeInt(type);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 发送复活对话框 139.40
function MiscCC:do_relive(pack)
	-- print("MiscCC:do_relive 服务器提示复活");
	local relive_time = pack:readInt();	--复活时间
	local camp_id	  = pack:readInt();--阵营id
	local killer_id   = pack:readInt();--杀人者id
	local pet_id	  = pack:readInt();--宠物id
	local killer_level = pack:readInt();--杀人者等级
	local killer_sex  = pack:readInt();--杀人者性别
	local killer_job = pack:readInt();--杀人者职业
	local killer_name = pack:readString();--杀人者名字
	local master_name = pack:readString();--主人的名字

	--镇妖塔副本不提示复活 add by tjh
	local fuben_id = FubenCenterModel:get_current_fb_id(  )
	if fuben_id == 119 then
		return 
	end
	
	local player = EntityManager:get_player_avatar();
	-- print("!!!!MiscCC:do_relive(角色,阵营id,阵营)",player.name,camp_id,Lang.camp_name_ex[camp_id])
	player:show_resurretionDialog_dialog( killer_name );
end

--招财事件
--c->s,139,31
function MiscCC:request_zhaocai( type )
	local pack = NetManager:get_socket():alloc(139, 31)
	pack:writeByte(0)
	pack:writeByte(type)
	NetManager:get_socket():SendToSrv(pack)
end

--招财事件回调
-- s->c 139,32
function MiscCC:do_zhaocai( pack )
	--状态码：10：元宝换铜币成功 11：批量元宝换铜币成功 20：元宝换银币成功 21：批量元宝换银币成功
		--	  -1：元宝不足 -11：元宝换银币次数不足 -12：元宝换铜币次数不足
	local status_code = pack:readChar();
	local num = pack:readInt();	--今天已经招财的次数
	-- print("MiscCC:do_zhaocai(status_code,num)",status_code,num)
	if status_code == 20 or status_code == 21 then
		ZhaoCaiModel:set_has_zc_num(num)
		ZhaoCaiModel:do_zhaocai_success()
	elseif status_code == 10 or status_code == 11 then
		ZhaoCaiModel:set_has_jinbao_num(num)
		ZhaoCaiModel:do_jinbao_success()
	else

	end
end

--------------------渡劫系统
-- c->s 	139,41  获取渡劫关卡信息
function MiscCC:request_dujie_info( )
	-- print("－－－－－－－－－请求渡劫信息");
	local pack = NetManager:get_socket():alloc(139, 41);
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 	139,41 返回渡劫关卡信息
function MiscCC:do_dujie_info( pack )

	local count = pack:readInt();--渡劫数量

	-- print("－－－－－－－－－请求渡劫信息",count);
	local star_table = {};
	local yb_table = {};--获取元宝的状态
	for i=1,count do 
		star_table[i] = pack:readByte()-1;
		yb_table[i]   = pack:readChar();

		-- ZXLog("－－－－－－渡劫关卡",star_table[i],yb_table[i]);
	end
	DujieModel:update_dujie_info(star_table,yb_table);

end

-- 进入渡劫副本
-- c->s 	139,42
function MiscCC:request_enter_dujie( jingjie_index )
	local pack = NetManager:get_socket():alloc(139, 42);
	pack:writeInt(jingjie_index);
	NetManager:get_socket():SendToSrv(pack);
end

-- 渡劫成功
-- s->c 	139,42
function MiscCC:do_dujie_succss( pack )
	--当前第几阶
	local jingjie = pack:readInt()
	--评价，星级
	local star = pack:readInt()-1;
	--是否是第一次渡劫
	local frist_dujie = pack:readInt();
	-- print("MiscCC:do_dujie_succss( pack )")
	DujieModel:dujie_succss_callback(jingjie,star,frist_dujie);	
end

-- 渡劫失败
-- s->c 	139,43
function MiscCC:do_dujie_fail( )
	-- 渡劫失败，回调model
	-- print("MiscCC:do_dujie_fail( )")
	DujieModel:dujie_fail_callback();
end

-- 退出渡劫
-- c->s 	139,43
function MiscCC:request_exit_dujie( )
	-- print("MiscCC:request_exit_dujie( )")
	local pack = NetManager:get_socket():alloc(139, 43);
	NetManager:get_socket():SendToSrv(pack);
end


-- c->s 	139,37	--接受刷星任务
function MiscCC:req_receive_quest(quest_id)
	print("MiscCC:req_receive_quest(quest_id)",quest_id)
	local pack = NetManager:get_socket():alloc(139, 37);
	pack:writeInt(quest_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- c->s 	139,38	--任务刷星		
function MiscCC:req_refresh_quest_star(quest_id,is_max_lv, money_type)
	print("=====req_refresh_quest_star: ", quest_id, is_max_lv, money_type)
	print("req_refresh_quest_star")
	local pack = NetManager:get_socket():alloc(139, 38);
	pack:writeInt(quest_id);
	pack:writeByte(is_max_lv);		--1,是,0否
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- c->s 	139,39	--完成刷新任务		
function MiscCC:req_finish_quest_star(quest_id,is_quick_finish, money_type)
	-- print("====req_finish_quest_star===", quest_id, is_quick_finish, money_type)
--	print("req_finish_quest_star")
	local pack = NetManager:get_socket():alloc(139, 39);
	pack:writeInt(quest_id);
	pack:writeByte(is_quick_finish);		--1,是,0否
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 	139,37 -- 任务刷新结果
function MiscCC:do_refresh_quest_star(pack)
	--print("do_refresh_quest_star")
	local star_quest_type = pack:readInt();				-- star_quest_id,刷星任务id 实际上就是刷星任务类型
	local level = pack:readInt();	--level, 等级段
	local star_lv = pack:readInt();	--star_lv, 星级
	local quest_id = pack:readInt();	--quest_id,任务id
	local left_refresh_star_count = pack:readInt();--left_refresh_star_count,剩余免费刷星次数
	if ( star_quest_type == 1 ) then
		ZYCMWin:on_refresh_quest_star( star_quest_type,level,star_lv,quest_id,left_refresh_star_count )
	elseif ( star_quest_type == 2 ) then
		local win = UIManager:find_visible_window("hsxn_win");
		if ( win ) then
			win:on_refresh_quest_star( star_quest_type,level,star_lv,quest_id,left_refresh_star_count );
		end
	end
end

-- s->c 139,44 -- 更新刷新任务可接状态
function MiscCC:do_refresh_quest_star_count(pack)
	--print("do_refresh_quest_star_count..........................")
	local star_quest_count = pack:readInt();
	-- 更新次数
	ZYCMWin:set_zycm_count(star_quest_count);
	-- array 暂时不保存
end

-- s->c 139,45 -- 接受刷星任务结果
function MiscCC:do_receive_quest(pack)
	-- 刷星任务类型ID: 1表示为斩妖除魔任务,2表示为护送仙女任务
	local quest_type = pack:readInt();
	local result     = pack:readInt();		--0表示成功
	-- print("do_receive_quest(star_quest_type,result)",star_quest_type,result)
	if ( result == 0 and quest_type == 1 ) then
		local win = UIManager:find_visible_window( "zycm_win" )
		if win then
			win:on_receive_quest();
		end
	end
end

-- c->s 139,50 请求阵营战战场信息
function MiscCC:req_battle_info( )
	local pack = NetManager:get_socket():alloc(139,50);
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 139,50 接受阵营战战场信息
function MiscCC:do_battle_info( pack )
	local battle_count = pack:readInt();
	-- print("MiscCC:do_battle_info(battle_count)",battle_count)
	local battle_info = {};
	for i=1,battle_count do
		local xiaoyao_num = pack:readInt()
		local xingchen_num = pack:readInt()
		local yixian_num = pack:readInt()  
		battle_info[i] = {xiaoyao_num,xingchen_num,yixian_num};
	end
	-- 进入过战场标识,从低位到高位每个bit表示是否进入过站场（1，2，3...）
	battle_info.battle_count = battle_count
	battle_info.enter_flag = pack:readInt()
	-- print("MiscCC:do_battle_info，战场数量,战场标识",#battle_info,battle_info.enter_flag)
	CampBattleModel:do_battle_info( battle_info );
end

-- c->s 139,51 进入战场
function MiscCC:req_enter_battle( battle_id )
	local pack = NetManager:get_socket():alloc(139,51);
	pack:writeInt(battle_id);
	NetManager:get_socket():SendToSrv(pack);
	-- print("MiscCC:req_enter_battle( battle_id )",battle_id)
end

-- s->c 139,51 进入战场结果
function MiscCC:do_enter_battle( pack )
	local battle_id = pack:readInt();
	local status_code = pack:readInt();
	local error_message = pack:readString();
	require "model/CampBattleModel"
	CampBattleModel:do_eneter_battle( battle_id,status_code,error_message );
end
-- c->s 139,53 领取阵营战奖励
function MiscCC:req_battle_reward(  )
	local pack = NetManager:get_socket():alloc(139,53);
	NetManager:get_socket()SendToSrv(pack);
end
-- s->c 139,53 领取阵营战奖励结果
function MiscCC:do_battle_reward( pack )
	local battle_id = pack:readInt();--第几战场
	local result	= pack:readInt();--结果, 0:成功，-1：已经领取，-2：其他
	local message  	= pack:readString();--结果提示。错误时返回的是错误提示
	require "model/CampBattleModel"
	CampBattleModel:do_battle_reward( battle_id, result ,message );
end


-- s->c 139,54 下发阵营战统计信息
function MiscCC:do_zhenying_battle_tongji( pack )
	local battle_id = pack:readInt();	--战场id
	local xiaoyao_score		= pack:readInt();	--逍遥阵营的积分
	local xingchen_score 	= pack:readInt();	--星辰阵营的积分
	local yixian_score		= pack:readInt();	--逸仙阵营的积分
	local my_rank	= pack:readInt();	--我的排名
	local my_score	= pack:readInt();	--我的积分
	local my_kills 	= pack:readInt();	--我的击杀
	local my_assists= pack:readInt();	--我的助攻
	local my_multiKill = pack:readInt();--我的连杀
	-- 排行榜前三名
	local rank_list = {};
	for i=1,3 do
		local zhenying_id = pack:readInt();	--阵营id
		local name 		  = pack:readString();	--名字
		local score 	  = pack:readInt();	--积分
		local skills	  = pack:readInt();	--击杀数
		rank_list[i] = {zhenying_id,name,score,skills};
	end
	
	-- print("my_rank, my_score, my_kills",my_rank, my_score, my_kills)
	local data = {my_rank, my_score, my_kills};
	CampBattleModel:update_battle_data( data );

	local data = {battle_id,xiaoyao_score,xingchen_score,yixian_score,my_rank,my_score,my_kills,my_assists,my_multiKill,rank_list};
	FubenTongjiModel:update_tongji( 59, 0, data );
end

-- s->c 139,57  打阵营战期间的联盟信息
function MiscCC:do_campBattle_league_status( pack )
	
	local xiaoyao_league_status = pack:readByte();
	local xingchen_league_status = pack:readByte();
	local yixian_league_status = pack:readByte();

	local league_dict = {xiaoyao_league_status,xingchen_league_status,yixian_league_status};

	require "model/FubenModel/FubenTongjiModel"
	FubenTongjiModel:update_campBattle_league( league_dict );

	PlayerAvatar:change_lianmeng_state( league_dict );

end

-- s->c 139,52 获取阵营战排行榜信息
function MiscCC:send_camp_battle_top_list_info(pageIndex)
	
	local pack = NetManager:get_socket():alloc(139, 52)
	pack:writeInt(pageIndex)
	NetManager:get_socket():SendToSrv(pack)
	-- print("send battle list info",pageIndex)

end

-- s->s 139, 52 发送阵营战排行榜信息
function MiscCC:receive_camp_battle_top_list_info(pack)
	local self_index = pack:readInt()
	local page_num = pack:readInt()
	local page_index = pack:readInt()
	local num = pack:readInt()
	local battle_info = {}
	for i = 1, num do
		battle_info[i] = TopListBattleStruct(pack)
	end
	--------------
	-- print("MiscCC:receive_camp_battle_top_list_info page_index", page_index)
	TopListModel:add_index_top_list_info( TopListConfig.TopListType.FMSL, page_index - 1, battle_info, page_num )	
	-- TopListModel:add_top_list_info( TopListConfig.TopListType.FMSL, page_index, battle_info )
	-- TopListModel:update_index_scroll_max_num(TopListConfig.TopListType.FMSL, page_num)

end
-- 
-- c->s 139,56 获取阵营战结束后排行榜的信息
function MiscCC:req_camp_battle_result_rank(  )
	print(" c->s 139,56 获取阵营战结束后排行榜的信息")
	local pack = NetManager:get_socket():alloc( 139, 56 );
	pack:writeInt(1);
	NetManager:get_socket():SendToSrv(pack);

end
-- s->c 139,56 返回阵营战结束后排行榜的信息
function MiscCC:do_camp_battle_result_rank( pack )
		print(" s->c 139,56 返回阵营战结束后排行榜的信息")
	-- 自己的排名
	local my_rank = pack:readInt();
	--总共多少页
	local page_sum = pack:readInt();
	--当前的页数
	local current_page = pack:readInt();

	-- 排行榜数据
	local rank_dict = {};
	local count = pack:readInt();

	print("my_rank",my_rank)
	for i=1,count do
		
		local player_id = pack:readInt();
		local player_name = pack:readString();
		local camp = pack:readInt();
		local sex = pack:readInt();
		local job = pack:readInt();
		local level = pack:readInt();
		local kill_num = pack:readInt();
		local assists_num = pack:readInt();
		local multiKill_num = pack:readInt();
		local score = pack:readInt();
		
		rank_dict[i] = { player_id, player_name, camp, sex, job, level, kill_num, assists_num, multiKill_num, score };
		print("阵营战结果",player_id, player_name, camp, sex, job, level, kill_num);
	end
	CampBattleModel:do_camp_battle_result_rank( my_rank, rank_dict );
end



---客户端鲜花赠送
function MiscCC:send_send_flower(number, selecttype, name)
	local pack = NetManager:get_socket():alloc(139,21)
	pack:writeShort(number)
	pack:writeChar(selecttype)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack)
end
---服务器鲜花返回
function MiscCC:receive_flower(pack)
	local num = pack:readWord()
	local name = pack:readString()
	local id = pack:readInt()
	local camp = pack:readInt()
	local job = pack:readInt()
	local level = pack:readInt()
	local sex = pack:readInt()
	local icon = pack:readInt()
	-----------
	require "model/FriendModel/FriendFlowerThankModel"
	--print("id, camp, level, sex, num, name, icon",id, camp, level, sex, num, name, icon)
	FriendFlowerThankModel:add_friend(id, num, camp, job, level, sex, name, icon)

end

--服务器返回增加采集蟠桃次数的元宝
--s->c, 139,62
function MiscCC:do_add_gather_pink_count( pack )
	local has_use_count = pack:readInt();
	local yuanbao		= pack:readInt();
	-- print("下发 增加蟠桃采集次数需要的元宝数");
	require "model/FubenModel/FubenTongjiModel"
	FubenTongjiModel:do_add_gather_count(yuanbao);

end
-- 消费元宝增加采集蟠桃次数
-- c->s,139,32
function MiscCC:req_add_gather_pink_count( money_type )
	
	local pack = NetManager:get_socket():alloc(139,32);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);

end

-- c->s,  139,70  请求经验找回系统数据  date_type : 1是副本积累  2 是日常任务积累
function MiscCC:req_exp_back_date( date_type )
	local pack = NetManager:get_socket():alloc(139,70);
	pack:writeChar( date_type )
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c, 139,70  下发经验找回系统数据
function MiscCC:do_result_exp_back_date( pack )
	local date_type     = pack:readChar()
	local state         = pack:readChar()
	local can_get_exp   = pack:readInt()
	local need_money    = pack:readInt()
	local count         = pack:readInt()
	local list          = {}
	local id_temp       = nil                      -- 临时数据
	local times_temp    = nil                      -- 临时数据
	for i = 1, count do 
        id_temp    = pack:readInt()
        times_temp = pack:readInt()
        list[i] = { id = id_temp, times = times_temp }
	end
	-- print("!!!!!!!!!!!!!!!!!!!!!!!MiscCC:do_result_exp_back_date(date_type, state, can_get_exp, need_money, list)",date_type, state, can_get_exp, need_money, list)
	WelfareModel:set_exp_back_date( date_type, state, can_get_exp, need_money, list )
end

-- c->s,  139,71  领取经验找回系统奖励  类型(1 副本 2 日常任务 )  领取方式（免费， 元宝）
function MiscCC:req_get_exp_back_award( get_type, get_way, money_type )
	--print("MiscCC:req_get_exp_back_award( get_type, get_way )",get_type,get_way)
	local pack = NetManager:get_socket():alloc(139, 71);
	pack:writeChar( get_type )
	pack:writeChar( get_way )
	pack:writeByte( money_type )
	NetManager:get_socket():SendToSrv(pack);
end

-- 进入灵泉仙浴
-- c->s 139,58
function MiscCC:req_enter_xianyu(  )
	local pack = NetManager:get_socket():alloc(139, 58);
	NetManager:get_socket():SendToSrv(pack);
end

-- 灵泉仙浴里的动作
-- c->s 139,59 
function MiscCC:req_xianyu_playActoin( action_id ,target_name)
	--action_id 1为打泡泡，2为戏水
	local pack = NetManager:get_socket():alloc(139, 59);
	pack:writeInt(action_id);		--动作id
	pack:writeString(target_name);	--目标玩家名字
	NetManager:get_socket():SendToSrv(pack);
end

--返回戏水，打泡泡次数
-- s->c 139,60
function MiscCC:do_playAction_count( pack )
	--打泡泡次数
	local paopao_count = pack:readUInt();
	--戏水次数
	local xishui_count = pack:readUInt();

	require "model/XianYuModel"
	XianYuModel:update_play_count(paopao_count,xishui_count);
end

-- 广播灵泉仙浴的玩耍活动
-- s->c 139,59
function MiscCC:do_broadcast_playAction( pack )
	local action_id = pack:readInt();
	local status_code = pack:readInt();
	local target_handle = pack:readUint64();
	require "model/XianYuModel"
	XianYuModel:broadcast_playAction(action_id,status_code,target_handle);
end


-- 服务器下发天元之战的统计数据
-- s->c 139,35
function MiscCC:do_tianyuan_battle_tongji( pack )

	local xianzong_rank = pack:readInt();	--仙宗排名
	local xianzong_score = pack:readInt();	--仙宗积分
	local person_rank = pack:readInt();		--个人排名
	local person_score = pack:readInt();	--个人积分
	
	local num = pack:readInt();				--个人积分排行榜
	local person_rank_dict = {};
	for i=1,num do
		local name = pack:readString();
		local score = pack:readInt();
		person_rank_dict[i] = {name=name,score=score};
		
	end

	local num = pack:readInt();				--仙宗积分排行榜
	local xianzong_rank_dict = {};
	for i=1,num do
		local name = pack:readString();
		local score = pack:readInt();
		xianzong_rank_dict[i] = {name=name,score=score};
		
	end
	
	local boss_refresh_time = pack:readInt();
	local boss_pos_x = pack:readInt();
	local boss_pos_y = pack:readInt();

	-- print("暗夜天魔boss",boss_refresh_time,boss_pos_x,boss_pos_y);

	require "model/FubenModel/FubenTongjiModel"
	local data = {xianzong_rank,xianzong_score,person_rank,person_score,person_rank_dict,xianzong_rank_dict,boss_refresh_time,boss_pos_x,boss_pos_y};
	FubenTongjiModel:update_tongji( 999, 1, data );

end

-- 请求下发天元之战的统计数据
-- c->s 139,35
function MiscCC:req_tianyuan_battle_tongji( )
	local pack = NetManager:get_socket():alloc(139, 35);
	NetManager:get_socket():SendToSrv(pack);
end


-- 副本里掉落宝箱
-- s->c 139,47
function MiscCC:do_drop_chest_in_fuben( pack )
	local num = pack:readInt();
	local item = {};
	
	print(" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!@#@!MiscCC:do_drop_chest_in_fuben(num)",num)
	for i=1,num do
		item.item_id = pack:readInt();			--物品id
		item.item_count = pack:readInt();		--物品数量
		item.item_quality = pack:readInt();	--物品质量
		item.item_strengthen = pack:readInt();	--物品强化
		item.is_bangding = pack:readInt();		--是否绑定
	end
	require "model/FubenModel/FuBenModel"
	FuBenModel:do_drop_chest(item);
end

-- 打开宝箱
-- c->s 139,47
function MiscCC:req_open_chest_in_fuben(  )
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!MiscCC:req_open_chest_in_fuben(  )")
	local pack = NetManager:get_socket():alloc(139, 47);
	NetManager:get_socket():SendToSrv(pack);
end

-- 赏金副本里下发赏金怪物得到的金钱
-- s->c 139,46
function MiscCC:do_shangjin_money( pack )
	local monster_handle = pack:readUint64();
	local base_money = pack:readInt();
	local all_money = pack:readInt();

	require "model/FubenModel/FuBenModel"
	FuBenModel:set_shangjin_money( base_money,all_money );
end

-- -- c->s 139,36
-- -- 请求填本帮派天元之战统计数据
function MiscCC:request_tianyuan_range(  )
	local pack = NetManager:get_socket():alloc(139, 36);
	NetManager:get_socket():SendToSrv(pack);
end

-- -- s->c 139,36
-- -- 服务器 下发天元之战排名
function MiscCC:do_result_self_guild_tianyuan_range( pack )
	local guild_range        = pack:readInt()               -- 仙宗排名
	local guild_score        = pack:readInt()               -- 仙宗积分
	local guild_range_count  = pack:readInt()               -- 仙宗排名数量
	local guild_range_list   = {}                           -- 仙宗排名列表
	for i = 1, guild_range_count do
        local one_guild_range = {}
        one_guild_range.name  = pack:readString()           -- 名称
        one_guild_range.score = pack:readInt()              -- 积分
        table.insert( guild_range_list, one_guild_range )
	end

	require "model/GuildModel"
	GuildModel:set_tianyuan_range_info( guild_range, guild_score, guild_range_list )

end

-- 神秘商店 购买物品
-- c->s 139,61 
function MiscCC:req_buy_mystical_item( shop_id ,item_id, count, money_type )
	local pack = NetManager:get_socket():alloc(139, 61);
	pack:writeInt(shop_id) 
	pack:writeInt(item_id) 
	pack:writeInt(count) 
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- vip体验卡 ，服务器下发剩余的体验时间
-- s->c 139, 65
function MiscCC:do_vip_experience_time( pack )
	
	local time = pack:readInt();
	VIPModel:set_expe_vip_time( time );

	print("vip体验剩余的时间",time);
end

-- 请求某个场景里的所有NPC的任务状态
-- s->c 139, 72
function MiscCC:req_npc_task_status( scene_id )
	local pack = NetManager:get_socket():alloc(139, 72);
	pack:writeInt(scene_id);
	-- print("请求所有NPC的任务状态",scene_id);
	NetManager:get_socket():SendToSrv(pack);
end
function MiscCC:do_npc_task_status( pack )
	-- 场景id
	local scene_id = pack:readInt();
	local count = pack:readInt();
	local npcs = {};
	local tb_index = 0
	for i=1,count do
		-- npc的entity id
		local npc_name = pack:readString();
		-- 任务状态 , 4种状态: 0 = 无任务, 1 = 有可接任务(黄色感叹号), 2 = 有已完成任务(黄色问号), 3 = 有正在进行中的任务(灰色问号)
		local task_status = pack:readInt();
		-- print("npc任务状态",npc_name, task_status);
		if npc_name ~= "淘宝树" then tb_index = i end
		npcs[i] = {name = npc_name, status = task_status};
	end
	-- 客户端这边暂时屏蔽掉淘宝树的NPC状态下发 by hwl
	if tb_index ~= 0 then
		table.remove(npcs, tb_index)
	end
	MiniMapModel:do_npc_task_status( scene_id, npcs );
end

-- 播放获取物品特效
-- 1：在线奖励
-- 2：拾取
-- 3：任务奖励
-- 4：使用礼包
-- 5：目标奖励
-- 6：成就奖励
-- 7：短期目标奖励
-- 8：周环任务阶段奖励
-- 9：大厅连续登录奖励
--139,67
function MiscCC:do_play_get_item_effect( pack )
	local item_from = pack:readInt(); 	-- 物品来源
	local item_num  = pack:readInt();	-- 物品个数
	-- print("----------------------------------播放获取物品特效",item_from,item_num);
	local item_effect_table = {};
	for i=1,item_num do
		item_effect_table[3*(i-1)+1] = pack:readInt();	--奖励类型(1为物品,2为金钱,3为宝石材料)
		item_effect_table[3*(i-1)+2] = pack:readInt();	--物品ID或经验类型
		item_effect_table[3*(i-1)+3] = pack:readInt();	--物品或金钱数量
	end
	--播放特效
	LuaEffectManager:play_get_items_effect( item_effect_table )
end

-- 播放获取经验特效
--139,68
function MiscCC:do_play_exp_effect( pack )
	local exp = pack:readInt();
	LuaEffectManager:play_get_exp_effect( exp );
end


-- 设置同屏人数限制
-- c->s 139, 73
function MiscCC:req_limit_display_player(  count )
	-- print("设置同屏人数限制  c->s 139, 73  ", count)
	local pack = NetManager:get_socket():alloc(139, 73);
	pack:writeInt(count)  
	NetManager:get_socket():SendToSrv(pack);
end

-- 请求签到 139,75
function MiscCC:req_qd()
	-- print(LangGameString[449]) -- [449]="申请签到.............................."
	local pack = NetManager:get_socket():alloc(139, 75);
	NetManager:get_socket():SendToSrv(pack);
	QianDaoModel:set_request_qian_dao(true)
end

-- 请求补签 139,76
function MiscCC:req_bq( day )
	--print("申请补签...........................")
	local pack = NetManager:get_socket():alloc(139, 76);
	pack:writeChar(day)
	NetManager:get_socket():SendToSrv(pack);
end

-- 请求领取签到宠物奖励 139,77
function MiscCC:req_accept_qd_pet(  )
	local pack = NetManager:get_socket():alloc(139, 77);
	NetManager:get_socket():SendToSrv(pack);
end

-- 请求领取每天签到奖励 139 78
function MiscCC:req_accept_award( award_index )
	local pack = NetManager:get_socket():alloc(139, 78);
	pack:writeChar( award_index );
	NetManager:get_socket():SendToSrv(pack);
end

-- 下发每日签到的已签数据 139 75
function MiscCC:do_get_qd_info( pack )
	local qd_days = pack:readChar();		-- 签到的天数
	local qd_day_table = {};
	for i=1,qd_days do
		local qd_day = pack:readChar();
	--	print("第"..qd_day .. "签到了。。。")
		qd_day_table[qd_day] = 1;
	end
	local left_days = pack:readShort();		--签到送宠物活动的剩余天数
	local max_days 	= pack:readShort();		--签到送宠物需要签到的总天数
	local is_accept_pet = pack:readChar(); 	--签到送宠物是否已领 0=未领，1=已领
	local had_replenish_qd = pack:readChar() -- 是否已经补签
	local qd_info = {};
	qd_info.qd_days = qd_days;
	qd_info.qd_day_table = qd_day_table;
	qd_info.left_days = left_days;
	qd_info.max_days = max_days;
	qd_info.is_accept_pet =is_accept_pet;
	qd_info.had_replenish_qd = had_replenish_qd
	QianDaoModel:set_qd_info( qd_info );
	-- 通知签到界面更新
	local win = UIManager:find_visible_window("benefit_win");
	if ( win ) then
		win:update_qd_state(  )
	end
	-- sevenDayAwardModel:auto_qian_dao()
    -- print("==========MiscCC:do_get_qd_info===============!!!!!!@@@!!!@@@!!!@@@@@@===========", qd_days, left_days, max_days, is_accept_pet, had_replenish_qd)
end

-- 下发每日签到当月的奖励领取情况 139 76
function MiscCC:do_get_award_accept_info( pack )
	local qd_award_info = {};
	local award_nums = pack:readChar();
	for i=1,award_nums do
		local award_id = pack:readChar();
		local is_accept = pack:readChar();
	--	print("award_id = ",award_id,"is_accept = ",is_accept);
		qd_award_info[award_id] = is_accept;
	end
	QianDaoModel:set_qd_award_info( qd_award_info );
	-- 通知签到界面更新
	local win = UIManager:find_visible_window("benefit_win");
	if ( win ) then
		win:update_qiandao_award_accept_btn_state()
	end
end

-- 139->79 server
--下发投资基金系统图标状态
function MiscCC:receive_tzfl_icon_state(pack)
	-- 图标显示状态
	local icon_state = pack:readChar()
	-- 是否已购买基金
	local is_buy = pack:readChar()
	--火影代码 忍者基金
    
--     if icon_state ==1 then 
-- 		local  win =  UIManager:show_window("activity_menus_panel")
-- 	    win:insert_btn(998)
--    elseif icon_state ==2 then 
-- 		local win =  UIManager:find_visible_window("activity_menus_panel")
-- 		if win then
-- 		   win:remove_btn(998)
-- 		end
-- end
	TZFLModel:update_win_info(icon_state, is_buy)
	-- RenZheJiJinModel:update_win_info(icon_state, is_buy)
	-- local win = UIManager:find_window("activity_menus_panel")
	-- win:insert_btn(1)
	--将投资返利放入活动页面 不下发到主界面
	-- local  win = UIManager:find_window("right_top_panel")
	-- win:insert_btn(13)
end

-- 139->80 client
--请求投资基金系统信息
function MiscCC:send_tzfl_info()
	local pack = NetManager:get_socket():alloc(139, 80)
	-- print("MiscCC:send_tzfl_info")
	NetManager:get_socket():SendToSrv(pack)
end

-- 139->80 server
--下发投资基金系统信息
function MiscCC:receive_tzfl_info(pack)
	--火影忍者基金数据结构
	-- 购买基金的类型
	-- local kind = pack:readInt()
	-- local info = {};
	-- -- if kind >=1 and kind <= 3 then
	--     -- 奖励的数量
	-- 	local num  = pack:readShort()
	--      print( string.format("MiscCC:receive_tzfl_info num=%d",num) )
	-- 	for i = 1 , num do
	-- 		info[i] = pack:readChar()
	-- 	end
	-- -- end
	-- -- 可购买选项(按位读取)
	-- local can_buy = pack:readInt()
	local num = pack:readShort()
	-- print( string.format("MiscCC:receive_tzfl_info num=%d",num) )
	local info = {}
	for i = 1 , num do
		info[i] = pack:readChar()
	--	print("info[i]",info[i])
	end

	--火影代码  忍者基金 隐藏
	-- RenZheJiJinModel:update_jijin_info( kind, info, can_buy )
	TZFLModel:update_item_button_info(info)
end

-- 139->81 client
--请求购买投资基金
function MiscCC:send_tzfl_buy( jijin_type, yuanbao_type )
	local pack = NetManager:get_socket():alloc(139, 81);
	-- pack:writeInt( jijin_type );
	-- pack:writeByte( yuanbao_type );
	NetManager:get_socket():SendToSrv(pack);
end

-- 139->82 client
--请求领取奖励
function MiscCC:send_tzfl_get_reward(index)
--	print( string.format("MiscCC:send_tzfl_get_reward index=%d",index) )
	local pack = NetManager:get_socket():alloc(139,82)
	pack:writeChar(index)
	NetManager:get_socket():SendToSrv(pack)
end

-- 139->83 client  通知服务器，退出游戏
function MiscCC:send_quit_server()
	local pack = NetManager:get_socket():alloc(139,83)
	NetManager:get_socket():SendToSrv(pack)
	NetManager:disconnect()
end

-- 139->63 c->s
function MiscCC:req_get_a_item( item_series,index)
	local pack = NetManager:get_socket():alloc(139,63)
	pack:writeInt64(item_series)
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

-- 139->63 s->c
function MiscCC:do_use_a_item( pack )
	-- print("do_use_a_item..................................")
	local item_series = pack:readInt64();
	local item_num = pack:readInt();
	local item_table = {};
	for i=1,item_num do
		item_table[i] = pack:readInt();
	end
	-- 先根据道具的序列号找到这个道具
	local user_item = ItemModel:get_item_by_series(item_series);
	local item_info = ItemConfig:get_item_by_id( user_item.item_id )
	--print("item_info.type === ",item_info.type );
	if ( item_info.type == 82 ) then
		GetSkillDialog:show( item_table,item_series );
	end 

end

-- 139->85 c->s  请求 欢乐护送  斩妖除魔 银两 仙宗任务 次数
function MiscCC:request_HZYX_count(  )
	local pack = NetManager:get_socket():alloc( 139, 85 )
	NetManager:get_socket():SendToSrv(pack)
end

-- 139->85 s->c
function MiscCC:do_result_HZYX_count( pack )
	local zhanyao_count = pack:readInt()
	local huanle_count = pack:readInt()
	local xianzong_count = pack:readInt()
	local yinliang_count = pack:readInt()

    SecretaryModel:set_HZYX_count( huanle_count, zhanyao_count, yinliang_count, xianzong_count )
end

-- 139->86 c->s  获取玩家是否在线
function MiscCC:request_check_self_online(  )
	-- local pack = NetManager:get_socket():alloc( 139, 86 )
	-- NetManager:get_socket():SendToSrv(pack)
end

-- 139->86 s->c  在线确认，服务器返回（如果接收到，表明还没断线）
function MiscCC:do_result_check_online( pack )
	GameStateManager:server_confirm_online(  )
	WholeModel:result_check_delay(  )
end

-- 139->87 c->s  发送手机信息
function MiscCC:request_send_phone_info( phone_mark, phone_version, platform, ratio, strISP, strNet,uuid, chanel_id,client_version)
-- *************   开发阶段，不发送
	-- print("139->87 c->s  发送手机信息  ", phone_mark, phone_version, platform, ratio, strISP, strNet)
	local pack = NetManager:get_socket():alloc( 139, 87 )
	pack:writeString( phone_mark );
	pack:writeString( phone_version );
	pack:writeString( platform );
	pack:writeString( ratio );
	--if strISP and strNet then
	pack:writeString(strISP)
	pack:writeString(strNet)
	pack:writeString(uuid)
	pack:writeString(chanel_id)
	pack:writeString(client_version)
	--end
	NetManager:get_socket():SendToSrv(pack)
-- *************   开发阶段，不发送
end

-- 139,88 c->s
-- 获取阵营战军令状的面板
function MiscCC:req_camp_battle_task(  )
	local pack = NetManager:get_socket():alloc( 139, 88 )
	NetManager:get_socket():SendToSrv(pack)
end
-- 139,88 s->c
-- 下发阵营战军令状的面板
function MiscCC:do_camp_battle_task( pack )
	
	local size = pack:readInt();
	local task_dict = {};
	for i=1,size do
		-- 任务类型
		local task_type = pack:readInt();
		-- 任务索引
		local task_index = pack:readInt();
		-- 领取状态
		local award_status = pack:readChar();
		task_dict[i] = { type = task_type, index = task_index, status = award_status };

	end

	CampBattleModel:do_battle_task( task_dict );
	
end

--139，89 c->c
-- 完成阵营战任务
function MiscCC:req_complete_battle_task( task_type )
	local pack = NetManager:get_socket():alloc( 139, 89 )
	pack:writeInt(task_type);
	NetManager:get_socket():SendToSrv(pack)
end


-- 139,90 s->c  
--下发八卦地宫统计
function MiscCC:do_baguadigong_tongji_info( pack )
	-- print("下发地宫统计");
	local size = pack:readInt();
	local dict = {};
	for i=1,size do
		local _target_id = pack:readInt();		--目标id
		local _completed_count = pack:readInt();	--完成数量
		local _target_count = pack:readInt();	--目标数量
		local _award_exp = pack:readInt();		--奖励经验
		local _award_status = pack:readInt(); 	-- 0未完成，1完成未领取，2已领取
		-- print("八卦地宫统计", _target_id, _completed_count,_target_count,_award_exp,_award_status);
		dict[i] = {target_id=_target_id, completed_count=_completed_count, target_count=_target_count, award_exp=_award_exp, award_status=_award_status};
	end
	if SceneManager:get_cur_scene() == 1128 then
		--只有在八卦地宫里才显示统计
		FubenTongjiModel:update_tongji( 69, 0, dict );
	end
end
--139,91  s->c
--下发八卦地宫的boss刷新时间
function MiscCC:do_baguadigong_boss_refresh_time( pack )
	-- 剩余时间
	local time = pack:readInt();
	FubenTongjiModel:update_baguadigong_boss_time( time )
end


-- 139,92 c->s
-- 进入八卦地宫副本
function MiscCC:enter_baguadigong(  )
	print("进入八卦地宫副本");
	local pack = NetManager:get_socket():alloc( 139, 92 )
	NetManager:get_socket():SendToSrv(pack)
end
-- s->c
function MiscCC:did_enter_baguadidong( pack )
	BaguadigongModel:did_enter_digong_fuben(  )
end

-- 139,93 c->s
-- 领取八卦地宫奖励
function MiscCC:req_baguadigong_get_award( target_id )
	-- print("领取八卦地宫奖励",target_id);
	local pack = NetManager:get_socket():alloc( 139, 93 )
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack)
end


-- 139-64 c->s
function MiscCC:send_params_to_server(num, info)
	-- print("MiscCC:send_params_to_server",num, info)
	local pack = NetManager:get_socket():alloc( 139, 64 )
	pack:writeInt( num )
	for i = 1, #info do
		pack:writeString( info[i] )
	end
	NetManager:get_socket():SendToSrv(pack)
end
-- c->s 139,100 请求幸运大转盘活动信息
function MiscCC:req_luopan_data(  )
	-- print("c->s 139,100 请求幸运大转盘活动信息")
	local pack = NetManager:get_socket():alloc( 139, 100 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,100 下发幸运大转盘活动信息
function MiscCC:do_result_luopan_data( pack )
	-- print("s->c 139,100 下发幸运大转盘活动信息")
	local remain_times = pack:readInt()                 -- 当前剩余抽奖次数    
	local gold_num = pack:readInt()               -- 角色元宝数
	-- todo
	LuopanModel:set_luopan_data( remain_times, gold_num )
end

-- c->s 139,101 请求幸运大转盘珍品列表记录
function MiscCC:req_luopan_item_record(  )
	local pack = NetManager:get_socket():alloc( 139, 101 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,101 下发幸运大转盘珍品列表记录
function MiscCC:do_result_luopan_appear_items( pack )
	-- print("s->c 139,101 下发幸运大转盘珍品列表记录")
	local count = pack:readShort()                 -- 多少项    
	-- print("大家珍品数量，，", count)
	local cell_t = {}                            -- 排行榜项
	for i = 1, count do 
		local cell = LuopanItemStruct( pack )
		table.insert( cell_t, cell )
		-- print("大家的抽奖道具：",cell.player_name,cell.item_name,cell.item_count)
	end
	LuopanModel:set_appear_items( cell_t )
end

-- c->s 139,102 幸运大转盘活动请求抽奖  0=不播放, 1=播放
function MiscCC:req_luopan_get_award( show_animation )
	print("c->s 139,102 幸运大转盘活动请求抽奖  0=不播放, 1=播放",show_animation)
	local pack = NetManager:get_socket():alloc( 139, 102 )
	pack:writeChar(show_animation);
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,102 幸运大转盘活动抽奖结果返回
function MiscCC:do_result_luopan_get_award( pack )
	-- print("s->c 139,102 幸运大转盘活动抽奖结果返回")
	local award_index = pack:readChar()                 -- 奖励项索引    
	LuopanModel:set_luopan_result( award_index )
end

-- c->s 139,103 转盘动画结束
function MiscCC:luopan_end(  )
	-- print("c->s 139,103 转盘动画结束")
	local pack = NetManager:get_socket():alloc( 139, 103 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,103 幸运大转盘增加珍品记录
function MiscCC:luopan_add_item( pack )
	-- print("s->c 139,103 幸运大转盘增加珍品记录")
    local item = LuopanItemStruct( pack )
	LuopanModel:add_appear_item( item )
end

-- c->s 139,148 请求幸运大转盘中我的抽奖记录（最多十条），打开页面请求一次，每次抽奖成功也会请求一次。
function MiscCC:req_luopan_my_item_record(  )
	-- print("c->s 139,148 请求幸运大转盘中我的抽奖记录")
	local pack = NetManager:get_socket():alloc( 139, 148 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,148 幸运大转盘下发我的抽奖记录
function MiscCC:do_luopan_my_item_record( pack )
	-- print("s->c 139,148 下发幸运大转盘中我的抽奖记录")
	local count = pack:readShort()                 -- 多少项 
	-- print("我的抽奖数量：", count)
	local cell_t = {}                            -- 排行榜项
	for i = 1, count do 
		local cell = LuopanItemStruct( pack )
		-- print("我的抽奖道具：",cell.player_name,cell.item_name,cell.item_count)
		table.insert( cell_t, cell )
	end
	LuopanModel:set_my_appear_items( cell_t )
end

-- c->s 139,106 获取神秘商店信息
function MiscCC:req_get_shenmi_info( )
	--print("获取神秘商店信息")
	local pack = NetManager:get_socket():alloc( 139,106)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,106 下发神秘商店信息
function MiscCC:do_shenmi_info( pack )
	local remain_time = pack:readInt()  -- 活动剩下的时间
	local next_shua_time = pack:readInt()  -- 下一次刷新的时间
	local remain_shua_count = pack:readInt()  -- 剩余刷新次数
	local item_count = pack:readInt()  -- 物品数量
	print("下发神秘商店信息",remain_time,next_shua_time,remain_shua_count,item_count)
	local item_list = {}
	for i=1,item_count do
		local item_info={id,type,before_price,now_price,remain_count}
		item_info.id = pack:readInt(); 
		item_info.type = pack:readChar(); 
		item_info.before_price = pack:readInt(); 
		item_info.now_price = pack:readInt(); 
		item_info.remain_count = pack:readInt();
		--print("物品"..i,item_info.id) 
		item_list[i] = item_info  --物品信息
	end  
	local xiaohao_yuanbao = pack:readInt()  -- 消耗元宝 
 	-- print("服务器返回的消耗元宝是多少？",xiaohao_yuanbao)
 	ShenMiShopModel:set_item_list(item_list)
	ShenMiShopModel:set_shop_data(remain_time,next_shua_time,remain_shua_count,item_count)
	ShenMiShopModel:set_xiaohao_yuanbao(xiaohao_yuanbao)

	--更新界面
	local win = UIManager:find_visible_window("shenmi_shop_win");
	if win then
		win:update_shenmi_shop()
	end
	
end

-- c->s 139,107 刷新道具
function MiscCC:req_refresh_item( type )
	print("刷新道具")
	local pack = NetManager:get_socket():alloc( 139,107)
	pack:writeChar(type)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 139,108 购买道具
function MiscCC:req_buy_item(item_id,item_count)
	--print("购买信息")
	local pack = NetManager:get_socket():alloc( 139,108)
	pack:writeInt(item_id)
	pack:writeInt(item_count)
	NetManager:get_socket():SendToSrv(pack)
end

--139-109 S->C 显示或隐藏限时商店图标
function MiscCC:do_show_hide_icon(pack )
	--print("显示或隐藏限时商店图标")
	--local x = 1
end

--139-110 S->C 更新限时商店的刷新剩余时间
function MiscCC:do_update_remain_time( pack )
	local next_shua_time = pack:readInt()  -- 下一次刷新的时间
	ShenMiShopModel:set_next_shua_time( next_shua_time )

	--更新界面
	local win = UIManager:find_visible_window("shenmi_shop_win");
	if win then
		win:update_remain_time( next_shua_time )
	end
end



-- 客户端请求服务器时间
-- 139-123  C->S
function MiscCC:send_req_server_time()
	local pack = NetManager:get_socket():alloc( 139, 123 )
	NetManager:get_socket():SendToSrv(pack)
end
-- 处理服务器返回时间
--139-123 S->C
function MiscCC:do_get_server_time(pack)
	local time = pack:readInt()
	local server_open_time = pack:readInt()
	ActivityModel:get_server_time(time,server_open_time)
end

-- c->s 139,124 请求道具数据
function MiscCC:req_item_info( item_id )
	local pack = NetManager:get_socket():alloc( 139, 124 )
	pack:writeInt(item_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 139,124 下发道具数据
function MiscCC:do_item_info(pack)

	local item_info = {};
	item_info.id = pack:readInt();
	item_info.type = pack:readInt();
	item_info.icon = pack:readInt();
	item_info.color = pack:readInt();
	item_info.name = pack:readString();
	item_info.desc = pack:readString();
	ItemModel:save_temp_item_info( item_info.id,item_info );
	-- print("MiscCC:do_item_info(pack)",item_info.id,item_info.name,item_info.desc,item_info.type,item_info.icon,item_info.color)
end

-- s>c 139,125  下发当天的所有副本剩余次数
function MiscCC:do_get_fuben_times_remain( pack )
	local num = pack:readInt()
	ActivityModel:set_fuben_times_remain(num)
	local win = UIManager:find_window( "right_top_panel" )
	if win then
		win:update_activity_remain_tips()
	end
end

-- s->c 139,129  下发商城购买送礼的信息
function MiscCC:do_buy_and_present( pack )
	local x = pack:readInt()
	x = Utils:get_bit_by_position( x, 1 )
	local y = pack:readInt()
	y = Utils:get_bit_by_position( y, 1 )

	if x == 0 then
		MallModel:update_taozhuang_info( false, false )
	else
		if y == 0 then
			MallModel:update_taozhuang_info( true, false )
		else
			MallModel:update_taozhuang_info( true, true )
		end
	end
end

-- c->s 139,130  领取商城购买送礼
function MiscCC:req_get_present( activity_id )
	local pack = NetManager:get_socket():alloc( 139, 130 )
	pack:writeInt(activity_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 139,131  拉取背包中可获取的宝石材料列表
function MiscCC:req_get_gem_meta( )
	local pack = NetManager:get_socket():alloc(139, 131)
	NetManager:get_socket():SendToSrv(pack)
end

-- s-> 139,131  返回背包中可获取的宝石材料列表
function MiscCC:do_get_gem_meta( pack )
	local meta_t = {}
	for i=1,4 do
		meta_t[i] = pack:readInt()
		-- print("================", meta_t[i])
	end
	ForgeModel:do_get_gem_meta( meta_t )
end

--c->s 139,132  发送一键合成请求
function MiscCC:req_easy_synth( lv, type)
	local pack = NetManager:get_socket():alloc( 139, 132 )
	pack:writeChar(lv)
	pack:writeChar(type)
	NetManager:get_socket():SendToSrv(pack)
end


-- c->s 139,132 将背包的宝石材料注入
-- function MiscCC:req_put_gem_meta( meta_type )
-- 	local pack = NetManager:get_socket():alloc(139, 132)
-- 	pack:writeInt(meta_type)
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- -- s->c 139,132 将背包的宝石材料注入成功
-- function MiscCC:do_put_gem_meta( pack )
-- 	-- print("======s->c 139,132 将背包的宝石材料注入成功======")
-- end

-- s->c 139,128 服务器下发副本数据
function  MiscCC:do_fuben_info( pack )
	-- ZXLog("~~~~~~~~~~~~~~~~~~~~~~~MiscCC:do_fuben_info( pack )")
	local fuben_info = ParentFuBenStruct(pack);
	-- print("fuben_info.count,fuben_info.progress",fuben_info.count,fuben_info.progress)
	-- for i=1,fuben_info.count do
	-- 	print("subid,remainCount,totalCount",fuben_info.fubenId_list[i],fuben_info.sub_list[i].remainCount,fuben_info.sub_list[i].totalCount)
	-- end
	local fb_list_id = fuben_info.fbListId
	local win = UIManager:find_visible_window("activity_Win")
	if win then
		local if_have_team_info = TeamActivityMode:if_have_team_fuben( fb_list_id )
		if if_have_team_info == true then
			TeamActivityMode:update_times(fuben_info)  
		else 
			win:change_page(1)
			win:update_win("fuben_data",fuben_info) 
		end 
	end

	--更新model里的副本次数
	local fuben_struct = {}
	fuben_struct.list_id = fuben_info.fbListId

	-- 1:计子副本次数
	if fuben_info.fuben_type == 1 then
		local total_remain_count = 0
		for i=1,#fuben_info.sub_list do 
			total_remain_count = total_remain_count + fuben_info.sub_list[i].remainCount
		end
		fuben_struct.remain_count = total_remain_count
	else
	-- 2:计父副本次数
		fuben_struct.remain_count = fuben_info.sub_list[1].remainCount
	end 

	FuBenModel:add_fuben_info_in_table( fuben_struct )
	
end

-- c->s 139,133 请求增加副本次数
function MiscCC:req_add_fuben_count(fbListId,money_type)
	-- print("MiscCC:req_add_fuben_count(fbListId,money_type)",fbListId,money_type)
	local pack = NetManager:get_socket():alloc( 139, 133 )
	pack:writeInt(fbListId)
	pack:writeByte(money_type)	
	NetManager:get_socket():SendToSrv(pack)
end


-- c->s 139,149 请求增加副本次数（天将雄狮）
function MiscCC:req_add_fuben_count_2(fbListId,money_type)
	print("c->s 139,149 请求增加副本次数（天将雄狮） MiscCC:req_add_fuben_count_2(fbListId,money_type)",fbListId)
	local pack = NetManager:get_socket():alloc( 139, 149 )
	pack:writeInt(fbListId)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 139,149 回调副本次数（天将雄狮）
function MiscCC:do_add_enter_fuben_count( pack )
	print("s->c, (139,149)")
	require "struct/FuBenStruct"
	local info_count = pack:readInt();
	print("info_count",info_count)
	local fuben_info_table = {};
	for i=1,info_count do
		fuben_info_table[i] = FuBenStruct(pack);
		-- print("--------fuben_info_table[i]:", fuben_info_table[i].fuben_id, fuben_info_table[i].count, fuben_info_table[i].vip_add)
		-- debug.debug()
	end
	require "model/FubenModel/FuBenModel"
	FuBenModel:set_fuben_info_table( fuben_info_table );
	-- local info_count = pack:readInt()
	-- local fuben_info_table = {}

	-- for i=1,info_count do
	-- 	fuben_info_table[i] = {}
	-- 	fuben_info_table[i].list_id = pack:readInt()
	-- 	fuben_info_table[i].remain_count = pack:readInt()
	-- 	local fuben_list_data = ActivityModel:get_activity_info_by_class( "fuben" )
	-- 	fuben_info_table[i].fuben_id = fuben_list_data[i].id
	-- 	fuben_info_table[i].count = fuben_info_table[i].remain_count
	-- 	print("--------fuben_info_table[i].remain_count:", fuben_info_table[i].remain_count)
	-- 	fuben_info_table[i].vip_add = 0
	-- 	-- print("i,fuben_info_table[i].list_id,fuben_info_table[i].remain_count",i,fuben_info_table[i].list_id,fuben_info_table[i].remain_count)
	-- end

	-- require "model/FubenModel/FuBenModel"
	-- FuBenModel:set_fuben_info_table( fuben_info_table )
end

--s->c 139,133 服务器下发增加次后子副本数据
--已废，统一下发128
function MiscCC:do_add_fuben_count(pack)
	-- local fubenId = pack:readInt()
	-- local remainCount = pack:readInt()
	-- local totalCount = pack:readInt()

	-- print("MiscCC:do_add_fuben_count(fubenId,remainCount,totalCount)",fubenId,remainCount,totalCount)	
	-- FBChallengeWin:update_sub_fuben(fubenId,remainCount,totalCount)

	-- --更新model里的副本数据
	-- local enter_count,vip_add = FuBenModel:get_enter_fuben_count( fubenId )
	-- local fuben_struct = {}
	-- fuben_struct.fuben_id = fubenId
	-- fuben_struct.count = enter_count
	-- fuben_struct.vip_add = vip_add + 1

	-- FuBenModel:add_fuben_info_in_table( fuben_struct )

	local fuben_info = ParentFuBenStruct(pack)
	-- print("fuben_info.count,fuben_info.progress",fuben_info.count,fuben_info.progress)
	-- for i=1,fuben_info.count do
	-- 	print("subid,remainCount,totalCount",fuben_info.sub[i].subId,fuben_info.sub[i].remainCount,fuben_info.sub[i].totalCount)
	-- end
	local fb_list_id = fuben_info.fbListId
	local win = UIManager:show_window("fb_challenge_win")
	if win then
	    win:initialize_by_fubenid(fb_list_id+1)
		FBChallengeWin:update_win(fuben_info)
	end
	-- local activity_win = UIManager:find_visible_window("activity_win")
	-- if activity_win then 
	-- 	TeamActivityMode:set_fuben_times_info(fuben_info)
	-- end 

	--更新model里的副本数据
	-- print("!!!!!!!!!!fuben_info.count",fuben_info.count)
	for i=1,fuben_info.count do
		local fubenId = fuben_info.sub[i].subId
		local remainCount = fuben_info.sub[i].remainCount
		local totalCount = fuben_info.sub[i].totalCount
		-- print("fubenId,remainCount,totalCount",fubenId,remainCount,totalCount)

		local enter_count,vip_add = FuBenModel:get_enter_fuben_count( fubenId )
		-- print("enter_count,vip_add",enter_count,vip_add)
		local fuben_struct = {}
		fuben_struct.fuben_id = fubenId
		fuben_struct.count = enter_count
		fuben_struct.vip_add = vip_add + 1

		-- FuBenModel:add_fuben_info_in_table( fuben_struct )
	end
end

--s->c 139,135 领取渡劫奖励
function MiscCC:fetch_dujie_yb(fuben_id)
	local pack = NetManager:get_socket():alloc( 139, 135 )
	pack:writeInt(fuben_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- --c->s 139,136 获取今天进入各个副本的次数
-- function MiscCC:req_get_enter_fuben_count()
-- 	local pack = NetManager:get_socket():alloc(139, 136);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end

--s->c 139,136 下发今天进入各个副本的次数
function MiscCC:do_get_enter_fuben_count( pack )
	-- print("*********************####################################***MiscCC:do_get_enter_fuben_count( pack )")
	local info_count = pack:readInt()
	local fuben_info_table = {}

	for i=1,info_count do
		fuben_info_table[i] = {}
		fuben_info_table[i].list_id = pack:readInt()
		fuben_info_table[i].remain_count = pack:readInt()
		local fuben_list_data = ActivityModel:get_activity_info_by_class( "fuben" )
		fuben_info_table[i].fuben_id = fuben_list_data[i].id
		fuben_info_table[i].count = fuben_info_table[i].remain_count
		-- print("--------fuben_info_table[i].remain_count:", fuben_info_table[i].remain_count)
		fuben_info_table[i].vip_add = 0
		-- print("i,fuben_info_table[i].list_id,fuben_info_table[i].remain_count",i,fuben_info_table[i].list_id,fuben_info_table[i].remain_count)
	end

	require "model/FubenModel/FuBenModel"
	FuBenModel:set_fuben_info_table( fuben_info_table )
end

--s->c 139,135 下发副本箭头指示
function MiscCC:do_indicate_direction(pack)
	local fuben_id = pack:readInt()
	-- print("MiscCC:do_indicate_direction(fuben_id,SceneManager:get_cur_fuben())",fuben_id,SceneManager:get_cur_fuben())
	if SceneManager:get_cur_fuben() == fuben_id then
		local ui_node = ZXLogicScene:sharedScene():getUINode()
		local x = UIScreenPos.relativeWidth(0.90)
	    local y = UIScreenPos.relativeHeight(0.50)

		local instrution = MUtils:create_sprite(ui_node,UIPIC_ACTIVITY_067, x, y,99999)
		LuaEffectManager:run_move_animation( 2, instrution )

		local function dismiss()
			instrution:removeFromParentAndCleanup(true)
			instrution = nil
	    end

	    local cb = callback:new()
	    cb:start(4,dismiss)
   	end 
end

-- add after tjxs  
-- c>s 139,154 一键满星完成
function MiscCC:req_finish_quest_full_star(  )
	print("c->s:", 139, 154)
	local pack = NetManager:get_socket():alloc(139, 154)
	NetManager:get_socket():SendToSrv(pack)
end

--获取关卡是否通关
--65  皇陵秘境
-- 58  破狱之战
-- 64  密宗佛塔
--139,140 
function  MiscCC:req_fuben_pass_info(fuben_id)
	print("c->s:",139,140)
	local pack = NetManager:get_socket():alloc(139,140)
	pack:writeInt(fuben_id)
	NetManager:get_socket():SendToSrv(pack)
end

--139,140 下发关卡信息
function  MiscCC:do_fuben_pass_info( pack )
	local flow_info = pack:readInt() 
	local flow_one    = Utils:get_bit_by_position( flow_info, 1 );	--复活时间
	local flow_two	  = Utils:get_bit_by_position( flow_info, 2 );--阵营id
	local flow_three  = Utils:get_bit_by_position( flow_info, 3 );--杀人者id
	local flow_four	  = Utils:get_bit_by_position( flow_info, 4 );--宠物id
	local flow_five   = Utils:get_bit_by_position( flow_info, 5 );--杀人者等级
	local flow_six    = Utils:get_bit_by_position( flow_info, 6 );--杀人者性别

	local array = {}
	table.insert(array,flow_one)
	table.insert(array,flow_two)
	table.insert(array,flow_three)
	table.insert(array,flow_four)
	table.insert(array,flow_five)
	table.insert(array,flow_six)
ActivityModel:set_fenceng_fuben_pass(array)
end





--------------------------------------在之前的版本中 至尊特惠的协议这版本均没使用 已经废弃  begin xiehande-----------------------------------------

--------------------------------------------------------------
--特惠狂欢

--c->s 139,136 请求特惠狂欢活动指定系列信息
-- function MiscCC:req_tehui_sub_info( index )
-- 	print("c->s 139,136")
-- 	local pack = NetManager:get_socket():alloc( 139, 136 )
-- 	pack:writeInt(index)--1：强化特惠   2：法宝特惠  3：装备特惠
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- --s->c 139,136
-- function MiscCC:do_tehui_sub_info( pack )
-- 	-- print("s->c 139,136")
-- 	-- local which_c_s = pack:readChar()--从哪条协议下来的
-- 	local index = pack:readInt()--索引 --1：强化特惠   2：法宝特惠  3：装备特惠
-- 	local libao_num = pack:readChar()--可购买礼包种类的数量
-- 	-- print("index=",index)
-- 	-- print("libao_num=",libao_num)

-- 	local libao_data = {}
-- 	for i=1,libao_num do
-- 		libao_data[i] = {}
-- 		local person_buy_times = pack:readChar()-- 玩家当前购买次数
-- 		local server_buy_times = pack:readInt()--全服购买数量
-- 		-- print("i=",i)
-- 		-- print("person_buy_times=",person_buy_times)
-- 		-- print("server_buy_times=",server_buy_times)
-- 		libao_data[i].person_buy_times = person_buy_times
-- 		libao_data[i].server_buy_times = server_buy_times
-- 	end
-- 	TehuiModel:set_libao_data(index,libao_num,libao_data)

-- -----------------------------------------

-- 	local can_get_times = pack:readInt()--土豪送的礼包，剩余可领数
-- 	local person_num = pack:readInt()--土豪礼包购买人数
-- 	-- print("can_get_times=",can_get_times)
-- 	-- print("person_num=",person_num)

-- 	local zhizun_data = {} --至尊送礼
-- 	for i=1,person_num do
-- 		zhizun_data[i] = {}
-- 		local role_id = pack:readInt()  ---人的id
-- 		local role_name = pack:readString()--人的名
-- 		-- print("i=",i)
-- 		-- print("role_id=",role_id)
-- 		-- print("role_name=",role_name)

-- 		zhizun_data[i].role_id = role_id
-- 		zhizun_data[i].role_name = role_name
-- 	end

-- 	TehuiModel:set_zhizun_data(can_get_times,person_num,zhizun_data)
-- 	local win = UIManager:find_visible_window("tehui_win")
-- 	if win then
-- 		win:update("control")
-- 		win:update("time")
-- 		win:update("btn")
		
-- 	end
-- end


-- --点击按钮购买
-- function MiscCC:req_get_tehui_libao(index, sub_index, num)
-- 	print("c->s 139,137")
-- 	local pack = NetManager:get_socket():alloc( 139, 137 )
-- 	pack:writeInt(index)--1：强化特惠   2：法宝特惠  3：装备特惠
-- 	pack:writeInt(sub_index)--1：特惠   2：超级  3：至尊
-- 	pack:writeInt(num)--购买数量
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- --点击按钮领取至尊送礼
-- function MiscCC:req_get_tehui_zhizun_libao(index)
-- 	print("c->s 139,138")
-- 	local pack = NetManager:get_socket():alloc( 139, 138 )
-- 	pack:writeInt(index)--1：强化特惠   2：法宝特惠  3：装备特惠
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

--c->s 139,142 请求特惠狂欢活动指定系列信息
function MiscCC:req_tehui_sub_info( index )
	print("c->s 139,142")
	local pack = NetManager:get_socket():alloc( 139, 142 )
	pack:writeInt(index)--1：强化特惠   2：法宝特惠  3：装备特惠
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 139,142
function MiscCC:do_tehui_sub_info( pack )
	print("s->c 139,142")
	-- local which_c_s = pack:readChar()--从哪条协议下来的
	local index = pack:readInt()--索引 --1：强化特惠   2：法宝特惠  3：装备特惠
	local libao_num = pack:readChar()--可购买礼包种类的数量
	-- print("index=",index)
	-- print("libao_num=",libao_num)

	local libao_data = {}
	for i=1,libao_num do
		libao_data[i] = {}
		local person_buy_times = pack:readChar()-- 玩家当前购买次数
		local server_buy_times = pack:readInt()--全服购买数量
		-- print("i=",i)
		-- print("person_buy_times=",person_buy_times)
		-- print("server_buy_times=",server_buy_times)
		libao_data[i].person_buy_times = person_buy_times
		libao_data[i].server_buy_times = server_buy_times
	end
	TehuiModel:set_libao_data(index,libao_num,libao_data)

-----------------------------------------

	local can_get_times = pack:readInt()--土豪送的礼包，剩余可领数
	local person_num = pack:readInt()--土豪礼包购买人数
	-- print("can_get_times=",can_get_times)
	-- print("person_num=",person_num)

	local zhizun_data = {} --至尊送礼
	for i=1,person_num do
		zhizun_data[i] = {}
		local role_id = pack:readInt()  ---人的id
		local role_name = pack:readString()--人的名
		-- print("i=",i)
		-- print("role_id=",role_id)
		-- print("role_name=",role_name)

		zhizun_data[i].role_id = role_id
		zhizun_data[i].role_name = role_name
	end

	TehuiModel:set_zhizun_data(can_get_times,person_num,zhizun_data)
	local win = UIManager:find_visible_window("tehui_win")
	if win then
		win:update("control")
		win:update("time")
		win:update("btn")
		
	end
end


--点击按钮购买
function MiscCC:req_get_tehui_libao(index, sub_index, num)
	print("c->s 139,143")
	local pack = NetManager:get_socket():alloc( 139, 143 )
	pack:writeInt(index)--1：强化特惠   2：法宝特惠  3：装备特惠
	pack:writeInt(sub_index)--1：特惠   2：超级  3：至尊
	pack:writeInt(num)--购买数量
	NetManager:get_socket():SendToSrv(pack)
end

--点击按钮领取至尊送礼
function MiscCC:req_get_tehui_zhizun_libao(index)
	print("c->s 139,144")
	local pack = NetManager:get_socket():alloc( 139, 144 )
	pack:writeInt(index)--1：强化特惠   2：法宝特惠  3：装备特惠
	NetManager:get_socket():SendToSrv(pack)
end




--------------------------------------在之前的版本中 至尊特惠的协议这版本均没使用 已经废弃 end-----------------------------------------


-- 登陆送元宝（Lucky Draw 抽奖） ==================================
-- add by chj @tjxs
-- 获取登陆送元宝数据
function MiscCC:req_login_award_data()
	print("c->s (139, 145) MiscCC:req_login_award_data")
	local pack = NetManager:get_socket():alloc( 139, 145 )
	NetManager:get_socket():SendToSrv(pack)
end

-- 获取登陆送元宝数据
-- add by chj @tjxs (139, 145)
-- is_get: 1 表示已经领过了, 0 表示没有领过

function MiscCC:do_get_login_award_data( pack )
	print("s->c (139, 145) MiscCC:do_get_login_award_data")
	local is_get = pack:readChar()
	local num_1 = pack:readChar()
	local num_2 = pack:readChar()
	local num_3 = pack:readChar()
	print("---------------login_award:", is_get, num_1, num_2, num_3)
	LoginLuckyDrawModel:update_login_page( is_get, num_1, num_2, num_3 )
end

-- 登陆送元宝抽奖
function MiscCC:req_lucky_draw( index )
	print("c->s (139, 146) MiscCC:req_login_award_data")
	local pack = NetManager:get_socket():alloc( 139, 146 )
	print("-----index:", index)
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

-- 登陆送元宝领奖
function MiscCC:req_get_award( )
	print("c->s (139, 147) MiscCC:req_get_award")
	local pack = NetManager:get_socket():alloc( 139, 147 )
	NetManager:get_socket():SendToSrv(pack)
end

--c->s 139,160 修改昵称
function MiscCC:req_rename( new_name )
	local pack = NetManager:get_socket():alloc( 139, 160 )
	pack:writeString(new_name)
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 139,160 改名结果返回
function MiscCC:do_rename_result( pack )
	local result_code = pack:readChar()
	if result_code == 0 then
		UI_Utilities.showReconnectDialog(true)
	elseif result_code == -6 then
		GlobalFunc:create_screen_notic(Lang.rename[10])
	else
		GlobalFunc:create_screen_notic(Lang.rename[11])
	end
end

--c->s 139,161 验证昵称
function MiscCC:req_rename_check( new_name )
	local pack = NetManager:get_socket():alloc( 139, 161 )
	pack:writeString(new_name)
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 139,161 名称验证返回
function MiscCC:do_check_name_result(pack)
	local result_code = pack:readChar()
	local win = UIManager:find_visible_window("rename_dialog")
	if win then
		win:update(result_code)
	end
end
-------------------------------------------------------