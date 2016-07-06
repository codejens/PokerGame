------------------------------
-- @gameStateManager
-- 初始化state 
--
------------------------------

initialState = { id = 'initialState' }

function initialState:enter(oldstate)
	print('initialState:enter')
	baseState.enter(self)
	--TODO
	self:finish()
end

function initialState:leave()
	--print('initialState:leave')
	baseState.leave(self)
end

function initialState:finish()
	gameStateManager:setState(updateState)
end