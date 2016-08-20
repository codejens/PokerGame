-- PlatformND.lua
-- created by mwy @2014-7-5
-- 苹果官方平台，登录方式包括游客登录、GameCenter登录、正式注册账号登录,由self.platform_type区分

PlatformApple = {}

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformApple:init()
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
	--self.InstallChannel = WG_GetChannelId()
	--local info = WG_GetSDKConfig()
	--local ret = json2table(info)
	--if ret  then
	--	self.AppId     		= ret['AppId']
	--end
	--ZXLog('PlatformApple.AppId', self.AppId)
	--ZXLog('PlatformApple.InstallChannel', self.InstallChannel)

end

function PlatformSD:get_server_filter_list()
	return nil--CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

function PlatformApple:gamecenter_Login( )

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

function PlatformApple:set_platform_type(platform_type)
	self.platform_type =platform_type
end

function PlatformApple:get_platform_type()
	return self.platform_type 
end


-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformApple:onEnterGameScene(isEnter)

	if isEnter and self.platform_type== MSDK_TYPE.ePlatform_Guest then
		local cb = callback:new()
		local function cb_fun()
			LoginPage:ShowBindGuestPanel(true)
		end
		cb:start( 5,cb_fun)
	end
end

-- 入口,当Login界面Show
-- 显示登陆界面
function PlatformApple:onEnterLoginState()
	RoleModel:show_login_win( GameStateManager:get_game_root() )
	local c = callback:new()
		c:start(0.1,function()
			PlatformApple:doLogin()
		end)
	self.firstLogin = false
end

-- 按下登录按钮的回调，应显示平台登陆页
function PlatformApple:doLogin()
	--跳转到无平台登陆页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	self:autoLogin()
end

--实现动登录
function PlatformApple:autoLogin( )
	--切换到登录页
	RoleModel:change_login_page( "login" ,true)
	--各种登录情况是否进行自动登录处理
	local _platform_type=self:getLoginType()
	if _platform_type ==MSDK_TYPE.ePlatform_GameCenter then
		--上一次登录是gc
		PlatformInterface:gamecenter_Login(  )
	elseif _platform_type==MSDK_TYPE.ePlatform_Guest then
		--上一次登录是游客账号
		-- RoleModel:guest_get_server_list( ) 
	elseif _platform_type==MSDK_TYPE.ePlatform_normal then
		--上一次登录是普通账号,自动切换到平台账号登录页
		local win = RoleModel:get_login_win()
		if win then
			local _login_page =win.login_page
			_login_page:change_login_page(tLoginPage.eShowloginPanel)
		end
	else
		--其他登录
	end
end

-- 打开用户中心
function PlatformApple:open_user_center()
	
end

--从选服界面登出
function PlatformApple:logoutFromSelectServer(callbackfunc, reason)
	-- print('PlatformApple:logoutFromSelectServer',err, data)
	if callbackfunc then
		callbackfunc()
	end
	if reason then
		MUtils:toast(reason,2048)
	end
	--跳转到无平台登陆页，有平台应该调用SDK
	--并且隐藏窗口
	RoleModel:change_login_page( "login" )
end

-- 登陆成功回调
function PlatformApple:onLoginResult(err, data)
	if err == 0 then
		self.uid = data.uid
		self.pwd = data.pwd
		self.platform_type=data.platformType
		self.password_changed = data.password_changed
		RoleModel:request_server_list_platform()
	end
end

function PlatformApple:setLoginRet(uid,psw)
	self.uid=uid
	self.pwd=psw
end

function PlatformApple:getLoginRet()
	return self.uid, self.pwd, self.password_changed
end


function PlatformApple:setLoginType(ePlatformType)
	CCUserDefault:sharedUserDefault():setIntegerForKey("loginType", ePlatformType )
	CCUserDefault:sharedUserDefault():flush()
end

function PlatformApple:getLoginType()
	return CCUserDefault:sharedUserDefault():getIntegerForKey("loginType")
end


--获取注册url
function PlatformApple:get_registe_url()
	return UpdateManager.registe_url
end

--获取服务器列表url
function PlatformApple:get_servlist_url()
	return GameUrl_global:getServerIP() or ""
end

--获取平台登录url
function PlatformApple:get_login_url()
	--UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	return _url
end


--普通账号注册
function PlatformApple:get_registe_param(username,password,tel)
	local _username = username or ''
	local _password = password or ''
	local _tel = tel or ''
	return string.format('username=%s&password=%s&tel=%s',_username,_password,_tel)
end	

-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformApple:get_servlist_param()
	local uid = self.uid 		--用户名
	local pw  = self.pwd or ''  --密码
	return string.format('username=%s&password=%s',uid,pw)
end

-- login 的参数
function PlatformApple:get_login_param(account,dbip, server_id )
	return 'account='..account..'&ip='..dbip..'&serverid='..server_id..'&channel='..CCAppConfig:sharedAppConfig():getStringForKey('lh_channel')
end

function PlatformApple:get_login_param_json( user_name, password )
    return 'account=' ..user_name.."&pw="..password
end

-- 获取登录服务器ip
function PlatformApple:getServerIP()
	--UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('server_list')
	print("PlatformSD:getServerIP:",_url)
	if _url == '' then
		_url = UpdateManager.servlist_url
		print("UpdateManager.servlist_url",servlist_url)
	end
	return _url
end

----------------------------------------------
function PlatformApple:clearLoginRet()
	self.uid = nil;
	self.pwd = nil;
	self.password_changed = false
end

--登出
function PlatformApple:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
		UpdateWin:show()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

function PlatformApple:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
		UpdateWin:show()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformApple:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformApple:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformApple:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformApple:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformApple:onStartGame(cbfunc)
	cbfunc()
end

function PlatformApple:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformApple:doNeedLogin_delay()
end

function PlatformApple:OnAsyncMessage( id, msg )
	ZXLog('PlatformApple:OnAsyncMessage', id, msg)
	RoleModel:request_server_list_platform()
	return false;
end

--平台主动行为封装 Begin
--支付
function PlatformApple:pay(...)
	local payWin = UIManager:show_window("pay_win");
	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformApple:WG_GetLoginRecord()
	
end

function PlatformApple:get_cache_url()
	return UpdateManager.cache_url .. "/download" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformApple:get_package_url()
	return UpdateManager.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
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
function PlatformApple:send_to_weixin( scene, title, desc, url, mediaTagName, thumbImgData, thumbImgDataLen )
end

-- 分享图片消息到微信, 此类消息只可以分享到回话和到朋友圈. 需要有SD卡
-- @param scene 		标识分享到朋友圈还是会话, 可能值SendMessageToWX.Req.WXSceneSession 和SendMessageToWX.Req.WXSceneTimeline
-- @param mediaTagName 	使用者自己设定一个值, 此值会传到微信供统计用, 在分享返回时也会带回此值, 可以用于区分分享来源.
-- @param imgData 		分享的图片数据, 图片大小不应该超过5M
-- @param imgDataLen 	分享的图片数据长度
function PlatformApple:send_to_weixin_with_photo( scene, mediaTagName, imgData, imgDataLen )
end

-- 分享消息到QQ, 在手Q上接受到消息点击能拉起传入的targetUrl对应的页面, 不能直接拉起游戏. 需要有SD卡
-- @param title 	分享的标题
-- @param desc 		分享的描述
-- @param targetUrl 目标URL, 好友点击消息拉起此页面
-- @param imgUrl 	分享展示的图片的URL
function PlatformApple:send_qq( title, desc, targetUrl, imgUrl)
end

--分享接口, info为table，必须有key
--info = {
--    ['title']
--    ['desc']
--    ['targetUrl']
--	  ['imgUrl']	
--}
function PlatformApple:share(info)
end


function PlatformApple:payUICallback( info )
	require 'model/iOSChongZhiModel'
	iOSChongZhiModel:purchase_product( info.item_id )
end

function PlatformApple:Feedback(game,info)
end

function PlatformApple:getDownloadFrom()
	return 'applatform'
end

function PlatformApple:showPlatformUI(bFlag)
end

-- 获取平台支付地址
function PlatformApple:getPlatformPayUrl()
	return ""
end