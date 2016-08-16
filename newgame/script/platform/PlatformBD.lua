PlatformBD= {}
PlatformBD.MESSAGE_TYPE	= "platform"
PlatformBD.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformBD.FUNC_LOGIN		= "login"		--登录
PlatformBD.FUNC_RELOGIN	= "re_login"	--重登
PlatformBD.FUNC_PAY		= "pay"			--支付
PlatformBD.FUNC_TOAST	= "toast"		--平台返回消息
PlatformBD.FUNC_TAB		= "tab"			--切换账号
PlatformBD.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformBD.FUNC_QUIT		= "quit"		--退出
PlatformBD.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformBD.CODE_SUCCESS = 0
PlatformBD.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformBD.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformBD:init()
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

	self.platformId = "platform_baidu"
	self.is_exit = true
end

-- login 的参数
function PlatformBD:get_login_param(account, dbip, server_id)
	local str = string.format(
		"uid=%s&udid=%s&channel=%s&sub_channel=%s&plat=android&serverid=%s",
   		self.uid,GetSerialNumber(),self.platformId,self.platformId,server_id
   	)
	return str
    -- return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformBD:get_login_param_json()
	local time = tostring(os.time())
	local sign = md5(self.platformId..time.."UqgDfqGLpR6a5P8yeuqndc4dRe79rb2E")
    local str = string.format(
		"time=%s&sign=%s&uid=%s&AppID=%s&AccessToken=%s",
		time, sign, self.uid, self.appId, self.access_token
    )
    return str
end


function PlatformBD:OnAsyncMessage(id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登录成功", 2048, 2.5)

					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					self.appKey = jtable["appKey"]
					self.appId = jtable["appId"]

					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登录失败", 2048, 2.5)
					self:try_login()
				end
			elseif func_type == self.FUNC_RELOGIN then -- 重连
				if GameStateManager:get_state()=="scene" then
					MiscCC:send_quit_server()
				end
				AIManager:set_AIManager_idle()
				GameStateManager:set_state("login")
				self:doLogin()
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
				if GameStateManager:get_state()=="scene" then
					MiscCC:send_quit_server()
					AIManager:set_AIManager_idle()
				end
				GameStateManager:set_state("login")
				-- if error_code == self.CODE_SUCCESS then
				-- 	self.access_token = jtable["token"]
				-- 	self.uid = jtable["uid"]
				-- 	RoleModel:request_server_list_platform()
				-- end
				-- RoleModel:change_login_page("new_select_server_page")
			elseif func_type == self.FUNC_TOAST then
				local toast = jtable["toast"]
				MUtils:toast(toast, 2048, 2.5)
			elseif func_type == self.FUNC_QUIT then
				ZXGameQuit()
			end	
		end
	end
	return false
end



--支付
-- 支付接口参数说明
-- !!! 注意必传参数,不能为空，推荐所有参数都传值 !!!

-- doid CP订单ID (*必传)
-- dpt CP商品名 (*必传)
-- dmoney CP金额(定额) (*必传) --单位为分
-- dradio CP兑换比率(1元兑换率默认1:10)

function PlatformBD:payUICallback(info)
	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product(info.item_id)
	local _money_rate = 100
	--local user_account = RoleModel:get_login_info().user_name

	local _item_id = info.item_id
	local _product = info.item_index
	local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _userLevel = player.level
	local _userName = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id
	local _orderId = "xljs_baidu_"..self.uid.."_".._serverId.."_"..os.time()
	local _extInfo = string.format(
		"user_level:%s,role_id:%s,server_id:%s,product_id:%s",
		_userLevel,_userId,_serverId,_product
	)

	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page("login")
	local item_name = ""
	if info.monthcard_name ~= nil then
		item_name = info.monthcard_name
	else
		item_name = string.format("%d元宝",_item_id*10)
	end
	local json_table_temp = {}
	json_table_temp[ "message_type" ] = PlatformBD.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformBD.FUNC_PAY

	json_table_temp[ "orderId" ] = _orderId
	json_table_temp[ "money" ] = tostring(_item_id*_money_rate)
	json_table_temp[ "moneyName" ] = item_name
	json_table_temp[ "exchangeRatio" ] = _money_rate
	json_table_temp[ "extInfo" ] = _extInfo

	require 'json/json'
	local jcode = json.encode(json_table_temp)
	send_message_to_java(jcode)
end

function PlatformBD:getLoginRet()
	return self.uid, self.token
end
