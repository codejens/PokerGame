-- GuildTianyanRight.lua
-- created by lyl on 2012-1.29
-- 仙宗天元之战页面

super_class.GuildTianyanRight( Window )

local window_width =347
local window_height = 480
local  title_color = LH_COLOR[13]
local  text_color = LH_COLOR[2]
function GuildTianyanRight:create( )
	return GuildTianyanRight( "GuildTianyanRight", "", false, window_width, window_height )
end

function GuildTianyanRight:__init( )
    local panel = self.view

    local bgPanel1 = CCBasePanel:panelWithFile(0, 10, window_width, window_height, UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(bgPanel1)

    -- 标题   图片形式
    local title_bg = CCZXImage:imageWithFile( -4, 460, -1, -1, UILH_NORMAL.title_bg3, 500, 500 )
    panel:addChild( title_bg )
    local title = CCZXImage:imageWithFile(121, 14, -1, -1, UILH_GUILD.wancheng_role)
    local title_bg_size = title_bg:getSize()
    local title_size = title:getSize()
    title:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2)

    title_bg:addChild(title)

    --标题  文字形式
    -- local title_lable = UILabel:create_lable_2( title_color..Lang.guild.tianyuan[5], 6, 460, 16,  ALIGN_LEFT ) -- [12]="#cffff00王城之战规则:"
    -- panel:addChild( title_lable )

    local lable_x_1 = 16
    local lable_x_2 = 32
    local lable_y = 413
    local inter_y   = 50

    local lable_temp = UILabel:create_lable_2( Lang.guild.tianyuan[6] , lable_x_1, lable_y, 16,  ALIGN_LEFT ) -- [1226]="1、周日#c66FF6619:30-20:00#cffffff开启活动"
    bgPanel1:addChild( lable_temp )

    lable_y = lable_y - inter_y
    lable_temp = UILabel:create_lable_2(  Lang.guild.tianyuan[7], lable_x_1, lable_y, 16,  ALIGN_LEFT ) -- [1227]="2、#c66FF66仙宗积分第一#cffffff的可获得天"
    bgPanel1:addChild( lable_temp )
    lable_y = lable_y - 28
    lable_temp = UILabel:create_lable_2(  Lang.guild.tianyuan[8], lable_x_2, lable_y, 16,  ALIGN_LEFT ) -- [1228]="元城的主宰权"
    bgPanel1:addChild( lable_temp )

    lable_y = lable_y - inter_y
    lable_temp = UILabel:create_lable_2(  Lang.guild.tianyuan[9], lable_x_1, lable_y, 16,  ALIGN_LEFT ) -- [1229]="3、天元城建立此宗宗主的雕像"
    bgPanel1:addChild( lable_temp )
    lable_y = lable_y - 28
    lable_temp = UILabel:create_lable_2(  Lang.guild.tianyuan[10], lable_x_2, lable_y, 16,  ALIGN_LEFT ) -- [1230]="以资表彰，此仙宗成员每周一"
    bgPanel1:addChild( lable_temp )
    lable_y = lable_y - 28
    lable_temp = UILabel:create_lable_2(  Lang.guild.tianyuan[11], lable_x_2, lable_y, 16,  ALIGN_LEFT ) -- [1231]="至周日可获得#c66FF66每日主宰奖励#cffffff"
    bgPanel1:addChild( lable_temp )

    -- 右边的下半部分
    -- local bgPanel2 = CCBasePanel:panelWithFile(0, 52, 316, 120, UIPIC_FAMILY_011, 500, 500)
    -- panel:addChild(bgPanel2)

    -- local title_bg = CCZXImage:imageWithFile( 1, 90, 127, 28, UIPIC_FAMILY_016, 500, 500 )
    -- local title = CCZXImage:imageWithFile(22, 2, 71, 23, UIPIC_FAMILY_029)
    -- title_bg:addChild(title)
    -- bgPanel2:addChild(title_bg)

    -- -- 家族名称
    -- local name_title = UILabel:create_lable_2(Lang.guild.list[2], 10, 66, 16, ALIGN_LEFT)
    -- bgPanel2:addChild(name_title)
    -- self.name_lable = UILabel:create_lable_2("", 90, 66, 16, ALIGN_LEFT)
    -- bgPanel2:addChild(self.name_lable)

    --  -- 积分
    -- local score_title = UILabel:create_lable_2( Lang.guild.tianyuan[1], 10, 10, 16, ALIGN_LEFT ) -- [1221]="#cffff00仙宗本周积分："
    -- bgPanel2:addChild( score_title )
    -- self.score_lable = UILabel:create_lable_2( "", 90, 10, 16, ALIGN_LEFT )
    -- bgPanel2:addChild( self.score_lable )

    -- -- 排名
    -- local ranking_title = UILabel:create_lable_2( Lang.guild.tianyuan[2], 10, 38, 16, ALIGN_LEFT ) -- [1222]="#cffff00排名："
    -- bgPanel2:addChild( ranking_title )
    -- self.ranking_lable = UILabel:create_lable_2( "", 90, 38, 16, ALIGN_LEFT )
    -- bgPanel2:addChild( self.ranking_lable )
end

-- 更新本仙宗天元战信息
function GuildTianyanRight:update_self_guild_info(  )
   local  guild_tianyuan_range, guild_tianyuan_score = GuildModel:get_self_tianyuan_range_info(  )
   -- xiehande 
    -- print("xiehande GuildTianyanRight:update_self_guild_info")
    --  print("guild_tianyuan_range=",guild_tianyuan_range)
    --   print("guild_tianyuan_score=",guild_tianyuan_score)
   self.score_lable:setString( guild_tianyuan_score )
   self.ranking_lable:setString( guild_tianyuan_range )
end


function GuildTianyanRight:destroy(  )
    -- self:hide_keyboard()
     Window.destroy(self);
end
