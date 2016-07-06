------------------------------
-- @gameStateManager
-- 选服状态
--
------------------------------
selectServerState = { id = 'selectServerState' }

function selectServerState:enter(oldstate)
	--print('loginState:enter')
	baseState.enter(self)

	  --创建登录场景
  	--local sceneLogin = cc.Scene:create()
  	--切换创景
    --cocosHelper.setScene(sceneLogin)
    --GUI切换场景
    --GUIManager:switchScene(sceneLogin)



    local win = GUIManager:show_window('selectserver')
    -- win:addTouchEventListener('login_btn',_login_func)
    -- win:addTouchEventListener('logout_btn',_logout_func)
end

function selectServerState:leave()
	--print('loginState:leave')
	baseState.leave(self)
  --离开登陆界面
  GUIManager:hide_window('selectserver')
end

function selectServerState:onTimeline()
	print('loginState:onTimeline')
end

function selectServerState:startGame(sid)
    --gameStateManager:setState(newScenarioState, { scenario_id = 1, save_id = 255 } )
end