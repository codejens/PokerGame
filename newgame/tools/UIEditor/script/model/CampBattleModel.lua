-- CampBattleModel.lua
-- created by lyl on 2013-2-25

-- super_class.CampBattleModel()
CampBattleModel = {}

local _battle_info = nil;

local _player_data = nil;
-- added by aXing on 2013-5-25
function CampBattleModel:fini( ... )

	_battle_info = nil;
	_player_data = nil;
end

---------------网络请求相关

--请求战场信息
function CampBattleModel:req_battle_info(  )	
	MiscCC:req_battle_info();
end

--得到战场信息
function CampBattleModel:do_battle_info( battle_info )
	
	_battle_info = battle_info;
	
	local win = UIManager:get_win_obj("camp_win");
	if win ~= nil then
		win:update(_battle_info);
	end

end

--获取战场信息
function CampBattleModel:get_battle_info( )
	
	return _battle_info;
end

-- 更新阵营战玩家本人的统计数据
function CampBattleModel:update_battle_data( data )
	_player_data = data;
end

-- 获取阵营战玩家本人的统计数据
function CampBattleModel:get_battle_data( )
	return _player_data;
end


--进入战场
function CampBattleModel:req_enter_battle( battle_id )
	
	MiscCC:req_enter_battle( battle_id );
	
end

--进入战场的结果
--服务器下发回调
function CampBattleModel:do_eneter_battle( battle_id,code,error_message )

	--进入战场结果的回调中，只处理出错情况
	if code == -1 then
		
		NormalDialog:show(error_message,nil,2);
	elseif code == 0 then	--0为成功
		UIManager:hide_window("camp_win");
	end
	print("CampBattleModel:do_eneter_battle( battle_id,code,error_message )",battle_id,code,error_message )
end
--领取阵营战奖励
function CampBattleModel:req_battle_reward(  )
	-- MiscCC:req_battle_reward( )
	GameLogicCC:req_talk_to_npc( 0, "GetCampBattleAward" );
end

-- --领取阵营战奖励结果
-- function CampBattleModel:do_battle_reward( battle_id, result,message )
	
-- end


-- 获取阵营战结束之后的排行榜
function CampBattleModel:req_camp_battle_result_rank(  )
	MiscCC:req_camp_battle_result_rank(  );
end

function CampBattleModel:do_camp_battle_result_rank( my_rank, rank_dict  )
	print("阵营战结束之后的排行榜数据");
	-- if _battle_info then
		local win = UIManager:show_window("camp_result_win");
		if win then
--测试数据
  --          local my_rank = 4
  --          local rank_dict ={}
  --         -- local rank_dict[i] = { player_id, player_name, camp, sex, job, level, kill_num, assists_num, multiKill_num, score };
  --         local rank_dict1 = {8214,"陆杨威",2,0,4,60,2,1,1,1}
  --         local rank_dict2 = {20502,"闻人千水",1,0,1,50,1,1,1,1}
  --         local rank_dict3 = {22550,"詹函桐的",1,1,3,50,1,1,1,1}
  --         local rank_dict4 = {28694,"詹函桐1",2,1,3,50,0,1,1,1,1}
  --         table.insert(rank_dict,rank_dict1)
  --         table.insert(rank_dict,rank_dict2)
  --         table.insert(rank_dict,rank_dict3)
  --         table.insert(rank_dict,rank_dict4)
  --         local win = UIManager:show_window("camp_result_win");
		-- if win then
		-- 	print("打开阵营战 排行榜页面")
		-- 	print(my_rank)
		-- 	print("=======================================")
		-- 	for k,v in pairs(rank_dict) do
		-- 		print(k,v)
		-- 	end
			
		-- 	win:init_rank_data(my_rank,rank_dict);
		-- 	end
			win:init_rank_data(my_rank,rank_dict);
		end
	-- end
end


-- 获取阵营战军令状
function CampBattleModel:req_battle_task(  )
	MiscCC:req_camp_battle_task();
end

-- 下发阵营战军令状
function CampBattleModel:do_battle_task( data )
	local win = UIManager:find_visible_window("camp_task_win");
	if win then
		win:update(data);
	end
end
-- 领取阵营战军令状奖励
function CampBattleModel:req_complete_battle_task( task_type )
	print("领取阵营战军令状奖励", task_type );
	MiscCC:req_complete_battle_task( task_type );
end


-- 添加阵营战buff
function CampBattleModel:do_add_camp_battle_buff( buff_type )
	local player = EntityManager:get_player_avatar();
	local effect_id ;
	if buff_type == 95 then
		effect_id = 10000;
	elseif buff_type == 96 then
		effect_id = 10001;
	elseif buff_type == 97 then
		effect_id = 10002;
	end
	
	if effect_id ~= nil then
		player:show_camp_buff_effect( effect_id );
	end

end	

--删除阵营战buff
function CampBattleModel:do_dele_camp_battle_buff(  )
	-- local player = EntityManager:get_player_avatar();
	-- player:dele_camp_buff_effect(  )
end