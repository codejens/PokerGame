--Window.lua
--窗口容器基类

require "UI/component/AbstractBase"

local _created_windows_ = {}

super_class.Window(AbstractBasePanel)

function CheckWindowRelease()
	for window,v in pairs(_created_windows_) do 
		CCMessageBox("windows was not destroyed:"..window.__classname, "CheckWindowRelease")
	end
	_created_windows_ = {}
end

function UnRegisterWindow(win)
	_created_windows_[win] = nil
end

function RegisterWindow(win)
	_created_windows_[win] = true
end

function Window.getCreatedWindows()
	return _created_windows_
end

function Window:__init(window_name, texture_name, is_grid, width, height)
	local final_width 	= width  or -1 	--引擎默认-1是图片原大小
	local final_height 	= height or -1

	if texture_name == nil or texture_name == "" then
		texture_name = ""
		if final_width == -1 then
			final_width  = GameScreenConfig.standard_width
		end
		if final_height == -1 then
			final_height = GameScreenConfig.standard_height
		end
	end
	self.window_name = window_name
	if is_grid then
		self.view = CCBasePanel:panelWithFile(0, 0, final_width, final_height, texture_name, 500, 500)
	else
		self.view = CCBasePanel:panelWithFile(0, 0, final_width, final_height, texture_name, 0, 0)
	end
	if self.view == nil then
		return
	end

	self.view:setDefaultMessageReturn(true)

	_created_windows_[self] = true

	safe_retain(self.view)
end

--创建窗口的静态方法，被UIManager调用
function Window:create(window_name, texture_name)
	local window = Window(window_name, texture_name)
	return window
end

--摧毁窗口，被UIManager调用
function Window:destroy()
	if self.view ~= nil then
		safe_release(self.view)
		self.view = nil
	end
	UnRegisterWindow(self)
end

--添加一个节点
function Window:addChild(child)
	if child.view ~= nil then
	 	self.view:addChild(child.view)
	else
	 	self.view:addChild(child)
	end
end

--移除一个节点
function Window:removeChild(child)
	if child.view ~= nil then
	 	self.view:removeChild(child.view, true)
	else
		self.view:removeChild(child, true)
	end
end

--移动
function Window:move(pos_x, pos_y, appear_type)
	local off_x = 0
	local off_y = 0
	if appear_type == 1 then
		off_x = 6
	elseif appear_type == 2 then
		off_x = -6
	elseif appear_type == 3 then
		off_y = 6
	end

	local move_to_act = CCMoveTo:actionWithDuration(0.5, CCPointMake(pos_x+off_x, pos_y+off_y))
	local act_easa    = CCEaseExponentialOut:actionWithAction(move_to_act)
	local move_by_act = CCMoveBy:actionWithDuration(0.1, CCPointMake(-off_x, -off_y))
	local seq_act     = CCSequence:actionOneTwo(act_easa, move_by_act)
	self.view:runAction(seq_act)
end

function Window:setPosition(pos_x, pos_y)
	self.view:setPosition(pos_x, pos_y)
end

--获取窗口宽度
function Window:get_width()
	return self.view:getSize().width
end

--获取窗口高度
function Window:get_height()
	return self.view:getSize().height
end

--被添加或移除的事件
function Window:active(show)
end

--关闭自身
function Window:close()
	UIManager:destroy_window(self.window_name)
end