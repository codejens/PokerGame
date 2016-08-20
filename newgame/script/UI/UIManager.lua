--UIManager.lua
--UI管理

super_class.UIManager()

--UI窗口出现范围(LEFT, RIGHT, ALL)
local WINDOW_APPEAR_LEFT	= 4 			-- 该面板出现在屏幕左边
local WINDOW_APPEAR_RIGHT	= 6 			-- 该面板出现在屏幕右边
local WINDOW_APPEAR_ALL		= 5 			-- 该面板是覆盖全画面
local WINDOW_DIALOG 		= 100 			-- 以dialog的方式出现在中间
local WINDOW_DIALOG_MODAL	= 200 			-- 模态dialog方式出现在中间
local WINDOW_DIALOG_RIGHT   = 300	        -- 以dialog的方式出现在右边
local WINDOW_DIALOG_TJXS 	= 301			-- 天将雄狮后添加
local WINDOW_DIALOG_NOTMAIN = 302			-- 以dialog出现, 但屏蔽掉主界面UI
local WINDOW_APPEAR_MIDDLE	= 400 			-- 类WINDOW_APPEAR_ALL,但是不屏蔽主窗口UI

--UI关闭方式
--如果 close_type == nil 时 == CLOSE_DESTORY
local CLOSE_HIDE			= 1 			-- 窗口关闭只隐藏
local CLOSE_DESTORY			= 2 			-- 窗口关闭销毁

local _current_left_window	= nil 			-- 出现在屏幕左边的界面的名字
local _current_right_window	= nil 			-- 出现在屏幕右边的界面的名字
local _current_all_window 	= nil 			-- 出现在全屏幕的界面的名字

local _ui_windows = {}						-- 记录已创建窗口
local _ui_windows_shown = {}				-- 记录正在显示的窗口
local _ui_dialogs_shown = {}				-- 记录正在显示的dialog
local _main_window = {}                     --主要窗口

--求相对屏幕大小的函数
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

--全屏大小
local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

--半屏大小
local _ui_half_width = _ui_width * 0.5
local _ui_half_height = _ui_height * 0.5

--定义大窗口与中形窗口坐标与位置
-- local _big_win_info = { x = 10, y = 35, width = 917, height = 628, texture = 		UIPIC_WINDOWS_BG }
-- local _mid_win_info = { x = 400, y = 48, width = 457, height = 607, texture =  		UIPIC_WINDOWS_BG }
-- local _left_mid_win_info = { x = 3, y = 39, width = 457, height = 607, texture = 	UIPIC_WINDOWS_BG }
-- local _right_mid_win_info = { x = 403, y = 39, width = 457, height = 607, texture = UIPIC_WINDOWS_BG }

--新风格界面 窗口坐标与位置
-- local _left_mid_win_new = { x = 10, y = 35, grid = true, width = 457, height = 619, texture =   UIPIC_WINDOWS_BG }
-- local _right_mid_win_new = { x = 401, y = 35, grid = true, width = 457, height = 619, texture = UIPIC_WINDOWS_BG }
local _big_mid_win_new = { x = 35, y = 35, grid = true, width = 917, height = 640, texture = UIPIC_WINDOWS_BG }
-- local _normall_mid_win = { x = 35, y = 35, grid = true, width = 917, height = 640, texture = "" }
local _left_mid_win_info_lion = { x = 10, y = 10, grid = true,width = 435, height = 630, texture =   "",title_bg =UIPIC_COMMOM_title_bg }
local _right_mid_win_info_lion = { x = 401-25, y = 10, grid = true,width = 500, height = 630, texture ="",title_bg =UIPIC_COMMOM_title_bg  }
-- local _big_win_info_lion = { x = 30, y = 10, grid = true,width = 900, height = 630, texture = "",title_bg =UIPIC_COMMOM_title_bg  }

--窗口定义
-- local _big_win = {x=10,y=10,grid=true,width = 960, height = 640,texture = ""}
-- local _normall_win = {x=10,y=10,grid=true,width = 960, height = 640,texture = ""}
-- local _left_win = {x=10,y=10,grid=true,width = 470, height = 640,texture = ""}
-- local _right_win = { x = 401-25, y = 10, grid = true,width = 460, height = 630, texture ="",title_bg =UIPIC_COMMOM_title_bg  }
-- local _hui_win = {x=0,y=0,grid=true,width = _refWidth(1.0), height = _refHeight(1.0), texture = "nopack/xszy/zezhao1.png"}
--山海经继承老界面
-- local old_right_win = {x = 300, y = 15, grid = true,width = 493, height = 621, texture ="" }
-- local _big_win_info_win = { x = 40, y = 0, grid = true,width = 910, height = 615, texture = ""}
--初始化主界面标志位
local _firstShowMainUI = true
--主界面是否处于显示状态
local _isShowMainUI = true
--主界面Panels
local _mainUIPanels = {}
local _mainUIPanels_dict = {}
--主界面Actions
local _mainUIShowActions = {}
--主界面是否初始化完毕
local _mainUIReady = false
--主界面Action的Tag
local _mainUIShowActionTag = 1
--黑背景的Tag
local _backSpriteTag = 2
--安全删除控件, 移除之前调用autorelease
local _safeRemoveChild = CocosUtils.safeRemoveChild
local _safeRemoveFromParentAndCleanup = CocosUtils.safeRemoveFromParentAndCleanup

local WINDOW_STYLE = {
	[WINDOW_APPEAR_LEFT]  = _left_mid_win_info_lion,
	[WINDOW_APPEAR_RIGHT] = _right_mid_win_info_lion,
	[WINDOW_APPEAR_ALL]   = _big_mid_win_new,
}


local _show_history_record = {}
local _no_close_win = {
	"mainhall_win",
	"screen_notic_win",
	"center_notic_win",
	"screen_run_notic_win",
}
-- function UIManager:get_cur_win()

-- 	return  _current_left_window, _current_right_window, _current_all_window
-- end

-- function UIManager:get_big_win_create_info()
-- 	return _big_mid_win_new
-- end

-- function UIManager:get_new_big_win_create_info()
-- 	return _big_win_info_lion
-- end

-- function UIManager:get_min_win_create_info()
-- 	return _mid_win_info_new
-- end

-- function UIManager:get_left_mid_win_create_info()
-- 	return _left_mid_win_info
-- end

-- function UIManager:get_right_mid_win_create_info()
-- 	return _right_mid_win_info_new
-- end

--UI根节点	
local _ui_root = nil
local _ui_dict = {}

require "UI/script_reload"
local SCRIPT_PATH = script_reload.SCRIPT_PATH

local function _init()
	_ui_dict = {

	--登录框
	login_win  = {class = loginWin,config = "login_win", texture = "nopack/login_bgp.jpg", z = Z_ACTIVE_WINDOW,appear_type = WINDOW_APPEAR_ALL, close_type = CLOSE_DESTORY , width = _refWidth(1.0), height = _refHeight(1.0) },	
	--跑马灯
	screen_notic_win = {class = ScreenNoticWin, x = 0, y = 0, z = Z_TOOLTIP+1 },
	--主屏公告
	center_notic_win = {class = CenterNoticWin, x = 0, y = 0, z = Z_ACTIVE_WINDOW, },	
	screen_run_notic_win = {class = ScreenRunNoticWin, texture = "", z = Z_TOOLTIP},
	alert_win = {class = AlertWin, texture = "", x = 0, y = 0, z = Z_TOOLTIP, width = _ui_width, height = _ui_height, },
	
	--只有一句文字的对话框
	normal_dialog = {class = NormalDialog,texture = nil,x = 235,y = 140, z =Z_DIALOG_START,width = 416,height=331, appear_type =WINDOW_DIALOG,grid=true},
	--系统消息提示框
	sysmsg_dialog = {class = SysMsgDialog, texture = "nopack/blocked.png", width = _refWidth(1.0), height = _refHeight(1.0), x = 0, y = 0, z = Z_TOOLTIP, appear_type = WINDOW_DIALOG},
		
	mainhall_win = {config = "ue_mainhall_win",texture = "nopack/hall_function_bg.jpg", class = MainHallWin, appear_type = WINDOW_APPEAR_ALL,  width = _refWidth(1.0), height = _refHeight(1.0)},	
	game_win = {config = "ue_game_win",texture = _big_mid_win_new.texture, class = GameWin, appear_type = WINDOW_APPEAR_ALL, width = _refWidth(1.0), height = _refHeight(1.0) ,no_block = true},	
	
	room_list_win = {config = "ue_room_list_win",texture = "nopack/chuji_bg.jpg", class = RoomListWin, appear_type = WINDOW_APPEAR_ALL,  width = _refWidth(1.0), height = _refHeight(1.0),no_block = true },	
	}
end

--生成一个拖拽图标
function UIManager:create_drag_item(icon, point_x, point_y)
	if self.drag_item ~= nil then
		UIManager:destory_drag_item()
	end
	self.drag_item = DragItem(48, 48)
	self.drag_item.view:setEnableHitTest(false)  
	self.drag_item:set_icon_texture(icon)
	self.drag_item:setAnchor(0.5, 0.5)
	self.drag_item:setPosition(point_x,point_y)
	_ui_root:addChild(self.drag_item.view,999)
	self.drag_item.view:setCurState(CLICK_STATE_DOWN)
	--动画效果
	local scale_act = CCScaleBy:actionWithDuration(0.1, 1.6)
	self.drag_item.view:runAction(scale_act)
end

--销毁拖拽图标
function UIManager:destory_drag_item()
	if self.drag_item ~= nil then 
		_safeRemoveFromParentAndCleanup(self.drag_item.view, true)
		self.drag_item = nil
	end
end

--根据关闭状态删除窗口
local function close_window(name)
	if name == nil then
		return 
	end
	if UIManager:find_visible_window(name) then
		local window = _ui_dict[name]
		if window and (window.close_type == nil or window.close_type == CLOSE_DESTORY) then
			print("destroy name=",name)
			UIManager:destroy_window(name)
		else
			print("hide name=",name)
			UIManager:hide_window(name)
		end
	end
end

local function delay_close_window( name )
	if name == nil then
		return 
	end
	
	if _show_history_record[#_show_history_record] == name then
		local win = UIManager:find_window(name)
		if win then
			win.view:setIsVisible(false)
		end
		return
	end

	local is_insert = false
	for i=1,#_show_history_record do
		if name == _show_history_record[i] then
			table.remove(_show_history_record,i)
			table.insert(_show_history_record,name)
			is_insert = true
		end
	end

	if not is_insert then
		table.insert( _show_history_record, name )
	end

	if #_show_history_record > 3 then
		local w_name = table.remove(_show_history_record,1)
		if UIManager:find_visible_window(name) then
			local window = _ui_dict[name]
			if window and window.close_type == CLOSE_DESTORY then
				UIManager:destroy_window(name)
			else
				UIManager:hide_window(name)
			end
		end
	else
		local win = UIManager:find_window(name)
		if win then
			win.view:setIsVisible(false)
		end
	end
end

--将窗口置中
local function bring_window_center(window)
	UIScreenPos.screen9GridPosWithAction(window, 5)
end

--将窗口置前
local function bring_window_front(window, z_order)
	_safeRemoveChild(_ui_root, window.view, false)
	_ui_root:addChild(window.view, z_order)
end

--自动生成窗口标题和关闭按钮
local function create_title_and_close_button(window, window_name, window_info)
	if window_info.appear_type then
		local spr_bg_size = window.view:getSize()
		if window_info.not_close_btn ~= true then
			local function btn_close_fun(eventType,x,y)
				if window_info.close_type == CLOSE_HIDE then
		        	UIManager:hide_window( window_name )
		        elseif not window_info.close_type or window_info.close_type == CLOSE_DESTORY then 
		        	UIManager:destroy_window( window_name )
		        end
		        SoundManager:play_ui_effect( 3 )
		    end
		  	window.exit_btn = ZButton:create(window.view, "sui/common/close.png", btn_close_fun, 0, 0, -1, -1, 1002)	
		    local exit_btn_size = window.exit_btn:getSize()
		    if window_info.appear_type == WINDOW_DIALOG then
		    	window.exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width , spr_bg_size.height - exit_btn_size.height)	
		   	else  
		    	window.exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height -exit_btn_size.height+2)
			end 
		end 
    end
end

--UI管理器初始化
function UIManager:init(root)
	_ui_root = root:getUINode()
	local function ui_main_msg_fun(eventType, x, y)
		if eventType == CCTOUCHBEGAN then 
			PowerCenter:OnTouchBegin()
			return false
		elseif eventType == CCTOUCHENDED then
			PowerCenter:OnTouchEnd()
			return false
		end
	end
	_ui_root:registerScriptTouchHandler(ui_main_msg_fun, false, 0, false)
	--UI最底层的空地层
	local base_win = UIBackGroundWin:create("")
	_ui_root:addDragPanel(base_win.view)
	--引用减少1
	safe_release(base_win.view)
	UnRegisterWindow(base_win)
	--初始化摇杆
	-- require "joystick/JoystickManager"
	-- JoystickManager:init(_ui_root, Z_JOYSTICK)			
	-- JoystickManager:set_visible(true)
	self:createBlackBackground()
	-- self:createWindowScreenCloser()
	_init()
	self._isWindowsVisible = true

	UIManager:show_window("screen_notic_win")
	UIManager:show_window("center_notic_win")
	UIManager:show_window("screen_run_notic_win")

end

--创建窗口
function UIManager:create_window(window_name)
	local window_info = _ui_dict[window_name]
	if window_info == nil then
		return nil
	end

	local has_window = _ui_windows[window_name]
	if has_window ~= nil then
		return has_window
	end

	local style_info  = WINDOW_STYLE[window_info.appear_type]
	local create_info = window_info
	if style_info then
		create_info.texture     = window_info.texture 	 or style_info.texture
		create_info.grid 	    = window_info.grid 		 or style_info.grid
		create_info.width 	    = window_info.width 	 or style_info.width
		create_info.height 	    = window_info.height 	 or style_info.height
		create_info.x 		    = window_info.x 		 or style_info.x
		create_info.y 		    = window_info.y 		 or style_info.y
		create_info.title_text 	= window_info.title_text or ""
		create_info.config 		= window_info.config
	end

	local new_window = nil
	if create_info.layout then
		new_window = UILoader(create_info.layout, create_info.class, window_name, create_info)
	else
		new_window = create_info.class(window_name, create_info.texture, create_info.grid, create_info.width, 
			                           create_info.height, create_info.title_text, create_info.config)
	end

	if new_window.on_exit_btn_create_finish then
		new_window:on_exit_btn_create_finish()
	end

	if create_info.config and create_info.win_center == true then
		local win_root      = new_window:get_widget_by_name("win_root")
		local win_root_size = win_root:getSize()
		local x = (create_info.width-win_root_size.width)/2
		local y = (create_info.height-win_root_size.height)/2
		win_root:setPosition(x,y)
	end
    
    --存在蒙层 可以设置透明度
	if create_info.Opacity and create_info.texture then
		new_window.view:setOpacity(create_info.Opacity)
	end
	_ui_windows[window_name] = new_window
	return new_window
end

--销毁窗口
function UIManager:destroy_window(window_name)
	local has_window = _ui_windows[window_name]
	if has_window == nil then
		print("window nil name=",window_name)
		return false
	end
	for _ , win_name in pairs(_no_close_win) do
		if win_name == window_name then
			print("win_name=",win_name)
			return false
		end
	end
	print("destroy_window window_name=",window_name)
	_ui_windows[window_name] = nil

	if _ui_windows_shown[window_name] ~= nil then
		_ui_windows_shown[window_name] = nil
		_ui_dialogs_shown[window_name] = nil
		UIManager:setBlackBackground(has_window.view, 0, false)
		_safeRemoveChild(_ui_root,has_window.view,true)
	end	
	
	if _current_left_window == window_name then
		_current_left_window = nil
	end
	if _current_right_window == window_name then
		_current_right_window = nil
	end
	if _current_all_window == window_name then
		_current_all_window = nil
	end

	has_window:destroy()
	
	SoundManager:playUISound("close_win", false)
	-- ItemModel:check_update_callback()
	-- EntityManager:check_update_callback()

	for i=1,#_show_history_record do
		if _show_history_record[i] == window_name then
			table.remove(_show_history_record,i)
		end
	end

	if #_show_history_record > 0 then
		--如果关闭的是全屏窗口，显示主界面
		print("如果关闭的是全屏窗口，显示主界面")
		local window_info = _ui_dict[window_name]
		local name = _show_history_record[#_show_history_record]
		if window_info.appear_type == WINDOW_APPEAR_ALL then
			local win = UIManager:find_window(name)
			if win then
				win.view:setIsVisible(true)
				win:active(true)
				_current_all_window = name
				return true
			end
		end
	end

	--如果关闭的是全屏窗口，显示主界面
	local window_info = _ui_dict[window_name]
	if window_info.appear_type == WINDOW_APPEAR_ALL or window_info.appear_type == WINDOW_DIALOG_NOTMAIN then
		UIManager:showMainUI(true)
		print("如果关闭的是全屏窗口，显示主界面")
	end

	return true
end

-- 显示窗口
-- 可以直接调用，如果没创建，会自动创建
--	is_touch_other_close 是否点击其他地方关闭窗口
function UIManager:show_window( window_name ,is_touch_other_close)
    --在打开任意界面的时候如果发现正在录音应该马上停止 add by xiehande
    if window_name ~= "process_bar" then
	    -- if ChatModel:get_is_doing_record(  ) then -- 正在录音
	    	--打开都发停止的
	    	-- ChatModel:set_is_doing_record(false)
			local json_table_temp = {}
			json_table_temp[ "message_type" ]	= "platform"	--消息类型，必传字段
			json_table_temp[ "function_type" ] = "stopAudioRecord"
			json_table_temp[ "funcID" ] = "do_yaya_func"
			local jcode = json.encode( json_table_temp )
			if GetPlatform() == CC_PLATFORM_IOS then
				IOSDispatcher:do_yaya_func( jcode )
			elseif GetPlatform() == CC_PLATFORM_ANDROID then
				send_message_to_java( jcode )
			end
	        --如果页面没有被顶掉只是被其他页面盖住
	        -- local  win = UIManager:find_visible_window("chat_win")
	        -- if win then
	        -- 	local  input_panel = win.chat_input_edit
	        -- 	    input_panel:set_can_record(true)
	        -- 	    input_panel:clear_chat_time()
	        -- 	    if input_panel.hitPanel then
	        --         	input_panel.hitPanel:setIsVisible(false)
	        --         	input_panel.hitPanel2:setIsVisible(false)
	        --         	input_panel.hitPanel3:setIsVisible(false)
	        --         	input_panel.hitPanel4:setIsVisible(false)
	        --         end
	        --         input_panel:set_cancel_isvisitable(false)
	        --         --还原音量
	        --         SoundManager:chat_back_effct(  )
	        -- end

	        --如果是组队状态按钮给其他页面顶掉
	        -- local  win = UIManager:find_visible_window("menus_panel")
	        -- if win then
	        -- 	    if win.hitPanel then
	        --         	win.hitPanel:setIsVisible(false)
	        --         	win.hitPanel2:setIsVisible(false)
	        --         	win.hitPanel3:setIsVisible(false)
	        --         	win.hitPanel4:setIsVisible(false)
	        --         end
	        --         win:clear_chat_time()
	        --         win:set_can_record(true)
	        --         win:set_cancel_isvisitable(false)
	        --         --还原音量
	        --         SoundManager:chat_back_effct(  )
	        -- end
	    -- end
    end
    local is_view = false
	--如果已经显示了，忽略这次调用
	if _ui_windows_shown[window_name] then
		--return _ui_windows_shown[window_name]
		is_view = true
		for i=1,#_show_history_record do
			if _show_history_record[i] == window_name then
				table.remove(_show_history_record,i)
			end
		end
		_ui_windows_shown[window_name].view:setIsVisible(true)
	end

	local window_info = _ui_dict[window_name]
	if window_info == nil then
		print("window_info is nil name=",window_name)
		return nil
	end

	local window = UIManager:find_window(window_name)
	if window == nil then
		window = UIManager:create_window(window_name)
		if window == nil then
			return nil
		end
	end

	if not is_view then
		window.view:resumeChildAction()
		if is_touch_other_close then
			window:registerScriptFun()
			window:setTouchClickFun(window.close)
			if window.get_widget_by_name then
				local win_root = window:get_widget_by_name("win_root")
				if win_root then
					win_root:set_click_func(function ()
						window:close()
					end)
				end
			end
			self.windowsCloser:setClosingWindow(_ui_root,window_name,window_info.z or Z_DIALOG_START)
		end
	end
	
	local default_z = Z_ACTIVE_WINDOW
	--要区分出现方式
	if window_info.appear_type ~= nil then
		--左界面
		if window_info.appear_type == WINDOW_APPEAR_LEFT then
			close_window(_current_all_window)
			_current_all_window = nil
			if window_name ~= _current_left_window then
				close_window(_current_left_window)
				_current_left_window = window_name
			end
		--右界面
		elseif window_info.appear_type == WINDOW_APPEAR_RIGHT then
			close_window(_current_all_window)
			_current_all_window = nil
			if window_name ~= _current_right_window then
				close_window(_current_right_window)
				_current_right_window = window_name
			end
		--全界面
		elseif window_info.appear_type == WINDOW_APPEAR_ALL or window_info.appear_type == WINDOW_APPEAR_MIDDLE then
			close_window(_current_left_window)
			_current_left_window = nil
			close_window(_current_right_window)
			_current_right_window = nil
			if _current_all_window ~= window_name then
				delay_close_window(_current_all_window)
			end
			--close_window(_current_all_window)
			_current_all_window = window_name
			--如果是全屏窗口，关闭主界面
			if window_info.appear_type ~= WINDOW_APPEAR_MIDDLE then 
				UIManager:showMainUI(false) 
			end
		--对话框(非模态)
		elseif window_info.appear_type == WINDOW_DIALOG then
			_ui_dialogs_shown[window_name] = window
			default_z = Z_DIALOG_START+100
		--对话框(模态)
		elseif window_info.appear_type == WINDOW_DIALOG_MODAL then
			bring_window_center(window)
			default_z = Z_DIALOG_START
		elseif window_info.appear_type == WINDOW_DIALOG_RIGHT then
			_ui_dialogs_shown[window_name] = window
			local function dialog_click()
				bring_window_front(window, Z_DIALOG_START)
			end
			window:setTouchBeganFun(dialog_click)
			default_z = Z_DIALOG_START
			window:setPosition(481, window_info.y)
		elseif window_info.appear_type == WINDOW_DIALOG_TJXS then
			_ui_dialogs_shown[window_name] = window
			close_window(_current_left_window)
			_current_left_window = nil
			close_window(_current_right_window)
			_current_right_window = nil
			close_window(_current_all_window)
			_current_all_window = nil
		elseif window_info.appear_type == WINDOW_DIALOG_NOTMAIN then
			_ui_dialogs_shown[window_name] = window
			default_z = Z_DIALOG_START+100
			UIManager:showMainUI(false)
		end
	end
	
	if _ui_windows_shown[window_name] == nil then
		if window_info.z ~= nil then
			default_z = window_info.z
		end
		_ui_root:addChild(window.view, default_z)
		_ui_windows_shown[window_name] = window
		window:active(true)
	end

	--move effect
	if not is_view then
		if window then
			local _type = window_info.appear_type
			if _type then
				if _type <= 9 and window_name ~= "mini_map_win" then
					UIScreenPos.screen9GridPosWithAction(window, _type)
				else
					if _type == WINDOW_DIALOG_TJXS then
						local rPos = window_info.relative_position
						if rPos then
							if rPos.show_action then

								UIScreenPos.screen9GridPosWithAction(window,rPos.show_action)
							else
								UIScreenPos.screenPos(window,rPos.x,rPos.y,rPos.anchor)
							end
						end
					else
						UIScreenPos.screen9GridPosWithAction(window, 10)
					end
				end
			else
				local rPos = window_info.relative_position
				if rPos then
					if rPos.show_action then
						UIScreenPos.screen9GridPosWithAction(window,rPos.show_action)
					else
						UIScreenPos.screenPos(window,rPos.x,rPos.y,rPos.anchor)
					end
				end
			end
		end

		if window_info.appear_type == WINDOW_APPEAR_ALL and not window_info.no_block then
			UIManager:setBlackBackground(window.view, window_info.z, true)
		end
	end
	if not self._isWindowsVisible then
		window.view:setIsVisible(false)
	end

	SoundManager:playUISound("open_win", false)

	return window
end

function UIManager:update_window(window_name,...)
	local window = _ui_windows_shown[window_name]

	if window ~= nil then
		window:update(...)
	end
end

--隐藏窗口(只是取消渲染，不会删除窗口)
function UIManager:hide_window( window_name,is_hide )
	is_hide = is_hide or false
	if is_hide == false then
		UIManager:destroy_window(window_name)
		return
	end
	SoundManager:playUISound( "close_win" , false )
	local window_info = _ui_dict[window_name]
	if not window_info.close_type or window_info.close_type == CLOSE_DESTORY then
		UIManager:destroy_window( window_name )
		return
	end

	local window = _ui_windows_shown[window_name]

	if window ~= nil then
		if window.view:retainCount() > 1 then
			UIManager:setBlackBackground(window.view,0,false)
			_ui_root:removeChild(window.view, true)
			_ui_windows_shown[window_name] = nil
			_ui_dialogs_shown[window_name] = nil
			window:active(false)
		end
	end
	-- 判断popupview是否存在，存在就删除掉
	self.windowsCloser:onWindowHide(window_name)

	if _current_left_window == window_name then
		_current_left_window = nil
	end

	if _current_right_window == window_name then
		_current_right_window = nil
	end

	if _current_all_window == window_name then
		_current_all_window = nil
	end

	for i=1,#_show_history_record do
		if _show_history_record[i] == window_name then
			table.remove(_show_history_record,i)
		end
	end

	if #_show_history_record > 0 then
		-- local name = table.remove(_show_history_record,#_show_history_record)
		local name = _show_history_record[#_show_history_record]
		local win = UIManager:find_window(name)
		if win then
			win.view:setIsVisible(true)
			win:active(true)
			_current_all_window = name
			return 
		end
	end


	--如果是全屏幕窗口，关闭时显示主界面
	if window_info.appear_type == WINDOW_APPEAR_ALL or window_info.appear_type == WINDOW_DIALOG_NOTMAIN then
		UIManager:showMainUI(true)
	end
end

-- 开关窗口(仅调用show和hide)
function UIManager:toggle_window( window_name , is_touch_other_close)
	if _ui_windows_shown[window_name] == nil then
		return UIManager:show_window(window_name,is_touch_other_close)
	else
		UIManager:hide_window(window_name)
	end
end

-- 找到窗口
function UIManager:find_window( window_name )
	return _ui_windows[window_name]
end

-- 找到显示的窗口
function UIManager:find_visible_window( window_name )
	return _ui_windows_shown[window_name]
end

---找到主消息窗口
function UIManager:get_main_panel()
	return _ui_root
end

-- 检测某一窗口当前状态
function UIManager:get_win_status(window_name)
	if _ui_windows_shown[window_name] ~= nil then
		return true
	else 
		return false
	end
end

--判断当前是否有打开的窗口或对话框
function UIManager:find_is_show_window_or_dialog()
	for k,v in pairs(_ui_windows_shown) do
		if _current_left_window or _current_all_window or _current_right_window then
			return true
		end
	end
	for k,v in pairs(_ui_dialogs_shown) do
		if v~= nil then
			return true
		end
	end
	return false
end

-- 获取某一窗口当前对象指针
function UIManager:get_win_obj(window_name)
	return _ui_windows[window_name]
end

-- 隐藏全部窗口
function UIManager:hide_all_window()
	for window_name, window in pairs(_ui_windows_shown) do
		UIManager:hide_window(window_name)
	end
end

function UIManager:close_window_except_main()
	for k,v in pairs(_ui_windows_shown) do
		if k ~= "mini_btn_win" and not _main_window[k] then
			UIManager:destroy_window(k)
		end
	end
	UIManager:showMainUI(true)
end
--
function UIManager:close_all_window()
	if _current_left_window ~= nil then
		close_window(_current_left_window)
	end
	if _current_right_window ~= nil then
		close_window(_current_right_window)
	end
	if _current_all_window ~= nil then
		close_window(_current_all_window)
	end
end

--关闭除此之外的页面
function UIManager:close_otherwise_window(name)
	if _current_left_window ~= nil then
		if _current_left_window ~=name then
		   close_window(_current_left_window)
	    end
	end

	if _current_right_window ~= nil then
		if _current_right_window ~=name then
		   close_window(_current_right_window)
	    end
	end

	if _current_all_window ~= nil then
		if _current_all_window ~=name then
		   close_window(_current_all_window)
	    end
	end

	self:close_all_dialog()
end

function UIManager:close_all_dialog()
	for dialog_name, dialog in pairs(_ui_dialogs_shown) do
		UIManager:hide_window(dialog_name)
	end
end

-- 退出删除全部窗口
function UIManager:OnQuit()
	self:destroyBlackBackground()
	self:destroyWindowScreenCloser()
	self:relaseMainUIActions()

	for window_name, window in pairs(_ui_windows) do
		window:destroy()
	end

	SceneLoadingWin:destroy_instance()
	
	_current_left_window	= nil 			-- 出现在屏幕左边的界面的名字
	_current_right_window	= nil 			-- 出现在屏幕右边的界面的名字
	_current_all_window 	= nil 			-- 出现在全屏幕的界面的名字

	_ui_windows = {}						-- 记录已创建窗口
	_ui_windows_shown = {}				-- 记录正在显示的窗口
	_ui_dialogs_shown = {}				-- 记录正在显示的dialog

	-- UI根节点
	_ui_root = nil

	_ui_dict = {}
end

function UIManager:createWindowScreenCloser()
	self.windowsCloser = PopupView()
end

function UIManager:destroyWindowScreenCloser()
	if self.windowsCloser then
		self.windowsCloser:destroy()
		self.windowsCloser = nil
	end
end


local function _block_fun(eventType, x, y)
	return true
end

local function _noblock_fun(eventType, x, y)
	return false
end

function UIManager:createBlackBackground()
	local blackPic = "nopack/black.png"
	self.blackBackSprite = CCBasePanel:panelWithFile(0, 0, _refWidth(4.0), _refHeight(4.0), blackPic)
	self.blackBackSprite:retain()
	self.blackBackSprite:setAnchorPoint(0.5, 0.5)
	self.blackBackSprite:setOpacity(0)
	self.blackBackSprite:registerScriptHandler(_block_fun)
end

function UIManager:destroyBlackBackground()
	if self.blackBackSprite then
		_safeRemoveFromParentAndCleanup(self.blackBackSprite,true)
		self.blackBackSprite:release()
	end
end

function UIManager:setBlackBackground(view, z, flag, no_block)
	if flag then
		local cz = view:getContentSize()
		self.blackBackSprite:setPosition(cz.width*0.5, cz.height*0.5)
		_safeRemoveFromParentAndCleanup(self.blackBackSprite, true)
		view:addChild(self.blackBackSprite, -1)
		view:setEnableHitTest(false)
		if no_block then
			self.blackBackSprite:registerScriptHandler(_noblock_fun)
		else
			self.blackBackSprite:registerScriptHandler(_block_fun)
		end
	else
		if self.blackBackSprite:getParent() == view then
			_safeRemoveFromParentAndCleanup(self.blackBackSprite,true)
			view:setEnableHitTest(true)
		end
	end
end

function get_win()
	return _ui_windows
end

function dump_win()
	ZXLog("_ui_windows_shown >>>")
	for k,v in pairs(_ui_windows_shown) do
		ZXLog(k)
	end
	ZXLog("_ui_dialogs_shown >>>")
	for k,v in pairs(_ui_dialogs_shown) do
		ZXLog(k)
	end
	ZXLog("_ui_windows >>>")
	for k,v in pairs(_ui_windows) do
		ZXLog(k)
	end
end

function get_win_shown()
	return _ui_windows_shown
end

function get_dialog_shown()
	return _ui_dialogs_shown
end

--销毁所有窗口
function destroy_all_window()
	for k,v in pairs(_ui_windows) do
		UIManager:destroy_window(k)
	end
end

--获取窗口的配置
function UIManager:get_win_info( win_name )
	local win_info = _ui_dict[win_name]
	if win_info ~= nil then
		return win_info
	end
end

local function reloadWin( window_name )
	local r_table = SCRIPT_PATH[window_name]
	if r_table and #r_table > 0 then
		UIManager:destroy_window(window_name)
		for k,v in pairs(r_table) do
			reloadScript(v)
		end
		--重新加载class
		_init()
		UIManager:show_window(window_name)
	end
end

function UIManager:reloadAllWin()
	if _current_left_window then
		reloadWin(_current_left_window)
	end
	if _current_all_window then
		reloadWin(_current_all_window)
	end
	if _current_right_window then
		reloadWin(_current_right_window)
	end

	for k,v in pairs(_ui_dialogs_shown) do
		if v~= nil then
			reloadWin(k)
		end
	end
end

function UIManager:removeMainUI(id)
	 _mainUIPanels_dict[_mainUIPanels[id]] = nil
	 _mainUIPanels[id] = nil
end

function UIManager:setMainUI(id,view)
	_mainUIPanels[id] = view
	 _mainUIPanels_dict[_mainUIPanels[id]] = true
end

--初始化主界面和其Actions
function UIManager:setupMainUI()
	_mainUIReady = false
	-- 显示用户面板
	UIManager:show_window("user_panel")
	_main_window["user_panel"] = true
	--UIManager:show_window("right_panel")
	UIManager:show_window("right_top_panel")
	_main_window["right_top_panel"] = true
	UIManager:show_window("menus_panel")
	_main_window["menus_panel"] = true
	UIManager:show_window("exp_panel")
	_main_window["exp_panel"] = true
	-- 要先创建活动按钮面板
	-- UIManager:create_window("activity_menus_panel")
	----
	UIManager:show_window("screen_notic_win")
	_main_window["screen_notic_win"] = true
	UIManager:show_window("center_notic_win")
	_main_window["center_notic_win"] = true
	UIManager:show_window("screen_run_notic_win")
	_main_window["screen_run_notic_win"] = true
	UIManager:show_window("hyper_link")
	_main_window["hyper_link"] = true


	_mainUIReady = true

	if _firstShowMainUI then 
		local p0 = { _mainUIPanels[1]:getPosition() }
		local p1 = { _mainUIPanels[2]:getPosition() }
		local p2 = { _mainUIPanels[3]:getPosition() }
		local s2 = _mainUIPanels[3]:getSize()
		----------------------------------------------------------------------------------------
		local move1 = CCMoveTo:actionWithDuration(0.5,CCPointMake(p0[1]-_ui_half_width,
																  p0[2]+_ui_half_height))
		local array = CCArray:array()
		array:addObject(move1)
		array:addObject(CCHide:action())
		_mainUIShowActions[1] = CCSequence:actionsWithArray(array)
		----------------------------------------------------------------------------------------
		local move2 = CCMoveTo:actionWithDuration(0.5,CCPointMake(p1[1]+_ui_half_width,
																  p1[2]+_ui_half_height))
		local array = CCArray:array()
		array:addObject(move2)
		array:addObject(CCHide:action())
		_mainUIShowActions[2] = CCSequence:actionsWithArray(array)
		----------------------------------------------------------------------------------------
		local move3 = CCMoveTo:actionWithDuration(0.5,CCPointMake(p2[1],
																  p2[2]-s2.height))
		local array = CCArray:array()
		array:addObject(move3)
		array:addObject(CCHide:action())
		_mainUIShowActions[3] = CCSequence:actionsWithArray(array)
		-- _mainUIShowActions[3] = move3
		----------------------------------------------------------------------------------------

		_mainUIShowActions[4] = CCMoveTo:actionWithDuration(0.25,CCPointMake(p0[1],p0[2]))

		_mainUIShowActions[5] = CCMoveTo:actionWithDuration(0.25,CCPointMake(p1[1],p1[2]))

		_mainUIShowActions[6] = CCMoveTo:actionWithDuration(0.25,CCPointMake(p2[1],p2[2]))

		----------------------------------------------------------------------------------------
		for i, v in ipairs(_mainUIShowActions) do
			v:retain()
			v:setTag(_mainUIShowActionTag)
		end
	end

	_firstShowMainUI = false
end

--初始化主界面Actions
function UIManager:showMainUI(bShow)
	if not _mainUIReady or _isShowMainUI == bShow then return end

	_isShowMainUI = bShow

	-- 部分副本因为上面需要显示血条，故隐藏上面左右面板
	-- local is_teshu_fuben =  SFuBenModel:check_teshu_fuben()
	-- if SFuBenModel:check_teshu_fuben() then
	-- 	is_teshu_fuben = true
	-- end

	if not bShow then -- 隐藏
		--SFuBenModel:is_show_teshu_ui(false)
		if _mainUIPanels[1] then
			_mainUIPanels[1]:stopActionByTag(_mainUIShowActionTag)
			_mainUIPanels[1]:runAction(_mainUIShowActions[1])
		end

		if _mainUIPanels[2] then
			_mainUIPanels[2]:stopActionByTag(_mainUIShowActionTag)
			_mainUIPanels[2]:runAction(_mainUIShowActions[2])
		end

		if _mainUIPanels[3] then
			_mainUIPanels[3]:stopActionByTag(_mainUIShowActionTag)
			_mainUIPanels[3]:runAction(_mainUIShowActions[3])
		end
		UIManager:destroy_window("main_activity_win")
		JoystickManager:set_visible(false)
	else -- 显示
		--SFuBenModel:is_show_teshu_ui(true)
		-- if not is_teshu_fuben then
			if _mainUIPanels[1] then
				_mainUIPanels[1]:stopActionByTag(_mainUIShowActionTag)
				_mainUIPanels[1]:setIsVisible(true)
				_mainUIPanels[1]:runAction(_mainUIShowActions[4])
			end

			if _mainUIPanels[2] then
				_mainUIPanels[2]:stopActionByTag(_mainUIShowActionTag)
				_mainUIPanels[2]:setIsVisible(true)
				_mainUIPanels[2]:runAction(_mainUIShowActions[5])
			end
			-- is_teshu_fuben = false
		-- end
		if _mainUIPanels[3] then
			_mainUIPanels[3]:stopActionByTag(_mainUIShowActionTag)
			_mainUIPanels[3]:setIsVisible(true)
			_mainUIPanels[3]:runAction(_mainUIShowActions[6])
		end
		JoystickManager:set_visible(true)

		self:set_mainui_state( UIManager.mainui_state)
	end
end

-- 设置一个状态，隐藏主界面人物面板和右上面板(写成状态，可扩展)
UIManager.MUI_STATE_NORMAL  = 1 -- 正常显示(全显示)
UIManager.MUI_STATE_JUSTBTM = 2 -- 只显示下面ui
UIManager.mainui_state = UIManager.MUI_STATE_NORMAL
function UIManager:set_mainui_state( mui_state)
	UIManager.mainui_state = mui_state
	if UIManager.mainui_state == UIManager.MUI_STATE_NORMAL then -- 显示全部(默认)
		if _mainUIPanels[1] then
			_mainUIPanels[1]:setIsVisible(true)
		end
		if _mainUIPanels[2] then
			_mainUIPanels[2]:setIsVisible(true)
		end
		if _mainUIPanels[3] then
			_mainUIPanels[3]:setIsVisible(true)
		end
	elseif UIManager.mainui_state == UIManager.MUI_STATE_JUSTBTM then -- 只显示底部
		if _mainUIPanels[1] then
			_mainUIPanels[1]:setIsVisible(false)
		end
		if _mainUIPanels[2] then
			_mainUIPanels[2]:setIsVisible(false)
		end
		if _mainUIPanels[3] then
			_mainUIPanels[3]:setIsVisible(true)
		end
	end
end

--开启主面板技能
function UIManager:fn_open(openType, fbType)
	SGPublic:skill_task_open(fn_config["技能1"])
	SGPublic:skill_task_open(fn_config["技能2"])
	SGPublic:skill_task_open(fn_config["技能3"])
	SGPublic:skill_task_open(fn_config["技能4"])
	SGPublic:skill_task_open(fn_config["技能xp"])
end

function UIManager:setWindowVisible(bShow)
	for window_name, window in pairs(_ui_windows_shown) do
		if not _mainUIPanels_dict[window.view] then
			window.view:setIsVisible(bShow)
		end
	end
	UIManager:showMainUI(bShow)
	self._isWindowsVisible = bShow
end

--销毁主界面Actions
function UIManager:relaseMainUIActions()
	for i, v in ipairs(_mainUIShowActions) do
		v:release()
	end
end

-- 开发时，做F5刷新界面时用到
function UIManager:init_out()
	_init()
end

function UIManager:scene_leave()
	self:destroyWindowScreenCloser()
	UIManager:hide_all_window()
end

--特殊窗口销毁
--create by jiangjinhong 
function  UIManager:my_hide(window_name)
	local has_window = _ui_windows[window_name]
	if has_window == nil then
		return false
	end

	_ui_windows[window_name] = nil

	if _ui_windows_shown[window_name] ~= nil then
		_ui_windows_shown[window_name] = nil
		_ui_dialogs_shown[window_name] = nil
		UIManager:setBlackBackground(has_window.view, 0, false)
		_ui_root:removeChild(has_window.view, true)
	end	
	
	if _current_left_window == window_name then
		_current_left_window = nil
	end
	if _current_right_window == window_name then
		_current_right_window = nil
	end
	if _current_all_window == window_name then
		_current_all_window = nil
	end

	has_window:destroy_new()
	
	--如果关闭的是全屏窗口，显示主界面
	local window_info = _ui_dict[window_name]
	if window_info.appear_type == WINDOW_APPEAR_ALL or window_info.appear_type == WINDOW_DIALOG_NOTMAIN then
		UIManager:showMainUI(true)
	end

	SoundManager:playUISound("close_win", false)

	return true
end

-- add by chj @2015-8-26 更新界面统一接口(封装了model层常用代码@_@)
function UIManager:update_win(win_name, utype, ...)
	local args = { ... }
	local win = UIManager:find_visible_window( win_name)
	if win then
		win:update( utype, args)
	end
end

--清空记录窗口
function UIManager:clear_history_record( ... )
	for i=1,#_show_history_record do
		local window_name = _show_history_record[i]
		UIManager:destroy_window(window_name)
	end
end