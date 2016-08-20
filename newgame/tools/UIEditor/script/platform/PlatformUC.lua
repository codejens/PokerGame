PlatformUC= {}
PlatformUC.MESSAGE_TYPE	= "platform"
PlatformUC.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformUC.FUNC_LOGIN		= "login"		--登录
PlatformUC.FUNC_PAY		= "pay"			--支付
PlatformUC.FUNC_TAB		= "tab"			--切换账号
PlatformUC.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformUC.FUNC_QUIT		= "quit"		--退出
PlatformUC.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformUC.FUNC_USER_CENTER 	= "user_center"
PlatformUC.FUNC_REGISTER_CENTER = "register_page"
PlatformUC.FUNC_GAME_CENTER = "game_center"

PlatformUC.CODE_SUCCESS = 0
PlatformUC.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformUC.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformUC:init()
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()

	self.AppId = ''

end

function PlatformUC:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformUC:onEnterGameScene(isEnter)
	if isEnter == true then

	else

	end
end

function PlatformUC:init_role_info()
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local serverName = RoleModel:get_server_name_had_login(  )
	local player = EntityManager:get_player_avatar()
	local roleId = player.id
	local roleName = player.name
	local roleLevel = player.level
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUC.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUC.FUNC_INIT_ROLE
	json_table_temp[ "serverName" ] = serverName
	json_table_temp[ "roleId" ] = tostring(roleId)
	json_table_temp[ "serverId" ] = tostring(serverId)
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel" ] = tostring(roleLevel)
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformUC:onEnterLoginState(state)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	if self.firstLogin == true then
		-- MUtils:toast("37Wan 登陆请求授权",2048,3) -- [69]="请求登录授权"
		local c = callback:new()
			c:start(0.1,function()
				PlatformUC:doLogin()
			end)
		self.firstLogin = false
	end
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformUC:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	-- MUtils:toast("PlatformUC:doLogin", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUC.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUC.FUNC_LOGIN
	json_table_temp[ "msg" ] = ""
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url
function PlatformUC:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformUC:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformUC:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformUC:logoutFromSelectServer(callbackfunc, reason)
	print('PlatformNoPlatform:logoutFromSelectServer',err, data)
	if callbackfunc then
		callbackfunc()
	end

	-- if reason then
	-- 	MUtils:toast(reason,2048)
	-- end
	--跳转到无平台登陆页，有平台应该调用SDK
	--并且隐藏窗口
	RoleModel:change_login_page( "loginSDK" )
end

-- -- 获取该平台，发送请求服务器列表接口的http参数
-- function PlatformUC:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformUC:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformUC:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "sid=" .. self.sid
end


-- 获取登录服务器ip
function PlatformUC:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformUC:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformUC:getPlatformPayUrl()
	return ""
end

--登出
function PlatformUC:logout(callbackfunc)
	-- print("run loginout11111")
	if callbackfunc then
		callbackfunc()
	end
	-- print("run loginout22222")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUC.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUC.FUNC_LOGIN_OUT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	-- print("run loginout33333")
	send_message_to_java( jcode )	
	-- print("run loginout44444")
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
	-- print("run loginout55555")
end

function PlatformUC:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformUC:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformUC:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformUC:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformUC:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformUC:onStartGame(cbfunc)
	cbfunc()
end

function PlatformUC:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformUC:doNeedLogin_delay()
end

function PlatformUC:OnAsyncMessage( id, msg )
	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	MUtils:toast("成功进入！", 2048, 2.5)
	print("s,e",s,e)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		print("message_type",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			print("func_type",func_type)
			print('error_code',error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登陆成功", 2048, 2.5)
					-- self.access_token = jtable["token"]
					-- self.user_name = jtable["name"]
					-- self.password = jtable["password"]
					self.sid = jtable["sid"]
					RoleModel:request_server_list_platform()
					return true
				else
					MUtils:toast("登陆失败", 2048, 2.5)				
				end
				return false
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
					-- self.access_token = jtable["token"]
					-- self.uid = jtable["uid"]
					-- self.user_name = jtable["name"]
					-- MiscCC:send_quit_server()
					-- GameStateManager:set_state("login")
					-- RoleModel:send_name_and_pw(self.uid, self.access_token, nil, true)
					-- RoleModel:change_login_page("new_select_server_page")					
			end
			
		end
	end
	-- MUtils:toast("登陆失败", 2048, 2.5)
	return false;
end

function PlatformUC:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformUC:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

--平台主动行为封装 Begin
--支付
function PlatformUC:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformUC:getDownloadFrom()
	return 'noplatform'
end

function PlatformUC:showPlatformUI(bFlag)
end

function PlatformUC:payUICallback( info )

	-- HelpPanel:show( 3, UILH_NORMAL.title_tips, "内测期间不提供充值" )

	require 'model/iOSChongZhiModel'
	local _money_rate = 0.1

    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _roleLevel = player.level
	local _roleName = player.name
	local _userName = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id
	local _serverName = RoleModel:get_server_name_had_login(  )
	local _orderId = "LionHeart_UC".._userName.."_".._serverId.."_"..os.time();

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)
	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUC.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUC.FUNC_PAY
	json_table_temp[ "orderId" ] = _orderId
	json_table_temp[ "serverId" ] = _serverId
	json_table_temp[ "roleId"] = _userId
	json_table_temp[ "roleName" ] = _roleName
	json_table_temp[ "roleLevel" ] = _roleLevel
	json_table_temp[ "money" ] = _item_id * _money_rate
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformUC:getLoginRet()
	return self.uid, self.token
end


function PlatformUC:getPayInfo()
	require "../data/chong_zhi_config"
	local temp_info = ChongZhiConfig:get_chong_zhi_info()
	return temp_info.uc
end
--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformUC:share(info)

end

function PlatformUC:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformUC:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformUC:open_user_center()
	
end

function PlatformUC:onLoginResult( err, data )
	-- body
end
--退出游戏
function PlatformUC:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= self.MESSAGE_TYPE					--消息类型，必传字段
	json_table_temp[ "function_type" ]		= self.FUNC_QUIT					--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end