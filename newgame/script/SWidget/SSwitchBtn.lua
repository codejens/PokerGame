--SSwitchBtn.lua
--create by tjh on 2015.8.11
--勾选按钮 在已有的代码上封装 方便UI编辑器编辑

SSwitchBtn = simple_class(SWidgetBase)

function SSwitchBtn:__init( view,layout,switch_but )
	SWidgetBase.__init(self,view,layout)
	self.switch_but = switch_but
	-- self:set_sound_id(4)
end

function SSwitchBtn:create_by_layout( layout )

	local word_x = layout.word_x or 30
	local switch_but = UIButton:create_switch_button( layout.pos[1], layout.pos[2], layout.size[1], layout.size[2],
	 layout.img_n,layout.img_s, layout.str,
	 word_x, FONT_DEF_SIZE-2)
	return self(switch_but.view,layout,switch_but)
end

--设置回调
function SSwitchBtn:set_click_func( func )
	self.switch_but.callback_fun = func
end

--设置文本
function SSwitchBtn:setText( str )
	self.switch_but.setString(str)
end

-- 获取勾选状态
function SSwitchBtn:get_if_selected( )
	return self.switch_but.if_selected
end

function SSwitchBtn:set_state(if_select,callback)
	if self.switch_but.set_state then 
		self.switch_but.set_state(if_select,callback)
	end
end
