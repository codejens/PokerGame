-- GlobalConfig.lua
-- created by fjh on 2013-1-18
-- 全局属性配置

-- super_class.GlobalConfig()

GlobalConfig = {}


local _CAN_RECHARGE = false -- 是否可以充值

function GlobalConfig:get_item_color( num )
	require "../data/client_global_config"
	local itemColors = client_global_config["itemColors"];
	return Utils:c3_dec_to_hex(itemColors[num]);
end

-- 根据序列号获取充值奖励的道具
function GlobalConfig:get_recharge_award_items( index )
	require "../data/client_global_config"
	if client_global_config.rechargeAwardItems2[index] then
        return client_global_config.rechargeAwardItems2[index]
    else
    	return client_global_config.rechargeAwardItems2[1]
	end
end

--
function GlobalConfig:get_xiaofeilibao_items( index )
	require "../data/client_global_config"
	if index > #client_global_config.consumeAwardItems then
		return client_global_config.consumeAwardItems[#client_global_config.consumeAwardItems]
	else
		return client_global_config.consumeAwardItems[index]
	end
end

--
function GlobalConfig:get_xiaofeilibao_value( index )
	require "../data/client_global_config"
	if index > #client_global_config.consumeAwardPrice then
		return client_global_config.consumeAwardPrice[#client_global_config.consumeAwardPrice]
	else
		return client_global_config.consumeAwardPrice[index]
	end
end

--
function GlobalConfig:get_xiaofeilibao_money( index )
	require "../data/client_global_config"
	if index > #client_global_config.consumeAwardMoney then
		return client_global_config.consumeAwardMoney[#client_global_config.consumeAwardMoney]
	else
		return client_global_config.consumeAwardMoney[index]
	end
end

--
function GlobalConfig:get_xiaofeilibao_item_id()
	require "../data/client_global_config"
	return client_global_config.consumeAwardItemIds
end
---
function GlobalConfig:get_recharge_award(index)
	require "../data/client_global_config"
	if client_global_config.rechargeAwardItems[index] then
		return client_global_config.rechargeAwardItems[index]
	else
		return client_global_config.rechargeAwardItems[1]
	end
end
-- 获取成就列表
function GlobalConfig:get_achieve_group( group_id )
	require "../data/client_global_config"
	return client_global_config.achieveDisplayOrder[group_id]
end

-- 获取是否可以充值
function GlobalConfig:get_can_recharge(  )
	return _CAN_RECHARGE
end

--取得目标奖励起始值
function GlobalConfig:get_begin_goal_target_index()
	return 150
end