-- PlayerPet.lua
-- created by aXing on 2012-12-1
-- 游戏场景中主角宠物的实体类


PlayerPet = simple_class(Pet)

-- 记录连续移动路点(x,y,...)
local _Astar_path = {}
-- 记录当前去到哪个路点
local _current_path_index = 1
-- 记录当前动作
local _current_action = nil
-- 记录下一个动作
local _next_action = nil
-- 等待动作队列
local _waiting_queue = {}
-- 后续的动作队列
local _continue_queue = {}
-- 当前的移动目标坐标
local _cur_target_x = 0
local _cur_target_y = 0
-- 当前是否需要广播移动协议
local _need_update_move = false


function PlayerPet:__init( handle )
	--self.type = "PlayerPet"
	local function tick( dt )
		self:think(dt)
	end
	self.think_timer = timer:create()
	self.think_timer:start(t_ppet_,tick)

	-- 待机时间
	self.stand_time = 0;
	-- 使用宠物粮的cd
	self.use_pet_food_cd = ItemModel:get_item_cd_time( 19003 ) / 1000;
	-- 使用拨浪鼓的cd
	self.use_pet_toy_cd = ItemModel:get_item_cd_time( 28211 ) / 1000;
	self.is_use_pet_food = false;
	self.is_use_pet_toy = false;
	-- 启动ai
	self.pet_ai = PetAI:__init();
	self.entity_type = EntityConfig.TYPE_PLAYER_PET 
end


-- 获取动作序列的最高优先级别
local function get_action_queue_priority( queue )
	local max = ActionConfig.PRIORITY_NONE
	for k,action in pairs(queue) do
		max = math.max(max, action.priority)
	end
	return max
end


-- 实体析构
function PlayerPet:destroy(  )
	-- 停止ai
	self.pet_ai:stop_ai();
	self.think_timer:stop()
	self.target_id = nil;
	if ( _current_action ) then
		_current_action:stop_action();
		_current_action = nil;
	end
	Pet.destroy(self)
end

-- 主角属性变更函数
function PlayerPet:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	self[attri_type]	= attri_value

	-- 以下是主角属性变更的时候，触发的事件
	if attri_type == "model"  then
		self.model = ZXEntityMgr:toPlayerPet(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换player avatar出错！")
			return
		end
	elseif attri_type == "hp" then
		-- 更新主界面宠物栏
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			if ( self.hp and self.maxHp ) then
				--print("self.hp , self.maxHp",self.hp , self.maxHp);
				win:updatePetHp( self.hp , self.maxHp );
			end
		end
		-- 更新宠物界面
		local pet_struct = PetModel:get_current_pet_info(  )
		if ( pet_struct ) then
			pet_struct:change_pet_attr( 3,self.hp,true,true )
		end

	elseif attri_type == "level" then 
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			if ( old_value and self.level  ) then
				win:update_pet( 4 ,{ self.level} );
			end
		end
	elseif attri_type == "maxHp" then 
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			if ( old_value ) then
				win:updatePetHp(  self.hp , self.maxHp  );
			end
		end
		-- 更新宠物界面
		local pet_struct = PetModel:get_current_pet_info(  )
		if ( pet_struct ) then
			pet_struct:change_pet_attr( 17,self.maxHp,true,true )
		end
	elseif attri_type == "body" then
		self.body = attri_value;
		--print("宠物的body id",self.body);
		if self.model ~= nil then
			local body_effect_id = ZXLuaUtils:highByte( self.body );
			print("body_effect_id = ",body_effect_id);
			if ( body_effect_id ~= 0 ) then
				-- 先删除之前的特效
				self.model:stopEffect(10000); 
				-- 播放特效
				local ani_table = effect_config[body_effect_id]
				self.model:playEffect( ani_table[1],10000,7,ani_table[3],nil,0 ,0,0,ani_table[2]);
			end
			local body_id	= ZXLuaUtils:lowByte( self.body );
			local path = "scene/monster/"..body_id;
			self.model:changeBody( path);
		end
	end

end




-- 设置主角当前目标
function PlayerPet:set_target( target )

	if ( target == nil ) then
		self.target_id = nil;
	else

		self.target_id = target.handle;
	end
	
end

-- 设置主角面向目标
function PlayerPet:face_to_target( target )
	if target.model.m_x < self.x then
		self.dir = 6
	else
		self.dir = 0
	end
end


-- 主角思考下一步动作
function PlayerPet:think( dt )

	if ( self.model == nil )then
		return;
	end

	-- 做一些额外的同步工作
	self.x = self.model.m_x
	self.y = self.model.m_y

	if self:is_dead() then
		-- 如果死了就什么都不用想了
		if _current_action ~= nil then
			_current_action:stop_action()
			_current_action = nil
		end
		return
	end

	if _current_action == nil then
		_current_action = self:get_next_action()
	end

	if _current_action ~= nil then
		local result = _current_action:do_action()
		if result == ActionConfig.ACTION_DOING then
			
			return
		elseif result == ActionConfig.ACTION_FAIL then
			self:clean_waiting_queue()
            _current_action = nil
        elseif result == ActionConfig.ACTION_END then
        	_current_action = nil
        else
        	print("不应该到这里", result, _current_action)
        end
        -- 如果执行了任何操作，待机时间重新计算
        self.stand_time = 0;
    else
    	-- 如果当前什么都不做的话就更新待机时间
    	self:update_stand_time(dt);
	end
end


-- 添加动作队列
function PlayerPet:add_action_queue( queue )
	-- 添加进入等待队列
	self:set_waiting_queue(queue)
	-- 跟当前动作相比，如果新的动作队列优先级较高，则顶掉当前队列
	if _current_action ~= nil then
		local new_queue_priority = get_action_queue_priority(queue)
		local current_priority 	= _current_action.priority
		if current_priority < new_queue_priority then
			_current_action:stop_action()
			_current_action = nil
		-- 如果优先级别相同，而当前动作可以被打断，则打断
		elseif current_priority == new_queue_priority and _current_action.can_break then
			_current_action:stop_action()
			_current_action = nil
		end
	end
end

-- 设置等待队列
function PlayerPet:set_waiting_queue( queue )
	_waiting_queue = queue
end

-- 设置后续队列
function PlayerPet:set_continue_queue( queue )
	_continue_queue = queue
end

-- 清除队列
function PlayerPet:clean_waiting_queue(  )
	_waiting_queue = {}
end

-- 获取下一个动作
function PlayerPet:get_next_action(  )
	if _waiting_queue ~= nil then
		local ret = table.remove(_waiting_queue, 1)
		return ret;
	end
	return nil
end

-- 停止全部动作
function PlayerPet:stop_all_action(  )
--	xprint('PlayerPet:stop_all_action')
	if _current_action ~= nil then
		_current_action:stop_action()
	end
	_current_action = nil
	_waiting_queue  = {}
	-- added by aXing on 2013-3-6
	-- 停止所有动作还包括把模型当前的动作帧也停止了
	local target_x = self.model.m_x
	local target_y = self.model.m_y
	self.model:stopMove(target_x, target_y)
	
end


-- 宠物取得最近的一个攻击目标的handle
function PlayerPet:get_nearest_target()

	-- 如果挂了，就不能放技能了
	if self:is_dead() then
		return
	end

	-- 当没有目标的时候，去寻找最近的目标
	if self.target_id == nil or EntityManager:get_entity(self.target_id) == nil then
		self.target_id = EntityManager:find_nearest_target(1)
		if self.target_id == nil then
			-- 找不到目标
			return		
		end
	end

	local target = EntityManager:get_entity(self.target_id)
	self:set_target(target)
	return self.target_id;
end

-- 死亡
function PlayerPet:die(  )
	print("--------------主角宠物阵亡!---------------");
	self:stop_all_action(  )
	self:change_entity_attri( "hp", 0 );
	self.target_id = nil;
	Pet.die(self)

	-- 主界面播放宠物死亡后的cd动画
	local win = UIManager:find_window("user_panel")
	win:play_pet_cd_animation()

end

local TIME = 5;

-- 主角宠物TIME秒不动就随即动作
function PlayerPet:update_stand_time( dt )
	self.stand_time = self.stand_time + dt;
	if ( self.stand_time > TIME ) then
		self.stand_time = 0;
		-- 第一次随机都是坑爹的，第二次才是随机
		local x = math.random(0,3);
		x = math.random(1,4);
		--print("x = ",x);
		-- 随即一个数决定是移动还是待机动作 1:移动2待机
		if ( x ~= 4) then
			-- x,y不能为0
			local ran_x = math.random(1,2);
			if ( ran_x == 1 ) then
				ran_x = math.random(1,3);
			else
				ran_x = math.random(-3,-1);
			end
		
			local ran_y = math.random(1,2);
			if ( ran_y == 1 ) then
				ran_y = math.random(1,3);
			else
				ran_y = math.random(-3,-1);
			end
			local player = EntityManager:get_player_avatar();
			if player then
			CommandManager:move( player.x + ran_x * SceneConfig.LOGIC_TILE_WIDTH ,player.y + ran_y * SceneConfig.LOGIC_TILE_HEIGHT
				, true,nil,EntityManager:get_player_pet());
			end
		else
			--print("宠物待机动作");
			require "config/PetTalkConfig"
			require "UI/common/EntityDialog"
			-- x = math.random(1,26);
			local talk_word = PetTalkModel:get_pet_tald_word(  )
			EntityDialog( self.model:getBillboardNode(),talk_word );
			--self.model:playAction( 0 , self.dir);
		end

		TIME = math.random(1,6);
		--print("TIME = ",TIME);
	end

end

function PlayerPet:start_cd( pet_skill_struct ,cd )
	local skill_cd_cb = callback:new();
	local function cb_function()
		if ( pet_skill_struct ) then 
			pet_skill_struct.skill_cd = 0;
		end
	end
	skill_cd_cb:start(cd/1000,cb_function);
end

-- 设置宠物技能cd
function PlayerPet:set_skill_cd( skill_id,skill_cd )

	local pet_skill_tab,normal_skill = PetModel:get_current_fight_pet_skill_info()
	for i=1,#pet_skill_tab do
		if ( pet_skill_tab[i].skill_id == skill_id ) then
			--print("skill_cd = ",skill_cd);
			pet_skill_tab[i].skill_cd = skill_cd;
			PlayerPet:start_cd( pet_skill_tab[i] ,skill_cd )
			return;
		end
	end
	-- 如果不是技能就是普通攻击
	if ( skill_id == normal_skill.skill_id ) then
		normal_skill.skill_cd = skill_cd;
		PlayerPet:start_cd( normal_skill ,skill_cd );
	end
end

-- 取得当前技能cd
function PlayerPet:get_skill_cd( skill_id )
	local pet_skill_tab,normal_skill = PetModel:get_current_fight_pet_skill_info()
	for i=1,#pet_skill_tab do
		--print("pet_skill_tab[i].skill_id,skill_id",pet_skill_tab[i].skill_id,skill_id)
		if ( pet_skill_tab[i].skill_id == skill_id ) then
			return pet_skill_tab[i].skill_cd ;
		end
	end
	-- 如果不是技能就是普通攻击
	if ( skill_id == normal_skill.skill_id ) then
		--return normal_skill.skill_cd;
		-- 强制返回0
		return 0;
	end
	return nil;
end

-- 注册选中事件
function PlayerPet:register_click_event(  )
	
end