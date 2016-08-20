-- PlantConfig.lua
-- created by HJH
-- 种植
-------------------------------------
PlantUpdateType = 
{
	update_all = 1,
	update_level = 2,
	update_land = 3,
	update_water_num = 4,
	update_water_cd = 5,
	update_luck = 6,
	update_friend = 7,
	update_event = 8,
	update_xianlu = 9,
	update_build_yb = 10,
}
-------------------------------------
PlantConfig = {}
-------------------------------------
function PlantConfig:get_dong_fu_max_level()
	require "../data/dongfu_conf"
	return #dongfu_conf.lingquanAward
end
-------------------------------------
function PlantConfig:get_plant_award_info( index, level )
	require "../data/dongfu_conf"
	local temp_info = dongfu_conf.plantType[1].awardValue[index]
	for i = 1, #temp_info do
		if temp_info[i] == level or i + 1 == #temp_info then
			return temp_info[i + 1]
		end
	end
end
-------------------------------------
function PlantConfig:get_award_value()
	require "../data/dongfu_conf"
	return dongfu_conf.plantType[1].awardValue
end
-------------------------------------
function PlantConfig:get_luck_award_info(index)
	require "../data/dongfu_conf"
	return dongfu_conf.summonLandAdd[index]
end
-------------------------------------
function PlantConfig:get_land_award_info(index)
	require "../data/dongfu_conf"
	return dongfu_conf.landAdd[index]
end
-------------------------------------
function PlantConfig:get_show_min_level()
	require "../data/dongfu_conf"
	return dongfu_conf.openLevel
end
-------------------------------------
function PlantConfig:get_self_water_max_num()
	require "../data/dongfu_conf"
	return dongfu_conf.lingquanSelfCount
end
-------------------------------------
function PlantConfig:get_level_up_money(level)
	require "../data/dongfu_conf"
	return dongfu_conf.upgradeYuanbao[level]
end
-------------------------------------
function PlantConfig:get_luck_money(index)
	require "../data/dongfu_conf"
	return dongfu_conf.summonYuanBao[index]
end
-------------------------------------
function PlantConfig:get_build_full_level_money()
	require "../data/dongfu_conf"
	return dongfu_conf.refreshBestYB
end
-------------------------------------
function PlantConfig:get_quick_per_yb()
	require "../data/dongfu_conf"
	return dongfu_conf.quickGrownYB
end
-------------------------------------
function PlantConfig:get_xianlu_max_num( level )
	require "../data/dongfu_conf"
	return dongfu_conf.maxXianluValue[level]
end