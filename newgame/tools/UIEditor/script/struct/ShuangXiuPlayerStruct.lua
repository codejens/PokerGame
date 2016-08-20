-- ShuangXiuPlayerStruct.lua
-- create by hcl on 2013-2-16
-- 双修玩家的基本信息
super_class.ShuangXiuPlayerStruct()

function ShuangXiuPlayerStruct:__init( pack )
	self.player_id = pack:readInt();		-- 玩家id
	self.sex 	   = pack:readByte();		-- 性别
	self.job	   = pack:readByte();		-- 职业
	self.camp	   = pack:readByte();		-- 阵营id
	self.lv 	   = pack:readByte();		-- 等级
	self.head 	   = pack:readByte();		-- 头像
	self.team_id   = pack:readUInt();		-- 队伍id,没组队就是0
	self.is_dazuo  = pack:readByte();		-- 是否打坐中   0:非打坐,1:打坐
	self.name 	   = pack:readString();		-- 玩家的名字

end