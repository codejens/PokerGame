--Examplepage.lua (结合ExamplePageWin使用)
--create by chj on 2015.8.17
--伙伴属性也

Examplepage = simple_class(BasePage)

-- ========================================== 更新部分(自定义更新部分可卸载update下面)
-- 更新统一接口
function Examplepage:update(utype, date)
	if utype == "xxx" then
		self:update_xxx(date)
	end
end

function Examplepage:update_xxx(date)
end

-- ========================================== 自定义部分

-- ========================================== 本窗口构造部分(构造函数)
function Examplepage:__init(view,result)
	BasePage.__init(self,view,result)
end

function Examplepage:create(parent, name)
	local view = parent:get_page_by_name(name)
    return Examplepage(view, parent.result)
end

-- ========================================== 重写部分(由父类构造函数调用)
-- 保存控件
function Examplepage:save_widget()
	self.btn_xx = self:get_widget_by_name("xxx")
end

-- 注册事件方法
function Examplepage:registered_envetn_func()
	-- self.jj_auto_buy:set_click_func(auto_buy_btn_func)
end