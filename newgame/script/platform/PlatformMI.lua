PlatformMI= {}
PlatformMI.MESSAGE_TYPE	= "platform"
PlatformMI.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformMI.FUNC_LOGIN		= "login"		--登录
PlatformMI.FUNC_PAY		= "pay"			--支付
PlatformMI.FUNC_TAB		= "tab"			--切换账号
PlatformMI.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformMI.FUNC_QUIT		= "quit"
PlatformMI.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformMI.CODE_SUCCESS = 0
PlatformMI.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformMI.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformMI:init()
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

	self.AppId = ''

	self.is_exit = true

end

-- login 的参数
function PlatformMI:get_login_param( account, dbip, server_id )
   local param = string.format("uid=%s&udid=%s&channel=%s&sub_channel=%s&plat=android&serverid=%s",
   	self.uid,GetSerialNumber(),self.platformId,self.platformId,server_id)
	print("获取小米登录参数",param)
	return param
   -- return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformMI:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
   -- return "session=" .. ZXLuaUtils:URLEncode(self.access_token) .. "&uid=" .. ZXLuaUtils:URLEncode(self.uid)
   print ("PlatformMI:get_login_param_json >>>")
   -- print (user_name)
   -- print (password)

   -- local str = string.format("account=%s&pw=%s", tostring(self.uid), md5("1")) 
   -- print (str)
   --local url = GameUrl_global:getServerIP() or ""
   local time = tostring(os.time())
   print (">>> ",self.platformId .. time .. self.appSecret)
   local sign = md5(self.platformId .. time .. self.appSecret)
   local str = string.format("uid=%s&time=%s&sign=%s&session=%s&appId=%s",
   							 self.uid, time, sign, self.session, self.appId)
   print (str)
   print (GameUrl_global:getServerIP(true))
   return  str
end



function PlatformMI:OnAsyncMessage( id, msg )
	-- ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	MUtils:toast("成功进入！", 2048, 2.5)
	--print("s,e",s,e)
	-- print "PlatformMI:OnAsyncMessage  >>>>"
	-- Utils:print_table(jtable)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		--print("message_type",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			--print("func_type",func_type)
			--print('error_code',error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登录成功", 2048, 2.5)
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					self.session = jtable["session"]
					self.appKey = jtable["appKey"]
					self.appId = jtable["appId"]
					self.appSecret = jtable["appSecret"]				
					self.platformId = jtable["platformId"]
									
					-- self.access_token = jtable[ "access_token" ] or ""
					-- self.expires_in = jtable[ "expires_in" ] or ""
					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登录失败", 2048, 2.5)
					self:try_login()		
				end
			elseif func_type == self.FUNC_QUIT then
				print "PlatformMI:OnAsyncMessage >>>> FUNC_QUIT"
				ZXGameQuit()
			end
		end
	end
	return false;
end


--平台主动行为封装 Begin
--支付
function PlatformMI:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end




function PlatformMI:payUICallback( info )

	-- HelpPanel:show( 3, UILH_NORMAL.title_tips, "内测期间不提供充值" )

	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 1
    -- local user_account = RoleModel:get_login_info().user_name

    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _userName = RoleModel:get_login_info().user_name
	local balance = player.yuanbao
	local partyName = ""
	local vipLevel = player.vipFlag

	local _serverId = RoleModel:get_login_info().server_id
	local _orderId = "tjxs_xiaomi_"..self.uid.."_".._serverId.."_"..os.time();
	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)
	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformMI.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformMI.FUNC_PAY
	--json_table_temp[ "outorderid" ] = _orderId
	json_table_temp[ "serverName" ] = RoleModel:get_server_name_had_login(  )
	json_table_temp[ "pext" ] = ""
	json_table_temp[ "userId" ] = _userId
	json_table_temp[ "userName" ] = _userName
	json_table_temp[ "userLevel" ] = player.level
	json_table_temp[ "money" ] = _item_id * _money_rate
	json_table_temp[ "balance" ] = balance
	json_table_temp[ "partyName" ] = partyName
	json_table_temp[ "vipLevel" ] = vipLevel
	json_table_temp[ "orderId" ] = self.uid .. "_" .. _serverId .. os.time()
	json_table_temp[ "arg_str" ] = string.format("user_level:%s,role_id:%s,server_id:%s,product_id:%s",
									player.level, player.id, _serverId, info.item_index)

	-- print "player >>>>"
	-- Utils:print_table(player)

	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformMI:getLoginRet()
	return self.uid, self.token
end

