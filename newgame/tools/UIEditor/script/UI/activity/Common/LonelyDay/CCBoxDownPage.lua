--CCBoxDownPage.lua
--内容：圣诞节天降宝箱页面类
--作者：肖进超
--时间：2014.12.17

--加载移动位置页面类
require "UI/activity/Common/CMovePlacePage"

--创建圣诞节天降宝箱页面类
super_class.CBoxDownPage(MovePlacePage)

--功能：定义圣诞节天降宝箱页面的基础属性
--参数：self	圣诞节天降宝箱页面对象
--返回：无
--作者：肖进超
--时间：2014.12.17
local function create_self_params(self)

end

--功能：创建圣诞节天降宝箱页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CBoxDownPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CBoxDownPage:destroy()
	--获取父类
	local t_pageParent = CBoxDownPage.super
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
--时间：2014.12.17
function CBoxDownPage:showPageAction()
	ChristmasModel:showCBoxDownPage(self._isInit)
end

--功能：前往按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CBoxDownPage:forwardButtonAction()
    ChristmasModel:forwardPlace()
end

--功能：传送按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CBoxDownPage:transformButtonAction()
    ChristmasModel:transformPlace()
end