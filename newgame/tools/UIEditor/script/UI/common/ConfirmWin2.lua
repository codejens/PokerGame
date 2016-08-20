-- ConfirmWin2.lua
-- created by lyl on 2013-5-13
-- 确认窗口

-- 使用方法：静态调用 ConfirmWin2:show( win_type, but_name_index, notice_content,  x, y, swith_but_func, yes_but_func )

-- ************************ 增加提示窗口类型 步骤******************************
-- 1、_title_name_image_t  加入想要的表头名称的图片路径， 并配置相对表头背景的坐标, 修改 create_title
-- 2、如果显示内容有特殊需求（例如显示图片）， 修改 create_content 方法
-- 3、 create_switch_but 方法，控制 勾选项的显示
-- 4、_button_name_image_t 加入确定按钮的名称， 如果对按钮有特殊需求，修改create_apply_but方法

super_class.ConfirmWin2(  )

-- 标头 图片配置： 图片路径， 相对于标头背景的坐标
local _title_name_image_t = {
    [1] = { path =  UILH_NORMAL.title_tips, x = 34, y = 0 },        -- "提示"
    [2] = { path =  UILH_NORMAL.title_tips, x = 34, y = 0 },  -- 材料获得
    [3] = { path =  UILH_NORMAL.title_tips, x = 34, y = 0},  -- 家族邀请
}


--已没有使用 取而代之的是文字按钮
---------------------------------------------------------------------------------------------------------------------------------------------
local _button_name_image_t = {                              -- 确定按钮名称图片，相对背景的坐标, but_type: 2：两个字的按钮用不同的背景，默认四字
    [0] = { path = UIResourcePath.FileLocate.normal .. "queding.png", x = 35.5, y = 11, but_type = 2 },
    [1] = { path = UIResourcePath.FileLocate.other .. "lijiqianwang.png", x = 12, y =  10 },          -- 立即前往
    [2] = { path = UIResourcePath.FileLocate.other .. "kuaisuchongzhi.png", x = 12, y =  10 },          -- 快速充值
    [3] = { path = UIResourcePath.FileLocate.other .. "t_cwxz.png", x = 12, y =  10 },          -- 成为VIP 
    [4] = { path = UIResourcePath.FileLocate.other .. "dakaishangdian.png", x = 12, y =  10 },          -- 打开商店
    [5] = { path = UIResourcePath.FileLocate.other .. "lijichuansong.png", x = 12, y =  10 },          -- 立即传送
    [6] = { path = UIResourcePath.FileLocate.ph .. "t_dsz.png", x = 12, y =  10 },          -- 丢骰子
    [7] = { path = UIResourcePath.FileLocate.other .. "dialog_t_5.png", x = 12, y =  10 },          -- 立即购买
}
---------------------------------------------------------------------------------------------------------------------------------------------


local _button_name_t = {  -- 确定按钮名称，相对背景的坐标, but_type: 2：两个字的按钮用不同的背景，默认四字
    [0] = { name = Lang.common.confirm[0], x = 35.5, y = 11, but_type = 2 }, --确定
    [1] = { name = Lang.common.confirm[1], x = 12, y =  10 },          -- 立即前往
    [2] = { name = Lang.common.confirm[2], x = 12, y =  10 },          -- 快速充值
    [3] = { name = Lang.common.confirm[3], x = 12, y =  10 },          -- 成为VIP 
    [4] = { name = Lang.common.confirm[4], x = 12, y =  10 },          -- 打开商店
    [5] = { name = Lang.common.confirm[5], x = 12, y =  10 },          -- 立即传送
    [6] = { name = Lang.common.confirm[6], x = 12, y =  10 },            -- 丢骰子
    [7] = { name = Lang.common.confirm[7], x = 12, y =  10 },          -- 立即购买
    [8] = { name = Lang.common.confirm[8], x = 12, y = 10 },               --前往
    [9] = { name = Lang.common.confirm[9], x = 12, y = 10, but_type = 2 }, -- 取消
    [10] = {name = Lang.common.confirm[10], x = 12, y = 10},                --同意
    [11] = {name = Lang.common.confirm[11], x = 12, y = 10},                --拒绝
    [12] = {name = Lang.common.confirm[14], x = 12, y = 10,but_type = 4},  --再来一次 
    [13] = {name = Lang.common.confirm[15], x = 12, y = 10,but_type = 4},     --获得铜币  
    [14] = {name = Lang.common.confirm[16], x = 12, y = 10,but_type = 4},      --获取经验
    [15] = {name = Lang.common.confirm[17], x = 12, y = 10,but_type = 4},      --获取银两
}

-- local _win_width  = 416
-- -- local _win_height = 331
-- local _win_height = 331
local _win_width  = 440
-- -- local _win_height = 331
 local _win_height =300

-- win_type：窗口类型  1： 内容按传入文字 | 带勾选："不再提示" 的开关 
--                     2:  充值提示专用， 文字用图片显示
--                     3:  纯文字提示， 只有一个按钮,  默认为 “确定”， 根据 but_name_index
--                     4:  确认框，有文字提示和 “确定”、“取消”  按钮
--                     5:  有文字提示和 “确定”、“取消”  按钮 和 勾选
--                     9:  确定   再来一次
-- 按钮名称的序号, 在 _button_name_image_t 中配置
-- notice_content: 提示文字内容
-- x, y:  坐标
-- swith_but_func: 开关按钮改变时回调.  
-- yes_but_func:   确认按钮回调 函数
-- title_type:  标题类型， _title_name_image_t 中配置， 如果为nil， 则为 “提示”
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
function ConfirmWin2:__init( win_type, but_name_index, notice_content,  x, y, yes_but_func, swith_but_func, title_type, panel_tip )
    self.win_type = win_type
    self.but_name_index = but_name_index
    self.notice_content = notice_content or ""
    self.x = x
    self.y = y
    self.swith_but_func = swith_but_func
    self.yes_but_func = yes_but_func
    self.title_type = title_type
    self.yes_but_func_2 = nil    -- 有两个按钮的特殊类型，这时要调用 set_yes_but_func_2 方法类设置第二个按钮的回调
    self.panel_tip = panel_tip

    -- 窗口背景
    self.view = CCBasePanel:panelWithFile( _refWidth(0.5), _refHeight(0.5), _win_width, _win_height, UILH_COMMON.dialog_bg, 500, 500 )
    self.view:setAnchorPoint(0.5,0.5)
    --第二层背景
    self.view:addChild( CCZXImage:imageWithFile( _win_width/2 - 410/2, 85-8, 410, 180, UILH_COMMON.bottom_bg, 500, 500 ) )

    -- 标头
    self:create_title(  )

    -- 提示内容
    self:create_content()

    -- 勾选
    self:create_switch_but(  )

    -- 功能按钮
    self:create_apply_but(  )

    -- 关闭按钮
    local function close_but_CB( )
    	self:close_win(  )
    	-- self:do_swith_but_func(  )
    end

    self.close_but = UIButton:create_button_with_name( 0, 0, -1, -1,UIPIC_COMMOM_008, UIPIC_COMMOM_008, nil, "", close_but_CB ,999)
    local close_but_size = self.close_but.view:getSize()
    local self_size = self.view:getSize()
    self.close_but.view:setPosition( self_size.width - close_but_size.width-5, self_size.height -close_but_size.height+20)
    self.view:addChild( self.close_but.view )
    -- 设置不可击穿
    self.view:setDefaultMessageReturn(true)
end

-- 创建标头
function ConfirmWin2:create_title(  )

        --标题背景
        local title_bg = CCBasePanel:panelWithFile( 0, 0, -1, 60, UIPIC_COMMOM_title_bg )
        local title_bg_size = title_bg:getSize()
        title_bg:setPosition( ( self.view:getSize().width - title_bg_size.width ) / 2, self.view:getSize().height - title_bg_size.height/2-14)

        local title_info = nil
        if self.title_type and _title_name_image_t[ self.title_type ] then
            title_info = _title_name_image_t[ self.title_type ]
        else
            title_info = _title_name_image_t[ 1 ]
        end

       local title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1, title_info.path  )
       title:setAnchorPoint(0.5,0.5)

      title_bg:addChild( title )

    self.view:addChild( title_bg )

end

-- 显示内容
function ConfirmWin2:create_content(  )
    if self.win_type == 2 then                  -- 充值提示特殊需求，用图片显示文字
        -- self.notice_dialog = CCDialogEx:dialogWithFile( 40, 250, 340, 150, 50, nil, 1 ,ADD_LIST_DIR_UP)
        -- self.notice_dialog:setText( Lang.common.confirm[12])   --[12] = "#cffff00亲，您的元宝不够了！您可以快速充值。"  
        -- self.notice_dialog:setAnchorPoint(0,1);
        -- self.view:addChild( self.notice_dialog )
         --您的元宝不够了！您可以快速充值
         local text_img1 = ZImage:create( self.view, UILH_NORMAL.text_yuanbao1, 0, 0, -1, -1 )
         local self_size = self.view:getSize()
         local text_size = text_img1.view:getSize()
          text_img1.view:setPosition(self_size.width/2 - text_size.width/2,self_size.height/2-text_size.height/2 +40 )
       
         local text_img2 = ZImage:create( self.view, UILH_NORMAL.text_chongzhi, 0, 0, -1, -1 )
         text_size = text_img2.view:getSize()
         text_img2.view:setPosition(self_size.width/2 - text_size.width/2,self_size.height/2-text_size.height/2 )
    elseif self.win_type == 10 then 
        local text_img2 = ZImage:create( self.view, self.panel_tip, 0, 0, -1, -1 )
        local self_size = self.view:getSize()
        local text_size = text_img2.view:getSize()
        text_img2.view:setPosition(self_size.width/2 - text_size.width/2, self_size.height/2+text_size.height )
    else
        self.notice_dialog = CCDialogEx:dialogWithFile( 40, 240, 340, 150, 50, nil, 1 ,ADD_LIST_DIR_UP)
        self.notice_dialog:setText( self.notice_content )
        self.notice_dialog:setAnchorPoint(0,1);
        self.view:addChild( self.notice_dialog )
    end
end

-- 创建勾选项
function ConfirmWin2:create_switch_but(  )
    if self.win_type == 1 or self.win_type == 5 then
        local function swith_but_callback_fun( if_selected )
            self:do_swith_but_func(  )
        end
        -- 改用create_switch_button2，便于设置文本y值 note by guozhinan
        self.swith_but = UIButton:create_switch_button2( 53, 101, 125, 40, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, Lang.common.confirm[13], 43, 13, 16, nil, nil, nil, nil, swith_but_callback_fun ) -- [13]="不再提示"
        self.view:addChild( self.swith_but.view )
        self.swith_but.set_state(true)
    end
end

-- 创建功能按钮
function ConfirmWin2:create_apply_but(  )
    -- 应用（具体功能、确定等） 按钮回调
    local function apply_but_CB( )
        self:apply_but_func(  )
        self:close_win(  )
        self:do_swith_but_func(  )
    end

    -- 取消按钮回调
    local function cancel_but_CB(  )
        self:close_win(  )
    end

    -- 第二个功能按钮的回调
    local function apply_but_CB_2(  )
        self:apply_but_func_2(  )
        self:close_win(  )
        self:do_swith_but_func(  )
    end


    --提示框按钮
    if self.win_type == 4 or self.win_type == 5 then

        --确定
        self.apply_but_1 = UIButton:create_button_with_name( _win_width/2-126-30, 17, -1, -1,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", apply_but_CB )
        self.view:addChild( self.apply_but_1.view )
        -- local text_img = CCZXImage:imageWithFile( 49.5, 22, -1, -1, UIResourcePath.FileLocate.normal .. "queding.png" );
        -- text_img:setAnchorPoint(0.5,0.5)
        -- self.apply_but_1:addChild( text_img )
        local btn_text = UILabel:create_lable_2(_button_name_t[0].name, 126/2+30, 15+5, 18)
        local btn_w = self.apply_but_1.view:getSize().width
        local txt_w = btn_text:getSize().width
        btn_text:setPosition(btn_w/2 -txt_w/2,20 )
         self.apply_but_1.view:addChild(btn_text)
 

        --取消
        self.apply_but_2 = UIButton:create_button_with_name( _win_width/2+30, 17, -1, -1, UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", cancel_but_CB )
        self.view:addChild( self.apply_but_2.view )
        -- local text_img2 = CCZXImage:imageWithFile( 49.5, 22, -1, -1, UIResourcePath.FileLocate.normal .. "quxiao.png" )
        -- text_img2:setAnchorPoint(0.5,0.5)
        -- self.apply_but_2:addChild( text_img2 )
        local btn_text = UILabel:create_lable_2(_button_name_t[9].name, 126/2-30, 15+5, 18)
        local btn_w = self.apply_but_2.view:getSize().width
        local txt_w = btn_text:getSize().width
        btn_text:setPosition(btn_w/2 -txt_w/2,20 )
        self.apply_but_2.view:addChild(btn_text)

    -- 立即前往、  速传 提示框
    elseif self.win_type == 6 then 
        self.apply_but_1 = UIButton:create_button_with_name( _win_width/2-126-30, 17, -1, -1, UILH_COMMON.btn4_nor, UILH_COMMON.btn4_sel, nil, "", apply_but_CB )
        self.view:addChild( self.apply_but_1.view )
        -- local text_img = CCZXImage:imageWithFile( 65.5, 22, -1, -1, _button_name_image_t[1].path )
        -- text_img:setAnchorPoint(0.5,0.5)
        -- self.apply_but_1:addChild( text_img )
        local btn_text = UILabel:create_lable_2(_button_name_t[1].name, 126/2, 15+5, 18, ALIGN_CENTER)
        self.apply_but_1.view:addChild(btn_text)

        self.apply_but_2 = UIButton:create_button_with_name( _win_width/2+30, 17, -1, -1,UILH_COMMON.btn4_nor, UILH_COMMON.btn4_sel, nil, "", apply_but_CB_2 )
        self.view:addChild( self.apply_but_2.view )
        -- local text_img2 = CCZXImage:imageWithFile( 65.5, 22, -1, -1, _button_name_image_t[5].path)
        -- text_img2:setAnchorPoint(0.5,0.5)
        -- self.apply_but_2:addChild( text_img2 )
        local btn_text = UILabel:create_lable_2(_button_name_t[5].name, 126/2, 15+5, 18, ALIGN_CENTER)
        self.apply_but_2.view:addChild(btn_text)

    -- 前往（文字）
    elseif self.win_type == 7 then
        self.apply_but_1 = UIButton:create_button_with_name(170, 17, -1, -1, UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", apply_but_CB)
        self.view:addChild(self.apply_but_1.view)
        local btn_text = UILabel:create_lable_2(_button_name_t[8].name, 126/2, 15+5, 18, ALIGN_CENTER)
        self.apply_but_1.view:addChild(btn_text)

    -- 拒绝、同意
    elseif self.win_type == 8 then
        --xiehande  通用按钮修改
        self.apply_but_1 = UIButton:create_button_with_name(90, 17, -1, -1, UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", apply_but_CB)
        self.view:addChild(self.apply_but_1.view)   --btn_lang2.png ->button2.png
        local btn_text = UILabel:create_lable_2(_button_name_t[10].name, 96/2, 15+5, 16, ALIGN_CENTER)
        self.apply_but_1.view:addChild(btn_text)

        self.apply_but_2 = UIButton:create_button_with_name(246, 17, -1, -1, UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", apply_but_CB_2)
        self.view:addChild(self.apply_but_2.view)--btn_lang2.png ->button2.png  
        local btn_text = UILabel:create_lable_2(_button_name_t[11].name, 96/2, 15+5, 16, ALIGN_CENTER)
        self.apply_but_2.view:addChild(btn_text)
    --打副本时  确定  / 再来一次
    elseif self.win_type == 9 then
        self.apply_but_1 = UIButton:create_button_with_name(90, 17, -1, -1, UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", apply_but_CB)
        self.view:addChild(self.apply_but_1.view)   
        local btn_text = UILabel:create_lable_2(_button_name_t[0].name, 96/2, 15+5, 16, ALIGN_CENTER)
        self.apply_but_1.view:addChild(btn_text)

        self.apply_but_2 = UIButton:create_button_with_name(246, 17, -1, -1, UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r, nil, "", apply_but_CB_2)
        self.view:addChild(self.apply_but_2.view)--btn_lang2.png ->button2.png  
        local btn_text = UILabel:create_lable_2(_button_name_t[12].name, 96/2, 15+5, 16, ALIGN_CENTER)
        self.apply_but_2.view:addChild(btn_text)
    -- 显示一个图片
    elseif self.win_type == 10 then
        self.apply_but_1 = UIButton:create_button_with_name(170, 17, -1, -1, UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s, nil, "", apply_but_CB)
        self.view:addChild(self.apply_but_1.view)
        local btn_text = UILabel:create_lable_2(_button_name_t[0].name, 99/2, 15+5, 18, ALIGN_CENTER)
        self.apply_but_1.view:addChild(btn_text)
    else
        -- 一般的四字按钮
        --local but_bg_name = UIResourcePath.FileLocate.common .. "button3.png"
         local but_bg_name = UILH_COMMON.lh_button_4_r
        -- self.apply_but = UIButton:create_button_with_name( 110, 25, -1, -1, "ui/common/button_bg02_n.png", "ui/common/button_bg02_n.png", nil, "", apply_but_CB )
        -- self.view:addChild( self.apply_but )


        -- 按钮显示的文字
        -- print( "按钮显示的文字", self.but_name_index, _button_name_image_t[ self.but_name_index ])
        if self.but_name_index then
            local but_word_info = _button_name_t[ self.but_name_index ]
            if but_word_info then
                if but_word_info.but_type == 2 then  -- 两字的按钮背景
                    but_bg_name = UILH_COMMON.lh_button2
                    but_bg_name_s = UILH_COMMON.lh_button2_s
                    self.apply_but = UIButton:create_button_with_name( _win_width/2-121/2, 15, -1, -1, but_bg_name, but_bg_name_s, nil, "", apply_but_CB )
                else
                    self.apply_but = UIButton:create_button_with_name(  _win_width/2-121/2+7, 15, -1, -1, but_bg_name, but_bg_name_s, nil, "", apply_but_CB )
                end
                self.view:addChild( self.apply_but.view )
                local width = self.apply_but.view:getSize().width;
                -- ZCCSprite:create(self.apply_but,but_word_info.path,width/2,23)
                local btn_text = UILabel:create_lable_2(but_word_info.name, width/2, 15+5, 16, ALIGN_CENTER,999)
                self.apply_but.view:addChild(btn_text)
            end
        end
        -- 没有按钮信息，默认显示确定
        if self.but_name_index == nil or _button_name_t[ self.but_name_index ] == nil then
            local but_word_info = _button_name_t[ 0 ]

            self.apply_but = UIButton:create_button_with_name( _win_width/2-121/2, 25, -1, -1, UILH_COMMON.lh_button_4_r, UILH_COMMON.lh_button_4_r, nil, "", apply_but_CB ) 

            self.view:addChild( self.apply_but.view )
            local width = self.apply_but.view:getSize().width;
            self.apply_but.view:addChild( UILabel:create_lable_2(but_word_info.name, width/2, 15+5, 16, ALIGN_CENTER) )
        end
    end
end

-- 设置第二个按钮的回调
function ConfirmWin2:set_yes_but_func_2( yes_but_func_2 )
    if type(yes_but_func_2) == "function" then 
        self.yes_but_func_2 = yes_but_func_2
    end
end

-- 开关回调
function ConfirmWin2:do_swith_but_func(  )
    if self.swith_but_func and self.swith_but then
    	local if_selected = self.swith_but.if_selected
        self.swith_but_func( if_selected )
    end
end

-- 确认按钮回调
function ConfirmWin2:apply_but_func(  )
    if self.yes_but_func then
        self.yes_but_func()
    end
end

-- 第二个按钮的回调
function ConfirmWin2:apply_but_func_2(  )
    if self.yes_but_func_2 then 
        self.yes_but_func_2()
    end
end

-- 关闭窗口
function ConfirmWin2:close_win(  )
    AlertWin:close_alert(  )
end

-- win_type：窗口类型  1：带勾选：不再提示 的开关
-- but_name_index 按钮名称_button_name_image_t的序号 如果不用选择的情况下填nil
-- notice_content: 提示文字内容
-- x, y:  坐标
-- swith_but_func: 开关按钮改变时回调
-- yes_but_func:   确认按钮回调 函数
-- title_type:  标题类型， _title_name_image_t 中配置， 如果为nil， 则为 “提示”
function ConfirmWin2:show( win_type, but_name_index, notice_content,  yes_but_func, swith_but_func, title_type, panel_tip )

    -- local hw = GameScreenConfig.ui_screen_width * 0.5
    -- local hh = GameScreenConfig.ui_screen_height * 0.5
    local confirmWin2_temp = ConfirmWin2( win_type, but_name_index, notice_content, 260, 175, yes_but_func, swith_but_func, title_type, panel_tip )
    --confirmWin2_temp.view:setPosition(0.5,0.5)
    AlertWin:show_new_alert( confirmWin2_temp.view )   -- 显示到alertwin， 点击其他地方可以关闭

    return confirmWin2_temp

end
