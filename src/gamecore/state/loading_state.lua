------------------------------
-- @gameStateManager
-- 游戏正式开始的状态
--
------------------------------
loadingState = { id = 'loadingState' }

function loadingState:enter(oldstate)
	--print('startGameState:enter')
	baseState.enter(self)
	--[[
	effectConfig:init()

	resourceManager:init()
	--本地存储
	localStorageManager:init()
	GUIManager:init()
	]]--

	reload('common.utils.init')
	reload('common.helpers.init')
	
	require "gamecore.protocol.__init"
	require "gamecore.net.__init"
	require 'gamecore.state.login_state'
	require 'gamecore.state.finalize_state'
	require 'gamecore.customshader.__init'
	require 'gamecore.ui.__init'
	require "gamecore.struct.__init"
	require "gamecore.config.__init"
	require "gamecore.model.__init"
	require "gamecore.scene.__init"
	require "gamecore.ai.__init"
	require "gamecore.entity.__init"
	require "gamecore.control.__init"
	require "gamecore.effect.__init"
	require "gamecore.action.__init"
	require "gamecore.joystick.__init"
	require "gamecore.ui.__init"
	resourceHelper.loadDependency('json/dependency.json')


	

	GUIManager:init()
	local ui_root = scene.XLogicScene:sharedScene():getUINode()
	GUIManager:switchScene( ui_root )
	self:finish()
end

function loadingState:leave()
	--print('startGameState:leave')
	baseState.leave(self)
end

function loadingState:finish()
	local _is_test_mode = helpers.CCAppConfig:sharedAppConfig():getBoolForKey("test_mode")
	if _is_test_mode then
		require 'gamecore.state.test_state'
		gameStateManager:setState(testState)
	else
		gameStateManager:setState(loginState)	
	end
end