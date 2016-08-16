-- ExampleWin.lua
-- windows 创建范例 (基于ui编辑器的)

super_class.ExampleWin( BaseEditWin)

local  function btn_xx_func( eventType, x, y)
	-- body
end 

-- ========================================== 更新部分(自定义更新部分可卸载update下面)
-- 更新统一接口
function ExampleWin:update( utype, date )
	if utype == "xxx" then
		self:update_xxx( data)
	else

	end
end

function ExampleWin:update_xxx( data)
	-- body
end


-- ========================================== 本窗口构造部分(构造函数)
function ExampleWin:__init(  )

end

-- 显示窗口事件
function ExampleWin:active( show)
	if show then

	end
end


-- ========================================== 自定义部分

-- ========================================== 重写部分(由父类构造函数调用)
-- 获取UI控件
function ExampleWin:save_widget( )
	--定义好需要用到的控件
	self.root = self:get_widget_by_name("win_root")
	-- self.btn_xx = self:get_widget_by_name("xxx")
end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function ExampleWin:registered_envetn_func(  )

	-- self.btn_xx:set_click_func( btn_xx_func)
end


-- window (913x605)
-- 内容主面板(862x530)