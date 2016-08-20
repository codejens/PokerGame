-- QDConfig.lua
-- create by hcl on 2013-5-22
-- 签到配置


QDConfig = {}

function QDConfig:get_award_by_index( index )
	require "../data/dailyattendanceconf"
	return DailyAttendanceConf.rewards_options[index];
end

function QDConfig:get_pet_award_by_month( month )
	return DailyAttendanceConf.gift_pet_reward[month].reward;
end