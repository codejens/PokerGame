--WorkDayModel.lua
--内容：清凉一夏活动的单体数据逻辑类
--作者：陈亮
--时间：2014.10.27

--加载光棍节活动的配置对象
require "config/activity/WorkDayConfig"

--加载通用活动数据逻辑类
require "model/activity/CBaseCommonModel"


--定义常量

local _TAOBAO_PARAM_INDEX			= 1
local  _APPUP_LOGIN_PARAM_INDEX		= 2
local _ADDUP_RECHARGE_PARAM_INDEX	= 3

local _VALENTINE_DAY_PARAM_INDEX	= 4
local _BOX_DOWN_PARAM_INDEX	= 5
local _LUOPAN_PARAM_INDEX			= 6
--创建光棍节活动数据逻辑
WorkDayModel = BaseCommonModel(nil,WorkDayConfig)


--功能：显示光棍节活动窗口
--参数：1、isInit	是否需要初始化
--返回：无
--作者：陈亮
--时间：2014.09.19
function WorkDayModel:showWorkDayWin(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_workDayWin = UIManager:find_visible_window("workDayWin")

	--如果需要初始化，进行对光棍节活动窗口进行初始化
	if isInit then
		self:initActivityWin(t_workDayWin)
	end
end


--功能：显示圣诞节兑换页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function WorkDayModel:showCExchangePage(isInit)
	local t_win = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _EXCHANGE_PARAM_INEDEX

	--如果需要初始化，进行对兑换页面初始化
	if isInit then
		self:initExchangePage(t_win, CommonActivityConfig.WorkDay)
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
function WorkDayModel:refreshTGExchangeInfo(cur_item_num)
	local t_win = UIManager:find_visible_window("workDayWin")
	--如果没有显示，不进行操作
	if (not t_win) then
		return
	end

	self:refreshExchangeStatusInfo(t_win, cur_item_num, CommonActivityConfig.WorkDay)
end

--功能：显示圣诞节淘宝树页面或淘宝树页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function WorkDayModel:showSMTaobaoPage(isInit)
    local t_win = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _TAOBAO_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initMovePlacePage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示光棍节累计登陆页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.14
function WorkDayModel:showSMAddupLoginPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("workDayWin")

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

--功能：显示国庆节重复消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：陈亮
--时间：2014.09.19
function WorkDayModel:showSMAddupRechargePage(isInit)
	--获取国庆节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_workDayWin = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _ADDUP_RECHARGE_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGainAwardPage(t_workDayWin)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_workDayWin)

	--请求累计充值页面信息
	self:requestAddupRechargeInfo()
end

--功能：刷新活动中通用页面的信息
--参数：1、activityInfo		通用页面信息
--返回：无
--作者：肖进超
--时间：2014.10.30
function WorkDayModel:flushPageInfo(activityInfo)
	--获取光棍节活动窗口
	local t_win = UIManager:find_visible_window("workDayWin")
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
function WorkDayModel:finish()
	UIManager:destroy_window("workDayWin")
end



--功能：界面跳转
--参数：无
--返回：无
--作者：chj
--时间：2014.08.30
function WorkDayModel:openGroupBuyActivityWin()
	SuperGroupBuyModel:set_ACTIVITY_ID( CommonActivityConfig.WorkDay )
	UIManager:show_window("super_tuangou_win")
end

--功能：显示累计消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：gzn
--时间：2015.3.24
function WorkDayModel:showAddupConsumePage(isInit)
	local t_win = UIManager:find_visible_window("workDayWin")

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


--功能：显示圣诞节淘宝树页面或淘宝树页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function WorkDayModel:showCTaobaoPage(isInit)
    local t_win = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _TAOBAO_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initMovePlacePage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示每日限购页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：谢汉德
--时间：2014.10.14
function WorkDayModel:showCLDailyQuotaGuyPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _VALENTINE_DAY_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGotoActivityPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示光棍节宝天降箱页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.14
function WorkDayModel:showLDBoxDownPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _BOX_DOWN_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initMovePlacePage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示情人节幸运转盘页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：郭志楠
--时间：2015.2.6
function WorkDayModel:showVLuoPanPage(isInit)
	--获取情人节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("workDayWin")

	--设置为当前显示页
	self._currentParamIndex = _LUOPAN_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGotoActivityPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end
