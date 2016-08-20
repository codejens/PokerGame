--播放速度
local normal_speed = 0.125;

-- --特效墙播放速度
-- local barrier_speed = 0.175;

--普攻播放速度
local n_atk_t = 0.14

--主角攻击后的受击特效
shj_hurt_effect = {
	--职业id  特效id
	[1] = 124,
	[2] = 125,
	[4] = 86,
	--[4] = 92, --郭圣通
}

--主角攻击后的受击音效
shj_hurt_voice = {
	--职业id  特效id
	[1] = 8,
	[2] = 107,
	[4] = 207,
	--[4] = 92, --郭圣通
}

--主角攻击后的受击特效 某些动作特殊受击特效
shj_hurt_skill_effect = {
	--动作id  特效id
	--[31] = 44,
	--[34] = 53,
	--[33] = 53,
	[81] = 102,
}


--怪物攻击后的受击特效
shj_monster_hurt_effect = {
	--怪物id 特效id
	--[0] = 37,--通用受击特效
}

--除了普攻之外技能特效
shj_skill_effect = {
	---[3] = {4,96,97},
	[10] = {10,11},

	[22] = {17,18},
	[23] = {21},
	[24] = {25,26},
	[27] = {23,24},
	[47] = {39},
	[48] = {40},
	--[49] = {41,42},
	[53] = {43},
	[54] = {45,46},
	[56] = {50},
	[57] = {48,49},
}

--一些特效需要根据目标位置旋转对准
shj_effect_rotation = {
	--[17] = true,
}

--坐骑相对主角脚下的坐标
--[坐骑ID]=坐骑相对人物脚底向下编译的像素
--坐骑ID按坐骑化形界面从左到右从上到下点起，id从1开始
mount_offset_config={
	--[坐骑ID]=坐骑相对人物脚底向下编译的像素
	[1]= -8,
	[2]= -8,
	[3]= -8,
	[4]= -8,
	[5]= -8,
	[6]= -8,
	[7]= -8,
}

-- 弓箭手群攻技能3配置
-- (缩放倍数，出现延迟时间，相对中点的x,y坐标)
-- arrow_effect_config = {
-- 		[1] = {scale = 0.85, time = 0.08, x = -65, y = -20 },
-- 		[2] = {scale = 0.8,  time = 0.23, x = 25, y = -30 },
-- 		[3] = {scale = 1,    time = 0.18, x = -24, y = 25 },
-- 		[4] = {scale = 0.85, time = 0.01, x = 0, y = -20 },
-- 		[5] = {scale = 0.95, time = 0.30, x =64, y = 14 },
-- 		[6] = {scale = 0.7,  time = 0.19, x = 23, y = -50 },
-- 		[7] = {scale = 0.9,  time = 0.34, x = -40, y = 5 },
-- 	}

-- 需要受击特效, 需要添加受击特效的特效列表
-- 特效有客户端播放，与服务器断绝关系
-- target_attacked_effects = {
	
-- 	-- 普通特效，根据职业 self.job 获取
-- 	[1] = { delay= 0.35, effect_id = 1606, type = 9, effect_h=0.5 },
-- 	[2] = { delay= 0.35, effect_id = 1106, type = 9, effect_h=0.5 },
-- 	[3] = { delay= 0.1, effect_id = 1706, type = 9, effect_h=0.7 }, 
-- 	[4] = { delay= 0.1, effect_id = 2506, type = 9, effect_h=0.7 }, 

-- 	-- [1601] = { delay= 1.5, effect_id = 1606, type = 2 }, -- 刀客群攻
-- 	-- [1603] = { delay= 1.5, effect_id = 1606, type = 2 }, -- 刀客群攻
-- 	-- [1701] = { delay= 1.5, effect_id = 1706, type = 2 },
-- 	-- [1705] = { delay= 1.5, effect_id = 1706, type = 9 },
-- 	-- [2505] = { delay= 1.5, effect_id = 2506, type = 9 },
-- }

-- 1-10000 UI面板特效；  10001~20000为主角用特效	20001~30000为场景特效  5000~10000为UI展示特效
--山海经ui动画特效用这个 别用下面那个了 准备以后删掉
shj_effect_config =  {
	-- [4] = {"frame/uieffect/1",normal_speed,7}, --必杀技能量操  ——山海经资源
	-- [6] = {"frame/uieffect/3", normal_speed + 0.08, 7}, -- 自动杀怪 ——山海经资源
	-- [7] = {"frame/uieffect/4", normal_speed + 0.08, 7}, -- 自动寻路 ——山海经资源
	-- [8] = {"frame/uieffect/5", normal_speed, 1}, --npc头像上面箭头 ——山海经资源
	[5] = {"frame/uieffect/2",normal_speed,10}, --主界面图标圈圈特效
	[9] = {"frame/uieffect/29", normal_speed, 6}, --星图星点选中效果
	[10] = {"frame/uieffect/30", normal_speed, 6}, --激活星图特效
	[11] = {"frame/uieffect/8", normal_speed, 15}, --角色升级特效上层
	[12] = {"frame/uieffect/9", normal_speed, 8}, --角色升级特效下层
	[13] = {"frame/uieffect/10", normal_speed+0.09, 4}, --小地图头像动画
	[14] = {"frame/uieffect/11", normal_speed, 7}, --副本结算爆炸特效
	[15] = {"frame/uieffect/12", normal_speed, 8}, --副本结算粒子特效
	[16] = {"frame/uieffect/13", normal_speed, 21}, --副本结算粒子特效(60%)
	[17] = {"frame/uieffect/14", normal_speed, 7}, --主界面挂机
	[18] = {"frame/uieffect/16", normal_speed, 4}, --聊天录音
	[19] = {"frame/uieffect/15", normal_speed, 4}, --听取录音
	[20] = {"frame/uieffect/17", normal_speed, 6}, --点击地面特效
	[21] = {"frame/uieffect/18", normal_speed, 6}, --普攻按钮特效
	[22] = {"frame/uieffect/19", normal_speed, 10}, --提示特效
	[23] = {"frame/uieffect/20", normal_speed, 8}, --选中目标特效
	[24] = {"frame/uieffect/21", normal_speed, 3},	-- 在空中飘的经验特效
	[25] = {"frame/uieffect/22", normal_speed, 5},	-- 落到经验条上的经验特效
	[26] = {"frame/uieffect/27", normal_speed, 8},	-- 任务小面板完成任务的特效
	[27] = {"frame/uieffect/23", normal_speed, 9},	-- 被抢光了的红包特效
	[28] = {"frame/uieffect/24", normal_speed, 10},	-- 红包的星光特效
	[29] = {"frame/uieffect/28", normal_speed, 9},	-- 抢到红包的红包特效
	[39] = {"frame/uieffect/33", normal_speed - 0.04, 10}, -- 鲜花特效里面的流星
	[40] = {"frame/uieffect/25", normal_speed-0.04, 8}, -- 强化特效
	[41] = {"frame/uieffect/26", normal_speed , 11}, -- 坐骑培养成功
	[42] = {"frame/uieffect/31", normal_speed , 10}, -- 新手框框特效
	[43] = {"frame/uieffect/32", normal_speed , 10}, -- 新手功能开启特效
	[44] = {"frame/uieffect/34", normal_speed , 10}, -- 新手技能开启特效
	[45] = {"frame/uieffect/35", normal_speed , 6},	
	[46] = {"frame/uieffect/37", normal_speed , 9},		--升级特效
	[47] = {"frame/uieffect/38", normal_speed , 6},		--loading特效
	[48] = {"frame/uieffect/39", normal_speed , 8},		--寻宝抽奖特效
	[49] = {"frame/uieffect/40", normal_speed , 8},    --寻宝十次抽奖特效
	[50] = {"frame/uieffect/41", normal_speed , 7},	--主界面变强特效
    [51] = {"frame/uieffect/36", normal_speed , 13},	--主界面公告栏特效
    [52] = {"frame/uieffect/42", normal_speed , 8},	--玩法波数特效（主界面）
    [53] = {"frame/uieffect/43", normal_speed , 11},	--培养成功特效
    [54] = {"frame/uieffect/44", normal_speed , 13},	--暴击数字（5）
    [55] = {"frame/uieffect/45", normal_speed , 13},	--暴击数字（2）
    [56] = {"frame/uieffect/46", normal_speed , 13},	--暴击（倍暴击）
    [57] = {"frame/uieffect/47", normal_speed , 11},	--纵向翻牌特效
    [58] = {"frame/uieffect/48", normal_speed , 12},	--横向翻牌特效
    [59] = {"frame/uieffect/49", normal_speed , 10},	--完成任务特效
    [60] = {"frame/uieffect/50", normal_speed , 7},	--聚宝盆发光特效
    [61] = {"frame/uieffect/51", normal_speed , 10},	--任务升星特效
    [62] = {"frame/uieffect/52", normal_speed , 12},	--扫荡完成特效
    [63] = {"frame/uieffect/53", normal_speed , 12},	--聚宝五次特效
    [64] = {"frame/uieffect/54", normal_speed , 12},	--聚宝一次特效
    [65] = {"frame/uieffect/55", 0.1 , 3},	--连击特效
    [66] = {"frame/uieffect/56", normal_speed , 10},	--可接任务特效
    [67] = {"frame/uieffect/57", normal_speed , 10},	--可交任务特效
    [68] = {"frame/uieffect/58", normal_speed , 6},	--GO指路
    [69] = {"frame/uieffect/59", normal_speed , 1},	--大乱斗场景特效（护甲）
    [70] = {"frame/uieffect/60", normal_speed , 1},	--大乱斗场景特效（恢复）
    [71] = {"frame/uieffect/61", normal_speed , 1},	--大乱斗场景特效（加速）
    [72] = {"frame/uieffect/62", normal_speed , 1},	--大乱斗场景特效（嗜血）
    [73] = {"frame/uieffect/63", normal_speed , 10},	--设置界面点击反馈
    [74] = {"frame/uieffect/64", normal_speed , 10},	--开始游戏按钮特效
    [75] = {"frame/uieffect/65", normal_speed , 10},	--阴丽华武器特效
    [76] = {"frame/uieffect/66", normal_speed , 10},	--boss来袭特效
    [77] = {"frame/uieffect/67", normal_speed , 10},	--阴丽华鞭子
    [78] = {"frame/uieffect/68", normal_speed , 10},	--阴丽华腰带
    [79] = {"frame/uieffect/69", normal_speed , 10},	--刘秀武器特效
    [80] = {"frame/uieffect/70", normal_speed , 13},	--暴击数字（3）
    [81] = {"frame/uieffect/71", normal_speed , 13},	--暴击数字（6）
    [82] = {"frame/uieffect/72", normal_speed , 10},	--活跃度开宝箱特效
    [83] = {"frame/uieffect/73", normal_speed , 13},	--背包解锁特效
    [84] = {"frame/uieffect/74", normal_speed , 15},	--主界面战斗力特效
    [85] = {"frame/uieffect/75", normal_speed , 5},	--cjjs——gst飘带（大）
    [86] = {"frame/uieffect/76", normal_speed , 5},	--cjjs——gst飘带（小）
    [87] = {"frame/uieffect/77", normal_speed , 5},	--cjjs——灯笼光晕
    [88] = {"frame/uieffect/78", normal_speed , 10},	--cjjs——武器特效（右）
    [89] = {"frame/uieffect/79", normal_speed , 10},	--cjjs——武器特效（左）
    [90] = {"frame/uieffect/80", normal_speed , 10},	--运营活动-夺宝（刷光）
    [91] = {"frame/uieffect/81", normal_speed , 10},	--运营活动-夺宝（台光）
    [92] = {"frame/uieffect/82", normal_speed+0.03 , 10},	--道具框特效（低级）
    [93] = {"frame/uieffect/83", normal_speed+0.03 , 10},	--道具框特效（中级）
    [94] = {"frame/uieffect/84", normal_speed+0.03 , 10},	--道具框特效（高级）
    [95] = {"frame/uieffect/85", normal_speed , 10},	--月签到特效
    [96] = {"frame/uieffect/86", normal_speed , 10},	--战力礼包特效
    [97] = {"frame/uieffect/87", normal_speed , 10},	--战力礼包特效
    [98] = {"frame/uieffect/88", normal_speed , 10},	--兑换坐骑格子特效
    [99] = {"frame/uieffect/89", normal_speed , 6},	--兑换坐骑方向特效
    [100] = {"frame/uieffect/90", normal_speed , 8},	--兑换坐骑抛物线特效
    [101] = {"frame/uieffect/91", normal_speed , 10},	--兑换坐骑特效
    [102] = {"frame/uieffect/92", normal_speed , 10},	--SVIP称号特效
    [103] = {"frame/uieffect/93", normal_speed , 10},	--SVIP字特效
    [104] = {"frame/uieffect/94", normal_speed , 10},	--SVIP主角脚下光环

	--======================================UI展示特效开始==========================================
	[50001] = {"frame/uishow/fabao/1", normal_speed, 6}, --法宝展示-昆仑镜
	[50002] = {"frame/uishow/fabao/2", normal_speed, 6}, --法宝展示-东皇钟
	[50003] = {"frame/uishow/fabao/3", normal_speed, 6}, --法宝展示-炼妖壶
	[50006] = {"frame/uishow/fabao/6", normal_speed, 6}, --法宝展示-昊天塔
	[50007] = {"frame/uishow/fabao/7", normal_speed, 6}, --法宝展示-盘古斧
	[50008] = {"frame/uishow/fabao/8", normal_speed, 1}, --法宝展示-女娲石
	[50009] = {"frame/uishow/fabao/9", normal_speed, 6}, --法宝展示-伏羲琴
	[50010] = {"frame/uishow/fabao/10", normal_speed, 1}, --法宝展示-轩辕剑

	[50050] = {"frame/uishow/mount/1", normal_speed, 4}, --坐骑展示-1阶

	[50100] = {"frame/uishow/wing/1", normal_speed, 6}, --翅膀展示-1阶

	[50150] = {"frame/uishow/role/2",normal_speed,6}, --阴丽华ui展示
--======================================UI展示特效结束==========================================	

--======================================BUFF特效开始==========================================
	[10125] = {"frame/buffeffect/125", normal_speed, 10}, --定身BUFF特效
	[10126] = {"frame/buffeffect/126", normal_speed, 10}, --减速BUFF特效
	[10127] = {"frame/buffeffect/127", normal_speed, 10}, --残废BUFF特效
	[10128] = {"frame/buffeffect/128", normal_speed, 10}, --石化BUFF特效
	[10129] = {"frame/buffeffect/129", normal_speed, 10}, --混乱BUFF特效
	[10130] = {"frame/buffeffect/130", normal_speed, 10}, --沉默BUFF特效
	[10131] = {"frame/buffeffect/131", normal_speed, 10}, --眩晕BUFF特效
	[10132] = {"frame/buffeffect/132", normal_speed, 10}, --束缚BUFF特效
	[10023] = {"frame/buffeffect/23", normal_speed, 10}, --防御增加BUFF特效	
	[10024] = {"frame/buffeffect/24", normal_speed, 10}, --防御降低BUFF特效
	[10027] = {"frame/buffeffect/27", normal_speed, 10}, --攻击增加BUFF特效	
	[10028] = {"frame/buffeffect/28", normal_speed, 10}, --攻击降低BUFF特效	

--======================================BUFF特效结束==========================================

	[20001] = {"frame/sceneeffct/1",normal_speed,5},	--祖庙场景黑雾特效
	[20002] = {"frame/sceneeffct/2",normal_speed,8},	--场景阻隔光幕黄色
	[20003] = {"frame/sceneeffct/3",normal_speed,10},	--场景阻隔光幕蓝色
	[20004] = {"frame/sceneeffct/4",normal_speed,6},	--温泉热气特效
	[20005] = {"frame/sceneeffct/5",normal_speed,6,scale=3},	--空中白色云雾特效
	[20006] = {"frame/sceneeffct/6",normal_speed,6},	--睡睡粉迷雾特效
	[20007] = {"frame/sceneeffct/7",normal_speed,6},	--紧张
	[20008] = {"frame/sceneeffct/8",normal_speed,6},	--惊吓
	[20009] = {"frame/sceneeffct/9",normal_speed,6},	--开心
	[20010] = {"frame/sceneeffct/10",normal_speed,6},	--脸红
	[20011] = {"frame/sceneeffct/11",normal_speed,6},	--伤心
	[20012] = {"frame/sceneeffct/12",normal_speed,5},	--生气
	[20013] = {"frame/sceneeffct/13",normal_speed,6},	--郁闷
	[20016] = {"frame/effect/38",normal_speed-0.025,7},			--怪物出生特效
	[20017] = {"frame/effect/152",0.1,4},			--连击特效
    [20018] = {"frame/sceneeffct/17",normal_speed,2},	--玉佩
    [20019] = {"frame/sceneeffct/18",normal_speed,4},	--蜡烛
    [20020] = {"frame/sceneeffct/19",normal_speed,2,scale=0.7},	--长歌刀
    [20021] = {"scene/monster/2101",normal_speed,1},	--箱子
    [20022] = {"frame/sceneeffct/20",normal_speed,8},	--彗星
    [20023] = {"frame/sceneeffct/21",normal_speed,13},	--秋风扫落叶
    [20024] = {"frame/sceneeffct/22",normal_speed,8},	--瀑布水汽
    [20025] = {"frame/effect/113",normal_speed,10},	--冰晶

    --副本特效
	[30018] = {"frame/sceneeffct/15",normal_speed,8}, 	--预警特效,第xx层
	[30019] = {"frame/sceneeffct/16",normal_speed,10}, 	--boss来袭特效
   	
	--临时旧资源
	[11049] = {"frame/effect/scene/8",normal_speed,10},	-- 历练副本燃烧特效
	--[21] = {"frame/effect/must/21",0.15,5},	--点击地板
	--[7] = {"frame/effect/must/7",0.2,5},	--选中
	[10014] = {"frame/effect/jm/10014",normal_speed,6}, --提升成功特效
	[10015] = {"frame/effect/jm/10015",normal_speed,6}, --提升暴击特效
	[11042] = {"frame/uieffect/14",normal_speed,6},	-- 挂机中特效	
	[11043] = {"frame/uieffect/95",normal_speed,8},	-- 七夕收花送花特效
	-- [11044] = {"frame/uieffect/96",normal_speed,8},	-- 七夕收花送花特效
}

--临时旧资源 都的删掉的 新资源不要放在这里了
effect_config = {
	[11049] = {"frame/effect/scene/8",normal_speed,10},	-- 历练副本燃烧特效
	--[21] = {"frame/effect/must/21",0.15,5},	--点击地板
	--[7] = {"frame/effect/must/7",0.2,5},	--选中
	[10014] = {"frame/effect/jm/10014",normal_speed,6}, --提升成功特效
	[10015] = {"frame/effect/jm/10015",normal_speed,6}, --提升暴击特效
	[11042] = {"frame/uieffect/14",normal_speed,6},	-- 挂机中特效	
	[10007] = {"frame/effect/jm/10007",normal_speed,16},--选中框
}
