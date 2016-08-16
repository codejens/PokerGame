--create by jiangjinhong 
--腾讯MSDN游戏平台
--PlatformMSDK.lua

PlatformMSDK = {}
--消息类型
PlatformMSDK.MESSAGE_TYPE			= "platform"
--分发类型
PlatformMSDK.FUNC_LOGIN				= "login"		--登录
PlatformMSDK.FUNC_PAY				= "pay"			--支付
PlatformMSDK.FUNC_HL_PAY			= "hl_pay"			--hoolai支付
PlatformMSDK.FUNC_QUIT        		= "quit"        --退出平台
PlatformMSDK.FUNC_PAY_BACK     		= "pay_back"    --充值返回
PlatformMSDK.FUNC_PAY_NEED_LOGIN    = "pay_need_login"    --充值时 登录状态失效需要玩家重新登录
PlatformMSDK.pay_url 				= "http://119.29.53.102/msdk/SD_yyb" --支付地址
PlatformMSDK.FUNC_BIND_PAY_SERVICE 	= "bind_pay_service"
PlatformMSDK.FUNC_REMOVE_PAY_ERVICE = "remove_pay_ervice"
PlatformMSDK.FUNC_PAY_NEED_LOGIN 	= "pay_need_login"
PlatformMSDK.FUNC_PAY_RESULT		= "pay_result"
PlatformMSDK.FUNC_NOTIC_INFO		= "notic_info"
PlatformMSDK.FUNC_REC_MID			= "sendMid"
PlatformMSDK.FUNC_GET_MID			= "getMid"
PlatformMSDK.FUNC_USER_INFO 		= "userInfo"
PlatformMSDK._platform_qq			= 2
PlatformMSDK._platform_wx			= 1
PlatformMSDK._task_market_url		= "http://entry.tjxs.m.hoolaigames.com:8099/market/yyb/collect?"

--充值返回结果信息
PlatformMSDK.pay_resultCode = 
{	
	--说明游戏初始化绑定service不成功
	PAYRESULT_SERVICE_BIND_FAIL =-2,
	--支付流程失败
	PAYRESULT_ERROR = -1,
	--支付流程成功
	PAYRESULT_SUCC = 0,
	--用户取消
	PAYRESULT_CANCEL = 2,
	--参数错误
	PAYRESULT_PARAMERROR = 3,
}
PlatformMSDK.pay_family = 
{
	['-1'] = "不知道什么渠道",
	['0'] = "Q点渠道",
	['1'] = "财付通",
	['2'] = "银行卡快捷支付",
	['3'] = "payChannel=3(文档没有标注什么渠道)",
	['4'] = "Q卡渠道",
	['5'] = "手机充值卡渠道",
	['7'] = "元宝渠道",
	['8'] = "微信支付渠道",
	['9'] = "话费渠道",
	['10'] = "金券渠道",
	['11'] = "Q币渠道",

}
PlatformMSDK.login_error = {
	[2000] = "微信没安装",
	[2004] = "微信登录失败",

}

-- local _platform = ""
-- local _openId  = ""
-- local _pf      = ""
-- local _pfKey   =  ""
-- local _qqAccessToken = ""
-- local _qqPayToken = ""
-- local _wxAccessToken = ""
-- local _wxRefreshToken = ""
	--初始化
function PlatformMSDK:init(callbackfunc)
	self.firstLogin = true
	self.logoutable = true
	self.loginRet = nil
	self.login_type = nil
	self._platform = ""
	self._openId = ""
	self._pf = ""
	self._pfKey = ""
	self._qqAccessToken = ""
	self._qqAccessToken = ""
	self._wxAccessToken = ""
	self._wxRefreshToken = ""
	if callbackfunc then callbackfunc() end
end

function PlatformMSDK:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformMSDK:onEnterGameScene(isEnter)
	if isEnter == true then
		if PlatformMSDK._task_market_url then
		    local function httpPayResponse( error_code, message )
		    	--print("PlatformMSDK:onEnterGameScene返回:::::：error code,message:", error_code,message)
			end

			local login_info = RoleModel:get_login_info()
			local serverId = login_info.server_id
			local param = string.format("MID=%s&serverid=%s&roleId=%s",self._mid,serverId,self._openId)
			--print("PlatformMSDK:onEnterGameScene:", PlatformMSDK._task_market_url, param)
			HttpRequest.sendPay( PlatformMSDK._task_market_url, param, httpPayResponse )
		end
	else

	end
end

--进入登录状态
function PlatformMSDK:onEnterLoginState(isFirlstLoad)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	RoleModel:change_login_page( "loginSDK" )
	self.loginRet = nil
	-- if self.firstLogin == true then
	-- 	local c = callback:new()
	-- 	c:start(0.1,function() PlatformMSDK:doLogin() end)
	-- 	self.firstLogin = false
	-- end
end

function PlatformMSDK:set_login_type(arg)
	self.login_type = arg
end

--按下登录按钮的回调
function PlatformMSDK:doLogin()
	-- MUtils:toast("PlatformYYB:doLogin", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformMSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ]		= PlatformMSDK.FUNC_LOGIN		--分发类型，必传字段
	json_table_temp[ "login_type" ] = self.login_type
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)

	local json_table_temp_s = {}
	json_table_temp_s[ "message_type" ]	= PlatformMSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp_s[ "function_type" ]		= PlatformMSDK.FUNC_GET_MID		--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp_s )
	send_message_to_java(jcode)

end

--获取平台登录url
function PlatformMSDK:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformMSDK:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformMSDK:show_logout(callbackfunc)
	callbackfunc()
end

--从选服界面登出
function PlatformMSDK:logoutFromSelectServer(callbackfunc, reason)
	if callbackfunc then
		callbackfunc()
	end
	PlatformMSDK:showPlatformUI(true)
end

-- login 的参数
function PlatformMSDK:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformMSDK:get_login_param_json( )
	--print("PlatformMSDK:get_login_param_json self._platform",self._platform)
	if self._platform == "qq" then
		return "openid=" .. self._openId .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
	elseif self._platform == "wx" then
		return "openid=" .. self._openId .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
	else
		return "token=" .. "" .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
	end
end

-- 获取登录服务器ip
function PlatformMSDK:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	--print("PlatformMSDK:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		--print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformMSDK:getPlatformPayUrl()
	return ""
end

--登出
function PlatformMSDK:logout( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast( LangCommonString[25], 2048 )
end

function PlatformMSDK:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25], 2048 )
end

--无法登入游戏服务器
function PlatformMSDK:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end

-- 上报接口
function PlatformMSDK:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformMSDK:onStartPackage(cbfunc)
	cbfunc()
end


--开始更新
function PlatformMSDK:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformMSDK:onStartGame(cbfunc)
	cbfunc()
end


function PlatformMSDK:init_role_info()
	self:requst_server_about_pay()
end
--初始化登录的服务器信息
function PlatformMSDK:set_server_info( server_info )
	self.loginRet = server_info 
end
--JSON消息接收与处理
function PlatformMSDK:OnAsyncMessage( id, msg )
	--print("PlatformMSDK:OnAsyncMessage",id, msg)
	--过滤掉不是平台返回的信息
	if id ~= AsyncMessageID.eMsgPhoneMessge then 
		return 
	end 
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		if message_type == PlatformMSDK.MESSAGE_TYPE then
			local funcType = jtable[ "funcType" ] or ""
			if funcType == PlatformMSDK.FUNC_LOGIN then
				--登录
				self._openId = jtable["openId"] or "";
				self._pf = jtable["pf"] or "";
				self._pfKey = jtable["pfKey"] or "";
				self._wxAccessToken   = jtable["wxAccessToken"] or ""
				self._wxRefreshToken = jtable["wxRefreshToken"] or ""
				self._qqAccessToken = jtable["qqAccessToken"] or ""
				self._qqPayToken = jtable["qqPayToken"] or ""
				self._platform = tonumber(jtable["platform"])
				if self._platform == PlatformMSDK._platform_qq then
					self._platform = "qq"
				elseif self._platform == PlatformMSDK._platform_wx then
					self._platform = "wx"
				end
	        	RoleModel:request_server_list_platform()
	        elseif funcType == PlatformMSDK.FUNC_PAY_RESULT then 
	        	--print("PlatformMSDK.FUNC_PAY_RESULT")
	        	--平台充值回调
			    local resultCode = jtable["resultCode"] or "";
			    local payChannel = jtable["payChannel"] or "";
			    local payState = jtable["payState"] or "";
			    local providerState = jtable["providerState"] or "";
			    local saveNum = jtable["saveNum"] or "";
			    local resultMsg	 = jtable["resultMsg"] or "";		        
			    local extendInfo = jtable["extendInfo"] or "";
			    --支付完成时上报参数
			    local phylum = "" --充值成功情况
			    local classfield = "" --原因
			    local family = "" --充值渠道
			    local genus = "msdk"--安装包名
			    local amount = "元宝"--金额单位
			    local val = saveNum--数量
			    local userid = self:getUserRet()

			   
			    local pay_result_type = PlatformMSDK.pay_resultCode
			    if resultCode == pay_result_type.PAYRESULT_SERVICE_BIND_FAIL then 
			    	MUtils:toast("游戏初始化绑定service不成功",2048,3)
			    	phylum = "pay_fail"
			    	classfield ="游戏初始化绑定service不成功"
			    elseif resultCode ==pay_result_type.PAYRESULT_ERROR  then 
			    	MUtils:toast("支付流程失败",2048,3)
			    	phylum = "pay_fail"
			    	classfield ="支付流程失败"
			    elseif resultCode ==pay_result_type.PAYRESULT_SUCC  then
			    	--print("支付流程成功")
			    	phylum = "pay_success"
			    	classfield ="支付流程成功"
			    	--sdk返回渠道 号 转化为 字符串
			    	--转化规则参考腾讯支付插件2.3.8c白皮书中2.7.2
			    	local str = string.format("%d",payChannel)
			    	family = PlatformMSDK.pay_family[str]
			    	-- ZXLog("渠道-------------------：",family)
			    	self:requst_server_about_pay()
			    elseif resultCode ==pay_result_type.PAYRESULT_CANCEL  then
			    	classfield ="取消支付"
			    	phylum = "pay_fail"
			    	MUtils:toast( LangCommonString[60], 2048, 3 ) -- [60]="取消支付"
			    elseif resultCode ==pay_result_type.PAYRESULT_PARAMERROR then 
			    	--print("参数错误")
			    	phylum = "pay_fail"
			    	classfield ="参数错误"
			    end

			elseif funcType ==  PlatformMSDK.FUNC_PAY_NEED_LOGIN then 
				--登录失效。需要重新登录
				-- ZXLog("登录失效。需要重新登录")
				GameStateManager:back_to_login()
			elseif funcType == PlatformMSDK.FUNC_NOTIC_INFO then
				local notic_type = jtable["msg"]
				notic_type = tonumber(notic_type)
				if PlatformMSDK.login_error[notic_type] then
					MUtils:toast( PlatformMSDK.login_error[notic_type], 2048 )
				else
					-- MUtils:toast( tostring(notic_type), 2048 )
				end
			elseif funcType == PlatformMSDK.FUNC_REC_MID then
				self._mid = jtable["mid"]
			end
		end
	end
end
--与服务器通信，通知支付情况
function PlatformMSDK:requst_server_about_pay()
	--print("与服务器通信，通知支付情况")
	 -- 请求回调
	local max_request = 4 -- 最大请求次数
	local current_request = 0 --当前请求次数
    local function httpPayResponse( error_code, message )
    	-- ZXLog("请求服务器列表返回:::::：error code:", error_code)
    	-- ZXLog(string.format("支付完成时请求服务器列表返回:::::：%s", message))
		if error_code == 0 then
			MUtils:lockScreen(false,2048)
            require 'json/json'
            local jtable = {}
			local s,e = pcall(function()
				jtable = json.decode(message)
			end)
            local resulst_code = jtable['ret']    -- 0：操作成功 -1：其他错误 -2：余额不足
            if resulst_code == "0" then 
            	MUtils:toast( "发货成功!", 2048 )
            	--ZXLog("发货成功!")
            elseif resulst_code == "-1" then 
            	-- ZXLog("参数错误")       
            	MUtils:toast( "参数错误!", 2048 )        
            elseif resulst_code == "-2" then 
            	--ZXLog("余额不足")     
            	MUtils:toast( "余额不足!", 2048 )      	
            end
        else
        	if current_request <= max_request then 
        		HttpRequest.sendPay( url, param, httpPayResponse )
        		current_request = current_request+1
        	else
        		MUtils:toast( LangCommonString[65] .. tostring( error_code ), 2048, 5 ) -- [65]="连接支付服务器失败:错误码[" -- [66]="]
        	end 
        	
		end
	end
	local url = PlatformMSDK.pay_url.."/change"
	local param = self:get_pay_result_param()
	--print("PlatformMSDK:requst_server_about_pay:", url, param)
	HttpRequest.sendPay( url, param, httpPayResponse )
	current_request = current_request+1
end

--平台返回支付结果后 跟服务器通信 参数
function PlatformMSDK:get_pay_result_param()
	--服务器需要参数
	-- openid,openkey,pf,pay_token,pfkey,server
	--local login_info = RoleModel:get_login_info()
	--ZXLog("")
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local open_id, access_token, pf, pf_key, pay_token, tplatform = self:getUserRet()
	--ZXLog("当前登录的服务器id:",serverid)
	if tplatform == "wx" then
		tplatform = "weixin" 
	end
	local resulst_param = string.format("openid=%s&openkey=%s&pf=%s&pay_token=%s&pfkey=%s&serverid=%s&platform=%s",
		  open_id, access_token, pf, pay_token, pf_key, serverId, tplatform)
		-- ZXLog("请求服务器参数：",resulst_param)
	return resulst_param
end 
-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformMSDK:get_servlist_param(  )
	--channel_id=1&uid=2049379297&sessionid=F89E100A3E2BED00DD12FA239281F85B
	--参数中的"channel_id=1001"是规定写死的
	local param = 'channel_id=1001'.."&openid=".._openId
	return param
end

--打开支付窗口
function PlatformMSDK:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	payWin:setDisable(true)
	payWin:setCallback(function(which)
		if UpdateManager.msdk_pay_type ~= "hoolai" then
			self:payUICallback({ item_id = which, window = 'pay_win' })
		else
			self:payUICallback2({ item_id = which, window = 'pay_win' })
		end
	end)
end

function PlatformMSDK:get_pay_log(  )
	--userid --kingdom(充值面板是否拉起 或者 关闭充值 ) --phylum(是否成功，此处为默认成功)--
	local open_id, access_token, pf, pf_key, pay_token = self:getUserRet()
	local param = "userid= "..open_id.."&kingdom=".."open_pay".."&phylum=".."success"
	return param
end

--支付
function PlatformMSDK:payUICallback( info )
	if UpdateManager.msdk_pay_type == "hoolai" then
		return self:payUICallback2(info)
	end
	local item_id  = info.item_id
	-- local function http_callback( error_code, message )
	-- 	RoleModel:set_lock_operate( false )
	-- 	if error_code == 0 then
	-- 		MUtils:lockScreen(false,2048)
 --            require 'json/json'
 --            local jtable = {}
	-- 		local s,e = pcall(function()
	-- 			jtable = json.decode(message)
	-- 		end)
 --            local resulst_code = jtable['ret']    -- 0：操作成功 -1：其他错误 -2：余额不足
 --            if resulst_code == "0" then 
 --            	-- ZXLog("发送玩家支付log给后台成功")
 --            end
 --        end 
	-- end
	-- --通知后台玩家点击了充值按钮
	-- local url = PlatformMSDK.pay_url.."/pay_log"
	-- local param = self:get_pay_log()
	-- local http_request = HttpRequest:new( url, param, http_callback )
	-- http_request:send()

	--获取需要的支付内容，先去请求支付下单
	--local login_info = RoleModel:get_login_info()
	local open_id, access_token, pf, pf_key, pay_token, tplatform = self:getUserRet()	
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local json_table_temp = {}
	local player = EntityManager:get_player_avatar()
	local roleName = player.name
	json_table_temp[ "message_type" ]	= PlatformMSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformMSDK.FUNC_PAY              --分发类型，必传字段
	json_table_temp[ "openid" ] = open_id 
	json_table_temp[ "access_token" ] = access_token
	json_table_temp[ "pf" ] = pf
	json_table_temp[ "pay_token" ] = pay_token
	json_table_temp[ "serverid" ] = serverid	
	json_table_temp[ "pf_key" ] = pf_key	
	json_table_temp[ "serverid"] = "1"
	json_table_temp[ "price"] = item_id
	json_table_temp[ "platform" ] = tplatform
	json_table_temp[ "roleName" ] = roleName
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--支付2 胡莱支付
function PlatformMSDK:payUICallback2( info )
	local item_id  = info.item_id
	local player 	= EntityManager:get_player_avatar()
	local _userId   = player.id
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local _uid = login_info.user_name

	local _callBackInfo = "lion_" .. _uid .. "_" .. serverId .. "_" .. os.time()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformMSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformMSDK.FUNC_HL_PAY              --分发类型，必传字段

	json_table_temp[ "userId"] = _userId
	json_table_temp[ "itemName"] = string.format("%d元宝", item_id)
	json_table_temp[ "amount"] = item_id * 10
	json_table_temp[ "callBackInfo"] = _callBackInfo
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformMSDK:showPlatformUI( bFlag )
	--PlatformUILoginWin:show( bFlag )
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	if bFlag then
		RoleModel:change_login_page( "loginSDK" )
	end
end

function PlatformMSDK:getLoginRet(  )
	return nil
end
function PlatformMSDK:getUserRet()
	local open_id, access_token, pf, pf_key, pay_token, tplatform 
	open_id = self._openId
	if self._platform == "qq" then
		access_token = self._qqAccessToken
		pay_token = self._qqPayToken
	elseif self._platform == "wx" then
		access_token = self._wxAccessToken
		pay_token = self._wxAccessToken
	else 
		access_token = ""
	end
	pf = self._pf
	pf_key = self._pfKey
	tplatform = self._platform
	--print("订单信息：", open_id, access_token, pf, pf_key, pay_token, tplatform )
	return open_id, access_token, pf, pf_key, pay_token, tplatform
end

function PlatformMSDK:userInfo()
	local serverName = RoleModel:get_server_name_had_login(  )
	local player = EntityManager:get_player_avatar()
	local level = player.level
	local open_id, access_token, pf, pf_key, pay_token, tplatform = self:getUserRet()	
	local account = open_id
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformMSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformMSDK.FUNC_USER_INFO              --分发类型，必传字段
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "account"] = account
	json_table_temp[ "level"] = level
	require 'json/json'
	local jcode = json.encode( json_table_temp )	
end

function PlatformMSDK:getPayInfo()
	require "../data/chong_zhi_config"
	local temp_info = ChongZhiConfig:get_chong_zhi_info()
	return temp_info.msdk
end

function PlatformMSDK:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformMSDK:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformMSDK:share(info)

end

function PlatformMSDK:setLoginRet(uid,psw)
	
end

-- 打开用户中心
function PlatformMSDK:open_user_center()
	
end

function PlatformMSDK:onLoginResult( err, data )
	-- body
end
