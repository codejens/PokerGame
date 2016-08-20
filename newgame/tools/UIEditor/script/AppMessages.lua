
AppGameMessages = nil

AppMessages = {}

local _ZXGameQuit = ZXGameQuit
ZXGameQuit = function()
	JPush.cfgTag = CCUserDefault:sharedUserDefault():getStringForKey("JPush_tag")
	ZXLog('quit, tag = ', JPush.cfgTag)
	JPush.setTag(JPush.cfgTag)
	_ZXGameQuit()
end


--程序退出，需要做回收操作
--通知脚本退出，需要对retain的CCObject做回收操作
function AppMessages:OnQuit(...)
	if AppGameMessages then
		AppGameMessages.OnQuit()
	end
end

--进入后端
function AppMessages:OnEnterBackground(...)
	if AppGameMessages then
		JPush.cfgTag = CCUserDefault:sharedUserDefault():getStringForKey("JPush_tag")
		ZXLog('enter background, tag = ', JPush.cfgTag)
		JPush.setTag(JPush.cfgTag)
		AppGameMessages.OnEnterBackground(...)
	end
end

--进入前端
function AppMessages:OnEnterForeground(...)
	if AppGameMessages then
		AppGameMessages.OnEnterForeground(...)
	end
end


function AppMessages.OnRemoteDebugger( sz )
    print('>',sz)
 	local isGM = string.match(sz,'^@')
 	if isGM and ChatCC then
    	ChatCC:send_chat(6, 0, sz)
	else
		--loadstring(sz)()
		--loadstring("selectionComponent:receive")
		if UIEditor then
			UIEditor:receive( sz )
		end
	end
end

-- 第一次加载一个模块，开始加载前
function AppMessages:before_require( name )
	if AppGameMessages then
		AppGameMessages.before_require(name)
	end
end

-- 第一次加载一个模块，完成加载后
function AppMessages:after_require( name )
	if AppGameMessages then
		AppGameMessages.after_require(name)
	end
end

-- 重新加载一个模块
function AppMessages:reload_module( name )
	if AppGameMessages then
		AppGameMessages.reload_module(name)
	end
end

-- 断开连接
function AppMessages:close_connect_message(  )
	if AppGameMessages then
		AppGameMessages.close_connect_message()
	end
end

-- 异步消息处理
function AppMessages.OnAsyncMessage( id, msg )

	if id == AsyncMessageID.eMsgSocketInitError then
		--AppDelayMessages[AsyncMessageID.eMsgSocketInitError] = msg
		--MUtils:toast("网络模块初始化失败" .. '[' .. msg .. ']',2048)

	elseif id == AsyncMessageID.eMsgMSDKOnWakeupNotify then
		pushQQWakeMessages(msg)
		print('QQWakeMessage[1]',QQWakeMessage)
		return

	elseif id == AsyncMessageID.eMsgPhoneMessge then
		local ret = false
		
		if PlatformInterface and PlatformInterface.OnAsyncMessage then
    		ret = PlatformInterface:OnAsyncMessage(id,msg)
    	end
    	
    	if not ret then
			AppMessages.OnPhoneMessage(msg)
		end
		return

	elseif id == AsyncMessageID.eMsgSocketError then
		MUtils:toast(LangCommonString[1] .. '[' .. msg .. ']',2048) -- [1]="网络异常"
		GameStateManager:lost_connect()
	--增加文件无法找到的处理
	elseif id == AsyncMessageID.eMsgInternalResourceNoFound then
		if UpdateManager.FileErrorDialog then
			UpdateManager:FileErrorDialog()
		end
	--增加脚本解析错误的处理
	elseif id == AsyncMessageID.eMsgInternalScriptFailed then
		if UpdateManager.FileErrorDialog then
			UpdateManager:FileErrorDialog()
		end
			
    elseif UpdateManager:OnAsyncMessage(id,msg) then
    	return

    elseif PlatformInterface and PlatformInterface.OnAsyncMessage then
    	PlatformInterface:OnAsyncMessage(id,msg)

	elseif AppGameMessages then
		AppGameMessages.OnAsyncMessage(id,msg)
	end
end

function AppMessages.OnKeyEvent( key, down )
	if AppGameMessages then
		AppGameMessages.OnKeyEvent(key,down)
	end
end

function AppMessages.OnBackClick()
	if GameStateManager then
		GameStateManager:OnBackClick()
	end
	--平台有退出方法需要调用平台退出 by liubo on 2014-08-13
	if PlatformInterface and PlatformInterface.exit then
		PlatformInterface:exit()
	else
		QuitGame()
	end
	--if AppGameMessages then
	--	AppGameMessages.OnBackClick()
	--end
end

function AppMessages.OnMenuClick()
	if AppGameMessages then
		AppGameMessages.OnMenuClick()
	end
end

function AppMessages.OnPhoneMessage(msg)
	
	local ret = json2table(msg)
	--获取消息类型
	local msg = ret[PhoneMessage.k_id]
	--获得消息类型
	if msg == PhoneMessage.initSDK then
		if PlatformInterface then
			PlatformInterface.qqAppId = ret['qqAppId']
		end
	end
	return true
end

function AppMessages.OnMemoryWarning()
	ResourceManager:garbage_collection(true)
end


local modalPop = nil
local STRING_BTN_QUIT = LangCommonString[2] -- [2]='退出'
local STRING_CANCEL = LangCommonString[3] -- [3]='取消'
local STRING_QUIT =  { LangCommonString[4], LangCommonString[5],LangCommonString[6] }  -- [4]='#cfff5f0您需要退出游戏吗' -- [5]='#cffc80e点击退出' -- [6]='#cfff5f0退出游戏'
local DialogDepth = 80000

function QuitGame()
	local _root =  ZXLogicScene:sharedScene():getUINode()
    _root:setBlocked(false)
	if _root and not modalPop then
		modalPop = PopupNotify( _root,
								DialogDepth, STRING_QUIT,
								STRING_BTN_QUIT,STRING_CANCEL,POPUP_YES_NO,
								function(state)
									if state then 
										if Analyze then
											Analyze:fini( ) 
										end
									 	ZXGameQuit()
									end
									modalPop = nil
								 end,
								 POPUPSIZE_EXIT_DIALOG)
	end
	return true
end

