-- SuitConfig.lua
-- created by fjh on 2013-1-21
-- 装备套装的属性配置

-- super_class.SuitConfig()

SuitConfig = {}

function SuitConfig:get_suit_equip_info( suit_id )
	require "../data/suitConfig"	
	return suitConfig[suit_id];
end