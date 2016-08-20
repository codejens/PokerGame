----JiShouShangJiaWin.lua
----HJH
----2013-7-25
----
super_class.JiShouShangJiaWin(NormalStyleWindow)
local _cur_active_page = nil
-----------------------------------------
-----------------------------------------
local function create_panel( self, width, height )
	require "UI/JiShou/JiShouShangJiaItem"
	require "UI/JiShou/JiShouShangJiaMoney"
	require "UI/JiShou/JiShouShangJiaViewItem"
	----------------------------
	-- local _exit_info = { width = -1, height = -1, fun =  JiShouShangJiaModel.exit_fun,
	-- 					image = { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" } }
	-- local _title_info = { width = -1, height = -1, image_bg = UIResourcePath.FileLocate.common .. "win_title1.png",
	-- 					 title = UIResourcePath.FileLocate.jiShou .. "jssj_title.png" }
	local _tab_info = { width = -1, height = -1, 
						button = { UILH_COMMON.tab_gray, UILH_COMMON.tab_light},
						title = Lang.jiShou.shangjia_tab,
					 }
	local _radio_button_info = { width = 103, height = 45, addType = 0 }

	-----------------------------
	---title
	-- self.title = ZImageImage:create( nil, _title_info.title, _title_info.image_bg, 0, 0, _title_info.width, _title_info.height )
	-- self.title:setGapSize(-6, 0)
	-- self:addChild( self.title.view )
	-- local title_size = self.title.view:getSize()
	-- self.title:setPosition( (width - title_size.width) / 2, height - title_size.height )
	-----------------------------
	---tab 分页按钮
	self.radio_button = ZRadioButtonGroup:create( nil, 15, 513, _radio_button_info.width*3, _radio_button_info.height, _radio_button_info.addType )
	self:addChild( self.radio_button.view )
	for i = 1, #_tab_info.title do
		-- local temp_btn = ZImageButton:create( nil, _tab_info.button, _tab_info.title[i], nil, 0, 0, _tab_info.width, _tab_info.height )
		-- local temp_btn = ZTextButton:create(nil, _tab_info.title[i], _tab_info.button, nil, 0, 0, -1, 45)
		local temp_btn = ZButton:create(nil, _tab_info.button, nil, 0, 0, -1, 45)
		local lab = ZLabel:create(temp_btn.view, _tab_info.title[i], 50, 11, 16, ALIGN_CENTER)
		self.radio_button:addItem( temp_btn, 2)
		-- temp_btn:set_image_gapsize(0, 0)
		local function tab_fun()
			local cur_index = i
			local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
			if ji_shou_shang_jia_win ~= nil then
				ji_shou_shang_jia_win:change_index_page(cur_index)
				JiShouShangJiaModel:set_cur_ji_shou_shang_jia_select_page(cur_index)
			end
		end
		temp_btn:setTouchClickFun(tab_fun)
	end

	----------------------------
	----
	self.ji_shou_wu_pin_page = JiShouShangJiaItem( "JiShouShangJiaItem", "", true, 410, 498 )
	self:addChild( self.ji_shou_wu_pin_page.view )
	self.ji_shou_wu_pin_page.view:setPosition( 0, 0 )
	---------------------------
	----
	self.ji_shou_huo_bi_page = JiShouShangJiaMoney( "JiShouShangJiaMoney", "", true,  410, 498 )
	self:addChild( self.ji_shou_huo_bi_page.view )
	self.ji_shou_huo_bi_page.view:setPosition( 0, 0 )
	---------------------------
	---
	self.shang_jia_wu_pin_page = JiShouShangJiaViewItem("JiShouShangJiaViewItem","", true,  400, 488 )
	self:addChild( self.shang_jia_wu_pin_page.view )
	self.shang_jia_wu_pin_page.view:setPosition( 0, 0 )

	---exit btn
	-- self.exit = ZButton:create( nil, _exit_info.image, _exit_info.fun, 0, 0, -1, -1 )
	-- self:addChild(self.exit.view)
	-- --self.exit:setTouchClickFun()
	-- local exit_size = self.exit:getSize()
	-- self.exit:setPosition( width - exit_size.width, height - exit_size.height )
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:__init(window_name, texture_name, is_grid, width, height)
	print("window_info",window_name,width,texture_name)
	create_panel( self, width, height)
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:change_index_page(index)
	self.radio_button:selectItem(index - 1)
	JiShouShangJiaModel:set_cur_ji_shou_shang_jia_select_page(index)
	local temp_page = { self.ji_shou_wu_pin_page, self.ji_shou_huo_bi_page, self.shang_jia_wu_pin_page }
	if index > #temp_page then
		return
	end
	for i = 1, #temp_page do
		if i == index then
			if temp_page[i] ~= nil then
				temp_page[i].view:setIsVisible(true)
				_cur_active_page = temp_page[i]
				if temp_page[i] == self.shang_jia_wu_pin_page then
					JiShouShangJiaModel:check_my_ji_shou_info()
				else
					if temp_page[i] == self.ji_shou_wu_pin_page then
						JiShouShangJiaModel:page_one_reset_btn_fun()
					elseif temp_page[i] == self.ji_shou_huo_bi_page then
						JiShouShangJiaModel:page_two_reset_btn_fun()
					end
				end
			end
		else
			if temp_page[i] ~= nil then
				temp_page[i].view:setIsVisible(false)
			end
			if temp_page[i] == self.ji_shou_wu_pin_page then
				JiShouShangJiaModel:page_one_reset_btn_fun()
			elseif temp_page[i] == self.ji_shou_huo_bi_page then
				JiShouShangJiaModel:page_two_reset_btn_fun()
			end
		end
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:destroy()
	local temp_page = { self.ji_shou_wu_pin_page, self.ji_shou_huo_bi_page, self.shang_jia_wu_pin_page }
	Window.destroy( self )
	for i = 1, #temp_page do
		if temp_page[i] ~= nil then
			temp_page[i]:destroy()
		end
	end
	BagModel:set_all_item_enable()
	BagModel:hide_all_item_color_cover( )
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:active(show)
	if JiShouShangJiaModel:get_init_ji_shou_shang_jia() == false then
		self:clear_ji_shou_wu_pin_page_info()
		--------
		self:clear_ji_shou_huo_bi_page_info()
		--------
		self:clear_scroll()
		self:refresh_shang_jia_wu_pin()
		JiShouShangJiaModel:set_init_ji_shou_shang_jia(true)
	end
	JiShouShangJiaModel:open_window(show)
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_wu_pin_item_info( info )
	if self.ji_shou_wu_pin_page ~= nil and _cur_active_page == self.ji_shou_wu_pin_page then
		self.ji_shou_wu_pin_page:update_item_info(info)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:get_ji_shou_wu_pin_all_sell_price()
	if self.ji_shou_wu_pin_page ~= nil and _cur_active_page == self.ji_shou_wu_pin_page then
		return self.ji_shou_wu_pin_page:get_sell_price_num()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_wu_pin_all_sell_price_num(num)
	if self.ji_shou_wu_pin_page ~= nil and _cur_active_page == self.ji_shou_wu_pin_page then
		self.ji_shou_wu_pin_page:set_sell_price_num(num)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_wu_pin_bao_guan_fei_num(num)
	if self.ji_shou_wu_pin_page ~= nil and _cur_active_page == self.ji_shou_wu_pin_page then
		self.ji_shou_wu_pin_page:set_bao_guan_fei_num(num)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_wu_pin_time(index)
	if self.ji_shou_wu_pin_page ~= nil and _cur_active_page == self.ji_shou_wu_pin_page then
		self.ji_shou_wu_pin_page:set_time_info(index)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:clear_ji_shou_wu_pin_page_info()
	--if self.ji_shou_wu_pin_page ~= nil and _cur_active_page == self.ji_shou_wu_pin_page then
		self.ji_shou_wu_pin_page:clear_info()
	--end	
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:get_ji_shou_huo_bi_sell_num()
	if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		return self.ji_shou_huo_bi_page:get_sell_num()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_huo_bi_sell_num(num)
	if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		return self.ji_shou_huo_bi_page:set_sell_num(num)
	end	
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:get_ji_shou_huo_bi_price_num()
	if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		return self.ji_shou_huo_bi_page:get_sell_price_num()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_huo_bi_price_num(num)
	if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		return self.ji_shou_huo_bi_page:set_sell_price_num(num)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_huo_bi_bao_guan_hui_num(num)
	if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		return self.ji_shou_huo_bi_page:set_bao_guan_fei_num(num)
	end	
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_ji_shou_huo_bi_time(index)
	if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		return self.ji_shou_huo_bi_page:set_time_info(index)
	end	
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:clear_ji_shou_huo_bi_page_info()
	--if self.ji_shou_huo_bi_page ~= nil and _cur_active_page == self.ji_shou_huo_bi_page then
		self.ji_shou_huo_bi_page:clear_info()
	--end	
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:set_shang_jia_wu_pin_max_num(num)
	if self.shang_jia_wu_pin_page ~= nil and _cur_active_page == self.shang_jia_wu_pin_page then
		self.shang_jia_wu_pin_page:set_scroll_max_num(num)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:refresh_shang_jia_wu_pin()
	if self.shang_jia_wu_pin_page ~= nil and _cur_active_page == self.shang_jia_wu_pin_page then
		self.shang_jia_wu_pin_page:refresh_scroll()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaWin:clear_scroll()
	--if self.shang_jia_wu_pin_page ~= nil and _cur_active_page == self.shang_jia_wu_pin_page then
		self.shang_jia_wu_pin_page:clear_scroll()
	--end
end