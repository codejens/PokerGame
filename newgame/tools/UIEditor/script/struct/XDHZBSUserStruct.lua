-- XDHZBSUserStruct.lua
-- create by hcl on 2013-8-10
-- 仙道会争霸赛玩家数据

super_class.XDHZBSUserStruct()

function XDHZBSUserStruct:__init( pack )
	self.id = pack:readInt();				--玩家id
	self.name = pack:readString();			--玩家名
	self.sex = pack:readChar();				--玩家性别
	self.head = pack:readShort();			--玩家头像
	self.fight_value = pack:readInt();		--玩家战斗力
	self.value = pack:readInt();			--身价
	print("争霸赛玩家数据",self.name,self.value);
end
