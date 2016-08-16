PlatformHuaWei= {}

PlatformHuaWei.MESSAGE_TYPE	= "platform"

PlatformHuaWei.FUNC_CHANGE_ACCOUNT = "change_account"

PlatformHuaWei.FUNC_LOGIN		= "login"		--登录

PlatformHuaWei.FUNC_PAY		= "pay"			--支付

PlatformHuaWei.FUNC_TAB		= "tab"			--切换账号
PlatformHuaWei.FUNC_QUIT 	= "quit" 		--退出
PlatformHuaWei.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformHuaWei.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformHuaWei.FUNC_CREATE		= "create_role" --创建角色
PlatformHuaWei.FUNC_ENTERGAME	= "enter_game" --进入游戏
PlatformHuaWei.FUNC_LEVELUP	= "level_up" --人物升级
PlatformHuaWei.FUNC_LOGINSUCCESS = "login_success" --登录成功后 要告诉平台 游戏版本更新
PlatformHuaWei.CODE_SUCCESS = 0
PlatformHuaWei.INIT_SLIDER = "init_slider"

PlatformHuaWei.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformHuaWei.STATE_LOGIN_FAIL = 1	-- 失败

PlatformHuaWei.STATE_LOGIN_CANCLE = 2	-- 失败



-- 不准许有全局参数，因为需要被reload

--

--


function PlatformHuaWei:init()

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

	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>HuaWei")

	self.AppId = ''

	self.channel = ""
	self.plat = ""
	self.uuid = ""
	self.subchannel = ""


end


-- @param:是否进入或者离开游戏场景,true：进入,false:离开

function PlatformHuaWei:onEnterGameScene(isEnter)

	if isEnter == true then
	    local player = EntityManager:get_player_avatar()
	    local server_info = RoleModel:get_server_date_by_id(login_info.server_id)

		local json_table_temp = {}
		json_table_temp[ "message_type" ]  = PlatformHuaWei.MESSAGE_TYPE	--消息类型，必传字段
		json_table_temp[ "function_type" ] = PlatformHuaWei.FUNC_ENTERGAME
		-- json_table_temp[ "roleId" ] = roleId
		-- json_table_temp[ "serverId" ] = "ppsmobile_s"..serverId
		-- json_table_temp[ "roleName" ] = roleName
		-- json_table_temp[ "serverName"] = serverName
		-- json_table_temp[ "roleLevel"] = roleLevel
		json_table_temp["level"] = player.level or ""
		json_table_temp["name"] = player.name or ""
		json_table_temp["serverId"] = server_info.server_id or ""
		json_table_temp["guildName"] = player.guildName or ""

	    require 'json/json'
		local jcode = json.encode( json_table_temp )
		send_message_to_java( jcode )
    else

	end
end

function PlatformHuaWei:init_role_info()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = login_info.user_name or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformHuaWei.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformHuaWei.FUNC_ENTERGAME
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "serverId" ] = "ppsmobile_s"..serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "roleLevel"] = roleLevel
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformHuaWei:onPlayerLevelUp()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = login_info.user_name or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformHuaWei.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformHuaWei.FUNC_LEVELUP
	json_table_temp[ "roleId" ] = roleId
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "roleLevel"] = roleLevel
	require 'json/json'
	-- GlobalFunc:create_screen_notic("人物升级send_message_to_java")
	-- MUtils:toast("人物升级send_message_to_java",2048,2.5) -- [69]="请求登录授权"
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformHuaWei:get_login_param( account, dbip, server_id )

	local login_info = RoleModel:get_login_info()
	local udid = GetSerialNumber()
	self.uid = GameUrl_global:get_userID()
	-- print("self.uid =============>>>>>>>>>>>", self.uid)
 	local str_login_param = "uid="..tostring(self.uid).."&udid="..tostring(udid).."&channel=".."platform_huawei".."&sub_channel=".."platform_huawei".."&plat=".."android".."&serverid="..tostring(login_info.before_serverid)
  	return str_login_param

end



function PlatformHuaWei:get_login_param_json( user_name, password )

	local time = os.time()

    return "uid="..self.access_token.."&time="..tostring(time).."&sign="..md5("platform_huawei"..tostring(time).."r4ipjqu7k8g4pn1fw6c8mqmehrxhf5ef").."&accessToken="..self.access_token

end

--平台主动行为封装 Begin

--支付

function PlatformHuaWei:pay(...)

	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	--paywin里直接调用payUICallback
	-- payWin:setCallback(function(which)

	-- 		self:payUICallback({ item_id = which, window = 'pay_win' })

	-- 	end)
	
end


--支付
function PlatformHuaWei:payUICallback( info )
	-- HelpPanel:show( 3, UILH_NORMAL.title_tips, "内测期间不提供充值" )
	require 'model/iOSChongZhiModel'
	--iOSChongZhiModel:purchase_product( info.item_id )
	local _money_rate = 10
    -- local user_account = RoleModel:get_login_info().user_name
    local player = EntityManager:get_player_avatar()
    local game_money  = info.item_id 		--元宝数量
    -- local recharge_type = info.recharge_type or 0 	--充值类型,0普通,1双倍,2其它
    -- local desc = ""
    -- local actual_money = game_money
 --    if recharge_type == 0 then
 --    	desc = game_money .. "元宝"
	-- elseif recharge_type == 1 then
	-- 	desc = "活动双倍元宝，一共" .. game_money .. "元宝"
	-- 	actual_money = game_money*2
 --    end

    local player = EntityManager:get_player_avatar()

	local _userId   = player.id

	-- local pay_rsa_private = GameUrl_global:get_rsa_private()
	-- local _userName = RoleModel:get_login_info().user_name

	-- local balance = player.yuanbao

	-- local partyName = ""

	-- local vipLevel = player.vipFlag

	local _serverId = RoleModel:get_login_info().server_id
	_serverId = tostring(_serverId)

	local _privateField = "cycs_android_"..self.uid.."_".._serverId;

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)

	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )


	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformHuaWei.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformHuaWei.FUNC_PAY

	json_table_temp["request_id"] = "huawei_"..tostring(_userId).."_"..tostring(_serverId).."_"..os.time();
	
	-- json_table_temp[ "ResultUrl" ] = "http://entry.tjxs.m.shediao.com/zhangshang/SD_zhangshang_tianjiang/paycallback"
	-- json_table_temp[ "amount" ] = game_money 	--充值或支付金额（现实货币），单位为 元
	json_table_temp[ "amount" ] = game_money..".00" 	--充值或支付金额（现实货币），单位为 元

	local item_name = ""
	if info.monthcard_name ~= nil then
		item_name = info.monthcard_name
	else
		item_name = game_money*_money_rate.."元宝"
	end
	json_table_temp[ "quantity" ] = 1 						--购买产品数量（商品个数），默认为1

	json_table_temp[ "product_id"] = info.item_index 		--商品唯一标识id

	json_table_temp[ "virtual_quantity"] = game_money*_money_rate		--购买产品的虚拟货币数量（如：10元购买100元宝，则为100；或10元购买1000元宝，则为1000），默认为amount（充值显示货币金额）*10

	json_table_temp[ "product_name" ] =  item_name --商品名称

	json_table_temp[ "item_desc" ] = game_money*_money_rate.."元宝" 	--商品详细描述

	json_table_temp[ "server_id" ] = _serverId 				--服务器Id，默认1

	json_table_temp[ "currency" ] = "rmb"

	local uid = GameUrl_global:get_userID()
	json_table_temp[ "extra" ] = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index)..",uid:"..tostring(uid)

	-- print("extra===========>>>>>>", json_table_temp[ "extra" ])
	json_table_temp["roleId"] = _userId

	-- json_table_temp["pay_rsa_private"] = pay_rsa_private
	-- json_table_temp[ "UserID" ] = self.uid

	-- json_table_temp[ "OrderNo" ] = "shengcai_"..os.time()
	
	require 'json/json'

	-- print("iqiyiPayment==========>>>>  ", game_money, _userId, _serverId, json_table_temp[ "extra" ])

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )
end

--创建角色
function PlatformHuaWei:create_role_info(create_role_info)

	MUtils:toast("创建角色", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformHuaWei.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformHuaWei.FUNC_CREATE
	json_table_temp[ "roleId" ] = create_role_info.roleId or ""
	json_table_temp[ "serverId" ] = "ppsmobile_s"..create_role_info.serverId or ""
	json_table_temp[ "roleName" ] = create_role_info.roleName or ""
	json_table_temp[ "serverName"] = create_role_info.serverName or ""
	json_table_temp[ "roleLevel"] = create_role_info.roleLevel or ""
	json_table_temp[ "uuid" ] = self.uuid
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformHuaWei:init_slider()
	local json_table_temp = {}
	json_table_temp["message_type"] = PlatformHuaWei.INIT_SLIDER
	local jcode = json.encode(json_table_temp)
	send_message_to_java(jcode)
end


function PlatformHuaWei:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformHuaWei.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformHuaWei.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end




function PlatformHuaWei:getLoginRet()

	return self.uid, self.token

end


function PlatformHuaWei:OnAsyncMessage( id, msg )
	-- print("做了PlatformHuaWei:OnAsyncMessage===>>>")
	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	-- print("s,e===========PlatformHuaWei:OnAsyncMessage=========>>>",s,e,msg)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		-- print("message_type",message_type, self.MESSAGE_TYPE)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			-- print("func_type",func_type, self.FUNC_LOGIN, error_code, self.CODE_SUCCESS)
			--print('error_code',error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					-- MUtils:toast("登录成功", 2048, 2.5)
					-- self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					self.access_token = jtable[ "accessToken" ] or ""
					-- -- self.expires_in = jtable[ "expires_in" ] or ""
					if self.access_token and self.access_token ~= "" then
						RoleModel:request_server_list_platform()
					end
					-- print("运行了PlatformHuaWei:OnAsyncMessage( id, msg )===>>>", self.uid, self.access_token)
					-- RoleModel:change_login_page( 'new_select_server_page' )
					-- RoleModel:send_name_and_pw( self.uid, self.pwd,self.password_changed, true )
					-- print("1111111111111111")
					
					-- print("22222222222222")
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
				end
				AIManager:set_AIManager_idle()
				GameStateManager:set_state("login")
				if error_code == self.CODE_SUCCESS then
					self.access_token = jtable["token"]
					self.uid = jtable["uid"]
					RoleModel:request_server_list_platform()
				end
				-- RoleModel:change_login_page("new_select_server_page")
			elseif func_type == self.FUNC_TOAST then
				local toast = jtable["toast"]
				MUtils:toast(toast, 2048, 2.5)
			elseif func_type == self.FUNC_QUIT then
				ZXGameQuit()
			end	
		end
	end
	return false;
end

function PlatformHuaWei:platfotm_set_uid( uid )
 	self.access_token = uid
 end 