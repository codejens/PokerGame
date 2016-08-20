-- ActivityGiftPage.lua  
-- created by lyl on 2013-3-5
-- 活动礼包页  

super_class.ActivityGiftPage(Window)

function ActivityGiftPage:create(  )
	-- local temp_panel_info = { texture = UIResourcePath.FileLocate.common .. "bg_blue.png", x = 18, y = 22, width = 710, height = 335 }
	return ActivityGiftPage( "ActivityGiftPage", "", false, 850, 490 )
end

function ActivityGiftPage:__init( window_name, window_info )
    


    
end

-- 更新数据
function ActivityGiftPage:update( update_type )
    if update_type == "" then
        
    else

    end
end