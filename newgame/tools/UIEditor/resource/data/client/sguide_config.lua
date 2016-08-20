--sguide_config.lua
--新手指引配置文件


--[[ 一次指引配置说明
[等级/任务id] = {
	指引1 [1] = {
		priority -- 引导优先级 （选填）
		步骤1 [1] ={
			count_down -- 倒计时时间，时间到玩家不操作则执行下一步骤
			close_win = true 该单元步骤 关闭所有窗口
			rect={1,2,100,200},响应区域大小{x,y,w,h} 结束条件的响应区域 默认全屏
			element = {
			元素1 [1] = {stype = 1,position={1,2},dest="#c74341a文字说明",rect={1,2,100,200},
			icon = "sui/xszy/iocn_1.png",index = 1},
			元素2 [2] = {},
			...
			},
		},
		步骤2 [2] ={},
		...
	},
	指引2 [1] = {},
	...
--},
]]

--[[一个元素说明
	stype    元素类型 1文字 2操作 3图示  4新功能 5新技能 6执行函数 7 VIP打开窗口 必填参数
	position 位置{x,y坐标值}          1文字 2操作才有
	(4新功能 5新技能 暂时固定在屏幕中间,所以这个位置是飞行目的地) 选填参数
	dest     描述  					  1文字类型才有已有			  选填参数
	rect     图示凸显区域 			  3图示类型才有            	  选填参数
	icon     飞行图标资源位置 		  4新功能 5新技能类型才有     选填参数
	index    技能位置（从下到上1234） 3图示5新技能类型才有        选填参数
	(3图示 index表示形状索引 默认1方形，圆形需要填2 如index=2)
	not_move 不播放动画				  3图示类型才有 			  选填参数
	（默认不填这个字段是播放的 需要不播放得not_move = true）
	do_type（ 开/关某些面板，例如主界面的任务面板）					stype = 6 必填
		1-右边面板 2-任务面板
	isOpen   true/false  打开还是关闭 do_type 指定的面板
	delay 当前步骤延时一定时间，再执行下一步
	search_type  搜索背包的类型，值为 sguide_operation的sguide_auto_show_items的 key
	is_do_next 当前步骤元素执行完，里面进入下一步骤
]]

--[[
stype 13    多重图标到处飞 图标数 1<=N<=5
[1] = {
	element = {
				[1] = {stype = 13,
					bg = "nopack/xszy/open_pvp.png", --背景
					icons = {
							"sui/mainMenu/1.png", 图标1
							"sui/mainMenu/2.png", 图标2
						},
					pos={
							{56,590}, 图标1 飞往的目标
							{256,590},
						},
					align={
							{alignx=1,aligny=3}, 图标1 的适配方案
							{alignx=1,aligny=3},
						}
					},
		},
},
--]]

sguide_config = {
	--等级促发指引
	level = 
	{
		--1级 指引任务寻路	
		[1] = 
		{	
			--增加欢迎界面
			[1] ={
				element = 
				{
					[1] = {stype = 3,rect={0,0,0,0},not_move=true,alignx=1,aligny=1,},
					[2] = {stype = 1,position={150,170},dest="#c74341a嗨~我是#c4fbb00小书童丽华 #c74341a，文叔哥哥不在，你陪我玩好吗~"},
					[3] = {stype = 9,sound = {1,101}, delay = {3,3}},
				},
			},
			--指引寻路
			[2] ={
				rect={9,357,225,69},
				element = 
				{
					[1] = {stype = 1,position={180,150},alignx=1,aligny=2,dest="#c74341a邓禹哥好像要给你看个宝贝，点击这里去找他吧！"},
					[2] = {stype = 2,position={120,393},alignx=1,aligny=3,},
					[3] = {stype = 9,sound = 2},
				},
			},

		},



		--4级 开启技能升级+技能附加效果
		[4] = 
		{
			--开启新功能 技能
			[1] ={
				element = 
				{
					[1] = {stype = 4,icon = "sui/mainMenu/1.png",position={56,590},alignx=1,aligny=3,},
				},
			},
		},
		-- 5级 奖励大厅
		[5] = 
		{
			--开启新功能 奖励大厅
			[1] ={
				element = 
				{
					[1] = {stype = 4,icon = "sui/rightTop/jiangli.png",position={206,512},alignx=1,aligny=3,name="奖励"},
				},
			},
		-- 	-- -- --强制点击【<】按钮
		-- 	-- [2] ={
		-- 	-- 	touch_target = 12,
		-- 	-- 	rect={831,472,38,70},
		-- 	-- 	element = 
		-- 	-- 	{
		-- 	-- 		[1] = {stype = 10,rect={831,472,38,70},alignx=3,aligny=3},

		-- 	-- 	},
		-- 	-- },
			-- --高亮奖励大厅+文字
			-- [2] ={
			-- 	rect={153,472,69,78},
			-- 	touch_target = 1303,
			-- 	element = 
			-- 	{
			-- 		[1] = {stype = 1,position = {200,190},dest="#c74341a看你这么乖，丽华偷偷带你去好地方~"},
			-- 		[2] = {stype = 10,rect={162,476,69,76},alignx=1,aligny=2,not_move = true},
			-- 		[3] = {stype = 9,sound = 3},
			-- 		-- [2] = {stype = 2,position = {707,505},alignx=3,aligny=3, },
			-- 	},
			-- },
			-- --引导文案
			-- [3] ={
			-- 	touch_to_next = true,
			-- 	element = 
			-- 	{
			-- 		[1] = {stype = 1,position = {230,123},dest="#c74341a每天登录来和我玩，就有丰厚奖励等你领取呦！"},
			-- 		[2] = {stype = 10,rect={59,32,232,507},alignx=2,aligny=2,not_move = true},
			-- 		[3] = {stype = 9,sound = 4},
			-- 	},
			-- },

		},
		-- --7级 称号
		-- [7] =
		-- {
		-- 	--7级 开启称号功能
		-- 	[1] ={
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 4,icon = "sui/xszy/icon_1.png",position={56,590},alignx=1,aligny=3},
		-- 		},
		-- 	},
		-- 	--文字
		-- 	[2] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={1,1,1,1},not_move=true,},
		-- 			[2] = {stype = 1,position = {332,243},dest="#c74341a完成各类挑战可获得称号，称号能增加不俗属性哦！"}
		-- 		},
		-- 	},
		-- 	--指引头像
		-- 	[3] ={
		-- 		rect={8,553,78,87},
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 3,rect={8,553,78,87},alignx=1,aligny=3,},
		-- 			[2] = {stype = 2,position={47,596},alignx=1,aligny=3,},
		-- 		},
		-- 	},
		-- 	--指引角色
		-- 	[4] ={
		-- 		rect={242,327,77,86},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={242,327,77,86},index=2,},
		-- 			[2] = {stype = 2,position={280,370},},
		-- 		},
		-- 	},
		-- 	--指引称号
		-- 	[5] ={
		-- 		rect={911,318,49,92},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={911,318,49,92},},
		-- 			[2] = {stype = 2,position={935,364},},
		-- 		},
		-- 	},
		-- 	--展示称号1
		-- 	[6] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 1,position={231,142},dest="#c74341a已获得的称号可以提供大量属性加成！并且可以展示在角色头顶哦！"},
		-- 			[2] = {stype = 3,rect={292,394,600,100},},
		-- 		},
		-- 	},
		-- 	--展示称号2
		-- 	[7] ={
		-- 		rect={752,401,117,41},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={292,394,600,100},not_move=true,},
		-- 			[2] = {stype = 2,position={810,421},},
		-- 		},
		-- 	},
		-- },
		-- --9级 vip
		-- [9] = 
		-- {
		-- 	--开启新功能 VIP体验卡
		-- 	[1] = {
		-- 		rect={421,102,144,57},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 7,win = 1,},
		-- 			[2] = {stype = 2,position={493,130},},
		-- 		},
		-- 	},

		-- },

		

		-- --10级 寻宝+伙伴
		-- [10] = 
		-- {
		-- 	--开启寻宝功能
		-- 	[1] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 4,icon = "sui/rightTop/first_row_2.png",position={841,490},alignx=3,aligny=3,},
		-- 		},	
		-- 	},
		-- 	--指引[<]
		-- 	[2] ={
		-- 		touch_target = 12,
		-- 		rect={831,472,38,70},
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 10,rect={831,472,38,70},alignx=3,aligny=3,not_move = true},
		-- 		},
		-- 	},
		-- 	--高亮寻宝+文字
		-- 	[3] ={
		-- 		touch_target = 1202,
		-- 		rect={801,473,88,88},
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 1,position = {300,220},dest="#c74341a通过寻宝可快速获得各类稀有道具！"},
		-- 			[2] = {stype = 10,rect={810,478,56,63},alignx=3,aligny=2,not_move = true},
		-- 		},
		-- 	},
			
		-- 	--指引天级寻宝
		-- 	[4] ={
		-- 		rect={589,122,139,54},
		-- 		touch_target = 120201,
		-- 		element =
		-- 		{
		-- 			-- [1] = {stype = 2,position = {658,144},},
		-- 			[1] = {stype = 10,rect={589,122,139,54},alignx=2,aligny=2,not_move = true},
		-- 		},
		-- 	},
		-- 	--指引抽1次
		-- 	[5] ={
		-- 		rect={587,305,139,54},
		-- 		touch_target = 120202,
		-- 		element =
		-- 		{
		-- 			-- [1] = {stype = 2,position = {658,333},},
		-- 			[1] = {stype = 10,rect={587,305,139,54},alignx=2,aligny=2,not_move = true},
		-- 		},
		-- 	},
		-- 	--文字
		-- 	[6] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 1,position = {100,0},dest="#c74341a抽到了不错的伙伴哦！伙伴已经自动出战了，快去看看吧～"},
		-- 		},
		-- 	},
		-- 	--点击寻宝确定
		-- 	[7] ={
		-- 		rect={170,133,139,64},
		-- 		touch_target = 120203,
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 10,rect={170,133,139,55},alignx=2,aligny=2,not_move = true},
		-- 			-- [1] = {stype = 2,position={240,165},},
		-- 		},
		-- 	},	
		-- 	-- --点击寻宝关闭
		-- 	-- [8] ={
		-- 	-- 	rect={858,561,62,57},
		-- 	-- 	element =
		-- 	-- 	{
		-- 	-- 		[1] = {stype = 3,rect={858,561,62,57},},
		-- 	-- 		[2] = {stype = 2,position={889,589},},
		-- 	-- 	},
		-- 	-- },
		-- },

		--10级 聚宝盆图标飘入
		[10] =
		{
					--开启聚宝盆
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/rightTop/first_row_3.png",position={206,512},alignx=1,aligny=3,name="聚宝盆"},
				},
			},
		},

		--12级 铸造 强化
		[12] =
		{
			--开启铸造功能
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/mainMenu/6.png",position={56,590},alignx=1,aligny=3,},
				},
			},
			--指引头像
			[2] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			--指引铸造
			[3] ={
				rect={443,368,88,93},
				touch_target = 1105,
				element =
				{
					-- [1] = {stype = 2,position={158,215}, },
					[1] = {stype = 10,rect={450,368,77,83},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={160,100},dest="#c74341a工欲善其事，必先利其器~来#c4fbb00强化装备#c74341a吧！"},
					[3] = {stype = 9,sound = 5},
				},
			},
			--文字 选择材料
			[4] ={
				rect={403,146,75,75},
				element =
				{
					[1] = {stype = 1,position={200,210},dest="#c74341a先选择一样材料，你懂的~"},
					[2] = {stype = 10,rect={407,144,65,65},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 6},
					-- [2] = {stype = 2,position={798,69},},
				},
			},
			--文字 强化+点击强化
			[5] ={
				rect={728,42,139,54},
				element =
				{
					[1] = {stype = 1,position={350,110},dest="#c74341a点击#c4fbb00强化#c74341a，就是这么简单~"},
					[2] = {stype = 10,rect={728,42,139,54},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 7},
					-- [2] = {stype = 2,position={798,69},},
				},
			},
		},

		--14级开放 坐骑
		[14] = 
		{
			--开启坐骑
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/mainMenu/3.png",position={56,590},alignx=1,aligny=3},	
				},
			},

			--指引头像
			[2] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move=true},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a你要当骑牛将军，我便帮你选只风雅的牛当坐骑~"},
					[3] = {stype = 9,sound = 26},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},

			--指引坐骑
			[3] ={
				rect={643,368,88,93},
				touch_target = 1106,
				element =
				{	
					[1] = {stype = 10,rect={649,368,77,86},alignx=2,aligny=2,},
					-- [1] = {stype = 2,position={814,210},},
				},
			},	

			--文字+指引培养
			[4] ={
				rect={722,32,139,54},
				touch_target = 11060101,
				element =
				{
					[1] = {stype = 1,position={200,100},dest="#c74341a坐骑进阶可获#c4fbb00酷炫外观并提高属性#c74341a，还溜得更快！"},
					[2] = {stype = 10,rect={722,32,139,54},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 27},
					-- [2] = {stype = 2,position={792,53},},
				},
			},

			--指引骑乘文字+指引点击
			[5] ={
				rect={66,32,139,54},
				touch_target = 11060102,
				element = 
				{
					-- [1] = {stype = 2,position={136,53},},
					[1] = {stype = 10,rect={66,32,139,54},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={140,20},dest="#c74341a赶快骑上坐骑！做个大名鼎鼎的【骑牛将军】吧~"},
					[3] = {stype = 9,sound = 28},
					[4] = {stype = 12,	search_type = "zuoji"},

				},
			},

			[6] ={
				end_guide = true,
				-- element = 
				-- {

				-- },
			},
		},

		--15级 好友
		[15] = 
		{
			--开启好友功能
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/mainMenu/7.png",position={56,590},alignx=1,aligny=3,},	
				},
			},
			--指引头像
			[2] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			--指引好友
			[3] ={
				rect={343,218,88,93},
				touch_target = 1104,
				element =
				{
					-- [1] = {stype = 2,position={280,411}, },
					[1] = {stype = 10,rect={352,218,72,90},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={400,0},dest="#c74341a结交各路#c4fbb00好友#c74341a，可#c4fbb00互送钥匙#c74341a一同寻宝噢！"},
					[3] = {stype = 9,sound = 8},
				},
			},	
			--文字推荐好友+加点击
			[4] ={
				rect={165,491,119,50},
				touch_target = 110401,
				element =
				{
					[1] = {stype = 1,position={260,255},dest="#c74341a想找到志同道合的玩家一起游戏嘛？点这里吧~"},
					[2] = {stype = 10,rect={165,491,119,50},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 9},
					-- [2] = {stype = 2,position={225,515}, },
				},
			},
		},

		--17级 开启伙伴 培养伙伴
		[17] =
		{
			-- priority = -1,
			--开启伙伴功能
			[1] ={
				close_win = true,
				element =
				{
					[1] = {stype = 4,icon="sui/mainMenu/2.png",position={56,590},alignx=1,aligny=3},
				},
			},
			--指引头像
			[2] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a一个骁勇善战的小伙伴正等着你，快去看看吧~"},
					[3] = {stype = 9,sound = 10},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},

			--指引伙伴
			[3] ={
				rect={543,368,88,93},
				touch_target = 1103,
				element =
				{	
					[1] = {stype = 10,rect={550,368,77,83},alignx=2,aligny=2,not_move = true},	
					[2] = {stype = 1,position={260,100},dest="#c74341a小伙伴已经自动出战了，你不再是一个人战斗了~"},
					[3] = {stype = 9,sound = 11},
					-- [1] = {stype = 2,position={814,210},},
				},
			},


			--指引培养按钮
			[4] ={
				rect={296,36,136,57},
				touch_target = 11030101,
				element =
				{
					[1] = {stype = 10,rect={296,36,136,57},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={80,90},dest="#c74341a快用刚刚获得的材料培养小伙伴吧~"},
					[3] = {stype = 9,sound = 12},
					-- [2] = {stype = 2,position={798,69},},
				},
			},

			--介绍等级和潜力
			[5] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 1,position={130,210},dest="#c74341a小伙伴#c4fbb00潜力越高，资质提升上限就越高#c74341a~"},
					[2] = {stype = 10,rect={540,460,130,75},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 13},
					-- [2] = {stype = 2,position={798,69},},
				},
			},

			--介绍培养
			[6] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 1,position={130,236},dest="#c4fbb00伙伴培养#c74341a有几率提升资质~资质可#c4fbb00提升伙伴属性#c74341a~"},
					[2] = {stype = 10,rect={200,140,560,80},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 14},
					-- [2] = {stype = 2,position={798,69},},
				},
			},

			--指引点击培养
			[7] ={
				rect={563,66,139,57},
				element =
				{
					[1] = {stype = 1,position={200,120},dest="#c74341a伙伴是闯关PK好帮手，记得经常培养他喔～"},
					[2] = {stype = 10,rect={563,66,139,57},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 15},
					[4] = {stype = 12,	search_type = "huoban"},
					-- [2] = {stype = 2,position={798,69},},
				},
			},

			-- --检索背包内可用的伙伴
			-- [8]	={
			-- 	is_do_next = true,
			-- 	{
			-- 		[1] = {stype = 12,	search_type = "huoban"},
			-- 	}
			-- },
		},

		--19级 琴棋书画
		-- [19] = 
		-- {
		-- 	--开启琴棋书画
		-- 	[1] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 4,icon = "sui/mainMenu/12.png",position={56,590},alignx=1,aligny=3,},
		-- 		},	
		-- 	},
		-- 	--指引头像
		-- 	[2] ={
		-- 		rect={11,543,81,84},
		-- 		touch_target = 11,
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true},
		-- 			[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a善琴棋书画者，至情至性，至善至美。"},
		-- 			[3] = {stype = 9,sound = 16},
		-- 			-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
		-- 		},
		-- 	},
		-- 	--指引琴棋书画
		-- 	[3] ={
		-- 		rect={543,218,88,93},
		-- 		touch_target = 1108,
		-- 		element =
		-- 		{
		-- 			-- [1] = {stype = 2,position={286,257},},
		-- 			[1] = {stype = 10,rect={547,218,83,90},alignx=2,aligny=2,not_move = true},
		-- 			[2] = {stype = 1,position={220,-50},dest="#c74341a现在就去琴棋书画提升一下格调吧~"},
		-- 			[3] = {stype = 9,sound = 17},
		-- 		},
		-- 	},
			
		-- 	--指引琴
		-- 	[4] ={
		-- 		rect={58,62,198,463},
		-- 		touch_target = 110801,
		-- 		delay = 1,
		-- 		element =
		-- 		{
		-- 			-- [1] = {stype = 2,position={286,257},},
		-- 			[1] = {stype = 10,rect={58,62,198,463},alignx=2,aligny=2,not_move = true},
		-- 		},
		-- 	},
		-- 	--文字+指引挂机
		-- 	[5] ={
		-- 		touch_to_next = true,
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 1,position={120,123},dest="#c74341a琴棋书画不仅格调高，还可以获得#c4fbb00不俗奖励#c74341a！"},
		-- 			[2] = {stype = 9,sound = 18},
		-- 		},
		-- 	},
		-- 	--文字+指引可邀请好友
		-- 	[6] ={
		-- 		touch_to_next = true,
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 1,position={270,80},dest="#c4fbb00邀请好友#c74341a一同研修还能获得#c4fbb00额外收益#c74341a！"},
		-- 			[2] = {stype = 10,rect={670,330,158,130},alignx=2,aligny=2,not_move = true},
		-- 			[3] = {stype = 9,sound = 19},
		-- 		},
		-- 	},
		-- },
		--20级 装备进阶
		[20] =
		{
			--开启铸造功能
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_3.png",position={56,590},alignx=1,aligny=3,},
				},
			},
			--指引头像
			[2] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move= true},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c4fbb00进阶装备#c74341a足以让你在大神之路上更进一步。"},
					[3] = {stype = 9,sound = 20},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			--指引铸造
			[3] ={
				rect={443,368,88,93},
				touch_target = 1105,
				element =
				{
					[1] = {stype = 10,rect={450,368,77,83},alignx=2,aligny=2,not_move = true},
					-- [1] = {stype = 2,position={158,215}, },
				},
			},
			--点击进阶
			[4] ={
				rect={901,284,67,108},
				touch_target = 110502,
				element =
				{
					[1] = {stype = 10,rect={905,284,40,108},alignx=2,aligny=2,not_move= true},
					-- [1] = {stype = 2,position={935,339}, },
				},
			},
			--文字 进阶
			[5] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 1,position={135,100},dest="#c74341a进阶后的装备#c4fbb00造型更加酷炫#c74341a，属性也会#c4fbb00大幅提升#c74341a！"},
					[2] = {stype = 10,rect={385,365,415,105},alignx=2,aligny=2,not_move= true},
					[3] = {stype = 9,sound = 21},
				},
			},
			--点击进阶
			[6] ={
				rect={526,43,139,54},
				element = 
				{
					[1] = {stype = 1,position={220,100},dest="#c74341a点击#c4fbb00进阶#c74341a，让装备变得更加酷炫吧～"},
					[2] = {stype = 10,rect={526,43,139,54},alignx=2,aligny=2,not_move= true},
					[3] = {stype = 9,sound = 22},
					-- [1] = {stype = 2,position={594,70},},
				},
			},
		},
		--21级 开启世界BOSS
		[21] =
		{
			--开启世界BOSS
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_6.png",position={717,551},alignx=3,aligny=3,},
				},
			},
			-- --指引点击玩法
			-- [2] ={
			-- 	rect={711,545,98,103},
			-- 	touch_target = 1301,
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 10,rect={722,550,65,75},alignx=3,aligny=3},
			-- 		-- [1] = {stype = 2,position={755,586},alignx=3,aligny=3, },
			-- 	},
			-- },
			-- --点击异兽
			-- [3] ={
			-- 	rect={900,279,67,108},
			-- 	touch_target = 130103,
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 10,rect={905,279,40,108},alignx=2,aligny=2,not_move = true},
			-- 		-- [1] = {stype = 2,position={925,330},},
			-- 	},
			-- },
			-- --文字
			-- [4] ={
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 1,position={120,120},dest="#c74341a每天不要忘记与全服小伙伴一起击杀世界BOSS，可以获得丰厚奖励哟~"},
			-- 		-- [2] = {stype = 3,rect={0,0,0,0},not_move=true,},
			-- 	},
			-- },
		},

		--22级 活跃度引导
		[22] =
		{
			--开启任务
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_4.png",position={800,561},alignx=3,aligny=3,}, 
				},
			},
			--点击日常
			[2] ={
				rect={789,545,98,103},
				touch_target = 1302,
				element =
				{
					[1] = {stype = 1,position={320,280},dest="#c74341a每天完成日常里的内容，即可轻松获得奖励噢～"},
					[2] = {stype = 10,rect={800,550,65,75},index=2,alignx=3,aligny=3,not_move=true},
					[3] = {stype = 9,sound = 23},
				},
			},
			--日常面板认识
			[3] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 10,rect={54,290,830,220},index=2,not_move=true,alignx=2,aligny=2,},
					[2] = {stype = 1,position={130,50},dest="#c74341a每天都有超多有趣的玩法等你来玩呦～"},
					[3] = {stype = 9,sound = 24},
				},
			},

			--奖励指引
			[4] ={
				element =
				{
					[1] = {stype = 10,rect={150,30,740,90},index=2,not_move=true,alignx=2,aligny=2,},
					[2] = {stype = 1,position={120,120},dest="#c74341a每天可积累活跃度获得奖励，千万不要错过喔～"},
					[3] = {stype = 9,sound = 25},
				},
			},
		},


		--24级 天机奇缘，神驹猎狩图标飘入，接ID = 4301，4314号引导任务
		[24] =
		{
			--开启新功能 天机奇缘
			[1] ={
				element = 
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_14.png",position={720,550},alignx=3,aligny=3,},
				},
			},

			--开启神驹猎狩
			[2] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_16.png",position={717,551},alignx=3,aligny=3,},
				},
			},
			
		},

		--25级 世族
		[25] =
		{
			--开启寻宝功能
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/rightTop/first_row_2.png",position={206,512},alignx=1,aligny=3,name="寻宝"},
				},	
			},

			--开启世族功能
			[2] ={
				element =
				{
					[1] = {stype = 4,icon="sui/mainMenu/9.png",position={56,590},alignx=1,aligny=3,}, 
				},
			},
			--指引头像
			[3] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true,},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a恭喜你终于找到组织了，快去世族瞧一瞧吧~"},
					[3] = {stype = 9,sound = 29},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			--指引世族
			[4] ={
				rect={443,218,88,93},
				touch_target = 1109,
				element =
				{
					-- [1] = {stype = 2,position={479,411},},
					[1] = {stype = 10,rect={449,218,77,90},alignx=2,aligny=2,not_move = true},
				},
			},
			--文字
			[5] ={
				element =
				{
					[1] = {stype = 1,position={120,120},dest="#c74341a加入世族可享#c4fbb00属性加成#c74341a，还有#c4fbb00福利与活动#c74341a哦~"},
					[2] = {stype = 9,sound = 30},
					-- [2] = {stype = 3,rect={0,0,0,0},not_move=true,},
				},
			},
		},
		
		-- --27级 开启悬赏任务图标飘入，接ID = 5142号引导任务
		-- [27] =
		-- {
		-- 	--开启悬赏任务
		-- 	[1] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 4,icon="sui/xszy/icon_11.png",position={797,551},alignx=3,aligny=3,}, 
		-- 		},
		-- 	},
		-- },

		--26级 演武场图标飘入，接ID = 4303号引导任务
		[26] =
		{
			--开启演武场
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_9.png",position={717,551},alignx=3,aligny=3,},
				},
			},

			--开启宝石
			[2] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_10.png",position={56,590},alignx=1,aligny=3,},
				},
			},
		},

		--27级 箴机奇图图标飘入
		[27] =
		{
			--开启演武场
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_15.png",position={717,551},alignx=3,aligny=3,},
				},
			},
		},

		--28级 武力试炼 图标飘入，接ID = 4304号引导任务
		[28] =
		{
			--开启武力试炼
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_7.png",position={717,551},alignx=3,aligny=3,},
				},
			},
		},

		--29级 每日剧情+组队副本-守卫昆阳 暂不用任务引导[图标飘入，接ID = 5145号引导任务]
		[29] =
		{
			-- --开启每日剧情
			-- [1] ={
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 4,icon = "sui/xszy/icon_27.png",position={717,551},alignx=3,aligny=3,},
			-- 	},
			-- },

			--开启组队副本
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "sui/xszy/icon_20.png",position={717,551},alignx=3,aligny=3,},
				},
			},

			--指引点击玩法
			[2] ={
				rect={711,545,98,103},
				touch_target = 1301,
				element =
				{
					[1] = {stype = 10,rect={719,548,65,75},alignx=3,aligny=3,not_move = true},
					[2] = {stype = 1,position={230,280},dest="#c74341a糟糕！昆阳告急，快随我一起去#c4fbb00守卫昆阳#c74341a！"},--
					[3] = {stype = 9,sound = 31},
					-- [1] = {stype = 2,position={755,586},alignx=3,aligny=3, },
				},
			},

			--特效出现在副本标签处
			[3] ={
				rect={900,374,67,108},
				touch_target = 130102,
				element =
				{
					-- [1] = {stype = 7,win = 2,},
					[1] = {stype = 10,rect={906,368,40,108},alignx=2,aligny=2},
					-- [2] = {stype = 2,position={753,588},alignx=3,aligny=3, },
				},
			},
			
			--点击组队守卫昆阳，即守卫昆阳
			[4] ={
				rect={49,306,185,60},
				element =
				{
					[1] = {stype = 10,rect={49,306,185,76},alignx=2,aligny=2 ,not_move = true},
					[2] = {stype = 1,position={250,50},dest="#c74341a多人副本#c4fbb00奖励丰厚#c74341a，与好友组队通关更轻松！"},--
					[3] = {stype = 9,sound = 32},
					-- [2] = {stype = 2,position={139,432},},
				},
			},

			--介绍守护昆阳
			[5] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 10,rect={265,103,595,150},alignx=2,aligny=2 ,not_move = true},
					[2] = {stype = 1,position={220,240},dest="#c74341a打败的怪物越多，奖励就越丰厚哟！"},--
					[3] = {stype = 9,sound = 33},
					-- [2] = {stype = 2,position={139,432},},
				},
			},
			
			--点击自动匹配
			[6] ={
				rect={252,43,139,57},
				element =
				{
					[1] = {stype = 10,rect={252,43,139,57},alignx=2,aligny=2 ,not_move = true},
					[2] = {stype = 1,position={100,100},dest="#c74341a点击#c4fbb00自动匹配#c74341a，轻松组队下副本吧～"},--
					[3] = {stype = 9,sound = 34},
					-- [2] = {stype = 2,position={139,432},},
				},
			},
		},

		--30级 武将系统
		[30] =
		{
			--开启武将
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/mainMenu/5.png",position={56,590},alignx=1,aligny=3},
				},
			},

			--点击头像
			[2] ={

				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,90},alignx=1,aligny=3,not_move = true},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c4fbb00武将图鉴#c74341a收录了战功显赫的二十八将，去看看吧~"},
					[3] = {stype = 9,sound = 35},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},

			--点击武将
			[3] ={
				rect={243,218,88,93},
				touch_target = 1110,
				element =
				{	
					[1] = {stype = 10,rect={250,218,77,83},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={310,0},dest="#c74341a收集武将可获#c4fbb00属性加成#c74341a，彼此#c4fbb00组合还可激活技能#c74341a~"},--
					[3] = {stype = 9,sound = 36},
				},
			},

			--点击武将卡牌第一张
			[4] ={
				rect={57,265,158,222},
				-- touch_target = 1106,
				element =
				{	
					[1] = {stype = 10,rect={57,265,158,222},alignx=2,aligny=2,not_move = true},
					-- [1] = {stype = 2,position={814,210},},
				},
			},

			--介绍武将升级升阶
			[5] ={
				touch_to_next = true,
				-- touch_target = 1106,
				element =
				{	
					[1] = {stype = 10,rect={186,122,224,46},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={00,180},dest="#c74341a武将可以#c4fbb00升级和升阶#c74341a，当前#c4fbb00品阶会限制最高等级#c74341a～"},
					[3] = {stype = 9,sound = 37},
					-- [1] = {stype = 2,position={814,210},},
				},
			},

			--点击武将卡牌升级
			[6] ={
				rect={643,120,139,54},
				-- touch_target = 1106,
				element =
				{	
					[1] = {stype = 10,rect={643,120,139,54},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={230,180},dest="#c74341a升级武将可#c4fbb00大幅提升人物属性#c74341a，试试升级武将吧～"},
					[3] = {stype = 9,sound = 38},
				},
			},

			--开启云台将录
			[7] ={
				close_win = true,
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_17.png",position={717,551},alignx=3,aligny=3,},
					[2] = {stype = 12,	search_type = "wujiang"},
				},
			},

		},

		--31级 跑环+5大PVP活动
		[31] =
		{
			--5大PVP活动
			[1] ={
				element =
				{
					[1] = {
						stype = 13,
						bg="nopack/xszy/open_pvp.png",
						icons =
						{
							"icon/huoyue/00020.pd",
							"icon/huoyue/00021.pd",
							"icon/huoyue/00022.pd",
							"icon/huoyue/00023.pd",
							"icon/huoyue/00019.pd",
						},
						pos =
						{
							{735,570},
							{735,570},
							{735,570},
							{735,570},
							{735,570},
						},
						align =
						{
							{ alignx=3,aligny=3 },
							{ alignx=3,aligny=3 },
							{ alignx=3,aligny=3 },
							{ alignx=3,aligny=3 },
							{ alignx=3,aligny=3 },
						},
					},
				},
			},

			--开启跑环 
			[2] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_25.png",position={797,551},alignx=3,aligny=3,},
				},
			},


			-- --开启PVP玩法
			-- [1] ={
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 4,icon="sui/xszy/icon_25.png",position={717,551},alignx=3,aligny=3,},
			-- 	},
			-- },
		},
		
		

		--32级 宝石镶嵌图标飘入，接ID = 5146号引导任务
		[32] =
		{
			--开启龙脉珍宝
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_24.png",position={717,551},alignx=3,aligny=3,},
				},
			},
		},

		--洗练图标飘入，接ID = 5149号引导任务，开启箴机奇图	
		[33] = 
		{
			--开启洗练
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_8.png",position={56,590},alignx=1,aligny=3,},
				},
			},

			--开启剑试云台
			[2] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_23.png",position={717,551},alignx=3,aligny=3,},
				},
			},

			-- --开启箴机奇图
			-- [2] ={
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 4,icon = "sui/xszy/icon_15.png",position={717,551},alignx=3,aligny=3,},
			-- 		},
			-- },
		},

		--36级 武将图鉴
		[36] =
		{
			--开启武将图鉴升级
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="icon/huoyue/00037.pd",position={56,590},alignx=1,aligny=3,},--需要添加武将图鉴
				},
			},
		},

		--40级 伙伴亲密
		[40] =
		{
			--开启伙伴亲密
			[1] ={
				element =
				{
					[1] = {stype = 4,icon = "icon/huoyue/00036.pd",position={56,590},alignx=1,aligny=3,},
				},
			},
		},


		--50级 神铸
		[50] = 
		{
			--开启神铸
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_5.png",position={56,590},alignx=1,aligny=3,},	
				},
			},
		-- 	--文字1
		-- 	[2] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 1,position={330,260},dest="#c74341a神铸可提升装备品质，大幅提升装备属性！"},
		-- 			[2] = {stype = 3,rect={1,1,1,1},not_move=true,},
		-- 		},
 	-- 		},
 	-- 		--指引头像
		-- 	[3] ={
		-- 		rect={8,553,78,87},
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 3,rect={8,553,78,87},alignx=1,aligny=3,},
		-- 			[2] = {stype = 2,position={47,596},alignx=1,aligny=3,},
		-- 		},
		-- 	},
		-- 	--指引铸造
		-- 	[4] ={
		-- 		rect={103,146,77,86},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={103,146,77,86},index=2,},
		-- 			[2] = {stype = 2,position={141,189},},
		-- 		},
		-- 	},
		-- 	--指引神铸
		-- 	[5] ={
		-- 		rect={902,205,49,92},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={902,205,49,92},},
		-- 			[2] = {stype = 2,position={926,247},},
		-- 		},
		-- 	},
		-- 	--文字2
		-- 	[6] ={
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 1,position={330,260},dest="#c74341a只有紫色或橙色装备才能进行神铸哦！"},
		-- 			[2] = {stype = 3,rect={1,1,1,1},not_move=true,},
		-- 		},
 	-- 		},
		},
	},

	--接受完成促发指引
	accept_question = 
	{
		--任务ID=21 剧情副本 -接取通关剧情副本1-1的任务后触发
		[21] = 
		{
			priority = -1,
			--开启新功能 剧情副本
			-- [1] ={
			-- 	element = 
			-- 	{
			-- 		[1] = {stype = 4,icon = "sui/rightTop/first_row_1.png",position={890,488},alignx=3,aligny=3,},
			-- 	},
			-- },
			--手指引导剧情副本+文字+
			[1] ={
				rect={9,357,225,69},
				touch_target = -1,
				delay = 1,
				element =
				{
					
					-- [1] = {stype = 10,rect={875,471,70,80},alignx=3,aligny=3,not_move = true},
					[1] = {stype = 2,position={120,393},alignx=1,aligny=3,},
					[2] = {stype = 1,position={180,150},dest="#c74341a你想知道丽华和文叔哥哥的#c4fbb00感人故事#c74341a吗？点~这里~",alignx=1,aligny=3,},
					[3] = {stype = 9,sound = 39},
					-- [2] = {stype = 2,position={915,511},alignx=3,aligny=3,},
				},
			},
				
			-- --手指+剧情副本第一章
			-- [3] ={
			-- 	rect={54,30,166,454},
			-- 	touch_target = 12040101,
			-- 	delay = 1,
			-- 	element =
			-- 	{
			-- 		-- [1] = {stype = 2,position={137,257},},
			-- 		[1] = {stype = 10,rect={54,30,166,454},alignx=2,aligny=2,not_move = true},
			-- 		[2] = {stype = 1,position={200,80},dest="#c74341a亲身重温剧情副本动人情节后，还可#c4fbb00获得星魂#c74341a呢。"},
			-- 		[3] = {stype = 9,sound = 40},
			-- 	},
			-- },		
			-- --手指+剧情副本第一章第一节
			-- [4] ={
			-- 	rect={204,43,110,425},
			-- 	touch_target = 12040102,
			-- 	element =
			-- 	{
			-- 		-- [1] = {stype = 2,position={260,255},},
			-- 		[1] = {stype = 10,rect={204,43,110,425},alignx=2,aligny=2,not_move = true},
			-- 	},
			-- },
			--手指+剧情副本第一章第一节进入按钮
			[2] ={
				rect={612,50,139,57},
				element =
				{
					-- [1] = {stype = 2,position={712,82},},
					[1] = {stype = 10,rect={612,50,139,57},alignx=2,aligny=2,not_move = true},
				},
			},
		},

		



		--悬赏任务引导，接受任务ID=	70 25级最后一个主线
		[70] =
		{
			priority = -1,
			--开启悬赏
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/xszy/icon_11.png",position={800,561},alignx=3,aligny=3,}, 
				},
			},

			--点击日常
			[2] ={
				rect={789,545,98,103},
				touch_target = 1302,
				element =
				{
					[1] = {stype = 10,rect={800,550,65,75},index=2,alignx=3,aligny=3,not_move=true},
					[2] = {stype = 1,position={250,280},dest="#c74341a经验奖励哪里多？日常任务找#c4fbb00悬赏#c74341a~"},
					[3] = {stype = 9,sound = 41},
				},
			},
			--悬赏页签引导
			[3] ={
				rect={902,366,67,108},
				touch_target = 130201,
				element =
				{
					-- [1] = {stype = 7,win = 3,},
					[1] = {stype = 10,rect={907,376,40,108},alignx=2,aligny=2},
				},
			},
			--悬赏星级引导
			[4] ={
				touch_to_next = true,
				element =
				{
					-- [1] = {stype = 3,rect={0,0,0,0},alignx=1,aligny=3,not_move =true,},
					[1] = {stype = 10,rect={425,444,250,40},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={120,120},dest="#c74341a点击箭头进行#c4fbb00任务升星#c74341a~星级越高，奖励越丰厚！"},
					[3] = {stype = 9,sound = 42},
				},
			},
			--点击接受
			[5] ={
				rect={691,438,136,51},
				element =
				{
					[1] = {stype = 10,rect={691,438,136,51},not_move = true},
					[2] = {stype = 1,position={180,130},dest="#c74341a悬赏任务可获得#c4fbb00大量经验#c74341a，快去完成悬赏任务吧～"},
					[3] = {stype = 9,sound = 43},
				},
			},
		},
	},

	--任务完成促发指引
	finish_question = 
	{
		--任务ID=1 快速穿戴武器+再次指引任务寻路
		-- [1] = 
		-- {
		-- 	priority = -1,
		-- 	--快速穿戴
		-- 	[1] ={
		-- 		rect={749,276,97,32},
		-- 		-- count_down = 8,
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 1,position={112,150},dest="#c74341a装备这把武器，变厉害了就可以保护丽华啦~"},
		-- 			-- [2] = {stype = 3,rect={645,200,312,78},alignx=3,aligny=3,},
		-- 			[2] = {stype = 2,position={809,293},alignx=3,aligny=2,},
		-- 			[3] = {stype = 9,sound = 44},
		-- 		},
		-- 	},
		-- 	--再次指引任务寻路
		-- 	[2] ={
		-- 		rect={9,357,225,69},
		-- 		element = 
		-- 		{
		-- 			-- [1] = {stype = 1,position={202,100},dest="#c74341a试试点击任务小面板，接取第一个任务！"},
		-- 			[1] = {stype = 2,position={120,393},alignx=1,aligny=3,},
		-- 		},
		-- 	},
		-- },

		-- --任务ID=4 快速穿戴
		-- [4] = 
		-- {
		-- 	priority = -1,
		-- 	--快速穿戴
		-- 	[1] ={
		-- 		rect={749,276,97,32},
		-- 		-- count_down = 8,
		-- 		element = 
		-- 		{
		-- 			-- [1] = {stype = 1,position={50,130},dest="#c74341a点击装备这把武器！"},
		-- 			-- [2] = {stype = 3,rect={645,200,312,78},alignx=3,aligny=3,},
		-- 			[1] = {stype = 2,position={809,293},alignx=3,aligny=2,},
		-- 		},
		-- 	},
		-- },

		--任务ID=21 点亮新图，完成通关剧情副本1-1后触发，接取5152
		[21] =
		{
			priority = -1,
			--开启星图
			[1] ={
				element =
				{
					[1] = {stype = 4,icon="sui/other/xingtu.png",position={890,488},alignx=3,aligny=3,}, 
				},
			},
		},

		
	},

	wujaing =
	{	
		[1] = {
			priority = 10,
			[1] = {
				element =
				{
					[1] = {stype = 11,icon = "sui/wujiang/card_bg_1.png",position={56,590},alignx=1,aligny=3,},
				},
			},
		},
	
	},

	--新技能开启
	skill = 
	{
		--3级 开启技能1
		[3] =
		{	
			--priority = 10000,
			[1] = {
				element =
				{
					[1] = {stype = 5,icon = "sui/skill/skill_bg.png",position={765,54},index = 1,alignx=3,aligny=1,},
				},
			},
		
		},
		--8级 开启技能2
		[8] =
		{
			--priority = 10000,
			[1] = {
				element =
				{
					[1] = {stype = 5,icon = "sui/skill/skill_bg.png",position={758,146},index = 2,alignx=3,aligny=1,},
				},
			},
		
		},
		--12级 开启技能3
		[12] =
		{
			priority = 10000,
			[1] = {
				element =
				{
					[1] = {stype = 5,icon = "sui/skill/skill_bg.png",position={820,206},index = 3,alignx=3,aligny=1,},
				},
			},
		
		},
		--16级 开启技能4
		[16] =
		{
			--priority = 10000,
			[1] = {
				element =
				{
					[1] = {stype = 5,icon = "sui/skill/skill_bg.png",position={911,200},index = 4,alignx=3,aligny=1,},
				},
			},
		},

		-- [24] =
		-- {
		-- 	--priority = 10000,
		-- 	[1] ={
		-- 		rect={4,392,272,55}, 
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 3,rect={0,392,272,125},index = 1,alignx=1,aligny=3,},
		-- 			[2] = {stype = 2,position={136,425},alignx=1,aligny=3,},
		-- 		},
		-- 	},

		-- 	[2] = {
		-- 		--rect={8,553,78,87},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 3,rect={700,-100,400,400},index=2,alignx=1,aligny=3,},
		-- 			[2] = {stype = 1,position={330,260},dest="#c74341a滑动释放必杀技！"},
		-- 			[3] = {stype = 8},				
		-- 		},
		-- 	},
		-- },
	},

	--主动 触发引导
	touch_task = {

		--神驹猎狩玩法，24级推送 ID=5141 引导任务
		[4301] = 
		{
			--指引点击玩法
			[1] ={
				rect={711,545,98,103},
				touch_target = 1301,
				element =
				{
					[1] = {stype = 10,rect={720,550,65,75},alignx=3,aligny=3},
					-- [1] = {stype = 2,position={755,586},alignx=3,aligny=3, },
				},
			},

			--指引副本页签
			[2] ={
				rect={900,374,67,108},
				touch_target = 130102,
				element =
				{
					[1] = {stype = 7,win = 2,},
					[2] = {stype = 10,rect={906,368,40,108},alignx=2,aligny=2},
					-- [2] = {stype = 2,position={753,588},alignx=3,aligny=3, },
				},
			},
			
			--点击神驹猎狩
			[3] ={
				rect={49,372,185,76},
				touch_target = 13010202,
				element =
				{
					[1] = {stype = 10,rect={57,380,165,75},alignx=2,aligny=2},
					-- [2] = {stype = 2,position={139,432},},
				},
			},

			--出现文字说明
			[4] ={
				touch_to_next = true,
				element =
				{
					
					[1] = {stype = 1,position={200,230},dest="#c74341a副本【神驹猎狩】暗藏大~量#c4fbb00坐骑培养材料#c74341a！"},--
					[2] = {stype = 10,rect={590,130,260,100},alignx=2,aligny=2,not_move=true},
					[3] = {stype = 9,sound = 45},
				},
			},

			--指引点击进入
			[5] ={
				rect={734,43,139,54},
				element =
				{
					
					[1] = {stype = 1,position={250,120},dest="#c74341a现在就去#c4fbb00坐骑副本【神驹猎狩】#c74341a吧～"},--
					[2] = {stype = 10,rect={734,43,139,54},alignx=2,aligny=2,not_move=true},
					[3] = {stype = 9,sound = 46},
				},
			},
		},

		

		--演武场玩法，28级推送 ID=5143 引导任务
		[4303] = 
		{
			--指引点击玩法
			[1] ={
				rect={711,545,98,103},
				touch_target = 1301,
				element =
				{
					[1] = {stype = 10,rect={720,550,65,75},alignx=3,aligny=3,not_move=true},
					[2] = {stype = 1,position={230,280},dest="#c4fbb00演武场#c74341a是个一言不合就开打的地方！"},--
					[3] = {stype = 9,sound = 47},
					-- [1] = {stype = 2,position={755,586},alignx=3,aligny=3, },
				},
			},

			--特效出现在列表上的演武场处
			[2] ={
				touch_to_next = true,
				element =
				{
					-- [1] = {stype = 7,win = 2,},
					[1] = {stype = 1,position={180,120},dest="#c74341a在这里可以与全服玩家进行PK。"},--
					[2] = {stype = 9,sound = 48},
					-- [3] = {stype = 3,rect={0,0,0,0},alignx=2,aligny=2,not_move=true},
					-- [2] = {stype = 2,position={753,588},alignx=3,aligny=3, },
				},
			},
			
			--凸显商店
			[3] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 10,rect={470,55,407,80},alignx=2,aligny=2,not_move=true},
					[2] = {stype = 1,position={250,150},dest="#c4fbb00威望#c74341a可兑换#c4fbb00珍稀材料#c74341a，#c4fbb00战报和排行#c74341a可了解战况~"},--
					[3] = {stype = 9,sound = 49},
					-- [2] = {stype = 2,position={139,432},},
				},
			},

			--点击演武场一个玩家
			[4] ={
				rect={248,195,157,333},
				element =
				{
					[1] = {stype = 10,rect={248,195,157,333},alignx=2,aligny=2,not_move=true},
					[2] = {stype = 1,position={350,120},dest="#c74341a快去挑战吧～排名越高，奖励越多噢"},--
					[3] = {stype = 9,sound = 50},
					-- [2] = {stype = 2,position={139,432},},
				},
			},

			--点击挑战
			[5] ={
				rect={248,195,157,333},
				element =
				{
					[1] = {stype = 10,rect={248,195,157,333},alignx=2,aligny=2,not_move=true},
					-- [2] = {stype = 2,position={139,432},},
				},
			},
		},

		--武力试炼玩法，30级推送 ID=5144 引导任务
		[4304] = 
		{
			--指引点击玩法
			[1] ={
				rect={711,545,98,103},
				touch_target = 1301,
				element =
				{
					[1] = {stype = 10,rect={720,550,65,75},alignx=3,aligny=3,not_move = true},
					[2] = {stype = 1,position={230,280},dest="#c4fbb00武力试炼#c74341a能让你清楚知道自己的战力极限。"},--
					[3] = {stype = 9,sound = 51},
					-- [1] = {stype = 2,position={755,586},alignx=3,aligny=3, },
				},
			},

			--特效出现在列表上的武力试炼处
			[2] ={
				rect={51,381,186,76},
				touch_target = 13010102,
				element =
				{
					-- [1] = {stype = 7,win = 2,},
					[1] = {stype = 10,rect={51,381,186,76},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={200,150},dest="#c74341a这里还产出#c4fbb00大量宝石和强化材料#c74341a~"},--
					[3] = {stype = 9,sound = 52},
					-- [2] = {stype = 2,position={753,588},alignx=3,aligny=3, },
				},
			},
			
			--文字说明
			[3] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 1,position={380,120},dest="#c74341a每五层还有#c4fbb00额外宝箱奖励#c74341a等着你~"},
					[2] = {stype = 10,rect={250,50,160,480},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 53},
					-- [3] = {stype = 3,rect={0,0,0,0},not_move=true,},
				},
			},
			--文字说明
			[4] ={
				touch_to_next = true,
				element =
				{
					[1] = {stype = 1,position={350,300},dest="#c74341a重置可回到第一层重新挑战，每天#c4fbb00免费重置1次#c74341a。"},
					[2] = {stype = 10,rect={708,227,160,70},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 54},
					-- [3] = {stype = 3,rect={0,0,0,0},not_move=true,},
				},
			},
			--文字说明
			[5] ={
				rect={579,89,139,57},
				element =
				{
					[1] = {stype = 1,position={250,160},dest="#c74341a现在就去挑战自己的极限吧！"},
					[2] = {stype = 10,rect={579,89,139,57},not_move = true},
					[3] = {stype = 9,sound = 55},
				},
			},
		},

		--组队副本，即守卫昆阳，31级推送 ID=5145 引导任务
		-- [5145] = 
		-- {
		-- 	--玩法界面弹出，特效出现在列表上的处
		-- 	[1] ={
		-- 		rect={900,374,67,108},
		-- 		touch_target = 130102,
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 7,win = 2,},
		-- 			[2] = {stype = 10,rect={906,368,40,108},alignx=1,aligny=3},
		-- 			-- [2] = {stype = 2,position={753,588},alignx=3,aligny=3, },
		-- 		},
		-- 	},
			
		-- 	--点击组队守卫昆阳，即守卫昆阳
		-- 	[2] ={
		-- 		rect={49,230,185,76},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 10,rect={49,230,185,76},alignx=1,aligny=3},
		-- 			[2] = {stype = 1,position={120,120},dest="#c74341a多人副本经验、奖励丰厚，与小伙伴组队通关更轻松！"},--
		-- 			-- [2] = {stype = 2,position={139,432},},
		-- 		},
		-- 	},

		-- 	--点击自动匹配
		-- 	[3] ={
		-- 		rect={252,43,139,57},
		-- 		element =
		-- 		{
		-- 			[1] = {stype = 10,rect={252,43,139,57},alignx=1,aligny=3},
		-- 			-- [2] = {stype = 2,position={139,432},},
		-- 		},
		-- 	},
		-- },

		--宝石镶嵌，33级推送 ID=5146 引导任务
		[4306] =
		{
			--指引头像
			[1] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a不镶嵌宝石的装备不是好武器，快来试试看~"},
					[3] = {stype = 9,sound = 56},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			--指引铸造
			[2] ={
				rect={443,368,88,93},
				touch_target = 1105,
				element =
				{
					-- [1] = {stype = 2,position={158,215}, },
					[1] = {stype = 10,rect={450,368,77,83},alignx=2,aligny=2,not_move = true},
					-- [2] = {stype = 1,position={190,-30},dest="#c74341a强化装备可以大幅提升战力，如果感觉打怪吃力就快来强化装备吧！"},
				},
			},
			--点击镶嵌页签
			[3] ={
				rect={901,96,67,108},
				touch_target = 110505,
				element =
				{
					-- [1] = {stype = 7,win = 4,},
					[1] = {stype = 10,rect={905,96,40,108},alignx=2,aligny=2,not_move= true},
					[2] = {stype = 1,position={220,80},dest="#c74341a镶嵌宝石可#c4fbb00大幅提升角色属性#c74341a，#c4fbb00高级宝石可由低级宝石合成获得#c74341a噢～"},
					[3] = {stype = 9,sound = 57},
					-- [1] = {stype = 2,position={935,339}, },
				},
			},

			--点击一颗宝石
			[4] ={
				touch_to_next = true,
				element = 
				{
					[1] = {stype = 10,rect={720,415,75,80},alignx=2,aligny=2,not_move= true},
					[2] = {stype = 1,position={330,150},dest="#c74341a当前装备可镶嵌的宝石是亮着的噢～快选一颗吧。"},
					[3] = {stype = 9,sound = 58},
					-- [1] = {stype = 2,position={594,70},},
				},
			},

			--点击镶嵌按钮
			[5] ={
				rect={445,41,139,54},
				element = 
				{
					[1] = {stype = 10,rect={445,41,139,54},alignx=2,aligny=2,not_move= true},
					[2] = {stype = 1,position={130,100},dest="#c74341a点击这里镶嵌宝石，战力又噌噌噌地往上涨啦～"},
					[3] = {stype = 9,sound = 59},
					-- [1] = {stype = 2,position={594,70},},
				},
			},
		},

		--剧情副本精英难度，32级推送 ID=5147 引导任务
		[4307] =
		{
			--弹出剧情副本面板，点击精英页签
			[1] ={
				rect={348,482,130,57},
				touch_target = 12040103,
				element =
				{
					[1] = {stype = 7,win = 6,},
					[2] = {stype = 10,rect={348,482,130,57},alignx=2,aligny=2,not_move= true},
					[3] = {stype = 1,position={50,150},dest="#c74341a精英副本#c4fbb00奖励更加丰厚#c74341a噢～"},
					[4] = {stype = 9,sound = 60},
					-- [1] = {stype = 2,position={935,339}, },
				},
			},
			
			--手指+剧情副本第一章
			[2] ={

				rect={54,30,166,454},
				touch_target = 12040101,
				delay = 1,
				element =
				{
					-- [1] = {stype = 2,position={137,257},},
					[1] = {stype = 10,rect={54,30,166,454},alignx=2,aligny=2,not_move = true},
				},
			},		
			--手指+剧情副本第一章第一节
			[3] ={
				rect={204,43,110,425},
				touch_target = 12040102,
				element =
				{
					-- [1] = {stype = 2,position={260,255},},
					[1] = {stype = 10,rect={204,43,110,425},alignx=2,aligny=2,not_move = true},
				},
			},
			--手指+剧情副本第一章第一节进入按钮
			[4] ={
				rect={612,50,139,57},
				element =
				{
					-- [1] = {stype = 2,position={712,82},},
					[1] = {stype = 10,rect={612,50,139,57},alignx=2,aligny=2,not_move = true},
				},
			},
		},

		--指引伙伴加成
		[4310] =
		{

			--指引加成
			[1] ={
				rect={901,361,67,108},
				touch_target = 110302,
				element =
				{	
					[1] = {stype = 7,win = 5,},
					[2] = {stype = 10,rect={907,370,40,108},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 1,position={200,230},dest="#c4fbb00获得伙伴#c74341a即可#c4fbb00激活对主角的属性加成#c74341a噢～"},
					-- [4] = {stype = 9,sound = 61},
				},
			},

			-- --加成说明
			-- [2] ={
			-- 	touch_to_next= true,
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 1,position={200,185},dest="#c4fbb00出战#c74341a伙伴#c4fbb00可积累#c74341a，道具也可提升喔~"},
			-- 		[2] = {stype = 10,rect={299,142,572,46},alignx=2,aligny=2,not_move = true},
			-- 		-- [3] = {stype = 9,sound = 62},
			-- 		-- [2] = {stype = 2,position={798,69},},
			-- 	},
			-- },

			--指引点击强化
			[2] ={
				rect={535,32,139,57},
				element =
				{
					[1] = {stype = 1,position={200,100},dest="#c74341a培养#c4fbb00可提升亲密度，从而提升属性加成#c74341a～快来试试吧～"},
					[2] = {stype = 10,rect={535,32,139,57},alignx=2,aligny=2,not_move = true},
					-- [3] = {stype = 9,sound = 63},
					-- [2] = {stype = 2,position={798,69},},
				},
			},
		},

		--指引技能
		[4311] = 
		{
			--指引头像
			[1] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true,},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a丽华在藏书阁找到一些技能书，一起去看看吧~"},
					[3] = {stype = 9,sound = 64},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},

			--指引技能
			[2] ={
				rect = {343,368,88,93},
				touch_target = 1101,
				element =
				{
					-- [1] = {stype = 2,position={816,454}, },
					[1] = {stype = 1,position={380,120},dest="#c74341a这个#c4fbb00技能#c74341a好像很厉害的样子～"},
					[2] = {stype = 10,rect={350,368,77,83},alignx=2,aligny=2 ,not_move = true,},
					[3] = {stype = 9,sound = 65},
				},
			},
			--凸显升级+点击
			[3] ={
				rect = {737,51,139,54},
				touch_target = 110101,
				element = 
				{
					[1] = {stype = 1,position={350,100},dest="#c74341a还可以#c4fbb00升级技能#c74341a，快点试试吧～"},
					[2] = {stype = 10,rect={737,51,139,54},alignx=2,aligny=2 ,not_move = true,},
					[3] = {stype = 9,sound = 66},
					-- [2] = {stype = 2,position={805,81},},
				},
			},
			-- --指引升级
			-- [6] ={
			-- 	rect={744,48,144,60},
			-- 	touch_target = 110101,
			-- 	element = 
			-- 	{
			-- 		[1] = {stype = 2,position={816,78}, },
			-- 	},
			-- },
			-- 文字+凸显技能特效
			[4] ={
				rect={218,75,69,68},
				element =
				{
					[1] = {stype = 1,position={280,0},dest="#c74341a善用技能升级后的#c4fbb00附加效果#c74341a，是胜利的关键哦！"},
					[2] = {stype = 10,rect={218,75,69,68},alignx=2,aligny=2 ,not_move = true,},
					[3] = {stype = 9,sound = 67},
					-- [2] = {stype = 2,position={253,109},},
				},
			},
		},

		--指引 剧情副本 -【星图】 7级推送任务4312
		[4312] = 
		{
			--点击剧情副本
			[1] = {
				rect={875,471,79,80},
				touch_target = 1204,	
				element = 
				{
					[1] = {stype = 10,rect={875,471,70,80},alignx=3,aligny=3,not_move=true},
					[2] = {stype = 1,position={300,230},dest="#c74341a你听！buling~buling~的星魂在召唤你~"},
					[3] = {stype = 9,sound = 68},
					-- [2] = {stype = 2,position={915,511},alignx=1,aligny=3,},
				},
			},
			--点击星图标签
			[2] ={
				rect={902,373,67,108},
				touch_target = 120402,	
				element = 
				{
					[1] = {stype = 1,position={250,200},dest="#c74341a星魂就藏在星图里~可用来#c4fbb00点亮星图中的星宿#c74341a喔"},
					[2] = {stype = 10,rect={907,373,40,108},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 69},
					-- [2] = {stype = 2,position={930,435},},
				},
			},
			--激活星图
			[3] ={
				rect={683,46,139,57,},
				element = 
				{
					[1] = {stype = 1,position={250,100},dest="#c74341a快来#c4fbb00点亮一颗星宿#c74341a试试吧~"},
					[2] = {stype = 10,rect={683,46,139,57,},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 70},
					-- [2] = {stype = 2,position={755,80},},
				},
			},
			--文字记得回来点星图
			[4] ={
				element =
				{
					[1] = {stype = 1,position={250,100},dest="#c74341a点亮星图可令你#c4fbb00战力爆表#c74341a呐~千万不要告诉别人~"},
					[2] = {stype = 9,sound = 71},
				},
			},
		},

		--指引 天机奇缘 24级推送任务4314
		[4314] = 
		{
			priority = -1,
			
			--指引点击玩法
			[1] ={
				rect={711,545,98,103},
				touch_target = 1301,
				element =
				{
					[1] = {stype = 10,rect={720,550,65,75},alignx=3,aligny=3,},
					-- [1] = {stype = 2,position={755,586},alignx=3,aligny=3, },
				},
			},

			--点击副本页签
			[2] ={
				rect={900,374,67,108},
				touch_target = 130102,
				element =
				{
					-- [1] = {stype = 7,win = 2,},
					[1] = {stype = 10,rect={906,368,40,108},alignx=2,aligny=2,not_move = true},
					-- [2] = {stype = 2,position={753,588},alignx=3,aligny=3, },
				},
			},
			
			-- --点击天机奇缘
			-- [3] ={
			-- 	rect={49,372,185,76},
			-- 	element =
			-- 	{
			-- 		[1] = {stype = 10,rect={57,380,165,75},alignx=1,aligny=3},
			-- 		-- [2] = {stype = 2,position={139,432},},
			-- 	},
			-- },

			--出现文字说明
			[3] ={
				touch_to_next = true,
				element =
				{
					
					[1] = {stype = 1,position={200,220},dest="#c74341a副本【天机奇缘】暗藏大~量#c4fbb00伙伴培养材料#c74341a！"},--
					[2] = {stype = 10,rect={590,130,260,100},alignx=2,aligny=2,not_move=true},
					[3] = {stype = 9,sound = 72},
				},
			},

			--指引点击进入
			[4] ={
				rect={734,43,139,54},
				element =
				{
					
					[1] = {stype = 1,position={250,120},dest="#c74341a现在就去伙伴副本【天机奇缘】吧~"},--
					[2] = {stype = 10,rect={734,43,139,54},alignx=2,aligny=2,not_move=true},
					[3] = {stype = 9,sound = 73},
				},
			},
		},


		--指引 武将图鉴 40级推送任务4315	--还差文案
		[4315] =
		{
			--点击头像
			[1] ={

				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					-- [1] = {stype = 1,position={150,120},dest="#c74341a除了武将可以升级，图鉴也是神器噢~"},--
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},

			--点击武将
			[2] ={
				rect={250,218,77,83},
				touch_target = 1110,
				element =
				{	
					[1] = {stype = 10,rect={250,218,77,90},alignx=2,aligny=2,not_move = true},
					-- [2] = {stype = 1,position={180,50},dest="#c74341a收集武将可获得属性加成，收集特定组合的武将还可以获得武将技能喔～"},--
				},
			},

			--点击图鉴
			[3] ={
				rect={752,498,125,44},
				-- touch_target = 1110,
				element =
				{	
					[1] = {stype = 1,position={350,250},dest="#c74341a除了武将卡牌可提升大量属性，#c4fbb00图鉴也是神器#c74341a噢~"},--
					-- [2] = {stype = 1,position={180,50},dest="#c74341a好了，快去升级图鉴吧～"},--
					-- [1] = {stype = 3,rect={752,498,125,44},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 10,rect={752,498,125,44},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 74},
				},
			},

			--指引属性的加成
			[4] ={
				touch_to_next = true,
				-- touch_target = 1110,
				element =
				{	
					
					[1] = {stype = 1,position={150,150},dest="#c74341a提升图鉴等级，可以#c4fbb00大幅提升武将的总加成#c74341a～"},--
					-- [1] = {stype = 3,rect={478,408,230,40},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 10,rect={478,408,230,40},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 75},
				},
			},

			--指引点击提升
			[5] ={
				rect={526,129,139,54},
				-- touch_target = 1110,
				element =
				{	
					
					[1] = {stype = 1,position={180,200},dest="#c74341a好了，快去#c4fbb00升级图鉴#c74341a吧～"},--

					-- [1] = {stype = 3,rect={526,129,139,54},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 10,rect={526,129,139,54},alignx=2,aligny=2,not_move = true},
					[3] = {stype = 9,sound = 76},
				},
			},
		},

		--指引 装备铸造 31级推送任务4316
		[4316] =
		{
			--指引头像
			[1] ={
				rect={11,543,81,84},
				touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={11,543,81,84},alignx=1,aligny=3,not_move = true},
					[2] = {stype = 1,position={80,320},alignx=1,aligny=3,dest="#c74341a已经游历秀丽江山好久咯，有没有记得去#c4fbb00强化装备#c74341a呀~"},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			--指引铸造
			[2] ={
				rect={443,368,88,93},
				touch_target = 1105,
				element =
				{
					-- [1] = {stype = 2,position={158,215}, },
					[1] = {stype = 10,rect={450,368,77,83},alignx=2,aligny=2,not_move = true},
					[2] = {stype = 1,position={160,100},dest="#c74341a一定要记得#c4fbb00强化装备#c74341a，才能保护好丽华噢～"},
					-- [3] = {stype = 9,sound = 5},
				},
			},
			--文字 强化+点击强化
			[3] ={
				rect={728,42,139,54},
				element =
				{
					[1] = {stype = 1,position={350,110},dest="#c74341a快去#c4fbb00强化#c74341a吧～"},
					[2] = {stype = 10,rect={728,42,139,54},alignx=2,aligny=2,not_move = true},
					-- [3] = {stype = 9,sound = 7},
					-- [2] = {stype = 2,position={798,69},},
				},
			},
		},
	},
}







--[[
	node_tag 节点标签 （必填参数，每步必须有） sguide_operation.lua的 weak_guide_node_map 参选
	win_map_id 打开哪个窗口（选填） sguide_operation.lua的 sguide_win_map 参选
		win_page 打开该窗口的哪个标签页（选填）  这两个一般都在第一步
	touch_target  跟强引导的一个意思（选填）  sguide_operation.lua的 sguide_operation_map 参选
	pop_right_menus_panel 弹出或者关闭右边的小面板，nil不进行处理
	ref  当前步刷新引导，针对主面板 第一步加上其余不加 （）
	delay 当前步骤延时一定时间，再执行下一步
]]
sweakguide_config = {
	accept_task = {

		-- --聚宝盆，29级推送 ID=5148 引导任务
		-- [4308] = {
		-- 	--ref = true,
		-- 	[1] ={
		-- 		node_tag = "1000",
		-- 		pop_right_menus_panel = true,
		-- 		ref = true,
		-- 		rect={90,0,100,100},
		-- 		-- win_map_id = 4,
		-- 		-- win_page = 5,
		-- 		touch_target = 1203,
		-- 		element = 
		-- 		{
		-- 			[1] = {stype = 10,rect={98,3,55,63},alignx=2,aligny=2,not_move= true},
		-- 			-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
		-- 		},
		-- 	},
		-- 	[2] ={
		-- 		node_tag = "2000",
		-- 		rect={188,70,139,57},
		-- 		element = 
		-- 		{
		-- 			--[1] = {stype = 1,position={202,100},dest="#c74341a试试点击任务小面板，接取第一个任务！"},
		-- 			[1] = {stype = 10,rect={188,70,139,57},alignx=1,aligny=3,not_move= true},
		-- 		},
		-- 	},
		-- },

		--装备洗练，39级推送 ID=5149 引导任务
		[4309] = {
			[1] ={
				node_tag = "200",
				rect={489,21,139,54},
				win_map_id = 4,
				win_page = 2,
				--touch_target = 11,
				element = 
				{
					[1] = {stype = 10,rect={489,21,139,54},alignx=2,aligny=2,not_move =true},
					-- [2] = {stype = 2,position={47,596},alignx=1,aligny=3, },
				},
			},
			-- [1] ={
			-- 	node_tag = "200",
			-- 	rect={524,43,139,54},
			-- 	element = 
			-- 	{
			-- 		--[1] = {stype = 1,position={202,100},dest="#c74341a试试点击任务小面板，接取第一个任务！"},
			-- 		[1] = {stype = 10,position={524,43,139,54},alignx=1,aligny=3,},
			-- 	},
			-- },
		},


	},
}
