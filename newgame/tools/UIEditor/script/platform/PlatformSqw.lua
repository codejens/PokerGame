PlatformSqw= {}
PlatformSqw.MESSAGE_TYPE	= "platform"
PlatformSqw.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformSqw.FUNC_LOGIN		= "login"		--登录
PlatformSqw.FUNC_PAY		= "pay"			--支付
PlatformSqw.FUNC_TAB		= "tab"			--切换账号
PlatformSqw.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformSqw.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformSqw.CODE_SUCCESS = 0
PlatformSqw.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformSqw.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformSqw:init()
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

function PlatformSqw:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformSqw:onEnterGameScene(isEnter)
	if isEnter == true then

	else

	end
end

-- /**
-- * 提交角色信息参数说明
-- * @param serverId 当前玩家登录的区服ID
-- * @param serverName 当前玩家登录的区服名称
-- * @param roleId 当前玩家的角色ID
-- * @param roleName 当前玩家的角色名称
-- * @param roleLevel 当前玩家的角色等级
-- * @param balance 用户余额（RMB购买的游戏币）
-- * @param partyName 帮派、公会等，没有则填空字符串
-- * @param vipLevel Vip等级,没有vip系统的传0
-- */
function PlatformSqw:init_role_info()
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local serverName = RoleModel:get_server_name_had_login(  )
	local player = EntityManager:get_player_avatar()
	local roleId = player.id
	local roleName = player.name
	local roleLevel = player.level
	local balance = player.yuanbao
	local partyName = ""
	local vipLevel = player.vipFlag
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformSqw.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformSqw.FUNC_INIT_ROLE
	json_table_temp[ "serverId" ] = tostring(serverId)
	json_table_temp[ "serverName" ] = serverName
	json_table_temp[ "roleId" ] = tostring(roleId)
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel" ] = tostring(roleLevel)
	json_table_temp[ "balance" ] = tostring(balance)
	json_table_temp[ "partyName" ] = partyName
	json_table_temp[ "vipLevel" ] = tostring(vipLevel)
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformSqw:onEnterLoginState(state)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	if self.firstLogin == true then
		MUtils:toast("37Wan 登陆请求授权",2048,3) -- [69]="请求登录授权"
		local c = callback:new()
			c:start(0.1,function()
				PlatformSqw:doLogin()
			end)
		self.firstLogin = false
	end
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformSqw:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	MUtils:toast("PlatformSqw:doLogin", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformSqw.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformSqw.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url
function PlatformSqw:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformSqw:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformSqw:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformSqw:logoutFromSelectServer(callbackfunc, reason)
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
-- function PlatformSqw:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformSqw:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id
end

function PlatformSqw:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "token=" .. ZXLuaUtils:URLEncode(self.access_token) .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end


-- 获取登录服务器ip
function PlatformSqw:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformSqw:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformSqw:getPlatformPayUrl()
	return ""
end

--登出
function PlatformSqw:logout(callbackfunc)
	-- print("run loginout11111")
	if callbackfunc then
		callbackfunc()
	end
	-- print("run loginout22222")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformSqw.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformSqw.FUNC_LOGIN_OUT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	-- print("run loginout33333")
	send_message_to_java( jcode )	
	-- print("run loginout44444")
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
	-- print("run loginout55555")
end

function PlatformSqw:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformSqw:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformSqw:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformSqw:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformSqw:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformSqw:onStartGame(cbfunc)
	cbfunc()
end

function PlatformSqw:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformSqw:doNeedLogin_delay()
end

function PlatformSqw:OnAsyncMessage( id, msg )
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
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					self.user_name = jtable["name"]
					-- self.access_token = jtable[ "access_token" ] or ""
					-- self.expires_in = jtable[ "expires_in" ] or ""
					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登陆失败", 2048, 2.5)				
				end
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					self.user_name = jtable["name"]
					MiscCC:send_quit_server()
					GameStateManager:set_state("login")
					RoleModel:send_name_and_pw(self.uid, self.access_token, nil, true)
					RoleModel:change_login_page("new_select_server_page")
					
				-- self.access_token = jtable["token"]
				-- self.uid = jtable["uid"]
				-- self.user_name = jtable["name"]
					-- json.put("name", bundle.getString("username"));
					-- json.put("username", bundle.getString(SQwanCore.LOGIN_KEY_USERNAME));
					-- json.put("uid", bundle.getString(SQwanCore.LOGIN_KEY_USERID));
					-- json.put("token", bundle.getString(SQwanCore.LOGIN_KEY_TOKEN));				
				-- GameStateManager:back_to_login()

			end
			
		end
	end
	MUtils:toast("登陆失败", 2048, 2.5)
	return false;
end

function PlatformSqw:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformSqw:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

--平台主动行为封装 Begin
--支付
function PlatformSqw:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformSqw:getDownloadFrom()
	return 'noplatform'
end

function PlatformSqw:showPlatformUI(bFlag)
end


--支付
--          /**
--           * 支付接口参数说明
--           * !!! 注意必传参数,不能为空，推荐所有参数都传值 !!!
--           * 
--           * @param context 上下文 (*必传)
--           * @param doid CP订单ID (*必传)
--           * @param dpt CP商品名
--           * @param dcn CP货币名称 
--           * @param dsid CP游戏服ID (*必传)
--           * @param dsname CP游戏服名称
--           * @param dext CP扩展回调参数 (*必传)
--           * @param drid CP角色ID
--           * @param drname CP角色名
--           * @param drlevel CP角色等级
--           * @param dmoney CP金额(定额) (*必传)
--           * @param dradio CP兑换比率(1元兑换率默认1:10)
--           * @param payListener 充值回调 (*必传)
--           */
-- outorderid= resultJson.getString("outorderid");
-- itemName = resultJson.getString("itemName");
-- moneyName = resultJson.getString("moneyName");
-- serverId= resultJson.getString("serverId");
-- serverName = resultJson.getString("serverName");	
-- pext= resultJson.getString("pext");  // 扩展字段  服务器会原样返回给游戏服务器（可选）
-- userId= resultJson.getString("userId");	
-- userName = resultJson.getString("userName");
-- userLevel = (int) resultJson.getInt("userLevel");
-- money = (float) resultJson.getDouble("money");
-- moneyRate = (int) resultJson.getInt("moneyRate");
function PlatformSqw:payUICallback( info )

	HelpPanel:show( 3, UILH_NORMAL.title_tips, "内测期间不提供充值" )

	-- require 'model/iOSChongZhiModel'
	-- --iOSChongZhiModel:purchase_product( info.item_id )
	-- local _money_rate = 0.1
 --    -- local user_account = RoleModel:get_login_info().user_name

 --    local _item_id  = info.item_id
 --    local player = EntityManager:get_player_avatar()
	-- local _userId   = player.id
	-- local _userName = RoleModel:get_login_info().user_name
	-- local _serverId = RoleModel:get_login_info().server_id

	-- local _orderId = "LionHeart_37wan-37wan".._userId.."_".._serverId.."_"..os.time();

	-- -- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)
	-- MUtils:toast("充值中", 2048, 3)

	-- -- RoleModel:change_login_page( "login" )
	-- local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformSqw.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = PlatformSqw.FUNC_PAY
	-- json_table_temp[ "outorderid" ] = _orderId
	-- json_table_temp[ "itemName" ] = string.format("%d元宝",_item_id)
	-- json_table_temp[ "moneyName" ] = string.format("%d元宝",_item_id)
	-- json_table_temp[ "serverId" ] = _serverId
	-- json_table_temp[ "serverName" ] = RoleModel:get_server_name_had_login(  )
	-- json_table_temp[ "pext" ] = ""
	-- json_table_temp[ "userId" ] = _userId
	-- json_table_temp[ "userName" ] = _userName
	-- json_table_temp[ "userLevel" ] = player.level
	-- json_table_temp[ "money" ] = _item_id * _money_rate
	-- json_table_temp[ "moneyRate" ] = _money_rate
	-- require 'json/json'
	-- local jcode = json.encode( json_table_temp )
	-- send_message_to_java( jcode )
end


function PlatformSqw:getLoginRet()
	return self.uid, self.token
end


function PlatformSqw:getPayInfo()
	require "../data/chong_zhi_config"
	local temp_info = ChongZhiConfig:get_chong_zhi_info()
	return temp_info.sqw
end
--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformSqw:share(info)

end

function PlatformSqw:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformSqw:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformSqw:open_user_center()
	
end

function PlatformSqw:onLoginResult( err, data )
	-- body
end
