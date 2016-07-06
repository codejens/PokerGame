-- EntityManager.lua
-- created by tjh on 2015-5-21
-- 这是一个管理游戏场景内实体的管理器
-- 例如创建人物，创建和消亡怪物，或者是一些采集物品等
EntityManager = {}

-- entity 根节点
local _entity_root = nil

-- 主角的handle
local _player_avatar_handle = 0
-- 主角宠物的handle
local _player_pet_handle = 0;

-- 场景AOI内全部出现的entity数据 { handle = values }
local _entities = {}


-- 获得实体
function EntityManager:get_entity( handler )
	return _entities[handler]
end

-- entity管理器初始化
function EntityManager:init()
	
	if _entity_root ~= nil then
		return
	end

	_entity_root = scene.XLogicScene:sharedScene():getEntityNode()

	-- 地图事件，用entity管理器来处理。 来决定玩家的移动
    local function map_click( event_data )
    	EntityManager:do_map_click( event_data )
    end
    SceneManager:register_map_event( map_click, SceneManager.MAP_EVENT_CLICK )
end

-- 地图点击事件处理
function EntityManager:do_map_click( event_data )
	local player = EntityManager:get_player_avatar()
	CommandManager:move( player,event_data.x, event_data.y )
	print("地图点击事件处理EntityManager:do_map_click(")
end

--退出游戏了
function EntityManager:OnQuit()
	_entity_root = nil
	_entities = nil
end

-- 移除全部的entity
function EntityManager:remove_all_entity(  )
	-- 主角的handle
	_player_avatar_handle = 0
	-- 主角宠物的handle
	_player_pet_handle = 0;

	for handler, entity in pairs(_entities) do
		self:destroy_entity(handler)
	end
	_entities = {}
end


-- AOI内创建一个entity
function EntityManager:create_entity( handle, entity_type )
	print("create_entity")
	local class = _G[entity_type]
	local new_entity = class(handle)
	_entities[handle] = new_entity
	return new_entity
end

-- 创建主角
function EntityManager:create_player_avatar( handle )
	print("create_player_avatar")
	_player_avatar_handle	= handle
	return EntityManager:create_entity(handle, "PlayerAvatar")
end


-- 返回主角entity
function EntityManager:get_player_avatar(  )
	return _entities[_player_avatar_handle]
end

function EntityManager:get_player_avatar_handle()
	return _player_avatar_handle
end

-- 设置主角宠物的entity
function EntityManager:set_player_pet( pet_handle )
	_player_pet_handle = pet_handle;
end

-- 取得主角宠物的entity
function EntityManager:get_player_pet()
	return _entities[_player_pet_handle];
end

-- 更新实体属性
function EntityManager:change_entity_attri( handle, attri_type, attri_value )
	local entity = _entities[handle]
	if entity ~= nil then
		entity:change_entity_attri(attri_type, attri_value)
	end
end

-- 实体消失
function EntityManager:destroy_entity( handle)
	local entity = _entities[handle]

	--通知主角
	local palyer = EntityManager:get_entity(_player_avatar_handle)
	palyer:other_destroy(handle)

	if entity ~= nil then
		entity:destroy()
		_entities[handle] = nil
	end


	-- lp todo 某些特殊实体消失要做特殊处理
end


-- 查找距离指定实体最近的指定类型的实体
-- @param entity_type 实体类型
function EntityManager:find_nearest_target(entity_type )

	local min_distance = 9999999 -- 因为下面distance计算出的值很大，大于65535所以要增加min_distance的值
	local player = _entities[_player_avatar_handle]
	local sx,sy = player:get_map_position()
	local target = nil

	local tx = 0
	local ty = 0
	local dx = 0
	local dy = 0
	local distance = 0

	for handler, entity in pairs(_entities) do

		if entity.type == entity_type then
			if  entity.hp ~= nil and entity.hp >0  then
				tx,ty = entity:get_map_position()
				dx = tx - sx
				dy = ty - sy
				distance = dx * dx + dy * dy
				if distance < min_distance and handler ~= _player_avatar_handle then
					target 	= entity
					min_distance = distance
				end
			end
		end
	end

	return target
end


-- 查找附近所有的掉落道具
function EntityManager:find_all_drop_item( )
	local dropItem_table = {};
	for handler, entity in pairs(_entities) do
		-- lp todo const 
		if ( entity.type == 99 ) then
			dropItem_table[#dropItem_table + 1 ] = handler;
		end
	end
	return dropItem_table;
end

-- 新手指引的需求，隐藏所有怪物
function EntityManager:hide_all_monster()
	for handler, entity in pairs(_entities) do
		if ( entity.type == 1 ) then
			entity.model:setIsVisible(false);
		end
	end
end
-- 显示所有怪物
function EntityManager:show_all_monster()
	for handler, entity in pairs(_entities) do
		-- lp todo const
		if ( entity.type == 1 ) then
			entity.model:setIsVisible(true);
		end
	end
end

-- 隐藏掉所有的其他玩家和宠物
function EntityManager:hide_all_player_and_pet(  )
	for handler, entity in pairs(_entities) do
		-- lp todo const
		if ( entity.type == -2 or entity.type == 0 or entity.type == 4 ) then
			if entity.handle ~= _player_pet_handle then 
			    entity.model:setIsVisible(false);
			end
		end
	end
end

-- 显示所有的其他玩家和宠物
function EntityManager:show_all_player_and_pet(  )
	for handler, entity in pairs(_entities) do
		-- lp todo const
		if ( entity.type == -2 or entity.type == 0 or entity.type == 4 ) then
			entity.model:setIsVisible(true);
		end
	end
end

-- 更新npc状态
function EntityManager:change_npc_state( npc_handle,npc_state )
	for handler, entity in pairs(_entities) do
		if ( handler == npc_handle) then
			entity:change_quest_state( npc_state );
			return;
		end
	end
end

-- 取得附近一个可以攻击的目标
function EntityManager:get_can_attack_entity( _entity )
	local min_distance = 9999999 -- 因为下面distance计算出的值很大，大于65535所以要增加min_distance的值
	local sx = _entity.x
	local sy = _entity.y
	local target_id = nil
	
	for handler, entity in pairs(_entities) do
		-- 当entity为指定entity时
		if EntityManager:can_attack_entity(entity) then

			if ( is_continue ) then 
				local tx = entity.model.m_x
				local ty = entity.model.m_y
				local dx = tx - sx
				local dy = ty - sy
				local distance = dx * dx + dy * dy
				
				if distance ~= 0 and distance < min_distance then
					target_id 	 = entity.handle
					min_distance = distance
				end
			end
		end
	end

	return target_id
end

--判断是否是主角可以攻击的目标
function EntityManager:can_attack_entity( target )
	--不是玩家，怪物直接返回
	if target.type ~= EntityConfig.TYPE_AVATAR and target.type ~= EntityConfig.TYPE_MONSTER then
		return false
	end 
	--lp todo
	--阵营判断 各种
	return true
end
--- 获取主角某个属性 genuine
-- @param attr_name 属性名称
function EntityManager:get_player_avatar_attr( attr_name )
	local player_avatar = EntityManager:get_player_avatar() or {}
	local attr_value = player_avatar[ attr_name ] or ""
	return attr_value
end

-- 获得实体handler
function EntityManager:get_handler( name )

	for handler,entity in pairs(_entities) do
		if entity.name == name then
			return handler
		end
	end
	return nil;
end