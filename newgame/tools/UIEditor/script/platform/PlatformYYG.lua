PlatformYYG= {}
PlatformYYG.MESSAGE_TYPE	= "platform"
PlatformYYG.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformYYG.FUNC_LOGIN		= "login"		--登录
PlatformYYG.FUNC_PAY		= "pay"			--支付
PlatformYYG.FUNC_TOAST	= "toast"		--平台返回消息
PlatformYYG.FUNC_TAB		= "tab"			--切换账号
PlatformYYG.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformYYG.FUNC_CREATE_ROLE	= "create_role"	--创建角色
PlatformYYG.FUNC_LV_CHANGE	= "lv_change"	--等级改变
PlatformYYG.FUNC_INIT_ROLE	= "init_role"		--进入游戏
PlatformYYG.FUNC_QUIT		= "quit"		--登出
PlatformYYG.CODE_SUCCESS = 0
PlatformYYG.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformYYG.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformYYG:init()
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

function PlatformYYG:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformYYG:onEnterGameScene(isEnter)
	if isEnter == true then

	else

	end
end
-- /**
-- * 提交角色信息参数说明(创建角色完毕时)
-- * @param serverId 当前玩家登录的区服ID
-- */
function PlatformYYG:create_role_info(role_info)
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYYG.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYYG.FUNC_CREATE_ROLE
	json_table_temp[ "roleName" ] = role_info.roleName
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
-- /**
-- * 提交角色信息参数说明(游戏进入时)
-- * @param serverId 当前玩家登录的区服ID
-- */
function PlatformYYG:init_role_info()
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYYG.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYYG.FUNC_INIT_ROLE
	json_table_temp[ "serverId" ] = serverId
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
-- 提交玩家角色升级
function PlatformYYG:onPlayerLevelUp()
	-- self:submit_data(PlatformYYG.SUBMIT_LEVEL_UP)
	local player = EntityManager:get_player_avatar()
	local level = player.level
	local roleName = player.name
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYYG.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYYG.FUNC_LV_CHANGE
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel" ] = level
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformYYG:onEnterLoginState(state)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	MUtils:toast("PPS 登陆请求授权",2048,3) -- [69]="请求登录授权"
	local c = callback:new()
		c:start(0.1,function()
			PlatformYYG:doLogin()
		end)
	self.firstLogin = false
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformYYG:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	MUtils:toast("PlatformYYG:doLogin", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYYG.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYYG.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url
function PlatformYYG:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformYYG:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformYYG:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformYYG:logoutFromSelectServer(callbackfunc, reason)
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
-- function PlatformYYG:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformYYG:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformYYG:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "uid=" .. ZXLuaUtils:URLEncode(self.uid)
end


-- 获取登录服务器ip
function PlatformYYG:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformYYG:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformYYG:getPlatformPayUrl()
	return ""
end

--登出
function PlatformYYG:logout(callbackfunc)
	-- print("run loginout11111")
	if callbackfunc then
		callbackfunc()
	end
	-- print("run loginout22222")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYYG.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYYG.FUNC_LOGIN_OUT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

function PlatformYYG:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformYYG:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformYYG:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformYYG:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformYYG:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformYYG:onStartGame(cbfunc)
	cbfunc()
end

function PlatformYYG:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformYYG:doNeedLogin_delay()
end

function PlatformYYG:OnAsyncMessage( id, msg )
	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
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
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					-- self.access_token = jtable[ "access_token" ] or ""
					-- self.expires_in = jtable[ "expires_in" ] or ""
					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登陆失败", 2048, 2.5)				
				end
			elseif func_type == self.FUNC_TOAST then
				local toast = jtable["toast"]
				MUtils:toast(toast, 2048, 2.5)
			end	
		end
	end
	return false;
end

function PlatformYYG:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformYYG:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

--平台主动行为封装 Begin
--支付
function PlatformYYG:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformYYG:getDownloadFrom()
	return 'noplatform'
end

function PlatformYYG:showPlatformUI(bFlag)
end


--支付
--          /**
--           * 支付接口参数说明
--           * !!! 注意必传参数,不能为空，推荐所有参数都传值 !!!
--           * 
--           * @param doid CP订单ID (*必传)
--           * @param dpt CP商品名 (*必传)
--           * @param dmoney CP金额(定额) (*必传)	--单位为分
--           * @param dradio CP兑换比率(1元兑换率默认1:10)
--           */
function PlatformYYG:payUICallback( info )


	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 0.1
    -- local user_account = RoleModel:get_login_info().user_name

    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _userName = player.name
	local _serverId = RoleModel:get_login_info().server_id
	local productId = "lion_yy_" .. _userId .. "_" .. _item_id ..os.time()
	local userData = "lion_yy_".. self.uid .. "_" .. _serverId .. "_" ..os.time()

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)
	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYYG.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYYG.FUNC_PAY
	json_table_temp[ "serverId" ] = _serverId
	json_table_temp[ "productId" ] = "gold"
	json_table_temp[ "itemNum" ] = 1  --物品数量 默认1,没有用到
	json_table_temp[ "itemPrice" ] = 1  --物品数量 默认1,没有用到
	json_table_temp[ "itemName" ] = string.format("%d元宝",_item_id)
	json_table_temp[ "money" ] = _item_id * _money_rate
	json_table_temp[ "roleId" ] = _userId
	json_table_temp[ "roleName" ] = _userName
	json_table_temp[ "extData" ] = userData
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformYYG:getLoginRet()
	return self.uid, self.sign
end


function PlatformYYG:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.yyg
	-- local temp_info = ChongZhiConfig:get_chong_zhi_info()
	-- return temp_info[wdj]
end
--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformYYG:share(info)

end

function PlatformYYG:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformYYG:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformYYG:open_user_center()
	
end

function PlatformYYG:onLoginResult( err, data )
	-- body
end
--退出游戏
function PlatformYYG:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= self.MESSAGE_TYPE					--消息类型，必传字段
	json_table_temp[ "function_type" ]		= self.FUNC_QUIT					--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end