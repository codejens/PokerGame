-- TYZZDialog.lua
-- created by hcl on 2013/7/8
-- 天元之战对话框


require "UI/component/Window"
require "utils/MUtils"
super_class.TYZZDialog(NormalStyleWindow)

-- 
function TYZZDialog:__init( window_name, texture_name, is_grid, width, height,title_text )
    -- local title_bg = Image:create(nil, 0, 0, -1, -1, "" )
    -- local title_bg_size = title_bg:getSize()
    -- title_bg:setPosition( ( width - title_bg_size.width ) / 2 , height - title_bg_size.height - 40 )
    -- self.view:addChild( title_bg.view )

    local spr_bg = CCZXImage:imageWithFile( 15, 16, 420,310, UILH_COMMON.bottom_bg,500,500);
    self.view:addChild( spr_bg );


    MUtils:create_sprite(self.view,"",313 ,370 );
    -- print( "Lang.tyzz.str......................",Lang.tyzz.str )
    local dialog = MUtils:create_ccdialogEx(self.view,Lang.tyzz.str,23,315,400,280,20,15,1);
    dialog:setAnchorPoint(0,1);
end


