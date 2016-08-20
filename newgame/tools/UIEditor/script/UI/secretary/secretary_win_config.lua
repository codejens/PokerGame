-- 小秘书系统，图片资源、坐标等，静态配置

secretary_win_config = {
    win = {                       -- 窗口
        
    },

    -- 游戏秘书
	secretaryPage = {
        bg1              = { img = UIPIC_Secretary_009, x = 12, y = 12, w = 754, h = 550  },      -- 背景
    },


    -- 版本公告
    -- noticePage = {
    --     bg1              = { img = UIResourcePath.FileLocate.common .. "nine_grid_bg.png", x = 21, y = 22, w = 722, h = 335  },      -- 背景
    --     page_title       = { x = 100, y = 275, w = -1, h = -1, img = UIResourcePath.FileLocate.secretary .. "gengxinneirong.png"  },   -- 右边区域标题
    --     title_1          = { w = -1, h = -1, img = UIResourcePath.FileLocate.secretary .. "titel_1.png"  },   -- 右边区域标题
    --     title_2          = { w = -1, h = -1, img = UIResourcePath.FileLocate.secretary .. "title_2.png"  },   -- 右边区域标题
    --     title_3          = { w = -1, h = -1, img = UIResourcePath.FileLocate.secretary .. "title_3.png"  },   -- 右边区域标题

    --     content_begin_x = 5,        -- 内容开始的坐标
    --     content_begin_y = 305,
    --     title_interval_y = 30,      -- 标题的换行间距
    --     word_interval = 20,   -- 文字的换行间距
    --     font_size = 16 ,            -- 文字大小



    --     add_content      = {        -- 新增的内容，就被遍历按配置坐标显示
    --         "1.新增美女小助手.签到系统.投资理财", 
    --         "2.新增天气系统.粒子特效" ,
    --         "3.新增手指上滑骑乘.手指下滑打坐功能"
    --     },
    --     optimize_content = {        -- 优化的内容，就被遍历按配置坐标显示
    --         "1.优化滑动控件.增加可滑动条",
    --         "2.优化扩大\"接受/完成任务.立即穿戴\"按钮的点击范围",
    --         "3.优化自动拾取范围扩大到玩家的可视范围"
    --     },
    --     motify_content   = {        -- 修正的内容，就被遍历按配置坐标显示
    --         "1.修正挂机设置，设置后无法自动吃药",
    --         "2.修正打坐无法双修的问题"
    --     },
    -- },


    -- 客服信息
    customServicePage = {
        bg1              = { img = UIPIC_Secretary_009, x = 12, y = 12, w = 754, h = 346  },      -- 背景
        title_1          = { x = 21, y = 300, size = 20, words = " " },
        call_content     = {
            { x = 21, y = 300, size = 16, words = LangGameString[1862] }, -- [1862]="#c38ff33官方交流1群：      #cffffff2995192452"
            { x = 21, y = 270, size = 16, words = LangGameString[1863] }, -- [1863]="#c38ff33官方交流2群：      #cffffff2995192452"
            { x = 21, y = 240, size = 16, words = LangGameString[1864] }, -- [1864]="#c38ff33客服电话:     #cffffff0799-2191291"
            { x = 21, y = 210, size = 16, words = LangGameString[1865] }, -- [1865]="#c38ff33客服qq：  #cffffff2995192452"
            { x = 21, y = 180, size = 16, words = LangGameString[1866] }, -- [1866]="#c38ff33官网：  #cffffffzxsj.qq.com"
            { x = 21, y = 150, size = 16, words = LangGameString[1867] }, -- [1867]="#c38ff33论坛：  #cffffffhttp://sy.gamebbs.qq.com/forum.php?mod=forumdisplay&fid=185 "
        }
    },
}

