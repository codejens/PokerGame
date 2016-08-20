--CBaseCommonConfig.lua
--内容：基础通用活动配置类
--作者：陈亮
--时间：2014.09.19

--定义常量
local _BUTTON_CLICK_STATUS = true
local _BUTTON_UNCLICK_STATUS = false
local _GAIN_STATUS_IMAGE_PATH = UI_WELFARE.lingqu
local _HAD_STATUS_IMAGE_PATH = UI_WELFARE.yilingqu
local _EXCHANGE_STATUS_IMAGE_PATH = "ui/other/gain_award.png"
local _HAD_EXCHANGE_STATUS_IMAGE_PATH = "ui/other/exchange1.png"

--创建基础通用活动配置类
super_class.BaseCommonConfig()

--功能：定义基础通用活动配置类的属性
--参数：1、self		活动配置类对象
--返回：无
--作者：陈亮
--时间：2014.09.19
local function create_self_params(self)
	self._activityParam = nil			--活动参数
end

--功能：基础通用活动配置类初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:__init(activityParam)
	--声明成员变量
	create_self_params(self)
	--保存活动参数
	self._activityParam = activityParam
end

--功能：获取子活动的导航数据
--参数：无
--返回：1、t_directlyDataGroup		子活动的导航数据
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getDirectlyDataGroup()
	local t_directlyDataGroup = self._activityParam.directlyDataGroup
	return t_directlyDataGroup
end

--功能：设置活动参数
--参数：1、activityParam	活动参数
--返回：无
--作者：陈亮
--时间：2014.10.31
function BaseCommonConfig:setActivityParam(activityParam)
	--保存活动参数
	self._activityParam = activityParam
end

----------------------------------------------------------------------
--继承CCommonBasePage类的相关配置获取函数
----------------------------------------------------------------------
--功能：获取子活动页面的标题路径
--参数：1、itemIndex			子活动索引
--返回：1、t_titleImagePath		子活动页面的标题路径
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getPageTitleImagePath(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_titleImagePath = t_pageData.titleImagePath
	return t_titleImagePath
end

function BaseCommonConfig:getPageTitleImagePath_1(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_titleImagePath = t_pageData.titleImagePath_1
	return t_titleImagePath
end


--功能：获取子活动页面的标题大小
--参数：1、itemIndex			子活动索引
--返回：1、t_titleImageSize		子活动页面的标题大小
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getPageTitleImageSize(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_titleImageSize = t_pageData.titleImageSize
	return t_titleImageSize
end

function BaseCommonConfig:getPageTitleImageSize_1(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_titleImageSize = nil
	if t_pageData.titleImageSize_1 then
		t_titleImageSize = t_pageData.titleImageSize_1
	end
	 
	return t_titleImageSize
end

----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--继承CNormalInfoPage类的相关配置获取函数
----------------------------------------------------------------------
--功能：获取子活动页面的活动时间
--参数：1、itemIndex			子活动索引
--返回：1、t_activityTime		子活动页面的活动时间
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getActivityTime(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_activityTime = t_pageData.activityTime
	return t_activityTime
end

--功能：获取子活动页面的活动说明
--参数：1、itemIndex		子活动索引
--返回：1、t_describe		子活动页面的活动说明
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getActivityDescribe(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_describe = t_pageData.describe
	return t_describe
end

--功能：获取子活动页面的活动说明
--参数：1、itemIndex		子活动索引
--返回：1、t_describe		子活动页面的活动说明
--作者：chj
--时间：2014.09.19
function BaseCommonConfig:getAcivitytPageTitleEx( itemIndex )
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_pageTitle = t_pageData.title_page
	return t_pageTitle
end
----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
--其他可选的配置获取函数
----------------------------------------------------------------------
--功能：获取子活动页面的奖励组数据
--参数：1、itemIndex			子活动索引
--返回：1、t_awardDataGroup		子活动页面的奖励组数据
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getAwardDataGroup(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_awardDataGroup = t_pageData.awardGroup
	return t_awardDataGroup
end

--功能：获取子活动页面的标题组数据
--参数：1、itemIndex			子活动索引
--返回：1、t_itemTitleGroup		子活动页面的标题组数据
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:getItemTitleGroup(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_itemTitleGroup = t_pageData.itemTitleGroup
	return t_itemTitleGroup
end

--功能：获取子活动页面的前往副本或者BOSS地点的场景信息
--参数：1、itemIndex		子活动索引
--返回：1、t_sceneInfo		子活动页面的前往副本或者BOSS地点的场景信息
--作者：陈亮
--时间：2014.09.19
function BaseCommonConfig:getSceneInfo(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_sceneInfo = t_pageData.sceneInfo
	return t_sceneInfo
end

--功能：获取子活动页面的兑换标题组数据
--参数：1、itemIndex				子活动索引
--返回：1、t_exchangeTitleGroup		子活动页面的兑换标题组数据
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:getExchangeTitleGroup(itemIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_exchangeTitleGroup = t_pageData.exchangeTitleGroup
	return t_exchangeTitleGroup
end

--功能：获取子活动页面的兑换内容组数据
--参数：1、itemIndex					子活动索引
--		2、propCountGroup				已有兑换道具数量组
--返回：1、t_exchangeContentGroup		子活动页面的兑换内容组数据
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:getExchangeContentGroup(itemIndex,propCountGroup,activity_id)
	--创建兑换内容组
	local t_exchangeContentGroup = {}
	require "../data/exchange_conf"
	if activity_id and not exchange_conf[activity_id] then return t_exchangeContentGroup end
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_exchangeCountGroup = t_pageData.exchangeCountGroup

	--如果兑换道具数量组存在
	if propCountGroup then
		-- local t_itemCount = #propCountGroup
		-- --如果拥有的兑换道具数量大于0，生成兑换内容
		-- if t_itemCount > 0 then
		-- 	--遍历生成兑换组数据
		-- 	for t_itemIndex = 1,t_itemCount do
		-- 		local t_exchangeCount = t_exchangeCountGroup[t_itemIndex]
		-- 		local t_propCount = propCountGroup[t_itemIndex]
		-- 		local t_exchangeContent = string.format("%d/%d",t_propCount,t_exchangeCount)
		-- 		t_exchangeContentGroup[t_itemIndex] = t_exchangeContent
		-- 	end
		-- end
		local t_itemCount = #t_exchangeCountGroup
		for t_itemIndex = 1,t_itemCount do
			local t_exchangeCount = t_exchangeCountGroup[t_itemIndex]
			local t_exchangeContent = string.format("%d/%d",propCountGroup,t_exchangeCount)
			t_exchangeContentGroup[t_itemIndex] = t_exchangeContent
		end
		t_exchangeContentGroup.itemId = exchange_conf[activity_id].itemId
	--如果兑换道具数量组为空，返回默认兑换内容信息
	else
		local t_itemCount = #exchange_conf[activity_id].itemPool
		for t_itemIndex = 1,t_itemCount do
			t_exchangeContentGroup[t_itemIndex] = "--"
		end
	end
		
	return t_exchangeContentGroup
end

--功能：获取子活动页面的兑换ID数据
--参数：1、itemIndex		子活动索引
--		2、awardIndex		兑换奖励索引
--返回：1、t_exchangeId		子活动页面的兑换ID
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:getExchangeId(itemIndex,awardIndex)
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_exchangeIdGroup = t_pageData.exchangeIdGroup
	local t_exchangeId = t_exchangeIdGroup[awardIndex]
	return t_exchangeId
end

--功能：转换出兑换状态组
--参数：1、itemIndex					子活动索引
--		2、exchangeInfoGroup			兑换信息组
--返回：1、t_transfromStatusGroup		子活动页面的兑换状态组
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:transExchangeStatusGroup(itemIndex,exchangeInfoGroup)
	--创建转换后的兑换状态组
	local t_transfromStatusGroup = {}

	--解析出状态数量
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_awardDataGroup = t_pageData.awardGroup

	--如果输入的兑换信息组存在，转换成页面需要的状态组
	if exchangeInfoGroup then
		--解析兑换信息组
		local t_statusGroup = exchangeInfoGroup.status
		local t_propCount = exchangeInfoGroup.propCount
		local t_statusCount = #t_statusGroup
		--如果状态数量大于0，转换出新的状态组信息
		if t_statusCount > 0 then
			--获取需要兑换的数量组
			local t_exchangeCountGroup = t_pageData.exchangeCountGroup
			--解析出兑换状态组和拥有的兑换数量组
			local t_exchangeStatusGroup = exchangeInfoGroup.status
			local t_propCountGroup = exchangeInfoGroup.propCount
			--遍历状态组，转化所有状态
			for t_statusIndex = 1,t_statusCount do
				local t_exchangeStatus = t_exchangeStatusGroup[t_statusIndex]
				local t_propCount = t_propCountGroup[t_statusIndex]
				local t_exchangeCount = t_exchangeCountGroup[t_statusIndex]
				local t_transfromStatus = {}
				--如果已经兑换了，设置已兑换
				if t_exchangeStatus == 2 then
					t_transfromStatus.status = _BUTTON_UNCLICK_STATUS
					t_transfromStatus.imagePath = _HAD_EXCHANGE_STATUS_IMAGE_PATH
				--如果不够兑换数量，设置不可兑换
				elseif t_propCount < t_exchangeCount then
					t_transfromStatus.status = _BUTTON_UNCLICK_STATUS
					t_transfromStatus.imagePath = _EXCHANGE_STATUS_IMAGE_PATH
				--如果够兑换数量，设置可兑换
				elseif t_propCount >= t_exchangeCount then
					t_transfromStatus.status = _BUTTON_CLICK_STATUS
					t_transfromStatus.imagePath = _EXCHANGE_STATUS_IMAGE_PATH
				end
				t_transfromStatusGroup[t_statusIndex] = t_transfromStatus
			end
		end
	--如果输入的兑换信息组不存在，返回默认的状态组
	else
		local t_statusCount = #t_awardDataGroup
		--遍历状态组，设置所有默认状态
		for t_statusIndex = 1,t_statusCount do
			local t_transfromStatus = {}
			t_transfromStatus.status = _BUTTON_UNCLICK_STATUS
			t_transfromStatus.imagePath = _EXCHANGE_STATUS_IMAGE_PATH
			t_transfromStatusGroup[t_statusIndex] = t_transfromStatus
		end
	end

	return t_transfromStatusGroup
end

--功能：转换出每日充值单礼包领取状态状态
--参数：1、flag                     领取状态标志
--返回：1、t_gainStatusGroup		子活动页面的兑换状态组
--作者：肖进超
--时间：2014.12.27
function BaseCommonConfig:transDailyRechargeState(flag)
     t_gainStatusGroup = {[1] = {},}  
    if flag >= 1 then      --可领取
        t_gainStatusGroup[1].status = _BUTTON_CLICK_STATUS
		t_gainStatusGroup[1].imagePath = _GAIN_STATUS_IMAGE_PATH

    elseif flag == 0 then  --不可领取
        t_gainStatusGroup[1].status = _BUTTON_UNCLICK_STATUS
		t_gainStatusGroup[1].imagePath = _GAIN_STATUS_IMAGE_PATH

    elseif flag == -1 then --已领取
        t_gainStatusGroup[1].status = _BUTTON_UNCLICK_STATUS
		t_gainStatusGroup[1].imagePath = _HAD_STATUS_IMAGE_PATH
    end
    return t_gainStatusGroup
end

--功能：获取领取状态组
--参数：1、itemIndex				子活动索引
--		2、canGainRecord			可领取记录
--		3、hadGainRecord			已领取记录
--返回：1、t_gainStatusGroup		领取状态组
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:getGainStatusGroupFromBit(itemIndex,canGainRecord,hadGainRecord)
	--创建获取状态组
	local t_gainStatusGroup = {}

	--解析出状态数量
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_awardDataGroup = t_pageData.awardGroup
	local t_statusCount = #t_awardDataGroup
	--根据状态组转换成新的状态组
	if canGainRecord and hadGainRecord then
		--遍历设置默认状态
		for t_statusIndex = 1,t_statusCount do
			--创建状态表
			t_gainStatusGroup[t_statusIndex] = {}

			local t_canGainStatus = Utils:get_bit_by_position(canGainRecord,t_statusIndex)
			local t_hadGainStatus = Utils:get_bit_by_position(hadGainRecord,t_statusIndex)

			--不可领取
			if t_canGainStatus == 0 then
				t_gainStatusGroup[t_statusIndex].status = _BUTTON_UNCLICK_STATUS
				t_gainStatusGroup[t_statusIndex].imagePath = _GAIN_STATUS_IMAGE_PATH
			--已领取
			elseif t_hadGainStatus == 1 then
				t_gainStatusGroup[t_statusIndex].status = _BUTTON_UNCLICK_STATUS
				t_gainStatusGroup[t_statusIndex].imagePath = _HAD_STATUS_IMAGE_PATH
			--可领取
			else
				t_gainStatusGroup[t_statusIndex].status = _BUTTON_CLICK_STATUS
				t_gainStatusGroup[t_statusIndex].imagePath = _GAIN_STATUS_IMAGE_PATH
			end
		end
	else
		--遍历设置默认状态
		for t_statusIndex = 1,t_statusCount do
			--创建状态表
			t_gainStatusGroup[t_statusIndex] = {}
			t_gainStatusGroup[t_statusIndex].status = _BUTTON_UNCLICK_STATUS
			t_gainStatusGroup[t_statusIndex].imagePath = _GAIN_STATUS_IMAGE_PATH
		end
	end

	return t_gainStatusGroup
end

--功能：获取每日消费领取状态组
--参数：1、itemIndex				子活动索引
--		2、canGainRecord			礼包总数
--		3、hadGainRecord			已领取状态
--返回：1、t_gainStatusGroup		领取状态组
--作者：陈亮
--时间：2014.09.22
function BaseCommonConfig:getEveryRechargeFromBit(itemIndex,activityInfo)
	--解析出获取记录和已领取记录
	local canGainRecord = activityInfo.can_get_record
	local hadGainRecord = activityInfo.had_get_record
	local cost_num = activityInfo.arg 	--今日消费元宝数量
	--创建获取状态组
	local t_gainStatusGroup = {}
	--解析出状态数量
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_awardDataGroup = t_pageData.rechargeCountGroup
	local t_statusCount = #t_awardDataGroup
	--根据状态组转换成新的状态组
	if hadGainRecord then
		--遍历设置默认状态
		for t_statusIndex = 1,t_statusCount do
			--创建状态表
			t_gainStatusGroup[t_statusIndex] = {}

			local t_hadGainStatus = hadGainRecord[t_statusIndex]
			--不可领取
			if t_hadGainStatus == 0 then
				t_gainStatusGroup[t_statusIndex].status = _BUTTON_UNCLICK_STATUS
				t_gainStatusGroup[t_statusIndex].imagePath = _GAIN_STATUS_IMAGE_PATH
			--已领取
			elseif t_hadGainStatus == 2 then
				t_gainStatusGroup[t_statusIndex].status = _BUTTON_UNCLICK_STATUS
				t_gainStatusGroup[t_statusIndex].imagePath = _HAD_STATUS_IMAGE_PATH
			--可领取
			else
				t_gainStatusGroup[t_statusIndex].status = _BUTTON_CLICK_STATUS
				t_gainStatusGroup[t_statusIndex].imagePath = _GAIN_STATUS_IMAGE_PATH
			end
		end
	else
		--遍历设置默认状态
		for t_statusIndex = 1,t_statusCount do
			--创建状态表
			t_gainStatusGroup[t_statusIndex] = {}
			t_gainStatusGroup[t_statusIndex].status = _BUTTON_UNCLICK_STATUS
			t_gainStatusGroup[t_statusIndex].imagePath = _GAIN_STATUS_IMAGE_PATH
		end
	end

	return t_gainStatusGroup
end

--功能：获取默认的消费排行的角色名字组
--参数：1、itemIndex			子活动索引
--返回：1、t_roleNameGroup		角色名字组
--作者：陈亮
--时间：2014.11.03
function BaseCommonConfig:getDefaultRoleNameGroup(itemIndex)
	--解析出消费排行最大数量
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_awardDataGroup = t_pageData.awardGroup
	local t_consumeQueueCount = #t_awardDataGroup

	--生成默认的消费排行的角色名字组
	local t_roleNameGroup = {}
	for t_index = 1,t_consumeQueueCount do
		t_roleNameGroup[t_index] = "--"
	end

	return t_roleNameGroup
end

--功能：获取默认的消费排行的消费元宝组
--参数：1、itemIndex			子活动索引
--返回：1、t_consumeGoldGroup	消费元宝组
--作者：陈亮
--时间：2014.11.03
function BaseCommonConfig:getDefaultConsumeGoldGroup(itemIndex)
	--解析出消费排行最大数量
	local t_pageDataGroup = self._activityParam.pageDataGroup
	local t_pageData = t_pageDataGroup[itemIndex]
	local t_awardDataGroup = t_pageData.awardGroup
	local t_consumeQueueCount = #t_awardDataGroup

	--生成默认的消费排行的消费元宝组
	local t_consumeGoldGroup = {}
	for t_index = 1,t_consumeQueueCount do
		t_consumeGoldGroup[t_index] = "--"
	end

	return t_consumeGoldGroup
end
