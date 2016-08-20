--region SendFlowerConfig.lua    --送花排行榜活动单体配置
--Author : 肖进超
-- Date   : 2014/10/27

--加载送花排行榜活动参数文件
--require "../data/activity_config/SendFlowerParam"

SendFlowerConfig = {}
local _activityParam = nil

--获取排名奖励
function SendFlowerConfig:getRewardGrup()
	if _activityParam == nil then 
		return 
	end
    return _activityParam.rewardGrup
end

--获取累计送花奖励
function SendFlowerConfig:getAddUpGroup()
	if _activityParam == nil then 
		return 
	end
    return _activityParam.addUpGroup
end

--获取帮助说明文本
function SendFlowerConfig:getHelpContent()
	if _activityParam == nil then 
		return 
	end
    return _activityParam.helpContent
end

--获得活动描述
function SendFlowerConfig:getActivityDesc()
	if _activityParam == nil then 
		return 
	end
    return _activityParam.activityDesc
end


--刷新配置活动参数，加载送花排行榜活动参数文件
function SendFlowerConfig:refreshActivityParam(activityId)
	if activityId == 99 then     --老服送花活动
		require "../data/activity_config/old_sendflower_param"
		_activityParam = OldSendFlowerParam

	-- elseif activityId == SpecialActivityConfig.NewSendFlower then --新服送花活动
	-- 	require "../data/activity_config/new_sendflower_param"
	-- 	_activityParam = NewSendFlowerParam
	end
end
