--CBaseCommonModel.lua
--内容：基础通用活动数据逻辑类
--作者：陈亮
--时间：2014.09.19

--定义常量
local _SPECIAL_ACTIVITY_FINISH_WANRING = "活动已结束！"

--创建基础通用活动数据逻辑类
super_class.BaseCommonModel()

--功能：定义基础通用活动数据逻辑类的属性
--参数：1、self		活动数据逻辑类对象
--返回：无
--作者：陈亮
--时间：2014.09.19
local function create_self_params(self)
	self._activityId = nil					--活动ID
	self._activityConfig = nil				--活动配置对象
	self._currentParamIndex = nil			--当前子活动参数索引
end

--功能：通过状态位来刷新指定窗口的领取状态和刷新玩家消费元宝数
--参数：1、paramIndex		活动参数索引
--		2、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--		4、activityConfig	配置文件
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_gain_status_form_bit(paramIndex,activityWin,activityInfo,activityConfig)
	--解析出获取记录和已领取记录
	local t_canGainRecord = activityInfo.can_get_record
	local t_hadGainRecord = activityInfo.had_get_record
	local t_gainStatusGroup = {}
	-- 每日消费特殊处理
	if activityInfo.activity_child_id == SmallOperationModel.SUB_ACTIVITY_10 then
		t_gainStatusGroup = activityConfig:getEveryRechargeFromBit(paramIndex, activityInfo)
	else
		--获取领取状态组
		t_gainStatusGroup = activityConfig:getGainStatusGroupFromBit(paramIndex,t_canGainRecord,t_hadGainRecord)
	end
	--刷新页面领取状态
	activityWin:refreshGainAwardStatus(t_gainStatusGroup)
	print("activityInfo.activity_child_id:", activityInfo.activity_child_id)
	--如果是累计消费页面 或 每日消费页面
    if activityInfo.activity_child_id == SmallOperationModel.SUB_ACTIVITY_3 
    	or activityInfo.activity_child_id == SmallOperationModel.SUB_ACTIVITY_10 then
        local t_consume = activityInfo.arg     
	    activityWin:refreshConsumeYuanbao(t_consume)  --刷新页面领取状态
    end

    if activityInfo.activity_child_id == SmallOperationModel.SUB_ACTIVITY_2 then
    	 local t_consume = activityInfo.arg  
    	activityWin:refreshChongzhiYuanbao(t_consume)  --刷新页面领取状态
    end

    if activityInfo.activity_child_id == SmallOperationModel.SUB_ACTIVITY_4 then
    	 local t_consume = activityInfo.arg  
    	activityWin:refreshChongzhiYuanbao(t_consume)  --刷新页面领取状态
    end
end

--功能：刷新重复获取状态
--参数：1、activityWin		通用活动窗口
--		2、activityInfo		通用页面信息
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_repeat_gain_status(activityWin,activityInfo)
	--获取当前可以领取的奖励数量
	local t_gainCount = activityInfo.can_get_record
	--如果大于0，使领取按钮和领取全部按钮可以点击，否则不可点击
	if t_gainCount > 0 then
		activityWin:setAllButtonClick()
	else
		activityWin:setAllButtonUnclick()
	end

	--设置可领取数量
	activityWin:setGainAwardCount(t_gainCount)
end

--功能：刷新重复消费页面信息
--参数：1、activityWin		通用活动窗口
--		2、activityInfo		通用页面信息
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_repeat_consume_page(activityWin,activityInfo)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是重复消费页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeRepeatConsume then
		return
	end

	flush_repeat_gain_status(activityWin,activityInfo)
end

--功能：刷新重复充值页面信息
--参数：1、activityWin		通用活动窗口
--		2、activityInfo		通用页面信息
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_repeat_recharge_page(activityWin,activityInfo)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是重复消费页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeRepeatRecharge then
		return
	end

	flush_repeat_gain_status(activityWin,activityInfo)
end

--功能：刷新每日页面信息
--参数：1、paramIndex		活动参数索引
--		2、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--		4、activityConfig	配置文件
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_every_recharge_page(paramIndex,activityWin,activityInfo,activityConfig)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	print("单前页面类型",t_pageType)
	--如果不是每日消费页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeEveryRecharge then
		return
	end

	flush_gain_status_form_bit(paramIndex,activityWin,activityInfo,activityConfig)
end

--功能：刷新累计消费页面信息
--参数：1、paramIndex		活动参数索引
--		2、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--		4、activityConfig	配置文件
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_addup_consume_page(paramIndex,activityWin,activityInfo,activityConfig)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是累计消费页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeAddupConsume then
		return
	end

	flush_gain_status_form_bit(paramIndex,activityWin,activityInfo,activityConfig)
end

--功能：刷新每日充值单礼包页面信息
--参数：1、paramIndex		活动参数索引
--		2、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--		4、activityConfig	配置文件
--返回：无
--作者：肖进超
--时间：2014.12.25
local function flush_daily_recharge_page(paramIndex,activityWin,activityInfo,activityConfig)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是每日充值页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeDailyRecharge then
		return
	end

    --刷新页面领取状态
    local t_gainStatusGroup = BaseCommonConfig:transDailyRechargeState(activityInfo.can_get_record)
    activityWin:refreshGainAwardStatus(t_gainStatusGroup)
end

--功能：刷新累计充值页面信息
--参数：1、paramIndex		活动参数索引
--		2、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--		4、activityConfig	配置文件
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_addup_recharge_page(paramIndex,activityWin,activityInfo,activityConfig)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是累计消费页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeAddupRecharge then
		return
	end

	flush_gain_status_form_bit(paramIndex,activityWin,activityInfo,activityConfig)
end

--功能：刷新累计登陆页面信息
--参数：1、paramIndex		活动参数索引
--		2、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--		4、activityConfig	配置文件
--返回：无
--作者：陈亮
--时间：2014.08.28
local function flush_total_login_page(paramIndex,activityWin,activityInfo,activityConfig)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是累计登陆页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeTotalLogin then
		return
	end

	flush_gain_status_form_bit(paramIndex,activityWin,activityInfo,activityConfig)
end

--功能：基础通用活动配置类初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:__init(activityId,activityConfig)
	--声明成员变量
	create_self_params(self)
	--保存活动ID和活动配置对象
	self._activityId = activityId
	self._activityConfig = activityConfig
end

----------------------------------------------------------------------
--继承CNormalInfoPage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：设置页面基础信息
--参数：1、activityWin	活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:updatePageBaseInfo(activityWin)

	--设置活动标题

	local t_titleImagePath_1 = self._activityConfig:getPageTitleImagePath_1(self._currentParamIndex)
	local t_titleImageSize_1 = self._activityConfig:getPageTitleImageSize_1(self._currentParamIndex)
	activityWin:setPageTitle_1(t_titleImagePath_1,t_titleImageSize_1)


	local t_titleImagePath = self._activityConfig:getPageTitleImagePath(self._currentParamIndex)
	local t_titleImageSize = self._activityConfig:getPageTitleImageSize(self._currentParamIndex)
	activityWin:setPageTitle(t_titleImagePath,t_titleImageSize)
	--设置活动时间
	-- local t_activityTime = self._activityConfig:getActivityTime(self._currentParamIndex)
    -- if t_activityTime ~= "" then  --根据配置文件中写死的时间
	    -- activityWin:setActivityTime(t_activityTime)
    -- else                          --根据服务器下发的活动时间
        local timeStr = SmallOperationModel:getActivityTimeDescEx(self._activityId) or ""
        -- print("情人节  春节 设置活动服务器时间 活动ID,时间=",_activityId,timeStr)
        activityWin:setActivityTime(timeStr)
    -- end
	--设置活动说明
	local t_describe = self._activityConfig:getActivityDescribe(self._currentParamIndex)
	activityWin:setActivityDescribe(t_describe)
	--设置活动剩余时间
	local t_remainTime = SmallOperationModel:getActivityRemainTime(self._activityId)
    -- print("活动ID 活动时间倒计时 :",self._activityId,t_remainTime)
	local t_isTimeOut = false
	--如果剩余时间为0，设置剩余时间状态位true
	if t_remainTime == 0 then
		t_isTimeOut = true
	end
	activityWin:setActivityRemainTime(t_remainTime,t_isTimeOut)

	
	-- add by chj
	local t_titlePage = self._activityConfig:getAcivitytPageTitleEx(self._currentParamIndex)
	if t_titlePage then
		activityWin:setActivityTitlePageEx(t_titlePage)
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CRepeatConsumePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：获取重复消费单礼包
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainRepeatConsumeAward()
	OnlineAwardCC:req_get_activity_award_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_8)
end

--功能：获取全部重复消费单礼包
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainAllRepeatConsumeAward()
	OnlineAwardCC:reqGainAllAward(self._activityId,SmallOperationModel.SUB_ACTIVITY_8)
end

--功能：请求重复消费信息
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:requestRepeatConsumeInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_8)
end
----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CRepeatRechargePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：获取重复充值单礼包
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainRepeatRechargeAward()
	OnlineAwardCC:req_get_activity_award_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_7)
end

--功能：请求重复充值信息
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:requestRepeatRechargeInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_7)
end

--功能：获取全部重复充值单礼包
--参数：无
--返回：无
--作者：陈亮
--时间：2014.11.03
function BaseCommonModel:gainAllRepeatRechargeAward()
	OnlineAwardCC:reqGainAllAward(self._activityId,SmallOperationModel.SUB_ACTIVITY_7)
end
----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CMovePlacePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：前往某个地方
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:forwardPlace()
	--判断活动是否结束,如果结束直接返回
	local t_remainTime = SmallOperationModel:getActivityRemainTime(self._activityId)

	print("self._activityId",self._activityId)
	if t_remainTime == 0 then
		return
	end

	--获取场景信息
	local t_sceneInfo = self._activityConfig:getSceneInfo(self._currentParamIndex)
	--移动到目的地
	GlobalFunc:move_to_target_scene(t_sceneInfo.sceneId,t_sceneInfo.sceneX * SceneConfig.LOGIC_TILE_WIDTH,t_sceneInfo.sceneY * SceneConfig.LOGIC_TILE_HEIGHT)
end

--功能：传送到某个地方
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:transformPlace()
	--判断活动是否结束,如果结束直接返回
	local t_remainTime = SmallOperationModel:getActivityRemainTime(self._activityId)
	if t_remainTime == 0 then
		return
	end

	--获取场景信息
	local t_sceneInfo = self._activityConfig:getSceneInfo(self._currentParamIndex)

	--传送到目的地
	GlobalFunc:teleport_to_target_scene(t_sceneInfo.sceneId,t_sceneInfo.sceneX,t_sceneInfo.sceneY)

	--获取NPC名称
	local t_npcName = t_sceneInfo.npcName
	--如果NPC名称存在，拉起对话框
	if t_npcName then
		AIManager:set_after_pos_change_command(t_sceneInfo.sceneId, AIConfig.COMMAND_ASK_NPC,t_sceneInfo.npcName)
	end
end

----------------------------------------------------------------------
--继承CAddupConsumePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：请求累计消费的信息数据
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:requestAddupConsumeInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_3)
end

--功能：获取累计消费奖励
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainAddupConsumeAward(awardIndex)
	OnlineAwardCC:req_get_activity_award_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_3,awardIndex)
end

----------------------------------------------------------------------
--继承CDailyRechargePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：请求每日充值的信息数据
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.25
function BaseCommonModel:requestDailyRechargeInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId, SmallOperationModel.SUB_ACTIVITY_4)
end

--功能：获取每日充值奖励
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.25
function BaseCommonModel:gainDailyRechargeAward(awardIndex)
	OnlineAwardCC:req_get_activity_award_com(self._activityId, SmallOperationModel.SUB_ACTIVITY_4, awardIndex)
end

----------------------------------------------------------------------
--继承CAddupRechargePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：请求累计充值的信息数据
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:requestAddupRechargeInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_2)
end

--功能：获取累计充值奖励
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainAddupRechargeAward(awardIndex)
	OnlineAwardCC:req_get_activity_award_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_2,awardIndex)
end

----------------------------------------------------------------------
--继承CTotalLoginPage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：请求累计登陆的信息数据
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:requestTotalLoginInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_1)
end

--功能：获取累计登陆奖励
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainTotalLoginAward(awardIndex)
	OnlineAwardCC:req_get_activity_award_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_1,awardIndex)
end

----------------------------------------------------------------------
----------------------------------------------------------------------

--功能：请求每日消费的信息数据
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:requestEveryConsumeInfo()
	OnlineAwardCC:req_activity_data_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_10)
end

--功能：获取每日消费奖励
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:gainEveryConsumeAward(awardIndex)
	OnlineAwardCC:req_get_activity_award_com(self._activityId,SmallOperationModel.SUB_ACTIVITY_10,awardIndex)
end

----------------------------------------------------------------------
--继承CGotoActivityPage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：打开活动窗口到BOSS页
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:openActivityWinToBoss()
	ActivityWin:win_change_page(3)
end

--打开活动窗口到每日限购
function BaseCommonModel:openDailyQuotaBuy( )
	 require "config/activity/SpecialActivityConfig"
	 --设置为春节活动下的子活动
	 --注意 如果一种活动同时存在两个大活动中  这里的类型一定要设置
	DailyQuatoBuyModel:setActivityType(CommonActivityConfig.NewLonelyDay)
    DailyQuatoBuyModel:refreshActivityId(SpecialActivityConfig.NewDailyQuatoBuy)
    UIManager:show_window("dailyQuotaBuyWin")
end

--擦 这哪里灵活了
function BaseCommonModel:openDailyQuotaBuy2( )
	 require "config/activity/SpecialActivityConfig"
	 --设置为春节活动下的子活动
	DailyQuatoBuyModel:setActivityType(CommonActivityConfig.ValentineDay)
    DailyQuatoBuyModel:refreshActivityId(SpecialActivityConfig.OldDailyQuatoBuy)
    UIManager:show_window("dailyQuotaBuyWin")
end


function BaseCommonModel:openDailyQuotaBuyCommon(activity_type,activity_id )
	 require "config/activity/SpecialActivityConfig"
	 --设置为春节活动下的子活动
	DailyQuatoBuyModel:setActivityType(activity_type)
    DailyQuatoBuyModel:refreshActivityId(activity_id)
    UIManager:show_window("dailyQuotaBuyWin")
end


--功能：打开特殊活动窗口
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:openSpecialActivityWin(sepcialActivityId)
	--获取要打开的活动剩余时间
	local t_remainTime = SmallOperationModel:getActivityRemainTime(sepcialActivityId)
	--如果活动剩余时间等于0，表示活动结束，提示活动已结束
	if t_remainTime == 0 then
		GlobalFunc:create_screen_notic(_SPECIAL_ACTIVITY_FINISH_WANRING,14,415,100)
		return 
	end

	--打开聚宝袋
	if sepcialActivityId == 46 then
		DreamlandModel:set_dreamland_type( DreamlandModel.DREAMLAND_TYPE_JBD)
  		UIManager:show_window("jubao_bag_left_win")

  	--打开珍宝轩
  	elseif sepcialActivityId == 60 then
		DreamlandModel:set_dreamland_type( DreamlandModel.DREAMLAND_TYPE_ZBX)
  		UIManager:show_window("jubao_bag_left_win")
        
    --打开大宝殿 
    elseif sepcialActivityId == SpecialActivityConfig.Dabaodian then
        UIManager:show_window("dabaodianWin")

	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CGroupBuyPage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：打开团购活动界面
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function BaseCommonModel:openGroupBuyActivityWin()
	--获取团购的活动剩余时间
	local t_remainTime = SmallOperationModel:getActivityRemainTime(81)
	--如果活动剩余时间等于0，表示活动结束，提示活动已结束
	if t_remainTime == 0 then
		GlobalFunc:create_screen_notic(_SPECIAL_ACTIVITY_FINISH_WANRING,14,415,100)
		return 
	end

	--打开团购活动界面
	UIManager:show_window("groupBuyWin")
end
----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CExchangePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：兑换奖励
--参数：1、awardIndex	奖励索引
--返回：无
--作者：陈亮
--时间：2014.09.23
function BaseCommonModel:exchangeAward(awardIndex)
	--获取兑换ID
	-- local t_exchangeId = self._activityConfig:getExchangeId(self._currentParamIndex,awardIndex)

	--请求兑换奖励
	OnlineAwardCC:reqExchangeProp(awardIndex, self._activityId)
end

--功能：请求兑换信息
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function BaseCommonModel:requestExchangeInfo()
	--请求兑换信息
	OnlineAwardCC:reqExchangeInfoList(self._activityId)
end

--功能：刷新兑换状态信息
--参数：1、activityWin			活动窗口
--		2、exchangeInfoGroup	兑换信息组
--返回：无
--作者：陈亮
--时间：2014.09.23
function BaseCommonModel:refreshExchangeStatusInfo(activityWin,exchangeInfoGroup,activityId)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是重复消费页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeExchange then
		return
	end

	--获取兑换内容组
	local t_propCountGroup = exchangeInfoGroup
	local t_exchangeContentGroup = self._activityConfig:getExchangeContentGroup(self._currentParamIndex,t_propCountGroup, activityId)

	--获取兑换状态组
	-- local t_exchangeStatusGroup = self._activityConfig:transExchangeStatusGroup(self._currentParamIndex,exchangeInfoGroup)
	-- local t_exchangeStatusGroup = {} -- 无限制,可以无限制兑换
	--刷新兑换状态
	activityWin:refreshExchangeStatus(t_propCountGroup,t_exchangeContentGroup)
end

----------------------------------------------------------------------
--继承CQueuePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：跳转到鲜花排行榜窗口
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function BaseCommonModel:gotoSendFollowQueueWin(activity_id)
	local activityId = nil
	-- if self._activityId == CommonActivityConfig.NewLonelyDay or self._activityId == CommonActivityConfig.NewChristmas then
	-- 	activityId = SpecialActivityConfig.NewSendFlower

 --    elseif self._activityId == CommonActivityConfig.OldLonelyDay or self._activityId == CommonActivityConfig.OldChristmas then
 --        activityId = SpecialActivityConfig.OldSendFlower
	-- end
	activityId = activity_id
	-- local t_remainTime = SmallOperationModel:getActivityRemainTime(activityId)
	-- --如果活动剩余时间等于0，表示活动结束，提示活动已结束
	-- if t_remainTime == 0 then
	-- 	GlobalFunc:create_screen_notic(_SPECIAL_ACTIVITY_FINISH_WANRING,14,415,100)
	-- 	return 
	-- end
	-- SendFlowerModel:refreshActivityId(activityId)
	-- OnlineAwardCC:req_get_sendFlowerRanking()
	local win = UIManager:show_window("flower_rank_win");
	if win then
		local send_flower_info = SendFlowerModel:get_send_flower_info()
		win:update_ranking_scroll(send_flower_info,UILH_LONELY.title_songhua)
	end
end

--功能：跳转到鲜花排行榜窗口
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function BaseCommonModel:gotoReceiveFollowQueueWin(activity_id)
	local activityId = nil
	-- if self._activityId == CommonActivityConfig.NewLonelyDay or self._activityId == CommonActivityConfig.NewChristmas then
	-- 	activityId = SpecialActivityConfig.NewSendFlower

 --    elseif self._activityId == CommonActivityConfig.OldLonelyDay or self._activityId == CommonActivityConfig.OldChristmas then
 --        activityId = SpecialActivityConfig.OldSendFlower
	-- end
	activityId = activity_id
	-- local t_remainTime = SmallOperationModel:getActivityRemainTime(activityId)
	-- --如果活动剩余时间等于0，表示活动结束，提示活动已结束
	-- if t_remainTime == 0 then
	-- 	GlobalFunc:create_screen_notic(_SPECIAL_ACTIVITY_FINISH_WANRING,14,415,100)
	-- 	return
	-- end
	-- SendFlowerModel:refreshActivityId(activityId)
	local win = UIManager:show_window("flower_rank_win");
	if win then
		local receive_flower_info = BAReceiveFlowerModel:get_receive_flower_info()
		win:update_ranking_scroll(receive_flower_info,UILH_LONELY.title_shouhua)
		win:update_subtitle(3,Lang.qingrenjie[7]);
	end
end
----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CConsumeQueuePage类的相关数据逻辑函数
----------------------------------------------------------------------
--功能：刷新消费排行信息
--参数：1、activityWin		 活动窗口
--		2、consumeQueueInfo	 消费排行信息
--返回：无
--作者：陈亮
--时间：2014.10.31
function BaseCommonModel:refreshConsumeQueueInfo(activityWin,consumeQueueInfo)
	--获取当前页面类型
	local t_pageType = activityWin:getCurrentPageType()
	--如果不是消费排行页面，不进行操作
	if t_pageType ~= CommonActivityConfig.TypeConsumeQueue then
		return
	end

	--设置我的排行信息
	local t_myQueue = consumeQueueInfo.myQueue
	local t_myConsumeGold = consumeQueueInfo.myConsumeGold
	activityWin:setMyQueueInfo(t_myQueue,t_myConsumeGold)

	local t_queueCount = consumeQueueInfo.queueCount
	--刷新消费排行角色名字、消费排行消费元宝
	local t_roleNameGroup = consumeQueueInfo.roleNameGroup
	local t_consumeGoldGroup = consumeQueueInfo.consumeGoldGroup
	activityWin:refreshConsumeQueueInfo(t_queueCount,t_roleNameGroup,t_consumeGoldGroup)
end

----------------------------------------------------------------------
----------------------------------------------------------------------

--功能：刷新活动中通用页面的信息
--参数：1、activityWin		通用活动窗口
--		3、activityInfo		通用页面信息
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:flushCommonInfo(activityWin,activityInfo)
	--解析出子活动ID
	local t_childActivityId = activityInfo.activity_child_id

	--如果是重复消费活动
	if t_childActivityId == SmallOperationModel.SUB_ACTIVITY_8 then
		flush_repeat_consume_page(activityWin,activityInfo)
	--如果是累计消费活动
	elseif t_childActivityId == SmallOperationModel.SUB_ACTIVITY_3 then
		flush_addup_consume_page(self._currentParamIndex,activityWin,activityInfo,self._activityConfig)
	--如果是累计登陆活动
	elseif t_childActivityId == SmallOperationModel.SUB_ACTIVITY_1 then
		flush_total_login_page(self._currentParamIndex,activityWin,activityInfo,self._activityConfig)
	--如果是重复充值活动
	elseif t_childActivityId == SmallOperationModel.SUB_ACTIVITY_7 then
		flush_repeat_recharge_page(activityWin,activityInfo)
	--如果是累计充值活动
	elseif t_childActivityId == SmallOperationModel.SUB_ACTIVITY_2 then
		flush_addup_recharge_page(self._currentParamIndex,activityWin,activityInfo,self._activityConfig)
	--如果是每日充值单礼包活动
	elseif t_childActivityId == SmallOperationModel.SUB_ACTIVITY_4 then
		flush_daily_recharge_page(self._currentParamIndex,activityWin,activityInfo,self._activityConfig)
	--如果是每日消费单礼包活动
	elseif t_childActivityId == SmallOperationModel.SUB_ACTIVITY_10 then
		flush_every_recharge_page(self._currentParamIndex,activityWin,activityInfo,self._activityConfig)
	end
end

--功能：刷新活动ID，用于分服的通用活动
--参数：1、activityId		活动ID
--返回：无
--作者：陈亮
--时间：2014.10.31
function BaseCommonModel:refreshActivityId(activityId)
	--如果刷新的活动ID和当前活动ID一样，不需执行动作
	if self._activityId == activityId then
		return
	end
	
	--保存活动ID
	self._activityId = activityId
	--刷新活动配置参数
	self._activityConfig:refreshActivityParam(activityId)
end

--功能：初始化活动界面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:initActivityWin(activityWin)
	--初始化窗口
	activityWin:initWindow()
	--设置导航子活动数据
	local t_directlyDataGroup = self._activityConfig:getDirectlyDataGroup()
	activityWin:setDataGroup(t_directlyDataGroup)
	activityWin:resetDirectlyScroll()
	--完成初始化
	activityWin:initFinished()
end

--功能：初始化继承了移动基础页的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:initMovePlacePage(activityWin)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	activityWin:refreshMovePlacePageAward(t_awardDataGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了重复获取页的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonModel:initRepeatGainPage(activityWin)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	activityWin:refreshRepeatGainPageAward(t_awardDataGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了获取奖励页的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:initGainAwardPage(activityWin)
	--重置标题组、奖励组和状态组
	local t_itemTitleGroup = self._activityConfig:getItemTitleGroup(self._currentParamIndex)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	local t_gainStatusGroup = self._activityConfig:getGainStatusGroupFromBit(self._currentParamIndex,nil,nil)
	activityWin:resetGainAwardInfoData(t_itemTitleGroup,t_awardDataGroup,t_gainStatusGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了跳转活动的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:initGotoActivityPage(activityWin)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	activityWin:refreshGotoActivityPageAward(t_awardDataGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了团购活动的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:initGroupBuyPage(activityWin)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	local t_itemtTitleGroup = self._activityConfig:getItemTitleGroup(self._currentParamIndex)
	activityWin:setGroupBuyPageBaseInfo(t_itemtTitleGroup,t_awardDataGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了兑换活动的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:initExchangePage(activityWin, activityId)
	--获取奖励标题组和奖励数据并设置
	local t_itemtTitleGroup = self._activityConfig:getItemTitleGroup(self._currentParamIndex)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	activityWin:setExchangeAwardBaseInfo(t_itemtTitleGroup,t_awardDataGroup)
	--获取兑换状态组、兑换标题组和兑换内容组并设置
	local t_exchangeStatusGroup = self._activityConfig:transExchangeStatusGroup(self._currentParamIndex,nil)
	local t_exchangeTitleGroup = self._activityConfig:getExchangeTitleGroup(self._currentParamIndex)
	local t_exchangeContentGroup = self._activityConfig:getExchangeContentGroup(self._currentParamIndex,nil,activityId)
	activityWin:setExchangeStatusBaseInfo(t_exchangeStatusGroup,t_exchangeTitleGroup,t_exchangeContentGroup)
	--重置兑换滑动框数据
	activityWin:resetExchangeScroll()
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了排行榜页的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.09.22
function BaseCommonModel:initQueuePage(activityWin)
	--重置标题组、奖励组和状态组
	local t_itemTitleGroup = self._activityConfig:getItemTitleGroup(self._currentParamIndex)
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	activityWin:setQueueInfoData(t_itemTitleGroup,t_awardDataGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end

--功能：初始化继承了消费排行的页面
--参数：1、activityWin		通用活动窗口
--返回：无
--作者：陈亮
--时间：2014.10.31
function BaseCommonModel:initConsumeQueuePage(activityWin)
	--重置消费排行信息、角色名字组、消费元宝组
	local t_awardDataGroup = self._activityConfig:getAwardDataGroup(self._currentParamIndex)
	local t_roleNameGroup = self._activityConfig:getDefaultRoleNameGroup(self._currentParamIndex)
	local t_consumeGoldGroup = self._activityConfig:getDefaultConsumeGoldGroup(self._currentParamIndex)
	activityWin:resetConsumeQueueInfo(t_awardDataGroup,t_roleNameGroup,t_consumeGoldGroup)
	--设置完成初始化
	activityWin:pageInitFinish()
end