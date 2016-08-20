-- GuildApplierInfo.lua
-- created by lyl on 2012-12-26
-- 仙宗申请者信息数据结构

super_class.GuildApplierInfo()

function GuildApplierInfo:__init( pack )
	if pack ~= nil then
		self.actorId	   = pack:readInt()		     -- 申请者id
		self.sex	       = pack:readByte()		 -- 性别
		self.level   	   = pack:readInt()		     -- 等级
		self.job           = pack:readByte()	     -- 职业
		self.attack        = pack:readInt()	         -- 战斗力 
		self.qqvip		   = pack:readInt()			 -- QQVIP
		self.name	       = pack:readString()		 -- 名称 
	end
end