--CSMAddupLoginPage.lua
--内容：光棍节累计登录页面类
--作者：肖进超
--时间：2014.10.29

--加载累计登陆基础页面类
require "UI/activity/Common/CTotalLoginPage"

--创建光棍节累计登录页面类
super_class.SMAddupLoginPage(TotalLoginPage)

--功能：定义光棍节累计登录页面的基础属性
--参数：self	光棍节累计登录页面对象
--返回：无
--作者：肖进超
--时间：2014.10.29
local function create_self_params(self)

end

--功能：创建光棍节累计登录页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function SMAddupLoginPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function SMAddupLoginPage:destroy()
	--获取父类
	local t_pageParent = SMAddupLoginPage.super
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
--时间：2014.10.29
function SMAddupLoginPage:showPageAction()
	SummerDayModel:showSMAddupLoginPage(self._isInit)
end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function SMAddupLoginPage:gainAward(itemIndex)
	SummerDayModel:gainTotalLoginAward(itemIndex)
end