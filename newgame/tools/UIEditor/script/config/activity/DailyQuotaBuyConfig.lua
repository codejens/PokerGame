--region DailyQuotaBuyConfig.lua    --每日限购活动单体配置
--Author : 肖进超
-- Date   : 2015/1/6

DailyQuotaBuyConfig = {}
local _activityParam = nil

--
function DailyQuotaBuyConfig:getDesc()
    return _activityParam.desc
end

--
function DailyQuotaBuyConfig:getQuotaItems(tag)
    return _activityParam[tag]
end

function DailyQuotaBuyConfig:getQuotaItems2(tag,day)
    return _activityParam[tag][day]
end

--刷新配置活动参数，加载送花排行榜活动参数文件
function DailyQuotaBuyConfig:refreshActivityParam(activityId)
	if activityId == SpecialActivityConfig.NewDailyQuatoBuy then     --老服每日限购
		require "../data/activity_config/CommonActivity/dailyquotabuy_new_param"
		_activityParam = NewDailyQuotaBuyParam
		
	elseif activityId == SpecialActivityConfig.OldDailyQuatoBuy then --新服每日限购
		require "../data/activity_config/CommonActivity/dailyquotabuy_old_param"
		_activityParam = OldDailyQuotaBuyParam
	
	elseif activityId == SpecialActivityConfig.WomanQuatoBuy then --新服每日限购
		require "../data/activity_config/CommonActivity/dailyquotabuy_woman_param"
		_activityParam = WDailyQuotaBuyParam
	elseif activityId == SpecialActivityConfig.WorkQuatoDay then --新服每日限购
		require "../data/activity_config/CommonActivity/dailyquotabuy_work_param"
		_activityParam = WorkDailyQuotaBuyParam
	end
end