-- ShareConfig.lua
-- created by fjh on 2013-9-2
-- 分享成就配置

ShareConfig = {}


function ShareConfig:get_achieve_table_by_sysid( sys_id )
	
	require "../data/djshareconf"
	return djshareconf.table[sys_id];

end

function ShareConfig:get_achieve_config_by_sysid( sys_id )

	require "../data/djshareconf"
	return djshareconf.config[sys_id];

end

