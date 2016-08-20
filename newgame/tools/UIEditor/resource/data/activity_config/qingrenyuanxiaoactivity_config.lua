--元宵活动礼包配置

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

qryxactivity_conf = {

	mini_title = {
		{"超值回馈","消费送豪礼",3},--活动小标题（上）,活动小副标题（下）,活动子id（对应下方activity_sub_id）
		{"甜蜜惊喜","登录送好礼",1},
		{"幸运转盘","幸运大抽奖",1002},
		{"咱们结婚吧","次数翻不停",1001},
		{"感恩献爱","每日献真情",999},
		{"鲜花达人","魅力大比拼",6},
	},

	--消费回馈礼包显示道具列表
	[1] = 
	{
		activity_sub_id = 3,
		title_img_path = "xiaofeihuikui.png",
		title = {"消费达到498元宝","消费达到998元宝","消费达到2588元宝","消费达到5888元宝","消费达到12888元宝","消费达到39888元宝"},
		activity_time_str = "2014年02月12日10:00—2014年02月16日23:59",
		content = "在活动期间，消费数额累计达到指定金额，就能领取超值豪华消费大礼包。",
		{--迷你消费礼包
			{ type = 0, id = 18711, count = 3},
			{ type = 0, id = 18720, count = 5},
			{ type = 0, id = 18603, count = 2},
			{ type = 0, id = 18604, count = 2},
			{ type = 0, id = 18605, count = 2},
			{ type = 0, id = 18227, count = 5},
		},
		{--小型消费礼包
			{ type = 0, id = 18711, count = 6},
			{ type = 0, id = 18720, count = 8},
			{ type = 0, id = 18603, count = 3},
			{ type = 0, id = 18604, count = 3},
			{ type = 0, id = 18605, count = 3},
			{ type = 0, id = 18227, count = 10},
		},	
		{--中型消费礼包
			{ type = 0, id = 18740, count = 2},
			{ type = 0, id = 18730, count = 2},
			{ type = 0, id = 18711, count = 8},
			{ type = 0, id = 18720, count = 10},
			{ type = 0, id = 18603, count = 5},
			{ type = 0, id = 18604, count = 5},
			{ type = 0, id = 18605, count = 5},
			{ type = 0, id = 18227, count = 15},
		},	
		{--大型消费包
			{ type = 0, id = 18740, count = 3},
			{ type = 0, id = 18730, count = 3},
			{ type = 0, id = 18711, count = 15},
			{ type = 0, id = 18720, count = 20},
			{ type = 0, id = 18603, count = 10},
			{ type = 0, id = 18604, count = 10},
			{ type = 0, id = 18605, count = 10},
			{ type = 0, id = 18227, count = 20},
		},	
		{--巨型消费包
			{ type = 0, id = 18740, count = 5},
			{ type = 0, id = 18730, count = 5},
			{ type = 0, id = 18712, count = 15},
			{ type = 0, id = 18721, count = 20},
			{ type = 0, id = 18603, count = 15},
			{ type = 0, id = 18604, count = 15},
			{ type = 0, id = 18605, count = 15},
			{ type = 0, id = 18227, count = 30},
		},	
		{--超级消费包
			{ type = 0, id = 18740, count = 15},
			{ type = 0, id = 18730, count = 15},
			{ type = 0, id = 18713, count = 20},
			{ type = 0, id = 18722, count = 25},
			{ type = 0, id = 18603, count = 30},
			{ type = 0, id = 18604, count = 30},
			{ type = 0, id = 18605, count = 30},
			{ type = 0, id = 18227, count = 50},
		},
	},

	--连续登录道具列表
	[2] = 
	{
		activity_sub_id = 1,
		title_img_path = "meirihaoli.png",
		title = {"元宵每日礼包","登录第2天礼包","登录第4天礼包"},
		activity_time_str = "2014年02月12日10:00—2014年02月16日23:59",
		content = "在活动期间，每日上线登录，即可领取登录礼包，连续登录还可以领取额外的节日礼包。",
		{--每日登录红包
			{ type = 0, id = 64715, count = 1},--幸运结晶
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
	},
	
	--幸运转盘可获道具列表（界面中6*3显示）
	[3] = 
	{
		activity_sub_id = 1004,
		title_img_path = "xingyunzuanpan.png",
		activity_time_str = "2014年02月12日10:00—2014年02月16日23:59",
		content = "在活动期间，通过抽幸运转盘，就有机会获得#cffc000特级保护符#cffffff、#cff66cc炫彩棒棒糖#cffffff、#cff66cc紫微极玉#cffffff等大量稀有道具。",
	--在大面板里显示排序，罗盘里的显示顺序另外取GoldenCompass.txt
		{id = 18722, count = 1, istreasure=true},--特级保护符
		{id = 11700, count = 1, istreasure=true},--炫彩棒棒糖（小）
		{id = 18750, count = 1, istreasure=true},--紫微极玉	
		{id = 64713, count = 1, istreasure=true},--神秘钥匙
		{id = 64750, count = 1, istreasure=false},--20000灵气丹
		{id = 18721, count = 1, istreasure=true},--高级保护符
		{id = 18712, count = 1, istreasure=true},--高级强化石
		{id = 18720, count = 1, istreasure=false},--中级保护符
		{id = 18711, count = 1, istreasure=false},--中级强化石
		{id = 18404, count = 1, istreasure=false},--至尊生命药水
		{id = 18605, count = 1, istreasure=false},--高级法宝晶石
		{id = 18604, count = 1, istreasure=false},--中级法宝晶石
	},	

	--咱们结婚吧
	[4] = 
	{
		activity_sub_id = 1001,
		title_img_path = "zanmenjiehunba.png",
		activity_time_str = "2014年02月12日10:00—2014年02月16日23:59",
		content = "在活动期间，每日的#cff66cc豪华婚宴#cffffff和#cff66cc云游巡车#cffffff数翻倍，赶快来参与吧！",
		img = { "zmjhb.jpg" },

	},

	--感恩献爱
	[5] = 
	{
		activity_sub_id = 999,
		title_img_path = "ganenxianai.png",
		title = {"赠送9朵玫瑰，可获得爱情礼包*1","赠送99朵玫瑰，可获得浓情礼盒*1","赠送999朵玫瑰，可获得真情礼包*1"},
		activity_time_str = "2014年02月12日10:00—2014年02月16日23:59",
		content = "在活动期间，向心爱的人赠送鲜花即可获得相对应的礼盒，每天先领取一次，机不可失哦！",
		{--9朵玫瑰礼包
			{ type = 0, id = 18211, count = 1},--中级经验丹
			{ type = 0, id = 19301, count = 1},--中级生命包
			{ type = 0, id = 19201, count = 1},--中级法力包
			{ type = 0, id = 18600, count = 1},--复活石
		},
		{--99朵玫瑰礼包
			{ type = 0, id = 18219, count = 3},--高级经验丹
			{ type = 0, id = 28209, count = 3},--高级灵气丹
			{ type = 0, id = 14408, count = 1},--幻梦之心
			{ type = 0, id = 18404, count = 3},--至尊生命药水
		},
		{--999朵玫瑰礼包
			{ type = 0, id = 18711, count = 6},--中级强化石
			{ type = 0, id = 18720, count = 10},--中级保护符
			{ type = 0, id = 14408, count = 3},--梦幻之心
			{ type = 0, id = 18404, count = 5},--至尊生命药水
			{ type = 0, id = 18740, count = 1},--焚离珠
			{ type = 0, id = 18730, count = 1},--幽煌珠
		},

	},	

	--鲜花达人
	[6] = 
	{
		activity_sub_id = 6,--排名活动
		title_img_path = "xianhuadaren.png",
		title = {"周魅力排行第1名","周魅力排行第2名","周魅力排行第3名","周魅力排行第4-6名","周魅力排行第7-10名"},
		activity_time_str = "2014年02月12日10:00—2014年02月16日23:59",
		content = "在活动结束后，魅力周排行榜上排名前十的玩家，就能领取超值礼包奖励。",
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
	    top_type = 8,
		[1] = {--1
			{ type = 0, id = 18740, count = 5},
			{ type = 0, id = 18730, count = 5},
			{ type = 0, id = 18219, count = 1},
			{ type = 0, id = 18607, count = 2},
			{ type = 0, id = 18610, count = 1},
		},
		[2] = {--2
			{ type = 0, id = 18740, count = 2},
			{ type = 0, id = 18730, count = 2},
			{ type = 0, id = 18219, count = 1},
			{ type = 0, id = 18606, count = 2},
		},	
		[3] = {--3
			{ type = 0, id = 18740, count = 1},
			{ type = 0, id = 18730, count = 1},
			{ type = 0, id = 18219, count = 1},
		},	
		[4] = {--4
			{ type = 0, id = 18711, count = 2},
			{ type = 0, id = 28231, count = 2},
			{ type = 0, id = 28221, count = 2},
		},	
		[5] = {--5
			{ type = 0, id = 18711, count = 2},
			{ type = 0, id = 18604, count = 2},
		},	
	},	
}