--create by jiangjinhong 
--TeamActivityMode.lua
--组队副本
TeamActivityMode ={}
local _current_btn = 1   --第几个副本
local _current_fuben_info ={} --当前按钮对应的副本客户端信息
local _current_fuben_times = {} --服务器下发当前副本次数等信息
local _team_fuben_time = {} --组队副本次数信息

local _team_fuben_type_num = 5 	-- 队伍的副本类型数量，目前有4个组队副本+“无”副本类型的队伍
local _fuben_id_table = {12,81,82,83,0}	-- 创建队伍时选择的副本类型对应的副本id
local _team_display_filter = {[12] = true,[81] = true,[82] = true,[83] = true, [0] = true} 	-- 根据副本类型对队伍显示进行筛选
local _all_team_info = nil	-- 以前队伍信息立即发到window，现在需要暂存进行筛选发送。

--获取单个副本信息
function TeamActivityMode:get_fuben_info( index )
	local fuben_info = TeamActivityConfig:get_fuben_info( index )
	return fuben_info
end
--当前按钮对应的副本信息
function TeamActivityMode:get_select_fuben_info(  )
	_current_fuben_info = TeamActivityConfig:get_fuben_info( _current_btn )
	return _current_fuben_info
end
--获取配置表中副本数量
function TeamActivityMode:get_fuben_num(  )
	local btn_num = TeamActivityConfig:get_fuben_num(  )
	return btn_num
end
--当前副本选择页左侧按钮选中个数
function TeamActivityMode:get_now_select_btn(  )
	return _current_btn
end
function TeamActivityMode:set_now_select_btn( index )
	_current_btn = index
end
--获取组队队伍页标题
function TeamActivityMode:get_zudui_title(  )
	return _current_fuben_info.zudui_title
end
--当前按钮对应的副本的 副本id
function TeamActivityMode:get_fuben_id(  )
	return _current_fuben_info.fuben_id
end
--当前按钮对应的副本是否开启
function TeamActivityMode:if_open(  )
	return _current_fuben_info.if_open
end
--获取副本组队界面 所有副本id
function TeamActivityMode:get_all_fuben_listid(  )
	local listid = TeamActivityConfig:get_all_fuben_listid( )
	return listid
end
--服务器下发的 副本信息中是否有组队副本信息
function TeamActivityMode:if_have_team_fuben( listid )
	local all_fuben_listid =TeamActivityMode:get_all_fuben_listid(  )
	if all_fuben_listid ~= nil then 
		for i=1,#all_fuben_listid do
			if all_fuben_listid[i] == listid then 
				return true 
			end 
		end
	end
	return false  
end
function TeamActivityMode:get_fuben_listid(  )
	return _current_fuben_info.fuben_listid
end
function TeamActivityMode:get_fuben_name(  )
	return _current_fuben_info.fuben_name
end
--当前副本增加次数需要的元宝
function TeamActivityMode:get_fuben_add_price(  )
	local fuben_listid =TeamActivityMode:get_fuben_listid(  )
	local price = FubenConfig:get_cost_by_listId(fuben_listid)
	return price
end
--获取当前选择的副本的次数信息
function TeamActivityMode:get_current_fuben_times(  )
	local fuben_listid =TeamActivityMode:get_fuben_listid(  )
	if fuben_listid ~= -1 then 
		local  str = string.format("ShowFubenList,%d",fuben_listid)
    	GameLogicCC:req_talk_to_npc( 0, str)
    end 
end
function TeamActivityMode:update_times( now_fuben )
	local table = {fuben_listid = 0,total_num = 0,can_enter_num= 0,have_enter_num =0}
	if now_fuben.fuben_type == 1 then 
		table.fuben_listid = now_fuben.fbListId
		table.total_num = now_fuben.sub_list[1].totalCount
		table.can_enter_num = now_fuben.sub_list[1].remainCount
		table.had_enter_num =table.total_num - table.can_enter_num
	end 
	local win = UIManager:find_visible_window("activity_Win")
	if win then
		win:change_page(5)
		win:update_win("update_fuben_num",table)
	end 
end
--从服务器下发的副本信息中提取组队副本信息
function TeamActivityMode:get_all_fuben(  )
	local all_fuben = FuBenModel:get_fuben_info_table()
	-- for i=1,#all_fuben do
	-- 	ZXLog("副本信息i：",i,all_fuben[i].list_id)
	-- end
	local all_team_fuben_listid =TeamActivityMode:get_all_fuben_listid(  )
	for i=1,#all_team_fuben_listid do
		--为-1 时 表示未开的副本
		if all_team_fuben_listid[i] ~= -1 then 
			for j =1,#all_fuben do 
				if all_team_fuben_listid[i] == all_fuben[j].list_id then 
					local table = {fbListId = 0,can_enter_num = 0  }
					table.fbListId = all_fuben[j].list_id
					table.can_enter_num = all_fuben[j].remain_count
					_team_fuben_time[i] = table
				end 
			end
		else 
			local table = {fbListId = -1,can_enter_num = 0  }
			_team_fuben_time[i] = table 
		end
	end
end
function TeamActivityMode:get_fuben_can_enter_times( index )
	local one_fuben = _team_fuben_time[index]
	return one_fuben
end
-- ------------------队伍页面相关---------------------------
local status_list = {};      --保存的队员的状态列表

--------------------------------私有变量(聚仙令部分)----------------------
local tokens_count = {0,0,0}	--3令的数量
local tokens_type  = {8,9,10}	--3令依次对应的货币类型
local tokens_name  = {Lang.juxianling[6],Lang.juxianling[7],Lang.juxianling[8]}
--------------------------------私有变量(end)----------------------


function TeamActivityMode:fini( ... )
	tokens_count = {0,0,0}
	_team_display_filter = {[12] = true,[81] = true,[82] = true,[83] = true, [0] = true}
	_all_team_info = nil
	-- xprint("UIManager:destroy_window,JuxianlingModel:fini( ... )")
	UIManager:destroy_window("team_win")

end
-- 获取令牌拥有的数量
function TeamActivityMode:get_tokens_count()
	return tokens_count
end
-- 根据货币类型获取某种令牌的总数
function TeamActivityMode:get_tokens_count_by_type(type)
	if type == tokens_type[1] then
		return tokens_count[1]
	elseif type == tokens_type[2] then
		return tokens_count[2]
	elseif type == tokens_type[3] then
		return tokens_count[3]
	end
	return 0
end
-- 根据货币类型获取某种令牌的名字
function TeamActivityMode:get_tokens_name_by_type(type)
	if type == tokens_type[1] then
		return tokens_name[1]
	elseif type == tokens_type[2] then
		return tokens_name[2]
	elseif type == tokens_type[3] then
		return tokens_name[3]
	end
	return nil
end
-- 根据货币类型获取某种令牌的序号
function TeamActivityMode:get_index_by_type(type)
	if type == tokens_type[1] then
		return 1
	elseif type == tokens_type[2] then
		return 2
	elseif type == tokens_type[3] then
		return 3
	end
	return 1
end
-- 更新副本招募信息
function TeamActivityMode:update_recruit_info( recruit_info )
	-- 拿到的数据，如果不是空的话，先排序一下，把玩家自己创建的队伍排在最前面
	if recruit_info.team_info_list[1] ~= nil and recruit_info.team_info_list[1].captain_name ~= "" then
		local player_index = nil
		local player = EntityManager:get_player_avatar()
		for i=1,recruit_info.team_count do
			if recruit_info.team_info_list[i].captain_name == player.name then
				player_index = i
				break
			end
		end
		if player_index ~= nil then
			local team_info = {team_id,captain_name,count,zhanli}
			for k,v in pairs(recruit_info.team_info_list[1]) do
				team_info[k] = recruit_info.team_info_list[1][k]
				recruit_info.team_info_list[1][k] = recruit_info.team_info_list[player_index][k]
				recruit_info.team_info_list[player_index][k] = team_info[k]
			end
		end
	end
	_all_team_info = recruit_info;
	
	-- 刷新页面
	TeamActivityMode:update_win_with_filter()
end
--删除队员后重新请求副本招募信息
function TeamActivityMode:get_recruit_info( )
	local win = UIManager:find_visible_window("team_win");
	if win then
		win:get_recruit_info()
	end
end
-- 更新队伍信息
function TeamActivityMode:update_team_info(team_info )
	local win = UIManager:find_window("team_win");
	if win then
		win:refresh_team_list(team_info)
	end

end
-- 申请入队回应
function TeamActivityMode:join_req(player_info )
	local win = UIManager:find_visible_window("team_win");
	if win then
		win:join_req(player_info)
	else
		TeamCC:req_leader_replay(player_info.userId,1)
	end

end
-- 获取聚仙令副本当日的已进入次数和最大次数
function TeamActivityMode:get_enter_fuben_count( fuben_id )
	local a1,b1 = ActivityModel:get_enter_fuben_count( fuben_id)
	-- 因为服务器默认最大次数default_max_count为0，需要客户端自+1显示
	return a1+1,b1+1
end

-- 请求增加副本次数
function TeamActivityMode:add_erter_fuben_times( )
	local need_item_id = 24400
	local fuben_id = TeamActivityMode:get_fuben_id()
	local count = ItemModel:get_item_total_num_by_id( need_item_id )
	--if count > 0 then
		OthersCC:request_add_enter_fuben_count( fuben_id )
	--end

end
-- 更新队员状态
function TeamActivityMode:update_status(actor_id,status )
	-- 保存已准备的队员ID
	local count = #status_list
	local has = false
	if count ==20 then
		status_list = {}	
	end
	for i=1,count do
		if status_list[i].id ==actor_id then
			status_list[i].type = status
			has = true
		end
	end
	if not has then
		local actor_status = {}
		actor_status.id = actor_id
		actor_status.type = status
		status_list[count+1] = actor_status
	end
	local win = UIManager:find_visible_window("team_win")
	if win then 
		win:update_status(actor_id,status)
	end
end

function TeamActivityMode:get_status( )
	return status_list
end
function TeamActivityMode:clear_status( ... )
	status_list = {}
end
-- 获取第一页招募副本信息
function TeamActivityMode:get_first_recruit_info(num_fuben )
	TeamActivityCC:req_get_recruit_info(num_fuben,1)
end

function TeamActivityMode:req_make_team( num_fuben, fuben_type )
	local fuben_id = _fuben_id_table[fuben_type];
	TeamActivityCC:req_make_team(num_fuben,fuben_id)
end

-- 根据服务器传过来的队伍的副本id转化为副本类型序号（之后可以针对性拿到图片）。
function TeamActivityMode:get_team_fuben_type( t_fuben_id )
	local fuben_type = 0
	for i=1,#_fuben_id_table do
		if _fuben_id_table[i] == t_fuben_id then
			fuben_type = i;
			break;
		end
	end
	return fuben_type;
end

-- 获得队伍过滤表
function TeamActivityMode:get_team_display_filter()
	return _team_display_filter;
end

-- 根据显示状态表设置队伍过滤表
function TeamActivityMode:set_team_display_filter(t_state_table)
	for i=1,_team_fuben_type_num do
		local t_fuben_id = _fuben_id_table[i];
		if t_state_table[i] == true then
			_team_display_filter[t_fuben_id] = true
		else
			_team_display_filter[t_fuben_id] = false
		end
	end
end

-- 重置过滤表。关闭窗口时重置一次。
function TeamActivityMode:reset_team_display_filter()
	_team_display_filter = {[12] = true,[81] = true,[82] = true,[83] = true, [0] = true}
end

-- 获得各种副本队伍类型的显示状态表
function TeamActivityMode:get_team_display_state_table()
	local state_table = {}
	for i=1,_team_fuben_type_num do
		local t_fuben_id = _fuben_id_table[i];
		if _team_display_filter[t_fuben_id] == true then
			state_table[i] = true;
		else
			state_table[i] = false;
		end
		-- print("第",i,"个副本类型状态为",state_table[i])
	end
	return state_table;
end

-- 根据过滤表刷新窗口信息
function TeamActivityMode:update_win_with_filter()
	if _all_team_info == nil then
		return;
	end

	-- 如果组队数据不为空，则进行过滤操作。
	local filer_data = {}
	if _all_team_info.team_info_list[1] ~= nil and _all_team_info.team_info_list[1].captain_name ~= "" then
		filer_data.team_count = 0;
		filer_data.num_fuben = _all_team_info.num_fuben;
		filer_data.pages = _all_team_info.pages;
		filer_data.num_page = _all_team_info.num_page
		filer_data.team_info_list = {}
		for k=1,_all_team_info.team_count do
			local t_team_fuben_id = _all_team_info.team_info_list[k].team_fuben_id
			if _team_display_filter[t_team_fuben_id] == true then
				filer_data.team_count = filer_data.team_count+1
				filer_data.team_info_list[filer_data.team_count] = _all_team_info.team_info_list[k];
			end
		end
	else
		filer_data = _all_team_info
	end
	local win = UIManager:find_window("team_win");
	if win then
		win:update_self_info(filer_data)
	end
end