-- 小秘书系统，公告页， 图片资源、坐标等，静态配置 lyl


-- 版本公告
    secretary_noticePage_config = {
        bg1              = { img = UIPIC_Secretary_009, x = 12, y = 12, w = 754, h = 346  },      -- 背景
        page_title       = { x = 100, y = 275, w = -1, h = -1, img = UIResourcePath.FileLocate.secretary .. "gengxinneirong.png"  },   -- 右边区域标题
        title_1          = { w = -1, h = -1, img = UILH_SECRETARY.text1  },   -- 右边区域标题
        title_2          = { w = -1, h = -1, img = UILH_SECRETARY.text2  },   -- 右边区域标题

        content_begin_x = 20,        -- 内容开始的坐标
        content_begin_y = 410,
        title_interval_y = 30,      -- 标题的换行间距
        word_interval = 20,   -- 文字的换行间距
        font_size = 16 ,            -- 文字大小



        -- add_content      = {        -- 新增的内容，就被遍历按配置坐标显示
        --     "1、新增世界时间",
        --     "2、商城热销区新增每日限购宝箱",
        --     "3、商城热销区新增神秘钥匙道具",
        --     "4、诛仙阵掉落修改为神秘百宝箱",
        -- },
        -- optimize_content = {        -- 优化的内容，就被遍历按配置坐标显示
        --     "1、仙宗贡献显示成员的累积贡献",
        --     "2、法宝改为角色达到43级直接开启",
        --     "3、跑环任务50级前取消天劫石任务",
        --     "4、新版UI，可以伸缩隐藏功能面板",
        -- },
        -- motify_content   = {        -- 修正的内容，就被遍历按配置坐标显示

        -- },
    }
