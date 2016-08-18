-- -- GameLogicCC.lua
-- -- created by aXing on 2012-12-1
-- -- 游戏实体对象逻辑处理类

-- -- super_class.GameLogicCC()

 GameLogicCC = {}

function GameLogicCC:login_game()
	local account = "test_1"
	local server_ip = "192.168.1.53"
    local server_port = 9101
    local password = "e10adc3949ba59abbe56e057f20f883e"
   	local server_id = 18
    -- NetManager:connect( account, password, server_ip, server_id, server_port )

 --    local function back_func()


	--     local pack = NetManager:get_NetPacket(8, 8)
	-- 	pack:writeUInt(8)
	-- 	NetManager:send_packet(pack)
	-- end
	-- local c = _new_callback()
	-- c:start(5,back_func)

end

-- init_instance("GameLogicCC")
-- -- 游戏连接心跳
-- local heartBeat = nil
-- function GameLogicCC:do_game_tick( pack )
-- 	local pack = NetManager:get_socket():alloc(0, 2)
-- 	pack:writeUInt(0)
-- 	NetManager:get_socket():SendToSrv(pack)

-- 	if heartBeat == nil then
-- 		heartBeat = os.clock()
-- 	end
-- 	-- -- 每次接到服务器心跳，说明连接还在，就重置连接检查
-- 	-- GameStateManager:reset_connect_check_count(  )
-- end




-- -- 在场景上创建其他玩家
-- function GameLogicCC:do_create_other_avatar( pack )
-- 	local player_id		= pack:readInt()				-- 玩家id
-- 	local handle 		= pack:readInt64()				-- 玩家的handle

-- 	-- 判断实体是否已经创建
-- 	local is_exist_entity = EntityManager:get_entity(handle)
-- 	if ( is_exist_entity ) then
-- 		print("玩家已经创建.............................................................")
-- 		return ;
-- 	end

-- 	local is_teleport	= pack:readByte()				-- 是否传送过来的
-- 	local x 			= pack:readInt()
-- 	local y 			= pack:readInt()
-- 	local tx			= pack:readInt()
-- 	local ty 			= pack:readInt()
-- 	local body 			= pack:readInt()
-- 	local hp 			= pack:readUInt()
-- 	local mp 			= pack:readUInt()
-- 	local maxHp 		= pack:readUInt()
-- 	local maxMp 		= pack:readUInt()
-- 	local moveSpeed 	= pack:readWord()
-- 	local sex 			= pack:readByte()
-- 	local job 			= pack:readByte()
-- 	local level 		= pack:readByte()
-- 	local weapon 		= pack:readInt()
-- 	local mount 		= pack:readInt()
-- 	local wing 			= pack:readInt()
-- 	local socialMask 	= pack:readInt()
-- 	local face 			= pack:readWord()
-- 	local attackSpeed 	= pack:readWord()
-- 	local dir 			= pack:readByte()
-- 	local state 		= pack:readUInt()
-- 	local title 		= pack:readByte()
-- 	local camp 			= pack:readByte()
-- 	local campPost 		= pack:readInt()
-- 	local temp 			= pack:readInt()
-- 	local pkMode 		= Utils:high_word(temp)	-- pk模式
-- 	local vipFlag 		= Utils:low_word(temp) -- vip经验
-- 	local teamId 		= pack:readInt()		-- 队伍id
-- 	local QQVIP 		= pack:readInt()			-- qq vip
-- 	local practiceEffect = pack:readInt()-- 打坐时特效

-- 	local guildId =  pack:readInt()-- 仙宗ID  add by tjh 20140915
-- 	local serverId =  pack:readInt()-- 服务器名  add by tjh 20140915

-- 	-- 读取角色名字颜色
-- 	local name_color = ZXLuaUtils:band(pack:readUInt(), 0xffffff)
-- 	-- 读取实体名称
-- 	local name = pack:readString()

-- 	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个	
-- 	require "utils/Utils"
-- 	local name_table = Utils:Split(name, "\\");
-- 	name = name_table[1];  

-- 	-- 最后通知引擎创建实体
-- 	-- print("GameLogicCC 创建其他玩家: ", x, y)
-- 	-- print("创建其他玩家", EntityConfig.ENTITY_TYPE[0], x, y, ", name:", name, ", model id:", body)
-- 	local model = ZXEntityMgr:sharedManager():createEntity(handle, ZX_ENTITY_AVATAR , x, y, body, dir, moveSpeed)

-- 	-- 创建一个实体数据
-- 	local new_entity 	= EntityManager:create_entity(handle, "Avatar")
-- 	new_entity:change_entity_attri("model", model)
-- 	local show_name 	= Lang.camp_name_ex[camp] .. "#c" .. Utils:c3_dec_to_hex(name_color) .. name
-- 	--edit by tjh 20140915 连服显示玩家服务器
-- 	-- if KuaFuModel:get_kuafu_satae() then
-- 	-- 	local serverName = string.format("[%s]",serverId)
-- 	-- 	show_name = serverName .. show_name
-- 	-- end
-- 	model:setName(show_name)
-- 	--放在原先的位置不知道为什么没有赋值成功，都没有走到那里去。 先提上来解决9阶坐骑问题。
-- 	new_entity:change_entity_attri("dir", dir)			-- 朝向
-- 	--显示其他玩家
-- 	new_entity:change_entity_attri("sname", show_name)
-- 	new_entity:show_name(show_name,true)
-- 	-- 实体类型
-- 	new_entity:change_entity_attri("type", ZX_ENTITY_AVATAR )
-- 	-- 为实体创建属性
-- 	new_entity:change_entity_attri("id", player_id)				 	-- 玩家id
-- 	new_entity:change_entity_attri("x", x)							-- 坐标X
-- 	new_entity:change_entity_attri("y", y)							-- 坐标Y
-- 	new_entity:change_entity_attri("body", body)			-- 模型id				
-- 	new_entity:change_entity_attri("hp", hp)			-- 当前血量
-- 	new_entity:change_entity_attri("mp", mp)			-- 当前蓝量
-- 	new_entity:change_entity_attri("maxHp", maxHp)		-- 最大血量
-- 	new_entity:change_entity_attri("maxMp", maxMp)		-- 最大蓝量
-- 	new_entity:change_entity_attri("moveSpeed", moveSpeed)	-- 移动速度
-- 	new_entity:change_entity_attri("sex", sex)			-- 性别
-- 	new_entity:change_entity_attri("job", job)			-- 职业
-- 	new_entity:change_entity_attri("level", level)		-- 等级
-- 	new_entity:change_entity_attri("weapon", weapon)		-- 武器模型
-- 	new_entity:change_entity_attri("mount", mount)			-- 坐骑模型
-- 	new_entity:change_entity_attri("wing", wing)			-- 翅膀模型
-- 	new_entity:change_entity_attri("socialMask", socialMask)	-- 社会关系的mask，是一些bit位
-- 	new_entity:change_entity_attri("face", face)			-- 头像id
-- 	new_entity:change_entity_attri("attackSpeed", attackSpeed)	-- 攻击速度
-- 	--new_entity:change_entity_attri("dir", dir)			-- 朝向
-- 	new_entity:change_entity_attri("state", state)		-- 实体当前的状态，如打坐等
-- 	new_entity:change_entity_attri("title", title)		-- 称号id
-- 	new_entity:change_entity_attri("camp", camp)			-- 阵营id
-- 	new_entity:change_entity_attri("campPost", campPost)		-- 阵营职位
		
-- 	new_entity:change_entity_attri("pkMode", pkMode)	-- pk模式
-- 	new_entity:change_entity_attri("vipFlag", vipFlag) -- vip经验
-- 	new_entity:change_entity_attri("teamId",teamId)		-- 队伍id
-- 	new_entity:change_entity_attri("QQVIP", QQVIP)			-- qq vip
-- 	new_entity:change_entity_attri("practiceEffect",practiceEffect)-- 打坐时特效

-- 	new_entity:change_entity_attri("guildId",guildId)    --仙宗ID
-- 	new_entity:change_entity_attri("name", name)					-- 名字 
	
-- 	-- 添加读取buff				2013-4-13
-- 	local buff_count	= pack:readByte()
-- 	for i=1,buff_count do
-- 		local buff 		= BuffStruct(pack)
-- 		new_entity:add_buff(buff)
-- 	end

-- 	-- 添加读取实体特效id
-- 	local effect_count	= pack:readByte()
-- 	for i=1,effect_count do
-- 		local effect_type	= pack:readByte()
-- 		local effect_id		= pack:readWord()
-- 		local duration 		= pack:readUInt()			-- 毫秒
-- 		new_entity:add_effect(effect_type, effect_id, duration)
-- 	end

-- 	-- 添加称号
-- 	for i=0,31 do
-- 		local byte = pack:readByte()
-- 		if byte ~= 0 then
-- 			for j=0,7 do
-- 				local have = ZXLuaUtils:isSysEnabled(byte, j)
-- 				if have == true then
-- 					local title_index = i * 8 + j
-- 					new_entity:add_title(title_index)
-- 				end
-- 			end
-- 		end
-- 	end

-- 	-- model创建在state之后，所以只能把玄都之主的判断加在这了
-- 	if ( ZXLuaUtils:band(new_entity.state, EntityConfig.ACTOR_STATE_CASTELLAN) > 0 ) then
-- 		-- print("-------------------------播放玄都之主特效--------------------------");
-- 		local ani_table = effect_config[79];
-- 		new_entity.model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
-- 	end

-- 	-- 如果实体是有移动目标地点的，则移动
-- 	if tx ~= -1 and ty ~= -1 then
-- 		new_entity:start_move(x, y, tx, ty)
-- 	end

-- 	if SceneManager:get_cur_scene() == 1077 then
-- 		-- 如果是在瑶池仙泉场景里，则隐藏所有玩家的翅膀，武器，坐骑，宠物，
-- 		new_entity:take_off_weapon();
-- 		new_entity:take_off_wing();
-- 		-- 先删除之前的特效
-- 		-- model:stopEffect(GUANGHUAN_EFFECT_TAG);
-- 	end
-- 	-- 保存仙盟名字
-- 	if ( name_table[3] ) then
-- 		new_entity:change_entity_attri("guildName",name_table[3]);
-- 	end

--     -- 根据设置系统， 是否显示其他玩家
--     -- EntityManager:set_hide_other_player( new_entity )

--     EntityManager:set_hide_player( new_entity )
-- end

-- 实体消失
function GameLogicCC:do_destroy_entity( pack )
	
	local handle = pack:readInt64()

	local entity = EntityManager:get_entity( handle );
	-- print("怪物消失。。", handle, entity, entity.name, entity.model.m_x, entity.model.m_y)
	if ( entity ) then
		-- if ( entity.type == 1 and entity.hp <=0) then
		-- 	-- 怪物死亡要播放死亡动画
		-- 	EntityManager:destroy_entity(handle,true);
		-- else
		-- 	EntityManager:destroy_entity(handle)
		-- end
		EntityManager:destroy_entity(handle)
	end

end

-- 实体属性改变
function GameLogicCC:do_entity_attribute_changed( pack )
	local handle 	= pack:readUint64()
	local count 	= pack:readByte()
	print("do_entity_attribute_changed:start..................................",count);
	for i=1,count do
		local attri_id 		= pack:readByte()
		local value 		= EntityConfig.ACTOR_PROPERTY[attri_id]
		local attri_type 	= value[1]
		local attri_value
		if value[2] == "int" then
			attri_value = pack:readInt()
		elseif value[2] == "uint" then
			attri_value = pack:readUInt()
		elseif value[2] == "float" then
			attri_value = pack:readFloat()
		elseif value[2] == "double" then
			attri_value = pack:readUint64()
		end
		--print("attri_type ===== ",attri_type,"attri_value = ",attri_value);
		-- if ( attri_type == "hp" ) then
		-- 	local entity = EntityManager:get_entity(handle);
		-- 	if ( entity ) then
		-- 		local dhp 	 = attri_value - entity.hp		-- 血量变化，负的为减血，正的为加血
		-- 		--print("dhp,attri_value,entity.hp",dhp,attri_value,entity.hp)
		-- 		if ( dhp < 0  ) then
		-- 			GameLogicCC:play_change_blood_animation(entity,dhp)
		-- 		    -- 判断被攻击的怪物是否是当前玩家选中的目标
		-- 			if ( UserPanel:check_is_select_entity( handle ) ) then
		-- 				-- 更新主界面
		-- 				local win = UIManager:find_window("user_panel");
		-- 				if ( win ) then
		-- 					win:update_other_entity_hp_and_mp( dhp,attri_value,entity.maxHp);	
		-- 				end
		-- 			end
		-- 		end
		-- 		-- 如果有队伍
		-- 		if ( entity.type == 0 and #TeamModel:get_team_table() > 0 ) then
		-- 			local tab = TeamModel:get_team_table();
		-- 			for i=1,#tab do
		-- 				if ( entity.id == tab[i].actor_id) then
		-- 					MiniTaskPanel:get_miniTaskPanel():update_team_attr( entity.id,{attri_value,entity.maxHp},1);
		-- 					break;
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- elseif ( attri_type == "level" ) then
		-- 	local entity = EntityManager:get_entity(handle);
		-- 	if ( entity ) then
		-- 	    -- 如果有队伍
		-- 		if ( entity.type == 0 and #TeamModel:get_team_table() > 0 ) then
		-- 			local tab = TeamModel:get_team_table();
		-- 			for i=1,#tab do
		-- 				if ( entity.id == tab[i].actor_id) then
		-- 					MiniTaskPanel:get_miniTaskPanel():update_team_attr( entity.id,{attri_value},3);
		-- 					break;
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- elseif attri_type == "practiceEffect" then
		-- 	print("change practiceEffect-------------------------",attri_value)
		-- 	GameLogicCC:foot_effect_change(handle, attri_value)
		-- elseif attri_type == "mp" then
		-- 	if ( UserPanel:check_is_select_entity( handle ) ) then
		-- 		-- 更新主界面
		-- 		local win = UIManager:find_window("user_panel");
		-- 		if ( win ) then
		-- 			local entity = EntityManager:get_entity(handle);
		-- 			win:update_other_entity_mp( attri_value,entity.maxMp);	
		-- 		end
		-- 	end
		-- end
		EntityManager:change_entity_attri(handle, attri_type, attri_value)
	end
end

-- 主角属性改变
function GameLogicCC:do_player_avatar_attribute_changed( pack )

	--print("主角属性改变.........................")

	local count = pack:readByte()

	--local is_lv_up = false;

	for i=1,count do
		local attri_id 		= pack:readByte()
		local value 		= EntityConfig.ACTOR_PROPERTY[attri_id] or "int"
		local attri_type 	= value[1]
		local attri_value
		if value[2] == "int" then
			attri_value = pack:readInt()
		elseif value[2] == "uint" then
			attri_value = pack:readUInt()
		elseif value[2] == "float" then
			attri_value = pack:readFloat()
		elseif value[2] == "double" then
			attri_value = pack:readUint64()
		end
		--print("attri_id",attri_id,attri_type,attri_value)
		-- 如果是主角掉血了要显示飘血动画
		-- if ( attri_type == "hp" ) then
		-- 	local player = EntityManager:get_player_avatar();
		-- 	if ( player ) then 
		-- 		local dhp = attri_value - player.hp;
		-- 		--print("主角hp改变,dhp = ",dhp)
		-- 		if ( dhp ~= 0  ) then
		-- 			GameLogicCC:play_change_blood_animation( player,dhp );
		-- 		end
		-- 	end
		-- elseif attri_type == "practiceEffect" then
		-- 	print("change practiceEffect ----------------------",attri_value)
		-- 	GameLogicCC:foot_effect_change(nil, attri_value)
		-- end
		-- print("GameLogic -- 主角的属性发生变化",attri_type, attri_value);
		if attri_type and attri_value then
			EntityManager:change_player_avatar_attri(attri_type, attri_value)
		end

		-- if ( attri_type == "level" ) then
		-- 	is_lv_up = true;
		-- end

	end
	-- if ( is_lv_up ) then 
	-- 	-- 执行玩家属性变化的动画
	--	local player = EntityManager:get_player_avatar();
	--	player:play_attr_animation( )
	-- end
end

-- 重设主角坐标
function GameLogicCC:do_reset_player_avatar( pack )
	local scene_id 	= pack:readInt()
	local x 		= pack:readInt()
	local y 		= pack:readInt()
	local avatar = EntityManager:get_player_avatar()
	print("重设主角坐标:", x, y, "主角当前坐标:", avatar.model.m_x, avatar.model.m_y,avatar.state)
--	xprint('GameLogicCC:do_reset_player_avatar')

	-- avatar:change_entity_attri("x", x)
	-- avatar:change_entity_attri("y", y)
	-- avatar.model:stopMove(x, y)
	-- ZXLogicScene:sharedScene():moveCameraMap(x, y)
	-- --avatar:reset();
	-- if ( avatar.type == -1 ) then
	-- 	-- 主角的话需要停止打坐
	-- 	avatar:stop_dazuo();
	-- 	-- 停止当前动作
	-- 	avatar:stop_curr_action(  )
	-- end
end

-- -- 其他实体停止移动(包括主角，令实体停止所有的动作)
-- function GameLogicCC:do_entity_stop_moved( pack )
-- 	local handle 	= pack:readInt64()
-- 	local target_x 	= pack:readInt()
-- 	local target_y 	= pack:readInt()

-- 	-- print("实体停止移动--屏幕坐标:", target_x, target_y)
-- 	local entity 	= EntityManager:get_entity(handle)
-- 	if entity ~= nil then
-- 		-- 坐标同步
-- 		entity:change_entity_attri("x", target_x)
-- 		entity:change_entity_attri("y", target_y)

-- 		-- 如果目标是玩家并且是在打坐中则不需要stop_move
-- 		if ( entity.type == -1 or entity.type == 0 ) then
-- 			if ( ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0 or ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0  ) then
-- 				return;
-- 			end
-- 		end

-- 		if entity.stop_move ~= nil then
-- 			entity:stop_move(target_x, target_y)
-- 		end
-- 	end
-- end

-- -- 其他实体的移动
-- function GameLogicCC:do_entity_moved( pack )
-- 	local handle 	= pack:readInt64()
-- 	local cur_x 	= pack:readInt()
-- 	local cur_y 	= pack:readInt()
-- 	local target_x 	= pack:readInt()
-- 	local target_y 	= pack:readInt()

-- 	-- TODO:: 实体移动
-- 	local entity 	= EntityManager:get_entity(handle)

-- 	-- print("GameLogicCC entity move:", cur_x, cur_y, target_x, target_y, entity)
-- 	if entity ~= nil and entity.start_move ~= nil then
-- 		entity:start_move( cur_x, cur_y, target_x, target_y)
-- 	end

-- end

function GameLogicCC:do_enter_scene_test()
	local fb_id 		= 0 --pack:readWord()		-- 进入的副本id	(当副本id为零的时候，表示在世界场景，否则在副本)
	local scene_id 		= 1047 --pack:readWord()		-- 进入的场景id
	local x 			= 500--pack:readInt()		-- 跳转的像素坐标x
	local y 			= 300--pack:readInt()		-- 跳转的像素坐标y
	local keep_walking 	= 0--pack:readInt()		-- 是否继续寻路
	local scene_name 	= "yms02"--pack:readString()	-- 场景的名字
	local map_name 		= "是的"--pack:readString()		-- 场景的地图名字
	-- 把地图名转换成小写
	map_name = string.lower(map_name);
	local tyc_lord 	= ""--pack:readString()		-- 玄都城主的名字
	print("进入场景", fb_id, scene_id, x, y,map_name,tyc_lord)
EntityManager:init()
	-- 跳转到地图的场景
	-- require "scene/SceneManager"
	SceneManager:enter_scene(fb_id, scene_id, x, y, keep_walking, scene_name, map_name)
	-- player_born_x = x
	-- player_born_y = y
	EntityManager:create_player_avatar(0x33115)
	-- -- 然后需要把主角放到屏幕中间
	local player_avatar = EntityManager:get_player_avatar()
	local scene,scene_root,entity_root = SceneManager:get_scene()
	print("scene=",scene)
	-- local sp = cc.Sprite:create("res/ui/common/close.png")
	-- scene:addChild(sp,9999)
	-- sp:setPosition(960/2,640/2)
	-- print("scene_root=",scene_root)
	entity_root:addChild(player_avatar.root)
	if player_avatar then
		-- player_avatar.model:stopMove(x, y)
		player_avatar:change_entity_attri("x", x)
	 	player_avatar:change_entity_attri("y", y)
	 	player_avatar:change_entity_attri("moveSpeed",0.2)
	 	-- print("player_avatar.model = ",player_avatar.model)
		player_avatar:change_entity_attri("body",11)
		-- print("然后重置玩家的状态")
	 	-- player_avatar:reset()

	 	player_avatar:do_finish_create()
	end
	-- player_avatar.root:setPosition(960/2,640/2)
end

-- 进入场景
function GameLogicCC:do_enter_scene( pack )
	local fb_id 	= pack:readWord()		-- 进入的副本id	(当副本id为零的时候，表示在世界场景，否则在副本)
	local scene_id 	= pack:readWord()		-- 进入的场景id
	local x 		= pack:readInt()		-- 跳转的像素坐标x
	local y 		= pack:readInt()		-- 跳转的像素坐标y
	local keep_walking = pack:readInt()		-- 是否继续寻路
	local scene_name = pack:readString()	-- 场景的名字
	local map_name 	= pack:readString()		-- 场景的地图名字
	-- 把地图名转换成小写
	map_name = string.lower(map_name);
	local tyc_lord 	= pack:readString()		-- 玄都城主的名字
	-- print("进入场景", fb_id, scene_id, x, y,map_name,tyc_lord)

	-- 跳转到地图的场景
	-- require "scene/SceneManager"
	SceneManager:enter_scene(fb_id, scene_id, x, y, keep_walking, scene_name, map_name)
	player_born_x = x
	player_born_y = y
	-- print("aaaaaaaaaa")
	-- EntityManager:create_player_avatar(0x33115)

	-- -- -- 然后需要把主角放到屏幕中间
	-- local player_avatar = EntityManager:get_player_avatar()
	-- if player_avatar then
	-- 	player_avatar.model:stopMove(x, y)
	-- 	player_avatar:change_entity_attri("x", x)
	--  	player_avatar:change_entity_attri("y", y)
	-- print("然后重置玩家的状态")
	--  	player_avatar:reset()

	-- end

	-- 	-- local winSize		= CCDirector:sharedDirector():getWinSizeInPixels();
	-- 	-- local halfWinWidth	= winSize.width  / 2
	-- 	-- local halfWinHeight	= winSize.height / 2
	-- 	-- local cam_pos 		= ZXGameScene:sharedScene():getCameraPositionInPixels()
	-- 	-- local pos_x			= x - cam_pos.x + halfWinWidth
	-- 	-- local pos_y			= cam_pos.y - y + halfWinHeight
	-- 	-- player_avatar.model:setPosition(pos_x, pos_y)
	-- else
	-- 	player_born_x = x
	-- 	player_born_y = y
	-- end
	-- -- if ( fb_id == 0 ) then
	-- -- 	-- AIManager判断是否是自动寻路
	-- -- 	AIManager:CB_enter_scene();
	-- -- end
	-- -- 切换场景后询问下AIManager是否有下一步动作 
	-- AIManager:CB_enter_scene( false );
	-- -- 询问新手指引
	-- XSZYManager:on_enter_scene(  )

	-- -- 副本内要下坐骑
	-- if ( fb_id ~= 0 ) then 
	-- 	local is_ride = MountsModel:get_is_shangma(  );
	-- 	if ( is_ride ) then
	-- 		--MountsModel:ride_a_mount( );
	-- 	end
	-- end

end

-- -- 实体血量变化
-- function GameLogicCC:do_entity_hp_changed( pack )
-- 	-- local handle = pack:readInt64()
-- 	-- local dhp 	 = pack:readInt()		-- 血量变化，负的为减血，正的为加血
-- 	-- local entity = EntityManager:get_entity(handle)
-- 	-- --print("实体掉血。。。。。。。。。。",entity.name);
-- 	-- if ( entity ) then
-- 	-- 	GameLogicCC:play_change_blood_animation(entity,dhp)
-- 	-- 	local result_hp = entity.hp + dhp;
-- 	-- 	--entity:change_entity_attri("hp", result_hp );
-- 	-- 	--print("entity:change_entity_attri",entity.hp,dhp,handle);
-- 	--     -- 判断被攻击的怪物是否是当前玩家选中的目标
-- 	-- 	if ( UserPanel:check_is_select_entity( handle ) ) then
-- 	-- 		-- 更新主界面
-- 	-- 		local win = UIManager:find_window("user_panel");
-- 	-- 		if ( win ) then
-- 	-- 			win:update_other_entity_hp_and_mp( dhp,result_hp,entity.maxHp);	
-- 	-- 		end
-- 	-- 	end
-- 	-- end
-- end

-- -- 播放掉血动画
-- function GameLogicCC:play_change_blood_animation(entity,dhp)
-- 	-- 加血是绿色字，掉血是红色字
-- 	-- 显示飘血
-- 	--print("dhp = ",dhp);
-- 	if ( entity ) then
-- 		local entity_top_node = entity.model:getBillboardNode();
-- 		local hp_str = "";
-- 		local yOffset = entity_top_node:getPositionY()
-- 		if ( dhp > 0 ) then
-- 			--hp_str = "#c66ff66+"..dhp;
-- 			TextEffect:FlowText(entity.model,yOffset,nil,FLOW_COLOR_TYPE_GREEN,'+' .. tostring(dhp), true)
-- 		else
-- 			--玩家或者宠物
-- 			if entity.entity_type == EntityConfig.TYPE_PLAYER_AVATAR or 
-- 		   	   entity.entity_type == EntityConfig.TYPE_PLAYER_PET then
-- 				TextEffect:FlowText(entity.model,yOffset,nil,FLOW_COLOR_TYPE_YELLOW,tostring(dhp))
-- 			else
-- 				TextEffect:FlowText(entity.model,yOffset,nil,FLOW_COLOR_TYPE_RED,tostring(dhp))
-- 			end

-- 			--hp_str = "#cff0000"..dhp;
			
-- 		end
-- 	end
-- end

-- -- 实体受击
-- function GameLogicCC:do_entity_hurted( pack )
-- 	local handle = pack:readInt64()
-- end

-- 实体死亡
function GameLogicCC:do_entity_died( pack )
	--print("实体死亡.............................")
	local dead = pack:readInt64()
	local killer = pack:readInt64()
	local is_hit_fly = pack:readInt()
	-- 怪物死亡后马上取消选中
	--UserPanel:is_selected_entity( dead );

	local dead_entity = EntityManager:get_entity(dead)

	local killer_entity = EntityManager:get_entity(killer)

	EntityManager:destroy_entity( dead ,true ,is_hit_fly );
	--怪物没有死亡动作，玩家的死亡动作则通过服务器下发状态来改变
	-- if dead_entity.die ~= nil then
	-- 	dead_entity:die(killer_entity)
	-- end

	

	-- if ( dead_entity ) then 

	-- 	if dead_entity.hp > 0 then
	-- 		GameLogicCC:play_change_blood_animation(dead_entity, -dead_entity.hp)
	-- 	end

	-- 	if ( dead_entity.type == -2 ) then
	-- 		dead_entity:die();
	-- 	elseif dead_entity.type == 1  then
	-- 		--EntityManager:destroy_entity( dead ,true ,is_hit_fly );
	-- 		-- 播放怪物死亡动画
	-- 		dead_entity.hp = 0;
	-- 		LuaEffectManager:play_monster_dead_effect( dead_entity ,is_hit_fly);
			
	-- 	end
	-- 	-- 新手指引判断,万剑愁挂了以后要播放剧情动画
	-- 	if ( dead_entity.name == "蚩尤幻影") then
	-- 		-- 播放剧情动画
	-- 		JQDH:play_animation( 1 ) 
	-- 	elseif ( dead_entity.name == "蚩尤古兵") then
	-- 		JQDH:play_animation( 4 ) 
	-- 	elseif ( dead_entity.name == "蠪侄") then	
	-- 		JQDH:play_animation( 6 ); 
	-- 	end
	-- end

	-- local pet = EntityManager:get_player_pet();
	-- if ( pet ) then
	-- 	-- 如果死亡的实体是宠物的攻击目标
	-- 	if ( dead == pet.target_id ) then
	-- 		EntityManager:get_player_pet().target_id = nil;
	-- 	end
	-- end
	--print(dead_entity.name,"死亡")



end

-- -- 实体释放技能
-- function GameLogicCC:do_entity_spell( pack )
-- 	local handler 		= pack:readInt64()
-- 	local skill_id		= pack:readWord()
-- 	local skill_level	= pack:readByte()
-- 	local dir 			= pack:readByte()

-- 	local entity = EntityManager:get_entity(handler)
-- 	if entity ~= nil then
-- 		entity:use_skill(skill_id, skill_level, dir)
-- 	end

-- 	LuaEffectManager:SpellEffect(skill_id,entity)
-- end

-- -- 实体瞬移
-- function GameLogicCC:do_entity_teleport( pack )

-- 	local handler 		= pack:readInt64()
-- 	local play_effect	= pack:readInt()
-- 	local pos_x 		= pack:readInt()
-- 	local pos_y 		= pack:readInt()
-- 	local dir 			= pack:readByte()
	
-- 	local entity = EntityManager:get_entity(handler)
-- 	if entity ~= nil then
-- 		entity:change_entity_attri("dir", dir)
-- 		entity:change_entity_attri("x", pos_x)
-- 		entity:change_entity_attri("y", pos_y)
-- 		entity.model:stopMove(pos_x, pos_y)

-- 		--xprint('GameLogicCC:do_entity_teleport')
-- 		print('GameLogicCC:do_entity_teleport',pos_x,pos_y)
-- 		--self.model:playAction(ZX_ACTION_DIE, self.dir, false)

-- 	end

-- 	local player = EntityManager:get_player_avatar()
-- 	-- 如果瞬移的是主角，则移动镜头 
-- 	if entity == player then
-- 		ZXLogicScene:sharedScene():moveCameraMap(pos_x, pos_y)
-- 		-- 主角瞬移完要询问AIManager是否有自动要做的任务
-- 		AIManager:CB_enter_scene()
-- 	end

-- end

-- ------------------------------------------------------------
-- --
-- -- 一些跟人物无关的接口
-- --
-- ------------------------------------------------------------
-- -- 添加一些新的窗口 29 渡劫 30 灵根 31 封神台
-- -- 打开系统窗口
-- function GameLogicCC:do_open_window( pack )
-- 	local window_id 	= pack:readByte()
-- 	local open_or_close	= pack:readByte()
-- 	local param 		= pack:readString()
-- 	 print("==========================do_open_window window_id=",window_id,"param = ",param,"open_or_close = ",open_or_close);
-- 	local window_name	= nil
-- 	if window_id == 0 then					
-- 		--window_name = "bag_win"				-- 背包
-- 	elseif window_id == 1 then
-- 		window_name = "user_attr_win"		-- 人物属性
-- 	elseif window_id == 2 then				
-- 		window_name = "task_win"			-- 任务
-- 	elseif window_id == 3 then
-- 		window_name = "user_skill_win"		-- 技能
-- 	elseif window_id == 4 then
-- 		window_name = "forge_win"			-- 炼器
-- 	elseif window_id == 5 then
-- 		window_name = "guild_win"			-- 仙盟
-- 	elseif window_id == 6 then
-- 		window_name = nil					-- 寄卖
-- 	elseif window_id == 7 then
-- 		window_name = nil					-- 系统
-- 	elseif window_id == 8 then
-- 		window_name = "mall_win" 			-- 商城
-- 	elseif window_id == 9 then
-- 		window_name = nil					-- 弃用
-- 	elseif window_id == 10 then
-- 		window_name = nil					-- 弃用
-- 	elseif window_id == 11 then
-- 		local item_id = param
-- 		-- TODO:: 打开一个购买的小窗口
-- 		--BuyItemBox.getInstance().showByItemId(id,null,true,1,0,1,true)
-- 		BuyKeyboardWin:show(item_id,nil,1);
-- 	elseif window_id == 12 then
-- 		window_name = nil					-- 弃用
-- 	elseif window_id == 13 then
-- 		-- 显示一个dialog 参数类型 标题,内容  用逗号隔开
-- 		window_name = nil
-- 	elseif window_id == 14 then
-- 		window_name = nil					-- 弃用
-- 	elseif window_id == 15 then
-- 		window_name = "welcome_win"			-- 欢迎界面
-- 	elseif window_id == 16 then
-- 		ZYCMWin:show(param); 				-- 任务刷星界面
-- 	elseif window_id == 17 then
-- 		--VIPDialog:show()					-- 购买速传道具对话框
-- 		MUtils:show_vip_dialog()
-- 	elseif window_id == 18 then
-- 		window_name = "cangku_win" 			-- 打开仓库
-- 	elseif window_id == 19 then
-- 		 HSXNWin:show(param)			    --护送美女界面
-- 	elseif window_id == 20 then
-- 		window_name = nil					-- 还可以护送仙女次数，是否返回去接
-- 	elseif window_id == 21 then
-- 		window_name = "tyzz_dialog"					-- 玩法与规则界面
-- 	elseif window_id == 22 then
-- 		-- window_name = "chat_flower_send_win"	-- 送花界面
-- 		local win = UIManager:show_window("chat_flower_send_win");
-- 		win:reinit_info(param);
-- 	elseif window_id == 23 then
-- 		MysticalShopModel:set_curr_shop_type( MysticalShopModel.OLD_SHOP )
-- 		window_name = "mystical_Shop_win"	-- 神秘商店
-- 	elseif window_id == 24 then
-- 		window_name = "jptz_dialog"			-- 消费引导
-- 	elseif window_id == 25 then
-- 		window_name = nil					-- 打开仓库的提示界面
-- 	elseif window_id == 26 then
-- 		window_name = nil 					-- 打开十一抽奖界面
-- 	elseif window_id == 27 then
-- 		window_name = "pet_win"				-- 打开宠物界面
-- 	elseif window_id == 28 then
-- 		window_name = nil					-- 坐骑引导界面
-- 	elseif window_id == 33 then				-- 淘宝树
-- 		window_name = "dreamland_win"
-- 	elseif window_id == 34 then				-- 打开云车巡游界面
-- 		window_name = "marriage_win"
-- 	elseif window_id == 32 then
-- 		window_name = "baguadigongTwo_win"
-- 	end

-- 	if window_name ~= nil then
-- 		if open_or_close == 0 then
-- 			local win = UIManager:show_window(window_name)
-- 			if window_id == 33 and win then
-- 				win:choose_tbmj_tba();
-- 			elseif window_id == 34 and win then
-- 				win:open_win_for_xunyou(true);
-- 			end

-- 		else
-- 			UIManager:hide_window(window_name)
-- 		end
-- 	end
	
-- end

-- -- 申请跟npc对话
-- -- @ npc_handler npc的handler(如果是执行全局的函数，传0)
-- -- @ content 对话内容
-- function GameLogicCC:req_talk_to_npc( npc_handler, content )
-- 	 print("GameLogicCC:req_talk_to_npc")
-- 	local pack = NetManager:get_socket():alloc(0, 5)
-- 	pack:writeUint64(npc_handler)
-- 	pack:writeString(content)
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- -- 返回npc对话结果
-- function GameLogicCC:do_talk_to_npc( pack )
	
-- 	local success = pack:readByte()			-- 成功与否的标记

-- 	if success then
-- 		local handler = pack:readUint64()		-- 实体句柄
-- 		local content = pack:readString()		-- 对话内容
-- 		print("content = ",content);
-- 		if ( content  ) then
-- 			-- TODO::打开npc对话框并设置
-- 			-- 判断Npc对话框有没打开，如果已经打开则不需要自动去做任务
-- 			-- local win = UIManager:find_visible_window("npc_dialog");
-- 			-- if ( win ) then
-- 			-- 	return;
-- 			-- end
-- 			local entity = EntityManager:get_entity( handler );
-- 			if entity.name == "灵谷传送" then
-- 				-- 地宫传送npc的对话特殊处理，不想显示平台npc对话框。
-- 				UIManager:show_window("baguadigong_win");
-- 			else
-- 				-- 各种坑爹阿，页游版10级的时候没有背包指引，手游有
-- 				-- 所以就有了下面这段坑爹代码
-- 				-- 在做背包指引的时候不能弹任务对话框
-- 				if ( XSZYManager:get_state() ~=  XSZYConfig.BEI_BAO_ZY ) then
-- 					NPCDialog:show(content,handler);
-- 				end
-- 			end
			
-- 		else
-- 			-- TODO::隐藏npc对话框
-- 			--print("隐藏npc对话框")
-- 			--UIManager:hide_window("npc_dialog")
-- 		end
		

-- 	else

-- 	end

-- end

-- -- 0,33号系统 s->c:提示NPC身上是否有可接任务或者可完成任务
-- -- 改变npc的状态 0 没有任务 1 可以接任务 2 有任务可以在Npc上交 3 有任务在这个npc上交，但未完成
-- function GameLogicCC:do_npc_have_quest(pack)
-- 	local npc_handle = pack:readInt64();
-- 	local npc_type = pack:readByte();
-- 	-- 更新npc状态
-- 	EntityManager:change_npc_state( npc_handle,npc_type );
-- end
-- -- /**1-挥洒**/
-- -- public static const ON_WEAPON	 :int = 1;
-- -- /**2-爆炸**/
-- -- public static const EXPLODE	 :int = 2;
-- -- /**3-飞行**/
-- -- public static const FLY	 :int = 3;
-- -- /**4-投掷**/
-- -- public static const THROW_OUT	 :int = 4;
-- -- /**5-脚下持续**/
-- -- public static const KEEP_UNDER_FEET	:int = 5;
-- -- /**6-身上持续**/
-- -- public static const KEEP_ON_BODY	:int = 6;
-- -- 给目标添加特效
-- _effectQueue = {}
-- _effectQueueTimer = timer()

-- function GameLogicCC:target_add_effect( pack )
-- 	local attacker_handle = pack:readInt64();
-- 	local target_handle = pack:readInt64();
-- 	local effect_type = pack:readByte();
-- 	local effect_id = pack:readWord();
-- 	local time = pack:readInt();
-- 	--print("目标添加特效,特效type",effect_type,"特效id = ",effect_id,"time",time,"handle",target_handle);
-- 	--[[
-- 	if _effectQueueTimer:isIdle() then
-- 		_effectQueueTimer:start(0.function, 0(dt) 				
-- 			        if #_effectQueue == 0 then
-- 			            _effectQueueTimer:stop()
-- 			        else
-- 			            local job = table.remove(_effectQueue,1)
-- 			            job()
-- 			        end
-- 			    end)
-- 	end

-- 	_effectQueue[#_effectQueue+1] = function()
-- 	]]--
-- 	--print("目标添加特效,特效type",effect_type,"特效id = ",effect_id,"time",time);
-- 	local effect_animation_table = effect_config[effect_id];
-- 	if ( effect_animation_table  ) then		
-- 		if ( effect_type == 2   or effect_type == 1 or effect_type == 4 ) then
-- 			-- local delay_cb = callback:new();
-- 			-- print("target_handle = ",target_handle);
-- 			-- local function cb()
-- 				local actor = EntityManager:get_entity( target_handle )
-- 				if actor ~= nil then
-- 					if actor.delayKill then
-- 						actor.model:playEffectAt( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2]);
-- 					else
-- 						actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2]);
-- 					end
-- 				end
-- 			-- end
-- 			-- delay_cb:start(0.9,cb);
-- 		elseif ( effect_type == 3 ) then
-- 			local actor = EntityManager:get_entity( attacker_handle )
-- 			local target_entity = EntityManager:get_entity ( target_handle );
-- 			if ( actor and target_entity ) then
-- 				local dir = actor.dir or 0;
-- 				-- model 才是CCZXEntity
-- 				actor.model:playEffect( effect_animation_table[1],effect_id,effect_type,effect_animation_table[3],target_entity.model,dir ,0,500,effect_animation_table[2]);
-- 			end
-- 		elseif (effect_type == 5 or effect_type == 6) then
-- 			local actor = EntityManager:get_entity( target_handle )
-- 			if actor ~= nil then
-- 				actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,time,500,effect_animation_table[2]);
-- 			end
-- 		end
-- 	end
-- 	require "../data/sound_effect"
-- 	if ( sound_effect[effect_id] ) then
-- 		local str = string.format("%s%05d%s", SoundGlobals.SoundEffectPath, effect_id,".wav")
-- 		-- 播放技能音效
-- 		AudioManager : playEffect( str , false )
-- 	end
-- 	--[[
-- 	end
-- 	]]--
-- 	--print("播放技能音效:"..str)
-- end


-- -- 添加场景特效
-- function GameLogicCC:scene_add_effect( pack )
	
-- 	local actor_handle = pack:readInt64();		-- 施法者handle
-- 	local effect_type = pack:readByte();		-- 特效类型
-- 	local effect_id = pack:readWord();			-- 特效id
-- 	local pos_x     = pack:readInt();			-- 位置x
-- 	local pos_y     = pack:readInt();			-- 位置y
-- 	local time = pack:readUInt();				-- 持续时间 
-- 	print("------------------------------添加场景特效,特效type",effect_type,"特效id = ",effect_id,"pos_x,pos_y,time= ",pos_x,pos_y,time);

-- 	local effect_animation_table = effect_config[effect_id];

-- 	if ( effect_animation_table  ) then
-- 		-- local actor = EntityManager:get_entity( actor_handle )
-- 		-- -- 重新换算Pos
-- 		-- pos_x = pos_x - actor.x;
-- 		-- pos_y = pos_y - actor.y;
-- 		-- --print("换算后pos_x = ",pos_x,"pos_y = ",pos_y);
-- 		-- if ( effect_type == 2   or effect_type == 1 ) then
-- 		-- 	actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2]);
-- 		-- elseif ( effect_type == 4 ) then
-- 		-- 	actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2],pos_x,pos_y);

-- 		-- elseif ( effect_type == 3 ) then

-- 		-- elseif ( effect_type == 5 or effect_type == 6) then
-- 		-- 	actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,time,500,effect_animation_table[2]);
-- 		-- end
-- 		if effect_type == 6 then
-- 			local ccp = CCPoint( pos_x,pos_y );
-- 			ZXGameScene:sharedScene():mapPosToGLPos(ccp)
-- 			LuaEffectManager:play_view_effect( effect_id,ccp.x,ccp.y,SceneManager.skyRoot,false,100,time)
-- 		else
-- 			local ccp = CCPoint( pos_x,pos_y );
-- 			ZXGameScene:sharedScene():mapPosToGLPos(ccp)
-- 			LuaEffectManager:play_map_effect( effect_id,ccp.x,ccp.y,false,10000,time )
-- 		end
-- 	end
-- 	require "../data/sound_effect"
-- 	if ( sound_effect[effect_id] ) then
-- 		local str = string.format("%s%05d%s", SoundGlobals.SoundEffectPath, effect_id,".wav")
-- 		-- 播放技能音效
-- 		AudioManager : playEffect( str , false )
-- 	end

-- end

-- -- 服务器要求客户端弹出一个对话框
-- -- s->c 0,22 
-- function GameLogicCC:do_message_dialog( pack )
-- 	local data = {};
-- 	data.npc_handle = pack:readUint64();	--npc的handle
-- 	data.text = pack:readString();			--对话框文本
-- 	local btn_num = pack:readByte();		--按钮数量
-- 	data.btn_text_dict = {};				--按钮文本，可能多个
-- 	for i=1,btn_num do
-- 		data.btn_text_dict[i] = pack:readString();
-- 	end

-- 	data.alive_time = pack:readUInt();		--对话框的存在时间
-- 	-- print("对话框的存在时间",data.alive_time);
-- 	data.message_id = pack:readInt();		--消息号
-- 	data.type = pack:readByte();			--对话框类型
-- 	data.tip = pack:readString();			--tip
-- 	data.icon_id = pack:readWord();		--图标id
-- 	data.unkown = pack:readInt();			--超时后返回的按钮id，-1表示不返回
-- 	data.has_close_btn = pack:readByte();--是否有关闭按钮

-- 	-- require "model/FubenModel/FubenCenterModel"
-- 	-- print("服务器要求客户端弹出一个对话框");

-- 	FubenCenterModel:show_message_dialog( data );

-- end

-- -- 对应 0,22协议，返回对话框的操作
-- -- c->s 0,6
-- function GameLogicCC:req_message_dialog( npc_handle, btn_index, message_id )
-- 	local pack = NetManager:get_socket():alloc(0, 6)
-- 	pack:writeUint64(npc_handle)
-- 	pack:writeByte(btn_index);
-- 	pack:writeInt(message_id);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end

-- -- 服务器下发连斩cd时间
-- -- s->c 0,38
-- function GameLogicCC:do_batter_cd_time( pack )
-- 	local cd_time = pack:readUInt();
-- 	-- print("服务器下发连斩cd时间",cd_time);
-- end

-- -- 实体被暴击
-- function GameLogicCC:do_entity_critical( pack )
-- 	local entity_handle = pack:readInt64();		--被暴击实体handle
-- 	local attack_handle = pack:readInt64();		--攻击者实体handle
-- 	local dhp           = pack:readUInt();
-- 	-- print("---------------------------------------实体被暴击-----------------------------dhp = ",dhp);
-- 	local entity = EntityManager:get_entity( entity_handle );
-- 	if ( entity ) then 
-- 		-- print("显示暴击特效...................");
-- 		-- 显示暴击特效
-- 		local entity_top_node = entity.model:getBillboardNode();
-- 		--local hp_str = "#cffc000暴击-"..dhp;
-- 		local yOffset = entity_top_node:getPositionY()
-- 		--被打中的是玩家或宠物飘黄字
-- 		if entity.entity_type == EntityConfig.TYPE_PLAYER_AVATAR or 
-- 		   entity.entity_type == EntityConfig.TYPE_PLAYER_PET then
-- 			TextEffect:FlowText(entity.model, yOffset ,'critical',FLOW_COLOR_TYPE_YELLOW,'-' .. tostring(dhp))
-- 		else
-- 			TextEffect:FlowText(entity.model, yOffset ,'critical',FLOW_COLOR_TYPE_RED,'-' .. tostring(dhp))

-- 			local player = EntityManager:get_player_avatar();
-- 			local root = ZXLogicScene:sharedScene()
-- 			-- 如果攻击者是主角，就要震荡屏幕
-- 			if ( attack_handle == player.handle ) then
-- 			    local x = math.random(-4,4);
-- 			    local y = 0;
-- 			    local z = 0;
-- 			    local timer = timer();
-- 			    local index = 0;
-- 			    local function cb()
-- 			        z = math.random(1,4);
-- 			        if ( z== 1 ) then 
-- 			            x = math.random(-5,5);
-- 			            y = math.random(-5,5);
-- 			           -- print("x,y = ",x,y);
-- 			            root:moveCameraMap(player.x + x, player.y + y);
-- 			        end
-- 			        index = index + 1;
-- 			        if ( index == 30 ) then 
-- 			            timer:stop();
-- 			        end
-- 			    end
-- 			    timer:start(0.01,cb);
-- 			end
-- 		end
-- 	end
-- end

-- -- 实体闪避
-- function GameLogicCC:do_entity_dodge( pack )
-- 	local who_dodge = pack:readByte();
-- 	if ( who_dodge == 0 ) then
-- 		--print("---------------------------玩家闪避攻击---------------------------");
-- 		local entity = EntityManager:get_player_avatar();
-- 		if ( entity ) then 
-- 			-- 显示暴击特效
-- 			local entity_top_node = entity.model:getBillboardNode();
-- 			--local hp_str = "#c66ff66闪避";
-- 			--ZXEffectManager:sharedZXEffectManager():run_blood_action(entity_top_node,hp_str,30);
-- 			local yOffset = entity_top_node:getPositionY()
-- 			TextEffect:FlowText(entity.model,yOffset,'dodge',FLOW_COLOR_TYPE_BLUE,'')
-- 		end
-- 	else
-- 		local player = EntityManager:get_player_avatar();
-- 		local entity = EntityManager:get_entity(player.target_id);
-- 		if ( entity ) then 
-- 			local entity_top_node = entity.model:getBillboardNode();
-- 			local yOffset = entity_top_node:getPositionY()
-- 			TextEffect:FlowText(entity.model,yOffset,'dodge',FLOW_COLOR_TYPE_BLUE,'')
-- 			-- 显示暴击特效
-- 			--
-- 			--local hp_str = "#c66ff66闪避";
-- 			--ZXEffectManager:sharedZXEffectManager():run_blood_action(entity_top_node,hp_str,30);
-- 		end
-- 		--print("---------------------------目标闪避玩家的攻击----------------------");
-- 	end
-- end

-- -- 屏幕震荡
-- function GameLogicCC:do_screen_move( pack )
-- 	local range = pack:readByte()   --屏幕震荡的尺度
-- 	local time = pack:readByte()	--屏幕震荡的时间 
-- 	--print("======================屏幕震荡=======================")
	
-- end

-- -- 创建人物形象的怪物
-- function GameLogicCC:do_create_human_monster( pack )
-- 	local monster_id	= pack:readInt()				-- 怪物id
-- 	local handle 		= pack:readInt64()				-- 怪物的handle
-- 	local x 			= pack:readInt()
-- 	local y 			= pack:readInt()
-- 	local body 			= pack:readInt()
-- 	local maxHp 		= pack:readUInt()
-- 	local maxMp 		= pack:readUInt()
-- 	local moveSpeed 	= pack:readWord()
-- 	local sex 			= pack:readByte()
-- 	local job 			= pack:readByte()
-- 	local level 		= pack:readByte()
-- 	local camp 			= pack:readByte()
-- 	local weapon 		= pack:readInt()
-- 	local face 			= pack:readWord()
-- 	local wing 			= pack:readInt()
-- 	local master_handle = pack:readInt64()
-- 	local master_id 	= pack:readInt()
-- 	local name 			= pack:readString()
-- 	-- 到现在才能确认类型，并创建entity和赋值属性
-- 	require "config/EntityConfig"
-- 	local new_entity	= EntityManager:create_entity(handle, EntityConfig.ENTITY_TYPE[0])
-- 	-- 通知引擎创建实体
-- 	-- print("创建其他实体", EntityConfig.ENTITY_TYPE[0], x, y, ", name:", name, ", model id:", body)
-- 	local model = ZXEntityMgr:sharedManager():createEntity(handle, ZX_ENTITY_AVATAR, x, y, body, 6, moveSpeed)
-- 	model:setName(name)



-- 	new_entity:change_entity_attri("model", model)					-- 名字 
-- 	new_entity:change_entity_attri("id", monster_id)				 	-- 玩家id
-- 	new_entity:change_entity_attri("x", x)							-- 坐标X
-- 	new_entity:change_entity_attri("y", y)							-- 坐标Y
-- 	new_entity:change_entity_attri("body", body)			-- 模型id				
-- 	new_entity:change_entity_attri("hp", maxHp)			-- 当前血量
-- 	new_entity:change_entity_attri("mp", maxMp)			-- 当前蓝量
-- 	new_entity:change_entity_attri("maxHp", maxHp)		-- 最大血量
-- 	new_entity:change_entity_attri("maxMp", maxMp)		-- 最大蓝量
-- 	new_entity:change_entity_attri("moveSpeed", moveSpeed)	-- 移动速度
-- 	new_entity:change_entity_attri("sex", sex)			-- 性别
-- 	new_entity:change_entity_attri("job", job)			-- 职业
-- 	new_entity:change_entity_attri("level", level)		-- 等级
-- 	new_entity:change_entity_attri("camp", camp)			-- 阵营id
-- 	new_entity:change_entity_attri("weapon", weapon)			-- 武器
-- 	new_entity:change_entity_attri("face", face)			-- 脸
-- 	new_entity:change_entity_attri("wing", wing)			-- 翅膀
-- 	new_entity:change_entity_attri("name", name)					-- 名字 
-- 	new_entity:change_entity_attri("pkMode", 4)					-- pk模式 
-- 	new_entity:change_entity_attri("type", 0)				-- 实体类型

-- 	--镜像不能弹出右键菜单               add by tjh on 20141028
-- 	new_entity:change_entity_attri("jingxiang", true)		-- 镜像实体类型

-- 		--显示其他玩家
-- 	new_entity:change_entity_attri("sname", name)
-- 	new_entity:show_name(name,true)
	
-- end

-- -- 0,40 改变实体名字
-- function GameLogicCC:entity_change_name( pack )
-- 	local handle = pack:readUint64();		--玩家的句柄
-- 	local name = pack:readString();			--玩家名字
-- 	local entity = EntityManager:get_entity( handle );
-- 	if ( entity ) then 
-- 		 print("实体名字=",name)
-- 		 local temp_color = entity.name_color
-- 		local name_table = Utils:Split(name,"\\");
-- 		if ( entity.type == -2 or entity.type == 4 )then
-- 			name = "#c" .. temp_color .. name_table[2].."的"..name_table[1];
-- 		else
-- 			name = name_table[1];
-- 		end
-- 		-- -- 加上颜色
-- 		-- if ( entity.name_color ) then
-- 		-- 	print("entity.name_color",entity.name_color);
-- 		-- 	name = entity.name_color..name;
-- 		-- end
-- 		entity:change_entity_attri( "name",name );
-- 		entity.model:setName(name);

-- 		--显示其他玩家
-- 		entity:change_entity_attri("sname", name)
-- 		entity:show_name(name,true)
-- 		-- 玩家要更新帮派id
-- 		if ( entity.type == -1 or entity.type == 0 ) then
-- 			-- print("name_table[3]",name_table[3]);
-- 			if ( name_table[3] ) then
-- 				entity:change_entity_attri( "guildName",name_table[3] );
-- 			else
-- 				entity:change_entity_attri( "guildName","" );
-- 			end
			
-- 		end
-- 	end
-- end

-- -- 0,37 玩家名称改变颜色
-- function GameLogicCC:avatar_change_name_color( pack )
-- 	print("玩家名称改变颜色...................................")
-- 	local handle = pack:readUint64();		--玩家的句柄
-- 	local name_color = pack:readUInt();			--玩家名称颜色ARGB值
-- 	local entity = EntityManager:get_entity( handle ); 
-- 	if ( entity ) then 
-- 		local base_str = "";
-- 		--print("entity.camp = ",entity.camp);
-- 		if ( entity.camp and entity.camp < 4 and entity.camp > 0) then
-- 			base_str = base_str .. Lang.camp_name_ex[entity.camp];
-- 		end
-- 		local showname = base_str..  "#c" .. Utils:c3_dec_to_hex(name_color) .. entity.name
-- 		entity.model:setName( showname)

-- 				--显示其他玩家
-- 		entity:change_entity_attri("sname", showname)
-- 		entity:show_name(showname,true)
-- 	end
-- end 

-- function GameLogicCC:foot_effect_change(handle,value)
-- 	local foot_index = ZXLuaUtils:lowByte(value)
-- 	if foot_index > 0 then
-- 		if handle == nil then   -----mine
-- 			handle = EntityManager:get_player_avatar_handle()
-- 		end
-- 		if handle == nil then
-- 			return
-- 		end
-- 		local target = EntityManager:get_entity(handle)
-- 		local effect_id = effect_config:index_to_foot_effect_id(foot_index)
-- 		--print("GameLogicCC:foot_effect_change effect_id", effect_id, foot_index)
-- 		target:showFootStep(effect_id)
-- 	end
-- end

-- -- 0,55 跨服战登录key返回
-- function GameLogicCC:do_kuafu_login_key( pack )
-- 	print("--下发跨服登录信息")
-- 	local kuafu_login_info = {}
-- 	kuafu_login_info.server_id =   pack:readInt()
-- 	kuafu_login_info.server_ip = pack:readString()
-- 	kuafu_login_info.server_port = pack:readInt()
-- 	kuafu_login_info.key = pack:readString()
-- 	kuafu_login_info.rold_id = pack:readInt()
-- 	KuaFuModel:do_kuafu_login_info( kuafu_login_info )
-- end
