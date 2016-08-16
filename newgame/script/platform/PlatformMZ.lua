--魅族
--PlatformMZ.lua

PlatformMZ = {}
--消息类型
PlatformMZ.MESSAGE_TYPE			= "platform"
--分发类型
PlatformMZ.FUNC_LOGIN				= "login"		--登录
PlatformMZ.FUNC_LOGIN_FAIL			= "login_fail"		--登录
PlatformMZ.FUNC_PAY				= "pay"			--支付
PlatformMZ.FUNC_QUIT        		= "quit"        --退出平台
PlatformMZ.FUNC_PAY_BACK     		= "pay_back"    --充值返回
PlatformMZ.FUNC_PAY_NEED_LOGIN    = "pay_need_login"    --充值时 登录状态失效需要玩家重新登录
PlatformMZ.FUNC_PAY_NEED_LOGIN 	= "pay_need_login"
PlatformMZ.FUNC_PAY_RESULT		= "pay_result"
PlatformMZ.FUNC_NOTIC_INFO		= "notic_info"

PlatformMZ._task_market_url		= "http://entry.tjxs.m.hoolaigames.com:8099/market/yyb/collect?"


-- local _wxRefreshToken = ""
--初始化
function PlatformMZ:init(callbackfunc)
	self.firstLogin = true
	self.logoutable = true
	self.loginRet = nil
	self.login_type = nil
	self.uid = ""
	self.sid = ""
	if callbackfunc then callbackfunc() end

	self.is_exit  = true
end

-- login 的参数
function PlatformMZ:get_login_param( account, dbip, server_id )
	local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
	local str_login_param = "uid="..tostring(self.uid).."&udid="..tostring(udid).."&channel=".."platform_meizu".."&sub_channel=".."platform_meizu".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
	return str_login_param
end

function PlatformMZ:get_login_param_json( )
	local time = os.time()
	local param = "time="..tostring(time).."&sign="..md5("platform_meizu"..tostring(time).."LObdv2tVZkwtl6iHiVYPSdkFubeWtFd6").."&uid="..self.uid.."&session_id="..self.sid
	return param
end



--初始化登录的服务器信息
function PlatformMZ:set_server_info( server_info )
	self.loginRet = server_info 
end
--JSON消息接收与处理
function PlatformMZ:OnAsyncMessage( id, msg )
	--print("PlatformMZ:OnAsyncMessage",id, msg)
	--过滤掉不是平台返回的信息
	if id ~= AsyncMessageID.eMsgPhoneMessge then 
		return 
	end 
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		if message_type == PlatformMZ.MESSAGE_TYPE then
			local funcType = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			if funcType == PlatformMZ.FUNC_LOGIN then
				if error_code == 0 then
					--登录
					self.uid = jtable["uid"] or "";
					self.sid = jtable["sid"] or "";
					RoleModel:request_server_list_platform()
				else
					self:try_login()
				end
			elseif funcType == PlatformMZ.FUNC_LOGIN_FAIL then
				local error_msg = jtable["errorMsg"] or ""
				-- MUtils:toast( error_msg, 2048 )
				GlobalFunc:create_screen_notic("登录失败")
			elseif funcType == PlatformMZ.FUNC_PAY_BACK then
				local code = jtable[ "code" ] or 0
				if 0 == tonumber(code) then
					GlobalFunc:create_screen_notic("支付成功")
				else
					local errMsg = jtable[ "msg" ] or ""
					GlobalFunc:create_screen_notic("支付失败")
				end
			elseif funcType ==  PlatformMZ.FUNC_PAY_NEED_LOGIN then 
				--登录失效。需要重新登录
				-- ZXLog("登录失效。需要重新登录")
				GameStateManager:back_to_login()
			elseif funcType == PlatformMZ.FUNC_QUIT then
				QuitGame()
			end
		end
	end
end


--支付
function PlatformMZ:payUICallback( info )
	local item_price 	= tostring(info.item_id)
	local item_id  		= info.item_index

	local login_info 	= RoleModel:get_login_info()
	local serverId 		= login_info.server_id
	local player 		= EntityManager:get_player_avatar()
	local roleName 		= player.name
	local time 			= os.time()
	local orderId 		= "meizu" .. self.uid .. tostring(serverId) .. time
	local product_body 	= "无"
	local product_id 	= item_id
	local product_subject 	= string.format("购买%s个元宝", item_price*10)
	local product_unit 	= "个"
	local buy_amount  	= 1
	local pay_type 		= 0
	local appid 		= "3093260"
	local appSecret		= "LObdv2tVZkwtl6iHiVYPSdkFubeWtFd6"
	local user_info 	= "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(serverId)..",product_id:"..tostring(info.item_index)..",uid:"..self.uid 
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformMZ.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] 	= PlatformMZ.FUNC_PAY              --分发类型，必传字段
	json_table_temp[ "orderId" ] 		= orderId
	json_table_temp[ "uid"] 			= self.uid
	json_table_temp[ "buy_amount"] 		= buy_amount
	json_table_temp[ "create_time"] 	= time
	json_table_temp[ "pay_type"] 		= pay_type
	json_table_temp[ "product_body"] 	= product_body
	json_table_temp[ "product_id"]		= item_id
	json_table_temp[ "product_subject"]	= product_subject
	json_table_temp[ "product_unit"]	= product_unit
	json_table_temp[ "total_price"] 	= item_price
	json_table_temp[ "user_info"] 		= user_info
	local sign_str = "app_id=" .. appid
	sign_str = sign_str .. "&buy_amount=" .. buy_amount
	sign_str = sign_str .. "&cp_order_id=" .. orderId
	sign_str = sign_str .. "&create_time=" .. time
	sign_str = sign_str .. "&pay_type=" .. pay_type
	sign_str = sign_str .. "&product_body=" .. product_body
	sign_str = sign_str .. "&product_id=" .. product_id
	sign_str = sign_str .. "&product_per_price=" .. item_price
	sign_str = sign_str .. "&product_subject=" .. product_subject
	sign_str = sign_str .. "&product_unit=" .. product_unit
	sign_str = sign_str .. "&total_price=" .. item_price
	sign_str = sign_str .. "&uid=" .. self.uid
	sign_str = sign_str .. "&user_info=" .. user_info
	sign_str = sign_str .. ":" .. appSecret
	-- local sign_str = string.format("app_id=3093260&buy_amount=%d&cp_order_id=%s&create_time=%d&pay_type=%d&product_body=&product_id=%d&product_per_price=%s&product_subject=%s&product_unit=&total_price=%s&uid=%s&user_info=%s:%s", 
	-- 	buy_amount,orderId,time,pay_type,product_id,item_price,product_subject,item_price,tostring(self.uid), user_info, "LObdv2tVZkwtl6iHiVYPSdkFubeWtFd6")
	local sign = md5(sign_str)
	json_table_temp[ "sign"] 		= sign
	json_table_temp[ "sign_type"] 	= "md5"

	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

