PlatformPk= {}
PlatformPk.MESSAGE_TYPE	= "platform"
PlatformPk.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformPk.FUNC_LOGIN		= "login"		--登录
PlatformPk.FUNC_PAY		= "pay"			--支付
PlatformPk.FUNC_TAB		= "tab"			--切换账号
PlatformPk.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformPk.FUNC_QUIT		= "quit"
PlatformPk.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformPk.CODE_SUCCESS = 0
PlatformPk.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformPk.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
function PlatformPk:init()
	self.appKey = "ce51bfb1fcd62efc7ee1e5b75bde111d"
end

-- login 的参数
function PlatformPk:get_login_param( account, dbip, server_id )
   local param = string.format("uid=%s&udid=%s&channel=%s&sub_channel=%s&plat=android&serverid=%s",
   	self.uid,GetSerialNumber(),Target_Platform,Target_Platform,server_id)
	return param
   -- return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformPk:get_login_param_json( )
   local time = tostring(os.time())
   --print (">>> ",self.platformId .. time .. self.appKey)
   local sign = md5(Target_Platform .. time .. self.appKey)
   local str = string.format("uid=%s&time=%s&sign=%s&token=%s",
   							 self.uid, time, sign,self.token)
   print (str)
   return  str
end


function PlatformPk:OnAsyncMessage( id, msg )
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
					self.uid = jtable["account_id"]
					self.token = jtable["token"]
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

function PlatformPk:payUICallback( info )

	require 'model/iOSChongZhiModel'
	local _money_rate = 10

    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _userName = RoleModel:get_login_info().user_name
	local balance = player.yuanbao
	local partyName = ""
	local vipLevel = player.vipFlag

	local _serverId = RoleModel:get_login_info().server_id
	local _orderId = "xljs_93pk_"..self.uid.."_".._serverId.."_"..os.time();
	local item_name = ""
	if info.monthcard_name ~= nil then
		item_name = info.monthcard_name
	else
		item_name = _item_id*_money_rate.."元宝"
	end

	local param = string.format("user_level:%s,role_id:%s,server_id:%s,product_id:%s",
		player.level,player.id,_serverId,info.item_index)

	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= self.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = self.FUNC_PAY
	json_table_temp[ "exorderno" ] = param--_orderId
	json_table_temp[ "price" ] = _item_id*100--0.1*100
	json_table_temp[ "goodName" ] = item_name

	json_table_temp[ "extra" ] = param
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


