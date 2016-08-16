--BaseEditWin.lua
--编辑器编辑的窗口基类

super_class.BaseEditWin(Window)

--构造函数
function BaseEditWin:__init(window_name, texture_name, is_grid, width, height, text, layout)
	self.layout = layout

	-- 保存所有布局文件创建的控件
	self.result = {}
	self:create_by_layout(layout)

	-- 可已处理窗口统一事件
	self:do_middle_func()

	self:_save_widget()     
	
end

-- 初始完成后，执行方法
function BaseEditWin:do_middle_func( )
	-- 关闭按钮
	self.btn_close = self:get_widget_by_name( "btn_close")
	if self.btn_close then
		local function btn_close_func()
			--SoundManager:play_ui_effect( 3 )
			self:close()
		end
		self.btn_close:set_click_func(btn_close_func)
	end
end

-- 根据布局文件创建界面并保存
function BaseEditWin:create_by_layout( layout )
	self.result = UICreateByLayout( layout )
	self.view:addChild(self.result["root"].view)
	-- self.view:addChild(self.result["root"])
end

-- 根据名字获取控件
function BaseEditWin:get_widget_by_name( name )
	
	if not self.result[name] then
		--获得不到控件的情况下  可能是不需要加载的控件
		----print( "BaseEditWin", "找不到该控件", name)
	end
	return self.result[name]
end

function BaseEditWin:get_page_by_name( name )
	if not self.result[name] then
		--获得不到控件的情况下  可能是不需要加载的控件
		self.result = UICreateLayoutByName( self.result,self.layout,name)
	end
	return self.result[name]
end

function BaseEditWin:destroy()
	Window.destroy(self)
	-- body
end

-- 子类重写
-- 获取UI控件
function BaseEditWin:_save_widget( )
	self:save_widget()
	self:registered_envetn_func()
end
-- 子类重写
-- 获取UI控件
function BaseEditWin:save_widget( )

end

-- 子类重写
-- 注册事件方法
function BaseEditWin:registered_envetn_func(  )

end



