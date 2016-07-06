--GameLogicModel.lua
--默认系统 0号协议处理
GameLogicModel = {}

function GameLogicModel:create_player_avatar( handle,player_id,attris,show_name )

	print(show_name)
	local player = EntityManager:create_player_avatar(handle)
	--local player = EntityManager:get_player_avatar(  )
   -- player:init_model()
    scene.XLogicScene:sharedScene():getEntityNode():addChild( player.model.model_root )
    player:get_on_riding()

    --绑定摇杆
    require "test.test_Joystick"
    local joystick =  test_Joystick:getInstance()
    joystick:set_player(player)
    --绑定摄像机
    SceneCamera:add_target( player.model.model_root )
	EntityManager:change_player_avatar_attri("id", player_id)
	for k,v in pairs(attris) do
		EntityManager:change_player_avatar_attri(k, v)
	end
	
	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个	
	local name_table = Utils:Split(show_name, "\\");
	show_name = name_table[1];  

	local player_name = show_name
	EntityManager:change_player_avatar_attri("name", player_name)
		-- 将人物放到场景camera中心
	local new_player 	= EntityManager:get_player_avatar()
	new_player:change_entity_attri("type", EntityConfig.TYPE_PLAYER_AVATAR)				-- 实体类型
	-- new_player:change_entity_attri("x", 0)
	-- new_player:change_entity_attri("y", 0)
	-- 最后通知引擎创建实体
	-- print("创建主角:", player_born_x, player_born_y)
	-- local model = ZXEntityMgr:sharedManager():createEntity(handle, ZX_ENTITY_PLAYER_AVATAR, 
	-- 	player_born_x, player_born_y, new_player.body, new_player.dir, new_player.moveSpeed)



	-- EntityManager:change_player_avatar_attri("model", model)
	-- EntityManager:change_player_avatar_attri("weapon", new_player.weapon)

	--local show_name = Lang.camp_name_ex[new_player.camp] .. "#cfff000" .. show_name
	--model:setName(show_name)
	--显示主角名字
	-- EntityManager:change_player_avatar_attri("sname", show_name)
	-- new_player:show_name(show_name,true)
 --    -- 保存仙盟名字
	-- if ( name_table[3] ) then
	-- 	new_player:change_entity_attri("guildName",name_table[3]);
	-- end

	-- new_player:on_player_avatar_create_finish();	
end

function GameLogicModel:create_other_player_avatar( handel,id,attris,name )

end

function GameLogicModel:create_other_entity_avatar( date )
	-- 只有宠物才有的属性
	if date.is_pet  then
		local player_avatar = EntityManager:get_player_avatar()
		-- ★潜规则：-2 表示主玩家的宠物
		if date.master_handle ~= nil and player_avatar ~= nil and (player_avatar.handle == date.master_handle )  then
			-- EntityManager保存宠物handle;
			EntityManager:set_player_pet( date.entity_handle );	
		end
	end
		-- 通知引擎创建实体
	print("创建其他实体", EntityConfig.ENTITY_TYPE[date.entity_type], date.x, date.y, 
		", name:", date.name, ", handle:", date.entity_handle,"hp:",date.hp)
	
	--local model = ZXEntityMgr:sharedManager():createEntity(entity_handle, entity_type, x, y, body, dir, moveSpeed)

	-- 到现在才能确认类型，并创建entity和赋值属性
	local new_entity	= nil;
	-- 封神台的宠物以及护送仙女里面的仙女都是Monster，但他们的名字后面都会跟着玩家的名字
	local player_avatar = EntityManager:get_player_avatar()
	if ( player_avatar and date.name_table[2] == player_avatar.name and
	 ( date.name_table[1] == "佳人" or date.name_table[1] == "天香" or 
	 date.name_table[1] == "绝色" or date.name_table[1] == "倾城" or date.name_table[1] == "天仙" ) ) then
		print("player_avatar.name",player_avatar.name,date.name_table[1],date.name_table[2]);
		-- 用个比较2的方法判断是不是仙女 然后创建实体用-3
		new_entity = EntityManager:create_entity(date.entity_handle, EntityConfig.ENTITY_TYPE[-3])
	else
		new_entity = EntityManager:create_entity(date.entity_handle, EntityConfig.ENTITY_TYPE[date.entity_type])
	end
	scene.XLogicScene:sharedScene():getEntityNode():addChild( new_entity.model.model_root )
	--new_entity:change_entity_attri("model", model)					-- 由于npc有可能有称号，是根据名字获取的，

	for k,v in pairs(date.attris) do
		new_entity:change_entity_attri(v[1], v[2])	
	end

	local model_pos_x, model_pos_y = new_entity.model:getPosition()

	local player_avatar = EntityManager:get_player_avatar();
	-- 加上主人的名字
	-- if date.master_handle ~= nil then
	-- 	new_entity:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
	-- 	print("new_entity.name_color",new_entity.name_color);	
	-- 	model:setName("#c" .. Utils:c3_dec_to_hex(name_color) ..name_table[2].."的".. name);
	-- 	new_entity:change_entity_attri("sname", "#c" .. Utils:c3_dec_to_hex(name_color) ..name_table[2].."的".. name)	

	-- else
	-- 	local temp = "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	-- 	-- 如果是怪物的话，加上等级
	-- 	if is_monster then
	-- 		temp = temp .. "(" .. level .. "级)"
	-- 	end
	-- 	model:setName(temp)
	-- 	new_entity:change_entity_attri("sname", temp)	
	-- end
	-- 宠物添加称号
	-- if ( is_pet and new_entity.hpStore > 0 ) then
	-- 	print("camp,hpStore",new_entity.camp,new_entity.hpStore)
	-- 	new_entity:add_title( new_entity.hpStore )
	-- end

	-- --显示宠物名字
	-- if is_pet or is_npc then
	-- 	new_entity:show_name(new_entity.sname,true)
	-- end

	-- 策划要求封神台中的自己宠物不能被点击
	-- 封神台中宠物是Monster
	-- if ( SceneManager:get_cur_scene() == 1078 and player_avatar and name_table[2] == player_avatar.name ) then 
	-- 	new_entity:disable_click_event(); 
	-- 	entity_type = -2;
	-- 	new_entity:change_entity_attri("type", entity_type)				-- 实体类型
	-- end

	-- 玄都之主添加特效
	-- if name == "玄都主雕像" then
	-- 	local ani_table = effect_config[79];
	-- 	model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,5,ani_table[2],0,50);
	-- end

	-- 如果实体是有移动目标地点的，则移动
	-- if tx ~= -1 and ty ~= -1 then
	-- 	new_entity:start_move(x, y, tx, ty)
	-- end

	-- 新产生了一个entity,通知小地图
	--MiniMapModel:update_entity_point( 1, entity_handle, new_entity );

	
	-- 要根据设置系统设置，控制是否显示名称
	--EntityManager:set_one_monster_show_name( new_entity )

    -- -- 根据设置系统， 是否显示其他玩家
    -- EntityManager:set_hide_other_player( new_entity )

    --EntityManager:set_hide_player( new_entity )

    -- if ( new_entity.type == 1 ) then
    --     -- 根据系统设置，控制是否显示怪物
    --     EntityManager:set_hide_monster( new_entity );
    -- end
end