--OldLonelyDayParam.lua
--内容：光棍节节活动的配置参数
--作者：陈亮
--时间：2014.10.27

LonelyDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/openser/i996.png",mainTitleContent = "鲜花排行",subTitleContent = "神技神装来袭"},
		[2] = {iconPath = "ui/openser/i2.png",mainTitleContent = "珍宝轩",subTitleContent = "奖励满天飞"},
		[3] = {iconPath = "ui/openser/i24.png",mainTitleContent = "重复消费",subTitleContent = "苍炎之殇复活"},
		[4] = {iconPath = "ui/openser/i997.png",mainTitleContent = "超级团购",subTitleContent = "天天有金币"},
		[5] = {iconPath = "ui/openser/i6.png",mainTitleContent = "累计登录",subTitleContent = "人人为我"},
		[6] = {iconPath = "ui/openser/i3.png",mainTitleContent = "Boss袭礼",subTitleContent = "天降淘宝金币"},
		[7] = {iconPath = "ui/openser/i3.png",mainTitleContent = "天降宝箱",subTitleContent = "天降淘宝金币"},
	},
	
	--子活动页面数据
	pageDataGroup = {
	    --鲜花排行页面
		[1] = {
			--标题路径
			titleImagePath = "ui/openser/leijidenglu.png",
			--标题图片大小
			titleImageSize = {width = 155,height = 29},
			--活动时间
			activityTime = "2014年9月29日00:01-2014年10月3日23:59",
			--活动说明
			describe = "活动期间，每日登录均可领取一个每日登录礼包！累计足够的登录天数，更多的淘宝金币等着你！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第一行
				[1] = {
					[1] = {awardId = 44488,count = 1},
					[2] = {awardId = 18600,count = 2},
					[3] = {awardId = 18613,count = 5},
					[4] = {awardId = 18621,count = 3},
					[5] = {awardId = 18227,count = 3},
				},
				--第二行
				[2] = {
					[1] = {awardId = 44488,count = 2},
					[2] = {awardId = 18600,count = 2},
					[3] = {awardId = 18612,count = 2},
					[4] = {awardId = 39605,count = 2},
					[5] = {awardId = 18628,count = 2},
				},
				--第三行
				[3] = {
					[1] = {awardId = 44488,count = 3},
					[2] = {awardId = 39605,count = 2},
					[3] = {awardId = 48261,count = 1},
					[4] = {awardId = 18711,count = 4},
					[5] = {awardId = 18720,count = 3},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每日登录礼包",
				[2] = "累计登录3天礼包",
				[3] = "累计登录5天礼包",
			},
		},	

		--珍宝轩页面
		[2] = {
			--标题路径
			titleImagePath = "ui/openser/bossxili.png",
			--标题图片大小
			titleImageSize = {width = 176,height = 29},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，每日下午15:00点、夜晚22:00将会在指定地图刷新世界boss，击杀后会刷新宝箱获得奖励！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 65209,isEffect = false},
				[2] =  {awardId = 44488,isEffect = false},
				[3] =  {awardId = 24443,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
		},

		--重复消费页面
		[3] = {
			--标题路径
			titleImagePath = "ui/openser/xiaofeilibao.png",
			--标题图片大小
			titleImageSize = {width = 184,height = 29},
			--活动时间
			activityTime = "2014年9月29日00:01-2014年10月3日23:59",
			--活动说明
			describe = "活动期间每消费250元宝即#cFFC000【有概率】#cffffff获得以下#cFFC000【奖励之一】#cffffff！神兽再现！",
			--奖励
			awardGroup = {
				[1] = {awardId = 64635,isEffect = false,count = 1},
				[2] = {awardId = 44488,isEffect = false,count = 5},
				[3] = {awardId = 39605,isEffect = false,count = 5},
			},
		},

		--超级团购活动页面
		[4] = {
			--标题路径
			titleImagePath = "ui/openser/chaojituangou.png",
			--标题图片大小
			titleImageSize = {width = 184,height = 29},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，超级团购推出【灵魂南瓜】低价出售，内含【紫薇极玉暴击礼包】和【威望丹暴击包】！",
			--奖励上面的小标题
			itemTitleGroup = {
				[1] = "购买后获得以下【全部】内容", 
			    [2] = "购买后获得以内容【之一】"
			},
			--奖励
			awardGroup = {
				[1] = {      --实惠奖励
					[1] =  {awardId = 65209,count = 10},
					[2] =  {awardId = 44488,count = 10},
					[3] =  {awardId = 65161,count = 1}
				},
                [2] = {      --超值奖励
                	[1] =  {awardId = 48271,count = 1},
                	[2] =  {awardId = 48271,count = 2},
                	[3] =  {awardId = 48271,count = 3},
                	[4] =  {awardId = 48271,count = 4},
                	[5] =  {awardId = 48271,count = 5},
                	[6] =  {awardId = 48271,count = 5}
            	}
			},
		},

		--累计登录页面
		[5] = {
			--标题路径
			titleImagePath = "ui/openser/leijidenglu.png",
			--标题图片大小
			titleImageSize = {width = 155,height = 29},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "活动期间，每日登录均可领取一个每日登录礼包！累计足够的登录天数，更多的淘宝金币等着你！",
			--奖励
			awardGroup = {
				--以数字为KEY的每行奖励
				--第1行
				[1] = {
					[1] = {awardId = 44488,count = 1},
					[2] = {awardId = 65209,count = 1},
					[3] = {awardId = 18613,count = 5},
					[4] = {awardId = 18621,count = 3},
					[5] = {awardId = 18227,count = 5},
				},
				--第二行
				[2] = {
					[1] = {awardId = 44488,count = 2},
					[2] = {awardId = 65209,count = 2},
					[3] = {awardId = 18612,count = 2},
					[4] = {awardId = 18603,count = 2},
					[5] = {awardId = 18628,count = 2},
				},
				--第三行
				[3] = {
					[1] = {awardId = 44488,count = 3},
					[2] = {awardId = 65209,count = 3},
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

		--BOSS袭礼页面
		[6] = {
			--标题路径
			titleImagePath = "ui/openser/bossxili.png",
			--标题图片大小
			titleImageSize = {width = 176,height = 29},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，每日下午15:00点、夜晚22:00将会在指定地图刷新世界boss，击杀后会刷新宝箱获得奖励！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 65209,isEffect = false},
				[2] =  {awardId = 44488,isEffect = false},
				[3] =  {awardId = 24443,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
		},
		
		--天降宝箱
		[7] = {
			--标题路径
			titleImagePath = "ui/openser/tianjiangbaoxiang.png",
			--标题图片大小
			titleImageSize = {width = 184,height = 29},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，每日9点、10点、11点、12点和下午16点、17点、18点将会在天元城刷新大量宝箱获得奖励！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 65209,isEffect = false},
				[2] =  {awardId = 44488,isEffect = false},
				[3] =  {awardId = 24443,isEffect = false},
				[4] =  {awardId = 18227,isEffect = false},
			},
			--场景信息
			sceneInfo = {sceneId = 11,sceneX = 97,sceneY = 86},
		},
	}
}