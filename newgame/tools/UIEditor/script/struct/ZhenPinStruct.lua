-- ZhenPinStruct.lua
-- created by fjh on 2012-12-20
-- 珍品记录的信息结构

super_class.ZhenPinStruct()


function ZhenPinStruct:__init( pack )

	self.item_id 		= pack:readInt();	--物品id
	self.user_id 		= pack:readInt();	--用户id
	self.user_sex		= pack:readByte();	--用户性别
	self.user_job 		= pack:readByte();	--用户职业
	self.user_camp		= pack:readByte();	--用户阵营
	self.user_level		= pack:readByte();	--用户等级
	self.user_icon		= pack:readByte();	--用户头像
	self.user_team_id	= pack:readUInt();	--用户队伍id，没有队伍则为0
	self.user_name		= pack:readString();--用户名字
	
end