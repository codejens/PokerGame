
--内容：元宵节窗口类
--作者：xiehande
--时间：2015.2.4
require "UI/activity/Common/SummerDay/SMDailyRechargePage"		--每日首冲

require "UI/activity/Common/SummerDay/SMAddupLoginPage"			--累计登陆
require "UI/activity/Common/SummerDay/SMGroupBuyPage"			--超级团购
require "UI/activity/Common/SummerDay/SMTaobaoPage"				--淘宝树
-- require "UI/activity/Common/SummerDay/SMAddupRechargePage"		--累计消费
require "UI/activity/Common/SummerDay/SMAddupConsumePage"		--累计消费

--定义情人节窗口类
super_class.SummerDayWin(CommonActivityBaseWin)

-- 如果要调转两个页面位置，需要修改：1.SummerDayWin的self._pageClassGroup表顺序。2.ValentineDayModel的页面序号。3.ValentineDayParam中参数顺序 by gzn

--功能：定义情人节窗口的属性
--参数：1、self		情人节窗口对象
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
function SummerDayWin:__init()
	--声明成员变量
	create_self_params(self)
	--赋值子活动的页面类型组
	self._pageClassGroup = {
		[1] = SMDailyRechargePage,		--每日首充
		[2] = SMAddupLoginPage,			--累计登陆
		[3] = SMGroupBuyPage,			--超级团购
		[4] = SMTaobaoPage,				--淘宝树
		[5] = SMAddupConsumePage,		--累计消费
	}
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function SummerDayWin:destroy()
	--获取父类
	local t_pageParent = SummerDayWin.super
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
function SummerDayWin:showWinAction()
	SummerDayModel:showSummerDayWin(self._isInit)
end