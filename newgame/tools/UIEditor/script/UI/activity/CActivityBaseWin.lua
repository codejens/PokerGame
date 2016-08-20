--CActivityBaseWin.lua
--内容：活动窗口基础类,除了通用活动，其他活动都要继承次类窗口，定义了初始化的字段
--作者：陈亮
--时间：2014.09.03

--定义活动窗口基础类
super_class.ActivityBaseWin(NormalStyleWindow)

--功能：定义活动窗口的属性
--参数：1、self		活动窗口对象
--返回：无
--作者：陈亮
--时间：2014.09.03
local function create_self_params(self)
	self._isInit = true					--是否需要初始化，true为要；false为不要
end

--功能：创建活动窗口对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function ActivityBaseWin:__init( window_name, texture, grid, width,  height,title_text)
	--声明成员变量
	create_self_params(self)
end

--功能：初始化完成，设置初始化标识为false，不需要继续初始化
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function ActivityBaseWin:initFinished()
	self._isInit = false
end

--功能：活动窗口对象的析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function ActivityBaseWin:destroy()
	--销毁父类
	Window.destroy(self)
end

--功能：窗口是否显示
--参数：1、status	窗口状态
--返回：无
--作者：陈亮
--时间：2014.09.03
function ActivityBaseWin:active(status)
	--如果显示窗口，进行显示的相关操作
	if status then
		self:showWinAction()
	--如果隐藏窗口，进行隐藏的相关操作
	else
		self:hideWinAction()
	end
end

----------------------------------------------------------------------
--以下函数子类可以进行重写
----------------------------------------------------------------------
--功能：显示窗口时候的行为
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function ActivityBaseWin:showWinAction()

end

--功能：关闭窗口时候的行为
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.03
function ActivityBaseWin:hideWinAction()

end