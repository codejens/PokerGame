-----------------------------------------------------------------------------
-- 节点类
-- @author lushan
-- 
-----------------------------------------------------------------------------

--!class GUITouchBase

GUITouchBase = simple_class(GUIBase) 

--- 构造函数
-- @param view cpp控件对象
-- @see GUIBase
-- @see members
function GUITouchBase:__init(view)
	self.class_name = "GUITouchBase"
	-- print("self.class_name=",self.class_name)
	self.touch_event_func = {}
	-- xprint("111111111111111")
	self:addTouchEventListener()
	-- self.init_count = self.init_count or 1
	-- self.init_count = self.init_count + 1
end

-- function GUITouchBase:addTouchEventListener(touchEvent)
-- 	self.view:setTouchEnabled(true)
-- 	self.view:addTouchEventListener(touchEvent)
-- end

-- function GUITouchBase:addCLickEventListener( touchEvent )
-- 	self.view:setTouchEnabled(true)
-- 	local function _click_func( sender,eventType )

-- 	  if eventType == ccui.TouchEventType.ended then
-- 	  		touchEvent(sender)
-- 	  end
-- 	end
-- 	self.view:addTouchEventListener(_click_func)
-- end

function GUITouchBase:set_all_touch_func(func)
	self.all_touch_func = func
end

function GUITouchBase:set_click_func(func)
	self.touch_event_func[ccui.TouchEventType.ended] = func
end

function GUITouchBase:set_touch_func(eventType,func)
	self.touch_event_func[eventType] = func
end

function GUITouchBase:addTouchEventListener()
	if self.core == nil then
		return
	end
	-- Utils:print_table(self)
	self:setTouchEnabled(true)
	local function touch_event_func(sender,eventType)
		if self.all_touch_func then
			return self.all_touch_func(sender,eventType)
		else
			self:touch_event_handle(sender,eventType)
		end
	end
	self.core:addTouchEventListener(touch_event_func)
end

function GUITouchBase:touch_event_handle(sender,eventType)
	-- if eventType == ccui.TouchEventType.began then
		local func = self.touch_event_func[eventType]
		if func then
			func(sender,eventType)
		end
		-- elseif eventType == ccui.TouchEventType.moved then
		-- elseif eventType == ccui.TouchEventType.ended then
		-- elseif eventType == ccui.TouchEventType.canceled then
		-- end
end