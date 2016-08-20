-- QQVipConfig.lua
QQVipConfig = {}

QQVipConfig.get_vip_fresh_award_info = nil
QQVipConfig.get_vip_daly_award_info = nil
QQVipConfig.get_vip_year_award_info = nil
QQVipConfig.get_vip_level_award_info = nil
QQVipConfig.get_vip_pet_award_info = nil
QQVipConfig.get_vip_award_item_num = nil
QQVipConfig.get_vip_max_level = nil

function QQVipConfig:get_vip_blue_fresh_award_info()
	require "../data/lanzuan"
	return lanzuan.lanzuanxinshouAward
end

function QQVipConfig:get_vip_blue_daly_award(index)
	require "../data/lanzuan"
	if index > QQVipConfig:get_vip_max_level() then
		index = QQVipConfig:get_vip_max_level()
	end
	local temp_info = { lanzuan.YiJilanzhuanmeiriAward, lanzuan.ErJilanzhuanmeiriAward, lanzuan.SanJilanzhuanmeiriAward, lanzuan.SiJilanzhuanmeiriAward,
	 lanzuan.WuJilanzhuanmeiriAward, lanzuan.LiuJilanzhuanmeiriAward, lanzuan.QiJilanzhuanmeiriAward }
	return temp_info[index]
end

function QQVipConfig:get_vip_blue_year_award()
	require "../data/lanzuan"
	return lanzuan.NianfeiAward
end

function QQVipConfig:get_vip_blue_level_award(index)
	require "../data/lanzuan"
	local cur_index = 0
	if index < 20 then
		cur_index = 10
	elseif index < 30 then
		cur_index = 20
	elseif index < 40 then
		cur_index = 30
	elseif index < 50 then
		cur_index = 40
	elseif index < 60 then
		cur_index = 50
	elseif index < 70 then
		cur_index = 60 
	elseif index < 80 then
		cur_index = 70 
	elseif index < 90 then
		cur_index = 80
	elseif index < 100 then
		cur_index = 90
	end
	local temp_max_info = QQVipConfig:get_vip_max_level() * 10
	if cur_index > temp_max_info then
		cur_index = temp_max_info
	end
	local temp_info = { [10] = lanzuan.ShijiCZAward, [20] = lanzuan.ErshiCZAward, [30] = lanzuan.SanshiCZAward, [40] = lanzuan.SishiCZAward, 
						[50] = lanzuan.WushiCZAward, [60] = lanzuan.LiushiCZAward, [70] = lanzuan.QishiCZAward }
	return temp_info[cur_index], cur_index
end

function QQVipConfig:get_vip_blue_pet()
	require "../data/lanzuan"
	return lanzuan.ChongwuAward[1]
end

function QQVipConfig:get_vip_blue_award_item_num()
	require "../data/lanzuan"
	return lanzuan.award_item_num
end

function QQVipConfig:get_vip_blue_max_level()
	require "../data/lanzuan"
	return lanzuan[1].maxlevel
end