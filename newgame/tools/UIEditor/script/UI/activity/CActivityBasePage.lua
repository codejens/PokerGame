--CActivityBasePage.lua
--内容：活动页面基础类
--作者：陈亮
--时间：2014.08.28

--创建活动页面基础类
super_class.ActivityBasePage()

--功能：定义页的基础属性
--参数：self	充值有礼页对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function create_self_params(self)
	self._positionX = 10					--页面默认X轴坐标
	self._positionY = 10					--页面默认Y轴坐标
	self._width = 740						--页面默认宽度
	self._height = 333						--页面默认高度

	self._pageView = nil					--页面视图
	self._isInit = true						--对象初始化标识，true为需要初始化
end

--功能：创建页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:__init()
	--创建私有变量
	create_self_params(self)

	--创建页面视图
	local t_pageView = CCBasePanel:panelWithFile(self._positionX,self._positionY,self._width,self._height,"",500,500)
	self._pageView = t_pageView
end

--功能：获取页面视图
--参数：无
--返回：self._pageView 	页面视图
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:getPageView()
	return self._pageView
end

--功能：隐藏页面视图
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:hidePage()
	self._pageView:setIsVisible(false)
	--执行页面隐藏的动作
	self:hidePageAction()
end

--功能：显示页面视图
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:showPage()
	self._pageView:setIsVisible(true)
	--执行页面显示的动作
	self:showPageAction()
end

--功能：设置页面图片
--参数：1、pageViewImagePath	页面图片路径
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:setPageViewImage(pageViewImagePath)
	self._pageView:setTexture(pageViewImagePath)
end

--功能：设置页面宽高
--参数：1、width	页宽
--		2、height	页高
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:setPageSize(width,height)
	self._pageView:setSize(width,height)

	self._width = width
	self._height = height	
end

--功能：设置页面坐标
--参数：1、positionX	X轴
--		2、positionY	Y轴
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:setPagePosition(positionX,positionY)
	self._pageView:setPosition(positionX,positionY)
	--保存坐标
	self._positionX = positionX
	self._positionY = positionY
end

--功能：初始化完成，设置初始化标识为false，不需要继续初始化
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:initFinished()
	self._isInit = false
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:destroy()

end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：显示页面的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:showPageAction()

end

--功能：隐藏页面的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function ActivityBasePage:hidePageAction()

end