--注册窗口

RegisterWin = simple_class(GUIWindow)

---对外接口---
--返回登录按钮回调
local function back_btn_func()
    RegisterCC:back_login()
end

--创建帐号按钮回调
local function create_btn_func(username,password,affirm_password)
    RegisterCC:create_account(username,password,affirm_password)
end

--------------

function RegisterWin:__init( view )
	printInfo("RegisterWin:__init ::: ")
	self:register_listener()
end

function RegisterWin:register_listener( ... )
  	local function _cb_func_1(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local username = self:findWidgetByName("TextField_1")
            local password = self:findWidgetByName("TextField_2")
            local affirm_password = self:findWidgetByName("TextField_2_1")
            create_btn_func(username,password,affirm_password)
        end
    end    
	-- self:addTouchEventListener('Button_1',_cb_func_1)

    local function _cb_func_2(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            back_btn_func()
        end
    end    
    -- self:addTouchEventListener('Button_2',_cb_func_2)
end
