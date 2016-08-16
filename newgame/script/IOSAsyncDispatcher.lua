--IOSAsyncDispatcher.lua
--IOS异步消息派发器
--备注:发往OC层的json格式必须包含funcID字段,标识哪个函数。
--json = {"funcID":"iap_purchase"}(不带参数)
--json = {"funcID":"iap_purchase","productID":"mieshenProduct1"}(带参数)

IOSAsyncDispatcher = {}

--消息类型 key
local _MESSAGE_TYPE_KEY = "message_type"
--消息ID key
local _MESSAGE_ID_KEY   = "message_id"

--平台消息类型 key
local _PLATFORM_TYPE     = "platform"       --SDK平台
local _REACHABILITY_TYPE = "reachability"   --网络状态
local _BATTERY_TYPE      = "battery"        --电量状态

--平台消息ID类型 key
IOSAsyncDispatcher._PLATFORM_INIT     = "init"
IOSAsyncDispatcher._PLATFORM_LOGIN    = "login"
IOSAsyncDispatcher._PLATFORM_LOGOUT   = "logout"
IOSAsyncDispatcher._PLATFORM_PURCHASE = "purchase"

local function on_ios_async_message(error, json)
	local json_table = Utils:json2table(json)
	local message_type = json_table[_MESSAGE_TYPE_KEY]
	local message_id   = json_table[_MESSAGE_ID_KEY]
	if message_type == _PLATFORM_TYPE then
		PlatformInterface:OnAsyncMessage(message_id, json_table)
	elseif message_type == _REACHABILITY_TYPE then
		IOSAsyncDispatcher:reachabilityChanged(json_table)
	elseif message_type == _BATTERY_TYPE then
		IOSAsyncDispatcher:batteryChanged(json_table)
	end
end

--注册统一的异步回调函数
function IOSAsyncDispatcher:register_async_lua_handler()
	IOSRegisterAsyncLuaHandler(on_ios_async_message)
end

--调用oc异步函数
function IOSAsyncDispatcher:send_async_to_oc(json)
	IOSSendAsyncToOC(json)
end

--网络状态发生变化
function IOSAsyncDispatcher:reachabilityChanged(json_table)
	--0 无网络 1 WIFI 2 4G/3G/2G
	local net_type = 0
	if json_table.status == 0 then
		net_type = -1
	elseif json_table.status == 1 then
		net_type = 1
	elseif json_table.status == 2 then
		net_type = 4
	end
	NetManager:net_type_change(net_type)
end

--电量状态发生变化
function IOSAsyncDispatcher:batteryChanged(json_table)
	local battery = tonumber(json_table.battery)
	if not battery then
		return
	end
	battery = math.floor(battery*100)
	if SetSystemModel then
		SetSystemModel:set_phone_power(battery)
	end
end