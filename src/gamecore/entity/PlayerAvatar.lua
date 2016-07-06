-- PlayerAvatar.lua
-- created by aXing on 2012-12-1
-- 游戏场景中主角玩家的实体类

PlayerAvatar = simple_class(Avatar)

-- 记录连续移动路点(x,y,...)
local _Astar_path	 = {}
-- 记录当前去到哪个路点
local _current_path_index = 1
-- 记录当前动作
local _current_action = nil
-- 记录下一个动作
local _next_action = nil
-- 等待动作队列
local _waiting_queue = {}

-- 当前的移动目标坐标
local _cur_target_x = 0
local _cur_target_y = 0
-- 当前是否需要广播移动协议
local _need_update_move = false
local old_selected_entity = nil;

local _player_attr_listener = {}           -- 角色属性变化的监听者  model。 要求model有 player_attr_update 方法




--主角完成创建 一些操作需要创建完主角之后才调用的
function PlayerAvatar:do_finish_create(  )
	--绑定摇杆
	--[[
    local joystick =  Joystick:getInstance()
    joystick:set_player(self)
    --]]
    --绑定摄像机
    SceneCamera:add_target( self.root )
    --申请技能
    -- SkillSystemCC:req_skill_list( )

    --创建主界面
    -- MainPanelCC:create_win()

    AIManager:init()
end


function PlayerAvatar:get_curaction()
	return _current_action
end

-- 取得是否可打断当前action
function PlayerAvatar:is_can_break_action()
	if ( _current_action and _current_action.can_break == false ) then
		return false;
	end
	return true;
end

function PlayerAvatar:get_waiting_queue()
	return _waiting_queue
end


-- 判断是否能成为目标
function PlayerAvatar:can_attack_target( target )
    -- lp todo 做各种判断。 请参考 mieshen

	return true
end

-- 公有函数

function PlayerAvatar:__init( handle )
	-- Avatar.__init(self,handle)
	self.type = -1
    -- 思考心跳
	local function tick( dt )
		self:think(dt)
	end
	self.think_timer = timer:create( )
	self.think_timer:start(  1 / 60, tick )

	-- 待机时间
	self.stand_time = 0;
	
	--目标对象handle
    self.target_id = nil
    --上一个目标
    self.old_entity = nil
    print("create playeravatar")
end


-- 实体析构(主角的一般不会调用)
function PlayerAvatar:destroy(  )
	self.think_timer:stop()
	-- AIManager:fini()
	Avatar.destroy(self)
	_Astar_path = {}
	_current_path_index = 1
	_current_action = nil
	_next_action = nil
	_cur_target_x = 0
	_cur_target_y = 0
	_need_update_move = false
	old_selected_entity = nil;

	if _current_action ~= nil then
		_current_action:stop_action()
		_current_action = nil
	end

	for i,v in ipairs(_waiting_queue) do
		v:stop_action()
	end
	_waiting_queue = {}

end


-- 主角思考下一步动作
function PlayerAvatar:think( dt )
    -- lp todo
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
		-- 如果执行了任何操作，待机时间重新计算
        self.stand_time = 0;
        
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
    	-- 如果当前是眩晕或者禁止移动状态的话
    	-- if ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_DIZZY) > 0 or 
    	-- 	ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_MOVE_FORBID) > 0 ) then
    	-- 	-- 什么也不做
    	-- else
	    --  玩家当前没动作的时候就通知AIManager
	    	AIManager:do_ai()
	    -- 	-- 如果当前什么都不做的话就更新待机时间
	    -- 	self:update_stand_time(dt);
	    -- end
	end
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
function PlayerAvatar:add_action_queue( queue )
    -- lp todo
    	-- 跟当前动作相比，如果新的动作队列优先级较高，则顶掉当前队列
	if _current_action ~= nil then
		local new_queue_priority = get_action_queue_priority(queue)
		local current_priority 	= _current_action.priority
		if current_priority < new_queue_priority then
			_current_action:stop_action()
			_current_action = nil
		-- 如果优先级别相同，而当前动作可以被打断，则打断
		elseif current_priority == new_queue_priority and _current_action.can_break then
			--print("打断当前动作..........")
			_current_action:stop_action()
			_current_action = nil
		end
	end

	-- 添加进入等待队列
	self:set_waiting_queue(queue)
end


-- 设置等待队列
function PlayerAvatar:set_waiting_queue( queue )
	_waiting_queue = queue
end

-- 清除队列
function PlayerAvatar:clean_waiting_queue(  )
	_waiting_queue = {}
end

-- 获取下一个动作
function PlayerAvatar:get_next_action(  )
	if _waiting_queue ~= nil then
		local ret = table.remove(_waiting_queue, 1)
		return ret;
	end
	return nil
end

-- 停止全部动作
function PlayerAvatar:stop_all_action(  )
	-- if _current_action ~= nil then
	-- 	_current_action:stop_action()
	-- end
	-- _current_action = nil
	-- _waiting_queue  = {}
	-- -- added by aXing on 2013-3-6
	-- -- 停止所有动作还包括把模型当前的动作帧也停止了
	-- local target_x = self.model.m_x
	-- local target_y = self.model.m_y
	-- self.model:stopMove(target_x, target_y)
	-- -- 通知服务器广播自己停止动作了
	-- MoveCC:request_stop_move(target_x, target_y, self.dir)
end

-- 停止当前动作
function PlayerAvatar:stop_curr_action()
	-- if _current_action ~= nil then
	-- 	_current_action:stop_action()
	-- end
	-- _current_action = nil
	-- _waiting_queue  = {}
	-- -- added by aXing on 2013-3-6
	-- -- 停止所有动作还包括把模型当前的动作帧也停止了
	-- local target_x = self.model.m_x
	-- local target_y = self.model.m_y
	-- self.model:stopMove(target_x, target_y)
end


--是否死亡
function PlayerAvatar:is_dead( ... )
	return false
end


-- 死亡
function PlayerAvatar:die()
	-- lp todo
	-- if ( self.model ) then
	-- 	AIManager:set_AIManager_idle();

	-- 	Avatar.die(self);
	-- end
end


-- 获取主角当前是否在做动作
function PlayerAvatar:get_doing_action_num()
	-- lp todo
	-- return self.model:numberOfRunningActions();
end





-- 重置玩家的状态
function PlayerAvatar:reset()
    -- lp todo
	
end

-- 隐身状态
function PlayerAvatar:hide_body(  )
	-- lp todo
end

-- 现身
function PlayerAvatar:show_body(  )
	-- lp todo
end

--设置玩家目标 
function PlayerAvatar:set_target_entity( entity)
	
	--选中目标相关显示
	self:show_select( entity )
	--保存新对象
	self.target_entity = entity
	--保存攻击目标
	local can_attack = self:save_target(entity)

	if not entity then
		return
	end
	-- AI处理选中后的事件
	 AIManager:on_selected_entity(self.old_entity,entity,can_attack)
end

--选中目标相关显示
function PlayerAvatar:show_select( entity )
	--隐藏旧目标的选中效果
	if self.target_entity then
		self.target_entity:draw_selecte(false)
	end
	--显示当前选中效果
	if entity then
		entity:draw_selecte(true)
	end
end

--保存攻击目标
function PlayerAvatar:save_target( target  )

	if not target then
		self.target_id = nil
		return false
	end

	local can_attack = EntityManager:can_attack_entity( target )

	self.old_entity = EntityManager:get_entity(self.target_id)

	if can_attack then 
		self.target_id = target.handle
	else
		self.target_id = nil;
	end
	return can_attack
end

--实体消失
function PlayerAvatar:other_destroy( handle )
	if handle == self.target_id then
		print("PlayerAvatar--实体消失")
		self:set_target_entity(nil)
	end
end