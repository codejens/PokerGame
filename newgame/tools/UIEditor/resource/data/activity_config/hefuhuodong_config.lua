--合服活动配置

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

hefuhuodong_config = {

	mini_title = {
		--活动小标题（上）,活动小副标题（下）,活动子id（对应下方activity_sub_id）
		-- {"充值回馈","充值送豪礼",2},
		-- {"登录好礼","登录送豪礼",998},
		-- {"合服首冲","首冲送惊喜",996},
		-- {"双倍福利","活动翻双倍",1000},
		-- {"战力悬赏","战力排行榜",6},
		-- {"至尊伙伴","宠物排行榜",6},
		-- {"阵营试炼","封魔战场榜",997},
		-- {"逐鹿中原","逐鹿中原榜",995},
		[1] = {iconPath = "ui/lh_chunjie/CJ_0002.png",txtPath="ui/lh_work/text_icon3.png",mainTitleContent = "红旗兑换",subTitleContent = "神技神装来袭",2},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_hefu/text2.png",mainTitleContent = "淘宝树",subTitleContent = "淘宝树淘宝树",998},
		[3] = {iconPath = "ui/lh_hefu/icon3.png",txtPath="ui/lh_hefu/text3.png",mainTitleContent = "每日消费",subTitleContent = "消费消费",996},
		[4] = {iconPath = "ui/lh_hefu/icon4.png",txtPath="ui/lh_hefu/text4.png",mainTitleContent = "每日限购",subTitleContent = "每日像狗",1000},
		[5] = {iconPath = "ui/lh_hefu/icon5.png",txtPath="ui/lh_hefu/text5.png",mainTitleContent = "累计登录",subTitleContent = "登录登录",6},
		[6] = {iconPath = "ui/lh_hefu/icon6.png",txtPath="ui/lh_hefu/text6.png",mainTitleContent = "超级团购",subTitleContent = "超级团购",6},
		[7] = {iconPath = "nopack/main/camp_icon.png",txtPath="ui/lh_hefu/text7.png",mainTitleContent = "双倍经验",subTitleContent = "经验来经验来",997},
		[8] = {iconPath = "nopack/main/tianyuan_icon.png",txtPath="ui/lh_hefu/text8.png",mainTitleContent = "天降宝箱",subTitleContent = "天降淘宝金币",995},
	},

	--充值回馈
	[1] = 
	{
		activity_sub_id = 2,--充值活动
		title_img_path = "ui/lh_hefu/title1.png",
		title = {"充值达到500元宝","充值达到2000元宝","充值达到5000元宝","充值达到10000元宝","充值达到20000元宝","充值达到30000元宝"},
		activity_time_str = "2015年2月18日00:01-2014年2月25日23:59",
		content = "活动期间，累计充值达到对应额度，均可领取超值好礼一份，心动不如行动吧。",
		{--累计充值500元宝礼包
			{ type = 0, id = 18227, count = 6},--铜钱通票
			{ type = 0, id = 18612, count = 2},--坐骑口粮
			{ type = 0, id = 18711, count = 3},--中级强化石
			{ type = 0, id = 18720, count = 2},--中级保护符
			{ type = 0, id = 18634, count = 1},--中级化羽技能书
			{ type = 0, id = 18604, count = 1},--中级美人玉
			{ type = 0, id = 18606, count = 5},--秦皇令
			{ type = 0, id = 18230, count = 1},--3级宝石礼包
		},
		{--累计充值2000元宝礼包
			{ type = 0, id = 18227, count = 10},--铜钱通票
			{ type = 0, id = 18634, count = 2},--中级化羽技能书
			{ type = 0, id = 18604, count = 2},--中级美人玉
			{ type = 0, id = 18612, count = 3},--坐骑口粮
			{ type = 0, id = 18711, count = 4},--中级强化石
			{ type = 0, id = 18720, count = 2},--中级保护符
			{ type = 0, id = 18606, count = 6},--秦皇令
			{ type = 0, id = 18230, count = 1},--3级宝石礼包
		},	
		{--累计充值5000元宝礼包
			{ type = 0, id = 18227, count = 15},--铜钱通票
			{ type = 0, id = 18604, count = 3},--中级美人玉
			{ type = 0, id = 18605, count = 1},--高级美人玉
			{ type = 0, id = 18612, count = 4},--坐骑口粮
			{ type = 0, id = 18712, count = 3},--高级强化石
			{ type = 0, id = 18721, count = 2},--高级保护符
			{ type = 0, id = 18606, count = 8},--秦皇令
			{ type = 0, id = 18231, count = 1},--4级宝石礼包
		},
		{--累计充值10000元宝礼包
			{ type = 0, id = 18227, count = 20},--铜钱通票
			{ type = 0, id = 18760, count = 2},--神佑符
			{ type = 0, id = 18605, count = 2},--高级美人玉
			{ type = 0, id = 18612, count = 6},--坐骑口粮
			{ type = 0, id = 18712, count = 6},--高级强化石
			{ type = 0, id = 18721, count = 4},--高级保护符
			{ type = 0, id = 18607, count = 5},--周王令
			{ type = 0, id = 18231, count = 1},--4级宝石礼包
		},
		{--累计充值20000元宝礼包
			{ type = 0, id = 18227, count = 25},--铜钱通票
			{ type = 0, id = 18750, count = 2},--血炼石
			{ type = 0, id = 18605, count = 8},--高级美人玉
			{ type = 0, id = 18612, count = 10},--坐骑口粮
			{ type = 0, id = 18713, count = 10},--特级强化石
			{ type = 0, id = 18722, count = 6},--特级保护符
			{ type = 0, id = 18607, count = 10},--周王令
			{ type = 0, id = 18231, count = 1},--4级宝石礼包
		},
		{--累计充值30000元宝礼包
			{ type = 0, id = 18227, count = 30},--铜钱通票
			{ type = 0, id = 18750, count = 3},--血炼石
			{ type = 0, id = 18605, count = 10},--高级美人玉
			{ type = 0, id = 18612, count = 12},--坐骑口粮
			{ type = 0, id = 18714, count = 5},--完美强化石
			{ type = 0, id = 18723, count = 5},--完美保护符
			{ type = 0, id = 18607, count = 12},--周王令
			{ type = 0, id = 18232, count = 1},--5级宝石礼包
		},
	},

	-- 登录好礼
	[2] = 
	{
		activity_sub_id = 998,
		title_img_path = "ui/lh_hefu/title2.png",
		activity_time_str = "合服后前七天",
		content = "合服活动期间，在合服前等级超过40级的玩家，登录游戏即可获得合服礼包，每个角色只可领取一次。",
		title = {"合服前等级≥40玩家即可领取"},
		{
			{ type = 0, id = 18711, count = 1},--中级强化石
			{ type = 0, id = 19301, count = 1},--中型气血包
			{ type = 0, id = 19201, count = 1},--中型法力包
			{ type = 0, id = 18210, count = 1},--初级经验丹
			{ type = 0, id = 64810, count = 1},--绑定元宝
			{ type = 0, id = 18227, count = 5},--招财神符
		},
	},

	-- 合服首冲
	[3] = 
	{
		activity_sub_id = 996,
		title_img_path = "ui/lh_hefu/title3.png",
		activity_time_str = "合服后前七天",
		content = "合服活动期间，玩家充值任意金额，即可领取合服首冲礼包。",
		title = {"充值任意金额可领取",},
		{
			{ type = 0, id = 18629, count = 1},--三阶羽翼晶石
			{ type = 0, id = 18634, count = 1},--中级羽翼技能卷
			{ type = 0, id = 18512, count = 1},--三级攻击宝石
			{ type = 0, id = 18612, count = 1},--坐骑进阶符
			{ type = 0, id = 18712, count = 1},--高级强化石
			{ type = 0, id = 18720, count = 1},--中级保护符
			{ type = 0, id = 18606, count = 1},--星蕴结晶
			{ type = 0, id = 18219, count = 1},--高级经验丹
		},		
	},
	-- 双倍福利
	[4] = 
	{
		activity_sub_id = 1000,
		title_img_path = "ui/lh_hefu/title4.png",
		activity_time_str = "合服后前七天",
		content = "在活动期间，指定时间内参与活动即可获得双倍经验，机不可失哦！",
		str = {	
			"智力答题 奖励加成100% 每天12:10-12:20与23:10-23:20",
			"押镖 奖励加成100% 全天",
			"英雄大宴 奖励加成100% 每天19:00-19:20",
			"翰皇虎符 奖励加成100% 每天19:30-20:00",
			"阵营之战 奖励加成100% 周一、周三、周五20:10-20:40",
			"打坐 奖励加成100% 全天",
		},	
	},
	[5] = 
	{
		activity_sub_id = 6,--排名活动
		title_img_path = "ui/lh_hefu/title5.png",
		title = {"战力榜第1名礼包","战力榜第2名礼包","战力榜第3名礼包","战力榜4~6名礼包","战力榜7~10名礼包"},
		activity_time_str = "合服后前七天",
		content = "合服活动结束后，战力排行榜达到前十名的玩家，即可获得礼包，赶紧提升战力吧！",
	    top_type = 1,
		[1] = {--1
			{ type = 0, id = 58214, count = 1},--5级宝石
			{ type = 0, id = 18404, count = 3},--至尊生命药水
			{ type = 0, id = 18621, count = 10},--天仙令
			{ type = 0, id = 18613, count = 10},--除魔令
			{ type = 0, id = 48296, count = 8},--解环石
			{ type = 0, id = 18609, count = 1},--9朵玫瑰
		},
		[2] = {--2
			{ type = 0, id = 58214, count = 1},--5级宝石
			{ type = 0, id = 18404, count = 2},--至尊生命药水
			{ type = 0, id = 18621, count = 8},--天仙令
			{ type = 0, id = 18613, count = 8},--除魔令
			{ type = 0, id = 48296, count = 7},--解环石
		},	
		[3] = {--3
			{ type = 0, id = 58214, count = 1},--5级宝石
			{ type = 0, id = 18404, count = 1},--至尊生命药水
			{ type = 0, id = 18621, count = 6},--天仙令
			{ type = 0, id = 18613, count = 6},--除魔令
			{ type = 0, id = 48296, count = 5},--解环石
		},	
		[4] = {--4
			{ type = 0, id = 58213, count = 1},--4级宝石
			{ type = 0, id = 18403, count = 2},--精装生命药水
			{ type = 0, id = 18621, count = 6},--天仙令
			{ type = 0, id = 18613, count = 6},--除魔令
			{ type = 0, id = 48296, count = 5},--解环石
		},
		[5] = {--5
			{ type = 0, id = 48261, count = 1},--3级宝石
			{ type = 0, id = 18403, count = 1},--精装生命药水
			{ type = 0, id = 18621, count = 5},--天仙令
			{ type = 0, id = 18613, count = 5},--除魔令
			{ type = 0, id = 48296, count = 4},--解环石
		},
	},	
	[6] = 
	{
		activity_sub_id = 6,--最佳伙伴
		title_img_path = "ui/lh_hefu/title6.png",
		title = {"伙伴榜第1名礼包","伙伴榜第2名礼包","伙伴榜第3名礼包","伙伴榜4~6名礼包","伙伴榜7~10名礼包"},
		activity_time_str = "合服后前七天",
		content = "合服活动结束后，伙伴排行榜达到前十名的玩家，即可获得礼包，赶紧提升您的小伙伴吧！。",
	    top_type = 10,
		[1] = {--1
			{ type = 0, id = 28245, count = 5},--唤魂玉
			{ type = 0, id = 19101, count = 5},--中级宠物长生丹
			{ type = 0, id = 18621, count = 10},--天仙令
			{ type = 0, id = 18613, count = 10},--除魔令
			{ type = 0, id = 48296, count = 10},--解环石
		},
		[2] = {--2
			{ type = 0, id = 28245, count = 4},--唤魂玉
			{ type = 0, id = 19101, count = 4},--中级宠物长生丹
			{ type = 0, id = 18621, count = 8},--天仙令
			{ type = 0, id = 18613, count = 8},--除魔令
			{ type = 0, id = 48296, count = 8},--解环石
		},	
		[3] = {--3
			{ type = 0, id = 28245, count = 3},--唤魂玉
			{ type = 0, id = 19101, count = 3},--中级宠物长生丹
			{ type = 0, id = 18621, count = 6},--天仙令
			{ type = 0, id = 18613, count = 6},--除魔令
			{ type = 0, id = 48296, count = 6},--解环石
		},	
		[4] = {--4
			{ type = 0, id = 28245, count = 2},--唤魂玉
			{ type = 0, id = 19101, count = 2},--中级宠物长生丹
			{ type = 0, id = 18621, count = 5},--天仙令
			{ type = 0, id = 18613, count = 5},--除魔令
			{ type = 0, id = 48296, count = 4},--解环石
		},	
		[5] = {--5
			{ type = 0, id = 28245, count = 1},--唤魂玉
			{ type = 0, id = 19101, count = 1},--中级宠物长生丹
			{ type = 0, id = 18621, count = 5},--天仙令
			{ type = 0, id = 18613, count = 5},--除魔令
			{ type = 0, id = 48296, count = 4},--解环石
		},		
	},
	[7] = 
	{
		activity_sub_id = 997,  --合服阵营试炼活动
		title_img_path = "ui/lh_hefu/title7.png",
		title = {"阵营之战第1名礼包","阵营之战第2名礼包","阵营之战第3名礼包","阵营之战4~6名礼包","阵营之战7~10名礼包"},
		activity_time_str = "合服后前七天",
		content = "合服活动期间，战场排行榜达到前十名的玩家，即可获得礼包，赶紧提升战力吧！",
		-- 合服阵营试炼的top_type只会用到一次
		top_type = 14,
		[1] = {--1
			{ type = 0, id = 11700, count = 1},--炫彩棒棒糖
			{ type = 0, id = 48278, count = 1},--20000威望丹
			{ type = 0, id = 18740, count = 5},--幽煌珠
			{ type = 0, id = 18730, count = 5},--焚离珠
			{ type = 0, id = 18606, count = 5},--星蕴结晶
			{ type = 0, id = 18607, count = 5},--月华梦境
		},
		[2] = {--2
			{ type = 0, id = 11700, count = 1},--炫彩棒棒糖
			{ type = 0, id = 48278, count = 1},--20000威望丹
			{ type = 0, id = 18740, count = 4},--幽煌珠
			{ type = 0, id = 18730, count = 4},--焚离珠
			{ type = 0, id = 18606, count = 4},--星蕴结晶
			{ type = 0, id = 18607, count = 4}--月华梦境
		},	
		[3] = {--3
			{ type = 0, id = 11700, count = 1},--炫彩棒棒糖
			{ type = 0, id = 48278, count = 1},--20000威望丹
			{ type = 0, id = 18740, count = 3},--幽煌珠
			{ type = 0, id = 18730, count = 3},--焚离珠
			{ type = 0, id = 18606, count = 3},--星蕴结晶
			{ type = 0, id = 18607, count = 3},--月华梦境
		},	
		[4] = {--3
			{ type = 0, id = 11700, count = 1},--炫彩棒棒糖
			{ type = 0, id = 48271, count = 1},--10000威望丹
			{ type = 0, id = 18740, count = 2},--幽煌珠
			{ type = 0, id = 18730, count = 2},--焚离珠
			{ type = 0, id = 18606, count = 2},--星蕴结晶
			{ type = 0, id = 18607, count = 2},--月华梦境
		},	
		[5] = {--3
			{ type = 0, id = 11700, count = 1},--炫彩棒棒糖
			{ type = 0, id = 64751, count = 1},--1000威望丹
			{ type = 0, id = 18740, count = 1},--幽煌珠
			{ type = 0, id = 18730, count = 1},--焚离珠
			{ type = 0, id = 18606, count = 1},--星蕴结晶
			{ type = 0, id = 18607, count = 1},--月华梦境
		},
	},	
	[8] = 
	{
		activity_sub_id = 995,  --合服逐鹿中原活动
		title_img_path = "ui/lh_hefu/title8.png",
		title = {"王城之战第1名世族主礼包","王城之战第1名世族成员礼包","王城之战2~5名世族成员礼包","王城之战6~10名世族成员礼包"},
		activity_time_str = "合服后前七天",
		content = "王城之战结束后，王城之战排行榜达到前十名的世族成员及第一名世族主可获得礼包奖励哦！",
		-- 合服阵营逐鹿中原的top_type只会用到一次
		top_type = 15,
		[1] = {--1
			{ type = 0, id = 48265, count = 1},--300000灵气丹
			{ type = 0, id = 18542, count = 2},--三级生命宝石
			{ type = 0, id = 18712, count = 5},--高级强化石
			{ type = 0, id = 18401, count = 5},--中级回血药
			{ type = 0, id = 19201, count = 5},--中级法力包
			{ type = 0, id = 19101, count = 5},--中级宠物长生丹
		},
		[2] = {--1
			{ type = 0, id = 18712, count = 3},--高级强化石
			{ type = 0, id = 18404, count = 3},--至尊生命药水
			{ type = 0, id = 19201, count = 3},--中级法力包
			{ type = 0, id = 19101, count = 3},--中级宠物长生丹
		},
		[3] = {--2
			{ type = 0, id = 18712, count = 2},--高级强化石
			{ type = 0, id = 18403, count = 3},--精装生命药水
			{ type = 0, id = 19201, count = 2},--中级法力包
			{ type = 0, id = 19101, count = 2},--中级宠物长生丹
		},	
		[4] = {--3
			{ type = 0, id = 18712, count = 1},--高级强化石
			{ type = 0, id = 18403, count = 1},--精装生命药水
			{ type = 0, id = 19201, count = 1},--中级法力包
			{ type = 0, id = 19101, count = 1},--中级宠物长生丹
		},		
	},					
}