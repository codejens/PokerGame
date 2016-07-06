local cc_director = cc.Director:getInstance()
local cc_app	  = cc.Application:getInstance()
local cc_event_dispatcher = cc_director:getEventDispatcher()
local _AppConfig  = helpers.CCAppConfig:sharedAppConfig()
local cc_fileutls = cc.FileUtils:getInstance()
local node_helpers = helpers.NodeHelpers

local _EVENT_TOUCH_BEGAN = cc.Handler.EVENT_TOUCH_BEGAN
local _EVENT_TOUCH_MOVED = cc.Handler.EVENT_TOUCH_MOVED
local _EVENT_TOUCH_ENDED = cc.Handler.EVENT_TOUCH_ENDED

local _EVENT_TOUCHES_BEGAN = cc.Handler.EVENT_TOUCHES_BEGAN
local _EVENT_TOUCHES_MOVED = cc.Handler.EVENT_TOUCHES_MOVED 
local _EVENT_TOUCHES_ENDED = cc.Handler.EVENT_TOUCHES_ENDED

local _winSize = nil
local _visibleSize = nil
local _visibleOrigin = nil
cocosHelper = {
--// The application will come to foreground.
--// This message is posted in cocos/platform/android/jni/Java_org_cocos2dx_lib_Cocos2dxRenderer.cpp.
	EVENT_COME_TO_FOREGROUND  =  "event_come_to_foreground",

--// The renderer[android:GLSurfaceView.Renderer  WP8:Cocos2dRenderer] was recreated.
--// This message is used for reloading resources before renderer is recreated on Android/WP8.
--// This message is posted in cocos/platform/android/javaactivity.cpp and cocos\platform\wp8-xaml\cpp\Cocos2dRenderer.cpp.
	EVENT_RENDERER_RECREATED  =  "event_renderer_recreated",

--// The application will come to background.
--// This message is used for doing something before coming to background, such as save RenderTexture.
--// This message is posted in cocos/platform/android/jni/Java_org_cocos2dx_lib_Cocos2dxRenderer.cpp and cocos\platform\wp8-xaml\cpp\Cocos2dRenderer.cpp.
	EVENT_COME_TO_BACKGROUND  =  "event_come_to_background",

--// added by Shan Lu 2014/12/15 Begin
--// 程序被销毁了
	EVENT_APP_QUIT			  =  "event_app_quit"
--// added by Shan Lu 2014/12/15 End
}

function cocosHelper.init()
	_winSize  		= cc_director:getWinSize()
	_visibleSize    = cc_director:getVisibleSize()
	_visibleOrigin	= cc_director:getVisibleOrigin()
end

function cocosHelper.getWinSize()
	return _winSize
end

function cocosHelper.getVisibleSize()
	return _visibleSize
end

function cocosHelper.getVisibleOrigin()
	return _visibleOrigin
end

function cocosHelper.getRunningScene()
	return cc_director:getRunningScene()
end

function cocosHelper.getVisibleOrigin()
	return cc_director:getVisibleOrigin()
end

function cocosHelper.setScene(scene)
    if cc_director:getRunningScene() then
        cc_director:replaceScene(scene)
    else
        cc_director:runWithScene(scene)
    end
end

function cocosHelper.getTargetPlatform()
	-- body
	return cc_app:getTargetPlatform()
end

function cocosHelper.listenCustomEvent(_type, func, obj)
	local listener = cc.EventListenerCustom:create(_type, func)
	if obj then
		local eventDispatcher = obj:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener, obj)
	else
		cc_event_dispatcher:addEventListenerWithFixedPriority(listener,1)
	end
	return listener
end

function cocosHelper.listenMouseEvent(_type,func)
	local listener = cc.EventListenerMouse:create()
	listener:registerScriptHandler(func,_type)
	cc_event_dispatcher:addEventListenerWithFixedPriority(listener,1)
	return listener
end

function cocosHelper.removeEventListener(listener)
	cc_event_dispatcher:removeEventListener(listener)
end


function cocosHelper.listenTouchAllAtOnceEvent(layer,begin_func, move_func, end_func)
 	local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(begin_func, _EVENT_TOUCHES_BEGAN)
    
    if move_func then
		listener:registerScriptHandler(move_func,  _EVENT_TOUCHES_MOVED)
	end

	if end_func then
		listener:registerScriptHandler(end_func,   _EVENT_TOUCHES_ENDED)
	end

    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    return listener
end


function cocosHelper.listenTouchOneByOneEvent(layer,begin_func, move_func, end_func)
 	local listener = cc.EventListenerTouchOneByOne:create()
    
    listener:registerScriptHandler(begin_func, _EVENT_TOUCH_BEGAN)

    if move_func then
		listener:registerScriptHandler(move_func,  _EVENT_TOUCH_MOVED)
	end

	if end_func then
		listener:registerScriptHandler(end_func,   _EVENT_TOUCH_ENDED)
	end


    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    return listener
end



function cocosHelper.listenKeyboardEvent(_type,func)
	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(func,_type)
	cc_event_dispatcher:addEventListenerWithFixedPriority(listener,1)
	return listener
end

function cocosHelper.findWidgetByName(root,name)
	return node_helpers:seekWidgetByName(root,name)
end

function cocosHelper.safeRemoveFromParent(root,flag)
	return node_helpers:safeRemoveFromParent(root,flag)
end

function cocosHelper.safeRemoveChild(root,child,flag)
	return node_helpers:safeRemoveChild(root,child,flag)
end

function cocosHelper.safeRelease(root,child,flag)
	return node_helpers:safeRemoveChild(root,child,flag)
end

function cocosHelper.creatUI(filename)
	return cc.CSLoader:createNode(filename)
end

function cocosHelper.createTimeline(filename)
	return cc.CSLoader:createTimeline(filename)
end

function cocosHelper.createNode(filename, callback)
	return cc.CSLoader:createNode(filename, callback)
end