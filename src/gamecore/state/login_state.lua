------------------------------
-- @gameStateManager
-- 登录状态
--
------------------------------
loginState = { id = 'loginState' }

function loginState:enter(oldstate)
	--print('loginState:enter')
	baseState.enter(self)

  local win = GUIManager:show_window("login_win")
end

function loginState:leave()
	--print('loginState:leave')
	baseState.leave(self)
  --离开登陆界面
  GUIManager:hide_window("login_win")
end

function loginState:onTimeline()
	print('loginState:onTimeline')
end

function loginState:startGame(sid)
    gameStateManager:setState(newScenarioState, { scenario_id = 1, save_id = 255 } )
end