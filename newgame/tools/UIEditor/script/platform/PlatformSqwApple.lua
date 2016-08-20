-- PlatformSqwApple.lua
-- created by guozhinan on 2014-12-2
-- 天将雄师项目37wan的AppleStore版平台

PlatformSqwApple= {}
PlatformSqwApple.MESSAGE_TYPE	= "platform"
PlatformSqwApple.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformSqwApple.FUNC_LOGIN		= "login"		--登录
PlatformSqwApple.FUNC_PAY		= "pay"			--支付
PlatformSqwApple.FUNC_TAB		= "tab"			--切换账号
PlatformSqwApple.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformSqwApple.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformSqwApple.CODE_SUCCESS = 0
PlatformSqwApple.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformSqwApple.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformSqwApple:init()
	self.firstLogin = true
	self.login_state = false
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
	self.pid = nil

end

function PlatformSqwApple:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformSqwApple:onEnterGameScene(isEnter)
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
function PlatformSqwApple:init_role_info()
	-- ios版好像没有这个需求
	-- local login_info = RoleModel:get_login_info()
	-- local serverId = login_info.server_id
	-- local serverName = RoleModel:get_server_name_had_login(  )
	-- local player = EntityManager:get_player_avatar()
	-- local roleId = player.id
	-- local roleName = player.name
	-- local roleLevel = player.level
	-- local balance = player.yuanbao
	-- local partyName = ""
	-- local vipLevel = player.vipFlag
	-- local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformSqwApple.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = PlatformSqwApple.FUNC_INIT_ROLE
	-- json_table_temp[ "serverId" ] = tostring(serverId)
	-- json_table_temp[ "serverName" ] = serverName
	-- json_table_temp[ "roleId" ] = tostring(roleId)
	-- json_table_temp[ "roleName" ] = roleName
	-- json_table_temp[ "roleLevel" ] = tostring(roleLevel)
	-- json_table_temp[ "balance" ] = tostring(balance)
	-- json_table_temp[ "partyName" ] = partyName
	-- json_table_temp[ "vipLevel" ] = tostring(vipLevel)
	-- require 'json/json'
	-- local jcode = json.encode( json_table_temp )
	-- send_message_to_java( jcode )
end
-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformSqwApple:onEnterLoginState()
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	if self.login_state == false then
		MUtils:toast("登陆请求授权",2048,3) -- [69]="请求登录授权"
		local c = callback:new()
			c:start(0.1,function()
				PlatformSqwApple:doLogin()
			end)
	end
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformSqwApple:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	-- MUtils:toast("PlatformSqwApple:doLogin", 2048, 3)
	-- RoleModel:change_login_page( "login" )
	-- IOSDispatcher:sdksqw_login()


	if self.firstLogin == true then
		-- 第一次登录前，向ios代码发送切换账号的回调函数
		self.firstLogin = false;
		local function switch_account(error_code, json)
			local json_table = Utils:json2table(json)
			local error = json_table["error"]
			if error_code == 0 then
				if NetManager:get_socket() ~= nil then
					MiscCC:send_quit_server()
				end
				GameStateManager:set_state("login")
			end
		end
		local json = "{\"funcID\":\"sdk_sqw_switch_account\"}"
		IOSDispatcher:async_send_to_oc(json,switch_account)
	end



	local function login_succ( error_code, json )
		local json_table = Utils:json2table(json)
		local error = json_table["error"]
		if error_code == 0 then
			MUtils:toast("登陆成功", 2048, 2.5)
			-- 37wan给了切换账号的回调，所以登录就是登录，不用再考虑是不是切换账号
			-- if PlatformSqwApple.firstLogin == true then
				local access_token = json_table["token"]
				PlatformSqwApple:set_access_token(access_token)
				-- pid是37wanSDK登录回调给的联运id号，暂时不知道有什么用，先保存再说
				self.pid = json_table["pid"]
				-- self.firstLogin = false
				RoleModel:request_server_list_platform()
			-- elseif PlatformSqwApple.firstLogin == false then
			-- 	self.login_state = true
			-- 	local access_token = json_table["token"]
			-- 	PlatformSqwApple:set_access_token(access_token)
			-- 	if NetManager:get_socket() ~= nil then
			-- 		MiscCC:send_quit_server()
			-- 	end
			-- 	GameStateManager:set_state("login")
			-- 	self.login_state = false
			-- 	RoleModel:request_server_list_platform()
			-- end
		else
			MUtils:toast("登陆失败", 2048, 2.5)				
		end 
	end
	local json = "{\"funcID\":\"sdk_sqw_login\"}"
	IOSDispatcher:async_send_to_oc(json,login_succ)
	-- IOSDispatcher:sdksqw_logout()
end

--获取平台登录url
function PlatformSqwApple:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformSqwApple:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformSqwApple:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformSqwApple:logoutFromSelectServer(callbackfunc, reason)
	print('PlatformNoPlatform:logoutFromSelectServer',err, data)
	if callbackfunc then
		callbackfunc()
	end

	if reason then
		MUtils:toast(reason,2048)
	end
	--跳转到无平台登陆页，有平台应该调用SDK
	--并且隐藏窗口
	-- self.firstLogin = true
	RoleModel:change_login_page( "loginSDK" )
end

-- -- 获取该平台，发送请求服务器列表接口的http参数
-- function PlatformSqwApple:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformSqwApple:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id
end

function PlatformSqwApple:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "token=" .. ZXLuaUtils:URLEncode(self.access_token) .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformSqwApple:set_access_token(value)
    self.access_token = value
end

-- 获取登录服务器ip
function PlatformSqwApple:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformSqwApple:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformSqwApple:getPlatformPayUrl()
	return ""
end

--登出
function PlatformSqwApple:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	-- local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformSqwApple.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = PlatformSqwApple.FUNC_LOGIN_OUT
	-- require 'json/json'
	-- local jcode = json.encode( json_table_temp )
	-- send_message_to_java( jcode )	
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

function PlatformSqwApple:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformSqwApple:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformSqwApple:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformSqwApple:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformSqwApple:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformSqwApple:onStartGame(cbfunc)
	cbfunc()
end

function PlatformSqwApple:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformSqwApple:doNeedLogin_delay()
end

function PlatformSqwApple:OnAsyncMessage( id, msg )
	ZXLog('37wan AppleStore版不应该进入这里')
	-- require 'json/json'
	-- local jtable = {}
	-- local s,e = pcall(function() jtable = json.decode(msg) end)
	-- MUtils:toast("成功进入！", 2048, 2.5)
	-- print("s,e",s,e)
	-- if s then
	-- 	local message_type = jtable[ "message_type" ] or ""
	-- 	print("message_type",message_type)
	-- 	if message_type == self.MESSAGE_TYPE then
	-- 		local func_type = jtable[ "funcType" ] or ""
	-- 		local error_code = jtable[ "error_code" ] or self.CODE_FAIL
	-- 		print("func_type",func_type)
	-- 		print('error_code',error_code)
	-- 		if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
	-- 			if error_code == self.CODE_SUCCESS then
	-- 				MUtils:toast("登陆成功", 2048, 2.5)
	-- 				self.access_token = jtable["token"]
	-- 				self.uid = jtable["uid"]
	-- 				self.user_name = jtable["name"]
	-- 				-- self.access_token = jtable[ "access_token" ] or ""
	-- 				-- self.expires_in = jtable[ "expires_in" ] or ""
	-- 				RoleModel:request_server_list_platform()
	-- 			else
	-- 				MUtils:toast("登陆失败", 2048, 2.5)				
	-- 			end
	-- 		end
			
	-- 	end
	-- end
	-- MUtils:toast("登陆失败", 2048, 2.5)
	return false;
end

function PlatformSqwApple:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformSqwApple:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

-- 用于支付窗口PayWin确定平台充值数额
function PlatformSqwApple:get_pay_config_info()
	require "../data/chong_zhi_config"
	return ChongZhiConf.sqw_apple;
end


--平台主动行为封装 Begin
--支付
function PlatformSqwApple:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformSqwApple:getDownloadFrom()
	return 'noplatform'
end

function PlatformSqwApple:showPlatformUI(bFlag)
end


--支付
-- /**
--  *  appstore商品购买(调用此接口时,请先调用getAppSotreProductsInfoFromSQBackstage获得商品信息)
--  *
--  *  @param productid   商品id
--  *  @param productName 商品名称
--  *  @param price       商品价格
--  *  @param serverID    服务器id
--  *  @param outOrderID  外部订单号
--  *  @param extendParam 扩展字段
--  */

-- outorderid= resultJson.getString("outorderid");
-- //itemName = resultJson.getString("itemName");
-- serverId= resultJson.getString("serverId");
-- //serverName = resultJson.getString("serverName");	
-- pext= resultJson.getString("pext");  // 扩展字段  服务器会原样返回给游戏服务器（可选）
-- //userId= resultJson.getString("userId");	
-- //userName = resultJson.getString("userName");
-- money = (float) resultJson.getDouble("money");
-- //moneyRate = (int) resultJson.getInt("moneyRate");
function PlatformSqwApple:payUICallback( info )

	require 'model/iOSChongZhiModel'

    local _item_id  = info.item_id
    local _item_index = info.item_index
	local _userId   = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id

	local _orderId = "LionHeart_37wan-37wan".._userId.."_".._serverId.."_"..os.time();

	ZXLog ("-- PlatformSqwApple 平台 ---", _orderId, _item_id,_item_index,_userId,_serverId)
	MUtils:toast("充值中", 2048, 3)
	-- GlobalFunc:create_screen_notic( "#cfff000正在购买,请稍候", 27, 800/2,480/2 ) 

	local productID;
	productID_table = {
		[1] = "com.shediao.tjxs.sq.60",
		[2] = "com.shediao.tjxs.sq.300",
		[3] = "com.shediao.tjxs.sq.980",
		[4] = "com.shediao.tjxs.sq.1680",
		[5] = "com.shediao.tjxs.sq.3280",
		[6] = "com.shediao.tjxs.sq.6480",
	}
	productID = productID_table[_item_index]
	local productName = string.format("%d元宝",_item_id)

	local function purchase_callback( error, json )
		local json_table = Utils:json2table( json )
		local state_code = json_table["error"];
		if state_code == 1 then
			-- 购买成功
			-- GlobalFunc:create_screen_notic( LangGameString[769], 27, 800/2,480/2 ) -- [769]="#cfff000购买成功"
			MUtils:toast("充值成功", 2048, 3)
		elseif state_code == 0 then
			-- 购买失败
			-- GlobalFunc:create_screen_notic( LangGameString[770], 27, 800/2,480/2 ) -- [770]="#cfff000购买失败,请稍后再试"
			MUtils:toast("#cfff000购买失败,请稍后再试", 2048, 3)
		end
	end

	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id


--  *  @param productid   商品id
--  *  @param productName 商品名称
--  *  @param price       商品价格
--  *  @param serverID    服务器id
--  *  @param outOrderID  外部订单号
--  *  @param extendParam 扩展字段

-- funcID:调用的函数
-- productID:商品id
-- productName:商品名称
-- userId:用户id

	local json = string.format("{\"funcID\":\"sdk_sqw_purchase\",\"productID\":\"%s\",\"productName\":\"%s\",\"price\":%d,\"serverid\":%d,\"outOrderID\":\"%s\"}",productID, productName, _item_id/10, serId, _orderId)

	IOSDispatcher:async_send_to_oc(json,purchase_callback)
end


function PlatformSqwApple:getLoginRet()
	return self.uid, self.token
end


function PlatformSqwApple:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.sqw_apple;
end
--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformSqwApple:share(info)

end

function PlatformSqwApple:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformSqwApple:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformSqwApple:open_user_center()
	
end

function PlatformSqwApple:onLoginResult( err, data )
	-- body
end
