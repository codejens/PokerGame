-- PaoHuanModel.lua
-- create by hcl on 2012-12-10
-- 跑环
require "../data/looptaskconfig"

PaoHuanModel = {}

local pao_huan_info = {};

function PaoHuanModel:get_max_level( )
	return loopTaskConfig.OPEN_LEVEL
end

function PaoHuanModel:fini( ... )
	pao_huan_info = {};
end

function PaoHuanModel:set_ph_info( ph_info )
	pao_huan_info = ph_info;
end

function PaoHuanModel:get_ph_info( )
	return pao_huan_info;
end

function PaoHuanModel:get_awards_table()
	return loopTaskConfig.itemAwards;
end

-- 获取最大奖励个数
function PaoHuanModel:get_max_awards_number()	
	return #loopTaskConfig.itemAwards
end

function PaoHuanModel:get_award_data_by_index(index)	
	return loopTaskConfig.itemAwards[index]
end

-- 获取跑环说明文字
function PaoHuanModel:get_task_explain()	
	return loopTaskConfig.task_explain
end

-- 获取解环石id
function PaoHuanModel:get_jiehuanshi_id()	
	return loopTaskConfig.finishItemId
end