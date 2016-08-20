--SummerDayModel.lua
--内容：清凉一夏活动的单体数据逻辑类
--作者：陈亮
--时间：2014.10.27

--加载光棍节活动的配置对象
require "config/activity/SummerDayConfig"

--加载通用活动数据逻辑类
require "model/activity/CBaseCommonModel"


--定义常量

-- local _FOLLOW_QUEUE_PARAM_INDEX 	= 1
local _DAILY_RECHARGE_PARAM_INEDEX	= 1
-- local _TREASURE_PARAM_INDEX         = 2
local  _APPUP_LOGIN_PARAM_INDEX		= 2
-- local _EVERY_CONSUME_PARAM_INDEX   = 3
local _GROUP_BUY_PARAM_INDEX 		= 3

local _TAOBAO_PARAM_INDEX 			= 4
local _ADDUP_CONSUME_PARAM_INDEX	= 5
--创建光棍节活动数据逻辑
SummerDayModel = BaseCommonModel(nil,SummerDayConfig)

--功能：显示每日充值-每日充值页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.25
function SummerDayModel:showDRDailyRechargePage(isInit)
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _DAILY_RECHARGE_PARAM_INEDEX

	--如果需要初始化
	if isInit then
		self:initGainAwardPage(t_win, CommonActivityConfig.SummerDay)  
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

    --请求累计消费页面信息
	self:requestDailyRechargeInfo()   
end

--功能：显示光棍节活动窗口
--参数：1、isInit	是否需要初始化
--返回：无
--作者：陈亮
--时间：2014.09.19
function SummerDayModel:showSummerDayWin(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_summerDayWin = UIManager:find_visible_window("summerDayWin")

	--如果需要初始化，进行对光棍节活动窗口进行初始化
	if isInit then
		self:initActivityWin(t_summerDayWin)
	end
end


--功能：显示圣诞节兑换页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function SummerDayModel:showCExchangePage(isInit)
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _EXCHANGE_PARAM_INEDEX

	--如果需要初始化，进行对兑换页面初始化
	if isInit then
		self:initExchangePage(t_win, CommonActivityConfig.SummerDay)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

	--请求兑换界面信息
	self:requestExchangeInfo()
end

--功能：刷新兑换界面的信息
--参数：1、cur_item_num	当前所需道具数量
--返回：无
--作者：肖进超
--作者：肖进超
--时间：2014.12.17
function SummerDayModel:refreshTGExchangeInfo(cur_item_num)
	local t_win = UIManager:find_visible_window("summerDayWin")
	--如果没有显示，不进行操作
	if (not t_win) then
		return
	end

	self:refreshExchangeStatusInfo(t_win, cur_item_num, CommonActivityConfig.SummerDay)
end

--功能：显示圣诞节淘宝树页面或淘宝树页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function SummerDayModel:showSMTaobaoPage(isInit)
    local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _TAOBAO_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initMovePlacePage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end


--功能：显示光棍节鲜花排行页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：陈亮
--时间：2014.10.27
function SummerDayModel:showLDFollowQueuePage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_summerDayWin = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _FOLLOW_QUEUE_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initQueuePage(t_summerDayWin)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_summerDayWin)
end

--功能：显示光棍节珍宝轩页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function SummerDayModel:showLDTreasurePage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _TREASURE_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGotoActivityPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示光棍节重复消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function SummerDayModel:showLDRepeatConsumePage(isInit)
	--获取国庆节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _REPEAT_CONSUME_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initRepeatGainPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

	--请求重复消费信息
	self:requestRepeatConsumeInfo()
end

--功能：显示光棍节超级团购页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function SummerDayModel:showSMGroupBuyPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _GROUP_BUY_PARAM_INDEX

	--如果需要初始化，进行对光棍节超级团购进行初始化
	if isInit then
		self:initGroupBuyPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示光棍节累计登陆页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.14
function SummerDayModel:showSMAddupLoginPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _APPUP_LOGIN_PARAM_INDEX

	--如果需要初始化，进行对光棍节累计登陆页面进行初始化
	if isInit then
		self:initGainAwardPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

	--请求累计登陆页面信息
	self:requestTotalLoginInfo()
end

--功能：显示光棍节BOSS页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.14
function SummerDayModel:showLDBossHitPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _BOSS_HIT_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGotoActivityPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示国庆节重复消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：陈亮
--时间：2014.09.19
function SummerDayModel:showSMAddupRechargePage(isInit)
	--获取国庆节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_oldNationalDayWin = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _ADDUP_RECHARGE_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGainAwardPage(t_oldNationalDayWin)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_oldNationalDayWin)

	--请求累计充值页面信息
	self:requestAddupRechargeInfo()
end

--功能：显示情人节超级团购页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function SummerDayModel:showLDGroupBuyPage(isInit)
	--获取情人节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _GROUP_BUY_PARAM_INDEX

	--如果需要初始化，进行对情人节超级团购进行初始化
	if isInit then
		self:initGroupBuyPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：刷新活动中通用页面的信息
--参数：1、activityInfo		通用页面信息
--返回：无
--作者：肖进超
--时间：2014.10.30
function SummerDayModel:flushPageInfo(activityInfo)
	--获取光棍节活动窗口
	local t_win = UIManager:find_visible_window("summerDayWin")
	--如果没有显示，不进行操作
	if (not t_win) then
		return
	end
print("-------model:flushPageInfo")
	self:flushCommonInfo(t_win, activityInfo)
end

--功能：结束数据逻辑
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.30
function SummerDayModel:finish()
	UIManager:destroy_window("summerDayWin")
end



--功能：界面跳转
--参数：无
--返回：无
--作者：chj
--时间：2014.08.30
function SummerDayModel:openGroupBuyActivityWin()
	SuperGroupBuyModel:set_ACTIVITY_ID( CommonActivityConfig.SummerDay )
	UIManager:show_window("super_tuangou_win")
end

--功能：显示累计消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：gzn
--时间：2015.3.24
function SummerDayModel:showAddupConsumePage(isInit)
	local t_win = UIManager:find_visible_window("summerDayWin")

	--设置为当前显示页
	self._currentParamIndex = _ADDUP_CONSUME_PARAM_INDEX

	--如果需要初始化
	if isInit then
		self:initGainAwardPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

    --请求累计消费页面信息
	self:requestAddupConsumeInfo()
end