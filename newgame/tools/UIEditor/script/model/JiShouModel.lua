----JiShouModel.lua
----HJH
----2013-7-25
----
JiShouModel = {}
-------------------------------
local _last_buy_page_index = nil
local _is_next_not_show = false
-------------------------------
local _index_cur_page_select = { 1, 4, 6, 8, 11, 13, 14, 15, 16 }
-------------------------------
local _id_range = 
{
	{ serch_id = 1, range = { 21 }, is_continuous = false }, ---装备升级
	{ serch_id = 2, range = { 22 }, is_continuous = false }, ---装备提品
	{ serch_id = 3, range = { 23 }, is_continuous = false }, ---装备升阶
	{ serch_id = 4, range = { 24 }, is_continuous = false }, ---宝石
	{ serch_id = 5, range = { 25 }, is_continuous = false }, ---强化材料
	{ serch_id = 6, range = { 26 }, is_continuous = false }, ---法宝材料
	{ serch_id = 7, range = { 27 }, is_continuous = false }, ---翅膀材料
	{ serch_id = 8, range = { 28 }, is_continuous = false }, ---宠物蛋
	{ serch_id = 9, range = { 29 }, is_continuous = false }, ---宠物培养
	{ serch_id = 10, range = { 30 }, is_continuous = false }, ---坐骑培养
	{ serch_id = 11, range = { 31 }, is_continuous = false }, ---人物物品
	{ serch_id = 12, range = { 32 }, is_continuous = false }, ---宠物物品
	{ serch_id = 13, range = { 100003 }, is_continuous = false }, --- 元宝
	{ serch_id = 14, range = { 33 }, is_continuous = false }, ---其他道具
	{ serch_id = -1, range = {}, is_continuous = false },----所有物品
	{ serch_id = -2, range = {}, is_continuous = false },----自定义搜索
}
-------------------------------
local _money_page_index = 13
local _cur_page_select = -1
local _cur_top_page_select = -1
local _static_serch_info_page_num = 4
local _scroll_refresh_limit_time = 10
local _init_page_serch_info = false
local _page_serch_info = {}
-------------------------------------------------
function JiShouModel:fini( ... )
	_last_buy_page_index = nil
	_cur_page_select = -1
	_cur_top_page_select = -1
	_index_cur_page_select = { 1, 4, 6, 8, 11, 13, 14, 15, 16 }
	_init_page_serch_info = false
	_is_next_not_show = false
end
-------------------------------------------------
function JiShouModel:set_is_next_not_show(result)
	_is_next_not_show = result
end
-------------------------------------------------
function JiShouModel:get_is_next_not_show()
	return _is_next_not_show
end
-------------------------------------------------
function JiShouModel:get_init_serch_info()
	return _init_page_serch_info
end
--------------------------------------------------
function JiShouModel:set_init_serch_info(result)
	_init_page_serch_info = result
end
-------------------------------------------------
---初始化搜索信息
function JiShouModel:init_serch_page_info()
	--if _init_page_serch_info == false then
		_page_serch_info = nil 
		_page_serch_info = {}
		for i = 1, #_id_range do
			local temp = JiShouSerchPageInfo( _id_range[i].serch_id, _id_range[i].range, _id_range[i].is_continuous )
			table.insert( _page_serch_info, temp )
		end
		--_init_page_serch_info = true
	--end
end
-------------------------------------------------
---取得index的选定页数值
function JiShouModel:get_index_page_cur_select(index)
	return _index_cur_page_select[index]
end
-------------------------------------------------
function JiShouModel:set_cur_top_page_select(index)
	_cur_top_page_select = index
end
-------------------------------------------------
function JiShouModel:get_cur_top_page_select()
	return _cur_top_page_select
end
-------------------------------------------------
---设置index页选定数值
function JiShouModel:set_index_page_cur_select(index, num)
	_index_cur_page_select[index] = num
end
-------------------------------------------------
---设置指定页是否已发送请求
function JiShouModel:set_index_page_is_send( index, result )
	_page_serch_info[index].is_send = result
end
-------------------------------------------------
---取得ID范围
function JiShouModel:get_id_range_info(info)
	local result = {}
	if info.is_continuous == true then
		result = {}
		local add_index = 0
		for i = info.id_range[1], info.id_range[2] do
			result[add_index + 1] = info.id_range[1] + add_index
			--print("result[add_index + 1]",result[add_index + 1])
			add_index = add_index + 1
		end
	else
		result = info.id_range
	end	
	return result
end
-------------------------------------------------
---取得数据刷新最大时间
function JiShouModel:get_scroll_refresh_limit_time()
	return _scroll_refresh_limit_time
end
-------------------------------------------------
---
function JiShouModel:buy_item(id, handle)
	_last_buy_page_index = _cur_page_select
	JiShouCC:send_buy_item( id, handle )
end
-------------------------------------------------
---设置指定页
function JiShouModel:set_cur_page_select(index)
	-- xprint("index",index)
	-- if _cur_page_select == index then
	-- 	return
	-- end
	_cur_page_select = index
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		local is_init = _page_serch_info[index].init 
		print("is_init",is_init,index)
		if is_init == false or os.time() - _page_serch_info[index].refresh_time > _scroll_refresh_limit_time then
			JiShouModel:init_serch_page_info()
			_page_serch_info[index].init = true
			if index~=16 then
				JiShouModel:get_index_page_info(_cur_page_select)
			end
		end
		ji_shou_win:set_scroll_max_num( _page_serch_info[index].max_num )
		ji_shou_win:clear_scroll()
		if is_init == true then
			ji_shou_win:refresh_scroll()
		end
	end
end
-------------------------------------------------
---
function JiShouModel:reset_btn_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page( ji_shou_win:get_special_page_index() )
	end
end
-------------------------------------------------
---模糊搜索
function JiShouModel:serch_but_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win == nil then
		return
	end
	local serch_text = ji_shou_win:get_serch_text()
end
-------------------------------------------------
---取得当前选择页
function JiShouModel:get_cur_page_select()
	return _cur_page_select
end
-------------------------------------------------
---
function JiShouModel:data_check_index_page_serch_info_exist(index, info)
	for i = 1, #_page_serch_info[index].info do
		if _page_serch_info[index].info[i].handle == info.handle then
			return true
		end
	end
	return false
end
-------------------------------------------------
---
function JiShouModel:data_add_page_serch_info_to_special( page_index, max_num, info )
	local temp_index = 15
	for i = 1, #info do
		if JiShouModel:data_check_index_page_serch_info_exist( temp_index, info[i] ) == false then
			table.insert( _page_serch_info[temp_index].info, info[i] )
		end
	end
	_page_serch_info[temp_index].max_page = max_num
	local temp_index_page_info_num = #_page_serch_info[temp_index].info
	if max_num * _static_serch_info_page_num - temp_index_page_info_num < _static_serch_info_page_num then
		_page_serch_info[temp_index].max_num = temp_index_page_info_num
	else
		_page_serch_info[temp_index].max_num = max_num * _static_serch_info_page_num
	end
	_page_serch_info[temp_index].last_serch_index = page_index
	_page_serch_info[temp_index].refresh_time = os.time()
	_page_serch_info[temp_index].is_send = false
	return temp_index
end
-- 自定义搜索
function JiShouModel:data_add_page_serch_info_to_custom( page_index, max_num, info )
	local temp_index = 16
	for i = 1, #info do
		if JiShouModel:data_check_index_page_serch_info_exist( temp_index, info[i] ) == false then
			table.insert( _page_serch_info[temp_index].info, info[i] )
		end
	end
	_page_serch_info[temp_index].max_page = max_num
	local temp_index_page_info_num = #_page_serch_info[temp_index].info
	if max_num * _static_serch_info_page_num - temp_index_page_info_num < _static_serch_info_page_num then
		_page_serch_info[temp_index].max_num = temp_index_page_info_num
	else
		_page_serch_info[temp_index].max_num = max_num * _static_serch_info_page_num
	end
	_page_serch_info[temp_index].last_serch_index = page_index
	_page_serch_info[temp_index].refresh_time = os.time()
	_page_serch_info[temp_index].is_send = false
	return temp_index
end
-------------------------------------------------
---添加搜索信息
function JiShouModel:data_add_page_serch_info( page_index, max_num ,info )
	local info_num = #info
	--print("JiShouModel:data_add_page_serch_info info[1].bag_item.item_id ",info[1].bag_item.item_id )
	for i = 1, #_page_serch_info do
		if info[1].type == 1 then
			for i = 1, #info do
				if JiShouModel:data_get_index_data_item_info(_money_page_index, info[i].handle ) == nil then
					table.insert( _page_serch_info[_money_page_index].info, info[i] )
				end
			end
			_page_serch_info[_money_page_index].max_page = max_num
			local temp_index_page_info_num = #_page_serch_info[_money_page_index].info		
			if max_num * _static_serch_info_page_num - temp_index_page_info_num < _static_serch_info_page_num then
				_page_serch_info[_money_page_index].max_num =  temp_index_page_info_num
			else
				_page_serch_info[_money_page_index].max_num = max_num * _static_serch_info_page_num
			end
			_page_serch_info[_money_page_index].last_serch_index = page_index
			_page_serch_info[_money_page_index].refresh_time = os.time()
			_page_serch_info[_money_page_index].is_send = false
			return _money_page_index
		else
			--print("JiShouModel:data_add_page_serch_info i",i)
			local id_range_info = JiShouModel:get_id_range_info( _page_serch_info[i] )
			for j = 1, #id_range_info do
				print("info[1].bag_item.item_id , id_range_info[j]",info[1].bag_item.item_id, id_range_info[j])
				local temp_item_info = ItemConfig:get_item_by_id( info[1].bag_item.item_id )
				if temp_item_info.sellType == id_range_info[j] then
					for k = 1, #info do
						if JiShouModel:data_get_index_data_item_info( i, info[k].handle ) == nil then
							table.insert( _page_serch_info[i].info, info[k] )
						end
					end
					_page_serch_info[i].max_page = max_num
					local temp_index_page_info_num = #_page_serch_info[i].info		
					if max_num * _static_serch_info_page_num - temp_index_page_info_num < _static_serch_info_page_num then
						_page_serch_info[i].max_num =  temp_index_page_info_num
					else
						_page_serch_info[i].max_num = max_num * _static_serch_info_page_num
					end
					_page_serch_info[i].last_serch_index = page_index
					_page_serch_info[i].refresh_time = os.time()
					_page_serch_info[i].is_send = false
					return i
				end
			end
		end
	end
	return nil
end
-------------------------------------------------
---
-- function JiShouModel:data_add_index_data_info(index, info)
-- 	table.insert(_page_serch_info[index].info, info)
-- end
-------------------------------------------------
---删除指定搜索数据
function JiShouModel:data_delete_index_data_info(index, handle)
	for i = 1, #_page_serch_info[index].info do
		if _page_serch_info[index].info[i].handle == handle then
			table.remove(_page_serch_info[index].info, i)
			_page_serch_info[index].refresh_time = os.time()
			_page_serch_info[index].max_num = _page_serch_info[index].max_num - 1
			_page_serch_info[i].max_page = math.ceil( _page_serch_info[i].max_num / _static_serch_info_page_num )
			return
		end
	end
end
-------------------------------------------------
---删除指定搜索数据
function JiShouModel:data_delete_data_info(handle)
	for i = 1, #_page_serch_info do
		for j = 1, #_page_serch_info[i].info do
			print("_page_serch_info[i].info[j].handle,handle", _page_serch_info[i].info[j].handle,handle)
			if _page_serch_info[i].info[j].handle == handle then
				table.remove( _page_serch_info[i].info, j)
				_page_serch_info[i].refresh_time = os.time()
				_page_serch_info[i].max_num = _page_serch_info[i].max_num - 1
				_page_serch_info[i].max_page = math.ceil( _page_serch_info[i].max_num / _static_serch_info_page_num )
				return i
			end
		end
	end
	-------default stept
	_page_serch_info[ _cur_page_select ].info = nil
	_page_serch_info[ _cur_page_select ].info = {}
	_page_serch_info[ _cur_page_select ].is_send = false
	_page_serch_info[ _cur_page_select ].refresh_time = os.time()
	return _cur_page_select
end
-------------------------------------------------
---取得指定索引信息
function JiShouModel:data_get_index_data_info(index)
	return _page_serch_info[index]
end
-------------------------------------------------
---取得指定索引信息
function JiShouModel:data_get_index_data_item_info(index, handle)
	if _page_serch_info[index].info ~= nil then
		for i = 1, #_page_serch_info[index].info do
			if _page_serch_info[index].info[i].handle == handle then
				return _page_serch_info[index].info[i]
			end
		end
	end
	return nil
end
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-------------------------------------------------
---退出按钮
function JiShouModel:exit_btn_fun()
	UIManager:hide_window("ji_shou_win")
end
-------------------------------------------------
---
function JiShouModel:check_serch_send_index(index)
	local temp_info = _page_serch_info[index].info
	print("JiShouModel:check_serch_send_index #temp_info", #temp_info)
	local temp_info_len = #temp_info
	if temp_info_len % _static_serch_info_page_num == 0 and temp_info_len ~= 0 then
		return temp_info_len / _static_serch_info_page_num
	else
		return temp_info_len / _static_serch_info_page_num
	end
end
-------------------------------------------------
---检查指定索引数据
function JiShouModel:get_index_page_info(index)	
	--_page_serch_info[index].init = true
	local temp_index = JiShouModel:check_serch_send_index(index)
	print("JiShouModel:get_index_page_info index temp_index",index, temp_index)
	if JiShouModel:get_cur_top_page_select() == 9 then -- 搜索状态
		local win = UIManager:find_window("ji_shou_win")
		local num = 0
		local id_list = {}
		local money_type = 0
		local item_quality = -1 
		if win then
			local prefix = "../data/"
			local data_name = "std_items"
			local name = win:get_search_name()
			if name~="" then
				for i=0,150 do
					local config_index = data_name .. i
					local config = _G[config_index]
					if config then
						for k,v in pairs(config) do			
							local p = string.find(v.name, name)
							if p~=nil then
								table.insert(id_list,v.id)
							end
						end
					end
				end
			end
			num = #id_list
			money_type = win:get_search_money_type()
			item_quality = win:get_select_quality()
		end
		JiShouCC:send_find_item( _static_serch_info_page_num, temp_index, _page_serch_info[index].serch_id, 0,            0,             item_quality,      0,           0,            0,             num, id_list,money_type)
		-- JiShouCC:send_find_item( 4,                        temp_index, -1,                               min_price_lv, self.price_lv, self.item_quality, min_item_lv, self.item_lv, self.job_type, num, id_list,money_type)
	else
		JiShouCC:send_find_item( _static_serch_info_page_num, temp_index, _page_serch_info[index].serch_id, 0, 0, -1, 0, 0, 0, 0, 0 ,0)
	end
end
-------------------------------------------------
---添加搜索信息
function JiShouModel:add_serch_info(page_index, max_page, info)
	local temp_win = UIManager:find_window("ji_shou_win")
	local _special_page_index = temp_win:get_special_page_index()
	_special_page_index = JiShouModel:get_index_page_cur_select(_special_page_index)
	local add_page_index 
	if _cur_page_select == _special_page_index then
		add_page_index = JiShouModel:data_add_page_serch_info_to_special( page_index, max_page, info )
	elseif _cur_page_select == 16 then
		add_page_index = JiShouModel:data_add_page_serch_info_to_custom( page_index, max_page, info )		
	else	
		add_page_index = JiShouModel:data_add_page_serch_info( page_index, max_page, info )
	end
	--JiShouModel:sort_index_item_info_by_time(add_page_index)
	print("JiShouModel:add_serch_info add_page_index, _cur_page_select",add_page_index, _cur_page_select)
	if add_page_index ~= nil then
		--_page_serch_info[add_page_index].init = true
		if add_page_index == _cur_page_select then
			local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
			if ji_shou_win ~= nil then
				print("_page_serch_info[add_page_index].max_num",_page_serch_info[add_page_index].max_num)
				ji_shou_win:set_scroll_max_num( _page_serch_info[add_page_index].max_num )
				ji_shou_win:refresh_scroll()
			end
		end
	end
end
-------------------------------------------------
---搜索按钮
function JiShouModel:serach_btn_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		local info = ji_shou_win:get_serch_text()
		if #info <= 0 then
			GlobalFunc:create_screen_notic(Lang.jiShou.serch_screen_run_text)
		else
			JiShouCC:send_find_item(_static_serch_info_page_num, 0, -1, 0, max_money, -1, 0, 0, job, search_num, id_list, 0)
		end
	end
end
-------------------------------------------------
---
function JiShouModel:buy_finish()
	_page_serch_info[15] = nil
	_page_serch_info[15] = JiShouSerchPageInfo( _id_range[15].serch_id, _id_range[15].range, _id_range[15].is_continuous )
	if _last_buy_page_index ~= nil then
		_page_serch_info[_last_buy_page_index] = nil
		_page_serch_info[_last_buy_page_index] = JiShouSerchPageInfo( _id_range[_last_buy_page_index].serch_id, _id_range[_last_buy_page_index].range, _id_range[_last_buy_page_index].is_continuous )
	end
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	ji_shou_win:clear_scroll()
	ji_shou_win:refresh_scroll()
	-- local player = EntityManager:get_player_avatar()
	-- local cur_yb = player.yuanbao
	-- local cur_yl = player.yinliang
	-- JiShouModel:update_yb_yl()
end
-------------------------------------------------
---上架按钮
function JiShouModel:shanjia_btn_fun()
	UIManager:hide_window("ji_shou_win")
	local ji_shou_shang_jia_win = UIManager:show_window("ji_shou_shang_jia_win")
	ji_shou_shang_jia_win:change_index_page(3)
end
-------------------------------------------------
---我要寄售
function JiShouModel:woyaojishou_btn_fun()
	local ji_shou_shang_jia_win = UIManager:show_window("ji_shou_shang_jia_win")
	ji_shou_shang_jia_win:change_index_page(1)
end
-------------------------------------------------
---更新元宝与银两
function JiShouModel:update_yb_yl()
	local ji_shou_win = UIManager:find_window("ji_shou_win")
	if ji_shou_win ~= nil then
		local player = EntityManager:get_player_avatar()
		local cur_yb = player.yuanbao
		local cur_yl = player.yinliang
		ji_shou_win:update_yb_and_yl(cur_yb, cur_yl)
	end
end
-------------------------------------------------
---装备与
function JiShouModel:equip_and_material_tab_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page(1)
	end
end
-------------------------------------------------
---宝石与强化
function JiShouModel:gem_and_strgen_tab_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page(2)
	end
end
-------------------------------------------------
---法宝与翅膀
function JiShouModel:trump_and_wing_tab_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page(3)
	end
end
-------------------------------------------------
---药品
function JiShouModel:medicine_tab_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page(4)
	end
end
-------------------------------------------------
---元宝与银两
function JiShouModel:yb_and_yl_tab_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page(5)
	end
end
-------------------------------------------------
---其它道具
function JiShouModel:other_tab_fun()
	local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
	if ji_shou_win ~= nil then
		ji_shou_win:change_page(6)
	end
end
-------------------------------------------------
---删除指定数据
function JiShouModel:delete_item(handle)
	local index = JiShouModel:data_delete_data_info(handle)
	print("JiShouModel delete_item index", index)
	if index ~= nil then
		-- _page_serch_info[index].info = nil
		-- _page_serch_info[index].info = {}
		--_page_serch_info[index].max_num = _page_serch_info[index].max_num - 1
		-- local temp_mod_num = #_page_serch_info[index].info % _static_serch_info_page_num
		-- local temp_div_num = math.ceil( #_page_serch_info[index].info / _static_serch_info_page_num )
		-- _page_serch_info[index].last_serch_index = temp_div_num
		local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
		print("ji_shou_win", ji_shou_win, _page_serch_info[index].max_num, #_page_serch_info[index].info)
		if ji_shou_win ~= nil then
			ji_shou_win:clear_scroll()
			ji_shou_win:set_scroll_max_num(_page_serch_info[index].max_num)
			ji_shou_win:refresh_scroll()
			--JiShouModel:get_index_page_info(index)
		end
	end
end
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-------------------------------------------------
---装备升级按钮
function JiShouModel:item_level_btn_fun()
	JiShouModel:set_index_page_cur_select(1, 1)
	JiShouModel:set_cur_page_select(1)
end
-------------------------------------------------
---装备提口按钮
function JiShouModel:item_tp_btn_fun()
	JiShouModel:set_index_page_cur_select(1, 2)
	JiShouModel:set_cur_page_select(2)
end
-------------------------------------------------
---装备升阶按钮
function JiShouModel:item_sj_btn_fun()
	JiShouModel:set_index_page_cur_select(1, 3)
	JiShouModel:set_cur_page_select(3)
end
-------------------------------------------------
---宝石按钮
function JiShouModel:gem_btn_fun()
	JiShouModel:set_index_page_cur_select(2, 4)
	JiShouModel:set_cur_page_select(4)
end
-------------------------------------------------
---强化材料按钮
function JiShouModel:strengthen_btn_fun()
	JiShouModel:set_index_page_cur_select(2, 5)
	JiShouModel:set_cur_page_select(5)
end
-------------------------------------------------
---翅膀培养按钮
function JiShouModel:wing_btn_fun()
	JiShouModel:set_index_page_cur_select(3, 6)
	JiShouModel:set_cur_page_select(6)
end
-------------------------------------------------
---式神培养按钮
function JiShouModel:trump_btn_fun()
	JiShouModel:set_index_page_cur_select(3, 7)
	JiShouModel:set_cur_page_select(7)
end
-------------------------------------------------
---宠物蛋按钮
function JiShouModel:pet_egg_btn_fun()
	JiShouModel:set_index_page_cur_select(4, 8)
	JiShouModel:set_cur_page_select(8)
end
-------------------------------------------------
---宠物培养按钮
function JiShouModel:pet_pei_btn_fun()
	JiShouModel:set_index_page_cur_select(4, 9)
	JiShouModel:set_cur_page_select(9)
end
-------------------------------------------------
---坐骑培养按钮
function JiShouModel:mount_btn_fun()
	JiShouModel:set_index_page_cur_select(4, 10)
	JiShouModel:set_cur_page_select(10)
end
-------------------------------------------------
---人物物品按钮
function JiShouModel:role_medicine_btn_fun()
	JiShouModel:set_index_page_cur_select(5, 11)
	JiShouModel:set_cur_page_select(11)
end
-------------------------------------------------
---宠物物品按钮
function JiShouModel:pet_medicine_btn_fun()
	JiShouModel:set_index_page_cur_select(5, 12)
	JiShouModel:set_cur_page_select(12)
end
-------------------------------------------------
---元宝按钮
function JiShouModel:yb_btn_fun()
	JiShouModel:set_index_page_cur_select(6, 13)
	JiShouModel:set_cur_page_select(13)
end

function JiShouModel:yl_btn_fun()
	JiShouModel:set_index_page_cur_select(6, 15)
	JiShouModel:set_cur_page_select(15)
end

-------------------------------------------------
---其它道具按钮
function JiShouModel:other_btn_fun()
	JiShouModel:set_index_page_cur_select(7, 14)
	JiShouModel:set_cur_page_select(14)
end
-------------------------------------------------
---
function JiShouModel:sort_index_item_info_by_time(index)
	local function sort_fun(a, b)
		if a.reset_time ~= nil and b.reset_time ~= nil then
			if a.reset_time > b.reset_time then
				return true
			else
				return false
			end
		end
	end
	table.sort( _page_serch_info[index].info, sort_fun )
end