PlatformWanpu= {}
PlatformWanpu.MESSAGE_TYPE	= "platform"
PlatformWanpu.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformWanpu.FUNC_LOGIN		= "login"		--登录
PlatformWanpu.FUNC_PAY		= "pay"			--支付
PlatformWanpu.FUNC_TAB		= "tab"			--切换账号
PlatformWanpu.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformWanpu.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformWanpu.FUNC_QUIT			= "quit"		--退出
PlatformWanpu.FUNC_EXIT					= "exit"		--退出游戏
PlatformWanpu.FUNC_SUBMIT 				= "submit"	    --提交用户数据pl

PlatformWanpu.SUBMIT_ENTER_SERVER   		= "enterServer"    --进入游戏场景
PlatformWanpu.SUBMIT_LEVEL_UP            = "levelUp"        --角色升级
PlatformWanpu.SUBMIT_CREATE_ROLE         = "createRole"     --创建角色

PlatformWanpu.CODE_SUCCESS = 0
PlatformWanpu.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformWanpu.STATE_LOGIN_FAIL = 1	-- 失败

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformWanpu:init()
	self.firstLogin = true
	self.loginRet = nil
	self.tokens = nil
	self.logoutable = true
	self.slashscreen = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
	self.download_url =  ''
	self.home_url     = CommonConfig.home
	self.channelID = ""
	--http是否已经返回！
	self.payurl_waiting     = false
	self.unlockcallback = callback:new()

	self.AppId = ''

end

function PlatformWanpu:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformWanpu:onEnterGameScene(isEnter)
	if isEnter == true then
		-- self:submit_data(PlatformWanpu.SUBMIT_ENTER_SERVER)
	else

	end
end

-- 第一次进入游戏场景，创建主角完成后调用
function PlatformWanpu:init_role_info()
	self:submit_data(PlatformWanpu.SUBMIT_ENTER_SERVER)
end

-- 提交玩家选择的游戏分区及角色信息 
function PlatformWanpu:create_role_info(role_info)
	if role_info then
		self:submit_data(PlatformWanpu.SUBMIT_CREATE_ROLE,role_info)
	end 
end

-- 提交玩家角色升级
function PlatformWanpu:onPlayerLevelUp()
	self:submit_data(PlatformWanpu.SUBMIT_LEVEL_UP)
end

function PlatformWanpu:submit_data(type_key,role_info)
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformWanpu.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ]		= PlatformWanpu.FUNC_SUBMIT	--分发类型，必传字段

	json_table_temp["_id"] = type_key   -- 当前情景，目前支持 enterServer，levelUp，createRole
	json_table_temp["roleId"] = self.userID
	json_table_temp["roleName"] = "天将雄师OL"..self.username
	json_table_temp["partyName"] = "无帮派"

	if type_key == PlatformWanpu.SUBMIT_CREATE_ROLE and role_info then

		if role_info.roleId == null or role_info.roleId == "" then
			json_table_temp["roleId"] = self.userID
		else
			json_table_temp["roleId"] = role_info.roleId
		end

		if role_info.roleName == null or role_info.roleName == "" then
			json_table_temp["roleName"] = "天将雄师OL"..self.username
		else
			json_table_temp["roleName"] = role_info.roleName
		end 
		
		json_table_temp["roleLevel"] = 1
		json_table_temp["balance"] = 0 
	end 

	local player = EntityManager:get_player_avatar()
	if player then
		json_table_temp["roleId"] = player.id or self.userID                    --当前登录的玩家角色ID，必须为数字，若如，传入userid
		json_table_temp["roleName"] = player.name or "天将雄师OL"..self.username		--当前登录的玩家角色名，不能为空，不能为null，若无，传入"游戏名称+username"，如"刀塔传奇风吹来的鱼"
		json_table_temp["roleLevel"] = player.level or 1 						--当前登录的玩家角色等级，必须为数字，若无，传入1
		json_table_temp["balance"] = player.yuanbao or 0                        --当前用户游戏币余额，必须为数字，若无，传入0
		json_table_temp["partyName"] = player.guildName or "无帮派"	            --当前用户所属帮派，不能为空，不能为null，若无，传入"无帮派"
	end

	local server_name = RoleModel:get_server_name_had_login(  )

	json_table_temp["zoneId"] = RoleModel:get_login_info().server_id or 1 		--当前登录的游戏区服ID，必须为数字，若无，传入1
	json_table_temp["zoneName"] = server_name or "天将雄师1区"   --当前登录的游戏区服名称，不能为空，不能为null，若无，传入游戏名称+"1区"，如"刀塔传奇1区"

	require "model/VIPModel"
	local vip_info = VIPModel:get_vip_info()
	if vip_info then
		if vip_info.level then
    		json_table_temp["vip"] = vip_info.level                                 --当前用户VIP等级，必须为数字，若无，传入1
    	else
    		json_table_temp["vip"] = 1
    	end 
    else
    	json_table_temp["vip"] = 1
    end 

    require "model/GuildModel"
    local guild_info = GuildModel:get_user_guild_info()
    local guild_name = "无帮派"
    if guild_info and guild_info.if_join_guild then
		if guild_info.if_join_guild == 0 then
			if guild_info.guild_name and guild_info.guild_name ~="" then
	    		guild_name = guild_info.guild_name
	    	end 
		end
	end 

	json_table_temp["partyName"] = guild_name                             

	local jcode = json.encode(json_table_temp) 									
	-- for k,v in pairs(json_table_temp) do
	-- 	ZXLog(k,v)
	-- end
	send_message_to_java(jcode)
end

-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformWanpu:onEnterLoginState(state)
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	-- if self.firstLogin == true then
	-- MUtils:toast("万普 登陆请求授权",2048,3) -- [69]="请求登录授权"
	local c = callback:new()
		c:start(0.1,function()
			PlatformWanpu:doLogin()
		end)
	self.firstLogin = false
	-- end
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformWanpu:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	-- MUtils:toast("PlatformWanpu:doLogin", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformWanpu.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformWanpu.FUNC_LOGIN
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end

--获取平台登录url
function PlatformWanpu:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformWanpu:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

function PlatformWanpu:show_logout(callbackfunc)
	callbackfunc()
end


--从选服界面登出
function PlatformWanpu:logoutFromSelectServer(callbackfunc, reason)
	print('PlatformNoPlatform:logoutFromSelectServer',err, data)
	if callbackfunc then
		callbackfunc()
	end

	-- if reason then
	-- 	MUtils:toast(reason,2048)
	-- end
	--跳转到无平台登陆页，有平台应该调用SDK
	--并且隐藏窗口
	RoleModel:change_login_page( "loginSDK" )
end

-- -- 获取该平台，发送请求服务器列表接口的http参数
-- function PlatformWanpu:get_servlist_param()
-- 	local account, pwd = self:getLoginRet()
-- 	if account then
-- 		return string.format('account=%s&pw=%s',account,md5(pwd));
-- 	else
-- 		return ''
-- 	end
-- end

-- login 的参数
function PlatformWanpu:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformWanpu:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return "userId=" .. self.userID .."&channel="..self.channelID.."&token=" .. ZXLuaUtils:URLEncode(self.access_token)
end


-- 获取登录服务器ip
function PlatformWanpu:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformWanpu:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

-- 获取平台支付地址
function PlatformWanpu:getPlatformPayUrl()
	return ""
end

--登出
function PlatformWanpu:logout(callbackfunc)
	-- print("run loginout11111")
	if callbackfunc then
		callbackfunc()
	end
	-- print("run loginout22222")
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformWanpu.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformWanpu.FUNC_LOGIN_OUT
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )	
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'

end

function PlatformWanpu:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformWanpu:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformWanpu:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformWanpu:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformWanpu:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformWanpu:onStartGame(cbfunc)
	cbfunc()
end

function PlatformWanpu:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformWanpu:doNeedLogin_delay()
end

function PlatformWanpu:OnAsyncMessage( id, msg )
	ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	require 'json/json'
	local jtable = {}
	local s,e = pcall(function() jtable = json.decode(msg) end)
	MUtils:toast("成功进入！", 2048, 2.5)
	print("s,e",s,e)
	if s then
		local message_type = jtable[ "message_type" ] or ""
		print("message_type",message_type)
		if message_type == self.MESSAGE_TYPE then
			local func_type = jtable[ "function" ] or ""
			-- local error_code = jtable[ "error_code" ] or self.CODE_FAIL
			print("func_type",func_type)
			-- print('error_code',error_code)
			if func_type == PlatformWanpu.FUNC_LOGIN then -- 登录、切换成功的处理
					MUtils:toast("登陆成功", 2048, 2.5)

					--登录	
					self.channelID = jtable["channelID"]					    --渠道ID，用来区分用户来自哪个渠道
					self.username = jtable["username"] 						    --用户昵称
					self.userID = jtable["userID"]						        --我方给出的不冲突的用户ID
					self.access_token = jtable["token"]							    --令牌
					self.productCode = jtable["productCode"]				    --产品代码
					self.channelUserId = jtable["channelUserId"]			    --渠道用户id，渠道原始用户ID
					self.channelLabel = jtable["channelLabel"] 					--渠道标识

					RoleModel:request_server_list_platform()
			elseif func_type == PlatformWanpu.FUNC_QUIT then
				QuitGame()
			elseif func_type == PlatformWanpu.FUNC_EXIT then
				ZXGameQuit()
			elseif func_type == PlatformWanpu.FUNC_LOGIN_OUT then
				if NetManager:get_socket() ~= nil then
					MiscCC:send_quit_server()
				end
				GameStateManager:set_state("login")
			end
		end
	end
	return false;
end

function PlatformWanpu:android_print(string)
	-- local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformWanpu.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = "print"
	-- json_table_temp[ "context" ] = string
	-- require 'json/json'
	-- local jcode = json.encode( json_table_temp )
	-- send_message_to_java( jcode )	
end

function PlatformWanpu:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformWanpu:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

--平台主动行为封装 Begin
--支付
function PlatformWanpu:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformWanpu:getDownloadFrom()
	return 'noplatform'
end

function PlatformWanpu:showPlatformUI(bFlag)
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
function PlatformWanpu:payUICallback( info )
	-- 万普要求用“分”来计算，（元宝：人民币：分=10：1：100）
	local _money_rate = 10
    local _item_id  = info.item_id
	local _uid = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id

	local _orderId = "lion_SD_wp_".._uid.."_".._serverId.."_"..os.time();
	MUtils:toast("充值中", 2048, 3)

	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformWanpu.MESSAGE_TYPE	--消息类型，必传字段
	json_table_temp[ "function_type" ] = PlatformWanpu.FUNC_PAY
	json_table_temp[ "total" ] = _item_id * _money_rate--_item_id * _money_rate-- 定额支付总金额，单位为人民币分
	json_table_temp[ "unitName" ] = "元宝"  -- 游戏币名称，如金币、钻石等
	json_table_temp[ "count" ] = _item_id	-- 购买商品数量，如100钻石，传入100；10魔法石，传入10
	json_table_temp[ "callBackInfo" ] = _orderId
	json_table_temp[ "callBackUrl" ] = "http://entry.tjxs.m.shediao.com/wanpu/SD_wp/paycallback";

	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end


function PlatformWanpu:getLoginRet()
	return self.uid, self.token
end


function PlatformWanpu:getPayInfo()
	require "../data/chong_zhi_config"
	return ChongZhiConf.wanpu
end

function PlatformWanpu:exit( )
	local json_table_temp = {}
	json_table_temp[ "message_type" ]	= PlatformWanpu.MESSAGE_TYPE					--消息类型，必传字段
	json_table_temp[ "function_type" ]		= PlatformWanpu.FUNC_QUIT					--分发类型，必传字段
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java(jcode)
end

--------------------------------------
--unused function
--HJH 2014-11-27
--写这个架构的人没想清楚，怎么会有下面这些函数
function PlatformWanpu:share(info)

end

function PlatformWanpu:setLoginRet(uid,psw)
	
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformWanpu:get_servlist_param(  )
	return ""
end

-- 打开用户中心
function PlatformWanpu:open_user_center()
	
end

function PlatformWanpu:onLoginResult( err, data )
	-- body
end
