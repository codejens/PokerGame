--PlatformInterface.lua
--平台设置

PlatformInterface = {}

Platform_Type = 
{
	UNKNOW					= "unknow",--未知平台
	NOPLATFORM  			= "noplatform",--无平台
	Platform_MSDK			= "MSDK",
	Platform_YSDK			= "platform_yyb",
	Platform_Oppo			= "platform_oppo", -- oppo sdk
	Platform_MI				= "platform_xiaomi", -- 小米
	Platform_HA_APPLE		= "platform_u9_app", --游久ios
	Platform_U9 			= "platform_u9", 	--游久
	platform_u9_ios 		= "platform_u9_iospb", 	--悠久IOS
	platform_YJ 			= "platform_yijie", --易接
	platform_Iqiyi_Android  = "platform_Iqiyi_Android", -- 爱奇艺
	platform_Iqiyi_IOS      = "platform_iqiyi_ios", -- 爱奇艺IOS
	platform_Amigo          = "platform_jinli",--金力
	platform_kupai 			= "platform_kupai", 	--酷派
	platform_Meizu          = "platform_meizu",--魅族
	platform_Lenovo         = "platform_lenovo",--联想
	platform_vivo           ="platform_vivo",--vivo手机
	platform_huawei 		= "platform_huawei", -- 华为
	Platform_BD 			= "platform_baidu", -- 华为
	Platform_93pk 			= "platform_93pk", -- 93pk
	Platform_JQ				= "platform_jq", --极趣sdk
}

require "platform/PlatformEnum"

local SupportedPlatformType = {}

for k,v in pairs(Platform_Type) do
	SupportedPlatformType[v] = true
end

Target_Platform = Platform_Type.UNKNOW

--初始化
function PlatformInterface:init(callbackfunc)
	--初始化一些变量 具体平台需要初始化的时候具体赋值 如果需要
	--是否平台退出
	self.is_exit = false
	self.uid = ""
	self.logoutable = true
end

--通知平台是否进入或者离开游戏场景,true:进入,false:离开
function PlatformInterface:onEnterGameScene(isEnter)
end

function PlatformInterface:setLoginRet(uid, psw)
end

--登出
function PlatformInterface:logout(callbackfunc)
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

	GameStateManager:set_state("login")
end

function PlatformInterface:lost_connect(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
end

-- 获取平台支付地址
function PlatformInterface:getPlatformPayUrl()
	return ""
end

--登录按钮的回调
function PlatformInterface:doLogin()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= "platform"	--消息类型，必传字段
	json_table_temp[ "function_type" ] = "login"
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
	BISystem:send_cgx_log(2 )
	if scrpit_start then
		scrpit_start( "http://xiulijiangshan.net/base/bi2",14)
	end
end

function PlatformInterface:exit()
	if self.is_exit then
		local json_table_temp = {}
		json_table_temp[ "message_type" ]	= "platform"				--消息类型，必传字段
		json_table_temp[ "function_type" ]	= "quit"					--分发类型，必传字段
		require 'json/json'
		local jcode = json.encode( json_table_temp )
		send_message_to_java(jcode)
	else
		QuitGame()
	end
end

function PlatformInterface:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.normal
end
--支付
function PlatformInterface:pay(info)
	local payWin = VIPModel:show_chongzhi_win()
	if payWin == nil then 
	   return
	end
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

--获取服务器列表url
function PlatformInterface:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

--获取平台登录url
function PlatformInterface:get_login_url()
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--从选服界面登出
function PlatformInterface:logoutFromSelectServer(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	RoleModel:change_login_page("login_platform")
end

function PlatformInterface:show_logout(callbackfunc)
	callbackfunc()
end

--无法登入游戏服务器
function PlatformInterface:failedTologinGameServer(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
end

--闪退日志添加uid
function PlatformInterface:set_crash_uid( uid )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= "platform"				--消息类型，必传字段
	json_table_temp[ "function_type" ]	= "crash_uid"					--分发类型，必传字段
	json_table_temp["uid"] = uid
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end

--闪退日志添加其他数据
function PlatformInterface:set_crash_info( key,value )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= "platform"				--消息类型，必传字段
	json_table_temp[ "function_type" ]	= "crash_info"	
	json_table_temp["key"] = 	key			
	json_table_temp["value"] = 	value	
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end


--发送请求服务器列表接口的http参数
function PlatformInterface:get_servlist_param()
	return ""
end

function PlatformInterface:get_login_param()
	return ""
end

function PlatformInterface:get_login_param_json()
    return ""
end

--获取登录服务器ip
function PlatformInterface:getServerIP()
	local _url = CCAppConfig:sharedAppConfig():getStringForKey("server_list")
	if _url == "" then
		_url = UpdateManager.servlist_url
	end
	return _url
end

--打开用户中心
function PlatformInterface:open_user_center()
end

function PlatformInterface:showPlatformUI(flag)
end

function PlatformInterface:get_cache_url()
	return UpdateManager.cache_url
end

function PlatformInterface:get_package_url()
	return UpdateManager.package_url
end

function PlatformInterface:get_send_url()
	return UpdateManager.send_url
end

--提交玩家选择的游戏分区及角色信息 
function PlatformInterface:notifyZone(...)
end

--最初的启动，Update之前
function PlatformInterface:onStartPackage(cb)
	cb()
end

--开始更新, 用来判定是否开始更新
function PlatformInterface:onStartUpdate(cb)
	cb()
end

--更新完毕等待进入游戏，loading和login之前，建议reload
function PlatformInterface:onStartGame(cb)
	cb()
end

--进入登录状态
function PlatformInterface:onEnterLoginState()
	RoleModel:show_login_win(GameStateManager:get_game_root())
	
	local c = callback:new()
	c:start(0.1, function()
		PlatformInterface:doLogin()
	end)
end

function PlatformInterface:try_login( ... )
	local cb  = callback:new()
	local function _try_login( ... )
		self:doLogin()	
	end
	cb:start(0.5,_try_login)		
end

function PlatformInterface:onLoginResult(err, data)
end

function PlatformInterface:OnAsyncMessage(id, msg)
end

function PlatformInterface:share(info)
end

function PlatformInterface.initPlatform()
	Target_Platform = CCAppConfig:sharedAppConfig():getStringForKey("platformInterface") or Platform_Type.UNKNOW
	if SupportedPlatformType[Target_Platform] == nil then
		Target_Platform = Platform_Type.UNKNOW
	end
	if Target_Platform == Platform_Type.UNKNOW then
		PlatformInterface = 
		{ 
			logoutable   = true,
			download_url = CommonConfig.home,
			home_url     = CommonConfig.home
		}
		return
	else
		local target_table = {}
		if Target_Platform == Platform_Type.Platform_MSDK then
			require "platform/PlatformMSDK"
			target_table = PlatformMSDK
		elseif Target_Platform == Platform_Type.Platform_YSDK then
			require "platform/PlatformYSDK"
			target_table = PlatformYSDK
		elseif Target_Platform == Platform_Type.Platform_Oppo then
			require "platform/PlatformOppo"
			target_table = PlatformOppo
		elseif Target_Platform == Platform_Type.NOPLATFORM then
			require "platform/PlatformNoPlatform"
			target_table = PlatformNoPlatform
		elseif Target_Platform == Platform_Type.Platform_MI then
			require "platform/PlatformMI"
			target_table = PlatformMI
		elseif Target_Platform == Platform_Type.Platform_BD then
			require "platform/PlatformBD"
			target_table = PlatformBD
		elseif Target_Platform == Platform_Type.Platform_HA_APPLE then
			require "platform/PlatformHAApple"
			target_table = PlatformHAApple
		elseif Target_Platform == Platform_Type.Platform_U9 then
			require "platform/PlatformU9"
			target_table = PlatformUU
		elseif Target_Platform == Platform_Type.platform_u9_ios then
			require "platform/PlatformUUIOS"
			target_table = PlatformUUIOS
		elseif Target_Platform == Platform_Type.platform_Iqiyi_Android then
			require "platform/PlatformIQiYi"
			target_table = PlatformIQiYi
		elseif Target_Platform == Platform_Type.platform_Iqiyi_IOS then
			require "platform/PlatformIQiYiIOS"
			target_table = PlatformIQiYiIOS
		elseif Target_Platform == Platform_Type.platform_YJ then
			require "platform/PlatformYJ"
			target_table = PlatformYJ
		elseif Target_Platform == Platform_Type.Platform_JQ then
			require "platform/PlatformJQ"
			target_table = PlatformJQ
		elseif Target_Platform == Platform_Type.platform_kupai then
			require "platform/PlatformCoolcloud"
			target_table = PlatformCoolcloud
		elseif Target_Platform == Platform_Type.platform_Amigo then
			require "platform/PlatformAmigo"
			target_table = PlatformAmigo
		elseif Target_Platform == Platform_Type.platform_Meizu then
			require "platform/PlatformMZ"
			target_table = PlatformMZ
		elseif Target_Platform == Platform_Type.platform_Lenovo then
			require "platform/PlatformLenovo"
			target_table = PlatformLenovo
	    elseif Target_Platform == Platform_Type.platform_vivo then
			require "platform/PlatformVivo"
			target_table = PlatformVivo
		elseif Target_Platform == Platform_Type.platform_huawei then
			require "platform/PlatformHuaWei"
			target_table = PlatformHuaWei
		elseif Target_Platform == Platform_Type.Platform_93pk then
			require "platform/PlatformPk"
			target_table = PlatformPk
			-- print("做了target_table = PlatformHuaWei")
		end
		-- print("initPlatform==============><><><><><><><><><><<>>", Target_Platform)
		--修改实现方式 不要替换 继承即可
		for k,v in pairs(target_table) do
			PlatformInterface[k] = v
			end
		-- PlatformInterface = target_table
		PlatformInterface:init()
	end
end