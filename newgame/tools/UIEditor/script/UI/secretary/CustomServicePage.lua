-- CustomServicePage.lua  
-- created by lyl on 2013-6-17
-- 客服信息

super_class.CustomServicePage(Window)



local _page_info = secretary_win_config.customServicePage
local _layout_info = nil                                -- 布局信息临时变量


function CustomServicePage:create(  )
	_page_info = secretary_win_config.customServicePage
	_layout_info = _page_info.bg1
	return CustomServicePage( "", _layout_info.img, _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h )
end

function CustomServicePage:__init( window_name, texture_name )
	local panel = self.view

    -- 标题
    local lable_info = _page_info.title_1
    panel:addChild( UILabel:create_lable_2( lable_info.words, lable_info.x, lable_info.y, lable_info.size, ALIGN_LEFT ) )

    -- 显示内容
    local content_info = _page_info.call_content
    for i = 1, #content_info do
        local lable_info = content_info[i]
        panel:addChild( UILabel:create_lable_2( lable_info.words, lable_info.x, lable_info.y, lable_info.size, ALIGN_LEFT ) )
    end

end

-- 更新数据 
function CustomServicePage:update( update_type )
    if update_type == "all" then
        
    elseif update_type == "" then
        
    end
end