--SHJStyleWindow.lua
--功能：需要标题和关闭按钮的页面可继承
--修改：SJS
--时间：2016-03-14

require "UI/component/Window"

super_class.SHJStyleWindow(Window)

--关闭按钮
local _exit_btn_info = {img = "sui/common/close.png", z = 1000, width = -1, height = -1}

function SHJStyleWindow:__init(window_name, texture_name, is_grid, width, height, title_text, title)
	--大页面
    if width >600 then
    	self.bg_img = ZImage:create(self.view, "sui/common/win_panel.png", 0, 0, width, height, -1, 500, 500)
    --小页面
    else
    	self.bg_img = ZImage:create(self.view, "sui/common/tipsPanel.png", 0, 0, width-52, height-14, -1, 500, 500)
    	self.window_title = ZImage:create(self.bg_img, title_text, (width-52)/2, height-1, width-34, 53, 2, 55, 11, 55, 11, 55, 41, 55, 41)
		self.window_title.view:setAnchorPoint(0.5, 1)
		self.window_title1 = ZImage:create(self.bg_img, "sui/common/title_panel.png", (width-52)/2, height-4, width-46, 60, 1, 43, 1, 43, 1, 43, 55, 43, 55)
		self.window_title1.view:setAnchorPoint(0.5, 1)
		self.window_title2 = ZImage:create(self.window_title1, "sui/common/little_win_title_bg2.png", width-78, 63, 70, -1, -1)
		self.window_title2.view:setAnchorPoint(0, 1)
		self.window_title3 = ZImage:create(self.view, "sui/common/menu_line.png", 463, 606, -1, 214, -3)
		self.window_title3.view:setAnchorPoint(0.5, 1)
    end
    --关闭按钮
	local function _close_btn_fun()
		if window_name == "bag_win" then
			UIManager:hide_window("shop_win")
		end
		UIManager:hide_window(window_name)
		SoundManager:play_ui_effect( 3 )
	end
	self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun, 0, 0, _exit_btn_info.width, _exit_btn_info.height, _exit_btn_info.z)
	local exit_btn_size = self._exit_btn:getSize()
	if width >600 then
        self._exit_btn:setPosition(823,558)
	else
		self._exit_btn:setPosition(width-exit_btn_size.width-70, height-exit_btn_size.height+5)
	end
end

function SHJStyleWindow:setExitBtnFun(tFun)
	self._exit_btn:setTouchClickFun(tFun)
end
