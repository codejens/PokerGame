-- WindowExten.lua
-- created by HJH on 2014-9-22
--适用范围：需要标题和关闭按钮的页面可继承
require "UI/component/Window"

super_class.NormalStyleWindow(Window)

--关闭按钮
local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }

local _title_info = { img = UIPIC_GRID_title_right, z = nil, width = -1, height = 60, reserve_width = 100 }

local _title_light_info = { img = UIPIC_GRID_title_light, z = nil, height = 50 }

function NormalStyleWindow:__init( window_name, texture_name, is_grid, width, height,title_text )
	
	local _t_img_bg = UILH_COMMON.style_bg
	local big_win_info = UIManager:get_new_big_win_create_info()
	local bg = ZImage:create( self.view, _t_img_bg, 0, 0, width, height - 25, -1,500,500 )

 --    --第二层背景框
	-- local style_ds = CCZXImage:imageWithFile( 0, 0, width,height, UIPOS_TopListWin_0018)
	--       self.view:addChild(style_ds)
    
    --标题背景
	local title_bg = ZImage:create( self.view,UILH_COMMON.title_bg, 0, 0, -1, -1 )
	local title_bg_size = title_bg:getSize()
	title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    
	local t_width = title_bg:getSize().width
	local t_height = title_bg:getSize().height
	self.window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
	self.window_title.view:setAnchorPoint(0.5,0.5)
	   

    --关闭按钮
	local function _close_btn_fun()
		Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
		UIManager:hide_window(window_name)
	end

	self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
	--self._exit_btn:setAnchorPoint(0.5,0.5)
	local exit_btn_size = self._exit_btn:getSize()
	self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height-20)

end

function NormalStyleWindow:setExitBtnFun(tFun)
	self._exit_btn:setTouchClickFun(tFun)
end
