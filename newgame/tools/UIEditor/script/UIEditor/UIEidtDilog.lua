--UIEidtDilog.lua

super_class.UIEidtDilog()

function UIEidtDilog:__init()
	local root = SPanel:create("", 200, 600)
	root:setPosition(750, 20)

	self.panel = SPanel:create("sui/common/panel9.png", 200, 600, true)
	root:addChild(self.panel)

	self.view = root.view

	self.can_move = false
	local function began_event(x, y)
		self.can_move = true
	end
	local function move_event(etype, x, y)
	end
	local function end_event(x, y)
		UIEditModel:unselect_widget()
		self.can_move = false
	end

	self.panel:set_touch_func(TOUCH_BEGAN, began_event)
	self.panel:set_touch_func(TOUCH_MOVED, move_event)
	self.panel:set_touch_func(TOUCH_ENDED, end_event)

	self:create_btn()
end

--最后必须为控件开关
local _name = {
	"按钮","面板","文本","图片","输入框","文字按钮","区域文字","滑动控件","组选按钮","组选子项",
	"物品控件","进度条","勾选按钮","开关按钮","拖动条","触摸面板","控件开关"
}

function UIEidtDilog:create_btn()
	local x = 10
	local y = 550

	for i=1, #_name do
		local bg_panel = SPanel:create("sui/common/frame.png", 85, 30, true)
		if i == #_name then
			x = 10
			y = 0
		end
		if i == 14 then
			x = 105
			y = 550
		end
		bg_panel:setPosition(x, y)
		y = y - 40

		local label = SLabel:create(_name[i], FONT_DEF_SIZE, ALIGN_CENTER) 
		label:setPosition(85/2, 5)

		bg_panel:addChild(label)

		local function panel_click_func(etype, x, y)
			if i == #_name then
				UIEidtAllWidget:show_windows()
				return true
			end
			UIEditModel:select_widget(i)
			return true
		end 
		local function panel_end_func()
			UIEditModel:unselect_widget()
			return true
		end 
		bg_panel:set_touch_func(TOUCH_BEGAN, panel_click_func)
		bg_panel:set_touch_func(TOUCH_ENDED, panel_end_func)

		self.panel:addChild(bg_panel)
	end
end

function UIEidtDilog:move(dx, dy)
	local x,y = self.view:getPosition()
	self.view:setPosition(x+dx, y+dy)
end