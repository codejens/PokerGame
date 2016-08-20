--CAddupRechargePage.lua
--内容：累计充值页面基础类
--作者：陈亮
--时间：2014.09.22

--加载获取奖励基础页面类
require "UI/activity/Common/CGainAwardPage"

--创建累计充值页面基础类
super_class.AddupRechargePage(GainAwardPage)

--功能：定义累计充值页面的基础属性
--参数：self	累计充值页面对象
--返回：无
--作者：陈亮
--时间：2014.09.22
local function create_self_params(self)

end

--功能：创建累计充值页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function AddupRechargePage:__init()
	--创建私有变量
	create_self_params(self)

	--赋值页面类型
	self._pageType = CommonActivityConfig.TypeAddupRecharge
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function AddupRechargePage:destroy()
	--获取父类
	local t_pageParent = AddupRechargePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end
