-- BeautyCardConfig.lua
-- created by chj on 2015-4-7
-- 美人抽卡


BeautyCardConfig = {}


function BeautyCardConfig:get_conf( )
	require "../data/beautycard_config"
	return beautycard_config
end

-- 获取美人抽卡类型(是否显示神秘宝箱)
function BeautyCardConfig:get_beautycard_type_num( )
	require "../data/beautycard_config"
	local num_card = 2
	if beautycard_config.bc_type == 2 then
		num_card = 3
	end
	return beautycard_config.bc_type, num_card
end

-- 获取宝箱卡牌的位置
function BeautyCardConfig:get_card_pos(num_card)
	require "../data/beautycard_config"
	-- body
	return beautycard_config.card_pos[num_card]
end

-- 获取宝箱卡牌信息
function BeautyCardConfig:get_card_info( index )
	require "../data/beautycard_config"
	return beautycard_config.card_show[index]
end

-- 获取卡牌翻后的信息
function BeautyCardConfig:get_card_info_open( index )
	require "../data/beautycard_config"
	return beautycard_config.card_open[index]
end

-- 获取抽奖结果信息
-- type:1是抽1次，2是10连抽
function BeautyCardConfig:get_result_info( type)
	require "../data/beautycard_config"
	return beautycard_config.result_info[type]
end

-- 获取抽奖结构道具展示位置
function BeautyCardConfig:get_result_item_pos( type)
	require "../data/beautycard_config"
	return beautycard_config.result_info[type].item_pos
end


-- 服务器打包配置
function BeautyCardConfig:get_ser_conf( )
	require "../data/takecardconfig"
end

-- 获取黄金宝箱倒计时
function BeautyCardConfig:get_gold_freetime( )
	require "../data/takecardconfig"
	return takecardconfig.time[2]
end