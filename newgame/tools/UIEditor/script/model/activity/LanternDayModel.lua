--LanternDayModel.lua
--内容：元宵节活动的单体数据逻辑类
--作者：陈亮
--时间：2014.10.27

--加载元宵节活动的配置对象
require "config/activity/LanternConfig"

--加载通用活动数据逻辑类
require "model/activity/CBaseCommonModel"

--定义常量
local _EXCHANGE_PARAM_INEDEX = 1
local _BOX_DOWN_PARAM_INDEX = 2
local _EVERY_CONSUME_PARAM_INDEX = 3
local _GROUP_BUY_PARAM_INDEX = 4

--创建元宵节活动数据逻辑
LanternDayModel = BaseCommonModel(nil,LanternConfig)

--功能：显示元宵节活动窗口
--参数：1、isInit	是否需要初始化
--返回：无
--作者：陈亮
--时间：2014.09.19
function LanternDayModel:showlanternDayWin(isInit)
	--获取元宵节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_lanternDayWin = UIManager:find_visible_window("lanternDayWin")
	--如果需要初始化，进行对元宵节活动窗口进行初始化
	if isInit then
		self:initActivityWin(t_lanternDayWin)
	end
end

--功能：显示元宵节幸运转盘页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：郭志楠
--时间：2015.2.6
function LanternDayModel:showVLuoPanPage(isInit)
	--获取元宵节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("lanternDayWin")

	--设置为当前显示页
	self._currentParamIndex = _LUOPAN_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGotoActivityPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示圣诞节兑换页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function LanternDayModel:showCExchangePage(isInit)
	local t_win = UIManager:find_visible_window("lanternDayWin")
    
	--设置为当前显示页
	self._currentParamIndex = _EXCHANGE_PARAM_INEDEX

	--如果需要初始化，进行对兑换页面初始化
	if isInit then
		self:initExchangePage(t_win, CommonActivityConfig.LanternDay)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

	--请求兑换界面信息
	self:requestExchangeInfo()
end


--功能：显示圣诞节淘宝树页面或淘宝树页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function LanternDayModel:showCTaobaoPage(isInit)
    local t_win = UIManager:find_visible_window("lanternDayWin")

	--设置为当前显示页
	self._currentParamIndex = _TAOBAO_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initMovePlacePage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end


--功能：显示元宵节重复消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function LanternDayModel:showLDRepeatConsumePage(isInit)
	--获取国庆节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("lanternDayWin")

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

--功能：显示元宵节超级团购页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function LanternDayModel:showYXGroupBuyPage(isInit)
	--获取元宵节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("lanternDayWin")

	--设置为当前显示页
	self._currentParamIndex = _GROUP_BUY_PARAM_INDEX

	--如果需要初始化，进行对元宵节超级团购进行初始化
	if isInit then
		self:initGroupBuyPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end



--功能：显示每日限购页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：谢汉德
--时间：2014.10.14
function LanternDayModel:showDailyQuotaGuyPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("lanternDayWin")

	--设置为当前显示页
	self._currentParamIndex = _VALENTINE_DAY_PARAM_INDEX

	--如果需要初始化，进行对副本页面进行初始化
	if isInit then
		self:initGotoActivityPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示光棍节超级团购页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.29
function LonelyDayModel:showLDGroupBuyPage(isInit)
	--获取光棍节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("lonelyDayWin")

	--设置为当前显示页
	self._currentParamIndex = _GROUP_BUY_PARAM_INDEX

	--如果需要初始化，进行对光棍节超级团购进行初始化
	if isInit then
		self:initGroupBuyPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：显示元宵节宝天降箱页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.10.14
function LanternDayModel:showYXBoxDownPage(isInit)
	--获取元宵节活动窗口，因为是显示窗口才调这个函数，所以不用判断
	local t_win = UIManager:find_visible_window("lanternDayWin")

	--设置为当前显示页
	self._currentParamIndex = _BOX_DOWN_PARAM_INDEX

	--如果需要初始化，进行对宝箱页面进行初始化
	if isInit then
		self:initMovePlacePage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)
end

--功能：刷新某个页面的信息
--参数：1、page_type	当前页面类型
function LanternDayModel:refreshPageInfo(page_type)
	local t_win = UIManager:find_visible_window("lanternDayWin")
	--如果没有显示，不进行操作
	if (not t_win) then
		return
	end

	local t_pageType = t_win:getCurrentPageType()
	if t_pageType == page_type then
		if t_pageType == CommonActivityConfig.TypeSendFlowerQueue then
			t_win._currentPage:refreshData();
		elseif t_pageType == CommonActivityConfig.TypeReceiveFlowerQueue then
			t_win._currentPage:refreshData();
		end
	end
end

--功能：显示每日消费页面
--参数：1、isInit	是否需要初始化
--返回：无
--作者：肖进超
--时间：2014.12.17
function LanternDayModel:showCEveryConsumePage(isInit)
	local t_win = UIManager:find_visible_window("lanternDayWin")

	--设置为当前显示页
	self._currentParamIndex = _EVERY_CONSUME_PARAM_INDEX

	--如果需要初始化
	if isInit then
		self:initGainAwardPage(t_win)
	end

	--更新页面基础信息
	self:updatePageBaseInfo(t_win)

    --请求每日消费页面信息
	self:requestEveryConsumeInfo()
end

--功能：刷新活动中通用页面的信息
--参数：1、activityInfo		通用页面信息
--返回：无
--作者：肖进超
--时间：2014.10.30
function LanternDayModel:flushPageInfo(activityInfo)
	--获取元宵节活动窗口
	local t_win = UIManager:find_visible_window("lanternDayWin")
	--如果没有显示，不进行操作
	if (not t_win) then
		return
	end

	self:flushCommonInfo(t_win, activityInfo)
end

--功能：结束数据逻辑
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.30
function LanternDayModel:finish()
	UIManager:destroy_window("lanternDayWin")
end

--功能：界面跳转
--参数：无
--返回：无
--作者：chj
--时间：2014.08.30
function LanternDayModel:openGroupBuyActivityWin()
	SuperGroupBuyModel:set_ACTIVITY_ID( CommonActivityConfig.LanternDay )
	UIManager:show_window("super_tuangou_win")
end
--功能：刷新兑换界面的信息
--参数：1、cur_item_num	当前所需道具数量
--返回：无
--作者：肖进超
--作者：肖进超
--时间：2014.12.17
function LanternDayModel:refreshTGExchangeInfo(cur_item_num)
	local t_win = UIManager:find_visible_window("lanternDayWin")
	--如果没有显示，不进行操作
	if (not t_win) then
		return
	end

	self:refreshExchangeStatusInfo(t_win, cur_item_num, CommonActivityConfig.LanternDay)
end