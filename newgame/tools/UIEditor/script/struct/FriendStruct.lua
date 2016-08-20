-- FriendStruct.lua
-- create by HJH on 2013-2-21
-- 好友的数据结构

super_class.FriendStruct()

function FriendStruct:__init( pack )
	self.roleId = pack:readInt()
	self.qqVip = pack:readInt()
	self.friendly = pack:readUInt()
	self.face = pack:readByte()
	self.ttype = pack:readByte()
	self.level = pack:readByte()
	self.camp = pack:readByte()
	self.job = pack:readByte()
	self.sex = pack:readByte()
	self.online = pack:readByte()
	pack:readByte()
	self.roleName = pack:readString()
	--print("id,qqvip,friendly,face,type,level,camp,job,sex,online,name",self.roleId,self.qqVip,self.friendly,self.face,self.ttype,self.level,self.camp,self.job,self.sex,self.online,self.roleName)
	-- if(type==SocialModel.GROUP_ENEMY)
	-- {
	-- 	kill = friendly&0xffff;
	-- 	killed = friendly>>16; 
	-- }
end

---------------------------------------
super_class.FriendCelerbrateInfo()

function FriendCelerbrateInfo:__init( pack )
	self.role_id = pack:readInt()
	self.level = pack:readInt()
	self.num = pack:readInt()
	self.exp = pack:readInt()
	self.name = pack:readString()
end