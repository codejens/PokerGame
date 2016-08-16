AppGameMessages = { isForeGround = true }

--程序退出，需要做回收操作
--通知脚本退出，需要对retain的CCObject做回收操作
function AppGameMessages:OnQuit(...)
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
	
	-- if Instruction then
	-- 	Instruction:onQuit()
	-- end

	if safe_retain_check then
		safe_retain_check()
	end
	collectgarbage("collect")
end

--进入后端
function AppGameMessages:OnEnterBackground(...)
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
function AppGameMessages:OnEnterForeground(...)
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
		-- if TransformModel then
		-- 	TransformModel:CheckIsCanUpdateState()
		-- end
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
	-- --print("requrie", name)
end

-- 重新加载一个模块
function AppGameMessages:reload_module(name)
	-- body
end

-- 断开连接
function AppGameMessages:close_connect_message()
	if GameStateManager then
		GameStateManager:lost_connect()
	end
end

-- 异步消息处理
function AppGameMessages.OnAsyncMessage(id, msg)

end

function AppGameMessages.OnBackClick()
	if GameStateManager then
		GameStateManager:quit()
	end
end

function AppGameMessages.OnMenuClick()
end

local function reloadWindowScript()
	if UIManager then
		UIManager:reloadAllWin()
	end
end

local showTile = false
local showMap = false
local debugEntityBB = false
local no_check_list_win = {
	"test_music",
}

function AppMessages.OnKeyEvent(key, down)
	for _ , v in pairs(no_check_list_win) do
		if UIManager and UIManager:find_visible_window(v) then
			return
		end
	end
	if not down and key == 112 then --F1
		if not showTile then
			ZXGameScene:sharedScene():showTiles()
		else
			ZXGameScene:sharedScene():hideTiles()
		end
		showTile = not showTile
	elseif not down and key == 113 then --F2
		-- if not showMap then
		-- 	UIManager:show_window("mini_map_win")
		-- else
		-- 	UIManager:hide_window("mini_map_win")
		-- end
		-- showMap = not showMap
		if SMovieClientWin then
			local is_set = SMovieClientWin:is_set()
			if is_set then
				SMovieClientWin:refresh_story()
			else
				UIManager:show_window("movieclient_win")
			end
		end
	elseif not down and key == 114 then --F3
		if UIManager then
			UIManager:show_window("movieclient_win")
		end
	end

	if NPC then
		NPC:set_dir(key, down)
	end

	if key == string.byte('B') and down then
		debugEntityBB = not debugEntityBB
		ZXEntity:enableDebugBoundingBox(debugEntityBB)
	end

	if key == string.byte('P') and down then
		-- test_effcet()
	end

	-- if UIManager then
	-- 	local win = UIManager:find_visible_window("chat_win")
	-- 	if not win then
	-- 		if key == string.byte('A') and down then
	-- 			UIManager:show_window("action_win")
	-- 		elseif key == string.byte('Z') and down then
	-- 			UIManager:show_window("effect_win")
	-- 		end
	-- 	end

	-- 	local win = UIManager:find_visible_window("action_win")
	-- 	if key == string.byte('E') and down and not win then
	-- 		require 'UIEditor/UIEditor'
	-- 		UIEditor:toggle()
	-- 	end
	-- end

	--F1
	if key == 120 and down then
		reloadWindowScript()
	end

	--F2
	if key == 13 and down and UIManager then
		local win = UIManager:find_visible_window("chat_win")
		if win then
			ChatModel:input_send_fun()
		end
		win = UIManager:find_visible_window("movieclient_win")
		if win then
			win:enter_sure_func()
		end
	end

	--F3 重新加载剧情副本配置文件
	if key ==114 and down then
		reload "../data/movie/movie_config"
	end

	--F4 重新加载主角动作文件
	if key == 115 and down then
		reload "../data/action_effects/action"
	end

	--F5
	if key == 116 and down then
		require "F5"
		reload "F5"
		reload_script()
	end

	--F6
	if key == 117 and down and UIManager then
		UIManager:init_out()
		UIManager:destroy_window("protocal_win")
		UIManager:show_window("protocal_win")
	end

	--F7
	if key == 118 and down and UIManager then
		UIManager:destroy_window("test_music")
		UIManager:show_window("test_music")
	end

	--F8
	if key == 119 and down and AIManager then
		AIManager.auto = not AIManager.auto
	end

	--F9
	if key == 120 and down then
		--reload "SGuide/SGuidePanel"
		reload "SGuide/SGPublic"
		reload "../data/client/sguide_config"
		reload "../data/mount_pos_config"
	end

	--F10
	if key == 121 and not down then
		-- print("------print(121)")
	end
end
