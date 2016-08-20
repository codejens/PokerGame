-- UserGuildInfo.lua
-- created by lyl on 2012-1-7
-- 用户本人的仙宗(帮派)信息数据结构

super_class.UserGuildInfo()

function UserGuildInfo:__init( pack )
	if pack ~= nil then
        self.if_join_guild = pack:readByte()		 -- 0:加入帮派。 1：没有加入帮派
	    self.ranking = pack:readInt()		         -- 帮派排名
	    self.level = pack:readInt64()		             -- 帮派等级  // 等级4个字节，从低到高，分别代表4个建筑的等级
	    self.contribution = pack:readInt()		     -- 帮派贡献值
	    self.cont_add_up = pack:readInt()		     -- 帮派累计贡献值
	    self.standing = pack:readByte()		         -- 帮派地位
	    self.wang_id = pack:readInt()		         -- 帮主主id
	    self.icon = pack:readWord()		             -- 帮派图标
	    self.stone_num = pack:readInt()		         -- 灵石数量
	    self.memb_count = pack:readInt()		     -- 成员数量
	    self.menber_online_num = pack:readInt()		 -- 在线成员数量
	    self.if_can_welfare = pack:readInt()		 -- 能否领取福利。 0：不可以
	    self.wang_name = pack:readString()		     -- 帮主名称
	    self.guild_name = pack:readString()		     -- 帮派名字
	    self.notice = pack:readString()		         -- 公告
	    self.yy = pack:readString()		             -- yy语音
	    self.group_chat = pack:readString()		     -- 群聊
	    self.zhenying = pack:readByte()		     -- 阵营
	end
end
