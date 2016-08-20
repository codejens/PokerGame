-- XDHXWStruct.lua
-- create by hcl on 2013-8-10
-- 仙道会仙王的数据

super_class.XDHXWStruct()

function XDHXWStruct:__init( pack )	
	self.id = pack:readInt();				--玩家id
	self.name = pack:readString();			--玩家名字
	self.camp = pack:readByte();			--玩家职业
	self.guild_name = pack:readString();	--玩家仙宗名
	if self.guild_name == "" then
		self.guild_name = "无"
	end
	self.fight_value = pack:readInt();		--玩家战斗力
	self.pet_value = pack:readInt();		--宠物战斗力
	self.time = pack:readUInt();			--时间
	print("XDHXWStruct",self.name,self.camp,self.guild_name,self.fight_value,self.pet_value,self.time)
end