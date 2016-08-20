-- GuildDetailPanel.lua  
-- created by lyl on 2012-12-26
-- 仙宗详细信息窗口 

super_class.GuildDetailPanel(Window)

local color_yellow = "#cd0cda2"
local guild = nil

-- 关闭按钮   
local function close_but_callback(  )
    --GuildModel:hide_guild_detail( )
    local  win = UIManager:find_visible_window("guild_detail_win")
    if win~=nil then
        win.view:setIsVisible(false)
    end
end

function  GuildDetailPanel:create( guild )
    return GuildDetailPanel("GuildDetailPanel","",false,445,300,guild)
end

function GuildDetailPanel:show(_guild)
    guild = _guild
    local win = UIManager:show_window("guild_detail_win", true)
    return win
end

function GuildDetailPanel:__init( win_name, texture, isgrid, width, height, _guild )
    self.camp_name_t = {Lang.guild.create.camp[1], Lang.guild.create.camp[2],Lang.guild.create.camp[3]} -- 
    -- Utils:print_table_key_value( guild )
    --local guild = _guild;
	if guild == nil then
        close_but_callback(  )
	end
    --背景框
    local dialog_bg = CCBasePanel:panelWithFile( 0, 0, width, height, UILH_COMMON.style_bg, 500, 500 )
    self.view:addChild( dialog_bg )
    
    --标题背景
    -- local title = CCZXImage:imageWithFile(170, 345, 87, 17, UIPIC_FAMILY_056)
    -- dialog_bg:addChild(title)
    
    --第二层底框
    local bgPanel = CCBasePanel:panelWithFile(16, 22-5, 414, 265, UILH_COMMON.bottom_bg, 500, 500)
    dialog_bg:addChild(bgPanel)

    local panel_1 = CCBasePanel:panelWithFile(130, 148, 295, 130, "", 500, 500)
    dialog_bg:addChild(panel_1)

    local panel_2 = CCBasePanel:panelWithFile(21, 20, 405, 130, "", 500, 500)
    dialog_bg:addChild(panel_2)

     local panel_3 = CCBasePanel:panelWithFile(5, 5, 395, 120, UILH_JISHOU.frame_bg2, 500, 500)
    panel_2:addChild(panel_3)
    
    --图标背景
    local icon_bg = CCZXImage:imageWithFile( -106, 0, 110, 110, UILH_NORMAL.skill_bg_b, 500, 500 )  -- 图标背景
    panel_1:addChild( icon_bg )

    -- 图标
    self.guild_icon = GuildCommon:get_icon_by_index( guild.icon, 41, 155,-1,-1  )
    -- panel_1:addChild( self.guild_icon )
    self:addChild( self.guild_icon )

    --- 信息
    panel_1:addChild( UILabel:create_lable_2(Lang.guild.detail[1], 16, 94, 16,  ALIGN_LEFT) ) -- [1174]="#c53ee48名称："
    self.guild_name_lable = UILabel:create_lable_2( color_yellow .. guild.name, 89, 94, 16, ALIGN_LEFT )
    panel_1:addChild( self.guild_name_lable )

    panel_1:addChild( UILabel:create_lable_2( color_yellow .. Lang.guild.detail[2], 16, 58, 15,  ALIGN_LEFT ) ) -- [1176]="#c53ee4军团长："
    self.wang_name_lable = UILabel:create_lable_2( color_yellow .. guild.wang_name,  89, 58, 16, ALIGN_LEFT )
    panel_1:addChild( self.wang_name_lable )


    local max_memb_count = GuildModel:get_guild_level_max_count( guild ) or ""
    panel_1:addChild( UILabel:create_lable_2( Lang.guild.detail[3], 176, 18, 15,  ALIGN_LEFT ) ) -- [1182]="#c53ee48成员："
    self.memb_count_lable = UILabel:create_lable_2( color_yellow..guild.memb_count.."/"..max_memb_count, 230, 18, 15, ALIGN_LEFT )
    panel_1:addChild( self.memb_count_lable )

    panel_1:addChild( UILabel:create_lable_2( Lang.guild.detail[4], 210, 58, 15,  ALIGN_LEFT ) ) -- [1177]="#c53ee48等级："
    self.guild_level_lable = UILabel:create_lable_2( color_yellow .. guild.level, 260, 58, 16, ALIGN_LEFT )
    panel_1:addChild( self.guild_level_lable )

    panel_1:addChild( UILabel:create_lable_2( Lang.guild.detail[5], 210, 94, 15,  ALIGN_LEFT) ) -- [1175]="#c53ee48排名："
    self.guild_ranking_lable = UILabel:create_lable_2( color_yellow .. guild.ranking, 260, 94, 16, ALIGN_LEFT )
    panel_1:addChild( self.guild_ranking_lable )
    
    --阵营
    panel_1:addChild( UILabel:create_lable_2( Lang.guild.detail[6], 16, 18, 15,  ALIGN_LEFT ) ) -- [1178]="#c53ee48阵营："
    local camp = self.camp_name_t[guild.camp] or ""
    self.camp_lable = UILabel:create_lable_2( color_yellow .. camp or "", 89, 18, 15, ALIGN_LEFT )
    panel_1:addChild( self.camp_lable )

    --军团公告
    -- local title_bg = CCZXImage:imageWithFile( 1, 104, 127, 28, UIPIC_FAMILY_016, 500, 500 )
    -- local title = CCZXImage:imageWithFile(22, 2, 71, 23, UIPIC_FAMILY_017)
    -- title_bg:addChild(title)

        local title_name =  UILabel:create_lable_2(LH_COLOR[13]..Lang.guild[30].."：", 11, 102, font_size, ALIGN_LEFT ) 
    panel_2:addChild(title_name)
    
    --分割线
    local line = ZImage:create( nil, UILH_COMMON.split_line , 7, 125, 390, 3 )
    panel_2:addChild( line.view )


    self.notice_dialog = CCDialogEx:dialogWithFile( 15, 7, 354, 85, 100, nil, TYPE_VERTICAL, ADD_LIST_DIR_UP)
    self.notice_dialog:setText( color_yellow .. guild.notice )
    panel_2:addChild( self.notice_dialog )

    -- 关闭按钮
    -- local close_but = UIButton:create_button_with_name( 375, 254, -1, -1, UIPIC_COMMOM_008,UIPIC_COMMOM_008, nil, "", close_but_callback )
    -- -- local exit_btn_size = close_but:getSize()
    -- -- local spr_bg_size = panel_2:getSize()
    -- -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width / 2 - 10, spr_bg_size.height - exit_btn_size.height / 2 - 10 )
    -- dialog_bg:addChild( close_but.view )

end

-- 设置窗口信息
function GuildDetailPanel:set_content( _guild )
    guild = _guild
    -- 图标
    self.guild_icon:setTexture(GuildCommon:get_icon_path_by_index(guild.icon))

    self.guild_name_lable:setText( color_yellow..guild.name )
    self.guild_ranking_lable:setString( color_yellow..guild.ranking )
    self.wang_name_lable:setString( color_yellow..guild.wang_name )
    self.guild_level_lable:setString( color_yellow..guild.level )
    local camp = self.camp_name_t[guild.camp] or ""
    self.camp_lable:setString( color_yellow..camp )
    local max_memb_count = GuildModel:get_guild_level_max_count( guild ) or ""
    self.memb_count_lable:setString( color_yellow..guild.memb_count.."/"..max_memb_count )
    self.notice_dialog:setText( "" )        -- dialog 必须这样设置为空，否则setText会叠加
    -- print("========== guild.notice: " .. guild.notice)
    self.notice_dialog:setText( color_yellow..guild.notice )
end
