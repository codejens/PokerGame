PlatformUU= {}

PlatformUU.MESSAGE_TYPE	= "platform"

PlatformUU.FUNC_CHANGE_ACCOUNT = "change_account"

PlatformUU.FUNC_LOGIN		= "login"		--登录

PlatformUU.FUNC_PAY		= "pay"			--支付

PlatformUU.FUNC_TAB		= "tab"			--切换账号
PlatformUU.FUNC_QUIT 	= "quit" 		--退出
PlatformUU.FUNC_LOGIN_OUT	= "login_out"	--登出

PlatformUU.FUNC_USER_CENTER	= "user_center"	--传送
PlatformUU.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformUU.FUNC_CREATE		= "create_role" --创建角色
PlatformUU.FUNC_ENTERGAME	= "enter_game" --进入游戏
PlatformUU.FUNC_LEVELUP	= "level_up" --人物升级
PlatformUU.FUNC_LOGINSUCCESS = "login_success" --登录成功后 要告诉平台 游戏版本更新
PlatformUU.CODE_SUCCESS = 0

PlatformUU.STATE_LOGIN_SUCCESS = 0 -- 成功

PlatformUU.STATE_LOGIN_FAIL = 1	-- 失败

PlatformUU.STATE_LOGIN_CANCLE = 2	-- 失败



-- 不准许有全局参数，因为需要被reload

--

--固定随机毫秒
local function _rand_time( time )
	local b = math.ceil(time%1000000)
	local q1=  math.ceil(b/1000)
	local q2=  math.ceil(b/10000)
	local q3=  math.ceil(b/100000)
	local q4=q1+q2+q3
	q4 = q4%1000
	q4 = string.format("%03d",q4)
	return q4
end

function PlatformUU:init()

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

	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>U9")

	self.AppId = ''

	self.channel = ""
	self.plat = ""
	self.uuid = ""
	self.subchannel = ""

end



function PlatformUU:init_role_info()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	if not player then
		return
	end
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = login_info.user_name or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUU.FUNC_ENTERGAME
	json_table_temp[ "roleId" ] = player.id
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "roleLevel"] = roleLevel
	local time = SelectRoleCC:get_role_time(player.id)
    time=math.floor(time).._rand_time(time)..""
	json_table_temp[ "time"] = time
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformUU:onPlayerLevelUp()
	local login_info = RoleModel:get_login_info()
	local player = EntityManager:get_player_avatar()
	local server_info = RoleModel:get_server_date_by_id(login_info.server_id)
	local roleId = login_info.user_name or "" 	--user_name 就是uid
	local roleName = player.name or ""
    local serverId = server_info.server_id or ""
    local serverName = server_info.server_name or ""
    local roleLevel = player.level or "1"
    local time = SelectRoleCC:get_role_time(player.id)
    time=math.floor(time).._rand_time(time)..""
    local ltime =  (QianDaoModel:get_server_time() + MINI_DATE_TIME_BASE)
    ltime = math.floor(ltime).._rand_time(ltime)..""
    local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUU.FUNC_LEVELUP
	json_table_temp[ "roleId" ] = player.id
	json_table_temp[ "serverId" ] = serverId
	json_table_temp[ "roleName" ] = roleName
	json_table_temp[ "serverName"] = serverName
	json_table_temp[ "roleLevel"] = roleLevel
	json_table_temp[ "time"] = time
	json_table_temp[ "leveltime"] =ltime
	
	require 'json/json'
	-- GlobalFunc:create_screen_notic("人物升级send_message_to_java")
	-- MUtils:toast("人物升级send_message_to_java",2048,2.5) -- [69]="请求登录授权"
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

-- login 的参数

function PlatformUU:get_login_param( account, dbip, server_id )
	--http://183.57.57.156:58010/base/login?uid=9&channel=platform_u9_andriod&serverid=1   登录地址
	local str_login_param = 'uid='..self.uid.."&channel=" .. PlatformInfoForBISystem:getDownloadFrom() .. '&serverid='..server_id .. '&udid=' .. self.uuid .. "&sub_channel=" .. PlatformInfoForBISystem:getDownloadChannel() .. "&plat=" .. self.plat
	-- local str_login_param = string.format("uid=%s&channel=%s&serverid=%s&udid=%s&sub_channel=%s&plat=%s",
	-- 	self.uid,PlatformInfoForBISystem:getDownloadFrom(),server_id,self.uuid,self.sub_channel,self.plat)
    -- print("zengsi str_login_param=",str_login_param)
    return str_login_param

end


function PlatformUU:get_login_param_json( )
	-- ConfirmWin2:show(1,nil,"roleName=" .. roleName .. ",player.name=" .. player.name)
	local time = os.time()
    return "token=" ..self.token.. "&is_test=false" .."&channel=" .. PlatformInfoForBISystem:getDownloadFrom().."&uid="..self.uid .. "&time="..tostring(time).."&sign="..md5("u9"..tostring(time).."f667b7492a9847c9930d66098a8875d9")
end

--登出

function PlatformUU:logout(callbackfunc)

	-- --print("run loginout11111")

	if callbackfunc then

		callbackfunc()

	end

	-- --print("run loginout22222")

	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformUU.FUNC_LOGIN_OUT

	require 'json/json'

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )	

	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'



end


function PlatformUU:OnAsyncMessage( id, msg )

	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)

	require 'json/json'

	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)

		local message_type = jtable[ "message_type" ] or ""
	print("--------PlatformUU:OnAsyncMessage---message_type=",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "funcType" ] or ""
			local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			print("zengsi func_type,error_code",func_type,error_code)
			if func_type == self.FUNC_LOGIN then -- 登录、切换成功的处理
				if error_code == self.CODE_SUCCESS then
					MUtils:toast("登录成功", 2048, 2.5)
					self.token = jtable["token"]
					self.uid = jtable["uid"]
					local memory = jtable["memory"]
					self.channel = jtable["channel"]
					self.plat = jtable["plat"]
					self.uuid = jtable["uuid"]
					self.subchannel = jtable["subchannel"]
					RoleModel:set_login_info("user_name",self.uid)
					RoleModel:set_phone_memory(memory)
					
					local json_table_temp = {}
					json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
					json_table_temp[ "function_type" ] = PlatformUU.FUNC_LOGINSUCCESS
					require 'json/json'
					local jcode = json.encode( json_table_temp )
					send_message_to_java( jcode )

					RoleModel:request_server_list_platform()

				else
					--重新登录
					ZXLog("登录失败自动登录")
					self:doLogin()
					-- if error_code == self.STATE_LOGIN_FAIL then
					-- 	MUtils:toast("登录失败", 2048, 2.5)	
						
					-- elseif error_code == self.STATE_LOGIN_CANCLE then
					-- 	MUtils:toast("登录取消", 2048, 2.5)
					
					-- end			

				end
			elseif func_type == self.FUNC_QUIT then
				QuitGame()
			elseif func_type == "logout" then
				--登出
				if GameStateManager:get_state() == "scene" then
					MenusPanel:use_all_equip_tip( )
					AudioManager:stopBackgroundMusic(true)
					-- ZXLog("返回登录中。。。。。。。。。。。。。。。。。。。。。。。。。。")
					MiscCC:send_quit_server()
					GameStateManager:set_state("login")
				else
					self:doLogin()
				end
			end
		else
		
		end
	return false;

end

--子渠道号
function PlatformUU:getDownloadChannel()
	return self.subchannel
end

--平台
function PlatformUU:getDownloadFrom()
	return self.channel
end

function PlatformUU:exit()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUU.FUNC_QUIT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--支付
function PlatformUU:payUICallback( info )
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

	-- local _userName = RoleModel:get_login_info().user_name

	-- local balance = player.yuanbao

	-- local partyName = ""

	-- local vipLevel = player.vipFlag

	local _serverId = RoleModel:get_login_info().server_id

	local _privateField = "cycs_android_"..self.uid.."_".._serverId;

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)

	MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )


	local json_table_temp = {}

	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段

	json_table_temp[ "function_type" ] = PlatformUU.FUNC_PAY


	-- json_table_temp[ "ResultUrl" ] = "http://entry.tjxs.m.shediao.com/zhangshang/SD_zhangshang_tianjiang/paycallback"
	json_table_temp[ "amount" ] = game_money 	--充值或支付金额（现实货币），单位为 元

	json_table_temp[ "quantity" ] = 1 						--购买产品数量（商品个数），默认为1

	json_table_temp[ "product_id"] = info.item_index 		--商品唯一标识id

	json_table_temp[ "virtual_quantity"] = game_money*_money_rate		--购买产品的虚拟货币数量（如：10元购买100元宝，则为100；或10元购买1000元宝，则为1000），默认为amount（充值显示货币金额）*10

	json_table_temp[ "product_name" ] =  game_money*_money_rate.."元宝" --商品名称

	json_table_temp[ "item_desc" ] = game_money*_money_rate.."元宝" 	--商品详细描述

	json_table_temp[ "server_id" ] = _serverId 				--服务器Id，默认1

	json_table_temp[ "currency" ] = "rmb"

	json_table_temp[ "extra" ] = "user_level:" .. player.level .. ",role_id:" .. player.id..",server_id:"..tostring(_serverId)..",product_id:"..tostring(info.item_index)..",channel:" .. PlatformInfoForBISystem:getDownloadFrom()

	-- json_table_temp[ "UserID" ] = self.uid

	-- json_table_temp[ "OrderNo" ] = "shengcai_"..os.time()
	
	require 'json/json'

	local jcode = json.encode( json_table_temp )

	send_message_to_java( jcode )
end

--创建角色
function PlatformUU:create_role_info(create_role_info)

	MUtils:toast("创建角色", 2048, 3)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUU.FUNC_CREATE
	json_table_temp[ "roleId" ] = create_role_info.roleId or ""
	json_table_temp[ "serverId" ] = create_role_info.serverId or ""
	json_table_temp[ "roleName" ] = create_role_info.roleName or ""
	json_table_temp[ "serverName"] = create_role_info.serverName or ""
	json_table_temp[ "roleLevel"] = create_role_info.roleLevel or "1"
	local time = SelectRoleCC:get_role_time(create_role_info.roleId)
    time=math.floor(time).._rand_time(time)..""
	json_table_temp[ "time"] = time
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformUU:switch_account()
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUU.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformUU:getLoginRet()

	return self.uid, self.token

end

-- 打开用户中心
function PlatformUU:enter_user_center()
	print("-- 打开用户中心")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformUU.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformUU.FUNC_USER_CENTER
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

function PlatformUU:onLoginResult( err, data )

	-- body
	--[[
	roleId
	roleName
	roleLevel
	serverId
	serverName
	--]]
	PlatformInterface:onEnterLoginState()
end