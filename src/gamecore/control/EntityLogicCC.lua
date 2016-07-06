--EntityLogicCC.lua
--create by tgh on 2015-05-04
--0号协议实体相关逻辑处理

EntityLogicCC = {}

function EntityLogicCC:init( ... )
	-- body
end

function EntityLogicCC:finish( ... )
	-- body
end

--创建主角
function EntityLogicCC:do_create_player_avatar(  )
	
	local player_info = DefaultSystemModel:get_player_info(  )
	local attribute = player_info.attribute

	local player = EntityManager:create_player_avatar(player_info.handle)

	player:change_entity_attri("type", EntityConfig.TYPE_PLAYER_AVATAR)				-- 实体类型
	player:load_body(attribute.body)

    scene.XLogicScene:sharedScene():getEntityNode():addChild( player.root )


	for k,v in pairs(attribute) do
		if k ~= "body" then --身体先加载好了 不好保证改变数据的顺序
			player:change_entity_attri(k, v)
		end
	end
	
	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个	
	print("player_info.name",player_info.name)
	local name_table = Utils:Split(player_info.name, "\\");
	local show_name = name_table[1];  

	local player_name = show_name
	player:change_entity_attri("name", show_name)

	--主角完成创建
	player:do_finish_create()


end

function EntityLogicCC:create_other_entity_avatar( entity_attri )
	
	if not entity_attri.date then
		return
	end
	-- 只有宠物才有的属性
	if entity_attri.is_pet  then
		local player_avatar = EntityManager:get_player_avatar()
		-- ★潜规则：-2 表示主玩家的宠物
		if entity_attri.master_handle ~= nil and player_avatar ~= nil and (player_avatar.handle == entity_attri.master_handle )  then
			-- EntityManager保存宠物handle;
			EntityManager:set_player_pet( entity_attri.entity_handle );	
		end
	end
		-- 通知引擎创建实体
	print("创建其他实体", EntityConfig.ENTITY_TYPE[entity_attri.entity_type], entity_attri.x, entity_attri.y, 
		", name:", entity_attri.name, ", handle:", entity_attri.entity_handle,"hp:",entity_attri.hp)
	

	-- 到现在才能确认类型，并创建entity和赋值属性
	local new_entity	= nil;
	-- 封神台的宠物以及护送仙女里面的仙女都是Monster，但他们的名字后面都会跟着玩家的名字
	local player_avatar = EntityManager:get_player_avatar()

	new_entity = EntityManager:create_entity(entity_attri.entity_handle, EntityConfig.ENTITY_TYPE[entity_attri.entity_type])
	new_entity:change_entity_attri("type",entity_attri.entity_type)

	scene.XLogicScene:sharedScene():getEntityNode():addChild( new_entity.root )

	--先创建身体
	new_entity:change_entity_attri("body", entity_attri.body)	
	for k,v in pairs(entity_attri.attris) do
		new_entity:change_entity_attri(k, v)	
	end

end

function EntityLogicCC:create_other_player_avatar( date_t )

end

function EntityLogicCC:do_destroy_entity( handle )

	EntityManager:destroy_entity(handle)
	
end