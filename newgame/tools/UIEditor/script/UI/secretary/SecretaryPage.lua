-- SecretaryPage.lua  
-- created by lyl on 2013-5-28
-- 游戏助手页


super_class.SecretaryPage(Window)

local _page_info = secretary_win_config.secretaryPage
local _layout_info = nil                                -- 布局信息临时变量


function SecretaryPage:create(  )
	_page_info = secretary_win_config.secretaryPage
	_layout_info = _page_info.bg1
	-- return SecretaryPage( "secretary_win", _layout_info.img )
    return SecretaryPage( "secretary_win", "" , true, 857, 500 )
end

function SecretaryPage:__init( window_name, window_info )
    
    local panel = self.view

    -- 添加暗色背景
    local bg = CCBasePanel:panelWithFile( 0, 0, 872, 519, UILH_COMMON.normal_bg_v2, 500, 500 )
    panel:addChild( bg )
    -- 妹纸图
    local gril = CCZXImage:imageWithFile(410, -35, -1, -1, "nopack/girl.png")
    panel:addChild(gril)
    ZImage:create(panel, UILH_COMMON.bottom_bg, 15, 15, 505, 490, 0, 500, 500)
    --妹子(appstore审核版暂时去掉妹子 )
    -- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
    -- if is_ckeck_version then
    --     --卡通人物
    --     local beauty = CCZXImage:imageWithFile(600, 120, -1, -1, "nopack/body/11.png")
    --     self.view:addChild(beauty)
    -- else
        --大波女
        -- if Target_Platform == Platform_Type.Platform_91 or Target_Platform == Platform_Type.Platform_ap then
        --     local beauty = CCZXImage:imageWithFile(600, 105, -1, -1, "nopack/body/11.png")
        --     panel:addChild(beauty,999)
        -- else
        --     local bgPanel_4 = CCZXImage:imageWithFile( 500, 5, 359, 554, UIPIC_Secretary_001);      
        --     panel:addChild( bgPanel_4, 999 )
        -- end
    -- end



    self.secretaryRowMgr = SecretaryRowMgr( self.view, 0, 0 )


end

-- 更新数据 
function SecretaryPage:update( update_type )
    if update_type == "all" then
        self.secretaryRowMgr:update( update_type )
    elseif update_type == "" then

    else
        self.secretaryRowMgr:update( update_type )
    end
    self.secretaryRowMgr:row_state_change(  )
end

function SecretaryPage:destroy()
	Window.destroy(self)
    self.secretaryRowMgr:destroy()
end
