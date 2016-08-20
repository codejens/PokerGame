-----friendaddmode.lua
-----HJH
-----2013-2-17
-----------
-- super_class.FriendFlowerThankModel()
FriendFlowerThankModel = {}
-----------
local _friend_flower_thank_is_new = false
----info : id, num, camp, job, level, sex, name, icon
local _friend_flower_thank_info = {}
local _self_window = nil

-----------
-- added by aXing on 2013-5-25
function FriendFlowerThankModel:fini( ... )
	_friend_flower_thank_is_new = false
	_friend_flower_thank_info = {}
	_self_window = nil
end
-----------
function FriendFlowerThankModel:insert_add_info(tid, tnum, tcamp, tjob, tlevel, tsex, tname, ticon)
	local index = #_friend_flower_thank_info
	local value = { id = tid, num = tnum, camp = tcamp, level = tlevel, sex = tsex, name = tname, icon = ticon }	
	table.insert( _friend_flower_thank_info, index + 1, value)
end
-----------
function FriendFlowerThankModel:delete_add_info(tid)
	local tarindex = nil
	for i = 1, #_friend_flower_thank_info do
		--print("#friend_adD_info",#_friend_add_info)
		if _friend_flower_thank_info[i].id == tid then
			table.remove( _friend_flower_thank_info, i)
			return
		end
	end
end
-----------
function FriendFlowerThankModel:add_friend(tid, tnum, tcamp, tjob, tlevel, tsex, tname, ticon)
	_friend_flower_thank_is_new = true
	-- print("run FriendAddModel:add_friend")
	-- print("tid, taddType, tcampid, tlevel, tname",tid, taddType, tcampid, tlevel, tname)
	FriendFlowerThankModel:insert_add_info(tid, tnum, tcamp, tjob,tlevel, tsex,tname, ticon)
	local add_num = #_friend_flower_thank_info
	MiniBtnWin:show(4, FriendFlowerThankModel.click_friend_btn_function, add_num )
end
-----------
function FriendFlowerThankModel:click_friend_btn_function()
	local acc_win = UIManager:show_window("friend_flower_thank_win")
	------
	--local acc_win = UIManager:find_visible_window("friend_flower_thank_win")
	--print("acc_win,_friend_add_info_is_new",acc_win,_friend_add_info_is_new)
	if _friend_flower_thank_is_new == true then
		acc_win.scroll.view:reinitScroll()
		acc_win.scroll:refresh()
		_friend_flower_thank_is_new = false
	end
	------	
end
-----------
-----------
-----------非数据区操作
function FriendFlowerThankModel:ok_btn_click_function()
	local thank_msg = Lang.chat.mode_str[11] -- [11]="好感动啊!谢谢你送的花,真的好漂亮,我好喜欢!"
	thank_msg = string.format("%d%s%s", ChatConfig.PrivateChatType.TYPE_THANK_CHAT_INFO, ChatConfig.message_split_target.CHAT_INFO_PRIVAT_TARGET, thank_msg)
	for i = 1 , #_friend_flower_thank_info do
		ChatCC:send_private_chat(_friend_flower_thank_info[i].id, 0, _friend_flower_thank_info[i].name, thank_msg)
	end
	_friend_flower_thank_info = nil
	_friend_flower_thank_info = {}
	local friend_add_win = UIManager:find_window("friend_flower_thank_win")
	friend_add_win.scroll.view:reinitScroll()
	UIManager:hide_window("friend_flower_thank_win")
	-- self.ok_button:setCurState(CLICK_STATE_DISABLE)
	-- self.reject_button:setCurState(CLICK_STATE_DISABLE)
end
-----------
-----------
-----------
function FriendFlowerThankModel:reject_btn_click_function()
	_friend_flower_thank_info = nil
	_friend_flower_thank_info = {}
	local friend_add_win = UIManager:find_window("friend_flower_thank_win")
	friend_add_win.scroll.view:reinitScroll()
	UIManager:hide_window("friend_flower_thank_win")
	-- self.ok_button:setCurState(CLICK_STATE_DISABLE)
	-- self.reject_button:setCurState(CLICK_STATE_DISABLE)
end
-----------
-----------
local function createItem(id, num, camp, name, width, height)
	require "UI/component/TextButton"
	local acc_win = UIManager:find_window("friend_flower_thank_win")
	-- local scroll_info = acc_win:model_function(FriendConfig.EventType.SCROLL_INFO)
	-- local perGridSize = {width = scroll_info.width, height = scroll_info.height / scroll_info.maxnum}
	local window_size = {width = 960, height = 640}
	local button_info = {width = 99, height = 53, text = Lang.chat.private[6], image = {UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s} } -- [6]="查看"
	local campInfo = Lang.camp_info[camp]
	local text_one_info = { size = 17, text = string.format( "%s", name) }
	local text_two_info = {size = 17, text = string.format(Lang.friend.model[7],num) } -- [7]="送上#cffd700【%d朵玫瑰】"
	-------
	local accept = TextButton:create( nil, width - button_info.width, (height - button_info.height) / 2, -1, -1, button_info.text, button_info.image, window_size.width, window_size.width)
	-------
	local function click_fun()
		local tempId = id
		local tempNum = num
		local tempName = name
		UIManager:hide_window("friend_flower_thank_win")
		--UIManager:close_all_window()
		require "model/ChatModel/ChatThankModel"
		ChatThankModel:open_thank_info(tempId, nil, nil, nil, nil, tempNum, tempName, nil)
		--print("run click fun, id ",tempId)
		--FriendCC:send_add_friend( tempId, 1, 1)
		FriendFlowerThankModel:delete_add_info( tempId )
		--item:setCurState(CLICK_STATE_DISABLE)
	end	
	accept:setTouchClickFun(click_fun)
	-------
	local label_two = Label:create( nil, 0, (height - button_info.height) / 2+7, text_two_info.text, text_two_info.size)
	local label_two_pos = label_two:getPosition()
	-------
	local label_one = Label:create( nil, 0, label_two_pos.y + text_two_info.size+8, text_one_info.text, text_one_info.size)	

	local line = ZImage.new(UILH_COMMON.split_line)
	line:setPosition(0, 2)
	line:setSize(width, 3)
	-------
	local basepanel = BasePanel:create( nil, 0, 0, width, height)
	-------
	basepanel:addChild(accept)
	basepanel:addChild(label_one)
	basepanel:addChild(label_two)
	basepanel:addChild(line)
	return basepanel
end
-----------
-----------
function FriendFlowerThankModel:scroll_create_function(index)
	-----------
	local info_num = #_friend_flower_thank_info
	print("index ,infonum",index,info_num)
	if index <= info_num then
		-- require "UI/component/BasePanel"
		-- require "UI/component/TextButton"
		-- require "UI/component/Label"
		-- require "UI/component/List"
		local acc_win = UIManager:find_window("friend_flower_thank_win")
		local sumnum = 2
		--print("acc_win",acc_win)
		if acc_win ~= nil then
			if #_friend_flower_thank_info <= 0 then
				return 
			end
			acc_win.scroll.view:setMaxNum(info_num)
			local scrollSize = acc_win.scroll:getSize()
			local scrollMaxnum = acc_win.scroll:getMaxNum()
			local scroll_info = { width = scrollSize.width, height = scrollSize.height, maxnum = scrollMaxnum }
			local list = List:create( nil, 0, 0, scroll_info.width, scroll_info.height, 1, sumnum)--,"ui/common/bg03.png",500,500)
			for i = 1, sumnum do
				local curIndex = index * sumnum + i
				-- print("curIndex,#_friend_flower_thank_info",curIndex,#_friend_flower_thank_info)
				if curIndex <= #_friend_flower_thank_info then
					--id, num, camp, name, width, height
					local tarItem = createItem(_friend_flower_thank_info[curIndex].id, _friend_flower_thank_info[curIndex].num, _friend_flower_thank_info[curIndex].camp, _friend_flower_thank_info[curIndex].name, scroll_info.width, scroll_info.height / sumnum)
					list:addItem(tarItem)
				end
			end
			return list
		end
	end
end
-----------
-----------
function FriendFlowerThankModel:exit_btn_click_function()
	UIManager:hide_window("friend_flower_thank_win")
end
-----------
-----------
