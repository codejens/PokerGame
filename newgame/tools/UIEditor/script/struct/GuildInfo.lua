-- GuildInfo.lua
-- created by lyl on 2012-12-26
-- 仙宗信息数据结构

super_class.GuildInfo()


function GuildInfo:__init( pack )
	if pack ~= nil then
		self.guild_id	   = pack:readInt()		     -- 帮派id
		self.ranking	   = pack:readInt()		     -- 排名
		self.level   	   = pack:readInt()		     -- 等级
		self.stone_count   = pack:readInt()	         -- 灵石数量
		self.camp          = pack:readInt()	         -- 阵营 
		self.memb_count	   = pack:readInt()		     -- 成员数量 
		self.icon	       = pack:readInt()		     -- 图标 
		self.qqvip		   = pack:readInt()			 -- QQVIP
		self.name          = pack:readString()		 -- 帮派名字
		self.wang_name     = pack:readString()       -- 帮主名字 
        self.notice        = pack:readString()	     -- 公告
	end
end