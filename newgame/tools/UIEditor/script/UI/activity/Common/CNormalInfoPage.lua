--CNormalInfoPage.lua
--内容：常用信息活动页面基础类
--作者：陈亮
--时间：2014.08.28

--加载通用信息活动页面基础类
require "UI/activity/Common/CCommonBasePage"

--加载布局文件
require "../data/layouts/Activity/Common/NormalInfoPageLayout"

--定义常量
local _TIME_OUT_CONTENT = "活动已截止"

--创建常用信息活动页面基础类
super_class.NormalInfoPage(CommonBasePage)

--功能：定义常用信息活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function create_self_params(self)
	self._timeLabel = nil
	self._desLabel = nil
	self._remainTimeLabel = nil
end

--功能：剩余时间倒计时结束回调函数
--参数：1、self		常用信息活动对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function count_down_end_callback(self)
	self._remainTimeLabel:setString(_TIME_OUT_CONTENT)
end

--功能：创建常用信息活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function NormalInfoPage:__init()
	--创建私有变量
	create_self_params(self)

	--创建活动时间
	local t_timeTitleLayout = NormalInfoPageLayout.timeTitle
	ZLabel:create(self._pageView,LangGameString[1629], t_timeTitleLayout.x, t_timeTitleLayout.y, t_timeTitleLayout.fontSize)
	local t_timeLayout = NormalInfoPageLayout.time
	self._timeLabel = ZLabel:create(self._pageView,"", t_timeLayout.x, t_timeLayout.y, t_timeLayout.fontSize)

	--创建活动说明
	local t_desTitleLayout = NormalInfoPageLayout.desTitle
	ZLabel:create(self._pageView,LangGameString[1630], t_desTitleLayout.x, t_desTitleLayout.y, t_desTitleLayout.fontSize)
	local t_describeLayout = NormalInfoPageLayout.describe
	self._desLabel = ZDialog:create(self._pageView,"",t_describeLayout.x, t_describeLayout.y, t_describeLayout.width, t_describeLayout.height, t_describeLayout.fontSize, t_describeLayout.max)
	self._desLabel.view:setAnchorPoint(0,1)

	--创建活动剩余时间
	local t_remainTimeTitleLayout = NormalInfoPageLayout.remainTimeTitle
	ZLabel:create(self._pageView,LangGameString[1631], t_remainTimeTitleLayout.x, t_remainTimeTitleLayout.y, t_remainTimeTitleLayout.fontSize)
	local t_remainTimeLayout = NormalInfoPageLayout.remainTime
	self._remainTimeLabel = TimerLabel:create_label(self._pageView,t_remainTimeLayout.x,t_remainTimeLayout.y,t_remainTimeLayout.fontSize,0, "", bind(count_down_end_callback,self), false, ALIGN_LEFT,false)

	self._pageTitleBg = CCBasePanel:panelWithFile( 0, 240, 603, 35, UILH_NORMAL.title_bg5 );
	self._pageView:addChild(self._pageTitleBg)
	self._pageTitle = ZLabel:create( self._pageTitleBg, "", 300, 10, 16, ALIGN_CENTER )
	self._pageTitleBg:setIsVisible(false)
end

--功能：设置活动时间
--参数：1、time		活动时间
--返回：无
--作者：陈亮
--时间：2014.08.28
function NormalInfoPage:setActivityTime(time)
	self._timeLabel:setText(time)
end

--功能：剩余活动时间已结束
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function NormalInfoPage:remainTimeOut()
	self._remainTimeLabel:setString(_TIME_OUT_CONTENT)
end

--功能：设置活动说明
--参数：1、describe		活动说明
--返回：无
--作者：陈亮
--时间：2014.08.28
function NormalInfoPage:setActivityDescribe(describe)
	self._desLabel:setText(describe)
end

--功能：设置活动剩余时间
--参数：1、remainTime	活动剩余时间
--返回：无
--作者：陈亮
--时间：2014.08.28
function NormalInfoPage:setRemainTime(remainTime)
	self._remainTimeLabel:setText(remainTime)
end

--功能：设置page_title
--参数：1、remainTime	活动剩余时间
--返回：无
--作者：chj
--时间：2014.08.28
function NormalInfoPage:setTitlePageEx( title_page )
	if title_page then
		self._pageTitleBg:setIsVisible(true)
		self._pageTitle:setText(title_page)
	end
end


--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function NormalInfoPage:destroy()
	--销毁时间控件
	self._remainTimeLabel:destroy()

	--获取父类
	local t_pageParent = NormalInfoPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end