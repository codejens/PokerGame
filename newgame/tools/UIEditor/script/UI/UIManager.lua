-- UIManager.lua
-- created by aXing on  2012-11-15
-- 这是一个UI的管理器
-- 用于管理UI的创建，消亡，显示，隐藏等

super_class.UIManager()

-----------------------------------------------------------------------------------
-- 以下是ui深度排序indexg
-- 定义域(1, +)
-----------------------------------------------------------------------------------


-- 70000 = 断开连接Dialog
-- 80000 = 退出游戏Dialog

-- UI窗口出现范围(LEFT, RIGHT, ALL)
local WINDOW_APPEAR_LEFT	= 4 			-- 该面板出现在屏幕左边
local WINDOW_APPEAR_RIGHT	= 6 			-- 该面板出现在屏幕右边
local WINDOW_APPEAR_ALL		= 5 			-- 该面板是覆盖全画面
local WINDOW_DIALOG 		= 100 			-- 以dialog的方式出现在中间
local WINDOW_DIALOG_MODAL	= 200 			-- 模态dialog方式出现在中间
local WINDOW_DIALOG_RIGHT   = 300	        -- 以dialog的方式出现在右边
local WINDOW_DIALOG_TJXS 	= 301			-- 天将雄狮后添加
local WINDOW_APPEAR_MIDDLE	= 400 			-- 类WINDOW_APPEAR_ALL,但是不屏蔽主窗口UI

-- UI关闭方式
--如果 close_type == nil 时 == CLOSE_DESTORY
local CLOSE_HIDE			= 1 			-- 窗口关闭只隐藏
local CLOSE_DESTORY			= 2 			-- 窗口关闭销毁

local _current_left_window	= nil 			-- 出现在屏幕左边的界面的名字
local _current_right_window	= nil 			-- 出现在屏幕右边的界面的名字
local _current_all_window 	= nil 			-- 出现在全屏幕的界面的名字

local _ui_windows = {}						-- 记录已创建窗口
local _ui_windows_shown = {}				-- 记录正在显示的窗口
local _ui_dialogs_shown = {}				-- 记录正在显示的dialog

--求相对屏幕大小的函数
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

--全屏大小
local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height
	
--半屏大小
local _ui_half_width = _ui_width * 0.5
local _ui_half_height = _ui_height * 0.5


local _all_win_info = { x = 0, y = 0, width = _ui_width, height = _ui_height, texture ="" }

------------------------------------------
----------HJH 2013-9-7

----------定义大窗口与中形窗口坐标与位置
local _big_win_info = { x = 10, y = 35, width = 917, height = 628, texture = 		UIPIC_WINDOWS_BG }
local _mid_win_info = { x = 400, y = 48, width = 457, height = 607, texture =  		UIPIC_WINDOWS_BG }
local _left_mid_win_info = { x = 3, y = 39, width = 457, height = 607, texture = 	UIPIC_WINDOWS_BG }
local _right_mid_win_info = { x = 403, y = 39, width = 457, height = 607, texture = UIPIC_WINDOWS_BG }

--新风格界面 窗口坐标与位置
local _left_mid_win_new = { x = 10, y = 35, grid = true, width = 457, height = 619, texture =   UIPIC_WINDOWS_BG }
local _right_mid_win_new = { x = 401, y = 35, grid = true, width = 457, height = 619, texture = UIPIC_WINDOWS_BG }
local _big_mid_win_new = { x = 35, y = 35, grid = true, width = 917, height = 640, texture =    UIPIC_WINDOWS_BG }

-- 天降雄师新窗口坐标和位置(等大家统一窗口大小了，就可以直接改前面的窗口大小，然后把引用下面变量的进行全局替换，note by guozhinan)
local _left_mid_win_info_lion = { x = 10, y = 10, grid = true,width = 435, height = 630, texture =   "",title_bg =UIPIC_COMMOM_title_bg }
local _right_mid_win_info_lion = { x = 401, y = 10, grid = true,width = 435, height = 630, texture ="",title_bg =UIPIC_COMMOM_title_bg  }
local _big_win_info_lion = { x = 30, y = 10, grid = true,width = 900, height = 630, texture = "",title_bg =UIPIC_COMMOM_title_bg  }
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

local WINDOW_STYLE = 
{
	[WINDOW_APPEAR_LEFT] = _left_mid_win_info_lion,
	[WINDOW_APPEAR_RIGHT] = _right_mid_win_info_lion,
	[WINDOW_APPEAR_ALL] = _big_mid_win_new
}

------------------------------------------
function UIManager:get_big_win_create_info()
	return _big_mid_win_new
end
------------------------------------------
function UIManager:get_new_big_win_create_info()
	return _big_win_info_lion
end
------------------------------------------
function UIManager:get_min_win_create_info()
	return _mid_win_info_new
end
------------------------------------------
function UIManager:get_left_mid_win_create_info()
	return _left_mid_win_info
end
------------------------------------------
function UIManager:get_right_mid_win_create_info()
	return _right_mid_win_info_new
end
---------add end
------------------------------------------
-- UI根节点	
local _ui_root = nil

local _ui_dict = {}


local function _init()

	_ui_dict = {
	-- --UI层最底层的空白win
	-- base_win = {class = UIBackGroundWin, texture = "", x = 100, y = 100, z = 0, width = 100, height = 100},

	--以下业务层win的Z深度值必须大于等于1

	-- added by aXing on 2014-5-2
	-- 添加变身系统，希望作为一个窗口例子范例
	-- 注释：考虑，UI信息映射表，是希望把共性的信息尽量省略，并轻易得绑定一些共性的属性
	-- 如窗口定性为只有，左，右，大三种，而这三种的信息基本一致，其实就不用一一写出来。

	-- 商城系统
	mall_win = {class = MallWin, width = _big_win_info_lion.width, height = _big_win_info_lion.height,  texture = _big_win_info_lion.texture, grid = true, appear_type = WINDOW_APPEAR_ALL, title_text = UILH_MALL.title_mall, auto_title_and_exit_create = false},



	
	team_filter_dialog = {class = TeamFilterDialog, texture = nil, width = 400, height = 330, z = Z_DIALOG_START, appear_type =WINDOW_DIALOG, grid=true,auto_title_and_exit_create = false},
	-- 乾坤兑换活动
	qian_kun_win = {class = QianKunWin, width = _big_win_info_lion.width, height = _big_win_info_lion.height, texture = _big_win_info_lion.texture, appear_type = WINDOW_APPEAR_ALL,title_text = UILH_OTHER.qiankun, auto_title_and_exit_create = false}, 
	-- 淘宝树展示界面 
	taobao_win = { class = TaoBaoWin, width = _mid_win_info.width, height = _big_win_info_lion.height,  texture = _big_win_info_lion.texture, grid = true, appear_type = WINDOW_APPEAR_ALL, title_text = UILH_MAINACTIVITY.taobaoshu_title, auto_title_and_exit_create = false },
	-- 每日充值(多个档次)
	day_cz_multi_win = {class = DayChongZhiMultiWin, width = _big_win_info_lion.width, height = _big_win_info_lion.height,  texture = _big_win_info_lion.texture, grid = true, appear_type = WINDOW_APPEAR_ALL, title_text = UILH_MRCZ.mrcz_title, auto_title_and_exit_create = false},	
	
	mapedite_win = { class = MapEditeWin, width = _all_win_info.width, height = _all_win_info.height,  texture = _all_win_info.texture, grid = true, appear_type = WINDOW_APPEAR_ALL, title_text = UILH_MRCZ.mrcz_title, auto_title_and_exit_create = false},	

	uiedit_win =  { class = UIEditWin, width = _all_win_info.width, height = _all_win_info.height,  texture = _all_win_info.texture, grid = true, appear_type = WINDOW_APPEAR_ALL, title_text = UILH_MRCZ.mrcz_title, auto_title_and_exit_create = false},	

	uiedit_dialog = {class = UIEidtDilog, texture = nil, width = 400, height = 330, z = Z_DIALOG_START, appear_type =WINDOW_DIALOG, grid=true,auto_title_and_exit_create = false},
}
end


--生成一个拖拽图标
function UIManager:create_drag_item(icon,point_x,point_y)
	-- require "UI/component/DragItem"
	if  self.drag_item ~= nil then
		UIManager:destory_drag_item();
	end
	self.drag_item = DragItem(48,48);
	self.drag_item.view:setEnableHitTest(false);  
	self.drag_item:set_icon_texture(icon);
	self.drag_item:setAnchor(0.5,0.5);
	-- print("拖拽图片的起始坐标点", point_x, point_y);
	self.drag_item:setPosition(point_x,point_y);
	_ui_root:addChild(self.drag_item.view,999);
	self.drag_item.view:setCurState(CLICK_STATE_DOWN);
	
	-- 动画效果
	local winSize = CCDirector:sharedDirector():getWinSize();
	local scale_act = CCScaleBy:actionWithDuration( 0.1, 1.6 );
	self.drag_item.view:runAction(scale_act);

	--托管
	--self.drag_item_id = _ui_root:addTouchMoveSprite(self.drag_item.view,self.drag_item.view);

end

--销毁拖拽图标
function UIManager:destory_drag_item( )
	if self.drag_item ~= nil then 
		--print("-------------------销毁拖拽图标----------------",self.drag_item_id);
		--_ui_root:removeTouchMoveSprite(self.drag_item_id);
		--self.drag_item = nil;
		_safeRemoveFromParentAndCleanup(self.drag_item.view,true)
		self.drag_item = nil;
	end
end

-- 根据关闭状态删除窗口
local function close_window( name )
	if name == nil then
		return 
	end
		-- 如果这个窗口正在显示
	if ( UIManager:find_visible_window(name) ) then
		local old_window = _ui_dict[name]
		print("old_window",old_window.close_type)
		if old_window and old_window.close_type == CLOSE_DESTORY then
			UIManager:destroy_window( name )
		else
			UIManager:hide_window( name )
		end
	end
end

-- 将窗口置中
function bring_window_center( window )
	UIScreenPos.screen9GridPosWithAction(window, 5)
end

-- 将窗口置前
local function bring_window_front( window, z_order )
	_safeRemoveChild(_ui_root,window.view,false)
	_ui_root:addChild(window.view, z_order)
end

-- 根据窗口信息放置窗口
local function locate_window( window, info )
	-- 如果窗口信息字典里面有详细信息，则用制订信息
	-- 否则，用默认信息代替

	local final_x
	local final_y
	local reset_pos = false

	if info.appear_type == WINDOW_APPEAR_LEFT then
		if info.x ~= nil then
			final_x = info.x
		else
			final_x = _left_mid_win_new.x
		end

		if info.y ~= nil then
			final_y = info.y
		else
			final_y = _left_mid_win_new.y
		end

	elseif info.appear_type == WINDOW_APPEAR_RIGHT then
		if info.x ~= nil then
			final_x = info.x
		else
			final_x = _right_mid_win_new.x
		end

		if info.y ~= nil then
			final_y = info.y
		else
			final_y = _right_mid_win_new.y
		end

	elseif info.appear_type == WINDOW_APPEAR_ALL then
		if info.x ~= nil then
			final_x = info.x
		else
			final_x = _right_mid_win_new.x
		end

		if info.y ~= nil then
			final_y = info.y
		else
			final_y = _right_mid_win_new.y
		end

	elseif info.appear_type == WINDOW_DIALOG or info.appear_type == WINDOW_APPEAR_MIDDLE or info.appear_type == WINDOW_DIALOG_MODAL then
		if info.x ~= nil and info.y ~= nil then
			final_x = info.x
			final_y = info.y
		else
			reset_pos = true
			if window ~= nil then
				bring_window_center(window)
			end
		end
	end

	if window ~= nil and reset_pos ~= true then
		window:setPosition(final_x, final_y)
	end
end

-- 自动生成窗口标题和关闭按钮
local function create_title_and_close_button( window, window_name, window_info )
	-- 自动生成标题和关闭按钮
	if window_info.appear_type then
		local spr_bg_size = window.view:getSize()
        -- 标题背景
	    local title_bg_path = ""
	    if window_info.title_bg == nil then
           if window_info.appear_type == WINDOW_APPEAR_ALL or window_info.appear_type == WINDOW_APPEAR_MIDDLE or window_info.appear_type ==WINDOW_APPEAR_LEFT or window_info.appear_type == WINDOW_APPEAR_RIGHT then
           	   title_bg_path =UIPIC_COMMOM_title_bg
           end
	    else
			title_bg_path = window_info.title_bg
		end

		if ( title_bg_path ) then
	    	window.window_title_bg = ZImage:create( window.view, title_bg_path , spr_bg_size.width/2,  spr_bg_size.height-3,-1,-1, 1002 );
	    	window.window_title_bg:setAnchorPoint(0.5,0.5)
	    end
       
		-- 关闭按钮
		if window_info.not_close_btn ~= true then --没有关闭按钮
			local function btn_close_fun(eventType,x,y)
				Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
				--默认window_info.close_type == nil 销毁窗口 2014-05-29 LuShan
				if  window_info.close_type == CLOSE_HIDE then
		        	UIManager:hide_window( window_name );

		        elseif not window_info.close_type or window_info.close_type == CLOSE_DESTORY then 
		        	UIManager:destroy_window( window_name )
		        end
		    end
		  	window.exit_btn = ZButton:create(window.view, UIPIC_COMMOM_008, btn_close_fun,0,0,-1,-1,1002);	
		    local exit_btn_size = window.exit_btn:getSize()
		    if window_info.appear_type == WINDOW_DIALOG then
		    	window.exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width-5 , spr_bg_size.height - exit_btn_size.height+17)	
		   	else  
		    	window.exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width-5, spr_bg_size.height -exit_btn_size.height+17)
			end 
		end 

	   -- 标题文字   图片形式
	    if window_info.title_text then
	    	local t_width = window.window_title_bg:getSize().width
	    	local t_height = window.window_title_bg:getSize().height
	    	window.window_title = ZImage:create( window.window_title_bg, window_info.title_text , t_width/2,  t_height-27, -1,-1,999 );
	    	window.window_title.view:setAnchorPoint(0.5,0.5)
	    end
    end
end

-- UI管理器初始化
function UIManager:init( root )

	-- if _ui_root ~= nil then
	-- 	print("UI manager has been initialized!")
	-- 	return
	-- end

	_ui_root = root:getUINode()

	local function ui_main_msg_fun(eventType,x,y)
		if eventType == CCTOUCHBEGAN then 
			PowerCenter:OnTouchBegin()
			return false
		elseif eventType == CCTOUCHENDED then
			PowerCenter:OnTouchEnd()
			return false
		end
	end
	_ui_root:registerScriptTouchHandler(ui_main_msg_fun, false, 0, false)

	-- UI最底层的空地层
	local base_win = UIBackGroundWin:create("");
	_ui_root:addDragPanel(base_win.view);
	--引用减少1
	safe_release(base_win.view)
	UnRegisterWindow(base_win)

	-- 初始化摇杆
	require "joystick/JoystickManager"
	-- JoystickManager:init(_ui_root, Z_JOYSTICK)			
	-- JoystickManager:set_visible(true)

	self:createBlackBackground()
	self:createWindowScreenCloser()
	_init()
	--UIManager是否处于显示中
	--通过 setWindowVisible 接口控制，主要用于剧情动画
	self._isWindowsVisible = true
end

-- 创建窗口
-- 会申请内存，但不会渲染
function UIManager:create_window( window_name )	
	
	local window_info = _ui_dict[window_name]

	if window_info == nil then
		print(window_name .. " has not been registed!")
		return nil
	end

	local has_window = _ui_windows[window_name]
	if has_window ~= nil then
		print(window_name .. " has been created!")
		return has_window
	end

	-- edited by aXing on 2014-5-2
	-- 根据窗口出现类型决定窗口背景贴图
	local bg_texture = nil

	local style_info = WINDOW_STYLE[window_info.appear_type]
	local create_info = window_info

	if style_info then 
		create_info.texture = window_info.texture 	or style_info.texture
		create_info.grid 	= window_info.grid 		or style_info.grid
		create_info.width 	= window_info.width 	or style_info.width
		create_info.height 	= window_info.height 	or style_info.height
		create_info.x 		= window_info.x 		or style_info.x
		create_info.y 		= window_info.y 		or style_info.y
		create_info.title_text 		= window_info.title_text 		or ""
	end
	local new_window = nil
	if create_info.layout then
		new_window = UILoader( create_info.layout, create_info.class, window_name, create_info)
	else
		new_window = create_info.class( window_name, 
										  create_info.texture, 
										  create_info.grid, 
										  create_info.width, 
										  create_info.height,
										  create_info.title_text
										  )
	end
 --    if window_info.appear_type then
	--   local style_ds = CCZXImage:imageWithFile( 0, 0,  new_window.view:getSize().width, new_window.view:getSize().height, UIPOS_TopListWin_0018, 500, 500,500)
	--       new_window.view:addChild(style_ds)
	-- end
	-- edited by aXing on 2014-5-2
	-- 将自动生成标题和关闭按钮，代码拿到这里
	if window_info.auto_title_and_exit_create == nil then
		create_title_and_close_button(new_window, window_name, create_info)
	end

	-- add by hcl on 2014-5-10
	-- 因为退出按钮的创建在init之后，所以没办法在init中去改变exit的点击函数，
	-- 增加一个退出按钮创建完成的回调
	if new_window.on_exit_btn_create_finish then
		new_window:on_exit_btn_create_finish();
	end

	_ui_windows[window_name] = new_window

	return new_window

end

-- 销毁窗口
function UIManager:destroy_window( window_name )
	print('destroy_window',window_name)
	local has_window = _ui_windows[window_name]
	if has_window == nil then
		return false
	end

	_ui_windows[window_name] = nil

	if _ui_windows_shown[window_name] ~= nil then
		_ui_windows_shown[window_name] = nil
		_ui_dialogs_shown[window_name] = nil
		UIManager:setBlackBackground(has_window.view,0,false)
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
	
	--如果关闭的是全屏窗口，显示主界面
	local window_info = _ui_dict[window_name]
	if window_info.appear_type == WINDOW_APPEAR_ALL then
		UIManager:showMainUI(true)
	end
	--CCTextureCache:sharedTextureCache():removeUnusedTextures();
	SoundManager:playUISound( 'close_win' , false )
	
	return true
end

-- 显示窗口
-- 可以直接调用，如果没创建，会自动创建
--	is_touch_other_close 是否点击其他地方关闭窗口
function UIManager:show_window( window_name ,is_touch_other_close)

	--如果已经显示了，忽略这次调用
	if _ui_windows_shown[window_name] then
		return _ui_windows_shown[window_name]
	end
	-- 打开一个新窗口时，判断当前是否有新手指引，如果有，就去掉这个指引
	-- XSZYManager:on_show_window(  )
	-- 如果当前在锁屏指引中，则不能打开界面
	-- if XSZYManager:get_is_locking_screen() then
	-- 	return;
	-- end

	-- 只有在无锁屏状态下的时候才在打开窗口时关闭指引
	if Instruction:get_is_unlock() then
		Instruction:handleUIComponentClick(instruct_comps.CLOSE_XSZY)
	end
	--print("UIManager:show_window( window_name ,is_touch_other_close)",window_name ,is_touch_other_close)
	local window_info = _ui_dict[window_name]

	if window_info == nil then
		print(window_name .. " has not been registed!")
		return nil
	end

	local window = UIManager:find_window(window_name)

	if window == nil then
		window = UIManager:create_window(window_name)
		if window == nil then
			return nil
		end
	end
	print('>>>>>>>>>',window_name)
	print("window_info.appear_type",window_info.appear_type)
	-----------add by hjh  2013-4-3
	-----------
	if window ~= nil then
		window.view:resumeChildAction()
	end
	-- 加上一个背景panel，当点击到窗口外面时会自动关掉窗口
	if ( is_touch_other_close ) then
		self.windowsCloser:setClosingWindow(_ui_root,window_name,window_info.z)
	end

	-- added by aXing on 2014-5-2
	-- 添加默认深度，认为左中右三种默认是Active_window；dialog默认是dialog深度
	local default_z = Z_ACTIVE_WINDOW


	-- 要区分出现方式
	if window_info.appear_type ~= nil then
		-- 左界面
		if window_info.appear_type == WINDOW_APPEAR_LEFT then
			close_window(_current_all_window)
			_current_all_window = nil
			close_window(_current_left_window)
			_current_left_window = window_name
			-- window:setPosition(-window_info.width, window_info.y)
		-- 右界面
		elseif window_info.appear_type == WINDOW_APPEAR_RIGHT then
			close_window(_current_all_window)
			_current_all_window = nil
			close_window(_current_right_window)
			_current_right_window = window_name
			-- window:setPosition(800, window_info.y)
		-- 全界面
		elseif window_info.appear_type == WINDOW_APPEAR_ALL or window_info.appear_type == WINDOW_APPEAR_MIDDLE then
			close_window(_current_left_window)
			_current_left_window = nil
			close_window(_current_right_window)
			_current_right_window = nil
			close_window(_current_all_window)
			_current_all_window = window_name
			--显示黑屏底板
			--如果关闭的是全屏窗口，关闭主界面
			if window_info.appear_type ~= WINDOW_APPEAR_MIDDLE then UIManager:showMainUI(false) end
			-- window:setPosition(window_info.x, - window_info.height)
		-- 对话框(非模态)
		elseif window_info.appear_type == WINDOW_DIALOG then
			_ui_dialogs_shown[window_name] = window
			-- local function dialog_click(  )
			-- 	bring_window_front(window, Z_DIALOG_START)
			-- end
			-- window:setTouchBeganFun(dialog_click)
			--bring_window_center(window)
			default_z = Z_DIALOG_START
		-- 对话框(模态)
		elseif window_info.appear_type == WINDOW_DIALOG_MODAL then
			bring_window_center(window)
			default_z = Z_DIALOG_START
		elseif window_info.appear_type == WINDOW_DIALOG_RIGHT then
			_ui_dialogs_shown[window_name] = window
			local function dialog_click(  )
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

		end

		-- added by aXing on 2014-5-3
		-- 将移动窗口的动作，放到最后做
		-- 交给UIScreenPos处理，全部通过相对坐标做
		--locate_window(window, window_info)
	end
	
	if _ui_windows_shown[window_name] == nil then
		--_ui_root:addChild(window.view, window_info.z, window_name)
		if window_info.appear_type ~= WINDOW_APPEAR_LEFT and
		   window_info.appear_type ~= WINDOW_APPEAR_RIGHT then
		end

		if window_info.z ~= nil then
			default_z = window_info.z
		end
		_ui_root:addChild(window.view, default_z)
		_ui_windows_shown[window_name] = window
		window:active(true)		
	end

	-- move effect
	if window then
		local _type = window_info.appear_type
		if _type then 
			if window_info.appear_type <= 9 and window_name ~= "mini_map_win" then
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
					--小地图这里固定用缩放动画，因为下底拉起那个动画会造成小地图CCScrollView缩放拉大的一个bug
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
		UIManager:setBlackBackground(window.view,window_info.z,true)
	end
	if not self._isWindowsVisible then
		window.view:setIsVisible(false)
	end

	SoundManager:playUISound( 'open_win' , false )

	return window
end

-- 隐藏窗口
-- 只是取消渲染，不会删除窗口
function UIManager:hide_window( window_name )
	SoundManager:playUISound( 'close_win' , false )
	-- 指引关闭后继续玩家动作
	Instruction:continue_next()
	-- local window = UIManager:find_window(window_name)
	--默认window_info.close_type == nil 销毁窗口 2014-05-29 LuShan
	local window_info = _ui_dict[window_name]
	if not window_info.close_type or window_info.close_type == CLOSE_DESTORY then
		UIManager:destroy_window( window_name )
		return
	end

	local window = _ui_windows_shown[window_name];

	if window ~= nil then
		if window.view:retainCount() > 1 then
			UIManager:setBlackBackground(window.view,0,false)
			_ui_root:removeChild(window.view, true)
			_ui_windows_shown[window_name] = nil
			_ui_dialogs_shown[window_name] = nil
			window:active(false)
			
		else
			-- xprint('[retain<=1]can not hide window', window_name)
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



	--如果是全屏幕窗口，关闭时显示主界面
	if window_info.appear_type == WINDOW_APPEAR_ALL then
		UIManager:showMainUI(true)
	end


end

-- 开关窗口(仅调用show和hide)
function UIManager:toggle_window( window_name , is_touch_other_close)
	-- print("UIManager:toggle_window( window_name )",window_name)
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
	if (_ui_windows_shown[window_name] ~= nil) then
		return true;
	else 
		return false;
	end
end

-- 判断当前是否有打开的窗口或对话框
function UIManager:find_is_show_window_or_dialog()
	for k,v in pairs(_ui_windows_shown) do
		if ( _current_left_window or _current_all_window or _current_right_window ) then
			return true;
		end
	end
	for k,v in pairs(_ui_dialogs_shown) do
		if ( v~= nil ) then
			-- print("v = ",v,k)
			return true;
		end
	end
	return false;
end


-- 获取某一窗口当前对象指针
function UIManager:get_win_obj(window_name)
	return _ui_windows[window_name];
end

-- deleted by aXing on 2014-4-19
-- 这个东西是不对的
-- 小窗口坐标参数
-- direction: 0->left
-- function UIManager:small_win_param(direction)
-- 	local win_param = {x=400, y=48, width=393, height=438};
-- 	if (direction == 0) then
-- 		win_param.x = 5;
-- 	end
-- 	return win_param;
-- end

-- 隐藏全部窗口
function UIManager:hide_all_window(  )
	for window_name, window in pairs(_ui_windows_shown) do
		UIManager:hide_window(window_name)
	end
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
function UIManager:close_otherwise_window( name )
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

function UIManager:close_all_dialog( )
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

--[[
function MUtils.showBlackBack(b, z)
	if b then
		if not blackBackSprite then
			
		else
			blackBackSprite:retain()
			blackBackSprite:removeFromParentAndCleanup(true)
		end
		local UIRoot = ZXLogicScene:sharedScene():getUINode()
		
end
]]--

function UIManager:createWindowScreenCloser()
	self.windowsCloser = PopupView()
end

function UIManager:destroyWindowScreenCloser()
	if self.windowsCloser then
		self.windowsCloser:destroy()
		self.windowsCloser = nil
	end
end


local function _block_fun(eventType,x,y)
	return true
end

local function _noblock_fun(eventType,x,y)
	return false
end


function UIManager:createBlackBackground()
	---------------------------------------------------------
	local blackPic =  'nopack/black.png'
	self.blackBackSprite = CCBasePanel:panelWithFile( 0,0,
													  _refWidth(4.0),_refHeight(4.0),
													  blackPic )
	self.blackBackSprite:retain()
	self.blackBackSprite:setAnchorPoint(0.5,0.5)
	self.blackBackSprite:setOpacity(0)

	self.blackBackSprite:registerScriptHandler(_block_fun)
end

function UIManager:destroyBlackBackground()
	if self.blackBackSprite then
		_safeRemoveFromParentAndCleanup(self.blackBackSprite,true)
		self.blackBackSprite:release()
	end
end

function UIManager:setBlackBackground(view,z,flag,no_block)
	if flag then
		local cz = view:getContentSize()
		self.blackBackSprite:setPosition(cz.width*0.5,cz.height*0.5)
		_safeRemoveFromParentAndCleanup(self.blackBackSprite,true)
		view:addChild(self.blackBackSprite,-1)
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

	ZXLog('_ui_windows_shown >>>')
	for k,v in pairs(_ui_windows_shown) do
		ZXLog(k)
	end
	ZXLog('_ui_dialogs_shown >>>')
	for k,v in pairs(_ui_dialogs_shown) do
		ZXLog(k)
	end
	ZXLog('_ui_windows >>>')
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

function destroy_all_window()
-- 销毁窗口
	for k,v in pairs(_ui_windows) do
		UIManager:destroy_window(k)
	end
end
-- 获取窗口的配置
function UIManager:get_win_info( win_name )
	local win_info = _ui_dict[win_name]
	if win_info ~= nil then
		return win_info;
	end
end

local function reloadWin( window_name )
	local r_table = SCRIPT_PATH[window_name]
	if r_table and #r_table > 0 then
		UIManager:destroy_window(window_name);
		-- 遍历指定文件夹，把该文件夹里面的所有文件都reload
		-- local wefind = ".lua"
		-- local r_table = {};
		-- local intofolder = true;
		-- findindir (path, wefind, r_table, intofolder)
		for k,v in pairs(r_table) do
			print("reloadLayout",v)
			reloadScript(v)
		end
		-- 重新加载class
		_init()
		UIManager:show_window(window_name);
	end
end


function UIManager:reloadAllWin()
	if ( _current_left_window  ) then
		reloadWin(_current_left_window)
	end
	if _current_all_window then
		reloadWin(_current_all_window)
	end
	if _current_right_window then
		reloadWin(_current_right_window)
	end

	for k,v in pairs(_ui_dialogs_shown) do
		print("k,v",k,v)
		if ( v~= nil ) then
			reloadWin( k )
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
	UIManager:show_window("user_panel");
	--UIManager:show_window("right_panel");
	UIManager:show_window("right_top_panel");
	UIManager:show_window("menus_panel");
	UIManager:show_window("exp_panel");
	-- 要先创建活动按钮面板
	-- UIManager:create_window("activity_menus_panel");
	----
	UIManager:show_window("screen_notic_win")
	UIManager:show_window("center_notic_win")
	UIManager:show_window("screen_run_notic_win")
	UIManager:show_window("hyper_link")
	_mainUIReady = true

	if _firstShowMainUI then 

		local p0 = { _mainUIPanels[1]:getPosition() }
		local p1 = { _mainUIPanels[2]:getPosition() }
		local p2 = { _mainUIPanels[3]:getPosition() }
		----------------------------------------------------------------------------------------
		local move1 = CCMoveTo:actionWithDuration(0.5,CCPointMake(p0[1]-_ui_half_width,
																  p0[2]+_ui_half_height))
		local array = CCArray:array();
		array:addObject(move1)
		array:addObject(CCHide:action());
		_mainUIShowActions[1] = CCSequence:actionsWithArray(array);
		----------------------------------------------------------------------------------------
		local move2 = CCMoveTo:actionWithDuration(0.5,CCPointMake(p1[1]+_ui_half_width,
																  p1[2]+_ui_half_height))
		local array = CCArray:array();
		array:addObject(move2)
		array:addObject(CCHide:action());
		_mainUIShowActions[2] = CCSequence:actionsWithArray(array);
		----------------------------------------------------------------------------------------
		local move3 = CCMoveTo:actionWithDuration(0.5,CCPointMake(p2[1],
																  p2[2]-_ui_half_height))
		local array = CCArray:array();
		array:addObject(move3)
		array:addObject(CCHide:action());
		_mainUIShowActions[3] = CCSequence:actionsWithArray(array);
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

	if not _mainUIReady then
		return
	end

	if _isShowMainUI == bShow then
		return
	end 

	_isShowMainUI = bShow

	if not bShow then
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

		JoystickManager:set_visible(false)
	else
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
		
		if _mainUIPanels[3] then
			_mainUIPanels[3]:stopActionByTag(_mainUIShowActionTag)
			_mainUIPanels[3]:setIsVisible(true)
			_mainUIPanels[3]:runAction(_mainUIShowActions[6])
		end
		JoystickManager:set_visible(true)
	end
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
function UIManager:init_out(  )
	_init()
end

function UIManager:scene_leave(  )
	self:destroyWindowScreenCloser()
	UIManager:hide_all_window()

end
--特殊窗口销毁
--create by jiangjinhong 
function  UIManager:my_hide(window_name )
	-- xprint('destroy_window',window_name)
	local has_window = _ui_windows[window_name]
	if has_window == nil then
		return false
	end

	_ui_windows[window_name] = nil

	if _ui_windows_shown[window_name] ~= nil then
		_ui_windows_shown[window_name] = nil
		_ui_dialogs_shown[window_name] = nil
		UIManager:setBlackBackground(has_window.view,0,false)
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
	if window_info.appear_type == WINDOW_APPEAR_ALL then
		UIManager:showMainUI(true)
	end
	--CCTextureCache:sharedTextureCache():removeUnusedTextures();
	SoundManager:playUISound( 'close_win' , false )
	
	return true
end