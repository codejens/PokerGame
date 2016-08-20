-- ForceUpdateMgr.lua
-- created by mwy on 2014-6-14
-- 强更管理器
require 'UI/update/PopupNotify'
require 'utils/binder'

ForceUpdateMgr = {}

--是否启动强更
local _is_need_update = false

local _appstatore_update_url='https://itunes.apple.com/cn/app/ge-dou-da-shi/id820807634?&mt=8'

function ForceUpdateMgr:needUpdate()
	return _is_need_update
end

function ForceUpdateMgr:doUpdate()
	if GetPlatform() == CC_PLATFORM_IOS then
		ForceUpdateMgr:do_ios_update()
	elseif GetPlatform() == CC_PLATFORM_ANDROID then
		-- ForceUpdateMgr:do_android_update()
	elseif GetPlatform() == CC_PLATFORM_WIN32 then	
		-- ForceUpdateMgr:do_win32_update()
	end
end

--ios强更
function ForceUpdateMgr:do_ios_update()
	IOSDispatcher:appStoreUpdate( _appstatore_update_url )
end

--android强更
function ForceUpdateMgr:do_android_update()

end
--win32强更
function ForceUpdateMgr:do_win32_update()

end