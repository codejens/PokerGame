-----friendwin.lua
-----HJH
-----2013-2-17
-----------好友界面
require "model/FriendModel/FriendModel"
-----------
super_class.FriendWin(NormalStyleWindow)
------------
------------

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _refresh_time = 10
--local _friend_info			= {}
local _window_size			= {width = 800, height = 480}

------------
-- local _title_info 			= {width = 230, height = 43, text = Lang.friend.common[4], image = UILH_FRIEND[1], image_text = UILH_FRIEND[2] } -- [4]="好友"

local _edit_boX_info		= {x = 24, y = 495, width = 265, height = 45, maxnum = 10, image = UILH_COMMON.bg_02, default_text_info = Lang.friend.common[1]} -- [1]="点击输入玩家名称"

local _button_info 			= {
width = 92, 
height = 37,
 image = {UILH_COMMON.button_2_n, UILH_COMMON.button_2_s}, 
bt_friend_text = Lang.friend.common[4], bt_enemy_text = Lang.friend.common[5], bt_blacklist_text = Lang.friend.infowin[2], bt_near_text = Lang.friend.common[6]
}

--xiehande
local _radio_item_info 			= {
width = 92, 
height = 37,
image = {
					{UILH_FRIEND.Haoyou1,UILH_FRIEND.Haoyou},
					{UILH_FRIEND.Chouren1,UILH_FRIEND.Chouren}, 
					{UILH_FRIEND.Heiming1,UILH_FRIEND.Heiming},
					{UILH_FRIEND.Zuijin1,UILH_FRIEND.Zuijin}
			
},
 image_bg = {UILH_COMMON.button_2_n, UILH_COMMON.button_2_s}, 

bt_friend_text = Lang.friend.common[4], bt_enemy_text = Lang.friend.common[5], bt_blacklist_text = Lang.friend.infowin[2], bt_near_text = Lang.friend.common[6]
}

 -- [4]="好友" -- [5]="仇人" -- [2]="黑名单" -- [6]="最近"
 -- xiehande UILH_FRIEND006->UIPIC_COMMOM_001
local _find_info 			= {width = 99, height = -1, text = Lang.friend.common[7], image = {UIPIC_COMMOM_001, UIPIC_COMMOM_001} } -- [7]="查找"

-- local _exit_info			= {width = 62, height = 56, image = {UILH_FRIEND[8],UILH_FRIEND[8]}}

------------
function FriendWin:create_friend(width, height)
	require "UI/friend/MyFriend"
	require "UI/friend/Enemy"
	require "UI/friend/BlackList"
	require "UI/friend/Near"
	--好友底色
	local friend_bgcolor = ZImage:create( nil, UILH_COMMON.normal_bg_v2, 8, 8, 420, 560 , nil, 500, 500)
	self.view:addChild(friend_bgcolor.view)
	--好友列表底色
	-- local list_bgcolor = ZImage:create( nil, "", 20, 20, 410, 480, nil, 500, 500 )
	-- self.view:addChild(list_bgcolor.view)
	----------标题栏
	-- self.title = ZImageImage:create(nil, _title_info.image_text, _title_info.image, (width - _title_info.width) / 2,
	--  height - _title_info.height, _title_info.width, _title_info.height)
	-- self.title:setGapSize(-5, 4)
	--TextImage:create( nil, (width - _title_info.width) / 2, height - _title_info.height, _title_info.width, _title_info.height, _title_info.text, _title_info.image )
	------------输入框
	self.editBox = EditBox:create( nil, _edit_boX_info.x+10 , _edit_boX_info.y+10, _edit_boX_info.width, _edit_boX_info.height, _edit_boX_info.maxnum, _edit_boX_info.image, 16, _window_size.width, _window_size.width)
	local function editbox_func( eventType, arg )
		if eventType == KEYBOARD_FINISH_INSERT then
			self.editBox.view:detachWithIME()
		end
		return true
	end
	self.editBox.view:registerScriptHandler(editbox_func)

	------------查找按钮
	local friend_btn_click_fun = function(  )
		-- self:hide_keyboard()
		-- FriendModel:friend_btn_click_fun()
		FriendModel.find_btn_click_fun()
	end
	--x = 44, y = 505, width = 265, height = 29
	self.find_btn = ZTextButton:create( nil, _find_info.text, _find_info.image, nil, 309, 502, _find_info.width, _find_info.height)
	self.find_btn:setTouchClickFun(friend_btn_click_fun)

	------------好友按钮
	self.friend_btn = ZTextButton:create( nil, _radio_item_info.bt_friend_text, _radio_item_info.image_bg, nil, 0, 20,-1,-1, nil, 500, 500)
	
	-- self.friend_btn = ZImageButton:create( nil,  _radio_item_info.image_bg, _radio_item_info.image[1][1],nil, 0, 20,101,40, nil, 500, 500)
	self.friend_btn:setTouchClickFun(FriendModel.friend_btn_click_fun)
	------------好友信息页
	local temp_panel_info = { texture = "", x = 0, y = 30, width = 420, height = 433 }
	self.myfriend = MyFriend("MyFriend", temp_panel_info.texture,true,temp_panel_info.width,temp_panel_info.height)
	--_friend_info[FriendConfig.WinType.TYPE_MY_FRIEND] = myfriend
	self.myfriend.view:setIsVisible(true)

	------------仇人按钮
	self.enemy_btn = ZTextButton:create( nil, _radio_item_info.bt_enemy_text, _radio_item_info.image_bg, nil, 0, 27,-1,-1, nil, 500, 500)
	-- self.enemy_btn = ZImageButton:create( nil, _radio_item_info.image_bg, _radio_item_info.image[2][1], nil, 0, 27,101,40, nil, 500, 500)
	self.enemy_btn:setTouchClickFun(FriendModel.enemy_btn_click_fun)

	------------仇人信息页
	self.enemy = Enemy("Enemy", temp_panel_info.texture,true,temp_panel_info.width,temp_panel_info.height)
	--_friend_info[FriendConfig.WinType.TYPE_ENEMY] = enemy

	self.enemy.view:setIsVisible(false)
	------------黑名单按钮 xiehande
	self.backlist_btn = ZTextButton:create( nil, _radio_item_info.bt_blacklist_text, _radio_item_info.image_bg, nil, 0, 27,-1,-1, nil, 500, 500)
	-- self.backlist_btn = ZImageButton:create( nil, _radio_item_info.image_bg, _radio_item_info.image[3][1], nil, 0, 27,101,40, nil, 500, 500)
	self.backlist_btn:setTouchClickFun(FriendModel.backlist_btn_click_fun)

	------------黑名单页
	self.blacklist = BlackList("BlackList", temp_panel_info.texture,true,temp_panel_info.width,temp_panel_info.height)
	--_friend_info[FriendConfig.WinType.TYPE_BLACK_LIST] = blacklist
	self.blacklist.view:setIsVisible(false)
	------------最近按钮 xiehande
	self.near_btn = ZTextButton:create( nil, _radio_item_info.bt_near_text, _radio_item_info.image_bg, nil, 0, 27,-1,-1, nil, 500, 500)
	-- self.near_btn = ZImageButton:create( nil,  _radio_item_info.image_bg, _radio_item_info.image[4][1], nil, 0, 27,101,40, nil, 500, 500)
	self.near_btn:setTouchClickFun(FriendModel.near_btn_click_fun)

	------------最近信息页
	self.near = Near("Near", temp_panel_info.texture,true,temp_panel_info.width,temp_panel_info.height)
	--_friend_info[FriendConfig.WinType.TYPE_NEAR] = near
	self.near.view:setIsVisible(false)
	------------退出按钮
	-- self.exit_btn = ZButton:create( nil, _exit_info.image, nil, 0, 0, -1, -1)
	-- local exit_size = self.exit_btn:getSize()
	-- self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height )
	-- self.exit_btn:setTouchClickFun(FriendModel.exit_btn_click_fun)
	------------单选按钮组
	--按钮之间的距离
	local grap_size = 0
	self.radio_button_group = ZRadioButtonGroup:create( nil, _edit_boX_info.x, _edit_boX_info.y - 36, _button_info.width * 4 + 3 * grap_size, _button_info.height + 4);
	self.radio_button_group:addItem(self.friend_btn, grap_size)
	self.radio_button_group:addItem(self.enemy_btn, grap_size)
	self.radio_button_group:addItem(self.backlist_btn, grap_size)
	self.radio_button_group:addItem(self.near_btn, grap_size)
	------------
	-- self.view:addChild(self.title.view)
	self.view:addChild(self.editBox.view)
	self.view:addChild(self.find_btn.view)
	--self.view:addChild(self.exit_btn.view)
	self.view:addChild(self.radio_button_group.view)
	----------
	self.view:addChild(self.myfriend.view)
	self.view:addChild(self.enemy.view)
	self.view:addChild(self.blacklist.view)
	self.view:addChild(self.near.view)
	----------
	self.page_win = {self.myfriend, self.enemy, self.blacklist, self.near}

	----------
	local function self_view_func( eventType )
		if eventType == TOUCH_BEGAN then
			if self.editBox then
				self.editBox.view:detachWithIME();
			end
		end
		return true
	end
	self.view:registerScriptHandler(self_view_func)
    -- self:change_btn_name(1)

end
------------

--xiehande  点击按钮切换字体贴图
function FriendWin:change_btn_name( index )
	-- body
	for i,v in ipairs(self.radio_button_group.item_group) do
		if(i==index) then
          self.radio_button_group:getIndexItem(i-1):set_image_texture(_radio_item_info.image[i][2])
		else
          self.radio_button_group:getIndexItem(i-1):set_image_texture(_radio_item_info.image[i][1])
		end
	end
end


------------
function FriendWin:__init(window_name, texture_name, is_grid, width, height)
	self:create_friend(width, height)
	-- local function panel_function(eventType, arg, msgId, selfItem)
	-- 	if eventType == nil or arg == nil or msgId == nil or selfItem == nil then
	-- 		return
	-- 	end
	-- 	if eventType == TIMER then
	-- 		FriendModel:check_need_clear_all_info()
	-- 	end
	-- 	return true
	-- end
	-- self.view:setTimer(_refresh_time)
	-- self.view:registerScriptHandler(panel_function)
	--self:create_friend_panel_info(width, height)
end

------------
------------清空指定栏信息
function FriendWin:clear_index_scroll_item(index)
print("run clear index scroll item :",index)
	self.page_win[index]:clear_scroll_item()
end
------------
------------刷新指定栏信息
function FriendWin:refresh_index_scroll_item(index)
print("run refresh index scroll item :",index)
	self.page_win[index]:refresh_scroll_item()
end
------------
------------取得指页显隐
function FriendWin:get_index_page_visible(index)
	print("#self.page_win,index",#self.page_win,index)
	return self.page_win[index].view:getIsVisible()
end
------------
------------取得指定栏滑动条信息
function FriendWin:find_index_page_scroll_info(index)
	return self.page_win[index]:get_scroll_info()
end
------------
------------打开好友界面
function FriendWin:open_friend_win()
	--print("run open_friend_win")
	local curIndex = self.radio_button_group:getCurSelect()
	local friend_win = UIManager:show_window("friend_win")
	if curIndex ~= nil then
		--print("curIndex:",curIndex)
		friend_win:clear_index_scroll_item(curIndex + 1)
		friend_win:refresh_index_scroll_item(curIndex + 1)
	end
	friend_win:update_index_tip_info(curIndex + 1)
end
------------
------------设置指定页显隐
function FriendWin:setIndexPanelVisible(index, visible)
	--print("self.page_win[index]",index)
	if self.page_win[index] ~= nil then
		self.page_win[index].view:setIsVisible(visible)
		self:clear_index_scroll_item(index)
		self:refresh_index_scroll_item(index)
	end
end
------------
------------取得好友查找栏内容
function FriendWin:get_friend_insertbox_info()
	if self.editBox ~= nil then
		return self.editBox:getText()
	else
		return ""
	end
end
------------
------------设置好友查找栏内容
function FriendWin:set_friend_insetbox_info(info)
	if self.editBox ~= nil then
		self.editBox:setText(info)
	end
end
------------
------------取得添加仇人栏信息
function FriendWin:get_enemy_insertbox_info()
	if self.enemy ~= nil then
		return self.enemy.editbox:getText()
	else
		return ""
	end
end
------------
------------设置添加仇人栏信息
function FriendWin:set_enemy_insertbox_info(info)
	if self.enemy ~= nil then
		return self.enemy.editbox:setText(info)
	end
end
------------
------------取得拉黑栏信息
function FriendWin:get_black_insertbox_info()
	if self.blacklist ~= nil then
		return self.blacklist.editbox:getText()
	else
		return ""
	end
end
------------
------------设置拉黑拦信息
function FriendWin:set_black_insertbox_info(info)
	if self.blacklist ~= nil then
		return self.blacklist.editbox:setText(info)
	end
end
------------
------------显示
function FriendWin:show_other_data(info)
	-- 这个入口理论上已经没人调用了，所以注释掉。note by guozhinan
	-- local user_attr_win = UIManager:show_window("user_attr_win")
	-- if user_attr_win ~= nil then
	-- 	user_attr_win:open_other_panel(info[1], info[2])
	-- end
end
------------
------------更新指定栏信息
function FriendWin:update_index_tip_info(index)
	--print("self.page_win",self.page_win)
	--print("index",index)
	local friend_win = UIManager:find_window("friend_win")
	if self.page_win ~= nil then
		if index == 1 then
			friend_win:update_my_friend_text_info()
		elseif index == 2 then
			friend_win:update_enemy_text_info()
		elseif index == 3 then
			friend_win:update_black_list_text_info()
		elseif index == 4 then
			friend_win:update_near_text_info()
		end
		--self.page_win[index]:update_tip_info()
	end
end
-- end
function FriendWin:update_my_friend_text_info()
	--print("self.myfriend",self.myfriend)
	if self.myfriend ~= nil then
		self.myfriend:update_title_info()
		self.myfriend:update_notic_info()
	end
end
------------
------------
function FriendWin:update_enemy_text_info()
	if self.enemy ~= nil then
		self.enemy:update_title_info()
	end
end
------------
------------
function FriendWin:update_black_list_text_info()
	if self.blacklist ~= nil then
		self.blacklist:update_title_info()
	end
end
------------
------------
function FriendWin:update_near_text_info()
	if self.near ~= nil then
		self.near:update_title_info()
		self.near:update_notic_info()
	end
end
------------
------------
function FriendWin:update_index_max_num(index, maxnum)
	if index == 1 then
		if self.myfriend ~= nil then
			self.myfriend:setMaxNum(maxnum)
		end
	elseif index == 2 then
		if self.enemy ~= nil then
			self.enemy:setMaxNum(maxnum)
		end
	elseif index == 3 then
		if self.blacklist ~= nil then
			self.blacklist:setMaxNum(maxnum)
		end
	elseif index == 4 then
		if self.near ~= nil then
			self.near:setMaxNum(maxnum)
		end
	end
end	
------------
------------
function FriendWin:destroy()
	self.editBox.view:detachWithIME()
	if self.myfriend then
		self.myfriend:destroy()
	end
	if self.enemy then
		self.enemy:destroy()
	end
	if self.blacklist then
		self.blacklist:destroy()
	end
	if self.near then 
		self.near:destroy()
	end
	Window.destroy(self)
end
------------
----------
function FriendWin:active( show )
	if show then
		self.editBox:setText("")
		-- self.view:setTimer(0)
		-- self.view:setTimer(_refresh_time)
	else
		FriendModel:exit_btn_click_fun()
	end
end

