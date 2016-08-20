---------HJH
---------2012-2-15
---------通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------AbstractBasePanel类
super_class.AbstractNode()
---------
---------
function AbstractNode:__init()
	-- self.father_panel = fatherPanel
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
function AbstractNode:create()
	 return AbstractNode()
end
---------
---------
---------设置TOUCH_BEGAN函数
function AbstractNode:setTouchBeganFun(userFunction)
	self.touch_begin_fun = userFunction
end
---------
---------设置TOUCH_BEGIN返回值
function AbstractNode:setTouchBeganReturnValue(returnValue)
	self.touch_begin_return = returnValue
end
---------
---------设置TOUCH_MOVED函数
function AbstractNode:setTouchMovedFun(userFunction)
	------print("AbstractNode:setTouchMovedFun")
	self.touch_move_fun = userFunction
end
---------
---------设置TOUCH_MOVED返回值
function AbstractNode:setTouchMovedReturnValue(returnValue)
	self.touch_move_return = returnValue
end
---------
---------设置TOUCH_ENDED函数
function AbstractNode:setTouchEndedFun(userFunction)
	self.touch_end_fun = userFunction
end
---------
---------设置TOUCH_ENDED返回值
function AbstractNode:setTouchEndedReturnValue(returnValue)
	self.touch_end_return = returnValue
end
---------
---------设置TOUCH_CLICK函数
function AbstractNode:setTouchClickFun(userFunction)
	self.touch_click_fun = userFunction
end
---------
---------设置TOUCH_CLICK返回值
function AbstractNode:setTouchClickReturnValue(returnValue)
	self.touch_click_return = returnValue
end
---------
---------设置TOUCH_DOUBLE_CLICK函数
function AbstractNode:setTouchDoubleClickFun(userFunction)
	self.touch_double_click_fun = userFunction
end
---------
---------设置TOUCH_DOUBLE_CLICK返回值
function AbstractNode:setTouchDoubleClickReturnValue(returnValue)
	self.touch_double_click_return = returnValue
end
---------
---------设置TOUCH_TIMER函数
function AbstractNode:setTouchTimerFun(userFunction)
	self.touch_timer_fun = userFunction
end
---------
---------
function AbstractNode:setPosition(x, y)
	if self.view ~= nil then
		self.view:setPosition(x, y)
	end
end
---------
---------
function AbstractNode:getPosition()
	if self.view ~= nil then
		return self.view:getPositionS()
	end
end
---------
---------
function AbstractNode:addChild(item)
	if self.view ~= nil then
		self.view:addChild(item.view)
	end
end
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------抽像BasePanel类，只提供方法
super_class.AbstractBasePanel(AbstractNode)
---------
---------抽像BasePanel类消息注册方法
function AbstractBasePanel:registerScriptFun()
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
				------print("self.touch_click_fun",self.touch_click_fun)
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
					self.touch_timer_fun()
				end
				return true
			end
		end
		-------
		self.view:registerScriptHandler(basePanelMessageFun)
	end
end
-- ---------
-- ---------设置位置
-- function AbstractBasePanel:setPos(x, y)
-- 	if self.view ~= nil then
-- 		self.view:setPosition(x, y)
-- 	end
-- end
---------
---------设置大小
function AbstractBasePanel:setSize(width, height)
	if self.view ~= nil then
		self.view:setSize(width, height)
	end
end
---------
---------设置图片
function AbstractBasePanel:setImage(image)
	if self.view ~= nil then
		self.view:setTexture(image)
	end
end
---------
---------设置锚点
function AbstractBasePanel:setAnchorPoint(x, y)
	if self.view ~= nil then
		self.view:setAnchorPoint(x, y)
	end
end
---------
---------设置定时器
function AbstractBasePanel:setTimer(rate)
	if self.view ~= nil then
		self.view:setTimer(rate)
	end
end
---------
---------设置消息ID
function AbstractBasePanel:setMessageId(id)
	if self.view ~= nil then
		self.view:setMessageIndex(id)
	end
end
---------
---------
---------
-- ---------取得位置
-- function AbstractBasePanel:getPos()
-- 	if self.view ~= nil then
-- 		return self.view:getPositionS()
-- 	end
-- end
---------
---------取得大小
function AbstractBasePanel:getSize()
	if self.view ~= nil then
		return self.view:getSize()
	end
end
---------
---------取得消息Id
function AbstractBasePanel:getMessageId()
	if self.view ~= nil then
		return self.view:getMessageIndex()
	end
end
---------
---------
function AbstractBasePanel:setCurState(state)
	if self.view ~= nil then
		self.view:setCurState(state)
	end
end
----------------------------------------------------------------------
----------------------------------------------------------------------