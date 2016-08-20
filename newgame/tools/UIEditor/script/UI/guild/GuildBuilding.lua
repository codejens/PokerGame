-- GuildBuilding.lua
-- created by lyl on 2012-1-29
-- 仙宗列建筑页

super_class.GuildBuilding( Window )
local window_width =880
local window_height = 520

function GuildBuilding:create( Window )
    return GuildBuilding("GuildBuilding", UILH_COMMON.normal_bg_v2, true, window_width, window_height )
end

function GuildBuilding:__init( )
	self.icons_t = {}                       -- 存储所有建筑图标 
	self.info_panel_t = {}                  -- 存储信息面板
    self.icon_sele_key = "juxian"           -- 标记当前选中的icon    juxian  pantao  xianling  baibao biBeast 

	local panel = self.view
    --左边
    self.left_panel = self:create_left_panel()
    panel:addChild( self.left_panel )
    --右边
    self.right_panel = self:create_right_panel()
    panel:addChild( self.right_panel )
end

-- =======================================================
--
--   左侧
--
-- =======================================================
function GuildBuilding:create_left_panel(  )
 	-- 区域背景
	local panel = CCBasePanel:panelWithFile( 15, 16, 536, 492, UILH_GUILD.nine_grid_bg4, 500,500)
    
    self:create_one_icon( panel, 162, 276, "", UILH_GUILD.yaosai, "juxian" )       -- 忍之屋 变  要塞
  --  MUtils:create_zximg ( panel,UIPIC_FAMILY_061,190+20,182,-1,-1,500,500)

    self:create_one_icon( panel, -21, 195, "", UILH_GUILD.dayan, "pantao" )         -- 暗部  变 大宴
   -- MUtils:create_zximg ( panel,UIPIC_FAMILY_059, 14+20,37,-1,-1,500,500)

    self:create_one_icon( panel, 341, 187,  "", UILH_GUILD.hufu, "xianling" )  -- 作战室  变 虎符 
  --  MUtils:create_zximg ( panel,UIPIC_FAMILY_063,14+20,335,-1,-1,500,500)

    self:create_one_icon( panel, 32, 9, "", UILH_GUILD.zhenqibaoge, "baibao" )            -- 情报屋  变 珍奇宝阁
  --  MUtils:create_zximg ( panel,UIPIC_FAMILY_060,366+20,335,-1,-1,500,500)

    self:create_one_icon( panel, 290, 9, "", UILH_GUILD.zhanqi, "jitan")    -- 尾兽祭坛  变 战旗
   -- MUtils:create_zximg ( panel,UIPIC_FAMILY_062,366+20,37,-1,-1,500,500)

    -- self:update( "guild_level" )
    self:set_select_icon(  )

	return panel
end

-- 创建一个建筑图标, 坐标， 图标路径， 搜索的关键字
function GuildBuilding:create_one_icon( building_bg, x, y, icon_bg, icon_img_path, key )
	local icon = {} 
	icon.view = CCBasePanel:panelWithFile( x, y, 149, 149, icon_bg)
    building_bg:addChild( icon.view )                      -- 图标

    local icon_img = ZImage.new(icon_img_path)
    icon_img:setPosition(20+4, 20+6)
    icon.view:addChild(icon_img.view)

    icon.icon_sele_frame = CCZXImage:imageWithFile( 12, 14, -1, -1, UILH_GUILD.select_circle, 500, 500 )
    icon.view:addChild( icon.icon_sele_frame )             -- 选中状态

    --local level_bg = CCZXImage:imageWithFile( 5, -10, 95, 27, UIResourcePath.FileLocate.common .. "build_bg_1.png", 500, 500 )
    --icon.view:addChild( level_bg )                  -- 文字背景

    --icon.level_lable = UILabel:create_lable_2( LangGameString[1135], 47, 5, 16, ALIGN_CENTER ) -- [1135]="9级"
    --level_bg:addChild( icon.level_lable )      -- 级数

    local function icon_callback( eventType,x,y )
    	if eventType == TOUCH_CLICK then
            self.icon_sele_key = key
            self:set_select_icon(  )
            self:set_info_panel(  )
            self:check_upgrade_but(  )
            return true               -- 让主面板可以相应，关闭tips
        end
        return true
    end
    icon.view:registerScriptHandler( icon_callback )

    -- 修改等级
    icon.change_level_lable_fun = function ( level )
      --  local building_level = level or 1
    	--icon.level_lable:setString( building_level..LangGameString[1136] ) -- [1136]="级"
    end

    self.icons_t[ key ] = icon
end

-- 设置仙宗图标选中状态
function GuildBuilding:set_select_icon(  )
	for key, icon in pairs(self.icons_t) do
        icon.icon_sele_frame:setIsVisible( false )
	end
	self.icons_t[ self.icon_sele_key ].icon_sele_frame:setIsVisible( true )
end


-- =======================================================
--
--   右侧
--
-- =======================================================
function GuildBuilding:create_right_panel(  )
	local panel = CCBasePanel:panelWithFile( 569-16, 16, 313, 492, UILH_COMMON.bottom_bg, 500, 500 )

    self.junxian_info_panel = self:juxian_info_panel()
    panel:addChild( self.junxian_info_panel.panel_bg)

    self.pantao_info_panel = self:pantao_info_panel()
    panel:addChild( self.pantao_info_panel.panel_bg)

    self.xianling_info_panel = self:xianling_info_panel()
    panel:addChild( self.xianling_info_panel.panel_bg)

    self.baibao_info_panel = self:baibao_info_panel()
    panel:addChild( self.baibao_info_panel.panel_bg)

    self.ji_tan_panel = self:shengshoujitan()
    panel:addChild( self.ji_tan_panel.panel_bg)
    self:set_info_panel(  )

    -- 升级建筑按钮
    local function upgrade_building_but_fun(  )
    	GuildModel:request_upgrade_building( self.icon_sele_key )
    end
    self.upgrade_building_but = UIButton:create_button_with_name( 75+18, 13, -1, -1, UILH_COMMON.btn4_nor, UILH_COMMON.btn4_sel, nil, "", upgrade_building_but_fun )
    self.upgrade_building_but.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.btn4_dis )
    local label_but_1 = UILabel:create_label_1(Lang.guild.building[41], CCSize(100,20), 60 , 30, 16, CCTextAlignmentLeft, 255, 255, 255) 

    local btn_size = self.upgrade_building_but.view:getSize()
    local label_size = label_but_1:getSize()
    label_but_1:setPosition(btn_size.width/2 - label_size.width/2,btn_size.height/2 - label_size.height/2+4)

     self.upgrade_building_but.view:addChild( label_but_1 )  
    panel:addChild( self.upgrade_building_but.view )
    --UIButton:set_button_image_name( self.upgrade_building_but, 18, 15, 110, 28, UIPIC_FAMILY_036)
	return panel
end

-- 判断升级条件是否满足，不满足就灰掉按钮   juxian  pantao  xianling  baibao jitan
function GuildBuilding:check_upgrade_but(  )
    -- if self.icon_sele_key == "jitan" then
    --     self.upgrade_building_but.view:setCurState( CLICK_STATE_DISABLE )
    --     return
    -- end

	if self.icon_sele_key == "juxian"  then
		local pantao_check, xianling_check, baibao_check, stone_check = GuildModel:check_juxian_up_condition(  )
		if pantao_check and xianling_check and baibao_check and stone_check then
            self.upgrade_building_but.view:setCurState( CLICK_STATE_UP )
        else
            self.upgrade_building_but.view:setCurState( CLICK_STATE_DISABLE )
		end
    elseif self.icon_sele_key == "pantao" or self.icon_sele_key == "xianling" or self.icon_sele_key == "baibao" or self.icon_sele_key == "jitan" then
    	local key_t = { pantao = "biPT", xianling = "biBoss", baibao = "biStore", jitan = "biBeast"  }  -- 与调用方法参数的映射
    	local juxian_check, stone_check = GuildModel:check_con_up_condition( key_t[ self.icon_sele_key ] )
		if juxian_check and stone_check then
            self.upgrade_building_but.view:setCurState( CLICK_STATE_UP )
        else
            self.upgrade_building_but.view:setCurState( CLICK_STATE_DISABLE )
		end
	end
end

-- 根据选中的切换信息面板
function GuildBuilding:set_info_panel(  )
	for key, info_panel in pairs(self.info_panel_t) do
        info_panel.panel_bg:setIsVisible( false )
	end
    -- print("GuildBuilding:set_info_panel()",self.icon_sele_key)
	self.info_panel_t[ self.icon_sele_key ].panel_bg:setIsVisible( true )
end

--军团要塞
function GuildBuilding:juxian_info_panel(  )
    local panel = {}
	local panel_bg = CCBasePanel:panelWithFile( 0, 90, 285+15, 365, "", 500, 500 )
	-- 坐标
	local lable_x_1 = 15
	local lable_x_2 = 95
	-- local lable_x_2 = 27
    -- local lable_y = 355
    -- local lable_y_interval = 50
    local row_lable_gad1 = 28
    local row_lable_gad2 = 22
    local font_size = 15

    --文字位置 
    local lable_pos = {355,305,246,175,100}

    panel.panel_bg = panel_bg 

    local title_temp =  UILabel:create_lable_2( Lang.guild.building[3], lable_x_1, lable_pos[1], font_size, ALIGN_LEFT ) -- [1137]="#cffff00建筑名称: "
    panel_bg:addChild( title_temp )
    panel.build_name =  UILabel:create_lable_2( Lang.guild.building[4], lable_x_2, lable_pos[1], font_size, ALIGN_LEFT ) -- [1138]="#cFF49F4忍之屋"
    panel_bg:addChild( panel.build_name )

    -- 建筑等级
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2( Lang.guild.building[5], lable_x_1, lable_pos[2], font_size, ALIGN_LEFT ) -- [1139]="#cffff00建筑等级: "
    panel_bg:addChild( title_temp )
    panel.build_level =  UILabel:create_lable_2( LH_COLOR[2].."12", lable_x_2, lable_pos[2], font_size, ALIGN_LEFT )
    panel_bg:addChild( panel.build_level )

    -- 当前效果
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2( Lang.guild.building[6], lable_x_1, lable_pos[3], font_size, ALIGN_LEFT ) -- [1140]="#cffff00当前效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.curr_effect_1 = UILabel:create_lable_2( Lang.guild.building[7], lable_x_2, lable_pos[3]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1141]="仙宗人数上限提升到: #c66FF6650 "
    panel_bg:addChild( panel.curr_effect_1 )
    -- lable_y = lable_y - lable_y_interval
    panel.curr_effect_2 = UILabel:create_lable_2( Lang.guild.building[8], lable_x_2, lable_pos[3]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1142]="仙宗等级提升为: #c66FF662 "
    panel_bg:addChild( panel.curr_effect_2 )

    -- -- 下级效果
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2(Lang.guild.building[9], lable_x_1, lable_pos[4], font_size, ALIGN_LEFT ) -- [1143]="#cffff00下级效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.next_effect_1 = UILabel:create_lable_2( Lang.guild.building[10], lable_x_2, lable_pos[4]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1144]="仙宗人数上限提升到: #cFF49F450 "
    panel_bg:addChild( panel.next_effect_1 )
    -- lable_y = lable_y - lable_y_interval
    panel.next_effect_2 = UILabel:create_lable_2( Lang.guild.building[11], lable_x_2,  lable_pos[4]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1145]="仙宗等级提升为: #cFF49F42 "
    panel_bg:addChild( panel.next_effect_2 )

    -- 升级条件
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2(Lang.guild.building[12], lable_x_1, lable_pos[5], font_size, ALIGN_LEFT ) -- [1146]="#cffff00升级条件: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_1 = UILabel:create_lable_2( Lang.guild.building[13], lable_x_2, lable_pos[5]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1147]="#c66FF66蟠桃仙园（1级）"
    panel_bg:addChild( panel.condition_1 )

    panel.condition_2 = UILabel:create_lable_2( Lang.guild.building[14], lable_x_2, lable_pos[5]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1148]="#c66FF66家族叛徒（1级）"
    panel_bg:addChild( panel.condition_2 )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_3 = UILabel:create_lable_2( Lang.guild.building[15], lable_x_2, lable_pos[5]-row_lable_gad1-2*row_lable_gad2, font_size, ALIGN_LEFT ) -- [1149]="#c66FF66百宝奇阁（1级）"
    panel_bg:addChild( panel.condition_3 )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_4 = UILabel:create_lable_2( Lang.guild.building[42], lable_x_2, lable_pos[5]-row_lable_gad1-3*row_lable_gad2, font_size, ALIGN_LEFT ) -- [1150]="#c66FF66神兽祭坛（1级）"
    panel_bg:addChild( panel.condition_4 )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_5 = UILabel:create_lable_2( Lang.guild.building[17], lable_x_2, lable_pos[5]-row_lable_gad1-4*row_lable_gad2, font_size, ALIGN_LEFT ) -- [1151]="#cff0000500000灵石"
    panel_bg:addChild( panel.condition_5 )

    panel.syn_lable_fun = function ( )
    	local build_level = GuildModel:get_guild_building_level( "biMain" ) or ""
    	panel.build_level:setString( LH_COLOR[2]..build_level )                                                -- 建筑等级

    	local guild_curr_max_memb = GuildModel:get_user_guild_max_count(  ) or "" 
    	panel.curr_effect_1:setString("#cd0cda2"..Lang.guild.building[18].. guild_curr_max_memb )     -- 仙宗人数上限 -- [1152]="仙宗人数上限提升到"

    	local guild_curr_level = GuildModel:get_guild_level( ) or "" 
    	panel.curr_effect_2:setString( "#cd0cda2"..Lang.guild.building[19].. guild_curr_level )            -- 当前仙宗等级 -- [1153]="仙宗等级提升到" -- [1136]="级"
        
        local guild_next_level = GuildModel:get_user_guild_max_next_level( ) or "" 
        panel.next_effect_1:setString("#cd0cda2"..Lang.guild.building[18].. guild_next_level )        -- 下级人数上限 -- [1152]="仙宗人数上限提升到"

        local build_level_next = build_level + 1
        panel.next_effect_2:setString("#cd0cda2"..Lang.guild.building[19].. build_level_next) -- [1153]="仙宗等级提升到" -- [1136]="级"

        -- 根据是否满足条件，要设定颜色
        local color_t = GuildModel:get_junxian_up_cond_color(  )

        panel.condition_1:setString(color_t[1]..Lang.guild.building[20] .. build_level .. Lang.guild.building[21]  ) -- [1154]="翰皇虎符（" -- [1155]="级）"
        panel.condition_2:setString(color_t[2]..Lang.guild.building[22] .. build_level .. Lang.guild.building[21]  ) -- [1156]="珍奇宝阁（" -- [1155]="级）"
        panel.condition_3:setString(color_t[3]..Lang.guild.building[23] .. build_level .. Lang.guild.building[21]  ) -- [1157]="英雄大宴（" -- [1155]="级）"
        panel.condition_4:setString(color_t[5]..Lang.guild.building[24] .. build_level ..Lang.guild.building[21]  ) -- [1158]="军团战旗（" -- [1155]="级）"
        local up_need_stone = GuildModel:get_building_upgrade_need_stone( "biMain" ) or 0
        panel.condition_5:setString( color_t[4]..up_need_stone..Lang.guild.building[25]) -- [1159]="灵石"
    end

    self.info_panel_t["juxian"] = panel
    return panel
end


-- 英雄大宴
function GuildBuilding:pantao_info_panel(  )
    local panel = {}
	local panel_bg = CCBasePanel:panelWithFile( 0, 90, 285+15, 365, "", 500, 500 )

    panel.panel_bg = panel_bg

	-- 坐标
	local lable_x_1 = 15
	local lable_x_2 = 95
	-- local lable_x_2 = 27
	-- local lable_y = 340
	-- local lable_y_interval = 30
    local font_size = 15

    local row_lable_gad1 = 28
    local row_lable_gad2 = 22

      --文字位置 
    local lable_pos = {355,305,246,175,118}

    local title_temp =  UILabel:create_lable_2( Lang.guild.building[3], lable_x_1, lable_pos[1], font_size, ALIGN_LEFT ) -- [1137]="#cffff00建筑名称: "
    panel_bg:addChild( title_temp )
    panel.build_name =  UILabel:create_lable_2( Lang.guild.building[26], lable_x_2, lable_pos[1], font_size, ALIGN_LEFT ) -- [1160]="#cFF49F4蟠桃仙树"
    panel_bg:addChild( panel.build_name )

    -- 建筑等级
    title_temp =  UILabel:create_lable_2( Lang.guild.building[5], lable_x_1, lable_pos[2], font_size, ALIGN_LEFT ) -- [1139]="#cffff00建筑等级: "
    panel_bg:addChild( title_temp )
    panel.build_level =  UILabel:create_lable_2( LH_COLOR[2].."12", lable_x_2, lable_pos[2], font_size, ALIGN_LEFT )
    panel_bg:addChild( panel.build_level )

    -- 当前效果
    title_temp =  UILabel:create_lable_2( Lang.guild.building[6], lable_x_1, lable_pos[3], font_size, ALIGN_LEFT ) -- [1140]="#cffff00当前效果: "
    panel_bg:addChild( title_temp )
    panel.curr_effect_1 = UILabel:create_lable_2(LH_COLOR[2]..Lang.guild.building[27], lable_x_2-25, lable_pos[3]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1161]="蟠桃盛宴经验灵力增加100% "
    panel_bg:addChild( panel.curr_effect_1 )

    -- -- 下级效果
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2( Lang.guild.building[9], lable_x_1, lable_pos[4], font_size, ALIGN_LEFT ) -- [1143]="#cffff00下级效果: "
    panel_bg:addChild( title_temp )

    panel.next_effect_1 = UILabel:create_lable_2(LH_COLOR[2]..Lang.guild.building[28], lable_x_2-25, lable_pos[4]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1162]="蟠桃盛宴经验灵力增加20% "
    panel_bg:addChild( panel.next_effect_1 )

    -- 升级条件
    title_temp =  UILabel:create_lable_2( Lang.guild.building[12], lable_x_1, lable_pos[5], font_size, ALIGN_LEFT ) -- [1146]="#cffff00升级条件: "
    panel_bg:addChild( title_temp )

    panel.condition_1 = UILabel:create_lable_2( Lang.guild.building[31], lable_x_2, lable_pos[5]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1163]="忍之屋（2级）"
    panel_bg:addChild( panel.condition_1 )

    panel.condition_4 = UILabel:create_lable_2( Lang.guild.building[30], lable_x_2, lable_pos[5]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1164]="500000灵石"
    panel_bg:addChild( panel.condition_4 )

    panel.syn_lable_fun = function ( )
    	local build_level = GuildModel:get_guild_building_level( "biPT" ) or ""
    	panel.build_level:setString( LH_COLOR[2]..build_level )                                                -- 建筑等级

    	local effect_1_content = GuildModel:get_pantao_effect( "current" ) or "" 
    	panel.curr_effect_1:setString( LH_COLOR[2]..effect_1_content )                            -- 效果
        
        local effect_2_content = GuildModel:get_pantao_effect( "next" ) or "" 
        panel.next_effect_1:setString( LH_COLOR[2]..effect_2_content )        

        -- 根据是否满足条件，要设定颜色
        local color_t = GuildModel:get_con_up_cond_color( "biPT" )

        panel.condition_1:setString( color_t[1]..Lang.guild.building[31] .. (build_level + 1) .. Lang.guild.building[21]) -- [1165]="忍之屋（" -- [1155]="级）"
        local up_need_stone = GuildModel:get_building_upgrade_need_stone( "biPT" ) or 0
        panel.condition_4:setString( color_t[2]..up_need_stone..Lang.guild.building[25]) -- [1159]="灵石"
    end

    self.info_panel_t["pantao"] = panel
    return panel
end

-- 翰皇虎符
function GuildBuilding:xianling_info_panel(  )
    local panel = {}
	local panel_bg = CCBasePanel:panelWithFile( 0, 90, 285+15, 365, "", 500, 500 )

    panel.panel_bg = panel_bg
	-- 坐标
	local lable_x_1 = 15
	local lable_x_2 = 95
	-- local lable_x_2 = 27
    -- local lable_y = 340
    -- local lable_y_interval = 30
    local font_size = 15

    local row_lable_gad1 = 28
    local row_lable_gad2 = 22

      --文字位置 
    local lable_pos = {355,305,246,175,118}


    local title_temp =  UILabel:create_lable_2( Lang.guild.building[3], lable_x_1, lable_pos[1], font_size, ALIGN_LEFT ) -- [1137]="#cffff00建筑名称: "
    panel_bg:addChild( title_temp )
    panel.build_name =  UILabel:create_lable_2( Lang.guild.building[32], lable_x_2, lable_pos[1], font_size, ALIGN_LEFT ) -- [1166]="#cFF49F4家族叛徒"
    panel_bg:addChild( panel.build_name )

    -- 建筑等级
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2(Lang.guild.building[5], lable_x_1, lable_pos[2], font_size, ALIGN_LEFT ) -- [1139]="#cffff00建筑等级: "
    panel_bg:addChild( title_temp )
    panel.build_level =  UILabel:create_lable_2( LH_COLOR[2].."12", lable_x_2, lable_pos[2], font_size, ALIGN_LEFT )
    panel_bg:addChild( panel.build_level )

    -- 当前效果
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2( Lang.guild.building[6], lable_x_1, lable_pos[3], font_size, ALIGN_LEFT ) -- [1140]="#cffff00当前效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.curr_effect_1 = UILabel:create_lable_2( Lang.guild.building[33], lable_x_2, lable_pos[3]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1167]="可召唤一阶兽灵BOSS。 "
    panel_bg:addChild( panel.curr_effect_1 )

    -- -- 下级效果
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2( Lang.guild.building[9], lable_x_1, lable_pos[4], font_size, ALIGN_LEFT ) -- [1143]="#cffff00下级效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.next_effect_1 = UILabel:create_lable_2( Lang.guild.building[34], lable_x_2, lable_pos[4]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1168]="可召唤二阶兽灵BOSS。 "
    panel_bg:addChild( panel.next_effect_1 )

    -- 升级条件
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2( Lang.guild.building[12], lable_x_1, lable_pos[5], font_size, ALIGN_LEFT ) -- [1146]="#cffff00升级条件: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_1 = UILabel:create_lable_2( Lang.guild.building[29], lable_x_2, lable_pos[5]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1163]="忍之屋（2级）"
    panel_bg:addChild( panel.condition_1 )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_4 = UILabel:create_lable_2( Lang.guild.building[25], lable_x_2, lable_pos[5]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1164]="500000灵石"
    panel_bg:addChild( panel.condition_4 )

    panel.syn_lable_fun = function ( )
    	local build_level = GuildModel:get_guild_building_level( "biBoss" ) or ""
    	panel.build_level:setString( LH_COLOR[2]..build_level )                                                -- 建筑等级

    	local effect_1_content = GuildModel:get_xianling_effect( "current" ) or "" 
    	panel.curr_effect_1:setString( LH_COLOR[2]..effect_1_content )                            -- 效果
        
        local effect_2_content = GuildModel:get_xianling_effect( "next" ) or "" 
        panel.next_effect_1:setString( LH_COLOR[2]..effect_2_content )        

        -- 根据是否满足条件，要设定颜色
        local color_t = GuildModel:get_con_up_cond_color( "biBoss" )
        
        panel.condition_1:setString( color_t[1]..Lang.guild.building[31] .. (build_level + 1) .. Lang.guild.building[21]) -- [1165]="忍之屋（" -- [1155]="级）"
        local up_need_stone = GuildModel:get_building_upgrade_need_stone( "biBoss" ) or 0
        panel.condition_4:setString( color_t[2]..up_need_stone..Lang.guild.building[25]) -- [1159]="灵石"
    end

    self.info_panel_t["xianling"] = panel
    return panel
end

-- 珍宝奇阁
function GuildBuilding:baibao_info_panel(  )
    local panel = {}
	local panel_bg = CCBasePanel:panelWithFile( 0, 90, 285+15, 365, "", 500, 500 )
    panel.panel_bg = panel_bg
	-- 坐标
	local lable_x_1 = 15
	local lable_x_2 = 95
	-- local lable_x_2 = 27
    -- local lable_y = 340
    -- local lable_y_interval = 30
    local font_size = 15

    local row_lable_gad1 = 28
    local row_lable_gad2 = 22

      --文字位置 
    local lable_pos = {355,305,246,175,118}

    local title_temp =  UILabel:create_lable_2( Lang.guild.building[3], lable_x_1, lable_pos[1], font_size, ALIGN_LEFT ) -- [1137]="#cffff00建筑名称: "
    panel_bg:addChild( title_temp )
    panel.build_name =  UILabel:create_lable_2( Lang.guild.building[35], lable_x_2, lable_pos[1], font_size, ALIGN_LEFT ) -- [1169]="#cFF49F4百宝奇阁"
    panel_bg:addChild( panel.build_name )

    -- 建筑等级
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2(Lang.guild.building[5], lable_x_1, lable_pos[2], font_size, ALIGN_LEFT ) -- [1139]="#cffff00建筑等级: "
    panel_bg:addChild( title_temp )
    panel.build_level =  UILabel:create_lable_2( LH_COLOR[2].."12", lable_x_2, lable_pos[2], font_size, ALIGN_LEFT )
    panel_bg:addChild( panel.build_level )

    -- 当前效果
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2( Lang.guild.building[6], lable_x_1, lable_pos[3], font_size, ALIGN_LEFT ) -- [1140]="#cffff00当前效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.curr_effect_1 = UILabel:create_lable_2( LangGameString[1170], lable_x_2, lable_pos[3]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1170]="1级仙宗商店道具解封。 "
    panel_bg:addChild( panel.curr_effect_1 )

    -- -- 下级效果
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2(Lang.guild.building[9], lable_x_1, lable_pos[4], font_size, ALIGN_LEFT ) -- [1143]="#cffff00下级效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.next_effect_1 = UILabel:create_lable_2(Lang.guild.building[37], lable_x_2, lable_pos[4]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1171]="2级仙宗商店道具解封。 "
    panel_bg:addChild( panel.next_effect_1 )

    -- 升级条件
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2( Lang.guild.building[12], lable_x_1, lable_pos[5], font_size, ALIGN_LEFT ) -- [1146]="#cffff00升级条件: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_1 = UILabel:create_lable_2( Lang.guild.building[38], lable_x_2, lable_pos[5]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1172]="#cff0000忍之屋（2级）"
    panel_bg:addChild( panel.condition_1 )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_4 = UILabel:create_lable_2( Lang.guild.building[25], lable_x_2, lable_pos[5]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1151]="#cff0000500000灵石"
    panel_bg:addChild( panel.condition_4 )

    panel.syn_lable_fun = function ( )
    	local build_level = GuildModel:get_guild_building_level( "biStore" ) or ""
    	panel.build_level:setString( LH_COLOR[2]..build_level )                                                -- 建筑等级

    	local effect_1_content = GuildModel:get_baibao_effect( "current" ) or "" 
    	panel.curr_effect_1:setString( LH_COLOR[2]..effect_1_content )                            -- 效果
        
        local effect_2_content = GuildModel:get_baibao_effect( "next" ) or "" 
        panel.next_effect_1:setString( LH_COLOR[2]..effect_2_content )        

        -- 根据是否满足条件，要设定颜色
        local color_t = GuildModel:get_con_up_cond_color( "biStore" )

        panel.condition_1:setString(color_t[1]..Lang.guild.building[31].. (build_level + 1) .. Lang.guild.building[21] ) -- [1165]="忍之屋（" -- [1155]="级）"
        local up_need_stone = GuildModel:get_building_upgrade_need_stone( "biStore" ) or 0
        panel.condition_4:setString( color_t[2]..up_need_stone..Lang.guild.building[25]) -- [1159]="灵石"
    end

    self.info_panel_t["baibao"] = panel
    return panel
end

-- 军团战旗
function GuildBuilding:shengshoujitan()
    local panel = {}
    local panel_bg = CCBasePanel:panelWithFile( 0, 90, 285+15, 365, "", 500, 500 )
    panel.panel_bg = panel_bg

    -- 坐标
    local lable_x_1 = 15
    local lable_x_2 = 95
    -- local lable_x_2 = 27
    -- local lable_y = 340
    -- local lable_y_interval = 30
    local font_size = 15

    local row_lable_gad1 = 28
    local row_lable_gad2 = 22

      --文字位置 
    local lable_pos = {355,305,246,175,118}
    -- if true then
    --     local title_temp =  UILabel:create_lable_2( Lang.guild.building[40], lable_x_1, lable_y, 20, ALIGN_LEFT )
    --     panel_bg:addChild(title_temp)
    --     panel.syn_lable_fun = function ( )
    --     end
    --     self.info_panel_t["jitan"] = panel
    --     return panel
    -- end

    local title_temp =  UILabel:create_lable_2( Lang.guild.building[3], lable_x_1, lable_pos[1], font_size, ALIGN_LEFT ) -- [1137]="#cffff00建筑名称: "
    panel_bg:addChild( title_temp )
    panel.build_name =  UILabel:create_lable_2(Lang.guild.building[39], lable_x_2, lable_pos[1], font_size, ALIGN_LEFT ) -- [1173]="#cFF49F4神兽祭坛"
    panel_bg:addChild( panel.build_name )

    -- 建筑等级
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2( Lang.guild.building[5], lable_x_1, lable_pos[2], font_size, ALIGN_LEFT ) -- [1139]="#cffff00建筑等级: "
    panel_bg:addChild( title_temp )
    panel.build_level =  UILabel:create_lable_2( LH_COLOR[2].."12", lable_x_2, lable_pos[2], font_size, ALIGN_LEFT )
    panel_bg:addChild( panel.build_level )

    -- 当前效果
    -- lable_y = lable_y - lable_y_interval
    title_temp =  UILabel:create_lable_2( Lang.guild.building[6], lable_x_1, lable_pos[3], font_size, ALIGN_LEFT ) -- [1140]="#cffff00当前效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.curr_effect_1 = UILabel:create_lable_2( Lang.guild.building[33], lable_x_2-30, lable_pos[3]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1167]="可召唤一阶兽灵BOSS。 "
    panel_bg:addChild( panel.curr_effect_1 )

    -- -- 下级效果
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2( Lang.guild.building[9], lable_x_1, lable_pos[4], font_size, ALIGN_LEFT ) -- [1143]="#cffff00下级效果: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.next_effect_1 = UILabel:create_lable_2( Lang.guild.building[34], lable_x_2-30, lable_pos[4]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1168]="可召唤二阶兽灵BOSS。 "
    panel_bg:addChild( panel.next_effect_1 )

    -- 升级条件
    -- lable_y = lable_y - lable_y_interval
    -- lable_y = lable_y - lable_y_interval - 5
    title_temp =  UILabel:create_lable_2( Lang.guild.building[12], lable_x_1, lable_pos[5], font_size, ALIGN_LEFT ) -- [1146]="#cffff00升级条件: "
    panel_bg:addChild( title_temp )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_1 = UILabel:create_lable_2( Lang.guild.building[38], lable_x_2, lable_pos[5]-row_lable_gad1, font_size, ALIGN_LEFT ) -- [1163]="忍之屋（2级）"
    panel_bg:addChild( panel.condition_1 )
    -- lable_y = lable_y - lable_y_interval
    panel.condition_4 = UILabel:create_lable_2( Lang.guild.building[30], lable_x_2, lable_pos[5]-row_lable_gad1-row_lable_gad2, font_size, ALIGN_LEFT ) -- [1164]="500000灵石"
    panel_bg:addChild( panel.condition_4 )

    panel.syn_lable_fun = function ( )
        local build_level = GuildModel:get_guild_building_level( "biBeast" ) or ""
        panel.build_level:setString( LH_COLOR[2]..build_level )                                                -- 建筑等级

        local effect_1_content = GuildModel:get_jitan_effect( "current" ) or "" 
        panel.curr_effect_1:setString( LH_COLOR[2]..effect_1_content )                            -- 效果
        
        local effect_2_content = GuildModel:get_jitan_effect( "next" ) or "" 
        panel.next_effect_1:setString( LH_COLOR[2]..effect_2_content )        

        -- 根据是否满足条件，要设定颜色
        local color_t = GuildModel:get_con_up_cond_color( "biBeast" )
        
        panel.condition_1:setString( color_t[1]..Lang.guild.building[31] .. (build_level + 1) .. Lang.guild.building[21]) -- [1165]="忍之屋（" -- [1155]="级）"
        local up_need_stone = GuildModel:get_building_upgrade_need_stone( "biBeast" ) or 0
        panel.condition_4:setString( color_t[2]..up_need_stone..Lang.guild.building[25]) -- [1159]="灵石"
    end

    self.info_panel_t["jitan"] = panel
    return panel
end

function GuildBuilding:update( update_type )
    if update_type == "all" then
        self:update_all(  )
    elseif update_type == "guild_level" then 
        self:update_building_level(  )
    elseif update_type == "user_guild_info" then 
        self:update_all(  )
    end
end

-- 更新仙宗建筑等级
function GuildBuilding:update_all(  )
    self:update_building_level(  )
    self:update_building_info(  )
    self:check_upgrade_but(  )
end

-- 更新仙宗建筑等级
function GuildBuilding:update_building_level(  )
	local juxian_level = GuildModel:get_guild_building_level( "biMain" )
	self.icons_t[ "juxian" ].change_level_lable_fun( juxian_level ) 
	local pantao_level = GuildModel:get_guild_building_level( "biPT" )
	self.icons_t[ "pantao" ].change_level_lable_fun( pantao_level ) 
	local xianling_level = GuildModel:get_guild_building_level( "biBoss" )
	self.icons_t[ "xianling" ].change_level_lable_fun( xianling_level ) 
	local baibao_level = GuildModel:get_guild_building_level( "biStore" )
	self.icons_t[ "baibao" ].change_level_lable_fun( baibao_level ) 
    local jitan_level = GuildModel:get_guild_building_level( "biBeast" )
    self.icons_t[ "jitan" ].change_level_lable_fun( jitan_level )
	-- 当建筑等级改变，会引起各信息也需要刷新，并且要检查当前按钮是否还有效
	self:update_building_info(  )
	self:check_upgrade_but(  )
end

-- 仙宗建筑信息
function GuildBuilding:update_building_info(  )
	for key, panel in pairs(self.info_panel_t) do
		if panel.syn_lable_fun then
            panel.syn_lable_fun()
        end
	end
end
