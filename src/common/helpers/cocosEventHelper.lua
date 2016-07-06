cocosEventHelper = {}

local script_cb_helpers = helpers.ScriptCallbackHelpers
local sys_helpers = helpers.SystemHelpers
local CFUNCTION = luaFunToCFunc.convert
-- 节点触摸事件类别
cocosEventHelper.EventType = {
	EVENT_TOUCH_BEGAN      = cc.Handler.EVENT_TOUCH_BEGAN,
	EVENT_TOUCH_MOVED      = cc.Handler.EVENT_TOUCH_MOVED,
	EVENT_TOUCH_ENDED      = cc.Handler.EVENT_TOUCH_ENDED,
	EVENT_TOUCH_CANCELLED  = cc.Handler.EVENT_TOUCH_CANCELLED,
}

cocosEventHelper.AnimateEvent = 
{
    eFrameStart = 0,
    eFrameEvent = 1,
    eFrameEnd   = 2
}


function cocosEventHelper.listenAppEvents(func)
	script_cb_helpers:listenAppEvents(CFUNCTION(func))
end

function cocosEventHelper.listenFrameEvent(sp, func)
	script_cb_helpers:listenFrameEvent(sp,CFUNCTION(func))
end

function cocosEventHelper.listenActionNodeEvent(sp, func)
    script_cb_helpers:listenActionNodeEvent(sp,CFUNCTION(func))
end


function cocosEventHelper.setLastFrameCallFunc(sp, func)
    script_cb_helpers:setLastFrameCallFunc(sp,CFUNCTION(func))
end
-- 注册节点方法  by lyl
-- node: 注册的监听事件的节点
-- func: 回调函数
-- eventType：触摸事件类型.  见  NodeEventType 
-- swallow 是否吞没 默认false
function cocosEventHelper.registerScriptHandler( node, func, eventType, swallow )
    
    -- 事件回调
	local function eventCallbackFunc( touch, event )
        return func( touch, event )
    end

   local function onTouchBegan(touch, event)
       --return false
    end

    -- 监听
    local  listener = cc.EventListenerTouchOneByOne:create();
    --强制注册began事件 不然无法单独注册除began事件以外的事件
    listener:registerScriptHandler( onTouchBegan, cocosEventHelper.EventType.EVENT_TOUCH_BEGAN )
   
    listener:registerScriptHandler( eventCallbackFunc, eventType)
    listener:setSwallowTouches(swallow or false)
    -- 加入监听
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node);
end

--- 注册 widget 事件函数
-- @param widget cpp widget控件对象
-- @param func 回调函数
-- @param eventType 事件类型   ccui.TouchEventType.ended
--[[ccui.TouchEventType =
{
    began = 0,
    moved = 1,
    ended = 2,
    canceled = 3,
}  
]]
function cocosEventHelper.registerWidgetLisnter( widget, func, eventType_p )
    local function callback( sender, eventType )
        if eventType == eventType_p then 
            func( sender, eventType )
        end
    end
    widget:setTouchEnabled(true)
    widget:addTouchEventListener(callback)
end