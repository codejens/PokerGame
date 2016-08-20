-- XianNv.lua
-- created by hcl on 2013-4-15
-- 护送仙女任务里面的仙女,它从一出生就会一直跟着主角走

XianNv = simple_class(Monster)

-- 记录连续移动路点(x,y,...)
local _Astar_path = {}
-- 记录当前去到哪个路点
local _current_path_index = 1
-- 记录当前动作
local _current_action = nil
-- 记录下一个动作
local _next_action = ZX_ACTION_IDLE
-- 等待动作队列
local _waiting_queue = {}
-- 后续的动作队列
local _continue_queue = {}
-- 当前的移动目标坐标
local _cur_target_x = 0
local _cur_target_y = 0
-- 当前是否需要广播移动协议
local _need_update_move = false


local eAnimationXianNv	= 8

function XianNv:__init( handle )
	Monster.__init(self,handle)
	
	local function tick( dt )
		self:think(dt)
	end
	self.think_timer = timer()
	self.think_timer:start(t_ppet_,tick)
	self.player = EntityManager:get_player_avatar();
	self.startPos = nil
end

-- 实体析构
function XianNv:destroy(  )
	-- 销毁仙女
	--print("................销毁仙女.....................")
	self.think_timer:stop()
	self.think_timer = nil;
	_current_action = nil;
	Entity.destroy(self)
end

-- 设置主角面向目标
function XianNv:face_to_target( target )
	if target.model.m_x < self.x then
		self.dir = 6
	else
		self.dir = 0
	end
end

function XianNv:think()


	if ( self.model == nil )then
		return;
	end



	-- 做一些额外的同步工作
	self.x = self.model.m_x
	self.y = self.model.m_y

	local isStopMoved = false

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
    else
    	isStopMoved = self:is_near_player();
	end


	if isStopMoved then
		self:stopMove()
	end

end

function XianNv:is_near_player()
	local player_tx,player_ty = SceneConfig:pos2grid( self.player.x, self.player.y );
	local other_tx,other_ty = SceneConfig:pos2grid( self.model.m_x, self.model.m_y );

	local dx = player_tx - other_tx ;
	local dy = player_ty - other_ty ;
	local distance = math.sqrt(dx * dx + dy * dy);
	--print("仙女与主角的距离",distance);
	if ( distance < 2 ) then
		return true;
	end
	local ex,ey = 0,0;
	if ( self.player._current_action == nil ) then
		if ( self.player.dir > 3 ) then
			ex = 1
		else
			ex = -1;
		end
	end 
	-- 跟随
	CommandManager:move( self.player.x + ex * SceneConfig.LOGIC_TILE_WIDTH, self.player.y , true,nil,self);
end

-- 获取动作序列的最高优先级别
local function get_action_queue_priority( queue )
	local max = ActionConfig.PRIORITY_NONE
	for k,action in pairs(queue) do
		max = math.max(max, action.priority)
	end
	return max
end

-- 添加动作队列
function XianNv:add_action_queue( queue )
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
function XianNv:set_waiting_queue( queue )
	_waiting_queue = queue
end

-- 设置后续队列
function XianNv:set_continue_queue( queue )
	_continue_queue = queue
end

-- 清除队列
function XianNv:clean_waiting_queue(  )
	_waiting_queue = {}
end

-- 获取下一个动作
function XianNv:get_next_action(  )
	if _waiting_queue ~= nil then
		local ret = table.remove(_waiting_queue, 1)
		return ret;
	end
	return nil
end


-- 实体更改自己的属性
function XianNv:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toMonster(attri_value)
		self.model:setAnimationType(eAnimationXianNv)
		self.model:registerScriptHandler(bind(XianNv.onScriptEvent,self))

		if self.model == nil then
			print("ERROR:: entity转换actor出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "body" then
		self._body_id = attri_value
		EntityManager.setNPCBody(self)

	elseif attri_type == "name" then
		-- 如果是仙灵封印里面的仙灵，则要播放剧情动画
		-- if ( SceneManager:get_cur_scene() == 1046   ) then
		-- 	if ( string.find(self.name,"仙灵") ) then 
		-- 		LuaEffectManager:play_monster_talk_with_hp( 1 ,self.handle,{0.95,0.9,0.85});
		-- 	elseif ( self.name == "赤元子" ) then
		-- 		local other_entity_handle = EntityManager:get_handler_by_sub_name( "仙灵" );
		-- 		LuaEffectManager:play_monster_talk( 2 ,self.handle,other_entity_handle,{1,2,1,2,1});
		-- 	end
		-- end
	end
end

--由Action驱动的移动事件
function XianNv:startMove(tx,ty,IdleOnStopMove)
	self.model:startMove(self.dir, 
						 self.x, self.y, 
						 tx, ty,
						 false)
end

function XianNv:onScriptEvent(id)
	--[[
	if id == eOnEntityStopMove then
		self:stopMove()
	end
	]]--
end