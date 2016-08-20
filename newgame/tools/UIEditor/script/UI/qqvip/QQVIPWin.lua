----QQVIPWin.lua
----HJH
----2013-9-15
----
require "UI/qqvip/QQVIPAward"
------
---当前选择面板
local cur_active_index = 1
------
super_class.QQVIPWin(Window)
----------------------------------------
----------------------------------------
function QQVIPWin:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	----------------------------------------
	----标题
	-- local title = ZImageImage:create( nil, UIResourcePath.FileLocate.qqvip .. "title.png", UIResourcePath.FileLocate.common .. "win_title1.png", 0, 0, -1, -1 )
	-- title:setGapSize( -10, 3)
	-- self:addChild( title.view )
	-- local title_size = title.view:getSize()
	-- title:setPosition( (window_info.width - title_size.width) / 2, window_info.height - title_size.height + 10 )
	----------------------------------------
	----QQVIP奖励面板	
	local temp_panel_info = { texture = "", x = -1, y = 2, width = window_info.width, height = window_info.height }
	self.award_panel = QQVIPAward( "", temp_panel_info )
	self:addChild(self.award_panel.view)
	----------------------------------------
	----退出按钮
	-- local exit = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"} , nil, 0, 0, -1, -1)
	-- self:addChild( exit.view )
	-- local exit_size = exit:getSize()
	-- exit:setPosition( width - exit_size.width, height - exit_size.height )
	-- local function exit_btn_fun()
	-- 	UIManager:hide_window("qqvip_win")
	-- end
	-- exit:setTouchClickFun(exit_btn_fun)
end
----------------------------------------
function QQVIPWin:active(show)
	if show == true then
		if QQVIPModel:get_reinit() == true then
			QQVIPModel:reinit_info()
		end
		if cur_active_index == 1 and self.award_panel ~= nil then
			self.award_panel:active_win()
		end
	end
end
----------------------------------------
function QQVIPWin:update_award_win()
	if self.award_panel ~= nil then
		self.award_panel:update_win()
	end
end
----------------------------------------
function QQVIPWin:destroy()
	Window.destroy(self)
	if self.award_panel ~= nil then
		self.award_panel:destroy()
	end
end