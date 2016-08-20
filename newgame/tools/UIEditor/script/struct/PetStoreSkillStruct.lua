-- PetStoreSkillStruct.lua
-- create by hcl on 2012-12-10
-- 兽魂仓库技能结构

super_class.PetStoreSkillStruct()

function PetStoreSkillStruct:__init( pack,_skill_index,_skill_id,_skill_lv ,_skill_keyin)

	if pack ~= nil then 
		self.skill_index = pack:readInt64(); 	-- 序列号
		self.skill_id = pack:readInt();			-- 技能id
		self.skill_lv = pack:readInt();			-- 技能等级
		self.skill_keyin = 1;
		--print("PetStoreSkillStruct:skill_id = " .. self.skill_id .. " skill_lv = " .. self.skill_lv .. " skill_index = " .. self.skill_index );
	else
		self.skill_index = _skill_index; 	-- 序列号
		self.skill_id = _skill_id;			-- 技能id
		self.skill_lv = _skill_lv;			-- 技能等级
		self.skill_keyin = _skill_keyin;
	end

end










