--CSMAddupConsumePage.lua
--内容：累计消费页面基础类
--作者：陈亮
--时间：2014.09.22

--加载获取奖励基础页面类
require "UI/activity/Common/CAddupConsumePage"

--创建每日消费页面基础类
super_class.SMAddupConsumePage(AddupConsumePage)

--功能：定义每日消费页面的基础属性
--参数：self	每日消费页面对象
--返回：无
--作者：陈亮
--时间：2014.09.22
local function create_self_params(self)

end

--功能：创建每日消费页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function SMAddupConsumePage:__init()
	--创建私有变量
	create_self_params(self)

	--赋值页面类型
	self._pageType = CommonActivityConfig.TypeAddupConsume
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function SMAddupConsumePage:destroy()
	--获取父类
	local t_pageParent = SMAddupConsumePage.super
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
--时间：2014.12.17
function SMAddupConsumePage:showPageAction()
	SummerDayModel:showAddupConsumePage(self._isInit)
end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function SMAddupConsumePage:gainAward(itemIndex)
	SummerDayModel:gainAddupConsumeAward(itemIndex)
end