-- ActionCombatSpell.lua
-- created by aXing on 2013-1-22
-- 处理主角战斗技能动作

-- require "action/ActionSpell"
-- 战斗技能
super_class.ActionCombatSpell(ActionSpell)

function ActionCombatSpell:__init( skill, target_id )
	self.priority = ActionConfig.PRIORITY_THREE
end