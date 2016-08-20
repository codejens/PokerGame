--CSMDailyRechargePage.lua
--内容：每日充值-每日充值活动页面基础类
--作者：肖进超
--时间：2014.12.25

--加载每日充值活动页面基础类
require "UI/activity/Common/CDailyRechargePage"

--创建每日充值-每日充值活动页面基础类
super_class.SMDailyRechargePage(DailyRechargePage)

--功能：定义每日充值每日充值活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：肖进超
--时间：2014.12.25
local function create_self_params(self)

end

--功能：创建每日充值-每日充值活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.25
function SMDailyRechargePage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.25
function SMDailyRechargePage:destroy()
	--获取父类
	local t_pageParent = SMDailyRechargePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：显示页面的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.25
function SMDailyRechargePage:showPageAction()
	SummerDayModel:showDRDailyRechargePage(self._isInit)
end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.25
function SMDailyRechargePage:gainAward(itemIndex)
	SummerDayModel:gainDailyRechargeAward(itemIndex)
end
