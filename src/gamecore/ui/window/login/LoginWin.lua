--loginWin.lua
LoginWin = simple_class(GUIWindow)

---对外接口---
local function login_btn_func( name,passsword )
	 -- LoginModel:do_login(name,passsword)
    GUIManager:hide_window("login_win")
    GUIManager:show_window("main_win")
     -- SceneManager:init()
     -- GameLogicCC:do_enter_scene_test()
end 

local function register_btn_func()
    RegisterCC:open_register_win()
end
--------------

function LoginWin:__init( view )
	-- printInfo("LoginWin:__init ::: ")
    self:create_register_btn()
	self:register_listener()
    local user_name = helpers.CCAppConfig:sharedAppConfig():getStringForKey("user_name")
    user_name = (user_name == "") and "mytest222" or user_name
    print( user_name )
    self:findWidgetByName("yonghuming_tf"):setString( user_name )
    self:findWidgetByName("mima_tf"):setString("e10adc3949ba59abbe56e057f20f883e")

    local tips = ItemTips:create()
    tips:setPosition(100,200)
    self:addChild(tips)
    
    self:test_change_map()
  
end

local _map_name = nil
local _map_string = "jxyz"
--测试代码-0---
function LoginWin:test_change_map( ... )
    _map_name = ccui.TextField:create()
    --map_name:ignoreContentAdaptWithSize(false)
    _map_name:setFontSize(30)
    _map_name:setColor(cc.c3b(255, 0, 0))
    _map_name:setString("jxyz")
    _map_name:setPosition(450,500)
    self:addChild(_map_name)
    print(_map_name:getString())

end

function LoginWin:get_map_name( ... )
    print("_map_name",_map_string)
    return _map_string
end

--创建注册按钮
function LoginWin:create_register_btn()
    local register_button = GUIButton:create("res/ui/selectserve/left_btn_normal.png")
    register_button:setTitleText("注册帐号")
    register_button.view:setPosition(150,50)
    self.view:addChild(register_button.view)
    local function _register_func(sender,eventType)
          --print(eventType,tolua.type(sender))
        -- if eventType == ccui.TouchEventType.ended then
            GUIManager:show_window('register')
        -- end
    end    
    register_button:set_click_func(_register_func)
    -- register_button:addTouchEventListener(_register_func)
end

--设置账号、密码控件的内容
function LoginWin:set_account_password(account,password)
    local username_widget = self:findWidgetByName("yonghuming_tf")
    local password_widget = self:findWidgetByName("mima_tf")
    username_widget:setString(account)
    password_widget:setString(password)
end

--获取账号、密码控件的内容
function LoginWin:get_account_password()
    local username_widget = self:findWidgetByName("yonghuming_tf")
    local password_widget = self:findWidgetByName("mima_tf")
    local username = username_widget:getString()
    --local password = password_widget:getString()
    local password = "e10adc3949ba59abbe56e057f20f883e" --测试环境固定密码
    return username,password
end

function LoginWin:register_listener( ... )
    --开始游戏
  	local function _login_func(sender,eventType)
        -- if eventType == ccui.TouchEventType.ended then
	      	local username,password = self:get_account_password()
            _map_string = _map_name:getString()
	      	login_btn_func(username,password)       
            -- print("username = ",username)
            -- xprint("password = ",password)

        -- end
    end    
	self:addTouchEventListener('login_button',_login_func)
    
end