--LanternDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

LanternDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0000.png",txtPath="ui/lh_activity_cmmon/YX_icon_0000.png",mainTitleContent = "红旗兑换",subTitleContent = "神技神装来袭"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0007.png",txtPath="ui/lh_chunjie/CJ_icon_0007.png",mainTitleContent = "天降宝箱",subTitleContent = "天降淘宝金币"},
		[3] = {iconPath = "ui/lh_chunjie/CJ_0002_1.png",txtPath="ui/lh_chunjie/CJ_icon_0002_1.png",mainTitleContent = "每日消费",subTitleContent = "每日消费。"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_chunjie/CJ_icon_0005.png",mainTitleContent = "超级团购",subTitleContent = "超级团购"},
	},
	
	--子活动页面数据
	pageDataGroup = {
	    --红旗兑换
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/YX_subtitle1.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2014年2月25日23:59",
			--活动说明
			describe = "活动期间，通过【元宵节活动】的其它活动可以收集到【汤圆】，然后在本界面下方可兑换超值奖励，极品装备，珍稀道具。",

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
				[1] = {awardId = 18227,count = 1},
				--第二行
				[2] = {awardId = 18609,count = 2},
				--第三行
				[3] = {awardId = 18612,count = 5},
				[4] = {awardId = 18721,count = 5},
				[5] = {awardId = 18614,count = 1},
				[6] = {awardId = 34883,count = 1},
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
				[1] = 1,
				[2] = 3,
				[3] = 20,
				[4] = 40,
				[5] = 88,
				[6] = 250,
			},
			--兑换后获得的ID
			exchangeIdGroup = {
				[1] = 18227,
				[2] = 18609,
				[3] = 18612,
				[4] = 18721,
				[5] = 18614,
				[6] = 34883,
			},
		},	

	
		-- 天降宝箱
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/YX_subtitle2.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2015年2月25日23:59",
			--活动说明
			describe = "在活动期间，每日11点、16点30、18点、21点30将会在雁门关刷新大量宝箱，采集可获得奖励",
			--奖励
			awardGroup = {
				[1] =  {awardId = 60067,isEffect = false},
				[2] =  {awardId = 18608,isEffect = false},
				[3] =  {awardId = 18618,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
			--场景信息
			sceneInfo = {sceneId = 3,sceneX = 97,sceneY = 86},
		},
			--每日消费页面
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/YX_subtitle3.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年9月29日00:01-2014年10月3日23:59",
			--活动说明
			describe = "活动期间,在游戏中每日累计消费足够金额，即可在该面板领取丰厚大奖！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 60067,count = 4},
					[2] = {awardId = 18720,count = 2},
					[3] = {awardId = 18711,count = 1},
					[4] = {awardId = 18227,count = 2},
					[5] = {awardId = 18609,count = 4},
				},
				[2] = {
					[1] = {awardId = 18720,count = 4},
					[2] = {awardId = 18711,count = 2},
					[3] = {awardId = 18616,count = 1},
					[4] = {awardId = 18612,count = 4},
					[5] = {awardId = 48284,count = 4},
				},
				[3] = {
					[1] = {awardId = 18720,count = 8},
					[2] = {awardId = 18711,count = 4},
					[3] = {awardId = 18616,count = 3},
					[4] = {awardId = 18612,count = 10},
					[5] = {awardId = 48284,count = 8},
				},
				[4] = {
					[1] = {awardId = 18721,count = 8},
					[2] = {awardId = 18712,count = 4},
					[3] = {awardId = 18616,count = 3},
					[4] = {awardId = 18604,count = 4},
					[5] = {awardId = 48284,count = 10},
				},
				[5] = {
					[1] = {awardId = 18722,count = 2},
					[2] = {awardId = 18713,count = 1},
					[3] = {awardId = 18615,count = 1},
					[4] = {awardId = 18605,count = 2},
					[5] = {awardId = 48284,count = 8},
				},
				[6] = {
					[1] = {awardId = 18722,count = 3},
					[2] = {awardId = 18713,count = 1},
					[3] = {awardId = 18615,count = 1},
					[4] = {awardId = 18605,count = 2},
					[5] = {awardId = 48284,count = 8},
				},
				[7] = {
					[1] = {awardId = 18722,count = 6 },
					[2] = {awardId = 18713,count = 3},
					[3] = {awardId = 18615,count = 2 },
					[4] = {awardId = 18605,count = 4 },
					[5] = {awardId = 48284,count = 12},
				},

			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 500,
				[2] = 1500,
				[3] = 4000,
				[4] = 8000,
				[5] = 12000,
				[6] = 18000,
				[7] = 32000,
			},
			--标题组
			itemTitleGroup = {
				[1] = "每日消费达到500元宝",
				[2] = "每日消费达到1500元宝",
				[3] = "每日消费达到4000元宝",
				[4] = "每日消费达到8000元宝",
				[5] = "每日消费达到12000元宝",
				[6] = "每日消费达到18000元宝",
				[7] = "每日消费达到36000元宝",
			},
		},

-- 超级团购页面
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/YX_subtitle4.png" ,
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




	}
}