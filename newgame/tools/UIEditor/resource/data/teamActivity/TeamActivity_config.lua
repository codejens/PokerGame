--create by jiangjinhong
--TeamActivity_config.lua
--组队副本配置表
TeamActivity_config = 
{	
	--羁判副本
	{	
		fuben_name = "羁判副本",----副本
		player_level = 34,	--开启最低等级(新加)		
		fuben_id = 12,	--副本id（唯一）
		fuben_listid = 5,	--副本父系id		
		title = "ui/teamActivity/activity_1.png",	--按钮标题
		small_title = "ui/teamActivity/activity_1_small.png",	--副本图片显示标题		
		fuben_picture = "nopack/MiniMap/wyc3.jpg",	--副本地图		
		zudui_title = "ui/teamActivity/list_1.png",	--组队界面标题 （列："队伍列表(羁绊副本)"）		
		product = 	--产出：天，make_3.png；地，make_2.png；玄，make_1.png；经验，exp.png；产出字样必须放在  第一个位置，make.png
		{	
			"ui/teamActivity/make.png",
			"ui/teamActivity/exp.png",
		},		
		reward = "#c4d2308海量经验",	--副本奖励内容		
		challenge_dengji = "#c4d230834级",	--挑战等级		
		duiwu_num = "#c4d23082人",	-- 队伍人数
		if_open = true,	--目前是否开放
	},

	--圣灵守护副本
	{	
		
		player_level = 45,	--开启最低等级(新加)		
		fuben_id = 82,	--副本id（唯一）
		fuben_listid = -1,	--副本父系id		
		title = "ui/teamActivity/activity_2.png",	--按钮标题		
		small_title = "ui/teamActivity/activity_2_small.png",	--副本图片显示标题		
		fuben_picture = "nopack/MiniMap/xmhj.jpg",	--副本地图		
		zudui_title = "ui/teamActivity/list_2.png",	--组队界面标题 （列："队伍列表(羁绊副本)"）		
		product = 		--产出：天，make_3.png；地，make_2.png；玄，make_1.png；经验，exp.png；产出字样必须放在  第一个位置，make.png
		{	
			"ui/teamActivity/make.png",
			"ui/teamActivity/exp.png",
			"ui/teamActivity/make_1.png",
		},		
		reward = "#c4d2308海量经验#r玄令积分",	--副本奖励内容		
		challenge_dengji = "#c4d230845级",	--挑战等级		
		duiwu_num = "#c4d23082~5人",	-- 队伍人数		
		if_open = false,	--目前是否开放
	},

	--五星连珠副本
	{			
		player_level = 49,	--开启最低等级(新加)
		fuben_id = 83,	--副本id（唯一）
		fuben_listid = -1,	--副本父系id		
		title = "ui/teamActivity/activity_3.png",	--按钮标题		
		small_title = "ui/teamActivity/activity_3_small.png",	--副本图片显示标题		
		fuben_picture = "nopack/MiniMap/tmt.jpg",	--副本地图		
		zudui_title = "ui/teamActivity/list_3.png",		--组队界面标题 （列："队伍列表(羁绊副本)"）	
		product = 		--产出：天，make_3.png；地，make_2.png；玄，make_1.png；经验，exp.png；产出字样必须放在  第一个位置，make.png
		{	
			"ui/teamActivity/make.png",
			"ui/teamActivity/exp.png",
			"ui/teamActivity/make_2.png",
		},
		reward = "#c4d2308海量经验#r地令积分",		--副本奖励内容		
		challenge_dengji = "#c4d230849级",		--挑战等级		
		duiwu_num = "#c4d23082~5人",	-- 队伍人数		
		if_open = false,	--目前是否开放
	},

	--炽翼魔窟副本
	{	
		
		
		player_level = 52,	--开启最低等级(新加)		
		fuben_id = 81,	--副本id（唯一）
		fuben_listid = -1,	--副本父系id	
		title = "ui/teamActivity/activity_4.png",	--按钮标题		
		small_title = "ui/teamActivity/activity_4_small.png",	--副本图片显示标题		
		fuben_picture = "nopack/MiniMap/htmj.jpg",		--副本地图		
		zudui_title = "ui/teamActivity/list_4.png",		--组队界面标题 （列："队伍列表(羁绊副本)"）
		product = 		--产出：天，make_3.png；地，make_2.png；玄，make_1.png；经验，exp.png；产出字样必须放在  第一个位置，make.png
		{	
			"ui/teamActivity/make.png",
			"ui/teamActivity/exp.png",
			"ui/teamActivity/make_3.png",
		},		
		reward = "#c4d2308海量经验#r天令积分",		--副本奖励内容		
		challenge_dengji = "#c4d230852级",		--挑战等级		
		duiwu_num = "#c4d23082~5人",		-- 队伍人数		
		if_open = false,		--目前是否开放
	},

}