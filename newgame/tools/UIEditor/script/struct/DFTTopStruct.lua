-- DFTTopStruct.lua
-- create by hcl on 2013-1-14
-- 宠物的数据结构

super_class.DFTTopStruct()

function DFTTopStruct:__init( pack )
	self.top		 = pack:readInt();		--排行
	self.dft_id		 = pack:readInt();		--id
	self.name		 = pack:readString();	--名字
	self.sex		 = pack:readInt();		--性别
	self.job		 = pack:readInt();		--职业
	self.clan		 = pack:readInt();		--阵营
	self.xz			 = pack:readString();		--仙宗
	self.lv			 = pack:readInt();		--等级
	self.fight_value = pack:readInt();		--战斗力
	self.is_up		 = pack:readByte();		--升降趋势 (0表示降,1表示不变,2表示升) 
	self.body 		 = pack:readInt();		-- 模型
	self.weapon		 = pack:readInt();		-- 武器
	self.wing		 = pack:readInt();
end