--CRepeatRechargePage.lua
--内容：重复充值活动页面基础类
--作者：陈亮
--时间：2014.08.29

--加载重复获取活动页面基础类
require "UI/activity/Common/CRepeatGainPage"

--创建重复充值活动页面基础类
super_class.RepeatRechargePage(RepeatGainPage)

--功能：定义重复消费活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.29
local function create_self_params(self)

end

--功能：创建重复充值活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatRechargePage:__init()
	--创建私有变量
	create_self_params(self)

	--赋值页面类型
	self._pageType = CommonActivityConfig.TypeRepeatRecharge
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatRechargePage:destroy()
	--获取父类
	local t_pageParent = RepeatRechargePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end
