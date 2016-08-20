-- PlatformInterface.lua
-- created by aXing on 2013-7-16
-- 平台设置

PlatformInterface = { }

--GameUrl_global 请同步设置Platform_Type
Platform_Type = 
{
	UNKNOW					= "unknow",
	NOPLATFORM  			= 'noplatform',
	Platform_sqw 			= "sqwPlatform",
	Platform_sqwApple 		= "sqwApplePlatform",
	Platform_sqwApple_pb 	= "sqwApplePBPlatform",
	Platform_ewan       	= "ewanPlatform",
	Platform_MSDK			= "MSDK",
	Platform_Oppo			= "oppoPlatform", -- oppo sdk
	Platform_MI				= "miPlatform", -- 小米
	Platform_SC				= "scPlatform", -- 生菜
	Platform_wdj			= "wdjPlatform", -- 豌豆荚
	Platform_BD				= "bdPlatform", -- 百度
	Platform_Youku			= "youkuPlatform",
	Platform_PPS			= "ppsPlatform",
	Platform_KuGou			= "KuGouPlatform",
	Platform_UC				= "UCPlatform",
	Platform_SD 			= "SDPlatform",
	Platform_360			= "360Platform",
	Platform_Wanpu			= "wanpuPlatform",
	Platform_YYG			= "yygPlatform",
	Platform_it 			= "itPlatform",  -- iTools助手
	Platform_tb 			= "tbPlatform",  -- 同步推
	Platform_pp 	    	= "ppPlatform",	 -- pp助手
	Platform_djoy 	    	= "downjoyPlatform",	-- 当乐
	Platform_SD_APPLE		= "SDApplePlaform", 
	Platform_HA_APPLE		= "HAApplePlatform", --互爱
	Platform_Hoolai			= "HoolaiPlatform", --胡莱1(龙剑传奇)
	Platform_Hoolai2		= "HoolaiPlatform2", --胡莱2(铁血传奇)
	Platform_ZS				= "zsPlatform", --掌尚
	Platform_Any			= "anyPlatform", -- AnySDK
	Platform_sy        = "syPlatform", --07073
	Platform_LJ        		= "ljcqPlatform", --胡莱带登陆
	Platform_YXD        		= "yxdPlatform", --8849  游戏多
	Platform_Sogou        		= "sogouPlatform", --搜狗
	Platform_YL        		= "youlongPlatform", --游龙
	Platform_DY        		= "dianyouPlatform", --点优
}

require('platform/PlatformEnum')
local SupportedPlatformType = {}

for k, v in pairs(Platform_Type) do
	SupportedPlatformType[v] = true
end

Target_Platform 	= Platform_Type.UNKNOW
Target_Platform_appId = nil

--初始化
function PlatformInterface:init(callbackfunc)
	callbackfunc()
end

-- @param:通知平台，是否进入或者离开游戏场景,true：进入,false:离开
function PlatformInterface:onEnterGameScene(isEnter)
	
end

function PlatformInterface:setLoginRet(uid,psw)
	
end

--登出
function PlatformInterface:logout(callbackfunc)
	callbackfunc()
end

function PlatformInterface:lost_connect( callbackfunc )
	-- body
	callbackfunc()
end

-- 按下登录按钮的回调
function PlatformInterface:doLogin()
	
end

--支付
function PlatformInterface:pay( info )
end

--获取服务器列表url
function PlatformInterface:get_servlist_url()
	return ""
end
--获取平台登录url
function PlatformInterface:get_login_url()
	return ""
end

--从选服界面登出
function PlatformInterface:logoutFromSelectServer(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
end

--无法登入游戏服务器
function PlatformInterface:failedTologinGameServer(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformInterface:get_servlist_param(  )
	return ""
end

function PlatformInterface:get_login_param()
	-- body
	return ""
end

function PlatformInterface:get_login_param_json(  )
    return ''
end


-- 获取登录服务器ip
function PlatformInterface:getServerIP()
	return ""
end

-- 打开用户中心
function PlatformInterface:open_user_center()
	
end

function PlatformInterface:get_cache_url()

end

function PlatformInterface:get_package_url()

end

-- 提交玩家选择的游戏分区及角色信息 
function PlatformInterface:notifyZone( ... )
	-- 子类重写
end

--最初的启动，Update之前
function PlatformInterface:onStartPackage(cb)
end

--开始更新, 用来判定是否开始更新
function PlatformInterface:onStartUpdate(cb)
end

--更新完毕等待进入游戏，loading和login之前，建议reload
function PlatformInterface:onStartGame(cb)
end

--进入登录状态
function PlatformInterface:onEnterLoginState()
	
end


function PlatformInterface:onLoginResult( err, data )
	-- body
end

function PlatformInterface:OnAsyncMessage( id, msg )

end
--获取平台登录参数
-- function PlatformInterface:get_platform_param()

-- end


--分享接口, info为table，必须有key
--info = {
--    ['title']
--    ['desc']
--    ['targetUrl']
--	  ['imgUrl']	
--}
function PlatformInterface:share(info)

end

function PlatformInterface.initPlatform()
	--TODO
	Target_Platform = CCAppConfig:sharedAppConfig():getStringForKey('platformInterface') or Platform_Type.UNKNOW
	--如果没有平台，走之前的方法
	

	if SupportedPlatformType[Target_Platform] == nil then
		Target_Platform = Platform_Type.UNKNOW
	end

	-- print('PlatformInterface.initPlatform : ', Target_Platform)
	if Target_Platform == Platform_Type.UNKNOW then
		PlatformInterface = 
		{ 
			logoutable    = true,
			download_url = CommonConfig.home,
			home_url     = CommonConfig.home
		}
		Target_Platform_appId = 100703379
		return
	else
		local target_table = {}
		print("PlatformInterface.initPlatform Target_Platform",Target_Platform)
		if Target_Platform == Platform_Type.Platform_MSDK then
			require "platform/PlatformMSDK"
			target_table = PlatformMSDK
			ZXLog("PlatformMSDK")
			-- Target_Platform_appId = 100703379
		elseif Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2 then
			-- hoolai 和hoolai2处理方法一样,这里分开命名仅仅是为了显示不一样的logo
			require "platform/PlatformHoolai"
			target_table = PlatformHoolai
		elseif Target_Platform == Platform_Type.Platform_Oppo then
			require "platform/PlatformOppo"
			target_table = PlatformOppo
		elseif Target_Platform == Platform_Type.QQHall then
			require "platform/PlatformQQHall"
			target_table = PlatformQQHall
			-- Target_Platform_appId = 100703379
		elseif Target_Platform == Platform_Type.NOPLATFORM then
			require "platform/PlatformNoPlatform"
			target_table = PlatformNoPlatform
			ZXLog('PlatformNoPlatform')
			-- Target_Platform_appId = 100703379
		elseif Target_Platform == Platform_Type.Platform_sqw then
			require "platform/PlatformSqw"
			target_table = PlatformSqw
			ZXLog("PlatformSqw")
		elseif Target_Platform == Platform_Type.Platform_sqwApple then
			require "platform/PlatformSqwApple"
			target_table = PlatformSqwApple
			-- ZXLog("PlatformSqwApple")
		elseif Target_Platform == Platform_Type.Platform_sqwApple_pb then
			require "platform/PlatformSqwApplePB"
			target_table = PlatformSqwApplePB
		elseif Target_Platform == Platform_Type.Platform_MI then
			require "platform/PlatformMI"
			target_table = PlatformMI
	    elseif Target_Platform == Platform_Type.Platform_SC then
			require "platform/PlatformSC"
			target_table = PlatformSC
		elseif Target_Platform == Platform_Type.Platform_ZS then
			require "platform/PlatformZS"
			target_table = PlatformZS
		elseif Target_Platform == Platform_Type.Platform_sy then
			require "platform/PlatformSY"
			target_table = PlatformSY
		elseif Target_Platform == Platform_Type.Platform_BD then
			require "platform/PlatformBD"
			target_table = PlatformBD
		elseif Target_Platform == Platform_Type.Platform_PPS then
			require "platform/PlatformPPS"
			target_table = PlatformPPS
		elseif Target_Platform == Platform_Type.Platform_360 then
			require "platform/Platform360"
			target_table = Platform360
		elseif Target_Platform == Platform_Type.Platform_wdj then
			require "platform/PlatformWdj"
			target_table = PlatformWdj
		elseif Target_Platform == Platform_Type.Platform_ewan then
			require "platform/PlatformEwan"
			target_table = PlatformEwan
			ZXLog("PlatformEwan")
	    elseif Target_Platform == Platform_Type.Platform_Youku then
			require "platform/PlatformYouku"
			target_table = PlatformYouku
			ZXLog("PlatformYouku")
		elseif Target_Platform == Platform_Type.Platform_KuGou then
			require "platform/PlatformKuGou"
			target_table = PlatformKuGou
			ZXLog("PlatformKuGou")
		elseif Target_Platform == Platform_Type.Platform_UC then
			require "platform/PlatformUC"
			target_table = PlatformUC
			ZXLog("PlatformUC")
		elseif Target_Platform == Platform_Type.Platform_SD then
			require "platform/PlatformSD"
			target_table = PlatformSD
			ZXLog("PlatformSD")
	    elseif Target_Platform == Platform_Type.Platform_Wanpu then
			require "platform/PlatformWanpu"
			target_table = PlatformWanpu
			 ZXLog("PlatformWanpu")
		elseif Target_Platform == Platform_Type.Platform_YYG then
			require "platform/PlatformYYG"
			target_table = PlatformYYG
		elseif Target_Platform == Platform_Type.Platform_it then	
			require "platform/PlatformIT"
			target_table = PlatformIT
			ZXLog('PlatformIT init')
		elseif Target_Platform == Platform_Type.Platform_tb then
			require "platform/PlatformTB"
			target_table = PlatformTB
			ZXLog('PlatformTB init')
		elseif Target_Platform == Platform_Type.Platform_pp then
			require "platform/PlatformPP"
			target_table = PlatformPP
			ZXLog('PlatformPP init')
		elseif Target_Platform == Platform_Type.Platform_djoy then
			require "platform/PlatformDownJoy"
			target_table = PlatformDownJoy
			ZXLog('PlatformPP init')
		elseif Target_Platform == Platform_Type.Platform_SD_APPLE then
			require "platform/PlatformSDApple"
			target_table = PlatformSDApple
			ZXLog("PlatformSDApple init")
		elseif Target_Platform == Platform_Type.Platform_HA_APPLE then
			require "platform/PlatformHAApple"
			target_table = PlatformHAApple
			ZXLog("PlatformHAApple init")
		elseif Target_Platform == Platform_Type.Platform_Any then
			require "platform/PlatformAny"
			target_table = PlatformAny
		elseif Target_Platform == Platform_Type.Platform_LJ then
			require "platform/PlatformLJ"
			target_table = PlatformLJ
		elseif Target_Platform == Platform_Type.Platform_YXD then
			require "platform/PlatformYouXiDuo"
			target_table = PlatformYouXiDuo
		elseif Target_Platform == Platform_Type.Platform_Sogou then
			require "platform/PlatformSogou"
			target_table = PlatformSogou
		elseif Target_Platform == Platform_Type.Platform_YL then
			require "platform/PlatformYL"
			target_table = PlatformYL
		elseif Target_Platform == Platform_Type.Platform_DY then
			require "platform/PlatformDY"
			target_table = PlatformDY
		end
		--检查是否所有接口都实现了
		--@debug_begin
		for k, v in pairs(PlatformInterface) do
			if target_table[k] == nil and k ~= 'initPlatform' then
				error(k .. ' : member not defined')
			end
		end
		--@debug_end

		--初始化
		PlatformInterface = target_table
		PlatformInterface:init()
	end
end
