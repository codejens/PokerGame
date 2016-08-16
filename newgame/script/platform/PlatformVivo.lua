PlatformVivo= {}
PlatformVivo.MESSAGE_TYPE	= "platform"
PlatformVivo.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformVivo.FUNC_LOGIN		= "login"		--登录
PlatformVivo.FUNC_PAY		= "pay"			--支付
PlatformVivo.FUNC_TAB		= "tab"			--切换账号
PlatformVivo.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformVivo.FUNC_QUIT		= "quit"		--退出
PlatformVivo.FUNC_INIT_ROLE	= "init_role"	--初始化保存角色信息
PlatformVivo.FUNC_USER_CENTER = "user_center"
PlatformVivo.FUNC_SWITCH_ACCOUNT = "swithc_account"
PlatformVivo.FUNC_ENTRY_PLATFORM = "enter_platform"

PlatformVivo.CODE_SUCCESS = 0
PlatformVivo.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformVivo.STATE_LOGIN_FAIL = 1	-- 失败

local job_name = {"刘秀","阴丽华"}
function PlatformVivo:init()
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.show_btn = 1
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()
	self.access_token = ""
	self.openId = ""
	self.user_name = ""
	self.AppId = ''


end


-- 拉取服务器列表的时候需要的参数
function PlatformVivo:get_login_param_json( account, dbip, server_id )

	local sign = "985c535d88d665de3c9b7b35b3244d8c"
	local time  = os.time()
    return 'uid='..self.uid..'&time='..os.time().."&authtoken="..self.access_token..'&sign='..md5("platform_vivo"..tostring(time)..sign)
end


--点击登录服务器真正登录服务器的时候
function PlatformVivo:get_login_param( )
	if GetSerialNumber then
		self.udid = GetSerialNumber()
	end
    local _serverId = RoleModel:get_login_info().before_serverid
    return "uid="..self.uid .. "&udid=" ..self.udid.. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel').."&sub_channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel').."&plat=".."android".."&serverid=".._serverId
end


function PlatformVivo:OnAsyncMessage( id, msg )
	ZXLog('PlatformVivo:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	-- MUtils:toast("成功进入！", 2048, 2.5)
	--print("s,e",s,e)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		--print("message_type",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			print("func_type",func_type)
			print('error_code',error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登录成功", 2048, 2.5)
					print("登录成功")
					self.name = jtable["name"] --name:帐户名
					self.uid = jtable["openid"] --openid：帐户唯一标识
					self.access_token = jtable["authtoken"] -- authtoken：第三方游戏用此token到vivo帐户系统服务端校验帐户信息
                    -- self:open_user_center()
					RoleModel:request_server_list_platform()
				else
					MUtils:toast("登录失败", 2048, 2.5)		
					self:try_login()		
				end
				return true
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
					MiscCC:send_quit_server()
					GameStateManager:set_state("login")
					-- RoleModel:send_name_and_pw(self.uid, self.access_token, nil, true)
					-- RoleModel:change_login_page("new_select_server_page")
			end
			return true
		end
	end
	MUtils:toast("登录失败", 2048, 2.5)
	return false;
end

--平台主动行为封装 Begin
--支付
function PlatformVivo:pay(...)
	local payWin = VIPModel:show_chongzhi_win();
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

-- 获取平台支付地址
function PlatformVivo:getPlatformPayUrl()

	_url = UpdateManager.order_url
	print("UpdateManager.order_url",_url)
	return _url
end

function PlatformVivo:payUICallback( info )
	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 100
	local time = os.time()
    -- local user_account = RoleModel:get_login_info().user_name
    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _serverId = RoleModel:get_login_info().server_id

	local _orderId = "platform_vivo".._userId.."_".._serverId.."_"..time;

	MUtils:toast("创建订单中...", 2048, 3)

    local function http_callback(err, message)
    	print("http_callback err",err,message)
		 if err == 0 then
			MUtils:lockScreen(false,2048)
			require 'json/json'
			local jtable = {}
			local s,e = pcall(function()
				jtable = json.decode(message)
			end)
			if not s then 
				-- ----print("进入 s")
				RoleModel:show_notice("创建订单失败，请重新尝试！["..RoleModel.json_error.."]") -- [425]="登录失败，请重新尝试！["
				MUtils:lockScreen(false,2048)
				PlatformInterface:logoutFromSelectServer()
				return 
			end
			--接口返回值为json格式 ，如果ret的值为1，则请求成功，反之失败
			local ret_code = jtable['ret'] 
			--创建订单成功
			print("ret_code",ret_code)
			if ret_code==1 or ret_code=="1" then
				MUtils:toast("成功创建订单",2048)
				local transNo = jtable['transNo'] --vivo订单号
				local accessKey = jtable['accessKey'] --订单推送接口返回的accessKey
				local price = jtable['price'] --单位 分  人民币
			    print("服务器回来的价格是",price)
				local pro_name = price*0.01 --元 
				local pro_des = price *0.1 --元宝
				local vip = VIPModel:get_vip_info( ).level

				--成功之后再启动收银台
				local json_table_temp = {}
				json_table_temp[ "message_type" ]	= PlatformVivo.MESSAGE_TYPE	--消息类型，必传字段
				json_table_temp[ "function_type" ] = PlatformVivo.FUNC_PAY
				json_table_temp[ "transNo" ] = transNo --订单推送接口返回的vivo订单号

				json_table_temp[ "accessKey" ] = accessKey --订单推送接口返回的accessKey
				json_table_temp[ "price" ] = price --商品价格，单位为分（1000即10.00元）
				json_table_temp[ "productName" ] =  pro_name.."元"--//商品名称

				json_table_temp[ "productDes" ] =pro_des.."元宝" --//商品描述
				json_table_temp[ "vip" ] = vip

				json_table_temp[ "level" ] = player.level
				json_table_temp[ "party" ] = player.guildName or ""  --世族名称
				json_table_temp[ "roleId" ] = _userId  --角色ID 
				json_table_temp[ "roleName" ] = player.name or "" --角色名称
				json_table_temp[ "serverName" ] =  RoleModel:get_server_name_had_login() or "" --服务器名称

				require 'json/json'
				local jcode = json.encode( json_table_temp )
				send_message_to_java( jcode )	
			else
				MUtils:toast("创建订单失败，请重新尝试！",2048)
			end
		 else
		 		MUtils:toast("网络错误，请重新尝试！",2048)
		 end
	end
	local url   = PlatformVivo:getPlatformPayUrl()
    local price = _item_id * _money_rate
    local des = _item_id*_money_rate *0.1
	local param ="&cpOrderNumber=".._orderId.."&orderAmount="..price.."&orderTitle=".._item_id.."元".."&orderDesc="..des.."元宝".."&extInfo=".."user_level:"..player.level..",role_id:".._userId..",server_id:".._serverId..",product_id:"..info.item_index
	-- print("发送商户服务器后台字段param",url,param)
	local http_request = HttpRequest:new(url, param, http_callback)
	http_request:send()
end


function PlatformVivo:getLoginRet()
	return self.uid, self.token
end


-- 打开用户中心
function PlatformVivo:open_user_center()

	local player = EntityManager:get_player_avatar()
	local _userId   = player.id

    local server_id = RoleModel:get_login_info().server_id
    local user_name = RoleModel:get_login_info().user_name
    local server_name = RoleModel:get_server_name_had_login()

    -- print("_userId  server_id player.level RoleModel:get_login_info().user_name  RoleModel:get_server_name_had_login()",_userId , server_id, player.level,user_name,server_name)

	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformVivo.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "roleId" ] = _userId  -- 游戏用于标识角色的id
	json_table_temp[ "roleLevel" ] = player.level  -- //角色等级
	json_table_temp[ "serviceAreaID" ] = server_id --//区服ID
	json_table_temp[ "roleName" ] = player.name or "" --//角色名称
	json_table_temp[ "serviceAreaName" ] = RoleModel:get_server_name_had_login() or ""--//区服名称
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
end


function PlatformVivo:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformVivo.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformVivo.FUNC_SWITCH_ACCOUNT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

