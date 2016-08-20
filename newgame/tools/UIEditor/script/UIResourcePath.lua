----------------------------------------
-----------------------HJH 2013-7-3
-----------------------UI资源路径前序

require '../data/layouts/mainLayouts'


UIResourcePath = {}
-----------------------
UIResourcePath.FileFontLocate = "ui/"
-----------------------common


UIResourcePath.FileLocate = {
	achieveAndGoal = 		UIResourcePath.FileFontLocate .. "achieveandgoal/",	----成就与目标
	activity =				UIResourcePath.FileFontLocate .. "activity/",			----
	bagAndCangKu = 			UIResourcePath.FileFontLocate .. "bagandcangku/",	----背包与仓库
	business = 				UIResourcePath.FileFontLocate .. "business/",			----交易
	camp = 					UIResourcePath.FileFontLocate .. "camp/",				----阵营
	chat = 					UIResourcePath.FileFontLocate .. "chat/",				----聊天
	chongZhi =				UIResourcePath.FileFontLocate .. "chongzhi/",			----充值
	common = 				UIResourcePath.FileFontLocate .. "common/",				----公用
	douFaTai =	 			UIResourcePath.FileFontLocate .. "doufatai/",			----斗法台
	dreamLand = 			UIResourcePath.FileFontLocate .. "dreamland/",
	duJie = 				UIResourcePath.FileFontLocate .. "dujie/",				----渡劫
	exchange =				UIResourcePath.FileFontLocate .. "exchange/",			----兑换
	faBao = 				UIResourcePath.FileFontLocate .. "fabao/",				----法宝
	fightValue = 			UIResourcePath.FileFontLocate .. "fightvalue/",			----战斗力
	flower = 				UIResourcePath.FileFontLocate .. "flower/",				----鲜花
	fontEffect = 			UIResourcePath.FileFontLocate .. "fonteffect/",			----字体特效
	forge = 				UIResourcePath.FileFontLocate .. "forge/",				----炼器
	friend = 				UIResourcePath.FileFontLocate .. "friend/",				----好友
	fuBen = 				UIResourcePath.FileFontLocate .. "fuben/",				----副本
	guild = 				UIResourcePath.FileFontLocate .. "guild/", 				----仙宗
	hsxn = 					UIResourcePath.FileFontLocate .. "hsxn/",				----仙女护送
	mail = 					UIResourcePath.FileFontLocate .. "mail/", 				----邮件
	main = 					UIResourcePath.FileFontLocate .. "main/",
	mainnopack =            UIResourcePath.FileFontLocate .. "mainnopack/",
	mall = 					UIResourcePath.FileFontLocate .. "mall/",				----商城
	menus = 				UIResourcePath.FileFontLocate .. "menus/",
	mount = 				UIResourcePath.FileFontLocate .. "mount/",				----坐骑
	normal = 				UIResourcePath.FileFontLocate .. "normal/",				----
	npcTitle =	 			UIResourcePath.FileFontLocate .. "npctitle/",			----NPC标题
	openSer = 				UIResourcePath.FileFontLocate .. "openser/",			----开服活动
	other = 				UIResourcePath.FileFontLocate .. "other/",				----其它
	passwordSet = 			UIResourcePath.FileFontLocate .. "passwordset/",		----密码设置
	pet = 					UIResourcePath.FileFontLocate .. "pet/",				----宠物
	qianDao = 				UIResourcePath.FileFontLocate .. "qiandao/",			----签到
	role = 					UIResourcePath.FileFontLocate .. "role/",				----角色
	sclb = 					UIResourcePath.FileFontLocate .. "sclb/",				----首冲礼包
	secretary = 			UIResourcePath.FileFontLocate .. "secretary/",			----小秘书
	shop = 					UIResourcePath.FileFontLocate .. "shop/", 				----商店
	skill = 				UIResourcePath.FileFontLocate .. "skill/",				----技能
	systemSet =	 			UIResourcePath.FileFontLocate .. "systemset/",			----系统设置
	task = 					UIResourcePath.FileFontLocate .. "task/",				----任务
	title = 				UIResourcePath.FileFontLocate .. "title/",				----标题
	topList = 				UIResourcePath.FileFontLocate .. "toplist/",			----排行榜
	tzfl = 					UIResourcePath.FileFontLocate .. "tzfl/",				----投资返利
	vip = 					UIResourcePath.FileFontLocate .. "vip/",				----VIP
	weiTuo = 				UIResourcePath.FileFontLocate .. "weituo/",				----委托
	welfare = 				UIResourcePath.FileFontLocate .. "welfare/",			----福利
	wing = 					UIResourcePath.FileFontLocate .. "wing/",				----翅膀
	zhaoCai = 				UIResourcePath.FileFontLocate .. "zhaocai/",			----招财
	notes   = 				UIResourcePath.FileFontLocate .. "notes/",				----信号，电源
	mainMenu = 				UIResourcePath.FileFontLocate .. "mainmenu/",			----功能菜单
	mainActivity = 			UIResourcePath.FileFontLocate .. "mainactivity/",		----功能菜单
	newactivity = 			UIResourcePath.FileFontLocate .. "newactivity/",		----功能菜单
	question =				UIResourcePath.FileFontLocate .. "question/",			----答题活动
	npc = 					UIResourcePath.FileFontLocate .. "npc/",				----npc半身相和名字
	jiShou = 				UIResourcePath.FileFontLocate .. "jishou/",				----寄售
	caiquan = 				UIResourcePath.FileFontLocate .. "caiquan/",			-- 猜拳
	ph = 					UIResourcePath.FileFontLocate .. "ph/",					-- 跑环
	operationAct = 			UIResourcePath.FileFontLocate .. "operation_act/",		-- 运营活动
	plant = 				UIResourcePath.FileFontLocate .. "plant/",				-- 种植
	marriage = 				UIResourcePath.FileFontLocate .. "marriage/",			-- 结婚系统  
	xiandaohui = 			UIResourcePath.FileFontLocate .. "xiandaohui/",			-- 仙道会
	miyou	 = 				UIResourcePath.FileFontLocate .. "miyou/",				-- 密友
	zhanbu = 				UIResourcePath.FileFontLocate .. "zhanbu/",				-- 占卜
	qqvip = 				UIResourcePath.FileFontLocate .. "qqvip/",				-- qq蓝钻
	huanledou = 			UIResourcePath.FileFontLocate .. "hld/",				-- 欢乐斗
	pay   = 				UIResourcePath.FileFontLocate .. "pay/",				-- 支付
	buykey = 				UIResourcePath.FileFontLocate .. "buykey/",			-- 购买
	sevenDayAward = 		UIResourcePath.FileFontLocate .. "sevenDayAward/",		--
	luopan = 				UIResourcePath.FileFontLocate .. "luopan/",				-- 罗盘
	dailyActivity = 		UIResourcePath.FileFontLocate .. "dailyActivity/",		-- 日常活动

	tuangou = 				UIResourcePath.FileFontLocate .. "tuangou/",		-- 团购
	llk     = 				UIResourcePath.FileFontLocate .. "llk/",		-- 连连看小游戏
	PushBox     = 			UIResourcePath.FileFontLocate .. "PushBox/",	-- 推箱子小游戏
	QQactive     = 			UIResourcePath.FileFontLocate .. "QQactive/",	-- QQ活动
	-- wardrobe     = 			UIResourcePath.FileFontLocate .. "wardrobe/",	-- 衣柜系统
	jubaobag     = 			UIResourcePath.FileFontLocate .. "jubaobag/",	-- 聚宝袋
	
	renwu     = 			UIResourcePath.FileFontLocate .. "renwu/",	    -- 任务属性
	transform	=			UIResourcePath.FileFontLocate .. "transform/", 	-- 变身系统
	genius	=			    UIResourcePath.FileFontLocate .. "geniues/", 	-- 变身系统
	linggen =				UIResourcePath.FileFontLocate .. "linggen/",	-- 灵根
	lh_other = 				UIResourcePath.FileFontLocate .. "lh_other/",
	zycm =					UIResourcePath.FileFontLocate .. "zycm/",		-- 斩妖除魔
	lh_other = 				UIResourcePath.FileFontLocate .. "lh_other/",
	lh_main = 				UIResourcePath.FileFontLocate .. "lh_main/",-- 主界面相关资源
	lh_mainmenu = 			UIResourcePath.FileFontLocate .. "lh_mainmenu/",-- 主界面相关资源
	lh_doufatai	=			UIResourcePath.FileFontLocate .. "lh_doufatai/",-- 斗法台相关资源	
	lh_jishou	=			UIResourcePath.FileFontLocate .. "lh_jishou/", 		-- 寄售
	lh_chat		=			UIResourcePath.FileFontLocate .. "lh_chat/", 		-- 地图
	lh_friend	=			UIResourcePath.FileFontLocate .. "lh_friend/", 		-- 地图
	lh_zhaocai	=			UIResourcePath.FileFontLocate .. "lh_zhaocai/", 	-- 招财
	lh_righttop	=			UIResourcePath.FileFontLocate .. "lh_righttop/",
	lh_pet	=				UIResourcePath.FileFontLocate .. "lh_pet/",			-- 宠物
	lh_fuben	=			UIResourcePath.FileFontLocate .. "lh_fuben/",
	lh_benefit =			UIResourcePath.FileFontLocate .. "lh_benefit/",		----活动大厅
	lh_role		= 			UIResourcePath.FileFontLocate .. "lh_role/",		----活动大厅
	lh_normal	= 			UIResourcePath.FileFontLocate .. "lh_normal/",
	lh_marriage 	= 		UIResourcePath.FileFontLocate .. "lh_marriage/",	-- 结婚系统
	lh_juxianling	= 			UIResourcePath.FileFontLocate .. "lh_juxianling/",	-- 聚仙令
}