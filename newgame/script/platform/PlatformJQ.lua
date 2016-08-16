PlatformJQ= {}

PlatformJQ.MESSAGE_TYPE	= "platform"

PlatformJQ.FUNC_LOGIN   = "login"		--登录
PlatformJQ.FUNC_PAY		= "pay"			--支付

PlatformJQ.FUNC_TAB		= "tab"			--切换账号
PlatformJQ.FUNC_QUIT 	= "quit" 		--退出
PlatformJQ.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformJQ.FUNC_ENTERGAME	= "enter_game" --进入游戏
PlatformJQ.FUNC_LEVELUP	= "level_up" --人物升级
PlatformJQ.CODE_SUCCESS = 0

PlatformJQ.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformJQ.STATE_LOGIN_FAIL = 1	-- 失败

PlatformJQ.STATE_LOGIN_CANCLE = 2	-- 失败



-- 不准许有全局参数，因为需要被reload

--

--


function PlatformJQ:init()
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
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>U9")
	self.AppId = ''
	self.channel = ""
	self.plat = ""
	self.uuid = ""
	self.subchannel = ""
	self.platform_flag = "platform_jiqu"
end


--进入游戏后
function PlatformJQ:init_role_info()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local vip_info = VIPModel:get_vip_info()
	local vip_level = 1
	if vip_info then
		vip_level = vip_info.level or 1
	end
	local roleId = player.id or "1" 	--user_name 就是uid
	local roleName = player.name or "1"
    local serverId = server_info.server_id or 1
    local serverName = server_info.server_name or "1"
    local roleLevel = player.level or 1
    local money = player.yuanbao or 0
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformJQ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformJQ.FUNC_ENTERGAME
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel"] = roleLevel
	json_table_temp[ "zoneId" ] = serverId
	json_table_temp[ "zoneName"] = serverName
	json_table_temp[ "balance"] = money
	json_table_temp[ "roleVip"] = vip_level
	require 'json/json'
	Utils:print_table(json_table_temp)
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--人物升级调用
function PlatformJQ:onPlayerLevelUp()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = player.id or "1" 	--user_name 就是uid
	local roleName = player.name or "1"
    local serverId = server_info.server_id or 1
    local serverName = server_info.server_name or "1"
    local roleLevel = player.level or 1
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformJQ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformJQ.FUNC_LEVELUP
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel"] = roleLevel
	json_table_temp[ "zoneId" ] = serverId
	json_table_temp[ "zoneName"] = serverName
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
-- login 的参数

function PlatformJQ:get_login_param( account, dbip, server_id )
	local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
 	local str_login_param = "uid="..tostring(self.uid).."&udid="..tostring(udid).."&channel=".."platform_jiqu".."&sub_channel=".."platform_jiqu".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
  	print("login,str_login_param=",str_login_param)
  	return str_login_param
end

function PlatformJQ:get_login_param_json( )
    local time = os.time()
   	local str_login_param = "uid=" .. self.token .. "&token="..self.token.."&time="..tostring(time).."&sign="..md5("platform_jiqu"..tostring(time).."46c8f27217fe063e4cd72a9e7b9a808a")
   	print("get_serverlist str_login_param=",str_login_param)
   	return str_login_param
end
-- 获取登录服务器ip

function PlatformJQ:platfotm_set_uid(uid)
	self.uid = uid
	self.token = uid
end

function PlatformJQ:OnAsyncMessage( id, msg )

	require 'json/json'
	-- print("PlatformJQ:OnAsyncMessage >>>>>>>>>>>")
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	local message_type = jtable[ "message_type" ] or ""
	if message_type == self.MESSAGE_TYPE then
		local func_type = jtable[ "funcType" ] or ""
		local error_code = jtable[ "error_code" ] or self.CODE_FAIL
		if func_type == self.FUNC_LOGIN then -- 登录
			if error_code == self.CODE_SUCCESS then
				self.token = jtable["token"]
				local memory = jtable["memory"]
				RoleModel:set_phone_memory(memory)
				print("memory=",memory)
				RoleModel:request_server_list_platform()
				self.platform_flag = "platform_jiqu"
			else
				--登录失败
				print("登录失败")
				self:try_login()
			end
		elseif func_type == self.FUNC_LOGIN_OUT then --切换账号
			--这里调退出游戏
			local function logout_callback()
				if GameStateManager:get_state() == "scene" then 
					MenusPanel:use_all_equip_tip( )
					--AudioManager:stopBackgroundMusic(true)
					-- print_zengsi("zengsi 返回登录中。。。。。。。。。。。。。。。。。。。。。。。。。。")
					MiscCC:send_quit_server()
				end
				GameStateManager:set_state("login")
			end
			-- print_zengsi("zengsi PlatformJQ:logout(logout_callback)。。。。。。。。。。。。。。。。。。。。。。。。。。")
			-- PlatformJQ:logout(logout_callback)
			logout_callback()
		elseif func_type == self.FUNC_QUIT then
			if error_code == 0 then
				ZXGameQuit()
			elseif error_code == 1 then
				QuitGame()
			end
		end
	else
	
	end
	return false;
end

--子渠道号
function PlatformJQ:getDownloadChannel()
	return self.platform_flag--self.subchannel
end

--平台
function PlatformJQ:getDownloadFrom()
	-- return self.channel
	return self.platform_flag
end

function PlatformJQ:get_cache_url()
	local temp_url_font = CCAppConfig:sharedAppConfig():getStringForKey('develop_cache_url')
	UpdateManager.cache_url = UpdateManager.cache_url or temp_url_font .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
	return UpdateManager.cache_url

end

function PlatformJQ:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformJQ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformJQ.FUNC_QUIT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformJQ:get_package_url()

	return UpdateManager.package_url-- .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')

end

--平台主动行为封装 Begin
--支付
function PlatformJQ:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
	if payWin == nil then 
	   return
	end
	--paywin里直接调用payUICallback
	-- payWin:setCallback(function(which)
	-- 		self:payUICallback({ item_id = which, window = 'pay_win' })
	-- 	end)
end

function PlatformJQ:payUICallback(info)
	local _money_rate = 10
    -- local user_account = RoleModel:get_login_info().user_name
    local player = EntityManager:get_player_avatar()
    local game_money  = info.item_id 		--元宝数量
    local player = EntityManager:get_player_avatar()

	local _userId   = player.id

	local _serverId = RoleModel:get_login_info().server_id
	local send_java_callback = nil

	--http://sync.1sdk.cn/cb/wdj/5AE844609915FAEB/sync.html
	-- local cporderid = self.platform_flag .. self.uid .."_".._serverId .."_".. os.time()
	-- local extra = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index) ..",channel:" .. self.platform_flag 
	-- local transid = nil
	-- ZXLog(LangModelString[441], url , "param:", param) -- [441]="（平台公用）请求服务器列表： url: "
	
	-- 请求回调
	-- local function http_callback(error_code, message)
	-- 	ZXLog("请求充值返回:::::：error code:", error_code)
	-- 	ZXLog(string.format("请求充值返回:::::：content: >>%s<<", message))
	-- 	if error_code == 0 then
	-- 		require 'json/json'
	-- 		local jtable = {}
	-- 		local s,e = pcall(function()
	-- 			jtable = json.decode(message)
	-- 		end)
	-- 		if not s then 
	-- 			return 
	-- 		end
	-- 		local resulst_code = jtable['ret']								   -- 0：操作失败   1：操作成功   -1：其他错误
	-- 		transid = jtable['transid']
	-- 		print("transidtransidtransidtransidtransid=",transid)
	-- 		if resulst_code == "1" then 
	-- 			send_java_callback()
	-- 		elseif resulst_code == 1 then
	-- 		elseif resulst_code == "0" then
	-- 		else
	-- 		end
	-- 		--清空自动重试
	-- 		setupHttpAutoReconnect()
	-- 	else
	-- 		MUtils:lockScreen(false,2048)
	-- 		if not doHttpAutoReconnect() then
	-- 			ZXLog("http失败!!!")
	-- 	   	end
	-- 	end
	-- end

	-- RoleModel:set_lock_operate(true)		 -- 锁住，在http响应钱不能做任何操作
	local waresid = info.item_index
	local url   = UpdateManager.order_url
	local cporderids = "platform_jiqu" ..self.uid.."_".._serverId .."_".. os.time()
	local extra = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index)..",channel:" .. "platform_jiqu"
	-- "userLevel." .. player.level .. "|roleId." .. player.id.."|serverId."..tostring(_serverId).."|productId."..tostring(info.item_index) 
	local param = "waresid=" .. waresid .. "&cporderid=" .. cporderids .. "&price=" .. game_money .. "&appuserid=" .. self.uid .. "&cpprivateinfo=" .. extra .. "&notifyurl=" .. UpdateManager.yuliu_str
	--print("param=", param)


	send_java_callback = function()	
			function_type = PlatformJQ.FUNC_PAY
		local product_name = game_money*_money_rate
		local money_name = "元宝"
		if info.item_index == 20 then --月卡   remain=0的时候，商品名字前面就不会被加上价格
			money_name = "福利月卡"
			product_name= ""
		elseif info.item_index == 21 then
			money_name = "至尊月卡"
			product_name = ""
		end
		product_name = product_name .. money_name
		local json_table_temp = {}
		json_table_temp["message_type"] 	= PlatformJQ.MESSAGE_TYPE 				--消息类型
		json_table_temp["function_type"] 	= function_type 						--支付接口类型
		-- json_table_temp["money_name"] 		= money_name 							--道具名称
		json_table_temp["money"] 			= game_money 							--充值或支付金额（现实货币），单位为 分
		-- json_table_temp["count"] 			= 1 									--数量
		json_table_temp["item_id"] 			= info.item_index 						--商品唯一标识id
		json_table_temp["order_title"] 		= product_name							--商品名称
		json_table_temp["extra"] 			= extra 								--扩展参数
		json_table_temp["cp_orderId"] 		= cporderids 								--
		-- json_table_temp["remain"] 			= remain 								--比例
		-- json_table_temp["pay_url"] 			= UpdateManager.yuliu_str or ""
		Utils:print_table(json_table_temp)
		require 'json/json'
		local jcode = json.encode( json_table_temp )
		send_message_to_java( jcode )
	end
	send_java_callback()
	-- print("PlatformJQ:payUICallback url,param",url,param)
	-- local http_request = HttpRequest:new(url, param, http_callback)
	-- http_request:send()	
end

function PlatformJQ:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformJQ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformJQ.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformJQ:getLoginRet()
	return self.uid, self.token
end

function PlatformJQ:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.normal
end

--------------------------------------

--unused function

--HJH 2014-11-27

--写这个架构的人没想清楚，怎么会有下面这些函数

function PlatformJQ:share(info)
end

function PlatformJQ:setLoginRet(uid,psw)
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformJQ:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformJQ:open_user_center()
end

function PlatformJQ:onLoginResult( err, data )
	PlatformInterface:onEnterLoginState()
end

--加个列表 很多平台切换账号不能再调用登录

--进入登录状态
-- function PlatformJQ:onEnterLoginState()
-- 	RoleModel:show_login_win(GameStateManager:get_game_root())
-- 	if self.platform_name ~= "le" then
-- 		local c = callback:new()
-- 		c:start(0.1, function()
-- 			PlatformInterface:doLogin()
-- 		end)
-- 	else
-- 		if self.login_out then
-- 			self.login_out = false
-- 		else
-- 			local c = callback:new()
-- 			c:start(0.1, function()
-- 				PlatformInterface:doLogin()
-- 			end)
-- 		end
-- 	end
-- end

--登出
function PlatformJQ:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end

	local json_table_temp = {}
	json_table_temp[ "message_type" ] = "platform" --消息类型，必传字段
	json_table_temp[ "function_type" ] = "login_out"
	require 'json/json'
	local jcode = json.encode(json_table_temp)
	send_message_to_java(jcode)	
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
	self.login_out = true
	--GameStateManager:set_state("login")
end



-- function PlatformJQ:set_uid(uid)
-- 	self.uid = uid
-- 	self.code =uid
-- end