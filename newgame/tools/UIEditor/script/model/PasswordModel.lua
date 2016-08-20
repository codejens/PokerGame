-- PasswordModel.lua
-- created by lyl on 2012-6-5
-- 密码系统

PasswordModel = {}

local _modify_reuslt = ""      -- 修改结果字符串保存

function PasswordModel:fini()
    _modify_reuslt = ""
end

-- 获取修改结果
function PasswordModel:get_modify_result_word(  )
	return _modify_reuslt
end

-- 判断原密码是否正确
function PasswordModel:check_pre_password(  )
	return true
end

-- 发送修改请求
function PasswordModel:request_modify_password( pre_password, new_password )
	print("account, pre_password, new_password    ", pre_password, new_password )
	local notice_content = ""

    local login_info = RoleModel:get_login_info(  )
    local account = login_info.user_name

	-- 修改密码
	local function http_callback( error_code, message )
		print( "修改------",error_code, message)
		PasswordModel:modify_passowrd_result( error_code, message )
	end

    account = account or ""
    pre_password = pre_password or ""
    new_password = new_password or ""
	local url = UpdateManager.NOPlatform_server_url .. 'register.jsp'
    local param = 'type=1&account='..account..'&pw='..new_password..'&pw_old='..pre_password
	local http_request = HttpRequest:new( url, param, http_callback )
	http_request:send()
end

-- 修改结果
function PasswordModel:modify_passowrd_result( error_code, message )
	print("返回结果")
	if error_code == 0 then
        print("成功！！！", message)
        local message_temp = message:match("%s*(.-)%s*$")    -- 去掉空格  (a,"%s*(.-)%s*$"))
        local register_info_t = Utils:Split_old( message_temp, ",:" )  
        local resulst_code = register_info_t[1]              -- 0：操作失败   1：操作成功   -1：其他错误
        if resulst_code == "1" then
            local notice_content = LangModelString[386] -- [386]="修改成功!"
            NormalDialog:show( notice_content, nil, 2 )
            local account = register_info_t[2] or ""
            local password = register_info_t[3] or ""
            PasswordModel:save_password( account, password )
        elseif resulst_code == "0" then 
            _modify_reuslt = LangModelString[387] -- [387]="#cff0000原密码错误"
            ModifyPasswordWin:update_win( "modify_result" )
        else
            _modify_reuslt = LangModelString[388]..error_code..LangModelString[389] -- [388]="#cff0000修改失败[" -- [389]="], 请重试!"
        	ModifyPasswordWin:update_win( "modify_result" )
        end
    else
    	local notice_content = LangModelString[388]..error_code..LangModelString[390] -- [388]="#cff0000修改失败[" -- [390]="], 请重试"
        NormalDialog:show( notice_content, nil, 2 )
	end
end

-- 保存密码到文件
function PasswordModel:save_password( account, password )
	if password == "" or password == nil then
        return
	end
	password = md5(password)                   -- 
    -- 保存到 账号密码对 列表  *** 这个方法要在第一次加密后调用
    RoleModel:save_account_pw( account, password )

	password = encryptMD5(password)            -- 二次加密
    CCUserDefault:sharedUserDefault():setStringForKey("password", password)
    CCUserDefault:sharedUserDefault():flush()

end

-- 判断密码是否合法
function PasswordModel:check_password_right( password )
    if not RoleModel:check_str_num_and_letter( password ) then 
        return false, LangModelString[391] -- [391]="#cff0000只可使用数字和字母"
    elseif not RoleModel:check_str_length_limit( password, 5, 200000 ) then  -- 密码大于五的判断
        return false, LangModelString[392] -- [392]="#cff0000密码不足5位"
    elseif not RoleModel:check_str_length_limit( password, 0, 20 ) then  -- 密码大于五的判断
        return false, LangModelString[393] -- [393]="#cff0000密码不可以超过20位"
	end
	return true
end
