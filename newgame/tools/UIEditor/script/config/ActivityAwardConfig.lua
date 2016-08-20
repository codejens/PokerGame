-- ActivityAwardConfig.lua
-- created by lyl on 2013-3-4
-- 活跃奖励配置

-- super_class.ActivityAwardConfig()
ActivityAwardConfig = {}

-- 获取活跃奖励,目标列表
function ActivityAwardConfig:get_activity_target_list(  )
	require "../data/activity_award"
	return activity_award.targets
end

-- 获取活跃奖励， 奖品列表
function ActivityAwardConfig:get_award_item_list(  )
	require "../data/activity_award"
	return activity_award.awards
end

-- 获取活跃奖励， 积分列表
function ActivityAwardConfig:get_award_point_list(  )
	require "../data/activity_award"
	return activity_award.activitys
end

-- 获取活跃奖励，领取个数列表
function ActivityAwardConfig:get_award_point_count_list(  )
	require "../data/activity_award"
	return activity_award.count
end

-- 获取活动奖励，按id排序后的列表
function ActivityAwardConfig:get_activity_target_range_list(  )
	require "utils/Utils"
	-- 不能影响配置文件顺序，所以必须使用 克隆 方法获取后再排序
	local target_list = Utils:table_clone( ActivityAwardConfig:get_activity_target_list() )
	local function campare_func( element_1, element_2 )
		if element_1.id < element_2.id then
            return true
		end
		return false
	end
	table.sort(target_list, campare_func)
	return target_list
end

-- 根据活动id，获取配置中的排列序列号  (服务器按这个序列号来发送次数信息)
function ActivityAwardConfig:get_index_by_target_id( target_id )
	local ret = 0
	require "../data/activity_award"
	for i = 1, #activity_award.targets do
        if activity_award.targets[i].id == target_id then
            ret = i
        end
	end
	return ret
end