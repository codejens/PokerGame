PlatformSC= {}

PlatformSC.MESSAGE_TYPE	= "platform"

PlatformSC.FUNC_CHANGE_ACCOUNT = "change_account"

PlatformSC.FUNC_LOGIN		= "login"		--登录

PlatformSC.FUNC_PAY		= "pay"			--支付

PlatformSC.FUNC_TAB		= "tab"			--切换账号

PlatformSC.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformSC.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformSC.CODE_SUCCESS = 0

PlatformSC.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformSC.STATE_LOGIN_FAIL = 1	-- 失败



-- 不准许有全局参数，因为需要被reload

--

--

function PlatformSC:init()

	self.firstLogin = true
	
	self.login_type = "true"

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



function PlatformSC:get_server_filter_list()

	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')

end



-- @param:是否进入或者离开游戏场景,true：进入,false:离开

function PlatformSC:onEnterGameScene(isEnter)

	if isEnter == true then



	else



	end

end



-- 入口,当Login界面Show

-- 显示登陆界面

function PlatformSC:onEnterLoginState(state)

	RoleModel:show_login_win( GameStateManager:get_game_root() )

	-- if self.firstLogin == true then

	MUtils:toast("生菜 登陆请求授权",2048,3) -- [69]="请求登录授权"

	local c = callback:new()

		c:start(0.1,function()

			PlatformSC:doLogin()

		end)

	self.firstLogin = false

	-- end

end



-- 按下登录按钮的回调，应显示平台登陆页

function PlatformSC:doLogin()

	--跳转到无平台登陆页，有平台应该调用SDK

	-- RoleModel:change_login_page( "login" )

	MUtils:toast("PlatformSC:doLogin", 2048, 3)



	-- RoleModel:change_login_page( "login" )

	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformSC.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformSC.FUNC_LOGIN

	json_table_temp[ "login_type" ] = self.login_type

	require 'json/json'

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )

end



--获取平台登录url

function PlatformSC:get_login_url()

	--UpdateManager.login_url = nil

	local platform_id =  Target_Platform

	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')

	if _url == '' then

		_url = UpdateManager.server_url .. 'noplatform/'

	end

	return _url

end



--获取服务器列表url

function PlatformSC:get_servlist_url()

	return GameUrl_global:getServerIP() or ""

end



function PlatformSC:show_logout(callbackfunc)

	callbackfunc()

end





--从选服界面登出

function PlatformSC:logoutFromSelectServer(callbackfunc, reason)

	print('PlatformNoPlatform:logoutFromSelectServer',err, data)

	if callbackfunc then

		callbackfunc()

	end



	-- if reason then

	-- 	MUtils:toast(reason,2048)

	-- end

	--跳转到无平台登陆页，有平台应该调用SDK

	--并且隐藏窗口
    self.login_type = "false"
	RoleModel:change_login_page( "loginSDK" )

end



-- -- 获取该平台，发送请求服务器列表接口的http参数

-- function PlatformSC:get_servlist_param()

-- 	local account, pwd = self:getLoginRet()

-- 	if account then

-- 		return string.format('account=%s&pw=%s',account,md5(pwd));

-- 	else

-- 		return ''

-- 	end

-- end



-- login 的参数

function PlatformSC:get_login_param( account, dbip, server_id )

    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')

end



function PlatformSC:get_login_param_json( )
  
    return 'uid='..self.uid
    -- return ""
end





-- 获取登录服务器ip

function PlatformSC:getServerIP()

	--UpdateManager.servlist_url = nil

	local platform_id =  Target_Platform

	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')

	print("PlatformSC:getServerIP:",_url)

	if _url == '' then

		_url = UpdateManager.servlist_url

		print("UpdateManager.servlist_url",servlist_url)

	end

	return _url

end



-- 获取平台支付地址

function PlatformSC:getPlatformPayUrl()

	return ""

end



--登出

function PlatformSC:logout(callbackfunc)

	-- print("run loginout11111")

	if callbackfunc then

		callbackfunc()

	end

	-- print("run loginout22222")

	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformSC.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformSC.FUNC_LOGIN_OUT

	require 'json/json'

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )	

	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'



end



function PlatformSC:lost_connect( callbackfunc )

	if callbackfunc then

		callbackfunc()

	end

	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'

end





--无法登入游戏服务器

function PlatformSC:failedTologinGameServer(callbackfunc)



	if callbackfunc then

		callbackfunc()

	end



	RoleModel:destroy_login_without_update_win()

end





-- 上报接口

function PlatformSC:notifyZone( ... )

	-- 子类重写

end



--最初的启动

function PlatformSC:onStartPackage(cbfunc)

	cbfunc()

end



--开始更新

function PlatformSC:onStartUpdate(cbfunc)

	cbfunc()

end



--更新完毕等待进入游戏

function PlatformSC:onStartGame(cbfunc)

	cbfunc()

end



function PlatformSC:doNeedLogin()

end



-- 按下登录按钮的回调

function PlatformSC:doNeedLogin_delay()

end



function PlatformSC:OnAsyncMessage( id, msg )

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
                   
                   --需要先退出当前登录的游戏
					self.uid = jtable["uid"]
					self.login_type = jtable["login_type"]

			    if GameStateManager:get_state()=="scene" then
						MiscCC:send_quit_server()
						AIManager:set_AIManager_idle()
					    GameStateManager:set_state("login")
				else

					-- self.access_token = jtable[ "access_token" ] or ""

					-- self.expires_in = jtable[ "expires_in" ] or ""

					RoleModel:request_server_list_platform()
				end

				else

					MUtils:toast("登陆失败", 2048, 2.5)				

				end

			end

		end

	end

	return false;

end



function PlatformSC:get_cache_url()

	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')

end



function PlatformSC:get_package_url()

	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')

end



--平台主动行为封装 Begin

--支付

function PlatformSC:pay(...)

	local payWin = UIManager:show_window("pay_win");

	payWin:setCallback(function(which)

			self:payUICallback({ item_id = which, window = 'pay_win' })

		end)

end



function PlatformSC:getDownloadFrom()

	return 'noplatform'

end



function PlatformSC:showPlatformUI(bFlag)

end


--支付
function PlatformSC:payUICallback( info )
	-- HelpPanel:show( 3, UILH_NORMAL.title_tips, "内测期间不提供充值" )
	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 0.1
    -- local user_account = RoleModel:get_login_info().user_name

    local _item_id  = info.item_id

    local player = EntityManager:get_player_avatar()

	local _userId   = player.id

	-- local _userName = RoleModel:get_login_info().user_name

	-- local balance = player.yuanbao

	-- local partyName = ""

	-- local vipLevel = player.vipFlag

	local _serverId = RoleModel:get_login_info().server_id

	local _privateField = "SD_shengcai_"..self.uid.."_".._serverId;

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)

	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )



	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformSC.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformSC.FUNC_PAY


	json_table_temp[ "notifyUrl" ] = "http://entry.tjxs.m.shediao.com/shengcai/SD_shengcai/paycallback"

	json_table_temp[ "reqFee" ] = _item_id * _money_rate


	json_table_temp[ "tradeDesc" ] =  _item_id.."元宝"

	json_table_temp[ "tradeName" ] = _item_id.."元宝"

	json_table_temp[ "userid" ] = self.uid

	json_table_temp[ "privateField" ] = _privateField

	json_table_temp[ "tradeId" ] = "shengcai_"..os.time()
	
	require 'json/json'

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )

end


function PlatformSC:switch_account()
    
	self.login_type = "false"
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformSC.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformSC.FUNC_LOGIN
	json_table_temp[ "login_type" ] = self.login_type
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end




function PlatformSC:getLoginRet()

	return self.uid, self.token

end





function PlatformSC:getPayInfo()

	require "../data/chong_zhi_config"

	return ChongZhiConf.shengcai

end

--------------------------------------

--unused function

--HJH 2014-11-27

--写这个架构的人没想清楚，怎么会有下面这些函数

function PlatformSC:share(info)



end



function PlatformSC:setLoginRet(uid,psw)

	

end



-- 获取该平台，发送请求服务器列表接口的http参数

function PlatformSC:get_servlist_param(  )

	return ""

end



-- 打开用户中心

function PlatformSC:open_user_center()

	

end



function PlatformSC:onLoginResult( err, data )

	-- body

end