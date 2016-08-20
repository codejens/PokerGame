-- TeamModel.lua
-- create by hcl on 2013-2-25
-- 队伍model

-- super_class.TeamModel()
TeamModel = {}
-------------------------------私有变量------------------------------
local team_pick_up_type ;		--队伍的拾取方式
local team_member_num = 0;		--在线队伍成员的数量
local team_member_table = {};	--在线队伍成员的信息
local team_leader_actorID = 0;	--队长的actorID
local item_roll_min_pinzhi = 0;	--Roll物品的最低物品品质
local team_id  = 0;				--队伍id
local fuben_id = 0;				--副本id默认是0
local team_state = 0;			--队伍的副本状态	0,1=在创建队伍,等待进入副本的状态,2=已经进入副本战斗中
local recruit_timer = timer()	--由于window改为destroy模式，那么发布招募的10秒cd需要转到model层来做
local recruit_time = 0			--记录招募秒数
--------------------------------私有变量----------------------

TeamModel.STATE_ONLINE = 0;
TeamModel.STATE_OFFLINE = 1;
TeamModel.STATE_OUTOFRANGE = 2;


-- added by aXing on 2013-5-25
function TeamModel:fini( ... )
	recruit_timer:stop()
	recruit_time = 0
	team_pick_up_type = nil
	team_member_num = 0
	team_member_table = {}
	team_leader_actorID = 0
	item_roll_min_pinzhi = 0
	team_id  = 0
	fuben_id = 0
	team_state = 0;
end

function TeamModel:set_recruit_time(time)
	recruit_timer:stop();
	recruit_time = 0;
	if time and time > 0 then
		recruit_time = time
		local function tick(dt)
			recruit_time = recruit_time - 1;
			if recruit_time <= 0 then
				recruit_time = 0
				recruit_timer:stop();
			end
		end
		recruit_timer:start(1, tick)
	end
end

function TeamModel:get_recruit_time()
	return recruit_time;
end

--create by jiangjinhong
function TeamModel:get_team_id(  )
	return team_id 
end
-- 判断主角是否有队伍
function TeamModel:is_have_team()
	return team_id > 0
end

-- 初始化
function TeamModel:init_team_info( pack )
	team_pick_up_type = pack:readByte();
	team_member_num	= pack:readByte();
	ZXLog("玩家组队。。。。。。。。。。。。。。。。。。team_member_num:",team_member_num)
	for i=1,team_member_num do
		team_member_table[i] = TeamMemberStruct(pack);
	end
	team_leader_actorID = pack:readInt();
	item_roll_min_pinzhi = pack:readByte();
	team_id = pack:readInt();
	fuben_id = pack:readUInt();
	team_state = pack:readByte();
--	print("team_pick_up_type,team_member_num,team_leader_actorID,item_roll_min_pinzhi,team_id,fuben_id,team_state",team_pick_up_type,team_member_num,team_leader_actorID,item_roll_min_pinzhi,team_id,fuben_id,team_state);

	-- 更新界面
	local win = UIManager:find_window("user_panel");
	if ( win ) then
		win:update(6);
		local is_leader = TeamModel:is_leader(  );
		-- 更新主界面的队长标志
		win:set_team_leader_spr_visible( is_leader );
	end
	--如果组队界面打开的话，要更新组队界面
	local team_win = UIManager:find_window("team_win")
	if team_win then
		team_win:update_btn( team_id  );
		team_win:get_recruit_info( )
	end
end

-- 取得队伍数据
function TeamModel:get_team_table()
	return team_member_table;
end

-- 取得队长actor_id
function TeamModel:get_leader_actor_id()
	return team_leader_actorID;
end

-- 添加一个队员
function TeamModel:add_member( pack )
	local team_member_struct = TeamMemberStruct(pack);
	for i=1,#team_member_table do
		if ( team_member_struct.actor_id == team_member_table[i].actor_id ) then
			team_member_table[i] = team_member_struct;
			-- 通知界面更新
			local win = MiniTaskPanel:get_miniTaskPanel()
			if ( win ) then
				win:update_team_member_state(actorID,TeamModel.STATE_ONLINE);
			end
			return;
		end
	end
	--table.insert(team_member_table,team_member_struct);
	team_member_table[#team_member_table+1] = team_member_struct;
	-- 更新界面
	local win = UIManager:find_window("user_panel");
	if ( win ) then
		win:update(6);
	end
	--如果组队界面打开的话，要更新组队界面
	local team_win = UIManager:find_window("team_win")
	if team_win then
		team_win:update_btn( team_id  );
		team_win:get_recruit_info( )
	end
end

-- 删除一个队员
function TeamModel:remove_member( actorID )
	local player = EntityManager:get_player_avatar();
	print(actorID,"退出队伍","player.id",player.id);
	-- 自己被踢了
	if ( actorID == player.id ) then
		TeamModel:exit_team() 
	else
		for i=1,#team_member_table do
			if ( actorID == team_member_table[i].actor_id ) then
				table.remove(team_member_table,i);
				print("删除",actorID)
				break;
			end
		end
		-- 更新界面
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			win:update(6);
			if ( #team_member_table == 0 ) then
				win:on_exit_team( );
			end
		end
		--如果组队界面打开的话，要更新组队界面
		local team_win = UIManager:find_window("team_win")
		if team_win then
			team_win:update_btn( team_id  );
			team_win:get_recruit_info( )
		end
	end

end

-- 根据actorID取得队员信息
function TeamModel:get_member_info_by_actor_id( actorID )
	for i=1,#team_member_table do
		if ( actorID == team_member_table[i].actor_id ) then
			return team_member_table[i];
		end
	end
end

-- 根据actionID取得队员的索引
function TeamModel:get_member_index_by_actor_id( actorID )
	for i=1,#team_member_table do
		if ( actorID == team_member_table[i].actor_id ) then
			return i;
		end
	end	
end

-- 设置队员为掉线状态
function TeamModel:set_member_offline( actorID )
	local member_struct = self:get_member_info_by_actor_id(actorID);
	if ( member_struct ) then
		-- 设置为0代表掉线
		member_struct.handle = 0;
	end
	-- 通知界面更新
	local win = MiniTaskPanel:get_miniTaskPanel()
	if ( win ) then
		win:update_team_member_state(actorID,TeamModel.STATE_OFFLINE);
	end
	-- 广播队伍退出游戏或者掉线
	GlobalFunc:create_screen_notic( member_struct.name .. LangModelString[471] ); -- [471]="退出游戏或掉线"
end

-- 更新队员是否超出范围
function TeamModel:update_member_range( actorID,is_out_of_range )

	local win = MiniTaskPanel:get_miniTaskPanel();
	if win then
		if is_out_of_range == 0 then
			win:update_team_member_state( actorID,TeamModel.STATE_OUTOFRANGE )
		elseif is_out_of_range == 1 then
			win:update_team_member_state( actorID,TeamModel.STATE_ONLINE )
		end
	end
end


TeamModel.MEMBER_ATTR = {
	--名字，等级，职业，hp，mp,maxHp,maxMp,场景id,pos_x,pos_y,头像id，性别
	{"name","string"},{"lv","byte"},{"job","byte"},{"hp","int"},{"mp","int"},
	{"maxHp","int"},{"maxMp","int"},{"scene_id","word"},{"pos_x","int"},{"pos_y","int"}
	,{"head_id","word"},{"sex","byte"}
}

-- 设置队员的属性
function TeamModel:set_member_attr(actorID,pack)

	local member_struct = TeamModel:get_member_info_by_actor_id (actorID );
	
	if ( member_struct ) then
		local attr_num = pack:readByte();
		-- 设置队员的属性
		for i=1,#attr_num do
			local key = pack:readByte();
			local value = nil;
			if ( TeamModel.MEMBER_ATTR[key][2] == "string" ) then
				value = pack:readString();
			elseif ( TeamModel.MEMBER_ATTR[key][2] == "byte" ) then
				value = pack:readByte();
			elseif ( TeamModel.MEMBER_ATTR[key][2] == "int" ) then
				value = pack:readInt();
			elseif ( TeamModel.MEMBER_ATTR[key][2] == "word" ) then
				value = pack:readWord();
			end
			member_struct.TeamModel.MEMBER_ATTR[key][1] = value;
		end
	end
	-- -- 通知界面更新
	-- local win = UIManager:find_window("user_panel");
	-- if ( win ) then
	-- 	win:update(6);
	-- end
	MiniTaskPanel:get_miniTaskPanel():update_team_attr( actorID,member_struct)
end

-- 解散队伍
function TeamModel:remove_team()
	team_pick_up_type = nil;		--队伍的拾取方式
	team_member_num = 0;		--在线队伍成员的数量
	team_member_table = {}	--在线队伍成员的信息
	team_leader_actorID = 0;	--队长的actorID
	item_roll_min_pinzhi = 0;	--Roll物品的最低物品品质
	team_id  = 0;				--队伍id
	fuben_id = 0;				--副本id默认是0
	team_state = 0;			--队伍的副本状态	0,1=在创建队伍,等待进入副本的状态,2=已经进入副本战斗中
	-- 更新界面
	local team_win = UIManager:find_window("team_win")
	if team_win then
		team_win:update_btn( team_id  );
		team_win:get_recruit_info( )
	end
end

-- 退出队伍	
function TeamModel:exit_team()

	TeamCC:req_exit_team(  );
	print("离开队伍")
	-- 清除数据
	TeamModel:remove_team();
	-- 通知界面更新
	local win = UIManager:find_window("user_panel");
	if ( win ) then
		win:update(6);
		win:on_exit_team( );
	end
	--如果组队界面打开的话，要更新组队界面
	local team_win = UIManager:find_window("team_win")
	if team_win then
		team_win:update_btn( team_id  );
	end
end

-- 判断自己是不是队长
function TeamModel:is_leader(  )
	local player = EntityManager:get_player_avatar();
	if ( player.id ==  team_leader_actorID ) then
		return true;
	end
	return false;
end

-- 设置队长
function TeamModel:set_leader( _team_leader_actorID )
	--print("TeamModel:set_leader")
	team_leader_actorID = _team_leader_actorID;
	-- 更新界面
	local win = UIManager:find_window("user_panel");
	if ( win ) then
		-- 更新队伍面板的队长标志
		win:update(7,{_team_leader_actorID});
		local is_leader = TeamModel:is_leader(  );
		-- 更新主界面的队长标志
		win:set_team_leader_spr_visible( is_leader );
	end
	-- 更新组队界面
	local team_win = UIManager:find_visible_window("team_win")
	if team_win then
		team_win:get_recruit_info( )
	end
end

-- 判断目标是否是自己的队友
function TeamModel:is_teammate( _actorID )
	for i=1,#team_member_table do
		if ( team_member_table[i].actor_id == _actorID ) then
			return true;
		end
	end
	return false;
end

-- 更新队友的属性
function TeamModel:update_teammate_attr( handle,actor_id,attr_tab )

end

-- 广播队友死亡或复活
function TeamModel:teammate_state( actor_id,is_die )
	local struct = TeamModel:get_member_info_by_actor_id( actor_id )
	if ( struct ) then
		if ( is_die == 0 ) then
			GlobalFunc:create_screen_notic(struct.name..LangModelString[472]) -- [472]="死亡"
		else
			GlobalFunc:create_screen_notic(struct.name..LangModelString[473]) -- [473]="复活"
		end
	end
end
