--CommonCC.lua
--created by liubo on 2015-05-04
--常用窗口控制器

CommonCC = {}

local _WIN_NAME = "common"

local _menu_data = {
	[1]= {name="user",title="人物"},
	[2]= {name="bag",title="背包"},
	[3]= {name="mount",title="坐骑"},
	[4]= {name="pet",title="宠物"},
	[5]= {name="wing",title="翅膀"},
	[6]= {name="shenbing",title="神兵"},
	[7]= {name="zhanling",title="战灵"},
	[8]= {name="yingji",title="影迹"},
	[9]= {name="shehu",title="神护"},
}

function CommonCC:init()

end

function CommonCC:finish( ... )
	
end

--打开窗口
function CommonCC:open_win()
	GUIManager:show_window(_WIN_NAME)
	CommonCC:create_menu()
	CommonCC:menu_cb(1)
end

--关闭窗口
function CommonCC:colse_win()
	GUIManager:hide_window(_WIN_NAME)
end

--创建菜单
function CommonCC:create_menu()
	local win = GUIManager:find_window("common")
	if win then
		local data = CommonCC:get_menu_data()
		win:create_menu(data)
	end
end

--获取菜单数据
function CommonCC:get_menu_data()
	return _menu_data
end

--菜单点击回调
function CommonCC:menu_cb(index)
	local win = GUIManager:find_window("common")
	if win then
		local data = CommonCC:get_menu_data()
		local page_name = data[index].name
		win:slelcted_menu(index)
		win:show_page(page_name)
	end
end