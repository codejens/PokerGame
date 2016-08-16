PlatformYJ= {}

PlatformYJ.MESSAGE_TYPE	= "platform"

PlatformYJ.FUNC_CHANGE_ACCOUNT = "change_account"

PlatformYJ.FUNC_LOGIN		= "login"		--登录
PlatformYJ.FUNC_CHARGE  = "charge" 		--支付扩展接口
PlatformYJ.FUNC_PAY		= "pay"			--支付
PlatformYJ.FUNC_EXTENDPAY = "extendpay" 	--扩展支付接口

PlatformYJ.FUNC_TAB		= "tab"			--切换账号
PlatformYJ.FUNC_QUIT 	= "quit" 		--退出
PlatformYJ.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformYJ.FUNC_INIT_ROLE	= "init_role"	--初始化
PlatformYJ.FUNC_CREATE		= "create_role" --创建角色
PlatformYJ.FUNC_ENTERGAME	= "enter_game" --进入游戏
PlatformYJ.FUNC_LEVELUP	= "level_up" --人物升级
PlatformYJ.FUNC_LOGINSUCCESS = "login_success" --登录成功后 要告诉平台 游戏版本更新
PlatformYJ.FUNC_ENTERSERVER = "enter_server " --选择服务器
PlatformYJ.CODE_SUCCESS = 0

PlatformYJ.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformYJ.STATE_LOGIN_FAIL = 1	-- 失败

PlatformYJ.STATE_LOGIN_CANCLE = 2	-- 失败



-- 不准许有全局参数，因为需要被reload

--

--


function PlatformYJ:init()
	require "../data/platform_sdk_config"
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	--http是否已经返回！
	self.payurl_waiting     = false
	self.format_pay_url = "http://sync.1sdk.cn/cb/%s/%s/sync.html"
	self.unlockcallback = callback:new()
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>U9")
	self.AppId = ''
	self.channel = ""
	self.plat = ""
	self.uuid = ""
	self.subchannel = ""
end


--进入游戏后
function PlatformYJ:init_role_info()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local vip_level = VIPModel:get_vip_info().level
	local roleId = player.id or "1" 	--user_name 就是uid
	local roleName = player.name or "1"
    local serverId = server_info.server_id or "1"
    local serverName = server_info.server_name or "1"
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYJ.FUNC_ENTERGAME
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel"] = roleLevel
	json_table_temp[ "serverId" ] = serverId
	json_table_temp["partyName"] = player.guildName or "无世族"
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "balance"] = player.yuanbao or "0"
	json_table_temp[ "vip"] = vip_level or "0"
	json_table_temp[ "roleCTime"] = "0"
	json_table_temp[ "roleLevelMTime"] = "0"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
	-- print_zengsi("进入游戏后 init_role_info -----begin")
	-- Utils:print_table(json_table_temp)
	-- print_zengsi("进入游戏后 init_role_info -----end")
end

--人物升级调用
function PlatformYJ:onPlayerLevelUp()
	local login_info = RoleModel:get_login_info()
	local vip_level = VIPModel:get_vip_info().level
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = player.id or "1" 	--user_name 就是uid
	local roleName = player.name or "1"
    local serverId = server_info.server_id or "1"
    local serverName = server_info.server_name or "1"
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYJ.FUNC_LEVELUP
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp["partyName"] = player.guildName or "无世族"
	json_table_temp[ "roleLevel"] = roleLevel
	json_table_temp[ "balance"] = player.yuanbao or "0"
	json_table_temp[ "vip"] = vip_level or "0"
	json_table_temp[ "roleCTime"] = "0"
	json_table_temp[ "roleLevelMTime"] = os.time()
	require 'json/json'
	-- GlobalFunc:create_screen_notic("人物升级send_message_to_java")
	-- MUtils:toast("人物升级send_message_to_java",2048,2.5) -- [69]="请求登录授权"
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
	-- print_zengsi("人物升级调用 onPlayerLevelUp -----begin")
	-- Utils:print_table(json_table_temp)
	-- print_zengsi("人物升级调用 onPlayerLevelUp -----end")
end

--选择服务器进入后,其实就是进入游戏后
function PlatformYJ:enter_server()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local vip_level = VIPModel:get_vip_info().level
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = player.id or "1" 	--user_name 就是uid
	local roleName = player.name or "1"
    local serverId = server_info.server_id or "1"
    local serverName = server_info.server_name or "1"
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYJ.FUNC_ENTERSERVER
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "roleLevel"] = roleLevel
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "balance"] = player.yuanbao or "0"
	json_table_temp["partyName"] = player.guildName or "无世族"
	json_table_temp[ "vip"] = vip_level or "0"
	json_table_temp[ "roleCTime"] = "0"
	json_table_temp[ "roleLevelMTime"] = "0"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
	-- print_zengsi("选择服务器进入后 enter_server -----begin")
	-- Utils:print_table(json_table_temp)
	-- print_zengsi("选择服务器进入后 enter_server -----end")
end


--创建角色调用
function PlatformYJ:create_role_info(create_role_info)

	-- MUtils:toast("创建角色", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYJ.FUNC_CREATE
	json_table_temp[ "roleId" ] = create_role_info.roleId or "1"
	json_table_temp[ "serverId" ] = create_role_info.serverId or "1"
	json_table_temp[ "roleName" ] = create_role_info.roleName or "1"
	json_table_temp[ "serverName"] = create_role_info.serverName or "1"
	json_table_temp[ "roleLevel"] = create_role_info.roleLevel or "1"
	json_table_temp["partyName"] = "无世族"
	json_table_temp[ "balance"] = 0
	json_table_temp[ "vip"] = 0
	json_table_temp[ "roleCTime"] = os.time()
	json_table_temp[ "roleLevelMTime"] = "0"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
	-- print_zengsi("创建角色 create_role_info -----begin")
	-- Utils:print_table(json_table_temp)
	-- print_zengsi("创建角色 create_role_info -----end")
end


-- login 的参数

function PlatformYJ:get_login_param( account, dbip, server_id )
	local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
 	local str_login_param = "uid="..tostring(self.userId).."&udid="..tostring(udid).."&channel="..self.platform_flag.."&sub_channel=".."platform_yijie".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
  	return str_login_param
end

function PlatformYJ:get_login_param_json( )
    local time = os.time()
    return "uid=" .. self.userId .."&channel="..self.platform_flag.. "&sdk=" .. self.channelId .. "&app="..self.appId.. "&uin=" .. self.userId .. "&sess=" .. self.token .."&time="..tostring(time).."&sign="..md5("yijie"..tostring(time).."QGALUMECG5OP33A2BNM6EIQ7I5MVGKGO")
end
-- 获取登录服务器ip

function PlatformYJ:OnAsyncMessage( id, msg )

	require 'json/json'
	-- print("PlatformYJ:OnAsyncMessage >>>>>>>>>>>")
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	local message_type = jtable[ "message_type" ] or ""
	if message_type == self.MESSAGE_TYPE then
		local func_type = jtable[ "funcType" ] or ""
		local error_code = jtable[ "error_code" ] or self.CODE_FAIL
		if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
			if error_code == self.CODE_SUCCESS then
				if GameStateManager:get_state() == "scene" then --如果已经在游戏里了，还收到这个，就是切换账号的\
					--这里调退出游戏
					-- print("如果已经在游戏里了，还收到这个，就是切换账号的")
					local function logout_callback()
						MenusPanel:use_all_equip_tip( )
						AudioManager:stopBackgroundMusic(true)
						print_zengsi("zengsi 返回登录中。。。。。。。。。。。。。。。。。。。。。。。。。。")
						MiscCC:send_quit_server()
						GameStateManager:set_state("login")
						-- 取消
						if GetPlatform() == CC_PLATFORM_IOS then
							IOSDispatcher:IAP_remove_observer( )
						elseif GetPlatform() == CC_PLATFORM_ANDROID then
						elseif GetPlatform() == CC_PLATFORM_WIN32 then	
						end
					end
					-- print_zengsi("zengsi PlatformYJ:logout(logout_callback)。。。。。。。。。。。。。。。。。。。。。。。。。。")
					logout_callback()
				else
					self.appId = jtable["appId"];
					self.channelId = jtable["channelId"];
					self.userId = jtable["userId"];
					self.token = jtable["token"];
					self.uid = self.userId
					local platform_flag = platform_sdk_config.special[self.channelId]
					if platform_flag == nil then
						platform_flag = platform_sdk_config.normal[self.channelId]
					end
					self.platform_flag = platform_flag or "nil"
					self.platform_name = platform_flag
					self.platform_flag = "platform_" .. self.platform_flag
					self.channelId = Utils:RemoveString(self.channelId,"{")
					self.channelId = Utils:RemoveString(self.channelId,"}")
					self.channelId = Utils:RemoveString(self.channelId,"-")
					local memory = jtable["memory"]
					self.appId = Utils:RemoveString(self.appId,"{")
					self.appId = Utils:RemoveString(self.appId,"}")
					self.appId = Utils:RemoveString(self.appId,"-")
					RoleModel:set_phone_memory(memory)
					RoleModel:request_server_list_platform()
				end
			else
				if error_code == self.STATE_LOGIN_FAIL then
					MUtils:toast("登录失败", 2048, 2.5)	
					self:try_login()
					
				elseif error_code == self.STATE_LOGIN_CANCLE then
					MUtils:toast("登录取消", 2048, 2.5)
					self:try_login()
				end			

			end
		elseif func_type == self.FUNC_TAB then --切换账号
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
			-- print_zengsi("zengsi PlatformYJ:logout(logout_callback)。。。。。。。。。。。。。。。。。。。。。。。。。。")
			-- PlatformYJ:logout(logout_callback)
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
function PlatformYJ:getDownloadChannel()
	return self.platform_flag--self.subchannel
end

--平台
function PlatformYJ:getDownloadFrom()
	-- return self.channel
	return self.platform_flag
end

function PlatformYJ:get_cache_url()
	local temp_url_font = CCAppConfig:sharedAppConfig():getStringForKey('develop_cache_url')
	UpdateManager.cache_url = UpdateManager.cache_url or temp_url_font .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
	return UpdateManager.cache_url

end

function PlatformYJ:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYJ.FUNC_QUIT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformYJ:get_package_url()

	return UpdateManager.package_url-- .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')

end

--平台主动行为封装 Begin
--支付
function PlatformYJ:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
	if payWin == nil then 
	   return
	end
	--paywin里直接调用payUICallback
	-- payWin:setCallback(function(which)
	-- 		self:payUICallback({ item_id = which, window = 'pay_win' })
	-- 	end)
end

function PlatformYJ:payUICallback(info)


	-- if self.platform_name == "tt" then
	-- 	local data = {content="暂时无法充值！请联系客服！",btn_name= "确定"}
 --    	SGeneralTips:show_tips(SGeneralTips.GENERAL, data)
	-- 	return
	-- end

	local _money_rate = 10
    -- local user_account = RoleModel:get_login_info().user_name
    local player = EntityManager:get_player_avatar()
    local game_money  = info.item_id 		--元宝数量
    local player = EntityManager:get_player_avatar()

	local _userId   = player.id

	local _serverId = RoleModel:get_login_info().server_id
	local send_java_callback = nil
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
			-- print("s,e",s,e)
			if not s then 
				return 
			end
			-- print("jtable=",jtable)
			local resulst_code = jtable['ret']								   -- 0：操作失败   1：操作成功   -1：其他错误
			Utils:print_table(jtable)
			-- print("resulst_code=",resulst_code)
			if resulst_code == "1" then 
				send_java_callback()
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
	--http://sync.1sdk.cn/cb/wdj/5AE844609915FAEB/sync.html
	local url   = "http://sync.1sdk.cn/cb/" .. self.platform_name .. '/' .. self.appId .. "/sync.html"
	local cporderid = self.platform_flag ..self.uid.."_".._serverId .."_".. os.time()
	local extra = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index) ..",channel:" .. self.platform_flag 
	local param = "waresid=" .. info.item_index .. "&cporderid=" .. cporderid .. "&price=" .. game_money .. "&appuserid=" .. self.uid .. "&cpprivateinfo=" .. extra .. "&notifyurl=" .. UpdateManager.yuliu_str

	-- ZXLog(LangModelString[441], url , "param:", param) -- [441]="（平台公用）请求服务器列表： url: "
	

	send_java_callback = function()	
		if self.platform_name == "sougou" 
		   or self.platform_name == "kugou" then
			function_type = PlatformYJ.FUNC_EXTENDPAY
		elseif self.platform_name == "yixin" 
			 or self.platform_name == "pptv" then
			function_type = PlatformYJ.FUNC_PAY
		else
			function_type = PlatformYJ.FUNC_CHARGE
		end
		local product_name = game_money*_money_rate
		local money_name = "元宝"
		local remain = 10
		if info.item_index == 20 then --月卡   remain=0的时候，商品名字前面就不会被加上价格
			money_name = "福利月卡"
			product_name= ""
			remain = 0
		elseif info.item_index == 21 then
			money_name = "至尊月卡"
			product_name = ""
			remain = 0
		end
		product_name = product_name .. money_name
		local json_table_temp = {}
		json_table_temp["message_type"] 	= PlatformYJ.MESSAGE_TYPE 				--消息类型
		json_table_temp["function_type"] 	= function_type 						--支付接口类型
		json_table_temp["money_name"] 		= money_name 							--道具名称
		json_table_temp["amount"] 			= game_money*100 						--充值或支付金额（现实货币），单位为 分
		json_table_temp["count"] 			= 1 									--数量
		json_table_temp["product_id"] 		= info.item_index 						--商品唯一标识id
		json_table_temp["product_name"] 	= product_name							--商品名称
		json_table_temp["extra"] 			= extra 								--扩展参数
		json_table_temp["remain"] 			= remain 								--比例
		json_table_temp["pay_url"] 			= UpdateManager.yuliu_str or ""
		require 'json/json'
		local jcode = json.encode( json_table_temp )
		send_message_to_java( jcode )
	end
	send_java_callback()
	-- print("充值url, param=",url, param)
	-- local http_request = HttpRequest:new(url, param, http_callback)
	-- http_request:send()	
end

function PlatformYJ:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformYJ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformYJ.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformYJ:getLoginRet()
	return self.uid, self.token
end

function PlatformYJ:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.normal
end

--------------------------------------

--unused function

--HJH 2014-11-27

--写这个架构的人没想清楚，怎么会有下面这些函数

function PlatformYJ:share(info)
end

function PlatformYJ:setLoginRet(uid,psw)
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformYJ:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformYJ:open_user_center()
end

function PlatformYJ:onLoginResult( err, data )
	PlatformInterface:onEnterLoginState()
end

--加个列表 很多平台切换账号不能再调用登录

--进入登录状态
-- function PlatformYJ:onEnterLoginState()
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
function PlatformYJ:logout(callbackfunc)
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