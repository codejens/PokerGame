-- WindowExten.lua
-- created by HJH on 2014-9-22
--适用范围：需要标题和关闭按钮的页面可继承
require "UI/component/Window"

super_class.SHJStyleWindow(Window)

--关闭按钮
local _exit_btn_info = { img = "sui/public/close_btn.png", z = 1000, width = -1, height = -1 }

function SHJStyleWindow:__init( window_name, texture_name, is_grid, width, height,title_text,title )

    ----print("title",title,width, height)
    if width >600 then  --大页面
    	self.bg_img = ZImage:create( self.view, "sui/common/win_panel.png", 0, 0, width, height, -1,500,500 )
    else
    	self.bg_img = ZImage:create( self.view, "sui/common/win_panel.png", 0, 0, width-12, height-10, -1,500,500 )
    	self.window_title = ZImage:create(self.bg_img, title_text ,0,  0, 305,-1,999 );
		self.window_title.view:setAnchorPoint(0,0.5)

	    local  bg_img_size = self.bg_img:getSize()
	    --标题背景
		local title_size = self.window_title:getSize()
		if width >600 then
	        self.window_title:setPosition(bg_img_size.width/2 -title_size.width/2+15,bg_img_size.height-title_size.height+3)
		else
			self.window_title:setPosition(bg_img_size.width/2 -title_size.width/2,bg_img_size.height-title_size.height+28)
		end

    end

    

    --关闭按钮
	local function _close_btn_fun()
		Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
		UIManager:hide_window(window_name)
	end

	self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
	local exit_btn_size = self._exit_btn:getSize()

	if width >600 then
        self._exit_btn:setPosition(823,556)
	else
		self._exit_btn:setPosition( width - exit_btn_size.width-65+35 , height - exit_btn_size.height-47+30)
	end


	

end

function SHJStyleWindow:setExitBtnFun(tFun)
	self._exit_btn:setTouchClickFun(tFun)
end
