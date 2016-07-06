-- AIManager.lua
-- created by tjh on 2015-5-21
-- 主角AI管理器

AIManager = {}



AIManager.COMMAND_IDLE = 0;			-- 空闲
AIManager.COMMAND_MOVE = 1;			-- 移动命令
AIManager.COMMAND_ASK_NPC = 2;		-- 访问NPC
AIManager.COMMAND_KILL_MONSTER = 3;	-- 杀怪
--AIManager.COMMAND_GATHER = 4;		-- 采集
AIManager.COMMAND_GUAJI = 5;		-- 挂机
AIManager.COMMAND_FUBEN_GUAJI = 6;	-- 副本挂机
--AIManager.COMMAND_ENTER_SCENE = 7;	-- 切换场景
AIManager.COMMAND_DO_QUEST = 8;		-- 执行任务
--AIManager.COMMAND_ENTER_FUBEN = 10;	-- 切换副本
AIManager.COMMAND_FOLLOW = 11;		-- 跟随其他玩家
AIManager.COMMAND_AUTO_GATHER = 12;	-- 挂机采集

--当前状态
local _ai_type = AIManager.COMMAND_IDLE

--当前AI信息
local _ai_info = {
	scene_id = nil,--场景ID
	fuben_id = nil,--副本id
	param = {},--参数
}


--玩家
local _player = nil

---------------------------------------每种AI对应的处理函数--------------
--杀一只怪AI
local function ai_kill_one_monster(  )

	-- 如果玩家当前的目标已经死亡，则停止动作
	if ( _player.target_id == nil ) then
		AIManager:set_ai_type( AIManager.COMMAND_IDLE )
	-- 没死就接着放技能
	else
		-- 施放技能
		CommandManager:combat_skill()
	end

end

--访问npc AI
local function ai_ask_npc(  )
	local tx = 0
	local ty = 0
	local npc_name = _ai_info.param[1]
	if _ai_info.scene_id then
		tx,ty = SceneConfig:get_npc_pos(_ai_info.scene_id,npc_name);
	else
		tx,ty = SceneManager:pixels_to_tile(  _ai_info.param[2], _ai_info.param[3] );
	end
	CommandManager:ask_npc( tx,ty,npc_name)
	AIManager:set_ai_type(AIManager.COMMAND_IDLE)
end

--挂机AI
local function ai_guaji( )
	--如果没有目标找一个
	if  not player.target_id then
	
		local target_id = EntityManager:get_can_attack_entity(player);
		if target_id == nil then
			-- 找不到目标
			return 
		end
		local target_entity = EntityManager:get_entity( target_id );
		player:set_target(target_entity)
	end

	-- 施放技能
	CommandManager:combat_skill()

end

--副本挂机AI
local function ai_fuben_guaji(  )
	--如果没有目标选择目标
	if  not _player.target_id  then
		local entity_handle = EntityManager:get_can_attack_entity(_player)
		if entity_handle then
			local target_entity = EntityManager:get_entity( entity_handle );
			player:set_target(target_entity)
		end
	end
	--有目标直接用技能打
	if _player.target_id then
		CommandManager:combat_skill(  )
	else
		--lp todo 找到传送点

	end
end


-- 跟随玩家AI
local function ai_follow(  )

	local handle = __ai_info.param[1]
	local follow_entity = EntityManager:get_entity( handle )
	if  follow_entity then
		local x,y = follow_entity:get_map_position()
		-- 跟随
		CommandManager:move( _palyer, x, y);
	end
end

--自动采集
local function ai_auto_gather( )
	local entity = EntityManager:find_nearest_target( 12 ,false )
	if  entity  then
		--lp todo
	end
end
---------------------------------------------------------------------------------

--每个ai类型对应的处理函数
local _ai_type_func = {
	--[AIManager.COMMAND_MOVE] = "ai_move",
	[AIManager.COMMAND_ASK_NPC] = ai_ask_npc,
	[AIManager.COMMAND_KILL_MONSTER] = ai_kill_one_monster,
	--[AIManager.COMMAND_GATHER] = "ai_gather",
	[AIManager.COMMAND_GUAJI] = ai_guaji,
	[AIManager.COMMAND_FUBEN_GUAJI] = ai_fuben_guaji,
	--[AIManager.COMMAND_DO_QUEST] = "ai_do_quest",
	[AIManager.COMMAND_FOLLOW] = ai_follow,
	[AIManager.COMMAND_AUTO_GATHER] = ai_auto_gather,

}


local doing_quest = nil;



--初始化数据
function AIManager:init()
	AIManager:clear_ai_info( )
	_player = EntityManager:get_player_avatar()
end

--清除数据
function AIManager:fini( ... )

	AIManager:clear_ai_info( )

	_player = nil
end

--清除ai
function AIManager:clear_ai_info( )
	_ai_type = AIManager.COMMAND_IDLE--ai类型
	AIManager:clear_ai_date()
end

--清除ai数据
function AIManager:clear_ai_date( ... )
	_ai_info = {
		scene_id = nil,--场景ID
		fuben_id = nil,--副本id
		param = {},--参数
	}
end


--设置ai类型
--@param ai_type ai类型
--@param ai_info ai数据 默认nil
function AIManager:set_ai_type( ai_type ,ai_info )
	_ai_type = ai_type
	if ai_info then
		_ai_info = ai_info
	else
		AIManager:clear_ai_date()
	end
end

function AIManager:get_ai_type()
	return _ai_type
end


-- 当主角没有动作的时候 执行AI 每帧都执行
function AIManager:do_ai()
	-- 如果当前AIManager的状态时空闲，直接返回
	if _ai_type == AIManager.COMMAND_IDLE then
		return
	else
		--如果有指定场景
		if _ai_info.scene_id then
			--判断是否到达指定场景
			if AIManager:is_on_target_scene() then
				_ai_type_func[_ai_type]()
			end
		--如果有指定副本
		elseif _ai_info.fuben_id then
			--lp todo
		else
			_ai_type_func[_ai_type]()	
		end
		
	end
end

--判断是否到达指定场景 如果没有 移动
function AIManager:is_on_target_scene(  )
	local curr_scene_id = SceneManager:get_cur_scene();
	--首先判断是否到达目标场景，如果没有则计算出到达目标场景的最短路径，然后移动
	if curr_scene_id ~=  _ai_info.scene_id then
		local tx,ty = SceneManager:get_nearest_position( curr_scene_id , _ai_info.scene_id ) 
		local pos_x,pos_y =SceneManager:pixels_to_tile( tx, ty )
		-- 移动
		CommandManager:move( _player ,pos_x, pos_y)
		return false
	end
	return true
end


function AIManager:on_selected_entity(old_entity,entity,can_attack_target)

	-- 如果当前在挂机，直接返回
	if ( _ai_type == AIManager.COMMAND_FUBEN_GUAJI or 
		_ai_type == AIManager.COMMAND_GUAJI ) then
		return
	end

	-- 如果玩家点击的是同一只实体并且当前有不可打断的动作
	if ( old_entity and old_entity.handle == entity.handle 
		and _player:is_can_break_action() == false ) then
		return
	end

	-- -- 杀怪
	if entity.type == EntityConfig.TYPE_MONSTER   then
		-- 如果能够攻击目标
		if can_attack_target  then 
			--CommandManager:combat_skill( )
			AIManager:set_ai_type( AIManager.COMMAND_KILL_MONSTER )
		end

	-- 访问npc
	elseif ( entity.type == EntityConfig.TYPE_NPC ) then
		--清空挂机数据
		AIManager:clear_ai_date()
		--准备挂机数据
		_ai_info.param[1] = entity.name
		_ai_info.param[2],_ai_info.param[3] = entity:get_map_position()

		AIManager:set_ai_type( AIManager.COMMAND_ASK_NPC,_ai_info )
		
	-- 采集
	--elseif ( entity.type == 12 ) then

	elseif ( entity.type ==  EntityConfig.TYPE_AVATAR  ) then
		AIManager:select_avator(entity)

	-- 如果是传送门
	elseif ( entity.type ==  EntityConfig.TYPE_TELEPORT ) then
		local player = EntityManager:get_player_avatar();
		CommandManager:move( entity.model.m_x,entity.model.m_y ,true,nil,player);
	end

end

--选中玩家
function AIManager:select_avator( entity )
	-- local player = EntityManager:get_player_avatar();
	-- -- 如果是在瑶池仙泉中
	-- if ( XianYuModel:get_status(  ) ) then
	-- 	-- 移动到目标的前面一格
	-- 	local player = EntityManager:get_player_avatar();
	-- 	local target_x = entity.model.m_x;
	-- 	local target_y = entity.model.m_y;
	-- 	local _x = target_x - player.x;
	-- 	local _y = target_y - player.y;
	-- 	local distance = math.sqrt( _x * _x + _y * _y );
	-- 	if ( distance > 1 ) then 
	-- 		if ( player.x > entity.model.m_x ) then
	-- 			target_x = target_x + 10
	-- 		else
	-- 			target_x = target_x - 10
	-- 		end
	-- 	end
	-- 	--print("target_x,target_y = ",target_x,target_y,player.x,player.y)
	-- 	CommandManager:move(target_x,target_y,true,nil,player);
	-- elseif ( can_attack_target ) then
	-- 	local skill = AIManager:get_can_use_skill()
	-- 	if ( skill ) then 
	-- 		CommandManager:combat_skill( skill ,EntityManager:get_player_avatar())
	-- 	end
	-- 	AIManager:set_state( AIManager.COMMAND_KILL_MONSTER );
	-- end
end