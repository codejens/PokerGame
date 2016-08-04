GUIManager = {}


-- module("GUIManager",package.seeall )

local _safeRemoveFromParent = cocosHelper.safeRemoveFromParent
local _UI_MAPPINGS = 
{
	login_win = { file = "ue_login_win", creator_name = "MainWin", zOrder = 1 },
	mainhall_win = { file = "ue_mainhall_win", creator_name = "MainHallWin", zOrder = 1 },
	game_win = {file = "ue_game_win",creator_name = "GameWin",zOrder = 1},
	main_win = { creator_name = "MainWin", zOrder = 1 },
	selectserver = { file = "layout/studio/selectserver/stu_select_server.lua", creator_name = "SelectServerWin", zOrder = 1 },
	role = { file = "layout/studio/role/stu_role.lua", creator_name = "RoleWin", zOrder = 1 },
	register = { file = "layout/studio/register/stu_register.lua", creator_name = "RegisterWin", zOrder = 1 },
	mainpanel = { file = "layout/studio/mainpanel/stu_main_panel.lua", creator_name = "MainPanelWin", zOrder = 1 },
	joystick =  { file = "layout/studio/joystick/stu_joystick.lua", creator_name = "Joystick", zOrder = 1 },
	common = { file = "layout/studio/common/stu_common.lua", creator_name = "CommonWin", zOrder = 1 },
	modal = { creator_name = "ModalWin", zOrder = 1000 },
	task = { creator_name = "TaskWin", zOrder = 1000 },
	test_tips = { file = "ue_test_tips" , creator_name = "TestTips", zOrder = 1000 },
	--console = { file = 'ui/console.csb', creator = GUIConsole, zOrder = 2 },
	--world_menu = { file = 'ui/worldMenu.csb', creator = GUIWorldMenu, zOrder = 3 }
}

function GUIManager:init()
	print('GUIManager:init')
	
	self._active_windows = {}
	self._cache_windows = {}
	-- self._ui_root = cc.Layer:create()
	-- safe_retain(self._ui_root)

	--cc.SpriteFrameCache:getInstance():addSpriteFrames("ui/main_ui.plist")
end

function GUIManager:onAppQuit()
	print('GUIManager:onAppQuit')
	for k, win in pairs(self._cache_windows) do
		print('close', k,win)
		win:removeFromParent(true)
		win:destroy()
		safe_release(win.core)
	end
	--_safeRemoveFromParent(self._ui_root,true)
	self._cache_windows = {}
	-- self._ui_root:removeFromParent(true)
	-- safe_release(self._ui_root)
	-- self._ui_root = nil
end

function GUIManager:switchScene(scene)
	-- self._ui_root:removeFromParent(false)
	-- scene:addChild(self._ui_root)
	self.scene = scene
	self._ui_root = scene

	-- local function xxxxxxxxxx(aa,bb)
		-- print("aa=",aa)
		-- print("bb=",bb)
	-- end
	-- print("1111111111111111")
	-- ScriptHandlerMgr:getInstance():registerScriptHandler(self._ui_root,xxxxxxxxxx,cc.Handler.EVENT_EVENT_CUSTOMINT)
end



function GUIManager:show_window(name,param)
	-- xprint('GUIManager:show_window',name)
	local win = self._active_windows[name]
	if win then
		return win 
	end

	local config = _UI_MAPPINGS[name]
	win = self._cache_windows[name]

	if not win then	
		local creator = _G[ config.creator_name ]
		creator.layout = config.file
		win = creator(param)
		win.children = {}
		self._cache_windows[name] = win
		self._active_windows[name] = win
	end
	self._ui_root:addChild(win.core,config.zOrder)
	return win
end

function GUIManager:hide_window(name, kill)
	-- print('GUIManager:hide_window',name)
	local win = self._active_windows[name]
	if kill == nil then
		kill = true
	end
	if win then
		win:unActive()
		win:removeFromParent(true)
		self._active_windows[name] = nil
		if kill then
			win:destroy()
			safe_release(win.core)
			self._cache_windows[name] = nil
		end
	end
end

function GUIManager:find_window( name )
	return self._active_windows[name]
end

function GUIManager:update_window(win_name,...)
	local win = self:find_window(win_name)
	if win then
		win:update(...)
	end
end

function GUIManager:get_ui_root(  )
	return self._ui_root
end

-- 刷新窗口
function GUIManager:reload( win_name )
	GUIManager:hide_window( win_name )
	self._active_windows[win_name] = nil
	self._cache_windows[win_name] = nil
	GUIManager:show_window( win_name )
end

-- 刷新当前窗口
function GUIManager:refresh_current_win(  )
	local win_name_t = {}
	print("self._active_windows ", self._active_windows)
	for win_name, win in pairs( self._active_windows ) do 
        table.insert( win_name_t, win_name )
	end
	
	for i = 1, #win_name_t do 
        local win_name = win_name_t[ i ]
        GUIManager:hide_window( win_name )
		self._active_windows[win_name] = nil
		self._cache_windows[win_name] = nil
		GUIManager:show_window( win_name )
	end
end