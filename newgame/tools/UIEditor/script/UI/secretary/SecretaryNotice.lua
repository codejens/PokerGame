-- SecretaryNotice.lua  
-- created by lyl on 2013-5-28
-- 游戏版本公告

super_class.SecretaryNotice(Window)


local _page_info = nil
local _layout_info = nil                                -- 布局信息临时变量
local _notice_info = nil

function SecretaryNotice:create(  )
    require "UI/secretary/notice_page_config"
    require "../data/secretary_notice"
	_page_info = secretary_noticePage_config
    _notice_info = secretary_notice
	_layout_info = _page_info.bg1
	-- return SecretaryNotice( "", {texture = _layout_info.img, x = _layout_info.x, y = _layout_info.y, width = _layout_info.w, height = _layout_info.h} )
    return SecretaryNotice( "secretary_notice", "" , true, 857, 500 )
end

function SecretaryNotice:__init( window_name, texture_name )
	local panel = self.view

    -- 头顶标题
    -- _layout_info = _page_info.page_title 
    -- local page_title = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )   -- 边角线
    -- panel:addChild( page_title )

    local begin_x = _page_info.content_begin_x
    local begin_y = _page_info.content_begin_y
    local title_interval_y = _page_info.title_interval_y
    local word_interval = _page_info.word_interval

    --妹子(appstore审核版暂时去掉妹子 )
    -- local bgPanel_4 = CCZXImage:imageWithFile( 477, 5, 359, 554, UIPIC_Secretary_001);      
    -- panel:addChild( bgPanel_4, 999 )
    -- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
    -- if is_ckeck_version then
        --卡通人物
    --     local beauty = CCZXImage:imageWithFile(600, 120, -1, -1, "nopack/body/11.png")
    --     panel:addChild(beauty,999)
    -- else
        -- if Target_Platform == Platform_Type.Platform_91 or Target_Platform == Platform_Type.Platform_ap then
        --     local beauty = CCZXImage:imageWithFile(600, 105, -1, -1, "nopack/body/11.png")
        --     panel:addChild(beauty,999)
        -- else
        --     local bgPanel_4 = CCZXImage:imageWithFile( 500, 5, 359, 554, UIPIC_Secretary_001);      
        --     panel:addChild( bgPanel_4, 999 )
        -- end
    -- end
    -- local beauty = CCZXImage:imageWithFile(600, 105, -1, -1, "nopack/body/11.png")
    --  panel:addChild(beauty,999)

    
    -- 添加暗色背景
    local bg = CCBasePanel:panelWithFile( 0, 0, 872, 519, UILH_COMMON.normal_bg_v2, 500, 500 )
    panel:addChild( bg )
    -- 妹纸图
    local gril = CCZXImage:imageWithFile(410, -35, -1, -1, "nopack/girl.png")
    panel:addChild(gril)
    ZImage:create(panel, UILH_COMMON.bottom_bg, 15, 15, 505, 490, 0, 500, 500)
    -- 新增内容
    if #_notice_info.xinzeng_text > 0 then 
        _layout_info = _page_info.title_1 
        local title_1 = CCZXImage:imageWithFile( begin_x, begin_y + 40, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )   -- 边角线
        panel:addChild( title_1 )
        begin_y = begin_y - title_interval_y
    end

    for i = 1, #_notice_info.xinzeng_text do 
        panel:addChild( UILabel:create_lable_2( _notice_info.xinzeng_text[i], begin_x, begin_y + 40, _page_info.font_size, ALIGN_LEFT ) )
        begin_y = begin_y - title_interval_y
    end

    -- 优化
    if #_notice_info.youhua_text > 0 then 
        _layout_info = _page_info.title_2 
        local title_1 = CCZXImage:imageWithFile( begin_x, begin_y + 10, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )   -- 边角线
        panel:addChild( title_1 )
        begin_y = begin_y - title_interval_y - 30
    end

    for i = 1, #_notice_info.youhua_text do 
        panel:addChild( UILabel:create_lable_2( _notice_info.youhua_text[i], begin_x, begin_y + 40, _page_info.font_size, ALIGN_LEFT ) )
        begin_y = begin_y - title_interval_y
    end

    -- 修正
    -- if #_notice_info.xiuzheng_text > 0 then 
    --     _layout_info = _page_info.title_3 
    --     local title_1 = CCZXImage:imageWithFile( begin_x, begin_y + 40, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )   -- 边角线
    --     panel:addChild( title_1 )
    --     begin_y = begin_y - title_interval_y
    -- end

    -- for i = 1, #_notice_info.xiuzheng_text do 
    --     panel:addChild( UILabel:create_lable_2( _notice_info.xiuzheng_text[i], begin_x, begin_y + 40, _page_info.font_size, ALIGN_LEFT ) )
    --     begin_y = begin_y - title_interval_y
    -- end

end

-- 更新数据 
function SecretaryNotice:update( update_type )
    if update_type == "all" then
        
    elseif update_type == "" then
        
    end
end