-- WorldBossConfig.lua
-- created by lyl on 2013-2-21
-- 世界boss配置

-- super_class.WorldBossConfig()
WorldBossConfig = {}


-- 获取世界boss所有活动信息
function WorldBossConfig:get_world_boss_info(  )
	require "../data/world_boss"
	return world_boss
end

-- 根据活动id获取单个boss活动信息
function WorldBossConfig:get_activity_info_by_id( activity_id )
	require "../data/world_boss"
    for key2, activity_info in pairs(world_boss) do
        if activity_info.id == activity_id then
            return activity_info
        end
    end
	return nil
end