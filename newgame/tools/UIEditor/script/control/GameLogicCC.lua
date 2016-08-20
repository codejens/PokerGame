-- GameLogicCC.lua
-- created by aXing on 2012-12-1
-- 游戏实体对象逻辑处理类

-- super_class.GameLogicCC()

GameLogicCC = {}

-- 游戏连接心跳
local heartBeat = nil
--服务器第一次心跳时间
local _serverCurrentTime = nil
local _serverTimeBegin = nil
local _serverTimePass = nil 
local _localTimeBegin = nil
local _localTimePass = nil

local _localLastClock = nil
local _currentTimeDif = nil

function _recordServerTime(server_time)
	print('server time', server_time )
	print('server date', os.date('%Y/%m/%d %X', server_time))
	print('local time', os.time())
	print('local date', os.date('%Y/%m/%d %X', os.time()))
	print('os.clock()',os.clock())

	local _localClock = os.clock()
	--记录游戏开始时间
	if not _serverTimeBegin then
		--初始化，服务器时间
		_serverTimeBegin = server_time
		--上一次服务器时间
		_serverCurrentTime = server_time
		--本地时间
		_localTimeBegin  = _localClock
		--上一次本地时间
		_localLastClock  = _localClock
	end

	--计算差异
	_serverTimePass = server_time - _serverTimeBegin
	_localTimePass = _localClock - _localTimeBegin


	--本次间隔的差异
	_currentTimeDif = (_localClock - _localLastClock) - (server_time - _serverCurrentTime)

	--记录当前本地时间
	_localLastClock = _localClock
	--记录当前服务器时间
	_serverCurrentTime = server_time

	--获得全局差异
	print('GameLogicCC:getTimeDif', GameLogicCC:getTimeDif())
end

function GameLogicCC:do_game_tick( pack )
	print("GameLogicCC:do_game_tick")
	local server_time = pack:readUInt()
	_recordServerTime(server_time)

	local pack = NetManager:get_socket():alloc(0, 2)
	pack:writeUInt(0)
	NetManager:get_socket():SendToSrv(pack)

	if heartBeat == nil then
		heartBeat = os.clock()
	end
	-- -- 每次接到服务器心跳，说明连接还在，就重置连接检查
	-- GameStateManager:reset_connect_check_count(  )
end

-- 在场景上面创建非玩家的实体
function GameLogicCC:do_create_other_entity( pack )
	-- print("GameLogicCC:do_create_other_entity")
	local name 			= pack:readString()				-- 实体名字
	--print("GameLogicCC:do_create_other_entity:name = ",name);
	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个
	local name_table = Utils:splitEntityName(name)
	name = name_table[1];

	--删除npc名字后缀,数字
	--name = string.match(name,'(%D+)')

	local entity_id		= pack:readInt()				-- 实体id,如果没有则为0
	local entity_handle	= pack:readInt64()				-- 实体handle
	local entity_type	= pack:readInt()				-- 实体类型

	EntityManager:remove_to_delay_destroy_list(entity_handle);


	-- 判断实体是否已经创建
	local is_exist_entity = EntityManager:get_entity(entity_handle)
	if ( is_exist_entity ) then
		-- print("实体已经创建.............................................................")
		return ;
	end

	local is_pet 		= EntityConfig:is_pet(entity_type)
	local is_monster 	= EntityConfig:is_monster(entity_type)
	local is_npc 		= EntityConfig:is_npc(entity_type)

	local entity 		= EntityManager:get_entity(entity_handle)
	
	if entity == nil then
		local x 		= pack:readInt()
		local y 		= pack:readInt()
		local tx		= pack:readInt()
		local ty 		= pack:readInt()
		local body 		= pack:readInt()
		local dir 		= pack:readByte()
		local moveSpeed = 0
		--print("怪物属性 x:", x)
		--print("怪物属性 y:", y)
		--print("怪物属性 tx:", tx)
		--print("怪物属性 ty:", ty)
		--print("怪物属性 body:", body)
		--print("怪物属性 dir:", dir)
		--print("怪物类型 entity_type:", entity_type)

		local level 		= nil						-- 等级
		local hp 			= nil						-- 血量
		local mp 			= nil						-- 蓝量
		local maxHp 		= nil						-- 最大血量
		local maxMp 		= nil						-- 最大蓝量
		local attackSpeed 	= nil						-- 攻击速度
		local state 		= nil						-- 玩家状态
		local name_color 	= 0xffffff			        -- 名称颜色
		local wing 			= nil						-- 怪物的官职和攻击类型或NPC任务状态
		local func			= nil						-- npc功能类型，怪物暂时没有意义
		local attackSprite 	= nil						-- 宠物的称号 低2位是悟性称号 高2位是成长称号，其他实体没意义
		local title 		= nil						-- 阵营和排行称号信息
		local void_byte 	= nil						-- 保留字段
		-- 下面是只有怪物和npc才有的属性
		if (is_pet or is_monster or is_npc) then
			level 			= pack:readByte()						-- 等级
			hp 				= pack:readUInt()						-- 血量
			--deleted by shan lu 2013-11-12 reason 	缩减协议
			    --mp 			= pack:readUInt()						-- 蓝量
			maxHp 			= pack:readUInt()						-- 最大血量
			--deleted by shan lu 2013-11-12 reason 	缩减协议
			    --maxMp 		= pack:readUInt()						-- 最大蓝量
			moveSpeed 		= pack:readShort()						-- 移动速度
			attackSpeed 	= pack:readWord()						-- 攻击速度
			state 			= pack:readUInt()						-- 玩家状态
			name_color		= pack:readUInt()
			if name_color == 0 then
				name_color 	= 0xffffff
			end
			name_color 		= ZXLuaUtils:band(name_color, 0xffffff)			-- 名称颜色
			wing 			= pack:readByte()						-- 怪物的官职和攻击类型或NPC任务状态
			func			= pack:readInt()						-- npc功能类型，怪物暂时没有意义
			attackSprite 	= pack:readInt()						-- 宠物的称号 低2位是悟性称号 高2位是成长称号，其他实体没意义
			title 		    = pack:readInt()						-- 阵营和排行称号信息
			--deleted by shan lu 2013-11-12 reason 	缩减协议
			    --void_byte 		= pack:readUint64()						-- 保留字段
			
			-----------------------------------------------------
			-- print("怪物属性 level:", level)
			-- print("怪物属性 hp:", hp)
			-- -- print("怪物属性 mp:", mp)
			-- print("怪物属性 maxHp:", maxHp)
			-- -- print("怪物属性 maxMp:", maxMp)
			-- print("怪物属性 moveSpeed:", moveSpeed)
			-- print("怪物属性 attackSpeed:", attackSpeed)
			-- print("怪物属性 state:", state)
			-- print("怪物属性 name_color:", name_color)
			--print("怪物属性 wing:", wing)
			--print("怪物属性 func:", func)
			--print("怪物属性 attackSprite:", attackSprite)
			-- print("怪物属性 title:", title)
			-----------------------------------------------------
		end

		local master_handle = nil;
		
		-- 只有宠物才有的属性
		if is_pet  then
			local player_avatar = EntityManager:get_player_avatar()
			master_handle = pack:readUint64()						-- 主人的handle
			 -- print('@>>>>>>>>>>>>>>>', master_handle, player_avatar.handle)
			-- ★潜规则：-2 表示主玩家的宠物
			if master_handle ~= nil and player_avatar ~= nil and (player_avatar.handle == master_handle )  then
				entity_type = -2;
				-- EntityManager保存宠物handle;
				EntityManager:set_player_pet( entity_handle );	
			end
		end

		-- 通知引擎创建实体
		-- print("创建其他实体", EntityConfig.ENTITY_TYPE[entity_type], x, y, ", name:", name, ", handle:", entity_handle,"hp:",hp,"body",body);
		require "../data/monster" 
		local model = nil
		if name_table[1] ~= monster[14].name and name_table[1] ~= monster[1026].name then
			model = ZXEntityMgr:sharedManager():createEntity(entity_handle, entity_type, x, y, body, dir, moveSpeed)
		end
		-------------------------------------------
		---------HJH 2014-10-17 新对象序列帧 modify begin
		-- if is_monster then
		-- 	model:setActionStept(ZX_ACTION_STEPT)
		-- end
		---------HJH modify end
		-------------------------------------------

		-- 到现在才能确认类型，并创建entity和赋值属性
		local new_entity	= nil;
		-- 斗法台的宠物以及护送仙女里面的仙女都是Monster，但他们的名字后面都会跟着玩家的名字
		local player_avatar = EntityManager:get_player_avatar()

		--从配置里面读取 确认是否为镖车 
		if ( player_avatar and name_table[2] == player_avatar.name and
		 ( name_table[1] == monster[274].name or name_table[1] == monster[275].name or  -- [432]="佳人" -- [433]="天香"
		 name_table[1] == monster[276].name or name_table[1] == monster[277].name or name_table[1] == monster[278].name ) ) then -- [434]="绝色" -- [435]="倾城" -- [436]="天仙"
			-- print("player_avatar.name",player_avatar.name,name_table[1],name_table[2]);
			-- 用个比较2的方法判断是不是仙女 然后创建实体用-3
			new_entity = EntityManager:create_entity(entity_handle, EntityConfig.ENTITY_TYPE[-3])
		elseif name_table[1] == monster[14].name or name_table[1] == monster[1026].name then
			-- 采集物白马因为需要2帧的待机动作,因此按照怪物的模型创建
			-- 只要保证其它属性为采集物的属性即可正常采集
			model = ZXEntityMgr:sharedManager():createEntity(entity_handle, 1, x, y, body, dir, moveSpeed)
			new_entity = EntityManager:create_entity(entity_handle, EntityConfig.ENTITY_TYPE[-4])
		else
			new_entity = EntityManager:create_entity(entity_handle, EntityConfig.ENTITY_TYPE[entity_type])
		end

		-- 如果有主人的handle，要记录下
		if ( master_handle ) then
			new_entity:change_entity_attri("master_handle", master_handle)				-- 主人handle
			-- print("master_handle ............................ = ",new_entity.master_handle);
		end

		new_entity:change_entity_attri("type", entity_type)				-- 实体类型
		new_entity:change_entity_attri("x", x)							-- 坐标X
		new_entity:change_entity_attri("y", y)							-- 坐标Y
		
		-- 怪物和宠物的Face取低位  高位是称号
		if (is_monster or is_pet) then
			new_entity:change_entity_attri("face", Utils:low_word(body))
		else
			new_entity:change_entity_attri("face", body)
		end
		new_entity:change_entity_attri("dir", dir)						-- 朝向
		-- 以下是只有怪物才有的属性
		if (is_pet or is_monster or is_npc) then
			new_entity:change_entity_attri("id", entity_id)				-- 玩家id
			new_entity:change_entity_attri("level", level)				-- 等级
			new_entity:change_entity_attri("hp", hp)					-- 血量
			--new_entity:change_entity_attri("mp", mp)					-- 蓝量
			new_entity:change_entity_attri("maxHp", maxHp)				-- 最大血量
			--new_entity:change_entity_attri("maxMp", maxMp)				-- 最大蓝量
			new_entity:change_entity_attri("moveSpeed", moveSpeed)		-- 移动速度(移动2个逻辑格子需要的毫秒数)
			new_entity:change_entity_attri("attackSpeed", attackSpeed)	-- 攻击速度
			new_entity:change_entity_attri("state", state)				-- 玩家状态
			new_entity:change_entity_attri("attackSprite", attackSprite)-- 宠物的称号 低2位是悟性称号 高2位是成长称号，其他实体没意义
			-- 阵营和排行称号信息
			--deleted by shan lu 2013-11-12 reason 	缩减协议
		    if (is_pet or is_monster) then
		    	new_entity:change_entity_attri("camp", Utils:low_word(title))
		    	new_entity:change_entity_attri("hpStore", Utils:high_word(title))
		    end
		end
		new_entity:change_entity_attri("name", name)					-- 实体名字
		new_entity:change_entity_attri("model", model)					-- 由于npc有可能有称号，是根据名字获取的，
																		-- 所以要先对名字赋值，然后再赋值模型
		new_entity:change_entity_attri("body", body)					-- 模型id

		if new_entity.addBloodBar then
			new_entity:addBloodBar(maxHp)	--创建血条
		end
		--print('>>>>>>>>>>>> body',body)
		--deleted by shan lu 2013-11-12 reason 	缩减协议
		    -- 添加读取buff			2013-4-13
		    --local buff_count	= pack:readByte()
		    --for i=1,buff_count do
		    --	local buff 		= BuffStruct(pack)
		    --	new_entity:add_buff(buff)
		    --end

		-- 添加读取实体特效id
		local effect_count	= pack:readByte()
		for i=1,effect_count do
			local effect_type	= pack:readByte()
			local effect_id		= pack:readWord()
			local duration 		= pack:readUInt()			-- 毫秒
			new_entity:add_effect(effect_type, effect_id, duration)
		end

		local model_pos_x, model_pos_y = model:getPosition()

		local player_avatar = EntityManager:get_player_avatar();
		new_entity:setName(name_color,name,level,name_table[2])
		-- 加上主人的名字
		if master_handle ~= nil then
			new_entity:change_entity_attri("master_name",name_table[2]);
		end
		-- 宠物增加品阶
		if (is_pet and new_entity.attackSprite ) then
			new_entity:add_pet_pj( new_entity.attackSprite )
		end


		-- 宠物添加称号
		if ( is_pet and new_entity.hpStore > 0 ) then
			-- print("camp,hpStore",new_entity.camp,new_entity.hpStore)
			new_entity:add_title( new_entity.hpStore )
		end


		-- 策划要求斗法台中的自己宠物不能被点击
		-- 斗法台中宠物是Monster
		if ( SceneManager:get_cur_scene() == 1078 and player_avatar and name_table[2] == player_avatar.name ) then 
			new_entity:disable_click_event(); 
			entity_type = EntityConfig.TYPE_PLAYER_PET;
			new_entity:change_entity_attri("type", entity_type)				-- 实体类型
		end

		-- 天元之主添加特效
		if name == LangGameString[439] then -- [439]="天元城主雕像"
			local ani_table = effect_config[79];
			model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,5,ani_table[2],0,50);
		end

		-- 新手指引代码，在播放剧情动画的时候，有个需求是要隐藏掉实体.因为我是在进入副本的时候
		-- 开始播放剧情动画，而这个时候实体还没创建，所以需要在这个实体创建的方法里面添加一些代码
		-- if ( XSZYManager:get_state() == XSZYConfig.GUA_JI_ZY ) then
		-- 	if ( name == "熔岩魔" ) then
		-- 		new_entity.delayKill = true
		-- 		new_entity.model:setIsVisible(false);
		-- 	end
		-- elseif ( XSZYManager:get_state() == XSZYConfig.FENMODIAN and XSZYManager:get_step() == 1 ) then
		-- 	if ( name == "魔刀魂" ) then
		-- 		new_entity.model:setIsVisible(false);
		-- 	end
		-- elseif ( XSZYManager:get_state() == XSZYConfig.QHZ_ZY and XSZYManager:get_step() == 1 ) then
		-- 	if ( name == "黑树妖" or name == "黑心狐" ) then
		-- 		new_entity.model:setIsVisible(false);
		-- 	end
		-- elseif ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY and XSZYManager:get_step() == 1) then
		-- 	if ( name == "一阶天雷" ) then
		-- 		new_entity.model:setIsVisible(false);
		-- 	end
		-- end

		-- 如果实体是有移动目标地点的，则移动
		if tx ~= -1 and ty ~= -1 then
			new_entity:startMoveFrom(x, y, tx, ty)
		end

		-- 新产生了一个entity,通知小地图
		MiniMapModel:update_entity_point( 1, entity_handle, new_entity );

		
		-- 要根据设置系统设置，控制是否显示名称
		EntityManager:set_one_monster_show_name( new_entity )

        -- -- 根据设置系统， 是否显示其他玩家
        -- EntityManager:set_hide_other_player( new_entity )

        EntityManager:set_hide_player( new_entity )

        if ( new_entity.type == 1 ) then
        	EntityManager:set_hide_monster( new_entity );
        end
		--剧情动画接口检查是新的entity是否需要显示
        EntityManager:should_new_entity_visible(new_entity)

        -- 新手副本代码
        -- 当创建的角色名字叫界王神时触发剧情
        if SceneManager:get_cur_fuben() == 75 and new_entity.name == "界王神" then
        	local player = EntityManager:get_player_avatar();
        	if player then
        		JQDH:play_animation( 16 ) 
        	end
        end
	end
end

-- 主角出生坐标
local player_born_x = 0
local player_born_y = 0

-- 在场景上面创建主角
function GameLogicCC:do_create_player_avatar( pack )
	-- print("GameLogicCC:do_create_player_avatar")
	-- print("GameLogicCC:do_create_player_avatar------------ BEGIN")
	local handle 	= pack:readInt64()				-- 主角的handle
	local void_word	= pack:readWord()				-- 默认数据长度2，预留字段
	
	EntityManager:create_player_avatar(handle)
	-- 开始读取属性
	local player_id		= pack:readUInt()				-- 玩家id
	-- print("玩家id，",player_id);

	EntityManager:change_player_avatar_attri("handle", handle)

	EntityManager:change_player_avatar_attri("id", player_id)

	local wingData = nil
	for index,value in ipairs(EntityConfig.ACTOR_PROPERTY) do
		local attri_type  = value[1]
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
		EntityManager:change_player_avatar_attri(attri_type, attri_value)	
	end

	local show_name		= pack:readString()				-- 主角显示的名字

	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个	
	ZXLog('-----show_name------',show_name)
	local name_table = Utils:Split(show_name, "\\");
	show_name = name_table[1];  
	EntityManager:change_player_avatar_attri("name", show_name)

	-- 将人物放到场景camera中心
	local new_player 	= EntityManager:get_player_avatar()
	new_player:change_entity_attri("type", ZX_ENTITY_PLAYER_AVATAR)				-- 实体类型
	new_player:change_entity_attri("x", player_born_x)
	new_player:change_entity_attri("y", player_born_y)
	-- 最后通知引擎创建实体
	ZXLog("创建主角:", player_born_x, player_born_y)
	local model = ZXEntityMgr:sharedManager():createEntity( handle, ZX_ENTITY_PLAYER_AVATAR, 
														    player_born_x, player_born_y, 
														    new_player.body, new_player.dir, 
														    new_player.moveSpeed )
	------------------------
	---HJH 2014-9-16 新角色序列帧 modify begin
	model:setActionStept(ZX_ACTION_STEPT)
	---HJH 2014-9-16 modify end
	------------------------
	EntityManager:change_player_avatar_attri("model", model)
   
	EntityManager:change_player_avatar_attri('wing', new_player.wing)	
    

	EntityManager:change_player_avatar_attri("weapon", new_player.weapon)

	local show_name = Lang.camp_name_ex[new_player.camp] .. "#cfff000" .. show_name
	-- local show_name = "#cfff000" .. show_name
	--读取变身字段值
	local _super_id = EntityManager:get_curren_transform_id(  )
	local _super_level = EntityManager:get_curren_transform_stage(  )
	new_player.role_name_panel = TransformAvatarTitile:create_avatar_titile( new_player.QQVIP, show_name,nil,_super_id,_super_level )
    new_player.name_lab = new_player.role_name_panel.name_lab
   	local temp_panel_size = new_player.role_name_panel:getSize()
    local bill_board_node = model:getBillboardNode()
    local bill_board_node_size = bill_board_node:getContentSize()
    local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
    new_player.role_name_panel:setPosition( ( bill_board_node_size.width - temp_panel_size.width ) / 2, 0 )
	bill_board_node:addChild(new_player.role_name_panel.view)

	model:setName(show_name)
    -- 保存仙宗名字
	if ( name_table[3] ) then
		new_player:change_entity_attri("guildName",name_table[3]);
	end

	new_player:on_player_avatar_create_finish();
	EntityManager:set_avatar_hide_title(new_player)

	-----HJH 2013-9-17
	-----request qqvip
	-- print("Target_Platform................................",Target_Platform)
	--QQVIPName:game_login_qqvip_info_request()
	QQVipInterface:game_login_qqvip_info_request()

	---------查询在线占卜BUFF情况
	ZhanBuModel:get_zhanbu_buff_info()
	if PlatformInterface.init_role_info then
		PlatformInterface:init_role_info()
	end
	-- print("GameLogicCC:do_create_player_avatar------------ END")
end

-- 在场景上创建其他玩家
function GameLogicCC:do_create_other_avatar( pack )
	-- print("GameLogicCC:do_create_other_avatar")
	local player_id		= pack:readInt()				-- 玩家id
	local handle 		= pack:readInt64()				-- 玩家的handle
	
	-- 判断实体是否已经创建
	local is_exist_entity = EntityManager:get_entity(handle)
	if ( is_exist_entity ) then
		-- print("玩家已经创建.............................................................")
		return ;
	end
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	    --local is_teleport	= pack:readByte()				-- 是否传送过来的
	local x 			= pack:readInt()
	local y 			= pack:readInt()
	local tx			= pack:readInt()
	local ty 			= pack:readInt()
	local body 			= pack:readInt()
	local hp 			= pack:readUInt()
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	    --local mp 			= pack:readUInt()
	local maxHp 		= pack:readUInt()
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	    --local maxMp 		= pack:readUInt()
	local moveSpeed 	= pack:readWord()
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	local sex 			= pack:readByte()
	local job 		= pack:readByte()
	local level 		= pack:readByte()
	local weapon 		= pack:readInt()
	local mount 		= pack:readInt()
	local wing 			= pack:readUInt()
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	    --local socialMask 	= pack:readInt()
	local face 			= pack:readWord()
	local attackSpeed 	= pack:readWord()
	local dir 			= pack:readByte()
	local state 		= pack:readUInt()
	local title 		= pack:readByte()
	local camp 			= pack:readByte()
	local campPost 		= pack:readInt()
	local temp 			= pack:readInt()  -- pk模式/vip经验	
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	local teamId 		= pack:readInt()  -- 队伍id
	local QQVIP 		= pack:readInt()  -- qq vip
	local practiceEffect = pack:readInt() -- 打坐时特效
	local name_color = ZXLuaUtils:band(pack:readUInt(), 0xffffff) -- 读取角色名字颜色
	local name = pack:readString()		  -- 读取实体名称

	--done reading part one
	local pkMode 		= Utils:high_word(temp)	-- pk模式
	local vipFlag 		= Utils:low_word(temp) -- vip经验
	
	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个	
	require "utils/Utils"
	local name_table = Utils:Split(name, "\\");
	name = name_table[1];  

	-- 最后通知引擎创建实体
	-- print("GameLogicCC 创建其他玩家: ", x, y)
	 -- print("创建其他玩家", EntityConfig.ENTITY_TYPE[0], x, y, ", name:", name, ", model id:", body)
	local model = ZXEntityMgr:sharedManager():createEntity(handle, ZX_ENTITY_AVATAR , x, y, body, dir, moveSpeed)
	------------------------
	---HJH 2014-9-16 新角色序列帧 modify begin
	model:setActionStept(ZX_ACTION_STEPT)
	---HJH 2014-9-16 modify end
	------------------------
	-- 创建一个实体数据
	local new_entity 	= EntityManager:create_entity(handle, "Avatar")
	new_entity:change_entity_attri("model", model)
	new_entity:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
	local show_name 	= Lang.camp_name_ex[camp] .. "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	-- local show_name = "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	new_entity:change_entity_attri("name", name)					-- 名字 
	--显示其他人物名字
	-- model:setName(show_name)
	-- 实体类型
	new_entity:change_entity_attri("type", ZX_ENTITY_AVATAR )
	-- 为实体创建属性
	new_entity:change_entity_attri("id", player_id)				 	-- 玩家id
	new_entity:change_entity_attri("x", x)							-- 坐标X
	new_entity:change_entity_attri("y", y)							-- 坐标Y
	new_entity:change_entity_attri("body", body)			-- 模型id				
	new_entity:change_entity_attri("hp", hp)			-- 当前血量
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	    --new_entity:change_entity_attri("mp", mp)			-- 当前蓝量
	new_entity:change_entity_attri("maxHp", maxHp)		-- 最大血量
	--deleted by shan lu 2013-11-12 reason 	缩减协议    
	    --new_entity:change_entity_attri("maxMp", maxMp)		-- 最大蓝量
	new_entity:change_entity_attri("moveSpeed", moveSpeed)	-- 移动速度
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	new_entity:change_entity_attri("sex", sex)			-- 性别
	new_entity:change_entity_attri("job", job)			-- 职业
	new_entity:change_entity_attri("level", level)		-- 等级
	new_entity:change_entity_attri("weapon", weapon)		-- 武器模型
	new_entity:change_entity_attri("mount", mount)			-- 坐骑模型
	new_entity:change_entity_attri("wing", wing)			-- 翅膀模型
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	    --new_entity:change_entity_attri("socialMask", socialMask)	-- 社会关系的mask，是一些bit位
	new_entity:change_entity_attri("face", face)			-- 头像id
	new_entity:change_entity_attri("attackSpeed", attackSpeed)	-- 攻击速度
	new_entity:change_entity_attri("dir", dir)			-- 朝向
	new_entity:change_entity_attri("state", state)		-- 实体当前的状态，如打坐等
	new_entity:change_entity_attri("title", title)		-- 称号id
	new_entity:change_entity_attri("camp", camp)			-- 阵营id
	new_entity:change_entity_attri("campPost", campPost)		-- 阵营职位
	new_entity:change_entity_attri("pkMode", pkMode)	-- pk模式
	new_entity:change_entity_attri("vipFlag", vipFlag) -- vip经验
	--deleted by shan lu 2013-11-12 reason 	缩减协议
	new_entity:change_entity_attri("teamId",teamId)		-- 队伍id
	new_entity:change_entity_attri("QQVIP", QQVIP)			-- qq vip
	new_entity:change_entity_attri("practiceEffect",practiceEffect)-- 打坐时特效
	
	--deleted by shan lu 2013-11-12 reason 	缩减协议
		--[[
		-- 添加读取buff				2013-4-13
		local buff_count	= pack:readByte()
		for i=1,buff_count do
			local buff 		= BuffStruct(pack)
			new_entity:add_buff(buff)
		end
		]]--
	-- 添加读取实体特效id
	local effect_count	= pack:readByte()
	for i=1,effect_count do
		local effect_type	= pack:readByte()
		local effect_id		= pack:readWord()
		local duration 		= pack:readUInt()			-- 毫秒
		new_entity:add_effect(effect_type, effect_id, duration)
	end


	-- 是否上坐骑
	local is_shangma = not (ZXLuaUtils:band( new_entity.state , EntityConfig.ACTOR_STATE_RIDE) == 0)

	-- 添加称号
	for i=0,31 do
		local byte = pack:readByte()
		if byte ~= 0 then
			for j=0,7 do
				local have = ZXLuaUtils:isSysEnabled(byte, j)
				if have == true then
					local title_index = i * 8 + j
					new_entity:add_title(title_index, is_shangma)
				end
			end
		end
	end
	-- model创建在state之后，所以只能把天元之主的判断加在这了
	-- 上马状态暂时不增加特效
	if ( not is_shangma and ZXLuaUtils:band(state, EntityConfig.ACTOR_STATE_CASTELLAN) > 0 ) then
		-- print("-------------------------播放天元之主特效--------------------------");
		local ani_table = effect_config[79];
		local effect_node = new_entity.model:getChildByTag(79)
		if not effect_node then
			new_entity.model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
		end
	end

	-- 如果实体是有移动目标地点的，则移动
	if tx ~= -1 and ty ~= -1 then
		new_entity:startMoveFrom(x, y, tx, ty)
	end

	-- 保存仙宗名字
	if ( name_table[3] ) then
		new_entity:change_entity_attri("guildName",name_table[3]);
	end

    -- 根据设置系统， 是否显示其他玩家
    -- EntityManager:set_hide_other_player( new_entity )

    EntityManager:set_hide_player( new_entity )
	--剧情动画接口检查是新的entity是否需要显示
    EntityManager:should_new_entity_visible(new_entity)
    -- 人物变身信息显示
    -- 高16：培养阶段 低16：变身ID
    local _super_value	= pack:readInt()
	local _super_id	    = Utils:low_word(_super_value) 		
	local _super_level   = Utils:high_word(_super_value)

	new_entity.role_name_panel = TransformAvatarTitile:create_avatar_titile( QQVIP, show_name,nil,_super_id,_super_level )
    new_entity.name_lab = new_entity.role_name_panel.name_lab
   	local temp_panel_size = new_entity.role_name_panel:getSize()
    local bill_board_node = new_entity.model:getBillboardNode()
    local bill_board_node_size = bill_board_node:getContentSize()
    local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
    new_entity.role_name_panel:setPosition( ( bill_board_node_size.width - temp_panel_size.width ) / 2, 0 )
	bill_board_node:addChild(new_entity.role_name_panel.view)


	-- 是否有上坐骑，调整名字的位置
	new_entity:update_title(is_shangma)
	new_entity:update_name(is_shangma)


    -- 判断是否pk场景，如果是就隐藏称号显示仙宗
    -- print("GameLogicCC:do_create_other_avatar( pack )",new_entity.name)
     if ( SceneManager:get_is_pk_scene() ) then
    	new_entity:update_title_type( 2, is_shangma )
    	local camp_str = Lang.camp_name_ex[camp].."#c" .. Utils:c3_dec_to_hex(name_color)..new_entity.name
    	new_entity.name_lab:setText(camp_str)
    else
    	new_entity:update_title_type( 1, is_shangma )
    end

    --如果玩家设置了隐藏周边玩家的话需要隐藏掉
	EntityManager:set_hide_other_player( new_entity )
	-- 创建血条
	new_entity:addBloodBar(maxHp)
 	local curSceneId = SceneManager:get_cur_scene()
	if curSceneId == 1077 then
		-- 如果是在灵泉仙浴场景里，则隐藏所有玩家的翅膀，武器，坐骑，宠物，
		new_entity:take_off_weapon();
		new_entity:take_off_wing();
		-- 去掉脚底的影子
		new_entity:setShadowIsVisible(false)
		-- 先删除之前的特效
		-- model:stopEffect(GUANGHUAN_EFFECT_TAG);
	elseif curSceneId == 27 then
		-- new_entity:setIsVisible(false, 255)
	end
end

-- 实体消失
function GameLogicCC:do_destroy_entity( pack )
	print("s->c (0, 5) GameLogicCC:do_destroy_entity")
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
		-- EntityManager:destroy_entity(handle)

		if EntityConfig:is_monster(entity.type) then 
			if ( ZXLuaUtils:band(entity.state, EntityConfig.ACTOR_STATE_ATTACK_FORBIDEN) > 0 ) then
				EntityManager:destroy_entity(handle)
			else
				EntityManager:insert_to_delay_destroy_list(handle)
				local cb = callback:new()
				cb:start(0.35, function() EntityManager:remove_to_delay_destroy_list(handle) end)
			end
		else
			EntityManager:destroy_entity(handle)
		end
	end

end

-- 实体属性改变
function GameLogicCC:do_entity_attribute_changed( pack )
	print("GameLogicCC:do_entity_attribute_changed")
	local handle 	= pack:readUint64()
	local count 	= pack:readByte()
	-- ZXLog("do_entity_attribute_changed:start..................................");
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
		--print("GameLogicCC:do_entity_attribute_changed","attri_id",attri_id, "attri_type ===== ",attri_type,"attri_value = ",attri_value);
		if ( attri_type == "hp" ) then
			local entity = EntityManager:get_entity(handle);
			if ( entity ) then
				local dhp 	 = attri_value - entity.hp		-- 血量变化，负的为减血，正的为加血
				--print("dhp,attri_value,entity.hp",dhp,attri_value,entity.hp)
				if ( dhp < 0  ) then
					print('@@ hp change ',handle,dhp)
					GameLogicCC:play_change_blood_animation(entity,dhp)
				    -- 判断被攻击的怪物是否是当前玩家选中的目标
					if ( UserPanel:check_is_select_entity( handle ) ) then
						-- 更新主界面
						local win = UIManager:find_window("user_panel");
						if ( win ) then
							win:update_other_entity_hp_and_mp( dhp,attri_value,entity.maxHp);	
						end
					end
				end
				if entity.changeBlood and entity.maxHp ~= attri_value then
					entity:changeBlood(dhp,attri_value,entity.maxHp)
				end
				-- 如果有队伍
				if ( entity.type == 0 and #TeamModel:get_team_table() > 0 ) then
					local tab = TeamModel:get_team_table();
					for i=1,#tab do
						if ( entity.id == tab[i].actor_id) then
							MiniTaskPanel:get_miniTaskPanel():update_team_attr( entity.id,{attri_value,entity.maxHp},1);
							break;
						end
					end
				end
			end
		elseif ( attri_type == "level" ) then
			local entity = EntityManager:get_entity(handle);
			if ( entity ) then
			    -- 如果有队伍
				if ( entity.type == 0 and #TeamModel:get_team_table() > 0 ) then
					local tab = TeamModel:get_team_table();
					for i=1,#tab do
						if ( entity.id == tab[i].actor_id) then
							MiniTaskPanel:get_miniTaskPanel():update_team_attr( entity.id,{attri_value},3);
							break;
						end
					end
				end
			end
		elseif ( attri_type == "QQVIP" ) then
			-- print("GameLoginCC:do_entity_attribute_changed QQVIP")
		elseif attri_type == "practiceEffect" then
			-- print("change practiceEffect-------------------------",attri_value)
			GameLogicCC:foot_effect_change(handle, attri_value)
		elseif attri_type == "super" then
			local entity = EntityManager:get_entity(handle);
			local _super_id	    = Utils:low_word(attri_value) 		
			local _super_level   = Utils:high_word(attri_value)
			TransformAvatarTitile:reset_title_position(entity.role_name_panel,_super_id)
			if _super_id ~=0 then
				 SpecialSceneEffect:playTransformAnimate(entity)
			end
		elseif attri_type == "state" then
			if attri_value == EntityConfig.ACTOR_STATE_BATTLE then
				local entity = EntityManager:get_entity(handle);
				-- 在副本里面添加感叹号
				local fb_id = SceneManager:get_cur_fuben()
				-- print("------fb_id:", fb_id)
				if fb_id and fb_id~=0 then
					if entity.exclame_icon then
						entity.exclame_icon:removeFromParentAndCleanup(true)
						entity.exclame_icon = nil
					end
					-- 添加感叹号
					if not entity.exclame_icon then
						-- 判断是否向玩家移动(因为在副本里，不会出现其他玩家--没考虑多人副本)
						-- local player = EntityManager:get_player_avatar()
						-- local cur_dis = GameLogicCC:get_distance_twopoint( cur_x, cur_y, entity.model.m_x, entity.model.m_y)
						-- local tag_dis = GameLogicCC:get_distance_twopoint( target_x, target_y, entity.model.m_x, entity.model.m_y)
						-- 如果是向目标前进
						-- if (cur_dis-tag_dis) > 0 then
							-- TODO:: 实体移动添加感叹号
							entity.exclame_icon = MUtils:create_sprite( entity.model, "nopack/monster_state1.png", -10, entity.model:getBodyHeight() * 1.0, 1000);
							local act_1 = CCBlink:actionWithDuration(0.4, 2)
							local act_2 = CCShow:action()
							local act_3 = CCDelayTime:actionWithDuration(0.3)
							-- local act_4 = CCDelayTime:actionWithDuration(0.5)
							-- local act_4 = CCFadeIn:actionWithDuration(0.5)
							local act_5 = CCFadeOut:actionWithDuration(0.02)
							local array = CCArray:array();
							array:addObject(act_1)
							array:addObject(act_2)
							array:addObject(act_3)
							-- array:addObject(act_4)
							array:addObject(act_5)
							local seq_ = CCSequence:actionsWithArray(array);
							entity.exclame_icon:runAction( seq_)
						-- else -- 如果是向目标的反方向移动
						-- 	if entity.exclame_icon then
						-- 		entity.exclame_icon:removeFromParentAndCleanup(true)
						-- 		entity.exclame_icon = nil
						-- 	end
						-- end
					end
				end
			end
		end
		EntityManager:change_entity_attri(handle, attri_type, attri_value)
	end
end

-- 主角属性改变
function GameLogicCC:do_player_avatar_attribute_changed( pack )
	print("GameLogicCC:do_player_avatar_attribute_changed")
	local count = pack:readByte()

	local is_lv_up = false;

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
		-- print("GameLogicCC:do_player_avatar_attribute_changed attri_type,attri_value",attri_type,attri_value)

		--print("GameLogicCC:do_player_avatar_attribute_changed","attri_id",attri_id, "attri_type ===== ",attri_type,"attri_value = ",attri_value);
		-- 如果是主角掉血了要显示飘血动画
		if ( attri_type == "hp" ) then
			local player = EntityManager:get_player_avatar();
			if ( player ) then 
				local dhp = attri_value - player.hp;
				-- print("主角hp改变,dhp = ",dhp)
				if ( dhp ~= 0  ) then
					GameLogicCC:play_change_blood_animation( player,dhp );
					if dhp < 0 then
						local buniess_win = UIManager:find_visible_window("buniess_win")
						if buniess_win ~= nil then
							BuniessModel:exit_btn_function()
						end
					end
				end
			end
		elseif attri_type == "QQVIP" then
			-- print("GameLogicCC:do_player_avatar_attribute_changed QQVIP")
		elseif attri_type == "practiceEffect" then
			-- print("change practiceEffect ----------------------",attri_value)
			GameLogicCC:foot_effect_change(nil, attri_value)
		elseif attri_type == "super" then
			-- print("---------------------change变身super ----------------------",attri_value)
			local id 	  = Utils:low_word(attri_value) 		
			local stage   = Utils:high_word(attri_value)

			local player = EntityManager:get_player_avatar();
			TransformAvatarTitile:reset_title_position(player.role_name_panel,id)
			-- 添加变身技能
			UserSkillModel:handle_super_skill( id )
			if id ~= 0 then
				SoundManager:playUISound( 'transfer' , false )
			end
		elseif attri_type == "camp" then
			local  player = EntityManager:get_player_avatar();
			local  camp_str = Lang.camp_name_ex[attri_value]
			local  name_str = "#c"..player.name_color..player.name 
			 -- print("GameLogic -- 主角的属性发生变化----------------name_color,name_str",player.name_color,name_str)
		   	if ( SceneManager:get_is_pk_scene() ) then
		    	player:update_title_type( 2 )
		    	player.name_lab:setText(camp_str.. name_str)
		    else
		    	player:update_title_type( 1 )
		    	player.name_lab:setText(camp_str .. name_str)
		    end
		end
		-- ZXLog("GameLogic -- 主角的属性发生变化----------------",attri_type, attri_value);
		EntityManager:change_player_avatar_attri(attri_type, attri_value)
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
	print("GameLogicCC:do_reset_player_avatar")
	local scene_id 	= pack:readInt()
	local x 		= pack:readInt()
	local y 		= pack:readInt()
	local avatar = EntityManager:get_player_avatar()
	print("重设主角坐标:", x, y, "主角当前坐标:", avatar.model.m_x, avatar.model.m_y,avatar.state)
--	xprint('GameLogicCC:do_reset_player_avatar')

	avatar:change_entity_attri("x", x)
	avatar:change_entity_attri("y", y)
	avatar.model:stopMove(x, y)
	ZXLogicScene:sharedScene():moveCameraMap(x, y)
	--avatar:reset();
	if ( avatar.type == -1 ) then
		-- 主角的话需要停止打坐
		avatar:stop_dazuo();
		-- 停止当前动作
		avatar:stop_curr_action(  )
	end
end

-- 其他实体停止移动(包括主角，令实体停止所有的动作)
function GameLogicCC:do_entity_stop_moved( pack )
	print("GameLogicCC:do_entity_stop_moved")
	local handle 	= pack:readInt64()
	local target_x 	= pack:readInt()
	local target_y 	= pack:readInt()

	-- print("实体停止移动--屏幕坐标:", target_x, target_y)
	local entity 	= EntityManager:get_entity(handle)
	if entity ~= nil then
		-- 坐标同步
		entity:change_entity_attri("x", target_x)
		entity:change_entity_attri("y", target_y)

		-- 如果目标是玩家并且是在打坐中则不需要stop_move
		if ( entity.type == -1 or entity.type == 0 ) then
			if ( ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0 or ZXLuaUtils:band( entity.state, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0  ) then
				return;
			end
		end

		if entity.stop_move ~= nil then
			entity:stop_move(target_x, target_y)
		end
	end
end

-- 其他实体的移动
function GameLogicCC:do_entity_moved( pack )
	print("GameLogicCC:do_entity_moved")

	local handle 	= pack:readInt64()
	local cur_x 	= pack:readInt()
	local cur_y 	= pack:readInt()
	local target_x 	= pack:readInt()
	local target_y 	= pack:readInt()

	-- TODO:: 实体移动
	local entity 	= EntityManager:get_entity(handle)

	-- print("GameLogicCC entity move:", cur_x, cur_y, target_x, target_y, entity)
	if entity ~= nil and entity.startMoveFrom ~= nil then
		entity:startMoveFrom( cur_x, cur_y, target_x, target_y)
	end

end

-- 进入场景
function GameLogicCC:do_enter_scene( pack )
	print("GameLogicCC:do_enter_scene")

	local fb_id 	= pack:readWord()		-- 进入的副本id	(当副本id为零的时候，表示在世界场景，否则在副本)
	local scene_id 	= pack:readWord()		-- 进入的场景id
	local x 		= pack:readInt()		-- 跳转的像素坐标x
	local y 		= pack:readInt()		-- 跳转的像素坐标y
	local keep_walking = pack:readInt()		-- 是否继续寻路
	local scene_name = pack:readString()	-- 场景的名字
	local map_name 	= pack:readString()		-- 场景的地图名字
	-- 把地图名转换成小写
	map_name = string.lower(map_name);
	local tyc_lord 	= pack:readString()		-- 天元城城主的名字
	print("进入场景 fb_id", fb_id, 'scene_id', scene_id, 
					'x,y', x, y, 'map_name',map_name,'tyc_lord', tyc_lord)

	--进入场景前判定是否有组队副本窗口
	--create by jiangjinhong
	local  team_win = UIManager:find_visible_window("team_win")
	ZXLog("-----------------------team——win：",team_win)
	if team_win then 
		UIManager:my_hide("team_win" )
		TeamActivityMode:clear_status()
	end 

	-- 先判断该场景是否pk场景,pk场景要隐藏掉称号，然后显示仙宗名
	SceneManager:update_pk_scene( scene_id,fb_id );
    
	-- 跳转到地图的场景
	require "scene/SceneManager"
	local last_fb = SceneManager:get_cur_fuben()
	SceneManager:enter_scene(fb_id, scene_id, x, y, keep_walking, scene_name, map_name, tyc_lord)
	-- 然后需要把主角放到屏幕中间
	local player_avatar = EntityManager:get_player_avatar()
	if player_avatar then
		player_avatar.model:stopMove(x, y)
		player_avatar:change_entity_attri("x", x)
	 	player_avatar:change_entity_attri("y", y)
	 	-- 然后重置玩家的状态
	 	player_avatar:reset()

		-- local winSize		= CCDirector:sharedDirector():getWinSizeInPixels();
		-- local halfWinWidth	= winSize.width  / 2
		-- local halfWinHeight	= winSize.height / 2
		-- local cam_pos 		= ZXGameScene:sharedScene():getCameraPositionInPixels()
		-- local pos_x			= x - cam_pos.x + halfWinWidth
		-- local pos_y			= cam_pos.y - y + halfWinHeight
		-- player_avatar.model:setPosition(pos_x, pos_y)
	else
		player_born_x = x
		player_born_y = y
	end
	-- if ( fb_id == 0 ) then
	-- 	-- AIManager判断是否是自动寻路
	-- 	AIManager:CB_enter_scene();
	-- end
	-- 切换场景后询问下AIManager是否有下一步动作 
	AIManager:CB_enter_scene( false );
	-- 询问新手指引
	-- XSZYManager:on_enter_scene(  )

	--若进入每日必玩副本，则自动挂机
	if fb_id~= 0 then
		local fuben_list = FuBenModel:get_all_fuben_id()
		for i=1,#fuben_list do
			--心魔幻境第七层不自动挂机
			if fuben_list[i] == fb_id and scene_id~= 1081 then
				AIManager:set_state(AIConfig.COMMAND_FUBEN_GUAJI)
				return
			end 
		end
		if scene_id == 27 then
			AIManager:set_state(AIConfig.COMMAND_FUBEN_GUAJI)
			return
		end
	end

	-- 副本内要下坐骑
	-- if ( fb_id ~= 0 ) then 
	-- 	local is_ride = MountsModel:get_is_shangma(  );
	-- 	if ( is_ride ) then
	-- 		--MountsModel:ride_a_mount( );
	-- 	end
	-- end
	if player_avatar then
		local  camp_str = Lang.camp_name_ex[player_avatar.camp]
		local  name_str = "#c"..player_avatar.name_color..player_avatar.name 
		print("GameLogicCC:do_enter_scene(player_avatar.name_color,name_str)",player_avatar.name_color,name_str)
	   	if ( SceneManager:get_is_pk_scene() ) then
	    	player_avatar:update_title_type( 2 )
	    	player_avatar.name_lab:setText(camp_str..name_str)
	    else
	    	player_avatar:update_title_type( 1 )
	    	player_avatar.name_lab:setText(camp_str..name_str)
	    end

	    EntityManager:set_avatar_hide_title( player_avatar )
	end

	-- 从副本退出后自动做任务
	if last_fb ~= 0 and fb_id == 0 then
		local auto_quest_lv = InstructionConfig:get_auto_quest_level( )
		if player_avatar.level < auto_quest_lv then
			AIManager:do_next_quest()
		end
	end

	-- 历练副本退出时清除计时器和添加场景特效
	if last_fb == 4 then
		FuBenModel:stop_fire_effect()
	end
end

-- 实体血量变化
function GameLogicCC:do_entity_hp_changed( pack )
	-- local handle = pack:readInt64()
	-- local dhp 	 = pack:readInt()		-- 血量变化，负的为减血，正的为加血
	-- local entity = EntityManager:get_entity(handle)
	-- --print("实体掉血。。。。。。。。。。",entity.name);
	-- if ( entity ) then
	-- 	GameLogicCC:play_change_blood_animation(entity,dhp)
	-- 	local result_hp = entity.hp + dhp;
	-- 	--entity:change_entity_attri("hp", result_hp );
	-- 	--print("entity:change_entity_attri",entity.hp,dhp,handle);
	--     -- 判断被攻击的怪物是否是当前玩家选中的目标
	-- 	if ( UserPanel:check_is_select_entity( handle ) ) then
	-- 		-- 更新主界面
	-- 		local win = UIManager:find_window("user_panel");
	-- 		if ( win ) then
	-- 			win:update_other_entity_hp_and_mp( dhp,result_hp,entity.maxHp);	
	-- 		end
	-- 	end
	-- end
end

-- 播放掉血动画
function GameLogicCC:play_change_blood_animation(entity,dhp)
	print("GameLogicCC:play_change_blood_animation")

	-- 加血是绿色字，掉血是红色字
	-- 显示飘血
	--print("dhp = ",dhp);
	if ( entity ) then
		local entity_top_node = entity.model:getBillboardNode();
		local hp_str = "";
		local yOffset = entity_top_node:getPositionY()
		if ( dhp > 0 ) then
			--hp_str = "#c66ff66+"..dhp;
			TextEffect:FlowText(entity.model,yOffset,nil,FLOW_COLOR_TYPE_GREEN,'+' .. tostring(dhp), true)
		else
			--玩家或者宠物
			if entity.entity_type == EntityConfig.TYPE_PLAYER_AVATAR or 
		   	   entity.entity_type == EntityConfig.TYPE_PLAYER_PET then
				TextEffect:FlowText(entity.model,yOffset,nil,FLOW_COLOR_TYPE_YELLOW,tostring(dhp))
			else
				TextEffect:FlowText(entity.model,yOffset,nil,FLOW_COLOR_TYPE_RED,tostring(dhp))
			end

			--hp_str = "#cff0000"..dhp;


			
		end
	end
end

-- 实体受击
function GameLogicCC:do_entity_hurted( pack )
	local handle = pack:readInt64()
	-- print("GameLogicCC:do_entity_hurted handle,EntityManager:get_player_avatar().handle", handle,EntityManager:get_player_avatar().handle)

end

-- 实体死亡
function GameLogicCC:do_entity_died( pack )
	print("s->c (0, 35) GameLogicCC:do_entity_died")

	-- print("实体死亡.............................")
	local dead = pack:readInt64()
	local killer = pack:readInt64()
	local is_hit_fly = pack:readInt()

	local dead_entity = EntityManager:get_entity(dead)

	local killer_entity = EntityManager:get_entity(killer)

	-- 连斩效果刷新
	local player = EntityManager:get_player_avatar()
	local pet = EntityManager:get_player_pet()
	if (player and player.handle == killer) or (pet and pet.handle == killer) then
		ComboAttackView:show();
	end

	-- 怪物没有死亡动作，玩家的死亡动作则通过服务器下发状态来改变
	-- if dead_entity.die ~= nil then
	-- 	dead_entity:die(killer_entity)
	-- end

	if ( dead_entity ) then 
		-- for i=1,3 do
		if SceneManager:get_cur_fuben() ~= 11 then
			LuaEffectManager:addAngerValueEffect( dead_entity.model.m_x,dead_entity.model.m_y )
		end
		-- end

		-- 如果是历练副本，有怪死了就播特效
		-- if SceneManager:get_cur_fuben() == 4  then
		--     LuaEffectManager:play_get_lilian_effect( dead_entity  )
		-- end

		if dead_entity.hp > 0 then
			GameLogicCC:play_change_blood_animation(dead_entity, -dead_entity.hp)
		end

		--销毁血条
		if dead_entity.destroyBlood then
			dead_entity:destroyBlood()
		end
		if ( dead_entity.type == -2 ) then
			dead_entity:die();
		elseif dead_entity.type == 1  then
			--EntityManager:destroy_entity( dead ,true ,is_hit_fly );
			-- 播放怪物死亡动画
			dead_entity.hp = 0;
			print('is_hit_fly:', is_hit_fly)
			LuaEffectManager:play_monster_dead_effect( dead_entity ,is_hit_fly);
		-- elseif ( dead_entity.type == -1 ) then
		-- 	if ( killer_entity ) then
		-- 		dead_entity:show_resurretionDialog_dialog( killer_entity.name );
		-- 	else
		-- 		dead_entity:show_resurretionDialog_dialog( "" );
		-- 	end
			
		end
		if dead_entity.type == 1 then
			-- 新手指引判断,万剑愁挂了以后要播放剧情动画
			if ( dead_entity.name == LangGameString[440]) then -- [440]="炎魔万剑愁"
				-- 播放剧情动画
				JQDH:play_animation( 1 ) 
			elseif ( dead_entity.name == LangGameString[441]) then -- [441]="蚩尤残魂"
				JQDH:play_animation( 4 ) 
			elseif ( dead_entity.name == LangGameString[442]) then	 -- [442]="姥魔"
				JQDH:play_animation( 6 ); 
			elseif ( dead_entity.name == "云霄" ) then
				JQDH:play_animation( 8 ); 	
			elseif ( dead_entity.name == "炎帝怨念" ) then
				JQDH:play_animation( 10 ); 	
			elseif dead_entity.name == "界王神" then
				JQDH:play_animation( 17 ); 	
			elseif dead_entity.name == "守卫天将" then
				JQDH:play_animation( 15 );
			elseif dead_entity.name == "神秘小猫" then
				TransformModel:add_transform_fuben_instruction();
			end
		end
	end

	local pet = EntityManager:get_player_pet();
	if ( pet ) then
		-- 如果死亡的实体是宠物的攻击目标
		if ( dead == pet.target_id ) then
			EntityManager:get_player_pet().target_id = nil;
		end
	end
	--print(dead_entity.name,"死亡")


end

-- 实体释放技能
function GameLogicCC:do_entity_spell( pack )
	print("GameLogicCC:do_entity_spell")

	local handler 		= pack:readInt64()
	local skill_id		= pack:readWord()
	local skill_level	= pack:readByte()
	local dir 			= pack:readByte()

	local entity = EntityManager:get_entity(handler)
	if entity ~= nil then
		entity:use_skill(skill_id, skill_level, dir, handler)
	end

	LuaEffectManager:SpellEffect(skill_id,entity)
end

-- 实体瞬移
function GameLogicCC:do_entity_teleport( pack )
	print("GameLogicCC:do_entity_teleport")

	local handler 		= pack:readInt64()
	local play_effect	= pack:readInt()
	local pos_x 		= pack:readInt()
	local pos_y 		= pack:readInt()
	local dir 			= pack:readByte()
	
	--
	--print('>>>>>>>>>>>>>> do_entity_teleport',pos_x,pos_y,play_effect)
	local entity = EntityManager:get_entity(handler)

	if play_effect >= JUMPING_TELEPORT_TYPE and entity.jump then
		--
		if entity ~= nil then

			local jumpLandAction = nil
			local player = EntityManager:get_player_avatar()
			if entity == player then
				-- 如果瞬移的是主角，则移动镜头 
				jumpLandAction = function() AIManager:CB_enter_scene() end
			end

			if play_effect == JUMPING_TELEPORT_TYPE then
				entity:change_entity_attri("dir", dir)
				entity:change_entity_attri("x", pos_x)
				entity:change_entity_attri("y", pos_y)
				entity:jump(pos_x,pos_y, jumpLandAction)
			else
				entity:change_entity_attri("dir", dir)
				entity:change_entity_attri("x", pos_x)
				entity:change_entity_attri("y", pos_y)
				entity:teleportAction(play_effect, pos_x,pos_y, jumpLandAction)
			end
		end

	else
		if entity ~= nil then
			entity:change_entity_attri("dir", dir)
			entity:change_entity_attri("x", pos_x)
			entity:change_entity_attri("y", pos_y)
			entity.model:stopMove(pos_x, pos_y)

			--xprint('GameLogicCC:do_entity_teleport')
			-- print('GameLogicCC:do_entity_teleport',pos_x,pos_y)
			--self.model:playAction(ZX_ACTION_DIE, self.dir, false)
		end

		local player = EntityManager:get_player_avatar()
		-- 如果瞬移的是主角，则移动镜头 
		if entity == player then
			ZXLogicScene:sharedScene():moveCameraMap(pos_x, pos_y)
			-- 主角瞬移完要询问AIManager是否有自动要做的任务
			AIManager:CB_enter_scene()
		end
	end
end

------------------------------------------------------------
--
-- 一些跟人物无关的接口
--
------------------------------------------------------------
-- 添加一些新的窗口 29 渡劫 30 灵根 31 斗法台
-- 打开系统窗口
function GameLogicCC:do_open_window( pack )
	print("GameLogicCC:do_open_window")

	local window_id 	= pack:readByte()
	local open_or_close	= pack:readByte()
	local param 		= pack:readString()
	-- print("==========================do_open_window window_id=",window_id,"param = ",param,"open_or_close = ",open_or_close);
	local window_name	= nil
	if window_id == 0 then					
		--window_name = "bag_win"				-- 背包
	elseif window_id == 1 then
		window_name = "user_equip_win"		-- 人物属性
	elseif window_id == 2 then				
		window_name = "task_win"			-- 任务
	elseif window_id == 3 then
		window_name = "user_skill_win"		-- 技能
	elseif window_id == 4 then
		window_name = "forge_win"			-- 炼器
	elseif window_id == 5 then
		window_name = "guild_win"			-- 仙宗
	elseif window_id == 6 then
		window_name = nil					-- 寄卖
	elseif window_id == 7 then
		window_name = nil					-- 系统
	elseif window_id == 8 then
		window_name = "mall_win" 			-- 商城
	elseif window_id == 9 then
		window_name = nil					-- 弃用
	elseif window_id == 10 then
		window_name = nil					-- 弃用
	elseif window_id == 11 then
		local item_id = param
		-- TODO:: 打开一个购买的小窗口
		--BuyItemBox.getInstance().showByItemId(id,null,true,1,0,1,true)
		BuyKeyboardWin:show(item_id,nil,1);
	elseif window_id == 12 then
		window_name = nil					-- 弃用
	elseif window_id == 13 then
		-- 显示一个dialog 参数类型 标题,内容  用逗号隔开
		window_name = nil
	elseif window_id == 14 then
		window_name = nil					-- 弃用
	elseif window_id == 15 then
		-- window_name = "welcome_win"			-- 欢迎界面
		-- 屏蔽火影的欢迎界面 by hwl
		-- sevenDayAwardModel:set_first_show( true )
		-- if SceneManager:get_cur_fuben() == 75 then
		-- 	JQDH:play_animation( 13 ) 
		-- else
			window_name = "welcome_win"			-- 欢迎界面
			EventSystem.setParam('newGame',true)
		-- 	return 
		-- end
	elseif window_id == 16 then
		-- print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG window_id")
		-- -- 判断忍者任务榜支线任务是否完成
		-- local is_accepted = TaskModel:if_task_accpet(902)
		-- local is_finished = TaskModel:is_task_complete(902)

		-- print("is_accepted,is_finished",is_accepted,is_finished)

		-- if is_accepted and is_finished then
		-- 	-- 完成任务不弹
		-- else
			ZYCMWin:show(param) 				-- 任务刷星界面
		-- end 
	elseif window_id == 17 then
		--VIPDialog:show()					-- 购买速传道具对话框
		MUtils:show_vip_dialog()
	elseif window_id == 18 then
		window_name = "cangku_win" 			-- 打开仓库
	elseif window_id == 19 then
		 HSXNWin:show(param)			    --护送美女界面
	elseif window_id == 20 then
		window_name = nil					-- 还可以护送仙女次数，是否返回去接
		-- local function cb()
		-- 	GlobalFunc:ask_npc( 11,"潇月"  );
		-- end
		-- NormalDialog:show("你今天还剩下"..param.."次护送任务，是否返回天元城潇月处继续",cb,1,nil,false);
		local data = { text = string.format(Lang.activity.husong[1], param),btn_text_dict = {Lang.common.confirm[14],Lang.common.confirm[5]},npc_name = Lang.activity.husong[2],scene_id = 3}; 
		-- [443]="你今天还剩下" -- [444]="次护送任务，是否返回木叶村惠比嘶处继续" -- [445]="再来一次" -- [446]="立即传送" -- [447]="潇月"
		SysMsgDialog:show_dialog( data )
	elseif window_id == 21 then
		window_name = "tyzz_dialog"					-- 玩法与规则界面
	elseif window_id == 22 then
		-- window_name = "chat_flower_send_win"	-- 送花界面
		local win = UIManager:show_window("chat_flower_send_win");
		win:reinit_info(param);
	elseif window_id == 23 then
		MysticalShopModel:set_curr_shop_type( MysticalShopModel.OLD_SHOP )
		window_name = "mystical_Shop_win"	-- 神秘商店
	elseif window_id == 24 then
		window_name = "jptz_dialog"			-- 消费引导
	elseif window_id == 25 then
		window_name = nil					-- 打开仓库的提示界面
	elseif window_id == 26 then
		window_name = nil 					-- 打开十一抽奖界面
	elseif window_id == 27 then
		window_name = "pet_win"				-- 打开宠物界面
	elseif window_id == 28 then
		window_name = nil					-- 坐骑引导界面
	elseif window_id == 33 then				-- 淘宝树
		window_name = "new_dreamland_win"
	elseif window_id == 34 then				-- 打开云车巡游界面
		window_name = "marriage_hunche_win"
	end

	-- 暂时跳过欢迎界面。note by guozhinan
	-- if window_name == "welcome_win" then
	-- 	GameLogicCC:req_talk_to_npc(0, "startPlay")
	-- 	window_name = nil

	-- 	-- 申请第一个技能
 --        -- local job_skill_t = UserSkillModel:get_player_skills()
 --        -- UserSkillCC:request_upgrade_skill( job_skill_t[1].id, nil )
	-- end

	if window_name ~= nil then
		if open_or_close == 0 then
			local win = UIManager:show_window(window_name)
			if window_id == 33 and win then
				win:choose_tbmj_tba();
			elseif window_id == 34 and win then
				-- win:open_win_for_xunyou(true);
			end

		else
			UIManager:hide_window(window_name)
		end
	end
end

-- 申请跟npc对话
-- @ npc_handler npc的handler(如果是执行全局的函数，传0)
-- @ content 对话内容
function GameLogicCC:req_talk_to_npc( npc_handler, content )
	print("GameLogicCC:req_talk_to_npc(npc_handler,content)",npc_handler,content)
	local pack = NetManager:get_socket():alloc(0, 5)
	pack:writeUint64(npc_handler)
	pack:writeString(content)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回npc对话结果
function GameLogicCC:do_talk_to_npc( pack )
	
	local success = pack:readByte()			-- 成功与否的标记
	print("GameLogicCC:do_talk_to_npc(success)",success)
	if success then
		local handler = pack:readUint64()		-- 实体句柄
		local content = pack:readString()		-- 对话内容
		print("content",content)
		if ( content  ) then
			-- TODO::打开npc对话框并设置
			-- 判断Npc对话框有没打开，如果已经打开则不需要自动去做任务
			-- local win = UIManager:find_visible_window("npc_dialog");
			-- if ( win ) then
			-- 	return;
			-- end
			local entity = EntityManager:get_entity( handler );
		    require "../data/std_fuben"
			-- 皇陵秘境分层页面与NPC任务 区分数据解析
            local player = EntityManager:get_player_avatar()
			if entity.name==std_fuben[65].fbname then

            -- if player.level>25 then  --这种解析方式不通用 很不好 尽量和服务器共用解析
					require 'utils/MUtils'
					local tab_data = Utils:Split(content, "|"); 
		            if #tab_data > 1 then 
		            	if tab_data[4]~=nil then
		            		local tab_data2 = Utils:Split(content, ","); 
		            		local tab_data3 = Utils:Split(tab_data2[1],"|")
		            		local tab_data4 = tab_data2[2]
		            		-- if tostring(tab_data3[4]) == "CompleteMession" and tonumber(tab_data4) == 199 then  --		皇陵秘境NPC任务
		            		if tostring(tab_data3[4]) == "CompleteMession" then  --		皇陵秘境NPC任务
		            		else
			            		local zhanyifuben = UIManager:show_window("zhanyifuben_win");
		                        zhanyifuben:change_current_activity(105)
		                        return
		            		end
		            	end
		            else
		            	    --如果是OnEnterFubenFunc 首先分割\
		            	 	local str_table  = Utils:Split(content, "\\");
		            	 	if #str_table >1 then
		            	 			local temp_table = str_table[2];
									local str_temp = Utils:Split(temp_table,"@")
									local content2 = str_temp[2]
									local str_temp2 = Utils:Split(content2,",")
									local value_1 = str_temp2[1] 
									local value_2 = str_temp2[2] 
									if ( value_1 == "OnEnterFubenFunc" and tonumber(value_2)==65  ) then	
										local zhanyifuben = UIManager:show_window("zhanyifuben_win");
				                        zhanyifuben:change_current_activity(105)
				                        return
									end 
		            	 	end
		            end
		        -- end
			end

			if entity.name == FubenConfig:get_baguadigong_npc_name( ) then -- [448]="地宫传送"
				-- 地宫传送npc的对话特殊处理，不想显示平台npc对话框。
				UIManager:show_window("baguadigong_win");

				--破狱之战  如以后存在破狱之战NPC 再处理解析
			elseif entity.name==std_fuben[58].fbname then
                local zhanyifuben = UIManager:show_window("zhanyifuben_win");
                zhanyifuben:change_current_activity(107)
                return
             -- elseif entity.name==std_fuben[65].fbname then
             --    local zhanyifuben = UIManager:show_window("zhanyifuben_win");
             --    zhanyifuben:change_current_activity(105)
             --    return
             --天魔塔  如以后存在破狱之战NPC 再处理解析
            elseif entity.name == std_fuben[64].fbname   then
                local zhanyifuben = UIManager:show_window("zhanyifuben_win");
                zhanyifuben:change_current_activity(110)
                return
            -- #2 屏蔽
   --          elseif entity.name == "王城之战" then
   --          	return
			else

			-- print("entity.name=",entity.name)
				-- 各种坑爹阿，页游版10级的时候没有背包指引，手游有
				-- 所以就有了下面这段坑爹代码
				-- 在做背包指引的时候不能弹任务对话框
				-- if ( XSZYManager:get_state() ~=  XSZYConfig.BEI_BAO_ZY and 
				-- 	XSZYManager:get_state()~= XSZYConfig.NANZHAOWANG_ZY and  
				-- 	XSZYManager:get_state()~= XSZYConfig.HEILONGZHIHUN_ZY ) then
				NPCDialog:show(content,handler);
				-- end
			end
			
		else
			-- TODO::隐藏npc对话框
			--print("隐藏npc对话框")
			--UIManager:hide_window("npc_dialog")
		end
		

	else

	end

end



-- 0,33号系统 s->c:提示NPC身上是否有可接任务或者可完成任务
-- 改变npc的状态 0 没有任务 1 可以接任务 2 有任务可以在Npc上交 3 有任务在这个npc上交，但未完成
function GameLogicCC:do_npc_have_quest(pack)
	print("GameLogicCC:do_npc_have_quest")

	local npc_handle = pack:readInt64();
	local npc_type = pack:readByte();
	-- 更新npc状态
	EntityManager:change_npc_state( npc_handle,npc_type );
end
-- /**1-挥洒**/
-- public static const ON_WEAPON	 :int = 1;
-- /**2-爆炸**/
-- public static const EXPLODE	 :int = 2;
-- /**3-飞行**/
-- public static const FLY	 :int = 3;
-- /**4-投掷**/
-- public static const THROW_OUT	 :int = 4;
-- /**5-脚下持续**/
-- public static const KEEP_UNDER_FEET	:int = 5;
-- /**6-身上持续**/
-- public static const KEEP_ON_BODY	:int = 6;
-- 给目标添加特效
_effectQueue = {}
_effectQueueTimer = timer()

function GameLogicCC:target_add_effect( pack )
	local attacker_handle = pack:readInt64();
	local target_handle = pack:readInt64();
	local effect_type = pack:readByte();
	local effect_id = pack:readWord();
	local time = pack:readInt();

	local player = EntityManager:get_player_avatar();
	local effect_animation_table = effect_config[effect_id];

	print( "目标添加特效,特效type",effect_type,
		   "特效id = ",effect_id,
		   "time",time,
		   "target handle",target_handle,
		   'attacker handle',attacker_handle,
		   'player handle',player.handle,
		   'effect_animation_table',effect_animation_table );
	if attacker_handle == player.handle then
		if effect_id ~= 1602 then
			return 
		end
	end

	-- --[[
	-- if
 -- _effectQueueTimer:isIdle() then
	-- 	_effectQueueTimer:start(0.function, 0(dt) 				
	-- 		        if #_effectQueue == 0 then
	-- 		            _effectQueueTimer:stop()
	-- 		        else
	-- 		            local job = table.remove(_effectQueue,1)
	-- 		            job()
	-- 		        end
	-- 		    end)
	-- end

	-- _effectQueue[#_effectQueue+1] = function()
	-- ]]--
	-- --print("目标添加特效,特效type",effect_type,"特效id = ",effect_id,"time",time);



	if ( effect_animation_table  ) then		
		local dst_actor = EntityManager:get_entity( target_handle )
		local src_actor = EntityManager:get_entity( attacker_handle )
		--print("目标添加特效 来自",dst_actor,src_actor);
		print("--------------effect_animation_table.act_type:", effect_animation_table.act_type)
		if effect_animation_table.act_type then
			if dst_actor then
				local is_playing = LuaEffectManager:is_playing_skill( attacker_handle, effect_id)
				if not is_playing then
					LuaEffectManager:add_playing_skill( attacker_handle, effect_id, effect_animation_table)
					EffectBuilder:playEntityEffect(effect_type,
										   effect_animation_table,
										   time,
										   dst_actor,
										   src_actor,
										   effect_id)
				end
				


				-- EffectBuilder:playEntityEffect(effect_type,
				-- 							   effect_animation_table,
				-- 							   time,
				-- 							   dst_actor,
				-- 							   src_actor,
				-- 							   effect_id)
			end
		else
			if ( effect_type == 2   or effect_type == 1 or effect_type == 4 ) then
				-- local delay_cb = callback:new();
				-- print("target_handle = ",target_handle);
				-- local function cb()
					local actor = EntityManager:get_entity( target_handle )
					if actor ~= nil then
						if actor.delayKill then
							actor.model:playEffectAt( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2]);
						else
							actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2]);
						end
					end
				-- end
				-- delay_cb:start(0.9,cb);
			elseif ( effect_type == 3 ) then
				local actor = EntityManager:get_entity( attacker_handle )
				local target_entity = EntityManager:get_entity ( target_handle );
				if ( actor and target_entity ) then
					local dir = actor.dir;
					-- model 才是CCZXEntity
					actor.model:playEffect( effect_animation_table[1],effect_id,effect_type,effect_animation_table[3],target_entity.model,dir ,0,500,effect_animation_table[2]);
				end
			elseif (effect_type == 5 or effect_type == 6) then
				local actor = EntityManager:get_entity( target_handle )
				if actor ~= nil then
					actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,time,500,effect_animation_table[2]);
				end
			end
		end
	end

	SoundManager:playEffectSound(effect_id,false)
	--[[
	end
	]]--
	--print("播放技能音效:"..str)

	-- 被攻击的实体要显示受击特效
	-- local target_entity = EntityManager:get_entity(target_handle)
	-- local runing_action_num = target_entity.model:numberOfRunningActions();
	-- print("runing_action_num = ",runing_action_num)
	-- if runing_action_num == 0  then
	-- 	local attacker_entity = EntityManager:get_entity(attacker_handle)
	-- 	if attacker_entity then
	-- 		local move_x = 0
	-- 		if attacker_entity.model.m_x > target_entity.model.m_x then
	-- 			move_x = -6;
	-- 		else
	-- 			move_x = 6;
	-- 		end
	-- 		local action_time = 0.05;
	-- 		local action = CCMoveBy:actionWithDuration(action_time,CCPoint(move_x,0));
	-- 		local action_d = CCDelayTime:actionWithDuration(0.1);
	-- 		local action2 = CCMoveBy:actionWithDuration(action_time*2,CCPoint(-move_x,0));
	-- 		-- local action3 = CCMoveBy:actionWithDuration(action_time,CCPoint(move_x,0));
	-- 		-- local action4 = CCMoveBy:actionWithDuration(action_time,CCPoint(-move_x,0));
	-- 		-- local action5 = CCMoveBy:actionWithDuration(action_time,CCPoint(move_x,0));
	-- 		-- local action6 = CCMoveBy:actionWithDuration(action_time,CCPoint(-move_x,0));
	-- 		local array = CCArray:array();
	-- 		array:addObject(action);
	-- 		array:addObject(action_d);
	-- 		array:addObject(action2);
	-- 		-- array:addObject(action3);
	-- 		-- array:addObject(action4);
	-- 		-- array:addObject(action5);
	-- 		-- array:addObject(action6);
	-- 		local sequence = CCSequence:actionsWithArray(array);
	-- 		target_entity.model:runAction(sequence);
	-- 	end
	-- end
end

-- add by chj after tjxs
-- 判断时候为技能场景特效
local function is_skill_effect( effect_id )
	local skill_scene_effect_t = { 1103 }
	for k, v in pairs(skill_scene_effect_t) do
		if effect_id == v then
			return true
		end
	end 
	return false
end


-- 添加场景特效
function GameLogicCC:scene_add_effect( pack )
	
	local actor_handle = pack:readInt64();		-- 施法者handle
	local effect_type  = pack:readByte();		-- 特效类型
	local effect_id    = pack:readWord();			-- 特效id
	local pos_x        = pack:readInt();			-- 位置x
	local pos_y        = pack:readInt();			-- 位置y
	local time         = pack:readUInt();				-- 持续时间 
	local dir          = pack:readByte();
	-------------------------------------------------------
	--local dir = pack:readByte()					-- 特效类型

	print("------------------------------添加场景特效",
		"特效type = ",effect_type,
		"特效id = ",
		effect_id,
		"pos_x,pos_y,time= ",
		pos_x,pos_y,time,
		'dir',
		dir);
	-- 判断时候为技能场景特效，不播放
	-- if is_skill_effect(effect_id) then
	-- 	return 
	-- end
	local player = EntityManager:get_player_avatar();
	print("-------player:", player.x, player.y)
	if player.handle == actor_handle then
		return 
	end

	local effect_animation_table = effect_config[effect_id];

	if ( effect_animation_table  ) then
		-- local actor = EntityManager:get_entity( actor_handle )
		-- -- 重新换算Pos
		-- pos_x = pos_x - actor.x;
		-- pos_y = pos_y - actor.y;
		-- --print("换算后pos_x = ",pos_x,"pos_y = ",pos_y);
		-- if ( effect_type == 2   or effect_type == 1 ) then
		-- 	actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2]);
		-- elseif ( effect_type == 4 ) then
		-- 	actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,0,500,effect_animation_table[2],pos_x,pos_y);

		-- elseif ( effect_type == 3 ) then

		-- elseif ( effect_type == 5 or effect_type == 6) then
		-- 	actor.model:playEffect( effect_animation_table[1],effect_id, effect_type, effect_animation_table[3],nil,1,time,500,effect_animation_table[2]);
		-- end
		if effect_type == 6 then
			local ccp = CCPoint( pos_x,pos_y );
			ZXGameScene:sharedScene():mapPosToGLPos(ccp)
			-- 仙灵封印下发的是毫秒，但是这个接口是按秒来播放的，所以改一下。
			-- 可能会影响其他特效播放，但跟服务器确认过，这个协议就是毫秒单位 note by guozhinan
			LuaEffectManager:play_view_effect( effect_id,ccp.x,ccp.y,SceneManager.skyRoot,false,100,time/1000.0)
		elseif effect_type == 3 then

		else

			if effect_animation_table.act_type then
				EffectBuilder:playMapLayerEffect( effect_animation_table,
												  pos_x,pos_y,1,
												  time,
												  dir)

			else
				local ccp = CCPoint( pos_x,pos_y );
				ZXGameScene:sharedScene():mapPosToGLPos(ccp)
				LuaEffectManager:play_map_effect( effect_id,ccp.x,ccp.y,false,10000,time )
			end


		end
	end
	SoundManager:playEffectSound(effect_id,false)
end

-- 服务器要求客户端弹出一个对话框
-- s->c 0,22 
function GameLogicCC:do_message_dialog( pack )
	print("GameLogicCC:do_message_dialog")

	local data = {};
	data.npc_handle = pack:readUint64();	--npc的handle
	data.text = pack:readString();			--对话框文本
	local btn_num = pack:readByte();		--按钮数量
	data.btn_text_dict = {};				--按钮文本，可能多个
	for i=1,btn_num do
		data.btn_text_dict[i] = pack:readString();
		print("服务器要求客户端弹出一个对话框",data.btn_text_dict[i]);
	end

	data.alive_time = pack:readUInt();		--对话框的存在时间
	-- print("对话框的存在时间",data.alive_time);
	data.message_id = pack:readInt();		--消息号
	data.type = pack:readByte();			--对话框类型
	data.tip = pack:readString();			--tip
	data.icon_id = pack:readWord();		--图标id
	data.unkown = pack:readInt();			--超时后返回的按钮id，-1表示不返回
	data.has_close_btn = pack:readByte();--是否有关闭按钮

	-- require "model/FubenModel/FubenCenterModel"
	-- print("服务器要求客户端弹出一个对话框");

	FubenCenterModel:show_message_dialog( data );

end

-- 对应 0,22协议，返回对话框的操作
-- c->s 0,6
function GameLogicCC:req_message_dialog( npc_handle, btn_index, message_id )
	print("GameLogicCC:req_message_dialog")

	local pack = NetManager:get_socket():alloc(0, 6)
	pack:writeUint64(npc_handle)
	pack:writeByte(btn_index);
	pack:writeInt(message_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 服务器下发连斩cd时间
-- s->c 0,38
function GameLogicCC:do_batter_cd_time( pack )
	print("GameLogicCC:do_batter_cd_time")

	local cd_time = pack:readUInt();
	-- print("服务器下发连斩cd时间",cd_time);
end

-- 实体被暴击
function GameLogicCC:do_entity_critical( pack )
	print("GameLogicCC:do_entity_critical")

	local entity_handle = pack:readInt64();		--被暴击实体handle
	local attack_handle = pack:readInt64();		--攻击者实体handle
	local dhp           = pack:readUInt();
	-- print("---------------------------------------实体被暴击-----------------------------dhp = ",dhp);
	local entity = EntityManager:get_entity( entity_handle );
	if ( entity ) then 
		-- print("显示暴击特效...................");
		-- 显示暴击特效
		local entity_top_node = entity.model:getBillboardNode();
		--local hp_str = "#cffc000暴击-"..dhp;
		local yOffset = entity_top_node:getPositionY()
		--被打中的是玩家或宠物飘黄字
		if entity.entity_type == EntityConfig.TYPE_PLAYER_AVATAR or 
		   entity.entity_type == EntityConfig.TYPE_PLAYER_PET then
			TextEffect:FlowText(entity.model, yOffset ,'critical',FLOW_COLOR_TYPE_YELLOW,'-' .. tostring(dhp))
		else
			TextEffect:FlowText(entity.model, yOffset ,'critical',FLOW_COLOR_TYPE_RED,'-' .. tostring(dhp))

			local player = EntityManager:get_player_avatar();
			local root = ZXLogicScene:sharedScene()
			-- 如果攻击者是主角，就要震荡屏幕
			if ( attack_handle == player.handle ) then
			    local x = math.random(-4,4);
			    local y = 0;
			    local z = 0;
			    local timer = timer();
			    local index = 0;
			    local function cb()
			        z = math.random(1,4);
			        if ( z== 1 ) then 
			            x = math.random(-5,5);
			            y = math.random(-5,5);
			           -- print("x,y = ",x,y);
			            root:moveCameraMap(player.x + x, player.y + y);
			        end
			        index = index + 1;
			        if ( index == 30 ) then 
			            timer:stop();
			        end
			    end
			    timer:start(0.01,cb);
			end
		end
	end
end

-- 实体闪避
function GameLogicCC:do_entity_dodge( pack )
	print("GameLogicCC:do_entity_dodge")

	local who_dodge = pack:readByte();
	if ( who_dodge == 0 ) then
		--print("---------------------------玩家闪避攻击---------------------------");
		local entity = EntityManager:get_player_avatar();
		if ( entity ) then 
			-- 显示暴击特效
			local entity_top_node = entity.model:getBillboardNode();
			--local hp_str = "#c66ff66闪避";
			--ZXEffectManager:sharedZXEffectManager():run_blood_action(entity_top_node,hp_str,30);
			local yOffset = entity_top_node:getPositionY()
			TextEffect:FlowText(entity.model,yOffset,'dodge',FLOW_COLOR_TYPE_BLUE,'')
		end
	else
		local player = EntityManager:get_player_avatar();
		local entity = EntityManager:get_entity(player.target_id);
		if ( entity ) then 
			local entity_top_node = entity.model:getBillboardNode();
			local yOffset = entity_top_node:getPositionY()
			TextEffect:FlowText(entity.model,yOffset,'dodge',FLOW_COLOR_TYPE_BLUE,'')
			-- 显示暴击特效
			--
			--local hp_str = "#c66ff66闪避";
			--ZXEffectManager:sharedZXEffectManager():run_blood_action(entity_top_node,hp_str,30);
		end
		--print("---------------------------目标闪避玩家的攻击----------------------");
	end
end

-- 屏幕震荡
function GameLogicCC:do_screen_move( pack )
	print("GameLogicCC:do_screen_move")

	local range = pack:readByte()   --屏幕震荡的尺度
	local time = pack:readByte()	--屏幕震荡的时间 
	--print("======================屏幕震荡=======================")
	
end

-- 创建人物形象的怪物
function GameLogicCC:do_create_human_monster( pack )
	print("GameLogicCC:do_create_human_monster")

	local monster_id	= pack:readInt()				-- 怪物id
	local handle 		= pack:readInt64()				-- 怪物的handle
	local x 			= pack:readInt()
	local y 			= pack:readInt()
	local body 			= pack:readInt()
	local maxHp 		= pack:readUInt()
	local maxMp 		= pack:readUInt()
	local moveSpeed 	= pack:readWord()
	local sex 			= pack:readByte()
	local job 			= pack:readByte()
	local level 		= pack:readByte()
	local camp 			= pack:readByte()
	local weapon 		= pack:readInt()
	local face 			= pack:readWord()
	local wing 			= pack:readInt()
	local name 			= pack:readString();
	-- 到现在才能确认类型，并创建entity和赋值属性
	require "config/EntityConfig"
	local new_entity	= EntityManager:create_entity(handle, EntityConfig.ENTITY_TYPE[0])
	-- 通知引擎创建实体
	-- print("创建其他实体", EntityConfig.ENTITY_TYPE[0], x, y, ", name:", name, ", model id:", body)
	local model = ZXEntityMgr:sharedManager():createEntity(handle, ZX_ENTITY_AVATAR, x, y, body, 6, moveSpeed)

	------------------------
	--- 处理斗法台没有人物模型显示问题，模仿HJH写法补上新角色序列帧。 note by gzn 
	model:setActionStept(ZX_ACTION_STEPT)
	--- 2014-11-14
	------------------------

	if new_entity.name_lab then
		new_entity.name_lab:setText(name)
	else
		local name_lab = Label:create( nil, 0, 0, name )
		new_entity.name_lab = name_lab
		local name_lab_size = name_lab:getSize()
		local bill_board_node = model:getBillboardNode()
		bill_board_node:addChild(name_lab.view)
		local bill_board_node_size = bill_board_node:getContentSize()
	    local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
	   	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )
   end
	--model:setName(name)

	new_entity:change_entity_attri("model", model)					-- 名字 
	new_entity:change_entity_attri("id", monster_id)				 	-- 玩家id
	new_entity:change_entity_attri("x", x)							-- 坐标X
	new_entity:change_entity_attri("y", y)							-- 坐标Y
	new_entity:change_entity_attri("body", body)			-- 模型id				
	new_entity:change_entity_attri("hp", maxHp)			-- 当前血量
	new_entity:change_entity_attri("mp", maxMp)			-- 当前蓝量
	new_entity:change_entity_attri("maxHp", maxHp)		-- 最大血量
	new_entity:change_entity_attri("maxMp", maxMp)		-- 最大蓝量
	new_entity:change_entity_attri("moveSpeed", moveSpeed)	-- 移动速度
	new_entity:change_entity_attri("sex", sex)			-- 性别
	new_entity:change_entity_attri("job", job)			-- 职业
	new_entity:change_entity_attri("level", level)		-- 等级
	new_entity:change_entity_attri("camp", camp)			-- 阵营id
	new_entity:change_entity_attri("weapon", weapon)			-- 武器
	new_entity:change_entity_attri("face", face)			-- 脸
	new_entity:change_entity_attri("wing", wing)			-- 翅膀
	new_entity:change_entity_attri("name", name)					-- 名字 
	new_entity:change_entity_attri("pkMode", 4)					-- pk模式 
	new_entity:change_entity_attri("type", 0)				-- 实体类型
	
end

-- 0,40 改变实体名字
function GameLogicCC:entity_change_name( pack )
	print("GameLogicCC:entity_change_name")

	local handle = pack:readUint64();		--玩家的句柄
	local name = pack:readString();			--玩家名字
	local entity = EntityManager:get_entity( handle );
	 print("############################改变实体名字 - ", name);

	if ( entity ) then 
		local base_str = "";
		-- print("实体名字=",name)
		local name_table = Utils:Split(name,"\\");
		if ( entity.type == -2 or entity.type == 4 )then
			name = name_table[2]..LangGameString[437]..name_table[1]; -- [437]="的"
		else
			name = name_table[1];
		end
		-- -- 加上颜色
		-- if ( entity.name_color ) then
		-- 	print("entity.name_color",entity.name_color);
		-- 	name = entity.name_color..name;
		-- end
		if ( entity.camp and entity.camp < 4 and entity.camp > 0) then
			base_str = base_str .. Lang.camp_name_ex[entity.camp];
		end
		print("GameLogicCC:entity_change_name ",entity.name_color,name_table[1])
		entity:change_entity_attri( "name",name_table[1] );
		if entity.role_name_panel ~= nil then

		else
			entity.name_lab.view:setText("#c" .. entity.name_color .. name )
			local name_lab_size = entity.name_lab:getSize()
			local bill_board_node = entity.model:getBillboardNode()
			local bill_board_node_size = bill_board_node:getContentSize()
		    local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
		    entity.name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )
		end
		--entity.model:setName( "#c" .. Utils:c3_dec_to_hex(entity.name_color).. name);
		-- 玩家要更新帮派id
		if ( entity.type == -1 or entity.type == 0 ) then
			-- print("name_table[3]",name_table[3]);
			if ( name_table[3] ) then
				entity:change_entity_attri( "guildName",name_table[3] );
			else
				entity:change_entity_attri( "guildName","" );
			end
			
		end
	end
end

-- 0,37 实体改变颜色
function GameLogicCC:entity_change_name_color( pack )
	print("GameLogicCC:entity_change_name_color")

	-- print("实体改变颜色...................................")
	local handle = pack:readUint64();		--玩家的句柄
	local name_color = pack:readUInt();			--玩家名称颜色ARGB值
	local entity = EntityManager:get_entity( handle ); 
	if ( entity and entity.name) then 
		print("玩家名称改变颜色...................................",entity.name);
		local base_str = "";
		print("entity.camp = ",entity.camp);
		if ( entity.camp and entity.camp < 4 and entity.camp > 0) then
			base_str = base_str .. Lang.camp_name_ex[entity.camp];
		end
		entity:change_entity_attri("name_color",Utils:c3_dec_to_hex(name_color));
		local model_name = base_str.. "#c" .. Utils:c3_dec_to_hex(name_color) ;
		-- 如果实体是宠物，要在它的名字加上它主人的名字
		if ( entity.master_name ) then
			model_name = model_name.. entity.master_name .. "的".. entity.name ;
		else
			model_name = model_name.. entity.name;
		end
		print("model_name",model_name, entity.role_name_panel)
		if entity.role_name_panel ~= nil then
		else
			entity.name_lab.view:setText( model_name )
			local name_lab_size = entity.name_lab:getSize()
			local bill_board_node = entity.model:getBillboardNode()
			local bill_board_node_size = bill_board_node:getContentSize()
		    local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
		    -- entity.name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )
		end

		-- print("----------GameLogicCC:entity_change_name_color(pack)",entity.name)
		if ( SceneManager:get_is_pk_scene() ) then
    		-- entity.name_lab:setText(base_str)
    		--xiehande
    		entity.name_lab:setText(model_name)
    	else
    		entity.name_lab:setText(model_name)
    	end
		--entity.name_lab.view:setText( base_str..  "#c" .. Utils:c3_dec_to_hex(name_color) .. entity.name )
		--entity.model:setName( base_str..  "#c" .. Utils:c3_dec_to_hex(name_color) .. entity.name)
	end
end 

-- 目标移出特效
function GameLogicCC:target_remove_effect( pack )
	print("GameLogicCC:target_remove_effect")

	local target_handle = pack:readInt64();
	local effect_type = pack:readByte();
	local effect_id = pack:readWord();
	local entity = EntityManager:get_entity( target_handle );
	if ( entity ) then
		entity.model:removeChildByTag( effect_id ,true);
		-- -- 如果是品阶特效
		-- if ( effect_id == 89 or effect_id == 59 ) then
		-- 	UserAttrWin:update_win( "remove_pj_effect" )
		-- end
	end
end

-- 0,24公共操作结果
function GameLogicCC:do_handle_result( pack )
	print("GameLogicCC:do_handle_result")

	local result = pack:readByte();
	if result then

	end
end

function GameLogicCC:foot_effect_change(handle,value)
	print("GameLogicCC:foot_effect_change")

	local foot_index = ZXLuaUtils:lowByte(value)
	--if foot_index > 0 then
		if handle == nil then   -----mine
			handle = EntityManager:get_player_avatar_handle()
		end
		if handle == nil then
			return
		end
		local target = EntityManager:get_entity(handle)
		local effect_id = nil
		if foot_index > 0 then 
			effect_id = effect_config:index_to_foot_effect_id(foot_index)
		end
		--print("GameLogicCC:foot_effect_change effect_id", effect_id, foot_index)
		target:showFootStep(effect_id)
	--end
end

function GameLogicCC:getTimeDif()
	print("GameLogicCC:getTimeDif")
	
	if _serverTimePass and _localTimePass then
		return _localTimePass - _serverTimePass , _currentTimeDif
	else
		return 0 , 0
	end
	
end