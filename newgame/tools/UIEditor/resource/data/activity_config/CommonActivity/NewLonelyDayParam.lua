--NewLonelyDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

LonelyDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0000.png",txtPath="ui/lh_chunjie/CJ_icon_0000.png",mainTitleContent = "红旗兑换",subTitleContent = "神技神装来袭"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0001.png",txtPath="ui/lh_chunjie/CJ_icon_0001.png",mainTitleContent = "淘宝树",subTitleContent = "淘宝树淘宝树"},
		[3] = {iconPath = "ui/lh_chunjie/CJ_0002.png",txtPath="ui/lh_chunjie/CJ_icon_0002.png",mainTitleContent = "每日消费",subTitleContent = "消费消费"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0003.png",txtPath="ui/lh_chunjie/CJ_icon_0003.png",mainTitleContent = "每日限购",subTitleContent = "每日像狗"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_chunjie/CJ_icon_0004.png",mainTitleContent = "累计登录",subTitleContent = "登录登录"},
		[6] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_chunjie/CJ_icon_0005.png",mainTitleContent = "超级团购",subTitleContent = "超级团购"},
		[7] = {iconPath = "ui/lh_chunjie/CJ_0006.png",txtPath="ui/lh_chunjie/CJ_icon_0006.png",mainTitleContent = "双倍经验",subTitleContent = "经验来经验来"},
		[8] = {iconPath = "ui/lh_chunjie/CJ_0007.png",txtPath="ui/lh_chunjie/CJ_icon_0007.png",mainTitleContent = "天降宝箱",subTitleContent = "天降淘宝金币"},
		[9] = {iconPath = "ui/lh_chunjie/CJ_0008.png",txtPath="ui/lh_chunjie/CJ_icon_0008.png",mainTitleContent = "Boss袭礼",subTitleContent = "天降淘宝金币"},
	},
	
	--子活动页面数据
	pageDataGroup = {
	    --红旗兑换
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0000.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2014年2月25日23:59",
			--活动说明
			describe = "活动期间，通过【春节活动】的其它活动可以收集到【红包】，然后在本界面下方可兑换超值奖励，极品装备，珍稀道具。",

			-- title_page = "XXXXXXXXXXXXXXXXXXXXXXX",

				--奖励上面的小标题
			itemTitleGroup = {
				[1] = "兑换可以获得以下奖励",
				[2] = "兑换可以获得以下奖励",
				[3] = "兑换可以获得以下奖励",
				[4] = "兑换可以获得以下奖励",
				[5] = "兑换可以获得以下奖励",
				[6] = "兑换可以获得以下奖励",
			},


			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第一行
				[1] = {awardId = 44488,count = 1},
				--第二行
				[2] = {awardId = 18609,count = 2},
				--第三行
				[3] = {awardId = 18721,count = 5},
				[4] = {awardId = 18712,count = 5},
				[5] = {awardId = 18614,count = 1},
				[6] = {awardId = 34880,count = 1},
			},

		--兑换标题
			exchangeTitleGroup = {
				[1] = "需要扣除雪花",
				[2] = "需要扣除雪花",
				[3] = "需要扣除雪花",
				[4] = "需要扣除雪花",
				[5] = "需要扣除雪花",
				[6] = "需要扣除雪花",
			},
			--兑换数量
			exchangeCountGroup = {
				[1] = 2,
				[2] = 3,
				[3] = 40,
				[4] = 45,
				[5] = 88,
				[6] = 250,
			},
			--兑换后获得的ID
			exchangeIdGroup = {
				[1] = 44488,
				[2] = 18609,
				[3] = 18721,
				[4] = 18712,
				[5] = 18614,
				[6] = 60095,
			},
		},	

		--淘宝树
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0001.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，通过打开【淘宝树】界面，可以参与抽奖，更有机会获得超级伙伴—功夫熊猫！国宝陪你闯荡边关，纵横西域无人可挡！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 38206,isEffect = false},
				[2] =  {awardId = 60067,isEffect = false},
				[3] =  {awardId = 18513,isEffect = false},
				[4] =  {awardId = 18543,isEffect = false},
				[5] =  {awardId = 18521,isEffect = false},
				[6] =  {awardId = 28231,isEffect = false},
				[7] =  {awardId = 18522,isEffect = false},
				[8] =  {awardId = 18634,isEffect = false},
				[9] =  {awardId = 18631,isEffect = false},
				[10] =  {awardId = 18740,isEffect = false},
				[11] =  {awardId = 18730,isEffect = false},
				[12] =  {awardId = 18712,isEffect = false},

			},
					--场景信息
		    sceneInfo = {sceneId = 3,sceneX = 130,sceneY = 63},
		},

		--每日消费页面
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0002.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年9月29日00:01-2014年10月3日23:59",
			--活动说明
			describe = "活动期间,在游戏中每日充值累计足够金额，即可在该面板领取丰厚大奖！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 60118,count = 1},
				},
				[2] = {
					[1] = {awardId = 60119,count = 1},
				},
				[3] = {
					[1] = {awardId = 60120,count = 1},
				},
				[4] = {
					[1] = {awardId = 60121,count = 1},
				},
				[5] = {
					[1] = {awardId = 60122,count = 1},
				},
				[6] = {
					[1] = {awardId = 60123,count = 1},
				},
				[7] = {
					[1] = {awardId = 60124,count = 1},
				},
				[8] = {
					[1] = {awardId = 60125,count = 1},
				},
				[9] = {
					[1] = {awardId = 60126,count = 1},
				},
			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 99,
				[2] = 588,
				[3] = 1588,
				[4] = 5888,
				[5] = 15888,
				[6] = 15888,
				[7] = 98888,
				[8] = 158888,
				[9] = 200000,
			},
			--标题组
			itemTitleGroup = {
				[1] = "累计充值达到99元宝",
				[2] = "累计充值达到588元宝",
				[3] = "累计充值达到1588元宝",
				[4] = "累计充值达到5888元宝",
				[5] = "累计充值达到15888元宝",
				[6] = "累计充值达到58888元宝",
				[7] = "累计充值达到98888元宝",
				[8] = "累计充值达到158888元宝",
				[9] = "累计充值达到200000元宝",
			},
		},

		--每日限购活动页面
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0003.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，玩家可以在游戏内直接抢购限量礼包，机不可失，失不再来。",
			--奖励上面的小标题
			itemTitleGroup = {
				[1] = "购买后获得以下【全部】内容", 
			    [2] = "购买后获得以内容【之一】"
			},
			--奖励
			-- awardGroup = {
			-- 	[1] = {      --实惠奖励
			-- 		[1] =  {awardId = 18531,count = 10},
			-- 		[2] =  {awardId = 18531,count = 10},
			-- 		[3] =  {awardId = 18531,count = 1}
			-- 	},
   --              [2] = {      --超值奖励
   --              	[1] =  {awardId = 18531,count = 1},
   --              	[2] =  {awardId = 18600,count = 2},
   --              	[3] =  {awardId = 18531,count = 3},
   --              	[4] =  {awardId = 18600,count = 4},
   --              	[5] =  {awardId = 18600,count = 5},
   --              	[6] =  {awardId = 18600,count = 5}
   --          	}
			-- },
			awardGroup = {
				[1] =  {awardId = 18612,isEffect = false},
				[2] =  {awardId = 64700,isEffect = false},
				[3] =  {awardId = 18711,isEffect = false},
				[4] =  {awardId = 18720,isEffect = false},
				[5] =  {awardId = 28232,isEffect = false},
				[6] =  {awardId = 28237,isEffect = false},
				[7] =  {awardId = 28222,isEffect = false},
				[8] =  {awardId = 28227,isEffect = false},
				[9] =  {awardId = 18604,isEffect = false},
				[10] =  {awardId = 18605,isEffect = false},
				[11] =  {awardId = 18628,isEffect = false},
				[12] =  {awardId = 18635,isEffect = false},
			},


		},

		--累计登录页面
		[5] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0004.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--标题图片大小
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，每日登录游戏都能领取一个【每日礼包】！累计足够的登录天数，更可以获得对应天数的登录奖励！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 60067,count = 1},
					[2] = {awardId = 44488,count = 1},
					[3] = {awardId = 18613,count = 5},
					[4] = {awardId = 18621,count = 3},
				},
				--第二行
				[2] = {
					[1] = {awardId = 60067,count = 2},
					[2] = {awardId = 44488,count = 1},
					[3] = {awardId = 18600,count = 3},
					[4] = {awardId = 18603,count = 3},
				},
				--第三行
				[3] = {
					[1] = {awardId = 60067,count = 4},
					[2] = {awardId = 44488,count = 2},
					[3] = {awardId = 18612,count = 3},
					[4] = {awardId = 24444,count = 2},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每天登录可领取",
				[2] = "累计登录3天可领取",
				[3] = "累计登录7天可领取",
			},
		},

--超级团购页面
		[6] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0005.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，玩家在游戏内购买礼包可获得世族积分，世族积分排名前三名可获得奖励！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 18600,count = 1},
					[2] = {awardId = 18600,count = 1},
					[3] = {awardId = 18613,count = 5},
					[4] = {awardId = 18621,count = 3},
					[5] = {awardId = 18227,count = 5},
				},
				--第二行
				[2] = {
					[1] = {awardId = 18600,count = 2},
					[2] = {awardId = 18600,count = 2},
					[3] = {awardId = 18612,count = 2},
					[4] = {awardId = 18603,count = 2},
					[5] = {awardId = 18628,count = 2},
				},
				--第三行
				[3] = {
					[1] = {awardId = 18600,count = 3},
					[2] = {awardId = 18600,count = 3},
					[3] = {awardId = 48261,count = 1},
					[4] = {awardId = 18711,count = 4},
					[5] = {awardId = 18720,count = 3},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每天登录可领取",
				[2] = "累计登录3天可领取",
				[3] = "累计登录5天可领取",
			},
		},



--双倍经验页面
		[7] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0006.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，以下活动产出的经验加倍！",

			-- 双倍经验说明（特殊）
			desc_ex = "#cd0cda2以下活动产出经验翻倍#r英雄大宴 获得经验增加100%。#r翰皇虎符 获得经验增加100%。#r阵营之战 获得经验增加100%。#r护送镖车 获得经验增加100%。#r智力答题 获得经验增加100%。",

			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 18600,count = 1},
					[2] = {awardId = 18600,count = 1},
					[3] = {awardId = 18613,count = 5},
					[4] = {awardId = 18621,count = 3},
					[5] = {awardId = 18227,count = 5},
				},
				--第二行
				[2] = {
					[1] = {awardId = 18600,count = 2},
					[2] = {awardId = 18600,count = 2},
					[3] = {awardId = 18612,count = 2},
					[4] = {awardId = 18603,count = 2},
					[5] = {awardId = 18628,count = 2},
				},
				--第三行
				[3] = {
					[1] = {awardId = 18600,count = 3},
					[2] = {awardId = 18600,count = 3},
					[3] = {awardId = 48261,count = 1},
					[4] = {awardId = 18711,count = 4},
					[5] = {awardId = 18720,count = 3},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每天登录可领取",
				[2] = "累计登录3天可领取",
				[3] = "累计登录5天可领取",
			},
		},

		
		--天降宝箱
		[8] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0007.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2015年2月25日23:59",
			--活动说明
			describe = "在活动期间，每日11点、16点30、18点、21点30将会在雁门关刷新大量宝箱，采集可获得奖励",
			--奖励
			awardGroup = {
				[1] =  {awardId = 60067,isEffect = false},
				[2] =  {awardId = 44488,isEffect = false},
				[3] =  {awardId = 18618,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
			--场景信息
			sceneInfo = {sceneId = 3,sceneX = 97,sceneY = 86},
		},

		--BOSS袭礼页面
		[9] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0008.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2015年2月25日23:59",
			--活动说明
			describe = "在活动期间，每日下午15:30点、夜晚22:30将会在指定地图刷新世界boss，击杀后会刷新宝箱，采集可获得大礼！先到先得，手快有手慢无！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 60067,isEffect = false},
				[2] =  {awardId = 44488,isEffect = false},
				[3] =  {awardId = 18618,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
					--场景信息
		  sceneInfo = {sceneId = 7, sceneX = 13,sceneY = 82},
		},

	}
}