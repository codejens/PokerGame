-- 活动礼包，图片资源、坐标等，静态配置
code_gift_win_config = {
	page1 = {
        bg1 = { img = UIResourcePath.FileLocate.other .. "code.png", x = 220, y = 120, w = -1, h = -1 },

        enter_title = { words = "#cffff00请输入激活码:", x = 215 - 95 , y = 43 , size = 20, layout = ALIGN_LEFT },          -- 提示语

        enter_frame_bg = { x = 345 - 75 , y = 35, w = 220, h = 40, img = UIPIC_GRID_nine_grid_bg3  },   -- 右边区域标题

        enter_frame = { x = 355 - 75 , y = 35 , w = 200, h = 40, bg = "",  max_num = 20, size = 16, enter_type = EDITBOX_TYPE_NORMAL },          -- 输入框

        get_but = { x = 570 - 75 , y = 35 , image_path = UIResourcePath.FileLocate.common .. "button2_red.png", 
                    word_x = 15, word_y = 8, word_image_path = UIResourcePath.FileLocate.normal .. "get.png"  },          -- 领取按钮

    }
}