--CCGroupBuyPage.lua
--内容：圣诞节超级团购活动页面类
--作者：肖进超
--时间：2014.12.17

--加载超级团购页面类
require "UI/activity/Common/CGroupBuyPage"

--创建圣诞节超级团购活动页面类
super_class.CGroupBuyPage(GroupBuyPage)

--功能：定义圣诞节超级团购活动页面的基础属性
--参数：self	超级团购活动页面对象
--返回：无
--作者：肖进超
--时间：2014.12.17
local function create_self_params(self)

end

--功能：创建圣诞节超级团购活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CGroupBuyPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CGroupBuyPage:destroy()
	--获取父类
	local t_pageParent = CGroupBuyPage.super
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
function CGroupBuyPage:showPageAction()
	ChristmasModel:showCGroupBuyPage(self._isInit)
end

--功能：前往按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CGroupBuyPage:goGroupBuy()
	ChristmasModel:openGroupBuyActivityWin()
end
