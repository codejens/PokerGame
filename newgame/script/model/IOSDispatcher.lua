--IOSDispatcher.lua
--iOS消息派发器
--备注:发往OC层的json格式必须包含funcID字段,标识哪个函数。
--json = {"funcID":"iap_purchase"}
--json = {"funcID":"iap_purchase","productID":"mieshenProduct1"}(带参数)

IOSDispatcher = {}

--同步调用oc函数
function IOSDispatcher:sync_send_to_oc(json)
	local callback = IOSBridgeDispatcher(json)
	return callback
end

--异步调用oc函数(luaHandler函数至少接受2个参数func(error,msg))
function IOSDispatcher:async_send_to_oc(json, luaHandler)
	IOSBridgeDispatcherAsync(json, luaHandler)
end

--获取iOS设备信息
--["identifier"] ：设备唯一标识
--["iOSVer"]     ：系统版本
--["deviceVer"]  ：设备型号
--["os"]         ：操作系统名字
function IOSDispatcher:get_device_info()
	local json = "{\"funcID\":\"device_info\"}"
	local ret  = IOSDispatcher:sync_send_to_oc(json)
	if ret then
		require "utils/Utils"
		local json_table = Utils:json2table(ret)
		return json_table
	end
end

-----------------appStore内购-----------------

--保存账号和服务器id(在oc中保存验证订单时需要用的信息)
function IOSDispatcher:set_login_message(user_account, serId)
	local url = PlatformInterface:get_iap_callback()
	if not url then
		return
	end
	assert(url, "入口没有配置支付回调url")
	url = string.lower(url)
	local i,j = string.find(url, "com")
	assert(i ~= j, "支持回调地址有误")
	local domain = string.sub(url, 8, j)
	local exten  = string.sub(url, j+1, url.length)
	local json   = string.format("{\"funcID\":\"iap_setLoginMsg\", \"domain\":\"%s\", \"url\":\"%s\", \"userId\":\"%s\", \"serId\":%d}", domain, exten, user_account, serId)
	IOSDispatcher:sync_send_to_oc(json)
end

--是否可以交易
function IOSDispatcher:IAP_can_purchase()
	local json = "{\"funcID\":\"iap_purchase\"}"
	local ret  = IOSDispatcher:sync_send_to_oc(json)
	return ret
end

--购买
function IOSDispatcher:IAP_purchase_product(productID, callback)
	local account = RoleModel:get_login_info().user_name
	local serId   = RoleModel:get_login_info().server_id
	local json    = string.format("{\"funcID\":\"iap_purchase\", \"productID\":\"%s\", \"userId\":\"%s\", \"serverid\":%d}", productID, account, serId)
	IOSDispatcher:async_send_to_oc(json, callback)
end

--添加内购监听
function IOSDispatcher:IAP_add_observer()
	local function callback(error, json)
		require "model/iOSChongZhiModel"
		iOSChongZhiModel:addObserver(error, json)
	end
	local json = "{\"funcID\":\"iap_addObserver\"}"
	IOSDispatcher:async_send_to_oc(json, callback)
end

--删除内购监听
function IOSDispatcher:IAP_remove_observer()
	local json = "{\"funcID\":\"iap_removeObserver\"}"
	IOSDispatcher:sync_send_to_oc(json)
end

--确认充值队列里是否有未验证的订单，重新验证
function IOSDispatcher:IAP_reverfy_payment_queue()
	local function callback(error, json)
		require "model/iOSChongZhiModel"
		iOSChongZhiModel:addObserver(error, json)
	end
	local json = "{\"funcID\":\"iap_reverfy\"}"
	IOSDispatcher:async_send_to_oc(json, callback)
end

--结束交易
function IOSDispatcher:IAP_finish_transcation()
	local json = "{\"funcID\":\"iap_finish\"}"
	IOSDispatcher:sync_send_to_oc(json)
end

--appstore强制更新
function IOSDispatcher:appStoreUpdate(url)
	local function update_callback(error_code, json)
		local json_table = Utils:json2table(json)
		local error      = json_table["error"]
	end
	local json = string.format("{\"funcID\":\"appstore_update\", \"updateUrl\":\"%s\"}", url)
    local ret  = IOSDispatcher:async_send_to_oc(json, update_callback)
    return ret
end

--GameCenter 
function IOSDispatcher:gamecenter_authenticateLocalUser(callback)
	local json = "{\"funcID\":\"gamecenter_authenticate\"}"
	IOSDispatcher:async_send_to_oc(json, callback)
end

--AdMob(显示广告)
function IOSDispatcher:show_admob_banner()
	local json = "{\"funcID\":\"admob_banner\"}"
	IOSDispatcher:sync_send_to_oc(json)
end

--启动推送api
function IOSDispatcher:open_push_service(post_url)
	local function call_back(error_code, json)
		local json_table = Utils:json2table(json)
		local error      = json_table["error"]
		--获取到token保持到服务器
		local json_token = json_table["token"]
		local token      = string.sub(json_token, 2, string.len(json_token)-1)
		local function http_callback(error_code, message)
		    --ZXLog( "-----上报token http_callback:-------", error_code, message)
		end
		local device_info  = IOSDispatcher:get_device_info()
		local udid         = device_info["identifier"]
		local url          = post_url.."rec_token"
		local param        = "token="..token.."&udid="..udid
		local http_request = HttpRequest:new(url, param, http_callback)
		http_request:send()
	end
	local json = "{\"funcID\":\"addPushService\"}"
	IOSDispatcher:async_send_to_oc(json, call_back)
end

--显示消息弹框
function IOSDispatcher:showMsgBox(msg, title)
	local function callback(error_code, json)
	end
	local json = string.format("{\"funcID\":\"showMessge\", \"msg\":\"%s\", \"title\":\"%s\"}", msg, title)
    IOSDispatcher:async_send_to_oc(json, callback)
end

---------------------------91 sdk-----------------------------
function IOSDispatcher:sdk91_logout(  )
	local  function fcallback()
		-- body
		if NetManager:get_socket() ~= nil and MiscCC ~= nil then
			MiscCC:send_quit_server()
		end
		GameStateManager:set_state("login")
		-- 取消
		IOSDispatcher:IAP_remove_observer( )
		--注销登录
		PlatformInterface:show_logout()

	end

	local json = string.format("{\"funcID\":\"sdk91_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,fcallback )
end

function IOSDispatcher:sdk91_login()
	local function login_succ( error_code, json )
		--[[
		local json_table = Utils:json2table(json)
		local error = json_table["error"]

		local uin = json_table["loginUin"]
		local sessionId = json_table["sessionId"]
		local nikeName = json_table["nickName"]

		ZXLog("-------login_succ-----",uin,sessionId,nikeName)
		
        RoleModel:send_name_and_pw( uin,sessionId , false)]]

        PlatformInterface:onLoginResult(json)
	end

	local json = "{\"funcID\":\"sdk91_login\"}"

	-- ----print("json.........."..json)

	IOSDispatcher:async_send_to_oc(json,login_succ)

	IOSDispatcher:sdk91_logout()

end

--91platform :进入平台
function IOSDispatcher:enter_platform( )
	-- body
    local json = "{\"funcID\":\"sdk91_enter_platform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--91platform :进入bbs
function IOSDispatcher:enter_bbs( )
	-- body
	local json = "{\"funcID\":\"sdk91_enter_bbs\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--91platform :游戏反馈
function IOSDispatcher:user_feedback( )
	-- body
	local json = "{\"funcID\":\"sdk91_user_feedback\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--91platform :游戏充值
function IOSDispatcher:user_chongzhi( )
	-- body
	local json = "{\"funcID\":\"sdk91_chongzhi\"}"
    local ret = IOSDispatcher:async_send_to_oc( json )

    local function chongzhi_callback( error_code, json )

		local json_table = Utils:json2table(json)
		local error = json_table["error"]

		local msg = json_table["message"]

        --RoleModel:send_name_and_pw( uin,sessionId , false)

	end

--{\"funcID\":\"iap_purchase\",\"productID\":\"%s\",\"userId\":
     
    local server_id=RoleModel:get_login_info().server_id
    local json = string.format("{\"funcID\":\"sdk91_chongzhi\",\"serverID\":\"%s\"}",server_id)

	IOSDispatcher:async_send_to_oc(json,chongzhi_callback)
	
end

--nd IAP
function IOSDispatcher:sdk91_purchase(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"sdk91_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	-- ZXLog("-------------sdk91_purchase----------------------"..json)
	IOSDispatcher:async_send_to_oc(json,callback)
end

function IOSDispatcher:sdk91_set_tool_status(isHide)
	local _isHede = "1"--打开
	if not isHide then
		_isHede="0"--关闭
	end
	local json = string.format("{\"funcID\":\"sdk91_setToolBar\",\"isHideToolBar\":\"%s\"}",_isHede)
	local function callback( ... )
		-- body
	end

	IOSDispatcher:async_send_to_oc(json,callback)
end

---------------------------pp sdk-----------------------------

function IOSDispatcher:sdkpp_logout(  )
	local  function fcallback()
		-- body
		if NetManager:get_socket() ~= nil and MiscCC ~= nil then
			MiscCC:send_quit_server()
		end
		GameStateManager:set_state("login",false)
		-- -- 取消
		IOSDispatcher:IAP_remove_observer( )
		--注销登录
		-- PlatformInterface:show_logout()
	end

	local json = string.format("{\"funcID\":\"sdkpp_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,fcallback )
end

local _is_first_login = true
function IOSDispatcher:sdkpp_login()
	local function login_succ( error_code, json )

		-- local json_table = Utils:json2table(json)
		-- local error = json_table["error"]

		-- local uin = json_table["uid"]--486187976
		-- local sessionId = json_table["token"]--5b4b5ee16a853cb2fcafdd022b197c0e
		-- local nikeName = json_table["username"]--账号


  --       RoleModel:send_name_and_pw( uin,sessionId , false)

  		PlatformInterface:onLoginResult(json)

	end

	local json = "{\"funcID\":\"sdkpp_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)

	if _is_first_login then 
		IOSDispatcher:sdkpp_logout()--返回一个注销的函数句柄
	end

end

--跳入游戏界
function IOSDispatcher:sdkpp_get_user_info()
	local function login_succ( error_code, json )

	end

	local json = "{\"funcID\":\"sdkpp_get_user_info\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)
end

--ppPlatform :进入平台
function IOSDispatcher:enter_ppPlatform( )
	-- body
    local json = "{\"funcID\":\"enter_ppPlatform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end


--充值
function IOSDispatcher:pp_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id

	local json = string.format("{\"funcID\":\"pp_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	IOSDispatcher:async_send_to_oc(json,callback)
end


---------------------------ky sdk------------------------------------

-- 注册快用助手平台的登出事件
function IOSDispatcher:ky_registLogoutHandle(  )

	local json = string.format("{\"funcID\":\"ky_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json, PlatformInterface.logout )
end

-- 当然用户点击返回登录按钮时，通知
function IOSDispatcher:ky_user_logout(  )
	local json = string.format("{\"funcID\":\"ky_user_logout\"}")
	IOSDispatcher:sync_send_to_oc( json )
end

-- 显示快用助手平台的登录页面
function IOSDispatcher:ky_showLoginPage()

	local function login_succ( error_code, json )
		
		local json_table = Utils:json2table(json)
		local error = json_table["error"]
		if error == 1 then
			local ky_token = json_table["token"]

			RoleModel:send_name_and_pw( "unuse", ky_token , false)
		end
	end

	local json = string.format("{\"funcID\":\"ky_login\"}")
	
	IOSDispatcher:async_send_to_oc(json, login_succ)

	--是注册
	IOSDispatcher:ky_registLogoutHandle( )
end

-- 快用平台的支付接口
function IOSDispatcher:ky_purchase( orderId, price, callback )

	local ky_guid = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local subject = (price*10).."元宝"

	local json = string.format("{\"funcID\":\"ky_purchase\",\"uid\":\"%s\",\"gameser\":\"%s\",\"fee\":\"%s\",\"subject\":\"%s\",\"receipt\":\"%s\"}",ky_guid,serId,price,subject,orderId)

	IOSDispatcher:async_send_to_oc(json, callback)

end


---------------------------tb sdk------------------------------------

function IOSDispatcher:sdktb_logout(  )

	local  function fcallback()
		-- body
		if NetManager:get_socket() ~= nil and MiscCC ~= nil then
			MiscCC:send_quit_server()
		end
		GameStateManager:set_state("login")
		-- 取消
		IOSDispatcher:IAP_remove_observer( )
		--注销登录
		PlatformInterface:show_logout()

	end

	local json = string.format("{\"funcID\":\"sdktb_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,fcallback )
end

function IOSDispatcher:sdktb_login()
	local function login_succ( error_code, json )
        PlatformInterface:onLoginResult(json)
	end

	local json = "{\"funcID\":\"sdktb_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)

	IOSDispatcher:sdktb_logout()

end

function IOSDispatcher:sdktb_set_tool_status(isHide)
	local _isHede = "1"--打开
	if not isHide then
		_isHede="0"--关闭
	end
	local json = string.format("{\"funcID\":\"sdktb_setToolBar\",\"isHideToolBar\":\"%s\"}",_isHede)
	local function callback( ... )
		-- body
	end

	IOSDispatcher:async_send_to_oc(json,callback)
end

--ppPlatform :进入平台
function IOSDispatcher:enter_tbPlatform( )
	--require "PlatformTB"
    local json = "{\"funcID\":\"enter_tbPlatform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--tb IAP
function IOSDispatcher:tb_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"tb_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	IOSDispatcher:async_send_to_oc(json,callback)
end


---------------------------dj sdk------------------------------------

function IOSDispatcher:sdkdj_logout(  )

	local json = string.format("{\"funcID\":\"sdkdj_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,PlatformInterface.logout )
end

function IOSDispatcher:sdkdj_login()
	local function login_succ( error_code, json )

		local json_table = Utils:json2table(json)
		local error = json_table["error"]

		local uid = json_table["uid"]
		local sessionId = json_table["sessionId"]
		local nikeName = json_table["nickName"]

        RoleModel:send_name_and_pw( uid,sessionId , false)
	end

	local json = "{\"funcID\":\"sdkdj_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)

	IOSDispatcher:sdkdj_logout()

end


--ppPlatform :进入平台
function IOSDispatcher:enter_djPlatform( )
	--require "PlatformTB"
    local json = "{\"funcID\":\"enter_djPlatform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--ppPlatform :进入充值中心
function IOSDispatcher:enter_djChongzhiCenter( )
	--require "PlatformTB"
    local json = "{\"funcID\":\"sdkdj_enter_ChongzhiCenter\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--djplatform :切换账户
function IOSDispatcher:change_djuser_count( )
	-- body
	local json = "{\"funcID\":\"sdkdj_change_user_acount\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--tb IAP
function IOSDispatcher:dj_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"dj_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	IOSDispatcher:async_send_to_oc(json,callback)
end

-----------------------------ty sdk------------------------------------
function IOSDispatcher:sdkty_logout(  )

	local json = string.format("{\"funcID\":\"sdkty_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,PlatformInterface.logout )
end

--换号登录
function IOSDispatcher:sdkty_login()
	local function login_succ( error_code, json )
		local json_table = Utils:json2table(json)
		local error = json_table["error"]
		local uid = json_table["uid"]
		local sessionId = json_table["sessionId"]
		local nikeName = json_table["nickName"]
        RoleModel:send_name_and_pw( uid,sessionId , false)
	end

	local json = "{\"funcID\":\"sdkty_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)

	IOSDispatcher:sdkty_logout()
end

--tyPlatform :进入平台
function IOSDispatcher:enter_tyPlatform( )
	-- body
    local json = "{\"funcID\":\"enter_tyPlatform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--ty IAP
function IOSDispatcher:ty_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"ty_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	
	-- ----print("ty_purchase_product------------------"..json)
	IOSDispatcher:async_send_to_oc(json,callback)
end


-----------------------------49y sdk------------------------------------

function IOSDispatcher:sdkny_logout(  )

	local json = string.format("{\"funcID\":\"sdkny_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,PlatformInterface.logout )
end

--换号登录
function IOSDispatcher:sdkny_login()
	local function login_succ( error_code, json )
		local json_table = Utils:json2table(json)
		local error = json_table["error"]
		local uid = json_table["uid"]
		local sessionId = json_table["sessionId"]
		local nikeName = json_table["nickName"]
        RoleModel:send_name_and_pw( uid,sessionId , false)
	end

	local json = "{\"funcID\":\"sdkny_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)

	IOSDispatcher:sdkny_logout()
end

--nyPlatform :进入平台
function IOSDispatcher:sdkny_enterPlatform( )
	-- body
    local json = "{\"funcID\":\"enter_nyPlatform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--ny IAP
function IOSDispatcher:sdkny_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"ny_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	
	-- ----print("ty_purchase_product------------------"..json)
	IOSDispatcher:async_send_to_oc(json,callback)
end


-----------------------------sqw sdk------------------------------------

function IOSDispatcher:sdksqw_logout(  )

	local json = string.format("{\"funcID\":\"sdk_sqw_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,PlatformInterface.logout )
end

--换号登录
function IOSDispatcher:sdksqw_login()
	local function login_succ( error_code, json )
		local json_table = Utils:json2table(json)
		local error = json_table["error"]
		local uid = json_table["uid"]
		local sessionId = json_table["sessionId"]
		local nikeName = json_table["nickName"]
        RoleModel:send_name_and_pw( uid,sessionId , false)
	end

	local json = "{\"funcID\":\"sdk_sqw_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)
	IOSDispatcher:sdksqw_logout()
end

--nyPlatform :进入平台
function IOSDispatcher:sdksqw_enterPlatform( )
	-- body
    local json = "{\"funcID\":\"sdk_sqw_enter_Platform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--ny IAP
function IOSDispatcher:sdksqw_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"sdk_sqw_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	
	-- ----print("ty_purchase_product------------------"..json)
	IOSDispatcher:async_send_to_oc(json,callback)
end


-----------------------------sqw台湾 sdk------------------------------------

function IOSDispatcher:sdksqwtw_logout(  )

	local json = string.format("{\"funcID\":\"sdksqwtw_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,PlatformInterface.logout )
end

--换号登录
function IOSDispatcher:sdksqwtw_login()
	local function login_succ( error_code, json )
		local json_table = Utils:json2table(json)
		local error = json_table["error"]
		local uid = json_table["uid"]
		local sessionId = json_table["sessionId"]
		local nikeName = json_table["nickName"]
        RoleModel:send_name_and_pw( uid,sessionId , false)
	end

	local json = "{\"funcID\":\"sdksqwtw_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)
	IOSDispatcher:sdksqwtw_logout()
end

--sqw :进入平台
function IOSDispatcher:sdksqwtw_enterPlatform( )
	-- body
    local json = "{\"funcID\":\"sdksqwtw_enter_platform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--sqw IAP
function IOSDispatcher:sdksqwtw_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"sdksqwtw_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	
	-- ----print("ty_purchase_product------------------"..json)
	IOSDispatcher:async_send_to_oc(json,callback)
end


-----------------------------itools sdk------------------------------------

function IOSDispatcher:sdkit_logout(  )

	local  function fcallback()
		-- body
		if NetManager:get_socket() ~= nil and MiscCC ~= nil then
			MiscCC:send_quit_server()
		end
		GameStateManager:set_state("login")
		-- 取消
		IOSDispatcher:IAP_remove_observer( )
		--注销登录
		PlatformInterface:show_logout()

	end	

	local json = string.format("{\"funcID\":\"sdkit_logout\"}")
	
	IOSDispatcher:async_send_to_oc( json,fcallback )
end

function IOSDispatcher:sdkit_login()
	local function login_succ( error_code, json )
		PlatformInterface:onLoginResult(json)
	end

	local json = "{\"funcID\":\"sdkit_login\"}"

	IOSDispatcher:async_send_to_oc(json,login_succ)

	IOSDispatcher:sdkit_logout()

end

function IOSDispatcher:enter_itPlatform()
	-- ZXLog("---------IOSDispatcher:enter_itPlatform-------")
	local json = "{\"funcID\":\"sdkit_enter_Platform\"}"
    local ret = IOSDispatcher:sync_send_to_oc( json )
    return ret
end

--sqw IAP
function IOSDispatcher:sdkit_purchase_product(orderId ,price, callback )
	-- productID 产品id
	local user_account = RoleModel:get_login_info().user_name
	local serId = RoleModel:get_login_info().server_id
	local json = string.format("{\"funcID\":\"sdkit_purchase\",\"orderId\":\"%s\",\"price\":%d,\"userId\":\"%s\",\"serverid\":%d}",orderId,price, user_account, serId)
	
	-- ----print("it_purchase_product------------------"..json)
	IOSDispatcher:async_send_to_oc(json,callback)
end

--获取用户udid/idfa
function IOSDispatcher:get_udid()
	local udid = nil
    local device_info = IOSDispatcher:get_device_info()
    if device_info then
	    udid = device_info["identifier"]
	end
	return udid or CCAppConfig:sharedAppConfig():getStringForKey("idfa")
end

--语音相关
function IOSDispatcher:do_yaya_func(json)
	local function cb_fun(error_code, json)
	end
	IOSDispatcher:async_send_to_oc(json, cb_fun)
end

--设置语音回调接口
function IOSDispatcher:set_yaya_func()
	local function cb_fun(error_code, json)
		ChatModel:OnAsyncMessage(1, json)
	end
	local json = "{\"funcID\":\"set_yaya_func\"}"
	IOSDispatcher:async_send_to_oc(json,cb_fun)
end