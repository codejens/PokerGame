---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------抽象面板类，只提供方法

require "XWidget/base/XAbstructNode"

super_class.XAbstructPanel(XAbstructNode)

---------
---------
function XAbstructPanel:__init()

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
---------设置TOUCH_BEGAN函数
function XAbstructPanel:setTouchBeganFun(userFunction)
	self.touch_begin_fun = userFunction
end

---------
---------设置TOUCH_BEGIN返回值
function XAbstructPanel:setTouchBeganReturnValue(returnValue)
	self.touch_begin_return = returnValue
end

---------
---------设置TOUCH_MOVED函数
function XAbstructPanel:setTouchMovedFun(userFunction)
	--print("AbstractNode:setTouchMovedFun")
	self.touch_move_fun = userFunction
end

---------
---------设置TOUCH_MOVED返回值
function XAbstructPanel:setTouchMovedReturnValue(returnValue)
	self.touch_move_return = returnValue
end

---------
---------设置TOUCH_ENDED函数
function XAbstructPanel:setTouchEndedFun(userFunction)
	self.touch_end_fun = userFunction
end

---------
---------设置TOUCH_ENDED返回值
function XAbstructPanel:setTouchEndedReturnValue(returnValue)
	self.touch_end_return = returnValue
end

---------
---------设置TOUCH_CLICK函数
function XAbstructPanel:setTouchClickFun(userFunction)
	self.touch_click_fun = userFunction
end

---------
---------设置TOUCH_CLICK返回值
function XAbstructPanel:setTouchClickReturnValue(returnValue)
	self.touch_click_return = returnValue
end

---------
---------设置TOUCH_DOUBLE_CLICK函数
function XAbstructPanel:setTouchDoubleClickFun(userFunction)
	self.touch_double_click_fun = userFunction
end

---------
---------设置TOUCH_DOUBLE_CLICK返回值
function XAbstructPanel:setTouchDoubleClickReturnValue(returnValue)
	self.touch_double_click_return = returnValue
end

---------
---------设置所有事件的返回值
function XAbstructPanel:setAllDefaultReturnValue( returnValue )
	self:setTouchBeganReturnValue(returnValue)
	self:setTouchEndedReturnValue(returnValue)
	self:setTouchClickReturnValue(returnValue)
end

---------
---------设置TOUCH_TIMER函数
function XAbstructPanel:setTouchTimerFun(userFunction)
	self.touch_timer_fun = userFunction
end

---------
---------设置大小
function XAbstructPanel:setSize(width, height)
	self.view:setSize(width, height)
end

---------
---------取得大小
function XAbstructPanel:getSize()
	return self.view:getSize()
end

---------
---------设置X翻转
function XAbstructPanel:setFlipX(result)
	self.view:setFlipX(result)
end

---------
---------设置Y翻转
function XAbstructPanel:setFlipY(result)
	self.view:setFlipY(result)
end

---------
---------设置当前点击状态
function XAbstructPanel:setCurState(state)
	self.view:setCurState(state)
end

---------
---------取得当前点击状态
function XAbstructPanel:getCurState()
	return self.view:getCurState()
end

---------
---------设置是否不向下传消息
function XAbstructPanel:setMessageCut(result)
	self.view:setMessageCut(result)
end

---------
---------设置是否使用双击事件
function XAbstructPanel:setEnableDoubleClick(result)
	self.view:setEnableDoubleClick(result)
end

---------
---------设置图片
function XAbstructPanel:setTexture(file)
	self.view:setTexture(file)
end

---------
---------设置注册函数
function XAbstructPanel:registerScriptFun()
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