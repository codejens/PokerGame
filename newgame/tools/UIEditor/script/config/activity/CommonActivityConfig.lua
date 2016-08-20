--CommonActivityConfig.lua
--内容：通用活动的配置单体类，主要包括通用活动的活动ID和活动类型
--作者：陈亮
--时间：2014.08.28

CommonActivityConfig = {}
----------------------------------------------------------------------
--活动ID
----------------------------------------------------------------------
CommonActivityConfig.MidAutumn = 87						--中秋节
CommonActivityConfig.NewNationalDay = 91			    --新服国庆节
CommonActivityConfig.OldNationalDay = 92				--老服国庆节
CommonActivityConfig.Hallowmas = 97						--万圣节
CommonActivityConfig.OldLonelyDay = 100					--老服光棍节
-- CommonActivityConfig.NewLonelyDay = 102					--新服光棍节 


CommonActivityConfig.OldThanksgiving = 103  			--老服感恩节  
CommonActivityConfig.NewThanksgiving = 104				--新服感恩节  
CommonActivityConfig.OldChristmas = 107    				--老服圣诞节
CommonActivityConfig.NewChristmas = 108    				--新服圣诞节 
CommonActivityConfig.OldYuandan = 110    				--老服元旦节
CommonActivityConfig.NewYuandan = 111    				--新服元旦节 
CommonActivityConfig.OldChristmas = 107    				--老服圣诞节
CommonActivityConfig.NewChristmas = 108    				--新服圣诞节
CommonActivityConfig.DailyRecharge = 114    		    --每日充值
CommonActivityConfig.Xinyue = 117		    		    --心悦



--天降雄狮添加
CommonActivityConfig.ValentineDay = 8		    		    --情人节
CommonActivityConfig.NewLonelyDay =9					--春节 
CommonActivityConfig.ValentineWhiteDay = 12
CommonActivityConfig.LanternDay =10					--元宵节
CommonActivityConfig.QingmingDay = 17  				-- 清明节
CommonActivityConfig.SummerDay = 19  				-- 清凉一夏
CommonActivityConfig.WorkDay = 20  				-- 劳动节

CommonActivityConfig.VersionCelebration = 21  				-- 版本庆典活动
CommonActivityConfig.heFuKH = 28  				-- 合服狂欢活动

CommonActivityConfig.PoBing = 6                         --破冰活动  单独活动

CommonActivityConfig.WomensDay = 11                         -- 妇女节

CommonActivityConfig.DragonTower = 15					--神龙密塔
----------------------------------------------------------------------
--页面类型，用来定义需要与服务端交互的页面类型
----------------------------------------------------------------------
--通用页面，类型范围1~50
CommonActivityConfig.TypeRepeatConsume  = 1				--重复消费
CommonActivityConfig.TypeAddupConsume   = 2				--累计消费
CommonActivityConfig.TypeTotalLogin	    = 3				--累计登陆
CommonActivityConfig.TypeAddupRecharge	= 4				--累计充值
CommonActivityConfig.TypeRepeatRecharge = 5				--重复充值
CommonActivityConfig.TypeExchange		= 6				--兑换
CommonActivityConfig.TypeConsumeQueue	= 7				--消费排行
CommonActivityConfig.TypeDailyRecharge	= 8				--每日充值
CommonActivityConfig.TypeEveryRecharge	= 10			--每日消费(多礼包)
CommonActivityConfig.TypeSendFlowerQueue = 11				--送花排行
CommonActivityConfig.TypeReceiveFlowerQueue = 12			--收花排行

--特殊页面，类型范围，100~200
CommonActivityConfig.TypeMoonCake = 101					--中秋节活动特殊月饼页面