PlatformLJ= {}
PlatformLJ.MESSAGE_TYPE	= "platform"
PlatformLJ.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformLJ.FUNC_LOGIN		= "login"		--登录
PlatformLJ.FUNC_PAY		= "pay"			--支付
PlatformLJ.FUNC_TAB		= "tab"			--切换账号
PlatformLJ.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformLJ.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformLJ.FUNC_USER_CENTER 	= "user_center"
PlatformLJ.FUNC_REGISTER_CENTER = "register_page"
PlatformLJ.FUNC_GAME_CENTER = "game_center"
PlatformLJ.FUNC_SWITCH_LOGIN = "switchLogin"
PlatformLJ.FUNC_QUIT			= "quit"		--退出
PlatformLJ.FUNC_EXIT					= "exit"		--退出游戏
PlatformLJ.pay_url 				= "http://entry.tjxs.m.hoolaigames.com/hoolai/hoolai/paycallback" --支付地址
PlatformLJ.FUNC_HL_PAY			= "hl_pay"			--hoolai支付
PlatformLJ.CODE_SUCCESS = 0
PlatformLJ.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformLJ.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformLJ:init()
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.show_center = nil --是否需要显示用户中心
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()

	self.AppId = ''

end

function PlatformLJ:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformLJ:onEnterGameScene(isEnter)
	if isEnter == true then

	else

	end
end

function PlatformLJ:init_role_info()
	self:send_role_info('1')
end

-- 提交玩家角色升级
function PlatformLJ:onPlayerLevelUp()
	self:send_role_info('2')
end

function PlatformLJ:create_role_info()
	self:send_role_info('3')
end

function PlatformLJ:send_role_info(send_type)
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local serverName = RoleModel:get_server_name_had_login(  )
	local player = EntityManager:get_player_avatar()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= self.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = self.FUNC_INIT_ROLE
	json_table_temp[ "roleId" ] = player.id
	json_table_temp[ "roleName" ] = player.name
	json_table_temp[ "lv" ] = player.level
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "serverName" ] = serverName
	json_table_temp[ "send_type" ] = send_type
	local vip_info = VIPModel:get_vip_info()
	if vip_info then
		if vip_info.level then
    		json_table_temp["vip"] = vip_info.level                                 --当前用户VIP等级，必须为数字，若无，传入1
    	else
    		json_table_temp["vip"] = 0
    	end 
    else
    	json_table_temp["vip"] = 0
    end
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformLJ:onEnterLoginState(state)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	if self.firstLogin == true then
		-- MUtils:toast("37Wan 登陆请求授权",2048,3) -- [69]="请求登录授权"
		local c = callback:new()
			c:start(0.1,function()
				PlatformLJ:doLogin()
			end)
		self.firstLogin = false
	end
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformLJ:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	-- MUtils:toast("PlatformLJ:doLogin", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformLJ.FUNC_LOGIN
	json_table_temp[ "msg" ] = ""
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url
function PlatformLJ:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformLJ:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformLJ:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformLJ:logoutFromSelectServer(callbackfunc, reason)
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
-- function PlatformLJ:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformLJ:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='.. server_id.. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformLJ:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "uid=" .. self.uid .. "&channel=" .. self.channel .. "&channelUid=" .. self.channelUid .. "&accessToken=" .. self.accessToken .. "&productId=" .. self.productId
end


-- 获取登录服务器ip
function PlatformLJ:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformLJ:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformLJ:getPlatformPayUrl()
	return ""
end

--登出
function PlatformLJ:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	-- local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = PlatformLJ.FUNC_LOGIN_OUT
	-- require 'json/json'
	-- local jcode = json.encode( json_table_temp )
	-- send_message_to_java( jcode )	
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

function PlatformLJ:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformLJ:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformLJ:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformLJ:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformLJ:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformLJ:onStartGame(cbfunc)
	cbfunc()
end

function PlatformLJ:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformLJ:doNeedLogin_delay()
end

function PlatformLJ:OnAsyncMessage( id, msg )
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
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登陆成功", 2048, 2.5)
					self.productId = jtable["productId"]
					self.accessToken = jtable["accessToken"]
					self.user_email = jtable["userEmail"]
					self.uid = jtable["uid"]
					self.channel = jtable["channel"]
					self.channelUid = jtable["channelUid"]
					self.show_center = jtable["show_center"]
					RoleModel:request_server_list_platform()
					return true
				else
					MUtils:toast("登陆失败", 2048, 2.5)		
					return false		
				end
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
					self.productId = jtable["productId"]
					self.accessToken = jtable["accessToken"]
					self.user_email = jtable["userEmail"]
					self.uid = jtable["uid"]
					self.channel = jtable["channel"]
					self.channelUid = jtable["channelUid"]
					self.show_center = jtable["show_center"]
					-- MiscCC:send_quit_server()
					-- GameStateManager:set_state("login")
					RoleModel:send_name_and_pw(self.uid, self.access_token, nil, true)
					RoleModel:change_login_page("new_select_server_page")
			elseif func_type == self.FUNC_QUIT then
				ZXGameQuit()
			elseif func_type == self.FUNC_EXIT then
				QuitGame()
			elseif func_type == self.FUNC_LOGIN_OUT then
				if NetManager:get_socket() ~= nil then
					MiscCC:send_quit_server()
				end
				GameStateManager:set_state("login")
			end
		end
	end
	-- MUtils:toast("登陆失败", 2048, 2.5)
	return false;
end

function PlatformLJ:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformLJ:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformLJ:get_show_center( )
	return self.show_center
end

--平台主动行为封装 Begin
--支付
function PlatformLJ:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformLJ:getDownloadFrom()
	return 'noplatform'
end

function PlatformLJ:showPlatformUI(bFlag)
end

function PlatformLJ:payUICallback( info )
	print('payUICallback: ', info.item_id)
	local item_id  = info.item_id
	local player 	= EntityManager:get_player_avatar()
	local _userId   = player.id
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local _uid = login_info.user_name

	local _callBackInfo = "lion~" .. _uid .. "~" .. serverId .. "~" .. os.time()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformLJ.FUNC_HL_PAY              --分发类型，必传字段

	json_table_temp[ "userId"] = _userId
	json_table_temp[ "itemName"] = string.format("%d元宝", item_id)
	json_table_temp[ "amount"] = item_id * 10
	json_table_temp[ "callBackInfo"] = _callBackInfo
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformLJ:getLoginRet()
	return self.uid, self.token
end


function PlatformLJ:getPayInfo()
	require "../data/chong_zhi_config"
	local temp_info = ChongZhiConfig:get_chong_zhi_info()
	return temp_info.msdk
end

function PlatformLJ:switch_account()
	-- MiscCC:send_quit_server()
	-- GameStateManager:set_state("login")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformLJ.FUNC_SWITCH_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
end
--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformLJ:share(info)

end

function PlatformLJ:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformLJ:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformLJ:open_user_center()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformLJ.FUNC_USER_CENTER
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformLJ:onLoginResult( err, data )
	-- body
end

function PlatformLJ:switch_account()
	-- MiscCC:send_quit_server()
	-- GameStateManager:set_state("login")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformLJ.FUNC_CHANGE_ACCOUNT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
end

function PlatformLJ:exit( )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformLJ.MESSAGE_TYPE					--消息类型，必传字段
	json_table_temp[ "function_type" ]		= PlatformLJ.FUNC_QUIT					--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end