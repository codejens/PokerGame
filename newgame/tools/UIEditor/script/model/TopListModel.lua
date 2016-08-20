---------------HJH
---------------2013-3-4
---------------
TopListModel = {}
---------------
local _cur_time = 0
local _refresh_max_time = 30 
local _resend_max_time = 60
local _scroll_page_num = 5
local _top_list_info = nil
local _init = true
local _top_list_scroll_max_num = 50
local _cur_page_select = 1
local _my_top_list_info = {}
---------------
function TopListModel:fini( ... )
	_init = true
end
---------------
function TopListModel:get_init()
	return _init
end
---------------重设排行榜数据
function TopListModel:reinit_top_list_info()
	_cur_time = os.time()
	_top_list_info = nil
	_top_list_info = {}
	local temp_panel_type_index = { TopListConfig.TopListType.Fight, TopListConfig.TopListType.Trump,
	 TopListConfig.TopListType.Pet, TopListConfig.TopListType.PerWeekCharm, TopListConfig.TopListType.FMSL }
	--print("TopListModel:reinit_top_list_info －－－－－－－－－－－#TopListConfig.TopListType ", #TopListConfig.TopListType )
	require "struct/TopListStruct"
	for i = 1, 11 do
		_top_list_info[i] = TopListPanelStruct()
		_top_list_info[i].type_index = temp_panel_type_index[i]
	end
	_init = false
	_cur_page_select = 1
end
---------------更新指定排行榜数据
function TopListModel:data_update_top_list_index_info( index, i , info )
	--print("TopListModel:data_update_top_list_index_info index, i", index, i)
	_top_list_info[index].info.page_info[i + 1] = nil
	_top_list_info[index].info.page_info[i + 1] = info
end
---------------检测指定排行榜数据
function TopListModel:data_check_top_list_index_info( index, id )
	for i = 1, #_top_list_info[index].info do
		if _top_list_info[index].info[i].playerId == id then
			return i
		end
	end
	return nil
end
---------------取得指定排行榜数据
function TopListModel:data_get_top_list_index_index_info( index, i )
	--print("#_top_list_info[index].info.page_info, index, i", #_top_list_info[index].info.page_info, index, i)
	if #_top_list_info[index].info.page_info < i + 1 then
		_top_list_info[index].cur_time = os.time()
		--print("_top_list_info[index].cur_time,_top_list_info[index].send_time,_top_list_info[index].is_send",_top_list_info[index].cur_time,_top_list_info[index].send_time,_top_list_info[index].is_send)
		-- if _top_list_info[index].cur_time - _top_list_info[index].send_time > _resend_max_time then
		-- 	_top_list_info[index].is_send = false
		-- end
		if _top_list_info[index].is_send == false then
			_top_list_info[index].is_send = true
			--print("_top_list_info[index].is_send", _top_list_info[index].is_send)
			_top_list_info[index].send_time = os.time()
			--local temp_page = TopListModel:data_get_top_list_index_page_send_info( index )
			if index == TopListConfig.TopListType.FMSL then
				MiscCC:send_camp_battle_top_list_info( i + 1 )
			else
				OthersCC:send_top_list_data( index, i, _scroll_page_num )
			end
		end
		return nil
	else
		if index == TopListConfig.TopListType.FMSL then
			return _top_list_info[index].info.page_info[i + 1]
		else
			return _top_list_info[index].info.page_info[i + 1]
		end
	end
end
---------------
function TopListModel:data_get_top_list_index_panel_info( index )
	return _top_list_info[index]
end
---------------
function TopListModel:data_set_top_list_index_init(index, result)
	_top_list_info[index].init = result
end
---------------添加指定排行榜数据
function TopListModel:data_add_top_list_index_info(index, page, info)
	--print("TopListModel:data_add_top_list_index_info index, i", index, page + 1)
	_top_list_info[index].info.page_info[page + 1] = nil
	_top_list_info[index].info.page_info[page + 1] = info
	_top_list_info[index].is_send = false
end
---------------删除指定排行榜数据
function TopListModel:data_delete_top_list_index_info(index, id)
	for i = 1, #_top_list_info[index].info do
		if _top_list_info[index].info[i].playerId == id then
			table.remove( _top_list_info[index].info, i )
			return
		end
	end
end
---------------取得指定排行榜发送页数
function TopListModel:data_get_top_list_index_page_send_info(index)
	local num = #_top_list_info[index].info
	return math.floor( num % _scroll_page_num )
end
--------------------------------------------------------
---------------我的排行榜点击按钮
function TopListModel:my_top_list_click_fun()
	-- OthersCC:send_my_top_list_info()
	local top_list_win = UIManager:find_visible_window("top_list_win")
	if top_list_win ~= nil then
		OthersCC:send_my_top_list_info()
	end
end
---------------我的排行榜数据刷新
function TopListModel:open_my_top_list(info)
	-- _my_top_list_info = info
	-- local top_list_win = UIManager:find_visible_window("top_list_win")
	-- if top_list_win ~= nil then
	-- 	top_list_win:reinit_info( info )
	-- end
	local top_list_win = UIManager:find_visible_window("top_list_win")
	if top_list_win ~= nil then
		top_list_win.my_top_list.view:setIsVisible(true)
		top_list_win.my_top_list:reinit_info( info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9],info[10],info[11])
	end
end
---------------获取我的排行榜数据
function TopListModel:get_my_top_list(index)
	return _my_top_list_info[index] or 0
end
---------------我的排行榜退出
function TopListModel:my_top_list_exit_button_click_fun()
	local top_list_win = UIManager:find_visible_window("top_list_win")
	if top_list_win ~= nil then
		top_list_win.my_top_list.view:setIsVisible(false)
	end
end
---------------
---------------检测是否全部刷新数据
function TopListModel:check_need_clear_all_top_list_info()
	local curtime = os.time()
	--print("curtime - _cur_time ",curtime, _cur_time, curtime - _cur_time )
	--if curtime - _cur_time > _refresh_max_time then
		--print(" run clear all top list info")
		_cur_time = curtime
		local temp_page_select = _cur_page_select
		TopListModel:reinit_top_list_info()
		_cur_page_select = temp_page_select
		local top_list_win = UIManager:find_window("top_list_win")
		if top_list_win ~= nil then
			top_list_win:reinit_all_scroll()
		end
	--end
end
--------------------------------------------------------
function TopListModel:add_index_top_list_info( index, page_index, info, max_page )
	_top_list_info[index].info.max_num = max_page
	TopListModel:data_add_top_list_index_info( index, page_index, info )
	local top_list_win = UIManager:find_visible_window("top_list_win")
	if top_list_win ~= nil then
		top_list_win:set_index_scroll_max_num( index, max_page )
		top_list_win:refresh_index_scroll( index )
	end
end
