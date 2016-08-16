---------HJH
---------2013-11-6
---------通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------ZAbstractBasePanel类
super_class.ZAbstractNode()
---------
---------
function ZAbstractNode:__init()
	self.father_panel = nil
	self.view = nil
	--self.createItemList = {}
	-------
	-------touch begin info
	self.touch_begin_return = true
	self.touch_begin_fun = nil
	-------
	-------touch end info
	self.touch_end_return = true
	self.touch_end_fun = nil
	-------
	-------touch move info
	self.touch_move_return = true
	self.touch_move_fun = nil
	-------
	-------touch click info
	self.touch_click_return = true
	self.touch_click_fun = nil
	-------
	-------touch double click info
	self.touch_double_click_return = true
	self.touch_double_click_fun = nil
	-------
	-------touch timer fun
	self.touch_timer_fun = nil
end
---------
---------
function ZAbstractNode:create()
	 return ZAbstractNode()
end
---------
---------
---------设置TOUCH_BEGAN函数
function ZAbstractNode:setTouchBeganFun(userFunction)
	self.touch_begin_fun = userFunction
end
---------
---------设置TOUCH_BEGIN返回值
function ZAbstractNode:setTouchBeganReturnValue(returnValue)
	self.touch_begin_return = returnValue
end
---------
---------设置TOUCH_MOVED函数
function ZAbstractNode:setTouchMovedFun(userFunction)
	------print("AbstractNode:setTouchMovedFun")
	self.touch_move_fun = userFunction
end
---------
---------设置TOUCH_MOVED返回值
function ZAbstractNode:setTouchMovedReturnValue(returnValue)
	self.touch_move_return = returnValue
end
---------
---------设置TOUCH_ENDED函数
function ZAbstractNode:setTouchEndedFun(userFunction)
	self.touch_end_fun = userFunction
end
---------
---------设置TOUCH_ENDED返回值
function ZAbstractNode:setTouchEndedReturnValue(returnValue)
	self.touch_end_return = returnValue
end
---------
---------设置TOUCH_CLICK函数
function ZAbstractNode:setTouchClickFun(userFunction)
	self.touch_click_fun = userFunction
end
---------
---------设置TOUCH_CLICK返回值
function ZAbstractNode:setTouchClickReturnValue(returnValue)
	self.touch_click_return = returnValue
end
---------
---------设置TOUCH_DOUBLE_CLICK函数
function ZAbstractNode:setTouchDoubleClickFun(userFunction)
	self.touch_double_click_fun = userFunction
end
---------
---------设置TOUCH_DOUBLE_CLICK返回值
function ZAbstractNode:setTouchDoubleClickReturnValue(returnValue)
	self.touch_double_click_return = returnValue
end
---------
---------设置所有事件的返回值
function ZAbstractNode:setDefaultReturnValue( returnValue )
	self:setTouchBeganReturnValue(returnValue)
	self:setTouchEndedReturnValue(returnValue)
	self:setTouchClickReturnValue(returnValue)
end

---------
---------设置TOUCH_TIMER函数
function ZAbstractNode:setTouchTimerFun(userFunction)
	self.touch_timer_fun = userFunction
end
---------
---------
function ZAbstractNode:setPosition(x, y)
	if self.view ~= nil then
		self.view:setPosition(x, y)
	end
end
---------
---------
function ZAbstractNode:getPosition()
	if self.view ~= nil then
		return self.view:getPositionS()
	end
end
---------
---------
function ZAbstractNode:addChild(item, z)
	z = z or 0
	if self.view ~= nil then
		if item.view ~= nil then
			self.view:addChild(item.view, z)
		else
			self.view:addChild(item, z)
		end
	end
end
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------抽像BasePanel类，只提供方法
super_class.ZAbstractBasePanel(ZAbstractNode)
---------

function ZAbstractBasePanel:__init( width, height )
	self.width  = width
	self.height = height
end

---------抽像BasePanel类消息注册方法
function ZAbstractBasePanel:registerScriptFun()
	if self.view ~= nil then
		local function basePanelMessageFun(eventType, args, msgid, selfItem)
			-------
			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				if self.touch_begin_fun ~= nil then
					self:touch_begin_fun(args)
				end
				return self.touch_begin_return
			elseif eventType == TOUCH_MOVED then
				if self.touch_move_fun ~= nil then
					self:touch_move_fun(args)
				end
				return self.touch_move_return
			elseif eventType == TOUCH_ENDED then
				if self.touch_end_fun ~= nil then
					self:touch_end_fun(args)
				end
				return self.touch_end_return
			elseif eventType == TOUCH_CLICK then
				if self.touch_click_fun ~= nil then
					self:touch_click_fun(args)
				end
				return self.touch_click_return
			elseif eventType == TOUCH_DOUBLE_CLICK then
				if self.touch_double_click_fun ~= nil then
					self:touch_double_click_fun(args)
				end
				return self.touch_double_click_return
			elseif eventType == TIMER then
				if self.touch_timer_fun ~= nil then
					self:touch_timer_fun()
				end
				return true
			end
		end
		-------
		self.view:registerScriptHandler(basePanelMessageFun)
	end
end
---------
---------设置大小
function ZAbstractBasePanel:setSize(width, height)
	if self.view ~= nil then
		self.view:setSize(width, height)
		self.width	= width
		self.height = height
	end
end
---------
---------设置图片
function ZAbstractBasePanel:setImage(image)
	if self.view ~= nil then
		self.view:setTexture(image)
	end
end
---------
---------设置锚点
function ZAbstractBasePanel:setAnchorPoint(x, y)
	if self.view ~= nil then
		self.view:setAnchorPoint(x, y)
	end
end
---------
---------设置定时器
function ZAbstractBasePanel:setTimer(rate)
	if self.view ~= nil then
		self.view:setTimer(rate)
	end
end
---------
---------设置消息ID
function ZAbstractBasePanel:setMessageId(id)
	if self.view ~= nil then
		self.view:setMessageIndex(id)
	end
end
---------
---------取得大小
function ZAbstractBasePanel:getSize()
	if self.view ~= nil then
		return self.view:getSize()
	end
end
---------
---------取得消息Id
function ZAbstractBasePanel:getMessageId()
	if self.view ~= nil then
		return self.view:getMessageIndex()
	end
end
---------
---------
function ZAbstractBasePanel:setCurState(state)
	if self.view ~= nil then
		self.view:setCurState(state)
	end
end
----------------------------------------------------------------------
----------------------------------------------------------------------