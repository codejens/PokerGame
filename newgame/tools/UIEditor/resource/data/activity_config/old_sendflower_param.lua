-- region SendFlowerParam.lua    --老服送花排行榜活动配置参数
-- Author : 肖进超
-- Date   : 2014/10/27

OldSendFlowerParam = {
	--活动说明
	activityDesc = "#cd0cda2活动期间，玩家只要向他人送花就会进行送花统计！当送花数量达到要求，即可领取右下角累计送花奖励！当领取完全部累计送花奖励，活动结束时即可获得排行奖励！",

	--帮助说明文本    -- #r ：换行符
	helpContent = "#c66FF66 1.排行奖励的发放条件为：领取完全部累计赠送鲜花奖励！ #r"..
                  "#c66FF66 2.如果您已经上榜，但是未达到以上条件，结算时不会发放奖励！ #r"..
                  "#c66FF66 3.本排行榜和累计送花奖励皆以送花者为单位进行统计。#r"..
                  "#c66FF66 4.鲜花赠送给谁与统计没有直接关系，谢谢参与！",
	--右侧送花排名奖励展示的物品和数量
	rewardGrup = {
		[1] = {
			title = "#cd0cda2送花排名第一即可获得",
			awardData = {
				[1] = {awardId = 18210,count = 1},
				[2] = {awardId = 18210,count = 3},
				[3] = {awardId = 18210,count = 3},
				[4] = {awardId = 18210,count = 3},
			},
		},
		[2] = {
			title = "#cd0cda2送花排名第二即可获得",
			awardData = {
				[1] = {awardId = 18210,count = 2},
				[2] = {awardId = 18210,count = 2},
			},
		},
		[3] = {
			title = "#cd0cda2送花排名第三即可获得",
			awardData = {
				[1] = {awardId = 18210,count = 1},
				[2] = {awardId = 18210,count = 1},
			},
		},
	},

	--右侧累计送花奖励展示的物品和数量
	addUpGroup = {
		[1] = {
			title = "#cd0cda2累计赠送1000朵花",
			awardData = {
				[1] = {awardId = 18210,count = 2},
				[2] = {awardId = 18210,count = 2},
				[3] = {awardId = 18210,count = 10},
			},
		},
		[2] = {
			title = "#cd0cda2累计赠送5000朵花",
			awardData = {
				[1] = {awardId = 18210,count = 6},
				[2] = {awardId = 18210,count = 6},
				[3] = {awardId = 18210,count = 30},
				[4] = {awardId = 18210,count = 2},
			},
		},
		[3] = {
			title = "#cd0cda2累计赠送15000朵花",
			awardData = {
				[1] = {awardId = 18210,count = 15},
				[2] = {awardId = 18210,count = 15},
				[3] = {awardId = 18210,count = 50},
				[4] = {awardId = 18210,count = 5},
			},
		},
		[4] = {
			title = "#cd0cda2累计赠送30000朵花",
			awardData = {
				[1] = {awardId = 18210,count = 40},
				[2] = {awardId = 18210,count = 40},
				[3] = {awardId = 18210,count = 80},
				[4] = {awardId = 18210,count = 10},
			},
		},
	},

    --
}



