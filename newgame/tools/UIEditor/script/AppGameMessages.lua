AppGameMessages = {isForeGround = true}

--程序退出，需要做回收操作
--通知脚本退出，需要对retain的CCObject做回收操作
function AppGameMessages:OnQuit()
	--析构Login窗口
	if RoleModel then
		RoleModel:destroy_login_win()
	end
	--删除UI管理器
	if UIManager then
		UIManager:OnQuit()
	end
	--检查释放
	if CheckWindowRelease then
		CheckWindowRelease()
	end
	
	--释放单例Slot效果
	if SlotEffectManager then
		SlotEffectManager.release_slot_effect()
	end
	
	if EntityManager then
		EntityManager:OnQuit()
	end
	
	if SpecialSceneEffect then
		SpecialSceneEffect:destory()
	end

	if CenterNoticItem_OnQuit then
		CenterNoticItem_OnQuit()
	end

	if Cinema then
		Cinema:OnQuit()
	end

	if EffectBuilder then
		EffectBuilder.onQuit()
	end
	
	if UIEditor then
		UIEditor:onQuit()
	end
	
	if Instruction then
		Instruction:onQuit()
	end

	if safe_retain_check then
		safe_retain_check()
	end
	collectgarbage("collect")
end

--进入后端
function AppGameMessages:OnEnterBackground()
	if Analyze then
		Analyze:fini()
	end
	if SceneManager then
		SceneManager:onPause()
	end
	if SceneEffectManager then
		SceneEffectManager:onPause()
	end
	ZXGameScene:sharedScene():onPause()
	collectgarbage("collect")
	AppGameMessages.isForeGround = false
	--dump_texture()
end

--
function AppGameMessages:OnEnterForeground()
	local c = callback:new() 
	--下一帧在执行
	c:start(0.1, function () 
		--切换到前端
		AppGameMessages.isForeGround = true

		--恢复场景特效
		if SceneManager then
			SceneManager:onResume()
		end

		if SceneEffectManager then
			SceneEffectManager:onResume()
		end
		
		--恢复到前端的时候，发包检查在线情况进入前端
		if GameStateManager then
			GameStateManager:request_check_online()
		end
		--重新刷地表
		if GameStateManager and GameStateManager:get_state() == 'scene' then
			ZXGameScene:sharedScene():onResume()
		end

		-- if QQVIPName then
		-- 	QQVIPName:get_qqvip_request_info()
		-- end
		if QQVipInterface then
			QQVipInterface:game_login_qqvip_info_request()
		end
		--dump_texture()
		-- 检测是否需要更新变身倒计时
		if TransformModel then
			TransformModel:CheckIsCanUpdateState()
		end
	end)
end

function AppGameMessages.OnRemoteDebugger(sz)

end

-- 第一次加载一个模块，开始加载前
function AppGameMessages:before_require(name)
	-- body
end

-- 第一次加载一个模块，完成加载后
function AppGameMessages:after_require(name)
	-- print("requrie", name)
end

-- 重新加载一个模块
function AppGameMessages:reload_module(name)
	-- body
end

-- 断开连接
function AppGameMessages:close_connect_message()
	GameStateManager:lost_connect()
end

-- 异步消息处理
function AppGameMessages.OnAsyncMessage(id, msg)
end

function AppGameMessages.OnBackClick()
	ZXLog('OnBackClick')
	GameStateManager:quit()

end

function AppGameMessages.OnMenuClick()
	ZXLog('OnMenuClick')
end

local function reloadWindowScript()
	UIManager:reloadAllWin()
end

local showTile = false
local showMap = false
local debugEntityBB = false
function AppMessages.OnKeyEvent(key, down)
	print("按键", key, down)

	if not down and key == 112 then --F1
	elseif not down and key == 113 then --F2
	elseif not down and key == 114 then --F3
	elseif not down and key == 115 then --F4
	elseif not down and key == 116 then --F5
		reloadWindowScript()
	elseif not down and key == 117 then --F6
	elseif not down and key == 118 then --F7
	elseif not down and key == 119 then --F8
	elseif not down and key == 120 then --F9
	end

	if UIEditor then
		UIEditor:onKeyEvent(key,down)
	end

	if key == string.byte('E') and down then
		require 'UIEditor/UIEditor'
		UIEditor:toggle()
	end
end