-- ActionPetSpell.lua
-- created by hcl on 2013-3-11
-- 宠物使用技能类

super_class.ActionPetSpell(ActionBase)

function ActionPetSpell:__init( skill_id, target_id ,entity)

end

-- 判断技能是否能做
function ActionPetSpell:can_do(  )

	return true
end

-- 技能准备
function ActionPetSpell:_on_start(  )

end

-- 动作失败
function ActionPetSpell:_on_fail(  )

end

-- 动作结束
function ActionPetSpell:_on_end(  )

end
