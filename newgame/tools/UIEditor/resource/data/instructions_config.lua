instruct_comps = 
{
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
	-- 新的新手指引配置ID
	CLOSE_BTN				= -1,		--关闭按钮

	BUY_KEYBOARD_OK			= -2,
	
	CLOSE_XSZY				= -200, 		-- 关闭无锁屏的指引
	ANY_BTN					= -255, 	--任何按钮
	ANY_SLOT				= -256,		--任何一个Slot，包括item和技能
	ANY_SLOT_DOUBLE			= -257,		--双击slot
	-- 任务
	MINI_TASK_BASE			= 101,		--接取/完成任务
	GUIJI_BTN 				= 111,		-- 挂机按钮
	BOOK_WIN_ACTIVATE_BTN	= 112,		-- 灵根激活
	PUT_YP_QUICK			= 113,		-- TipsWin放入快捷栏按钮
	-- 主界面下方菜单
	-- 起始值为200, 201~209为 201:背包 202:伙伴 203:炼器 204:坐骑 205:翅膀 206:世族 207:商城 208:好友 209:技能
	MENU_BUTTON_BASE		= 200,

	--技能界面
	USER_SKILL_LEARN = 221,    --学习
	USER_SKILL_LEARNALL = 222, --一键学习
	USER_SKILL_SELECT = 223,

	-- 主界面右上角
	--1,地图 2,功能菜单 3，成长之路 4，活动大厅 5，福利大厅6，遗迹寻宝
	TOP_RIGHT_BUTTON_BASE_ROW_0	= 300,

	TOP_RIGHT_BUTTON_FBEXIT 	= 310,	--退出副本按钮

	TOP_RIGHT_BUTTON_LINGJIANG	= 311,	--登录和七日狂欢领奖按钮
	-- 领奖界面tab 
	AWARD_WIN_TAB_BASE			= 320,

	AWARD_WIN_LOGIN_GET			= 331,	--在线时长领奖
	AWARD_WIN_SEVEN_GET			= 332,	--七日狂欢领奖
	LOGIN_AWARD_GET				= 333,	--登录送元宝

	-- 宠物休息和出战
	PET_WIN_REST_FIGHT_BTN		= 401,
	-- 宠物选项卡tab
	PET_WIN_TAB_BASE			= 410,
	-- 宠物拖动
	PET_WIN_DRAG1				= 421,
	PET_WIN_DRAG2				= 422,
	PET_WIN_GET					= 431,	-- 宠物招募

	ANGER_BTN					= 501,	-- 必杀技

	MOUNT_WIN_RIDE_BTN			= 601,	--上下坐骑
	MOUNT_WIN_UPDATE1			= 602,	--坐骑升级
	MOUNT_WIN_UPDATE2			= 603,	--坐骑升阶
	MOUNT_WIN_XB_JINJIE_BTN		= 604, 	--铜钱提升
	MOUNT_WIN_YB_JINJIE_BTN		= 605,  --元宝提升

	-- 签到
	QIANDAO_WIN_BTN1			= 701,	--领奖按钮
	QIANDAO_WIN_BTN2			= 702,	--签到按钮
	-- 福利大厅分页标签
	BENEFIT_WIN_BASE			= 710,

	EXCHANGE_WEAPON_BTN			= 802,	--武器兑换按钮


	-- 护国榜界面的挑战索引第一个是901
	DUJIE_WIN_ITEM_BASE			= 900,

	-- 成长之路	分别对应 menus_grow 下 挑战、成长和荣耀下的按钮
	MENU_GROW_WIN_BASE			= 1000,
	-- 1、护国榜 2、演武场
	MENU_GROW_WIN_BTN1			= 1100,
	-- 1、灵根 2、兑换 3、招财 4、法宝
	MENU_GROW_WIN_BTN2			= 1200,
	-- 1、榜单 2、成就
	MENU_GROW_WIN_BTN3			= 1300,

	StrengthenRD_WIN_OK_BTN		= 2001, -- 强化确认按钮

	-- 雷达征友
	RADAR_SEARCH		= 2101,	-- 搜索附近好友按钮
	RADAR_ADD_FRIEND	= 2102, -- 一键添加好友

	-- 元宝礼包
	DIALOG_USE_OPEN 			= 2201, --打开礼包/使用

	DREAMLAND_TANBO1			= 3002, -- 梦境寻宝1次
	DREAMLAND_OPENWAREHOUSE		= 3003, --打开梦境仓库
	DREAMLAND_WAREHOUSE_TAKEALL	= 3004, --打开梦境仓库

	ACHIEVE_BTN_GET				= 4001, -- 成就领取奖励按钮

	-- 征伐榜
	ZHANYAO_REFRESH				= 5001, -- 刷星按钮
	ZHANYAO_GET_TASK			= 5002, -- 接取按钮

	TIAOZHANG 					= 6001,	--副本挑战按钮
	-- 副本窗口选项,对应每一个副本子选项
	FUBEN_CHALLENGE_BASE		= 6100,
	-- 密友抽奖入口
	FRIENDS_DRAW_BTN			= 6200,
	FRIENDS_MIYOU_AWARD1		= 6201,	-- 密友抽奖
	FRIENDS_MIYOU_AWARD2		= 6202, -- 抽奖
}

-- 第一次进入副本的指引
first_fuben_instruct = {
	--副本ID，触发指引ID
	{	fuben_id = 4,		instruct_id = 26,	}, 
	{	fuben_id = 9,		instruct_id = 26,	}, 
	{	fuben_id = 10,		instruct_id = 26,	}, 
	{	fuben_id = 63,		instruct_id = 26,	},
}

bi_sha_instruct = {
	--副本ID，触发指引次数，触发指引ID
	{	fuben_id = 11,		instruct_count = 1,		instruct_id = 27,	},
}

-- 关闭窗口
	--user_skill_win 
	-- 人物buffer
	--user_buff_win
	-- 人物属性界面
	--user_attr_win 
	-- 宠物
	--pet_win
	-- 灵根
	--linggen_win
	--精灵系统
	--genius_win 
	--获取精灵系统
	--genius_get_win 
	-- 查看他人式神
	--other_genius_win 

	--变身系统
	--transform_win 
	--transform_dev_win 
	--transform_stage_win

instructions_config = {
	-- 预设按钮id 技能



	-- 新手指引的配置
	--[[
	[指引id] = { 
				 (选填)pauseAI = 是否中断AI,如自动做任务,自动打怪(默认中断),

				 [步骤一] = {x = 出现的x坐标, y = 出现的y坐标, dir = 指向的方向(1=右（实是左），2=左（实是右），3=上，4=下), 
				width = 框的宽度, height = 框的高度, (选填)lock_screen = 是否锁屏幕(默认锁屏幕), (选填)double_click = 是否双击下一步(默认不是),
				 anchor 锚点所在 小键盘为坐标轴，将屏幕分为9个部分
				(选填)show_main_banner = 是否打开下面主功能菜单, (选填)show_top_banner = 是否打开上面的功能菜单, },
				jt_image = nopack/...png（指引底框的图片）
				label_image = "nopack/...png"（指引文字图片的路径及图片名）
				skip = { npc = 27, msg = '跳过了#c4d2308忍の书#cffffff的新手指引<19>' , delay = 3 },
				 [步骤二] = {(新的类型)new_system = 新开的系统()},
				},

			-- 功能定义
			GameSysModel.MOUNT 			= 0				-- 坐骑
			GameSysModel.GEM 			= 1 			-- 法宝(用作精灵系统吧)
			GameSysModel.GUILD 			= 2 			-- 世族 仙踪
			GameSysModel.ENHANCED		= 3 			-- 炼器
			GameSysModel.LOTTERY 		= 4 			-- 梦境
			GameSysModel.MONEY_TREE 	= 5 			-- 拜神(是招财进宝吗?)
			GameSysModel.UNIQUE_SKILL 	= 6 			-- 必杀技
			GameSysModel.PRACTICE 		= 7 			-- 打坐
			GameSysModel.ROOTS	 		= 8 			-- 灵根
			GameSysModel.DJ 			= 9  			-- 渡劫
			GameSysModel.PET 			= 13 			-- 宠物
			GameSysModel.FIGHTSYS		= 14 			-- 演武场
			GameSysModel.GENIUS			= 15 			-- 式神
			GameSysModel.TRANSFORM 		= 16 			-- 变身

			-- 前32个编号给非根据等级开放（即需要服务端记录）的系统
			GameSysModel.MOUNT_REFRESH	= 32 			-- 坐骑洗炼
			GameSysModel.FIGHT_POWER	= 33 			-- 战斗力介绍
			GameSysModel.SUMMON			= 34 			-- 召唤萱儿
			GameSysModel.WING 			= 35 			-- 翅膀系统(用作变身系统吧)
			GameSysModel.JJC 			= 36 			-- 演武场
			GameSysModel.FIRST_RECHARGE	= 37 			-- 首充礼包
			GameSysModel.GET_WING 		= 38			-- 领取翅膀
			GameSysModel.NEW_SERVER		= 39 			-- 开服活动
			GameSysModel.DDZ 			= 40 			-- 欢乐斗
			GameSysModel.JJC_AWARD		= 41 			-- 演武场排名奖励
			GameSysModel.TZFL			= 42 			-- 投资返利
			GameSysModel.MARRY			= 43 			-- 结婚系统
			GameSysModel.DongFu			= 44			-- 种植
			GameSysModel.QianDao 		= 45			-- 签到
			GameSysModel.PAO_HUAN 		= 46			-- 跑环
			GameSysModel.MYXT			= 47			-- 密友系统
			GameSysModel.ZhanBu			= 48			-- 占卜
			
	服务端任务开启任务，在任务配置中，增加（接取）：
	PromCallBack = function(sysarg,mission) 
  	LActor.openActorSystem(sysarg, 1)
	end,	
	服务端任务开启任务，在任务配置中，增加（提交）：
	CompCallBack = function(sysarg,mission) 
  	LActor.openActorSystem(sysarg, 1)
	end,

	···屏幕九宫格
	7 头像，任务     8                9 功能活动等
	4 左窗口，仓库   5 一般窗口       6 右窗口，背包等
 	1 功能菜单       2                3 技能

	···跳过指引的配置方法
	skip = { npc = 7, msg = '跳过了指引，可点击#c4d2308人物——技能#cffffff打开界面#c4d2308学习技能<16>' , delay = 5, dir = 'l' },
		npc = npc头像 id 
		msg = 信息 上面例子的<16>是表情16
		delay = 显示时长
		dir = 'l' 左边 'r' 右边，默认不填是'r'
	
	···每阶段npc对话
	在每个阶段填写附加字段
	talk = { keep = false, npc = 7, msg = '在左边说一句话<15>' , pos = 'l' }, 
		npc = npc头像 id 
		msg = 信息 上面例子的<15>是表情15
		pos = 'l' 左边 'r' 右边，默认不填是'r'
		keep = 这个npc不会移出屏幕，比如我们填写在左边的npc是keep，然后下一步填写一个npc也在左边
		       此时就会替换npc的图片的说的话，这样就不会有同一个npc又进又出的问题。
		       以后可以做一个npc有两个表情，通过替换npc表情丰富指引
	
	改变分辨率sdcard/zhanxian/UserDefault.xml
	IP4：	960 640
	IP5：	1136 640
	IPAD：	1024 768
	<WinHeight>768</WinHeight>
	<WinWidth>1024</WinWidth>
	]]--

	--[[测试用
	[0] = { 
			skip = { npc = 7, msg = '跳过了指引，可点击#c4d2308人物——技能#cffffff打开界面#c4d2308学习技能<16>' , delay = 5, dir = 'l' },
			--pos = 'l' 在左下角出现, keep == false 到了下一步消失
			[1] = { talk = { keep = false, npc = 7, msg = '在左边说一句话<15>' , pos = 'l' }, 
					x =  380, y = 10, dir = 4, width = 75, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png" },
			
			--pos = 'r' 在右下角出现, keep == true 到了下一步也不会消失
			[2] = { talk = { keep =true, npc = 8, msg = '在右边说一句话，留在屏幕上' , pos = 'r' }, 
					x = 205, y = 41, dir = 4, width = 105, height = 42, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",x },
			
			--pos = 'r' 在右下角出现, 由于之前那个右边的NPC是keep == true， 所以替换修改它的对话内容和NPC图像
			--最后他自己的keep == false,它将在下一步消失
			[3] = { talk = { keep = false, npc = 9, msg = '在右边#c4d2308再#cffffff说一句话，然后走开' , pos = 'r' }, 
					x = 600, y = 50, dir = 2, width = 127, height = 42, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			
			--pos = 'r' 在右下角出现, 因为是最后一步，所以keep无效
			[4] = { talk = { keep = true, npc = 10, msg = '在右边#c4d2308最后#cffffff说一句话！！！#r萨大声的撒撒旦·#r萨大声的撒撒旦·' , delay = -1, pos = 'r' }, 
					x = 871, y = 571, dir = 2, width = 61, height = 61, anchor = 5, jt_image = nil, label_image = "nopack/xszy/7.png", },
		},
	]]
	--指引条件，现在实现了任务作为条件
	-- id = 任务 id
	-- state = 任务状态 state = false 就是已接未完成 state = true 已完成, state = nil 不关心任务状态
	--has_quest = { { id = 179, state = true } },
	--vip = { 8, 9 }, vip等级，8-9
	--close_all_ui  

	-- component_instruction == true 定位控件的指引
	-- component_ui = 在那个界面
	--[2] = { component_id = 310, component_instruction = true , component_ui = 'menus_panel'
  			-- user_panel   -- 用户面板（包括用户的头像，宠物，任务等)
			-- menus_panel  -- 主界面下面的一堆按钮
			-- right_top_panel -- 右上角一堆按钮
			-- effect 需要播放的特效
	--32级前停留X秒自动继续任务
	auto_quest_time = 5,
	auto_quest_level = 32,


 	--测试命令 testInstruction(指引id)
 	-- 屏蔽指引配置,需要的单独开启 by hwl
	--指引宠物开启
	[1] = { 				
			close_all_ui = true,	
	-- 		skip = { npc = 7, msg = '已跳过指引，可点击#c4d2308人物——技能#cffffff打开界面#c4d2308学习技能<12>' , delay = 5 },	
			[1] = {new_system = 13, mbx = 205, mby = 38, },
			[2] = { component_id = 202, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
			[3] = { component_id = 401, x = 411, y = 220, dir = 3, width = 80, height = 79, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
			[4] = { close_windows = { 'pet_win' }, },	

			--[4] = { close_windows = { 'pet_win' }, },	
			--[4] = { component_id = -1, x = 870, y = 575, dir = 3, width = 60, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", 	
		},		
			
	--指引坐骑升级、乘骑			
	[2] = { 			
			close_all_ui = true,	
	-- 		skip = { npc = 14, msg = '已跳过指引' , delay = 5 },
			[1] = {new_system = 0, mbx = 275, mby = 5, },
			[2] = { component_id = 204, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 602, x = 836, y = 401, dir = 3, width = 70, height = 35, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },		
	--     [4] = { component_id = 601, x = 440, y = 124, dir = 4, width = 79, height = 80, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
			[4] = { close_windows = { 'mounts_win_new' }, },
			[5] = {component_id = 421,new_drag = 2, x = 118, y = 477, anchor = 5},	
		},		

	--指引坐骑升价			
	[3] = { 			
			close_all_ui = true,	
	-- 		skip = { npc = 14, msg = '已跳过指引' , delay = 5 },
			[1] = { component_id = 204, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[2] = { component_id = 603, x = 836, y = 296, dir = 3, width = 70, height = 35, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },		
			[3] = { component_id = 605, x = 420, y = 53, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/11.png",label_index=11, },
			[4] = { component_id = 605, x = 420, y = 53, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/11.png",label_index=11, },		
			[5]  = { component_id = -1, x = 881, y = 555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },	
		},		

	--指引挑战历练副本
	[4] = { 
	--		has_quest = { id = 50, state = true },
			close_all_ui = true,
	--		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
	--		[1] = { new_system = 9, mbx = 715, mby = 575, },
		[1] = { component_id = 304, x=630, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[2] = { component_id = 6101, x = 57, y = 388, dir = 3, width = 141, height = 96, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 6001, x = 733, y = 34, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/2.png",label_index=2, },
			[4] = { close_windows = { 'activity_Win' }, },	 	
		},

	--指引兑换系统
	[5] = { 
			close_all_ui = true,
	--		skip = { npc = 26, msg = '已跳过指引，请点击右上角的#c4d2308功能#cffffff打开兑换界面，#c4d2308兑换强力武器<16>' , delay = 5 },
			[1] = { component_id = 303, x = 705, y = 570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[2] = { component_id = 1202, x = 385, y = 322, dir = 4, width = 70, height = 70, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 802, x = 319, y = 379, dir = 3, width = 70, height = 35, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[4] = { component_id = -2, x = 272, y = 194, dir = 3, width = 98, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[5] = { close_windows = { 'exchange_win' }, },
	--		[6] = { component_id = 601, x = 412, y = 172, dir = 3, width = 125, height = 53, anchor = 5, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/3.png", },
	},

	--指引挑战护国榜一阶
	[6] = { 
	--		has_quest = { id = 50, state = true },
			close_all_ui = true,
	--		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
			[1] = { new_system = 9, mbx = 705, mby = 570, },
		[2] = { component_id = 303, x=705, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 1101, x = 97, y = 322, dir = 3, width = 70, height = 70, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[4] = { component_id = 901, x = 130, y = 410, dir = 3, width = 94, height = 91, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[5] = { close_windows = { 'dujie_win' }, },	
	--		[6] = { component_id = -255, x = 885, y = 340, dir = 2, width = 70, height = 70, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, }, 
		},

	--指引挑战护国榜二阶
	[7] = { 
	--		has_quest = { id = 50, state = true },
			close_all_ui = true,
	--		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
	--		[1] = { new_system = 9, mbx = 715, mby = 575, },
		[1] = { component_id = 303, x=705, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[2] = { component_id = 1101, x = 97, y = 322, dir = 3, width = 70, height = 70, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 902, x = 380, y = 410, dir = 3, width = 94, height = 91, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[4] = { close_windows = { 'dujie_win' }, },	
		},

	--指引玩家进行装备强化
	[8] = 
		{ 
			close_all_ui = true,
	--		skip = { npc = 6, msg = '点击炼器可以找到战力飙升的秘密，#c4d2308装备强化，战士无敌<45>' , delay = 5 },
			[1]  = { new_system = 3, mbx = 275, mby = 5, },
			[2]  = { component_id = 203, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3]  = { component_id = 2001, effect=11036, x = 707, y = 112, dir = 4, width = 163, height = 52, anchor = 5, jt_image = nil, label_image = "nopack/xszy/10.png",label_index=10, },
			[4]  = { component_id = 2001, effect=11036, x = 707, y = 112, dir = 4, width = 163, height = 52, anchor = 5, jt_image = nil, label_image = "nopack/xszy/10.png",label_index=10, },
			[5]  = { component_id = -1, x = 883, y = 560, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	--		close_windows = { 'forge_win' },
		},

	--指引世族开启
	[9] = { 
			close_all_ui = true,
	--		skip = { npc = 14, msg = '已跳过指引，可点击#c4d2308家族#cffffff打开界面#c4d2308查看家族列表<36>' , delay = 5 },
			[1] = {new_system = 2, mbx = 412, mby = 5, },
			[2] = { component_id = 206, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { waiting_next = true }
		},

	--指引使用VIP3体验卡
	[10] = { 
			close_all_ui = true,
	    [1] = { open_window = 'vip_card_win' }, 
		[2] = { component_id = -255, is_need_lock = false, effect=11036, x = 405, y = 135, dir = 2, width = 162, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
		},

	--指引梦境系统(针对vip4以下)
	[11] = { 
	     -- vip = { 0, 3 },
			close_all_ui = true,
	--		skip = { npc = 11, msg = '已跳过指引，可点击#c4d2308梦境#cffffff打开界面探宝，#c4d2308极品道具、极品通灵兽等你拿！~<16>' , delay = 5 },
	--		[1] = {new_system = 4, mbx = 505, mby = 575, },
			[1] = { component_id = 306, x=480, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", label_index=5, },
			[2] = { component_id = 3002, x = 288, y = 227, dir = 3, width = 82, height = 82, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[3] = { component_id = 3003, x = 83, y = 59, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[4] = { component_id = 3004, x = 790, y = 45, dir = 2, width = 121, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[5] = { close_windows = { 'dreamland_win', 'dreamland_info_win', 'dreamland_cangku_win' }, },
		},

	--指引挑战一骑当千副本
	[12] = { 
	--		has_quest = { id = 50, state = true },
			close_all_ui = true,
	--		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
	--		[1] = { new_system = 9, mbx = 715, mby = 575, },
		    [1] = { component_id = 304, x=630, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		    [2] = { component_id = 6102, x = 199, y = 388, dir = 3, width = 135, height = 90, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 6001, x = 733, y = 34, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/2.png",label_index=2, },
			[4] = { close_windows = { 'activity_Win' }, },		 	
		},

	--指引签到
	[13] = { 
			close_all_ui = true,
		    [1] = { component_id = 305, x=555, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		    [2] = { component_id = 713, x = 268, y = 531, dir = 3, width = 101, height = 45, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 702, effect = 11036, x = 739, y = 194, dir = 4, width = 162, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
			[4]  = { component_id = -1, x = 881, y = 555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, }, 	
		},

	--指引技能升级
	[14] = { 				
			close_all_ui = true,	
	-- 	skip = { npc = 7, msg = '已跳过指引，可点击#c4d2308人物——技能#cffffff打开界面#c4d2308学习技能<12>' , delay = 5 },	
			[1] = { component_id = 209, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 1, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
	--		[2] = { component_id = 223, x = 308, y = 415, dir = 2, width = 98, height = 98, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
			[2] = { component_id = 222, x = 780, y = 45, dir = 2, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
	-- 		[3] = {component_id = 421,new_drag = 3, x = 340, y = 105, anchor = 5},
	    	[3] = { waiting_next = true},
	-- 		[6] = { close_windows = { 'user_skill_win' }, },
		},

	--指引成就系统
	[15] = { 
			close_all_ui = true,
	--		skip = { npc = 26, msg = '已跳过指引，请点击右上角的#c4d2308功能#cffffff打开兑换界面，#c4d2308兑换强力武器<16>' , delay = 5 },
			[1] = { component_id = 303, x = 705, y = 570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[2] = { component_id = 1302, x = 788, y = 322, dir = 4, width = 70, height = 70, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 4001, x = 716, y = 67, dir = 2, width = 162, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[4]  = { component_id = -1, x = 883, y = 560, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	-- 		[5] = { close_windows = { 'exchange_win' }, },
	    -- [5] = { waiting_next = true}
	},

	--指引点将台
	[16] = { 
			close_all_ui = true,
	        [1] = { new_system = 36, mbx = 705, mby = 570, },
			[2] = { component_id = 303, x = 705, y = 570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 1102, x = 212, y = 322, dir = 4, width = 70, height = 70, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[4] = { waiting_next = true }
	},         

	--指引灵根系统
	[17] = { 
	--		has_quest = { id = 50, state = true },
			close_all_ui = true,
			[1] = { new_system = 8, mbx = 705, mby = 570, },
		[2] = { component_id = 303, x=705, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
		[3] = { component_id = 1201, x = 385, y = 322, dir = 3, width = 70, height = 70, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[4] = { component_id = 112, x = 722, y = 355, dir = 3, width = 99, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/9.png",label_index=9, },
		[5] = { component_id = -1, x = 881, y = 555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	--		[5] = { close_windows = { 'linggen_win' }, },	
		},

	--指引挑战校武场副本
	[18] = { 
			close_all_ui = true,
		[1] = { component_id = 304, x=630, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[2] = { component_id = 6103, x = 339, y = 388, dir = 3, width = 135, height = 90, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 6001, x = 733, y = 34, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/2.png",label_index=2, },
			[4] = { close_windows = { 'activity_Win' }, },	
		},

	--指引梦境系统（VIP4~6）
	[19] = { 
	     -- vip = { 0, 3 },
			close_all_ui = true,
	--		skip = { npc = 11, msg = '已跳过指引，可点击#c4d2308梦境#cffffff打开界面探宝，#c4d2308极品道具、极品通灵兽等你拿！~<16>' , delay = 5 },
	--		[1] = {new_system = 4, mbx = 505, mby = 575, },
			[1] = { component_id = 306, x=480, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", label_index=5, },
			[2] = { component_id = 3002, x = 237, y = 227, dir = 3, width = 82, height = 82, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[3] = { component_id = 3003, x = 83, y = 59, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[4] = { component_id = 3004, x = 790, y = 45, dir = 2, width = 121, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[5] = { close_windows = { 'dreamland_win', 'dreamland_info_win', 'dreamland_cangku_win' }, },
		},

	--引导宠物融合		 
	[20] = {
		close_all_ui = true,
		[1] = { open_window = 'bag_win' }, 
		[2] = { use_item = 28251, component_id = -257, dir = 3, width = 72, height = 72, anchor = 6, jt_image = nil, label_image = "nopack/xszy/12.png",label_index=12, },
	--	[3] = { component_id = -255, x = 162, y = 132, dir = 3, width = 99, height = 53, anchor = 1, label_image = "nopack/xszy/5.png", label_index=5, },
		[3] = { component_id = 431, x = 307, y = 125, dir = 3, width = 99, height = 53, anchor = 5, label_image = "nopack/xszy/5.png", label_index=5, },
		[4] = { open_window = 'pet_win' }, 
		[5] = { component_id = 416, x = 555, y = 525, dir = 3, width = 101, height = 48, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[6] = {component_id = 421,new_drag = 1, x = 140, y = 445, anchor = 5},
		[7] = { waiting_next = true}
		},

	--指引征伐榜
	[21] = { 
		close_all_ui = true,
		[1] = { open_window = 'zycm_win' }, 	
		[2] = { component_id = 5001, x=108, y=303, dir = 1, width = 89, height = 43, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[3] = { component_id = 5002, x = 68, y = 217, dir = 1, width = 162, height = 53, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[4] = { component_id = -255, x = 315, y = 431, dir = 1, width = 45, height = 52, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[5] = { close_windows = { 'zycm_win' }, },	
	},	

	--指引购买药品
	[22] = { 
			close_all_ui = true,
		[1] = { open_window = 'shop_win' }, 	
		[2] = { component_id = -255, x=152, y=430, dir = 1, width = 70, height = 32, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[3] = { component_id = -2, x = 272, y = 194, dir = 1, width = 98, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		[4] = { close_windows = { 'shop_win' }, },	
		 },

	--指引药品快捷栏
	[32] = { 
			close_all_ui = true,
		[1] = { open_window = 'bag_win' }, 
	    [2] = { use_item = 18300, component_id = -256, dir = 3, width = 72, height = 72, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
	    [3] = { component_id = 113, x=275, y=190, dir = 1, width = 121, height = 53, anchor = 3, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
	    [4] = { close_windows = { 'bag_win' }, },
	},

	--指引使用无限速传
	[23] = { 
		close_all_ui = true,
	[1] = { component_id = -255, is_need_lock = false, x=220, y=342, dir = 1, width = 45, height = 52, anchor = 7, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/1.png",label_index=1, },	
	},

	--指引兑换系统,开启黑市钱庄
	[24] = { 
			close_all_ui = true,
	    [1] = {new_system = 5, mbx = 715, mby = 570, },
	},

	--指引穿戴翅膀
	[25] = { 
			close_all_ui = true,
		[1] = { component_id = 2201, x=412, y=172, dir = 3, width = 121, height = 52, anchor = 5, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/3.png",label_index=3, },	
		[2] = { new_system = 35, mbx = 415, mby = 5, },
		},

	--引导挂机
	[26] = { 
			close_all_ui = true,
		[1]  = { component_id = 111, x = 885, y = 340, dir = 2, width = 70, height = 70, anchor = 3, jt_image = nil, label_image = "nopack/xszy/6.png",label_index=6, },
	},

	--指引使用必杀（首次进入郡守府副本调用）
	[27] = { 
		close_all_ui = true,
		[1] = { component_id = 501, x = 853, y = 11, dir = 4, width = 90, height = 90, anchor = 3, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
	},

	--退出副本
	[28] = { 
			close_all_ui = true,
	--		[1] = { component_id = 310, x = 623, y = 448, dir = 2, width = 60, height = 59, anchor = 9, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
		[1]  = { component_id = 310, x = 850, y = 495, dir = 2, width = 70, height = 70, anchor = 9, jt_image = nil, label_image = "nopack/xszy/7.png",label_index=7, },
	},

	--指引使用金元宝
	[29] = { 
			close_all_ui = true,
		[1] = { component_id = 2201, x=414, y=168, dir = 3, width = 121, height = 52, anchor = 5, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
		},

	--指引领取登录奖励
	[30] = { 
			close_all_ui = true,
			[1] = { component_id = 311, x = 705, y = 497, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[2] = { component_id = 322, x = 167, y = 526, dir = 3, width = 101, height = 45, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 332, x = 518, y = 69, dir = 2, width = 162, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
	-- 		[3]  = { component_id = -1, x = 883, y = 560, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	 --       [4] = { waiting_next = true}
	        [4] = { component_id = -1, x = 881, y = 555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	},

	--指引梦境系统（VIP, VIP6以上）
	[31] = { 
	     -- vip = { 0, 3 },
			close_all_ui = true,
	--		skip = { npc = 11, msg = '已跳过指引，可点击#c4d2308梦境#cffffff打开界面探宝，#c4d2308极品道具、极品通灵兽等你拿！~<16>' , delay = 5 },
	--		[1] = {new_system = 4, mbx = 505, mby = 575, },
			[1] = { component_id = 306, x=480, y=570, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", label_index=5, },
			[2] = { component_id = 3002, x = 210, y = 227, dir = 3, width = 82, height = 82, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[3] = { component_id = 3003, x = 83, y = 59, dir = 4, width = 121, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[4] = { component_id = 3004, x = 790, y = 45, dir = 2, width = 121, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
			[5] = { close_windows = { 'dreamland_win', 'dreamland_info_win', 'dreamland_cangku_win' }, },
		},

	--指引展开美人图谱界面
	[33] = { 
			close_all_ui = true,
		 	[1] = { open_window = 'bag_win' }, 
		    [2] = { use_item = 60103, component_id = -256, dir = 3, width = 72, height = 72, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
		    [3] = { component_id = -255, x = 165, y = 207, dir = 3, width = 99, height = 52, anchor = 3, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5,  },
		    [4] = { open_window = 'lingqi_win' }, 
	        [5] = { component_id = -1, x=881, y=555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/7.png",label_index=7, },
	},	

	--指引一键征友
	[34] = { 				
			close_all_ui = true,	
			[1] = { component_id = 208, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 1, width = 70, height = 70, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
			[2] = { component_id = -255, x = 793, y = 52, dir = 4, width = 121, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 2101, x = 221, y = 20, dir = 4, width = 179, height = 69, anchor = 1, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
		    [4] = { waiting_next = true}
		},	

	--指引登录送元宝
	[35] = { 
			close_all_ui = true,
			[1] = { component_id = 311, x = 705, y = 497, dir = 3, width = 70, height = 70, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[2] = { component_id = 323, x = 268, y = 526, dir = 3, width = 101, height = 45, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 333, x = 751, y = 238, dir = 1, width = 59, height = 147, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
	        [4] = { component_id = -1, x = 881, y = 555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	},

	--指引章节任务
	[36] = { 
			close_all_ui = true,
			[1] = { component_id = -200, unlock = true, is_need_lock = false, x = -45, y = 346, dir = 1, width = 250, height = 45, anchor = 7, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/2.png",label_index=2, },
	},

	--指引密友抽奖
	[37] = { 				
			close_all_ui = true,
			[1] = { open_window = 'activity_menus_panel' }, 
			[2] = { component_id = 6201, x = 90, y = 455, dir = 3, width = 86, height = 86, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[3] = { component_id = 6202, x = 105, y = 71, dir = 1, width = 85, height = 85, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },
			[4] = { component_id = -1, x = 881, y = 555, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png",label_index=7, },
	    --    [4] = { waiting_next = true },
	},

	--奇书系统开启
	[38] = { 
	--		has_quest = { id = 50, state = true },
			close_all_ui = true,
	--		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
			[1] = { new_system = 15, mbx = 705, mby = 570, },
		},
	-- [1] = { 
	-- 		--has_quest = { { id = 9, state = false } },
	-- 		close_all_ui = true,
	-- 		skip = { npc = 29, msg = '已跳过指引，可点击#c4d2308人物——技能#cffffff打开界面#c4d2308学习技能<12>' , delay = 5 },
	-- 		[1] = { component_id = 301, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 401, x = 248, y = 31, dir = 4, width = 125, height = 59, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 502, x = 178, y = 37, dir = 2, width = 125, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		--关闭按钮的id -1
	-- 		[4] = { close_windows = { 'user_attr_win', 'user_skill_win' }, },
	-- 	},

	-- --指引通灵兽开启
	-- [2] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 18, msg = '已跳过指引，可点击#c4d2308通灵兽#cffffff按钮打开界面#c4d2308设置出战宠物<36>' , delay = 5 },
	-- 		[1] = {new_system = 13, mbx = 340, mby = 8, },	--开启系统的ID，飘往目标的坐标x,y
	-- 		[2] = { component_id = 307, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 701, x = 644, y = 47, dir = 4, width = 83, height = 83, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",  },
	-- 		[4] = { close_windows = { 'pet_win' }, },
	-- 	},

	-- 	--指引一键征友
	-- [3] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 5, msg = '已跳过指引，想寻与您不离不弃的#ce519cb“她”#cffffff，就打开#c4d2308好友界面，一键征友#cffffff吧！<34>' , delay = 5 },
	-- 		[1]  = { component_id = 303, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2]  = { component_id = -255, x = 782, y = 43, dir = 2, width = 126, height = 52, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3]  = { close_windows = { 'friend_win' }, },
	-- 	},

	-- --指引变身技能体验
	-- [4] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 30, msg = '已跳过指引，可点击右边的#cfff000变身技能#ce519cb水牢术#cffffff，体验变身技能的威力！<16>' , delay = 5, pos = 'l' },
	-- 		[1] = { component_id = 105, x = 893, y = 215, dir = 2, width = 60, height = 60, anchor = 3, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --指引坐骑开启
	-- [5] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，可点击#c4d2308坐骑#cffffff打开界面#c4d2308提升坐骑属性<25>' , delay = 5 },
	-- 		[1] = {new_system = 0, mbx = 340, mby = 8,  },
	-- 		[2] = { component_id = 304, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 902, x = 608, y = 101, dir = 4, width = 125, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = -1, x = 873, y = 579, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/7.png", },
	-- 		--close_windows = {'mounts_win_new'} , 
	-- 		custom_action = { action_id = 1, label_image = "nopack/xszy/8.png", talk = nil},
	-- 	},

	-- --重复指引坐骑培养
	-- [6] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，可点击#c4d2308坐骑#cffffff打开界面#c4d2308提升坐骑属性<25>' , delay = 5 },
	-- 		[1] = { component_id = 304, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 902, x = 608, y = 101, dir = 4, width = 125, height = 52, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { close_windows = {'mounts_win_new' }, },
	-- 	},

	-- --指引战士试炼副本，即历练副本
	-- [7] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 27, msg = '已跳过指引，可点击右上角的#c4d2308每日必玩#cffffff打开界面挑战战士试炼副本，赚取#c4d2308历练值兑换强力装备<16>' , delay = 5 },
	-- 		[1] = { component_id = 1004, x = 642, y = 570, dir = 3, width = 68, height = 68, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 6000, x = 189, y = 551, dir = 3, width = 109, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 6004, x = 755, y = 44, dir = 4, width = 109, height = 49, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- 	--指引兑换系统
	-- [8] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 26, msg = '已跳过指引，请点击右上角的#c4d2308功能#cffffff打开兑换界面，#c4d2308兑换强力武器<16>' , delay = 5 },
	-- 		[1] = { component_id = 1002, x = 780, y = 573, dir = 3, width = 69, height = 66, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 'duihuan', x = 93, y = 479, dir = 3, width = 85, height = 85, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 'exchange_item_buy', x = 289, y = 486, dir = 3, width = 73, height = 45, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = -2, x = 200, y = 183, dir = 3, width = 96, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { close_windows = { 'exchange_win' }, },
	-- 		[6] = { component_id = 601, x = 412, y = 172, dir = 3, width = 125, height = 53, anchor = 5, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/3.png", },
	-- },

	-- --指引战士考试
	-- [9] = { 
	-- 		has_quest = { id = 50, state = true },
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
	-- 		[1] = { new_system = 9, mbx = 800, mby = 225, },
	-- 		[2] = { component_id = 313, uncertain_menu_pos = true, component_instruction = true, component_ui = 'menus_panel', dir = 2, width = 74, height = 74, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		--[3] = { component_id = 'dujie', x = 226, y = 479, dir = 3, width = 85, height = 85, anchor = 3, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 2001, x = 83, y = 490, dir = 3, width = 260, height = 89, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --第二次指引战士考试
	-- [10] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 13, msg = '已跳过指引，可点击#c4d2308功能#cffffff选择战士考试，挑战成功后#c4d2308永久提升人物战斗力！！<16>' , delay = 5 },
	-- 		[1] = { component_id = 313, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 2, width = 74, height = 74, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 2002, x = 352, y = 490, dir = 3, width = 260, height = 89, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --指引玩家进行装备强化
	-- [11] = 
	-- 	{ 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 6, msg = '点击炼器可以找到战力飙升的秘密，#c4d2308装备强化，战士无敌<45>' , delay = 5 },
	-- 		[1]  = { new_system = 3, mbx = 430, mby = 8, },
	-- 		[2]  = { component_id = 305, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3]  = { component_id = 5201, x = 711, y = 58, dir = 4, width = 145, height = 58, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4]  = { component_id = 5201, x = 711, y = 58, dir = 4, width = 145, height = 58, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5]  = { component_id = -1, x = 873, y = 579, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, lock_screen =false, label_image = "nopack/xszy/7.png", },
	-- 		--close_windows = { 'forge_win' },
	-- 	},

	-- --指引家族开启
	-- [12] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 14, msg = '已跳过指引，可点击#c4d2308家族#cffffff打开界面#c4d2308查看家族列表<36>' , delay = 5 },
	-- 		[1] = {new_system = 2, mbx = 515, mby = 8, },
	-- 		[2] = { component_id = 306, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- 	--指引使用VIP3体验卡
	-- [13] = { 
	-- 		skip = { npc = 11, msg = '已跳过指引，可在背包中使用#cfff000VIP3体验卡#cffffff体验#ce519cb至尊特权<16>' , delay = 5 },
	-- 		[1] = { component_id = -255, x = 401, y = 106, dir = 2, width = 144, height = 56, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- 	--点击传送
	-- [14] = { 
	-- 		skip = { npc = 11, msg = '已跳过指引，点击任务栏的#cfff000筋斗云#cffffff立即传送<16>' , delay = 5 },
	-- 		[1] = { component_id = -255, x = 147, y = 401, dir = 1, width = 60, height = 60, anchor = 7, jt_image = nil, label_image = "nopack/xszy/1.png", },
	-- 	},

	-- --指引梦境系统（VIP0、1、2、3）
	-- [15] = { 
	--         vip = { 0, 3 },
	-- 		close_all_ui = true,
	-- 		skip = { npc = 11, msg = '已跳过指引，可点击#c4d2308梦境#cffffff打开界面探宝，#c4d2308极品道具、极品通灵兽等你拿！~<16>' , delay = 5 },
	-- 		[1] = {new_system = 4, mbx = 700, mby = 8, },
	-- 		[2] = { component_id = 308, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 5301, x = 187, y = 219, dir = 3, width = 82, height = 98, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 5400, x = 264, y = 54, dir = 2, width = 146, height = 58, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { component_id = 5401, x = 668, y = 34, dir = 2, width = 126, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[6] = { close_windows = { 'dreamland_win', 'dreamland_info_win', 'dreamland_cangku_win' }, },
	-- 	},

	-- --指引梦境系统（VIP4、5）
	-- [16] = { 
	--         vip = { 4, 5 },
	-- 		close_all_ui = true,
	-- 		skip = { npc = 11, msg = '已跳过指引，可点击#c4d2308梦境#cffffff打开界面探宝，#c4d2308极品道具、极品通灵兽等你拿！~<16>' , delay = 5 },
	-- 		[1] = {new_system = 4, mbx = 700, mby = 8, },
	-- 		[2] = { component_id = 308, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 5301, x = 131, y = 219, dir = 3, width = 81, height = 98, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 5400, x = 264, y = 54, dir = 2, width = 146, height = 58, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { component_id = 5401, x = 668, y = 34, dir = 2, width = 126, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[6] = { close_windows = { 'dreamland_win', 'dreamland_info_win', 'dreamland_cangku_win' } , },
	-- 	},

	-- --指引梦境系统（VIP6、7、8、9、10）
	-- [17] = { 
	--         vip = { 6, 10 },
	-- 		close_all_ui = true,
	-- 		skip = { npc = 11, msg = '已跳过指引，可点击#c4d2308梦境#cffffff打开界面探宝，#c4d2308极品道具、极品通灵兽等你拿！~<16>' , delay = 5 },
	-- 		[1] = { new_system = 4, mbx = 700, mby = 8, },
	-- 		[2] = { component_id = 308, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 5301,x = 105, y = 219, dir = 3, width = 79, height = 96, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 5400,x = 265, y = 55, dir = 2, width = 143, height = 57, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { component_id = 5401,x = 668, y = 34, dir = 2, width = 126, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[6] = { close_windows = { 'dreamland_win', 'dreamland_info_win', 'dreamland_cangku_win' } , },
	-- 	},

	-- --指引元素意志副本，即诛仙阵
	-- [18] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308每日必玩#cffffff打开界面挑战火之意志副本，#c4d2308炫炸天的全屏必杀等您体验<16>' , delay = 5 },
	-- 		[1] = { component_id = 1004, x = 642, y = 570, dir = 3, width = 68, height = 68, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 6000, x = 189, y = 551, dir = 3, width = 109, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 6002, x = 63, y = 325, dir = 1, width = 156, height = 82, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 6004, x = 755, y = 44, dir = 4, width = 109, height = 49, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --指引宠物悟性提升
	-- [19] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 30, msg = '已跳过指引，可点击#c4d2308通灵兽#cffffff打开界面，提升宠物悟性，#c4d2308增强宠物战斗力！！<16>' , delay = 5 },
	-- 		[1] = { component_id = 307, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = -255, x = 187, y = 560, dir = 3, width = 109, height = 52, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = -255, x = 728, y = 42, dir = 2, width = 146, height = 58, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = -255, x = 728, y = 42, dir = 2, width = 146, height = 58, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { component_id = -1, x = 873, y = 579, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/7.png", },
	-- 		--close_windows = { 'pet_win' },
	-- 	},

	-- --指引妙木秘境副本，即宠物岛
	-- [20] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 11, msg = '已跳过指引，可点击右上角的#c4d2308每日必玩#cffffff打开界面挑战妙木秘境副本，#c4d2308赢取强力宠物<16>' , delay = 5 },
	-- 		[1] = { component_id = 1004, x = 642, y = 570, dir = 3, width = 68, height = 68, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 6000, x = 189, y = 551, dir = 3, width = 109, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 6003, x = 63, y = 217, dir = 1, width = 156, height = 82, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 6004, x = 755, y = 44, dir = 4, width = 109, height = 49, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --指引战士任务榜的刷星、领取
	-- [21] = { 
	-- 		skip = { npc = 6, msg = '已跳过指引，可使用背包的#c4d2308战士任务榜#cffffff打开界面领取任务，#c4d2308每天海量经验轻松拿！<16>' , delay = 5 },
	-- 		[1] = { component_id = -255, x = 75, y = 125, dir = 1, width = 126, height = 53, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = -255, x = 120, y = 43, dir = 1, width = 225, height = 60, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = -255, x = 325, y = 274, dir = 1, width = 96, height = 53, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },	
	-- 		[4] = { close_windows = { 'zycm_win' }, },
	-- 	},

	-- --主线任务104任务状态变为完成时触发，第一次完成战士任务不再弹出战士任务界面
	-- [22] = { 
	-- 		skip = { npc = 7, msg = '已跳过指引，请点击任务栏继续任务' , delay = 5 },
	-- 		[1] = { close_windows = { 'zycm_win' }, },
	-- 	},

	-- --指引忍の书开启
	-- [23] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 5, msg = '已跳过指引，可点击#c4d2308人物——忍の书#cffffff打开界面#c4d2308激活忍の书<16>' , delay = 5 },
	-- 		[1] = { component_id = 301, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 405, x = 98, y = 31, dir = 4, width = 126, height = 59, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",  },
	-- 		[3] = { component_id = 801, x = 541, y = 82, dir = 1, width = 125, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 801, x = 541, y = 82, dir = 1, width = 125, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { component_id = -1, x = 889, y = 589, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/7.png",  },
	-- 		[6] = { close_windows = { 'user_attr_win' }, }
	-- 		--close_windows = { 'linggen_win','user_attr_win' },
	-- 	},

	-- --指引玩家领取免费翅膀
	-- [24] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，可点击#c4d2308领取翅膀#cffffff打开界面领取翅膀，#c4d2308大幅度提升战斗力！！<37>' , delay = 5 },
	-- 		[1] = { component_id = 1110, x = 822, y = 502, dir = 3, width = 69, height = 69, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = 3001, x = 288, y = 45, dir = 2, width = 146, height = 58, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --指引培养式神
	-- [25] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 4, msg = '已跳过指引，可点击#c4d2308式神#cffffff打开界面，提升#c4d2308式神等级#cffffff，大幅度提升#c4d2308战斗力！<16>' , delay = 5 },
	-- 		[1] = { new_system = 15, mbx = 792, mby = 8, },
	-- 		[2] = { component_id = 309, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 4, width = 90, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 8000, x = 661, y = 56, dir = 4, width = 146, height = 57, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[4] = { component_id = 8000, x = 661, y = 56, dir = 4, width = 146, height = 57, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[5] = { component_id = -1, x = 391, y = 569, dir = 1, width = 60, height = 60, anchor = 4, jt_image = nil, label_image = "nopack/xszy/7.png", },	
	-- 		--close_windows = {'genius_win' },
	-- 	},

	-- --指引使用挂机（首次进入副本调用）
	-- [26] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，请点击右下角的#c4d2308攻击#cffffff开始#c4d2308自动打怪<36>' , delay = 5 },
	-- 		[1] = { component_id = 150, x = 847, y = 13, dir = 4, width = 104, height = 105, anchor = 3, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/6.png", },
	-- 	},

	--指引使用必杀（首次进入火之意志副本调用）
	--[27] = { 
	--		close_all_ui = true,
	--		[1] = { component_id = 501, x = 853, y = 11, dir = 4, width = 90, height = 90, anchor = 3, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/5.png", },
	--	},

	-- --指引商店买卖
	-- [28] = { 
	-- 		has_quest = { id = 29, state = true },
	-- 		skip = { npc = 4, msg = '已跳过指引，您可在#ce519cb主城的婧音#cffffff处购买#c4d2308中级寿司等常用药品#cffffff！<18>' , delay = 5 },
	-- 		[1]  = { component_id = -255, x = 173, y = 461, dir = 1, width = 72, height = 43, anchor = 4, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2]  = { component_id = -2, x = 200, y = 183, dir = 3, width = 96, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3]  = { close_windows = { 'shop_win' } }
	-- 	},

	-- 	--指引战士考试(只用于未完成任务重复指引)
	-- [29] = { 
	-- 		has_quest = { id = 50, state = true },
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，可点击右上角的#c4d2308功能#cffffff图标，选择战士考试，通关后#c4d2308永久提升人物属性<16>' , delay = 5 },
	-- 		[2] = { component_id = 313, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', dir = 2, width = 74, height = 74, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		--[3] = { component_id = 'dujie', x = 226, y = 479, dir = 3, width = 85, height = 85, anchor = 3, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[3] = { component_id = 2001, x = 83, y = 490, dir = 3, width = 260, height = 89, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},
	-- --指引变身开启
	-- [30] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 4, msg = '已跳过指引，可点击#c4d2308变身#cffffff打开界面#c4d2308激活变身<16>' , delay = 5 },
	-- 		[1] = { new_system = 16 },
	-- 		[2] = { component_id = 310, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', width = 90, height = 90, dir = 4, next_id = 31 , show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},

	-- --上接指引变身开启
	-- [31] = { 
	-- 		skip = { npc = 4, msg = '已跳过指引，可点击#c4d2308变身#cffffff打开界面#c4d2308激活变身<16>' , delay = 5 },
	-- 		[1] = { component_id = -255, x = 670, y = 50, dir = 2, width = 126, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2] = { component_id = -255,x = 641, y = 50, dir = 2, width = 126, height = 53, anchor = 6, jt_image = nil, label_image = "nopack/xszy/4.png", },
	-- 		[3] = { close_windows = {'transform_win','transform_dev_win','transform_stage_win','transform_left','transform_right'} , },
	-- 	},

	-- --指引玩家查看超强变身
	-- [32] = { 
	-- 		close_all_ui = true,
	-- 		skip = { npc = 25, msg = '已跳过指引，请注意超强变身的倒计时，#c4d2308计时结束后，可免费领取变身，独特技能，非你莫属！<25>' , delay = 5 },
	-- 		[1]  = { component_id = 1112, x = 753, y = 503, dir = 3, width = 68, height = 68, anchor = 9, show_top_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 		[2]  = { component_id = -1, x = 591, y = 524, dir = 3, width = 58, height = 56, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
	-- 	},
--[[


	--指引变身副本出口（程序调用）
	[19] = { 
			close_all_ui = true,
			[1] = { component_id = 1200, x = 890, y = 500, dir = 2, width = 75, height = 75, anchor = 9, show_top_banner = false, jt_image = nil, label_image = "nopack/xszy/5.png", },
		},

		--指引穿戴装备（去掉）
	[22] = { 
			skip = { npc = 14, msg = '你获得了新的装备，#c4d2308快查看你的背包吧#cffffff，双击可以穿戴装备哦~<16>' , delay = 5 },
			[1] = { component_id = 601, x = 412, y = 172, dir = 3, width = 125, height = 53, anchor = 5, show_main_banner = false, jt_image = nil, label_image = "nopack/xszy/3.png", },
		},
		


	--指引宝石镶嵌 宝石附灵- TODO
	[28] = 
		{ 
			close_all_ui = true,
			skip = { npc = 11, msg = '点击炼器可以找到战力飙升的秘密，#c4d2308装备附灵，战力激增<45>' , delay = 5 },
			[1] = { component_id = 305, x = 395, y = 8, dir = 4, width = 70, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[2] = { component_id = 5502, x = 173, y = 551, dir = 3, width = 95, height = 50, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[3] = { component_id = -255, x = 556, y = 105, dir = 2, width = 95, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[4] = { component_id = -255, x = 327, y = 172, dir = 4, width = 126, height = 52, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },		
			[5] = { component_id = -256, x = 369, y = 271, dir = 2, width = 61, height = 68, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[6] = { component_id = -256, x = 752, y = 438, dir = 4, width = 61, height = 71, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[7] = { component_id = -255, x = 711, y = 33, dir = 4, width = 145, height = 58, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[8] = { component_id = -1, x = 873, y = 579, dir = 2, width = 60, height = 60, anchor = 5,lock_screen = false, jt_image = nil, label_image = "nopack/xszy/7.png", },		
			--{ close_windows = { 'forge_win' } ,
		},

	--指引升级装备
	[29] = 
		{ 
			close_all_ui = true,
			skip = { npc = 12, msg = '点击炼器可以找到战力飙升的秘密，#c4d2308装备升级，属性提升<45>' , delay = 5 },
			[1] = { component_id = 305, x = 395, y = 8, dir = 4, width = 70, height = 84, anchor = 1, show_main_banner = true, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[2] = { component_id = 5504, x = 373, y = 551, dir = 3, width = 95, height = 50, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[3] = { component_id = -255, x = 556, y = 152, dir = 2, width = 95, height = 53, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },	
			[4] = { component_id = -1, x = 635, y = 433, dir = 2, width = 60, height = 60, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },	
			[5] = { close_windows = { 'forge_win' } , },				
		},

	--领取翅膀触发指引
	[38] = { 
			close_all_ui = true,
			skip = { npc = 25, msg = '已跳过指引，可点击#c4d2308式神#cffffff打开界面#c4d2308查看<16>' , delay = 5 },
			[1] = { new_system = 15, },
			[2] = { component_id = 309, uncertain_menu_pos = true, component_instruction = true , component_ui = 'menus_panel', width = 90, height = 90, dir = 4, next_id = 39 , jt_image = nil, label_image = "nopack/xszy/5.png", },
		},

	--上接指引玩家领取免费翅膀的进阶培养
	[39] = { 
			skip = { npc = 25, msg = '已跳过指引，可点击#c4d2308领取式神#cffffff打开界面领取式神，#c4d2308大幅度提升战斗力！！<37>' , delay = 5 },
			[1] = { component_id = 3101, x = 628, y = 63, dir = 1, width = 125, height = 53,  anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png", },
			[2] = { close_windows = {'genius_win' } , },
		},

	--进入场景展开右上角
	[40] = { 
			[1] = { show_top_banner = true, },
		},
		]]

}

--填写任务跟踪，接收了那个任务后需要追踪
mini_task_instruction = {
	acceptQuest = {
	--[[
		[2] = { dir = 3, label_image = "nopack/xszy/2.png", },
		[3] = { dir = 3, label_image = "nopack/xszy/2.png", },
		[4] = { dir = 3, label_image = "nopack/xszy/2.png", },
		[100] = { dir = 3, label_image = "nopack/xszy/1.png", },
		[101] = { dir = 3, label_image = "nopack/xszy/1.png", },
		[102] = { dir = 3, label_image = "nopack/xszy/1.png", },
		[103] = { dir = 3, label_image = "nopack/xszy/1.png", },
		[104] = { dir = 3, label_image = "nopack/xszy/1.png", },
		[105] = { dir = 3, label_image = "nopack/xszy/1.png", },
		[106] = { dir = 3, label_image = "nopack/xszy/1.png", },
		]]
	},
}