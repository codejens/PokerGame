-------------------------------------
sevenDayAwardConfig = {}
-------------------------------------
function sevenDayAwardConfig:get_index_award(index)
	require "../data/qiriliucun_conf"
	local temp_info = { qiriliucun_conf.OnedayAward, qiriliucun_conf.LiangtianAward, qiriliucun_conf.SantianAward, qiriliucun_conf.SitianAward,
	qiriliucun_conf.WuriAward, qiriliucun_conf.LiuriAward, qiriliucun_conf.QiriAward }
	return temp_info[index]
end