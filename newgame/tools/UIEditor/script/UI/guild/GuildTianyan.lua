-- GuildTianyan.lua
-- created by lyl on 2012-1.29
--alter by xiehande on 2014-12-11
-- 仙宗天元之战页面

super_class.GuildTianyan( Window )

local window_width =880
local window_height = 520


function GuildTianyan:create( )
	return GuildTianyan("GuildTianyan", UILH_COMMON.normal_bg_v2, true, window_width, window_height )
end

function GuildTianyan:__init( )
    self.left_panel = GuildTianyanLeft:create()
    self.left_panel:setPosition(10, 5)
    self.view:addChild( self.left_panel.view )
    self.right_panel = GuildTianyanRight:create()
    self.right_panel:setPosition(554-35, 5)
    self.view:addChild( self.right_panel.view )

end

function GuildTianyan:update( update_type )
	if update_type == "tianyuan_list" then
        self.left_panel:update_list(  )
    elseif update_type == "self_tianyuan" then
     --   self.right_panel:update_self_guild_info(  )
    else
        self.left_panel:update("all")
	end
end

function GuildTianyan:destroy()
    self.view:removeChild( self.left_panel.view, true )
    self.left_panel:destroy()
    self.view:removeChild(self.right_panel.view, true)
    self.right_panel:destroy()
    Window.destroy(self)

end

-- function GuildTianyan:update( update_type )
--     print("GuildInfoPage:update( update_type )")
--     if update_type == "all" then
--         self:update_all()
--     elseif update_type == "user_guild_info" then
--         self:update_all()
--     else
--         self:update_element( update_type ) 
--     end
-- end

-- -- 刷新所有数据
-- function GuildTianyan:update_all(  )
--     print("GuildInfoPage:update_all(  )")
--     self.left_panel:update( "all" )
--     self.right_panel:update( "all" )
-- end

-- -- 某些元素更新
-- function GuildTianyan:update_element( update_type )
--     self.left_panel:update( update_type )
--     self.right_panel:update( update_type )
-- end