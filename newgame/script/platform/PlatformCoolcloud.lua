PlatformCoolcloud= {}

PlatformCoolcloud.MESSAGE_TYPE	= "platform"

PlatformCoolcloud.FUNC_CHANGE_ACCOUNT = "change_account"

PlatformCoolcloud.FUNC_LOGIN		= "login"		--登录

PlatformCoolcloud.FUNC_PAY		= "pay"			--支付

PlatformCoolcloud.FUNC_TAB		= "tab"			--切换账号
PlatformCoolcloud.FUNC_QUIT 	= "quit" 		--退出
PlatformCoolcloud.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformCoolcloud.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformCoolcloud.FUNC_CREATE		= "create_role" --创建角色
PlatformCoolcloud.FUNC_ENTERGAME	= "enter_game" --进入游戏
PlatformCoolcloud.FUNC_LEVELUP	= "level_up" --人物升级
PlatformCoolcloud.FUNC_LOGINSUCCESS = "login_success" --登录成功后 要告诉平台 游戏版本更新
PlatformCoolcloud.CODE_SUCCESS = 0
PlatformCoolcloud.INIT_SLIDER = "init_slider"

-- PlatformCoolcloud.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformCoolcloud.STATE_LOGIN_FAIL = 1	-- 失败

PlatformCoolcloud.STATE_LOGIN_CANCLE = 2	-- 失败

-- 不准许有全局参数，因为需要被reload
function PlatformCoolcloud:init()

	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.param = {}
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()
	self.AppId = ''
	self.channel = ""
	self.plat = ""
	self.uuid = ""
	self.subchannel = ""
end

-- 显示登录界面
-- function PlatformCoolcloud:onEnterLoginState()
-- 	RoleModel:show_login_win(GameStateManager:get_game_root())
-- 	RoleModel:change_login_page("login_platform")
-- 	local c = callback:new()

-- 		c:start(0.1,function()

-- 			PlatformCoolcloud:doLogin()

-- 		end)
		
-- 	self.firstLogin = false
-- end

-- 按下登录按钮的回调，应显示平台登录页
function PlatformCoolcloud:doLogin()
	MUtils:toast("请求登录授权", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url

function PlatformCoolcloud:get_login_url()
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('develop_log_url')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformCoolcloud:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformCoolcloud:show_logout(callbackfunc)
	callbackfunc()
end

--从选服界面登出
function PlatformCoolcloud:logoutFromSelectServer(callbackfunc, reason)
	if callbackfunc then
		callbackfunc()
	end
	--并且隐藏窗口
	RoleModel:change_login_page("login_platform")
end

--login 的参数
function PlatformCoolcloud:get_login_param( account, dbip, server_id )
	local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
 	local str_login_param = "uid="..tostring(self.uid).."&udid="..tostring(udid).."&channel=".."platform_kupai".."&sub_channel=".."platform_kupai".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
  	return str_login_param
end

function PlatformCoolcloud:get_login_param_json( user_name, password )
	local time = os.time()
    return "uid=" .. self.code .. "&code="..self.code.."&time="..tostring(time).."&sign="..md5("platform_kupai"..tostring(time).."67b5a0cdb36b46e18bf23da0e9dbf425")
end

-- 获取登录服务器ip

function PlatformCoolcloud:getServerIP()
 	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
 	_url = UpdateManager.servlist_url
	-- print("运行了PlatformIQ:getServerIP===>>>>>>    ",  _url)
	return _url
end
-- 获取平台支付地址

function PlatformCoolcloud:getPlatformPayUrl()
	return ""
end
--登出

-- function PlatformCoolcloud:logout(callbackfunc)
-- 	if callbackfunc then
-- 		callbackfunc()
-- 	end
-- 	local json_table_temp = {}
-- 	json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段
-- 	json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_LOGIN_OUT
-- 	require 'json/json'
-- 	local jcode = json.encode( json_table_temp )
-- 	send_message_to_java( jcode )	
-- 	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
-- end

function PlatformCoolcloud:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

--无法登入游戏服务器
function PlatformCoolcloud:failedTologinGameServer(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	RoleModel:destroy_login_without_update_win()
end

-- 上报接口

function PlatformCoolcloud:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformCoolcloud:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新

function PlatformCoolcloud:onStartUpdate(cbfunc)

	cbfunc()

end

--更新完毕等待进入游戏

function PlatformCoolcloud:onStartGame(cbfunc)
	cbfunc()
end

function PlatformCoolcloud:doNeedLogin()

end

-- 按下登录按钮的回调

function PlatformCoolcloud:doNeedLogin_delay()

end

function PlatformCoolcloud:get_cache_url()

	return UpdateManager.cache_url

end

function PlatformCoolcloud:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_QUIT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformCoolcloud:get_package_url()

	return UpdateManager.package_url-- .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')

end



--平台主动行为封装 Begin

--支付

function PlatformCoolcloud:pay(...)

	local payWin = VIPModel:show_chongzhi_win()
	if payWin == nil then 
	   return
	end
end

--支付
function PlatformCoolcloud:payUICallback( info )
	require 'model/iOSChongZhiModel'
	local _money_rate = 10
    local player = EntityManager:get_player_avatar()
    local game_money  = info.item_id 		--元宝数量
	local _userId   = player.id
    local player = EntityManager:get_player_avatar()
	local _serverId = RoleModel:get_login_info().server_id
	local send_java_callback = nil
	local transid = ""
	local coolcloud_params = {
	-- [1] = 1,
	-- [2] = 2,
	-- [3] = 3,
	-- [4] = 4,
	-- [5] = 5,
	-- [6] = 6,
	[7] = 9,
	[8] = 10,
	[20] = 7,
	[21] = 8,
}
	-- 请求回调
	local function http_callback(error_code, message)
		ZXLog("请求充值返回:::::：error code:", error_code)
		ZXLog(string.format("请求充值返回:::::：content: >>%s<<", message))
		if error_code == 0 then
			require 'json/json'
			local jtable = {}
			local s,e = pcall(function()
				jtable = json.decode(message)
			end)
			if not s then 
				return 
			end
			local resulst_code = jtable['ret']								   -- 0：操作失败   1：操作成功   -1：其他错误
			transid = jtable['transid']
			-- print("transidtransidtransidtransidtransid=",transid)
			if resulst_code == "1" then 
				send_java_callback()
			elseif resulst_code == 1 then
			elseif resulst_code == "0" then
			else
			end
			--清空自动重试
			setupHttpAutoReconnect()
		else
			MUtils:lockScreen(false,2048)
			if not doHttpAutoReconnect() then
				ZXLog("http失败!!!")
		   	end
		end
	end

	RoleModel:set_lock_operate(true)		 -- 锁住，在http响应钱不能做任何操作
	local waresid = coolcloud_params[info.item_index] or info.item_index
	local url   = UpdateManager.order_url
	local cporderid = "platform_kupai" ..self.uid.."_".._serverId .."_".. os.time()
	local extra = "userLevel." .. player.level .. "|roleId." .. player.id.."|serverId."..tostring(_serverId).."|productId."..tostring(info.item_index) 
	local param = "waresid=" .. waresid .. "&cporderid=" .. cporderid .. "&price=" .. game_money .. "&appuserid=" .. self.uid .. "&cpprivateinfo=" .. extra .. "&notifyurl=" .. UpdateManager.yuliu_str


	send_java_callback = function()
		-- print("send_java_callback")
		local json_table_temp = {}

		json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段

		json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_PAY


		-- json_table_temp[ "ResultUrl" ] = "http://entry.tjxs.m.shediao.com/zhangshang/SD_zhangshang_tianjiang/paycallback"
		json_table_temp[ "amount" ] = game_money 	--充值或支付金额（现实货币），单位为 元
		-- json_table_temp[ "amount" ] = 1 	--充值或支付金额（现实货币），单位为 元


		-- json_table_temp[ "quantity" ] = 1 						--购买产品数量（商品个数），默认为1

		json_table_temp[ "product_id"] = info.item_index 		--商品唯一标识id

		-- json_table_temp[ "virtual_quantity"] = game_money*_money_rate		--购买产品的虚拟货币数量（如：10元购买100元宝，则为100；或10元购买1000元宝，则为1000），默认为amount（充值显示货币金额）*10

		json_table_temp[ "product_name" ] =  game_money*_money_rate.."元宝" --商品名称

		-- json_table_temp[ "item_desc" ] = game_money*_money_rate.."元宝" 	--商品详细描述

		-- json_table_temp[ "server_id" ] = _serverId 				--服务器Id，默认1

		-- json_table_temp[ "currency" ] = "rmb"

		json_table_temp["extra" ] = extra--"user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index) 
		json_table_temp["openid"] = self.uid or ""
		json_table_temp["expires_in"] = self.param.expires_in or ""
		json_table_temp["refresh_token"] = self.param.refresh_token or ""
		json_table_temp["access_token"] = self.param.access_token or ""
		json_table_temp["pay_url"] = UpdateManager.yuliu_str or ""
		json_table_temp["transid"] = transid
		require 'json/json'

		-- print("iqiyiPayment==========>>>>  ", game_money, _userId, _serverId, json_table_temp[ "extra" ])

		local jcode = json.encode( json_table_temp )

		send_message_to_java( jcode )
	end

	-- print("PlatformCoolcloud:payUICallback url,param",url,param)
	local http_request = HttpRequest:new(url, param, http_callback)
	http_request:send()	
end

--创建角色
function PlatformCoolcloud:create_role_info(create_role_info)

	MUtils:toast("创建角色", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_CREATE
	json_table_temp[ "roleId" ] = create_role_info.roleId or ""
	json_table_temp[ "serverId" ] = create_role_info.serverId or ""
	json_table_temp[ "roleName" ] = create_role_info.roleName or ""
	json_table_temp[ "serverName"] = create_role_info.serverName or ""
	json_table_temp[ "roleLevel"] = create_role_info.roleLevel or ""
	json_table_temp[ "uuid" ] = self.uuid
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


--进入游戏后
function PlatformCoolcloud:init_role_info()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local vip_level = VIPModel:get_vip_info().level
	local roleId = player.id or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local job = player.job or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_ENTERGAME
	-- json_table_temp[ "roleId" ] = roleId
	-- json_table_temp[ "roleName" ] = roleName
	json_table_temp["uid"] 	= self.uid
	json_table_temp["job_sex"] = job
	json_table_temp[ "roleLevel"] = roleLevel
	-- json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "serverName"] = serverName
	-- json_table_temp[ "balance"] = player.yuanbao
	-- json_table_temp[ "vip"] = vip_level
	-- json_table_temp[ "roleCTime"] = "0"
	-- json_table_temp[ "roleLevelMTime"] = "0"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
	-- print_zengsi("进入游戏后 init_role_info -----begin")
	-- Utils:print_table(json_table_temp)
	-- print_zengsi("进入游戏后 init_role_info -----end")
end


function PlatformCoolcloud:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformCoolcloud.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformCoolcloud.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformCoolcloud:getLoginRet()
	return self.uid, self.token
end

function PlatformCoolcloud:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.normal
end

--------------------------------------

--unused function

--HJH 2014-11-27

--写这个架构的人没想清楚，怎么会有下面这些函数

function PlatformCoolcloud:share(info)
end

function PlatformCoolcloud:setLoginRet(uid,psw)
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformCoolcloud:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformCoolcloud:open_user_center()
end

function PlatformCoolcloud:onLoginResult( err, data )
	PlatformInterface:onEnterLoginState()
end

function PlatformCoolcloud:OnAsyncMessage( id, msg )
	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	-- print("s,e===========PlatformCoolcloud:OnAsyncMessage=========>>>",s,e)
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
					self.code = jtable["android_code"]

					RoleModel:request_server_list_platform()
				elseif error_code == self.STATE_LOGIN_CANCLE then --登录取消
					-- print("zengsi login cancle")	
					self:doLogin()	
				else
					-- print("zengsi login fail") 
					self:doLogin()	
				end

			elseif func_type == self.FUNC_TAB then --切换账号
				--这里调退出游戏
				if error_code == self.CODE_SUCCESS then
					local function logout_callback()
						MenusPanel:use_all_equip_tip( )
						AudioManager:stopBackgroundMusic(true)
						-- print_zengsi("zengsi 返回登录中。。。。。。。。。。。。。。。。。。。。。。。。。。")
						MiscCC:send_quit_server()
						GameStateManager:set_state("login")
						-- 取消
						--create by jiangjinhong  通知平台退出平台s
						if GetPlatform() == CC_PLATFORM_IOS then
							IOSDispatcher:IAP_remove_observer( )
						elseif GetPlatform() == CC_PLATFORM_ANDROID then
							-- ForceUpdateMgr:do_android_update()
						elseif GetPlatform() == CC_PLATFORM_WIN32 then	
							-- ForceUpdateMgr:do_win32_update()
						end
					end
					-- print_zengsi("zengsi PlatformCoolcloud:logout(logout_callback)。。。。。。。。。。。。。。。。。。。。。。。。。。")
					PlatformCoolcloud:logout(logout_callback)
					self.code = jtable["android_code"]
					RoleModel:request_server_list_platform()
				else
					-- print_zengsi("用户登录失败，或者取消")
				end
			elseif func_type == self.FUNC_QUIT then
				-- if error_code == 0 then
				-- 	ZXGameQuit()
				-- elseif error_code == 1 then
					QuitGame()
				-- end
			end	
		end
	end
	return false;
end

function PlatformCoolcloud:set_uid(uid)
	self.uid = uid
	self.code =uid
end

function PlatformCoolcloud:set_back_param(param)
	-- print_zengsi("recv>>>>>>>>>>>>>>>.")
	self.param = param
end