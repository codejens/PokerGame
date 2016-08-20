
bianqiang_config = {
	big_titles_tab = {
		-- [1] = "sui/btn_name/zhanlitisheng.png", 
		-- [2] = "sui/btn_name/tesewanfa.png", 
		-- [3] = "sui/btn_name/jingyan.png", 
		-- [4] = "sui/btn_name/beibi.png", 
		-- [5] = "sui/btn_name/jingji.png",
		[1] = "战力提升", 
		[2] = "特色玩法", 
		[3] = "经验", 
		[4] = "铜钱", 
		[5] = "竞技",
	},
	small_titles_tab = {
		[1] = {
			{title = "星图",rank = 7  ,sign = "sui/other/xingtu.png", win = "chiYing_win", page = 2, is_red = false, des = "通关剧情点亮星图，可提升大量人物属性"},
			{title = "铸造",rank = 13 ,sign = "sui/mainMenu/6.png", win = "zhuzhao_win", is_red = false, des = "对装备进行强化、升阶、洗练、镶嵌，可大幅提升战斗力"},
			{title = "技能",rank = 4  ,sign = "sui/mainMenu/1.png", win = "user_skill_win", is_red = false, des = "升级技能提升战斗力，合理搭配技能特效可使战斗更加轻松"},
			{title = "伙伴",rank = 9 ,sign = "sui/mainMenu/2.png", win = "spartner_win", is_red = false, des = "伙伴出战可大幅提升战力，培养伙伴可提升大量属性"},
			{title = "坐骑",rank = 23 ,sign = "sui/mainMenu/3.png", win = "mount_win", is_red = false, des = "提升移动速度，提升大量属性"},
			{title = "武将",rank = 36 ,sign = "sui/mainMenu/5.png", win = "wujiang_win", is_red = false, des = "收集/培养武将可大幅提升战力，武将技能更是PK利器！"},
		},
		[2] = {
			{title = "寻宝",rank = 9 ,sign = "sui/other/xunbao.png", win = "geocaching_win", is_red = false ,des = "小小花费大大奖励，十连抽必出极品奖励，来试试你的RP吧！"},
			{title = "琴棋书画",rank = 17 ,sign = "sui/mainMenu/12.png", win = "qinqishuhua_win", is_red = false ,des = "抚琴研棋、读书作画，轻松获得经验、铜钱、伙伴培养材料"},
			{title = "通缉榜",rank = 28 ,sign = "sui/other/tongjibang.png", win = "sactivity_win",page = 4, is_red = false ,des = "想报仇却势单力薄？发布通缉召集全服玩家帮你复仇！"}
		}, 
		[3] = {
			{title = "守卫昆阳",rank = 31 ,FBID = SFuBenModel.FB_SHXUANNV_ID, limit_type = 1,is_on = false, cur = 0 ,tote = 0,win = "sactivity_win",page = 2,paging = "【队】守卫昆阳", is_red = false ,des = "产出大量经验、装备进阶材料"},
			-- {title = "天机奇缘",rank = 11 ,FBID = SFuBenModel.FB_LINGCHONG_ID ,limit_type = 1, cur = 0 ,tote = 0,win = "sactivity_win",page = 2,paging = 1, is_red = false ,des = "产出大量伙伴培养材料"},
			-- {title = "神驹猎狩",rank = 24 ,FBID = SFuBenModel.FB_LIEQI_ID ,limit_type = 1, cur = 0 ,tote = 0,win = "sactivity_win",page = 2,paging = 2, is_red = false ,des = "产出大量坐骑培养材料"},
			-- {title = "云台将录",rank = 36 ,FBID = SFuBenModel.FB_XYMIJING_ID ,limit_type = 1, cur = 0 ,tote = 0,win = "sactivity_win",page = 2,paging = 3, is_red = false ,des = "产出大量翅膀培养材料"},
			{title = "无尽秘藏",rank = 29 ,FBID = SFuBenModel.FB_WJMIZANG_ID, limit_type = 1,is_on = false, cur = 0 ,tote = 0, win = "sactivity_win",page = 2,paging = "【队】无尽秘藏",is_red = false ,des = "产出大量经验，多种装备进阶材料"},
			{title = "武力试炼",rank = 30 ,limit_type = 2, is_on = false,cur = 0 ,tote = 0,win = "sactivity_win",page = 1,paging = "武力试炼", is_red = false ,des = "产出铜钱、经验、装备强化材料"},
			{title = "悬赏任务",rank = 27 , limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "task_win",page = 2,is_red = false ,des = "产出大量经验，每天18点、24点刷新"},
			{title = "世族任务",rank = 25 , limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "guild_task_win",is_red = false , des = "产出经验、世族贡献等，每天24点刷新"},
			{title = "剧情副本",rank = 10 , limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "chiYing_win",is_red = false , des = "产出经验、星魂、伙伴碎片等材料"},
			{title = "箴机奇图",rank = 31 , limit_type = 2, is_on = false,cur = 0 ,tote = 0,win = "sactivity_win",page = 1, paging = "箴机奇图",is_red = false , des = "产出大量经验、铜钱，每天13:30-14:30、20:30-21:30开启"},
			{title = "剑试云台",rank = 30 ,FBID = SFuBenModel.FB_TTSLTEAM_ID, limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "sactivity_win",page = 2, paging = "【队】剑试云台",is_red = false , des = "产出大量寒铁、少量经验"},
			{title = "烽火长安",rank = 30 ,FBID = SFuBenModel.FB_LONGTEAM_TWO_ID, limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "sactivity_win",page = 2, paging = "【队】烽火长安",is_red = false , des = "产出岚罡、灵刃等装备进阶材料以及少量宝石"},
			{title = "血战豫州",rank = 30 ,FBID = SFuBenModel.FB_LONGTEAM_ONE_ID, limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "sactivity_win",page = 2, paging = "【队】血战豫州",is_red = false , des = "产出大量碎星、少量宝石、少量经验"},
			{title = "皇榜任务",rank = 28, limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "task_win",page = 3,is_red = false , des = "产出中量经验"},
			{title = "跑环任务",rank = 30, limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "task_win",page = 5,is_red = false , des = "产出大量经验和中量铜钱"},
		}, 
		[4] = {
			{title = "聚宝盆", rank = 10 ,limit_type = 1, is_on = false, cur = 0 ,tote = 1, win = "jubaopen_win", is_red = false ,des = "每天免费聚宝，轻松获得大量铜钱"},
			{title = "无尽秘藏",rank = 29 ,FBID = SFuBenModel.FB_WJMIZANG_ID, limit_type = 1, is_on = false,cur = 0 ,tote = 0, win = "sactivity_win",page = 2,paging = "【队】无尽秘藏",is_red = false ,des = "产出铜钱、经验、装备强化材料"},
			{title = "龙脉珍宝",rank = 30 ,FBID = SFuBenModel.FB_WJMZBOSS_ID, limit_type = 1, is_on = false,cur = 0 ,tote = 0,win = "sactivity_win",page = 2, paging = "【队】龙脉珍宝",is_red = false , des = "产出大量铜钱、少量星魂"},
		}, 
		[5] = {
			{title = "演武场",rank = 28 ,limit_type = 1, is_on = false, cur = 0 ,tote = 0, win = "sactivity_win", page = 1, paging = "演武场", is_red = false ,des = "每日发放丰厚奖励，专属商店还可兑换珍稀道具"},
			{title = "天梯赛",rank = 39 ,limit_type = 2, is_on = false, win = "sactivity_win", page = 1, paging = "天梯赛", is_red = false ,des = "1V1实时战斗，来场真正的对决吧！每周一、三20:00-20:30进行"},
			{title = "战队赛",rank = 39 ,limit_type = 2, is_on = false, win = "sactivity_win", is_red = false ,des = "3V3实时战斗，和小伙伴组队踏上巅峰！每周二、四20:00-20:30进行"},
			{title = "大乱斗",rank = 37 ,limit_type = 2, is_on = false, win = "sactivity_win", page = 1, paging = "大乱斗",is_red = false ,des = "个人大乱斗，角逐战场最强者！每周五20:00-20:30举行"},
			{title = "阵营战",rank = 37 ,limit_type = 2,is_on = false, win = "sactivity_win", page = 1, paging = "阵营战",is_red = false ,des = "王莽乱汉，汉室当兴，是时候为天下苍生而战了！活动于每周六20:00-20:30举行"},
			{title = "逐鹿中原",rank = 37 ,limit_type = 2,is_on = false, win = "sactivity_win", page = 1, paging = "逐鹿中原",is_red = false ,des = "乱世之中，奸贼横行，惩奸除恶最众者，可掌洛阳！活动于每周日20:00-20:30举行"}
		}
	},

	activty_config = { 
		--箴机奇图
		{id = 8 ,rank = 31, index = {3,7}, open_week = {1,2,3,4,5,6,7}, start_hour = {13,20}, start_min = {30,30}, end_hour = {14,21}, end_min = {30,30} },
		--天梯赛
		{id = 9 ,rank = 39, index = {5,2}, open_week = {1,3}, start_hour = {20}, start_min = {0}, end_hour = {20}, end_min = {30} },
		--战队赛
		{id = 10,rank = 39, index = {5,3}, open_week = {2,4}, start_hour = {20}, start_min = {0}, end_hour = {20}, end_min = {30} },
		--大乱斗
		{id = 14,rank = 37, index = {5,4}, open_week = {5}, start_hour = {20}, start_min = {0}, end_hour = {20}, end_min = {30} },
		--阵营战
		{id = 11,rank = 37, index = {5,5}, open_week = {6}, start_hour = {20}, start_min = {0}, end_hour = {20}, end_min = {30} },
		--逐鹿中原
		{id = 13,rank = 37, index = {5,6}, open_week = {6}, start_hour = {20}, start_min = {0}, end_hour = {20}, end_min = {30} },
	}

}