-- ExampleWin.lua
-- windows 创建范例 (基于ui编辑器的)

super_class.SregisterPage(BaseEditWin)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)
-- 对外接口：事件处理、更新接口-----------
local  function btn_xx( eventType, x, y, self )
	-- body
end 

-- 参数可以根据需求定义，table或者多参 等等
-- @param date是个table 包括字段（需要说明 如下）
-- id 人物id
-- text 按钮名字
function SregisterPage:update_btn( date )
	--这里做更新操作 尽量再封装一次 保证前面代码比较少 方便别人调用
	--self:_update_btn()
end

-- 设置该页面的可视
function SregisterPage:isVisible(if_show)
	self.view:setIsVisible(if_show)
end

-- 检查该账号密码输入的时候是否合法
local function check_if_string_legal(str)
	local len = string.len(str)
	local result = false
	local lab = nil
	local temp = nil
	for k = 1, len do
		lab = string.sub(str, k, k)
		temp = tonumber(string.byte(lab))
		if (48 <= temp and temp <= 57) or (97 <= temp and temp <= 122) then
			result = true
		else
			result = false
			return result
		end
	end
	return result
end

-- 判断密码是否完全没有问题，没有特殊字符，没有不一致
function SregisterPage:check_password_if_all_right()
	local result = false
	local passwordText = self.password:getText()
	local ensurePasswordText = self.ensurePassword:getText()

	if passwordText ~= '' then
		if check_if_string_legal(passwordText) then
			result = true
		else
			return false, 1   -- 返回1表示第一个密码有问题
		end
	end

	if ensurePasswordText ~= '' then
		
		if check_if_string_legal(ensurePasswordText) and 
			ensurePasswordText == passwordText then
			result = true
		else
			return false, 2   -- 返回2表示第二个密码跟第一个密码不一样
		end
	end

	return result
end

function SregisterPage:errorTipsVisible(fot)
	-- self.accountErrorTips:setIsVisible(fot)
	self.passwordErrorTips:setIsVisible(fot)
	self.ensurePassWordErrorTips:setIsVisible(fot)
	self.accountIsOkTips:setIsVisible(fot)
	self.passWordIsOkTips:setIsVisible(fot)
	self.ensurePassWordIsOkTips:setIsVisible(fot)
	self.accountIsExsist:setIsVisible(fot)
end
------------------------------------------

function SregisterPage:__init(  )
	

	-- self.rootPanel = self:get_widget_by_name("panel_3")
	-- ----print("000000000000000000000000000000000000", self.rootPanel)
	-- local function register_main_msg_fun(eventType,x,y)
	-- 	if eventType == CCTOUCHBEGAN then

	-- 		return false
	-- 	elseif eventType == CCTOUCHENDED then
	-- 		check_password_if_all_right()
	-- 		return false
	-- 	end
	-- end

	-- self.rootPanel:registerScriptTouchHandler(register_main_msg_fun, false, 0, false)
end

-- 获取UI控件
function SregisterPage:save_widget( )
	--定义好需要用到的控件
	self.root = self:get_widget_by_name("root")
	-- 账号提示
	self.accountTips = self:get_widget_by_name("accountTips")

	-- 密码提示
	self.passWordTips = self:get_widget_by_name("passwordTips")

	-- 再次输入密码提示
	self.ensurePassWordTips = self:get_widget_by_name("label_7")
	-- 错误的账号提示
	self.accountErrorTips = self:get_widget_by_name("accountErrorTips")

	-- 错误的密码提示
	self.passwordErrorTips = self:get_widget_by_name("label_1")

	-- 错误的确认密码提示（密码不一致）
	self.ensurePassWordErrorTips = self:get_widget_by_name("label_2")

	-- 账号标识
	self.accountIsOkTips = self:get_widget_by_name("img_6")

	-- 密码标识
	self.passWordIsOkTips = self:get_widget_by_name("img_7")

	-- 确认密码标识
	self.ensurePassWordIsOkTips = self:get_widget_by_name("img_8")

	-- 账号已存在的label
	self.accountIsExsist = self:get_widget_by_name("label_4")

	-- 注册面板
	self.registerPanel = self:get_widget_by_name("panel_1")
	self.registerPanel.view:setPositionX(panelWidth / 2 - self.registerPanel.view:getContentSize().width / 2)

	-- 隐藏掉错误提示字符
	self:errorTipsVisible(false)
end

function SregisterPage:ensure_passWord_editBox_msg_func(eventType, arg, msgid, selfItem)
	if eventType == nil then
		return 
	elseif eventType == KEYBOARD_FINISH_INSERT then
		KeyBoardModel:hide_keyboard()
		if self.login_func ~= nil then
			self.login_func()
		end
	elseif eventType == KEYBOARD_ATTACH then
		self:change_edit_label()
		-- 隐藏掉错误提示
		self:errorTipsVisible(false)
		self.ensurePassWordTips:setIsVisible(false)
		self.password_changed = true

	elseif eventType == KEYBOARD_CLICK then
		self.password_changed = true
		self.ensurePassWordTips:setIsVisible(false)
	elseif eventType == KEYBOARD_BACKSPACE then
		self.password_changed = true

		if self.ensurePassword:getText() == "" then
			self.ensurePassWordTips:setIsVisible(true)
		end
	elseif eventType == KEYBOARD_WILL_HIDE then   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)

	elseif eventType == KEYBOARD_WILL_HIDE then	   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)
	end
	return true
end

function SregisterPage:passWord_editBox_msg_func(eventType, arg, msgid, selfItem)
	if eventType == nil then
		return 
	elseif eventType == KEYBOARD_FINISH_INSERT then
		KeyBoardModel:hide_keyboard()
		if self.login_func ~= nil then
			self.login_func()
		end
	elseif eventType == KEYBOARD_ATTACH then
		self:change_edit_label()
		-- 隐藏掉错误提示
		self:errorTipsVisible(false)
		self.passWordTips:setIsVisible(false)
		self.password_changed = true

	elseif eventType == KEYBOARD_CLICK then
		self.password_changed = true
		self.passWordTips:setIsVisible(false)
	elseif eventType == KEYBOARD_BACKSPACE then
		self.password_changed = true
		if self.password:getText() == "" then
			self.passWordTips:setIsVisible(true)
		end
	elseif eventType == KEYBOARD_WILL_HIDE then   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)


	elseif eventType == KEYBOARD_WILL_HIDE then	   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)
	end
	return 
end

function SregisterPage:account_editBox_msg_func(eventType, arg, msgid, selfItem)
	if eventType == nil then
		return 
	elseif eventType == KEYBOARD_FINISH_INSERT then
		KeyBoardModel:hide_keyboard()
		if self.login_func ~= nil then
			self.login_func()
		end
	elseif eventType == KEYBOARD_ATTACH then
		-- 隐藏掉刚开始的提示字符
		self:change_edit_label()
		-- 隐藏掉错误提示
		self:errorTipsVisible(false)
		self.accountTips:setIsVisible(false)
		self.password_changed = true
		self.accountIsExsist:setIsVisible(false)
	elseif eventType == KEYBOARD_CLICK then
		self.password_changed = true
		self.accountTips:setIsVisible(false)
	elseif eventType == KEYBOARD_BACKSPACE then
		if self.account:getText() == "" then
			self.accountTips:setIsVisible(true)
		end
		self.password_changed = true
	elseif eventType == KEYBOARD_WILL_HIDE then   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)


	elseif eventType == KEYBOARD_WILL_HIDE then	   -- 这里应该是手机上才能测试的，先注掉
		-- local temparg = Utils:Split(arg, ":")
		-- local keyboard_width = tonumber(temparg[1])
		-- local keyboard_height = tonumber(temparg[2])
		-- self:keyboard_will_hide(keyboard_width, keyboard_height)

	end
	return true
end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function SregisterPage:registered_envetn_func(  )
	local function closeItemCallBack()
		self:isVisible(false)
	 	RoleModel:change_login_page( "login" )
	end
	-- 关闭按钮
	self.close_btn = self:get_widget_by_name("closeitem")
	self.close_btn:set_click_func(closeItemCallBack)
	-- 账号输入框事件
	local function account_editBox_msg_func( eventType, arg, msgid, selfItem)
		return self:account_editBox_msg_func(eventType, arg, msgid, selfItem)
	end
	-- 账号输入框控件
	self.account = self:get_widget_by_name("account")
	self.account.view:registerScriptHandler(account_editBox_msg_func)

	-- 密码输入框事件
	local function passWord_editBox_msg_func( eventType, arg, msgid, selfItem)
		return self:passWord_editBox_msg_func(eventType,arg,msgid,selfItem)
	end
	-- 密码的输入框
	self.password = self:get_widget_by_name("password")
	self.password.view:registerScriptHandler(passWord_editBox_msg_func)


	-- 再次确认密码输入事件
	local function ensure_passWord_editBox_msg_func( eventType, arg, msgid, selfItem)
		return self:ensure_passWord_editBox_msg_func(eventType,arg,msgid,selfItem)
	end
	-- 再次确认密码的输入框
	self.ensurePassword = self:get_widget_by_name("surepassword")
	self.ensurePassword.view:registerScriptHandler(ensure_passWord_editBox_msg_func)

	-- 注册按钮回调函数
	local function register_callback()
		local result, Error = self:check_password_if_all_right()
		if not result and Error == 1 then
			self.passwordErrorTips:setIsVisible(true)
		elseif not result and Error == 2 then
			self.ensurePassWordErrorTips:setIsVisible(true)
		end

        -- if self:check_enter_string(  ) then
            local account  = self.account:getText()
            local password = self.password:getText()
            local ensurePassWord = self.ensurePassword:getText()
          
            local accountNum = self.account.view:getCurTextNum()
            local passwordNum = self.password.view:getCurTextNum()
            local ensurePassWordNum = self.ensurePassword.view:getCurTextNum()
         		
   --       	self.accountIsOkTips = self
			-- -- 密码标识
			-- self.passWordIsOkTips = sel
			-- -- 确认密码标识
			-- self.ensurePassWordIsOkTips

        	self.accountIsOkTips:setIsVisible(true)
        	self.passWordIsOkTips:setIsVisible(true)
        	self.ensurePassWordIsOkTips:setIsVisible(true)
        	if accountNum < 6 or accountNum > 12 then
            	self.accountIsOkTips:setTexture("sui/login/cha.png")
            else
            	self.accountIsOkTips:setTexture("sui/login/gou.png")
            end
            if passwordNum < 6 or passwordNum > 12 then
            	self.passWordIsOkTips:setTexture("sui/login/cha.png")
            else
            	self.passWordIsOkTips:setTexture("sui/login/gou.png")
            end

            if ensurePassWordNum < 6 or ensurePassWordNum > 12 or ensurePassWord ~= password then
            	self.ensurePassWordIsOkTips:setTexture("sui/login/cha.png")
            else
            	self.ensurePassWordIsOkTips:setTexture("sui/login/gou.png")
            end

            if accountNum < 6 or accountNum > 12 then
            	RoleModel:show_notice( "账号请输入6-12位字母和数字的组合！" )
            	return
            end
            if passwordNum < 6 or passwordNum > 12 then
            	RoleModel:show_notice( "密码请输入6-12位字母和数字的组合！" )
            	return
            end
            if ensurePassWordNum < 6 or ensurePassWordNum > 12 then
            	RoleModel:show_notice( "确认密码请输入6-12位字母和数字的组合！" )
            	return
            end
            if ensurePassWord ~= password then
            	RoleModel:show_notice("两次密码不一致！")
            	return
            end
            RoleModel:request_create_account( account, password )
		-- self:isVisible(false)
        -- end
	end
	-- 注册按钮
	self.register = self:get_widget_by_name("registe")
	self.register:set_click_func(register_callback)

end

-- 更改输入框中的label
function SregisterPage:change_edit_label()
	-- if self.password:getText() == '' then
	-- 	self.passWordTips:setIsVisible(true)
	-- end
	-- if self.ensurePassword:getText() == '' then
	-- 	self.ensurePassWordTips:setIsVisible(true)
	-- end
	-- if self.account:getText() == '' then
	-- 	self.accountTips:setIsVisible(true)
	-- end
end

function SregisterPage:clear_all()
	self:errorTipsVisible(false)
	self.account:setText("")
	self.password:setText("")
	self.ensurePassword:setText("")

		self.accountTips:setIsVisible(true)
		self.passWordTips:setIsVisible(true)
		self.ensurePassWordTips:setIsVisible(true)
end

-- 更新按钮
function SregisterPage:update( ttype )
	--self.btn_xx:set_xxx
	if ttype == "create_error_account" then

		self.accountIsExsist:setIsVisible(true)

		self.accountIsOkTips:setIsVisible(true)
		self.accountIsOkTips:setTexture("sui/login/cha.png")
	elseif ttype == "create_account_success" then
		self:isVisible(false)
	end
end
