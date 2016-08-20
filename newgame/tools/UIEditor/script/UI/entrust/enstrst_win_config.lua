-- 委托系统，图片资源、坐标等，静态配置
local dis_x = 165
local dis_y = 35
entrust_win_config = {
	page1 = {
        bg1              = { window_name ="EntrustPage" ,img = UILH_COMMON.bg_02,grid=true, x = 10, y = 10, w = 860, h = 520  },      -- 背景
        frame_bg_1       = { x = 2 , y = 296 + dis_y, w = 555, h = 35, img = UIResourcePath.FileLocate.common .. "coner1.png"  },             -- 亮背景上面的线
        frame_bg_2       = { x = 2 , y = 256 + dis_y, w = 500, h = 75, img = UIResourcePath.FileLocate.common .. "ng_gradient.png"  },        -- 亮背景
        frame_bg_3       = { x = 2 , y = 160, w = 588, h = 1, img = UIResourcePath.FileLocate.common .. "fenge_bg.png"  },           -- 亮背景下面的线
        frame_bg_4       = { x = 2 , y = 115, w = 555, h = 35, img = UIResourcePath.FileLocate.common .. "coner1.png"  },             -- 下面区域分割
        -- frame_bg_5       = { x = 10 , y = 11, w = 350, h = 136, img = UIResourcePath.FileLocate.common .. "nine_grid_bg.png"  },      -- 下面区域信息显示背景
        frame_bg_6       = { x = 502 , y = 296, w = 206, h = 35, img = UIResourcePath.FileLocate.common .. "coner1.png"  },            -- 右边区域边
        frame_bg_7       = { x = 502 , y = 296, w = 206, h = 1, img = UIResourcePath.FileLocate.common .. "fenge_bg.png"  },            -- 右边标题下面的线
        right_title_1_bg = { x = 500 , y = 300, w = -1, h = -1, img = UIResourcePath.FileLocate.weiTuo .. "weituocangku.png"  },   -- 右边区域标题

        need_level_title = { x = 15 , y = 295 + dis_y, size = 16},          -- 需要等级
        need_level       = { x = 100 , y = 295 + dis_y, size = 16},         -- 
        need_time_title  = { x = 280 , y = 295 + dis_y, size = 16},          -- 需要时间
        need_time        = { x = 370, y = 295 + dis_y, size = 16},         -- 
        get_exp_title    = { x = 15 , y = 265 + dis_y, size = 16},         -- 获得经验  获得历练  获得仙币
        get_exp          = { x = 100 , y = 265 + dis_y, size = 16},         -- 
        get_yingliang_title={ x = 280 , y = 265 + dis_y, size = 16},        -- 获得银两
        get_yingliang    = { x = 370 , y = 265 + dis_y, size = 16},         -- 
        entrust_count_title = { x = 15 , y = 230 + dis_y, size = 16},       -- 委托次数
        entrust_level_title = { x = 15 , y = 205 + dis_y, size = 16},       -- 委托层数
        can_entrust_num  = { x = 105 , y = 205 + dis_y, size = 16},         -- 可委托层数
        yuanbao_notice   = { x = 285-113 , y = 166-22 + dis_y, size = 14},         -- 元宝委托提示
        remain_time_title= { x = 375 , y = 120, size = 14},         -- 剩余时间
        remain_time      = { x = 445 , y = 120, size = 14},         -- 
        right_title_1    = { x = 520 , y = 307, size = 16},         -- 右侧标题
        get_but_notice_1 = { x = 400 , y = 15, size = 12},          -- 委托前须清理仓库
        entrust_result     = { x = 15 , y = 165, size = 16},          -- 委托结果显示

        entrusting_dialog= { x = 20 , y = 24, w = 315, h = 100 },

        times_select_but  = { begin_x = 110 , begin_y = 228 + dis_y, interval = 95, normal_image = UIResourcePath.FileLocate.common .. "common_toggle_n.png", select_image = UIResourcePath.FileLocate.common .. "common_toggle_s.png", but_area_w = 60, but_area_h = 20 },
        mystical_shop_but = { x = 375+80 , y = 200 + dis_y, w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button4.png", select_image = UIResourcePath.FileLocate.common .. "button4.png" },
        xianbi_but        = { x = 15 , y = 162 + dis_y, w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button4.png", select_image = UIResourcePath.FileLocate.common .. "button4.png" },
        yuanbao_but       = { x = 180 , y = 162 + dis_y, w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button4.png", select_image = UIResourcePath.FileLocate.common .. "button4.png" },
        add_times_but     = { x = 345 , y = 162+dis_y,   w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button4.png", select_image = UIResourcePath.FileLocate.common .. "button4.png" },
        complete_but      = { x = 400 , y = 60 + 25, w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button4.png", select_image = UIResourcePath.FileLocate.common .. "button4.png" },
        get_exp_but       = { x = 400 , y = 10 + 25, w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button4.png", select_image = UIResourcePath.FileLocate.common .. "button4.png" },
        get_item_but      = { x = 505 , y = 10, w = -1, h = -1, normal_image = UIResourcePath.FileLocate.common .. "button2.png", select_image = UIResourcePath.FileLocate.common .. "button2.png" },

        slotItem_area     = { begin_x = 20 , begin_y = 24 + 60, interval_x = 70, interval_y = 62, column_num = 15, rows_num = 2  }
    }
}

