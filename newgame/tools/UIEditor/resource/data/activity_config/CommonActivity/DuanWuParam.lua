--DuanWuParam.lua
--内容：端午节活动的配置参数
--作者：陈亮
--时间：2014.10.27

DuanWuParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0005.png",txtPath="ui/lh_chunjie/CJ_icon_0005.png",mainTitleContent = "超级团购",subTitleContent = "超级团购"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0002.png",txtPath="ui/lh_work/text_icon3.png",mainTitleContent = "充值活动",subTitleContent = "充值活动"},
		[3] = {iconPath = "ui/lh_chunjie/CJ_0001.png",txtPath="ui/lh_chunjie/CJ_icon_0001.png",mainTitleContent = "淘宝树",subTitleContent = "淘宝树"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_chunjie/CJ_icon_0004.png",mainTitleContent = "登录活动",subTitleContent = "登录活动"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0007.png",txtPath="ui/lh_chunjie/CJ_icon_0007.png",mainTitleContent = "天降宝箱",subTitleContent = "天降宝箱"},
		[6] = {iconPath = "ui/lh_duanwu/meili_icon.png",txtPath="ui/lh_duanwu/meili_txt.png",mainTitleContent = "魅力排行",subTitleContent = "魅力排行"},
	},
	
	--子活动页面数据
	pageDataGroup = {
		-- 超级团购页面
		[1] = {
			--标题路径
			titleImagePath = "nopack/BigImage/duanwu_img.png" ,
			--标题图片大小
			titleImageSize = {width = 635, height = 100},
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

		--累计充值页面
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_duanwu/duanwu_img.png" ,
			--标题图片大小
			titleImageSize = {width = 635, height = 100},
			--活动时间
			activityTime = "2015年6月19日00:01-2015年6月21日23:59",
			--活动说明
			describe = "活动期间,在游戏中充值累计足够金额，即可在该面板领取丰厚大奖！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 48261,count = 1}, 
					[2] = {awardId = 18711,count = 1},
					[3] = {awardId = 18609,count = 1},
				},
				[2] = {
					[1] = {awardId = 48261,count = 1},
					[2] = {awardId = 18740,count = 2},
					[3] = {awardId = 18730,count = 2},
				},
				[3] = {
					[1] = {awardId = 11702,count = 1},
					[2] = {awardId = 18721,count = 2},
					[3] = {awardId = 18740,count = 2},
					[4] = {awardId = 18730,count = 2},
				},
				[4] = {
					[1] = {awardId = 18750,count = 1},
					[2] = {awardId = 48271,count = 1},
					[3] = {awardId = 18740,count = 2},
					[4] = {awardId = 18730,count = 2},
				},
				[5] = {
					[1] = {awardId = 18750,count = 2},
					[2] = {awardId = 58213,count = 1},
					[3] = {awardId = 18740,count = 3},
					[4] = {awardId = 18730,count = 3},
				},
				[6] = {
					[1] = {awardId = 18750,count = 3},
					[2] = {awardId = 18721,count = 2},
					[3] = {awardId = 18740,count = 3},
					[4] = {awardId = 18730,count = 3},
				},
				[7] = {
					[1] = {awardId = 18750,count = 4},
					[2] = {awardId = 58213,count = 1},
					[3] = {awardId = 18712,count = 2},
					[4] = {awardId = 18721,count = 2},
					[5] = {awardId = 18610,count = 1},
					[6] = {awardId = 18830,count = 1},
				},
				[8] = {
					[1] = {awardId = 18750,count = 5},
					[2] = {awardId = 58214,count = 1},
					[3] = {awardId = 18713,count = 3},
					[4] = {awardId = 18722,count = 3},
					[5] = {awardId = 48265,count = 1},
					[6] = {awardId = 18830,count = 1},
				},
				[9] = {
					[1] = {awardId = 18750,count = 5},
					[2] = {awardId = 58214,count = 1},
					[3] = {awardId = 18713,count = 5},
					[4] = {awardId = 18722,count = 5},
					[5] = {awardId = 48278,count = 1},
					[6] = {awardId = 18830,count = 3},
				},
			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 80,
				[2] = 300,
				[3] = 600,
				[4] = 980,
				[5] = 1980,
				[6] = 3280,
				[7] = 6480,
				[8] = 8880,
				[9] = 18000,
			},
			--标题组
			itemTitleGroup = {
				[1] = "累计充值达到80元宝",
				[2] = "累计充值达到300元宝",
				[3] = "累计充值达到600元宝",
				[4] = "累计充值达到980元宝",
				[5] = "累计充值达到1980元宝",
				[6] = "累计充值达到3280元宝",
				[7] = "累计充值达到6480元宝",
				[8] = "累计充值达到8880元宝",
				[9] = "累计充值达到18000元宝",
			},
		},

		--淘宝树
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_duanwu/duanwu_img.png" ,
			--标题图片大小
			titleImageSize = {width = 635, height = 100
},
			--活动时间
			activityTime = "2015年6月19日00:01-2015年6月21日23:59",
			--活动说明
			describe = "在活动期间，参与【淘宝树】抽奖，就有机会获得完美伙伴—百战天女！",
			--奖励
			awardGroup = {
				[1] =   {awardId = 34441,isEffect = false},
				[2] =   {awardId = 39605,isEffect = false},
				[3] =   {awardId = 39606,isEffect = false},
				[4] =   {awardId = 34944,isEffect = false},
				[5] =   {awardId = 34943,isEffect = false},
				[6] =   {awardId = 18740,isEffect = false},
				[7] =   {awardId = 18730,isEffect = false},
				[8] =   {awardId = 18711,isEffect = false},
				[9] =   {awardId = 18712,isEffect = false},
				[10] =  {awardId = 18720,isEffect = false},
				[11] =  {awardId = 18721,isEffect = false},
				[12] =  {awardId = 18513,isEffect = false},

			},
					--场景信息
		    sceneInfo = {sceneId = 3,sceneX = 130,sceneY = 63},
		},


		--累计登录页面
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_duanwu/duanwu_img.png" ,
			--标题图片大小
			titleImageSize = {width = 635, height = 100
},
			--标题图片大小
			--活动时间
			activityTime = "2015年6月19日00:01-2015年6月21日23:59",
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
					[2] = {awardId = 18609,count = 4},
					[3] = {awardId = 18612,count = 3},
					[4] = {awardId = 48261,count = 1},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每天登录可领取",
				[2] = "累计登录2天可领取",
				[3] = "累计登录3天可领取",
			},
		},
	
		-- 天降宝箱
		[5] = {
			--标题路径
			titleImagePath ="ui/lh_duanwu/duanwu_img.png" ,
			--标题图片大小
			titleImageSize = {width = 635, height = 100
},
			--活动时间
			activityTime = "2015年6月19日00:01-2015年6月21日23:59",
			--活动说明
			describe = "在活动期间，每日11点、16点30、18点、21点30将会在雁门关刷新大量宝箱，采集可获得奖励",
			--奖励
			awardGroup = {
				[1] =  {awardId = 44488,isEffect = false},
				[2] =  {awardId = 18608,isEffect = false},
				[3] =  {awardId = 18618,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
			--场景信息
			sceneInfo = {sceneId = 3,sceneX = 97,sceneY = 86},
		},

		-- 魅力排行榜页面
		[6] = {
			--标题路径
			titleImagePath ="ui/lh_duanwu/duanwu_img.png" ,
			--标题图片大小
			titleImageSize = {width = 635,height = 100
},
			--活动时间
			activityTime = "2015年6月19日00:01-2015年6月21日23:59",
			--活动说明
			describe = "活动期间，玩家只需要向他人赠送鲜花，或者收到其他玩家赠送的鲜花，都会进行魅力统计！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第一行
				[1] = {
					[1] = {awardId = 18730,count = 5},
					[2] = {awardId = 18740,count = 5},
					[3] = {awardId = 18219,count = 1},
					[4] = {awardId = 18606,count = 4},
					[5] = {awardId = 18610,count = 1},
				},
				--第二行
				[2] = {
					[1] = {awardId = 18730,count = 2},
					[2] = {awardId = 18740,count = 2},
					[3] = {awardId = 18219,count = 1},
					[4] = {awardId = 18606,count = 2},
				},
				--第三行
				[3] = {
					[1] = {awardId = 18711,count = 2},
					[2] = {awardId = 28231,count = 2},
					[3] = {awardId = 28221,count = 2},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "魅力排行榜第1名奖励",
				[2] = "魅力排行榜第2~3名奖励",
				[3] = "魅力排行榜第4~10名奖励",
			},
		},

	}
}