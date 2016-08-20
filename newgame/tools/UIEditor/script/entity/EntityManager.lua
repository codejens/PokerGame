-- EntityManager.lua
-- created by aXing on 2012-11-15
-- 这是一个管理游戏场景内实体的管理器
-- 例如创建人物，创建和消亡怪物，或者是一些采集物品等
super_class.EntityManager()

-- entity 根节点
local _entity_root = nil

-- 主角的handle
local _player_avatar_handle = 0
-- 主角宠物的handle
local _player_pet_handle = 0;

-- 场景AOI内全部出现的entity数据 { handle = values }
local _entities = {}
local _fuben_quest_npc = {}

--npc的分时加载模型策略
local _setNPCBodyPartsQueueTimer = timer()
local _setNPCBodyPartsQueue= {}

--avatar的分支加载模型策略
local _setAvatarBodyPartsQueueTimer = timer()
local _setAvatarBodyPartsQueue = {}

local _delay_destroy_list = {}
 
local _setNPCTimerInterval = 0.1
local _setAVATARTimerInterval = 0.1
local _enableSetAvatarBodyParts = true
local tsort = table.sort
local tremove = table.remove

-----------------------------------------------------
--[[
	EntityConfig.TYPE_PLAYER_PET = -2
	EntityConfig.TYPE_PLAYER_AVATAR = -1
	EntityConfig.TYPE_AVATAR = 0
	EntityConfig.TYPE_MONSTER = 1
	EntityConfig.TYPE_NPC = 2
	EntityConfig.TYPE_MOVING_NPC = 3
	EntityConfig.TYPE_PET = 4
	EntityConfig.TYPE_PLANT = 8
	EntityConfig.TYPE_TELEPORT = 9
]]
-----------------------------------------------------

local _avatarAndPets = 
{ 
	[EntityConfig.TYPE_PLAYER_PET] = true, 
	[EntityConfig.TYPE_AVATAR] = true, 
	[EntityConfig.TYPE_PET] = true, 
}

local _others = 
{ 
	[EntityConfig.TYPE_PLAYER_PET] = true, 
	[EntityConfig.TYPE_AVATAR] = true, 
	[EntityConfig.TYPE_PET] = true, 
	[EntityConfig.TYPE_NPC] = true, 
	[EntityConfig.TYPE_MONSTER] = true, 
	[EntityConfig.TYPE_PLANT] = true,
	[EntityConfig.TYPE_TELEPORT] = true
}

local _all_entity = 
{
	[EntityConfig.TYPE_PLAYER_PET] = true,
	[EntityConfig.TYPE_PLAYER_AVATAR] = true,
	[EntityConfig.TYPE_AVATAR] = true,
	[EntityConfig.TYPE_MONSTER] = true,
	[EntityConfig.TYPE_NPC] = true,
	[EntityConfig.TYPE_MOVING_NPC] = true,
	[EntityConfig.TYPE_PET] = true,
	[EntityConfig.TYPE_PLANT] = true,
	[EntityConfig.TYPE_TELEPORT] = true,
}

local _entityTypeVisible = {}



local function doSetNPCBodyPartsTick( dt )
	if #_setNPCBodyPartsQueue == 0 then
		_setNPCBodyPartsQueueTimer:stop()
	else
		local _ent = tremove(_setNPCBodyPartsQueue)
		-- print('doSetNPCBodyPartsTick',_ent.name)
		_setNPCBodyPartsQueue[_ent] = nil
		_ent:setBody()
	end
end

local function doSetAVATARBodyPartsTick( dt )
	-- print("#_setAvatarBodyPartsQueue",#_setAvatarBodyPartsQueue);
	if #_setAvatarBodyPartsQueue == 0 then
		_setAvatarBodyPartsQueueTimer:stop()
	else
		local _ent =  _setAvatarBodyPartsQueue[#_setAvatarBodyPartsQueue]
		-- print('doSetAVATARBodyPartsTick',_ent.name)
		if _ent:setBodyQueue() then
			_setAvatarBodyPartsQueue[_ent] = nil;
			tremove(_setAvatarBodyPartsQueue)
		end
	end
end

local shadowTexture = 'nopack/shadow.png'
local fontEffectTexture = UIResourcePath.FileLocate.fontEffect .. "ui_font_effect1.png"

-- 获取AOI内全部的entity对象
function EntityManager:get_entities( )
	return _entities;
end

-- 根据提供的指定群抽出最近的实体
function EntityManager:find_nearest_in_entities(entities)
	local min_distance = 9999999 -- 因为下面distance计算出的值很大，大于65535所以要增加min_distance的值
	local target = nil
	local player = EntityManager:get_player_avatar()
	local sx = player.model.m_x
	local sy = player.model.m_y
	local index = 1
	for i, entity in pairs(entities) do
		-- 当entity为指定entity时
		if entity.hp ~= nil and entity.hp >0   then
			local tx = entity.model.m_x
			local ty = entity.model.m_y
			local dx = tx - sx
			local dy = ty - sy
			local distance = dx * dx + dy * dy
			--print("distance = ",distance);
			if distance ~= 0 and distance < min_distance then
				target 	 = entity
				index = i
				min_distance = distance
			end
		end
	end
	return target, index
end
-- 获取附近可攻击的对象(仇人在前面)
function EntityManager:get_nearest_entities_by_num(max_num)
	local avatar_info = { }
	local avatars = {}
	local player = EntityManager:get_player_avatar()
	-- 首先抽出可攻击玩家
	for i, entity in pairs(_entities) do
		-- 抽出可攻击的其它玩家
		if entity.type == EntityConfig.TYPE_AVATAR then
			if player.name ~= entity.name then
				if player:can_attack_target(entity) then
					table.insert(avatars, entity)
				end
			end
		end
	end
	if #avatars == 0 then return avatars end
	--抽出仇人玩家
	local idx = 1
	while idx <= #avatars do
		if #avatar_info >= max_num then return avatar_info end
		local ent = avatars[idx]
		if FriendModel:is_my_enemy(ent.name) then
			local tab = {avatar = ent, is_enemy = true}
			table.insert(avatar_info, tab)
			table.remove(avatars, idx)
		else
			idx = idx +1
		end
	end
	--抽出最近的几个玩家
	-- idx = 1
	local remain = max_num - #avatar_info
	if remain <= 0 then return end
	for i = 1, remain do
		if #avatars == 0 then return avatar_info end
		local entity, index = EntityManager:find_nearest_in_entities(avatars)
		local tab = {avatar = entity, is_enemy = false}
		table.insert(avatar_info, tab)
		table.remove(avatars, index)
	end
	return avatar_info
end

-- 获得实体
function EntityManager:get_entity( handler )
	return _entities[handler]
end

-- 获得实体handler
function EntityManager:get_handler( name )

	for handler,entity in pairs(_entities) do
		if entity.name == name then
			return handler
		end
		print(entity.name)
	end
	return nil;
end


-- 获得实体
function EntityManager:get_entity_by_name( name )

	for handler,entity in pairs(_entities) do
		if entity.name == name then
			return entity
		end
	end
	return nil;
end

-- 获得实体handler 
-- 查找名字包含给定字符串的实体 
function EntityManager:get_handler_by_sub_name( sub_name )
	for handler,entity in pairs(_entities) do
		if string.find(entity.name,sub_name) then
			return handler
		end
	end
	return nil;
end

-- 根据实体id取得实体
function EntityManager:get_entity_by_id( entity_id )
	for handler,entity in pairs(_entities) do
		if entity.id == entity_id then
			return entity
		end
	end
	return nil;
end

-- entity管理器初始化
function EntityManager:init(root)
	
	if _entity_root ~= nil then
		return
	end

	self.current_transform_id=-1
	self.current_transform_stage=-1

	--ZXEntity:setShadowTextureName(shadowTexture)
	_entity_root = root:getEntityNode()
	root:createShadowNode(shadowTexture)
	ZXEntity:SetDefaultBody("nopack/defaultBody.pd",0.5,0.0)
	ZXEntity:setHighLightDuration(0.75)
	------
	root:createFontEffectNode(fontEffectTexture)

    local function entity_msg_func(eventType,x,y)
		if eventType == CCTOUCHBEGAN then 
			return true
		elseif eventType == CCTOUCHENDED then
			return true
		end
	end
	_entity_root:registerScriptTouchHandler(entity_msg_func, false, 0, false)
	gameticktimer = timer()

	for k,v in pairs(EntityConfig.ENTITY_TYPE) do
		_all_entity[k] = true
		_entityTypeVisible[k] = true
	end
end

--退出游戏了
function EntityManager:OnQuit()
	_entity_root = nil
	_entities = nil
	_fuben_quest_npc = nil
	--清除分时setBody
	EntityManager.clearSetBodyQueues()
end

-- 移除全部的entity
function EntityManager:remove_all_entity(  )
	-- 用于切换账号的时候，需要客户端自己清除数据

	-------------------------------
	-- 清除LOD请求
	--Entity_dataLOD_CC.clearDataLOD()
	EntityManager.clearSetBodyQueues()

	-- 主角的handle
	_player_avatar_handle = 0
	-- 主角宠物的handle
	_player_pet_handle = 0;

	for handler, entity in pairs(_entities) do
		self:destroy_entity(handler)
	end

	_entities = {}
	_fuben_quest_npc = {}

end

-- 获取实体层根节点
function EntityManager:get_entity_root(  )
	return _entity_root
end

-- AOI内创建一个entity
function EntityManager:create_entity( handle, entity_type )
	local new_entity
	if entity_type == "Monster" then
		new_entity = Monster(handle)
	elseif entity_type == "Avatar" then
		new_entity = Avatar(handle)
	elseif entity_type == "Pet" then
		new_entity = Pet(handle)
	elseif entity_type == "NPC" then
		new_entity = NPC(handle)
	elseif entity_type == "MovingNPC" then
		new_entity = NPC(handle)
	elseif entity_type == "PlayerPet" then
		new_entity = PlayerPet(handle)
	elseif entity_type == "XianNv" then
		new_entity = XianNv(handle)
	elseif entity_type == "Plant" then
		new_entity = Plant(handle)
	elseif entity_type == "Collectable" then
		new_entity = Plant(handle)
	elseif entity_type == "PlantEx" then
		new_entity = PlantEx(handle)
	elseif entity_type == "PlayerAvatar" then
		new_entity = PlayerAvatar(handle)
        EntityManager:set_avatar_hide_title( new_entity )
	elseif entity_type == "DropItem" then
		new_entity = DropItem(handle)
	elseif entity_type == "Teleport" then
		new_entity = StaticEntity(handle)
	else
		new_entity = Entity(handle)
	end
	_entities[handle] = new_entity

	return new_entity
end

-- 创建主角
function EntityManager:create_player_avatar( handle )
	_player_avatar_handle	= handle
	return EntityManager:create_entity(handle, "PlayerAvatar")
end

-- 更新主角属性
function EntityManager:change_player_avatar_attri( attri_type, attri_value )
	--print("EntityManager -- 主角的属性发生变化",attri_type, attri_value);
	local entity = EntityManager:get_player_avatar()
	if ( entity ) then
		entity:change_entity_attri(attri_type, attri_value)
		--如果人物属性面板已经创建，就更新数据
--		print("attri_type, attri_value", attri_type, attri_value)
	    local win = UIManager:find_visible_window("user_attr_win")
	    if win then
	        win:update("")
	    end
	    win = UIManager:find_visible_window("user_equip_win")
	    if win then
	        win:update("")
	    end

	    -- 翅膀界面更新声望
	    win = UIManager:find_visible_window("wing_win")
	    if win then
	    	win:update("wing_renown")
	    end

	    -- 如果是技能升级相关的属性改变，刷新技能窗口，检查是否可升级
	    if attri_type == "level" or attri_type == "yinliang" or attri_type == "expL" or attri_type == "expH" then
	        require "UI/userSkillWin/UserSkillWin"
	        UserSkillWin:update_skill_win()
	        UserSkillModel:show_skill_minibut(  )
	    end

	    -- 背包格子和金钱等数发生变化
	    if attri_type == "yuanbao" or attri_type == "bindYuanbao" or attri_type == "yinliang" or attri_type == "bindYinliang" then
	        BagWin:update_bag_win( "player" )
	    end

	    if attri_type == "bagVolumn" then
	        BagWin:update_bag_win( "bagVolumn" )
	    end

	    -- 仓库格子数发生变化
	    if attri_type == "storeVolumn" then
	        require "UI/cangku/CangKuWin"
	        CangKuWin:update_cangku_win( "player" )
	    end

	    --qqvip
	    if attri_type == "QQVIP" then
	    	QQVipInterface:update_panel_for_qqvip_change()
	    	--QQVIPName:update_panel_for_qqvip_change()
	    end
	   
	    if attri_type == "super" then
		    -- 高16：培养阶段 低16：变身ID
			local id 	  = Utils:low_word(attri_value) 		
			local stage   = Utils:high_word(attri_value)
			
			-- 保存变身信息
			self.current_transform_id=id
			self.current_transform_stage=stage

			-- TransformAvatarTitile:reset_title_position_by_level(id)
			ZXLog('---------------变身结果返回id,stage-------------------',id,stage)

			local _transform_info = TransformModel:get_transform_data( )
			if _transform_info then
				_transform_info.current_transform_id=id
				_transform_info.current_transform_stage=stage
			end
			--更新Ui
			TransformModel:update_left_win()
			TransformModel:update_right_win()

		    if entity.model and entity.role_name_panel then
		    	--头部标记设置
				TransformAvatarTitile:reset_title_position(entity.role_name_panel,id)
				--增加变身人物特效
				if id ~=0 then
				 	SpecialSceneEffect:playTransformAnimate(entity)
				end
			end
		    
		end

	end
end
-- 返回主角当前的变身id
function EntityManager:get_curren_transform_id(  )
	return self.current_transform_id
end

-- 返回主角当前变身的阶级
function EntityManager:get_curren_transform_stage()
	return self.current_transform_stage
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
	--debug_hook(true)
	print("is_monster_dead = ", handle);


	UserPanel:is_selected_entity( handle );

	local entity = _entities[handle]
	local ent_name = ""
	if entity ~= nil then
		ent_name = entity.name

		--add by chj @ 2015-4-21 begin(怪物添加感叹号，去除)
		if entity.exclame_icon then
			entity.exclame_icon:removeFromParentAndCleanup(true)
		end
		--add by chj @ 2015-4-21 end

		--add by Shan Lu 2013-11-12 Begin
		--删除LOD请求，如果有的话
		--Entity_dataLOD_CC.removeDataLOD(entity)
		--add by Shan Lu 2013-11-12 End
		EntityManager.removeFromSetBodyQueue(entity)

		if entity.destroyBlood then
			entity:destroyBlood()	--销毁血条
		end
		--熔岩魔死的太快
		if entity.delayKill then
			local cb = callback:new()
			cb:start(1.5, function() entity:destroy() end)
		else
			entity:destroy()
		end

		-- 在彻底销毁entity之前通知微地图
		MiniMapModel:update_entity_point( 0, handle, entity );

		_entities[handle] = nil

		--
	end
	
	-- 如果消失的实体是当前npc对话框的实体，则要关闭npc对话框
	local npc_dialog = UIManager:find_visible_window("npc_dialog")
	if ( npc_dialog) then
		npc_dialog:on_npc_dismiss( handle );
	end

	-- 如果消失的实体是仙女，则要关闭仙女对话框
	if ( ent_name == Lang.activity.husong[2] and UIManager:find_visible_window("hsxn_win") ) then
		UIManager:hide_window("hsxn_win");
	end

end

-- 查找距离主角最近的指定类型的实体
function EntityManager:find_nearest_target(entity_type ,is_check_hp )
	
	local player = _entities[_player_avatar_handle]
	return EntityManager:find_nearest_target_by_entity(entity_type ,is_check_hp , player)
end

-- 查找距离指定实体最近的指定类型的实体
function EntityManager:find_nearest_target_by_entity(entity_type ,is_check_hp , _entity)

	local min_distance = 9999999 -- 因为下面distance计算出的值很大，大于65535所以要增加min_distance的值
	local sx = _entity.model.m_x
	local sy = _entity.model.m_y
	local target_id = nil

	if ( is_check_hp == nil ) then
		is_check_hp = false;
	end

	for handler, entity in pairs(_entities) do
		-- 当entity为指定entity时
		if ( entity.type == entity_type ) then
			if ( not is_check_hp or ( entity.hp ~= nil and entity.hp >0 ) ) then
				local tx = entity.model.m_x
				local ty = entity.model.m_y
				local dx = tx - sx
				local dy = ty - sy
				local distance = dx * dx + dy * dy
				--print("distance = ",distance);
				if distance ~= 0 and distance < min_distance then
					target_id 	 = entity.handle
					min_distance = distance
				end
			end
		end
	end

	return target_id
end

-- 查找距离玩家最近的实体
function EntityManager:find_nearest_entity(  )
	local min_distance = 9999999 -- 因为下面distance计算出的值很大，大于65535所以要增加min_distance的值
	local _entity = EntityManager:get_player_avatar();
	local sx = _entity.model.m_x
	local sy = _entity.model.m_y
	local target_entity = nil

	for handler, entity in pairs(_entities) do
		-- 不能选中主角和主角宠物和别人的宠物
		if ( entity.type ~= -1 and entity.type ~= -2 and entity.type ~= 4) then 
			-- 如果是玩家或怪物，必须先检测能否攻击
			if ( ( entity.type ~= 1 and entity.type ~= 0 and entity.type ~= 4 ) or  _entity:can_attack_target(entity) ) then
				--print("entity.name",entity.name)
				local tx = entity.model.m_x
				local ty = entity.model.m_y
				local dx = tx - sx
				local dy = ty - sy
				local distance = dx * dx + dy * dy
				if distance ~= 0 and distance < min_distance then
					target_entity 	 = entity
					min_distance = distance
				end
			else

			end
		end
	end

	return target_entity
end

-- 查找附近所有的掉落道具
function EntityManager:find_all_drop_item( )
	local dropItem_table = {};
	for handler, entity in pairs(_entities) do
		if ( entity.type == 99 ) then
			dropItem_table[#dropItem_table + 1 ] = handler;
		end
	end
	return dropItem_table;
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
	local player = EntityManager:get_player_avatar();
	
	for handler, entity in pairs(_entities) do
		-- 当entity为指定entity时
		if ( entity.type == 1 or entity.type == 0 ) then
			-- lua 没有continue 坑爹
			local is_continue = true;
			-- 如果目标已经死亡
			if ( ZXLuaUtils:band(entity.state, EntityConfig.ACTOR_STATE_DEATH) > 0 ) then
				--print("目标已经死亡。。。")
				is_continue = false;
			end
			
			-- 如果是玩家,要判断该玩家能否攻击,不能攻击就直接下一次计算
			if ( entity.type == 0 ) then

				if ( player:can_attack_target( entity ) == false) then
					is_continue = false;
				end
			else
				-- 如果是不可攻击的怪
				if ( ZXLuaUtils:band( entity.state ,EntityConfig.ACTOR_STATE_ATTACK_FORBIDEN) > 0 
					-- 阵营战中同阵营的怪不可攻击
					or ( player.camp ~= 0 and entity.camp~=0 and player.camp == entity.camp )  )  then
					is_continue = false;
					--print("目标不能攻击....");
				end
			end

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

-- 是否屏蔽怪物名称
function EntityManager:show_monster_name( if_show )
    for key, entity in pairs(_entities) do
        if EntityConfig:is_monster( entity.type ) and entity.model then
        	entity.name_lab.view:setIsVisible( if_show )
            --entity.model:showName( if_show )
        end
    end
end

-- 根据设置系统，设置是否显示怪物名称
function EntityManager:set_one_monster_show_name( entity )
	if entity == nil then
        return 
	end

	local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.SHOW_MONSTER_NAME )
	if entity and entity.type then
        if EntityConfig:is_monster( entity.type ) and entity.model then
            entity.name_lab.view:setIsVisible( if_show )
            --entity.model:showName( if_show )
        end
	end
end

-- 根据设置系统，设置是否显示玩家称号
function EntityManager:set_avatar_hide_title( avatar )
	local if_hide = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_MY_TITLE )
	avatar:set_if_show_title( not if_hide )
end

-- 根据设置系统，设置玩家是否显示   显示：返回true, 隐藏，返回false
function EntityManager:set_hide_other_player( avatar )
	local if_hide = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_OTHER_PLAYER )
	local if_show = true                     -- 是否显示
	
	if ( avatar.type == -2 or avatar.type == 0 or avatar.type == 4 ) then
		if if_hide and avatar.handle ~= _player_pet_handle then
		    avatar:setModelIsVisible(false);
		    if_show = false
		else
            avatar:setModelIsVisible(true);
		end
	end
	return if_show
end

-- 设置不显示同阵营玩家
function EntityManager:set_hide_same_camp_player( avatar )
	local if_hide_camp = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_SAME_CAMP )
	local if_show = true                     -- 是否显示
	local player = EntityManager:get_player_avatar()
	-- print( "player.handler", player.handler, "avatar.handler", avatar.handler )
	if player and player.camp == avatar.camp and avatar.type ~= -1  then 
        if if_hide_camp then
		    if_show = false
		end
	elseif EntityConfig:is_pet( avatar.type ) then       -- 如果是宠物，要判断主人的阵营
        local master_avatar = EntityManager:get_entity( avatar.master_handle )  -- 主人
	    
	    if if_hide_camp and master_avatar and player.camp == master_avatar.camp and avatar.handle ~= _player_pet_handle then
	    	if_show = false
		end
	end

	-- avatar不等于player才有必要设置
	if avatar ~= player then
		avatar:setModelIsVisible(if_show)
	end
	return if_show
end

-- 根据设置系统显示或隐藏玩家的翅膀，法宝，光环和宠物的光环
function EntityManager:set_fuben_optimize( bool ) 
	print("根据设置系统显示或隐藏玩家的翅膀，法宝，光环和宠物的光环",bool)
  	if bool then
        -- 屏蔽
        for k,v in pairs(_entities) do
            -- 玩家
            if v.type == 0 or v.type == -1 then
                -- 删除光环
                v:remove_guanghuan()
                -- 隐藏翅膀
                v:hide_wing()
                -- 隐藏法宝
                v:hide_fabao()
            -- 宠物
            elseif v.type == 4 or v.type == -2 then
                v:remove_guanghuan()
            end
        end
    else
        -- 显示
        for k,v in pairs(_entities) do
            if v.type == 0 or v.type == -1 then
                -- 显示光环
                v:update_default_body(v.body)
                -- 显示翅膀和法宝
                v:update_wing_and_fabao(v.wing)
           	elseif v.type == 4 or v.type == -2 then
                v:setBody()
            end
        end            
    end
end

-- 玩家显示控制
function EntityManager:set_hide_player( avatar )
	local if_show = EntityManager:set_hide_other_player( avatar ) 
    
    -- 如果“隐藏所有玩家”的判断为可显示，再判断是否同阵营
    if if_show then 
    	if_show = EntityManager:set_hide_same_camp_player( avatar )
    end

end
-- 隐藏怪物
function EntityManager:set_hide_monster( _entity )
	local is_show = JQDH:is_show_monster();
	if ( is_show == false ) then
		_entity:setModelIsVisible(is_show);
	end
end

-- 所有玩家显示控制
function EntityManager:set_hide_all_player(  )
	for handler, entity in pairs(_entities) do
		EntityManager:set_hide_player( entity )
	end
end

function EntityManager:add_fb_quest_npc(handle,ent)
	-- print('EntityManager:add_fb_quest_npc',handle)
	_fuben_quest_npc[handle] = ent
end

function EntityManager:remove_fb_quest_npc(handle)
	-- print('EntityManager:remove_fb_quest_npc',handle)
	_fuben_quest_npc[handle] = nil
end

function EntityManager:update_fb_npc(fbid)
    local ent = _fuben_quest_npc[fbid]
    if ent then
        ent:update_fb_quest_state()
    end
	return;
end


function EntityManager:update_all_fb_npc()
	for i,ent in pairs(_fuben_quest_npc) do
		--print('update_fb_npc',ent.npc_name)
		ent:update_fb_quest_state()
	end
end

function EntityManager:initLODReq()
	self.LODReqTimer = timer()
end

function EntityManager.setNPCBody(entity)

	if not _setNPCBodyPartsQueue[entity]  then
		_setNPCBodyPartsQueue[entity] = true
		_setNPCBodyPartsQueue[#_setNPCBodyPartsQueue+1] = entity
	end

	if _setNPCBodyPartsQueueTimer:isIdle() then
		_setNPCBodyPartsQueueTimer:start(_setNPCTimerInterval,doSetNPCBodyPartsTick)
	end
	
	local player = EntityManager:get_player_avatar()
	entity._dst = 0
	if player then
		local pm = player.model
		local em = entity.model
		local sx = pm.m_x
		local sy = pm.m_y
		local tx = em.m_x
		local ty = em.m_y
		local dx = tx - sx
		local dy = ty - sy
		entity._dst = dx * dx + dy * dy
		tsort(_setNPCBodyPartsQueue,function (a,b) return a._dst > b._dst end)
	end
end

--avatar的分支加载模型策略
function EntityManager.setAvatarBody(entity)
	-- print("setAvatarBody",entity.name);
	if not _setAvatarBodyPartsQueue[entity]  then
		_setAvatarBodyPartsQueue[entity] = true
		_setAvatarBodyPartsQueue[#_setAvatarBodyPartsQueue+1] = entity
	end

	if _setAvatarBodyPartsQueueTimer:isIdle() and _enableSetAvatarBodyParts then
		_setAvatarBodyPartsQueueTimer:start(_setAVATARTimerInterval,doSetAVATARBodyPartsTick)
	end
	
	local player = EntityManager:get_player_avatar()
	entity._dst = 0
	if player then
		local pm = player.model
		local em = entity.model
		local sx = pm.m_x
		local sy = pm.m_y
		local tx = em.m_x
		local ty = em.m_y
		local dx = tx - sx
		local dy = ty - sy
		entity._dst = dx * dx + dy * dy
		tsort(_setAvatarBodyPartsQueue,function (a,b) return a._dst > b._dst end)
	end
end


function EntityManager.removeFromSetBodyQueue(entity)
	if entity.type == EntityConfig.TYPE_PLAYER_AVATAR then
		print('Error EntityManager.removeFromSetBodyQueue entity is Player')
		return

	elseif entity.type == EntityConfig.TYPE_AVATAR then
		
		for i,v in ipairs(_setAvatarBodyPartsQueue) do
			if v == entity then
				tremove(_setAvatarBodyPartsQueue,i)
				_setAvatarBodyPartsQueue[entity] = nil
				print('EntityManager.removeFromSetBodyQueue remove avatar',entity.name)
				return
			end
		end
	else
		
		for i,v in ipairs(_setNPCBodyPartsQueue) do
			if v == entity then
				tremove(_setNPCBodyPartsQueue,i)
				_setNPCBodyPartsQueue[entity] = nil
				print('EntityManager.removeFromSetBodyQueue remove entity',entity.name)
				return
			end
		end
	end
end

function EntityManager.clearSetBodyQueues()
	_enableSetAvatarBodyParts = true

	_setNPCBodyPartsQueue = {}
	_setNPCBodyPartsQueueTimer:stop()

 	_setAvatarBodyPartsQueueTimer:stop()
 	_setAvatarBodyPartsQueue = {}
end


-- 找远近
function EntityManager:sort_entities_by_distance(entity_type, _centerEntity)

	_centerEntity = _centerEntity or EntityManager:get_player_avatar();

	local min_distance = 9999999 -- 因为下面distance计算出的值很大，大于65535所以要增加min_distance的值
	local sx = _centerEntity.model.m_x
	local sy = _centerEntity.model.m_y
	local target_id = nil
	local entTable = {}
	

	for handler, entity in pairs(_entities) do

		if ( entity.type == entity_type ) then
			local tx = entity.model.m_x
			local ty = entity.model.m_y
			local dx = tx - sx
			local dy = ty - sy
			local distance = dx * dx + dy * dy
			entTable[#entTable+1] = entity
			entity.__dst1 = distance
		end
	end

	tsort(entTable,function (a,b) return a.__dst1 < b.__dst1 end)
	--for i,v in ipairs(entTable) do
	--	print(v.name,v.__dst1)
	--end
	return entTable
end


local function doEntityStruck(ahandle, thandle)
	local attacker = _entities[ahandle]
	local target  = _entities[thandle]
	if attacker and target then
		local player = EntityManager:get_player_avatar()
		--如果是玩家攻击的才受击
		if attacker.handle ~= player.handle then
			return
		end
		target:doStruck(attacker)
	end
end

function EntityManager:setEntityStruck(event,attacker_handle, target_handle)
	print("xxx0")
	for k,v in ipairs(event) do
		print("xxx1")
		callback:new():start(v, bind(doEntityStruck,attacker_handle,target_handle))
	end
	--print('>>>>', handle)
end

function EntityManager:doEntityStruck(entity, attacker)
	print("xxx2")
	entity:doStruck(attacker)
end



------------------------------------------------------------------------------------
-- 新手指引的需求，隐藏所有怪物
function EntityManager:hide_all_monster()
	local _type = EntityConfig.TYPE_MONSTER
	_entityTypeVisible[_type] = false

	for handler, entity in pairs(_entities) do
		--print("entity.type = ",entity.type);
		if ( entity.type == _type ) then
			entity:setModelIsVisible(false);
		end
	end
end

-- 显示所有怪物
function EntityManager:show_all_monster()
	local _type = EntityConfig.TYPE_MONSTER
	_entityTypeVisible[_type] = true

	for handler, entity in pairs(_entities) do
		if ( entity.type == _type ) then
			entity:setModelIsVisible(true);
		end
	end
end

-- 隐藏掉所有的其他玩家和宠物
function EntityManager:hide_all_player_and_pet(  )
	-- print('EntityManager:hide_all_player_and_pet()')
	for k,v in pairs(_avatarAndPets) do
		_entityTypeVisible[k] = false
	end

	for handler, entity in pairs(_entities) do
		if _avatarAndPets[entity.type] then
			if entity.handle ~= _player_pet_handle then 
			    entity:setModelIsVisible(false);
			end
		end
	end
end

-- 显示所有的其他玩家和宠物
function EntityManager:show_all_player_and_pet(  )
	-- print('EntityManager:show_all_player_and_pet()')
	for k,v in pairs(_avatarAndPets) do
		_entityTypeVisible[k] = true
	end

	for handler, entity in pairs(_entities) do
		if _avatarAndPets[entity.type] then
			entity:setIsVisible(true);
		end
	end
end

-- 隐藏掉所有的其他玩家和宠物,NPC,怪物，传送点，采集
function EntityManager:hide_others(  )
	for k,v in pairs(_others) do
		_entityTypeVisible[k] = false
	end

	for handler, entity in pairs(_entities) do
		if _others[entity.type] then
			if entity.handle ~= _player_pet_handle then 
			    entity:setIsVisible(false);
			end
		end
	end
end

-- 隐藏掉所有的其他玩家和宠物,NPC,怪物，传送点，采集
function EntityManager:show_others(  )
	for k,v in pairs(_others) do
		_entityTypeVisible[k] = true
	end

	-- print('EntityManager:show_all_player_and_pet()')
	for handler, entity in pairs(_entities) do
		local _type = entity.type
		if _others[_type] then
			entity:setIsVisible(true);
		end
	end
end

-- 隐藏掉所有的其他玩家和宠物
function EntityManager:hide_all(  )
	for k,v in pairs(_all_entity) do
		_entityTypeVisible[k] = false
	end

	for handler, entity in pairs(_entities) do
		entity:setIsVisible(false);
	end
end

-- 显示所有的其他玩家和宠物
function EntityManager:show_all(  )
	for k,v in pairs(_all_entity) do
		_entityTypeVisible[k] = true
	end

	for handler, entity in pairs(_entities) do
		entity:setIsVisible(true);
	end
end

--恢复entity显示到系统默认设
function EntityManager:restore_show_entity()
	EntityManager:show_all()
	EntityManager:set_hide_all_player()
end

--剧情动画接口检查是新的entity是否需要显示
function EntityManager:should_new_entity_visible(entity)
	if _entityTypeVisible[entity.type] then
		entity:setIsVisible(true);
	else
		entity:setIsVisible(false);
	end
end

-- 玩家从新手体验副本中出来的时候,恢复entity显示到系统默认设
function EntityManager:restore_show_entity_from_newercamp()
	local if_hide = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_OTHER_PLAYER )
	local if_hide_camp = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_SAME_CAMP )
	local player  = EntityManager:get_player_avatar()
	
	-- 第一步,解除优先级锁定,设置所有玩家都可见
	for handler, entity in pairs(_entities) do
		if entity.type == 0 then
			entity:setIsVisible(true, 256)
			entity:setOperationPriority(0)
		end
	end

	-- 第二步,根据当前的系统设置,设置玩家是否可见
	for handler, entity in pairs(_entities) do
		if entity.type == 0 then
			if if_hide then
				entity:setModelIsVisible(false)
			else
				if player and player.camp == entity.camp then
					if if_hide_camp then
						entity:setModelIsVisible(false)
					end
				end
			end
		end
	end
end

-- 建立延迟销毁列表进行记录延迟销毁行为，防止延迟销毁过程中进行实体创建出错。 
function EntityManager:insert_to_delay_destroy_list(t_handle)
	_delay_destroy_list[t_handle] = 1
end

function EntityManager:remove_to_delay_destroy_list(t_handle)
	if _delay_destroy_list[t_handle] == 1 then
		_delay_destroy_list[t_handle] = nil
		EntityManager:destroy_entity(t_handle)
	end
end