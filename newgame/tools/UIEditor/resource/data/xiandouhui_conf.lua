-- 演武场客户端配置文件(主要是演武场的规则面板)

-- 填写说明
-- type   1表示自己的排名奖励, 2表示规则, 3表示排行榜名次奖励,
-- items  奖励道具列表(目前一行最多显示4个) (id:道具id, count:道具数量, bind:道具是否绑定)
-- rule_title 规则的标题
-- rule_desc 规则描述,#r表示跨行, #cffffff(#c+6位数字(十六进制))表示颜色, warn:跨行的时候记得带上颜色
-- lv     排行榜名次

-- 有用 bychj @2016-1-22
xiandouhui_conf = {
	-- 自己的排行奖励
	[1] = { type=1, items = {
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
	-- 排行奖励规则描述
	[2] = { type=2, rule_title = "#c4e2d0e演武场战斗规则", rule_desc = "#c643f171.  每天可免费在演武场战斗5次，额外购买5次战斗机会，VIP等级可增加免费战斗次数和额外购买次数。#r#c643f172.  在演武场战斗胜利后，如果被挑战者名次高于挑战者，双方会互换排名。#r#c643f173.  战斗时限为3分钟，若到达3分钟还未分出胜负，则算作挑战方挑战失败。#r#c643f174.  累计胜利一定次数就能获得额外奖励，不要忘了在界面右下方领取哦。#r#c643f175.  每日24点会根据演武场排名段发放奖励，排名越高奖励越多。"},
	-- 排行榜名次奖励
	[3] = { type=3, lv=1, items = { 
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
	[4] = { type=3, lv=2, items = { 
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
	[5] = { type=3, lv=3, items = { 
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
	[6] = { type=3, lv=4, items = { 
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
	[7] = { type=3, lv=5, items = { 
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
	[8] = { type=3, lv=6, items = { 
			[1] = {id=26143, count=25, bind = false},
			[2] = {id=26143, count=25, bind = false},
			[3] = {id=26143, count=25, bind = false},
			[4] = {id=26143, count=25, bind = false},
		}},
}
