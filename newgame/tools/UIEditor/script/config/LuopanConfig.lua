-- LuopanConfig.lua
-- created by lyl on 2013-8-27
-- 罗盘配置

LuopanConfig = {}


-- 获取罗盘道具
function LuopanConfig:get_luopan_item(  )
	require "../data/russia_conf"
    return russia_conf.awards
end