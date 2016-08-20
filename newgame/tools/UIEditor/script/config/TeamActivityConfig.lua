--create by jiangjinhong
--TeamActivityConfig.lua
--组队副本配置
TeamActivityConfig = {}

function TeamActivityConfig:get_fuben_num(  )
	require "../data/teamActivity/TeamActivity_config"
	ZXLog("-----------------副本数量：",#TeamActivity_config)
	return #TeamActivity_config
end
function TeamActivityConfig:get_fuben_info( index )
	require "../data/teamActivity/TeamActivity_config"
	return TeamActivity_config[index]
end
function TeamActivityConfig:get_all_fuben_listid( )
	require "../data/teamActivity/TeamActivity_config"
	local fuben_id_table = {}
	for i=1,#TeamActivity_config do
		fuben_id_table[i] = TeamActivity_config[i].fuben_listid
	end
	return fuben_id_table
end
