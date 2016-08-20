--CLonelyDayWin.lua
--内容：光棍节窗口类
--作者：陈亮
--时间：2014.10.27

--加载基类文件
require "UI/activity/Common/CCommonActivityBaseWin"
--加载页面文件
require "UI/activity/Common/LonelyDay/CCExchangePage"            --红旗兑换
require "UI/activity/Common/LonelyDay/CCTaobaoPage"              --淘宝树
require "UI/activity/Common/LonelyDay/CNDAddupRechargePage"      --累计充值
require "UI/activity/Common/LonelyDay/CLDailyQuotaBuyPage"              --每日限购
-- require "UI/activity/Common/CTotalLoginPage"              --累计登录
-- require "UI/activity/Common/LonelyDay/CLDFollowQueuePage"          --鲜花排行
-- require "UI/activity/Common/LonelyDay/CLDTreasurePage"                --珍宝轩
-- require "UI/activity/Common/LonelyDay/CLDRepeatConsumePage"        --重复消费
require "UI/activity/Common/LonelyDay/CLDGroupBuyPage"              --超级团购
require "UI/activity/Common/LonelyDay/CLDAddupLoginPage"           --累计登录
-- require "UI/activity/Common/LonelyDay/CCTaobaoPage"              --双倍经验
require "UI/activity/Common/LonelyDay/CLDDoubleExpPage"              --双倍经验
require "UI/activity/Common/LonelyDay/CLDBoxDownPage"           	--天降宝箱采集物掉落
require "UI/activity/Common/LonelyDay/CLDBossHitPage"              --Boss袭礼采集物掉落
--定义光棍节窗口类
super_class.LonelyDayWin(CommonActivityBaseWin)

--功能：定义光棍节窗口的属性
--参数：1、self		光棍节窗口对象
--返回：无
--作者：陈亮
--时间：2014.10.27
local function create_self_params(self)
	
end

--功能：创建光棍节对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function LonelyDayWin:__init()
	--声明成员变量
	create_self_params(self)
	--赋值子活动的页面类型组
	self._pageClassGroup = {
		[1] = CExchangePage,		--红包兑换
        [2] = CTaobaoPage,			--淘宝树
		[3] = NDAddupRechargePage,	--累积充值
		[4] = CLDailyQuotaBuyPage,	--每日限购
		[5] = LDAddupLoginPage,		--累积登陆
		[6] = LDGroupBuyPage,		--超级团购
		[7] = LDDoubleExpPage,		--双倍经验
		[8] = LDBoxDownPage,        --天将宝箱
		[9] = LDBossHitPage,        --boss袭击
	}
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function LonelyDayWin:destroy()
	--获取父类
	local t_pageParent = LonelyDayWin.super
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
function LonelyDayWin:showWinAction()
	LonelyDayModel:showLonelyDayWin(self._isInit)
end