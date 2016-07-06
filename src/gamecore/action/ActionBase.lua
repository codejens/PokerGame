-- ActionBase.lua
-- created by aXing on 2013-1-17
-- 主角行为基类

ActionBase = simple_class()


function ActionBase:__init()
	self.priority 	= ActionConfig.PRIORITY_ONE		-- 动作优先级
	self.can_break	= false							-- 是否能被打断

	self.state		= ActionConfig.ACTION_READY		-- 动作状态

	self.player =  EntityManager:get_player_avatar(  ) --默认是玩家
end

-- 执行这个行为
function ActionBase:do_action(  )
	if self.state == ActionConfig.ACTION_END or self.state == ActionConfig.ACTION_FAIL then
		return self.state
	end

	if self.state == ActionConfig.ACTION_READY then		-- 如果动作处于就绪状态
		if self:can_do() then
			self:start_action()

		else
			self:stop_action()
			return self.state
		end
	end


	return self.state
end

-- 开始行为
function ActionBase:start_action(  )
	self.state = ActionConfig.ACTION_DOING
	self:_on_start()
end

-- 终止行为
function ActionBase:stop_action(  )
	self.state = ActionConfig.ACTION_FAIL
	self:_on_fail()
end

-- 正常终止
function ActionBase:end_action(  )
	self.state = ActionConfig.ACTION_END
	self:_on_end()
end

-- 以下函数由子类实现，不应手动调用
-- 判断条件
function ActionBase:can_do(  )
	return true
end

-- 在行为将要开始前被调用
function ActionBase:_on_start(  )
	
end

-- 在行为失败时被调用
function ActionBase:_on_fail(  )
	
end

-- 在行为正常结束时被调用
function ActionBase:_on_end(  )
	
end