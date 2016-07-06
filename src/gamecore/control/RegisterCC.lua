--RegisterCC.lua
--created by liubo on 2015-05-04
--注册控制器

RegisterCC = {}

function RegisterCC:init()

end

function RegisterCC:finish( ... )
	
end

--打开注册窗口
function RegisterCC:open_register_win()
	GUIManager:hide_window("login_win")
	GUIManager:show_window('register')
end

--返回登录
function RegisterCC:back_login()
	GUIManager:hide_window('register')
	GUIManager:show_window("login_win")
end

--创建帐号
function RegisterCC:create_account(username,password,affirm_password)
	local username_str = username:getString()
	local password_str = password:getString()
	local affirm_password_str = affirm_password:getString()
	if not RegisterCC:check_input_method(username_str) then
		print("用户名不合法")
		return
	end
	if not RegisterCC:check_input_method(password_str) then
		print("密码不合法")
		return
	end
	if not RegisterCC:check_input_method(affirm_password_str) then
		print("确认密码不合法")
		return
	end
	if password_str ~= affirm_password_str then
		print("两次输入的密码不一致")
		return
	end
	GUIManager:hide_window('register')
	local win = GUIManager:show_window("login_win")
	win:set_account_password(username_str,password_str)
end

--检查输入是否合法
function RegisterCC:check_input_method(str)
	if not str or str == "" then
		return false
	end
	if string.len(str) < 5 or string.len(str) > 20 then
		return false
	end
	if string.find(str,'%W+') then 
		return false
	end
	return true
end