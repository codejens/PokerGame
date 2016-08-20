-- HLDUserStruct.lua
-- created by hcl on 2013-9-16
-- 欢乐斗用户结构

super_class.HLDUserStruct()

function HLDUserStruct:__init( pack )
	self.id = pack:readInt();			--角色id
	self.name = pack:readString();		--角色名
	self.level = pack:readInt();		--角色等级
	self.job  = pack:readInt();			--职业id
	self.guild_id = pack:readInt();		--帮派id
	self.guild_name = pack:readString();		--帮派名
	self.camp = pack:readInt();			--阵营
	self.sex = pack:readInt();			--性别
	self.faceid = pack:readInt();		--头像id
	self.catchTime = pack:readInt();	--被抓捕的时间
	self.catchLevel = pack:readInt();	--被抓捕时的等级
	self.catchRankNum = pack:readInt();	--被抓捕时的竞技场排名
	self.curExp = pack:readInt();		--当前已产生的经验
	self.interactiveCD = pack:readInt();	--互动cd时间
	self.slaveStatus = pack:readInt();	--身份状态
	self.baseExp = pack:readInt();		--苦工每秒钟产生的经验的基数
	
end