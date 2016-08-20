----JiShouShangJiaModel.lua
----HJH
----2013-7-25
----
JiShouShangJiaModel = {}
local cur_ji_shou_shang_jia_select_page = 1
--local _cur_item_info = nil
local _page_one_info = { cur_item_info = nil, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
local _page_two_info = { sell_price = 0, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
local _page_three_info_init = false
local _page_three_info = {}
local _max_bao_guan_fei_num = 20000
local _max_ji_shou_num = 12
local _page_one_ji_shou_state = 0
local _page_two_ji_shou_state = 0
local _init_ji_shou_shang_jia = true
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
---
function JiShouShangJiaModel:get_init_ji_shou_shang_jia()
	return _init_ji_shou_shang_jia
end
-------------------------------------------------
---
function JiShouShangJiaModel:set_init_ji_shou_shang_jia(result)
	_init_ji_shou_shang_jia = result
end
-------------------------------------------------
---
function JiShouShangJiaModel:data_add_my_ji_shou_item(item)
	for i = 1, #_page_three_info do
		--print("_page_three_info[i].handle,item.handle",_page_three_info[i].handle,item.handle)
		if _page_three_info[i].handle == item.handle then
			_page_three_info[i] = nil
			_page_three_info[i] = item
		end
	end
	table.insert( _page_three_info, item )
end
-------------------------------------------------
---
function JiShouShangJiaModel:data_delete_my_ji_shou_item(handle)
	for i = 1, #_page_three_info do
		if _page_three_info[i].handle == handle then
			table.remove(_page_three_info, i )
			return true
		end
	end
	return false
end
-------------------------------------------------
---
function JiShouShangJiaModel:data_find_my_ji_shou_item(handle)
	for i = 1, #_page_three_info do
		if _page_three_info[i].handle == handle then
			return _page_three_info[i]
		end
	end
	return nil
end
-------------------------------------------------
---
function JiShouShangJiaModel:check_can_ji_shou()
	if #_page_three_info >= _max_ji_shou_num then
		return false
	else
		return true
	end
end
function JiShouShangJiaModel:get__page_three_info_len(  )
	return  #_page_three_info
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
-------------------------------------------------
function JiShouShangJiaModel:fini( ... )
	cur_ji_shou_shang_jia_select_page = 1
	_init_ji_shou_shang_jia = false
	_page_one_info = nil
	_page_one_info = { cur_item_info = nil, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
	_page_two_info = nil
	_page_two_info = { sell_price = 0, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
	_page_three_info_init = false
	_page_three_info = nil
	_page_three_info = {}
end
-------------------------------------------------
---
function JiShouShangJiaModel:set_page_one_ji_shou_state(state)
	_page_one_ji_shou_state = state
end
-------------------------------------------------
---
function JiShouShangJiaModel:get_page_one_ji_shou_state()
	return _page_one_ji_shou_state
end
-------------------------------------------------
---
function JiShouShangJiaModel:set_page_two_ji_shou_state(state)
	_page_two_ji_shou_state = state
end
-------------------------------------------------
---
function JiShouShangJiaModel:get_page_two_ji_shou_state()
	return _page_two_ji_shou_state
end
-------------------------------------------------
---
function JiShouShangJiaModel:sum_bao_guan_fei(info, offset)
	if info == nil then
		return 0
	end
	local toffset = offset
	if offset == nil then
		toffset = false
	end
	local price = 0
	print("toffset,info.radio_select, info.all_sell_price, info.time",toffset,info.radio_select, info.all_sell_price, info.time)
	if toffset == false then 
		if info.radio_select == 3 then --yb
			price = info.all_sell_price * 10 * ( info.time / 24 )
		else
			price = info.all_sell_price * 0.01 * ( info.time / 24 )
		end
	else
		if info.radio_select == 1 then --yb
			price = info.all_sell_price * 10 * ( info.time / 24 )
		else
			price = info.all_sell_price * 0.01 * ( info.time / 24 )
		end
	end	
	price = math.ceil( price )
	if price <= 0 then
		price = 1
	end
	if price > _max_bao_guan_fei_num then
		price = _max_bao_guan_fei_num
	end
	return price
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
---
function JiShouShangJiaModel:set_page_one_radio_button_select_fun(index)
	_page_one_info.radio_select = index
	JiShouCC:send_calculate_money( _page_one_info.time * 60 * 60 , _page_one_info.radio_select, _page_one_info.all_sell_price )
	--_page_one_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_one_info )
	-- local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	-- if ji_shou_shang_jia_win ~= nil then
	-- 	ji_shou_shang_jia_win:set_ji_shou_wu_pin_bao_guan_fei_num(_page_one_info.baoguanfei)
	-- end
end
-------------------------------------------------
---
function JiShouShangJiaModel:set_page_one_item_info(info)
	_page_one_info.cur_item_info = info
end
-------------------------------------------------
---
function JiShouShangJiaModel:get_page_one_item_info()
	return _page_one_info.cur_item_info
end
-------------------------------------------------
---
function JiShouShangJiaModel:clear_page_one_item_info()
	_page_one_info.cur_item_info = nil
end
-------------------------------------------------
---
function JiShouShangJiaModel:set_page_one_time(index)
	_page_one_info.time = index
	_page_one_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_one_info )
	JiShouCC:send_calculate_money( _page_one_info.time * 60 * 60 , _page_one_info.radio_select, _page_one_info.all_sell_price )
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		--ji_shou_shang_jia_win:set_ji_shou_wu_pin_bao_guan_fei_num( _page_one_info.baoguanfei )
		ji_shou_shang_jia_win:set_ji_shou_wu_pin_time( index )
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:get_cur_ji_shou_shang_jia_select_page()
	return cur_ji_shou_shang_jia_select_page
end
-------------------------------------------------
---
function JiShouShangJiaModel:set_cur_ji_shou_shang_jia_select_page(index)
	cur_ji_shou_shang_jia_select_page = index
end
-------------------------------------------------
---
function JiShouShangJiaModel:exit_fun()
	UIManager:hide_window("ji_shou_shang_jia_win")
end
-------------------------------------------------
---
function JiShouShangJiaModel:auto_add_my_item_info(info)
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		if _page_one_info.cur_item_info ~= nil then
			BagModel:hide_item_color_cover( _page_one_info.cur_item_info.series )
		end
		JiShouShangJiaModel:set_page_one_item_info(info)
		BagModel:set_item_color_cover(info.series)
		ji_shou_shang_jia_win:set_ji_shou_wu_pin_item_info(info)
	end
end
-------------------------------------------------
---寄售框
function JiShouShangJiaModel:set_page_one_sell_all_price()
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		local price = ji_shou_shang_jia_win:get_ji_shou_wu_pin_all_sell_price()
		_page_one_info.all_sell_price = price
		ji_shou_shang_jia_win:set_ji_shou_wu_pin_all_sell_price_num(price)
		JiShouCC:send_calculate_money( _page_one_info.time * 60 * 60, _page_one_info.radio_select, _page_one_info.all_sell_price )
		-- _page_one_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_one_info )
		-- ji_shou_shang_jia_win:set_ji_shou_wu_pin_bao_guan_fei_num(_page_one_info.baoguanfei)
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:page_one_reset_btn_fun()
	if _page_one_info.cur_item_info ~= nil then
		BagModel:hide_item_color_cover( _page_one_info.cur_item_info.series )
	end
	_page_one_info = { cur_item_info = nil, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		ji_shou_shang_jia_win:clear_ji_shou_wu_pin_page_info()
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:page_one_ji_shou_btn_fun()
	if _page_one_info ~= nil then
		if  JiShouShangJiaModel:check_can_ji_shou() == true then
			if _page_one_info.cur_item_info == nil then
				GlobalFunc:create_screen_notic(Lang.jiShouShangJia.tips1) -- "请先选择寄售的物品"
				return
			end
			if _page_one_info.all_sell_price <= 0 then
				GlobalFunc:create_screen_notic(Lang.jiShouShangJia.tips2) -- "请输入寄售总价"
				return
			end
			local item_name = ItemConfig:get_item_name_by_item_id( _page_one_info.cur_item_info.item_id )
			local item_quality = _page_one_info.cur_item_info.quality + 1
			if item_quality <= 0 then
				item_quality = 1 
			elseif item_quality > 6 then
				item_quality = 6
			end
			print(" item_name,_page_one_info.cur_item_info.quality",item_name,item_quality)
			local temp_name = string.format("%s%s%s","#c",ItemConfig:get_item_color( item_quality ), item_name)
			local temp_notic = string.format(Lang.jiShouShangJia.page_one.send_notic, _page_one_info.cur_item_info.count, temp_name,
			 _page_one_info.all_sell_price, _static_money_type[_page_one_info.radio_select] )
			local function confirm_fun()
				local player = EntityManager:get_player_avatar()
				local cur_yb = player.yuanbao
				local cur_yl = player.yinliang
				if _page_one_info.baoguanfei > cur_yl then
					-- GlobalFunc:create_screen_notic( string.format(Lang.jiShouShangJia.tips3,_page_one_info.baoguanfei) ) -- [342]="你的银两不足，要寄售本物品需要银两%d"

					--天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
		       	 	 ConfirmWin2:show( nil, 15, string.format(Lang.jiShouShangJia.tips3,_page_one_info.baoguanfei) ,  need_money_callback, nil, nil )
					return false
				else
					JiShouShangJiaModel:set_page_one_ji_shou_state(1)
					JiShouCC:send_item_info(_page_one_info.cur_item_info.series, 0, 0, _page_one_info.time * 60 * 60 ,
					 _page_one_info.all_sell_price, _page_one_info.radio_select, _page_one_info.baoguanfei )
				end
			end
			NormalDialog:show(temp_notic,confirm_fun)
		else
			GlobalFunc:create_screen_notic(Lang.jiShouShangJia.tips4) -- [343]="您的摊位已满，不能寄售新物品"
		end
	end
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
--
function JiShouShangJiaModel:set_page_two_sell_ji_shou_sell_num()
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		local price = ji_shou_shang_jia_win:get_ji_shou_huo_bi_sell_num()
		_page_two_info.sell_price = price
		ji_shou_shang_jia_win:set_ji_shou_huo_bi_sell_num(price)
		JiShouCC:send_calculate_money( _page_two_info.time * 60 * 60, _page_two_info.radio_select, _page_two_info.all_sell_price )
		-- print("_page_two_info.time, _page_two_info.all_sell_price", _page_two_info.time, _page_two_info.all_sell_price)
		-- _page_two_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_two_info, true )
		-- print("JiShouShangJiaModel:set_page_two_sell_ji_shou_sell_num _page_two_info.baoguanfei",_page_two_info.baoguanfei)
		-- ji_shou_shang_jia_win:set_ji_shou_huo_bi_bao_guan_hui_num(_page_two_info.baoguanfei)
		-- _page_two_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_one_info )
		-- ji_shou_shang_jia_win:set_ji_shou_wu_pin_bao_guan_fei_num(_page_one_info.baoguanfei)
	end
end
-------------------------------------------------
--
function JiShouShangJiaModel:set_page_two_sell_all_price()
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		local price = ji_shou_shang_jia_win:get_ji_shou_huo_bi_price_num()
		_page_two_info.all_sell_price = price
		ji_shou_shang_jia_win:set_ji_shou_huo_bi_price_num(price)
		local buy_type
		if _page_two_info.radio_select == 3 then
			buy_type = 1
		else
			buy_type = 3
		end
		JiShouCC:send_calculate_money( _page_two_info.time * 60 * 60 , buy_type, _page_two_info.all_sell_price )
		-- print("_page_two_info.time, _page_two_info.all_sell_price", _page_two_info.time, _page_two_info.all_sell_price)
		-- _page_two_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_two_info, true )
		-- print("JiShouShangJiaModel:set_page_two_sell_all_price _page_two_info.baoguanfei",_page_two_info.baoguanfei)
		-- ji_shou_shang_jia_win:set_ji_shou_huo_bi_bao_guan_hui_num(_page_two_info.baoguanfei)
	end
end
-------------------------------------------------
--
function JiShouShangJiaModel:set_page_two_radio_button_select_fun(index)
	_page_two_info.radio_select = index
	local buy_type
	if _page_two_info.radio_select == 3 then
		buy_type = 1
	else
		buy_type = 3
	end
	JiShouCC:send_calculate_money( _page_two_info.time * 60 * 60 , buy_type, _page_two_info.all_sell_price )
	-- _page_two_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_two_info, true )
	-- local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	-- if ji_shou_shang_jia_win ~= nil then
	-- 	ji_shou_shang_jia_win:set_ji_shou_huo_bi_bao_guan_hui_num(_page_two_info.baoguanfei)
	-- end
end
-------------------------------------------------
--
function JiShouShangJiaModel:set_page_two_time(index)
	_page_two_info.time = index
	local buy_type
	if _page_two_info.radio_select == 3 then
		buy_type = 1
	else
		buy_type = 3
	end
	JiShouCC:send_calculate_money( _page_two_info.time * 60 * 60, buy_type, _page_two_info.all_sell_price )
	_page_two_info.baoguanfei = JiShouShangJiaModel:sum_bao_guan_fei( _page_two_info, true )
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		--ji_shou_shang_jia_win:set_ji_shou_huo_bi_bao_guan_hui_num( _page_two_info.baoguanfei )
		ji_shou_shang_jia_win:set_ji_shou_huo_bi_time( index )
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:page_two_reset_btn_fun()
	_page_two_info = { sell_price = 0, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		ji_shou_shang_jia_win:clear_ji_shou_huo_bi_page_info()
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:page_two_ji_shou_btn_fun()
	if _page_two_info ~= nil then
		local buy_type = nil
		local sell_name = ""
		local price_name = ""
		if _page_two_info.radio_select == 3 then
			sell_name = Lang.normal[4] -- [344]="元宝"
			price_name = Lang.normal[1] -- [8]="银两"
			buy_type = 1
		else
			sell_name = Lang.normal[1] -- [8]="银两"
			price_name = Lang.normal[4] -- [344]="元宝"
			buy_type = 3
		end
		if _page_two_info.sell_price <= 0 then
			GlobalFunc:create_screen_notic(Lang.jiShouShangJia.tips5) -- [345]="请输入要寄售的金额"
			return
		end
		if _page_two_info.all_sell_price <= 0 then
			GlobalFunc:create_screen_notic(Lang.jiShouShangJia.tips2) -- [341]="请输入寄售总价"
			return
		end
		if JiShouShangJiaModel:check_can_ji_shou() == false then
			GlobalFunc:create_screen_notic(Lang.jiShouShangJia.tips4) -- [343]="您的摊位已满，不能寄售新物品"
			return
		end
		local function confirm_fun()
			JiShouShangJiaModel:set_page_two_ji_shou_state(1)
			JiShouCC:send_item_info(0, _page_two_info.sell_price, _page_two_info.radio_select, _page_two_info.time * 60 * 60 ,
			 _page_two_info.all_sell_price, buy_type, _page_two_info.baoguanfei )
		end
		NormalDialog:show( string.format( Lang.jiShouShangJia.page_two.send_notic,_page_two_info.sell_price, sell_name, _page_two_info.all_sell_price, price_name ),confirm_fun)
	end
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
---
function JiShouShangJiaModel:my_ji_shou_result( result, info )
	if result > 0 then		
		JiShouModel:init_serch_page_info()
		local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
		if ji_shou_win ~= nil then
			local cur_page_select = JiShouModel:get_cur_top_page_select()
			ji_shou_win:change_page(cur_page_select)
		end
		_page_three_info_init = false
		_page_three_info = nil
		_page_three_info = {}
		JiShouShangJiaModel:page_one_reset_btn_fun()
		JiShouShangJiaModel:page_two_reset_btn_fun()
		local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
		if ji_shou_shang_jia_win ~= nil then
			ji_shou_shang_jia_win:clear_scroll()
			if cur_ji_shou_shang_jia_select_page == 3 then
				ji_shou_shang_jia_win:change_index_page(cur_ji_shou_shang_jia_select_page)
			end
		end
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:delete_my_ji_shou_item(handle)
	local result = JiShouShangJiaModel:data_delete_my_ji_shou_item( handle ) 
	if result == true then
		local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
		if ji_shou_shang_jia_win ~= nil then
		--GlobalFunc:create_screen_notic("您的物品已下架，返回到您的背包中，请查收")
			ji_shou_shang_jia_win:set_shang_jia_wu_pin_max_num( #_page_three_info )
			ji_shou_shang_jia_win:clear_scroll()
			ji_shou_shang_jia_win:refresh_shang_jia_wu_pin()
		end
	end
end
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
---
function JiShouShangJiaModel:check_my_ji_shou_info()
	print("#########################_page_three_info",#_page_three_info,_page_three_info_init)
	-- if #_page_three_info <= 6 or _page_three_info_init == false then
		JiShouCC:send_get_my_item_list()
	-- end
end
-------------------------------------------------
---
function JiShouShangJiaModel:update_my_ji_shou_info(num, info)
	_page_three_info = nil
	_page_three_info = {}
	_page_three_info_init = true
	for i = 1, num do
		JiShouShangJiaModel:data_add_my_ji_shou_item(info[i])
		--table.insert( _page_three_info, info[i] )
	end
	JiShouShangJiaModel:sort_info_by_time()
	if num > 0 then
		local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
		if ji_shou_shang_jia_win ~= nil then
			ji_shou_shang_jia_win:set_shang_jia_wu_pin_max_num(#_page_three_info)
			ji_shou_shang_jia_win:clear_scroll()
			ji_shou_shang_jia_win:refresh_shang_jia_wu_pin()
		end
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:get_my_ji_shou_item_info()
	return _page_three_info
end
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------
---
function JiShouShangJiaModel:exit_window()
	local ji_shou_shang_jia_win = UIManager:find_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		ji_shou_shang_jia_win:clear_ji_shou_wu_pin_page_info()
		ji_shou_shang_jia_win:clear_ji_shou_huo_bi_page_info()
	end
	_page_one_info = { cur_item_info = nil, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
	_page_two_info = { sell_price = 0, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
	BagModel:set_all_item_enable()
	BagModel:hide_all_item_color_cover()
	BagModel:disable_cur_active_window()
	UIManager:hide_window("ji_shou_shang_jia_win")
	UIManager:show_window("ji_shou_win")	
end
-------------------------------------------------
---
function JiShouShangJiaModel:open_window(show)
	if show == true then
		local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
		if ji_shou_shang_jia_win ~= nil then
			ji_shou_shang_jia_win:change_index_page(cur_ji_shou_shang_jia_select_page)
			local bag_win = UIManager:show_window("bag_win")
			BagModel:set_lock_item_disable()
			BagModel:set_cur_active_window(ji_shou_shang_jia_win)
			-- 停止AI
			AIManager:set_AIManager_idle(  )
			EntityManager:get_player_avatar():stop_all_action(  )
		end
	else
		local ji_shou_shang_jia_win = UIManager:find_window("ji_shou_shang_jia_win")
		if ji_shou_shang_jia_win ~= nil then
			ji_shou_shang_jia_win:clear_ji_shou_wu_pin_page_info()
			ji_shou_shang_jia_win:clear_ji_shou_huo_bi_page_info()
		end
		_page_one_info = { cur_item_info = nil, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
		_page_two_info = { sell_price = 0, all_sell_price = 0, radio_select = 3, baoguanfei = 0, time = 12 }
		BagModel:set_all_item_enable()
		BagModel:hide_all_item_color_cover()
		BagModel:disable_cur_active_window()
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:update_bao_guan_fei(num)
	if cur_ji_shou_shang_jia_select_page == 1 then
		_page_one_info.baoguanfei = num
	elseif cur_ji_shou_shang_jia_select_page == 2 then
		_page_two_info.baoguanfei = num
	end
	local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
	if ji_shou_shang_jia_win ~= nil then
		if cur_ji_shou_shang_jia_select_page == 1 then
			ji_shou_shang_jia_win:set_ji_shou_wu_pin_bao_guan_fei_num(num)
		elseif cur_ji_shou_shang_jia_select_page == 2 then
			ji_shou_shang_jia_win:set_ji_shou_huo_bi_bao_guan_hui_num(num)
		end
	end
end
-------------------------------------------------
---
function JiShouShangJiaModel:sort_info_by_time()
	local function sort_fun(a, b)
		if a.reset_time ~= nil and b.reset_time ~= nil then
			if a.reset_time > b.reset_time then
				return true
			else
				return false
			end
		end
	end
	table.sort( _page_three_info, sort_fun )
end
