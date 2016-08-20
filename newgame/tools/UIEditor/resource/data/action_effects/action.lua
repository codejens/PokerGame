eOnEntityStopMove 		= 100
eOnEntityChangeBody 	= 101

ZX_ACTION_NONE  		= -1		--// 没有动作
ZX_ACTION_IDLE  		= 0		--// 常规待机动作，也是常规序列帧动画第一个动作定义
ZX_ACTION_MOVE  		= 1		--// 移动动作 
-- ZX_ACTION_HIT   		= 2		--// 向内砍攻击动作
-- ZX_ACTION_HIT_2 		= 3		--// 向外砍攻击动作
-- ZX_ACTION_DIE			= 4		--// 死亡动作
-- ZX_ACTION_STRUCK		= 5		--// 受击动作
-- ZX_ACTION_PRACTICE		= 6		--// 打坐动作
-- ZX_ACTION_ON_HORSE_IDLE = 7		--// 骑乘待机动作
-- ZX_ACTION_ON_HORSE_MOVE = 8	    --// 骑乘移动动作
-- ZX_ACTION_HIT_3 		= 9		--直刺攻击动作
-- ZX_ACTION_STRUCK_2 		= 10	--// 受击动作2
-- ZX_ACTION_CAST			= 11	--施法动作
-- ZX_JUMP_PREPARE         = 12	--跳跃准备
-- ZX_JUMPING				= 13	--跳跃中
-- ZX_JUMP_FINISH			= 14    --跳跃落地
-- ZX_JUMP_CAST			= 15    --施法动作，包括跳跃

-- ZX_Tishu_1            	= 16    --体术近程单体
-- ZX_Tishu_2            	= 17    --体术远程单体
-- ZX_Tishu_3            	= 18    --体术近程群体
-- ZX_Tishu_4            	= 19    --体术远程群体
-- ZX_Renshu_1            	= 20    --忍术近程单体
-- ZX_Renshu_2            	= 21    --忍术远程单体
-- ZX_Renshu_3            	= 22    --忍术近程群体
-- ZX_Renshu_4            	= 23    --忍术远程群体
-- ZX_Huanshu_1           	= 24    --幻术近程单体
-- ZX_Huanshu_2           	= 25    --幻术远程单体
-- ZX_Huanshu_3           	= 26    --幻术近程群体
-- ZX_Huanshu_4           	= 27    --幻术远程群体

-- ZX_ACTION_CAST1         = 28    --正面施放动作
-- ZX_ACTION_THROW         = 29    --扔动作
-- ZX_ACTION_CALL          = 30    --通灵召唤
-- ZX_ACTION_FLAIL         = 31    --甩刀动作
-- ZX_ACTION_PUSH          = 32    --掌推动作
-- ZX_ACTION_LEAP          = 33    --飞跃动作
-- ZX_NORMAL_HIT           = 34    --通用攻击
-- ZX_SHOW_HIT             = 35    --表演攻击
-- ZX_ACTION_SLEEP         = 36    --睡眠状态

-- ZX_BISHAI_REN	        = 37    --忍术必杀动作
-- ZX_BISHAI_TI	        = 38    --体术必杀动作
-- ZX_BISHAI_HUAN	        = 39    --幻术必杀动作

-- ZX_PET_HIT              = 40    --宠物攻击

-- HY_BIANSHEN_ZUOZHU      = 51    --变身技能——佐助-麒麟斩
-- HY_BIANSHEN_JINGYE      = 52    --变身技能——丼野-心灵控制
-- HY_BIANSHEN_BAI         = 53    --变身技能——白-飞银针
-- HY_BIANSHEN_ZAIBUZHAN   = 54    --变身技能——再不斩-水牢术
-- HY_BIANSHEN_KAKAXI      = 55    --变身技能——卡卡西-写轮眼
-- HY_BIANSHEN_MINGREN     = 56    --变身技能——名人-螺旋丸
-- ZX_ACTION_HIT_4 		= 60    --必杀动作

-- ZX_JUMP_PREPARE_ID 		= 70
-- ZX_JUMPING_ID			= 71    --施法动作，包括跳跃
-- ZX_JUMP_FINISH_ID		= 72    --跳跃落地

--[[
local eAnimationAvatar  = 0
local eAnimationMount   = 1
local eAnimationMonster = 2
local eAnimationPet     = 3
local eAnimationNPC     = 4
local eAnimationPlant   = 5
local eAnimationEffect  = 6
local eAnimationFabao	= 7
]]--

--玩家普通攻击动作循环
--根据上一次攻击动作决定本次攻击动作
-- avatar_normal_attack_loop = 
-- {
-- 	--上一次的动作      --本次动作，在队列中随机取出一个
-- 						--1/4机会重复动作 ZX_ACTION_HIT 3/4 ZX_ACTION_HIT_2
-- 	-- [ZX_ACTION_HIT] =   { ZX_ACTION_HIT },
-- 	[1] =   { 2},
-- 						--1/4机会重复动作 ZX_ACTION_HIT 3/4 ZX_ACTION_HIT_3
-- 	-- [ZX_ACTION_HIT_2] = { ZX_ACTION_HIT, ZX_ACTION_HIT_2, ZX_ACTION_HIT_3 },
-- 	[2] = { 3},
-- 						--1/2 ZX_ACTION_HIT， ZX_ACTION_HIT_2
-- 	-- [ZX_ACTION_HIT_3] = { ZX_ACTION_HIT_3 }
-- 	[3] = { 1}
-- }

-- avatar_shadow_normal_attack = 
-- {
-- 	[ZX_ACTION_HIT]   =  ZX_ACTION_HIT_3,
-- 	[ZX_ACTION_HIT_2] =  ZX_ACTION_HIT,
-- 	[ZX_ACTION_HIT_3] =  ZX_ACTION_HIT_2
-- }

--普攻动画时长统一
NORMAL_ATTACK_DUR = 0.75

--玩家坐骑状态对应的待机，移动动作
avatar_mount_action = 
{
	[1] = {14,15},
	[2] = {47,48},
	[3] = {30,31},
	[4] = {63,64},
}

--玩家待机，移动动作,死亡,受击
avatar_normal_action = 
{
	[1] = {13,6,4,5},
	[2] = {46,37,35,36},
	[3] = {62,54,52,53},
	[4] = {62,54,52,53},
}
--------------------------

--职业对应技能动作震屏的配置参数
--frequency:频率，表示1秒中震动多少次（例：1000表示1秒震动1000次）
--min_range:表示震动的最小范围（像素单位）
--max_range:表示震动的最大范围（像素单位）
--duration:持续震动次数(例：40表示持续震动40次后结束)
job_1_skill_3_action_shake = {frequency=800,min_range = 4,max_range = 20,duration=10}
job_1_skill_4_action_shake = {frequency=800,min_range = 5,max_range = 12,duration=20}

job_2_skill_2_action_shake = {frequency=1000,min_range = 5,max_range = 10,duration=8}
job_2_skill_4_action_shake = {frequency=800,min_range = 5,max_range = 12,duration=12}

--暴击震屏
--range:范围（例：5表示5*5的矩形范围内随机抖动）
--duration:持续震动次数(例：40表示持续震动40次后结束)
--baoji_action_shake = {range=0,duration=2}

--[[
	action = 动作id，
	frames = 帧集合，
	duration = 持续时间
]]--

--伙伴AI参数配置
partner_ai_config =  {
	player_range = 4,  --只在玩家周围 A 格内活动 A值 单位：格子
	delay_time   = 8,  --每隔B秒会向随机方向移动min~max个格子 B值 单位：秒
	min_grid_num = 1,  --每隔B秒会向随机方向移动min~max个格子 min值 单位：格子
	max_grid_num = 4,  --每隔B秒会向随机方向移动min~max个格子 max值 单位：格子
}

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--------------------------------
----HJH
ZX_ACTION_STEPT = 10
-- local _test_action_stept = ZX_ACTION_STEPT
-- -----------------
-- local _test_idle_stept = 0
-- ZX_ACTION_IDLE_U = _test_action_stept + _test_idle_stept + 0
-- ZX_ACTION_IDLE_LU_OR_RU = _test_action_stept + _test_idle_stept + 1
-- ZX_ACTION_IDLE_L_OR_R = _test_action_stept + _test_idle_stept + 2
-- ZX_ACTION_IDLE_LD_OR_RD = _test_action_stept + _test_idle_stept + 3
-- ZX_ACTION_IDLE_D = _test_action_stept + _test_idle_stept + 4
-- -----------------
-- local _test_move_stept = 10
-- ZX_ACTION_MOVE_U = _test_action_stept + _test_move_stept + 0
-- ZX_ACTION_MOVE_LU_OR_RU = _test_action_stept + _test_move_stept + 1
-- ZX_ACTION_MOVE_L_OR_R = _test_action_stept + _test_move_stept + 2
-- ZX_ACTION_MOVE_LD_OR_RD = _test_action_stept + _test_move_stept + 3
-- ZX_ACTION_MOVE_D = _test_action_stept + _test_move_stept + 4
-- -----------------
-- local _test_hit_one_stept = 20
-- ZX_ACTION_HIT_ONE_U = _test_action_stept + _test_hit_one_stept + 0
-- ZX_ACTION_HIT_ONE_LU_OR_RU = _test_action_stept + _test_hit_one_stept + 1
-- ZX_ACTION_HIT_ONE_L_OR_R = _test_action_stept + _test_hit_one_stept + 2
-- ZX_ACTION_HIT_ONE_LD_OR_RD = _test_action_stept + _test_hit_one_stept + 3
-- ZX_ACTION_HIT_ONE_D = _test_action_stept + _test_hit_one_stept + 4
-- -----------------
-- local _test_hit_two_stept = 30
-- ZX_ACTION_HIT_TWO_U = _test_action_stept + _test_hit_two_stept + 0
-- ZX_ACTION_HIT_TWO_LU_OR_RU = _test_action_stept + _test_hit_two_stept + 1
-- ZX_ACTION_HIT_TWO_L_OR_R = _test_action_stept + _test_hit_two_stept + 2
-- ZX_ACTION_HIT_TWO_LD_OR_RD = _test_action_stept + _test_hit_two_stept + 3
-- ZX_ACTION_HIT_TWO_D = _test_action_stept + _test_hit_two_stept + 4
-- -----------------
-- local _test_die_stept = 40
-- ZX_ACTION_DIE_U = _test_action_stept + _test_die_stept + 0
-- ZX_ACTION_DIE_LU_OR_RU = _test_action_stept + _test_die_stept + 1
-- ZX_ACTION_DIE_L_OR_R = _test_action_stept + _test_die_stept + 2
-- ZX_ACTION_DIE_LD_OR_RD = _test_action_stept + _test_die_stept + 3
-- ZX_ACTION_DIE_D = _test_action_stept + _test_die_stept + 4
-- -----------------
-- local _test_struck_stept = 50
-- ZX_ACTION_STRUCK_U = _test_action_stept + _test_struck_stept + 0
-- ZX_ACTION_STRUCK_LU_OR_RU = _test_action_stept + _test_struck_stept + 1
-- ZX_ACTION_STRUCK_L_OR_R = _test_action_stept + _test_struck_stept + 2
-- ZX_ACTION_STRUCK_LD_OR_RD = _test_action_stept + _test_struck_stept + 3
-- ZX_ACTION_STRUCK_D = _test_action_stept + _test_struck_stept + 4
-- -----------------
-- local _test_practice_stept = 60
-- ZX_ACTION_PRACTICE_U = _test_action_stept + _test_practice_stept + 0
-- ZX_ACTION_PRACTICE_LU_OR_RU = _test_action_stept + _test_practice_stept + 1
-- ZX_ACTION_PRACTICE_L_OR_R = _test_action_stept + _test_practice_stept + 2
-- ZX_ACTION_PRACTICE_LD_OR_RD = _test_action_stept + _test_practice_stept + 3
-- ZX_ACTION_PRACTICE_D = _test_action_stept + _test_practice_stept + 4
-- -----------------
-- local _test_on_horse_idle_stept = 70
-- ZX_ACTION_ON_HORSE_IDLE_U = _test_action_stept + _test_on_horse_idle_stept + 0
-- ZX_ACTION_ON_HORSE_IDLE_LU_OR_RU = _test_action_stept + _test_on_horse_idle_stept + 1
-- ZX_ACTION_ON_HORSE_IDLE_L_OR_R = _test_action_stept + _test_on_horse_idle_stept + 2
-- ZX_ACTION_ON_HORSE_IDLE_LD_OR_RD = _test_action_stept + _test_on_horse_idle_stept + 3
-- ZX_ACTION_ON_HORSE_IDLE_D = _test_action_stept + _test_on_horse_idle_stept + 4
-- --------------------------------
-- local _test_on_horse_move_stept = 80
-- ZX_ACTION_ON_HORSE_MOVE_U = _test_action_stept + _test_on_horse_move_stept + 0
-- ZX_ACTION_ON_HORSE_MOVE_LU_OR_RU = _test_action_stept + _test_on_horse_move_stept + 1
-- ZX_ACTION_ON_HORSE_MOVE_L_OR_R = _test_action_stept + _test_on_horse_move_stept + 2
-- ZX_ACTION_ON_HORSE_MOVE_LD_OR_RD = _test_action_stept + _test_on_horse_move_stept + 3
-- ZX_ACTION_ON_HORSE_MOVE_D = _test_action_stept + _test_on_horse_move_stept + 4
-- --------------------------------
-- local _test_hit_three_stept = 90
-- ZX_ACTION_HIT_THREE_U = _test_action_stept + _test_hit_three_stept + 0
-- ZX_ACTION_HIT_THREE_LU_OR_RU = _test_action_stept + _test_hit_three_stept + 1
-- ZX_ACTION_HIT_THREE_L_OR_R = _test_action_stept + _test_hit_three_stept + 2
-- ZX_ACTION_HIT_THREE_LD_OR_RD = _test_action_stept + _test_hit_three_stept + 3
-- ZX_ACTION_HIT_THREE_D = _test_action_stept + _test_hit_three_stept + 4
-- --------------------------------
-- local _test_power_hit_stept = 100
-- ZX_ACTION_POWER_HIT_U = _test_action_stept + _test_power_hit_stept + 0
-- ZX_ACTION_POWER_HIT_LU_OR_RU = _test_action_stept + _test_power_hit_stept + 1
-- ZX_ACTION_POWER_HIT_L_OR_R = _test_action_stept + _test_power_hit_stept + 2
-- ZX_ACTION_POWER_HIT_LD_OR_RD = _test_action_stept + _test_power_hit_stept + 3
-- ZX_ACTION_POWER_HIT_D = _test_action_stept + _test_power_hit_stept + 4
-- --------------------------------
-- local _test_hit_four_stept = 600
-- ZX_ACTION_HIT_FOUR_U = _test_action_stept + _test_hit_four_stept + 0
-- ZX_ACTION_HIT_FOUR_LU_OR_RU = _test_action_stept + _test_hit_four_stept + 1
-- ZX_ACTION_HIT_FOUR_L_OR_R = _test_action_stept + _test_hit_four_stept + 2
-- ZX_ACTION_HIT_FOUR_LD_OR_RD = _test_action_stept + _test_hit_four_stept + 3
-- ZX_ACTION_HIT_FOUR_D = _test_action_stept + _test_hit_four_stept + 4
-- --------------------------------
-- local _test_jump_prepare_stept = 700
-- ZX_JUMP_PREPARE_U = _test_action_stept + _test_jump_prepare_stept + 0
-- ZX_JUMP_PREPARE_LU_OR_RU = _test_action_stept + _test_jump_prepare_stept + 1
-- ZX_JUMP_PREPARE_L_OR_R = _test_action_stept + _test_jump_prepare_stept + 2
-- ZX_JUMP_PREPARE_LD_OR_RD = _test_action_stept + _test_jump_prepare_stept + 3
-- ZX_JUMP_PREPARE_LD_D = _test_action_stept + _test_jump_prepare_stept + 4
-- --------------------------------
-- local _test_jumping_stept = 710
-- ZX_JUMPING_U = _test_action_stept + _test_jumping_stept + 0
-- ZX_JUMPING_LU_OR_RU = _test_action_stept + _test_jumping_stept + 1
-- ZX_JUMPING_L_OR_R = _test_action_stept + _test_jumping_stept + 2
-- ZX_JUMPING_LD_OR_RD = _test_action_stept + _test_jumping_stept + 3
-- ZX_JUMPING_LD_D = _test_action_stept + _test_jumping_stept + 4
-- --------------------------------
-- local _test_jump_finish_stept = 720
-- ZX_JUMP_FINISH_U = _test_action_stept + _test_jump_finish_stept + 0
-- ZX_JUMP_FINISH_LU_OR_RU = _test_action_stept + _test_jump_finish_stept + 1
-- ZX_JUMP_FINISH_L_OR_R = _test_action_stept + _test_jump_finish_stept + 2
-- ZX_JUMP_FINISH_LD_OR_RD = _test_action_stept + _test_jump_finish_stept + 3
-- ZX_JUMP_FINISH_LD_D = _test_action_stept + _test_jump_finish_stept + 4
---------------------------
----
lh_npc_action_config =
{
	--eAnimationMonster 怪物
	-- { eType = 2,  action = ZX_ACTION_IDLE, 			frames = { 0,1 }, duration = 0.8 },
	-- { eType = 2,  action = ZX_ACTION_MOVE, 			frames = { 2, 3, 4, 5 }, duration = 0.8 },
	-- { eType = 2,  action = ZX_ACTION_HIT,  			frames = { 6, 7, 8 }, duration = 0.8 },
	-- { eType = 2,  action = ZX_ACTION_STRUCK,  		frames = { 12 }, duration = 0.5 },
	-- { eType = 2,  action = ZX_ACTION_STRUCK_2,  	frames = { 11 }, duration = 0.5 },
	--eAnimationNPC 
	-- { eType = 4,  action = ZX_ACTION_IDLE, frames = { 0,1,2,3,4,5 }, duration = 1.0 },
	-- { eType = 4,  action = ZX_ACTION_MOVE, frames = { 6,7,8,9,10,11,12,13 }, duration = 1.0 },
	-- { eType = 4,  action = ZX_JUMP_PREPARE_ID, frames = { 0,1,2,3 }, duration = 0.2 },
	-- { eType = 4,  action = ZX_JUMPING_ID, frames = { 12 }, duration = 0.2 },
	-- { eType = 4,  action = ZX_JUMP_FINISH_ID, frames = { 0,1,2 }, duration = 0.1 },

	--eAnimationEffect 传送阵
	--传送阵动作帧配置 不能删除
	{ eType = 6,  action = 1, frames = { 0,1,2,3,4,5,6,7}, duration = 1.2 },

	--eAnimationMount 坐骑
	-- { eType = 1,  action = ZX_ACTION_ON_HORSE_IDLE, frames = { 1,1,2,3,4,5 }, duration = 1.0 },
	-- { eType = 1,  action = ZX_ACTION_ON_HORSE_MOVE, frames = { 6,7,8,9,10,10 }, duration = 0.6 },
	--{ entity = 4,  action = ZX_ACTION_MOVE, frames = { 0,1,2,3,4,5 }, duration = 0.166 },
	
	--eAnimationPlant 采集对象
	{ eType = 5,  action = 1, frames = { 0 }, duration = 60.0 },

	-- --eAnimationPet = 宠物
	-- { eType = 3,  action = ZX_ACTION_IDLE, frames = { 0,1 }, duration = 1.0 },
	-- { eType = 3,  action = ZX_ACTION_MOVE, frames = { 2,3,4,5 }, duration = 0.5 },
	-- { eType = 3,  action = ZX_ACTION_HIT,  frames = { 6, 7, 8  }, duration = 1.0 },
	-- { eType = 3,  action = ZX_PET_HIT,  frames = { 6, 7, 8 }, duration = 1.0 },

	--eAnimationFabao 法宝
	-- { eType = 7,  action = ZX_ACTION_IDLE,  frames = { 6,7,8,9,10,11 }, duration = 1 },	
	-- { eType = 7,  action = ZX_ACTION_MOVE,  frames =  { 0,1,2,3,4,5 }, duration = 0.5},	

	--仙女

	-- { eType = 8,  action = ZX_ACTION_IDLE,  frames = { 0,1 }, duration = 0.6 },	
	-- { eType = 8,  action = ZX_ACTION_MOVE,  frames = { 2,3,4,5}, duration = 0.8 },


}

