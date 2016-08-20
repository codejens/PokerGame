xszy = {
	-- 新手指引的配置
	--[[
	[指引id] = { [步骤一] = {x = 出现的x坐标, y = 出现的y坐标, str = 显示的字符串, direction = 指向的方向(1=右，2=左，3=上，4=下), 
				width = 框的宽度, height = 框的高度, },
				 [步骤二] = {...},
				},
	...
	]]--

	-- 装备指引 131
	[1] = { [1] = {x = 500, y = 151, str = "", direction = 3, width = 131, height = 42,img_id=8,},	-- 第一步
			[2] = {},	-- 第二步
			},

	-- 宠物指引
	[2] = { [1] = {x = 214, y = 196, str = "", direction = 3, width = 64, height = 63,img_id=5, },
			[2] = {},	-- 第二步
			},

	-- 背包指引
	-- 背包的框框是动态位置的，所以不填x, y, 后面的指引也一样，如果是动态的，则不填，或者按程序要求填写
	-- 2:指向关闭按钮
	[3] = { [1] = {str = "", direction = 3, width = 57, height = 57,img_id=7,},
			[2] = { x =747 , y = 427 ,str ="",direction = 3,width =49, height = 48 ,img_id=5,},
			},

	-- 挂机指引 挂机按钮的在下面统一
	-- [4] = { [1] = {x = 729, y = 305, str = "", direction = 2, width = 60, height = 60, },
	-- 		[2] = {},
	-- 		},

	-- 必杀技指引 1先指向开启必杀技按钮 2然后指向必杀技按钮 3最后指向退出副本按钮
	[5] = { [1] = {x = 870, y = 67, str = "", direction = 3, width = 70, height = 70, img_id=5,},
			--[2] = {x = 652, y = 77,str = "",direction = 2,width = 67,height = 68,},
			--[3] = { x = 550,y =365,str ="" ,direction =3,width =60,height = 60 ,},
			},

	-- 坐骑指引 1指向 升级按钮 2指向关闭
	[6] = { [1] = {x = 724, y = 394, str = "", direction = 3, width = 53, height = 27,img_id=5,},
			[2] = {x =346,y =428,str ="" ,direction =3,width =49,height = 48,img_id=5,},
			},

	-- 商店指引 1指向中级药水 2指向购买框的确定按钮ni 
	[7] = { [1] = {x = 150, y = 330, str = "", direction = 3, width = 64, height = 30,img_id=9, },
			[2] = {x =160, y =140 ,str ="" ,direction =3,width =65, height =30,img_id=5,},
			},

	-- 坐骑进阶指引 1指向进阶按钮2指向铜钱提升3指向关闭
	[8] = { [1] = {x =12, y =251,str = "" ,direction = 1,width = 33,height = 83,img_id=5,},
			[2] = {x =450, y =311,str ="" ,direction = 3,width = 84,height = 29,img_id=5,},
			[3] = {x =346,y =428,str ="" ,direction = 3,width = 49,height = 48,img_id=5,},
			},

	-- 副本指引 指向npc对话框的第一个选项
	[9] = { [1] = {x = 376, y = 200, str = "", direction = 1, width = 230, height = 26,img_id=5, },
			[2] = {},
			},

	-- 兑换指引 1指向功能菜单里面的兑换按钮  2锁定兑换武器 3 指向购买按钮
	[10] = { [1] = {x = 90,y =316,str ="",direction =3,width =82,height =82,img_id=5,},
			 [2] = {x = 220,y = 319, width = 63,height =30 ,direction = 3 ,img_id=5,},
			 [3] = {x =160, y = 140 ,str = "" ,direction =3,width =65, height =30,img_id=5,},
			 },

	-- 渡劫指引 1 指向渡劫1阶 
	[11] = { [1] = {x = 61, y = 307, str = "", direction = 3, width = 109, height = 124,img_id=5, },
			 [2] = {},
			 },

	-- 渡劫指引2
	[12] = { [1] = {x = 287, y = 315, str = "", direction = 3, width = 109, height = 124,img_id=5, },
			 [2] = {},
			 },

	-- 炼器指引 1指向第一个道具 2指向强化，3指向关闭
	[13] = { [1] = {x = 365, y = 299, str = "", direction = 1, width = 58, height = 58,img_id=7, },
			 [2] = {x = 200,y =65, str ="" ,direction =1,width =131, height =41,img_id=5,},
			 [3] = {x =741,y =426, str ="" ,direction =2,width =49, height =48,img_id=5,},
			 },
	-- 世族指引
	[14] = {},

	-- 快捷任务指引
	[15] = { [1] = {x = 4, y = 230, str = "", direction = 1, width = 150, height = 60, },
			 [2] = {},
			 },

	-- vip3指引
	[16] = {},

	-- 梦境指引  1指向寻宝一次，这个按钮时动态改变的 2:指向关闭按钮
	[17] = { [1] = { str = "", direction = 4, width = 70, height = 85,img_id=5, },
			 [2] = {x = 346,y =428,str ="" ,direction = 3,width =49,height = 48 ,img_id=5,},
			 },

	-- 诛仙剑阵指引 1:指向npc对话框的第一个选项 2 指向必杀技按钮
	[18] = { [1] = {x = 23, y = 175, str = "", direction = 1, width = 208, height = 24,img_id=5, },
			 --[2] = {x = 652,y =77, str = "",direction =2,width =67,height =68 },
			 },

	-- 宠物岛指引
	[19] = { [1] = {x = 23, y = 175, str = "", direction = 1, width = 208, height = 24,img_id=5, },
			 [2] = {},
			 },

	-- 宠物融合指引 1:指向宠物开蛋界面的领养按钮2:指向宠物融合按钮3
	[20] = { [1] = {x = 42, y = 55, str = "", direction = 4, width = 81, height = 29,img_id=5, },
			 [2] = {x = 483,y =396,str ="",direction =3,width = 85,height =34 },
			 },

	-- 封魔殿剧情
	[21] = {},

	-- 斩妖除魔指引 1:指向刷星按钮2:指向接受任务按钮 
	[22] = { [1] = {x = 82, y = 116, str = "", direction = 3, width = 83, height = 30, img_id=5,},
			 [2] = { x =139,y =59, str ="" ,direction =2,width =122,height =41 ,img_id=5,},
			 },

	-- 千狐冢指引
	[23] = {},

	-- 灵根剧情动画
	[24] = {},

	-- 灵根指引 1:指向第一个灵根点 2:指向激活按钮 3:指向关闭按钮4:指向功能菜单的灵根按钮
	[25] = { [1] = {x = 117, y = 253, str ="", direction = 3, width = 40, height = 40,img_id=5, },
			 [2] = {x = 686, y = 275, str ="",direction =3,width =71,height =34,img_id=5,},
			 [3] = {x = 743, y = 427, str ="",direction =3,width =49,height =49,img_id=5,},
			 [4] = {x = 227, y = 315, str ="",direction =3,width =83,height =83 ,img_id=5,},
			 },

	-- 技能指引 1:指向一键升级 2:拖动动画结束以后指向关闭按钮
	[26] = { [1] = {x = 133, y = 69, str = "", direction = 1, width = 131, height = 39,img_id=5, },
			 [2] = {x =346,y =428,str ="" ,direction =1,width =49, height = 48,img_id=5,},
			 },
	-- 一些通用的按钮指引
	-- 挂机按钮
	[27] = { [1] = {x = 732, y = 175, str = "", direction = 2, width = 61, height = 61 ,img_id=5,},
			},
	-- 必杀技按钮
	[28] = { [1] = {x = 853, y = 11,str = "",direction = 2,width = 90,height = 90,img_id=5,} ,
			},
	-- 退出副本按钮
	[29] = { [1] = {x =742,y =364,str ="" ,direction =3,width = 48,height =51,img_id=5,} ,
			},
	-- 功能菜单按钮
	[30] = { [1] = {x =645,y =425,str ="",direction =3,width =52,height =54,img_id=5,}, 
			},
	-- 美女助手按钮
	[31] = { [1] = {x =730,y =361,str ="",direction =3,width =66,height =56,img_id=20,}, 
			},
	-- 跑环指引 1:指向跑环按钮
	[36] = { [1] = {x =60,y =316,str ="",direction =3,width =77,height =77,img_id=5,}, 
			 [2] = {x =602,y =54,str ="",direction =2,width =113,height =37,img_id=5,},
			 [3] = {x =612,y =64,str ="",direction =2,width =113,height =37,img_id=5,},
			},
	-- 活跃奖励指引 指向活动奖励分页
	[37] = { [1] = {x =296,y =397,str ="",direction =3,width =84,height =33,img_id=5,},
			 [2] = {x =744,y =426,str ="",direction =2,width =45,height =45,img_id=6,},
			},
	-- 活动按钮
	[40] = { [1] = {x =589,y =425,str ="",direction =3,width =52,height =54,img_id=20,}, 
			},	
	-- 日常按钮
	[41] = { [1] = {x =535,y =425,str ="",direction =3,width =52,height =54,img_id=20},
			},
}