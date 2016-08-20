--VCTeHuiPage.lua
--内容：版本庆典活动，修复雁门关
--作者：郭志楠
--时间：2015-4-21

--加载跳转活动页面类
require "UI/activity/Common/CGotoActivityPage"

super_class.VCTeHuiPage(GotoActivityPage)

--功能：定义情人节-活动页面的基础属性
local function create_self_params(self)

end

--功能：创建情人节-每日限购活动页面的基础初始化函数
function VCTeHuiPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
function VCTeHuiPage:destroy()
	--获取父类
	local t_pageParent = VCTeHuiPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示页面的行为动作
function VCTeHuiPage:showPageAction()
	VersionCelebrationModel:showTeHuiPage(self._isInit)
end

--功能：查看活动按钮执行的行为动作
function VCTeHuiPage:gotoButtonAction()
	UIManager:show_window("tehui_win") 
end