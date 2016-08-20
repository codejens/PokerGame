-----------------------------------------------
-----------------------------------------------
---------HJH
---------2013-5-29
---------充值界面
-----------------------------------------------
-----------------------------------------------
super_class.ChongZhiPage(Window)
--require "UI/chongzhi/ChongZhiJiLuWin"
require "UI/chongzhi/ChongZhiKaWin"
require "UI/chongzhi/ZhiFuBaoPageWin"
require "UI/chongzhi/CreditCardWin"
function ChongZhiPage:__init( window_name, texture_name, pos_x, pos_y, width, height )
end
-----------------------------------------------
-----------------------------------------------
super_class.ChongZhiWin(Window)
-----------------------------------------------
-----------------------------------------------
local function create_chongzhi_panel(self, width, height)
	-----------------------------------------------
	-- self.title = Image:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.chongZhi .. "title.png" )
	-- local title_size = self.title:getSize()
	-- self.title:setPosition( (width - title_size.width) * 0.5, height - 60 )
	-- -----------------------------------------------
	-- self.exit = ZButton:create( nil, UIResourcePath.FileLocate.chongZhi .. "exit.png" , nil, 0, 0, -1, -1)
	-- local exit_size = self.exit:getSize()
	-- self.exit:setPosition( width - exit_size.width, height - exit_size.height )
	-- self.exit:setTouchClickFun( ChongZhiModel.exit_function )
	
	-- Hcl on 2013/11/11
	self.exit_btn:setTouchClickFun( ChongZhiModel.exit_function )
	-----------------------------------------------
	self.chong_zhi_notic = ZLabel:create( nil, LangGameString[750], 28, height - 75, 18 ) -- [750]="选择充值方式"
	local chong_zhi_notic_pos = self.chong_zhi_notic:getPosition()
	-----------------------------------------------
	self.page_info = {}
	-- local text_button_font_size = 10
	-- local radio_group_info = { width = 155, height = 280, add_type = 1, image = "" }
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	-- self.radio_button = RadioButton:create( nil, chong_zhi_notic_pos.x -8 , chong_zhi_notic_pos.y - 15 - radio_group_info.height, radio_group_info.width, radio_group_info.height
	-- 										, radio_group_info.add_type, radio_group_info.image )
	local button_info = {
						 	-- { text = "充值记录", 	button_fun = ChongZhiModel.chong_zhi_ji_lu_button_function, 	page_fun =  ChongZhiWin.create_chong_zhi_info_page,
						 	-- 	page_info = {}
						 	-- },
						 	{ text = LangGameString[751], page_fun =  ChongZhiWin.create_zhi_fu_bao_page, 	 -- [751]="支付宝"
						  		page_info = {button_text = LangGameString[752], -- [752]="#cfff000去支付宝"
						  					chong_zhi_button_fun = ChongZhiModel.zhi_fu_bao_page_button_function
						  					}
						  	},
						 	{ text = LangGameString[753], page_fun =  ChongZhiWin.create_credit_card_page,  -- [753]="信用卡"
							 	page_info = {
							 					button_text_one = LangGameString[754], -- [754]="#cfff000充值"
							 					chong_zhi_button_fun = ChongZhiModel.chong_zhi_button_function,
							 					button_text_two = LangGameString[755], -- [755]="#cfff000解绑"
							 					jie_bang_button_fun = ChongZhiModel.jie_bang_button_function,
							 					button_text_three = LangGameString[756], -- [756]="#cfff000绑卡"
							 					bang_ka_button_fun = ChongZhiModel.bang_ka_button_function,
											}
						 	},
							-- { text = "移动充值卡", page_fun =  ChongZhiWin.create_card_page,
						 -- 		page_info = {
						 -- 					select_info = chong_zhi_info.yi_dong, notic_one_info = "你选择的充值方式为：#cfff000移动充值卡",
							--   				 notic_two_info = "请选择你的充值卡面值",
							-- 				 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info .. "#r#cffffff" .. Lang.chong_zhi_info.yi_dong_warning_info,
							-- 				 --index = 2, 
							-- 				 button_text = "#cfff000支付",
							-- 				 chong_zhi_button_fun = ChongZhiModel.yi_dong_page_button_function
							-- 				}
							-- }, 
						 	{ text = LangGameString[757], page_fun =  ChongZhiWin.create_card_page,  -- [757]="联通一卡付"
							 	page_info = {
							 				 select_info = chong_zhi_info.lian_ton, notic_one_info = LangGameString[758], -- [758]="你选择的充值方式为：#cfff000联通一卡付"
							  				 notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,
											 --index = 3, 
											 button_text = LangGameString[760], -- [760]="#cfff000支付"
											 chong_zhi_button_fun = ChongZhiModel.lian_ton_page_button_function
											}
						 	},
							{ text = LangGameString[761], page_fun =  ChongZhiWin.create_card_page,  -- [761]="电信充值卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.dian_xin, notic_one_info = LangGameString[762], -- [762]="你选择的充值方式为：#cfff000电信充值卡"
							  				 notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,
											 --index = 4, 
											 button_text = LangGameString[760], -- [760]="#cfff000支付"
											 chong_zhi_button_fun = ChongZhiModel.dian_xin_page_button_function
											}
							},
						 	{ text = LangGameString[763], page_fun =  ChongZhiWin.create_card_page,  -- [763]="骏网一卡通"
							 	page_info = {
							 				 select_info = chong_zhi_info.jun_wan, notic_one_info = LangGameString[764], -- [764]="你选择的充值方式为：#cfff000骏网一卡通"
							  				 notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,
											 --index = 5, 
											 button_text = LangGameString[760], -- [760]="#cfff000支付"
											 chong_zhi_button_fun = ChongZhiModel.jun_wang_page_button_function
											}
							},
						 	{ text = LangGameString[765], page_fun = ChongZhiWin.create_card_page, -- [765]="盛大卡"
							 	page_info = {
							 				select_info = chong_zhi_info.sn_da, notic_one_info = LangGameString[766], -- [766]="你选择的充值方式为：#cfff000盛大卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 6,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.sn_da_page_button_function
							 				}
							},
						 	{ text = LangGameString[767], page_fun = ChongZhiWin.create_card_page, -- [767]="神州行"
							 	page_info = { 
							 				select_info = chong_zhi_info.szx, notic_one_info = LangGameString[768], -- [768]="你选择的充值方式为：#cfff000神州行"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 7,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.szx_page_button_function
							 				}
							},
					 		{ text = LangGameString[769], 	page_fun = ChongZhiWin.create_card_page, -- [769]="征途卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.zheng_tu, notic_one_info = LangGameString[770], -- [770]="你选择的充值方式为：#cfff000征途卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 8,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.zheng_tu_page_button_function
							 				}
							},
							{ text = LangGameString[771], page_fun = ChongZhiWin.create_card_page, -- [771]="Q币卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.qq_car, notic_one_info = LangGameString[772], -- [772]="你选择的充值方式为：#cfff000Q币卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 9,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.qq_car_page_button_function
							 				}
							},
							{ text = LangGameString[773],	page_fun = ChongZhiWin.create_card_page, -- [773]="久游卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.jiu_you, notic_one_info = LangGameString[774], -- [774]="你选择的充值方式为：#cfff000久游卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 10,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.jiu_you_page_button_function
							 				}
							},
							{ text = LangGameString[775],	page_fun = ChongZhiWin.create_card_page, -- [775]="易宝e卡通"
							 	page_info = { 
							 				select_info = chong_zhi_info.yp_card, notic_one_info = LangGameString[776], -- [776]="你选择的充值方式为：#cfff000易宝e卡通"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 11,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.yp_card_page_button_function
							 				}
							},
							{ text = LangGameString[777],	page_fun = ChongZhiWin.create_card_page, -- [777]="网易卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.net_ease, notic_one_info = LangGameString[778], -- [778]="你选择的充值方式为：#cfff000网易卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 12,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.net_ease_page_button_function
							 				}
							},
							{ text = LangGameString[779],	page_fun = ChongZhiWin.create_card_page, -- [779]="完美卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.wan_mei, notic_one_info = LangGameString[780], -- [780]="你选择的充值方式为：#cfff000完美卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 13,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.wan_mei_page_button_function
							 				}
							},
							{ text = LangGameString[781], page_fun = ChongZhiWin.create_card_page, -- [781]="搜狐卡"
							 	page_info = { 
							 				select_info = chong_zhi_info.sohu, notic_one_info = LangGameString[782], -- [782]="你选择的充值方式为：#cfff000搜狐卡"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 14,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.sohu_page_button_function
							 				}
							},
							{ text = LangGameString[783], page_fun = ChongZhiWin.create_card_page, -- [783]="纵游一卡通"
							 	page_info = { 
							 				select_info = chong_zhi_info.zong_you, notic_one_info = LangGameString[784], -- [784]="你选择的充值方式为：#cfff000纵游一卡通"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 15,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.zong_you_page_button_function
							 				}
							},
							{ text = LangGameString[785], page_fun = ChongZhiWin.create_card_page, -- [785]="天下一卡通"
							 	page_info = {
							 				 select_info = chong_zhi_info.tian_xia, notic_one_info = LangGameString[786], -- [786]="你选择的充值方式为：#cfff000天下一卡通"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 16,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.tian_xia_page_button_function
							 				}
							},
							{ text = LangGameString[787], page_fun = ChongZhiWin.create_card_page, -- [787]="天宏一卡通"
							 	page_info = { 
							 				select_info = chong_zhi_info.tian_hong, notic_one_info = LangGameString[788], -- [788]="你选择的充值方式为：#cfff000天宏一卡通"
							 				notic_two_info = LangGameString[759], -- [759]="请选择你的充值卡面值"
											 notic_three_info = Lang.chong_zhi_info.yi_dong_chong_info,
											 notic_four_info = Lang.chong_zhi_info.yi_dong_warning_info,							 				--index = 17,
							 				button_text = LangGameString[760], -- [760]="#cfff000支付"
							 				chong_zhi_button_fun = ChongZhiModel.tian_hong_page_button_function
							 				}
							},
						}
	local text_button_font_size = 10
	local text_button_size = { width = 155, height = 38 }
	local radio_group_info = { width = 155, height = 280, add_type = 1, image = "", gapSize = 0 }
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	self.radio_button = RadioButton:create( nil, chong_zhi_notic_pos.x -8 , chong_zhi_notic_pos.y - 15 - radio_group_info.height, radio_group_info.width,
	 										#button_info * text_button_size.height + #button_info * radio_group_info.gapSize,
	 										radio_group_info.add_type, radio_group_info.image )
	local button_list = {}
	for i = 1, #button_info do
		local button = TextButton:create( nil, 0, 0, text_button_size.width, text_button_size.height, button_info[i].text, {UIResourcePath.FileLocate.chongZhi .. "button_n.png", UIResourcePath.FileLocate.chongZhi .. "button_s.png"}, 600, 600 )
		self.radio_button:addItem( button, radio_group_info.gapSize )
		local function button_function()
			local curIndex = i
			local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
			chong_zhi_win:set_index_scroll_show( curIndex )
			chong_zhi_win:refrsh_index_scroll( curIndex )
		end
		local function credit_card_function()
			local curIndex = i
			local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
			chong_zhi_win:set_index_scroll_show( curIndex )
			chong_zhi_win:refrsh_index_scroll( curIndex )
			self.page_info[i]:reinit_info(ChongZhiModel:get_car_id())
		end
		if button_info[i].text == LangGameString[753] then -- [753]="信用卡"
			button:setTouchEndedFun( credit_card_function )
		else
			button:setTouchEndedFun( button_function )
		end
		-----------------------------------------------		
		button_info[i].page_info.page_index = i
		print("button_info[i].page_info",button_info[i].page_info.button_text)
		self.page_info[i] = button_info[i].page_fun(nil,button_info[i].page_info)
		if i == 1 then
			self.page_info[i].view:setIsVisible(true)
		else
			self.page_info[i].view:setIsVisible(false)
		end
		-- if button_info[i].text == "支付宝" then
		-- 	self.page_info[i] = ChongZhiWin:create_zhi_fu_bao_page(button_info[i].page_info)
		-- 	self.page_info[i].view:setIsVisible(true)
		-- elseif button_info[i].text == "信用卡" then
		-- 	self.page_info[i] = ChongZhiWin:c
		-- else
		-- 	-- if i == 2 then
		-- 	-- 	self.page_info[i] = ChongZhiWin:create_zhi_fu_bao_page(button_info[i].page_info)
		-- 	-- else
		-- 		self.page_info[i] = ChongZhiWin:create_card_page(button_info[i].page_info)
		-- 	--end
		-- 	self.page_info[i].view:setIsVisible(true)
		-- end
		self.page_info[i]:setPosition( chong_zhi_notic_pos.x + radio_group_info.width + 5, 25 )
	end
	-----------------------------------------------
	self.scroll = Scroll:create( nil, chong_zhi_notic_pos.x -8 , chong_zhi_notic_pos.y - 15 - radio_group_info.height, 155, 200+90, 1, TYPE_HORIZONTAL )
	self.scroll.view:addItem( self.radio_button.view )
	-----------------------------------------------
	self.view:addChild( self.title.view )
	self.view:addChild( self.exit.view )
	self.view:addChild( self.chong_zhi_notic.view )
	self.view:addChild( self.scroll.view )
	--self.view:addChild( self.radio_button.view )
	for i = 1, #button_info do
		self.view:addChild( self.page_info[i].view )
	end
	-----------------------------------------------
end
-----------------------------------------------
-----------------------------------------------
function ChongZhiWin:__init(window_name, window_info)
	create_chongzhi_panel( self, window_info.width, window_info.height )
end
-----------------------------------------------
-----------------------------------------------
function ChongZhiWin:set_index_scroll_show(index)
	if self.page_info == nil then
		return
	end
	print("set_index_scroll_show", index)
	for i = 1, #self.page_info do
		if i == index then
			self.page_info[i].view:setIsVisible(true)
		else
			self.page_info[i].view:setIsVisible(false)
		end
	end
end
-----------------------------------------------
-----------------------------------------------
function ChongZhiWin:refrsh_index_scroll(index)
	print("run refresh index scroll",index)
	print(self.page_info,self.page_info[index].view,self.page_info[index].scroll)
	if self.page_info == nil or self.page_info[index].view == nil or self.page_info[index].scroll == nil then
		return
	end
	print("run refresh index scroll",index)
	self.page_info[index].scroll:refresh()
end
-----------------------------------------------
function ChongZhiWin:get_scroll_info()
	-- if self.page_info == nil then
	-- 	return
	-- end
	-- local scroll_size = self.page_info[2].scroll.view:getSize()
	local temp_info = { width = 520, height = 320}
	return temp_info
end
-----------------------------------------------
function ChongZhiWin:destroy()
	print("run chong zhi win destroy")
    Window.destroy(self)
    if self.page_info then
    	for i = 1, #self.page_info do
    		if self.page_info[i] ~= nil then
    			self.page_info[i]:destroy()
    		end
        end
    end  
end
-----------------------------------------------
function ChongZhiWin:create_chong_zhi_info_page(info)
	--return ZhiFuBaoPageWin( "", "", 0, 0, 520, 320 + 15 )
	return Scroll:create( nil, 0, 50, 520, 320, 0, TYPE_HORIZONTAL )
end
-----------------------------------------------
function ChongZhiWin:create_zhi_fu_bao_page(info)
	return ZhiFuBaoPageWin( "", {texture = "", x = 0, y = 0, width = 520, height = 320 + 15}, info )
end
-----------------------------------------------
function ChongZhiWin:create_card_page(info)
	return ChongZhiKaWin( "", {texture = "", x = 0, y = 0, width = 520, height = 320 + 15}, info )
end
-----------------------------------------------
function ChongZhiWin:create_credit_card_page(info)
	return CreditCardWin( "", {texture = "", x = 0, y = 0, width = 520, height = 320 + 15} , info )
end
-----------------------------------------------
function ChongZhiWin:clear_index_page_info(index)
	if self.page_info[index] == nil and self.page_info[index].clear_insert_info then
		return nil
	end
	self.page_info[index]:clear_insert_info()
end
-----------------------------------------------
function ChongZhiWin:get_index_page_info(index)
	if self.page_info[index] == nil then
		return nil
	end
	-- if index == 1 then

	-- elseif index >= 2 then
		print("self.page_info[index]", self.page_info[index], self.page_info[index].temp_page_info)
		return self.page_info[index]:get_page_info()
	-- end
	--return nil
end
-----------------------------------------------
function ChongZhiWin:refresh_cur_page()
	if self.page_info == nil then
		return 
	end
	local cur_index = self.radio_button:getCurSelect() + 1	
	self:set_index_scroll_show( cur_index )
	self:refrsh_index_scroll( cur_index )
end
-----------------------------------------------
function ChongZhiWin:active(show)
	if show then
		self:refresh_cur_page()
	end
end
-----------------------------------------------
function ChongZhiWin:clear_insert_info()
	if self.page_info ~= nil then
		for i = 1, #self.page_info do
			if self.page_info[i].clear_insert_info ~= nil then
				self.page_info[i]:clear_insert_info()
			end
		end
	end
end
