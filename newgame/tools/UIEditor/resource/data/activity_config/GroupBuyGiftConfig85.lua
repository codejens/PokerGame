	--GroupBuyGiftConfig82.lua
--内容：团购礼包配置文件
--作者：陈亮
--时间：2014.08.14

GroupBuyGiftConfig85 = {
	--每个类型针对一份配置
	--配置1
	[1] = {
		--元宝图片路径
		moneyImagePath = "ui/lh_mainActivity/tg_everyday_168.png", -- 废弃(每次改元宝都需要ui)
		-- 元宝数量
		moneyNum = 188,
		--元宝图片大小
		moneyImageSize = {
			width = 312,
			height = 39
		},
		--优惠礼包ID
		cheapGiftId = 64000,
		--超值礼包ID
		superGiftId = 64001,
		--积分礼包ID
		pointGiftId = 60066,
		--可获取的最大积分
		maxPoint = 5,
		--实惠礼包购买最大次数
		cheapGiftMax = 5,
		--开启超值礼包购买的实惠礼包购买数
		consumeCheapCount = 5,
		--实惠礼包单价元宝数量
		cheapGold = 188,
		--超值礼包单价元宝数量
		superGold = 2588,
		--实惠礼包购买内容
		cheapContent = "188元宝购买",
		--超值礼包购买内容
		superContent = "2588元宝购买",
		--积分礼包领取内容
		gainContent = "需要5积分",
		--排行奖励组
		awardGroup = {
			--每项就是一个奖励ID
			[1] = 60072,
			[2] = 60073,
			[3] = 60074
		}
	},
}

-- 元宵节道具配置 (8) 展示
-- 第1个是大礼包，后面3个是小物品
-- type:类型，id:物品编号, count物品数量
-- itemConfigNewYear = {

	-- -- 春节
	-- [9] = {
	-- 	[1] = {
	-- 		[1] = {type=1, id = 60064, count =1 },
	-- 		[2] = {type=1, id = 60067, count =5 },
	-- 		[3] = {type=1, id = 18712, count =4 },
	-- 		[4] = {type=1, id = 18721, count =8 },
	-- 	},
	-- 	[2] = {
	-- 		[1] = {type=1, id = 60065, count =1 },
	-- 		[2] = {type=1, id = 60067, count =100 },
	-- 		[3] = {type=1, id = 18712, count =18 },
	-- 		[4] = {type=1, id = 18721, count =30 },
	-- 	}
	-- },
-- }
