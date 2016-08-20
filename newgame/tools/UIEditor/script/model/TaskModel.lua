-- TaskModel.lua
-- create by hcl on 2012-12-3
-- 任务模型

-- super_class.TaskModel()
TaskModel = {}
-- require "config/QuestConfig"
-- require "config/MonsterConfig"
-- require "struct/TaskProcessStruct"

-- 可接任务id列表
--local tab_kejie_type_tasks = {{},{},{}};
local tab_kejie_tasks = {};
local kejie_task_num = 0;

-- 已接任务id列表
--local tab_yijie_type_tasks = {{},{},{}};
local tab_yijie_tasks = {};
local yijie_task_num = 0;
-- 已接任务进度列表
local tab_yijie_process= { } ;
-- 章节奖励领取状态表
local chapter_award_states = {}

TYPE_YIJIE = 1;
TYPE_KEJIE = 2;

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

-- added by aXing on 2013-5-25
function TaskModel:fini( ... )
	tab_kejie_tasks = {};
	kejie_task_num = 0;
	tab_yijie_tasks = {};
	yijie_task_num = 0;
	tab_yijie_process= { } ;
	-- 清除主界面任务栏
	UIManager:destroy_window("user_panel");
	-- 清除下面按钮栏
	UIManager:destroy_window("menus_panel");
	-- 清除活动界面
	UIManager:destroy_window("activity_menus_panel");
	-- 清除右上角的按钮
	UIManager:destroy_window("right_top_panel");
	-- 清除所有对话框
	UIManager:destroy_window("dialog_manager");
	-- 清除剧情动画
	JQDH:destroy();
	-- 清除小按钮
	UIManager:destroy_window("mini_btn_win");
	
end

-- 每次任务栏打开是询问是否需要更新数据
function TaskModel:active( show )
	if ( show ) then
		if ( #tab_kejie_tasks == 0 ) then
			-- 请求已接任务列表
    		TaskCC:req_task_list();
		end
	end
end

function TaskModel:get_process_list()
	return tab_yijie_process;
end

-- type 1 =可接列表，2=已接列表
function TaskModel:set_tasks_list( table ,type,num)
	print("@@@@@@@@@@@TaskModel:set_tasks_list( table ,type,num)",table,type,num)
	if ( type == 1) then
		tab_kejie_tasks = table;
		kejie_task_num = num;
		-- print("TaskModel:set_tasks_list( table ,type,num)",table,type,num)
		-- 更新ui
		MiniTaskPanel:update_kejie_task_num( kejie_task_num )
	else
		tab_yijie_tasks = table;
		yijie_task_num = num;

		-- 判断是否有仙宗，如果没有仙宗就清除仙宗任务
		local player = EntityManager:get_player_avatar();
	    if ( player and player.guildId == 0 ) then
			-- 清除仙宗任务
			TaskModel:clear_xz_quest(  )
		end
		-- 判断当前跑环环数，如果是0就清除跑环任务
	end
end

function TaskModel:get_yijie_tasks_list(  )
	return tab_yijie_tasks,yijie_task_num;
end

-- 取得分类好的任务列表
function TaskModel:get_kejie_tasks_list()
	return tab_kejie_tasks,kejie_task_num;
end
-- 取得对应任务id的静态配置表数据
function TaskModel:get_info_by_task_id( task_id )
	--print("TaskModel:get_info_by_task_id:quest_id = ",task_id);
	return QuestConfig:get_quest_by_id(task_id);
end

-- 取得任务目标，任务描述，任务奖励的文字 type 1 = 已接任务 type 2 = 可接任务
function TaskModel:get_task_str_by_task_id( task_id ,task_type,is_only_target)
	-- print("TaskModel:get_task_str_by_task_id( task_id ,task_type,is_only_target)",task_id,task_type)
	local info = self:get_info_by_task_id( task_id );
	local npc_str = "";
	local scene_str = "";
	-- 是否完成
	local is_finish = false;
	-- 是否需要计时
	local time = 0;
	-- 返回的任务目标字符串
	local target_str = "";
	
	-- 如果没有target，则是对话任务
	if ( #info.target == 0  ) then
		-- if ( task_type == TYPE_KEJIE ) then
		-- 	npc_str = info.prom.npc;
		-- 	scene_str = info.prom.scene; 
		-- elseif ( task_type == TYPE_YIJIE ) then
		-- 	npc_str = info.comp.npc;
		-- 	scene_str = info.comp.scene; 
		-- 	if ( scene_str == nil) then
		-- 		scene_str = "";
		-- 	end
		-- end
		-- -- 任务目标
		-- target_str = string.format("#c66ff66去%s",scene_str );
		-- target_str = target_str.."寻找#cfff000"..npc_str;
		target_str = TaskModel:get_ask_npc_str( task_type,info );
		is_finish = true;
	else
		local quest_target_table = info.target[1];

		-- 取得目标任务的进度值
		-- TODO 可能会有多个目标
		local value = self:get_process_value(task_id );
		if ( value==nil ) then
			value = 0;
		end
		-- 如果任务未完成
		if ( value < quest_target_table.count ) then
			-- 打怪和采集任务
			if ( quest_target_table.type == 0 ) then
				if ( info.starid == 1 and task_type == TYPE_KEJIE ) then
					target_str = Lang.task[9]; -- [9]="打开#cff49f4斩妖除魔榜#cffffff接受任务"
				elseif (info.starid == 4 and task_type == TYPE_KEJIE ) then
					target_str = TaskModel:get_ask_npc_str( task_type,info );
				elseif (info.starid == 3 and task_type == TYPE_KEJIE ) then
					target_str = TaskModel:get_ask_npc_str( task_type,info );
				else
					local monster_info = MonsterConfig:get_monster_by_id( quest_target_table.id );
					-- 任务目标数据
					if ( quest_target_table.data~=nil ) then
						local scene_name =  Utils:Split(quest_target_table.data, "/")[1];
						target_str = string.format( LH_COLOR[2] .. Lang.task[10],scene_name ); -- [10]="#c66ff66去%s"
					else
						local scene_name = ""
						if quest_target_table.location.fubenid == nil then
							SceneConfig:get_scene_name_by_id( quest_target_table.location.sceneid )
						else
							SceneConfig:get_scene_name_by_id( quest_target_table.location.sceneid , quest_target_table.location.fubenid)
						end
						target_str = string.format( LH_COLOR[2] .. Lang.task[10],scene_name ); -- [10]="#c66ff66去%s"
					end
					-- 判断是否采集怪
					if ( monster_info.entityType == 12 ) then
						target_str = target_str..Lang.task[11]..monster_info.name .. "#ce0fcff("..value.."/"..quest_target_table.count..")"; -- [11]="采集#cfff000"
					elseif ( monster_info.entityType == 1 ) then
						target_str = target_str..Lang.task[12]..monster_info.name.. "#ce0fcff("..value.."/"..quest_target_table.count..")"; -- [12]="击杀#cfff000"
					end
				end
			-- 购买道具
			elseif ( quest_target_table.type == 1 ) then
				target_str = quest_target_table.data;

				target_str = Utils:Split(target_str, "/")[1];
				local item_id = quest_target_table.id;
				local count = quest_target_table.count;
				target_str =  target_str ..count..Lang.task[13]..ItemConfig:get_item_name_by_item_id( item_id ).."#cffffff" -- [452]="个#c66ff66"
				-- 添加进度值字符串
				target_str = TaskModel:add_process_str( target_str,task_id,quest_target_table )  
			-- 角色的等级达标
			elseif ( quest_target_table.type == 5 ) then
				target_str = Lang.task[14]..quest_target_table.count..Lang.task[15]; -- [14]="达到等级" -- [15]="#r#cff8c00【如何升级？】"
			elseif ( quest_target_table.type == 7 ) then
			elseif ( quest_target_table.type == 40 ) then
				target_str = quest_target_table.data;
				target_str = Utils:Split(target_str, "/")[1];
				-- 添加进度值字符串
				target_str = TaskModel:add_process_str( target_str,task_id,quest_target_table )
			elseif ( quest_target_table.type == 127 ) then
				
				local value = self:get_process_value(task_id );
				if ( value==nil ) then
					value = 0;
				end
				-- 如果是跑环任务
				if ( info.loopid  ) then

					if ( quest_target_table.data == nil ) then
						local monster_info = MonsterConfig:get_monster_by_id( quest_target_table.id );
						if ( quest_target_table.location ) then
							local scene_name = SceneConfig:get_scene_name_by_id( quest_target_table.location.sceneid  )
							target_str = string.format(LH_COLOR[2] .. Lang.task[10],scene_name ); -- [449]="#c66ff66去%s"
							-- 判断是否采集怪
							if ( monster_info.entityType == 12 ) then
								target_str = target_str..Lang.task[11]..monster_info.name .. "#cffffff("..value.."/"..quest_target_table.count..")"; -- [450]="采集#cfff000"
							elseif ( monster_info.entityType == 1 ) then
								target_str = target_str..Lang.task[12]..monster_info.name.. "#cffffff("..value.."/"..quest_target_table.count..")"; -- [451]="击杀#cfff000"
							end
						else
							target_str = info.content;
						end
					else
						target_str = quest_target_table.data;
						target_str = Utils:Split(target_str, "/")[1];
						-- 添加进度值字符串
						target_str = TaskModel:add_process_str( target_str,task_id,quest_target_table )  
					end
				else
					-- 护送仙女任务
					if ( task_type == TYPE_KEJIE ) then
						-- target_str = "去天元城寻找#cfff000潇月";
						-- 127的可接任务直接访问npc
						target_str = TaskModel:get_ask_npc_str( task_type,info );
					else
						local start_time = 0;
						target_str = quest_target_table.data;
						target_str = Utils:Split(target_str, "/")[1];
						-- 添加进度值字符串
						target_str,time,start_time = TaskModel:add_process_str( target_str,task_id,quest_target_table,info.starid )  
						if ( info.starid == 2 and task_type == 1  ) then
							-- 任务限制的时间
							if ( time > 0  ) then
								target_str = target_str .. Lang.task[16]; -- [455]="#r#cfff000剩余时间:"
							else
								local curr_time = math.floor(os.clock());
								-- print("curr_time =",curr_time,start_time)
								time = 20 * 60 -  ( curr_time- start_time );
								target_str = target_str .. Lang.task[16]; -- [455]="#r#cfff000剩余时间:"
							end
						-- SB策划时隔3个月后又想去掉这个24小时后免费领取神兵利器的功能，所以注释掉
						-- elseif ( info.starid == 5) then
						-- 	-- 中级强化石任务starid=5。add by gzn
						-- 	if (time > 0) then
						-- 		-- 此情况，time是do_task_list()拿到的
						-- 		target_str = target_str .. Lang.task[16]; -- [455]="#r#cfff000剩余时间:"
						-- 	elseif (time == -1) then
								
						-- 	else
						-- 		-- 此情况，time是do_new_task()拿到的
						-- 		local curr_time = math.floor(os.clock());
						-- 		-- print("curr_time =",curr_time,start_time)
						-- 		time = info.timelimit -  ( curr_time- start_time );
						-- 		target_str = target_str .. Lang.task[16]; -- [455]="#r#cfff000剩余时间:"
						-- 	end
						end
					end
				end
			end
		else
			if (  info.comp.type == 0 ) then
				-- npc_str = info.comp.npc;
				-- scene_str = info.comp.scene;
				-- target_str = string.format("#c66ff66去%s寻找#cfff000%s",scene_str, npc_str); 
				target_str = TaskModel:get_ask_npc_str( task_type,info );
			else
				-- 判断是不是刷星任务
				if ( info.starid == 1 ) then
					target_str = Lang.task[17]; -- [456]="打开#cff49f4征伐榜#cffffff完成任务"
				end

			end
			is_finish = true;
		end

		
	end

	target_str = target_str;

	if ( is_only_target ) then
		return target_str,is_finish,time;
	end

	-- 任务描述
	local content_str = info.content;
	-- 任务奖励
	local tab_awards = self:get_awards( task_id );
	
	return target_str,content_str,tab_awards,is_finish,time;
end

function TaskModel:get_ask_npc_str( task_type,task_info )
	local npc_str,scene_str,target_str = "";
	if ( task_type == TYPE_KEJIE ) then
		npc_str = Utils:parseNPCName(task_info.prom.npc);
		scene_str = task_info.prom.scene; 
	elseif ( task_type == TYPE_YIJIE ) then
		npc_str = Utils:parseNPCName(task_info.comp.npc);
		scene_str = task_info.comp.scene; 
		if ( scene_str == nil) then
			scene_str = "";
		end
	end
	-- 任务目标
	target_str = string.format(LH_COLOR[2] .. Lang.task[10],scene_str ); -- [449]="#c66ff66去%s"
	target_str = target_str..Lang.task[18]..LH_COLOR[12]..npc_str; -- [457]="寻找#cfff000"
	return target_str;
end

-- 添加进度值字符串
function TaskModel:add_process_str( source_str,quest_id,quest_target_table,quest_starid )

	local value,time,start_time = self:get_process_value(quest_id );
--	print("TaskModel:add_process_str...................start_time = ",start_time)
	if ( value == nil ) then
		value = 0;
	end
	if time ~= nil and time == 0 and quest_starid ~= nil and quest_starid == 5 then
		-- 中级强化石任务
		time = -1;
	end
	if ( time == nil ) then
		time = 0;
	end
	if ( start_time and time ~= 0 and time ~= -1) then
		local curr_time = math.floor(os.clock());
--		print("start_time = ",start_time,"curr_time",curr_time);
		local leave_time =  curr_time- start_time;
		time = time - leave_time;
	end
	local add_str = string.format("(%s/%s)",value,quest_target_table.count);
	source_str = source_str .. add_str;
	return source_str,time,start_time;		
end
-- 取得奖励
function TaskModel:get_awards( task_id )
	--print("TaskModel:task_id",task_id);
	local info = TaskModel:get_info_by_task_id( task_id );
	-- 任务奖励
	local tab_awards = {};
	local tab_awards_info = info.awards;
	for i=1,#tab_awards_info do
		local award = tab_awards_info[i];
		
		local player = EntityManager:get_player_avatar();
		-- 0 装备，1修为，2经验，3仙宗灵石，4阵营贡献，5绑定银两，6银两，
		-- 7，礼金，8称谓，9奖励技能，10奖励战魂，11成就点，12历练
		if ( award.type == 0 ) then
			--print("award.sex = ",award.sex,"player.sex",player.sex,"award.job",award.job,"player.job",player.job);
			if ( award.sex==nil and award.job == nil or award.sex == player.sex or award.sex == -1 and award.job == player.job ) then
				-- show_type 0 = 要显示icon图标和文字,1=只显示文字
				
				local icon_path = ItemConfig:get_item_icon( award.id );
				local icon_name = ItemConfig:get_item_by_id( award.id ).name 
				tab_awards[#tab_awards + 1] = { show_type = 0 ,icon_path = icon_path,icon_name = icon_name,bind = award.bing ,icon_count = award.count ,item_id = award.id};
			end
		elseif ( award.type == 1 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[19]..LH_COLOR[2]..award.count}; -- [458]="#cfff000修为 : #cffffff"
		elseif ( award.type == 2 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[20]..LH_COLOR[2]..award.count}; -- [20]="#cfff000经验 : #cffffff"
		elseif ( award.type == 3 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[21]..LH_COLOR[2]..award.count}; -- [21]="#cfff000仙宗贡献 : #cffffff"
		elseif ( award.type == 4 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[22]..LH_COLOR[2]..award.count}; -- [22]="#cfff000阵营贡献 : #cffffff"
		elseif ( award.type == 5 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[23]..LH_COLOR[2]..award.count}; -- [23]="#cfff000仙币 : #cffffff"
		elseif ( award.type == 6 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[24]..LH_COLOR[2]..award.count}; -- [24]="#cfff000银两 : #cffffff"
		elseif ( award.type == 7 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[25]..LH_COLOR[2]..award.count}; -- [25]="#cfff000礼金 : #cffffff"
		elseif ( award.type == 8 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[26]..LH_COLOR[2]..award.count}; -- [26]="#cfff000称谓 : #cffffff"
		elseif ( award.type == 9 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[27]..LH_COLOR[2]..award.count}; -- [27]="#cfff000技能 : #cffffff"
		elseif ( award.type == 10 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[28]..LH_COLOR[2]..award.count}; -- [28]="#cfff000战魂 : #cffffff"
		elseif ( award.type == 11 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[29]..LH_COLOR[2]..award.count}; -- [29]="#cfff000成就点 : #cffffff"
		elseif ( award.type == 12 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[30]..LH_COLOR[2]..award.count}; -- [30]="#cfff000历练 : #cffffff"
		elseif ( award.type == 14 ) then
			tab_awards[#tab_awards + 1] = { show_type = 1 , type = award.type,icon_count = award.count, str = LH_COLOR[13]..Lang.task[31]..LH_COLOR[2]..award.count}; -- [31]="#cfff000建设度:#cffffff"
		end
	end
	return tab_awards;
end

-- 取得目标任务的进度值
function TaskModel:get_process_value(task_id )
	for i=1,#tab_yijie_process do
		--print("tab_yijie_process[i].start_time",tab_yijie_process[i].start_time)
		if ( tab_yijie_process[i].task_id == task_id ) then
			return tab_yijie_process[i].tab_process[1],tab_yijie_process[i].time,tab_yijie_process[i].start_time;
		end
	end
end
-- 设置目标任务的进度值 
function TaskModel:set_process_value(task_id,index,value)
	for i=1,#tab_yijie_process do
		if ( tab_yijie_process[i].task_id == task_id ) then
			tab_yijie_process[i].tab_process[index] = value;
			return;
		end
	end
end
-- 添加已接任务
function TaskModel:add_yijie_task( task_id )
	
	if ( TaskModel:is_zhuxian_quest( task_id ) ) then
		table.insert(tab_yijie_process,1,TaskProcessStruct(nil,task_id))
		table.insert(tab_yijie_tasks,1,task_id)
	else
		-- 不是主线就插到二个
		if ( #tab_yijie_tasks > 0 ) then
			table.insert(tab_yijie_process,2,TaskProcessStruct(nil,task_id))
			table.insert(tab_yijie_tasks,2,task_id)
		else
			table.insert(tab_yijie_process,TaskProcessStruct(nil,task_id))
			table.insert(tab_yijie_tasks,task_id)
		end
	end

	yijie_task_num = #tab_yijie_tasks;

	-- 先去删除可接列表任务
	self:remove_kejie_task( task_id )
	
	LuaEffectManager:play_scene_effect( 1,_refWidth(0.5), _refHeight(0.8), 1000 )
	local win = UIManager:find_window( "user_panel" ) 
	if ( win ) then
		win:update(1);
	end

	-- 接到任务时，更新新手指引的状态,如果XSZYManager:update_state返回true则不继续任务
	-- if XSZYManager:update_state(task_id, 1) then		
	-- 	return
	-- elseif not AIManager:is_doing_zx_quest() and not self:is_paohuan_quest(task_id) then
	-- 	AIManager:do_quest(task_id, 1)
	-- end

	-- 接到任务，如果发现有新手引导，则不回去自动做任务
	-- local instruction_id 	= Instruction:check_quest(task_id, 1)	-- 1=接任务后, 2=完成任务后
	local is_doing_zx_quest = AIManager:is_doing_zx_quest()
	local is_paohuan_quest 	= self:is_paohuan_quest(task_id)
	
	-- if instruction_id ~= nil then
	-- 	Instruction:start(instruction_id)
	if not is_doing_zx_quest and not is_paohuan_quest then
		-- 如果AIManager当前没有在执行主线任务
		print("***** shit **********", instruction_id, is_doing_zx_quest, is_paohuan_quest)	
		AIManager:do_quest(task_id, 1)
	end
end
-- 删除已接任务
function TaskModel:remove_yijie_task( task_id )
	for i=1,#tab_yijie_tasks do
		if ( tab_yijie_process[i] and tab_yijie_process[i].task_id == task_id ) then
			table.remove( tab_yijie_process , i );
		end
		if ( tab_yijie_tasks[i] == task_id ) then
			table.remove( tab_yijie_tasks,i );
			-- break;
		end
	end
	yijie_task_num = #tab_yijie_tasks;
	--print("删除已接任务结果,yijie_task_num = " ,yijie_task_num);
end

-- 增加可接任务
function TaskModel:add_kejie_task( task_id, is_zhuxian )
	local renzhe_task_t = {}
	-- 添加已接任务列表
	if is_zhuxian then
		table.insert(tab_kejie_tasks, 1, task_id)
	else
		table.insert(tab_kejie_tasks, task_id)
	end
	kejie_task_num = #tab_kejie_tasks

	-- 更新ui
	MiniTaskPanel:update_kejie_task_num( kejie_task_num )
end

-- 删除可接任务
function TaskModel:remove_kejie_task( task_id )
	-- for k,v in pairs(tab_kejie_tasks) do
	-- 	print("TaskModel:remove_kejie_task(  )",k,v)
	-- end
	local remove_index = 0;
	local task_info = self:get_info_by_task_id( task_id )
	if task_info.starid and task_info.starid > 0 then
		for i,v in ipairs(tab_kejie_tasks) do
			local info = self:get_info_by_task_id( v );
			if task_info.starid == info.starid then
				remove_index = i;
				break;
			end
		end
	else
		for i=1,#tab_kejie_tasks do
			if ( tab_kejie_tasks[i] == task_id ) then
				remove_index = i;
				break;
			end
		end
	end
	if remove_index > 0 then
		table.remove(tab_kejie_tasks,remove_index);
		kejie_task_num = kejie_task_num - 1;
	    -- print("TaskModel:remove_kejie_task( task_id )",task_id,kejie_task_num,#tab_kejie_tasks);
		-- 更新ui
		MiniTaskPanel:update_kejie_task_num( kejie_task_num )
	end
end

-- 判断一个有进度值的任务是否完成(例如杀怪任务)
function TaskModel:is_quest_finish( quest_id ,quest_value)
	local quest_tab = QuestConfig:get_quest_by_id(quest_id)

	if ( quest_value and quest_tab.target ) then
		-- 提交任务的type如果是0则要返回npc处对话，如果不是0则会自动完成
		print('quest_tab',quest_tab,quest_tab.target[1])
		if quest_tab.target[1] then
			if ( quest_tab.target[1].count == quest_value and  quest_tab.comp.type == 0) then
				return true;
			end
		end
	end

	return false;
end
-- 判断是否主线任务
function TaskModel:is_zhuxian_quest( quest_id )
	local task_info = TaskModel:get_info_by_task_id( quest_id );
	
	-- 卡级任务和魔劫爆发任务不算主线任务
	if ( task_info.type == 0 and quest_id ~= 332 ) then
		-- local quest_target_table = task_info.target[1];
		-- if ( quest_target_table and quest_target_table.type == 5 ) then
		-- 	return false;
		-- end
		return true;
	end
	return false;
end

-- 判断是否跑环任务
function TaskModel:is_paohuan_quest( quest_id )
	local task_info = TaskModel:get_info_by_task_id( quest_id );
	if ( task_info.loopid ) then
		return true;
	end
	return false;
end

-- 取得提交任务的场景
function TaskModel:get_commit_quest_scene( quest_id )
	print('quest_id,', quest_id)
	local quest_info = TaskModel:get_info_by_task_id( quest_id );
	local sceneid  = SceneConfig:get_id_by_name( quest_info.comp.scene );
	return sceneid;
end

function TaskModel:teleport_by_quest_id ( quest_id ,quest_type)
	print(" TaskModel:teleport_by_quest_id ( quest_id ,quest_type)",quest_id,quest_type)
	-- 先停止人物动作
    local player = EntityManager:get_player_avatar()
    
    --print("停止所有动作")
    local scene_id,scene_name,scene_x,scene_y = TaskModel:get_teleport_arg(quest_id,quest_type);
    -- print(" TaskModel:teleport_by_quest_id ( quest_id ,quest_type)2")
    if ( scene_id and scene_name and scene_x and scene_y ) then
        -- -- 筋斗云 18601
        local count = ItemModel:get_item_count_by_id( 18601 )
        local vip_info = VIPModel:get_vip_info();
      
        -- 如果vip等级大于3或者有筋斗云或者是VIP3体验状态
        if ( (vip_info and vip_info.level >=3 ) or count > 0  or VIPModel:get_expe_vip_time(  ) > 0) then
            player:stop_all_action()
            -- 如果有宠物的话也要停止宠物的动作
            local pet = EntityManager:get_player_pet();
            if ( pet ) then
            	pet:stop_all_action(  );
            end
            -- 设置传送后的AIManager动作 
            AIManager:set_after_pos_change_command( scene_id ,AIConfig.COMMAND_DO_QUEST,{quest_id ,quest_type});
            -- print("AIManager:get_state()",AIManager:get_state());
        else
            print("没有筋斗云或者vip不大于3")
        end
        MiscCC:req_teleport(scene_id,scene_name,scene_x,scene_y)
    end
end

-- 根据任务id取得传送的参数
function TaskModel:get_teleport_arg(quest_id,quest_type)
    local quest_info = TaskModel:get_info_by_task_id( quest_id );
    local scene_id,scene_name,scene_x,scene_y = nil,nil,nil,nil;
    local tab_target = quest_info.target;
    -- 如果target为空
    if ( quest_type== 2 or #tab_target == 0 ) then
        -- 斩妖除魔任务 特殊处理
        if ( quest_info.starid == 1 ) then
            return;
        end

        -- 要访问的npc
        local npc = nil;
        if ( quest_type == 1 ) then
            npc = quest_info.comp.npc;
            scene_name = quest_info.comp.scene;
            scene_id = SceneConfig:get_id_by_name( scene_name );
        else
            npc = quest_info.prom.npc;
            scene_name = quest_info.prom.scene;
            scene_id = SceneConfig:get_id_by_name( scene_name );
        end
        scene_x,scene_y = SceneConfig:get_npc_pos(scene_id,npc);
    else
        -- 取出目标table中的第一项
        local target_struct = tab_target[1];
    
        -- 判断任务是否完成
        -- 当前进度值
        local curr_process_value = TaskModel:get_process_value(quest_id );
        if ( curr_process_value == nil ) then
            curr_process_value = 0;
        end
      --  print("curr_process_value,target_struct.count",curr_process_value,target_struct.count);
        if ( curr_process_value >= target_struct.count ) then
        	if ( quest_info.starid == 1 ) then
				-- 打开斩妖除魔
				GlobalFunc:open_or_close_window( 16 ,0 ,nil );
				return;
			end
            -- 任务完成
            local npc_name = AIManager:get_commit_quest_npc(quest_info)
            scene_name = quest_info.comp.scene;
            scene_id  = SceneConfig:get_id_by_name( scene_name );
            scene_x,scene_y = SceneConfig:get_npc_pos(scene_id,npc_name);
            return scene_id,scene_name,scene_x,scene_y;
        end

        -- 任务没完成，执行任务
        -- tab_target.type 0 杀怪类、1 收集类、2 消耗类、3 对话类、4 送物类
        if ( target_struct.type == 0 )  then

            -- 如果有data 就解析data
            if ( target_struct.data ) then
                return self:parse_str( target_struct.data );
            end
    
            -- 判断是打怪还是采集
            local monster_info = MonsterConfig:get_monster_by_id( target_struct.id);
            if ( monster_info ) then
	            -- 采集
	            if ( monster_info.entityType == 12 ) then
	                local gatherTime = monster_info.gatherTime;
	                scene_id = target_struct.location.sceneid;
	                scene_name = SceneConfig:get_scene_name_by_id(scene_id);
	                scene_x,scene_y = SceneConfig:get_monster_pos( scene_id , target_struct.id );
	            -- 打怪
	            elseif ( monster_info.entityType == 1 ) then
	            	local loc_name = target_struct.location.entityName
	                if ( loc_name and loc_name ~= monster_info.name ) then
	                    scene_id = target_struct.location.sceneid;
	                    scene_name = SceneConfig:get_scene_name_by_id(scene_id);
	                    scene_x,scene_y = SceneConfig:get_npc_pos( scene_id,loc_name );
	                else
	                    scene_id = target_struct.location.sceneid
	                    scene_name = SceneConfig:get_scene_name_by_id(scene_id);
	                    scene_x,scene_y = SceneConfig:get_monster_pos( scene_id , target_struct.id );
	                end             
	            end
	        end
        -- 0 杀怪类、1 收集类、2 消耗类、3 对话类、4 送物类5角色的等级达标
        -- 6角色所在帮派等级 7身上其中一件装备强化等级8身上其中一件装备打孔等级
        --9身上其中一件装备镶嵌指定数量宝石10身上其中一件装备精锻等级
        --11角色杀戮值12角色战魂值13角色帮派贡献分14角色阵营贡献
        --40 打开界面或访问npc
        elseif ( target_struct.type == 1 ) then
        	return self:parse_str( target_struct.data );
        elseif ( target_struct.type == 5 ) then

        elseif ( target_struct.type == 7 ) then

        elseif ( target_struct.type == 40 ) then
            return self:parse_str( target_struct.data );
        elseif ( target_struct.type == 127 ) then
            return self:parse_str( target_struct.data );
        end
    end
   print("scene_id,scene_name,scene_x,scene_y",scene_id,scene_name,scene_x,scene_y)
    return scene_id,scene_name,scene_x,scene_y;
end


-- 根据字符串执行相应的操作 show_window(window_type):打开窗口 ask_npc(npc_name):访问npc
function TaskModel:parse_str( str )
    local str_table = Utils:Split( str, "/" ); 
    if ( str_table[2] ) then
    	-- print("str_table[2]",str_table[2])
	    str_table = Utils:Split( str_table[2], "," );  
	    if( str_table[1] == "@show_window" ) then
	        return nil;
	    elseif ( str_table[1] == "@ask_npc" ) then
	        local scene_name = str_table[2];
	        local sceneid = SceneConfig:get_id_by_name( scene_name );
	        local scene_x ,scene_y = SceneConfig:get_npc_pos( sceneid,str_table[3] );
	        return sceneid,scene_name,scene_x,scene_y;
	    end
	end
end

-- 清除仙宗任务
function TaskModel:clear_xz_quest(  )
	--print("开始清楚仙宗任务。。。。。。。。。。。。。。。。",#tab_yijie_tasks)
	for i=1,#tab_yijie_tasks do
		local quest_info = QuestConfig:get_quest_by_id( tab_yijie_tasks[i] );
	--	print("检查任务........",tab_yijie_tasks[i])
		if ( quest_info.starid == 3 ) then
	--		print("找到仙宗任务并删除。。。。。。。。。。。。。。。。",tab_yijie_tasks[i])
			TaskCC:req_give_up_task( tab_yijie_tasks[i] )
			table.remove(tab_yijie_tasks,i);
			local win = UIManager:find_visible_window("user_panel");
			win:update(1);
			return;
		end
	end

	
end
-- 取得父类任务完成后是否会弹下一个任务
function TaskModel:get_parent_quest_finish_next( quest_id )
	local parent_id = TaskModel:get_info_by_task_id( quest_id ).parentid;
	if ( parent_id and parent_id > 0) then
		local parent_quest_info = TaskModel:get_info_by_task_id( parent_id );
		print("parent_quest_info.finishNext,parent_id",parent_quest_info.finishNext,parent_id);
		return parent_quest_info.finishNext;
	end
	return false;
end

-- 取得已接或可接任务中的主线任务
function TaskModel:get_zhuxian_quest()
	for i,v in ipairs(tab_yijie_tasks) do
		if ( TaskModel:is_zhuxian_quest( v ) ) then
			return v,TYPE_YIJIE;
		end
	end

	for i,v in ipairs(tab_kejie_tasks) do
		if ( TaskModel:is_zhuxian_quest( v ) ) then
			return v,TYPE_KEJIE;
		end
	end

	return nil;
end

-- 判断某个任务已接
function TaskModel:if_task_accpet(taskid)
	for i,v in ipairs(tab_yijie_tasks) do
		if v==taskid then
			return true
		end
	end
	return false
end

function TaskModel:is_task_finished( task_id )

	local value = self:get_process_value(task_id );
	value = value or 0

	local quest_tab = QuestConfig:get_quest_by_id(task_id)

	-- 如果没有target，则是对话任务
	if ( #quest_tab.target == 0  ) then
		return true
	end

	if ( value and quest_tab.target ) then
		-- 提交任务的type如果是0则要返回npc处对话，如果不是0则会自动完成
		if quest_tab.target[1] then
			if value >= quest_tab.target[1].count then
				print('TaskModel:is_task_finished true',task_id)
				return true;
			end
		end
	end

	if ( quest_tab.comp.type == 0 ) then
		return true;
	end

	return false;
end
 
function TaskModel:is_task_complete( task_id )

	local value = self:get_process_value(task_id )

	value = value or 0

	print("value",value)

	local quest_tab = QuestConfig:get_quest_by_id(task_id)

	-- 如果没有target，则是对话任务
	if ( #quest_tab.target == 0  ) then
		return true
	end

	if ( value and quest_tab.target ) then
		-- 提交任务的type如果是0则要返回npc处对话，如果不是0则会自动完成
		if quest_tab.target[1] then
			if value >= quest_tab.target[1].count then
				print('TaskModel:is_task_finished true',task_id)
				return true;
			end
		end
	end

	return false
end

-- 取得已接或可接任务
function TaskModel:get_task_to_do()
	for i,v in ipairs(tab_yijie_tasks) do
		return v,TYPE_YIJIE;
	end

	for i,v in ipairs(tab_kejie_tasks) do
		return v,TYPE_KEJIE;
	end
	return nil;
end

-- 取得任务可接和已接的类型
function TaskModel:get_task_acceptType(qid)
	for i,v in ipairs(tab_yijie_tasks) do
		if v == qid then
			return TYPE_YIJIE;
		end
	end

	for i,v in ipairs(tab_kejie_tasks) do
		if v == qid then
			return TYPE_KEJIE;
		end
	end
	return nil;
end

--判断是否有接受某种日常任务
function TaskModel:has_star_task_accepted(starid)
	for i,task_id in ipairs(tab_yijie_tasks) do
		local quest_tab = QuestConfig:get_quest_by_id(task_id)
		if quest_tab.starid == starid then
			--print('>>>>>>>>>>>> TaskModel:has_star_task_accepted',starid)
			return true
		end
	end
	return false
end

--根据主线任务id获取章节信息
function TaskModel:get_chapter_info( task_id )
	print('task_id', task_id)
	require "../data/chapter_award"
	local player = EntityManager:get_player_avatar()
	for i, chapter in pairs(chapter_award) do
		local task_info = {}
		if #chapter.task == 3 then
			task_info = chapter.task[player.camp]
		else
			task_info = chapter.task[1]
		end

		for _, id in ipairs(task_info.subtask) do
			if task_id == id then
				return chapter, task_info.subtask
			end
		end
	end
end

--根据id,抽出有效的任务表
function TaskModel:get_exist_task( id )
	require "../data/chapter_award"
	local player = EntityManager:get_player_avatar()
	for i, chapter in pairs(chapter_award) do
		if chapter.cid == id then
			if #chapter.task == 3 then
				return chapter.task[player.camp].subtask
			else
				return chapter.task[1].subtask
			end
		end
	end
	return {}
end

--请求章节奖励
function TaskModel:req_chapter_award(cid)
	TaskCC:req_chapter_award(cid)
end

--设置全部章节奖励领取状态
function TaskModel:set_chapter_awards(states)
	chapter_award_states = states or {}
	local win = UIManager:find_visible_window("right_top_panel")
	if win then
		local cur_cid = 0
		local zx_task, task_type = self:get_zhuxian_quest()
		if not zx_task then zx_task = 99999 end
		local chapter, chapter_tasks = TaskModel:get_chapter_info( zx_task )
		if chapter then
			cur_cid = chapter.cid
		end

		if cur_cid == 0 then
			win:show_chapter_visible(false)
		else
			win:show_chapter_visible(true)
			win:change_chapter_icon(cur_cid)
		end
	end
end
--获取某个章节奖励领取状态
function TaskModel:get_state_by_id(id)
	return chapter_award_states[id] or 0
end
--获取是否有奖励可领
function TaskModel:get_award_exist()
	for i, v in ipairs(chapter_award_states) do
		if v == 2 then
			return true
		end
	end
	return false
end
