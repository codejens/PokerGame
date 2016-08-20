--VLuopanPage.lua
--内容：情人节，幸运转盘活动页面类
--作者：郭志楠
--时间：2015-2-6

--加载跳转活动页面类
require "UI/activity/Common/CGotoActivityPage"

super_class.VLuopanPage(GotoActivityPage)

--功能：定义情人节-活动页面的基础属性
local function create_self_params(self)

end

--功能：创建情人节-每日限购活动页面的基础初始化函数
function VLuopanPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
function VLuopanPage:destroy()
	--获取父类
	local t_pageParent = VLuopanPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示页面的行为动作
function VLuopanPage:showPageAction()
	ValentineDayModel:showVLuoPanPage(self._isInit)
end

--功能：查看活动按钮执行的行为动作
function VLuopanPage:gotoButtonAction()
	--黄金罗盘（幸运转盘）
    UIManager:show_window("luopan_win")
end