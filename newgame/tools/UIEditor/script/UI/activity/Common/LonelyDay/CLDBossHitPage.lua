--CLDBossHitPage.lua
--内容：光棍节-Boss袭礼活动页面类
--作者：肖进超
--时间：2014.10.29

--加载跳转活动页面类
require "UI/activity/Common/CMovePlacePage"

--创建光棍节-Boss袭礼页面类
super_class.LDBossHitPage(MovePlacePage)

--功能：定义光棍节-Boss袭礼活动页面的基础属性
--参数：self	光棍节-Boss袭礼活动页面对象
--返回：无
--作者：肖进超
--时间：2014.10.29
local function create_self_params(self)

end

--功能：创建光棍节-Boss袭礼活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDBossHitPage:__init()
	--创建私有变量
	create_self_params(self)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDBossHitPage:destroy()
	--获取父类
	local t_pageParent = LDBossHitPage.super
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
function LDBossHitPage:showPageAction()
	LonelyDayModel:showLDBossHitPage(self._isInit)
end

--功能：前往按钮执行的行为动作
--参数：无
--返回：无
--作者：谢汉德
--时间：2014.12.17
function LDBossHitPage:forwardButtonAction()
    LonelyDayModel:forwardPlace()
end

--功能：传送按钮执行的行为动作
--参数：无
--返回：无
--作者：谢汉德
--时间：2014.12.17
function LDBossHitPage:transformButtonAction()
    LonelyDayModel:transformPlace()
end