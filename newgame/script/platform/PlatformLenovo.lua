PlatformLenovo= {}
PlatformLenovo.MESSAGE_TYPE	= "platform"
PlatformLenovo.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformLenovo.FUNC_LOGIN		= "login"		--登录
PlatformLenovo.FUNC_PAY		= "pay"			--支付
PlatformLenovo.FUNC_TAB		= "tab"			--切换账号
PlatformLenovo.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformLenovo.FUNC_QUIT		= "quit"
PlatformLenovo.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformLenovo.CODE_SUCCESS = 0
PlatformLenovo.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformLenovo.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
function PlatformLenovo:init()
	self.is_exit = true
	self.token = ""
end

-- login 的参数
function PlatformLenovo:get_login_param( account, dbip, server_id )
   local param = string.format("uid=%s&udid=%s&channel=%s&sub_channel=%s&plat=android&serverid=%s",
   	self.uid,self.DeviceID,self.platformId,self.platformId,server_id)
	return param
   -- return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformLenovo:get_login_param_json( )
   local time = tostring(os.time())
   --print (">>> ",self.platformId .. time .. self.appKey)
   local sign = md5(self.platformId .. time .. self.appKey)
   local str = string.format("uid=%s&time=%s&sign=%s&Token=%s",
   							 self.token, time, sign,self.token)
   print (str)
   return  str
end


function PlatformLenovo:OnAsyncMessage( id, msg )
	print("-----PlatformLenovo:OnAsyncMessage----------",id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)

	if s then
		local message_type = jtable[ "message_type" ] or ""
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL

			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if tonumber(error_code) == self.CODE_SUCCESS then
					self.uid = jtable["uid"]
					self.token = jtable["uid"]
					self.appKey = jtable["appKey"]
					self.appId = jtable["appId"]
					self.platformId = jtable["platformId"]
					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登录失败", 2048, 2.5)	
					self:try_login()			
				end
			elseif func_type == self.FUNC_QUIT then
				ZXGameQuit()
			end
		end
	end
	return false;
end

local _waresid_info = {
	[1]=69096,[2]=69097,[3]=69098,[4]=69099,[5]=69100,[6]=69101,[7]=86109,[8]=86110,
	[20]=69102,[21]=69103,
}

function PlatformLenovo:payUICallback( info )

	require 'model/iOSChongZhiModel'
	local _money_rate = 1
	if not _waresid_info[info.item_index]  then
		return
	end
    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _userName = RoleModel:get_login_info().user_name
	local balance = player.yuanbao
	local partyName = ""
	local vipLevel = player.vipFlag

	local _serverId = RoleModel:get_login_info().server_id
	local _orderId = "xljs_lenovo_"..self.uid.."_".._serverId.."_"..os.time();

	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= self.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = self.FUNC_PAY
	json_table_temp[ "exorderno" ] = _orderId
	json_table_temp[ "price" ] = _item_id * _money_rate
	json_table_temp[ "waresid" ] = _waresid_info[info.item_index]  --后台配置的商品id
	json_table_temp[ "notifyurl" ] = ""
	local param = string.format("user_level:%s,role_id:%s,server_id:%s,product_id:%s,uid:%s",
		player.level,player.id,_serverId,info.item_index,self.uid)
	json_table_temp[ "extra" ] = param
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--入口返回参数
function PlatformLenovo:set_back_param( AccountID,Username,DeviceID,verified )
	print("入口返回参数",AccountID,Username,DeviceID,verified)
	self.uid = AccountID
	self.token = AccountID
	self.Username = Username
	self.DeviceID = DeviceID
end

