--动作的反应时间
require '../data/action_effects/action'
require "../data/action_effects/saction"

JUMP_PREPARE_ACTION_T = 0.2     --起跳动作持续时间
JUMPING_ACTION_T = 0.5          --跳跃中持续时间
JUMPING_LAND_ACTION_T = 0.2     --着地时间
JUMPING_DEFAULT_HEIGHT = 120	  --默认跳跃高度

EntityAnimationTypes =
{
	eAnimationAvatar  = 0,
	eAnimationMount   = 1,
	eAnimationMonster = 2,
	eAnimationPet     = 3,
	eAnimationNPC     = 4,
	eAnimationPlant   = 5,
	eAnimationEffect  = 6,
	eAnimationXianNv  = 8,
}
--目标被打出受击状态的概率，根据目标自身的状态
--待机就是100/100会被打出受中
-- local _canStruckActions = 
-- {
-- 	[ZX_ACTION_IDLE]  			= 100,		--// 常规待机动作，也是常规序列帧动画第一个动作定义
-- 	[ZX_ACTION_MOVE]  			= 100,		--// 移动动作 
-- 	[ZX_ACTION_HIT]  			= 50,		--// 第一个攻击动作
-- 	[ZX_ACTION_HIT_2] 			= 50,		--// 第二个攻击动作
-- 	[ZX_ACTION_DIE]				= 0, 		--// 死亡动作
-- 	[ZX_ACTION_STRUCK]			= 0,		--// 受击动作
-- 	[ZX_ACTION_PRACTICE]		= 100,		--// 打坐动作
-- 	[ZX_ACTION_ON_HORSE_IDLE] 	= 0,		--// 骑乘待机动作
-- 	[ZX_ACTION_ON_HORSE_MOVE] 	= 0,	    --// 骑乘移动动作
-- 	[ZX_ACTION_HIT_3] 			= 50,		--攻击动作3
-- 	[ZX_ACTION_STRUCK_2] 		= 0			--// 受击动作2
-- }

-- --是否受中动作
-- local _isStruckDict =
-- {
-- 	[ZX_ACTION_STRUCK] = true,
-- 	[ZX_ACTION_STRUCK_2] = true,
-- }

local _struckEvents = {}

EntityActionConfig = {}

local _math_random = math.random
function EntityActionConfig.init()
	local act = lh_npc_action_config
	local _mgr = ZXEntityMgr:sharedManager()
	local _frame = CVectorUC()
	local _delays = CVectorUC()
	for i, info in ipairs(act) do
		_frame:clear()
		local fdata = info.frames
		local eType = info.eType
		for ii, fid in ipairs(fdata) do
			_frame:push_back(fid)
		end
		local delay = info.duration / #fdata
		_mgr:registerActionWithArray(info.eType,info.action,_frame,delay,false,_delays);
	end

	
	act = saction
	for i, info in ipairs(act) do
		_frame:clear()
		local fdata = info.frames
		local eType = info.eType
		for ii, fid in ipairs(fdata) do
			_frame:push_back(fid)
		end
		local delay = info.duration / #fdata

		local more_delay = info.more_delay or false
		
		_delays:clear()
		if more_delay then
			local ddate = info.delays or {}
			local sum = 0
			for ii, did in ipairs(ddate) do
				sum = did + sum
				did = sum/info.duration*100
				_delays:push_back(did)
			end
		end
		_mgr:registerActionWithArray(info.eType,info.action,_frame,delay,more_delay,_delays);

		_struckEvents[info.action] = info.hit
	end

	--提前加载josn 目前解析一个要0.5秒 明显卡顿
	local path = {
	"frame/human/0/01000","frame/human/0/02000","frame/human/0/03100","frame/human/0/04100",
	}
	for i=1,4 do
		ZXLuaUtils:loadFrameModifier(path[i])
	end
	

end

function EntityActionConfig.getStruckEvent(action_id)
	return _struckEvents[action_id]
end

function EntityActionConfig.canStruck(action_id)
	local per =  _canStruckActions[action_id] or 0
	if per == 0 then
		return false
	end
	return _math_random(0,100) > per
end

function EntityActionConfig.isStruck(action_id)
	return _isStruckDict[action_id]
end


EntityActionConfig.init()