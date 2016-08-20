-- DouFaTaiStruct.lua
-- create by hcl on 2013-1-14
-- 宠物的数据结构

super_class.DouFaTaiStruct()

function DouFaTaiStruct:__init( pack )
	self.dft_id		 = pack:readInt();		--id
	self.name		 = pack:readString();	--名字
	self.mode_id 	 = pack:readInt();		--模型ID
	self.head_id	 = pack:readWord();		--头像ID
	self.sex		 = pack:readInt();		--性别
	self.job		 = pack:readInt();		--职业
	self.clan		 = pack:readInt();		--阵营
	self.lv			 = pack:readInt();		--等级
	self.fight_value = pack:readInt();		--战斗力
	self.top		 = pack:readInt();		--排名
	self.money		 = pack:readInt();		--这期获得的仙币
	self.lilian		 = pack:readInt();		--这期获得的历练	 
end