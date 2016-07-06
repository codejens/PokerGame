--EffectConfig.lua

EffectConfig = {}

function EffectConfig:get_effect_by_id( id )
	require "res.data.effect_config"
	return effect_config[id]
end