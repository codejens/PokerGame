--ValentineDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

VersionCelebrationParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_activity_vc/icon1.png",txtPath="ui/lh_activity_vc/text1.png",mainTitleContent = "修复雁门关",subTitleContent = "修复雁门关"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_chunjie/CJ_icon_0005.png",mainTitleContent = "超级团购",subTitleContent = "超级团购"},
		[3] = {iconPath = "ui/lh_work/shenshu.png",txtPath="ui/lh_work/text_icon6.png",mainTitleContent = "昆仑神树",subTitleContent = "昆仑神树"},
		[4] = {iconPath = "ui/lh_activity_vc/icon4.png",txtPath="ui/lh_activity_vc/text4.png",mainTitleContent = "特惠礼包",subTitleContent = "特惠礼包"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_chunjie/CJ_icon_0004.png",mainTitleContent = "累计登录",subTitleContent = "登录登录"},
		[6] = {iconPath = "ui/lh_chunjie/CJ_0007.png",txtPath="ui/lh_chunjie/CJ_icon_0007.png",mainTitleContent = "天降宝箱",subTitleContent = "天降淘宝金币"},
	},
	
	--子活动页面数据
	pageDataGroup = {
		-- 幸运转盘
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_activity_vc/subtitle1.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，玩家只要参与修复雁门关即可获得物品奖励。",
			--奖励
			awardGroup = {
				[1] =  {awardId =  18616,isEffect = false},
				[2] =  {awardId =  28231,isEffect = false},
				[3] =  {awardId =  28221,isEffect = false},
				[4] =  {awardId =  18730,isEffect = false},
				[5] =  {awardId =  18721,isEffect = false},
				[6] =  {awardId =  18605,isEffect = false},
				[7] =  {awardId =  18712,isEffect = false},
				[8] =  {awardId =  18602,isEffect = false},
				[9] =  {awardId =  18713,isEffect = false},
				[10] =  {awardId = 18615,isEffect = false},
				[11] =  {awardId = 18722,isEffect = false},
				[12] =  {awardId = 18750,isEffect = false},
			},
		},

		--超级团购页面
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_activity_vc/subtitle2.png" ,
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

		-- 幸运转盘
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_activity_vc/subtitle3.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，帮昆仑神树浇水、种果子可得秘籍",
			--奖励
			awardGroup = {
				[1] =  {awardId = 34942,isEffect = false},
				[2] =  {awardId = 34943,isEffect = false},
				[3] =  {awardId = 39606,isEffect = false},
				[4] =  {awardId = 39605,isEffect = false},
				[5] =  {awardId = 18730,isEffect = false},
				[6] =  {awardId = 18740,isEffect = false},
				[7] =  {awardId = 18610,isEffect = false},
				[8] =  {awardId = 28237,isEffect = false},
				[9] =  {awardId = 28227,isEffect = false},
				[10] =  {awardId = 18232,isEffect = false},
				[11] =  {awardId = 28222,isEffect = false},
				[12] =  {awardId = 58213,isEffect = false},
			},
		},

				-- 幸运转盘
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_activity_vc/subtitle4.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "特惠礼包狂欢，极品买买买！！！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 18740,isEffect = false},
				[2] =  {awardId = 18730,isEffect = false},
				[3] =  {awardId = 18750,isEffect = false},
			},
		},

		--累计登录页面
		[5] = {
			--标题路径
			titleImagePath ="ui/lh_activity_vc/subtitle5.png" ,
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
					[1] = {awardId = 18210,count = 2},
					[2] = {awardId = 19301,count = 2},
					[3] = {awardId = 18613,count = 3},
					[4] = {awardId = 18621,count = 3},
				},
				--第二行
				[2] = {
					[1] = {awardId = 18210,count = 2},
					[2] = {awardId = 19301,count = 2},
					[3] = {awardId = 18600,count = 3},
					[4] = {awardId = 18603,count = 3},
				},
				--第三行
				[3] = {
					[1] = {awardId = 18211,count = 2},
					[2] = {awardId = 19301,count = 2},
					[3] = {awardId = 18633,count = 2},
					[4] = {awardId = 48261,count = 1},
					[5] = {awardId = 18609,count = 1},
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
		[6] = {
			--标题路径
			titleImagePath ="ui/lh_activity_vc/subtitle6.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2015年2月25日23:59",
			--活动说明
			describe = "在活动期间，每日11点、16点30、18点、21点30将会在雁门关刷新大量宝箱，采集可获得奖励",
			--奖励
			awardGroup = {
				[1] =  {awardId = 19300,isEffect = false},
				[2] =  {awardId = 18608,isEffect = false},
				[3] =  {awardId = 18618,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
			--场景信息
			sceneInfo = {sceneId = 3,sceneX = 97,sceneY = 86},
		},
	}
}