-----near.lua
-----HJH
-----2013-2-17
-----------最近页
super_class.Near(Window)
-----------
-----------
local _window_size					= {width = 800, height = 480}
local _title_info 					= {width = 275, height = 10, size = { 205, 85, 85 }, myfriend = Lang.friend.near[1], level = Lang.friend.blacklist[2], job = Lang.friend.blacklist[3]} -- [1]="最近联系人(0/0)" -- [2]="等级" -- [3]="职业"
--xiehande   UILH_FRIEND010 ->UIPIC_COMMOM_002
local _set_info						= {width = -1, height = -1, text = Lang.friend.myfriend[2], image = {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor} } -- [2]="个人设置"
local _get_friend_info				= {width = -1, height = -1, text = Lang.friend.myfriend[3], image_bg = {UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor} } -- [3]="一键征友"
local _notic_info					= {text = Lang.friend.myfriend[4], size = 14} -- [4]="#c00c0ff一键征友：快速向12个在线仙友发送申请"
local _bg_info						= {x=23,y=97,height = 370, image = UILH_COMMON.bottom_bg}
local _scroll_info					= {height = 315, page_num = 10, maxnum = 1, gapSize = 10, scrollType = TYPE_HORIZONTAL_EX, scrollRunType = RUN_TYPE_PAGE}
local _line_info					= {width = 340, height = -1, image = UILH_COMMON.split_line}
-----------
function Near:createNear(fatherPanel, width, height)
	-----------
	-- require "UI/component/ListVertical"
	-- require "UI/component/Label"
	-- require "UI/component/Scroll"
	-- require "UI/component/TextButton"
	-- require "UI/component/Image"
	-- require "UI/component/ImageButton"
	-- require "model/FriendModel/FriendModel"
	-----------
	self.title = ZListVertical:create( nil, 0, height - _title_info.height+15, width-30, _title_info.height+15, _title_info.size)
	local myfriendLabel = ZLabel:create( nil, _title_info.myfriend, 0, 0)
	local levelLabel = ZLabel:create( nil, _title_info.level, 0, 0)
	local jobLevel = ZLabel:create( nil, _title_info.job, 0, 0)
	self.title:addItem(myfriendLabel)
	self.title:addItem(levelLabel)
	self.title:addItem(jobLevel)
	-----------
	_notic_info.text = string.format(Lang.friend.myfriend[4]) -- [4]="#c00c0ff一键征友：快速向12个在线仙友发送申请"
	self.notic_text = ZLabel:create( nil, _notic_info.text, 15, 10, _notic_info.size)
	local notic_text_size = self.notic_text:getSize()
	self.notic_text:setPosition( (width - notic_text_size.width) / 2+16, 26)
	-----------
	self.scroll = ZScroll:create( nil , nil, 30, 110, width-50, _scroll_info.height, _scroll_info.maxnum, _scroll_info.scrollType )
	self.scroll:setScrollLump(11, 50, _scroll_info.height )
	self.scroll:setScrollLumpPos(365)
	--self.scroll.view:setScrollLumpPos(width - 15)
	self.scroll:setScrollCreatFunction(FriendModel.near_scroll_create_function)
	-----------
	self.set_btn = ZTextButton:create( nil, _set_info.text, _set_info.image, nil, 29, notic_text_size.height +25, _set_info.width, _set_info.height, nil, _window_size.width, _window_size.width)
	self.set_btn:setTouchClickFun(FriendModel.near_set_btn_click_function)
	-----------
	self.get_friend_btn = ZTextButton:create( nil,_get_friend_info.text, _get_friend_info.image_bg, nil, width - _get_friend_info.width-138, notic_text_size.height +25, _get_friend_info.width, _get_friend_info.height)
	self.get_friend_btn:setTouchClickFun(FriendModel.near_get_friend_btn_function)
	-----------
	-- self.line = ZImage:create( nil, _line_info.image, 0, height - _title_info.height - 8, _line_info.width, _line_info.height)
	-----------
	self.bg = ZImage:create( nil, _bg_info.image, _bg_info.x, _bg_info.y, width-30, _bg_info.height, nil, _window_size.width, _window_size.width)
	-----------
	--标题背景图
	self.title_bg=CCZXImage:imageWithFile(14,429,width-32,33,UILH_NORMAL.title_bg4,500,500)

	--滚动条箭头
	local arrow_up = CCZXImage:imageWithFile(width-25 , 105 + _scroll_info.height, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(width-25, 110, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)

	self.view:addChild(self.bg.view)
	-- self.view:addChild(self.line.view)
	self.view:addChild(self.title_bg)
	self.view:addChild(self.title.view)
	self.view:addChild(self.scroll.view)
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	-- self.view:addChild(self.notic_text.view)
	self.view:addChild(self.set_btn.view)
	self.view:addChild(self.get_friend_btn.view)
	
end
-----------
-----------
function Near:__init(windowName,texture_name, is_grid, width, height)
	self:createNear(nil, width, height)
end
-----------
function Near:clear_scroll_item()
	self.scroll:clear()
end
-----------
function Near:refresh_scroll_item()
	self.scroll:refresh()
end
-----------
function Near:get_scroll_info()
	if self.scroll ~= nil then
		local size = self.scroll:getSize()
		return {width = size.width, height = size.height, num = _scroll_info.page_num, cur_max_num = self.scroll.view:getMaxNum()}
	end
end
-- -----------
-- function Near:update_tip_info()
-- 	local item = self.title:getIndexItem(1)
-- 	if item ~= nil then
-- 		local curOnlineNum = FriendModel:get_near_online_num()
-- 		local curMaxNum = FriendModel:get_near_info_num()
-- 		item:setText(string.format("最近联系人(%d/%d)",curOnlineNum,curMaxNum))
-- 	end
-- end
----------
function Near:update_title_info()
	if self.title ~= nil then
		local templabel = self.title:getIndexItem(1)
		require "model/FriendModel/FriendModel"
		local online_num = FriendModel:get_near_online_num()
		local max_num = FriendModel:get_near_info_num()
		templabel:setText( string.format(Lang.friend.near[2],online_num, max_num) ) -- [2]="最近联系人(%d/%d)"
	end
end
----------
function Near:update_notic_info()
	if self._notic_info ~= nil then
		self._notic_info:setText( string.format(Lang.friend.myfriend[4] ) ) -- [4]="#c00c0ff一键征友：快速向12个在线仙友发送申请"
	end
end
