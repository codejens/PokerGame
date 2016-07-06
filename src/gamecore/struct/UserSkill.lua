--UserSkill.lua

UserSkill = simple_class()

function UserSkill:__init( pack )
	
 	self.skill_id = pack:readWord( ) 
 	self.skill_level = 	pack:readByte( )
 	self.miji_id = pack:readWord( ) 
 	self.skill_cd = pack:readInt( )
 	self.skill_exp = pack:readInt( )
 	self.miji_time = pack:readUInt( ) 
 	self.skill_stop  =  pack:readByte( )
 	print(self.skill_id,self.skill_level,self.miji_id,self.skill_cd,self.skill_exp,self.miji_time,self.skill_stop)
 --[[
 	WORD: 技能ID
	BYTE: 技能的等级
	WORD: 技能使用的秘籍的ID 
	int : 技能的CD或者经验 
	int :技能的经验 
	unsigned int: 秘籍的过期时间 
	BYTE: 技能是否被停用了，1表示停用，0表示正常 
]]
end