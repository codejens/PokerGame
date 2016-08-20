PlatformAny= {}
PlatformAny.MESSAGE_TYPE	= "platform"
PlatformAny.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformAny.FUNC_LOGIN		= "login"		--登录
PlatformAny.FUNC_PAY		= "pay"			--支付
PlatformAny.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformAny.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformAny.FUNC_USER_CENTER = "user_center"
PlatformAny.FUNC_QUIT			= "quit"		--退出
PlatformAny.FUNC_EXIT					= "exit"		--退出游戏
PlatformAny.FUNC_SUBMIT 				= "submit"	    --提交用户数据pl
PlatformAny.SUBMIT_ENTER_SERVER   		= "enterServer"    --进入游戏场景
PlatformAny.SUBMIT_LEVEL_UP            = "levelUp"        --角色升级
PlatformAny.SUBMIT_CREATE_ROLE         = "createRole"     --创建角色
PlatformAny.FUNC_DELIVERY	= "delivery"	--传送

PlatformAny.CODE_SUCCESS = 0
PlatformAny.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformAny.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformAny:init()
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	self.channelID = ""
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()

	self.AppId = ''

end

function PlatformAny:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformAny:onEnterGameScene(isEnter)
	if isEnter == true then
		-- self:submit_data(PlatformAny.SUBMIT_ENTER_SERVER)
	else

	end
end

-- 第一次进入游戏场景，创建主角完成后调用
function PlatformAny:create_role_success(role_info)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_INIT_ROLE
	json_table_temp[ "roleId" ] = role_info.roleId
	json_table_temp[ "roleName" ] = role_info.roleName
	json_table_temp[ "lv" ] = "1"
	json_table_temp[ "serverId" ] = role_info.server_id
	json_table_temp[ "serverName" ] = role_info.serverName
	json_table_temp[ "dataType" ] = "2"
	json_table_temp[ "ext" ] = "login"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

-- 第一次进入游戏场景，创建主角完成后调用
function PlatformAny:init_role_info()
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local serverName = RoleModel:get_server_name_had_login(  )
	local player = EntityManager:get_player_avatar()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_INIT_ROLE
	json_table_temp[ "roleId" ] = player.id
	json_table_temp[ "roleName" ] = player.name
	json_table_temp[ "lv" ] = player.level
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "serverName" ] = serverName
	json_table_temp[ "dataType" ] = "1"
	json_table_temp[ "ext" ] = "login"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformAny:onEnterLoginState(state)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	if self.firstLogin == true then
	-- MUtils:toast("万普 登陆请求授权",2048,3) -- [69]="请求登录授权"
		local c = callback:new()
			c:start(0.1,function()
				PlatformAny:doLogin()
			end)
		self.firstLogin = false
	end
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformAny:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	-- MUtils:toast("PlatformAny:doLogin", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url
function PlatformAny:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformAny:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformAny:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformAny:logoutFromSelectServer(callbackfunc, reason)
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
-- function PlatformAny:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformAny:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformAny:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "uid=" .. self.userID
end


-- 获取登录服务器ip
function PlatformAny:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformAny:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformAny:getPlatformPayUrl()
	return ""
end

--登出
function PlatformAny:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_LOGIN_OUT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'

end

function PlatformAny:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformAny:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformAny:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformAny:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformAny:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformAny:onStartGame(cbfunc)
	cbfunc()
end

function PlatformAny:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformAny:doNeedLogin_delay()
end

function PlatformAny:OnAsyncMessage( id, msg )
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
			-- local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			print("func_type",func_type)
			-- print('error_code',error_code)
			if func_type == PlatformAny.FUNC_LOGIN then -- 登录、切换成功的处理
				MUtils:toast("登陆成功", 2048, 2.5)
				--登录	
				self.userID = jtable["userID"]

				RoleModel:request_server_list_platform()
			elseif func_type == PlatformAny.FUNC_QUIT then
				QuitGame()
			elseif func_type == PlatformAny.FUNC_EXIT then
				ZXGameQuit()
			elseif func_type == PlatformAny.FUNC_LOGIN_OUT then
				if NetManager:get_socket() ~= nil then
					MiscCC:send_quit_server()
				end
				GameStateManager:set_state("login")
			elseif func_type == PlatformAny.FUNC_CHANGE_ACCOUNT then
				MiscCC:send_quit_server()
				GameStateManager:set_state("login")
				RoleModel:change_login_page( "loginSDK" )
			end
		end
	end
	return false;
end

function PlatformAny:android_print(string)
	-- local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = "print"
	-- json_table_temp[ "context" ] = string
	-- require 'json/json'
	-- local jcode = json.encode( json_table_temp )
	-- send_message_to_java( jcode )	
end

function PlatformAny:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformAny:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

--平台主动行为封装 Begin
--支付
function PlatformAny:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformAny:getDownloadFrom()
	return 'noplatform'
end

function PlatformAny:showPlatformUI(bFlag)
end


--支付
--          /**
--           * 支付接口参数说明
--           * !!! 注意必传参数,不能为空，推荐所有参数都传值 !!!
--           */
function PlatformAny:payUICallback( info )
	local _money_rate = 0.1
    local _item_id  = info.item_id
	local _uid = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id
	local player = EntityManager:get_player_avatar()

	local _orderId = "lion_any_".._uid.."_".._serverId.."_"..os.time();
	MUtils:toast("充值中", 2048, 3)

	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_PAY
	json_table_temp[ "pId" ] = _item_id
	json_table_temp[ "itemName" ] = _item_id .. "元宝"
	json_table_temp[ "price" ] = _item_id * _money_rate
	json_table_temp[ "count" ] = "1"	--如无特殊要求,默认传1就好
	json_table_temp[ "roleId" ] = player.id
	json_table_temp[ "roleName" ] = player.name
	json_table_temp[ "lv" ] = player.level
	json_table_temp[ "yuanbao" ] = player.yuanbao
	json_table_temp[ "serverId" ] = _serverId
	json_table_temp[ "ext" ] = _orderId

	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformAny:getLoginRet()
	return self.uid, self.token
end


function PlatformAny:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.anySDK
end

function PlatformAny:exit( )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE					--消息类型，必传字段
	json_table_temp[ "function_type" ]		= PlatformAny.FUNC_QUIT					--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end

--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformAny:share(info)

end

function PlatformAny:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformAny:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformAny:open_user_center()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_USER_CENTER
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
end

function PlatformAny:onLoginResult( err, data )
	-- body
end
function PlatformAny:switch_account()
	-- MiscCC:send_quit_server()
	-- GameStateManager:set_state("login")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformAny.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformAny.FUNC_CHANGE_ACCOUNT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
end
--传送从入口外获取到的平台uid到java层
function PlatformAny:delivery_platform_uid(uid)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= self.MESSAGE_TYPE					--消息类型，必传字段
	json_table_temp[ "function_type" ]		= self.FUNC_DELIVERY				--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end