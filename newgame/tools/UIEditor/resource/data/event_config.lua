--事件系统
--
--通过触发 执行行为 
event_config = 
{
	--支持触发的事件
	--开始新游戏（新角色） newGame
	--loading完毕， 	   loadingEnd
	--动画结束 			   endOfMovie

	--支持的行为
	--movie = 播放动画   
		--params[1] = movie id
	
	--showUI = 显示界面  
		--params[1] = window name
	
	--doQuest = 执行任务 
		--quest_type 1 = 已接任务，quest_type 2= 可接任务
		--params[1] = id param[2] = type

	--loading结束事件，不要修改，不要删除
	['loadingEnd'] = 
	{
		[1] = {
				 { action='finishLoading', params = {}}
			  }
	},
    
    --剧情副本测试
	['action_test'] = 
	{
		[1] =  { 
				{ action = 'movie', params = { 'act58' } }
			},	
	},

	--第一次进入游戏
	['newGame'] = 
	{
		--[1] = { 
		--		{ action='movie', params = { 'actstart' } } 
		--	  }, 
	},

	--电影播放结束
	['endOfMovie'] = 
	{
		['actone'] = { 
						{ action = 'showUI', params = { 'welcome_win' } }
					},

			--[[指引体验变身技能		
		['bianshen'] = { 
						{ action = 'instruction', params = { 4 } }
					},	]]	
		['act41'] = {
						{ action = 'instruction', params = { 25 } }
					},
		['act39'] = {
						{ action = 'instruction', params = { 33 } }
					},
				--指引校武场
		['act52'] = {
					{ action = "instruction", params = { 18 } }
				},
	},

	['acceptQuest'] =
	{
		--任务接受
			--指引
	
		--指引领取登录奖励
        [33] = {
					{ action = "instruction", params = { 30 } }
				},

		--指引领取登录奖励
        [3] = {
					{ action = "instruction", params = { 30 } }
				},
				
		--指引领取登录奖励
        [63] = {
					{ action = "instruction", params = { 30 } }
				},

        --指引宠物系统
		[10] = {
					{ action = "instruction", params = { 1 } }
				},

			   --雁门关校武场剧情对话
		[157] = {
			{ action = "movie", params = { 'act52' } }
		   },

        --指引宠物系统
		[40] = {
					{ action = "instruction", params = { 1 } }
				},

        --指引宠物系统
		[70] = {
					{ action = "instruction", params = { 1 } }
				},

		--开启坐骑系统
		[30] = {
					{ action = "instruction", params = { 2 } }
				},

		--开启坐骑系统
		[60] = {
					{ action = "instruction", params = { 2 } }
				},
		--开启坐骑系统
		[90] = {
					{ action = "instruction", params = { 2 } }
				},	

	--	--开启必杀技
	--	[26] = {
	--				{ action = "instruction", params = { 27 } }
	--			},

		--开启签到
		[98] = {
					{ action = "instruction", params = { 13 } }
				},

		--引导购买药品
		[94] = {
					{ action = "instruction", params = { 22 } }
				},

		--引导药品快捷栏
		[95] = {
					{ action = "instruction", params = { 32 } }
				},

		--引导坐骑升阶
		[104] = {
					{ action = "instruction", params = { 3 } }
				},

		-- --开启历练副本
		-- [108] = { 
		-- 			{ action = 'instruction', params = { 4 } }
		-- 		},

		--开启兑换系统
		[109] = { 
					{ action = 'instruction', params = { 5 } }
				},

		--引导使用飞鞋
		[106] = { 
					{ action = 'instruction', params = { 23 } }
				},

		--引导使用飞鞋
		[100] = { 
					{ action = 'instruction', params = { 23 } }
				},

		--引导使用飞鞋
		[137] = { 
					{ action = 'instruction', params = { 23 } }
				},

		--引导使用飞鞋
		[138] = { 
					{ action = 'instruction', params = { 23 } }
				},

		--引导使用飞鞋
		[139] = { 
					{ action = 'instruction', params = { 23 } }
				},				

		--引导使用飞鞋
		[140] = { 
					{ action = 'instruction', params = { 23 } }
				},

		--引导使用飞鞋
		[144] = { 
					{ action = 'instruction', params = { 23 } }
				},

		--开启黑市钱庄
		[113] = { 
					{ action = 'instruction', params = { 24 } }
				},	

		--引导渡劫一
		[116] = {
					{ action = "instruction", params = { 6 } }
				},	

		--引导渡劫二
		[124] = {
					{ action = "instruction", params = { 7 } }
				},	

		--开启炼器系统
		[128] = {
					{ action = "instruction", params = { 8 } }
				},	

		--开启世族系统
		[131] = {
					{ action = "instruction", params = { 9 } }
				},	

		--开启梦境系统
		[142] = {
					{ action = "instruction", params = { 11 } }
				},	

		--指引一骑当千副本
		[143] = {
					{ action = "instruction", params = { 12 } }
				},

		--指引成就奖励
		[148] = {
					{ action = "instruction", params = { 15 } }
				},		

	
		--指引征伐榜
		[159] = {
					{ action = "instruction", params = { 21 } }
				},

		--指引演武场
		[177] = {
					{ action = "instruction", params = { 16 } }
				},

		--指引章节任务
		[1] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[31] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[61] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[7] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[37] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[67] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[91] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[92] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[93] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[167] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[188] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[218] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[250] = {
					{ action = "instruction", params = { 36 } }
				},

		--指引章节任务
		[294] = {
					{ action = "instruction", params = { 36 } }
				},
        
        --古城斩杀敌将动画
	    [23] = {
		            { action = "movie", params = { "act57" } }
		       },
	   	[53] = {
		            { action = "movie", params = { "act57" } }
	           },
	    [83] = {
		            { action = "movie", params = { "act57" } }
	           },
												
		--[[点击传送
		[77] = {
					{ action = "instruction", params = { 14 } }
				},	
	
		--点击传送
		[78] = {
					{ action = "instruction", params = { 14 } }
				},	

		--点击传送
		[79] = {
					{ action = "instruction", params = { 14 } }
				},	

		--点击传送
		[80] = {
					{ action = "instruction", params = { 14 } }
				},	]]
		
		--开启梦境系统
		--[81] = { 
		--			{ action = 'instruction', params = { 15 } },
		--			{ action = 'instruction', params = { 16 } },
		--			{ action = 'instruction', params = { 17 } },
		--		},
			
		--[[点击传送
		[82] = {
					{ action = "instruction", params = { 14 } }
				},		

		--点击传送
		[83] = {
					{ action = "instruction", params = { 14 } }
				},	

		--点击传送
		[83] = {
					{ action = "instruction", params = { 14 } }
				},		

		--点击传送
		[84] = {
					{ action = "instruction", params = { 14 } }
				},	]]

	--	--指引火之意志，即诛仙阵
	--	[85] = {
	--				{ action = "instruction", params = { 18 } }
	--			},
	--					
	--	--指引宠物悟性提升
	--	[90] = { 
	--				{ action = 'instruction', params = { 19 } }
	--			},	

	--	--指引妙木秘境，即宠物副本
	--	[95] = { 
	--				{ action = 'instruction', params = { 20 } }
	--			},	

	--	--指引斩妖除魔任务的刷星、领取
	--	[104] = { 
	--				{ action = 'instruction', params = { 21 } }
	--			},

	----------	--开启忍の书系统
	----------	[123] = {
	----------				{ action = "instruction", params = { 23 } }
	----------			},
				
			--动画
		-- 测试接受任务对话  By FJH
		[1] = {
			{ action = "movie", params = { "acceptQuestAction1" }}
		      },				
	},

	

	-- 讨债玩法 By FJH
	["taoZhai"] = {
		[1] = {
			{ action = "movie", params = { "taoZhai1" }}
		},	
	},

	["unfinishQuest"] = {
		[1] = {
			{action = "movie", params = {"unfinishQuest"}}
		},
	},

	['finishQuest'] = 
	{
		--任务完成
			--指引	

		--指引美人图谱
        [6] = {
					{ action = "instruction", params = { 33 } }
				},

		--指引美人图谱
        [36] = {
					{ action = "instruction", params = { 33 } }
				},

		--指引美人图谱
        [66] = {
					{ action = "instruction", params = { 33 } }
				},

		--指引宠物融合
		[157] = { 
					{ action = 'instruction', params = { 20 } }
				},	

		--指引VIP3体验卡
		[136] = { 
					{ action = 'instruction', params = { 10 } }
				},

				--引导技能升级
		[21] = {
					{ action = "instruction", params = { 14 } }
				},

		--引导技能升级
		[51] = {
					{ action = "instruction", params = { 14 } }
				},

		--引导技能升级
		[81] = {
					{ action = "instruction", params = { 14 } }
				},

		--指引使用金元宝
		[15] = { 
					{ action = 'instruction', params = { 29 } }
				},

		--指引使用金元宝
		[45] = { 
					{ action = 'instruction', params = { 29 } }
				},

		--指引使用金元宝
		[75] = { 
					{ action = 'instruction', params = { 29 } }
				},

		--指引一键征友
		[96] = { 
					{ action = 'instruction', params = { 34 } }
				},

		--指引登录送元宝
		[110] = { 
					{ action = 'instruction', params = { 35 } }
				},

		--指引密友抽奖
		[319] = { 
					{ action = 'instruction', params = { 37 } }
				},

		-- --月牙湾对话  
		-- [1] = {
		-- { action = "movie", params = { "act33" } }

		--    },






		[31] = {
		{ action = "movie", params = { "act33" } }
		
		   },
		[61] = {
		{ action = "movie", params = { "act33" } }
		
		   },
		[5] = {
			{ action = "movie", params = { "act27" } }
		   },
	   	[35] = {
		{ action = "movie", params = { "act27" } }
	   },
	    [65] = {
		{ action = "movie", params = { "act27" } }
	   },

	   --潺夜古城 对话  伙伴开启
	   	[9] = {
			{ action = "movie", params = { "act28" } }
		   },
	   	[39] = {
		{ action = "movie", params = { "act28" } }
	   },
	    [69] = {
		{ action = "movie", params = { "act28" } }
	   },
          

        --潺夜古城  霍安对话
	   	[27] = {
			{ action = "movie", params = { "act29" } }
		   },
	   	[57] = {
		{ action = "movie", params = { "act29" } }
	   },
	    [87] = {
		{ action = "movie", params = { "act29" } }
	   },


	    [14] = {
		{ action = "movie", params = { "act38" } }
	   },
	     [44] = {
		{ action = "movie", params = { "act38" } }
	   },
	     [74] = {
		{ action = "movie", params = { "act38" } }
	   },

	     [140] = {
		{ action = "movie", params = { "act56" } }
	   },

	   --潺夜古城  狼嚎
	--    [11] = {
	--		 { action = "movie", params = { "act49" } }
	--	    },
	--   	 [41] = {
	--	{ action = "movie", params = { "act49" } }
	--   },
	--    [71] = {
	--	{ action = "movie", params = { "act49" } }
	--   },

	           --白戎祖地   霍安对话
	   	[101] = {
			{ action = "movie", params = { "act30" } }
		   },
		       --白戎祖地   红日对话
 	    [102] = {
			{ action = "movie", params = { "act36" } }
		   },
		   --楼兰废墟  卢魁斯对话
	   	[118] = {
			{ action = "movie", params = { "act31" } }
		   },

	   	[120] = {
			{ action = "movie", params = { "act32" } }
		   },
		   --楼兰废墟第一次护国榜
		[115] = {
			{ action = "movie", params = { "act51" } }
		   },

		   --43级美人图谱开启剧情对话
		--[[[248] = {
			{ action = "movie", params = { "act53" } }
		   },--]]

               --乌垒城  殷破对话

		[183] = {
			{ action = "movie", params = { "act35" } }
		   },
             
        [164] = {
			{ action = "movie", params = { "act55" } }
		   },
               --雁门关  兑换使者对话

        [107] = {
			{ action = "movie", params = { "act37" } }
		   },
		[108] = {
			{ action = "movie", params = { "act50" } }
		   },
		   
		   --剧情分章小电影
		[6] = {
			{ action = "movie", params = { "act39" } }
			-- { action = 'instruction', params = { 33 }}
		   },
		[29] = {
			{ action = "movie", params = { "act40" } }
		   },

		[36] = {
			{ action = "movie", params = { "act39" } }
			-- { action = 'instruction', params = { 33 } }
		   },
		[59] = {
			{ action = "movie", params = { "act40" } }
		   },

		[66] = {
			{ action = "movie", params = { "act39" } }
			-- { action = 'instruction', params = { 33 } }
		   },
		[89] = {
			{ action = "movie", params = { "act40" } }
		   },

		[166] = {
			{ action = "movie", params = { "act41" } }
		   },

		[188] = {
			{ action = "movie", params = { "act42" } }
		   },

		--[[
		[105] = {
			{ action = "movie", params = { "act54" } }
		   },
		   --]]

		
		[217] = {
			{ action = "movie", params = { "act43" } }
		   },
        --[[
		[249] = {
			{ action = "movie", params = { "act44" } }
		   },
		   --]]

		[293] = {
			{ action = "movie", params = { "act45" } }
		   },

        [318] = {
			{ action = "movie", params = { "act46" } }
		   },

		--开启灵根系统
		[188] = {
					{ action = "instruction", params = { 17 } }
				},

	--	--指引玩家查看超强变身
	--	[27] = { 
	--				{ action = 'instruction', params = { 32 } }
	--			},	

	--	--再次指引坐骑培养
	--	[41] = { 
	--				{ action = 'instruction', params = { 6 } }
	--			},

	--	--指引兑换系统
	--	[43] = { 
	--				{ action = 'instruction', params = { 8 } }
	--			},	

	--	--一键征友
	--    [24] = {
	-- 	    		{ action = "instruction", params = { 3 } }
	-- 	    	},					

	--	--指引使用VIP3体验卡
	--	[76] = { 
	--				{ action = 'instruction', params = { 13 } }
	--			},
		--[[
		--穿戴装备
		[7] = { 
					{ action = 'instruction', params = { 22 } }
				},	

		--指引装备附灵
		[64] = { 
					{ action = 'instruction', params = { 28 } }
				},
			
		--开启装备升级指引
		[169] = {
					{ action = "instruction", params = { 29 } }
				},
		]]		


		----------------------------------------- 测试对话内容
		-- 月牙湾对话  
		[1] = {
		{ action = "movie", params = { "finishQuestAction1" } }

		   },

	},

	["normalTalk"] = {
		-- 测试接受任务对话  By FJH
		[1] = {
			{ action = "movie", params = { "normalTalk1" }}
		     },	

	},

	["fubenTalk"] = {
		-- 测试副本对话  By chj
		[1] = {
			{ action = "movie", params = { "fubenTalk1" }}
		     },	

	},


	--指引结束
	["endOfInstruction"] = 
	{

	},

	-- 升级瞬间
	["levelUp"] = 
	{
------		--指引玩家领取免费翅膀		
------		[29] = { 
------					{ action = 'instruction', params = { 24 } }
------				},	

----		--指引式神成长培养
		-- [43] = { 
		-- 			{ action = 'instruction', params = { 25 } }
		-- 		},	
		[43] = { 
					{ action = 'movie', params = { "act53" } }
				},	

		[55] = {
					{ action = 'instruction', params = { 38 } }
				},
	},

	--开系统触发
	['openSystem'] = 
	{
		
	--------	--指引变身
	--------	[16] = { 
	--------				{ action = 'instruction', params = { 30 } }
	--------			},	

		--[[指引式神
		[15] = { 
					{ action = 'instruction', params = { 38 } }
				},	
		]]
	},

	--进入场景
	['enterScene'] = 
	{
		--where [1] == 场景id
		--xiehande 暂时屏蔽掉场景
		-- [1] = { 
		-- 		{ action='showUI', params = { 'welcome_win' } } 
		-- 	  }, 
	},

		--完成副本
	['enterFB'] = 
	{
		--where [1001] == fb id 1001是渡劫
		-- [4] = {
 	-- 			{ action='movie', params = { 'juqing11' } } 
	 --     },
	 --     [120] = {
 	-- 			{ action='movie', params = { 'juqing11' } } 
	 --     },
	},

		--第1次进入副本
	['firstEnterFB'] =
	{
	    [5] = { 
				    { action='movie', params = { 'bianshen' } } 
			     }, 
	},

	--场景移动触发
	['arrive'] = 
	{
		[1] =  { 
					{ action = 'movie', params = { 'act1' } }
				},	
	},

	--已接任务，未完成，点击了任务跟踪界面，触发事件
	['miniTaskClicked'] = 
	{
		-- [108] = {
		-- 			{ action = 'askNpc', params = {'雁门关', '历练副本', 108} }
		-- },
		-- [143] = {
		-- 			{ action = 'askNpc', params = {'雁门关', '一骑当千', 143} }
		-- },
		-- [157] = {
		-- 			{ action = 'askNpc', params = {'雁门关', '校武场', 157} }
		-- },
	},
	['miniFinishTaskClicked'] = 
	{
		-- [108] = {
		-- 			{ action = 'askNpc', params = {'雁门关', '历练副本', 108} }
		-- },
		-- [143] = {
		-- 			{ action = 'askNpc', params = {'雁门关', '一骑当千', 143} }
		-- },
		-- [157] = {
		-- 			{ action = 'askNpc', params = {'雁门关', '校武场', 157} }
		-- },
	},
}
	--已接任务，未完成，且与npc对过话，，点击了任务跟踪界面，触发事件
--	['miniFinishTaskClicked'] = 
--	{
--		--第1次进行战士考试时，没有完成任务
--		[50] = { 
--				{ action = 'instruction', params = { 29 } }
--			},	
--	},

----	--从npc打开商店
----	['openNPCShop'] = 
----	{
----		[12] = { { action = 'instruction', params = { 28 } } }
----	},

	-- 任务栏显示为已完成，但还没交任务
--	['completedQuest'] = 
--	{
--		--第1次完成战士任务，指引完成，且主动关闭战士任务界面
--		[104] = {
--					{ action = "instruction", params = { 22 } }
--				},	
--	},
--}

event_locations = 
{
	[1] = { scene_id = 1, tx = 100, ty = 100 }
}

event_fuben_xszy =
{
	[1] = { npc_name = "历练副本", quest_id = 108 },
	[2] = { npc_name = "一骑当千", quest_id = 143 },
	[3] = { npc_name = "校武场", quest_id = 157 },
}