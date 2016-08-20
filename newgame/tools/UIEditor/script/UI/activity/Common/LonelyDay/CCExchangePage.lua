--CCExchangePage.lua
--内容：春节节兑换活动页面类
--作者：肖进超
--时间：2014.12.17

--加载兑换页面类
require "UI/activity/Common/CExchangePage"

--创建圣诞节兑换活动页面类
super_class.CExchangePage(ExchangePage)

--功能：定义圣诞节兑换活动页面的基础属性
--参数：self	圣诞节兑换活动页面对象
--返回：无
--作者：肖进超
--时间：2014.12.17
local function create_self_params(self)

end

--功能：创建圣诞节兑换活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CExchangePage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CExchangePage:destroy()
	--获取父类
	local t_pageParent = CExchangePage.super
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
function CExchangePage:showPageAction()
	LonelyDayModel:showCExchangePage(self._isInit)
end

--功能：兑换奖励的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function CExchangePage:exchangeAward(itemIndex)
	LonelyDayModel:exchangeAward(itemIndex)
end