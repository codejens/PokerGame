-- FuBenStruct.lua
-- create by hcl on 2013-2-18
-- 副本的结构

-- 补充副本模式的类型定义：
-- enum tagFubenMode
-- {
	
-- 	fmCommon = 0,	//普通场景
-- 	fmSingle = 1,	//单人副本
-- 	fmTeam = 2,		//普通队伍副本
-- 	fmTeamHero = 3,	//英雄队伍副本
-- 	fmGroup = 4,	//普通团队副本
-- 	fmGroupHero = 5,	//英雄团队副本
-- 	fmMaxCount = fmGroupHero,
-- }; 

super_class.FuBenStruct()

function FuBenStruct:__init( pack )
	if ( pack ) then
		self.fuben_id 	= pack:readWord();
		self.count 		= pack:readWord();
		self.vip_add 	= pack:readWord();
		--print("fuben_id = ",self.fuben_id,"self.count = ",self.count,"self.vip_add",self.vip_add);
	end
end