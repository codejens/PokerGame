-- BenefitConfig.lua
-- created by LittleWhite on 2014-7-24
-- 福利中心配置
require "../data/dailyloginrewardconf"

BenefitConfig = {}

-- 获取首月登陆奖励的数据
function BenefitConfig:get_firstrawards( days_index )
	
	local award_data = dailyloginrewardconf.firstrewards[days_index]
	return award_data
end

-- 获取其他月登陆奖励的数据
function BenefitConfig:get_normalrewards( days_index )
	local award_data = dailyloginrewardconf.normalrewards[days_index]
	return award_data
end

-- 获取最大奖励天数
function BenefitConfig:get_max_awards_number()
	local max_number = dailyloginrewardconf.maxnum
	return max_number
end

-- 获取首月展示奖励的数据
function BenefitConfig:get_first_showrewards()
	local award_data = dailyloginrewardconf.showrewards[1]
	return award_data
end

-- 获取其他月展示奖励的数据
function BenefitConfig:get_normal_showrewards()
	local award_data = dailyloginrewardconf.showrewards[2]
	return award_data
end