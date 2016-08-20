-- MeirenConfig.lua
-- created by xiehande on 2015-3-16
-- 活动配置

-- super_class.MeirenConfig()
MeirenConfig = {}

-- 获取父目录集合
function MeirenConfig:get_cardGroup_array( )
	require "../data/collectcard"
	return collectcard.cardGroup
end

--父目录集合有几个
function MeirenConfig:get_cardGroup_size( )
	require "../data/collectcard"
	return #collectcard.cardGroup
end

--获取父目录中的一个
function MeirenConfig:get_cardGroup_array( index)
	require "../data/collectcard"
	return collectcard.cardGroupp[index]
end




