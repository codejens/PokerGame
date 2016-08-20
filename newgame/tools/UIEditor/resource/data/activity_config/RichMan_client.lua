--chongzhifanhui_client.lua
--create by zenghaiming  2014-09-22
--大富翁配置表

local itemSize = 40
local itemRealSize = itemSize + 6
local RightX = 510
local ButtonY = 90
local _RECHARGE_PAGE_ROW_H = 125
local common = 0
local spcial = 1
RichMan_client = {
	t_ItemMapConfig			= {
	[1] 	= {id = 0, x = RightX - 0*itemRealSize , y = ButtonY-5,  size = itemSize*1.5, Type = spcial},
	[2] 	= {id = 0, x = RightX - 1*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[3] 	= {id = 0, x = RightX - 2*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[4] 	= {id = 0, x = RightX - 3*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[5] 	= {id = 0, x = RightX - 4*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[6] 	= {id = 0, x = RightX - 5*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[7] 	= {id = 0, x = RightX - 6*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[8] 	= {id = 0, x = RightX - 7*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[9] 	= {id = 0, x = RightX - 8*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[10] 	= {id = 0, x = RightX - 9*itemRealSize, y = ButtonY, size = itemSize, Type = common},
	[11] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize -2, y = ButtonY-5 -2, size = itemSize*1.5, Type = spcial},
	[12] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 1*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[13] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 2*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[14] 	= {id = 0, x = RightX - 9*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 2*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[15] 	= {id = 0, x = RightX - 8*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 2*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[16] 	= {id = 0, x = RightX - 8*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 3*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[17] 	= {id = 0, x = RightX - 8*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 4*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[18] 	= {id = 0, x = RightX - 9*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 4*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[19] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 4*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[20] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 5*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[21] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize+5 , y = ButtonY-5 + 6*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[22] 	= {id = 0, x = RightX - 10*itemRealSize - 0.4*itemSize -2, y = ButtonY-5 + 7*itemRealSize + 0.4*itemSize, size = itemSize*1.5, Type = spcial},
	[23] 	= {id = 0, x = RightX - 9*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[24] 	= {id = 0, x = RightX - 8*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[25] 	= {id = 0, x = RightX - 7*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[26] 	= {id = 0, x = RightX - 6*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[27] 	= {id = 0, x = RightX - 5*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[28] 	= {id = 0, x = RightX - 4*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[29] 	= {id = 0, x = RightX - 3*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[30] 	= {id = 0, x = RightX - 2*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[31] 	= {id = 0, x = RightX - 1*itemRealSize, y = ButtonY + 7*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[32] 	= {id = 0, x = RightX - 0*itemRealSize, y = ButtonY + 7*itemRealSize-5 + 0.4*itemSize, size = itemSize*1.5, Type = spcial},
	[33] 	= {id = 0, x = RightX - 0*itemRealSize+5, y = ButtonY-5 + 6*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[34] 	= {id = 0, x = RightX - 0*itemRealSize+5, y = ButtonY-5 + 5*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[35] 	= {id = 0, x = RightX - 1*itemRealSize+5, y = ButtonY-5 + 5*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[36]  = {id = 0, x = RightX - 2*itemRealSize+5, y = ButtonY-5 + 5*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[37]  = {id = 0, x = RightX - 2*itemRealSize+5, y = ButtonY-5 + 4*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[38]  = {id = 0, x = RightX - 2*itemRealSize+5, y = ButtonY-5 + 3*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[39]  = {id = 0, x = RightX - 1*itemRealSize+5, y = ButtonY-5 + 3*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[40]  = {id = 0, x = RightX - 0*itemRealSize+5, y = ButtonY-5 + 3*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[41]  = {id = 0, x = RightX - 0*itemRealSize+5, y = ButtonY-5 + 2*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	[42]  = {id = 0, x = RightX - 0*itemRealSize+5, y = ButtonY-5 + 1*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	--[42]  = {id = 0, x = RightX - 0*itemRealSize+5, y = ButtonY-5 + 1*itemRealSize + 0.4*itemSize, size = itemSize, Type = common},
	},

	t_layoutConfig = {
            -- 行高， 计算需要用，所以提取出来
            row_h = _RECHARGE_PAGE_ROW_H,
            -- 滑动中的行的父节点    高度要通过 行的数量*行高 来计算
            scroll_bg    = { id = "scroll_bg", x = 0, y = 0, w = 835, h = 1, img = "" },
            -- scroll 
            award_scroll = { id = "award_scroll", x = 5, y = 110, w = 835, h = 380, img = "", scroll_type = TYPE_HORIZONTAL },
        
            -- 一行的背景
            row_bg    = { id = "row_bg", x = 0, w = 835, h = _RECHARGE_PAGE_ROW_H, img = "" },
            -- 行中的标题
            row_title = { id = "row_title", words = "", x = 15, y = 100, size = 16, align = ALIGN_LEFT  },
            -- 行中的道具坐标计算系数
            row_slot_item = { begin_x = 20, interval_x = 83, begin_y = 15, w = 65, h = 65  },
            -- 领取按钮
            row_get_but = { x = 680, y = 15, w = -1, h = -1, img_n = UILH_COMMON.btn4_nor, img_s = UILH_COMMON.btn4_nor },
            -- 领取按钮的文字
            row_get_word_img = { x = 11, y = 10, w = -1, h = -1, img = UILH_COMMON.btn4_nor },
            -- 领取按钮的文字  已领取
            row_get_word_img2 = { x = 20, y = 10, w = -1, h = -1, img = UILH_COMMON.btn4_nor },
            -- 行的分割线
            split_line = { x = 10, y = 0, w = 835, h = 3, img = UILH_COMMON.split_line },
            
        },

    t_awardTitles = {

		"#cfff000完成环游5圈",		
        "#cfff000完成环游10圈",  
        "#cfff000完成环游20圈", 
        "#cfff000完成环游40圈", 
        "#cfff000完成环游70圈", 
		"#cfff000完成环游118圈", 

	},


	

	words = {
		activityDesc = "活动期间大富翁环游完成相应次数即可获得奖励", -- 环游世界活动说明
		explaint	= "#c4d23081.普通骰子20元宝掷一次，随机出1~6，每天可获得3个免费骰子#r#c4d23082.黄金骰子能连续行动10次，最后一次获得双倍奖励！#r#c4d23083.每环游一圈就可以领取一个环游礼包，走到起点也可获得。礼包可随机开出极品奖励哦！#r#c4d23084.完成环游次数越多，可兑换更多的礼包，赶紧行动吧！#r#cffff0 注：每天0点富翁的位置将重置回起点。", -- 大富翁活动说明
		ComomThrowDicePrice = "#c4d230820元宝/次",		--普通掷骰子的价格
		GoldThrowDicePrice = "#c4d2308200元宝/10次",		--黄金掷骰子的价格
		FreeTrowDice = "#c4d2308免费掷骰子"				--免费掷骰子	
	},




}