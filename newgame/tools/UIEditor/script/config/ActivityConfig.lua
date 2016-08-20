-- ActivityConfig.lua
-- created by lyl on 2013-2-21
-- 活动配置

-- super_class.ActivityConfig()
ActivityConfig = {}


-- @brief:服务器下发活动时间变化的活动id，该活动id不对应于统计配置里的activityID
ActivityConfig.ACTIVITY_PANTAOSHENGYAN = 1;		--蟠桃盛宴
ActivityConfig.ACTIVITY_SHOULINGFENGYIN = 2;	--仙灵封印
ActivityConfig.ACTIVITY_TIANYUANZHIZHAN = 3;	--天元之战
ActivityConfig.ACTIVITY_ZHENYINGZHAN = 4;		--阵营战
ActivityConfig.ACTIVITY_HUANLEHUSONG = 5;		--欢乐护送
ActivityConfig.ACTIVITY_LINGQUANXIANYU = 6;		--灵泉仙浴
ActivityConfig.ACTIVITY_BAGUADIGONG = 7;		--八卦地宫
ActivityConfig.ACTIVITY_QUESTION = 8;			--答题活动
ActivityConfig.ACTIVITY_FREE_MATCH = 9;			--自由赛
ActivityConfig.ACTIVITY_DOMINATION_MATCH = 10;	--争霸赛
ActivityConfig.ACTIVITY_GUILD_FUBEN = 19;		--仙宗副本

--这个不是活动,放在主界面的任务章节入口,不属于活动,避免重复,这里定义一个
ActivityConfig.CHAPTER_TASK_ENTRY = 99
-- 活动开放的等级
ActivityConfig.LEVEL_BAGUADIGONG = 38
ActivityConfig.LEVEL_WENQUAN = 25
ActivityConfig.LEVEL_ZHENYINGZHAN = 28

-- 活动场景
ActivityConfig.SCENE_BAGUADIGONG = 1128
ActivityConfig.SCENE_WENQUAN = 1077

-- 获取某类活动信息    daily  fuben    
function ActivityConfig:get_activity_info_by_class( class_name )
	require "../data/activity_config"
	return activity_config[class_name]
end

-- 根据活动id，获取某个活动信息
function ActivityConfig:get_activity_info_by_id( activity_id )
	require "../data/activity_config"
	for key1, class_info in pairs(activity_config) do
        for key2, activity_info in pairs(class_info) do
            if activity_info.id == activity_id then
                return activity_info
            end
        end
	end
	return nil
end


function ActivityConfig:get_activity_info_by_fbid( fb_id )
	require "../data/activity_config"
	for key1, class_info in pairs(activity_config) do
        for key2, activity_info in pairs(class_info) do
            if activity_info.FBID == fb_id then
                return activity_info
            end
        end
	end
	return nil
end



--获取分层后的副本信息  
function ActivityConfig:get_activity_info_by_id_fenceng( activity_id )
	require "../data/client/activity_fuben_fenceng"
	return activity_fuben_fenceng[activity_id]
end