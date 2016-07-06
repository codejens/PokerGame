-- EntityConfig.lua
-- created by aXing on 2012-12-3
-- 实体属性配置表

-- super_class.EntityConfig()
EntityConfig = {}

EntityConfig.PlayerAvatar = "PlayerAvatar"
EntityConfig.PlayerPet = "PlayerPet"
EntityConfig.Monster = "Monster"

EntityConfig.TYPE_PLAYER_PET = -2
EntityConfig.TYPE_PLAYER_AVATAR = -1
EntityConfig.TYPE_AVATAR = 0
EntityConfig.TYPE_MONSTER = 1
EntityConfig.TYPE_NPC = 2
EntityConfig.TYPE_MOVING_NPC = 3
EntityConfig.TYPE_PET = 4
EntityConfig.TYPE_TELEPORT = 9
-- 实体类型的索引表
EntityConfig.ENTITY_TYPE = {
	-- 生物类
	[-3] = "XianNv",				-- 护送仙女里面的仙女
	[-2] = "PlayerPet",				-- 玩家的宠物
	[-1] = EntityConfig.PlayerAvatar,			-- 主玩家
	[0] = "Avatar",					-- 玩家
	"Monster",						-- 怪物
	"NPC",							-- npc
	"MovingNPC",					-- 巡逻的npc
	"Pet",							-- 宠物
	-- 非生物
	"Totem",						-- 图腾
	"Mine",							-- 矿物，采集对象
	"Defender",						-- 防御措施
	--"Monster",
	"Plant",						-- 植物，采集对象
	-- 特效类
	"Teleport",						-- 传送门
	"Building",						-- 建筑
	"Effect",						-- 特效
	-- 其他
	"Collectable",					-- 采集怪
	"DisplayMonster",				-- 显示怪，如炸药包
	"",--/** 14-人形怪 **/
	"",	--/** 15-分身宠物 **/
	-- 拾取物品
	[99] = "DropItem",				-- 拾取物品
}



--[[
选择怪物值：ff0000
选择角色值：fff000
选择NPC值：38ff33
]]
EntityConfig.SELECT_COLOR_ENTITY =     {
	[EntityConfig.TYPE_AVATAR] =  { 255, 255, 0 , 45 },
	[EntityConfig.TYPE_MONSTER] = { 255, 0, 0 , 45 },
	[EntityConfig.TYPE_NPC] = 	  { 56, 255, 51 , 45 },
	[EntityConfig.TYPE_MOVING_NPC] =  { 56, 255, 51 , 45 }
}
EntityConfig.SELECT_COLOR_DEFAULT =  { 128, 255, 255 , 45 }

-- 实体状态标示位
EntityConfig.ACTOR_STATE_STAND 			= 0x00000001 	-- 1 : 站立
EntityConfig.ACTOR_STATE_MOVE			= 0x00000002	-- 2 : 移动
EntityConfig.ACTOR_STATE_RIDE			= 0x00000004	-- 3 : 坐骑
EntityConfig.ACTOR_STATE_ZANZEN			= 0x00000008	-- 4 : 打坐
EntityConfig.ACTOR_STATE_GATHER			= 0x00000010	-- 5 : 采集
EntityConfig.ACTOR_STATE_SING			= 0x00000020	-- 6 : 吟唱
EntityConfig.ACTOR_STATE_BATTLE			= 0x00000040	-- 7 : 战斗
EntityConfig.ACTOR_STATE_DEATH			= 0x00000080	-- 8 : 死亡
EntityConfig.ACTOR_STATE_MOVE_FORBID	= 0x00000100	-- 9 : 禁止移动
EntityConfig.ACTOR_STATE_DIZZY			= 0x00000200	-- 10: 晕眩
EntityConfig.ACTOR_STATE_AUTO_BATTLE	= 0x00000400	-- 11: 挂机
EntityConfig.ACTOR_STATE_RETURN_BURN	= 0x00000800	-- 12: 回归(仅用于怪物)
EntityConfig.ACTOR_STATE_DISABLE_SKILLCD= 0x00001000	-- 13: 禁用技能cd(仅用于开发阶段)
EntityConfig.ACTOR_STATE_CHALLENGE		= 0x00002000	-- 14: 擂台
EntityConfig.ACTOR_STATE_TRAFFIC		= 0x00004000	-- 15: 在交通工具上
EntityConfig.ACTOR_STATE_COUPLE_ZANZEN	= 0x00008000	-- 16: 双修
EntityConfig.ACTOR_STATE_ATTACK_FORBIDEN= 0x00010000	-- 17: 禁止被攻击
EntityConfig.ACTOR_STATE_SHOW_BOSS_NAME	= 0x00020000	-- 18: boss归属者
EntityConfig.ACTOR_STATE_HIDE_TITLE		= 0x00040000	-- 19: 隐藏称号
EntityConfig.ACTOR_STATE_START_FLIGHT	= 0x00080000	-- 20: 开篇飞行
EntityConfig.ACTOR_STATE_CASTELLAN		= 0x00100000	-- 21: 玄都主
EntityConfig.ACTOR_STATE_PROTECTION		= 0x00200000	-- 22: 护送
EntityConfig.ACTOR_STATE_PK_STATE		= 0x00400000	-- 23: pk状态
EntityConfig.ACTOR_STATE_PET 			= 0x00800000	-- 24: 宠物，主要用在怪物身上，用于区分是否宠物
EntityConfig.ACTOR_STATE_SWIMMING		= 0x02000000	-- 26: 游泳
	

-- 实体属性的索引表
EntityConfig.ACTOR_PROPERTY = {
			
	[0] = {"id", "uint",},								-- 实体id
	{"x", "int",},										-- 实体坐标X
	{"y", "int",},										-- 实体坐标Y
	{"body", "int",},									-- 模型id
	{"face", "uint",},									-- 头像id
	{"dir", "int",},									-- 实体的朝向
	{"level", "uint",},									-- 等级
	{"hp", "uint",},									-- 当前血量
	{"mp", "uint",},									-- 当前蓝量
	{"moveSpeed", "uint",},								-- 移动速度，如果是0，表示不能移动
	{"maxHp", "uint",},									-- 最大血量
	{"maxMp", "uint",},									-- 最大蓝量
	{"outAttack", "int",},								-- 物理攻击
	{"outDefence", "int",},								-- 物理防御
	{"defCriticalStrikes", "int"},						-- 抗暴击值
	{"allAttack", "int"},								-- 所有攻击
	{"subDef", "int",},									-- 无视防御
	{"innerAttack", "int",},							-- 法术攻击
	{"innerDefence", "int",},							-- 法术防御
	{"criticalStrikes", "int",},						-- 暴击值
	{"dodge", "int",},									-- 闪避值
	{"hit",	 "int",},									-- 命中值
	{"attackAppend", "uint",},							-- 伤害追加
	{"hpRenew", "float",},								-- HP恢复
	{"mpRenew",	"float",},								-- MP恢复
	{"attackSpeed", "uint",},							-- 攻击速度
	{"inAttackDamageAdd", "int",},						-- 承受法术伤害的数值提高
	{"outAttackDamageAdd", "int",},						-- 承受物理伤害的数值提高
	{"state", "uint",},									-- 实体当前的状态，如打坐等
	{"baseMaxHp", "uint",},								-- 基础的最大血量，等级带来的MaxHp，不包括buff，装备等附带
	{"baseMaxMp", "uint",},								-- 基础的最大蓝量，等级带来的MaxMp，不包括buff，装备等附带
	{"weapon", "int",},									-- 武器外观
	{"mount", "int",},									-- 坐骑外观
	{"attackSprite", "int",},							-- 攻击灵性	(★潜规则：宠物为称号id，分高低位表示两个称号)
	{"defenceSprite", "uint",},							-- 防御灵性
	{"hpStore", "uint",},								-- Hp存量 (★潜规则：对Monster来说是排行榜称号)
	{"mpStore", "uint",},								-- Mp存量
	{"spirit", "uint",},								-- 保留，暂时没用
	{"pkMode", "int",},									-- pk模式
	{"pet", "int",},									-- 低两位字节为宠物id
	{"wing", "uint",},									-- 翅膀
	{"jumpPowerRenewRate", "int",},						-- 跳跃体力的每5秒回复多少点
	{"maxXiuwei", "int",},								-- 玩家的最大修为
	{"xiuweiRenewRate", "int",},						-- 玩家修为的恢复速度
	{"sex", "uint",},									-- 性别
	{"job", "uint",},									-- 职业
	{"expL", "uint",},									-- 经验低位
	{"expH", "uint",},									-- 经验高位
	{"pkValue", "int",},								-- PK值
	{"bagVolumn", "int",},								-- 背包格子数量
	{"zhanhun", "int",},								-- 战魂值
	{"bindYinliang", "uint",},							-- 绑定银两
	{"yinliang", "uint",},								-- 银两
	{"bindYuanbao", "uint",},							-- 绑定元宝
	{"yuanbao", "uint",},								-- 元宝
	{"renown", "uint",},								-- 声望
	{"charm", "uint",},									-- 魅力值
	{"gemSlotCount", "uint",},							-- 宝物开通的槽位的数目
	{"lilian", "uint",},								-- 历练
	{"guildId", "uint",},								-- 帮派的id
	{"teamId", "uint",},								-- 队伍id
	{"socialMask", "uint",},							-- 社会关系的mask，是一些bit位
	{"guildExp", "uint",},								-- 帮派贡献度
	{"practiceRemain", "uint",},						-- 今天剩余打坐时间
	{"sysOpenState", "int",},							-- 功能系统开启状态，按位标示
	{"jumpPower", "uint",},								-- 跳跃体力，用于跳跃
	{"defaultSkillId", "uint",},						-- 默认技能id
	{"maxJumpPower", "int",},							-- 最大跳跃体力，用于跳跃
	{"maxExpL", "uint",},								-- 当前等级最大的经验低位
	{"maxExpH", "uint",},								-- 当前等级最大的经验高位
	{"innerCriticalStrikesDamage", "float",},			-- 内功暴击伤害，(已废)
	{"criticalStrikesDamage", "float",},				-- 暴击的伤害比率，即会心，比如1.5
	{"expRate", "float",},								-- 玩家经验的增长的倍率，默认为1倍
	{"storeVolumn", "int",},							-- 仓库打开格子数量
	{"anger", "int",},									-- 怒气值
	{"lingQi", "uint",},								-- 灵气值
	{"achievePoint", "int",},							-- 玩家的成就点
	{"campCountribution", "int",},						-- 阵营的贡献度
	{"vip", "uint",},									-- VIP
	{"vipRExpiryTime", "uint",},						-- 红钻到期时间
	{"vipBExpiryTime", "uint",},						-- 蓝钻到期时间
	{"vipYExpiryTime", "uint",},						-- 黄钻到期时间
	{"vipFlag", "int",},								-- VIP标识
	{"camp", "uint",},									-- 玩家阵营1 逍遥，2星辰， 3逸仙
	{"petSlotCount", "uint",},							-- 宠物的开启的槽位的个数
	{"honor", "int"},									-- 荣誉值
	{"killTotal","int",}, --总杀戮值
	{"killWeek","int",}, --周杀戮值
	{"prestige","int",}, --总威望值
	{"prestigeRemain","int",}, --//可兑换的威望值
	{"baoliu1","int",}, --////低16位表示群攻技能加成 高16位表示全身强化的特效
	{"strongLvl","int",}, --//高16位表示玩家历史最高全身强化等级
	{"totalOnlineTime","int",}, --//总的在线时长
	{"baoliu2","int",}, --//93
	{"baoliu3","int",}, --//94
	{"shenbingFightValue","int",}, --/-/95神兵总战斗力
	{"baoliu4","int",}, --//96 	//96-100保留备用
	{"baoliu5","int",}, --//97
	{"baoliu6","int",}, --//98
	{"baoliu7","int",}, --//99
	{"baoliu8","int",}, --//100
	{"gatherValue", "uint",},							-- 101采集体力
	{"durKillTimes", "uint",},							-- 连杀的次数
	{"nudeScore", "uint",},								-- /角色当天获取的经验值
	{"fightValue", "uint",},							-- 战斗力
	{"maxRenown", "uint",},								-- 最大声望
	{"campPost", "uint",},								-- 阵营职位id
	{"headTitle", "int",},								-- 玩家的头衔,用于头衔系统，按位表示玩家是否有这个头衔，默认为0
	{"headwear", "int",},								-- //帮派神兽等级
	{"practiceEffect", "int",},							-- //玩家打坐的时候的特效
	{"equipScore", "uint",},							-- 玩家的装备的总分
	{"baoliu9","int",}, --//111
	{"baoliu10","int",}, --//112//111-112保留
	{"formation","int",}, --113;//阵型战使用，阵型类别
	{"baoliu11","float",},--//114/**114-疯狂挂机*/
	
	{"baoliu12","int",},
	{"baoliu13","int",},
	{"baoliu14","int",},
	{"baoliu15","int",}, 
	
}

-- 检查实体是否宠物
function EntityConfig:is_pet( entity_type )
	return EntityConfig.ENTITY_TYPE[entity_type] == "Pet"
end

-- 检查实体是否怪物
function EntityConfig:is_monster( entity_type )
	local type_str = EntityConfig.ENTITY_TYPE[entity_type]
	return (type_str == "Monster") or (type_str == "Collectable") or (type_str == "DisplayMonster")
end

-- 检查实体是否npc
function EntityConfig:is_npc( entity_type )
	local type_str = EntityConfig.ENTITY_TYPE[entity_type]
	return (type_str == "NPC") or (type_str == "MovingNPC")
end

-- 检查实体是否玩家
function EntityConfig:is_player( entity_type )
	local type_str = EntityConfig.ENTITY_TYPE[entity_type]
	return (type_str == "Avatar") or (type_str == "PlayerAvatar")
end

--获取动作配置
function EntityConfig:get_action_json( entity_type )
	require "res.data.entity_action_json"
	local type_str = EntityConfig.ENTITY_TYPE[entity_type]
	return entity_action[type_str]
end

--获取资源配置
function EntityConfig:get_body_path( entity_type,body_id )
	require "res.data.entity_action_json"

	local type_str = EntityConfig.ENTITY_TYPE[entity_type]
		print("entity_type",entity_type,type_str)
	return entity_action.res[type_str]
end