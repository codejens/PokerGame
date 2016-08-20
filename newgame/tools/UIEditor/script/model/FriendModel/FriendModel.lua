-----friendmode.lua
-----HJH
-----2013-2-17
-----------
-- super_class.FriendModel()
FriendModel = {}
-----------
-- require "config/FriendConfig"
-----------
local _online_state_image 		= {
	UILH_COMMON.fy_bg2,
	UILH_COMMON.fy_select2,	
}
-----------
-----------
local _my_friend_info 					= {}
local _enemy_info						= {}
local _black_info						= {}
local _near_info						= {}
local radar_info						= {}
local _get_friend_times					= nil
local _my_friend_info_need_refresh		= false
local _enemy_info_need_refresh 			= false
local _black_info_need_refresh			= false
local _near_info_need_refresh			= false
local _cur_time							= os.time()
local _refresh_max_time					= 15
-----------
-- added by aXing on 2013-5-25
function FriendModel:fini( ... )
	_my_friend_info 					= {}
	_enemy_info							= {}
	_black_info							= {}
	_near_info							= {}
	radar_info							= {}
	_get_friend_times					= nil
	_my_friend_info_need_refresh		= false
	_enemy_info_need_refresh 			= false
	_black_info_need_refresh			= false
	_near_info_need_refresh				= false
	_cur_time 							= os.time()
end
-----------
function FriendModel:data_get_my_friend_info_by_id(id)
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].roleId == id then
			return _my_friend_info[i]
		end
	end
	return nil
end
-----------
function FriendModel:get_my_friend_info_num()
	return #_my_friend_info
end
-----------
function FriendModel:get_my_friend_online_num()
	local curnum = 0
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].online == 1 then
			curnum = curnum + 1
		end
	end
	return curnum
end

-----------取得第N个在线好友信息
function FriendModel:get_my_OL_friendIndex_info(index)

	local have_online_friend = false
	local i = 1
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].online == 1 then
			have_online_friend =true
			index=index-1
			if index == 0 then 
				return _my_friend_info[i]
			end
		end

	end
	if have_online_friend == false then 
		return nil
	end
end

-----------
function FriendModel:get_enemy_info_num()
	return #_enemy_info
end
-- 是否为仇人
function FriendModel:is_my_enemy(roleName)
	for i, v in ipairs(_enemy_info) do
		if v.roleName == roleName then
			return true
		end
	end
	return false
end
-----------
function FriendModel:get_enemy_online_num()
	local curnum = 0
	for i = 1, #_enemy_info do
		if _enemy_info[i].online == 1 then
			curnum = curnum + 1
		end
	end
	return curnum
end
-----------
function FriendModel:get_blacklist_info_num()
	return #_black_info
end
-----------
function FriendModel:get_blacklist_online_num()
	local curnum = 0
	for i = 1, #_black_info do
		if _black_info[i].online == 1 then
			curnum = curnum + 1
		end
	end
	return curnum
end
-----------
function FriendModel:get_near_info_num()
	return #_near_info
end
-----------
function FriendModel:get_near_online_num()
	local curnum = 0
	for i = 1, #_near_info do
		if _near_info[i].online == 1 then
			curnum = curnum + 1
		end
	end
	return curnum
end
-----------更新一键征友数目
function FriendModel:update_get_times_num(num)
	_get_friend_times = num
	local friend_win = UIManager:find_window("friend_win")
	if friend_win ~= nil then
		local cur_index = friend_win.radio_button_group:getCurSelect()
		print("update_get_times_num cur_index",cur_index)
		friend_win:update_index_tip_info(cur_index)
	end
end
-----------取得键征友数目
function FriendModel:get_get_times_num()
	return _get_friend_times
end
-----------取得指定好友信息
function FriendModel:get_my_friend_info(id)
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].roleId == id then
			return _my_friend_info[i]
		end
	end
	return nil
end



-----------取得好友在线数量
function FriendModel:data_update_my_friend_online_info(id, online)
	--print("id, online",id, online)
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].roleId == id then
			_my_friend_info[i].online = online
			break
		end
	end
	FriendModel:sort_info(_my_friend_info)
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil and friend_win:get_index_page_visible(1) == true then
		friend_win:clear_index_scroll_item(1)
		friend_win:refresh_index_scroll_item(1)
		friend_win:update_my_friend_text_info()
	elseif _my_friend_info_need_refresh == false then
		_my_friend_info_need_refresh = true
	end
	if online > 0 then
		local friend_info =	FriendModel:get_my_friend_info(id)
		if friend_info ~= nil then
			GlobalFunc:create_screen_notic( string.format(Lang.friend.model[3],friend_info.roleName) ) -- [3]="你的好友%s上线了"
		end
	end
end
-----------取得好友总数量
function FriendModel:date_update_my_friend_info_info(id, level, icon, new_name)
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].roleId == id then
			_my_friend_info[i].level = level
			_my_friend_info[i].face = icon
			_my_friend_info[i].roleName = new_name
		end
	end
	local friend_win = UIManager:find_window("friend_win")
	if friend_win ~= nil then
		friend_win:clear_index_scroll_item(1)
		friend_win:refresh_index_scroll_item(1)
	elseif _my_friend_info_need_refresh == false then
		_my_friend_info_need_refresh = true
	end
	FriendModel:sort_info(_my_friend_info)
end
-----------添加好友信息
function FriendModel:data_add_my_friend_info(friendInfo)
	local index = #_my_friend_info
	--local tinfo = {id = tid, friendly = tfriendly, icon = ticon, ttype = ttype, camp = tcamp, job = tjob, sex = tsex, online = tonline, reserve = treserve, name = tname}
	--for i = 1, #friendInfo do
	table.insert(_my_friend_info, index + 1, friendInfo)
	_my_friend_info_need_refresh = true
	FriendModel:sort_info(_my_friend_info)
	--end
	-- print("data_add_my_friend_info---------------------")
	-- print("index=",index)
	-- print("_my_friend_info",_my_friend_info)
	-- print("data_add_my_friend_info---------------------")
end
-----------删除好友信息
function FriendModel:data_delete_my_friend_info(id)
	--print("#_my_friend_info, id",#_my_friend_info,id)
	for i = 1, #_my_friend_info do
		--print("_my_friend_info[i].roleId",_my_friend_info[i].roleId)
		if _my_friend_info[i].roleId == id then
			table.remove(_my_friend_info, i)
			_my_friend_info_need_refresh = true
			return
		end
	end
	FriendModel:sort_info(_my_friend_info)
end
-----------添加敌人信息
function FriendModel:data_add_enemy_info(friendInfo)
	local index = #_enemy_info
	--local tinfo = {id = tid, friendly = tfriendly, icon = ticon, ttype = ttype, camp = tcamp, job = tjob, sex = tsex, online = tonline, reserve = treserve, name = tname}
	--for i = 1, #friendInfo do
		table.insert(_enemy_info, index + 1, friendInfo)
		_enemy_info_need_refresh = true
	--end
end
-----------删除敌人信息
function FriendModel:data_delete_enemy_info(id)
	for i = 1, #_enemy_info do
		if _enemy_info[i].roleId == id then
			table.remove(_enemy_info, i)
			_enemy_info_need_refresh = true
			return
		end
	end
end
-----------添加黑名单信息
function FriendModel:data_add_back_info(friendInfo)
	local index = #_black_info
	--local tinfo = {id = tid, friendly = tfriendly, icon = ticon, ttype = ttype, camp = tcamp, job = tjob, sex = tsex, online = tonline, reserve = treserve, name = tname}
	--for i = 1, #friendInfo do
	table.insert(_black_info, index + 1, friendInfo)
	_black_info_need_refresh = true
	FriendModel:sort_info(_black_info)
		--print("data_add_back_info online",friendInfo.online)
	--end
end
-----------删除黑名单信息
function FriendModel:data_delete_back_info(id)
	for i = 1, #_black_info do
		if _black_info[i].roleId == id then
			table.remove(_black_info, i)
			_black_info_need_refresh = true
			return
		end
	end
	FriendModel:sort_info(_black_info)
end
-----------添加附近信息
function FriendModel:data_add_near_info(friendInfo)
	local index = #_near_info
	--local tinfo = {id = tid, friendly = tfriendly, icon = ticon, ttype = ttype, camp = tcamp, job = tjob, sex = tsex, online = tonline, reserve = treserve, name = tname}
	--for i = 1, #friendInfo do
	table.insert(_near_info, index + 1, friendInfo)
	_near_info_need_refresh = true
	FriendModel:sort_info(_near_info)
	--end
end
-----------删除附近信息
function FriendModel:data_delete_near_info(id)
	for i = 1, #_near_info do
		if _near_info[i].roleId == id then
			table.remove(_near_info, i)
			_near_info_need_refresh = true
			return
		end
	end
	FriendModel:sort_info(_near_info)
end
-----------
function FriendModel:is_my_friend(id)
	for i = 1, #_my_friend_info do
		if _my_friend_info[i].roleId == id then
			return true
		end
	end
	return false
end
-----------
-----------
local _curFriendAddNum = 0
local _curFriendCelebreateNum = 0
-----------
function FriendModel:refresh_friend_info(info)
	--print("FriendModel:refresh_friend_info #info:",#info)
	for i = 1, #info do
		--print("info[i].ttype",info[i].ttype)
		FriendModel:refresh_index_info(info[i].ttype, info[i])
	end
	local friend_win = UIManager:find_window("friend_win")
	if friend_win ~= nil then
		local curselect = friend_win.radio_button_group:getCurSelect() + 1
		FriendWin:update_index_tip_info(curselect)
		-- if curselect == 1 then
		-- 	friend_win:update_my_friend_text_info()
		-- elseif curselect == 2 then
		-- 	friend_win:update_enemy_text_info()
		-- elseif curselect == 3 then
		-- 	friend_win:update_black_list_text_info()
		-- elseif curselect == 4 then
		-- 	friend_win:update_near_notic_text()
		-- end
		--friend_win:update_index_tip_info(curselect + 1)
	end
end
-----------
-- function FriendModel:update_cur_index_notic()
-- 	local friend_win = UIManager:find_window("friend_win")
-- 	local curselect = friend_win.radio_button_group:getCurSelect()
-- 	if curselect == 1 then
-- 		cu
-- end
-----------
function FriendModel:refresh_index_info(index, info)
	--print("run FriendModel:refresh_index_info")
	local cur_max_num = 0
	if info ~= nil then
		if index == 1 then
			FriendModel:data_add_my_friend_info(info)
			cur_max_num = #_my_friend_info
		elseif index == 2 then
			FriendModel:data_add_enemy_info(info)
			cur_max_num = #_enemy_info
		elseif index == 3 then
			FriendModel:data_add_back_info(info)
			cur_max_num = #_black_info
		elseif index == 4 then
			FriendModel:data_add_near_info(info)
			cur_max_num = #_near_info
		end
	end
	--FriendModel:set_cur_scroll_max_num()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
		--friend_win:update_index_max_num( index, cur_max_num )
		--print("run refresh_index_panel")
		friend_win:clear_index_scroll_item(index)
		friend_win:refresh_index_scroll_item(index)
	else
		if index == 1 then
			_my_friend_info_need_refresh = true
		elseif index == 2 then
			_enemy_info_need_refresh = true
		elseif index == 3 then
			_black_info_need_refresh = true
		elseif index == 4 then
			_near_info_need_refresh = true
		end
	end
end
-----------
function FriendModel:delete_friend_info(info)
	--print("run delete friend info info.ttype, info.roleId",info.ttype, info.roleId)
	--for i = 1, #info do
	--print("info.roleId ,info.ttype",info.roleId,info.ttype)
		FriendModel:delete_index_info(info.ttype, info.roleId)
	--end
end
----------
function FriendModel:delete_index_info(index, id)
	print("run delete index info index, id",index, id)
	local cur_max_num = 0
	if id ~= nil then
		if index == 1 then
			FriendModel:data_delete_my_friend_info(id)
			cur_max_num = #_my_friend_info
		elseif index == 2 then 
			FriendModel:data_delete_enemy_info(id)
			cur_max_num = #_enemy_info
		elseif index == 3 then
			FriendModel:data_delete_back_info(id)
			cur_max_num = #_black_info
		elseif index == 4 then
			FriendModel:data_delete_near_info(id)
			cur_max_num = #_near_info
		end
	end
	local friend_win = UIManager:find_visible_window("friend_win")
	print("friend_win", friend_win)
	if friend_win ~= nil then
		--friend_win:update_index_max_num( index, cur_max_num )
		if friend_win:get_index_page_visible(index) == true then
			print("run if")
			--print("run refresh_index_panel")
			friend_win:clear_index_scroll_item(index)
			friend_win:refresh_index_scroll_item(index)
		else
			print("run else")
			local curindex = friend_win.radio_button_group:getCurSelect() + 1
			friend_win:clear_index_scroll_item(curindex)
			friend_win:refresh_index_scroll_item(curindex)		
		end
	end
	-- local friend_win = UIManager:find_visible_window("friend_win")
	-- if friend_win ~= nil and friend_win:get_index_page_visible(1) == true then
	
	-- end	
end
-----------
function FriendModel:setCurFriendAddNum(num)
	_curFriendAddNum = num
end
-----------
function FriendModel:setCurFriendCelebreateNum(num)
	_curFriendCelebreateNum = num
end
-----------
function FriendModel:getCurFriendAddNum()
	return _curFriendAddNum
end
-----------
function FriendModel:getCurFriendCelebrateNum()
	return _curFriendCelebreateNum
end
-----------
function FriendModel:find_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
		local info = friend_win:get_friend_insertbox_info()
		-- require "control/FriendCC"
		if info == "" then
			GlobalFunc:create_screen_notic(Lang.friend_info.Edit_Is_Empty) -- [156]="请输入搜索角色名称"
		else
			FriendCC:send_check_friend(info)
		end
	end
end
-----------
function FriendModel:friend_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
	    -- friend_win:change_btn_name(1) --xiehande
		friend_win:setIndexPanelVisible(1, true)
		friend_win:setIndexPanelVisible(2, false)
		friend_win:setIndexPanelVisible(3, false)
		friend_win:setIndexPanelVisible(4, false)
		friend_win.radio_button_group:selectItem(0)
		--print("_my_friend_info_need_refresh",_my_friend_info_need_refresh)
		if _my_friend_info_need_refresh == true then
			local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.MY_FRIEND)
			local cur_friend_num = math.ceil(#_my_friend_info / scroll_info.num)
			local last_frined_num = friend_win.myfriend.scroll:getMaxNum()
			print("FriendModel:friend_btn_click_fun last_frined_num,cur_friend_num",last_frined_num,cur_friend_num)
			if last_frined_num ~= cur_friend_num then
				friend_win.myfriend.scroll:setMaxNum(cur_friend_num)
				return nil
			end
			friend_win:clear_index_scroll_item(1)
			friend_win:refresh_index_scroll_item(1)
			_my_friend_info_need_refresh = false
		end
		friend_win:update_index_tip_info(1)
	end
	
	--friend_win:update_my_friend_text_info()
end
-----------
function FriendModel:enemy_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
	    -- friend_win:change_btn_name(2) --xiehande
		friend_win:setIndexPanelVisible(1, false)
		friend_win:setIndexPanelVisible(2, true)
		friend_win:setIndexPanelVisible(3, false)
		friend_win:setIndexPanelVisible(4, false)
		if _enemy_info_need_refresh == true then
			local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.ENEMY)
			local cur_friend_num = math.ceil(#_enemy_info / scroll_info.num)
			local last_frined_num = friend_win.enemy.scroll:getMaxNum()
			if last_frined_num ~= cur_friend_num then
				friend_win.enemy.scroll:setMaxNum(cur_friend_num)
			end
			friend_win:clear_index_scroll_item(2)
			friend_win:refresh_index_scroll_item(2)
			_enemy_info_need_refresh = false
		end
		friend_win:update_index_tip_info(2)
	end
	
	--friend_win:update_enemy_text_info()
end
-----------
function FriendModel:backlist_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
	    -- friend_win:change_btn_name(3) --xiehande
		friend_win:setIndexPanelVisible(1, false)
		friend_win:setIndexPanelVisible(2, false)
		friend_win:setIndexPanelVisible(3, true)
		friend_win:setIndexPanelVisible(4, false)
		if _black_info_need_refresh == true then
			local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.BLACK_LIST)
			local cur_friend_num = math.ceil(#_black_info / scroll_info.num)
			local last_frined_num = friend_win.blacklist.scroll:getMaxNum()
			if last_frined_num ~= cur_friend_num then
				friend_win.blacklist.scroll:setMaxNum(cur_friend_num)
			end
			friend_win:clear_index_scroll_item(3)
			friend_win:refresh_index_scroll_item(3)
			_black_info_need_refresh = false
		end
		friend_win:update_index_tip_info(3)
	end
	
	--friend_win:update_black_list_text_info()
end
-----------
function FriendModel:near_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
	     -- friend_win:change_btn_name(4) --xiehande
		friend_win:setIndexPanelVisible(1, false)
		friend_win:setIndexPanelVisible(2, false)
		friend_win:setIndexPanelVisible(3, false)
		friend_win:setIndexPanelVisible(4, true)
		if _near_info_need_refresh == true then
			local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.NEAR)
			local cur_friend_num = math.ceil(#_near_info / scroll_info.num)
			local last_frined_num = friend_win.near.scroll:getMaxNum()
			if last_frined_num ~= cur_friend_num then
				friend_win.near.scroll:setMaxNum(cur_friend_num)
			end
			friend_win:clear_index_scroll_item(4)
			friend_win:refresh_index_scroll_item(4)
			_near_info_need_refresh = false
		end
		friend_win:update_index_tip_info(4)
		--friend_win:update_near_notic_text()
	end
	--friend_win:update_near_text_info()
end
-----------
function FriendModel:exit_btn_click_fun()
	UIManager:hide_window("friend_win")
	UIManager:hide_window("friend_set_win")
end
-----------
function FriendModel:get_friend()
	if _get_friend_times > 0 then
		require "control/FriendCC"
		FriendCC:send_get_friend()
	end
end
----------
function FriendModel:personal_set()
	if UIManager:get_win_status("friend_set_win") == false then
		UIManager:show_window("friend_set_win")
	else
		UIManager:hide_window("friend_set_win")
	end 
end
----------
function FriendModel:show_friend_info(tid, tlevel, tcamp, tjob, tsex, tname, txzname)
	require "model/FriendModel/FriendInfoModel"
	FriendInfoModel:init_friend_info(tid, tlevel, tcamp, tjob, tsex, tname, txzname)
end
----------
-----------
-----------
-----myfriendmode.lua
-----HJH
-----2013-2-17
-----------
--super_class.MyFriendModel()
-----------
function FriendModel:myfriend_scroll_create_function(index)
	-----------
	local info_num = #_my_friend_info
	print("myfriend_scroll_create_function index, info_num",index, info_num )
	if index < info_num  then
		-----------
		local friend_win = UIManager:find_window("friend_win")
		local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.MY_FRIEND)
		local temp_friend_num = math.ceil( #_my_friend_info / scroll_info.num )
		print("temp_friend_num,scroll_info.cur_max_num",temp_friend_num,scroll_info.cur_max_num)
		if temp_friend_num ~= scroll_info.cur_max_num then
			self:setMaxNum(temp_friend_num)
			self:refresh()
			return nil
		end
		local ver_size_info = {200, 85, 85}
		local list = ZList:create( nil, 0, 0, scroll_info.width, scroll_info.height, 1, scroll_info.num)
		-----------
		local label_one_info 			= {width = 25, height = 25}
		for i = 1, scroll_info.num do
			local curSetIndex = index * scroll_info.num + i
			if curSetIndex <= #_my_friend_info then
				local tempInfo = _my_friend_info[curSetIndex]
				local tempNameColor = ""
				if tempInfo.online == 0 then
					tempNameColor = "#c808080"  
				end
				local label_info = { 
				string.format("%s%s%s",tempNameColor, tempInfo.roleName, Lang.sex_info[tempInfo.sex + 1]),
				string.format(Lang.friend.model[4],tempInfo.level), -- [4]="%d级"
				Lang.job_info[tempInfo.job] 
				}
				--print("label_info[1],[2],[3]",label_info[1],label_info[2],label_info[3])
				local ver_list = ZListVertical:create( nil, 0, 0, scroll_info.width, scroll_info.height / scroll_info.num, ver_size_info, 1, 1)
				--ver_list.view:setTexture("ui/common/bg03.png")
				local function list_touch_click_fun()
					--info = check friend struct
					local info = { roleId =  tempInfo.roleId, qqvip = tempInfo.qqVip, roleName = tempInfo.roleName, level = tempInfo.level, camp = tempInfo.camp, job = tempInfo.job, sex = tempInfo.sex, online = tempInfo.online, ttype = tempInfo.ttype}
					--require "model/LeftClickMenuMgr"
					--print("info.online",info.online)
					-- ver_list.selectbg.view:setIsVisible(true)
					if info.online == 1 then
						if GuildModel:check_ask_join_right(  ) == true then
							LeftClickMenuMgr:show_left_menu("my_friend_online_menu_guild", info)
						else
							LeftClickMenuMgr:show_left_menu("my_friend_online_menu", info)
						end
					else
						LeftClickMenuMgr:show_left_menu("my_friend_offline_menu", info)
						--LeftClickMenuMgr:show_left_menu("my_friend_offline_menu", info)
					end
				end
				local function list_double_click_fun()
					if tempInfo.online == 0 then
						GlobalFunc:create_screen_notic(Lang.friend_info.Friend_off_line)
					else
						local info = { roleId =  tempInfo.roleId, roleName = tempInfo.roleName, level = tempInfo.level, camp = tempInfo.camp, job = tempInfo.job, sex = tempInfo.sex, online = tempInfo.online, ttype = tempInfo.ttype}
						LeftClickMenuMgr:private_chat(info)
					end
				end
				-- ver_list.selectbg = ZImage:create(ver_list.view, 'nopack/black.png', 0, -5, scroll_info.width, scroll_info.height / scroll_info.num - 15)
				-- ver_list.selectbg.view:setOpacity(50)
				-- ver_list.view:registerScriptHandler(message_function)
				-- ver_list.selectbg.view:setIsVisible(false)
				ver_list:setTouchClickFun(list_touch_click_fun)
				ver_list:setTouchDoubleClickFun(list_double_click_fun)
				ver_list.view:setEnableDoubleClick(true)
				--print("ver_list.touch_click_fun",ver_list.touch_click_fun)
				local label_one = TextCheckBox:create( nil, 0, 0, label_one_info.width, label_one_info.height, _online_state_image[tempInfo.online + 1], label_info[1] )
				label_one:setTouchBeganReturnValue(false)
				label_one:setTouchMovedReturnValue(false)
				label_one:setTouchEndedReturnValue(false)
				local label_two = ZLabel:create( nil, label_info[2], 0, 0)
				local label_three = ZLabel:create(nil, label_info[3], 0, 0)
				local line = ZImage.new(UILH_COMMON.split_line)
				self.select_img = CCZXImage:imageWithFile(28, -7, scroll_info.width-28, scroll_info.height / scroll_info.num + 6, UILH_CHATWIN.btn_select, 600, 600)
				self.select_img:setIsVisible(false)
				line:setPosition(-4, -3)
				line:setSize(scroll_info.width-30, 2)
				ver_list:addItem(label_one)
				ver_list:addItem(label_two)
				ver_list:addItem(label_three)
				ver_list:addChild(line)
				ver_list:addChild(self.select_img)
				list:addItem(ver_list)
			end
		end
		--print("list",list)
		-----------
		return list
	end
end
-----------个人设置按钮
function FriendModel:myfriend_set_btn_click_function()
	if UIManager:get_win_status("friend_set_win") == false then
		UIManager:show_window("friend_set_win")
	else
		UIManager:hide_window("friend_set_win")
	end 
end
-----------一键征友
function FriendModel:myfriend_get_friend_btn_function()
	if _get_friend_times > 0 then
		--require "control/FriendCC"
		FriendCC:send_get_friend()
		_get_friend_times = _get_friend_times - 1
		local friend_win = UIManager:find_visible_window("friend_win")
		if friend_win ~= nil then
			--local cur_select = friend_win.radio_button_group:getCurSelect() + 1
			friend_win:update_index_tip_info(1)
			friend_win:update_index_tip_info(4)
		end
	else
		GlobalFunc:create_screen_notic( Lang.friend.model[5] ) -- [5]="今日次数已用完"
	end
end
-----------
-----enemymodel.lua
-----HJH
-----2013-2-17
-----------
--super_class.EnemyModel()
-----------
function FriendModel:enemy_scroll_create_function(index)
	-----------
	local info_num = #_enemy_info
	--print("index, info_num",index, info_num )
	if index < info_num  then
		-----------
		FriendModel:sort_info(_enemy_info)
		local friend_win = UIManager:find_window("friend_win")
		local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.ENEMY)
		local temp_friend_num = math.ceil( #_enemy_info / scroll_info.num )
		if temp_friend_num ~= scroll_info.cur_max_num then
			self:setMaxNum(temp_friend_num)
			self:refresh()
			return nil
		end
		local ver_size_info = {190, 100, 85 }
		local list = ZList:create( nil, 0, 0, scroll_info.width, scroll_info.height, 1, scroll_info.num)
		-----------
		local label_one_info 			= {width = 25, height = 25}
		for i = 1, scroll_info.num do
			local curSetIndex = index * scroll_info.num + i
			if curSetIndex <= #_enemy_info then
				--print("curSetIndex, #_enemy_info",curSetIndex,#_enemy_info)
				local tempInfo = _enemy_info[curSetIndex]
				local tempNameColor = ""
				if tempInfo.online == 0 then
					tempNameColor = "#c808080"  
				end
				local label_info = { string.format("%s%s%s",tempNameColor,tempInfo.roleName, Lang.sex_info[tempInfo.sex + 1]), tostring( ZXLuaUtils:highByte(tempInfo.friendly) ), tostring(ZXLuaUtils:lowByte(tempInfo.friendly) ) }
				--print("label_info[1],2,3",label_info[1],label_info[2],label_info[3])
				local ver_list = ZListVertical:create( nil, 0, 0, scroll_info.width, scroll_info.height / scroll_info.num, ver_size_info, 1, 1)
				--ver_list.view:setTexture("ui/common/bg03.png")
				local function list_touch_click_fun()
					--info = check friend struct
					local info = { roleId =  tempInfo.roleId, roleName = tempInfo.roleName, qqvip = tempInfo.qqVip, level = tempInfo.level, camp = tempInfo.camp, job = tempInfo.job, sex = tempInfo.sex, online = tempInfo.online, ttype = tempInfo.ttype }
					require "model/LeftClickMenuMgr"
					if info.online == 1 then
						LeftClickMenuMgr:show_left_menu("my_enemy_online_menu", info)
					else
						LeftClickMenuMgr:show_left_menu("my_friend_offline_menu", info)
					end
				end
				ver_list:setTouchClickFun(list_touch_click_fun)
				local label_one = TextCheckBox:create( nil, 0, 0, label_one_info.width, label_one_info.height, _online_state_image[tempInfo.online + 1], label_info[1] )
				label_one:setTouchBeganReturnValue(false)
				label_one:setTouchMovedReturnValue(false)
				label_one:setTouchEndedReturnValue(false)
				local label_two = ZLabel:create( nil, label_info[2], 0, 0)
				local label_three = ZLabel:create(nil, label_info[3], 0, 0)
				local line = ZImage.new(UILH_COMMON.split_line)
				line:setPosition(-4, -3)
				line:setSize(scroll_info.width-30, 2)
				ver_list:addItem(label_one)
				ver_list:addItem(label_two)
				ver_list:addItem(label_three)
				ver_list:addChild(line)
				list:addItem(ver_list)
			end
		end
		--print("list",list)
		-----------
		return list
 	end
end
-----------敌人界面添加敌人按钮
function FriendModel:enemy_add_enemy_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
		local info = friend_win:get_enemy_insertbox_info()
		require "control/FriendCC"
		FriendCC:send_add_enemy(0, info)
	end
end
-----------
-----backlistmodel.lua
-----HJH
-----2013-2-17
-----------
--super_class.BlackListModel()
-----------
function FriendModel:blacklist_scroll_create_function(index)
	-----------
	local info_num = #_black_info
	--print("index, info_num",index, info_num )
	if index < info_num  then
		-----------
		FriendModel:sort_info(_black_info)
		local friend_win = UIManager:find_window("friend_win")
		local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.BLACK_LIST)
		local temp_friend_num = math.ceil( #_black_info / scroll_info.num )
		if temp_friend_num ~= scroll_info.cur_max_num then
			self:setMaxNum(temp_friend_num)
			self:refresh()
			return nil
		end
		local ver_size_info = {200, 85, 85 }
		local list = ZList:create( nil, 0, 0, scroll_info.width, scroll_info.height, 1, scroll_info.num)
		-----------
		local label_one_info 			= {width = 25, height = 25}
		for i = 1, scroll_info.num do
			local curSetIndex = index * scroll_info.num + i
			if curSetIndex <= #_black_info then
				--print("curSetIndex, #_enemy_info",curSetIndex,#_black_info)
				local tempInfo = _black_info[curSetIndex]
				local tempNameColor = ""
				if tempInfo.online == 0 then
					tempNameColor = "#c808080"  
				end
				local label_info = { string.format("%s%s%s",tempNameColor,tempInfo.roleName, Lang.sex_info[tempInfo.sex + 1]), string.format(Lang.friend.model[4],tempInfo.level), Lang.job_info[tempInfo.job] } -- [4]="%d级"
				--print("label_info[1],2,3",label_info[1],label_info[2],label_info[3])
				local ver_list = ZListVertical:create( nil, 0, 0, scroll_info.width, scroll_info.height / scroll_info.num, ver_size_info, 1, 1)
				local function list_touch_click_fun()
					--info = check friend struct
					local info = { roleId =  tempInfo.roleId, roleName = tempInfo.roleName, qqvip = tempInfo.qqVip, level = tempInfo.level, camp = tempInfo.camp, job = tempInfo.job, sex = tempInfo.sex , online = tempInfo.online, ttype = tempInfo.ttype}
					require "model/LeftClickMenuMgr"
					if info.online == 1 then
						LeftClickMenuMgr:show_left_menu("my_black_list_menu", info)
					else
						LeftClickMenuMgr:show_left_menu("my_friend_offline_menu", info)
					end
				end
				ver_list:setTouchClickFun(list_touch_click_fun)
				local label_one = TextCheckBox:create( nil, 0, 0, label_one_info.width, label_one_info.height, _online_state_image[tempInfo.online + 1], label_info[1] )
				label_one:setTouchBeganReturnValue(false)
				label_one:setTouchMovedReturnValue(false)
				label_one:setTouchEndedReturnValue(false)
				local label_two = Label:create( nil, 0, 0, label_info[2])
				local label_three = Label:create(nil, 0, 0, label_info[3])
				local line = ZImage.new(UILH_COMMON.split_line)
				line:setPosition(-4, -3)
				line:setSize(scroll_info.width-30, 2)
				ver_list:addItem(label_one)
				ver_list:addItem(label_two)
				ver_list:addItem(label_three)
				ver_list:addChild(line)
				list:addItem(ver_list)
			end
		end
		--print("list",list)
		-----------
		return list
 	end
end
-----------
function FriendModel:blacklist_add_backlist_btn_click_fun()
	local friend_win = UIManager:find_visible_window("friend_win")
	if friend_win ~= nil then
		local info = friend_win:get_black_insertbox_info()
		require "control/FriendCC"
		FriendCC:send_add_black_list(0, info)
	end
end
-----nearmodel.lua
-----HJH
-----2013-2-17
-----------
--super_class.NearModel()
-----------
function FriendModel:near_scroll_create_function(index)
	-----------
	local info_num = #_near_info
	--print("index, info_num",index, info_num )
	if index < info_num  then
		-----------
		FriendModel:sort_info(_near_info)
		local friend_win = UIManager:find_window("friend_win")
		local scroll_info = friend_win:find_index_page_scroll_info(FriendConfig.WinType.NEAR)
		local temp_friend_num = math.ceil( #_near_info / scroll_info.num )
		if temp_friend_num ~= scroll_info.cur_max_num then
			self:setMaxNum(temp_friend_num)
			self:refresh()
			return nil
		end
		local ver_size_info = {200, 85, 85}
		local list = List:create( nil, 0, 0, scroll_info.width, scroll_info.height, 1, scroll_info.num)
		-----------
		local label_one_info 			= {width = 25, height = 25}
		for i = 1, scroll_info.num do
			local curSetIndex = index * scroll_info.num + i
			if curSetIndex <= #_near_info then
				--print("curSetIndex, #_enemy_info",curSetIndex,#_near_info)
				local tempInfo = _near_info[curSetIndex]
				local tempNameColor = ""
				if tempInfo.online == 0 then
					tempNameColor = "#c808080"  
				end
				--print( string.format("run near scroll name=%s,online=%s,level=%s",tempInfo.roleName, tempInfo.online, tempInfo.level) )
				local label_info = { string.format("%s%s%s",tempNameColor,tempInfo.roleName, Lang.sex_info[tempInfo.sex + 1]), string.format(Lang.friend.model[4],tempInfo.level), Lang.job_info[tempInfo.job] } -- [4]="%d级"
				--print("label_info[1],2,3",label_info[1],label_info[2],label_info[3])
				local ver_list = ZListVertical:create( nil, 0, 0, scroll_info.width, scroll_info.height / scroll_info.num, ver_size_info, 1 ,1)
				local function list_touch_click_fun()
					--info = check friend struct
					--print("tempInfo.online",tempInfo.online)
					local info = { roleId =  tempInfo.roleId, roleName = tempInfo.roleName, qqvip = tempInfo.qqVip, level = tempInfo.level, camp = tempInfo.camp, job = tempInfo.job, sex = tempInfo.sex, online = tempInfo.online, ttype = tempInfo.ttype}
					require "model/LeftClickMenuMgr"
					if info.online == 1 then
						LeftClickMenuMgr:show_left_menu("near_online_menu", info)
					else
						--LeftClickMenuMgr:show_left_menu("my_friend_offline_menu", info)
					end
				end
				ver_list:setTouchClickFun(list_touch_click_fun)
				local label_one = TextCheckBox:create( nil, 0, 0, label_one_info.width, label_one_info.height, _online_state_image[tempInfo.online + 1], label_info[1] )
				label_one:setTouchBeganReturnValue(false)
				label_one:setTouchMovedReturnValue(false)
				label_one:setTouchEndedReturnValue(false)
				local label_two = ZLabel:create( nil, label_info[2], 0, 0)
				local label_three = ZLabel:create(nil, label_info[3], 0, 0)
				local line = ZImage.new(UILH_COMMON.split_line)
				line:setPosition(-4, -3)
				line:setSize(scroll_info.width-30, 2)
				ver_list:addItem(label_one)
				ver_list:addItem(label_two)
				ver_list:addItem(label_three)
				ver_list:addChild(line)
				list:addItem(ver_list)
			end
		end
		--print("list",list)
		-----------
		return list
 	end
end
-----------
function FriendModel:near_set_btn_click_function()
	if UIManager:get_win_status("friend_set_win") == false then
		UIManager:show_window("friend_set_win")
	else
		UIManager:hide_window("friend_set_win")
	end 
end
-----------
function FriendModel:near_get_friend_btn_function()
	if _get_friend_times > 0 then
		-- require "control/FriendCC"
		-- FriendCC:send_get_friend()
		-- _get_friend_times = _get_friend_times - 1
		-- local friend_win = UIManager:find_visible_window("friend_win")
		-- if friend_win ~= nil then
		-- 	--friend_win:update_near_notic_text()
		-- end
		Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
		UIManager:show_window("onekeyadd_win")
	end
end
-----------
function FriendModel:sort_info(arg)
	--local tinfo = {id = tid, friendly = tfriendly, icon = ticon, ttype = ttype, 
	--camp = tcamp, job = tjob, sex = tsex, online = tonline, reserve = treserve, name = tname}
	if type(arg) == "table" then
		local function sort_fun(a,b)
			if a ~= nil and b ~= nil then
				if a.online > b.online then
					return true
				elseif a.online < b.online then
					return false
				else
					if a.online == b.online then
						if a.level > b.level then
							return true
						else
							return false
						end
					end
				end
			end
		end
		table.sort( arg, sort_fun)
	end
end
-----------
function FriendModel:set_cur_scroll_max_num()
	local friend_win = UIManager:find_window("friend_win")
	print("FriendModel:set_cur_scroll_max_num friend_win",friend_win)
	if friend_win ~= nil then
		local cur_page = friend_win.radio_button_group:getCurNum()
		print("FriendModel:set_cur_scroll_max_num cur_page",cur_page)
		if cur_page == 0 then
			local temp_max_num = math.ceil( #_my_friend_info / 5 )
			friend_win.myfriend.scroll:setMaxNum(temp_max_num)
		elseif cur_page == 1 then
			local temp_max_num = math.ceil( #_enemy_info / 5 )
			friend_win.enemy.scroll:setMaxNum(temp_max_num)			
		elseif cur_page == 2 then
			local temp_max_num = math.ceil( #_black_info / 5 )
			friend_win.blacklist.scroll:setMaxNum(temp_max_num)
		elseif cur_page == 3 then
			local temp_max_num = math.ceil( #_near_info / 5 )
			friend_win.near.scroll:setMaxNum(temp_max_num)
		end
	end
end
-----------
function FriendModel:check_need_clear_all_info()
	local temp_time = os.time()
	if temp_time - _cur_time > _refresh_max_time then
		print("run clear friend all info")
		_my_friend_info = {}
		_enemy_info	= {}
		_black_info	= {}
		_near_info = {}
		local friend_win = UIManager:find_window("friend_win")
		if friend_win ~= nil then
			friend_win:clear_index_scroll_item(1)
			friend_win:clear_index_scroll_item(2)
			friend_win:clear_index_scroll_item(3)
			friend_win:clear_index_scroll_item(4)
		end
		FriendCC:request_friend_enemy_black_info()
	end
end
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

------------ 键盘事件
function FriendModel:keyboard_show( keyboard_width, keyboard_height )
	
	local win = UIManager:find_visible_window("friend_win")
	local win_info = UIManager:get_win_info( "friend_win" )

	if win and win_info then

		local move_call = callback:new()
		local function callback_func(  )
			print("好友系统的输入框")
			if keyboard_height <= 162 then
				-- print("111111111111111")
				win:setPosition(_refWidth(1),620);
			elseif keyboard_height <= 198 then	
				-- print("22222222222222")	
				win:setPosition(_refWidth(1),650);
			elseif keyboard_height <= 352 then		
				-- print("3333333333")
				win:setPosition(_refWidth(1),620);
			elseif keyboard_height <= 406 then		
				-- print("44444444444")
				win:setPosition(_refWidth(1),620);
			end
			move_call:cancel()
		end
	
		move_call:start(0.3, callback_func)

	end
end
function FriendModel:keyboard_hide( )
	local win = UIManager:find_visible_window("friend_win")
	-- local win_info =  UIManager:get_win_info( "friend_win" )
	if win then
		win:setPosition(_refWidth(1),_refHeight(0.5));
	end
end

function FriendModel:send_get_radar_info()
	FriendCC:radar_get_friend()
end

function FriendModel:set_radar_info(temp_info)
	radar_info = temp_info
end

function FriendModel:get_radar_info()
	return radar_info
end