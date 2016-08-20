-------------------------------------
OnlineAwardConfig = {}
-------------------------------------
function OnlineAwardConfig:get_index_award()
	require "../data/client/online_award_config"
	return online_award_config
end