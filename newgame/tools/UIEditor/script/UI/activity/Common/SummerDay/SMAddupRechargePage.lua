--CSMAddupRechargePage.lua
--内容：老服国庆节累计充值页面类
--作者：陈亮
--时间：2014.09.22

--加载累计充值基础页面类
require "UI/activity/Common/CAddupRechargePage"

--创建老服国庆节累计充值页面类
super_class.SMAddupRechargePage(AddupRechargePage)

--功能：定义老服国庆节累计充值页面的基础属性
--参数：self	老服国庆节累计充值页面对象
--返回：无
--作者：陈亮
--时间：2014.09.22
local function create_self_params(self)

end

--功能：创建老服国庆节累计充值页面的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function SMAddupRechargePage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function SMAddupRechargePage:destroy()
	--获取父类
	local t_pageParent = SMAddupRechargePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示页面的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function SMAddupRechargePage:showPageAction()
	SummerDayModel:showSMAddupRechargePage(self._isInit)
end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function SMAddupRechargePage:gainAward(itemIndex)
	SummerDayModel:gainAddupRechargeAward(itemIndex)
end