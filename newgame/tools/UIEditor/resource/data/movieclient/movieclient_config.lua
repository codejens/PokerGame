

-- 说明：
-- handle_id: 每个演员的唯一表示，如果相同则表示同一个(handle_id=0表示主角的替身)
-- body: 角色-1000,
--       怪物-1

MOVIECLIENT_ACTOR_ZORDER = 100

-- movieclient_config 剧情副本前缀
juqing_misc = {
	formal_pre = {
		[1] 	= "juqing-ux",      -- 主线配置前缀
		[2] 	= "juqing-ix",      -- 支线配置前缀
		[3] 	= "juqing",			-- 副本配置前缀
		[4] 	= "juqing-ac",		-- 活动配置前缀
	},

	-- F2命令窗口与聊天输入框测试命令前缀
	test_pre = {
		[1] 	= "@ux",          -- 实例: 输入@ux001 既是剧情"juqing-ux001"
		[2] 	= "@ix",		  -- 实例: 输入@ix001 既是剧情"juqing-ix001"
		[3] 	= "@fb",          -- 实例: 输入@fb001 既是剧情"juqing001"
		[4] 	= "@ac",          -- 实例: 输入@ac001 既是剧情"juqing-ac001"
	},

	-- 冲突命令，如果输入的是以下前缀，就播发不出剧情
	test_against = {
		[1]		= "@acceptrole"
	},

		-- 乱七八糟的配置
	talk_width = 300, -- 头顶聊天框最大宽度

	-- 动作配置
	actions = {
		[1] = {  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14},
		[2] = { 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46},
		[3] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30}, 
		[4] = { 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62},
	},

	-- 剧情开始淡入淡出帧数, 变暗或变亮是(0-255),0.017(大约一帧时间)变一次,从而可算出几秒变暗或变亮
	black_zhen_num = 30,  -- 变暗
	light_zhen_num = 30,  -- 变亮
	black_keeptime = 0.5, -- 黑幕持续时间
}

--支持剧情测试时传送到目标点播放剧情
--仅支持开发过程方便传送配置
juqing_scene = {
	start_delay = 0.8,

	special_delay = {
		['juqing111'] = 0.3,
	},
	
	-- --==========副本剧情场景===============--
	-- -- ['juqing111'] = {sceneid=101,x= 96,y =96},
	-- -- ['juqing112'] = {sceneid=101,x= 96,y =96},
	-- ['juqing121'] = {sceneid=1,x= 96,y =96},
	-- ['juqing122'] = {sceneid=1,x= 96,y =96},
	-- -- ['juqing131'] = {sceneid=4,x= 125,y =63},
	-- -- ['juqing132'] = {sceneid=4,x= 125,y =63},

	-- --==========主线剧情场景===============--
	-- ['juqing-ux999'] = {sceneid=4,x= 98,y =91},


	-- --==========支线剧情场景===============--
	-- ['juqing-ix999'] = {sceneid=4,x= 98,y =91},	
}

-- 播放任意文件夹下面的音乐 对应的文件夹对应的文件ssound_effect 里面的ID
--参数类型 id, loop, job,path_name
--path_name 有 ui scene skill moviebg partner
--{ event='playAudio', delay=0.1, id = 500 ,loop = false,job = nil,path_name = "scene"},


movieclient_config = 
{
	--剧情配置示例
    ["juqing-ux999"] = 
	{
        --角色前置对白
	    -- {
	   	-- 	{ event='init_cimera', delay = 0.1,mx= 83,my = 100 }, 	 
	    -- },
        -- {  --测试创建坐骑
	       --  { event='createActor', delay=1, handle_id="111", is_mount=true, pos={2356,3424}, speed=340, dir = 6,mount_id = 1},
	       --  { event='move', delay=1.5, handle_id="111", pos={2456, 3424}, speed=340, dur=1, end_dir=5 },
        -- },
        -- 创建演员
        {
        	{event = 'changeRGBA',delay=0.1,dur=1,txt = "dsdf",
        	cont_time=2, light_time=0.2, txt_time=0.1, black_time=0.3},
        	-- { event='playBgMusic', delay=0.1, id = 1 ,loop = true},
        	{ event='playAudio', delay=0.1, id = 500 ,loop = false,job = nil,path_name = "scene"},
        	{ event='screenImage', handle_id=10, delay = 0.2, img="nopack/BigImage/map_world.png", adapt="height"},	--height，和width

			{ event="createSpEntity", handle_id=1, name="cast42",name_color="#c444444",actor_name="过主啦啦啦啦啦", action_id=6, dir=2, pos={416,672}},
 			{ event='playAction', delay=0.2, handle_id=1, action_id=6, dur=1.5, dir=2, loop=true },
        	-- { event='createActor', delay=1, handle_id=2, is_lead=0, pos={2356,3424}, speed=340, dir = 6},
        	-- 抛物线轨迹鱼洞，如果动作之后没有特殊需求，带有end字样的不需要配置
			-- { event='moveParabola', delay=2, handle_id=2, pos={5180, 1492}, high=10, time=0.2,
	  --  										end_act_id=2, end_dir=3, end_loop=true },
        	-- { event='createActor', delay=1, handle_id=2, body=1, pos={2056,3424}, dir=3, speed=340, 
	      									-- name_color=0xffffff, name="苏青", level=1}, 
	    --   	-- { event='createActor', delay=1, handle_id=1, is_lead=1, body=1, pos={2056,3424}, dir=3, speed=340, 
	    --   	-- 								name_color=0xffffff, name="苏青", level=1, weapon=11101, wing=1}
     --    	-- 创建实体:delay-延迟时间, handle_id, 角色唯一标识, is_lead(1-4代表4个角色), body-人物实体，pos-位置, dir任务朝向，speed-移动速度，name_xxx-名字
	    --   	-- { event='createActor', delay=0.1, handle_id=2, is_lead=1, body=1000, pos={2056,3424}, dir=3, speed=340, 
	    --   	-- 								name_color=0xffffff, name="苏荷", level=1, weapon=11101, wing=1}, 
	    --   	-- { event="createActor", delay=0.1, handle_id=1, pos={2056,3424}},
	      	
	    --   	-- { event='spawn', delay=0.5, cast='cast20', dir = 6, pos = { 2456,3424 } },
	    --   	-- {event = 'changeRGBA',delay=0.1,dur=1,txt = "#cd71345你是我的小苹果,怎么爱都爱不够！"},
	      	-- { event = 'move', delay = 0.1, cast = 'player', end_dir = 1, pos = {67, 107},speed = 340, dur = 1 },
	    --   	-- { event="createSpEntity", handle_id=1, name="cast2222", action_id=99, dir=2, pos={2056,3424}},
	    -- { event='createTexture', handle_id=15, delay= 4, pos={ 1198, 648}, path = "nopack/ttsl/4.png"},  --创建贴图
	    -- { event='deleteTexture', handle_id=9, delay=3.1 },  --删除贴图
	    },
	    {
	   		{ event='move', delay=1.5, handle_id=2, pos={2456, 3424}, speed=340, dur=1, end_dir=5 },
	        -- { event='jump', delay=0.2, handle_id=2, dir=6, pos={2456,3424}, speed=120, dur=1, end_dir=3 }, -- 通过
	        -- { event = 'effect', handle_id=1 delay = 2.0, pos = {76, 107}, layer = 2, effect_id = 20004, dx = 0,dy = 30,is_forever = true},
	        { event='effect', handle_id=2, delay=2.0, pos={2256, 3424}, effect_id=20004, is_forever = false},
	        { event='effect', handle_id=5, target_id=2, delay=2.0, pos={10, 10}, effect_id=20004, is_forever = true},
	    },
	    {
	      { event='backSceneMusic', delay = 0}, 
	    },

	    -- 苏荷移动，边跑边冒泡
	    {
	    	-- { event='kill', delay=4, cast='cast20', style='destory'}, -- 消除实体通过
	    	-- { event='kill', delay=5, handle_id=1},  -- 消除实体通过
	    	-- { event='hideCast', delay=5, handle_id=1}, 	--隐藏实体
	    	-- { event='showCast', delay=5, handle_id=1}, 	--显示实体
        	-- { event='move', delay=1.1, handle_id=0, end_dir=5, pos={71, 105}, speed=340, dur=2 }, -- 移动通过
        	-- { event='move', delay=1, handle_id=1, end_dir=5, pos={2056,3424}, speed=340, dur=2 }, -- 移动通过
	      	-- { event='talk', delay=0.1, handle_id=0, talk='给我揍他！', dur=1.5 },  -- 聊天气泡通过
	      	-- handle_id-攻击者id,target_id-被攻击者, skill_id-技能id,0是普攻，其他参考主角技能id,如果特殊攻击特效需要另外配
	    	-- { event='attack', delay=2.1, handle_id=1, target_id=2, skill_id = 11}, -- 施法技能，攻击无攻击动作 =======================
	    	-- { event = 'changePos', delay = 3, handle_id=1, pos={2156, 992}, end_dir=5}, -- 位置的跪着不一样，需要转换下 ==============
	   		-- { event='dialog', delay=0.5, dialog_id=102 },  -- 下部弹出窗口通过
	   		-- { event = 'removeEffect', delay = 0.1, handle_id=1, effect_id=8}, -- 通过
	   		-- { event='moveEffect', handle_id=10, delay=1.5, effect_id=10128, pos1={67, 107}, pos2={70,103}, pos3={72,106}, dur=0.5, m_dur=0.2}, -- 通过
	   		-- { event = 'camera', delay = 0.2, dur=3.5,sdur = 0.9,style = '',backtime=1, c_topox = { 2756,3724 } }, -- 移动镜头通过
	   		-- { event ='camera', delay = 0.5, target_id = 4, sdur=3.5, dur = 1,style = 'follow',backtime=1}, --移动镜头跟随
	   		-- { event='zoom', delay=0.2, sValue=1.0, eValue=1.5, dur=1.0 }, -- 通过
	     --    { event='playAction', delay=0.2, handle_id=1981, action_id=4, dur=1.5, dir=2, loop=false },
	        -- { event='shake', delay=0.1, dur=1, c_topox={2456,3424}, index=60, rate=4, radius=40 }, --通过
	        -- { event='FlowText', delay=0.5, handle_id=1, yOffset=150, colortype=2, numbermessage=2537, isHeal=false}, -- 不可用
	        -- { event="gather", delay=4.5, handle_id=4, gather_time=2, breakTime=1, txt="显示进度条"}, -- breakTime字段是打断用的(一遍不用)
	        -- {event='stopMonster',delay =0.1,ttype = 1}, -- 未实现
	        -- {event='transform', delay=2.5, handle_id=1, dir=3,  body=49,--pos={2056,3424}
	        -- 			speed=340}, 
        	-- {event='transform', delay=4.5, handle_id=1, dir=3,  body=48,--pos={2056,3424}
        	-- 			speed=340}, 
        	-- {event='transform', is_lead=1, delay=6.5, handle_id=1, dir=3,  body=1000,--pos={2056,3424}
        	-- 			speed=340}, 
	        -- {event='tranToMonster', delay=0.5, handle_id=1, is_lead=1, body=1000, 
	        -- 			pos={2056,3424}, dir=3, speed=340, weapon=11101, wing=1},
	        -- {event='changeRGBA', delay=1, data.hideTime=2, txt="苏茉和芙儿一块跪坐在火炉旁边，两人用刀子划开自己的手，号。"},  --hideTime是结束时间

        },
	},	

----=====================================================================长歌行剧情副本剧情动画配置 START =====================================================-------  


--——————————————————————————————————————————————————第一章第一节1-1-1 开始————————————————————————————————————————————————————
	--演员表
	--过珊彤-6 ；劫匪1-2；劫匪2-3；劫匪3-4；刘秀-5 ；过主-1；吴汉-7；劫匪4-8；
	['juqing111'] = 
	{
		{
	   		{ event='init_cimera', delay = 0.1,mx= 1100,my = 1901 }, 	 
	    },
		--创建人物
	    { 
	   		-- { event='createActor', delay=0.1, handle_id=1, body=2, pos={1173,1879}, dir=1, speed=340, name_color=0xffffff, name="过主"}, 
	   		-- { event='createActor', delay=0.1, handle_id=6, body=2, pos={1173,1976}, dir=1, speed=340, name_color=0xffffff, name="过珊彤"}, 
	   		{ event='createActor', delay=0.1, handle_id=1, body=11, pos={980,1879}, dir=1, speed=340, name_color=0xffffff, name="过主"}, 
	   		{ event='createActor', delay=0.1, handle_id=6, body=17, pos={980,1976}, dir=1, speed=340, name_color=0xffffff, name="过珊彤"},	   		
	   		{ event='createActor', delay=0.1, handle_id=2, body=31, pos={657-250,1841}, dir=2, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=3, body=32, pos={753-250,1907}, dir=2, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=4, body=32, pos={660-250,2002}, dir=2, speed=340, name_color=0xffffff, name="劫匪"},  
	    },
	    --追过珊彤
	    {
	    	--过珊彤和他妈跑
	    	{ event='talk', delay=1.2, handle_id=1, talk='!!!', dur=1 },
	    	{ event='talk', delay=1.2, handle_id=6, talk='害怕o((⊙﹏⊙))o.', dur=1 },
	    	{ event='move', delay=0.1, handle_id=1, end_dir=6, pos={1173,1879}, speed=300, dur=1 },
	    	{ event='move', delay=0.1, handle_id=6, end_dir=6, pos={1173,1976}, speed=300, dur=1 },

	    	{ event='move', delay=1.8, handle_id=1, end_dir=6, pos={1939,1879}, speed=300, dur=1 },
	    	{ event='move', delay=1.8, handle_id=6, end_dir=6, pos={1939,1976}, speed=300, dur=1 },

	    	--土匪跑
	    	{ event='move', delay=1, handle_id=2, end_dir=1, pos={1873, 1808}, speed=220, dur=4 },
	    	{ event='move', delay=1, handle_id=3, end_dir=1, pos={1934, 1870}, speed=220, dur=4 },
	    	{ event='move', delay=1, handle_id=4, end_dir=1, pos={1966, 1937}, speed=220, dur=4 },
	    	{ event='talk', delay=1.5, handle_id=2, talk='哪里跑！', dur=3 },
	    	{ event='talk', delay=1.5, handle_id=4, talk='站住！', dur=3},
	    },
	    --创建刘秀
	    {
	    	{ event='createActor', delay=1, handle_id=5, body=13, pos={977,2223}, dir=6, speed=340, name_color=0xffffff, name="刘秀"}, 
	    },
	    --刘秀出现
	    {
	    	{ event='kill', delay=0.1, handle_id=1},
	    	{ event='kill', delay=0.1, handle_id=2},
	    	{ event='kill', delay=0.1, handle_id=3},
	    	{ event='kill', delay=0.1, handle_id=4},
	    	{ event='kill', delay=0.1, handle_id=6},

	    	{ event='move', delay=0.1, handle_id=5, end_dir=1, pos={1100, 2000}, speed=300, dur=1 },
	    	{ event='showTopTalk', delay=2, dialog_id="1_1_1" ,dialog_time = 1.2},

	    },
	    --刘秀吃惊
	    {
	    	{ event='move', delay=0.5, handle_id=5, end_dir=1, pos={1150, 1950}, speed=150, dur=1 },
	    	{ event='talk', delay=01, handle_id=5, talk='!!!', dur=1.5 },
	    },
	},

	['juqing112'] = 
	{
		{
	   		{ event='init_cimera', delay = 0.1,mx= 1487,my = 1150 },
	   		-- { event='createParticle', id =1 ,delay = 0.1,pos={1487,1150},scale = 1,path= "particle/xueqiu.plist" },	
	   		-- { event='removeParticle', id =1 },	
	    },
		--创建人物
	    {
	   		{ event='createActor', delay=0.1, handle_id=6, body=17, pos={1330,1135}, dir=3, speed=340, name_color=0xffffff, name="过珊彤"},
	   		{ event='createActor', delay=0.1, handle_id=1, body=11, pos={1615,1329}, dir=7, speed=340, name_color=0xffffff, name="过主"}, 
	   		{ event='createActor', delay=0.1, handle_id=2, body=31, pos={1327,1233}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=3, body=32, pos={1424,1168}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=7, body=8, pos={1456,1265}, dir=3, speed=340, name_color=0xffffff, name="吴汉"}, 
	    },
	    --冒泡BB
	    {
	    	-- { event='move', delay=2, handle_id=7, end_dir=3, pos={1517, 1235}, speed=750, dur=1 },
	    	-- { event='move', delay=3.5, handle_id=7, end_dir=3, pos={1456,1265}, speed=750, dur=1 },
	    	{ event='talk', delay=1, handle_id=7, talk='快给你夫家写封信，让他们拿钱来赎你们，否则……', dur=2 },

	    	{ event='talk', delay=3.3, handle_id=6, talk='母亲！我怕……[a]', dur=2,emote = {a = 33}},
	    	{ event ='move', delay=3.3, handle_id=6, end_dir=3, pos={1360,1165}, speed=200, dur=1 },

	    	{ event ='move', delay=4.3, handle_id=1, end_dir=7, pos={1580,1311}, speed=200, dur=1 },
	    	{ event='talk', delay=4.3, handle_id=1, talk='珊彤……别怕，有母亲在。', dur=2 },

	    	{ event ='move', delay=3.5, handle_id=2, end_dir=3, pos={1360,1199}, speed=200, dur=1 },
	    	{ event ='move', delay=3.5, handle_id=3, end_dir=3, pos={1397,1196}, speed=200, dur=1 },
	    

	    },
	    {
	    	--{ event='move', delay=0.1, handle_id=7, end_dir=5, pos={2955, 1461}, speed=300, dur=0.5 },
	    	{ event='playAction', delay=0.1, handle_id=7, action_id=2, dur=1, dir=3, loop=false },
	    	{ event='talk', delay=1, handle_id=7, talk='快写！我这刀枪可不会像我这么好商量！', dur=2 }, 
	    },
	    --报！！！
	    {
	    	{ event='showTopTalk', delay=1, dialog_id="1_1_2" ,dialog_time = 1.2},
	    	{ event='createActor', delay=0.1, handle_id=5, body=13, pos={1747,1713}, dir=2, speed=340, name_color=0xffffff, name="刘秀"}, 
	    },
	    --刘秀报过来冒泡，土匪害怕
	    {
	    	{ event ='camera', delay = 0.1, target_id=5, dur=0.5, sdur = 2,style = 'follow',backtime=1},
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=7, pos={1681,1425}, speed=300, dur=2 },
	    	{ event ='move', delay=0.5, handle_id=1, end_dir=3, pos={1615,1329}, speed=340, dur=2 },
	    	{ event ='talk', delay=2.5, handle_id=5, talk='禀夫人，在下乃大司徒王寻辖下参军。', dur=2 },
	    	{ event ='talk', delay=4.6, handle_id=5, talk='大司徒得知夫人要前来，特派卑职前来相迎。', dur=2 },
	    },
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = {1487,1150}},
	    	-- { event='talk', delay=0.5, handle_id=2, talk='[a]', dur=2,emote = {a = 41}},,
	    	{ event='talk', delay=0.5, handle_id=3, talk='头儿，咱们可是逃兵，不能见官……', dur=2 },
	    	{ event ='move', delay=3, handle_id=7, end_dir=7, pos={1456,1265}, speed=200, dur=1 },--吴汉转身
	    	{ event ='move', delay=3.5, handle_id=2, end_dir=3, pos={1327,1233}, speed=200, dur=1 },
	    	{ event ='move', delay=3.5, handle_id=3, end_dir=3, pos={1424,1168}, speed=200, dur=1 },

	    	{ event ='move', delay=4, handle_id=7, end_dir=7, pos={1360+50,1165+50}, speed=340, dur=1 },--吴汉走过
	    	{ event='talk', delay=4, handle_id=7, talk='哼！[a]', dur=1.5, emote = {a = 32}},
	    	{ event='playAction', delay=5, handle_id=7, action_id=2, dur=1, dir=7, loop=false },
	    	{ event='playAction', delay=5.3, handle_id=6, action_id=3, dur=0.5, dir=3, loop=false },
	    	{ event='playAction', delay=5.8, handle_id=6, action_id=4, dur=1, dir=7, loop=false,once =true},
	    	{ event='talk', delay=5.5, handle_id=6, talk='啊啊……', dur=1.5},
	    },
	    --土匪走了
	    {
	    	--{ event = 'camera', delay = 0.5, dur=2,sdur = 0.9,style = '',backtime=1, c_topox = {3023,1232}},
	    	{ event='talk', delay=0, handle_id=7, talk='快走！', dur=1.5, },
	    	{ event='move', delay=0.5, handle_id=2, end_dir=3, pos={1013, 887}, speed=200, dur=1 },
	    	{ event='move', delay=0.5, handle_id=3, end_dir=3, pos={1013, 887}, speed=200, dur=1 },
	    	{ event='move', delay=0.5, handle_id=7, end_dir=3, pos={1013, 887}, speed=200, dur=1 },
	    	{ event='kill', delay=2, handle_id=2},
	    	{ event='kill', delay=2, handle_id=3},
	    	{ event='kill', delay=2, handle_id=7}, 

	    	{ event ='move', delay=0.1, handle_id=1, end_dir=7, pos={1580,1311}, speed=280, dur=1 },
	    	{ event='talk', delay=0.1, handle_id=1, talk='！！！', dur=1.5 },
	    	{ event='talk', delay=0.1, handle_id=5, talk='！！！', dur=1.5 },  	
	    },
	    --镜头切回，过珊彤刘秀BB
	    {
	    	-- { event ='camera', delay = 0.1, target_id=5, dur=0.5, sdur = 2,style = 'follow',backtime=1},
	    	{ event ='move', delay=0.1, handle_id=5, end_dir=7, pos={1445,1297}, speed=280, dur=1 },
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=7, pos={1458,1202}, speed=280, dur=1 },
	    	--{ event ='move', delay=1, handle_id=1, end_dir=5, pos={1615,1329}, speed=340, dur=0.1 },
	    },
	    --开始BB
	    {
	    	{ event='talk', delay=0.1, handle_id=1, talk='珊彤……', dur=1.5 },
	    	{ event='talk', delay=2.2, handle_id=6, talk='呜呜……母亲……', dur=1.5 ,},
	    	{ event ='move', delay=4.3, handle_id=5, end_dir=7, pos={1391,1223}, speed=300, dur=1 },
	    	{ event='talk', delay=4.3, handle_id=5, talk='姑娘，来我看看……', dur=1.5 },
	    	{ event='playAction', delay=5.5, handle_id=6, action_id=0, dur=1, dir=3, loop=true },
	    	{ event='talk', delay=7, handle_id=5, talk='你的伤口不深，他们只是割掉了你一缕头发而已。', dur=2 },
	    	{ event='talk', delay=9.2, handle_id=5, talk='相信我，你不会有事的。', dur=1.5 }, 	
	    	{ event='talk', delay=11, handle_id=6, talk='恩……谢谢大哥哥……', dur=1.5},
	    },
	    --接着BB
	    {
	    	{ event ='move', delay=0.5, handle_id=1, end_dir=5, pos={1458,1202}, speed=340, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=1, pos={1391,1223}, speed=340, dur=1 },
	    	{ event='talk', delay=1, handle_id=1, talk='你真的是王寻大司徒的参军吗？', dur=2 },
	    	{ event='talk', delay=3.4, handle_id=5, talk='我只是一个返乡的太学生，我叫刘文叔。', dur=2 },
	    	{ event='talk', delay=5.8, handle_id=1, talk='刘文叔……', dur=1.5 },
	    	
	    },
	    --劫匪回来了
	    {
	   		{ event='createActor', delay=0.1, handle_id=2, body=31, pos={722-128,691-128}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=3, body=32, pos={818-128,624-128}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=7, body=8,  pos={849-128,721-128}, dir=3, speed=340, name_color=0xffffff, name="吴汉"}, 

	    	{ event ='move', delay=0.5, handle_id=1, end_dir=7, pos={1458,1202}, speed=340, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=7, pos={1391,1223}, speed=340, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=6, end_dir=7, pos={1360,1165}, speed=340, dur=1 },

	    	{ event='showTopTalk', delay=0.1, dialog_id="1_1_3" ,dialog_time = 2},
	    	{ event='talk', delay=2.2, handle_id=6, talk='啊！母亲！他们又追上来了', dur=2 },

	    	{ event ='move', delay=4.5, handle_id=2, end_dir=3, pos={886-64,880-64}, speed=450, dur=2 },
	    	{ event ='move', delay=4.5, handle_id=3, end_dir=3, pos={1008-64,848-64}, speed=450, dur=2 },
	    	{ event ='move', delay=4.5, handle_id=7, end_dir=3, pos={1009-64,944-64}, speed=450, dur=2 },	    	
	    	{ event ='camera', delay = 4.2, c_topox = {914-96,784-96}, dur=0.5, sdur = 1,style = '',backtime=1},
	    	{ event='talk', delay=4.4, handle_id=7, talk='快追！', dur=1.5, },
	    	{ event='talk', delay=4.4, handle_id=2, talk='别让他们跑了！', dur=1.5, },
	    },

	    --刘秀说 你们走吧 留我一人 装B就够了 
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {1487,1150}, dur=0.5, sdur = 1,style = '',backtime=1},
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=5, pos={1458,1202}, speed=340, dur=1 },
	    	{ event ='move', delay=0.1, handle_id=5, end_dir=1, pos={1391,1223}, speed=340, dur=1 },
	    	{ event ='move', delay=0.1, handle_id=6, end_dir=3, pos={1360,1165}, speed=340, dur=1 },
	    	{ event='talk', delay=1, handle_id=5, talk='夫人，小姐，你们先走，我来断后。', dur=2 },
	    	{ event='talk', delay=3.2, handle_id=1, talk='感谢壮士舍命相救，我们母女来日必定相报！', dur=2 },
	    	{ event='talk', delay=5.4, handle_id=6, talk='那你呢……', dur=1.5 },
	    	{ event='talk', delay=7.1, handle_id=5, talk='他们的目的是你们，我不会有事的，你们先走。', dur=2 },
	    	{ event='talk', delay=9.3, handle_id=6, talk='可是……', dur=1.5 },
	    	{ event='talk', delay=11, handle_id=5, talk='小姑娘，别担心，来日有缘再见，快走。', dur=2 },
	    	{ event='talk', delay=13.2, handle_id=1, talk='珊彤，快走吧。', dur=1.5 },
	    },

	    --他们走了
	    {
	    	{ event ='move', delay=0.1, handle_id=6, end_dir=7, pos={1588,1393}, speed=300, dur=2 },
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=7, pos={1714,1462}, speed=300, dur=2 },
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=7, pos={1391,1223}, speed=340, dur=1 },
	    	{ event ='move', delay=2, handle_id=5, end_dir=3, pos={1391,1223}, speed=340, dur=1 },
	    	{ event='talk', delay=2, handle_id=6, talk='刘文叔……刘文叔……', dur=1.5 },
	    	{ event='talk', delay=3.7, handle_id=5, talk='小姑娘，别担心，来日有缘再见，快走。', dur=2 },
	    	{ event='talk', delay=3.7, handle_id=5, talk='文叔……再见……我们一定要再见面！', dur=2 },
	    	

	    	{ event ='move', delay=6, handle_id=6, end_dir=3, pos={1650,1553}, speed=280, dur=2 },
	    	{ event ='move', delay=6, handle_id=1, end_dir=3, pos={1745,1554}, speed=280, dur=2 },	 
	    },
	},
--——————————————————————————————————————————————————第一章第一节1-1-1 结束————————————————————————————————————————————————————

    --============================================wuwenbin  剧情副本第一章第二节 start  =====================================----
	['juqing121'] = 
	{	
		--创建角色，丽华，刘秀
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={5104,1360}, dir=5, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={5040,1392}, dir=1, speed=340, name_color=0xffffff, name="刘秀", },	
	   	},

		--字幕，几年前
		{
			{ event = 'changeRGBA',delay=0.1,dur=1,txt = "几年前，长安……"},
			{ event='init_cimera', delay = 0.1,mx= 5104,my = 1360 },
		},

	    --刘秀对丽华说情话
		{
			{ event='talk', delay=0.1, handle_id=2, talk='丽华……', dur=1.5 },    
			{ event='talk', delay=1.7, handle_id=2, talk='小小草鸢一只，送给你，鸟儿翩翩，如秀之挂牵。', dur=3 },		
			{ event='talk', delay=5, handle_id=2, talk='此生幸得与君相识，天涯海角，我心相随。', dur=2.5 },	

			{ event = 'kill', delay = 8.5, handle_id=1, dur = 0.1 },
			{ event = 'kill', delay = 8.5, handle_id=2, dur = 0.1 },
		},

		--创建角色刘秀
	    {
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={3412,1968}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },	
	   	},

	   	--黑幕转场
		{
			{ event='init_cimera', delay = 0.3,mx= 3476,my = 1904 },
		},

	   	--邓晨的叮嘱
	    {
	   		{ event='showTopTalk', delay=0.3, dialog_id="1_2_1" ,dialog_time = 3},
	   	},

	   	--刘秀自言自语
	   	{
	   		{ event = 'talk', delay=0.1, handle_id=2, talk='丽华……你还记得这只草鸢吗？', dur=2 },    
	   		{ event = 'talk', delay=2.5, handle_id=2, talk='真想再见你一次，哪怕……只是远远的看着。', dur=2.5 }, 
	   		{ event = 'kill', delay = 6, handle_id=1, dur = 0.1 },
	   	},

	    --创建角色，丽华，胭脂，弹琴邓禹，刘秀
	    {
	    	{ event='init_cimera', delay = 0.3,mx= 5495,my = 436 },
	    	-- { event ='camera', delay = 0.1, c_topox={5495,436}, dur=1, sdur = 2,style = 'follow',backtime=1},
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={5400,474}, dir=1, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={4814,1502}, dir=1, speed=340, name_color=0xffffff, name="刘秀", },	
	   		{ event="createSpEntity",delay=0.1, handle_id=3, name="1",name_color=0xffffff,actor_name="邓禹", action_id=2, dir=5, pos={5524,410}},
	   		{ event='playAction', delay=0.2, handle_id=3, action_id=5, dur=0.1, dir=5, loop=true,},
	   		-- { event='createActor', delay=0.1, handle_id=3, body=1, pos={5524,410}, dir=5, speed=340, name_color=0xffffff, name="邓禹", },	--弹琴邓禹

	   		{ event='createActor', delay=0.1, handle_id=4, body=10, pos={5490,506}, dir=1, speed=340, name_color=0xffffff, name="邓婵", },

	   	},
		-- {
	 --   		{ event='init_cimera', delay = 0.3,mx= 5495,my = 436 },
	 --   	},
	   	

	   	--邓禹弹琴
		{

			{ event='talk', delay=0.1, handle_id=3, talk='青青子衿，悠悠我心……', dur=2 },    
			{ event='talk', delay=2.3, handle_id=3, talk='青青子佩，悠悠我思……', dur=2 },		
		},

		--刘秀说话
	    {
	   		{ event='showTopTalk', delay=0.1, dialog_id="1_2_2" ,dialog_time = 2},
	   	},

	   	--丽华意欲寻找，但被胭脂阻止
	   	{
	   		{ event='talk', delay=0.1, handle_id=1, talk='！！', dur=1.5 }, 
	   		{ event='playAction', delay=0.1, handle_id=3, action_id=0, dur=0.1, dir=5, loop=true,},
	   		{ event = 'move', delay = 0.1,handle_id=1, dir = 2, pos = {5400,474},speed = 340, dur = 1 ,end_dir=5},
	   		{ event = 'move', delay = 0.1,handle_id=4, dir = 2, pos = {5490,506},speed = 340, dur = 1 ,end_dir=5},
	   		{ event ='camera', delay = 1, target_id=2, dur=1, sdur = 0.1,style = 'follow',backtime=1},
	   		{ event ='camera', delay = 3, target_id=1, dur=1, sdur = 0.1,style = 'follow',backtime=1},

	   		{ event = 'move', delay = 4,handle_id=1, dir = 2, pos = {5374,558},speed = 340, dur = 1 ,end_dir=5},
			{ event = 'move', delay = 4,handle_id=4, dir = 2, pos = {5334,624},speed = 220, dur = 1 ,end_dir=1},	
			{ event='talk', delay=5, handle_id=4, talk='丽华！你看，你和邓表兄多有默契啊~', dur=2.5 },
			{ event='talk', delay=7.6, handle_id=4, talk='他刚刚弹唱的不就是你上次抄了半天的诗嘛。', dur=2.5 },
			{ event='talk', delay=10.5, handle_id=1, talk='是表姐你告诉他的吧。', dur=2 },
			{ event='talk', delay=13, handle_id=4, talk='我可没说啊……', dur=2 },
	   	},

	   	--刘秀被阴识驱赶
		{
			{ event ='camera', delay = 0.1, c_topox = {4830,1350}, dur=0.5, sdur = 1,style = '',backtime=1},

			{ event = 'talk', delay=1.5, handle_id=2, talk='丽华……', dur=2 }, 
			{ event = 'createActor', delay = 1, handle_id=5, body=30, pos={5148,1018}, dir=5, speed=340, name_color=0xffffff, name="阴识", },
			{ event = 'move', delay = 1.5,handle_id=5, dir = 2, pos = {4928,1430},speed = 340, dur = 1 ,end_dir=5},	
			{ event = 'talk', delay = 4, handle_id=5, talk='你来做什么？难道忘了五年前与我的约定？', dur=2 },    
			{ event = 'talk', delay = 6.5, handle_id=2, talk='我答应过你，绝对不会让她想起长安旧事。', dur=2 },
			{ event = 'talk', delay = 9, handle_id=5, talk='为了丽华，我不能让你们相见，来人啊，将此人赶出去。', dur=2.5 },		
		},

	},

	['juqing122'] = 
	{	
		--角色表，1丽华，2邓禹，3阴识，4邓婵，5邓奉，6阴兴，7胭脂

		--镜头初始化
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 5296,my = 436 }, 
	   	},
		--创建阴兴，丽华，邓婵
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={5264,464}, dir=1, speed=340, name_color=0xffffff, name="丽华", },
	   		-- { event='createActor', delay=0.1, handle_id=2, body=1, pos={5354,402}, dir=5, speed=340, name_color=0xffffff, name="邓禹", },
	   		{ event="createSpEntity",delay=0.1, handle_id=2, name="1",name_color=0xffffff,actor_name="邓禹", action_id=2, dir=5, pos={5354,402}},	
	   		{ event='createActor', delay=0.1, handle_id=4, body=10, pos={5326,494}, dir=1, speed=340, name_color=0xffffff, name="邓婵", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=20, pos={5106,524}, dir=2, speed=340, name_color=0xffffff, name="阴兴", },	

	   		{ event='effect', handle_id=101,  delay = 0.1 , pos={5307,300}, effect_id=20018, is_forever = true},

	   		-- { event='createTexture', handle_id=101, delay= 4, pos={ 952,702 }, path = "nopack/juqing/bxhl.png",},	--创建玉佩贴图
	   	},

	   	--丽华，阴兴，邓婵悄悄说话，邓婵脸红跑开
	   	{
	   		{ event='talk', delay=0.1, handle_id=1, talk='……', dur=1.5 },
			{ event='talk', delay=0.1, handle_id=2, talk='……', dur=1.5, },
			{ event='talk', delay=0.1, handle_id=4, talk='……', dur=1.5, },

			{ event='talk', delay=1.8, handle_id=4, talk='[a]', dur=1.5, emote = { a = 48 }},
			{ event = 'move', delay = 1.8,handle_id = 4, dir = 2, pos = {5298,564},speed = 340, dur = 1.5 ,end_dir=5},
			{ event = 'move', delay = 1.8,handle_id = 1, dir = 2, pos = {5266,628},speed = 260, dur = 1.5 ,end_dir=1},
	   	},

	   	--丽华让邓婵快去
	   	{
	   		{ event='talk', delay=0.1, handle_id=4, talk='丽华！这……这怎么好意思啊……', dur=2 },
			{ event='talk', delay=2, handle_id=1, talk='有什么不好意思的！快去！', dur=2, },
			{ event='talk', delay=4, handle_id=4, talk='好吧……', dur=1.5, },

			{ event = 'move', delay = 4.3,handle_id = 1, dir = 2, pos = {5266,628},speed = 260, dur = 1.5 ,end_dir=5},
			{ event = 'move', delay = 4,handle_id = 4, dir = 2, pos = {4852,816},speed = 260, dur = 1.5 ,end_dir=5},
			{ event = 'kill', delay = 5.5, handle_id=4, dur = 0.1 },
	   	},

	   	--丽华跑回去拿玉佩给阴兴
	   	{
			{ event = 'move', delay = 0.1,handle_id = 1, dir = 2, pos = {5272,390},speed = 260, dur = 1.5 ,end_dir=1},
			{ event = 'move', delay = 2,handle_id = 6, dir = 2, pos = {5106,524},speed = 260, dur = 1.5 ,end_dir=1},--阴兴转身
			{ event = 'move', delay = 2,handle_id = 1, dir = 2, pos = {5170,494},speed = 260, dur = 1.5 ,end_dir=5},

			{ event='playAction', delay=1.3, handle_id=1, action_id=2, dur=0.1, dir=1, loop=true,},
			{ event='removeEffect', handle_id=101,  delay = 1.6 , effect_id=20018},


			{ event='talk', delay=2.5, handle_id=1, talk='待会表姐跳舞的时候，把这个玉佩交给大哥。', dur=2 },
			{ event='talk', delay=4.5, handle_id=6, talk='好的，姐姐。', dur=1.5, },

			{ event = 'move', delay = 4.8,handle_id = 6, dir = 2, pos = {4852,816},speed = 260, dur = 1.5 ,end_dir=7},
			{ event = 'kill', delay = 6, handle_id=6, dur = 0.1 },
	   	},

	   	--丽华回去和邓禹说话
	   	{
			{ event = 'move', delay = 0.1,handle_id = 1, dir = 2, pos = {5264,464},speed = 260, dur = 5.5 ,end_dir=1},

			{ event='talk', delay=1, handle_id=1, talk='阿禹，准备好了吗？奏乐~', dur=2 },
			{ event='talk', delay=3, handle_id=2, talk='嗯。', dur=1.5, },

			{ event='playAction', delay=4.8, handle_id=2, action_id=5, dur=0.1, dir=5, loop=true,},
			{ event='playBgMusic', delay=4.8, id = 1 ,loop = true},
		},

	   	--邓婵跳舞
	   	{
	   		{ event = 'kill', delay = 0.1, handle_id=1, dur = 0.1 },
	   		{ event = 'kill', delay = 0.1, handle_id=2, dur = 0.1 },

	   		{ event ='camera', delay = 0.1, c_topox={4136,420}, dur=0.5, sdur = 0.5,style = 'follow',backtime=1},
	   		{ event='createActor', delay=0.1, handle_id=104, body=10, pos={4364,494}, dir=7, speed=340, name_color=0xffffff, name="邓婵", },
	   		{ event="createSpEntity",delay=0.1, handle_id=4, name="10",name_color=0xffffff,actor_name="邓婵", action_id=2, dir=7, pos={4364,494}},
	   		{ event='createActor', delay=0.1, handle_id=3, body=30, pos={3990,434}, dir=3, speed=340, name_color=0xffffff, name="阴识", },
			{ event='createActor', delay=0.1, handle_id=6, body=20, pos={4048,400}, dir=3, speed=340, name_color=0xffffff, name="阴兴", },

			{ event='hideCast', delay=0.2, handle_id=104},
		},
		{
			{ event='playAction', delay=0.1, handle_id=4, action_id=6, dur=0.1, dir=2, loop=true, },
			-- { event='playAction', delay=0.8, handle_id=4, action_id=2, dur=0.1, dir=5, loop=false, },
			-- { event='playAction', delay=1.3, handle_id=4, action_id=2, dur=0.1, dir=7, loop=false, },
			-- { event='playAction', delay=2, handle_id=4, action_id=2, dur=0.1, dir=3, loop=false, },
			-- { event='playAction', delay=2.7, handle_id=4, action_id=2, dur=0.1, dir=1, loop=false, },
			-- { event='playAction', delay=3.4, handle_id=4, action_id=2, dur=0.1, dir=5, loop=false, },
			-- { event='playAction', delay=4, handle_id=4, action_id=2, dur=0.1, dir=3, loop=false, },
			-- { event='playAction', delay=4.6, handle_id=4, action_id=2, dur=0.1, dir=7, loop=false, },
		},
		{
			-- { event ='camera', delay = 0.2, target_id=3, dur=0.1, sdur = 0.5,style = 'follow',backtime=1},
			{ event='talk', delay=0.1, handle_id=6, talk='大哥，这个玉佩……', dur=2 },
			{ event = 'move', delay = 0.1,handle_id = 6, dir = 2, pos = {4048,400},speed = 300, dur = 1.5 ,end_dir=5},
			{ event='talk', delay=2.1, handle_id=3, talk='……', dur=1.5, },
			{ event='talk', delay=3.8, handle_id=6, talk='唉……', dur=1.5, },

			{ event='showCast', delay=3.6, handle_id=104},
	   		{ event='hideCast', delay=3.6, handle_id=4},
	   		{ event = 'kill', delay = 3.6, handle_id=4,},

	   	
	   		{ event = 'move', delay = 3.6,handle_id = 3, dir = 2, pos = {3216,726},speed = 300, dur = 1.5 ,end_dir=6},
	   		{ event = 'move', delay = 4.8,handle_id = 6, dir = 2, pos = {3216,726},speed = 300, dur = 1.5 ,end_dir=5},

	   		{ event = 'kill', delay = 7.3, handle_id=6, dur = 0.1 },
	   	},

	   	-- --恢复场景音乐
	   	-- {
	    --   { event='backSceneMusic', delay = 0.1}, 
	    -- },
	   	--丽华给邓婵出吸引注意的鬼点子
	   	{

	   		{ event ='camera', delay = 0.1, c_topox={4380,506}, dur=0.5, sdur = 0.5,style = 'follow',backtime=1},

	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={4724,718}, dir=1, speed=340, name_color=0xffffff, name="丽华", },


	   		{ event = 'move', delay = 0.1,handle_id = 104, dir = 2, pos = {4210,528},speed = 300, dur = 1.5 ,end_dir=5},
	   		{ event = 'move', delay = 0.2,handle_id = 1, dir = 2, pos = {4268,560},speed = 300, dur = 1.5 ,end_dir=7},

	   		{ event='talk', delay=2.3, handle_id=1, talk='表姐……', dur=1.5 },

			{ event='talk', delay=4.5, handle_id=104, talk='我入了他的眼，始终入不了他的心……', dur=3, },

			{ event = 'move', delay = 9,handle_id = 104, dir = 2, pos = {4210,528},speed = 300, dur = 1.5 ,end_dir=3},
			{ event='talk', delay=8.8, handle_id=1, talk='噢！有了，你假装掉到水里去，我大哥一定会来救你的。', dur=2.5, },
	   	},

	   	--胭脂冲太快，把丽华和邓婵都撞下水了
	   	{
	   		{ event='createActor', delay=0.1, handle_id=7, body=41, pos={4724,686}, dir=5, speed=340, name_color=0xffffff, name="胭脂", },

	   		{ event = 'move', delay = 0.2,handle_id = 7, dir = 2, pos = {4292,554},speed = 260, dur = 1.5 ,end_dir=6},

			{ event='talk', delay=0.2, handle_id=7, talk='姑娘！干嘛要推别人下水啊……', dur=1.6, },

			
			{ event='talk', delay=2.2, handle_id=7, talk='哎呀——', dur=1 },
			{ event='playAction', delay=2.4, handle_id=7, action_id=3, dur=0.1, dir=1, loop=false, },

			-- { event='talk', delay=2.4, handle_id=1, talk='啊——', dur=1 },
			{ event='talk', delay=2.4, handle_id=104, talk='啊——', dur=1 },

			-- { event = 'move', delay = 2,handle_id = 4, dir = 2, pos = {4210,528},speed = 300, dur = 1.5 ,end_dir=1},
	  --  		{ event = 'move', delay = 2,handle_id = 1, dir = 2, pos = {4268,560},speed = 300, dur = 1.5 ,end_dir=1},
			{ event='playAction', delay=2.4, handle_id=1, action_id=3, dur=0.1, dir=1, loop=false, once = true},
			{ event='playAction', delay=2.4, handle_id=104, action_id=3, dur=0.1, dir=1, loop=false, once = true},
			-- { event='playAction', delay=2.2, handle_id=7, action_id=3, dur=0.1, dir=1, loop=false, once = true},

			-- { event='playAction', delay=2.3, handle_id=1, action_id=4, dur=0.1, dir=1, loop=false, once = true},
			-- { event='playAction', delay=2.3, handle_id=4, action_id=4, dur=0.1, dir=1, loop=false, once = true},
			-- { event='playAction', delay=2.3, handle_id=7, action_id=4, dur=0.1, dir=1, loop=false, once = true},
			{ event='jump', delay=2.8, handle_id=1, dir=1, pos={ 4076,792 }, speed=120, dur=0.8 ,end_dir = 3},
			{ event='jump', delay=2.8, handle_id=104, dir=1, pos={ 4152,810 }, speed=120, dur=0.8 ,end_dir = 3},
			{ event='jump', delay=2.7, handle_id=7, dir=5, pos={ 4152,810 }, speed=120, dur=0.8 ,end_dir = 3},

			-- { event='hideCast', delay=2.8, handle_id=1},
			-- { event='hideCast', delay=2.8, handle_id=4},
			-- { event='hideCast', delay=2.8, handle_id=7},

			{ event = 'kill', delay = 3.3, handle_id=1, dur = 0.1 },
	   		{ event = 'kill', delay = 3.3, handle_id=104, dur = 0.1 },
	   		{ event = 'kill', delay = 3.3, handle_id=7, dur = 0.1 },
	   	},

	   	--阴识听见呼救，急忙跳入河中救人
	   	{
	   		{ event='createActor', delay=0.1, handle_id=201, body=19, pos={3124,728}, dir=2, speed=340, name_color=0xffffff, name="家丁", },
	   		{ event ='camera', delay = 0.1, c_topox={3164,714}, dur=0.5, sdur = 0.5,style = 'follow',backtime=1},
	   	},
	   	{
	   		{ event ='showTopTalk', delay= 0.1, dialog_id="1_2_3" ,dialog_time = 1.5},

	   		{ event ='talk', delay = 1.5, handle_id=3, talk='！！', dur=1 }, 
	   		{ event = 'move', delay = 1.5,handle_id = 3, dir = 2, pos = {3216,726},speed = 300, dur = 1.5 ,end_dir=2},

	   		{ event = 'move', delay = 3.5,handle_id = 3, dir = 2, pos = {3440,814},speed = 300, dur = 1.5 ,end_dir=2},
	   		{ event ='talk', delay = 3.8, handle_id=3, talk='是婵儿！', dur=1.5 }, 
	   		{ event='jump', delay=5, handle_id=3, dir=2, pos={ 3695,783 }, speed=120, dur=0.8 ,end_dir = 2},
	   		{ event = 'kill', delay = 5.5, handle_id=3, dur = 0.1 },

	   	},

	    --创建角色，1丽华，2邓禹，4邓婵，5邓奉，6阴兴，7胭脂
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={3604,1096}, dir=1, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=1, pos={3550,1058}, dir=1, speed=340, name_color=0xffffff, name="邓禹", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=30, pos={2838,1044}, dir=3, speed=340, name_color=0xffffff, name="阴识", },	
	   		{ event='createActor', delay=0.1, handle_id=4, body=10, pos={2898,1080}, dir=7, speed=340, name_color=0xffffff, name="邓婵", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=29, pos={3722,1006}, dir=1, speed=340, name_color=0xffffff, name="邓奉", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=20, pos={3672,1122}, dir=1, speed=340, name_color=0xffffff, name="阴兴", },	
	   		{ event='createActor', delay=0.1, handle_id=7, body=41, pos={3770,1062}, dir=5, speed=340, name_color=0xffffff, name="胭脂", },

	   		{ event='playAction', delay=0.2, handle_id=5, action_id=4, dur=0.1, dir=1, loop=false, once = true },	--邓奉倒下
	   		{ event='playAction', delay=0.2, handle_id=7, action_id=4, dur=0.1, dir=7, loop=false, once = true },	--胭脂倒下
	   	},

	   	-- {
	   	-- 	{ event ='camera', delay = 0.1, target_id=3, dur=0.1, sdur = 0.1,style = 'follow',backtime=1},
	   	-- },

	   	-- --阴识听到呼救，跑到河边
	   	-- {	
	   	-- 	{ event = 'move', delay = 0.1,handle_id = 3, dir = 2, pos = {3960,410},speed = 300, dur = 1.5 ,end_dir=5},
	    	
	   	-- 	{ event ='talk', delay = 2.1, handle_id=3, talk='！！', dur=1.5 }, 
	   	-- 	{ event = 'move', delay = 2.3,handle_id=3, dir = 2, pos = {3533,934},speed = 280, dur = 1 ,end_dir=2},
	   	-- 	{ event ='camera', delay = 6.5, c_topox = {3676,1004}, dur=0.5, sdur = 0.1,style = '',backtime=1},
	   	-- },

	   	--镜头移到被救上来的岸边
	   	{
	  		-- { event ='camera', delay = 0.1, c_topox = {3676,1004}, dur=0.5, sdur = 0.1,style = '',backtime=1},
	  		{ event = 'changeRGBA',delay=0.1,dur=1,txt = "一刻钟后……"},	
	  		{ event='init_cimera', delay = 0.3,mx= 3676,my = 1004 },

	  		{ event='talk', delay=1, handle_id=5, talk='咳……咳咳……', dur=2, },
			{ event='talk', delay=1, handle_id=7, talk='咳……咳咳……', dur=2, },
	  	},

	  	--丽华调笑邓奉
	  	{
			{ event='talk', delay=0.5, handle_id=1, talk='奉儿你又不会游泳！下来干嘛！反倒要我救你！', dur=2 },
			{ event='talk', delay=2.8, handle_id=2, talk='[a]哈哈……', dur=1.5, emote = {a = 3} },
			{ event='talk', delay=2.8, handle_id=6, talk='[a]哈哈……', dur=1.5, emote = {a = 3} },

			{ event = 'move', delay = 2.8,handle_id=5, dir = 2, pos = {3722,1006},speed = 340, dur = 1 ,end_dir=5},	--邓奉起身
			{ event = 'move', delay = 2.8,handle_id=7, dir = 2, pos = {3770,1062},speed = 340, dur = 1 ,end_dir=5},	--胭脂起身
			{ event='talk', delay=4.6, handle_id=5, talk='[a]救人心切，忘了……', dur=1.5, emote = {a = 30}  },
	   	},

	   	--阴兴问丽华玉佩怎么办
	   	{
	   		{ event = 'move', delay = 0.5,handle_id=1, dir = 2, pos = {3604,1096},speed = 340, dur = 1 ,end_dir=3},	
			{ event = 'move', delay = 0.5,handle_id=6, dir = 2, pos = {3672,1122},speed = 340, dur = 1 ,end_dir=7},	

			{ event='talk', delay=0.5, handle_id=6, talk='姐姐，那这个玉佩怎么办？', dur=2 },
			{ event='talk', delay=2.8, handle_id=1, talk='[a]快看那边。', dur=1.5, emote = {a = 2} },

			{ event ='camera', delay = 4.8, c_topox = {2868,1060}, dur=0.8, sdur = 0.1,style = '',backtime=1},
			{ event = 'move', delay = 4.3,handle_id=1, dir = 2, pos = {3604,1096},speed = 340, dur = 1 ,end_dir=6},	
			{ event = 'move', delay = 4.3,handle_id=2, dir = 2, pos = {3550,1058},speed = 340, dur = 1 ,end_dir=6},
			{ event = 'move', delay = 4.3,handle_id=5, dir = 2, pos = {3722,1006},speed = 340, dur = 1 ,end_dir=6},	
			{ event = 'move', delay = 4.3,handle_id=6, dir = 2, pos = {3672,1122},speed = 340, dur = 1 ,end_dir=6},
			{ event = 'move', delay = 4.3,handle_id=7, dir = 2, pos = {3770,1062},speed = 340, dur = 1 ,end_dir=6},
	   	},

	   	--阴识，邓婵含情脉脉对视
	   	{
	   		{ event='talk', delay=0.3, handle_id=4, talk='[a]', dur=2 , emote = {a = 48}},
	   	},



	 --   	--阴识关心邓婵
		-- {
		-- 	{ event ='camera', delay = 0.1, target_id=3, dur=0.5, sdur = 2,style = 'follow',backtime=1},
		-- 	{ event = 'move', delay = 0.5,handle_id=3, dir = 2, pos = {3606,950},speed = 340, dur = 1 ,end_dir=3},	
		-- 	{ event = 'move', delay = 0.5,handle_id=4, dir = 2, pos = {3670,982},speed = 340, dur = 1 ,end_dir=7},	

		-- 	{ event='talk', delay=1, handle_id=3, talk='冷不冷？我送你回去。', dur=2 ,},    
		-- 	{ event='talk', delay=3, handle_id=4, talk='[a]我不冷。[b]', dur=2 , emote = {a = 3,b = 48} },	
		-- 	{ event='talk', delay=5, handle_id=3, talk='我送你回府换衣服。', dur=1.5 },    
		-- 	{ event='talk', delay=6.5, handle_id=4, talk='谢谢表兄……', dur=1.5 },	

		-- 	{ event = 'move', delay = 7,handle_id=3, dir = 2, pos = {2874,564},speed = 340, dur = 1 ,end_dir=7},	
		-- 	{ event = 'move', delay = 7,handle_id=4, dir = 2, pos = {2874,564},speed = 340, dur = 1 ,end_dir=7},	
		-- 	{ event ='camera', delay = 7, c_topox = {3758,960}, dur=0.5, sdur = 2,style = '',backtime=1},

		--     --众人转向，窃笑
		-- 	{ event = 'move', delay = 7.3,handle_id=1, dir = 2, pos = {3570,1038},speed = 340, dur = 1 ,end_dir=7},	
		-- 	{ event = 'move', delay = 7.3,handle_id=2, dir = 2, pos = {3604,1096},speed = 340, dur = 1 ,end_dir=7},	
		-- 	{ event = 'move', delay = 7.3,handle_id=5, dir = 2, pos = {3722,1006},speed = 340, dur = 1 ,end_dir=7},	
		-- 	{ event = 'move', delay = 7.3,handle_id=6, dir = 2, pos = {3672,1122},speed = 340, dur = 1 ,end_dir=7},	
		-- 	{ event = 'move', delay = 7.3,handle_id=7, dir = 2, pos = {3854,1036},speed = 340, dur = 1 ,end_dir=7},	

		-- 	{ event='talk', delay=7.3, handle_id=1, talk='[a]', emote = {a = 2} },    
		-- 	{ event='talk', delay=7.3, handle_id=2, talk='[a]', emote = {a = 2} },	
		-- 	{ event='talk', delay=7.3, handle_id=5, talk='[a]', emote = {a = 2} },    
		-- 	{ event='talk', delay=7.3, handle_id=6, talk='[a]', emote = {a = 2} },	
		-- },

	},

	--============================================wuwenbin  剧情副本第一章第二节 end    =====================================----

	--============================================sunluyao  剧情副本第一章第三节 start  =====================================----
	['juqing131'] = {	

         --演员表  1丽华  2邓婵  3胭脂  4马武  5往常  6成丹
         --胭脂买蜜饯，丽华邓婵被劫持。
	    {
	   		{ event='init_cimera', delay = 0.1,mx= 2652,my = 2012 }, 	 
	    },

	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2627,2060}, dir=5, speed=340, name_color=0xffffff, name="丽华", },

	   		{ event='createActor', delay=0.1, handle_id=2, body=10, pos={2701,2133}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },

	   		{ event='createActor', delay=0.1, handle_id=3, body=41, pos={2562,2169}, dir=1, speed=340, name_color=0xffffff, name="胭脂", },

	   	},

		{
			{ event='talk', delay=1.1, handle_id=1, talk='胭脂，帮我去买些蜜饯来。', dur=1.5 },    
			{ event='talk', delay=2.5, handle_id=3, talk='好的，小姐。', dur=1.5 },
			{ event = 'move', delay = 3.5,handle_id=3, dir = 2, pos = {2178,2393},speed = 340, dur = 1 },
			{ event = 'kill', delay = 5, handle_id=3, dur = 0.1 },			

		},
	    {
	   		{ event='createActor', delay=0.1, handle_id=4, body=47, pos={2025,1961}, dir=3, speed=340, name_color=0xffffff, name="马武", },

	   	},


		{
			{ event = 'camera', delay = 0.2, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = {  2308,1974  } }, 
			{ event='jump', delay=0.8, handle_id=4, dir=3, pos={ 2357,2039 }, speed=120, dur=0.8 ,end_dir = 3},

			{ event = 'camera', delay = 1, dur=0.2,sdur = 0.9,style = '',backtime=1, c_topox = {  2607,2000  } }, 

	   		{ event='createActor', delay=1.5, handle_id=5, body=7, pos={2354,2222}, dir=5, speed=340, name_color=0xffffff, name="王常", },
	   		{ event='createActor', delay=1.5, handle_id=6, body=29, pos={2447,2354}, dir=5, speed=340, name_color=0xffffff, name="成丹", },

			{ event = 'move', delay = 1.6,handle_id=5, dir = 2, pos = {2501,2076},speed = 340, dur = 1 ,end_dir=1},
			{ event = 'move', delay = 1.6,handle_id=6, dir = 2, pos = {2773,2202},speed = 340, dur = 1 ,end_dir=7},	

			{ event = 'move', delay = 1.6,handle_id=4, dir = 2, pos = {2727,2027},speed = 50, dur = 0.5 ,end_dir=3},
			{ event = 'effect', handle_id=101, delay = 2, target_id = 2, pos = {0,40}, layer = 2, effect_id = 20015, dx = 0,dy = 30,is_forever = false}, -- 被撞击特效
			{ event = 'effect', handle_id=102, delay = 2, target_id = 1, pos = {0,40}, layer = 2, effect_id = 20015, dx = 0,dy = 30,is_forever = false}, -- 被撞击特效						
			{ event = 'move', delay = 2.1,handle_id=4, dir = 2, pos = {2727,2027},speed = 340, dur = 0.1 ,end_dir=5},

			{ event='playAction', delay=1.9, handle_id=1, action_id=3, dur=1, dir=5, loop=false },
			{ event='playAction', delay=1.9, handle_id=2, action_id=3, dur=1, dir=5, loop=false },


			{ event='playAction', delay=2.2, handle_id=2, action_id=4, dur=1, dir=5, loop=false ,once= true },

			{ event='talk', delay=1.9, handle_id=2, talk='[a]',emote={a=22}, dur=1.5 },    
			{ event='talk', delay=2.2, handle_id=1, talk='怎么回事！', dur=1.5 },

			{ event = 'move', delay = 2.4,handle_id=1, dir = 3, pos = {2644,2098},speed = 340, dur = 0.1 ,end_dir=3},
		},

		{
			{ event='talk', delay=0.1, handle_id=4, talk='别动，否则就杀了你们！', dur=3 },    
		},

	},



	['juqing132'] = {
		--演员表 1丽华 2邓婵 3马武 4王常 5成丹
		--邓婵装病，丽华框马武等人，满满的套路。
	    {
	   		{ event='init_cimera', delay = 0.1,mx= 2626,my = 2020 }, 	 
	    },

	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2654,2018}, dir=2, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=10, pos={2725,2036}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },

			{ event='playAction', delay=0.2, handle_id=2, action_id=4, dur=1, dir=5, loop=false ,once = true },

	   		{ event='createActor', delay=0.1, handle_id=3, body=47, pos={2588,2221}, dir=1, speed=340, name_color=0xffffff, name="马武", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=7, pos={2690,2237}, dir=7, speed=340, name_color=0xffffff, name="王常", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=29, pos={2491,2149}, dir=1, speed=340, name_color=0xffffff, name="成丹", },

			{ event='talk', delay=1, handle_id=2, talk='[a]',emote={a=20}, dur=1.5 },    
			{ event='talk', delay=2, handle_id=1, talk='表姐，你醒醒，别吓我啊……表姐！', dur=2 },

	   	},
	   	{   
			{ event = 'move', delay = 0.5,handle_id=1, dir = 2, pos = {2635,2113},speed = 340, dur = 1 ,end_dir=5},

			{ event='talk', delay=1, handle_id=1, talk='我表姐体弱有心疾，旧病复发，求你们请个大夫来吧。', dur=2 },    
			{ event='talk', delay=3.5, handle_id=4, talk='我们要是有钱请大夫，还用得着劫人要赎金吗！', dur=2 },
			{ event='talk', delay=6, handle_id=1, talk='那……怎么办？表姐……[a]',emote={a=46}, dur=2 },  

			{ event = 'move', delay = 6.5,handle_id=1, dir = 2, pos = {2825,2041},speed = 340, dur = 1 ,end_dir=7},
	   	},
	   	{
			{ event='talk', delay=0.1, handle_id=2, talk='丽华……', dur=1.5 },    
			{ event='talk', delay=1.5, handle_id=1, talk='[a]，表姐，你继续装病，他们肯定会把你先送回去的。',emote={a=2}, dur=2 },	
			{ event='talk', delay=4, handle_id=2, talk='恩恩。', dur=1.5 }, 			   	
	   	},
	   	{

			{ event = 'move', delay = 0.5,handle_id=1, dir = 2, pos = {2794,2116},speed = 340, dur = 1 ,end_dir=5},
			{ event='talk', delay=2.5, handle_id=1, talk='[a]求求你们，放了我表姐，让她先回家看病吧。',emote={a=46}, dur=2 },	   	
	   	},
	   	{
	
			{ event = 'move', delay = 1,handle_id=4, dir = 7, pos = {2667,2182},speed = 340, dur = 1 ,end_dir=5},
			{ event = 'move', delay = 1,handle_id=5, dir = 5, pos = {2565,2142},speed = 340, dur = 1 ,end_dir=3},	

			{ event='talk', delay=2.5, handle_id=3, talk='……', dur=1.5 },	 
			{ event='talk', delay=2, handle_id=4, talk='……', dur=1.5 },	 
			{ event='talk', delay=2.3, handle_id=5, talk='……', dur=1.5 },	 			
	   	},
	   	{
	   		{ event = 'move', delay = 1,handle_id=4, dir = 2, pos = {2667,2182},speed = 340, dur = 1 ,end_dir=1},	

			{ event = 'move', delay = 1,handle_id=5, dir = 2, pos = {2565,2142},speed = 340, dur = 1 ,end_dir=1},
  

			{ event='talk', delay=2.5, handle_id=3, talk='我弟兄先把你表姐送回去，你继续跟着我们走。', dur=2 },	 
			{ event='talk', delay=5, handle_id=1, talk='太好了，谢谢，谢谢你们！', dur=3 },	 			 	
	   	},
	},




	--============================================sunluyao  剧情副本第一章第三节 end    =====================================----


	--============================================wuwenbin  剧情副本第一章第四节 start    =====================================----

	--刘縯、邓晨包围王常、成丹，但被逃脱
	['juqing141'] = {	
    --创建角色
    	{
	   		{ event='init_cimera', delay = 0.1,mx= 2726,my = 2102 }, 	 
	    },
	    
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={2602,2201}, dir=1, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=23, pos={2674,2261}, dir=1, speed=340, name_color=0xffffff, name="邓晨", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=7, pos={2723,2103}, dir=5, speed=340, name_color=0xffffff, name="王常", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=29, pos={2795,2137}, dir=5, speed=340, name_color=0xffffff, name="成丹", },

	   		--包围上半圈
	   		{ event='createActor', delay=0.1, handle_id=11, body=25, pos={2454,2177}, dir=3, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=25, pos={2488,2113}, dir=3, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=25, pos={2546,2084}, dir=3, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=25, pos={2615,2083}, dir=3, speed=340, name_color=0xffffff, name="随从", },

	   		--包围下半圈
	   		{ event='createActor', delay=0.1, handle_id=15, body=25, pos={2747,2324}, dir=7, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=16, body=25, pos={2803,2329}, dir=7, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=17, body=25, pos={2866,2295}, dir=7, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=18, body=25, pos={2897,2227}, dir=7, speed=340, name_color=0xffffff, name="随从", },
	   	},


	    --质问丽华所在
		{
			{ event='talk', delay= 1, handle_id = 3, talk='[a]你们是谁？', dur=2 ,emote = {a= 22}},
			{ event='talk', delay= 2.5, handle_id = 1, talk='南阳刘伯升！', dur=2 },	
		},
	   	{
			{ event = 'move', delay = 0.3,handle_id=1, dir = 1, pos = {2631,2169},speed = 260, dur = 1 ,end_dir = 1},	
			{ event = 'move', delay = 0.3,handle_id=2, dir = 7, pos = {2699,2201},speed = 260, dur = 1 ,end_dir = 1},	
			{ event = 'move', delay = 0.5,handle_id=3, dir = 1, pos = {2752,2075},speed = 260, dur = 1 ,end_dir = 5},	
			{ event = 'move', delay = 0.5,handle_id=4, dir = 7, pos = {2824,2109},speed = 260, dur = 1 ,end_dir = 5},	


   			{ event = 'talk', delay= 0.3, handle_id = 2, talk='[a]丽华在哪里？', dur=1 ,emote = {a= 34}},
   			{ event = 'talk', delay= 1.5, handle_id = 3, talk='[a]跑！', dur=1 ,emote = {a= 39}},
   			--{ event = 'kill', delay = 3,handle_id=80, dur = 0.1 },
	   	},
	    --两人逃跑
	   	{
			{ event = 'move', delay = 0.1,handle_id=3, dir = 1, pos = {3339,1560},speed = 260, dur = 0.5 ,end_dir = 1},	
			{ event = 'move', delay = 0.1,handle_id=4, dir = 1, pos = {3428,1593},speed = 260, dur = 0.5 ,end_dir = 1},	
	   	},
	    --众人追赶
	   	{
	   		{ event ='camera', delay = 0.6, target_id= 1, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
	   		{ event = 'talk', delay= 0.1, handle_id = 1, talk='想跑？给我追！', dur=1.5 },
			
			{ event = 'move', delay = 0.2,handle_id=1, dir = 1, pos = {3339,1560},speed = 300, dur = 0.5 ,end_dir = 1},	
			{ event = 'move', delay = 0.2,handle_id=2, dir = 2, pos = {3428,1593},speed = 300, dur = 0.5 ,end_dir = 1},
			{ event = 'move', delay = 0.2,handle_id=11, dir = 11, pos = {3306,1550},speed = 300, dur = 0.5 ,end_dir = 1},	
			{ event = 'move', delay = 0.2,handle_id=12, dir = 12, pos = {3306,1550},speed = 300, dur = 0.5 ,end_dir = 1},
			{ event = 'move', delay = 0.2,handle_id=13, dir = 13, pos = {3306,1550},speed = 300, dur = 0.5 ,end_dir = 1},	
			{ event = 'move', delay = 0.2,handle_id=14, dir = 14, pos = {3306,1550},speed = 300, dur = 0.5 ,end_dir = 1},
			{ event = 'move', delay = 0.2,handle_id=15, dir = 15, pos = {3489,1685},speed = 300, dur = 0.5 ,end_dir = 1},	
			{ event = 'move', delay = 0.2,handle_id=16, dir = 16, pos = {3489,1685},speed = 300, dur = 0.5 ,end_dir = 1},
			{ event = 'move', delay = 0.2,handle_id=17, dir = 17, pos = {3489,1685},speed = 300, dur = 0.5 ,end_dir = 1},	
			{ event = 'move', delay = 0.2,handle_id=18, dir = 18, pos = {3489,1685},speed = 300, dur = 0.5 ,end_dir = 1},

			{ event = 'kill', delay = 1.5,handle_id=1, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=2, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=3, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=4, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=11, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=12, dur = 0.1 },
			{ event = 'kill', delay = 1.5,handle_id=13, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=14, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=15, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=16, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=17, dur = 0.1 },	
			{ event = 'kill', delay = 1.5,handle_id=18, dur = 0.1 },	
	   	},
	},

    --丽华逃脱，被刘秀所救
	['juqing142'] = {	

        --角色前置对白
        {
	   		{ event='init_cimera', delay = 0.1,mx= 2637,my = 930 }, 	 
	    },

	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2637,930}, dir=5, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={2018,1208}, dir=1, speed=340, name_color=0xffffff, name="刘秀", },
	   	},


	    --丽华缓慢地跑
		{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2411,1053},speed = 440, dur = 1 ,end_dir = 5},	 
			{ event = 'talk', delay= 0.3, handle_id = 1, talk='[a]', dur=3 ,emote = {a= 43}},
			{ event ='camera', delay = 0.2, target_id= 1, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
			{ event = 'move', delay = 0.5,handle_id=2, dir = 1, pos = {2284,1136},speed = 300, dur = 0.5 ,end_dir = 1},
			{ event = 'talk', delay= 1.8, handle_id = 1, talk='[a]是谁……？[a]', dur=1.5 ,emote = {a= 43}},
		},

		--刘秀出现在丽华前面
		{
			{ event = 'talk', delay= 0.3, handle_id = 2, talk='我是刘秀，丽华你怎么了？', dur=1.5 },
			{ event = 'talk', delay= 1.8, handle_id = 1, talk='刘秀？文叔哥哥……[a]', dur=1.5 ,emote = {a= 43}},
		},

	    --丽华晕倒
		{
			{ event = 'playAction', handle_id= 1, delay = 0.1, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},	 
			{ event = 'talk', delay= 0.3, handle_id = 2, talk='丽华！丽华！', dur=2 },
			{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2400,1010},speed = 240, dur = 1 ,end_dir = 3},	
		},

	},
	--============================================wuwenbin  剧情副本第一章第四节 end    =====================================----


	--============================================wuwenbin  剧情副本第一章第五节 start    =====================================----
	['juqing151'] = {	

        --创建角色 1.尉迟峻 2.小五 3.小六

	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=22, pos={600,1150}, dir=1, speed=340, name_color=0xffffff, name="尉迟峻", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=15, pos={1045,880}, dir=3, speed=340, name_color=0xffffff, name="小五", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=16, pos={1131,940}, dir=7, speed=340, name_color=0xffffff, name="小六", },
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1197,my = 846 }, 	 
	    },

	    --两个小孩在阴府前面吃东西
		{ 
			{ event = 'talk', delay= 0.1, handle_id = 3, talk='真好吃。', dur=2 },
			{ event = 'talk', delay= 1.5, handle_id = 2, talk='恩恩，快吃。', dur=1.5 },
		},

		--尉迟峻跑过来
		{
			{ event = 'talk', delay= 0.5, handle_id = 1, talk='哎呀，别吃了！', dur=1.5 },
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {1011,971},speed = 340, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {1045,880},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.1,handle_id=3, dir = 1, pos = {1131,940},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'talk', delay= 2.5, handle_id = 1, talk='这好吃的东西多着呢，咱不吃这个！走，摸他家粮仓去。', dur=2.5 },
			{ event = 'talk', delay= 5.3, handle_id = 2, talk='哦哦。[a]', dur=1.5 ,emote = {a= 18}},
			{ event = 'talk', delay= 5.3, handle_id = 3, talk='恩恩。[a]', dur=1.5 ,emote = {a= 18}},
		},

	    --三人跑进阴府
		{
			{ event ='camera', delay = 0.7, target_id= 1, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {1393,664},speed = 340, dur = 0.5 ,end_dir = 5},	 
			{ event = 'move', delay = 0.8,handle_id=2, dir = 1, pos = {1394,588},speed = 340, dur = 0.3 ,end_dir = 5},
			{ event = 'move', delay = 0.8,handle_id=3, dir = 1, pos = {1469,629},speed = 340, dur = 0.3 ,end_dir = 5},
			{ event = 'talk', delay= 0.8, handle_id = 2, talk='快跟上。', dur=1.5 },
			{ event = 'talk', delay= 0.8, handle_id = 3, talk='好。', dur=1.5 },
		},

	},

	['juqing152'] = {	

        --角色前置对白

	    {
	   		{ event='createActor', delay=0.1, handle_id=4, body=22, pos={1163,852}, dir=5, speed=340, name_color=0xffffff, name="尉迟峻", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=15, pos={1097,815}, dir=5, speed=340, name_color=0xffffff, name="小五", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=16, pos={1228,882}, dir=5, speed=340, name_color=0xffffff, name="小六", },

	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1097,my = 700 }, 	 
	    },

	    --三人被火鸢追赶
		{ 	{ event ='camera', delay = 0.5, sdur=0.5, dur = 3, c_topox = {655,1001}, style = '',backtime=1},
			-- { event ='camera', delay = 0.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
			{ event = 'move', delay = 0.1,handle_id=4, dir = 1, pos = {655,1101},speed = 280, dur = 2 ,end_dir = 5},	--坐标34，13
			{ event = 'move', delay = 0.1,handle_id=5, dir = 1, pos = {592,1070},speed = 280, dur = 2 ,end_dir = 5},	--坐标35，12
			{ event = 'move', delay = 0.1,handle_id=6, dir = 1, pos = {721,1134},speed = 280, dur = 2 ,end_dir = 5},	--坐标33，14
			{ event = 'talk', delay= 0.5, handle_id = 5, talk='有鬼啊！', dur=2 },
			{ event = 'talk', delay= 0.5, handle_id = 6, talk='这闹鬼啊！', dur=2 },

			-- { event='createActor', delay=1.8, handle_id=7, body=40, pos={1224,786}, dir=1, speed=220, name_color=0xffffff, name="", },	--创建火鸢
			{ event="createSpEntity", delay=1.8,handle_id=7, name="60",name_color=0xffffff, actor_name="机关鸢",  dir=5, pos={1224,786}},	 
			-- { event ='camera', delay = 2, target_id= 7, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
			{ event = 'move', delay = 2,handle_id=7, dir = 1, pos = {655,1101},speed = 70, dur = 1.5 ,end_dir = 5},

			{ event = 'playAction', handle_id= 4, delay = 2.8, action_id = 4, dur = 0.1, dir = 1,loop = false ,once = true},
			{ event = 'playAction', handle_id= 5, delay = 2.8, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
			{ event = 'playAction', handle_id= 6, delay = 2.8, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
			-- { event = 'effect', handle_id=101, delay = 3.8, target_id = 4, pos = {0,40}, layer = 2, effect_id = 20015, dx = 0,dy = 30,is_forever = false}, -- 被撞击特效
			-- { event = 'effect', handle_id=102, delay = 3.6, target_id = 5, pos = {0,40}, layer = 2, effect_id = 20015, dx = 0,dy = 30,is_forever = false}, -- 被撞击特效
			-- { event = 'effect', handle_id=103, delay = 3.6, target_id = 6, pos = {0,40}, layer = 2, effect_id = 20015, dx = 0,dy = 30,is_forever = false}, -- 被撞击特效

			{ event = 'talk', delay= 2.8, handle_id = 4, talk='啊…', dur=2 },
			{ event = 'talk', delay= 2.8, handle_id = 6, talk='哎哟…[a]', dur=2 ,emote = {a= 33}},
			{ event = 'talk', delay= 2.8, handle_id = 5, talk='疼疼…[a]', dur=2 ,emote = {a= 46}},


			-- { event ='camera', delay = 3.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},

			{ event = 'move', delay = 3,handle_id=7, dir = 1, pos = {1224,786},speed = 100, dur = 1.5 ,end_dir = 7},
			{ event = 'kill', delay = 4,handle_id=7, dur = 1 },
		},

		--神秘的前置对白
		{
			
			{ event='showTopTalk', delay=0.5, dialog_id="1_4_1" ,dialog_time = 2},
			
			{ event = 'move', delay = 0.8,handle_id=4, dir = 1, pos = {639,1141},speed = 340, dur = 2 ,end_dir = 1},	
			{ event = 'move', delay = 0.8,handle_id=5, dir = 1, pos = {561,1168},speed = 340, dur = 2 ,end_dir = 1},
			{ event = 'move', delay = 0.8,handle_id=6, dir = 1, pos = {616,1197},speed = 280, dur = 2 ,end_dir = 1},

			{ event = 'talk', delay= 0.8, handle_id = 4, talk='[a]', dur=1.5 ,emote = {a= 41} },
			{ event = 'talk', delay= 0.8, handle_id = 6, talk='[a]', dur=1.5 ,emote = {a= 41}},
			{ event = 'talk', delay= 0.8, handle_id = 5, talk='[a]', dur=1.5 ,emote = {a= 41}},
		},

		--尉迟峻投降
		{
			{ event = 'talk', delay= 0.3, handle_id = 4, talk='我认栽了！请出来相见吧！', dur=2.5 },
		},

		--阴丽华、邓奉和阴兴出现
		{
			{ event='createActor', delay=0.1, handle_id=1, body=6, pos={1163,852},dir=5, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=20, pos={1097,815},dir=5, speed=340, name_color=0xffffff, name="阴兴", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=29, pos={1228,882},dir=5, speed=340, name_color=0xffffff, name="邓奉", },


	   		{ event = 'talk', delay= 0.1, handle_id = 6, talk='[a]', dur=1.5 ,emote = {a= 33}},
			{ event = 'talk', delay= 0.1, handle_id = 5, talk='[a]', dur=1.5 ,emote = {a= 33}},
	   		{ event ='camera', delay = 0.5, sdur=0.5, dur = 0.5, c_topox = {729+50,1000}, style = '',backtime=1},

			{ event = 'move', delay = 0.5,handle_id=1, dir = 1, pos = {792,1046}, speed = 340, dur = 1.5 ,end_dir = 5},	
			{ event = 'move', delay = 0.5,handle_id=2, dir = 1, pos = {725,1006}, speed = 340, dur = 1.5 ,end_dir = 5},
			{ event = 'move', delay = 0.5,handle_id=3, dir = 1, pos = {852,1072}, speed = 340, dur = 1.5 ,end_dir = 5},

			{ event = 'talk', delay= 2, handle_id = 4, talk='你们要打要杀冲我来，放了他们。', dur=2.5 },
			{ event = 'talk', delay= 4.8, handle_id = 1, talk='你倒是讲义气。[a]', dur=2 ,emote = {a= 29}},

		},

		--尉迟峻与阴丽华对话
		{
			{ event = 'talk', delay= 0.1, handle_id = 4, talk='姑娘要我的命，尽管拿去便是。', dur=2 },
			{ event = 'talk', delay= 2.3, handle_id = 1, talk='那你就留下来赎罪，给我阴家卖命罢。', dur=2.5 },
			{ event = 'talk', delay= 5.1, handle_id = 1, talk='兴儿，给这些少年点钱粮，放他们离开。', dur=2.5 },
			{ event = 'talk', delay= 3.5, handle_id = 4, talk='[a]', dur=2 ,emote = {a= 25}},
		},

	    --阴丽华回房，阴兴抓狂
		{
			--阴丽华转身，说话
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {792,1046},speed = 340, dur = 1 ,end_dir = 1},	 
			{ event = 'talk', delay= 0.8, handle_id = 1, talk='兴儿暂代家主之位，这麻烦事儿就交给兴儿处理吧。', dur=2.5 },
			{ event = 'talk', delay= 3.5, handle_id = 1, talk='就这样，姐姐困了，回房睡了。', dur=2 },
			{ event = 'move', delay = 3.5,handle_id=1, dir = 1, pos = {1654,752},speed = 360, dur = 1 ,end_dir = 3},
			{ event = 'kill', delay = 6,handle_id=1, dur = 0.1 },
			

			--阴兴转身，邓奉坏笑
			{ event = 'move', delay = 3.8,handle_id=2, dir = 1, pos = {725,1006},speed = 340, dur = 1 ,end_dir = 1},	--阴兴邓奉转生看着丽华
			{ event = 'move', delay = 3.8,handle_id=3, dir = 1, pos = {852,1072},speed = 340, dur = 1 ,end_dir = 1},	 
			{ event = 'talk', delay= 3.8, handle_id = 2, talk='这……你们！哎……[a]', dur=2 ,emote = {a= 28}},	
			{ event = 'talk', delay= 3.8, handle_id = 3, talk='[a]', dur=2 ,emote = {a= 2}},
		},

	},

	--============================================wuwenbin  剧情副本第一章第五节 end    =====================================----

	--============================================luyao  剧情副本第一章第六节 start  =====================================----
	['juqing161'] = {	

        --1丽华 2邓婵
        --丽华去找刘秀被邓晨撞见，以为刘秀被抓走。
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 3315,my = 1764 }, 	

	    },        
	    {

	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={3291,1778}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=23, pos={3141,2036}, dir=1, speed=340, name_color=0xffffff, name="邓晨", },

			{ event = 'move', delay = 0.5,handle_id=2, dir = 1, pos = {3457,1820},speed = 340, dur = 1 ,end_dir = 7},

	   		{ event = 'talk', delay= 2.1, handle_id = 2, talk='阴……姬？！你怎么来了？是为了文叔吗？', dur=2 },
			{ event = 'move', delay = 4.5,handle_id=1, dir = 1, pos = {3291,1778},speed = 340, dur = 1 ,end_dir = 3},	   		
	   		{ event = 'talk', delay= 5, handle_id = 1, talk='啊，不是……我是来看表姐的，表兄怎么也来了？', dur=1.8 },

	   		{ event = 'talk', delay= 8, handle_id = 2, talk='宛城李家原本与伯升有仇，听说他们正在找文叔。', dur=1.8 },
	   		{ event = 'talk', delay= 10, handle_id = 2, talk='我怕文叔有事，就赶过来看看。', dur=1.8 },

	   	},

	   	{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {3291,1778},speed = 340, dur = 1 ,end_dir = 7},
	   		{ event = 'talk', delay= 0.5, handle_id = 1, talk='[a]糟了！文叔被李轶带走了……',emote={a=39}, dur=1.8 },
		
			{ event = 'move', delay = 1,handle_id=1, dir = 1, pos = {3291,1778},speed = 340, dur = 1 ,end_dir = 3},	
	   		{ event = 'talk', delay= 2.5, handle_id = 2, talk='[a]快去李家！',emote={a=28}, dur=1.8 },		

			{ event = 'move', delay = 3.5,handle_id=1, dir = 7, pos = {3251,1494},speed = 340, dur = 1 ,end_dir = 7},	

			{ event = 'move', delay = 4,handle_id=2, dir = 7, pos = {3407,1506},speed = 340, dur = 1 ,end_dir = 7},			   						
	   	},

	   	{
	   		{ event='kill', delay=0.1, handle_id=1},
	   		{ event='kill', delay=0.1, handle_id=2},
	   	},s

	},

	['juqing162'] = {	
	--1阴丽华 2李轶 3李通 4刘秀
	--丽华误会李轶，强行带走刘秀。
	    {
	   		{ event='init_cimera', delay = 0.1,mx= 3316,my = 550 }, 

	   		{ event='createActor', delay=0.1, handle_id=2, body=48, pos={3257,584}, dir=3, speed=340, name_color=0xffffff, name="李轶", },

	   		{ event = 'playAction', handle_id= 2, delay = 0.2, action_id = 4, dur = 0.1, dir = 2,loop = false ,once = true}, 

	   		{ event='createActor', delay=0.1, handle_id=3, body=30, pos={3433,530}, dir=5, speed=340, name_color=0xffffff, name="李通", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=13, pos={3519,578}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },

	   		{ event = 'talk', delay= 1.2, handle_id = 3, talk='！！！', dur=2 },	
	   		{ event = 'talk', delay= 1.2, handle_id = 4, talk='！！！', dur=2 },		   			   		
	   		{ event = 'talk', delay= 0.2, handle_id = 2, talk='[a]',emote={a=4}, dur=6 },

	   		{ event='createActor', delay=1.1, handle_id=1, body=6, pos={3431,771}, dir=1, speed=340, name_color=0xffffff, name="阴丽华", },	   		
			{ event = 'move', delay = 1.5,handle_id=1, dir = 1, pos = {3480,646},speed = 340, dur = 1 ,end_dir = 1},	

	   		{ event = 'talk', delay= 2.1, handle_id = 1, talk='三哥，快走！', dur=1.8 },

	   		{ event = 'talk', delay= 4.1, handle_id = 4, talk='你怎么来了？', dur=1.8 },

	   		{ event = 'talk', delay= 6.1, handle_id = 1, talk='来救你啊！', dur=1.8 },		   			   		
	   	},
	   	{

	   		{ event='createActor', delay=0.1, handle_id=5, body=19, pos={2966,398}, dir=3, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=20, pos={3080,363}, dir=3, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=19, pos={3201,392}, dir=3, speed=340, name_color=0xffffff, name="门客", },
			{ event = 'move', delay = 0.2,handle_id=5, dir = 1, pos = {3218,620},speed = 340, dur = 1 ,end_dir = 3},	   		
			{ event = 'move', delay = 0.3,handle_id=6, dir = 1, pos = {3292,571},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.4,handle_id=7, dir = 1, pos = {3344,499},speed = 340, dur = 1 ,end_dir = 3},

	   		{ event = 'talk', delay= 0.5, handle_id = 6, talk='抓住他们。', dur=1.8 },	
	   		{ event = 'talk', delay= 2.5, handle_id = 1, talk='快走！', dur=1.8 },

			{ event = 'move', delay = 2.6,handle_id=1, dir = 1, pos = {3197,893},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 2.8,handle_id=4, dir = 1, pos = {3383,881},speed = 340, dur = 1 ,end_dir = 5},

	   		{ event='kill', delay=3.8, handle_id=1},
	   		{ event='kill', delay=3.8, handle_id=4},

			{ event = 'move', delay = 3.5,handle_id=5, dir = 1, pos = {3282,1068},speed = 340, dur = 1 ,end_dir = 3},	   		
			{ event = 'move', delay = 3.6,handle_id=6, dir = 1, pos = {3282,1068},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 3.8,handle_id=7, dir = 1, pos = {3282,1068},speed = 340, dur = 1 ,end_dir = 3},	

	   		{ event = 'talk', delay= 3.5, handle_id = 5, talk='给我追！', dur=1.8 },	
	   		{ event = 'talk', delay= 3.6, handle_id = 6, talk='站住！', dur=1.8 },	
	   		{ event = 'talk', delay= 4, handle_id = 7, talk='别跑！', dur=1.8 },	

	   		{ event='kill', delay=5.8, handle_id=5},
	   		{ event='kill', delay=5.8, handle_id=6},
	   		{ event='kill', delay=5.8, handle_id=7},

	   	},


	},
	--============================================luyao  剧情副本第一章第六节 end    =====================================----

	--============================================lixin  剧情副本第二章第第二节 start    ===================================----
	--演员表 1-阴丽华 2-刘稷  3~8-刘家子弟 9~14刘家门客
	['juqing211'] = {
		{
			{ event='playBgMusic', delay=0.1, id = 1 ,loop = true},
		},
        --创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={1099,590}, dir=5, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=20, pos={311,536}, dir=3, speed=340, name_color=0xffffff, name="刘稷", },

	   		{ event='createActor', delay=0.1, handle_id=3, body=7, pos={291+20,676}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=7, pos={365+20,633}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=7, pos={366+20,751}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=7, pos={441+20,708}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=7, pos={441+20,826}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=7, pos={536+20,783}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },

	   		{ event='createActor', delay=0.1, handle_id=9,  body=29, pos={440+20,590}, dir=7, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=29, pos={515+20,547}, dir=7, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=11, body=29, pos={516+20,665}, dir=7, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=29, pos={591+20,622}, dir=7, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=29, pos={631+20,740}, dir=7, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=29, pos={724+20,697}, dir=7, speed=340, name_color=0xffffff, name="刘家门客", },
	   	},	

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1074,my = 975 }, 	 
	    },
	    --等怪物刷出来再移动镜头
	    {
	    	{ event ='camera', delay = 0.5, sdur=0.5, dur = 1, c_topox = {435-180,591}, style = '',backtime=1},
	    },
	    --嚯！
	   	{
	   		{ event = 'talk', delay= 0.5,   handle_id = 2,  talk='1——', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 3,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 4,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 5,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 6,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 7,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 8,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 9,  talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 10, talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 11, talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 12, talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 13, talk='嚯！', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 14, talk='嚯！', dur=1.5 },

	   		{ event = 'playAction', delay = 2.5, handle_id= 3,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 4,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 5,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 6,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 7,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 8,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 9,  action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 10, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 11, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 12, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 13, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2.5, handle_id= 14, action_id = 2, dur = 1, dir = 7,loop = false },
	   	},  
	   	--哈！
	   	{
	   		{ event = 'talk', delay= 0.1, handle_id = 2, talk='2——', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 3, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 4, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 5, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 6, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 7, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 8, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 9, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 10, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 11, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 12, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 13, talk='哈！', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 14, talk='哈！', dur=1.5 },

	   		{ event = 'playAction', delay = 2, handle_id= 3, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2, handle_id= 4, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2, handle_id= 5, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2, handle_id= 6, action_id = 2, dur = 1, dir = 7,loop = false },
	   		{ event = 'playAction', delay = 2, handle_id= 7, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 8, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 9, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 10, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 11, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 12, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 13, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   		{ event = 'playAction', delay = 2, handle_id= 14, action_id = 2, dur = 1, dir = 7,loop = false ,},
	   	},  

	   	--刘冀跑过来
		{
			{ event ='camera', delay = 0.1, sdur=0.5, dur = 0.5, c_topox = {1099,590}, style = '',backtime=1},
			{ event = 'talk', delay= 1, handle_id = 1, talk='哎……[a]', dur=1.5,emote={a=29}},
			{ event = 'move', delay = 0.3,handle_id=2, dir = 1, pos = {950,650},speed = 300, dur = 3 ,end_dir = 1}, 

	   		{ event = 'move',  delay=1.3, handle_id=3,  pos={291+20,676}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=4,  pos={365+20,633}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=5,  pos={366+20,751}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=6,  pos={441+20,708}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=7,  pos={441+20,826}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=8,  pos={536+20,783}, dir=7, speed=340, dur = 1 ,end_dir = 2},

	   		{ event = 'move',  delay=1.3, handle_id=9,  pos={440+20,590}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=10, pos={515+20,547}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=11, pos={516+20,665}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=12, pos={591+20,622}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=13, pos={631+20,740}, dir=7, speed=340, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=1.3, handle_id=14, pos={724+20,697}, dir=7, speed=340, dur = 1 ,end_dir = 2},			
		},

		--BB开始
		{
			{ event = 'talk', delay= 0.1, handle_id = 2, talk='阴兄弟，怎不练武？要不要我教你两招？', dur=1.5},	
			{ event = 'talk', delay= 1.7, handle_id = 1, talk='稷哥，勿怪小弟直言……', dur=1.5},	
			{ event = 'talk', delay= 3.4, handle_id = 1, talk='咱们除了练武，还得练习如何排兵布阵', dur=1.5},	
			{ event = 'talk', delay= 5.1, handle_id = 2, talk='[a]哼！我是不懂啥兵法，要想我服你？', dur=1.5,emote={a=40}},
			{ event = 'talk', delay= 6.8, handle_id = 2, talk='咱比试比试，你赢了，就听你的！', dur=1.5},

			{ event = 'move',  delay=7.3, handle_id=12,  pos={798-32,529-32}, dir=7, speed=300, dur = 1 ,end_dir = 3},
	   		{ event = 'move',  delay=7.3, handle_id=13,  pos={914,538}, dir=7, speed=300, dur = 1 ,end_dir = 3},
	   		{ event = 'move',  delay=7.3, handle_id=14,  pos={752-32,587}, dir=7, speed=300, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=7.3, handle_id=6,  pos={838-32,583}, dir=7, speed=300, dur = 1 ,end_dir = 2},
	   		{ event = 'move',  delay=7.3, handle_id=7,  pos={764-32,687+32}, dir=7, speed=300, dur = 1 ,end_dir = 1},
	   		{ event = 'move',  delay=7.3, handle_id=8,  pos={821,662}, dir=7, speed=300, dur = 1 ,end_dir = 1},
	   		{ event = 'move',  delay=7.3, handle_id=11,  pos={857,715}, dir=7, speed=300, dur = 1 ,end_dir = 1},

		},
		--继续BB
		{
			{ event = 'talk', delay= 1, handle_id = 1, talk='不必了，小弟武艺平平，不是稷哥的对手……', dur=1.5},	
			{ event = 'talk', delay= 2.7, handle_id = 2, talk='[a]武技平平，还敢来教训我，先教你两招。', dur=1.5,emote={a=24}},

	   		{ event = 'talk', delay= 4.4, handle_id = 6, talk='教训他！', dur=1.5 },
	   		{ event = 'talk', delay= 4.4, handle_id = 11, talk='打他！', dur=1.5 },
	   		{ event = 'talk', delay= 4.4, handle_id = 13, talk='给他点颜色瞧瞧！', dur=1.5 },
		},
	    {
	      { event='backSceneMusic', delay = 0}, 
	    },
	},

	['juqing212'] = {
		--创建角色
		{
			{ event='createActor', delay=0.1, handle_id=1, body=5, pos={1099,590}, dir=5, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=20, pos={950,650}, dir=1, speed=340, name_color=0xffffff, name="刘稷", },

	   		{ event='createActor', delay=0.1, handle_id=6, body=7, pos={806,583}, dir=2, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=7, pos={732,719}, dir=1, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=7, pos={821,662}, dir=1, speed=340, name_color=0xffffff, name="刘家子弟", },

	   		{ event='createActor', delay=0.1, handle_id=11, body=29, pos={857,715}, dir=1, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=29, pos={766,497}, dir=3, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=29, pos={914,538}, dir=3, speed=340, name_color=0xffffff, name="刘家门客", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=29, pos={720,587}, dir=2, speed=340, name_color=0xffffff, name="刘家门客", },
		},
		--定镜头
		{
	   		{ event='init_cimera', delay = 0.1,mx= 1099,my = 590 }, 	 
	    },	

	    --开始BB
	    {
			{ event = 'talk', delay= 1, handle_id = 2, talk='阴兄弟，我服了！', dur=1.5},
			{ event = 'talk', delay= 2.7,   handle_id = 1, talk='我就是个巧劲，论武技力道远不如稷哥，还望你多指教小弟。', dur=2},
			{ event = 'talk', delay= 4.9, handle_id = 2, talk='兄弟客气了，往后你教咱练兵，我教你武技。', dur=1.5},
			{ event = 'talk', delay= 6.6, handle_id = 2, talk='来日上阵杀敌，生死与共。', dur=1.5},
			{ event = 'talk', delay= 8.2, handle_id = 1, talk='生死与共！', dur=1.5},

	   		{ event = 'talk', delay= 9.9, handle_id = 6, talk='说的对！', dur=1.5 },
	   		{ event = 'talk', delay= 9.9, handle_id = 11, talk='说的对！', dur=1.5 },
	   		{ event = 'talk', delay= 9.9, handle_id = 13, talk='说的对！', dur=1.5 },	

	   		{ event = 'talk', delay= 11.6, handle_id = 8, talk='生死与共！', dur=1.5 },
	   		{ event = 'talk', delay= 11.6, handle_id = 7, talk='生死与共！', dur=1.5 },
	   		{ event = 'talk', delay= 11.6, handle_id = 14, talk='生死与共！', dur=1.5 },		    	
	    },

	},
	--============================================lixin  剧情副本第二章第第二节 end    =====================================----

	--============================================lixin  剧情副本第二章第第二节 start    ====================================----
	--演员表  1-刘縯  2阴戟   3-刘秀  4-刘良  5-刘氏宗亲   6-刘氏宗亲  7-刘稷
	['juqing221'] = 
	{	

		{
			{ event='playBgMusic', delay=0.1, id = 1 ,loop = true},
		},
        --创建角色

	    {
	   		{ event='createActor', delay=0.1, handle_id=3, body=13, pos={815,2286}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={881,2386}, dir=2, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=5, pos={1105,2290}, dir=3, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=20, pos={1232,2321}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=23, pos={498,2321}, dir=2, speed=340, name_color=0xffffff, name="刘良", },
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 944+150,my = 2300 }, 	 
	    },
	    --刘演跑，刘良追
	    {

	   		{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {1200,2385},speed = 300, dur = 1 ,end_dir = 2}, 
	   		{ event = 'talk', delay= 0.1, handle_id = 1, talk='我找地方躲会儿。', dur=1.5 },

	   		{ event = 'move', delay = 1,handle_id=7, dir = 1, pos = {1232,2321},speed = 300, dur = 1 ,end_dir = 5}, 
	   		{ event = 'move', delay = 1,handle_id=2, dir = 1, pos = {1105,2290},speed = 300, dur = 1 ,end_dir = 5}, 
	   		{ event = 'talk', delay= 1, handle_id = 2, talk='？？？', dur=1.5 },

	   		{ event = 'move', delay = 1,handle_id=4, dir = 2, pos = {944,2387},speed = 340, dur = 1 ,end_dir = 2}, 
	   		{ event = 'talk', delay= 1.5, handle_id = 4, talk='刘伯升，你个忤逆的不肖子！', dur=2 },

	   		{ event = 'talk', delay= 1.8, handle_id = 1, talk='(坏了)', dur=1.5 },
	   		{ event = 'move', delay = 3,handle_id=1, dir = 1, pos = {1038+32,2382},speed = 400, dur = 1 ,end_dir = 6}, 
	   		-- { event = 'talk', delay= 3.5, handle_id = 1, talk='哈哈……(ㆀ^·^)', dur=1.5},
	   		{ event = 'talk', delay= 3.5, handle_id = 1, talk='[a]哈哈……', dur=1.5,emote={a=30}},
	    },
		--刘演被训
		{
			{ event = 'talk', delay= 0.1, handle_id = 1, talk='叔父，您怎么来了？', dur=1.5 },
			{ event = 'talk', delay= 1.8, handle_id = 4, talk='哼[a]', dur=1.5,emote = {a = 32} },
			{ event = 'talk', delay= 3.5, handle_id = 4, talk='再不来，咱刘家就让你给祸害了！刘家出了你这小畜生，简直就是家门不幸！', dur=3 },
			{ event = 'playAction', delay = 6.6, handle_id= 4, action_id = 2, dur = 1, dir = 2,loop = false },
			{ event = 'talk', delay= 6.7, handle_id = 4, talk='我，我，替你老子打死你……', dur=1.5 },
			{ event = 'playAction', delay = 7.2, handle_id= 1, action_id = 3, dur = 1, dir = 6,loop = false },
			{ event = 'talk', delay= 7.2, handle_id = 1, talk='啊！！', dur=1 },
		},	
		--大家转圈跑
		{
			{ event ='camera', delay = 0.1, target_id= 1, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
			{ event = 'move', delay = 0,handle_id=1, dir = 1, pos = {1038+320,2382},speed = 300, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.5,handle_id=4, dir = 1, pos = {944+320,2387},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'talk', delay= 0.5, handle_id = 1, talk='叔父，别打了……', dur=1 },
	   		{ event = 'talk', delay= 1.7, handle_id = 1, talk='哎哟……疼……', dur=1 },
	   		{ event = 'talk', delay= 0.5, handle_id = 4, talk='站住！我叫你跑！', dur=1.5 },		
			{ event = 'talk', delay= 2.2, handle_id = 4, talk='我打死你这小畜生！', dur=1.5 },
			{ event = 'move', delay = 2,handle_id=1, dir = 1, pos = {1295,2500},speed = 340, dur = 1 ,end_dir = 6}, 
			{ event = 'move', delay = 3,handle_id=1, dir = 1, pos = {659,2547},speed = 340, dur = 1 ,end_dir = 6}, 

			{ event = 'move', delay = 2.5,handle_id=4, dir = 1, pos = {1295,2500},speed = 340, dur = 2 ,end_dir = 6}, 
			{ event = 'move', delay = 3.5,handle_id=4, dir = 1, pos = {659,2547},speed = 340, dur = 2 ,end_dir = 6}, 

	   		{ event = 'move', delay = 2.9,handle_id=3, dir = 1, pos = {1041,2482},speed = 360, dur = 2 ,end_dir = 6}, --刘秀加入队伍
	   		{ event = 'move', delay = 5,handle_id=3, dir = 1, pos = {659,2547},speed = 360, dur = 1 ,end_dir = 6}, 
	   		{ event = 'talk', delay= 2.5, handle_id = 3, talk='叔父您先别生气……', dur=2 },

		},

		--阴戟和刘稷BB
		{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {242,2642},speed = 300, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=4, dir = 1, pos = {242,2642},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=3, dir = 1, pos = {242,2642},speed = 340, dur = 1 ,end_dir = 3}, 
	  		{ event='kill', delay=0.5, handle_id=1},
	   		{ event='kill', delay=0.5, handle_id=3},
	   		{ event='kill', delay=0.5, handle_id=4},

	   		{ event = 'move', delay = 0.5,handle_id=7, dir = 1, pos = {1232,2321},speed = 300, dur = 1 ,end_dir = 7}, 
	   		{ event = 'move', delay = 0.5,handle_id=2, dir = 1, pos = {1105,2290},speed = 300, dur = 1 ,end_dir = 3}, 
			{ event ='camera', delay = 0.2, sdur=0.5, dur = 0.5, c_topox = {1107,2230}, style = '',backtime=1},
			{ event = 'talk', delay= 1, handle_id = 2, talk='[a][a][a][a]这老爷子是谁呀，大哥三哥这么怕他？', dur=2,emote = {a = 14} },
			{ event = 'talk', delay= 3.3, handle_id = 7, talk='二叔刘良。', dur=1.5},
			{ event = 'talk', delay= 5, handle_id = 7, talk='大哥的爹去世后，一家子多亏叔父照看，这就是个‘爹’。', dur=2},
		},

		{
	      { event='backSceneMusic', delay = 0}, 
	    },
	},

	--演员表  1-刘縯  2阴戟   3-刘秀  4-刘良  5-刘氏宗亲   6-刘氏宗亲  7-刘稷   特效 101 眩晕特效
	['juqing222'] = {

		--创建角色
		{
			{ event='createActor', delay=0.1, handle_id=3, body=13, pos={910,1746}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={1139,1906}, dir=6, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=5, pos={1200,1776}, dir=3, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=20, pos={1328,1809}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=23, pos={1456,1906}, dir=6, speed=340, name_color=0xffffff, name="刘良", },
		},

		--定位镜头
		{
	   		{ event='init_cimera', delay = 0.1,mx= 1007,my = 1800 }, 	 
	    },

	    --刘良还在打刘演 = = 有恒心的老头啊
	    {
	    	{ event = 'move', delay = 1,handle_id=2, dir = 1, pos = {1200,1776},speed = 300, dur = 1 ,end_dir = 5},	
	    	{ event = 'move', delay = 1,handle_id=7, dir = 1, pos = {1328,1809},speed = 300, dur = 1 ,end_dir = 5},

	    	{ event = 'move', delay = 0.5,handle_id=1, dir = 1, pos = {1139-288,1906},speed = 300, dur = 1 ,end_dir = 6},	
	    	{ event = 'move', delay = 0.5,handle_id=4, dir = 1, pos = {1456-288,1906},speed = 300, dur = 1 ,end_dir = 6},
	    	{ event = 'talk', delay= 1, handle_id = 4, talk='我……我打死你这臭小子！', dur=1.5},	

	    	{ event = 'move', delay = 1,handle_id=3, dir = 1, pos = {1033,1900},speed = 300, dur = 1 ,end_dir = 2},
	    },

	    {
	    	{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {1139-288,1906},speed = 300, dur = 1 ,end_dir = 2},
	    	{ event = 'talk', delay= 0.1, handle_id = 3, talk='叔父——！你先听我们解释。', dur=1.5},
	    	{ event = 'talk', delay= 1.8, handle_id = 4, talk='当年东郡翟义刘信的前车之鉴你们都忘了？', dur=2},
	    	{ event = 'talk', delay= 4.1, handle_id = 3, talk='您知道秀从不做无把握之事。叔父，我们已经不能回头了。', dur=2.5},
	    	{ event = 'talk', delay= 6.9, handle_id = 4, talk='起义闹事才是不能回头！你们这是要把刘家全族拖进火坑里！', dur=3},
	    	{ event = 'talk', delay= 10.2, handle_id = 1, talk='事已至此，与其为莽贼所灭，不如揭竿而起，跟莽贼拼了。', dur=2.5},
	    	{ event = 'move', delay = 10.2,handle_id = 1, dir = 1, pos = {1139-200,1906},speed = 200, dur = 1 ,end_dir = 2},
	    },

	   --一言不合刘良就镖车了
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 4, talk='好，你们不愿回头！我让你们回头！', dur=1.8},
	    	{ event = 'move', delay = 1,handle_id=4, dir = 1, pos = {1456-200,1906},speed = 400, dur = 1 ,end_dir = 2},	--刘良走
	    	{ event = 'move', delay = 1.5,handle_id=3, dir = 1, pos = {1456-296,1906},speed = 200, dur = 1 ,end_dir = 2},	--刘秀追
	    	{ event = 'talk', delay= 2, handle_id = 3, talk='这……叔父你要去哪？', dur=1.5},
	    	{ event = 'move', delay = 2.5,handle_id=4, dir = 1, pos = {1456-200,1906},speed = 300, dur = 1 ,end_dir = 6},	--刘良回头
	    	{ event = 'talk', delay= 3.5, handle_id = 4, talk='我这就去找老友严尤将军！', dur=1.5},
	    },

	    --可不能让你去！
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='0.0', dur=1.5},
	    	{ event = 'talk', delay= 0.1, handle_id = 2, talk='0.0', dur=1.5},
	    	{ event = 'talk', delay= 0.1, handle_id = 3, talk='0.0', dur=1.5},
	    	{ event = 'talk', delay= 0.1, handle_id = 7, talk='0.0', dur=1.5},
	    	-- { event = 'move', delay = 1,handle_id=2, dir = 1, pos = {1388,2003},speed = 200, dur = 1 ,end_dir = 5},	
	    	-- { event = 'move', delay = 1,handle_id=7, dir = 1, pos = {1456,1906},speed = 200, dur = 1 ,end_dir = 6},	
	    	-- { event = 'move', delay = 1,handle_id=1, dir = 1, pos = {1458,1968},speed = 200, dur = 1 ,end_dir = 7},	
	    	-- { event = 'move', delay = 1,handle_id=3, dir = 1, pos = {1393,2002},speed = 200, dur = 1 ,end_dir = 7},	
	    	{ event ='camera', delay = 1.5, sdur=0.5, dur = 0.5, c_topox = {1552,1890}, style = '',backtime=1},
	    	{ event = 'move', delay = 1,handle_id=4, dir = 1, pos = {1456-200,1906},speed = 400, dur = 1 ,end_dir = 2},
	    	{ event = 'jump', delay= 1.2, handle_id= 2, pos={1393,1842}, speed=200, dur=1, dir = 3, end_dir=5 },
	    	{ event = 'jump', delay= 1.2, handle_id= 7, pos={1456,1906}, speed=200, dur=1, dir = 3, end_dir=6 },
	    	{ event = 'jump', delay= 1.2, handle_id= 1, pos={1458,1968}, speed=200, dur=1, dir = 6, end_dir=7 },
	    	{ event = 'jump', delay= 1.2, handle_id= 3, pos={1393,2002}, speed=200, dur=1, dir = 3, end_dir=7 },
	    },

	    --开始BB
	    {
	    	{ event = 'move', delay = 1,handle_id=2, dir = 1, pos = {1393,1842},speed = 200, dur = 1 ,end_dir = 5},	
	    	{ event = 'move', delay = 1,handle_id=7, dir = 1, pos = {1456,1906},speed = 200, dur = 1 ,end_dir = 6},	
	    	{ event = 'move', delay = 1,handle_id=1, dir = 1, pos = {1458,1968},speed = 200, dur = 1 ,end_dir = 7},	
	    	{ event = 'move', delay = 1,handle_id=3, dir = 1, pos = {1393,2002},speed = 200, dur = 1 ,end_dir = 7},

	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='不能去。', dur=1.5},
	    	{ event = 'talk', delay= 1.7, handle_id = 4, talk='[a]怎么？！养你们大了，还敢朝我动手不成？！', dur=1.8,emote={a=24}},
	    	{ event = 'move', delay = 3.2,handle_id=2, dir = 1, pos = {1393+64,1842},speed = 300, dur = 1 ,end_dir = 5},	
	    	{ event = 'move', delay = 3.2,handle_id=7, dir = 1, pos = {1456+64,1906},speed = 300, dur = 1 ,end_dir = 6},	
	    	{ event = 'move', delay = 3.2,handle_id=1, dir = 1, pos = {1458+64,1968},speed = 300, dur = 1 ,end_dir = 7},	
	    	{ event = 'move', delay = 3.2,handle_id=3, dir = 1, pos = {1393+64,2002},speed = 300, dur = 1 ,end_dir = 7},

	    	{ event = 'talk', delay= 3.6, handle_id = 4, talk='哼！', dur=1.5},
	    	{ event = 'move', delay = 3.5,handle_id=4, dir = 1, pos = {1456-70,1906},speed = 450, dur = 1 ,end_dir = 2},	    	
	    },

	    --阴戟出手
	    {
	    	{ event = 'move', delay = 0,handle_id=2, dir = 1, pos = {1336,1988},speed = 100, dur = 1 ,end_dir = 1},
	    	{ event = 'playAction', handle_id= 4, delay = 0.5, action_id = 3, dur = 1.8, dir = 6,loop = false ,},
	    	{ event = 'playAction', handle_id= 4, delay = 1, action_id = 4, dur = 1.8, dir = 6,loop = false ,once=true},
	    	{ event = 'talk', delay= 0.5, handle_id = 4, talk='啊——', dur=1.5},
	    	{ event = 'effect', handle_id=101, delay = 1.5, target_id = 4, pos = {-110,35}, layer = 2, effect_id = 10131,is_forever = true},
	    -- },

	    -- --0.0,阴戟下手重
	    -- {
	    	{ event = 'talk', delay= 1, handle_id = 1, talk='0.0', dur=1.5},
	    	{ event = 'talk', delay= 1, handle_id = 3, talk='0.0', dur=1.5},
	    	{ event = 'talk', delay= 1, handle_id = 7, talk='0.0', dur=1.5},
	
	    	{ event = 'move', delay = 1,handle_id=7, dir = 1, pos = {1456+32,1906},speed = 100, dur = 1 ,end_dir = 6},	
	    	{ event = 'move', delay = 1,handle_id=1, dir = 1, pos = {1458+32,1968},speed = 100, dur = 1 ,end_dir = 7},	
	    	{ event = 'move', delay = 1,handle_id=3, dir = 1, pos = {1393+32,2002},speed = 100, dur = 1 ,end_dir = 7},	    	

	    	{ event = 'talk', delay= 2.7, handle_id = 3, talk='你这也下手太重了……', dur=1.5},
	    	{ event = 'talk', delay= 4.4, handle_id = 2, talk='[a]你们是子侄不好动手，只好由我来了。没事，晕会就醒了。', dur=2.5,emote={a=8}},
	    },


	},
	--============================================lixin  剧情副本第二章第第二节 end    =====================================----

	--============================================luyao  剧情副本第二章第三节 start    =====================================----	
	['juqing231'] = {	

	   	{
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={1100,658}, dir=3, speed=340, name_color=0xffffff, name="丽华", },

 			--{ event = 'effect', handle_id=101, delay = 0.1, target_id = 1, pos = {}, layer = 2, effect_id = 20004, dx = 0,dy = 30,is_forever = true},

	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={936,1041}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },	 

	   		{ event='init_cimera', delay = 0.1,mx= 1310,my = 720 }, 

			{ event ='camera', delay = 1.5, target_id = 2, sdur=3.5, dur = 1,style = 'follow',backtime=1}, --移动镜头跟随

			{ event = 'move', delay = 2,handle_id=2, dir = 1, pos = {1358,983},speed = 300, dur = 1 ,end_dir = 3},	   		
	   		{ event = 'talk', delay= 3.6, handle_id = 2, talk='丽华——', dur=1.2 },


			{ event = 'move', delay = 5.7,handle_id=2, dir = 1, pos = {1575,801},speed = 300, dur = 1 ,end_dir = 1},
	   		{ event = 'talk', delay= 7, handle_id = 2, talk='丽华——', dur=1.2 },	
		},
		{
	    	{ event='showTopTalk', delay=0.1, dialog_id="2_3_1" ,dialog_time = 1.2},

	   		{ event ='camera', delay = 1, sdur=1.5, dur = 1.5, c_topox = {1267,660}, style = '',backtime=1},
			{ event = 'move', delay = 2.2,handle_id=2, dir = 1, pos = {1310,761},speed = 340, dur = 1 ,end_dir = 7},

	   	},
	    {

	   		{ event = 'talk', delay= 0.1, handle_id = 1, talk='你大嫂走了么？', dur=1.8 },
	   		{ event = 'talk', delay= 2.1, handle_id = 2, talk='走了，别担心……洗好了么？', dur=1.8 },
	   		{ event = 'talk', delay= 4.1, handle_id = 1, talk='好了……[a]三哥你先走远些。', emote={a=27},dur=1.8 },
	   		{ event = 'talk', delay= 6.1, handle_id = 2, talk='哦！', dur=1.8 },	   			   			   		
	   	},
	   	{
	   		{ event ='camera', delay = 0.6, sdur=1.5, dur = 1.5, c_topox = {1030,1022}, style = '',backtime=1},	   	
			{ event = 'move', delay = 0.2,handle_id=2, dir = 1, pos = {1030,1022},speed = 340, dur = 1 ,end_dir = 1},

	   		{ event = 'talk', delay= 0.3, handle_id = 2, talk='还好我替你望风，不然……', dur=1.5 },	

	    	{ event='showTopTalk', delay=1.2, dialog_id="2_3_2" ,dialog_time = 1.2},

	   		{ event = 'talk', delay= 3.2, handle_id = 2, talk='[a]怎么了？',emote={a=39}, dur=1.5 },

	    	{ event='showTopTalk', delay=5.2, dialog_id="2_3_3" ,dialog_time = 1.2},

	   		{ event = 'talk', delay= 7, handle_id = 2, talk='什么？！', dur=1.5 },	    	
	   	},
	   	{
	   		{ event='createActor', delay=0.1, handle_id=3, body=17, pos={1963,345}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=14, pos={2153,383}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=20, pos={2063,253}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=29, pos={2156,274}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=29, pos={2096,210}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },

			{ event = 'move', delay = 0.2,handle_id=3, dir = 1, pos = {1683,909},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 0.4,handle_id=4, dir = 1, pos = {1683,909},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 0.6,handle_id=5, dir = 1, pos = {1683,909},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 0.9,handle_id=6, dir = 1, pos = {1683,909},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 0.9,handle_id=7, dir = 1, pos = {1683,909},speed = 500, dur = 1 ,end_dir = 1},

			{ event ='camera', delay = 0.2, target_id = 3, sdur=0.2, dur =0.2,style = 'follow',backtime=1}, --移动镜头跟随

	   		{ event = 'talk', delay= 0.5, handle_id = 4, talk='真有奸细，你看清啦？！', dur=1.8 },
	   		{ event = 'talk', delay= 2.5, handle_id = 3, talk='对啊，从咱家后院出去的，躲在河边，我亲眼所见……', dur=2},





	   	},


	},

	['juqing232'] = {	


	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={1114,781}, dir=3, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={1225,855}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },	 
	   	},
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1200,my = 700 }, 	

	   		{ event = 'talk', delay= 1.5, handle_id = 1, talk='[a]让我知道谁偷了我衣服，非把他……[b]',emote={a=34,b=11}, dur=1.8 },
	   		{ event = 'talk', delay= 3.5, handle_id = 2, talk='[a]先别生气了，一会儿我们来个明修栈道，暗度陈仓……', emote={a=45},dur=1.8 },

	    	{ event='showTopTalk', delay=5.5, dialog_id="2_3_4" ,dialog_time = 3},
	    },
		{
	   		{ event='createActor', delay=0.1, handle_id=3, body=17, pos={1863,545}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=14, pos={2053,583}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=20, pos={1963,453}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=29, pos={2056,474}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=29, pos={1996,410}, dir=7, speed=340, name_color=0xffffff, name="刘家子弟", },

	   		{ event ='camera', delay = 0.2, sdur=0.5, dur = 0.5, c_topox = {1907,675}, style = '',backtime=1},	

			{ event = 'move', delay = 0.2,handle_id=3, dir = 1, pos = {1455,934},speed = 500, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.4,handle_id=4, dir = 1, pos = {1536,867},speed = 500, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.6,handle_id=5, dir = 1, pos = {1432,1005},speed = 500, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.9,handle_id=6, dir = 1, pos = {1516,996},speed = 500, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.9,handle_id=7, dir = 1, pos = {1598,951},speed = 500, dur = 1 ,end_dir = 7},

	   		{ event ='camera', delay = 2.2, sdur=0.5, dur = 0.5, c_topox = {1380,775}, style = '',backtime=1},	


	   		{ event = 'talk', delay= 2.5, handle_id = 1, talk='!', dur=1.8 },
	   		{ event = 'talk', delay= 2.5, handle_id = 2, talk='!', dur=1.8 },
	   		{ event = 'talk', delay= 3.5, handle_id = 1, talk='糟了！', dur=1.8 },
	   		{ event = 'talk', delay= 5, handle_id = 2, talk='别怕，跟我来。', dur=1.8 },

			{ event = 'move', delay = 6,handle_id=1, dir = 1, pos = {1250,890},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 6,handle_id=2, dir = 1, pos = {1349,826},speed = 340, dur = 1 ,end_dir = 3},

		},	    
	    {
	   		{ event = 'talk', delay= 0.1, handle_id = 2, talk='大哥，你们这是要去那儿？', dur=1.8 },
	   		{ event = 'talk', delay= 2, handle_id = 4, talk='[a]伯姬说，溪边有行迹鬼祟之人，可能是奸细。', emote={a=39},dur=1.8 },
	   		{ event = 'talk', delay= 4, handle_id = 2, talk='[a]大哥误会了，是我和阴兄弟去河边洗澡，伯姬看错啦。', emote={a=42},dur=1.8 },
			{ event = 'move', delay = 6,handle_id=3, dir = 1, pos = {1200,890},speed = 340, dur = 1 ,end_dir = 2},
			{ event = 'move', delay = 7,handle_id=3, dir = 1, pos = {1200,840},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 8,handle_id=3, dir = 1, pos = {1300,890},speed = 340, dur = 1 ,end_dir = 6},

			{ event = 'move', delay = 10,handle_id=3, dir = 1, pos = {1410,860},speed = 340, dur = 1 ,end_dir = 7},
	   		{ event = 'talk', delay= 11, handle_id = 3, talk='三哥，你的衣服怎么穿在阴戟身上？', dur=1.8 },	

	   		{ event = 'talk', delay= 13, handle_id = 2, talk='阴兄弟的衣服被水冲走了，他身子单薄，我做哥哥的，就把衣服给他了……', dur=1.8 },	
	   		{ event = 'talk', delay= 13.5, handle_id = 1, talk='阿——嚏！[a]',emote={a=20}, dur=1.8 },	

			{ event = 'move', delay = 15.5,handle_id=1, dir = 1, pos = {1250,890},speed = 340, dur = 1 ,end_dir = 2},
			{ event = 'move', delay = 16.5,handle_id=4, dir = 1, pos = {1536,867},speed = 340, dur = 1 ,end_dir = 6},

	   		{ event = 'talk', delay= 15.5, handle_id = 1, talk='大哥，我好像有点受凉，先回房了。', dur=1.8 },	
	   		{ event = 'talk', delay= 17.5, handle_id = 4, talk='好，好，赶紧回去歇息。', dur=1.8 },	   			   		

	   	},
	   	{
			{ event = 'move', delay = 0.5,handle_id=1, dir = 1, pos = {2023,688},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2023,688},speed = 340, dur = 1 ,end_dir = 3},

	   		{ event ='camera', delay = 2.2, sdur=0.5, dur = 0.5, c_topox = {1670,800}, style = '',backtime=1},	

			{ event = 'move', delay = 1,handle_id=4, dir = 1, pos = {1536,867},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 1,handle_id=5, dir = 1, pos = {1432,1005},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 1,handle_id=6, dir = 1, pos = {1516,996},speed = 500, dur = 1 ,end_dir = 1},
			{ event = 'move', delay = 1,handle_id=7, dir = 1, pos = {1598,951},speed = 500, dur = 1 ,end_dir = 1},

	   		{ event='kill', delay=3.8, handle_id=1},
	   		{ event='kill', delay=3.8, handle_id=2},
	   		
			{ event = 'move', delay = 2,handle_id=3, dir = 1, pos = {1670,858},speed = 340, dur = 1 ,end_dir = 1},	

	   		{ event = 'talk', delay= 4, handle_id = 3, talk='你……哼！', dur=3 },	 				
	   	},

	},
	--============================================luyao  剧情副本第二章第三节 end      =====================================----

    --============================================luyao  剧情副本第二章第四节 start    =====================================----	
	['juqing241'] = {	

	   	{
	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={2202,4004}, dir=3, speed=340, name_color=0xffffff, name="刘縯", },

	   		{ event='createActor', delay=0.1, handle_id=2, body=36, pos={2131,4056}, dir=3, speed=340, name_color=0xffffff, name="樊夫人", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=12, pos={2338,4069}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=5, pos={2434,4131}, dir=5, speed=340, name_color=0xffffff, name="阴戟", },
	   		--{ event='createActor', delay=0.1, handle_id=5, body=17, pos={2004,4069}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
			{ event="createSpEntity",delay=0.1, handle_id=5, name="17",name_color=0xffffff,actor_name="刘伯姬", action_id=5, dir=3, pos={2004,4069}},	   		
	   		{ event='createActor', delay=0.1, handle_id=6, body=1, pos={2076,4236}, dir=1, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=1, pos={2162,4286}, dir=1, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=7, pos={2337,4332}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=9, body=7, pos={2475,4287}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=7, pos={2587,4176}, dir=6, speed=340, name_color=0xffffff, name="门客", },




	   		{ event='init_cimera', delay = 0.1,mx= 2288,my = 4058 ,dur= 1.5}, 

	   	},
	   	{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2206,4126},speed = 340, dur = 1 ,end_dir = 3},	

	   		{ event = 'talk', delay= 1, handle_id = 1, talk='十三年前，新莽篡我汉室江山，不知叔伯们还记得？', dur=2.5 },	 
	   		{ event = 'talk', delay= 4, handle_id = 1, talk='今日我刘伯升想邀请各位叔伯兄弟，共举义旗，匡扶汉室！', dur=2.5 },	
	   		{ event = 'talk', delay= 7, handle_id = 6, talk='！！', dur=1.5 },	
	   		{ event = 'talk', delay= 7, handle_id = 7, talk='！！', dur=1.5 },	
	   		{ event = 'talk', delay= 9, handle_id = 6, talk='[a]你忘了当年安众侯起兵，全家被杀的惨祸么？！',emote={a=34}, dur=2.2},	
	   		{ event = 'talk', delay= 12, handle_id = 7, talk='今日是你娘大寿，你不能少说点煞气之事？ ', dur=1.8 },	

			{ event = 'move', delay = 14,handle_id=2, dir = 1, pos = {2161,4086},speed = 340, dur = 1 ,end_dir = 3},		   		
	   		{ event = 'talk', delay= 14.5, handle_id = 2, talk='好了好了，先不提这事，大家先喝酒…… ', dur=2 },	

	
			{ event = 'move', delay = 17,handle_id=1, dir = 1, pos = {2246,4166},speed = 340, dur = 1 ,end_dir = 5},	
	   		{ event = 'talk', delay= 18, handle_id = 1, talk='哼！ ', dur=1.4 },	
			{ event = 'move', delay = 19.5,handle_id=1, dir = 1, pos = {2202,4004},speed = 340, dur = 1 ,end_dir = 3},					
	   	},

	   	{
			{ event = 'move', delay = 0.1,handle_id=5, dir = 1, pos = {2254,4151},speed = 340, dur = 1 ,end_dir = 7},	

	   		{ event = 'talk', delay= 1, handle_id = 5, talk='娘，女儿最近学了套越女剑，伯姬愿舞剑为娘祝寿。', dur=2.2 },

	   		{ event = 'talk', delay= 3.5, handle_id = 5, talk='也替家兄馈谢诸位长辈。', dur=1.8 },

			{ event = 'move', delay = 5.6,handle_id=5, dir = 1, pos = {2246,4166},speed = 340, dur = 1 ,end_dir = 3},

	   		{ event = 'playAction', handle_id= 5, delay = 7, action_id = 5, dur = 2, dir = 2,loop = false ,},

			{ event = 'move', delay = 9,handle_id=5, dir = 1, pos = {2286,4166},speed = 150, dur = 0.4 ,end_dir = 7},

	   		{ event = 'playAction', handle_id= 5, delay = 9.5, action_id = 5, dur = 2, dir = 6,loop = false ,},   	   		  

	   		{ event = 'talk', delay= 6.6, handle_id = 10 , talk='[a]',emote={a=26}, dur=1.8 },	 
	   		{ event = 'talk', delay= 7.5  , handle_id = 7 , talk='[a]',emote={a=16}, dur=1.8 },	
	   		{ event = 'talk', delay= 8, handle_id = 6 , talk='[a]',emote={a=2}, dur=1.8 },	
	   		{ event = 'talk', delay= 8.5, handle_id = 9 , talk='[a]',emote={a=2}, dur=1 },	
	   		{ event = 'talk', delay= 8, handle_id = 8, talk='[a]',emote={a=2}, dur=1 },	

	    	{ event='showTopTalk', delay=8.4, dialog_id="2_4_1" ,dialog_time=2},

	   	},

	   	{
			{ event = 'move', delay = 0.1,handle_id=5, dir = 1, pos = {2404,4151},speed = 340, dur = 1 ,end_dir = 7},

	   		{ event = 'talk', delay= 1.2, handle_id = 5 , talk='啊呀——', dur=1.8 },	


	   		{ event = 'playAction', handle_id= 5, delay = 1.2, action_id = 4, dur = 1.8, dir = 2,loop = false ,once=true},  

	   		{ event = 'playAction', handle_id= 4, delay = 1.2, action_id = 3, dur = 1.8, dir = 5,loop = false ,once=false}, 
	   		{ event = 'talk', delay= 1.3, handle_id = 11 , talk='！！！', dur=1.5 },

			{ event = 'changeRGBA',delay=2.5,dur=0.1,txt = "丽华一头青丝如瀑布落下……"},
	   		{ event='kill', delay=2.8, handle_id=4},
			{ event = 'move', delay = 2.7,handle_id=5, dir = 1, pos = {2404,4151},speed = 340, dur = 1 ,end_dir = 2},

	   		{ event='createActor', delay=3, handle_id=11, body=6, pos={2434,4131}, dir=5, speed=340, name_color=0xffffff, name="阴丽华", },




	   		{ event = 'talk', delay= 5.5, handle_id = 3 , talk='！！！', dur=1.5 },	 
	   		{ event = 'talk', delay= 5.5, handle_id = 4 , talk='！！！', dur=1.5 },	   		
	   		{ event = 'talk', delay= 5.5, handle_id = 10 , talk='！！！', dur=1.5 },
	   		{ event = 'talk', delay= 5.5, handle_id = 6 , talk='！！！', dur=1.5 },
	   		{ event = 'talk', delay= 5.5, handle_id = 7 , talk='是女子？', dur=1.5 },

			{ event = 'move', delay = 5.5,handle_id=3, dir = 1, pos = {2338,4069},speed = 340, dur = 1 ,end_dir = 3},	
	   		{ event = 'playAction', handle_id= 6, delay = 2.5, action_id = 0, dur = 1.8, dir = 2,loop = true ,}, 
			{ event = 'move', delay = 6.8,handle_id=5, dir = 1, pos = {2304,4151},speed = 340, dur = 1 ,end_dir = 2},	 
	   		{ event = 'talk', delay= 7.2, handle_id = 5, talk='[a]阴家姐姐，真是对不住啊，是伯姬不小心。',emote={a=48}, dur=2 },			  		
	   	},
	   	{

			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2304,4151},speed = 340, dur = 1 ,end_dir = 2},	 
			{ event = 'move', delay = 0.5,handle_id=5, dir = 1, pos = {2304,4251},speed = 340, dur = 1 ,end_dir = 1},	

	   		{ event = 'talk', delay= 1.5, handle_id = 1 , talk='阴…戟？你是女子？！', dur=1.8 },

			--{ event = 'effect', handle_id=101,target_id=11, delay = 9.0, pos = {0,0}, layer = 2, effect_id = 20004, dx = 0,dy = 30,is_forever = true},--阴丽华紧张特效
	   		{ event = 'talk', delay= 3.5, handle_id = 11 , talk='[a]我…',emote={a=23}, dur=1.8 },
			{ event = 'move', delay = 5.5,handle_id=5, dir = 1, pos = {2384,4201},speed = 340, dur = 1 ,end_dir = 1},		   			 
	   		{ event = 'talk', delay= 6.5, handle_id = 5 , talk='[a]大哥忘了，她就是你三年前救下的阴家千金，阴丽华啊。',emote={a=45}, dur=2.5 },

			--{ event = 'effect', handle_id=102,target_id=11, delay = 9.0, pos = {0,0}, layer = 2, effect_id = 20004, dx = 0,dy = 30,is_forever = true},--阴丽华愤怒特效
	   		{ event = 'talk', delay= 9.5, handle_id = 11 , talk='[a]我以后再与大哥解释。',emote={a=43}, dur=1.8 },	

			{ event = 'move', delay = 11,handle_id=11, dir = 1, pos = {2500,4104},speed = 500, dur = 1 ,end_dir = 1},

	   		{ event = 'talk', delay= 11.5, handle_id = 5 , talk='拦住她。', dur=1.8 },	

			{ event = 'move', delay = 11.8,handle_id=3, dir = 1, pos = {2338,4069},speed = 340, dur = 1 ,end_dir = 1}, 

			{ event = 'move', delay = 11.8,handle_id=10, dir = 1, pos = {2584,4046},speed = 200, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 11.8,handle_id=9, dir = 1, pos = {2584,4160},speed = 200, dur = 1 ,end_dir = 5},
	   	},
	},

	['juqing242'] = {	


	  
	   	{
	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={2239,4270}, dir=1, speed=340, name_color=0xffffff, name="刘縯", },

	   		{ event='createActor', delay=0.1, handle_id=2, body=36, pos={2161,4086}, dir=2, speed=340, name_color=0xffffff, name="樊夫人", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=12, pos={2338,4069}, dir=1, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=5, pos={2500,4104}, dir=1, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=17, pos={2004,4069}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=1, pos={2076,4236}, dir=1, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=1, pos={2162,4286}, dir=1, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=7, pos={2337,4332}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=9, body=7, pos={2584,4160}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=7, pos={2584,4046}, dir=6, speed=340, name_color=0xffffff, name="门客", },

	   		{ event='init_cimera', delay = 0.1,mx= 2288,my = 4050 ,dur= 1.5}, 

	   	},

	   	{

	   		{ event = 'talk', delay= 0.1, handle_id = 2 , talk='阴姑娘，请留步。', dur=1.8 },	
			{ event = 'move', delay = 2, handle_id=4, dir = 1, pos = {2500,4104},speed = 340, dur = 1 ,end_dir = 6},
	   		{ event = 'talk', delay= 2.5, handle_id = 2 , talk='老身眼不太好，请姑娘过来……', dur=1.8 },		
	   		{ event = 'talk', delay= 4.1, handle_id = 4 , talk='[a]',emote={a=50}, dur=1.8 },
			{ event = 'move', delay = 5, handle_id=3, dir = 1, pos = {2420,4104},speed = 340, dur = 1 ,end_dir = 1},
	   		{ event = 'talk', delay= 6, handle_id = 3 , talk='别怕，跟我来。',emote={a=50}, dur=1.8 },	

			{ event = 'move', delay = 9.5, handle_id=2, dir = 1, pos = {2161,4086},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 7.8, handle_id=3, dir = 1, pos = {2183,4167},speed = 340, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 8.2, handle_id=4, dir = 1, pos = {2272,4114},speed = 340, dur = 1 ,end_dir = 7},


	   		{ event = 'talk', delay= 10, handle_id = 3 , talk='母亲，您与大哥曾问孩儿为何一直没有娶亲，皆因秀在长安太学时，就已立下夙愿。', dur=1.8 },	
	   		{ event = 'talk', delay= 12, handle_id = 2 , talk='哦？是什么？', dur=1.8 },
	   		{ event = 'talk', delay= 14, handle_id = 3 , talk='孩儿此生唯愿：仕宦当作执金吾，娶妻当得阴丽华！', dur=1.8 },

	   		{ event = 'talk', delay= 16, handle_id = 5 , talk='！', dur=1.8 },
	   		{ event = 'talk', delay= 16, handle_id = 6 , talk='！', dur=1.8 },
	   		{ event = 'talk', delay= 16, handle_id = 7 , talk='！', dur=1.8 },
	   		{ event = 'talk', delay= 16, handle_id = 8 , talk='！', dur=1.8 },	   		
	   		{ event = 'talk', delay= 16.5, handle_id = 4 , talk='[a]',emote={a=47}, dur=1.8 },	 	   			   		

	   		{ event = 'talk', delay= 18, handle_id = 2 , talk='为娘明白了……', dur=1.2 },

	   		{ event = 'talk', delay= 19.5, handle_id = 2 , talk='秀儿，阴姬千金之躯，不辞劳苦过来帮你，你可要好好对她呀。', dur=1.8 },

	   		{ event = 'talk', delay= 22, handle_id = 3 , talk='娘说得是，孩儿此生非丽华不娶，定会对她一心一意！', dur=1.8 },

			{ event = 'move', delay = 21, handle_id=3, dir = 1, pos = {2232,4144},speed = 340, dur = 1 ,end_dir = 1},

			{ event = 'move', delay = 21, handle_id=4, dir = 1, pos = {2272,4114},speed = 340, dur = 1 ,end_dir = 5},

	   		{ event = 'talk', delay= 23, handle_id = 4 , talk='[a]',emote={a=18}, dur=1.8 },



	   	},



	},
	--============================================luyao  剧情副本第二章第三节 end      =====================================----	

	--============================================wuwenbin  剧情副本第二章第五节 start    =====================================----
	['juqing251'] = {	

        --角色前置对白

	    {

	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={2800,1620}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=14, pos={2778,1992}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=48, pos={2709,2025}, dir=7, speed=340, name_color=0xffffff, name="李轶", },
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 2716,my = 1880 }, 	 
	    },

	    --刘秀跑进屏幕
	    {
	   		{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2706,1921},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'talk', delay= 0.5, handle_id = 2, talk='不好了，谋反之事被甄阜告发，李家处境十分危险。', dur=2.5 },
	   		{ event = 'talk', delay= 3.3, handle_id = 4, talk='[a]我们应该立刻起兵，杀进宛城救回我大哥。', dur=2.5 ,emote = { a = 28},},
	   		{ event = 'talk', delay= 6.1, handle_id = 3, talk='没错，以不变应万变，我们提前起兵！', dur=2.5 },
	   		{ event = 'talk', delay= 8.9, handle_id = 2, talk='不可，当务之急，是去宛城通知李次元，我去吧。', dur=2.5 },
	    },

	    --丽华前置对白
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="2_5_1" ,dialog_time=1.3},
	    	{ event = 'move', delay = 0.3,handle_id=2, dir = 1, pos = {2706,1921},speed = 340, dur = 1 ,end_dir = 5}, 
	    	{ event = 'move', delay = 0.3,handle_id=3, dir = 1, pos = {2778,1992},speed = 340, dur = 1 ,end_dir = 5}, 
	    	{ event = 'move', delay = 0.3,handle_id=4, dir = 1, pos = {2709,2025},speed = 340, dur = 1 ,end_dir = 5}, 
	    },

	    --阴丽华跑进屏幕
	    {
	    	{ event='createActor', delay=0.1, handle_id=1, body=5, pos={2453,2381}, dir=1, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event = 'move', delay = 0.3,handle_id = 1, dir = 1, pos = {2635,1958},speed = 340, dur = 1 ,end_dir = 3},

	   		{ event = 'move', delay = 2.6,handle_id=2, dir = 1, pos = {2706,1921},speed = 340, dur = 1 ,end_dir = 3}, 
	    	{ event = 'move', delay = 2.6,handle_id=3, dir = 1, pos = {2778,1992},speed = 340, dur = 1 ,end_dir = 7}, 
	    	{ event = 'move', delay = 2.6,handle_id=4, dir = 1, pos = {2709,2025},speed = 340, dur = 1 ,end_dir = 7}, 

	   		{ event = 'talk', delay= 0.5, handle_id = 1, talk='我表姐邓蝉还在宛城，只怕她也会被牵连。', dur=2.5 },
	   		{ event = 'talk', delay= 3.3, handle_id = 3, talk='你们去宛城千万小心，大哥等你们回来。', dur=2.5 },
	   		{ event = 'talk', delay= 6.1, handle_id = 2, talk='嗯嗯', dur=1.5 },
	   		{ event = 'talk', delay= 6.1, handle_id = 1, talk='嗯嗯', dur=1.5 },
	    },

	    --刘秀，阴丽华跑出屏幕
	    {
	   		{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2738,1500},speed = 340, dur = 2 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2820,1500},speed = 340, dur = 2 ,end_dir = 3}, 
	    },


	},

	['juqing252'] = {	

        --角色前置对白
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2835,1801}, dir=7, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={2898,1842}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },

	   		{ event='createActor', delay=0.1, handle_id=3, body=18, pos={2173,1206}, dir=3, speed=340, name_color=0xffffff, name="甄阜", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=52, pos={2040,1169}, dir=1, speed=340, name_color=0xffffff, name="李珺", },

	   		{ event='createActor', delay=0.1, handle_id=8, body=19, pos={2042,1201}, dir=3, speed=340, name_color=0xffffff, name="", },  --尸体
	   		{ event='createActor', delay=0.1, handle_id=9, body=17, pos={2071,1138}, dir=7, speed=340, name_color=0xffffff, name="", },	--尸体
	   		{ event='createActor', delay=0.1, handle_id=10, body=19, pos={2100,1175}, dir=1, speed=340, name_color=0xffffff, name="", },	--尸体
	   		{ event='createActor', delay=0.1, handle_id=11, body=11, pos={2102,1113}, dir=3, speed=340, name_color=0xffffff, name="", },  --尸体
	   		{ event='createActor', delay=0.1, handle_id=12, body=19, pos={2126,1135}, dir=7, speed=340, name_color=0xffffff, name="", },	--尸体

	   		{ event='createActor', delay=0.1, handle_id=21, body=17, pos={2902,1650}, dir=3, speed=340, name_color=0xffffff, name="", },	--谈话的路人
	   		{ event='createActor', delay=0.1, handle_id=22, body=41, pos={2971,1683}, dir=7, speed=340, name_color=0xffffff, name="", },	--谈话的路人
	   		
	   		{ event='createActor', delay=0.1, handle_id=23, body=17, pos={2200,1301}, dir=7, speed=340, name_color=0xffffff, name="", }, --听布告路人
	   		{ event='createActor', delay=0.1, handle_id=24, body=41, pos={2252,1269}, dir=7, speed=340, name_color=0xffffff, name="", }, --听布告路人
	   		{ event='createActor', delay=0.1, handle_id=25, body=19, pos={2317,1229}, dir=7, speed=340, name_color=0xffffff, name="", }, --听布告路人
	   		{ event='createActor', delay=0.1, handle_id=26, body=17, pos={2318,1163}, dir=6, speed=340, name_color=0xffffff, name="", }, --听布告路人


	   		{ event = 'playAction', handle_id= 7, delay = 0.2, action_id = 4, dur = 0.1, dir = 2,loop = false ,once = true},  --尸体死亡动作
	   		{ event = 'playAction', handle_id= 8, delay = 0.2, action_id = 4, dur = 0.1, dir = 7,loop = false ,once = true},  --尸体死亡动作
	   		{ event = 'playAction', handle_id= 9, delay = 0.2, action_id = 4, dur = 0.1, dir = 3,loop = false ,once = true},  --尸体死亡动作
	   		{ event = 'playAction', handle_id= 10, delay = 0.2, action_id = 4, dur = 0.1, dir = 1,loop = false ,once = true},  --尸体死亡动作
	   		{ event = 'playAction', handle_id= 11, delay = 0.2, action_id = 4, dur = 0.1, dir = 3,loop = false ,once = true},  --尸体死亡动作
	   		{ event = 'playAction', handle_id= 12, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},  --尸体死亡动作

	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 2590,my = 1600 }, 	
	    },

	    --丽华，刘秀跑过路人旁，听见谈论李家
	    {
	    	{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2835,1710},speed = 340, dur = 1 ,end_dir = 1}, 
	    	{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2898,1749},speed = 340, dur = 1 ,end_dir = 1}, 
	    	{ event = 'talk', delay= 0.1, handle_id = 21, talk='听说了么，李家的人都被砍了。', dur=2 },
	   		{ event = 'talk', delay= 2.3, handle_id = 22, talk='何止啊，还焚尸弃市，真惨啊……', dur=2 },

	   		{ event = 'move', delay = 4.3,handle_id=1, dir = 1, pos = {2835,1710},speed = 340, dur = 1 ,end_dir = 3}, 
	    	{ event = 'move', delay = 4.3,handle_id=2, dir = 1, pos = {2898,1749},speed = 340, dur = 1 ,end_dir = 7}, 
	   		{ event = 'talk', delay= 4.3, handle_id = 1, talk='[a]', dur=1.5, emote = { a = 41 } },
	   		{ event = 'talk', delay= 6.1, handle_id = 2, talk='去看看。', dur=1.5 },

		},

		-- --尸体特写
		-- {
		-- 	{ event = 'camera', delay = 0.2, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = { 2000,1071 } },  
		-- 	{ event= 'zoom', delay=0.5, sValue=1.0, eValue=0.5, dur=0.3 },	--放大镜头给特写
		-- },

		--丽华，刘秀走到前面，听见甄阜布告
		{
			{ event = 'camera', delay = 0.3, target_id = 1, sdur=3.5, dur = 0.3,style = 'follow',backtime=1},	
	    	{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2350,1289},speed = 340, dur = 1 ,end_dir = 7}, 
	    	{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2414,1266},speed = 340, dur = 1 ,end_dir = 7}, 


			{ event = 'camera', delay = 3, dur = 0.5,sdur = 0.9,style = '',backtime=1, c_topox = { 2231,1206 } },
	   		{ event = 'talk', delay= 3, handle_id = 3, talk='反贼李通意图造反——这就是他们的下场！', dur=2.5 },
	   		{ event = 'talk', delay= 5.8, handle_id = 3, talk='尔等谁敢窝藏反贼家眷者，论罪同刑！', dur=2.5 },
	   		{ event = 'talk', delay= 8.6, handle_id = 3, talk='揭发逆贼者，本官重重有赏！', dur=2 },
		},

		--丽华刘秀跑出屏幕
		{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2350,1289},speed = 340, dur = 1 ,end_dir = 1}, 
	    	{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2414,1266},speed = 340, dur = 1 ,end_dir = 5}, 

			{ event = 'talk', delay= 0.1, handle_id = 1, talk='[a]啊……表姐。', dur=2, emote = { a = 47 } },
			{ event = 'talk', delay= 2.3, handle_id = 2, talk='去他们家，走！', dur=2 },
	    	{ event = 'move', delay = 4.3, handle_id = 1, dir = 1, pos = {2481,850},speed = 340, dur = 2 ,end_dir = 3}, 
	    	{ event = 'move', delay = 4.3, handle_id = 2, dir = 1, pos = {2421,820},speed = 340, dur = 2 ,end_dir = 3}, 
		},

	},

	--============================================wuwenbin  剧情副本第二章第五节 end    =====================================----

	--============================================wuwenbin  剧情副本第二章第六节 start    =====================================----
	['juqing261'] = {	

        --创建角色
	    {

	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2476,680}, dir=5, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=10, pos={2554,726}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=41, pos={2548,652}, dir=5, speed=340, name_color=0xffffff, name="胭脂", },

	   		{ event='createActor', delay=0.1, handle_id=4, body=21, pos={2356,942}, dir=1, speed=340, name_color=0xffffff, name="新兵兵头", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=25, pos={2414,982}, dir=1, speed=340, name_color=0xffffff, name="新兵守卫", },

	   		--摆设型卫兵
	   		{ event='createActor', delay=0.1, handle_id=11, body=27, pos={2198,1036}, dir=1, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=27, pos={2228,1110}, dir=1, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=27, pos={2254,1162}, dir=1, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=27, pos={2550,1032}, dir=5, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=15, body=27, pos={2578,1090}, dir=5, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=16, body=27, pos={2618,1162}, dir=5, speed=340, name_color=0xffffff, name="守城士兵", },

	   	},

	   	--镜头初始化并跟随
	   	{
	   		-- { event ='camera', delay = 0.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1}, 
	   		{ event='init_cimera', delay = 0.1,mx= 2427,my = 856 }, 	 
	    },

	    --丽华，邓婵，胭脂走近官兵
	    {
	   		{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2386,850},speed = 340, dur = 1 ,end_dir = 5}, 
	   		{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2456,882},speed = 340, dur = 1 ,end_dir = 5}, 
	   		{ event = 'move', delay = 0.1,handle_id=3, dir = 1, pos = {2456,814},speed = 340, dur = 1 ,end_dir = 5}, 

	   		{ event = 'talk', delay= 1, handle_id = 5, talk='站住！什么人？', dur=1.5 },
	   		{ event = 'talk', delay= 2.8, handle_id = 1, talk='回官爷话，是小的姐姐和婢女。', dur=2 },
	   		{ event = 'talk', delay= 5, handle_id = 4, talk='你不知道，现在不许随意出入吗？', dur=2 },
	   		{ event = 'talk', delay= 7.3, handle_id = 1, talk='这位官爷，求官爷通融一下吧，我的姐姐快要临产了……', dur=2.5 },
	   		{ event = 'talk', delay= 10, handle_id = 4, talk='行了行了，你们走吧！', dur=1.5 },
	   		{ event = 'talk', delay= 11.8, handle_id = 1, talk='谢谢官爷！', dur=1.5 },
	    },

	    --守卫让路放行，阴戟一行走出去，经过一个新兵
	    {
	    	{ event = 'camera', delay = 0.2, dur=3.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2415,1032 } },

	    	{ event = 'move', delay = 0.1,handle_id=4, dir = 1, pos = {2253,891},speed = 340, dur = 1 ,end_dir = 3},  --兵头让开
	    	{ event = 'move', delay = 0.1,handle_id=5, dir = 1, pos = {2494,917},speed = 340, dur = 1 ,end_dir = 5},  --守卫让开

	   		{ event = 'move', delay = 1,handle_id=1, dir = 1, pos = {2442,1324},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 1,handle_id=2, dir = 1, pos = {2512,1362},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 1,handle_id=3, dir = 1, pos = {2512,1362},speed = 340, dur = 1 ,end_dir = 3}, 


	   		{ event = 'talk', delay= 1.8, handle_id = 13, talk='[a]', dur=1.5 ,emote = {a = 41}},
	   		{ event = 'move', delay = 2,handle_id = 13, dir = 1, pos = {2254,1162},speed = 340, dur = 1 ,end_dir = 3}, 


	   		{ event='kill', delay=3.8, handle_id=1},
	   		{ event='kill', delay=3.8, handle_id=2},
	   		{ event='kill', delay=4, handle_id=3},
	    },

	    --新兵认出阴戟，向兵头报告
	    {
	    	
	    	{ event = 'move', delay = 0.1,handle_id = 4, dir = 1, pos = {2338,1120},speed = 340, dur = 1 ,end_dir = 5},
	    	{ event = 'move', delay = 0.5,handle_id = 13, dir = 1, pos = {2254,1162},speed = 340, dur = 1 ,end_dir = 1},  

	   		{ event = 'talk', delay= 0.1, handle_id = 13, talk='他……他……', dur=1.5 },
	   		{ event = 'talk', delay= 1.5, handle_id = 4, talk='[a]他什么他？你认识他？', dur=2 ,emote = {a = 34}},
	   		{ event = 'talk', delay= 3.5, handle_id = 13, talk='刚刚过去那女的，好像是邓家反贼！', dur=2 },
	   		{ event = 'talk', delay= 5.5, handle_id = 4, talk='[a]那还愣着干什么！赶快追啊！', dur=2 ,emote = {a = 22}},
	    },

	    --兵头士兵追向阴戟一行
	    {
	   		{ event = 'move', delay = 0.1,handle_id=4, dir = 1, pos = {2700,1528},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.3,handle_id=5, dir = 1, pos = {2868,1496},speed = 340, dur = 1 ,end_dir = 3}, 

	   		{ event = 'move', delay = 0.3,handle_id=11, dir = 1, pos = {2700,1528},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.3,handle_id=12, dir = 1, pos = {2700,1528},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.3,handle_id=13, dir = 1, pos = {2700,1528},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.3,handle_id=14, dir = 1, pos = {2868,1496},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.3,handle_id=15, dir = 1, pos = {2868,1496},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.3,handle_id=16, dir = 1, pos = {2868,1496},speed = 340, dur = 1 ,end_dir = 3}, 
	    },


	},

	['juqing262'] = {	

		--角色表 1 丽华 2 邓婵 3 阴识 4 阴和 5 家仆 101-107 追赶的士兵
        --创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2518,988}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=10, pos={2640,988}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },
	   		-- { event='createActor', delay=0.1, handle_id=3, body=30, pos={3030,912}, dir=5, speed=340, name_color=0xffffff, name="阴识", },
	   		-- { event='createActor', delay=0.1, handle_id=4, body=19, pos={3082,954}, dir=5, speed=340, name_color=0xffffff, name="家仆", },
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 2864,my = 1320 }, 	
	    },

	    --丽华和邓婵跑过
	    {
	   		{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {2770,1622},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {2882,1622},speed = 340, dur = 1 ,end_dir = 3}, 

	   		{ event='kill', delay=3.8, handle_id=1},
	   		{ event='kill', delay=3.8, handle_id=2},
		},

	    --创建追赶士兵
	   	{
	   		--摆设型卫兵
	   		{ event='createActor', delay=0.1, handle_id=101, body=21, pos={2616-32,1080-64}, dir=3, speed=340, name_color=0xffffff, name="新兵兵头", },

	   		{ event='createActor', delay=0.1, handle_id=102, body=27, pos={2484-32,910-64}, dir=3, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=103, body=27, pos={2518-32,988-64}, dir=3, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=27, pos={2552-32,1036-64}, dir=3, speed=340, name_color=0xffffff, name="守城士兵", },

	   		{ event='createActor', delay=0.1, handle_id=105, body=27, pos={2608-32,910-64}, dir=3, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=106, body=27, pos={2640-32,988-64}, dir=3, speed=340, name_color=0xffffff, name="守城士兵", },
	   		{ event='createActor', delay=0.1, handle_id=107, body=27, pos={2674-32,1036-64}, dir=3, speed=340, name_color=0xffffff, name="守城士兵", },

	   		-- { event = 'playAction', handle_id= 2, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   	},

	   	
	    --一队士兵跑过
	    {
	   		{ event = 'move', delay = 0.1,handle_id=101, dir = 1, pos = {2825,1622},speed = 340, dur = 1 ,end_dir = 3},

	   		{ event = 'move', delay = 0.1,handle_id=102, dir = 1, pos = {2770,1622},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=103, dir = 1, pos = {2770,1622},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=104, dir = 1, pos = {2770,1622},speed = 340, dur = 1 ,end_dir = 3}, 

	   		{ event = 'move', delay = 0.1,handle_id=105, dir = 1, pos = {2882,1622},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=106, dir = 1, pos = {2882,1622},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.1,handle_id=107, dir = 1, pos = {2882,1622},speed = 340, dur = 1 ,end_dir = 3}, 

	   		{ event = 'talk', delay= 1, handle_id = 101, talk='莫跑了邓家反贼！', dur=3 },
	   		{ event = 'talk', delay= 1, handle_id = 103, talk='莫跑了邓家反贼！', dur=3 },
	   		{ event = 'talk', delay= 1, handle_id = 105, talk='莫跑了邓家反贼！', dur=3 },

	   		{ event='kill', delay=3.6, handle_id=101},

	   		{ event='kill', delay=4.6, handle_id=102},
	   		{ event='kill', delay=4.2, handle_id=103},
	   		{ event='kill', delay=3.8, handle_id=104},

	   		{ event='kill', delay=4.6, handle_id=105},
	   		{ event='kill', delay=4.2, handle_id=106},
	   		{ event='kill', delay=3.8, handle_id=107},
		},

		--创建角色
	    {	
	    	{ event ='camera', delay = 0.1, c_topox = {3092,876}, sdur=0.5, dur = 0.5,style = '',backtime=1},
	   		{ event='createActor', delay=0.4, handle_id=3, body=30, pos={3049,850}, dir=5, speed=340, name_color=0xffffff, name="阴识", },
	   		{ event='createActor', delay=0.4, handle_id=4, body=1, pos={3156,884}, dir=5, speed=340, name_color=0xffffff, name="阴和", },
	   		{ event='createActor', delay=0.4, handle_id=5, body=19, pos={3156,818}, dir=5, speed=340, name_color=0xffffff, name="家仆", },

	   		{ event = 'move', delay = 0.6,handle_id=3, dir = 1, pos = {3030,912},speed = 340, dur = 1 ,end_dir = 5}, 
			{ event = 'move', delay = 0.6,handle_id=4, dir = 1, pos = {3082,954},speed = 340, dur = 1 ,end_dir = 5}, 
			{ event = 'move', delay = 0.6,handle_id=5, dir = 1, pos = {3082,874},speed = 340, dur = 1 ,end_dir = 5},
	   	},

		--阴识和家仆发现官兵追人，绕道
		{
	   		{ event = 'talk', delay= 0.1, handle_id = 5, talk='公子，前面有一队官兵，像是追什么人。', dur=2.5 },
	   		{ event = 'talk', delay= 3, handle_id = 5, talk='咱们是否绕道而行？', dur=2 },
		},

		--阴识内心挣扎，想去看看被阴和阻拦
		{	
			{ event ='showTopTalk', delay= 0.1, dialog_id="2_6_1" ,dialog_time = 2.5},

			{ event = 'talk', delay= 2.8, handle_id = 3, talk='过去看看。', dur=2.5 },
			{ event = 'move', delay = 3,handle_id=3, dir = 1, pos = {2984,952},speed = 340, dur = 1 ,end_dir = 5}, 
			{ event = 'move', delay = 3,handle_id=4, dir = 1, pos = {2968,1000},speed = 260, dur = 1 ,end_dir = 1}, 

			{ event = 'talk', delay= 4, handle_id = 4, talk='大公子——', dur=1.5 },
			{ event = 'talk', delay= 5.8, handle_id = 4, talk='咱们途径宛城时已是风声鹤唳，新野邓家的情况只怕也很危险。', dur=3 },
			{ event = 'talk', delay= 9.1, handle_id = 4, talk='公子还是尽快赶回，无谓与官兵照面，惹来麻烦。', dur=3 },
		},

		-- --阴识和家仆发现官兵追人，绕道
		-- {
		-- 	{ event ='camera', delay = 0.6, c_topox = {3092,876}, sdur=0.5, dur = 0.5,style = '',backtime=1},


	 --   		{ event = 'talk', delay= 1.5, handle_id = 5, talk='公子，前面有一队官兵，像是追什么人。', dur=2.5 },
	 --   		{ event = 'talk', delay= 4.5, handle_id = 5, talk='咱们是否绕道而行？', dur=2 },
		-- },

		--阴识内心挣扎，想去看看被阴和阻拦
		{	
			{ event ='showTopTalk', delay= 0.1, dialog_id="2_6_2" ,dialog_time = 2},

			{ event = 'talk', delay= 2.3, handle_id = 3, talk='那就绕道而行吧。', dur=2 },
			{ event = 'move', delay = 4.5,handle_id=3, dir = 7, pos = {2928,654},speed = 340, dur = 1 ,end_dir = 5}, 
			{ event = 'move', delay = 4.5,handle_id=4, dir = 7, pos = {2868,686},speed = 340, dur = 1 ,end_dir = 1}, 
			{ event = 'move', delay = 4.5,handle_id=5, dir = 7, pos = {2930,722},speed = 340, dur = 1 ,end_dir = 1},

			{ event='kill', delay=5.5, handle_id=3},
	   		{ event='kill', delay=5.5, handle_id=4},
	   		{ event='kill', delay=5.5, handle_id=5},
		},

		--创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={1938,2066}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=10, pos={2000,2092}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },
	   		-- { event='createActor', delay=0.1, handle_id=3, body=30, pos={3030,912}, dir=5, speed=340, name_color=0xffffff, name="阴识", },
	   		-- { event='createActor', delay=0.1, handle_id=4, body=19, pos={3082,954}, dir=5, speed=340, name_color=0xffffff, name="家仆", },
	   		{ event='init_cimera', delay = 0.1,mx= 1870,my = 1680 }, 	
	   	},

	   	--邓婵摔倒，流产
	   	{
	   		{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {1678,1692},speed = 340, dur = 1 ,end_dir = 7}, 
			{ event = 'move', delay = 0.1,handle_id=2, dir = 1, pos = {1912,1810},speed = 400, dur = 1 ,end_dir = 7},

			{ event = 'talk', delay= 2.2, handle_id = 2, talk='啊——', dur=0.5 },
			{ event = 'talk', delay= 2.8, handle_id = 2, talk='疼疼……', dur=2 },
			{ event='playAction', delay=2.2, handle_id=2, action_id=4, dur=0.1, dir=3, loop=false, once = true},

			{ event = 'move', delay = 3,handle_id=1, dir = 1, pos = {1786,1823},speed = 260, dur = 1 ,end_dir = 1}, 
			{ event = 'talk', delay= 4.6, handle_id = 1, talk='表姐，你没事吧？', dur=2 },
			{ event = 'talk', delay= 6.9, handle_id = 2, talk='[a]疼啊，我受不住了……', dur=2 ,emote = {a= 46}},
		},
		{	
			{ event = 'talk', delay= 0.1, handle_id = 1, talk='表姐，你一定要撑住，要顺利地把孩子生下来……', dur=2.5 },
			{ event = 'talk', delay= 2.8, handle_id = 2, talk='我不要生孩子……丽华，我不要生……', dur=3 },
			{ event = 'talk', delay= 6.2, handle_id = 2, talk='我根本……不……爱那个男人……', dur=3 },
			{ event = 'talk', delay= 9.5, handle_id = 2, talk='为什么要……替他……生孩子！', dur=3 },
			{ event = 'talk', delay= 12.9, handle_id = 2, talk='我爱的是表哥！', dur=2.5 },
			{ event = 'talk', delay= 15.8, handle_id = 2, talk='我要回去看表哥……', dur=2.5 },
	   	},

	   	--丽华尝试宽慰邓婵
	   	{
			{ event = 'talk', delay= 0.1, handle_id = 1, talk='你赶快把孩子生下来，我们就可以回家看我哥了。', dur=2.5 },

			{ event = 'move', delay = 2.8,handle_id=1, dir = 1, pos = {1678,1692},speed = 340, dur = 1 ,end_dir = 7}, 
			{ event = 'talk', delay= 3.5, handle_id = 1, talk='表姐你看，那边就是新野故乡的方向……', dur=3 },
			{ event = 'talk', delay= 6.8, handle_id = 1, talk='你再坚持一下，我们很快就能回到家了，就能见到我哥了……', dur=3 },

			{ event = 'talk', delay= 10, handle_id = 2, talk='回家……回家看表哥……', dur=2 },
		},

		--丽华发现邓婵快不行了
	   	{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {1744,1748},speed = 340, dur = 1 ,end_dir = 3}, 
			{ event = 'talk', delay= 0.5, handle_id = 1, talk='表姐……', dur=1.5 },
			{ event = 'talk', delay= 2.3, handle_id = 2, talk='表哥……你为什么……呜……', dur=3 },
			{ event = 'talk', delay= 5.6, handle_id = 2, talk='从来……不肯多看我一眼……', dur=3 },
		},


		--丽华发现邓婵不行了
	   	{
			{ event = 'move', delay = 2,handle_id=1, dir = 1, pos = {1778,1778},speed = 340, dur = 1 ,end_dir = 3}, 
			{ event = 'talk', delay= 0.5, handle_id = 1, talk='表姐……？', dur=1.5 },
			{ event = 'talk', delay= 2.3, handle_id = 1, talk='！', dur= 1.5},

			{ event = 'move', delay = 3.8,handle_id=1, dir = 1, pos = {1786,1823},speed = 260, dur = 1 ,end_dir = 1}, 
			{ event = 'talk', delay= 4, handle_id = 1, talk='表姐……！表姐……', dur=1.5 },
			{ event = 'talk', delay= 5.8, handle_id = 1, talk='[a]表姐，你不要死……呜呜呜呜……', dur=3,emote = {a= 46} },

			{ event = 'changeRGBA',delay=9,dur=3,txt = "夜幕降临，荒野上回荡着丽华揪心凄绝的哭声……"},
			-- { event='kill', delay=9, handle_id=1},
	  --  		{ event='kill', delay=9, handle_id=2},	
		},
	   	

		-- --邓婵难产，丽华在一旁
		-- {
		-- 	-- { event ='camera', delay = 0.1, c_topox = {2106,1760}, sdur=0.5, dur = 0.5, style = '',backtime=1},
		-- 	-- { event= 'zoom', delay=0.6, sValue=1.0, eValue=0.9, dur=0.5 },	--放大镜头给特写
		-- 	{ event = 'move', delay = 4.5,handle_id=4, dir = 1, pos = {2868,686},speed = 260, dur = 1 ,end_dir = 1}, 
		-- 	{ event = 'move', delay = 4.5,handle_id=5, dir = 1, pos = {2930,722},speed = 400, dur = 1 ,end_dir = 1},

		-- 	{ event = 'talk', delay= 1, handle_id = 2, talk='[a]疼……我为什么要替他生孩子……', dur=2,emote = {a= 46}},
		-- 	{ event = 'talk', delay= 3.1, handle_id = 2, talk='我根本不……爱那个男人……', dur=2 },
		-- 	{ event = 'talk', delay= 5, handle_id = 1, talk='[a]表姐，我求求你！你不能放弃啊……', dur=2,emote = {a= 33} },
		-- 	{ event = 'talk', delay= 7, handle_id = 2, talk='阴识表哥……你……你为何从不看我……一眼……', dur=2 },
		-- 	{ event = 'talk', delay= 9, handle_id = 1, talk='表姐……？表姐……！呜呜呜呜……[a]', dur=2.5,emote = {a= 33} },
	    	
		-- },

	},

	--============================================wuwenbin  剧情副本第二章第六节 end    =====================================----


	--============================================wuwenbin  剧情副本第三章第一节 start    =====================================----
	['juqing311'] = {	

        --创建角色
        -- 演员表 1 丽华 2 刘縯 3 刘敞 4 刘稷 5 朱佑 6樊夫人 11-18宗亲
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={939,500}, dir=6, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=14, pos={626,528}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=53, pos={522,468}, dir=3, speed=340, name_color=0xffffff, name="刘敞", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=20, pos={877,470}, dir=6, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=1, pos={816,423}, dir=6, speed=340, name_color=0xffffff, name="朱佑", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=36, pos={594,594}, dir=7, speed=340, name_color=0xffffff, name="樊夫人", },

	   		--摆设型宗亲，逆时针从10点方向到4点方向
	   		{ event='createActor', delay=0.1, handle_id=11, body=19, pos={659,690}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=23, pos={724,656}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=19, pos={777,624}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=23, pos={845,583}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },

	   		-- { event='createActor', delay=0.1, handle_id=15, body=19, pos={714,750}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		-- { event='createActor', delay=0.1, handle_id=16, body=19, pos={793,725}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		-- { event='createActor', delay=0.1, handle_id=17, body=19, pos={854,691}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		-- { event='createActor', delay=0.1, handle_id=18, body=19, pos={906,658}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },	   		
	   	},

	   	--镜头初始化并跟随
	   	{
	   		-- { event ='camera', delay = 0.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1}, 
	   		{ event='init_cimera', delay = 0.1,mx= 577,my = 452 }, 	 
	    },

	    --刘敞训斥刘縯
	    {
	   		{ event = 'talk', delay= 1, handle_id = 2, talk='伯升见过侯爷！', dur=2 },
	   		{ event = 'talk', delay= 3.3, handle_id = 3, talk='刘縯！瞧瞧你都干了些什么，可是当真要惹得天怒人怨才肯甘心么？', dur=3 },
	   		{ event = 'talk', delay= 6.6, handle_id = 2, talk='我…… [a]', dur=1.5, emote={ a= 40} },
	    },

	     --丽华问刘稷
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={893,468} , sdur=0.1, dur = 0.5,style = '',backtime=1},

	    	{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {939,500},speed = 340, dur = 1 ,end_dir = 7},
	   		{ event = 'talk', delay= 0.1, handle_id = 1, talk='这人是谁……？', dur=1.5 },

	   		{ event = 'move', delay = 0.8,handle_id = 4, dir = 1, pos = {877,470},speed = 340, dur = 1 ,end_dir = 3},
	   		{ event = 'talk', delay= 1.5, handle_id = 4, talk='这是舂陵侯刘敞！咱南阳刘氏宗亲之首……', dur=2 },

	   		{ event = 'move', delay = 3.5,handle_id = 1, dir = 1, pos = {939,500},speed = 340, dur = 1 ,end_dir = 6},
			{ event = 'move', delay = 3.5,handle_id = 4, dir = 1, pos = {877,470},speed = 340, dur = 1 ,end_dir = 6},
	    },

	    --樊夫人移步向前面对刘敞
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={577,512} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	    	{ event = 'move', delay = 0.5,handle_id = 6, dir = 1, pos = {564,560},speed = 340, dur = 1 ,end_dir = 7},
	    	{ event = 'talk', delay= 0.5, handle_id = 6, talk='樊氏教子无方，愧对刘家宗亲……', dur=2 },
	    },

	    --4个宗亲上前吵嚷
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={685,585} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event = 'move', delay = 0.1,handle_id=11, dir = 1, pos = {659,690},speed = 340, dur = 1 ,end_dir = 7}, 
	   		{ event = 'talk', delay= 0.1, handle_id = 11, talk='侯爷可要替我们做主啊！', dur=1.5 },

	   		{ event = 'move', delay = 1.5,handle_id=12, dir = 1, pos = {724,656},speed = 340, dur = 1 ,end_dir = 7}, 
	   		{ event = 'talk', delay= 1.5, handle_id = 12, talk='是啊，这全是刘縯一个人的主意！', dur=2 },

	   		{ event = 'move', delay = 3.5,handle_id=13, dir = 1, pos = {777,624},speed = 340, dur = 1 ,end_dir = 7}, 
	   		{ event = 'talk', delay= 3.5, handle_id = 13, talk='他想害死我们刘氏全族啊……', dur=1.5 },

	   		{ event = 'move', delay = 5,handle_id=14, dir = 1, pos = {845,583},speed = 340, dur = 1 ,end_dir = 7}, 
	   		{ event = 'talk', delay= 5, handle_id = 14, talk='是啊，是啊！', dur=1.5 },
	    },
	},

	['juqing312'] = {	

        --创建角色
        -- 演员表 1 丽华 2 刘縯 3 刘秀 4 刘敞 5 刘稷 6 朱佑 7 樊夫人 11-18宗亲
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={939,500}, dir=6, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=14, pos={626,528}, dir=3, speed=340, name_color=0xffffff, name="刘縯", },

	   		{ event='createActor', delay=0.1, handle_id=4, body=53, pos={522,468}, dir=3, speed=340, name_color=0xffffff, name="刘敞", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=20, pos={877,470}, dir=5, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=1, pos={816,423}, dir=5, speed=340, name_color=0xffffff, name="朱佑", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=36, pos={564,560}, dir=3, speed=340, name_color=0xffffff, name="樊夫人", },

	   		--摆设型卫兵
	   		{ event='createActor', delay=0.1, handle_id=11, body=19, pos={659,690}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=23, pos={724,656}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=19, pos={777,624}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=23, pos={845,583}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },

	   		-- { event='createActor', delay=0.1, handle_id=15, body=19, pos={714,750}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		-- { event='createActor', delay=0.1, handle_id=16, body=19, pos={793,725}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		-- { event='createActor', delay=0.1, handle_id=17, body=19, pos={854,691}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },
	   		-- { event='createActor', delay=0.1, handle_id=18, body=19, pos={906,658}, dir=7, speed=340, name_color=0xffffff, name="宗亲", },	
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 607,my = 502 }, 	
	    },

	    --刘縯痛斥各宗亲
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 2, talk='我只是想与诸君共复汉室！你们却只顾着自家安危。', dur=3 },
	   		{ event = 'talk', delay= 3.4, handle_id = 2, talk='坐视山河沦丧，王莽暴虐而不理，岂不是无耻忘祖?', dur=3 },

	   		{ event = 'talk', delay= 6.7, handle_id = 12, talk='我等非是忘祖，只是顾念亲人性命！', dur=2.5 },
	   		{ event = 'talk', delay= 9.5, handle_id = 14, talk='你想造反是你的事，我等就不奉陪了。', dur=2.5 },
		},

		-- --宗亲开始退场
		-- {
		-- 	{ event = 'camera', delay = 0.1, c_topox={982,758}, sdur=0.1, dur = 0.5,style = '',backtime=1},
		-- 	{ event = 'move', delay = 0.1,handle_id = 11, dir = 1, pos = {853,817},speed = 340, dur = 1 ,end_dir = 3},
		-- 	{ event = 'move', delay = 0.1,handle_id = 12, dir = 1, pos = {913,782},speed = 340, dur = 1 ,end_dir = 3},
		-- 	{ event = 'move', delay = 0.1,handle_id = 13, dir = 1, pos = {982,758},speed = 340, dur = 1 ,end_dir = 3},
		-- 	{ event = 'move', delay = 0.1,handle_id = 14, dir = 1, pos = {1045,720},speed = 340, dur = 1 ,end_dir = 3},
		-- 	-- { event = 'move', delay = 0.1,handle_id = 15, dir = 1, pos = {911,875},speed = 340, dur = 1 ,end_dir = 3},
		-- 	-- { event = 'move', delay = 0.1,handle_id = 16, dir = 1, pos = {977,849},speed = 340, dur = 1 ,end_dir = 3},
		-- 	-- { event = 'move', delay = 0.1,handle_id = 17, dir = 1, pos = {1042,818},speed = 340, dur = 1 ,end_dir = 3},
		-- 	-- { event = 'move', delay = 0.1,handle_id = 18, dir = 1, pos = {1105,788},speed = 340, dur = 1 ,end_dir = 3},
		-- },

		--震屏，场景变暗，彗星特效（变暗用遮罩？）
		{
			{ event='shake', delay = 0.1, dur=1, c_topox={607,502}, index=30, rate=2, radius=20 }, 
			{ event = 'screenEffect', handle_id=1001, delay = 0.3, pos = {1000, 20}, layer = 2, effect_id = 20022,is_forever = true},
	   		{ event = 'moveAction', handle_id=1001, delay = 0.4, pos_type = 3,end_pos = {-1000, -20}, effect_id = 20022, runtime =0.8},
	   		{ event = 'removeEffect', delay = 1.1, handle_id=1001, effect_id=20004},
	   		{ event = 'changeRGBA',delay=0.1,dur=1.6,txt = "", zOrder = 1, black_value = 125,cont_time = 1.5},

	   		{ event = 'move', delay = 0.3,handle_id = 11, dir = 1, pos = {659,690},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.3,handle_id = 12, dir = 1, pos = {724,656},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.3,handle_id = 13, dir = 1, pos = {777,624},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.3,handle_id = 14, dir = 1, pos = {845,583},speed = 340, dur = 1 ,end_dir = 3},

			{ event = 'move', delay = 0.3,handle_id = 1, dir = 1, pos = {939,500},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.3,handle_id = 5, dir = 1, pos = {877,470},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'move', delay = 0.3,handle_id = 6, dir = 1, pos = {816,423},speed = 340, dur = 1 ,end_dir = 3},
		},

		--众人惊讶
		{
			-- { event = 'camera', delay = 0.1, c_topox={982,758}, sdur=0.1, dur = 0.5,style = '',backtime=1},
	       
			{ event = 'talk', delay= 0.4, handle_id = 13, talk='那是什么！！！', dur=2 },
	   		{ event = 'talk', delay= 0.4, handle_id = 11, talk='彗星！！！', dur=2 },
	   		
	   		-- { event = 'effect', handle_id=1 delay = 2.0, pos = {76, 107}, layer = 2, effect_id = 20004, dx = 0,dy = 30,is_forever = true},
		},

		--丽华解释
		{
			{ event = 'camera', delay = 0.1, c_topox={893,468} , sdur=0.1, dur = 0.5,style = '',backtime=1},
			{ event = 'talk', delay= 0.1, handle_id = 1, talk='星孛于张！', dur=2 },
	   		{ event = 'talk', delay= 1, handle_id = 5, talk='？', dur=1.5 },

	  --  		{ event = 'move', delay = 1,handle_id = 11, dir = 1, pos = {853,817},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 12, dir = 1, pos = {913,782},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 13, dir = 1, pos = {982,758},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 14, dir = 1, pos = {1045,720},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 15, dir = 1, pos = {911,875},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 16, dir = 1, pos = {977,849},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 17, dir = 1, pos = {1042,818},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 1,handle_id = 18, dir = 1, pos = {1105,788},speed = 340, dur = 1 ,end_dir = 7},
		},

		--刘秀出面说明
		{
			{ event = 'move', delay = 0.8,handle_id = 1, dir = 1, pos = {939,500},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.8,handle_id = 5, dir = 1, pos = {877,470},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.8,handle_id = 6, dir = 1, pos = {816,423},speed = 340, dur = 1 ,end_dir = 5},


			{ event = 'camera', delay = 0.1, c_topox={607,502} , sdur=0.1, dur = 0.5,style = '',backtime=1},
			{ event='createActor', delay=0.1, handle_id=3, body=12, pos={524,758}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },
			{ event = 'move', delay = 0.2,handle_id = 3, dir = 1, pos = {662,598},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'talk', delay= 1, handle_id = 3, talk='《易经》曰：星孛于张，东南行即翼、轸之分。', dur=3 },
	   		{ event = 'talk', delay= 4.3, handle_id = 3, talk='意指周、楚之地将有兵乱，是为除旧兴国之意。', dur=3 },
	   		{ event = 'talk', delay= 7.6, handle_id = 3, talk='慧星之出，天为民之乱见之！如今天命所授，逆贼当诛，汉室必复！', dur=3 },

	   		{ event = 'move', delay = 10.9,handle_id = 3, dir = 1, pos = {662,598},speed = 340, dur = 1 ,end_dir = 7},
	   		{ event = 'talk', delay= 10.9, handle_id = 3, talk='秀当从于天意，追随大哥，光复汉室江山！！', dur=2 },

	   		{ event = 'move', delay = 0.8,handle_id = 11, dir = 1, pos = {659,690},speed = 340, dur = 1 ,end_dir = 7},	
			{ event = 'move', delay = 0.8,handle_id = 12, dir = 1, pos = {754,686},speed = 340, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.8,handle_id = 13, dir = 1, pos = {807,654},speed = 340, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.8,handle_id = 14, dir = 1, pos = {845,583},speed = 340, dur = 1 ,end_dir = 7},
		},

		--丽华站出来造势
		{
			-- { event = 'move', delay = 0.5,handle_id = 11, dir = 1, pos = {689,720},speed = 340, dur = 1 ,end_dir = 7},	
			-- { event = 'move', delay = 0.5,handle_id = 12, dir = 1, pos = {754,686},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 0.5,handle_id = 13, dir = 1, pos = {807,654},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 0.5,handle_id = 14, dir = 1, pos = {875,613},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 0.5,handle_id = 15, dir = 1, pos = {744,780},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 0.5,handle_id = 16, dir = 1, pos = {823,755},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 0.5,handle_id = 17, dir = 1, pos = {884,721},speed = 340, dur = 1 ,end_dir = 7},
			-- { event = 'move', delay = 0.5,handle_id = 18, dir = 1, pos = {936,688},speed = 340, dur = 1 ,end_dir = 7},

			{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {724,558},speed = 340, dur = 1 ,end_dir = 7},


			{ event = 'talk', delay= 0.3, handle_id = 1, talk='逆贼当诛！汉室必复！', dur=2 },
	   		{ event = 'talk', delay= 1, handle_id = 5, talk='逆贼当诛！汉室必复！', dur=2 },
	   		-- { event = 'talk', delay= 1, handle_id = 6, talk='逆贼当诛！汉室必复！', dur=2 },
	   		{ event = 'talk', delay= 1, handle_id = 11, talk='逆贼当诛！汉室必复！', dur=2 },
	   		{ event = 'talk', delay= 1, handle_id = 13, talk='逆贼当诛！汉室必复！', dur=2 },
	   		{ event = 'talk', delay= 1, handle_id = 16, talk='逆贼当诛！汉室必复！', dur=2 },
	   		{ event = 'talk', delay= 1, handle_id = 18, talk='逆贼当诛！汉室必复！', dur=2 },
		},

		--刘縯说话，刘稷应和
		{
			-- { event = 'move', delay = 0.1,handle_id = 4, dir = 1, pos = {2338,1120},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'talk', delay= 0.1, handle_id = 2, talk='自今日起，我刘伯升便是柱天都部！', dur=2.5 },

			{ event = 'move', delay = 2.8,handle_id = 5, dir = 1, pos = {781,533},speed = 340, dur = 2.3 ,end_dir = 7},
	   		{ event = 'talk', delay= 2.8, handle_id = 5, talk='我们誓死追随柱天都部！', dur=2 },
		},


	},

	--============================================wuwenbin  剧情副本第三章第一节 end    =====================================----

	--============================================wuwenbin  剧情副本第三章第二节 start    =====================================----
	['juqing321'] = {	

        --创建角色
        -- 演员表 1 刘縯 2 城守 3 新野尉 101-105 汉军 201-210 长聚守军
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={556,1554}, dir=1, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=43, pos={1484,1522}, dir=5, speed=340, name_color=0xffffff, name="城守", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=21, pos={1544,1544}, dir=5, speed=340, name_color=0xffffff, name="新野尉", },


	   		--汉军
	   		{ event='createActor', delay=0.1, handle_id=101, body=26, pos={364,1558}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=26, pos={430,1590}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=103, body=26, pos={492,1620}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=26, pos={546,1646}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=105, body=26, pos={620,1674}, dir=1, speed=340, name_color=0xffffff, name="汉军", },

	   		{ event='createActor', delay=0.1, handle_id=106, body=25, pos={304,1618}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=107, body=25, pos={360,1642}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=108, body=25, pos={444,1678}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=109, body=25, pos={490,1700}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=110, body=25, pos={558,1744}, dir=1, speed=340, name_color=0xffffff, name="汉军", },

	   		{ event='createActor', delay=0.1, handle_id=111, body=25, pos={230,1678}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=112, body=25, pos={304,1708}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=113, body=25, pos={364,1742}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=114, body=25, pos={440,1776}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=115, body=25, pos={500,1816}, dir=1, speed=340, name_color=0xffffff, name="汉军", },


	   		--长聚守军
	   		{ event='createActor', delay=0.1, handle_id=201, body=27, pos={1488,1428}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=202, body=27, pos={1560,1448}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=203, body=27, pos={1628,1484}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=204, body=27, pos={1674,1520}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=205, body=27, pos={1738,1554}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },

	   		{ event='createActor', delay=0.1, handle_id=206, body=28, pos={1588,1396}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=207, body=28, pos={1648,1422}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=208, body=28, pos={1708,1460}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },	 
	   		{ event='createActor', delay=0.1, handle_id=209, body=28, pos={1778,1488}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=210, body=28, pos={1836,1518}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },	   		
	   	},

	   	--镜头初始化并跟随
	   	{
	   		-- { event ='camera', delay = 0.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1}, 
	   		{ event='init_cimera', delay = 0.1,mx= 564,my = 1552 }, 	 
	    },

	    --刘縯挑衅城守
	    {
	   		{ event = 'talk', delay= 1, handle_id = 1, talk='[a]舂陵刘縯在此！谁来领死！', dur=2 , emote = { a= 45}},
	    },

	     --城守受挑衅，上当出战
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={1534,1498} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event = 'talk', delay= 0.5, handle_id = 2, talk='一群乌合之众。', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 3, talk='小心，不可轻敌。', dur=1.5 },
	   	},
	   	{
	   		{ event = 'camera', delay = 1, c_topox={756,1482} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event = 'move', delay = 0.5,handle_id = 2, dir = 1, pos = {890,1428},speed = 260, dur = 1.5 ,end_dir = 5},
	   		-- { event = 'talk', delay= 1.5, handle_id = 2, talk='无名小卒，速来和我一战！', dur=1.5 },
	    },

	    --刘縯跳过去斩杀城守
	    {
	    	{ event = 'talk', delay= 0.8, handle_id = 1, talk='来得正好！', dur=1.5 },
	    	{ event = 'jump', delay= 0.8, handle_id= 1,pos={820,1448}, speed=200, dur=1, dir = 1, end_dir=1 },
	    	
	    	{ event='playAction', delay = 1.4, handle_id=1, action_id=2, dur=1.5, dir=1, loop=false ,},	
	    	{ event='playAction', delay = 1.6, handle_id=2, action_id=4, dur=1.5, dir=5, loop=false , once = true},	
	    },

	    --刘縯带领士兵冲杀
	    {
	   		-- { event = 'camera', delay = 0.1, c_topox={130,1218} , sdur=0.1, dur = 1,style = '',backtime=1},
	   		{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {556,1554},speed = 340, dur = 1 ,end_dir = 5},
	   		{ event = 'talk', delay= 1, handle_id = 1, talk='弟兄们，杀——！', dur=1.5 },
	   	},
	   	{
	   		{ event = 'talk', delay= 0.5, handle_id = 101, talk='杀——！', dur=1.5 },
	   		{ event = 'talk', delay= 0.5, handle_id = 103, talk='杀——！', dur=1.5 },
	   		{ event = 'talk', delay= 0.5, handle_id = 105, talk='杀——！', dur=1.5 },
	   		{ event = 'talk', delay= 0.5, handle_id = 107, talk='杀——！', dur=1.5 },
	   		{ event = 'talk', delay= 0.5, handle_id = 110, talk='杀——！', dur=1.5 },
	   		{ event = 'talk', delay= 0.5, handle_id = 112, talk='杀——！', dur=1.5 },
	   		{ event = 'talk', delay= 0.5, handle_id = 115, talk='杀——！', dur=1.5 },

	   		{ event = 'move', delay = 0.3,handle_id = 1, dir = 1, pos = {1628,1484},speed = 340, dur = 1 ,end_dir = 5},

	   		{ event = 'move', delay = 0.8,handle_id=101, dir = 1, pos = {1488,1428},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=102, dir = 1, pos = {1560,1448},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=103, dir = 1, pos = {1628,1484},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=104, dir = 1, pos = {1674,1520},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=105, dir = 1, pos = {1738,1554},speed = 340, dur = 1 ,end_dir = 3}, 

	   		{ event = 'move', delay = 0.8,handle_id=106, dir = 1, pos = {1488,1428},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=107, dir = 1, pos = {1560,1448},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=108, dir = 1, pos = {1628,1484},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=109, dir = 1, pos = {1674,1520},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=110, dir = 1, pos = {1738,1554},speed = 340, dur = 1 ,end_dir = 3}, 
	   		
	   		{ event = 'move', delay = 0.8,handle_id=111, dir = 1, pos = {1488,1428},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=112, dir = 1, pos = {1560,1448},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=113, dir = 1, pos = {1628,1484},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=114, dir = 1, pos = {1674,1520},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=115, dir = 1, pos = {1738,1554},speed = 340, dur = 1 ,end_dir = 3}, 


	    },

	    --镜头给新野尉，守军逃走
	    {
	    	-- { event='kill', delay=0.3, handle_id=101},
	    	-- { event='kill', delay=0.3, handle_id=102},
	    	-- { event='kill', delay=0.3, handle_id=103},
	    	-- { event='kill', delay=0.3, handle_id=104},
	    	-- { event='kill', delay=0.3, handle_id=105},
	    	-- { event='kill', delay=0.3, handle_id=106},
	    	-- { event='kill', delay=0.3, handle_id=107},
	    	-- { event='kill', delay=0.3, handle_id=108},
	    	-- { event='kill', delay=0.3, handle_id=109},
	    	-- { event='kill', delay=0.3, handle_id=110},
	    	-- { event='kill', delay=0.3, handle_id=111},
	    	-- { event='kill', delay=0.3, handle_id=112},
	    	-- { event='kill', delay=0.3, handle_id=113},
	    	-- { event='kill', delay=0.3, handle_id=114},
	    	-- { event='kill', delay=0.3, handle_id=115},
	    	-- { event='kill', delay=0.3, handle_id=1},


	    	{ event = 'camera', delay = 0.1, c_topox={1809,1451} , sdur=0.1, dur = 0.3,style = '',backtime=1},
	    	{ event = 'talk', delay= 0.5, handle_id = 3, talk='快撤！撤回去！[a]', dur=1.5 , emote = {a =41}},
	   		{ event = 'talk', delay= 0.5, handle_id = 1, talk='', dur=1.5 },

	   		{ event = 'talk', delay= 0.5, handle_id = 201, talk='[a]', dur=2 , emote = {a =41}},
	   		{ event = 'talk', delay= 0.5, handle_id = 207, talk='[a]', dur=2 , emote = {a =41}},
	   		{ event = 'talk', delay= 0.5, handle_id = 210, talk='[a]', dur=2 , emote = {a =41}},
	   		{ event = 'move', delay = 0.8,handle_id=3, dir = 1, pos = {2444,398},speed = 340, dur = 1 ,end_dir = 3},
	   		{ event = 'move', delay = 0.8,handle_id=201, dir = 1, pos = {2444,398},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=202, dir = 1, pos = {2636,402},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=203, dir = 1, pos = {2636,402},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=204, dir = 1, pos = {2444,398},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=205, dir = 1, pos = {2636,402},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=206, dir = 1, pos = {2444,398},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=207, dir = 1, pos = {2868,1496},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=208, dir = 1, pos = {2444,398},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=209, dir = 1, pos = {2636,402},speed = 340, dur = 1 ,end_dir = 3}, 
	   		{ event = 'move', delay = 0.8,handle_id=210, dir = 1, pos = {2868,1496},speed = 340, dur = 1 ,end_dir = 3}, 
	    },

	},

	['juqing322'] = {	

        --创建角色
        -- 演员表 1 阴戟 2 刘秀  3 刘稷 
	    {
	   		-- { event='createActor', delay=0.1, handle_id=1, body=5, pos={2476,680}, dir=5, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={1484,506}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },


	   		--汉军
	   		{ event='createActor', delay=0.1, handle_id=101, body=25, pos={2868,556}, dir=1, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=25, pos={2842,430}, dir=6, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=103, body=25, pos={2634,472}, dir=3, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=25, pos={2580,268}, dir=3, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=105, body=25, pos={2642,760}, dir=4, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=106, body=25, pos={2486,684}, dir=5, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=107, body=25, pos={2038,1232}, dir=6, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=108, body=25, pos={1900,1400}, dir=7, speed=340, name_color=0xffffff, name="汉军", },


	   		--长聚守军
	   		{ event='createActor', delay=0.1, handle_id=201, body=27, pos={2868,556}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=202, body=27, pos={2842,430}, dir=2, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=203, body=27, pos={2634,472}, dir=7, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=204, body=27, pos={2580,268}, dir=3, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=205, body=27, pos={2264,400}, dir=4, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=206, body=27, pos={2322,744}, dir=5, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=207, body=27, pos={2000,1300}, dir=2, speed=340, name_color=0xffffff, name="长聚守军", },
	   		{ event='createActor', delay=0.1, handle_id=208, body=27, pos={1836,1360}, dir=3, speed=340, name_color=0xffffff, name="长聚守军", },	

	   		--汉军、守军的尸体
	   		{ event = 'playAction', handle_id= 101, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 102, delay = 0.2, action_id = 4, dur = 0.1, dir = 7,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 103, delay = 0.2, action_id = 4, dur = 0.1, dir = 4,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 104, delay = 0.2, action_id = 4, dur = 0.1, dir = 3,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 105, delay = 0.2, action_id = 4, dur = 0.1, dir = 1,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 106, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 107, delay = 0.2, action_id = 4, dur = 0.1, dir = 2,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 108, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},

	   		{ event = 'playAction', handle_id= 201, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 202, delay = 0.2, action_id = 4, dur = 0.1, dir = 4,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 203, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 204, delay = 0.2, action_id = 4, dur = 0.1, dir = 6,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 205, delay = 0.2, action_id = 4, dur = 0.1, dir = 7,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 206, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 207, delay = 0.2, action_id = 4, dur = 0.1, dir = 2,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 208, delay = 0.2, action_id = 4, dur = 0.1, dir = 1,loop = false ,once = true},
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1946,my = 1328 }, 	
	    },

	    --镜头移动
	    {
	    	{ event = 'camera', delay = 1, c_topox={2474,756} , sdur=0.1, dur = 1,style = '',backtime=1},
	   		{ event = 'camera', delay = 3, c_topox={2638,464} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event = 'camera', delay = 5, target_id = 2 , sdur=0.1, dur = 1,style = 'follow',backtime=1},
		-- },

		-- --刘秀四下寻找
		-- {
			{ event = 'move', delay = 5.1,handle_id = 2, dir = 1, pos = {1300,444},speed = 340, dur = 1 ,end_dir = 6},
			{ event = 'talk', delay= 5.1, handle_id = 2, talk='丽……阴戟——', dur=2 },

			{ event = 'move', delay = 7,handle_id = 2, dir = 1, pos = {1688,440},speed = 340, dur = 1 ,end_dir = 1},
			{ event = 'talk', delay= 7.7, handle_id = 2, talk='阴戟——！', dur=2 },

			{ event='createActor', delay=6, handle_id=3, body=20, pos={2222,336}, dir=5, speed=340, name_color=0xffffff, name="刘稷", },
		},

		--刘秀问刘稷
		{
			
	      	{ event = 'move', delay = 0.1,handle_id = 2, dir = 1, pos = {2154,364},speed = 340, dur = 1 ,end_dir = 1},
			{ event = 'talk', delay= 0.5, handle_id = 2, talk='[a]阿稷，可见到阴戟了？', dur=2 ,emote = { a= 23}},
			{ event = 'talk', delay= 2.5, handle_id = 3, talk='方才见他好像往城东去了。', dur=2 },
		},

		--丽华牵马过来了
		{
			{ event = 'camera', delay = 0.2, target_id = 1 , sdur=0.1, dur = 0.5,style = 'follow',backtime=1},

			{ event='createActor', delay=0.1, handle_id=1, body=5, pos={2824,722}, dir=5, speed=340, name_color=0xffffff, name="阴戟", },
			{ event='createActor', delay=0.1, handle_id="111", is_mount=true, pos={2896,754}, speed=340, dir = 7,mount_id = 6},

			{ event = 'move', delay = 0.3,handle_id = 1, dir = 1, pos = {2672,626},speed = 340, dur = 1 ,end_dir = 7},
			{ event = 'move', delay = 0.3,handle_id = "111", dir = 1, pos = {2758,692},speed = 340, dur = 1 ,end_dir = 7},

			{ event = 'move', delay = 0.1,handle_id = 2, dir = 1, pos = {2604,596},speed = 340, dur = 1 ,end_dir = 3},
			{ event = 'talk', delay= 0.5, handle_id = 1, talk='三哥!', dur=2 },

			{ event = 'camera', delay = 2.4, target_id = 2 , sdur=0.1, dur = 0.3,style = 'follow',backtime=1},
		},

		--刘秀迎上去,发现战马，感谢丽华
		{
			
			-- { event = 'move', delay = 0.1,handle_id = 4, dir = 1, pos = {2338,1120},speed = 340, dur = 1 ,end_dir = 5},
			{ event = 'talk', delay= 0.1, handle_id = 2, talk='[a]你去哪里了？乱跑什么。', dur=2 ,emote = { a= 23}},
	   		{ event = 'talk', delay= 2, handle_id = 1, talk='我给你夺了一匹战马回来，喏！', dur=2 },
	   		{ event = 'talk', delay= 4.2, handle_id = 2, talk='[a]', dur=2 ,emote = { a= 48}},
	   		{ event = 'talk', delay= 4.2, handle_id = 1, talk='[a]', dur=2 ,emote = { a= 18}},
		},
	},

	--============================================wuwenbin  剧情副本第三章第二节 end    =====================================----

  --============================================luyao  剧情副本第三章第三节 start    =====================================----	
	['juqing331'] = {	

	   	{



	   		{ event='createActor', delay=0.1, handle_id=1, body=5 , pos={1066,2565}, dir=2, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=14, pos={1308,2662}, dir=2, speed=340, name_color=0xffffff, name="刘縯", },--
	   		{ event='createActor', delay=0.1, handle_id=3, body=12, pos={1215,2717}, dir=2, speed=340, name_color=0xffffff, name="刘秀", },--
	   		{ event='createActor', delay=0.1, handle_id=4, body=20, pos={1036,2606}, dir=2, speed=340, name_color=0xffffff, name="刘稷", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=1 , pos={1034,2705}, dir=2, speed=340, name_color=0xffffff, name="朱佑", },

	   		{ event='createActor', delay=0.1, handle_id=7 , body=25, pos={950,2600}, dir=2, speed=340, name_color=0xffffff, name="舂陵将士", },
	   		{ event='createActor', delay=0.1, handle_id=8 , body=25, pos={850,2600}, dir=2, speed=340, name_color=0xffffff, name="舂陵将士", },
	   		{ event='createActor', delay=0.1, handle_id=9 , body=25, pos={950,2700}, dir=2, speed=340, name_color=0xffffff, name="舂陵将士", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=25, pos={850,2700}, dir=2, speed=340, name_color=0xffffff, name="舂陵将士", },
	   		{ event='createActor', delay=0.1, handle_id=19, body=25, pos={900,2500}, dir=2, speed=340, name_color=0xffffff, name="舂陵将士", },
	   		{ event='createActor', delay=0.1, handle_id=20, body=25, pos={900,2800}, dir=2, speed=340, name_color=0xffffff, name="舂陵将士", },	   	

	   		{ event = 'move', delay = 0.8,handle_id=1, dir = 1, pos = {1466,2565},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=2, dir = 1, pos = {1708,2662},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=3, dir = 1, pos = {1615,2717},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=4, dir = 1, pos = {1436,2606},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=5, dir = 1, pos = {1434,2705},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=7, dir = 1, pos = {1350,2600},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=8, dir = 1, pos = {1250,2600},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=9, dir = 1, pos = {1350,2700},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=10, dir = 1, pos = {1250,2700},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=19, dir = 1, pos = {1300,2500},speed = 500, dur = 1 ,end_dir = 2}, 
	   		{ event = 'move', delay = 0.8,handle_id=20, dir = 1, pos = {1300,2800},speed = 500, dur = 1 ,end_dir = 2}, 

	   		{ event='createActor', delay=0.1, handle_id=6, body=43, pos={2400,2700}, dir=6, speed=340, name_color=0xffffff, name="岑彭", },

	   		{ event='createActor', delay=0.1, handle_id=11, body=27, pos={2700,2850}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=28, pos={2500,2650}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=13, body=27, pos={2600,2650}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=14, body=27, pos={2700,2650}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=15, body=27, pos={2700,2550}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=16, body=28, pos={2504,2750}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=17, body=27, pos={2600,2752}, dir=6, speed=340, name_color=0xffffff, name="新军", },
	   		{ event='createActor', delay=0.1, handle_id=18, body=27, pos={2700,2750}, dir=6, speed=340, name_color=0xffffff, name="新军", },

			{ event='effect', handle_id=101, target_id=11, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=102, target_id=6 , delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=103, target_id=12, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=104, target_id=13, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=105, target_id=14, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=106, target_id=15, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=107, target_id=16, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=108, target_id=17, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=109, target_id=18, delay = 0.2 , pos={5, 90}, effect_id=20005, is_forever = true},
--[[
			{ event='effect', handle_id=121, target_id=11, delay = 0.2 , pos={25, 90}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=122, target_id=6 , delay = 0.2 , pos={45, 90}, effect_id=20004, is_forever = true},		   		
			{ event='effect', handle_id=123, target_id=12, delay = 0.2 , pos={65, 90}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=124, target_id=13, delay = 0.2 , pos={25, 90}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=125, target_id=14, delay = 0.2 , pos={45, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=126, target_id=15, delay = 0.2 , pos={65, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=127, target_id=16, delay = 0.2 , pos={25, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=128, target_id=17, delay = 0.2 , pos={45, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=129, target_id=18, delay = 0.2 , pos={65, 90}, effect_id=20004, is_forever = true},

			{ event='effect', handle_id=131, target_id=11, delay = 0.2 , pos={35, 90}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=132, target_id=6 , delay = 0.2 , pos={55, 90}, effect_id=20004, is_forever = true},		   		
			{ event='effect', handle_id=133, target_id=12, delay = 0.2 , pos={75, 90}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=134, target_id=13, delay = 0.2 , pos={35, 90}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=135, target_id=14, delay = 0.2 , pos={55, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=136, target_id=15, delay = 0.2 , pos={75, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=137, target_id=16, delay = 0.2 , pos={35, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=138, target_id=17, delay = 0.2 , pos={55, 90}, effect_id=20004, is_forever = true},
			{ event='effect', handle_id=139, target_id=18, delay = 0.2 , pos={75, 90}, effect_id=20004, is_forever = true},
]]
	
			{ event='effect', handle_id=110,  delay = 0.2 , pos={1763,2611}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=111,  delay = 0.2 , pos={2012,2864}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=112,  delay = 0.2 , pos={1946,2805}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=113,  delay = 0.2 , pos={2435,2811}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=110,  delay = 0.2 , pos={1763,2611}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=111,  delay = 0.2 , pos={2012,2864}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=112,  delay = 0.2 , pos={1946,2805}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=113,  delay = 0.2 , pos={2435,2811}, effect_id=20005, is_forever = true},

			{ event='effect', handle_id=110,  delay = 0.2 , pos={1863,2611}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=111,  delay = 0.2 , pos={2112,2864}, effect_id=20004, is_forever = true},		   		
			{ event='effect', handle_id=112,  delay = 0.2 , pos={1846,2805}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=113,  delay = 0.2 , pos={2535,2811}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=110,  delay = 0.2 , pos={1863,2611}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=111,  delay = 0.2 , pos={2112,2864}, effect_id=20004, is_forever = true},		   		
			{ event='effect', handle_id=112,  delay = 0.2 , pos={1846,2805}, effect_id=20004, is_forever = true},	
			{ event='effect', handle_id=113,  delay = 0.2 , pos={2535,2811}, effect_id=20004, is_forever = true},


	   		{ event='init_cimera', delay = 0.2,mx= 1379,my = 2630 ,dur= 1.5}, 

	   		{ event ='camera', delay = 2.5, c_topox = {2429,2686}, sdur=0.3, dur = 0.2,backtime=1},

--			{ event= 'zoom', delay=3, sValue=1.0, eValue=0.6, dur=0.6 },	

	   		{ event ='camera', delay = 4.5, c_topox = {1579,2580}, sdur=0.3, dur = 0.2,backtime=1},

--			{ event= 'zoom', delay=3.5, sValue=0.6, eValue=1, dur=0.6 },	
	   	},


	   	{

	   		{ event = 'talk', delay= 0.1, handle_id = 2, talk='！！！', dur=1 },	 
	   		{ event = 'talk', delay= 1.5, handle_id = 2, talk='不好。', dur=1.8 },	 
	    	{ event='showTopTalk', delay=3.5, dialog_id='3_3_1' ,dialog_time = 2,},  -- 下部弹出窗口通过	   			   	
	   	},

	   	{

	   		{ event ='camera', delay = 0.1, c_topox = {2429,2586}, sdur=0.3, dur = 0.2,backtime=1},

	   		--====================删除特效====================--

	   		{ event = 'removeEffect', delay = 0.3, handle_id=101, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.4, handle_id=102, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.5, handle_id=103, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.6, handle_id=104, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.7, handle_id=105, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.5, handle_id=106, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.4, handle_id=107, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.5, handle_id=108, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=109, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.6, handle_id=110, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.3, handle_id=111, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=112, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.4, handle_id=113, effect_id=20004},
	   		{ event = 'removeEffect', delay = 1.1, handle_id=114, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.2, handle_id=115, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.3, handle_id=116, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.4, handle_id=117, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.8, handle_id=118, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.9, handle_id=119, effect_id=20004},
--[[	   		
	   		{ event = 'removeEffect', delay = 0.1, handle_id=121, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=122, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=123, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=124, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=125, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=126, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=127, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=128, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=129, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=131, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=132, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=133, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=134, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=135, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=136, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=137, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=138, effect_id=20004},
	   		{ event = 'removeEffect', delay = 0.1, handle_id=139, effect_id=20004},
]]
	   		--====================删除特效====================--

	   		{ event = 'move', delay = 0.2,handle_id=6, dir = 1, pos = {1200,2700},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=11, dir = 1, pos = {600,2750},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=12, dir = 1, pos = {1300,2650},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=13, dir = 1, pos = {1400,2650},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=14, dir = 1, pos = {1500,2650},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=15, dir = 1, pos = {1600,2650},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=16, dir = 1, pos = {1304,2750},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=17, dir = 1, pos = {1400,2752},speed = 500, dur = 1 ,end_dir = 6}, 
	   		{ event = 'move', delay = 0.2,handle_id=18, dir = 1, pos = {1500,2750},speed = 500, dur = 1 ,end_dir = 6}, 

	   		{ event = 'talk', delay= 0.5, handle_id = 11, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 12, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 13, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 14, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 15, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 16, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 17, talk='杀！', dur=3 },	
	   		{ event = 'talk', delay= 0.5, handle_id = 18, talk='杀！', dur=3 },	

	   		{ event ='camera', delay = 1.5, c_topox = {1579,2530}, sdur=2.3, dur = 2.2,backtime=1},
			{ event= 'zoom', delay=1.6, sValue=1.0, eValue=1.5, dur=2.2 },	


	   		{ event = 'talk', delay= 2.5, handle_id = 2, talk='[a]',emote={a=24}, dur=1.8 },	

	   		{ event = 'talk', delay= 4.5, handle_id = 2, talk='有埋伏！快撤——！！', dur=1.8 },	

	   		{ event = 'move', delay = 4.2,handle_id=1, dir = 1, pos = {766,2565},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=2, dir = 1, pos = {908,2662},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=3, dir = 1, pos = {765,2717},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=4, dir = 1, pos = {686,2606},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=5, dir = 1, pos = {684,2705},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=7, dir = 1, pos = {550,2600},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=8, dir = 1, pos = { 450,2600},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=9, dir = 1, pos = {550,2700},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=10, dir = 1, pos = {350,2700},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=19, dir = 1, pos = {400,2500},speed = 400, dur = 3 ,end_dir = 6}, 
	   		{ event = 'move', delay = 4.2,handle_id=20, dir = 1, pos = {400,2800},speed = 400, dur = 3 ,end_dir = 6}, 

	   		{ event = 'talk', delay= 5.5, handle_id = 6, talk='生擒刘縯——赏金千两！', dur=1.8 },	

	   	--	{ event = 'talk', delay= 6.5, handle_id = 11, talk='莫走了刘縯——生擒刘縯。', dur=1.5 },
	   	--	{ event = 'talk', delay= 6.5, handle_id = 12, talk='莫走了刘縯——生擒刘縯。', dur=1.5 },
	   	--	{ event = 'talk', delay= 6.5, handle_id = 13, talk='莫走了刘縯——生擒刘縯。', dur=1.5 },
	   	--	{ event = 'talk', delay= 6.5, handle_id = 14, talk='莫走了刘縯——生擒刘縯。', dur=1.5 },
	   	--	{ event = 'talk', delay= 6.5, handle_id = 15, talk='莫走了刘縯——生擒刘縯。', dur=1.5 },
	   		{ event = 'talk', delay= 6.5, handle_id = 16, talk='生擒刘縯——', dur=1.5 },
	   	--	{ event = 'talk', delay= 6.5, handle_id = 17, talk='莫走了刘縯——生擒刘縯。', dur=1.5 },
	   		{ event = 'talk', delay= 7, handle_id = 18, talk='莫走了刘縯——', dur=1.5 },

			{ event= 'zoom', delay=4.2, sValue=1.5, eValue=1, dur=2 },	

	   	},


	},

	['juqing332'] = {	


	  
	   	{


			{ event='effect', handle_id=101,  delay = 0.2 , pos={2963,2675}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=102,  delay = 0.2 , pos={2834,2473}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=103,  delay = 0.2 , pos={2579,2541}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=104,  delay = 0.2 , pos={2384,2352}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=105,  delay = 0.2 , pos={2121,2380}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=106,  delay = 0.2 , pos={2413,2478}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=107,  delay = 0.2 , pos={2572,2638}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=108,  delay = 0.2 , pos={2345,2706}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=109,  delay = 0.2 , pos={2803,2705}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=110,  delay = 0.2 , pos={2219,2608}, effect_id=20005, is_forever = true},

			{ event='effect', handle_id=111,  delay = 0.2 , pos={1992,2750}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=112,  delay = 0.2 , pos={2256,2745}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=113,  delay = 0.2 , pos={2247,2632}, effect_id=20005, is_forever = true},			

	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={3200,2800}, dir=7, speed=340, name_color=0xffffff, name="阴戟", },

	   		{ event='init_cimera', delay = 0.2,mx= 2550,my = 2550 ,dur= 1.5}, 

	    	{ event='showTopTalk', delay=0.5, dialog_id='3_3_2' ,dialog_time = 2,},  -- 前置	   

	   		{ event = 'removeEffect', delay = 2.3, handle_id=101, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.4, handle_id=102, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.5, handle_id=103, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.6, handle_id=104, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.7, handle_id=105, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.8, handle_id=106, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.5, handle_id=107, effect_id=20005},
	   		{ event = 'removeEffect', delay = 2.4, handle_id=108, effect_id=20005},
	   		{ event = 'removeEffect', delay = 1.6, handle_id=109, effect_id=20005},
	   		{ event = 'removeEffect', delay = 1.9, handle_id=110, effect_id=20005},

	    	{ event = 'camera', delay = 1.5, c_topox={2850,2550} , sdur=0.5, dur = 0.5,style = '',backtime=1},
			{ event = 'move', delay = 1.1, handle_id=1, dir = 1, pos = {2763,2675},speed = 300, dur = 1 ,end_dir = 6},
	   		{ event = 'talk', delay= 2.3, handle_id = 1 , talk='三哥——', dur=1.8 },	
			{ event = 'move', delay = 4.2, handle_id=1, dir = 1, pos = {2870,2584},speed = 300, dur = 1 ,end_dir = 1},
	   		{ event = 'talk', delay= 5.3, handle_id = 1 , talk='伯升大哥——', dur=1.8 },	


	   		
	   	},

	   	{

	    	{ event = 'camera', delay = 0.1, c_topox={2735,2580} , sdur=0.5, dur = 0.5,style = '',backtime=1},

	   		{ event='createActor', delay=0.1, handle_id=2, body=25, pos={2135,2640}, dir=2, speed=340, name_color=0xffffff, name="汉军士兵", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=25, pos={2017,2711}, dir=2, speed=340, name_color=0xffffff, name="汉军士兵", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=25, pos={2007,2795}, dir=2, speed=340, name_color=0xffffff, name="汉军士兵", },
	   		
	   		{ event = 'removeEffect', delay = 0.4, handle_id=111, effect_id=20005},
	   		{ event = 'removeEffect', delay = 0.6, handle_id=112, effect_id=20005},
	   		{ event = 'removeEffect', delay = 0.9, handle_id=113, effect_id=20005},

	   		{ event = 'move', delay = 0.2,handle_id = 2, dir = 1, pos = {3241,2231},speed = 260, dur = 1.5 ,end_dir = 2},
	   		{ event = 'move', delay = 0.2,handle_id = 3, dir = 1, pos = {2568,2653},speed = 260, dur = 1.5 ,end_dir = 2},
	   		{ event = 'move', delay = 0.2,handle_id = 4, dir = 1, pos = {3241,2231},speed = 260, dur = 1.5 ,end_dir = 2},

			{ event = 'move', delay = 0.2, handle_id=1, dir = 1, pos = {2870,2584},speed = 300, dur = 0.5 ,end_dir = 6},

			{ event = 'move', delay = 1.2, handle_id=1, dir = 1, pos = {2638,2653},speed = 300, dur = 1 ,end_dir = 6},

	   		{ event = 'talk', delay= 3, handle_id = 1 , talk='刘将军呢，他们在哪里！', dur=1.8 },	

	   		{ event = 'talk', delay= 5, handle_id = 3 , talk='死了，都死了。', dur=1.8 },	

	   		{ event = 'move', delay = 6.5,handle_id = 3, dir = 1, pos = {3241,2231},speed = 260, dur = 1.5 ,end_dir = 2},	

	   		{ event = 'talk', delay= 7, handle_id = 3 , talk='[a]', emote={a=22}, dur=1.8 },

	   		{ event = 'move', delay = 6.8,handle_id = 1, dir = 1, pos = {2638,2653},speed = 260, dur = 0.2 ,end_dir = 1},	

	   		{ event = 'move', delay = 8.5,handle_id = 1, dir = 6, pos = {2638,2653},speed = 260, dur = 0.2 ,end_dir = 6},	

	   		{ event = 'talk', delay= 8, handle_id = 1 , talk='不会的，他们不会死的。', dur=1.8 },	

	   		{ event='createActor', delay=0.1, handle_id=5, body=17, pos={1319,2670}, dir=2, speed=340, name_color=0xffffff, name="刘伯姬", },

	   	},
	   	{
	   	
	    	{ event = 'camera', delay = 0.1, c_topox={1499,2634} , sdur=0.5, dur = 0.5,style = '',backtime=1},
	   		{ event = 'move', delay = 0.2,handle_id = 5, dir = 2, pos = {1705,2763},speed = 350, dur = 2 ,end_dir = 3},	

	   		{ event = 'talk', delay= 0.3, handle_id = 5 , talk='救命——救命啊——', dur=1.8 },	
	    	{ event = 'camera', delay = 2.1, c_topox={1899,2534} , sdur=0.5, dur = 0.5,style = '',backtime=1},

	   		{ event='createActor', delay=2.8, handle_id=6, body=12, pos={2219,2670}, dir=2, speed=340, name_color=0xffffff, name="刘秀", },	    

	   		{ event = 'move', delay = 2.9,handle_id = 6, dir = 6, pos = {1984,2656},speed = 260, dur = 0.2 ,end_dir = 6},	
	   		{ event = 'talk', delay= 2.9, handle_id = 6 , talk='伯姬——！', dur=1.5 },	

	   		{ event = 'move', delay = 4,handle_id = 5, dir = 6, pos = {1884,2656},speed = 260, dur = 0.2 ,end_dir = 2},	

	   		{ event = 'talk', delay= 4.8, handle_id = 6 , talk='其它人呢？娘呢？！大姐呢？！', dur=1.8 },	

	   		{ event = 'talk', delay= 6.8, handle_id = 5 , talk='不知道……我不知道……大家都跑乱了，很多人都死了。', dur=2.3 },	

	    	{ event='showTopTalk', delay=9, dialog_id='3_3_3' ,dialog_time = 2,},  -- 前置	


	   	},
	   	{
	   		{ event = 'talk', delay= 0.1, handle_id = 6 , talk='！！！', dur=1.8 },	
	   		{ event = 'talk', delay= 0.1, handle_id = 5 , talk='！！！', dur=1.8 },	
	    	{ event = 'camera', delay = 0.1, c_topox={1331,2561} , sdur=0.5, dur = 0.5,style = '',backtime=1},

	   		{ event='createActor', delay=0.1, handle_id=11, body=37, pos={989,2339}, dir=2, speed=340, name_color=0xffffff, name="潘氏", },	  
	   		{ event='createActor', delay=0.1, handle_id=12, body=36, pos={1157,2578}, dir=1, speed=340, name_color=0xffffff, name="良婶", },	  
	   		{ event='createActor', delay=0.1, handle_id=13, body=29, pos={1120,2400}, dir=3, speed=340, name_color=0xffffff, name="刘安", },	  
	   		{ event='createActor', delay=0.1, handle_id=14, body=25, pos={830,2500}, dir=3, speed=340, name_color=0xffffff, name="汉军", },	  
	   		{ event='createActor', delay=0.1, handle_id=15, body=25, pos={955,2536}, dir=3, speed=340, name_color=0xffffff, name="汉军", },	  
	   		{ event='createActor', delay=0.1, handle_id=16, body=25, pos={1008,2548}, dir=7, speed=340, name_color=0xffffff, name="汉军", },	  
	   		{ event='createActor', delay=0.1, handle_id=17, body=25, pos={1220,2490}, dir=6, speed=340, name_color=0xffffff, name="汉军", },	  
	   		{ event='createActor', delay=0.1, handle_id=18, body=25, pos={674,2358}, dir=6, speed=340, name_color=0xffffff, name="汉军", },	
	   		{ event='createActor', delay=0.1, handle_id=19, body=41, pos={618,2336}, dir=1, speed=340, name_color=0xffffff, name="家眷", },	  
	   		{ event='createActor', delay=0.1, handle_id=20, body=41, pos={1140,2448}, dir=3, speed=340, name_color=0xffffff, name="家眷", },	  
	   		{ event='createActor', delay=0.1, handle_id=21, body=41, pos={1211,2590}, dir=2, speed=340, name_color=0xffffff, name="家眷", },	  
	   		{ event='createActor', delay=0.1, handle_id=22, body=41, pos={1178,2758}, dir=7, speed=340, name_color=0xffffff, name="家眷", },	

	   		{ event = 'playAction', handle_id= 11, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 12, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 13, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 14, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 15, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 16, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 17, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 18, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 19, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 20, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 21, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 22, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},

	   		{ event='createActor', delay=0.1, handle_id=7, body=7, pos={1430,2436}, dir=1, speed=340, name_color=0xffffff, name="刘仲", },	  
	   		{ event='createActor', delay=0.1, handle_id=8, body=37, pos={1576,2448}, dir=2, speed=340, name_color=0xffffff, name="刘元", },	  
	   		{ event='createActor', delay=0.1, handle_id=9, body=17, pos={1210,2490}, dir=3, speed=340, name_color=0xffffff, name="邓卉", },	  
	   		{ event='createActor', delay=0.1, handle_id=10, body=41, pos={1512,2658}, dir=5, speed=340, name_color=0xffffff, name="邓瑾", },	  

	   		{ event = 'playAction', handle_id= 7, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 8, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 9, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'playAction', handle_id= 10, delay = 0.2, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},

	   		{ event = 'move', delay = 4,handle_id = 5, dir = 6, pos = {1556,2628},speed = 260, dur = 0.2 ,end_dir = 7},	
	   		{ event = 'move', delay = 4,handle_id = 6, dir = 6, pos = {1644,2575},speed = 260, dur = 0.2 ,end_dir = 7},	
	   		{ event = 'talk', delay= 4.8, handle_id = 6 , talk='二哥，二姐！', dur=1.8 },	

	   		{ event = 'talk', delay= 4.8, handle_id = 6 , talk='不——二哥……二姐……呜呜……', dur=1.8 },	

	    	{ event = 'camera', delay = 6.1, c_topox={1000,2561} , sdur=1, dur = 1,style = '',backtime=1},

	    	{ event = 'camera', delay = 7.1, c_topox={800,2261} , sdur=1, dur = 1,style = '',backtime=1},

			{ event='effect', handle_id=121,  delay = 9.2 , pos={1163,2475}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=122,  delay = 9.2 , pos={1034,2273}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=123,  delay = 9.2 , pos={779,2341}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=124,  delay = 9.2 , pos={584,2252}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=125,  delay = 9.2 , pos={321,2180}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=126,  delay = 9.2 , pos={613,2278}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=127,  delay = 9.2 , pos={772,2338}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=128,  delay = 9.2 , pos={545,2506}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=129,  delay = 9.2 , pos={1003,2505}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=130,  delay = 9.2 , pos={419,2408}, effect_id=20005, is_forever = true},

			{ event='effect', handle_id=101, target_id=11, delay = 9.2 , pos={5, 10}, effect_id=20005, is_forever = true},		   		
			{ event='effect', handle_id=103, target_id=12, delay = 9.9 , pos={5, 10}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=104, target_id=13, delay = 10.1 , pos={5, 10}, effect_id=20005, is_forever = true},	
			{ event='effect', handle_id=105, target_id=14, delay = 9.2 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=106, target_id=15, delay = 9.3 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=107, target_id=16, delay = 10 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=108, target_id=17, delay = 10.2 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=109, target_id=18, delay = 9.4 , pos={5, 10}, effect_id=20005, is_forever = true},			
			{ event='effect', handle_id=106, target_id=19, delay = 10 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=107, target_id=20, delay = 9.6 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=108, target_id=21, delay = 9.5 , pos={5, 10}, effect_id=20005, is_forever = true},
			{ event='effect', handle_id=109, target_id=22, delay = 9.3 , pos={5, 10}, effect_id=20005, is_forever = true},			

	   	},

	},
	--============================================luyao  剧情副本第三章第三节 end      =====================================----	
	--============================================luyao  剧情副本第三章第四节 start    =====================================----
	['juqing341']=

	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 950,my = 2130 ,dur= 1.5}, 
			{ event='effect', handle_id=101,  delay = 0.1 , pos={780,2050}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=102,  delay = 0.1 , pos={780+50,2050}, effect_id=20019, is_forever = true},		   		
			{ event='effect', handle_id=103,  delay = 0.1 , pos={780+100,2050}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=104,  delay = 0.1 , pos={760,2050+50}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=105,  delay = 0.1 , pos={760+50,2050+50}, effect_id=20019, is_forever = true},
			{ event='effect', handle_id=106,  delay = 0.1 , pos={760+100,2050+50}, effect_id=20019, is_forever = true},

			{ event='effect', handle_id=121,  delay = 0.1 , pos={740,2150}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=122,  delay = 0.1 , pos={740+50,2150}, effect_id=20019, is_forever = true},		   		
			{ event='effect', handle_id=123,  delay = 0.1 , pos={740+100,2150}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=124,  delay = 0.1 , pos={710,2150+50}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=125,  delay = 0.1 , pos={710+50,2150+50}, effect_id=20019, is_forever = true},
			{ event='effect', handle_id=126,  delay = 0.1 , pos={710+100,2150+50}, effect_id=20019, is_forever = true},

			{ event='effect', handle_id=107,  delay = 0.1 , pos={690,2250}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=108,  delay = 0.1 , pos={690+50,2250}, effect_id=20019, is_forever = true},		   		
			{ event='effect', handle_id=109,  delay = 0.1 , pos={690+100,2250}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=110,  delay = 0.1 , pos={670,2250+50}, effect_id=20019, is_forever = true},	
			{ event='effect', handle_id=111,  delay = 0.1 , pos={670+50,2250+50}, effect_id=20019, is_forever = true},
			{ event='effect', handle_id=112,  delay = 0.1 , pos={670+100,2250+50}, effect_id=20019, is_forever = true},

	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={950,2200}, dir=6, speed=340, name_color=0xffffff, name="刘縯", },	  
	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={960,2280}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },	  
	   		{ event='createActor', delay=0.1, handle_id=3, body=5, pos={1000,2120}, dir=6, speed=340, name_color=0xffffff, name="阴戟", },	  
	   		{ event='createActor', delay=0.1, handle_id=4, body=20, pos={900,2320}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },	

	   		{ event='createActor', delay=0.1, handle_id=5, body=25, pos={1310,2080}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	  
	   		{ event='createActor', delay=0.1, handle_id=6, body=25, pos={1330,2200}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	 	   		
	   		{ event='createActor', delay=0.1, handle_id=7, body=25, pos={1330,2270}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	  
	   		{ event='createActor', delay=0.1, handle_id=8, body=25, pos={1280,2400}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	

	   		{ event='createActor', delay=0.1, handle_id=9, body=25, pos={1110,2120}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	  
	   		{ event='createActor', delay=0.1, handle_id=10, body=25, pos={1130,2200}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	 
	   		{ event='createActor', delay=0.1, handle_id=11, body=25, pos={1130,2270}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	  
	   		{ event='createActor', delay=0.1, handle_id=12, body=25, pos={1080,2350}, dir=6, speed=340, name_color=0xffffff, name="汉军将士", },	 

		},

		{
	   		{ event='talk', delay=0.1, handle_id=1, talk='出不入兮往不返……平原忽兮路超远……', dur=3 },
	   		{ event='talk', delay=3.5, handle_id=1, talk='带长剑兮挟秦弓，首身离兮心不惩……', dur=3 },
	   		{ event='talk', delay=7, handle_id=2, talk='身既死兮神以灵，魂魄毅兮为鬼雄……', dur=3 },
	   		{ event='talk', delay=10.5, handle_id=3, talk='身既死兮神以灵，魂魄毅兮为鬼雄……', dur=3 },
	   		{ event='talk', delay=10.5, handle_id=4, talk='身既死兮神以灵，魂魄毅兮为鬼雄……', dur=3 },
	   		{ event='talk', delay=14, handle_id=1, talk='逝去的亲人们在天上看着咱们呢，随我杀尽莽贼，报仇雪恨！', dur=3 },
	   	},
	   	{
	   		{ event='talk', delay=0.1, handle_id=5, talk='报仇！报仇！', dur= 3},
	   		{ event='talk', delay=0.1, handle_id=6, talk='报仇！报仇！', dur=3 },
	   		{ event='talk', delay=0.1, handle_id=7, talk='报仇！报仇！', dur=3 },
	   		{ event='talk', delay=0.1, handle_id=8, talk='报仇！报仇！', dur=3 },
	   		{ event='talk', delay=0.1, handle_id=9, talk='报仇！报仇！', dur= 3},
	   		{ event='talk', delay=0.1, handle_id=10, talk='报仇！报仇！', dur=3 },
	   		{ event='talk', delay=0.1, handle_id=11, talk='报仇！报仇！', dur=3 },
	   		{ event='talk', delay=0.1, handle_id=12, talk='报仇！报仇！', dur=3 },
		},

	},

	['juqing342']=
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 528,my = 1176 ,dur= 1.5}, 

	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={450,1182}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },	  
	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={514,1202}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },	  
	   		{ event='createActor', delay=0.1, handle_id=3, body=5, pos={390,1232}, dir=7, speed=340, name_color=0xffffff, name="阴戟", },	  
	   		{ event='createActor', delay=0.1, handle_id=4, body=20, pos={550,1300}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },	

	   		--{ event='createActor', delay=0.1, handle_id=7, body=25, pos={368,1290}, dir=7, speed=340, name_color=0xffffff, name="汉军将士", },
	   		--{ event='createActor', delay=0.1, handle_id=8, body=25, pos={426,1326}, dir=7, speed=340, name_color=0xffffff, name="汉军将士", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=25, pos={426,1392}, dir=7, speed=340, name_color=0xffffff, name="汉军将士", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=25, pos={368,1368}, dir=7, speed=340, name_color=0xffffff, name="汉军将士", },

	   		{ event='talk', delay=1.5, handle_id=2, talk='烧——！', dur=1.5 },

	   		--{ event = 'playAction', handle_id= 7, delay = 3, action_id = 2, dur = 1, dir = 1,loop = true ,},
	   		--{ event = 'playAction', handle_id= 8, delay = 3, action_id = 2, dur = 1, dir = 1,loop = true ,},
	   		--{ event = 'playAction', handle_id= 5, delay = 3, action_id = 2, dur = 1, dir = 1,loop = true ,},
	   		--{ event = 'playAction', handle_id= 6, delay = 3, action_id = 2, dur = 1, dir = 1,loop = true ,},

		},


		{
	    	{ event = 'camera', delay = 0.1, c_topox={567,400} , sdur=1, dur = 1,style = '',backtime=1},
			{ event='effect', handle_id=101,  delay = 1.1 , pos={873,412}, effect_id=11049, is_forever = true},	
			{ event='effect', handle_id=102,  delay = 1.2 , pos={438,535}, effect_id=11049, is_forever = true},		   		
			{ event='effect', handle_id=103,  delay = 1.5 , pos={654,877}, effect_id=11049, is_forever = true},	
			{ event='effect', handle_id=110,  delay = 1.2 , pos={449,699}, effect_id=11049, is_forever = true},	
			{ event='effect', handle_id=111,  delay = 1.4 , pos={380,541}, effect_id=11049, is_forever = true},
			{ event='effect', handle_id=112,  delay = 1.1 , pos={458,505}, effect_id=11049, is_forever = true},

			{ event='effect', handle_id=113,  delay = 1.1 , pos={588,599}, effect_id=11049, is_forever = true},	
			{ event='effect', handle_id=114,  delay = 1.5 , pos={694,420}, effect_id=11049, is_forever = true},		   		
			{ event='effect', handle_id=115,  delay = 2.1 , pos={780,460}, effect_id=11049, is_forever = true},	
			{ event='effect', handle_id=116,  delay = 1.7 , pos={699,296}, effect_id=11049, is_forever = true},	
			{ event='effect', handle_id=117,  delay = 1.5 , pos={756,546}, effect_id=11049, is_forever = true},
			{ event='effect', handle_id=118,  delay = 1.3 , pos={586,320}, effect_id=11049, is_forever = true},

		},

		{
	   		{ event='createActor', delay=0.1, handle_id=10, body=18, pos={1473,470}, dir=6, speed=340, name_color=0xffffff, name="甄阜", },	  
	   		{ event='createActor', delay=0.1, handle_id=11, body=48, pos={1458,535}, dir=6, speed=340, name_color=0xffffff, name="梁丘赐", },	  
	
	   		{ event='createActor', delay=1.1, handle_id=12, body=27, pos={859,402}, dir=1, speed=340, name_color=0xffffff, name="新军士兵", },	  
	   		{ event='createActor', delay=1.1, handle_id=13, body=27, pos={892,316}, dir=1, speed=340, name_color=0xffffff, name="新军士兵", },	 

	   		{ event='createActor', delay=0.1, handle_id=14, body=27, pos={1573,470}, dir=1, speed=340, name_color=0xffffff, name="新军士兵", },	  
	   		{ event='createActor', delay=0.1, handle_id=15, body=27, pos={1558,535}, dir=1, speed=340, name_color=0xffffff, name="新军士兵", },	

	   		{ event = 'move', delay = 1.2,handle_id = 13, dir = 6, pos = {1257,431},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 12, dir = 6, pos = {1293,508},speed = 260, dur = 0.2 ,end_dir = 2},	

	   		{ event = 'move', delay = 1.2,handle_id = 1, dir = 6, pos = {1142,800},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 2, dir = 6, pos = {1284,800},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 3, dir = 6, pos = {1138,858},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 4, dir = 6, pos = {1280,858},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 5, dir = 6, pos = {1074,909},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 6, dir = 6, pos = {1223,909},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 7, dir = 6, pos = {1100,1000},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 8, dir = 6, pos = {1200,1000},speed = 260, dur = 0.2 ,end_dir = 2},	


	    	{ event = 'camera', delay = 2.1, c_topox={1299,376} , sdur=1, dur = 1,style = '',backtime=1},

	   		{ event='talk', delay=2.5, handle_id=12, talk='将军！蓝乡粮草被汉军烧了！', dur=1.5 },
	   		{ event='talk', delay=2.5, handle_id=13, talk='将军！蓝乡粮草被汉军烧了！', dur=1.5 },
		},
		{
	   		{ event='talk', delay=0.1, handle_id=10, talk='快，调前队过去灭火！一定要保住粮草！', dur=1.5 },


	   		{ event = 'move', delay = 1.2,handle_id = 1, dir = 6, pos = {1442,500},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 2, dir = 6, pos = {1273,474},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 3, dir = 6, pos = {1413,558},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 4, dir = 6, pos = {1347,567},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 5, dir = 6, pos = {1262,709},speed = 260, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 1.2,handle_id = 6, dir = 6, pos = {1183,749},speed = 260, dur = 0.2 ,end_dir = 2},	

	   		{ event = 'move', delay = 2.4,handle_id = 11, dir = 6, pos = {1644,444},speed = 340, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 2.4,handle_id = 12, dir = 6, pos = {1954,256},speed = 160, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 2.4,handle_id = 13, dir = 6, pos = {1942,256},speed = 160, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 2.4,handle_id = 14, dir = 6, pos = {1942,256},speed = 160, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 2.4,handle_id = 15, dir = 6, pos = {1942,256},speed = 160, dur = 0.2 ,end_dir = 2},	
	   		{ event = 'move', delay = 2.4,handle_id = 10, dir = 6, pos = {1644+60,444+60},speed = 340, dur = 0.2 ,end_dir = 7},

	   		{ event='talk', delay=2.1, handle_id=12, talk='！！！', dur=1.5 },
	   		{ event='talk', delay=2.1, handle_id=13, talk='！！！', dur=1.5 },
	   		{ event='talk', delay=2.1, handle_id=14, talk='！！！', dur=1.5 },
	   		{ event='talk', delay=2.1, handle_id=15, talk='！！！', dur=1.5 },

			{ event = 'kill', delay= 3.2, handle_id = 12,dur=2 ,},
			{ event = 'kill', delay= 3.2, handle_id = 13,dur=2 ,},
			{ event = 'kill', delay= 3.2, handle_id = 14,dur=2 ,},
			{ event = 'kill', delay= 3.2, handle_id = 15,dur=2 ,},
			--{ event = 'kill', delay= 3, handle_id = 10,dur=2 ,},


	   		{ event = 'move', delay = 2.9,handle_id = 2, dir = 6, pos = {1698,420},speed = 50, dur = 0.2 ,end_dir = 5},

	    	{ event = 'camera', delay = 2.9, c_topox={1712,358} , sdur=1, dur = 1,style = '',backtime=1},
	   		{ event='talk', delay=4.1, handle_id=2, talk='甄阜，梁丘赐—纳命来！', dur=1.5 },

	   		{ event = 'playAction', handle_id= 2, delay = 5, action_id = 2, dur = 0.1, dir = 5,loop = false ,once = true},
	   		{ event = 'move', delay = 5.3,handle_id = 2, dir = 6, pos = {1698,420},speed = 340, dur = 0.2 ,end_dir = 5},
	   		{ event = 'playAction', handle_id= 11, delay = 5.2, action_id = 4, dur = 0.1, dir = 1,loop = false ,once = true},	
	   	},
	   	{

	    	{ event = 'camera', delay =1.5, c_topox={1812,558} , sdur=1, dur = 1,style = '',backtime=1},

	   		{ event='talk', delay=0.1, handle_id=10, talk='！！！', dur=1.5 },
	   		{ event = 'move', delay = 1,handle_id = 10, dir = 6, pos = {1731,668},speed = 260, dur = 0.2 ,end_dir = 3},

	   		{ event = 'move', delay = 1.5,handle_id = 1, dir = 6, pos = {1731+50,668+50},speed = 50, dur = 0.2 ,end_dir = 7},
	   		{ event = 'playAction', handle_id= 1, delay = 2.2, action_id = 2, dur = 0.1, dir = 7,loop = false ,},
	   		{ event = 'playAction', handle_id= 10, delay = 2.4, action_id = 4, dur = 0.1, dir = 1,loop = false ,once = true},

	   	},
	   	{

	   		{ event = 'move', delay = 0.5,handle_id = 2, dir = 3, pos = {1528+100,457+200},speed = 340, dur = 0.2 ,end_dir = 3},	
	   		{ event = 'move', delay = 0.5,handle_id = 3, dir = 3, pos = {1606,563},speed = 340, dur = 0.2 ,end_dir = 3},	
	   		{ event = 'move', delay = 0.5,handle_id = 4, dir = 3, pos = {1423,536},speed = 340, dur = 0.2 ,end_dir = 3},	
	   		{ event = 'move', delay = 0.5,handle_id = 5, dir = 3, pos = {1489,636},speed = 340, dur = 0.2 ,end_dir = 3},	

	   		{ event='talk', delay=1.5, handle_id=1, talk='报仇了！', dur=3 },
	   		{ event='talk', delay=2.5, handle_id=2, talk='报仇了！', dur=3 },
	   		{ event='talk', delay=2.5, handle_id=3, talk='报仇了！', dur=3 },
	   		{ event='talk', delay=2.5, handle_id=4, talk='报仇了！', dur=3 },
	   		{ event='talk', delay=2.5, handle_id=5, talk='报仇了！', dur=3 },



		},

	},




	--============================================luyao  剧情副本第三章第四节 end      =====================================----	

	--============================================LX  剧情副本第三章第五节 start  =====================================----
	--演员表 1刘秀  2邓晨  3宗佻  4李轶  5任光  6臧宫  7刘隆  8王霸  9傅俊  10马武  11阴戟  12邓奉  13王常  14张卬  15王凤 16冯异
	['juqing351']=
	{
		--创建角色
		{
	    	-- { event='createActor', delay=0.1, handle_id = 1, body=12, pos={2223,400}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=12, pos={2386,337}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=23, pos={1700,304+50}, dir=2, speed=340, name_color=0xffffff, name="邓晨", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1,  pos={1905,305+50}, dir=2, speed=340, name_color=0xffffff, name="宗佻", },	
	   		{ event='createActor', delay=0.1, handle_id = 6, body=30,  pos={2032,241+50}, dir=2, speed=340, name_color=0xffffff, name="臧宫", },   		

	   		{ event='createActor', delay=0.1, handle_id = 8, body=8,  pos={1874,367+50}, dir=2, speed=340, name_color=0xffffff, name="王霸", },
	   		{ event='createActor', delay=0.1, handle_id = 9, body=20, pos={1904,240+50}, dir=2, speed=340, name_color=0xffffff, name="傅俊", },
	   		{ event='createActor', delay=0.1, handle_id = 11, body=5,  pos={1807,305+50}, dir=2, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id = 12, body=29, pos={1778,240+50}, dir=2, speed=340, name_color=0xffffff, name="邓奉", },
	   		{ event='createActor', delay=0.1, handle_id = 13, body=7,  pos={2063,305+50}, dir=2, speed=340, name_color=0xffffff, name="王常", },
	   		{ event='createActor', delay=0.1, handle_id = 14, body=54, pos={2119,298}, dir=2, speed=340, name_color=0xffffff, name="张卬", },
	   		{ event='createActor', delay=0.1, handle_id = 15, body=9,  pos={1980,355}, dir=2, speed=340, name_color=0xffffff, name="王凤", },

	   		{ event='createActor', delay=0.1, handle_id = 4, body=48, pos={2383,593-30}, dir=1, speed=340, name_color=0xffffff, name="李轶", },
	   		{ event='createActor', delay=0.1, handle_id = 7, body=13, pos={2323,497}, dir=1, speed=340, name_color=0xffffff, name="刘隆", },
	   		{ event='createActor', delay=0.1, handle_id = 10, body=47, pos={2432,531-40}, dir=1, speed=340, name_color=0xffffff, name="马武", },
	   		{ event='createActor', delay=0.1, handle_id = 5, body=18, pos={2418,434}, dir=1, speed=340, name_color=0xffffff, name="任光", },

	   		-- { event='createActor', delay=0.1, handle_id = 4, body=20, pos={1874,273+64}, dir=3, speed=340, name_color=0xffffff, name="李轶", },
	   		-- { event='createActor', delay=0.1, handle_id = 10, body=22, pos={2034,337+64}, dir=3, speed=340, name_color=0xffffff, name="马武", },
	   		-- { event='createActor', delay=0.1, handle_id = 5, body=18, pos={1970,273+64}, dir=3, speed=340, name_color=0xffffff, name="任光", },
	   		-- { event='createActor', delay=0.1, handle_id = 7, body=13, pos={1746,337+64}, dir=3, speed=340, name_color=0xffffff, name="刘隆", },	   		
	   	},
	   	--镜头定格
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 2060,my = 200+30 },
	   	},
	   	--BB
	   	{
	   		{ event='talk', delay=1, handle_id=1, talk='昆阳生死，唯系外援，哪位将军随我出城突围，求取救兵？', dur=3 },

	   		{ event='talk', delay=3, handle_id=2, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=3, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=4, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=5, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=6, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=7, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=8, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=9, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=10, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=11, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=12, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=13, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=14, talk='……', dur=1.5 },
	   		{ event='talk', delay=3, handle_id=15, talk='……', dur=1.5 },

	   		{ event='talk', delay=4.6, handle_id=1, talk='既然诸位都愿留守昆阳，那便请诸位齐心协力，死守昆阳！', dur=3 },
	   		{ event='talk', delay=7.8, handle_id=1, talk='秀不才，这就出城求援，愿诸位保重，异日昆阳再会，与君同干庆功酒！', dur=3 },
	   	},
	   	--转身就走
	   	{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={2223,399}, speed=340, dur=2 },--刘秀走
	   		{ event='talk', delay=0.5, handle_id=11, talk='阴戟愿随将军去！', dur=1.5 },
	   		{ event='move', delay= 0.5, handle_id=11, end_dir=1, pos={2043,485}, speed=240, dur=1 },--阴戟挑出来
	   		{ event='move', delay= 3.5, handle_id=10, end_dir=1, pos={2186,467}, speed=240, dur=1 },--马武冲出来
	   		{ event='talk', delay=3, handle_id=10, talk='娘皮的，老子不能输给一个女子！我随你去！', dur=1.5 },
	   		{ event='talk', delay=5.5, handle_id=11, talk='[a]', dur=1.5, emote = {a=23}},
	   		{ event='talk', delay=7.2, handle_id=8, talk='[a]女子？！我可不是胆小如女子！刘将军！算上我！', dur=2 , emote = {a=14}},
	   		{ event='move', delay= 9, handle_id=8, end_dir=1, pos={2101,429}, speed=240, dur=1 },--王霸冲出来
	   	},	
	   	--其他人附和
	   	{
	   		{ event='createActor', delay=0.1, handle_id = 16, body=34,  pos={2735,498}, dir=7, speed=340, name_color=0xffffff, name="冯异", },
	   		{ event='talk', delay=0.1, handle_id=2, talk='我也去！', dur=1.5 },
	   		{ event='talk', delay=0.1, handle_id=12, talk='我也去！', dur=1.5 },

	   		{ event='talk', delay=1.7, handle_id=5, talk='还有我！', dur=1.5 },
	   		{ event='talk', delay=1.7, handle_id=6, talk='还有我！', dur=1.5 },
	   		{ event='talk', delay=1.7, handle_id=3, talk='还有我！', dur=1.5 },
	   		{ event='talk', delay=1.7, handle_id=7, talk='还有我！', dur=1.5 },
	   	},
	   	--冯异又装逼了
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id='3_5_1' ,dialog_time = 2,},
	   		{ event='move', delay= 1, handle_id=16, end_dir=5, pos={2340,351}, speed=280, dur=2 },
	   		{ event='move', delay= 2.8, handle_id=1, end_dir=1, pos={2223,399}, speed=340, dur=2 },
	   		{ event='talk', delay=2.8, handle_id=16, talk='刘将军，不知公孙能否随你们同往。', dur=2 },
	   		{ event='talk', delay=5, handle_id=10, talk='不行！他可是新朝的官，不能信！', dur=2 },
	   		{ event='talk', delay=7.5, handle_id=1, talk='既然公孙要与我们一起，便是生死与共的兄弟。', dur=2 },
	   	},
	   	--李铁坏心思
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id='3_5_2' ,dialog_time = 2.5,},

	   		-- { event='move', delay= 1, handle_id=4, end_dir=2, pos={2162,431}, speed=240, dur=1 },
	   		{ event='talk', delay=2.7, handle_id=4, talk='文叔，我也跟你一起去。', dur=1.5 },
	   		{ event='move', delay= 2.7, handle_id=4, end_dir=7, pos={2269+40,524+40}, speed=200, dur=1 },

	   		{ event='move', delay= 3.3, handle_id=1, end_dir=3, pos={2223,399}, speed=340, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=2, end_dir=3, pos={1700,354}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=3, end_dir=3, pos={1905,355}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=5, end_dir=5, pos={2418,434}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=6, end_dir=3, pos={2032,291}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=7, end_dir=5, pos={2323,497}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=8, end_dir=3, pos={2101,429}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=9, end_dir=3, pos={1904,290}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=10, end_dir=3, pos={2186,467}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=11, end_dir=2, pos={2043,485}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=12, end_dir=3, pos={1778,290}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=13, end_dir=3, pos={2063,355}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=14, end_dir=3, pos={2119,298}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=15, end_dir=3, pos={1980,355}, speed=240, dur=1 },
	   		{ event='move', delay= 3.3, handle_id=16, end_dir=5, pos={2340,351}, speed=240, dur=1 },


	   		{ event='talk', delay=4.8, handle_id=1, talk='好！', dur=1.5 },
	   	},
	   	--结尾，いこう
	   	{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={2223,399}, speed=340, dur=1 },
	   		{ event='talk', delay=0.1, handle_id=1, talk='我们十三人，定能杀出重围。', dur=1.5 },

	   		{ event='move', delay= 1.5, handle_id=2, end_dir=2, pos={1700,354}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=3, end_dir=2, pos={1905,355}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=5, end_dir=1, pos={2418,434}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=6, end_dir=2, pos={2032,291}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=7, end_dir=1, pos={2323,497}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=8, end_dir=1, pos={2101,429}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=9, end_dir=2, pos={1904,290}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=10, end_dir=1, pos={2186,467}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=11, end_dir=1, pos={2043,485}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=12, end_dir=2, pos={1778,290}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=13, end_dir=2, pos={2063,355}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=14, end_dir=2, pos={2119,298}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=15, end_dir=2, pos={1980,355}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=16, end_dir=5, pos={2340,351}, speed=240, dur=1 },


	   		{ event='talk', delay=2, handle_id=2, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=3, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=4, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=5, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=6, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=7, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=8, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=9, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=10, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=11, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=12, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=2, handle_id=16, talk='诺！', dur=1.5 },

	   	},
	},

	--演员表 1刘秀  2邓晨  3宗佻  4李轶  5任光  6臧宫  7刘隆  8王霸  9傅俊  10马武  11阴戟  12邓奉  16冯异

	['juqing352']=
	{
		--创建角色
		{
	    	{ event='createActor', delay=0.1, handle_id = 1,  body=12, pos={2674,2096-20}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id = 2,  body=23, pos={2512-50,1838-20}, dir=3, speed=340, name_color=0xffffff, name="邓晨", },
	   		{ event='createActor', delay=0.1, handle_id = 3,  body=1,  pos={2544,1904-20}, dir=3, speed=340, name_color=0xffffff, name="宗佻", },	
	   		{ event='createActor', delay=0.1, handle_id = 4,  body=48, pos={2480,1970-20}, dir=3, speed=340, name_color=0xffffff, name="李轶", },
	   		{ event='createActor', delay=0.1, handle_id = 5,  body=18, pos={2415,2035-20}, dir=3, speed=340, name_color=0xffffff, name="任光", }, 
	   		{ event='createActor', delay=0.1, handle_id = 6,  body=30,  pos={2416-100,1838-20}, dir=3, speed=340, name_color=0xffffff, name="臧宫", },   		
	   		{ event='createActor', delay=0.1, handle_id = 7,  body=13, pos={2448-50,1904-20}, dir=3, speed=340, name_color=0xffffff, name="刘隆", },
	   		{ event='createActor', delay=0.1, handle_id = 8,  body=8,  pos={2639,2001-20}, dir=7, speed=340, name_color=0xffffff, name="王霸", },
	   		{ event='createActor', delay=0.1, handle_id = 9,  body=20, pos={2198,1832}, dir=3, speed=340, name_color=0xffffff, name="傅俊", },
	   		{ event='createActor', delay=0.1, handle_id = 10, body=47, pos={2543,2097-20}, dir=7, speed=340, name_color=0xffffff, name="马武", },
	   		{ event='createActor', delay=0.1, handle_id = 11, body=5,  pos={2306,1956}, dir=3, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id = 12, body=29, pos={2111,1922}, dir=3, speed=340, name_color=0xffffff, name="邓奉", },	
	   		{ event='createActor', delay=0.1, handle_id = 16, body=34, pos={2194,2037}, dir=3, speed=340, name_color=0xffffff, name="冯异", },   		  		
	   	},
	   	--镜头定格
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 2462,my = 1860 },
	   	},
	   	{
	   		{ event='move', delay= 1.5, handle_id=10, end_dir=1, pos={2543,2097-20}, speed=240, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=8, end_dir=5, pos={2639,2001-20}, speed=240, dur=1 },
	   		{ event='talk', delay=1.5, handle_id=8, talk='咱们竟然都冲出来了！', dur=1.5 },
	   		{ event='talk', delay=3.2, handle_id=10, talk='[a]真痛快！哈哈！', dur=1.5,emote = {a=16}},
	   		{ event='talk', delay=5.2, handle_id=1, talk='我们就此分兵，任光刘隆五位将军前去郾城，我们几个去定陵！', dur=2.5 },	 
	   		{ event='talk', delay=7.9, handle_id=1, talk='纠齐援军后，于昆阳外汇合。', dur=2 },	
	   	},
	   	--诺！
	   	{
	   		{ event='move', delay= 0.1, handle_id=10, end_dir=3, pos={2543,2097-20}, speed=240, dur=1 },
	   		{ event='move', delay= 0.1, handle_id=8, end_dir=3, pos={2639,2001-20}, speed=240, dur=1 },
	   		{ event='talk', delay=1, handle_id=2, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=3, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=4, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=5, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=6, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=7, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=8, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=9, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=10, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=11, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=12, talk='诺！', dur=1.5 },
	   		{ event='talk', delay=1, handle_id=16, talk='诺！', dur=1.5 },	   		
	   	},

	},
	--============================================LX  剧情副本第三章第五节 end  =====================================----
	--============================================LX  剧情副本第三章第六节 end  =====================================----
	--演员表 1-丁柔 2-阴丽华 3-尉迟峻 4-王寻 5~8新军将士   101-长歌刀
	['juqing361'] = {
		--创建角色
		{
	    	-- { event='createActor', delay=0.1, handle_id = 1,  body=42, pos={847-50,689-50},  dir=7, speed=340, name_color=0xffffff, name="丁柔", },
	    	{ event="createSpEntity",delay=0.1, handle_id=1, name="42",name_color=0xffffff,actor_name="丁柔", action_id=5, dir=6, pos={944-50,627-50}},
	    	{ event="createSpEntity",delay=0.1, handle_id=2, name="06",name_color=0xffffff,actor_name="阴丽华", action_id=5, dir=7, pos={847-50,689-50}},
   		  	-- { event='createActor', delay=0.1, handle_id = 2,  body=6,  pos={847-50,689-50},  dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
   		  	{ event='createActor', delay=0.1, handle_id = 3,  body=22, pos={944-50,396-50},  dir=5, speed=340, name_color=0xffffff, name="尉迟峻", },
   		  	{ event='createActor', delay=0.1, handle_id = 4,  body=53,  pos={501-50,462-50},  dir=3, speed=340, name_color=0xffffff, name="王寻", },
   		  	{ event='createActor', delay=0.1, handle_id = 5,  body=25, pos={1232-50,529-50}, dir=5, speed=340, name_color=0xffffff, name="新军将士", },
   		  	{ event='createActor', delay=0.1, handle_id = 6,  body=25, pos={337-50,817-50},  dir=1, speed=340, name_color=0xffffff, name="新军将士", },
   		  	{ event='createActor', delay=0.1, handle_id = 7,  body=25, pos={592-50,946-50},  dir=1, speed=340, name_color=0xffffff, name="新军将士", },
   		  	{ event='createActor', delay=0.1, handle_id = 8,  body=25, pos={1589-50,720-50}, dir=5, speed=340, name_color=0xffffff, name="新军将士", },
	   	},
	   	--镜头定格
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 896-50,my = 641-50 },
	   	},


	   	--阴丽华跳舞跳过去
	   	{
	   		{ event = 'playAction', delay = 0.1,handle_id= 1, action_id = 5, dur = 2, dir = 6,loop = true,once =false},

	   		{ event = 'talk', delay= 1, handle_id = 5, talk='♪♮♫♪♬♭♩♪♪~', dur=4 },
	   		{ event = 'talk', delay= 1, handle_id = 6, talk='♪♮♫♪♬♭♩♪♪~', dur=4 },
	   		{ event = 'talk', delay= 1, handle_id = 7, talk='♪♮♫♪♬♭♩♪♪~', dur=4 },
	   		{ event = 'talk', delay= 1, handle_id = 8, talk='♪♮♫♪♬♭♩♪♪~', dur=4 },	
	   		{ event = 'talk', delay= 1, handle_id = 4, talk='♪♮♫♪♬♭♩♪♪~', dur=4 },	
	   		--{ event = 'talk', delay= 1, handle_id = 8, talk='♪♮♫♪♬♭♩♪♪~', dur=3 },	  	
	   		--{ event ='camera', delay = 1, target_id= 2, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},

	   		{ event = 'playAction', delay = 0.1,handle_id= 2, action_id = 5, dur = 2, dir = 2,loop = true,once =false},
	   		{ event='moveParabola', delay=1.5, handle_id=2, pos={847-120,689-120}, high=0, time=1.4, end_act_id=5, end_dir=7, end_loop=true },

	   		{ event = 'camera', delay = 3, c_topox={628-50,446-50} , sdur=0.1, dur = 1,style = '',backtime=1},
	   		{ event = 'playAction', delay = 3,handle_id= 2, action_id = 5, dur = 2, dir = 2,loop = true,once =false},
	   		{ event='moveParabola', delay=3, handle_id=2, pos={688-50,562-50}, high=0, time=1.5, end_act_id=5, end_dir=7, end_loop=true },
	   		-- { event = 'move', delay = 3,handle_id = 2, dir = 1, pos = {688-50,562-50},speed = 340, dur = 1.5 ,end_dir = 7},
	   		{ event = 'playAction', delay = 4.7,handle_id= 2, action_id = 4, dur = 1, dir = 3,loop = false,once =true},
	   		{ event = 'talk', delay= 4.5, handle_id = 2, talk='！！！', dur=1.5 },

	   		{ event='moveEffect', handle_id=101, delay=5, effect_id=20020, pos1={17,14}, pos2={16,12}, pos3={16,13}, dur=0.3, m_dur=0.3}, --丢长歌刀

	   		{ event = 'move', delay = 5.5,handle_id = 4, dir = 2, pos = {428-50,429-50},speed = 200, dur = 1.5 ,end_dir = 3},
	   		{ event = 'talk', delay= 5.5, handle_id = 4, talk='[a]长歌刀？！', dur=2,emote={a=37} },
	   	},
	   	--危险
	   	{
	   		--王寻反应
	   		
	   		{ event = 'talk', delay= 0.1, handle_id = 4, talk='[a]来人！有刺客！', dur=2 ,emote={a=24}},

	   		--尉迟骏反应
	   		{ event = 'talk', delay= 1.5, handle_id = 3, talk='！！！', dur=2 },
			{ event = 'move', delay = 1.5,handle_id = 3, dir = 1, pos = {719-50,688-50},speed = 100, dur = 1 ,end_dir = 5},
			--{ event='jump', delay=1.8, handle_id= 3, dir=5, pos={719,688}, speed=120, dur=1, end_dir=5 },  

			{ event = 'camera', delay = 2, c_topox={750-50,641-50} , sdur=0.1, dur = 1,style = '',backtime=1},
			--阴丽华反应
	   		{ event = 'playAction', delay = 2,handle_id= 2, action_id = 0, dur = 0.1, dir = 7,loop = true},
	   		{ event = 'move', delay = 2.5,handle_id = 2, dir = 1, pos = {688-50,562-50},speed = 340, dur = 1.5 ,end_dir = 3},
	   		{ event = 'move', delay = 3,handle_id = 2, dir = 1, pos = {688-50,562-50},speed = 340, dur = 1.5 ,end_dir = 5},

	   		--丁柔反应
	   		{ event = 'move', delay = 3,handle_id = 1, dir = 1, pos = {802,556},speed = 280, dur = 1.5 ,end_dir = 3},
	   		-- { event = 'talk', delay= 3, handle_id = 1, talk='[a]', dur=2 ,emote={a=23}},
	   		
	   	   --大兵跑过来
	   		{ event = 'move', delay = 1.5,handle_id = 5, dir = 1, pos = {529-50,530-50},speed = 100, dur = 4 ,end_dir = 3},
	   		{ event = 'move', delay = 1.5,handle_id = 8, dir = 1, pos = {881-50,850-50},speed = 150, dur = 4 ,end_dir = 7},
	   		{ event = 'move', delay = 1.5,handle_id = 6, dir = 1, pos = {562-50,724-50},speed = 280, dur = 4 ,end_dir = 1},
	   		{ event = 'move', delay = 1.5,handle_id = 7, dir = 1, pos = {688-50,852-50},speed = 280, dur = 4 ,end_dir = 7},
	   	},
	},

    --演员表 1-丁柔 2-阴丽华 3-尉迟峻 4-王寻 5~8新军将士
	['juqing362'] = {

		{
	    	{ event='createActor', delay=0.1, handle_id = 1,  body=42, pos={752-50,692-50},  dir=7, speed=340, name_color=0xffffff, name="丁柔", },
   		  	{ event='createActor', delay=0.1, handle_id = 2,  body=6,  pos={720-50,596-50},  dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
   		  	{ event='createActor', delay=0.1, handle_id = 3,  body=22, pos={847-50,624-50},  dir=7, speed=340, name_color=0xffffff, name="尉迟峻", },
   		  	{ event='createActor', delay=0.1, handle_id = 4,  body=53,  pos={625-70,530-70},  dir=3, speed=340, name_color=0xffffff, name="王寻", },
   		  	{ event='createActor', delay=0.1, handle_id = 5,  body=25, pos={468-50,626-50},  dir=2, speed=340, name_color=0xffffff, name="新军将士", },
   		  	{ event='createActor', delay=0.1, handle_id = 6,  body=25, pos={657-50,818-50},  dir=1, speed=340, name_color=0xffffff, name="新军将士", },
   		  	{ event='createActor', delay=0.1, handle_id = 7,  body=25, pos={690-50,463-50},  dir=2, speed=340, name_color=0xffffff, name="新军将士", },
   		  	{ event='createActor', delay=0.1, handle_id = 8,  body=25, pos={913-50,660-50},  dir=5, speed=340, name_color=0xffffff, name="新军将士", },
	   	},
	   	--镜头定格
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1488-50,my = 846-50 },
	   	},

	   	--演员姿势就位
	   	{
	   		{ event = 'camera', delay = 1, c_topox={750-50,541-50} , sdur=0.1, dur = 1,style = '',backtime=1},
	   		{ event = 'playAction', delay = 0.1,handle_id= 5, action_id = 4, dur = 1, dir = 3,loop = false,once =true},
	   		{ event = 'playAction', delay = 0.1,handle_id= 6, action_id = 4, dur = 1, dir = 3,loop = false,once =true},
	   		{ event = 'playAction', delay = 0.1,handle_id= 7, action_id = 4, dur = 1, dir = 3,loop = false,once =true},
	   		{ event = 'playAction', delay = 0.1,handle_id= 8, action_id = 4, dur = 1, dir = 3,loop = false,once =true},
	   	},
	   	--杀王寻
	   	{
	   		{ event = 'talk', delay= 0.1, handle_id = 4, talk='你……你是……', dur=1.5 },
	   		{ event = 'playAction', delay = 2,handle_id= 2, action_id = 2, dur = 1, dir = 7,loop = false},
	   		{ event = 'playAction', delay = 2.5,handle_id= 4, action_id = 3, dur = 1, dir = 3,loop = false},
	   		{ event = 'playAction', delay = 3,handle_id= 4, action_id = 4, dur = 1, dir = 3,loop = false,once=true},
	   		{ event = 'talk', delay= 2.5, handle_id = 4, talk='啊……[a]', dur=1.5,emote={a=4}},
	   		{ event = 'talk', delay= 4.2, handle_id = 2, talk='今日我就替卫家报此血仇！你死有余辜。', dur= 2},
	   	},
	   	--前置喊抓人
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id='3_6_2' ,dialog_time = 1.5,}, 
	   		{ event = 'move', delay = 1,handle_id = 1, dir = 3, pos = {752-50,692-50},speed = 100, dur = 1 ,end_dir = 3},
	   		{ event = 'move', delay = 1,handle_id = 2, dir = 3, pos = {720-50,596-50},speed = 100, dur = 1 ,end_dir = 3},
	   		{ event = 'move', delay = 1,handle_id = 3, dir = 3, pos = {847-50,624-50},speed = 100, dur = 1 ,end_dir = 3},
	   		{ event = 'talk', delay = 0.8, handle_id = 1, talk='！！！', dur=1.5 },
	   		{ event = 'talk', delay = 0.8, handle_id = 2, talk='！！！', dur=1.5 },
	   		{ event = 'talk', delay = 0.8, handle_id = 3, talk='！！！', dur=1.5 },
	   		{ event = 'talk', delay = 2.5, handle_id = 2, talk='快走！', dur=1.5 },
	   		{ event = 'move', delay = 3,handle_id = 1, dir = 3, pos = {1551-50,1104-50},speed = 200, dur = 2 ,end_dir = 3},
	   		{ event = 'move', delay = 3,handle_id = 2, dir = 3, pos = {1550-50,1008-50},speed = 200, dur = 2 ,end_dir = 3},
	   		{ event = 'move', delay = 3,handle_id = 3, dir = 3, pos = {1680-50,1040-50},speed = 200, dur = 2 ,end_dir = 3},
	   	},
	},

	--============================================LX  剧情副本第三章第六节 end  =====================================----
	--============================================wuwenbin  剧情副本第四章第一节 start    =====================================----
	['juqing411'] = {	

        --创建角色
        -- 演员表 1 阴戟 2 刘秀 3 刘縯 4 阴识 5 刘稷 6 刘玄 7 张卬 8 申屠建 9 朱鲔 10 王匡 101-108路人大臣
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={594,723}, dir=3, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={524,760}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=14, pos={500,818}, dir=1, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=30, pos={667,794}, dir=7, speed=340, name_color=0xffffff, name="阴识", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=20, pos={598,812}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },

	   		{ event='createActor', delay=0.1, handle_id=6, body=24, pos={375,366}, dir=3, speed=340, name_color=0xffffff, name="刘玄", },

	   		{ event='createActor', delay=0.1, handle_id=7, body=54, pos={948,470}, dir=3, speed=340, name_color=0xffffff, name="张卬", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=38, pos={1021,442}, dir=3, speed=340, name_color=0xffffff, name="申屠建", },
	   		{ event='createActor', delay=0.1, handle_id=9, body=48, pos={1017,528}, dir=7, speed=340, name_color=0xffffff, name="朱鲔", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=55, pos={1091,497}, dir=7, speed=340, name_color=0xffffff, name="王匡", },

	   		--路人大臣
	   		-- { event='createActor', delay=0.1, handle_id=101, body=23, pos={688,778}, dir=3, speed=340, name_color=0xffffff, name="大臣", },
	   		-- { event='createActor', delay=0.1, handle_id=102, body=19, pos={744,765}, dir=3, speed=340, name_color=0xffffff, name="大臣", },
	   		-- { event='createActor', delay=0.1, handle_id=103, body=23, pos={753,854}, dir=7, speed=340, name_color=0xffffff, name="大臣", },
	   		-- { event='createActor', delay=0.1, handle_id=104, body=19, pos={811,816}, dir=7, speed=340, name_color=0xffffff, name="大臣", },

	   		{ event='createActor', delay=0.1, handle_id=105, body=23, pos={1144,627}, dir=5, speed=340, name_color=0xffffff, name="大臣", },
	   		{ event='createActor', delay=0.1, handle_id=106, body=19, pos={1211,661}, dir=5, speed=340, name_color=0xffffff, name="大臣", },
	   		{ event='createActor', delay=0.1, handle_id=107, body=23, pos={1081,681}, dir=1, speed=340, name_color=0xffffff, name="大臣", },  
	   		{ event='createActor', delay=0.1, handle_id=108, body=19, pos={1142,730}, dir=1, speed=340, name_color=0xffffff, name="大臣", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		-- { event ='camera', delay = 0.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1}, 
	   		{ event='init_cimera', delay = 0.1,mx= 559,my = 740 }, 	 
	    },

	    --刘縯喝醉，打嗝儿
	    {
	   		{ event = 'talk', delay= 1, handle_id = 3, talk='嗝儿。。', dur=2 },
	    },

	     --张卬欲害刘縯
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={1070,330} , sdur=0.1, dur = 1,style = '',backtime=1},
	    	{ event = 'talk', delay= 0.5, handle_id = 7, talk='……', dur=2 },
	    	{ event = 'talk', delay= 0.5, handle_id = 8, talk='……', dur=2 },
	    	{ event = 'talk', delay= 0.5, handle_id = 9, talk='……', dur=2 },
	    	{ event = 'talk', delay= 0.5, handle_id = 10, talk='……', dur=2 },
	    },
	    {
	    	-- { event = 'camera', delay = 1, target_id = 7 , sdur=0.1, dur = 1,style = 'follow',backtime=1},
	    	{ event = 'camera', delay = 1, c_topox={462,293} , sdur=0.1, dur = 2.5,style = '',backtime=1},

	   		{ event = 'move', delay = 0.5,handle_id = 7, dir = 1, pos = {502,437},speed = 300, dur = 1.5 ,end_dir = 7},
	   		{ event = 'talk', delay= 3, handle_id = 7, talk='陛下，您的玉玦掉了。', dur=2 },
	   		{ event = 'talk', delay= 5, handle_id = 6, talk='额……这个……', dur=1.5 },

	   		{ event = 'move', delay = 0.5,handle_id = 8, dir = 1, pos = {1021,442},speed = 260, dur = 1.5 ,end_dir = 6},
	   		{ event = 'move', delay = 0.5,handle_id = 9, dir = 1, pos = {1017,528},speed = 260, dur = 1.5 ,end_dir = 6},
	   		{ event = 'move', delay = 0.5,handle_id = 10, dir = 1, pos = {1091,497},speed = 260, dur = 1.5 ,end_dir = 6},
	   	},

	    --阴戟跑过去解围
	    {
	    	{ event = 'move', delay = 0.5,handle_id = 1, dir = 1, pos = {430,460},speed = 260, dur = 1.5 ,end_dir = 7},
	    	{ event = 'talk', delay= 2, handle_id = 1, talk='陛下，阴戟也参与昆阳一战，陛下还未赏我呢。', dur=2.5 },
	    	{ event = 'talk', delay= 4.8, handle_id = 1, talk='阴戟看到这块玉玦心中喜欢，想朝陛下讨个赏赐……', dur=2.5 },
	    	{ event = 'talk', delay= 7.4, handle_id = 6, talk='既然阴戟喜欢玉，拿去就是了。', dur=2 },
	    	{ event = 'talk', delay= 9.7, handle_id = 1, talk='阴戟谢陛下赏赐！', dur=1.5 },

	    	{ event = 'move', delay = 11.5,handle_id = 1, dir = 1, pos = {594,723},speed = 260, dur = 1.5 ,end_dir = 3},

	    	{ event = 'move', delay = 11.8,handle_id = 7, dir = 1, pos = {502,437},speed = 260, dur = 1.5 ,end_dir = 3},
	   		{ event = 'talk', delay= 11.8, handle_id = 7, talk='哼！[a]', dur=2 , emote = {a =34}},
	    },

	    --张卬回位
	    {
	   		-- { event = 'camera', delay = 0.5, c_topox={912,578} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event = 'move', delay = 0.1,handle_id = 7, dir = 1, pos = {948,470},speed = 300, dur = 1 ,end_dir = 3},
	   		{ event = 'move', delay = 2.1,handle_id = 8, dir = 1, pos = {1021,442},speed = 260, dur = 0.1 ,end_dir = 3},
	   		{ event = 'move', delay = 2.1,handle_id = 9, dir = 1, pos = {1017,528},speed = 260, dur = 0.1 ,end_dir = 7},
	   		{ event = 'move', delay = 2.1,handle_id = 10, dir = 1, pos = {1091,497},speed = 260, dur = 0.5 ,end_dir = 7},
	   	},

	   	--刘稷摔杯
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id='4_1_1' ,dialog_time = 1,},  -- 下部弹出窗口通过

	   		{ event = 'move', delay = 0.1,handle_id = 7, dir = 1, pos = {948,470},speed = 300, dur = 0.5 ,end_dir = 5},
	   		{ event = 'move', delay = 0.1,handle_id = 8, dir = 1, pos = {1021,442},speed = 260, dur = 0.5 ,end_dir = 5},
	   		{ event = 'move', delay = 0.1,handle_id = 9, dir = 1, pos = {1017,528},speed = 260, dur = 0.5 ,end_dir = 5},
	   		{ event = 'move', delay = 0.1,handle_id = 10, dir = 1, pos = {1091,497},speed = 260, dur = 0.5 ,end_dir = 5},
	   	},
	   	{
	   		{ event = 'camera', delay = 0.5, c_topox={459,697} , sdur=0.1, dur = 1,style = '',backtime=1},
	   		{ event = 'talk', delay= 0.5, handle_id = 1, talk='！！', dur=2 , },
	   		{ event = 'talk', delay= 0.5, handle_id = 2, talk='！！', dur=2 , },
	   		{ event = 'talk', delay= 0.5, handle_id = 4, talk='！！', dur=2 , },
	   		-- { event = 'talk', delay= 0.5, handle_id = 5, talk='！！', dur=1.5 , },
	   		{ event = 'move', delay = 0.5,handle_id = 4, dir = 1, pos = {667,794},speed = 260, dur = 1.5 ,end_dir = 5},

	   		{ event = 'talk', delay= 2.5, handle_id = 5, talk='赏罚分明，说的好听，狗屁。', dur=2 , },
	   		{ event = 'talk', delay= 4.5, handle_id = 2, talk='说什么胡话！快闭嘴！', dur=2 , },

	   		{ event = 'playAction', handle_id= 5, delay = 6.5, action_id = 4, dur = 0.1, dir = 7,loop = false},
	   		{ event = 'talk', delay= 6.5, handle_id = 5, talk='[a]我……嗝儿……我可没乱说话！', dur=2 , emote = {a =40}},
	   	},

	   	--刘玄愤怒
	   	{
	   		{ event = 'camera', delay = 0.1, c_topox={462,293} , sdur=0.1, dur = 1,style = '',backtime=1},
	   		{ event = 'talk', delay= 1, handle_id = 6, talk='[a]', dur=2 , emote = {a =34}},
	   	},

	},

	['juqing412'] = {	

                --创建角色
        -- 演员表 1 阴戟 2 刘秀 3 刘縯 4 阴识 5 刘稷 6 刘玄 7 张卬 8 申屠建 9 朱鲔 10 王匡 101-108路人大臣
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=5, pos={594,723}, dir=7, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=12, pos={502,437}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=14, pos={500,818}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=30, pos={667,794}, dir=7, speed=340, name_color=0xffffff, name="阴识", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=20, pos={430,460}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },

	   		{ event='createActor', delay=0.1, handle_id=6, body=24, pos={375,366}, dir=3, speed=340, name_color=0xffffff, name="刘玄", },

	   		{ event='createActor', delay=0.1, handle_id=7, body=54, pos={948,470}, dir=6, speed=340, name_color=0xffffff, name="张卬", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=7, pos={1021,442}, dir=6, speed=340, name_color=0xffffff, name="申屠建", },
	   		{ event='createActor', delay=0.1, handle_id=9, body=48, pos={1017,528}, dir=6, speed=340, name_color=0xffffff, name="朱鲔", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=55, pos={1091,497}, dir=6, speed=340, name_color=0xffffff, name="王匡", },

	   		--路人大臣
	   		-- { event='createActor', delay=0.1, handle_id=101, body=23, pos={688,778}, dir=3, speed=340, name_color=0xffffff, name="大臣", },
	   		-- { event='createActor', delay=0.1, handle_id=102, body=19, pos={744,765}, dir=3, speed=340, name_color=0xffffff, name="大臣", },
	   		-- { event='createActor', delay=0.1, handle_id=103, body=23, pos={753,854}, dir=7, speed=340, name_color=0xffffff, name="大臣", },
	   		-- { event='createActor', delay=0.1, handle_id=104, body=19, pos={811,816}, dir=7, speed=340, name_color=0xffffff, name="大臣", },

	   		{ event='createActor', delay=0.1, handle_id=105, body=23, pos={1144,627}, dir=7, speed=340, name_color=0xffffff, name="大臣", },
	   		{ event='createActor', delay=0.1, handle_id=106, body=19, pos={1211,661}, dir=7, speed=340, name_color=0xffffff, name="大臣", },
	   		{ event='createActor', delay=0.1, handle_id=107, body=23, pos={1081,681}, dir=7, speed=340, name_color=0xffffff, name="大臣", },  
	   		{ event='createActor', delay=0.1, handle_id=108, body=19, pos={1142,730}, dir=7, speed=340, name_color=0xffffff, name="大臣", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		-- { event ='camera', delay = 0.6, target_id= 4, sdur=0.5, dur = 0.5,style = 'follow',backtime=1}, 
	   		{ event='init_cimera', delay = 0.1,mx= 462,my = 293 }, 	 
	    },

	    --刘秀带刘稷向刘玄请罪
	    {
	   		{ event = 'talk', delay= 0.5, handle_id = 5, talk='嗝儿……', dur=1.5 },
	   		{ event = 'talk', delay= 2, handle_id = 2, talk='（颤声）刘稷不知礼节，酒醉胡言，出言莽撞，陛下恕罪!', dur=3 },
	   		{ event = 'talk', delay= 5.3, handle_id = 6, talk='赏赐也要分个先后，等你拿下颍川父城，朕再为你庆功！', dur=3.3 },
	   		{ event = 'talk', delay= 8.9, handle_id = 2, talk='臣当不负陛下所托。', dur=2 },
	    },


	},

	--============================================wuwenbin  剧情副本第四章第一节 end    =====================================----


	--============================================wuwenbin  剧情副本第四章第二节 start    =====================================----
	['juqing421'] = {	

        --创建角色
        -- 演员表 1 刘縯 2 刘玄 3 刘稷 4 张卬 5 朱鲔 101 102 看守侍卫  103-106 保护侍卫
	    {

	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={468,433}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=24, pos={375,366}, dir=3, speed=340, name_color=0xffffff, name="刘玄", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=20, pos={593,531}, dir=7, speed=340, name_color=0xffffff, name="刘稷", },

	   		{ event='createActor', delay=0.1, handle_id=4, body=54, pos={555,360}, dir=5, speed=340, name_color=0xffffff, name="张卬", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=48, pos={630,400}, dir=5, speed=340, name_color=0xffffff, name="朱鲔", },

	   		--侍卫
	   		{ event='createActor', delay=0.1, handle_id=101, body=25, pos={629,614}, dir=7, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=25, pos={688,587}, dir=7, speed=340, name_color=0xffffff, name="侍卫", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 428,my = 355 }, 	 
	    },

	    --刘縯质问
	    {
	   		{ event = 'talk', delay= 0.1, handle_id = 1, talk='[a]刘稷为我汉军出生入死！谁敢杀他？！', dur=2 ,emote = {a= 24,},},
	   		{ event = 'talk', delay= 2, handle_id = 4, talk='陛下！刘縯居功自傲，早有不臣之心，积弊已久……', dur=2.5 },
	   		{ event = 'talk', delay= 4.8, handle_id = 5, talk='刘縯！你这样是要造反不成！', dur=2 },
	   		{ event = 'talk', delay= 7.1, handle_id = 3, talk='大哥，快走！他们要杀你！', dur=2 },
	    },

	     --张卬跳杀刘稷
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 4, talk='大胆逆贼！', dur=2 },
	    	{ event='jump', delay=0.1, handle_id= 4, dir=5, pos={612,459}, speed=120, dur=1, end_dir=5 },  
	    	{ event = 'playAction', handle_id= 4, delay = 0.7, action_id = 2, dur = 0.1, dir = 5,loop = false},
	    	{ event = 'playAction', handle_id= 3, delay = 0.9, action_id = 4, dur = 0.1, dir = 7,loop = false,once = true},
	    },

	    --刘縯跑到刘稷身边
	    {
	    	{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {530,501},speed = 260, dur = 1.5 ,end_dir = 3},
	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='阿稷——！', dur=2 },

	    	{ event = 'move', delay = 2,handle_id = 1, dir = 1, pos = {530,501},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'talk', delay= 2.7, handle_id = 1, talk='[a]谁动我兄弟，就是动我刘伯升！张卯！我要你血债血偿！', dur=2.5 ,emote = {a= 34,},},
	    	{ event = 'playAction', handle_id= 1, delay = 2.7, action_id = 2, dur = 0.1, dir = 1,loop = false},

	    	{ event = 'talk', delay= 5.5, handle_id = 4, talk='大胆刘縯，你敢在陛下面前行凶，意图不轨。', dur=2 },
	    	{ event = 'talk', delay= 7.8, handle_id = 5, talk='来人！抓刺客！保护陛下！', dur=1.5 },

	    },

	    --侍卫出现，包围刘縯
	    {
	    	{ event='createActor', delay=0.1, handle_id=103, body=27, pos={307,428}, dir=3, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=27, pos={268,488}, dir=3, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.1, handle_id=105, body=27, pos={309,556}, dir=3, speed=340, name_color=0xffffff, name="侍卫", },

	   		{ event = 'move', delay = 0.2,handle_id = 103, dir = 1, pos = {465,434},speed = 260, dur = 2 ,end_dir = 3},
	   		{ event = 'move', delay = 0.2,handle_id = 104, dir = 1, pos = {439,503},speed = 260, dur = 2 ,end_dir = 2},
	   		{ event = 'move', delay = 0.2,handle_id = 105, dir = 1, pos = {469,563},speed = 260, dur = 2 ,end_dir = 1},
	   	},

	},

	['juqing422'] = {	

        --创建角色
        -- 演员表 1 刘縯 2 丽华 3 刘玄 4 张卬 5 朱鲔 101-104 侍卫
	    {

	   		{ event='createActor', delay=0.1, handle_id=1, body=14, pos={600,600}, dir=7, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=24, pos={375,366}, dir=3, speed=340, name_color=0xffffff, name="刘玄", },


	   		{ event='createActor', delay=0.1, handle_id=4, body=54, pos={397,464}, dir=3, speed=340, name_color=0xffffff, name="张卬", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=48, pos={503,395}, dir=3, speed=340, name_color=0xffffff, name="朱鲔", },

	   		--侍卫
	   		{ event='createActor', delay=0.1, handle_id=101, body=27, pos={503,617}, dir=1, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=27, pos={498,553}, dir=3, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.1, handle_id=103, body=27, pos={552,531}, dir=3, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=27, pos={626,526}, dir=5, speed=340, name_color=0xffffff, name="侍卫", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 448,my = 505 }, 	 
	    },

	    --丽华跑进画面
	    {
	    	-- { event = 'kill', delay= 0.2, handle_id = 1000,dur=2 ,},
	    	{ event='createActor', delay=0.5, handle_id = 2, body=6, pos={1046,818}, dir=7, speed=380, name_color=0xffffff, name="丽华", },

	    	{ event = 'move', delay = 0.6,handle_id = 2, dir = 1, pos = {857,681},speed = 260, dur = 1 ,end_dir = 7},
	   		{ event = 'talk', delay= 0.6, handle_id = 2, talk='大哥——！', dur=2 ,},

	   		{ event='createActor', delay=0.8, handle_id=105, body=27, pos={725,726}, dir=3, speed=340, name_color=0xffffff, name="侍卫", },
	   		{ event='createActor', delay=0.8, handle_id=106, body=27, pos={949,557}, dir=5, speed=340, name_color=0xffffff, name="侍卫", },

	   		{ event = 'move', delay = 0.9,handle_id = 105, dir = 1, pos = {787,649},speed = 260, dur = 0.5 ,end_dir = 3},
	   		{ event = 'move', delay = 0.9,handle_id = 106, dir = 1, pos = {849,622},speed = 260, dur = 0.5 ,end_dir = 3},
	   	},

	   	--张卬下令杀死刘縯
	   	{
	   		{ event = 'talk', delay= 0.5, handle_id = 4, talk='给我杀了他！', dur=1.5 ,},
	   		{ event = 'playAction', handle_id= 4, delay = 0.5, action_id = 2, dur = 0.1, dir = 3,loop = false},

	    	{ event = 'playAction', handle_id= 101, delay = 1.3, action_id = 2, dur = 0.1, dir = 1,loop = false},
	    	{ event = 'playAction', handle_id= 102, delay = 1.3, action_id = 2, dur = 0.1, dir = 3,loop = false},
	    	{ event = 'playAction', handle_id= 103, delay = 1.3, action_id = 2, dur = 0.1, dir = 3,loop = false},
	    	{ event = 'playAction', handle_id= 104, delay = 1.3, action_id = 2, dur = 0.1, dir = 5,loop = false},
	    	{ event = 'talk', delay= 1.5, handle_id = 1, talk='保护……', dur=1.5 },

	    	{ event = 'talk', delay= 3.1, handle_id = 1, talk='保护……文叔。', dur=1.5 },
	    	{ event = 'playAction', handle_id= 1, delay = 1.6, action_id = 4, dur = 0.1, dir = 7,loop = false,once = true},

	    	{ event = 'playAction', handle_id= 2, delay = 2, action_id = 2, dur = 0.1, dir = 7,loop = false},
	    	{ event = 'playAction', handle_id= 105, delay = 2.4, action_id = 4, dur = 0.1, dir = 3,loop = false,once = true},
	    	{ event = 'playAction', handle_id= 106, delay = 2.4, action_id = 4, dur = 0.1, dir = 3,loop = false,once = true},
	    	{ event = 'move', delay = 2.4,handle_id = 2, dir = 1, pos = {680,602},speed = 260, dur = 1.5 ,end_dir = 5},
	    	{ event = 'talk', delay= 4.8, handle_id = 2, talk='[a]大……哥……', dur=3 ,emote = {a= 46,}},
	    },

	},

	--============================================wuwenbin  剧情副本第四章第二节 end    =====================================----


	--============================================sunluyao 剧情副本第四章第三节 start    =====================================----


	['juqing431'] = {	

        --创建角色
        -- 演员表  1刘秀   2阴丽华    3刘縯    4家丁
	 	{
	 		{ event='init_cimera', delay = 0.1,mx= 1079,my = 786 }, 
			--{ event ='camera', delay = 0.5, target_id = 1, sdur=0.1, dur = 0.1,style = 'follow',backtime=1},	 			 
	    	{ event='createActor', delay=0.1, handle_id=1, body=13, pos={1364,1051}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	    	{ event = 'move', delay = 0.5,handle_id = 1, dir = 2, pos = {1094,861},speed = 340, dur = 1.5 ,end_dir = 7},
	    	{ event = 'talk', delay= 1, handle_id = 1, talk='丽华——', dur=1.5 },
	    	{ event = 'talk', delay= 3, handle_id = 1, talk='丽华——', dur=1.5 },	

	    	{ event ='camera', delay = 4, c_topox = {979,662}, sdur=0.5, dur = 0.5,backtime=1},

	    	{ event='createActor', delay=4.2, handle_id=2, body=6, pos={801,716}, dir=3, speed=340, name_color=0xffffff, name="阴丽华", },--998,351
	    	{ event = 'talk', delay= 5, handle_id = 2, talk='三哥？', dur=1.5 },
	    	{ event ='camera', delay = 6, c_topox = {979,792}, sdur=0.5, dur = 0.5,backtime=1},	    	
	    	{ event = 'move', delay = 6,handle_id = 2, dir = 7, pos = {950,861},speed = 340, dur = 1.5 ,end_dir = 2},	
	    	{ event = 'move', delay = 6.5,handle_id = 1, dir = 7, pos = {1094,861},speed = 340, dur = 1.5 ,end_dir = 6},	    	    	    	
	 	},

	 	{
	    	{ event = 'talk', delay= 0.1, handle_id = 2, talk='你怎么来了？', dur=1.8 },
	    	{ event = 'talk', delay= 3, handle_id = 1, talk='丽华，你愿意嫁给我吗？', dur=2 },
	    	{ event = 'talk', delay= 6, handle_id = 2, talk='你说什么？', dur=1.8 },
	    	{ event = 'talk', delay= 9, handle_id = 1, talk='你能……嫁给我，做我的妻子吗？', dur=2.2 },

	    	{ event='createActor', delay=10, handle_id=3, body=30, pos={441,507}, dir=3, speed=340, name_color=0xffffff, name="阴识", },
	    	{ event='createActor', delay=10, handle_id=4, body=22, pos={313,512}, dir=3, speed=340, name_color=0xffffff, name="阴家隐士", },
	    	{ event='createActor', delay=10, handle_id=5, body=22, pos={348,406}, dir=3, speed=340, name_color=0xffffff, name="阴家隐士", },

	 	},

	 	{
	    	{ event='showTopTalk', delay=0.1, dialog_id='4_3_1' ,dialog_time = 2,}, 

--	    	{ event ='camera', delay = 2, c_topox = {979,792}, sdur=0.5, dur = 0.5,backtime=1},

	    	{ event = 'move', delay = 1,handle_id = 2, dir = 1, pos = {1000,911},speed = 340, dur = 1.5 ,end_dir = 7},
	    	{ event = 'move', delay = 1,handle_id = 1, dir = 1, pos = {1094,861},speed = 340, dur = 1.5 ,end_dir = 7},

	    	{ event = 'move', delay = 1,handle_id = 3, dir = 1, pos = {1005,823},speed = 250, dur = 1.5 ,end_dir = 3},
	    	{ event = 'move', delay = 1,handle_id = 4, dir = 1, pos = {801,777},speed = 250, dur = 1.5 ,end_dir = 3},
	    	{ event = 'move', delay = 1,handle_id = 5, dir = 1, pos = {889,756},speed = 250, dur = 1.5 ,end_dir = 3},	

	    	{ event = 'talk', delay= 3.2, handle_id = 3, talk='你休想！', dur=2 },	    	   	
	 	},

	},

	['juqing432'] =
	{	
		{
	 		{ event='init_cimera', delay = 0.1,mx= 979,my = 792 }, 	

	    	{ event='createActor', delay=0.1, handle_id=1, body=13, pos={1094,861}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	    	{ event='createActor', delay=0.1, handle_id=2, body=6, pos={900,823}, dir=3, speed=340, name_color=0xffffff, name="阴丽华", },
	    	{ event='createActor', delay=0.1, handle_id=3, body=30, pos={1005,823}, dir=3, speed=340, name_color=0xffffff, name="阴识", },
	    	{ event='createActor', delay=0.1, handle_id=4, body=22, pos={801,777}, dir=3, speed=340, name_color=0xffffff, name="阴家隐士", },
	    	{ event='createActor', delay=0.1, handle_id=5, body=22, pos={889,756}, dir=3, speed=340, name_color=0xffffff, name="阴家隐士", },	


	    	{ event = 'playAction',delay = 1.5,  handle_id= 3, action_id = 2, dur = 0.1, dir = 3,loop = false,},



	    	{ event = 'playAction',delay = 1.6,  handle_id= 1, action_id = 3, dur = 0.2, dir = 7,loop = false,},
	    	{ event = 'playAction',delay = 1.8,  handle_id= 1, action_id = 4, dur = 0.2, dir = 7,loop = false, once=true},
	    	{ event = 'playAction',delay =2.5,  handle_id= 1, action_id = 0, dur = 1, dir = 7,loop = true, },

		},
		{
	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='但求次伯成全！', dur=1.8 },
	    	{ event = 'talk', delay= 2.2, handle_id = 3, talk='你打的什么主意，旁人不知，难道还能瞒得过我？', dur=2.5 },
	    	{ event = 'talk', delay= 5.5, handle_id = 3, talk='你若放弃丽华，娶其他女子自保。', dur=2 },
	    	{ event = 'talk', delay= 8.5, handle_id = 3, talk='我非但不会阻你，还可全力助你！', dur=2 },
	    	{ event = 'talk', delay= 11, handle_id = 1, talk='我只要她……', dur=1.5 },

		},
		{
	    	{ event='effect',  delay = 0.1 ,handle_id=101, target_id=3, pos={0,0}, effect_id=10135, is_forever = false},	--愤怒表情

	    	{ event = 'playAction',delay = 1,  handle_id= 3, action_id = 2, dur = 0.1, dir = 3,loop = false,},
	    	{ event = 'talk', delay= 1, handle_id = 3, talk='我绝不同意！', dur=2 },
	    	{ event ='camera', delay = 1.2, c_topox = {1039,792}, sdur=0.5, dur = 0.5,backtime=1},	  
	    	{ event='jump', delay=1.2, handle_id= 1, dir=7, pos={1217,891}, speed=50, dur=0.3, end_dir=7 }, 
	    	{ event = 'playAction',delay =1.7,  handle_id= 1, action_id = 4, dur = 0.2, dir = 7,loop = false, once=true },
		},
		{
	    	{ event = 'move', delay = 0.1,handle_id = 2, dir = 1, pos = {1159,865},speed = 340, dur = 1.5 ,end_dir = 7},
	    	{ event = 'talk', delay= 2, handle_id = 2, talk='大哥，你别打了！', dur=2 },
	    	{ event = 'talk', delay= 5, handle_id = 2, talk='三哥已经够可怜了！你还折磨他！', dur=2 },	 
		},
		{
	    	{ event = 'playAction',delay =0.1,  handle_id= 1, action_id = 0, dur = 1, dir = 7,loop = true, },	
	    	{ event = 'talk', delay= 1, handle_id = 3, talk='[a]你今天护着他，他还是会死的！你明白不明白？！', emote={a=34}, dur=2.5 },
	    	{ event = 'talk', delay= 4, handle_id = 2, talk='我不想明白，我只知道，他不能死！', dur=2 },		    	
	    	{ event = 'talk', delay= 6.5, handle_id = 2, talk='我不能再忍受那种失去亲人的痛楚！', dur=2 },
		},
		{
	    	{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {1094,861},speed = 340, dur = 1.5 ,end_dir = 7},
	    	{ event = 'talk', delay= 1, handle_id = 1, talk='[a]求次伯成全！', emote={a=48}, dur=1.8 },	  
	    	{ event = 'talk', delay= 4, handle_id = 3, talk='[a]哼！我已经说过，不可能！', emote={a=34}, dur=2},		    
		},
		{
	    	{ event = 'move', delay = 0.1,handle_id = 3, dir = 1, pos = {1055,823},speed = 340, dur = 1.5 ,end_dir = 3 },
	    	{ event = 'talk', delay= 1, handle_id = 3, talk='[a]丽华，你看清楚这个男人！', emote={a=34}, dur=2 },	  
	    	{ event = 'talk', delay= 4, handle_id = 3, talk='他要娶你，只是想利用你！根本是不爱你！',  dur=2 },
	    	{ event = 'talk', delay= 7, handle_id = 2, talk='大哥……若失去他，我也活不成了！', dur=2 },	  
	    	{ event = 'talk', delay= 10, handle_id = 3, talk='丽华！嫁给刘秀，你的人生会很辛苦……',  dur=2 },
	    	{ event = 'talk', delay= 13, handle_id = 3, talk='我只盼望，你能够平平安安地度过此生。',  dur=2 },	  
	    	{ event = 'talk', delay= 17, handle_id = 2, talk='生于乱世之中，想要平安，恐怕只是奢望了吧。',  dur=2 },
	    	{ event = 'talk', delay= 20, handle_id = 3, talk='……', emote={a=48}, dur=1.8 },	  
		},
		{
	    	{ event = 'move', delay = 0.1,handle_id = 2, dir = 1, pos = {955,843},speed = 340, dur = 1.5 ,end_dir = 3 },
	    	{ event = 'talk', delay= 1, handle_id = 2, talk='你是真的想要娶我吗？', dur=2 },	  
	    	{ event = 'talk', delay= 4, handle_id = 1, talk='是！',  dur=2 },
	    	{ event = 'talk', delay= 7, handle_id = 2, talk='好吧，我答应嫁给你。', dur=2 },	
		},

		{
	    	{ event = 'move', delay = 0.1,handle_id = 3, dir = 1, pos = {1055,823},speed = 340, dur = 1.5 ,end_dir = 5 },
	    	{ event = 'move', delay = 0.8,handle_id = 2, dir = 1, pos = {955,843},speed = 340, dur = 1.5 ,end_dir = 1 },	    	
	    	{ event = 'talk', delay= 1, handle_id = 3, talk='丽华！你疯了！！！', dur=2 },	

	    	{ event = 'move', delay = 2,handle_id = 2, dir = 1, pos = {955,843},speed = 340, dur = 1.5 ,end_dir = 3 },		    	  
	    	{ event = 'talk', delay= 3, handle_id = 2, talk='三哥回去准备吧，想什么时候亲迎都行。',  dur=3 },
	
		},






	},
	--============================================sunluyao  剧情副本第四章第三节 end    =====================================----
	--============================================sunluyao  剧情副本第四章第四节 start  =====================================----	
	['juqing441'] = 
	{

		{

			{ event='init_cimera', delay = 0.1,mx= 2229,my = 2274 }, 

	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={2029,2343}, dir=3, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=42, pos={2167,2322}, dir=7, speed=340, name_color=0xffffff, name="丁柔", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=37, pos={2558,2721}, dir=7, speed=340, name_color=0xffffff, name="赵姬", },

	    	{ event = 'move', delay = 0.2,handle_id = 3, dir = 1, pos = {2111,2381},speed = 340, dur = 1.5 ,end_dir = 7 },	
	    	{ event = 'move', delay = 1,handle_id = 2, dir = 1, pos = {2167,2322},speed = 340, dur = 1.5 ,end_dir = 3 },

	    	{ event = 'talk', delay= 1, handle_id = 3, talk='两位姐姐，求你救救我！后面有人在追我！让我躲一下好不好？',  dur=2.8 },
	    	{ event = 'talk', delay= 4, handle_id = 1, talk='什么人追你，发生了什么事？',  dur=2},	    	
	    	{ event = 'talk', delay= 6.5, handle_id = 3, talk='我，我的家人被恶人所迫，逼我成亲，我才逃出来的。',  dur=2.5 },
	    	{ event = 'talk', delay= 9.5, handle_id = 1, talk='你别担心，我帮你，你快躲进屋里。',  dur=2.2 },	

	    	{ event = 'move', delay = 11,handle_id = 3, dir = 1, pos = {1833,2273},speed = 340, dur = 1.5 ,end_dir = 5 },
	    	{ event='kill', delay=12.5, handle_id=3},	    	

		},

		{
	    	{ event ='camera', delay = 0.1, c_topox = {2574,2474}, sdur=0.1, dur = 0.1,backtime=1},	

	    	{ event ='camera', delay = 1, c_topox = {2229,2274}, sdur=2, dur = 2,backtime=1},	    		
	   		{ event='createActor', delay=0.1, handle_id=4, body=21, pos={2710,2722}, dir=7, speed=340, name_color=0xffffff, name="赵信", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=7, pos={2810,2722}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=7, pos={2810,2622}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=7, pos={2710,2822}, dir=7, speed=340, name_color=0xffffff, name="门客", },

	    	{ event = 'move', delay = 0.3,handle_id = 4, dir = 7, pos = {2210,2466},speed = 290, dur = 1.5 ,end_dir = 7 },	
	    	{ event = 'move', delay = 0.4,handle_id = 5, dir = 7, pos = {2310,2466},speed = 290, dur = 1.5 ,end_dir = 7 },
	    	{ event = 'move', delay = 0.4,handle_id = 6, dir = 7, pos = {2310,2366},speed = 290, dur = 1.5 ,end_dir = 7 },	
	    	{ event = 'move', delay = 0.4,handle_id = 7, dir = 7, pos = {2210,2566},speed = 290, dur = 1.5 ,end_dir = 7 },	  

	    	{ event = 'talk', delay= 3, handle_id = 4, talk='请问夫人，有没有看到一个女子从这里经过？',  dur=2 },
	    	{ event = 'talk', delay= 5.5, handle_id = 1, talk='未曾见到。',  dur=1.8},	    	
	    	{ event = 'talk', delay= 7.5, handle_id = 5, talk='大人，我们在此处发现了一枚发簪。',  dur=2.5 },
	    	{ event = 'talk', delay= 10.5, handle_id = 2, talk='那是我不小心落在地上了……',  dur=2.2 },	
	    	{ event = 'talk', delay= 13, handle_id = 4, talk='住口！还敢骗我！',  dur=2},	
	    	{ event = 'talk', delay= 15.5, handle_id = 4, talk='给我搜！',  dur=1.5 },	
		},

		{
	    	{ event = 'move', delay = 0.1,handle_id = 4, dir = 7, pos = {2026,2386},speed = 340, dur = 1.5 ,end_dir = 7 },	
	    	{ event = 'move', delay = 0.1,handle_id = 5, dir = 7, pos = {2126,2386},speed = 340, dur = 1.5 ,end_dir = 7 },
	    	{ event = 'move', delay = 0.1,handle_id = 6, dir = 7, pos = {2126,2286},speed = 340, dur = 1.5 ,end_dir = 6 },	
	    	{ event = 'move', delay = 0.1,handle_id = 7, dir = 7, pos = {2026,2486},speed = 340, dur = 1.5 ,end_dir = 7 },	

	    	{ event = 'move', delay = 0.5,handle_id = 1, dir = 7, pos = {1882,2320},speed = 300, dur = 1.5 ,end_dir = 3 },	

	    	{ event = 'move', delay = 1,handle_id = 2, dir = 1, pos = {2167,2322},speed = 340, dur = 1.5 ,end_dir = 6 },

	    	{ event = 'talk', delay= 1.5, handle_id = 1, talk='不准！',  dur=1.5 },
	    	{ event = 'talk', delay= 3.5, handle_id = 4, talk='我不想对女人动手，让开。',  dur=2 },	    	
	    	{ event = 'talk', delay= 6, handle_id = 1, talk='我不会让欺凌弱女之辈从我手上掠人。',  dur=2.5 },
	    	{ event = 'talk', delay= 9, handle_id = 4, talk='再不让开，休怪我对你不客气！',  dur=3 },	
	    },
	},




	['juqing442'] =
	{
		{

			{ event='init_cimera', delay = 0.1,mx= 2129,my = 2324 }, 

	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={1882,2320}, dir=3, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=42, pos={1967,2322}, dir=3, speed=340, name_color=0xffffff, name="丁柔", },

	   		{ event='createActor', delay=0.1, handle_id=4, body=21, pos={2126,2386}, dir=7, speed=340, name_color=0xffffff, name="赵信", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=7, pos={2226,2386}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=7, pos={2226,2286}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=7, pos={2126,2486}, dir=7, speed=340, name_color=0xffffff, name="门客", },	  
	   		
	   		{ event='createActor', delay=1.1, handle_id=3, body=37, pos={1833,2273}, dir=3, speed=340, name_color=0xffffff, name="赵姬", },
	    	{ event = 'move', delay = 1.2,handle_id = 3, dir = 1, pos = {2026,2386},speed = 340, dur = 1.5 ,end_dir = 2 },

	    	{ event = 'talk', delay= 1.5, handle_id = 3, talk='不得无礼。',  dur=1.5 },
	    	{ event = 'talk', delay= 3.5, handle_id = 1, talk='！',  dur=1.2 },	    	
	    	{ event = 'talk', delay= 3.5, handle_id = 2, talk='！',  dur=1.2 },
	    	{ event = 'talk', delay= 5, handle_id = 3, talk='我跟你回去，不要为难她们。',  dur=3 },	
		},
		{
	    	{ event = 'move', delay = 0.1,handle_id = 3, dir = 1, pos = {1982,2420},speed = 340, dur = 1.5 ,end_dir = 7 },

	    	{ event = 'talk', delay= 0.5, handle_id = 3, talk='姐姐仗义相救，我不会忘记。我不能再连累你们两位。谢谢你们。',  dur=2.5 },

	    	{ event = 'move', delay = 4,handle_id = 4, dir = 7, pos = {2710,2722},speed = 340, dur = 1.5 ,end_dir = 7 },	
	    	{ event = 'move', delay = 4,handle_id = 5, dir = 7, pos = {2810,2722},speed = 340, dur = 1.5 ,end_dir = 7 },
	    	{ event = 'move', delay = 4,handle_id = 6, dir = 7, pos = {2810,2622},speed = 340, dur = 1.5 ,end_dir = 6 },	
	    	{ event = 'move', delay = 4,handle_id = 7, dir = 7, pos = {2710,2822},speed = 340, dur = 1.5 ,end_dir = 7 },	
	    	{ event = 'move', delay = 4,handle_id = 3, dir = 7, pos = {2610,2722},speed = 340, dur = 1.5 ,end_dir = 7 },	

	    	{ event='kill', delay=6, handle_id=3},	
	    	{ event='kill', delay=6, handle_id=3},		
	    	{ event='kill', delay=6, handle_id=3},	
	    	{ event='kill', delay=6, handle_id=3},	
	    	{ event='kill', delay=6, handle_id=3},	

	    	{ event = 'talk', delay= 6.5, handle_id = 2, talk='这女子到底是何人？',  dur=1.8 },	    	
	    	{ event = 'talk', delay= 9, handle_id = 1, talk='纵是王侯之女，也还是身不由己。',  dur=3 },
    	
		},
		

	},

	--============================================sunluyao  剧情副本第四章第四节 end    =====================================----

	--============================================lx 剧情副本第四章第五节 start    =====================================----
	--演员表 李轶-1  门客-2  刘伯姬-3 李家护卫4~5  6-李轶2 7-刘伯姬2
	['juqing451'] = {

		--创建角色
	    {

	   		{ event='createActor', delay=0.1, handle_id=1, body=48, pos={751,2351}, dir=3, speed=340, name_color=0xffffff, name="李轶", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=19, pos={847,2449}, dir=7, speed=340, name_color=0xffffff, name="门客", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=17, pos={1169,1778}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=20, pos={1742,1808}, dir=7, speed=340, name_color=0xffffff, name="李家护卫", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=20, pos={1744,1938}, dir=7, speed=340, name_color=0xffffff, name="李家护卫", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 819,my = 2353 }, 	 
	    },
	    --BB
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='……', dur=2 },
	    	{ event = 'talk', delay= 0.1, handle_id = 2, talk='……', dur=2 },
	    	{ event = 'talk', delay= 2.5, handle_id = 1, talk='要趁在刘秀渡河之前，把他除掉……', dur=2 },
	    },
	    --刘伯姬被发现
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id='4_5_1' ,dialog_time = 1.5,}, 
	    	{ event ='camera', delay = 1, c_topox = {1166-30,1690-30}, sdur=0.5, dur = 0.5,backtime=1},
	    	{ event='showTopTalk', delay=2, dialog_id='4_5_2' ,dialog_time = 1.5,},
	    	{ event = 'talk', delay= 1.5, handle_id = 3, talk='！', dur=1.5 },
	    	{ event = 'move', delay = 2.5,handle_id = 3, dir = 1, pos = {1169+20,1778-20},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event='jump', delay=2.5, handle_id= 4, dir=7, pos={1205,1647}, speed=120, dur=1, end_dir=5 }, 
	    	{ event='jump', delay=2.5, handle_id= 5, dir=7, pos={1297,1713}, speed=120, dur=1, end_dir=5 }, 
	    	-- { event = 'move', delay = 2.5,handle_id = 4, dir = 1, pos = {1137,1680},speed = 200, dur = 1.5 ,end_dir = 5},
	    	-- { event = 'move', delay = 2.5,handle_id = 5, dir = 1, pos = {1265,1745},speed = 200, dur = 1.5 ,end_dir = 5},

	    	{ event = 'talk', delay= 3, handle_id = 4, talk='站住！', dur=1.5 },
	    	{ event = 'talk', delay= 3, handle_id = 5, talk='哪里走！', dur=1.5 },

	    	{ event='kill', delay=2, handle_id=1},
	    	{ event='kill', delay=2, handle_id=2},
	    	{ event='createActor', delay=3, handle_id=1, body=48, pos={1739,1943}, dir=3, speed=340, name_color=0xffffff, name="李轶", }, 
	    },
	    --李轶出现
	    {
	    	{ event = 'move', delay = 0,handle_id = 1, dir = 1, pos = {1442,1778},speed = 280, dur = 1.5 ,end_dir = 6},
	    	{ event = 'talk', delay= 2, handle_id = 1, talk='是伯姬？', dur=1.5 },
	    	{ event = 'talk', delay= 4.5, handle_id = 1, talk='你们都退下吧。', dur=1.5 },

			{ event = 'move', delay = 2,handle_id = 4, dir = 1, pos = {1205,1647},speed = 260, dur = 1.5 ,end_dir = 3},
	    	{ event = 'move', delay = 2,handle_id = 5, dir = 1, pos = {1297,1713},speed = 260, dur = 1.5 ,end_dir = 3},	    	
	    	{ event = 'talk', delay= 6.5, handle_id = 4, talk='诺。', dur=1.5 },
	    	{ event = 'talk', delay= 6.5, handle_id = 5, talk='诺。', dur=1.5 },
	    	{ event = 'move', delay = 7.5,handle_id = 4, dir = 1, pos = {1552,2000},speed = 260, dur = 1.5 ,end_dir = 5},
	    	{ event = 'move', delay = 7.5,handle_id = 5, dir = 1, pos = {1552,2000},speed = 260, dur = 1.5 ,end_dir = 5},

	    	{ event = 'move', delay = 2,handle_id = 3, dir = 1, pos = {1169+20,1778-20},speed = 340, dur = 1 ,end_dir = 2},
	    },
	    --李轶引敌深入
	    {
	    	{ event='kill', delay=0.1, handle_id=4},
	    	{ event='kill', delay=0.1, handle_id=5},

	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='伯姬，有事儿进来里面说。', dur=2 },
	    	{ event = 'move', delay = 2.4,handle_id = 1, dir = 1, pos = {1457,1871},speed = 340, dur = 1.5 ,end_dir = 6},
	    	{ event = 'talk', delay= 3, handle_id = 1, talk='伯姬妹妹，别怕，快进来。', dur=2 },
	    	
	    	{ event = 'talk', delay= 5.8, handle_id = 3, talk='唔……好……', dur=1.5 },
	    	{ event = 'move', delay = 2.5,handle_id = 3, dir = 1, pos = {1169+20,1778-20},speed = 340, dur = 1 ,end_dir = 3},
	    },
	    --开始BB
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {778,2348}, sdur=0.5, dur = 0.5,backtime=1},
	    	{ event='createActor', delay=0.1, handle_id=6, body=48, pos={1298,2128}, dir=3, speed=340, name_color=0xffffff, name="李轶", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=17, pos={1455,2034}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
			{ event = 'move', delay = 1,handle_id = 6, dir = 1, pos = {718,2451},speed = 340, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 7, dir = 1, pos = {849,2385},speed = 340, dur = 1.5 ,end_dir = 5},
	    	{ event = 'talk', delay = 5, handle_id = 6, talk='刚才你在外面，听见我说话了？', dur=2 },
	    	{ event = 'talk', delay = 7.2, handle_id = 7, talk='没……没有……', dur=1.5 },
	    	{ event = 'talk', delay = 9, handle_id = 6, talk='你这个贱人，还想骗我？！', dur=2 },
	    	{ event = 'move', delay = 9,handle_id = 6, dir = 1, pos = {718+20,2451-20},speed = 200, dur = 1.5 ,end_dir = 1},
	    	{ event = 'talk', delay= 11.2, handle_id = 7, talk='（大惊失色）你想做什么！', dur=2 },
	    	{ event = 'talk', delay= 13.7, handle_id = 6, talk='你自己送上门来，就别怪我无情了。', dur=1.5 },
			{ event = 'move', delay = 14,handle_id = 6, dir = 1, pos = {1136,2257},speed = 340, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 14,handle_id = 7, dir = 1, pos = {1136,2257},speed = 340, dur = 1.5 ,end_dir = 1},	    	
	    },

	},

	--演员表 李轶-1  李通-2  刘伯姬-3 刘秀-4
	['juqing452'] = 
	{
		--创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=48, pos={751,2351},  dir=3, speed=340, name_color=0xffffff, name="李轶", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=17, pos={817,2261}, dir=3, speed=340, name_color=0xffffff, name="刘伯姬", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=13, pos={1454,2060}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 849,my = 2095 }, 	 
	    },

	    {
	    	{ event = 'move', delay = 0.5,handle_id = 3, dir = 1, pos = {848,2126},speed = 340, dur = 1 ,end_dir = 1},
	    	{ event = 'move', delay = 0.5,handle_id = 1, dir = 1, pos = {816,2261},speed = 340, dur = 1 ,end_dir = 1},
	    	{ event = 'talk', delay= 1, handle_id = 3, talk='！', dur=1.5 },
	    	{ event = 'move', delay = 1.5,handle_id = 3, dir = 1, pos = {848,2126},speed = 340, dur = 1 ,end_dir = 5},
	    	{ event = 'talk', delay= 2.5, handle_id = 1, talk='嘿嘿……我今天就要得到你……', dur=2 },
	    	{ event = 'talk', delay= 4.7, handle_id = 3, talk='滚开！你这个畜生！', dur=1.5 },
			
			{ event='showTopTalk', delay=6, dialog_id='4_5_3' ,dialog_time = 1.5,}, 
	    },

	    {
	    	{ event='createActor', delay=1.7, handle_id=2, body=30, pos={624,2640},  dir=7, speed=340, name_color=0xffffff, name="李通", },

	    	{ event = 'talk', delay= 0.1, handle_id = 3, talk='李大哥！救我！', dur=1.5 },
	    	{ event = 'move', delay =0.1,handle_id = 1, dir = 1, pos = {816,2261},speed = 300, dur = 1 ,end_dir = 5},
	    	{ event = 'talk', delay= 0.5, handle_id = 1, talk='！', dur=1.5 },
	    	{ event ='camera', delay = 2, target_id= 2, sdur=0.1, dur = 0.5,style = 'follow',backtime=1},
	    	{ event ='camera', delay = 3.5, c_topox = {849,2095}, sdur=0.5, dur = 1,backtime=1},

	    	{ event = 'move', delay = 3,handle_id = 1, dir = 1, pos = {1396,2035},speed = 300, dur = 1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.5,handle_id = 2, dir = 1, pos = {816,2261},speed = 200, dur = 1 ,end_dir = 1},
	    	{ event = 'move', delay = 3.7,handle_id = 2, dir = 1, pos = {1170-40,2256},speed = 300, dur = 1 ,end_dir = 7},
	    },

	    {
	    	{ event='kill', delay=0.1, handle_id=1},

	    	{ event = 'talk', delay= 0.1, handle_id = 3, talk='啊……', dur=1.5 },
	    	{ event = 'playAction',delay = 1,  handle_id= 3, action_id = 4, dur = 0.1, dir = 5,loop = false,once = true},
	    	{ event='effect',  delay = 1.2 ,handle_id=101, target_id=3, pos={-70, 5}, effect_id=10131, is_forever = true},	--头顶星星特效
	    	{ event = 'talk', delay= 1.5, handle_id = 2, talk='伯姬——！', dur=1.5 },
	    	{ event = 'move', delay = 2,handle_id = 2, dir = 1, pos = {809-40,2202+80},speed = 200, dur = 1 ,end_dir = 1},

	    	{ event = 'move', delay = 3,handle_id = 4, dir = 1, pos = {911,2263},speed = 280, dur = 1 ,end_dir = 6},
	    	{ event = 'talk', delay= 5.5, handle_id = 2, talk='文叔……', dur=1.5 },
	    	{ event = 'talk', delay= 7.5, handle_id = 2, talk='这件事我一定给你和伯姬一个交代……', dur=2.5 },
	    	{ event = 'talk', delay= 10.3, handle_id = 4, talk='不，今日之事，多亏了次元兄相救。', dur=2},
	    	{ event = 'talk', delay= 12.8, handle_id = 2, talk='哎……告辞。', dur=1.5 },
	    },
	    {
	    	{ event = 'move', delay = 0.1,  handle_id = 2, dir = 1, pos = {1169,2255},speed = 300, dur = 1 ,end_dir = 6},
	    	{ event = 'move', delay = 1,    handle_id = 4, dir = 1, pos = {911,2263},speed = 280, dur = 1 ,end_dir = 2},
	    	{ event = 'talk', delay = 1,    handle_id = 4, talk='次元兄请留步，秀有一事相求。', dur=2 },
	    	{ event = 'talk', delay = 2.5,  handle_id = 2, talk='？', dur=1.5 },
	    	{ event = 'move', delay = 4.3,  handle_id = 4, dir = 1, pos = {1043,2255},speed = 340, dur = 1 ,end_dir = 2},
	    	{ event = 'talk', delay = 4.3,  handle_id = 4, talk='我即将动身往河北，若你愿意，伯姬便许你为妻，替我好好照顾她。', dur=3.5 },
	    	{ event = 'talk', delay = 8,    handle_id = 2, talk='文叔，你若愿将她许配给我……', dur=2},
	    	{ event = 'talk', delay = 10.2,    handle_id = 2, talk='我这一生一世，都会好好待她。', dur=2 },
	    	{ event = 'talk', delay = 12.7, handle_id = 4, talk='既如此，小妹就托付给你了！', dur=2 },
	    },
	},
	--============================================lx  剧情副本第四章第五节 end    =====================================----
	--============================================lx  剧情副本第四章第六节 start    =====================================----
	--演员表  盖延-1   刘秀-2   冯异-3     丽华-4    家眷 5~8   山贼-9~12 士兵13~18  士兵2 19~23 29  盖延2号-24  山贼2号 25~28
	['juqing461'] =
	{
		--创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=47, pos={3470,1777},  dir=5, speed=340, name_color=0xffffff, name="盖延", },
	   		{ event='createActor', delay=0.1, handle_id=9,  body=31, pos={3569,1807}, dir=5, speed=340, name_color=0xffffff, name="山贼", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=31, pos={3667,1778}, dir=5, speed=340, name_color=0xffffff, name="山贼", },
	   		{ event='createActor', delay=0.1, handle_id=11, body=32, pos={3474,1682}, dir=5, speed=340, name_color=0xffffff, name="山贼", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=32, pos={3601,1683}, dir=5, speed=340, name_color=0xffffff, name="山贼", },

	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={2835,2515}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=6,  pos={2932,2545}, dir=5, speed=340, name_color=0xffffff, name="阴丽华",},
	   		{ event='createActor', delay=0.1, handle_id=5, body=41, pos={2897,2611}, dir=6, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=41, pos={2798,2641}, dir=1, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=52, pos={2735,2609}, dir=1, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=52, pos={2739,2545}, dir=2, speed=340, name_color=0xffffff, name="家眷", },

	   	},

	   	--镜头初始化
	   	{
	   		-- { event='init_cimera', delay = 0.1,mx= 2177,my = 1794 }, 
	   		{ event='init_cimera', delay = 0.1,mx= 2798,my = 2576-50 }, 	 
	    },	
	    --装老弱病残
	    {

	    	-- { event='move', delay=0.5, handle_id=2, end_dir=3, pos={3055,2867}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=4, end_dir=3, pos={3121,2832}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=5, end_dir=3, pos={2931,2833}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=6, end_dir=3, pos={3025,2739}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=7, end_dir=3, pos={2832,2768}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=8, end_dir=3, pos={2959,2675}, speed=340, dur=1 },
	   		{ event = 'talk', delay = 1, handle_id = 2, talk='……', dur=1.5 },
	   		{ event = 'talk', delay = 1, handle_id = 5, talk='……', dur=1.5 },
	   		{ event = 'talk', delay = 1, handle_id = 7, talk='……', dur=1.5 },
	   		{ event = 'talk', delay = 1, handle_id = 8, talk='……', dur=1.5 },


	    },
	    --给山贼镜头了
	    {
	    	{ event = 'camera', delay = 0.5, target_id= 12, sdur=1, dur = 0.5,style = 'follow',backtime=1},
	    	{ event ='playAction', delay = 1, handle_id = 1, action_id = 2, dur=0, dir=5, loop=false ,once=false},
	    	{ event = 'talk', delay = 1, handle_id = 1,  talk='杀——！', dur=2.5 },
	    	{ event = 'talk', delay = 2, handle_id = 9,  talk='杀——！', dur=1.5 },
	    	{ event = 'talk', delay = 2, handle_id = 10, talk='杀——！', dur=1.5 },
	    	{ event = 'talk', delay = 2, handle_id = 11, talk='杀——！', dur=1.5 },
	    	{ event = 'talk', delay = 2, handle_id = 12, talk='杀——！', dur=1.5 },

	    	-- { event = 'move', delay=2, handle_id=1, end_dir=5, pos={3470-224,1777+192}, speed=340, dur=1 },
	   		-- { event = 'move', delay=2, handle_id=9, end_dir=5, pos={3569-224,1807+192}, speed=340, dur=1 },
	   		-- { event = 'move', delay=2, handle_id=10, end_dir=5, pos={3667-224,1778+192}, speed=340, dur=1 },
	   		-- { event = 'move', delay=2, handle_id=11, end_dir=5, pos={3474-224,1682+192}, speed=340, dur=1 },
	   		-- { event = 'move', delay=2, handle_id=12, end_dir=5, pos={3601-224,1683+192}, speed=340, dur=1 },

	   		{ event='move', delay=2, handle_id=1, end_dir=5, pos={3060,2193}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=9, end_dir=5, pos={3155,2223}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=10, end_dir=5, pos={3250,2191}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=11, end_dir=5, pos={3060,2097}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=12, end_dir=5, pos={3218,2092}, speed=340, dur=1 },


	    },
	    --回到刘秀他们身上
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {2798,2576-50}, sdur=2, dur =0.5,backtime=1},

	    	{ event='showTopTalk', delay=1, dialog_id="4_6_1" ,dialog_time = 2},

	    	-- { event='move', delay=0.5, handle_id=2, end_dir=3, pos={3055,2867}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=4, end_dir=3, pos={3121,2832}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=5, end_dir=3, pos={2931,2833}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=6, end_dir=3, pos={3025,2739}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=7, end_dir=3, pos={2832,2768}, speed=340, dur=1 },
	   		-- { event='move', delay=0.5, handle_id=8, end_dir=3, pos={2959,2675}, speed=340, dur=1 },

	   		{ event='move', delay=2, handle_id=2, end_dir=1, pos={2835,2515}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=4, end_dir=1, pos={2932,2545}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=5, end_dir=1, pos={2897,2611}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=6, end_dir=1, pos={2798,2641}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=7, end_dir=1, pos={2735,2609}, speed=340, dur=1 },
	   		{ event='move', delay=2, handle_id=8, end_dir=1, pos={2739,2545}, speed=340, dur=1 },

	   		{ event = 'talk', delay = 3, handle_id = 2, talk='[a]大家快逃！', dur=1.5 ,emote={a=41}},

	   		{ event ='camera', delay = 4, c_topox = {2736+100,2378}, sdur=2, dur=1,backtime=1},

			{ event='move', delay=4, handle_id=2, end_dir=7, pos={2197-100,2382}, speed=340, dur=1 },
	   		{ event='move', delay=4, handle_id=4, end_dir=7, pos={2290-100,2419}, speed=340, dur=1 },
	   		{ event='move', delay=4, handle_id=5, end_dir=7, pos={2224-100,2513}, speed=340, dur=1 },
	   		{ event='move', delay=4, handle_id=6, end_dir=7, pos={2160-100,2546}, speed=340, dur=1 },
	   		{ event='move', delay=4, handle_id=7, end_dir=7, pos={2094-100,2512}, speed=340, dur=1 },
	   		{ event='move', delay=4, handle_id=8, end_dir=7, pos={2096-100,2419}, speed=340, dur=1 },	


	   		{ event='move', delay=4.5, handle_id=1,  end_dir=6, pos={2737,2478}, speed=300, dur=1 },
	   		{ event='move', delay=4.5, handle_id=9,  end_dir=6, pos={2865,2511}, speed=280, dur=1 },
	   		{ event='move', delay=4.5, handle_id=10, end_dir=6, pos={2815,2385}, speed=280, dur=1 },
	   		{ event='move', delay=4.5, handle_id=11, end_dir=6, pos={2996,2416}, speed=280, dur=1 },
	   		{ event='move', delay=4.5, handle_id=12, end_dir=6, pos={2911,2344}, speed=280, dur=1 },

	   		{ event = 'talk', delay = 6, handle_id = 1, talk='弟兄们，上！', dur=2 },  

	   		{ event='move', delay=6.7, handle_id=1,  end_dir=5, pos={1972,2577}, speed=250, dur=2 },
	   		{ event='move', delay=6.7, handle_id=9,  end_dir=5, pos={1972,2577}, speed=250, dur=2 },
	   		{ event='move', delay=6.7, handle_id=10, end_dir=5, pos={1972,2577}, speed=250, dur=2 },
	   		{ event='move', delay=6.7, handle_id=11, end_dir=5, pos={1972,2577}, speed=250, dur=2 },
	   		{ event='move', delay=6.7, handle_id=12, end_dir=5, pos={1972,2577}, speed=250, dur=2 }, 		
	    },
	    --土匪追来，刘秀众人消失
	    {
	    	{ event='kill', delay=1, handle_id=2}, 
	   		{ event='kill', delay=1, handle_id=4}, 
	   		{ event='kill', delay=1, handle_id=5}, 
	   		{ event='kill', delay=1, handle_id=6},
	   		{ event='kill', delay=1, handle_id=7},
	   		{ event='kill', delay=1, handle_id=8},   

			{ event='kill', delay=1, handle_id=1}, 
	   		{ event='kill', delay=1, handle_id=9}, 
	   		{ event='kill', delay=1, handle_id=10}, 
	   		{ event='kill', delay=1, handle_id=11},
	   		{ event='kill', delay=1, handle_id=12},
	   		{ event='kill', delay=1, handle_id=13}, 	   		

	   		-- { event='hideCast', delay=5, handle_id=1}, 	--隐藏实体
	    	-- { event='showCast', delay=5, handle_id=1}, 	--显示实体

	    	--创建并且隐藏
	   		{ event='createActor', delay=0.1, handle_id=24, body=47, pos={2096,2482},  dir=3, speed=340, name_color=0xffffff, name="盖延", },
	   		{ event='createActor', delay=0.1, handle_id=25, body=31, pos={2192,2515}, dir=7, speed=340, name_color=0xffffff, name="山贼", },
	   		{ event='createActor', delay=0.1, handle_id=26, body=31, pos={2195,2422}, dir=7, speed=340, name_color=0xffffff, name="山贼", },
	   		{ event='createActor', delay=0.1, handle_id=27, body=32, pos={2195,2422}, dir=7, speed=340, name_color=0xffffff, name="山贼", },
	   		{ event='createActor', delay=0.1, handle_id=28, body=32, pos={2192,2515}, dir=7, speed=340, name_color=0xffffff, name="山贼", },

	   		{ event='hideCast', delay=1, handle_id=24}, 	
	   		{ event='hideCast', delay=1, handle_id=25}, 
	   		{ event='hideCast', delay=1, handle_id=26}, 
	   		{ event='hideCast', delay=1, handle_id=27}, 
	   		{ event='hideCast', delay=1, handle_id=28}, 


	    },

	    --移动镜头发现被骗了
	    {
	    	{ event='showCast', delay=0.5, handle_id=24}, 	
	   		{ event='showCast', delay=0.5, handle_id=25}, 
	   		{ event='showCast', delay=0.5, handle_id=26}, 
	   		{ event='showCast', delay=0.5, handle_id=27}, 
	   		{ event='showCast', delay=0.5, handle_id=28}, 

	   		{ event ='camera', delay = 0.1, c_topox = {1775,2622}, sdur=2, dur = 0.5,backtime=1},

	    	{ event='move', delay=0.7, handle_id=24, end_dir=5, pos={1649,2770}, speed=300, dur=1 },
	   		{ event='move', delay=0.7, handle_id=25, end_dir=5, pos={1743,2740}, speed=300, dur=1 },
	   		{ event='move', delay=0.7, handle_id=26, end_dir=5, pos={1682,2674}, speed=300, dur=1 },
	   		{ event='move', delay=0.7, handle_id=27, end_dir=5, pos={1811,2673}, speed=300, dur=1 },
	   		{ event='move', delay=0.7, handle_id=28, end_dir=5, pos={1743,2609}, speed=300, dur=1 },

			{ event='move', delay=4, handle_id=24, end_dir=1, pos={1649,2770}, speed=300, dur=1 },
	   		{ event='move', delay=4, handle_id=25, end_dir=2, pos={1743,2740}, speed=300, dur=1 },
	   		{ event='move', delay=4, handle_id=26, end_dir=5, pos={1682,2674}, speed=300, dur=1 },
	   		{ event='move', delay=4, handle_id=27, end_dir=2, pos={1811,2673}, speed=300, dur=1 },
	   		{ event='move', delay=4, handle_id=28, end_dir=7, pos={1743,2609}, speed=300, dur=1 },

	   		{ event='move', delay=5, handle_id=24, end_dir=5, pos={1587,2836}, speed=280, dur=1 },
	   		{ event='move', delay=5, handle_id=25, end_dir=7, pos={1809,2803}, speed=280, dur=1 },
	   		{ event='move', delay=5, handle_id=26, end_dir=1, pos={1615,2610}, speed=280, dur=1 },
	   		{ event='move', delay=5, handle_id=27, end_dir=6, pos={1903,2642}, speed=280, dur=1 },
	   		{ event='move', delay=5, handle_id=28, end_dir=3, pos={1744,2546}, speed=280, dur=1 },	   		

	   		{ event = 'talk', delay = 5, handle_id = 24, talk='？', dur=2 },
	   		{ event = 'talk', delay = 5, handle_id = 25, talk='？', dur=2 },
	   		{ event = 'talk', delay = 5, handle_id = 26, talk='？', dur=2 },
	   		{ event = 'talk', delay = 5, handle_id = 27, talk='？', dur=2 },


	   		{ event='move', delay=6, handle_id=24, end_dir=1, pos={1587,2836}, speed=340, dur=1 },
	   		{ event='move', delay=6, handle_id=25, end_dir=3, pos={1809,2803}, speed=340, dur=1 },
	   		{ event='move', delay=6, handle_id=26, end_dir=5, pos={1615,2610}, speed=340, dur=1 },
	   		{ event='move', delay=6, handle_id=27, end_dir=2, pos={1903,2642}, speed=340, dur=1 },
	   		{ event='move', delay=6, handle_id=28, end_dir=7, pos={1744,2546}, speed=340, dur=1 },

			{ event='move', delay=7, handle_id=24, end_dir=1, pos={1649,2770}, speed=300, dur=0.5 },
	   		{ event='move', delay=7, handle_id=25, end_dir=7, pos={1743,2740}, speed=300, dur=0.5 },
	   		{ event='move', delay=7, handle_id=26, end_dir=3, pos={1682,2674}, speed=300, dur=0.5 },
	   		{ event='move', delay=7, handle_id=27, end_dir=7, pos={1811,2673}, speed=300, dur=0.5 },
	   		{ event='move', delay=7, handle_id=28, end_dir=3, pos={1743,2609}, speed=300, dur=0.5 },

	    },

	    --刘秀众人带兵来
	    {	

	    	{ event = 'talk', delay = 0.1, handle_id = 24, talk='人呢？', dur=2 },
	   		{ event = 'talk', delay = 0.1, handle_id = 27, talk='人呢？', dur=2 },

	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={817,2261}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=6, pos={1454,2060}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=19, body=26, pos={817,2261}, dir=3, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=20, body=26, pos={1454,2060}, dir=7, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=21, body=26, pos={817,2261}, dir=3, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=22, body=26, pos={1454,2060}, dir=7, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=23, body=26, pos={817,2261}, dir=3, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=29, body=26, pos={1454,2060}, dir=7, speed=340, name_color=0xffffff, name="士兵", },	


	   		{ event='createActor', delay=0.1, handle_id=3,  body=34, pos={2222,2225}, dir=5, speed=340, name_color=0xffffff, name="冯异", },
	    	{ event='createActor', delay=0.1, handle_id=13, body=25, pos={2159,2161}, dir=5, speed=340, name_color=0xffffff, name="士兵", },
	    	{ event='createActor', delay=0.1, handle_id=14, body=25, pos={2289,2161}, dir=5, speed=340, name_color=0xffffff, name="士兵", },
	    	{ event='createActor', delay=0.1, handle_id=15, body=25, pos={2159,2065}, dir=5, speed=340, name_color=0xffffff, name="士兵", },
	    	{ event='createActor', delay=0.1, handle_id=16, body=25, pos={2289,2065}, dir=5, speed=340, name_color=0xffffff, name="士兵", },
	    	{ event='createActor', delay=0.1, handle_id=17, body=25, pos={2161,1968}, dir=5, speed=340, name_color=0xffffff, name="士兵", },
	    	{ event='createActor', delay=0.1, handle_id=18, body=25, pos={2289,1968}, dir=5, speed=340, name_color=0xffffff, name="士兵", },   		
	    },

	    --冯异带人出现
	    {

	    	{event ='camera', delay = 0.5, target_id= 3, sdur=2, dur = 0.5,style = 'follow',backtime=1},

	    	{ event='move', delay=1.5, handle_id=3, end_dir=5, pos={1937,2576}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=13, end_dir=5, pos={1968,2481}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=14, end_dir=5, pos={2034,2547}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=15, end_dir=5, pos={2033,2414}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=16, end_dir=5, pos={2096,2482}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=17, end_dir=5, pos={2094,2353}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=18, end_dir=5, pos={2161,2416}, speed=340, dur=1 },

	   		{ event = 'talk', delay = 1, handle_id = 3, talk='杀——！', dur=2 },
	    },

        --盖延被包围
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {1960,2572}, sdur=2, dur = 1,backtime=1},

	    	{ event='move', delay=0.1, handle_id=24, end_dir=1, pos={1649,2770}, speed=300, dur=1 },
	   		{ event='move', delay=0.1, handle_id=25, end_dir=1, pos={1743,2740}, speed=300, dur=1 },
	   		{ event='move', delay=0.1, handle_id=26, end_dir=1, pos={1682,2674}, speed=300, dur=1 },
	   		{ event='move', delay=0.1, handle_id=27, end_dir=1, pos={1811,2673}, speed=300, dur=1 },
	   		{ event='move', delay=0.1, handle_id=28, end_dir=1, pos={1743,2609}, speed=300, dur=1 },
 
 			{ event = 'talk', delay = 1, handle_id = 24, talk='中计了！快逃！', dur=2 },

 			{ event='move', delay=1.5, handle_id=24, end_dir=2, pos={1649+60,2770}, speed=300, dur=1 },
	   		{ event='move', delay=1.5, handle_id=25, end_dir=2, pos={1743+60,2740}, speed=300, dur=1 },
	   		{ event='move', delay=1.5, handle_id=26, end_dir=2, pos={1682+60,2674}, speed=300, dur=1 },
	   		{ event='move', delay=1.5, handle_id=27, end_dir=2, pos={1811+60,2673}, speed=300, dur=1 },
	   		{ event='move', delay=1.5, handle_id=28, end_dir=2, pos={1743+60,2609}, speed=300, dur=1 },


	   		{ event='move', delay=1.8, handle_id=2, end_dir=5, pos={2066,2642}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=4, end_dir=5, pos={2127,2706}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=19, end_dir=5, pos={2225,2674}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=20, end_dir=5, pos={2159,2577}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=21, end_dir=5, pos={2288,2642}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=22, end_dir=5, pos={2224,2547}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=23, end_dir=5, pos={2353,2575}, speed=340, dur=1 },
	   		{ event='move', delay=1.8, handle_id=29, end_dir=5, pos={2286,2514}, speed=340, dur=1 },

	   		{ event = 'talk', delay = 2.5, handle_id = 4, talk='哪里跑！', dur=2 },
	    },

	},

	--演员表  盖延-1   刘秀-2   冯异-3     吴汉-4    耿纯-5   阴丽华-6
	['juqing462'] = 
	{
		--创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=47, pos={1616,2801}, dir=1, speed=340, name_color=0xffffff, name="盖延", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={1553,2607}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=34, pos={1745,2545}, dir=5, speed=340, name_color=0xffffff, name="冯异", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=8, pos={1894,2558}, dir=5, speed=340, name_color=0xffffff, name="吴汉", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=30, pos={1905,2673}, dir=5, speed=340, name_color=0xffffff, name="耿纯", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=6, pos={1982,2763}, dir=6, speed=340, name_color=0xffffff, name="阴丽华", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1759,my = 2580 }, 	 
	    },

	    --盖延挨打
	    {
	    	{ event ='move', delay = 0.1, handle_id=5, end_dir=5, pos={1685+20,2732-20}, speed=300, dur=1},
	    	{ event ='talk', delay = 1.5, handle_id = 5, talk='[a]把我妻儿交出来！马上！', dur=2,emote= {a=34}},
	    	{ event ='playAction', delay = 2.5, handle_id = 5, action_id = 2, dur=0, dir=5, loop=false ,once=false},
	    	{ event ='playAction', delay = 3, handle_id = 1, action_id = 3, dur=0, dir=1, loop=false ,once=false},
	    	{ event ='talk', delay = 3, handle_id = 1, talk='啊—！', dur=1.5 },

	    	{ event ='move', delay = 3.5, handle_id = 4, end_dir=5, pos={1787+20,2664-20}, speed=200, dur=1},
	    	{ event ='talk', delay = 3.5, handle_id = 4, talk='慢！', dur=1.5 },

	    	{ event ='move', delay = 4, handle_id =2, end_dir=3, pos={1553,2607}, speed=300, dur=1},
	    	{ event ='move', delay = 4, handle_id =3, end_dir=3, pos={1745,2545}, speed=300, dur=1},
	    	{ event ='move', delay = 4, handle_id =5, end_dir=1, pos={1685+20,2732-20}, speed=300, dur=1},
	    	{ event ='move', delay = 4, handle_id =6, end_dir=7, pos={1982,2763}, speed=300, dur=1},

	    	{ event ='talk', delay = 4.5, handle_id = 5, talk='[a]你想做什么？！', dur=1.5 ,emote= {a=14}},

	    	{ event ='move', delay = 7, handle_id =2, end_dir=3, pos={1553,2607}, speed=300, dur=1},
	    	{ event ='move', delay = 7, handle_id =3, end_dir=5, pos={1745,2545}, speed=300, dur=1},
	    	{ event ='move', delay = 7, handle_id =5, end_dir=5, pos={1685+30,2732-30}, speed=300, dur=1},
	    	{ event ='move', delay = 7, handle_id =6, end_dir=6, pos={1982,2763}, speed=300, dur=1},


	    	{ event ='move', delay = 6.5, handle_id =4, end_dir=6, pos={1739,2770}, speed=300, dur=1},
	    	{ event ='move', delay = 8, handle_id =4, end_dir=3, pos={1550,2748}, speed=150, dur=1},
	    	{ event ='move', delay = 9, handle_id =4, end_dir=5, pos={1670,2748}, speed=150, dur=1.3},

	    	-- { event ='move', delay = 7, handle_id =1, end_dir=2, pos={1616,2801}, speed=300, dur=1},
	    	-- { event ='move', delay = 8.5, handle_id =1, end_dir=7, pos={1616,2801}, speed=300, dur=1},
	    	-- { event ='move', delay = 10, handle_id =1, end_dir=1, pos={1616,2801}, speed=300, dur=1},
	    },
	    --吴汉和盖延相认
	    {
	    	{ event ='talk', delay = 0.1, handle_id = 4, talk='你是盖延兄弟？！在邯郸就听说匪寇身高八尺，使把大刀，果然是你！', dur=3 },
	    	{ event ='talk', delay = 3.5, handle_id = 1, talk='吴…吴大哥？', dur=1.5 },
	    	{ event ='move', delay = 5.5, handle_id = 4, end_dir=1, pos={1491,2650}, speed=300, dur=1},

			{ event ='move', delay = 6, handle_id =2, end_dir=5, pos={1553,2607}, speed=300, dur=1},
	    	{ event ='move', delay = 6, handle_id =3, end_dir=5, pos={1745,2545}, speed=300, dur=1},
	    	{ event ='move', delay = 6, handle_id =5, end_dir=7, pos={1685+30,2732-30}, speed=300, dur=1},
	    	{ event ='move', delay = 6, handle_id =1, end_dir=7, pos={1616,2801}, speed=300, dur=1},

	    	{ event ='talk', delay = 7, handle_id = 4, talk='大将军，此人名盖延，曾随我贩马为生，是换命的弟兄。', dur=3 },
	    	{ event ='talk', delay = 10.2, handle_id = 4, talk='不知怎地沦落到这般地步，还请大将军饶他一命。', dur=2.5 },
	    	
	    	{ event ='move', delay = 13.5, handle_id = 4, end_dir=3, pos={1491,2650}, speed=300, dur=1},
	    	{ event ='move', delay = 13.5, handle_id = 5, end_dir=5, pos={1685+30,2732-30}, speed=300, dur=1},
	    	{ event ='move', delay = 13.5, handle_id = 2, end_dir=3, pos={1553,2607}, speed=300, dur=1},

	    	{ event ='talk', delay = 13.5, handle_id = 1, talk='吴大哥，小弟实在是走投无路才当了山贼。', dur=2 },
	    	{ event ='talk', delay = 15.7, handle_id = 4, talk='先别说了，快！让人先把耿纯的家眷带出来。', dur=2 },

	    	{ event ='talk', delay = 18.2, handle_id = 2, talk='……', dur=2},

	    	{ event ='move', delay = 18.5, handle_id = 4, end_dir=1, pos={1491,2650}, speed=300, dur=1},
	    	{ event ='move', delay = 18.5, handle_id = 5, end_dir=7, pos={1685+30,2732-30}, speed=300, dur=1},

	    },
	    --刘秀求情
	    {
	    	{ event ='move', delay=0.1, handle_id=2, end_dir=3, pos={1646,2633}, speed=300, dur=1},
	    	{ event ='talk', delay = 1.5, handle_id = 2, talk='伯山，他既然是我的奔命兵，我便代手下弟兄，向你求一个情。', dur=3 },
	    	{ event ='talk', delay = 5.5, handle_id = 5, talk='只要把我妻儿平安放回来，这人听凭大将军处置就行。', dur=3 },
	    },

	},

	--============================================  lx  剧情副本第四章第六节 end    =====================================----
	--============================================	sunluyao	剧情副本5-1    start  =========================================

	['juqing511'] =
	{		
		{

	   		{ event='createActor', delay=0.1, handle_id=1, body=48, pos={2270,1700}, dir=2, speed=340, name_color=0xffffff, name="刘林", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=7 , pos={2270-100,1700+50}, dir=2, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=7 , pos={2270-100,1700-50}, dir=2, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=29, pos={2270-200,1700+50}, dir=2, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=29, pos={2270-200,1700-50}, dir=2, speed=340, name_color=0xffffff, name="随从", },

		},
		{
	   		{ event='init_cimera', delay = 0.1,mx= 2310,my = 1570 }, 	 
		},
		{
	    	{ event ='camera', delay = 1, c_topox = {2587,1372}, sdur=1.5, dur = 1.5,backtime=1},	
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=2, pos={2760,1450}, speed=300, dur=2},
	    	{ event ='move', delay=0.1, handle_id=2, end_dir=2, pos={2760-100,1450+50}, speed=300, dur=2},
	    	{ event ='move', delay=0.1, handle_id=3, end_dir=2, pos={2760-100,1450-50}, speed=300, dur=2},
	    	{ event ='move', delay=0.1, handle_id=4, end_dir=2, pos={2760-200,1450+50}, speed=300, dur=2},
	    	{ event ='move', delay=0.1, handle_id=5, end_dir=2, pos={2760-200,1450-50}, speed=300, dur=2},

	    	{ event ='talk', delay = 1.5, handle_id = 3, talk='将军，咱们真的要……', dur=1.8 },	    	
		},
		{
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=6, pos={2760,1450}, speed=300, dur=0.5},	
	    	{ event ='talk', delay = 1, handle_id = 1, talk='废话！刘秀那厮不识好歹！这功劳咱们可不能放过！', dur=2.8 },	 
	    	{ event ='talk', delay = 4, handle_id = 1, talk='[a]给我下锄！', dur=1.8 ,emote={a=34},},	
		},
		{
	    	{ event ='talk', delay = 0.1, handle_id = 5, talk='啊——！', dur=1.8 ,},	
	   		{ event='playAction', delay = 0.3, handle_id = 5, action_id = 4, dur=0, dir=1, loop=false ,once=true},	
	    	{ event ='talk', delay = 2.2, handle_id = 1, talk='[a]怎么回事！', dur=1.8 ,emote={a=44},},	
	    	{ event ='move', delay=2.2, handle_id=2, end_dir=6, pos={2760-100,1450+50}, speed=300, dur=0.5},
	    	{ event ='move', delay=2.2, handle_id=3, end_dir=6, pos={2760-100,1450-50}, speed=300, dur=0.5},
	    	{ event ='move', delay=2.2, handle_id=4, end_dir=6, pos={2760-200,1450+50}, speed=300, dur=0.5},    		   		    	
		},
		{
	    	{ event ='camera', delay = 0.1, c_topox = {2130,1555}, sdur=0.1, dur = 0.1,backtime=1},
		    { event ='camera', delay = 0.5, c_topox = {2487,1422}, sdur=1, dur = 1,backtime=1},    	
	   		{ event='createActor', delay=0.1, handle_id=6 , body=12, pos={2130-100,1555+40}, dir=2, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=7 , body=8 , pos={2130,1555}, dir=2, speed=340, name_color=0xffffff, name="王霸", },
	   		{ event='createActor', delay=0.1, handle_id=8 , body=5 , pos={2130-100,1555-40}, dir=2, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=9 , body=34, pos={2130-200,1555+40}, dir=2, speed=340, name_color=0xffffff, name="冯异", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=43, pos={2130-200,1555-40}, dir=2, speed=340, name_color=0xffffff, name="姚期", },
	   		{ event='createActor', delay=0.1, handle_id=11, body=25, pos={2130-280,1555+80}, dir=2, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=25, pos={2130-280,1555-80}, dir=2, speed=340, name_color=0xffffff, name="士兵", },

	    	{ event ='move', delay=0.2, handle_id=7 , end_dir=2, pos={2410,1470}, speed=300, dur=2},
	    	{ event ='move', delay=0.2, handle_id=6 , end_dir=2, pos={2410-100,1470+40}, speed=300, dur=2},
	    	{ event ='move', delay=0.2, handle_id=8 , end_dir=2, pos={2410-100,1470-40}, speed=300, dur=2},
	   		{ event ='move', delay=0.2, handle_id=9 , end_dir=2, pos={2410-200,1470+40}, speed=300, dur=2},
	    	{ event ='move', delay=0.2, handle_id=10, end_dir=2, pos={2410-200,1470-40}, speed=300, dur=2},
	    	{ event ='move', delay=0.2, handle_id=11, end_dir=2, pos={2410-280,1470+80}, speed=300, dur=2},
	    	{ event ='move', delay=0.2, handle_id=12, end_dir=2, pos={2410-280,1470-80}, speed=300, dur=2},

		},

		{
	    	{ event ='talk', delay = 0.1, handle_id = 7, talk='[a]谁敢掘堤！老子第一个杀了他！', dur=3 ,emote={a=24},},		
		},

	},
	['juqing512'] =
	{
		{
	   		{ event='createActor', delay=0.1, handle_id=1, body=48, pos={2760,1450}, dir=6, speed=340, name_color=0xffffff, name="刘林", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=7 , pos={2760-100,1450+50}, dir=6, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=7 , pos={2760-100,1450-50}, dir=6, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=29, pos={2760-200,1450+50}, dir=6, speed=340, name_color=0xffffff, name="随从", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=29, pos={2760-200,1450-50}, dir=6, speed=340, name_color=0xffffff, name="随从", },

	   		{ event='createActor', delay=0.1, handle_id=6 , body=12, pos={2410-100,1470+40}, dir=2, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=7 , body=8 , pos={2410,1470}, dir=2, speed=340, name_color=0xffffff, name="王霸", },
	   		{ event='createActor', delay=0.1, handle_id=8 , body=5 , pos={2410-100,1470-40}, dir=2, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=9 , body=34, pos={2410-200,1470+40}, dir=2, speed=340, name_color=0xffffff, name="冯异", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=43, pos={2410-200,1470-40}, dir=2, speed=340, name_color=0xffffff, name="姚期", },
	   		{ event='createActor', delay=0.1, handle_id=11, body=25, pos={2410-280,1470+80}, dir=2, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=25, pos={2410-280,1470-80}, dir=2, speed=340, name_color=0xffffff, name="士兵", },

	   		{ event='playAction', delay = 0.2, handle_id = 5, action_id = 4, dur=0, dir=1, loop=false ,once=true},	
	   		{ event='init_cimera', delay = 0.2,mx= 2487,my = 1422 }, 	   			   		
		},
		{
	    	{ event ='move', delay=0.5, handle_id=6 , end_dir=2, pos={2410,1470}, speed=300, dur=2},
	    	{ event ='move', delay=0.1, handle_id=7 , end_dir=2, pos={2410-50,1470+50}, speed=300, dur=2},

	    	{ event ='talk', delay = 1, handle_id = 6, talk='[a]刘林，你好大的胆子！', dur=2 ,emote={a=34},},			    			    	
		},
		{
	    	{ event ='move', delay=0.1, handle_id=1 , end_dir=6, pos={2560,1450}, speed=300, dur=2},

	    	{ event ='move', delay=0.2, handle_id=2 , end_dir=6, pos={2760-100,1450+80}, speed=300, dur=2},
	    	{ event ='move', delay=0.2, handle_id=3 , end_dir=6, pos={2760-100,1450-80}, speed=300, dur=2},
	    	{ event ='move', delay=0.4, handle_id=4 , end_dir=6, pos={2760-200,1450+80}, speed=300, dur=2},


	    	{ event ='talk', delay = 1, handle_id = 1, talk='刘秀，你来河北是宣慰招抚的，该办的事不办，到处得罪人……', dur=3 ,},
		},
		{
	   		{ event='playAction', delay = 0.1, handle_id = 6, action_id = 2, dur=0, dir=2, loop=false ,},			
	    	{ event ='talk', delay = 0.5, handle_id = 6, talk='[a]就算把你们得罪个遍！也不容你杀害无辜百姓！', dur=3 ,emote={a=24},},	
		},
		{
	    	{ event ='move', delay=0.1, handle_id=1 , end_dir=6, pos={2630,1450}, speed=30, dur=0.2},		
	    	{ event ='talk', delay = 0.5, handle_id = 1, talk='[a]我乃赵王太子，为朝廷平乱剿匪，你敢阻我，我……', dur=3 ,emote={a=28},},

	   		{ event='jump', delay=3, handle_id= 8, dir=1, pos={2520,1450}, speed=120, dur=0.2, end_dir=2 }, 
	   		{ event='playAction', delay = 3.8, handle_id = 8, action_id = 2, dur=0.5, dir=2, loop=false ,},
	   		{ event='playAction', delay = 3.9, handle_id = 1, action_id = 3, dur=0.5, dir=6, loop=false ,},	
		},
		{
	    	{ event ='talk', delay = 0.1, handle_id = 8, talk='大将军奉旨宣慰河北，敢对大将军无礼，逆贼论处！', dur=3 ,},
	    	{ event ='talk', delay = 3.5, handle_id = 1, talk='你……！', dur=1.8 ,},	
	    	{ event ='talk', delay = 5.5, handle_id = 1, talk='哼！我们走！', dur=1.8 ,},	  	    	    	
		},
		{
	    	{ event ='move', delay=0.1, handle_id=1 , end_dir=6, pos={2260,2190}, speed=300, dur=2},	
	    	{ event ='move', delay=0.1, handle_id=2 , end_dir=6, pos={2260,2190}, speed=300, dur=2},	
	    	{ event ='move', delay=0.1, handle_id=3 , end_dir=6, pos={2260,2190}, speed=300, dur=2},	
	    	{ event ='move', delay=0.1, handle_id=4 , end_dir=6, pos={2260,2190}, speed=300, dur=2},	

	    	{ event ='move', delay=1, handle_id=6 , end_dir=5, pos={2410,1470}, speed=300, dur=2},	
	    	{ event ='move', delay=1, handle_id=7 , end_dir=5, pos={2410-50,1470+50}, speed=300, dur=2},	
	    	{ event ='move', delay=1, handle_id=8 , end_dir=5, pos={2520,1450}, speed=300, dur=2},
	    	{ event ='move', delay=1, handle_id=9 , end_dir=5, pos={2410-200,1470+40}, speed=300, dur=2},	
	    	{ event ='move', delay=1, handle_id=10 , end_dir=5, pos={2410-200,1470-40}, speed=300, dur=2},	
	    	{ event ='move', delay=1, handle_id=11 , end_dir=5, pos={2410-280,1470+80}, speed=300, dur=2},
	    	{ event ='move', delay=1, handle_id=12 , end_dir=5, pos={2410-280,1470-80}, speed=300, dur=2},	    	
		},
		{
	   		{ event='kill', delay=0.1, handle_id=1}, 
	   		{ event='kill', delay=0.1, handle_id=2}, 
	   		{ event='kill', delay=0.1, handle_id=3}, 
	   		{ event='kill', delay=0.1, handle_id=4},
	   		{ event='kill', delay=0.1, handle_id=5},

	    	{ event ='talk', delay = 0.1, handle_id = 7, talk='还好公孙那一箭去得快，否则河堤一毁，得死多少人啊。', dur=3 ,},

	    	{ event ='move', delay=3, handle_id=8 , end_dir=5, pos={2500,1450}, speed=300, dur=2},	    	
	    	{ event ='talk', delay = 3.5, handle_id = 8, talk='三哥，邯郸这块地方，只怕不能再呆下去了。', dur=2.5 ,},	
	    	{ event ='talk', delay = 6.5, handle_id = 6, talk='此处不容人，自有容人处，山高水阔，继续北上，总能找到合适的地方。', dur=3.5 ,},	
		},
		{
	    	{ event ='move', delay=0.1, handle_id=6 , end_dir=5, pos={2200,1090}, speed=300, dur=2},	
	    	{ event ='move', delay=0.5, handle_id=7 , end_dir=5, pos={2200,1090}, speed=300, dur=2},	
	    	{ event ='move', delay=0.5, handle_id=8 , end_dir=5, pos={2200,1090}, speed=300, dur=2},
	    	{ event ='move', delay=1, handle_id=9 , end_dir=5, pos={2200,1090}, speed=300, dur=2},	
	    	{ event ='move', delay=1, handle_id=10 , end_dir=5, pos={2200,670}, speed=300, dur=2},	
	    	{ event ='move', delay=1.5, handle_id=11 , end_dir=5, pos={2200,670}, speed=300, dur=2},
	    	{ event ='move', delay=1.5, handle_id=12 , end_dir=5, pos={2200,670}, speed=300, dur=2},
		},

	},

	--============================================	sunluyao	剧情副本5-1    end  =========================================

	--============================================	sunluyao	剧情副本5-2    start  =========================================
['juqing521'] =
	{
		{
	    	{ event='createActor', delay=0.1, handle_id = 1, body=12, pos={360,440}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	    	{ event='createActor', delay=0.1, handle_id = 2, body=5, pos={400,520}, dir=7, speed=340, name_color=0xffffff, name="阴戟", },
	    	{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={550,500}, dir=7, speed=340, name_color=0xffffff, name="姚期", },
	    	{ event='createActor', delay=0.1, handle_id = 4, body=34, pos={480,450}, dir=7, speed=340, name_color=0xffffff, name="冯异", },
	    	{ event='createActor', delay=0.1, handle_id = 5, body=47, pos={490,560}, dir=7, speed=340, name_color=0xffffff, name="祭遵", },

	    	{ event='createActor', delay=0.1, handle_id = 11, body=38, pos={260,410}, dir=3, speed=340, name_color=0xffffff, name="刘接", },
	   		{ event='createActor', delay=0.1, handle_id = 12, body=27, pos={160,410}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },
	   		{ event='createActor', delay=0.1, handle_id = 13, body=27, pos={260,360}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },
	   		{ event='createActor', delay=0.1, handle_id = 14, body=28, pos={100,360}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },
	   		{ event='createActor', delay=0.1, handle_id = 15, body=28, pos={180,310}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },

	   		{ event='init_cimera', delay = 0.1,mx= 479,my = 286 }, 
		},

		{
	   		{ event='talk', delay=1.1, handle_id=1, talk='刘接，你身为宗室之子，竟然黑白不分，公然攻击陛下派来的使节？', dur=3 },	
	   		{ event='talk', delay=4.5, handle_id=11, talk='哼！更始刘玄不过是旁支外系，那里有刘子舆陛下正统！', dur=2.5},
	   		{ event='talk', delay=7.5, handle_id=11, talk='抓住他！哪个取刘秀人头，赏赐万金啊！', dur=2},
	   		{ event='playAction', delay = 7.2, handle_id = 11, action_id = 2, dur=0.2, dir=3, loop=false ,},	

	   		{ event='talk', delay=10, handle_id=4, talk='[a]撤！', emote={a=28}, dur=1.2},

		},

		{
	    	{ event='createActor', delay=0.1, handle_id = 21, body=19, pos={310,610}, dir=1, speed=340, name_color=0xffffff, name="百姓", },
	   		{ event='createActor', delay=0.1, handle_id = 22, body=19, pos={780,1150}, dir=1, speed=340, name_color=0xffffff, name="百姓", },
	   		{ event='createActor', delay=0.1, handle_id = 23, body=19, pos={1100,730}, dir=5, speed=340, name_color=0xffffff, name="百姓", },
	   		{ event='createActor', delay=0.1, handle_id = 24, body=41, pos={1420,640}, dir=6, speed=340, name_color=0xffffff, name="农妇", },
	   		{ event='createActor', delay=0.1, handle_id = 25, body=41, pos={1220,1190}, dir=7, speed=340, name_color=0xffffff, name="农妇", },
	   		{ event='createActor', delay=0.1, handle_id = 26, body=41, pos={1424,842}, dir=5, speed=340, name_color=0xffffff, name="农妇", },

	    	{ event ='camera', delay = 2.2, c_topox = {1060,960}, sdur=3, dur = 3,backtime=1},		
	   		{ event='move', delay=0.1, handle_id=1, end_dir=3, pos={1300,1000}, speed=340, dur=2 },
	   		{ event='move', delay=0.6, handle_id=2, end_dir=3, pos={1200,1000}, speed=340, dur=2 },
	   		{ event='move', delay=0.6, handle_id=4, end_dir=3, pos={1240,940}, speed=340, dur=2 },
	   		{ event='move', delay=1.5, handle_id=3, end_dir=3, pos={1150,930}, speed=340, dur=2 },
	   		{ event='move', delay=1.5, handle_id=5, end_dir=3, pos={1130,990}, speed=340, dur=2 },

	    	{ event ='camera', delay = 4, c_topox = {479,286}, sdur=0.1, dur = 0.1,backtime=1},	

	   		{ event='move', delay=3.8, handle_id=11, end_dir=3, pos={950,862}, speed=240, dur=2 },
	   		{ event='move', delay=3.8, handle_id=12, end_dir=3, pos={830,820}, speed=240, dur=2 },
	   		{ event='move', delay=3.8, handle_id=13, end_dir=3, pos={920,760}, speed=240, dur=2 },
	   		{ event='move', delay=3.8, handle_id=14, end_dir=3, pos={790,780}, speed=240, dur=2 },
	   		{ event='move', delay=3.8, handle_id=15, end_dir=3, pos={860,720}, speed=240, dur=2 },

	   		{ event='talk', delay=3.5, handle_id=12, talk='抓刘秀，赏万金，抓刘秀啊！大家一起上啊！', dur=3 },

	    	{ event ='camera', delay = 5, c_topox = {1060,860}, sdur=2, dur = 2,backtime=1},

	   		{ event='move', delay=5.2, handle_id=25, end_dir=1, pos={1184,1100}, speed=340, dur=1 },
	   		{ event='move', delay=5.2, handle_id=24, end_dir=7, pos={1321,1094}, speed=340, dur=1 },
	   		{ event='move', delay=5.2, handle_id=23, end_dir=6, pos={1470,979}, speed=240, dur=1 },
	   		{ event='move', delay=5.2, handle_id=26, end_dir=6, pos={1405,1048}, speed=340, dur=1 },
	   		{ event='move', delay=5.2, handle_id=22, end_dir=1, pos={996,1036}, speed=340, dur=1 },	   		
		},
		{
	   		{ event='talk', delay=0.1, handle_id=23, talk='抓刘秀！', dur=1.8 },
	   		{ event='talk', delay=0.1, handle_id=24, talk='抓刘秀！', dur=1.8 },
	   		{ event='talk', delay=0.1, handle_id=25, talk='赏万金！', dur=1.8 },
	   		{ event='talk', delay=0.1, handle_id=26, talk='赏万金！', dur=1.8 },

	   		{ event='move', delay=2, handle_id=2, end_dir=7, pos={1200,1000}, speed=340, dur=2 },
	   		{ event='move', delay=2.5, handle_id=2, end_dir=3, pos={1200,1000}, speed=340, dur=2 },

	   		{ event='talk', delay=2.5, handle_id=2, talk='怎么这么多人？', dur=1.8 },

	   		{ event='move', delay=4.8, handle_id=11, end_dir=3, pos={950+40,862+40}, speed=240, dur=2 },
	   		{ event='move', delay=4.8, handle_id=12, end_dir=3, pos={830+40,820+40}, speed=240, dur=2 },
	   		{ event='move', delay=4.8, handle_id=13, end_dir=3, pos={920+30,760+30}, speed=240, dur=2 },
	   		{ event='move', delay=4.8, handle_id=14, end_dir=3, pos={790+30,780+30}, speed=240, dur=2 },
	   		{ event='move', delay=4.8, handle_id=15, end_dir=3, pos={860+30,720+30}, speed=240, dur=2 },


	   		{ event='talk', delay=5, handle_id=3, talk='万两黄金，十万户侯，这些人连自己爹娘都能卖了！大伙杀出去！', dur=3 },

		},
		{
	    	{ event='createActor', delay=0.1, handle_id = 6, body=8, pos={1562,1255}, dir=7, speed=340, name_color=0xffffff, name="王霸", },
	   		--{ event='move', delay=0.3, handle_id=6, end_dir=7, pos={1390,1030}, speed=40, dur=2 },
			{ event='jump', delay=0.2, handle_id=6, end_dir=7, pos={1390,1030}, speed=320, dur=1 },

	   		{ event='playAction', delay = 1, handle_id = 23, action_id = 4, dur=0, dir=1, loop=false ,once=true},
	   		{ event='playAction', delay = 1, handle_id = 24, action_id = 4, dur=0, dir=3, loop=false ,once=true},
	   		{ event='playAction', delay = 1, handle_id = 25, action_id = 4, dur=0, dir=6, loop=false ,once=true},
	   		{ event='playAction', delay = 1, handle_id = 26, action_id = 4, dur=0, dir=7, loop=false ,once=true},	    	
		},
		{
	   		{ event='talk', delay=0.1, handle_id=6, talk='大司马，大司马……不好了。', dur=1.8 },
	   		{ event='talk', delay=2, handle_id=6, talk='蓟县三门已闭，唯有南门开启，据闻是迎接邯郸使者！', dur=2.2 },
	   		{ event='talk', delay=4.8, handle_id=1, talk='现今只能从南门闯出去，去南门！', dur=2 },

	   		{ event='talk', delay=7, handle_id=2, talk='遵命！', dur=1.8 },
	   		{ event='talk', delay=7, handle_id=3, talk='遵命！', dur=1.8 },
	   		{ event='talk', delay=7, handle_id=4, talk='遵命！', dur=1.8 },
	   		{ event='talk', delay=7, handle_id=5, talk='遵命！', dur=1.8 },
	   		{ event='talk', delay=7, handle_id=6, talk='遵命！', dur=1.8 },   		
		},
		{
	   		{ event='move', delay=0.3, handle_id=1, end_dir=3, pos={1562,1255}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.3, handle_id=2, end_dir=3, pos={1562-100,1255}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.3, handle_id=3, end_dir=3, pos={1562-40,1255-60}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.3, handle_id=4, end_dir=3, pos={1562-150,1255-70}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.3, handle_id=5, end_dir=3, pos={1562-170,1255-10}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.6, handle_id=6, end_dir=3, pos={1562,1255}, speed=340, dur=1.5 },
		},

	},
	['juqing522'] =
	{
		{
	    	{ event='createActor', delay=0.1, handle_id = 1, body=12, pos={1300,1000}, dir=3, speed=340, name_color=0xffffff, name="刘秀", },
	    	{ event='createActor', delay=0.1, handle_id = 2, body=5, pos={1200,1000}, dir=3, speed=340, name_color=0xffffff, name="阴戟", },
	    	{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={1240-50,940-50}, dir=3, speed=340, name_color=0xffffff, name="姚期", },
	    	{ event='createActor', delay=0.1, handle_id = 4, body=34, pos={1150-50,930-50}, dir=3, speed=340, name_color=0xffffff, name="冯异", },
	    	{ event='createActor', delay=0.1, handle_id = 5, body=47, pos={1130-50,990}, dir=3, speed=340, name_color=0xffffff, name="祭遵", },
	    	{ event='createActor', delay=0.1, handle_id = 6, body=8, pos={1390,970}, dir=3, speed=340, name_color=0xffffff, name="王霸", },	   	


	   		{ event='createActor', delay=0.1, handle_id = 22, body=19, pos={1184,1200}, dir=1, speed=340, name_color=0xffffff, name="百姓", },
	   		{ event='createActor', delay=0.1, handle_id = 23, body=19, pos={1370,1184}, dir=7, speed=340, name_color=0xffffff, name="百姓", },
	   		{ event='createActor', delay=0.1, handle_id = 24, body=41, pos={1550,1029}, dir=6, speed=340, name_color=0xffffff, name="农妇", },
	   		{ event='createActor', delay=0.1, handle_id = 25, body=41, pos={1485,1098}, dir=7, speed=340, name_color=0xffffff, name="农妇", },
	   		{ event='createActor', delay=0.1, handle_id = 26, body=41, pos={996,1036}, dir=1, speed=340, name_color=0xffffff, name="农妇", },	    	

		},
		{
	   		{ event='init_cimera', delay = 0.1,mx= 1160,my = 960 }, 
		},
		{
	   		{ event='playAction', delay = 1, handle_id = 6, action_id = 2, dur=0.3, dir=3, loop=false ,},

	   		{ event='talk', delay=1.5, handle_id=6, talk='闪开！不想死的就统统给我让路！', dur=2.2 },
	   		{ event='talk', delay=4.1, handle_id=25, talk='那个是刘秀，抓刘秀！', dur=1.8 },

	   		{ event='move', delay=6.5, handle_id=25, end_dir=7, pos={1485-50,1098-50}, speed=340, dur=0.5 },
		},
		{
	   		{ event='move', delay=0.1, handle_id=2, end_dir=3, pos={1340,1041}, speed=140, dur=0.5 },

	   		{ event='talk', delay=0.5, handle_id=2, talk='挡我者死，随我杀！', dur=1.8 },
		},
		{
	   		{ event='move', delay=0.1, handle_id=1, end_dir=3, pos={1562,1255}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.1, handle_id=2, end_dir=3, pos={1562-100,1255}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.1, handle_id=3, end_dir=3, pos={1562-40,1255-60}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.1, handle_id=4, end_dir=3, pos={1562-150,1255-70}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.1, handle_id=5, end_dir=3, pos={1562-170,1255-10}, speed=340, dur=1.5 },
	   		{ event='move', delay=0.1, handle_id=6, end_dir=3, pos={1562,1255}, speed=340, dur=1.5 },

	   		{ event='move', delay=0.1, handle_id=26, end_dir=3, pos={996,1036}, speed=340, dur=0.5 },

	   		{ event='talk', delay=0.5, handle_id=23, talk='啊——！', dur=1.8 },
	   		{ event='talk', delay=0.5, handle_id=24, talk='啊——！', dur=1.8 },
	   		{ event='talk', delay=0.5, handle_id=25, talk='啊——！', dur=1.8 },
	   		{ event='talk', delay=0.5, handle_id=22, talk='啊——！', dur=1.8 },

	   		{ event='playAction', delay = 1, handle_id = 23, action_id = 4, dur=0, dir=1, loop=false ,once=true},
	   		{ event='playAction', delay = 1, handle_id = 24, action_id = 4, dur=0, dir=3, loop=false ,once=true},
	   		{ event='playAction', delay = 1, handle_id = 25, action_id = 4, dur=0, dir=6, loop=false ,once=true},
	   		{ event='playAction', delay = 1, handle_id = 22, action_id = 4, dur=0, dir=7, loop=false ,once=true},
		},
		{
	    	{ event ='camera', delay = 0.1, c_topox = {860,760}, sdur=0.1, dur = 0.1,backtime=1},

	    	{ event='createActor', delay=0.1, handle_id = 11, body=38, pos={950-50,862-50}, dir=3, speed=340, name_color=0xffffff, name="刘接", },
	   		{ event='createActor', delay=0.1, handle_id = 12, body=27, pos={830-50,820-50}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },
	   		{ event='createActor', delay=0.1, handle_id = 13, body=27, pos={920-50,760-50}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },
	   		{ event='createActor', delay=0.1, handle_id = 14, body=28, pos={790-50,780-50}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },
	   		{ event='createActor', delay=0.1, handle_id = 15, body=28, pos={860-50,720-50}, dir=3, speed=340, name_color=0xffffff, name="蓟县士卒", },

	   		{ event='move', delay=0.2, handle_id=11, end_dir=3, pos={950,862}, speed=340, dur=0.5 },
	   		{ event='move', delay=0.2, handle_id=12, end_dir=3, pos={830,820}, speed=340, dur=0.5 },
	   		{ event='move', delay=0.2, handle_id=13, end_dir=3, pos={920,760}, speed=340, dur=0.5 },
	   		{ event='move', delay=0.2, handle_id=14, end_dir=3, pos={790,780}, speed=340, dur=0.5 },
	   		{ event='move', delay=0.2, handle_id=15, end_dir=3, pos={860,720}, speed=340, dur=0.5 },


	   		{ event='talk', delay=1.5, handle_id=11, talk='怎么回事，谁开的城门，堵住他们……', dur=2.2 },

		},		

	},


	--============================================	sunluyao	剧情副本5-2    end  =========================================


	--============================================wuwenbin  剧情副本第五章第三节 start  =====================================----

	['juqing531'] = {

		--角色前置对白
	    {
	   		{ event='init_cimera', delay = 0.1,mx= 1772,my = 650 }, 	 
	    },

	   	--发现追兵
	    {
	    	{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={1708,520}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 6, body=27, pos={1740,584}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={1772,648}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={1804,712}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		--{ event='createActor', delay=0.1, handle_id = 9, body=49, pos={1836,778}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },

	   		{ event='createActor', delay=0.1, handle_id = 10, body=27, pos={1804,520}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 11, body=27, pos={1836,584}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 12, body=27, pos={1868,648}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 13, body=27, pos={1900,712}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		--{ event='createActor', delay=0.1, handle_id = 14, body=49, pos={1932,784}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },

	   		{ event='createActor', delay=0.1, handle_id = 15, body=27, pos={1944,520}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 16, body=27, pos={1976,584}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 17, body=27, pos={2008,648}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 18, body=27, pos={2040,712}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		--{ event='createActor', delay=0.1, handle_id = 19, body=49, pos={2072,784}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },

	   		{ event ='camera', delay = 0.2, target_id= 6, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},
	   		{ event='move', delay=0.5, handle_id=5, end_dir=5, pos={1356,520}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=6, end_dir=5, pos={1388,584}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=7, end_dir=5, pos={1420,648}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=8, end_dir=5, pos={1452,712}, speed=340, dur=1 },
	   		--{ event='move', delay=0.5, handle_id=9, end_dir=5, pos={1484,786}, speed=340, dur=1 },

	   		{ event='move', delay=0.5, handle_id=10, end_dir=5, pos={1458,520}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=11, end_dir=5, pos={1490,584}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=12, end_dir=5, pos={1522,648}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=13, end_dir=5, pos={1554,712}, speed=340, dur=1 },
	   		--{ event='move', delay=0.5, handle_id=14, end_dir=5, pos={1586,788}, speed=340, dur=1 },

	   		{ event='move', delay=0.5, handle_id=15, end_dir=5, pos={1598,520}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=16, end_dir=5, pos={1630,584}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=17, end_dir=5, pos={1662,648}, speed=340, dur=1 },
	   		{ event='move', delay=0.5, handle_id=18, end_dir=5, pos={1694,712}, speed=340, dur=1 },
	   		--{ event='move', delay=0.5, handle_id=19, end_dir=5, pos={1726,788}, speed=340, dur=1 },

	   		{ event='talk', delay=0.5, handle_id=6, talk='莫跑了刘秀！', dur=1.5 },
	   		{ event='talk', delay=0.5, handle_id=7, talk='莫跑了刘秀！', dur=1.5 },
	   		{ event='talk', delay=0.5, handle_id=11, talk='莫跑了刘秀！', dur=1.5,},
	   		{ event='talk', delay=0.5, handle_id=12, talk='莫跑了刘秀！', dur=1.5 },
	   		{ event='talk', delay=0.5, handle_id=16, talk='莫跑了刘秀！', dur=1.5 },
	   		{ event='talk', delay=0.5, handle_id=17, talk='莫跑了刘秀！', dur=1.5 },


	   		{ event='createActor', delay=0.8, handle_id = 1, body=5, pos={142+96,591+96}, dir=7, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.8, handle_id = 2, body=12, pos={178+96,531+96}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	    	{ event='createActor', delay=0.8, handle_id = 3, body=34, pos={211+96,463+96}, dir=7, speed=340, name_color=0xffffff, name="冯异", },
	   		{ event='createActor', delay=0.8, handle_id = 4, body=8, pos={240+96,404+96}, dir=7, speed=340, name_color=0xffffff, name="王霸", },
	   		{ event ='camera', delay = 1.8, target_id = 3, sdur=0.1, dur = 1,style = 'follow',backtime=1},

	   		{ event='move', delay= 2, handle_id= 1, end_dir= 7, pos={142,591},speed=360, dur=1 },
	    	{ event='move', delay= 2, handle_id= 2, end_dir= 7, pos={178,531}, speed=360, dur=1 },
	   		{ event='move', delay= 2, handle_id= 3, end_dir= 7, pos={211,463}, speed=360, dur=1 },
	   		{ event='move', delay= 2, handle_id= 4, end_dir= 7, pos={240,404}, speed= 360, dur=1 },

	   		{ event='move', delay= 3, handle_id=3, end_dir= 2, pos={211,463}, speed=280, dur=0.1 },
	   		{ event='talk', delay= 3, handle_id=3, talk='追兵来了。', dur=1 },

	   		{ event='move', delay= 3.5, handle_id= 1, end_dir= 2, pos={142,591},speed=280, dur=0.1 },
	    	{ event='move', delay= 3.5, handle_id= 2, end_dir= 2, pos={178,531}, speed=280, dur=0.1 },
	   		{ event='move', delay= 3.5, handle_id= 4, end_dir= 2, pos={240,404}, speed=280, dur=0.1 },
	   	},

	   	--阴丽华回头破冰
	 	{
	 		{ event='talk', delay= 0.1, handle_id= 1, talk='[a]你们先走！', dur=1.5 , emote = {a = 39}},
	   		{ event='move', delay= 0.3, handle_id= 1, end_dir= 1, pos={666,724}, speed= 200, dur=1 },

	--    		--{ event ='camera', delay = 1, target_id = 4, sdur=3.5, dur = 0.5,style = 'follow',backtime=1},
	   		{ event ='camera', delay = 1.5, c_topox = {1006,572}, sdur=2, dur = 1,backtime=1},

	   		{ event='move', delay= 1.5, handle_id=5, end_dir=5, pos={883,600}, speed=340, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=6, end_dir=5, pos={914,668}, speed=340, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=7, end_dir=5, pos={648,728}, speed=340, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=8, end_dir=5, pos={679,792}, speed=340, dur=1 },
	   		--{ event='move', delay= 2, handle_id=9, end_dir=5, pos={679,815}, speed=340, dur=1 },

	   		{ event='move', delay=1.5, handle_id=10, end_dir=5, pos={979,600}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=11, end_dir=5, pos={1009,668}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=12, end_dir=5, pos={1034,728}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=13, end_dir=5, pos={1079,792}, speed=340, dur=1 },
	   		--{ event='move', delay=2, handle_id=14, end_dir=5, pos={1110,815}, speed=340, dur=1 },

	   		{ event='move', delay=1.5, handle_id=15, end_dir=5, pos={1209,600}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=16, end_dir=5, pos={1241,668}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=17, end_dir=5, pos={1273,728}, speed=340, dur=1 },
	   		{ event='move', delay=1.5, handle_id=18, end_dir=5, pos={1305,792}, speed=340, dur=1 },
	   		--{ event='move', delay=2, handle_id=14, end_dir=5, pos={1110,815}, speed=340, dur=1 },

	   		-- { event ='camera', delay = 0, target_id = 5, sdur=3.5, dur = 1,style = 'follow',backtime=1},
	   		{ event='talk', delay= 0.5, handle_id = 2, talk='丽华！别过去！', dur=1.5 },
	   		{ event='move', delay= 0.5, handle_id=2, end_dir = 3, pos={212,531}, speed=340, dur=1 },  --原位置差+70，+0
	   		{ event='move', delay= 0.5, handle_id= 3, end_dir =7, pos={278,563}, speed=280, dur=1 },  --原位置差+100，+100
	   		{ event='move', delay= 0.5, handle_id= 4, end_dir =7, pos={310,504}, speed=280, dur=1 },  --原位置差+70，+100
	   		{ event='talk', delay= 0.5, handle_id = 3, talk='别过去。', dur = 2 },

	   		
	   		{ event='playAction', delay = 3, handle_id = 1, action_id = 2, dur=0, dir=1, loop=false ,once=false},

	   		{ event='createTexture', handle_id=20, delay= 4, pos={ 952,702 }, path = "nopack/juqing/bxhl.png",},
	   		{ event='shake', delay= 3.5, dur=1, c_topox={952,702}, index=60, rate=4, radius=40 },
	   		-- { event = 'effect', delay = 1, layer = 2, effect_id = 10011,c_topox = {3088,1138}, dx= 0,dy = 30,loop = true},  --兵掉入水中

	   		{ event='kill', delay=4, handle_id=5}, 
	   		{ event='kill', delay=4, handle_id=6}, 
	   		{ event='kill', delay=4, handle_id=7}, 
	   		{ event='kill', delay=4, handle_id=8},
	   		--{ event='kill', delay=4, handle_id=9}, 
	   		{ event='kill', delay=4, handle_id=10},  
	   		{ event='kill', delay=4, handle_id=11}, 
	   		{ event='kill', delay=4, handle_id=12}, 
	   		{ event='kill', delay=4, handle_id=13},

	   		{ event='talk', delay= 4.3, handle_id = 16, talk='快停下！！', dur = 2 },
	   		{ event='talk', delay= 4.3, handle_id = 18, talk='小心！！', dur = 2 },
	   	},

	   	-- 士兵掉水中，剩余的围攻阴丽华
	   	{

	   		--{ event = 'effect', delay = 1, layer = 2, effect_id = 10011,c_topox = {3088,1138}, dx= 0,dy = 30,loop = true},  --兵掉入水中
	   		--{ event='jump', delay=0.2, handle_id=1, dir=6, pos={2456,3424}, speed=120, dur=1 },
	   		{ event ='camera', delay = 0.5, c_topox = {1234,634}, sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event='jump', delay=0.1, handle_id= 1, dir=1, pos={965,704}, speed=120, dur=1, end_dir=1 },  
	   		{ event='jump', delay=0.5, handle_id= 1, dir=1, pos={1234,684}, speed=120, dur=1, end_dir=1 },

	   		{ event='move', delay= 0.5, handle_id=15, end_dir=3, pos={1175,570}, speed=180, dur=1 },
	   		{ event='move', delay= 0.5, handle_id=16, end_dir=5, pos={1291,594}, speed=180, dur=1 },
	   		{ event='move', delay= 0.5, handle_id=17, end_dir=7, pos={1307,767}, speed=180, dur=1 },
	   		{ event='move', delay= 0.5, handle_id=18, end_dir=5, pos={1355,638}, speed=180, dur=1 },

	   		

	   		{ event='talk', delay= 2.1, handle_id = 17, talk='还敢过来！！', dur = 2 },
	   		{ event='talk', delay= 1.8, handle_id = 18, talk='抓住他！！', dur = 2 },

	   		{ event='talk', delay= 1.5, handle_id = 1, talk='你们冲我来！！', dur = 2 },
	   		{ event='playAction', delay = 1.5, handle_id = 1, action_id = 2, dur=0, dir=1, loop=false ,once=false},

	   		
	   		-- { event='kill', delay=4, handle_id=13},
	   	-- 	{ event='playAction', delay = 3, handle_id = 5, action_id = 2, dur=0, dir=5, loop=true ,once=false},
	   	-- 	{ event='playAction', delay = 3, handle_id = 9, action_id = 2, dur=0, dir=7, loop=true ,once=false},
	   	-- 	{ event='playAction', delay = 3, handle_id = 10, action_id = 2, dur=0, dir=5, loop=true ,once=false},
	   	-- 	{ event='playAction', delay = 3, handle_id = 14, action_id = 2, dur=0, dir=7, loop=true ,once=false},
	   	-- 	--{ event='playAction', delay = 3, handle_id = 1, action_id = 2, dur=0, dir=1, loop=true ,once=false},

	   	-- 	-- { event='talk', delay=0.2, handle_id=9, talk='上！', dur=1.5 },
	   	-- 	-- { event='talk', delay=0.2, handle_id=10, talk='抓住她！', dur=1.5 },
	   	},

	 },

	['juqing532'] = 
	{
		-- --角色前置对白
	 --    {
	 --   		{ event='init_cimera', delay = 0.1,mx= 83,my = 100 }, 	 
	 --    },

		--阴丽华被士兵围困
		{
			{ event='init_cimera', delay = 0.2,mx= 1120,my = 600 },
			-- { event ='camera', delay = 0.3, target_id= 1, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=27, pos={1266+64,552}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 4, body=27, pos={1329+64,589}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={1393+64,626}, dir=5, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 6, body=27, pos={1391+64,683}, dir=7, speed=340, name_color=0xffffff, name="邯郸追兵", },
	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={1324+64,727}, dir=7, speed=340, name_color=0xffffff, name="邯郸追兵", },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1115+64,660}, dir=1, speed=340, name_color=0xffffff, name="阴戟", },

	   		


	   		{ event='talk', delay=0.5, handle_id=5, talk='看你往哪里逃！', dur=1.5 },

			{ event='move', delay= 0.5, handle_id=3, end_dir=5, pos={1266+32,552}, speed=340, dur=0.1 },
	   		{ event='move', delay= 0.5, handle_id=4, end_dir=5, pos={1329+32,589}, speed=340, dur=0.1 },
	   		{ event='move', delay= 0.5, handle_id=5, end_dir=5, pos={1393+32,626}, speed=340, dur=0.1 },
	   		{ event='move', delay= 0.5, handle_id=6, end_dir=7, pos={1391+32,683}, speed=340, dur=0.1 },
	   		{ event='move', delay= 0.5, handle_id=7, end_dir=7, pos={1324+32,727}, speed=340, dur=0.1 },

	   		{ event='move', delay= 0.5, handle_id=1, end_dir=1, pos={1115+32,660}, speed=500, dur=0.1 },
	   		{ event='talk', delay= 0.5, handle_id=1, talk='呼呼…', dur=1.5 },

	   		{ event='move', delay= 3, handle_id=3, end_dir=5, pos={1266-64,552-32}, speed=340, dur=1 },
	   		{ event='move', delay= 3, handle_id=4, end_dir=5, pos={1329-32,589-32}, speed=340, dur=1 },
	   		{ event='move', delay= 3, handle_id=5, end_dir=5, pos={1393,626}, speed=340, dur=1 },
	   		{ event='move', delay= 3, handle_id=6, end_dir=7, pos={1391-32,683+32}, speed=340, dur=1 },
	   		{ event='move', delay= 3, handle_id=7, end_dir=7, pos={1324-64,727+32}, speed=340, dur=1 },
	   		{ event='talk', delay= 3, handle_id=5, talk='抓住她！', dur=1.5 },

	   		{ event='move', delay= 3, handle_id=1, end_dir=1, pos={1115-32,660}, speed=500, dur=1 },
	   		{ event='talk', delay= 4, handle_id=1, talk='糟了…', dur=1.5 },


	   		--{ event='kill', delay=4, handle_id=13},
	    },

	    {
	   		-- { event='move', delay= 0.5, handle_id=1, dir = 1, end_dir=1, pos={2798,1198}, speed=340, dur=1 },
	   		-- { event = 'effect', handle_id=21, delay = 1, layer = 2, effect_id = 10011,c_topox = {3088,1138}, dx= 0,dy = 30,loop = true},  --箭特效
	   		-- { event ='camera', delay = 0.3, target_id= 1, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},
	   		-- { event = 'jump', delay= 0.3, handle_id= 1, dir=1, pos={965,704}, speed=120, dur=1, dir = 5, end_dir=5 },
	   		--{ event = 'playAction', handle_id= 1, delay = 1, action_id = 4, dur = 1, dir = 2,loop = false ,once = true},
	   		--{ event = 'jump', delay = 2, handle_id=1, pos={2745, 1280}, dir = 1,end_dir=1},

	   		{ event='createTexture', handle_id=101, delay= 0.8, pos={ 952,702 }, path = "nopack/juqing/bxhl.png",},
	   		{ event='shake', delay=0.1, dur=1, c_topox={1120,658}, index=60, rate=4, radius=40 }, --通过

	   		{ event = 'talk', delay = 0.3, handle_id=1, talk='啊——', dur=1 },
	   		{ event='talk', delay= 0.3, handle_id=3, talk='！！', dur=1.5 },
	   		{ event='talk', delay= 0.3, handle_id=4, talk='！！', dur=1.5 },
	   		{ event='talk', delay= 0.3, handle_id=5, talk='！！', dur=1.5 },
	   		{ event='talk', delay= 0.3, handle_id=6, talk='！！', dur=1.5 },
	   		{ event='talk', delay= 0.3, handle_id=7, talk='！！', dur=1.5 },
	   		{ event = 'playAction', handle_id= 1, delay = 0.8, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},
	   		-- { event = 'effect', delay = 1, layer = 2, effect_id = 10011,c_topox = {3088,1138}, dx= 0,dy = 30,loop = true},  --水花特效
	   		{ event='kill', delay = 1.3, handle_id=1}, 

		},

		{
			{ event ='camera', delay = 0.3, target_id= 2, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={297,509}, dir=2, speed=340, name_color=0xffffff, name="刘秀", },

	    	--{ event='kill', delay = 3, handle_id=13}, 

	    	{ event='move', delay= 0.8, handle_id=2, end_dir=2, pos={733,675}, speed=240, dur=3 },
	    	{ event='talk', delay=0.5, handle_id=2, talk='丽华————！！', dur=1.5 },
		},

	},

	--============================================wuwenbin  剧情副本第五章第三节 end  =====================================----

	--============================================wuwenbin  剧情副本第五章第四节 start    =====================================----
	['juqing541'] = {	

        --创建角色
        -- 演员表 1 尉迟峻 2 狱卒头领 3 信都守军1 4 信都守军2 101-104 亲随  105-106 狱卒 201-205 家眷
	    {

	   		{ event='createActor', delay=0.1, handle_id=1, body=22, pos={1684,1840}, dir=7, speed=340, name_color=0xffffff, name="尉迟峻", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=21, pos={2098,1554}, dir=5, speed=340, name_color=0xffffff, name="狱卒头领", },

	   		{ event='createActor', delay=0.1, handle_id=101, body=27, pos={1620,1880}, dir=1, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=27, pos={1690,1910}, dir=1, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=103, body=27, pos={1554,1942}, dir=1, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=27, pos={1622,1966}, dir=1, speed=340, name_color=0xffffff, name="亲随", },

	   		{ event='createActor', delay=0.1, handle_id=105, body=27, pos={2096,1462}, dir=5, speed=340, name_color=0xffffff, name="狱卒", },
	   		{ event='createActor', delay=0.1, handle_id=106, body=27, pos={2190,1520}, dir=5, speed=340, name_color=0xffffff, name="狱卒", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 2100,my = 1490 }, 	 
	    },

	    -- 尉迟峻和众亲随进入
	    {
	    	{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {2000,1610},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 101, dir = 1, pos = {1936,1650},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 102, dir = 1, pos = {2006,1680},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 103, dir = 1, pos = {1870,1712},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 104, dir = 1, pos = {1938,1736},speed = 260, dur = 1.5 ,end_dir = 1},
	    },

	    --尉迟峻与狱卒头领对话
	    {
	   		{ event = 'talk', delay= 0.1, handle_id = 1, talk='诸位兄弟辛苦了，我特意准备了好酒好菜，慰劳诸位。', dur=2.5},
	   		{ event = 'talk', delay= 2.5, handle_id = 2, talk='倒挺懂规矩。', dur=2 },
	   		{ event = 'talk', delay= 4.5, handle_id = 1, talk='我们几个来换班，你们回去歇着吧。', dur=2.5 },

	   		{ event = 'move', delay = 7,handle_id = 2, dir = 1, pos = {2098,1554},speed = 260, dur = 1.5 ,end_dir = 1},
	   		{ event = 'talk', delay= 7, handle_id = 2, talk='咱们去歇着，让这几个新来的兄弟盯着就行了。', dur=2.5 },

	   		{ event = 'move', delay = 9.5,handle_id = 2, dir = 1, pos = {282,1398},speed = 260, dur = 1.5 ,end_dir = 3},
	   		{ event = 'move', delay = 9.5,handle_id = 105, dir = 1, pos = {282,1398},speed = 260, dur = 1.5 ,end_dir = 3},
	   		{ event = 'move', delay = 9.5,handle_id = 106, dir = 1, pos = {282,1398},speed = 260, dur = 1.5 ,end_dir = 3},	

	   		{ event = 'move', delay = 10.8,handle_id = 1, dir = 1, pos = {2000,1610},speed = 260, dur = 1 ,end_dir = 6},
	    	{ event = 'move', delay = 10.8,handle_id = 101, dir = 1, pos = {1936,1650},speed = 260, dur = 1.5 ,end_dir = 6},
	    	{ event = 'move', delay = 10.8,handle_id = 102, dir = 1, pos = {2006,1680},speed = 260, dur = 1.5 ,end_dir = 6},
	    	{ event = 'move', delay = 10.8,handle_id = 103, dir = 1, pos = {1870,1712},speed = 260, dur = 1.5 ,end_dir = 6},
	    	{ event = 'move', delay = 10.8,handle_id = 104, dir = 1, pos = {1938,1736},speed = 260, dur = 1.5 ,end_dir = 6},

	    	{ event = 'kill', delay= 11.5, handle_id = 2,dur=0.1 ,},
	    	{ event = 'kill', delay= 11.5, handle_id = 105,dur=0.1 ,},
	    	{ event = 'kill', delay= 11.5, handle_id = 106,dur=0.1 ,},  
	   	},

	    --尉迟峻向亲随下达命令
	    {
	    	{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {2000,1610},speed = 260, dur = 1.5 ,end_dir = 5},
	    	{ event = 'move', delay = 0.1,handle_id = 101, dir = 1, pos = {1936,1650},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 102, dir = 1, pos = {2006,1680},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 103, dir = 1, pos = {1870,1712},speed = 260, dur = 1.5 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 104, dir = 1, pos = {1938,1736},speed = 260, dur = 1.5 ,end_dir = 1},  

	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='两个守在这里，剩下进去救人。', dur=2},

	    	{ event = 'talk', delay= 1.5, handle_id = 101, talk='喏！', dur=1.5},
	    	{ event = 'talk', delay= 1.5, handle_id = 102, talk='喏！', dur=1.5},
	    	{ event = 'talk', delay= 1.5, handle_id = 103, talk='喏！', dur=1.5},
	    	{ event = 'talk', delay= 1.5, handle_id = 104, talk='喏！', dur=1.5},
	    },

	    --尉迟峻进入救人
	    {
	    	{ event = 'move', delay = 0.1,handle_id = 1, dir = 1, pos = {2490,1196},speed = 260, dur = 0.1 ,end_dir = 5},

	    	{ event = 'move', delay = 0.1,handle_id = 101, dir = 1, pos = {2412,1238},speed = 260, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 102, dir = 1, pos = {2484,1270},speed = 260, dur = 0.1 ,end_dir = 1},

	    	{ event = 'move', delay = 0.1,handle_id = 103, dir = 1, pos = {2096,1462},speed = 260, dur = 0.1 ,end_dir = 5},
	    	{ event = 'move', delay = 0.1,handle_id = 104, dir = 1, pos = {2190,1520},speed = 260, dur = 0.1 ,end_dir = 5},

	    	{ event = 'kill', delay= 2, handle_id = 1,dur=2 ,},
	    	{ event = 'kill', delay= 2, handle_id = 101,dur=2 ,},
	    	{ event = 'kill', delay= 2, handle_id = 102,dur=2 ,},
	    },

	    --幼儿哭啼
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id='5_4_1' ,dialog_time = 2,},  -- 下部弹出窗口通过

	    	{ event = 'talk', delay= 0.1, handle_id = 103, talk='！！', dur=1.5},
	    	{ event = 'talk', delay= 0.1, handle_id = 104, talk='！！', dur=1.5},
	    	{ event = 'move', delay = 0.1,handle_id = 103, dir = 1, pos = {2096,1462},speed = 260, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 0.1,handle_id = 104, dir = 1, pos = {2190,1520},speed = 260, dur = 0.1 ,end_dir = 1},
	    },

	    --尉迟峻出来
	    {
	    	{ event='createActor', delay=0.1, handle_id=1, body=22, pos={2452,1224}, dir=5, speed=340, name_color=0xffffff, name="尉迟峻", },

	   		{ event='createActor', delay=0.1, handle_id=101, body=27, pos={2442,1172}, dir=5, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=27, pos={2512,1202}, dir=5, speed=340, name_color=0xffffff, name="亲随", },

	   		{ event='createActor', delay=0.1, handle_id=201, body=42, pos={2446,1094}, dir=5, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=202, body=38, pos={2476,1140}, dir=5, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=203, body=37, pos={2418,1146}, dir=5, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=204, body=41, pos={2534,1170}, dir=5, speed=340, name_color=0xffffff, name="家眷", },
	   		{ event='createActor', delay=0.1, handle_id=205, body=17, pos={2566,1194}, dir=5, speed=340, name_color=0xffffff, name="家眷", },

	   		{ event ='camera', delay = 0.5, c_topox={2578,1092} , sdur=0.1, dur = 0.5,style = '',backtime=1},


	   		{ event = 'talk', delay= 1.3, handle_id = 1, talk='不好！快走，快！', dur=1.5},

	   		{ event = 'move', delay = 1.8,handle_id = 1, dir = 1, pos = {1670,1704},speed = 200, dur = 0.1 ,end_dir = 1},

	    	{ event = 'move', delay = 2.0,handle_id = 101, dir = 1, pos = {1752,1682},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 102, dir = 1, pos = {1750,1750},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 103, dir = 1, pos = {1812,1684},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 104, dir = 1, pos = {1820,1754},speed = 200, dur = 0.1 ,end_dir = 1},

	    	{ event = 'move', delay = 2.0,handle_id = 201, dir = 1, pos = {1870,1642},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 202, dir = 1, pos = {1872,1714},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 203, dir = 1, pos = {1870,1768},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 204, dir = 1, pos = {1940,1614},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 2.0,handle_id = 205, dir = 1, pos = {1940,1678},speed = 200, dur = 0.1 ,end_dir = 1},
	   	},


	    --信都守军听见哭声
	    {

	    	{ event ='camera', delay = 1, c_topox={920,1052} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	   		{ event='createActor', delay=0.1, handle_id=3, body=28, pos={906,1106}, dir=3, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=28, pos={960,1076}, dir=3, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=301, body=27, pos={812,1068}, dir=3, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=302, body=27, pos={882,1042}, dir=3, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=303, body=27, pos={942,1006}, dir=3, speed=340, name_color=0xffffff, name="信都守军", },

	   		{ event = 'talk', delay= 1.5, handle_id = 3, talk='那边怎么会有孩子的哭声？过去看看！', dur=1.5},
	   	},

	   	--信都守军发现逃跑
	   	{	
	   		-- { event ='camera', delay = 1, target_id = 4 , sdur=0.1, dur = 0.5,style = 'follow',backtime=1},
	   		{ event = 'move', delay = 0.1,handle_id = 3, dir = 1, pos = {1016,1266},speed = 300, dur = 0.1 ,end_dir = 3},
	    	{ event = 'move', delay = 0.1,handle_id = 4, dir = 1, pos = {1076,1232},speed = 300, dur = 0.1 ,end_dir = 3},
	    	{ event = 'move', delay = 0.1,handle_id = 301, dir = 1, pos = {946,1224},speed = 300, dur = 0.1 ,end_dir = 3},
	    	{ event = 'move', delay = 0.1,handle_id = 302, dir = 1, pos = {1016,1196},speed = 300, dur = 0.1 ,end_dir = 3},
	    	{ event = 'move', delay = 0.1,handle_id = 303, dir = 1, pos = {1072,1168},speed = 300, dur = 0.1 ,end_dir = 3},

	    	{ event ='camera', delay = 1, c_topox={1350,1600} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	    	{ event = 'move', delay = 1,handle_id = 1, dir = 1, pos = {370,1750},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 101, dir = 1, pos = {370,1684},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 102, dir = 1, pos = {370,1806},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 103, dir = 1, pos = {370,1750},speed = 200, dur = 0.1 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 104, dir = 1, pos = {370,1684},speed = 200, dur = 0.1 ,end_dir = 1},

	    	{ event = 'move', delay = 1,handle_id = 201, dir = 1, pos = {370,1806},speed = 200, dur = 2 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 202, dir = 1, pos = {370,1750},speed = 200, dur = 2 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 203, dir = 1, pos = {370,1684},speed = 200, dur = 2 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 204, dir = 1, pos = {370,1806},speed = 200, dur = 2 ,end_dir = 1},
	    	{ event = 'move', delay = 1,handle_id = 205, dir = 1, pos = {370,1750},speed = 200, dur = 2 ,end_dir = 1},

	    	{ event = 'kill', delay= 4, handle_id = 1,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 101,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 102,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 103,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 104,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 201,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 202,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 203,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 204,dur=0.1 ,},
	    	{ event = 'kill', delay= 4, handle_id = 205,dur=0.1 ,},


	   		{ event ='camera', delay = 3.5, target_id = 4 , sdur=0.1, dur = 0.5,style = 'follow',backtime=1},

	   		{ event = 'talk', delay= 3.8, handle_id = 4, talk='糟糕！！！信都家眷跑了！给我追！', dur=2.5},

	   		{ event = 'move', delay = 4.2,handle_id = 3, dir = 1, pos = {370,1650},speed = 300, dur = 1 ,end_dir = 3},
	    	{ event = 'move', delay = 4.2,handle_id = 4, dir = 1, pos = {370,1584},speed = 300, dur = 1 ,end_dir = 3},
	    	{ event = 'move', delay = 4.8,handle_id = 301, dir = 1, pos = {370,1706},speed = 300, dur = 1 ,end_dir = 3},
	    	{ event = 'move', delay = 4.8,handle_id = 302, dir = 1, pos = {370,1650},speed = 300, dur = 1 ,end_dir = 3},
	    	{ event = 'move', delay = 4.8,handle_id = 303, dir = 1, pos = {370,1584},speed = 300, dur = 1 ,end_dir = 3},
	   	},
	},

	['juqing542'] = {	

        --创建角色
        -- 演员表 1 尉迟峻 2 马武 101-105 阴家隐士（死亡）106-109 阴家隐士	201-210 信都守军 301-312 汉军
	    {
	   		{ event='createActor', delay=0.1, handle_id=101, body=62, pos={488,1514}, dir=1, speed=340, name_color=0xffffff, name="阴家隐士", },
	   		{ event='createActor', delay=0.1, handle_id=102, body=62, pos={566,1488}, dir=3, speed=340, name_color=0xffffff, name="阴家隐士", },
	   		{ event='createActor', delay=0.1, handle_id=103, body=62, pos={530,1578}, dir=6, speed=340, name_color=0xffffff, name="阴家隐士", },
	   		{ event='createActor', delay=0.1, handle_id=104, body=62, pos={594,1548}, dir=5, speed=340, name_color=0xffffff, name="阴家隐士", },
	   		{ event='createActor', delay=0.1, handle_id=105, body=62, pos={658,1512}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士", },
	   	},

	   	--镜头初始化并跟随
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 420,my = 1534 }, 	 
	    },

	    --全屏特效箭雨，阴家隐士死亡
	    {

	    	{ event = 'talk', delay= 0.3, handle_id = 103, talk='啊——！', dur=2 ,},
	    	{ event = 'talk', delay= 0.3, handle_id = 102, talk='啊——！', dur=2 ,},
	    	{ event = 'talk', delay= 0.3, handle_id = 105, talk='啊——！', dur=2 ,},

	    	{ event = 'playAction', handle_id= 101, delay = 0.3, action_id = 4, dur = 0.1, dir = 3,loop = false,once = true},
	    	{ event = 'playAction', handle_id= 102, delay = 0.3, action_id = 4, dur = 0.1, dir = 2,loop = false,once = true},
	    	{ event = 'playAction', handle_id= 103, delay = 0.3, action_id = 4, dur = 0.1, dir = 6,loop = false,once = true},
	    	{ event = 'playAction', handle_id= 104, delay = 0.3, action_id = 4, dur = 0.1, dir = 1,loop = false,once = true},
	    	{ event = 'playAction', handle_id= 105, delay = 0.3, action_id = 4, dur = 0.1, dir = 7,loop = false,once = true},
	   	},

	   	--尉迟峻进入镜头
	   	{
	   		-- { event ='camera', delay = 0.2, target_id = 1 , sdur=0.1, dur = 0.3,style = 'follow',backtime=1},

	   		{ event='createActor', delay=0.1, handle_id=1, body=22, pos={1012+160,1648}, dir=1, speed=340, name_color=0xffffff, name="尉迟峻", },
	   		{ event='createActor', delay=0.1, handle_id=106, body=7, pos={948+192,1672}, dir=3, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=107, body=7, pos={1080+192,1618}, dir=6, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=108, body=20, pos={1010+192,1700}, dir=5, speed=340, name_color=0xffffff, name="亲随", },
	   		{ event='createActor', delay=0.1, handle_id=109, body=9, pos={1066+192,1674}, dir=7, speed=340, name_color=0xffffff, name="亲随", },

	   		{ event = 'move', delay = 0.5,handle_id = 1, dir = 1, pos = {656,1604},speed = 210, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 106, dir = 1, pos = {596,1644},speed = 260, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 107, dir = 1, pos = {728,1582},speed = 260, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 108, dir = 1, pos = {654,1678},speed = 260, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 109, dir = 1, pos = {724,1636},speed = 260, dur = 1 ,end_dir = 7},

	    	{ event = 'talk', delay= 0.8, handle_id = 1, talk='啊——！', dur=1.5 ,},
	    	{ event = 'talk', delay= 2.8, handle_id = 1, talk='弟兄们……都死了……', dur=2 ,},
	    },

	    --信都守军出现
	    {
	   		{ event='createActor', delay=0.1, handle_id=201, body=27, pos={462-64,1604}, dir=2, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=202, body=27, pos={460-64,1644}, dir=2, speed=340, name_color=0xffffff, name="信都守军", },

	   		{ event='createActor', delay=0.1, handle_id=203, body=27, pos={594+64,1776+64}, dir=6, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=204, body=27, pos={654+64,1772+64}, dir=5, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=205, body=27, pos={718+64,1738+64}, dir=7, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=206, body=27, pos={796+64,1708+64}, dir=1, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=207, body=27, pos={838+64,1680+64}, dir=3, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=208, body=27, pos={846+64,1616+64}, dir=6, speed=340, name_color=0xffffff, name="信都守军", },

	   		{ event='createActor', delay=0.1, handle_id=209, body=27, pos={854+64,1514-64}, dir=5, speed=340, name_color=0xffffff, name="信都守军", },
	   		{ event='createActor', delay=0.1, handle_id=210, body=27, pos={780+64,1492-64}, dir=7, speed=340, name_color=0xffffff, name="信都守军", },

	   		{ event = 'move', delay = 0.3,handle_id = 201, dir = 1, pos = {462,1604},speed = 300, dur = 1 ,end_dir = 2},
	    	{ event = 'move', delay = 0.3,handle_id = 202, dir = 1, pos = {462,1644},speed = 300, dur = 1 ,end_dir = 2},

	    	{ event = 'move', delay = 0.3,handle_id = 203, dir = 1, pos = {594,1776},speed = 300, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.3,handle_id = 204, dir = 1, pos = {654,1772},speed = 300, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.3,handle_id = 205, dir = 1, pos = {718,1738},speed = 300, dur = 1 ,end_dir = 7},
	   		{ event = 'move', delay = 0.3,handle_id = 206, dir = 1, pos = {796,1708},speed = 300, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.3,handle_id = 207, dir = 1, pos = {838,1680},speed = 300, dur = 1 ,end_dir = 7},
	    	{ event = 'move', delay = 0.3,handle_id = 208, dir = 1, pos = {846,1616},speed = 300, dur = 1 ,end_dir = 7},

	    	{ event = 'move', delay = 0.3,handle_id = 209, dir = 1, pos = {854,1514},speed = 300, dur = 1 ,end_dir = 5},
	    	{ event = 'move', delay = 0.3,handle_id = 210, dir = 1, pos = {780,1492},speed = 300, dur = 1 ,end_dir = 5},

	    	{ event = 'move', delay = 0.5,handle_id = 1, dir = 1, pos = {656,1604},speed = 300, dur = 1 ,end_dir = 3},
	    	{ event = 'move', delay = 0.5,handle_id = 106, dir = 1, pos = {596,1644},speed = 300, dur = 1 ,end_dir = 5},
	    	{ event = 'move', delay = 0.5,handle_id = 107, dir = 1, pos = {728,1582},speed = 300, dur = 1 ,end_dir = 1},
	    	{ event = 'move', delay = 0.5,handle_id = 108, dir = 1, pos = {654,1678},speed = 300, dur = 1 ,end_dir = 3},
	    	{ event = 'move', delay = 0.5,handle_id = 109, dir = 1, pos = {724,1636},speed = 300, dur = 1 ,end_dir = 3},

	    	{ event = 'talk', delay= 0.8, handle_id = 106, talk='[a]', dur=1.5 ,emote ={ a=41}},
	    	-- { event = 'talk', delay= 0.8, handle_id = 107, talk='[a]', dur=1.5 ,emote ={ a=41}},
	    	-- { event = 'talk', delay= 0.8, handle_id = 108, talk='[a]', dur=1.5 ,emote ={ a=41}},
	    	{ event = 'talk', delay= 0.8, handle_id = 109, talk='[a]', dur=1.5 ,emote ={ a=41}},
	   	},

	   	--马武前置对白
	   	{
	   		{ event='showTopTalk', delay=0.5, dialog_id='5_4_2' ,dialog_time = 2,},  -- 下部弹出窗口通过
	   	},

	   	--马武出现支援
	    {
	   		{ event='createActor', delay=0.1, handle_id=2, body=47, pos={1778-64,1764+64}, dir=1, speed=340, name_color=0xffffff, name="马武", },

	   		{ event='createActor', delay=0.1, handle_id=301, body=25, pos={1718-64,1880+64}, dir=3, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=302, body=25, pos={1782-64,1842+64}, dir=6, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=303, body=25, pos={1840-64,1810+64}, dir=5, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=304, body=25, pos={1902-64,1776+64}, dir=7, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=305, body=25, pos={1776-64,1906+64}, dir=3, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=306, body=25, pos={1842-64,1872+64}, dir=6, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=307, body=25, pos={1906-64,1834+64}, dir=5, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=308, body=25, pos={1960-64,1800+64}, dir=7, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=309, body=25, pos={1838-64,1936+64}, dir=3, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=310, body=25, pos={1906-64,1906+64}, dir=6, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=311, body=25, pos={1968-64,1876+64}, dir=5, speed=340, name_color=0xffffff, name="汉军", },
	   		{ event='createActor', delay=0.1, handle_id=312, body=25, pos={2026-64,1844+64}, dir=7, speed=340, name_color=0xffffff, name="汉军", },

	   		{ event ='camera', delay = 0.2, target_id = 2 , sdur=0.1, dur = 0.5,style = 'follow',backtime=1},

	   		{ event = 'move', delay = 0.3,handle_id = 2, dir = 1, pos = {1224,1590},speed = 360, dur = 1 ,end_dir = 5},

	   		{ event = 'move', delay = 0.3,handle_id = 301, dir = 1, pos = {1166,1682},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 302, dir = 1, pos = {1230,1646},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 303, dir = 1, pos = {1298,1614},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 304, dir = 1, pos = {1360,1584},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 305, dir = 1, pos = {1224,1706},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 306, dir = 1, pos = {1298,1684},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 307, dir = 1, pos = {1356,1644},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 308, dir = 1, pos = {1426,1614},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 309, dir = 1, pos = {1302,1748},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 310, dir = 1, pos = {1360,1712},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 311, dir = 1, pos = {1414,1682},speed = 360, dur = 1.8 ,end_dir = 5},
	   		{ event = 'move', delay = 0.3,handle_id = 312, dir = 1, pos = {1492,1648},speed = 360, dur = 1.8 ,end_dir = 5},
	   	},

	},

	--============================================wuwenbin  剧情副本第五章第四节 end    =====================================----


	--============================================lixin  剧情副本第五章第五节 start    =====================================----
	--演员表  1-王郎  2-刘林  3-邯郸守军
	['juqing551'] = {
	    --创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=38, pos={1810,1200}, dir=3, speed=340, name_color=0xffffff, name="王郎", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=48, pos={1713,1329}, dir=3, speed=340, name_color=0xffffff, name="刘林", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=27, pos={2324,1583}, dir=7, speed=340, name_color=0xffffff, name="邯郸守军", },
	   	},

	   	--镜头初始化
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1759,my = 1200 }, 	 
	    },

	    --守军报不好了
	    {
	    	{ event = 'move', delay = 0.5,handle_id = 3, dir = 1, pos = {1860,1315},speed = 280, dur = 2 ,end_dir = 7},
	    	{ event = 'talk', delay= 0.5, handle_id = 3, talk='主公，不好了！', dur=2},
	    	{ event = 'talk', delay= 3, handle_id = 3, talk='我城的守将已经投降刘秀军，大开城门，接引汉军入城了！', dur=2.5},

	    	{ event = 'move', delay = 5.8,handle_id = 1, dir = 1, pos = {1810+20,1200+20},speed = 150, dur = 2 ,end_dir = 3},
	    	{ event = 'talk', delay= 5.8, handle_id = 1, talk='[a]什么？！那，现在城里情况如何？', dur=1.5,emote={a=41}},
	    },
	    --逃跑吧
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 3, talk='我军将士人心涣散，纷纷投降……', dur=2},

	    	{ event = 'move', delay = 2.4,handle_id = 2, dir = 1, pos = {1713,1329},speed = 280, dur = 2 ,end_dir = 1},
	    	{ event = 'talk', delay= 2.4, handle_id = 2, talk='唉呀，别说了，咱们先逃出邯郸再说吧！', dur=2},

	    	{ event = 'move', delay = 4,handle_id = 1, dir = 1, pos = {2093,877},speed = 300, dur = 2,end_dir = 5},
	    	{ event = 'move', delay = 4,handle_id = 2, dir = 1, pos = {2161,949},speed = 300, dur = 2,end_dir = 5},
	    	{ event = 'move', delay = 4,handle_id = 3, dir = 1, pos = {2223,979},speed = 300, dur = 2,end_dir = 5},
	    },

	},

	--演员表  1-王郎  2-刘林  3-6 邯郸守军   7-王霸   8-耿弇   9~12-汉军将士  101-冒汗特效  102-生气特效
	['juqing552'] = {
	    --创建角色
	    {
			{ event='createActor', delay=0.1, handle_id=1, body=38, pos={3409,721}, dir=7, speed=340, name_color=0xffffff, name="王郎", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=48, pos={3503,658}, dir=7, speed=340, name_color=0xffffff, name="刘林", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=27, pos={3439,785}, dir=7, speed=340, name_color=0xffffff, name="邯郸守军", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=27, pos={3536,719}, dir=7, speed=340, name_color=0xffffff, name="邯郸守军", },
	   		{ event='createActor', delay=0.1, handle_id=5, body=28, pos={3473,851}, dir=7, speed=340, name_color=0xffffff, name="邯郸守军", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=28, pos={3568,785}, dir=7, speed=340, name_color=0xffffff, name="邯郸守军", },


	   		{ event='createActor', delay=0.1, handle_id=7, body=8, pos={2735,275}, dir=3, speed=340, name_color=0xffffff, name="王霸", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=14, pos={2833,211}, dir=3, speed=340, name_color=0xffffff, name="耿弇", },
	   		{ event='createActor', delay=0.1, handle_id=9, body=25, pos={2608,239}, dir=3, speed=340, name_color=0xffffff, name="汉军将士", },
	   		{ event='createActor', delay=0.1, handle_id=10, body=26, pos={2675,207}, dir=3, speed=340, name_color=0xffffff, name="汉军将士", },
	   		{ event='createActor', delay=0.1, handle_id=11, body=25, pos={2737,176}, dir=3, speed=340, name_color=0xffffff, name="汉军将士", },
	   		{ event='createActor', delay=0.1, handle_id=12, body=26, pos={2804,144}, dir=3, speed=340, name_color=0xffffff, name="汉军将士", },
	   	},
	   	--镜头初始化
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 3544,my = 650 }, 	 
	    },

	    --王郎被逮到
	    {
	    	{ event ='camera', delay = 0.1, target_id= 1, sdur=0.1, dur = 0.1,style = 'follow',backtime=1},
	    	{ event = 'move', delay = 0.5,handle_id = 1, dir = 1, pos = {2993,528},speed = 300, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 2, dir = 1, pos = {3088,464},speed = 300, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 3, dir = 1, pos = {3055,594},speed = 300, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 4, dir = 1, pos = {3153,529},speed = 300, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 5, dir = 1, pos = {3120,657},speed = 300, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 0.5,handle_id = 6, dir = 1, pos = {3240,601},speed = 300, dur = 2,end_dir = 7},


	    	-- { event = 'move', delay = 2.5,handle_id = 7, dir = 1, pos = {2903,440},speed = 180, dur = 2,end_dir = 3}, --王霸

	    	{ event='jump', delay=2.2, handle_id=7, dir=3, pos={2903,440}, speed=120, dur=1, end_dir=3 }, 
	    	{ event = 'move', delay = 3,handle_id = 8, dir = 1, pos = {3000,377},speed = 250, dur = 2,end_dir = 3},
	    	{ event = 'move', delay = 3,handle_id = 9, dir = 1, pos = {2708,529},speed = 250, dur = 2,end_dir = 3},
	    	{ event = 'move', delay = 3,handle_id = 10, dir = 1, pos = {2780,330},speed = 250, dur = 2,end_dir = 3},
	    	{ event = 'move', delay = 3,handle_id = 11, dir = 1, pos = {2963,231},speed = 250, dur = 2,end_dir = 3},
	    	{ event = 'move', delay = 3,handle_id = 12, dir = 1, pos = {3143,280},speed = 250, dur = 2,end_dir = 5},

	    	{ event = 'talk', delay= 0.1, handle_id = 1, talk='快走！快走！', dur=2},

	    	{ event ='camera', delay = 2, c_topox = {2903,400}, dur=1, sdur = 1,style = '',backtime=1},
			{ event = 'talk', delay= 2, handle_id = 7, talk='王郎恶贼，哪里跑！', dur=2},
			{ event = 'talk', delay= 2.5, handle_id = 1, talk='！', dur=1.5},

			{ event = 'playAction', delay = 3.5, handle_id= 7, action_id = 2, dur = 0.1, dir = 3,loop = false ,once = false},
	    	{ event = 'playAction', delay = 3.8, handle_id= 1, action_id = 3, dur = 0.1, dir = 7,loop = false ,once = false},
	    	{ event = 'playAction', delay = 4.3, handle_id= 1, action_id = 4, dur = 0.1, dir = 3,loop = false ,once = true},


	    	{ event = 'talk', delay= 4.3, handle_id = 2, talk='！！！', dur=1.5},

	    	{ event = 'move', delay = 4.8,handle_id = 2, dir = 1, pos = {3088+50,464+50},speed = 200, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 4.8,handle_id = 3, dir = 1, pos = {3055-50,594+50},speed = 200, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 4.8,handle_id = 4, dir = 1, pos = {3153+50,529+50},speed = 200, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 4.8,handle_id = 5, dir = 1, pos = {3120-50,657+50},speed = 200, dur = 2,end_dir = 7},
	    	{ event = 'move', delay = 4.8,handle_id = 6, dir = 1, pos = {3240+50,601+50},speed = 200, dur = 2,end_dir = 7},
	    },

	    --刘林求饶
	    {
	    	{ event ='effect', delay = 0.1 ,handle_id=101, target_id=2,  pos={0, 100}, effect_id=20007, is_forever = true},
	    	{ event = 'talk', delay= 0.1, handle_id = 2, talk='[a]将军，我是赵王之后，是被王郎蒙骗了。', dur=2,emote={a=41}},
	    	{ event = 'talk', delay= 2.5, handle_id = 2, talk='我愿归降大司马，向更始陛下效忠，望将军成全！[a]', dur=2,emote={a=48}},
	    },

	    --刘林被弄死
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 8, talk='哼！你害我主公悬赏万金那会，可想到今日？', dur=2},
	    	{ event = 'effect', delay = 0.1 ,handle_id=102, target_id=8,  pos={8, 100}, effect_id=20012, is_forever = true},
	    	{ event = 'move', delay = 2,handle_id = 8, dir = 1, pos = {3095,440},speed = 150, dur = 1,end_dir = 3},

	    	{ event = 'playAction',delay = 2.5, handle_id= 8, action_id = 2, dur = 0.1, dir = 3,loop = false ,once = false},
	    	{ event = 'playAction',delay = 2.8, handle_id= 2, action_id = 3, dur = 0.1, dir = 7,loop = false ,once = true},
	    	{ event = 'playAction',delay = 3.3, handle_id= 2, action_id = 4, dur = 0.1, dir = 7,loop = false ,once = true},

	    	{ event = 'removeEffect', delay = 2.5, handle_id=101, effect_id=20007},
	    	{ event = 'talk', delay= 3, handle_id = 2, talk='啊……', dur=1.5},

	    	{ event = 'talk', delay= 3, handle_id = 3, talk='！！！', dur=1.5},
	    	{ event = 'talk', delay= 3, handle_id = 4, talk='！！！', dur=1.5},
	    	{ event = 'talk', delay= 3, handle_id = 6, talk='！！！', dur=1.5},

	    	{ event = 'removeEffect', delay = 3, handle_id=102, effect_id=20012},
	    },

	    --招降
	    {
	    	{ event = 'talk', delay= 0.1, handle_id = 8, talk='大司马仁德，叛军缴械不杀。', dur=2},

	    	{ event = 'move', delay = 0.1,handle_id = 10, dir = 1, pos = {2727,486},speed = 200, dur = 2,end_dir = 3},
	    	{ event = 'move', delay = 0.1,handle_id = 9, dir = 1, pos = {2810,626},speed = 200, dur = 2,end_dir = 3},
	    	{ event = 'move', delay = 0.1,handle_id = 11, dir = 1, pos = {3170,355},speed = 200, dur = 2,end_dir = 5},
	    	{ event = 'move', delay = 0.1,handle_id = 12, dir = 1, pos = {3315,420},speed = 200, dur = 2,end_dir = 5},

	    	{ event = 'talk', delay= 2.5, handle_id = 9, talk='缴械不杀。', dur=2},
	    	{ event = 'talk', delay= 2.5, handle_id = 10, talk='缴械不杀。', dur=2},
	    	{ event = 'talk', delay= 2.5, handle_id = 11, talk='缴械不杀。', dur=2},
	    	{ event = 'talk', delay= 2.5, handle_id = 12, talk='缴械不杀。', dur=2},

	    	{ event = 'talk', delay= 5, handle_id = 3, talk='我愿归降。', dur=2},
	    	{ event = 'talk', delay= 7, handle_id = 4, talk='我愿归降。', dur=2},
	    	{ event = 'talk', delay= 7, handle_id = 5, talk='我愿归降。', dur=2},
	    	{ event = 'talk', delay= 7, handle_id = 6, talk='我愿归降。', dur=2},
	    },
	},

	--============================================lixin  剧情副本第五章第五节 end    =====================================----
	


----=====================================================================长歌行剧情副本剧情动画配置  END =====================================================------- 



----=====================================================================长歌行主线任务剧情动画配置 START =====================================================-------     


	--============================================wuwenbin  主线任务 剧情1 start  =====================================----

	-- 阴丽华飞机关鸢，最后被阴识训斥
	['juqing-ux001'] = {
		
		--演员表 1 丽华 2 邓禹 3 邓奉 4 阴识
	    --创建角色
	    {
	   		{ event="createSpEntity", delay=0.1,handle_id=1, name="6",name_color=0xffffff, actor_name="丽华", action_id=6, dir=2, pos={914,880}},

	   		{ event='createActor', delay=0.1, handle_id = 2, body=1, pos={658,1040}, dir=1, speed=340, name_color=0xffffff, name="邓禹", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=29, pos={720,1074}, dir=1, speed=340, name_color=0xffffff, name="邓奉", },
	   		-- { event='createActor', delay=0.1, handle_id = 13, body=17, pos={1005,370}, dir=5, speed=340, name_color=0xffffff, name="侍女", },
	    },

	   	--初始化镜头
		{
			{ event='init_cimera', delay = 0.1,mx= 730,my = 950 },
			-- { event ='camera', delay = 0.1, target_id= 11, sdur=0.1, dur = 0.1,style = 'follow',backtime=1},
		},

		--丽华和邓禹邓奉说他能飞了
		{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={786,970}, speed=280, dur=0.1 },	--方向3跑

	   		{ event='talk', delay=0.5, handle_id=1, talk='阿禹！我能飞啦，啊哈哈……', dur=2 },


	   		{ event='talk', delay=2.3, handle_id=2, talk='你……你飞什么飞啊！若是摔下去，可不是闹着玩的！', dur=2.5 },
	   		{ event='talk', delay=5.1, handle_id=1, talk='才不会呢～', dur=2 },
	   		{ event='talk', delay=7.4, handle_id=3, talk='姐姐真厉害，这个东西真能飞起来吗？', dur=2 },
	   		{ event='talk', delay=9.7, handle_id=1, talk='那当然！不信？我飞给你们看看！', dur=2 },
	   	},

	   	--丽华飞起来邓禹拦截
		{
			{ event ='camera', delay = 0.1, target_id= 1, sdur=0.1, dur = 0.5,style = 'follow',backtime=1},
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={564,1102}, speed=180, dur=0.1 },	--方向3跑
	   		{ event='move', delay= 0.5, handle_id=2, end_dir=1, pos={498,1138}, speed=160, dur=0.1 },	--方向3跑
	   		{ event='move', delay= 0.5, handle_id=3, end_dir=5, pos={660,1108}, speed=280, dur=0.1 },	--方向3跑


	   		{ event='talk', delay=1, handle_id=2, talk='丽华！你不能飞！', dur=2 },
	   		{ event='talk', delay=3.3, handle_id=2, talk='如果……如果今天你一定要飞的话……', dur=2.5 },
	   		{ event='talk', delay=6.1, handle_id=2, talk='我！替！你！飞！', dur=2 },

	   		-- { event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1806,878}, speed=280, dur=0.1 },
	   		{ event='talk', delay=8.4, handle_id=1, talk='好！男子汉大丈夫。', dur=2 },
			{ event='talk', delay=10.7, handle_id=1, talk='阿禹，我今天终于见识到你男子汉的一面啦！', dur=2 },
	   		

	   		{ event='kill', delay = 13, handle_id = 1,},
	   		{ event='createActor', delay=13.1, handle_id = 1, body=6, pos={564,1102}, dir=5, speed=340, name_color=0xffffff, name="丽华", },
	   		-- { event='move', delay= 13.3, handle_id=1, end_dir=3, pos={1806,878}, speed=280, dur=0.1 },
			{ event='talk', delay=13.5, handle_id=1, talk='你来飞，快飞啊，快～', dur=2 },
	   	},

	   	--邓禹犹豫，邓奉主动请缨
	   	{
	   		{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={458,1172}, speed=280, dur=0.1 },	--方向3跑

	   		{ event='talk', delay=0.5, handle_id=2, talk='啊…这…这真能飞吗？', dur=2 },
	   		{ event='talk', delay=2.8, handle_id=1, talk='那当然啦……你快飞啊~', dur=2 },

	   		{ event='talk', delay=5.1, handle_id=3, talk='姐姐，要不然让我试试看能不能飞吧。', dur=2 },
	   		{ event='move', delay= 5.1, handle_id=3, end_dir=6, pos={660,1108}, speed=280, dur=0.1 },	--方向3跑
	   		{ event='move', delay= 5.1, handle_id=1, end_dir=2, pos={564,1102}, speed=180, dur=0.1 },	--方向3跑


	   		{ event='move', delay= 6, handle_id=2, end_dir=1, pos={458,1172}, speed=280, dur=0.1 },	--方向3跑
	   		{ event='talk', delay=7.4, handle_id=2, talk='啊…哈，那你飞吧！', dur=2 },
	   		{ event='talk', delay=9.7, handle_id=1, talk='呵…你确定？', dur=2 },
	   		{ event='talk', delay=12, handle_id=3, talk='飞就飞吧，反正我是男子汉大丈夫~', dur=2 },

	   		{ event='kill', delay = 14, handle_id = 1,},
	   		{ event='kill', delay = 14, handle_id = 2,},
	   		{ event='kill', delay = 14, handle_id = 3,},
	   	},

	   	--创建邓奉
	   	{	
	   		{ event='init_cimera', delay = 0.1,mx= 1459,my = 1459 },
	   		
	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1100,1387}, dir=3, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=1, pos={1036,1419}, dir=3, speed=340, name_color=0xffffff, name="邓禹", },
			
	   		{ event="createSpEntity", delay=0.1,handle_id=3, name="29",name_color=0xffffff, actor_name="邓奉", action_id=1, dir=7, pos={1459,1459},},
	   		{ event='setShieldAlpha', delay=0.2, handle_id=3, shield_alpha=255 },		--修改透明度
	   		-- { event ='camera', delay = 0.3, target_id= 3, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},

	   		-- { event='kill', delay = 14, handle_id = 100,},
	   	},


	   	--邓奉盘旋
	   	{
	   		{ event='talk', delay=0.1, handle_id=3, talk='我要飞啦～～', dur=1.5 },
	   		-- { event = 'jump', delay = 1.5, handle_id=3, pos={1297, 1367}, dir = 1,end_dir=3},
	   		{ event ='camera', delay = 1.5, c_topox={1103,910} , sdur=0.1, dur = 2.5,style = '',backtime=1},
	   		{ event='move', delay= 1.5, handle_id=3, end_dir=7, pos={1103,943}, speed=260, dur=3 },	--方向3跑

	   		{ event='talk', delay=2, handle_id=1, talk='你看！我就说能飞吧！', dur=2 },
	   		{ event='talk', delay=2.5, handle_id=3, talk='我能飞啦～～', dur=1.5 },

	   		{ event='move', delay= 2.5, handle_id=1, end_dir=1, pos={1100,1387}, speed=340, dur=1 },	--方向3跑
			{ event='move', delay= 2.5, handle_id=2, end_dir=1, pos={1036,1419}, speed=340, dur=1 },	--邓禹跑过去

			{ event='shake', delay=4.5, dur=1, c_topox={1103,910}, index=30, rate=2, radius=20 }, --通过
	   		{ event = 'playAction', handle_id= 3, delay = 4.3, action_id = 4, dur = 0.1, dir = 7,loop = false ,once = true},	--方向3跑

	   		{ event='talk', delay=4.4, handle_id=3, talk='啊——', dur=1.5 },
			{ event='effect',  delay = 4.7 ,handle_id=101, target_id=3, pos={-85, 85}, effect_id=10131, is_forever = true},	--头顶星星特效

			{ event='move', delay= 4.4, handle_id=1, end_dir=2, pos={940,935}, speed=220, dur=1 },	--方向3跑
	   		{ event='move', delay= 4.4, handle_id=2, end_dir=1, pos={993,1027}, speed=220, dur=1.3 },	--方向3跑

	   		{ event='talk', delay=6, handle_id=3, talk='呜呜……我的脸啊……', dur=3 },
	   		{ event='talk', delay=9.3, handle_id=1, talk='没理由啊？如果是我飞，肯定不会这样。', dur=3 },
	   	},

	   	--阴识出现，训斥众人
	   	{
	   		{ event='createActor', delay =0.1, handle_id = 4, body=30, pos={1403,658}, dir=5, speed=340, name_color=0xffffff, name="阴识", },
			{ event='move', delay = 0.2 , handle_id = 4, end_dir=5, pos={1160,881}, speed=340, dur=4.5 },

			{ event='talk', delay = 1.5 , handle_id = 4, talk='如此胡闹，成何体统！[a]', dur=2.5 ,emote = {a= 34}},
			{ event ='camera', delay = 0.2, target_id= 4, sdur=0.1, dur = 0.5,style = 'follow',backtime=1},
	   	},

	 --   	--邓奉绕着池塘盘旋
	 --   	{
	 --   		-- { event ='camera', delay = 0.3, target_id= 1, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},

	 --   		{ event='move', delay= 0.1, handle_id=3, end_dir=7, pos={886,1044}, speed=240, dur=0.4 },	--方向3跑
	 --   	},
	 --   	{
	 --   		{ event='effect',  delay = 0.4 ,handle_id=101, target_id=3, pos={-85, 85}, effect_id=10131, is_forever = true},	--头顶星星特效
	 --   		{ event='talk', delay=0.2, handle_id=3, talk='啊——', dur=1.5 },
	 --   		{ event = 'playAction', handle_id= 3, delay = 0.2, action_id = 4, dur = 0.1, dir = 7,loop = false ,once = true},

	 --   		{ event='move', delay= 0.2, handle_id=2, end_dir=3, pos={780,960}, speed=280, dur=0.1 },	--方向3跑
	 --   		{ event='move', delay= 0.2, handle_id=1, end_dir=2, pos={746,1042}, speed=280, dur=0.1 },	--方向3跑

	 --   		-- { event='move', delay= 0.2, handle_id=2, end_dir=1, pos={792-20,1078+20}, speed=280, dur=0.1 },	--方向3跑
	 --   		-- { event='move', delay= 0.2, handle_id=1, end_dir=1, pos={850-20,1100+20}, speed=280, dur=0.1 },	--方向3跑

	 --   		{ event='talk', delay=2, handle_id=3, talk='呜呜……我的屁股啊……疼啊……', dur=2 },
	 --   		{ event='talk', delay=4.3, handle_id=1, talk='没理由啊？如果是我飞，肯定不会这样。', dur=2.5 },
	 --   	},

	   	--阴识训斥
		-- {
		-- 	--邓奉栽倒在地
		-- 	{ event ='camera', delay = 0.2, target_id= 4, sdur=0.1, dur = 0.3,style = 'follow',backtime=1},
		-- 	{ event='createActor', delay =0.1, handle_id = 4, body=30, pos={1136,820}, dir=5, speed=340, name_color=0xffffff, name="阴识", },

		-- 	-- { event='move', delay= 0.4, handle_id=1, end_dir=1, pos={720,1074}, speed=280, dur=3.2 },	--方向3跑
	 --   		{ event='move', delay= 0.4, handle_id=2, end_dir=2, pos={780,960}, speed=280, dur=0.1 },	--方向3跑
		-- 	{ event='move', delay = 0.2 , handle_id = 4, end_dir=5, pos={972,974}, speed=240, dur=0.1 },
		-- 	{ event='talk', delay = 0.7 , handle_id = 4, talk='如此胡闹，成何体统！[a]', dur=2.5 ,emote = {a= 34}},
		-- },
		-- --丫鬟追着阴丽华跑
		-- {
	 --   		{ event='talk', delay=0.1, handle_id=11, talk='小姐，求求你了快下来！', dur=2 },
	 --   		{ event='talk', delay=0.1, handle_id=12, talk='小姐小心呀！', dur=2 },

		-- 	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1806,878}, speed=280, dur=0.1 },	--方向3跑
	 --   	},
	 --   	{
	 --        --创建角色，邓禹，邓奉
	 --   		{ event='createActor', delay = 1.3, handle_id = 2, body=1, pos={1119,820}, dir=5, speed=340, name_color=0xffffff, name="邓禹", },
	 --   		{ event='createActor', delay = 1.3, handle_id = 3, body=29, pos={1198,855}, dir=5, speed=340, name_color=0xffffff, name="邓奉", },
	 --   		-- { event ='camera', delay = 0.3, target_id= 1, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},


	 --        --邓禹邓奉跑过去拦住
	        
	 --    	{ event='move', delay= 1.8, handle_id=1, end_dir=7, pos={1551,711}, speed=340, dur=0.1 },	--方向7跑
	 --   		{ event='move', delay= 2.3, handle_id=11, end_dir=7, pos={1625,746}, speed=340, dur=0.1 },	--方向7跑
	 --   		{ event='move', delay= 2.7, handle_id=12, end_dir=7, pos= {1681,782},speed=340, dur=0.1 },	--方向7跑
	 --   		{ event='move', delay= 2.7, handle_id=13, end_dir=7, pos= {1623,816}, speed=340, dur=0.1 },	--方向7跑

	 --   		{ event ='camera', delay = 2.1, c_topox={1537,549} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	 --    	{ event='move', delay=2.1, handle_id=2, end_dir=3, pos={1419,656}, speed=250, dur=0.1 },	--邓禹跑过去
	 --    	{ event='move', delay=2.1, handle_id=3, end_dir=3, pos={1489,619}, speed=250, dur=0.1 },	--邓奉跑过去
		-- },

		-- --邓禹与丽华对话
		-- {
		-- 	{ event='talk', delay=0.5, handle_id=1, talk='阿禹~我能飞了~', dur=1.5 },
	 --   		{ event='talk', delay=2, handle_id=2, talk='你飞什么飞啊！胆子也太大了吧！', dur=2 },
	 --   		{ event='talk', delay=4.1, handle_id=2, talk='你若是摔下去，可不是闹着玩的！', dur=2,},
	 --   		{ event='talk', delay=6, handle_id=3, talk='姐姐真厉害，让我替你飞吧~', dur=2 },
		-- },

		-- --创建角色，普通丽华，带翅膀邓奉
	 --    {
	 --   		{ event='kill', delay=0.1, handle_id=1},
	 --   		{ event='kill', delay=0.1, handle_id=3},

	 --   		{ event='createActor', delay=0.2, handle_id = 1, body=6, pos={1551,711}, dir=5, speed=340, name_color=0xffffff, name="阴丽华", },
	 --   		{ event='createActor', delay=0.2, handle_id = 3, body=29, pos={1489,619}, dir=5, speed=340, name_color=0xffffff, name="邓奉", },
	 --    },

		-- --邓奉盘旋
		-- {
		-- 	--众人跑过去
		-- 	{ event='move', delay= 0.5, handle_id=1, end_dir=7, pos={1397,531}, speed=340, dur=1 },	--方向3跑
		-- 	{ event='move', delay= 0.5, handle_id=2, end_dir=7, pos={1333,559}, speed=340, dur=1 },	--邓禹跑过去
	 --   		-- { event='move', delay= 0.5, handle_id=11, end_dir=5, pos={1397,592}, speed=340, dur=1 },	--方向3跑
	 --   		-- { event='move', delay= 0.5, handle_id=12, end_dir=5, pos={1429,655}, speed=340, dur=1 },	--方向3跑
	 --   		-- { event='move', delay= 0.5, handle_id=13, end_dir=7, pos={1463,594}, speed=340, dur=1 },	--方向3跑

	 --    	--邓奉绕圈
	 --    	{ event ='camera', delay = 0.1, target_id= 3, sdur=0.1, dur = 0.3,style = 'follow',backtime=1},
	 --    	-- { event='move', delay= 0.1, handle_id=3, end_dir=1, pos={1301,489}, speed=340, dur=1.5 },	
	 --    	{ event='move', delay= 0.1, handle_id=3, end_dir=6, pos={1305,400}, speed=340, dur=1.7 },	
	 --    	{ event='move', delay= 2, handle_id=3, end_dir=3, pos={1074,405}, speed=340, dur=1.4 },	
	 --    	{ event='move', delay= 3.6, handle_id=3, end_dir=2, pos={1081,491}, speed=340, dur=0.6 },	

		-- 	{ event='talk', delay=0.5, handle_id=3, talk='我能飞啦~~~~', dur=1.5 },
	 --   		{ event='talk', delay=0.5, handle_id=1, talk='[a]', dur=1.5 ,emote = {a= 15}},
		-- },

		-- --邓奉栽倒在地，阴识训斥
		-- {
		-- 	--邓奉栽倒在地
		-- 	{ event='move', delay= 0.1, handle_id=3, end_dir=2, pos={1190,489}, speed=340, dur=0.1 },
		-- 	{ event='talk', delay=1, handle_id=3, talk='啊！！', dur=1.5 },
		-- 	{ event = 'playAction', handle_id= 3, delay = 0.9, action_id = 4, dur = 0.1, dir = 5,loop = false ,once = true},	--方向3跑
		-- 	{ event='effect', handle_id=5, target_id=3, delay = 1.2 , pos={10, 10}, effect_id=20004, is_forever = true},	--头顶星星特效

		-- 	{ event ='camera', delay = 2, target_id= 4, sdur=0.1, dur = 0.3,style = 'follow',backtime=1},
		-- 	{ event='createActor', delay =1, handle_id = 4, body=30, pos={1147,813}, dir=5, speed=340, name_color=0xffffff, name="阴识", },
		-- 	{ event='move', delay = 2 , handle_id = 4, end_dir=1, pos={1264,660}, speed=340, dur=0.1 },

		-- 	{ event='move', delay= 2.5, handle_id=1, end_dir=5, pos={1397,531}, speed=340, dur=1 },	--方向3跑
		-- 	{ event='move', delay= 2.5, handle_id=2, end_dir=5, pos={1333,559}, speed=340, dur=1 },	--邓禹跑过去
		-- 	{ event='talk', delay = 2.5 , handle_id = 4, talk='如此胡闹，成何体统！[a]', dur=2 ,emote = {a= 34}},
		-- },

	},
	--============================================wuwenbin  主线任务 剧情1 end  =====================================----

	--============================================lixin  主线任务 剧情2 start  =====================================----
	--严子陵言语戏文叔
	--演员表 1 刘秀  2 严子陵
	['juqing-ux002'] = 
	{
	     --欢快的 音乐
		{
			{ event='playBgMusic', delay=0, id = 1 ,loop = true},
		},

	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2318,my = 2000 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=19, pos={1745,2032}, dir=3, speed=340, name_color=0xffffff, name="严子陵"},
	   		-- { event='createActor', delay=0.1, handle_id = 2, body=13, pos={2354,2066}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event="createSpEntity",delay=0.1, handle_id=2, name="13",name_color=0xffffff,actor_name="刘秀", action_id=5, dir=3, pos={2354,2066}},  
	    },

	    --严子陵跑过来，喊话
	    {
	    	{ event='playAction', delay = 0.1, handle_id=2, action_id=5, dur=2, dir=3, loop=true ,once = false},
	    	
	    	{ event='talk', delay=3.5, handle_id=1, talk='文叔哥哥~[a]', dur=1.5 ,emote ={ a=45} },
	    	{ event='talk', delay=5.1, handle_id=1, talk='仕宦当作执金吾，娶妻当得阴丽华~~[a]', dur=2,emote ={ a=45} },
	    	{ event='talk', delay=7.4, handle_id=1, talk='丽华回来啦~~[a]', dur=1.5,emote ={ a=45} },
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=2, pos={2200,2066}, speed=300, dur=1.5 },
	    	{ event='move', delay= 3, handle_id=1, end_dir=1, pos={2324,2130}, speed=170, dur=1},	    	
	    	{ event='move', delay= 4.6, handle_id=1, end_dir=5, pos={2387,2001}, speed=150, dur=1 },	
	    	{ event='move', delay= 6.6, handle_id=1, end_dir=7, pos={2416,2101}, speed=150, dur=1 },    	
	    	-- { event='move', delay= 4.5, handle_id=2, end_dir=1, pos={2354,2066}, speed=150, dur=1 },
	    	
	    	{ event='playAction', delay = 4.5, handle_id=2, action_id=5, dur=2, dir=1, loop=true ,once = false},
	    	{ event='playAction', delay = 6.1, handle_id=2, action_id=5, dur=2, dir=3, loop=true ,once = false},

	    	{ event='talk', delay=3.9, handle_id=2, talk='[a]', dur=4 ,emote ={ a=13}},
	    },   
	    --严子陵跑到刘秀面前，BB
	    {
	    	{ event='move', delay= 0.5, handle_id=2, end_dir=3, pos={2354,2066}, speed=150, dur=1 },
			{ event='talk', delay=0.5, handle_id=2, talk='严！子！陵！[a]', dur=1.5,emote ={ a=34} },
			{ event='talk', delay=2.2, handle_id=2, talk='你的玩笑不好笑！[a]', dur=1.5,emote ={ a=24} },
	    },

	    {
	      { event='backSceneMusic', delay = 0}, 
	    },
	},

	--============================================lixin  主线任务 剧情2 end  =====================================----
	--============================================lixin  主线任务 剧情2.5 start  =====================================----
    --相救珊彤
	--演员表  过珊彤-6 ；劫匪1-2；劫匪2-3；劫匪3-4；刘秀-5 ；过主-1；吴汉-7；劫匪4-8；
	['juqing-ux1002'] = 
	{
		{
	   		{ event='init_cimera', delay = 0.1,mx= 2800,my = 2575 }, 	 
	    },
		--创建人物
	    { 
	   		-- { event='createActor', delay=0.1, handle_id=1, body=2, pos={1173,1879}, dir=1, speed=340, name_color=0xffffff, name="过主"}, 
	   		-- { event='createActor', delay=0.1, handle_id=6, body=2, pos={1173,1976}, dir=1, speed=340, name_color=0xffffff, name="过珊彤"}, 
	   		{ event='createActor', delay=0.1, handle_id=1, body=11, pos={2546,2640}, dir=1, speed=340, name_color=0xffffff, name="过主"}, 
	   		{ event='createActor', delay=0.1, handle_id=6, body=17, pos={2578,2769}, dir=1, speed=340, name_color=0xffffff, name="过珊彤"},	   		
	   		{ event='createActor', delay=0.1, handle_id=2, body=31, pos={2096,2678}, dir=2, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=3, body=32, pos={2187,2795}, dir=2, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=4, body=32, pos={2128,2864}, dir=2, speed=340, name_color=0xffffff, name="劫匪"},  
	    },
	    --追过珊彤
	    {
	    	--过珊彤和他妈跑
	    	{ event='talk', delay=1.6, handle_id=1, talk='!!!', dur=1 },
	    	{ event='talk', delay=1.6, handle_id=6, talk='害怕o((⊙﹏⊙))o.', dur=1 },
	    	{ event='move', delay=0.1, handle_id=1, end_dir=6, pos={2995-120,2546}, speed=280, dur=1 },
	    	{ event='move', delay=0.1, handle_id=6, end_dir=6, pos={3088-120,2672}, speed=280, dur=1 },

	    	{ event='move', delay=2.2, handle_id=1, end_dir=6, pos={3471,2355}, speed=300, dur=1 },
	    	{ event='move', delay=2.2, handle_id=6, end_dir=6, pos={3566,2515}, speed=300, dur=1 },

	    	--土匪跑
	    	{ event='move', delay=1.3, handle_id=2, end_dir=1, pos={3471,2355}, speed=220, dur=4 },
	    	{ event='move', delay=1.3, handle_id=3, end_dir=1, pos={3598,2354}, speed=220, dur=4 },
	    	{ event='move', delay=1.3, handle_id=4, end_dir=1, pos={3566,2515}, speed=220, dur=4 },
	    	{ event='talk', delay=1.8, handle_id=2, talk='哪里跑！', dur=3 },
	    	{ event='talk', delay=1.8, handle_id=4, talk='站住！', dur=3},
	    },
	    --创建刘秀
	    {
	    	{ event='createActor', delay=1, handle_id=5, body=13, pos={2548,2188}, dir=6, speed=450, name_color=0xffffff, name="刘秀"}, 
	    },
	    --刘秀出现
	    {
	    	{ event='kill', delay=0.1, handle_id=1},
	    	{ event='kill', delay=0.1, handle_id=2},
	    	{ event='kill', delay=0.1, handle_id=3},
	    	{ event='kill', delay=0.1, handle_id=4},
	    	{ event='kill', delay=0.1, handle_id=6},

	    	{ event='move', delay=0.1, handle_id=5, end_dir=3, pos={2771,2572}, speed=340, dur=1 },
	    	{ event='showTopTalk', delay=2, dialog_id="1_1_1" ,dialog_time = 1.5},

	    },
	    --刘秀吃惊
	    {
	    	{ event='move', delay=0.5, handle_id=5, end_dir=2, pos={2898,2545}, speed=200, dur=1 },
	    	{ event='talk', delay=0.1, handle_id=5, talk='！！！', dur=1.5 },
	    },

		{
	   		{ event='init_cimera', delay = 0.1,mx= 3372,my = 1100 },
	   		-- { event='createParticle', id =1 ,delay = 0.1,pos={1487,1150},scale = 1,path= "particle/xueqiu.plist" },	
	   		-- { event='removeParticle', id =1 },	
	    },
		--创建人物ux
	    {
	   		{ event='createActor', delay=0.1, handle_id=6, body=17, pos={3313,1040}, dir=3, speed=340, name_color=0xffffff, name="过珊彤"},
	   		{ event='createActor', delay=0.1, handle_id=1, body=11, pos={3465,1275}, dir=7, speed=340, name_color=0xffffff, name="过主"}, 
	   		{ event='createActor', delay=0.1, handle_id=2, body=31, pos={3279,1140}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=3, body=32, pos={3408,1073}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=7, body=8, pos={3396,1188}, dir=3, speed=340, name_color=0xffffff, name="吴汉"}, 
	    },
	    --冒泡BB
	    {
	    	-- { event='move', delay=2, handle_id=7, end_dir=3, pos={1517, 1235}, speed=750, dur=1 },
	    	-- { event='move', delay=3.5, handle_id=7, end_dir=3, pos={1456,1265}, speed=750, dur=1 },
	    	{ event='talk', delay=1, handle_id=7, talk='快给你夫家写封信，让他们拿钱来赎你们，否则……', dur=2 },

	    	{ event='talk', delay=3.3, handle_id=6, talk='母亲！我怕……[a]', dur=2,emote = {a = 33}},
	    	{ event ='move', delay=3.3, handle_id=6, end_dir=3, pos={3323,1050}, speed=200, dur=1 },

	    	{ event ='move', delay=4.3, handle_id=1, end_dir=7, pos={3455,1265}, speed=200, dur=1 },
	    	{ event='talk', delay=4.3, handle_id=1, talk='珊彤……别怕，有母亲在。', dur=2 },

	    	{ event ='move', delay=3.5, handle_id=2, end_dir=3, pos={3335,1109}, speed=200, dur=1 },
	    	{ event ='move', delay=3.5, handle_id=3, end_dir=3, pos={3368,1102}, speed=200, dur=1 },
	    
	    	{ event='kill', delay=0.1, handle_id=5},
	    },
	    {
	    	--{ event='move', delay=0.1, handle_id=7, end_dir=5, pos={2955, 1461}, speed=300, dur=0.5 },
	    	{ event='playAction', delay=0.1, handle_id=7, action_id=2, dur=1, dir=3, loop=false },
	    	{ event='talk', delay=1, handle_id=7, talk='快写！我这刀枪可不会像我这么好商量！', dur=2 }, 
	    },
	    --报！！！
	    {
	    	{ event='showTopTalk', delay=1, dialog_id="1_1_2" ,dialog_time = 1.2},
	    	{ event='createActor', delay=0.1, handle_id=5, body=13, pos={3407,1747}, dir=7, speed=340, name_color=0xffffff, name="刘秀"}, 
	    },
	    --刘秀报过来冒泡，土匪害怕
	    {
	    	{ event ='camera', delay = 0.1, target_id=5, dur=0.5, sdur = 2,style = 'follow',backtime=1},
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=1, pos={3365,1337}, speed=300, dur=2 },
	    	{ event ='move', delay=0.5, handle_id=1, end_dir=5, pos={3469,1250}, speed=340, dur=2 },
	    	{ event ='talk', delay=2.5, handle_id=5, talk='禀夫人，在下乃大司徒王寻辖下参军。', dur=2 },
	    	{ event ='talk', delay=4.6, handle_id=5, talk='大司徒得知夫人要前来，特派卑职前来相迎。', dur=2 },
	    },
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = {3351,1106-30}},
	    	-- { event='talk', delay=0.5, handle_id=2, talk='[a]', dur=2,emote = {a = 41}},,
	    	{ event='talk', delay=0.5, handle_id=3, talk='头儿，咱们可是逃兵，不能见官……', dur=2 },
	    	{ event ='move', delay=3, handle_id=7, end_dir=7, pos={3396,1188}, speed=200, dur=1 },--吴汉转身
	    	{ event ='move', delay=3.5, handle_id=2, end_dir=3, pos={3279,1140}, speed=200, dur=1 },
	    	{ event ='move', delay=3.5, handle_id=3, end_dir=3, pos={3408,1073}, speed=200, dur=1 },

	    	{ event ='move', delay=4, handle_id=7, end_dir=7, pos={3342+25,1109+20}, speed=340, dur=1 },--吴汉走过
	    	{ event='talk', delay=4, handle_id=7, talk='哼！[a]', dur=1.5, emote = {a = 32}},
	    	{ event='playAction', delay=5, handle_id=7, action_id=2, dur=1, dir=7, loop=false },
	    	{ event='playAction', delay=5.3, handle_id=6, action_id=3, dur=0.5, dir=3, loop=false },
	    	{ event='playAction', delay=5.8, handle_id=6, action_id=4, dur=1, dir=7, loop=false,once =true},
	    	{ event='talk', delay=5.5, handle_id=6, talk='啊啊……[a]', dur=1.5,emote = {a = 5}},


	    	{ event ='move', delay=0.5, handle_id=1, end_dir=7, pos={3455,1265}, speed=280, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=7, pos={3365,1337}, speed=300, dur=2 },
	    },
	    --土匪走了
	    {
	    	--{ event = 'camera', delay = 0.5, dur=2,sdur = 0.9,style = '',backtime=1, c_topox = {3023,1232}},
	    	{ event='talk', delay=0, handle_id=7, talk='快走！', dur=1.5, },
	    	{ event='move', delay=0.5, handle_id=2, end_dir=3, pos={3088, 625}, speed=200, dur=1 },
	    	{ event='move', delay=0.5, handle_id=3, end_dir=3, pos={3088, 625}, speed=200, dur=1 },
	    	{ event='move', delay=0.5, handle_id=7, end_dir=3, pos={3088, 625}, speed=200, dur=1 },

	    	{ event='talk', delay=0.1, handle_id=1, talk='！！！', dur=1.5 },
	    	{ event='talk', delay=0.1, handle_id=5, talk='！！！', dur=1.5 },  	
	    },
	    --镜头切回，过珊彤刘秀BB
	    {
	    	{ event='kill', delay=1, handle_id=2},
	    	{ event='kill', delay=1, handle_id=3},
	    	{ event='kill', delay=1, handle_id=7}, 
	    	-- { event ='camera', delay = 0.1, target_id=5, dur=0.5, sdur = 2,style = 'follow',backtime=1},
	    	{ event ='move', delay=0.1, handle_id=5, end_dir=7, pos={3313,1169}, speed=280, dur=1 },
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=7, pos={3409,1075}, speed=280, dur=1 },
	    	--{ event ='move', delay=1, handle_id=1, end_dir=5, pos={1615,1329}, speed=340, dur=0.1 },
	    },
	    --开始BB
	    {
	    	{ event='talk', delay=0.1, handle_id=1, talk='珊彤……', dur=1.5 },
	    	{ event='talk', delay=2.2, handle_id=6, talk='呜呜……母亲……', dur=1.5 ,},
	    	{ event ='move', delay=4.3, handle_id=5, end_dir=1, pos={3307,1107}, speed=300, dur=1 },
	    	{ event='talk', delay=4.3, handle_id=5, talk='姑娘，来我看看……', dur=1.5 },
	    	{ event='playAction', delay=5.5, handle_id=6, action_id=0, dur=1, dir=3, loop=true },
	    	{ event='talk', delay=7, handle_id=5, talk='你的伤口不深，他们只是割掉了你一缕头发而已。', dur=2 },
	    	{ event='talk', delay=9.2, handle_id=5, talk='相信我，你不会有事的。', dur=1.5 }, 	
	    	{ event='talk', delay=11, handle_id=6, talk='恩……谢谢大哥哥……', dur=1.5},
	    },
	    --接着BB
	    {
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=1, pos={3307,1107}, speed=340, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=1, end_dir=5, pos={3409,1075}, speed=340, dur=1 },
	    	{ event='talk', delay=1, handle_id=1, talk='你真的是王寻大司徒的参军吗？', dur=2 },
	    	{ event='talk', delay=3.4, handle_id=5, talk='我只是一个返乡的太学生，我叫刘文叔。', dur=2 },
	    	{ event='talk', delay=5.8, handle_id=1, talk='刘文叔……', dur=1.5 },
	    	
	    },
	    --劫匪回来了
	    {
	   		{ event='createActor', delay=0.1, handle_id=2, body=31, pos={2960,209}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=3, body=32, pos={3151,177}, dir=3, speed=340, name_color=0xffffff, name="劫匪"}, 
	   		{ event='createActor', delay=0.1, handle_id=7, body=8,  pos={3087,274}, dir=3, speed=340, name_color=0xffffff, name="吴汉"}, 

	    	{ event ='move', delay=0.5, handle_id=1, end_dir=7, pos={3409,1075}, speed=450, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=7, pos={3307,1107}, speed=450, dur=1 },
	    	{ event ='move', delay=0.5, handle_id=6, end_dir=7, pos={3323,1050}, speed=450, dur=1 },

	    	{ event='showTopTalk', delay=0.1, dialog_id="1_1_3" ,dialog_time = 2},
	    	{ event='talk', delay=2.2, handle_id=6, talk='啊！母亲！他们又追上来了', dur=2 },

	    	{ event ='move', delay=4.5, handle_id=2, end_dir=5, pos={3120,784}, speed=340, dur=2 },
	    	{ event ='move', delay=4.5, handle_id=3, end_dir=5, pos={3249,785}, speed=340, dur=2 },
	    	{ event ='move', delay=4.5, handle_id=7, end_dir=5, pos={3183,848}, speed=340, dur=2 },	    	
	    	{ event ='camera', delay = 4.2, c_topox = {3104,312}, dur=0.5, sdur = 1,style = '',backtime=1},
	    	{ event='talk', delay=4.4, handle_id=7, talk='快追！', dur=1.5, },
	    	{ event='talk', delay=4.4, handle_id=2, talk='别让他们跑了！', dur=1.5, },
	    },

	    --刘秀说 你们走吧 留我一人 装B就够了 
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {3354,1108-20}, dur=0.5, sdur = 1,style = '',backtime=1},

	    	{ event='kill', delay=1, handle_id=2},
	    	{ event='kill', delay=1, handle_id=3},
	    	{ event='kill', delay=1, handle_id=7}, 

	    	{ event ='move', delay=0.1, handle_id=1, end_dir=5, pos={3409,1075}, speed=340, dur=1 },
	    	{ event ='move', delay=0.1, handle_id=5, end_dir=1, pos={3307,1107}, speed=340, dur=1 },
	    	{ event ='move', delay=0.1, handle_id=6, end_dir=3, pos={3323,1050}, speed=340, dur=1 },
	    	{ event='talk', delay=1, handle_id=5, talk='夫人，小姐，你们先走，我来断后。', dur=2 },
	    	{ event='talk', delay=3.2, handle_id=1, talk='感谢壮士舍命相救，我们母女来日必定相报！', dur=2 },
	    	{ event='talk', delay=5.4, handle_id=6, talk='那你呢……', dur=1.5 },
	    	{ event='talk', delay=7.1, handle_id=5, talk='他们的目的是你们，我不会有事的，你们先走。', dur=2 },
	    	{ event='talk', delay=9.3, handle_id=6, talk='可是……', dur=1.5 },
	    	{ event='talk', delay=11, handle_id=5, talk='小姑娘，别担心，来日有缘再见，快走。', dur=2 },
	    	{ event='talk', delay=13.2, handle_id=1, talk='珊彤，快走吧。', dur=1.5 },
	    },

	    --他们走了
	    {
	    	{ event ='move', delay=0.1, handle_id=6, end_dir=7, pos={3442,1296}, speed=300, dur=2 },
	    	{ event ='move', delay=0.1, handle_id=1, end_dir=7, pos={3537,1331}, speed=300, dur=2 },
	    	{ event ='move', delay=0.5, handle_id=5, end_dir=7, pos={3307,1107}, speed=340, dur=1 },
	    	{ event ='move', delay=2, handle_id=5, end_dir=3, pos={3307,1107}, speed=340, dur=1 },
	    	{ event='talk', delay=2, handle_id=6, talk='刘文叔……刘文叔……', dur=1.5 },
	    	{ event='talk', delay=3.7, handle_id=5, talk='小姑娘，别担心，来日有缘再见，快走。', dur=2 },
	    	{ event='talk', delay=3.7, handle_id=5, talk='文叔……再见……我们一定要再见面！', dur=2 },
	    	

	    	{ event ='move', delay=6, handle_id=6, end_dir=3, pos={3665,1448+100}, speed=280, dur=2 },
	    	{ event ='move', delay=6, handle_id=1, end_dir=3, pos={3665,1448+100}, speed=280, dur=2 },	 
	    },
	},
	--============================================lixin  主线任务 剧情2.5 start  =====================================----

    --============================================luyao  主线任务 剧情3 start  =====================================----
	--伯升之勇
	['juqing-ux003'] = 
	{
	--创建角色 1刘秀 2吴汉 3杂兵 4杂兵 5刘縯
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2262,my = 2005 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=13, pos={2172,2070}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=8, pos={2491,2194}, dir=7, speed=340, name_color=0xffffff, name="吴汉", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=15, pos={2481,2289}, dir=7, speed=340, name_color=0xffffff, name="杂兵", },
	   		{ event='createActor', delay=0.1, handle_id = 4, body=16, pos={2622,2223}, dir=7, speed=340, name_color=0xffffff, name="杂兵", },

	   		{ event='move', delay= 0.3, handle_id=1, end_dir=3, pos={2072,1970}, speed=340, dur=1 },
	    	{ event='move', delay= 0.3, handle_id=2, end_dir=7, pos={2328,2081}, speed=340, dur=1 },
	    	{ event='move', delay= 0.3, handle_id=3, end_dir=7, pos={2429,2172}, speed=340, dur=1 },	    	
	    	{ event='move', delay= 0.3, handle_id=4, end_dir=7, pos={2529,2057}, speed=340, dur=1 },	
	    },

	    {
	    	{ event='talk', delay=0.1, handle_id=2, talk='我吴汉平生最恨就是南阳人！', dur=2},

	    	{ event='talk', delay=2.3, handle_id=2, talk='今日算你倒霉，死在我枪下！', dur=2 },
	    	{ event='talk', delay=4.6, handle_id=2, talk='看枪！', dur=1.5 },




--	    	{ event='move', delay= 7, handle_id=2, end_dir=7, pos={2238,2034}, speed=50, dur=1 },
--	    	{ event='move', delay= 8, handle_id=2, end_dir=7, pos={2238,2034}, speed=340, dur=0.1 },

	    	{ event='createActor', delay=4.6, handle_id = 5, body=14, pos={2009,2118}, dir=2, speed=340, name_color=0xffffff, name="刘縯", },
	    	{ event = 'jump', delay = 4.8, handle_id=5, pos={2192, 1986}, dir = 1,end_dir=3},
	        -- { event = 'playAction', delay = 6.6, handle_id= 5, action_id = 0, dir = 3,loop = false },

	        
	        { event = 'playAction', delay = 5.2, handle_id= 2, action_id = 2, dur = 1, dir = 7,loop = false },
	        { event = 'playAction', delay = 5.4, handle_id= 5, action_id = 2, dur = 1, dir = 3,loop = false },
	        
	        -- { event = 'playAction', delay = 7.2, handle_id= 5, action_id = 2, dur = 1, dir = 3,loop = false },
	        { event = 'playAction', delay = 5.8, handle_id= 2, action_id = 4, dur = 1, dir = 7,loop = false, once = true},	

	        { event='move', delay= 6.6, handle_id=2, end_dir=7, pos={2328,2081}, speed=340, dur=1 },
	        { event='talk', delay=6.3, handle_id=2, talk='！！！', dur=1.5 },
	        { event='talk', delay=6.3, handle_id=3, talk='！', dur=1.5 },
	        { event='talk', delay=6.3, handle_id=4, talk='！', dur=1.5 },
			-- { event = 'effect', handle_id=101, delay = 5.2,  pos = {70,62}, layer = 2, effect_id = 20015, dx = 0,dy = 0,is_forever = false}, 	
		},
		{
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=7, pos={2329,2172}, speed=340, dur=1 },	    	
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=7, pos={2429,2057}, speed=340, dur=1 },

	    	{ event='talk', delay=1.5, handle_id=3, talk='没事吧，大哥！', dur=1.5 },
	    	{ event='talk', delay=1.5, handle_id=4, talk='没事吧，大哥！', dur=1.5 },
	    	{ event='talk', delay=3.3, handle_id=5, talk='哪来的混贼？连我刘縯的弟弟都敢劫？！', dur=2 },
	    	{ event='talk', delay=5.6, handle_id=2, talk='敢问兄台，是南阳刘縯刘伯升？', dur=2 },
	    	{ event='talk', delay=7.9, handle_id=5, talk='怎么样，不服？', dur=2 },
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=3, pos={2232, 2036}, speed=340, dur=1 },	

	    	{ event='talk', delay=1.2, handle_id=5, talk='不服你们都一起上吧，我奉陪到底！', dur=2 },
	    	{ event = 'playAction', delay = 1.2, handle_id= 5, action_id = 2, dur = 1, dir = 3,loop = false },
	    	{ event='talk', delay=3.5, handle_id=2, talk='既然败于你手，要杀要剐冲我来，让我兄弟们走！', dur=2.5 },
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=2, pos={2138,2083}, speed=340, dur=1 },	   

	    	{ event='move', delay= 1, handle_id=2, end_dir=6, pos={2328,2081}, speed=340, dur=1 },
	    	{ event='talk', delay=1, handle_id=1, talk='这位壮士，你我并无怨仇。', dur=2 },
	    	{ event='talk', delay=3.8, handle_id=1, talk='为何要拼个你死我活？', dur=2 },
	    	{ event='talk', delay=6.6, handle_id=1, talk='你们走吧。', dur=1.5 },

	    	{ event='move', delay= 8.4, handle_id=2, end_dir=7, pos={2328,2081}, speed=340, dur=1 },
			{ event='talk', delay=8.4, handle_id=2, talk='[a]当真不杀我？！', dur=2 ,emote ={ a=25}},

			{ event='talk', delay=10.7, handle_id=5, talk='我三弟让你们走，你们就赶紧走！', dur=2.5},

	    	{ event='talk', delay=13.5, handle_id=2, talk='多谢兄弟不杀之恩，告辞！', dur=2 },

	    	{ event='move', delay= 15.5, handle_id=2, end_dir=3, pos={2328,2081}, speed=340, dur=1 },

	    	{ event='talk', delay=15.8, handle_id=2, talk='走！', dur=1.5 },

	    	{ event='move', delay= 16.5, handle_id=2, end_dir=3, pos={2491,2594}, speed=300, dur=1.5 },
	    	{ event='move', delay= 17, handle_id=3, end_dir=3, pos={2481,2689}, speed=300, dur=1.5 },
	    	{ event='move', delay= 17, handle_id=4, end_dir=3, pos={2622,2623}, speed=300, dur=1.5 },
	   		-- { event='kill', delay=29, handle_id=2},
	   		-- { event='kill', delay=29, handle_id=3},
	   		-- { event='kill', delay=29, handle_id=4},
		},

	},


	--============================================luyao  主线任务 剧情3 end  =====================================----

	--============================================wuwenbin  主线任务 剧情4 start  =====================================----

	-- 及冠之礼
	['juqing-ux004'] = {

	   	--创建角色，丽华，邓奉，邓婵，邓禹，邓父男女家眷
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1836,2063}, dir=1, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=29, pos={1904,2093}, dir=1, speed=340, name_color=0xffffff, name="邓奉", },
	   		{ event="createSpEntity", delay=0.1,handle_id=6, name="60",name_color=0xffffff, actor_name="机关鸢", action_id=6, dir=3, pos={1969,1969}},	   		
	    },

	    --初始化镜头
		{
			{ event='init_cimera', delay = 0.1,mx= 2000,my = 1880 },
		},

	    --机关鸢飞行
	    {	
	    	{ event='talk', delay = 0.1 , handle_id = 2, talk='飞！', dur=1.5 },
	    	-- { event='zoom', delay=0.3, sValue=1.0, eValue=1.3, dur=0.5}, -- 通过
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=3, pos={2873,2419}, speed=60, dur=0.5 },	
	    	{ event='move', delay= 0.4, handle_id=1, end_dir=3, pos={1836,2063}, speed=340, dur = 1},
	    	{ event='move', delay= 0.4, handle_id=2, end_dir=3, pos={1904,2093}, speed=340, dur = 1},


	    	{ event='move', delay= 2, handle_id=6, end_dir=7, pos={1189,1645}, speed=60, dur=0.5 },	
	    	{ event='move', delay= 2.8, handle_id=1, end_dir=1, pos={1836,2063}, speed=340, dur = 1},
	    	{ event='move', delay= 2.8, handle_id=2, end_dir=1, pos={1904,2093}, speed=340, dur = 1},

	    	{ event='move', delay= 3.2, handle_id=1, end_dir=7, pos={1836,2063}, speed=340, dur = 1},
	    	{ event='move', delay= 3.2, handle_id=2, end_dir=7, pos={1904,2093}, speed=340, dur = 1},

	    	{ event='move', delay= 4.2, handle_id=6, end_dir=3, pos={1845,1969}, speed=120, dur = 1},	--丽华转身
	    	{ event='move', delay= 4.7, handle_id=1, end_dir=7, pos={1836,2063}, speed=340, dur = 1},
	    	{ event='move', delay= 4.7, handle_id=2, end_dir=7, pos={1904,2093}, speed=340, dur = 1},
	    },

	    --丽华称赞邓奉
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 1, talk='真聪明，我都没想到。', dur=2 },
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1836,2063}, speed=340, dur = 1},
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1904,2093}, speed=340, dur = 1},
	    },

	    --前置对白，邓父说话
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id='ux4_1' ,dialog_time = 4,},  -- 下部弹出窗口通过
	    	
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={1836,2063}, speed=340, dur = 1},	--丽华转身
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1904,2093}, speed=340, dur = 1},
	    },
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 2, talk='哎呀，小叔叔的及冠之礼开始了。', dur=2 },
	    	{ event='talk', delay = 2.4 , handle_id = 1, talk='我们去观礼吧。', dur=2 },

	    	{ event='move', delay= 0.2, handle_id=1, end_dir=3, pos={1836,2063}, speed=340, dur = 1},	--丽华转身
	    	-- { event='move', delay= 4.7, handle_id=2, end_dir=7, pos={1461,1846}, speed=340, dur = 1},

	    	{ event='kill', delay=4.7, handle_id=3}, 
	    	{ event='kill', delay=4.7, handle_id=3}, 
	    },

	    --创建出观礼人群
	    {
	    	{ event='init_cimera', delay = 0.4,mx= 779,my = 986 },
	    	-- { event='zoom', delay=0.4, sValue=1.3, eValue=1.0, dur=0.3}, -- 通过
	    	{ event = 'changeRGBA',delay = 0.1 , dur=1,txt = "",cont_time = 0.8},

	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1234,1136}, dir=1, speed=340, name_color=0xffffff, name="丽华", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=29, pos={1296,1165}, dir=1, speed=340, name_color=0xffffff, name="邓奉", },
	    	{ event='createActor', delay=0.1, handle_id = 3, body=10, pos={753,973}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },

	   		{ event='createActor', delay=0.1, handle_id = 4, body=1, pos={549,1134}, dir=7, speed=340, name_color=0xffffff, name="邓禹", },   --跪着的邓禹
	   		{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={461,1070}, dir=3, speed=340, name_color=0xffffff, name="邓父", }, 

	   		{ event='createActor', delay=0.1, handle_id = 11, body=19, pos={240,1236}, dir=1, speed=340, name_color=0xffffff, name="", },	--男眷1
	   		{ event='createActor', delay=0.1, handle_id = 12, body=17, pos={301,1261}, dir=1, speed=340, name_color=0xffffff, name="", },	--女眷1
	   		{ event='createActor', delay=0.1, handle_id = 13, body=19, pos={372,1291}, dir=1, speed=340, name_color=0xffffff, name="", },	--男眷2
	   		{ event='createActor', delay=0.1, handle_id = 14, body=19, pos={435,1331}, dir=1, speed=340, name_color=0xffffff, name="", },	--男眷3
	   		-- { event='createActor', delay=0.1, handle_id = 15, body=2, pos={492,1355}, dir=1, speed=340, name_color=0xffffff, name="", },	--女眷2
	   		{ event='createActor', delay=0.1, handle_id = 16, body=19, pos={531,1397}, dir=1, speed=340, name_color=0xffffff, name="", },	--男眷4
	   		{ event='createActor', delay=0.1, handle_id = 17, body=19, pos={556,1297}, dir=7, speed=340, name_color=0xffffff, name="", },	--男眷5
	   		-- { event='createActor', delay=0.1, handle_id = 18, body=2, pos={630,1262}, dir=7, speed=340, name_color=0xffffff, name="", },	--女眷3
	   		{ event='createActor', delay=0.1, handle_id = 19, body=17, pos={854,1171}, dir=6, speed=340, name_color=0xffffff, name="", },	--女眷4
	   		{ event='createActor', delay=0.1, handle_id = 20, body=19, pos={911,1134}, dir=6, speed=340, name_color=0xffffff, name="", },	--男眷6
	   		{ event='createActor', delay=0.1, handle_id = 21, body=17, pos={980,1097}, dir=6, speed=340, name_color=0xffffff, name="", },	--女眷5
	    },

	    --邓奉，阴丽华去观礼
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={818,1001}, speed=250, dur=3 },	
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={887,1036}, speed=250, dur=3 },	
	    },

	    --丽华感叹典礼
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 1, talk='[a]好庄重……', dur=1.5 ,emote = {a= 25}},
	    	{ event='move', delay= 1.6, handle_id=3, end_dir=3, pos={753,973}, speed=340, dur=0.5 },
	    	{ event='move', delay= 1.8, handle_id=1, end_dir=7, pos={818,1001}, speed=250, dur=3 },	
	    	{ event='talk', delay = 2 , handle_id = 3, talk='[a]你的及笄之礼还未行。', dur=2.5 ,emote = {a= 38}},
	    	{ event='talk', delay = 2 , handle_id = 1, talk='[a]', dur=2 ,emote = {a= 38}},
	    	{ event='talk', delay = 4.6 , handle_id = 3, talk='不然也是这般庄重。', dur=2 },
	    	{ event='move', delay= 6.9, handle_id=3, end_dir=5, pos={753,973}, speed=340, dur=0.5 },
	    	{ event='move', delay= 6.9, handle_id=1, end_dir=5, pos={818,1001}, speed=250, dur=0.5 },	
	    },
	    
	    --前置对白，邓父说话
	    {
	    	{ event ='camera', delay = 0.1, c_topox={554,1086} , sdur=0.1, dur = 0.5,style = '',backtime=1},
	    	{ event='showTopTalk', delay=0.5, dialog_id='ux4_2' ,dialog_time = 4,},  -- 下部弹出窗口通过
	    },

	    -- --邓禹起立
	    -- {
	    -- 	{ event='hideCast', delay=0.2, handle_id=4},
	    -- 	{ event='showCast', delay=0.2, handle_id=6},
	    -- },

	    --丽华感叹典礼
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 5, talk='礼毕——', dur=2 },
	    	-- { event='talk', delay = 1 , handle_id = 1, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 2, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 3, talk='拍手庆祝表情', dur=2.5 },

	    	-- { event='talk', delay = 1 , handle_id = 11, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 13, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 12, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 17, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 19, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 21, talk='拍手庆祝表情', dur=2.5 },
	    	-- { event='talk', delay = 1 , handle_id = 22, talk='拍手庆祝表情', dur=2.5 },
	    },

	},

	--============================================wuwenbin  主线任务 剧情4 end  =====================================----

	--============================================wuwenbin  主线任务 剧情5 start  =====================================----

	-- 秀之牵挂 
	['juqing-ux005'] = {

	   	--创建角色，丽华，带翅膀的邓奉，邓婵，邓禹，邓父男女家眷
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=13, pos={1806,2060}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=14, pos={1648,2038}, dir=1, speed=340, name_color=0xffffff, name="刘縯", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=23, pos={1708,1971}, dir=5, speed=340, name_color=0xffffff, name="邓晨", },
	    },

	    --初始化镜头
		{
			{ event='init_cimera', delay = 0.1,mx= 1746,my = 2000 },
		},

	    --刘秀，刘縯，邓晨对话
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 2, talk='这个阴丽华就是阴家千金？', dur=2 },
	    	{ event='talk', delay = 2 , handle_id = 3, talk='是的。', dur=1.5 },
	    	{ event='talk', delay = 3.5 , handle_id = 1, talk='[a]丽华？', dur=2 ,emote = {a= 25}},
	    },

	    --刘秀跑走，邓晨追问
	    {
	    	{ event='move', delay= 0.3, handle_id=1, end_dir=7, pos={1966,2160}, speed=250, dur=1 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={1648,2038}, speed=250, dur=1 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1708,1971}, speed=250, dur=1 },
	    	{ event='talk', delay = 0.1 , handle_id = 3, talk='文叔？！去哪？', dur=1.5 },
	    	{ event='talk', delay = 1.2 , handle_id = 1, talk='我去找人！', dur=1.5 },
	    	{ event='move', delay= 1.8, handle_id=1, end_dir=3, pos={2478,2252}, speed=250, dur=0.1 }, --刘秀继续跑
	    },	

	    --下雨特效，刘縯追了几步
	    {
	    	-- { event = 'effect', handle_id=1 delay = 2.0, pos = {76, 107}, layer = 2, effect_id = 20004, dx = 0,dy = 30,is_forever = true},	--下雨特效
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={1802,2062}, speed=250, dur=1 },	
	   		{ event='talk', delay = 0.1 , handle_id = 2, talk='三弟！三弟！', dur=2 },
	    },

	    --刘縯回头和邓晨说话
	    {
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1802,2062}, speed=250, dur=0.1 },	
	   		{ event='talk', delay = 0.3 , handle_id = 2, talk='你还说他办事沉稳周全，看他，哪有沉稳的样子。', dur=2 },
	    },

	},

	--============================================wuwenbin  主线任务 剧情5 end  =====================================----

	--============================================wuwenbin  主线任务 剧情6 start  =====================================----

	-- 轻薄官婢 
	['juqing-ux006'] = {

	   	--创建角色，丽华，马武，王常，丁柔，幼女及一群官兵
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={2800,1588}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=47, pos={2802,1680}, dir=7, speed=340, name_color=0xffffff, name="马武", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=7, pos={2870,1642}, dir=7, speed=340, name_color=0xffffff, name="王常", },

	   		{ event='createActor', delay=0.1, handle_id = 4, body=42, pos={2200,1104}, dir=6, speed=340, name_color=0xffffff, name="丁柔", },   
	   		{ event='createActor', delay=0.1, handle_id = 5, body=41, pos={2034,1042}, dir=3, speed=340, name_color=0xffffff, name="幼女", }, 
	   		{ event='createActor', delay=0.1, handle_id = 6, body=41, pos={1940,1104}, dir=1, speed=340, name_color=0xffffff, name="官婢", },   	
	   		{ event='createActor', delay=0.1, handle_id = 7, body=41, pos={1968,1162}, dir=1, speed=340, name_color=0xffffff, name="官婢", }, 

	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={2068,1132}, dir=7, speed=340, name_color=0xffffff, name="新军官兵", },	--官兵1，下方官兵
	   		{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={2134,1104}, dir=7, speed=340, name_color=0xffffff, name="新军官兵", },	--官兵2，上方官兵
	   		{ event='createActor', delay=0.1, handle_id = 10, body=25, pos={2132,1168}, dir=7, speed=340, name_color=0xffffff, name="新军兵头", },	--男眷2

	   		{ event='createActor', delay=0.1, handle_id = 20, body=27, pos={1839,1129}, dir=1, speed=340, name_color=0xffffff, name="新军官兵", },	--摆设官兵
	   		{ event='createActor', delay=0.1, handle_id = 21, body=27, pos={1886,1180}, dir=1, speed=340, name_color=0xffffff, name="新军官兵", },	--摆设官兵
	   		{ event='createActor', delay=0.1, handle_id = 22, body=27, pos={2189,984}, dir=5, speed=340, name_color=0xffffff, name="新军官兵", },	--摆设官兵	上面两个
	   		{ event='createActor', delay=0.1, handle_id = 23, body=27, pos={2257,993}, dir=5, speed=340, name_color=0xffffff, name="新军官兵", },	--摆设官兵	上面两个
	    },

	    --初始化镜头
		{
			{ event='init_cimera', delay = 0.1,mx= 2066,my = 1024 },
		},

	    --幼女呼救，丁柔制止
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 5, talk='姐姐救我——', dur=2 },
	    	{ event='talk', delay = 2 , handle_id = 4, talk='别碰她！别碰……', dur=1.5 },

	    	{ event='playAction', delay = 3.3, handle_id=9, action_id=2, dur=1.5, dir=2, loop=false ,once = false},
	    	{ event='talk', delay = 3.3 , handle_id = 9, talk='让你多嘴！', dur=2 },

	    	{ event='playAction', delay = 3.5, handle_id=4, action_id=4, dur=1.5, dir=2, loop=false ,once = true},
	    	-- { event='talk', delay = 3.6 , handle_id = 4, talk='啊——', dur=1.5 },
	    	{ event='talk', delay = 3.3 , handle_id = 5, talk='姐姐！呜呜呜', dur=2 ,emote = {a= 46}},
	    },

	    --官兵继续围堵幼女
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 5, talk='[a]', dur=1.5 ,emote = {a= 41}},
	    	{ event='talk', delay = 0.1 , handle_id = 8, talk='[a]', dur=1.5 ,emote = {a= 26}},
	    	{ event='talk', delay = 0.1 , handle_id = 9, talk='[a]', dur=1.5 ,emote = {a= 26}},

	    	{ event='move', delay= 0.1, handle_id=5, end_dir=3, pos={2004,1008}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 0.1, handle_id=8, end_dir=7, pos={2002,1066}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 0.1, handle_id=9, end_dir=7, pos={2076,1034}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=7, pos={2200,1104}, speed=250, dur=1.5 },

	    	{ event='talk', delay = 0.1 , handle_id = 6, talk='[a]', dur=1.5 ,emote = {a= 23}},
	    	{ event='talk', delay = 0.1 , handle_id = 7, talk='[a]', dur=1.5 ,emote = {a= 23}},
	    },

	    --丁柔求情，被兵头盯上
	    {
	    	{ event='move', delay= 1.8, handle_id=4, end_dir=5, pos={2200,1104}, speed=250, dur=1.5 },
	    	{ event='talk', delay = 0.1 , handle_id = 10, talk='喂，可别给玩死了，还得交差的。', dur=1.8 },
	    	{ event='talk', delay = 2 , handle_id = 4, talk='军爷开恩，她还小，放过她吧。', dur=2 },

	    	{ event='move', delay= 4.1, handle_id=22, end_dir=5, pos={2216,1021}, speed=250, dur=1.5 },
	    	{ event='move', delay= 4.1, handle_id=23, end_dir=5, pos={2296,1049}, speed=250, dur=1.5 },
	    	{ event='move', delay= 4.1, handle_id=10, end_dir=1, pos={2152,1144}, speed=250, dur=2 },
	    	{ event='talk', delay = 4.1 , handle_id = 10, talk='你倒不小了，陪爷玩玩吧！啊哈哈哈……', dur=1.5},

	    	{ event='move', delay= 4.1, handle_id=4, end_dir=5, pos={2228,1080}, speed=250, dur=2 },
	    	{ event='talk', delay = 5.5 , handle_id = 4, talk='救……救命啊……', dur=1.5 },
	    },	

	    --镜头移动，丁柔幼女呼救
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={2858,1584} , sdur=0.1, dur = 1,style = '',backtime=1},
	    	{ event = 'showTopTalk', delay=0.5, dialog_id='ux6_1',dialog_time=1.5 }, 
	    },

	    --丽华意欲相救，痛斥马王懦夫
	    {
	    	{ event='talk', delay = 0.1 , handle_id = 1, talk='畜生！！', dur=1.5 },
	    	{ event='move', delay= 1.6, handle_id=1, end_dir=3, pos={2800,1588}, speed=250, dur=0.1 },	
	    	{ event='talk', delay = 1.7 , handle_id = 1, talk='你们是不是男人！救救她们啊！', dur=2.5 },
	    	{ event='talk', delay = 1.7 , handle_id = 2, talk='[a]', dur=2.5 ,emote = {a= 38}},
	    	{ event='talk', delay = 1.7 , handle_id = 3, talk='[a]', dur=2.5 ,emote = {a= 38}},
	    	{ event='talk', delay = 4.3 , handle_id = 1, talk='亏你们还要投奔义军？懦夫！', dur=2 },	
	    	{ event='playAction', delay = 4.3, handle_id=1, action_id=2, dur=1.5, dir=3, loop=false ,once = false},
	    },

	},

	--============================================wuwenbin  主线任务 剧情6 end  =====================================----

	--============================================lixin  主线任务 剧情7  start  =====================================----

	--丁柔落水
	--演员表 1 阴丽华  2 丁柔 3-5 士兵   6 冯异  7~9 士兵
	['juqing-ux007'] = 
	{
	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2352,my = 1008 },
	    	{ event='createActor', delay=0.1, handle_id = 2, body=42, pos={2352,1008}, dir=5, speed=340, name_color=0xffffff, name="丁柔"},
	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={2321,1204}, dir=1, speed=340, name_color=0xffffff, name="阴丽华"},
	    },
	    --丁柔和阴丽华BB
	    {
	    	{ event='move', delay= 2.6, handle_id=1, end_dir=1, pos={2305,1086}, speed=300, dur=1 },
	    	{ event='talk', delay=1, handle_id=2, talk='丽华妹妹你别管我了，快逃吧。', dur=1.5 },
	    	{ event='talk', delay=2.6, handle_id=1, talk='不，我是新野阴家的阴丽华，我可以保护你！跟我走。', dur=3},
	    	{ event='talk', delay=5.7, handle_id=2, talk='[a]', dur=1.5,emote ={ a=48} },
	    },   
	    --前置&创建官兵
	    {
			{ event ='showTopTalk', delay=0.1, dialog_id='ux7_1', dialog_time=1.5 },
			{ event='createActor', delay=0.1, handle_id = 3, body=27, pos={2545,2130}, dir=1, speed=340, name_color=0xffffff, name="新军官兵"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=28, pos={2641,2130}, dir=1, speed=340, name_color=0xffffff, name="新军兵头"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={2671,2194}, dir=1, speed=340, name_color=0xffffff, name="新军官兵"},
	    },
	    --镜头移动，官兵追来
	    {
	    	{ event ='camera', delay = 0.1, sdur=2, dur = 0.5, c_topox = {2767,1800}, style = '',backtime=1},
	    	{ event='move', delay= 0.4, handle_id=3, end_dir=1, pos={2709,1847}, speed=300, dur=1 },
	    	{ event='move', delay= 0.4, handle_id=4, end_dir=1, pos={2801,1811}, speed=300, dur=1 },
	    	{ event='move', delay= 0.4, handle_id=5, end_dir=1, pos={2863,1843}, speed=300, dur=1 },
	    	{ event ='camera', delay = 1.8, sdur=0.5, dur = 1, c_topox = {2352,950}, style = '',backtime=1},
		},
		--阴丽华和丁柔再BB
		{
	    	{ event='talk', delay=0.1, handle_id=2, talk='[a]你快走！', dur=1.5,emote={a=41}},
	    	{ event='talk', delay=2.6, handle_id=1, talk='我们一起走！', dur=1.5},
	    	{ event='talk', delay=4.7, handle_id=2, talk='[a]不行，两人一起，谁都跑不了！你往那边，快走啊！', dur=2.5,emote={a=28} },
	    	{ event='talk', delay=6.8, handle_id=1, talk='好吧，保重……', dur=1.5},

	    	--杀了士兵一会用
	    	{ event='kill', delay=0.1, handle_id=3},  
	   		{ event='kill', delay=0.1, handle_id=4}, 
	   		{ event='kill', delay=0.1, handle_id=5}, 
		},
		--阴丽华就这么跑了····
		{
			{ event='move', delay= 0, handle_id=1, end_dir=1, pos={3025,911}, speed=300, dur=2 },

		},
		--官兵来了
		{
			{ event='createActor', delay=0.1, handle_id = 3, body=27, pos={2644,1426}, dir=7, speed=340, name_color=0xffffff, name="新军官兵"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=28, pos={2770,1393}, dir=7, speed=340, name_color=0xffffff, name="新军兵头"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={2864,1358}, dir=7, speed=340, name_color=0xffffff, name="新军官兵"},

	   		{ event='move', delay= 0.2, handle_id=3, end_dir=1, pos={2258,1044}, speed=300, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=4, end_dir=1, pos={2416,1072}, speed=300, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=5, end_dir=7, pos={2513,1040}, speed=300, dur=1 },
	   		{ event='talk', delay=0.2, handle_id=4, talk='还想跑？抓住她！', dur=1.5},
		},
		--丁柔跳崖
		{
			--{ event ='camera', delay = 0.1, target_id= 2, sdur=0.1, dur = 0.9,style = 'follow',backtime=1},
			{ event ='camera', delay = 0.1, sdur=2, dur = 1, c_topox = {2414,658}, style = '',backtime=1},
			{ event='move', delay= 0, handle_id=2, end_dir=3, pos={2352,1008}, speed=300, dur=0.4 },
			{ event='talk', delay=0, handle_id=2, talk='!!!', dur=1.5},
			{ event='move', delay= 0.5, handle_id=2, end_dir=7, pos={2414,658}, speed=300, dur=1.5 },
			{ event = 'jump', delay= 2.3, handle_id= 2, dir=1, pos={2378,533}, speed=200, dur=1, dir = 1, end_dir=1 },
			{ event='kill', delay=2.8, handle_id=2}, 
		},
		--拉回去官兵那
		{
			{ event ='camera', delay = 0.1, sdur=1, dur = 0.5, c_topox = {2352,950}, style = '',backtime=1},
	   		{ event='move', delay= 0.2, handle_id=3, end_dir=1, pos={2258,950}, speed=200, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=4, end_dir=7, pos={2416,970}, speed=200, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=5, end_dir=7, pos={2513,940}, speed=200, dur=1 },
	   		{ event='talk', delay=0.5, handle_id=3, talk='!!!', dur=1},
	   		{ event='talk', delay=0.5, handle_id=4, talk='!!!', dur=1},
	   		{ event='talk', delay=0.5, handle_id=5, talk='!!!', dur=1},

	   		{ event='move', delay= 1.5, handle_id=3, end_dir=3, pos={2258,950}, speed=200, dur=1 },
	   		{ event='move', delay= 1.5, handle_id=5, end_dir=5, pos={2513,940}, speed=200, dur=1 },
	   		{ event='talk', delay=1.6, handle_id=3, talk='老大，还救么？', dur=1.5},
	   		{ event='talk', delay=3.3, handle_id=4, talk='救个屁！你傻啊？回去吧，就说她死了。', dur=2},
	   		{ event='talk', delay=5.5, handle_id=3, talk='是！', dur=1.5},
	   		{ event='talk', delay=5.5, handle_id=5, talk='是！', dur=1.5},

			{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={1136,979}, dir=3, speed=340, name_color=0xffffff, name="官兵"},
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={1009,1011}, dir=3, speed=340, name_color=0xffffff, name="官兵"},
	   		{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={1075,880}, dir=3, speed=340, name_color=0xffffff, name="官兵"},
	   		-- { event='createActor', delay=0.1, handle_id = 6, body=34, pos={1232,1009}, dir=3, speed=340, name_color=0xffffff, name="冯异"},	
	   		{ event="createSpEntity",delay=0.1, handle_id=6, name="34",name_color=0xffffff,actor_name="冯异", action_id=5, dir=3, pos={1232,1009}},   		
		},

		--冯异装B
		{
			{ event ='camera', delay = 0.1, target_id= 6, sdur=0, dur = 0.9,style = 'follow',backtime=1},
			{ event='talk', delay=1, handle_id=6, talk='♪♮♫♪♬♭♩♪♪~', dur=2},
			{ event='playAction', delay = 0.1, handle_id=6, action_id=5, dur=2, dir=3, loop=true ,once = false},
			{ event ='showTopTalk', delay=2, dialog_id='ux7_2', dialog_time=2},
			{ event='talk', delay=4, handle_id=6, talk='？？？', dur=1.5},
			{ event='move', delay= 4, handle_id=6, end_dir=2, pos={1326,1146}, speed=200, dur=1 },
			{ event='move', delay= 5, handle_id=6, end_dir=5, pos={1326,1146}, speed=200, dur=1 },	
			{ event='move', delay= 6, handle_id=6, end_dir=1, pos={1326,1146}, speed=200, dur=1 },	
			{ event='talk', delay=6.5, handle_id=6, talk='河中有人呼救，救人！', dur=1.5},	
		},

	},
	--============================================lixin  主线任务 剧情7 end  =====================================----

	--============================================luyao  主线任务 剧情8 start  =====================================----
--哀鸿遍野
	['juqing-ux008'] = 
--1-6官婢  7丽华  8马武  9王常  10成丹	
	{
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2780,my = 1537 },


	   		{ event='createActor', delay=0.1, handle_id = 1, body=2, pos={2726,1510}, dir=1, speed=340, name_color=0xffffff, name="官婢", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=37, pos={2200,1140}, dir=2, speed=340, name_color=0xffffff, name="官婢", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=2, pos={2369,905}, dir=3, speed=340, name_color=0xffffff, name="官婢", },
	   		{ event='createActor', delay=0.1, handle_id = 4, body=37, pos={2484,824 }, dir=5, speed=340, name_color=0xffffff, name="官婢", }, 
	   		{ event='createActor', delay=0.1, handle_id = 5, body=2, pos={2620,751}, dir=2, speed=340, name_color=0xffffff, name="官婢", },
	   		{ event='createActor', delay=0.1, handle_id = 6, body=37, pos={3010,878}, dir=7, speed=340, name_color=0xffffff, name="官婢", }, 

	    	{ event='playAction', delay = 0.2, handle_id=1, action_id=4, dur=1.5, dir=1, loop=false ,once = true},	 
	    	{ event='playAction', delay = 0.2, handle_id=2, action_id=4, dur=1.5, dir=2, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=3, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=4, action_id=4, dur=1.5, dir=5, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=5, action_id=4, dur=1.5, dir=2, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=6, action_id=4, dur=1.5, dir=7, loop=false ,once = true},	

			{ event='playBgMusic', delay=0.5, id = 2 ,loop = true},	    	

	    	{ event = 'camera', delay = 1, c_topox={2446,1003} , sdur=2, dur = 1.5,style = '',backtime=1},
	    	{ event = 'camera', delay = 3, c_topox={2615,720} , sdur=2, dur = 1.5,style = '',backtime=1},
	    	{ event = 'camera', delay = 5, c_topox={2500,1097} , sdur=2, dur = 1.5,style = '',backtime=1},	    	

	   		{ event='createActor', delay=5, handle_id = 7, body=6, pos={2657,1433}, dir=7, speed=340, name_color=0xffffff, name="丽华", }, 
	   		{ event='createActor', delay=5, handle_id = 8, body=47, pos={2828,1431}, dir=7, speed=340, name_color=0xffffff, name="马武", },
	   		{ event='createActor', delay=5, handle_id = 9, body=7, pos={2740,1570}, dir=7, speed=340, name_color=0xffffff, name="王常", }, 
	   		{ event='createActor', delay=5, handle_id = 10, body=29, pos={2862,1496}, dir=7, speed=340, name_color=0xffffff, name="成丹", }, 		

			{ event='move', delay= 5.5, handle_id=7, end_dir=7, pos={2516,1117}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 5.5, handle_id=8, end_dir=7, pos={2513,1236}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 5.5, handle_id=9, end_dir=7, pos={2591,1175}, speed=250, dur=1.5 },
	    	{ event='move', delay= 5.5, handle_id=10, end_dir=7, pos={2666,1073}, speed=250, dur=1.5 },

	   	},

		{

	    	{ event='move', delay= 0.1, handle_id=8, end_dir=3, pos={2513,1236}, speed=250, dur=1.5 },
	    	{ event='move', delay= 0.5, handle_id=8, end_dir=1, pos={2513,1236}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 1, handle_id=8, end_dir=7, pos={2513,1236}, speed=250, dur=1.5 },		    	    	
			{ event='talk', delay = 1.5 , handle_id = 8, talk='这帮畜生！', dur=2 },

			{ event='talk', delay = 3.5 , handle_id = 10, talk='哎！', dur=2 },

			{ event='talk', delay = 5.5 , handle_id = 9, talk='这就是你所谓的仗义而为？你真以为帮了她们？你看看，看清楚！', dur=2 },

			{ event='talk', delay = 7.5 , handle_id = 7, talk='[a] 为什么？', emote={a=48}, dur=2 },

			{ event='talk', delay = 9.5 , handle_id = 9, talk='[a] 为什么？官婢逃了，官兵怕被问责，全杀掉就能推到咱们头上了！',emote={a=37}, dur=2 },
		},  
	},

	--============================================luyao  主线任务 剧情8 end  =====================================----


	--============================================wuwenbin  主线任务 剧情9 start  =====================================----

	-- 救命之恩 
	['juqing-ux009'] = {

	   	--创建角色，丽华，刘秀，邓禹，马武
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={495+300,1109-60}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={459+300,1108-60}, dir=7, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={434+300,1072-60}, dir=7, speed=340, name_color=0xffffff, name="邓禹", },
	   		{ event='createActor', delay=0.1, handle_id = 4, body=47, pos={174+300,1201-60}, dir=3, speed=340, name_color=0xffffff, name="马武", }, 

	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={1259,1008}, dir=3, speed=340, name_color=0xffffff, name="官兵", }, 	--官兵1，下方官兵
	   		{ event='createActor', delay=0.1, handle_id = 6, body=27, pos={1620,1362}, dir=1, speed=340, name_color=0xffffff, name="官兵", },   	--官兵2，中间官兵
	   		{ event='playAction', delay = 0.2, handle_id=4, action_id=4, dur=0.5, dir=7, loop=false ,once = true},	--官兵1动作
			{ event='init_cimera', delay = 0.1,mx= 130,my = 1100 },
			{ event = 'changeRGBA',delay=0.1,dur=0.1,txt = "几年前，长安……"},

			{ event='move', delay= 1.5, handle_id=1, end_dir=7, pos={234+300,1265-60}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 1.5, handle_id=2, end_dir=1, pos={131+300,1266-60}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 1.5, handle_id=3, end_dir=6, pos={261+300,1199-60}, speed=250, dur=1.5 },	
		},

	    --马武呼救,丽华一行走到马武旁边
	    {
	    	{ event='talk', delay = 0.8 , handle_id = 4, talk='啊……救……救我……', dur=2 },
	    },

	    --传来官兵的声音
		{
			{ event ='showTopTalk', delay=0.1, dialog_id='ux9_1', dialog_time=1.5},	
		},

		{
			{ event='talk', delay= 0.1, handle_id=1, talk='！！！', dur=1.5},
			{ event='talk', delay= 0.1, handle_id=2, talk='！！！', dur=1.5},
			{ event='talk', delay= 0.1, handle_id=3, talk='！！！', dur=1.5},
			{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={234+300,1265-60}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={131+300,1266-60}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=3, pos={261+300,1199-60}, speed=250, dur=1.5 },

			{ event='move', delay= 1.5, handle_id=1, end_dir=7, pos={234+300,1265-60}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 1.5, handle_id=2, end_dir=1, pos={131+300,1266-60}, speed=250, dur=1.5 },	
	    	{ event='move', delay= 1.5, handle_id=3, end_dir=6, pos={261+300,1199-60}, speed=250, dur=1.5 },

			{ event='talk', delay= 1.8, handle_id=1, talk='快将他藏起来。', dur=2},	
		},

	    --官兵搜捕中
	    {
	    	{ event = 'camera', delay = 0.1, c_topox={1409,1127} , sdur=0.1, dur = 1.2,style = '',backtime=1},

	    	{ event='playAction', delay = 1.2, handle_id=5, action_id=2, dur=1.5, dir=3, loop=false ,once = false},	--官兵1动作
	    	{ event='move', delay= 2, handle_id=5, end_dir=3, pos={1399,1107}, speed=250, dur=1.5 },	--官兵1动作	
	    	{ event='playAction', delay = 3, handle_id=5, action_id=2, dur=1.5, dir=2, loop=false ,once = false},	--官兵1动作
	    	{ event='move', delay= 3.5, handle_id=5, end_dir=3, pos={1295,1197}, speed=250, dur=1.5 },	--官兵1动作
	
			{ event='playAction', delay = 0.3, handle_id=6, action_id=2, dur=1.5, dir=1, loop=false ,once = false},	--官兵2动作
	    	{ event='move', delay= 1.2, handle_id=6, end_dir=1, pos={1484,1259}, speed=250, dur=1.5 },	--官兵2动作	
	    	{ event='playAction', delay = 2.3, handle_id=6, action_id=2, dur=1.5, dir=1, loop=false ,once = false},	--官兵2动作
	    	{ event='move', delay= 3, handle_id=6, end_dir=7, pos={1361,1241}, speed=250, dur=1.5 },	--官兵2动作
	    	-- { event='playAction', delay = 4.3, handle_id=1, action_id=2, dur=1.5, dir=3, loop=false ,once = false},	--官兵2动作

	    	{ event='talk', delay = 4 , handle_id = 6, talk='我这儿没有', dur=2 },
	    	{ event='talk', delay = 6.3 , handle_id = 5, talk='我这边也没找到', dur=2 },

	    },

	    --官兵对话
	    {
	    	{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={920,1487}, dir=1, speed=340, name_color=0xffffff, name="官兵", }, 	--官兵3，上方官兵
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={976,1515}, dir=1, speed=340, name_color=0xffffff, name="官兵", }, 	--官兵4，上方官兵
	   		-- { event='createActor', delay=0.3, handle_id = 4, body=2, pos={171,1211}, dir=3, speed=340, name_color=0xffffff, name="马武", }, 	--跪地马武
	   		-- { event='kill', delay= 0.1, handle_id=4,},	--正常马武消失
	   		{ event='move', delay= 0.5, handle_id=5, end_dir=5, pos={1295,1197}, speed=250, dur=1.5 },	
	   		{ event='move', delay= 0.5, handle_id=6, end_dir=5, pos={1361,1241}, speed=250, dur=1.5 },	
	   		{ event='move', delay= 0.5, handle_id=7, end_dir=1, pos={1239,1224}, speed=250, dur=1.5 },	
	   		{ event='move', delay= 0.5, handle_id=8, end_dir=1, pos={1300,1272}, speed=250, dur=1.5 },

	   		{ event='talk', delay = 1.5 , handle_id = 8, talk='我们这边也没有', dur=2 },
	    },

	    --官兵去往其他地方
	    {
	    	{ event='talk', delay = 0.5 , handle_id = 6, talk='走，去其他地方搜去！', dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=5, end_dir=5, pos={1369,1715}, speed=250, dur=1.5 },	--官兵1动作	
	   		{ event='move', delay= 1.5, handle_id=6, end_dir=5, pos={1369,1715}, speed=250, dur=1.5 },	--官兵1动作	
	   		{ event='move', delay= 1.5, handle_id=7, end_dir=1, pos={1369,1715}, speed=250, dur=1.5 },	--官兵1动作	
	   		{ event='move', delay= 1.5, handle_id=8, end_dir=1, pos={1369,1715}, speed=250, dur=1.5 },	--官兵1动作	
	   		-- { event = 'camera', delay = 1.5, target_id =8, sdur=0.1, dur = 0.5,style = 'follow',backtime=1},
	   		{ event = 'camera', delay = 2.5, c_topox={130,1100} , sdur=0.1, dur = 1,style = '',backtime=1},

	   		-- { event='kill', delay= 0.1, handle_id=100,},	--正常马武消失
	    },

	    --马武跪地谢恩
	     {
	    	{ event='talk', delay = 0.1 , handle_id = 2, talk='他们走了。', dur=1 },
	    	{ event='talk', delay = 1 , handle_id = 1, talk='壮士醒醒', dur=1 },

	    	{ event='move', delay= 2.5, handle_id=4, end_dir=3, pos={174+300,1201-60}, speed=250, dur=1.5 },	--官兵1动作	

	    	{ event='talk', delay = 3 , handle_id = 3, talk='你就是他们要找的刺客？', dur=2 },

	   		{ event='playAction', delay = 5, handle_id=4, action_id=0, dur=1.5, dir=3, loop=false ,once = true},	--官兵1动作
	   		{ event='talk', delay = 5 , handle_id = 4, talk='多谢三位的救命之恩，在下这就告辞了。', dur=2.5 },
	    },
	},

	--============================================wuwenbin  主线任务 剧情9 end  =====================================----

	--============================================wuwenbin  主线任务 剧情10 start  =====================================----

	--丽华记忆复苏
	['juqing-ux010'] = 
	{
	    --创建角色，丽华，刘秀，阴识
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1734,2833}, dir=5, speed=340, name_color=0xffffff, name="阴丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={1445,2967}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=30, pos={2249,2772}, dir=5, speed=340, name_color=0xffffff, name="阴识"},
	    },

	    --初始化镜头
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 1650,my = 2764 },

	    },

	    --刘秀丽华隔空喊话
	    {
	    	{ event='talk', delay=0.1, handle_id=1, talk='你是刘家大哥吗？', dur=2 , },
	    	{ event='talk', delay=2.4, handle_id=2, talk='[a]', dur=1.5, emote = {a= 31}},
	    	{ event='talk', delay=4.2, handle_id=1, talk='不是刘家大哥？那前天晚上你……？', dur=2, },
	    },

	    --阴识进入镜头
	    {
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=5, pos={1825,2762}, speed=300, dur=1.5 },
	    	{ event='talk', delay=0.5, handle_id=3, talk='丽华！', dur=2 , },

	    	{ event='move', delay= 1.5, handle_id=1, end_dir=1, pos={1734,2833}, speed=300, dur=1.5 },
	    	{ event='talk', delay=1.5, handle_id=1, talk='大哥？你怎么来了？', dur=2 ,},
	    	{ event='talk', delay=3.8, handle_id=3, talk='我来能干什么，叫你回家啊。', dur=2.5 ,},
	    },   

	    --丽华转身，跟刘秀说话后走出镜头
	    {
			{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={1734,2833}, speed=300, dur=1.5 },
			{ event='talk', delay=0.5, handle_id=1, talk='那麻烦你帮我跟刘家大哥说一声，谢谢他那天晚上救了我。', dur=3,},
			{ event='talk', delay=3.8, handle_id=3, talk='快走吧。', dur=1.5,},

			{ event='move', delay= 5, handle_id=1, end_dir=5, pos={2270,2603}, speed=300, dur=1.5 },
			{ event='move', delay= 5, handle_id=3, end_dir=5, pos={2315,2641}, speed=300, dur=1.5 },
	    },

	    --刘秀追上
	    {
			
			{ event='talk', delay=0.1, handle_id=2, talk='等一下……', dur=1.5,},

			{ event='move', delay= 1.5, handle_id=2, end_dir=1, pos={2186,2636}, speed=300, dur = 4 },
			{ event = 'camera', delay = 0.1, target_id = 2, sdur=0.1, dur = 1,style = 'follow',backtime=1},
			{ event='talk', delay = 2, handle_id=2, talk='等等', dur=2,},
		},

		--丽华阴识停下，转身
		{
			{ event = 'camera', delay = 0.1, target_id = 1, sdur=0.1, dur = 0.5,style = 'follow',backtime=1},
			{ event='talk', delay=0.1, handle_id=2, talk='这个给你。', dur=1.5,},
			{ event='talk', delay=1.8, handle_id=1, talk='给我的？一束稻穗…？', dur=2,},
			{ event='talk', delay=4.1, handle_id=2, talk='丽华，后会有期！', dur=2,},
			{ event='talk', delay=6.5, handle_id=3, talk='走吧！', dur=1.5,},

	    },

	    --丽华阴识停下，转身
		{
			{ event = 'camera', delay = 4, c_topox = {2173,1997}, sdur=0.1, dur = 0.5,style = '',backtime=1},
			{ event='move', delay= 0.1, handle_id=3, end_dir=3, pos={2128,2035}, speed=300, dur=1.5 },
			{ event='move', delay= 0.5, handle_id=1, end_dir=7, pos={2194,2063}, speed=300, dur=1.5 },

			{ event='talk', delay=4, handle_id=1, talk='大哥等等，救我的刘家大哥叫什么名字啊。', dur=2.5,},
			{ event='talk', delay=6.8, handle_id=3, talk='刘縯刘伯升', dur=2,},
			{ event='talk', delay=9, handle_id=1, talk='那刘秀是谁？', dur=2,},
			{ event='talk', delay=11.3, handle_id=3, talk='唉…刚才那个人就是刘秀刘文叔。', dur=2.5,},
			{ event='talk', delay=14.1, handle_id=1, talk='刘文叔？', dur=1.4,},
			{ event='talk', delay=15.7, handle_id=1, talk='文叔哥哥……？他就是文叔哥哥……？[a]', dur=2.5,emote = {a= 33}},
	    },

	},

	--============================================wuwenbin  主线任务 剧情10  end   =====================================----


		--============================================luyao  主线任务 剧情11 start  =====================================----
--哀鸿遍野
	['juqing-ux011'] = 	
	--1阴丽华  2阴识   3阴识  4邓婵
	{
	

	    {

	    	{ event = 'camera', delay = 0.5, c_topox={1709,832} , sdur=0.3, dur = 0.5,style = '',backtime=1},

	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1508,712}, dir=3, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id = 2, body=30, pos={1694,846}, dir=7, speed=340, name_color=0xffffff, name="阴识", },

			{ event='move', delay= 0.2, handle_id=1, end_dir=3, pos={1605,838}, speed=250, dur=1.5 },	

			{ event='talk', delay = 1.5 , handle_id = 1, talk='大哥，不好了，表姐不愿下嫁，去了碧水河寻死……', dur=2 },
			{ event='talk', delay = 3.5 , handle_id = 2, talk='婵儿！', dur=2 },

			{ event='move', delay= 4, handle_id=1, end_dir=6, pos={1605,838}, speed=250, dur=1.5 },	
			{ event='move', delay= 4, handle_id=2, end_dir=1, pos={1251,791}, speed=250, dur=1.5 },	

			{ event='kill', delay=5.5, handle_id=2}, 			
			{ event='kill', delay=5.5, handle_id=1}, 
	   	},
 	
		{

			{ event = 'camera', delay = 0.1, c_topox={1002,1107} , sdur=0, dur = 0.1,style = '',backtime=1},

	   		{ event='createActor', delay=0.2, handle_id = 3, body=30, pos={1133,914}, dir=3, speed=340, name_color=0xffffff, name="阴识", },
	   		--{ event='createActor', delay=0.1, handle_id = 4, body=10, pos={902,1227}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },
			{ event="createSpEntity",delay=0.1, handle_id=4, name="10",name_color=0xffffff,actor_name="邓婵", action_id=5, dir=5, pos={902,1227}},		   		
			{ event='move', delay = 0.3, handle_id=3, end_dir=5, pos={950,1170}, speed=250, dur=1.5 },	
		},

		{
			{ event='playBgMusic', delay=0.1, id = 2 ,loop = true},

			{ event='talk', delay = 0.5 , handle_id = 3, talk='婵儿……', dur=1.5 },
			{ event='move', delay = 1   , handle_id=4, end_dir=1, pos={902,1227}, speed=250, dur=0.2},

	   		--{ event='playAction', delay = 1.5, handle_id=4, action_id=5, dur=1.5, dir=1, loop=false ,},

			{ event='talk', delay = 2.5 , handle_id = 3, talk='这里风寒露重，随我回去吧。', dur=2 },
			{ event='talk', delay = 5.5 , handle_id = 4, talk='我回去之后，就要嫁与旁人，与表兄再难有相见之日了。', dur=2 },
			{ event='talk', delay = 8.5 , handle_id = 3, talk='哎……公孙是宛城望族，与邓家门第相当。', dur=2},
			{ event='talk', delay = 11.5 , handle_id = 3, talk='你嫁过去，为人正妻，将来生儿育女，一世尽享安乐。', dur=2 },
			{ event='talk', delay = 14.5 , handle_id = 4, talk='可是我只想与喜欢的人相守……', dur=2 },
			{ event='talk', delay = 17.5 , handle_id = 4, talk='什么名分地位，我都不在乎！', dur=2 },
			{ event='talk', delay = 20.5 , handle_id = 3, talk='你可以不在乎，邓家不能不在乎！', dur=2 },
		},

		{
			{ event='showTopTalk', delay=0.1, dialog_id="ux11_1" ,dialog_time = 3},
		},

		{
			{ event='talk', delay = 0.1 , handle_id = 3, talk='别为难我了，回去吧。', dur=2 },

			{ event = 'camera', delay = 2.1, c_topox={1084,977} , sdur=0.5, dur = 0.5,style = '',backtime=1},		
			{ event='move', delay = 2.1, handle_id=3, end_dir=1, pos={1000,1070}, speed=340, dur=2},
			{ event='move', delay = 2.2, handle_id=4, end_dir=5, pos={1080,1020}, speed=150, dur=2},

			{ event='talk', delay = 4 , handle_id = 4, talk='[a]可是婵儿心里，只有表兄一人……', emote={a=46}, dur=2 },
			{ event='talk', delay = 7 , handle_id = 4, talk='若要我嫁给旁人，我情愿一死！', dur=2 },
			{ event='talk', delay = 10 , handle_id = 4, talk='表兄，若我死了，你是不是才会在意我？', dur=2 },

		},
		{
			{ event='move', delay = 0.1, handle_id=3, end_dir=5, pos={1000,1070}, speed=340, dur=2},

			{ event='talk', delay = 0.1 , handle_id = 3, talk='胡闹，我若不在意你，就不会来寻你？', dur=2.1 },
			{ event='talk', delay = 3 , handle_id = 4, talk='真的？你是在意我的……[a]', emote={a=16}, dur=2 },	

			{ event='showTopTalk', delay=5.5, dialog_id="ux11_2" ,dialog_time = 3},	

			{ event='move', delay = 8, handle_id=3, end_dir=1, pos={1000,1070}, speed=340, dur=2},
			{ event='talk', delay = 8 , handle_id = 3, talk='不，婵儿……', dur=1.8 },
			{ event='talk', delay = 10 , handle_id = 3, talk='我对你的在意，仅仅是……我把你视为我的妹妹。', dur=2.2 },
		},
		{						
			{ event='talk', delay = 0.1 , handle_id = 3, talk='别在胡思乱想了，也别再为难我了，跟我回家。', dur=2.2 },	

			{ event='talk', delay = 3 , handle_id = 4, talk='我不要回去！不要回去……', dur=2 },

	   		{ event='playAction', delay = 3.2, handle_id=4, action_id=2, dur=1.5, dir=5, loop=false ,},	
	   		{ event='playAction', delay = 3.5, handle_id=3, action_id=3, dur=1.5, dir=1, loop=false ,},	
			{ event='talk', delay = 4 , handle_id = 3, talk='啊……', dur=1.5 },
            { event='moveEffect', handle_id=101, delay=4, effect_id=20018, pos1={31,31}, pos2={29,30}, pos3={26,33}, dur=0.5, m_dur=0.2}, --丢玉佩
		--	{ event='effect', handle_id=101,  delay = 17.2 , pos={852,1069}, effect_id=20002, is_forever = true},
		},
		{	
			{ event='talk', delay = 0.1 , handle_id = 4, talk='玉佩……？原来你一直在骗我……', dur=2 },
			{ event='talk', delay = 3 , handle_id = 4, talk='其实你心里是在乎我的，对不对？', dur=2 },
			{ event='talk', delay = 6 , handle_id = 4, talk='不然你也不会把我送给你的玉佩一直带在身边！', dur=2 },
			{ event='talk', delay = 9 , handle_id = 3, talk='我……', dur=1.5 },
			{ event='talk', delay = 12 , handle_id = 4, talk='表兄……我求求你，我真的只想和你在一起。', dur=2 },

			{ event='move', delay = 14, handle_id=3, end_dir=1, pos={1020,1050}, speed=250, dur=2},

			{ event='talk', delay = 15 , handle_id = 3, talk='婵儿……', dur=1.8 },			

			{ event='showTopTalk', delay=17, dialog_id="ux11_3" ,dialog_time = 3},	
		},
		{
			{ event='move', delay = 0.1, handle_id=4, end_dir=5, pos={1050,1050}, speed=250, dur=2},

            { event='effect', handle_id=102, target_id=4, delay =0.5 , pos={20,150}, effect_id=20009, is_forever = true},--冒心心

			{ event='showTopTalk', delay=3, dialog_id="ux11_4" ,dialog_time = 3},	
	   		{ event = 'removeEffect', delay = 5.5, handle_id=102, effect_id=20009},

			{ event='move', delay = 6, handle_id=3, end_dir=7, pos={852,1089}, speed=250, dur=2},
	   		{ event = 'removeEffect', delay = 7.5, handle_id=101, effect_id=20018},
			{ event='move', delay = 8, handle_id=3, end_dir=1, pos={1000,1080}, speed=250, dur=2},	   		
		},
		{
			{ event='talk', delay = 0.1 , handle_id = 3, talk='这个玉佩的确做得十分精美，我也非常喜欢。', dur=2 },
			{ event='talk', delay = 3 , handle_id = 3, talk='可我仅仅将它视为妹妹送给哥哥的礼物。', dur=2 },
			{ event='talk', delay = 6 , handle_id = 3, talk='别无它想，如果让你产生了什么误会的话。', dur=2 },
			{ event='talk', delay = 9 , handle_id = 3, talk='今天我也只能物归原主了。', dur=2 },
			{ event='talk', delay = 12 , handle_id = 4, talk='！！！', dur=2 },
		},
		{
	   		{ event='createParticle', id =1 ,delay = 0.1,pos={1071,1020},scale = 1,path= "particle/xueqiu.plist" },	
	   		{ event='createParticle', id =2 ,delay = 0.1,pos={1070,1020},scale = 1,path= "particle/xuehue.plist" },	

	   		{ event='createParticle', id =3 ,delay = 0.1,pos={583,784},scale = 1,path= "particle/xueqiu.plist" },	
	   		{ event='createParticle', id =4 ,delay = 0.1,pos={583,784},scale = 1,path= "particle/xuehue.plist" },

			{ event='showTopTalk', delay=0.1, dialog_id="ux11_5" ,dialog_time = 3},

			{ event='talk', delay = 3 , handle_id = 4, talk='不用了……表兄将它扔了吧！', dur=2 },

	   		{ event='playAction', delay = 5, handle_id=4, action_id=2, dur=1.5, dir=5, loop=false ,},

			{ event = 'camera', delay = 5.5, c_topox={771,1087} , sdur=0.5, dur = 0.5,style = '',backtime=1},	

            { event='moveEffect', handle_id=103, delay=5.2, effect_id=20018, pos1={31, 33}, pos2={25,34}, pos3={24,38}, dur=1, m_dur=1}, --丢玉佩
		--	{ event='effect', handle_id=103,  delay = 6 , pos={788,1245}, effect_id=20002, is_forever = true},
	   		{ event = 'removeEffect', delay = 7, handle_id=103, effect_id=20018},

			{ event = 'camera', delay = 7.5, c_topox={769,912} , sdur=0.5, dur = 0.5,style = '',backtime=1},	

			{ event='move', delay = 8, handle_id=4, end_dir=7, pos={842,946}, speed=340, dur=2},
			{ event='move', delay = 9, handle_id=3, end_dir=7, pos={950,1020}, speed=250, dur=2},

			{ event='talk', delay = 10 , handle_id = 3, talk='婵儿！我……', dur=1.8 },
			{ event='move', delay = 12, handle_id=4, end_dir=3, pos={842,946}, speed=340, dur=2},			
			{ event='talk', delay = 12.5 , handle_id = 4, talk='请表兄放心，婵儿不会再去寻死。', dur=2 },
			{ event='talk', delay = 15.5 , handle_id = 4, talk='婵儿……就此拜别！', dur=1.5 },
	   		{ event='playAction', delay = 16.5, handle_id=4, action_id=5, dur=1.5, dir=3, loop=false ,},

			{ event='move', delay = 18, handle_id=4, end_dir=7, pos={398,737}, speed=340, dur=2},
			{ event='kill', delay=21, handle_id=4}, 
			{ event='move', delay = 18.5, handle_id=3, end_dir=7, pos={759,948}, speed=340, dur=2},

			{ event='showTopTalk', delay=19, dialog_id="ux11_6" ,dialog_time = 3},

		},


	},

	--============================================luyao  主线任务 剧情11 end  =====================================----



    --============================================luyao      主线任务 剧情12 start    =====================================----
	['juqing-ux012'] = {	

        --1邓婵  2胭脂  3-4侍妾  5阴丽华

        {
	   		{ event='createActor', delay=0.1, handle_id=1, body=10, pos={3125,2192}, dir=5, speed=340, name_color=0xffffff, name="邓婵", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=41, pos={3221,2130}, dir=5, speed=340, name_color=0xffffff, name="胭脂", },
        },
		{
	   		{ event='init_cimera', delay = 0.3,mx= 3210,my = 2136 }, 
		},
        {
	   		{ event='createActor', delay=0.1, handle_id=3, body=37, pos={3276,1854}, dir=5, speed=340, name_color=0xffffff, name="侍妾", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=36, pos={3396,1880}, dir=5, speed=340, name_color=0xffffff, name="侍妾", },

			{ event = 'camera', delay = 0.5, c_topox={3261,2000} , sdur=0.5, dur = 0.5,style = '',backtime=1},	

	   		{ event='move', delay = 0.5, handle_id=3, end_dir=5, pos={3145,2030}, speed=340, dur=2},
	   		{ event='move', delay = 0.5, handle_id=4, end_dir=5, pos={3302,2042}, speed=340, dur=2},

			{ event='talk', delay = 2.5 , handle_id = 3, talk='既是行动不便，姐姐就该在房里好好歇着才是，何苦出来碍眼！', dur=2 },

	   		{ event='move', delay = 3.5, handle_id=1, end_dir=1, pos={3125,2192}, speed=340, dur=2},
	   		{ event='move', delay = 3.5, handle_id=2, end_dir=1, pos={3200,2152}, speed=340, dur=2},

			{ event='talk', delay = 4.5 , handle_id = 2, talk='[a]',emote={a=34}, dur=2 },

			{ event='talk', delay = 6.5 , handle_id = 1, talk='[a]我只是出来走走，未想扰了妹妹雅兴，我回去便是。',emote={a=23}, dur=2 },

        },
        {
	   		{ event='move', delay = 0.1, handle_id=1, end_dir=5, pos={3276,2344}, speed=500, dur=2},
	   		{ event='move', delay = 1.2, handle_id=2, end_dir=5, pos={3380,2340}, speed=500, dur=2},

			{ event='talk', delay = 1.1 , handle_id = 3, talk='慢着！', dur=4 },

			{ event = 'camera', delay = 2, c_topox={3247,2295} , sdur=0.5, dur = 0.5,style = '',backtime=1},	

	   		{ event='move', delay = 1.8, handle_id=3, end_dir=5, pos={3164,2162}, speed=340, dur=1.5},
	   		{ event='move', delay = 1.5, handle_id=4, end_dir=5, pos={3250,2162}, speed=340, dur=1.5},

			{ event = 'jump', delay= 2.6, handle_id= 3, dir=5, pos={3114,2290}, speed=200, dur=1, dir = 5, end_dir=5 },
			{ event = 'jump', delay= 2.3, handle_id= 4, dir=5, pos={3200,2300}, speed=200, dur=1, dir = 5, end_dir=5 },			

	   		{ event='move', delay = 3.1, handle_id=3, end_dir=2, pos={3126,2363}, speed=340, dur=2},
	   		{ event='move', delay = 2.8, handle_id=4, end_dir=1, pos={3170,2432}, speed=340, dur=2},

        },

        {
			{ event='talk', delay = 0.1 , handle_id = 3, talk='姐姐这么说，好像是怪妹妹我不让你出门了？', dur=2 },
			{ event='talk', delay = 2.2 , handle_id = 3, talk='夫君已对你无半分情意，若不是看你有孕在身，早就一纸休书将你休了！', dur=3 },	
			{ event='talk', delay = 5.7 , handle_id = 4, talk='所以你别一副受尽委屈的样子，反倒让夫君看见心烦。', dur=2.2 },	
			{ event='talk', delay = 8.2 , handle_id = 1, talk='[a]', emote={a=46}, dur=2 },							
        },

        {
	   		{ event='move', delay = 0.1, handle_id=2, end_dir=5, pos={3241,2379}, speed=340, dur=2},
			{ event='talk', delay = 1.1 , handle_id = 2, talk='夫人有孕在身，大夫说应该常晒太阳，对胎儿多有裨益。', dur=2.2 },
			{ event='talk', delay = 3.6 , handle_id = 2, talk='况且，我家夫人乃一家主母，这家里哪儿不可以去？', dur=2.2 },

	   		{ event='playAction', delay = 6, handle_id=4, action_id=2, dur=1.5, dir=1, loop=false ,},	
	   		{ event='playAction', delay = 6.2, handle_id=2, action_id=3, dur=1.5, dir=5, loop=false ,},

			{ event='talk', delay = 7 , handle_id = 4, talk='[a]大胆贱婢，敢跟我顶嘴！我看你是不想在公孙家待了。', emote={a=24},dur=2.2 },	
			{ event='talk', delay = 9.5 , handle_id = 2, talk='[a]', emote={a=33},dur=1.8 },
			{ event='talk', delay = 11.8 , handle_id = 4, talk='我打死你这小贱婢！', dur=2 },

	   		{ event='playAction', delay = 12.4, handle_id=4, action_id=2, dur=1.5, dir=1, loop=false ,},	
	   		{ event='playAction', delay = 12.5, handle_id=2, action_id=3, dur=1.5, dir=5, loop=false ,},

	   		{ event='playAction', delay = 13.4, handle_id=4, action_id=2, dur=1.5, dir=1, loop=false ,},	
	   		{ event='playAction', delay = 13.5, handle_id=2, action_id=3, dur=1.5, dir=5, loop=false ,},	   					

	   		{ event='createActor', delay=12.1, handle_id=5, body=6, pos={3392,2519}, dir=7, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='move', delay = 12.2, handle_id=5, end_dir=7, pos={3291,2450}, speed=340, dur=2},	

			{ event='talk', delay = 13.1 , handle_id = 5, talk='住手！', dur=1.8 },

	   		{ event='move', delay = 13.5, handle_id=4, end_dir=3, pos={3170,2432}, speed=340, dur=2},			
			{ event='talk', delay = 15.2 , handle_id = 5, talk='一个侍妾，也敢欺负主母！公孙家还有无规矩礼数？', dur=2.2 },	   		   		
        },

        {
	   		{ event='move', delay = 0.1, handle_id=1, end_dir=7, pos={3346,2500}, speed=340, dur=2},
	   		{ event='move', delay = 0.5, handle_id=2, end_dir=7, pos={3400,2445}, speed=340, dur=2},

	   		{ event='move', delay = 0.2, handle_id=3, end_dir=3, pos={3266,2360}, speed=340, dur=2},

			{ event='talk', delay = 2.1 , handle_id = 1, talk='[a]丽华……', emote={a=46},dur=2 },	
			{ event='talk', delay = 4.2 , handle_id = 2, talk='[a]姑娘……', emote={a=46}, dur=2 },
			{ event='talk', delay = 6.3 , handle_id = 3, talk='哪来的疯女子？竟敢在我家撒野！来人哪……', dur=3 },					   		
        },


	    },    

	--============================================luyao      主线任务 剧情12 end      =====================================----




    --============================================ wuwenbin  主线任务 剧情13 start    =====================================----
	['juqing-ux013'] = {	

        --角色前置对白

	    {
	   		{ event='createActor', delay=0.1, handle_id=1, body=6, pos={1138,850}, dir=1, speed=340, name_color=0xffffff, name="阴丽华", },
	   		{ event='createActor', delay=0.1, handle_id=2, body=13, pos={1203,881}, dir=1, speed=340, name_color=0xffffff, name="刘秀", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=23, pos={1335,364}, dir=5, speed=340, name_color=0xffffff, name="蔡少公", },
	   		{ event='createActor', delay=0.1, handle_id=4, body=53, pos={1258,406}, dir=1, speed=340, name_color=0xffffff, name="王寻", },

	   		{ event='createActor', delay=0.1, handle_id=5, body=25, pos={1164,363}, dir=1, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=6, body=25, pos={1197,437}, dir=1, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=7, body=25, pos={1275,472}, dir=1, speed=340, name_color=0xffffff, name="士兵", },
	   		{ event='createActor', delay=0.1, handle_id=8, body=25, pos={1357,459}, dir=1, speed=340, name_color=0xffffff, name="士兵", },

	   		{ event='createActor', delay=0.1, handle_id=30, body=13, pos={3495,461}, dir=5, speed=340, name_color=0xffffff, name="刘秀", },	--只说一句话的刘秀
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.3,mx= 3414,my = 452 }, 	 
	    },

        --刘秀自言自语
	    {
			{ event = 'talk', delay= 0.1, handle_id = 30, talk='丽华，还记得你当初的承诺吗？', dur=2 },	
	    },

        --字幕，几年前
		{
			{ event = 'changeRGBA',delay=0.1,dur=1,txt = "五年前，长安……"},
			{ event = 'camera', delay = 0.1, c_topox={1282,336} , sdur=0.5, dur = 1,style = '',backtime=1},
		},



		--王寻请教蔡少公
	    {
			{ event = 'talk', delay= 0.1, handle_id = 4, talk='蔡博士，这赤伏符中有何天机？', dur=2 },	
			{ event = 'talk', delay= 2.3, handle_id = 3, talk='谶书中二十八星宿，每七字成一组，加之中天紫微垣北斗七星……', dur=3 },
			{ event = 'talk', delay= 5.6, handle_id = 3, talk='得五句字谜诗，这五句拆字，并字射谜，归为一句话……', dur=3 },
			{ event = 'talk', delay= 9, handle_id = 3, talk='刘、秀、当、为、帝。', dur=2 },
	    },

	    --哐当一声
		{
			
			{ event='showTopTalk', delay=0.5, dialog_id="ux13_1" ,dialog_time = 1},
		},

		--王寻听见响声
	    {
			{ event = 'talk', delay= 0.5, handle_id = 4, talk='[a]谁在外面！', dur=2 ,emote = {a= 39}},	   
			{ event = 'move', delay = 0.1,handle_id=4, dir = 5, pos = {1258,406},speed = 240, dur = 1 ,end_dir = 5}, 	
			{ event = 'move', delay = 0.1,handle_id=5, dir = 5, pos = {1164,363},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.1,handle_id=6, dir = 5, pos = {1197,437},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.1,handle_id=7, dir = 5, pos = {1275,472},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.1,handle_id=8, dir = 5, pos = {1357,459},speed = 240, dur = 1 ,end_dir = 5},
	    },

	    --刘秀，丽华跑掉，王寻和众士兵跑入屏幕
		{
			{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.3,style = '',backtime=1, c_topox = {1105,883}},
			{ event = 'talk', delay= 0.5, handle_id = 1, talk='不好，文叔哥哥快跑。', dur=1.5 },
			{ event = 'move', delay = 0.7,handle_id=1, dir = 1, pos = {522,1106},speed = 240, dur = 0.1 ,end_dir = 3},
			{ event = 'move', delay = 0.7,handle_id=2, dir = 1, pos = {588,1164},speed = 240, dur = 0.1 ,end_dir = 3},
			{ event='kill', delay=3.5, handle_id=1}, 
			{ event='kill', delay=3.5, handle_id=2}, 

			--王寻和众士兵跑入屏幕
			{ event = 'move', delay = 1.5,handle_id=4, dir = 1, pos = {1045,939},speed = 240, dur = 2.5 ,end_dir = 5},
			{ event = 'move', delay = 1.8,handle_id=5, dir = 1, pos = {1015,852},speed = 240, dur = 2.5 ,end_dir = 5},
			{ event = 'move', delay = 1.8,handle_id=6, dir = 1, pos = {1079,886},speed = 240, dur = 2.5 ,end_dir = 5},
			{ event = 'move', delay = 1.8,handle_id=7, dir = 1, pos = {1143,913},speed = 240, dur = 2.5 ,end_dir = 5},
			{ event = 'move', delay = 1.8,handle_id=8, dir = 1, pos = {1213,940},speed = 240, dur = 2.5 ,end_dir = 5},
	    },

	    --王寻和众士兵跑出屏幕
		{
			{ event = 'talk', delay= 0.1, handle_id = 4, talk='给我追！', dur=1.5 },
			-- { event = 'camera', delay = 0.1, dur=2,sdur = 0.5,style = 'follow',backtime=1, target_id = 4},

			{ event = 'move', delay = 0.5,handle_id=4, dir = 1, pos = {493,1252},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.5,handle_id=5, dir = 1, pos = {464,1158},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.5,handle_id=6, dir = 1, pos = {519,1185},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.5,handle_id=7, dir = 1, pos = {592,1224},speed = 240, dur = 1 ,end_dir = 5},
			{ event = 'move', delay = 0.5,handle_id=8, dir = 1, pos = {663,1253},speed = 240, dur = 1 ,end_dir = 5},

			{ event='kill', delay=3, handle_id=4}, 
			{ event='kill', delay=3, handle_id=5}, 
			{ event='kill', delay=3, handle_id=6}, 
			{ event='kill', delay=3, handle_id=7}, 
			{ event='kill', delay=3, handle_id=8}, 

	    },


	    --丽华和刘秀跑进角落里
		{
			{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = {592,1752}},
			{ event='createActor', delay=0.5, handle_id=1, body=6, pos={334,1424}, dir=1, speed=340, name_color=0xffffff, name="阴丽华", },
			{ event='createActor', delay=0.5, handle_id=2, body=13, pos={393,1424}, dir=1, speed=340, name_color=0xffffff, name="刘秀", },
			-- { event = 'camera', delay = 0.1, dur=2,sdur = 0.5,style = 'follow',backtime=1, target_id = 4},

			{ event = 'move', delay = 1,handle_id=1, dir = 1, pos = {500,1755},speed = 240, dur = 2 ,end_dir = 3},
			{ event = 'move', delay = 1,handle_id=2, dir = 1, pos = {569,1781},speed = 240, dur = 2 ,end_dir = 7},

			{ event = 'talk', delay= 2, handle_id = 1, talk='呼呼呼...', dur=1.8 },
			{ event = 'talk', delay= 2, handle_id = 2, talk='呼呼呼...', dur=1.8 },
			{ event = 'talk', delay= 4.1, handle_id = 1, talk='舅舅所说的谶语，可跟文叔哥哥你有关系啊，你不也叫刘秀嘛。', dur=3 },
			{ event = 'talk', delay= 7.4, handle_id = 2, talk='对啊，怎知这谶语所说的刘秀不是我呢？', dur=2.5 },
			{ event = 'talk', delay= 10.2, handle_id = 1, talk='哈哈，若是文叔哥哥能当天子，那我倒是愿意当个皇后。', dur=3 },
			{ event = 'talk', delay= 13.5, handle_id = 2, talk='丽华！你……此言当真？', dur=2 },
			{ event = 'talk', delay= 15.8, handle_id = 1, talk='君子一诺千金，我可是君子呢！', dur=2 },
	    },

	},

	--============================================wuwenbin  主线任务 剧情13 end    =====================================----

	--============================================luyao  主线任务 剧情14 start  =====================================----
	['juqing-ux014'] = { 
	--1刘秀  2阴戟  3刘縯  
	   	{
	   		{ event='init_cimera', delay = 0.3,mx= 3272,my = 1234 }, 	 

	   		{ event='createActor', delay=0.1, handle_id=1, body=13, pos={3671,1440}, dir=6, speed=340, name_color=0xffffff, name="刘秀", },	

	   		{ event='createActor', delay=0.1, handle_id=2, body=5, pos={3258,850}, dir=1, speed=340, name_color=0xffffff, name="阴戟", },
	   		{ event='createActor', delay=0.1, handle_id=3, body=14, pos={3412,780}, dir=5, speed=340, name_color=0xffffff, name="刘縯", },

			{ event = 'move', delay = 0.2,handle_id=1, dir = 6, pos = {3306,1384},speed = 340, dur = 1.5 ,end_dir = 6},
		},
		{
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux14_1" ,dialog_time = 3},
		},
		{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 5, pos = {3306,1384},speed = 340, dur = 0.2 ,end_dir = 5},
			{ event = 'move', delay = 0.5,handle_id=1, dir = 3, pos = {3306,1384},speed = 340, dur = 0.2 ,end_dir = 3},
			{ event = 'move', delay = 1,handle_id=1, dir = 1, pos = {3306,1384},speed = 340, dur = 0.2 ,end_dir = 1},
			{ event = 'talk', delay= 0.2, handle_id = 1, talk='？', dur=1.5 },				
		},

		{
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux14_2" ,dialog_time = 3},
		},	
		{
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux14_3" ,dialog_time = 3},
		},			
		{
			{ event = 'talk', delay= 0.1, handle_id = 1, talk='！！！', dur=1.5 },			
		},

		{
			{ event = 'camera', delay = 0.1, dur=1.8,sdur = 1.6,style = '',backtime=1, c_topox = {3270,774}},
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {3261,950},speed = 300, dur = 2 ,end_dir = 1},

			{ event = 'move', delay = 2.1,handle_id=2, dir = 7, pos = {3258+50,800-50},speed = 300, dur = 2 ,end_dir = 5},

			{ event = 'talk', delay= 4.5, handle_id = 3, talk='文叔，傻站着干嘛，快过来，咱们又多了一位盟友。', dur=2.8 },

			{ event = 'talk', delay= 7.5, handle_id = 3, talk='阴戟兄弟要随我们一同去李家，共谋大事。', dur=2.2 },	

			{ event = 'talk', delay= 9.5, handle_id = 1, talk='不行！', dur=1.5 },
			{ event = 'talk', delay= 11.2, handle_id = 1, talk='阴戟，你随我来，我有话对你说。', dur=2 },				

		},

		{
			{ event = 'move', delay = 0.1,handle_id=1, dir = 1, pos = {3446,1557},speed = 340, dur = 2 ,end_dir = 3},


			{ event = 'move', delay = 2.1,handle_id=2, dir = 2, pos = {3258,800},speed = 300, dur = 2 ,end_dir = 2},
			{ event = 'talk', delay = 3.0, handle_id = 2, talk='伯升大哥，我去去就回。', dur=1.8 },

			{ event = 'camera', delay = 4.6, dur=2,sdur = 2,style = '',backtime=1, c_topox = {3317,1409}},

			{ event = 'move', delay = 4.6,handle_id=2, dir = 2, pos = {3300,1439},speed = 340, dur = 1.5 ,end_dir = 3},
		},

	    {
			{ event = 'talk', delay= 0.1, handle_id = 2, talk='你叫我出来，不就是为了劝我不要去吗？怎地又不开口了？', dur= 2.2 },
			{ event = 'move', delay = 2.1,handle_id=1, dir = 2, pos = {3420,1520},speed = 340, dur = 2 ,end_dir = 7},
			{ event = 'talk', delay= 2.5, handle_id = 1, talk='[a]丽华这般聪明，不开口便知我要说什么。',emote={a=18}, dur=2 },
			{ event = 'talk', delay= 4.5, handle_id = 2, talk='[a]我虽是女子，可你也该知道我的心性，绝非那种……',emote={a=34}, dur=2.2 },
			{ event = 'talk', delay= 7, handle_id = 1, talk='绝非那种躲在家中，不谙世事的女子？', dur=1.8 },
			{ event = 'talk', delay= 9, handle_id = 2, talk='你既知道，那就不必浪费时间了。', dur=1.8 },

			{ event = 'camera', delay = 10.1, dur=0.8,sdur = 1,style = '',backtime=1, c_topox = {3196,1474}},	

			{ event = 'move', delay = 10.1,handle_id=2, dir = 2, pos = {3200,1539},speed = 340, dur = 0.8 ,end_dir = 5},						
			{ event = 'move', delay = 10.5,handle_id=1, dir = 2, pos = {3150,1589},speed = 240, dur = 0.5 ,end_dir = 1},
		},
		{
			{ event = 'talk', delay= 0.1, handle_id = 1, talk='我知你志向身手都不输男儿，可毕竟是个女子，征战沙场，多有不便。', dur= 3 },
			{ event = 'talk', delay= 3.5, handle_id = 2, talk='三哥，请把丽华当作阴戟，一个想于乱世中有所作为之人。', dur= 3 },
			{ event = 'talk', delay= 7, handle_id = 2, talk='让我随你们一起，并肩而战！', dur=1.8 },
			{ event = 'talk', delay= 9, handle_id = 1, talk='[a]那……好吧。',emote={a=13}, dur=3 },
		},
	},



	--============================================luyao  主线任务 剧情14 end    =====================================----

	--============================================wuwenbin  主线任务 剧情15 start  =====================================----
	--演员表 1 丽华  2 刘秀 3 刘稷
	['juqing-ux015'] = 
	{
	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 959,my = 1700 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={970,1717}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={921,1753}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    },
	    --刘秀想教丽华盘髻
	    {
	    	{ event='talk', delay=0.1, handle_id=2, talk='男子发髻比你们女子的简单，我教你……', dur=3  },
	    	{ event='talk', delay=3.5, handle_id=1, talk='要不三哥把头发散了，我看你怎么扎的，看一遍就会。', dur=3 },

	    	{ event='move', delay= 5, handle_id=2, end_dir=1, pos={888,1777}, speed=300, dur=1.5 },
	    	{ event='talk', delay= 6.8, handle_id=2, talk='别别，君子动口不动手，我教你，我教你。', dur=3 },
	    },   

	    --刘秀走到阴戟身后无限接近
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={970,1717}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={954,1736}, speed=300, dur=1.5 },
	    }, 

	    --刘稷突然跑过来
	    {
			{ event='createActor', delay=0.1, handle_id = 3, body=20, pos={1329,2060}, dir=5, speed=340, name_color=0xffffff, name="刘稷"},
			{ event='move', delay= 0.2, handle_id=3, end_dir=7, pos={1009,1813}, speed=300, dur=1.5 },
			{ event='talk', delay=0.2, handle_id=3, talk='三哥！三哥！', dur=2.5  },

			{ event='talk', delay=0.5, handle_id=1, talk='！！', dur=1.5 },
			{ event='talk', delay=0.5, handle_id=2, talk='！！', dur=1.5 },

			{ event='move', delay= 0.5, handle_id=1, end_dir=3, pos={970,1717}, speed=340, dur=1.5 },
			{ event='move', delay= 0.5, handle_id=2, end_dir=3, pos={882,1754}, speed=340, dur=1.5 },
	    },

	    --刘稷怀疑刘秀断袖
	    {
			{ event='talk', delay=0.1, handle_id=3, talk='你…你们…三哥，你们……难道断，断袖……', dur=3 },

			{ event='talk', delay=3.4, handle_id=2, talk='[a]胡说什么，阴兄弟不会束发，我在教他。', dur=3,emote ={ a=47} },
			{ event='talk', delay=6.7, handle_id=3, talk='三哥，你不是没娶到阴千金，就喜欢阴家小子吧~', dur=3,emote ={ a=45} },
	    },

	    --丽华生气，赶走两人
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={970,1717}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={882,1754}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=1, pos={1009,1813}, speed=300, dur=1.5 },

			{ event='talk', delay=0.1, handle_id=1, talk='不会束发怎么啦，我们阴家仆人多，不用我动手！', dur=3 },
			{ event='talk', delay=3.5, handle_id=1, talk='不用你教了，出去出去，免得束个发还落人闲话。', dur=3},

			{ event='playAction', delay = 3.8, handle_id=1, action_id=2, dur=1.5, dir=5, loop=false ,},

			{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={888,1781}, speed=300, dur=1.5 },
			{ event='move', delay= 0.1, handle_id=3, end_dir=1, pos={979,1843}, speed=300, dur=1.5 },
			{ event='talk', delay=3.8, handle_id=2, talk='！！', dur=1.5 },
			{ event='talk', delay=3.8, handle_id=3, talk='！！', dur=1.5 },
	    },

	    --丽华叹息
	    {
			{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={912,2160}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=1, pos={995,2202}, speed=300, dur=1.5 },

			{ event='talk', delay=2, handle_id=1, talk='唉，原来扮男人也不容易。', dur=2.5 },
	    },
	},

	--============================================wuwenbin  主线任务 剧情15 end  =====================================----

	--============================================wuwenbin  主线任务 剧情16 start  =====================================----
	--演员表 1 丽华  2 刘秀
	['juqing-ux016'] = 
	{
	    --创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 959,my = 1650 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={904,1750}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    },
	    --刘秀想教丽华盘髻
	    {
	    	{ event='talk', delay=0.1, handle_id=2, talk='你看这一句，士众一，则军心结，意思是……', dur=2.5  },
	    	{ event='talk', delay=2.8, handle_id=1, talk='[a]', dur=1.5 ,emote ={ a=16} },
	    	{ event='talk', delay=4.6, handle_id=2, talk='怎么了？', dur=1.5 },
	    	{ event='talk', delay=6.5, handle_id=1, talk='柔能治刚，弱能治强，原来三哥是把军谶融会贯通，用在做人处事上。', dur=3},
	    },   

	    --刘秀向丽华表白
	    {
	    	{ event='talk', delay=0.1, handle_id=2, talk='军谶，用计用谋，我对你，是用心。', dur=2.5  },
	    	{ event='talk', delay=2.9, handle_id=1, talk='[a]', dur=1.5 ,emote ={ a=48} },
	    }, 
	},

	--============================================wuwenbin  主线任务 剧情16 end  =====================================----

	--============================================lixin  主线任务 剧情17 start  =====================================----
	--演员表  1-刘縯  2-刘秀  3-阴戟  4-刘稷  5-刘伯姬  6-潘氏
	['juqing-ux017'] =
	{
	    --创建角色
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=5, pos={982,1706}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	    },	

	    --锁定镜头创建第二波人物
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 959,my = 1650 },
	    },

	    --说话 跑进人群
	    {
	    	{ event='talk', delay=0.1, handle_id=2, talk='我现在就去告诉大哥！', dur=2.5  },
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1838-32,2098-32}, speed=300, dur=1.5 },
	    },

	},
	--============================================lixin  主线任务 剧情18 end  =====================================----

	--============================================lixin  主线任务 剧情18 start  =====================================----
	--演员表  1-刘縯  2-刘秀  3-阴戟  4-刘稷  5-刘伯姬  6-潘氏
	['juqing-ux018'] =
	{
	    --创建角色
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=14, pos={467,563}, dir=3, speed=340, name_color=0xffffff, name="刘縯"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={623,561}, dir=5, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=5, pos={465,690}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=20, pos={624,690}, dir=7, speed=340, name_color=0xffffff, name="刘稷"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=17, pos={1259,306}, dir=2, speed=340, name_color=0xffffff, name="刘伯姬"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=56, pos={1383,306}, dir=6, speed=340, name_color=0xffffff, name="潘氏"},
	    },	

	    --锁定镜头创建第二波人物
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 565,my = 593 },
	    },

	    --说话
	    {
	    	{ event='talk', delay=0.1, handle_id=2, talk='……', dur=2.5  },
	    	{ event='talk', delay=0.1, handle_id=1, talk='……', dur=2.5  },
	    	{ event='talk', delay=3, handle_id=3, talk='……', dur=1.5  },
	    	{ event='talk', delay=3, handle_id=4, talk='……', dur=1.5  },
	    },

	    --刘伯姬去找盘式
	    {
	    	{ event ='camera', delay = 0.1, target_id = 5, sdur=3.5, dur = 1,style = 'follow',backtime=1},
	    	-- { event='move', delay= 0.1, handle_id=5, end_dir=2, pos={1259,306}, speed=300, dur=1.5 },

	    	{ event='talk', delay=2, handle_id=5, talk='大嫂，这大哥眼里就只有兄弟和大事，都不理你。[a]', dur=2.5,emote={a=48}},
	    	{ event='talk', delay=5, handle_id=6, talk='[a]哎，他连孩子都懒得看一眼。',dur=2 ,emote={a=7}},
	    	{ event='talk', delay=7.5, handle_id=5, talk='[a]可是那个阴戟身份古怪得很，怕是外头的奸细！', dur=2.5,emote={a=39}},

	    	{ event='kill', delay=3, handle_id=1},
	    	{ event='kill', delay=3, handle_id=2},
	    	{ event='kill', delay=3, handle_id=3},
	    	{ event='kill', delay=3, handle_id=4},

	    	{ event='createActor', delay=4, handle_id = 3, body=5, pos={1105,715}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	    },

	    {
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=6, pos={817,8}, speed=150, dur=1.5 },

	    	{ event='move', delay= 1, handle_id=5, end_dir=6, pos={1209,306}, speed=300, dur=1.5 },
	    	{ event='move', delay= 1, handle_id=6, end_dir=6, pos={1333,306}, speed=300, dur=1.5 },

	    	{ event='talk', delay=1, handle_id=5, talk='！', dur=1.5  },
	    	{ event='talk', delay=1, handle_id=6, talk='！', dur=1.5  },

	    	{ event='kill', delay=1.8, handle_id=3},
	    },

	    {
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=2, pos={1209,306}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=6, pos={1333,306}, speed=300, dur=1.5 },

	    	{ event='talk', delay=0.1, handle_id=5, talk='咦？大嫂，那人好像是阴戟……', dur=2},
	    	{ event='talk', delay=2.5, handle_id=5, talk='你看我没说错吧，是他形迹太可疑，此人不得不防啊。', dur=2.5  },
	    	{ event='talk', delay=5.5, handle_id=6, talk='[a]这么晚了，他是要去那儿……过去看看。', dur=2.5,emote={a=14}},
	    },

	    {
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=6, pos={851,79}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=6, pos={851,79}, speed=300, dur=1.5 },
	    },
	},

	--============================================lixin  主线任务 剧情18 end  =====================================----

--=============================================luyao	主线剧情19	start 	=======================================--
	['juqing-ux019'] =
	{
		{--公孙石1   小妾 2    阴丽华3  阴丽华跳过去就是一刀。
	    	{ event='init_cimera', delay = 0.2,mx= 1427,my = 284 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=38, pos={1282,285}, dir=5, speed=340, name_color=0xffffff, name="公孙石"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=37, pos={1209,322}, dir=1, speed=340, name_color=0xffffff, name="小妾"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=6, pos={1521,529}, dir=7, speed=340, name_color=0xffffff, name="阴丽华"},

	    	{ event='move', delay= 1, handle_id=3, end_dir=7, pos={1284,361}, speed=50, dur=0.7 },
	    	{ event='playAction', delay = 1.5, handle_id=3, action_id=2, dur=1.5, dir=7, loop=false ,},

	    	{ event='playAction', delay = 1.6, handle_id=1, action_id=3, dur=0.5, dir=3, loop=false ,},
	    	{ event='playAction', delay = 1.6, handle_id=2, action_id=3, dur=0.5, dir=3, loop=false ,},

	    	{ event='talk', delay=1.5, handle_id=1, talk='啊——！', dur=1 },
	    	{ event='talk', delay=1.5, handle_id=2, talk='——！', dur=1 },		    		 	    	    	
		},
		{--贱人四散
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1530,370}, speed=350, dur=0.7 },
	    	{ event='move', delay= 1.7, handle_id=1, end_dir=7, pos={1580,510}, speed=350, dur=0.7 },

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={1350,480}, speed=350, dur=0.7 },
	    	{ event='move', delay= 1.5, handle_id=2, end_dir=7, pos={1590,470}, speed=350, dur=0.7 },

	    	{ event='move', delay= 0.8, handle_id=3, end_dir=3, pos={1284,361}, speed=350, dur=0.7 },

	    	{ event='talk', delay=0.3, handle_id=1, talk='杀人呐——', dur=2.5  },	    	
	    	{ event='talk', delay=0.3, handle_id=2, talk='救命啊啊啊——', dur=2.5  },

	    	{ event='talk', delay=0.8, handle_id=3, talk='[a]', dur=2.5, emote={a=34}, },
		},
		{--刘秀出现救人
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=5, pos={1284+50,361+50}, speed=300, dur=0.7 },
	    	{ event='talk', delay=0.1, handle_id=3, talk='[a]', dur=1.2, emote={a=34}, },
	   		{ event='createActor', delay=0.3, handle_id = 4, body=13, pos={990,559}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},

	    	{ event='move', delay= 0.4, handle_id=4, end_dir=1, pos={1284,361+100}, speed=200, dur=0.7 },

	    	{ event='talk', delay=1.5, handle_id=4, talk='多耽搁一会就是一分危险，先找婵儿要紧，走！', dur=2.2  },

	    	{ event='move', delay= 4, handle_id=3, end_dir=3, pos={1284+50,361+50}, speed=300, dur=0.7 },
	    	{ event='talk', delay=4.2, handle_id=3, talk='[a]项上人头，先寄着！', dur=2 , emote={a=34}, },	    	
		},
		{--成功引开BOSS·
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=5, pos={927,717}, speed=300, dur=1.7 },
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=5, pos={927,717}, speed=300, dur=1.7 },
	    	{ event='move', delay= 0.2, handle_id=1, end_dir=6, pos={1580,510}, speed=300, dur=1.7 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=6, pos={1590,470}, speed=300, dur=1.7 },	

		},
	},
--=============================================luyao	主线剧情19	end 	=======================================--

	--============================================wuwenbin  主线任务 剧情21 start  =====================================----
	--演员表 1 丽华  2 刘秀 3 刘栩 4 刘良 101-104 刘家子弟，汉军将士
	['juqing-ux021'] = 
	{
	    --创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1970,my = 2100 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1334-32,1740-32}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	   		-- { event='createActor', delay=0.1, handle_id = 2, body=12, pos={1970,2200}, dir=6, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id="2", is_lead=1, pos={1970,2200}, speed=340, dir = 6,mount = 1, name="刘秀"}, 
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={1362-32,1812-32}, dir=5, speed=340, name_color=0xffffff, name="刘栩"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={1390-32,1872-32}, dir=1, speed=340, name_color=0xffffff, name="刘良"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=29, pos={1908-32,2132-32}, dir=3, speed=340, name_color=0xffffff, name="刘家子弟"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=29, pos={2068+32,2166-32}, dir=5, speed=340, name_color=0xffffff, name="刘家子弟"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={2038+32,2256+32}, dir=7, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1872-32,2250+32}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	    },
	    --刘家子弟和汉军将士嘲笑刘秀
	    {
	    	{ event='talk', delay=0.1, handle_id=101, talk='刘秀，你大哥可是柱天都部啊……', dur=2.5  },
	    	{ event='talk', delay=2.9, handle_id=101, talk='难道你要骑牛上阵吗？', dur=2.5 },

	    	{ event='talk', delay=5.4, handle_id=103, talk='原来还是你家耕地用的牛啊！', dur=2.5 },
	    	{ event='talk', delay=8.2, handle_id=104, talk='你以后是不是还打算继续耕田呀？', dur=2.5 },

	    	{ event='talk', delay=11, handle_id=102, talk='你这也算是咱高祖的后人？', dur=2.5},
	    	{ event='talk', delay=13.8, handle_id=101, talk='真丢人，哈哈哈……骑牛将军？', dur=2.5  },


	    	-- { event='talk', delay=16.6, handle_id=101, talk='难道你要骑牛上阵吗？', dur=2.5 },

	    	{ event='talk', delay=16.6, handle_id=101, talk='哈哈——', dur=2 },
	    	{ event='talk', delay=16.6, handle_id=102, talk='哈哈——', dur=2 },
	    	{ event='talk', delay=16.6, handle_id=103, talk='[a]', dur=2 ,emote = { a=45 }},
	    	{ event='talk', delay=16.6, handle_id=104, talk='[a]', dur=2 ,emote = { a=45 } },
	    },   

	    --阴戟进入镜头，攻击了刘家子弟一下
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1838-32,2098-32}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1812-32,2156-32}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },

	    	-- { event = 'effect', handle_id=201 , delay = 1, target_id = 1, layer = 2, effect_id = 20004, dx = 0,dy = 120,is_forever = true},--阴丽华生气特效

	    	{ event='playAction', delay = 3.3, handle_id=1, action_id=2, dur=1.5, dir=3, loop=false ,},
	    	{ event='playAction', delay = 3.5, handle_id=101, action_id=4, dur=1.5, dir=6, loop=false , once = true},
	    	{ event='talk', delay=3.5, handle_id=101, talk='哎哟——', dur=1.5 },
	    },

	    --刘栩嘲笑子弟1
	    {
	    	{ event='talk', delay=0.5, handle_id=101, talk='疼死了……', dur=2.5  },
	    	{ event='move', delay= 0.1, handle_id=101, end_dir=5, pos={2034+32,2096-32}, speed=300, dur=1.5 },

	    	{ event='move', delay= 2.5, handle_id=3, end_dir=1, pos={1812-32,2156-32}, speed=300, dur=1.5 },
	    	{ event='talk', delay=2.9, handle_id=3, talk='哈哈哈，活该！', dur=1.5 ,emote ={ a=48} },
	    	{ event='talk', delay=4.7, handle_id=3, talk='谁让你嘲笑三哥！', dur=1.5 ,emote ={ a=48} },
	    }, 

	    --阴戟和刘秀说话
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1912-32,2160-32}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id="2", end_dir=7, pos={1970,2200}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1812-32,2156-32}, speed=300, dur=1.5 },

	    	{ event='talk', delay=0.3, handle_id=1, talk='三哥，骑牛上阵毕竟不好看……', dur=2.5  },
	    	{ event='talk', delay=3.1, handle_id=1, talk='你真的要骑它去打仗吗？', dur=2.5  },

	    	{ event='talk', delay=5.9, handle_id="2", talk='[a]古有黄飞虎骑五色牛，助西伯侯姬昌建周。', dur=2.5 , emote = { a = 3}, },

	    	{ event='talk', delay=8.9, handle_id="2", talk='如今我刘文叔为何不能骑耕牛，助兄长复汉？', dur=2.5  },

	    	{ event='move', delay= 12.3, handle_id=4, end_dir=1, pos={1906,2266}, speed=300, dur=1.5 },
	    	{ event='move', delay= 12.3, handle_id="2", end_dir=5, pos={1970,2200}, speed=300, dur=3 },
	    	{ event='move', delay= 12.3, handle_id=104, end_dir=7, pos={1966+32,2292+32}, speed=300, dur=1.5 },
	    	{ event='talk', delay=12.3, handle_id=4, talk='说的好，不亏我刘家儿郎。', dur=3  },
	    },

	    --刘秀阴戟对话
	    {
	    	-- { event='move', delay= 0.1, handle_id=2, end_dir=1, pos={912,2160}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id="2", end_dir=7, pos={1970,2200}, speed=300, dur=1.5 },
	    	{ event='talk', delay=0.1, handle_id="2", talk='阴戟~要来一块骑牛么？', dur=2.5  },
	    	{ event='talk', delay=2.9, handle_id=1, talk='……', dur=1.5  },
	    	{ event='talk', delay=4.8, handle_id=1, talk='若非你将马给我，也不至于骑牛上阵。', dur=3  },
	    	{ event='talk', delay=8.1, handle_id="2", talk='[a]能与你并肩而战，骑牛又如何？', dur=3 , emote = { a = 3}, },
	    	{ event='talk', delay=11.4, handle_id=1, talk='没错，就算是骑牛冲锋陷阵，你也能做个大将军！', dur=3  },
	    },

	    --阴丽华心里对白
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux21_1" ,dialog_time = 2},
	    },
	},

	--============================================wuwenbin  主线任务 剧情21 end  =====================================----

	--============================================sunluyso  主线任务 剧情22 start  =====================================----
	['juqing-ux022'] =
	{
	   	{	

	    	{ event='createActor', delay=0.1, handle_id = 1, body=20, pos={1225,357}, dir=2, speed=340, name_color=0xffffff, name="刘稷"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=29, pos={1185-100,357-40}, dir=2, speed=340, name_color=0xffffff, name="刘家弟子"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=29, pos={1185-100,357+40}, dir=2, speed=340, name_color=0xffffff, name="刘家弟子"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=29, pos={1185,357-90}, dir=2, speed=340, name_color=0xffffff, name="刘家弟子"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=29, pos={1185,357+90}, dir=2, speed=340, name_color=0xffffff, name="刘家弟子"},

	    	{ event='createActor', delay=0.1, handle_id = 11, body=47, pos={1640,330}, dir=6, speed=340, name_color=0xffffff, name="陈牧"},
	    	{ event='createActor', delay=0.1, handle_id = 12, body=15, pos={1640+100,360+50}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},
	    	{ event='createActor', delay=0.1, handle_id = 13, body=15, pos={1640+100,360-100}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},	    	
	    	{ event='createActor', delay=0.1, handle_id = 14, body=16, pos={1640+200,360-100}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},
	    	{ event='createActor', delay=0.1, handle_id = 15, body=16, pos={1640+200,360+50}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},
	    	{ event='createActor', delay=0.1, handle_id = 16, body=16, pos={1640+150,330}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},	    	
	    	{ event='createActor', delay=0.1, handle_id = 17, body=16, pos={1640+300,360+50}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},
	    	{ event='createActor', delay=0.1, handle_id = 18, body=16, pos={1640+250,330}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},
	    	{ event='createActor', delay=0.1, handle_id = 19, body=16, pos={1640+300,360-100}, dir=6, speed=340, name_color=0xffffff, name="平林兵士"},

			{ event='effect', handle_id=1001,  delay=0.2, pos={1365, 287}, effect_id=20021, is_forever = true},
			{ event='effect', handle_id=1002,  delay=0.2, pos={1465, 287}, effect_id=20021, is_forever = true},
			{ event='effect', handle_id=1003,  delay=0.2, pos={1365, 410}, effect_id=20021, is_forever = true},
			{ event='effect', handle_id=1004,  delay=0.2, pos={1435, 367}, effect_id=20021, is_forever = true},	

			{ event='effect', handle_id=1005,  delay=0.2, pos={1365+50, 287+100}, effect_id=20021, is_forever = true},
			{ event='effect', handle_id=1006,  delay=0.2, pos={1465+50, 287+100}, effect_id=20021, is_forever = true},
			--{ event='effect', handle_id=1007,  delay=0.2, pos={1365, 377+120}, effect_id=20021, is_forever = true},
			--{ event='effect', handle_id=1008,  delay=0.2, pos={1435, 367+110}, effect_id=20021, is_forever = true},			

		},	
		{
	   		{ event='init_cimera', delay = 0.2,mx= 1465,my = 287 },
	   	},
		{
	    	{ event='talk', delay=1, handle_id=1, talk='我们拼死拼活打下的湖阳，连湖阳尉都是我杀的，理应拿大份！', dur=3 },
	    	{ event='talk', delay=4.5, handle_id=11, talk='湖阳我们也打了！谁人多谁拿大份才对！', dur=2.2 },
	    	{ event='talk', delay=7, handle_id=3, talk='放狗屁，当然是谁功劳大谁分的多。', dur=2 },
	    	{ event='talk', delay=9.5, handle_id=12, talk='咱们人多，只管抢就是了！', dur=2 },

	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=11, end_dir=6, pos={1540,310}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=12, end_dir=6, pos={1540+100,360+50}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=13, end_dir=6, pos={1540+100,360-100}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=14, end_dir=6, pos={1540+200,360-100}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=15, end_dir=6, pos={1540+200,360+50}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=16, end_dir=6, pos={1540+150,330}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=17, end_dir=6, pos={1540+300,360+50}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=18, end_dir=6, pos={1540+250,330}, speed=300, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=19, end_dir=6, pos={1540+300,360-100}, speed=300, dur=0.5 },
	    },
	    {
			--{ event='effect', handle_id=10001, target_id=1 , delay=0.1, pos={-10,120}, effect_id=20012, is_forever = true},

	    	{ event='talk', delay=0.1, handle_id=1, talk='[a]', dur=1, emote={a=24}, },

	    	{ event='move', delay= 0.1, handle_id=1, end_dir=2, pos={1325,357}, speed=300, dur=1.5 },

	    	{ event='talk', delay=1.3, handle_id=1, talk='谁敢动手！弟兄们上！', dur=1.8 },

	    	{ event='move', delay= 2, handle_id=2, end_dir=2, pos={1285-100,357-40}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2, handle_id=3, end_dir=2, pos={1285-100,357+40}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2, handle_id=4, end_dir=2, pos={1285,357-90}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2, handle_id=5, end_dir=2, pos={1285,357+90}, speed=300, dur=1.5 },

	    	--{ event = 'removeEffect', delay = 3, handle_id=10001, effect_id=20012},
	    },
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux22_1" ,dialog_time = 3},
	    },
	    {

	    	{ event ='camera', delay = 0.1, c_topox = {1465,187}, dur=0.1, sdur = 0.1,style = '',backtime=1},  
	    	{ event='createActor', delay=0.1, handle_id = 21, body=12, pos={1489,725}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 22, body=5, pos={1489,725}, dir=7, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 23, body=1, pos={1489,725}, dir=7, speed=340, name_color=0xffffff, name="朱佑"},

	    	{ event='move', delay= 0.2, handle_id=21, end_dir=7, pos={1444,430}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=22, end_dir=7, pos={1494,480}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=23, end_dir=7, pos={1394,480}, speed=300, dur=1.5 },

	    	{ event='move', delay= 1, handle_id=1, end_dir=3, pos={1325,357}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=2, end_dir=3, pos={1285-100,357-40}, speed=300, dur=0.5 },
	    	--{ event='move', delay= 1, handle_id=3, end_dir=2, pos={1285-100,357+40}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=4, end_dir=3, pos={1285,357-90}, speed=300, dur=0.5 },
	    	--{ event='move', delay= 1, handle_id=5, end_dir=2, pos={1285,357+90}, speed=300, dur=0.5 },	

	    	{ event='move', delay= 1, handle_id=11, end_dir=5, pos={1540,330}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=12, end_dir=5, pos={1540+100,360+50}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=13, end_dir=5, pos={1540+100,360-100}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=14, end_dir=5, pos={1540+200,360-100}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=15, end_dir=5, pos={1540+200,360+50}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=16, end_dir=5, pos={1540+150,330}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=17, end_dir=5, pos={1540+300,360+50}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=18, end_dir=5, pos={1540+250,330}, speed=300, dur=0.5 },
	    	{ event='move', delay= 1, handle_id=19, end_dir=5, pos={1540+300,360-100}, speed=300, dur=0.5 },	    	    		    	
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=22, end_dir=2, pos={1194,480}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=23, end_dir=3, pos={1100,340}, speed=300, dur=1.5 },
	    	{ event='move', delay= 1, handle_id=21, end_dir=7, pos={1384,430}, speed=300, dur=0.5 },	    	
	    },
	    {
	    	{ event='talk', delay=0.1, handle_id=21, talk='把东西先分给新市平林的兄弟们！', dur=2 },

	    	{ event='talk', delay=2.5, handle_id=1, talk='！！！', dur=1.5 },
			{ event='effect', handle_id=10002, target_id=1 , delay=2.5, pos={-10,120}, effect_id=20008, is_forever = true},
	    	{ event = 'removeEffect', delay = 3.5, handle_id=10002, effect_id=20008},
	    },
	    {
	    	{ event='talk', delay=0.1, handle_id=1, talk='三哥，这些是咱们缴获的，凭啥给他们？', dur=2.2 },

	    	{ event='talk', delay=2.5, handle_id=3, talk='就是……', dur=1.8 },
	    	{ event='talk', delay=4.5, handle_id=5, talk='凭什么啊……', dur=1.8 },

	    	{ event='talk', delay=6.5, handle_id=21, talk='咱们起义是为了什么，难道就是为争抢东西？', dur=3 },

	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=21, end_dir=1, pos={1444,430}, speed=300, dur=1.5 },
	    	{ event='talk', delay=1, handle_id=21, talk='这才打了几仗，别说新莽主力，就连南阳宛城都还没打下来！', dur=3 },
	    	{ event='move', delay= 4.4, handle_id=21, end_dir=7, pos={1444,430}, speed=300, dur=0.5 },	    	
	    	{ event='talk', delay=4.5, handle_id=21, talk='就先为了这点东西，跟浴血杀场，并肩作战的同胞们打起来了！', dur=3 },
	    	{ event='move', delay= 7.9, handle_id=21, end_dir=1, pos={1444,430}, speed=300, dur=0.5 },		    	
	    	{ event='talk', delay=8, handle_id=21, talk='就凭你们，谈什么匡扶汉室天下？谈什么救民于水火！', dur=3 },	    	
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=21, end_dir=7, pos={1384,430}, speed=300, dur=1.5 },
	    	{ event='talk', delay=1, handle_id=21, talk='枉你们是刘家儿郎，扪心自问，对得起祖宗么，对得起良心么？', dur=3 },
	    },
	    {
	    	{ event='talk', delay=0.1, handle_id=1, talk='哎……算了算了……', dur=1.8 },
	    	{ event='talk', delay=2.1, handle_id=3, talk='东西不拿了……', dur=1.8 },
	    },
	    {
	    	{ event='talk', delay=0.1, handle_id=21, talk='新市平林的弟兄比咱们人多，也比咱们艰苦。', dur=3 },   	
	    	{ event='talk', delay=3.5, handle_id=21, talk='大家同为汉军，即为兄弟同袍，就该性命相托，不分彼此。', dur=3 },    	
	    	{ event='talk', delay=7, handle_id=21, talk='从今往后，若再为此事起争执，扰乱军心，军法处置！', dur=3 },	 
	    },
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux22_2" ,dialog_time = 3},
	    },
	    {
	    	{ event='createActor', delay=0.1, handle_id = 24, body=48, pos={1960,408}, dir=7, speed=340, name_color=0xffffff, name="朱鲔"},
	    	{ event='createActor', delay=0.1, handle_id = 25, body=9, pos={1980,400}, dir=7, speed=340, name_color=0xffffff, name="王凤"},

	    	{ event='move', delay= 0.2, handle_id=24, end_dir=6, pos={1550,433}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=25, end_dir=6, pos={1650,433}, speed=300, dur=1.5 },

	    	{ event='move', delay= 1, handle_id=21, end_dir=2, pos={1444,430}, speed=300, dur=1.5 },	    	

	    	{ event='talk', delay=1, handle_id=24, talk='大家已是兄弟，往后要同心协力，不可再和舂陵兄弟们起争端。', dur=3 }, 	    
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=25, end_dir=7, pos={1550,480}, speed=300, dur=1.5 },
	    	{ event='talk', delay=1, handle_id=25, talk='刘三将军，谢了。', dur=1.8 },

	    	{ event='move', delay= 3, handle_id=21, end_dir=3, pos={1444,430}, speed=300, dur=1.5 },	    	 	
	    	{ event='talk', delay=3.5, handle_id=21, talk='[a]不敢，应该的。', dur=1.8, emote={a=3}, }, 		    	    	
	    },
	    {
	   		{ event='init_cimera', delay = 1,mx=2562 ,my = 305},		
			{event='changeRGBA', delay=0.1, txt="",cont_time=0.8, light_time=0.8, txt_time=0.1, black_time=0.1},
	    	{ event='createActor', delay=0.3, handle_id = 26, body=18, pos={2610,440}, dir=6, speed=340, name_color=0xffffff, name="刘玄"},
	    	{ event='createActor', delay=0.3, handle_id = 27, body=47, pos={2734,468}, dir=6, speed=340, name_color=0xffffff, name="马武"},

	    	{ event='talk', delay=1, handle_id=26, talk='呵~刘文叔还真是敦厚大度啊，倒让我小瞧他了。', dur=2.5 }, 	    	
	    	{ event='talk', delay=4, handle_id=27, talk='厉害啊，就这么几句话就把事了了。', dur=3}, 	  
	    },
	},

	--============================================sunluyao  主线任务 剧情22 end  =====================================----

	

		--============================================hanbaobao  主线任务 剧情23 start  =====================================----

	--演员表 1 刘縯 2 刘秀 3 阴戟 4 李轶 5 李通 6 王匡 7 朱鲔 8 王常 9 张卬 10 马武 11 刘玄 101-105 震惊特效 106 流汗特效
	['juqing-ux023'] = 
	{
	    --创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 984,my = 869+70 },
	   		
	   		{ event='createActor', delay=0.1, handle_id = 1, body=14, pos={1135,1106}, dir=7, speed=340, name_color=0xffffff, name="刘縯"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={1199,1004}, dir=6, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=5, pos={1232,1106}, dir=6, speed=340, name_color=0xffffff, name="阴戟"},

	   		{ event='createActor', delay=0.1, handle_id = 4, body=48, pos={1071,1201}, dir=7, speed=340, name_color=0xffffff, name="李轶"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=30, pos={1168,1199}, dir=7, speed=340, name_color=0xffffff, name="李通"},

	   		{ event='createActor', delay=0.1, handle_id = 6, body=55, pos={849,1008}, dir=3, speed=340, name_color=0xffffff, name="王匡"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=48, pos={783,1072}, dir=3, speed=340, name_color=0xffffff, name="朱鲔"},

	   		{ event='createActor', delay=0.1, handle_id = 8, body=7, pos={816,911}, dir=3, speed=340, name_color=0xffffff, name="王常"},
	   		{ event='createActor', delay=0.1, handle_id = 9, body=54, pos={908,945}, dir=3, speed=340, name_color=0xffffff, name="张卬"},

	   		{ event='createActor', delay=0.1, handle_id = 10, body=47, pos={751,975}, dir=3, speed=340, name_color=0xffffff, name="马武"},
	   		{ event='createActor', delay=0.1, handle_id = 11, body=18, pos={686,1069}, dir=3, speed=340, name_color=0xffffff, name="刘玄"},
	    },

	    --开始BB，并且震惊
	    {

	    	{ event='talk', delay=0.2, handle_id=6, talk='天下百姓思汉，大势所趋，我等商议……', dur=3 },
	    	{ event='talk', delay=3.4, handle_id=6, talk='决定拥立天子，名声言顺地对抗莽贼，逐鹿天下。', dur=3 },
	    	{ event='talk', delay=6.6, handle_id=1, talk='拥立天子，非同儿戏，当审慎决定。', dur=3 },
	    	{ event='talk', delay=9.8, handle_id=6, talk='伯升所言极是，我等决定拥立刘玄刘圣公为天子。', dur=3 },

	    	{ event='effect', handle_id=101, target_id=1, delay =13 , pos={15-30,110+20}, effect_id=20008, is_forever = false},--震惊
	        { event='effect', handle_id=102, target_id=2, delay =13 , pos={15-30,110+20}, effect_id=20008, is_forever = false},--震惊	       
	        { event='effect', handle_id=103, target_id=3, delay =13 , pos={15-30,110+20}, effect_id=20008, is_forever = false},--震惊
	        { event='effect', handle_id=104, target_id=4, delay =13 , pos={15-30,110+20}, effect_id=20008, is_forever = false},--震惊
	        { event='effect', handle_id=105, target_id=5, delay =13 , pos={15-30,110+20}, effect_id=20008, is_forever = false},--震惊

	        { event='talk', delay=13.2, handle_id=1, talk='！', dur=1.2 },
	    	{ event='talk', delay=13.2, handle_id=2, talk='！', dur=1.2 },
	    	{ event='talk', delay=13.2, handle_id=3, talk='！', dur=1.2 },
	    	{ event='talk', delay=13.2, handle_id=4, talk='！', dur=1.2 },
	    	{ event='talk', delay=13.2, handle_id=5, talk='！', dur=1.2 },
	       
	    },   

	    --刘秀和众将士四向散开
	    {
	    	{ event='talk', delay=0.2, handle_id=1, talk='刘玄？！！', dur=1.3 },
	    	{ event='talk', delay=1.7, handle_id=11, talk='不……不…不…', dur=1.3 },
	    	{ event='move', delay= 1.7, handle_id=11, end_dir=1, pos={784,1168}, speed=200, dur=0.8 },
	    	{ event='move', delay= 1.8, handle_id=6, end_dir=5, pos={849,1008}, speed=280, dur=0.8 },
	    	{ event='move', delay= 1.8, handle_id=7, end_dir=5, pos={783,1072}, speed=200, dur=0.8 },

	    	{ event='talk', delay=3.2, handle_id=11, talk='玄无德无功，不敢，不敢。', dur=1.5 },
	    	
	    	{ event='talk', delay=4.9, handle_id=6, talk='圣公过谦了。', dur=1.3 },
	    	
	    	{ event='talk', delay=6.4, handle_id=6, talk='圣公是舂陵宗室，又是我汉军更始大将，当是最佳人选。', dur=3.5 },
	    	
	    	{ event='talk', delay=10.1, handle_id=6, talk='若按族谱论嫡庶之分，亦是圣公为先，伯升不会反对吧！', dur=3.5 },
	    	{ event='move', delay= 10.1, handle_id=6, end_dir=3, pos={849,1008}, speed=200, dur=0.8 },

	    	{ event='move', delay= 10.3, handle_id=11, end_dir=2, pos={784,1168}, speed=200, dur=0.8 },
	    	{ event='move', delay= 10.3, handle_id=7, end_dir=3, pos={783,1072}, speed=200, dur=0.8 },

	    	{ event='talk', delay=13.8, handle_id=1, talk='眼下反莽义军数不胜数，如若他们也立了天子，必与我军两虎相争。', dur=4 },
	    	{ event='talk', delay=18, handle_id=1, talk='因此仓促称帝，不利于讨伐莽贼大业。', dur=3 },

	    },

	     --张卬站出来BB
	    {
	    	
			{ event='move', delay= 0.2, handle_id=9, end_dir=3, pos={977,1009}, speed=280, dur=0.8 },
	    	{ event='talk', delay=0.2, handle_id=9, talk='刘伯升！', dur=1.2 },
	    	{ event='talk', delay=1.6, handle_id=9, talk='你这般反对，莫非是想自己做天子？', dur=2 },

	    	{ event='move', delay= 3.8, handle_id=1, end_dir=7, pos={1101,1074}, speed=280, dur=0.8 },
	    	{ event='talk', delay=3.8, handle_id=1, talk='你……[a]', dur=1.2,emote = {a = 24}},

	    	{ event='move', delay= 4, handle_id=7, end_dir=1, pos={912,1076}, speed=280, dur=0.8 },
	    	{ event='talk', delay=4, handle_id=7, talk='休要胡言！大将军岂是你所想的这般狭隘心肠之人？', dur=3.5 },
	    	{ event='move', delay= 4.2, handle_id=9, end_dir=5, pos={977,1009}, speed=280, dur=0.8 },
	    	{ event='move', delay= 4.2, handle_id=1, end_dir=6, pos={1101,1074}, speed=280, dur=0.8 },

	    },

	    --刘秀站出来BB
	    {
	    	
			{ event='move', delay= 0.2, handle_id=2, end_dir=5, pos={1135,973}, speed=300, dur=0.8 },
	    	{ event='talk', delay=0.2, handle_id=2, talk='朱将军，为今之计，与其立天子——', dur=3 },

			{ event='move', delay= 1.3, handle_id=7, end_dir=1, pos={912,1076}, speed=300, dur=0.8 },
			{ event='move', delay= 1.3, handle_id=9, end_dir=1, pos={977,1009}, speed=300, dur=0.8 },
			{ event='move', delay= 1.3, handle_id=1, end_dir=1, pos={1101,1074}, speed=300, dur=0.8 },
			{ event='move', delay= 1.8, handle_id=6, end_dir=2, pos={849,1008}, speed=280, dur=0.8 },

	    	{ event='talk', delay=4-0.6, handle_id=2, talk='不如推选一个德才兼备之人，尊为王。', dur=3 },
	    	{ event='talk', delay=7.4-0.6, handle_id=2, talk='同样可节制诸将，号令四方。', dur=2 },

	    	{ event='talk', delay=9.6-0.6, handle_id=10, talk='文叔所言有理。', dur=1.5 },
	    	{ event='move', delay= 10.1-0.6, handle_id=7, end_dir=7, pos={912,1076}, speed=280, dur=0.8 },
			{ event='move', delay= 10.1-0.6, handle_id=9, end_dir=7, pos={977,1009}, speed=280, dur=0.8 },
			{ event='move', delay= 10.1-0.6, handle_id=1, end_dir=7, pos={1101,1074}, speed=280, dur=0.8 },
			{ event='move', delay= 10.1-0.6, handle_id=6, end_dir=7, pos={849,1008}, speed=280, dur=0.8 },
			{ event='move', delay= 10.1-0.6, handle_id=11, end_dir=7, pos={784,1168}, speed=280, dur=0.8 },

	    	{ event='talk', delay=11.3-0.6, handle_id=8, talk='嗯。如今王莽未破，不如且先称王……', dur=3 },

	    },

	     --张卬愤怒
	    {
			{ event='talk', delay=0.2, handle_id=9, talk='三心二意，如何成大事？', dur=2 },
			{ event='move', delay= 0.1, handle_id=7, end_dir=2, pos={912,1076}, speed=280, dur=0.8 },
			{ event='move', delay= 0.2, handle_id=9, end_dir=3, pos={977,1009}, speed=280, dur=0.8 },
			{ event='move', delay= 0.2, handle_id=1, end_dir=7, pos={1101,1074}, speed=280, dur=0.8 },

			{ event='move', delay= 0.2, handle_id=6, end_dir=3, pos={849,1008}, speed=280, dur=0.8 },
			{ event='move', delay= 0.2, handle_id=11, end_dir=1, pos={784,1168}, speed=280, dur=0.8 },

			{ event='playAction', delay=2.4, handle_id=9, action_id=2, dur=1, dir=3, loop=false },

	    	{ event='talk', delay=2.4, handle_id=9, talk='今日之议，不得有二！谁敢反对，就是与汉军为敌！', dur=3.5 },
	    	{ event='talk', delay=6.1, handle_id=1, talk='[a]', dur=1.2,emote = {a = 24}},
	    	{ event='talk', delay=6.1, handle_id=3, talk='[a]', dur=1.2,emote = {a = 24}},

			{ event='move', delay= 7.3, handle_id=7, end_dir=1, pos={912,1076}, speed=300, dur=0.8 },
			{ event='move', delay= 7.3, handle_id=9, end_dir=5, pos={977,1009}, speed=300, dur=0.8 },
			{ event='move', delay= 7.3, handle_id=1, end_dir=6, pos={1101,1074}, speed=300, dur=0.8 },


	    	{ event='talk', delay=7.3, handle_id=7, talk='不得无礼！大将军也是为我汉军将来筹谋！', dur=3 },
	    	{ event='talk', delay=10.5, handle_id=7, talk='只是天下反莽众多，若让旁人先称帝……', dur=3 },
	    	{ event='talk', delay=13.7, handle_id=7, talk='于我汉军不利，还是今日议定吧。', dur=3 },

	    },

         --朱鲔带领众人称臣
	    {
			
			{ event='move', delay= 0.2, handle_id=7, end_dir=5, pos={841,1115}, speed=280, dur=0.8 },
			{ event='talk', delay=0.7, handle_id=7, talk='吾等愿尊更始将军为帝！', dur=2.5 },

			{ event='move', delay= 3, handle_id=1, end_dir=5, pos={1101,1074}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=2, end_dir=5, pos={1135,973}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=3, end_dir=5, pos={1232,1106}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=4, end_dir=6, pos={1071,1201}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=5, end_dir=6, pos={1168,1199}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=6, end_dir=3, pos={849,1008}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=8, end_dir=3, pos={816,911}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=9, end_dir=5, pos={977,1009}, speed=280, dur=0.8 },
			{ event='move', delay= 3, handle_id=10, end_dir=3, pos={751,975}, speed=280, dur=0.8 },

			{ event='effect',  delay = 3 ,handle_id=106, target_id=11, pos={0,100}, effect_id=20007, is_forever = true},

			{ event='talk', delay=3.6, handle_id=11, talk='我何德何能，如何……做得了天子？', dur=2.5 },
			{ event='talk', delay=6.3, handle_id=11, talk='不行不行…', dur=1.5 },

	    	{ event='talk', delay=8, handle_id=9, talk='有何不可，我等就愿跟随更始将军！', dur=2.5 },
	    	{ event='talk', delay=10.7, handle_id=9, talk='不，是更始皇帝！', dur=2 },

	    	{ event='talk', delay=12.9, handle_id=11, talk='这……', dur=1.2 },
	    	
	    	{ event='move', delay= 14.3, handle_id=4, end_dir=5, pos={1004,1135}, speed=280, dur=0.8 },
	    	{ event='talk', delay=14.3, handle_id=4, talk='末将也愿意追随陛下。', dur=2 },

	    	{ event = 'removeEffect', delay = 16, handle_id=106, effect_id=20007}, 
	    },


         --刘縯党无力回天
	    {

			{ event='talk', delay=0.2, handle_id=1, talk='！', dur=1.2 },
	    	{ event='talk', delay=0.2, handle_id=2, talk='！', dur=1.2 },
	    	{ event='talk', delay=0.2, handle_id=3, talk='！', dur=1.2 },
	    	{ event='talk', delay=0.2, handle_id=5, talk='！', dur=1.2 },

	    	{ event='move', delay= 1.6, handle_id=6, end_dir=5, pos={849,1008}, speed=280, dur=0.8 },
	    	
	    	{ event='talk', delay=1.6, handle_id=6, talk='我等愿尊将军为天子。', dur=2 },

	    	{ event='move', delay= 3.8, handle_id=8, end_dir=5, pos={908,945}, speed=280, dur=0.8 },
	    	{ event='move', delay= 3.8, handle_id=10, end_dir=5, pos={714,1014}, speed=280, dur=0.8 },

	    	{ event='talk', delay=3.8, handle_id=4, talk='我等愿尊将军为天子。', dur=2 },
	    	{ event='talk', delay=3.8, handle_id=7, talk='我等愿尊将军为天子。', dur=2 },
	    	{ event='talk', delay=3.8, handle_id=8, talk='我等愿尊将军为天子。', dur=2 },
	    	{ event='talk', delay=3.8, handle_id=9, talk='我等愿尊将军为天子。', dur=2 },
	    	{ event='talk', delay=3.8, handle_id=10, talk='我等愿尊将军为天子。', dur=2 },

	    	{ event='move', delay= 6, handle_id=2, end_dir=5, pos={1145,1032}, speed=280, dur=0.8 },
	    	{ event='talk', delay=7, handle_id=2, talk='大哥且忍怒。', dur=1.2 },

	    	{ event='move', delay= 8, handle_id=1, end_dir=1, pos={1101,1074}, speed=280, dur=0.8 },
	    	{ event='talk', delay=9, handle_id=2, talk='终有一日他们会后悔今日的决定。', dur=2.5 },

	    },

	},

	--============================================hanbaobao  主线任务 剧情23 end  =====================================----

	--============================================wuwenbin  主线任务 剧情24 start  =====================================----

	--演员表 1 刘秀 2 阴兴 3 马武 4 王霸 101-104 汉军将士 201-208 昆阳看守	301-309 阴家隐士、弩车、火鸢 
	['juqing-ux024'] = 
	{
	    --创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1506,my = 736 },
	   		
	   		{ event='createActor', delay=0.1, handle_id = 1, body=12, pos={1556,662}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={1484,694}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={1576,726}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={1454,750}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1520,784}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	    },

	    --刘秀率将士潜入昆阳城
	    {
	    	{ event ='camera', delay = 0.1, target_id = 1, sdur=3.5, dur = 1,style = 'follow',backtime=1},
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={1936,330}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=101, end_dir=1, pos={1870,370}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=102, end_dir=1, pos={1936,402}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=103, end_dir=1, pos={1844,434}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=104, end_dir=1, pos={1906,466}, speed=300, dur=1.5 },

	    	{ event='talk', delay=3, handle_id=1, talk='行动！', dur=1.5 },
	    	{ event ='camera', delay = 3, c_topox = {1936,330}, dur=0.5, sdur = 1,style = '',backtime=1},
	    },   

	    --刘秀和众将士四向散开
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={2098,236}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=101, end_dir=3, pos={1714,180}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=102, end_dir=3, pos={2260,430}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=103, end_dir=3, pos={1500,450}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=104, end_dir=3, pos={1924,700}, speed=300, dur=0.8 },

	    	{ event='kill', delay=1, handle_id=1}, 
	    	{ event='kill', delay=1, handle_id=101}, 
	    	{ event='kill', delay=1, handle_id=102}, 
	    	{ event='kill', delay=1, handle_id=103}, 
	    	{ event='kill', delay=1, handle_id=104}, 
	    },

	    --阴兴弩车
	    {
	    	{ event='init_cimera', delay = 0.4,mx= 2156,my = 1824 },
	    	
	    	{ event='createActor', delay=0.1, handle_id = 2, body=20, pos={2454,1970}, dir=7, speed=340, name_color=0xffffff, name="阴兴"},

	   		{ event='createActor', delay=0.1, handle_id = 301, body=62, pos={2096,1906}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},
	   		{ event='createActor', delay=0.1, handle_id = 302, body=62, pos={2036,2096}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},
	   		{ event='createActor', delay=0.1, handle_id = 303, body=62, pos={2356,2098}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},

	   		{ event='createActor', delay=0.1, handle_id = 304, body=50, pos={2036,1876}, dir=1, speed=340, name_color=0xffffff, name="弩车"},
	   		{ event='createActor', delay=0.1, handle_id = 305, body=50, pos={1968,2064}, dir=1, speed=340, name_color=0xffffff, name="弩车"},
	   		{ event='createActor', delay=0.1, handle_id = 306, body=50, pos={2286,2070}, dir=1, speed=340, name_color=0xffffff, name="弩车"},

	   		{ event="createSpEntity", delay=0.1,handle_id=307, name="60",name_color=0xffffff, actor_name="火鸢",  dir=1, pos={2036+64,1876-32}},
	   		{ event="createSpEntity", delay=0.1,handle_id=308, name="60",name_color=0xffffff, actor_name="火鸢",  dir=1, pos={1968+64,2064-32}},
	   		{ event="createSpEntity", delay=0.1,handle_id=309, name="60",name_color=0xffffff, actor_name="火鸢",  dir=1, pos={2286+64,2070-32}},

	   		-- { event='effect', handle_id=2001, target_id=304, delay=0.2, pos={30, 100}, effect_id=11049, dx = 30,dy = 50,is_forever = true},
	   		-- { event='effect', handle_id=2002, target_id=305, delay=0.2, pos={30, 100}, effect_id=11049, is_forever = true},
	   		-- { event='effect', handle_id=2003, target_id=306, delay=0.2, pos={30, 100}, effect_id=11049, is_forever = true},


	   		-- { event='createActor', delay=0.1, handle_id = 104, body=25, pos={1872-32,2250+32}, dir=1, speed=340, name_color=0xffffff, name="火鸢"},
	   		-- { event='createActor', delay=0.1, handle_id = 103, body=25, pos={2038+32,2256+32}, dir=7, speed=340, name_color=0xffffff, name="火鸢"},
	   		-- { event='createActor', delay=0.1, handle_id = 104, body=25, pos={1872-32,2250+32}, dir=1, speed=340, name_color=0xffffff, name="火鸢"},

	   		{ event='hideCast', delay=0.2, handle_id=307}, 	--隐藏实体
	   		{ event='hideCast', delay=0.2, handle_id=308}, 	--隐藏实体
	   		{ event='hideCast', delay=0.2, handle_id=309}, 	--隐藏实体

	   		-- { event='jump', delay=0.2, handle_id=2, dir=6, pos={2456,3424}, speed=120, dur=1, end_dir=3 }, -- 通过
	        -- { event='jump', delay=0.2, handle_id=2, dir=6, pos={2456,3424}, speed=120, dur=1, end_dir=3 }, -- 通过
	        -- { event='jump', delay=0.2, handle_id=2, dir=6, pos={2456,3424}, speed=120, dur=1, end_dir=3 }, -- 通过
	    }, 

	    --阴兴指挥放箭
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux24_1" ,dialog_time = 2},
	    	{ event='playAction', delay = 2.3, handle_id=2, action_id=2, dur=1.5, dir=7, loop=false ,},

	    	{ event='playAction', delay = 3, handle_id=301, action_id=2, dur=1.5, dir=7, loop=false ,},
	    	{ event='playAction', delay = 3, handle_id=302, action_id=2, dur=1.5, dir=7, loop=false ,},
	    	{ event='playAction', delay = 3, handle_id=303, action_id=2, dur=1.5, dir=7, loop=false ,},

	    	{ event='playAction', delay = 3.6, handle_id=304, action_id=2, dur=1.5, dir=1, loop=false ,once= true},
	    	{ event='playAction', delay = 3.6, handle_id=305, action_id=2, dur=1.5, dir=1, loop=false ,once= true},
	    	{ event='playAction', delay = 3.6, handle_id=306, action_id=2, dur=1.5, dir=1, loop=false ,once= true},

	    	-- { event = 'removeEffect', delay = 4, handle_id=2001, effect_id=11049},
	    	-- { event = 'removeEffect', delay = 4, handle_id=2002, effect_id=11049},
	    	-- { event = 'removeEffect', delay = 4, handle_id=2003, effect_id=11049},
	    	{ event='showCast', delay=4, handle_id=307},
	    	{ event='showCast', delay=4, handle_id=308}, 
	    	{ event='showCast', delay=4, handle_id=309}, 

	    	{ event='move', delay= 4, handle_id=307, end_dir=5, pos={2384,1550}, speed=60, dur=1.5 },	--
	    	{ event='move', delay= 4, handle_id=308, end_dir=5, pos={2548,1646}, speed=60, dur=1.5 },	--
	    	{ event='move', delay= 4, handle_id=309, end_dir=5, pos={2732,1750}, speed=60, dur=1.5 },

	    	{ event='kill', delay=4.7, handle_id=307}, 
	    	{ event='kill', delay=4.7, handle_id=308}, 
	    	{ event='kill', delay=4.7, handle_id=309}, 
	    },

	    --看守处
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 3210,my = 526 },
	    	{ event='createActor', delay=0.1, handle_id = 201, body=26, pos={3222,534}, dir=5, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='createActor', delay=0.1, handle_id = 202, body=26, pos={3312,596}, dir=5, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=26, pos={3120,590}, dir=1, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=26, pos={3216,660}, dir=1, speed=340, name_color=0xffffff, name="昆阳看守"},

	   		{ event='talk', delay=0.5, handle_id=201, talk='什么声音？！', dur=2},

	   		-- { event='move', delay= 0.1, handle_id=202, end_dir=5, pos={3312,596}, speed=300, dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=203, end_dir=5, pos={3120,590}, speed=300, dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=204, end_dir=5, pos={3216,660}, speed=300, dur=1.5 },

	    	{ event='talk', delay=1.5, handle_id=202, talk='？！', dur=2 },
	    	{ event='talk', delay=1.5, handle_id=203, talk='？！', dur=2 },
	    	{ event='talk', delay=1.5, handle_id=204, talk='？！', dur=2 },

	    	{ event='kill', delay=3.5, handle_id=201}, 
	    	{ event='kill', delay=3.5, handle_id=202}, 
	    	{ event='kill', delay=3.5, handle_id=203}, 
	    	{ event='kill', delay=3.5, handle_id=204}, 
	    },

	    --三只火鸢到处飞，出火焰特效
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {3086,850}, dur=0.5, sdur = 1,style = '',backtime=1},
	    	{ event='zoom', delay=0.1, sValue=1.0, eValue=1.1, dur=0.5}, -- 通过

	    	-- { event='createActor', delay=0.1, handle_id = 104, body=25, pos={1872-32,2250+32}, dir=1, speed=340, name_color=0xffffff, name="火鸢"},
	   		-- { event='createActor', delay=0.1, handle_id = 103, body=25, pos={2038+32,2256+32}, dir=7, speed=340, name_color=0xffffff, name="火鸢"},
	   		-- { event='createActor', delay=0.1, handle_id = 104, body=25, pos={1872-32,2250+32}, dir=1, speed=340, name_color=0xffffff, name="火鸢"},

	   		-- { event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1812-32,2156-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1812-32,2156-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1812-32,2156-32}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },


	    	-- { event='move', delay= 0.3, handle_id=307, end_dir=5, pos={97*32, 22*32}, speed=60, dur=1.5 },	--

	    	--第一只火鸢放火轨迹
	    	{ event="createSpEntity", delay=0.1,handle_id=307, name="60",name_color=0xffffff, actor_name="火鸢",  dir=3, pos={106*32, 36*32}},
	    	{ event='move', delay= 0.2, handle_id=307, end_dir=5, pos={88*32, 32*32}, speed=60, dur=1.5 },	--
	    	{ event='move', delay= 1.2, handle_id=307, end_dir=3, pos={97*32, 22*32}, speed=60, dur=1.5 },
	    	{ event = 'effect', handle_id=1001, delay = 0.1, pos = {106*32, 34*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1002, delay = 0.1, pos = {104*32, 38*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1003, delay = 0.1, pos = {108*32, 38*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1004, delay = 1, pos = {88*32, 30*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1005, delay = 1, pos = {86*32, 34*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1006, delay = 1, pos = {90*32, 34*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1007, delay = 2, pos = {97*32, 20*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1008, delay = 2, pos = {95*32, 24*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1009, delay = 2, pos = {99*32, 24*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},

	    	--第二只火鸢放火轨迹
	    	{ event="createSpEntity", delay=0.1,handle_id=308, name="60",name_color=0xffffff, actor_name="火鸢",  dir=3, pos={88*32, 25*32}},
	    	{ event='move', delay= 0.2, handle_id=308, end_dir=3, pos={96*32, 35*32}, speed=60, dur=1.5 },	--
	    	{ event='move', delay= 1.3, handle_id=308, end_dir=1, pos={109*32, 29*32}, speed=60, dur=1.5 },
	    	{ event = 'effect', handle_id=1010, delay = 2.5, pos = {88*32, 27*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1011, delay = 2.7, pos = {86*32, 26*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1012, delay = 0.1, pos = {90*32, 23*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1013, delay = 0.5, pos = {94*32, 38*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1014, delay = 1, pos = {96*32, 34*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1015, delay = 1.5, pos = {97*32, 35*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1016, delay = 1.5, pos = {112*32, 29*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1017, delay = 1.8, pos = {108*32, 27*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1018, delay = 1.8, pos = {106*32, 31*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},

	    	--第三只火鸢放火轨迹
	    	{ event="createSpEntity", delay=0.1,handle_id=309, name="60",name_color=0xffffff, actor_name="火鸢",  dir=7, pos={97*32, 36*32}},
	    	{ event='move', delay= 0.2, handle_id=309, end_dir=1, pos={88*32, 27*32}, speed=60, dur=1.5 },	--
	    	{ event='move', delay= 1.5, handle_id=309, end_dir=3, pos={105*32, 24*32}, speed=60, dur=1.5 },
	    	{ event = 'effect', handle_id=1019, delay = 2.0, pos = {97*32, 34*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1020, delay = 2.0, pos = {95*32, 36*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1021, delay = 2.5, pos = {97*32, 32*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1022, delay = 2.7, pos = {83*32, 27*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1023, delay = 2.7, pos = {88*32, 23*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1024, delay = 3.5, pos = {88*32, 29*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1025, delay = 3.5, pos = {105*32, 27*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1026, delay = 2.5, pos = {108*32, 21*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1027, delay = 2.7, pos = {103*32, 25*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},

	    	{ event = 'effect', handle_id=1028, delay = 2.7, pos = {90*32, 31*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1029, delay = 3.5, pos = {81*32, 27*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'effect', handle_id=1030, delay = 3.5, pos = {101*32, 37*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},

	    	-- { event = 'effect', handle_id=1026, delay = 3.5, pos = {105*32, 39*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	-- { event = 'effect', handle_id=1027, delay = 3.5, pos = {105*32, 34*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},
	    	-- { event = 'effect', handle_id=1028, delay = 3.5, pos = {109*32, 33*32}, layer = 2, effect_id = 11049, dx = 0,dy = 30,is_forever = true},

	    	{ event='showTopTalk', delay=3, dialog_id="ux24_2" ,dialog_time = 2},

	    	--火鸢退场
	    	{ event='move', delay= 2.4, handle_id=307, end_dir=5, pos={80*32, 33*32}, speed=60, dur=1.5 },
			{ event='move', delay= 2.4, handle_id=308, end_dir=5, pos={98*32, 40*32}, speed=60, dur=1.5 },
			{ event='move', delay= 2.4, handle_id=309, end_dir=5, pos={85*32, 36*32}, speed=60, dur=1.5 },

	    	{ event='kill', delay=3.5, handle_id=307}, 
	    	{ event='kill', delay=3.5, handle_id=308}, 
	    	{ event='kill', delay=3.5, handle_id=309}, 
	    },

	    --镜头转移到刘秀处
	    {
	    	{ event ='camera', delay = 0.1, c_topox = {1936+64,330}, dur=0.5, sdur = 1,style = '',backtime=1},
	    	
	    	{ event='createActor', delay=0.1, handle_id = 1, body=12, pos={1936+64,330}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=47, pos={1876+64,308}, dir=3, speed=340, name_color=0xffffff, name="马武"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=8, pos={1940+64,268}, dir=3, speed=340, name_color=0xffffff, name="王霸"},


	   		{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={1870+64,370}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={1936+64,402}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={1844+32,434-32}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1906+32,466-32}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},

	   		{ event='talk', delay=1.5, handle_id=3, talk='文叔！那是什么？', dur=2 },

	   		{ event='move', delay= 3.8, handle_id=1, end_dir=3, pos={1936+64,330}, speed=300, dur=1.5 },
	   		{ event='talk', delay=3.8, handle_id=1, talk='是丽华！援军到了。', dur=2 },

	   		{ event='move', delay= 6, handle_id=1, end_dir=5, pos={1936+64,330}, speed=300, dur=1.5 },
	   		{ event='talk', delay=6, handle_id=1, talk='天灭莽贼，弟兄们——！随我杀——！', dur=2.5  },
	   		-- { event='talk', delay=7.5, handle_id=3, talk='杀——！', dur=2  },
	   		-- { event='talk', delay=7.5, handle_id=4, talk='杀——！', dur=2  },
	    },

	    --镜头拉远，昆阳看守慌忙逃窜
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 3086,my = 850 },
	    	{ event='zoom', delay=0.2, sValue=1.0, eValue=1.1, dur=0.5}, -- 通过


	    	{ event='createActor', delay=0.1, handle_id = 201, body=26, pos={3094,718}, dir=7, speed=340, name_color=0xffffff, name="昆阳看守"},
	    	{ event='move', delay= 0.2, handle_id=201, end_dir=3, pos={2780,1076}, speed=460, dur=2.5 },
	    	{ event='talk', delay=0.2, handle_id=201, talk='啊——！', dur=3  },

	   		{ event='createActor', delay=0.1, handle_id = 202, body=26, pos={3078,906}, dir=7, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3026,1038}, speed=440, dur=2.5 },

	   		{ event='createActor', delay=0.1, handle_id = 203, body=26, pos={2794,776}, dir=7, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='move', delay= 0.2, handle_id=203, end_dir=3, pos={3638,1166}, speed=460, dur=2.5 },
	   		{ event='talk', delay=0.2, handle_id=203, talk='啊——！', dur=3  },

	   		{ event='createActor', delay=0.1, handle_id = 204, body=26, pos={2668,944}, dir=1, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		-- { event='move', delay= 0.2, handle_id=204, end_dir=3, pos={3638,1166}, speed=440, dur=2.5 },

	   		{ event='createActor', delay=0.1, handle_id = 205, body=26, pos={2780,1076}, dir=7, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='move', delay= 0.2, handle_id=205, end_dir=3, pos={2928,688}, speed=460, dur=2.5 },
	   		{ event='talk', delay=0.2, handle_id=205, talk='啊——！', dur=3  },

	   		{ event='createActor', delay=0.1, handle_id = 206, body=26, pos={3026,1038}, dir=7, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='move', delay= 0.2, handle_id=206, end_dir=3, pos={3544,810}, speed=460, dur=2.5 },

	   		{ event='createActor', delay=0.1, handle_id = 207, body=26, pos={3638,1166}, dir=7, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		-- { event='move', delay= 0.2, handle_id=207, end_dir=3, pos={2794,776}, speed=440, dur=2.5 },
	   		{ event='talk', delay=0.2, handle_id=207, talk='啊——！', dur=3  },

	   		{ event='createActor', delay=0.1, handle_id = 208, body=26, pos={3544,810}, dir=1, speed=340, name_color=0xffffff, name="昆阳看守"},
	   		{ event='move', delay= 0.2, handle_id=208, end_dir=3, pos={2668,944}, speed=460, dur=3.1 },
	   		{ event='talk', delay=0.2, handle_id=208, talk='啊——！', dur=3  },

	   		{ event='effect', handle_id=2001, target_id=202, delay=0.2, pos={10, 10}, effect_id=11049, is_forever = true},
	   		{ event='effect', handle_id=2002, target_id=204, delay=0.2, pos={10, 10}, effect_id=11049, is_forever = true},
	   		{ event='effect', handle_id=2003, target_id=207, delay=0.2, pos={10, 10}, effect_id=11049, is_forever = true},

	   		{ event='playAction', delay = 0.2, handle_id=202, action_id=4, dur=1.5, dir=1, loop=false ,once= true},
	    	{ event='playAction', delay = 0.2, handle_id=204, action_id=4, dur=1.5, dir=5, loop=false ,once= true},
	    	{ event='playAction', delay = 0.2, handle_id=207, action_id=4, dur=1.5, dir=7, loop=false ,once= true},
	    },
	},

	--============================================wuwenbin  主线任务 剧情24 end  =====================================----

	--============================================wuwenbin  主线任务 剧情25 start  =====================================----
	--演员表 1 阴戟  2 刘秀 3 巨无霸 4 阴兴 5 邓奉 101-106 阴家隐士 201-215 狮子，老虎，大象 301-310 新军（尸体）
	['juqing-ux025'] = 
	{
	    --创建角色
	    {
	   		
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={1300,1234}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=54, pos={588,862}, dir=3, speed=340, name_color=0xffffff, name="巨无霸"},

	   		--左边一坨
	   		{ event='createActor', delay=0.1, handle_id = 201, body=40, pos={428,1010}, dir=3, speed=340, name_color=0xffffff, name="狮子"},
	   		{ event='createActor', delay=0.1, handle_id = 202, body=33, pos={496,974}, dir=3, speed=340, name_color=0xffffff, name="老虎"},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=35, pos={428-32,1010-64}, dir=3, speed=340, name_color=0xffffff, name="狼"},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=33, pos={496-32,974-64}, dir=3, speed=340, name_color=0xffffff, name="老虎"},
	   		{ event='createActor', delay=0.1, handle_id = 205, body=40, pos={428-64,1010-128}, dir=3, speed=340, name_color=0xffffff, name="狮子"},
	   		{ event='createActor', delay=0.1, handle_id = 206, body=35, pos={496-64,974-128}, dir=3, speed=340, name_color=0xffffff, name="狼"},


	   		--右边一坨
	   		{ event='createActor', delay=0.1, handle_id = 207, body=40, pos={686,874}, dir=3, speed=340, name_color=0xffffff, name="狮子"},
	   		{ event='createActor', delay=0.1, handle_id = 208, body=33, pos={754,848}, dir=3, speed=340, name_color=0xffffff, name="老虎"},
	   		{ event='createActor', delay=0.1, handle_id = 209, body=35, pos={686-32,874-64}, dir=3, speed=340, name_color=0xffffff, name="狼"},
	   		{ event='createActor', delay=0.1, handle_id = 210, body=33, pos={754-32,848-64}, dir=3, speed=340, name_color=0xffffff, name="老虎"},
	   		{ event='createActor', delay=0.1, handle_id = 211, body=40, pos={686-64,874-128}, dir=3, speed=340, name_color=0xffffff, name="狮子"},
	   		{ event='createActor', delay=0.1, handle_id = 212, body=35, pos={754-64,848-128}, dir=3, speed=340, name_color=0xffffff, name="狼"},

	   		--后边一坨
	   		{ event='createActor', delay=0.1, handle_id = 213, body=40, pos={432,784}, dir=3, speed=340, name_color=0xffffff, name="狮子"},
	   		{ event='createActor', delay=0.1, handle_id = 214, body=33, pos={498,752}, dir=3, speed=340, name_color=0xffffff, name="老虎"},
	   		{ event='createActor', delay=0.1, handle_id = 215, body=39, pos={432-32,784-64}, dir=3, speed=340, name_color=0xffffff, name="大象"},
	   		{ event='createActor', delay=0.1, handle_id = 216, body=35, pos={498-32,752-64}, dir=3, speed=340, name_color=0xffffff, name="狼"},

	   		--新军尸体
	   		{ event='createActor', delay=0.1, handle_id = 301, body=57, pos={590,1046}, dir=6, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 302, body=57, pos={662,1172}, dir=6, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 303, body=57, pos={888,1206}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 304, body=57, pos={1040,1100}, dir=6, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 305, body=57, pos={856,1070}, dir=6, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 306, body=57, pos={1002,1008}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 307, body=57, pos={1230,1270}, dir=6, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 308, body=57, pos={1482,1202}, dir=5, speed=340, name_color=0xffffff, name="新军"},

	   		{ event='playAction', delay = 0.2, handle_id=301, action_id=4, dur=0.1, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=302, action_id=4, dur=0.1, dir=5, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=303, action_id=4, dur=0.1, dir=1, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=304, action_id=4, dur=0.1, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=305, action_id=4, dur=0.1, dir=6, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=306, action_id=4, dur=0.1, dir=7, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=307, action_id=4, dur=0.1, dir=6, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=308, action_id=4, dur=0.1, dir=7, loop=false ,once = true},
	    },

	    --阴戟寻找刘秀
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 2250,my = 1750 },

	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={2294,2066}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='move', delay= 0.2, handle_id=1, end_dir=1, pos={2540,1876}, speed=280, dur=1.5 },
	    	{ event='talk', delay=0.2, handle_id=1, talk='三哥——！', dur=1.5  },

	    	{ event='move', delay= 1.9, handle_id=1, end_dir=7, pos={2194,1776}, speed=280, dur=1.5 },
	    	{ event='talk', delay=2.2, handle_id=1, talk='三哥——！', dur=1.5 },


	    	-- { event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1774-32,2224-32}, speed=300, dur=1.5 },
	    	{ event='showTopTalk', delay=3.5, dialog_id="ux25_1" ,dialog_time = 1.5},

	    	{ event='talk', delay=4.5, handle_id=1, talk='！！！', dur=1.5 },
	    	
	    },   

	    --巨无霸指挥猛兽向刘秀扑过去
	    {
	    	{ event='kill', delay=0.1, handle_id=1}, 
	    	{ event='init_cimera', delay = 0.1,mx= 566,my = 810 },

	    	{ event='playAction', delay = 0.2, handle_id=3, action_id=2, dur=1.5, dir=3, loop=false ,},
	    	{ event='talk', delay=0.2, handle_id=3, talk='上！', dur=1.5 },

	    	{ event = 'camera', delay = 1.5, dur=2,sdur = 0.5,style = '',backtime=1, c_topox = { 1300,1234 } }, -- 移动镜头通过
	    	{ event='move', delay= 0.8, handle_id=201, end_dir=3, pos={788,1174}, speed=240, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=202, end_dir=3, pos={788+64,1174-32}, speed=240, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=207, end_dir=3, pos={788+128,1174-64}, speed=240, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=208, end_dir=3, pos={788+192,1174-96}, speed=240, dur=1.5 },
	    	{ event='talk', delay=0.8, handle_id=201, talk='吼——', dur=1.5  },
	    	{ event='talk', delay=0.8, handle_id=202, talk='吼——', dur=1.5  },
	    	{ event='talk', delay=0.8, handle_id=207, talk='吼——', dur=1.5  },
	    	{ event='talk', delay=0.8, handle_id=208, talk='吼——', dur=1.5  },

	    	{ event='jump', delay= 2.3, handle_id=201, end_dir=3, pos={1196,1170}, speed=120, dur=1.5 ,dir = 3},
	    	{ event='jump', delay= 2.3, handle_id=202, end_dir=5, pos={1368,1146}, speed=120, dur=1.5 ,dir = 3},
	    	{ event='jump', delay= 2.3, handle_id=207, end_dir=7, pos={1398,1298}, speed=120, dur=1.5 ,dir = 3},
	    	{ event='jump', delay= 2.3, handle_id=208, end_dir=1, pos={1238,1310}, speed=120, dur=1.5 ,dir = 3},

	    	{ event='talk', delay=2.3, handle_id=2, talk='！！', dur=1.5 },
	    	{ event='playAction', delay = 2.8, handle_id=201, action_id=2, dur=1.5, dir=3, loop=true ,},
	    	{ event='playAction', delay = 2.8, handle_id=202, action_id=2, dur=1.5, dir=5, loop=true ,},
	    	{ event='playAction', delay = 2.8, handle_id=207, action_id=2, dur=1.5, dir=7, loop=true ,},
	    	{ event='playAction', delay = 2.8, handle_id=208, action_id=2, dur=1.5, dir=1, loop=true ,},
	    	{ event='playAction', delay = 2.8, handle_id=2, action_id=2, dur=1.5, dir=7, loop=true ,},
	    },

	    --阴戟出现
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1870,1552}, dir=6, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='jump', delay= 0.2, handle_id=1, dir = 7 ,end_dir=7, pos={1482,1360}, speed=120, dur=1.5 },

	    	{ event='playAction', delay = 0.8, handle_id=1, action_id=2, dur=1.5, dir=7, loop=false ,},
	    	{ event='playAction', delay = 1, handle_id=207, action_id=4, dur=1.5, dir=7, loop=false ,once = true},

	    	{ event='move', delay= 1.4, handle_id=2, end_dir=3, pos={1300,1234}, speed=300, dur=1.5 },

	    	{ event='talk', delay=1.4, handle_id=2, talk='丽华！！快走！！', dur=1 ,emote ={ a=48} },

	    	{ event='jump', delay= 2.2, handle_id=201, dir=3, end_dir=3, pos={1448,1320}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2.2, handle_id=202, dir=3, end_dir=5, pos={1518,1328}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2.2, handle_id=208, dir=3, end_dir=1, pos={1456,1398}, speed=120, dur=1.5 },
	    	{ event='talk', delay=2.2, handle_id=201, talk='吼——', dur=1.5  },
	    	{ event='talk', delay=2.2, handle_id=202, talk='吼——', dur=1.5  },
	    	{ event='talk', delay=2.2, handle_id=208, talk='吼——', dur=1.5  },



	    	{ event='playAction', delay = 2.7, handle_id=201, action_id=2, dur=1.5, dir=3, loop=false ,},
	    	{ event='playAction', delay = 2.7, handle_id=202, action_id=2, dur=1.5, dir=5, loop=false ,},
	    	{ event='playAction', delay = 2.7, handle_id=208, action_id=2, dur=1.5, dir=1, loop=false ,},
	    

	    	{ event='talk', delay=3, handle_id=1, talk='啊——', dur=1.5  },
	    	{ event='playAction', delay = 3, handle_id=1, action_id=4, dur=1.5, dir=7, loop=false ,once = true},

	    	{ event='move', delay= 2.7, handle_id=2, end_dir=3, pos={1390,1298}, speed=220, dur=1.5 },
	    	{ event='playAction', delay = 3.4, handle_id=2, action_id=2, dur=1.5, dir=3, loop=false ,},
	    	{ event='talk', delay=2.7, handle_id=2, talk='丽华——！', dur=2.5 ,},

	    	{ event='playAction', delay = 3.6, handle_id=201, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 3.6, handle_id=202, action_id=4, dur=1.5, dir=5, loop=false ,once = true},
	    	{ event='playAction', delay = 3.6, handle_id=208, action_id=4, dur=1.5, dir=1, loop=false ,once = true},
	    },

	    --野兽再发动一波攻势
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 566,810 } }, -- 移动镜头通过
	    	{ event='talk', delay=0.6, handle_id=3, talk='再给我上！[a]', dur=2.5 ,emote = { a = 24} },

	    	{ event = 'camera', delay = 1.5, dur=2,sdur = 0.5,style = '',backtime=1, c_topox = { 1300,1234 } }, -- 移动镜头通过

	    	{ event='move', delay= 1, handle_id=203, end_dir=3, pos={788,1174}, speed=120, dur=1.5 },
	    	{ event='move', delay= 1, handle_id=204, end_dir=3, pos={788+64,1174-32}, speed=120, dur=1.5 },
			{ event='move', delay= 1, handle_id=206, end_dir=3, pos={788+128,1174-64}, speed=120, dur=1.5 },

	    	{ event='move', delay= 1.5, handle_id=209, end_dir=3, pos={788,1174}, speed=120, dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=210, end_dir=3, pos={788+64,1174-32}, speed=120, dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=211, end_dir=3, pos={788+128,1174-64}, speed=120, dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=212, end_dir=3, pos={788+192,1174-96}, speed=120, dur=1.5 },

	    	{ event='jump', delay= 2, handle_id=203, dir= 3, end_dir=3, pos={1362-32,1266-32}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2, handle_id=204, dir= 3, end_dir=5, pos={1418+32,1266-32}, speed=120, dur=1.5 },
	    	-- { event='move', delay= 1, handle_id=205, end_dir=7, pos={1418,1328}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2, handle_id=206, dir= 3, end_dir=1, pos={1362-32,1328+32}, speed=120, dur=1.5 },

	    	{ event='jump', delay= 2.5, handle_id=209, dir= 3, end_dir=3, pos={1456,1324}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2.5, handle_id=210, dir= 3, end_dir=5, pos={1524,1324}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2.5, handle_id=211, dir= 3, end_dir=7, pos={1524,1398}, speed=120, dur=1.5 },
	    	{ event='jump', delay= 2.5, handle_id=212, dir= 3, end_dir=1, pos={1456,1398}, speed=120, dur=1.5 },

	    	{ event='playAction', delay = 2.8, handle_id=203, action_id=2, dur=0.5, dir=3, loop=true ,},
	    	{ event='playAction', delay = 2.8, handle_id=204, action_id=2, dur=0.5, dir=5, loop=true ,},
	    	-- { event='playAction', delay = 2.8, handle_id=205, action_id=2, dur=1.5, dir=7, loop=true ,},
	    	{ event='playAction', delay = 2.8, handle_id=206, action_id=2, dur=0.5, dir=1, loop=true ,},

	    	{ event='playAction', delay = 3.3, handle_id=209, action_id=2, dur=0.5, dir=3, loop=true ,},
	    	{ event='playAction', delay = 3.3, handle_id=210, action_id=2, dur=0.5, dir=5, loop=true ,},
	    	{ event='playAction', delay = 3.3, handle_id=211, action_id=2, dur=0.5, dir=7, loop=true ,},
	    	{ event='playAction', delay = 3.3, handle_id=212, action_id=2, dur=0.5, dir=1, loop=true ,},

	    	{ event='talk', delay=3, handle_id=2, talk='啊——', dur=1.5  },
	    	{ event='playAction', delay = 2.8, handle_id=2, action_id=4, dur=1.5, dir=3, loop=false , once = true},

	    },

	    --阴兴邓奉赶到
	    {
	    	{ event = 'camera', delay = 0.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 2172,1700 } }, -- 移动镜头通过

	    	{ event='createActor', delay=0.1, handle_id = 4, body=20, pos={2388,1906}, dir=7, speed=340, name_color=0xffffff, name="阴兴"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=29, pos={2444,1868}, dir=7, speed=340, name_color=0xffffff, name="邓奉"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=28, pos={2388+64,1906+32}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=28, pos={2388+128,1906+64}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=28, pos={2444+64,1868+32}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=28, pos={2444+128,1868+64}, dir=7, speed=340, name_color=0xffffff, name="阴家隐士"},


	    	{ event='move', delay= 0.8, handle_id=4, end_dir=7, pos={2128,1776}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=5, end_dir=7, pos={2188,1742}, speed=300, dur=1.5 },

	    	{ event='move', delay= 0.8, handle_id=101, end_dir=7, pos={2120,1890}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=102, end_dir=7, pos={2120+64,1890-32}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=103, end_dir=7, pos={2120+128,1890-64}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.8, handle_id=104, end_dir=7, pos={2120+192,1890-96}, speed=300, dur=1.5 },

	    	{ event='talk', delay=2, handle_id=4, talk='姐姐——！', dur=1.5 ,},
	    	{ event='talk', delay=3.8, handle_id=5, talk='刘秀！', dur=1.5 ,},
	    },

	    --弓箭手放箭，野兽死亡
	    {
	    	{ event='playAction', delay = 0.1, handle_id=101, action_id=2, dur=1.5, dir=7, loop=false ,},
	    	{ event='playAction', delay = 0.1, handle_id=102, action_id=2, dur=1.5, dir=7, loop=false ,},
	    	{ event='playAction', delay = 0.1, handle_id=103, action_id=2, dur=1.5, dir=7, loop=false ,},
	    	{ event='playAction', delay = 0.1, handle_id=104, action_id=2, dur=1.5, dir=7, loop=false ,},

	    	{ event = 'camera', delay = 1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1300,1234 } }, -- 移动镜头通过
	    	
	    	-- { event='playAction', delay = 3, handle_id=1, action_id=2, dur=1.5, dir=3, loop=false ,},
	    	{ event='playAction', delay = 1.5, handle_id=203, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 1.5, handle_id=204, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 1.5, handle_id=206, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 1.5, handle_id=209, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 1.5, handle_id=210, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 1.5, handle_id=211, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 1.5, handle_id=212, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	    },

	    --巨无霸逃跑
    	{
    		{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 566,810 } }, -- 移动镜头通过
	    	{ event='talk', delay=0.8, handle_id=3, talk='哼！', dur=1.5 ,},

	    	{ event='move', delay= 2.5, handle_id=3, end_dir=5, pos={212,628}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2.5, handle_id=205, end_dir=5, pos={214,692}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2.5, handle_id=213, end_dir=5, pos={214,692}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2.5, handle_id=214, end_dir=5, pos={272,656}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2.5, handle_id=215, end_dir=5, pos={214,692}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2.5, handle_id=216, end_dir=5, pos={272,656}, speed=300, dur=1.5 },

	    	{ event='kill', delay=3.5, handle_id=3}, 
	    	{ event='kill', delay=3.5, handle_id=205}, 
	    	{ event='kill', delay=3.5, handle_id=213}, 
	    	{ event='kill', delay=3.5, handle_id=214}, 
	    	{ event='kill', delay=3.5, handle_id=215}, 
	    	{ event='kill', delay=3.5, handle_id=216}, 


	    	{ event = 'camera', delay = 3.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 2172,1700 } }, -- 移动镜头通过
	    	{ event='talk', delay=5, handle_id=4, talk='别让他跑了！', dur=2 ,},

	    	{ event='move', delay= 6, handle_id=4, end_dir=7, pos={1720,1510}, speed=300, dur=1.5 },
	    	{ event='move', delay= 6, handle_id=5, end_dir=7, pos={1786,1494}, speed=300, dur=1.5 },

	    	{ event='move', delay= 6.2, handle_id=101, end_dir=7, pos={1720+64,1510+32}, speed=300, dur=1.5 },
	    	{ event='move', delay= 6, handle_id=102, end_dir=7, pos={1720+128,1510+64}, speed=300, dur=1.5 },

	    	{ event='move', delay= 6, handle_id=103, end_dir=7, pos={1786+64,1494+32}, speed=300, dur=1.5 },
	    	{ event='move', delay= 6.2, handle_id=104, end_dir=7, pos={1786+128,1494+64}, speed=300, dur=1.5 },
    	},
	},

	--============================================wuwenbin  主线任务 剧情25 end  =====================================----

	--============================================wuwenbin  主线任务 剧情26 start  =====================================----
	--演员表 
	['juqing-ux026'] = 
	{
	    --拔箭
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 1198,my = 648 },
	    	
	    	-- { event='screenImage', handle_id=1, delay = 0.2, outtime = 4,img="nopack/juqing/bajian.png", adapt="width"},	--height，和width
	    	{ event='screenImage', delay = 0.2, handle_id=1, img="nopack/juqing/bajian.jpg",adapt="width", black=true, outtime=4, start_pos={0.6,0.5},  movetime=1.3, end_pos = {0.5,0.5}, },

	    	-- { event='imgMoveAction', delay = 2, handle_id=1, dur=2, endx=0.2, endy=0.5, movetime=2,} ,--移动事件

	    	-- { event='init_cimera', delay = 3.8,mx= 1198,my = 648 },
	    	{ event = 'changeRGBA',delay=3,dur=1,txt = "",cont_time = 0.8},
	    	{ event='screenImage', handle_id=2, delay = 3.5, outtime = 6,img="nopack/juqing/jiantou.png", adapt="width"},	--height，和width
	    	-- { event='screenImage', delay = 2, handle_id=2, img="nopack/juqing/jiantou.png",adapt="width", outtime=4, startx=0.2, starty=0.5, movetime=1, endx=0.5, endy=0.5},
	    	{ event='scaleAction', delay = 3.8, handle_id=2, dur=1, scale=1.2},


	    	-- { event='init_cimera', delay = 3.8,mx= 1198,my = 648 },
	    	-- { event='screenImage', handle_id=3, delay = 7.8, outtime = 8,img="nopack/juqing/duishi.png", adapt="width"},	--height，和width
	    	{ event = 'changeRGBA',delay = 6.5,dur=1,txt = "",cont_time = 0.8},
	    	{ event='screenImage', delay = 7, handle_id=3, img="nopack/juqing/duishi.png",adapt="width", outtime=10,},

	    	{ event='showTopTalk', delay=9, dialog_id="ux26_1" ,dialog_time = 3.5},
	    },		
	},

	--============================================wuwenbin  主线任务 剧情26 end  =====================================----

	--============================================wuwenbin  主线任务 剧情28 start  =====================================----

	--演员表 1 丽华  2 刘秀 3 邓禹  4 阴兴 5 邓奉 6 琥珀 7 柳氏 101-106 家眷 
	['juqing-ux028'] = 
	{
	    --创建角色
	    {
	   		
	   		{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={434,433}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=52, pos={366,459}, dir=7, speed=340, name_color=0xffffff, name="琥珀"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=37, pos={369,364}, dir=3, speed=340, name_color=0xffffff, name="柳氏"},
	    },

	    --丽华和大嫂聊天
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 355,my = 300 },


	    	{ event='talk', delay=0.1, handle_id=1, talk='我不顾大哥的劝阻，执意嫁给刘秀，想必是伤了他的心……', dur=3 },
	    	{ event='talk', delay=3.4, handle_id=7, talk='[a]终身大事，终究是要自己做主的。', dur=2.5 ,emote = { a = 3}},
	    	{ event='talk', delay=6.2, handle_id=7, talk='你大哥他只是想妹妹过得好……', dur=2 },
	    },   

	    --阴兴出场
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux28_1" ,dialog_time = 2},

	    	{ event='createActor', delay=2.2, handle_id = 4, body=20, pos={211,239}, dir=6, speed=340, name_color=0xffffff, name="阴兴"},
	    	{ event='createActor', delay=2.2, handle_id = 5, body=29, pos={243,180}, dir=6, speed=340, name_color=0xffffff, name="邓奉"},
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=3, pos={302,399}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=3, pos={305,342}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 1.4, handle_id=2, end_dir=3, pos={1300,1234}, speed=300, dur=1.5 },

	    	-- { event='move', delay= 1.4, handle_id=2, end_dir=3, pos={1300,1234}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 1.4, handle_id=2, end_dir=3, pos={1300,1234}, speed=300, dur=1.5 },
	    	
	    	{ event='talk', delay=1.5, handle_id=1, talk='我去向大哥拜别。', dur=2 },
	    	{ event='move', delay= 3, handle_id=1, end_dir=7, pos={302,399}, speed=300, dur=1.5 },
	    	{ event='move', delay= 3.5, handle_id=4, end_dir=3, pos={302-64,399-32}, speed=300, dur=1.5 },

	    	{ event='move', delay= 3.5, handle_id=5, end_dir=5, pos={305,342}, speed=300, dur=1.5 },
	    	{ event='move', delay= 3.5, handle_id=7, end_dir=5, pos={369,364}, speed=300, dur=1.5 },

	    	{ event='talk', delay=3.8, handle_id=4, talk='大哥说……', dur=1.5 ,},
	    	{ event='talk', delay=5.6, handle_id=4, talk='让姐姐不必去行礼了。', dur=2 },
	    	{ event='talk', delay=7.9, handle_id=1, talk='！！', dur=1.5 },
	    	{ event='talk', delay=9.7, handle_id=1, talk='母亲不在，长兄为父，我理应拜别才是。', dur=2.5 ,},
	    	{ event='talk', delay=12.5, handle_id=4, talk='姐姐你还是不要违背他的意思了。', dur=2.5 },
	    	{ event='talk', delay=15.3, handle_id=1, talk='大哥……他真的这么不想见我？', dur=2.5 },

	    	{ event='playBgMusic', delay=7.9, id = 2 ,loop = true},
	    },

	    --丽华和大嫂拜别
	    {
	    
	    	{ event='talk', delay=0.1, handle_id=4, talk='姐姐不要哭，你一哭，脸上的妆都花了。', dur=2.5 },
	    	{ event='talk', delay=2.9, handle_id=1, talk='谁说我哭了？我才没有。', dur=2 ,},


	    	-- { event='move', delay= 1.4, handle_id=2, end_dir=3, pos={1300,1234}, speed=300, dur=1.5 },
	    	-- { event='move', delay= 1.4, handle_id=2, end_dir=3, pos={1300,1234}, speed=300, dur=1.5 },

	    	{ event='move', delay= 5, handle_id=1, end_dir=1, pos={302,399}, speed=300, dur=1.5 },
	    	{ event='talk', delay=5.2, handle_id=1, talk='长嫂如母，那这礼对嫂嫂行也是使得的！丽华拜别了。', dur=3 },
	    	{ event='talk', delay=8.5, handle_id=7, talk='好妹妹……', dur=1.5 ,},
	    },

	    --恢复平常音乐
	    {
	      	{ event='backSceneMusic', delay = 0}, 
	    },

	    --丽华看到刘秀
	    {
	    	--
	    	{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={1045,917}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=41, pos={729,878}, dir=2, speed=340, name_color=0xffffff, name="家眷"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=19, pos={727,948}, dir=2, speed=340, name_color=0xffffff, name="家眷"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=41, pos={787,1008}, dir=1, speed=340, name_color=0xffffff, name="家眷"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=19, pos={849,1043}, dir=1, speed=340, name_color=0xffffff, name="家眷"},

	   		{ event='createActor', delay=0.1, handle_id = 105, body=19, pos={1072,725}, dir=5, speed=340, name_color=0xffffff, name="家眷"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=41, pos={1138,751}, dir=5, speed=340, name_color=0xffffff, name="家眷"},
	   		{ event='createActor', delay=0.1, handle_id = 107, body=41, pos={1167,819}, dir=6, speed=340, name_color=0xffffff, name="家眷"},
	   		{ event='createActor', delay=0.1, handle_id = 108, body=19, pos={1165,883}, dir=6, speed=340, name_color=0xffffff, name="家眷"},

	   		{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={911,816}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=3, pos={855,770}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=3, pos={789,817}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=3, pos={917,751}, speed=280, dur=1.5 },

	    	{ event = 'camera', delay = 0.1, dur=1,sdur = 1,style = '',backtime=1, c_topox = { 901,793 } }, -- 移动镜头通过
	    },

	    --刘秀上前跟丽华说话
	    {
	   		{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={972,850}, speed=300, dur=1.5 },

	   		{ event='talk', delay=0.2, handle_id=2, talk='丽华——', dur=1.5 },

	   		{ event = 'effect', handle_id=1001, target_id = 1,delay = 2, pos = {0, 140}, effect_id = 20009, dx = 0,dy = 30,is_forever = true},	--红心特效
	    	{ event = 'removeEffect', delay = 4, handle_id=1001, effect_id=20012},

	    	{ event = 'effect', handle_id=1002, target_id = 2,delay = 2, pos = {0, 140}, effect_id = 20009, dx = 0,dy = 30,is_forever = true},	--红心特效
	    	{ event = 'removeEffect', delay = 4, handle_id=1002, effect_id=20012},

	    	{ event='talk', delay=4.5, handle_id=5, talk='姐夫，你一定要待我姐姐好……', dur=2.5 },
	    	{ event='talk', delay=7.3, handle_id=5, talk='姐姐最爱口是心非，可待姐夫你的一片心却是世间少有……', dur=3 },

	    	{ event='move', delay= 10.3, handle_id=1, end_dir=7, pos={911,816}, speed=300, dur=1.5 },
	    	
	    	{ event='talk', delay=10.3, handle_id=1, talk='不要说了，话这么多……', dur=1.5 ,},
	    	{ event='talk', delay=12.1, handle_id=2, talk='呵呵……', dur=1.5 },

	    	{ event='move', delay= 13.7, handle_id=1, end_dir=3, pos={911,816}, speed=300, dur=1.5 },
	    	{ event='talk', delay=13.7, handle_id=1, talk='你不要理他……', dur=2 },
	    	{ event='talk', delay=16, handle_id=2, talk='丽华，只能给你一个这样的婚礼，委屈你了……', dur=2.5 },
	    },

	    --邓禹喊话
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux28_2" ,dialog_time = 2},

	    	{ event='move', delay= 0.2, handle_id=1, end_dir=5, pos={911,816}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=5, pos={972,850}, speed=300, dur=1.5 },
		},

	    --邓禹出现
	    {
	    	{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={590,1046}, dir=6, speed=340, name_color=0xffffff, name="邓禹"},
	    	
	    	{ event='move', delay= 0.2, handle_id=3, end_dir=1, pos={848,915}, speed=300, dur=1.5 },

	    	{ event='talk', delay=0.5, handle_id=1, talk='阿禹！', dur=1.5 },
	    	{ event='talk', delay=0.5, handle_id=5, talk='小叔叔！', dur=1.5 },
	    	{ event='talk', delay=2.3, handle_id=2, talk='阿禹，你回来了，今日我与丽华成亲，请到府上喝杯喜酒。', dur=2.5 },
	    	{ event='talk', delay=5.1, handle_id=3, talk='！！', dur=1.5 },
	    	{ event='talk', delay=6.9, handle_id=3, talk='你们……', dur=1.5 },

	    	{ event = 'effect', handle_id=1001, target_id = 3,delay = 8.5, pos = {0, 120}, effect_id = 20011, dx = 0,dy = 30,is_forever = true},	--心碎特效
	    	{ event = 'removeEffect', delay = 10, handle_id=1001, effect_id=20012},

	    	{ event='talk', delay=10.3, handle_id=3, talk='丽华，我回来得太晚了，是不是？', dur=2 },
	    	{ event='talk', delay=12.6, handle_id=1, talk='你能平安回来，我们很开心……', dur=2.5 },
	    },

	    --丽华想走了
	    {
	    	{ event='move', delay= 0.5, handle_id=1, end_dir=3, pos={911,816}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.5, handle_id=2, end_dir=7, pos={972,850}, speed=300, dur=1.5 },
	    	{ event='talk', delay=0.5, handle_id=1, talk='三哥，我们走吧。', dur=2 },

	    	{ event='move', delay= 2.7, handle_id=1, end_dir=3, pos={1580,1167}, speed=300, dur=1.5 },
	    	{ event='move', delay= 2.7, handle_id=2, end_dir=3, pos={1580,1167}, speed=300, dur=1.5 },


	    	{ event='move', delay= 3.2, handle_id=3, end_dir=3, pos={879,946}, speed=300, dur=1.5 },
	    	{ event='move', delay= 3.2, handle_id=5, end_dir=7, pos={939,984}, speed=120, dur=1.5 },
	    	{ event='talk', delay=3.7, handle_id=5, talk='小叔叔，别……', dur=2 },

	    	{ event = 'effect', handle_id=1001, target_id = 3,delay = 5.7, pos = {0, 140}, effect_id = 20011, dx = 0,dy = 30,is_forever = true},	--心碎特效
	    	{ event = 'removeEffect', delay = 7.2, handle_id=1001, effect_id=20012},

	    	{ event='kill', delay=8, handle_id=1}, 
	    	{ event='kill', delay=8, handle_id=2}, 
	    	{ event='kill', delay=8, handle_id=3}, 
	    	{ event='kill', delay=8, handle_id=4}, 
	    	{ event='kill', delay=8, handle_id=5}, 
	    	{ event='kill', delay=8, handle_id=6}, 
	    	{ event='kill', delay=8, handle_id=7}, 

	    	{ event='kill', delay=8, handle_id=101}, 
	    	{ event='kill', delay=8, handle_id=102}, 
	    	{ event='kill', delay=8, handle_id=103}, 
	    	{ event='kill', delay=8, handle_id=104}, 
	    	{ event='kill', delay=8, handle_id=105}, 
	    	{ event='kill', delay=8, handle_id=106}, 
	    	{ event='kill', delay=8, handle_id=107}, 
	    	{ event='kill', delay=8, handle_id=108}, 
	    },

	    --转移镜头，丽华刘秀移动
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 1579,my = 1108 },

	    	{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={1323,1070}, dir=3, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={1352,1105}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},

	    	{ event='move', delay= 0.2, handle_id=1, end_dir=7, pos={1449,1133}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=7, pos={1383,1170}, speed=300, dur=1.5 },
			{ event='showTopTalk', delay=0.3, dialog_id="ux28_3" ,dialog_time = 1.5},
		},

		--阴兴出现
		{
	    	{ event='createActor', delay=0.1, handle_id = 4, body=20, pos={1224,977}, dir=6, speed=340, name_color=0xffffff, name="阴兴"},
	    	{ event='move', delay= 0.2, handle_id=4, end_dir=3, pos={1311,1050}, speed=300, dur=1.5 },


	    	{ event='talk', delay=1, handle_id=4, talk='姐姐就算嫁入你刘家为妇，也还是阴家的人。', dur=3 },
	    	{ event='talk', delay=4.3, handle_id=4, talk='若是今后有什么地方对不住她……莫怪我阴家对你不客气。', dur=3},

	    	-- { event='move', delay= 1, handle_id=1, end_dir=3, pos={788,1174}, speed=120, dur=1.5 },
	    	{ event='talk', delay=6.6, handle_id=1, talk='[a]', dur=1.5 ,emote={ a = 34} },
	    	
	    	{ event='move', delay= 8.1, handle_id=2, end_dir=7, pos={1382,1102}, speed=340, dur=1.5 },
	    	{ event='talk', delay=8.5, handle_id=2, talk='秀何其有幸……', dur=2 },

	    	{ event='move', delay= 10.8, handle_id=2, end_dir=3, pos={1382,1102}, speed=340, dur=3 },
	    	{ event='talk', delay=10.8, handle_id=2, talk='娶妻丽华，至宝也，此生决不相负。', dur=2.5 },
	    },


	    --阴家传出音乐
	    {
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=7, pos={1311,1050}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1382,1102}, speed=340, dur=9 }, --借用dur作为结束控制

	    	{ event='talk', delay=0.1, handle_id=1, talk='！', dur=1.5 },
	    	{ event='talk', delay=0.1, handle_id=2, talk='！', dur=1.5 },

	    	{ event='playBgMusic', delay=0.1, id = 1 ,loop = true},

	    	{ event='showTopTalk', delay=2, dialog_id="ux28_4" ,dialog_time = 3},

	    	{ event='talk', delay=5, handle_id=1, talk='大哥他……并没怪我……', dur=3 },
	    },
	},

	--============================================wuwenbin  主线任务 剧情28 end  =====================================----
--============================================sunluyao  主线任务 剧情29 start  =====================================----

	['juqing-ux029'] =
	{
		{

	   		{ event='init_cimera', delay = 0.5,mx=553 ,my = 450},		
			{event='changeRGBA', delay=0.1, txt="喧闹过后，夜深人寂……#r刘秀脱去玄色婚服，里边竟是白色缟素丧服！",cont_time=5, light_time=0.5, txt_time=0.5, black_time=0.1},
		},
		{
	    	{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={355,461}, dir=3, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={473,505}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='talk', delay=3, handle_id=1, talk='!', dur=1.8 },
	    },
	    {
	    	{ event='showTopTalk', delay=2, dialog_id="ux29_1" ,dialog_time = 3},
	    },
		{
			{ event='playBgMusic', delay=0.1, id = 2 ,loop = true},	  		
	    	{ event='talk', delay=0.1, handle_id=1, talk='三哥……', dur=1.8,  },
	    	{ event='talk', delay=2.5, handle_id=1, talk='[a]呜呜……', dur=1.8, emote={a=46},},

	    	{ event='move', delay= 5, handle_id=2, end_dir=7, pos={473-50,505-20}, speed=300, dur=1.5 },
	    	{ event='talk', delay=5.1, handle_id=2, talk='不能哭……', dur=1.8,  },
	    	{ event='talk', delay=7.5, handle_id=2, talk='不能……', dur=4.8,  },	  
			{event='changeRGBA', delay=9.5, txt="洞房花烛夜，烛泪相伴到天明！",cont_time=3, light_time=0.5, txt_time=0.5, black_time=0.1},
		},	 	   
	},
--============================================sunluyao  主线任务 剧情29 end  =====================================----
		--============================================hanbaobao  主线任务 剧情30 start  =====================================----

	--演员表 1 刘玄 2 赵姬 101 冒心特效
	['juqing-ux030'] = 
	{
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 5549,my = 301 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=24, pos={5613,436}, dir=6, speed=340, name_color=0xffffff, name="刘玄"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=37, pos={5357,500}, dir=1, speed=340, name_color=0xffffff, name="赵姬"},
	    },

	    --刘玄和赵姬，两人BB
	    {

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=2, pos={5489,428}, speed=300, dur=0.8 },

	    	{ event='talk', delay=0.2, handle_id=2, talk='陛下——', dur=1.1 },
	    	{ event='talk', delay=1.6, handle_id=2, talk='怎么闷闷不乐的，是为河北使节的事烦心么？', dur=3.5 },
			
	    	{ event='talk', delay=5.3, handle_id=1, talk='哎……', dur=1.1 },

	    	{ event='move', delay= 6.7, handle_id=1, end_dir=3, pos={5655,470}, speed=300, dur=0.8 },
			{ event='talk', delay=6.7, handle_id=1, talk='河北使节未定，如今不知有谁能信任。', dur=3.5 },

			{ event='move', delay= 10.5, handle_id=2, end_dir=3, pos={5533,443}, speed=300, dur=0.8 },
	    	{ event='talk', delay=10.5, handle_id=2, talk='妾以为，武信侯刘秀倒是可信。', dur=2.5 },

	    	{ event='move', delay= 13.3, handle_id=1, end_dir=7, pos={5655,470}, speed=300, dur=0.8 },
	    	{ event='talk', delay=13.3, handle_id=1, talk='谁教你说这话的？阴丽华？', dur=2 },
	    	{ event='talk', delay=15.6, handle_id=2, talk='没有呀，是听爹爹和门客们说的。', dur=2.5 },
	    	{ event='talk', delay=18.4, handle_id=1, talk='看来是朕多心了，以为丽华来求过你……', dur=3.5 },

	    },   
	    --刘玄和赵姬，两人BB
	    {
	    	{ event='talk', delay=0.4, handle_id=2, talk='丽华姐姐没有同我说过这些。', dur=2.5 },
	    	{ event='talk', delay=3.3, handle_id=2, talk='不过她和武信侯的感情，让我觉得……', dur=3 },
	    	{ event='talk', delay=6.7, handle_id=1, talk='嗯？觉得什么？', dur=1.5 },
	    	{ event='talk', delay=8.6, handle_id=2, talk='她告诉过我，她和武信侯是“死生契阔，与子成说”。', dur=3.5 },
	    	{ event='talk', delay=12.5, handle_id=2, talk='陛下，你说咱们会不会和他们一样，白头到老，不离不弃？', dur=4 },
	    	{ event='talk', delay=16.9, handle_id=1, talk='呵呵……当然会。', dur=1.5 },
	    	{ event='move', delay= 17, handle_id=1, end_dir=6, pos={5583,443}, speed=300, dur=0.8 },
	    	{ event='move', delay= 17, handle_id=2, end_dir=1, pos={5533,443}, speed=300, dur=0.8 },
	    	{ event='talk', delay=18.8, handle_id=2, talk='陛下[a]', dur=1.1 ,emote ={ a=26} },

	        { event='effect', handle_id=101, target_id=2, delay =19 , pos={20,150}, effect_id=20009, is_forever = true},--冒心心
	        { event = 'removeEffect', delay = 22, handle_id=101, effect_id=20009},

	    },   
        --刘玄和赵姬，两人BB
	    {
	    	{ event='talk', delay=0.3, handle_id=2, talk='陛下，您还是不要让武信侯去河北了。', dur=2 },
	    	{ event='talk', delay=2.6, handle_id=1, talk='为什么？', dur=1.5 },
	    	{ event='talk', delay=4.4, handle_id=2, talk='妾不想武信候和阴姐姐分开。', dur=2 },
	    	{ event='talk', delay=6.7, handle_id=2, talk='阴姐姐对武信候一往情深，若是让他们分开，实在是太残忍了……', dur=3.5 },	    	
	    	{ event='talk', delay=10.5, handle_id=1, talk='你说得对。', dur=1.5 },

	    },   


	    --刘玄和赵姬，两人BB
	    {
			--{ event='move', delay= 0.2, handle_id=1, end_dir=1, pos={2106,2790}, speed=300, dur=0.8 },
	    	{ event='talk', delay=0.3, handle_id=1, talk='刘秀是个可用之才，就让他去河北又有何妨？', dur=3 },
	    	{ event='talk', delay=3.6, handle_id=1, talk='任他飞，还是收回来，线都在我的手上……', dur=3 },

	    },  

	},

	--============================================hanbaobao  主线任务 剧情30 end  =====================================----

	--============================================wuwenbin  主线任务 剧情31 start  =====================================----

	--演员表 1 阴戟 2 刘秀 3 冯异 4 王霸 5 祭遵 6 姚期 101-108 汉军将士 201-212 难民 301-310 难民尸体
	['juqing-ux031'] = 
	{
	    --创建角色 
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1560,944}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={1488,914}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},

	   		{ event='createActor', delay=0.1, handle_id = 3, body=34, pos={1426,980}, dir=1, speed=340, name_color=0xffffff, name="冯异"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=8, pos={1488,1004}, dir=1, speed=340, name_color=0xffffff, name="王霸"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=47, pos={1358,1044}, dir=1, speed=340, name_color=0xffffff, name="祭遵"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=43, pos={1420,1064}, dir=1, speed=340, name_color=0xffffff, name="姚期"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={1266,1078}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={1266+64,1078+32}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={1266+128,1078+64}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},

	   		{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1240,1142}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=25, pos={1240+64,1142+32}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=25, pos={1240+128,1142+64}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},

	   		--难民尸体
	   		{ event='createActor', delay=0.1, handle_id = 301, body=45, pos={58*32,23*32}, dir=7, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 302, body=46, pos={59*32,28*32}, dir=7, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 303, body=45, pos={56*32,29*32}, dir=7, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 304, body=46, pos={42*32,28*32}, dir=7, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 305, body=45, pos={36*32,37*32}, dir=7, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 306, body=45, pos={45*32,36*32}, dir=7, speed=340, name_color=0xffffff, name="难民"},

	   		{ event='playAction', delay = 0.2, handle_id=301, action_id=4, dur=0.3, dir=5, loop=false , once=true },
	   		{ event='playAction', delay = 0.2, handle_id=302, action_id=4, dur=0.3, dir=3, loop=false , once=true },
	   		{ event='playAction', delay = 0.2, handle_id=303, action_id=4, dur=0.3, dir=1, loop=false , once=true },
	   		{ event='playAction', delay = 0.2, handle_id=304, action_id=4, dur=0.3, dir=7, loop=false , once=true },
	   		{ event='playAction', delay = 0.2, handle_id=305, action_id=4, dur=0.3, dir=2, loop=false , once=true },
	   		{ event='playAction', delay = 0.2, handle_id=306, action_id=4, dur=0.3, dir=6, loop=false , once=true },
	    },

	    --众人行军中
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 1478,my = 922 },
	    	{ event ='camera', delay = 0.1, target_id = 2, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={1722,626}, speed=300, dur=0.8 },

	    	{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={1712,790}, speed=300, dur=0.8 },
	    	{ event='move', delay= 1.4, handle_id=1, end_dir=2, pos={2424,862}, speed=240, dur=0.8 },	--阴戟跑开

	    	{ event='talk', delay=2, handle_id=2, talk='等到了邯郸，要换辎车……', dur=1.5 },

	    	{ event='move', delay= 0.1, handle_id=3, end_dir=1, pos={1680,684}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=1, pos={1748,722}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=1, pos={1646,752}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=1, pos={1706,786}, speed=300, dur=0.8 },

	    	{ event='move', delay= 0.1, handle_id=101, end_dir=1, pos={1548,782}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=102, end_dir=1, pos={1548+64,782+32}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=103, end_dir=1, pos={1548+128,782+64}, speed=300, dur=0.8 },

	    	{ event='move', delay= 0.1, handle_id=104, end_dir=1, pos={1515,848}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=105, end_dir=1, pos={1515+64,848+32}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=106, end_dir=1, pos={1515+128,848+64}, speed=300, dur=0.8 },

	    	
	    },   

	    --刘秀听见嘈杂声
	    {
	    	{ event='kill', delay=0.5, handle_id=1}, 
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux31_1" ,dialog_time = 2},

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={1722,626}, speed=300, dur=0.8 },
	    	{ event='talk', delay=2, handle_id=2, talk='什么事！', dur=1.5 },

	    	{ event='move', delay= 3.8, handle_id=4, end_dir=7, pos={1776,658}, speed=300, dur=0.8 },
	    	{ event='talk', delay= 4.3, handle_id=4, talk='阴将军在散粮食！', dur=1.5 },

	    	{ event='move', delay= 0.1, handle_id=3, end_dir=3, pos={1680,684}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1748,722}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=3, pos={1646,752}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=3, pos={1706,786}, speed=300, dur=0.8 },

	    	{ event='move', delay= 0.1, handle_id=101, end_dir=3, pos={1548,782}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=102, end_dir=3, pos={1548+64,782+32}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=103, end_dir=3, pos={1548+128,782+64}, speed=300, dur=0.8 },

	    	{ event='move', delay= 0.1, handle_id=104, end_dir=3, pos={1515,848}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=105, end_dir=3, pos={1515+64,848+32}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.1, handle_id=106, end_dir=3, pos={1515+128,848+64}, speed=300, dur=0.8 },

	    },

	    --镜头给丽华
	    {
	    	{ event = 'camera', delay = 0.1, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 2394,790 } }, -- 移动镜头通过

	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={2418,842}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},

	    	{ event='createActor', delay=0.1, handle_id = 201, body=45, pos={2414+32,758-32}, dir=5, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 202, body=46, pos={2488+32,780-32}, dir=5, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=45, pos={2548+32,822-32}, dir=5, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=46, pos={2516+32,876}, dir=7, speed=340, name_color=0xffffff, name="难民"},

	    	{ event='talk', delay=0.2, handle_id=203, talk='给点吃的罢', dur=2.5 },
	    	{ event='talk', delay=2.9, handle_id=201, talk='官爷行行好……', dur=2.5 },

	    	{ event='talk', delay=5.7, handle_id=1, talk='别急，还有的', dur=2.5 },
	    }, 

        --刘秀一行也跑过来
	    {
	    	{ event = 'camera', delay = 1.2, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 2300,846 } }, -- 移动镜头通过

			{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={2250,874}, speed=240, dur=0.8 },
			{ event='move', delay= 0.5, handle_id=4, end_dir=7, pos={2186,846}, speed=260, dur=0.8 },
	    	{ event='move', delay= 0.5, handle_id=6, end_dir=3, pos={2194,910}, speed=260, dur=0.8 },
	    	{ event='move', delay= 0.5, handle_id=3, end_dir=7, pos={2092,850}, speed=260, dur=0.8 },
	    	{ event='move', delay= 0.5, handle_id=5, end_dir=5, pos={2104,912}, speed=260, dur=0.8 },

	    	{ event='talk', delay=0.5, handle_id=2, talk='阴戟——', dur=2.5 },

	    	{ event='createActor', delay=2.3, handle_id = 205, body=45, pos={2036-32,788-32}, dir=3, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=2.3, handle_id = 206, body=45, pos={2108-32,758-32}, dir=3, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=2.3, handle_id = 207, body=45, pos={1996+32,932+96}, dir=1, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=2.3, handle_id = 208, body=46, pos={2068+32,966+96}, dir=1, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=2.3, handle_id = 209, body=46, pos={2290+96,974+96}, dir=7, speed=340, name_color=0xffffff, name="难民"},
	   		{ event='createActor', delay=2.3, handle_id = 210, body=46, pos={2350+96,940+96}, dir=7, speed=340, name_color=0xffffff, name="难民"},

	   		{ event='move', delay= 2.5, handle_id=205, end_dir=3, pos={2036,788}, speed=300, dur=0.8 },
			{ event='move', delay= 2.5, handle_id=206, end_dir=3, pos={2108,758}, speed=300, dur=0.8 },

	    	{ event='move', delay= 2.5, handle_id=207, end_dir=1, pos={1996,932+32}, speed=300, dur=0.8 },
	    	{ event='move', delay= 2.5, handle_id=208, end_dir=1, pos={2068,966+32}, speed=300, dur=0.8 },

	    	{ event='move', delay= 2.5, handle_id=209, end_dir=7, pos={2290,974+32}, speed=300, dur=0.8 },
	    	{ event='move', delay= 2.5, handle_id=210, end_dir=7, pos={2350,940+32}, speed=300, dur=0.8 },

	    	{ event='talk', delay=2.5, handle_id=207, talk='官爷行行好……', dur=2.5 },
	    	{ event='talk', delay=2.5, handle_id=209, talk='官爷行行好……', dur=2.5 },
	    },

	   --刘秀说话
	   {
	    	
	    	{ event='talk', delay=0.1, handle_id=2, talk='……', dur=2 },
	    	{ event='talk', delay=0.1, handle_id=3, talk='……', dur=2 },
	    	{ event='talk', delay=0.1, handle_id=4, talk='……', dur=2 },
	    	{ event='talk', delay=0.1, handle_id=5, talk='……', dur=2 },
	    	{ event='talk', delay=0.1, handle_id=6, talk='……', dur=2 },

	    	{ event='talk', delay=2.3, handle_id=2, talk='哎……', dur=1.5 },
	    	{ event='talk', delay=4.1, handle_id=2, talk='将干粮分给他们吧。', dur=2 },
	    },
	},

	--============================================wuwenbin  主线任务 剧情31 end  =====================================----

	--============================================hanbaobao  主线任务 剧情32 start  =====================================----

	--演员表 1 刘秀 2 阴戟 3 冯异 4 王霸 5 祭遵 6 姚期 
	['juqing-ux032'] = 
	{
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 2181,my = 2714-50 },

	   		{ event='createActor', delay=0.1, handle_id = 2, body=5, pos={1900,2833}, dir=2, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=34, pos={2181,2714}, dir=5, speed=340, name_color=0xffffff, name="冯异"},

	   		{ event='createActor', delay=0.1, handle_id = 1, body=12, pos={1390,2613}, dir=5, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=8, pos={1453,2581}, dir=5, speed=340, name_color=0xffffff, name="王霸"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=47, pos={1522,2580}, dir=6, speed=340, name_color=0xffffff, name="祭遵"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=43, pos={1487,2649}, dir=7, speed=340, name_color=0xffffff, name="姚期"},
	    },

	    --丽华和冯异，两人BB
	    {

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={2050,2819}, speed=300, dur=0.8 },

	    	{ event='talk', delay=2, handle_id=2, talk='公孙，我们并未怪你……', dur=1.5 },
	    	{ event='talk', delay=3.9, handle_id=3, talk='正因如此，我更无颜面留下。', dur=2 },
	    	{ event='talk', delay=6.2, handle_id=3, talk='丽华。', dur=1.5 },
	    	{ event='talk', delay=7.9, handle_id=3, talk='文叔今时大难不死，来日必将成就大业。', dur=2.5 },
	    	{ event='talk', delay=10.6, handle_id=3, talk='而我无法再追随左右……', dur=2 },
	    	{ event='talk', delay=12.8, handle_id=3, talk='我必须回洛阳与家人生死与共。', dur=2.5 },
	    	{ event='talk', delay=15.5, handle_id=2, talk='你回去了他们也不会放过你的家人，你这是自投罗网！', dur=3.5 },

	    },   
	    --丽华和冯异，两人BB
	    {
	    	{ event='talk', delay=0.2, handle_id=3, talk='就算救不了他们，起码可以生死在一处……', dur=2.5 },
	    	{ event='talk', delay=2.9, handle_id=2, talk='丁姐姐曾对我说过，她会去照顾你的家人。', dur=2.5 },
	    	{ event='talk', delay=5.6, handle_id=2, talk='她只希望你能无后顾之忧，一展宏愿。', dur=2.5 },
	    	{ event='talk', delay=8.3, handle_id=2, talk='不要因为她，而受牵绊。', dur=1.5 },
	    	{ event='talk', delay=9.8, handle_id=3, talk='哎……', dur=1.5 },
	    	{ event='talk', delay=11.5, handle_id=3, talk='你来看……这是阿柔的手指……', dur=1.5 },

	    },   
        --丽华和冯异，两人BB
	    {
			{ event='move', delay= 0.2, handle_id=2, end_dir=1, pos={2106,2790}, speed=150, dur=0.8 },
	    	{ event='talk', delay=0.2, handle_id=2, talk='！！！', dur=1.5 },
	    	{ event='talk', delay=1.9, handle_id=3, talk='他们皆因我而受连累，生死未卜，我怎能不顾他们？', dur=3.2 },
	    	{ event='talk', delay=5.3, handle_id=2, talk='丁姐姐与我情同姐妹，我以性命承诺——', dur=2.5 },
	    	{ event='talk', delay=8, handle_id=2, talk='阴家会全力解救她和你的家眷。', dur=2 },	    	
	    	{ event='talk', delay=10.2, handle_id=3, talk='哎……', dur=1.5 },

	    },   


	    --刘秀前置，阴戟和冯异转身，刘秀带着王霸，祭遵，姚期走入屏幕
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ux32_1" ,dialog_time = 2},
			
			{ event='talk', delay=1, handle_id=3, talk='！', dur=1 },
	    	{ event='talk', delay=1, handle_id=2, talk='！', dur=1 },

	    	{ event='move', delay= 1.1, handle_id=3, end_dir=6, pos={2093,2668}, speed=300, dur=0.8 },
            { event='move', delay= 1.1, handle_id=2, end_dir=6, pos={2085,2783}, speed=300, dur=0.8 },

	    	{ event = 'camera', delay = 1.2, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 2003,2638 } }, -- 移动镜头通过

	    	{ event='move', delay= 1.2, handle_id=1, end_dir=2, pos={1963,2710}, speed=300, dur=0.8 },
	    	{ event='move', delay= 1.2, handle_id=4, end_dir=3, pos={1894,2629}, speed=300, dur=0.8 },
	    	{ event='move', delay= 1.2, handle_id=5, end_dir=2, pos={1833,2713}, speed=300, dur=0.8 },
	    	{ event='move', delay= 1.2, handle_id=6, end_dir=1, pos={1882,2809}, speed=300, dur=0.8 },

	    },

	   --众人BB
	   {
	    	
	    	{ event='talk', delay=0.5, handle_id=1, talk='说好了生死与共，你不能言而无信。', dur=2 },
	    	{ event='talk', delay=2.7, handle_id=4, talk='冯主薄啊——', dur=1.5 },
	    	{ event='talk', delay=4.4, handle_id=4, talk='我们还都指望你呢，你可不能丢下咱们兄弟不管。', dur=3.2 },

	    	{ event='move', delay= 7.6, handle_id=5, end_dir=1, pos={1833,2713}, speed=300, dur=0.8 },
	    	{ event='talk', delay=7.6, handle_id=5, talk='王霸。', dur=1.5 },
	    	{ event='move', delay= 7.7, handle_id=4, end_dir=5, pos={1894,2629}, speed=300, dur=0.8 },

	    	{ event='talk', delay=9.3, handle_id=5, talk='你是怕公孙不在，咱们连饭都没的吃了吧？', dur=3.2 },
	    	{ event='talk', delay=12.7, handle_id=6, talk='所以啦，咱们都不能没公孙啊！', dur=1.5 },	
			{ event='move', delay=14.2, handle_id=5, end_dir=2, pos={1833,2713}, speed=300, dur=0.8 },
	    	{ event='move', delay=14.2, handle_id=4, end_dir=3, pos={1894,2629}, speed=300, dur=0.8 },
	    	{ event='talk', delay=14.4, handle_id=4, talk='哈哈^_^', dur=1.5 },
	    	{ event='talk', delay=14.4, handle_id=5, talk='哈哈^_^', dur=1.5 },
			{ event='talk', delay=14.4, handle_id=6, talk='哈哈^_^', dur=1.5 },


	    },

	    --阴戟移动转向继续BB
	   {
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=1, pos={2051,2724}, speed=300, dur=0.8 },
	    	{ event='move', delay= 0.2, handle_id=3, end_dir=5, pos={2093,2668}, speed=300, dur=0.8 },

	    	{ event='talk', delay=0.3, handle_id=2, talk='公孙。', dur=1.5 },
	    	{ event='talk', delay=2, handle_id=2, talk='你忘了昔年太学之时，我们曾经共同的志向吗？', dur=3.2 },
	    	{ event='talk', delay=5.4, handle_id=2, talk='挽倾厦之将覆，解万民于倒悬。', dur=2 },
	    	{ event='talk', delay=7.6, handle_id=2, talk='留下来吧。', dur=1.5 },
	    	{ event='talk', delay=9.3, handle_id=3, talk='好吧……', dur=1.5 },	    

	    },
        --冯异转身BB
	    {

            { event='move', delay= 0.2, handle_id=3, end_dir=6, pos={2093,2668}, speed=300, dur=0.8 },
	    	{ event='talk', delay=0.3, handle_id=3, talk='蒙众位兄弟不嫌弃。', dur=1.5 },
	    	{ event='talk', delay=2, handle_id=3, talk='公孙必将和诸位一起，奋战到底。', dur=2.5 },
	    },

	},

	--============================================hanbaobao  主线任务 剧情32 end  =====================================----

	--============================================wuwenbin  主线任务 剧情33 start  =====================================----

	--演员表 1 阴戟 2 邓禹
	['juqing-ux033'] = 
	{
	   
	    --创建角色 
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1800,2769}, dir=3, speed=340, name_color=0xffffff, name="阴戟"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=1, pos={1462,2637}, dir=7, speed=340, name_color=0xffffff, name="邓禹"},
	    },

	    --阴戟出场
		{
			{ event='init_cimera', delay = 0.1,mx= 1482,my = 2550 },

			{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={1530,2682}, speed=300, dur=1 },
			{ event='talk', delay=0.1, handle_id=1, talk='阿禹你醒了？', dur=2 },

			{ event='move', delay= 1, handle_id=2, end_dir=3, pos={1462,2637}, speed=300, dur=1 },
			{ event='talk', delay=1, handle_id=2, talk='丽华——', dur=1.5 },
		},

		--邓禹转身说话
		{
			{ event='talk', delay=0.5, handle_id=2, talk='这个玉钗送你，昔年我游历西域时买的。', dur=2.5 },
			{ event='talk', delay=3.3, handle_id=2, talk='本想在你及笄礼之时替你绾上，没想到错过了……', dur=3 },
			{ event='talk', delay=6.6, handle_id=2, talk='现在你身穿武袍，威风凛凛，这个自然也用不上了。', dur=3 },
			{ event='talk', delay=9.9, handle_id=1, talk='……', dur=1.5 },
			{ event='talk', delay=11.7, handle_id=1, talk='啊哈哈……你一去那么久，我还想着会有什么礼物呢，算你有良心。', dur=3.5 },
			{ event='talk', delay=15.5, handle_id=2, talk='那……我……能替你绾上么？', dur=2 },
			{ event='talk', delay=17.8, handle_id=1, talk='好！', dur=1.5 },
		},

		--阴戟转身，邓禹接近阴戟
		{
			{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1530,2682}, speed=300, dur=0.5 },
			{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={1530-20,2682-20}, speed=300, dur=0.5 },
		},

		--字幕，几年前
		{
			{ event = 'changeRGBA',delay=0.1,dur=6,cont_time=6,txt = "丽华解下帻巾，满头青丝泻下#r邓禹颤抖的挽起丽华的长发#r笨拙的将玉钗绾住丽华的发髻#r像是完成一个心愿一般……"},
		},

        
        --走位
		{    
			{ event='move', delay= 0.2, handle_id=2, end_dir=3, pos={1462,2637}, speed=300, dur=1,dir = 3 },

  			{ event='talk', delay=0.8, handle_id=2, talk='好了！', dur=1.5 },

  			{ event='move', delay= 1.1, handle_id=1, end_dir=7, pos={1530,2682}, speed=300, dur=1 },
  			{ event='talk', delay=2.6, handle_id=1, talk='[a]', dur=1.5, emote ={ a=3 },},
		},

	    --玉钗摔碎
	    {
	   		{ event='showTopTalk', delay=0.1, dialog_id="ux33_1" ,dialog_time = 2.5},

	   		{ event='talk', delay=0.3, handle_id=1, talk='！！', dur=2 },
	   		{ event='talk', delay=0.3, handle_id=2, talk='！！', dur=2 },
	   		{ event='move', delay= 0.3, handle_id=2, end_dir=3, pos={1462-16,2637-16}, speed=300, dur=1,dir = 3 },
			{ event='move', delay= 0.3, handle_id=1, end_dir=7, pos={1530+16,2682+16}, speed=300, dur=1 },

	   		{ event='talk', delay=3.3, handle_id=1, talk='糟糕！', dur=1.3 },
	   		{ event='talk', delay=4.9, handle_id=2, talk='我真是……笨手笨脚……', dur=2.5 },
	   		{ event='talk', delay=7.7, handle_id=2, talk='分钗破镜……果然……无法挽回！', dur=2.5 },

	   		{ event='move', delay= 7.7, handle_id=2, end_dir=7, pos={1462-16,2637-16}, speed=300, dur=1 },
	   		{ event='talk', delay= 10.5, handle_id=1, talk='阿禹……', dur=1.5 },
	    },

	    --分钗之约
	    {
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={1391-16,2604-16}, speed=240, dur=19 },
	   		{ event='talk', delay=0.5, handle_id=1, talk='阿禹！你看！……', dur=1.5 },
	   		{ event='talk', delay=2.3, handle_id=1, talk='我现在可是护军阴戟！你看我这样盘髻，是不是更有男儿气概？', dur=3.5 },
	   		{ event='talk', delay=6.1, handle_id=1, talk='我今年二十啦，你说这算不算是行及冠礼呢？', dur=2.5 },
	   		{ event='talk', delay=8.9, handle_id=2, talk='丽华……', dur=2 },
	   		{ event='talk', delay=12, handle_id=2, talk='倾禹所有，允你今日分钗之约，一生无悔！', dur=4 },
	   		-- { event='talk', delay=11, handle_id=1, talk='无论你要我做什么，都会如卿所愿，此生无悔！', dur=1.3 },
	   		{ event='talk', delay=16.3, handle_id=1, talk='阿禹……', dur=2 },
	    },
	},

	--============================================wuwenbin  主线任务 剧情33 end  =====================================----

    	--============================================hanbaobao  主线任务 剧情34 start  =====================================----

	--演员表 1 丽华 2 冯异 3 邓禹 4 尉迟峻 5 邓晨  101 心碎特效
	['juqing-ux034'] = 
	{
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 1264,my = 2406 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1354,2542}, dir=2, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=34, pos={1651,2541}, dir=6, speed=340, name_color=0xffffff, name="冯异"},
	   		
	    },

	    --冯异跳出来攻击丽华，丽华后跳一步
	    {

	    	{ event='jump', delay=0.2, handle_id=2, dir=6, pos={ 1455,2539 }, speed=120, dur=0.8 ,end_dir = 6},
	    	{ event='playAction', delay=1, handle_id=2, action_id=2, dur=1.5, dir=6, loop=false },
	    	{ event='talk', delay=0.5, handle_id=1, talk='!', dur=1 },    	
	    	{ event='jump', delay=0.9, handle_id=1, dir=2, pos={ 1226,2540 }, speed=120, dur=0.8 ,end_dir = 2},
	    	{ event='talk', delay=1.8, handle_id=1, talk='公孙！你什么意思？', dur=1.5 },
	    	{ event='talk', delay=3.5, handle_id=1, talk='你现在可是欺我有伤在身？', dur=2 },
	    	{ event='talk', delay=5.7, handle_id=2, talk='你总是要死的，与其让你将来愧疚自缢。', dur=2.5 },
	    	{ event='talk', delay=8.4, handle_id=2, talk='不如我做恶人，先成全了你们夫妻！', dur=2.5 },
	    	{ event='talk', delay=11.1, handle_id=1, talk='你胡说什么？你少来危言耸听！', dur=2.5 },


	    },   
	    --丽华和冯异，两人BB
	    {
	    	
			{ event='move', delay= 0.2, handle_id=2, end_dir=6, pos={1354,2542}, speed=150, dur=0.8 },

	    	{ event='talk', delay=0.2, handle_id=2, talk='如今娶一女子便能轻易化干戈为玉帛！', dur=2.5 },
	    	{ event='talk', delay=2.9, handle_id=2, talk='数万人的生死存亡，系在刘文叔的取舍之间！', dur=2.5 },
	    	{ event='talk', delay=5.6, handle_id=2, talk='你要这跟随文叔的数万人统统去死不成？', dur=2.5 },
	    	{ event='talk', delay=8.3, handle_id=1, talk='我只知道，他是我夫君，我是他的妻子。', dur=2.5 },
	    	{ event='talk', delay=11, handle_id=1, talk='我们俩之间，容不下第三个人！', dur=2 },
	    	{ event='talk', delay=13.2, handle_id=2, talk='你这是在逼文叔去死！', dur=1.5 },

	    },   
        --丽华和冯异，两人BB
	    {
			

	    	{ event='talk', delay=0.2, handle_id=1, talk='你……别胡说。', dur=1.3 },
	    	{ event='move', delay= 0.5, handle_id=1, end_dir=5, pos={1226,2540}, speed=200, dur=0.8 },
			
			{ event='move', delay= 1.5, handle_id=2, end_dir=1, pos={1137,2609}, speed=200, dur=0.8 },

			--{ event = 'camera', delay = 1.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 1268,2445 } }, -- 移动镜头通过

	    	{ event='talk', delay=2.5, handle_id=2, talk='丽华！你虽性情豁达，宛若丈夫，然而……', dur=2.5 },
	    	{ event='talk', delay=5.2, handle_id=2, talk='你非真男儿，男人的抱负与追求，是你永远也无法明白的！', dur=4 },
	    	{ event='talk', delay=9.4, handle_id=1, talk='这只是你的想法，不是文叔的想法！子非鱼，安知鱼之乐？', dur=4 },	    	
	    	{ event='talk', delay=13.6, handle_id=2, talk='子非我，安知我不知鱼之乐？', dur=2 },
	    	{ event='talk', delay=15.8, handle_id=1, talk='……', dur=1.1 },	    	

	    },   


	    --前置对白，尉迟峻和邓禹出现
	    {

	    	{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={1427,2830}, dir=7, speed=340, name_color=0xffffff, name="邓禹"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=22, pos={1427,2830}, dir=7, speed=340, name_color=0xffffff, name="尉迟峻"},

	   		{ event='showTopTalk', delay=0.2, dialog_id="ux34_1" ,dialog_time = 3},
			
			{ event='talk', delay=2, handle_id=1, talk='！', dur=1 },
	    	{ event='talk', delay=2, handle_id=2, talk='！', dur=1 },
	    	{ event='move', delay= 2.1, handle_id=1, end_dir=3, pos={1226,2540}, speed=200, dur=0.8 },
            { event='move', delay= 2.1, handle_id=2, end_dir=3, pos={1137,2609}, speed=200, dur=0.8 },

	    	{ event = 'camera', delay = 2.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 1226,2540 } }, -- 移动镜头通过

			{ event='move', delay= 2.5, handle_id=3, end_dir=7, pos={1300,2638}, speed=200, dur=0.8 },
            { event='move', delay= 2.5, handle_id=4, end_dir=7, pos={1233,2704}, speed=200, dur=0.8 },

			{ event='talk', delay=3.7, handle_id=3, talk='丽华，别难过了，这事也怪不得文叔……', dur=3 },
	    	{ event='talk', delay=6.9, handle_id=3, talk='我陪你回新野，好不好？', dur=2.5 },

	    	{ event='effect', handle_id=101, target_id=1, delay =9.6 , pos={20,150}, effect_id=20011, is_forever = true},--心碎
	        { event = 'removeEffect', delay = 11.6, handle_id=101, effect_id=20011},

	    },

	   --邓晨出现，继续BB
	   {
	    	
	    	{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={742,2898}, dir=1, speed=340, name_color=0xffffff, name="邓晨"},
	    	{ event='move', delay= 0.2, handle_id=5, end_dir=1, pos={1046,2732}, speed=200, dur=0.8 },

			{ event='move', delay= 0.4, handle_id=1, end_dir=5, pos={1226,2540}, speed=200, dur=0.8 },
            { event='move', delay= 0.4, handle_id=2, end_dir=5, pos={1137,2609}, speed=200, dur=0.8 },

			{ event='move', delay= 0.4, handle_id=3, end_dir=5, pos={1300,2638}, speed=200, dur=0.8 },
            { event='move', delay= 0.4, handle_id=4, end_dir=5, pos={1233,2704}, speed=200, dur=0.8 },


	    	{ event='talk', delay=1, handle_id=5, talk='总算找到你们了！', dur=1.5 },
	    	{ event='talk', delay=2.7, handle_id=5, talk='文叔执意不受，众将跪地直谏。', dur=2.5 },
	    	{ event='talk', delay=5.4, handle_id=5, talk='若是再不允协，恐伤人心……', dur=2.5 },

	    	{ event='move', delay= 8.1, handle_id=5, end_dir=1, pos={1137,2609}, speed=200, dur=0.8 },
 			{ event='move', delay= 8.1, handle_id=2, end_dir=2, pos={1010,2609}, speed=200, dur=0.8 },
			{ event='talk', delay=8.3, handle_id=5, talk='丽华，为了文叔，委屈一下吧。', dur=2.5 },
			{ event='move', delay= 10.8, handle_id=2, end_dir=2, pos={1010,2609}, speed=200, dur=0.8 },
			
			{ event='move', delay= 10.8, handle_id=3, end_dir=7, pos={1300,2638}, speed=200, dur=0.8 },
            { event='move', delay= 10.8, handle_id=4, end_dir=7, pos={1233,2704}, speed=200, dur=0.8 },

			{ event='talk', delay=11, handle_id=1, talk='……', dur=1.3 },

			{ event='showTopTalk', delay=12.5, dialog_id="ux34_2" ,dialog_time = 6},
			{ event='showTopTalk', delay=19, dialog_id="ux34_3" ,dialog_time = 6},


	    },

	},

	--============================================hanbaobao  主线任务 剧情34 end  =====================================----

		   	--============================================hanbaobao  主线任务 剧情35 start  =====================================----

	--演员表 1 刘秀 2 过珊彤 3 刘扬 4 过主 5 刘植 6 耿纯 101-104 刘秀随从 201-206 刘扬部下 301 害羞特效
	['juqing-ux035'] = 
	{
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 749,my = 332+20 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=3, pos={597,399}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=36, pos={657,375}, dir=3, speed=340, name_color=0xffffff, name="过珊彤"},

	   		{ event='createActor', delay=0.1, handle_id = 3, body=23, pos={717,366}, dir=5, speed=340, name_color=0xffffff, name="刘扬"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=11, pos={783,398}, dir=5, speed=340, name_color=0xffffff, name="过主"},

	   		{ event='createActor', delay=0.1, handle_id = 5, body=18, pos={566,470}, dir=2, speed=340, name_color=0xffffff, name="刘植"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=30, pos={585,539}, dir=2, speed=340, name_color=0xffffff, name="耿纯"},	   		

	   		{ event='createActor', delay=0.1, handle_id = 101, body=41, pos={849,589}, dir=7, speed=340, name_color=0xffffff, name="侍女"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=41, pos={686-50,558}, dir=1, speed=340, name_color=0xffffff, name="侍女"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=41, pos={785,303}, dir=5, speed=340, name_color=0xffffff, name="侍女"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=41, pos={847,335}, dir=5, speed=340, name_color=0xffffff, name="侍女"},

	   		{ event='createActor', delay=0.1, handle_id = 201, body=57, pos={912,367}, dir=5, speed=340, name_color=0xffffff, name="侍卫 "},
	   		{ event='createActor', delay=0.1, handle_id = 202, body=57, pos={943+60,461}, dir=6, speed=340, name_color=0xffffff, name="侍卫 "},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=57, pos={879+60,496}, dir=6, speed=340, name_color=0xffffff, name="侍卫 "},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=57, pos={880+60,429}, dir=7, speed=340, name_color=0xffffff, name="侍卫 "},
	   		{ event='createActor', delay=0.1, handle_id = 205, body=57, pos={911+60,562}, dir=7, speed=340, name_color=0xffffff, name="侍卫 "},
	   		{ event='createActor', delay=0.1, handle_id = 206, body=57, pos={849+60,589}, dir=7, speed=340, name_color=0xffffff, name="侍卫 "},
	   		
	    },

	    --刘扬BB
	    {

	    	{ event='move', delay= 0.5, handle_id=3, end_dir=3, pos={687+50,433+50}, speed=400, dur=1 },
	    	{ event='talk', delay=1.7, handle_id=3, talk='今日是我的外甥女珊彤与刘大司马结亲的大喜日子！', dur=3.5 },  

	    	{ event='effect',  delay = 5.2 ,handle_id=301, target_id=2, pos={0,100}, effect_id=20010, is_forever = true},

	    	{ event='talk', delay=5.4, handle_id=3, talk='我要为各位献上一曲，以助雅兴。', dur=2.5 }, 

	    	--{ event = 'removeEffect', delay = 7.9, handle_id=301, effect_id=20010},

	    	{ event='talk', delay=8.1, handle_id=4, talk='[a]', dur=1.2,emote = {a = 2}},
	    	{ event='talk', delay=9.5, handle_id=5, talk='好！', dur=1.2 }, 
	    	{ event='talk', delay=9.5, handle_id=6, talk='好！', dur=1.2 }, 

	    	{ event='talk', delay=10.9, handle_id=201, talk='好！', dur=1.2 }, 
	    	{ event='talk', delay=10.9, handle_id=202, talk='好！', dur=1.2 }, 
	    	{ event='talk', delay=10.9, handle_id=203, talk='好！', dur=1.2 }, 
	    	{ event='talk', delay=10.9, handle_id=204, talk='好！', dur=1.2 }, 
	    	{ event='talk', delay=10.9, handle_id=205, talk='好！', dur=1.2 }, 
	    	{ event='talk', delay=10.9, handle_id=206, talk='好！', dur=1.2 }, 

	    },   

		--欢快音乐
	   	{
			{ event='playBgMusic', delay=0.1, id = 1 ,loop = true},
		},

        --字幕，几年前
		{
			{ event = 'changeRGBA',delay=0.1,dur=6,cont_time=6,txt = "众人欢呼叫好，推杯换盏，击筑高歌，皆欢欣鼓舞，大醉而归。"},
			{ event='kill', delay=0.2, handle_id=2}, 
			{ event='init_cimera', delay = 6.1,mx= 2634,my = 436-100 },
			{ event='createActor', delay=0.3, handle_id = 2, body=36, pos={2634,436}, dir=1, speed=340, name_color=0xffffff, name="过珊彤"},
		
		},

		--悲伤音乐
	   	{
			{ event='playBgMusic', delay=0.1, id = 2 ,loop = true},
		},


	    --前置对白
	    {
	   		
	   		{ event='talk', delay=0.5, handle_id=2, talk='夫君……', dur=1.5 }, 
	   		{ event='showTopTalk', delay=2.4, dialog_id="ux35_1" ,dialog_time = 3},
	   		{ event='talk', delay=5.8, handle_id=2, talk='……', dur=1.5 }, 
	   		{ event='talk', delay=7.7, handle_id=2, talk='夫君……', dur=1.5 }, 

	   		{ event='showTopTalk', delay=9.6, dialog_id="ux35_2" ,dialog_time = 4},
	   		
	   		{ event='talk', delay=14, handle_id=2, talk='哎……夫君，你还记得我么？', dur=2.5 }, 
	   		{ event='talk', delay=16.9, handle_id=2, talk='我记得你呢，你比那时瘦了……', dur=3 }, 
	   	
	    },

	     --字幕，几年前
		{
			{event='changeRGBA', delay=0.4, dur=5.3, txt="半晌，灯灭……",cont_time=5.3, light_time=0.5, txt_time=0.5, black_time=0.1},
			{event='changeRGBA', delay=5.3,dur=9.5, txt="半晌，灯灭……#r过珊彤躺在一旁榻上。",cont_time=9.5, light_time=0.1, txt_time=0, black_time=0.1},
			{event='changeRGBA', delay=9,dur=6, txt="半晌，灯灭……#r过珊彤躺在一旁榻上。#r刘秀睁开眼睛，眼眸清明，思念丽华，痛苦内疚。",cont_time=6, light_time=0.1, txt_time=0, black_time=0.1},
		},

	},

	--============================================hanbaobao  主线任务 剧情35 end  =====================================----

			   	--============================================hanbaobao  主线任务 剧情36 start  =====================================----

	--演员表 1 刘玄 2 丽华 101-102 随从 201 风吹落叶特效
	['juqing-ux036'] = 
	{
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 493-150,my = 1200 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=24, pos={432,1263}, dir=1, speed=340, name_color=0xffffff, name="刘玄"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=6, pos={496,1296}, dir=1, speed=340, name_color=0xffffff, name="丽华"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=57, pos={463+50,1198-50}, dir=5, speed=340, name_color=0xffffff, name="随从"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=57, pos={559+50,1231-50}, dir=5, speed=340, name_color=0xffffff, name="随从"},
	   		
	    },

	    --刘玄BB
	    {

	    	{ event='talk', delay=0.3, handle_id=1, talk='你们不用跟来。', dur=1.5 },  
	    	{ event='talk', delay=2, handle_id=101, talk='诺。', dur=1.1 }, 
	    	{ event='talk', delay=2, handle_id=102, talk='诺。', dur=1.1 }, 
	    },     

	    --刘玄带丽华沿河慢走，丽华停下来BB
	    {
	        
	    	{ event ='camera', delay = 0.2, target_id=1, dur=0.5, sdur = 2,style = 'follow',backtime=1},
	        { event='move', delay= 0.2, handle_id=1, end_dir=2, pos={295,1479}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=6, pos={400,1453}, speed=300, dur=1 },
	    
	    	{ event='talk', delay=1.4, handle_id=2, talk='陛下，这是什么地方？', dur=2 }, 
	    	{ event='talk', delay=3.6, handle_id=1, talk='一会儿朕会告诉你。', dur=1.2 }, 

	    },   

        --刘玄继续带丽华沿河慢走，丽华停下来BB
	    {
	        { event='move', delay= 0.2, handle_id=1, end_dir=3, pos={240,1583}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=3, pos={336,1580}, speed=300, dur=1 },
	    
	    	{ event='playBgMusic', delay=1.3, id = 2 ,loop = true},
	    	{ event='talk', delay=1.3, handle_id=2, talk='！', dur=1.2 }, 

	    	{ event='move', delay= 2.5, handle_id=2, end_dir=5, pos={526,1741}, speed=300, dur=1 },
	    	{ event='talk', delay=3.6, handle_id=2, talk='这里难道是……', dur=1.2 }, 

	    	{ event = 'camera', delay = 5, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = {463,1630}},
	    	{ event='move', delay= 5, handle_id=1, end_dir=3, pos={463,1680}, speed=300, dur=1 },
	    	{ event='talk', delay=6.2, handle_id=1, talk='这里是师父与你爹跳崖之处。', dur=2.5 }, 

	    	{ event='move', delay= 8.9, handle_id=2, end_dir=7, pos={526,1741}, speed=300, dur=1 },
	        { event='talk', delay=8.9, handle_id=2, talk='！', dur=1.2 }, 

	    },   

	    --刘玄继续带丽华沿河慢走，丽华停下来BB
	    {

			{ event='talk', delay=0.1, handle_id=1, talk='自从回了长安后……', dur=1.5 }, 
			{ event='talk', delay=1.8, handle_id=1, talk='每当我想念起师父的时候，就会来这里祭拜她。', dur=3.5 }, 

			{ event='move', delay= 5.5, handle_id=2, end_dir=5, pos={526,1741}, speed=300, dur=1 },
			{ event='talk', delay=6.7, handle_id=2, talk='爹……', dur=1.5 }, 
			{ event='talk', delay=8.4, handle_id=2, talk='娘……', dur=1.5 }, 

			{ event='move', delay= 8.6, handle_id=1, end_dir=5, pos={463,1680}, speed=300, dur=1 },
			{ event='talk', delay=9.8, handle_id=1, talk='师父……', dur=1.5 }, 

	    },  


	    --  --风吹落叶的特效
	    -- {
	    --     { event='effect', handle_id=201, delay=2.0, pos={2256, 3424}, effect_id=20004, is_forever = false},

	    -- },  

	},

	--============================================hanbaobao  主线任务 剧情36 end  =====================================----


		--============================================hanbaobao  主线任务 剧情37 start  =====================================----

	--演员表 1 光武帝刘秀 2 冯异 3 马武 4 吴汉 5 王霸 6 耿纯 101-110 汉军将士 201-202 侍从
	['juqing-ux037'] = 
	{
	   
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 1865,my = 1201 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=3, pos={2006,1428}, dir=7, speed=340, name_color=0xffffff, name="光武帝刘秀"},

	   		{ event='createActor', delay=0.1, handle_id = 201, body=55, pos={2007,1550}, dir=7, speed=340, name_color=0xffffff, name="侍从"},
 			{ event='createActor', delay=0.1, handle_id = 202, body=55, pos={2130,1426}, dir=7, speed=340, name_color=0xffffff, name="侍从"},

	   		{ event='createActor', delay=0.1, handle_id = 2, body=8, pos={1741,1428}, dir=1, speed=340, name_color=0xffffff, name="吴汉"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=47, pos={1741+60,1428+60}, dir=1, speed=340, name_color=0xffffff, name="马武"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=34, pos={1741+120,1428+120}, dir=1, speed=340, name_color=0xffffff, name="冯异"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=30, pos={2003+60,1164+60}, dir=5, speed=340, name_color=0xffffff, name="耿纯"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=8, pos={2003,1164}, dir=5, speed=340, name_color=0xffffff, name="王霸"},

			{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={1741+180,1428+180}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={2003+120,1164+120}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=27, pos={2003+180,1164+180}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=27, pos={1741,1428+60}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=27, pos={1741+60,1428+120}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},

	   		{ event='createActor', delay=0.1, handle_id = 106, body=27, pos={1741+120,1428+180}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 107, body=27, pos={1741+180,1428+240}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 108, body=27, pos={2003+60,1164}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 109, body=27, pos={2003+120,1164+60}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 110, body=27, pos={2003+180,1164+120}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},

	   		{ event='createActor', delay=0.1, handle_id = 111, body=27, pos={2003+240,1164+180}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 112, body=27, pos={1741,1428+120}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 113, body=27, pos={1741+60,1428+180}, dir=1, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 114, body=27, pos={2003+120,1164}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},
	   		{ event='createActor', delay=0.1, handle_id = 115, body=27, pos={2003+180,1164+60}, dir=5, speed=340, name_color=0xffffff, name="汉军将士"},



	    },

	    --字幕，几年前
		{
			{ event = 'changeRGBA',delay=0.1,dur=4,cont_time=4,txt = "公元二十五年，更始三年，刘秀称帝，改元建武，公开与更始帝决裂。"},
		
		},
        
        --走位
		{    
		    { event='move', delay= 0.2, handle_id=1, end_dir=3, pos={1680,1167}, speed=300, dur=1 },


  			{ event='move', delay= 0.2, handle_id=201, end_dir=1, pos={1672,1325}, speed=300, dur=1 },
		    { event='move', delay= 0.2, handle_id=202, end_dir=5, pos={1872,1132}, speed=300, dur=1 },

		    { event='move', delay= 1.5, handle_id=2, end_dir=7, pos={1741,1428}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=3, end_dir=7, pos={1809,1358}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=4, end_dir=7, pos={1871,1298}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=5, end_dir=7, pos={1942,1230}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=6, end_dir=7, pos={2003,1164}, speed=300, dur=1 },





		    { event='move', delay= 1.5, handle_id=112, end_dir=7, pos={1741+60,1428+60}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=105, end_dir=7, pos={1809+60,1358+60}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=104, end_dir=7, pos={1871+60,1298+60}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=108, end_dir=7, pos={1942+60,1230+60}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=114, end_dir=7, pos={2003+60,1164+60}, speed=300, dur=1 },

		    { event='move', delay= 1.5, handle_id=113, end_dir=7, pos={1741+120,1428+120}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=106, end_dir=7, pos={1809+120,1358+120}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=102, end_dir=7, pos={1871+120,1298+120}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=109, end_dir=7, pos={1942+120,1230+120}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=115, end_dir=7, pos={2003+120,1164+120}, speed=300, dur=1 },

		    { event='move', delay= 1.5, handle_id=107, end_dir=7, pos={1741+180,1428+180}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=101, end_dir=7, pos={1809+180,1358+180}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=103, end_dir=7, pos={1871+180,1298+180}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=110, end_dir=7, pos={1942+180,1230+180}, speed=300, dur=1 },
		    { event='move', delay= 1.5, handle_id=111, end_dir=7, pos={2003+180,1164+180}, speed=300, dur=1 },

		  

		},


	    --前置对白
	    {
	   		{ event='zoom', delay=0.2, sValue=1.0, eValue=1.5, dur=0.5}, -- 通过
	   		{ event='showTopTalk', delay=0.1, dialog_id="ux37_1" ,dialog_time = 5},
	   		{ event='showTopTalk', delay=5.5, dialog_id="ux37_2" ,dialog_time = 8},
	   		{ event='showTopTalk', delay=14, dialog_id="ux37_3" ,dialog_time = 8},
	   		{ event='showTopTalk', delay=22.5, dialog_id="ux37_4" ,dialog_time = 3},
	   		{ event='showTopTalk', delay=26, dialog_id="ux37_5" ,dialog_time = 3},
			{ event='showTopTalk', delay=29.5, dialog_id="ux37_6" ,dialog_time = 5},
	    },


	},

	--============================================hanbaobao  主线任务 剧情37 end  =====================================----

		--============================================hanbaobao  主线任务 剧情38 start  =====================================----

	--演员表 1 刘玄 2 丽华 3赵姬 4 赵信 5 琥珀 6 刘求 7 刘鲤 8 张卬 101-104 张卬部下
	['juqing-ux038'] = 
	{
	   
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 1621+70,my = 1786-50 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=24, pos={1551,1744}, dir=3, speed=340, name_color=0xffffff, name="刘玄"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=6, pos={1616+50,1839+50}, dir=7, speed=340, name_color=0xffffff, name="丽华"},

	   		{ event='createActor', delay=0.1, handle_id = 3, body=37, pos={1682+50,1777+50}, dir=7, speed=340, name_color=0xffffff, name="赵姬"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=21, pos={1520,1680}, dir=3, speed=340, name_color=0xffffff, name="赵信"},

	   		{ event='createActor', delay=0.1, handle_id = 5, body=52, pos={1648+100,1905+100}, dir=7, speed=340, name_color=0xffffff, name="琥珀"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=30, pos={1711+100,1841+100}, dir=7, speed=340, name_color=0xffffff, name="刘求"},
			{ event='createActor', delay=0.1, handle_id = 7, body=44, pos={1745+100,1745+100}, dir=7, speed=340, name_color=0xffffff, name="刘鲤"},

	   		{ event='createActor', delay=0.1, handle_id = 8, body=54, pos={721,1809}, dir=3, speed=340, name_color=0xffffff, name="张卬"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=58, pos={721,1745}, dir=7, speed=340, name_color=0xffffff, name="张卬部下"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=58, pos={623,1776}, dir=3, speed=340, name_color=0xffffff, name="张卬部下"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=58, pos={657,1710}, dir=7, speed=340, name_color=0xffffff, name="张卬部下"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=58, pos={559,1709}, dir=3, speed=340, name_color=0xffffff, name="张卬部下"},

	    },
        
        --走位
		{    
		   	{ event='talk', delay=0.2, handle_id=1, talk='赵信——', dur=1.5 },
		    { event='move', delay= 1.9, handle_id=4, end_dir=5, pos={1648,1711}, speed=340, dur=1 },
		    { event='move', delay= 1.9, handle_id=1, end_dir=1, pos={1551,1744}, speed=340, dur=1 },

		    { event='talk', delay=1.9, handle_id=4, talk='在！', dur=1.3 },
		    { event='talk', delay=3.4, handle_id=1, talk='你保护赵姬和丽华，带着孩子快跑，我留下殿后！', dur=3.5 },
		    { event='talk', delay=7.1, handle_id=4, talk='是！', dur=1.3 },

		    { event='talk', delay=8.6, handle_id=3, talk='不！夫君，咱们生死在一起……', dur=2.5 },
		    { event='move', delay= 8.6, handle_id=3, end_dir=7, pos={1682+30,1777+30}, speed=340, dur=1 },
		    { event='move', delay= 8.6, handle_id=1, end_dir=3, pos={1551,1744}, speed=340, dur=1 },

		    { event='showTopTalk', delay=11.3, dialog_id="ux38_1" ,dialog_time = 1.5},

		    { event='talk', delay=12.8, handle_id=1, talk='！', dur=1.3 },
		    { event='move', delay= 12.8, handle_id=1, end_dir=5, pos={1551,1744}, speed=340, dur=1 },

		    { event='move', delay= 12.8, handle_id=2, end_dir=5, pos={1616+50,1839+50}, speed=340, dur=1 },
		    { event='move', delay= 12.8, handle_id=3, end_dir=5, pos={1682+30,1777+30}, speed=340, dur=1 },
		    { event='move', delay= 12.8, handle_id=4, end_dir=5, pos={1648,1711}, speed=340, dur=1 },
		    { event='move', delay= 12.8, handle_id=5, end_dir=5, pos={1648+100,1905+100}, speed=340, dur=1 },
		    { event='move', delay= 12.8, handle_id=6, end_dir=5, pos={1711+100,1841+100}, speed=340, dur=1 },
		    { event='move', delay= 12.8, handle_id=7, end_dir=5, pos={1745+100,1745+100}, speed=340, dur=1 },

		},

	    --走位+前置对白
		{    
		   	
		    { event ='camera', delay = 0.1, target_id=104, dur=0.5, sdur = 0.1,style = 'follow',backtime=1},

		    { event='move', delay= 0.1, handle_id=8, end_dir=3, pos={721+500,1809+500}, speed=340, dur=2 },
		    { event='talk', delay=0.2, handle_id=8, talk='给我杀！', dur=1 },
  			{ event='move', delay= 0.1, handle_id=101, end_dir=3, pos={721+400,1745+400}, speed=340, dur=1.5 },
		    { event='move', delay= 0.1, handle_id=102, end_dir=3, pos={623+400,1776+400}, speed=340, dur=1.5 },
		    { event='move', delay= 0.1, handle_id=103, end_dir=3, pos={657+400,1710+400}, speed=340, dur=1.5 },
  			{ event='move', delay= 0.1, handle_id=104, end_dir=3, pos={559+400,1709+400}, speed=340, dur=1.5 },

  			{ event='talk', delay=0.5, handle_id=101, talk='杀！', dur=1 },
  			{ event='talk', delay=0.5, handle_id=102, talk='杀！', dur=1 },
  			{ event='talk', delay=0.5, handle_id=103, talk='杀！', dur=1 },
  			{ event='talk', delay=0.5, handle_id=104, talk='杀！', dur=1 },
  			
		},

	    --走位+BB
	    {
	   		{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1621+70,1786-50 } },
	   		{ event='kill', delay=3, handle_id=8}, 
	   		{ event='kill', delay=3, handle_id=101}, 
	   		{ event='kill', delay=3, handle_id=102}, 
	   		{ event='kill', delay=3, handle_id=103}, 
	   		{ event='kill', delay=3, handle_id=104}, 

	   		--{ event='playAction', delay=0.4, handle_id=1, action_id=2, dur=1.5, dir=3, loop=false },

	   		{ event='talk', delay=0.4, handle_id=1, talk='快走！', dur=1.3 },

	   		{ event='move', delay= 0.4, handle_id=1, end_dir=3, pos={1551,1744}, speed=340, dur=1 },

	   		{ event='move', delay= 0.4, handle_id=2, end_dir=7, pos={1616+50,1839+50}, speed=340, dur=1 },
		    { event='move', delay= 0.4, handle_id=3, end_dir=7, pos={1682+30,1777+30}, speed=340, dur=1 },
		    { event='move', delay= 0.4, handle_id=4, end_dir=5, pos={1648,1711}, speed=340, dur=1 },
		    { event='move', delay= 0.4, handle_id=5, end_dir=7, pos={1648+100,1905+100}, speed=340, dur=1 },
		    { event='move', delay= 0.4, handle_id=6, end_dir=7, pos={1711+100,1841+100}, speed=340, dur=1 },
		    { event='move', delay= 0.4, handle_id=7, end_dir=7, pos={1745+100,1745+100}, speed=340, dur=1 },

		    { event='talk', delay=1.9, handle_id=2, talk='快走吧！', dur=1.3 },
		    { event='move', delay= 1.9, handle_id=2, end_dir=1, pos={1616+50,1839+50}, speed=340, dur=1 },
		    { event='move', delay= 2, handle_id=3, end_dir=5, pos={1682+30,1777+30}, speed=340, dur=1 },
		    { event='talk', delay=3.4, handle_id=3, talk='好吧……', dur=1.3 },
		    { event='move', delay= 4.9, handle_id=3, end_dir=7, pos={1682+30,1777+30}, speed=340, dur=1 },
		    { event='talk', delay=4.9, handle_id=3, talk='夫君，保重！', dur=1.3 },

		    { event='move', delay= 6.4, handle_id=2, end_dir=7, pos={2386,2194}, speed=200, dur=2 },
		    { event='move', delay= 6.4, handle_id=3, end_dir=7, pos={2386,2194}, speed=200, dur=2 },
		    { event='move', delay= 6.4, handle_id=4, end_dir=7, pos={2386,2194}, speed=200, dur=2 },
		    { event='move', delay= 6.4, handle_id=5, end_dir=7, pos={2386,2194}, speed=200, dur=2 },
		    { event='move', delay= 6.4, handle_id=6, end_dir=7, pos={2386,2194}, speed=200, dur=2 },
		    { event='move', delay= 6.4, handle_id=7, end_dir=7, pos={2386,2194}, speed=200, dur=2 },

	    },

	     --走位+BB
	    {
	   		{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1621,1786 } },
	
	   		{ event='createActor', delay=0.1, handle_id = 8, body=54, pos={1360,2065}, dir=1, speed=340, name_color=0xffffff, name="张卬"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=58, pos={1261,2064}, dir=1, speed=340, name_color=0xffffff, name="张卬部下"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=58, pos={1328,2126}, dir=1, speed=340, name_color=0xffffff, name="张卬部下"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=58, pos={1199,2094}, dir=1, speed=340, name_color=0xffffff, name="张卬部下"},
	   		{ event='createActor', delay=0.1, handle_id = 101, body=58, pos={1264,2159}, dir=1, speed=340, name_color=0xffffff, name="张卬部下"},


	   		{ event='move', delay= 0.5, handle_id=1, end_dir=5, pos={1711,1841}, speed=340, dur=1 },

	   		{ event='move', delay= 0.2, handle_id=101, end_dir=7, pos={1776,1938}, speed=200, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=103, end_dir=6, pos={1841,1842}, speed=200, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=104, end_dir=2, pos={1583,1841}, speed=200, dur=1 },
	   		{ event='move', delay= 0.2, handle_id=102, end_dir=3, pos={1647,1744}, speed=200, dur=1 },

	   		{ event='move', delay= 0.2, handle_id=8, end_dir=1, pos={1617,1966}, speed=300, dur=1 },

	   		{ event='talk', delay=1.8, handle_id=8, talk='站住！还想往哪儿跑？', dur=2 },
	   		{ event='talk', delay=4, handle_id=1, talk='张卯，你给我过来！[a]', dur=2 ,emote ={ a=24} },
	   		{ event='talk', delay=6.2, handle_id=1, talk='咱们两个人，决一死战！', dur=2 },

	   		{ event='talk', delay=8.4, handle_id=8, talk='啊哈哈哈……', dur=1.3 },
	   		{ event='talk', delay=9.9, handle_id=8, talk='杀你犹如碾死一只蝼蚁，何须我亲自动手？', dur=3.5 },
	   		{ event='talk', delay=13.4, handle_id=1, talk='我刘玄怎能死于宵小之手？', dur=2.5 },
	   		{ event='talk', delay=16.1, handle_id=8, talk='上！', dur=1.2 },
	   		{ event='playAction', delay=16.1, handle_id=8, action_id=2, dur=1.5, dir=1, loop=false },

	    },


	     --走位+BB
	    {
	   		{ event='playAction', delay=0.2, handle_id=101, action_id=2, dur=1.5, dir=7, loop=false },
	   		{ event='playAction', delay=0.2, handle_id=102, action_id=2, dur=1.5, dir=3, loop=false },
	   		{ event='playAction', delay=0.2, handle_id=103, action_id=2, dur=1.5, dir=6, loop=false },
	   		{ event='playAction', delay=0.2, handle_id=104, action_id=2, dur=1.5, dir=2, loop=false },
	   		{ event='talk', delay=0.5, handle_id=1, talk='啊……', dur=3.5 },
	   		{ event='playAction', delay=0.6, handle_id=1, action_id=4, dur=1.5, dir=5, loop=false ,once = true},

	     },

	},

	--============================================hanbaobao  主线任务 剧情38 end  =====================================----

					--============================================hanbaobao  主线任务 剧情39 start  =====================================----

	--演员表 1 光武帝刘秀 2 光烈皇后阴丽华
	['juqing-ux039'] = 
	{
	   
	    --创建角色 
	    {
	        { event='init_cimera', delay = 0.2,mx= 367,my = 625 },

	   		{ event='createActor', delay=0.1, handle_id = 1, body=3, pos={688,1136}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=4, pos={273,754}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},

	    },
        
        --走位
		{    
		   	{ event='talk', delay=0.2, handle_id=2, talk='和离……', dur=1.5 },
		    { event='move', delay= 1.9, handle_id=2, end_dir=7, pos={174,653}, speed=340, dur=1 },
		    { event='talk', delay=3.1, handle_id=2, talk='和离……', dur=1.5 },

  			{ event='move', delay= 4.8, handle_id=1, end_dir=7, pos={402,880}, speed=340, dur=1 },
  			{ event='talk', delay=5.4, handle_id=1, talk='丽华——', dur=1.5 },
  			{ event='talk', delay=5.5, handle_id=2, talk='！', dur=1 },

	   		{ event = 'camera', delay = 6.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 399,723 } },

  			{ event='move', delay= 6.5, handle_id=2, end_dir=3, pos={273,754}, speed=340, dur=1 },
  			{ event='talk', delay=7.7, handle_id=2, talk='妾拜见陛下。', dur=1.5 },

  			{ event='talk', delay=9.4, handle_id=1, talk='丽华……', dur=1.3 },
  			{ event='talk', delay=10.9, handle_id=1, talk='正好，借你的笔给我写点东西。', dur=2.5 },
  			{ event='talk', delay=13.6, handle_id=2, talk='陛下请……', dur=1.5 },
  			{ event='talk', delay=15.3, handle_id=1, talk='我念你写。', dur=1.5 },
  			{ event='talk', delay=17, handle_id=2, talk='好吧……', dur=1.5 },

		},

	    --走位+前置对白
		{    
		   	
		    { event = 'camera', delay = 0.2, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 367,625 } },
		    { event='move', delay= 0.2, handle_id=2, end_dir=7, pos={174,653}, speed=340, dur=1 },
  			{ event='move', delay= 0.4, handle_id=1, end_dir=7, pos={271,658}, speed=340, dur=1 },

  			{ event='showTopTalk', delay=2.2, dialog_id="ux39_1" ,dialog_time = 5},
	   		{ event='showTopTalk', delay=7.6, dialog_id="ux39_2" ,dialog_time = 5},
  			
		},

	    --走位+BB
	    {
	   		
	   		{ event='talk', delay=0.2, handle_id=2, talk='哎……', dur=1.3 },
	   		{ event='talk', delay=1.6, handle_id=1, talk='！', dur=1.3 },

	   		{ event = 'camera', delay = 1.6, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 495-100,815+10 } },
	   		{ event='move', delay= 1.6, handle_id=2, end_dir=3, pos={402,880}, speed=340, dur=1 },
	   		{ event='move', delay= 2, handle_id=1, end_dir=7, pos={462,943}, speed=220, dur=1 },

	   		{ event='talk', delay=3.1, handle_id=2, talk='三哥，放我走吧。', dur=1.5 },
	   		{ event='talk', delay=4.8, handle_id=1, talk='丽华……你当真不要我了吗？', dur=2 },

	   		{ event='move', delay= 7, handle_id=1, end_dir=7, pos={446,926}, speed=340, dur=1 },
	   		{ event='talk', delay=7, handle_id=1, talk='丽华……你要什么？', dur=1.3 },

	    },

	     --走位+BB
	    {
	   		{ event='talk', delay=0.2, handle_id=1, talk='你想要什么？别这样对我？', dur=2 },
	   		{ event='talk', delay=2.4, handle_id=2, talk='三哥，如今你已尊天子之位，是否也是时候当犒赏功臣，分封诸侯了？', dur=4.5 },
	   		{ event='talk', delay=7.1, handle_id=1, talk='！', dur=1.3 },
	   		{ event='talk', delay=8.6, handle_id=1, talk='如果这是你想要的……', dur=1.5 },
	   		{ event='talk', delay=10.3, handle_id=2, talk='三哥，以你一介天子之身，去分封列侯吧！', dur=3 },
	   		{ event='talk', delay=13.5, handle_id=2, talk='我累了，真的累了……原谅我……', dur=2.5 },
	   		{ event='talk', delay=16.2, handle_id=2, talk='不愿再守在你身边陪你渡过今后的种种难关了。', dur=3.5 },
	   	
	    },


	     --走位+BB
	    {
	   		
	   		{ event = 'camera', delay = 0.4, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 503,983 } },
	   		{ event='move', delay= 0.4, handle_id=2, end_dir=3, pos={819,1265}, speed=340, dur=1 },
	   		{ event='move', delay= 1, handle_id=1, end_dir=3, pos={503,983}, speed=340, dur=1 },
	   		{ event='talk', delay=1.2, handle_id=1, talk='丽华……', dur=1.5 },
	    	{ event='showTopTalk', delay=0.3, dialog_id="ux39_3" ,dialog_time = 8},
	    	{ event='talk', delay=8, handle_id=1, talk='丽华——！！！', dur=1.5 },
	    	{ event='move', delay= 8, handle_id=1, end_dir=3, pos={819,1265}, speed=340, dur=1 },
	    	{ event='kill', delay=3, handle_id=2}, 

	     },

		{	     
	    	{ event='playBgMusic', delay=0.2, id = 2 ,loop = true},
	    	{ event='init_cimera', delay = 0.2,mx= 1294,my = 305-100 },

	   		{ event='createActor', delay=0.1, handle_id = 2, body=4, pos={1294,305}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},
	   		{ event='showTopTalk', delay=0.5, dialog_id="ux39_4" ,dialog_time = 5},
	   		{ event='move', delay= 5.9, handle_id=2, end_dir=7, pos={1294,305}, speed=340, dur=1.5 },
	   		{ event='showTopTalk', delay=5.9, dialog_id="ux39_5" ,dialog_time = 7},

	    },


	},

	--============================================hanbaobao  主线任务 剧情39 end  =====================================----

--============================================sunluyao  主线任务 剧情40 start  =====================================----
	['juqing-ux040'] =
	{
		{
	   		{ event='createActor', delay=0.1, handle_id = 1, body=3, pos={1780,690}, dir=7, speed=340, name_color=0xffffff, name="光武帝刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=44, pos={1780+100,690+100}, dir=7, speed=340, name_color=0xffffff, name="刘阳"},
		},
		{
	    		{ event='init_cimera', delay = 0.1,mx= 1680,my = 380 },
		},
		{
		    { event='move', delay= 0.1, handle_id=1, end_dir=7, pos={1600+50,495}, speed=300, dur=1 },
		    { event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1600+100,495+100}, speed=300, dur=1 },
	   	    { event='createActor', delay=0.1, handle_id = 3, body=30, pos={1730,270}, dir=7, speed=340, name_color=0xffffff, name="刘强"},
		    { event='move', delay= 0.3, handle_id=3, end_dir=3, pos={1519,442}, speed=300, dur=1 },	   				    
		},
		{
	    	{ event = 'effect', handle_id=10001, target_id = 1,delay = 0.1, pos = {-20, 120}, effect_id = 20008, is_forever = true},
	    	{ event = 'effect', handle_id=10002, target_id = 2,delay = 0.1, pos = {-20, 120}, effect_id = 20008, is_forever = true},
	    	{ event = 'removeEffect', delay = 1.5, handle_id=10001, effect_id=20008},
	    	{ event = 'removeEffect', delay = 1.5, handle_id=10002, effect_id=20008},	    		    		    				
		},
		{
	   		{ event='talk', delay=0.1, handle_id=2, talk='大哥，你这是做什么？', dur=2 }, 
	   		{ event='talk', delay=2.5, handle_id=3, talk='儿臣启禀父皇，愿辞去太子之位，禅于二弟。', dur=2.2 }, 
	   		{ event='talk', delay=5, handle_id=1, talk='！', dur=1.5 },
	   		{ event='talk', delay=5, handle_id=2, talk='！', dur=1.5 }, 
	   		{ event='talk', delay=7, handle_id=1, talk='强儿，朕在三年前就已昭告天下，不会因你母亲之过，而迁怒于你。', dur=3 }, 
	   		{ event='talk', delay=10.5, handle_id=1, talk='怎么？你不相信父皇？', dur=2 }, 	
	   	},
	   	{	 
	   		{ event='talk', delay=0.1, handle_id=3, talk='儿臣不敢……', dur=1.5 }, 
		    --{ event='move', delay= 2, handle_id=2, end_dir=7, pos={1519+50,442+50}, speed=300, dur=1 },
	   		{ event='talk', delay=2.5, handle_id=2, talk='大哥……你怎么突然这么说？', dur=2 }, 
	   		{ event='talk', delay=5, handle_id=2, talk='母后不是教过么，兼爱天下，推己及人，你能做好的。', dur=2.5 }, 	 
	   		{ event='talk', delay=8, handle_id=3, talk='父皇，儿臣已经想清楚了……', dur=2 }, 
	   		{ event='talk', delay=10.5, handle_id=1, talk='[a]胡闹！', dur=1.5, emote={a=24}, }, 
	   		{ event='talk', delay=12.5, handle_id=1, talk='太子之位岂是你想让就让的？', dur=1.5 },
		    { event='move', delay= 11, handle_id=1, end_dir=3, pos={1600+50,495}, speed=300, dur=1 },	   			   			   		 	   			   		
		},
		{
		    { event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1600+10,495+60}, speed=300, dur=1 },
	   		{ event='talk', delay=0.1, handle_id=2, talk='大哥，父皇生气了……', dur=2 }, 
		    { event='move', delay=2, handle_id=3, end_dir=3, pos={1519+30,442+30}, speed=300, dur=1 },	   		
	   		{ event='talk', delay=2.5, handle_id=3, talk='父皇……', dur=2.2 }, 			    
		},
		{
		    { event='move', delay= 0.1, handle_id=1, end_dir=7, pos={1600+50,495}, speed=300, dur=0.5 },
	   		{ event='talk', delay=0.2, handle_id=1, talk='父皇要改立，你有没有想过，天下人答不答应？', dur=2 }, 
	   		{ event='talk', delay=2.5, handle_id=1, talk='你生在天家，肩上有重任，怎么能说这等话？', dur=2.2 }, 
	   		{ event='talk', delay=5, handle_id=3, talk='儿臣……', dur=2.2 }, 
	   		{ event='talk', delay=7.5, handle_id=3, talk='儿臣,明白了……', dur=3 }, 	   			   			
		},
	},
	--============================================sunluyao  主线任务 剧情40 end  =====================================----


	

	--============================================wuwenbin  主线任务 剧情41 start  =====================================----

	--演员表 1 阴戟 2 刘秀 3 阴兴
	['juqing-ux041'] = 
	{
	   
	    --创建角色 
	    {
	   		{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={1580,489}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={782,721}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=23, pos={1840,818}, dir=7, speed=340, name_color=0xffffff, name="阴兴"},

	    },

	    --阴兴出场
		{
			{ event='init_cimera', delay = 0.2,mx= 1604,my = 440 },

			{ event='move', delay= 0.2, handle_id=3, end_dir=7, pos={1671,539}, speed=300, dur=1 },
			{ event='talk', delay=0.5, handle_id=3, talk='姐姐。', dur=2 },
		},

		--阴兴和丽华对话
		{
			{ event='move', delay= 0.2, handle_id=1, end_dir=3, pos={1580,489}, speed=300, dur=1 },
			{ event='talk', delay=0.2, handle_id=1, talk='君陵……', dur=2 },

			{ event='talk', delay=2.5, handle_id=3, talk='我是来跟姐姐辞行的。', dur=2 },
			{ event='talk', delay=4.8, handle_id=3, talk='琥珀是我未过门的妻子。', dur=2 },
			{ event='talk', delay=7.1, handle_id=3, talk='我不能让她死的不明不白！', dur=2 },
			{ event='talk', delay=9.4, handle_id=1, talk='不……', dur=2 },
			{ event='talk', delay=12, handle_id=1, talk='让她死不瞑目的是我……', dur=2 },
			{ event='talk', delay=14.3, handle_id=1, talk='是我害死了她！都是我的错！', dur=2 },
			{ event='talk', delay=16.6, handle_id=1, talk='都是我！呜呜……', dur=2 },
			{ event='talk', delay=18.9, handle_id=3, talk='姐姐，这不是你的错，都是过家害的！', dur=2.5 },
		},

		--丽华悲痛欲绝
		{	
			{ event = 'camera', delay = 0.1, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 773,670 } },
			
			{ event='showTopTalk', delay=1, dialog_id="ux41_1" ,dialog_time = 4},
		},
		{
			{ event='talk', delay=0.1, handle_id=2, talk='丽华……这不是你的错……', dur=2.5 },
		},
		{
			{ event='showTopTalk', delay=0.1, dialog_id="ux41_2" ,dialog_time = 4},
		},
		{
			{ event='talk', delay=0.1, handle_id=2, talk='这都是朕的错……', dur=2.5 },
		},
		{
			{ event='showTopTalk', delay=0.1, dialog_id="ux41_3" ,dialog_time = 4},
		},
		{	
			{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={782+32,721-32}, speed=300, dur=1 },
			{ event='talk', delay=0.1, handle_id=2, talk='丽华……哎……', dur=2.5 },
		},

        --丽华伤心，阴兴勉意安慰
		{    
			{ event = 'camera', delay = 0.1, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 1604,480 } },

			{ event='talk', delay=1, handle_id=3, talk='姐姐，你没事吧……', dur=2 },
			{ event='talk', delay=3.3, handle_id=1, talk='君陵，是姐姐对不起你……是姐姐毁了你和琥珀的一生……', dur=3 },
			{ event='talk', delay=6.6, handle_id=1, talk='姐姐不求你原谅，只求你不去赴死，活着……', dur=3 },
			{ event='talk', delay=9.9, handle_id=3, talk='呜呜……我答应你……好好活着……', dur=2.5 },
			{ event='talk', delay=12.8, handle_id=1, talk='恩……呜呜……', dur=2 },
		},

	    --刘秀决意，铲除过家
	    {
	   		{ event = 'camera', delay = 0.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 773,670 } },

	   		{ event='talk', delay=2, handle_id=2, talk='过珊彤蛇蝎心肠，暗杀丽华幼子，又杀琥珀灭口！', dur=3 },

			{ event='talk', delay=5.3, handle_id=2, talk='这次……', dur=2 },
			{ event='move', delay= 7.6, handle_id=2, end_dir=5, pos={782+32,721-32}, speed=300, dur=1 },
			{ event='talk', delay=7.9, handle_id=2, talk='朕无法再容忍过家了。', dur=2.5 },

			{ event='move', delay= 10.7, handle_id=2, end_dir=3, pos={534,1106}, speed=300, dur=1 },
	    },
	},

	--============================================wuwenbin  主线任务 剧情41 end  =====================================----


--=====================================================================长歌行主线任务剧情动画配置 END =====================================================-------  



----=====================================================================长歌行支线任务剧情动画配置 START =====================================================-------  

    --============================================wuwenbin  每日剧情1 start  =====================================----
   	['juqing-ix001'] = 
	{
		--演员表 1 丽华 2 阴识 3 邓氏 4 阴兴 5 阴氏宗亲 6 阴氏宗亲	101 家仆
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2156,my = 768 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={2194,846}, dir=1, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=30, pos={2126,813}, dir=1, speed=340, name_color=0xffffff, name="阴识"},
	   		
	   		{ event='talk', delay=0.3, handle_id=2, talk='父亲…', dur=2  },
	   		{ event='talk', delay=0.3, handle_id=1, talk='父亲！[a]', dur=2 ,emote ={ a=46} },
	    },

	    --家仆通报表老爷闹事
	    {	
	    	{ event='createActor', delay=0.1, handle_id = 101, body=19, pos={1645,814}, dir=1, speed=340, name_color=0xffffff, name="家仆"},
	   		{ event='move', delay= 0.2, handle_id=101, end_dir=1, pos={2063,851}, speed=240, dur=1.5 },
	   		{ event='talk', delay=0.2, handle_id=101, talk='大公子，表老爷上门来要分阴家的田产！', dur=2  },

	   		{ event='move', delay= 1.5, handle_id=1, end_dir=6, pos={2194,846}, speed=240, dur=1.5 },
	   		{ event='move', delay= 1.5, handle_id=2, end_dir=5, pos={2126,813}, speed=240, dur=1.5 },
	    	{ event='talk', delay=2.2, handle_id=2, talk='什么？[a]', dur=1.5 ,emote ={ a=44} },
	    	{ event='talk', delay=3.9, handle_id=2, talk='[a]', dur=1.5 ,emote ={ a=43} },


	    	{ event='playAction', delay = 3.7, handle_id=2, action_id=4, dur=0.6, dir=5, loop=false ,once = true},
	    },

	    --创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1681,my = 650},

	    	{ event='createActor', delay=0.1, handle_id = 3, body=36, pos={1716,687}, dir=5, speed=340, name_color=0xffffff, name="邓氏"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={1618,750}, dir=1, speed=340, name_color=0xffffff, name="阴伯"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=48, pos={1680,788}, dir=1, speed=340, name_color=0xffffff, name="阴仲"},

	   		{ event='kill', delay=0.1, handle_id=1}, 
	    	{ event='kill', delay=0.1, handle_id=2}, 
	    	{ event='kill', delay=0.1, handle_id=101}, 
	    },

	    --家仆通报表老爷闹事
	    {
	   		{ event='talk', delay=0.1, handle_id=5, talk='阴陆贤弟突然暴病离世，实在可惜啊！', dur=2.5  },
	    	{ event='talk', delay=2.8, handle_id=5, talk='阴家偌大家产，不知要交予谁来打理？', dur=2.5 },

	    	{ event='talk', delay=5.5, handle_id=6, talk='阴识？他还未至及冠之年，如何打理阴家诸事？[a]', dur=3 ,emote = { a = 42}},

	    	{ event='talk', delay=8.8, handle_id=3, talk='不需要你们操心！，我知道你们一直觊觎我阴家的家产。', dur=3 ,},
	    	{ event='talk', delay=12.1, handle_id=3, talk='我夫君尸骨未寒之时，就打起了我们孤儿寡母的主意。', dur=3 ,},
	    	{ event='talk', delay=15.7, handle_id=3, talk='你们对得起自己的良心吗？[a]', dur=2.5 ,emote = { a = 23}},
	    },

	    --阴兴（小，刘阳模型）出现
	    {
	    	{ event='createActor', delay=0.1, handle_id = 4, body=44, pos={2256,853}, dir=5, speed=340, name_color=0xffffff, name="阴兴"},
	    	{ event='move', delay= 0.2, handle_id=4, end_dir=6, pos={1734,791}, speed=280, dur=1.5 },
	   		{ event='talk', delay=0.5, handle_id=4, talk='你们是谁，不许欺负我母亲。', dur=2.5  },

	   		{ event='playAction', delay = 2.7, handle_id=6, action_id=2, dur=1.5, dir=2, loop=false ,},
	   		{ event='playAction', delay = 2.9, handle_id=4, action_id=3, dur=1.5, dir=6, loop=false ,},

	   		
	   		{ event='move', delay= 3.3, handle_id=6, end_dir=1, pos={1680,788}, speed=300, dur=1.5 },
	   		{ event='move', delay= 3.3, handle_id=4, end_dir=5, pos={1752,690}, speed=300, dur=1.5 },
	   		{ event='talk', delay= 4, handle_id=4, talk='你是坏蛋，滚开，不许欺负我娘滚开……[a]', dur=3 ,emote = { a = 33}},
	    },

	    --丽华出现，打了宗亲甲一下
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={2031,853}, dir=5, speed=220, name_color=0xffffff, name="丽华"},
	    	{ event='move', delay= 0.2, handle_id=1, end_dir=7, pos={1712,847}, speed=200, dur=1.5 },

	   		{ event='playAction', delay = 1.5, handle_id=1, action_id=2, dur=1.5, dir=7, loop=false ,},
	   		{ event='playAction', delay = 1.7, handle_id=6, action_id=3, dur=1.5, dir=3, loop=false ,},

	   		{ event='move', delay= 2.2, handle_id=5, end_dir=3, pos={1618,750}, speed=300, dur=1.5 },
	   		-- { event='move', delay= 3, handle_id=4, end_dir=6, pos={1752,690}, speed=300, dur=1.5 },

	   		{ event='talk', delay=2.2, handle_id=6, talk='你又是哪来的野丫头，敢对长辈动手？！[a]', dur=2 ,emote = { a = 34}},
	   		{ event='talk', delay=4.5, handle_id=1, talk='我是阴家的女儿，阴陆是我的爹爹！', dur=2 },
	   		{ event='talk', delay=6.8, handle_id=5, talk='混账，阴家怎会有你这么不懂规矩的丫头', dur=2 },
	   		{ event='talk', delay=9.1, handle_id=6, talk='对啊，从来就没听说过阴家有什么女儿！', dur=2 },
	   		{ event='talk', delay=11.4, handle_id=1, talk='住嘴，敢动我的家人！', dur=2 },
	   		{ event='talk', delay=13.7, handle_id=6, talk='当我怕你不成，来人，赶她出去。', dur=2 },
	    },
    },

    ['juqing-ix002'] = 
	{
		--演员表 1 丽华 2 阴识 3 邓氏 4 阴兴 5 阴氏宗亲 6 阴氏宗亲

	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1681,my = 650},
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1712,847}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=36, pos={1716,687}, dir=5, speed=340, name_color=0xffffff, name="邓氏"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=44, pos={1752,690}, dir=5, speed=340, name_color=0xffffff, name="阴兴"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={1618,750}, dir=3, speed=340, name_color=0xffffff, name="阴伯"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=48, pos={1680,788}, dir=3, speed=340, name_color=0xffffff, name="阴仲"},
	    },

	    --阴识入场
	    {
	    	{ event='createActor', delay=0.1, handle_id = 2, body=30, pos={2031,853}, dir=1, speed=340, name_color=0xffffff, name="阴识"},
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=7, pos={1787,820}, speed=300, dur=1.5 },
	    	{ event='talk', delay=0.2, handle_id=2, talk='放开她！她是我的妹妹——阴姬丽华！', dur=3.5},

	    	{ event='kill', delay=4, handle_id=1}, 
	    	{ event='kill', delay=4, handle_id=2}, 
	    	{ event='kill', delay=4, handle_id=3}, 
	    	{ event='kill', delay=4, handle_id=4}, 
	    	{ event='kill', delay=4, handle_id=5}, 
	    	{ event='kill', delay=4, handle_id=6}, 
	    },

	    --数日后
		{
			{ event = 'changeRGBA',delay=0.1,dur=1,txt = "数日后……"},
			{ event='init_cimera', delay = 0.1,mx= 1219,my = 350 },
			{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1463,531}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
			{ event='createActor', delay=0.1, handle_id = 2, body=30, pos={1170,367}, dir=1, speed=340, name_color=0xffffff, name="阴识"},
		},

		--丽华走过去，询问阴识
		{
			{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={1226,423}, speed=300, dur=1.5 },
			{ event='talk', delay=0.3, handle_id=1, talk='大……大哥，你身体还未痊愈，该好好休息。', dur=2.5},

			{ event='move', delay= 2, handle_id=2, end_dir=3, pos={1170,367}, speed=300, dur=1.5 },	--阴识转身
			{ event='talk', delay=3, handle_id=2, talk='你知道这棵树的来历么？', dur=2},
			
			{ event='talk', delay=5.3, handle_id=1, talk='不知道。', dur=2},
			{ event='talk', delay=7.6, handle_id=2, talk='这棵树，是我八岁之时，父亲与我一起种下的。', dur=2.5},
			{ event='talk', delay=10.4, handle_id=2, talk='那一年，刚好是你出生的年头。', dur=2.5},
		},
		{
			{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1219,150 } },
			{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={1226,423}, speed=300, dur=1.5 },
			{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={1170,367}, speed=300, dur=1.5 },	--阴识转身
			{ event='talk', delay=0.9, handle_id=2, talk='为了应和你的名字，父亲便种下了这些梨花树。', dur=2.5},
			{ event='talk', delay=3.7, handle_id=1, talk='原来是这样。。。。', dur=2},
		},
		{	

			{ event='talk', delay=0.1, handle_id=2, talk='可惜，父亲走后，疏于打理，这棵树已有枯萎迹象。', dur=3},
			{ event='talk', delay=3.5, handle_id=2, talk='我要替父亲照顾好它。这样等到来年春天，它才能开出满树花。', dur=3},
			{ event='talk', delay=6.8, handle_id=2, talk='那景象，真是美轮美奂……', dur=3},
		},
	},

	--============================================wuwenbin  每日剧情1 end  =====================================----

	--============================================lixin  每日剧情2 start  =====================================----
	--演员表  1-阴丽华  2-邓奉 3-阴兴  4-刘秀  5-刘縯  6-刘稷  7-投石车
	['juqing-ix003'] = 
	{
		--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1136,my = 2317 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6,  pos={1038,2384}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=29, pos={1072,2483}, dir=1, speed=340, name_color=0xffffff, name="邓奉"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=20, pos={1170,2481}, dir=1, speed=340, name_color=0xffffff, name="阴兴"},
	    },

	    {
	    	{ event='talk', delay= 1, handle_id=2, talk='哇—', dur=1.5},
	    	{ event='move', delay= 1, handle_id=2, end_dir=1, pos={1097,2455}, speed=300, dur=1.5 },

	    	{ event='createActor', delay=0.1, handle_id = 4, body=12, pos={2189,1809}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=14, pos={2323,1841}, dir=7, speed=340, name_color=0xffffff, name="刘縯"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=22,  pos={2227,1903}, dir=7, speed=340, name_color=0xffffff, name="刘嘉"},
	    },

	    --各种BB
	    {
	    	{ event='talk', delay=0.1,  handle_id=1, talk='看你们两个呆头呆脑的样子，一看就是没见过什么世面！', dur=2},

	    	{ event='move', delay= 2, handle_id=2, end_dir=7, pos={1097,2455}, speed=300, dur=1 },
	    	{ event='move', delay= 2, handle_id=3, end_dir=7, pos={1170,2481}, speed=300, dur=1 },

	    	{ event='talk', delay=2.5, handle_id=3, talk='姐姐，你这个也太厉害了吧！', dur=1.5},
	    	{ event='talk', delay=4.5, handle_id=2, talk='阴家姐姐，这个也太神奇了吧！能教给我吗？', dur=2},
	    	{ event='talk', delay=7, handle_id=1, talk='[a]当然可以啦！这可是先祖留下来的墨家机关术的真传', dur=2,emote={a=18}},
	    },
	    --继续BB
	    {
	    	{ event='talk', delay=1, handle_id=2, talk='我听说刘家兄弟起兵反莽，被围困在舂陵了，不知道现在什么情况了？', dur=3.5},
	    	{ event='talk', delay=4.8, handle_id=1, talk='什么！三哥有难处了嘛？你个小鬼怎么现在才说？', dur=2.5},
	    	{ event='talk', delay=7.5, handle_id=1, talk='兴儿，带上我发明的机关，前去助他一臂之力。', dur=2.5},
	    	{ event='talk', delay=10.5, handle_id=2, talk='我也要去，我也要去，阴家姐姐，让兴儿带上我啊！', dur=2.5},
	    },
	    --转场
	    {
	    	{ event='init_cimera', delay = 0.5,mx= 2251-70,my = 1841-50 },
	    	{ event='kill', delay=0.1, handle_id=2}, 
	    	{ event='kill', delay=0.1, handle_id=3}, 
	    },
	    --继续BB
	    {
	    	{ event='createActor', delay=0.1, handle_id = 2, body=29, pos={2739+20,2160+20}, dir=7, speed=340, name_color=0xffffff, name="邓奉"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=20, pos={2769+20,2131+20}, dir=7, speed=340, name_color=0xffffff, name="阴兴"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=51, pos={2833+20,2161+20}, dir=7, speed=340, name_color=0xffffff, name="投石车"},

	   		{ event='talk', delay=0.1,  handle_id=4, talk='大家不要灰心，只要我们坚持下去，战事必定会出现转机的。', dur=3},
	   		{ event='talk', delay=3.5,  handle_id=5, talk='连日来，战况不利！死伤无数，这批新军还真是顽固！', dur=2.5},
	   		{ event='talk', delay=6.5,  handle_id=6, talk='战局不利，我们还在守着干嘛？等着被困死啊！', dur=2.5},

	   		{ event='move', delay= 8, handle_id=3, end_dir=1, pos={2354,1968}, speed=280, dur=1.5 },

	   		{ event='move', delay= 9, handle_id=4, end_dir=3, pos={2189,1809}, speed=300, dur=1.5 },
	   		{ event='move', delay= 9, handle_id=5, end_dir=3, pos={2323,1841}, speed=300, dur=1.5 },
	   		{ event='move', delay= 9, handle_id=6, end_dir=3, pos={2227,1903}, speed=300, dur=1.5 },
	   		{ event='talk', delay=12,  handle_id=4, talk='？', dur=1.5},
	   		{ event='talk', delay=12,  handle_id=5, talk='？', dur=1.5},
	   		{ event='talk', delay=12,  handle_id=6, talk='？', dur=1.5},

	   		{ event='talk', delay= 10,  handle_id=3, talk='刘家几位大哥，不要着急，看我带来了什么！', dur=2},
	   		{ event='talk', delay=12.2,  handle_id=3, talk='这次必定能攻克新军！', dur=1.5},
	    },
	    --投石车镜头
	    {
	    	-- { event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2422,1158 } },
	    	{ event ='camera', delay = 0.1, target_id = 7, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
	    	{ event='move', delay= 0.5, handle_id=2, end_dir=7, pos={2414,1936}, speed=300, dur=1.5 },
	    	{ event='move', delay= 0.5, handle_id=7, end_dir=7, pos={2482,1904}, speed=300, dur=1.5 },

	    	{ event = 'camera', delay = 3, dur=0.5,sdur = 1,style = '',backtime=1, c_topox = { 2452,1803 } },

	    	{ event='talk', delay=3,  handle_id=2, talk='怎么样，我们来的及时吧！', dur=1.5},

	    	{ event='talk', delay=4,  handle_id=4, talk='！', dur=1.5},
	   		{ event='talk', delay=4,  handle_id=5, talk='！', dur=1.5},
	   		{ event='talk', delay=4,  handle_id=6, talk='！', dur=1.5},

	   		{ event='move', delay= 4, handle_id=4, end_dir=3, pos={2323,1874}, speed=200, dur=1.5 },
	   		{ event='move', delay= 4, handle_id=6, end_dir=3, pos={2353,1806}, speed=200, dur=1.5 },
	   		{ event='move', delay= 4, handle_id=5, end_dir=3, pos={2449,1778}, speed=200, dur=1.5 },
	    },

	    --刘秀吃惊~
	    {

	    	{ event='talk', delay=0.1,  handle_id=4, talk='这……这是机关术？', dur=1.5},
	    	{ event='talk', delay=2,  handle_id=4, talk='丽华，是丽华让你们来的？', dur=1.5},

	    	{ event='talk', delay=4.5,  handle_id=6, talk='这次有新军受的了！', dur=1.5},

	    	{ event='move', delay= 6, handle_id=4, end_dir=1, pos={2323,1874}, speed=200, dur=1.5 },
	   		{ event='move', delay= 6, handle_id=6, end_dir=5, pos={2353,1806}, speed=200, dur=1.5 },
	   		{ event='move', delay= 6, handle_id=5, end_dir=5, pos={2449,1778}, speed=200, dur=1.5 },

	    	{ event='talk', delay=6.5,  handle_id=4, talk='传我命令，出战！', dur=1.5},

	    	{ event='talk', delay=8.5,  handle_id=5, talk='诺！', dur=2.5},
	    	{ event='talk', delay=8.5,  handle_id=6, talk='诺！', dur=2.5},
	    },
	},

	['juqing-ix004'] = 
	{
		--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 494,my = 1804 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 2, body=29, pos={466,1839}, dir=3, speed=340, name_color=0xffffff, name="邓奉"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=20, pos={433,1904}, dir=2, speed=340, name_color=0xffffff, name="阴兴"},

	   		{ event='createActor', delay=0.1, handle_id = 4, body=12, pos={532,1935}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=14, pos={651,1868}, dir=6, speed=340, name_color=0xffffff, name="刘縯"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=22,  pos={562,1807}, dir=5, speed=340, name_color=0xffffff, name="刘嘉"},
	    },

	    {
	    	-- { event='talk', delay=1,  handle_id=6, talk='[a]不堪一击，这次我们终于打了一个大胜仗！', dur=2,emote = {a=18}},
	    	-- { event='talk', delay=3.5,  handle_id=5, talk='[a]三弟，真有你的啊！', dur=1.5,emote = {a=16}},
	    	-- { event='talk', delay=5.5,  handle_id=2, talk='还是阴家姐姐厉害，这次我服了！', dur=2},
	    	-- { event='talk', delay=8,  handle_id=3, talk='姐姐真是厉害啊，回去之后我一定要学这个。', dur=2},
	    	-- { event='talk', delay=10.5,  handle_id=4, talk='我们定能成就一番大业的！', dur=2.5},


	    	{ event='talk', delay=1,  handle_id=2, talk='还是阴家姐姐厉害，这次我服了！', dur=2},
	    	{ event='talk', delay=3.5,  handle_id=3, talk='姐姐真是厉害啊，回去之后我一定要学这个。', dur=2},
	    	{ event='talk', delay=6,  handle_id=6, talk='[a]不堪一击，这次我们终于打了一个大胜仗！', dur=2,emote = {a=18}},
	    	{ event='talk', delay=8.5,  handle_id=5, talk='[a]三弟，真有你的啊！', dur=1.5,emote = {a=16}},
	    	{ event='talk', delay=10.5,  handle_id=4, talk='我们定能成就一番大业的！', dur=2.5},
	    },
	},
	--============================================lixin  每日剧情2 end  =====================================----

--================================================	luyao	每日剧情3 start ==============================================
	['juqing-ix005'] =
	{
		{
			{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={554,1550}, dir=3, speed=340, name_color=0xffffff, name="丽华"},
			{ event='createActor', delay=0.1, handle_id = 2, body=10, pos={454,1580}, dir=3, speed=340, name_color=0xffffff, name="邓婵"},
			{ event='createActor', delay=0.1, handle_id = 3, body=30, pos={654,1612}, dir=7, speed=340, name_color=0xffffff, name="阴识"},

	   		{ event='init_cimera', delay = 0.2,mx= 604,my = 1502},

			{ event='talk', delay=1, handle_id=3, talk='听说邓家今年要举行祭祖的大典。', dur=2},
			{ event='talk', delay=3.5, handle_id=3, talk='近些年来阴邓两家交好。正好婵儿也在阴家，你们两个一起过去看看吧。', dur=3},
			{ event='talk', delay=7, handle_id=1, talk='太好啦！这几天在家快把我闷坏了！', dur=2},
			{ event='talk', delay=9.5, handle_id=1, talk='大哥最好了，我这就和表姐一起过去。', dur=3},
		},
		{

			{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={749,914}, dir=3, speed=340, name_color=0xffffff, name="邓晨"},
			{ event='createActor', delay=0.1, handle_id = 5, body=1, pos={663,975}, dir=3, speed=340, name_color=0xffffff, name="邓禹"},
			{ event='createActor', delay=0.1, handle_id = 6, body=29, pos={874,864}, dir=3, speed=340, name_color=0xffffff, name="邓奉"},
			{ event='createActor', delay=0.1, handle_id = 11, body=19, pos={986,878}, dir=5, speed=340, name_color=0xffffff, name="宗亲"},
			{ event='createActor', delay=0.1, handle_id = 12, body=19, pos={715,1048}, dir=1, speed=340, name_color=0xffffff, name="宗亲"},
			{ event='createActor', delay=0.1, handle_id = 13, body=38, pos={1051,915}, dir=5, speed=340, name_color=0xffffff, name="宾客"},
			{ event='createActor', delay=0.1, handle_id = 14, body=38, pos={783,1086}, dir=1, speed=340, name_color=0xffffff, name="宾客"},

			{ event='move', delay= 0.1, handle_id=1, end_dir=6, pos={878,1513}, speed=200, dur=1.5 },

			{ event='move', delay= 0.8, handle_id=2, end_dir=2, pos={778,1513}, speed=300, dur=1.5 },

			{ event='talk', delay=0.5, handle_id=2, talk='丽华，你干嘛？慢点啊！毛毛躁躁的哪有一点女孩子的样子！', dur=3},

			{ event = 'camera', delay = 1.8, dur=0.8,sdur = 0.8,style = '',backtime=1, c_topox = { 820,1431 } },	

			{ event='talk', delay=4, handle_id=2, talk='哎呀，慢点啦！', dur=1.5},

			{ event = 'changeRGBA',delay=5,dur=2,txt = ""},

			{ event = 'camera', delay = 5.2, dur=1.2,sdur = 1.2,style = '',backtime=1, c_topox = { 884,855 } },

			{ event='move', delay= 4, handle_id=1, end_dir=7, pos={873,958}, speed=300, dur=2.5 },
			{ event='move', delay= 4.5, handle_id=2, end_dir=7, pos={793,990}, speed=300, dur=2.5 },

		},
		{ 
			{ event='talk', delay=0.1, handle_id=4, talk='你们来的正好！祭祖大典马上就要开始了。', dur=2},
			{ event='talk', delay=2.5, handle_id=4, talk='不要乱跑，让宗亲们笑话。', dur=2},

			{ event='createActor', delay=4, handle_id = 7, body=13, pos={1088,1142}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
			{ event='move', delay= 4.1, handle_id=7, end_dir=7, pos={911,1023}, speed=340, dur=1.5 },

			{ event='talk', delay=5, handle_id=7, talk='姐夫，不好了！外面来了一群土匪。', dur=2},
			{ event='move', delay= 5, handle_id=1, end_dir=3, pos={873,958}, speed=100, dur=1.5 },
			{ event='move', delay= 5, handle_id=2, end_dir=3, pos={793,990}, speed=100, dur=1.5 },
		},
		{
			{ event='talk', delay=0.1, handle_id=5, talk='真是无知狂徒，来招惹我们邓家。', dur=2.2},
			{ event='move', delay= 2.5, handle_id=5, end_dir=1, pos={663,975}, speed=340, dur=1.5 },			
			{ event='talk', delay=3, handle_id=5, talk='奉儿，带人去教训教训他们。', dur=2},
			{ event='move', delay= 4.5, handle_id=6, end_dir=5, pos={874,864}, speed=340, dur=1.5 },
			{ event='talk', delay=5.5, handle_id=6, talk='敢来我们邓家捣乱！看我不结果了你们。', dur=2},

			{ event='move', delay= 7.5, handle_id=6, end_dir=3, pos={1088,1142}, speed=340, dur=1.5 },
		},
	},

	['juqing-ix006'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 884,my = 855},

			{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={873,958}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
			{ event='createActor', delay=0.1, handle_id = 2, body=10, pos={793,990}, dir=7, speed=340, name_color=0xffffff, name="邓婵"},		
			{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={749,914}, dir=3, speed=340, name_color=0xffffff, name="邓晨"},
			{ event='createActor', delay=0.1, handle_id = 5, body=1, pos={663,975}, dir=3, speed=340, name_color=0xffffff, name="邓禹"},
			{ event='createActor', delay=0.1, handle_id = 6, body=29, pos={874,864}, dir=3, speed=340, name_color=0xffffff, name="邓奉"},
			{ event='createActor', delay=0.1, handle_id = 7, body=13, pos={1058,967}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},	
			{ event='createActor', delay=0.1, handle_id = 11, body=19, pos={986,878}, dir=5, speed=340, name_color=0xffffff, name="宗亲"},
			{ event='createActor', delay=0.1, handle_id = 12, body=19, pos={715,1048}, dir=1, speed=340, name_color=0xffffff, name="宗亲"},
			{ event='createActor', delay=0.1, handle_id = 13, body=38, pos={1051,915}, dir=5, speed=340, name_color=0xffffff, name="宾客"},
			{ event='createActor', delay=0.1, handle_id = 14, body=38, pos={783,1086}, dir=1, speed=340, name_color=0xffffff, name="宾客"},

			{ event='talk', delay=1, handle_id=4, talk='让宗亲宾客们受惊了，邓晨疏忽了！', dur=2},
			{ event='talk', delay=3.5, handle_id=6, talk='不知死活的东西，敢来我们邓家抢劫！', dur=2},
	    	{ event='playAction', delay = 3.5, handle_id=6, action_id=2, dur=1.5, dir=3, loop=false ,},

			{ event='talk', delay=6, handle_id=5, talk='好了，大家没事就好了！', dur=1.8},
			{ event='talk', delay=8.5, handle_id=5, talk='先把丽华送回阴家庄吧，免得再出纰漏！', dur=2},

			{ event='talk', delay=11, handle_id=1, talk='不怕，我在阴家和邓家不是一样吗？', dur=2},
			{ event='talk', delay=13.5, handle_id=4, talk='先把丽华和婵儿护送回内院在说吧。', dur=2},

			{ event='move', delay= 14.5, handle_id=1, end_dir=3, pos={1595,782}, speed=340, dur=2.5 },
			{ event='move', delay= 14.5, handle_id=2, end_dir=3, pos={1595,782}, speed=340, dur=2.5 },
			{ event='move', delay= 14.5, handle_id=11, end_dir=3, pos={1595,782}, speed=340, dur=2.5 },
			{ event='move', delay= 14.5, handle_id=12, end_dir=3, pos={1595,782}, speed=340, dur=2.5 },

			{ event='move', delay= 15, handle_id=4, end_dir=1, pos={749,914}, speed=340, dur=2.5 },
			{ event='move', delay= 15, handle_id=5, end_dir=1, pos={663,975}, speed=340, dur=2.5 },
			{ event='move', delay= 15, handle_id=6, end_dir=1, pos={874,864}, speed=340, dur=2.5 },
			{ event='move', delay= 15, handle_id=7, end_dir=1, pos={1058,967}, speed=340, dur=2.5 },
			{ event='move', delay= 15, handle_id=13, end_dir=1, pos={1051,915}, speed=340, dur=2.5 },

		},
		{
			{ event='talk', delay=0.1, handle_id=4, talk='传信给阴次伯，提防山匪袭城。', dur=3},	
		},


	},






--================================================	luyao	每日剧情3 end ==============================================

--================================================	luyao	每日剧情4 start ============================================

['juqing-ix007'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 2850,my = 1939},		
			{ event='createActor', delay=0.1, handle_id = 1, body=1, pos={2640,2110}, dir=1, speed=340, name_color=0xffffff, name="邓禹"},


			{ event='createActor', delay=0.1, handle_id = 5, body=45, pos={3011,1655}, dir=3, speed=340, name_color=0xffffff, name="青州百姓"},

			{ event='createActor', delay=0.1, handle_id = 6, body=46, pos={3011,1655}, dir=5, speed=340, name_color=0xffffff, name="青州百姓"},	
			--{ event='createActor', delay=0.1, handle_id = 7, body=29, pos={3011,1655}, dir=5, speed=340, name_color=0xffffff, name="青州百姓"},

			{ event='createActor', delay=0.1, handle_id = 8, body=45, pos={2348,2293}, dir=1, speed=340, name_color=0xffffff, name="青州百姓"},
			{ event='createActor', delay=0.1, handle_id = 9, body=46, pos={2481,1682}, dir=5, speed=340, name_color=0xffffff, name="青州百姓"},
			{ event='createActor', delay=0.1, handle_id = 10, body=45, pos={2348,2293}, dir=1, speed=340, name_color=0xffffff, name="青州百姓"},


			{ event='move', delay= 1.6, handle_id=5, end_dir=5, pos={2690,1990}, speed=340, dur=2.5 },
			{ event='move', delay= 2.6, handle_id=1, end_dir=1, pos={2610,2050}, speed=340, dur=2.5 },


			{ event='move', delay= 0.2, handle_id=6, end_dir=1, pos={2317,2568}, speed=340, dur=2.5 },
			{ event='move', delay= 2, handle_id=10, end_dir=1, pos={2317,2568}, speed=340, dur=2.5 },
			{ event='move', delay= 1, handle_id=8, end_dir=1, pos={2177,2313}, speed=340, dur=2.5 },
			{ event='move', delay= 4, handle_id=9, end_dir=1, pos={2177,2313}, speed=340, dur=2.5 },
			--{ event='move', delay= 6, handle_id=7, end_dir=1, pos={2177,2313}, speed=340, dur=2.5 },

			{ event='createActor', delay=1.5, handle_id = 11, body=46, pos={2948,1693}, dir=5, speed=340, name_color=0xffffff, name="青州百姓"},	
			{ event='move', delay= 1.6, handle_id=11, end_dir=5, pos={2620,1940}, speed=340, dur=2.5 },	

	    	{ event='kill', delay=4.5, handle_id=6},
	    	--{ event='kill', delay=10.5, handle_id=7},
	    	{ event='kill', delay=5.5, handle_id=8},
	    	{ event='kill', delay=8.5, handle_id=9},
	    	{ event='kill', delay=6.5, handle_id=10},	

			{ event='talk', delay=4, handle_id=1, talk='请问兄台，此地是何处？', dur=1.8},
			{ event='talk', delay=6, handle_id=1, talk='为何如此荒凉，人烟淡薄？', dur=1.8},
			{ event='talk', delay=8.5, handle_id=5, talk='此地已经干旱很久啦，年轻的都出去逃荒了。', dur=2.5},
			{ event='talk', delay=11.5, handle_id=11, talk='年老的年幼的只能慢慢的等死了。', dur=2.5},
		},

		{
			{ event='createActor', delay=0.1, handle_id = 2, body=43, pos={2781,2173}, dir=7, speed=340, name_color=0xffffff, name="青州郡守"},		
			{ event='createActor', delay=0.1, handle_id = 3, body=22, pos={2781,2248}, dir=7, speed=340, name_color=0xffffff, name="青州官兵"},
			{ event='createActor', delay=0.1, handle_id = 4, body=22, pos={2875,2198}, dir=7, speed=340, name_color=0xffffff, name="青州官兵"},

			{ event='move', delay= 0.2, handle_id=2, end_dir=7, pos={2681,2083}, speed=340, dur=2.5 },
			{ event='move', delay= 0.2, handle_id=3, end_dir=7, pos={2681,2158}, speed=340, dur=2.5 },
			{ event='move', delay= 0.2, handle_id=4, end_dir=7, pos={2775,2148}, speed=340, dur=2.5 },

			{ event='move', delay= 1.5, handle_id=1, end_dir=3, pos={2610,2050}, speed=340, dur=2.5 },
			{ event='move', delay= 1.5, handle_id=11, end_dir=3, pos={2620,1940}, speed=340, dur=2.5 },
			{ event='move', delay= 1.5, handle_id=5, end_dir=3, pos={2690,1990}, speed=340, dur=2.5 },

			{ event='talk', delay=1.1, handle_id=2, talk='去去去，一群刁民在此胡言乱语，', dur=2},

			{ event='talk', delay=1.8, handle_id=5, talk='！！！', dur=1},
			{ event='talk', delay=1.8, handle_id=11, talk='！！！', dur=1},

			{ event='talk', delay=3.5, handle_id=2, talk='我看现在的匪患就是你们搞出来的，赶快散开！', dur=2.2},
			{ event='talk', delay=6, handle_id=3, talk='我们也不愿意看着自己的兄弟姐妹被灾荒所困扰啊。', dur=2.2},
			{ event='talk', delay=8.5, handle_id=4, talk='但是现在朝廷让我们去剿匪，我们也没有办法啊！', dur=2.2},

			{ event='move', delay= 5.1, handle_id=5, end_dir=7, pos={2348,2293}, speed=340, dur=2.5 },
			{ event='move', delay= 5.1, handle_id=11, end_dir=7, pos={2348,2293}, speed=340, dur=2.5 },

	    	{ event='kill', delay=7.1, handle_id=11},
	    	{ event='kill', delay=7.1, handle_id=5},

		},
		{


			{ event='createActor', delay=0.1, handle_id = 12 , body=22, pos={2649,1708}, dir=7, speed=340, name_color=0xffffff, name="青州官兵"},
			{ event='createActor', delay=0.1, handle_id = 13 , body=22, pos={2908,1705}, dir=1, speed=340, name_color=0xffffff, name="青州官兵"},	
			{ event = 'camera', delay = 0.8, dur=1,sdur = 1,style = '',backtime=1, c_topox = { 2741,1617 } },		
			{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={2741,1817}, speed=340, dur=2.5 },

			{ event='move', delay= 3, handle_id=12, end_dir=3, pos={2649,1708}, speed=340, dur=0.5 },
			{ event='move', delay= 3, handle_id=13, end_dir=5, pos={2908,1705}, speed=340, dur=0.5 },

			{ event='talk', delay=2.5, handle_id=1, talk='剿匪？现在黎民苍生都活不下去了，还要剿匪？', dur=2.2},
			{ event='talk', delay=5, handle_id=12, talk='你说的太对了！', dur=1.8},
			{ event='talk', delay=7.5, handle_id=13, talk='我们也不想去打仗。', dur=2},

		},
		{
			{ event='createActor', delay=0.1, handle_id = 14 , body=32, pos={2462,1457}, dir=3, speed=340, name_color=0xffffff, name="草莽跟班"},
			{ event='createActor', delay=0.1, handle_id = 15 , body=32, pos={2888,1387}, dir=5, speed=340, name_color=0xffffff, name="草莽跟班"},


			{ event='jump', delay=0.2, handle_id=14, dir=3, pos={2649,1758}, speed=120, dur=1, end_dir=7 },
			{ event='jump', delay=0.2, handle_id=15, dir=5, pos={2908,1755}, speed=120, dur=1, end_dir=1 },	

	    	{ event='playAction', delay = 0.8, handle_id=14, action_id=2, dur=0.5, dir=1, loop=false ,},
	    	{ event='playAction', delay = 0.8, handle_id=15, action_id=2, dur=0.5, dir=1, loop=false ,},

	    	{ event='playAction', delay = 1, handle_id=12, action_id=4, dur=0.5, dir=1, loop=false , once=true },
	    	{ event='playAction', delay = 1, handle_id=13, action_id=4, dur=0.5, dir=1, loop=false , once=true },

			{ event='move', delay= 1.5, handle_id=14, end_dir=3, pos={2649,1758}, speed=340, dur=0.5 },	    	
			{ event='move', delay= 1.5, handle_id=15, end_dir=5, pos={2908,1755}, speed=340, dur=0.5 },
		},
		{
			{ event='createActor', delay=6.6, handle_id = 16 , body=47, pos={2766,1479}, dir=5, speed=340, name_color=0xffffff, name="草莽头目"},		
			{ event='talk', delay=0.1, handle_id=14, talk='既然来了，就留下点东西再走吧！', dur=2},
			{ event='talk', delay=2.5, handle_id=14, talk='兄弟们，有人闯山！', dur=1.8},
			{ event='talk', delay=4.5, handle_id=15, talk='隔几天就来一次，你们欺人太甚。', dur=2},
			{ event='talk', delay=7, handle_id=15, talk='看来朝廷是不想让我们活下去了！', dur=2},

			{ event='move', delay= 7.1, handle_id=16, end_dir=5, pos={2795,1679}, speed=340, dur=2.5 },

			{ event='talk', delay=9.5, handle_id=16, talk='多说无益，想剿灭我们就拿出点真本事。', dur=2},
			{ event='talk', delay=12, handle_id=16, talk='若是你真的打败了我，我愿意带领众兄弟跟随于你，任凭你差遣。', dur=3.5},

		},

	},

['juqing-ix008'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 2548,my = 875},			
			{ event='createActor', delay=0.1, handle_id = 1 , body=47, pos={2462,963}, dir=3, speed=340, name_color=0xffffff, name="草莽头目"},
			{ event='createActor', delay=0.1, handle_id = 2 , body=32, pos={2408,1044}, dir=3, speed=340, name_color=0xffffff, name="草莽跟班"},
			{ event='createActor', delay=0.1, handle_id = 3 , body=32, pos={2613,969}, dir=3, speed=340, name_color=0xffffff, name="草莽跟班"},
			{ event='createActor', delay=0.1, handle_id = 4 , body=1, pos={2599,1059}, dir=7, speed=340, name_color=0xffffff, name="邓禹"},
		},
		{	
			{ event='talk', delay=0.5, handle_id=4, talk='大首领，你败了！', dur=1.5},
			{ event='talk', delay=2.5, handle_id=1, talk='男子汉一言既出驷马难追。', dur=2},
			{ event='talk', delay=5, handle_id=1, talk='既然败于你手，我们自当遵守诺言。', dur=2},	
			{ event='talk', delay=7.5, handle_id=2, talk='我们也愿意追随邓公子！', dur=2.5},	
			{ event='talk', delay=7.5, handle_id=3, talk='我们也愿意追随邓公子！', dur=2.5},	


		},

	},
--================================================	luyao	每日剧情4 end ==============================================

    --============================================wuwenbin  每日剧情5 start  =====================================----
   	['juqing-ix009'] = 
	{
		--演员表 1 吴汉 2 新军头目 3 吴汉小弟 4 吴汉小弟 5-8 新军兵痞
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2810,my = 722 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=8, pos={2318,1270}, dir=1, speed=340, name_color=0xffffff, name="吴汉"},

	    	{ event='createActor', delay=0.1, handle_id = 3, body=15, pos={2234,1320}, dir=1, speed=340, name_color=0xffffff, name="吴汉小弟"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=16, pos={2288,1350}, dir=1, speed=340, name_color=0xffffff, name="吴汉小弟"},

	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={2706,784}, dir=5, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=27, pos={2766,820}, dir=5, speed=340, name_color=0xffffff, name="新军兵痞"},

	   		--围着吴汉和吴汉小弟的兵痞
	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={2230,1206}, dir=3, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={2448,1334}, dir=7, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={2200-32,1352+32}, dir=1, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 10, body=27, pos={2250-32,1382+32}, dir=1, speed=340, name_color=0xffffff, name="新军兵痞"},
	    },

	    --兵痞想去欺负一下新兵
	    {	

	   		{ event='talk', delay=0.1, handle_id=5, talk='兄弟，看到没有，又有新来的了。[a]', dur=2 ,emote= { a = 2} },
	   		{ event='talk', delay=2.3, handle_id=6, talk='走，过去瞧瞧!', dur=1.5  },

	   		{ event ='camera', delay = 3.8, target_id = 5, sdur=0.5, dur = 0.5,style = 'follow',backtime=1},
	   		{ event='move', delay= 3.8, handle_id=5, end_dir=5, pos={2358,1200}, speed=240, dur=1.5 },
	   		{ event='move', delay= 3.8, handle_id=6, end_dir=5, pos={2418,1234}, speed=240, dur=1.5 },
	    },


	    --吴汉反抗
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2422,1158 } },
	   		{ event='talk', delay=0.1, handle_id=3, talk='你们欺人太甚，我们也是被强迫抓进队伍的。', dur=2.5  },
	    	{ event='talk', delay=2.8, handle_id=3, talk='你们凭什么欺负我们？', dur=2.5 },

	    	{ event='talk', delay=5.5, handle_id=1, talk='你们要做什么？我们也不是好欺负的！', dur=2.5},
	    	{ event='playAction', delay = 8, handle_id=1, action_id=2, dur=1.5, dir=1, loop=false ,},
	   		
	   		{ event='talk', delay=8.3, handle_id=5, talk='哎呦！', dur=2},
	   		{ event='playAction', delay = 8.3, handle_id=5, action_id=3, dur=1.5, dir=5, loop=false ,},
	   		{ event='move', delay= 8.6, handle_id=5, end_dir=5, pos={2358+16 ,1200-16}, speed=240, dur=1.5 },
	    },

	    --新军头目出现想教训吴汉
	    {
	    	{ event='createActor', delay=0.1, handle_id = 2, body=21, pos={2574,982}, dir=1, speed=340, name_color=0xffffff, name="新军首领"},
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=5, pos={2458-16,1144+16}, speed=280, dur=1.5 },

	    	{ event='talk', delay=2, handle_id=2, talk='放肆，敢打我的手下，来人啊！', dur=2.5 ,},
	    	{ event='talk', delay=4.8, handle_id=2, talk='给我绑起来，好好教训一下！', dur=2.5 ,},

	    	{ event='talk', delay=7.6, handle_id=5, talk='打他们！', dur=2 ,},
	    	{ event='playAction', delay = 7.6, handle_id=5, action_id=2, dur=1.5, dir=5, loop=false ,},

	    	{ event='talk', delay=9.9, handle_id=6, talk='让他们不懂规矩!', dur=2.5 ,},
	    },

	    --吴汉小弟慌张
	    {
	   		{ event='talk', delay=0.5, handle_id=3, talk='大哥！大哥！', dur=2  },
	   		{ event='talk', delay=2.8, handle_id=3, talk='我们怎么办啊？', dur=2  },
	   		{ event='talk', delay=5.1, handle_id=1, talk='既然你们先动手，那就不要怪我们了。', dur=2.5  },
	   		{ event='talk', delay=7.9, handle_id=2, talk='好，那就来吧！看你们能翻起多大的风浪。', dur=2.5  },
	    },
    },

    ['juqing-ix010'] = 
	{
		--演员表 1 吴汉 2 新军头目 3 吴汉小弟 4 吴汉小弟 5-8 新军兵痞

	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2422,my = 1120},
	    	{ event='createActor', delay=0.1, handle_id = 1, body=8, pos={2318,1270}, dir=1, speed=340, name_color=0xffffff, name="吴汉"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=21, pos={2458-16,1144+16}, dir=5, speed=340, name_color=0xffffff, name="新军首领"},

	    	{ event='createActor', delay=0.1, handle_id = 3, body=15, pos={2234,1320}, dir=1, speed=340, name_color=0xffffff, name="吴汉小弟"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=16, pos={2288,1350}, dir=1, speed=340, name_color=0xffffff, name="吴汉小弟"},

	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={2358,1200}, dir=5, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=27, pos={2418,1234}, dir=5, speed=340, name_color=0xffffff, name="新军兵痞"},

	   		--围着吴汉和吴汉小弟的兵痞
	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={2230,1206},dir=3, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={2448,1334},dir=7, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={2200-32,1352+32}, dir=1, speed=340, name_color=0xffffff, name="新军兵痞"},
	   		{ event='createActor', delay=0.1, handle_id = 10, body=27, pos={2250-32,1382+32}, dir=1, speed=340, name_color=0xffffff, name="新军兵痞"},

	   		{ event='playAction', delay = 0.2, handle_id=7, action_id=4, dur=1.5, dir=7, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=8, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=9, action_id=4, dur=1.5, dir=5, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=10, action_id=4, dur=1.5, dir=5, loop=false ,once = true},
	    },

	    --两个兵痞跑走
	    {
	    	{ event='talk', delay=0.1, handle_id=5, talk='你们不要跑，给我等着！[a]', dur=2.5,emote = { a = 41 }},
	    	{ event='talk', delay=2.8, handle_id=6, talk='快去通知大人，有人要造反。[a]', dur=2.5,emote = { a = 41 }},

	    	{ event='move', delay= 5.5, handle_id=2, end_dir=1, pos={2458-16,1144+16}, speed=300, dur=1.5 },
	    	{ event='talk', delay=5.5, handle_id=2, talk='你们……等等[a]', dur=2.5,emote = { a = 22 }},

	    	{ event='move', delay= 5.5, handle_id=5, end_dir=1, pos={2706,784}, speed=300, dur=1.5 },
	    	{ event='move', delay= 5.5, handle_id=6, end_dir=1, pos={2766,820},speed=300, dur=1.5 },

	    	{ event='kill', delay=7, handle_id=5},
	    	{ event='kill', delay=7, handle_id=6},
	    },

	    --吴汉最后抵抗
		{
			{ event='talk', delay=0.1, handle_id=3, talk='大哥，我们怎么办？', dur=1.5},
	    	{ event='talk', delay=2, handle_id=1, talk='反了又能如何？就凭你们几个能拦得住我。', dur=2.5},

	    	{ event='move', delay= 0.5, handle_id=2, end_dir=5, pos={2458-16,1144+16}, speed=300, dur=1.5 },
	    	{ event='talk', delay=2, handle_id=2, talk='[a]', dur=2.5,emote = { a = 41 }},

	    	{ event='move', delay=2, handle_id= 1, dir=1, pos={2386,1200}, speed=200, dur=0.3, end_dir=1 }, 

	    	{ event = 'playAction',delay =4.8,  handle_id= 1, action_id = 2, dur = 0.2, dir = 1,loop = false, },
	    	{ event='talk', delay=4.8, handle_id=1, talk='识相一点就给我滚开！', dur=2},

	    	{ event = 'playAction',delay =5,  handle_id= 2, action_id = 3, dur = 0.2, dir = 5,loop = false, },
	    	{ event='talk', delay=5.2, handle_id=2, talk='啊——！', dur=1.5},
		},

		--兵头逃跑
		{
			{ event='talk', delay=0.1, handle_id=2, talk='造反啦！造反啦！有人夺营了！', dur=3.5},
			{ event='move', delay= 0.4, handle_id=2, end_dir=7, pos={2706,784}, speed=300, dur=1.5 },
		},
	},

	--============================================wuwenbin  每日剧情5 end  =====================================----

    --============================================wuwenbin  每日剧情6 start  =====================================----
   	['juqing-ix011'] = 
	{
		--演员表 1 王匡 2 王凤 3 宛城郡守 4 南阳郡守 5-6 绿林军 7 流民 8 新军 101-104 摆设绿林军 201-204 摆设新军
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 484,my = 1580 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=55, pos={464,1582}, dir=3, speed=340, name_color=0xffffff, name="王匡"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=9, pos={526,1620}, dir=7, speed=340, name_color=0xffffff, name="王凤"},
	    	
	    	{ event='createActor', delay=0.1, handle_id = 3, body=18, pos={2898,562}, dir=5, speed=340, name_color=0xffffff, name="南阳郡守"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=48, pos={2958,590}, dir=5, speed=340, name_color=0xffffff, name="宛城城守"},

	    	{ event='createActor', delay=0.1, handle_id = 5, body=15, pos={438-16,1654+16}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=16, pos={500-16,1670+16}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=32, pos={366-16,1608+16}, dir=1, speed=340, name_color=0xffffff, name="流民"},

	   		--摆设型绿林军
	   		{ event='createActor', delay=0.1, handle_id = 101, body=15, pos={332-16,1670+16}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=15, pos={404-16,1706+16}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=15, pos={472-16,1744+16}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=15, pos={598-16,1682+16}, dir=7, speed=340, name_color=0xffffff, name="绿林军"},

	   		--摆设型新军
	   		{ event='createActor', delay=0.1, handle_id = 201, body=27, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=27, pos={2990,500}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=27, pos={3058,528}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=27, pos={3124,558}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	    },

	    --王匡，王凤吐槽世道不公
	    {	
	   		{ event='talk', delay=0.1, handle_id=1, talk='现在这世道，我们还怎么活下去啊？', dur=2.5 },
	   		{ event='talk', delay=2.8, handle_id=2, talk='大哥，谁说不是呢!', dur=2  },
	   		{ event='talk', delay=5.1, handle_id=2, talk='你看看这世道！哎，不如反了他呢。', dur=2.5  },
	   	},

	   	--新军在山下大喊
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ix6_1" ,dialog_time = 2},

	   		{ event='move', delay= 0.2, handle_id=1, end_dir=1, pos={464,1582}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=1, pos={526,1620}, speed=280, dur=1.5 },

	    	{ event='talk', delay=0.1, handle_id=5, talk='！！！', dur=1.5 },
	   		{ event='talk', delay=0.1, handle_id=6, talk='！！!', dur=1.5  },
	    },


	    --绿林军群起响应
	    {	
	  		{ event='move', delay= 0.2, handle_id=1, end_dir=5, pos={464,1582}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=5, pos={526,1620}, speed=280, dur=1.5 },

	   		{ event='talk', delay=0.1, handle_id=5, talk='天下不公啊！你们还敢来欺负我们。', dur=2.5},
	   		{ event='talk', delay=2.9, handle_id=6, talk='我们不会这么忍下去的！！', dur=2  },
	   		{ event='talk', delay=5.2, handle_id=7, talk='王首领啊，我们愿意跟随你们！', dur=2.5  },

	   		{ event='talk', delay=8, handle_id=1, talk='好！兄弟们，随我出山应敌！', dur=2.5 ,},
	   		{ event='move', delay= 8.2, handle_id=2, end_dir=7, pos={526,1620}, speed=280, dur=1.5 },

	    	{ event='talk', delay=10.8, handle_id=2, talk='大哥，我们能战胜他们吗？', dur=2.5 ,},
	    	{ event='talk', delay=13.6, handle_id=1, talk='不管了，反正是活不下去了，和他们拼了！', dur=2.5 ,},
	    	{ event = 'playAction',delay =13.8,  handle_id= 1, action_id = 2, dur = 0.2, dir = 1,loop = false, },
	   	},


	    --宛城城守和南阳郡守收到消息
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 2930,my = 520 },
	    	{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={2618,820}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='move', delay= 0.2, handle_id=8, end_dir=1, pos={2834,658}, speed=280, dur=1.5 },
	    	{ event='talk', delay=0.8, handle_id=8, talk='报！城外有群流民打算聚众造反', dur=2  },

	    	{ event='talk', delay=3.1, handle_id=3, talk='不自量力的东西，看我们不灭了你们！[a]', dur=2.5  ,emote = { a= 34}},
	    	{ event = 'effect', handle_id=1001, target_id = 3,delay = 3.1, pos = {0, 120}, effect_id = 20012, dx = 0,dy = 30,is_forever = true},
	    	{ event = 'removeEffect', delay = 5.9, handle_id=1001, effect_id=20012},

	    	{ event='move', delay= 5.9, handle_id=4, end_dir=7, pos={2958,590}, speed=280, dur=1.5 },
	    	{ event='talk', delay=5.9, handle_id=4, talk='大人，无需多虑，此事交给属下来处理吧！', dur=2.5  },

	    	
	    	{ event='talk', delay=8.7, handle_id=3, talk='好，传令下去，讨伐反军！', dur=2.5 ,},
	    	{ event = 'playAction',delay =8.7,  handle_id= 3, action_id = 2, dur = 0.2, dir = 5,loop = false, },

	    	{ event='talk', delay=11.5, handle_id=202, talk='真是一群不自量力的家伙。', dur=2.5 ,},
	    	{ event='talk', delay=14.3, handle_id=203, talk='待会就知道我们的厉害了。', dur=2.5 ,},
	    },
    },

    ['juqing-ix012'] = 
	{
		--演员表 1 王匡 2 王凤 3 宛城郡守 4 南阳郡守 5-6 绿林军 7-8 新军 101-104 摆设绿林军 201-204 摆设新军

	 	--创建角色，数个新军和绿林军躺在地上
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1136-100,my = 1634+100},
	   		{ event = 'camera', delay = 1, dur=2.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1878,1332 } }, -- 移动镜头通过
	    	{ event='createActor', delay=0.1, handle_id = 1, body=55, pos={1136,1634}, dir=1, speed=340, name_color=0xffffff, name="王匡"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=9, pos={1192,1672}, dir=1, speed=340, name_color=0xffffff, name="王凤"},
	    	
	    	{ event='createActor', delay=0.1, handle_id = 3, body=18, pos={2898,562}, dir=5, speed=340, name_color=0xffffff, name="南阳郡守"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=48, pos={2958,590}, dir=5, speed=340, name_color=0xffffff, name="宛城城守"},

	    	{ event='createActor', delay=0.1, handle_id = 5, body=15, pos={1106-60,1688+20}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=16, pos={1164-60,1716+20}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},

	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={1878+30,1332+30}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={1936+30,1364+30}, dir=5, speed=340, name_color=0xffffff, name="新军"},

	   		--摆设型绿林军
	   		{ event='createActor', delay=0.1, handle_id = 101, body=15, pos={1010,1456}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=15, pos={1416,1554}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=15, pos={1386,1774}, dir=1, speed=340, name_color=0xffffff, name="绿林军"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=15, pos={1272,1494}, dir=7, speed=340, name_color=0xffffff, name="绿林军"},

	   		--摆设型新军
	   		{ event='createActor', delay=0.1, handle_id = 201, body=27, pos={1010,1456}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=27, pos={1416,1554}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=27, pos={1386,1774}, dir=5, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=27, pos={1100,1802}, dir=5, speed=340, name_color=0xffffff, name="新军"},

	   		{ event='playAction', delay = 0.2, handle_id=101, action_id=4, dur=1.5, dir=7, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=102, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=103, action_id=4, dur=1.5, dir=5, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=104, action_id=4, dur=1.5, dir=5, loop=false ,once = true},

	   		{ event='playAction', delay = 0.2, handle_id=201, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=202, action_id=4, dur=1.5, dir=7, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=203, action_id=4, dur=1.5, dir=1, loop=false ,once = true},
	   		{ event='playAction', delay = 0.2, handle_id=204, action_id=4, dur=1.5, dir=6, loop=false ,once = true},
	    },

	    --两个兵痞跑走
	    {
	    	{ event='talk', delay=0.1, handle_id=7, talk='我们力战不支！跑吧！[a]', dur=2.5, emote = { a =41}},
	    	{ event='talk', delay=2.8, handle_id=8, talk='不能全死在南阳这里，快撤！[a]', dur=2.5,emote = { a =22}},

	    	{ event='move', delay= 5.5, handle_id=7, end_dir=1, pos={2898,562}, speed=300, dur=1.5 },
	    	{ event='move', delay= 5.5, handle_id=8, end_dir=1, pos={2958,590}, speed=300, dur=1.5 },

	    	{ event='kill', delay=7.5, handle_id=7},
	    	{ event='kill', delay=7.5, handle_id=8},
	    },

	    --切换到郡守处
		{
			-- { event = 'camera', delay = 1, dur=1.5,sdur = 0.1,style = '',backtime=1, c_topox = { 2920,530 } }, -- 移动镜头通过
			{ event='init_cimera', delay = 0.2,mx= 2920,my = 530},
		},
		{
			{ event='talk', delay=0.1, handle_id = 3, talk='速速前往长安报信，南阳兵灾为患，请派兵镇压！[a]', dur=3, emote = { a =41}},
	    	{ event='talk', delay=3.4, handle_id = 4, talk='我们一定要镇压他们，不然朝廷怪罪下来，我们都担待不起！', dur=3},

			{ event='move', delay= 6.5, handle_id= 3, dir=1, pos= {2222,110},speed=200, dur=0.3, end_dir=1 }, 
	    	{ event='move', delay= 6.5, handle_id= 4, dir=1, pos= {2300,150},speed=200, dur=0.3, end_dir=1 }, 

	    	{ event='kill', delay=8.5, handle_id=3},
	    	{ event='kill', delay=8.5, handle_id=4},
		},

		--兵头逃跑
		{
			-- { event = 'camera', delay = 0.2, dur=3.5,sdur = 0.9,style = '',backtime=1, c_topox = { 2756,3724 } }, -- 移动镜头通过
			{ event='init_cimera', delay = 0.2,mx= 1136,my = 1634},
			{ event='move', delay= 0.2, handle_id= 1, dir=1, pos= {1136,1634},speed=200, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.2, handle_id= 2, dir=1, pos= {1192,1672},speed=200, dur=0.3, end_dir=7 }, 

			{ event='talk', delay=0.4, handle_id=1, talk='此战之后，想必天相应我们号召的义军不在少数！', dur=3},
			{ event='talk', delay=3.7, handle_id=2, talk='大哥所言极是，我们将率先举起反莽的大旗！', dur=3},
			{ event='talk', delay=7, handle_id=5, talk='反抗新莽，重整天下！', dur=3.5},
			{ event='talk', delay=7, handle_id=6, talk='反抗新莽，重整天下！', dur=3.5},
		},
	},

	--============================================wuwenbin  每日剧情6 end  =====================================----

	 --============================================lixin  每日剧情7 start  =====================================----
    --演员表 1-刘縯    2~3门客    4山贼头目    5~6 山贼    7-新军头目     8~9 新军兵痞  10~13 门客
    ['juqing-ix013'] = 
    {
    	--民那 出来吧~
    	{
	   		{ event='createActor', delay=0.1, handle_id = 7, body=47, pos={1167+20,1009}, dir=1, speed=340, name_color=0xffffff, name="新军头目"},
	    	{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={1199+20+20,912}, dir=5, speed=340, name_color=0xffffff, name="新军兵痞"},
	    	{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={1296+20,978}, dir=5, speed=340, name_color=0xffffff, name="新军兵痞"}
	    },

	    {
	    	{ event='init_cimera', delay = 0.1,mx= 1243+20,my = 934-50},
	    },

	    --兵痞BB
	    {
	    	-- { event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1243+20,934 } }, -- 移动镜头通过
	    	
	    	{ event = 'talk', delay=1, handle_id=8, talk='敢跟我们叫板，先抓起来再说！', dur=2},
	    	{ event = 'talk', delay=3.5, handle_id=9, talk='就是，只要能出了这口恶气，管他们是谁呢。', dur=2.5},
	    	{ event = 'talk', delay=6.5, handle_id=7, talk='几个不成事的世家子弟罢了。', dur=2},
	    	{ event = 'talk', delay=9, handle_id=7, talk='走，这就清缴了他们，看他们再嚣张！', dur=2.5},

	    	{ event='move', delay= 11.5, handle_id= 7, dir=5, pos= {723,1265},speed=340, dur=1, end_dir=5 }, 
	    	{ event='move', delay= 11.5, handle_id= 8, dir=5, pos= {752,1172},speed=340, dur=1, end_dir=5 },
	    	{ event='move', delay= 11.5, handle_id= 9, dir=5, pos= {849,1266},speed=340, dur=1, end_dir=5 },

	    	{ event='createActor', delay=0.1, handle_id = 1, body=14, pos={563,1823}, dir=2, speed=340, name_color=0xffffff, name="刘縯"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=7, pos={1328,1489}, dir=5, speed=340, name_color=0xffffff, name="门客"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=7, pos={1432,1553}, dir=5, speed=340, name_color=0xffffff, name="门客"},

	    	{ event='createActor', delay=0.1, handle_id = 10, body=19, pos={684,1900}, dir=6, speed=340, name_color=0xffffff, name="门客"},
	    	{ event='createActor', delay=0.1, handle_id = 11, body=19, pos={691,1784}, dir=6, speed=340, name_color=0xffffff, name="门客"},
	    },

	    --转场
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 883,my = 1802},
	    },

	    --刘演BB
	    {
	    	{ event='showTopTalk', delay=1.5, dialog_id="ix7_1" ,dialog_time = 2},

	    	{ event='talk', delay=0.5, handle_id=1, talk='……', dur=1.5},
	    	{ event='talk', delay=0.5, handle_id=11, talk='……', dur=1.5},
	    	{ event='talk', delay=0.5, handle_id=10, talk='……', dur=1.5},

	    	{ event='move', delay= 2, handle_id= 10, dir=2, pos= {684,1900},speed=300, dur=2, end_dir=2 }, 
	    	{ event='move', delay= 2, handle_id= 11, dir=2, pos= {691,1784},speed=300, dur=2, end_dir=2 },

	    	{ event='talk', delay=2.2, handle_id=1, talk='？', dur=1.5},
	    	{ event='talk', delay=2.2, handle_id=11, talk='？', dur=1.5},
	    	{ event='talk', delay=2.2, handle_id=10, talk='？', dur=1.5},

	    	--杀了兵痞
	    	{ event='kill', delay=0.1, handle_id=7},
	    	{ event='kill', delay=0.1, handle_id=8},
	    	{ event='kill', delay=0.1, handle_id=9},
	    },
	    --门客跑过来告状
	    {
	    	{ event='move', delay= 0.1, handle_id= 2, dir=1, pos= {976,1780},speed=300, dur=2, end_dir=6 }, 
	    	{ event='move', delay= 0.1, handle_id= 3, dir=1, pos= {978,1873},speed=300, dur=2, end_dir=6 },

	    	{ event='move', delay= 0.1, handle_id= 1, dir=1, pos= {740,1815},speed=300, dur=7, end_dir=2 },
	    	{ event='talk', delay=0.1, handle_id=1, talk='外面乱哄哄的，出了什么事情了？', dur=2},

	    	{ event='talk', delay=3, handle_id=2, talk='伯升大哥，大事不好了！', dur=1.5},
	    	{ event='talk', delay=5, handle_id=3, talk='新军在蔡阳城外开始搜捕我们了！', dur=2},

	    },

	    {
	    	-- { event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 883,1802 } }, -- 移动镜头通过
	    	{ event='talk', delay=0.5, handle_id=1, talk='不要慌张，待我去仔细询问下事情的缘由。如果新军敢针对我们…… ', dur=3},
	    	{ event='talk', delay=4, handle_id=1, talk='哼，我定当不饶他们！', dur=2},

	    	{ event='move', delay= 6.5, handle_id= 1, dir=1, pos= {1482,1485},speed=280, dur=2, end_dir=7 },
	    	{ event='move', delay= 7, handle_id= 2, dir=1, pos= {976,1780},speed=300, dur=1, end_dir=1 }, 
	    	{ event='move', delay= 7, handle_id= 3, dir=1, pos= {978,1873},speed=300, dur=1, end_dir=1 },

	    	-- { event='move', delay= 8.8, handle_id= 2, dir=1, pos= {976+40,1780-30},speed=300, dur=0.5, end_dir=1 }, 
	    	-- { event='move', delay= 8.8, handle_id= 3, dir=1, pos= {978+40,1873-30},speed=300, dur=0.5, end_dir=1 },

	    	-- { event = 'camera', delay = 8, dur=0.5,sdur = 0.5,target_id = 2 ,style = 'follow',backtime=1},
	    	{ event = 'camera', delay = 9.3, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1109,1742 } },
	    	{ event='talk', delay=8, handle_id=2, talk='伯升大哥，等等我们', dur=2},
	    	{ event='talk', delay=9, handle_id=3, talk='那些新军不讲道理的。', dur=2},

	    	{ event='move', delay= 9.3, handle_id= 2, dir=1, pos= {1482,1485},speed=280, dur=0.5, end_dir=1 }, 
	    	{ event='move', delay= 9.3, handle_id= 3, dir=1, pos= {1482,1485},speed=280, dur=0.5, end_dir=1 },

	    	{ event='kill', delay=10, handle_id=1},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=54, pos={589-70,818}, dir=5, speed=340, name_color=0xffffff, name="山贼头目"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=31, pos={492-70,882}, dir=1, speed=340, name_color=0xffffff, name="山贼"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=31, pos={780-100,1105-30}, dir=7, speed=340, name_color=0xffffff, name="山贼"},
	    },	
	    --转场    
	    {
	    	-- { event = 'changeRGBA',delay=0.1,dur=1,txt = " ",cont_time=0.5,light_time=0.1, txt_time=0.1, black_time=0.2},
	    	-- { event = 'camera', delay = 0.1, dur=0,sdur = 0.1,style = '',backtime=1, c_topox = { 480,800 } },
	    	{ event='init_cimera', delay = 0.1,mx= 480,my = 800},
	    },
	    --山贼BB
	    {

	    	{ event='move', delay= 0.1, handle_id= 6, dir=1, pos= {720-70,913},speed=300, dur=0.3, end_dir=7 },
	    	{ event='talk', delay=0.5, handle_id=6, talk='好消息，好消息！', dur=1.5},
	    	{ event='move', delay= 0.5, handle_id= 5, dir=1, pos= {492-70,882},speed=300, dur=0.3, end_dir=3 },
	    	{ event='move', delay= 0.5, handle_id= 4, dir=1, pos= {589-70,818},speed=300, dur=0.3, end_dir=3 },
	    	{ event='talk', delay=2.5, handle_id=4, talk='有话快说！', dur=1.5},
	    	{ event='talk', delay=4.5, handle_id=6, talk='听说刘家门客要和新军打起来了！', dur=2},
	    	{ event='talk', delay=7, handle_id=4, talk='又起冲突了？不知道能不能趁机捞点好处。', dur=2.5},
	    	{ event='talk', delay=10, handle_id=5, talk='要不，我们也去凑凑这个热闹？', dur=2},
	    	{ event='talk', delay=12.5, handle_id=4, talk='走，过去瞧瞧！', dur=2},
	    },

 	},
 	--演员表 1-刘縯    2~3门客    4山贼头目    5~6 山贼    7-新军头目     8~9 新军兵痞
    ['juqing-ix014'] = 
    {
    	--民那 出来吧~
    	{
	   		{ event='init_cimera', delay = 0.2,mx= 1583,my = 1391},
	    	{ event='createActor', delay=0.1, handle_id = 1, body=14, pos={1267,1200}, dir=7, speed=340, name_color=0xffffff, name="刘縯"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=7, pos={1264,1266}, dir=7, speed=340, name_color=0xffffff, name="门客"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=7, pos={1330,1234}, dir=7, speed=340, name_color=0xffffff, name="门客"},

	    	{ event='createActor', delay=0.1, handle_id = 7, body=47, pos={1191,1083}, dir=1, speed=340, name_color=0xffffff, name="新军头目"},
	    	{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={1157,1044}, dir=6, speed=340, name_color=0xffffff, name="新军兵痞"},
	    	{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={1222,1011}, dir=2, speed =340, name_color=0xffffff, name="新军兵痞"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=54, pos={1073,1170}, dir=5, speed=340, name_color=0xffffff, name="山贼头目"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=31, pos={945,1140}, dir=3, speed=340, name_color=0xffffff, name="山贼"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=31, pos={1028,1046}, dir=7, speed=340, name_color=0xffffff, name="山贼"},
	    },

	    --镜头移动
	    {
	    	{ event = 'camera', delay = 0.5, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = {1127,997}}, -- 移动镜头通过
	    	{ event='playAction', delay = 0.1, handle_id=4, action_id=4, dur=1.5, dir=1, loop=false,once=true},
	    	{ event='playAction', delay = 0.1, handle_id=5, action_id=4, dur=1.5, dir=3, loop=false,once=true},
	    	{ event='playAction', delay = 0.1, handle_id=6, action_id=4, dur=1.5, dir=5, loop=false,once=true},
	    	{ event='playAction', delay = 0.1, handle_id=7, action_id=4, dur=1.5, dir=2, loop=false,once=true},
	    	{ event='playAction', delay = 0.1, handle_id=8, action_id=4, dur=1.5, dir=6, loop=false,once=true},
	    	{ event='playAction', delay = 0.1, handle_id=9, action_id=4, dur=1.5, dir=7, loop=false,once=true},

	    	{ event='talk', delay=0.5, handle_id=4, talk='[a]', dur=7,emote={a=5}},
	   		{ event='talk', delay=0.5, handle_id=5, talk='[a]', dur=7,emote={a=5}},
	   		{ event='talk', delay=0.5, handle_id=6, talk='[a]', dur=7,emote={a=5}},
	   		{ event='talk', delay=0.5, handle_id=7, talk='[a]', dur=7,emote={a=5}},
	   		{ event='talk', delay=0.5, handle_id=8, talk='[a]', dur=7,emote={a=5}},
	   		{ event='talk', delay=0.5, handle_id=9, talk='[a]', dur=7,emote={a=5}},

	   		{ event='talk', delay=2, handle_id=1, talk='哼，这么点本事也敢来蔡阳捣乱？', dur=2},
	   		{ event='talk', delay=4.5, handle_id=2, talk='伯升之勇，岂是你们区区鼠辈能相抗的？', dur=2},
	   		{ event='talk', delay=7, handle_id=3, talk='知道厉害了就快点滚！', dur=1.5},
	    },

	    --逃跑
	    {
	    	{ event='playAction', delay = 0.1, handle_id=4, action_id=0, dur=1.5, dir=3, loop=true},
	    	{ event='playAction', delay = 0.1, handle_id=5, action_id=0, dur=1.5, dir=3, loop=true},
	    	{ event='playAction', delay = 0.1, handle_id=6, action_id=0, dur=1.5, dir=3, loop=true},
	    	{ event='playAction', delay = 0.1, handle_id=7, action_id=0, dur=1.5, dir=3, loop=true},
	    	{ event='playAction', delay = 0.1, handle_id=8, action_id=0, dur=1.5, dir=3, loop=true},
	    	{ event='playAction', delay = 0.1, handle_id=9, action_id=0, dur=1.5, dir=3, loop=true},

	    	{ event='talk', delay=1, handle_id=5, talk='撤吧，刘家的大哥太厉害了！', dur=2},
	    	{ event='talk', delay=3.5, handle_id=6, talk='我们根本不是对手啊！', dur=1.5},

	    	{ event='move', delay= 5, handle_id=6, end_dir=7, pos={575-50,801}, speed=300, dur=1.5 },
	    	{ event='move', delay= 5, handle_id=5, end_dir=7, pos={480,861}, speed=300, dur=1.5 },

	    	{ event='move', delay= 7.5 , handle_id=4, end_dir=7, pos={1073,1170}, speed=300, dur=1.5 },
	    	{ event='talk', delay=5.5, handle_id=4, talk='一群没用的东西，打不过就跑！', dur=2},

	    	{ event='talk', delay= 8, handle_id=4, talk='0.0！…… 等等我啊', dur=1.5},
	    	{ event='move', delay= 8, handle_id=4, end_dir=7, pos={576-50,895}, speed=280, dur=1.5 },

	    	{ event='move', delay= 8, handle_id=7, end_dir=7, pos={1191,1083}, speed=300, dur=1.5 },
	    	{ event='move', delay= 8, handle_id=8, end_dir=7, pos={1157,1044}, speed=300, dur=1.5 },
	    	{ event='move', delay= 8, handle_id=9, end_dir=7, pos={1222,1011}, speed=300, dur=1.5 },

	    	{ event='talk', delay= 8.5, handle_id=7, talk='0.0！', dur=1.5},
	    	{ event='talk', delay= 8.5, handle_id=8, talk='0.0！', dur=1.5},
	    	{ event='talk', delay= 8.5, handle_id=9, talk='0.0！', dur=1.5},

	    	{ event='move', delay= 9.5, handle_id=7, end_dir=7, pos={626,945}, speed=280, dur=1.5 },
	    	{ event='move', delay= 9.5, handle_id=8, end_dir=3, pos={625,851}, speed=280, dur=1.5 },
	    	{ event='move', delay= 9.5, handle_id=9, end_dir=3, pos={530,911}, speed=280, dur=1.5 },

	    	{ event='kill', delay=10.5, handle_id=4},
	    	{ event='kill', delay=10, handle_id=5},
	    	{ event='kill', delay=10, handle_id=6},
	    },

	    --转镜头 BB
	    {
	    	-- { event = 'camera', delay = 0.2, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2136,1430 } }, -- 移动镜头通过
	    	-- { event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,target_id = 8 ,style = 'follow',backtime=1},
	    	{ event='init_cimera', delay = 0.1,mx= 562,my = 847},
	    	{ event='talk', delay=1, handle_id=8, talk='刘家的老大果然不是名不虚传啊，要不先去通报吧！', dur=2.5},
	    	{ event='talk', delay=4, handle_id=7, talk='快去通报郡守，刘家勾结山贼造反了！', dur=2.5},
	    },
    }, 	
      --============================================lixin  每日剧情7 end  =====================================----





--============================================	luyao	每日剧情8	start  =========================================

	['juqing-ix015'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx=965 ,my = 2287},
	   		{ event='createActor', delay=0.1, handle_id = 1, body=14, pos={1020,2370}, dir=5, speed=340, name_color=0xffffff, name="刘縯"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=23, pos={1020+100,2370}, dir=5, speed=340, name_color=0xffffff, name="刘氏族长"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={1050+200,2400-50}, dir=5, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=7, pos={1050+50,2400-100}, dir=5, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=7, pos={1050+150,2400-100}, dir=5, speed=340, name_color=0xffffff, name="刘氏宗亲"},


	   		{ event='createActor', delay=0.1, handle_id = 6, body=43, pos={860,2440}, dir=1, speed=340, name_color=0xffffff, name="新军将领"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={860-100,2440}, dir=1, speed=340, name_color=0xffffff, name="新军"},	
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={860,2440+100}, dir=1, speed=340, name_color=0xffffff, name="新军"},

	   		{ event='createActor', delay=0.1, handle_id = 9 , body=27, pos={820,2350}, dir=1, speed=340, name_color=0xffffff, name="新军"},	
	   		{ event='createActor', delay=0.1, handle_id = 10, body=27, pos={950,2500}, dir=1, speed=340, name_color=0xffffff, name="新军"},	


		},

		{


	   		{ event='talk', delay=1.1, handle_id=6, talk='我等奉命前来监视刘氏一族。', dur=2  },
	   		{ event='talk', delay=3.5, handle_id=6, talk='以防汉室后裔对新皇有所不满，犯上作乱。', dur=2.2 },
	   		{ event='talk', delay=6, handle_id=7, talk='大人，这些就是舂陵刘氏一族。', dur=2  },
	   		{ event='talk', delay=8.5, handle_id=8, talk='舂陵刘氏？听说有个叫刘縯对新朝颇有不满！', dur=2.2  },
	   		{ event='talk', delay=11.5, handle_id=1, talk='你们不要欺人太甚！', dur=1.8  },
	   		{ event='talk', delay=13.5, handle_id=1, talk='我舂陵刘氏乃高祖后裔，不是任人欺辱的！', dur=1.8  },
		},
		{
	    	{ event='move', delay= 0.1, handle_id= 2, dir=5, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=5 }, 

	   		{ event='talk', delay=0.2, handle_id=2, talk='伯升，不要莽撞！', dur=2  },
	   		{ event='talk', delay=2.5, handle_id=2, talk='前车之鉴你都忘记了嘛？', dur=2 },
	   		{ event='talk', delay=5, handle_id=2, talk='不要将大家陷入新莽的诡计。', dur=2  },

	    	{ event='move', delay= 7.6, handle_id= 1, dir=1, pos= {1020,2370},speed=200, dur=0.3, end_dir=1 }, 
	    	{ event='move', delay= 7.6, handle_id= 2, dir=1, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=1 }, 

	   		{ event='talk', delay=7.5, handle_id=3, talk='我们还是皇室的后裔吗？', dur=2.2  },
	   		{ event='talk', delay=10.5, handle_id=4, talk='这和犯人有什么区别？', dur=1.8  },
	   		{ event='talk', delay=12.5, handle_id=5, talk='我们不服，我们要上书朝廷！', dur=1.8  },
		},
		{
	    	{ event='move', delay= 0.5, handle_id= 1, dir=1, pos= {1020,2370},speed=200, dur=0.3, end_dir=5 }, 
	    	{ event='move', delay= 0.5, handle_id= 2, dir=1, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=5 }, 

	   		{ event='talk', delay=0.1, handle_id=6, talk='既然知道就好，来人！将这些犯人看押起来！', dur=2  },
	   		{ event='talk', delay=2.5, handle_id=9, talk='是！', dur=1.5 },
	   		{ event='talk', delay=2.5, handle_id=10, talk='是！', dur=1.5 },	

	    	{ event='move', delay= 3.6, handle_id= 10, dir=1, pos= {1050+150,2400+50},speed=200, dur=2, end_dir=7 }, 
	    	{ event='move', delay= 3.6, handle_id= 9, dir=1, pos= {1050-80,2400-80},speed=200, dur=2, end_dir=3 }, 

	    	{ event='move', delay= 4, handle_id= 1, dir=1, pos= {1020,2370},speed=200, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 4.2, handle_id= 2, dir=1, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=3 }, 	    	
		},
		{		
	   		{ event='talk', delay=0.1, handle_id=9, talk='看什么看？快走！', dur=2  },
	   		{ event='talk', delay=2.5, handle_id=10, talk='知道你们是什么嘛，还不老实点！', dur=1.5 },
		},
		{
	    	{ event='move', delay= 0.1, handle_id= 2, dir=1, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.6, handle_id= 2, dir=1, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 1.8, handle_id= 2, dir=1, pos= {1020+80,2370+20},speed=200, dur=0.3, end_dir=1 }, 
	   		{ event='talk', delay=2.1, handle_id=2, talk='大家不要冲动，他们就是想激怒我们！', dur=2  },
	   		{ event='talk', delay=4.5, handle_id=2, talk='然后找个借口对付我们。', dur=1.8 },
	   		{ event='talk', delay=7.1, handle_id=3, talk='太过分了！侯爷，我们难道只能这么忍下去嘛？', dur=2  },
	   		{ event='talk', delay=9.5, handle_id=4, talk='伯升，你倒是说句话啊！', dur=1.8 },	   		

		},	
		{
	    	{ event='move', delay= 0.1, handle_id= 1, dir=1, pos= {1020,2370},speed=200, dur=0.3, end_dir=1 }, 
	    	{ event='move', delay= 1, handle_id= 1, dir=1, pos= {1020,2370},speed=200, dur=0.3, end_dir=5 },  		
			{ event='jump', delay=1.7, handle_id=1, dir=5, pos={1020-50,2370+50}, speed=20, dur=0.5, end_dir=5 },

			{ event='playAction', delay = 2.4, handle_id=1, action_id=2, dur=0.5, dir=5, loop=false ,},	
			{ event='playAction', delay = 2.5, handle_id=6, action_id=3, dur=0.5, dir=1, loop=false ,},	

	   		{ event='talk', delay=2.7, handle_id=1, talk='放肆！', dur=1.5  },
	   		{ event='talk', delay=4.7, handle_id=1, talk='真当我们舂陵无人了！', dur=3  },

		},


	},


	['juqing-ix016'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx=830 ,my = 1740},		
	   		{ event='createActor', delay=0.1, handle_id = 6, body=43, pos={680,1750}, dir=3, speed=340, name_color=0xffffff, name="新军将领"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=27, pos={820,1750}, dir=3, speed=340, name_color=0xffffff, name="新军"},	
	   		{ event='createActor', delay=0.1, handle_id = 8, body=27, pos={630,1830}, dir=3, speed=340, name_color=0xffffff, name="新军"},

	   		{ event='createActor', delay=0.1, handle_id = 9, body=27, pos={1010,2000}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 10, body=27, pos={1010-50,2000+50}, dir=7, speed=340, name_color=0xffffff, name="新军"},	   		
	    	{ event='move', delay= 0.2, handle_id= 9, dir=7, pos= {890,1817},speed=300, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.2, handle_id= 10, dir=7, pos= {790,1870},speed=300, dur=0.3, end_dir=7 }, 	
	   		{ event='talk', delay=0.8, handle_id=9, talk='不好啦！大人，舂陵刘氏造反作乱了！', dur=2 },	    	    	
		},
		{
	   		{ event='talk', delay=0.5, handle_id=10, talk='刘伯升杀了我们好多人！', dur=2  },
	   		{ event='talk', delay=3, handle_id=6, talk='慌什么！先盯住他们。', dur=2 },
	   		{ event='talk', delay=5.5, handle_id=6, talk='我这就向朝廷上书，请兵支援。', dur=2  },	   			   	
		},
		{
	   		{ event='init_cimera', delay = 1,mx=1265 ,my = 2387},		
			{event='changeRGBA', delay=0.1, txt="",cont_time=0.8, light_time=0.8, txt_time=0.1, black_time=0.1},
	   		{ event='createActor', delay=0.1, handle_id = 1, body=14, pos={1190,2390}, dir=7, speed=340, name_color=0xffffff, name="刘縯"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=23, pos={1190+120,2390}, dir=7, speed=340, name_color=0xffffff, name="刘氏族长"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={1190+150,2390+80}, dir=7, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=7, pos={1190+280,2390}, dir=6, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=7, pos={1190+260,2390+60}, dir=6, speed=340, name_color=0xffffff, name="刘氏宗亲"},

	   		{ event='createActor', delay=0.1, handle_id = 11, body=27, pos={970,2410}, dir=3, speed=340, name_color=0xffffff, name="新军"},	
	   		{ event='createActor', delay=0.1, handle_id = 12, body=27, pos={937,2210}, dir=2, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 13, body=27, pos={1100,2200}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	   		{ event='createActor', delay=0.1, handle_id = 14, body=27, pos={1310,2250}, dir=1, speed=340, name_color=0xffffff, name="新军"},	

			{ event='playAction', delay = 0.2, handle_id=11, action_id=4, dur=0.5, dir=3, loop=false , once=true},	
			{ event='playAction', delay = 0.2, handle_id=12, action_id=4, dur=0.5, dir=2, loop=false , once=true},	
			{ event='playAction', delay = 0.2, handle_id=13, action_id=4, dur=0.5, dir=7, loop=false , once=true},	
			{ event='playAction', delay = 0.2, handle_id=14, action_id=4, dur=0.5, dir=1, loop=false , once=true},		   		  		
		},
		{
	   		{ event='talk', delay=0.1, handle_id=1, talk='苍天不公，堂堂汉室居然落寞到如此地步！', dur=2.2  },
	   		{ event='talk', delay=3, handle_id=1, talk='难道就没人带领我们反抗嘛？', dur=1.8 },
	    	{ event='move', delay= 5.8, handle_id= 1, dir=2, pos= {1190,2390},speed=300, dur=0.3, end_dir=2 },
	    	{ event='move', delay= 5.2, handle_id= 2, dir=6, pos= {1190+120,2390},speed=300, dur=0.3, end_dir=6 },	    	 
	   		{ event='talk', delay=5.5, handle_id=2, talk='伯升，你中了他们的圈套啦！', dur=2  },
	   		{ event='talk', delay=8, handle_id=2, talk='唉，我们刘氏一族看来灾祸难免了！', dur=2.2  },
	   	},
	   	{	
			{ event='playAction', delay = 0.1, handle_id=3, action_id=2, dur=0.5, dir=7, loop=false ,},	
	   		{ event='talk', delay=1, handle_id=3, talk='我们受够了！', dur=1.8 },
	    	{ event='move', delay= 1.5, handle_id= 2, dir=2, pos= {1190+120,2390},speed=300, dur=0.3, end_dir=2 }, 

	   		{ event='talk', delay=3.5, handle_id=4, talk='对，伯升做的对！', dur=1.8  },
	   		{ event='talk', delay=5.5, handle_id=5, talk='侯爷，这可如何是好啊？', dur=3  },

		},		

	},
--============================================	luyao	每日剧情8	end    =========================================


    --============================================wuwenbin  每日剧情9 start  =====================================----
   	['juqing-ix017'] = 
	{
		--演员表 1 马武 2 王莽 3 刺客首领 4 禁卫首领 101-106 新军禁卫 201-203 刺客
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2452,my = 1192 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=47, pos={3354,424}, dir=1, speed=340, name_color=0xffffff, name="马武"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=53, pos={2488,1170}, dir=5, speed=340, name_color=0xffffff, name="王莽"},
	    	
	    	{ event='createActor', delay=0.1, handle_id = 3, body=48, pos={3440,372}, dir=5, speed=340, name_color=0xffffff, name="刺客首领"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=43, pos={2388,1238}, dir=1, speed=340, name_color=0xffffff, name="禁卫首领"},

	   		--禁卫

	   		{ event='createActor', delay=0.1, handle_id = 101, body=57, pos={2068,1490}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=57, pos={1996,1518}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=57, pos={1928,1558}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=57, pos={2162,1554}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=57, pos={2098,1584}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=57, pos={2032,1620}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},

	   		--刺客
	   		{ event='createActor', delay=0.1, handle_id = 201, body=22, pos={3518,244}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=22, pos={3538,342}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	    },

	    --王莽下旨出行祭天
	    {	
	   		{ event='talk', delay=0.1, handle_id=2, talk='传旨，安排祭天事宜！', dur=2.5 },
	   		{ event='talk', delay=2.8, handle_id=4, talk='是，遵命！', dur=2  },
	   	},

	   	--禁卫首领移动至新军禁卫处
	   	{
	   		{ event = 'camera', delay = 0.2, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2136,1430 } }, -- 移动镜头通过
	   		{ event='move', delay= 0.2, handle_id=4, end_dir=5, pos={2160,1450}, speed=280, dur=1.5 },

	    	{ event='talk', delay=1.2, handle_id=4, talk='皇帝陛下今日将要外出祭天游园。', dur=2.5 },
	   		{ event='talk', delay=4, handle_id=4, talk='我等要打起精神，不能出一点差错！', dur=2.5  },

	   		{ event='talk', delay=6.8, handle_id=101, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=6.8, handle_id=102, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=6.8, handle_id=103, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=6.8, handle_id=104, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=6.8, handle_id=105, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=6.8, handle_id=106, talk='喏！', dur=1.5  },

	   		{ event='kill', delay=8.5, handle_id=2},
	   		{ event='kill', delay=8.5, handle_id=4},

	   		{ event='kill', delay=8.5, handle_id=101},
	   		{ event='kill', delay=8.5, handle_id=102},
	   		{ event='kill', delay=8.5, handle_id=103},
	   		{ event='kill', delay=8.5, handle_id=104},
	   		{ event='kill', delay=8.5, handle_id=105},
	   		{ event='kill', delay=8.5, handle_id=106},
	    },


	    --刺客在密林里商量
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	    	{ event='init_cimera', delay = 0.2,mx= 3520,my = 250 },

	    	{ event='move', delay= 0.1, handle_id=201, end_dir=5, pos={3470,302}, speed=340, dur=1.5 },
	    	{ event='talk', delay=0.5, handle_id=201, talk='首领，据线报称，王莽将于近日出行祭天。', dur=2.5},
	    	{ event='talk', delay=3.3, handle_id=3, talk='好！', dur=1.5},

	   		{ event='talk', delay=5.1, handle_id=3, talk='马武，此次乃是天赐良机。', dur=2.5},
	   		{ event='talk', delay=7.9, handle_id=3, talk='我们只许成功，不能失败！', dur=2.5  },

	   		{ event='talk', delay= 10.7, handle_id=1, talk='请首领放心，我马武定当不辜负大家的厚望！', dur=2.5 ,},
	   		{ event='move', delay= 13.2, handle_id=1, end_dir=7, pos={3158,904}, speed=280, dur=1.5 },

	   		{ event='kill', delay=14.8, handle_id=1},
	   	},

	   	--刺客首领下达灭口令
	    {	
	    	{ event='talk', delay=0.1, handle_id=3, talk='（细语）你们俩，去看住马武，不能让他泄露我们的消息。', dur=3},
	    	{ event='talk', delay=3.4, handle_id=3, talk='如果行事不利，口风不紧，就找时机，做掉他！', dur=3},

	   		{ event='talk', delay=6.7, handle_id=201, talk='是！', dur=1.5},
	   		{ event='talk', delay=6.7, handle_id=202, talk='是！', dur=1.5},
	   		{ event='move', delay= 8.2, handle_id=201, end_dir=7, pos={3096,942}, speed=280, dur=1.5 },
	   		{ event='move', delay= 8.2, handle_id=202, end_dir=7, pos={3140,974}, speed=280, dur=1.5 },

	   		{ event='kill', delay=10, handle_id=3},
	   		{ event='kill', delay=10, handle_id=201},
	   		{ event='kill', delay=10, handle_id=202},
	   	},


	    --马武刺杀王莽
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 2706,my = 2350 },
	    	-- { event='init_cimera', delay = 0.1,mx= 3272,my = 2222 },
	    },
	    {
	    	
	    	{ event='createActor', delay=0.1, handle_id = 2, body=53, pos={2768,2518}, dir=3, speed=340, name_color=0xffffff, name="王莽"},
			{ event='createActor', delay=0.1, handle_id = 101, body=57, pos={2740,2414}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},
			{ event='createActor', delay=0.1, handle_id = 103, body=57, pos={2676,2382}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},
			{ event='createActor', delay=0.1, handle_id = 105, body=57, pos={2612,2350}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},

			{ event='createActor', delay=0.1, handle_id = 102, body=57, pos={2638,2472}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},
			{ event='createActor', delay=0.1, handle_id = 104, body=57, pos={2574,2440}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},
			{ event='createActor', delay=0.1, handle_id = 106, body=57, pos={2510,2410}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},

			-- { event = 'camera', delay = 0.2, dur=0.5,sdur = 0.5,target_id = 1 ,style = 'follow',backtime=1, }, -- 移动镜头通过

			-- { event='move', delay=0.2, handle_id=2, dir=6, pos={2768,2518}, speed=340, dur=1, end_dir=3 }, -- 通过

			-- { event='move', delay=0.2, handle_id=101, dir=6, pos={2740,2414}, speed=340, dur=1, end_dir=3 }, -- 通过
			-- { event='move', delay=0.2, handle_id=103, dir=6, pos={2676,2382}, speed=340, dur=1, end_dir=3 }, -- 通过
			-- { event='move', delay=0.2, handle_id=105, dir=6, pos={2612,2350}, speed=340, dur=1, end_dir=3 }, -- 通过
			-- { event='move', delay=0.2, handle_id=102, dir=6, pos={2638,2472}, speed=340, dur=1, end_dir=3 }, -- 通过
			-- { event='move', delay=0.2, handle_id=104, dir=6, pos={2574,2440}, speed=340, dur=1, end_dir=3 }, -- 通过
			-- { event='move', delay=0.2, handle_id=106, dir=6, pos={2510,2410}, speed=340, dur=1, end_dir=3 }, -- 通过

			{ event='talk', delay=0.2, handle_id=2, talk='朕今日祭天，必求得上天庇佑，千秋万世！', dur=3},
		},

		{
			{ event='createActor', delay=0.1, handle_id = 1, body=47, pos={3272,2222}, dir=3, speed=340, name_color=0xffffff, name="马武"},
			-- { event = 'camera', delay = 0.1, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 2706,2350 } },
			{ event='move', delay=0.2, handle_id=1, dir=6, pos={3084,2348}, speed=140, dur=1, end_dir=5 }, -- 通过		

			{ event='talk', delay=0.5, handle_id=1, talk='狗皇帝，拿命来！', dur=2.5},

			{ event='jump', delay=0.5, handle_id=1, dir=6, pos={2940,2436}, speed=120, dur=1, end_dir=5 }, -- 通过
			{ event='playAction', delay = 1, handle_id=1, action_id=2, dur=1.5, dir=5, loop=false ,},

			{ event='talk', delay=1, handle_id=2, talk='护驾！护驾！', dur=2},
			{ event='move', delay= 1, handle_id=2, end_dir=3, pos={2610,2418}, speed=280, dur=1.5 },

			{ event='move', delay= 1.3, handle_id=103, end_dir=3, pos={2670,2412}, speed=280, dur=1.5 },
			{ event='move', delay= 1.3, handle_id=104, end_dir=3, pos={2644,2484}, speed=280, dur=1.5 },
			{ event='move', delay= 1.3, handle_id=105, end_dir=3, pos={2572,2354}, speed=280, dur=1.5 },
			{ event='move', delay= 1.3, handle_id=106, end_dir=3, pos={2542,2420}, speed=280, dur=1.5 },

			{ event='talk', delay=1, handle_id=103, talk='！！', dur=1 , },
			{ event='talk', delay=1, handle_id=104, talk='！！', dur=1 , },
			{ event='talk', delay=1, handle_id=105, talk='！！', dur=1 , },
			{ event='talk', delay=1, handle_id=106, talk='！！', dur=1 , },


			{ event='createActor', delay=0.5, handle_id = 4, body=43, pos={2706,2546}, dir=5, speed=340, name_color=0xffffff, name="禁卫首领"},
			{ event='move', delay=0.6, handle_id=4, dir=6, pos={2830,2478}, speed=120, dur=1, end_dir=1 }, -- 通过
			{ event='talk', delay=0.8, handle_id=4, talk='陛下当心！', dur=2},
			
	   		{ event='playAction', delay = 1.2, handle_id=4, action_id=2, dur=1.5, dir=1, loop=false ,},

			{ event='move', delay= 1.3, handle_id=101, end_dir=3, pos={2830,2420}, speed=200, dur=1.5 },
			{ event='move', delay= 1.3, handle_id=102, end_dir=1, pos={2864,2550}, speed=200, dur=1.5 },
	    },

	    --马武刺杀失败，被追击
	    {
			{ event='talk', delay=0.1, handle_id=1, talk='狗皇帝，算你运气好！', dur=1.5},
			{ event='move', delay= 1, handle_id=1, end_dir=1, pos={3090,2346}, speed=140, dur=1.5 },
			{ event='jump', delay=1.5, handle_id=1, dir=1, pos={3340,2220}, speed=140, dur=1, end_dir=1 },

			{ event='move', delay=1.5, handle_id=4, dir=6, pos={2830+60,2478-30}, speed=200, dur=1, end_dir=1 },
			{ event='talk', delay=1.2, handle_id=4, talk='别跑！', dur=2},
		},
		{
			{ event='move', delay=0.1, handle_id=4, dir=6, pos={2830,2478}, speed=200, dur=1, end_dir=7 },
			{ event='talk', delay=0.8, handle_id=4, talk='你们护送皇上回宫！', dur=2.5},
			{ event='talk', delay=3.6, handle_id=4, talk='其余人随我捉拿刺客！', dur=2.5},


			--首领捉拿刺客群
			{ event='move', delay= 6.4, handle_id=101, end_dir=7, pos={3284,2228}, speed=280, dur=1.5 },
			{ event='move', delay= 6.4, handle_id=4, end_dir=7, pos={3348,2260}, speed=280, dur=1.5 },
			{ event='move', delay= 6.4, handle_id=102, end_dir=7, pos={3412,2292}, speed=280, dur=1.5 },

			--王莽回宫护卫群
			{ event='move', delay= 6.4, handle_id=103, end_dir=7, pos={1680,1808}, speed=280, dur=1.5 },
			{ event='move', delay= 6.4, handle_id=104, end_dir=7, pos={1648,1872}, speed=280, dur=1.5 },

			{ event='move', delay= 6.4, handle_id=2, end_dir=7, pos={1718,1874}, speed=280, dur=1.5 },
			
			{ event='move', delay= 6.4, handle_id=105, end_dir=7, pos={1680,1808}, speed=280, dur=1.5 },
			{ event='move', delay= 6.4, handle_id=106, end_dir=7, pos={1648,1872}, speed=280, dur=1.5 },

			
	    },
    },

    ['juqing-ix018'] = 
	{
		--演员表 1 马武 2 刺客首领 201-202 刺客

	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 3192,my = 330},
	    	{ event='createActor', delay=0.1, handle_id = 1, body=47, pos= {3030,492},dir=1, speed=340, name_color=0xffffff, name="马武"},

	    	{ event='move', delay= 0.3, handle_id= 1, dir=1, pos= {3216,434},speed=340, dur=0.3, end_dir=1 }, 
	    },

	    --刺客想要解决马武
	    {	
	    	{ event='createActor', delay=0.1, handle_id = 201, body=22, pos= {3432,304}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=22, pos= {2804,536},dir=1, speed=340, name_color=0xffffff, name="刺客"},

	    	{ event='jump', delay= 0.3, handle_id= 201, dir=5, pos= {3290+30,404-30},speed=120, dur=0.3, end_dir=5 }, 
	    	{ event='jump', delay= 0.3, handle_id= 202, dir=1, pos= {3150-30,472+30},speed=120, dur=0.3, end_dir=1 }, 

	    	{ event='talk', delay=0.7, handle_id=1, talk='你们……想干什么？', dur=2.5, },

	    	{ event='talk', delay=3.4, handle_id=201, talk='要问的话，就怪你办事不利吧！', dur=2.5,},
	    },

	    --刺客首领决定放马武一马
	    {
	    	{ event='createActor', delay=0.1, handle_id = 2, body=48, pos={3022,304}, dir=3, speed=340, name_color=0xffffff, name="刺客首领"},

	    	{ event='move', delay= 0.2, handle_id= 2, dir=1, pos= {3128,380},speed=200, dur=0.3, end_dir=3 }, 

	    	{ event='move', delay= 0.5, handle_id= 1, dir=1, pos= {3216,434},speed=200, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.5, handle_id= 201, dir=1, pos= {3290+30,404-30},speed=200, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.5, handle_id= 202, dir=1, pos= {3150-30,472+30},speed=200, dur=0.3, end_dir=7 }, 

	    	{ event='talk', delay=0.5, handle_id=2, talk='等等！', dur=2.5,},
	    	{ event='talk', delay=3.3, handle_id=2, talk='看在你这么多年劳心劳力的份上。', dur=2.5,},
	    	{ event='talk', delay=6.1, handle_id=2, talk='今天饶你一命！', dur=2,},
	    	{ event='talk', delay=8.4, handle_id=2, talk='如若走漏风声，定取你性命！', dur=2.5,},

	    	{ event='talk', delay=11.2, handle_id=1, talk='哼，那马武还要谢过首领了！', dur=2.5,},
	    	{ event='talk', delay=14, handle_id=1, talk='告辞，后会无期！', dur=2.5,},

	    	{ event='move', delay= 16.3, handle_id= 1, dir=1, pos= {3640,754},speed=200, dur=0.3, end_dir=1 }, 

	    	{ event='move', delay= 16.3, handle_id= 201, dir=1, pos= {3290+30,404-30},speed=200, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 16.3, handle_id= 202, dir=1, pos= {3150-30,472+30},speed=200, dur=0.3, end_dir=3 }, 

	    	{ event='kill', delay=18, handle_id=1},
	    },

	    --刺客首领决定放马武一马
	    {
	    	{ event='talk', delay=0.5, handle_id=201, talk='首领，就这么放他走了？', dur=2.5,},
	    	{ event='move', delay= 0.5, handle_id= 201, dir=5, pos= {3290+30,404-30},speed=120, dur=0.3, end_dir=6 }, 
	    	{ event='talk', delay=3.3, handle_id=2, talk='哼哼，现在满城风声鹤唳，还有他在，官兵就不会怀疑到我们头上了。', dur=3.5,},
	    },
	},

	--============================================wuwenbin  每日剧情9 end  =====================================----

	
	    --============================================hanbaobao  每日剧情10 start  =====================================----
   	['juqing-ix019'] = 
	{
		--演员表 1 蔡少公 2 刘秀 3 少女阴丽华 4 盗贼头目 101-102 盗书贼 201-202 长安百姓 301-304 太学生 
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1201,my = 2227 },	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=23, pos={1202,2230}, dir=5, speed=340, name_color=0xffffff, name="蔡少公"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={248,1362}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},	    		    	
	    	{ event='createActor', delay=0.1, handle_id = 4, body=47, pos={2066,1521}, dir=5, speed=340, name_color=0xffffff, name="盗贼头目"},

	   		--盗书贼

	   		{ event='createActor', delay=0.1, handle_id = 101, body=31, pos={1815,1678}, dir=1, speed=340, name_color=0xffffff, name="盗书贼"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=32, pos={1910,1745}, dir=1, speed=340, name_color=0xffffff, name="盗书贼"},

	   		--长安百姓
	   		{ event='createActor', delay=0.1, handle_id = 201, body=37, pos={523,1420}, dir=2, speed=340, name_color=0xffffff, name="长安百姓"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=41, pos={656,1420}, dir=6, speed=340, name_color=0xffffff, name="长安百姓"},

	    	--太学生
	   		{ event='createActor', delay=0.1, handle_id = 301, body=1, pos={557,2605}, dir=1, speed=340, name_color=0xffffff, name="太学生"},
	    	{ event='createActor', delay=0.1, handle_id = 302, body=19, pos={557,2605}, dir=1, speed=340, name_color=0xffffff, name="太学生"},
	    	{ event='createActor', delay=0.1, handle_id = 303, body=38, pos={557,2605}, dir=1, speed=340, name_color=0xffffff, name="太学生"},
	    	{ event='createActor', delay=0.1, handle_id = 304, body=55, pos={557,2605}, dir=1, speed=340, name_color=0xffffff, name="太学生"},

	    },

	   --蔡少公BB
	    {	
	   		{ event='talk', delay=0.3, handle_id=1, talk='听闻长安太学文风盛行。', dur=2 },
	   		{ event='talk', delay=2.5, handle_id=1, talk='不知道这其中有没有出类拔萃的学生。', dur=2.5 },
			{ event='move', delay= 5.2, handle_id=1, end_dir=5, pos={942,2356}, speed=280, dur=1.5 },

			{ event ='camera', delay = 5.3, target_id=1, dur=0.5, sdur = 2,style = 'follow',backtime=1},

			{ event='move', delay= 5.2, handle_id=301, end_dir=2, pos={682,2317}, speed=280, dur=1.5 },
			{ event='move', delay= 5.2, handle_id=302, end_dir=1, pos={685,2452}, speed=280, dur=1.5 },
			{ event='move', delay= 5.2, handle_id=303, end_dir=1, pos={780,2518}, speed=280, dur=1.5 },
			{ event='move', delay= 5.2, handle_id=304, end_dir=1, pos={913,2524}, speed=280, dur=1.5 },

	   		{ event='talk', delay=6, handle_id=301, talk='蔡少公来了！', dur=1.3  },
	   		{ event='talk', delay=6.2, handle_id=302, talk='嘘……！', dur=1.3  },
	   		{ event='talk', delay=6.4, handle_id=304, talk='安静安静！', dur=1.3  },
	   		
	   	},

	    --镜头移动到刘秀丽华处
	    {	
	   		{ event = 'camera', delay = 0.2, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 599,1426 } }, -- 移动镜头通过

	   		{ event='talk', delay=1, handle_id=201, talk='听说蔡少公在太学讲学呢！', dur=2.5 },
	   		{ event='talk', delay=3.7, handle_id=202, talk='是吗？那我们也听不懂吧……', dur=2.5  },
	   		{ event='talk', delay=6.4, handle_id=201, talk='哈哈哈……', dur=1.5 },
	   		{ event='talk', delay=6.4, handle_id=202, talk='哈哈哈……', dur=1.5  },
	   		{ event='move', delay= 1.4, handle_id=2, end_dir=1, pos={402,1492}, speed=280, dur=1.5 },
	   		{ event='talk', delay=6.9, handle_id=2, talk='……', dur=1  },

	   		{ event='move', delay= 7.2, handle_id=201, end_dir=7, pos={135,1253}, speed=200, dur=1.8 },
			{ event='move', delay= 7.2, handle_id=202, end_dir=7, pos={135,1253}, speed=200, dur=1.8 },

			{ event='move', delay= 8.2, handle_id=2, end_dir=7, pos={402,1492}, speed=280, dur=1.5 },
	   		{ event='talk', delay= 8.3, handle_id=2, talk='……', dur=1 },

			{ event='kill', delay=9.2, handle_id=201},
	   		{ event='kill', delay=9.2, handle_id=202},

	   		{ event='createActor', delay= 9.2, handle_id = 3, body=6, pos={983,1745}, dir=7, speed=340, name_color=0xffffff, name="丽华"},

	   	},
        --刘秀继续走，丽华出场
	    {	
	   		{ event='move', delay= 0.2, handle_id=2, end_dir=2, pos={556,1614}, speed=280, dur=1.5 },
			{ event='move', delay= 0.2, handle_id=3, end_dir=6, pos={685,1620}, speed=280, dur=1.6 },

	   		{ event='talk', delay=1, handle_id=3, talk='文叔哥哥——', dur=1.5 },
	   		{ event='talk', delay=2.9, handle_id=2, talk='丽华？', dur=1.2  },
	   		{ event='talk', delay=4.3, handle_id=3, talk='舅舅正在太学讲学。', dur=1.7 },
	   		{ event='talk', delay=6.2, handle_id=3, talk='我们一起去听课吧。', dur=1.7  },
			{ event='talk', delay=8.1, handle_id=2, talk='正有此意！', dur=1.2  },
			{ event='talk', delay=9.5, handle_id=2, talk='快走，去晚了就开讲了。', dur=1.5  },
			{ event='talk', delay=11.2, handle_id=3, talk='嗯。', dur=1  },


	   		{ event='move', delay= 12.3, handle_id=2, end_dir=1, pos={1109,1323}, speed=280, dur=2 },
	   		{ event='move', delay= 12.3, handle_id=3, end_dir=1, pos={1109,1323}, speed=280, dur=2 },
	   	
	   	},

	   	--镜头移动到盗书贼处
	   	{
	   		--{ event = 'camera', delay = 0.2, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2136,1430 } }, -- 移动镜头通过
	   		{ event='init_cimera', delay = 0.2,mx= 2136,my = 1430 },	
	   		{ event='move', delay= 0.8, handle_id=101, end_dir=2, pos={1903,1586}, speed=280, dur=1.5 },
	   		{ event='move', delay= 0.8, handle_id=102, end_dir=1, pos={2007,1656}, speed=280, dur=1.5 },

	    	{ event='talk', delay=1.2, handle_id=101, talk='大哥，已经摸清了。', dur=1.5 },
	   		{ event='talk', delay=2.9, handle_id=4, talk='讲——', dur=1  },
			{ event='talk', delay=4.1, handle_id=102, talk='那些竹简都在内室，而讲学的人现在都在书堂。', dur=3.5 },
	   		{ event='talk', delay=7.8, handle_id=4, talk='好！', dur=1  },
	   		{ event='talk', delay=9, handle_id=4, talk='尽快动手，免得节外生枝。', dur=2 },
	   		{ event='talk', delay=11.2, handle_id=101, talk='遵命！', dur=1.5 },
	   		{ event='talk', delay=11.2, handle_id=102, talk='遵命！', dur=1.5 },

			{ event='kill', delay=1, handle_id=2},
	   		{ event='kill', delay=1, handle_id=3},
	   		
	   		{ event='createActor', delay=1.1, handle_id = 2, body=13, pos={823,2262}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},	   
	   		{ event='createActor', delay=1.1, handle_id = 3, body=6, pos={943,2254}, dir=5, speed=340, name_color=0xffffff, name="丽华"},


	    },


	    --镜头移动到太学蔡少公处
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	    	{ event='init_cimera', delay = 0.2,mx= 943,my = 2254 },	
	    	
			{ event='showTopTalk', delay=1.5, dialog_id="ix10_1" ,dialog_time = 2},

			{ event='talk', delay= 3.1, handle_id=1, talk='嗯？', dur=1.5  },
			{ event='talk', delay= 4.7, handle_id=1, talk='是何人喧哗！真是不知礼数！', dur=2.5  },

			{ event='showTopTalk', delay=7.4, dialog_id="ix10_2" ,dialog_time = 2},
			{ event='talk', delay=9.7, handle_id=1, talk='！', dur=1 },
	   		{ event='talk', delay=9.7, handle_id=2, talk='！', dur=1 },
	   		{ event='talk', delay=9.7, handle_id=3, talk='！', dur=1  },
	   		{ event='talk', delay=9.7, handle_id=301, talk='！', dur=1  },
	   		{ event='talk', delay=9.7, handle_id=302, talk='！', dur=1 },
	   		{ event='talk', delay=9.7, handle_id=303, talk='！', dur=1  },
	   		{ event='talk', delay=9.7, handle_id=304, talk='！', dur=1 },
	   		
	   		{ event='talk', delay=10.9, handle_id=1, talk='糟糕！有人盗走了我的书简！', dur=2 },

	   		{ event='move', delay=13, handle_id=1, end_dir=1, pos={1500,1926}, speed=280, dur=2 },
	   		{ event='talk', delay=13.1, handle_id=1, talk='这些书简可都是无价之宝啊！', dur=2 },

	   		{ event='move', delay=13.2, handle_id=3, end_dir=2, pos={943,2254}, speed=280, dur=2 },

	   		{ event='talk', delay=15.3, handle_id=2, talk='走，大家一起去追！', dur=1.5 },

			{ event='move', delay=17, handle_id=2, end_dir=1, pos={1300,2126}, speed=280, dur=1 },
			{ event='move', delay=17, handle_id=3, end_dir=1, pos={1300,2126}, speed=280, dur=1 },
			{ event='move', delay=17, handle_id=301, end_dir=1, pos={1300,2126}, speed=280, dur=1 },
			{ event='move', delay=17, handle_id=302, end_dir=1, pos={1300,2126}, speed=280, dur=1 },
			{ event='move', delay=17, handle_id=303, end_dir=1, pos={1300,2126}, speed=280, dur=1 },
			{ event='move', delay=17, handle_id=304, end_dir=1, pos={1300,2126}, speed=280, dur=1 },

			{ event='kill', delay=18, handle_id=4},
	   		{ event='kill', delay=18, handle_id=101},
	   		{ event='kill', delay=18, handle_id=102},

	   		
	   		
	   	},

	   	 --镜头移动到盗贼处
	    {	
					
	    
			{ event='init_cimera', delay = 0.2,mx=  722,my = 1396 },	
	    	--创建盗书贼

	   		{ event='createActor', delay=0.1, handle_id = 4, body=47, pos={721,1520}, dir=7, speed=340, name_color=0xffffff, name="盗贼头目"},
	    	{ event='createActor', delay=0.1, handle_id = 101, body=31, pos={816,1486}, dir=7, speed=340, name_color=0xffffff, name="盗书贼"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=32, pos={881,1576}, dir=7, speed=340, name_color=0xffffff, name="盗书贼"},

	    	{ event='kill', delay=0.1, handle_id=1},
	   		{ event='kill', delay=0.1, handle_id=2},
	   		{ event='kill', delay=0.1, handle_id=3},
	   		{ event='kill', delay=0.1, handle_id=301},
	   		{ event='kill', delay=0.1, handle_id=302},
	   		{ event='kill', delay=0.1, handle_id=303},
	   		{ event='kill', delay=0.1, handle_id=304},
			
			{ event='move', delay=0.2, handle_id=4, end_dir=3, pos={403,1492}, speed=280, dur=1.5 },
			{ event='move', delay=0.2, handle_id=101, end_dir=7, pos={531,1513}, speed=280, dur=1.5 },
			{ event='move', delay=0.2, handle_id=102, end_dir=7, pos={467,1589}, speed=280, dur=1.5 },

			{ event='talk', delay= 0.3, handle_id=101, talk='老大，你说这些竹简到底有什么用？', dur=2.5  },
			{ event='talk', delay= 3, handle_id=102, talk='是啊，老大，我也想不明白!', dur=2  },
			{ event='talk', delay= 5.2, handle_id=4, talk='你们懂什么？！这可是大买卖！', dur=2  },
			{ event='talk', delay= 7.4, handle_id=4, talk='你们以为这些竹简一文不值？', dur=2  },
			{ event='talk', delay= 9.6, handle_id=4, talk='可不知道有多少世家子弟对这些趋之若鹜呢！', dur=3  },
			{ event='talk', delay= 12.8, handle_id=101, talk='不亏是老大，懂得可真多。', dur=2  },
			{ event='talk', delay= 15, handle_id=102, talk='是啊是啊！', dur=1.5  },


			{ event='createActor', delay=15.2, handle_id = 2, body=13, pos={983,1745}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},	    		    	
	    	{ event='createActor', delay=15.2, handle_id = 3, body=6, pos={983,1745}, dir=7, speed=340, name_color=0xffffff, name="丽华"},

			{ event='move', delay=15.5, handle_id=2, end_dir=6, pos={721,1520}, speed=280, dur=1.5 },
			{ event='move', delay=15.5, handle_id=3, end_dir=6, pos={816,1486}, speed=280, dur=1.5 },

			{ event='talk', delay= 17, handle_id=2, talk='看你们还往哪儿跑！', dur=1.5  },
			
			{ event='move', delay=18.5, handle_id=4, end_dir=2, pos={403,1492}, speed=280, dur=1.5 },
			{ event='move', delay=18.5, handle_id=101, end_dir=2, pos={264,1521}, speed=280, dur=1.5 },
			{ event='move', delay=18.5, handle_id=102, end_dir=2, pos={332,1587}, speed=280, dur=1.5 },
			
			{ event='talk', delay= 18.6, handle_id=4, talk='！', dur=1  },
			{ event='talk', delay= 18.6, handle_id=101, talk='！', dur=1  },
			{ event='talk', delay= 18.6, handle_id=102, talk='！', dur=1  },
			{ event='talk', delay= 19.8, handle_id=4, talk='不好，被发现了，快跑！', dur=1.5  },

	   	},
    },

    ['juqing-ix020'] = 
	{
		--演员表 1 蔡少公 2 刘秀 3 少女阴丽华 4 盗贼头目 101-102 盗书贼 
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1332,my = 648 },	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=23, pos={943,1074}, dir=1, speed=340, name_color=0xffffff, name="蔡少公"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={1426,713}, dir=6, speed=340, name_color=0xffffff, name="刘秀"},	    
			{ event='createActor', delay=0.1, handle_id = 3, body=6, pos={1392,787}, dir=7, speed=340, name_color=0xffffff, name="丽华"},	    
	    	
	   		--盗书贼
			{ event='createActor', delay=0.1, handle_id = 4, body=47, pos={1236,722}, dir=3, speed=340, name_color=0xffffff, name="盗贼头目"},
	   		{ event='createActor', delay=0.1, handle_id = 101, body=31, pos={1200,624}, dir=3, speed=340, name_color=0xffffff, name="盗书贼"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=32, pos={1100,689}, dir=3, speed=340, name_color=0xffffff, name="盗书贼"},
           
            --盗书贼扑街
	   		{ event='playAction', delay=0.2, handle_id=4, action_id=4, dur=2, dir=6, loop=false,once =true},
	   		{ event='playAction', delay=0.2, handle_id=101, action_id=4, dur=2, dir=7, loop=false,once =true},
	   		{ event='playAction', delay=0.2, handle_id=102, action_id=4, dur=2, dir=5, loop=false,once =true},

	    },


	    --刺客想要解决马武
	    {	

			{ event='move', delay= 0.3, handle_id= 3, dir=7, pos= {1347,768},speed=200, dur=0.3, end_dir=7 }, 
	    	{ event='talk', delay=0.3, handle_id=3, talk='跑啊，你们怎么不跑啦？', dur=1.5, },
	    	{ event='talk', delay=2.3, handle_id=3, talk='敢来太学偷书，你们真是有胆子啊！', dur=2.5,},
			{ event='talk', delay=5, handle_id=2, talk='把书简交出来！', dur=1.3,},
			{ event='talk', delay=6.5, handle_id=2, talk='否则我们就报官了。', dur=1.5,},

			{ event='talk', delay=8.2, handle_id=101, talk='冤枉啊，冤枉啊！', dur=1.1,},
--盗书贼起身
	   		{ event='playAction', delay=9.5, handle_id=4, action_id=0, dur=2, dir=3, loop=true,once =false},
	   		{ event='playAction', delay=9.5, handle_id=101, action_id=0, dur=2, dir=3, loop=true,once =false},
	   		{ event='playAction', delay=9.5, handle_id=102, action_id=0, dur=2, dir=3, loop=true,once =false},

			
			{ event='talk', delay=9.7, handle_id=102, talk='都是我们大哥指使的！我们不敢不听啊！', dur=3,},			
			{ event='talk', delay=12.9, handle_id=4, talk='真是晦气，偷书也能被抓！', dur=2.3,},
			{ event='talk', delay=15.4, handle_id=4, talk='这些书简都在这里，你们报官吧！', dur=2.5,},		

			{ event='move', delay= 15.5, handle_id= 1, dir=7, pos= {1329,850},speed=280, dur=2, end_dir=7 }, 
			{ event='talk', delay=17.6, handle_id=1, talk='罢了，偷书不为贼！', dur=1.2,},
			{ event='talk', delay=19, handle_id=1, talk='书简还在就放了他们吧！', dur=2,},		


	    },

	},

	--============================================hanbaobao  每日剧情10 end  =====================================----
  	--============================================zhenhuai  每日剧情11 start  =====================================----
	['juqing-ix021'] =
	{
        --演员表 1 蔡姬 2 阴陆 3 丽华 4 刘秀 5 王莽 6禁卫军守卫 7禁卫军守卫 8禁卫军头领
        --创建角色
    	{
            { event='init_cimera', delay = 0.2,mx= 910,my = 2414 },
            { event='createActor', delay=0.1, handle_id = 1, body=2,pos= {776,2506}, dir=7, speed=340, name_color=0xffffff, name="蔡姬"},
            { event='createActor', delay=0.1, handle_id = 2, body=23,pos= {720,2476}, dir=3, speed=340, name_color=0xffffff, name="阴陆"},
            { event='createActor', delay=0.1, handle_id = 3, body=6,pos= {1168,2354}, dir=5, speed=340, name_color=0xffffff, name="丽华"},
            { event='createActor', delay=0.1, handle_id = 4, body=13,pos= {1126,2312}, dir=5, speed=340, name_color=0xffffff, name="刘秀"},
   		},
    
        --蔡姬和阴陆说话
        {
            { event='talk', delay=0.1, handle_id = 1, talk='不要在劝我了，我心意已决。[a]', dur=2.5, emote = { a =7}},
            { event='talk', delay=2.8, handle_id = 1, talk='不报此仇，我如何能苟活于世间？', dur=2 },
            { event='talk', delay=5, handle_id = 2, talk=' 你为何如此？！不是说好了，我们一起回家吗？', dur=2,},
            { event='talk', delay=8, handle_id = 2, talk=' 我已经安排好后事了，你带着丽华回南阳吧！', dur=2,},
        },
        --丽华和刘秀对话
        {
            { event = 'camera', delay = 0.1, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1200,2254 } }, -- 移动镜头通过
            { event='move', delay= 0.1, handle_id= 3, dir=1, pos= {1168,2354},speed=240, dur=0.1, end_dir=7 }, 
            { event='move', delay= 0.1, handle_id= 4, dir=1, pos= {1126,2312},speed=240, dur=0.1, end_dir=3 }, 
            { event='talk', delay=0.2, handle_id = 3, talk='我好害怕啊，我们该怎么办啊？[a]', dur=2.5, emote = { a =46}},
            { event='talk', delay=2.8, handle_id = 4, talk='大人的事情我也不懂。不过看伯父和伯母的神情，好像要有什么大事发生啊。', dur=3,},
        },
        --创建王莽与小兵
        {
        	{ event='init_cimera', delay = 0.2,mx= 1742,my = 1772 },
        	{ event='createActor', delay=0.1, handle_id = 5, body=53,pos= {1676,1772}, dir=5, speed=340, name_color=0xffffff, name="王莽"},
            { event='createActor', delay=0.1, handle_id = 6, body=57,pos= {1738,1844}, dir=5, speed=340, name_color=0xffffff, name="禁卫军守卫"},
            { event='createActor', delay=0.1, handle_id = 7, body=57,pos= {1586,1740}, dir=5, speed=340, name_color=0xffffff, name="禁卫军守卫"},
            { event='createActor', delay=0.1, handle_id = 8, body=59,pos= {1614,1838}, dir=5, speed=340, name_color=0xffffff, name="禁卫军头领"},
            { event='createActor', delay=0.1, handle_id = 1, body=2,pos= {1546,1898}, dir=1, speed=340, name_color=0xffffff, name="蔡姬"},

        },    
        --蔡姬行刺王莽
        {
        	{ event = 'camera', delay = 0.1, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1682,1786 } }, -- 移动镜头通过
        	{ event='talk', delay=0.2, handle_id = 1, talk='王莽，还我卫家的血债！[a]', dur=2.5, emote = { a =34}},
    		{ event='talk', delay=2.8, handle_id = 5, talk='反贼余孽，胆敢行刺与我！来人，将她拿下！', dur=2.5,},
    		{ event='talk', delay=5.5, handle_id = 6, talk='保护陛下！', dur=2,},
    		{ event='talk', delay=8, handle_id = 7, talk='快，抓刺客啊！', dur=2.5, },
    		{ event='talk', delay=12, handle_id = 8, talk='不要放跑刺客！  抓住她重重有赏！', dur=2, },
    	},
	}, 

    ['juqing-ix022']=
    {	
    	--演员表 1 蔡姬 2 阴陆 3丽华 4 刘秀
    	--创建角色
    	{
    		{ event='init_cimera', delay = 0.2,mx= 1430,my = 724 },
    		{ event='createActor', delay=0.1, handle_id = 1, body=2,pos= {1326,786}, dir=3, speed=340, name_color=0xffffff, name="蔡姬"},
            { event='createActor', delay=0.1, handle_id = 2, body=23,pos= {1388,840}, dir=7, speed=340, name_color=0xffffff, name="阴陆"},
            { event='createActor', delay=0.1, handle_id = 3, body=6,pos= {902,1072}, dir=1, speed=340, name_color=0xffffff, name="丽华"},
            { event='createActor', delay=0.1, handle_id = 4, body=13,pos= {946,1104}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
    	},
    	--阴陆蔡姬托付丽华
    	{
        	{ event='talk', delay=0.2, handle_id = 2, talk='既然你我是夫妻，我怎能弃你于不顾？这位小兄弟，你能代我将丽华送回南阳吗？', dur=2.5,},
    		{ event='talk', delay=2.8, handle_id = 1, talk='是我不好，连累了你们！我最放心的不下的就是丽华了。', dur=2.5, },
    		{ event = 'camera', delay = 5.8, dur=0.8,sdur = 0.5,target_id = 3 ,style = 'follow',backtime=1, },--
            { event='move', delay= 6.1, handle_id= 3, dir=1, pos= {1196,910},speed=240, dur=2, end_dir=1 }, 
            { event='move', delay= 6.1, handle_id= 4, dir=1, pos= {1228,942},speed=240, dur=2, end_dir=1 }, 
			{ event = 'camera', delay = 7.3, dur=1.2,sdur = 0.5,style = '',backtime=1, c_topox = { 1360,788 } }, 	
    		{ event='talk', delay=6.5, handle_id = 4, talk='伯父，伯母，你们这是怎么啦？在下定当将丽华安全送回南阳？ ',dur=2.5,},
    		{ event='talk', delay=8.5, handle_id = 3, talk='爹爹!娘亲！你们不要抛下我啊！', dur=3,},
            { event='move', delay= 6, handle_id= 1, dir=5, pos= {1326,786},speed=240, dur=2, end_dir=5 }, 
            { event='move', delay= 6, handle_id= 2, dir=5, pos= {1388,840},speed=240, dur=2, end_dir=5 },     		
    	},
    },
	--============================================zhenhuai  每日剧情11 end  =====================================----

--============================================	luyao	每日剧情12	start  ====================================
	['juqing-ix023'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 319,my = 730},		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={260+100,760+80}, dir=7, speed=340, name_color=0xffffff, name="王莽"},
			{ event='createActor', delay=0.1, handle_id = 2, body=56, pos={260,760}, dir=3, speed=340, name_color=0xffffff, name="王政君"},
			{ event='createActor', delay=0.1, handle_id = 3, body=55, pos={260+250,760+110}, dir=7, speed=340, name_color=0xffffff, name="王匡"},
			{ event='createActor', delay=0.1, handle_id = 4, body=43, pos={260+150,760+190}, dir=7, speed=340, name_color=0xffffff, name="王寻"},

	    	{ event='talk', delay=  1, handle_id=1, talk='如今汉室无人，姑母就不要再冥顽不知变通了。', dur=2.2,},
	    	{ event='talk', delay=3.5, handle_id=1, talk='谁说天子一定要姓刘的来掌控呢？', dur=2,},
	    	{ event='playAction', delay = 5.5, handle_id=1, action_id=2, dur=1.5, dir=7, loop=false ,},

	    	{ event='talk', delay=6, handle_id=1, talk='交出传国玉玺，不要逼侄儿对您动手！', dur=2,},		
		},
		{
	    	{ event='move', delay= 0.1, handle_id= 2, dir=3, pos= {240,740},speed=20, dur=0.3, end_dir=3 }, 
	    	{ event='talk', delay=  1, handle_id=2, talk='这···难道是天意啊！传国玉玺你们拿去吧。', dur=2.2,},
	    	{ event='talk', delay=3.5, handle_id=2, talk='不要在妄添杀戮了。', dur=2,},	
	    	{ event='move', delay= 5, handle_id= 2, dir=3, pos= {820,750},speed=340, dur=0.3, end_dir=3 }, 

	    	{ event='move', delay= 6, handle_id= 1, dir=2, pos= {260+100,760+80},speed=340, dur=0.3, end_dir=2 }, 	    	
	   		{ event='kill', delay=7, handle_id=2},
		},
		{
	    	{ event='move', delay= 0.1, handle_id= 3, dir=3, pos= {260+230,760+100},speed=340, dur=0.3, end_dir=7 },
	    	{ event='move', delay= 1.1, handle_id= 1, dir=3, pos= {260+100,760+80},speed=340, dur=0.3, end_dir=3 }, 	    	 
	    	{ event='talk', delay= 0.5, handle_id=3, talk='大···不，皇帝陛下，如今汉室已经废了。', dur=2.2,},
	    	{ event='talk', delay=3.5, handle_id=3, talk='这汉室的江山就是我们的了！', dur=2,},	
	    	{ event='move', delay= 6, handle_id= 4, dir=3, pos= {260+130,760+180},speed=340, dur=0.3, end_dir=7 }, 
	    	{ event='talk', delay= 6.5, handle_id=4, talk='我们王氏一族终于等到了这一天！', dur=2.2,},	

	    	{ event='talk', delay= 9, handle_id=1, talk='哈哈，哈哈···', dur=2.2,},	 
	    	{ event='talk', delay= 9, handle_id=3, talk='哈哈，哈哈···', dur=2.2,},	 
	    	{ event='talk', delay= 9, handle_id=4, talk='哈哈，哈哈···', dur=2.2,},
    		 	    	  	
		},
		{
	   		{ event='init_cimera', delay = 1,mx=719 ,my = 1260},		
			{event='changeRGBA', delay=0.1, txt="",cont_time=0.8, light_time=0.8, txt_time=0.1, black_time=0.1},

	    	{ event='kill', delay=0.3, handle_id=1},	
	    	{ event='kill', delay=0.3, handle_id=3},		    	
	    	{ event='kill', delay=0.3, handle_id=4},	

	    	{ event='createActor', delay=0.1, handle_id = 9, body=53, pos={494,1293}, dir=3, speed=340, name_color=0xffffff, name="王莽"},

			{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={530,1500}, dir=1, speed=340, name_color=0xffffff, name="大臣"},
			{ event='createActor', delay=0.1, handle_id = 6, body=23, pos={870,1370}, dir=5, speed=340, name_color=0xffffff, name="大臣"},
			{ event='createActor', delay=0.1, handle_id = 7, body=21, pos={530+100,1500+50}, dir=1, speed=340, name_color=0xffffff, name="大臣"},
			{ event='createActor', delay=0.1, handle_id = 8, body=21, pos={870+100,1370+50}, dir=5, speed=340, name_color=0xffffff, name="大臣"},	
		},
		{
	    	{ event='move', delay= 0.1, handle_id= 5, dir=3, pos= {622,1439},speed=340, dur=0.3, end_dir=7 },

	    	{ event='talk', delay= 0.8, handle_id=5, talk='恭贺新皇登基！', dur=2,},	
	    	{ event='move', delay= 2, handle_id= 6, dir=3, pos= {712,1383},speed=340, dur=0.3, end_dir=7 },
	    	{ event='move', delay= 2, handle_id= 7, dir=3, pos= {728,1505},speed=340, dur=0.3, end_dir=7 },
	    	{ event='move', delay= 2, handle_id= 8, dir=3, pos= {892,1445},speed=340, dur=0.3, end_dir=7 },
	    	    		    		    	 
	    	{ event='talk', delay= 3.5, handle_id=6, talk='吾皇万岁，万岁，万万岁！', dur=2.2,},
	    	{ event='talk', delay= 3.5, handle_id=7, talk='吾皇万岁，万岁，万万岁！', dur=2.2,},
	    	{ event='talk', delay= 3.5, handle_id=8, talk='吾皇万岁，万岁，万万岁！', dur=2.2,},
	    	{ event='talk', delay= 3.5, handle_id=5, talk='吾皇万岁，万岁，万万岁！', dur=2.2,},	

		},
		{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ix12_1" ,dialog_time = 3},
		},
		{
			{ event='createActor', delay=0.1, handle_id = 10, body=25, pos={1258+50,1470+50}, dir=5, speed=340, name_color=0xffffff, name="守卫统领"},

			{ event='createActor', delay=0.1, handle_id = 11, body=27, pos={1416+50,1470+50}, dir=5, speed=340, name_color=0xffffff, name="殿前守卫"},
			{ event='createActor', delay=0.1, handle_id = 12, body=27, pos={1250+50,1391+50}, dir=5, speed=340, name_color=0xffffff, name="殿前守卫"},			
				
	    	{ event = 'camera', delay = 1, dur=0.1,sdur = 0.1,style = '',backtime=1, c_topox = { 1019,1360 } },		
	    	{ event='move', delay= 0.3, handle_id= 8, dir=3, pos= {892,1445},speed=340, dur=0.3, end_dir=3 },

	    	{ event='talk', delay= 1.5, handle_id=8, talk='何人在殿外喧闹？', dur=1.8,},

	    	{ event='move', delay= 2, handle_id= 5, dir=3, pos= {622,1439},speed=340, dur=0.3, end_dir=3 },
	    	{ event='move', delay= 2, handle_id= 6, dir=3, pos= {712,1383},speed=340, dur=0.3, end_dir=3 },
	    	{ event='move', delay= 2, handle_id= 7, dir=3, pos= {728,1505},speed=340, dur=0.3, end_dir=3 },

	    	{ event='talk', delay= 3.5, handle_id=8, talk='不知道今天是新皇登基吗？', dur=2,},
	    	{ event='talk', delay= 6, handle_id=8, talk='去抓起来，好好审问一番！', dur=2,},
	    },
	    {
	    	{ event='move', delay= 0.1, handle_id= 10, dir=3, pos= {892+100,1445+70},speed=280, dur=0.3, end_dir=7 },	    	
	    	{ event='talk', delay= 1.5, handle_id=10, talk='属下这就去看看。', dur=2,},

	    	{ event='move', delay= 3.7, handle_id= 10, dir=3, pos= {892+100,1445+70},speed=340, dur=0.3, end_dir=2 },	    		    	
	    	{ event='talk', delay= 4, handle_id=10, talk='殿前守卫，随我来！', dur=2,},	

	    	{ event='move', delay= 6, handle_id= 10, dir=3, pos= {1317,1712},speed=340, dur=2, end_dir=3 },
	    	{ event='move', delay= 6, handle_id= 11, dir=3, pos= {1317,1712},speed=340, dur=2, end_dir=3 },
	    	{ event='move', delay= 6, handle_id= 12, dir=3, pos= {1317,1712},speed=340, dur=2, end_dir=3 },	    	
		},
	},

	['juqing-ix024'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 719,my = 1290},			
	    	{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={494,1293}, dir=3, speed=340, name_color=0xffffff, name="王莽"},

			{ event='createActor', delay=0.1, handle_id = 3, body=27, pos={590,1535}, dir=7, speed=340, name_color=0xffffff, name="殿前守卫"},
			{ event='createActor', delay=0.1, handle_id = 4, body=27, pos={780,1435}, dir=7, speed=340, name_color=0xffffff, name="殿前守卫"},
			{ event='createActor', delay=0.1, handle_id = 2, body=25, pos={650,1420}, dir=7, speed=340, name_color=0xffffff, name="守卫统领"},

	    	{ event='talk', delay= 1, handle_id=1, talk='朕的登基之日，居然有刺客行刺！', dur=2,},
	    	{ event='talk', delay= 3.5, handle_id=1, talk='你们这群饭桶，给我把刺客找出来。', dur=2,},
	    	{ event='talk', delay= 6, handle_id=1, talk='否则朕诛你们九族！', dur=2,},	

	    	{ event='playAction', delay = 6.5, handle_id=1, action_id=2, dur=1.5, dir=3, loop=false ,once=false},	  
		},
		{
	    	{ event='talk', delay= 0.1, handle_id=2, talk='[a]', emote={a=22}, dur=1,},
	    	{ event='talk', delay= 0.1, handle_id=3, talk='[a]', emote={a=44}, dur=1,},
	    	{ event='talk', delay= 0.1, handle_id=4, talk='[a]', emote={a=12}, dur=1,},

	    	{ event='talk', delay= 1.5, handle_id=2, talk='是！陛下。属下这就去捉拿刺客！', dur=2,},
	    	{ event='move', delay= 3.6, handle_id= 2, dir=3, pos= {650,1420},speed=340, dur=0.3, end_dir=3 },
	    	{ event='talk', delay= 3.7, handle_id=2, talk='你们还愣着干嘛？还不快走！', dur=2,},
		},
		{
	    	{ event='talk', delay= 0.1, handle_id=3, talk='是，统领！', dur=1.5,},
	    	{ event='talk', delay= 0.1, handle_id=4, talk='是，统领！', dur=1.5,},
	    	{ event='move', delay= 2, handle_id= 2, dir=3, pos= {1330,1750},speed=440, dur=0.3, end_dir=3 },	    	
	    	{ event='move', delay= 3, handle_id= 3, dir=3, pos= {1330,1750},speed=440, dur=0.3, end_dir=3 },
	    	{ event='move', delay= 3, handle_id= 4, dir=3, pos= {1330,1750},speed=440, dur=0.3, end_dir=3 },

	    	{ event = 'camera', delay = 3.8, dur=1.5,sdur = 1.5,style = '',backtime=1, c_topox = { 930,1450 } },

	    	{ event='talk', delay= 3.5, handle_id=4, talk='[a]吓死我了！统领我们不会有事吧···', emote={a=13}, dur=2,},	    		    	
		},
	},


--============================================	luyao	每日剧情12	end    ====================================

--===============================================sunluyao	每日剧情13	start =================================

	['juqing-ix025'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 1044,my = 2256 },		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={760,2400}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={790,2460}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={853,2440}, dir=7, speed=340, name_color=0xffffff, name="邓禹"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=19, pos={1331,2068}, dir=5, speed=340, name_color=0xffffff, name="大学生"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=19, pos={1455,2126}, dir=5, speed=340, name_color=0xffffff, name="大学生"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=19, pos={1005,2451}, dir=7, speed=340, name_color=0xffffff, name="大学生"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=19, pos={672,2239}, dir=3, speed=340, name_color=0xffffff, name="大学生"},


		},
		{
	   		{ event='move', delay=0.1, handle_id= 4, dir=5, pos= {1030,2312},speed=300, dur=2, end_dir=5 },
	   		{ event='move', delay=0.1, handle_id= 5, dir=5, pos= {1092,2354},speed=300, dur=2, end_dir=5 }, 

	    	{ event='talk', delay=1, handle_id=4, talk='不好了，不好了！', dur=1.8,},
	    	{ event='talk', delay=3, handle_id=5, talk='外面来了好多官兵包围了太学，气势汹汹的不知道要干嘛。', dur=2.5,},

	   		{ event='move', delay=2.5, handle_id= 1, dir=3, pos= {760,2400},speed=300, dur=1, end_dir=1 }, 
	   		{ event='move', delay=2.5, handle_id= 2, dir=3, pos= {790,2460},speed=300, dur=1, end_dir=1 }, 
	   		{ event='move', delay=2.5, handle_id= 3, dir=3, pos= {853,2440},speed=300, dur=1, end_dir=1 }, 
	   		{ event='move', delay=2.5, handle_id= 6, dir=3, pos= {1005,2451},speed=300, dur=1, end_dir=1 }, 
	   		--{ event='move', delay=2.5, handle_id= 7, dir=3, pos= {672,2239},speed=300, dur=1, end_dir=3 }, 


		},
		{
	   		{ event='move', delay=0.1, handle_id= 1, dir=3, pos= {760,2400},speed=300, dur=0.3, end_dir=3 }, 
	    	{ event='talk', delay=0.5, handle_id=1, talk='阿禹，文叔，这可怎么办？', dur=1.8,},
	    	{ event='talk', delay=2.5, handle_id=1, talk='官兵要来抓我们啦！', dur=1.8,},	

	   		{ event='move', delay=2.5, handle_id= 2, dir=3, pos= {790,2460},speed=300, dur=0.3, end_dir=7 }, 
	   		{ event='move', delay=2.5, handle_id= 3, dir=3, pos= {853,2440},speed=300, dur=0.3, end_dir=7 }, 

		},
		{
	    	{ event='talk', delay=0.1, handle_id=2, talk='可能是找我们救的那个人吧！', dur=2,},	
	    	{ event='talk', delay=2.5, handle_id=2, talk='先不要慌，我们出去看看。', dur=2,},

	    	{ event='talk', delay=5, handle_id=3, talk='这里是太学，谅他们也不敢胡来。', dur=2.2,},	
	
	    },	
	    {
	   		{ event='init_cimera', delay = 1,mx=1533 ,my = 1708},		
			{event='changeRGBA', delay=0.1, txt="",cont_time=0.8, light_time=0.8, txt_time=0.1, black_time=0.1},
	    	{ event='kill', delay=0.3, handle_id=1},
	    	{ event='kill', delay=0.3, handle_id=2},
	    	{ event='kill', delay=0.3, handle_id=3},
	    	{ event='kill', delay=0.3, handle_id=4},
	    	{ event='kill', delay=0.3, handle_id=5},
	    	{ event='kill', delay=0.3, handle_id=6},
	    	{ event='kill', delay=0.3, handle_id=7},


	    	{ event='createActor', delay=0.5, handle_id = 14, body=21, pos={1700,1760}, dir=5, speed=340, name_color=0xffffff, name="官兵首领"},
	    	{ event='createActor', delay=0.5, handle_id = 15, body=27, pos={1700-100,1760-50}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	   		{ event='createActor', delay=0.5, handle_id = 16, body=27, pos={1700+100,1760+50}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	    	{ event='createActor', delay=0.5, handle_id = 17, body=28, pos={1700+150,1760}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	    	{ event='createActor', delay=0.5, handle_id = 18, body=28, pos={1700,1760-100}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	    },

	    {
	    	{ event='talk', delay=1, handle_id=14, talk='给我好好的搜查，跑了刺客，看我怎么收拾你们！', dur=2.5,},

	   		{ event='move', delay=4, handle_id= 15, dir=3, pos= {1700-150,1760},speed=300, dur=1, end_dir=5 }, 
	   		{ event='move', delay=4, handle_id= 16, dir=3, pos= {1700+50,1760+100},speed=300, dur=1, end_dir=5 }, 
	   		{ event='move', delay=4, handle_id= 17, dir=3, pos= {1700+100,1760+50},speed=300, dur=1, end_dir=5 }, 
	   		{ event='move', delay=4, handle_id= 18, dir=3, pos= {1700-60,1760-60},speed=300, dur=1, end_dir=5 }, 

	   		--{ event='move', delay=4, handle_id= 14, dir=3, pos= {1700,1760},speed=300, dur=0.3, end_dir=5 }, 
	    	{ event='createActor', delay=4.5, handle_id = 11, body=6, pos={1500-50,1900+50}, dir=1, speed=340, name_color=0xffffff, name="阴丽华"},
	    	{ event='createActor', delay=4.5, handle_id = 12, body=13, pos={1500-150,1900}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=4.5, handle_id = 13, body=1, pos={1500+50,1900+100}, dir=1, speed=340, name_color=0xffffff, name="邓禹"},	

	   		{ event='move', delay=4.6, handle_id= 11, dir=3, pos= {1500,1900},speed=300, dur=1, end_dir=1 }, 
	   		{ event='move', delay=4.6, handle_id= 12, dir=3, pos= {1500-100,1900-50},speed=300, dur=1, end_dir=1 }, 
	   		{ event='move', delay=4.6, handle_id= 13, dir=3, pos= {1500+100,1900+50},speed=300, dur=1, end_dir=1 }, 

	    	{ event='talk', delay=5.5, handle_id=15, talk='都听好了，现在严禁你们随意进出太学！', dur=2,},
	    	{ event='talk', delay=8, handle_id=16, talk='都安静，不要吵闹，我们在抓刺客。', dur=2,},	
	    },
	    {
    
	   		{ event='move', delay=0.2, handle_id= 11, dir=3, pos= {1500+80,1900-80},speed=300, dur=1, end_dir=1 }, 

	    	{ event='talk', delay=1, handle_id=11, talk='你们干嘛？这里可是太学院！', dur=2,},

	   		{ event='move', delay=3.5, handle_id= 12, dir=3, pos= {1500-90,1900-70},speed=300, dur=1, end_dir=1}, 	    	
	    	{ event='talk', delay=4.2, handle_id=12, talk='丽华，小心！不要和他们冲突啊！', dur=2,},	 	    	  		
	    },
		{
	   		{ event='move', delay=0.1, handle_id= 15, dir=3, pos= {1500,1777},speed=300, dur=1, end_dir=3 }, 
	   		{ event='move', delay=0.1, handle_id= 16, dir=3, pos= {1637,1865},speed=300, dur=1, end_dir=7 }, 

	   		--{ event='move', delay=0.5, handle_id= 11, dir=3, pos= {1500,1900},speed=300, dur=1, end_dir=1 }, 
	   		{ event='move', delay=1.8, handle_id= 12, dir=3, pos= {1500-50,1777+50},speed=300, dur=1, end_dir=1 }, 	
	   		{ event='move', delay=1.8, handle_id= 13, dir=3, pos= {1637-50,1865+50},speed=300, dur=1, end_dir=1 }, 

	    	{ event='talk', delay=2.4, handle_id=13, talk='放开丽华，不然我们不客气了！', dur=2,},	

	   		{ event='move', delay=3, handle_id= 15, dir=3, pos= {1500,1777},speed=300, dur=1, end_dir=5 }, 
	   		{ event='move', delay=3, handle_id= 16, dir=3, pos= {1637,1865},speed=300, dur=1, end_dir=5 }, 
		},    
	},

	['juqing-ix026'] =
	{
		{
	   		{ event='init_cimera', delay = 0.1,mx= 1533,my = 1708 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1500,1900}, dir=1, speed=340, name_color=0xffffff, name="阴丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=13, pos={1500-100,1900-50}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={1500+100,1900+50}, dir=1, speed=340, name_color=0xffffff, name="邓禹"},	

	    	{ event='createActor', delay=0.1, handle_id = 4, body=21, pos={1700,1760}, dir=5, speed=340, name_color=0xffffff, name="官兵首领"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={1500,1777}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	   		{ event='createActor', delay=0.1, handle_id = 6, body=27, pos={1637,1865}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	    	{ event='createActor', delay=0.1, handle_id = 7, body=28, pos={1700+150,1760}, dir=5, speed=340, name_color=0xffffff, name="官兵"},
	    	{ event='createActor', delay=0.1, handle_id = 8, body=28, pos={1700,1760-100}, dir=5, speed=340, name_color=0xffffff, name="官兵"},

	    	{ event='playAction', delay = 0.2, handle_id=5, action_id=4, dur=1.5, dir=3, loop=false , once=true,},	
	    	{ event='playAction', delay = 0.2, handle_id=6, action_id=4, dur=1.5, dir=7, loop=false , once=true,},		    	
		},
		{
	   		{ event='move', delay=1, handle_id= 4, dir=3, pos= {1700-50,1760+50},speed=300, dur=1, end_dir=5 },
	    	{ event='talk', delay=1.8, handle_id=4, talk='你们这群学生，不好好求学，居然包庇刺客。', dur=2.2,},
	    	{ event='talk', delay=4.2, handle_id=4, talk='看我上报朝廷，查封学院！', dur=2,},
		},
		{
	   		{ event='move', delay=1, handle_id= 7, dir=3, pos= {1700,1760+50},speed=300, dur=1, end_dir=5 },		
	    	{ event='talk', delay=1.8, handle_id=7, talk='大人，我们怎么办？', dur=2.2,},
	    	{ event='talk', delay=4.2, handle_id=4, talk='这里是太学，我们不能大动干戈。', dur=2,},
	    	{ event='talk', delay=6.7, handle_id=4, talk='先撤，将此事禀报朝廷！', dur=2,},
		},
		{
	   		{ event='move', delay=0.1, handle_id= 4, dir=3, pos= {1075,1648},speed=300, dur=1, end_dir=5 },
	   		--{ event='move', delay=0.1, handle_id= 5, dir=3, pos= {1075,1548},speed=300, dur=1, end_dir=5 },
	   		--{ event='move', delay=0.1, handle_id= 6, dir=3, pos= {1075,1548},speed=300, dur=1, end_dir=5 },
	   		{ event='move', delay=0.1, handle_id= 7, dir=3, pos= {1075,1648},speed=300, dur=1, end_dir=5 },
	   		{ event='move', delay=0.1, handle_id= 8, dir=3, pos= {1075,1648},speed=300, dur=1, end_dir=5 },

	   		{ event='move', delay=1, handle_id= 1, dir=3, pos= {1500,1900},speed=300, dur=1, end_dir=7 },	
	   		{ event='move', delay=1, handle_id= 2, dir=3, pos= {1500-100,1900-50},speed=300, dur=1, end_dir=7 },	
	   		{ event='move', delay=1, handle_id= 3, dir=3, pos= {1500+100,1900+50},speed=300, dur=1, end_dir=7 },

	    	{ event='kill', delay=3, handle_id=4},
	    	{ event='kill', delay=3, handle_id=5},
	    	{ event='kill', delay=3, handle_id=6},
	    	{ event='kill', delay=3, handle_id=7},
	    	{ event='kill', delay=3, handle_id=8},	   			   			   		
		},
		{
	   		{ event='move', delay=0.1, handle_id= 2, dir=3, pos= {1500-100,1900-50},speed=300, dur=1, end_dir=3 },		
	    	{ event='talk', delay=0.5, handle_id=2, talk='丽华，你没事吧？', dur=2.2,},
	    },
	    {	
--	   		{ event='move', delay=0.1, handle_id= 3, dir=3, pos= {1500+100,1900+50},speed=300, dur=1, end_dir=5 },
	    	{ event='talk', delay=0.5, handle_id=3, talk='丽华，你怎么这么冲动啊？', dur=2,},
	    	{ event='talk', delay=3, handle_id=3, talk='他们可都是带着兵器的。', dur=2,},

	   		{ event='move', delay=2, handle_id= 1, dir=3, pos= {1500,1900},speed=300, dur=1, end_dir=3 },	    	
	    	{ event='talk', delay=5.5, handle_id=1, talk='我没事，他们太野蛮了！', dur=2,},
	    	{ event='talk', delay=8, handle_id=1, talk='居然在书院就动手。', dur=2,},

		},

	},



--================================================sunluyao	每日剧情13	end    =========================================


    --============================================wuwenbin  每日剧情14 start  =====================================----
   	['juqing-ix027'] = 
	{
		--演员表 1 马武  2 刺客首领 3 守卫将领 101-104 巡城守卫 201-202 刺客
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 3500,my = 1170 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=18, pos={3126,1004}, dir=3, speed=340, name_color=0xffffff, name="刘玄"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=48, pos={3506+30,1234+30}, dir=7, speed=340, name_color=0xffffff, name="刺客首领"},

	   		--刺客
	   		{ event='createActor', delay=0.1, handle_id = 201, body=22, pos={3190,972}, dir=3, speed=340, name_color=0xffffff, name="刺客"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=22, pos={3062,1044}, dir=3, speed=340, name_color=0xffffff, name="刺客"},
	    },

	    --刺客带上刘玄见首领
	    {	
	    	{ event='move', delay= 0.2, handle_id=1, end_dir=3, pos={3442,1196}, speed=280, dur=1.5 },

	    	{ event='move', delay= 0.2, handle_id=201, end_dir=3, pos={3500,1166}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },

	   		{ event='talk', delay=0.5, handle_id=201, talk='首领，刘玄刘圣功带来了。', dur=2.5 },
	   		{ event='talk', delay=3.3, handle_id=2, talk='刘玄，你对此次计划如何安排？', dur=2.5  },
	   		{ event='talk', delay=6.1, handle_id=2, talk='经过马武，卫悦之事，王莽已经加强了护卫。', dur=2.5  },
	   		{ event='talk', delay=8.9, handle_id=2, talk='我们不能再失败了！', dur=2  },

	   		{ event='talk', delay=11.2, handle_id=1, talk='放心，虽说我刘圣功武勇不及马武，卫悦等人。', dur=3  },
	   		{ event='talk', delay=14.5, handle_id=1, talk='但是我是汉室刘家子孙！绝不容忍莽贼占我大汉江山！', dur=3  },

	   		{ event='talk', delay=17.8, handle_id=2, talk='好，那我们就等你的好消息了。', dur=2  },

	   		{ event='kill', delay=20, handle_id=1},
	    	{ event='kill', delay=20, handle_id=2},
	    	{ event='kill', delay=20, handle_id=201},
	    	{ event='kill', delay=20, handle_id=202},
	   	},

	   	--镜头移至刘玄处，走来走去，惴惴不安
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1720,my = 3578 },
	   		{ event='createActor', delay=0.1, handle_id = 1, body=18, pos={1586,3664}, dir=5, speed=340, name_color=0xffffff, name="刘玄"},
	   		{ event='move', delay= 0.2, handle_id=1, end_dir=1, pos={1680,3604}, speed=280, dur=1.5 },
	    	{ event='talk', delay=0.8, handle_id=1, talk='要找个时机……', dur=2 },

	    	{ event='move', delay= 2.8, handle_id=1, end_dir=5, pos={1586,3664}, speed=280, dur=1.5 },
	   		{ event='talk', delay=3.2, handle_id=1, talk='潜入皇宫……诛杀莽贼……', dur=2  },

	   		{ event='move', delay= 5.2, handle_id=1, end_dir=1, pos={1680,3604}, speed=280, dur=1.5 },
	   		{ event='talk', delay=5.7, handle_id=1, talk='可是……[a]', dur=2 ,emote = { a = 23} },
	    },


	    --镜头移至守卫出，在吐槽
	    {	
	    	{ event = 'camera', delay = 0.1, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 3706,3480 } },
	    	
	    	--禁卫
	    	{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={3670,3508}, dir=3, speed=340, name_color=0xffffff, name="守卫将领"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=58, pos={3700,3572}, dir=7, speed=340, name_color=0xffffff, name="巡城守卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=58, pos={3760,3542}, dir=7, speed=340, name_color=0xffffff, name="巡城守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=58, pos={3762,3628}, dir=7, speed=340, name_color=0xffffff, name="巡城守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=58, pos={3828,3600}, dir=7, speed=340, name_color=0xffffff, name="巡城守卫"},



	   		{ event='talk', delay=1.8, handle_id=101, talk='大人，光说巡视，巡视，这什么时候是个头啊？', dur=3  },
	   		{ event='talk', delay=5.1, handle_id=102, talk='真有刺客，早就抓到啦……', dur=2.5  },

	   		{ event='talk', delay=7.9, handle_id=3, talk='都给我精神点！', dur=2  },
	   		{ event='talk', delay=10.2, handle_id=3, talk='刺客都来两回了！', dur=2  },
	   		{ event='talk', delay=12.5, handle_id=3, talk='再出问题，我们谁都担待不起的！', dur=2.5  },

	   		{ event = 'camera', delay = 15.5, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2992+180,3288-60 } },
	   		{ event='move', delay= 15.5, handle_id=3, end_dir=6, pos={2992+180,3288}, speed=280, dur=1.5 },
	   		{ event='move', delay= 15.5, handle_id=101, end_dir=6, pos={3024+180,3342}, speed=280, dur=1.5 },
	   		{ event='move', delay= 15.5, handle_id=102, end_dir=6, pos={3084+180,3316}, speed=280, dur=1.5 },
	   		{ event='move', delay= 15.5, handle_id=103, end_dir=6, pos={3088+180,3406}, speed=280, dur=1.5 },
	   		{ event='move', delay= 15.5, handle_id=104, end_dir=6, pos={3156+180,3376}, speed=280, dur=1.5 },

	   		{ event='talk', delay=18.5, handle_id=3, talk='什么人！鬼鬼祟祟的，站住！', dur=2.5  },
	   	},

	   	--镜头移至刘玄处，官兵再出现
	    {	
	    	{ event = 'camera', delay = 0.1, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = { 1720,3578 } },

	    	{ event='kill', delay=0.8, handle_id=3},
	    	{ event='kill', delay=0.8, handle_id=101},
	    	{ event='kill', delay=0.8, handle_id=102},
	    	{ event='kill', delay=0.8, handle_id=103},
	    	{ event='kill', delay=0.8, handle_id=104},

			{ event='createActor', delay=1, handle_id = 3, body=43, pos={2288,3314}, dir=1, speed=340, name_color=0xffffff, name="守卫将领"},

	   		{ event='createActor', delay=1, handle_id = 101, body=58, pos={2388,3278}, dir=1, speed=340, name_color=0xffffff, name="巡城守卫"},
	    	{ event='createActor', delay=1, handle_id = 102, body=58, pos={2324,3252}, dir=1, speed=340, name_color=0xffffff, name="巡城守卫"},
	   		{ event='createActor', delay=1, handle_id = 103, body=58, pos={2444,3218}, dir=1, speed=340, name_color=0xffffff, name="巡城守卫"},
	   		{ event='createActor', delay=1, handle_id = 104, body=58, pos={2380,3182}, dir=1, speed=340, name_color=0xffffff, name="巡城守卫"},

	    	{ event='move', delay= 1, handle_id=1, end_dir=2, pos={1680,3604}, speed=280, dur=1.5 },
	    	{ event='talk', delay=1, handle_id=1, talk='！！', dur=1.5},
	    	{ event='talk', delay=2.8, handle_id=1, talk='不好，被发现了！快跑！', dur=2},

	    	{ event='move', delay= 3.5, handle_id=1, end_dir=2, pos={752,4050}, speed=200, dur=1.5 },
	    	-- { event='kill', delay=18, handle_id=1},


	    	{ event='move', delay= 4.5, handle_id=3, end_dir=5, pos={1740,3596}, speed=280, dur=1.5 },

	    	{ event='move', delay= 4.5, handle_id=101, end_dir=5, pos={1836+60,3568}, speed=280, dur=1.5 },
	    	{ event='move', delay= 4.5, handle_id=102, end_dir=5, pos={1772+60,3536}, speed=280, dur=1.5 },
	    	{ event='move', delay= 4.5, handle_id=103, end_dir=5, pos={1900+60,3500}, speed=280, dur=1.5 },
	    	{ event='move', delay= 4.5, handle_id=104, end_dir=5, pos={1838+60,3460}, speed=280, dur=1.5 },

	    	{ event='talk', delay=6, handle_id=3, talk='别让他跑了！', dur=2},

	    	{ event='move', delay= 7.8, handle_id=3, end_dir=5, pos={752,4050}, speed=280, dur=1.5 },

	    	{ event='move', delay= 7.8, handle_id=101, end_dir=5, pos={838+60,4018}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.8, handle_id=102, end_dir=5, pos={786+60,3978}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.8, handle_id=103, end_dir=5, pos={838+60,4018}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.8, handle_id=104, end_dir=5, pos={786+60,3978}, speed=280, dur=1.5 },

	    	{ event='kill', delay=10, handle_id=3},
	    	{ event='kill', delay=10, handle_id=101},
	    	{ event='kill', delay=10, handle_id=102},
	    	{ event='kill', delay=10, handle_id=103},
	    	{ event='kill', delay=10, handle_id=104},
	   	},

    },

    ['juqing-ix028'] = 
	{
		--演员表 1 刘玄 2 刺客首领 3 守卫将领 101-104 巡城守卫 201-202 刺客

	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 3500,my = 1170},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=48, pos= {3506+30,1234+30},dir=7, speed=340, name_color=0xffffff, name="刺客首领"},
	    	{ event='createActor', delay=0.1, handle_id = 201, body=22, pos= {3120,1004}, dir=3, speed=340, name_color=0xffffff, name="刺客"},
	    	-- { event='createActor', delay=0.1, handle_id = 202, body=22, pos= {2804,536},dir=1, speed=340, name_color=0xffffff, name="刺客"},
	    },

	    --首领得知刘玄失败，生气+失落
	    {
	    	{ event='move', delay= 0.1, handle_id= 201, dir=1, pos= {3442,1196},speed=240, dur=0.3, end_dir=3 }, 
	    	{ event='talk', delay=1, handle_id=201, talk='首领，不好了！刘玄行刺被发现了。', dur=2.5},
	    	{ event='talk', delay=3.8, handle_id=2, talk='这个刘玄！[a]', dur=2,emote= { a = 24}},
	    	{ event='playAction', delay = 4, handle_id=2, action_id=2, dur=1.5, dir=7, loop=false ,},

	    	{ event='move', delay= 6, handle_id= 2, dir=1, pos= {3506+30,1234+30},speed=340, dur=0.3, end_dir=3 }, 
	    	{ event='talk', delay=6.3, handle_id=2, talk='唉，难道真的是王莽的气数未尽？', dur=2.5},
	    	{ event='talk', delay=9.1, handle_id=2, talk='这么多次的行刺全部以失败告终，天不佑我啊！', dur=3},
	    },

	    --刘玄告辞
	    {	
	    	{ event='createActor', delay=0.1, handle_id = 1, body=18, pos= {3120,1004},dir=1, speed=340, name_color=0xffffff, name="刘玄"},
	    	{ event='move', delay= 0.2, handle_id= 1, dir=1, pos= {3442,1196},speed=340, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 1.5, handle_id= 201, dir=1, pos= {3504,1170},speed=340, dur=0.3, end_dir=5 }, 

	    	{ event='talk', delay=1.5, handle_id=1, talk='抱歉首领，是我大意了……[a]', dur=2.5,emote= { a = 23}},
	    	{ event='talk', delay=4.3, handle_id=1, talk='我要出去避避风头……', dur=2},
	    	{ event='talk', delay=6.6, handle_id=1, talk='在这里会连累大家的……', dur=2},

	    	{ event='talk', delay= 8.9, handle_id=2, talk='嗯，你去吧……', dur=3},
	    	{ event='move', delay= 12, handle_id= 1, dir=1, pos= {2904,848},speed=340, dur=2, end_dir=1 }, 
	    },

	    --守卫计划关城抓刘玄
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 4026,my = 3380},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={4078+30,3536-16}, dir=7, speed=340, name_color=0xffffff, name="守卫将领"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=58, pos={3700,3282}, dir=3, speed=340, name_color=0xffffff, name="巡城守卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=58, pos={3630,3314}, dir=3, speed=340, name_color=0xffffff, name="巡城守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=58, pos={3640,3218}, dir=3, speed=340, name_color=0xffffff, name="巡城守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=58, pos={3564,3248}, dir=3, speed=340, name_color=0xffffff, name="巡城守卫"},

	    	{ event='move', delay= 0.3, handle_id= 101, dir=1, pos= {4048-30,3470-30},speed=240, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.3, handle_id= 102, dir=1, pos= {3984-30,3506-30},speed=240, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.3, handle_id= 103, dir=1, pos= {3980-30,3406-30},speed=240, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.3, handle_id= 104, dir=1, pos= {3924-30,3446-30},speed=240, dur=0.3, end_dir=3 }, 

	    	{ event='talk', delay=1, handle_id=101, talk='大人，那家伙跑了！', dur=2,},
	    	{ event='talk', delay=3.3, handle_id=3, talk='不要慌乱，传我命令，封锁城门，抓捕刺客！', dur=3,},


	    	{ event='talk', delay=6.6, handle_id=101, talk='喏！', dur=2,},
	    	{ event='talk', delay=6.6, handle_id=102, talk='喏！', dur=2,},
	    	{ event='talk', delay=6.6, handle_id=103, talk='喏！', dur=2,},
	    	{ event='talk', delay=6.6, handle_id=104, talk='喏！', dur=2,},

	    	{ event='move', delay= 8.6, handle_id= 101, dir=1, pos= {3700,3282},speed=240, dur=1, end_dir=1 }, 
	    	{ event='move', delay= 8.6, handle_id= 102, dir=1, pos= {3630,3314},speed=240, dur=0.3, end_dir=1 }, 
	    	{ event='move', delay= 8.6, handle_id= 103, dir=1, pos= {3640,3218},speed=240, dur=0.3, end_dir=1 }, 
	    	{ event='move', delay= 8.6, handle_id= 104, dir=1, pos= {3564,3248},speed=240, dur=0.3, end_dir=1 }, 
	    },
	},

	--============================================wuwenbin  每日剧情14 end  =====================================----

	
    --============================================hanbaobao  每日剧情15 start  =====================================----
   	['juqing-ix029'] = 
	{
		--演员表 1 王莽  2 王匡 3 王寻 4 汉平帝刘衎 101-104 护卫军 
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1173-50,my = 2426+50 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={1108+50,2515+50}, dir=3, speed=340, name_color=0xffffff, name="王莽"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=55, pos={1137+50,2423+50}, dir=3, speed=340, name_color=0xffffff, name="王匡"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={1013+50,2580+50}, dir=3, speed=340, name_color=0xffffff, name="王寻"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=24, pos={1264+50,2571+50}, dir=7, speed=340, name_color=0xffffff, name="汉平帝刘衎"},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={1038+50,2381+50}, dir=3, speed=340, name_color=0xffffff, name="护卫军"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={972+50,2450+50}, dir=3, speed=340, name_color=0xffffff, name="护卫军"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=27, pos={914+50,2515+50}, dir=3, speed=340, name_color=0xffffff, name="护卫军"},
	    	{ event='createActor', delay=0.1, handle_id = 104, body=27, pos={847+50,2578+50}, dir=3, speed=340, name_color=0xffffff, name="护卫军"},

	    },
        --开始BB
        {
			{ event='talk', delay=0.3, handle_id=1, talk='交出斩蛇剑，我保你汉室宗亲的周全！', dur=3,},
	    	{ event='talk', delay=3.5, handle_id=1, talk='否则的话，就休怪我不讲君臣之道了！', dur=3,},
	    	{ event='talk', delay=6.7, handle_id=2, talk='还跟一个亡国之君说这些干嘛？', dur=2.5,},
	    	{ event='talk', delay=9.4, handle_id=2, talk='直接抢过来不就好了！', dur=2,},
	    	{ event='talk', delay=11.6, handle_id=4, talk='高祖的斩蛇剑乃是汉朝的象征！', dur=2.5,},
	    	{ event='talk', delay=14.3, handle_id=4, talk='怎能轻易交付于你？', dur=1.5,},
	    	{ event='talk', delay=16, handle_id=4, talk='简直是痴心妄想！', dur=1.5,},
	    	{ event='playAction', delay = 16, handle_id=4, action_id=2, dur=1.5, dir=7, loop=false ,},
		},

		{

	    	
	    	{ event='talk', delay=0.2, handle_id=2, talk='大司马，不要跟他废话了。', dur=2,},
	    	{ event='talk', delay=2.4, handle_id=3, talk='他既然冥顽不灵我们就该让他清醒一下。', dur=3,},
	    	{ event='talk', delay=5.6, handle_id=1, talk='那就休怪我王莽不客气了！', dur=2,},
	    	{ event='talk', delay=7.8, handle_id=1, talk='来人——！', dur=1.1,},
	    	{ event='talk', delay=9.1, handle_id=1, talk='替我们的皇帝陛下拿下斩蛇剑！', dur=2.5,},
	    	{ event='talk', delay=11.8, handle_id=101, talk='遵命！', dur=1.1,},
	    	{ event='talk', delay=11.8, handle_id=102, talk='遵命！', dur=1.1,},
	    	{ event='talk', delay=11.8, handle_id=103, talk='遵命！', dur=1.1,},
	    	{ event='talk', delay=11.8, handle_id=104, talk='遵命！', dur=1.1,},

	    },

		{
	    	{ event='talk', delay=0.1, handle_id=4, talk='你们……想干什么？', dur=1.3,},

	    	{ event='move', delay= 0.5, handle_id= 101, dir=3, pos= {1627,2799},speed=300, dur=1, end_dir=3 }, 
	    	{ event='move', delay= 0.5, handle_id= 102, dir=3, pos= {1627,2799},speed=300, dur=1, end_dir=3 }, 
	    	{ event='move', delay= 0.5, handle_id= 103, dir=3, pos= {1627,2799},speed=300, dur=1, end_dir=3 }, 
	    	{ event='move', delay= 0.5, handle_id= 104, dir=3, pos= {1627,2799},speed=300, dur=1, end_dir=3 }, 

			{ event='talk', delay=1.5, handle_id=4, talk='！', dur=1,},
	    	{ event='move', delay= 1.5, handle_id= 4, dir=3, pos= {1627,2799},speed=200, dur=1, end_dir=3 }, 

	    	

	    },

	    {
	    	{ event='init_cimera', delay = 0.2,mx= 2160,my = 2514 },


	    	{ event='kill', delay=0.1, handle_id=4},
	    	{ event='kill', delay=0.1, handle_id=101},
	    	{ event='kill', delay=0.1, handle_id=102},
	    	{ event='kill', delay=0.1, handle_id=103},
	    	{ event='kill', delay=0.1, handle_id=104},

			{ event='createActor', delay=0.2, handle_id = 4, body=24, pos={2123,2644}, dir=7, speed=340, name_color=0xffffff, name="汉平帝刘衎"},

	    	{ event='createActor', delay=0.2, handle_id = 101, body=27, pos={2193,2478}, dir=3, speed=340, name_color=0xffffff, name="护卫军"},
	    	{ event='createActor', delay=0.2, handle_id = 102, body=27, pos={2321,2677}, dir=7, speed=340, name_color=0xffffff, name="护卫军"},
	   		{ event='createActor', delay=0.2, handle_id = 103, body=27, pos={2134,2771}, dir=3, speed=340, name_color=0xffffff, name="护卫军"},
	    	{ event='createActor', delay=0.2, handle_id = 104, body=27, pos={1969,2569}, dir=7, speed=340, name_color=0xffffff, name="护卫军"},

			{ event='move', delay= 0.3, handle_id= 4, dir=1, pos= {2222,2566},speed=240, dur=0.3, end_dir=1 }, 
			{ event='talk', delay=0.9, handle_id=4, talk='！', dur=1,},

			{ event='move', delay= 1.5, handle_id= 4, dir=5, pos= {2165,2610},speed=240, dur=0.3, end_dir=6 }, 

			{ event='move', delay= 0.4, handle_id= 101, dir=3, pos= {2260,2510},speed=200, dur=0.3, end_dir=5 }, 
			{ event='move', delay= 0.4, handle_id= 102, dir=7, pos= {2291,2612},speed=200, dur=0.3, end_dir=6 }, 
			
			{ event='move', delay= 1.5, handle_id= 104, dir=2, pos= {2032,2606},speed=200, dur=0.3, end_dir=2 }, 
			{ event='move', delay= 1.5, handle_id= 103, dir=1, pos= {2065,2705},speed=200, dur=0.3, end_dir=1 }, 

			{ event='talk', delay=2, handle_id=103, talk='交出斩蛇剑！', dur=1.5,},
			{ event='talk', delay=2, handle_id=104, talk='交出斩蛇剑！', dur=1.5,},
			{ event='talk', delay=3.7, handle_id=4, talk='你们这些乱臣贼子，天理不容！', dur=2.5,},
			{ event='talk', delay=6.4, handle_id=4, talk='我刘氏子孙是不会放过你们的！', dur=2.5,},

	    },

    },

    ['juqing-ix030'] = 
	{
		--演员表 1 王莽  2 王匡 3 王寻 4 汉平帝刘衎  5 斩蛇剑 101-104 护卫军 
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 3142,my = 2250 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={3291,2245}, dir=5, speed=340, name_color=0xffffff, name="王莽"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=55, pos={3313,2191}, dir=5, speed=340, name_color=0xffffff, name="王匡"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={3386,2245}, dir=5, speed=340, name_color=0xffffff, name="王寻"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=24, pos={3159,2390}, dir=1, speed=340, name_color=0xffffff, name="汉平帝刘衎"},
	    	{ event = 'playAction', delay = 0.2,handle_id= 4, action_id = 4, dur = 1, dir = 7,loop = false,once =true},
	    	{ event='effect', handle_id=5,  delay = 0.1 , pos={3291,2340}, effect_id=20020, is_forever = true},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={3010-50,2306+50}, dir=2, speed=340, name_color=0xffffff, name="护卫军"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={2979-50,2420+50}, dir=2, speed=340, name_color=0xffffff, name="护卫军"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=27, pos={3044-50,2523+50}, dir=1, speed=340, name_color=0xffffff, name="护卫军"},
	    	{ event='createActor', delay=0.1, handle_id = 104, body=27, pos={3195-50,2553}, dir=1, speed=340, name_color=0xffffff, name="护卫军"},

	    },
        --开始BB
        {
			
			{ event='move', delay= 0.2, handle_id= 1, dir=5, pos= {3325,2299},speed=300, dur=0.3, end_dir=5 }, 
	   		{ event = 'talk', delay= 0.3, handle_id = 1, talk='这就是斩蛇剑？！', dur=1.5,},

	   		{ event='move', delay= 1.8, handle_id= 2, dir=3, pos= {3229,2238},speed=300, dur=0.3, end_dir=3 }, 
	   		{ event = 'talk', delay= 2, handle_id = 2, talk='恭祝大司马取得斩蛇剑！', dur=2,},

	   		--{ event='move', delay= 0.2, handle_id= 3, dir=5, pos= {3386,2245},speed=200, dur=0.3, end_dir=5 }, 
	   		{ event = 'talk', delay= 4.3, handle_id = 3, talk='别大司马了，是我们新朝皇帝！', dur=1.5,},
		},

		 {
			
	    	{ event='talk', delay=0.5, handle_id=4, talk='苍天啊，高祖啊！', dur=1.5,},
	    	{ event = 'playAction', delay = 2,handle_id= 4, action_id = 0, dur = 1, dir = 1,loop = true,once =false},

	    	--{ event = 'playAction', delay = 1.6,handle_id= 101, action_id = 2, dur = 1, dir = 2,loop = false,once =true},
			--{ event = 'playAction', delay = 1.6,handle_id= 102, action_id = 2, dur = 1, dir = 2,loop = false,once =true},
			--{ event = 'playAction', delay = 1.6,handle_id= 103, action_id = 2, dur = 1, dir = 1,loop = false,once =true},
			--{ event = 'playAction', delay = 1.6,handle_id= 104, action_id = 2, dur = 1, dir = 1,loop = false,once =true},

	    	{ event='talk', delay=2.2, handle_id=4, talk='大汉江山就要败于我手了！', dur=2.3,},

	    	{ event='talk', delay=4.9, handle_id=1, talk='汉室已经名存实亡了！', dur=1.7,},

	    	{ event='talk', delay=6.8, handle_id=1, talk='哈哈！撤军，还朝！', dur=1.5,},


		},

	},

	--============================================hanbaobao  每日剧情15 end  =====================================----
	--================================================luozhenhuai	每日剧情16	start    =========================================
	['juqing-ix031'] =
	{   ---演员  1丽华 2刘秀 3邓禹 4追兵1 5追兵2 6追兵首领 7邓禹
 		--剧情1 创建角色
 		{
 			{ event='init_cimera', delay = 0.2,mx= 2060,my = 206 },
 			{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1870,816}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
 			{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={1902,844}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
 			{ event='createActor', delay=0.1, handle_id = 3, body=1, pos={790,2460}, dir=7, speed=340, name_color=0xffffff, name="邓禹"},
 			{ event='createActor', delay=0.1, handle_id = 4, body=58, pos={1996,330}, dir=5, speed=340, name_color=0xffffff, name="追兵"},
 			{ event='createActor', delay=0.1, handle_id = 5, body=58, pos={2160,398}, dir=5, speed=340, name_color=0xffffff, name="追兵"},
 			{ event='createActor', delay=0.1, handle_id = 6, body=59, pos={2126,300}, dir=5, speed=340, name_color=0xffffff, name="追兵首领"},
		},
		--追兵与丽华刘秀
		{
			{ event='talk', delay=0.2, handle_id=4, talk='刘秀跑啦！快追啊！', dur=2,},	
			{ event='talk', delay=2.3, handle_id=5, talk='就在前面，他们跑不远的。 ', dur=2,},	
			{ event='talk', delay=4.4, handle_id=6, talk='快追，抓住刘秀，重重有赏！', dur=1,},
			{ event='talk', delay=5.4, handle_id=6, talk='放跑了刘秀，都要受罚。', dur=1,},
			{ event='move', delay=6, handle_id= 4, dir=5, pos= {1838,494},speed=300, dur=2, end_dir=5 },--追兵1
			{ event='move', delay=6, handle_id= 5, dir=5, pos= {1966,590},speed=300, dur=2, end_dir=5 }, --追兵2
			{ event='move', delay=6, handle_id= 6, dir=3, pos= {1966,462},speed=300, dur=2, end_dir=5 }, --追兵首领
			{ event='kill', delay=7.1, handle_id=5}, 
			{ event='init_cimera', delay = 7,mx= 1896,my = 810 },
			{ event='move', delay=8.1, handle_id= 1, dir=1, pos= {1870,816},speed=300, dur=1, end_dir=1 }, --丽华回头
			{ event='move', delay=8.1, handle_id= 2, dir=1, pos= {1902,844},speed=300, dur=1, end_dir=1 }, --刘秀回头
			{ event = 'camera', delay = 9, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1774,908 } },--移动镜头
			{ event='move', delay=9, handle_id= 1, dir=1, pos= {1740,938},speed=300, dur=2, end_dir=5 }, --丽华跑
			{ event='move', delay=9, handle_id= 2, dir=1, pos= {1774,972},speed=300, dur=2, end_dir=5 }, --刘秀跑
			{ event='talk', delay=9, handle_id=2, talk='丽华，走啊……他们主要是想抓住我，你快走啊！', dur=2,},	
			{ event='talk', delay=11.2, handle_id=1, talk='三哥，快走！我来拖住他们。', dur=2,},	
		},
		--剧情2	
		{	---消去剧情1角色
			{ event='kill', delay=0.2, handle_id=1}, 
			{ event='kill', delay=0.2, handle_id=2},
			{ event='kill', delay=0.2, handle_id=3}, 
			{ event='kill', delay=0.2, handle_id=4},
			{ event='kill', delay=0.2, handle_id=6},
		},
		{
			{ event='init_cimera', delay = 0.2,mx= 1518,my = 934 },
 			{ event='createActor', delay=0.2, handle_id = 1, body=5, pos={1490,976}, dir=5, speed=340, name_color=0xffffff, name="丽华"},
 			{ event='createActor', delay=0.2, handle_id = 2, body=12, pos={1422,1004}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
		},
		{
		--丽华与刘秀bb
			{ event='talk', delay=0.2, handle_id=1, talk='你快走啊！', dur=1.2,},		
			{ event='talk', delay=1.4, handle_id=2, talk='丽华，我怎能抛下你呢？我们一起走！', dur=2,},	
			{ event='talk', delay=3.4, handle_id=1, talk='你走啊！要不然我们都走不了的。', dur=2,},	
			{ event='talk', delay=5.4, handle_id=2, talk='丽华，你多加小心啊!', dur=2,},	
			{ event='move', delay=7.1, handle_id= 1, dir=7, pos= {1490,976},speed=300, dur=1, end_dir=7 }, --丽华目送
			{ event='move', delay=7.1, handle_id= 2, dir=7, pos= {1200,744},speed=300, dur=2, end_dir=7 }, --刘秀离开
			{ event='kill', delay=9.1, handle_id=2},
			{ event='createActor', delay=9.1, handle_id = 7, body=1, pos={1160,714}, dir=3, speed=340, name_color=0xffffff, name="邓禹"},
			{ event='move', delay=11.2, handle_id= 7, dir=3, pos= {1422,1004},speed=300, dur=4, end_dir=1 }, --邓禹进入
			{ event='talk', delay=13, handle_id=7, talk='丽华，丽华！', dur=1,},	
			{ event='move', delay=13, handle_id= 1, dir=5, pos= {1490,976},speed=300, dur=1, end_dir=5 },
			{ event='talk', delay=14, handle_id=1, talk='阿禹，你怎么来了？你不是在南阳嘛？', dur=2,},	
			{ event='talk', delay=0.2, handle_id=7, talk='我是专门来寻你的啊。你有我在，别怕，我不会让他们伤到你的。', dur=2,},	
		},
		{
			{ event='move', delay=0.2, handle_id= 1, dir=3, pos= {1490,976},speed=300, dur=1, end_dir=3 }, ---转过头
			{ event='move', delay=0.2, handle_id= 7, dir=3, pos= {1422,1004},speed=300, dur=1, end_dir=3 },---转过头
 			{ event='createActor', delay=0.2, handle_id = 4, body=58, pos={1740,1174}, dir=5, speed=340, name_color=0xffffff, name="追兵"},
 			{ event='createActor', delay=0.2, handle_id = 5, body=58, pos={1648,1266}, dir=1, speed=340, name_color=0xffffff, name="追兵"},
 			{ event='createActor', delay=0.2, handle_id = 6, body=59, pos={1744,1262}, dir=7, speed=340, name_color=0xffffff, name="追兵首领"},
			{ event = 'camera', delay = 0.8, dur=0.8,sdur = 0.5,target_id = 6 ,style = 'follow',backtime=1, },--挂镜头
			{ event='move', delay=1, handle_id= 4, dir=7, pos= {1584,1008},speed=300, dur=2, end_dir=7 }, --追兵1进入
			{ event='move', delay=1, handle_id= 5, dir=7, pos= {1458,1066},speed=300, dur=2, end_dir=7 }, ---追兵2进入
			{ event='move', delay=1, handle_id= 6, dir=7, pos= {1578,1100},speed=300, dur=2, end_dir=7 }, ---头领进入
		    { event = 'camera', delay = 1, dur=2,sdur = 0.5,style = '',backtime=1, c_topox = { 1520,1006 } },--移动镜头
			{ event='talk', delay=3, handle_id=4, talk='嘿，又来一个！那就一块捉住算了。', dur=1.5,},
			{ event='talk', delay=4.5, handle_id=5, talk='大人，我们怎么办？', dur=1,},	
			{ event='talk', delay=5.5, handle_id=6, talk='你们抓住他们两个。我去抓刘秀！', dur=2,},	
		},
	},
	['juqing-ix032'] =
	{
		--演员表 1丽华 2邓禹 3追兵1 4追兵2 5追兵头领
		{
 			{ event='init_cimera', delay = 0.2,mx= 716,my = 1422 },
 			{ event='createActor', delay=0.1, handle_id = 3, body=58, pos={750,1390}, dir=7, speed=340, name_color=0xffffff, name="追兵1"},
 			{ event='createActor', delay=0.1, handle_id = 4, body=58, pos={658,1486}, dir=7, speed=340, name_color=0xffffff, name="追兵2"},
 			{ event='createActor', delay=0.1, handle_id = 5, body=59, pos={748,1486}, dir=7, speed=340, name_color=0xffffff, name="追兵首领"},
		},
		{
			{ event='talk', delay=0.2, handle_id=3, talk='大人，他们都跑了！', dur=1.2,},		
			{ event='talk', delay=1.4, handle_id=4, talk='这可如何是好啊？大人，我们怎么办？', dur=2,},	
			{ event='talk', delay=3.4, handle_id=5, talk='真是晦气，让他们跑了！', dur=2,},	
			{ event='talk', delay=5.6, handle_id=5, talk='回去之后都给我闭嘴，知道吗？不然会受罚的。', dur=2,},	
		},
		{
			{ event='kill', delay=0.2, handle_id=3}, 
			{ event='kill', delay=0.2, handle_id=4},
			{ event='kill', delay=0.2, handle_id=5}, 
 			{ event='createActor', delay=0.2, handle_id = 1, body=5, pos={626,1006}, dir=3, speed=340, name_color=0xffffff, name="丽华"},
 			{ event='createActor', delay=0.2, handle_id = 2, body=1, pos={718,1038}, dir=7, speed=340, name_color=0xffffff, name="邓禹"},
		},
		{	
			{ event='init_cimera', delay = 0.2,mx= 622,my = 1006 },
			{ event='talk', delay=1, handle_id=1, talk='阿禹，你没事吧？多亏你来了，要不我自己还真没办法了。', dur=2,},		
			{ event='talk', delay=3.2, handle_id=2, talk='丽华，送给你！这个玉镯是我在外游学的时候，专门给你做的。', dur=2,},	
			{ event='talk', delay=5.6, handle_id=1, talk='阿禹你这是？我已经和三哥……我们之间已经不可能了。', dur=2,},	
			{ event='talk', delay=7.8, handle_id=2, talk='丽华你拿着吧，我并没有其他的意思。只想把这个送给你。', dur=2,},
		},
	},
	--============================================luozhenhuai  每日剧情16 end  =====================================----
	--============================================sunluyao	每日剧情17	start    =========================================
	['juqing-ix033'] =
	{
		{
 			{ event='init_cimera', delay = 0.2,mx= 740,my = 1400 },
 			{ event='createActor', delay=0.1, handle_id = 1, body=30, pos={930,1430}, dir=6, speed=340, name_color=0xffffff, name="阴识"},
 			{ event='createActor', delay=0.1, handle_id = 2, body=20, pos={365+100,1520-60}, dir=3, speed=340, name_color=0xffffff, name="阴兴"},
 			{ event='createActor', delay=0.1, handle_id = 3, body=6, pos={365,1520}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},

		},
		{
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={365+100,1520+60}, speed=280, dur=1.2 },
	    	{ event='move', delay= 0.3, handle_id=3, end_dir=5, pos={405+100,1460+60}, speed=280, dur=1.5 },
	   		{ event='talk', delay=0.2, handle_id=3, talk='[a]', dur=1.5, emote={a=16},  },

	    	{ event='move', delay= 1.5, handle_id=2, end_dir=3, pos={365,1520+120}, speed=280, dur=1.2 },
	    	{ event='move', delay= 2.3, handle_id=3, end_dir=5, pos={405,1460+120}, speed=280, dur=1.5 },
	   		{ event='talk', delay=2.5, handle_id=3, talk='[a]', dur=2, emote={a=16},  },

	    	{ event='move', delay= 3, handle_id=2, end_dir=1, pos={365+250,1520+120}, speed=280, dur=1 },
	    	{ event='move', delay= 4, handle_id=3, end_dir=1, pos={405+250,1460+120}, speed=280, dur=1 },	    	
		},
		{
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={930,1430}, speed=280, dur=1.2 },		
	   		{ event='talk', delay=0.5, handle_id=1, talk='丽华，兴儿，随我来！', dur=2.5 },

	    	{ event='move', delay= 1, handle_id=2, end_dir=1, pos={365+550,1520+20}, speed=280, dur=1 },
	    	{ event='move', delay= 1, handle_id=3, end_dir=1, pos={465+350,1460+20}, speed=280, dur=1 },

	   		{ event='talk', delay=4, handle_id=1, talk='今日乃是我们阴家先祖管仲的祭拜大礼。', dur=2.2  },
	   		{ event='talk', delay=6.5, handle_id=1, talk='你们不要再玩闹了，庄重一些！', dur=2.5  },
		},
		{
	   		{ event='talk', delay=0.1, handle_id=2, talk='好的，大哥！', dur=2.2  },
	   		{ event='talk', delay=2, handle_id=3, talk='知道了，大哥！', dur=2.5  },

 			{ event='createActor', delay=0.1, handle_id = 7, body=1, pos={1450,740}, dir=6, speed=340, name_color=0xffffff, name="邓禹"},--1200,1070
 			{ event='createActor', delay=0.1, handle_id = 8, body=23, pos={1450+100,740+60}, dir=3, speed=340, name_color=0xffffff, name="邓晨"},	 --1230,1040     		
		},
		{
 			{ event='init_cimera', delay = 0.1,mx= 1260,my = 880 },

	    	{ event='move', delay= 0.1, handle_id=7, end_dir=2, pos={965,1063}, speed=580, dur=1 },
	    	{ event='move', delay= 0.1, handle_id=8, end_dir=6, pos={1180,1070}, speed=580, dur=1 },

	   		{ event='talk', delay=0.5, handle_id=7, talk='表哥，我们快些走吧！', dur=1.8  },
	   		{ event='talk', delay=2.5, handle_id=7, talk='不要耽误了时辰。', dur=1.8  },
	   		{ event='talk', delay=4.5, handle_id=8, talk='禹儿，不要着急了！', dur=1.8  },
	   		{ event='talk', delay=6.5, handle_id=8, talk='现在时辰正好，到了阴家就能见到丽华啦！', dur=2.2  },

 			{ event='createActor', delay=0.1, handle_id = 4, body=54, pos={2076,2079}, dir=6, speed=340, name_color=0xffffff, name="盗贼头目"},
 			{ event='createActor', delay=0.1, handle_id = 5, body=31, pos={2076+20,2079+100}, dir=3, speed=340, name_color=0xffffff, name="盗贼"},
 			{ event='createActor', delay=0.1, handle_id = 6, body=31, pos={2076+100,2079-20}, dir=3, speed=340, name_color=0xffffff, name="盗贼"},		   		
		},		
		{
		
 			{ event='init_cimera', delay = 0.1,mx= 1600,my = 1850 },

	    	{ event='move', delay= 0.1, handle_id=4, end_dir=2, pos={1530,1890}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=6, pos={1630+20,1890+100}, speed=280, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=6, pos={1630+100,1890-20}, speed=280, dur=1.5 },
		},
		{
	   		{ event='talk', delay=0.1, handle_id=5, talk='大哥，阴家的情况都打探清楚了！', dur=2  },
	   		{ event='talk', delay=2.5, handle_id=5, talk='今日是阴家祭祖之日，人很多。', dur=2  },
	   		{ event='talk', delay=5, handle_id=4, talk='都给我精神点，今日事成之后，我们就算是发财啦。', dur=2.5  },
	   		{ event='talk', delay=8, handle_id=4, talk='谁要是拖后腿，看我回去怎么收拾你们！', dur=2  },
	   		{ event='talk', delay=10.5, handle_id=5, talk='知道了，大哥！', dur=2  },
	   		{ event='talk', delay=10.5, handle_id=6, talk='知道了，大哥！', dur=2  },
	    	{ event='move', delay= 12, handle_id=4, end_dir=6, pos={1530,1890}, speed=280, dur=1.5 },

	    	{ event='move', delay= 0.1, handle_id=7, end_dir=3, pos={1226,1056}, speed=580, dur=1 },
	    	{ event='move', delay= 0.1, handle_id=8, end_dir=3, pos={1169,1088}, speed=580, dur=1 },		
		},
		{
 			{ event='init_cimera', delay = 0.1,mx= 1260,my = 1040 },

	   		{ event='talk', delay=0.5, handle_id=7, talk='表哥，你看前面这群人鬼鬼祟祟的，肯定不是好人！', dur=2.5  },
	   		{ event='talk', delay=3.5, handle_id=7, talk='我们快去阴家报信吧!', dur=1.8  },
	   		{ event='talk', delay=5.5, handle_id=8, talk='嗯，快，去通知阴识！', dur=1.8  },	   				
		},
		{
 			{ event='init_cimera', delay = 0.2,mx= 940,my = 1300 },
	   		--{ event = 'camera', delay = 0.1, dur=1,sdur = 1,style = '',backtime=1, c_topox = {940,1300 } }, 

 			{ event='createActor', delay=0.1, handle_id = 11, body=1, pos={984,1350}, dir=5, speed=340, name_color=0xffffff, name="邓禹"},
 			{ event='createActor', delay=0.1, handle_id = 12, body=23, pos={840,1270}, dir=3, speed=340, name_color=0xffffff, name="邓晨"},	

	   		{ event='kill', delay=0.2, handle_id=7},
	    	{ event='kill', delay=0.2, handle_id=8},

	    	{ event='move', delay= 0.2, handle_id=1, end_dir=1, pos={930,1430}, speed=340, dur=1 },

	   		{ event='talk', delay=1.5, handle_id=11, talk='阴识兄，不好了！', dur=1.8  },
	   		{ event='talk', delay=3.5, handle_id=11, talk='外面来了一群歹人，好像是冲着阴家来的。!', dur=2.2  },

	    	{ event='move', delay= 5.5, handle_id=2, end_dir=1, pos={365+600,1520+20-50}, speed=340, dur=1 },	 

	   		{ event='talk', delay=6, handle_id=2, talk='什么，敢来我们阴家捣乱！', dur=2.2 },
	   		{ event='talk', delay=8.5, handle_id=3, talk='阿禹，你说什么？', dur=1.8  },

	    	{ event='move', delay= 10, handle_id=3, end_dir=3, pos={465+350+50,1460+20-50}, speed=580, dur=1 },

	    	{ event='move', delay= 10.3, handle_id=2, end_dir=7, pos={365+600,1520+20-50}, speed=340, dur=1 },	    		   		
	   		{ event='talk', delay=10.5, handle_id=3, talk='兴儿，走！我们去教训他们一下。', dur=1.8  },

	    	{ event='move', delay= 12.4, handle_id=2, end_dir=5, pos={365+600,1520+20-50}, speed=340, dur=1 },		   		
	   		{ event='talk', delay=12.5, handle_id=2, talk='来人啊！随我出庄。', dur=1.8  },
	    	{ event='move', delay= 12.4, handle_id=1, end_dir=5, pos={930,1430}, speed=340, dur=1 },	   		
		},
		{
 			{ event='createActor', delay=0.1, handle_id = 9, body=7, pos={678,1490}, dir=1, speed=340, name_color=0xffffff, name="阴家家丁"},
 			{ event='createActor', delay=0.1, handle_id = 10, body=7, pos={678+100,1490+60}, dir=1, speed=340, name_color=0xffffff, name="阴家家丁"},

	   		{ event='talk', delay=0.5, handle_id=9, talk='是，二公子！', dur=1.8  },
	   		{ event='talk', delay=2.5, handle_id=10, talk='走，去教训他们！', dur=1.8  },
		},
		{
 			{ event='init_cimera', delay = 0.1,mx= 1600,my = 1850 },

	   		{ event='talk', delay=0.1, handle_id=5, talk='大哥，阴家好像有所提防了啊！', dur=2  },
	   		{ event='talk', delay=2.5, handle_id=5, talk='大哥，我们怎么办？', dur=2  },
	   		{ event='talk', delay=5, handle_id=4, talk='不管了，富贵险中求！给我上！', dur=2.5  },
		},
	},


	['juqing-ix034'] =
	{
		{
 			{ event='init_cimera', delay = 0.2,mx= 1590,my = 1740 },		
 			{ event='createActor', delay=0.1, handle_id = 2, body=6, pos={1670,1898}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},
 			{ event='createActor', delay=0.1, handle_id = 1, body=20, pos={1670-100,1898+60}, dir=3, speed=340, name_color=0xffffff, name="阴兴"},
		},
		{
 			{ event='createActor', delay=1, handle_id = 3, body=30, pos={1360,1680}, dir=6, speed=340, name_color=0xffffff, name="阴识"},

	    	{ event='move', delay= 1.2, handle_id=3, end_dir=3, pos={1510+20,1815+20}, speed=340, dur=1 },	 			
	    	{ event='move', delay= 1.5, handle_id=2, end_dir=7, pos={1670,1898}, speed=340, dur=1 },	
	    	{ event='move', delay= 1.5, handle_id=1, end_dir=7, pos={1670-100,1898+60}, speed=340, dur=1 },	

		},
		{
	   		{ event='talk', delay=0.1, handle_id=2, talk='大哥，他们被打跑了！', dur=2  },
	   		{ event='talk', delay=2.3, handle_id=2, talk='怎么样，我和兴儿厉害吧！', dur=2  },
	   		{ event='talk', delay=4.5, handle_id=3, talk='真是一群不自量力的东西！', dur=2  },
	   		{ event='talk', delay=6.8, handle_id=3, talk='你们两个也是，不是有家丁嘛？', dur=2  },
	   		{ event='talk', delay=9, handle_id=3, talk='告诉你们庄重一点，还跑出去打打闹闹！', dur=2.2  },
	   		{ event='talk', delay=11.5, handle_id=1, talk='知道了，大哥！', dur=2  },	   			   		
		},
		{
 			{ event='createActor', delay=0.1, handle_id = 4, body=1, pos={1190,1600}, dir=5, speed=340, name_color=0xffffff, name="邓禹"},
 			{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={1190-100,1600+60}, dir=3, speed=340, name_color=0xffffff, name="邓晨"},	

	    	{ event='move', delay= 0.2, handle_id=4, end_dir=3, pos={1190+330,1600+150}, speed=340, dur=1 },	 			
	    	{ event='move', delay= 0.2, handle_id=5, end_dir=3, pos={1190+230,1600+210}, speed=340, dur=1 },	
		},
		{
	   		{ event='talk', delay=0.1, handle_id=4, talk='丽华，你没事吧？', dur=2  },
	   		{ event='talk', delay=2.3, handle_id=2, talk='我没事的，阿禹！', dur=2  },
	   		{ event='talk', delay=4.5, handle_id=2, talk='这次多亏了你来送信呢。', dur=2  },
	   		{ event='talk', delay=6.8, handle_id=5, talk='好啦，没事就好，没事就好！', dur=2  },

	    	{ event='move', delay= 8.8, handle_id=3, end_dir=7, pos={1510+20,1815+20}, speed=340, dur=1 },	
	   		{ event='talk', delay=9, handle_id=3, talk='好啦，不要在外面客套了。', dur=2  },
	   		{ event='talk', delay=11.2, handle_id=3, talk='随我进庄！', dur=1.5  },
		},
		{
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={888,1590}, speed=340, dur=1 },	 			
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={888,1590}, speed=340, dur=1 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=7, pos={888,1590}, speed=340, dur=1 },	 			
	    	{ event='move', delay= 2, handle_id=4, end_dir=7, pos={888,1590}, speed=340, dur=1 },
	    	{ event='move', delay= 2, handle_id=5, end_dir=7, pos={888,1590}, speed=340, dur=1 },	 			
		},


	},

	--============================================sunluyao  每日剧情17  end      =========================================
	
	
    --============================================wuwenbin  每日剧情18 start  =====================================----
   	['juqing-ix035'] = 
	{
		--演员表 1 丽华  2 刘秀 3 严子陵 4 亲军将领 5 杀手头目 101-108 亲军  201-204 杀手
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1256,my = 800 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={1268,842}, dir=5, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={1202,878}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=43, pos={1294,944}, dir=7, speed=340, name_color=0xffffff, name="亲军将领"},

	   		
	   		{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={1330,1002}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={1390,972}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={1330+64,1002+64}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1390+64,972+64}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=25, pos={1330+128,1002+128}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=25, pos={1390+128,972+128}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 107, body=25, pos={1330+192,1002+192}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 108, body=25, pos={1390+192,972+192}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	    },

	    --刺客带上刘玄见首领
	    {	
	    	-- { event='move', delay= 0.2, handle_id=1, end_dir=3, pos={3442,1196}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=201, end_dir=3, pos={3500,1166}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },

	    	-- { event='move', delay= 0.2, handle_id=1, end_dir=3, pos={3442,1196}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=201, end_dir=3, pos={3500,1166}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=1, end_dir=3, pos={3442,1196}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=201, end_dir=3, pos={3500,1166}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=201, end_dir=3, pos={3500,1166}, speed=280, dur=1.5 },
	    	-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },


	   		{ event='talk', delay=0.5, handle_id=1, talk='听闻子陵就隐居在这附近，果然是他的作风啊！', dur=2.5 },
	   		{ event='talk', delay=3.3, handle_id=1, talk='就是躲起来，也要选个这么景色宜人的地方。', dur=2.5  },
	   		{ event='talk', delay=6.1, handle_id=2, talk='想不到他还是当年的性情，一点没变啊！', dur=2.5  },

	   		{ event='move', delay= 8.9, handle_id=1, end_dir=3, pos={1268,842}, speed=280, dur=1.5 },
	   		{ event='move', delay= 8.9, handle_id=2, end_dir=3, pos={1202,878}, speed=280, dur=1.5 },
	   		{ event='talk', delay=8.9, handle_id=2, talk='你们不用跟着了，在附近守卫即可。', dur=2  },
	   		{ event='talk', delay=11.2, handle_id=4, talk='喏！', dur=1.5  },

	   		{ event='move', delay= 13, handle_id=1, end_dir=3, pos={590,1104}, speed=280, dur=1.5 },
	    	{ event='move', delay= 13, handle_id=2, end_dir=3, pos={590,1104}, speed=280, dur=1.5 },
	   	},
	   	{
	   		{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1290,903 } },
	   		{ event='move', delay= 0.1, handle_id=4, end_dir=3, pos={1294,944}, speed=280, dur=1.5 },
	   		{ event='talk', delay=0.1, handle_id=4, talk='来人，出去打探一下附近的情况。', dur=2  },
	   		{ event='talk', delay=2.5, handle_id=4, talk='剩下的原地戒备，保护陛下与皇后的安全。', dur=2.5  },
	   		-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },


	   		{ event='talk', delay= 5.3, handle_id=101, talk='领命，我们走！', dur=2  },
	   		{ event='move', delay= 7.6, handle_id=4, end_dir=1, pos={1048,922}, speed=280, dur=1.5 },
	   		{ event='move', delay= 7.6, handle_id=101, end_dir=1, pos={970,874}, speed=280, dur=3 },
	    	{ event='move', delay= 7.6, handle_id=102, end_dir=1, pos={1102,986}, speed=280, dur=3 },

	    	{ event='move', delay= 7.6, handle_id=103, end_dir=3, pos={1938,786}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.6, handle_id=104, end_dir=3, pos={1938,786}, speed=280, dur=1.5 },

	    	{ event='move', delay= 7.6, handle_id=105, end_dir=3, pos={1882,1524}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.6, handle_id=106, end_dir=3, pos={1934,1480}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.6, handle_id=107, end_dir=3, pos={1882,1524}, speed=280, dur=1.5 },
	    	{ event='move', delay= 7.6, handle_id=108, end_dir=3, pos={1934,1480}, speed=280, dur=1.5 },


	   		{ event='kill', delay=11, handle_id=1},
	    	{ event='kill', delay=11, handle_id=2},
	    	{ event='kill', delay=11, handle_id=4},

	    	{ event='kill', delay=11, handle_id=101},
	    	{ event='kill', delay=11, handle_id=102},
	    	{ event='kill', delay=11, handle_id=103},
	    	{ event='kill', delay=11, handle_id=104},
	    	{ event='kill', delay=11, handle_id=105},
	    	{ event='kill', delay=11, handle_id=106},
	    	{ event='kill', delay=11, handle_id=107},
	    	{ event='kill', delay=11, handle_id=108},
	   	},

	   	--镜头移至杀手处
	   	{
	   		{ event='createActor', delay=0.1, handle_id = 5, body=22, pos={1000,1900}, dir=7, speed=340, name_color=0xffffff, name="杀手头目"},

	   		{ event='createActor', delay=0.1, handle_id = 201, body=32, pos={842,1678}, dir=3, speed=340, name_color=0xffffff, name="杀手"},
	   		{ event='createActor', delay=0.1, handle_id = 203, body=32, pos={980,2004}, dir=7, speed=340, name_color=0xffffff, name="杀手"},
	   		{ event='createActor', delay=0.1, handle_id = 204, body=32, pos={980+64,2004-32}, dir=7, speed=340, name_color=0xffffff, name="杀手"},
	   		{ event='createActor', delay=0.1, handle_id = 205, body=32, pos={980+128,2004-64}, dir=7, speed=340, name_color=0xffffff, name="杀手"},
	   	},
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 966,my = 1844 },
	   		{ event='move', delay= 0.1, handle_id=201, end_dir=3, pos={942,1854}, speed=280, dur=1.5 },
	    	{ event='talk', delay=0.8, handle_id=201, talk='首领，前面的兄弟传来消息，大鱼来了！', dur=2.5 },
	   		{ event='talk', delay=3.5, handle_id=5, talk='这次机不可失，你们给我打起精神来！', dur=2.5  },
	   		{ event='talk', delay=6.3, handle_id=5, talk='错过了，你我都将会被幕后的雇主清理掉。', dur=2.5  },
	   		{ event='talk', delay=9.2, handle_id=201, talk='是，首领！', dur=2  },


	   		{ event='kill', delay=12, handle_id=5},
	   		{ event='kill', delay=12, handle_id=201},
	    	{ event='kill', delay=12, handle_id=202},
	    	{ event='kill', delay=12, handle_id=203},
	    	{ event='kill', delay=12, handle_id=204},
	    },


	    --刘秀，丽华见严子陵
	    {	
	    	{ event='init_cimera', delay = 0.1,mx= 100,my = 900 },
	    	
	    	--禁卫
	    	{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={408,1000}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={338,1024}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=19, pos={302,930}, dir=3, speed=340, name_color=0xffffff, name="严子陵"},

	   		{ event='talk', delay=0.5, handle_id=3, talk='草民严子陵拜见皇帝陛下，皇后娘娘。', dur=2.5  },
	   		{ event='talk', delay=3.3, handle_id=2, talk='无需多礼，昔日同窗之情，你相助我甚多。', dur=2.5  },

	   		{ event='talk', delay=6.1, handle_id=1, talk='没看出来啊，你严子陵也变成这么迂腐之人了。', dur=2.5  },
	   		{ event='talk', delay=8.9, handle_id=3, talk='不知陛下前来所为何事？', dur=2  },
	   		{ event='talk', delay=11.2, handle_id=2, talk='如今天下初定，各种事务繁琐，我想请子陵来相助与我。', dur=2.5  },

	   		{ event='talk', delay=14, handle_id=3, talk='这，恐怕要让陛下失望了。', dur=2  },
	   		{ event='talk', delay=16.3, handle_id=3, talk='严某无心朝堂政事，只想做一只闲云野鹤。', dur=2.5  },

	   		{ event='move', delay= 19.1, handle_id=1, end_dir=5, pos={408,1000}, speed=280, dur=1.5 },
	   		{ event='talk', delay=19.1, handle_id=1, talk='三哥，子陵，附近好像有人！', dur=2  },

	   		{ event='move', delay= 21.4, handle_id=2, end_dir=3, pos={338,1024}, speed=280, dur=1.5 },
	   		{ event='talk', delay=21.4, handle_id=2, talk='何人？如此大胆！', dur=2  },
	   	},

	   	--杀手出现
	   	{
	   		{ event='createActor', delay=0.1, handle_id = 5, body=22, pos={630+64,1284+64},dir=7, speed=340, name_color=0xffffff, name="杀手头目"},
	   		{ event='createActor', delay=0.1, handle_id = 201, body=32, pos={562+64,1376+64}, dir=7, speed=340, name_color=0xffffff, name="杀手"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=32, pos={630+64,1350+64}, dir=7, speed=340, name_color=0xffffff, name="杀手"},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=32, pos={692+64,1314+64}, dir=7, speed=340, name_color=0xffffff, name="杀手"},
	    	{ event='createActor', delay=0.1, handle_id = 204, body=32, pos={760+64,1282+64}, dir=7, speed=340, name_color=0xffffff, name="杀手"},


	   		{ event='move', delay= 0.2, handle_id=5, end_dir=7, pos= {630,1284}, speed=280, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=201, end_dir=7, pos= {562,1376},speed=280, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=202, end_dir=7, pos= {630,1350},speed=280, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=203, end_dir=7, pos= {692,1314},speed=280, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=204, end_dir=7, pos= {760,1282},speed=280, dur=1.5 },

	   		{ event='move', delay= 0.8, handle_id=1, end_dir=3, pos={408,1000}, speed=280, dur=1.5 },

	   		{ event='jump', delay=0.8, handle_id=5, dir=7, pos={428+32,1094+32}, speed=120, dur=1, end_dir=7 }, -- 通过

	   		{ event='jump', delay=0.8, handle_id=201, dir=6, pos={248-32,1082}, speed=120, dur=1, end_dir=1 }, -- 通过
	   		{ event='jump', delay=0.8, handle_id=202, dir=6, pos={316-32,1132}, speed=120, dur=1, end_dir=1 }, -- 通过

	   		{ event='jump', delay=0.8, handle_id=203, dir=6, pos={538,958}, speed=120, dur=1, end_dir=5 }, -- 通过
	   		{ event='jump', delay=0.8, handle_id=204, dir=6, pos={566,1028}, speed=120, dur=1, end_dir=5 }, -- 通过


	   		{ event='talk', delay=1.5, handle_id=5, talk='给我杀了他们，重重有赏！', dur=2.5  },
	   		-- { event='talk', delay=18.5, handle_id=3, talk='上，杀了他们！', dur=2.5  },
	   	},

    },

    ['juqing-ix036'] = 
	{
		--演员表 1 刘玄 2 刺客首领 3 守卫将领 101-104 巡城守卫 201-202 刺客

	 	--创建角色
	    {
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=4, pos={408,1000}, dir=3, speed=340, name_color=0xffffff, name="丽华"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={338,1024}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=19, pos={302,930}, dir=3, speed=340, name_color=0xffffff, name="严子陵"},
	    	-- { event='createActor', delay=0.1, handle_id = 202, body=22, pos= {2804,536},dir=1, speed=340, name_color=0xffffff, name="刺客"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=43, pos={468,1104}, dir=7, speed=340, name_color=0xffffff, name="亲军将领"},
	   		{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={464,1166}, dir=7, speed=340, name_color=0xffffff, name="亲军"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={524,1136}, dir=7, speed=340, name_color=0xffffff, name="亲军"},

	    	{ event='createActor', delay=0.1, handle_id = 5, body=22, pos={230,1166}, dir=7, speed=340, name_color=0xffffff, name="杀手头目"},
	   		{ event='createActor', delay=0.1, handle_id = 201, body=32, pos={248-32,1082}, dir=1, speed=340, name_color=0xffffff, name="杀手"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=32, pos={316-32,1132}, dir=1, speed=340, name_color=0xffffff, name="杀手"},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=32, pos={538,958}, dir=5, speed=340, name_color=0xffffff, name="杀手"},
	    	{ event='createActor', delay=0.1, handle_id = 204, body=32, pos={566,1028}, dir=5, speed=340, name_color=0xffffff, name="杀手"},

	    	{ event='playAction', delay = 0.2, handle_id=5, action_id=4, dur=0.2, dir=7, loop=false, once = true},
	    	{ event='playAction', delay = 0.2, handle_id=201, action_id=4, dur=0.2, dir=1, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=202, action_id=4, dur=0.2, dir=3, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=203, action_id=4, dur=0.2, dir=5, loop=false ,once = true},
	    	{ event='playAction', delay = 0.2, handle_id=204, action_id=4, dur=0.2, dir=6, loop=false ,once = true},
	    },

	    --将领请罪
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 424,my = 950},
	    	-- { event='move', delay= 0.1, handle_id= 201, dir=1, pos= {3442,1196},speed=240, dur=0.3, end_dir=3 }, 
	    	-- { event='move', delay= 0.1, handle_id= 201, dir=1, pos= {3442,1196},speed=240, dur=0.3, end_dir=3 }, 
	    	-- { event='move', delay= 0.1, handle_id= 201, dir=1, pos= {3442,1196},speed=240, dur=0.3, end_dir=3 }, 
	    	-- { event='move', delay= 0.1, handle_id= 201, dir=1, pos= {3442,1196},speed=240, dur=0.3, end_dir=3 }, 
	    	-- { event='move', delay= 0.1, handle_id= 201, dir=1, pos= {3442,1196},speed=240, dur=0.3, end_dir=3 }, 

	    	{ event='talk', delay=0.1, handle_id=4, talk='属下救驾来迟，请陛下降罪！', dur=2.5},
	    	{ event='talk', delay=2.9, handle_id=2, talk='无碍，这样的杀手奈何不了朕.', dur=2.5},
	    },

	    --严子陵解释
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 100,900 } },
	    	{ event='move', delay= 0.5, handle_id= 1, dir=1, pos= {408,1000},speed=340, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.5, handle_id= 2, dir=1, pos= {338,1024},speed=340, dur=0.3, end_dir=7 }, 

	    	{ event='talk', delay=0.5, handle_id=3, talk='陛下看，你觉得江山都是你的。', dur=2.5},
	    	{ event='talk', delay=3.3, handle_id=3, talk='但是有人可不这么认为，朝堂之上勾心斗角，', dur=3},
	    	{ event='talk', delay=6.6, handle_id=3, talk='可不是我严子陵想要的。', dur=2.5},
	    	{ event='talk', delay=9.4, handle_id=3, talk='我想看到的，只有你达成当年的志愿。', dur=2.5},

	    	{ event='talk', delay=12.2, handle_id=2, talk='当年的愿望必定要实现。', dur=2.5},
	    	{ event='talk', delay=15.1, handle_id=2, talk='但是我现在急需你来助我一臂之力！', dur=2.5},
	    },

	    --丽华劝解刘秀
	    {
	    	{ event='talk', delay=0.5, handle_id=1, talk='唉，严子陵，你还是如当年一般随性啊。', dur=2.5},

	    	{ event='move', delay= 3.3, handle_id= 1, dir=5, pos= {408,1000},speed=340, dur=0.3, end_dir=5 }, 
	    	{ event='talk', delay=3.3, handle_id=1, talk='三哥，算了吧，人各有志，强求也是没用的。', dur=2.5},

	    	{ event='move', delay= 6.1, handle_id= 1, dir=5, pos= {408,1000},speed=340, dur=0.3, end_dir=7 }, 
	    	{ event='talk', delay=6.1, handle_id=2, talk='罢了，罢了，子陵还望珍重。', dur=2.5},
	    	{ event='talk', delay=8.8, handle_id=2, talk='我们后会有期！', dur=2.5},

	    	
	    	{ event='talk', delay=11.6, handle_id=3, talk='严子陵恭送皇帝陛下、皇后娘娘。', dur=2.5},
	    },
	},

	--============================================wuwenbin  每日剧情18 end  =====================================----

    --============================================wuwenbin  每日剧情19 start  =====================================----
   	['juqing-ix037'] = 
	{
		--演员表 1 丽华  2 刘秀 3 冯异 4 丁柔 5 亲军将领 101-105 更始追兵 
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 684,my = 300 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={650,341}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=34, pos={717,367}, dir=7, speed=340, name_color=0xffffff, name="冯异"},
	    },

	    --刘秀在长安城外踌躇不定
	    {	

	   		-- { event='move', delay= 8.9, handle_id=2, end_dir=3, pos={1202,878}, speed=280, dur=1.5 },

	   		{ event='talk', delay=0.1, handle_id=3, talk='刘将军，走吧！', dur=2  },
	   		{ event='talk', delay=2.9, handle_id=3, talk='迟则生变，别再节外生枝了。', dur=2.5  },

	   		{ event='move', delay= 6.2, handle_id=2, end_dir=3, pos={650,341}, speed=280, dur=1.5 },

	   		{ event='talk', delay=6.4, handle_id=2, talk='我实在是放心不下丽华和伯姬啊！[a]', dur=2.5 ,emote= { a= 28} },
	   		{ event='talk', delay=9.2, handle_id=2, talk='不知道刘玄会如何对待他们。', dur=2.5  },

	   		{ event='talk', delay=12, handle_id=3, talk='阴姑娘聪明机敏应该不会有事的。', dur=2.5  },
	   		{ event='talk', delay=14.8, handle_id=3, talk='伯姬妹妹有李通的照应也大可放心。', dur=2.5  },
	   		{ event='talk', delay=17.6, handle_id=3, talk='而且我也已经叮嘱了丁柔照顾她们了。', dur=2.5  },

	   		{ event='talk', delay=20.4, handle_id=2, talk='那就有劳冯将军了！', dur=2  },
	   		{ event='talk', delay=22.7, handle_id=2, talk='我们走！', dur=1.5  },

	   		{ event='move', delay= 24.5, handle_id=2, end_dir=3, pos={1745,689}, speed=280, dur=3.5 },
	   		{ event='move', delay= 24.5, handle_id=3, end_dir=3, pos={1745,689}, speed=280, dur=3.5 },

	   		{ event='kill', delay=28, handle_id=2},  -- 消除实体通过
	   		{ event='kill', delay=28, handle_id=3},  -- 消除实体通过
	   	},

	   	--丽华和丁柔逃出城外
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 849,my = 300 },

	   		{ event='createActor', delay=0.15, handle_id = 1, body=6, pos={495,307}, dir=3, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.15, handle_id = 4, body=42, pos={562,273}, dir=3, speed=340, name_color=0xffffff, name="丁柔"},
	   		-- { event='move', delay= 0.2, handle_id=202, end_dir=3, pos={3382,1232}, speed=280, dur=1.5 },

	   		{ event='move', delay= 0.2, handle_id=1, end_dir=1, pos={817,369}, speed=280, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=4, end_dir=5, pos={882,339}, speed=280, dur=1.5 },

	   		{ event='talk', delay=1, handle_id=4, talk='姑娘，你快走！', dur=2  },
	   		{ event='talk', delay=3.3, handle_id=4, talk='后面的人追上来了。', dur=2.5  },
	   		{ event='talk', delay=6.1, handle_id=1, talk='走，我们一起跑！', dur=2.5  },
	   		{ event='talk', delay=8.9, handle_id=1, talk='一起去找三哥和冯大哥。', dur=2.5  },

	   		{ event='move', delay= 11.7, handle_id=1, end_dir=3, pos={1546,778}, speed=280, dur=3.3 },
	   		{ event='move', delay= 11.7, handle_id=4, end_dir=3, pos={1621,759}, speed=280, dur=3.3 },

	   		{ event='kill', delay=15, handle_id=1},  -- 消除实体通过
	   		{ event='kill', delay=15, handle_id=4},  -- 消除实体通过
	   	},

	   	--更始追兵出现
	   	{
	   		{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={560,266}, dir=3, speed=340, name_color=0xffffff, name="更始追兵"},
	   		{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={627,309}, dir=3, speed=340, name_color=0xffffff, name="更始追兵"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=27, pos={630,235}, dir=3, speed=340, name_color=0xffffff, name="更始追兵"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=27, pos={685,274}, dir=3, speed=340, name_color=0xffffff, name="更始追兵"},


	   		{ event='move', delay= 0.2, handle_id=101, end_dir=3, pos={1615,755}, speed=300, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=102, end_dir=3, pos={1615,755}, speed=300, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=103, end_dir=3, pos={1687,718}, speed=300, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=104, end_dir=3, pos={1687,718}, speed=300, dur=1.5 },


	    	{ event='talk', delay=0.2, handle_id=101, talk='快追啊！别让他们跑了！', dur=4 },
	   		{ event='talk', delay=0.2, handle_id=104, talk='抓住前面那两个女的！快！', dur=4  },

	   		{ event='kill', delay=5, handle_id=1},  -- 消除实体通过
	   		{ event='kill', delay=5, handle_id=1},  -- 消除实体通过
	   	},

    },

    ['juqing-ix038'] = 
	{
		--演员表 1 刘玄 2 刺客首领 3 守卫将领 101-104 巡城守卫 201-202 刺客

	 	--创建角色
	    {
	   		{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={620,1112}, dir=5, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=34, pos={563,1074}, dir=5, speed=340, name_color=0xffffff, name="冯异"},
	    	
	    },

	    --刘秀冯异继续跑
	    {
	    	{ event='init_cimera', delay = 0.1,mx= 390,my = 1150},
	    	{ event='move', delay= 0.1, handle_id= 2, dir=1, pos= {467,1265},speed=340, dur=0.5, end_dir=1 }, 
	    	{ event='move', delay= 0.1, handle_id= 3, dir=1, pos= {397,1234},speed=340, dur=0.5, end_dir=1 }, 

	    	{ event='createActor', delay=0.5, handle_id = 4, body=42, pos={786,912}, dir=7, speed=340, name_color=0xffffff, name="丁柔"},
	    	{ event='move', delay= 0.8, handle_id= 4, dir=5, pos= {464,1169},speed=340, dur=0.3, end_dir=5 }, 

	    	{ event='talk', delay=0.8, handle_id=4, talk='公孙——', dur=2.5},
	    },

	    --丁柔先跑到刘秀冯异处
	    {
	    	{ event='talk', delay=0.1, handle_id=3, talk='柔儿，你怎么跑来了啊？', dur=2.5},
	    	{ event='talk', delay=2.9, handle_id=3, talk='不是让你照顾阴姑娘嘛？', dur=3},
	    	{ event='talk', delay=6.2, handle_id=4, talk='我……我们逃出来了！', dur=2.5},
	    	{ event='talk', delay=9, handle_id=4, talk='你们带阴姑娘走吧。', dur=2.5},

	    	{ event='talk', delay=11.7, handle_id=2, talk='什么？你们逃出来了？', dur=2.5},
	    	{ event='talk', delay=14.5, handle_id=2, talk='丽华呢，丽华她没事吧？', dur=2.5},
	    },

	    --丽华劝解刘秀
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1050,828}, dir=3, speed=340, name_color=0xffffff, name="丽华"},

	    	{ event='move', delay= 0.2, handle_id= 1, dir=5, pos= {528,1198},speed=340, dur=0.3, end_dir=5 }, 
	    	{ event='talk', delay=0.2, handle_id=1, talk='呼呼…三哥…我在这里！', dur=3},
	    	{ event='talk', delay=3.5, handle_id=1, talk='我没事，你们才走到这里啊？', dur=2.5},
	    	{ event='talk', delay=6.3, handle_id=1, talk='我以为追不上你们了。', dur=2.5},
	    	
	    	{ event='talk', delay=9.1, handle_id=2, talk='真是太好了！', dur=2.5},
	    	{ event='talk', delay=11.9, handle_id=2, talk='走，我们一同去河北。', dur=2.5},
	    },
	},

	--============================================wuwenbin  每日剧情19 end  =====================================----

	--============================================luyao  每日剧情20 start  =====================================----
	['juqing-ix039'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 522,my = 1700 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={522,1800}, dir=5, speed=340, name_color=0xffffff, name="王莽"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=34, pos={669,1800}, dir=6, speed=340, name_color=0xffffff, name="王莽使臣"},

	   		{ event='createActor', delay=0.1, handle_id = 101, body=58, pos={546,1571}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=58, pos={300,1630}, dir=3, speed=340, name_color=0xffffff, name="新军禁卫"},

	   		{ event='createActor', delay=0.1, handle_id = 103, body=57, pos={1000,1800}, dir=7, speed=340, name_color=0xffffff, name="随从"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=57, pos={774,1996}, dir=7, speed=340, name_color=0xffffff, name="随从"},
		},
		{
	   		{ event='talk', delay=1.5, handle_id=1, talk='如今众人皆不服从新朝的统治，都要造反！', dur=2.5 },
	   		{ event='talk', delay=4.3, handle_id=1, talk='听说还有什么流传来的箴机能预言下一个皇帝？', dur=2.5  },
	   		{ event='talk', delay=7.1, handle_id=1, talk='真是无稽之谈！', dur=2.5 },

	   		{ event='talk', delay=9.9, handle_id=2, talk='陛下，切莫动怒！', dur=2.5  },
	   		{ event='talk', delay=12.7, handle_id=2, talk='微臣听说天下第一的文豪蔡文公已经破解了箴机的秘密。', dur=2.5 },
	   		{ event='talk', delay=15.5, handle_id=2, talk='不如将其请来询问之后在做安排!', dur=2.5  },

		},
		{
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=2, pos={522,1800}, speed=260, dur=1.5 },

	   		{ event='talk', delay=1.5, handle_id=1, talk='此计甚好！那此事就交由你来打理！', dur=2.5 },
	   		{ event='talk', delay=4.3, handle_id=2, talk='是陛下！', dur=1.5  },   	
		},
		{
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={445,1300}, speed=340, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={669,1800}, speed=340, dur=1.5 },

	    	{ event='move', delay= 1.5, handle_id=101, end_dir=1, pos={445,1300}, speed=340, dur=1.5 },
	    	{ event='move', delay= 1.5, handle_id=102, end_dir=7, pos={445,1300}, speed=340, dur=1.5 },	

	   		{ event='createActor', delay=0.1, handle_id =3, body=6, pos={1390,2390}, dir=6, speed=340, name_color=0xffffff, name="阴丽华"},
	   		{ event='createActor', delay=0.1, handle_id =4, body=13, pos={1063,2365}, dir=2, speed=340, name_color=0xffffff, name="刘秀"},		    	
		},
		{
	   		{ event='init_cimera', delay = 0.2,mx= 1123,my = 2200 },
	   		{ event='kill', delay=0.3, handle_id=1},
	   		{ event='kill', delay=0.3, handle_id=2},
	   		{ event='kill', delay=0.3, handle_id=101},
	   		{ event='kill', delay=0.3, handle_id=102},
	   		{ event='kill', delay=0.3, handle_id=103},	
	   		{ event='kill', delay=0.3, handle_id=104},	   		   		
		},
		{
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=6, pos={1063+100,2365}, speed=240, dur=1.5 },
	   		{ event='talk', delay=1.5, handle_id=3, talk='文叔哥哥，听说蔡文公推演出箴机的秘密啦！', dur=2.5 },
	   		{ event='talk', delay=4.3, handle_id=3, talk='快，我们一起偷偷溜去瞧瞧。', dur=2  },

	    	{ event='move', delay= 6, handle_id=3, end_dir=5, pos={1063+100,2365-200}, speed=240, dur=1.5 },

	    	{ event='move', delay= 6.5, handle_id=4, end_dir=1, pos={1063,2365}, speed=340, dur=0.5 },	    	
	    	{ event='move', delay= 7, handle_id=4, end_dir=1, pos={1063+50,2365-150}, speed=440, dur=1.5 },
	   		{ event='talk', delay=7.1, handle_id=4, talk='你呀，又去捣乱，慢点跑！', dur=2.5 },

	    	{ event='createActor', delay=0.1, handle_id = 5, body=23, pos={1850,1710}, dir=6, speed=340, name_color=0xffffff, name="蔡少公"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=34, pos={1670,1710}, dir=2, speed=340, name_color=0xffffff, name="王莽使臣"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=57, pos={1570,1660}, dir=2, speed=340, name_color=0xffffff, name="随从"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=57, pos={1570,1760}, dir=2, speed=340, name_color=0xffffff, name="随从"},	   		
		},
		{
	   		{ event='init_cimera', delay = 0.2,mx= 1760,my = 1600 },
		},
		{
	   		{ event='talk', delay=1.5, handle_id=6, talk='请问阁下就是蔡少公吧？', dur=2.5 },
	   		{ event='talk', delay=4.3, handle_id=5, talk='老朽正是，不知寻我所谓何事？', dur=2.5  },
	   		{ event='talk', delay=7.1, handle_id=6, talk='我乃是新朝皇帝派来的使者！', dur=2.5 },
	   		{ event='talk', delay=9.9, handle_id=6, talk='找蔡公询问箴机之事，不知蔡公如何看待此事？', dur=2.5  },
	   		{ event='talk', delay=12.7, handle_id=5, talk='天道循环，善恶有报。看破又能如何？', dur=2.5 },
	   		{ event='talk', delay=15.5, handle_id=5, talk='您请回吧！!', dur=2.5  },
	   	},
	   	{	
	    	{ event='playAction', delay=0.1, handle_id=6, action_id=2, dur=0.5, dir=2, loop=false },	   		
	   		{ event='talk', delay=1, handle_id=6, talk='不识抬举！来人啊，把他给我绑回去！!', dur=2.5  },
	   		{ event='talk', delay=4, handle_id=106, talk='是，大人！!', dur=2.5  },
	   		{ event='talk', delay=4, handle_id=105, talk='是，大人！!', dur=2.5  },

	    	{ event='move', delay= 5, handle_id=105, end_dir=2, pos={1570+150,1660}, speed=240, dur=1.5 },
	    	{ event='move', delay= 5, handle_id=106, end_dir=2, pos={1570+150,1760}, speed=340, dur=0.5 },	

	    	{ event='move', delay= 5, handle_id=3, end_dir=1, pos={1163,2165}, speed=240, dur=0.5 },
	    	{ event='move', delay= 5, handle_id=4, end_dir=1, pos={1163+100,2165}, speed=340, dur=0.5 },

	   		{ event = 'camera', delay = 5.5, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1123,2100 } },
		},
		{
	   		{ event='talk', delay=0.5, handle_id=3, talk='前面乱哄哄的，好像不对啊！', dur=2.5 },
	   		{ event='talk', delay=3.5, handle_id=3, talk='三哥快一些，我们过去看看。', dur=2.5  },
	   		{ event='talk', delay=6.5, handle_id=4, talk='走，不能让蔡博士受了惊吓。', dur=2 },

	    	{ event='move', delay= 8, handle_id=3, end_dir=1, pos={1163+300,2165-300}, speed=240, dur=0.5 },
	    	{ event='move', delay= 8, handle_id=4, end_dir=1, pos={1163+100+300,2165-300}, speed=240, dur=0.5 },	   		
		},
	},
	['juqing-ix040'] =
	{
		{
	   		{ event='init_cimera', delay = 0.2,mx= 1690,my = 1700 },

	    	{ event='createActor', delay=0.1, handle_id = 1, body=23, pos={1850,1710}, dir=5, speed=340, name_color=0xffffff, name="蔡少公"},
	   		{ event='createActor', delay=0.1, handle_id =2, body=6, pos={1416,1918}, dir=1, speed=340, name_color=0xffffff, name="阴丽华"},
	   		{ event='createActor', delay=0.1, handle_id =3, body=13, pos={1416+100,1918+20}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},		    	
		},

		{
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={1850-200,1710+80}, speed=240, dur=0.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=1, pos={1850-100,1710+100}, speed=240, dur=0.5 },
		},
		{
	   		{ event='talk', delay=0.5, handle_id=3, talk='蔡博士，您没事吧？', dur=2 },
	   		{ event='talk', delay=3, handle_id=2, talk='舅舅，我们来晚了！', dur=2 },
	   		{ event='talk', delay=5.5, handle_id=2, talk='他们是做什么的啊？为何要抓您呢。', dur=2.5 },
	   		{ event='talk', delay=8.5, handle_id=1, talk='王莽的随从，想找我去破解箴机的奥妙。', dur=2.5 },
	   		{ event='talk', delay=11.5, handle_id=1, talk='被我拒绝之后，恼羞成怒要将我绑去交差。', dur=2.5  },
	   	},
	   	{	
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={1850-200,1710+80}, speed=240, dur=0.3 },
	    	{ event='move', delay= 0.5, handle_id=2, end_dir=1, pos={1850-200,1710+80}, speed=240, dur=0.3 },

	   		{ event='talk', delay=1, handle_id=2, talk='这样啊，那我们快走吧。', dur=2 },
	   		{ event='talk', delay=3.5, handle_id=2, talk='免得他们追来。', dur=2 },
	   		{ event='talk', delay=6, handle_id=3, talk='是啊，蔡博士我们离开此地吧。', dur=2.5  },
	   		{ event='talk', delay=9, handle_id=1, talk='好吧，此地凶险。', dur=2 },
	   		{ event='talk', delay=11.5, handle_id=1, talk='就听你们的，我们走！', dur=2 },	   		
		},
		{
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={2137,2154}, speed=240, dur=1.5 },		
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=1, pos={2137,2154}, speed=240, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=1, pos={2137,2154}, speed=240, dur=1.5 },
		},
	},
	--============================================luyao  每日剧情20 end  =====================================----

	--============================================wuwenbin  每日剧情21 start  =====================================----
   	['juqing-ix041'] = 
	{
		--演员表 1 王莽 2 王寻 3 禁卫首领 4 李父 101-106 新军禁卫
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 2542,my = 1100 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={2544,1166}, dir=5, speed=340, name_color=0xffffff, name="王莽"},
	    	
	    	{ event='createActor', delay=0.1, handle_id = 2, body=43, pos={2160,1450}, dir=1, speed=340, name_color=0xffffff, name="王寻"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=21, pos={2522,1276}, dir=1, speed=340, name_color=0xffffff, name="禁卫首领"},

	   		--禁卫

	   		{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={2068,1490}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={1996,1518}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=27, pos={1928,1558}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=27, pos={2162,1554}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=27, pos={2098,1584}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=27, pos={2032,1620}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	    },

	    --王寻上报王莽李家造反
	    {	
	    	{ event='move', delay= 0.2, handle_id=2, end_dir=1, pos={2440,1230}, speed=260, dur=1.5 },

	   		{ event='talk', delay=1.5, handle_id=2, talk='陛下，属下接到探子的密报！', dur=2.5 },
	   		{ event='talk', delay=4.3, handle_id=2, talk='卿师李守的儿子在南阳联合刘氏后裔举兵作乱了。', dur=2.5  },

	   		{ event='talk', delay=7.1, handle_id=1, talk='大胆，身为我新朝官员居然谋逆作乱！', dur=2.5 },
	   		{ event='talk', delay=9.9, handle_id=1, talk='来人啊！速速前往李府将他们全部抓起来。', dur=2.5  },

	   		{ event='talk', delay=12.7, handle_id=3, talk='是，陛下！', dur=2  },
	   	},

	   	--禁卫首领移动至新军禁卫处
	   	{
	   		{ event = 'camera', delay = 0.2, dur=1.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2136,1430 } }, -- 移动镜头通过
	   		{ event='move', delay= 0.2, handle_id=3, end_dir=5, pos={2160,1450}, speed=280, dur=1.5 },

	    	{ event='talk', delay=1.2, handle_id=3, talk='传令：结队，包围李府。', dur=2.5 },

	   		{ event='talk', delay=4, handle_id=101, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=4, handle_id=102, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=4, handle_id=103, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=4, handle_id=104, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=4, handle_id=105, talk='喏！', dur=1.5  },
	   		{ event='talk', delay=4, handle_id=106, talk='喏！', dur=1.5  },

	   		{ event='move', delay= 5.8, handle_id=3, end_dir=5, pos={1626,1816}, speed=260, dur=1.5 },

	   		{ event='move', delay= 5.8, handle_id=101, end_dir=5, pos={2068,1490}, speed=260, dur=1.5 },
	   		{ event='move', delay= 5.8, handle_id=102, end_dir=5, pos={1996,1518}, speed=260, dur=1.5 },
	   		{ event='move', delay= 5.8, handle_id=103, end_dir=5, pos={1928,1558}, speed=260, dur=1.5 },

	   		{ event='move', delay= 5.8, handle_id=104, end_dir=5, pos={2162,1554}, speed=260, dur=1.5 },
	   		{ event='move', delay= 5.8, handle_id=105, end_dir=5, pos={2098,1584}, speed=260, dur=1.5 },
	   		{ event='move', delay= 5.8, handle_id=106, end_dir=5, pos={2032,1620}, speed=260, dur=1.5 },

	   		{ event='move', delay= 7, handle_id=101, end_dir=1, pos={1586,1774}, speed=260, dur=1.5 },
	   		{ event='move', delay= 7, handle_id=102, end_dir=1, pos={1586,1774}, speed=260, dur=1.5 },
	   		{ event='move', delay= 7, handle_id=103, end_dir=1, pos={1586,1774}, speed=260, dur=1.5 },

	   		{ event='move', delay= 7, handle_id=104, end_dir=1, pos={1682,1812}, speed=260, dur=1.5 },
	   		{ event='move', delay= 7, handle_id=105, end_dir=1, pos={1682,1812}, speed=260, dur=1.5 },
	   		{ event='move', delay= 7, handle_id=106, end_dir=1, pos={1682,1812}, speed=260, dur=1.5 },

	   		{ event='kill', delay=8.5, handle_id=1},
	   		{ event='kill', delay=8.5, handle_id=2},
	   		{ event='kill', delay=8.5, handle_id=3},
	   		-- { event='kill', delay=7.3, handle_id=4},

	   		{ event='kill', delay=8.5, handle_id=101},
	   		{ event='kill', delay=8.5, handle_id=102},
	   		{ event='kill', delay=8.5, handle_id=103},
	   		{ event='kill', delay=8.5, handle_id=104},
	   		{ event='kill', delay=8.5, handle_id=105},
	   		{ event='kill', delay=8.5, handle_id=106},
	    },

	    --王寻，禁卫军，李父出现
	    {
	    	{ event='createActor', delay=0.1, handle_id = 2, body=43, pos={1194,2224}, dir=5, speed=340, name_color=0xffffff, name="王寻"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=21, pos={1260,2196}, dir=5, speed=340, name_color=0xffffff, name="禁卫首领"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={784,2480}, dir=1, speed=340, name_color=0xffffff, name="李父"},

	   		--禁卫
	   		{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={1306,2128}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={1368,2158}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	    },

	    --王寻带兵出现在李府
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	    	{ event='init_cimera', delay = 0.2,mx= 920,my = 2340 },

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={880,2416}, speed=340, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=5, pos={938+32,2384-32}, speed=340, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=101, end_dir=5, pos={990+32,2298-32}, speed=340, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=102, end_dir=5, pos={1052+32,2328-32}, speed=340, dur=1.5 },

	    	{ event='talk', delay=2.3, handle_id=2, talk='李卿师，好久不见啊，近来可好？', dur=2.5},
	    	{ event='talk', delay=5.3, handle_id=4, talk='多谢大司徒挂念，下官不知司徒所来何事？', dur=2.5},

	   		{ event='talk', delay=8.1, handle_id=2, talk='呵呵，没什么事，就是听说你的好儿子在南阳起兵了。', dur=3},
	   		{ event='talk', delay=11.4, handle_id=2, talk='不知你这位老爹作何解释？', dur=2.5  },
	   	},

	   	--家丁通报，王寻抓人
	    {	
	    	{ event='createActor', delay=0.1, handle_id = 201, body=19, pos={506,2570}, dir=1, speed=340, name_color=0xffffff, name="家丁"},
	    	{ event='move', delay= 0.3, handle_id=201, end_dir=1, pos={718,2516}, speed=340, dur=1.5 },

	    	{ event='move', delay= 1, handle_id=4, end_dir=5, pos={784,2480}, speed=340, dur=1.5 },	--李父转向

	    	{ event='talk', delay=1, handle_id=201, talk='李大人，不好啦！', dur=2},
	    	{ event='talk', delay=3.3, handle_id=201, talk='府外全都是禁军，我们被包围了。', dur=2.5},
	    	{ event='talk', delay=6.1, handle_id=4, talk='[a]', dur=2,emote = { a = 41}},

	    	{ event='move', delay= 8, handle_id=4, end_dir=1, pos={784,2480}, speed=340, dur=1.5 },	--李父转向
	   		{ event='talk', delay=8.3, handle_id=4, talk='司徒大人，这都是误会啊！', dur=2.5},
	   		{ event='talk', delay=11, handle_id=4, talk='犬子肯定是受人蒙蔽，误入歧途啊！', dur=2.5},

	   		{ event='talk', delay=13.8, handle_id=2, talk='好啦！有什么话见了陛下再说吧。', dur=2.5},
	   		{ event='talk', delay=16.6, handle_id=2, talk='来人，将李府一干人等全部收押！', dur=2.5},
	   	},

	   	--刺客首领下达灭口令
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 2, body=55, pos={2160,1450}, dir=5, speed=340, name_color=0xffffff, name="家丁"},
	    	{ event = 'camera', delay = 2, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 1066+32,2228-32 } }, -- 移动镜头通过

	    	{ event='talk', delay=0.1, handle_id=3, talk='是，司徒大人。', dur=2},

	    	{ event='move', delay= 2.3, handle_id=3, end_dir=1, pos={938+32,2384-32}, speed=340, dur=1.5 },
	    	{ event='talk', delay=2.3, handle_id=3, talk='你们还在看什么？动手！', dur=2.5},

	   		{ event='talk', delay=5, handle_id=101, talk='是！', dur=1.5},
	   		{ event='talk', delay=5, handle_id=102, talk='是！', dur=1.5},
	   	},

    },

    ['juqing-ix042'] = 
	{
		--演员表 1 王寻 2 李父 3 禁卫首领 101-108 禁卫军 201-204 家眷
	 	--创建角色
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=43, pos={880,2416}, dir=5, speed=340, name_color=0xffffff, name="王寻"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=23, pos={784,2480}, dir=1, speed=340, name_color=0xffffff, name="李父"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=21, pos={938+32,2384-32}, dir=5, speed=340, name_color=0xffffff, name="禁卫首领"},
	    	

	    	{ event='createActor', delay=0.1, handle_id = 101, body=27, pos={616,2380}, dir=2, speed=340, name_color=0xffffff, name="新军禁卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=27, pos={628,2442}, dir=2, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=27, pos={660,2518}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=27, pos={692,2578}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 105, body=27, pos={752,2610}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},
	   		{ event='createActor', delay=0.1, handle_id = 106, body=27, pos={818,2642}, dir=1, speed=340, name_color=0xffffff, name="新军禁卫"},

	    	{ event='createActor', delay=0.1, handle_id = 201, body=1, pos= {684,2418}, dir=2, speed=340, name_color=0xffffff, name="家眷"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=17, pos= {718,2512},dir=1, speed=340, name_color=0xffffff, name="家眷"},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=36, pos= {818,2570}, dir=1, speed=340, name_color=0xffffff, name="家眷"},
	    },

	    --王寻押走李父
	    {	
	    	{ event='init_cimera', delay = 0.2,mx= 920,my = 2340},

	    	{ event='talk', delay=0.5, handle_id=1, talk='委屈卿师大人了！', dur=2.5, },
	    	{ event='talk', delay=3.3, handle_id=2, talk='王寻，你敢如此！', dur=2.5, },
	    	{ event='talk', delay=6.1, handle_id=2, talk='我定要向陛下上奏[a]', dur=2.5, emote = { a = 24}},

	    	{ event='talk', delay=8.9, handle_id=1, talk='死到临头了还嘴硬。', dur=2.5, },
	    	{ event='talk', delay=11.7, handle_id=1, talk='给我全部押走！', dur=2.5, },
	    	{ event='talk', delay=14.5, handle_id=3, talk='敢对司徒大人不敬！', dur=2.5, },
	    	{ event='talk', delay=17.3, handle_id=3, talk='全部押往监牢！', dur=2.5, },

	    	{ event='talk', delay=20.1, handle_id=103, talk='是，大人！', dur=2.5, },
	    	{ event='talk', delay=22.8, handle_id=104, talk='走，快点走！', dur=2.5, },
	    	{ event='playAction', delay=22.8, handle_id=104, action_id=2, dur=1.5, dir=1, loop=false },

	    },
	},

	--============================================wuwenbin  每日剧情21 end  =====================================----

	--============================================wuwenbin  每日剧情23 start  =====================================----
   	['juqing-ix045'] = 
	{
		--演员表 1 丽华 2 胭脂 3 追兵首领 4-6 追兵 
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 1500,my = 1498 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1358,1584}, dir=1, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=41, pos={1994,1298}, dir=5, speed=340, name_color=0xffffff, name="胭脂"},
	    },

	    --丽华胭脂逃跑
	    {	
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={1424,1550}, speed=260, dur=1.5 },
	   		{ event='talk', delay=1, handle_id=2, talk='小姐，不好了。', dur=2 },
	   		{ event='talk', delay=3.4, handle_id=2, talk='后面的追兵追上来了！', dur=2.5  },

	   		{ event='talk', delay=6.2, handle_id=1, talk='胭脂，你先走吧。', dur=2 },
	   		{ event='talk', delay=8.5, handle_id=1, talk='表姐死了，我有何面目回去见表哥和大哥啊……', dur=3  },

	   		{ event='talk', delay=11.8, handle_id=2, talk='小姐啊，别伤心了。', dur=2.5 },
	   		{ event='talk', delay=14.6, handle_id=2, talk='我们快走吧，要不然就来不及啦', dur=3  },
	   		{ event='talk', delay=17.9, handle_id=1, talk='好吧…', dur=2  },

	   		{ event='move', delay= 20, handle_id=1, end_dir=1, pos={1012,1842}, speed=260, dur=1.5 },
	   		{ event='move', delay= 20, handle_id=2, end_dir=1, pos={1012,1842}, speed=260, dur=1.5 },

	   		{ event='kill', delay=22, handle_id=1},
	   		{ event='kill', delay=22, handle_id=2},
	   	},

	   	--禁卫首领移动至新军禁卫处
	   	{
	   		--禁卫
	   		{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={2026,1298}, dir=5, speed=340, name_color=0xffffff, name="新军首领"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=58, pos={2030,1234}, dir=5, speed=340, name_color=0xffffff, name="新军士兵"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=58, pos={2096,1258}, dir=5, speed=340, name_color=0xffffff, name="新军士兵"},

	   		{ event='move', delay= 0.2, handle_id=3, end_dir=5, pos={1586,1578}, speed=260, dur=1.5 },

	   		{ event='move', delay= 0.2, handle_id=4, end_dir=5, pos={1616,1522}, speed=260, dur=1.5 },
	   		{ event='move', delay= 0.2, handle_id=5, end_dir=5, pos={1674,1554}, speed=260, dur=1.5 },

	   		{ event='talk', delay=1.3, handle_id=3, talk='快给我追！', dur=2},
	    	{ event='talk', delay=3.6, handle_id=3, talk='她们都是女眷，跑不远的。', dur=2.5},
	    	{ event='talk', delay=6.4, handle_id=3, talk='抓住他们重重有赏！', dur=2.5},

	    	{ event='talk', delay=9.2, handle_id=4, talk='是，大人!', dur=2},
	    	{ event='talk', delay=9.2, handle_id=5, talk='是，大人!', dur=2},

	    	{ event='move', delay= 11.5, handle_id=3, end_dir=5, pos={1168,1842}, speed=260, dur=1.5 },

	   		{ event='move', delay= 11.5, handle_id=4, end_dir=5, pos={1200,1778}, speed=260, dur=1.5 },
	   		{ event='move', delay= 11.5, handle_id=5, end_dir=5, pos={1256,1816}, speed=260, dur=1.5 },

	   		{ event='kill', delay=13.5, handle_id=3},
	   		{ event='kill', delay=13.5, handle_id=4},
	   		{ event='kill', delay=13.5, handle_id=5},
	    },


	    --刷出丽华等人
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	   		{ event='init_cimera', delay = 0.3,mx= 600,my = 2050 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={806,2274}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=41, pos={466,2034}, dir=3, speed=340, name_color=0xffffff, name="胭脂"},

	   		{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={560,2124}, dir=3, speed=340, name_color=0xffffff, name="新军首领"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=58, pos={468,2160}, dir=3, speed=340, name_color=0xffffff, name="新军士兵"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=58, pos={604,2046}, dir=3, speed=340, name_color=0xffffff, name="新军士兵"},

	   		{ event='playAction', delay=0.2, handle_id=2, action_id=4, dur=1.5, dir=3, loop=false ,once = true},
	   	},

	   	--追兵抓住了胭脂
	    {	

	    	{ event='talk', delay=0.1, handle_id=4, talk='你们再跑啊！接着跑啊！', dur=2.5},
	    	{ event='talk', delay=2.9, handle_id=5, talk='看着两个小姑娘年纪轻轻的，真是可惜了！', dur=3},
	    	{ event='talk', delay=6.2, handle_id=4, talk='[a]', dur=2,emote = { a = 45}},
	    	{ event='talk', delay=6.2, handle_id=5, talk='[a]', dur=2,emote = { a = 45}},

	   		{ event='talk', delay=8.5, handle_id=3, talk='好了，先抓回去交差吧！', dur=3},
	   	},

	   	--胭脂恳求丽华救自己
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 2, body=55, pos={2160,1450}, dir=5, speed=340, name_color=0xffffff, name="家丁"},
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={806-16,2274-16}, speed=340, dur=8 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={466,2034}, speed=340, dur=8 },

	    	{ event='talk', delay= 0.1, handle_id=1, talk='胭脂，胭脂！', dur=2},
	    	{ event='talk', delay= 2.3, handle_id=2, talk='小姐，救我，救我！[a]', dur=2.5,emote = { a = 46}},

	   		{ event='showTopTalk', delay=4.6, dialog_id="ix23_1" ,dialog_time = 3,},
	   	},

    },

    ['juqing-ix046'] = 
	{
		--演员表 1 王寻 2 李父 3 禁卫首领 101-108 禁卫军 201-204 家眷
	 	--创建角色
	    {
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={806,2274}, dir=7, speed=340, name_color=0xffffff, name="丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=41, pos={466,2034}, dir=3, speed=340, name_color=0xffffff, name="胭脂"},

	   		{ event='createActor', delay=0.1, handle_id = 3, body=43, pos={560,2124}, dir=3, speed=340, name_color=0xffffff, name="新军首领"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=58, pos={436-32,2092+32}, dir=3, speed=340, name_color=0xffffff, name="新军士兵"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=58, pos={558+32,2036}, dir=3, speed=340, name_color=0xffffff, name="新军士兵"},
	    },

	    --首领发现丽华跑了
	    {	
	    	{ event='init_cimera', delay = 0.2,mx= 700,my = 2150},
	    	{ event='move', delay= 0.3, handle_id=1, end_dir=3, pos={916,2324}, speed=200, dur=1.5 },
	    	{ event='jump', delay=0.7, handle_id=1, dir=3, pos={ 1230,2702 }, speed=120, dur=0.8 ,end_dir = 3},

	    	{ event='move', delay= 0.3, handle_id=3, end_dir=3, pos={662,2198}, speed=340, dur=1.5 },
			{ event='talk', delay=0.3, handle_id=3, talk='别跑！', dur=2, },
	    	{ event='talk', delay=2.6, handle_id=3, talk='溜得真快！', dur=2.5, },
	    },

	    --首领下令回去复命
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.3,sdur = 0.9,style = '',backtime=1, c_topox = { 600,2050 } },
	    	{ event='move', delay= 0.1, handle_id=3, end_dir=7, pos={624,2164}, speed=340, dur=1.5 },
	    	{ event='talk', delay=0.5, handle_id=3, talk='晦气，让那个小丫头跑了！', dur=3, },
	    	{ event='talk', delay=3.8, handle_id=3, talk='算了，好歹抓住了一个。', dur=2.5, },
	    	{ event='talk', delay=6.6, handle_id=3, talk='走吧，回去复命。', dur=2.5, },
	    	{ event='talk', delay=9.4, handle_id=4, talk='是，大人！', dur=2.5, },
	    	{ event='talk', delay=9.4, handle_id=5, talk='是，大人！', dur=2.5, },

	    	{ event='talk', delay=12.2, handle_id=2, talk='小姐，救我啊！', dur=2.5, },
	    	{ event='talk', delay=14.9, handle_id=2, talk='别丢下我不管啊[a]', dur=2.5, emote= { a = 33}},

	    	{ event='move', delay= 12.2, handle_id=4, end_dir=1, pos={436-32,2092+32}, speed=340, dur=1.5 },
	    	{ event='move', delay= 12.2, handle_id=5, end_dir=6, pos={558+32,2036}, speed=340, dur=1.5 },

	    	{ event='talk', delay=17.7, handle_id=4, talk='走，快点走！', dur=2, },

	    	{ event='playAction', delay=17.7, handle_id=4, action_id=2, dur=1.5, dir=1, loop=false },
	    	{ event='playAction', delay=17.9, handle_id=2, action_id=3, dur=1.5, dir=5, loop=false },

	    	{ event='talk', delay=17.9, handle_id=2, talk='小姐……[a]', dur=2, emote= { a = 33}},

	    	{ event='kill', delay=20, handle_id=1},
	   		{ event='kill', delay=20, handle_id=2},
	    	{ event='kill', delay=20, handle_id=3},
	   		{ event='kill', delay=20, handle_id=4},
	   		{ event='kill', delay=20, handle_id=5},
	    },

	     --丽华逃跑
	    {	
	    	{ event='init_cimera', delay = 0.2,mx= 858,my = 2966},
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={748,2928}, dir=3, speed=340, name_color=0xffffff, name="丽华"},

	    	-- { event='move', delay= 2.3, handle_id=3, end_dir=1, pos={938,2384}, speed=340, dur=1.5 },
	    	{ event='move', delay= 0.2, handle_id=1, end_dir=7, pos={912,3024}, speed=340, dur=0.7 },
	    },

	    --胭脂呼喊
	    {
	    	{ event='showTopTalk', delay=0.1, dialog_id="ix23_2" ,dialog_time = 2.5,},
		},

		--丽华自责
	    {	
	    	{ event='move', delay= 0.3, handle_id=1, end_dir=7, pos={912-32,3024-32}, speed=340, dur=0.7 },
	    	{ event='talk', delay=0.1, handle_id=1, talk='胭脂，胭脂——', dur=2.5, },
	    	{ event='talk', delay=2.8, handle_id=1, talk='表姐！胭脂！', dur=2.5, },
	    	{ event='talk', delay=5.6, handle_id=1, talk='我没用啊，我救不了你们。[a]', dur=3, emote = { a = 33}},
	    },
	},

	--============================================wuwenbin  每日剧情23 end  =====================================----


	--============================================wuwenbin  每日剧情24 start  =====================================----
   	['juqing-ix047'] = 
	{
		--演员表 1 阴戟 2 刘秀 3 刘縯 4 刘氏族长 5 刘氏宗亲 6 刘氏宗亲
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 964,my = 900 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={994,982}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={945,945}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=14, pos={1020,913}, dir=5, speed=340, name_color=0xffffff, name="刘縯"},
	    },

	    --刘秀刘縯商议
	    {	
	   		{ event='talk', delay=0.1, handle_id=3, talk='今日天降异象。', dur=2 },
	   		{ event='talk', delay=2.4, handle_id=3, talk='如此看来此等良机不可错过！', dur=2.5  },

	   		{ event='talk', delay=5.2, handle_id=2, talk='大哥，莫要声张！[a]', dur=2.5 ,emote = { a = 38}},
	   		{ event='talk', delay=8, handle_id=2, talk='此事我们还需要从长计议。', dur=3  },

	   		{ event='kill', delay=11.5, handle_id=1},
	   		{ event='kill', delay=11.5, handle_id=2},
	    	{ event='kill', delay=11.5, handle_id=3},
	   	},

	   	--族长处
	   	{
	   		{ event='init_cimera', delay = 0.2,mx= 249,my = 302 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={270,341}, dir=3, speed=340, name_color=0xffffff, name="刘氏族长"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=19, pos={273,408}, dir=1, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=38, pos={346,360}, dir=5, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	    },

	    --宗亲对天象感到慌张
	    {	
	   		{ event='talk', delay=0.1, handle_id=5, talk='发生什么事情了？', dur=2 },
	   		{ event='talk', delay=2.4, handle_id=5, talk='你们看到没有？', dur=2  },

	   		{ event='talk', delay=4.7, handle_id=6, talk='莫非这就是…….', dur=2 },
	   		{ event='talk', delay=7, handle_id=6, talk='春秋记载的七月流火，星孛于张！[a]', dur=3 ,emote = { a = 41} },
	   	},

	   	--族长决定问刘縯
	   	{
	   		{ event='move', delay= 0.1, handle_id=5, end_dir=7, pos={273,408}, speed=340, dur=3.7 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=7, pos={346,360}, speed=340, dur=3.7 },

	   		{ event='talk', delay=0.1, handle_id=4, talk='不要慌乱，随我去找伯升问清楚！', dur=3 },

	   		{ event='kill', delay=3.7, handle_id=4},
	   		{ event='kill', delay=3.7, handle_id=5},
	    	{ event='kill', delay=3.7, handle_id=6},
	   	},


	    --刷出丽华等人
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	   		{ event='init_cimera', delay = 0.3,mx= 934,my = 770 },
	   		
	   		{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1018,965}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={945,945}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=14, pos={1020,913}, dir=5, speed=340, name_color=0xffffff, name="刘縯"},

			{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={819,753}, dir=1, speed=340, name_color=0xffffff, name="刘氏族长"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=19, pos={750,719}, dir=5, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=38, pos={818,690}, dir=5, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	    	
	   	},

	   	--叔父找到刘秀等人
	    {	
	    	{ event='move', delay= 0.5, handle_id=1, end_dir=7, pos={1018,965}, speed=340, dur=2 },
	    	{ event='move', delay= 0.5, handle_id=2, end_dir=7, pos={945,945}, speed=340, dur=2 },
	    	{ event='move', delay= 0.5, handle_id=3, end_dir=7, pos={1020,913}, speed=340, dur=2 },

	    	{ event='move', delay= 0.1, handle_id=4, end_dir=3, pos={917,855}, speed=340, dur=2 },
	    	{ event='move', delay= 0.1, handle_id=5, end_dir=3, pos={854,823}, speed=340, dur=2 },
	    	{ event='move', delay= 0.1, handle_id=6, end_dir=3, pos={907,784}, speed=340, dur=2 },

	    	{ event='talk', delay=0.5, handle_id=4, talk='伯升，文叔，你们在做什么？', dur=2.5},
	    	{ event='talk', delay=3.3, handle_id=3, talk='叔父，我们在商议起兵复汉之事。', dur=3},
	    	{ event='talk', delay=6.6, handle_id=3, talk='您怎么来了？', dur=2},
	    	{ event='talk', delay=8.9, handle_id=2, talk='文叔拜见叔父。', dur=2.5},
	   	},

	   	--叔父斥责刘秀
	    {	
	    	{ event='talk', delay=0.1, handle_id=4, talk='文叔啊，伯升鲁莽。', dur=2.5},
	    	{ event='talk', delay=2.8, handle_id=4, talk='你怎么也跟着你大哥胡闹？', dur=3},

	    	{ event='talk', delay=6.1, handle_id=3, talk='伯父此言差矣，如今新莽倒行逆施天下动荡。', dur=3},
	    	{ event='talk', delay=9.4, handle_id=3, talk='正式好男儿建功立业之际！', dur=2.5},
	    	{ event='talk', delay=12.2, handle_id=3, talk='叔父您年纪大了，就多休息一下吧。', dur=3},

	    	{ event='talk', delay=15.8, handle_id=4, talk='伯升，你可知我们刘氏一族的处境？', dur=3},
	    	{ event='talk', delay=19.1, handle_id=4, talk='你还在这里大言不惭！[a]', dur=2.5,emote = { a = 34}},
	    	{ event='talk', delay=21.9, handle_id=5, talk='伯升，文叔，你们敢放肆！', dur=2.5},
	    	{ event='talk', delay=24.7, handle_id=6, talk='目无尊长，居然敢对族长出言不敬！', dur=3},
	   	},

    },

    ['juqing-ix048'] = 
	{
		--演员表 1 王寻 2 李父 3 禁卫首领 101-108 禁卫军 201-204 家眷
	 	--创建角色
	    {
	    	{ event='init_cimera', delay = 0.2,mx= 934,my = 770},

	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1018,965}, dir=7, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={945,945}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=14, pos={1020,913}, dir=7, speed=340, name_color=0xffffff, name="刘縯"},

			{ event='createActor', delay=0.1, handle_id = 4, body=23, pos={917,855}, dir=3, speed=340, name_color=0xffffff, name="刘氏族长"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=19, pos={854,823}, dir=3, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=38, pos={907,784}, dir=3, speed=340, name_color=0xffffff, name="刘氏宗亲"},
	    },

	    --刘縯，刘秀说服叔父
	    {
	    	{ event='talk', delay=0.1, handle_id=3, talk='叔父，侄儿无意冒犯。', dur=2.5, },
	    	{ event='talk', delay=2.9, handle_id=3, talk='还请叔父责罚！', dur=2.5, },

	    	{ event='talk', delay=5.7, handle_id=2, talk='侄儿们知错了。', dur=2.5, },
	    	{ event='talk', delay=8.5, handle_id=2, talk='不过王莽如今倒行逆施。', dur=2.5, },
	    	{ event='talk', delay=11.3, handle_id=2, talk='我们刘氏后裔身份特殊，更应早做打算。', dur=3, },
	    	{ event='talk', delay=14.6, handle_id=2, talk='还望叔父成全！', dur=2.5, },

	    	{ event='talk', delay=17.4, handle_id=1, talk='对啊，请刘家叔父慎重考虑！', dur=2.5, },
	    },

	    --叔父改口
	    {

	    	{ event='talk', delay=0.1, handle_id=4, talk='嗯……', dur=2,},
	    	{ event='talk', delay=2.4, handle_id=4, talk='罢了，我年纪也大了！', dur=2.5,},
	    	{ event='talk', delay=5.2, handle_id=4, talk='伯升啊，自此之后南阳舂陵刘氏一脉就交付于你来打理吧。', dur=3,},

	    	{ event='move', delay= 8.5, handle_id=5, end_dir=3, pos={917-64,855+32}, speed=340, dur=3 },
	    	{ event='move', delay= 11.3, handle_id=6, end_dir=3, pos={917+64,855-32}, speed=340, dur=2.8 },

	    	{ event='talk', delay=8.5, handle_id=5, talk='对，文叔说的在理，以后就跟着伯升打天下吧！', dur=2.5,},
	    	{ event='talk', delay=11.3, handle_id=6, talk='我等愿意追随伯升左右！', dur=2.5,},
	    },
	},

	--============================================wuwenbin  每日剧情24 end  =====================================----

	--============================================wuwenbin  每日剧情25 start  =====================================----
   	['juqing-ix049'] = 
	{
		--演员表 1 阴戟 2 刘秀 3 冯异 4 王匡 5 王寻 6 巨无霸 101-115 汉军 201-215 新军 301-306 狮子、老虎、狼
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 452,my = 1828 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 4, body=55, pos={474,1876}, dir=3, speed=340, name_color=0xffffff, name="王匡"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=43, pos={526,1908}, dir=7, speed=340, name_color=0xffffff, name="王寻"},
	    },

	    --刘秀刘縯商议
	    {	
	   		{ event='talk', delay=0.1, handle_id=4, talk='都是废物，近日来昆阳战局不利！', dur=2.5 },
	   		{ event='playAction', delay=0.4, handle_id=4, action_id=2, dur=0.2, dir=3, loop= false },
	   		{ event='talk', delay=2.9, handle_id=4, talk='你们打算如何向朝廷和陛下交代？', dur=2.5  },

	   		{ event='talk', delay=5.7, handle_id=5, talk='大司马，莫要急躁！', dur=2.5 ,},
	   		{ event='talk', delay=8.5, handle_id=5, talk='属下已经打听到一个消息：', dur=2.5  },
	   		{ event='talk', delay=11.3, handle_id=5, talk='昆阳附近有位奇人异士，身高巨大，懂的驱使走兽', dur=3 ,},
	   		{ event='talk', delay=14.6, handle_id=5, talk='能将此人召入帐中，定能攻破反军。', dur=2.5  },

	   		{ event='talk', delay=17.4, handle_id=4, talk='那就尽快将此事处理一下。', dur=2.5 ,},
	   		{ event='talk', delay=20.2, handle_id=4, talk='如果还是久攻不下的话，后果你们自己知道！', dur=3  },
	   		{ event='talk', delay=23.5, handle_id=5, talk='属下遵命！', dur=2  },

	   		{ event='kill', delay=26, handle_id=4},
	   		{ event='kill', delay=26, handle_id=5},
	   	},

	   	--昆阳城内刘秀商讨
	   	{
	   		{ event='init_cimera', delay = 0.2,mx= 2339,my = 288 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={2254,398}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={2381,344}, dir=5, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=34, pos={2322,436}, dir=1, speed=340, name_color=0xffffff, name="冯异"},
	    },

	    --刘秀，阴戟等商讨对策
	    {	
	   		{ event='talk', delay=0.1, handle_id=1, talk='三哥，听说新军找来什么奇人异士来攻打我们义军。', dur=3 },

	   		{ event='talk', delay=3.4, handle_id=2, talk='嗯，我已经收到前线的军报。', dur=2.5  },
	   		{ event='talk', delay=6.2, handle_id=2, talk='此次切不可掉以轻心，我打算亲自迎战。', dur=3 },

	   		{ event='talk', delay=9.5, handle_id=3, talk='战事变幻无常，切不可以身犯险。', dur=2.5 ,},
	   		{ event='talk', delay=12.3, handle_id=3, talk='刘将军，还望多加考虑！', dur=2.5 },

	   		{ event='talk', delay=15.1, handle_id=1, talk='冯将军所言极是。', dur=2 },
	   		{ event='talk', delay=17.4, handle_id=1, talk='三哥，你就不要去了吧。', dur=2.5  },

	   		{ event='talk', delay=20.2, handle_id=2, talk='我决心已定，你们无需再劝我了。', dur=2.5 },
	   		{ event='talk', delay=23, handle_id=2, talk='传令：出兵，迎战！', dur=2  },


	   		{ event='kill', delay=25.3, handle_id=1},
	   		{ event='kill', delay=25.3, handle_id=2},
	   		{ event='kill', delay=25.3, handle_id=3},
	   	},


	    --刷出丽华等人
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	   		-- { event='init_cimera', delay = 0.3,mx= 934,my = 770 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={1682,1606}, dir=3, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={1746,1580}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},

	    	{ event='createActor', delay=0.1, handle_id = 4, body=55, pos={2636,2060}, dir=7, speed=340, name_color=0xffffff, name="王匡"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=43, pos={2572,2096}, dir=7, speed=340, name_color=0xffffff, name="王寻"},
	    	{ event='createActor', delay=0.1, handle_id = 6, body=63, pos={2866,2286}, dir=7, speed=340, name_color=0xffffff, name="巨无霸"},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={1448,1488}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={1448+64,1488-32}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={1448+128,1488-64}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1448+194,1488-96}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 105, body=25, pos={1448+256,1488-128}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 106, body=25, pos={1486,1554}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 107, body=25, pos={1486+64,1554-32}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 108, body=25, pos={1486+128,1554-64}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 109, body=25, pos={1486+194,1554-96}, dir=3, speed=340, name_color=0xffffff, name="汉军"},
	    	{ event='createActor', delay=0.1, handle_id = 110, body=25, pos={1486+256,1554-128}, dir=3, speed=340, name_color=0xffffff, name="汉军"},

	    	{ event='createActor', delay=0.1, handle_id = 201, body=27, pos={2542,2192}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=27, pos={2542+64,2192-32}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=27, pos={2542+128,2192-64}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 204, body=27, pos={2542+194,2192-96}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 205, body=27, pos={2542+256,2192-128}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 206, body=28, pos={2576,2254}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 207, body=28, pos={2576+64,2254-32}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 208, body=28, pos={2576+128,2254-64}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 209, body=28, pos={2576+194,2254-96}, dir=7, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 210, body=28, pos={2576+256,2254-128}, dir=7, speed=340, name_color=0xffffff, name="新军"},

	    	{ event='createActor', delay=0.1, handle_id = 301, body=40, pos={2892,2352}, dir=7, speed=340, name_color=0xffffff, name="狮子"},
	    	{ event='createActor', delay=0.1, handle_id = 302, body=40, pos={2892+64,2352-32}, dir=7, speed=340, name_color=0xffffff, name="狮子"},
	    	{ event='createActor', delay=0.1, handle_id = 303, body=33, pos={2962,2406}, dir=7, speed=340, name_color=0xffffff, name="老虎"},
	    	{ event='createActor', delay=0.1, handle_id = 304, body=33, pos={2962+64,2406-32}, dir=7, speed=340, name_color=0xffffff, name="老虎"},
	    	{ event='createActor', delay=0.1, handle_id = 305, body=35, pos={3022,2468}, dir=7, speed=340, name_color=0xffffff, name="狼"},
	    	{ event='createActor', delay=0.1, handle_id = 306, body=35, pos={3022+64,2468-32}, dir=7, speed=340, name_color=0xffffff, name="狼"},
	   	},

	   	--叔父找到刘秀等人
	    {	
	    	{ event='init_cimera', delay = 0.2,mx= 1726,my = 1412 },
	    	{ event = 'camera', delay = 1.2, dur=3,sdur = 0.9,style = '',backtime=1, c_topox = { 2682,2032 } },
	    },
	    {
	    	{ event='talk', delay=0.1, handle_id=5, talk='刘秀，今日就是你们的兵败身亡之时！', dur=2.5},
	    	{ event='talk', delay=2.9, handle_id=5, talk='传我军令：进攻，剿灭反军！', dur=2.5},
	    	{ event='talk', delay=5.7, handle_id=203, talk='准备围困反军！', dur=2},
	    	{ event='talk', delay=5.7, handle_id=208, talk='准备围困反军！', dur=2},

	    	{ event = 'camera', delay = 8, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = { 2866,2286 } },

	    	{ event='talk', delay=8.8, handle_id=6, talk='百兽之力！所向无敌！', dur=2.5},
	    	{ event='playAction', delay=8.8, handle_id=6, action_id=2, dur=0.2, dir=7, loop= false },
	    	{ event='talk', delay=11.6, handle_id=301, talk='吼！！', dur=2},
	    	{ event='talk', delay=11.6, handle_id=304, talk='吼！！', dur=2},
	    	{ event='talk', delay=11.6, handle_id=305, talk='啊呜！', dur=2},
	   	},
    },

    ['juqing-ix050'] = 
	{
		--演员表 1 阴戟 2 刘秀 3 冯异 4 王匡 5 王寻 6 巨无霸 101-115 汉军 201-215 新军 301-306 狮子、老虎、狼
	 	--创建角色
	    --刷出丽华等人
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	   		{ event='init_cimera', delay = 0.3,mx= 2198,my = 1790 },
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={2122,1842}, dir=3, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={2192,1802}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=63, pos={2288,1922}, dir=7, speed=340, name_color=0xffffff, name="巨无霸"},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={57*32,54*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={61*32,60*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={71*32,53*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={77*32,57*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 105, body=25, pos={72*32,51*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 106, body=25, pos={78*32,64*32}, dir=1, speed=340, name_color=0xffffff, name=""},


	    	{ event='createActor', delay=0.1, handle_id = 201, body=27, pos={57*32,54*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=27, pos={63*32,62*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=28, pos={72*32,51*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 204, body=28, pos={77*32,59*32}, dir=1, speed=340, name_color=0xffffff, name=""},

	    	{ event='createActor', delay=0.1, handle_id = 301, body=40, pos={71*32,53*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 302, body=33, pos={65*32,59*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 303, body=33, pos={77*32,57*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 304, body=35, pos={78*32,64*32}, dir=1, speed=340, name_color=0xffffff, name=""},

	    	--死亡动作
	    	{ event='playAction', delay=0.2, handle_id=101, action_id=4, dur=0.4, dir=2, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=102, action_id=4, dur=0.4, dir=3, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=103, action_id=4, dur=0.4, dir=2, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=104, action_id=4, dur=0.4, dir=4, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=105, action_id=4, dur=0.4, dir=5, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=106, action_id=4, dur=0.4, dir=6, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=201, action_id=4, dur=0.4, dir=7, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=202, action_id=4, dur=0.4, dir=1, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=203, action_id=4, dur=0.4, dir=2, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=204, action_id=4, dur=0.4, dir=2, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=301, action_id=4, dur=0.4, dir=3, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=302, action_id=4, dur=0.4, dir=4, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=303, action_id=4, dur=0.4, dir=7, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=304, action_id=4, dur=0.4, dir=6, loop= false,once=true },

	   	},

	    --巨无霸做垂死挣扎
	    {
	    	
	    	{ event='talk', delay=0.1, handle_id=4, talk='刘秀！此仇不报，我誓不罢休！', dur=2.5, },

	    	{ event='talk', delay=2.9, handle_id=2, talk='新莽残暴无道，你居然逆天行事。', dur=2.5, },
	    	{ event='talk', delay=5.7, handle_id=2, talk='我送你上路！', dur=2.5, },
	    	{ event='talk', delay=8.5, handle_id=1, talk='三哥，不要和他啰嗦了。', dur=2.5, },
	    	{ event='talk', delay=11.3, handle_id=1, talk='速战速决吧！', dur=3, },
	    },

	    --刘秀阴戟发动协同攻击技能！伤害爆炸！
	    {
	    	-- { event='move', delay= 8.5, handle_id=1, end_dir=3, pos={917-64,855+32}, speed=340, dur=3 },
	    	-- { event='move', delay= 11.3, handle_id=2, end_dir=3, pos={917+64,855-32}, speed=340, dur=2.8 },

	    	{ event='move', delay=0.2, handle_id=1, dir=3, pos={ 2190,1940 }, speed=60, dur=0.8 ,end_dir = 2},
	    	{ event='move', delay=0.2, handle_id=2, dir=3, pos={ 2256,1872 }, speed=60, dur=0.8 ,end_dir = 3},

	    	{ event='playAction', delay=0.6, handle_id=1, action_id=2, dur=0.2, dir=2, loop= false, },
	    	{ event='playAction', delay=0.6, handle_id=2, action_id=2, dur=0.2, dir=3, loop= false, },


	    	{ event='playAction', delay=0.8, handle_id=4, action_id=4, dur=0.2, dir=3, loop= false,once=true },
	    	{ event='talk', delay=0.6, handle_id=4, talk='啊———', dur=3, },
	    },


	    --冯异出现，收兵
	    {
	    	-- { event='init_cimera', delay = 0.3,mx= 2198,my = 1790 },
	    	{ event='createActor', delay=0.1, handle_id = 3, body=34, pos={1840,1578}, dir=5, speed=340, name_color=0xffffff, name="冯异"},

	    	{ event='move', delay= 0.2, handle_id=3, end_dir=3, pos={2138,1846}, speed=240, dur=3 },

	    	{ event='move', delay=1.2, handle_id=1, dir=3, pos={ 2190,1940 }, speed=80, dur=0.8 ,end_dir = 7},
	    	{ event='move', delay=1.2, handle_id=2, dir=3, pos={ 2256,1872 }, speed=80, dur=0.8 ,end_dir = 7},
			{ event='talk', delay=1.2, handle_id=3, talk='刘将军，昆阳之围已破！', dur=2.5, },
			{ event='talk', delay=4, handle_id=3, talk='我们快收兵回城休整一下吧。', dur=2.5, },

	    	
	    	{ event='talk', delay=6.8, handle_id=2, talk='好！', dur=2, },
			{ event='talk', delay=9.1, handle_id=2, talk='传令：收兵，回城。', dur=2.5, },
	    },
	},

	--============================================wuwenbin  每日剧情25 end  =====================================----

	--============================================wuwenbin  每日剧情26 start  =====================================----
   	['juqing-ix051'] = 
	{
		--演员表 1 阴戟 2 刘秀 3 刘玄 4 王凤 5 张卬 6 新军将领 101-108 汉军 201-208 新军
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 3528,my = 1780 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={3304,1934}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={3374,1878}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=24, pos={3468,1816}, dir=5, speed=340, name_color=0xffffff, name="刘玄"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=9, pos={3428,1900}, dir=1, speed=340, name_color=0xffffff, name="王凤"},
	    	{ event='createActor', delay=0.1, handle_id = 5, body=54, pos={3370,1968}, dir=1, speed=340, name_color=0xffffff, name="张卬"},
	    },

	    --刘秀刘縯商议
	    {	
	   		{ event='talk', delay=0.1, handle_id=3, talk='今日我刘玄刘圣公得以登上这帝王之位。', dur=3 },
	   		{ event='talk', delay=3.3, handle_id=3, talk='多亏众位将士拼死搏杀。', dur=2.5  },
	   		{ event='talk', delay=6.1, handle_id=3, talk='朕，将封赏全军！', dur=2.5 ,},

	   		{ event='talk', delay=8.9, handle_id=4, talk='陛下，言重了！', dur=2.5  },
	   		{ event='talk', delay=11.7, handle_id=4, talk='这些都是我们做臣子的本分。', dur=3 ,},

	   		{ event='talk', delay=15, handle_id=2, talk='陛下，臣诚惶诚恐！', dur=2.5  },
	   		{ event='talk', delay=17.7, handle_id=2, talk='新莽与我有国仇家恨，秀自当竭尽全力杀敌！', dur=2.5  },
	   	},

	   	--阴戟心里暗自嘀咕
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ix26_1" ,dialog_time = 2.5,dur = 5},
	   	},

	   	--张卬心里打小算盘
	   	{
	   		{ event='showTopTalk', delay=0.5, dialog_id="ix26_2" ,dialog_time = 2.5,dur = 5.5},
	   	},

	   	--众人消失
	   	{
	   		{ event='kill', delay=0.1, handle_id=1},
	   		{ event='kill', delay=0.1, handle_id=2},
	   		{ event='kill', delay=0.1, handle_id=3},
	   		{ event='kill', delay=0.1, handle_id=4},
	   		{ event='kill', delay=0.1, handle_id=5},
	   	},

	   	--新军打算剿灭绿林军
	   	{
	   		{ event='init_cimera', delay = 0.2,mx= 1654,my = 2530 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 6, body=43, pos={1714,2668}, dir=3, speed=340, name_color=0xffffff, name="新军将领"},
	    	{ event='createActor', delay=0.1, handle_id = 7, body=57, pos={2034,2896}, dir=7, speed=340, name_color=0xffffff, name="新军"},

	    	{ event='createActor', delay=0.1, handle_id = 201, body=57, pos={1484,2608}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=57, pos={1484+64,2608-32}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=57, pos={1484+128,2608-64}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 204, body=57, pos={1484+192,2608-96}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 205, body=57, pos={1552,2670}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 206, body=57, pos={1552+64,2670-32}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 207, body=57, pos={1552+128,2670-64}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    	{ event='createActor', delay=0.1, handle_id = 208, body=57, pos={1552+192,2670-96}, dir=3, speed=340, name_color=0xffffff, name="新军"},
	    },

	    --刘秀，阴戟等商讨对策
	    {	
	   		{ event='move', delay=0.1, handle_id=7, dir=3, pos={ 1802,2736 }, speed=240, dur=0.8 ,end_dir = 7},

	   		{ event='talk', delay=0.8, handle_id=7, talk='报告将军：属下探明刘玄等反贼，', dur=2.5  },
	   		{ event='talk', delay=3.6, handle_id=7, talk='正在筹谋称王立帝的阴谋！', dur=2.5 },

	   		{ event='talk', delay=6.4, handle_id=6, talk='这群乌合之众！', dur=2.5 ,},
	   		{ event='talk', delay=9.2, handle_id=6, talk='当皇帝？我这就送他们一程！', dur=2.5 },
	   		{ event='talk', delay=12, handle_id=6, talk='来人啊！出兵，剿灭反贼。', dur=2.5 },

	   		{ event='talk', delay=14.8, handle_id=201, talk='是，将军！', dur=2.5  },
	   		{ event='talk', delay=14.8, handle_id=203, talk='是，将军！', dur=2.5  },
	   		{ event='talk', delay=14.8, handle_id=205, talk='是，将军！', dur=2.5  },
	   		{ event='talk', delay=14.8, handle_id=207, talk='是，将军！', dur=2.5  },

	   		{ event='kill', delay=17, handle_id=6},
	   		{ event='kill', delay=17, handle_id=7},
	   		{ event='kill', delay=17, handle_id=201},
	   		{ event='kill', delay=17, handle_id=202},
	   		{ event='kill', delay=17, handle_id=203},
	   		{ event='kill', delay=17, handle_id=204},
	   		{ event='kill', delay=17, handle_id=205},
	   		{ event='kill', delay=17, handle_id=206},
	   		{ event='kill', delay=17, handle_id=207},
	   		{ event='kill', delay=17, handle_id=208},
	   	},

	   	{
	   		{ event='init_cimera', delay = 0.2,mx= 3292,my = 1894 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={3356,1894}, dir=5, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={3276,1938}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=54, pos={3058,2194}, dir=1, speed=340, name_color=0xffffff, name="张卬"},
	    },

	    --张卬通报新军来犯
	    {	
	   		{ event='move', delay=0.1, handle_id=3, dir=3, pos={ 3188,1992 }, speed=280, dur=0.8 ,end_dir = 1},
	   		{ event='move', delay=0.8, handle_id=2, dir=3, pos={ 3276,1938 }, speed=280, dur=0.8 ,end_dir = 5},

	   		{ event='talk', delay=0.8, handle_id=3, talk='不好啦，新军打进来了！', dur=2.5  },
	   		{ event='talk', delay=3.6, handle_id=3, talk='大家快来迎敌啊！', dur=2.5 ,},

	   		{ event='talk', delay=6.4, handle_id=2, talk='大家莫要惊慌，保护陛下！', dur=2.5  },
	   		{ event='talk', delay=9.2, handle_id=2, talk='其余将士随我杀敌。', dur=2.5 ,},

	   		{ event='move', delay=12, handle_id=1, dir=3, pos={ 3356-16,1894+16 }, speed=220, dur=0.8 ,end_dir = 5},
	   		{ event='talk', delay=12, handle_id=1, talk='三哥，小心啊！', dur=2.5  },

	   		{ event='kill', delay=15, handle_id=1},
	   		{ event='kill', delay=15, handle_id=2},
	   		{ event='kill', delay=15, handle_id=3},
	   	},

    },

    ['juqing-ix052'] = 
	{
		--演员表 1 阴戟 2 刘秀 3 刘玄 4 王凤 5 张卬 6 新军将领 101-108 汉军 201-208 新军
	 	--创建角色
	    --刷出丽华等人
	    {	
	    	-- { event='createActor', delay=0.1, handle_id = 203, body=22, pos={2928,462}, dir=5, speed=340, name_color=0xffffff, name="刺客"},
	   		{ event='init_cimera', delay = 0.3,mx= 2910,my = 2630 },
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=5, pos={2806,2768}, dir=1, speed=340, name_color=0xffffff, name="阴戟"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=12, pos={2860,2722}, dir=1, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=24, pos={2960,2670}, dir=5, speed=340, name_color=0xffffff, name="刘玄"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=54, pos={2920,2758}, dir=1, speed=340, name_color=0xffffff, name="张卬"},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=57, pos={82*32,80*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={97*32,79*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 103, body=57, pos={85*32,78*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={97*32,85*32}, dir=1, speed=340, name_color=0xffffff, name=""},

	    	{ event='createActor', delay=0.1, handle_id = 201, body=57, pos={84*32,88*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 202, body=57, pos={89*32,90*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 203, body=28, pos={97*32,79*32}, dir=1, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 204, body=28, pos={97*32,88*32}, dir=1, speed=340, name_color=0xffffff, name=""},


	    	--死亡动作
	    	{ event='playAction', delay=0.2, handle_id=101, action_id=4, dur=0.2, dir=2, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=102, action_id=4, dur=0.2, dir=3, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=103, action_id=4, dur=0.2, dir=3, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=104, action_id=4, dur=0.2, dir=4, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=201, action_id=4, dur=0.2, dir=7, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=202, action_id=4, dur=0.2, dir=1, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=203, action_id=4, dur=0.2, dir=1, loop= false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=204, action_id=4, dur=0.2, dir=2, loop= false,once=true },

	   	},

	    --刘秀劝诫刘玄早点准备应对新军
	    {
	    	{ event='talk', delay=0.1, handle_id=3, talk='辛苦众位将士了！', dur=2.5, },
	    	{ event='talk', delay=2.9, handle_id=3, talk='大家清扫战场，回营休整吧！', dur=2.5, },

	    	-- { event='move', delay=0.2, handle_id=1, dir=3, pos={ 2190,1940 }, speed=60, dur=0.8 ,end_dir = 2},
	    	{ event='talk', delay=5.7, handle_id=2, talk='陛下，我们应该早做安排才是啊！', dur=2.5, },
	    	{ event='talk', delay=8.5, handle_id=2, talk='不然新军还会来犯的。', dur=2.5, },

	    	{ event='move', delay=11.3, handle_id=2, dir=3, pos={ 2860,2722 }, speed=60, dur=0.8 ,end_dir = 3},
	    	{ event='move', delay=11.3, handle_id=4, dir=3, pos={ 2920,2758 }, speed=60, dur=0.8 ,end_dir = 7},
	    	{ event='talk', delay=11.3, handle_id=4, talk='刘将军，不必多虑。', dur=2.5, },
	    	{ event='talk', delay=14.1, handle_id=4, talk='有我们在，新军来一次，败一次！', dur=3, },
	    },

	    --刘玄先回营
	    {
	    	{ event='move', delay=0.1, handle_id=2, dir=3, pos={ 2860,2722 }, speed=60, dur=0.8 ,end_dir = 1},
	    	{ event='move', delay=0.1, handle_id=4, dir=3, pos={ 2920,2758 }, speed=60, dur=0.8 ,end_dir = 1},
	    	{ event='talk', delay=0.1, handle_id=4, talk='陛下，战场不宜久留，还是先行回营吧！', dur=2.5, },
	    	{ event='talk', delay=2.9, handle_id=3, talk='好。', dur=2.5, },

	    	{ event='move', delay=5.7, handle_id=3, dir=3, pos={ 3054,2194 }, speed=280, dur=1.5 ,end_dir = 2},
	    	{ event='move', delay=5.7, handle_id=4, dir=3, pos={ 3054,2194 }, speed=280, dur=1.5 ,end_dir = 2},

	    	{ event='kill', delay=8, handle_id=3},
	   		{ event='kill', delay=8, handle_id=4},
	    },

	    --阴戟上前劝解刘秀
	    {
	    	{ event = 'camera', delay = 0.1, dur=0.5,sdur = 0.5,style = '',backtime=1, c_topox = { 2832,2710 } },
	    	{ event='move', delay=0.1, handle_id=2, dir=3, pos={ 2860,2722 }, speed=60, dur=11.5 ,end_dir = 5},

	    	{ event='talk', delay=0.1, handle_id=1, talk='三哥，算了吧！', dur=2.5, },
	    	{ event='talk', delay=2.9, handle_id=1, talk='他们是不会听我们所言的。', dur=2.5, },
			{ event='talk', delay=5.7, handle_id=2, talk='唉，如此乱世，还不能一心抗敌。', dur=2.5, },
	    	{ event='talk', delay=8.5, handle_id=2, talk='看来我们真的不是一路人啊！', dur=2.5, },
	    },

	},

	--============================================wuwenbin  每日剧情26 end  =====================================----



----=====================================================================长歌行支线任务剧情动画配置 END =====================================================-------  


----=====================================================================长歌行活动任务剧情动画配置 START =====================================================------- 
    --============================================luozhenhuai  诛莽复汉 staet=====================================----
	['juqing-ac001']=
	{
		---演员表 1 王莽 2随从1 3随从2 4随从3 5随从4 6宫女 7汉军将士1 8汉军将士2 9汉军将士3 10汉军将士4
		---创建角色
		{	
			--{ event='showTopTalk', delay=0.2, dialog_id="ac1_1" ,dialog_time = 3.2},
	    	{ event='init_cimera', delay = 0.1,mx= 1450,my = 1646},		
			{ event = 'changeRGBA',delay=0.1,dur=3,cont_time=4,txt = "地皇四年，更始元年，汉复元年，天水人隗嚣率众起兵应汉，发出檄文，披露王莽慢侮天地，悖道逆理，甚至鸩杀孝平皇帝，篡夺其位的滔天大罪，檄文遍传天下，四方响应。"}, 
	   		{ event='createActor', delay=0.1, handle_id = 1, body=53, pos={1484,1712}, dir=7, speed=340, name_color=0xffffff, name="王莽"},
	   		{ event='createActor', delay=0.1, handle_id = 2, body=27, pos={1262,1774}, dir=7, speed=340, name_color=0xffffff, name="禁军守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 3, body=27, pos={1518,1548}, dir=7, speed=340, name_color=0xffffff, name="禁军守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 4, body=27, pos={1806,1678}, dir=7, speed=340, name_color=0xffffff, name="禁军守卫"},
	   		{ event='createActor', delay=0.1, handle_id = 5, body=27, pos={1486,1932}, dir=7, speed=340, name_color=0xffffff, name="禁军守卫"},
		},
		---跑，说话
		{
			{ event = 'camera', delay = 0.2, dur=1,sdur = 0.5,target_id = 1 ,style = 'follow',backtime=0.1, },
	    	{ event='move', delay= 0.1, handle_id= 1, dir=5, pos= {752,1360},speed=340, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.1, handle_id= 2, dir=5, pos= {526,1422},speed=340, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.1, handle_id= 3, dir=5, pos= {782,1198},speed=340, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.1, handle_id= 4, dir=5, pos= {1040,1328},speed=340, dur=0.3, end_dir=3 }, 
	    	{ event='move', delay= 0.1, handle_id= 5, dir=5, pos= {748,1582},speed=340, dur=0.3, end_dir=3 },
	    	{ event='talk', delay=4.3, handle_id=1, talk='上天把治理国家的使命交给我。', dur=2},
	    	{ event='talk', delay=6.5, handle_id=1, talk='乱贼能把我怎么样！', dur=2.5},
		},  
		{
			{ event='kill', delay=0.1, handle_id=1}, 
			{ event='kill', delay=0.1, handle_id=2}, 
			{ event='kill', delay=0.1, handle_id=3}, 
			{ event='kill', delay=0.1, handle_id=4}, 
			{ event='kill', delay=0.1, handle_id=5}, 

		},
		{              
		---士兵杀王莽
	   		{ event='createActor', delay=0.1, handle_id = 6, body=41, pos={494,876}, dir=5, speed=340, name_color=0xffffff, name="宫女"},
	   		{ event='createActor', delay=0.1, handle_id = 7, body=57, pos={1386,1772}, dir=7, speed=340, name_color=0xffffff, name="起义军"},
	   		{ event='createActor', delay=0.1, handle_id = 8, body=57, pos={1518,1646}, dir=7, speed=340, name_color=0xffffff, name="起义军"},
	   		{ event='createActor', delay=0.1, handle_id = 9, body=57, pos={1674,1740}, dir=7, speed=340, name_color=0xffffff, name="起义军"},
	   		{ event='createActor', delay=0.1, handle_id = 10, body=57, pos={1552,1870}, dir=7, speed=340, name_color=0xffffff, name="起义军"},
	   	},
	   	{
	   		{ event='init_cimera', delay = 0.1,mx= 1484,my = 1710},	
			{ event = 'camera', delay = 0.2, dur=0.1,sdur = 0.5,target_id = 8 ,style = 'follow',backtime=1, },
	   	---士兵边跑冒泡
	    	{ event='move', delay= 0.1, handle_id= 7, dir=7, pos= {650,1426},speed=340, dur=0.3, end_dir=7 },  
	    	{ event='move', delay= 0.1, handle_id= 8, dir=7, pos= {780,1296},speed=340, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.1, handle_id= 9, dir=7, pos= {944,1388},speed=340, dur=0.3, end_dir=7 }, 
	    	{ event='move', delay= 0.1, handle_id= 10, dir=7, pos= {814,1520},speed=340, dur=0.3, end_dir=7 },
	    	{ event='talk', delay=0.1, handle_id=7, talk='杀王莽！', dur=2.5},
	    	{ event='talk', delay=0.1, handle_id=8, talk='杀王莽！', dur=2.5},
	    	{ event='talk', delay=0.1, handle_id=9, talk='杀王莽！', dur=2.5},
	    	{ event='talk', delay=0.1, handle_id=10, talk='杀王莽！', dur=2.5},
	   	---宫女跑出
	   		{ event='move', delay= 2.5, handle_id= 6, dir=3, pos= {586,1260},speed=340, dur=0.3, end_dir=3 }, --宫女跑出停下
	    	{ event='talk', delay=5, handle_id=6, talk='啊！', dur=2, emote = { a =41}},---宫女惊恐
	   		{ event='move', delay= 6.5, handle_id= 8, dir=7, pos= {654,1298},speed=340, dur=0.3, end_dir=7 }, --将士往前
	    	{ event='talk', delay=8, handle_id=8, talk='反贼王莽在哪里？', dur=3},
	    	{ event='talk', delay=11, handle_id=6, talk='在……在内室……', dur=1},
	    	{ event='talk', delay=12, handle_id=2, talk='走！', dur=1},
	    	{ event='move', delay= 13, handle_id= 7, dir=5, pos= {940,484},speed=340, dur=0.3, end_dir=5 }, ---冲入内室
	    	{ event='move', delay= 13, handle_id= 8, dir=5, pos= {940,484},speed=340, dur=0.3, end_dir=5 }, 
	    	{ event='move', delay= 13, handle_id= 9, dir=5, pos= {940,484},speed=340, dur=0.3, end_dir=5 }, 
	    	{ event='move', delay= 13, handle_id= 10, dir=5, pos= {940,484},speed=340, dur=0.3, end_dir=5 },
	    	{ event='move', delay= 14, handle_id= 6, dir=5, pos= {1708,1840},speed=340, dur=0.3, end_dir=5 },---宫女跑
	    	{ event='talk', delay=13, handle_id=7, talk='杀——！', dur=2.5},
	    	{ event='talk', delay=13, handle_id=8, talk='杀——！', dur=2.5},
	    	{ event='talk', delay=13, handle_id=9, talk='杀——！', dur=2.5},
	    	{ event='talk', delay=13, handle_id=10, talk='杀——！', dur=2.5}, 
	    },
	},

	['juqing-ac002']=
	{
		{
		---演员表 1公宾就 2杜吴 3汉军将士 4汉军将士 5汉军将士 6汉军将士 7汉军将士 8汉军将士 9汉军将士 10王莽
			{ event='init_cimera', delay = 0.1,mx= 1793,my = 420},	
			{ event='createActor', delay=0.1, handle_id = 1, body=55, pos={1642-200,526}, dir=1, speed=340, name_color=0xffffff, name="公宾就"},
			{ event='createActor', delay=0.1, handle_id = 2, body=34, pos={1742-200,586}, dir=1, speed=340, name_color=0xffffff, name="杜吴"},
			{ event='createActor', delay=0.1, handle_id = 3, body=57, pos={1520-200,524}, dir=1, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 4, body=57, pos={1550-200,426}, dir=2, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 5, body=57, pos={1680-200,392}, dir=3, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 6, body=57, pos={1838-200,428}, dir=5, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 7, body=57, pos={1932-200,494}, dir=6, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 8, body=57, pos={1870-200,588}, dir=7, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 9, body=57, pos={1774-200,686}, dir=7, speed=340, name_color=0xffffff, name="起义军"},
			{ event='createActor', delay=0.1, handle_id = 10, body=53, pos={1742-200,492}, dir=7, speed=340, name_color=0xffffff, name="王莽"},
			{ event='playAction', delay=0.2, handle_id=10, action_id=4, dur=8, dir=2, loop= false,once=true },
			{ event='talk', delay=2, handle_id=1, talk='我等分裂莽身，人人有份，各持一块，留待明日请赏。', dur=3},
			{ event='talk', delay=5.5, handle_id=2, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=3, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=4, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=5, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=6, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=7, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=8, talk='好——！', dur=1.5},
			{ event='talk', delay=5.5, handle_id=9, talk='好——！', dur=1.5},
	    	-- { event='move', delay=7.2, handle_id= 3, dir=1, pos= {1742-200,494},speed=340, dur=0.3, end_dir=1 }, 
	    	-- { event='move', delay=7.2, handle_id= 4, dir=2, pos= {1742-200,494},speed=340, dur=0.3, end_dir=2 }, 
	    	-- { event='move', delay=7.2, handle_id= 5, dir=3, pos= {1742-200,494},speed=340, dur=0.3, end_dir=3 }, 
	    	-- { event='move', delay=7.2, handle_id= 6, dir=5, pos= {1742-200,494},speed=340, dur=0.3, end_dir=5 }, 
	    	-- { event='move', delay=7.2, handle_id= 7, dir=6, pos= {1742-200,494},speed=340, dur=0.3, end_dir=6 }, 
	    	-- { event='move', delay=7.2, handle_id= 8, dir=7, pos= {1742-200,494},speed=340, dur=0.3, end_dir=7 }, 
	    	-- { event='move', delay=7.2, handle_id= 9, dir=7, pos= {1742-200,494},speed=340, dur=0.3, end_dir=7 }, 
	   },
	},
	--============================================luozhenhuai  诛莽复汉 end =====================================----
--============================================luyao  帝魂惊梦  start   =====================================----
    ['juqing-ac003'] =
    {
    	{
	    	{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={1198,211}, dir=3, speed=340, name_color=0xffffff, name="阴丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=3, pos={1236+100,335+100}, dir=7, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=23, pos={1331+100,342+100}, dir=7, speed=340, name_color=0xffffff, name="蔡少公"},
	    	{ event='createActor', delay=0.1, handle_id = 4, body=19, pos={1394+100,268+100}, dir=7, speed=340, name_color=0xffffff, name="严子陵"},	
	    	{ event='playAction', delay=0.2, handle_id=1, action_id=4, dur=0.2, dir=1, loop=false,once=true },	    	    		    	
    	},
    	{
	    	{ event='init_cimera', delay = 0.1,mx= 1430,my = 352},
	    	{ event='talk', delay=1, handle_id=2, talk='为何丽华还是无法醒转？', dur=2.5, },

	   		{ event='move', delay= 4, handle_id=2, end_dir=1, pos={1236+100,335+100}, speed=220, dur=1.5 },	    	
	    	{ event='talk', delay=3.8, handle_id=4, talk='此为梦魇，而梦者，必有心病。', dur=2.5, },
	    	{ event='talk', delay=6.6, handle_id=3, talk='子陵说的没错，需尽快找到诱因，否则……', dur=2.5, },
	    	--{ event='talk', delay=9.4, handle_id=1, talk='刘……刘玄……别，别过来……', dur=2.5, },
    	},
    	{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ac2_1" ,dialog_time = 3,dur = 3},
    	},
    	{
	   		{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={1236+100,335+100}, speed=220, dur=0.2 },	    	
	    	{ event='talk', delay=0.2, handle_id=2, talk='！', dur=1.5, },
	    	{ event='talk', delay=0.2, handle_id=3, talk='！', dur=1.5, },
	    	{ event='talk', delay=0.2, handle_id=4, talk='！', dur=1.5, },
    	},
    	{
	    	{ event='talk', delay=0.1, handle_id=4, talk='原来是刘玄！', dur=2.5, },
	    	{ event='talk', delay=2.8, handle_id=2, talk='他不是已经死了吗？', dur=2, },
	    	{ event='talk', delay=5, handle_id=3, talk='人死如生，在另一个世界里灵魂会继续生活，只是没有了肉体。', dur=3.5, },
	    	{ event='talk', delay=9.9, handle_id=2, talk='既然如此，我绝不能让他伤害丽华！', dur=2.5, },
	    	{ event='talk', delay=13, handle_id=3, talk='没错，一定要想法子尽快将其驱逐出丽华的梦境。', dur=2.5, },

    	},
    	{
	   		{ event='init_cimera', delay = 1,mx=1058 ,my = 1618},		
			{event='changeRGBA', delay=0.1, txt="丽华梦境……",cont_time=0.8, light_time=0.8, txt_time=0.1, black_time=0.1},

	    	{ event='createActor', delay=0.1, handle_id = 11, body=6, pos={978,1573}, dir=7, speed=340, name_color=0xffffff, name="阴丽华"},
	    	{ event='createActor', delay=0.1, handle_id = 12, body=24, pos={1326,1829}, dir=7, speed=340, name_color=0xffffff, name="刘玄"},
	    	{ event='createActor', delay=0.1, handle_id = 13, body=41, pos={889,1750}, dir=7, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 14, body=19, pos={1116,1711}, dir=7, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 15, body=41, pos={1102,1405}, dir=5, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 16, body=19, pos={1174,1500}, dir=7, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 17, body=41, pos={1186,1590}, dir=7, speed=340, name_color=0xffffff, name=""},
	    	{ event='createActor', delay=0.1, handle_id = 18, body=19, pos={978-50,1573-50}, dir=7, speed=340, name_color=0xffffff, name=""},	

	    	{ event='playAction', delay=0.2, handle_id=13, action_id=4, dur=0.5, dir=1, loop=false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=14, action_id=4, dur=0.5, dir=3, loop=false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=15, action_id=4, dur=0.5, dir=2, loop=false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=16, action_id=4, dur=0.5, dir=5, loop=false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=17, action_id=4, dur=0.5, dir=7, loop=false,once=true },
	    	{ event='playAction', delay=0.2, handle_id=18, action_id=4, dur=0.5, dir=6, loop=false,once=true },

	    	{ event='effect',  delay = 0.1 ,handle_id=1001,  pos={914,1277}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1002,  pos={694,1300}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1003,  pos={525,1390}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1004,  pos={505,1600}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1005,  pos={612,1703}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1006,  pos={834,1835}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1007,  pos={1053,1846}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1008,  pos={1317,1837}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1009,  pos={1510,1586}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=1010,  pos={1383,1437}, effect_id=20005, is_forever = true},


		},
		{
	   		{ event='move', delay= 0.1, handle_id=12, end_dir=7, pos={998+80,1572+60}, speed=650, dur=2 },
	    	{ event='talk', delay=0.1, handle_id=12, talk='啧啧……', dur=2.5, },
	    	{ event='talk', delay=2.8, handle_id=12, talk='这些无辜的百姓可都是你杀的。', dur=2.5, },
	    	{ event='talk', delay=6.6, handle_id=12, talk='果然是野性难除的狼崽子！', dur=3, },
	    	{ event='talk', delay=9.9, handle_id=12, talk='丽华，你我乃是同一类人！', dur=2.5, },

	   		{ event='move', delay= 12.5, handle_id=11, end_dir=3, pos={978,1573}, speed=650, dur=2 },	    	
	    	{ event='talk', delay=13, handle_id=11, talk='……', dur=2, },
		},
		{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ac2_2" ,dialog_time = 3,dur = 3},
		},
		{
	   		{ event='move', delay= 0.1, handle_id=12, end_dir=7, pos={1326+50,1729+50}, speed=650, dur=0.5 },
	    	{ event='talk', delay=1, handle_id=12, talk='朕愿做高皇帝，你可愿当朕的高皇后？', dur=2.5, },

	    	{ event='effect',  delay = 3 ,handle_id=1101,  pos={914+100,1277}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 3 ,handle_id=1102,  pos={694+300,1300-50}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 3 ,handle_id=1103,  pos={525+300,1390-100}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 3 ,handle_id=1104,  pos={505+600,1600-200}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 3 ,handle_id=1105,  pos={612+350,1703-200}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 3 ,handle_id=1106,  pos={834+400,1835}, effect_id=20005, is_forever = true},

	    	{ event='effect',  delay = 4 ,handle_id=1206, target_id=11, pos={0,120}, effect_id=10131, is_forever = true},
	    	{ event='talk', delay=4.5, handle_id=11, talk='我……愿意……', dur=2.5, },
	   		{ event='move', delay= 5, handle_id=11, end_dir=7, pos={998+80,1572+60}, speed=650, dur=2 },

	   		{ event='showTopTalk', delay=5.8, dialog_id="ac2_3" ,dialog_time = 3,dur = 3},
		},

		{
	    	{ event='talk', delay=0.1, handle_id=12, talk='！', dur=2.5, },
	    	{ event='talk', delay=2.8, handle_id=12, talk='怎么了？丽华，快随我来啊。', dur=2.5, },

	   		{ event='move', delay= 6.1, handle_id=11, end_dir=3, pos={998+80,1572+60}, speed=650, dur=0.5 },

	    	{ event='talk', delay=6.6, handle_id=11, talk='不！ 我不能随你去。', dur=2, },
	    	{ event='talk', delay=8.8, handle_id=12, talk='哼！', dur=1.5, },
	    	{ event='talk', delay=11.6, handle_id=12, talk='朕才是天子！你得陪朕一起……', dur=2.5, },

	    	{ event='talk', delay=14.4, handle_id=11, talk='你别做梦了，我不会陪你一起去死的！', dur=2.5, },	    	
		},
		{
	   		{ event='move', delay= 0.1, handle_id=11, end_dir=5, pos={998-200,1572-200}, speed=350, dur=1.5 },
		},
    },



    ['juqing-ac004'] =
    {
    	{
	    	{ event='effect',  delay = 0.1 ,handle_id=10001,  pos={1203,1385}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10002,  pos={937,1306}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10003,  pos={897,1769}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10004,  pos={685,1627}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10005,  pos={473,1562}, effect_id=20005, is_forever = true},	    	
	    	{ event='effect',  delay = 0.1 ,handle_id=10006,  pos={726,1198}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10007,  pos={228,1351}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10008,  pos={123,1154}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10009,  pos={680,1061}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 0.1 ,handle_id=10010,  pos={449,854}, effect_id=20005, is_forever = true},    	
	    	--{ event='createActor', delay=0.1, handle_id = 1, body=6, pos={888,1480}, dir=7, speed=340, name_color=0xffffff, name="阴丽华"},

			{ event="createSpEntity",delay=0.1, handle_id=1, name="06",name_color=0xffffff,actor_name="阴丽华", action_id=5, dir=7, pos={888,1480}},	    	
	    	{ event='createActor', delay=0.1, handle_id = 2, body=24, pos={888+120,1480+80}, dir=7, speed=340, name_color=0xffffff, name="刘玄"},
	   		{ event='init_cimera', delay = 0.2,mx=780 ,my = 1444},	
    	},
    	{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={570,1310}, speed=350, dur=0.5 },
	   		{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={570+200,1310+120}, speed=350, dur=0.5 },
	   		{ event='move', delay= 1.4, handle_id=2, end_dir=3, pos={570-120,1310-120}, speed=50, dur=1.5 },   	   		
	   		{ event = 'camera', delay = 1.4, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = { 500,1150 } },	 
 	
	    	{ event='talk', delay=2, handle_id=2, talk='丽华！你知道吗？没有我的保护，会有很多冤魂缠着你的！', dur=2.5, },   	   		  			   		
    	},

    	{
	    	{ event='createActor', delay=0.1, handle_id = 11, body=41, pos={563,951}, dir=3, speed=340, name_color=0xffffff, name="冤魂"},
	    	{ event='createActor', delay=0.1, handle_id = 12, body=19, pos={213,923}, dir=3, speed=340, name_color=0xffffff, name="冤魂"},
	    	{ event='createActor', delay=0.1, handle_id = 13, body=41, pos={184,1117}, dir=3, speed=340, name_color=0xffffff, name="冤魂"},
	    	{ event='createActor', delay=0.1, handle_id = 14, body=19, pos={491,1609}, dir=7, speed=340, name_color=0xffffff, name="冤魂"},
	    	{ event='createActor', delay=0.1, handle_id = 15, body=41, pos={966,1373}, dir=7, speed=340, name_color=0xffffff, name="冤魂"},
	    	--{ event='createActor', delay=0.1, handle_id = 16, body=19, pos={1174,1500}, dir=7, speed=340, name_color=0xffffff, name="冤魂"},
	    	--{ event='createActor', delay=0.1, handle_id = 17, body=41, pos={1186,1590}, dir=7, speed=340, name_color=0xffffff, name="冤魂"},
	    	--{ event='createActor', delay=0.1, handle_id = 18, body=19, pos={978-50,1573-50}, dir=7, speed=340, name_color=0xffffff, name="冤魂"},

	    	{ event='setOpacity', delay=0.2, handle_id=11, opacity=125}, --半透明
			{ event='setOpacity', delay=0.2, handle_id=12, opacity=125}, --半透明
			{ event='setOpacity', delay=0.2, handle_id=13, opacity=125}, --半透明
			{ event='setOpacity', delay=0.2, handle_id=14, opacity=125}, --半透明
			{ event='setOpacity', delay=0.2, handle_id=15, opacity=125}, --半透明
			--{ event='setOpacity', delay=0.2, handle_id=16, opacity=125}, --半透明
			--{ event='setOpacity', delay=0.2, handle_id=17, opacity=125}, --半透明
			--{ event='setOpacity', delay=0.2, handle_id=18, opacity=125}, --半透明

			{ event='moveParabola', delay=0.3, handle_id=11, pos={650,1174}, high=0, time=3, end_act_id=0, end_dir=5, end_loop=true },
			{ event='moveParabola', delay=0.3, handle_id=12, pos={372,1162}, high=0, time=3, end_act_id=0, end_dir=3, end_loop=true },
			{ event='moveParabola', delay=0.3, handle_id=13, pos={382,1319}, high=0, time=3, end_act_id=0, end_dir=2, end_loop=true },
			{ event='moveParabola', delay=0.3, handle_id=14, pos={428,1439}, high=0, time=3, end_act_id=0, end_dir=1, end_loop=true },
			{ event='moveParabola', delay=0.3, handle_id=15, pos={741,1302}, high=0, time=3, end_act_id=0, end_dir=6, end_loop=true },
			--{ event='moveParabola', delay=3.8, handle_id=16, pos={1174,1500}, high=0, time=0.1, end_act_id=0, end_dir=7, end_loop=true },
			--{ event='moveParabola', delay=3.8, handle_id=17, pos={1186,1590}, high=0, time=0.1, end_act_id=0, end_dir=7, end_loop=true },
			--{ event='moveParabola', delay=3.8, handle_id=18, pos={978-50,1573-50}, high=0, time=0.1, end_act_id=0, end_dir=7, end_loop=true },	   		
    	},
    	{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=1, pos={570,1310}, speed=350, dur=0.5 },
	   		{ event='move', delay= 0.8, handle_id=1, end_dir=5, pos={570,1310}, speed=350, dur=0.5 },
	   		{ event='move', delay= 1.6, handle_id=1, end_dir=7, pos={570,1310}, speed=350, dur=0.5 },

	    	{ event='talk', delay=2.2, handle_id=1, talk='啊——！！！', dur=2.5, },
	    	{ event='playAction', delay=4, handle_id=1, action_id=5, dur=1.5, dir=2, loop=true , },

	    	{ event='effect',  delay = 4.5 ,handle_id=1101,  pos={650,1174}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 4.5 ,handle_id=1102,  pos={372,1162}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 4.5 ,handle_id=1103,  pos={382,1319}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 4.5 ,handle_id=1104,  pos={428,1439}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 4.5 ,handle_id=1105,  pos={741,1302}, effect_id=20025, is_forever = false},
	    	--{ event='effect',  delay = 4.5 ,handle_id=1106,  pos={428+90,1139+80}, effect_id=20025, is_forever = false},

	    	{ event='effect',  delay = 5 ,handle_id=1001,  pos={650+100,1174-100}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 5 ,handle_id=1002,  pos={372+50,1162-100}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 5 ,handle_id=1003,  pos={382-100,1319-100}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 5 ,handle_id=1004,  pos={428-100,1439+100}, effect_id=20025, is_forever = false},
	    	{ event='effect',  delay = 5 ,handle_id=1005,  pos={741+100,1302+100}, effect_id=20025, is_forever = false},

	    	{ event='playAction', delay=5, handle_id=11, action_id=4, dur=1.5, dir=3, loop=true ,once=true },
	    	{ event='playAction', delay=5, handle_id=12, action_id=4, dur=1.5, dir=3, loop=true ,once=true },
	    	{ event='playAction', delay=5, handle_id=13, action_id=4, dur=1.5, dir=3, loop=true ,once=true },
	    	{ event='playAction', delay=5, handle_id=14, action_id=4, dur=1.5, dir=3, loop=true ,once=true },
	    	{ event='playAction', delay=5, handle_id=15, action_id=4, dur=1.5, dir=3, loop=true ,once=true },	  

	   		{ event='kill', delay=6, handle_id=11},
	   		{ event='kill', delay=6, handle_id=12},
	   		{ event='kill', delay=6, handle_id=13},
	   		{ event='kill', delay=6, handle_id=14},
	   		{ event='kill', delay=6, handle_id=15},

    	},
    	{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={570,1310}, speed=350, dur=0.4 },

	    	{ event='talk', delay=1, handle_id=1, talk='你到底想怎么样！', dur=2, },
	    	{ event='talk', delay=2.2, handle_id=2, talk='刘秀他根本就不在乎你！', dur=2.5, },
	    	{ event='talk', delay=4.8, handle_id=1, talk='不。他在乎我！比我想象的更在乎！', dur=2.5, },
	    	{ event='talk', delay=7.6, handle_id=1, talk='我还有家人，他们关心我爱护我。', dur=2.5, },
	    	{ event='talk', delay=10.4, handle_id=1, talk='我比你强百倍，你才是真正一无所有的人！', dur=2.5, },
	    },
	    {
	    	--{ event='playAction', delay=0.1, handle_id=2, action_id=2, dur=1.5, dir=3, loop=false , },

	    	{ event='talk', delay=0.5, handle_id=2, talk='住嘴！住嘴！！！', dur=1.5, },
	   		{ event='move', delay= 2, handle_id=2, end_dir=3, pos={570-90,1310-90}, speed=350, dur=0.4 },

	    	{ event='talk', delay=3.2, handle_id=2, talk='你是我的，所以只能和我在一起。', dur=2.5, },
	    	{ event='talk', delay=6, handle_id=2, talk='来吧，到了那边，我也要一直跟在你身边。', dur=2.5, },
	    	{ event='talk', delay=8.8, handle_id=2, talk='啊哈哈哈哈哈……', dur=2.5, },	 	    	   		    	
    	},
    	{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ac2_4" ,dialog_time = 3,dur = 3},
    	},
    	{
	    	{ event='createActor', delay=0.1, handle_id = 101, body=3, pos={980,1300}, dir=6, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='jump', delay=0.2, handle_id=101, dir=6, pos={ 570-50,1310-50 }, speed=120, dur=0.8 ,end_dir = 7},

	    	{ event='playAction', delay=0.8, handle_id=2, action_id=2, dur=1.5, dir=3, loop=false , },
	    	{ event='playAction', delay=0.9, handle_id=101, action_id=3, dur=1.5, dir=7, loop=false , },

	    	{ event='playAction', delay=1.8, handle_id=101, action_id=2, dur=1.5, dir=7, loop=false , },
			{ event='moveParabola', delay=2, handle_id=2, pos={ 570-200,1310-200 }, high=10, time=0.4, end_act_id=4, end_dir=3, end_loop=false,once=true },
	    	{ event='playAction', delay=2.4, handle_id=2, action_id=4, dur=1.5, dir=3, loop=false ,once=true },

	   		{ event = 'camera', delay = 2.5, dur=0.2,sdur = 0.2,style = '',backtime=1, c_topox = { 500-100,1150-80 } },	

	    	{ event='talk', delay=2.4, handle_id=2, talk='刘……秀？怎么会是你！', dur=1.5, },
	    	{ event='talk', delay=4.5, handle_id=2, talk='[a]', dur=2, emote={a=4} },
    	},
    	{

	   		{ event = 'camera', delay = 0.1, dur=0.2,sdur = 0.2,style = '',backtime=1, c_topox = { 500,1150 } },	    	
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=6, pos={570+50,1310-50}, speed=350, dur=0.4 },
	    	{ event='talk', delay=0.1, handle_id=1, talk='三哥！', dur=1.5, },	
	    	
	   		{ event='move', delay= 1, handle_id=101, end_dir=2, pos={570-50,1310-50}, speed=350, dur=0.4 },
	    	{ event='talk', delay=2, handle_id=1, talk='丽华，你没事吧。', dur=2, },
	    	{ event='talk', delay=4.2, handle_id=1, talk='你怎么来了？', dur=2, },
	    	{ event='talk', delay=6.4, handle_id=101, talk='是你舅舅蔡少公设法让我进入你的梦中。', dur=2.5, },
	    	{ event='talk', delay=9.2, handle_id=101, talk='有我在，我不会让他把你带走的。', dur=2, },
	    },
	    {
	   		{ event='showTopTalk', delay=0.1, dialog_id="ac2_5" ,dialog_time = 3,dur = 3},
	    },
	    {

	   		{ event='move', delay= 0.2, handle_id=1, end_dir=7, pos={570+50,1310-50}, speed=350, dur=0.4 },
	   		{ event='move', delay= 0.2, handle_id=101, end_dir=7, pos={570-50,1310-50}, speed=350, dur=0.4 },	   			    
	    	{ event='talk', delay=0.1, handle_id=1, talk='！', dur=2, },
	    	{ event='talk', delay=0.1, handle_id=101, talk='！', dur=2, },

	   		{ event = 'camera', delay = 1, dur=0.3,sdur = 0.3,style = '',backtime=1, c_topox = { 500-100,1150-100 } },	
	   		{ event='move', delay= 1, handle_id=1, end_dir=7, pos={370+100,1110+50}, speed=350, dur=0.4 },
	   		{ event='move', delay= 1, handle_id=101, end_dir=7, pos={370+80,1110+100}, speed=350, dur=0.4 },
    	},
    	{
	    	{ event='talk', delay=0.1, handle_id=2, talk='朕能否……最后听你唤我一声“圣公”……？', dur=2.5, },
	    	{ event='talk', delay=3, handle_id=1, talk='圣……公！', dur=2,  },
	    	{ event='talk', delay=5.5, handle_id=2, talk='好，好……', dur=1.5, },
	    	{ event='talk', delay=7.5, handle_id=2, talk='得你此言，也不枉朕待你的一片真心……', dur=5, },

	    	{ event='effect',  delay = 9 ,handle_id=10011,  pos={278,997}, effect_id=20005, is_forever = true},
	    	--{ event='effect',  delay = 9.1 ,handle_id=10012,  pos={437,938}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 9.2 ,handle_id=10013,  pos={338,1133}, effect_id=20005, is_forever = true},
	    	--{ event='effect',  delay = 9.4 ,handle_id=10014,  pos={551,1056}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 9.5 ,handle_id=10015, target_id=1, pos={0,20}, effect_id=20005, is_forever = true},	    	
	    	{ event='effect',  delay = 9.5 ,handle_id=10016, target_id=101, pos={0,20}, effect_id=20005, is_forever = true},
	    	{ event='effect',  delay = 9.5 ,handle_id=10017, target_id=2, pos={0,20}, effect_id=20005, is_forever = true},	    	
    	},
    },
     --============================================luyao  帝魂惊梦  end   =====================================----   

	--============================================wuwenbin  断情绝梦 start  =====================================----
	['juqing-ac005'] = 
	{
		--演员表 1 刘秀 2 过珊彤  101-104 侍卫
	 	--创建角色
	    {
	   		{ event='init_cimera', delay = 0.2,mx= 720,my = 1280 },

	   		{event = 'changeRGBA',delay=0.1,dur=3,txt = "建武十七年，刘秀下旨废后。",cont_time=2.5, light_time=0.2, txt_time=0.1, black_time=0.3},
	   		
	    	{ event='createActor', delay=0.1, handle_id = 1, body=3, pos={652,1358}, dir=3, speed=340, name_color=0xffffff, name="刘秀"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=36, pos={754,1426}, dir=7, speed=340, name_color=0xffffff, name="过珊彤"},
	    },


	    --过珊彤质问刘秀
	    {	
	   		{ event='talk', delay=0.1, handle_id=2, talk='为何废我？！', dur=2 },
	   		{ event='talk', delay=2.4, handle_id=1, talk='朕顾念你舅父当年襄助之恩，多次姑息宽待你过家！', dur=3  },
	   		{ event='talk', delay=5.7, handle_id=1, talk='而你却屡蹈“吕霍之风”，扰乱朝政……', dur=2.5 },
	   		{ event='talk', delay=8.5, handle_id=2, talk='陛下既要废后？！又何必给臣妾强扣罪名！', dur=3  },
	   	},

	   	--刘秀谴责过珊彤
	   	{
	   		{ event='move', delay= 0.1, handle_id=1, end_dir=7, pos={628,1332}, speed=220, dur=1.5 },
	    	{ event='talk', delay= 0.3, handle_id=1, talk='你——可当真是个好皇后啊！', dur=2.5 },

	    	-- { event='move', delay= 3, handle_id=1, end_dir=7, pos={628,1332}, speed=220, dur=1.5 },
	   		{ event='talk', delay=3, handle_id=1, talk='心狠手辣，可堪比吕雉、霍成君！', dur=2.5  },
	   		{ event='talk', delay=5.8, handle_id=1, talk='若朕驾崩，你当上皇太后，又将如何待朕幼孤？', dur=3  },
	   		{ event='talk', delay=9.1, handle_id=2, talk='呵呵……', dur=1.5  },
	   		{ event='talk', delay=10.9, handle_id=2, talk='皇子夭殇，妾难辞之咎，陛下要废我，妾无话可说！', dur=3  },
	   		{ event='talk', delay=14.2, handle_id=2, talk='只是陛下打算如何安置我？', dur=2.5  },
	   		{ event='talk', delay=17, handle_id=1, talk='你哪都不用再去。', dur=2.5  },
	    },

	    --刘秀与过珊彤断绝关系
	    {	
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={726,1398}, speed=340, dur=1.5 },

	    	{ event='talk', delay=0.1, handle_id=2, talk='陛下何意？', dur=2},
	    	{ event='talk', delay=2.4, handle_id=1, talk='你我夫妻情份，只到今日止！', dur=2.5},

	   		{ event='talk', delay=5.1, handle_id=2, talk='！！', dur=2},
	   	},

	   	--过珊彤扑向刘秀，刘秀闪开
	    {	

	    	{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={562,1264}, speed=200, dur=1.5 },
	    	{ event='talk', delay=0.1, handle_id=2, talk='不！陛下！', dur=1},

	    	{ event='move', delay= 0.1, handle_id=1, end_dir=5, pos={696,1286}, speed=200, dur=1.5 },
	    	
	    	{ event='talk', delay=1.3, handle_id=2, talk='啊——', dur=2},
	    	{ event='playAction', delay=1, handle_id=2, action_id=4, dur=1.5, dir=7, loop=true , once = true},
	    },

	    --刘秀怒斥过氏
	    {
	    	{ event='move', delay= 0.1, handle_id=1, end_dir=3, pos={756,1296}, speed=340, dur=1.5 },
	    	{ event='move', delay= 0.1, handle_id=2, end_dir=3, pos={562,1264}, speed=200, dur=1.5 },
	   		{ event='talk', delay=0.1, handle_id=2, talk='你怎么可以这么狠心！', dur=2.5},

	   		{ event='move', delay= 2.9, handle_id=2, end_dir=7, pos={820,1386}, speed=200, dur=1.5 },	
	   		{ event='talk', delay=4.5, handle_id=2, talk='难道你就一点不念夫妻之情吗？', dur=2.5},


	   		{ event='talk', delay=7.3, handle_id=1, talk='朕若不顾念夫妻之情，朕——', dur=2.5},
	   		{ event='talk', delay=10.1, handle_id=1, talk='可以诛你过氏满门！', dur=2.5},
	   	},

	   	--刘秀怒斥过氏
	    {
	    	{ event='effect',  delay = 0.1 ,handle_id=1001, target_id=2, pos={0,120}, effect_id=20012, is_forever = true},
	    	{ event='talk', delay=0.1, handle_id=2, talk='！！！', dur=2},

	    	{ event = 'removeEffect', delay = 2.3, handle_id=1001, effect_id=20012},
	   		{ event='talk', delay=2.3, handle_id=2, talk='陛下……陛下……', dur=2},
	   	},

	   	--过氏试图挽回
	   	{
	   		{ event = 'camera', delay = 8.9, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = { 914,1254 } },
	   		{ event='move', delay= 0.1, handle_id=2, end_dir=7, pos={816,1350}, speed=340, dur=1.5 },	

	   		{ event='talk', delay=0.1, handle_id=2, talk='陛下，您还记得吗？', dur=2.5},
	   		{ event='talk', delay=2.9, handle_id=2, talk='我们第一次见面的时候，是你救了臣妾……', dur=3},
	   		{ event='talk', delay=6.2, handle_id=2, talk='还有那些书……', dur=2},

	   		{ event='move', delay= 8.5, handle_id=1, end_dir=1, pos={756,1296}, speed=340, dur=1.5 },
	   		{ event='move', delay= 8.5, handle_id=2, end_dir=1, pos={1072,1294}, speed=340, dur=1.5 },	
	   		{ event='talk', delay=8.5, handle_id=2, talk='那些书我一直珍藏着……', dur=3.5},
	   		
	   		{ event='talk', delay=10, handle_id=1, talk='那些书是我从太学带回新野——', dur=3},
	   		{ event='talk', delay=13.3, handle_id=1, talk='赠给丽华的。', dur=2.5},

	   		-- { event='move', delay= 8.9, handle_id=4, end_dir=1, pos={1072,1086}, speed=340, dur=1.5 },	
	   		{ event='talk', delay=14, handle_id=2, talk='！！', dur=2.5},
	   	},

	   	--刘秀下令带走过氏
	   	{
	   		{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={1072,1294}, speed=340, dur=1.5 },	

	   		{ event='talk', delay=0.1, handle_id=2, talk='你……', dur=2.5},
	   		{ event='talk', delay=2.9, handle_id=1, talk='来人！把过氏带走！', dur=2.5},
	   		{ event='move', delay= 2.9, handle_id=1, end_dir=3, pos={756,1296}, speed=340, dur=1.5 },

	   		{ event='move', delay= 0.1, handle_id=2, end_dir=5, pos={1072-16,1294+16}, speed=340, dur=1.5 },	
	   		{ event='talk', delay=5.7, handle_id=2, talk='不——！！！', dur=2.5},
	   	},

	   	--侍卫出现，带走过氏
	   	{
	   		--侍卫们出现
	   		{ event='createActor', delay=0.1, handle_id = 101, body=25, pos={1106,1520}, dir=7, speed=200, name_color=0xffffff, name="侍卫"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=25, pos={1106+48,1520+48}, dir=7, speed=340, name_color=0xffffff, name="侍卫"},
	   		{ event='createActor', delay=0.1, handle_id = 103, body=25, pos={1106+112,1520+80}, dir=7, speed=340, name_color=0xffffff, name="侍卫"},
	   		{ event='createActor', delay=0.1, handle_id = 104, body=25, pos={1106+240,1520+112}, dir=7, speed=340, name_color=0xffffff, name="侍卫"},

	   		{ event='move', delay= 0.2, handle_id=1, end_dir=2, pos={756,1296}, speed=340, dur=1.5 },

	   		{ event='move', delay= 0.2, handle_id=101, end_dir=1, pos={1008-16,1324+16}, speed=200, dur=1.5 },	
	   		{ event='move', delay= 0.2, handle_id=102, end_dir=7, pos={1106-16,1352+16}, speed=200, dur=1.5 },	
	   		{ event='move', delay= 0.2, handle_id=103, end_dir=5, pos={1132-16,1266+16}, speed=200, dur=1.5 },	
	   		{ event='move', delay= 0.2, handle_id=104, end_dir=3, pos={1040-16,1238+16}, speed=200, dur=1.5 },	

	   		{ event='talk', delay=2, handle_id=2, talk='别碰我！别碰我！！！', dur=3.5},
	   		{ event='playAction', delay=2, handle_id=2, action_id=2, dur=0.5, dir=5, loop=false },
	   		{ event='move', delay= 2.5, handle_id=2, end_dir=5, pos={1072-16,1294+16}, speed=340, dur=1.5 },
	   	},
	   	{
	   		{ event='showTopTalk', delay=0.1, dialog_id="ac3_1" ,dialog_time = 3,dur = 7},
	   	},

    },

    --============================================wuwenbin  断情绝梦  end   =====================================----


    --============================================hanbaobao  斩奸奠魂 start  =====================================----

    ['juqing-ac007'] = 
	{
		--演员表 1 过康 2 尉迟纱南 101-102 醉鬼 103 酒馆掌柜

	 	--创建角色
	    {
	   		
	    	{ event='init_cimera', delay = 0.1,mx= 367,my = 367-100},

	   		{ event='createActor', delay=0.1, handle_id = 1, body=48, pos={240,369}, dir=1, speed=340, name_color=0xffffff, name="过康"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=52, pos={1168,692}, dir=7, speed=340, name_color=0xffffff, name="尉迟纱南"},

	    	{ event='createActor', delay=0.1, handle_id = 101, body=55, pos={178,301}, dir=3, speed=340, name_color=0xffffff, name="醉鬼"},
	    	{ event='createActor', delay=0.1, handle_id = 102, body=38, pos={305,304}, dir=5, speed=340, name_color=0xffffff, name="醉鬼"},

	    	{ event='createActor', delay=0.1, handle_id = 103, body=37, pos={848,241}, dir=3, speed=340, name_color=0xffffff, name="酒铺掌柜"},
	   
	    },

	    --过康醉酒倒地
	    {
	    	
	    	{ event='talk', delay=0.1, handle_id=1, talk='老子……嗝儿……！', dur=1},
	    	{ event='talk', delay=1.3, handle_id=1, talk='老子一定要报仇……', dur=1.5},

	    	{ event='move', delay= 3, handle_id= 101, dir=2, pos= {178,301},speed=500, dur=1, end_dir=2 },
	    	{ event='move', delay= 3, handle_id= 102, dir=6, pos= {305,304},speed=500, dur=1, end_dir=6 },

	    	{ event='move', delay= 3, handle_id= 1, dir=1, pos= {552,312},speed=500, dur=1, end_dir=1 },

	    	{ event='talk', delay=3, handle_id=101, talk='他喝多了，我们继续！', dur=1.5},
	    	{ event='talk', delay=4.7, handle_id=102, talk='对！继续喝……嗝儿……', dur=1.5},

	    	{ event='playAction', delay=6.1, handle_id=1, action_id=4, dur=1, dir=1, loop=false,once =true},
	    	
	    	{ event='talk', delay=6.4, handle_id=1, talk='我过大爷，怎么会是，你们能侮辱的……', dur=3.5},

	    	{ event='move', delay= 6.4, handle_id= 2, dir=7, pos= {849,337},speed=340, dur=0.5, end_dir=1 }, 
	    	{ event='talk', delay=10.1, handle_id=2, talk='……', dur=2},

	    	{ event='move', delay= 10.2, handle_id= 1, dir=3, pos= {911,433},speed=500, dur=0.5, end_dir=3 }, 
	    	{ event='talk', delay=10.1, handle_id=1, talk='嗝儿……', dur=2},

	    	{ event='talk', delay=13.5, handle_id=1, talk='？！', dur=1},
			{ event='move', delay= 13.5, handle_id= 1, dir=7, pos= {911,433},speed=500, dur=0.5, end_dir=7 }, 
			
	    	
	    },

	    --稍微BB了一下
	    {
	    	
	    	{ event='move', delay= 0.1, handle_id= 2, dir=3, pos= {848,466},speed=340, dur=1, end_dir=3 },
	    	{ event='move', delay= 0.2, handle_id= 1, dir=6, pos= {943,527},speed=300, dur=1, end_dir=7 },

	    	{ event ='camera', delay = 0.2, sdur=0.5, dur = 1, c_topox = {850,338+80}, style = '',backtime=1},
	    	{ event='talk', delay=1, handle_id=1, talk='美人儿！别走啊~~', dur=2},
	    	{ event='talk', delay=3.2, handle_id=1, talk='来陪爷喝一个……嗝儿……', dur=2},
	    	{ event='talk', delay=5.4, handle_id=2, talk='爷，您别这样。', dur=1.5},
	    	{ event='talk', delay=7.1, handle_id=1, talk='怎么？不愿陪爷喝酒啊？', dur=2},
	    	{ event='talk', delay=9.3, handle_id=1, talk='你别忘了！当年是爷杀了你！', dur=2.5},
	    	{ event='talk', delay=12, handle_id=1, talk='啊哈哈哈……', dur=1.5},


	    },

	    --追逐BB
	    {

	    	{ event='move', delay= 0.2, handle_id= 2, dir=3, pos= {882,496},speed=200, dur=0.5, end_dir=3 }, 
	    	{ event='talk', delay=1, handle_id=2, talk='呵呵……是吗？', dur=1.3},

	    	{ event='talk', delay=2.5, handle_id=1, talk='！！！', dur=1.1},
			{ event='talk', delay=3.8, handle_id=1, talk='不对……琥珀？？？', dur=1.5},

			{ event='moveParabola', delay=3.8, handle_id=1, pos={943+50,527+50}, high=0, time=0.1, end_act_id=0, end_dir=7, end_loop=true },

	    	{ event='talk', delay=5.5, handle_id=1, talk='你是琥珀！你是鬼！！！', dur=2},

	    	{ event='move', delay= 7.7, handle_id= 1, dir=3, pos= {1169+200,689+200},speed=340, dur=1, end_dir=3 },
	    	{ event='talk', delay=7.7, handle_id=1, talk='鬼啊！！！鬼……', dur=2},

	    	{ event='move', delay= 8, handle_id= 2, dir=3, pos= {1169+200,689+200},speed=300, dur=1, end_dir=3 },
	    	{ event='talk', delay=8, handle_id=2, talk='哼，别想跑！', dur=1.5},

	    },

	},

	['juqing-ac008'] = 
	{
		--演员表 1 过康 2 尉迟纱南 3尉迟峻

	 	--创建角色
	    {
	   		
	    	{ event='init_cimera', delay = 0.1,mx= 339,my = 1391},

	   		{ event='createActor', delay=0.1, handle_id = 1, body=48, pos={274,492}, dir=1, speed=340, name_color=0xffffff, name="过康"},
	    	{ event='createActor', delay=0.1, handle_id = 2, body=52, pos={786,1838}, dir=7, speed=340, name_color=0xffffff, name="尉迟纱南"},
	    	{ event='createActor', delay=0.1, handle_id = 3, body=22, pos={786,1838}, dir=7, speed=340, name_color=0xffffff, name="尉迟峻"},

	   
	    },

	    --过康醉酒倒地
	    {
	    	--{ event='moveParabola', delay=0.1, handle_id=1, pos={273,1392}, high=0, time=0.1, end_act_id=4, end_dir=7, end_loop=true },
	    	{ event='jump', delay=0.1, handle_id=1, dir=7, pos={ 273,1392 }, speed=120, dur=0.8 ,end_dir = 7},
	    	{ event='playAction', delay=0.6, handle_id=1, action_id=4, dur=1, dir=1, loop=false,once =true},


	    	{ event='move', delay= 1.5, handle_id= 2, dir=7, pos= {335+50,1487+50},speed=200, dur=0.5, end_dir=7 }, 
	    	{ event='move', delay= 1.5, handle_id= 3, dir=7, pos= {399+50,1391+50},speed=200, dur=0.5, end_dir=6 }, 

	    	{ event='talk', delay=4, handle_id=2, talk='义父。', dur=1},

	    	{ event='talk', delay=5.2, handle_id=2, talk='我们终于为琥珀姑姑报仇了！', dur=2},

	    	{ event='talk', delay=7.4, handle_id=3, talk='嗯。', dur=1},

	    },
	},

  --============================================hanbaobao  斩奸奠魂 end  =====================================----

----=====================================================================长歌行活动任务剧情动画配置 END =====================================================-------  

}