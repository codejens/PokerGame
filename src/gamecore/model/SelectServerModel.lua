--SelectServerModel.lua

SelectServerModel = {}

--选择服务器列表组
function SelectServerModel:do_group_btn( index )
	local server_list_date = LoginModel:get_serverlist_date()
	local curr_date = {}
	local cindex = 1
	for i=index,index+10 do
		curr_date[cindex] = server_list_date[i]

		cindex = cindex + 1
	end

	local win = GUIManager:find_window("selectserver")
	if win then
		win:update_server_list(curr_date)
	end
end

--选择服务器后 登陆服务器 链接服务器
function SelectServerModel:do_select_server( row_date )
	local server_ip = row_date.ip
	local server_id = row_date.serverid or ""
	local server_port = row_date.port
	local dbip   = row_date.dbip or ""
	local loginInfo = LoginModel:get_loginInfo(  )
	local account = loginInfo.user_name

-- 从登陆平台获取用户名和密码，然后登陆
	local function http_callback( error_code, message )
		
		if error_code == 0 then
			print(message)
			local message_temp = message:match("%s*(.-)%s*$")    -- 去掉空格  (a,"%s*(.-)%s*$"))
            local register_info_t = Utils:Split_old( message_temp, ",:" )  
            local resulst_code = register_info_t[1]              -- 0：操作失败   1：操作成功   -1：其他错误
            print(resulst_code)
            if resulst_code == "1" then
	            local account = register_info_t[2] or ""
	            local password = register_info_t[3] or ""
	            server_ip = "192.168.17.251"
	            server_port = "12004"
	            password = "e10adc3949ba59abbe56e057f20f883e"
	           	server_id = 305
	            NetManager:connect( account, password, server_ip, server_id, server_port )
	       else

	       end
	    end

	end
	
	local url = 'http://192.168.25.35:8080/ms/noplatform/login.jsp'
    local param = 'account='..account..'&ip='..dbip..'&serverid='..server_id .. '&channel=test'
    print(url,param)
	local http_request = HttpRequest:new( url, param, http_callback )
	http_request:send()
end