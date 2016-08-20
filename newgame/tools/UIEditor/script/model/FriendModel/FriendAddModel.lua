-----friendaddmode.lua
-----HJH
-----2013-2-17
-----------
-- super_class.FriendAddModel()
FriendAddModel = {}
-----------
local _friend_add_info_is_new = false
local _friend_add_info = {}
local _self_window = nil
-- -----------
-- function FriendAddModel:check_exist_friend(id)
-- 	print("run friendaddmodel check exist friend ",id)
-- 	for i = 1, #_friend_add_info do 
-- 		print( string.format("_friend_add_info[i].id=%d,id=%d",_friend_add_info[i].id,id))
-- 		if _friend_add_info[i].id == id then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end
-----------
-- added by aXing on 2013-5-25
function FriendAddModel:fini( ... )
	_friend_add_info_is_new = false
	_friend_add_info = {}
	_self_window = nil
end
-----------
function FriendAddModel:insert_add_info(tid, taddType, tcampId, tlevel, tname)
	--if _friend_add_info ~= nil then
		--local index = #_friend_add_info
		local value = { id = tid, addType = taddType, campId = tcampId, level = tlevel, name = tname }	
		table.insert( _friend_add_info, value)
end
-----------
function FriendAddModel:delete_add_info(tid)
	local tarindex = nil
	print("#_friend_add_info ",#_friend_add_info )
	for i = 1, #_friend_add_info do
		--print("#friend_adD_info",#_friend_add_info)
		if _friend_add_info[i].id == tid then
			print("_friend_add_info[i].id",_friend_add_info[i].id)
			table.remove( _friend_add_info, i)
			return
		end
	end
end
-----------
function FriendAddModel:check_info(tid)
	for i = 1 , #_friend_add_info do
		if _friend_add_info[i].id == tid then
			return true
		end
	end
	return false
end
-----------
function FriendAddModel:add_friend(tid, taddType, tcampid, tlevel, tname)
    local auto_accept_friend = SetSystemModel:get_date_value_by_key( SetSystemModel.AUTO_ACCEPT_FRIEND )
    local auto_reject_friend = SetSystemModel:get_date_value_by_key( SetSystemModel.REJECT_ADDED_FRIEND )
    -- print("是否自动：：：：：：：：：：", auto_accept_friend, auto_reject_friend )
    if auto_accept_friend then
        FriendCC:send_add_friend(tid, 1, taddType)
        return
    elseif auto_reject_friend then
        FriendCC:send_add_friend(tid, 0, taddType)
        return
    end

	if FriendModel:is_my_friend(tid) == false and FriendAddModel:check_info(tid) == false then
		_friend_add_info_is_new = true
		-- print("run FriendAddModel:add_friend")
		print("FriendAddModel:add_friend tid, taddType, tcampid, tlevel, tname",tid, taddType, tcampid, tlevel, tname)
		FriendAddModel:insert_add_info(tid, taddType, tcampid, tlevel, tname)
		local add_num = #_friend_add_info
		MiniBtnWin:show(1, FriendAddModel.click_friend_btn_function, add_num )
	end
end
-----------
function FriendAddModel:click_friend_btn_function()
	UIManager:show_window("friend_accept_win")
	------
	local acc_win = UIManager:find_visible_window("friend_accept_win")
	--print("acc_win,_friend_add_info_is_new",acc_win,_friend_add_info_is_new)
	if acc_win ~= nil and _friend_add_info_is_new == true then
		acc_win:model_function(FriendConfig.EventType.SCROLL_CLEAR)
		acc_win:model_function(FriendConfig.EventType.SCROLL_ADD_ITEM)
		_friend_add_info_is_new = false
	end
	------	
end
-----------
-----------
-----------非数据区操作
function FriendAddModel:ok_btn_click_function()
	for i = 1 , #_friend_add_info do
		FriendCC:send_add_friend( _friend_add_info[i].id, 1, 1)
	end
	-- for i = 1, #_friend_add_info do
	-- 	_friend_add_info
	-- end
	_friend_add_info = nil
	_friend_add_info = {}
	local friend_add_win = UIManager:find_window("friend_accept_win")
	friend_add_win.scroll.view:reinitScroll()
	UIManager:hide_window("friend_accept_win")
end
-----------
-----------
-----------
function FriendAddModel:reject_btn_click_function()
	_friend_add_info = nil
	_friend_add_info = {}
	local friend_add_win = UIManager:find_window("friend_accept_win")
	friend_add_win.scroll.view:reinitScroll()
	UIManager:hide_window("friend_accept_win")
end
-----------
-----------
local function createItem(id, level, camp, name, width, height)
	require "UI/component/TextButton"
	local acc_win = UIManager:find_window("friend_accept_win")
	-- print("createItem id, level, camp, name, width, height",id, level, camp, name, width, height)
	-- local scroll_info = acc_win:model_function(FriendConfig.EventType.SCROLL_INFO)
	-- local perGridSize = {width = scroll_info.width, height = scroll_info.height / scroll_info.maxnum}
	local window_size = {width = 960, height = 640}
	local button_info = {width = 96, height = 43, text = Lang.friend.friendadd[1], image = {UILH_COMMON.button2_sel, UILH_COMMON.button2_sel} } -- [1]="接受"
	local campInfo = Lang.camp_info[camp]
	local text_one_info = { size = 16, text = string.format( Lang.friend.model[1], name,level) } -- [1]="%s(%s级)"
	local text_two_info = {size = 16, text = Lang.friend.model[2]} -- [2]="申请加你为好友，是否同意？"
	-------
	local accept = TextButton:create( nil, width - button_info.width, (height - button_info.height) / 2-5, -1, -1, button_info.text, button_info.image, window_size.width, window_size.width)
	-------
	local function click_fun()
		local tempId = id
		--local item = accept
		--print("run click fun, id ",tempId)
		FriendCC:send_add_friend( tempId, 1, 1)
		FriendAddModel:delete_add_info( tempId )
		local friend_accept_win = UIManager:find_window("friend_accept_win")
		friend_accept_win.scroll.view:reinitScroll()
		friend_accept_win.scroll:refresh()
		print("friend_accept_win #_friend_add_info",#_friend_add_info)
		if #_friend_add_info <= 0 then
			UIManager:hide_window("friend_accept_win")
		end
	end	
	accept:setTouchClickFun(click_fun)
	-------
	local label_two = Label:create( nil, 0, (height - button_info.height) / 2, text_two_info.text, text_two_info.size)
	local label_two_pos = label_two:getPosition()
	-------
	local label_one = Label:create( nil, 0, label_two_pos.y + text_two_info.size+10, text_one_info.text, text_one_info.size)	
	-------
	local basepanel = BasePanel:create( nil, 0, 0, width, height)
	-------
	local line = ZImage.new(UILH_COMMON.split_line)
	line:setPosition(0, 5)
	line:setSize(width, 2)
	basepanel:addChild(accept)
	basepanel:addChild(label_one)
	basepanel:addChild(label_two)
	basepanel:addChild(line)
	return basepanel
end
-----------
-----------
function FriendAddModel:scroll_create_function(index)
	-----------
	local info_num = #_friend_add_info
	--print("index ,infonum",index,info_num - 1)
	if index <= info_num then
		require "UI/component/BasePanel"
		require "UI/component/TextButton"
		require "UI/component/Label"
		require "UI/component/List"
		local acc_win = UIManager:find_window("friend_accept_win")
		local sumnum = 2
		if acc_win ~= nil then
			if #_friend_add_info <= 0 then
				return
			end
			local scroll_info = acc_win:model_function(FriendConfig.EventType.SCROLL_INFO)
			local list = List:create( nil, 0, 0, scroll_info.width, scroll_info.height, 1, sumnum)--,"ui/common/bg03.png",500,500)
			for i = 1, sumnum do
				local curIndex = index * sumnum + i
				--print("curIndex",curIndex)
				if curIndex <= #_friend_add_info then
					local tarItem = createItem(_friend_add_info[curIndex].id, _friend_add_info[curIndex].level, _friend_add_info[curIndex].campId, _friend_add_info[curIndex].name, scroll_info.width, scroll_info.height / sumnum)
					list:addItem(tarItem)
				end
			end
			return list
		end
	end
end
-----------
-----------
function FriendAddModel:exit_btn_click_function()
	UIManager:hide_window("friend_accept_win")
	_friend_add_info = {}
	_friend_add_info_is_new = false
end
-----------
-----------
