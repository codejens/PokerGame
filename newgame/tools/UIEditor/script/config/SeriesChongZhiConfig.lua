-- SeriesChongZhiConfig.lua
-- created by chj on 2015-3-10
-- 连续充值

SeriesChongZhiConfig = {}

function SeriesChongZhiConfig:get_conf( )
	require "../data/activity_config/series_chongzhi_config"
	return series_chongzhi_config
end 
