-- GuildFubenTab1.lua
-- created by liuguowang on 2014-3-25

super_class.GuildFubenTab1()




function GuildFubenTab1:__init( bgPanel )
    --背景
    local background = CCBasePanel:panelWithFile( 42, 11, 339,382,nil, 500, 500);  --方形区域
    bgPanel:addChild( background,2 )

    local bk1 = ZImage:create(background, UIPIC_GRID_nine_grid_bg3,0,156,340,226,nil,500,500)
    ZImage:create(bk1, UIResourcePath.FileLocate.guild .. "fuben_bk1.png",5,5,330,-1)

    local bk2 = ZImage:create(background, UIPIC_GRID_nine_grid_bg3,0,0,340,152,nil,500,500)
    ZImageImage:create(bk2, UIResourcePath.FileLocate.guild .. "fuben_jianjie.png", UIResourcePath.FileLocate.common .. "quan_bg.png", 3, 120, 334, -1, 500, 500) 
    ZDialog:create(bk2,Lang.guild.fuben.jieshao,10,10,322,110)

    self.view = background


end
