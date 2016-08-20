--CLDFollowQueuePage.lua
--内容：鲜花排行榜活动页面类
--作者：陈亮
--时间：2014.10.27

--加载排行榜活动页面基础类
require "UI/activity/Common/CQueuePage"

--创建鲜花排行榜活动页面类
super_class.LDFollowQueuePage(QueuePage)

--功能：定义鲜花排行榜活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.10.27
local function create_self_params(self)

end

--功能：创建鲜花排行榜活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function LDFollowQueuePage:__init()

end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function LDFollowQueuePage:destroy()
	--获取父类
	local t_pageParent = LDFollowQueuePage.super
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
--时间：2014.10.27
function LDFollowQueuePage:showPageAction()
	LonelyDayModel:showLDFollowQueuePage(self._isInit)
end

--功能：查看排行榜的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function LDFollowQueuePage:gotoQueue()
	LonelyDayModel:gotoFollowQueueWin()
end