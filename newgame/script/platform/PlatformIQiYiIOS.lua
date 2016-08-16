PlatformIQiYiIOS = {}

--充值商品id
local _PRODUCTID_LIST = {
	[1] = "com.iqiyi.jiquyouxi.xljszcgx.coins6",
	[2] = "com.iqiyi.jiquyouxi.xljszcgx.coins30",
	[3] = "com.iqiyi.jiquyouxi.xljszcgx.coins98",
	[4] = "com.iqiyi.jiquyouxi.xljszcgx.coins198",
	[5] = "com.iqiyi.jiquyouxi.xljszcgx.coins328",
	[6] = "com.iqiyi.jiquyouxi.xljszcgx.coins648",
	--月卡
	[20] = "com.iqiyi.jiquyouxi.xljszcgx.card30",
	[21] = "com.iqiyi.jiquyouxi.xljszcgx.card98",
	--一元抢购
	[22] = "com.iqiyi.jiquyouxi.xljszcgx.card1",
}

--商品类别
local _PRODUCTID_TYPE = {
	[1]  = "元宝",
	[2]  = "元宝",
	[3]  = "元宝",
	[4]  = "元宝",
	[5]  = "元宝",
	[6]  = "元宝",
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
	[20] = "30月卡",
	[21] = "98月卡",
	[22] = "一元抢购",
}

function PlatformIQiYiIOS:init()
	self.logoutable = true
	self.udid = IOSDispatcher:get_udid()
	self.channel = "platform_iqiyi_ios"
	self.sub_channel = "platform_iqiyi_ios"
	self.loginkey = "74974bf301ff7e270d0e1e6860735f38"
	self.platform = "ios"
end

function PlatformIQiYiIOS:doLogin()
	local json = "{\"funcID\":\"sdkIQYLogin\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
	BISystem:send_cgx_log(2)
end

function PlatformIQiYiIOS:get_iap_callback()
end

function PlatformIQiYiIOS:get_login_param()
	local _serverId = RoleModel:get_login_info().before_serverid
    return "uid="..self.uid.."&udid="..self.udid.."&channel="..self.channel.."&sub_channel="..self.sub_channel.."&plat="..self.platform.."&serverid=".._serverId
end

function PlatformIQiYiIOS:get_login_param_json()
    local time = os.time()
	local sign = md5(self.channel..time..self.loginkey)
	local str_login_param = "uid="..self.uid.."&time="..time.."&sign="..sign
	return str_login_param
end

function PlatformIQiYiIOS:lost_connect(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25], 2048)
end

--打开个人中心
function PlatformIQiYiIOS:open_user_center()
	local json = "{\"funcID\":\"sdkOpenUserCenter\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
end

--打开客户服务
function PlatformIQiYiIOS:open_kehu_fuwu()
	local json = "{\"funcID\":\"sdkOpenKehuFuwu\"}"
	IOSAsyncDispatcher:send_async_to_oc(json)
end

--支付
function PlatformIQiYiIOS:pay()
	VIPModel:show_chongzhi_win()
end

--支付回调
function PlatformIQiYiIOS:payUICallback(info)
	local item_index = info.item_index
	if UpdateManager:is_appstore_auditing() then
		if item_index == 20 then
			item_index = 22
		elseif item_index == 21 then
			item_index = 20
		elseif item_index == 22 then
			item_index = 21
		end
	end
	local productId = _PRODUCTID_LIST[item_index]
	if not productId then
		GlobalFunc:create_screen_notic("#cfff000没有该商品ID,购买失败,请稍后再试")
		return
	end
	local productPrice = info.item_id
	local serverId     = RoleModel:get_login_info().server_id
	local player       = EntityManager:get_player_avatar()
	if not player then
		GlobalFunc:create_screen_notic("#cfff000获取角色信息失败,请稍后再试")
		return
	end

	local time       = os.time()
	local orderId    = "Iqiyi_Ios_"..self.uid.."_"..tostring(serverId).."_"..time
	local total      = productPrice
	local category   = _PRODUCTID_TYPE[item_index]
	local itemId     = productId
	local name       = _PRODUCTID_NAME[item_index]
	local json_table = {}
	json_table["funcID"]   = "talking_on_pay"
	json_table["orderId"]  = orderId
	json_table["total"]    = productPrice
	json_table["category"] = category
	json_table["account"]  = tostring(self.uid)
	self.order_table       = json_table

	local roleId        = player.id
	local roleLevel     = player.level
	local developerInfo = "user_level:"..roleLevel..",role_id:"..roleId..",server_id:"..serverId..",product_id:"..productId
	local str = "{\"funcID\":\"sdkIQYPurchase\",\"productId\":\"%s\",\"productPrice\":\"%d\",\"serverId\":\"%s\",\"roleId\":\"%s\",\"developerInfo\":\"%s\"}"
	local json = string.format(str, productId, productPrice, serverId, roleId, developerInfo)
	IOSAsyncDispatcher:send_async_to_oc(json)
end

--创建角色
function PlatformIQiYiIOS:create_role_info(create_role_info)
	if create_role_info.errorId == 0 then
		local str = "{\"funcID\":\"talking_on_create_role\",\"roleName\":\"%s\"}"
		local json = string.format(str, create_role_info.roleName)
		IOSAsyncDispatcher:send_async_to_oc(json)
	end
end

function PlatformIQiYiIOS:getPayInfo()
	require "../data/chong_zhi_config"
	if UpdateManager:is_appstore_auditing() then
		return ChongZhiConf.iqiyi_ios_auditing
	else
		return ChongZhiConf.iqiyi_ios
	end
end

function PlatformIQiYiIOS:switch_account()
end

function PlatformIQiYiIOS:getLoginRet()
	return self.uid, self.token
end

function PlatformIQiYiIOS:doRegisterSuccess()
	if self.uid then
		local str = "{\"funcID\":\"talking_on_register\",\"account\":\"%s\"}"
		local json = string.format(str, self.uid)
		IOSAsyncDispatcher:send_async_to_oc(json)
	end
end

function PlatformIQiYiIOS:doLoginResult(data)
	if data.error == false then
		self.uname     = data.uname
		self.uid       = data.uid
		self.timestamp = data.timestamp
		self.sign      = data.sign
		local str = "{\"funcID\":\"talking_on_login\",\"account\":\"%s\"}"
		local json = string.format(str, self.uid)
		IOSAsyncDispatcher:send_async_to_oc(json)
		RoleModel:request_server_list_platform()
	else
	end
end

function PlatformIQiYiIOS:doPurchaseResult(data)
	if data.error == false then
		GlobalFunc:create_screen_notic("#cfff000购买成功")
		if self.order_table then
			local mjcode = json.encode(self.order_table)
			IOSAsyncDispatcher:send_async_to_oc(mjcode)
		end
	else
		GlobalFunc:create_screen_notic("#cfff000购买失败")
	end
	self.order_table = nil
end

function PlatformIQiYiIOS:OnAsyncMessage(id, msg)
	if id == IOSAsyncDispatcher._PLATFORM_LOGIN then
		self:doLoginResult(msg)
	elseif id == IOSAsyncDispatcher._PLATFORM_PURCHASE then
		self:doPurchaseResult(msg)
	end
end