------------------------------
-- 
-- 有限状态机
--
------------------------------
FSM = simple_class()
local s_format = string.format

function FSM:__init(owner)
	self._state = nil
	self._all_states = {}
	self.owner = owner
end

function FSM:registerState(state_name, state)
	-- body
	state.name = state_name
	self._all_states[state_name] = state
end

function FSM:setState(state_name, data)
	--[[
	if self._state == new_state then
		printInfo('FSM %s %s','setState same state', new_state.id)
		return
	end
	]]--
	local new_state = self._all_states[state_name]
	local old_state = self._state
	if old_state then
		print(s_format('FSM %s:leave',old_state.name))
		old_state:leave(self,new_state, data)
	end
	self._state = new_state
	print(s_format('FSM %s:enter',new_state.name))
	self._state:enter(self,old_state, data)
end

function FSM:fini()
	self._state:leave(self,nil,nil)
	self._state = nil
end

function FSM:tick(dt)
	self._state:tick(self,dt)
end