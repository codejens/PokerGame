--BasePage.lua
--create by tjh on 2015.8.11
--基础页

BasePage = simple_class(SWidgetBase)

function BasePage:__init(view, result, parent)
	SWidgetBase.__init(self, view)
	self.result = result
	self.parent = parent
	self:save_widget()
	self:registered_envetn_func()
end

--根据名字获取控件
function BasePage:get_widget_by_name(name)
	if not self.result[name] then
	end
	return self.result[name]
end

--子类重写
--获取UI控件
function BasePage:save_widget()
end

--注册事件
function BasePage:registered_envetn_func()
end

--更新接口
function BasePage:update(utype, date)
end
