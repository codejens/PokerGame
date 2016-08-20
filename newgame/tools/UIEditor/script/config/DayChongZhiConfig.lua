-- DayChongZhiConfig.lua
-- created by chj on 2015-3-10
-- 每日充值

DayChongZhiConfig = {}

-- 单档次
function DayChongZhiConfig:get_conf( )
	require "../data/activity_config/day_chongzhi_config"
	return day_chongzhi_config
end 

function DayChongZhiConfig:get_item_conf( )
	require "../data/activity_config/day_chongzhi_config"
	return day_chongzhi_config.item_conf
end

function DayChongZhiConfig:get_chongzhi_yuanbao( )
	require "../data/activity_config/day_chongzhi_config"
	return day_chongzhi_config.yuanbao_cz
end

-- 多档次
function DayChongZhiConfig:get_multi_item_conf( )
	require "../data/activity_config/day_chongzhi_config"
	return day_chongzhi_multi_config.item_conf
end

function DayChongZhiConfig:get_multi_item_desc( )
	require "../data/activity_config/day_chongzhi_config"
	return day_chongzhi_multi_config.item_desc
end

function DayChongZhiConfig:get_multi_item_cz_req( )
	require "../data/activity_config/day_chongzhi_config"
	return day_chongzhi_multi_config.item_cz_req
end