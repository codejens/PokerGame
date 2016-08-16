--腾讯YSDN游戏平台
--PlatformYSDK.lua

PlatformYSDK = {}
--消息类型
PlatformYSDK.MESSAGE_TYPE			= "platform"
--分发类型
PlatformYSDK.FUNC_LOGIN				= "login"		--登录
PlatformYSDK.FUNC_PAY				= "pay"			--支付
PlatformYSDK.FUNC_QUIT        		= "quit"        --退出平台
PlatformYSDK.FUNC_PAY_BACK     		= "pay_back"    --充值返回
PlatformYSDK.FUNC_PAY_NEED_LOGIN    = "pay_need_login"    --充值时 登录状态失效需要玩家重新登录
PlatformYSDK.pay_url 				= "" --支付地址
PlatformYSDK.FUNC_PAY_NEED_LOGIN 	= "pay_need_login"
PlatformYSDK.FUNC_PAY_RESULT		= "pay_result"
PlatformYSDK.FUNC_NOTIC_INFO		= "notic_info"
PlatformYSDK._platform_qq			= 1 	--平台传的1是QQ,2是微信
PlatformYSDK._platform_wx			= 2 	--跟后台定的是1微信,2QQ
PlatformYSDK._task_market_url		= "http://entry.tjxs.m.hoolaigames.com:8099/market/yyb/collect?"
PlatformYSDK.is_sandbox				= "false" 		--是否为沙箱测试环境
PlatformYSDK.extendInfo 			= ""
--充值返回结果信息
PlatformYSDK.pay_resultCode = 
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
PlatformYSDK.pay_family = 
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
PlatformYSDK.login_error = {
	[1005]  = "没有安装QQ或版本过低",
	[2000] 	= "微信没安装",
	[2004] 	= "微信登录失败",

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
function PlatformYSDK:init(callbackfunc)
	self.is_show_tips = false
	self.firstLogin = true
	self.logoutable = true
	self.loginRet = nil
	self.login_type = nil
	self._platform = ""
	self._openId = ""
	self._pf = ""
	self._pfKey = ""
	self._accessToken = ""
	self._payToken = ""
	if callbackfunc then callbackfunc() end
end

function PlatformYSDK:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformYSDK:onEnterGameScene(isEnter)
	if isEnter == true then
		if PlatformYSDK._task_market_url then
		    local function httpPayResponse( error_code, message )
		    	--print("PlatformYSDK:onEnterGameScene返回:::::：error code,message:", error_code,message)
			end

			-- local login_info = RoleModel:get_login_info()
			-- local serverId = login_info.server_id
			-- local param = string.format("MID=%s&serverid=%s&roleId=%s",self._mid,serverId,self._openId)
			-- --print("PlatformYSDK:onEnterGameScene:", PlatformYSDK._task_market_url, param)
			-- HttpRequest.sendPay( PlatformYSDK._task_market_url, param, httpPayResponse )
		end
	else

	end
end

--进入登录状态
function PlatformYSDK:onEnterLoginState(isFirlstLoad)
	RoleModel:show_login_win(GameStateManager:get_game_root())
	-- if self.firstLogin == true then
	-- 	local c = callback:new()
	-- 	c:start(0.1,function() PlatformYSDK:doLogin() end)
	-- 	self.firstLogin = false
	-- end
end

function PlatformYSDK:set_login_type(arg)
	self.login_type = arg
end

--按下登录按钮的回调
function PlatformYSDK:doLogin()
	-- MUtils:toast("PlatformYYB:doLogin", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ]		= PlatformYSDK.FUNC_LOGIN		--分发类型，必传字段
	json_table_temp[ "login_type" ] = self.login_type
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
	self.is_show_tips = true
end

--获取平台登录url
function PlatformYSDK:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformYSDK:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformYSDK:show_logout(callbackfunc)
	callbackfunc()
end

--从选服界面登出
function PlatformYSDK:logoutFromSelectServer(callbackfunc, reason)
	if callbackfunc then
		callbackfunc()
	end
	PlatformYSDK:showPlatformUI(true)
end

-- login 的参数
function PlatformYSDK:get_login_param( account, dbip, server_id )
    local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
 	local str_login_param = "uid="..tostring(self._openId).."&udid="..tostring(udid).."&channel=".."platform_yyb".."&sub_channel=".."platform_yyb".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
  	return str_login_param
end

function PlatformYSDK:get_login_param_json( )
	--print("PlatformYSDK:get_login_param_json self._platform",self._platform)
	local time = os.time()
	local param = ""
	if self._platform == 2 then
		param = "time="..tostring(time).."&sign="..md5("platform_yyb"..tostring(time).."T6G2bymOEzyQj9Ac").."&uid=" .. self._openId .. "&login_type=" .. self._platform .. "&is_sandbox="..self.is_sandbox.."&appid=1105359062&openkey=" .. self._accessToken
	elseif self._platform == 1 then
		param = "time="..tostring(time).."&sign="..md5("platform_yyb"..tostring(time).."65ad7f783312a62a3a47cd64d56385c0").. "&uid=" .. self._openId .. "&login_type=" .. self._platform .. "&is_sandbox="..self.is_sandbox.."&appid=wx49b3ead3b9ce949d&openkey=" .. self._accessToken
	end
	return param
end

-- 获取登录服务器ip
function PlatformYSDK:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	--print("PlatformYSDK:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		--print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformYSDK:getPlatformPayUrl()
	return ""
end

--登出
function PlatformYSDK:logout( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast( LangCommonString[25], 2048 )
end

function PlatformYSDK:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25], 2048 )
end

--无法登入游戏服务器
function PlatformYSDK:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end

-- 上报接口
function PlatformYSDK:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformYSDK:onStartPackage(cbfunc)
	cbfunc()
end


--开始更新
function PlatformYSDK:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformYSDK:onStartGame(cbfunc)
	cbfunc()
end


function PlatformYSDK:init_role_info()
	self:requst_server_about_pay()
end
--初始化登录的服务器信息
function PlatformYSDK:set_server_info( server_info )
	self.loginRet = server_info 
end

function PlatformYSDK:sendMsgToJava(str)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ]		= "println"		--分发类型，必传字段
	json_table_temp[ "print_info" ] = str
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end

--JSON消息接收与处理
function PlatformYSDK:OnAsyncMessage( id, msg )
	--print("PlatformYSDK:OnAsyncMessage",id, msg)
	--过滤掉不是平台返回的信息
	if id ~= AsyncMessageID.eMsgPhoneMessge then 
		return 
	end 
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		if message_type == PlatformYSDK.MESSAGE_TYPE then
			local funcType = jtable[ "funcType" ] or ""
			if funcType == PlatformYSDK.FUNC_LOGIN then
				--登录
				self._openId = jtable["openId"] or "";
				self._pf = jtable["pf"] or "";
				self._pfKey = jtable["pfKey"] or "";
				self._accessToken   = jtable["accessToken"] or ""
				self._payToken = jtable["payToken"] or ""
				self._platform = tonumber(jtable["platform"])
				if self._platform == PlatformYSDK._platform_qq then
					self._platform = 2
				elseif self._platform == PlatformYSDK._platform_wx then
					self._platform = 1
				end
	        	RoleModel:request_server_list_platform()
	        elseif funcType == PlatformYSDK.FUNC_PAY_RESULT then 
	        	--print("PlatformYSDK.FUNC_PAY_RESULT")
	        	--平台充值回调
			    local resultCode = jtable["resultCode"] or "";
			    local payChannel = jtable["payChannel"] or "";
			    local providerState = jtable["providerState"] or "";
			    local saveNum = jtable["saveNum"] or "";
			    local resultMsg	 = jtable["resultMsg"] or "";		        
			    local extendInfo = jtable["extendInfo"] or "";
			    --支付完成时上报参数
			    local phylum = "" --充值成功情况
			    local classfield = "" --原因
			    local family = "" --充值渠道
			    local genus = "ysdk"--安装包名
			    local amount = "元宝"--金额单位
			    local val = saveNum--数量
			   	resultCode = tonumber(resultCode)
			    local pay_result_type = PlatformYSDK.pay_resultCode
			    if resultCode == pay_result_type.PAYRESULT_SERVICE_BIND_FAIL then 
			    	MUtils:toast("游戏初始化绑定service不成功",2048,3)
			    	phylum = "pay_fail"
			    	classfield ="游戏初始化绑定service不成功"
			    elseif resultCode ==pay_result_type.PAYRESULT_ERROR  then 
			    	MUtils:toast("支付流程失败",2048,3)
			    	phylum = "pay_fail"
			    	classfield ="支付流程失败"
			    elseif resultCode ==pay_result_type.PAYRESULT_SUCC  then
			    	local login_info = RoleModel:get_login_info()
					local serverId = login_info.server_id
					local player = EntityManager:get_player_avatar()
					local key = "pay" .. serverId .. player.id
			    	GlobalFunc:create_screen_notic("支付成功")
			    	--print("支付流程成功")
			    	phylum = "pay_success"
			    	classfield ="支付流程成功"
			    	--sdk返回渠道 号 转化为 字符串
			    	--转化规则参考腾讯支付插件2.3.8c白皮书中2.7.2
			    	local str = string.format("%d",payChannel)
			    	family = PlatformYSDK.pay_family[str]
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

			elseif funcType ==  PlatformYSDK.FUNC_PAY_NEED_LOGIN then 
				--登录失效。需要重新登录
				-- ZXLog("登录失效。需要重新登录")
				GameStateManager:back_to_login()
			elseif funcType == PlatformYSDK.FUNC_NOTIC_INFO then
				local notic_type = jtable["msg"]
				notic_type = tonumber(notic_type)
				if not self.is_show_tips then
					return
				end
				if PlatformYSDK.login_error[notic_type] then
					RoleModel:show_notice(PlatformYSDK.login_error[notic_type])
				else
					RoleModel:show_notice("请重新登录游戏")
				end
				self.is_show_tips = false
			end
		end
	end
end
--与服务器通信，通知支付情况
function PlatformYSDK:requst_server_about_pay()
	--print("与服务器通信，通知支付情况")
	 -- 请求回调

	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local player = EntityManager:get_player_avatar()
	local key = "pay" .. serverId .. player.id
	local extendInfo = ""
	if self.extendInfo ~= "" then
		extendInfo = self.extendInfo 
	else
		extendInfo = CCUserDefault:sharedUserDefault():getStringForKey(key) or ""
	end
	local max_request = 4 -- 最大请求次数
	local current_request = 0 --当前请求次数
	local param = ""
    local function httpPayResponse( error_code, message )
    	-- ZXLog("请求服务器列表返回:::::：error code:", error_code)
    	-- ZXLog(string.format("支付完成时请求服务器列表返回:::::：%s", message))
    	-- self:sendMsgToJava("error_code:" .. error_code)
		if error_code == 0 then
			-- MUtils:lockScreen(false,2048)
            require 'json/json'
            local jtable = {}
			local s,e = pcall(function()
				jtable = json.decode(message)
			end)
            local resulst_code = tonumber(jtable['ret']) or -1    -- 1：操作成功
            -- self:sendMsgToJava("message:" .. message)
            if resulst_code == 1 then 
            	MUtils:toast( "发货成功!", 2048 )
            	CCUserDefault:sharedUserDefault():setStringForKey(key, "")
            	CCUserDefault:sharedUserDefault():flush()
            	self.extendInfo = ""
            	--ZXLog("发货成功!")
            elseif resulst_code == -1 then 
            	-- ZXLog("参数错误")       
            	-- MUtils:toast( "参数错误!", 2048 )        
            elseif resulst_code == -2 then 

            elseif resulst_code == -4 then 
            	--ZXLog("余额不足")     
            	CCUserDefault:sharedUserDefault():setStringForKey(key, "")
            	CCUserDefault:sharedUserDefault():flush()
            	self.extendInfo = ""
            end
        else
        	if current_request <= max_request and param ~= "" then 
        		HttpRequest.sendPay( url, param, httpPayResponse )
        		current_request = current_request+1
        	else
        		MUtils:toast( LangCommonString[65] .. tostring( error_code ), 2048, 5 ) -- [65]="连接支付服务器失败:错误码[" -- [66]="]
        	end 
        	
		end
	end
	local pay_url = UpdateManager.yuliu_str or ""

	local if_correct = false
	-- 避免文件乱码,对查找到的值判断是否合法
	if extendInfo then
		if_correct = string.find(extendInfo, "product_id")
	end
	-- 没有该值 或 该值为空、不合法均发默认数值
	if not extendInfo or extendInfo == "" or not if_correct then
		extendInfo = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(serverId)..",product_id:0"
	end

	param = self:get_pay_result_param(extendInfo)
	local http_request = HttpRequest:new(pay_url, param, httpPayResponse)
	http_request:send()	
	current_request = current_request+1	
end

--平台返回支付结果后 跟服务器通信 参数
function PlatformYSDK:get_pay_result_param(extendInfo)

	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local openKey = self._accessToken
	if self._platform == 2 then
		openKey = self._payToken
	end
	local resulst_param = string.format("is_sandbox=%s&login_type=%s&openid=%s&openkey=%s&pf=%s&pfkey=%s&zoneid=1&ts=%s&extend=%s",
		  self.is_sandbox,self._platform,self._openId, openKey, self._pf,self._pfKey, os.time(), extendInfo)

	return resulst_param
end 
-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformYSDK:get_servlist_param(  )
	--channel_id=1&uid=2049379297&sessionid=F89E100A3E2BED00DD12FA239281F85B
	--参数中的"channel_id=1001"是规定写死的
	local param = 'channel_id=1001'.."&openid=".._openId
	return param
end

--打开支付窗口
function PlatformYSDK:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	payWin:setDisable(true)
	payWin:setCallback(function(which)
		if UpdateManager.msdk_pay_type ~= "hoolai" then
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end
	end)
end

function PlatformYSDK:get_pay_log(  )
	--userid --kingdom(充值面板是否拉起 或者 关闭充值 ) --phylum(是否成功，此处为默认成功)--
	local param = "userid= "..self._openId.."&kingdom=".."open_pay".."&phylum=".."success"
	return param
end

--支付
function PlatformYSDK:payUICallback( info )
	local player = EntityManager:get_player_avatar()
	local item_id  = info.item_id

	--获取需要的支付内容，先去请求支付下单
	--local login_info = RoleModel:get_login_info()
	local login_info = RoleModel:get_login_info()
	local serverId = login_info.server_id
	local json_table_temp = {}
	local player = EntityManager:get_player_avatar()
	local roleName = player.name
	self.extendInfo = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(serverId)..",product_id:"..tostring(info.item_index)
	json_table_temp[ "message_type" ]	= PlatformYSDK.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYSDK.FUNC_PAY              --分发类型，必传字段
	json_table_temp[ "serverid" ] = "1"
	json_table_temp[ "price"] = item_id*10
	json_table_temp[ "extendInfo"] = "ysdkExt"
	json_table_temp[ "canChange" ] = false 	 -- 是否可以改变充值数量
	CCUserDefault:sharedUserDefault():setStringForKey(key, self.extendInfo)
	CCUserDefault:sharedUserDefault():flush()
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformYSDK:getLoginRet(  )
	return nil
end

function PlatformYSDK:getPayInfo()
	require "../data/chong_zhi_config"
	local temp_info = ChongZhiConfig:get_chong_zhi_info()
	return temp_info.normal
end

function PlatformYSDK:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformYSDK:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformYSDK:share(info)

end

function PlatformYSDK:setLoginRet(uid,psw)
	
end

-- 打开用户中心
function PlatformYSDK:open_user_center()
	
end

function PlatformYSDK:onLoginResult( err, data )
	-- body
end
