PlatformIQiYi= {}

PlatformIQiYi.MESSAGE_TYPE	= "platform"

PlatformIQiYi.FUNC_CHANGE_ACCOUNT = "change_account"

PlatformIQiYi.FUNC_LOGIN		= "login"		--登录

PlatformIQiYi.FUNC_PAY		= "pay"			--支付

PlatformIQiYi.FUNC_TAB		= "tab"			--切换账号
PlatformIQiYi.FUNC_QUIT 	= "quit" 		--退出
PlatformIQiYi.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformIQiYi.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformIQiYi.FUNC_CREATE		= "create_role" --创建角色
PlatformIQiYi.FUNC_ENTERGAME	= "enter_game" --进入游戏
PlatformIQiYi.FUNC_LEVELUP	= "level_up" --人物升级
PlatformIQiYi.FUNC_LOGINSUCCESS = "login_success" --登录成功后 要告诉平台 游戏版本更新
PlatformIQiYi.CODE_SUCCESS = 0
PlatformIQiYi.INIT_SLIDER = "init_slider"

PlatformIQiYi.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformIQiYi.STATE_LOGIN_FAIL = 1	-- 失败

PlatformIQiYi.STATE_LOGIN_CANCLE = 2	-- 失败



-- 不准许有全局参数，因为需要被reload

--

--


function PlatformIQiYi:init()

	self.firstLogin = true



	self.logoutable = true

	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }

	self.download_url =  ''

	self.home_url     = CommonConfig.home

	--http是否已经返回！

	self.payurl_waiting     = false

	self.unlockcallback = callback:new()

	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>Iqiyi")

	self.AppId = ''

	self.channel = ""
	self.uuid = ""
	self.subchannel = ""


end



function PlatformIQiYi:get_server_filter_list()

	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')

end



-- @param:是否进入或者离开游戏场景,true：进入,false:离开

function PlatformIQiYi:onEnterGameScene(isEnter)

	if isEnter == true then
		
	else

	end

end

function PlatformIQiYi:init_role_info()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = login_info.user_name or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_ENTERGAME
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "serverId" ] = "ppsmobile_s"..serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "roleLevel"] = roleLevel
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformIQiYi:onPlayerLevelUp()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = login_info.user_name or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_LEVELUP
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "roleLevel"] = roleLevel
	require 'json/json'
	-- GlobalFunc:create_screen_notic("人物升级send_message_to_java")
	-- MUtils:toast("人物升级send_message_to_java",2048,2.5) -- [69]="请求登录授权"
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


--获取平台登录url

function PlatformIQiYi:get_login_url()

	--UpdateManager.login_url = nil

	local platform_id =  Target_Platform
	print("PlatformIQiYi============>>>>>>>>>get_login_url")
	-- local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('develop_log_url')

	if _url == '' then

		_url = UpdateManager.server_url .. 'noplatform/'

	end

	return _url

end



--获取服务器列表url

function PlatformIQiYi:get_servlist_url()

	return GameUrl_global:getServerIP() or ""

end

-- login 的参数

function PlatformIQiYi:get_login_param( account, dbip, server_id )

	local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
 	local str_login_param = "uid="..tostring(self.uid).."&udid="..tostring(udid).."&channel=".."platform_iqiyi".."&sub_channel=".."platform_iqiyi".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
  	return str_login_param
  	
 	
    -- return str_login_param
end



function PlatformIQiYi:get_login_param_json( user_name, password )

	local time = os.time()
    return "uid="..self.uid.."&time="..tostring(time).."&sign="..md5("platform_iqiyi"..tostring(time).."74974bf301ff7e270d0e1e6860735f38")

end

-- 获取登录服务器ip

function PlatformIQiYi:getServerIP()
 	_url = UpdateManager.servlist_url
	print("运行了PlatformIQ:getServerIP===>>>>>>    ",  _url)
	return _url
end

--登出

function PlatformIQiYi:logout(callbackfunc)

	-- --print("run loginout11111")

	if callbackfunc then

		callbackfunc()

	end

	-- --print("run loginout22222")

	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_LOGIN_OUT

	require 'json/json'

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )	

	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'



end

function PlatformIQiYi:doNeedLogin()

end

-- 按下登录按钮的回调

function PlatformIQiYi:doNeedLogin_delay()

end

function PlatformIQiYi:get_cache_url()

	return UpdateManager.cache_url

end

function PlatformIQiYi:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_QUIT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformIQiYi:get_package_url()

	return UpdateManager.package_url-- .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')

end



--平台主动行为封装 Begin

--支付

function PlatformIQiYi:pay(...)

	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	--paywin里直接调用payUICallback
	-- payWin:setCallback(function(which)

	-- 		self:payUICallback({ item_id = which, window = 'pay_win' })

	-- 	end)
	
end

--支付
function PlatformIQiYi:payUICallback( info )
	require 'model/iOSChongZhiModel'
	local _money_rate = 10

    local player = EntityManager:get_player_avatar()
    local game_money  = info.item_id 		--元宝数量

    local player = EntityManager:get_player_avatar()

	local _userId   = player.id
	local _serverId = RoleModel:get_login_info().server_id
	--_serverId = "ppsmobile_s"..tostring(_serverId)

	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_PAY
	json_table_temp[ "amount" ] = game_money	--充值或支付金额（现实货币），单位为 元
	json_table_temp[ "server_id" ] = "ppsmobile_s"..tostring(_serverId)				--服务器Id，默认1
	json_table_temp[ "extra" ] = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index) 
	json_table_temp["roleId"] = _userId

	require 'json/json'
	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )
end

--创建角色
function PlatformIQiYi:create_role_info(create_role_info)

	MUtils:toast("创建角色", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_CREATE
	json_table_temp[ "roleId" ] = create_role_info.roleId or ""
	json_table_temp[ "serverId" ] = "ppsmobile_s"..create_role_info.serverId or ""
	json_table_temp[ "roleName" ] = create_role_info.roleName or ""
	json_table_temp[ "serverName"] = create_role_info.serverName or ""
	json_table_temp[ "roleLevel"] = create_role_info.roleLevel or ""
	json_table_temp[ "uuid" ] = self.uuid
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformIQiYi:init_slider()
	local json_table_temp = {}
	json_table_temp["message_type"] = PlatformIQiYi.INIT_SLIDER
	local jcode = json.encode(json_table_temp)
	send_message_to_java(jcode)
end


function PlatformIQiYi:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformIQiYi.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformIQiYi.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end




function PlatformIQiYi:getLoginRet()

	return self.uid, self.token

end





function PlatformIQiYi:getPayInfo()

	require "../data/chong_zhi_config"

	return ChongZhiConf.normal

end

--------------------------------------

--unused function

--HJH 2014-11-27

--写这个架构的人没想清楚，怎么会有下面这些函数

function PlatformIQiYi:share(info)



end



function PlatformIQiYi:setLoginRet(uid,psw)

	

end



-- 获取该平台，发送请求服务器列表接口的http参数

function PlatformIQiYi:get_servlist_param(  )

	return ""

end



-- 打开用户中心

function PlatformIQiYi:open_user_center()

	

end



function PlatformIQiYi:onLoginResult( err, data )

	-- body
	--[[
	roleId
	roleName
	roleLevel
	serverId
	serverName
	--]]
	PlatformInterface:onEnterLoginState()


end

function PlatformIQiYi:OnAsyncMessage( id, msg )
	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	print("s,e===========PlatformIQiYi:OnAsyncMessage=========>>>",s,e)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		--print("message_type",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			--print("func_type",func_type)
			--print('error_code',error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					-- MUtils:toast("登录成功", 2048, 2.5)
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					-- -- self.access_token = jtable[ "access_token" ] or ""
					-- -- self.expires_in = jtable[ "expires_in" ] or ""

					print("运行了PlatformIQ============iYi:OnAsyncMessage( id, msg )===>>>", self.uid, self.pwd, self.password_changed)
					-- RoleModel:change_login_page( 'new_select_server_page' )
					-- RoleModel:send_name_and_pw( self.uid, self.pwd,self.password_changed, true )
					RoleModel:request_server_list_platform()
				else
					--0.5秒尝试登录一次
					local cb  = callback:new()
					local function try_login( ... )
						self:doLogin()	
					end
					cb:start(0.5,try_login)		
				end
			elseif func_type == self.FUNC_RELOGIN then -- 重连
				if GameStateManager:get_state()=="scene" then
					MiscCC:send_quit_server()
				end
				AIManager:set_AIManager_idle()
				GameStateManager:set_state("login")
				self:doLogin()
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then

				if GameStateManager:get_state()=="scene" then
					MiscCC:send_quit_server()
				end
				AIManager:set_AIManager_idle()
				GameStateManager:set_state("login")
				if error_code == self.CODE_SUCCESS then
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					RoleModel:request_server_list_platform()
				end
				-- RoleModel:change_login_page("new_select_server_page")
			elseif func_type == self.FUNC_TOAST then
				local toast = jtable["toast"]
				MUtils:toast(toast, 2048, 2.5)
			elseif func_type == self.FUNC_QUIT then
				ZXGameQuit()
			end	
		end
	end
	return false;
end