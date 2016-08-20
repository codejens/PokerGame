-- TeamCC.lua
-- create by hcl on 2013-2-25
-- 队伍系统

-- super_class.TeamCC()
TeamCC = {}

--16,1 s->c 初始化队伍信息
function TeamCC:do_init_team_info(pack)
	print("初始化队伍信息")
	require "model/TeamModel"
	TeamModel:init_team_info( pack );
end

-- 16,2 s->c 添加队伍成员
function TeamCC:do_player_join(pack)
	print("队友加入")
	require "model/TeamModel"
	TeamModel:add_member( pack )
end


-- 16,1 c->s 邀请加入队伍(队长邀请玩家加入)
function TeamCC:req_invate_join_team( target_name )
	print("target_name=",target_name);
	local pack = NetManager:get_socket():alloc(16,1);
	pack:writeString(target_name)
	NetManager:get_socket():SendToSrv(pack);
end

-- 16,3 c->s 申请加入队伍 (队员申请加入队伍)
function TeamCC:req_join_team( target_name )
	local pack = NetManager:get_socket():alloc(16,3);
	pack:writeString(target_name)
	NetManager:get_socket():SendToSrv(pack);
end

-- 16,9 s->c 服务器通知有玩家申请加入队伍
function TeamCC:do_player_req_join_team( pack )
	local player_actor_id = pack:readInt();		--玩家的actorID
	local player_lv = pack:readByte();			--玩家的等级
	local player_job = pack:readByte();			--玩家的职业
	local player_name = pack:readString();		--玩家的名字
	-- TODO 弹出玩家申请加入队伍面板

	-- 暂时先自动同意加入
	TeamCC:req_leader_replay(player_actor_id,1);
end

-- 16,10 c->s 队长回复申请入队 ( )
function TeamCC:req_leader_replay(actor_id,result)
	local pack = NetManager:get_socket():alloc(16,10);
	pack:writeInt(actor_id)
	pack:writeByte(result)		--1同意,0拒绝
	NetManager:get_socket():SendToSrv(pack);
end

-- 16,10 s->c 服务器通知有队长邀请玩家加入队伍
function TeamCC:do_leader_invate_join( pack )
	local invate_name = pack:readString();
	-- TODO 根据设置界面的是否自动接收组队来回复
	local is_auto = SetSystemModel:get_date_value_by_key( SetSystemModel.AUTO_JOINED_TEAM );
	if ( is_auto ) then  
		--暂时先同意 
		TeamCC:req_player_replay_invate_join( invate_name,1,1 )
	else
		local function cb_fun ()
			local function cb()
				TeamCC:req_player_replay_invate_join( invate_name,1,1 )
			end
			NormalDialog:show( invate_name..LangGameString[456],cb); -- [456]="邀请你加入队伍,是否加入?"
		end
		MiniBtnWin:show( 15 , cb_fun  );
	end
end

-- 16,11 c->s 玩家回复队长邀请加入队伍
function TeamCC:req_player_replay_invate_join( invate_name,result,auto_result )
	local pack = NetManager:get_socket():alloc(16,11);
	pack:writeString( invate_name )
	pack:writeByte(result)		--1同意,0拒绝
	pack:writeByte(auto_result)		--1同意,0拒绝
	NetManager:get_socket():SendToSrv(pack);
end

-- 16,2 c->s 退出队伍
function TeamCC:req_exit_team()
	local pack = NetManager:get_socket():alloc(16,2);
	NetManager:get_socket():SendToSrv(pack);
end

-- 16,4 c->s 设置为队长
function TeamCC:req_set_leader( actorID )
	local pack = NetManager:get_socket():alloc(16,4);
	pack:writeInt( actorID );
	NetManager:get_socket():SendToSrv(pack);
end
-- 16,4 s->c 服务通知设置队长结果
function TeamCC:do_set_leader( pack )
	local leader_actor_id = pack:readInt();
	TeamModel:set_leader( leader_actor_id )
end

--16,7 s->c 队伍退出游戏或者掉线
function TeamCC:do_player_offline(pack)
	local offline_player_actor_id = pack:readInt();
	-- model设置队员状态为掉线
	TeamModel:set_member_offline( offline_player_actor_id );

end

-- 16,8 s->c 队友的属性发生变化
function TeamCC:do_player_attr_change( pack )
	-- print("队友属性发生变化...................................................................")
	-- local handle = pack:readInt64();
	-- local actorID = pack:readInt();
	-- TeamModel:set_member_attr(actorID,pack)
end

-- 16,5 c->s 踢出一个队友
function TeamCC:req_kick_player( actorID )
	local pack = NetManager:get_socket():alloc(16,5);
	pack:writeInt( actorID );
	NetManager:get_socket():SendToSrv(pack);
end

-- 16,3 s->c 删除队伍成员
function TeamCC:do_kick_player(pack)
	local actorID = pack:readInt();
	-- 删除member
	TeamModel:remove_member( actorID );
	TeamActivityMode:clear_status()
end

-- 16,9 c->s 解散队伍
function TeamCC:req_disable_team(  )
	local pack = NetManager:get_socket():alloc(16,9);
	NetManager:get_socket():SendToSrv(pack);
	-- 删除所有数据
end

-- 16,11 s->c 广播队员死亡或复活
function TeamCC:do_broadcast_player_state( pack )
	local actorID = pack:readInt()
	local result = pack:readByte();  -- 0 死亡 1:复活
	-- 广播队员死亡或复活
	TeamModel:teammate_state( actorID,result )
end

-- 16,12 s->c 广播坐标或场景变化
function TeamCC:do_broadcast_scene_state( pack )
	local actorID = pack:readInt();  --队员id
	local sceneID = pack:readInt();  --所在的场景id
	local x_pos	  = pack:readWord();	--x坐标
	local y_pos   = pack:readWord(); 	--y坐标
	local is_out_exp_range = pack:readByte()	--是否超出了经验范围 0超出 1未超出
	print("广播坐标或场景变化",actorID,is_out_exp_range)
	TeamModel:update_member_range( actorID,is_out_exp_range )
end
-- s->c 16,13  队员准备状态
function TeamCC:do_ready_status( pack )
    local handle = pack:readInt64()   --如果不在线 0
	local actor_id = pack:readInt()  --队员ID
	local status = pack:readChar()    --准备状态 0:没有准备好 1：准备好
	ZXLog("队员准备状态逗比逗比都比-----------------------------",handle,actor_id,status)
	if handle ~= 0 then
		TeamActivityMode:update_status(actor_id,status)	
	end
end
