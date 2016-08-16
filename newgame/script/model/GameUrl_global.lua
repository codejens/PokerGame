-- GameUrl_global.lua
-- created by lyl on 2013-8-11
-- 游戏使用的url保存

GameUrl_global = {}

-- 登录url
local login_url = ""            

-- 支付回调url
local payUrl = ""

local userID = ""

-- 
local accessToken = ""

-- 平台的用户id
local _uid = ""

local GameUrl_PlatformConfig = 
{

	[Platform_Type.UNKNOW] = { },

	---------------------------------------IOS平台登录url，登录和支付url配置------------------------------------

	-- [Platform_Type.Platform_ap] = { url 	  =  'http://loginhy.hoolaigames.com/hy/', },

	-- [Platform_Type.Platform_pp] = { url 	  =  'http://loginhy.hoolaigames.com/hy/', },
							   
	-- [Platform_Type.Platform_91] = { url 	  =  'http://loginhy.hoolaigames.com/hy/',},

	-- [Platform_Type.Platform_tb] = { url 	  =  'http://loginhy.hoolaigames.com/hy/',},
							   
	-- [Platform_Type.Platform_it] = { url 	  =  'http://loginhy.hoolaigames.com/hy/', },

	------------------------------------------------------------------------------------------------------		   						   						   						   
}


function GameUrl_global:set_login_url( url )
	login_url = url or ""
end

function GameUrl_global:get_login_rul(  )
	return login_url 
end


-- 支付回调url
function GameUrl_global:set_pay_url( url )
	payUrl = url or ""
end

function GameUrl_global:get_pay_rul(  )
	return payUrl 
end


function GameUrl_global:set_accessToken( access_token )
	----print("set_accessToken  accessToken::::::", access_token)
	accessToken = access_token or ""
end

function GameUrl_global:get_accessToken(  )
	----print("get_accessToken   accessToken::::::", accessToken)
	return accessToken 
end

function GameUrl_global:set_userID(id)
	userID = id
end

function GameUrl_global:get_userID()
	return userID
end

-- 平台用户id
function GameUrl_global:set_uid( uid )
	_uid = uid or ""
end

function GameUrl_global:get_uid(  )
	return _uid
end

function GameUrl_global:getServerIP(bool)
	----print("GameUrl_global:getServerIP")
	local config = GameUrl_PlatformConfig[Target_Platform]
	----print("GameUrl_global:getServerIP config",config)
	-- print("GameUrl_global=====>>>>>", config, Target_Platform)
	if not config then
		return PlatformInterface:getServerIP(bool)
	else
		return config.url or ""
	end
end


function GameUrl_global:getPlatformPayUrl()
	----print("GameUrl_global:getPlatformPayUrl")
	local config = GameUrl_PlatformConfig[Target_Platform]
	if not config then
		return PlatformInterface:getPlatformPayUrl()
	else
		return config.pay_url or ""
	end
end


function GameUrl_global:getPlatformConfig()
	return GameUrl_PlatformConfig[Target_Platform]
end

function GameUrl_global:appstoreUrl()
	 return 'http://loginhy.hoolaigames.com/'
end

function GameUrl_global:get_register_url()

	if PlatformInterface.outer_net then

		return PlatformInterface.register_url
	end
	return CCAppConfig:sharedAppConfig():getStringForKey("develop_register_url")
end