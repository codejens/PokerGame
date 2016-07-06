------------------------------
-- @gameStateManager
-- 退出和销毁的state 
--
------------------------------

finalizeState = { id = 'finalizeState' }

function finalizeState:enter(oldstate)
	--print('finalizeState:enter')
	baseState.enter(self)

	GUIManager:onAppQuit()
	
	--默认消息处理
	callback.onAppQuit()
	timer.onAppQuit()
	
	--cocosUIHelper.onAppQuit()
	safe_retain_check()
	--通知
	--notifySystem:postNotify(cocosHelper.EVENT_APP_QUIT)
	
	--> finalizeState:leave
	gameStateManager:fini()

	resourceHelper.fini()
end

function finalizeState:leave()
	--print('finalizeState:leave')
	baseState.leave(self)
end