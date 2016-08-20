--WorkDayWin.lua
--内容：劳动节

--加载基类文件
-- require "UI/activity/Common/CCommonActivityBaseWin"
require "UI/activity/Common/WorkDay/WorkTaobaoPage"
require "UI/activity/Common/WorkDay/WorkAddupLoginPage"
require "UI/activity/Common/WorkDay/WorkAddupRechargePage"
require "UI/activity/Common/WorkDay/WorkQuotaBuyPage"
require "UI/activity/Common/WorkDay/WorkBoxDownPage"
require "UI/activity/Common/WorkDay/WorkLuopanPage"
--定义情人节窗口类
super_class.WorkDayWin(CommonActivityBaseWin)

-- 如果要调转两个页面位置，需要修改：1.WorkDayWin的self._pageClassGroup表顺序。2.ValentineDayModel的页面序号。3.ValentineDayParam中参数顺序 by gzn

--功能：定义情人节窗口的属性
--参数：1、self		妇女节窗口对象
--返回：无
--作者：陈亮
--时间：2014.10.27
local function create_self_params(self)
	
end

--功能：创建情人节对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function WorkDayWin:__init()
	--声明成员变量
	create_self_params(self)
	--赋值子活动的页面类型组
	self._pageClassGroup = {
		[1] = WorkTaobaoPage,
		[2] = WorkAddupLoginPage,
		[3] = WorkAddupRechargePage,
		[4] = WorkQuotaBuyPage,
		[5] = WorkBoxDownPage,
		[6] = WorkLuopanPage,
	}
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function WorkDayWin:destroy()
	--获取父类
	local t_pageParent = WorkDayWin.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示窗口时候的行为
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function WorkDayWin:showWinAction()
	WorkDayModel:showWorkDayWin(self._isInit)
end