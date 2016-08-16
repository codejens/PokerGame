PlatformUUIOS = {}

--商品类别
local _PRODUCTID_TYPE = {
	[1]  = "元宝",
	[2]  = "元宝",
	[3]  = "元宝",
	[4]  = "元宝",
	[5]  = "元宝",
	[6]  = "元宝",
	[7]  = "元宝",
	[8]  = "元宝",
	[20] = "月卡",
	[21] = "月卡",
	[22] = "抢购",
}

--商品名称
local _PRODUCTID_NAME = {
	[1]  = "60元宝",
	[2]  = "300元宝",
	[3]  = "980元宝",
	[4]  = "1980元宝",
	[5]  = "3280元宝",
	[6]  = "6480元宝",
	[7]  = "9980元宝",
	[8]  = "19980元宝",
	[20] = "30月卡",
	[21] = "98月卡",
	[22] = "一元抢购",
}

function PlatformUUIOS:init()
	self.logoutable = true
	self.udid = IOSDispatcher:get_udid()
	self.channel = "platform_u9_iospb"
	self.sub_channel = "platform_u9_iospb"
	self.loginkey = "f667b7492a9847c9930d66098a8875d9"
	self.platform = "ios"
end

function PlatformUUIOS:doLogin()
	local json = "{\"funcID\":\"sdku9_login\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
	BISystem:send_cgx_log(2)
end

function PlatformUUIOS:get_iap_callback()
end

function PlatformUUIOS:get_login_param()
	local _serverId = RoleModel:get_login_info().before_serverid
    return "uid="..self.uid.."&udid="..self.udid.."&channel="..self.channel.."&sub_channel="..self.sub_channel.."&plat="..self.platform.."&serverid=".._serverId
end

function PlatformUUIOS:get_login_param_json()
    local time = os.time()
	local sign = md5("u9"..time..self.loginkey)
	local str_login_param = "uid="..self.uid.."&time="..time.."&sign="..sign.."&token="..self.token.."&is_test=true".."&channel="..self.channel
	return str_login_param
end

function PlatformUUIOS:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	local json = string.format("{\"funcID\":\"sdku9_logout\"}")
	IOSAsyncDispatcher:send_async_to_oc(json)
	MUtils:toast(LangCommonString[25], 2048)
end

function PlatformUUIOS:lost_connect(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25], 2048)
end

function PlatformUUIOS:pay()
	VIPModel:show_chongzhi_win()
end

--支付
function PlatformUUIOS:payUICallback(info)
	local productPrice = info.item_id
	local serverId     = RoleModel:get_login_info().server_id
	local player       = EntityManager:get_player_avatar()
	if not player then
		GlobalFunc:create_screen_notic("#cfff000获取角色信息失败,请稍后再试")
		return
	end

	local time       = os.time()
	local orderId    = self.channel.."_"..self.uid.."_"..tostring(serverId).."_"..time
	local total      = productPrice
	local category   = _PRODUCTID_TYPE[info.item_index] or ""
	local name       = _PRODUCTID_NAME[info.item_index] or ""
	local json_table = {}
	json_table["funcID"]   = "talking_on_pay"
	json_table["orderId"]  = orderId
	json_table["total"]    = productPrice
	json_table["category"] = category
	json_table["account"]  = tostring(self.uid)
	-- self.order_table       = json_table

	local roleId              = player.id
	local roleLevel           = player.level
	local developerInfo       = "user_level:"..roleLevel..",role_id:"..roleId..",server_id:"..serverId..",product_id:"..info.item_index..",channel:"..self.channel
	local json_table          = {}
	json_table["funcID"]      = "sdku9_pay"
	json_table["orderId"]     = orderId
	json_table["serverId"]    = tostring(serverId)
	json_table["userId"]      = tostring(self.uid)
	json_table["price"]       = tostring(productPrice)
	json_table["productID"]   = tostring(info.item_index)
	json_table["productName"] = name
	json_table["ext"]         = developerInfo
	local mjcode = json.encode(json_table)
	IOSAsyncDispatcher:send_async_to_oc(mjcode)
end

function PlatformUUIOS:create_role_info(create_role_info)
	if create_role_info.errorId == 0 then
		local json = string.format("{\"funcID\":\"sdku9_create\",\"server\":\"%s\",\"roleid\":\"%s\",\"roleName\":\"%s\"}", create_role_info.serverId, create_role_info.roleId, create_role_info.roleName)
		IOSAsyncDispatcher:send_async_to_oc(json)
	end
end

function PlatformUUIOS:getDownloadChannel()
	return self.sub_channel
end

function PlatformUUIOS:getDownloadFrom()
	return self.channel
end

function PlatformUUIOS:switch_account()
end

function PlatformUUIOS:getLoginRet()
	return self.uid, self.token
end

function PlatformUUIOS:open_user_center()
	local json = "{\"funcID\":\"sdku9_user\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
end

function PlatformUUIOS:bind_mobile()
	local json = "{\"funcID\":\"sdku9_bind\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
end

function PlatformUUIOS:doRegisterSuccess()
	if self.uid then
		local str = "{\"funcID\":\"talking_on_register\",\"account\":\"%s\"}"
		local json = string.format(str, self.uid)
		IOSAsyncDispatcher:send_async_to_oc(json)
	end
end

function PlatformUUIOS:enter_user_center()
	local json = "{\"funcID\":\"sdku9_user\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
end

function PlatformUUIOS:doSDKInitResult(data)
	if data.error == false then
		self.channel     = data.channel
		self.sub_channel = data.sub_channel
		self.platform    = data.plat
		self.udid        = data.udid
	else
	end
end

function PlatformUUIOS:doLoginResult(data)
	if data.error == false then
		self.token    = data.token
		self.udid     = data.udid
		self.uid      = data.ppid
		self.usertype = data.usertype
		local str = "{\"funcID\":\"talking_on_login\",\"account\":\"%s\"}"
		local json = string.format(str, self.uid)
		IOSAsyncDispatcher:send_async_to_oc(json)
		RoleModel:request_server_list_platform()
	else
	end
end

function PlatformUUIOS:doLogOutResult(data)
	if data.error == false then
		if NetManager:get_socket() ~= nil and MiscCC ~= nil then
			MiscCC:send_quit_server()
		end
		GameStateManager:set_state("login", nil, true)
	else
	end
end

function PlatformUUIOS:doPurchaseResult(data)
	if data.error == false then
		GlobalFunc:create_screen_notic("#cfff000购买成功")
		if self.order_table then
			local mjcode = json.encode(self.order_table)
			IOSAsyncDispatcher:send_async_to_oc(mjcode)
		end
	else
		GlobalFunc:create_screen_notic("#cfff000购买失败,请稍后再试")
	end
	self.order_table = nil
end

function PlatformUUIOS:OnAsyncMessage(id, msg)
	if id == IOSAsyncDispatcher._PLATFORM_INIT then
		self:doSDKInitResult(msg)
	elseif id == IOSAsyncDispatcher._PLATFORM_LOGIN then
		self:doLoginResult(msg)
	elseif id == IOSAsyncDispatcher._PLATFORM_LOGOUT then
		self:doLogOutResult(msg)
	elseif id == IOSAsyncDispatcher._PLATFORM_PURCHASE then
		self:doPurchaseResult(msg)
	end
end