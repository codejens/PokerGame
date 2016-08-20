--ValentineDayParam.lua
--内容：春节活动的配置参数
--作者：陈亮
--时间：2014.10.27

WomensDayParam = {
	--子活动的导航数据,一个活动为一个数字KEY为索引
	directlyDataGroup = {
		[1] = {iconPath = "ui/lh_chunjie/CJ_0003.png",txtPath="ui/lh_lonely/title4.png",mainTitleContent = "每日限购",subTitleContent = "每件都聚限购100个，购多了罚再来一次。"},
		[2] = {iconPath = "ui/lh_lonely/luck_rotate.png",txtPath="ui/lh_lonely/title3.png",mainTitleContent = "幸运转盘",subTitleContent = "幸运转盘活动"},
	},
	
	--子活动页面数据
	pageDataGroup = {
		-- 每日限购
		[1] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/FNV_subtitle1.png" ,
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

		-- 幸运转盘
		[2] = {
			--标题路径
			titleImagePath ="ui/lh_activity_cmmon/FNV_subtitle2.png" ,
			--标题图片大小
			titleImageSize = {width = 201,height = 33},
			--活动时间
			activityTime = "2014年10月29日00:01-2014年11月2日23:59",
			--活动说明
			describe = "大奖来抽，壕礼送不停",
			--奖励
			awardGroup = {
				[1] =  {awardId = 18750,isEffect = false},
				[2] =  {awardId = 48265,isEffect = false},
				[3] =  {awardId = 18721,isEffect = false},
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

	}
}