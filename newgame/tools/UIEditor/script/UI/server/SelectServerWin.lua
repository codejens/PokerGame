-- -- SelectServerWin.lua
-- -- created by lyl on 2013-2-26
-- -- 服务器选择窗口  select_server

-- require "UI/component/Window"
-- super_class.SelectServerWin(Window)



-- -- 初始化
-- function SelectServerWin:__init( window_name, textrue_name )
--     -- 背景1
--     local bg_1 = CCZXImage:imageWithFile( 0, 0, 800, 480, "ui/login/loginbg_2.png", 500, 500 )
--     self.view:addChild( bg_1 )

--     -- 返回登录
--     local function left_bottom_but_CB(  )
--         print("选择服务器")
--     end
--     local left_bottom_but = UIButton:create_button_with_name( 65, 30, 66, 66, "ui2/login/back_but.png", "", nil, "", left_bottom_but_CB )
--     UIButton:set_button_image_name( left_bottom_but, 10, -15, 48, 28, "ui/login/zhuce.png"  )
--     self.view:addChild( left_bottom_but )

--     -- 开始游戏
--     local function right_bottom_CB(  )
--         print( "开始游戏" )
--     end
--     local right_bottom_but = UIButton:create_button_with_name( 665, 30, 66, 66, "ui2/login/enter_but.png", "", nil, "", right_bottom_CB )
--     UIButton:set_button_image_name( right_bottom_but, 10, -15, 48, 28, "ui/login/denglu.png"  )
--     self.view:addChild( right_bottom_but )
-- end