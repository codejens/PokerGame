--CLDBoxDownPage.lua
--内容：光棍节-天降宝箱页面类
--作者：肖进超
--时间：2014.10.29

--加载移动位置页面类
require "UI/activity/Common/CMovePlacePage"

--创建光棍节天降宝箱页面类
super_class.WorkBoxDownPage(MovePlacePage)

--功能：定义光棍节天降宝箱页面的基础属性
--参数：self	光棍节天降宝箱页面对象
--返回：无
--作者：肖进超
--时间：2014.10.29
local function create_self_params(self)

end

--功能：创建光棍节天降宝箱页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function WorkBoxDownPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function WorkBoxDownPage:destroy()
	--获取父类
	local t_pageParent = WorkBoxDownPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示页面的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function WorkBoxDownPage:showPageAction()
	WorkDayModel:showLDBoxDownPage(self._isInit)
end

--功能：前往按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function WorkBoxDownPage:forwardButtonAction()
    WorkDayModel:forwardPlace()
end

--功能：传送按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function WorkBoxDownPage:transformButtonAction()
    WorkDayModel:transformPlace()
end