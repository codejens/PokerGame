-- create by chj @2015-3-10

-- 单档
day_chongzhi_config = {
	yuanbao_cz = 1,
	item_conf = {
    	[1] = { id = 18711,count = 2},
		[2] = { id = 18219,count = 1},
		[3] = { id = 18609,count = 1},
		[4] = { id = 48296,count = 5},
	}
}

-- 多个档次
day_chongzhi_multi_config = {
	item_conf = {
		[1]= {
	    	[1] = { id = 18711,count = 2},
			[2] = { id = 24444,count = 2},
			[3] = { id = 18609,count = 1},
			[4] = { id = 48296,count = 5},
		},
		[2]= {
	    	[1] = { id = 18711,count = 3},
			[2] = { id = 18720,count = 3},
			[3] = { id = 18610,count = 1},
			[4] = { id = 48296,count = 7},
			[5] = { id = 18606,count = 1},
		},
		[3]= {
	    	[1] = { id = 18711,count = 6},
			[2] = { id = 18720,count = 6},
			[3] = { id = 48296,count = 10},
			[4] = { id = 18606,count = 3},
			[5] = { id = 18219,count = 1},
			[6] = { id = 18610,count = 2},
		},
	},
	item_desc = {
		[1] = "充值任意金额即可领取",
		[2] = "充值500元宝即可领取",
		[3] = "充值1000元宝即可领取",
	},
	item_cz_req = {
		[1] = 60,
		[2] = 500,
		[3] = 1000,
	},
}