-- filename: UserWingSkill.lua
-- author: created by fanglilian on 2012-12-14
-- function: 翅膀技能数据结构

super_class.UserWingSkill();

function UserWingSkill:__init(skillIndex)
	self.config = nil;		-- WingSkillConfig
	self.level = 0;			-- (int)
	self.exp = 0;			-- 熟练度(int)
	self.index = 0;			-- (int)
end