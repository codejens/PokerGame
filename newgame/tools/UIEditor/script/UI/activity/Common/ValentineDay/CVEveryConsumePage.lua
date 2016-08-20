--CCAddupConsumePage.lua
--内容：圣诞节累计消费活动页面基础类
--作者：肖进超
--时间：2014.12.17

--加载累计消费活动页面基础类
require "UI/activity/Common/CEveryConsumePage"

--创建圣诞节累计消费活动页面基础类
super_class.VEveryConsumePage(EveryConsumePage)

--功能：定义圣诞节累计消费活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：肖进超
--时间：2014.12.17
local function create_self_params(self)

end

--功能：创建圣诞节累计消费活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function VEveryConsumePage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function VEveryConsumePage:destroy()
	--获取父类
	local t_pageParent = VEveryConsumePage.super
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
function VEveryConsumePage:showPageAction()
	ValentineDayModel:showCEveryConsumePage(self._isInit)
end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.17
function VEveryConsumePage:gainAward(itemIndex)
	ValentineDayModel:gainEveryConsumeAward(itemIndex)
end
