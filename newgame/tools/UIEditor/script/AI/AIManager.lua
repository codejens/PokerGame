-- AIManager.lua
-- created by hcl on 2013-1-24
-- 主角AI管理器

-- super_class.AIManager()
-- require "config/AIConfig"
AIManager = {}

local _current_command_state = AIConfig.COMMAND_IDLE;
local _current_target_scene = -1;
local _after_reach_target_scene_command = nil;
local _after_reach_target_scene_param = nil;
-- AIManager需要用到的数据 例如跟随状态 ai_data就是跟随entity的handle
local ai_data = nil;
local old_selected_entity = nil;
local doing_quest = nil;
local doing_quest_type = nil;
-- 刚进入一个新场景
local is_enter_new_scene = false;
local enter_new_scene_wait_time = 0.2;

-- 副本挂机的挂机路径
local tab_fuben_path = {};
-- 寻路点
local path_index = 0

local _cur_scene_teleport_list = {}
local _cur_scene_teleport_action = nil

---------------------------------------------
local _paused_args = nil
local _paused = false
function AIManager:init()
	-- local function tick( dt )
	-- 	--print('AIManager:_think Begin : ', _current_command_state)
	-- 	--self:think(dt)
	-- 	--print('AIManager:_think End : ', _current_command_state)
	-- end
	
	-- self.think_timer = timer()
	-- self.think_timer:start(t_aimgr_,tick)
end

-- added by aXing on 2013-5-27
function AIManager:fini( ... )

	if self.think_timer then
		self.think_timer:stop()
	end

	--AIManager:set_state(  AIConfig.COMMAND_IDLE,nil)
	_current_command_state = AIConfig.COMMAND_IDLE;
	_current_target_scene = -1;
	_after_reach_target_scene_command = nil;
	_after_reach_target_scene_param = nil;
    -- AIManager需要用到的数据 例如跟随状态 ai_data就是跟随entity的handle
	ai_data = nil;
	old_selected_entity = nil;
	doing_quest = nil;
	doing_quest_type = nil
	is_enter_new_scene = false;
	tab_fuben_path = {};
	path_index = 0
	-- 删除主角和主角宠物前先停止他们的动作
	EntityManager:get_player_avatar():stop_all_action();
	local player_pet = EntityManager:get_player_pet();
	if ( player_pet ) then
		player_pet:stop_all_action();
	end
end

function AIManager:set_state( state , data )
	--print("_current_command_state,state",_current_command_state,state)
	if ( _current_command_state == state ) then
		-- 如果设置同样的状态就直接返回
		return;
	end

	AIManager:clearSameSceneTeleportArgs()

	_current_command_state = state;

	if ( data ) then
		ai_data = data;
	end

	if _current_command_state ~= AIConfig.COMMAND_FUBEN_GUAJI then
		path_index = 0
	end

	if ( _current_command_state == AIConfig.COMMAND_GUAJI or _current_command_state == AIConfig.COMMAND_FUBEN_GUAJI ) then
		-- 显示自动打怪中
		UserPanel:set_title_visible( true,1 );
		MenusPanel:do_toggle_guaji( true )
		if PowerCenter then
			PowerCenter:OnAIFight()
		end
	elseif ( _current_command_state == AIConfig.COMMAND_FOLLOW ) then
		-- 显示自动跟随中
		UserPanel:set_title_visible( true,3 );
		MenusPanel:do_toggle_guaji( false )
		if PowerCenter then
			PowerCenter:OnAIFollow()
		end
		doing_quest = nil
		doing_quest_type = nil
	elseif (  _current_command_state == AIConfig.COMMAND_DO_QUEST or 
			  _current_command_state == AIConfig.COMMAND_ASK_NPC or 
			  _current_command_state == AIConfig.COMMAND_ENTER_SCENE or 
			  _current_command_state == AIConfig.COMMAND_ENTER_FUBEN) or
			  _current_command_state == AIConfig.COMMAND_SCENE_TELEPORT or
			  _current_command_state == AIConfig.COMMAND_AUTO_GATHER or
			  _current_command_state == AIConfig.COMMAND_ACTION_MOVE or
			  _current_command_state == AIConfig.COMMAND_MOVE_TO_MONSTER then

		-- 显示自动寻路中
		UserPanel:set_title_visible( true,2 );
		MenusPanel:do_toggle_guaji( false )
		if PowerCenter then
			PowerCenter:OnAIMove()
		end
		local win = UIManager:find_visible_window("menus_panel")
		if win then 
			-- 取消隐藏 by hwl
			-- win:show_or_hide_panel(false)
		end
	else
		if ( _current_command_state == AIConfig.COMMAND_IDLE ) then
			doing_quest = nil
			doing_quest_type = nil
			_paused_args = nil
		end
		-- 取消所有标题
		UserPanel:set_title_visible( true,4 );
		MenusPanel:do_toggle_guaji( false )
		
	end

end

function AIManager:get_state()
	return _current_command_state;
end

-- 当主角没有动作的时候通知AIManager
function AIManager:on_player_curr_action_nil()
	--print("AIManager:on_player_curr_action_nil()")

	-- 如果刚进入一个新场景，那么需要停止动作一定时间来等待场景加载
	if ( is_enter_new_scene ) then
		return;
	end
	-- 如果当前AIManager的状态时空闲，直接返回
	if ( _current_command_state == AIConfig.COMMAND_IDLE or _current_command_state == AIConfig.COMMAND_ENTER_SCENE) then
		return;
	-- 如果是杀怪状态，会自动释放技能直到打死这只怪
	elseif ( _current_command_state == AIConfig.COMMAND_KILL_MONSTER ) then
		-- AIManger管理玩家的行为
		local player = EntityManager:get_player_avatar();
		-- 如果玩家当前没有动作
		if ( player:get_curaction() == nil ) then
			-- 如果玩家当前的目标已经死亡，则停止动作
			if ( player.target_id == nil ) then
				AIManager:set_state( AIConfig.COMMAND_IDLE );
			-- 没死就接着放技能
			else
				-- 施放技能
				local skill = self:get_can_use_skill();
				if ( skill ) then
					CommandManager:combat_skill( skill ,player);
				end
			end
		end
	-- 如果是挂机状态
	elseif ( _current_command_state == AIConfig.COMMAND_GUAJI ) then
		-- 先从设置里面取得是否自动捡道具
		if ( SetSystemModel:get_date_value_by_key( SetSystemModel.AUTO_PICK ) ) then
			-- 先判断背包是否已满
			if ( ItemModel:check_bag_if_full() == false ) then 
				-- 自动捡道具
				local drop_item_table = EntityManager:find_all_drop_item( );
				if ( #drop_item_table > 0 )	then
					--print("捡道具")
					for i=1,#drop_item_table do
						DropItemCC:req_pick_up_drop_item( drop_item_table[i] );
					end
				end
			end
		end
		--print("如果是挂机状态")
		-- AIManger管理玩家的行为
		local player = EntityManager:get_player_avatar();
		-- 如果玩家当前没有动作
		if ( player:get_curaction() == nil ) then

			if ( player.target_id ~= nil ) then

			else
				--找到一个能够攻击的目标
				local target_id = EntityManager:get_can_attack_entity(player);
				if target_id == nil then
					-- 找不到目标
					-- print("AIManager:guaji:找不到目标")
					--GlobalFunc:create_screen_notic( "请选择目标" );
					return ;	
				end
				local target_entity = EntityManager:get_entity( target_id );
				player:set_target(target_entity)
			end

			-- 施放技能
			local skill = self:get_can_use_skill();
			--print("释放技能。。。。。skill",skill)
			if ( skill ) then
				CommandManager:combat_skill( skill ,player );
			end
		else
			-- print("当前已有动作..........");
		end
	elseif ( _current_command_state == AIConfig.COMMAND_FUBEN_GUAJI ) then
		-- 先从设置里面取得是否自动捡道具
		if ( SetSystemModel:get_date_value_by_key( SetSystemModel.AUTO_PICK ) ) then
			-- 先判断背包是否已满
			if ( ItemModel:check_bag_if_full() == false ) then 
				-- 自动捡道具
				local drop_item_table = EntityManager:find_all_drop_item( );
				if ( #drop_item_table > 0 )	then
					--print("捡道具")
					for i=1,#drop_item_table do
						DropItemCC:req_pick_up_drop_item( drop_item_table[i] );
					end
				end
			end
		end

		local player = EntityManager:get_player_avatar();
		if ( player:get_curaction() == nil ) then

			if ( player.target_id ~= nil ) then
				local skill = self:get_can_use_skill();
				if ( skill ) then
					print("玩家当前有攻击目标，继续攻击....")
					CommandManager:combat_skill( skill ,player);
				end
			else
				print("玩家当前没有攻击目标，重新查找新目标。。。。。。")
				--找到一个能够攻击的目标
				local entity_handle = EntityManager:get_can_attack_entity(player);
				if ( entity_handle ) then
					print("找到能够攻击的目标")
					-- 找到怪物后重置寻路点,而不是接着走
					path_index = 0
					local target_entity = EntityManager:get_entity( entity_handle );
					player:set_target(target_entity)
					--player.target_id = entity_handle;
					-- 施放技能
					local skill = self:get_can_use_skill();
					if ( skill ) then
						CommandManager:combat_skill( skill ,player);
					end
				else
					local fb_id = SceneManager:get_cur_fuben();
		--			print("fb_id = ",fb_id);
					-- 诛仙剑阵11,阵营战59,封神台62,塔防60,仙盟领地7,71自由赛,不做任何操作
					if ( fb_id ~= 11 and fb_id ~= 59 and fb_id ~= 62 and fb_id ~= 7 and fb_id ~= 71 ) then
						-- 没有怪就查找传送石
						-- print("查找传送石")
						entity_handle = EntityManager:find_nearest_target( 9 );
						if not entity_handle and ( tab_fuben_path and #tab_fuben_path > 0 and path_index < #tab_fuben_path) then
				--			print(" 移动到指定目标 。。。。。。。。。。。 ")
							local pos_tab = {}
							if path_index == 0 then
								-- local x, y = SceneManager:view_pos_to_map_pos(player.x, player.y)
								local px, py = SceneManager:pixels_to_tile(player.x, player.y)
								pos_tab = tab_fuben_path[1]
								path_index = 1
								for i = 2, #tab_fuben_path do
									val = tab_fuben_path[i]
									local dx1, dy1 = math.abs((pos_tab[1] - px)), math.abs((pos_tab[2] - py))
									local dx2, dy2 = math.abs((val[1] - px)), math.abs((val[2] - py))
									if dx1*dx1+dy1*dy1 >= dx2*dx2+dy2*dy2 then
										pos_tab = val
										path_index = i
									end
								end
							else
								path_index = path_index + 1
								pos_tab = tab_fuben_path[path_index]
							end
							CommandManager:move( pos_tab[1] * SceneConfig.LOGIC_TILE_WIDTH, pos_tab[2]* SceneConfig.LOGIC_TILE_HEIGHT, true ,nil,player);
						else
							-- 赏金副本没有传送石
							if ( fb_id == 8888888 ) then
								is_enter_new_scene = true;
							else
								if ( entity_handle ) then
									local function cb()
										local curr_fuben_id = SceneManager:get_cur_fuben();
										AIManager:set_after_pos_change_command(curr_fuben_id,AIConfig.COMMAND_FUBEN_GUAJI,nil,AIConfig.COMMAND_ENTER_FUBEN);
									end
						--			print("前往传送石")
									local entity = EntityManager:get_entity( entity_handle );
									CommandManager:move( entity.model.m_x, entity.model.m_y, true ,cb,player);
								--在有寻路点的情况下不向右行走	by hwl 2015/1/27
								elseif not tab_fuben_path or #tab_fuben_path == 0 then
									local width = SceneConfig:get_scene_width( fb_id )
									if ( player.x + 96 < ( width - 4 ) * SceneConfig.LOGIC_TILE_WIDTH  ) then
					--					print("向右走 。。。。。。。")		
										CommandManager:move( player.x + 96, player.y, true ,nil,player);
									end
								end
							end

						end
					end
				end
			end
	
		else
			print("副本挂机...当前已有动作.....")
		end
	-- 跟随状态自动跟随目标玩家	
	elseif ( _current_command_state == AIConfig.COMMAND_FOLLOW ) then
		AIManager:is_player_near_target(  );
	elseif ( _current_command_state == AIConfig.COMMAND_AUTO_GATHER ) then
		local player = EntityManager:get_player_avatar();
		-- 如果当前没有动作
		if ( player:get_curaction() == nil ) then
			local entity_handle = EntityManager:find_nearest_target( 12 ,false )
			local entity = EntityManager:get_entity(entity_handle);
			if ( entity ) then
				local monster_info = MonsterConfig:get_monster_by_id( entity.id );
				CommandManager:gather(  entity.name , math.floor(entity.model.m_x/SceneConfig.LOGIC_TILE_WIDTH)
							,math.floor(entity.model.m_y/SceneConfig.LOGIC_TILE_WIDTH),monster_info.gatherTime,1);
			end
		end
	end
end

-- enter_type : 1 = 场景,2 = 副本
function AIManager:set_after_pos_change_command( target_scene_id ,after_reach_scene_command, param , enter_type )
	print("----------target_scene_id", target_scene_id)
	print("----------target_scene_id", target_scene_id)
	print("----------target_scene_id", target_scene_id)
	if ( enter_type ) then
		AIManager:set_state( enter_type );
		--print("_current_command_state = enter_type")
	else
		AIManager:set_state( AIConfig.COMMAND_ENTER_SCENE );
	end
	_after_reach_target_scene_command = after_reach_scene_command;
	-- 记录当前要访问的目标场景和当前在执行的任务id
	_current_target_scene = target_scene_id;
	-- 记录参数
	_after_reach_target_scene_param = param;
end

-- 进入场景或副本时的cb
function AIManager:CB_enter_scene( is_teleport )
	-- print("CB_enter_scene===============================================_current_command_state = ",_current_command_state);
	
	local cb = callback:new();
	local function _fun()
		-- 
		if ( _current_command_state == AIConfig.COMMAND_ENTER_SCENE ) then
			local curr_scene_id = SceneManager:get_cur_scene();
			--print("========================CB_enter_scene",curr_scene_id,_current_target_scene);
			--print("curr_scene_id,_current_target_scene_id = ",curr_scene_id,_current_target_scene )
			--首先判断是否到达目标场景，如果没有则计算出到达目标场景的最短路径，然后移动
			if ( curr_scene_id ==  _current_target_scene ) then
				self:do_reach_target_scene_command( _current_target_scene ,_after_reach_target_scene_command,_after_reach_target_scene_param )
			else

				local tx,ty = AIManager:get_nearest_position( curr_scene_id , _current_target_scene ) 
				--print(" tx,ty = ",tx,ty);
				local pos_x,pos_y = SceneConfig:grid2pos(tx,ty);
				-- 移动
				CommandManager:move( pos_x, pos_y, true ,nil,EntityManager:get_player_avatar());
		
			end

			--清空传送点列表
			_cur_scene_teleport_list = {}

		elseif ( _current_command_state == AIConfig.COMMAND_ENTER_FUBEN ) then
			local fuben_id = SceneManager:get_cur_fuben();
			-- 在 心魔幻境第七层要停止 58,1064
			-- print("+____========",SceneManager:get_cur_scene())
			if ( fuben_id == 98 and SceneManager:get_cur_scene() == 1081 ) then
				return;
			end
			-- print("========================CB_enter_scene",fuben_id,_current_target_scene);
			if ( _current_target_scene == fuben_id ) then
				self:do_reach_target_scene_command( _current_target_scene ,_after_reach_target_scene_command,_after_reach_target_scene_param )
			end
			--清空传送点列表
			_cur_scene_teleport_list = {}

		elseif ( _current_command_state == AIConfig.COMMAND_SCENE_TELEPORT ) then
			print('同一场景teleport')
			AIManager:gotoNextSameSceneTeleport()
		end

		is_enter_new_scene = false;
	end
	cb:start(enter_new_scene_wait_time,_fun);

	if ( is_teleport == false ) then
		-- 保存
		local fb_id = SceneManager:get_cur_fuben();
		-- print("fb_id = ",fb_id,"SceneManager:get_cur_scene() = ",SceneManager:get_cur_scene())
		if ( fb_id > 0  ) then
			require "../data/fbxl_config"
			tab_fuben_path = {};
			print('-0----------------', SceneManager:get_cur_scene())
			local temp_table = fbxl_config[SceneManager:get_cur_scene()];
			if ( temp_table ) then
				-- 复制本地数据
				for i=1,#temp_table do
					table.insert(tab_fuben_path,temp_table[i])
					--tab_fuben_path[i] = temp_table[i];
					print(temp_table[i][1],temp_table[i][2]);
				end
			end
		end
	end
end

-- 取得当前没有cd的技能，从左到右
function AIManager:get_can_use_skill()
	local skill_tab = UserSkillModel:get_can_use_skill_list();
	local player = EntityManager:get_player_avatar();
	--print("#skill_tab = ",#skill_tab);
	--HYTODO 屏蔽技能测试用

	for i=1,4 do
		if ( skill_tab[i] and skill_tab[i].cd == 0 and player:check_is_enough_magic_use_skill( skill_tab[i] ) ) then
			return skill_tab[i];
		end
	end


	-- for i=0,3 do
	-- 	-- 先取得技能是否使用
	-- 	local is_use_skill = SetSystemModel:get_date_value_by_key( SetSystemModel.HOOK_SKILL_PANEL_1 + i);
	-- 	if ( is_use_skill ) then
	-- 		local skill_id = SetSystemModel:get_date_value_by_key( SetSystemModel.HOOK_CYCLE_SKILL1 + i)
	-- 		local user_skill = UserSkillModel:get_a_skill_by_id( skill_id );
	-- 		if ( user_skill and user_skill.cd == 0 and player:check_is_enough_magic_use_skill( user_skill ) ) then
	-- 			return user_skill;
	-- 		end
	-- 	end
	-- end

	-- 如果技能都没有cd就使用普通攻击

	if ( skill_tab[0].cd == 0 ) then 
		--print("使用普通攻击。。。。。。。。。。。。。。。。。。。。。。。。。。。",skill_tab[0].id);
		return skill_tab[0];
	end
	
	return nil;
end

function AIManager:set_AIManager_idle(  )
	--print("AIManager:set_AIManager_idle(  ).....................")
	AIManager:set_state( AIConfig.COMMAND_IDLE )
	local player = EntityManager:get_player_avatar();

	-- 取消打坐
	if player and player.state then
		if ( ZXLuaUtils:band(player.state , EntityConfig.ACTOR_STATE_ZANZEN) > 0  or  
			 ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0 ) then
			-- 停止打坐
			-- print("停止打坐")
			player:stop_dazuo()	
		end
	end
end

---------------------------------------------任务AI----------------------------------------------
local function _AIManager_do_quest( params )
	AIManager:do_quest(params[1],params[2])
end

-- 执行任务 quest_type 1 = 已接任务，quest_type 2= 可接任务
function AIManager:do_quest( quest_id , quest_type ,mini_task_panel_click )
	--create by jiangjinhong  判定是否有小型学习技能，有的话 暂停自动任务
	local win = UIManager:find_window("small_jineng_win")
	print("--------------------------win:",win)
	if win ~= nil  then
		return;
	end 
	--xprint('!!!!!!!!!!!!!')
	print('@@ AIManager:do_quest')
	-- 判断是否在副本中，如果在副本中则不能自动寻路   副本和天元之战中不能自动寻路
	if ( SceneManager:get_cur_fuben() ~=0 ) then
		local is_fuben_display_quest = false;
		-- 还需要排除一种情况是中级强化石任务，这个任务是弹出面板的，测试想在副本内也可以弹出。所以这里处理一下 add by gzn 2015/3/4
		local quest_info = TaskModel:get_info_by_task_id( quest_id );
		if quest_info ~= nil and quest_info.starid == 5 then
			is_fuben_display_quest = true
		end
		if is_fuben_display_quest == false then
			print("副本中不能自动寻路");
			ScreenNoticWin:create_notic(LangGameString[2]) -- [2]="副本中不能自动寻路"
			return;
		end
	end

	-------------------------
	_paused_args = 
	{
		_AIManager_do_quest,
		{ quest_id, quest_type }
	}
	-------------------------

	local result = true
	-- 停止其他状态
	AIManager:set_state( AIConfig.COMMAND_DO_QUEST );
	-- 去掉当前选中的目标
	local player = EntityManager:get_player_avatar();
	player:set_target(nil);
	player:stop_dazuo();

	doing_quest = quest_id;
	doing_quest_type = quest_type;

	print("[AIManager]当前正在执行的任务id = ",quest_id,quest_type)
	-- 根据任务id取得对应的任务的静态配置信息
	local quest_info = TaskModel:get_info_by_task_id( quest_id );

	-- 如果自动寻路 = true
	-- if ( quest_info.autoRun ) then
	-- 任务目标
	local tab_target = quest_info.target;
	-- 如果target为空

	if ( quest_type== 2 or #tab_target == 0 ) then
		-- 斩妖除魔任务 特殊处理
		if ( quest_info.starid == 1 ) then
			-- 打开斩妖除魔
			GlobalFunc:open_or_close_window( 16 ,0 ,nil);
			return;
		end

		-- 当前场景id 和目标场景id 
		
		local target_scene_id = nil;
		-- 要访问的npc
		local npc = nil;
		if ( quest_type == 1 ) then
			npc = quest_info.comp.npc;
			target_scene_id = SceneConfig:get_id_by_name( quest_info.comp.scene );
		else
			npc = quest_info.prom.npc;
			target_scene_id = SceneConfig:get_id_by_name( quest_info.prom.scene );
		end
		-- if ( npc == NPCDialog:get_current_talking_npc_name() ) then
		-- 	print("当前正在与这个npc对话")
		-- 	return;
		-- end
		-- 首先先判断当前场景是否目标场景 然后执行command
		AIManager:is_reach_target_scene_and_do_command( target_scene_id ,AIConfig.COMMAND_ASK_NPC,npc)

	else
		-- 取出目标table中的第一项
		local target_struct = tab_target[1];
	
		-- 判断任务是否完成
		-- 当前进度值
		local curr_process_value = TaskModel:get_process_value(quest_id );
		if ( curr_process_value == nil ) then
			curr_process_value = 0;
		end
		--print("curr_process_value,target_struct.count",curr_process_value,target_struct.count);
		if ( curr_process_value >= target_struct.count ) then
			-- 如果是斩妖除魔任务
			-- 斩妖除魔任务 特殊处理
			if ( quest_info.starid == 1 ) then
				-- 打开斩妖除魔
				GlobalFunc:open_or_close_window( 16 ,0 ,nil );
				return;
			end

			-- 任务完成
			local npc_name = AIManager:get_commit_quest_npc(quest_info)
			local sceneid  = SceneConfig:get_id_by_name( quest_info.comp.scene );
			AIManager:is_reach_target_scene_and_do_command(  sceneid ,AIConfig.COMMAND_ASK_NPC,npc_name)
			return;
		end

		-- 任务没完成，执行任务
		-- tab_target.type 0 杀怪类、1 收集类、2 消耗类、3 对话类、4 送物类
		if ( target_struct.type == 0 )	then

			-- 如果有data 就解析data
			if ( target_struct.data ) then
				require "GlobalFunc"
				GlobalFunc:parse_str( target_struct.data );
				return;
			end

			if target_struct.location.hideFastTransfer then
				return;
			end
	
			-- 判断是打怪还是采集
			local monster_info = MonsterConfig:get_monster_by_id( target_struct.id);
			-- 采集
			if ( monster_info.entityType == 12 ) then
				local gatherTime = monster_info.gatherTime;
				local gatherCount = target_struct.count;
				--CommandManager:gather( target_struct.location.sceneid  ,target_struct.location.entityName, target_struct.id ,gatherTime);
				AIManager:is_reach_target_scene_and_do_command(  target_struct.location.sceneid ,AIConfig.COMMAND_GATHER,{target_struct.location.entityName,target_struct.id,gatherTime,gatherCount})
			-- 打怪
			elseif ( monster_info.entityType == 1 ) then
				-- 如果目标的data不为空，说明进入的是副本
				if ( target_struct.data ~= nil ) then
					AIManager:is_reach_target_scene_and_do_command(  target_struct.location.sceneid ,AIConfig.COMMAND_ASK_NPC,target_struct.location.entityName);
					--CommandManager:ask_npc( target_struct.location.sceneid,quest_info.prom.npc,"");
				else
					AIManager:is_reach_target_scene_and_do_command(  target_struct.location.sceneid ,AIConfig.COMMAND_KILL_MONSTER,{target_struct.location.entityName, target_struct.id})
					--CommandManager:quest_kill_monster( target_struct.location.sceneid  ,target_struct.location.entityName, target_struct.id );
				end				
			end
			

		

		-- 0 杀怪类、1 收集类、2 消耗类、3 对话类、4 送物类5角色的等级达标
		-- 6角色所在帮派等级 7身上其中一件装备强化等级8身上其中一件装备打孔等级
		--9身上其中一件装备镶嵌指定数量宝石10身上其中一件装备精锻等级
		--11角色杀戮值12角色战魂值13角色帮派贡献分14角色阵营贡献
		--40 打开界面或访问npc
		elseif ( target_struct.type == 5 ) then
			-- if mini_task_panel_click then 
			-- 	KaJiTuiJianWin:show()
			-- end
			result = false
		elseif ( target_struct.type == 7 ) then

		elseif ( target_struct.type == 40 ) then
			require "GlobalFunc"
			GlobalFunc:parse_str( target_struct.data,mini_task_panel_click );
		elseif ( target_struct.type == 127 ) then
			require "GlobalFunc"
			GlobalFunc:parse_str( target_struct.data,mini_task_panel_click );
		end
			
	end
	return result
end

-- 判断AIManager当前是否在执行主线任务
function AIManager:is_doing_zx_quest( )
	-- 首先判断当前是否已经在做任务，如果已经在做主线任务就直接返回，如果不是主线，就执行新的任务
	if ( AIManager:get_state() == AIConfig.COMMAND_DO_QUEST ) then
		if ( doing_quest ) then
			if ( TaskModel:is_zhuxian_quest( doing_quest ) ) then
				return true;	
			end
		end
 	end
 	return false;
end

-- 当任务完成的时候要清空AIManager的状态
function AIManager:on_quest_finish()
	if ( AIManager:get_state() == AIConfig.COMMAND_DO_QUEST ) then
		AIManager:set_state( AIConfig.COMMAND_IDLE );
	end
	doing_quest = nil;
	doing_quest_type = nil
end

-- 提交任务，任务完成后自动去交任务
function AIManager:get_commit_quest_npc(quest_info)
	-- type = 0,--任务的接受和提交类型，0表示从NPC上交任务；1表示满足需求条件时自动完成并获得奖励；2表示由脚本系统动态处理
	if ( quest_info.comp.type == 0 ) then
		local curr_scene_id = SceneManager:get_cur_scene();
		local target_scene_id = SceneConfig:get_id_by_name( quest_info.comp.scene );
		if ( target_scene_id ~= nil ) then
			local npc = quest_info.comp.npc;
			return npc;
		else
			print("[AIManager:commit_quest(quest_info)]:没有找到目标scene_id")
		end
	end
end

-- 判断当前场景是否目标场景
function AIManager:is_reach_target_scene_and_do_command( target_scene_id ,after_reach_scene_command,param )
	--print('AIManager:is_reach_target_scene_and_do_command', target_scene_id, param[1],param[2] )
	local curr_scene_id = SceneManager:get_cur_scene();

	if ( curr_scene_id ~= target_scene_id ) then
		-- 切换当前AI为跨场景
		AIManager:set_state( AIConfig.COMMAND_ENTER_SCENE );
		-- 记录到达场景后要做的command
		_after_reach_target_scene_command = after_reach_scene_command;
		-- 记录当前要访问的目标场景和当前在执行的任务id
		_current_target_scene = target_scene_id;
		-- 记录参数
		_after_reach_target_scene_param = param;
		-- 开始移动
	--	print("curr_scene_id,_current_target_scene_id = ",curr_scene_id,_current_target_scene )
		local tx,ty = AIManager:get_nearest_position( curr_scene_id , _current_target_scene ) 
	--	print(" tx,ty = ",tx,ty);
		local pos_x,pos_y = SceneConfig:grid2pos(tx,ty);
		-- 移动
		--CommandManager:move( pos_x , pos_y , true ,nil,EntityManager:get_player_avatar() );
		CommandManager:move2Teleport( pos_x, pos_y, true ,nil,EntityManager:get_player_avatar())
		return false;
	else
		self:do_reach_target_scene_command( target_scene_id ,after_reach_scene_command,param )
		return true;
	end
end
-- 执行到达指定场景后的command
function AIManager:do_reach_target_scene_command( target_scene_id ,after_reach_scene_command,param )
	-- print("====AIManager:do_reach_target_scene_command=========",after_reach_scene_command)
	-- 设置当前状态
	AIManager:set_state(after_reach_scene_command);

	-- 如果到达目标场景后要执行的command是任务
	if ( after_reach_scene_command == AIConfig.COMMAND_DO_QUEST ) then
		-- 继续执行任务
		AIManager:do_quest( param[1] , param[2]);
	-- 访问npc
	elseif ( after_reach_scene_command == AIConfig.COMMAND_ASK_NPC ) then
		CommandManager:ask_npc( target_scene_id,param,"");
	-- 采集
	elseif ( after_reach_scene_command == AIConfig.COMMAND_GATHER ) then
		CommandManager:quest_gather( target_scene_id  ,param[1], param[2] ,param[3],param[4]);
	-- 杀怪
	elseif ( after_reach_scene_command == AIConfig.COMMAND_KILL_MONSTER ) then
		CommandManager:quest_kill_monster( target_scene_id  ,param[1], param[2]  );
	-- 自定义任务
	elseif ( after_reach_scene_command == AIConfig.COMMAND_DO_ZIDINGYI_QUEST ) then

	elseif ( after_reach_scene_command == AIConfig.COMMAND_MOVE ) then
		if ( #param > 1 ) then
			CommandManager:move( param[1],param[2] , true ,nil,EntityManager:get_player_avatar());
		end

	elseif ( after_reach_scene_command == AIConfig.COMMAND_ACTION_MOVE ) then
		if ( #param > 1 ) then
			CommandManager:action_move( param[1],param[2] , true ,nil,EntityManager:get_player_avatar());
		end

	elseif ( after_reach_scene_command == AIConfig.COMMAND_FUBEN_GUAJI ) then
		AIManager:toggle_guaji(  );
		-- 先停止当前动作
		local player = EntityManager:get_player_avatar();
		player:stop_curr_action();
		AIManager:toggle_guaji(  );
	end

	_after_reach_target_scene_command = nil;
	_after_reach_target_scene_param = nil;
end



--------------------------------------------任务AI---------------------------------------------------------


--------------------------------------------地图AI-------------------------------------------------------------

-- local m_FindMapLinkExpectList = {};
-- function AIManager:findLinkPos(scene_id,target_scene_id) then
-- 	if ( scene_id == target_scene_id )
-- 			print("同一地图中不存在连接的概念！");
-- 			m_FindMapLinkExpectList = {};
			
-- 			if ( source.teleport )
-- 			{
-- 				var linkDesc: LinkPosDesc;
-- 				linkDesc = findNearestLinkPosInEnvir(source, target, m_FindMapLinkExpectList);
-- 				if ( linkDesc )
-- 					return new Point(linkDesc.lnk.posx, linkDesc.lnk.posy);
-- 			}
-- 	return null;
-- end



function AIManager:get_nearest_position( curr_scene_id , target_scene_id )
	local source_scene = SceneConfig:get_scene_by_id( curr_scene_id )
	local target_scene = SceneConfig:get_scene_by_id( target_scene_id )
	print("source_scene, target_scene",source_scene, target_scene)
	local nearest_position = AIManager:calculate_to_target_map_teleport( source_scene, target_scene );
	if nearest_position == nil then
		return 0, 0
	end
	return nearest_position.teleport.posx, nearest_position.teleport.posy
end

-- 计算指定场景到目标场景的最靠近的传送点
function AIManager:calculate_to_target_map_teleport(source_scene, target_scene, expect_list)

	if expect_list == nil then
		expect_list = {}
	end
	
	local nearest_position = nil

	-- 添加到排除列表
	table.insert(expect_list, source_scene)
	-- 遍历当前场景的出口
	for key,teleport in pairs(source_scene.teleport) do
		-- 如果下一个出口可以到达目标地图，则等于找到答案了
		if not target_scene then
			break
		end
		if teleport.toSceneid == target_scene.scenceid then
			nearest_position = {teleport = teleport, distance = 0}
			break
		end

		local next_scene = SceneConfig:get_scene_by_id(teleport.toSceneid)
		if next_scene ~= nil and next_scene.teleport ~= nil then
			-- 如果下一个场景在忽略列表，则跳过
			local is_existed = false
			for i, scene in ipairs(expect_list) do
				if scene == next_scene then
					is_existed = true
					break
				end
			end

			if not is_existed then
				local ret = self:calculate_to_target_map_teleport(next_scene, target_scene, expect_list)
				if ret then
					if nearest_position == nil or nearest_position.distance > ret.distance then
						nearest_position = ret
						nearest_position.teleport = teleport
					end 
				end
			end
		end
	end

	table.remove(expect_list)
	if nearest_position ~= nil then
		nearest_position.distance = nearest_position.distance + 1
		return nearest_position
		-- return nearest_position.teleport.posx , nearest_position.teleport.posy
	end
	-- nearest_position.teleport.posx   / posy
	return nil
end

-- 取得指定场景能到达的下一个场景
function AIManager:get_next_scene_ids(scene_id)
	-- 相当于一个配置表 
	-- 0凌云渡1炎帝洞2云梦山3九黎野4轩辕墟5不周山6北冰原7雷夏泽8青云渡9南蛮荒10青鸾峰
	-- 11玄都12飞云渡13飞仙岭14天魔城15神农渊16幻仙境17常青谷
	if ( scene_id == 0 ) then -- 0凌云渡
		return {2}; --2云梦山

	elseif (scene_id == 1) then -- 1炎帝洞
		return { 15,7,4 };		--15神农渊7雷夏泽4轩辕墟

	elseif (scene_id == 2) then -- 2云梦山
		return { 0,11 };		--0凌云渡11玄都

	elseif (scene_id == 3) then -- 3九黎野
		return { 6,11 };		--6北冰原,11玄都

	elseif (scene_id == 4) then -- 4轩辕墟
		return { 17,11,5,1 };  --17常青谷11玄都5不周山1炎帝洞

	elseif (scene_id == 5) then -- 5不周山
		return { 16,4 };  --16幻仙境4轩辕墟

	elseif (scene_id == 6) then -- 6北冰原
		return { 3 };  --3九黎野

	elseif (scene_id == 7) then -- 7雷夏泽
		return { 1,13,9 };  --1炎帝洞13飞仙岭9南蛮荒

	elseif (scene_id == 8) then -- 8青云渡
		return { 10 };  --10青鸾峰

	elseif (scene_id == 9) then -- 9南蛮荒
		return { 10,7 };  --10青鸾峰,7雷夏泽

	elseif (scene_id == 10) then -- 10青鸾峰
		return { 9,11 };  --9南蛮荒11玄都

	elseif (scene_id == 11) then -- 11玄都
		return { 17,13,10,2,3,4 };  --17常青谷13飞仙岭10青鸾峰2云梦山3九黎野4轩辕墟

	elseif (scene_id == 12) then -- 12飞云渡
		return { 13 };  --13飞仙岭

	elseif (scene_id == 13) then -- 13飞仙岭
		return { 11,7 };  --11玄都7雷夏泽

	-- elseif (scene_id == 14) then -- 14天魔城
	-- 	return { 11 };  --11
	elseif (scene_id == 15) then -- 15神农渊
		return { 1 };  --1炎帝洞

	elseif (scene_id == 16) then -- 16幻仙境
		return { 5 };  --5不周山

	elseif (scene_id == 17) then -- 17常青谷
		return { 11,4 };  --11玄都4轩辕墟
	end
end

function AIManager:get_cur_quest_id( )
	return doing_quest, doing_quest_type
end

--------------------------------------------地图AI------------------------------------------------------------

--------------------------------------------挂机AI------------------------------------------------------------







--------------------------------------------挂机AI------------------------------------------------------------


function AIManager:on_selected_entity(entity,can_attack_target)
	-- 生物类
	-- [-2] = "PlayerPet",				-- 玩家的宠物
	-- [-1] = "PlayerAvatar",			-- 主玩家
	-- [0] = "Avatar",					-- 玩家
	-- "Monster",						-- 怪物
	-- "NPC",							-- npc
	-- "MovingNPC",					-- 巡逻的npc
	-- "Pet",							-- 宠物
	-- -- 非生物
	-- "Totem",						-- 图腾
	-- "Mine",							-- 矿物，采集对象
	-- "Defender",						-- 防御措施
	-- "Plant",						-- 植物，采集对象
	-- -- 特效类
	-- "Teleport",						-- 传送门
	-- "Building",						-- 建筑
	-- "Effect",						-- 特效
	-- -- 其他
	-- "Collectable",					-- 采集怪
	-- "DisplayMonster",				-- 显示怪，如炸药包
	--print("entity.type = ",entity.type,"_current_command_state",_current_command_state);

	-- 如果当前在挂机，直接返回
	if ( _current_command_state == AIConfig.COMMAND_FUBEN_GUAJI or _current_command_state == AIConfig.COMMAND_GUAJI ) then
		return;
	end

	-- 如果玩家点击的是同一只实体并且当前有不可打断的动作
	if ( old_selected_entity and old_selected_entity.handle == entity.handle and EntityManager:get_player_avatar():is_can_break_action() == false ) then
		return;
	end

	-- -- 如果重复点击同一只怪，直接返回了
	-- if ( _current_command_state == AIConfig.COMMAND_KILL_MONSTER or _current_command_state == AIConfig.COMMAND_GATHER) then 
	-- 	-- if ( old_selected_entity and old_selected_entity.handle == entity.handle ) then 
	-- 	-- --	print("old_selected_entity.handle , entity.handle",old_selected_entity.handle , entity.handle)
	-- 	-- --	print("同一个entity")
	-- 	-- 	return;
	-- 	-- end
	-- 	-- 如果玩家点击的是同一只实体并且当前有动作的话就直接返回
	-- 	if ( old_selected_entity and old_selected_entity.handle == entity.handle and EntityManager:get_player_avatar():get_curaction() ~= nil ) then
	-- 		return;
	-- 	end
	-- end

	-- 取消自动挂机和打坐，任务
	AIManager:set_AIManager_idle(  );

	-- -- 杀怪
	if ( entity.type == 1 or entity.type == 4  ) then
		-- 如果能够攻击目标
		if ( can_attack_target ) then 
			local skill = AIManager:get_can_use_skill()
			if ( skill ) then 
				CommandManager:combat_skill( skill ,EntityManager:get_player_avatar())
			end
			AIManager:set_state( AIConfig.COMMAND_KILL_MONSTER );
		end

	-- 访问npc
	elseif ( entity.type == 2 ) then
		
		CommandManager:ask_target_npc(entity.model.m_x,entity.model.m_y,entity.name)
	-- 采集
	elseif ( entity.type == 12 ) then
		--print("----------=-=-=-================ entity.id = ", entity.id);
		if ( SceneManager:get_cur_fuben() == 7) then
			-- 如果是在仙盟领地副本
			local gather_count = FubenTongjiModel:get_pantao_gather_count( );
			if gather_count == nil or gather_count == 0 then
				GlobalFunc:create_screen_notic( LangGameString[3] ); -- [3]="采集次数已经用完"
				return;
			end
		end
		if ( SceneManager:get_cur_fuben() == 73 or SceneManager:get_cur_fuben() == 74 ) then
			-- -- 如果是在仙盟领地副本
			-- local gather_count = FubenTongjiModel:get_pantao_gather_count( );
			-- if gather_count == nil or gather_count == 0 then
			-- 	GlobalFunc:create_screen_notic( "采集次数已经用完" );
			-- 	return;
			-- end
		end
		local player = EntityManager:get_player_avatar();
		-- 不允许重复采集
		AIManager:set_state( AIConfig.COMMAND_GATHER ); 
		local monster_info = MonsterConfig:get_monster_by_id( entity.id);
		local gatherTime = monster_info.gatherTime;
		local tile_x,tile_y = SceneManager:pixels_to_tile( entity.model.m_x, entity.model.m_y )
		CommandManager:gather( monster_info.name,tile_x,tile_y,gatherTime)

	elseif ( entity.type ==  0 ) then
		local player = EntityManager:get_player_avatar();
		-- 如果是在瑶池仙泉中
		if ( XianYuModel:get_status(  ) ) then
			-- 移动到目标的前面一格
			local player = EntityManager:get_player_avatar();
			local target_x = entity.model.m_x;
			local target_y = entity.model.m_y;
			local _x = target_x - player.x;
			local _y = target_y - player.y;
			local distance = math.sqrt( _x * _x + _y * _y );
			if ( distance > 1 ) then 
				if ( player.x > entity.model.m_x ) then
					target_x = target_x + 10
				else
					target_x = target_x - 10
				end
			end
			--print("target_x,target_y = ",target_x,target_y,player.x,player.y)
			CommandManager:move(target_x,target_y,true,nil,player);
		elseif ( can_attack_target ) then
			local skill = AIManager:get_can_use_skill()
			if ( skill ) then 
				CommandManager:combat_skill( skill ,EntityManager:get_player_avatar())
			end
			AIManager:set_state( AIConfig.COMMAND_KILL_MONSTER );
		end
	-- 如果是传送门
	elseif ( entity.type ==  9 ) then
		local player = EntityManager:get_player_avatar();
		CommandManager:move( entity.model.m_x,entity.model.m_y ,true,nil,player);
	end

	EntityManager:set_one_monster_show_name( old_selected_entity )  -- 怪物的名称，根据设置系统来控制是否显示
	-- 
	old_selected_entity = entity;

    if entity and entity.model then                    -- 设置系统，如果设置不显示怪物名称。选中的时候，要把怪物名称显示
        --entity.model:showName( true )
        entity.name_lab.view:setIsVisible( true )
    end

    	-- 如果是在仙道会中
	local win = UIManager:find_visible_window("zbs_action_win")
	if ( win ) then
		if entity.type == 0 then 
			local zbs_info = XDHModel:get_zbs_info();
			local player_info = zbs_info.xdhzbs_player_table;
			for i=1,#player_info do
				if ( player_info[i].id == entity.id ) then
					win:update_btn_state( CLICK_STATE_UP,entity.name );
					return;
				end
			end
		end
		print("win:update_btn_state( CLICK_STATE_DISABLE,nil );")
		win:update_btn_state( CLICK_STATE_UP,nil );
	end
end
-- 当玩家的目标死亡或消失时
function AIManager:on_clear_select_target(  )
	--print("-----------------------on_clear_select_target-----------------------------")

	-- 如果是在仙道会中
	local win = UIManager:find_visible_window("zbs_action_win")
	if ( win ) then
		local zbs_info = XDHModel:get_zbs_info();
		local player_info = zbs_info.xdhzbs_player_table;
		for i=1,#player_info do
			if old_selected_entity and ( player_info[i].id == old_selected_entity.id ) then
				win:update_btn_state( CLICK_STATE_DISABLE );
				break;
			end
		end
	end
	old_selected_entity = nil;
end

-- 当前选中的目标
function AIManager:get_current_select_target()
	return old_selected_entity;
end

local function _AIManager_ask_npc(params)
	AIManager:ask_npc( params[1],params[2] )
end

-- 访问npc
function AIManager:ask_npc( target_scene_id,npc_name )
	-- 先取消ai
	--------------------------------
	_paused_args =
	{
		_AIManager_ask_npc,
		{ target_scene_id, npc_name }
	}
	--------------------------------
	AIManager:set_AIManager_idle();
	AIManager:is_reach_target_scene_and_do_command( target_scene_id ,AIConfig.COMMAND_ASK_NPC, npc_name );
end

local function _AIManager_move_to_target_scene( params )
	AIManager:move_to_target_scene( params[1],params[2],params[3] )
end


-- 移动到某个场景的某个坐标 x,y 格子坐标
function AIManager:move_to_target_scene( target_scene_id,x,y )
	--------------------------------
	_paused_args =
	{
		_AIManager_move_to_target_scene,
		{ target_scene_id, x, y }
	}
	--------------------------------
	local param_table = {};
	if ( x and y ) then
		param_table[1] = x;
		param_table[2] = y;
	end
	--print("移动到目标坐标......................",x,y)
		-- 先取消ai
	AIManager:set_AIManager_idle();
	AIManager:is_reach_target_scene_and_do_command( target_scene_id ,AIConfig.COMMAND_ACTION_MOVE, param_table );
end

local function _AIManager_set_guaji()
	AIManager:set_guaji()
end

-- 开关挂机
function AIManager:toggle_guaji(  )
	if ( _current_command_state == AIConfig.COMMAND_GUAJI or _current_command_state == AIConfig.COMMAND_FUBEN_GUAJI ) then
		AIManager:set_state(AIConfig.COMMAND_IDLE);
		-- ZXLog('-------------111------------------')
	else
		AIManager:set_guaji()
	end
end


function AIManager:set_guaji()
	_paused_args =
	{
		_AIManager_set_guaji
	}

	if ( _current_command_state == AIConfig.COMMAND_GUAJI or _current_command_state == AIConfig.COMMAND_FUBEN_GUAJI ) then
		return
	end
	--------------------------------
	local player = EntityManager:get_player_avatar();
	-- 取消玩家的当前目标
	player.target_id = nil;
	-- 停止当前动作
	player:stop_curr_action();
	local fuben_id = SceneManager:get_cur_fuben();
	if ( fuben_id == 0 ) then
		AIManager:set_state(AIConfig.COMMAND_GUAJI);
	else
		AIManager:set_state(AIConfig.COMMAND_FUBEN_GUAJI);
	end
	-- 玩家站立
	local player = EntityManager:get_player_avatar();
	-- 先停止打坐
	player:stop_dazuo();
	if ( ZXLuaUtils:band(player.state , EntityConfig.ACTOR_STATE_ZANZEN) > 0  or  ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0 ) then
		player:stop_all_action();
	end
end

function AIManager:get_comman_state(  )
	return _current_command_state
end

-- 挂机
function AIManager:guaji()
	if _current_command_state ~= AIConfig.COMMAND_GUAJI and _current_command_state ~= AIConfig.COMMAND_FUBEN_GUAJI  then
		AIManager:toggle_guaji(  )
	end
end

-- 找到最近的玩家打泡泡
function AIManager:xianyu_find_nearest_avater_play_action(  )
	-- 找到最近的玩家
	local avater_handle = EntityManager:find_nearest_target( 0 );
	if ( avater_handle ) then
		local player = EntityManager:get_player_avatar();
		local avater = EntityManager:get_entity(avater_handle);
		-- 设置选中
		player:set_target(avater);
		local tile_x,tile_y = SceneManager:pixels_to_tile( avater.model.m_x,avater.model.m_y );
		AIManager:da_paopao( tile_x,tile_y ); 
	else
		XianYuModel:AI_play_action_fail();
	end
end
-- 直接与选中的玩家打泡泡
function AIManager:xianyu_da_paopao_with_target()
	local player = EntityManager:get_player_avatar();
	local avater = EntityManager:get_entity( player.target_id );
	local tile_x,tile_y = SceneManager:pixels_to_tile( avater.model.m_x,avater.model.m_y );
	AIManager:da_paopao( tile_x,tile_y ); 
end

-- 打泡泡
function AIManager:da_paopao( tile_x,tile_y )
	CommandManager:da_pao_pao( tile_x,tile_y );
end

-- 判断主角是否在跟随玩家的附近
function AIManager:is_player_near_target(  )
	local player = EntityManager:get_player_avatar();
	local follow_entity = EntityManager:get_entity( ai_data );
	if ( player and follow_entity ) then
	--	print( "follow_entity.model.m_x, follow_entity.model.m_y,player.x,player.y",follow_entity.model.m_x, follow_entity.model.m_y,player.x,player.y );
		local other_tx,other_ty = SceneConfig:pos2grid( follow_entity.model.m_x, follow_entity.model.m_y );
		local player_tx,player_ty = SceneConfig:pos2grid( player.x, player.y );
	
		local dx = other_tx - player_tx ;
		local dy = other_ty - player_ty ;
	--	print("dx,dy",dx,dy);
		local distance = math.sqrt(dx * dx + dy * dy);
		--print("玩家与目标的距离为:",distance);
		if ( distance < 2 ) then
			return true;
		end
		local ex,ey = 0,0;
		if ( player._current_action == nil ) then
			if ( player.dir > 3 ) then
				ex = 1
			else
				ex = -1;
			end
		end 
		-- 跟随
		CommandManager:move( follow_entity.model.m_x + ex * SceneConfig.LOGIC_TILE_WIDTH, follow_entity.model.m_y , true,nil,player);
	else

	end
end

-- 寻路卡住后继续任务
function AIManager:continue_quest()
	-- 如果当前在任务状态中被寻路卡主
	--print('AIManager:continue_quest', _current_command_state, doing_quest)
	if doing_quest ~= nil then
		-- 继续做任务, 获取任务是可接还是已接
		local qtype = TaskModel:get_task_acceptType(doing_quest)
		if qtype then
			AIManager:do_quest( doing_quest , qtype)
			return true
		end
	else
		--如果没有正在做的任务，找一个
		return AIManager:do_next_quest()
	end
	return false
end

-- 找一个任务来做
function AIManager:do_next_quest()
	doing_quest = nil
	quest_type = nil
	--如果没有正在做的任务，做主线任务
	local zx_quest_id,quest_type = TaskModel:get_zhuxian_quest()
	if ( zx_quest_id and quest_type ) then
		AIManager:do_quest( zx_quest_id , quest_type );
		return true
	else
		--如果没有主线任务，随便找一个任务
		local qid, qtype = TaskModel:get_task_to_do()
		if ( qid and qtype ) then
			AIManager:do_quest( qid , qtype );
			return true
		end
	end
	return false
end
function _AIManager_gather_by_pos(params)
	AIManager:gather_by_pos(params[1],params[2])
end
-- 移动到目标然后采集
function AIManager:gather_by_pos( tile_x,tile_y )
	--------------------------------
	_paused_args =
	{
		_AIManager_gather_by_pos,
		{ tile_x, tile_y }
	}
	--------------------------------

	local player = EntityManager:get_player_avatar();
	CommandManager:move( tile_x * SceneConfig.LOGIC_TILE_WIDTH, tile_y * SceneConfig.LOGIC_TILE_HEIGHT, true,nil,player);
	AIManager:set_state( AIConfig.COMMAND_AUTO_GATHER );
end

function AIManager_auto_kill_monster_by_pos(params)
	AIManager:auto_kill_monster_by_pos(params[1],params[2])
end
-- 移动到目标地点然后挂机
function AIManager:auto_kill_monster_by_pos( tile_x,tile_y )
	--------------------------------
	_paused_args =
	{
		AIManager_auto_kill_monster_by_pos,
		{ tile_x, tile_y }
	}
	--------------------------------
	AIManager:set_state(AIConfig.COMMAND_MOVE_TO_MONSTER)
	CommandManager:auto_kill_monster( tile_x,tile_y )
end


--同地图传送方法
local function grid2pos(grid_x,grid_y)
	local pos_x = (grid_x + 0.5) * SceneConfig.LOGIC_TILE_WIDTH;
	local pos_y = (grid_y + 0.5) * SceneConfig.LOGIC_TILE_HEIGHT;
	return pos_x,pos_y;
end


--同地图传送方法
--找有没有可以去目的地的传送点
function AIManager:get_nearest_teleport(curr_scene_id, ttx , tty)
	local source_scene = SceneConfig:get_scene_by_id( curr_scene_id )
	local teleport_list = {}
	local min_distance = 0xffffffff
	local _entity = EntityManager:get_player_avatar();
	local s_map_x = _entity.model.m_x
	local s_map_y = _entity.model.m_y
	local target_entity = nil
	local tinsert = table.insert
	local t_map_x,t_map_y = grid2pos(ttx,tty)
	local _sceneFindPath = SceneManager.sceneFindPath

	local target_tels = {}  --目标传送
	local open_tels = {}	--可选的传送
	local all_tels = source_scene.teleport
	for key,teleport in pairs(all_tels) do
		if teleport.toSceneid == source_scene.scenceid then

			teleport._parent = nil
			teleport.id = key

			local tel_x, tel_y = grid2pos(teleport.toPosx,teleport.toPosy);
			local path = _sceneFindPath(tel_x,tel_y,t_map_x,t_map_y)
			if path then
				target_tels[#target_tels+1] = teleport
				
			end

		end
	end

	--print('目标列表------------------------')
	for i,tel in ipairs(target_tels) do
		print('找到目标了',tel.id, tel.posx,tel.posy)
	end

	local tel_path = {}
	local visited = {}
	local target_teleport = nil
	local depth = 0
	local error_code = ''
	local function _findTargetTeleport(parent, teleports)
		--找可以到达玩家的传送点
		depth = depth + 1
		if depth > 8 then
			error_code = '[寻路深度过深]'
			return false
		end
		for i, tel in ipairs(teleports) do
			if visited[tel] then
				--寻路死循环了
				error_code = '[寻路死循环了]'
				return false
			end
			visited[tel] = true
			local tel_map_x,tel_map_y = grid2pos(tel.posx,tel.posy)
			tel._parent = parent
			local path = _sceneFindPath(s_map_x,s_map_y,tel_map_x,tel_map_y)
			if path then
				print('到达来源了',tel.id, tel.posx,tel.posy)
				target_teleport = tel
				return true
			else
				--寻路自己的来自tel
				--tel_path[#tel_path+1] = tel
				-----------------------------
				local _fromTels = {}
				if tel.fromTels then
					for j, tt in ipairs(tel.fromTels) do
						_fromTels[#_fromTels+1] = all_tels[tt]
					end
					if _findTargetTeleport(tel,_fromTels) then
						return true
					end
				end
			end
		end
		--根本走不通
		return false
	end

	local bOK = _findTargetTeleport(nil,target_tels)
	if not bOK then
		GlobalFunc:create_screen_notic('寻路失败:' .. error_code)
		return nil
	end

	if not target_teleport then
		--print('无法找到目标传送点')
		return nil
	end

	local tp = target_teleport
	local i = 0
	while(tp) do
		if i > 8 then
			assert(false,'get_nearest_teleport 传送点的遍历深度过深')
		end

		tel_path[#tel_path+1] = tp
		tp = tp._parent
		i = i + 1
	end

	print('AIManager:get_nearest_teleport Begin')
	print('>>>>>', target_teleport.id)
	for i, v in ipairs(tel_path) do
		print(v.posx,v.posy,v.id)
	end
	print('AIManager:get_nearest_teleport End')
	return tel_path
end


--同地图传送方法
--跑到下一个传送点
function AIManager:gotoNextSameSceneTeleport()
	if #_cur_scene_teleport_list == 0 then
		local _callback_action = _cur_scene_teleport_action
		AIManager:set_state( AIConfig.COMMAND_IDLE );
		if _callback_action then
			_callback_action()
		end
		_cur_scene_teleport_action = nil
		return 
	end
	local player = EntityManager:get_player_avatar()
	local first_tp = table.remove(_cur_scene_teleport_list,1)
	local tel_map_x,tel_map_y = grid2pos(first_tp.posx,first_tp.posy)

	print('****','AIManager:gotoNextSameSceneTeleport',first_tp.id,#_cur_scene_teleport_list)
	CommandManager:move( tel_map_x, tel_map_y, true ,nil, player);
end

--同地图传送方法
--设置传送数据
function AIManager:setSameSceneTeleportArgs(path, actionQueueCreator)
	local player = EntityManager:get_player_avatar()
	_cur_scene_teleport_list = path
	_cur_scene_teleport_action = function() player:add_action_queue(actionQueueCreator()) end
end

--同地图传送方法
--清除传送数据
function AIManager:clearSameSceneTeleportArgs()
	--xprint('clearSameSceneTeleportArgs')
	_cur_scene_teleport_list = {}
	_cur_scene_teleport_action = nil
end

--同地图传送方法，同地图传送，获取传送列表
function AIManager:doSameSceneTeleport(curr_scene_id, ttx , tty, actionQueueCreator)
	local path = AIManager:get_nearest_teleport(curr_scene_id,ttx,tty)
	if path then
		
		--print('AIManager:doSameSceneTeleport ok', curr_scene_id, ttx , tty)
		AIManager:set_state(AIConfig.COMMAND_SCENE_TELEPORT)
		AIManager:setSameSceneTeleportArgs(path,actionQueueCreator)
		AIManager:gotoNextSameSceneTeleport()
		return true
	else
		--assert(false, 'AIManager:doSameSceneTeleport')
	end
	return false
end

function AIManager:pause()
	print("********** AIManager:pause() ***********")
	local _save = _paused_args
	AIManager:set_AIManager_idle()
	_paused_args = _save

	local player = EntityManager:get_player_avatar();
	player:stop_all_action(true)
	--_paused = true
end

function AIManager:resume()
	print("********** AIManager:resume() ***********")
	local _args = _paused_args
	if _args then
		_paused_args = nil
		_args[1](_args[2])
	end
	--_paused = false
end