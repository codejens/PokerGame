-- SLoginPlatformPage.lua
-- 平台登录界面
super_class.SLoginPlatformPage()

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)



function SLoginPlatformPage:update()

end

function SLoginPlatformPage:isVisible(visible)
	-- if visible then
	--    if Target_Platform ~= Platform_Type.Platform_YSDK then 
	--    		PlatformInterface:doLogin()
	--    end
	-- end
	self.view:setIsVisible(visible)
end

------------------------------------------

function SLoginPlatformPage:__init()
	local parent = CCBasePanel:panelWithFile( 0, 0, panelWidth, panelHeight, "")


	local function login_callback()
		if PlatformInterface.doLogin then
			PlatformInterface:doLogin()
		end
	end
	local function qq_enter_btn_fun()
        if Target_Platform == Platform_Type.Platform_YSDK then
            PlatformInterface:set_login_type("qq")
            PlatformInterface:doLogin()
        end
    end
    local function wx_enter_btn_fun()
        if Target_Platform == Platform_Type.Platform_YSDK then
            PlatformInterface:set_login_type("wx")
            PlatformInterface:doLogin()
        end
    end

	if Target_Platform == Platform_Type.Platform_YSDK  then
		local btn1 = SButton:quick_create("", panelWidth/2 - 155, 71, -1, -1, "sui/login/qqlogin.png", nil, nil, nil, false)
		btn1.view:setAnchorPoint(0.5, 0)
		parent:addChild(btn1.view)
		local btn2 = SButton:quick_create("", panelWidth/2 + 155, 71, -1, -1, "sui/login/wxlogin.png", nil, nil, nil, false)
		btn2.view:setAnchorPoint(0.5, 0)
		parent:addChild(btn2.view)
		btn1:set_click_func(qq_enter_btn_fun)
		btn2:set_click_func(wx_enter_btn_fun)
	else
		-- local btn = SButton:create("sui/login/btn.png")
		-- parent:addChild(btn.view)
		-- local btn_size = btn:getSize()
		-- btn:setPosition(panelWidth/2 - btn_size.width/2,166)
		-- btn:set_click_func(login_callback)
		-- local sp = SImage:quick_create(0,0,"sui/login/loginLab.png",btn)
		-- sp:setAnchorPoint(0.5,0.5)
		-- sp:setPosition(btn_size.width/2,btn_size.height/2)
		-- btn:setIsVisible(false)
	end
	self.view = parent
end

-- 获取UI控件
function SLoginPlatformPage:save_widget( )
	--定义好需要用到的控件
end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function SLoginPlatformPage:registered_envetn_func(  )

end


function SLoginPlatformPage:destroy()
	if self.view ~= nil then
		self.view:removeFromParentAndCleanup(true);
		self.view = nil
	end
end
