-- MiniMapConfig.lua
-- created by fjh on 2013-3-28
-- mini地图

MiniMapConfig = {}


function MiniMapConfig:get_mini_map_info( mapfile)
	require "res.data.map_config"
 	return map_config[mapfile];

 end 
