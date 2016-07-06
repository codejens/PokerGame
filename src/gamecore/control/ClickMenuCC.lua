-- ClickMenuCC.lua
-- created by liubo on 2015-05-15
-- 点击菜单控制层

ClickMenuCC = {}

function ClickMenuCC:fini( ... )

end

--显示菜单
--data = {{func=cb_function, param=cb_func_param, name="私聊"},...} 
--data[i].func 菜单回调函数 | data[i].param 透传参数，通过回调函数透传 | data[i].name 菜单名字
--pos_x 菜单显示位置x轴坐标
--pos_y 菜单显示位置y轴坐标
function ClickMenuCC:show_menu(data, pos_x, pos_y)
	local click_menu = ClickMenu:create(data)
	click_menu:setBgPosition(pos_x or 0, pos_y or 0)
	ModalCC:show_modal(click_menu.view)
end