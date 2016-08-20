-- CommandManager.lua
-- created by aXing on 2013-1-18
-- 主角指令集管理器

-- require "entity/EntityManager"
-- require "action/ActionMove"
-- require "action/ActionApproachStatic"
-- require "action/ActionApproach"
-- require "action/ActionCombatSpell"
-- require "action/ActionSimpleAttack"
-- require "action/ActionAsk"
-- require "action/ActionGather"
-- require "action/ActionGuaji"
-- require "action/ActionDaPaoPao"
-- require "action/ActionPetSpell"

CommandManager = {}




-- 普通移动 tx = 像素值
function CommandManager:move( tx, ty, need_send_to_server, after_moved_action_cb , entity, do_not_ride)
	--xprint("CommandManager:move",tx,ty)
	-- 如果玩家当前状态是禁止移动或眩晕状态或者死亡，直接返回
	if entity:isActionBlocking() then
		print('原子操作中！不能移动')
		return
	end
	if ( ZXLuaUtils:band(entity.state, EntityConfig.ACTOR_STATE_DIZZY) > 0 or 
		ZXLuaUtils:band(entity.state, EntityConfig.ACTOR_STATE_MOVE_FORBID) > 0	 or
		ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_DEATH) > 0 ) then
		GlobalFunc:create_screen_notic( LangGameString[1] ); -- [1]="当前不能移动"
		return;
	end

	-- 调用引擎的寻路算法，获取路点
	local queue = {}
	local action = ActionMove{ tx = tx, ty = ty, 
							   need_send_to_server = need_send_to_server,
							   entity = entity,
							   do_not_ride = do_not_ride
							 }
	
	if action:failed() then
		CommandManager:handleMoveFailed(tx,ty)
		return
	end

	table.insert(queue, action)
	if after_moved_action_cb ~= nil then
		table.insert(queue, ActionCallBack(after_moved_action_cb));
	end
	entity:add_action_queue(queue)

	if ( entity.type == -1 ) then
		--print("播放特效,tx ,ty",tx,ty );
		-- 先删除之前的移动特效
		LuaEffectManager:stop_map_effect( 21 )
		-- 播放移动目标的特效
		local ccp = CCPoint(tx,ty);
		SceneManager.game_scene:mapPosToGLPos(ccp)
		LuaEffectManager:play_map_effect( 21,ccp.x,ccp.y,true,10000 )
		-- 如果是主角移动，并且移动的距离大于一定值，就让主角上坐骑
		if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT, false) and SceneManager:get_cur_fuben() == 0 ) then
		end
	end
end


-- 普通移动 tx = 像素值
function CommandManager:action_move( tx, ty, need_send_to_server, after_moved_action_cb , entity)
	print("CommandManager:actionMove",tx,ty)
	-- 如果玩家当前状态是禁止移动或眩晕状态或者死亡，直接返回
	if entity:isActionBlocking() then
		print('原子操作中！不能移动')
		return
	end

	if ( ZXLuaUtils:band(entity.state, EntityConfig.ACTOR_STATE_DIZZY) > 0 or 
		ZXLuaUtils:band(entity.state, EntityConfig.ACTOR_STATE_MOVE_FORBID) > 0	 or
		ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_DEATH) > 0 ) then
		GlobalFunc:create_screen_notic( LangGameString[1] ); -- [1]="当前不能移动"
		return;
	end

	-- 调用引擎的寻路算法，获取路点
	function _createActionQueue()
		local action_0 = ActionMove{tx = tx, ty = ty, need_send_to_server = need_send_to_server,entity = entity}
		if after_moved_action_cb ~= nil then
			local action_1 = ActionCallBack(after_moved_action_cb)
			return { action_0, action_1 }
		else
			return { action_0 }
		end
	end

	local tile_x,tile_y = SceneManager:pixels_to_tile( tx, ty )
	if not SceneManager:can_move(tile_x,tile_y) then
		GlobalFunc:create_screen_notic('目标点不可行走')
		AIManager:set_AIManager_idle()
		entity:stop_all_action(true)
		return
	end

	if not CommandManager:checkPath(tile_x,tile_y,entity) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
		return
	end
	
	local queue = _createActionQueue()
	entity:add_action_queue(queue)
	
	if ( entity.type == -1 ) then
		-- 先删除之前的移动特效
		LuaEffectManager:stop_map_effect( 21 )
		-- 播放移动目标的特效
		local ccp = CCPoint(tx,ty);
		SceneManager.game_scene:mapPosToGLPos(ccp)
		LuaEffectManager:play_map_effect( 21,ccp.x,ccp.y,true,10000 )
		-- 如果是主角移动，并且移动的距离大于一定值，就让主角上坐骑
		if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT, false) and SceneManager:get_cur_fuben() == 0 ) then
		end
	end
end
-- 普通攻击和技能攻击是同样的做法
function CommandManager:simple_attack(  )

end

local function _getSpellAction(skill, handle, player, is_power_attack)
	--获取是否普攻
	local action = SkillConfig.isCombatAttack(skill.id)
	print("action!!!!!!!!!!!!!!!!! ",action, is_power_attack,skill.id)
	if action then
		return ActionCombatAttack(skill,handle,player)
	elseif is_power_attack then
		return ActionCombatPowerAttack(skill, handle, player)
	else
		return ActionCombatSpell(skill,handle,player)
	end
end

function CommandManager:combat_power_skill( skill )

	--print("CommandManager:combat_skill( skill )")
	local player = EntityManager:get_player_avatar();

	if player:isActionBlocking() then
		print('原子操作中！不能移动')
		return
	end

	-- 如果挂了，就不能放技能了
	if player:is_dead() then
		print("主角挂了，不能释放技能")
		return
	end

	if player:is_have_state( ) then 
		print("主角眩晕或者禁止移动中....")
	end

	-- 只要技能没有cd，就可以释放
	if skill.cd ~= 0 then
		print("技能在冷却中,cd = ",skill.cd);
		return
	end

	-- 如果在坐骑上要先下坐骑
	local is_shangma = MountsModel:get_is_shangma(  )
	if ( is_shangma ) then
		MountsModel:ride_a_mount( )
	end

	-- added by aXing on 2013-5-9
	-- 有些技能是不需要目标的,
	-- 如自身buff和自身群攻技能，目标是自己，并不改变当前目标
	local std_skill = SkillConfig:get_skill_by_id(skill.id)
	print("skill.id",skill.id)
	-- or std_skill.skillSpellType == SkillConfig.ST_DIRECTLY
	if std_skill.skillSpellType == SkillConfig.ST_TO_SELF then
		-- 构建动作序列
		local queue  	= {}
		-- 群攻技能不需要填目标handle
		local spell 	= _getSpellAction(skill, player.handle, player, true)
		table.insert(queue, spell)
		-- 对于刀客，action_queue中动画是剑雨飞下的动画。SpecialSceneEffect:perform中的是屏幕震动、光芒闪烁的效果
		EntityManager:get_player_avatar():add_action_queue(queue)
		SpecialSceneEffect:perform(skill.id, std_skill)  -- 火影的必杀技动画由两部分组成，一部分是放入action_queue中，另一部分是SpecialSceneEffect:perform
		return 
	end
	
	-- 当获取技能最大释放距离
	local distance 	= SkillConfig:get_spell_distance(skill.id, skill.level)
	
	local target_entity = EntityManager:get_entity(player.target_id);

	-- 构建动作序列
	local queue  	= {}
	local approach  = ActionApproach{target_id = player.target_id, distance = distance,target_entity = target_entity}
	local spell 	= _getSpellAction(skill, player.target_id ,player)
	
	if approach:failed() then
		CommandManager:handleApproachFailed(tx,ty)
		return
	end

	table.insert(queue, approach)
	table.insert(queue, spell)
	EntityManager:get_player_avatar():add_action_queue(queue)
	
end


-- 主角使用技能攻击
function CommandManager:combat_skill( skill )

	--print("CommandManager:combat_skill( skill )")
	local player = EntityManager:get_player_avatar();

	if player:isActionBlocking() then
		print('原子操作中！不能移动')
		return
	end

	-- 如果挂了，就不能放技能了
	if player:is_dead() then
		print("主角挂了，不能释放技能")
		return
	end

	if player:is_have_state( ) then 
		print("主角眩晕或者禁止移动中....")
	end

	-- 只要技能没有cd，就可以释放
	if skill.cd ~= 0 then
		print("技能在冷却中,cd = ",skill.cd);
		return
	end

	-- -- 判断是否有足够的蓝
	-- if ( player:check_is_enough_magic_use_skill( skill ) == false ) then
	-- 	print("蓝不够");
	-- 	return;
	-- end

	-- 如果在坐骑上要先下坐骑
	local is_shangma = MountsModel:get_is_shangma(  )
	if ( is_shangma ) then
		MountsModel:ride_a_mount( )
	end

	-- added by aXing on 2013-5-9
	-- 有些技能是不需要目标的,
	-- 如自身buff和自身群攻技能，目标是自己，并不改变当前目标
	local std_skill = SkillConfig:get_skill_by_id(skill.id)
	print("run CommandManager:combat_skill skill.id",skill.id,std_skill.skillSpellType == SkillConfig.ST_TO_SELF)
	-- or std_skill.skillSpellType == SkillConfig.ST_DIRECTLY
	if std_skill.skillSpellType == SkillConfig.ST_TO_SELF then
		-- print("释放群攻技能........................")
		-- 构建动作序列
		local queue  	= {}
		-- 群攻技能不需要填目标handle
		local spell 	= _getSpellAction(skill, player.handle, player)
		table.insert(queue, spell)
		EntityManager:get_player_avatar():add_action_queue(queue)
		SpecialSceneEffect:perform(skill.id, std_skill)
		return 
	end
	
	-- -- 下面是需要目标的情况
	-- local target_entity = nil;

	-- if ( player.target_id ) then
	-- 	target_entity = EntityManager:get_entity( player.target_id );
	-- end

	-- -- 先判断实体当前是否已经有攻击目标，并且该目标Hp大于0
	-- if ( target_entity and target_entity.hp > 0) then
	-- -- 	-- 判断实体能否攻击目标
	-- -- 	if ( player:can_attack_target( target_entity ) ) then
	-- -- 	else
	-- -- 		-- 不能攻击的话就直接返回
	-- -- 		print("目标不能被攻击");
	-- -- 		return;
	-- -- 	end
	-- -- else
	-- -- 	-- 暂时先取得最近的一个怪物
	-- -- 	local target_id = EntityManager:get_can_attack_entity(player);
	-- -- 	if target_id == nil then
	-- -- 		-- 找不到目标
	-- -- 		print("CommandManager:combat_skill:找不到目标")
	-- -- 		--GlobalFunc:create_screen_notic( "请选择目标" );
	-- -- 		return ;	
	-- -- 	end
	-- -- 	target_entity = EntityManager:get_entity( target_id );
	-- -- 	player:set_target(target_entity)
	-- else
	-- 	print("实体不存在或者实体血量小于0");
	-- 	return;
	-- end


	-- 当获取技能最大释放距离
	local distance 	= SkillConfig:get_spell_distance(skill.id, skill.level)
	
	--print("技能攻击范围=================",distance);
	-- 有些技能范围是偶数
	--if ( distance % 2  == 0 ) then
	--	distance = distance + 1;
	--end

	local target_entity = EntityManager:get_entity(player.target_id);

	-- 构建动作序列
	local queue  	= {}
	local approach  = ActionApproach{target_id = player.target_id, distance = distance,target_entity = target_entity}
	local spell 	= _getSpellAction(skill, player.target_id ,player)
	
	if approach:failed() then
		CommandManager:handleApproachFailed(tx,ty)
		return
	end

	table.insert(queue, approach)
	table.insert(queue, spell)
	EntityManager:get_player_avatar():add_action_queue(queue)
	
	--print("主角使用技能",skill.id)
end

-- 宠物使用技能
function CommandManager:pet_combat_skill( skill_id )
	local pet = EntityManager:get_player_pet()
	
	-- 如果宠物没有出战,
	if ( pet == nil ) then
		return;
	end

	-- 如果挂了，就不能放技能了
	if pet:is_dead() then
		return
	end



	-- 如果宠物技能cd中
	if ( pet:get_skill_cd( skill_id ) ~= 0 ) then
		-- print("宠物技能"..skill_id.."cd中....cd = ",pet:get_skill_cd( skill_id ));
		return ;
	end

	-- 当没有目标的时候，去寻找最近的目标
	if pet.target_id == nil or EntityManager:get_entity(pet.target_id) == nil then
		pet.target_id = EntityManager:get_can_attack_entity(pet);
		--print("寻找新的目标")
		if pet.target_id == nil then
			-- 找不到目标
			--print("CommandManager:pet_combat_skill:宠物找不到目标------------------")
			return		
		end
	end
	--print("---------------------------------------宠物施放技能:技能id = ",skill_id);
	
	local target = EntityManager:get_entity(pet.target_id)
	pet:set_target(target)

	-- 当获取技能最大释放距离
	local distance = SkillConfig:get_spell_distance(skill_id, 1)
	-- 有些技能范围是偶数
	-- if ( distance % 2  == 0 ) then
	-- 	distance = distance + 1;
	-- end

	-- 构建动作序列
	local queue  	= {}
	local approach  = ActionApproach{target_id = pet.target_id, distance = distance,entity = pet,target_entity = target}
	if approach:failed() then
		CommandManager:handleApproachFailed(tx,ty)
		return
	end
	local spell 	= ActionPetSpell( skill_id ,pet.target_id,pet);
	table.insert(queue, approach)
	table.insert(queue, spell)
	pet:add_action_queue(queue)
		
end

-- 使用必杀技
function CommandManager:use_bishaji()
--	xprint('CommandManager:use_bishaji')
	print("CommandManager:use_bishaji!!!!!!!!!!!!!!!!!!!!")
	CommandManager:combat_power_skill( UserSkillModel:get_skill_list()[-1] )

	-- local player = EntityManager:get_player_avatar();
	-- local action_id, effect_id = SkillConfig:get_spell_action(bishaji_id, 1);
	-- --print("------------------------------action_id = ",action_id);
	-- player:stop_all_action(  )
	-- player:playAction(action_id, player.dir, false)
	-- -- 播放特效
	-- if ( effect_id ~= 0 ) then
	-- 	local effect_animation_table = effect_config[effect_id];
	-- 	player.model:playEffect( effect_animation_table[1],effect_id, 2, effect_animation_table[3],nil,player.dir,0,500,effect_animation_table[2]);
	-- end
	-- UserSkillCC:request_use_skill(bishaji_id, 0, 0, 0, player.dir);
end

-- 访问本地图内的npc
function CommandManager:ask_npc( target_scene_id,npc_name,content)

	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！ask_npc')
		return
	end

	-- print("CommandManager:ask_npc:::当前要访问的npc为",target_scene_id,npc_name)
	local tile_x,tile_y = SceneConfig:get_npc_pos(target_scene_id,npc_name);
	-- print("tile_x,tile_y = ",tile_x,tile_y);
	-- 构建动作序列

	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x = tile_x, tile_y = tile_y, distance = {2,2}}
		local aciont_ask = ActionAsk(npc_name,content);
		return { approach_static, aciont_ask }
	end

	--针对主线id为5的任务进行特殊处理,需要跳跃传送
	local quest_id, quest_type = AIManager:get_cur_quest_id()
	local player = EntityManager:get_player_avatar()
	local limit_title_y = 73 -- 人物坐标大于这点将不进行跳跃
	if not CommandManager:checkPath(tile_x,tile_y) or (quest_id and (quest_id == 5 or quest_id == 35 or quest_id == 65) and quest_type and quest_type == 1 and player.y < limit_title_y * SceneConfig.LOGIC_TILE_HEIGHT) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
		return
	end

	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())

end

-- 直接访问npc
function CommandManager:ask_target_npc(x,y,npc_name)

	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！ask_target_npc')
		return
	end

	local tile_x,tile_y = SceneManager:pixels_to_tile( x, y );

	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x = tile_x, tile_y = tile_y, distance = {2,2}}
		local aciont_ask = ActionAsk(npc_name,"");
		return { approach_static, aciont_ask }
	end

	if not CommandManager:checkPath(tile_x,tile_y) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
		return
	end

	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())
end

function CommandManager:gather(  target_name,tile_x,tile_y,gatherTime,gatherCount)
	-- print("=====CommandManager:gather(  target_name,tile_x,tile_y,gatherTime,gatherCount): ", target_name, gatherTime, gatherCount)
	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！gather')
		return
	end

	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x = tile_x, tile_y = tile_y, distance = {1,1}}
		local direction = 1;
		if ( gatherCount == nil) then 
			gatherCount = 1
		end
		local action_gather = ActionGather(target_name,tile_x,tile_y,direction,gatherTime,gatherCount);
		return { approach_static, action_gather }
	end


	if not CommandManager:checkPath(tile_x,tile_y) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
		return
	end

	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())
end

-- 采集
function CommandManager:quest_gather( target_scene_id,target_name ,target_id ,gatherTime,gatherCount)

	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！quest_gather')
		return
	end

	local tile_x,tile_y = SceneConfig:get_monster_pos( target_scene_id , target_id );
	CommandManager:gather(  target_name,tile_x,tile_y,gatherTime,gatherCount)
end


-- 普通杀怪。点击怪物后会自动去打怪
function CommandManager:kill_monster( tile_x,tile_y )

	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！kill_monster')
		return
	end

	-- 构建动作序列
	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x = tile_x, tile_y = tile_y, distance = {5,5}}
		return { approach_static }
	end

	
	if not CommandManager:checkPath(tile_x,tile_y) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
		return
	end
	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())

end

-- 任务杀怪。点击怪物后会自动去打怪
function CommandManager:quest_kill_monster( target_scene_id,target_name ,target_id)
	
	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！quest_kill_monster')
		return
	end

	local tile_x,tile_y
	local curSceneId = SceneManager:get_cur_scene()
	if curSceneId == 27 then
		local curQuestId = NewerCampModel:GetCurrentQuest()
		if not curQuestId then
			return
		end
		tile_x,tile_y = NewerCampConfig:get_pos_by_quest_id(curQuestId)
	else
		tile_x,tile_y = SceneConfig:get_monster_pos( target_scene_id , target_id );
	end

	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x= tile_x,tile_y= tile_y, distance = {5,5}}
		local action_guaji = ActionGuaji();
		return { approach_static, action_guaji }
	end
	
	if not CommandManager:checkPath(tile_x,tile_y) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
	end

	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())
end


-- 移动到目标然后挂机打怪 tile_x,格子坐标
function CommandManager:auto_kill_monster( tile_x,tile_y )
	-- 构建动作序列
	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！auto_kill_monster')
		return
	end

	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x= tile_x,tile_y= tile_y, distance = {5,5}}
		local action_guaji = ActionGuaji();
		return { approach_static, action_guaji }
	end
	
	if not CommandManager:checkPath(tile_x,tile_y) then
		CommandManager:handleApproachStaticFailed(tile_x,tile_y,_createActionQueue)
		return
	end

	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())
end

function CommandManager:da_pao_pao( x,y )
	
	local player = EntityManager:get_player_avatar();
	if player:isActionBlocking() then
		print('原子操作中！da_pao_pao')
		return
	end

	function _createActionQueue()
		local approach_static  = ActionApproachStatic{tile_x= x,tile_y= y, distance = {1,1}}
		local action_dapaopao = ActionDaPaoPao();
		return { approach_static,action_dapaopao }
	end
	
	if not CommandManager:checkPath(x,y) then
		CommandManager:handleApproachStaticFailed(x,y,_createActionQueue)
		return
	end

	EntityManager:get_player_avatar():add_action_queue(_createActionQueue())
end


function CommandManager:move2Teleport(tx, ty, need_send_to_server, after_moved_action_cb ,entity)
	--print('>>>>>>>>>>>>',tx,ty)
	local model = entity.model
	local path = SceneManager.sceneFindPath(model.m_x, model.m_y, 
							   		  		tx, ty)
	if path then
		CommandManager:move(tx,ty,need_send_to_server,after_moved_action_cb,entity)
	else
		function _createActionQueue()
			local action0 = ActionMove{tx = tx, ty = ty, need_send_to_server = need_send_to_server,entity = entity}
			if after_moved_action_cb ~= nil then
				local action1 = ActionCallBack(after_moved_action_cb)
				return { action0, action1 }
			else
				return { action0 }
			end
		end
		CommandManager:createTeleportAction(tx,ty,_createActionQueue)
	end
end

function CommandManager:checkPath(tile_x,tile_y,entity)
	if not tile_x or not tile_y then return end
	entity = entity or EntityManager:get_player_avatar()
	local model = entity.model
	local tmx,tmy = SceneManager:tile_to_pixels( tile_x, tile_y )

	return SceneManager.sceneFindPath(model.m_x, model.m_y, 
							   		  tmx, tmy)
end

function CommandManager:handleMoveFailed(tx,ty)
	local curr_scene_id = SceneManager:get_cur_scene();
	-- GlobalFunc:create_screen_notic('无法移动到目标点')
	print('无法移动到目标点')
end

function CommandManager:handleApproachFailed(tx,ty)
	local curr_scene_id = SceneManager:get_cur_scene();
	-- GlobalFunc:create_screen_notic('无法接近目标点')
	print('无法接近目标点')
end

function CommandManager:handleApproachStaticFailed(ttx,tty,actionQueueCreator)
	if not CommandManager:createTeleportAction(ttx,tty,actionQueueCreator) then
		-- GlobalFunc:create_screen_notic('无法寻路到目标点')
		print('无法寻路到目标点')
	end
end

function CommandManager:createTeleportAction(ttx,tty,actionQueueCreator)
	if not ttx or not tty then return end
	local curr_scene_id = SceneManager:get_cur_scene();
	return AIManager:doSameSceneTeleport(curr_scene_id, ttx , tty, actionQueueCreator)
end

function CommandManager:handleActionMoveFailed(tmx,tmy,actionQueueCreator)
	local ttx,tty = SceneManager:pixels_to_tile( tmx, tmy )
	if not CommandManager:createTeleportAction(ttx,tty,actionQueueCreator) then
		-- GlobalFunc:create_screen_notic('无法寻路到目标点')
		print('无法寻路到目标点')
	end
end

	