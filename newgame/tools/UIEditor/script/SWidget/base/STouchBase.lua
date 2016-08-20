--STouchBase.lua
--create by tjh on 2015.7.12
--接收事件控件抽象基类

STouchBase = simple_class(SWidgetBase)


function STouchBase:__init( view,layout )
	
	SWidgetBase.__init(self,view,layout)
	--事件处理函数表
	self.touch_event_func = {}

	--所有事件都自己处理
	self.all_touch_func = nil

	self:registerScriptFun()
end

--设置事件回调函数
--@param eventType 事件类型
--@param func 	   事件处理函数
function STouchBase:set_touch_func( eventType, func )
	self.touch_event_func[eventType] = func
end

--设置点击事件回调 比较常用 所以加个方法
function STouchBase:set_click_func( func )
	self.touch_event_func[TOUCH_CLICK] = func
end

--设置接收所有消息
function STouchBase:set_all_touch_func( func )
	self.all_touch_func = func
end

--设置时间消息是否穿透
function STouchBase:set_message_pass( bool )
	self.view:setDefaultMessageReturn( bool )
end

function STouchBase:registerScriptFun(  )

	if self.view ~= nil then

		local function basePanelMessageFun(eventType, args, msgid, selfItem)

			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end

			if self.all_touch_func then
				return self.all_touch_func(eventType, args, msgid, selfItem)
			end

			--scroll特殊
			if eventType == SCROLL_CREATE_ITEM then
				if self.touch_event_func[eventType] then
					args = Utils:Split(args,":")
					--args[1] 行 args[2] 列
					local item = self.touch_event_func[eventType](args[1])
					self:addItem(item)
					self:refresh()
				end
				return true
			end
			
			args = Utils:Split(args,":")
			local x,y = args[1], args[2]

			if self.touch_event_func[eventType] then

				return self.touch_event_func[eventType](eventType,x,y)
			end

			return true
		end

		self.view:registerScriptHandler(basePanelMessageFun)
	end

end
