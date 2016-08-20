--zyb
--2014-4-14
--协议号154
TeamActivityCC = {}

-- 154,1 c->s 获取副本招募信息
function TeamActivityCC:req_get_recruit_info( num_fuben,num_page )
	print("获取副本招募信息",num_fuben,num_page)
	local pack = NetManager:get_socket():alloc(154,1);
	pack:writeInt(num_fuben)
	pack:writeInt(num_page)
	NetManager:get_socket():SendToSrv(pack);
end

--154,1 s->c 发送副本招募信息
function TeamActivityCC:do_fuben_team_info(pack)
	local recruit_info={team_count=0}
	
	recruit_info.num_fuben = pack:readInt(); --1 2 3 聚贤令副本 4 深海之恋
	recruit_info.pages = pack:readInt();  --总页数
	recruit_info.num_page = pack:readInt();  --第几页
	local team_num = pack:readInt();  --该页有多少个队伍
	recruit_info.team_info_list = {};
	recruit_info.team_count = 0
	print("发送副本招募信息",recruit_info.num_fuben,team_num)
	for i=1,team_num do
		local team_info={team_id,captain_name,count,zhanli}
		team_info.team_id = pack:readUInt(); 
		team_info.team_fuben_id = pack:readInt(); 
		team_info.captain_name = pack:readString(); 
		team_info.captain_job = pack:readInt();
		team_info.captain_sex = pack:readInt();
		team_info.count = pack:readInt(); 
		team_info.zhanli = pack:readInt(); 
		--过滤掉数组值为空的情况
		if team_info.team_id == 0 then
			
		else
			recruit_info.team_count = recruit_info.team_count+1
			recruit_info.team_info_list[recruit_info.team_count] = team_info  --队伍信息
		end 
	end
	TeamActivityMode:update_recruit_info( recruit_info );
end

-- 154,2 c->s 申请入队回应
function TeamActivityCC:req_apply_team_result( player_id,result )
	local pack = NetManager:get_socket():alloc(154,2);
	pack:writeInt(player_id)
	pack:writeByte(result)
	NetManager:get_socket():SendToSrv(pack);
end

--154,2 s->c 发送申请入队回应
function TeamActivityCC:do_apply_ans(pack)
	print("发送申请入队回应",pack:readByte())
end

-- 154,3 c->s 发布招募
function TeamActivityCC:req_release_recruit( num_fuben )
	local pack = NetManager:get_socket():alloc(154,3);
	pack:writeInt(num_fuben)
	NetManager:get_socket():SendToSrv(pack);
end

-- 154,5 c->s 申请入队
function TeamActivityCC:req_apply_team( team_id )
	local pack = NetManager:get_socket():alloc(154,5);
	pack:writeUInt(team_id)
	NetManager:get_socket():SendToSrv(pack);
end

-- 154,5 s->c 申请入队回应
function TeamActivityCC:do_join_req(pack)
	--print("收到申请回应")
	local user_info = {}
	user_info.userId = pack:readInt()
	user_info.userName = pack:readString()
	user_info.job = pack:readByte()
	user_info.level = pack:readInt()
	user_info.fight = pack:readInt() 
	TeamActivityMode:join_req( user_info );
	-- 跑马灯提示
	GlobalFunc:create_screen_notic( string.format("%s加入你的队伍",user_info.userName) )
end

-- 154,6 c->s 进入副本
function TeamActivityCC:req_enter_fuben( num_fuben, fuben_id )
	local pack = NetManager:get_socket():alloc(154,6);
	pack:writeInt(num_fuben)
	pack:writeInt(fuben_id)
	NetManager:get_socket():SendToSrv(pack);
end

-- 154,7 c->s 创建队伍
function TeamActivityCC:req_make_team( num_fuben, fuben_id)
	local pack = NetManager:get_socket():alloc(154,7);
	pack:writeInt(num_fuben)
	pack:writeInt(fuben_id)
	NetManager:get_socket():SendToSrv(pack);
end

-- 154,9 c->s 请求队伍信息
function TeamActivityCC:req_team_info( team_id )
	local pack = NetManager:get_socket():alloc(154,9);
	pack:writeUInt(team_id)
	NetManager:get_socket():SendToSrv(pack);
end

--154,9 s->c 发送队伍信息
function TeamActivityCC:do_team_info(pack)
	local team_info = {}
	team_info.team_id = pack:readUInt()
	team_info.count = pack:readInt()   --队伍人数

	for i=1,team_info.count do
		team_info[i] = {}
		team_info[i].userId = pack:readInt()
		team_info[i].userName = pack:readString()
		team_info[i].level = pack:readInt()
		team_info[i].fight = pack:readInt()
		team_info[i].sex = pack:readInt()
		team_info[i].job = pack:readInt()
	end
	TeamActivityMode:update_team_info( team_info );
end

-- c->s 154,8   请求增加副本次数
-- @fuben_id 副本id
function TeamActivityCC:req_add_fuben_times(fuben_id)
	local pack = NetManager:get_socket():alloc(154,8)
	pack:writeInt(fuben_id)
	NetManager:get_socket():SendToSrv(pack)
end
-- c->s 154,10  请求令牌数
function TeamActivityCC:req_token_count( )
	local pack = NetManager:get_socket():alloc(154,10)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 154,10  下发3令数量的处理
function TeamActivityCC:do_tokens_count( pack )
	local t = TeamActivityMode:get_tokens_count()
	t[1] = pack:readInt()
	t[2] = pack:readInt()
	t[3] = pack:readInt()
	local win = UIManager:find_visible_window("juxianling_win")
	if win then 
		if win:get_page_by_index(1) then
			win:get_page_by_index(1):update("token")
		end
		if win:get_page_by_index(2) then
			win:get_page_by_index(2):update("token")
		end
	end
end

--S->C 154,13队员准备信息
function TeamActivityCC:do_team_ready( )
	local ready = pack:readInt()
end

-- s->c 154,15 队长发布招募信息
function TeamActivityCC:do_leader_recruit_info( pack )
	-- local fuben_index = pack:readInt();
	-- TeamWin:show(fuben_index);
	-- GlobalFunc:create_screen_notic(string.format("队长在%s发布招募信息",TeamModel.FUBEN_NAME[fuben_index]));
end