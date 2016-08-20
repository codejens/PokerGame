-- UserSkill.lua
-- created by lyl on 2012-12-1
-- 玩家技能模型数据结构

super_class.UserSkill()

function UserSkill:__init( pack )
	if pack ~= nil then
		self.id		   = pack:readWord()				-- 技能id
		self.level	   = pack:readByte()			    -- 技能的等级
		self.secret_id = pack:readWord()			    -- 技能使用的秘籍的ID 
		self.cd	       = pack:readInt()				    -- 技能的当前CD或者经验 
		self.exp	   = pack:readInt()				    -- 技能的经验    (无用)
		self.dead_time = pack:readUInt()			    -- 秘籍的过期时间
		self.ifStop	   = pack:readByte()				-- 技能是否被停用了，1表示停用，0表示正常
		local static_info = SkillConfig:get_skill_by_id( self.id )
		self.max_cd	   = static_info.skillSubLevel[ self.level ].cooldownTime/1000			--技能的cd时间 ,单位毫秒
		print("UserSkill:18:self.id, cd = ",self.id,self.cd,self.max_cd	);
	end
end
