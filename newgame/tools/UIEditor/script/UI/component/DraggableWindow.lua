-- DraggableWindow.lua
-- created by aXing on 2013-2-21
-- 可以拖动的窗口

require "UI/component/Window"
require "utils/Utils"

super_class.DraggableWindow(Window)

function DraggableWindow:__init( window_name, texture_name, pos_x, pos_y, width, height )

	self.before_x = 0		        -- 记录上一帧的鼠标位置，用于拖动
	self.before_y = 0
	self.move_begin_flag = false    -- 标记是否开始拖动, 如果没有接收到开始消息（即被上层控件截取消息，就不可拖动）

	-- 注册拖动事件
    local function regist_drag_start_event(  )
    	self.move_begin_flag = true
    end
	local function regist_drag_event( self, args )
		if not self.move_begin_flag then
            return true
		end
		local temparg = Utils:Split(args, ":")
		local x  = tonumber(temparg[1])	--列数
		local y  = tonumber(temparg[2])	--行数

		if self.before_x == 0 and self.before_y == 0 then
			self.before_x = x
			self.before_y = y
		end

		local dx = x - self.before_x
		local dy = y - self.before_y
		local posX, posY = self.view:getPosition()
		self.view:setPosition(posX + dx, posY + dy);
		self.before_x = x
		self.before_y = y
	end

	local function regist_drag_end_event(  )
	    self.move_begin_flag = false
		self.before_x = 0
		self.before_y = 0
	end
	
	self:registerScriptFun()
	self:setTouchBeganFun( regist_drag_start_event )
	self:setTouchMovedFun(regist_drag_event)
	self:setTouchEndedFun(regist_drag_end_event)
end

-- 创建窗口的静态方法，被UIManager调用
function DraggableWindow:create( window_name, texture_name )
	local window = DraggableWindow(window_name, texture_name)
	--window:registerScriptFun()
	return window
end


