PlatformAmigo= {}
PlatformAmigo.MESSAGE_TYPE	= "platform"
PlatformAmigo.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformAmigo.FUNC_LOGIN		= "login"		--登录
PlatformAmigo.FUNC_PAY		= "pay"			--支付
PlatformAmigo.FUNC_TAB		= "tab"			--切换账号
PlatformAmigo.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformAmigo.FUNC_QUIT		= "quit"		--退出
PlatformAmigo.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformAmigo.FUNC_USER_CENTER = "user_center"
PlatformAmigo.FUNC_SWITCH_ACCOUNT = "swithc_account"
PlatformAmigo.FUNC_ENTRY_PLATFORM = "enter_platform"

PlatformAmigo.CODE_SUCCESS = 0
PlatformAmigo.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformAmigo.STATE_LOGIN_FAIL = 1	-- 失败

function PlatformAmigo:init()
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.show_btn = 1
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()
	self.access_token = ""
	self.openId = ""
	self.user_name = ""
	self.AppId = ''

end

-- 拉取服务器列表的时候需要的参数
function PlatformAmigo:get_login_param_json( account, dbip, server_id )

	local sign = "2C2D20268CD04B7E89E43800DD4AEEFE"
	local time  = os.time()
    return 'uid='..self.uid..'&time='..os.time().."&AmigoToken="..self.access_token..'&sign='..md5("platform_jinli"..tostring(time).."2C2D20268CD04B7E89E43800DD4AEEFE")
end


--点击登录服务器真正登录服务器的时候
function PlatformAmigo:get_login_param( )
	if GetSerialNumber then
		self.udid = GetSerialNumber()
	end
    local _serverId = RoleModel:get_login_info().before_serverid
    return "uid="..self.uid .. "&udid=" ..self.udid .. "&token=" .. self.access_token .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel').."&sub_channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel').."&plat=".."android".."&serverid=".._serverId
end


-- 获取平台支付地址
function PlatformAmigo:getPlatformPayUrl()

	_url = UpdateManager.order_url
	-- print("UpdateManager.order_url",_url)
	return _url
end

function PlatformAmigo:OnAsyncMessage( id, msg )
	ZXLog('PlatformAmigo:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	-- MUtils:toast("成功进入！", 2048, 2.5)
	--print("s,e",s,e)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		--print("message_type",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			-- print("func_type",func_type)
			-- print('error_code',error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登录成功", 2048, 2.5)
					-- print("登录成功")
					self.uid = jtable["uid"]
					self.access_token = jtable["mToken"]
					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登录失败", 2048, 2.5)	
					self:doLogin()			
				end
				return true
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
					MiscCC:send_quit_server()
					GameStateManager:set_state("login")
					-- RoleModel:send_name_and_pw(self.uid, self.access_token, nil, true)
					-- RoleModel:change_login_page("new_select_server_page")
			elseif func_type == self.FUNC_QUIT then
				ZXGameQuit()
			end
			return true
		end
	end
	MUtils:toast("登录失败", 2048, 2.5)
	return false;
end


--金力先商户服务器请求
function PlatformAmigo:request_server_pay() 

	local url   = UpdateManager.idfa_server_list_url
	local param = 'idfa='..IOSDispatcher:get_udid()

	local function http_callback(err, message)
		 if err == 0 then
			MUtils:lockScreen(false,2048)
			require 'json/json'
			local jtable = {}
			local s,e = pcall(function()
				jtable = json.decode(message)
			end)
			if not s then 
				-- ----print("进入 s")
				RoleModel:show_notice("登录失败，请重新尝试！["..RoleModel.json_error.."]") -- [425]="登录失败，请重新尝试！["
				MUtils:lockScreen(false,2048)
				PlatformInterface:logoutFromSelectServer()
				return 
			end
			local ret_code = jtable['ret'] 
			--登录成功
			if ret_code=="1" then
				RoleModel:set_server_list_date_for_json(jtable['srvlist'] )
				local acount	= jtable['uid'] or ""						  -- 登录服务器返回的 “acount”
				local loginurl  = jtable[ 'loginurl' ] or ""
				local biurl	 = jtable[ 'biurl' ] or ""
				local cdkeyurl  = jtable[ 'cdkeyurl' ] or ""
				local payUrl	= jtable[ 'payUrl' ] or ""
				local access_token = jtable[ 'access_token' ] or ""

				--选择新服务器的间隔
				RoleModel.switch_new_server_intvl = tonumber(jtable['server_interval']) or 0
				--入口的时间戳
				RoleModel.server_list_timestamp = tonumber(jtable['server_timestamp']) or 0
				-- ZXLog('guest_get_server_list:', RoleModel.switch_new_server_intvl,RoleModel.server_list_timestamp)
				GameUrl_global:set_uid(acount)
				GameUrl_global:set_login_url(loginurl)
				GameUrl_global:set_pay_url(payUrl)
				GameUrl_global:set_accessToken(access_token)
				local uid,psw = PlatformInterface:getLoginRet()
				RoleModel:set_login_info("user_name", acount)
				-- RoleModel:set_login_info("server_id", acount)										   
				RoleModel:change_login_page("new_select_server_page")
				PlatformInterface:showPlatformUI(false)
				PlatformInterface:setLoginType(MSDK_TYPE.ePlatform_Guest)
				MUtils:toast("获取服务器列表成功!",2048) -- [439]="获取服务器列表成功!"
			else
				--MUtils:toast("登录失败，请重新尝试！",2048)
				--self:doLogin()
			end
		 else
		 	-- 	local function cb_func(  )
		 	-- 		local http_request = HttpRequest:new(url, param, http_callback)
				-- 	http_request:send()
		 	-- 	end 

				-- local cb = callback:new()
				-- cb:start(1,cb_func)
		 end
	end

	local http_request = HttpRequest:new(url, param, http_callback)
	http_request:send()
	----print("guest_get_server_list url,param",url,param)

end




function PlatformAmigo:payUICallback( info )
	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 1
	local time = os.time()
    -- local user_account = RoleModel:get_login_info().user_name
    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _serverId = RoleModel:get_login_info().server_id

	local _orderId = "platform_jinli".._userId.."_".._serverId.."_"..time;

	MUtils:toast("创建订单中...", 2048, 3)

    local function http_callback(err, message)
    	-- print("http_callback err",err)
		 if err == 0 then
			MUtils:lockScreen(false,2048)
			require 'json/json'
			local jtable = {}
			local s,e = pcall(function()
				jtable = json.decode(message)
			end)
			if not s then 
				-- ----print("进入 s")
				RoleModel:show_notice("创建订单失败，请重新尝试！["..RoleModel.json_error.."]") -- [425]="登录失败，请重新尝试！["
				MUtils:lockScreen(false,2048)
				PlatformInterface:logoutFromSelectServer()
				return 
			end
			--接口返回值为json格式 ，如果ret的值为1，则请求成功，反之失败
			local ret_code = jtable['ret'] 
			--创建订单成功
			-- print("ret_code",ret_code)
			if ret_code==1 or ret_code=="1" then
				MUtils:toast("成功创建订单",2048)
				local submit_time = jtable['submit_time']
				local order_no = jtable['order_no']
				--成功之后再启动收银台
				local json_table_temp = {}
				json_table_temp[ "message_type" ]	= PlatformAmigo.MESSAGE_TYPE	--消息类型，必传字段
				json_table_temp[ "function_type" ] = PlatformAmigo.FUNC_PAY
			    json_table_temp["api_key"] =  "EA7BE318F7634DDFAB8EA511D4B836B0"
				json_table_temp[ "out_order_no" ] = _orderId --商户订单号
				-- print("启动收银台的时间")
				json_table_temp[ "time" ] =  submit_time ---订单创建时间
				require 'json/json'
				local jcode = json.encode( json_table_temp )
				send_message_to_java( jcode )	
			else
				MUtils:toast("创建订单失败，请重新尝试！",2048)
			end
		 else
		 		MUtils:toast("网络错误，请重新尝试！",2048)
		 end
	end
	local url   = PlatformAmigo:getPlatformPayUrl()
    local price = _item_id * _money_rate
    local item_name = ""
	if info.monthcard_name ~= nil then
		item_name = info.monthcard_name
	else
		item_name = string.format("%d元宝",_item_id*10)
	end
	local param = "player_id="..self.uid.."&api_key=EA7BE318F7634DDFAB8EA511D4B836B0".."&deal_price="..price.."&out_order_no=".._orderId.."&subject="..item_name.."&total_fee="..price.."&level="..player.level.."&server_id=".._serverId.."&role_id=".._userId
	print("发送商户服务器后台字段param",url,param)
	local http_request = HttpRequest:new(url, param, http_callback)
	http_request:send()
end



