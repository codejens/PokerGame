-- PlatformND.lua
-- created by mwy @2014-7-5
-- 苹果官方平台，登录方式包括游客登录、GameCenter登录、正式注册账号登录,由self.platform_type区分

PlatformHAApple = {}
PlatformHAApple.MESSAGE_TYPE	= "platform"
PlatformHAApple.FUNC_CHANGE_ACCOUNT = "change_account"
PlatformHAApple.FUNC_LOGIN		= "login"		--登录
PlatformHAApple.FUNC_PAY		= "pay"			--支付
PlatformHAApple.FUNC_TAB		= "tab"			--切换账号
PlatformHAApple.FUNC_LOGIN_OUT	= "login_out"	--登出
PlatformHAApple.FUNC_INIT_ROLE	= "init_role"	--传送
PlatformHAApple.CODE_SUCCESS = 0
PlatformHAApple.STATE_LOGIN_SUCCESS = 0 -- 成功
PlatformHAApple.STATE_LOGIN_FAIL = 1	-- 失败
-- PlatformHAApple._IOS_VERSION = "1.00.02"

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformHAApple:init()
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

	self.platform_type = nil;

end

function PlatformHAApple:get_ios_version()
	return "1.00.00"
end

function PlatformHAApple:is_check_version()

end

function PlatformHAApple:gamecenter_Login( )

	local function oc_callback( error, json )

		require "utils/Utils"
		local json_table = Utils:json2table( json )
		local playerID = json_table["playerID"]
		local playerName = json_table["playerName"]
		local pwd = ""
		local tel = ""
       	self:setLoginRet(playerID,pwd)

       	self:set_platform_type(MSDK_TYPE.ePlatform_GameCenter)

        RoleModel:gamecenter_get_server_list(playerID)
	end 

	IOSDispatcher:gamecenter_authenticateLocalUser( oc_callback )

end

function PlatformHAApple:set_platform_type(platform_type)
	self.platform_type =platform_type
end

function PlatformHAApple:setLoginType(ePlatformType)
	CCUserDefault:sharedUserDefault():setIntegerForKey("loginType", ePlatformType )
	CCUserDefault:sharedUserDefault():flush()
end

function PlatformHAApple:get_platform_type()
	return self.platform_type 
end

function PlatformHAApple:get_server_filter_list()
	local platform_test_version = nil
    local target_platform_test_version = ""
    if PlatformInterface.get_ios_version then
        platform_test_version = PlatformInterface:get_ios_version()
        target_platform_test_version = UpdateManager._ios_check_version
    end
    --print("platform_test_version,target_platform_test_version",platform_test_version,target_platform_test_version)
    if platform_test_version == target_platform_test_version then
    	return 2047
    else
		return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
	end
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformHAApple:onEnterGameScene(isEnter)

	-- if isEnter and self.platform_type== MSDK_TYPE.ePlatform_Guest then
	-- 	local cb = callback:new()
	-- 	local function cb_fun()
	-- 		LoginPage:ShowBindGuestPanel(true)
	-- 	end
	-- 	cb:start( 5,cb_fun)
	-- end
end

-- 入口,当Login界面Show
-- 显示登录界面
function PlatformHAApple:onEnterLoginState()
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	-- if self.login_state == false then
		local c = callback:new()
			c:start(0.1,function()
				PlatformHAApple:doLogin()
			end)
		self.firstLogin = true
	-- end
end

-- 按下登录按钮的回调，应显示平台登录页
function PlatformHAApple:doLogin()
	RoleModel:change_login_page( "loginIOS" )
end

--获取平台登录url
function PlatformHAApple:get_login_url()
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end

--获取服务器列表url
function PlatformHAApple:get_servlist_url()
	return UpdateManager.server_list_url or ""
end

-- 打开用户中心
function PlatformHAApple:show_logout(callbackfunc)
	-- local json = "{\"funcID\":\"sdkty_logout\"}"
	-- IOSDispatcher:async_send_to_oc(json,login_succ)
end

--从选服界面登出
function PlatformHAApple:logoutFromSelectServer(callbackfunc, reason)
	if callbackfunc then
		callbackfunc()
	end
	RoleModel:change_login_page("loginIOS")
end

-- 登录成功回调
function PlatformHAApple:onLoginResult(err, data)
	if err == 0 then
		self.uid = data.uid
		self.pwd = data.pwd
		self.password_changed = data.password_changed
		RoleModel:request_server_list_platform()
	end
end

function PlatformHAApple:setLoginRet(uid,psw)
	self.uid=uid
	self.pwd=psw
end

function PlatformHAApple:getLoginRet()
	return self.uid, self.pwd, self.password_changed
end

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformHAApple:get_servlist_param()
	local account, pwd = self:getLoginRet()
	if account then
		return string.format('uid=%s&pw=%s',account,md5(pwd));
	else
		return ''
	end
end

-- login 的参数
function PlatformHAApple:get_login_param( account, dbip, server_id )
    return 'account='..account..'&ip='..dbip..'&serverid='..server_id .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformHAApple:get_login_param_json( )
    -- return 'openid=' ..user_name.."&pw="..md5(password)
    return 'username=' .. self.uid.."&password=".. self.pwd .. "&channel=" .. CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

-- 获取登录服务器ip
function PlatformHAApple:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	--print("PlatformSqw:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.server_list_url
		--print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end


--获取注册url
function PlatformHAApple:get_registe_url()
	return UpdateManager.registe_url
end


--普通账号注册
function PlatformHAApple:get_registe_param(username,password,tel)
	local _username = username or ''
	local _password = password or ''
	local _tel = tel or ''
	return string.format('username=%s&password=%s&tel=%s',_username,_password,_tel)
end	


--获取平台登录url
function PlatformHAApple:get_iap_callback()
	return UpdateManager.apple_pay_callback
end

--------------------------------------------
function PlatformHAApple:clearLoginRet()
	self.uid = nil;
	self.pwd = nil;
	self.password_changed = false
end

--登出
function PlatformHAApple:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
		UpdateWin:show()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

function PlatformHAApple:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
		UpdateWin:show()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformHAApple:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformHAApple:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformHAApple:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformHAApple:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformHAApple:onStartGame(cbfunc)
	cbfunc()
end

function PlatformHAApple:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformHAApple:doNeedLogin_delay()
end

function PlatformHAApple:OnAsyncMessage( id, msg )
	ZXLog('PlatformHAApple:OnAsyncMessage', id, msg)
	RoleModel:request_server_list_platform()
	return false;
end

function PlatformHAApple:get_cache_url()
	local platform_test_version = nil
    local target_platform_test_version = ""
    if PlatformInterface.get_ios_version then
        platform_test_version = PlatformInterface:get_ios_version()
        target_platform_test_version = UpdateManager._ios_check_version
    end
    -- --print("platform_test_version,target_platform_test_version",platform_test_version,target_platform_test_version)
    if platform_test_version ~= target_platform_test_version then
		return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
	else
		return UpdateManager.cache_url .. "/check_download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
	end
end

function PlatformHAApple:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

--平台主动行为封装 Begin
--支付
function PlatformHAApple:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformHAApple:get_pay_config_info()
	require "../data/chong_zhi_config"
	return ChongZhiConf.ha_apple;
end

function PlatformHAApple:getPayInfo()
	require "../data/chong_zhi_config"
	local temp_info = ChongZhiConfig:get_chong_zhi_info()
	return temp_info.ha_apple
end

function PlatformHAApple:WG_GetLoginRecord()
	
end

-----------------------------------------------
--
--       分享类
--
-----------------------------------------------

-- 分享App消息到微信, 
-- 此类消息只可以分享到回话, 不能分享到朋友圈, 
-- 好友在会话界面点击分享的消息可以直接拉起游戏, 需要有SD卡
-- @param scene 标识分享到朋友圈还是会话, 可能值SendMessageToWX.Req.WXSceneSession 和SendMessageToWX.Req.WXSceneTimeline
-- @param title 分享的标题
-- @param desc 	分享的描述
-- @param url 	此处建议填入游戏页面, 或者官网url, 没有安装游戏时候可能会有用, 现阶段微信不支持拉起此url.
-- @param mediaTagName 使用者自己设定一个值, 此值会传到微信供统计用, 在分享返回时也会带回此值, 可以用于区分分享来源.
-- @param thumbImgData 分享时展示的缩略图, 数据大小不应该超过32k
-- @param thumbImgDataLen 分享时展示的缩略图的长度, 需要和thumbImgData匹配, 不能为空
function PlatformHAApple:send_to_weixin( scene, title, desc, url, mediaTagName, thumbImgData, thumbImgDataLen )
end

-- 分享图片消息到微信, 此类消息只可以分享到回话和到朋友圈. 需要有SD卡
-- @param scene 		标识分享到朋友圈还是会话, 可能值SendMessageToWX.Req.WXSceneSession 和SendMessageToWX.Req.WXSceneTimeline
-- @param mediaTagName 	使用者自己设定一个值, 此值会传到微信供统计用, 在分享返回时也会带回此值, 可以用于区分分享来源.
-- @param imgData 		分享的图片数据, 图片大小不应该超过5M
-- @param imgDataLen 	分享的图片数据长度
function PlatformHAApple:send_to_weixin_with_photo( scene, mediaTagName, imgData, imgDataLen )
end

-- 分享消息到QQ, 在手Q上接受到消息点击能拉起传入的targetUrl对应的页面, 不能直接拉起游戏. 需要有SD卡
-- @param title 	分享的标题
-- @param desc 		分享的描述
-- @param targetUrl 目标URL, 好友点击消息拉起此页面
-- @param imgUrl 	分享展示的图片的URL
function PlatformHAApple:send_qq( title, desc, targetUrl, imgUrl)
end

--分享接口, info为table，必须有key
--info = {
--    ['title']
--    ['desc']
--    ['targetUrl']
--	  ['imgUrl']	
--}
function PlatformHAApple:share(info)
end


function PlatformHAApple:payUICallback( info )
	require 'model/iOSChongZhiModel'
	iOSChongZhiModel:purchase_product( info.item_id )
end

function PlatformHAApple:Feedback(game,info)
end

function PlatformHAApple:getDownloadFrom()
	return 'applatform'
end

-- 获取平台支付地址
function PlatformHAApple:getPlatformPayUrl()
	return ""
end

function PlatformHAApple:open_user_center()

end


--获取注册url
function PlatformHAApple:get_registe_url()
	return UpdateManager.registe_url
end
