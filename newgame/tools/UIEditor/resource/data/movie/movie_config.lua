--测试方式，
--启动客户端前 双击resourcePack/console/console.wlua
--启动客户端
--在输入框，输入 testCinema('xxx') xxx = 你的动画名字

--动作类型

	
	-- ZX_ACTION_IDLE=0,				// 常规待机动作，也是常规序列帧动画第一个动作定义
	-- ZX_ACTION_MOVE=1,				// 移动动作 
	-- ZX_ACTION_HIT= 2,				// 第一个攻击动作
	-- ZX_ACTION_HIT_2 =3,			// 手机
	-- ZX_ACTION_DIE=4,				// 死亡动作
	-- ZX_ACTION_STRUCK=5,			// skill1
	-- ZX_ACTION_PRACTICE=6,			// skill2


	--ui控件隐藏  
       --hide  Avatar     hide UI   disable  SCeneClicks
       -- 隐藏其他玩家， 隐藏UI ，隐藏场景点击
    --备忘--
    --delay是延迟多久做,比如说你想move动作延迟;   dir=朝向 方向;  dur=做这个事情的时间,举例move走的近,move已经走到了。时间还没到。就不会继续跑剧情。所有有时候你会发现move动作之后如果有dialog会很久出来
--[怪物entity_id ] = true 不用显示等级
movie_npc_arr = {
	[1987] = true,
}

movie_misc_conf = {
	tip_go = { time=8, cont="点击GO可自动寻路哟~", width=200, pos={32,55}},
	tip_tuoguan = { time=5, cont="点击可切换为手动战斗哟", width=100, pos={30, 0}},
}

MOVIE_ACTOR_ZORDER = 100
movie_config = 
{


-- 		   { event = 'spawn', delay = 1, cast = 'shishen9', dir = 6, pos = { 604, 801 } },
--         { event = 'kill', delay = 4, cast = 'cast1016', style = 'destory' },
--         { event = 'zoom', delay = 5, sValue = 1.1, eValue = 1.0, dur = 1.0 },
-- 		   { event = 'jump', delay = 0.0, cast = 'cast3', dir = 6, pos = {1318,674},speed = 120, dur = 1 },

-- 	--*********************************************
-- 	--* 'FlowText'参数说明s
-- 	--* cast: 已创建的演员
-- 	--* yOffset: 高度偏移量
-- 	--* prefix:  飘血类型 可为空, 'exp'为经验, 'critical'为暴击飘血, 其它为普通飘血
-- 	--* colortype: 数字颜色类型 1~7
-- 	-- 类型定义
-- 	-- 1 	-- 蓝色字
-- 	-- 2 	-- 红色字
-- 	-- 3 	-- 绿色字
-- 	-- 4 	-- 黄色字
-- 	-- 5 	-- 小黄色字(用于显示数量)
-- 	-- 6 	-- 小黄色字(用于显示强化等级)
-- 	-- 7 	-- 繁体黄色字(用于显示宝石等级)
-- 	--* numbermessage: 飘血数字
-- 	--* isHeal: 可为空,为true时为加血
-- 	--*********************************************
-- 	    	{ event = 'playAction', cast = 'player', delay = 0, action_id = 2, dur = 1.5, dir = 2},
-- 	        { event = 'FlowText', delay = 0.5, cast = "cast35", yOffset = 150, colortype = 2, numbermessage = 2537, isHeal = false},
-- 	        -- { event = 'playSkill', delay = 0.5, cast = "cast35", skill = 1, time = 1, dir = 1},
-- 	        { event = 'effect', delay = 1.0, cast = 'player', effect_id = 6001, dy = 90, layer = 2 },

-- 	    {
-- 	       -- { event = 'playerMove', pos = {544, 960}, delay = 2.5}
-- 	    },
-- 		--动画组
-- 	    {   
-- 	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
-- 		   { event = 'hideUI' , delay = 0 },		-- 动画片段
-- 		   -- { event = 'screenText', id = 2 },		-- 动画片段
-- 		   { event = 'disableSceneClicks' },		-- 动画片段
-- 	    },
-- 	    {
-- 	    	{ event = 'shake', delay = 0, dur = 1.5, index = 60, rate = 4, radius = 30 },
-- 		},
--         {
-- 	       { event = 'dialog', dialog_id = 19 },  
-- 	       { event = 'move', delay = 0.1, cast = 'player', dir = 6, pos = {804, 1348},speed = 340, dur = 4 },
-- 	    },

--剧情副本玩家变怪物
	    -- {  
	    --    --玩家变怪物 body_id是客户端中的资源ID
     --       {event='tranToMonster', body_id = 1},
	    -- },

-- 变怪物之后还原角色
       -- { --还原主角变身
       --    {event = 'tranToPlayer', delay =0},
       --  },


--怪物移动后转向  移动配置一个 end_dir 
	    -- {   
	    -- 	{ event = 'move', delay = 0.1,entity_id = 1981, dir = 6, pos = {88,120},speed = 340, dur = 1,end_dir= 6},
	    -- },
	----------------------------------------------------------------------  测试对话数据  By Fjh
		['acceptQuestAction1'] = 
	{


		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
	    	-- 只要这里配置dialog_id 是读取配置表get_task_dialog
	       { event = 'dialog', dialog_id = 1, kind = "acceptQuest" },
	    },
	},

	['taoZhai1'] = {
			--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
	    	-- 只要这里配置dialog_id 是读取配置表get_task_dialog
	       { event = 'dialog', dialog_id = 1, kind = "taoZhai" },
	    },
	},

	["unfinishQuest"] = {
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
	    	-- 只要这里配置dialog_id 是读取配置表get_task_dialog
	       { event = 'dialog', dialog_id = 1, kind = "unfinishQuest" },
	    },

	},

		['normalTalk1'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
	    	-- 只要这里配置dialog_id 是读取配置表get_task_dialog
	       { event = 'dialog', dialog_id = 1, kind = "normalTalk" },
	    },
	},

	-- add by chj 2015-12-17
	['fubenTalk1'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
	    	-- 只要这里配置dialog_id 是读取配置表fuben_dialog
	       { event = 'dialog', dialog_id = 1, kind = "fubenTalk" },
	    },
	},

		['finishQuestAction1'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
	    	-- 只要这里配置dialog_id 是读取配置表get_task_dialog
	       { event = 'dialog', dialog_id = 1, kind = "finishQuest" },
	    },
	},


-------------------------------------------------------------------------------------------------

   --=========================================================山海经剧情动画配置===========================================---
   --============================================hanli  剧情副本第一章第一节 start  =====================================----
--剧情副本第一章第一节剧情1

    ['test'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
        
        {
			{ event = 'camera', delay = 0.5, dur=2,sdur = 1,style = '',backtime=1, c_topox = {2231, 3253} },
        },
        --玩家和富贵原地移动转向
      --    {
      --     --changeRGBA:屏幕渐变方法 点击后变白继续  txt 显示的文字
	     --  -- {event = 'changeRGBA',delay=0.1,dur=1,txt = "#cd71345你是我的小苹果,怎么爱都爱不够！"},
	     --  { event = 'move', delay = 0.1,cast = 'player', end_dir = 1, pos = {67, 107},speed = 340, dur = 1 },
	     -- },

	},	  


    ['juqing101'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
        
        --玩家和富贵原地移动转向
         {
          --changeRGBA:屏幕渐变方法 点击后变白继续  txt 显示的文字
	      -- {event = 'changeRGBA',delay=0.1,dur=1,txt = "#cd71345你是我的小苹果,怎么爱都爱不够！"},
	      { event = 'move', delay = 0.1,cast = 'player', end_dir = 1, pos = {67, 107},speed = 340, dur = 1 },
          { event = 'move', delay = 0.1,entity_id=1987, end_dir = 5, pos = {71, 105},speed = 340, dur = 1 },
	     },

        --角色前置对白
	    {

	   		 { event = 'dialog', dialog_id = 11 },  
	    },
        
	    {
	        { event = 'showUI' , delay = 1 },		-- 显示UI
	        { event = 'enableClick' , delay = 0 },		-- 允许点击
	    },

	    --富贵移动，边跑边冒泡
	    {
	      { event = 'move', delay = 0.1,entity_id=1987, end_dir = 1, pos = {92, 108},speed = 340, dur = 2.5 },
	      { event = 'talk', delay = 0.1, entity_id=1987, isEntity = false,talk = '给我揍他！', dur = 1.5 },
	      { event = 'kill', delay = 2.5,entity_id = 1987, dur = 0 }, 
	      { event = 'createActor', delay = 1,jqid=2 },  --刷出第一波熊孩子
        },

	},	    

   --剧情副本第一章第一节剧情2
   ['juqing102'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    
	    --玩家走过去
	    {   
	    	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {85,128},speed = 340, dur = 1 },
	    },

	    --角色前置对白
	    {
	   		--{ event = 'dialog', dialog_id = 101 },
	   		{ event = 'talk', delay = 0.1, entity_id = 1982, isEntity = false,talk = '死丫头！江流儿！', dur = 1.5 },
	   		{ event = 'talk', delay = 1, entity_id = 1983, isEntity = false,talk = '滚出去！滚出去！', dur = 1.5 },
	   		{ event = 'talk', delay = 2, entity_id = 1981, isEntity = false,talk = '你们再叫一声试试！！', dur = 1.5 },
	   		{ event = 'talk', delay = 2.5, entity_id = 1987, isEntity = false,talk = '就叫就叫！！', dur = 1 },
	    },
	    
	    --苏茉朝富贵扔了一团泥
	    {
	       --【苏茉】攻击动作
	       { event = 'playAction', entity_id= 1981, delay = 0.1, action_id = 2, dur = 1.5, dir = 2,loop = false },
		   --泥巴特效移动 第一个是开始位置，第二个是高度，第三个是目标位置。
           { event = 'moveEffect', delay = 0.2, effect_id = 10128, pos1 = {83,130},pos2 = {86,126},pos3 ={88,129},dur = 0.5,m_dur = 0.2},
           --{ event = 'removeEffect', delay = 1.3, entity_id=1987,effect_id = 20002, },	
           { event = 'removeEffect', delay = 0.6,  pos = { 83, 130 }, },
	       --【富贵】受击动作
           { event = 'playAction', entity_id= 1987, delay = 0.5, action_id = 3, dur = 1, dir = 6 },
           { event = 'talk', delay = 1.5, entity_id = 1987, isEntity = false,talk = '呸呸呸！', dur = 1 },
           { event = 'talk', delay = 2.5, entity_id = 1981, isEntity = false,talk = '叫不出了吧。', dur = 1 }, 
        },

	    --角色前置对白
	    {
	   		{ event = 'dialog',delay = 0.5,dialog_id = 102 },  
	    },
        --刷出第三波熊孩子
        {
          { event = 'createActor', jqid=7 }, --富贵开始攻击玩家
	    },

    },

   ['juqing1021'] =  
	{
		--移动冒泡
   		{
   			{ event = 'talk', delay = 0.1, entity_id = 1981, isEntity = false,talk = 'player,小心！', dur = 1.5 },
   			{ event = 'talk', delay = 0.1, entity_id = 1982, isEntity = false,talk = '富贵，加油！', dur = 1.5 },
   			{ event = 'talk', delay = 0.1, entity_id = 1983, isEntity = false,talk = '揍他，揍他！', dur = 1.5 },
   			{ event = 'move', delay = 0.1,entity_id = 1982, dir = 6, pos = {96,134},speed = 340, dur = 1, end_dir = 7 },
   			{ event = 'move', delay = 0.1,entity_id = 1983, dir = 6, pos = {97,130},speed = 340, dur = 1, end_dir = 6 },
   			{ event = 'move', delay = 0.1,entity_id = 1981, dir = 6, pos = {77,132},speed = 340, dur = 1, end_dir = 1 },
   		},
	},
   --剧情副本第一章第一节剧情3
   ['juqing103'] = 
	{
		
	    --动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    
	    --富贵冒泡对白
	     {
           --玩家走过去  
	    	{ event = 'move', delay = 0.5,cast = 'player', dir = 6, pos = {91,131},speed = 340, dur = 1, end_dir = 2 },
	    	{ event = 'talk', delay = 0.5,cast = 'player',isEntity = false,talk = '别跑！', dur = 1.5 },
        --富贵冒泡对白
           { event = 'move', delay = 0.1,entity_id = 1987, dir = 6, pos = {94,132},speed = 340, dur = 1, end_dir = 6 },
           { event = 'talk', delay = 0.1, entity_id = 1987, isEntity = false,talk = '哎哟，疼疼疼……', dur = 1 },
           { event = 'talk', delay = 1.5, entity_id = 1987, isEntity = false,talk = '呜呜呜……流泪表情', dur = 1 },
           { event = 'move', delay = 0.1,entity_id = 1981, dir = 6, pos = {91,133},speed = 340, dur = 1, end_dir = 2 },
	    },

	    --角色前置对白
	    {
	   		 { event = 'dialog',delay = 0.5, dialog_id = 103 },  
	    },

	    --苏茉朝着熊孩子们撒出一把白色粉末
	    {
	   		--【苏茉】朝【众人】撒出一把白色粉末。
	       { event = 'playAction', entity_id= 1981, delay = 0.5, action_id = 2, dur = 1, dir = 2 },
	       --气雾状特效覆盖【众人】的头部
           { event = 'effect', delay = 1, entity_id = 1982, layer = 2, effect_id = 20006,},
           { event = 'effect', delay = 1, entity_id = 1983, layer = 2, effect_id = 20006,},
           { event = 'effect', delay = 1, entity_id = 1987, layer = 2, effect_id = 20006,},
        },

	     --富贵，强强，狗蛋冒泡对白
	    {
	    	{ event = 'effect', delay = 1, entity_id = 1982, layer = 2, effect_id = 10131,is_forever =true},
        	{ event = 'effect', delay = 1, entity_id = 1983, layer = 2, effect_id = 10131,is_forever =true},
        	{ event = 'effect', delay = 1, entity_id = 1987, layer = 2, effect_id = 10131,is_forever =true},
           -- { event = 'talk', delay = 0.8, entity_id = 1982, isEntity = false,talk = '眩晕表情', dur = 1 },
           -- { event = 'talk', delay = 0.8, entity_id = 1983, isEntity = false,talk = '眩晕表情', dur = 1 },
           -- { event = 'talk', delay = 0.8, entity_id = 1987, isEntity = false,talk = '眩晕表情', dur = 1 },
	    },

	     --角色前置对白
	    {
	   		 { event = 'dialog', delay = 1,dialog_id = 104 },  
	    },

	    -- --苏茉移动到剧情位置
	    -- {   
	    -- 	{ event = 'move', delay = 0.1,entity_id = 1981, dir = 6, pos = {76,115},speed = 340, dur = 1 },
	    -- },

	    -- --苏茉消失
	    -- {
	    --  	{ event = 'kill', delay = 1,entity_id = 1981, dur = 0 },  
	    -- },

        --请求通关副本
        {
          	{ event = 'carnet', delay = 1,dur = 0 },  
        },

    },
--============================================hanli  剧情副本第一章第一节   end   =====================================----



    --============================================xiehande  剧情副本第一章第二节 start  =====================================----
    ['juqing111'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
        -- {  --抛物线运动（特效资源） pos1 第一个是目标位置， pos2 抛物线的第二个点也是最高点   pos3第三点 也是抛物线最后的一个终点 m_dur  抛出线这个运行时间,决定了速度
        --    { event = 'moveEffect', delay = 0.2, effect_id = 11049, pos1 = { 119, 96 },pos2 = {125,94},pos3 ={129,97},dur = 1,m_dur = 2},
        -- },
        --一章一节前置对面
	    {
	       { event = 'dialog', dialog_id = 1 }, 
	    },  
	    -- --移动到坐标X:X处，消失
        {
	    	{ event = 'move', delay = 0.1,entity_id=2001, dir = 6, pos = {145, 96},speed = 340, dur = 2 },
	    },
	    {
	    	{ event = 'kill', delay = 0,entity_id = 2001, dur = 0 },  
	    }
	     --石头特效移动 第一个是目标位置，其他两个是控制点，第二个决定高度
           -- { event = 'moveEffect', delay = 0.1, effect_id = 101, layer = 2, pos1 = { 111, 222 },pos2 = {190,190},pos3 ={222,222},dur = 1 },
    },

    --剧情副本第一章第一节 剧情2
    ['juqing112'] = 
	{
		{   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
        --坐标某处刷出鬼草
        {
          { event = 'createActor', jqid=2 },
        },
	    {  --entity_id 配置需要移动的服务器端人物
	      { event = 'dialog', dialog_id = 2 }, 
	    },

	    {  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	       { event = 'move', delay = 0.1,entity_id=2004, dir = 6, pos = {150,84},speed = 340, dur = 3,end_dir =5 },
	       { event = 'camera', delay = 0.2, dur=3.5,sdur = 0.9,style = '',backtime=1, c_topox = {4821,2704} },
	    },     	
	    {
	      { event = 'talk', delay = 0, entity_id=2004, isEntity = false,talk = '叽叽……', dur = 1 },
	     
	      { event = 'talk', delay = 2, entity_id=2004, isEntity = false,talk = '放马过来，我可是有小弟的。', dur = 1 },
          { event = 'effect', delay = 2, entity_id = 2004, layer = 2, effect_id = 8,dx=0,dy= 60},	      
	    }, 

	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0, dur=2,cast = 'player'},
	    },    	
    },
    
    --鬼草第一次跑开的配置
    ['juqing1121'] = 
	{

	    {
	      	{ event = 'talk', delay = 0.1, entity_id=2004, isEntity = false,talk = '小弟们，揍他！', dur = 1 },	    
	        { event = 'move', delay = 0.1,entity_id=2004, dir = 6, pos = {166,81},speed = 340, dur = 3, },
	    	{ event = 'removeEffect', delay = 0.1, entity_id=2004,effect_id = 8, },	        	        
     	},
     	{
     	    { event = 'changePos', delay = 0.1, entity_id=2004, pos = {171,59} ,end_dir =5 },
      	},
    },
    --第二种可能
    ['juqing1121a'] = 
	{

	    {
	      	{ event = 'talk', delay = 0.1, entity_id=2004, isEntity = false,talk = '啊，被打断了，快跑！', dur = 1 },	    
			{ event = 'playAction', delay = 0.1,entity_id = 2004, delay = 0.1, action_id = 3, dur = 1, dir = 5,loop = false},
			{ event = 'playAction', delay = 0.3,entity_id = 2004, delay = 0.1, action_id = 0, dur = 1, dir = 1,loop = true},	
	        { event = 'move', delay = 0.7,entity_id=2004, dir = 6, pos = {166,81},speed = 340, dur = 3 },
	    	{ event = 'removeEffect', delay = 0.1, entity_id=2004,effect_id = 8, },	        	        
     	},
     	{
     	    { event = 'changePos', delay = 0.1, entity_id=2004, pos = {171,59},end_dir =5 },
      	},
    },
    --第二次采集的位置
    ['juqing1122'] = 
	{
	    {
	       { event = 'move', delay = 0.1,entity_id=2004, dir = 6, pos = {183,52},speed = 340, dur = 3, end_dir =5},
	       { event = 'effect', delay = 0.1, entity_id = 2004, layer = 2, effect_id = 8,dx=0,dy= 60},
     	}

    },
     --第二次跑开的位置
    ['juqing1123'] = 
	{
	    {
	      	{ event = 'talk', delay = 0.1, entity_id=2004, isEntity = false,talk = '小弟们，揍他！', dur = 1 },	    	
	        { event = 'move', delay = 0.1,entity_id=2004, dir = 6, pos = {168,48},speed = 340, dur = 3 },
	        { event = 'removeEffect', delay = 0.1, entity_id=2004,effect_id = 8, },  
     	},
     	{
     	    { event = 'changePos', delay = 0, entity_id=2004, pos = {165,36} ,end_dir =3},
      	},

    },

     --第二种可能
    ['juqing1123a'] = 
	{
	    {
	      	{ event = 'talk', delay = 0.1, entity_id=2004, isEntity = false,talk = '啊，被打断了，快跑！', dur = 1 },
			{ event = 'playAction', delay = 0.1,entity_id = 2004, delay = 0.1, action_id = 3, dur = 1, dir = 5,loop = false},
			{ event = 'playAction', delay = 0.6,entity_id = 2004, delay = 0.1, action_id = 0, dur = 1, dir = 6,loop = true},		    	
	        { event = 'move', delay = 0.7,entity_id=2004, dir = 6, pos = {168,48},speed = 340, dur = 2 ,},
	        { event = 'removeEffect', delay = 0.1, entity_id=2004,effect_id = 8, },  
     	},
     	{
     	    { event = 'changePos', delay = 0, entity_id=2004, pos = {165,36} ,end_dir =3},
      	},

    },

     --第三次采集的位置
    ['juqing1124'] = 
	{
	    {
	    
	        { event = 'move', delay = 0.1,entity_id=2004, dir = 6, pos = {149,25},speed = 340, dur = 4,end_dir =3 },
	        { event = 'effect', delay = 3.5, entity_id = 2004, layer = 2, effect_id = 8,dx=0,dy= 60},
     	}
    },

     --第三次跑路
    ['juqing1124a'] = 
	{
	    {
	      	{ event = 'talk', delay = 0.1, entity_id=2004, isEntity = false,talk = '啊，和你拼了！', dur = 1 },
			{ event = 'playAction', delay = 0.1,entity_id = 2004, delay = 0.1, action_id = 3, dur = 1, dir = 3,loop = false},
			{ event = 'playAction', delay = 0.6,entity_id = 2004, delay = 0.1, action_id = 0, dur = 1, dir = 1,loop = true},
			{ event = 'removeEffect', delay = 0.1, entity_id=2004,effect_id = 8, },  	
     	}
    },

    ['juqing1124b'] = 
	{
	    {
	      	{ event = 'talk', delay = 0.1, entity_id=2004, isEntity = false,talk = '小弟们，和他拼了！', dur = 1 },	
	      	{ event = 'removeEffect', delay = 0.1, entity_id=2004,effect_id = 8, },  
     	}
    },
  --剧情副本第一章第一节 剧情3
  ['juqing113'] = 
	{
		{   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
        
	    {
	      { event = 'createActor', delay = 1,jqid=13 },  --刷出苏沫
	    },
	    -- {  --移动到鬼草处
	    --   { event = 'move', delay = 0.1,entity_id=2001, pos = {158,25},speed = 340, dur = 1.5 ,end_dir = 2},
	    -- },
	    {  --玩家移动到苏茉附近
	      { event = 'move', delay = 0.1, cast = 'player',  pos = {155,28},speed = 340, dur = 1.5 ,end_dir = 5},
	    },

	    {
	   		{ event = 'dialog', dialog_id = 3 },  
	    },

		{--震屏效果
	      { event = 'shake', delay = 0.1, dur = 1,c_topox = {4980,912},index = 60, rate = 4, radius = 40 }, 
	      { event = 'createActor', jqid=14 },  
	    },

	    {  
	       { event = 'talk', delay = 0.1, entity_id=2001, isEntity = false,talk = '{惊叹号}', dur = 1 },
	       { event = 'talk', delay = 0.1, cast = 'player', isEntity = false, talk = '{惊叹号}', dur = 1 },
	    },

	    --移动摄像机
	    {  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	    	{ event = 'camera', delay = 0.5, dur=0,sdur = 1,style = '',backtime=1.5, entity_id = 2008 },
	      	{ event = 'talk', delay = 0.5, entity_id=2008, isEntity = false, talk = '嘶嘶……', dur = 1.5 },
	    },

	    {
	    	{ event = 'camera', delay =0.1, dur=1.5,cast = 'player'},
	    	{ event = 'move', delay = 0.1, entity_id=2008, pos = {166,24},speed = 340, dur = 0.1 ,end_dir = 6},
	    },

	    {
	   		{ event = 'dialog', dialog_id = 4 },  
	    },

	    --苏茉跑开
	    {
	    	{ event = 'move', delay = 0.1, entity_id=2001,  pos = {155,35},speed = 250, dur = 1 ,end_dir = 1},
	    },

	    {
	    	{ event = 'createActor',  delay = 0.1,jqid=15 }, 
	    },
    },

  --剧情副本第一章第一节 剧情4
 ['juqing114'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
	    {
	    	{ event = 'camera', entity_id = 2001,  delay = 0.5, dur = 0, style = '' , sdur = 2.5, backtime = 1,},
	    	{ event = 'talk', delay = 1, entity_id=2001, isEntity = false,talk = '!', dur =2},
	    	{ event = 'move', delay = 1, entity_id=2001, pos = {155,35},speed = 340, dur = 4 ,end_dir = 3},
	    	{ event = 'createActor',  delay = 0.5,jqid=17}, 
	    	{ event = 'move', delay = 2.5, cast = 'player', pos = {157,33},speed = 280, dur = 1, end_dir = 3},
	    },        

	    {
	   		{ event = 'dialog',  delay =0.1,dialog_id = 5 },  
	    },

   	    {
   	    	{ event = 'move', delay = 0.1, entity_id=2002, pos = {156,35},speed = 200, dur = 0.7 ,end_dir = 7},	  	    	 
		},
		{
		   	{ event = 'playAction', entity_id = 2001, delay = 0.5, action_id = 4, dur = 1, dir = 3,loop = false},	
   	    	--{ event = 'playAction', entity_id = 2002, delay = 0.1, action_id = 4, dur = 1, dir = 7,loop = false},
   	    	--{ event = 'talk', delay = 0.5, entity_id=2001, isEntity = false,talk = '啊…', dur =1.5},
	      	{ event = 'talk', delay = 0.5, entity_id=2002, isEntity = false,talk = '不好意思！', dur =1},
	    },
   	  
	    {
	   		 { event = 'dialog',  delay =0.1,dialog_id = 6 },  
	    },	
	    {
   	    	{ event = 'playAction', delay = 0.1,entity_id = 2002, delay = 0.1, action_id = 0, dur = 1, dir = 7,loop = true}, 
   	    	{ event = 'playAction', delay = 0.1,entity_id = 2001, delay = 0.1, action_id = 0, dur = 1, dir = 3,loop = true}, 
   	    	{ event = 'move', delay = 0.5, entity_id=2001, dir = 6, pos = {153,34},speed = 200, dur = 1,end_dir = 3},
	        { event = 'talk', delay = 1, entity_id=2001, isEntity = false,talk = '臭流氓！', dur =1.5},	   	  	    	 
		},	
   	    {
   	    	--苏茉播放动作
   	    	{ event = 'playAction', delay = 0.1,entity_id = 2001, delay = 0.1, action_id = 2, dur = 1, dir = 3,loop = false}, 
          	{ event = 'moveEffect', delay = 0.5, effect_id = 20006, pos1 = {153,33},pos2 = {155,32},pos3 ={157,33},dur = 1,m_dur = 0.7 },	
          	{ event = 'removeEffect', delay = 1.2,  pos = {153,33 },effect_id = 20006, },
          	--赤羽晕倒
	        { event = 'talk', delay = 1.2, entity_id=2002, isEntity = false,talk = '{眩晕}', dur = 1.5},          	
   	    	{ event = 'playAction', delay = 1.8,entity_id = 2002, action_id = 4, dur = 1, dir = 5,loop = false }, 
   	    	{ event = 'effect', delay = 1.2, entity_id = 2002, layer = 2, effect_id = 10131,dx=0,dy=30,is_forever = true},
   	    	{ event = 'removeEffect', delay = 1.8,  entity_id = 2002,effect_id = 10131, },  
   	    	{ event = 'effect', delay = 2, entity_id = 2002, layer = 2, effect_id = 10131,dx=80,dy=-80,is_forever = true},	    	 
		},
	    {
	   		{ event = 'dialog',  delay =1,dialog_id = 116 },  
	    },
        {
          	{ event = 'carnet', delay = 2,dur = 0 },  
        },
    },

  --剧情副本第一章第一节 剧情5

     ['juqing115'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },

	    {
	       { event = 'dialog', dialog_id = 4 },  
	          --【苏茉】朝【赤羽】扔了块石头。
	          --执行动作 然后执行特效   playAction 未实现entity_id
	          -- { event = 'playAction', cast = 'cast200', delay = 2, action_id = 40, dur = 2, dir = 2 },
	          --如果不是服务器实体 则不用配置entity_id  可以配置cast
	       { event = 'playAction', entity_id=2002, delay = 2, action_id = 2, dur = 2, dir = 2 },
	       --石头特效移动 第一个是目标位置，其他两个是控制点，第二个决定高度
           
	    },
        {
	      { event = 'talk', delay = 0, entity_id=2002, isEntity = false,talk = '哎呀！[a]的表情',  emote = { a = 20, b = 2 }, dur = 1},
	      { event = 'talk', delay = 1, entity_id=2001, isEntity = false,talk = '闭嘴！', dur =1},
	    },
	    {
	   		 { event = 'dialog', dialog_id = 5 },  
	    },

	     {
	       --【苏茉】朝【赤羽】撒了一把粉尘。
	        { event = 'playAction', entity_id=2001, delay = 2, action_id = 2, dur = 2, dir = 2 },
	       --气雾状特效覆盖【赤羽】的头部
         	{ event = 'effect', delay = 1, entity_id = 2002, layer = 2, effect_id = 11049,},
		
         },
	    

	    {  --entity_id 配置需要移动的服务器端人物
	      { event = 'talk', delay = 0, entity_id=2002, isEntity = false,talk = '[a]',  emote = { a = 20, b = 2 }, dur = 0.5},
	      --倒地
	      { event = 'playAction', entity_id=2002, delay = 0.1, action_id = 4, dur = 2, dir = 2 },
		},
	
	    {
          { event = 'carnet', delay = 0.1,dur = 0 },  
        },
        --请求通关副本
        {
          { event = 'carnet', delay = 0.1,dur = 0 },  
        },
    },
    --============================================xiehande  剧情副本第一章第二节 end   =====================================----
     --============================================xiehande  剧情副本第一章第三节 start =====================================----
 
	--第一章第二节剧情1
    ['juqing121'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
     --    --苏茉和芙儿出现,三个巡逻店小二和百里寒也刷出
     --    {
	    --    { event = 'createActor', jqid=1 },
	    -- },
	    
	    --玩家移动
	    {
	      { event = 'move', delay = 0.1, cast = 'player', end_dir = 1, pos = {9, 44},speed = 340, dur = 1 },
	    },

        --店小二出现
        {
	       { event = 'createActor', jqid=2 },
	    },
	    --店小二移步上前
	    {
	      { event = 'move', delay = 0.1,entity_id=2025, end_dir = 5, pos = {14, 41},speed = 340, dur = 1 },
	      { event = 'talk', delay = 0.2, entity_id=2025, isEntity = false,talk = '你们给我出去。', dur = 1.5 },
	    },
	    --苏茉和芙儿转向
	    {
	      { event = 'move', delay = 0.1,entity_id=2021, end_dir = 3, pos = {11, 41},speed = 340, dur = 1 },
	      { event = 'talk', delay = 1.1, entity_id=2021, isEntity = false,talk = '！！！', dur = 1 },
          { event = 'move', delay = 0.1,entity_id=2022, end_dir = 1, pos = {12, 43},speed = 340, dur = 1 },
          { event = 'talk', delay = 1.1, entity_id=2022, isEntity = false,talk = '！！！', dur = 1 },
          { event = 'talk', delay = 1.1, cast = 'player', isEntity = false,talk = '！！！', dur = 1 },
	    },

	   --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 1},
        },
      
	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 7 },  
	    },

        --苏茉和芙儿移动后消失，店小二追赶后消失
        {
	      { event = 'move', delay = 0.1,entity_id=2021, end_dir = 1, pos = {33, 43},speed = 340, dur = 2.5 },
	      { event = 'talk', delay = 0.1, entity_id=2021, isEntity = false,talk = '快跑~', dur = 1 },
	      { event = 'kill', delay = 2.5,entity_id = 2021, dur = 0 }, 

          { event = 'move', delay = 0.3,entity_id=2022, end_dir = 1, pos = {33, 43},speed = 340, dur = 2.2 },
          { event = 'talk', delay = 1.1, entity_id=2022, isEntity = false,talk = '二楼见！', dur = 1 },
          { event = 'kill', delay = 2.5,entity_id = 2022, dur = 0 }, 

          { event = 'move', delay = 1.5,entity_id=2025, end_dir = 1, pos = {33, 43},speed = 340, dur = 2.5 },
          { event = 'talk', delay = 1, entity_id=2025, isEntity = false,talk = '别跑！', dur = 1 },
	      { event = 'kill', delay = 3.5,entity_id = 2025, dur = 0 }, 
	    },

	    --角色前置对白
	    {
	   	  { event = 'dialog', dialog_id = 8 },  
	    },
	   
        --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },
    },

    ['juqing122'] = 
    {
    	--苏茉采集怪上标记
    	{
    		{ event = 'changeVisible', delay = 0.1, entity_id1 = 2021, cansee1 = false, dur = 0 },
    		{ event = 'effect', delay = 0, entity_id = 2033, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
    		{ event = 'move', delay = 0.5, entity_id=2021, end_dir = 1, pos = {50,42,}, speed = 340, dur = 1 },
    	},
    },

    ['juqing123'] = 
    {
    	--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },

    	--苏茉对话并消失
    	{
    		{ event = 'changeVisible', delay = 0, entity_id1 = 2033, cansee1 = false, dur = 0 },
    		{ event = 'changeVisible', delay = 0, entity_id1 = 2021, cansee1 = true, dur = 0 },
    		{ event = 'move', delay = 0.1, cast = 'player', end_dir = 1, pos = {49,44,}, speed = 340, dur = 2.5 },
    		{ event = 'move', delay = 0.1, entity_id=2021, end_dir = 5, pos = {50,42,}, speed = 340, dur = 2.5 },
    		{ event = 'talk', delay = 1, entity_id = 2021, isEntity = false,talk = '去二楼等我，我吃完饼就来～', dur = 1.5 },
    		{ event = 'move', delay = 2, entity_id=2021, end_dir = 1, pos = {50,42,}, speed = 340, dur = 1 },
    	},
    },

    ['juqing124'] = 
    {
    	--如花采集怪上标记
    	{
    		{ event = 'changeVisible', delay = 0, entity_id1 = 2026, cansee1 = false, dur = 0 },
    		{ event = 'effect', delay = 0, entity_id = 2035, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
    		{ event = 'move', delay = 0.5, entity_id= 2026, end_dir = 7, pos = {26,31,}, speed = 340, dur = 1 },
    	},
    },

   	['juqing125'] = 
    {
    	--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },

    	--如花说话并消失
    	{
    		{ event = 'changeVisible', delay = 0, entity_id1 = 2026, cansee1 = true, dur = 0 },
    		{ event = 'changeVisible', delay = 0, entity_id1 = 2035, cansee1 = false, dur = 0 },
    		{ event = 'move', delay = 0.1, cast ='player', end_dir = 5, pos = {28,30,}, speed = 340, dur = 1 },
    		{ event = 'move', delay = 0.1, entity_id= 2026, end_dir = 1, pos = {26,31,}, speed = 340, dur = 1 },
    		{ event = 'dialog', delay = 1, dialog_id = 123 },
    	},
    	{
    		{ event = 'kill', delay = 1.5,entity_id = 2026, dur = 0 },
    	},
    },

    ['juqing126'] = 
    {
    	--芙儿采集怪上标记，并调整方向
    	{
    		{ event = 'changeVisible', delay = 0.1, entity_id1 = 2022, cansee1 = false, dur = 0 },
    		{ event = 'effect', delay = 0, entity_id = 2034, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
    		{ event = 'move', delay = 0.5, entity_id= 2022, end_dir = 7, pos = {10,29,}, speed = 340, dur = 1 },
    	},
    },

    ['juqing127'] = 
    {
    	--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },

    	--芙儿说话
    	{
    		{ event = 'changeVisible', delay = 0.1, entity_id1 = 2022, cansee1 = true, dur = 0 },
    		{ event = 'changeVisible', delay = 0.1, entity_id1 = 2034, cansee1 = false, dur = 0 },
    		{ event = 'changeVisible', delay = 0.1, entity_id1 = 2035, cansee1 = false, dur = 0 },
    		{ event = 'move', delay = 0.1, cast ='player', end_dir = 6, pos = {13,29,}, speed = 340, dur = 2.5 },
    		{ event = 'move', delay = 0.1, entity_id= 2022, end_dir = 2, pos = {10,29,}, speed = 340, dur = 2.5 },
    		{ event = 'talk', delay = 1, entity_id=2022, isEntity = false,talk = '找到茉儿啦？我去二楼等你们～', dur = 2 },
    		{ event = 'move', delay = 1.5, entity_id= 2022, end_dir = 5, pos = {21,20,}, speed = 280, dur = 3 },
    		{ event = 'kill', delay = 3, entity_id = 2022, dur = 0 },
    		{ event = 'kill', delay = 3, entity_id = 2021, dur = 0 },
    	},
    },

--第一章第二节剧情2
	['juqing128'] = 
	{    
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },

	    -- --创建行动角色 苏茉和芙儿
	    -- {
	    --   { event = 'createActor', jqid=3 },
	    -- },
        --主角移动，苏茉和芙儿转向
	    {
	      { event = 'move', delay = 0.5, cast = 'player', end_dir = 1, pos = {38, 10},speed = 340, dur = 1 },
	      { event = 'talk', delay = 0.5, cast = 'player', isEntity = false,talk = '我来啦', dur = 1 },
	      { event = 'move', delay = 0.5, entity_id=2021, end_dir = 5, pos = {40, 8},speed = 340, dur = 1 },
          { event = 'move', delay = 0.5, entity_id=2022, end_dir = 5, pos = {43, 8},speed = 340, dur = 1 },          
	    },

        --创建行动角色 瞎bb烦人店小二
	    {
	       { event = 'createActor', delay = 0.4, jqid = 17 },
	       { event = 'stopMonster', delay =0.5,ttype = 1},
	       { event = 'move', delay = 0.5,entity_id = 2032, end_dir = 7, pos = {44, 14},speed = 340, dur = 1 },
	    },
        
        {
	      { event = 'move', delay = 0.1,entity_id=2021, end_dir = 3, pos = {40, 8},speed = 340, dur = 1 },
	      { event = 'talk', delay = 0.6, entity_id=2021, isEntity = false,talk = '！！！', dur = 1 },
          { event = 'move', delay = 0.1,entity_id=2022, end_dir = 3, pos = {43, 8},speed = 340, dur = 1 },
          { event = 'talk', delay = 0.6, entity_id=2022, isEntity = false,talk = '！！！', dur = 1 },
          { event = 'move', delay = 0.1, cast = 'player', end_dir = 3, pos = {38, 10},speed = 340, dur = 1 },
          { event = 'talk', delay = 0.6, cast = 'player', isEntity = false,talk = '！！！', dur = 1 },
	    },
	   	--角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 10 },  
	    },
	    
	     --店小二攻击玩家
	    {
	        { event = 'createActor', jqid= 18 },
	    },
	    {
	    	{ event = 'stopMonster',delay =0.1,ttype = 0},
	    },



	    --停止或者打开怪物的动作  0 开始  1 停止
       -- { 
           --{event  = 'stopMonster',delay =0.1,ttype = 1},
       -- },
	    --角色前置对白
	   -- {
	   		-- { event = 'dialog', dialog_id = 11 },  
	   -- },

	    --停止或者打开怪物的动作  0 开始  1 停止
        --{ 
           --{event  = 'stopMonster',delay =0.1,ttype = 0},
       -- },

    },

--第一章第二节剧情3
 ['juqing129'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },

	   --创建角色 上官锦,小二移动至百里寒面前
	    {
	      	{ event = 'createActor', jqid = 20 },
	      	{ event = 'stopMonster',delay =0.2,ttype = 1},
	        { event = 'move', delay = 0.3,entity_id = 2032, end_dir = 3, pos = {43, 14},speed = 340, dur = 1 },
	    },

	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 12 },  
	    },

	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 13 },  
	    },
	    --角色消失 店小二
	    {
	   		{ event = 'kill', delay = 0.1,entity_id = 2032, dur = 0 },  
	    },
	    --苏茉 芙儿 玩家 上官锦 移步隔间
	    {
	      { event = 'move', delay = 0.5,entity_id=2021, dir = 6, pos = {44, 16},speed = 340, dur = 0.5, end_dir = 2 },
	      { event = 'move', delay = 1.1,entity_id=2022, dir = 6, pos = {44, 16},speed = 340, dur = 0.5, end_dir = 2 },
	      { event = 'move', delay = 1.6, cast = 'player', dir = 6, pos = {45, 16},speed = 340, dur = 0.5, end_dir = 2 },
	      { event = 'move', delay = 2.1,entity_id=2024, dir = 6, pos = {46, 17},speed = 340, dur = 0.5, end_dir = 2 },
	    },
	    --苏茉 芙儿 玩家 上官锦 移动到座位坐下
	    {
	      { event = 'move', delay = 0.5,entity_id=2021, dir = 6, pos = {54, 17},speed = 340, dur = 2, end_dir = 1 },   --end_dir方向为0-7,0为向上的12点钟方向，沿顺时针方向递增
	      { event = 'move', delay = 1.1,entity_id=2022, dir = 6, pos = {52, 16},speed = 340, dur = 2, end_dir = 1 },
	      { event = 'move', delay = 1.6, cast = 'player', dir = 6, pos = {57, 14},speed = 340, dur = 2, end_dir = 5 },
	      { event = 'move', delay = 2.1,entity_id=2024, dir = 6, pos = {55, 13},speed = 340, dur = 2, end_dir = 5 },
	    },

	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 14 },  
	    },
        --角色冒泡对白
	    {
	         { event = 'talk', delay = 1, entity_id=2021, isEntity = false,talk = '干杯干杯！', dur = 1.5 },--第一个干杯需要显示干杯的表情，角色苏茉
             { event = 'talk', delay = 1.5, entity_id=2022, isEntity = false,talk = '干杯干杯！', dur = 1.5 },--第一个干杯需要显示干杯的表情，角色芙儿
	         { event = 'talk', delay = 1.5, entity_id=2024, isEntity = false,talk = '干杯干杯！', dur = 1.5 },--第一个干杯需要显示干杯的表情，角色上官锦
	         { event = 'talk', delay = 1.5, cast = 'player', isEntity = false,talk = '干杯干杯！', dur = 1.5 },--第一个干杯需要显示干杯的表情，角色玩家
	    },
        --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 15 },  
	    },
	    --镜头的移动配置	    
	    {  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上 
	       { event = 'camera', delay = 0, dur=1,sdur = 0.5,style = '',backtime=1, c_topox = {2061, 561} },
	       { event = 'talk', delay = 0.1, entity_id=2023, isEntity = false,talk = '微笑表情', dur = 1.5 },
	    },

	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =1, dur=1,cast = 'player'},
	    },
        -- --镜头渐渐移动到邻桌百里寒处特写，百里寒气度不凡，充满霸气。
        -- {{ event = 'camera', entity_id = 2023,  delay = 1, dur=1, style = 'lookat' }},
        -- --镜头转回到全景
        -- {{ event = 'camera', cast = 'player',  delay = 1, dur=1, style = 'lookat' }},
        --冒泡
        {
	   		{ event = 'talk', delay = 0.1, entity_id=2024, isEntity = false,talk = '点头表情', dur = 1 }, 
	    },
	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 16 },  
	    },
       --冒泡
        {
	      { event = 'talk', delay = 0.1, entity_id=2021, isEntity = false,talk = '嗝儿……！', dur = 1.5 },
        },
        {
          { event = 'talk', delay = 0.1, entity_id=2023, isEntity = false,talk = '滴汗表情', dur = 1.5 },
          { event = 'talk', delay = 0.1, entity_id=2024, isEntity = false,talk = '滴汗表情', dur = 1.5 },
	    },
	    {
          { event = 'talk', delay = 0.1, cast = 'player', isEntity = false,talk = '苏茉她醉了。', dur = 1.5 },
          { event = 'talk', delay = 0.1, entity_id=2022, isEntity = false,talk = '这个疯丫头', dur = 1.5 },
	    },
	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 9 },  
	    },

	    --请求通关副本
        {
          { event = 'carnet', delay = 0.1,dur = 0 },  
        },
    },

    ['juqing12-ex'] = 
    {	--放5个小二的冒泡，统一请求此处
    	{
    		{ event = 'talk', delay = 0.1, entity_id=2027, isEntity = false,talk = '走走走！恕不接待', dur = 1 },
    		{ event = 'talk', delay = 0.1, entity_id=2028, isEntity = false,talk = '光听不给钱的快走！', dur = 1 },
    		{ event = 'talk', delay = 0.1, entity_id=2029, isEntity = false,talk = '蹭听说书的恕不接待！', dur = 1 },
    		{ event = 'talk', delay = 0.1, entity_id=2030, isEntity = false,talk = '不点东西就快走！', dur = 1 },
    		{ event = 'talk', delay = 0.1, entity_id=2031, isEntity = false,talk = '走走走！恕不接待', dur = 1 },
    		{ event = 'changeVisible', delay = 0.1, entity_id1 = 2035, cansee1 = false, dur = 0 },
    	},
    },
    --============================================xiehande  剧情副本第一章第三节   =====================================----
    --============================================xiehande  剧情副本第一章第四节   =====================================----
   --剧情副本第一章第三节剧情1
   ['juqing131'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
		   { event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {2,38},speed = 340, dur = 1, end_dir =3 },
	    },
	    	    --芙儿 和 苏茉
	    -- { { event = 'createActor', jqid=1 },},
	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 17 },  
	    },
	    {
	     { event = 'kill', delay = 0.1,entity_id = 2041, dur = 0 },  
	     { event = 'kill', delay = 0.1,entity_id = 2042, dur = 0 }, 
	    },
	    {
	         { event = 'createActor', jqid=2 }, 
	    },
    },

   --剧情副本第一章第三节剧情2
   ['juqing132'] = 
	{
		--动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
	    {   --玩家移动到剧情位置
	    	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {32,37},speed = 340, dur = 1, end_dir =7 },
	    },
	    --角色前置对白
	    {

	   		 { event = 'dialog', dialog_id = 18 },  
	    },
	    {
	     { event = 'kill', delay = 1,entity_id = 2041, dur = 0 },  
	     { event = 'kill', delay = 1,entity_id = 2042, dur = 0 }, 
	    },
	    {
           --刷出大祭司
           { event = 'createActor', jqid = 6 },  
	    },
    },

   --剧情副本第一章第三节剧情3
   ['juqing133'] = 
	{
		
	    --动画组
	    {   
	       { event = 'disableSceneClicks' },		-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'hideAvatars' , delay = 0 },		-- 动画片段
	    },
	    {   --玩家移动到剧情位置
	    	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {36,25},speed = 340, dur = 1, end_dir =3 },
	    },
	    --角色前置对白
	    {
	   		 { event = 'dialog', dialog_id = 19 },  
	    },
	    -- #cd71345 动画 苏茉和芙儿一块跪坐在火炉旁边，两人用刀子划开自己的手，把血抹在玉石上，紧接着玉石泛着光芒，把血吸入其中，出现一个象形文字的符号。
	    --changeRGBA:屏幕渐变方法 点击后变白继续  txt 显示的文字
	    {
	    {event = 'changeRGBA',delay=1,dur=2,txt = "苏茉和芙儿一块跪坐在火炉旁边，两人用刀子划开自己的手，把血抹在玉石上，紧接着玉石泛着光芒，把血吸入其中，出现一个象形文字的符号。"},
		},
	    --族长出现
	    {
           { event = 'createActor', jqid = 8 },  
	    },
	    {
	       --族长冒泡对白
	       { event = 'talk', delay = 1, entity_id = 2043, isEntity = false,talk = '{生气}表情', dur = 1.5 },
	    },
	    {   --玩家移动到剧情位置
	    	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {36,25},speed = 340, dur = 1, end_dir =7 },
	    },

        {
	   		 { event = 'dialog',delay = 1, dialog_id = 20 },  
	    },
	    {
	   	    { event = 'talk', delay = 1, entity_id = 2041, isEntity = false,talk = '委屈表情', dur = 1.5 },
		    { event = 'talk', delay = 1.5, cast = 'player', isEntity = false,talk = '委屈表情', dur = 1.5 },
	    },
        {
	   		 { event = 'dialog', dialog_id = 21 },  
	    },
	    {
	      { event = 'talk', delay = 1, entity_id = 2041, isEntity = false,talk = '忍住眼泪的表情', dur = 1.5 },
	      { event = 'talk', delay = 1.5, cast = 'player', isEntity = false,talk = '不服气的表情', dur = 1.5 },
	      { event = 'talk', delay = 2, entity_id = 2042, isEntity = false,talk = '难过的表情', dur = 1.5 },
	    },
	    {
	     { event = 'kill', delay = 0.5,entity_id = 2041, dur = 0 },  
	     { event = 'kill', delay = 0.5,entity_id = 2042, dur = 0 }, 
	     { event = 'kill', delay = 0.5,entity_id = 2043, dur = 0 },
	    },

		--请求通关副本
        {
          { event = 'carnet', delay = 0.1,dur = 0 },  
        },

    },
--     --============================================xiehande  剧情副本第一章第四节   end   =====================================----
--     --============================================xiehande  剧情副本第一章第五节 start   =====================================----
  --剧情副本第一章第四节剧情1
    ['juqing141'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	   
		
	    --角色前置对白
	    --{
	      --{ event = 'dialog', dialog_id = 22 },
	    --},
	    {--震屏效果
	    	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {4,39,},speed = 340, dur = 1,end_dir =3 },
	    	{ event = 'shake', delay = 2.1, dur = 1,c_topox = {446,1210,},index = 50, rate = 3, radius = 20 },  
	    	--隐藏青龙和朱雀
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2077, cansee1 = false,entity_id2 = 2078,cansee2 = false,dur = 0 }, 
	    },
	    { 
	      { event = 'talk', delay = 0, entity_id=2056, isEntity = false,talk = '惊讶！', dur = 1 },
	      { event = 'talk', delay = 0, cast = 'player', isEntity = false,talk = '惊讶！', dur = 1 },
	      { event = 'talk', delay = 0, entity_id=2057, isEntity = false,talk = '惊讶！', dur = 1 },
	      { event = 'talk', delay = 0, entity_id=2058, isEntity = false,talk = '惊讶！', dur = 1 },
	    },
	    --镜头的移动配置	    
	    {  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	    	{ event = 'camera', delay = 0.1, dur=0,sdur = 6,style = '',backtime=1, c_topox = {1119, 1053} },
		--},
		--四个光柱
		--{
			{ event = 'effect', delay = 0.5, effect_id = 20011, layer = 2, pos = {45,29}},	    --白虎
			{ event = 'effect', delay = 1, effect_id = 20014, layer = 2, pos = {25,29}},		--青龙
			{ event = 'effect', delay = 1.5, effect_id = 20013, layer = 2, pos = {45,37}},	--玄武
			{ event = 'effect', delay = 2, effect_id = 20012, layer = 2, pos = {25,37}},		--朱雀
			--星宿图
			{ event = 'effect', delay = 1, effect_id = 20007, layer = 2, pos = {45,26},is_forever=true},	--白虎
			{ event = 'effect', delay = 1.5, effect_id = 20008, layer = 2, pos = {25,25},is_forever=true}, 	    --青龙
			{ event = 'effect', delay = 2, effect_id = 20010, layer = 2, pos = {45,34},is_forever=true},	--玄武
			{ event = 'effect', delay = 2.5, effect_id = 20009, layer = 2, pos = {26,34},is_forever=true},	    --朱雀
			{ event = 'changeVisible', delay = 3.5,entity_id1 = 2077, cansee1 = true,entity_id2 = 2078,cansee2 = true,dur = 0 }, 
		},
		--特效消失出现青龙和朱雀
		{
			--两个东西播动作
	    	{ event = 'playAction', entity_id = 2077, delay = 0.1, action_id = 2, dur = 1, dir = 2,loop = false},
	    	{ event = 'playAction', entity_id = 2077, delay = 1.1, action_id = 2, dur = 1, dir = 2,loop = false},
	    	{ event = 'playAction', entity_id = 2078, delay = 0.1, action_id = 2, dur = 1, dir = 6,loop = false},
	    	{ event = 'playAction', entity_id = 2078, delay = 1.1, action_id = 2, dur = 1, dir = 6,loop = false},
	    	{ event = 'shake', delay = 0.1, dur = 1,c_topox = {1152, 1000},index = 30, rate = 4, radius = 20 }, 
	    	{ event = 'shake', delay = 1.1, dur = 1,c_topox = {1152, 1000},index = 30, rate = 4, radius = 20 }, 
			{ event = 'removeEffect', delay = 1,  pos = {25,25},effect_id = 20008, },
			{ event = 'removeEffect', delay = 1,  pos = {26,34},effect_id = 20009, },
			{ event = 'removeEffect', delay = 1,  pos = {45,26},effect_id = 20007, },
			{ event = 'removeEffect', delay = 1,  pos = {45,34},effect_id = 20010, },
			--朱雀和青龙播放特效
			--{ event = 'effect', delay = 0.1, effect_id = 20009, layer = 0, entity_id = 2078,dx=0,dy=-100,is_forever=true},
			--{ event = 'effect', delay = 0.1, effect_id = 20008, layer = 0, entity_id = 2077,dx=0,dy=-100,is_forever=true},
	    },

	    --强制摄像机回到玩家身上
	    {
	       { event = 'camera', delay =0, dur=2,cast = 'player'},
	       { event = 'kill', delay = 1,entity_id = 2077, dur = 0 },
	       { event = 'kill', delay = 1,entity_id = 2078, dur = 0 },
	    },

	    --前置对话 【苏茉】：上官大哥，发生什么事儿了！你看到族长老爹和芙儿了吗？
	    {
	      { event = 'dialog', dialog_id = 23 },  
	    },

	    --赤羽、上官锦、苏茉走了
	    {
	    	{ event = 'move', delay = 0.1,entity_id=2058, dir = 6, pos = {0,35,},speed = 340, dur = 1 },
	    	{ event = 'move', delay = 0.1,entity_id=2057, dir = 6, pos = {0,36,},speed = 340, dur = 1 },
	    	{ event = 'move', delay = 0.1,entity_id=2056, dir = 6, pos = {0,37,},speed = 340, dur = 1 },
	    	{ event = 'kill', delay = 1,entity_id = 2058, dur = 0 },  
	   		{ event = 'kill', delay = 1,entity_id = 2057, dur = 0 },
	   		{ event = 'kill', delay = 1,entity_id = 2056, dur = 0 },
	    },

	    --前置对话 【玩家】：苏茉有他们俩保护应该没事
	    {
	      { event = 'dialog', dialog_id = 24 },  
	    },

	    --请求进入阶段2，刷出西戎人
	    {
	      { event = 'createActor', jqid=2 }, 
	    },
    },

  --剧情副本第一章第四节剧情2
   ['juqing142'] = 
	{	   	
 		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0,ttype = 1},
        },

	    --玩家移动到剧情位置
	    {	
        	--芙儿逃跑  
            { event = 'move', delay = 0.1,entity_id=2059, dir = 6, pos = {20,50},speed = 340, dur = 2.5 },
	        { event = 'talk', delay = 0.1, entity_id=2059, isEntity = false,talk = '救命！救命！', dur = 2 },
        	--黑衣人出现
	        { event = 'move', delay = 1,entity_id=2073, dir = 6, pos = {22,48},speed = 320, dur = 1.8},
	        { event = 'talk', delay = 0.7,entity_id=2073, isEntity = false,talk = '别跑！',dur = 1 },
	        { event = 'camera', delay = 0.5, dur=0,sdur = 0.5,style = '',backtime=1, entity_id = 2059},
	        { event = 'camera', delay = 0.7, dur=1.8,sdur = 1,style = '',backtime=1, c_topox = {629,1612,}},
        }, 
        --芙儿摔倒
        {
        	{ event = 'move', delay = 0.1,entity_id=2073, dir = 6, pos = {19,51},speed = 100, dur = 1, end_dir=1},
        	{ event = 'playAction', entity_id = 2059, delay = 0.5, action_id = 4, dur = 1, dir = 5,loop = false},--芙儿摔倒
        	{ event = 'talk', delay = 0.5, entity_id=2059, isEntity = false,talk = '啊……', dur = 1},
        },
        {
        	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {16,52,},speed = 340, dur = 1,end_dir=1},
        	{ event = 'talk', delay = 0.1,cast='player', isEntity = false,talk = '放开芙儿！', dur = 1},
        	{ event = 'move', delay = 0.5,entity_id=2073, dir = 6, pos = {19,51},speed = 340, dur = 1,end_dir=5},
	    	{ event = 'talk', delay = 1.5, entity_id=2073, isEntity = false,talk = '多管闲事！', dur = 1},
	    },
	    --停怪打开
	    { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },
	    --请求进入阶段4，黑衣人朝玩家袭来
        {
           { event = 'createActor', jqid= 4},
	    },
    },

--剧情副本第一章第四节剧情3
   ['juqing143'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    {--芙儿进入待机动作
	     	{ event = 'playAction', entity_id = 2059, delay = 0.1, action_id = 0, dur = 1.5, dir = 6,loop = false},
	    },

	    -- {  --玩家移动到剧情位置           
	    -- 	{ event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {38,36,},speed = 340, dur = 1 },
	    -- },

	    --前置对白
	    {
	     { event = 'dialog',delay = 0, dialog_id = 28 },  
	    },
	    --赤羽跑
        {
        	{ event = 'move', delay = 0.1,entity_id= 2057, dir = 6, pos ={ 8,43 },speed = 300, dur = 1 },
	    },
	   	--芙儿跑了
	    {
	    	{ event = 'kill', delay = 0.1,entity_id = 2057, dur = 0 },
	    	{ event = 'move', delay = 0.1,entity_id=2059, dir = 6, pos = {30,20},speed = 350, dur = 0.5 },    	
	    },
	 },

	 --刷出黑衣人芙儿害怕
	['juqing144'] = 
	{
		{
			{ event = 'talk', delay = 0.1, entity_id=2059, isEntity = false,talk = '{害怕}的表情', dur = 5 },
		},
	},

	--黑衣人死了
	['juqing145'] = 
	{    
	    {
	       { event = 'effect', delay = 0, entity_id = 2059, layer = 2, effect_id = 8,dx=0,dy=30},
	    },
	},

   	['juqing146'] = 
   	{
   		--请求进入阶段9，解锁障碍
	    {
	      { event = 'createActor', jqid=9 }, 
	    },
	    {
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2059},
    	    { event = 'talk', delay = 0.1, cast = 'player', isEntity = false,talk = '别怕，有我在。', dur = 1.5 },
	    	{ event = 'move', delay = 0.5,entity_id=2059, dir = 6, pos = {68,9},speed = 340, dur = 1,end_dir=3},
	    },  
   	},

	 --刷出西戎人芙儿害怕
	['juqing147'] = 
	{
		{
			{ event = 'talk', delay = 0.1, entity_id=2059, isEntity = false,talk = '{哭泣}的表情', dur = 5 },
		},
	},

	--西戎人死了，芙儿头顶出现特效
   	['juqing148'] = 
	{    
	    {
	       { event = 'effect', delay = 0, entity_id = 2059, layer = 2, effect_id = 8,dx=0,dy=30},
	    },
	},
   
   --第二次点击芙儿之后
   ['juqing149'] = 
   {
   		--请求进入阶段13，解锁障碍
	    {
	      { event = 'createActor', jqid=13 }, 
	    },
	    {
	        { event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2059},
    	    { event = 'talk', delay = 0.1, cast = 'player', isEntity = false,talk = '别哭，我会保护你的。', dur = 1 },
	    	{ event = 'move', delay = 1,entity_id=2059, dir = 6, pos = {77,15},speed = 340, dur = 1 },
	    },
   },

  -- 剧情副本第一章第四节剧情5
    ['juqing1410'] = 
    {   --动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    --前置对白
	    {
	   	  { event = 'dialog', delay = 0.1, dialog_id = 29 },  
	    },

	    --移动摄像机
	    {
	       { event = 'camera', delay = 0.1, dur=0,sdur = 2,style = '',backtime=1, c_topox = {2446,847,}},
	    --请求后端，创建黑衣人
           { event = 'createActor', jqid= 15,delay=0.5},
	    },
	    --摄像头强制回归
	    {
	    	{ event = 'camera', delay =0.5, dur=0,cast = 'player'},
	    	{ event = 'move', delay = 0.1,entity_id=2059, dir = 6, pos = {77,15},speed = 340, dur = 1,end_dir = 3},
	    	{ event = 'move', delay = 0.1,entity_id=2056, dir = 6, pos = {79,17},speed = 340, dur = 1,end_dir = 5},
	    	{ event = 'talk', delay = 0.5, entity_id=2059, isEntity = false,talk = '{害怕}', dur = 1.5 },
	    	{ event = 'talk', delay = 0.5, entity_id=2056, isEntity = false,talk = '{害怕}', dur = 1.5 },
	    	{ event = 'talk', delay = 0.5, cast = 'player', isEntity = false,talk = '我来对付他们。', dur = 1.5 },
	    },
	},

    ['juqing1411'] = 
    {
    	{   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },	

	    --隐藏柳若霜
	    {
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2070, cansee1 = false,dur = 0 },  
	    },
	   --镜头快速平移到百里寒处
	    {
	       { event = 'camera', delay = 1, dur=0,sdur = 2,style = '',backtime=1, entity_id = 2060 },
	    },

        {         
	        { event = 'kill', delay = 0.1,entity_id = 2061, dur = 0 }, 
	        { event = 'effect', delay = 0.1, entity_id = 2070, layer = 2, effect_id = 20016,dx=0,dy=0},
	        { event = 'changeVisible', delay = 0.1,entity_id1 = 2070, cansee1 = true,entity_id2 = 2061, cansee2 = false,dur = 0 },  
	    },

	    {
	    	{ event = 'dialog', delay = 0.1, dialog_id = 37 }, 
	    },

	    --镜头从百里寒的双眼处再次回到【玩家】等人处
	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0.8, dur=0,cast = 'player'},
	    },
		--请求通关副本
        {
          { event = 'carnet', delay = 1,dur = 0 },  
        },
    },
--     --============================================xiehande  剧情副本第一章第四节  end =====================================----
--     --============================================xiehande  剧情副本第二章第一节 start   =====================================----
	--柳若霜 2084
	--芙儿	 2082
	--苏沫	 2083
	--百里寒 2085
	--赤羽	 2087
	--上官锦 2086
	--A区小怪  2088
	--B区小怪  2089
	--C区小怪（百里寒召唤）  2090
	--采集物A  2091
	--采集物B  2092
	--采集物C  2093
	--灯怪A-亮  2094
	--灯怪B-亮   2095
	--灯怪C-亮   2096


    --剧情副本第二章第一节剧情1
   ['juqing211'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    --弄些场景特效出来
        {
        	--===================================A区域迷雾特效====================================
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {56,47}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {58,46}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {62,26}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {64,48}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {68,52}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {71,50}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {72,53}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {69,56}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {65,48}, is_forever = true},
	    	--===================================B区迷雾特效===========================================
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {62,34}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {65,32}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {61,30}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {56,31}, is_forever = true},   
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {65,28}, is_forever = true}, 	
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {52,32}, is_forever = true}, 
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {49,32}, is_forever = true}, 
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {51,35}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {51,25}, is_forever = true}, 
	    	--===================================C区迷雾特效========================================
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {27,34}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {30,35}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {32,37}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {35,38}, is_forever = true},   
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {38,40}, is_forever = true}, 	
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {42,39}, is_forever = true}, 
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {41,42}, is_forever = true}, 
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {35,41}, is_forever = true}, 
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {31,41}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20001, layer = 2, pos = {27,38}, is_forever = true},
	    },

	    --隐藏不该出现的灯怪
		{
           { event = 'changeVisible', delay = 0.1,entity_id1 = 2097, cansee1 = false,entity_id2 = 2098,cansee2 = false,dur = 0 },  
           { event = 'changeVisible', delay = 0.1,entity_id1 = 2099, cansee1 = false,entity_id2 = 2100,cansee2 = false,dur = 0 }, 
        },
	    --前置对话  【苏茉】走错了吧，百里将军的房子不是在那么？姑娘，柳姑娘！
	    {
	      { event = 'dialog', dialog_id = 38 },  

	    },
	    --苏茉和芙儿往前走了几步后消失了
	    {
	    -- 2083 苏茉       2082 芙儿
          { event = 'move', delay = 0.3, entity_id = 2082, dir = 6,pos = {58, 47},speed = 340, dur = 2 },
          { event = 'move', delay = 0.3, entity_id = 2083, dir = 6,pos = {58, 47},speed = 340, dur = 2 },
	      { event = 'kill', delay = 1.5, entity_id = 2083, dur = 0 },  
	      { event = 'kill', delay = 1.5, entity_id = 2082, dur = 0 },  
	    },
	    --玩家说话 【玩家】苏茉，芙儿……你们等等我……哎，怎么都走散了。
        {
	     { event = 'dialog', dialog_id = 39 },  
	    },
	    --请求剧情2
	    {
	    	{ event = 'createActor', jqid=2 },
	    	{ event = 'effect', delay = 0.5, entity_id = 2092, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    	{ event = 'effect', delay = 0.5, entity_id = 2091, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    },
    },

    --剧情副本第二章第一节剧情2 
   ['juqing212'] = 
	{
		-- --动画组
	 --    {   
	 --       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		--    { event = 'hideUI' , delay = 0 },		-- 动画片段s
		--    { event = 'disableSceneClicks' },		-- 动画片段
	 --    },
	    -- 杀死采集物A，出现灯怪A
	    {
	    	{ event = 'kill', delay = 0.1, entity_id = 2091, is_forever = 0 }, 
	    	{ event = 'kill', delay = 0.1, entity_id = 2092, is_forever = 0 },
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2092},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2091},
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2097, cansee1 = true,entity_id2 = 2091,cansee2 = false,dur = 0 }, 
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2098, cansee1 = true,entity_id2 = 2092,cansee2 = false,dur = 0 }, 
	    },

	    --删除特效
	    {
	    --删除特效 1.如果是实体身上的特效配置entity_id,2.如果是场景特效配置格子坐标 pos， 3.如何是主角身上特效 配置 cast='player'
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {56,47}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {58,46}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {62,26}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {64,48}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {68,52}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {71,50}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {72,53}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {69,56}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {65,48}},
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {59,50}},
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {55,51}},
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {56,51}},
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {57,51}},   
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {55,51}}, 	
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {59,51}}, 
	    	-- { event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {55,52}}, 
	    },
	},

	--出现特效箭头采集物B
	['juqing213'] = 
	{
		{
			{ event = 'effect', delay = 0.5, entity_id = 2093, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    	{ event = 'effect', delay = 0.5, entity_id = 2094, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    },
	},

	--剧情副本第二章第一节剧情3 
   ['juqing214'] = 
	{
		-- --动画组
	 --    {   
	 --       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		--    { event = 'hideUI' , delay = 0 },		-- 动画片段
		--    { event = 'disableSceneClicks' },		-- 动画片段
	 --    },
	    -- 杀死采集物B，出现灯怪B
	    {
	    	{ event = 'kill', delay = 0.1, entity_id = 2093, dur = 0 }, 
	    	{ event = 'kill', delay = 0.1, entity_id = 2094, dur = 0 }, 
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2099, cansee1 = true,entity_id2 = 2093,cansee2 = false,dur = 0 }, 
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2100, cansee1 = true,entity_id2 = 2094,cansee2 = false,dur = 0 },  
	    },
	    --隐藏重新刷出来的灯怪A
	    {	
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2097, cansee1 = false,entity_id2 = 2098,cansee2 = false,dur = 0 },
		},
		--删除B区域迷雾特效
	    {	    	
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {62,34}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {65,32}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {61,30}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {56,31}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {65,28}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {52,32}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {49,32}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {51,35}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {51,25}},
	    },
	},

	--出现特效采集物C箭头
	['juqing215'] = 
	{
		{
	    	{ event = 'effect', delay = 0.5, entity_id = 2095, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    	{ event = 'effect', delay = 0.5, entity_id = 2096, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    },
	},

	--剧情副本第二章第一节剧情4 
   ['juqing216'] = 
	{
		-- --动画组
	 --    {   
	 --       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		--    { event = 'hideUI' , delay = 0 },		-- 动画片段
		--    { event = 'disableSceneClicks' },		-- 动画片段
	 --    },
	    --杀死采集物C，出现灯怪C
	    {
	    	{ event = 'kill', delay = 0.1, entity_id = 2095, dur = 0 }, 
	    	{ event = 'kill', delay = 0.1, entity_id = 2096, dur = 0 }, 
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2097, cansee1 = true,entity_id2 = 2095,cansee2 = false,dur = 0 }, 
	    	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2098, cansee1 = true,entity_id2 = 2096,cansee2 = false,dur = 0 }, 
	    },
	    --删除C区域迷雾特效
	    {	    	
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {27,34}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {30,35}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {61,30}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {32,37}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {35,38}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {38,40}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {42,39}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {41,42}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {35,41}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {31,41}},
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 20001, pos = {27,38}},
	    },
	    --请求进入阶段10,刷苏茉
	    {
	    	{ event = 'createActor', jqid=10 },
		},
	},

    --剧情副本第二章第一节剧情5
   ['juqing217'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    --苏茉和芙儿冒泡,看实际情况是否要加镜头移动
	    {
	    	{ event = 'camera', delay = 0.1, dur=1,sdur = 4,style = '',backtime=2, c_topox = {1138, 1130}},
		    { event = 'talk', delay = 0.1, entity_id=2082, isEntity = false,talk = '都说洞冥草能照见鬼。', dur = 1 },
		    { event = 'talk', delay = 1.5, entity_id=2083, isEntity = false,talk = '你别吓我！', dur = 1 },
		    { event = 'talk', delay = 2.5, entity_id=2082, isEntity = false,talk = '不怕有我在呢！', dur = 1 },
		--玩家走近两人
            { event = 'move', delay = 2.5, cast = 'player', dir = 6,pos = {27, 36},speed = 340, dur = 2 },
		},
		--苏茉惊恐
	    {
		    { event = 'talk', delay = 1.1, entity_id=2083, isEntity = false,talk = '啊！！！你们看！{惊恐}表情', dur = 1 },
		},
		--特写镜头从苏茉处缓缓移动到其青龙雕像处
	    {
	       { event = 'camera', delay = 0.5, dur=1,sdur = 1,style = '',backtime=1, c_topox = {495, 1051} },
        },
        --前置对白  【玩家】青龙像！
		{
		   { event = 'dialog', dialog_id = 40 },  
		},
		--客户端请求刷出百里寒
  		{
	      { event = 'createActor', jqid=11 }, 
	    },
    },

    --剧情副本第二章第一节剧情3
   ['juqing218'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    --前置对白 【百里寒】不准走！
	    {
		    --{ event = 'talk', delay = 0.5, entity_id=2085, isEntity = false,talk = '霜儿，上！', dur = 1 },
		    { event = 'dialog', dialog_id = 41,delay = 2},  
		},
        --柳若霜快速冲过去
	    {
	     --{ event = 'playAction', entity_id = 2084, delay = 0.1, action_id = 2, dur = 1.5, dir = 6,loop = false},
	     	{ event = 'move', delay = 1, entity_id = 2084, dir = 6, pos = {33, 37},speed = 50, dur = 1 },
	   	 --苏茉和芙儿播放受击特效
	   	 	{ event = 'effect', delay = 1.5, entity_id = 2082, layer = 1, effect_id = 20015,dx= 0,dy = -50},
	     	{ event = 'effect', delay = 1.5, entity_id = 2083, layer = 1, effect_id = 20015,dx= 0,dy = -50}, 
	     --{ event  = 'stopMonster',delay =0.1,ttype = 1}, --停止或者打开怪物的动作  0 开始  1 停止
		--苏茉&芙儿啊···
	    	{ event = 'playAction', entity_id=2082, delay = 1.5, action_id = 3, dur = 2, dir = 6 }, 
	    	{ event = 'playAction', entity_id=2083, delay = 1.5, action_id = 3, dur = 2, dir = 6 }, 
        	{ event = 'talk', delay = 1.5, entity_id=2082, isEntity = false,talk = '啊……', dur = 1 },
        	{ event = 'talk', delay = 1.5, entity_id=2083, isEntity = false,talk = '啊……', dur = 1 },
		},

		--前置对白 	【百里寒】将她们二人的血滴在青龙雕像上。
		{
		   { event = 'dialog', dialog_id = 105 },  
		},
		--柳若霜MOVE
		{
			{event = 'move', delay = 1, entity_id = 2084, dir = 6, pos = {17, 37},speed = 340, dur = 2,end_dir =3},
		},

		--青龙雕像开始泛着绿色光芒
		{
			{ event = 'effect', delay = 1, effect_id = 11049, layer = 2, pos = {15,37},is_forever =true},
		--芙儿周身也开始泛着绿色光芒
			{ event = 'effect', delay = 1.1,  entity_id = 2082, layer = 2, effect_id = 11049,dx= 0,dy = -100, is_forever =true},  --dx,dy表示偏移
        --冒泡对白 芙儿
		    { event = 'talk', delay = 1.1, entity_id=2082, isEntity = false,talk = '{失神}', dur = 1 },
		},

		{
		--苏茉身上也开始泛着红色光芒
  			{ event = 'effect', delay = 0.5, entity_id = 2083, layer = 2, effect_id = 11049,dx= 0,dy = -100,is_forever =true},
		--冒泡对白 苏茉
		    { event = 'talk', delay = 0.5, entity_id=2083, isEntity = false,talk = '{疑惑}的表情', dur = 1 },
		},
		--玩家身上也突然窜出两股特效（一红一绿）围绕着玩家飞舞旋转。
		{
	        { event = 'effect', delay = 0.5, cast = 'player', layer = 2, effect_id = 11049,dx= 0,dy = -100,is_forever =true},--is_forever =true
		},
		--前置对白【百里寒】是朱雀！唔？不光是朱雀，这是什么？同时拥有青龙和朱雀之力？这不可能
	    {
		   { event = 'dialog',delay = 1,dialog_id = 42 },  
		--玩家的光芒特效渐渐消失。 tag= 需要消失的特效ID
		   { event = 'removeEffect', delay = 1, cast = 'player', effect_id = 11049 }, 
		},
  --       --前置对白 【百里寒】你到底是谁？
		-- {
		--    { event = 'dialog', dialog_id = 43,delay = 1 },  
		-- },
		--百里寒召唤出一波怪攻击玩家 
		{
	       { event = 'createActor', jqid=12 }, 
	    },
    },


  --剧情副本第二章第一节剧情4
   ['juqing219'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    --上官锦、赤羽、百里寒、柳若霜冒特效
	    {
		    -- { event = 'talk', delay = 0, entity_id=160, isEntity = false,talk = '#cff0033鬼', dur = 1 },
		    -- { event = 'talk', delay = 0, entity_id=155, isEntity = false,talk = '#cff0033星', dur = 1 },
		    -- { event = 'talk', delay = 0, entity_id=145, isEntity = false,talk = '#cff99cc66角', dur = 1 },
		    -- { event = 'talk', delay = 0, entity_id=126, isEntity = false,talk = '#cff99cc66氐', dur = 1 },
			{ event = 'effect', delay = 1, entity_id = 2086, layer = 2, effect_id = 11049,dx= 0,dy = -100,is_forever =true},
	    	{ event = 'effect', delay = 1, entity_id = 2087, layer = 2, effect_id = 11049,dx= 0,dy = -100,is_forever =true},
	   		{ event = 'effect', delay = 1, entity_id = 2084, layer = 2, effect_id = 11049,dx= 0,dy = -100,is_forever =true},
	    	{ event = 'effect', delay = 1, entity_id = 2085, layer = 2, effect_id = 11049,dx= 0,dy = -100,is_forever =true},
		},
		--前置对白 【百里寒】没想到上官公子和赤羽公子都是朱雀七星。
	    {
		   { event = 'dialog', delay = 1,dialog_id = 44 },  
		},

	    {
	    --百里寒，赤羽，上官锦，苏茉，芙儿全部消失
	       { event = 'kill', delay = 0.1,entity_id = 2086, dur = 0 },  
	       { event = 'kill', delay = 0.1,entity_id = 2087, dur = 0 },  
	       { event = 'kill', delay = 0.1,entity_id = 2082, dur = 0 },  
	       { event = 'kill', delay = 0.1,entity_id = 2085, dur = 0 },  
	       { event = 'kill', delay = 0.1,entity_id = 2083, dur = 0 },
	       { event = 'removeEffect', delay = 1, entity_id = 2084, effect_id = 11049},  
	    },
	    --柳若霜红名变成精英怪攻击玩家。
	    {
	      { event = 'createActor', jqid=14 }, 
	      --{ event  = 'stopMonster',delay =0.1,ttype = 0},	--打开停怪
	    },
    },

    --副本结算，播放剧情8
	['juqing2110'] = 
	{
		--请求通关副本
        {
          { event = 'carnet', delay = 1.5,dur = 0 },  
        },
	},
    --============================================xiehande  剧情副本第二章第一节  end   =====================================----
    --============================================xiehande  剧情副本第二章第二节  start =====================================----
  --剧情副本第二章第二节剧情1
   ['juqing221'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    {
		   { event = 'dialog', dialog_id = 45, delay = 1},  
		},
		--宏泰消失
		{
	    	{ event = 'kill', delay = 0.1,entity_id = 2103, dur = 0 },  
		},

		--进入阶段2,隐藏把手2
		{
	 		{ event = 'createActor', jqid=2 },
	 		{ event = 'changeVisible', delay = 0.1,entity_id1 = 2117, cansee1 = false,dur = 0 },
	 	},
    },
    --第二章第二节剧情1.1
    ['juqing2211'] =
    {
    	{
    		{ event = 'effect', delay = 0.1, entity_id = 2112, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
    	},
	},
    
    --剧情副本第二章第二节剧情2
    ['juqing222'] = 
	{
		-- --动画组
	 --    {   
	 --       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		--    { event = 'hideUI' , delay = 0 },		-- 动画片段
		--    { event = 'disableSceneClicks' },		-- 动画片段
	 --    },
		--停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 1},
        },
        --杀掉牢门1
        {
        	{event = 'kill', delay = 0.1, entity_id=2112, dur = 0},
        },
		--上官锦跑出来冒泡
	    {
		   { event = 'move', delay = 0.1, entity_id = 2104, dir = 6,pos = {19, 29},speed = 340, dur = 1 ,end_dir=4},
		   { event = 'talk', delay = 0.5, entity_id=2104, isEntity = false,talk = '你先去救其他人。', dur = 2 }, 
		},
		{
		    { event = 'kill', delay = 0.1,entity_id = 2104, dur = 0 },
	    	-- { event = 'kill', delay = 0.1,entity_id = 2103, dur = 0 },  
		},
		--停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },
    },

    --第二章第二节剧情2.1
    ['juqing2221'] =
    {
    	{
    		{ event = 'effect', delay = 0.5, entity_id = 2113, layer = 2, effect_id = 8,dx= 0,dy = 50,loop = true},
    	},
	},

    --剧情副本第二章第二节剧情3
    ['juqing223'] = 
	{
		--动画组
	    -- {   
	    --    { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   -- { event = 'disableSceneClicks' },		-- 动画片段
	    -- },
		-- --停止或者打开怪物的动作  0 开始  1 停止
  --       { 
  --          {event  = 'stopMonster',delay =0.1,ttype = 1},
  --       },
        --杀掉牢门2
        {
        	{event = 'kill', delay = 0.1, entity_id=2113, dur = 0},
        },    
		--赤羽跑出来冒泡
	    {
		   { event = 'move', delay = 0.1, entity_id = 2105, dir = 6,pos = {31, 23},speed = 340, dur = 1 ,end_dir=4},
		   { event = 'talk', delay = 0.5, entity_id=2105, isEntity = false,talk = '快去救苏茉。', dur = 2 }, 
		},
		--宏泰和赤羽在原地消失
		{
			{ event = 'kill', delay = 0.1,entity_id = 2105, dur = 0 }, 	
		},
		--进入阶段8
		{
	 		{ event = 'createActor', jqid= 9 },
	 	},
   
    },

     --第二章第二节剧情2.1
    ['juqing2231'] =
    {
    	{
    		{ event = 'effect', delay = 0.5, entity_id = 2114, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
    	},
	},

    --剧情副本第二章第二节剧情4
    ['juqing224'] = 
	{
		--动画组
	    -- {   
	    --    { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   -- { event = 'hideUI' , delay = 0 },		-- 动画片段
		   -- { event = 'disableSceneClicks' },		-- 动画片段
	    -- },
	    --停止或者打开怪物的动作  0 开始  1 停止
        -- { 
        --    {event  = 'stopMonster',delay =0.1,ttype = 1},
        -- },
		--玩家从门口进入囚室3的某个坐标。
		-- {
  -- 		    { event = 'move', delay = 0.5, cast='player', dir = 6,pos = {39, 19},speed = 340, dur = 1 },
		-- },
		--杀掉牢门3
        {
        	{event = 'kill', delay = 0.1, entity_id=2114, dur = 0},
        }, 

        {
        	{ event = 'talk', delay = 0.1, cast='player', isEntity = false,talk = '囚室是空的……难道在刑室？', dur = 2 }, 
        },
		-- {
  -- 		    { event = 'move', delay = 0.5, cast='player', dir = 6,pos = {35, 14},speed = 340, dur = 1 },
		-- },
	 --    {
		--    { event = 'dialog', dialog_id = 48},  
		-- },

    },

        --剧情副本第二章第二节剧情5
    ['juqing225'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    {
		   --{ event = 'dialog', dialog_id = 49}, 
		   { event = 'talk', delay = 0.5, cast='player', isEntity = false,talk = '苏茉，我来救你了。', dur = 1.5 }, 
		   { event = 'talk', delay = 2, entity_id=2101, isEntity = false,talk = '我们快离开这里去找芙儿。', dur = 1.5 },
		},
		--苏茉跟随【玩家】
	    {
	      -- { event = 'move', delay = 1, cast = 'player', dir = 6, pos = {63, 30},speed = 340, dur = 2 },
          { event = 'move', delay = 0.1, entity_id=2101, dir = 6, pos = {55, 38},speed = 340, dur = 2 },
        },

    	{
    		{ event = 'effect', delay = 0.5, entity_id = 2115, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
    	},
	},

	--苏茉自己走
	['juqing2251'] =
	{
		--杀掉把手1显示把手2
        {
        	{event = 'kill', delay = 0.1, entity_id=2115, dur = 0},
        	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2117, cansee1 = true,entity_id2 = 2115, cansee2 = false,dur = 0 }, 
        }, 
        {
          { event = 'move', delay = 0.2, entity_id=2101, dir = 6, pos = {49, 40},speed = 340, dur = 2 },
        },
	},

    ['juqing226'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

        --停止或者打开怪物的动作  0 开始  1 停止
        { 
           { event  = 'stopMonster',delay =1,ttype = 1},
        },

        --前置对白
        {
          { event = 'dialog', dialog_id = 50 },
        },

        { 
           { event  = 'stopMonster',delay =1,ttype = 0},
        },
        --百里寒打玩家
        {
           { event = 'createActor', jqid=16 },  
        },
        --上官锦和赤羽协助玩家作战
        -- {{event = 'attack',delay = 0.1,jqid=14},},
    },
        --剧情副本第二章第二节剧情7
    ['juqing227'] = 
	{
        --动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
        --芙儿出现在场景中
        -- {
        --   { event = 'createActor', jqid=1 }, 
        -- },
 --停止或者打开怪物的动作  0 开始  1 停止
  		{ 
      		{event  = 'stopMonster',delay =0.1,ttype = 1},
  		},

        {
        	{ event = 'move', delay = 0.5, entity_id = 2106, dir = 6,pos = {41, 45},speed = 340, end_dir = 3 },		--百里寒
        	{ event = 'move', delay = 0.5, cast='player', dir = 6,pos = {42, 43},speed = 340, end_dir = 3 },		
        	{ event = 'camera', delay = 0.1, dur=1,sdur = 2,style = '',backtime=1, c_topox = {1574,1413} },
        	{ event = 'move', delay = 0.5, entity_id = 2101, dir = 6,pos = {49, 40},speed = 340, end_dir = 3 },		--苏茉
        	{ event = 'move', delay = 0.5, entity_id = 2104, dir = 6,pos = {46, 39},speed = 340, end_dir = 3 },		--上官锦
        	{ event = 'move', delay = 0.5, entity_id = 2105, dir = 6,pos = {45, 40},speed = 340, end_dir = 3 },		--赤羽
    	},

        --前置对白
        {
          { event = 'dialog', dialog_id = 51 },
        },
		--再冒个泡
		{
		    -- { event = 'talk', delay = 0.1, entity_id=2102, isEntity = false,talk = '等等………', dur = 2 },
        --芙儿走到赤羽身边对着赤羽
  		    { event = 'move', delay = 0.5, entity_id = 2102, dir = 6,pos = {48, 43},speed = 340, dur = 2 },
	    	{ event = 'camera', delay = 0.5, dur=1,sdur = 2,style = '',backtime=1, c_topox = {1522,1341}},
		    { event = 'talk', delay = 1.5, entity_id=2102, isEntity = false,talk = '这位公子，你叫什么？', dur = 1.5 },
		    { event = 'talk', delay = 3.5, entity_id=2105, isEntity = false,talk = '赤羽。', dur = 1.5},
        },
      --   --所有NPC消失
      --   {
	    	-- { event = 'kill', delay = 0.1,entity_id = 2105, dur = 0 },  
	    	-- { event = 'kill', delay = 0.1,entity_id = 2102, dur = 0 },  
	    	-- { event = 'kill', delay = 0.1,entity_id = 2101, dur = 0 },  
	    	-- { event = 'kill', delay = 0.1,entity_id = 2104, dur = 0 },
	    	-- { event = 'kill', delay = 0.1,entity_id = 2106, dur = 0 },            
      --   },
        --请求通关副本
        {
          { event = 'carnet', delay = 1,dur = 0 },  
        },
    },
    --============================================xiehande  剧情副本第二章第二节  end  =====================================----


    --============================================xiehande  剧情副本第二章第三节  start =====================================----
    --剧情副本第二章第三节剧情1
    ['juqing231'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
		   { event = 'dialog', dialog_id = 53},  
		},
    },
    ['juqing2311'] = 
    {
	    --冒泡对白
	    {
		  { event = 'move', delay = 0.1, entity_id=2129,  dir = 6,pos = {62,15},speed = 500, dur = 4 },	    
	      { event = 'talk', delay = 0.1, entity_id=2129, isEntity = false,talk = '{颤抖}太厉害了！小弟们快帮我挡住他。！', dur = 1 },
		  { event = 'kill', delay = 0.6, entity_id=2129, dur = 0 }, 
	    },    	

    },

 ['juqing2312'] = 
    {
	    --冒泡对白
	    {
		  { event = 'move', delay = 0.1, entity_id=2130,  dir = 6,pos = {44,40},speed = 500, dur = 4 },	    
	      { event = 'talk', delay = 0.1, entity_id=2130, isEntity = false,talk = '{颤抖}太厉害了！小弟们快帮我挡住他。！', dur = 1 },
		  { event = 'kill', delay = 0.6, entity_id=2130, dur = 0 }, 
	    },    	

    },

	--剧情副本第二章第三节剧情2
    ['juqing232'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },

	    {	
		 { event = 'move', delay = 0.1, cast='player', dir = 6,pos = {43,28},speed = 340, dur = 2, end_dir = 7, },
		},

	     --镜头的移动配置	    
	    {  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	       { event = 'camera', delay = 0, dur=2,sdur = 0.9,style = '',backtime=1, c_topox = {580,550} },
	    },
	    --百里寒和芙儿朝着王座方向走去，走到某个坐标停下
        {
          { event = 'move', delay = 0.1, entity_id = 2121, dir = 6,pos = {16,20},speed = 340, dur = 4 },
          { event = 'move', delay = 0.1, entity_id = 2122, dir = 6,pos = {20,18},speed = 340, dur = 4 },
	    },
	    --百里寒，芙儿，满朝文武官员（6个）和东夷王为进入副本即存在的NPC
	    --冒泡对白
	    --文武百官现在服务器没有创建 可以让客户端来配置假的，因为不需要真实伤害
		--例子 { event = 'talk', delay = 6, cast = 'cast200', talk = '战士之神，猿魔愿与你并肩作战。', emote = { a = 44, b = 2 }, dur = 2.5 },

	   --  {
	   --    { event = 'talk', delay = 0, entity_id=126, isEntity = false,talk = '恭迎玄女！', dur = 1 },
		  -- { event = 'talk', delay = 0, entity_id=130, isEntity = false,talk = '恭迎玄女！', dur = 1 }, 
	   --  },
	    --冒泡对白 
	    {
	      { event = 'talk', delay = 0, entity_id=2124, isEntity = false,talk = '恭迎玄女！', dur = 2 },
	      { event = 'talk', delay = 0, entity_id=2125, isEntity = false,talk = '恭迎玄女！', dur = 2 },

	    },
	    {
	    	{ event = 'talk', delay = 0, entity_id=2121, isEntity = false,talk = '陛下……我并不想成为东夷的玄女。', dur =2},
	   	},
	    {
	    	{ event = 'talk', delay = 0, entity_id=2123, isEntity = false,talk = '大胆！来人，把这个丫头押下去！', dur = 2 },
	   	},
	   	
	    --前置对白
	    --{
		 --  { event = 'dialog', dialog_id = 54},  
		--},
		--{
	     -- { event = 'talk', delay = 0, entity_id=2124, isEntity = false,talk = '天天喝酒吃肉，天天喝酒吃肉！', dur = 1 },
	     -- { event = 'talk', delay = 0, entity_id=2125, isEntity = false,talk = '天天喝酒吃肉，天天喝酒吃肉！', dur = 1 },

	   -- },
 		--{
		  --{ event = 'dialog', dialog_id = 55},  
		--},
		{--百里寒替芙儿出头
          	{ event = 'move', delay = 0.1, entity_id = 2122, dir = 6,pos = {17,18},speed = 340, dur = 2 },  
	    	{ event = 'talk', delay = 0, entity_id=2122, isEntity = false,talk = '谁敢碰她，先过我这关。', dur = 1.5 },               
	    },
	    {
	    	{ event = 'talk', delay = 0, entity_id=2123, isEntity = false,talk = '好你个百里寒！来人，把他也抓起来！', dur = 2 },
	   	},



 		--{
		  -- { event = 'dialog', dialog_id = 110},  
		--},
	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0, dur=2,cast = 'player'},
	    },
		{
	    	{ event = 'kill', delay = 0.1,entity_id = 2121, dur = 0 }, 
	    	{ event = 'kill', delay = 0.1,entity_id = 2122, dur = 0 },    
		   { event = 'dialog', dialog_id = 111},  
		},
		{
           { event = 'createActor', jqid=14 },  
        },
		 --玩家冲出来到某个坐标
        {
          { event = 'move', delay = 0.1, cast='player', dir = 6,pos = {21,20},speed =340, dur = 2.5 },
 
	    },
		{  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	       { event = 'camera', delay = 2.8, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = {467,502} },
	    },
	   	{
	   	  { event = 'move', delay = 0.1, entity_id = 2123, dir = 6,pos = {11,12},speed = 500, dur = 1,end_dir= 3 }, 
	      { event = 'talk', delay = 0.1, entity_id=2123, isEntity = false,talk = '来人，护驾！', dur = 1 }, 
	    },
	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0, dur=0.2,cast = 'player'},
	    },
        {--刷出一波小怪
	      { event = 'createActor', jqid=15 },  
	    },

	    --前置对白

        
    },
    --剧情副本第二章第三节剧情3
    --更多的侍卫（3个怪）涌上来围住众人。
    ['juqing233'] = 
    { 
        {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    {
		   { event = 'dialog', dialog_id = 112},  
		},


		{
          { event = 'move', delay = 0.1, cast='player', dir = 6,pos = {45,29},speed = 340, dur = 4 },  

	    },
	    {--再刷出百里寒
	      { event = 'createActor', jqid=18 },  
	    },

		{  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       { event = 'camera', delay = 0, dur=2,sdur = 0.9,style = '',backtime=1, c_topox = {580,550} },
	    },


	    {
		   { event = 'dialog', dialog_id = 113},  
		},
	    {
	       { event = 'playAction', entity_id=2122, delay = 2, action_id = 6, dur = 2, dir = 2 },
	    },	
	    {
	      { event = 'talk', delay = 0, entity_id=2133, isEntity = false,talk = '啊···呃···', dur = 1 }, 
	      { event = 'playAction', entity_id=2133, delay = 1, action_id = 4, dur = 2, dir = 2 },
	      { event = 'kill', delay = 0.1,delay = 3, entity_id = 2133, dur = 0 },
	    },	
	    {
		   { event = 'dialog', dialog_id = 114},  
		},
		{
	      { event = 'talk', delay = 1, entity_id=2124, isEntity = false,talk = '惊恐', dur = 1 },
	      { event = 'talk', delay = 1, entity_id=2123, isEntity = false,talk = '惊恐', dur = 1 },
	      { event = 'talk', delay = 1, entity_id=2125, isEntity = false,talk = '惊恐', dur = 1 },
	    },
	    {
		   { event = 'dialog', dialog_id = 115},  
		},
		{
          { event = 'move', delay = 0.1, entity_id=2122, dir = 3,pos = {35,30},speed = 340, dur = 4 }, 
          { event = 'talk', delay = 1.1, entity_id=2122, isEntity = false,talk = '哈哈，哈哈哈···', dur = 2 }, 
          { event = 'kill', delay = 3.1,delay = 3, entity_id = 2122, dur = 0 },  
	    },
	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0, dur=0,cast = 'player'},
	    },
	    --请求通关副本
        {
          { event = 'carnet', delay = 0.1,dur = 0 },  
        },

    },


    --============================================xiehande  剧情副本第二章第三节  end  =====================================----

            --============================================xiehande  剧情副本第二章第四节，wuwenbin 2015/12/28调试修改  start =====================================----
            --剧情副本第二章第四节剧情1
    ['juqing241'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    -- {
	    --   { event = 'createActor', jqid=2 },  --刷出柳若霜和玉羊
	    -- },
	    --停止或者打开怪物的动作 1停止战斗 0开始战斗
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 1},
        },
	    {
 			{ event = 'move', delay = 0.1, entity_id=2141, dir = 6,pos = {33,14,},speed = 250, dur = 2, end_dir = 3},
  		  	{ event = 'move', delay = 0.1, entity_id=2142, dir = 6,pos = {35,13,},speed = 250, dur = 2, end_dir = 3},

  		    { event = 'move', delay = 0.1, cast='player', dir = 6,pos = {45,46},speed = 340, dur = 2, end_dir = 7, },
  		    { event = 'move', delay = 0.1, entity_id = 2144, dir = 6,pos = {40,43},speed = 340, dur = 2, end_dir = 3, },
  		    { event = 'move', delay = 0.1, entity_id = 2143, dir = 6,pos = {42,42},speed = 340, dur = 2, end_dir = 3, },
		    { event = 'dialog', delay = 1, dialog_id = 56},  
		},
		--玉羊，柳若霜移动后消失
		{
  		    { event = 'move', delay = 0.1, entity_id = 2143, dir = 6,pos = {33,33},speed = 340, dur = 2, end_dir = 5, },
            { event = 'move', delay = 0.1, entity_id = 2144, dir = 6,pos = {31,34},speed = 340, dur = 2, end_dir = 3, },
	    	{ event = 'kill', delay = 0.1,entity_id = 2143, dur = 0 },  
	    	{ event = 'kill', delay = 0.1,entity_id = 2144, dur = 0 },             
        },
        --停止或者打开怪物的动作 1停止战斗 0开始战斗
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },
        --生成牢门1特效
        {
	    	{ event = 'changeVisible', delay = 0,entity_id1 = 2117, cansee1 = false, dur = 0 }, --隐藏把手
	    	{ event = 'effect', delay = 0, entity_id = 2112, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
        },

        {--刷出一波小怪
	        { event = 'createActor', jqid = 2 },  
	    },

    },

	--剧情副本第二章第四节剧情2
    ['juqing242'] = 
	{

        --清除牢门1特效，生成牢门2特效
	    {
	    	{ event = 'changeVisible', delay = 0,entity_id1 = 2112, cansee1 = false,dur = 0 }, 
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2112},
	    	{ event = 'effect', delay = 0.5, entity_id = 2113, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
		    { event = 'talk', delay = 0.2, cast='player', isEntity = false,talk = '不在此处。', dur = 1 },
        },

    },

    --剧情副本第二章第四节剧情3
    ['juqing243'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	   	{ 
           {event  = 'stopMonster',delay =0,ttype = 1},
        },
        --清除牢门2特效
	    {
	    	{ event = 'removeEffect', delay = 0, effect_id = 8, entity_id = 2113},
	    	{ event = 'talk', delay = 0.2, cast='player', isEntity = false,talk = '不在此处。', dur = 1 },
	    	{ event = 'changeVisible', delay = 0,entity_id1 = 2113, cansee1 = false,dur = 0 }, 
	    },
        {
  		   { event = 'move', delay = 0, cast='player', dir = 6,pos = {32, 25},speed = 340, dur = 0, end_dir = 1,},
		},

		--玩家看到狱卒后说话
        {
            { event = 'talk', delay = 0, entity_id = 2148, isEntity = false,talk = '大胆！想劫狱嘛！', dur = 1 },
		    { event = 'talk', delay = 1, cast ='player', isEntity = false,talk = '不好!被发现了。', dur = 1.5 },
        },

        { 
            {event  = 'stopMonster',delay =0.1,ttype = 0},
        },

    },

    ['juqing244'] =
    {
    --为控制狱卒死后才生成特效，加入阶段，生成牢门3特效
        {
	    	{ event = 'effect', delay = 0.5, entity_id = 2114, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
        },
    },

    --剧情副本第二章第四节剧情4
    ['juqing245'] = 
    {
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
        --清除牢门3特效
        {
        	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2114, cansee1 = false,dur = 0 }, 
	    	{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2114},
        },

		--停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0,ttype = 1},
        },
		{
		    { event = 'talk', delay = 0, cast='player', isEntity = false,talk = '芙儿，我来救你了！', dur = 1 },
        },
        --玩家，芙儿和百里寒在门口聚集
        {
  		  { event = 'move', delay = 0.1, cast='player', dir = 6,pos = {47, 22},speed = 250, dur = 2, end_dir = 7},
  		  { event = 'move', delay = 0.1, entity_id=2141, dir = 6,pos = {45, 18},speed = 250, dur = 2, end_dir = 5},
  		  { event = 'move', delay = 0.1, entity_id=2142, dir = 6,pos = {49, 20},speed = 250, dur = 2, end_dir = 5},
		},
		--玉羊、柳若霜奔跑过来
		{
  		  { event = 'move', delay = 0.1, entity_id=2143, dir = 6,pos = {36, 21},speed = 250, dur = 4 },
  		  { event = 'move', delay = 0.1, entity_id=2144, dir = 6,pos = {39, 23},speed = 250, dur = 4 },
  		  { event = 'move', delay = 0.1, cast='player', dir = 6,pos = {47, 22},speed = 340, dur = 2},
		  { event = 'dialog', delay = 1.8, dialog_id = 57},  
		},
        {
		    { event = 'talk', delay = 0, cast='player', isEntity = false,talk = '{吃惊}表情', dur = 1 },
		    { event = 'talk', delay = 0, entity_id=2141, isEntity = false,talk = '{吃惊}表情', dur = 1 },
		    { event = 'talk', delay = 1.5, entity_id=2141, isEntity = false,talk = '{害怕}表情', dur = 1 },
        },
        {
		   { event = 'dialog', dialog_id = 58},  
		},
		--芙儿、百里寒、玉羊、柳若霜移动出屏幕后消失
		{
  		  	{ event = 'move', delay = 0.1, entity_id=2141, dir = 6,pos = {28, 25},speed = 250, dur = 4 },
  		 	{ event = 'move', delay = 0.1, entity_id=2142, dir = 6,pos = {27, 26},speed = 250, dur = 4 },
  		  	{ event = 'move', delay = 0.1, entity_id=2143, dir = 6,pos = {28, 30},speed = 250, dur = 4 },
  		  	{ event = 'move', delay = 0.1, entity_id=2144, dir = 6,pos = {25, 28},speed = 250, dur = 4 },
	    	{ event = 'kill', delay = 1.5,entity_id = 2141, dur = 0 },  
	    	{ event = 'kill', delay = 1.5,entity_id = 2142, dur = 0 }, 
	    	{ event = 'kill', delay = 1.5,entity_id = 2143, dur = 0 },  
	    	{ event = 'kill', delay = 1.5,entity_id = 2144, dur = 0 },               
        },

        --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },   
    },

    ['juqing246'] =
    {
    --为控制狱卒死后才生成特效，加入阶段，生成把手特效
        {
	    	{ event = 'effect', delay = 0.5, entity_id = 2115, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
        },
    },

    ['juqing247'] =
    {
        {
	    	{ event = 'changeVisible', delay = 0,entity_id1 = 2117, cansee1 = true, dur = 0 }, 
	    	{ event = 'changeVisible', delay = 0,entity_id1 = 2116, cansee1 = false, dur = 0 },
	    	{ event = 'changeVisible', delay = 0,entity_id1 = 2115, cansee1 = false, dur = 0 },
        },
    },

    ['juqing248'] =
    {
	    {
	        { event = 'talk', delay = 1,  entity_id = 2150, isEntity = false,talk = '你休想逃！', dur = 2 },
	        { event = 'changeVisible', delay = 0,entity_id1 = 2116, cansee1 = true, dur = 0 },
  		},
    },
		--在场NPC均消失后进行副本结算
    ['juqing249'] = 
    {
        --请求通关副本
        {
           { event = 'carnet', delay = 1,dur = 0 },  
        },
    
    },
    --============================================hanlili  剧情副本第二章第四节  end  =====================================----

    --============================================hanlili   剧情副本第三章第一节  start =====================================----
            --剧情副本第三章第一节剧情1
    ['juqing311'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
		-- {
		--     { event = 'talk', delay = 0, entity_id = 126, isEntity = false,talk = '上官哥哥。', dur = 1 },
		--     { event = 'talk', delay = 0, entity_id = 130, isEntity = false,talk = '{脸红}表情', dur = 1 },
		--     { event = 'talk', delay = 0, entity_id = 135, isEntity = false,talk = '{高兴}表情', dur = 1 },
  --       },
  --       {
		--    { event = 'dialog', dialog_id = 59},  
		-- },
		--九黎公主跑向上官锦
        {
        	{ event = 'move', delay = 0.1, entity_id = 2166, dir = 6,pos = {51,56},speed = 340, dur = 1,end_dir=1},
  			{ event = 'move', delay = 2.7, entity_id = 2166, dir = 6,pos = {65,54},speed = 340, dur = 1 ,end_dir=1},
  			{ event = 'talk', delay = 1.5, entity_id = 2166, isEntity = false,talk = '上官哥哥，你终于回来了！', dur = 1.5 },
			{ event = 'move', delay = 2, entity_id = 2165, dir = 6,pos = {64,53},speed = 340, dur = 0.5,end_dir = 5}, 
			{ event = 'talk', delay = 2.5, entity_id = 2165, isEntity = false,talk = '糟了……', dur = 1 }, 		  
		},
		-- --前置【九黎公主】上官哥哥，你终于回来了。
		-- {
		--    { event = 'dialog', dialog_id = 60},  
		-- },
		--上官锦逃跑
		{
  		  	{ event = 'move', delay = 1, entity_id = 2165, dir = 6,pos = {82,44},speed = 340, dur = 1 },
  		  	{ event = 'move', delay = 0.1, entity_id = 2165, dir = 6,pos = {64,53},speed = 340, dur = 1,end_dir = 1}, 
  		  	{ event = 'talk', delay = 0.5, entity_id = 2165, isEntity = false,talk = '我先回避一下，皇宫大殿见。', dur = 2 },
	    	{ event = 'kill', delay = 1.8,entity_id = 2165, dur = 0 },            
        },
        {
  		  	{ event = 'talk', delay = 0.1, entity_id = 2166, isEntity = false,talk = '上官哥哥！你别跑啊！', dur = 1 },
  		  	{ event = 'move', delay = 1, entity_id = 2166, dir = 6,pos = {82, 44},speed = 340, dur = 4 },
  		  	{ event = 'talk', delay = 2, entity_id = 2166, isEntity = false,talk = '咱们赶紧去见我爹去吧。', dur = 1 },
	    	{ event = 'kill', delay = 2.5,entity_id = 2166, dur = 0 },            
        },

        -- --强制回到主角身上
        -- {	
        -- 	{ event = 'camera', delay = 0.1, dur=1,sdur = 0.1,cast = 'player',style = ''},
        -- }, 
        --前置 【玩家】别怕，我为你开路，陪你进殿。
        {
		   { event = 'dialog', dialog_id = 61},  
		},
		--请求进入阶段2
		{
			{ event = 'createActor', delay = 0.1, jqid= 2},
		--杀掉苏茉
			{ event = 'kill', delay = 0.1,entity_id = 2164, dur = 0 },
		},
    },

    --剧情2
    ['juqing312'] =
    {
    	{
    		{ event = 'talk', delay = 1, entity_id = 2171, isEntity = false,talk = '想跟我抢上官哥哥，没门！', dur = 3 },
    	},
    },

    --剧情副本第三章第一节剧情3
    ['juqing313'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
	    --摄像机移动到皇上身上
	    {
	    	{ event = 'camera', delay = 0.5, dur=2,sdur = 1,style = '',backtime=1, c_topox = {387, 406} },
	    	{ event = 'talk', delay = 0.1, entity_id = 2161, isEntity = false,talk = '恭迎玄女！', dur = 2 },
	    	{ event = 'talk', delay = 0.1, entity_id = 2162, isEntity = false,talk = '恭迎玄女！', dur = 2 },
	    },
	    --玩家移动
		{
  		  -- { event = 'move', delay = 0.1, entity_id = 126, dir = 6,pos = {40, 34},speed = 340, dur = 4 },
  		  -- { event = 'move', delay = 0.1, entity_id = 130, dir = 6,pos = {40, 34},speed = 340, dur = 4 },
  		  { event = 'move', delay = 0.5, cast = 'player', dir = 6,pos = {20, 18},speed = 340, dur = 4 },
		},
		--前置 【九黎王】这位就是朱雀玄女？
        {
		   { event = 'dialog', dialog_id = 62},  
		},
	    {
	       { event = 'showUI' , delay = 0 },		-- 动画片段
	    },	 

		--请求副本通关
        {
          { event = 'carnet', delay = 1,dur = 0 },  
        },
    },

  --============================================hanlili  剧情副本第三章第一节  end  =====================================----

        --============================================hanlili   剧情副本第三章第二节  start =====================================----
            --剧情副本第三章第二节剧情1
    ['juqing321'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
		--特效一闪，刷出大祭司
        --{
   			--{ event = 'effect',  effect_id = 20016, layer = 2, pos = { 41,34 },dur = 0.5 },
        --},


        {
	      { event = 'createActor', delay = 3, jqid=2 },  
	    },
	    {
	     	{ event = 'move', delay = 0.5, entity_id = 2181, dir = 6,pos = {48,30},speed = 340, dur = 0.1 ,end_dir = 2},
 			{ event = 'move', delay = 0.5, entity_id = 2182, dir = 6,pos = {45,31},speed = 340, dur = 0.1 ,end_dir = 2},
	    },

		{
		    { event = 'talk', delay = 0.5, entity_id = 2183, isEntity = false,talk = '#￥%￥……%&……%&', dur = 1 },
        },
        {
		   { event = 'dialog', delay = 0.1, dialog_id = 64},  
		},


        --特效一闪，大祭司消失
        {
           { event = 'effect', delay = 0.2, effect_id = 20016, layer = 2, entity_id = 2183,dur = 1},
           { event = 'kill', delay = 0.4,entity_id = 2183, dur = 0 },       
        },

        {
		    { event = 'dialog',delay = 0.5, dialog_id = 65},  
		},
		{
 			{ event = 'move', delay = 0.1, entity_id = 2181, dir = 6,pos = {61,23},speed = 340, dur = 2 },
 			{ event = 'move', delay = 0.1, entity_id = 2182, dir = 6,pos = {61,23},speed = 340, dur = 2 },
 			{ event = 'kill', delay = 1, entity_id = 2181, dur = 0 },
 			{ event = 'kill', delay = 1, entity_id = 2182, dur = 0 },
		},
		{
	      { event = 'createActor',delay = 0.1, jqid= 3 },  
	    },

    },

           --剧情副本第三章第er节剧情2
    ['juqing322'] = 
	{
		--动画组
	    {   
	       { event = 'hideAvatars' , delay = 0 },	-- 动画片段
		   { event = 'hideUI' , delay = 0 },		-- 动画片段
		   { event = 'disableSceneClicks' },		-- 动画片段
	    },
		{
 			{ event = 'move', delay = 0.1, cast='player', dir = 6,pos = {18,16},speed = 340, dur = 2, end_dir = 7},
		},
	    --大祭司做一个技能动作
	    {
	      { event = 'playAction', entity_id=2183, delay = 2, action_id = 2, dur = 0.5, dir = 3 },
	    },
		{  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	       { event = 'camera', delay = 0.1, dur=0.5,sdur = 0.9,style = '',backtime=1, c_topox = {306,788} },
           { event = 'effect', delay = 0.6, effect_id = 11049, layer = 2, pos = { 9,24 },dx= 7,dy = 31,is_forever = true },
	    },



	    {  --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上
	       { event = 'camera', delay = 0.2, dur=0.2,sdur = 0.9,style = '',backtime=1, c_topox = {1212,278} },
           { event = 'effect', delay = 0.6, effect_id = 11049, layer = 2, pos = { 37,9 },dx= 30,dy = 0, is_forever = true },
	    },

		{--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0.2, dur=0.5,cast = 'player'},
	    },

	    {
		   { event = 'dialog', delay = 1.1, dialog_id = 66},  

		},
				--请求通关副本
        {
          { event = 'carnet', delay = 0.1,dur = 0 },  
        },




    },

  --============================================hanlili  剧情副本第三章第二节  end  =====================================----

  --============================================wuwenbin   剧情副本第三章第三节  start =====================================----
    --剧情副本第三章第三节剧情1
    ['juqing331'] = 
    {
    --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
    --镜头移动到苏茉祭祀区域
        {
           { event = 'camera', entity_id = 2201,  delay = 0, dur = 1, style = 'lookat' , sdur = 1.5, backtime = 1,},
        },
    --玩家走入
        {
           { event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {45,58},speed = 340, dur = 1.5, end_dir = 7},
        },
    --前置对白
        {
           { event = 'dialog', dialog_id = 68},     
        },
  --播放特效震屏
	    {
	       { event = 'shake', delay = 1, dur = 1,c_topox = {1530,1850,},index = 60, rate = 4, radius = 40 },  
           { event = 'talk', delay = 2, entity_id=2202, isEntity = false,talk = '{惊恐}表情', dur = 1 },
           { event = 'talk', delay = 2, entity_id=2203, isEntity = false,talk = '{惊恐}表情', dur = 1 },
           { event = 'talk', delay = 2, cast = 'player', isEntity = false,talk = '{惊恐}表情', dur = 1 },
        } ,
  --前置对白
        {
           { event = 'dialog', dialog_id = 69  }, 
        },

  --赤羽向目标地移动后消失,宏泰消失
        {
          
          { event = 'move', delay = 0.1,entity_id = 2202, dir = 6, pos = {52,53},speed = 240, dur = 2,},
          { event = 'kill', delay = 0.5,entity_id = 2202, dur = 1 },
          { event = 'kill', delay = 0.5,entity_id = 2203, dur = 0 },
          { event = 'createActor', delay = 1.5, jqid= 2}, 
    	},
    }, 
  
      --剧情副本第三章第三节剧情2
    ['juqing332'] = 
    {
    --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
    --刷出赤羽后转向
        {
           { event = 'move', delay = 0.1, entity_id = 2202, dir = 6,pos = {35, 37},speed = 340, dur = 1, end_dir = 5},
        },
    --镜头移动到剧情区域
        {
           { event = 'camera', entity_id = 2201,  delay = 0.5, dur=1, style = 'lookat' },
        },
    --冒泡对白
        {
          { event = 'talk', delay = 0.5, entity_id=2204, isEntity = false,talk = '上官锦恳请玄女，再聚内力，再行盛典！', dur = 1 },
        },
    --大祭司释放技能动作
        {
           --{ event = 'playAction', entity_id=2205, delay = 2, action_id = 2, dur = 2, dir = 2 },
        },
    --玩家，赤羽进入该区域
        {
           { event = 'move', delay = 0.1, cast = 'player', dir = 6,pos = {24, 44},speed = 340, dur = 4, end_dir = 7},
           { event = 'move', delay = 0.1, entity_id = 2202, dir = 6,pos = {26, 42},speed = 340, dur = 4, end_dir = 7},
        },
    --播放特效 朱雀铜像面前燃起一片火焰
        {
           --{ event = 'effect', delay = 0.1, effect_id = '11049',tag = 1,  times = -1 , pos = { 14, 34 } ,},
        },
    --[[苏茉走向圣像
        {
           { event = 'move', delay = 0.1, entity_id = 2201, dir = 6,pos = {10, 34},speed = 340, dur = 4 ,end_dir = 7},
        },
    --苏茉对圣像释放技能，特效射向圣象
        {
          { event = 'playAction', entity_id=145, delay = 2, action_id = 40, dur = 2, dir = 2 },
        },]]

    --苏茉对圣象释放技能  一束火焰喷向圣象
        {
           { event = 'playAction', entity_id=2201, delay = 0, action_id = 2, dur = 1, dir = 7 },
        },
    --播放特效 屏幕震动
	    {
	       { event = 'shake', delay = 0.5, dur = 1,c_topox = {446,1210,},index = 60, rate = 4, radius = 40 },  
	    },
    --苏茉后退几步 
        {
           { event = 'move', delay = 0, entity_id = 2201, dir = 6,pos = {21, 40},speed = 340, dur = 1, end_dir = 7},
        },
    --冒泡对白
        {
           { event = 'talk', delay = 0.5, entity_id=2201, isEntity = false,talk = '{惊讶}表情。', dur = 1 },
           { event = 'talk', delay = 0.5, entity_id=2202, isEntity = false,talk = '{惊讶}表情。', dur = 1 },
           { event = 'talk', delay = 0.5, entity_id=2203, isEntity = false,talk = '{惊讶}表情。', dur = 1 },
           { event = 'talk', delay = 0.5, entity_id=2204, isEntity = false,talk = '{惊讶}表情', dur = 1 },
           { event = 'talk', delay = 0.5, entity_id=2205, isEntity = false,talk = '{惊讶}表情', dur = 1 },
           { event = 'talk', delay = 0.5, cast = 'player', isEntity = false,talk = '{惊讶}表情', dur = 1 },
        },

    --前置对白
        {
           { event = 'dialog', dialog_id = 70  }, 
        },

    --镜头恢复正常
        --{
           --{ event = 'camera', entity_id = 150,  delay = 1, dur=1, style = 'lookat' },
       -- },  
    --某个坐标刷出boss鸣蛇
        {
           { event = 'createActor', jqid= 10 }, 
        },
    },

    ['juqing333'] = 
    {
    --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
    --鸣蛇转向面对众人
        {
           { event = 'move', delay = 0.1, entity_id = 2211, dir = 6,pos = {14,48,},speed = 340, dur = 1, end_dir = 1},        
        },
 
    --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 1},
        },   

    --众人看鸣蛇
        {
           { event = 'move', delay = 0.5, entity_id = 2201, dir = 6,pos = {22, 39},speed = 340, dur = 1, end_dir = 5},
           { event = 'move', delay = 0.5, entity_id = 2202, dir = 6,pos = {26, 42},speed = 340, dur = 1, end_dir = 5},
           { event = 'move', delay = 0.5, entity_id = 2204, dir = 6,pos = {24, 39},speed = 340, dur = 1, end_dir = 5},
           { event = 'move', delay = 0.5, entity_id = 2205, dir = 6,pos = {20, 42},speed = 340, dur = 1, end_dir = 5},
           { event = 'move', delay = 0.5, cast = 'player', dir = 6,pos = {24, 44},speed = 340, dur = 1, end_dir = 5},           
        },
    --前置对白
        {
           { event = 'dialog', dialog_id = 71  }, 
        },
      --众NPC消失
        {
          { event = 'kill', delay = 0,entity_id = 2201, dur = 0 },
          { event = 'kill', delay = 0,entity_id = 2202, dur = 0 },
          { event = 'kill', delay = 0,entity_id = 2204, dur = 0 },
          { event = 'kill', delay = 0,entity_id = 2205, dur = 0 },
        }, 
        --鸣蛇攻击玩家
        {
           { event = 'createActor' , delay = 1, jqid= 11 }, 
        },

        --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },       
    },
    

    --剧情副本第三章第三节剧情2
    ['juqing334'] =
    {
        {
           { event = 'carnet', delay = 1,dur = 0 },  
        },
    },


  --============================================wuwenbin  剧情副本第三章第三节  end  =====================================----


     	--[[local SuMo = 2221	--苏茉ID
    	local DelayTime1 = 0.2 		--进入副本摄像机首次移动延迟时间
    	local DurTime1 = 1.5		--摄像机移动到苏茉路径用时
    	local DelayTime2 = DelayTime1 + DurTime1   --苏茉冒泡1时间
        local SpeakTime = 1     --冒泡持续时间
        local DelayTime3 =	DelayTime2 + SpeakTime		--苏茉冒泡2的时间
        local CamStopTime1 = PlayerInterTime   --摄像机在苏茉身上停留时间
        local PlayerInterTime = DelayTime3 +  SpeakTime  --玩家进入镜头时间
        local CamBackTime = 1       --摄像机回到玩家身上路径时间
        local RunTime = 2      --玩家走到目的地所需时间
        local Dil01 = 71		--前置对白ID （【玩家】你真的要这样不辞而别吗？）
        local Pox1 = 19 	--苏茉坐标X（摄像机移动中心点）
        local Poy1 = 40  --苏茉坐标Y（摄像机移动中心点）
		local Pox2 = 19 	--玩家目标点X
        local Poy2 = 43  --玩家目标点Y]]--
   --============================================liaoshaojia   剧情副本第三章第四节  start =====================================----
    --剧情副本第三章第四节剧情1
    ['juqing341'] = 
    {

    --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
      --镜头移动到苏茉所在区域 --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上; c_topox 移动位置坐标（像素坐标）
        {
           { event = 'camera', delay =0.5, dur=1,sdur = 3,style = '',backtime = 1, c_topox = {620, 1303} },
      --角色冒泡对白
           { event = 'talk', delay = 1, entity_id=2221, isEntity = false,talk = '上官大哥，对不起，我……我……', dur = 1.5 },
           { event = 'talk', delay = 3, entity_id=2221, isEntity = false,talk = '再见{快哭了}表情', dur = 1.5 },
        },
     --    --强制回到主角身上
     -- 	{	
     -- 	   { event = 'camera', delay = 0.1, dur=1,sdur = 0.1,cast = 'player',style = ''},
    	-- }, 
      --玩家走进镜头
        {
          { event = 'move', delay = 0.5, cast = 'player', dir = 6,pos = {19, 43},speed = 340, dur = 3 },
        },
        --前置对白
        {
           { event = 'dialog', dialog_id = 72 },  
        },
        {	--刷A区小怪
           { event = 'createActor', jqid= 2 },	 
        },
        --干掉苏茉
        {
	    	{ event = 'kill', delay = 0,entity_id = 2221, dur = 0 },  
	    },
    },
   
  --   --剧情副本第三章第四节剧情2
    --local Dil02 = 72		--前置对白ID （【玩家】为了避免无谓的战斗……）
    ['juqing342'] = 
    {
  --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
  --前置对白
        {
          { event = 'dialog', dialog_id = 73 },  
        },
  --刷出B区小怪
         {	
           { event = 'createActor', jqid= 4 },	 
        },
    },
   
    --剧情副本第三章第四节剧情3
    --local Dil03 = 73		--前置对白ID （【玩家】穿上侍卫服乔装打扮混出去）
    --local MXid = 49         --玩家变身成的模型ID
    ['juqing343'] = 
    {
  --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
  --场景中某个坐标刷出一个采集物【侍卫服】
       {
        	{ event = 'createActor', jqid= 7 },	
       		{ event = 'effect', delay = 0.5, entity_id = 2226, layer = 2, effect_id = 8,dx= 0,dy = 0,loop = true},	
       },
  --前置对白
        {
           { event = 'dialog', dialog_id = 74},
        },

    },
  --[[移动到侍卫服进行读条采集
        {
            { event = 'move', delay = 0.1,cast = 'player', dir = 6, pos = {30,21},speed = 340, dur = 4 },
        },]]
    ['juqing344'] = 
    {
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },

  		--读条完毕,玩家变身为侍卫
        {
            {event='tranToMonster', body_id = 49}, 
        },
       {
         	{ event = 'createActor', jqid= 9 }, 
       },
	},
	--怪物闲逛
    ['juqing3442'] = 
    {
        -- {   
        --   { event = 'hideAvatars' , delay = 0 },   -- 动画片段
        --   { event = 'hideUI' , delay = 0 },    -- 动画片段
        --   { event = 'disableSceneClicks' },    -- 动画片段
        -- },
        {
           { event = 'talk', delay = 0.1,entity_id=2225, isEntity = false,talk = '这人好面生，新来的侍卫吗？', dur = 20 },
           { event = 'move', delay = 0.1,entity_id=2225, dir = 6,pos = {11, 28},speed = 600, dur = 2 },
           { event = 'move', delay = 5,entity_id=2225, dir = 6,pos = {3, 21},speed = 600, dur = 2 },
           { event = 'move', delay = 10,entity_id=2225, dir = 6,pos = {11, 28},speed = 600, dur = 2 },
           --{ event = 'talk', delay = 5.5,entity_id=2225, isEntity = false,talk = '这人好面生，新来的侍卫吗？', dur = 1.5 },
           { event = 'move', delay = 15,entity_id=2225, dir = 6,pos = {3, 21},speed = 600, dur = 2 },
           { event = 'move', delay = 20,entity_id=2225, dir = 6,pos = {11, 28},speed = 600, dur = 2 },
           { event = 'move', delay = 25,entity_id=2225, dir = 6,pos = {5, 23},speed = 600, dur = 2 },
           -- { event = 'move', delay = 13.5,entity_id=2225, dir = 6,pos = {11, 28},speed = 600, dur = 2 },
           -- { event = 'move', delay = 15.5,entity_id=2225, dir = 6,pos = {3, 21},speed = 600, dur = 2 },
        },
        {
           { event = 'talk', delay = 0.1,entity_id=2227, isEntity = false,talk = '新来的？原来没见过啊', dur = 25 },
           { event = 'move', delay = 0.1,entity_id=2227, dir = 6,pos = {15, 28},speed = 600, dur = 2 },
           { event = 'move', delay = 5,entity_id=2227, dir = 6,pos = {6, 19},speed = 600, dur = 2 },
           { event = 'move', delay = 10,entity_id=2227, dir = 6,pos = {15, 28},speed = 600, dur = 2 },
           --{ event = 'talk', delay = 5.5,entity_id=2224, isEntity = false,talk = '新来的？原来没见过啊', dur = 5 },
           { event = 'move', delay = 15,entity_id=2227, dir = 6,pos = {6, 19},speed = 600, dur = 2 },
           { event = 'move', delay = 20,entity_id=2227, dir = 6,pos = {15, 28},speed = 600, dur = 2 },
           { event = 'move', delay = 25,entity_id=2227, dir = 6,pos = {6, 19},speed = 600, dur = 2 },
        },
	},
  --   --剧情副本第三章第四节剧情4
  --     	local ChiYu = 2222		--赤羽ID
  --   	local DelayTime11 = 0.2 		--摄像机延迟移动时间
  --   	local DurTime11 = 0		--摄像机移动到墙角路径用时
  --   	local DurTime12 = 1     --从墙根向上移动路径时间
  --   	local DelayTime12 = DelayTime1 + DurTime11 + CamStopTime11 - 0.3   --从墙根向上移动的时间
  --       local DelayCY = 0.5     --赤羽走进镜头时间
  --       local DurCY =	2		--赤羽走路时间
  --       local CamStopTime11 = 0.8   --摄像机在墙根停留时间     
  --      	local CamStopTime12 = 0.5 --摄像机在墙头停留时间
  --       local CamBackTime = 1       --摄像机回到玩家身上路径时间
  --       local Dil04 = 74		--前置对白ID （【苏茉】这么高的院墙怎么上去啊！我们出不去了。）
  --       local Dil05 = 75		--前置对白ID （【赤羽】我还以为是贼呢，原来是你们啊。）
  --       local Dil06 = 100		--前置对白ID （【赤羽】这边走，跟我来！）
  --       local Pox1 =44  	--墙根坐标X
  --       local Poy1 =4   --墙根坐标Y
  --       local Pox2 =48  	--墙头坐标X
  --       local Poy2 =3   --墙头坐标Y     
		-- local Posx2 = 35 		--苏茉的位置X坐标
		-- local Posy2 = 8	--苏茉的位置y坐标  
   ['juqing345'] = 
    {   
  --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
  		--前置对白
        { 
          	{ event = 'dialog', dialog_id = 100 },
        },

    	--隐藏赤羽
    	{
        	{ event = 'changeVisible', delay = 0.1,entity_id1 = 2222, cansee1 = false,dur = 0 },  
    	},

  --镜头转向院墙根部，慢慢上移。
        {
          --苏茉移动
          { event = 'move', delay = 0.3, entity_id = 2221, dir = 6,pos = {35, 8},speed = 150, dur = 0.5 },
          { event = 'move', delay = 0.3, cast = 'player', dir = 6,pos = {35-1, 8-1},speed = 150, dur = 0.5 },
        },

        {	--移动第二次
     		{ event = 'camera', delay = 1, dur=1.5,sdur = 1,style = '',backtime=1, c_topox = {1408, 128} },	--像素坐标
          	--还原主角变身
          	{event = 'tranToPlayer', delay =0},
     --    	{ event = 'camera', delay = 3.1, dur=2,sdur = 0.8,style = '', c_topox = {1536, 96} },
    	},

        {	--强制回到主角身上
        	{ event = 'camera', delay = 0.1, dur=1,sdur = 0.1,cast = 'player',style = ''},
        },  

  --苏茉说出不去
  		{
  			{ event = 'dialog', dialog_id = 75 },
  		},
  	--赤羽突然出现镜头,
  		{
        	--{ event = 'move', delay = 0.5, entity_id = 2222, dir = 6,pos = {35+1, 8-2},speed = 340, dur = 2 },
        	{ event = 'changeVisible', delay = 0.5,entity_id1 = 2222, cansee1 = true,dur = 0 },  
        	{ event = 'move', delay = 0.3, cast = 'player', dir = 6,pos = {35-1, 8-1},speed = 340, dur = 0.5 },
  --冒泡对白
           { event = 'talk', delay = 1, entity_id=2221, isEntity = false,talk = '{惊吓}的表情', dur = 1 },
           { event = 'talk', delay = 1, cast = 'player', isEntity = false,talk = '{惊吓}的表情', dur = 1 },
        },
  --前置对白
        {
           { event = 'dialog', dialog_id = 76 },
        },
    --请求通关副本
        {
          { event = 'carnet', delay = 1,dur = 0 },  
        },
    },	
    --=========================================================山海经剧情第四章动画配置===========================================---
     --============================================wuwenbin  剧情副本第四章第一节  start  =====================================----
  ['juqing411'] = 
    {
  --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
    --进入副本后简单移动
        {
           { event = 'move', delay = 1, entity_id = 2241, dir = 1, pos = {173,19,}, speed = 340, dur = 1, end_dir = 5},    
           { event = 'move', delay = 1, entity_id = 2242, dir = 1, pos = {179,23,}, speed = 340, dur = 1, end_dir = 5}, 
           { event = 'move', delay = 1, cast = 'player', dir = 5,pos = {176,21,}, speed = 340, dur = 1, end_dir = 5},
        },

    --角色前置对白，赤羽、玩家调侃苏茉
	    {
	   	   { event = 'dialog', dialog_id = 77 }, 
	   	},
	   	{
	   	   { event = 'talk', delay = 0.5, entity_id = 2241, isEntity = false,talk = '{恼怒}表情', dur = 1 },
	   	   { event = 'talk', delay = 1.5, cast = 'player', isEntity = false,talk = '有埋伏！小心！', dur = 1 }, 
	    },

    --赤羽、苏茉消失
	    {
	       { event = 'kill', delay = 1,entity_id = 2241, dur = 0 },  
	       { event = 'kill', delay = 1,entity_id = 2242, dur = 0 },  
	    },

	--刷出第一波普通怪黑衣人
        {
           { event = 'createActor', jqid= 2}, 
        },

    },

  ['juqing412'] = 
    {
  --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
  --玩家移动到指定位置
        {
           { event = 'move', delay = 0.5, cast = 'player', dir = 5,pos = {150,84,},speed = 340, dur = 0.5, end_dir = 5},    
        },

  --赤羽认出黑衣人首领
        {
           { event = 'dialog', dialog_id = 106 ,delay = 0.5},  
        },
    
  --黑衣人消失，刷出阿芝  
        {
           { event = 'kill', delay = 0,entity_id = 2248, dur = 0 }, 
           { event = 'createActor', delay = 0.5, jqid= 9}, 
        },

  --赤羽与阿芝交谈
        {
           { event = 'dialog', dialog_id = 107 ,delay = 1},  
        },
        
  --赤羽、苏茉消失
	    {

	       { event = 'kill', delay = 0,entity_id = 2241, dur = 0 },  
	       { event = 'kill', delay = 0,entity_id = 2242, dur = 0 },  
	    },
    
  --阿芝变为可攻击  
        {
           { event = 'createActor', jqid= 10}, 
        },

    },

  ['juqing413'] = 
    {
  --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
  --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 1},
        },  
  --阿芝、玩家移动至原位
        {
            { event = 'move', delay = 0, entity_id = 2249, dir = 1, pos = {142,90,}, speed = 340, dur = 1, end_dir = 1},
            { event = 'move', delay = 0, cast = 'player', dir = 5,pos = {150,84,},speed = 340, dur = 1, end_dir = 5},
        
        },

  --赤羽与阿芝争辩
        {
           { event = 'dialog', delay = 0.5, dialog_id = 108 },  
       },

  --玉羊出现 
        {
           { event = 'createActor', jqid= 12}, 
        },

  --玉羊攻击阿芝
        {
           { event = 'playAction', delay = 1, entity_id = 2250, dir = 1, action_id = 2, dur = 1,loop = false },
        },

  --阿芝冒泡表情
	    {
           { event = 'talk', delay = 0.1, entity_id = 2249, isEntity = false,talk = '啊....', dur = 1 },
           { event = 'playAction', delay = 0.2, entity_id= 2249, dir = 1, action_id = 4, dur = 1,loop = false },
        },

  --赤羽对白，让玩家撤退
        {
           { event = 'dialog', dialog_id = 109 },  
        },

  --赤羽、苏茉、玩家撤退
        {
            { event = 'move', delay = 0, entity_id = 2242, dir = 1, pos = {166,100,}, speed = 300, dur = 2 }, 
            { event = 'move', delay = 0, entity_id = 2241, dir = 1, pos = {165,101,}, speed = 300, dur = 2 },
            { event = 'move', delay = 0, cast = 'player', dir = 5,pos = {164,102,},speed = 300, dur = 2 },      
        },

  --赤羽、苏茉消失
	    {
	       { event = 'kill', delay = 0,entity_id = 2241, dur = 0 },  
	       { event = 'kill', delay = 0,entity_id = 2242, dur = 0 }, 
	       { event = 'move', delay = 0, cast = 'player', dir = 5,pos = {164,102,},speed = 340, dur = 1 }, 
	    },

  --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0.1,ttype = 0},
        },

  --请求通关副本
        {
           { event = 'carnet', delay = 0,dur = 0 },  
        },

    },

     --============================================wuwenbin  剧情副本第四章第一节  end  =====================================----


     --============================================wuwenbin  剧情副本第四章第二节  start  ===================================----


  ['juqing421'] = 
    {
  --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
  --前置1
        {
           { event = 'dialog', dialog_id = 118 },  
        },

        {
           { event = 'talk', delay = 0.1, entity_id = 2261, isEntity = false,talk = '{瞪眼}', dur = 1 },

           { event = 'talk', delay = 1.1, entity_id = 2262, isEntity = false,talk = '{闭嘴}', dur = 1 },
        },

        {
           { event = 'dialog',delay = 1, dialog_id = 119 },  
        },

        {

      		{ event = 'kill', delay = 0,entity_id = 2261, dur = 0 },  
	        { event = 'kill', delay = 0,entity_id = 2262, dur = 0 }, 
	        { event = 'kill', delay = 0,entity_id = 2263, dur = 0 }, 

        },

        {
           { event = 'createActor', jqid= 2 }, 
        },
    },   

 ['juqing422'] = 
 	{
        {
           { event = 'carnet', delay = 0,dur = 0 },  
        },
 	},

     --============================================wuwenbin  剧情副本第四章第二节  end  =====================================----
     --============================================wuwenbin  剧情副本第四章第三节  start  ===================================----


  ['juqing431'] = 
    {
 	 --动画组
        {   
          { event = 'hideAvatars' , delay = 0 },   -- 动画片段
          { event = 'hideUI' , delay = 0 },    -- 动画片段
          { event = 'disableSceneClicks' },    -- 动画片段
        },
    --镜头移动到苏茉所在区域 --dur 表示从当前到目的的时间     sdur 表示移动到之后停留的时间
	       --backtime 摄像机回来时间  不配置默认1秒回到玩家身上; c_topox 移动位置坐标（像素坐标）
        {
           { event = 'camera', delay =0.1, dur=1,sdur = 2,style = '',backtime = 1, c_topox = {560,1646} },
        },

        {
           { event = 'dialog', dialog_id = 82 },  
        },

        {
           { event = 'playAction', delay = 0.2, entity_id= 2283, dir = 1, action_id = 6, dur = 1,loop = true },
		},

        {
           { event = 'createActor', jqid= 2 }, 
        },

        {
           { event = 'talk', delay = 0.1, entity_id = 2283, isEntity = false,talk = '{九曜顺行，元始徘徊；}', dur = 1 },

           { event = 'talk', delay = 1.1, entity_id = 2283, isEntity = false,talk = '{华精茔明，元灵散开！}', dur = 1 },

            { event = 'playAction', delay = 0.2, entity_id= 2283, dir = 1, action_id = 0, dur = 1,loop = true },
        }, 

        {
           { event = 'createActor', jqid= 3 }, 
           { event = 'shake', delay = 0.1, dur = 1,c_topox = {560,1646},index = 30, rate = 4, radius = 20 }, 
        },

        {
           { event = 'talk', delay = 0.1, entity_id = 2283, isEntity = false,talk = '{踏平桃花坳！！！}', dur = 2 },

           { event = 'talk', delay = 1.1, entity_id = 2285, isEntity = false,talk = '{嗷呜~}', dur = 1 },
        }, 

        {
           { event = 'move', delay = 0, entity_id = 2285, dir = 1, pos = {28,55}, speed = 340, dur = 0, end_dir = 3, },
           { event = 'shake', delay = 1.1, dur = 1,c_topox = {560,1646},index = 30, rate = 4, radius = 20 },
           { event = 'shake', delay = 2.1, dur = 1,c_topox = {560,1646},index = 30, rate = 4, radius = 20 },
           { event = 'changePos', delay = 3, entity_id=2285, pos = {57,46}, },
		},

	    {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	    --,cast = 'player'
	       { event = 'camera', delay =0.1, dur=1,cast = 'player'},
	    },

        {
           { event = 'createActor', jqid= 4 }, 
        },

        {
           { event = 'dialog', dialog_id = 78 },  
        },

        {

           { event = 'move', delay = 0.2, entity_id = 2285, dir = 1, pos = {69,41}, speed = 340, dur = 2.5, end_dir = 1, },
           { event = 'shake', delay = 1.2, dur = 1,c_topox = {2074,1592},index = 30, rate = 4, radius = 20 },
           { event = 'shake', delay = 2.2, dur = 1,c_topox = {2074,1592},index = 30, rate = 4, radius = 20 },
      	   { event = 'kill', delay = 2.4,entity_id = 2285, dur = 0 },
		},

        {
           { event = 'talk', delay = 0.1, entity_id = 2281, isEntity = false,talk = '{惊骇}', dur = 2 },
           { event = 'talk', delay = 0.1, entity_id = 2282, isEntity = false,talk = '{惊骇}', dur = 2 },
           { event = 'talk', delay = 1.1,  cast = 'player', isEntity = false,talk = '{惊骇}', dur = 2 },
        },

        {
           { event = 'dialog',delay = 0.1, dialog_id = 79 },  
        },

        {

      		{ event = 'kill', delay = 0,entity_id = 2281, dur = 0 },  
	        { event = 'kill', delay = 0,entity_id = 2282, dur = 0 },

      		{ event = 'kill', delay = 0,entity_id = 2283, dur = 0 },  
	        { event = 'kill', delay = 0,entity_id = 2284, dur = 0 },	      

        },

        {
           { event = 'createActor',delay = 0.1, jqid= 5 }, 
        },

        {
           { event = 'dialog',delay = 0.1, dialog_id = 80 },  
        },

    },   

 ['juqing432'] = 
 	{

        {
           { event = 'createActor',delay = 0.1, jqid= 15 }, 
        },

        {
           { event = 'playAction', delay = 1, entity_id= 2282, dir = 0, action_id = 2, dur = 1,loop = true },
           { event = 'createActor', delay = 2, jqid= 16},
           { event = 'playAction', delay = 2.2, entity_id= 2282, dir = 0, action_id = 0, dur = 1,loop = true },         
		},


        {
           { event = 'move', delay = 0.2, entity_id = 2281, dir = 1, pos = {36,28}, speed = 340, dur = 2.5, end_dir = 6, },     
           { event = 'dialog',delay = 0.1, dialog_id = 81 },  
        },

        {
           { event = 'carnet', delay = 0,dur = 0 },  
        },
 	},

     --============================================wuwenbin  剧情副本第四章第三节  end  =====================================----

     --============================================wuwenbin  剧情副本第四章第四节  start  =====================================----
  ['juqing441'] = --  4-4剧情1
  	{
        --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --隐藏暂时不该出现的正常村民
  		{
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2303, cansee1 = false, dur = 0 },
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2304, cansee1 = false, dur = 0 },
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2305, cansee1 = false, dur = 0 },
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2306, cansee1 = false, dur = 0 },
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2307, cansee1 = false, dur = 0 },
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2308, cansee1 = false, dur = 0 },
           --[[{ event = 'changeVisible', delay = 0.1, entity_id1 = 2309, cansee1 = false, dur = 0 },
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2310, cansee1 = false, dur = 0 },]]
        },

	    --苏茉、玩家移动入关卡
	    {
	    	{ event = 'move', delay = 0, cast = 'player', dir = 5,pos = {103,93},speed = 340, dur = 0, end_dir = 7, },
            { event = 'move', delay = 0, entity_id = 2301, dir = 1, pos = {106,90,}, speed = 340, dur = 0, end_dir = 7, },
	    },

        --镜头沿被捆绑的村民存在的路线转一圈回到出生点
        {--镜头移动出去之后，可以这样设置回来。不配置此项，会在上一条backtime时间后自己回到玩家身上
	       --,cast = 'player'
	       { event = 'camera', delay = 0, dur=1,sdur = 1,style = '', c_topox = {1638,2103}, },
	       { event = 'camera', delay = 2, dur=2,sdur = 1.5,style = '', c_topox = {2860,1300}, },
	       { event = 'camera', delay = 6, dur=2,sdur = 1.5,style = 'lookat', c_topox = {2780,2790}, },
	       { event = 'camera', delay = 9, dur=1,cast = 'player'},
	    },

	    --刷出被缠村民A,B的特效
	    {
	    	{ event = 'effect', delay = 0, entity_id = 2311, layer = 2, effect_id = 8,loop = true},
	    	{ event = 'effect', delay = 0, entity_id = 2312, layer = 2, effect_id = 8,loop = true},
	    },


	    --[[苏茉、玩家移动入关卡
	    {
	    	{ event = 'move', delay = 0, cast = 'player', dir = 5,pos = {103,93},speed = 300, dur = 1, end_dir = 7, },
            { event = 'move', delay = 0, entity_id = 2301, dir = 1, pos = {106,90,}, speed = 300, dur = 1, end_dir = 7, },
	    },]]

  		--苏茉对白
        {
           { event = 'dialog', dialog_id = 83 },  
        },

        --苏茉跑出屏幕后消失	
        {
        	{ event = 'move', delay = 0, entity_id = 2301, dir = 1, pos = {96,88,}, speed = 300, dur = 1, },
        	{ event = 'kill', delay = 0.5,entity_id = 2301, dur = 0 },
        },    
  	}, 

  ['juqing442-a'] =
  	{
   		--尝试请求第4阶段
  		{
  			{ event = 'createActor', jqid= 3},
  		},

  		--被缠绕村民消失，正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2311, cansee1 = false, dur = 0 },
  			{ event = 'kill', delay = 0, entity_id = 2311, dur = 0 },
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2303, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2303, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0, entity_id = 2303, dir = 1, pos = {105,94,}, speed = 340, dur = 5 },
        	{ event = 'kill', delay = 2, entity_id = 2303, dur = 0 },
  		},
  	},

  ['juqing442-b'] =
  	{
  		--尝试请求第9阶段
  		{
  			{ event = 'createActor', jqid= 5},
  		},  		
  		--被缠绕村民消失，正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2312, cansee1 = false, dur = 0 },
        	{ event = 'kill', delay = 0, entity_id = 2312, dur = 0 },
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2304, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2304, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0, entity_id = 2304, dir = 1, pos = {105,94,}, speed = 340, dur = 5 },
        	{ event = 'kill', delay = 2, entity_id = 2304, dur = 0 },
  		},
  	},

  ['juqing443'] =
  	{
	    --刷出被缠村民C,D的特效
	    {
	    	{ event = 'effect', delay = 0.5, entity_id = 2313, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    	{ event = 'effect', delay = 0.5, entity_id = 2314, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    },
	},

  ['juqing444-c'] =
  	{
  		 --尝试请求第9阶段
  		{
  			{ event = 'createActor', jqid= 9},
  		},
  		--被缠绕村民消失，正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2313, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2305, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2305, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0, entity_id = 2305, dir = 1, pos = {110,37,}, speed = 340, dur = 5, },
        	{ event = 'kill', delay = 2,entity_id = 2305, dur = 0 },
  		},
  	},

  ['juqing444-d'] =
  	{
  		--尝试请求第11阶段
  		{
  			{ event = 'createActor', jqid= 11},
  		},
  		--被缠绕村民消失，正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2314, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2306, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2306, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0, entity_id = 2306, dir = 1, pos = {110,37,}, speed = 340, dur = 5, },
        	{ event = 'kill', delay = 2,entity_id = 2306, dur = 0 },
  		},

  	},

  ['juqing445'] =
  	{
	    --刷出被缠村民E,F的特效
	    {
	    	{ event = 'effect', delay = 0.5, entity_id = 2315, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    	{ event = 'effect', delay = 0.5, entity_id = 2316, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    },
	},

  ['juqing446-e'] =
  	{
  		--尝试请求第14阶段
  		{
  			{ event = 'createActor', jqid= 15},
  		},
  		--被缠绕村民消失，正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2315, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2307, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2307, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0, entity_id = 2307, dir = 1, pos = {57,55,}, speed = 340, dur = 3, },
        	{ event = 'kill', delay = 1,entity_id = 2307, dur = 0 },
  		},
  	},
  ['juqing446-f'] =
  	{
  		--尝试请求第14阶段
  		{
  			{ event = 'createActor', jqid= 17},
  		},
  	  		--被缠绕村民消失，正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2316, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2308, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2308, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0, entity_id = 2308, dir = 1, pos = {57,55,}, speed = 340, dur = 3, },
        	{ event = 'kill', delay = 1,entity_id = 2308, dur = 0 },
  		},
  	},

  --[[
  ['juqing447'] =
  	{
	    --刷出被缠村民G,H的特效
	    {
	    	{ event = 'effect', delay = 0.5, entity_id = 2317, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    	{ event = 'effect', delay = 0.5, entity_id = 2318, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
	    },
	},

  ['juqing448-g'] =
  	{
  		--被缠绕村民E消失
  		{
			{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2317},
			{ event = 'kill', delay = 0,entity_id = 2317, dur = 0 },
  		},
  		--正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2309, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id1 = 2309, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0.5, entity_id = 2309, dir = 1, pos = {36,54,}, speed = 300, dur = 3, end_dir = 7, },
        	{ event = 'kill', delay = 0,entity_id = 2309, dur = 0 },
  		},
  		--尝试请求第18阶段
  		{
  			{ event = 'createActor', jqid= 18},
  		},
  	},
  ['juqing448-h'] =
  	{
  		--被缠绕村民F消失
  		{
			{ event = 'removeEffect', delay = 0.1, effect_id = 8, entity_id = 2318},
			{ event = 'kill', delay = 0,entity_id = 2318, dur = 0 },
  		},
  		--正常村民出现，表示感谢之后消失
  		{
  			{ event = 'changeVisible', delay = 0.1, entity_id1 = 2310, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id1 = 2310, isEntity = false,talk = '多谢少侠相救{感谢}表情', dur = 1 },
  			{ event = 'move', delay = 0.5, entity_id = 2310, dir = 1, pos = {36,54,}, speed = 300, dur = 3, end_dir = 7, },
        	{ event = 'kill', delay = 0,entity_id = 2310, dur = 0 },
  		},
  		--尝试请求第18阶段
  		{
  			{ event = 'createActor', jqid= 18},
  		},
  	},]]

  ['juqing447'] =
  	{
  		
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        { 
           { event  = 'stopMonster',delay =0.1,ttype = 1},
        },

       	{--镜头移动到BOSS身上制造气氛
	       { event = 'camera', delay = 0, dur=1,sdur = 1,style = 'lookat', backtime = 1,c_topox = {732,2282}, },
  		   { event = 'talk', delay = 1.5, entity_id = 3213, isEntity = false,talk = '别挣扎了，你是清不完的！！', dur = 1.5 },
  		},
  		{
  			{ event = 'camera', delay = 0, dur= 1,cast = 'player'},
  		},

	    { 
            { event  = 'stopMonster',delay =0.1,ttype = 0},
        },
  	},

  ['juqing448'] = --  4-4剧情2
  	{
        --动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
 		
  		--苏茉赤羽刷出后改变方向
        {
        	{ event = 'move', delay = 0, entity_id = 2301,pos = {21,74,},speed = 340, dur = 0, end_dir = 7, }, 
	    	{ event = 'move', delay = 0, entity_id = 2302,pos = {18,75,},speed = 340, dur = 0, end_dir = 7, }, 
	    }, 
	     --玩家移动至剧情区域
  		{
	    	{ event = 'move', delay = 1, cast = 'player',pos = {18,71,},speed = 260, dur = 1, end_dir = 3, },
  		}, 
  		--苏茉和玩家的关卡结束对话
        {
           { event = 'dialog', dialog_id = 117 }, 
           { event = 'move', delay = 1, cast = 'player',pos = {18,71,},speed = 340, dur = 1, end_dir = 3, }, 
        },
  		--苏茉大哭
  		{
  			{ event = 'talk', delay = 0, entity_id = 2301, isEntity = false,talk = '{大哭}表情', dur = 2 },
  		},
  		--请求胜利
  		{
          	{ event = 'carnet', delay = 1,dur = 0 },
  		},


  	},
     --============================================wuwenbin  剧情副本第四章第四节  end  =====================================----

     --============================================wuwenbin  剧情副本第五章第一节  start  =====================================----

  ['juqing511'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --===================================区域1迷雾特效====================================
        {	--台子上
        	{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {51,111}, is_forever = true},
	    	{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {44,113}, is_forever = true},
	   		{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {51,116}, is_forever = true},
	   		--台子下
	   		--{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {55,123}, is_forever = true},
	   		{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {59,120}, is_forever = true},
    		{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {59,126}, is_forever = true},
    		{ event = 'effect', delay = 0.1, effect_id = 20005, layer = 10, pos = {50,123}, is_forever = true},	
	    },

	    --玩家原地转圈自说自话，表示不知道大家的去向
	    {
	    	{ event = 'talk', delay = 0, cast = 'player', isEntity = false,talk = '{疑问}表情', dur = 5 },
	    	{ event = 'move', delay = 1, cast = 'player',pos = {57,123,},speed = 280, dur = 1, end_dir = 1, }, 
	    	{ event = 'move', delay = 2, cast = 'player',pos = {57,125,},speed = 280, dur = 1, end_dir = 3, }, 
	    	--{ event = 'move', delay = 3, cast = 'player',pos = {55,125,},speed = 280, dur = 1, end_dir = 5, },
	    	{ event = 'move', delay = 3, cast = 'player',pos = {55,123,},speed = 280, dur = 1, end_dir = 7, },
	    	{ event = 'move', delay = 3, cast = 'player',pos = {55,123,},speed = 340, dur = 1, end_dir = 7, },     	
           	{ event = 'dialog', delay = 4, dialog_id = 84 }, 
        },

        --===================================区域1迷雾特效散去====================================
	    {
        	{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {51,111}, },
	    	{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {44,113}, },
	    	{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {51,116}, },

	   		--{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {55,123}, },
	   		{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {59,120}, },
	   		{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {59,126}, },
	   		{ event = 'removeEffect', delay = 1, effect_id = 20005, pos = {50,123}, },	
	    },

  	},

  ['juqing512'] =
  	{
  		
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        { 
           { event  = 'stopMonster',delay =0.1,ttype = 1},
        },

       	{--镜头移动到BOSS身上制造气氛
	       { event = 'camera', delay = 0, dur=1,sdur = 0.5,style = '', entity_id = 2329, },
	    },
	    {
  			{ event = 'talk', delay = 0, entity_id = 2329, isEntity = false,talk = '快过来，我在这里呀', dur = 1 },
  		},
  		{
  			{ event = 'camera', delay = 0.5, dur=1,cast = 'player'},
  		},
	    { 
            { event  = 'stopMonster',delay =0.1,ttype = 0},
        },
  	},

  ['juqing513'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
		--芙儿百里寒刷出后改变方向，玩家移动到指定区域
        {
        	{ event = 'playAction', delay = 0.5, entity_id= 2330, dir = 1, action_id = 4, dur = 0,loop = false },
        	{ event = 'move', delay = 0, entity_id = 2321,pos = {26,74},speed = 340, dur = 0, end_dir = 3, }, 
	    	{ event = 'move', delay = 0, entity_id = 2322,pos = {23,76},speed = 340, dur = 0, end_dir = 3, }, 
	    	{ event = 'move', delay = 0.5, cast = 'player',pos = {24,79,},speed = 260, dur = 1.3, end_dir = 1, },
	    	{ event = 'move', delay = 0.5, cast = 'player',pos = {24,79,},speed = 340, dur = 1, end_dir = 1, },
	    }, 

  		--玩家与百里寒芙儿的对话
  		{
  			{ event = 'dialog', dialog_id = 87 }, 
  		},
  		--刷出孙巨
  		{
  			{ event = 'createActor', jqid= 11},
  		},

   		--孙巨移动到指定地点,冒泡
   		{
   			{ event = 'camera', delay = 0.5, dur = 1,sdur = 1,style = '', entity_id = 2323, },
	    	{ event = 'move', delay = 0.5, entity_id = 2323,pos = {20,74},speed = 340, dur = 0, end_dir = 3, }, 
	    	{ event = 'talk', delay = 0.5, entity_id = 2323, isEntity = false,talk = '咳咳..', dur = 1.7 },
			--芙儿百里寒改变方向
        	{ event = 'move', delay = 1.5, entity_id = 2321,pos = {26,74},speed = 340, dur = 0, end_dir = 6, }, 
	    	{ event = 'move', delay = 1.5, entity_id = 2322,pos = {23,76},speed = 340, dur = 0, end_dir = 7, }, 
	    	{ event = 'move', delay = 1.5, cast = 'player',pos = {24,79,},speed = 340, dur = 0, end_dir = 7, },
	    	{ event = 'talk', delay = 1.8, entity_id = 2321, isEntity = false,talk = '咦，你是？', dur = 1 },
	    },
		--请求胜利
  		{
          	{ event = 'carnet', delay = 1,dur = 0 },
  		},
  },


     --============================================wuwenbin  剧情副本第五章第一节  end  =====================================----

     --============================================wuwenbin  剧情副本第五章第二节  start  =====================================----

  ['juqing521'] =
  	{
  		
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        { 
           { event  = 'stopMonster',delay =0.1,ttype = 1},
        },
        {
           { event = 'changeVisible', delay = 0.1, entity_id1 = 2349, cansee1 = false, dur = 0 },   
        },
        --苏茉上官锦改变方向
        {
        	{ event = 'move', delay = 0, entity_id = 2349,pos = {22,73},speed = 340, dur = 1, end_dir = 5, },
        	{ event = 'move', delay = 0.5, entity_id = 2341,pos = {22,73},speed = 340, dur = 0, end_dir = 7, }, 
	    	{ event = 'move', delay = 0.5, entity_id = 2343,pos = {21,72},speed = 340, dur = 0, end_dir = 3, }, 
	    },

       	{--镜头移动到剧情发生的中心
	       { event = 'camera', delay = 0, dur=0,sdur = 1,style = 'lookat', c_topox = {825,2390},},
	    },
	    --剧情1，赤羽与上官锦争吵
	    {
	    	{ event = 'talk', delay = 0, entity_id = 2341, isEntity = false,talk = '上官锦你放开我！', dur = 1 },
	    	{ event = 'move', delay = 0.5, entity_id = 2342,pos = {18,74},speed = 340, dur = 1, end_dir = 1, }, 
	    	{ event = 'move', delay = 1.5, entity_id = 2341,pos = {22,73},speed = 340, dur = 0, end_dir = 5, },
	    	{ event = 'move', delay = 1.5, entity_id = 2343,pos = {21,72},speed = 340, dur = 0, end_dir = 5, },  
	    	{ event = 'dialog', delay = 2, dialog_id = 88 }, 
	    },

	    --剧情2，玩家戳穿讹兽
	    {
	    	{ event = 'move', delay = 0.5, cast = 'player',pos = {21,76},speed = 240, dur = 0, end_dir = 1, }, 
	    	{ event = 'talk', delay = 0.5, cast = 'player',isEntity = false,talk = '大家小心，它是讹兽！', dur = 2 }, 
	    	{ event = 'move', delay = 1, entity_id = 2343,pos = {20,71},speed = 340, dir=3, dur = 0, end_dir = 3, },
	    	--{ event = 'dialog', dialog_id = 89 }, 
        },

        --讹兽出现并逃跑
        {	    	
	    	{ event = 'changeVisible', delay = 0.5, entity_id1 = 2341, cansee1 = false, dur = 0 },
	    	{ event = 'changeVisible', delay = 0.5, entity_id1 = 2349, cansee1 = true, dur = 0 },
        	{ event = 'kill', delay = 0,entity_id = 2341, dur = 1 },
	    	{ event = 'talk', delay = 1, entity_id = 2349, isEntity = false,talk = '算你厉害，小的们给我上！', dur = 1.5 },
	    	{ event = 'move', delay = 1, entity_id = 2349,pos = {27,73},speed = 340, dur = 1, end_dir = 1, },
	    	{ event = 'kill', delay = 1,entity_id = 2349, dur = 1 },
	    --},

	    --赤羽，上官锦消失
	    --{
	    	{ event = 'move', delay = 1.5, cast = 'player',pos = {21,76},speed = 340, dur = 1, end_dir = 1, }, --恢复玩家速度 
	    	{ event = 'kill', delay = 1.5,entity_id = 2342, dur = 0.5 },
	    	{ event = 'kill', delay = 1.5,entity_id = 2343, dur = 0.5 },
	    },	    

	    { 
            { event  = 'stopMonster',delay =0.1,ttype = 0},
        },
        --刷出第一波讹兽
        {
  			{ event = 'createActor', jqid= 2},
  		},
  	},

  ['juqing522'] =
  	{
  		
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        { 
           { event  = 'stopMonster',delay =0.1,ttype = 1},
        },

       	{--镜头移动到BOSS身上制造气氛
	    	{ event = 'camera', delay = 0, dur=1,sdur = 0.5,style = '', entity_id = 2349, },
  			{ event = 'talk', delay = 0, entity_id = 2349, isEntity = false,talk = '都是你坏了我的好事！', dur = 2 },
  		},
  		{
  			{ event = 'camera', delay = 0.5, dur=0.5,cast = 'player'},
  		},
	    { 
            { event  = 'stopMonster',delay =0.1,ttype = 0},
        },

  	},

  ['juqing523'] =
  	{
  		
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        { 
           { event  = 'stopMonster',delay =0.1,ttype = 1},
        },
        
		{	--玩家、讹兽移动并调整方向
	    	--{ event = 'move', delay = 0.5, entity_id = 2349,pos = {42,52,},speed = 340, dur = 2, end_dir = 3, },  
	    	--{ event = 'move', delay = 0.5, cast = 'player',pos = {40,54},speed = 340, dur = 2, end_dir = 1, }, 
	    	{ event = 'talk', delay = 1, entity_id = 2349, isEntity = false,talk = '没想到她会..额啊..', dur = 1 },
	    	{ event = 'playAction', delay = 2, entity_id= 2349, dir = 1, action_id = 4, dur = 1,loop = false },
	    	{ event = 'talk', delay = 3, cast = 'player', isEntity = false,talk = '先别死啊，苏茉在哪！', dur = 1 },
	    	{ event = 'kill', delay = 4,entity_id = 2349, dur = 0 },
		},
		{
  			{ event = 'createActor', jqid= 10},
  		},
	},

  ['juqing524'] =
    {
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
		{	
			--上官锦告诉玩家，三人去往苏茉处
			{ event = 'move', delay = 0, entity_id = 2341, pos = {62,63}, speed = 340, dur = 1, end_dir = 5, },
			{ event = 'move', delay = 0, entity_id = 2342, pos = {44,54}, speed = 340, dur = 1, end_dir = 7, },
			{ event = 'move', delay = 0, entity_id = 2343, pos = {46,53}, speed = 340, dur = 1, end_dir = 7, }, 
			--{ event = 'move', delay = 1, entity_id = 2342, pos = {38,53},speed = 260, dur = 1, end_dir = 3, },
			--{ event = 'move', delay = 1, entity_id = 2343, pos = {40,51},speed = 260, dur = 1, end_dir = 3, }, 
			{ event = 'talk', delay = 1, entity_id = 2343, isEntity = false,talk = '快来，苏茉在这边！', dur = 1 },
			{ event = 'move', delay = 2, entity_id = 2343, pos = {59,62},speed = 300, dur = 4, end_dir = 2, }, 
			{ event = 'move', delay = 2, entity_id = 2342, pos = {63,64},speed = 300, dur = 4, end_dir = 7, }, 
			{ event = 'move', delay = 2, cast = 'player', pos = {60,64},speed = 300, dur = 4, end_dir = 1, }, 
		},

		{	--在苏茉处的剧情
			{ event = 'move', delay = 0, cast = 'player', pos = {60,64},speed = 340, dur = 4, end_dir = 1, },  --恢复玩家速度
			{ event = 'talk', delay = 0, entity_id = 2342, isEntity = false,talk = '苏茉！', dur = 1 },
			{ event = 'talk', delay = 0, entity_id = 2343, isEntity = false,talk = '苏茉！', dur = 1 },
			{ event = 'talk', delay = 0, cast = 'player', isEntity = false,talk = '苏茉！', dur = 1 },
			{ event = 'dialog', delay = 1, dialog_id = 90 }, 
		},

		{	--对白完后进行的剧情
			{ event = 'talk', delay = 1, entity_id = 2341, isEntity = false,talk = '{吐血}{昏死}表情', dur = 1 },
            { event = 'playAction', delay = 2, entity_id= 2341, dir = 1, action_id = 4, dur = 1,loop = false },
            { event = 'talk', delay = 2.5, cast = 'player', isEntity = false,talk = '啊！茉儿昏死过去了！', dur = 1 },
        },

		--请求胜利
  		{
          	{ event = 'carnet', delay = 1,dur = 0 },
  		},

  	},

     --============================================wuwenbin  剧情副本第五章第二节  end  =====================================----

     --============================================wuwenbin  剧情副本第五章第三节  start  =====================================----

  ['juqing531'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        --停怪
        { 
           { event  = 'stopMonster',delay =0.5,ttype = 1},
        },

		{	
			--三人往里走至小童处
			{ event = 'move', delay = 0.5, cast = 'player', pos = {14,28}, speed = 340, dur = 0, end_dir = 1, },
			{ event = 'move', delay = 0.5, entity_id = 2362, pos = {11,27}, speed = 340, dur = 0, end_dir = 1, },
			{ event = 'move', delay = 0.5, entity_id = 2363, pos = {16,30}, speed = 340, dur = 0, end_dir = 1, }, 
			{ event = 'move', delay = 0.5, entity_id = 2373, pos = {17,26}, speed = 340, dur = 0, end_dir = 5, }, 
			{ event = 'talk', delay = 0.5, cast = 'player', isEntity = false,talk = '苏茉！苏茉！', dur = 2 },
		},

		{
			--小童喝止玩家
			{ event = 'talk', delay = 0.5,  entity_id = 2373, isEntity = false,talk = '嚷什么嚷！', dur = 2 },
		},

		{	--对白
			{ event = 'dialog', dialog_id = 91 },
		},

		{	--小童移出屏幕后消失,上官锦，赤羽也消失
			{ event = 'move', delay = 0, entity_id = 2373, pos = {33,25}, speed = 340, dur = 2, end_dir = 5, },
			{ event = 'kill', delay = 1, entity_id = 2373, dur = 0 },
			{ event = 'kill', delay = 1.5, entity_id = 2362, dur = 0 },
			{ event = 'kill', delay = 1.5, entity_id = 2363, dur = 0 },
		},

		--结束停怪
        { 
           { event  = 'stopMonster',delay =0.1,ttype = 0},
        },

		{	--刷出第一波道童
  			{ event = 'createActor', delay = 0.5, jqid= 2},
  		},
  	},

  ['juqing532'] =
  	{
		{
			--小童出现并冒泡
			{ event = 'talk', delay = 0.5,  entity_id = 2373, isEntity = false,talk = '想找她，先过我这关！', dur = 3 },
		},  		
  	},

  ['juqing533'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        {	--救人小童站位和施法动作
        	{ event  = 'stopMonster',delay =0,ttype = 1},
			{ event = 'playAction', delay = 1, entity_id= 2364, dir = 5, action_id = 2, dur = 1,loop = true },
			{ event = 'playAction', delay = 1, entity_id= 2365, dir = 7, action_id = 2, dur = 1,loop = true },
			{ event = 'playAction', delay = 1, entity_id= 2366, dir = 1, action_id = 2, dur = 1,loop = true },
			{ event = 'playAction', delay = 1, entity_id= 2367, dir = 3, action_id = 2, dur = 1,loop = true },
        	{ event = 'effect', delay = 0, effect_id = 20002, layer = 1, entity_id= 2361, is_forever = true},
        	{ event = 'playAction', delay = 0.7, entity_id= 2361, dir = 1, action_id = 4, dur = 1,loop = false },
        	--[[  --有特效后再补充
        	{ event = 'effect', delay = 0.1, effect_id = 20002, layer = 1, entity_id= 2364, is_forever = true},
        	{ event = 'effect', delay = 0.1, effect_id = 20002, layer = 1, entity_id= 2365, is_forever = true},
        	{ event = 'effect', delay = 0.1, effect_id = 20002, layer = 1, entity_id= 2366, is_forever = true},
        	{ event = 'effect', delay = 0.1, effect_id = 20002, layer = 1, entity_id= 2367, is_forever = true},

        	{ event  = 'stopMonster',delay =0,ttype = 0},
        	{ event = 'createActor', jqid= 10},
            { event  = 'stopMonster',delay =0,ttype = 1},]]

        	{ event = 'move', delay = 0.7, entity_id = 2373, pos = {46,13}, speed = 340, dur = 1, end_dir = 3, },
  			{ event = 'move', delay = 0.7, entity_id = 2362, pos = {53,14}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0.7, entity_id = 2363, pos = {47,18}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0.7, cast = 'player', pos = {50,16}, speed = 340, dur = 2, end_dir = 7, },
    	},

    	{	--小童表示生气
			{ event = 'talk', delay = 0,  entity_id = 2373, isEntity = false,talk = '不救了！好心没好报！{恼怒}表情', dur = 3 },
			{ event = 'talk', delay = 0.5,  entity_id = 2362, isEntity = false,talk = '{疑问}表情', dur = 2 },
			{ event = 'talk', delay = 0.5,  entity_id = 2363, isEntity = false,talk = '{疑问}表情', dur = 2 },
			{ event = 'talk', delay = 0.5,  cast = 'player', isEntity = false,talk = '{疑问}表情', dur = 2 },
		},

  		{
			--小童冒泡,并走开,上官锦一起			
			{ event = 'move', delay = 0, entity_id = 2373, pos = {47,6}, speed = 340, dur = 1, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2362, pos = {45,8}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2363, pos = {40,12}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0, cast = 'player', pos = {43,11}, speed = 340, dur = 2, end_dir = 7, },
		},

  		{	--前置对话
  			{ event = 'dialog', delay = 1, dialog_id = 93 },
  		},

		--请求胜利
  		{
          	{ event = 'carnet', delay = 1,dur = 0 },
  		},

  	},
    --============================================wuwenbin  剧情副本第五章第三节  end  =====================================----


  	--============================================wuwenbin  剧情副本第五章第五节  start  =====================================----
  ['juqing551'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        --停怪
        { 
           { event  = 'stopMonster',delay =0.5,ttype = 1},
        },

		{	--调整四人朝向
        	{ event = 'move', delay = 0.5, entity_id = 2401, pos = {10,50}, speed = 340, dur = 1, end_dir = 1, },
  			{ event = 'move', delay = 0.5, entity_id = 2402, pos = {13,51}, speed = 340, dur = 1, end_dir = 1, },
  			{ event = 'move', delay = 0.5, entity_id = 2403, pos = {14,55}, speed = 340, dur = 1, end_dir = 1, },
  			{ event = 'move', delay = 0.5, cast = 'player', pos = {11,54}, speed = 340, dur = 1, end_dir = 1, },  
  		}, 

  		{	--玩家前置对话
  			{ event = 'dialog', delay = 0.5, dialog_id = 120 },
  		},     

		{	--3个NPC消失
        	{ event = 'kill', delay = 0, entity_id = 2401, dur = 0,},
  			{ event = 'kill', delay = 0, entity_id = 2402, dur = 0,},
  			{ event = 'kill', delay = 0, entity_id = 2403, dur = 0,}, 
  		},

        --取消停怪
        { 
           { event  = 'stopMonster',delay =0.5,ttype = 0},
        }, 

  		{	--刷出第一波水虺
  			{ event = 'createActor', delay =0.5, jqid= 2},
  		},
  	},

  ['juqing552'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        { 
           { event  = 'stopMonster',delay =0.1,ttype = 1},
        },

		{	--四人移动向指定位置,调整后道长和道童朝向
        	{ event = 'move', delay = 0, entity_id = 2401, pos = {42,26}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2402, pos = {40,27}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2403, pos = {39,29}, speed = 340, dur = 2, end_dir = 7, },
  			{ event = 'move', delay = 0, cast = 'player',  pos = {45,26}, speed = 340, dur = 2, end_dir = 7, }, 
  			{ event = 'move', delay = 2, entity_id = 2404, pos = {24,12}, speed = 340, dur = 1, end_dir = 3, },
  			{ event = 'move', delay = 2, entity_id = 2405, pos = {20,13}, speed = 340, dur = 1, end_dir = 3, }, 
  		},


        {	--镜头给道长，移动到
        	{ event = 'camera', delay = 0, dur = 1,sdur = 3,style = '', entity_id = 2405, },
        	{ event = 'playAction', delay = 0, entity_id= 2405, dir = 1, action_id = 4, dur = 1,loop = false },
        	{ event = 'talk', delay = 1, entity_id = 2405, isEntity = false, talk = 'Zzzzz...', dur = 2 },
        	{ event = 'move', delay = 2, entity_id = 2404, pos = {22,13}, speed = 340, dur = 1, end_dir = 5, },
        	{ event = 'talk', delay = 3, entity_id = 2404, isEntity = false, talk = '师傅，青龙玄女来了。', dur = 1 },
        	{ event = 'talk', delay = 4.5, entity_id = 2405, isEntity = false, talk = '嗯...来啦{困}', dur = 3 },
        	{ event = 'move', delay = 5, entity_id = 2405, pos = {31,21}, speed = 300, dur = 1, end_dir = 3, },
        	{ event = 'move', delay = 6, entity_id = 2404, pos = {32,19}, speed = 300, dur = 1, end_dir = 3, },
       		{ event = 'camera', delay = 6, dur = 1,sdur = 3,style = '', c_topox = {1200,800},},
       		{ event = 'talk', delay = 6.5,  entity_id = 2401, isEntity = false,talk = '{皱眉}表情', dur = 1 },
    	}, 

  		{	--前置对话
  			{ event = 'dialog', delay = 0, dialog_id = 121 },
  		}, 

		{	--道长召唤怪物，NPC消失
        	{ event = 'talk', delay = 0.5,  entity_id = 2405, isEntity = false,talk = '先别说，过我三关再说', dur = 1 },
        	{ event = 'playAction', delay = 1, entity_id= 2405, dir = 3, action_id = 2, dur = 1,loop = false },
        	{ event  = 'stopMonster',delay = 1.5, ttype = 0},
        	{ event = 'createActor',delay = 1.5, jqid= 7},
        	{ event = 'kill', delay = 1.3, entity_id = 2401, dur = 0,},
  			{ event = 'kill', delay = 1.3, entity_id = 2402, dur = 0,},
  			{ event = 'kill', delay = 1.3, entity_id = 2403, dur = 0,}, 
  			{ event = 'kill', delay = 1.3, entity_id = 2404, dur = 0,},
  			{ event = 'kill', delay = 1.3, entity_id = 2405, dur = 0,},
    	}, 
  	},

  ['juqing553'] =
  {
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

  		{	--道长召唤怪物
  			{ event = 'move', delay = 0, entity_id = 2405, pos = {31,21}, speed = 300, dur = 1, end_dir = 3, },--道长调整朝向
  			{ event = 'camera', delay = 0, dur = 1,sdur = 1,style = '', entity_id = 2405, },
        	{ event = 'talk', delay = 0.5,  entity_id = 2405, isEntity = false,talk = '不错，那这个如何？', dur = 1 },
        	{ event = 'playAction', delay = 1, entity_id= 2405, dir = 3, action_id = 2, dur = 0,loop = false },
        	--刷出凶兽当康
        	{ event = 'createActor', delay = 1.5, jqid= 9},
  			--道长消失 
  			{ event = 'kill', delay = 1.5, entity_id = 2405, dur = 0,},
  		},
  },

  ['juqing554'] =
  {
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

  		{	--道长召唤怪物
  			{ event = 'move', delay = 0, entity_id = 2405, pos = {31,21}, speed = 300, dur = 1, end_dir = 3, },--道长调整朝向
  			{ event = 'camera', delay = 0, dur = 1,sdur = 1,style = '', entity_id = 2405, },
        	{ event = 'talk', delay = 0.5,  entity_id = 2405, isEntity = false,talk = '嗯，最后一个也可以？', dur = 1 },
        	{ event = 'playAction', delay = 1, entity_id= 2405, dir = 3, action_id = 2, dur = 0,loop = false },
        	--召唤凶兽相柳
        	{ event = 'createActor', delay = 1.5, jqid= 11},
			--道长消失 
  			{ event = 'kill', delay = 1.5, entity_id = 2405, dur = 0,},
  		},
  },

  ['juqing555'] =
  {
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },


        {	--调整NPC朝向
  			{ event = 'move', delay = 0.5, cast = 'player', pos = {39,25}, speed = 260, dur = 1.5, end_dir = 7, }, 
  			{ event = 'move', delay = 0, entity_id = 2401, pos = {36,25}, speed = 340, dur = 1, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2402, pos = {34,26}, speed = 340, dur = 1, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2403, pos = {33,28}, speed = 340, dur = 1, end_dir = 7, },
  			{ event = 'move', delay = 0, entity_id = 2404, pos = {31,21}, speed = 340, dur = 1, end_dir = 3, },
  			{ event = 'move', delay = 0, entity_id = 2405, pos = {30,23}, speed = 340, dur = 1, end_dir = 3, },
  			{ event = 'move', delay = 0, cast = 'player', pos = {38,23}, speed = 340, dur = 0, end_dir = 7, }, 
  			{ event = 'camera', delay = 0, dur = 1,sdur = 1,style = '', c_topox = {1040,720}, },--镜头移至众人中间
  		},

  		{	--陆压向芙儿施法

  			{ event = 'playAction', delay = 0.5, entity_id= 2405, dir = 3, action_id = 2, dur = 1,loop = false },
  			{ event = 'effect', delay = 1, effect_id = 20002, layer = 1, entity_id= 2401, is_forever = false}, --特效，一束光飞向芙儿
  			{ event = 'effect', delay = 1.5, effect_id = 20003, layer = 1, entity_id= 2401, is_forever = false}, --特效，芙儿身上出现保护罩
  			{ event = 'talk', delay = 2,  entity_id = 2401, isEntity = false,talk = '这是...？', dur = 1.5 },  			
  		},

  		{	--前置对白
  			{ event = 'dialog', delay = 1, dialog_id = 122 },
  		},

  		{	--陆压向百里寒施法
  			{ event = 'playAction', delay = 0.5, entity_id= 2405, dir = 3, action_id = 2, dur = 1,loop = false },
  			{ event = 'effect', delay = 1, effect_id = 20002, layer = 1, entity_id= 2402, is_forever = false }, --特效，一束光飞向百里寒		
  		},

  		{	--孙巨求buff
  			{ event = 'talk', delay = 1,  entity_id = 2403, isEntity = false,talk = '{谄媚}道长，到我了。。', dur = 1 },
  			{ event = 'playAction', delay = 2, entity_id= 2405, dir = 1, action_id = 4, dur = 1,loop = false },	
  			{ event = 'talk', delay = 3,  entity_id = 2405, isEntity = false,talk = 'Zzzzz……', dur = 4 },	
  			{ event = 'talk', delay = 4,  entity_id = 2404, isEntity = false,talk = '道长仙游，你们回去吧！', dur = 2 },	
  			{ event = 'talk', delay = 5,  entity_id = 2403, isEntity = false,talk = '哼！', dur = 1.5 },
  		},

		--请求胜利
  		{
          	{ event = 'carnet', delay = 1,dur = 0 },
  		},

  },
	--============================================wuwenbin  剧情副本第五章第五节  end  =====================================----






     --===============================================第五章第四节开始====================================================
	['juqing541'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0,ttype = 1},
           { event = 'move', delay = 0.1,cast = 'player', pos = {5,50},speed = 340, dur = 1 , end_dir = 2},
        },

        {	
        	--对白 【苏茉】这里，就是陆压道长修炼的地方
			{ event = 'dialog', dialog_id = 94 },
			--隐藏朱雀
			{ event = 'changeVisible', delay = 0.1,entity_id1 = 2392, cansee1 = false,dur = 0 }, 
		},

		{	--刷出3个三青鸟，看是否要加入镜头移动
  			{ event = 'createActor', jqid= 2},
  			{ event = 'dialog',dialog_id = 95, delay = 0.1 },
  		},

  		--小童喊定身
  		{
  			{ event = 'talk', delay = 0.5, entity_id = 2387, isEntity = false,talk = '定！', dur = 1.5 },
  			{ event = 'effect', delay = 1, entity_id = 2390, layer = 2, effect_id = 10125,dx = 0,dy = 30,is_forever = true},
  			{ event = 'effect', delay = 1, entity_id = 2391, layer = 2, effect_id = 10125,dx = 0,dy =30,is_forever = true},
  			{ event = 'effect', delay = 1, cast = 'player',layer = 2, effect_id = 10125,dx = 0,dy = 30,is_forever = true},
  			{ event = 'talk', delay = 1.5, entity_id = 2389, isEntity = false,talk = '{疑惑}', dur = 1.5 },
  			{ event = 'talk', delay = 2.5, entity_id = 2389, isEntity = false,talk = '你做什么，快解开咒语！', dur = 1.5 },
  		},

  		--三青鸟追苏茉
  		{
  			{ event = 'talk', delay = 0.1, entity_id = 2387, isEntity = false,talk = '{嘘}', dur = 1.5},
  			--三个鸟跑+冒泡
  			{ event = 'talk', delay = 0.1,  entity_id = 2381, isEntity = false,talk = '吱吱……', dur = 1.5 },	
  			{ event = 'talk', delay = 0.1,  entity_id = 2383, isEntity = false,talk = '吱吱……', dur = 1.5 }, 
  			{ event = 'talk', delay = 0.1,  entity_id = 2382, isEntity = false,talk = '吱吱……', dur = 1.5 },	
  			{ event = 'move', delay = 0.1, entity_id = 2381, pos = {14,51}, speed = 340, dur = 0.5, },
  			{ event = 'move', delay = 0.1, entity_id = 2382, pos = {14,51}, speed = 340, dur = 0.5, },
  			{ event = 'move', delay = 0.1, entity_id = 2383, pos = {14,51}, speed = 340, dur = 0.5, },
  			{ event = 'move', delay = 1, entity_id = 2389, pos = {11,52}, speed = 500, dur = 0.5, end_dir=5},
  			{ event = 'talk', delay = 1,  entity_id = 2389, isEntity = false,talk = '不要', dur = 1.5 },
  		--},

  		--{
  		--震屏+特效，三青鸟变朱雀
  			{ event = 'shake', delay = 1.2, dur = 0.1,cast = 'player',index = 60,rate = 4,radius = 30}, 
  			{ event = 'kill', delay = 1.2, entity_id = 2381, dur = 0 },	
  			{ event = 'kill', delay = 1.2, entity_id = 2382, dur = 0 },	
  			{ event = 'kill', delay = 1.2, entity_id = 2383, dur = 0 },		 
  			{ event = 'effect', delay = 1.5, effect_id = 20003, layer = 2, entity_id = 2392, dx = 0,dy = -100},--, is_forever = true
  			{ event = 'changeVisible', delay = 1.5,entity_id1 = 2392, cansee1 = true,dur = 0.1 },	
  			{ event = 'move', delay = 2.3, entity_id = 2389, pos = {11,52}, speed = 340, dur = 0.5, end_dir=1},
  			{ event = 'talk', delay = 2.3,  entity_id = 2389, isEntity = false,talk = '!', dur = 2},
  			--{ event = 'removeEffect', delay = 0.5,  pos = {11,51},effect_id = 20002},
  		},

  		--3人冒泡	
  		{
        	-- { event = 'camera', delay = 0.1, dur=1,sdur = 0.1,cast = 'player',style = ''},
        	{ event = 'talk', delay = 0.5,  entity_id = 2391, isEntity = false,talk = '朱雀', dur = 1.5 },
        	{ event = 'talk', delay = 0.5,  entity_id = 2390, isEntity = false,talk = '玄女', dur = 1.5 },
        	{ event = 'talk', delay = 0.5,  cast = 'player', isEntity = false,talk = '苏茉', dur = 1.5 },
  		},

  		--杀掉没用的人
  		{	
  			{ event = 'kill', delay = 0.1, entity_id = 2389, dur = 0 },	
  			{ event = 'kill', delay = 0.1, entity_id = 2390, dur = 0 },	
  			{ event = 'kill', delay = 0.1, entity_id = 2391, dur = 0 },	
  			{ event = 'kill', delay = 0.1, entity_id = 2392, dur = 0 },	
  			{ event = 'kill', delay = 0.1, entity_id = 2387, dur = 0 },	
  			{ event = 'removeEffect', delay = 0.1,cast = 'player',effect_id = 10125},
  		},

  		--停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0,ttype = 0},
        },

  		--请求进入阶段3
  		{
  			{ event = 'createActor', jqid= 3},
  		},
  	},

  	--第五章第四节剧情2
	['juqing542'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
  		--众人跑过去，小童叫醒陆压道长
  		{
  			{ event = 'move', delay = 0.1, entity_id = 2390, pos = {28,22}, speed = 200, dur = 3 },	--上官锦跑
  			{ event = 'move', delay = 0.1, entity_id = 2389, pos = {30,21}, speed = 200, dur = 3 },	--苏茉跑
  			{ event = 'move', delay = 0.1, entity_id = 2391, pos = {32,20}, speed = 200, dur = 3 },	--赤羽跑
  			{ event = 'move', delay = 0.1,cast = 'player', pos = {34,19},speed = 250, dur = 3},	--玩家跑
  			--{ event = 'camera', delay = 3, dur=1,sdur = 1,style = '', entity_id = 2388, backtime = 1},
  		},
  		{
  			{ event = 'camera', delay = 0.5, dur= 1 ,sdur = 1,style = '',backtime=1, c_topox = {883, 432} },
  			{ event = 'talk', delay = 0.5,  entity_id = 2388, isEntity = false,talk = 'Zzz……', dur = 2.5 },
  			{ event = 'talk', delay = 1.5,  entity_id = 2387, isEntity = false,talk = '师傅，快醒醒……', dur = 1.5 },
  			{ event = 'move', delay = 2.5,  entity_id = 2388, pos = {21,12}, speed = 340, dur = 1,end_dir = 3},
  		},

  		--前置对白
  		{
  			{ event = 'dialog',dialog_id = 97, delay = 1 },
  			{ event = 'move', delay = 0.1,cast = 'player', pos = {34,19},speed = 340, dur = 1 },	--恢复玩家速度
  		},

  		--陆压道长biu的一下变出一个怪物
  		{
  			{ event = 'playAction', entity_id= 2388, delay = 0.5, action_id = 5, dur = 1.5, dir = 3,loop = false },
  			{ event = 'camera', delay = 1, dur= 1 ,sdur = 1.5 ,style = '',backtime=1, c_topox = {1232, 817} },
  			{ event = 'createActor', jqid= 8,},
  		},

  		--请求进入阶段8
  		{
  			{ event = 'kill', delay = 0.1, entity_id = 2389, dur = 0 },		
  			{ event = 'kill', delay = 0.1, entity_id = 2390, dur = 0 },	
  			{ event = 'kill', delay = 0.1, entity_id = 2391, dur = 0 },	
  		},
  	}, 

  	--第五章第四节剧情3
	['juqing543'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
  		
  		--演员就位
  		{
  			{ event = 'move', delay = 0.1,cast = 'player', pos = {36,19},speed = 340, dur = 1 },
  		},

  		--停止或者打开怪物的动作  0 开始  1 停止
        { 
           {event  = 'stopMonster',delay =0,ttype = 1},
        },
        --3个怪物piu到苏茉他们身上
  		{
  			{ event = 'effect', delay = 0.1, entity_id = 2384, layer = 2, effect_id = 20003,dx = 0,dy = -100},
  			{ event = 'effect', delay = 0.1, entity_id = 2385, layer = 2, effect_id = 20003,dx = 0,dy = -100},
  			{ event = 'effect', delay = 0.1, entity_id = 2386, layer = 2, effect_id = 20003,dx = 0,dy = -100},
  			{ event = 'moveEffect', delay = 1.5, effect_id = 10126, pos1 = {28,14},pos2 = {30,22},pos3 ={30,18},dur = 1,m_dur = 0.7 },	--火->苏茉
  			{ event = 'moveEffect', delay = 1.5, effect_id = 10126, pos1 = {31,11},pos2 = {33,20},pos3 ={32,17},dur = 1,m_dur = 0.7 },	--呲铁->赤羽
  			{ event = 'moveEffect', delay = 1.5, effect_id = 10126, pos1 = {25,16},pos2 = {27,23},pos3 ={28,19},dur = 1,m_dur = 0.7 }, --河图洛书->上官锦
  			{ event = 'kill', delay = 0.5, entity_id = 2385, dur = 0 },	
  			{ event = 'kill', delay = 0.5, entity_id = 2386, dur = 0 },	
  			{ event = 'kill', delay = 0.5, entity_id = 2384, dur = 0 },
  			{ event = 'talk', delay = 2.5,  entity_id = 2389, isEntity = false,talk = '!!', dur = 1.5 },
  			{ event = 'talk', delay = 2.5,  entity_id = 2390, isEntity = false,talk = '!!', dur = 1.5 },
  			{ event = 'talk', delay = 2.5,  entity_id = 2391, isEntity = false,talk = '!!', dur = 1.5 },
        	{ event = 'removeEffect', delay = 2,  pos = {28,14},effect_id = 10126},
        	{ event = 'removeEffect', delay = 2,  pos = {31,11},effect_id = 10126},
        	{ event = 'removeEffect', delay = 2,  pos = {25,16},effect_id = 10126},
        },

        --前置对白
        {
			{ event = 'dialog',dialog_id = 98, delay = 0.1 },
        },

        --转身要睡觉了
        {
        	{ event = 'camera', delay = 0.1, dur=1,sdur = 1,style = '', entity_id = 2388, backtime = 1},
        	{ event = 'move', delay = 0.5,  entity_id = 2388, pos = {21,12}, speed = 340, dur = 1,end_dir = 7},
        	{ event = 'talk', delay = 0.5,  entity_id = 2388, isEntity = false,talk = '{哈欠}', dur = 2.5 },
        	{ event = 'dialog',dialog_id = 99, delay = 1.5 },
    	},

    	--请求通关
    	{
    		{ event = 'carnet', delay = 2,dur = 0 },
    	},
  	},

  	--============================================wuwenbin  剧情副本第六章第二节  start  =====================================----

  	['juqing611'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        { 
            { event  = 'stopMonster',delay = 1.2,ttype = 1},
           	{ event = 'move', delay = 1.2, entity_id = 2421, dir = 1, pos = {22,49,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2422, dir = 1, pos = {23,51,}, speed = 340, dur = 2, end_dir = 5},

           	{ event = 'move', delay = 1.2, entity_id = 2432, dir = 1, pos = {18,53,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2423, dir = 1, pos = {19,50,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2424, dir = 1, pos = {21,46,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2425, dir = 1, pos = {24,47,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2426, dir = 1, pos = {21,53,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2427, dir = 1, pos = {24,54,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, entity_id = 2428, dir = 1, pos = {26,51,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1.2, cast = 'player', dir = 1,pos = {14,56,}, speed = 340, dur = 1, end_dir = 1},
        	{ event = 'dialog', delay = 2, dialog_id = 124,},
        },

        --鲛人押送苏茉宏泰离开
        { 
        	{ event = 'move', delay = 1, entity_id = 2421, dir = 1, pos = {39,42,}, speed = 340, dur = 2, end_dir = 5},
        	{ event = 'talk', delay = 1,  entity_id = 2421, isEntity = false,talk = '救我{大哭}！', dur = 2 },
           	{ event = 'move', delay = 1, entity_id = 2422, dir = 1, pos = {40,44,}, speed = 340, dur = 2, end_dir = 5},

        	--{ event = 'move', delay = 1, entity_id = 2432, dir = 1, pos = {36,45,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1, entity_id = 2423, dir = 1, pos = {37,43,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'talk', delay = 1,  entity_id = 2423, isEntity = false,talk = '快走！', dur = 2 },

           	{ event = 'move', delay = 1, entity_id = 2424, dir = 1, pos = {38,41,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1, entity_id = 2425, dir = 1, pos = {41,41,}, speed = 340, dur = 2, end_dir = 5},

           	{ event = 'move', delay = 1, entity_id = 2426, dir = 1, pos = {38,45,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'talk', delay = 1,  entity_id = 2426, isEntity = false,talk = '快走！', dur = 2 },

           	{ event = 'move', delay = 1, entity_id = 2427, dir = 1, pos = {41,46,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'move', delay = 1, entity_id = 2428, dir = 1, pos = {42,43,}, speed = 340, dur = 2, end_dir = 5},

           	{ event = 'kill', delay = 2, entity_id = 2421, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2422, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2423, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2424, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2425, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2426, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2427, dur = 2,},
           	{ event = 'kill', delay = 2, entity_id = 2428, dur = 2,},

           	{ event = 'talk', delay = 3,  entity_id = 2432, isEntity = false,talk = '有本事就来水宫救他们吧！', dur = 2 },
           	{ event = 'move', delay = 4, entity_id = 2432, dir = 1, pos = {36,45,}, speed = 340, dur = 2, end_dir = 5},
           	{ event = 'kill', delay = 5, entity_id = 2432, dur = 1,},
            { event  = 'stopMonster',delay = 5,ttype = 0},
        },
	},

	['juqing612'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --镜头移动至BOSS刷出位置
        {
            { event  = 'stopMonster',delay = 0, ttype = 1},
        },
	    {
	    	{ event = 'move', delay = 0, entity_id = 2421, dir = 1, pos = {8,10}, speed = 340, dur = 2, end_dir = 3},
           	{ event = 'move', delay = 0, entity_id = 2422, dir = 1, pos = {17,6}, speed = 340, dur = 2, end_dir = 3},
	    	{ event = 'camera', delay = 0, dur = 1,sdur = 1,style = '', entity_id = 2432}, 
	        { event = 'talk', delay = 1,  entity_id = 2432, isEntity = false,talk = '把安安还回来！', dur = 2 },
  			{ event = 'camera', delay = 2, dur = 1,cast = 'player'},
  		},
  		{
            {event  = 'stopMonster',delay = 0,ttype = 0},
        },
	},

	['juqing613'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        {
            {event  = 'stopMonster',delay = 0,ttype = 1},
        },

        --移动至位置
        {
           	{ event = 'move', delay = 0.5, entity_id = 2432, dir = 1, pos = {15,9,}, speed = 260, dur = 1.5, end_dir = 3},
           	{ event = 'move', delay = 0.5, cast = 'player', dir = 1, pos = {18,11,}, speed = 260, dur = 1.5, end_dir = 7},
        },
        {    	
			{ event = 'dialog',dialog_id = 125, delay = 0 },	
        },
        --请求胜利
        {
        	{ event = 'move', delay = 0, cast = 'player', dir = 1,pos = {18,11,}, speed = 340, dur = 1, end_dir = 7},  --恢复角色速度
    		{ event = 'carnet', delay = 1,dur = 0 },
    	},
	},

  	--============================================wuwenbin  剧情副本第六章第一节  end  	 =====================================----

  	--============================================wuwenbin  剧情副本第六章第二节  start  =====================================----

  	['juqing621'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --进入副本后移动，后嘉嘉说话
        {
           	{ event = 'move', delay = 1.2, entity_id = 2441, dir = 1, pos = {66,95,}, speed = 340, dur = 1, end_dir = 5},    
           	{ event = 'move', delay = 1.2, entity_id = 2442, dir = 1, pos = {70,98,}, speed = 340, dur = 1, end_dir = 5}, 
           	{ event = 'move', delay = 1.2, entity_id = 2443, dir = 1, pos = {66,98,}, speed = 340, dur = 1, end_dir = 1}, 
           	{ event = 'move', delay = 1.2, cast = 'player', dir = 1,pos = {69,96,}, speed = 340, dur = 1, end_dir = 5},
        	{ event = 'dialog',dialog_id = 126, delay = 1.7 },
        },

        --嘉嘉移动出屏幕，然后3NPC消失
        { 
           	{ event = 'move', delay = 0, entity_id = 2443, dir = 1, pos = {52,96,}, speed = 260, dur = 0.5, end_dir = 1},
           	{ event = 'kill', delay = 0.8, entity_id = 2443, dur = 1, },  
           	{ event = 'kill', delay = 0.8, entity_id = 2441, dur = 1, },    
           	{ event = 'kill', delay = 0.8, entity_id = 2442, dur = 1, }, 
        },

        --刷出第一波紫箭竹
        {
        	{ event = 'createActor', jqid= 2,},
        },
	},

	['juqing622'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --镜头移动至BOSS刷出位置
        {
            { event  = 'stopMonster',delay = 0, ttype = 1},
        },
	    {
	    	{ event = 'camera', delay = 0, dur = 0.5, sdur = 1, style = '', c_topox = {1565,720},},
	    	{ event = 'shake', delay = 1, dur = 1, c_topox = {1565,720}, index = 60, rate = 4, radius = 40 }, 
	        { event = 'talk', delay = 2,  entity_id = 2449, isEntity = false,talk = ' 嚯！', dur = 1 }, 
	        { event = 'talk', delay = 3,  cast = 'player', isEntity = false,talk = ' 哈！', dur = 1 },
	        { event = 'talk', delay = 4,  entity_id = 2449, isEntity = false,talk = ' 嚯！！', dur = 1 }, 
	        { event = 'talk', delay = 5,  cast = 'player', isEntity = false,talk = ' 哈！！', dur = 1 },  
	        { event = 'talk', delay = 6,  entity_id = 2449, isEntity = false,talk = ' 是谁送你来到我身..诶不对！', dur = 1.5 },
  			{ event = 'camera', delay = 7.8, dur = 0.5,cast = 'player'},
  		},
  		{
            {event  = 'stopMonster',delay = 0,ttype = 0},
        },
	},

	['juqing623'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        {
            { event  = 'stopMonster',delay = 0, ttype = 1},
        },

        --神坛上调整2NPC和玩家站位和朝向
        {
           	{ event = 'move', delay = 0.3, entity_id = 2441, dir = 1, pos = {47,19,}, speed = 340, dur = 1, end_dir = 1},    
           	{ event = 'move', delay = 0.3, entity_id = 2442, dir = 1, pos = {49,21,}, speed = 340, dur = 1, end_dir = 1}, 
           	{ event = 'move', delay = 0.3, cast = 'player', dir = 5,pos = {50,18,}, speed = 340, dur = 1, end_dir = 5},  	
        	{ event = 'dialog',dialog_id = 127, delay = 2,},
        },

        {
            {event  = 'stopMonster',delay = 0,ttype = 0},
        },
        
        --请求通关
    	{
    		{ event = 'carnet', delay = 1,dur = 0 },
    	},
	},

  	--============================================wuwenbin  剧情副本第六章第二节  end  =====================================----


  	--============================================wuwenbin  剧情副本第六章第五节  start  =====================================----

  	['juqing651'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --进入副本后移动，后嘉嘉说话
        { 
           	{ event = 'move', delay = 0.8, entity_id = 2506, dir = 1, pos = {8,54}, speed = 340, dur = 1, end_dir = 1}, 
           	{ event = 'move', delay = 0.8, cast = 'player', dir = 1,pos = {10,52,}, speed = 340, dur = 1, end_dir = 5},
        },
        {
        	{ event = 'dialog',dialog_id = 135, delay = 0 },
        },
        --嘉嘉消失，调整宏泰和苏茉朝向
        { 
           	{ event = 'kill', delay = 0.4, entity_id = 2506, dur = 1, }, 
           	{ event = 'changeVisible', delay = 0, entity_id1 = 2501, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0, entity_id1 = 2504, cansee1 = false, dur = 0 }, 
  			{ event = 'move', delay = 0, entity_id = 2501, dir = 1, pos = {8,10}, speed = 340, dur = 2, end_dir = 3}, 
           	{ event = 'move', delay = 0, entity_id = 2504, dir = 1, pos = {17,6}, speed = 340, dur = 2, end_dir = 3}, 
        	{ event = 'createActor', delay = 1, jqid= 2,},   --刷出第一波蛟浪
        },
	},

	['juqing652'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        {
            { event  = 'stopMonster',delay = 0, ttype = 1},
        },
	    {	
	    	--主角走位
	    	{ event = 'move', delay = 0.5, cast = 'player', dir = 1,pos = {18,12,}, speed = 340, dur = 1.5, end_dir = 7},
	    	--调整首领NPC和鲛人朝向
	    	{ event = 'move', delay = 0, entity_id = 2507, dir = 1,pos = {13,8,}, speed = 340, dur = 1, end_dir = 3},
	    	{ event = 'move', delay = 0, entity_id = 2512, dir = 1,pos = {12,12,}, speed = 340, dur = 1, end_dir = 3},
	    	{ event = 'move', delay = 0, entity_id = 2513, dir = 1,pos = {14,11,}, speed = 340, dur = 1, end_dir = 3},
	    	{ event = 'move', delay = 0, entity_id = 2514, dir = 1,pos = {16,10,}, speed = 340, dur = 1, end_dir = 3},
	    	{ event = 'move', delay = 0, entity_id = 2515, dir = 1,pos = {18,9,}, speed = 340, dur = 1, end_dir = 3},
	    },
	    {
	    	{ event = 'dialog',dialog_id = 136, delay = 0.5 },	    
	    },
  		{
            {event  = 'stopMonster',delay = 0,ttype = 0},
        },
	},

	['juqing653'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

  		--调整赤羽，上官锦和安安的朝向，安安跑向首领
	    {
	    	{ event = 'move', delay = 0, entity_id = 2502, dir = 1,pos = {16,13,}, speed = 340, dur = 1, end_dir = 7},
	    	{ event = 'move', delay = 0, entity_id = 2503, dir = 1,pos = {20,11,}, speed = 340, dur = 1, end_dir = 7},
	    	{ event = 'move', delay = 0, entity_id = 2505, dir = 1,pos = {19,13,}, speed = 340, dur = 1, end_dir = 7},

	    	{ event = 'camera', delay = 0.8, dur = 0.5, sdur = 2,style = '', entity_id = 2507,}, 
	    	{ event = 'talk', delay = 1,  entity_id = 2507, isEntity = false,talk = '安安！', dur = 2 },
	    	{ event = 'talk', delay = 1,  entity_id = 2505, isEntity = false,talk = '首领！快放开他们吧', dur = 2 },
	    	{ event = 'move', delay = 1, entity_id = 2505, dir = 1,pos = {15,9,}, speed = 340, dur = 1, end_dir = 7},
	    },
	    {
	    	{ event = 'talk', delay = 0.5,  entity_id = 2516, isEntity = false,talk = '{快死了}{晕}', dur = 1.5 },
	    	{ event = 'talk', delay = 0.5,  entity_id = 2517, isEntity = false,talk = '快，先救苏茉！', dur = 1.5 },
	    	{ event = 'effect', delay = 2, entity_id = 2516, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},  --刷出苏茉采集怪箭头
	    	{ event = 'camera', delay = 2.5, dur = 0.5, sdur = 0.5,style = '', cast = 'player',},
	    },
	},

	['juqing654'] =
  	{
  		--宏泰头上刷出特效
  		{
  			{ event = 'effect', delay = 0, entity_id = 2517, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
  		},

  	  	--解救苏茉
  		{
  			{ event = 'changeVisible', delay = 0, entity_id1 = 2516, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0, entity_id1 = 2501, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2501, isEntity = false,talk = '得救了{大哭}快救宏泰', dur = 1.5 },
        	{ event = 'kill', delay = 0,entity_id = 2516, dur = 0 },
  		},
  		
	},

	['juqing655'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

  	  	--解救宏泰
  		{
  			{ event  = 'stopMonster',delay = 0, ttype = 1},  --停怪
  			{ event = 'changeVisible', delay = 0, entity_id1 = 2517, cansee1 = false, dur = 0 },
  			{ event = 'changeVisible', delay = 0, entity_id1 = 2504, cansee1 = true, dur = 0 },
  			{ event = 'talk', delay = 0, entity_id = 2504, isEntity = false,talk = '呼，终于解开了', dur = 1 },
        	{ event = 'kill', delay = 0,entity_id = 2517, dur = 0 },
  		},
        {	  
	    	{ event = 'move', delay = 0, entity_id = 2503, dir = 1,pos = {20,11}, speed = 340, dur = 1, end_dir = 6},
	    	{ event = 'move', delay = 0, entity_id = 2504, dir = 1,pos = {17,9,}, speed = 340, dur = 1, end_dir = 5},
	    	{ event = 'move', delay = 0, entity_id = 2505, dir = 1,pos = {14,8,}, speed = 340, dur = 1, end_dir = 4},
	    	{ event = 'move', delay = 0, entity_id = 2507, dir = 1,pos = {12,7,}, speed = 340, dur = 1, end_dir = 4},
	    	{ event = 'move', delay = 0, cast = 'player', dir = 1,pos = {10,9,}, speed = 340, dur = 1, end_dir = 3},
	    	--[[
        	{ event = 'effect', delay = 1, entity_id = 2501, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},	--苏茉手心火焰特效
			{ event = 'effect', delay = 1, entity_id = 2501, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},	--特效组，做出火焰的轨迹
			{ event = 'effect', delay = 1, entity_id = 2501, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
			{ event = 'effect', delay = 1, entity_id = 2501, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},
			{ event = 'effect', delay = 0.5, entity_id = 2501, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},	--火焰的柳字
			{ event = 'effect', delay = 0.5, entity_id = 2501, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true}, --烟花
        	]]
        	{ event = 'talk', delay = 0,  entity_id = 2501, isEntity = false,talk = '！！！', dur = 2 },
		},

		{	
        	{ event = 'dialog',dialog_id = 137,},
        },

        {
            {event  = 'stopMonster',delay = 0,ttype = 0},
        },
        
        --请求通关
    	{
    		{ event = 'carnet', delay = 1,dur = 0 },
    	},
	},
  	--============================================wuwenbin  剧情副本第六章第五节  end  =====================================----


  	--============================================wuwenbin  剧情副本第七章第一节  start  =====================================----

  	['juqing711'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        --进入副本后调整玩家和NPC方向
        { 
           	{ event = 'move', delay = 1, entity_id = 2526, dir = 1, pos = {12,60}, speed = 340, dur = 2, end_dir = 5}, --调整肥龙方向
           	{ event = 'move', delay = 1, entity_id = 2527, dir = 1,pos = {14,61}, speed = 340, dur = 1, end_dir = 5},	--调整阿肃方向
           	{ event = 'move', delay = 1, cast = 'player', dir = 1,pos = {11,63}, speed = 340, dur = 1, end_dir = 1},
        	--玩家和阿肃、肥龙对话
        	{ event = 'talk', delay = 1,  entity_id = 2526, isEntity = false,talk = '什么人！敢私闯我梼杌寨。', dur = 1.5 },
        	{ event = 'talk', delay = 2.3,  cast = 'player' , isEntity = false,talk = '交出苏茉和上官锦！', dur = 1.5 },
        	{ event = 'talk', delay = 3.8,  entity_id = 2526, isEntity = false,talk = '来人，把他也绑上。', dur = 1 }, 
        },
        {
        	{ event = 'kill', delay = 0,entity_id = 2526, dur = 0 },
        	{ event = 'kill', delay = 0,entity_id = 2527, dur = 0 },
        	{ event = 'createActor', delay = 0.5, jqid= 2,},
        },
	},

	['juqing712'] =
  	{
        --刷出栅栏特效
        { 
        	{ event = 'effect', delay = 0, entity_id = 2528, layer = 2, effect_id = 8,dx= 0,dy = 30,loop = true},  --刷出栅栏上标识
        },
	},


	['juqing713'] =
  	{
        --肥龙冒泡
        { 
        	{ event = 'talk', delay = 0.5,  entity_id = 2526, isEntity = false,talk = '小弟不中用，我自己来！', dur = 2 },
        },
	},

	['juqing714'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },
        {
            { event  = 'stopMonster',delay = 0, ttype = 1},
        },

        --镜头给阿肃，冒泡
        { 
           	{ event = 'camera', delay = 0, dur = 1, sdur = 2,style = '', entity_id = 2527,},  
           	{ event = 'move', delay = 0, entity_id = 2527, dir = 1,pos = {16,17}, speed = 340, dur = 1, end_dir = 3},	--调整阿肃方向
           	{ event = 'talk', delay = 1,  entity_id = 2527, isEntity = false,talk = '竟敢私闯我梼杌寨，看刀！', dur = 2 },
           	{ event = 'playAction', entity_id= 2527, delay = 1, action_id = 2, dur = 1.5, dir = 3,loop = false },
        },
        {
            { event  = 'stopMonster',delay = 0, ttype = 0},
        },

	},

	['juqing715'] =
  	{
  		--动画组
        {   
           { event = 'hideAvatars' , delay = 0 },   -- 动画片段
           { event = 'hideUI' , delay = 0 },    -- 动画片段
           { event = 'disableSceneClicks' },    -- 动画片段
        },

        {
            { event  = 'stopMonster',delay = 0, ttype = 1},
            { event = 'createActor', delay = 0.5, jqid = 13,}, --为配合剧情通关而设
            { event = 'talk', delay = 0.5,  entity_id = 2527, isEntity = false,talk = '剧情还要改，暂时先这么配着吧！', dur = 3 },
        },

        --[[进入副本后调整玩家和NPC方向
        { 
           	{ event = 'move', delay = 0.1, entity_id = 2527, dir = 1, pos = {19,20}, speed = 230, dur = 2, end_dir = 3}, --调整肥龙方向
           	{ event = 'talk', delay = 0.1,  entity_id = 2527, isEntity = false,talk = '哼，打得不错嘛', dur = 1 },
           	{ event = 'move', delay = 0.1, cast = 'player', dir = 1,pos = {25,23}, speed = 230, dur = 2, end_dir = 7},
        },
        --玩家和阿肃、肥龙对话
        { 
        	--阿肃攻击动作，投掷粉末   
           { event = 'move', delay = 0.1, entity_id = 2527, dir = 1, pos = {19,20}, speed = 340, dur = 2, end_dir = 3},
	       { event = 'move', delay = 0.1, cast = 'player', dir = 1,pos = {25,23}, speed = 340, dur = 2, end_dir = 7},

	       { event = 'createActor', delay = 0, jqid= 13,},
	       { event = 'move', delay = 0.1, entity_id = 2521, dir = 1, pos = {23,22}, speed = 260, dur = 2, end_dir = 7},

	       { event = 'talk', delay = 0.1,  entity_id = 2527, isEntity = false,talk = '尝尝这个', dur = 2 },
	       { event = 'talk', delay = 0.2,  entity_id = 2521, isEntity = false,talk = '小心！', dur = 2 },
	       { event = 'playAction', entity_id= 2527, delay = 0.5, action_id = 2, dur = 1.5, dir = 3,loop = false },

	       --粉尘特效
           { event = 'moveEffect', delay = 0.7, effect_id = 20002, pos1 = {19,20},pos2 = {21,20},pos3 ={23,22},dur = 1,m_dur = 0.2 },	
           { event = 'removeEffect', delay = 0.9,  pos = {19,20},},

           --赤羽晕倒
           { event = 'talk', delay = 1.2, entity_id=2521, isEntity = false,talk = '{眩晕}', dur = 1.5},          	
   	       { event = 'effect', delay = 1.2, entity_id = 2521, layer = 2, effect_id = 10131,dx=0,dy=30,is_forever = true},
   	       { event = 'removeEffect', delay = 2.2,  entity_id = 2521,effect_id = 10131, }, 

   	       { event = 'playAction', delay = 2.4,entity_id = 2521, action_id = 4, dur = 1, dir = 5,loop = false },  

   	       --玩家冒泡
   	       { event = 'talk', delay = 3,  cast = 'player' , isEntity = false,talk = '卑鄙！', dur = 1.5 },
        },--]]

        --请求通关
    	{
    		{ event = 'carnet', delay = 1,dur = 0 },
    	},

	},

  	--============================================wuwenbin  剧情副本第七章第一节  end  =====================================----
}