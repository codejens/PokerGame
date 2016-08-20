-- ActionBase.lua
-- created by aXing on 2013-1-17
-- 主角行为基类

ActionBase = simple_class()

-- require "action/ActionConfig"
-- require "entity/EntityManager"


function ActionBase:__init()
	self.priority 	= ActionConfig.PRIORITY_ONE		-- 动作优先级
	self.can_break	= false							-- 是否能被打断
	self.duration	= 0
	self.end_time	= 0								-- 动作结束时间
	self.state		= ActionConfig.ACTION_READY		-- 动作状态
	self.player		= EntityManager:get_player_avatar()		-- 拿到主角
	self.is_need_duration = true;
end

function ActionBase:failed()
	return self.state == ActionConfig.ACTION_FAIL	
end

-- 执行这个行为
function ActionBase:do_action(  )
	if self.state == ActionConfig.ACTION_END or self.state == ActionConfig.ACTION_FAIL then
		return self.state
	end
	-- print("self.class_name",self.class_name,self.state)

	if self.state == ActionConfig.ACTION_READY then		-- 如果动作处于就绪状态
		if self:can_do() then
			self:start_action()

			if ( self.is_need_duration ) then	
				if self.duration >= 0 then
					self.end_time = GameStateManager:get_total_milliseconds() + self.duration

				else
					self.end_time = GameStateManager:get_total_milliseconds()
				end
			end
		else
			self:stop_action()
			return self.state
		end
	end

	if ( self.is_need_duration ) then
		if GameStateManager:get_total_milliseconds() - self.end_time >= 0 then
			self:end_action()
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

-- 动作朝向
function ActionBase:face_to( tx, ty )
	-- local dx = math.floor(self.player.x - tx)
	-- local dy = math.floor(self.player.y - ty)
	-- if dx ~= 0 or dy ~= 0 then
	-- 	local new_angle = math.atan2(dy, dx)
	-- 	local angle 	= math.deg(new_angle + math.pi / 2)
	-- 	self.player.dir = (1 - angle / 360) * 8 % 8			
	-- end
	self.player:face_to(tx, ty)
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