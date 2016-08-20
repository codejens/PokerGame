-- toplistconfig.lua
-- created by HJH on 2013-3-5
-- VIP系统

-- super_class.VIPConfig()
VIPConfig = {}

function VIPConfig:get_vip_level_yuanbao(level)
	require "../data/vip"	
	local yuanbaos = vip["yuanbaos"];
	return yuanbaos[level];
end

-- 获取某即的详细配置
function VIPConfig:get_vip_level_info( level )
	require "../data/vip"
	local level_info = vip.levels[ level ]
	return level_info
end

-- 根据等级获取vip增加任务数
function VIPConfig:get_vip_level_add_task( level )
	require "../data/vip"
	return vip.dayQuestAdds[level]
end
