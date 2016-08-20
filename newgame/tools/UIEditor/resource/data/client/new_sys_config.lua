

--[[  
系统开启配置,所有的需要开启条件的功能配置在这里
意味着，新手指引的时候，sguide_config的配置要跟fn_config对应
ctype   1等级关联  2任务关联（包括领取/完成） 3等级和任务同时达到条件(目前只有主面板的技能有)
level   等级限制
task_id  任务id
fini  	 任务要求  1 领取  2完成

pos 技能面板的技能位置，开启技能专用
]]

require "model/GameSysModel"

fn_config = {
	
	[1] = {game_sys = GameSysModel.CHIYINGLEGEND, ctype = 2, level = 10, task_id = 21, fini = 2, name = "星图"},  --"星图" 这个两个都包含暂定用2，很可能需要改
	[2] = {game_sys = GameSysModel.CHIYINGLEGEND, ctype = 2, task_id = 21, fini = 1, name = "秀丽江山"},			-- “秀丽江山”
	
	-- [38] = {ctype = 1, level = 0},	--"称号"暂时不用称号
	-- [39] = {ctype = 1, level = 0},	--"时装"暂时不用时装

	[3] = {game_sys = GameSysModel.GEOCACHING, ctype = 1, level = 25, name = "寻宝"},     --"寻宝"
	[4] = {game_sys = nil, ctype = 1, level = 25, name = "战斗模式"},     --"战斗模式"
	[5] = {game_sys = GameSysModel.REWARD, ctype = 1, level = 5, name = "奖励"},     -- "奖励"
	[6] = {game_sys = GameSysModel.JUBAOPEN, ctype = 1, level = 10, name = "聚宝盆"},    --"聚宝盆"

	[7] = {game_sys = GameSysModel.PARTNER, ctype = 1, level = 17, name = "伙伴"},    --"伙伴"
	[8] = {game_sys = GameSysModel.PARTNER, ctype = 1, level = 40, name = "伙伴-亲密"},	-- "伙伴-亲密"

	[9] = {game_sys = GameSysModel.HAOYOU, ctype = 1, level = 15, name = "好友"},   -- "好友"
	[10] = {game_sys = GameSysModel.SKILL, ctype = 1, level = 4, name = "技能"},   --"技能"
	[11] = {game_sys = GameSysModel.QQSH, ctype = 1, level = 19, name = "琴棋书画"},	--"琴棋书画"	
	[12] = {game_sys = GameSysModel.MOUNT, ctype = 1, level = 14, name = "坐骑",},  --"坐骑"
	[13] = {game_sys = GameSysModel.GUILD, ctype = 1, level = 25, name = "世族"},   --"世族"
	[14] = {game_sys = GameSysModel.WUJIANG, ctype = 1, level = 30, name = "武将"},		--"武将"  武将系统

	-- ["翅膀"] = {ctype = 1, level = 35},		--删除 翅膀系统
	-- ["法宝"] = {ctype = 1, level = 40},		--删除 法宝系统

	[15] = {game_sys = GameSysModel.RICHANG , ctype = 1, level = 22, name = "活跃"},		--"日常任务" 日常任务开启等级变化
	[16] = {game_sys = nil, ctype = 2, level = 25, name = "悬赏任务", task_id = 70, fini = 1,},   --"悬赏任务" 25级接取最后一个主线

	[17] = {game_sys = nil, ctype = 1, level = 21, name = "玩法", tag_ol = {57,58,18,19}},		-- "玩法"
	[57] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 26, name = "玩法-历练"},
	[58] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 24, name = "玩法-副本"},
	[18] = {game_sys = GameSysModel.YISHOU, ctype = 1, level = 21, name = "玩法-惩诛"},    --"玩法-异兽" 目前 玩法开启就来这里 
	[19] = {game_sys = nil, ctype = 1, level = 28, name = "玩法-通缉榜"},   --"玩法-通缉榜"
	--["玩法"] = {ctype = 1, level = 1},   --调试用，不用注释起来
	
	
	[20] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 28, name = "武力试炼"},  --"玩法-武力试炼"目前 
	[21] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 26, name = "演武场"},	--"玩法-演武场"目前 
	[22] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 27, name = "箴机奇图"},  --"玩法-箴机奇图"
	[23] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 31, name = "大乱斗"},  --"玩法-大乱斗"
	[24] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 31, name = "天梯赛"},  --"玩法-天梯赛"
	[25] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 31, name = "战队赛"},   --"玩法-战队赛"
	[26] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 31, name = "阵营战"},   --"玩法-阵营战"
	[27] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 31, name = "逐鹿中原"},  --"玩法-逐鹿中原"
	[60] = {game_sys = GameSysModel.ACTIVITY, ctype = 1, level = 29, name = "每日剧情"},
	--加入每日剧情


	[28] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 24, name = "天机奇缘"}, --"玩法-天机奇缘"
	[29] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 24, name = "神驹猎狩"},   --"玩法-神驹猎狩"
	[30] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 29, name = "无尽秘藏"},		 -- "玩法-组队副本"
	[31] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 30, name = "云台将录"},  --"玩法-云台将录"
	[32] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 29, name = "守卫昆阳"},   --"玩法-守卫昆阳"
	[52] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 33, name = "剑试云台"},
	[53] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 32, name = "龙脉珍宝"},
	[54] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 40, name = "烽火长安"},
	[55] = {game_sys = GameSysModel.FUBEN, ctype = 1, level = 37, name = "血战豫州"},
	-- [40] = {ctype = 1, level = 33},		--"玩法-无尽秘藏" 


	[33] = {game_sys = GameSysModel.ENHANCED, ctype = 1, level = 12, name = "铸造"},  --"铸造"
	[34] = {game_sys = GameSysModel.ENHANCED, ctype = 1, level = 33, name = "洗练"},    --"铸造-洗练"
	[35] = {game_sys = GameSysModel.ENHANCED, ctype = 1, level = 26, name = "镶嵌"},   --"铸造-镶嵌"
	[36] = {game_sys = GameSysModel.ENHANCED, ctype = 1, level = 50, name = "神铸"},		--"铸造-神铸" 
	[37] = {game_sys = GameSysModel.ENHANCED, ctype = 1, level = 20, name = "进阶"},	--"铸造-进阶"

	[42] = {game_sys = nil, ctype = 1, level = 31, name = "精英副本"},   --剧情副本 精英难度
	
	[50] = {game_sys = GameSysModel.MALL, ctype = 1, level = 0, name = "商城"},

	[51] = {game_sys = GameSysModel.RICHANG, ctype = 1, level = 31, name = "跑环任务"},

	[56] = {game_sys = GameSysModel.WUJIANG, ctype = 1, level = 36, name = "升级图鉴"},   -- 武将图鉴里面的一个按钮
	
	[59] = {game_sys = nil, ctype = 1, level = 10, name = "红包"},

	[61] = {game_sys = nil, ctype = 1, level = 15, name = "排行榜"},
	
	-- ["技能1"] = {ctype = 3, pos = 1, level = 3, task_id = 2, fini = 2},
	-- ["技能2"] = {ctype = 3, pos = 2, level = 8, task_id = 12, fini = 2},
	-- ["技能3"] = {ctype = 3, pos = 3, level = 12, task_id = 22, fini = 1},
	-- ["技能4"] = {ctype = 3, pos = 4, level = 16, task_id = 31, fini = 2},
	-- ["技能xp"] = {ctype = 3, pos = 5, level = 24000, task_id = -1, fini = 1},

	["技能1"] = {ctype = 1, pos = 1, level = 3},
	["技能2"] = {ctype = 1, pos = 2, level = 8},
	["技能3"] = {ctype = 1, pos = 3, level = 12},
	["技能4"] = {ctype = 1, pos = 4, level = 16},
	["技能xp"] = {ctype = 1, pos = 5, level = 24000},
}



--新功能开放提示
-- 必须确定 fn_config对应的key有 level 这个字段

new_sys_config = {
	--索引连续 icon 功能资源路径   level 开放等级
	--注意： 已经自动排序了
	--[1] = {icon="sui/xszy/icon_1.png",level = 1},
	{icon="sui/other/xingtu.png",level = fn_config[1].level},	--7级开启	--伙伴

	{icon="sui/mainMenu/1.png",level = fn_config[10].level},	--41级开启	--技能

	{icon="sui/rightTop/jiangli.png",level = fn_config[5].level},	--5级开启	--奖励

	-- {icon="sui/xszy/icon_1.png",level = fn_config[38].level},	--7级开启	

	{icon="sui/mainMenu/2.png",level = fn_config[7].level},	--17级开启	--伙伴

	{icon="sui/xszy/icon_14.png",level = fn_config[28].level},	--24级开启	--天机奇缘

	{icon="sui/mainMenu/7.png",level = fn_config[9].level},	--15级开启	--好友

	{icon="sui/mainMenu/6.png",level = fn_config[33].level},	--13级开启	--铸造【强化】

	{icon="sui/rightTop/first_row_3.png",level = fn_config[6].level},	--10级开启	--聚宝盆

	{icon="sui/mainMenu/12.png",level = fn_config[11].level},	--19级开启	--琴棋书画

	{icon="sui/xszy/icon_3.png",level = fn_config[37].level},	--20级开启	--进阶

	{icon="sui/xszy/icon_6.png",level = fn_config[18].level},  --世界BOSS	--21级开启

	{icon="sui/mainMenu/3.png",level = fn_config[12].level},	--14级开启	--坐骑

	-- {icon="sui/xszy/icon_16.png",level = fn_config[29].level}, 	--24级开启	--神驹猎狩

	{icon="sui/mainMenu/9.png",level = fn_config[13].level},	--25级开启	--世族

	{icon="sui/xszy/icon_4.png",level = fn_config[15].level},	--22级开启	--活跃度

	-- {icon="sui/xszy/icon_11.png",level = fn_config[16].level},	--25级开启	--悬赏

	{icon="sui/xszy/icon_7.png",level = fn_config[20].level},	--28级开启	--武力试炼

	{icon="sui/xszy/icon_9.png",level = fn_config[21].level},	--26级开启	--演武场

	-- {icon="sui/rightTop/first_row_3.png",level = fn_config[6].level},	--29级开启	--聚宝盆

	-- {icon="sui/xszy/icon_8.png",level = fn_config[34].level},	--31级开启	--洗练

	{icon="sui/xszy/icon_20.png",level = fn_config[30].level},	--29级开启	--无尽秘藏

	{icon="sui/xszy/icon_10.png",level = fn_config[35].level},	--32级开启	--镶嵌

	{icon="sui/xszy/icon_15.png",level = fn_config[22].level},	--27级开启	--箴机奇图

	-- {icon="sui/mainMenu/1.png",level = fn_config["翅膀"].level},

	{icon="sui/mainMenu/5.png",level = fn_config[14].level},	--30级开启	--武将

	-- {icon="sui/mainMenu/6.png",level = fn_config["法宝"].level },

	{icon="sui/xszy/icon_13.png",level = fn_config[24].level},	--31级开启	--天梯赛

	-- {icon="sui/xszy/icon_19.png",level = fn_config[25].level},	--30级开启	--战队赛

	{icon="icon/huoyue/00037.pd",level = fn_config[56].level},	--36级开启	--武将图鉴

	{icon="icon/huoyue/00036.pd",level = fn_config[8].level},	--40级开启	--伙伴亲密

	{icon="sui/xszy/icon_5.png",level = fn_config[36].level},	--50级开启	--神铸

	-- [30] = {icon="sui/xszy/icon_5.png",level = fn_config[36].level},

}

xpcall(function() table.sort(new_sys_config, function(a,b) return a.level < b.level end) end, __G__TRACKBACK__)

