-- AchieveConfig.lua
-- created by aXing on 2013-3-27
-- 成就配置

AchieveConfig = {}

-- 获得成就分组
function AchieveConfig:get_achieve_group(  )
	require "../data/achieve_group"
	return achieve_group
end

-- 根据成就id获取成就数据
function AchieveConfig:get_achieve( achieve_id )
	require "../data/std_achieves"
	return std_achieves[achieve_id]
end

-- 获取成就总表
function AchieveConfig:get_achieve_total(  )
	require "../data/std_achieves"
	return std_achieves
end