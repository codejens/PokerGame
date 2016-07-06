------------------------------
-- 
-- 游戏状态管理器
--
------------------------------

gameStateManager = {}

--[[
	initialState 			--初始化
		updateState 		--更新
		loadingState		--游戏开始初始化
			loginState 		--登录
			gameState
	finalizeState 			--销毁
]]
local s_format = string.format
function gameStateManager:init()
	self._state = nil
	require 'gamecore.state.base_state'
	require 'gamecore.state.initial_state'
	require 'gamecore.state.update_state'
	require 'gamecore.state.SceneState'
end

function gameStateManager:setState(new_state, data)
	if self._state == new_state then
		print(s_format('%s %s','gameStateManager:setState same state', new_state.id))
		return
	end

	local old_state = self._state

	if old_state then
		print(s_format('%s:leave',old_state.id))
		old_state:leave(new_state, data)
	end
	
	self._state = new_state
	print(s_format('%s:enter',new_state.id))
	self._state:enter(old_state, data)
end

function gameStateManager:fini()
	self._state:leave()
	self._state = nil
end

function gameStateManager:onAppEvent(event, code, msg)
	if self._state and self._state.onAppEvent then
		self._state:onAppEvent(event,code,msg)
	end

	--游戏退出处理
	if event == AppDelegateEvents.eApplicationResetBegin then
		gameStateManager:setState(finalizeState)
	end
end