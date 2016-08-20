-- MountsStruct.lua
-- created by fjh on 2012-12-14
-- 坐骑信息结构

super_class.MountsStruct()

function MountsStruct:__init( id, pack )
	----modify by hjh 
	----用于查看他人坐骑信息功能
	self.player_id = id
	--self.player_id 		= pack:readInt();		--坐骑的用户id
	self.level 			= pack:readInt();			--坐骑等级
	self.jieji			= pack:readInt();			--坐骑阶级
	self.jiezhi			= pack:readInt();			--坐骑阶值
	self.fight			= pack:readInt();			--坐骑战斗力
	self.lingxi  		= pack:readInt();			--坐骑灵犀值,整数值，比如120，表示灵犀值是120%

	self.model_id		= pack:readInt();			--坐骑的外观id
	self.uplevel_cdtime = pack:readInt();			--坐骑升级的cd时间
	self.cd_endTime		= GameStateManager:get_total_seconds()+self.uplevel_cdtime;	--cd的终止时间

	self.att_hp 		= pack:readInt();			--基础属性 生命
	self.att_attack		= pack:readInt();			--基础属性 攻击
	self.att_md			= pack:readInt();			--基础属性 法防
	self.att_wd			= pack:readInt();			--基础属性 物防
	self.att_bj			= pack:readInt();			--基础属性 暴击

	self.zizhi_hp_exten 		= pack:readInt();	--资质属性 生命
	self.zizhi_attack_exten		= pack:readInt();	--资质属性 攻击
	self.zizhi_md_exten			= pack:readInt();	--资质属性 法防
	self.zizhi_wd_exten			= pack:readInt();	--资质属性 物防
	self.zizhi_bj_exten			= pack:readInt();	--资质属性 暴击

	--坐骑装备
	self.mounts_equ 		= {} --坐骑装备集合
	local mounts_equ_count 	= pack:readInt()
	for i=1,mounts_equ_count do
		self.mounts_equ[i] 	= UserItem(pack)
	end
	-- 当前特殊坐骑外观
	self.show_id			= pack:readInt() --当前特殊坐骑化形的外观
	self.spc_mounts 		= {} --拥有的特殊坐骑集合
	local spc_mounts_count 	= pack:readInt()
	for i=1,spc_mounts_count do
		self.spc_mounts[i] 	= {}
		self.spc_mounts[i].id 		= pack:readInt()  -- int 外观id
		self.spc_mounts[i].dead_line= pack:readUInt() -- unsigned int 道具结束时间
	end
end
