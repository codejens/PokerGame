-- TaskCC.lua
-- create by hcl on 2012-12-3
-- 任务系统

-- super_class.TaskCC()

TaskCC = {}

-- 1 请求任务列表
function TaskCC:req_task_list()
	-- print("TaskCC:req_task_list......................................................");
	local pack = NetManager:get_socket():alloc(6,1);
	NetManager:get_socket():SendToSrv(pack)
end

function TaskCC:req_task_list_from_dummy_server()
	local pack = NetManager:get_socket():alloc(6,1)
	NetManager.SendToDummyServer(pack)
end

-- 1 请求任务列表响应
function TaskCC:do_task_list(pack, is_newer_camp)
	print("run TaskCC:do_task_list pack,is_newer_camp",pack,is_newer_camp)
	local curSceneId = SceneManager:get_cur_scene()
	-- 检测玩家当前是否在新手副本中,如果在的话,则向客户端(模拟服务器)请求任务列表
	if curSceneId == 27 and not is_newer_camp then
		return
	end
	local result = pack:readByte();  -- 0表示返回客户端请求的结果，1表示玩家进入游戏第一次下发列表
	local task_num = pack:readWord(); -- 读取任务的数量
	-- print("TaskCC:do_task_list..........................task_num = "..task_num);
	local table1 = TaskModel:get_process_list();
	local table2 = {};
	for i=1,task_num do

		local process_struct = TaskProcessStruct(pack);
		local quest_id = process_struct.task_id;

		-- 首先判断是不是主线，如果是主线就插到前面
		if ( QuestConfig:get_quest_type( quest_id ) == 0 ) then
			table.insert(table1,1,process_struct);
			table.insert(table2,1,quest_id);
		else
			table.insert(table1,process_struct);
			table.insert(table2,quest_id);
		end 
		 -- print("----------------------当前已接任务task_id = ",quest_id);
		-- 判断任务是否完成
		-- 重新登录时检测新手指引进度
		-- if ( TaskModel:is_quest_finish( quest_id ,process_struct.tab_process[1] ) == false ) then
		-- 	XSZYManager:update_state( quest_id ,1);
		-- end
		
	end
	TaskModel:set_tasks_list(table2,2,task_num);
	local win = UIManager:find_window( "user_panel" ) 
	if ( win ) then
		win:update(1);
	end
end

-- 2 新增一个任务响应
function TaskCC:do_new_task(pack)
	print("TaskCC:do_new_task")
	local task_id 	= pack:readWord();  -- 任务id
	local result 	= pack:readChar();	-- 结果恒为0
	-- print("------接到一个新任务----task_id = ",task_id);
	-- 任务model增加一个已接任务，删除一个可接任务
	TaskModel:add_yijie_task( task_id );
	--print("************ EventSystem.postEvent('acceptQuest' ***************")
	
	local quest_info = QuestConfig:get_quest_by_id(task_id)
	-- 接完任务后,是否需要弹出极品装备窗口
	if quest_info.BestequipWin then
		-- 是否购买中级强化石,是否能够领取极品装备
		local can_get, had_get = MallModel:get_taozhuang_info()
		-- 玩家还没有购买中级强化石(使用非绑定元宝)
		if not can_get then
			-- 泉亲要求不主动弹出，显得我们不坑钱（次奥，射雕又要求要主动弹出了！！）
			UIManager:show_window("jptz_dialog")
		end
	end

	EventSystem.postEvent('acceptQuest', task_id )
end


local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

-- 3 完成任务
function TaskCC:do_finish_task(pack)
	local task_id 	= pack:readWord();  -- 任务id
	local result 	= pack:readChar();	-- 结果恒为0
	
	-- print("------完成一个任务----task_id = ",task_id);

	-- 播放完成任务的特效
	LuaEffectManager:play_scene_effect( 8,_refWidth(0.5), _refHeight(0.8), 1000 )

	-- 删除掉已完成的任务
	TaskModel:remove_yijie_task( task_id )

	local win = UIManager:find_window( "user_panel" ) 
	if ( win ) then
		win:update(1);
	end
	-- 播放任务完成的音效
	SoundManager:playUISound('finish_task',false)
	-- 通知AIManager任务完成了
	AIManager:on_quest_finish();

	-- 完成任务后询问XSZYManager
	-- XSZYManager:update_state(task_id ,2)

	EventSystem.postEvent('finishQuest', task_id )

	-- added by aXing on 2014-5-29
	-- 添加新手引导逻辑	
	-- local instruction_id = Instruction:check_quest(task_id, 2)	-- 1=接任务后, 2=完成任务后
	-- if instruction_id ~= nil then
	-- 	Instruction:start(instruction_id)
	-- end

	local quest_info = QuestConfig:get_quest_by_id(task_id)
	if quest_info.flowers then
		FlowerEffect:play(12)
	end

	-- 是否要显示VIP体验卡窗口
	if quest_info.show_vip_exp then
		UIManager:show_window("vip_card_win")
	end

	-- 是否开启变身倒计时
	if quest_info.super_count then
		TransformCC:request_over_transform_experience()
		TransformCC:request_begin_count_down( 1 )
	end
 end

--4 请求放弃任务
function TaskCC:req_give_up_task(task_id)

	-- 潜规则 跑环任务不能放弃
	local quest_info = QuestConfig:get_quest_by_id( task_id );
	if ( quest_info.loopid ) then
		GlobalFunc:create_screen_notic( LangGameString[455] ) -- [455]="跑环任务不能放弃"
		return;
	end
	local pack = NetManager:get_socket():alloc(6,4); 
	pack:writeWord(task_id);
	NetManager:get_socket():SendToSrv(pack);
end

--4 请求放弃任务响应
function TaskCC:do_give_up_task(pack)
	local task_id = pack:readWord();
	local result = pack:readByte();
	-- print("TaskCC:do_give_up_task:task_id = ".. task_id,"result = ",result);
	if(result == 0)then 
		-- 删除对应的已接任务
		TaskModel:remove_yijie_task( task_id );
		-- -- 增加对应的可接任务
		-- TaskModel:add_kejie_task( task_id )
		-- 主界面更新,任务面板更新
		local win = UIManager:find_visible_window("user_panel")
		if ( win ) then
			win:update(1);
		end
		win = UIManager:find_visible_window("task_win");
		if ( win ) then
			win:update(1,{1});
		end
	end
end
-- 5 下发可接任务列表
function TaskCC:do_get_task_list(pack)
	print("TaskCC:do_get_task_list(pack)..................................................1")
	print("TaskCC:do_get_task_list(pack)..................................................2")
	local task_num = pack:readWord(); -- 任务数量
	-- array 任务id列表 
	local table1 ={};
	for i=1,task_num do
		local task_id = pack:readWord();
		if task_id ~= 8176 and task_id ~= 8563 and task_id ~= 8479 then 
			print("-----------------------下发可接任务列表 task_id = ",task_id);
			-- 去掉跑环任务
			local quest_info = QuestConfig:get_quest_by_id(task_id)
			if quest_info then
				if ( quest_info.loopid == nil ) then
					-- 重新登录时检测新手指引进度
					--XSZYManager:update_state( task_id ,2);
					-- 首先判断是不是主线，如果是主线就插到前面
					if ( QuestConfig:get_quest_type( task_id ) == 0 ) then
						table.insert(table1,1,task_id);
					else
						table.insert(table1,task_id);
					end 
				end
			else
				print('TaskCC:do_get_task_list : 无法找到可接任务信息', task_id)
			end
		end
	end
	TaskModel:set_tasks_list(table1,1,#table1);

end

-- 7 超时任务
function TaskCC:do_task_time_out(pack)
	local task_num = pack:readByte(); -- 任务数量
	-- print("TaskCC:do_task_time_out(pack):任务超时 task_num = ",task_num);
	-- array 任务id列表 
	for i=1,task_num do
		local quest_id = pack:readWord();
		print(quest_id,"任务失败");
		TaskModel:remove_yijie_task( quest_id );
	end
	local win = UIManager:find_window( "user_panel" ) 
	if ( win ) then
		win:update(1);
	end
end

-- 8 设置任务进度值
function TaskCC:do_set_task_percent(pack)
	local task_id = pack:readWord();
	local task_index = pack:readByte();
	local task_percent = pack:readInt();
	-- ZXLog("==========TaskCC:do_set_task_percent(pack),task_id,task_index,task_percent",task_id,task_index,task_percent);

	-- 更新已接任务的进度值
	TaskModel:set_process_value(task_id,task_index + 1,task_percent);

	-- 更新主界面的任务进度
	local win = UIManager:find_window("user_panel")
	if ( win ) then
		print("更新进度值");
		win:update(4,{task_id,task_index,task_percent});
	end

	-- 判断任务是否完成，完成的话就继续下一个任务
	-- TODO 任务target可能有多项
	if ( TaskModel:is_quest_finish( task_id ,task_percent ) ) then
		if ( EntityManager:get_player_avatar(  ) ) then
			--print("TaskCC:任务完成");
			-- 任务完成
		--	print("do_set_task_percent(pack)......................")
			-- 如果不在副本中才继续任务了
			if ( SceneManager:get_cur_fuben() == 0  ) then 
				AIManager:set_AIManager_idle(  )
				AIManager:do_quest( task_id , 1 );
			end
		end
		-- 如果是 魔劫爆发任务，任务完成后关闭斩妖除魔界面
		if ( task_id == 332 ) then
			local win = UIManager:find_visible_window("zycm_win");
			if ( win ) then
				UIManager:hide_window("zycm_win");
			end
		end
	else
		-- 如果斩妖除魔任务界面打开了，并且当前更新任务是斩妖除魔任务
		local win = UIManager:find_visible_window("zycm_win");
		if ( win ) then
			local quest_info = TaskModel:get_info_by_task_id( task_id );
			if ( quest_info.starid == 1 ) then
				win:update_quest_process();
			end 
		end
		-- 如果跑环任务打开了
		local win = UIManager:find_visible_window("pao_huan_win");
		if ( win ) then
			local quest_info = TaskModel:get_info_by_task_id( task_id );
			if ( quest_info.loopid ) then
				win:update_quest();
			end
		end
	end
end

-- 9 新增可接任务
function TaskCC:do_add_kejie_task(pack)
	local task_num = pack:readWord();
	print("run TaskCC:do_add_kejie_task task_num",task_num)
	for i=1,task_num do
		local task_id = pack:readWord();
		-- print("------------------------新增可接任务---------task_id = ",task_id); 
		-- 去掉跑环任务
		local quest_info = QuestConfig:get_quest_by_id(task_id)
		local is_zhuxian = TaskModel:is_zhuxian_quest( task_id ) ;
		-- print("quest_info.loopid,is_zhuxian,TaskModel:get_parent_quest_finish_next( task_id )",
		-- 	quest_info.loopid,is_zhuxian,TaskModel:get_parent_quest_finish_next( task_id ))
		if ( quest_info.loopid == nil ) or ( is_zhuxian and TaskModel:get_parent_quest_finish_next( task_id ) ) then
			print("run 292")
			--不是跑环任务的话加到可接列表
			TaskModel:add_kejie_task( task_id, is_zhuxian );
		end

		if ( is_zhuxian ) then
			local win = UIManager:find_window( "user_panel" ) 
			if ( win ) then
				win:update( 1 );
			end
		end

		-- -- 新增可接任务时，更新新手指引的状态,如果XSZYManager:update_state返回true则不继续任务
		-- if ( XSZYManager:update_state( task_id ,2) ) then
		-- 	return;
		-- end

		-- if XSZYManager:get_state() ~= XSZYConfig.NONE then
		-- 	return;
		-- end

		-- 如果可接任务是主线 
		if ( is_zhuxian and TaskModel:get_parent_quest_finish_next( task_id ) ) then
			-- 自动与npc对话
			AIManager:do_quest( task_id , 2 );
		else
			-- 先要查询父任务完成后是否服务器会自动弹下一个任务
			--print("不是主线或者父类任务完成后会自动下发下一个任务.....................")
		end
	end

end

-- 10 请求快速完成任务
function TaskCC:req_rapid_finish_task(task_id, money_type)
	local pack = NetManager:get_socket():alloc(6,10); 
	pack:writeWord(task_id);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 10请求快速完成任务响应
function TaskCC:do_rapid_finish_task(pack)
	local task_id = pack:readWord();
	--print("task_id = ".. task_id);
	local result = pack:readByte();
	if(result == 0)then 
		-- 播放完成任务的特效
		-- local player = EntityManager:get_player_avatar();
		-- player.model:playEffect( 10003,8,15,nil,0 ,0,500);
		-- 删除掉已完成的任务
		TaskModel:remove_yijie_task( task_id )
		local player = EntityManager:get_player_avatar();
--通知服务器我完成任务了
		player:stop_all_action(true);

		local win = UIManager:find_window( "user_panel" ) 
		if ( win ) then
			win:update(1);
		end
	end
end

-- 11 删除一个可接任务
function TaskCC:do_delete_task( pack )

	local task_id = pack:readWord();
	-- print("服务器通知删除一个可接任务:TaskCC:do_delete_task",task_id)
	TaskModel:remove_kejie_task( task_id );
-- 	-- 更新界面
-- 	local win = UIManager:find_window( "user_panel" ) 
-- 	if ( win ) then
-- --		print("更新主界面")
-- 		win:update(1);
-- 	end
end
-- 6,13 领取章节奖励
function TaskCC:req_chapter_award(cid)
	local pack = NetManager:get_socket():alloc(6,13);
	pack:writeInt(cid)
	NetManager:get_socket():SendToSrv(pack)
end

-- 14 章节奖励信息
function TaskCC:do_get_chapters( pack )
	--目前有8个章节
	local chapter_awards = {}
	local show_effect = false
	for i = 1, 8 do
		local state = pack:readInt()
		if state == 2 then
			show_effect = true
		end
		chapter_awards[i] = state
	end
	TaskModel:set_chapter_awards(chapter_awards)
	--更新界面领取状态
	local win = UIManager:find_visible_window("task_win");
	if ( win ) then
		win:update(3);
	end
	local rt_win = UIManager:find_visible_window("right_top_panel")
	if rt_win then
		rt_win:show_chapter_effect(show_effect)
	end
end