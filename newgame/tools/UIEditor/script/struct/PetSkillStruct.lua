-- PetSkillStruct.lua
-- create by hcl on 2012-12-10
-- 宠物技能结构

super_class.PetSkillStruct()

function PetSkillStruct:__init( pack ,_skill_id,_skill_lv,_keyin)

	if pack ~= nil then 
		self.skill_id = pack:readInt(); 	-- 技能id
		self.skill_lv = pack:readInt();		-- 技能等级
		self.skill_cd = pack:readInt();		-- 技能cd时间
		self.skill_keyin = pack:readInt();	-- 技能是否刻印,0没有，1有
		--print("skill_id = " .. self.skill_id .. "skill_lv = " .. self.skill_lv .. "skill_cd = " .. self.skill_cd .. "skill_keyin = " ..self.skill_keyin);
	else
		self.skill_id = _skill_id;			-- 技能id
		self.skill_lv = _skill_lv;			-- 技能等级
		self.skill_keyin = _keyin;			-- 技能是否刻印,0没有，1有
		self.skill_cd = 	0;				-- cd时间
	end

	--self.skill_max_cd = PetConfig:get_pet_skill_cd( self.skill_id,self.skill_lv );
	-- 判断技能是不是被动
	-- 55 眩晕免疫,56,神力,57,强体,58,固体,59,塑身 63,荆棘护体64,培元,65,活泼,71,固若金汤,72沉默免疫被动技能
	if ( self.skill_id == 55 or self.skill_id == 56 or self.skill_id == 57 or self.skill_id == 58
		or self.skill_id == 59 or self.skill_id == 63 or self.skill_id == 64 or self.skill_id == 65
		or self.skill_id == 71 or self.skill_id == 72) then
		self.is_beidong = true;
	else
		self.is_beidong = false;
	end
	return self
end

























