--SSwitchBtnNew.lua
--开关按钮(方便UI编辑器编辑)

SSwitchBtnNew = simple_class(SWidgetBase)

function SSwitchBtnNew:__init(view, layout, switch_but)
	SWidgetBase.__init(self, view, layout)
	self.switch_but = switch_but
	-- self:set_sound_id(4)
end

function SSwitchBtnNew:create_by_layout(layout)
	local switch_but = UIButton:create_switch_button_new(layout.pos[1], layout.pos[2], layout.size[1], layout.size[2],
														 layout.img_n, layout.img_s, layout.str, 0, layout.fontsize)
	return self(switch_but.view,layout,switch_but)
end

--设置回调
function SSwitchBtnNew:set_click_func(func)
	self.switch_but.callback_fun = func
end

--设置文本
function SSwitchBtnNew:setText(str)
	self.switch_but.setString(str)
end

--获取勾选状态
function SSwitchBtnNew:get_if_selected()
	return self.switch_but.if_selected
end

function SSwitchBtnNew:get_size()

end

function SSwitchBtnNew:setSize(w, h)
	if self.switch_but.setSize then
		self.switch_but.setSize(w, h)
	end
end

function SSwitchBtnNew:setFontSize(f_size)
	if self.switch_but.setFontSize then
		self.switch_but.setFontSize(f_size)
	end
end

function SSwitchBtnNew:set_state(if_select, callback)
	if self.switch_but.set_state then
		self.switch_but.set_state(if_select, callback)
	end
end
