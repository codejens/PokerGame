--CVersionCelebrationWin.lua
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

require "UI/activity/Common/VersionCelebration/VCFixWallPage"           --修复城墙
require "UI/activity/Common/VersionCelebration/VCGroupBuyPage"           --修复城墙
require "UI/activity/Common/VersionCelebration/VCMagicTreePage"           --修复城墙
require "UI/activity/Common/VersionCelebration/VCAddupLoginPage"           --修复城墙
require "UI/activity/Common/VersionCelebration/VCTeHuiPage"           --修复城墙
require "UI/activity/Common/VersionCelebration/VCBoxDownPage"           --修复城墙

--定义情人节窗口类
super_class.VersionCelebrationWin(CommonActivityBaseWin)

-- 1.如果要调转两个页面位置，需要修改：1.VersionCelebrationWin的self._pageClassGroup表顺序。2.ValentineDayModel的页面序号。3.ValentineDayParam中参数顺序 by gzn
-- 2.打开活动窗口，不能仅用show_window，而是包括三步：
-- require "config/activity/CommonActivityConfig"  
-- QingmingDayModel:refreshActivityId(CommonActivityConfig.QingmingDay)
-- UIManager:show_window("QingmingDay_win");
-- 3.数据层面上如果想要流通，需要在BigActivityModel:set_activity_data添加活动model

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
function VersionCelebrationWin:__init()
	--声明成员变量
	create_self_params(self)
	--赋值子活动的页面类型组
	self._pageClassGroup = {
		[1] = VCFixWallPage,		--修复城墙
		[2] = VCGroupBuyPage,
		[3] = VCMagicTreePage,
		[4] = VCTeHuiPage,
		[5] = VCAddupLoginPage,
		[6] = VCBoxDownPage,

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
function VersionCelebrationWin:destroy()
	--获取父类
	local t_pageParent = VersionCelebrationWin.super
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
function VersionCelebrationWin:showWinAction()
	VersionCelebrationModel:showVersionCelebrationWin(self._isInit)
end