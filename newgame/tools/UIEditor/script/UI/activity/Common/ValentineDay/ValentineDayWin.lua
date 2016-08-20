--CValentineDayWin.lua
--内容：情人节窗口类
--作者：xiehande
--时间：2015.2.4

--加载基类文件
-- require "UI/activity/Common/CCommonActivityBaseWin"
-- --加载页面文件
-- require "UI/activity/Common/LonelyDay/CCExchangePage"            --红旗兑换
-- require "UI/activity/Common/LonelyDay/CCTaobaoPage"              --淘宝树
-- -- require "UI/activity/Common/LonelyDay/CLDFollowQueuePage"          --鲜花排行
-- -- require "UI/activity/Common/LonelyDay/CLDTreasurePage"                --珍宝轩
-- -- require "UI/activity/Common/LonelyDay/CLDRepeatConsumePage"        --重复消费
-- require "UI/activity/Common/LonelyDay/CLDGroupBuyPage"              --超级团购
-- -- require "UI/activity/Common/LonelyDay/CLDAddupLoginPage"           --累计登录
-- -- require "UI/activity/Common/LonelyDay/CCTaobaoPage"              --双倍经验
-- require "UI/activity/Common/LonelyDay/CLDBoxDownPage"           --天降宝箱采集物掉落
require "UI/activity/Common/ValentineDay/DailyQuotaBuyPage"              --每日限购
require "UI/activity/Common/ValentineDay/SendFollowQueuePage"
require "UI/activity/Common/ValentineDay/ReceiveFollowQueuePage"
require "UI/activity/Common/ValentineDay/VLuopanPage"
require "UI/activity/Common/ValentineDay/CVEveryConsumePage"              --每日限购
--定义情人节窗口类
super_class.ValentineDayWin(CommonActivityBaseWin)

-- 如果要调转两个页面位置，需要修改：1.ValentineDayWin的self._pageClassGroup表顺序。2.ValentineDayModel的页面序号。3.ValentineDayParam中参数顺序 by gzn

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
function ValentineDayWin:__init()
	--声明成员变量
	create_self_params(self)
	--赋值子活动的页面类型组
	self._pageClassGroup = {
		[1] = SendFollowQueuePage,
		[2] = ReceiveFollowQueuePage,
		[3] = VLuopanPage,
		[4] = DailyQuotaBuyPage,
		[5] = VEveryConsumePage,
        -- [2] = CTaobaoPage,
		-- [3] = LDBoxDownPage,
		-- [4] = CLDailyQuotaBuyPage,
		-- [5] = LDBoxDownPage,
		-- [6] = LDBoxDownPage,
		-- [7] = LDBoxDownPage,
		-- [8] = LDBoxDownPage,
		-- [9] = LDBoxDownPage,
	}
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function ValentineDayWin:destroy()
	--获取父类
	local t_pageParent = ValentineDayWin.super
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
function ValentineDayWin:showWinAction()
	ValentineDayModel:showvalentineDayWin(self._isInit)
end