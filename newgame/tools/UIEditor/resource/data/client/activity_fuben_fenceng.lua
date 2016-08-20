--天降的分层副本配置   之后废用删除  added by xiehande 2016-1-25
activity_fuben_fenceng ={
-- 破狱之战 
[107] = {
	    id = 107,--服务端响应编号，活动1-100，副本101-200，BOSS201-
	    -- 副本id 
	    FBID = 58, 
	    -- -- 描述
	    -- desc = "外族倾巢来犯，雁门关危在旦夕。这是血与火的考验，勇气和意志的较量，让我们仗剑执刀，浴血而战，与外族一决高下吧！", 
	    -- -- 建议等级
	    -- level = 38,
     --  -- 副本提示图片
     --    sceneImg="fuben_105",
     --  --读取图片路径
     --    scenelocation="nopack/MiniMap/xmhj.jpg",
     --  --图片宽高
     --    high="350",
     --    weight="228",
	    -- -- 前往挑战location
	    -- location = 
	    -- {
	    --   entityName = "心魔幻境",
	    --   sceneid = 3,
	    -- },
	    -- -- 活动评价
     --        -- 1:经验、2:灵气、3:历练、4:铜钱、5:装备、6:道具、7:银两
     --        stars = {
     --          {1,4},{5,5},
     --        },
      --活动的奖励，奖励的类型上面的类型,id，如果是物品或者称号的话就id,否则填0，数量表示数量，其他的bind,strong,quality都是物品用的
  --     awards=
  --     {   --为避免以后不同层奖励不同，每层都单独配置
  --       --{type = 2, id = 0, count = 100000,  bind = true, job = -1, sex = -1, group=0},
		-- {type = 0, id = 18810, count = 1,  bind = true, job = -1, group=0},
		-- {type = 0, id = 3121, count = 1,  bind = true, job = 1, sex = -1, group=0},
	 --    {type = 0, id = 3221, count = 1,  bind = true, job = 2, sex = -1, group=0},	
  --       {type = 0, id = 3321, count = 1,  bind = true, job = 3, sex = -1, group=0},
		-- {type = 0, id = 3421, count = 1,  bind = true, job = 4, sex = -1, group=0},
		-- {type = 0, id = 2121, count = 1,  bind = true, job = 1, sex = -1, group=0},
	 --    {type = 0, id = 2221, count = 1,  bind = true, job = 2, sex = -1, group=0},	
  --       {type = 0, id = 2321, count = 1,  bind = true, job = 3, sex = -1, group=0},
  --     }, 

    FBFCID = {
       58,
       98, 
       99, 
       100,
       101,
       102
	},

	max_can = { 3,6, 10, 13,16,19},

    }, 

	
--皇陵秘境
[105] = {
	    id = 105,--服务端响应编号，活动1-100，副本101-200，BOSS201-
	    -- 副本id 
	    FBID = 65, 
	    -- 描述
	--     desc = "传说秦始皇为防盗墓，布下七十二疑冢，皇陵秘境便是其中之一，其中珍宝无数，只等君前来获取。", 
	--     -- 建议等级
	--     level = 34,
 --      -- 副本提示图片
 --        sceneImg="fuben_108",
 --      --读取图片路径
 --        scenelocation="nopack/MiniMap/htmj.jpg",
 --      --图片宽高
 --        high="350",
 --        weight="170",
	--     -- 前往挑战location
	--     location = 
	--     {
	--       entityName = "皇陵秘境",
	--       sceneid = 3,
	--     },
	--     -- 活动评价
 --            -- 1:经验、2:灵气、3:历练、4:铜钱、5:装备、6:道具、7:银两
 --            stars = {
 --              {1,4},{5,5},
 --            },
 --      --活动的奖励，奖励的类型上面的类型,id，如果是物品或者称号的话就id,否则填0，数量表示数量，其他的bind,strong,quality都是物品用的
	-- awards = { 
	-- 	  [1] = {    type = 0,    count = 1,    sex = -1,    id = 48279,    group = 0,    bind = true,    job = -1,    }
	-- ,   [2] = {    type = 0,    count = 1,    sex = -1,    id = 48280,    group = 0,    bind = true,    job = -1,    }
	-- ,   [3] = {    type = 0,    count = 1,    sex = -1,    id = 48281,    group = 0,    bind = true,    job = -1,    }
	-- ,   [4] = {    type = 0,    count = 1,    sex = -1,    id = 48282,    group = 0,    bind = true,    job = -1,    }
	-- ,   },

    FBFCID = {
       65,
       84, 
       85, 
       86,
       87,
       88
	},

	max_can = { 3,6, 9, 12,15,18},
	
    }, 



 --天魔塔
[110] = {
	    id = 110,--服务端响应编号，活动1-100，副本101-200，BOSS201-
	    -- 副本id 
	    FBID = 64, 
	    -- 描述
	--     desc = "【泉亲到时候改】", 
	--     -- 建议等级
	--     level = 42,
 --      -- 副本提示图片
 --        sceneImg="fuben_107",
 --      --读取图片路径
 --        scenelocation="nopack/MiniMap/tmt.jpg",
 --      --图片宽高
 --        high="350",
 --        weight="170",
	--     -- 前往挑战location
	--     location = 
	--     {
	--       entityName = "天魔塔",
	--       sceneid = 3,
	--     },
	--     -- 活动评价
 --            -- 1:经验、2:灵气、3:历练、4:铜钱、5:装备、6:道具、7:银两
 --            stars = {   [1] = {    [1] = 1,    [2] = 5, }
	-- 		,   [2] = {    [1] = 6,    [2] = 3, }
	-- 		,   },
 --      --活动的奖励，奖励的类型上面的类型,id，如果是物品或者称号的话就id,否则填0，数量表示数量，其他的bind,strong,quality都是物品用的
	-- awards = {   [1] = {    type = 0,    count = 1,    sex = -1,    id = 18811,    group = 0,    bind = true,    job = -1,    }
	-- ,   },

    FBFCID = {
      64,114,115,116,117
      --被屏蔽 策划说只有五层
      --,118
	},

	max_can = { 4,8, 12, 16,20
	--,23
	},
	
    }, 

	
}
 