-- SetSystemPage.lua  
-- created by lyl on 2013-3-15
-- 读取邮件

super_class.SetSystemPage(Window)

require "model/SetSystemModel"

local commonPath = nil
local systemPath = nil

function SetSystemPage:create(  )
--    local temp_panel_info = { texture = "", x = 15, y = 10, width = 750, height = 345 }
    -- local temp_panel_info = { texture = "", x = 30, y = 20, width = 857, height = 495 }
	return SetSystemPage( "SetSystemPage", UILH_COMMON.normal_bg_v2, true, 891, 524)
end

function SetSystemPage:__init( window_name, texture_name )
    self.select_item_t = {}                    -- 所有选项控件集合  

    commonPath = UIResourcePath.FileLocate.common
    systemPath = UIResourcePath.FileLocate.systemSet

    -- 人为制作右背景

    self:create_left_up_panel(12, 13, 432, 499)
    self:create_right_panel(445, 13, 432, 499)

    self:update_all_but(  )
end

function SetSystemPage:create_right_panel(x, y, width, height)
    local panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild( panel )

    -- 标题背景
    local title_bg = CCZXImage:imageWithFile( 8, 460 , width-16, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel:addChild(title_bg)
    -- 标题文字：其他设置
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.system_page[2],(width-10)/2,11,ALIGN_CENTER,16);

    -- 创建所有选项
    local begin_x_1  = 20               -- 第一列x坐标
    local begin_x_2  = 233              -- 第二列x坐标
    local begin_y    = 400              -- 第一行y坐标
    local interval_y = 67               -- 行的y坐标间隔

    local content = Lang.set_system_info.system_page.auto_accept_friend--"#cffff00自动接受好友邀请"
    self.select_item_t[ SetSystemModel.AUTO_ACCEPT_FRIEND ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 36, 15, SetSystemModel.AUTO_ACCEPT_FRIEND )
    panel:addChild( self.select_item_t[ SetSystemModel.AUTO_ACCEPT_FRIEND ].view )
    
    local content = Lang.set_system_info.system_page.auto_reject_freind--"#cffff00自动拒绝好友邀请"
    self.select_item_t[ SetSystemModel.REJECT_ADDED_FRIEND ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 36, 15, SetSystemModel.REJECT_ADDED_FRIEND )
    panel:addChild( self.select_item_t[ SetSystemModel.REJECT_ADDED_FRIEND ].view )

    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.auto_accept_group--"#cffff00自动接受组队邀请"
    self.select_item_t[ SetSystemModel.AUTO_JOINED_TEAM ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 36, 15, SetSystemModel.AUTO_JOINED_TEAM )
    panel:addChild( self.select_item_t[ SetSystemModel.AUTO_JOINED_TEAM ].view )
    
    local content = Lang.set_system_info.system_page.auto_reject_group--"#cffff00自动拒绝交易邀请"
    self.select_item_t[ SetSystemModel.REJECT_BE_TRADED ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 36, 15, SetSystemModel.REJECT_BE_TRADED )
    panel:addChild( self.select_item_t[ SetSystemModel.REJECT_BE_TRADED ].view )
    -- local content = "#cffff00自动拒绝切磋邀请"
    -- self.select_item_t[ SetSystemModel.REJECT_CHALLENGED ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 20, "ui/pet/pet_toggle2_n.png", "ui/pet/pet_toggle2_s.png", content, 22, 15, SetSystemModel.REJECT_CHALLENGED )
    -- panel:addChild( self.select_item_t[ SetSystemModel.REJECT_CHALLENGED ].view )

    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.auto_accept_camp--"#cffff00自动接受帮派邀请"
    self.select_item_t[ SetSystemModel.AUTO_ACCEPT_GUILD ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 36, 15, SetSystemModel.AUTO_ACCEPT_GUILD )
    panel:addChild( self.select_item_t[ SetSystemModel.AUTO_ACCEPT_GUILD ].view )


    -- 标题背景
    title_bg = CCZXImage:imageWithFile( 8, 185 , width-16, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel:addChild(title_bg)
    -- 标题文字：声音设置
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.system_page[3],(width-10)/2,11,ALIGN_CENTER,16);

    -- 滑动条定位
    local begin_x = 105
    local top_y = 115
    local row_space = 60

    -- 滑动条背景
    local bar_bg = CCZXImage:imageWithFile( begin_x+9, top_y+7, 297, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    panel:addChild( bar_bg ) 
    -- 滑动条
    local function music_bar_callback( current_value )
        -- print( "音乐当前值", current_value )
        SetSystemModel:set_one_date( SetSystemModel.MUSIC_VOLUME, current_value )
    end
    self.music_value_bar = MUtils:create_value_move_bar2( begin_x, top_y, UILH_NORMAL.progress_bar, 315, 12,  UILH_NORMAL.slider, 40, 39, 100, music_bar_callback )
    panel:addChild( self.music_value_bar.view )
    -- 滑动条文字：背景音乐
    MUtils:create_zximg(self.music_value_bar.view,UILH_SYSTEM_SETTING.beijingyinyue,-80,10,-1,-1)   

    -- 滑动条背景
    top_y = top_y - row_space;
    local bar_bg = CCZXImage:imageWithFile( begin_x+9, top_y+7, 297, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    panel:addChild( bar_bg ) 
    local function action_bar_callback( current_value )
        -- print( "动作当前值", current_value )
        SetSystemModel:set_one_date( SetSystemModel.EFFECT_VOLUME, current_value )
    end
    self.action_value_bar = MUtils:create_value_move_bar2( begin_x, top_y, UILH_NORMAL.progress_bar, 315, 12, UILH_NORMAL.slider, 40, 39, 100, action_bar_callback )
    panel:addChild( self.action_value_bar.view )
    -- 滑动条文字：动作音效
    MUtils:create_zximg(self.action_value_bar.view,UILH_SYSTEM_SETTING.dongzuoyinxiao,-80,10,-1,-1)   
end

-- 创建一个选择控件
function SetSystemPage:create_one_switch_but( x, y, w, h, image_n, image_s, words, words_x, fontsize, but_key )
    local function switch_button_func(  )
        self:config_change( but_key )
    end
    -- 用create_switch_button2，便于设置文本的y值
    local switch_but = UIButton:create_switch_button2( x, y, w, h, image_n, image_s, words, 40, 13, fontsize, nil, nil, nil, nil, switch_button_func )
    switch_but.but_key = but_key
    return switch_but
end

-- 创建左上面板
function SetSystemPage:create_left_up_panel(x, y, width, height)
    local panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild( panel )

    -- 标题背景
    local title_bg = CCZXImage:imageWithFile( 8, 460 , width-16, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel:addChild(title_bg)
    -- 标题文字：显示设置
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.system_page[1],(width-10)/2,11,ALIGN_CENTER,16);

    -- 创建所有选项
    local begin_x_1  = 20               -- 第一列x坐标
    local begin_x_2  = 233              -- 第二列x坐标
    local begin_y    = 405              -- 第一行y坐标
    local interval_y = 62               -- 行的y坐标间隔

    -- 第一行
    local content = Lang.set_system_info.system_page.ignore_notic
    self.select_item_t[ SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION )
    panel:addChild( self.select_item_t[ SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION ].view )

    local content = Lang.set_system_info.system_page.screen_role_max_num
    self.select_item_t[ SetSystemModel.LIMIT_DISPLAY_PLAYER ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.LIMIT_DISPLAY_PLAYER )
    panel:addChild( self.select_item_t[ SetSystemModel.LIMIT_DISPLAY_PLAYER ].view )

    -- 第二行
    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.ignore_other_player
    self.select_item_t[ SetSystemModel.HIDE_OTHER_PLAYER ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.HIDE_OTHER_PLAYER )
    panel:addChild( self.select_item_t[ SetSystemModel.HIDE_OTHER_PLAYER ].view )
    

    local content = Lang.set_system_info.system_page.show_monster
    self.select_item_t[ SetSystemModel.SHOW_MONSTER_NAME ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.SHOW_MONSTER_NAME )
    panel:addChild( self.select_item_t[ SetSystemModel.SHOW_MONSTER_NAME ].view )

    -- 第三行    
    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.ignore_self_title
    self.select_item_t[ SetSystemModel.HIDE_MY_TITLE ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, 
        SetSystemModel.HIDE_MY_TITLE )
    panel:addChild( self.select_item_t[ SetSystemModel.HIDE_MY_TITLE ].view )

    local content = Lang.set_system_info.system_page.show_screen_info
    self.select_item_t[ SetSystemModel.show_scene_animation ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.show_scene_animation )
    panel:addChild( self.select_item_t[ SetSystemModel.show_scene_animation ].view )

    -- 第四行
    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.show_same_camp_player
    self.select_item_t[ SetSystemModel.HIDE_SAME_CAMP ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.HIDE_SAME_CAMP )
    panel:addChild( self.select_item_t[ SetSystemModel.HIDE_SAME_CAMP ].view )

    local content = Lang.set_system_info.system_page.show_weather_system
    self.select_item_t[ SetSystemModel.show_weather_effect ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.show_weather_effect )
    panel:addChild( self.select_item_t[ SetSystemModel.show_weather_effect ].view )

    -- 第五行
    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.show_net_time
    self.select_item_t[ SetSystemModel.net_delay_check ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.net_delay_check )
    panel:addChild( self.select_item_t[ SetSystemModel.net_delay_check ].view )

    local content = Lang.set_system_info.system_page.show_fps
    self.select_item_t[ SetSystemModel.show_fts ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.show_fts )
    panel:addChild( self.select_item_t[ SetSystemModel.show_fts ].view )

    -- 第六行
    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.show_screen_effect
    self.select_item_t[ SetSystemModel.show_scene_effect ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.show_scene_effect )
    panel:addChild( self.select_item_t[ SetSystemModel.show_scene_effect ].view )

    local content = Lang.set_system_info.system_page.auto_power
    self.select_item_t[ SetSystemModel.POWER_SAVING ] = self:create_one_switch_but( begin_x_2, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.POWER_SAVING )
    panel:addChild( self.select_item_t[ SetSystemModel.POWER_SAVING ].view )

    -- 第七行
    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.system_page.fuben_optimize   -- 副本优化
    self.select_item_t[ SetSystemModel.FUBEN_OPTIMIZE ] = self:create_one_switch_but( begin_x_1, begin_y, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 33+5, 15, SetSystemModel.FUBEN_OPTIMIZE )
    panel:addChild( self.select_item_t[ SetSystemModel.FUBEN_OPTIMIZE ].view )
end

-- 选项发生改变
function SetSystemPage:config_change( but_key )
    print(but_key)
    local switch_but = self.select_item_t[ but_key ]
    local but_value  = switch_but.if_selected

    -- 控制自动加接受好友  和 自动拒绝好友  只能一个
    if but_key == SetSystemModel.AUTO_ACCEPT_FRIEND and but_value == true then   -- 自动接受 选中
        self.select_item_t[ SetSystemModel.REJECT_ADDED_FRIEND ].set_state( false )
        SetSystemModel:set_one_date( SetSystemModel.REJECT_ADDED_FRIEND, false )
    elseif but_key == SetSystemModel.REJECT_ADDED_FRIEND and but_value == true then 
        self.select_item_t[ SetSystemModel.AUTO_ACCEPT_FRIEND ].set_state( false )
        SetSystemModel:set_one_date( SetSystemModel.AUTO_ACCEPT_FRIEND, false )
    end

    SetSystemModel:set_one_date( but_key, but_value )
end

-- 更新所有选择按钮
function SetSystemPage:update_all_but(  )
    for key, switch_but in pairs(self.select_item_t) do 
        local value = SetSystemModel:get_date_value_by_key( key )
        switch_but.set_state( value )
    end
end

-- 更新滑动条
function SetSystemPage:update_move_bar(  )
    -- 音乐 音量
    local music_value = SetSystemModel:get_date_value_by_key( SetSystemModel.MUSIC_VOLUME )
    self.music_value_bar.set_current_value( music_value )

    -- 音效音量
    local effect_value = SetSystemModel:get_date_value_by_key( SetSystemModel.EFFECT_VOLUME )
    self.action_value_bar.set_current_value( effect_value )
end

-- 更新数据
function SetSystemPage:update( update_type )
    if update_type == "set_date" then
        self:update_all_but(  )
        self:update_move_bar(  )
    elseif update_type == "all" then
        self:update_all_but(  )
        self:update_move_bar(  )
    else
        -- self.current_panel:update( update_type )
    end
end