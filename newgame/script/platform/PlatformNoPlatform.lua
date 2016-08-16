PlatformNoPlatform = {}

-- 不准许有全局参数，因为需要被reload
--
--
function PlatformNoPlatform:init()
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

-- http://183.57.57.156:58040/base/get_servlist?ret=1&uid=9&salt=QWERTY123&channelCode=common
-- http://183.57.57.156:58040/base/login?
	
	--内部的外网服
	self.login_url = "http://183.57.57.156:58040/base/login?"
	self.register_url = "http://cycs.6666wan.net:8082/TencentOpen/siren_jianhui/register.jsp"
	self.get_servlist_url ="http://183.57.57.156:58040/base/get_servlist?"

	--渠道评审
	--评审地址115.159.76.245:58020
	-- self.login_url = "http://115.159.76.245:58020/base/login? "
	-- self.register_url = "http://cycs.6666wan.net:8082/TencentOpen/siren_jianhui/register.jsp"
	-- self.get_servlist_url ="http://115.159.76.245:58020/base/get_servlist?"

	self.outer_net = CCAppConfig:sharedAppConfig():getBoolForKey('outer_net') or false
	
end

--获取平台登录url
function PlatformNoPlatform:get_iap_callback()
	return UpdateManager.apple_pay_callback
end

function PlatformNoPlatform:get_server_filter_list()
	return CCAppConfig:sharedAppConfig():getStringForKey('develop_serverFilter')
end

-- @param:是否进入或者离开游戏场景,true：进入,false:离开
function PlatformNoPlatform:onEnterGameScene(isEnter)
	
end


function PlatformNoPlatform:setLoginRet(uid,psw)
	self.uid=uid
	self.pwd=psw
end

function PlatformNoPlatform:getLoginRet()
	return self.uid, self.pwd, self.password_changed
end


-- 入口,当Login界面Show
-- 显示登录界面
function PlatformNoPlatform:onEnterLoginState()
	RoleModel:show_login_win(GameStateManager:get_game_root())
	MUtils:toast(LangCommonString[69], 2048, 3)
	local c = callback:new()
	c:start(0.1,function()
		PlatformNoPlatform:doLogin()
	end)
	self.firstLogin = false
end

-- 按下登录按钮的回调，应显示平台登录页
function PlatformNoPlatform:doLogin()
	--跳转到无平台登录页，有平台应该调用SDK
	-- RoleModel:change_login_page( "login" )
	RoleModel:log()
end

--获取平台登录url
function PlatformNoPlatform:get_login_url()
	UpdateManager.login_url = nil
	local platform_id =  Target_Platform
	local _url = CCAppConfig:sharedAppConfig():getStringForKey('develop_log_url')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end

	-- print("获取平台登录url---", self.outer_net,self.login_url)
	if self.outer_net then
		return self.login_url
	end
	return _url
end

--获取服务器列表url
function PlatformNoPlatform:get_servlist_url()

	return GameUrl_global:getServerIP() or ""
end

function PlatformNoPlatform:show_logout(callbackfunc)
	callbackfunc()
end

--从选服界面登出
function PlatformNoPlatform:logoutFromSelectServer(callbackfunc, reason)
	if callbackfunc then
		callbackfunc()
	end
	RoleModel:change_login_page("login")
end

-- 登录成功回调
function PlatformNoPlatform:onLoginResult(err, data)
	if err == 0 then
		self.uid = data.uid
		self.pwd = data.pwd
		self.password_changed = data.password_changed
		RoleModel:change_login_page('new_select_server_page')
		RoleModel:send_name_and_pw(self.uid, self.pwd, self.password_changed, true)
	end
end

--请求最新服务器列表
function PlatformNoPlatform:reNewServerList()
	RoleModel:send_name_and_pw(self.uid, self.pwd, self.password_changed, true)
end


-- 获取该平台，发送请求服务器列表接口的http参数
function PlatformNoPlatform:get_servlist_param()
	local account, pwd = self:getLoginRet()
	if account then
		return string.format('account=%s&pw=%s',account,md5(pwd));
	else
		return ''
	end
end

-- login 的参数
function PlatformNoPlatform:get_login_param( account, dbip, server_id )
	-- if self.outer_net then
		local param = string.format("uid=%s&udid=%s&channel=noplatform&sub_channel=noplatform&plat=pc&serverid=%s",account,GetSerialNumber(),server_id)
		return param--"uid="..account..""&udid=xxx&channel=xxxx&sub_channel=xxxx&plat=xxxx&serverid=xxxx
	-- end
 --    return 'account='..account..'&ip='..dbip..'&serverid='..server_id
end

function PlatformNoPlatform:get_login_param_json( user_name, password )
	-- local is_develop_entry_test_server = CCAppConfig:sharedAppConfig():getStringForKey('is_develop_entry_test_server')
	-- 这是为了进外网测试服
	return "ret=1&&uid="..user_name.."&salt=QWERTY123&channelCode=noplatform"
	-- if self.outer_net then
	-- 	return "ret=1&&uid="..user_name.."&salt=QWERTY123&channelCode=common"
	-- 	--return 'uid='..user_name..'&ret=1&salt=QWERTY123'
	-- else
	-- 	ret=1&uid=xxx&salt=QWERTY123&channelCode=common
 --    	return 'account=' ..user_name.."&pw="..md5(password)
 --    end
end


-- 获取登录服务器ip
function PlatformNoPlatform:getServerIP(bool)

	-- print("获取服务器列表url---", self.outer_net,self.get_servlist_url)
	-- print("做了PlatformNoPlatform:getServerIP", bool)
	if self.outer_net then
		return self.get_servlist_url
		-- return self.outer_net
	end

	UpdateManager.servlist_url = nil
	local platform_id =  Target_Platform
	local _url = nil
	if not bool then
		_url = CCAppConfig:sharedAppConfig():getStringForKey('develop_register_url')
    else
    	_url = CCAppConfig:sharedAppConfig():getStringForKey('develop_server_list')
    end

	
	-- local url = CCAppConfig:sharedAppConfig():getStringForKey('develop_register_url')
	if _url == '' then
		_url = UpdateManager.server_url .. 'noplatform/'
	end
	-- print("_url===========----------------<<<<<<<<<<<<<<<<", _url)
	return _url
end

function PlatformNoPlatform:open_user_center()
	
end


-- 获取平台支付地址
function PlatformNoPlatform:getPlatformPayUrl()
	return ""
end

----------------------------------------------
function PlatformNoPlatform:clearLoginRet()
	self.uid = nil;
	self.pwd = nil;
	self.password_changed = false
end

--登出
function PlatformNoPlatform:logout(callbackfunc)
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end

function PlatformNoPlatform:lost_connect( callbackfunc )
	if callbackfunc then
		callbackfunc()
	end
	MUtils:toast(LangCommonString[25],2048) -- [25]='返回到登录'
end


--无法登入游戏服务器
function PlatformNoPlatform:failedTologinGameServer(callbackfunc)

	if callbackfunc then
		callbackfunc()
	end

	RoleModel:destroy_login_without_update_win()
end


-- 上报接口
function PlatformNoPlatform:notifyZone( ... )
	-- 子类重写
end

--最初的启动
function PlatformNoPlatform:onStartPackage(cbfunc)
	cbfunc()
end

--开始更新
function PlatformNoPlatform:onStartUpdate(cbfunc)
	cbfunc()
end

--更新完毕等待进入游戏
function PlatformNoPlatform:onStartGame(cbfunc)
	cbfunc()
end

function PlatformNoPlatform:get_cache_url()
	local temp_url_font = CCAppConfig:sharedAppConfig():getStringForKey('develop_cache_url')
	return temp_url_font .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformNoPlatform:get_package_url()
	local temp_url_font = CCAppConfig:sharedAppConfig():getStringForKey('develop_package_url')
	return temp_url_font .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
end

function PlatformNoPlatform:doNeedLogin()
end

-- 按下登录按钮的回调
function PlatformNoPlatform:doNeedLogin_delay()
end

function PlatformNoPlatform:OnAsyncMessage( id, msg )
	-- ZXLog('PlatformNoPlatform:OnAsyncMessage', id, msg)
	--RoleModel:request_server_list_platform()
	return false;
end




--平台主动行为封装 Begin
--支付
function PlatformNoPlatform:pay(...)
	local payWin = VIPModel:show_chongzhi_win()
if payWin == nil then 
   return
end


	payWin:setCallback(function(which)
			self:payUICallback({ item_id = which, window = 'pay_win' })
		end)
end

function PlatformNoPlatform:WG_GetLoginRecord()
	
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
function PlatformNoPlatform:send_to_weixin( scene, title, desc, url, mediaTagName, thumbImgData, thumbImgDataLen )
end

-- 分享图片消息到微信, 此类消息只可以分享到回话和到朋友圈. 需要有SD卡
-- @param scene 		标识分享到朋友圈还是会话, 可能值SendMessageToWX.Req.WXSceneSession 和SendMessageToWX.Req.WXSceneTimeline
-- @param mediaTagName 	使用者自己设定一个值, 此值会传到微信供统计用, 在分享返回时也会带回此值, 可以用于区分分享来源.
-- @param imgData 		分享的图片数据, 图片大小不应该超过5M
-- @param imgDataLen 	分享的图片数据长度
function PlatformNoPlatform:send_to_weixin_with_photo( scene, mediaTagName, imgData, imgDataLen )
end

-- 分享消息到QQ, 在手Q上接受到消息点击能拉起传入的targetUrl对应的页面, 不能直接拉起游戏. 需要有SD卡
-- @param title 	分享的标题
-- @param desc 		分享的描述
-- @param targetUrl 目标URL, 好友点击消息拉起此页面
-- @param imgUrl 	分享展示的图片的URL
function PlatformNoPlatform:send_qq( title, desc, targetUrl, imgUrl)
end

--分享接口, info为table，必须有key
--info = {
--    ['title']
--    ['desc']
--    ['targetUrl']
--	  ['imgUrl']	
--}
function PlatformNoPlatform:share(info)
end


function PlatformNoPlatform:Feedback(game,info)
end

function PlatformNoPlatform:getDownloadFrom()
	return 'noplatform'
end

--支付
function PlatformNoPlatform:payUICallback(info)
	local item_index = info.item_index
	if UpdateManager:is_appstore_auditing() then
		if item_index == 20 then
			item_index = 22
		elseif item_index == 21 then
			item_index = 20
		elseif item_index == 22 then
			item_index = 21
		end
	end
	if item_index >= info.other_begin_index then
		if item_index == 20 then
			MiscCC:req_buy_month_card(1)
		elseif item_index == 21 then
			MiscCC:req_buy_month_card(2)
		elseif item_index == 22 then
			ChatModel:send_msg_to_world("@onermb")
		end
	else
		local price = info.item_id
		ChatModel:send_msg_to_world("@recharge "..price*10)
	end
end

function PlatformNoPlatform:getPayInfo()
	require "../data/chong_zhi_config"
	if UpdateManager:is_appstore_auditing() then
		return ChongZhiConf.iqiyi_ios
	else
		return ChongZhiConf.normal
	end
end