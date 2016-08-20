--WorkDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

WorkDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0001.png",txtPath="ui/lh_work/text_icon1.png",mainTitleContent = "淘宝树",subTitleContent = "神技神装来袭"},
		[2] = {iconPath = "ui/lh_chunjie/CJ_0004.png",txtPath="ui/lh_work/text_icon2.png",mainTitleContent = "累计登录",subTitleContent = "淘宝树淘宝树"},
		[3] = {iconPath = "ui/lh_chunjie/CJ_0002.png",txtPath="ui/lh_work/text_icon3.png",mainTitleContent = "充值返利",subTitleContent = "充值返利"},
		[4] = {iconPath = "ui/lh_chunjie/CJ_0003.png",txtPath="ui/lh_chunjie/CJ_icon_0003.png",mainTitleContent = "每日限购",subTitleContent = "每日限购"},
		[5] = {iconPath = "ui/lh_chunjie/CJ_0007.png",txtPath="ui/lh_work/text_icon5.png",mainTitleContent = "天降宝箱",subTitleContent = "天降宝箱"},
		[6] = {iconPath = "ui/lh_work/shenshu.png",txtPath="ui/lh_work/text_icon6.png",mainTitleContent = "昆仑神树",subTitleContent = "昆仑神树"},
	},
	
	--子活动页面数据
	pageDataGroup = {
		--淘宝树
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/BL_subtitle1.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "在活动期间，通过打开【淘宝树】界面，可以参与抽奖，更有机会获得超级伙伴—波斯舞姬！佳人陪你闯荡边关，纵横西域无人可挡！",
			--奖励
			awardGroup = {
				[1] =  {awardId = 34442,isEffect = false},
				[2] =  {awardId = 18631,isEffect = false},
				[3] =  {awardId = 18721,isEffect = false},
				[4] =  {awardId = 18730,isEffect = false},
				[5] =  {awardId = 18711,isEffect = false},
				[6] =  {awardId = 18712,isEffect = false},
				[7] =  {awardId = 18720,isEffect = false},
				[8] =  {awardId = 18740,isEffect = false},
				[9] =  {awardId = 18630,isEffect = false},
				[10] =  {awardId = 18629,isEffect = false},
				[11] =  {awardId = 28231,isEffect = false},
				[12] =  {awardId = 28221,isEffect = false},

			},
					--场景信息
		    sceneInfo = {sceneId = 3,sceneX = 130,sceneY = 63},
		},

		--累计登录页面
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_work/text2.png" ,
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
					[2] = {awardId = 19301,count = 2},
					[3] = {awardId = 18613,count = 3},
					[4] = {awardId = 18621,count = 3},
				},
				--第二行
				[2] = {
					[1] = {awardId = 44488,count = 2},
					[2] = {awardId = 18211,count = 2},
					[3] = {awardId = 18608,count = 3},
					[4] = {awardId = 18603,count = 3},									
				},
				--第三行
				[3] = {
					[1] = {awardId = 44488,count = 4},
					[2] = {awardId = 18211,count = 2},
					[3] = {awardId = 18633,count = 2},
					[4] = {awardId = 48261,count = 1},
					[5] = {awardId = 18609,count = 1},
				},
			},
			--标题组
			itemTitleGroup = {
				[1] = "每天登录可领取",
				[2] = "累计登录2天可领取",
				[3] = "累计登录3天可领取",
			},
		},

		-- 累计充值数据
		[3] = {
			--标题路径
			titleImagePath = "ui/lh_work/text3.png",
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
					[1] = {awardId = 60184,count = 1},
				},
				[2] = {
					[1] = {awardId = 60185,count = 1},
				},
				[3] = {
					[1] = {awardId = 60186,count = 1},
				},
				[4] = {
					[1] = {awardId = 60187,count = 1},
				},
				[5] = {
					[1] = {awardId = 60188,count = 1},
				},
				[6] = {
					[1] = {awardId = 60189,count = 1 },
				},
				[7] = {
					[1] = {awardId = 60190,count = 1 },
				},
				[8] = {
					[1] = {awardId = 60191,count = 1 },
				},
				[9] = {
					[1] = {awardId = 60192,count = 1 },
				},
			},
			--目标消费数额
			rechargeCountGroup = {
				[1] = 198,
				[2] = 588,
				[3] = 1588,
				[4] = 5888,
				[5] = 15888,
				[6] = 58888,
				[7] = 98888,
				[8] = 158888,
				[9] = 200000,
			},
			--标题组
			itemTitleGroup = {
				[1] = "累计充值198元宝",
				[2] = "累计充值588元宝",
				[3] = "累计充值1588元宝",
				[4] = "累计充值5888元宝",
				[5] = "累计充值15888元宝",
				[6] = "累计充值58888元宝",
				[7] = "累计充值98888元宝",
				[8] = "累计充值158888元宝",
				[9] = "累计充值200000元宝",
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
		--天降宝箱
		[5] = {
			--标题路径
			titleImagePath ="ui/lh_work/text5.png" ,
			--标题图片大小
			titleImageSize = {width = 202,height = 33},
			--活动时间
			activityTime = "2015年2月18日00:01-2015年2月25日23:59",
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
		-- 昆仑神树
		[6] = {
			--标题路径
			titleImagePath ="ui/lh_work/text6.png" ,
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
	}
}