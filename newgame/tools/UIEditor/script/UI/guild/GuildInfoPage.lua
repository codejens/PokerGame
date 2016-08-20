-- GuildInfoPage.lua
-- created by lyl on 2012-1.23
-- 仙宗信息页面

super_class.GuildInfoPage( Window )

local window_width =880
local window_height = 520

function GuildInfoPage:create( )
	return GuildInfoPage("GuildInfoPage", "", false, window_width, window_height,true)
end

function GuildInfoPage:__init(  )

    local panel = self.view
    local panel_bg = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500)   
    panel:addChild(panel_bg)
    
    
    --左右页显示数据由于相关联  这里只换下显示位置。不互换以前的left/right 功能
    --左页包括军团信息和军团公告   变显示上成  --》 左包括军团信息+个人信息 ，右 包括军团公告+军团功能 
    self.left_panel = GuildInfoPageLeft:create()
    self.left_panel:setPosition(6+10, 199)
    panel_bg:addChild( self.left_panel.view,999 )

    --右页包括个人信息和军团功能
    self.right_panel = GuildInfoPageRight:create()
    self.right_panel:setPosition(6+10, 8)
    panel_bg:addChild( self.right_panel.view,999 )

    --添加左右两个图片底框
    MUtils:create_zximg(panel_bg,UILH_COMMON.bottom_bg,13,14,420,494,500,500)
    MUtils:create_zximg(panel_bg,UILH_COMMON.bottom_bg,438,14,428,494,500,500)
end

function GuildInfoPage:update( update_type )
    -- print("GuildInfoPage:update( update_type )")
    if update_type == "all" then
        GuildModel:request_user_guild_date(  )
        self:update_all()
    elseif update_type == "user_guild_info" then
        self:update_all()
    else
        self:update_element( update_type ) 
    end
end

-- 刷新所有数据
function GuildInfoPage:update_all(  )
    --print("GuildInfoPage:update_all(  )")
    self.left_panel:update( "all" )
    self.right_panel:update( "all" )
end

-- 某些元素更新
function GuildInfoPage:update_element( update_type )
    self.left_panel:update( update_type )
    self.right_panel:update( update_type )
end

function GuildInfoPage:destroy()
    Window.destroy(self)
    self.left_panel:destroy()
    self.right_panel:destroy()
end