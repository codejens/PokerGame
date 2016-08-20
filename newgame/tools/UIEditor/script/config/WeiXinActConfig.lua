-- 微信活动配置
WeiXinActConfig = {}

function WeiXinActConfig:get_item_by_index( index )
	require "../data/activity_config/qq_weixin_conf"
	if index >= 1 and index <= #_qq_weixin_get_slot_id then
		return _qq_weixin_get_slot_id[index]
	end
end

function WeiXinActConfig:get_item()
	require "../data/activity_config/qq_weixin_conf"
	return _qq_weixin_get_slot_id;
end