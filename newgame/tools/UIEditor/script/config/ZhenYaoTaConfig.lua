-- ZhenYaoTaConfig.lua
-- created by tjh on 2014-5-23
-- 镇妖塔

ZhenYaoTaConfig={}

--获取boss攻略
function ZhenYaoTaConfig:get_boss_gonglue( index )
	require "../data/tongtianta_gl"
	return Tongtianta[index]
end

--获取本层奖励
function ZhenYaoTaConfig:get_award_by_index( index )
	require "../data/tongtiantaconf_config"
	return tongtiantaconf_config.scenes[index].award
end

--获取头像路径
function ZhenYaoTaConfig:get_head_path( index )
	require "../data/zhenyaot_head_path"
	return zhenyaot_head_path[index]
end

