-- loginWin.lua
-- 登录界面（输入账号密码）

super_class.loginWin(BaseEditWin)

require "SUI/login/SnewSelectServerPage"
require "SUI/login/SselectServerPage"
require "SUI/login/SregisterPage"
require "SUI/login/SnoticePage"
require "SUI/login/SLoginPlatformPage"
require "SUI/login/SselectRolePage"
require "SUI/login/SmergeServerSelectRolePage"
require "SUI/login/SbanhaoPage"

--相关标记为
local password_changed = nil

local _Z_NO_OPERATE = 1001
local _Z_NOTICE     = 1000

-- 创建游戏登录界面
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _create2Flow = effectCreator.create2Flow
local _create4Flow = effectCreator.create4Flow

local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)
local FONT_SIZE = 20

local ws = ZXgetWinSize().width

-- 外部静态调用  login  select_role   select_server 
-- (这个先这么写，新方案不知道用不用，先这么做避免有bug) 
function loginWin:change_login_page( page_name )
    self:change_page( page_name )
end

----------------------------------------------------------------------------------------

-- 最上层的遮罩阻止操作
function loginWin:lock_operate(if_show)
	self.no_operate_image:setIsVisible(if_show)
end

-- 销毁窗口
function loginWin:destroy()
	if self.select_role_page then
		self.select_role_page:destroy()
	end

	if self.select_server_page then
		self.select_server_page:destroy()
	end

	if self.register_page then
		self.register_page:destroy()
	end

	if self.new_select_server_page then
		self.new_select_server_page:destroy()
	end

	if self.notice_page then
		self.notice_page:destroy()
	end

	if self.banhao_page then
		self.banhao_page:destroy()
	end

	BaseEditWin.destroy(self)
end

function loginWin:isVisible(if_show)
	self.view:setIsVisible(if_show)
end

-- 设置注册页面的标记位为nil，将隐藏的东西重新渲染
function loginWin:close_register_interface()
	self.register_page = nil
end

------------------------------------------

function loginWin:__init()
	self.login_page = self
	table.insert(self.page_t, self.login_page)

	SoundManager:playeSceneMusic(500, true)
  	-- 添加遮罩层
  	self.no_operate_image = CCBasePanel:panelWithFile( 0, 0, panelWidth, panelHeight, "", 500, 500 )
    self.no_operate_image:setDefaultMessageReturn(true)
    self.view:addChild( self.no_operate_image, _Z_NO_OPERATE )
    self:lock_operate( false )
 	--粒子特效
    local p1 = CCParticleSystemQuad:particleWithFile("particle/piaoluodehuaban.plist")
    p1:setPosition(CCPointMake(150,600))
    self.huaba_effect = p1
    self.view:addChild(p1,100)
    local s = self.view:getContentSize()
    local call = callback:new()
    local function time_callback()
		self:quick_game()
    end
    call:start(1,time_callback)
end

-- 获取UI控件
function loginWin:save_widget()
	--定义好需要用到的控件
	self.root = self:get_widget_by_name("root")
 	
 	-- 存储已创建的每页的对象
	self.page_t = {}

	self.btn_quick_game = self:get_widget_by_name("btn_quick_game")
	-- 根节点
	self.winRoot = self:get_widget_by_name("win_root")
	self.winRoot:setSize(panelWidth, panelHeight)

	-- 账号输入框
	self.account = self:get_widget_by_name("account")
	self.account:setInputColor("#cffffff")

	-- 密码输入框
	self.passWord = self:get_widget_by_name("passWord")
	self.passWord:setInputColor("#cffffff")

	-- 账号输入框背景
	self.accountBg = self:get_widget_by_name("panel_1")

	self.account_error_tips = SLabel:quick_create("#cff0000账号不能包含非字母、数字的字符",0,-23,self.accountBg)
	self.account_error_tips:setIsVisible(false)
	-- 密码输入框背景
	self.passWordBg = self:get_widget_by_name("panel_2")
	
	-- 账号暗语提示
	self.accountTips = self:get_widget_by_name("label_1")

	-- 密码暗语提示
	self.passWordTips = self:get_widget_by_name("label_2")

	-- 如果有记录账号和密码的话下次不用再输入
	self:get_account_and_password()
	
	-- 登录按钮
	self.login_btn = self:get_widget_by_name("btn_1")
	self.login_btn.view:setPositionX(panelWidth / 2 - self.login_btn.view:getContentSize().width / 2)
	
	-- 注册新用户
	-- self.registe_btn = self:get_widget_by_name("registeBtn")
	-- self.registe_btn.view:setPositionX(panelWidth / 2 - self.registe_btn.view:getContentSize().width / 2)
	
	-- 公告
	self.notice = self:get_widget_by_name("notice")
	local size1 = self.notice.view:getContentSize()
	self.notice.view:setPosition(panelWidth - self.notice.view:getContentSize().width - 25, panelHeight - size1.height*2 - 29)

	-- 版号
	self.banhao = self:get_widget_by_name("banhao")
	-- self.banhao.view:setPosition(panelWidth - self.banhao.view:getContentSize().width - 25, panelHeight - size1.height*3 - 29)
	self.banhao.view:setPosition(0, self.banhao.view:getPositionY() - 20)
	-- 输入框背景
	self.input_bg = self:get_widget_by_name("panel_4")
	self.input_bg.view:setPositionX(panelWidth / 2 - self.input_bg.view:getContentSize().width / 2)

	-- 长歌行图标
	-- self.SHJLogo = self:get_widget_by_name("img_2")
	-- self.SHJLogo:setAnchorPoint(0.5, 1)
	-- self.SHJLogo:setPosition(panelWidth / 2, panelHeight - 35)
	-- 外网测试按钮
	-- self.out_net_btn = self:get_widget_by_name("out_net_btn")
	
	-- 登录界面背景
	-- self.loginBg = CCZXImage:imageWithFile(panelWidth/2, panelHeight/2, -1, -1, "nopack/hall_function_bg.jpg", 0, 0)
	-- self.loginBg:setAnchorPoint(0.5, 0.5)
	-- local size   = self.loginBg:getSize()
 --    local scalex = panelWidth/size.width
 --    local scaley = panelHeight/size.height
 --    local scale  = math.max(scalex, scaley)
 --    self.loginBg:setScale(scale)
	-- self.view:addChild(self.loginBg, -1)

	--版本号背景面板
	self.versionPanel = self:get_widget_by_name("panel_3")
	self.versionPanel:setSize(_refWidth(1), 34)

	--适配处理
	self.fcm_bg = self:get_widget_by_name("panel_5")
	self.fcm_bg:setSize(panelWidth, 35)
	self.fcm_bg.view:setPositionX(panelWidth/2)
	self.fcm_bg.view:setAnchorPoint(0.5, 0)
	self.fcm_desc = self:get_widget_by_name("label_9")
	self.fcm_desc.view:setPositionX(panelWidth/2)

	-- 版本字体控件
	self.label_version = self:get_widget_by_name("version")
	local ver = CCVersionConfig:sharedVersionConfig():getStringForKey("current_version")
	if ver == "1.04.09" then
		ver = "1.04.06"
	end
	local release_time
	if release_time == nil then
		release_time = ""
	else
		local date = os.date("*t",release_time)
		release_time = "." .. date.month .. date.day .. date.hour .. date.min .. ""
	end
	self.label_version:setText("#cf3dbb2"..ver .. release_time)
end

function loginWin:quick_game()

	local root = GameStateManager:get_game_root()

	--SceneLoadingWin:show_instance(nil,100,100)
	-- 初始化UI节点模块
	-- UIManager:init(root)				-- 初始化UI

	-- UIManager:destroy_window("login_win")
	RoleModel:destroy_login_win()
	-- UIManager:show_window("main_hall_win")
	MainHallModel:show_window()

end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function loginWin:registered_envetn_func()
	-- 账号输入框回调
	self.account.view:registerScriptHandler(bind(self.account_editBox_msg_func, self))

	-- 密码输入框回调
	self.passWord.view:registerScriptHandler(bind(self.passWord_editBox_msg_func, self))

	-- 登录按钮回调
	self.login_btn:set_click_func(bind(self.log, self))

    -- 注册新用户回调
	-- self.registe_btn:set_click_func(bind(self.register, self))

	-- 公告回调
	self.notice:set_click_func(bind(self.noticeCallback, self))
	
	-- 版号回调
	self.banhao:set_click_func(bind(self.banhaoCallback, self))

	self.btn_quick_game:set_click_func(bind(self.quick_game,self))

	-- 隐藏外网测试按钮
	-- self.out_net_btn:setIsVisible(false)
end

--获取进入游戏分页对象
function loginWin:get_new_select_server_page()
	return self.new_select_server_page
end

-- 登录
function loginWin:log()
	if BISystem.login then
		BISystem:login()
	end
	local tempinfo = self.account:getText()
	local temppass = self.passWord:getText()
	
	if string.find(tempinfo,"[^%d^%a]") ~= nil then
		-- self.accountTips:setIsVisible(true)
		self.account_error_tips:setIsVisible(true)
		-- GlobalFunc:create_screen_notic("账号存在非法字符,只能输入字母+数字")
		return
	else
		self.account_error_tips:setIsVisible(false)
	end
	if tempinfo == "" and temppass == "" then
		self.accountTips:setIsVisible(true)
		self.passWordTips:setIsVisible(true)
		return
	elseif tempinfo == "" then
		self.accountTips:setIsVisible(true)
		return
	elseif temppass == "" then
		self.passWord:setIsVisible(true)
		return
	end
	
	self:widgetVisible(false)
	if tempinfo == "" or temppass == "" then
		if self.inputErrorPop == nil then
			local root = ZXLogicScene:sharedScene()
			self.inputErrorPop = PopupNotify(root:getUINode(),
			10000, STRING_EMPTY_USR_PW,
			STRING_OK, nil,
			POPUP_OK,
			function(...) self.inputErrorPop = nil end)
		end
	else
		local data = {}
		data.uid = tempinfo
		data.pwd = temppass
		data.password_changed = self.password_changed

		PlatformInterface:onLoginResult(0, data)
	end
end

-- 注册
function loginWin:register()
	if self.register_page == nil then
		self.register_page = SregisterPage("register_page", nil, nil, 960, 640, nil, "register_page")
		self.view:addChild(self.register_page.view, 10)
		table.insert(self.page_t, self.register_page)
	end
	self.register_page:clear_all()
	self.current_page = self.register_page
	self.register_page:isVisible(true)
	self:widgetVisible(false)
end

-- 账号输入框
function loginWin:account_editBox_msg_func( eventType, arg, msgid, selfItem )
	if eventType == nil then
		return
	elseif eventType == KEYBOARD_FINISH_INSERT then
		KeyBoardModel:hide_keyboard()
	elseif eventType == KEYBOARD_ENTER then
	elseif eventType == KEYBOARD_CLICK then
		self.accountTips:setIsVisible(false)
	elseif eventType == KEYBOARD_ATTACH then
		self.accountTips:setIsVisible(false)
		if self.passWord:getText() == "" then
			self.passWordTips:setIsVisible(true)
		end
	elseif eventType == KEYBOARD_WILL_SHOW then
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_show(keyboard_width, keyboard_height)
	elseif eventType == KEYBOARD_BACKSPACE then
		if self.account:getText() == "" then
			self.accountTips:setIsVisible(true)
		end
	elseif eventType == KEYBOARD_WILL_HIDE then
		-- local temparg = Utils:Split(arg, ":")
		-- local temparg_height = tonumber(temparg[1])
		-- local temparg_width = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)
	end
	return true
end

-- 键盘事件
function loginWin:keyboard_will_show( keyboard_w, keyboard_h )
    self.is_keyboard_show=true
end

-- 隐藏键盘
function loginWin:keyboard_will_hide( keyboard_w, keyboard_h )
    self.is_keyboard_show=false
end

-- 手动关闭键盘
function loginWin:hide_keyboard()
    if self.passWord.view and self.is_keyboard_show then
        self.passWord.view:detachWithIME()
    end
    if self.account.view and self.is_keyboard_show then
        self.account.view:detachWithIME()
    end
end

-- 密码输入框
function loginWin:passWord_editBox_msg_func( eventType, arg, msgid, selfItem )
	if eventType == nil then
		return 
	elseif eventType == KEYBOARD_FINISH_INSERT then
		KeyBoardModel:hide_keyboard()
	elseif eventType == KEYBOARD_ATTACH then
		self.passWordTips:setIsVisible(false)
		if self.account:getText() == "" then
			self.accountTips:setIsVisible(true)
		end
		self.password_changed = true
	elseif eventType == KEYBOARD_CLICK then
		self.passWordTips:setIsVisible(false)
	elseif eventType == KEYBOARD_CLICK then
		self.password_changed = true
	elseif eventType == KEYBOARD_BACKSPACE then
		self.password_changed = true
		if self.passWord:getText() == "" then
			self.passWordTips:setIsVisible(true)
		end
	elseif eventType == KEYBOARD_WILL_SHOW then  -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_show(keyboard_width, keyboard_height)
	elseif eventType == KEYBOARD_WILL_HIDE then	   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)
	end
	return true
end

-- 公告回调
function loginWin:noticeCallback()
	RoleModel:change_login_page( "notice" )
end

-- 版号回调
function loginWin:banhaoCallback()
	RoleModel:change_login_page( "banhao" )
end

function loginWin:get_account_and_password()
	local _name = CCUserDefault:sharedUserDefault():getStringForKey("user_name")
	if _name then
		self.account:setText(_name) 
		self.accountTips:setIsVisible(false)
	end
	local pw = RoleModel:getPassword(_name)
	if pw then
		self.passWord:setText(pw)
		self.passWordTips:setIsVisible(false)
	end
end

-- 控制输入框，字符等的可视
function loginWin:widgetVisible(fot)
	self.login_btn:setIsVisible(fot)
	-- self.registe_btn:setIsVisible(fot)
	self.notice:setIsVisible(fot)
	self.account:setIsVisible(fot)
	self.passWord:setIsVisible(fot)
	self.banhao:setIsVisible(fot)
	self.accountBg:setIsVisible(fot)
	self.passWordBg:setIsVisible(fot)
	self.input_bg:setIsVisible(fot)
end

function loginWin:update_win(update_type)
	self:update(update_type)
end

function loginWin:update(update_type)
	if update_type == "all" then
	elseif update_type == "create_error_account" then
		if self.current_page.update then
			self.current_page:update("create_error_account")
		end
	elseif update_type == "new_select_server_list" then
		--服务器列表
		if self.new_select_server_page and self.new_select_server_page.update then
			self.new_select_server_page:update()
		end
	else
		if self.current_page.update then
			self.current_page:update(update_type)
		end
	end
end

function loginWin:show_notice_register( count, password, yes_callback )
	self.notice_panel_cb_func = yes_callback
    local ltt_win_w = 360
    local ltt_win_h = 280
    if self.notice_reg_panel == nil then
        self.notice_reg_panel = CCBasePanel:panelWithFile( 0, 0, panelWidth, panelHeight, "" )

        -- 窗口背景  和 台头
        self.words_bg = CCBasePanel:panelWithFile( _refWidth(0.5) , _refHeight(0.5), ltt_win_w, ltt_win_h, UILH_COMMON.dialog_bg, 500, 500 )
        self.words_bg:setAnchorPoint(0.5,0.5)
       
        -- 内框
        self.panel_inside = CCBasePanel:panelWithFile(15, 15, 332, 238, UILH_COMMON.bottom_bg, 500, 500 )
        self.words_bg:addChild( self.panel_inside )

        local title_bg = CCZXImage:imageWithFile( ltt_win_w*0.5, ltt_win_h-10, -1, -1, UILH_COMMON.title_bg )  -- 307, 60
        title_bg:setAnchorPoint( 0.5, 0.5 )
        self.words_bg:addChild( title_bg )
        local title    = CCZXImage:imageWithFile( 307*0.5, 60*0.5, -1, -1, UILH_NORMAL.title_tips )
        title:setAnchorPoint(0.5,0.5)
        title_bg:addChild( title )

        -- 提示
        local tip_1 = UILabel:create_lable_2( S_COLOR[1].. "使用以下账号密码进入游戏：", ltt_win_w*0.5, 195, 14, ALIGN_CENTER )
        self.words_bg:addChild( tip_1 )

        -- 账号
        local count_title = CCZXImage:imageWithFile( 100, 155, -1, -1, "ui2/login/lh_accout.png" )
        self.words_bg:addChild( count_title )
        self.count_value = UILabel:create_lable_2( count, ltt_win_w*0.5, 160, 14, ALIGN_LEFT )
        self.words_bg:addChild( self.count_value )

        -- 密码
        local pwd_title    = CCZXImage:imageWithFile( 100, 125, -1, -1, "ui2/login/lh_pwd.png" )
        self.words_bg:addChild( pwd_title )
        self.pass_value = UILabel:create_lable_2( password, ltt_win_w*0.5, 130, 14, ALIGN_LEFT )
        self.words_bg:addChild( self.pass_value )

        -- 分割线
        local line = CCZXImage:imageWithFile( 25, 100, 310, 3, UILH_COMMON.split_line)
        self.words_bg:addChild( line )

        -- 确定按钮
        local function apply_but_CB()
            self.notice_reg_panel:setIsVisible( false )
            if self.notice_panel_cb_func then 
                self.notice_panel_cb_func()
            end
        end
        self.apply_but = ZTextButton:create(self.words_bg, "确定",UILH_COMMON.lh_button2, apply_but_CB, ltt_win_w*0.5-99*0.5,26,-1,-1)

        self.notice_reg_panel:addChild( self.words_bg )
        self.view:addChild( self.notice_reg_panel, _Z_NOTICE )

        -- 点击任何地方，都关闭
        local function f1( eventType, x, y )
            if eventType == TOUCH_BEGAN then
                self.notice_reg_panel:setIsVisible( false )
                return true
            elseif eventType == TOUCH_CLICK then
                return false
            elseif eventType == TOUCH_ENDED then
                return false
            end
        end
        self.notice_reg_panel:registerScriptHandler(f1)
    end

    self.notice_reg_panel:setIsVisible( true )
    self.count_value:setText(count)
    self.pass_value:setText(password)
end

-- RoleModel有修改，需要这个函数，但是不知道干嘛的，先这么写
function loginWin:show_notice(notice_content, x, y, yes_callback)
	self.notice_panel_cb_func = yes_callback
	local ltt_win_w = 470+30
	local ltt_win_h = 300+30
	if self.notice_panel == nil then
		self.notice_panel = CCBasePanel:panelWithFile(0, 0, panelWidth, panelHeight, "", 500, 500)
		self.words_bg = CCBasePanel:panelWithFile( _refWidth(0.5) , _refHeight(0.5), ltt_win_w, ltt_win_h, "sui/common/tipsPanel.png", 500, 500 )
		-- tipsPanel
        self.words_bg:setAnchorPoint(0.5,0.5)
			
		--内背景
		local bg = CCBasePanel:panelWithFile(33,100,434,164,"sui/common/panel2.png",500,500)
		self.words_bg:addChild(bg)

		local title_bg = CCZXImage:imageWithFile( ltt_win_w*0.5, ltt_win_h-18, -1, -1, "sui/common/little_win_title_bg.png" )  -- 307, 60
        title_bg:setAnchorPoint( 0.5, 0.5 )
        self.words_bg:addChild( title_bg )

        local title = CCZXImage:imageWithFile( 336*0.5, 47*0.5, -1, -1, "sui/tips/tishi.png"  )
        title:setAnchorPoint(0.5,0.5)
        title_bg:addChild( title )

        self.content_dialog = CCZXLabel:labelWithText(215,74,"#c854c0f" .. notice_content,20,ALIGN_CENTER);

        bg:addChild(self.content_dialog)
        -- 确定按钮
        local function apply_but_CB()
            self.notice_panel:setIsVisible( false )
            if self.notice_panel_cb_func then 
                self.notice_panel_cb_func()
            end
        end
		self.apply_but = ZTextButton:create(self.words_bg, "","sui/common/btn_1.png", apply_but_CB, ltt_win_w*0.5,26,-1,-1)
		self.notice_panel:addChild( self.words_bg )
        self.view:addChild( self.notice_panel, _Z_NOTICE )
        local s = self.apply_but.view:getContentSize()
        local btn_name = CCZXImage:imageWithFile(s.width/2,s.height/2,-1,-1,"sui/btn_name/queding.png")
        self.apply_but.view:addChild(btn_name)
        btn_name:setAnchorPoint(0.5,0.5)
        self.apply_but:setPosition(ltt_win_w*0.5 - s.width/2,26)
		
         -- 点击任何地方，都关闭
        local function f1(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                self.notice_panel:setIsVisible( false )
                return true
            elseif eventType == TOUCH_CLICK then
                return false
            elseif eventType == TOUCH_ENDED then
                return false
            end
        end
        self.notice_panel:registerScriptHandler(f1)
	end
 	self.notice_panel:setIsVisible( true )
    self.content_dialog:setText("#c854c0f" .. notice_content )
end

--出现欢迎玩家回来的字眼
function loginWin:welcome()
	--暂时先屏蔽
	--[[if not self.label then
		local logWin  = RoleModel:get_login_win()
		self.label_bg = SPanel:quick_create(0, 0, 350, -1,"sui/login/welcome_label_bg.png", true, logWin.view)
		local bg_size = self.label_bg.view:getContentSize()
		self.label = SLabel:quick_create("#cf6e4c4亲爱的玩家，欢迎回来!", bg_size.width/2, bg_size.height/2, self.label_bg, nil, 18)
		self.label:setAnchorPoint(0.5, 0.5)
	end
	local name        = RoleModel:get_user_name_list()
	local name_string = name[1]
	if name_string == nil or name_string == "" then
		name_string   = "亲爱的玩家"
	end
	self.label:setText("#cf6e4c4"..name_string.."，欢迎回来!")
	self.label_bg.view:stopAllActions()
	local bg_size = self.label_bg.view:getContentSize()
	self.label_bg:setPosition((panelWidth-bg_size.width)/2, panelHeight+5)
	local arr      = CCArray:array()
	local movedown = CCMoveBy:actionWithDuration(1, CCPoint(0, -bg_size.height-7))
	local moveup   = CCMoveBy:actionWithDuration(1, CCPoint(0, bg_size.height+7))
	local delay    = CCDelayTime:actionWithDuration(1.5)
	arr:addObject(movedown)
	arr:addObject(delay)
	arr:addObject(moveup)
	local sequence = CCSequence:actionsWithArray(arr)
	self.label_bg.view:runAction(sequence)]]
end

-- 该函数用于切换登录界面的各个页面，但是前面有句
-- self.current_page:hide_to_left()这句话用来将当前页面隐藏掉，但是现在不确定采取什么方法
-- 先简单地隐藏
function loginWin:change_page(page_name)
	if self.current_page and self.old_page_name ~= "login" then
		self.current_page:isVisible(false)
	end
	self.login_page:widgetVisible(false)
	self.huaba_effect:setIsVisible(true)
    if page_name == "new_select_server_page" then
	    if self.new_select_server_page == nil then
			self.new_select_server_page = newSelectServerPage("new_select_server_page", nil, nil, panelWidth, panelHeight, nil, "new_select_server_page")
			self.view:addChild(self.new_select_server_page.view)
			table.insert(self.page_t, self.new_select_server_page)
		end
		self.current_page = self.new_select_server_page
		self.new_select_server_page:isVisible(true)
	elseif page_name == "select_server" then
		require "UI/UI_Utilities"
		UI_Utilities.CreateFixButton()
		UI_Utilities.CreateResourceFixButton()
		if self.select_server_page == nil then
			self.select_server_page = selectServerPage("select_server", nil, nil, 960, 640, nil, "select_server")
			self.select_server_page.view:setPosition(panelWidth/2, panelHeight/2)
			self.select_server_page.view:setAnchorPoint(0.5, 0.5)
			self.view:addChild(self.select_server_page.view)
			table.insert(self.page_t, self.select_server_page)
		end
		self.current_page = self.select_server_page
		self.select_server_page:isVisible(true)
	elseif page_name == "login" then
		self.current_page = self.login_page
		self.login_page:widgetVisible(true)
		self:welcome()
	elseif page_name == "select_role" then
		self.huaba_effect:setIsVisible(false)
		require "UI/UI_Utilities"
		UI_Utilities.DestroyAdButton()
		UI_Utilities.DestroyFixButton()
		UI_Utilities.DestroyResourceButton()
		if self.select_role_page == nil then
			self.select_role_page = SelectRolePage("SelectRolePage", "", false, panelWidth, panelHeight)	
			self.view:addChild(self.select_role_page.view)
			table.insert(self.page_t, self.select_role_page)
		else
			self.select_role_page:play_sound_effect()
		end
		self.current_page = self.select_role_page
		self.enter_role_callback = callback:new()
		local function enter_role_func()
			self.enter_role_callback:cancel()
			self.enter_role_callback = nil
		end
		self.enter_role_callback:start(0.5, enter_role_func)
		self.select_role_page.view:setIsVisible(true)
		if self.select_role_page and self.select_role_page.view:getIsVisible() then
 			RoleModel:apply_random_name(self.select_role_page.sex)
 			RoleModel:apply_random_job()
 		end
 		local server_id = RoleModel:get_login_info().server_id
 		BISystem:send_cgx_log(4, GameUrl_global:get_uid(), nil, nil, server_id)
	elseif page_name == "register" then
		if self.register_page == nil then
			self.register_page = RegisterPage("", {texture = "", x = -panelWidth, y = 0, width = panelWidth, height = panelHeight})
			self.view:addChild(self.register_page.view)
			table.insert(self.page_t, self.register_page)
		end
		self.current_page = self.register_page
		self.register_page:isVisible(true)
	elseif page_name == "select_alive_role_page" then
	    --测试合服选择角色界面
	    if self.merge_server_select_role == nil then
	    	self.merge_server_select_role = SmergeServerSelectRolePage("merge_server_select_role_win", nil, nil, 960, 640, nil, "merge_server_select_role_win")
	    	self.merge_server_select_role.view:setPosition(panelWidth/2, panelHeight/2)
			self.merge_server_select_role.view:setAnchorPoint(0.5, 0.5)
			self.view:addChild(self.merge_server_select_role.view)
			table.insert(self.page_t, self.merge_server_select_role)
	    end
		self.current_page = self.merge_server_select_role
		self.merge_server_select_role.view:setIsVisible(true)
	elseif page_name == "notice" then
		if self.notice_page == nil then
			self.notice_page = noticePage("notice_page", nil, nil, 960, 640, nil, "notice_page")
			self.notice_page.view:setPosition(panelWidth/2, panelHeight/2)
			self.notice_page.view:setAnchorPoint(0.5, 0.5)
			self.view:addChild(self.notice_page.view, 20)
			table.insert(self.page_t, self.notice_page)
		end
		self.current_page = self.notice_page
		self.notice_page:isVisible(true)
	elseif page_name == "banhao" then
		if self.banhao_page == nil then
			self.banhao_page = banhaoPage("banhao_page", nil, nil, 960, 640, nil, "banhao_page")
			self.banhao_page.view:setPosition(panelWidth/2, panelHeight/2)
			self.banhao_page.view:setAnchorPoint(0.5, 0.5)
			self.view:addChild(self.banhao_page.view, 20)
			table.insert(self.page_t, self.banhao_page)
		end
		self.current_page = self.banhao_page
		self.banhao_page:isVisible(true)
	elseif page_name == "login_platform" then
		if self.login_platform_page == nil then
			self.login_platform_page = SLoginPlatformPage()
			self.view:addChild(self.login_platform_page.view)
			table.insert(self.page_t, self.login_platform_page)
		end
		self.current_page = self.login_platform_page
		self.current_page:isVisible(true)
	end
	self.lasttime_page_name = self.old_page_name
	self.old_page_name = page_name
end

function loginWin:get_lasttime_page_name()
	return self.lasttime_page_name
end