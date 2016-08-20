-- tongjiConfig.lua
-- created by fjh on 2013-2-20
-- 副本统计配置

-- super_class.TongjiConfig()
TongjiConfig = {}

function TongjiConfig:get_fuben_config( fbId,actId )
	require "../data/fuben_tongji"
	-- 根据副本id和活动id映射一个统计配置
	local fbList = fuben_tongji.fbList;
	for i,fb in ipairs(fbList) do
		if fb.fbID == fbId then
			--有些副本配置没有activityID，所以如果activityID不为nil，则需要进行匹配activityID，
			if fb.activityID ~= nil then 
				if fb.activityID == actId then 
					return fb
				else
					return;
				end
			else
			--如果activityID为nil，则直接返回当前这个fb
				return fb
			end
		end
	end
	return
end