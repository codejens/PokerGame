--MainPanelCC.lua
--created by liubo on 2015-05-04
--主菜单控制器

MainPanelCC = {}

local DISTANCE_MAX 			= 10000 -- 如果主角一直走的话，我们认为是最远距离是10000像素

local _current_show_icon_type = 0 --当前显示的图标类型 0=活动图标 1=系统图标

--测试数据
local activity_data = {
	[1]= {id=1,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
	[2]= {id=2,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
	[3]= {id=3,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
}
local system_data = {
	[1]= {id=1,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
	[2]= {id=2,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
	[3]= {id=3,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
	[4]= {id=4,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
	[5]= {id=5,normal_path="res/ui/main/activity_1.png",press_path="res/ui/main/activity_1.png"},
}

local task_data = {
	[1]= {id=1,title="龙官夺宝",content="到长寿村渡化亡灵",},
	[2]= {id=2,title="龙官夺宝2",content="到长寿村渡化亡灵2",},
	[3]= {id=3,title="龙官夺宝3",content="到长寿村渡化亡灵3",},
	[4]= {id=4,title="龙官夺宝4",content="到长寿村渡化亡灵4",},
	[5]= {id=5,title="龙官夺宝5",content="到长寿村渡化亡灵5",},
}


function MainPanelCC:init()

end

function MainPanelCC:finish( ... )
	
end

--图标按钮点击回调
function MainPanelCC:icon_cb(id)

end

--创建并初始化主界面
function MainPanelCC:create_win()
	GUIManager:show_window("mainpanel")
    MainPanelCC:update("all")
end

--点击用户
function MainPanelCC:user_cb()
	MainPanelCC:update_icon()
end

--点击背包
function MainPanelCC:bag_cb()
	CommonCC:open_win()
end

--点击任务
function MainPanelCC:task_cb()

end

--点击技能
function MainPanelCC:skill_cb(index)
	local player = EntityManager:get_player_avatar(  )
	player:use_skill(index)

end

--点击必杀技
function MainPanelCC:inevitable_cb()
	local player = EntityManager:get_player_avatar(  )
	player:use_skill(5)
end

--点击地图
function MainPanelCC:map_cb()
	local player = EntityManager:get_player_avatar(  )
	player.model:get_on_riding()
end

--更新图标模块
function MainPanelCC:update_icon()
	local data = {}
	if _current_show_icon_type == 0 then
		data = MainPanelCC:get_activity_icon_data()
		_current_show_icon_type = 1
	elseif _current_show_icon_type == 1 then
		data = MainPanelCC:get_system_icon_data()
		_current_show_icon_type = 0
	end
	local win = GUIManager:find_window("mainpanel")
	win:update("icon","group",data)	
end

--更新任务模块
function MainPanelCC:update_task()
	local data = MainPanelCC:get_task_data()
	local win = GUIManager:find_window("mainpanel")
	win:update("task", "list", data)
end

--更新头像模块
function MainPanelCC:update_head()
	local win = GUIManager:find_window("mainpanel")
	local player = EntityManager:get_player_avatar()
	win:update("head", "all", player)
end

--更新经验模块
function MainPanelCC:update_exp()
	local win = GUIManager:find_window("mainpanel")
	local player = EntityManager:get_player_avatar()
	local player_exp = player.expH *(2^32) + player.expL
    local player_max_exp = player.maxExpH *(2^32) + player.maxExpL
    local percent_value = (player_exp / player_max_exp) * 100
    win:update("exp", "percent", percent_value)
end

--更新地图模块
function MainPanelCC:update_map()
	local win = GUIManager:find_window("mainpanel")
    win:update("map", "all", nil)
end

--更新聊天模块
function MainPanelCC:update_chat()
	local win = GUIManager:find_window("mainpanel")
    win:update("chat", "content", nil)
end

--更新技能模块
function MainPanelCC:update_skill()
	local win = GUIManager:find_window("mainpanel")
    win:update("skill", "icon", nil)
end

--移动摇杆
function MainPanelCC:move_joystick(pos)
	local player = EntityManager:get_player_avatar()
	local target_pos = cc.pMul(pos, DISTANCE_MAX)
	local x,y = SceneManager:view_pos_to_world_pos(target_pos.x, target_pos.y)
	CommandManager:move(player, x, y)
end

--停止移动摇杆
function MainPanelCC:stop_joystick()
	local player = EntityManager:get_player_avatar()
	player:stopMove()
	player:stopAction()
end

-- 更新数据
function MainPanelCC:update(stype)
	if stype == "task" then
		MainPanelCC:update_task()
	elseif stype == "head" then
		MainPanelCC:update_head()
	elseif stype == "exp" then
		MainPanelCC:update_exp()
	elseif stype == "icon" then
		MainPanelCC:update_icon()
	elseif stype == "map" then
		MainPanelCC:update_map()
	elseif stype == "chat" then
		MainPanelCC:update_chat()
	elseif stype == "skill" then
		MainPanelCC:update_skill()
	elseif stype == "all" then
		MainPanelCC:update_task()
		MainPanelCC:update_head()
		MainPanelCC:update_exp()
		MainPanelCC:update_icon()
		MainPanelCC:update_map()
		MainPanelCC:update_chat()
		MainPanelCC:update_skill()
	end
end

--获取活动图标数据
function MainPanelCC:get_activity_icon_data()
	return activity_data
end

--获取系统图标数据
function MainPanelCC:get_system_icon_data()
	return system_data
end

--获取任务数据
function MainPanelCC:get_task_data()
	return task_data
end