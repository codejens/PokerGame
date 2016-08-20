--[[
	move_pos:场景动画中需要移动到的点
			根据场景ID和副本进度获取需要移动到的坐标点
	progress表的参数说明:
		monster_num ：计划要刷出的怪物数量
		radius		：刷出来的怪物的活动范围

	pet：宠物相关配置
		-- id
		-- 怪物id
		-- 生命值
		-- 寿命
		-- 快乐值
		-- 等级
		-- 战斗类型
		-- 血包
		-- 当前经验
		-- 最大经验
		-- 悟性
		-- 成长值
		-- 宠物类型
		-- 攻击类型
		-- 等级称号
		-- 兽阶称号
		-- 最大血
		-- 攻击
		-- 内防御
		-- 外防御
		-- 暴击
		-- 命中
		-- 闪避
		-- 抗暴击
		-- 攻击资质
		-- 防御资质
		-- 灵巧资质
		-- 身法资质
		-- 攻击基础资质
		-- 防御基础资质
		-- 灵巧基础资质
		-- 身法基础资质
		-- 战斗力
		-- 技能槽
		-- max
		-- 名字
		-- 技能数量
		-- 如果技能数量大于0,则对应到每个技能还有如下4个字段
		-- 技能id
		-- 技能等级
		-- 技能cd时间
		-- 技能是否刻印 0 否 1 是
]]
newercamp = 
{
	skill_effect = 
	{
		[1]= {
				type	= 8,
				id   	= 1601,
				keepTime= 0
			},
		[2]= {
				type	= 2,
				id		= 1602,
				keepTime= 0,
			},
		[3]= {
				type	= 8,
				id		= 1603,
				keepTime= 0,
			},
		[4]= {
				type	= 6,
				id		= 1604,
				keepTime= 0,
			},
		[9]= {
				type	= 2,
				id		= 1101,
				keepTime= 0,
			},
		[11]= {
				type	= 4,
				id		= 1102,
				keepTime= 0,
			},
		[12]= {
				type	= 8,
				id		= 1103,
				keepTime= 0,
			},
		[14]={
				type	= 4,
				id		= 1104,
				keepTime= 0,
			},
		[17]={
				type	= 3,
				id		= 1701,
				keepTime= 0,
			},
		[19]={
				type	= 0,
				id		= 1702,
				keepTime= 0,
			},
		[20]={
				type	= 4,
				id		= 1703,
				keepTime= 0,
			},
		[22]={
				type	= 4,
				id		= 1704,
				keepTime= 0,
			},
		[25]={
				type	= 2,
				id		= 2501,
				keepTime= 0,
			},
		[27]={
				type	= 4,
				id		= 2502,
				keepTime= 0,
			},
		[28]={
				type	= 2,
				id		= 2503,
				keepTime= 0,
			},
		[30]={
				type	= 2,
				id		= 2504,
				keepTime= 0,
			},
	},
	progress =
	{
		[1] = {
				entity_id	= 1,
				name 		= "羌族护卫",
				x 			= 718,
				y 			= 902,
				move_x 		= -1,
				move_y 		= -1,
				model_id 	= 1,
				dir 		= 6,
				level 		= 99,
				hp 			= 1500,
				maxHp 		= 1500,
				moveSpeed 	= 1000,
				attackSpeed = 500,
				state 		= 0,
				name_color 	= 16777215,
				wing 		= 17,
				func 		= 5,
				pet_title 	= 0,
				title 		= 0,
				radius		= 200,
				monster_num = 4,
				quest_id 	= 997,
			},
		[2] = {
				entity_id 	= 1,
				name 		= "羌族死士",
				x 			= 1184,
				y 			= 640,
				move_x 		= -1,
				move_y 		= -1,
				model_id 	= 1,
				dir 		= 6,
				level 		= 99,
				hp 			= 48760,
				maxHp 		= 48760,
				moveSpeed 	= 1000,
				attackSpeed = 500,
				state 		= 0,
				name_color 	= 16777215,
				wing 		= 17,
				func 		= 5,
				pet_title 	= 0,
				title 		= 0,
				radius		= 200,
				monster_num = 14,
				quest_id 	= 998,
			},
		[3] = {
				entity_id 	= 17,
				name 		= "羌族大将",
				x 			= 1184,
				y 			= 640,
				move_x 		= -1,
				move_y 		= -1,
				model_id 	= 17,
				dir 		= 6,
				level 		= 99,
				hp 			= 88888,
				maxHp 		= 88888,
				moveSpeed 	= 1000,
				attackSpeed = 500,
				state 		= 0,
				name_color 	= 16777215,
				wing 		= 17,
				func 		= 5,
				pet_title 	= 0,
				title 		= 0,
				radius		= 200,
				monster_num = 1,
				quest_id 	= 999,
			},
	},
	damage =
	{
		hero =  {
					[1] = 357,
					[2] = 598,
					[3] = 575,
					[4] = 676,
					[7] = 357,
					[8] = 598,
					[9] = 575,
					[10] = 676,
					[12] = 486,
					[13] = 357,
					[14] = 598,
					[15] = 575,
					[16] = 676,
					[33] = 999999,
					[34] = 999999,
					[35] = 999999,
					[36] = 999999,
					[41] = 874,
					[42] = 874,
					[43] = 874,
					[44] = 874,
				},
		pet  = 	{
					[52] = 1600,
					[78] = 1600,
				},
		-- 额外附加伤害(宠物出战、佩戴翅膀)
		extra=	{
					pet  = 1000,
					wing = 3000,
				},
	},
	quest =
	{
		[997] = { mapy2 = 34,     mapy1 = 34,     mapx2 = 44,     entityid = 1,     mapx1 = 44,},
		[998] = { mapy2 = 38,     mapy1 = 38,     mapx2 = 87,     entityid = 2,     mapx1 = 87,},
		[999] = { mapy2 = 24,     mapy1 = 24,     mapx2 = 123,     entityid = 4,     mapx1 = 123,},
	},
	-- 玩家在新手副本中,拥有的宠物列表
	pet_list =
	{
		-- [1] = {
		-- 		id 			= 7074,		-- id
		-- 		monster_id	= 321,		-- 怪物id
		-- 		life		= 507,		-- 生命值
		-- 		shouming	= 26000,	-- 寿命
		-- 		happy_val	= 100,		-- 快乐值
		-- 		level		= 1,		-- 等级
		-- 		fight_type	= 1,		-- 战斗类型
		-- 		blood_bag	= 0,		-- 血包
		-- 		cur_exp		= 0,		-- 当前经验
		-- 		max_exp		= 0,		-- 最大经验
		-- 		wuxing		= 0,		-- 悟性
		-- 		grow_val	= 0,		-- 成长值
		-- 		pet_type	= 43,		-- 宠物类型
		-- 		attack_type	= 1,		-- 攻击类型
		-- 		level_title	= 0,		-- 等级称号
		-- 		mon_title	= 0,		-- 兽阶称号
		-- 		max_blood	= 507,		-- 最大血
		-- 		attack 		= 74,		-- 攻击
		-- 		inner_defen	= 26,		-- 内防御
		-- 		outer_defen	= 47,		-- 外防御
		-- 		baoji		= 26,		-- 暴击
		-- 		hit			= 25,		-- 命中
		-- 		duck		= 25,		-- 闪避
		-- 		fight_baoji	= 26,		-- 抗暴击
		-- 		attack_zz	= 734,		-- 攻击资质
		-- 		defen_zz	= 487,		-- 防御资质
		-- 		skillful_zz	= 497,		-- 灵巧资质
		-- 		shenfa_zz	= 464,		-- 身法资质
		-- 		att_base_zz	= 734,		-- 攻击基础资质
		-- 		def_base_zz	= 487,		-- 防御基础资质
		-- 		ski_base_zz	= 497,		-- 灵巧基础资质
		-- 		sf_base_zz	= 464,		-- 身法基础资质
		-- 		fight_val	= 401,		-- 战斗力
		-- 		jineng_slot	= 4,		-- 技能槽
		-- 		max 		= 507,		-- max
		-- 		name 		= "猿魔",	-- 名字
		-- 		skill 		=			-- 宠物身上已学习的技能列表
		-- 		{
		-- 			[1] = {
		-- 					skill_id	= 52, 
		-- 					skill_lv 	= 3, 
		-- 					skill_cd 	= 0, 
		-- 					skill_keyin = 0,
		-- 				},
		-- 		},
		-- 	},
	},
	-- 这里的数据是用来create_entity的,序号对应到上面的pet_list的序号
	-- 以下参数用在 GameLogicCC:do_create_other_entity 函数中
	pet_entity =
	{
		-- [1] = {
		-- 		entity_id	= 321,
		-- 		name 		= "猿魔",
		-- 		x 			= 1412,
		-- 		y 			= 1083,
		-- 		move_x 		= -1,
		-- 		move_y 		= -1,
		-- 		model_id 	= 321,
		-- 		dir 		= 6,
		-- 		level 		= 1,
		-- 		hp 			= 507,
		-- 		maxHp 		= 507,
		-- 		moveSpeed 	= 340,
		-- 		attackSpeed = 500,
		-- 		state 		= 0,
		-- 		name_color 	= 16730612,
		-- 		wing 		= 48,		-- 怪物的官职和攻击类型或NPC任务状态
		-- 		func 		= 5,		-- npc功能类型，怪物暂时没有意义
		-- 		pet_title 	= 0,		-- 宠物的称号 低2位是悟性称号,高2位是成长称号,其他实体没意义
		-- 		title 		= 0,		-- 阵营和排行称号信息
		-- 	},
	},
	movie =
	{
		[0] = { id = 'act23' },
		[1] = { id = 'act24' },
		[2] = { id = 'act25' },
		-- [3] = { id = 'act26' },
	},
	born_position = 
	{
		x = 3,
		y = 36,
	},
	move_pos = {
		[27] = {
			-- [1] = {x = 1160, y = 684, dur = 2.5},
			-- [2] = {x = 1100, y = 740, dur = 2},
		},
	},
	shishen_wing_id = 0x00090007,
}