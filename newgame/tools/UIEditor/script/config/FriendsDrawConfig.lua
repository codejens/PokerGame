-- FriendsDrawConfig.lua
-- created by chj on 2015-1-31
-- 密友抽奖

-- super_class.DjConfig()
FriendsDrawConfig = {}

function FriendsDrawConfig:get_item_conf( )
	require "../data/callfriendconf"
	return callfriendconf.itemList[1]
end

function FriendsDrawConfig:get_gift_conf( )
	require "../data/callfriendconf_client"
	return callfriendconf_client
end