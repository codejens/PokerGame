--CCountDownWin.lua
--内容：拥有活动倒计时的活动窗口类
--作者：陈亮
--时间：2014.09.03

--加载活动基础窗口类
require "UI/activity/CActivityBaseWin"

--定义常量
local _TIME_OUT_CONTENT = "活动已截止"
local _REMIAN_TIME_FONTSIZE = 15
local _REMAIN_TIME_Z = 50

--定义拥有活动倒计时的活动窗口类
super_class.CountDownWin(ActivityBaseWin)

--功能：定义目标奖励窗口的属性
--参数：1、self		目标奖励窗口对象
--返回：无
--作者：陈亮
--时间：2014.09.03
local function create_self_params(self)
	self._remainTimeLabel = nil			--倒计时控件
end

--功能：剩余时间倒计时结束回调函数
--参数：1、self		窗口对象
--返回：无
--作者：陈亮
--时间：2014.09.02
local function count_down_end_callback(self)
	self._remainTimeLabel:setString(_TIME_OUT_CONTENT)
end

--功能：创建拥有活动倒计时的活动窗口对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function CountDownWin:__init()
	--声明成员变量create_self_params(self)
	--创建活动剩余时间
	
	self._remainTimeLabel = TimerLabel:create_label(self.view,0,0,_REMIAN_TIME_FONTSIZE,0, "", bind(count_down_end_callback,self), false, ALIGN_LEFT,false)
	self.view:reorderChild(self._remainTimeLabel.panel.view,_REMAIN_TIME_Z)
end

--功能：剩余活动时间已结束
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function CountDownWin:remainTimeOut()
	self._remainTimeLabel:setString(_TIME_OUT_CONTENT)
end

--功能：设置活动剩余时间
--参数：1、remainTime	活动剩余时间
--返回：无
--作者：陈亮
--时间：2014.09.03
function CountDownWin:setRemainTime(remainTime)
	self._remainTimeLabel:setText(remainTime)
end

--功能：设置倒计时坐标
--参数：1、positionX	X轴
--		2、positionY	Y轴
--返回：无
--作者：陈亮
--时间：2014.09.03
function CountDownWin:setRemainPosition(positionX,positionY)
	self._remainTimeLabel.panel.view:setPosition(positionX,positionY)
end

--功能：拥有活动倒计时的活动窗口对象的析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function CountDownWin:destroy()
	--销毁时间控件
	self._remainTimeLabel:destroy()

	--获取父类
	local t_pageParent = CountDownWin.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end
