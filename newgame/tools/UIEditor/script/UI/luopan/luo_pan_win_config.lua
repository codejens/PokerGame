-- luo_pan_win_config  by lyl
-- 罗盘窗口，显示配置

local _SCROLL_ROW_H = 30    -- 行高

luo_pan_win_config = {
	window_config = {
        -- 台头 背景
        -- win_title_bg = { x = 280, y = 388, w = -1, h = -1, img = UIResourcePath.FileLocate.common .. "win_title1.png" },
        -- 台头 文字
        -- win_title = { x = 334, y = 395, w = -1, h = -1, img = UIResourcePath.FileLocate.luopan .. "huangjingluopan.png" },
        -- 大背景
        big_bg = {x = 10, y = 10, w = 880, h = 560, img = UILH_COMMON.normal_bg_v2},
        -- 信息区域背景
        info_area_bg1 = { x = 583, y = 339, w = 290, h = 215, img = UILH_COMMON.bottom_bg },
        -- 信息区域背景
        info_area_bg2 = { x = 583, y = 114, w = 290, h = 215, img = UILH_COMMON.bottom_bg },
        -- 美女图片
        girl_img = {x = -135, y = -15, w = -1, h = -1, img = "nopack/girl.png"},


        -- 获得者标题
        -- player_scroll_title = { x = 455, y = 360, w = -1, h = -1, img = UIResourcePath.FileLocate.luopan .. "huodezhe.png"},
        -- 滑动中的行的父节点    高度要通过 行的数量*行高 来计算
        scroll_row_height = _SCROLL_ROW_H,
        -- 整个滑动scroll 控件
        award_scroll = { id = "award_scroll", x = 590, y = 343, w = 280, h = 170, max_num = 10, img = "", scroll_type = TYPE_HORIZONTAL },
        -- 玩家抽奖记录的整个滑动scroll 控件
        my_award_scroll = { id = "my_award_scroll", x = 590, y = 118, w = 280, h = 170, max_num = 10, img = "", scroll_type = TYPE_HORIZONTAL },
        -- 滑动的只是条
        -- scroll_bar = { bar_img = UIResourcePath.FileLocate.common .. "common_progress.png", bar_w = 10, bar_h = 20, item_size = _SCROLL_ROW_H   },
        -- scroll只有一项，所有行放在这里
        scroll_bg    = { id = "scroll_bg", x = 0, y = 0, w = 525, h = 1, img = "" },
        -- 一行的背景
        row_bg    = { id = "row_bg", x = 0, w = 525, h = _SCROLL_ROW_H, img = "" },
        -- 玩家名称
        row_player_name = { words = "", x = 15, y = 7, size = 16, align = ALIGN_LEFT },
        -- 得到道具名称
        item_name = { words = "", x = 130, y = 7, size = 16, align = ALIGN_LEFT },
        -- 行 最上面的 边界
        -- split_line_top = { x = 448, y = 325, w = 307, h = 35, img = UIResourcePath.FileLocate.common .. "coner1.png" },
        -- 行的分割线
        split_line = { x = 0, y = 0, w = 280, h = -1, img = UILH_COMMON.split_line },


        -- 活动说明标题
        -- explain_title = { x = 455, y = 180, w = -1, h = -1, img = UIResourcePath.FileLocate.luopan .. "huodongshuoming.png" },
        -- 说明内容	
        -- explain_content_1 = { words = "每天登陆可免费领取一个幸运结晶;", x = 220, y = 158-40, size = 16, align = ALIGN_LEFT },
        explain_content_2 = { words = "#cfff000活动说明：#cffffff每次抽奖花费20元宝，", x = 240, y = 133-40, size = 16, align = ALIGN_LEFT },
        explain_content_3 = { words = "每天可以免费抽奖一次。", x = 240, y = 108-40, size = 16, align = ALIGN_LEFT },
        activity_time_title_label = {words = "#cfff000活动剩余时间:", x = 240, y = 43, size = 16, align = ALIGN_LEFT },
        activity_time_label = {x = 240+135, y = 43, size = 16, align = ALIGN_LEFT },
        -- explain_content_4 = { words = "抽奖优先使用幸运结晶。", x = 220, y = 83-40, size = 16, align = ALIGN_LEFT },
        -- 月饼数量
        moon_cake_num_title = { words = "#cffff00免费次数:", x = 585, y = 73, size = 16, align = ALIGN_LEFT },
        moon_cake_num = { words = "#c66ff660", x = 675, y = 73, size = 16, align = ALIGN_LEFT },
        -- 元宝数量
        yuanbao_title = { words = "#cffff00背包元宝:", x = 585, y = 48, size = 16, align = ALIGN_LEFT },
        yuanbao = { words = "#c66ff6612", x = 675, y = 48, size = 16, align = ALIGN_LEFT },
        -- 需要元宝数
        -- need_yuanbao = { words = "#cfff00020元宝/次", x = 360, y = 28, size = 16, align = ALIGN_LEFT },
        -- 充值 按钮
        -- recharge_but = { x = 620, y = 25, w = -1, h = -1, img_n = UIResourcePath.FileLocate.other .. "vip_btn_n.png", img_s = UIResourcePath.FileLocate.other .. "vip_btn_s.png"},
    },
    luopan_page = {
        -- 罗盘区域背景
        luopan_area_bg = { x = 200, y = 25, w = 380, h = 530, img = UILH_COMMON.bottom_bg },
        -- 罗盘最后面背景
        luopan_bg_1 = { x = 3, y = 152, w = -1, h = -1, img = UILH_LUOPAN.luopan_bg },
        -- 罗盘第二背景
        -- luopan_bg_2 = { x = 20, y = -5, w = -1, h = -1, img = UIResourcePath.FileLocate.luopan .. "luopan_fg.png" },
        -- 选中背景 
        selected_bg = { x = 60, y = 471, w = 67, h = 67, img = UILH_NORMAL.light_grid, angle = 210 - 1 },
        -- 罗盘指针
        luopan_zhizhen = { x = 188, y = 268+137/2, w = -1, h = -1, img = UILH_LUOPAN.luopan_zhizhen, start_angle = 0 },
        -- 开始抽奖按钮
        begin_but = { x = 123, y = 268, w = -1, h = -1, img_n = UILH_LUOPAN.kaishichoujiang_bg, img_s = UILH_LUOPAN.kaishichoujiang_bg},
        -- 抽奖按钮上的文字图片
        begin_img = { x = 137/2-108/2-2, y = 137/2-34/2+2, w = -1, h = -1, img = UILH_LUOPAN.dianjichoujiang},
        -- begin_but = { x = 0, y = 0, w = -1, h = -1, img_n = UIResourcePath.FileLocate.luopan .. "kaishichoujiang_but.png", img_s = UIResourcePath.FileLocate.luopan .. "kaishichoujiang_but.png"},
        -- begin_but = { x = 144, y = 120, w = -1, h = -1, img_n = "", img_s = ""},


        -- 道具的坐标
        item_pos_t = {
            { x = 66-30, y = 213+140 },
            { x = 102-30, y = 277+140 },
            { x = 164-30, y = 314+140 },
            { x = 238-30, y = 312+140 },
            { x = 300-30, y = 276+140 },
            { x = 337-30, y = 214+140 },
            { x = 337-30, y = 142+140 },
            { x = 301-30, y = 78+140 },
            { x = 238-30, y = 42+140 },
            { x = 165-30, y = 42+140 },
            { x = 103-30, y = 79+140 },
            { x = 65-30, y = 142+140 },
        },
        -- 创建道具的参数， 位置根据 item_pos_t 获取
        slot_item = { x = 1, y = 1, w = 42, h = 42 },
    }
}