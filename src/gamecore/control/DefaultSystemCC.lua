--DefaultSystemCC.lua
--create by tjh on 2015-05-04
--默认系统逻辑处理

DefaultSystemCC = {}


--初始化
function DefaultSystemCC:init( ... )
	-- body
	DefaultSystemCC:regist_protocol(  )
end

function DefaultSystemCC:finish( ... )
	-- body
end

--0-2协议接收 创建其他实体
local function do_create_other_entity( entity_attri )
	EntityLogicCC:create_other_entity_avatar( entity_attri )
end 

--0-3协议接收 创建主角
local function do_create_player_avatar(  handle, leng, attribute, name, is_win )
	local player_info = {}
	player_info.handle = handle
	player_info.leng = leng
	player_info.attribute = attribute
	player_info.name = name
	player_info.is_win = is_win
	DefaultSystemModel:set_player_info( player_info )

	EntityLogicCC:do_create_player_avatar()
end

--创建其他玩家
local function do_create_other_player_avatar( ... )
	local arg = {...}
	EntityLogicCC:create_other_player_avatar(arg)
end 
--0-13协议接收 进入场景
local function do_enter_scene( fb_id, scene_id, x, y, keep_walking, scene_name, map_name, chengzhu_name )
	map_name = string.lower(map_name);
	SceneManager:enter_scene(fb_id, scene_id, x, y, keep_walking, scene_name, map_name)
end 

-- 0-5协议接收实体消失
local function do_destroy_entity( handle )
	EntityLogicCC:do_destroy_entity(handle)
end

-- 主角属性改变
local function do_player_avatar_attribute_changed( count,date_t )
	for i=1,count do

	end
end

-- 实体属性改变
local function do_entity_attribute_changed( handle,count,date_t )
	for i=1,count do

	end
end

-- 实体名字改变
local function do_entity_show_name_changed( handle,name_str )

end

-- 其他实体停止移动(包括主角，令实体停止所有的动作)
local function do_entity_stop_moved( handle,target_x,target_y )

	local entity 	= EntityManager:get_entity(handle)
	if entity ~= nil then
		-- 坐标同步
		entity:change_entity_attri("x", target_x)
		entity:change_entity_attri("y", target_y)

		-- -- 如果目标是玩家并且是在打坐中则不需要stop_move
		-- if ( entity.type == -1 or entity.type == 0 ) then
		-- 	if ( ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0 or ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0  ) then
		-- 		return;
		-- 	end
		-- end
	end
end

-- 其他实体的移动
local function do_entity_moved( handle, cur_x, cur_y,  target_x, target_y )

	local entity 	= EntityManager:get_entity(handle)
	if entity ~= nil then
		entity:start_move(target_x/4*3,target_y/4*3)
	end
end

-- 其他实体使用技能
local function do_entity_use_skill( handle,skill_id,level,dir)

	local entity 	= EntityManager:get_entity(handle)
	if entity ~= nil then
		entity:use_skill(skill_id )
	end
end

--给目标添加特效
local function do_target_add_effect( handle,target_handle,effect_type,effect_id,time )

	local entity = EntityManager:get_entity(handle)
	EffectManage:play_effect( entity.root,effect_id,false )
end

--给场景添加特效
local function do_scene_add_effect( handle ,effect_type,effect_id,x,y,time )

	print(handle ,effect_type,effect_id,x,y,time)
end

--服务端打开客户端窗口
local function do_open_win( win_id,flag,param )
	print("do_open_win",win_id,flag,param)
end 



--注册协议处理
function DefaultSystemCC:regist_protocol(  )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_2, do_create_other_entity )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_3, do_create_player_avatar )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_4, do_create_other_player_avatar )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_5, do_destroy_entity )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_6, do_entity_attribute_changed )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_7, do_player_avatar_attribute_changed )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_8, do_entity_stop_moved )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_9, do_entity_moved )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_12,do_open_win )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_13,do_enter_scene )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_18,do_entity_use_skill )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_19,do_target_add_effect )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_32,do_scene_add_effect )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_40, do_entity_show_name_changed )
end



