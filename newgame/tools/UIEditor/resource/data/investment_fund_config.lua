--投资基金系统config
InvestmentFundConf = 
{
	need_level = 25,	--系统开启所需等级
	need_yuanbao = 200,
	awards = 
	{
		{
			days=1,	--第几天领取
			money = {type = 3, count = 50},	--没有则不写
			image = "ui/lh_tzfl/item_info_one.png",
			--item = {id = 24499, count = 1, bind = 1},	--没有则不写
		},
		{
			days=2,	--第几天领取
			money = {type = 3, count = 50},	--没有则不写
			image = "ui/lh_tzfl/item_info_one.png",
			--item = {id = 24499, count = 1, bind = 1},	--没有则不写
		},
		{
			days=3,	--第几天领取
			money = {type = 3, count = 100},	--没有则不写
			image = "ui/lh_tzfl/item_info_two.png",
			--item = {id = 24499, count = 1, bind = 1},	--没有则不写
		},
		{
			days=5,	--第几天领取
			money = {type = 0, count = 100000},	--没有则不写
			image = "ui/lh_tzfl/item_info_four.png",
			--item = {id = 24499, count = 1, bind = 1},	--没有则不写
		},
		{
			days=7,	--第几天领取
			--money = {type = 0, count = 150000},	--没有则不写
			item = {id = 58213, count = 1, bind = 1},	--没有则不写
			image = "ui/lh_tzfl/item_info_three.png",
		},
		{
			days=10,	--第几天领取
			money = {type = 0, count = 150000},	--没有则不写
			--item = {id = 24499, count = 1, bind = 1},	--没有则不写
			image = "ui/lh_tzfl/item_info_five.png",
		},
		{
			days=14,	--第几天领取
			--money = {type = 0, count = 10000},	--没有则不写
			item = {id = 58213, count = 1, bind = 1},	--没有则不写
			image = "ui/lh_tzfl/item_info_three.png",
		},
		{
			days=18,	--第几天领取
			money = {type = 0, count = 200000},	--没有则不写
			--item = {id = 24499, count = 1, bind = 1},	--没有则不写
			image = "ui/lh_tzfl/item_info_six.png",
		},
		{
			days=23,	--第几天领取
			--money = {type = 0, count = 10000},	--没有则不写
			item = {id = 58213, count = 1, bind = 1},	--没有则不写
			image = "ui/lh_tzfl/item_info_three.png",
		},
		{
			days=31,	--第几天领取
			--money = {type = 0, count = 10000},	--没有则不写
			item = {id = 58213, count = 1, bind = 1},	--没有则不写
			image = "ui/lh_tzfl/item_info_three.png",
		},
	},
}