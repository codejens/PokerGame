--CLDTreasurePage.lua
--内容：光棍节珍宝轩活动页面类
--作者：肖进超
--时间：2014.10.29

--加载光棍节光棍节珍宝轩页面基础类
require "UI/activity/Common/CGotoActivityPage"

--创建鲜花光棍节珍宝轩页面类
super_class.LDTreasurePage(GotoActivityPage)

--功能：定义鲜花光棍节珍宝轩页面的基础属性
--参数：self	页面对象
--返回：无
--作者：肖进超
--时间：2014.10.29
local function create_self_params(self)

end

--功能：创建鲜花光棍节珍宝轩页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDTreasurePage:__init()

end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDTreasurePage:destroy()
	--获取父类
	local t_pageParent = LDTreasurePage.super
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
function LDTreasurePage:showPageAction()
	LonelyDayModel:showLDTreasurePage(self._isInit)
end

--功能：查看活动按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDTreasurePage:gotoButtonAction()
	LonelyDayModel:openSpecialActivityWin(60)  --跳到  珍宝轩
end