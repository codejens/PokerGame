--新年活动礼包配置

-- activity_sub_id 活动子id   大运营活动里面有多个活动,里面每个活动都有个子活动id 
-- 1000以下的是服务器控制的活动,1000以上的为客户端控制的活动
-- 1.登录活动
-- 2.充值活动,多礼包
-- 3.消费活动,多礼包
-- 4.每日充值,单礼包
-- 5.每日消费,单礼包
-- 6.排行榜活动
-- 7.充值活动,重复单礼包
-- 8.消费活动,重复单礼包
-- 9.每日充值,多礼包
-- 10.每日消费,多礼包
-- 11.登录有礼
-- 12.日常累积活动
-- 13.每日登录有礼活动 (1-13对应协议 138,80)
-- 24:圣诞送礼活动(对应协议 138,96)
-- 995:合服逐鹿中原活动(对应协议　149,7)
-- 996:合服首冲活动(对应协议　149,5)
-- 997:合服阵营试炼活动(对应协议　149,3)
-- 998:合服登录活动(对应协议　149,1)
-- 999:情人元宵活动(对应协议 151,2)     
-- 1000:只有文字(无需协议)  1001:只有图片(无需协议) 1002以上的都是只有道具(无需协议)

-- title_img_path:界面右上角的标题对应的资源名
-- title:界面右下滑动区域内每一排的标题文字(例如:消费达到xxx元宝,登录x天礼包)
-- activity_time_str:界面右上角的活动时间文字(例如:2014年01月15日10:00—2014年01月19日23:59)
-- content:界面右上角的说明文字
-- img:1001活动特有的字段,宣传图对应的资源名
-- top_type:子活动id6排名榜活动特有的字段 1-10分别代表
-- 排名活动类型     
-- rtFightVal = 1, // 战力排行
-- rtLevel = 2,	// 等级排行
-- rtRoot = 3,		// 灵根排行
-- rtAchieve = 4,	// 成就排行
-- rtMount = 5,	// 坐骑排行
-- rtGem = 6,		// 法宝排行
-- rtCharm = 7,	// 魅力排行
-- rtCharmWeek = 8,// 每周魅力排行
-- rtWing = 9,		// 翅膀排行榜
-- rtPet = 10,		// 宠物排行榜

xinnianactivity_config = {

	mini_title = {
		{"福利临门","消费送豪礼",3},--活动小标题（上）,活动小副标题（下）,活动子id（对应下方activity_sub_id）
		{"新春贺礼","每日有好礼",1},
		{"新春宝树","幸运大抽奖",1002},
		{"双倍惊喜","双倍翻不停",1000},
		{"新年副本","惊喜掉不停",1003},
		{"怪物入侵","精英强入侵",1001},
	},

	--消费回馈礼包显示道具列表
	[1] = 
	{
		activity_sub_id = 3,
		title_img_path = "xiaofeihuikui.png",
		title = {"消费达到888元宝","消费达到2588元宝","消费达到5288元宝","消费达到9888元宝","消费达到19888元宝","消费达到39888元宝","消费达到88888元宝","消费达到128888元宝"},
		activity_time_str = "2014年01月25日10:00—2014年02月03日23:59",
		content = "在活动期间，消费数额累计达到指定金额，就能领取超值豪华消费大礼包。",
		{--888元宝礼包（消费迷你包）
			{type = 0, id = 18711,count = 2},
			{type = 0, id = 18720,count = 3},
			{type = 0, id = 18612,count = 2},
			{type = 0, id = 18603,count = 3},
			{type = 0, id = 18750,count = 2},
			{type = 0, id = 18227,count = 3},

		},
		{--2588元宝礼包（消费小型包）
			{type = 0, id = 18711,count = 3},
			{type = 0, id = 18720,count = 5},
			{type = 0, id = 18612,count = 5},
			{type = 0, id = 18603,count = 2},
			{type = 0, id = 18604,count = 2},
			{type = 0, id = 18750,count = 3},
			{type = 0, id = 18227,count = 5},
		},	
		{--5288元宝礼包（消费中型包）
			{ type = 0, id = 18711, count = 8},
			{ type = 0, id = 18720, count = 10},
			{ type = 0, id = 18612, count = 8},
			{ type = 0, id = 18604, count = 3},
			{ type = 0, id = 18605, count = 3},
			{ type = 0, id = 18750, count = 5},
			{ type = 0, id = 18227, count = 10},
		},	
		{--9888元宝礼包（消费大型包）
			{type = 0, id = 18712,count = 6},
			{type = 0, id = 18721,count = 8},
			{type = 0, id = 18612,count = 10},
			{type = 0, id = 18604,count = 8},
			{type = 0, id = 18605,count = 8},
			{type = 0, id = 18750,count = 5},
			{type = 0, id = 18227,count = 20},
		},	
		{--19888元宝礼包（消费巨型包）
			{type = 0, id = 18713,count = 6},
			{type = 0, id = 18722,count = 8},
			{type = 0, id = 28231,count = 6},
			{type = 0, id = 28236,count = 8},
			{type = 0, id = 28221,count = 6},
			{type = 0, id = 28226,count = 8},
			{type = 0, id = 18750,count = 5},
			{type = 0, id = 18227,count = 30},

		},	
		{--39888元宝礼包（消费豪华包）
			{type = 0, id = 18713,count = 15},
			{type = 0, id = 18722,count = 20},
			{type = 0, id = 28232,count = 6},
			{type = 0, id = 28237,count = 8},
			{type = 0, id = 28222,count = 6},
			{type = 0, id = 28227,count = 8},
			{type = 0, id = 18750,count = 10},
			{type = 0, id = 18227,count = 50},
		},
		{--88888元宝礼包（消费超级包）
			{type = 0, id = 18714,count = 12},
			{type = 0, id = 18723,count = 16},
			{type = 0, id = 28233,count = 6},
			{type = 0, id = 28238,count = 8},
			{type = 0, id = 28223,count = 6},
			{type = 0, id = 28228,count = 8},
			{type = 0, id = 18750,count = 10},
			{type = 0, id = 18227,count = 80},
		},
		{--128888元宝礼包（消费至尊包）
			{type = 0, id = 18714,count = 18},
			{type = 0, id = 18723,count = 20},
			{type = 0, id = 28233,count = 8},
			{type = 0, id = 28238,count = 10},
			{type = 0, id = 28223,count = 8},
			{type = 0, id = 28228,count = 10},
			{type = 0, id = 18830,count = 5},
			{type = 0, id = 18227,count = 99},
		},
	},

	--连续登录道具列表
	[2] = 
	{
		activity_sub_id = 1,
		title_img_path = "meirihaoli.png",
		title = {"每日登录红包","登录第2天礼包","登录第4天礼包","登录第6天礼包"},
		activity_time_str = "2014年01月25日10:00—2014年02月03日23:59",
		content = "在活动期间，每日上线登录，即可领取登录礼包，连续登录还可以领取额外的节日礼包。",
		{--每日登录红包
			{ type = 0, id = 64777, count = 1},--新年红包
			{ type = 0, id = 18711, count = 1},--中级强化石
			{ type = 0, id = 18613, count = 10},--除魔令
			{ type = 0, id = 18621, count = 5},--天仙令
			{ type = 0, id = 18601, count = 5},--筋斗云
		},
		{--登录2天礼包
			{ type = 0, id = 28220, count = 1},--初级悟性丹
			{ type = 0, id = 28230, count = 1},--初级成长丹
			{ type = 0, id = 18720, count = 1},--中级保护符
			{ type = 0, id = 19301, count = 1},--中级生命包
			{ type = 0, id = 18211, count = 1},--中级经验丹
		},
		{--登录4天礼包
			{ type = 0, id = 21651, count = 1},--金风玉露(2天)
			{ type = 0, id = 28221, count = 1},--中级悟性丹
			{ type = 0, id = 28231, count = 1},--中级成长丹
			{ type = 0, id = 18628, count = 1},--二阶羽翼晶石
			{ type = 0, id = 18612, count = 1},--坐骑进阶符
			{ type = 0, id = 19101, count = 1},--中级宠物长生丹
		},
		{--登录6天礼包
			{ type = 0, id = 21652, count = 1},--金风玉露(7天)
			{ type = 0, id = 18219, count = 1},--高级经验丹
			{ type = 0, id = 18604, count = 2},--中级法宝晶石
			{ type = 0, id = 48261, count = 1},--3级宝石
			{ type = 0, id = 18711, count = 2},--中级强化石
			{ type = 0, id = 18227, count = 10},--招财神符
		},
	},
	
	--淘宝树可获道具列表（界面中6*3显示）
	[3] = 
	{
		activity_sub_id = 1002,
		title_img_path = "xinchunbaoshu.png",
		activity_time_str = "2014年01月25日10:00—2014年02月03日23:59",
		content = "在活动期间，通过抽淘宝树，就有机会获得#cffc000完美·马上宠物蛋#cffffff、#cffc000永久新年礼服#cffffff等大量稀有道具。",
		npc_pos = {sceneid = 11,x = 93,y = 72},
	--在大面板里显示排序，罗盘里的显示顺序另外取GoldenCompass.txt
		{ type = 0, id = 64788, count = 1},--如意蛋
		{ type = 0, id = 21601, count = 1},--新春贺喜
		{ type = 0, id = 18730, count = 1},--焚离珠
		{ type = 0, id = 18740, count = 1},--幽煌珠
		{ type = 0, id = 18616, count = 1},--三级宝石
		{ type = 0, id = 18617, count = 1},--二级宝石
		{ type = 0, id = 18618, count = 1},--一级宝石
		{ type = 0, id = 28226, count = 1},--中级悟性保护珠
		{ type = 0, id = 28236, count = 1},--中级成长保护珠
		{ type = 0, id = 28221, count = 1},--中级悟性丹
		{ type = 0, id = 28231, count = 1},--中级成长丹
		{ type = 0, id = 28220, count = 1},--初级悟性丹
		--{ type = 0, id = 28230, count = 1},--初级成长丹
		--{ type = 0, id = 18604, count = 1},--中级法宝晶石
		--{ type = 0, id = 18603, count = 1},--初级法宝晶石
		--{ type = 0, id = 18612, count = 1},--坐骑进阶符
		--{ type = 0, id = 18720, count = 1},--中级保护符
		--{ type = 0, id = 18227, count = 1},--招财神符
	},	

	--双倍经验
	[4] = 
	{
		activity_sub_id = 1000,
		title_img_path = "shuangbeijingxi.png",
		activity_time_str = "2014年01月25日10:00—2014年02月03日23:59",
		content = "在活动期间，指定时间内参与活动即可获得双倍经验，机不可失哦！",
		str = {	"智力答题 奖励加成100% 每天12:10-12:20，23:10-23:20"
		},
		
	},

	--新年副本可获道具列表（界面中6*3显示）
	[5] = 
	{
		activity_sub_id = 1003,
		title_img_path = "xinchunfuben.png",
		activity_time_str = "2014年01月25日10:00—2014年02月03日23:59",
		content = "在活动期间，每日可从天元城“#c38ff33新年副本#cffffff”处进入新年副本，#c38ff33每天可进入2次#cffffff，副本中可掉落各类珍品道具！",
		npc_pos = {sceneid = 11,x = 97,y = 86},
		{ type = 0, id = 38212, count = 1},--卓越·欢庆舞狮
		{ type = 0, id = 18740, count = 1},--幽煌珠
		{ type = 0, id = 18730, count = 1},--焚离珠
		{ type = 0, id = 48261, count = 1},--3级宝石
		{ type = 0, id = 44488, count = 1},--淘宝币	
		{ type = 0, id = 18211, count = 1},--中级经验丹		
		{ type = 0, id = 18711, count = 1},--中级强化石
		{ type = 0, id = 18720, count = 1},--中级保护符	
		{ type = 0, id = 18618, count = 1},--一级宝石		
		{ type = 0, id = 18710, count = 1},--初级强化石		
		{ type = 0, id = 18603, count = 1},--初级法宝晶石
		{ type = 0, id = 28220, count = 1},--初级悟性丹

	},	
	--BOSS挑战可获道具列表（界面中6*3显示）
	[6] = 
	{
		activity_sub_id = 1001,
		title_img_path = "guaiwuruqing.png",
		activity_time_str = "2014年01月25日10:00—2014年02月03日23:59",
		content = "在活动期间，每天#c38ff3311:00、16:30、18:00、22:30#cffffff在#cff66cc北冰原#cffffff随机地方刷出精英怪，击杀有概率掉落#cff66cc淘宝币#cffffff哦！。",
		img = { "bsrx.jpg" },

	},	
}