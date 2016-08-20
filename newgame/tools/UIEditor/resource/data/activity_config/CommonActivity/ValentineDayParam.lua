--ValentineDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

ValentineDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_lonely/send_flower.png",txtPath="ui/lh_lonely/title1.png",mainTitleContent = "送花排行榜",subTitleContent = "送花排行榜"},		
		[2] = {iconPath = "ui/lh_lonely/receive_flower.png",txtPath="ui/lh_lonely/title2.png",mainTitleContent = "收花排行榜",subTitleContent = "收花排行榜"},
		[3] = {iconPath = "ui/lh_lonely/luck_rotate.png",txtPath="ui/lh_lonely/title3.png",mainTitleContent = "幸运转盘",subTitleContent = "幸运转盘活动"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0003.png",txtPath="ui/lh_lonely/title4.png",mainTitleContent = "每日限购",subTitleContent = "每件都聚限购100个，购多了罚再来一次。"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0002_1.png",txtPath="ui/lh_chunjie/CJ_icon_0002_1.png",mainTitleContent = "每日消费",subTitleContent = "每日消费。"},
	},
	
	--子活动页面数据
	pageDataGroup = {
		-- 送花排行榜页面
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_lonely/subtitle1.png" ,
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
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_lonely/subtitle2.png" ,
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

		-- 幸运转盘
		[3] = {
			--标题路径
			titleImagePath ="ui/lh_lonely/subtitle3.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "大奖来抽，壕礼送不停",
			--奖励
			awardGroup = {
				[1] =  {awardId = 38206,isEffect = false},
				[2] =  {awardId = 64751,isEffect = false},
				[3] =  {awardId = 18612,isEffect = false},
				[4] =  {awardId = 18603,isEffect = false},
				[5] =  {awardId = 18604,isEffect = false},
				[6] =  {awardId = 18219,isEffect = false},
				[7] =  {awardId = 18633,isEffect = false},
				[8] =  {awardId = 18634,isEffect = false},
				[9] =  {awardId = 28236,isEffect = false},
				[10] =  {awardId = 28226,isEffect = false},
				[11] =  {awardId = 18740,isEffect = false},
				[12] =  {awardId = 18730,isEffect = false},
			},
		},

				--BOSS袭礼页面
		[4] = {
			--标题路径
			titleImagePath ="ui/lh_lonely/subtitle4.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，玩家可以在游戏内直接抢购限量礼包，机不可失，失不再来。",
			--奖励
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
		-- 每日消费数据
		[5] = {
			--标题路径
			titleImagePath ="ui/lh_chunjie/CJ_title_0002_1.png" ,
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
					[1] = {awardId = 18720,count = 2},
					[2] = {awardId = 18612,count = 2},
					[3] = {awardId = 18600,count = 2},
					[4] = {awardId = 18609,count = 4},
					[5] = {awardId = 18227,count = 2},
				},
				[2] = {
					[1] = {awardId = 18720,count = 3},
					[2] = {awardId = 18612,count = 4},
					[3] = {awardId = 18600,count = 4},
					[4] = {awardId = 18610,count = 1},
					[5] = {awardId = 18227,count = 4},
				},
				[3] = {
					[1] = {awardId = 18721,count = 6},
					[2] = {awardId = 18612,count = 6},
					[3] = {awardId = 18616,count = 2},
					[4] = {awardId = 18603,count = 6},
					[5] = {awardId = 18227,count = 8},
				},
				[4] = {
					[1] = {awardId = 18721,count = 8},
					[2] = {awardId = 18612,count = 8},
					[3] = {awardId = 18616,count = 4},
					[4] = {awardId = 18604,count = 8},
					[5] = {awardId = 18227,count = 8},
				},
				[5] = {
					[1] = {awardId = 18721,count = 8},
					[2] = {awardId = 18612,count = 8},
					[3] = {awardId = 18617,count = 1},
					[4] = {awardId = 18605,count = 2},
					[5] = {awardId = 18227,count = 8},
				},
				[6] = {
					[1] = {awardId = 18722,count = 2 },
					[2] = {awardId = 18612,count = 10},
					[3] = {awardId = 18617,count = 2 },
					[4] = {awardId = 18605,count = 2 },
					[5] = {awardId = 18227,count = 12},
				},
				[7] = {
					[1] = {awardId = 18722,count = 4 },
					[2] = {awardId = 18612,count = 12},
					[3] = {awardId = 18618,count = 1 },
					[4] = {awardId = 18605,count = 2 },
					[5] = {awardId = 18227,count = 16},
				},

			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 500,
				[2] = 1400,
				[3] = 4000,
				[4] = 8000,
				[5] = 12000,
				[6] = 18000,
				[7] = 32000,
			},
			--标题组
			itemTitleGroup = {
				[1] = "每日消费达到500元宝",
				[2] = "每日消费达到1400元宝",
				[3] = "每日消费达到4000元宝",
				[4] = "每日消费达到8000元宝",
				[5] = "每日消费达到12000元宝",
				[6] = "每日消费达到18000元宝",
				[7] = "每日消费达到32000元宝",
			},
		},
	}
}