-- -- WindowExten.lua
-- -- created by HJH on 2014-9-22
-- --适用范围：需要标题和关闭按钮的页面可继承
-- require "UI/component/Window"

-- super_class.NormalStyleWindow(Window)

-- --关闭按钮
-- local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }

-- local _title_info = { img = UIPIC_GRID_title_right, z = nil, width = -1, height = 60, reserve_width = 100 }

-- local _title_light_info = { img = UIPIC_GRID_title_light, z = nil, height = 50 }

-- function NormalStyleWindow:__init( window_name, texture_name, is_grid, width, height,title_text )
	
-- 	-- local _t_img_bg = "sui/common/win_panel.png"
-- 	local big_win_info = UIManager:get_new_big_win_create_info()
-- 	local bg = ZImage:create( self.view, "sui/common/win_panel.png", 5, 10, 883, 595, -1,500,500 )
    
--     --标题背景
-- 	local title_bg = ZImage:create( bg, "sui/common/win_title_bg.png", -31, 515, -1, -1 )
-- 	-- local title_bg_size = title_bg:getSize()
-- 	-- title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    
-- 	-- local t_width = title_bg:getSize().width
-- 	-- local t_height = title_bg:getSize().height
-- 	ZImage:create(bg, title_text , 135, 550, -1,-1, 998 )
-- 	ZImage:create(bg, "sui/common/pj.png" , -25, 360, -1,-1, 999 )
-- 	-- self.window_title.view:setAnchorPoint(0.5,0.5)
	   

--     --关闭按钮
-- 	local function _close_btn_fun()
-- 		-- Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
-- 		UIManager:hide_window(window_name)
-- 		SoundManager:play_ui_effect( 3 )
-- 	end

-- 	self._exit_btn = ZButton:create(self.view, "sui/common/close.png", _close_btn_fun, 0, 5, -1, -1, _exit_btn_info.z);
-- 	--self._exit_btn:setAnchorPoint(0.5,0.5)
-- 	local exit_btn_size = self._exit_btn:getSize()
-- 	self._exit_btn:setPosition( 806, 550)

-- end

-- function NormalStyleWindow:setExitBtnFun(tFun)
-- 	self._exit_btn:setTouchClickFun(tFun)
-- end
