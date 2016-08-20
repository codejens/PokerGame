--ValentineWhiteDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

ValentineWhiteDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0001.png",txtPath="ui/lh_chunjie/CJ_icon_0001.png",mainTitleContent = "淘宝树",subTitleContent = "淘宝树淘宝树"},
		[2] = {iconPath = "ui/lh_lonely/send_flower.png",txtPath="ui/lh_lonely/title1.png",mainTitleContent = "送花排行榜",subTitleContent = "送花排行榜"},		
		[3] = {iconPath = "ui/lh_lonely/receive_flower.png",txtPath="ui/lh_lonely/title2.png",mainTitleContent = "收花排行榜",subTitleContent = "收花排行榜"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_chunjie/CJ_icon_0004.png",mainTitleContent = "累计登录",subTitleContent = "登录登录"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_chunjie/CJ_icon_0005.png",mainTitleContent = "超级团购",subTitleContent = "超级团购"},
	},
	
	--子活动页面数据
	pageDataGroup = {

		--淘宝树
		[1] = {
			-- titleImagePath_1 ="ui/lh_activity_cmmon/activity_t_1.png" ,
			-- titleImageSize_1 = {width = 91,height = 33},
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/BL_subtitle1.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，通过打开【淘宝树】界面，可以参与抽奖，更有机会获得超级伙伴—虞美人陪你闯荡边关，纵横西域无人可挡！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 34440,isEffect = false},
				[2] =  {awardId = 18612,isEffect = false},
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

		-- 送花排行榜页面
		[2] = {

			-- titleImagePath_1 ="ui/lh_lonely/send_flower.png" ,
			-- titleImageSize_1 = {width = 91,height = 33},


			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/BL_subtitle2.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年12月23日00:01-2014年12月25日23:59",
			--活动说明
			describe = "活动期间，玩家只需要向他人赠送鲜花就会进行送花统计！并且还可以得到以下相对应的奖励。奖励将由邮件自动下发！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第一行
				[1] = {
					[1] = {awardId = 60094,count = 1},
				},
				--第二行
				[2] = {
					[1] = {awardId = 60093,count = 1},
				},
				--第三行
				[3] = {
					[1] = {awardId = 60098,count = 1},
				},
				--第4行
				[4] = {
					[1] = {awardId = 18634,count = 2},
					[2] = {awardId = 18612,count = 4},
					[3] = {awardId = 48284,count = 10},
				},
				--第5行
				[5] = {
					[1] = {awardId = 18635,count = 4},
					[2] = {awardId = 18612,count = 10},
					[3] = {awardId = 48284,count = 16},
					[4] = {awardId = 18404,count = 8},
				},
				--第6行
				[6] = {
					[1] = {awardId = 58213,count = 2},
					[2] = {awardId = 18635,count = 4},
					[3] = {awardId = 18612,count = 12},
					[4] = {awardId = 48284,count = 18},
					[5] = {awardId = 18404,count = 10},
				},
				--第7行
				[7] = {
					[1] = {awardId = 58214,count = 1 },
					[2] = {awardId = 18740,count = 3 },
					[3] = {awardId = 18730,count = 3 },
					[4] = {awardId = 18635,count = 4 },
					[5] = {awardId = 18612,count = 12},
					[6] = {awardId = 48284,count = 18},
					[7] = {awardId = 18404,count = 10},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "送花排行榜第一名奖励",
				[2] = "送花排行榜第二名奖励",
				[3] = "送花排行榜第三名奖励",
				[4] = "累计送花1000朵",
				[5] = "累计送花5000朵",
				[6] = "累计送花15000朵",
				[7] = "累计送花30000朵",
			},
		},

		-- 收花排行榜页面
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/BL_subtitle3.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年12月23日00:01-2014年12月25日23:59",
			--活动说明
			describe = "活动期间，玩家只要收到鲜花就会进行收花统计！并且还可以得到以下相对应的奖励。奖励将由邮件自动下发！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第一行
				[1] = {
					[1] = {awardId = 14406,count = 5},
					[2] = {awardId = 18227,count = 18},
					[3] = {awardId = 18606,count = 16},
					[4] = {awardId = 18600,count = 8},
					[5] = {awardId = 18404,count = 8},
				},
				--第二行
				[2] = {
					[1] = {awardId = 14406,count = 2},
					[2] = {awardId = 18227,count = 8},	
					[3] = {awardId = 18606,count = 8},	
					[4] = {awardId = 18600,count = 5},	
					[5] = {awardId = 18404,count = 4},
				},
				--第三行
				[3] = {
					[1] = {awardId = 14406,count = 1},
					[2] = {awardId = 18227,count = 6},
					[3] = {awardId = 18606,count = 4},
					[4] = {awardId = 18600,count = 3},
					[5] = {awardId = 18404,count = 2},
				},
				--第4行
				[4] = {
					[1] = {awardId = 14406,count = 1},
					[2] = {awardId = 18606,count = 4},
					[3] = {awardId = 18600,count = 3},
					[4] = {awardId = 18404,count = 2},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "收花排行榜第1名",
				[2] = "收花排行榜第2名",
				[3] = "收花排行榜第3名",
				[4] = "收花排行榜第4-10名",
			},
		},

		--累计登录页面
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/BL_subtitle4.png" ,
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
					[2] = {awardId = 18609,count = 1},
					[3] = {awardId = 18613,count = 5},
					[4] = {awardId = 18621,count = 3},
				},
				--第二行
				[2] = {
					[1] = {awardId = 44488,count = 2},
					[2] = {awardId = 18609,count = 2},
					[3] = {awardId = 18600,count = 3},
					[4] = {awardId = 18603,count = 3},
				},
				--第三行
				[3] = {
					[1] = {awardId = 44488,count = 4},
					[2] = {awardId = 18609,count = 2},
					[3] = {awardId = 18612,count = 3},
					[4] = {awardId = 48261,count = 1},
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
		[5] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/BL_subtitle5.png" ,
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