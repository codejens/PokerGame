-- XDHUserStruct.lua
-- create by hcl on 2013-8-10
-- 仙道会玩家的数据

super_class.XDHUserStruct()

XDHUserStruct.TYPE_ZYS = 1;		--仙道会自由赛玩家数据
XDHUserStruct.TYPE_16Q = 2;		--仙道会上届16强玩家数据

function XDHUserStruct:__init( pack ,_type)
	self.top = pack:readInt();
	self.name = pack:readString();
	self.camp = pack:readByte();
	self.score = pack:readInt();
	self.fight_value = pack:readInt();
	self.match_num = pack:readInt();
	self.victory_num = pack:readInt();
	if ( _type == XDHUserStruct.TYPE_16Q ) then
		self.guild_name = pack:readString();
		print("self.guild_name",self.guild_name);
		if self.guild_name == "" then
			self.guild_name = "无";
		end
	end
end