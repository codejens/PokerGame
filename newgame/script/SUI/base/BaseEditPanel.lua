--BaseEditPanel.lua
--编辑器编辑的Panel

super_class.BaseEditPanel()

--构造函数
function BaseEditPanel:__init(layout)
	self.layout = layout
	-- 保存所有布局文件创建的控件
	self.result = {}
	self:create_by_layout(layout)
	--可已处理窗口统一事件
	self:save_widget()    
	self:registered_envetn_func()
end

--根据布局文件创建界面
function BaseEditPanel:create_by_layout(layout)
	self.result = UICreateByLayout(layout)
	self.view   = self.result["root"].view
end

--根据名字获取控件
function BaseEditPanel:get_widget_by_name(name)
	if not self.result[name] then
	end
	return self.result[name]
end

--根据名字获取页面
function BaseEditPanel:get_page_by_name(name)
	if not self.result[name] then
		--获得不到控件的情况下，可能是不需要加载的控件
		self.result = UICreateLayoutByName(self.result, self.layout, name)
	end
	return self.result[name]
end

--销毁
function BaseEditPanel:destroy()
end

--获取UI控件
function BaseEditPanel:save_widget()
end

--注册事件
function BaseEditPanel:registered_envetn_func()
end


