--CLDRepeatConsumePage.lua
--内容：光棍节重复消费活动页面基础类
--作者：陈亮
--时间：2014.09.23

--加载重复消费活动页面基础类
require "UI/activity/Common/CRepeatConsumePage"

--创建光棍节重复消费活动页面基础类
super_class.LDRepeatConsumePage(RepeatConsumePage)

--功能：定义光棍节重复消费活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.09.23
local function create_self_params(self)

end

--功能：创建光棍节重复消费活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function LDRepeatConsumePage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function LDRepeatConsumePage:destroy()
	--获取父类
	local t_pageParent = LDRepeatConsumePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：显示页面的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function LDRepeatConsumePage:showPageAction()
	LonelyDayModel:showLDRepeatConsumePage(self._isInit)
end

--功能：获取全部奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function LDRepeatConsumePage:gainAllAward()
	LonelyDayModel:gainAllRepeatConsumeAward()
end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function LDRepeatConsumePage:gainAward()
	LonelyDayModel:gainRepeatConsumeAward()
end