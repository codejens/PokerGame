
--内容：元宵节窗口类
--作者：xiehande
--时间：2015.2.4
require "UI/activity/Common/LanternDay/YXBoxDownPage"            --天降宝箱

require "UI/activity/Common/LanternDay/YXEveryConsumePage"      --每日消费
require "UI/activity/Common/LanternDay/YXExchangePage"              --元宵兑换
require "UI/activity/Common/LanternDay/YXGroupBuyPage"           --超级团购

--定义情人节窗口类
super_class.LanternDayWin(CommonActivityBaseWin)

-- 如果要调转两个页面位置，需要修改：1.LanternDayWin的self._pageClassGroup表顺序。2.ValentineDayModel的页面序号。3.ValentineDayParam中参数顺序 by gzn

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
function LanternDayWin:__init()
	--声明成员变量
	create_self_params(self)
	--赋值子活动的页面类型组
	self._pageClassGroup = {
		[1] = YXExchangePage,		--元宵兑换
		[2] = YXBoxDownPage,		--天降宝箱
		[3] = YXEveryConsumePage,	--每日消费
		[4] = YXGroupBuyPage,        --超级团购
	}
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function LanternDayWin:destroy()
	--获取父类
	local t_pageParent = LanternDayWin.super
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
function LanternDayWin:showWinAction()
	LanternDayModel:showlanternDayWin(self._isInit)
end