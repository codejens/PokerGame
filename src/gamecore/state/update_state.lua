------------------------------
-- @gameStateManager
-- 更新状态
--
------------------------------
updateState = { id = 'updateState' }

function updateState:enter(oldstate)
	--print('updateState:enter')
	baseState.enter(self)
	--TODO update
	updateState:finish()
end

function updateState:leave()
	--print('updateState:leave')
	baseState.leave(self)
end

function updateState:onTimeline()
	print('updateState:onTimeline')
end

function updateState:finish()
	-- body
	require 'gamecore.state.loading_state'
	gameStateManager:setState(loadingState)	
end