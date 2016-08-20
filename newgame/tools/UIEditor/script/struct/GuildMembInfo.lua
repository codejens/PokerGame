-- GuildMembInfo.lua
-- created by lyl on 2012-12-26
-- 仙宗成员信息数据结构

super_class.GuildMembInfo()

function GuildMembInfo:__init( pack )
	if pack ~= nil then
		self.ActorId		   = pack:readInt()		     -- 玩家id
		self.contribution	   = pack:readInt()		     -- 贡献值
		self.all_contribution  = pack:readInt()	         -- 总贡献
		self.sex               = pack:readByte()	     -- 性别 
		self.level	           = pack:readByte()		 -- 等级 
		self.job	           = pack:readByte()		 -- 职业 
		self.standing          = pack:readByte()		 -- 地位
		self.last_online_time  = pack:readUInt()         -- 最后在线时间（单位：秒） 
        self.ty_get_ward       = pack:readInt()			 -- 天元之战领奖设置 
        self.guild_change_time = pack:readInt()		     -- 帮派位置变更时记录时间 
        self.qqvip		       = pack:readInt()			 -- 蓝黄钻信息 
        self.if_show_chat      = pack:readInt()			 -- 是否显示聊天框
        self.head_icon_id      = pack:readByte()		 -- 玩家的头像ID
        self.fight_value	   = pack:readInt()			 -- 战斗力
        self.offline_time 	   = pack:readInt()			 -- 玩家离线时间
        self.name              = pack:readString()		 -- 角色名称 
		print("self.offline_time ",self.offline_time ,self.name, self.fight_value)
	end
end