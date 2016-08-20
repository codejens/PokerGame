--ValentineWhiteDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

QingmingDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_chunjie/CJ_icon_0004.png",mainTitleContent = "累计登录",subTitleContent = "登录登录"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0001.png",txtPath="ui/lh_chunjie/CJ_icon_0001.png",mainTitleContent = "淘宝树",subTitleContent = "淘宝树淘宝树"},
		[3] = {iconPath = "ui/lh_chunjie/CJ_0002_1.png",txtPath="ui/lh_activity_cmmon/QM_icon_0003.png",mainTitleContent = "累计消费",subTitleContent = "累计消费。"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_chunjie/CJ_icon_0005.png",mainTitleContent = "超级团购",subTitleContent = "超级团购"},
	},
	
	--子活动页面数据
	pageDataGroup = {

		--累计登录页面
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/QM_subtitle1.png" ,
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
					[2] = {awardId = 18227,count = 1},
					[3] = {awardId = 18613,count = 3},
					[4] = {awardId = 18621,count = 3},
					[5] = {awardId = 18609,count = 1},
				},
				--第二行
				[2] = {
					[1] = {awardId = 44488,count = 2},
					[2] = {awardId = 18227,count = 2},
					[3] = {awardId = 18600,count = 2},
					[4] = {awardId = 18403,count = 2},
					[5] = {awardId = 18211,count = 1},
				},
				--第三行
				[3] = {
					[1] = {awardId = 44488,count = 4},
					[2] = {awardId = 18227,count = 3},
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

		--淘宝树
		[2] = {
			-- titleImagePath_1 ="ui/lh_activity_cmmon/activity_t_1.png" ,
			-- titleImageSize_1 = {width = 91,height = 33},
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/QM_subtitle2.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，通过打开【淘宝树】界面，可以参与抽奖，更有机会获得超级伙伴—百战天女陪你闯荡边关，纵横西域无人可挡！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 34441,isEffect = false},
				[2] =  {awardId = 11657,isEffect = false},
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
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/QM_subtitle3.png" ,
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
					[1] = {awardId = 60148,count = 1},
				},
				[2] = {
					[1] = {awardId = 60149,count = 1},
				},
				[3] = {
					[1] = {awardId = 60150,count = 1},
				},
				[4] = {
					[1] = {awardId = 60151,count = 1},
				},
				[5] = {
					[1] = {awardId = 60152,count = 1},
				},
				[6] = {
					[1] = {awardId = 60153,count = 1 },
				},
				[7] = {
					[1] = {awardId = 60154,count = 1 },
				},
				[8] = {
					[1] = {awardId = 60155,count = 1 },
				},

			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 888,
				[2] = 2888,
				[3] = 4888,
				[4] = 9888,
				[5] = 19888,
				[6] = 29888,
				[7] = 49888,
				[8] = 79888,
			},
			--标题组
			itemTitleGroup = {
				[1] = "累计消费达到888元宝",
				[2] = "累计消费达到2888元宝",
				[3] = "累计消费达到4888元宝",
				[4] = "累计消费达到9888元宝",
				[5] = "累计消费达到19888元宝",
				[6] = "累计消费达到29888元宝",
				[7] = "累计消费达到49888元宝",
				[8] = "累计消费达到79888元宝",
			},
		},


--超级团购页面
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/QM_subtitle4.png" ,
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