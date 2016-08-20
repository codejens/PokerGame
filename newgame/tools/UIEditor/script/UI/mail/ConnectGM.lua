-- ConnectGM.lua  
-- created by lyl on 2013-3-12
-- 联系管理员

super_class.ConnectGM(Window)



function ConnectGM:create(  )
	local temp_panel_info = { texture = UIPIC_GRID_nine_grid_bg3, x = 46, y = 22, width = 322, height = 358}
	return ConnectGM( "",  temp_panel_info)
end

function ConnectGM:__init( window_name, texture_name )
    
end