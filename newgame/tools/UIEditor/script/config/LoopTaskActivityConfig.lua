-- LoopTaskActivityConfig.lua
-- created by MWY on 2014-08-15
-- 跑环配置表
require "../data/loopTaskConfig"

LoopTaskActivityConfig = {}

-- 获取最大奖励个数
function LoopTaskActivityConfig:get_max_awards_number()	
	return #loopTaskConfig.itemAwards
end

function LoopTaskActivityConfig:get_award_data_by_index(index)	
	return loopTaskConfig.itemAwards[index]
end

-- 获取跑环说明文字
function LoopTaskActivityConfig:get_task_explain()	
	return loopTaskConfig.task_explain
end

-- 获取解环石id
function LoopTaskActivityConfig:get_jiehuanshi_id()	
	return loopTaskConfig.finishItemId
end

