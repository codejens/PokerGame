--NewLonelyDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

SummerDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0002.png",txtPath="ui/lh_summer/text1.png",mainTitleContent = "红旗兑换",subTitleContent = "神技神装来袭"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_summer/text2.png",mainTitleContent = "淘宝树",subTitleContent = "淘宝树淘宝树"},
		[3] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_summer/text3.png",mainTitleContent = "每日消费",subTitleContent = "消费消费"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0001.png",txtPath="ui/lh_summer/text4.png",mainTitleContent = "每日限购",subTitleContent = "每日像狗"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0002_1.png",txtPath="ui/lh_summer/text5.png",mainTitleContent = "累计登录",subTitleContent = "登录登录"},
	},
	
	--子活动页面数据
	pageDataGroup = {
		-- 每日首冲
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_summer/title1.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年9月29日00:01-2014年10月3日23:59",
			--活动说明
			describe = "活动期间,在游戏中累计充值足够金额，即可在该面板领取丰厚大奖！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 60180,count = 1},
				},

			},
			--目标充值数额
			rechargeCountGroup = {
				[1] = 10,
			},
			--标题组
			itemTitleGroup = {
				[1] = "累计充值达到158元宝",
			},
		},

		--累计登录页面
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_summer/title2.png" ,
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
					[1] = {awardId = 44488,count = 1},
					[2] = {awardId = 48284,count = 1},
					[3] = {awardId = 18613,count = 3},
					[4] = {awardId = 18621,count = 3},
					[5] = {awardId = 18609,count = 1},
				},
				--第二行
				[2] = {
					[1] = {awardId = 44488,count = 2},
					[2] = {awardId = 48284,count = 2},
					[3] = {awardId = 18600,count = 2},
					[4] = {awardId = 18403,count = 2},
					[5] = {awardId = 18211,count = 1},										
				},
				--第三行
				[3] = {
					[1] = {awardId = 44488,count = 4},
					[2] = {awardId = 48284,count = 3},
					[3] = {awardId = 18600,count = 3},
					[4] = {awardId = 18403,count = 3},
					[5] = {awardId = 18211,count = 2},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每天登录可领取",
				[2] = "累计登录3天可领取",
				[3] = "累计登录5天可领取",
			},
		},

		--超级团购页面
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_summer/title3.png" ,
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

		--淘宝树
		[4] = {
			--标题路径
			titleImagePath = "ui/lh_summer/title4.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，通过打开【淘宝树】界面，可以参与抽奖，更有机会获得永久坐骑-紫电追风羚！陪你闯荡边关，纵横西域无人可挡！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 34885,isEffect = false},
				[2] =  {awardId = 34942,isEffect = false},
				[3] =  {awardId = 18513,isEffect = false},
				[4] =  {awardId = 18543,isEffect = false},
				[5] =  {awardId = 18521,isEffect = false},
				[6] =  {awardId = 28231,isEffect = false},
				[7] =  {awardId = 18522,isEffect = false},
				[8] =  {awardId = 18612,isEffect = false},
				[9] =  {awardId = 18611,isEffect = false},
				[10] =  {awardId = 18740,isEffect = false},
				[11] =  {awardId = 18730,isEffect = false},
				[12] =  {awardId = 18712,isEffect = false},

			},
					--场景信息
		    sceneInfo = {sceneId = 3,sceneX = 130,sceneY = 63},
		},

		-- 累计消费数据
		[5] = {
			--标题路径
			titleImagePath = "ui/lh_summer/title5.png",
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年9月29日00:01-2014年10月3日23:59",
			--活动说明
			describe = "活动期间,在游戏中累计消费足够金额，即可在该面板领取丰厚大奖！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 60167,count = 1},
				},
				[2] = {
					[1] = {awardId = 60168,count = 1},
				},
				[3] = {
					[1] = {awardId = 60169,count = 1},
				},
				[4] = {
					[1] = {awardId = 60170,count = 1},
				},
				[5] = {
					[1] = {awardId = 60171,count = 1},
				},
				[6] = {
					[1] = {awardId = 60172,count = 1 },
				},
				[7] = {
					[1] = {awardId = 60173,count = 1 },
				},
			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 688,
				[2] = 2488,
				[3] = 5888,
				[4] = 11888,
				[5] = 26888,
				[6] = 54888,
				[7] = 98888,
			},
			--标题组
			itemTitleGroup = {
				[1] = "累计消费达到688元宝",
				[2] = "累计消费达到2488元宝",
				[3] = "累计消费达到5888元宝",
				[4] = "累计消费达到11888元宝",
				[5] = "累计消费达到26888元宝",
				[6] = "累计消费达到54888元宝",
				[7] = "累计消费达到98888元宝",
			},
		},
	}
}