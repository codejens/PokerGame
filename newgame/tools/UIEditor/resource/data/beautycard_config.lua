-- 神树配置

beautycard_config = {
	-- type：1：不显示神秘宝箱，2显示神秘宝箱
	bc_type = 2, -- not use

	card_pos = {
		-- bc_type
		[2] = { [1]={x=155, y=25}, [2]={x=455, y=25} },
		[3] = { [1]={x=30, y=25}, [2]={x=310, y=25}, [3]={x=590, y=25} },
	},


	-- 宝箱卡信息
	card_show = {
		[1] = {
			name = "ui/lh_meiren_card/bc_lingpai.png",

			box_id = "ui/lh_meiren_card/bc_lingpai_box.png",

			-- label_1 = "有机会",
			-- label_2 = "获得美人卡",

			cost_type = "令牌",
			cost_num = 100,
		},
		[2] = {
			name = "ui/lh_meiren_card/bc_gold.png",

			box_id = "ui/lh_meiren_card/bc_gold_box.png",

			label_1 = "ui/lh_meiren_card/bc_card_ten.png",
			-- label_2 = "获得美人卡",
			item_ids = {
				[1] = 48222,
				[2] = 48222,
				[3] = 48222,
			},

			cost_type = "元宝",
			cost_num = 100,
		},
		[3] = {
			name = "ui/lh_meiren_card/bc_shenmi.png",

			box_id = "ui/lh_meiren_card/bc_shenmi_box.png",

			label_1 = "ui/lh_meiren_card/bc_card_can.png",
			-- label_2 = "获得美人卡",

			-- 神秘宝箱多出3个神秘道具
			item_ids = {
				[1] = 48222,
				[2] = 48222,
				[3] = 48222,
			},

			cost_type = "元宝",
			cost_num = 100,
		},
	},

	card_open = {
		[1] = {
			name = "令牌宝箱",
			cost_type_1 = "令牌",
			cost_num_1 = 100,
			btn_label_1 = "开启1个",

			-- tip_label = "十连抽可获得美人卡",

			cost_type_10 = "令牌",
			cost_num_10 = 100,
			btn_label_10 = "开启10个",
		},
		[2] = {
			name = "黄金宝箱",
			cost_type_1 = "元宝",
			cost_num_1 = 100,
			btn_label_1 = "开启1个",

			tip_label = "十连抽可获得美人卡",

			cost_type_10 = "元宝",
			cost_num_10 = 100,
			btn_label_10 = "开启10个",
		},
		[3] = {
			name = "神秘宝箱",
			cost_type_1 = "元宝",
			cost_num_1 = 100,
			btn_label_1 = "开启1个",

			tip_label = "十连抽可获得美人卡",

			cost_type_10 = "元宝",
			cost_num_10 = 900,
			btn_label_10 = "开启10个",
		},
	},

	result_info = {
		-- 抽一次
		[1] = {
			cost_type = { [1]="令牌", [2]="元宝", [3]="元宝"},
			cost_num = { [1]=100, [2]=1000, [3]=2000},
			btn_label = "再抽一次",
			-- 道具展示位置
			item_pos = {
				[1] = {x=517+33, y=387+33},
			}
		},
		-- 10连抽
		[10] = {
			cost_type = { [1]="令牌", [2]="元宝", [3]="元宝"},
			cost_num = { [1]=100, [2]=1000, [3]=2000},
			btn_label = "再抽十次",
			item_pos = {
				[1] = {x=270+33, y=387+33},
				[2] = {x=390+33, y=387+33},
				[3] = {x=517+33, y=387+33},
				[4] = {x=650+33, y=387+33},
				[5] = {x=760+33, y=387+33},
				[6] = {x=270+33, y=260+33},
				[7] = {x=390+33, y=260+33},
				[8] = {x=517+33, y=260+33},
				[9] = {x=650+33, y=260+33},
				[10] ={x=760+33, y=260+33},
			}
		},
	},
}