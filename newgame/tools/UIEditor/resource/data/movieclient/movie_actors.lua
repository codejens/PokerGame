
--[[
	ZX_ENTITY_PLAYER_PET = -2,				// 玩家的宠物
	ZX_ENTITY_PLAYER_AVATAR = -1,				// 主玩家
	ZX_ENTITY_AVATAR = 0,						// 玩家
	ZX_ENTITY_MONSTER = 1,						// 怪物
	ZX_ENTITY_NPC = 2,							// npc
	ZX_ENTITY_MOVING_NPC = 3,					// 巡逻的npc
	ZX_ENTITY_PET = 4,							// 宠物

	// 非生物
	ZX_ENTITY_TOTEM = 5,						// 图腾
	ZX_ENTITY_MINE = 6,							// 矿物，采集对象
	ZX_ENTITY_DEFENDER = 7,						// 防御措施
	ZX_ENTITY_PLANT = 8,						// 植物，采集对象
	// 特效类
	ZX_ENTITY_TELEPORT = 9,						// 传送门
	ZX_ENTITY_BUILDING = 10,						// 建筑
	ZX_ENTITY_EFFECT = 11,						// 特效
	// 其他
	ZX_ENTITY_COLLECTABLE = 12,					// 采集怪
	ZX_ENTITY_DISPLAY_MONSTER = 13,				// 显示怪，如炸药包
	// 掉落物品
	ZX_ENTITY_DROP_ITEM = 99,				// 掉落物品
]]

--动画角色
--括号里面是id []
--path  = 特效动画所在目录
--eType = 0
movie_actors =
{
	--eType == 0 这是一个玩家模型，枚举值参看上面，ZX_ENTITY_AVATAR == 0
    --['cast0'] = { path = "scene/monster/1", eType = 1},
  --测试 剧情怪物  有特殊动作配置act_type 
--————————————————————————————正常怪物ID和模型ID一致————开始————————————————————————————————
	['1'] = { path = "scene/monster/1", eType = 1,act_type=21}, --邓禹，弹琴动作ID5，其他不变
	-- ['2'] = { path = "scene/monster/2", eType = 1},
	-- ['3'] = { path = "scene/monster/3", eType = 1},
	-- ['4'] = { path = "scene/monster/4", eType = 1},
	-- ['5'] = { path = "scene/monster/5", eType = 1},
	['6'] = { path = "scene/monster/6", eType = 1,act_type=20}, --带翅膀的阴丽华
	['06'] = { path = "scene/monster/6", eType = 1,act_type=26}, --阴丽华跳舞 跳舞ID5
	-- ['7'] = { path = "scene/monster/7", eType = 1},
	-- ['8'] = { path = "scene/monster/8", eType = 1},
	-- ['9'] = { path = "scene/monster/9", eType = 1},
	['10'] = { path = "scene/monster/10", eType = 1,act_type=24},  --邓婵 万福礼 ID5  跳舞ID 6
	-- ['11'] = { path = "scene/monster/11", eType = 1},
	-- ['12'] = { path = "scene/monster/12", eType = 1},
	['13'] = { path = "scene/monster/13", eType = 1,act_type=23}, --刘秀读书
	-- ['14'] = { path = "scene/monster/14", eType = 1},
	-- ['15'] = { path = "scene/monster/15", eType = 1},
	-- ['16'] = { path = "scene/monster/16", eType = 1},
	['17'] = { path = "scene/monster/17", eType = 1,act_type=28}, --刘伯姬舞剑 舞剑ID5
	-- ['18'] = { path = "scene/monster/18", eType = 1},
	-- ['19'] = { path = "scene/monster/19", eType = 1},
	-- ['20'] = { path = "scene/monster/20", eType = 1},
	-- ['21'] = { path = "scene/monster/21", eType = 1},
	-- ['22'] = { path = "scene/monster/22", eType = 1},
	-- ['23'] = { path = "scene/monster/23", eType = 1},
	-- ['24'] = { path = "scene/monster/24", eType = 1},
	-- ['25'] = { path = "scene/monster/25", eType = 1},
	-- ['26'] = { path = "scene/monster/26", eType = 1},
	-- ['27'] = { path = "scene/monster/27", eType = 1},
	-- ['28'] = { path = "scene/monster/28", eType = 1},
	['29'] = { path = "scene/monster/29", eType = 1,act_type=19},  --带翅膀的邓奉
	-- ['30'] = { path = "scene/monster/30", eType = 1},
	-- ['31'] = { path = "scene/monster/31", eType = 1},
	-- ['32'] = { path = "scene/monster/32", eType = 1},
	-- ['33'] = { path = "scene/monster/33", eType = 1},
	['34'] = { path = "scene/monster/34", eType = 1,act_type=25},  --冯异吹笛
	-- ['35'] = { path = "scene/monster/35", eType = 1},
	-- ['36'] = { path = "scene/monster/36", eType = 1},
	-- ['37'] = { path = "scene/monster/37", eType = 1},
	-- ['38'] = { path = "scene/monster/38", eType = 1},
	-- ['39'] = { path = "scene/monster/39", eType = 1},
	-- ['40'] = { path = "scene/monster/40", eType = 1},
	-- ['41'] = { path = "scene/monster/41", eType = 1},
	['42'] = { path = "scene/monster/42", eType = 1,act_type=22},  --丁柔弹琵琶
	-- ['43'] = { path = "scene/monster/43", eType = 1},
	-- ['44'] = { path = "scene/monster/44", eType = 1},
	-- ['45'] = { path = "scene/monster/45", eType = 1},
	-- ['46'] = { path = "scene/monster/46", eType = 1},
	-- ['47'] = { path = "scene/monster/47", eType = 1},
	-- ['48'] = { path = "scene/monster/48", eType = 1},
	-- ['49'] = { path = "scene/monster/49", eType = 1},
	-- ['50'] = { path = "scene/monster/50", eType = 1},
	-- ['51'] = { path = "scene/monster/51", eType = 1},
	-- ['52'] = { path = "scene/monster/52", eType = 1},
	-- ['53'] = { path = "scene/monster/53", eType = 1},
	-- ['54'] = { path = "scene/monster/54", eType = 1},
	-- ['55'] = { path = "scene/monster/55", eType = 1},
	-- ['56'] = { path = "scene/monster/56", eType = 1},
	-- ['57'] = { path = "scene/monster/57", eType = 1},
	-- ['58'] = { path = "scene/monster/58", eType = 1},
	-- ['59'] = { path = "scene/monster/59", eType = 1},
	['60'] = { path = "scene/monster/60", eType = 1,act_type=27}, --机关鸢 
	-- ['61'] = { path = "scene/monster/61", eType = 1},
	-- ['62'] = { path = "scene/monster/62", eType = 1},
	-- ['63'] = { path = "scene/monster/63", eType = 1},
	-- ['64'] = { path = "scene/monster/64", eType = 1},
	-- ['65'] = { path = "scene/monster/65", eType = 1},
	-- ['66'] = { path = "scene/monster/66", eType = 1},
	-- ['67'] = { path = "scene/monster/67", eType = 1},
	-- ['68'] = { path = "scene/monster/68", eType = 1},
	-- ['69'] = { path = "scene/monster/69", eType = 1},
	-- ['70'] = { path = "scene/monster/70", eType = 1},
	-- ['71'] = { path = "scene/monster/71", eType = 1},
	-- ['72'] = { path = "scene/monster/72", eType = 1},
	-- ['73'] = { path = "scene/monster/73", eType = 1},
	-- ['74'] = { path = "scene/monster/74", eType = 1},
	-- ['75'] = { path = "scene/monster/75", eType = 1},
	-- ['76'] = { path = "scene/monster/76", eType = 1},
	-- ['77'] = { path = "scene/monster/77", eType = 1},
	-- ['78'] = { path = "scene/monster/78", eType = 1},
	-- ['79'] = { path = "scene/monster/79", eType = 1},
	-- ['80'] = { path = "scene/monster/80", eType = 1},
	-- ['81'] = { path = "scene/monster/81", eType = 1},
	-- ['82'] = { path = "scene/monster/82", eType = 1},
	-- ['83'] = { path = "scene/monster/83", eType = 1},
	-- ['84'] = { path = "scene/monster/84", eType = 1},
	-- ['85'] = { path = "scene/monster/85", eType = 1},
	-- ['86'] = { path = "scene/monster/86", eType = 1},
	-- ['87'] = { path = "scene/monster/87", eType = 1},

	['cast2222'] = { path = "scene/monster/2222", eType = 1,act_type = 19},

--————————————————————————正常怪物ID和模型ID一致————结束————————————————————————————

} 