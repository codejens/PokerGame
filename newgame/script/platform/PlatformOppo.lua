PlatformOppo= {}
PlatformOppo.MESSAGE_TYPE	= "platform"
PlatformOppo.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformOppo.FUNC_LOGIN		= "login"		--登录
PlatformOppo.FUNC_PAY		= "pay"			--支付
PlatformOppo.FUNC_TAB		= "tab"			--切换账号
PlatformOppo.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformOppo.FUNC_INIT_ROLE	= "init_role"	--传送

PlatformOppo.CODE_SUCCESS = 0
PlatformOppo.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformOppo.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformOppo:init()
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
	self.callbackUrl = "http://xiulijiangshan.net/oppo/pay"

	self.is_exit = true
end



-- /**
-- * 提交角色信息参数说明
-- * @param service 当前玩家登录的区服ID
-- * @param gameId 当前玩家的角色ID
-- * @param role 当前玩家的角色名称
-- * @param grade 当前玩家的角色等级
-- */
function PlatformOppo:init_role_info()
	local login_info = RoleModel:get_login_info()
	local service = login_info.server_id
	local serverName = RoleModel:get_server_name_had_login(  )
	local player = EntityManager:get_player_avatar()
	local gameId = player.id
	local role = player.name
	local grade = player.level
	local balance = player.yuanbao
	local partyName = ""
	local vipLevel = player.vipFlag
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformOppo.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformOppo.FUNC_INIT_ROLE
	json_table_temp[ "gameId" ] =  self.appId --tostring(gameId)
	json_table_temp[ "service" ] = tostring(service)
	json_table_temp[ "role" ] = role
	json_table_temp[ "grade" ] = tostring(grade)
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

-- login 的参数
function PlatformOppo:get_login_param( account, dbip, server_id )
    local param = string.format("uid=%s&udid=%s&channel=%s&sub_channel=%s&plat=android&serverid=%s",
   	self.uid,GetSerialNumber(),self.platformId,self.platformId,server_id)
	print("获取OPPO登录参数",param)
	return param
end

function PlatformOppo:get_login_param_json( )
   print ("PlatformOppo:get_login_param_json >>>")
   -- print (user_name)
   -- print (password)

   -- local str = string.format("account=%s&pw=%s", tostring(self.uid), md5("1")) 
   -- print (str)
   --local url = GameUrl_global:getServerIP() or ""
   local time = tostring(os.time())
   print (">>> ",self.platformId .. time .. self.appSecret)
   local sign = md5(self.platformId .. time .. self.appSecret)
   local str = string.format("uid=%s&time=%s&sign=%s&token=%s&appId=%s&ssoid=%s",
   							 self.uid, time, sign, self.session, self.appId, self.uid)
   print (str)
   print (GameUrl_global:getServerIP(true))
   return  str
end

function PlatformOppo:OnAsyncMessage( id, msg )
	-- ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	--print("s,e",s,e)
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
					MUtils.toast("登录成功", 2048, 2.5)
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]

					self.appSecret = jtable["appSecret"]				
					self.platformId = jtable["platformId"]
					self.session = jtable["session"]
					self.appId = jtable["appId"]

					print "OnAsyncMessage >>> 登录成功"
					RoleModel:request_server_list_platform()
				else
					MUtils.toast("登录失败", 2048, 2.5)
					self:doLogin()			
				end
			elseif func_type == self.FUNC_CHANGE_ACCOUNT then
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					self.user_name = jtable["name"]
					MiscCC:send_quit_server()
					GameStateManager:set_state("login")
					--RoleModel:send_name_and_pw(self.uid, self.access_token, nil, true)
					--RoleModel:change_login_page("new_select_server_page")
					
				-- self.access_token = jtable["token"]
				-- self.uid = jtable["uid"]
				-- self.user_name = jtable["name"]
					-- json.put("name", bundle.getString("username"));
					-- json.put("username", bundle.getString(SQwanCore.LOGIN_KEY_USERNAME));
					-- json.put("uid", bundle.getString(SQwanCore.LOGIN_KEY_USERID));
					-- json.put("token", bundle.getString(SQwanCore.LOGIN_KEY_TOKEN));				
				-- GameStateManager:back_to_login()

			end
			
		end
	end
	return false;
end

--平台主动行为封装 Begin
--支付
function PlatformOppo:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
	if payWin == nil then 
	   return
	end


	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end



--支付
--          /**
--           * 支付接口参数说明
--           * !!! 注意必传参数,不能为空，推荐所有参数都传值 !!!
--           * 
--           * @param context 上下文 (*必传)
--           * @param doid CP订单ID (*必传)
--           * @param dpt CP商品名
--           * @param dcn CP货币名称 
--           * @param dsid CP游戏服ID (*必传)
--           * @param dsname CP游戏服名称
--           * @param dext CP扩展回调参数 (*必传)
--           * @param drid CP角色ID
--           * @param drname CP角色名
--           * @param drlevel CP角色等级
--           * @param dmoney CP金额(定额) (*必传)
--           * @param dradio CP兑换比率(1元兑换率默认1:10)
--           * @param payListener 充值回调 (*必传)
--           */
-- outorderid= resultJson.getString("outorderid");
-- itemName = resultJson.getString("itemName");
-- moneyName = resultJson.getString("moneyName");
-- serverId= resultJson.getString("serverId");
-- serverName = resultJson.getString("serverName");	
-- pext= resultJson.getString("pext");  // 扩展字段  服务器会原样返回给游戏服务器（可选）
-- userId= resultJson.getString("userId");	
-- userName = resultJson.getString("userName");
-- userLevel = (int) resultJson.getInt("userLevel");
-- money = (float) resultJson.getDouble("money");
-- moneyRate = (int) resultJson.getInt("moneyRate");
function PlatformOppo:payUICallback( info )

	-- HelpPanel:show( 3, UILH_NORMAL.title_tips, "内测期间不提供充值" )

	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 100
    -- local user_account = RoleModel:get_login_info().user_name

    local _item_id  = info.item_id
    local player = EntityManager:get_player_avatar()
	local _userId   = player.id
	local _userName = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id
	local _dext = player.id

	--print("chj:", _item_id, player, self.uid, _userName, _serverId, _dext )
	local _orderId = "xljs_oppo_"..self.uid.."_".._serverId.."_"..os.time();

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)
	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformOppo.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformOppo.FUNC_PAY

	-- json_table_temp[ "outorderid" ] = _orderId
	-- -- json_table_temp[ "itemName" ] = string.format("%d元宝",_item_id)
	-- json_table_temp[ "moneyName" ] = "元宝"
	-- -- json_table_temp[ "serverId" ] = _serverId
	-- -- json_table_temp[ "serverName" ] = RoleModel:get_server_name_had_login(  )
	-- json_table_temp[ "pext" ] = _dext
	-- -- json_table_temp[ "userId" ] = _userId
	-- -- json_table_temp[ "userName" ] = _userName
	-- -- json_table_temp[ "userLevel" ] = player.level
	-- json_table_temp[ "money" ] = _item_id
	-- json_table_temp[ "moneyRate" ] = _money_rate
	-- --print("chj:", PlatformOppo.MESSAGE_TYPE, PlatformOppo.FUNC_PAY, _orderId, _item_id, _money_rate )
	local item_name = ""
	if info.monthcard_name ~= nil then
		item_name = info.monthcard_name
	else
		item_name = "元宝"
	end	
	--
	json_table_temp[ "callbackUrl" ] = self.callbackUrl
	json_table_temp[ "user_level" ] = player.level
	json_table_temp[ "role_id" ] = player.id
	json_table_temp[ "server_id" ] = _serverId
	json_table_temp[ "product_id" ] = info.item_index 
	json_table_temp[ "moneyName" ] = item_name
	json_table_temp[ "money" ] = _item_id *_money_rate
	json_table_temp[ "orderId" ] = self.uid .. "_" .. _serverId .. os.time()

	json_table_temp[ "arg_str" ] = string.format("user_level:%s,role_id:%s,server_id:%s,product_id:%s,uid:%s",
		player.level, player.id, _serverId, info.item_index , self.uid) 

	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformOppo:getLoginRet()
	return self.uid, self.token
end

