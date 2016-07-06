cocosActionHelper = {}
local _action_helper = helpers.ActionHelpers

function cocosActionHelper.moveTo(sx, sy,  tx,  ty,  time, tag)
	return _action_helper:moveTo(sx, sy,  tx,  ty,  time, tag)
end

function cocosActionHelper.removeWhenTimelineFinish( action,  delay,  fadeOut)
	return _action_helper:removeWhenTimelineFinish( action,  delay,  fadeOut)
end

function cocosActionHelper.removeWhenActionFinish( action,  delay,  fadeOut)
	return _action_helper:removeWhenTimelineFinish( action,  delay,  fadeOut)
end

function cocosActionHelper.delayRemove( delay)
	return _action_helper:delayRemove( delay)
end

function cocosActionHelper.delayFadoutRemove( delay,  fadeOut)
	return _action_helper:delayFadoutRemove( delay,  fadeOut)
end

function cocosActionHelper.delayEaseInFadoutRemove( delay,  ease,  fadeOut)
	return _action_helper:delayEaseInFadoutRemove( delay,  ease,  fadeOut)
end

function cocosActionHelper.delayEaseOutFadoutRemove( delay,  ease,  fadeOut)
	return _action_helper:delayEaseOutFadoutRemove( delay,  ease,  fadeOut)
end

function cocosActionHelper.delayFadeIn( delay,  fadeIn)
	return _action_helper:delayFadeIn( delay,  fadeIn)
end

function cocosActionHelper.delayEaseInFadeIn( delay,  ease,  fadeIn)
	return _action_helper:delayEaseInFadeIn( delay,  ease,  fadeIn)
end

function cocosActionHelper.delayEaseOutFadeIn( delay,  ease,  fadeIn)
	return _action_helper:delayEaseOutFadeIn( delay,  ease,  fadeIn)
end

function cocosActionHelper.easeElasticInScale( sx,  sy,  time,  ease)
	return _action_helper:easeElasticInScale( sx,  sy,  time,  ease)
end

function cocosActionHelper.easeElasticOutScale( sx,  sy,  time,  ease)
	return _action_helper:easeElasticOutScale( sx,  sy,  time,  ease)
end