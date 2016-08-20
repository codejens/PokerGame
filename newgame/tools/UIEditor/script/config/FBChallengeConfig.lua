-- FBChallengeConfig.lua
-- created by Little White on 2014-8-29
-- 副本挑战配置

FBChallengeConfig = {}

require "../data/fuben_challenge_config"

function FBChallengeConfig:get_challenge_fuben_info()

	local fuben_temp =  fuben_challenge_config or {}

	local function camp_func( element_1, element_2 )
		if element_1.level < element_2.level then
            return true
		end
		return false
	end

    table.sort( fuben_temp, camp_func )
    return fuben_temp
end

