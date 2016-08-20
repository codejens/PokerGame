-----HJH
-----2013-2-17
-----------黑名单
super_class.BlackList(Window)
-----------
-----------

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _window_size							= {width = 960, height = 640}
local _title_info							= {width = 275, height = 10, size = { 205, 85, 85 }, myenemy = Lang.friend.blacklist[1], kill = Lang.friend.blacklist[2], bekill = Lang.friend.blacklist[3]} -- [1]="我的黑名单(0/0)" -- [2]="等级" -- [3]="职业"
local _scroll_info							= {height = 315, page_num = 10, maxnum = 1, gapSize = 10, scrollType = TYPE_HORIZONTAL_EX, scrollRunType = RUN_TYPE_PAGE}
local _edit_info							= {x = 44, y = 43, width = 250, height = 45, maxnum = 100, image = UILH_COMMON.bg_02, default_text_info = Lang.friend.common[1]} -- [1055]="点击输入玩家名称"
      --xiehande   UILH_FRIEND010 ->UIPIC_COMMOM_002
local _add_backlist_info					= {width = -1, height = -1, image = {UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor}, text = Lang.friend.blacklist[4]} -- [1056]="拉 黑"
local _bg_info								= {x=23,y=97,height = 370, image = UILH_COMMON.bottom_bg}
local _line_info							= {width = 340, height = -1, image = UILH_COMMON.split_line}
-----------
function BlackList:createBlackList(fatherPanel, width, height)
	-----------
	-- require "UI/component/ListVertical"
	-- require "UI/component/Label"
	-- require "UI/component/Scroll"
	-- require "UI/component/EditBox"
	-- require "UI/component/TextButton"
	-- require "UI/component/Image"
	-- require "model/FriendModel/FriendModel"
	-----------
	self.title = ZListVertical:create( nil, 0, height - _title_info.height+15, width-30, _title_info.height+15, _title_info.size)
	local enemyLabel = ZLabel:create(nil, _title_info.myenemy, 0, 0)
	local killLabel = ZLabel:create(nil, _title_info.kill, 0, 0)
	local bekillLabel = ZLabel:create(nil, _title_info.bekill, 0, 0)
	self.title:addItem(enemyLabel)
	self.title:addItem(killLabel)
	self.title:addItem(bekillLabel)
	-----------
	self.scroll = ZScroll:create( nil, nil, 30 ,110, width-50, _scroll_info.height, _scroll_info.maxnum, _scroll_info.scrollType)
	self.scroll:setScrollLump(11, 50, _scroll_info.height )
	self.scroll:setScrollLumpPos(365)
	--self.scroll.view:setScrollLumpPos(width - 15)
	self.scroll:setScrollCreatFunction(FriendModel.blacklist_scroll_create_function)
	-----------
	self.editbox = EditBox:create( fatherPanel, _edit_info.x-6, _edit_info.y, _edit_info.width, _edit_info.height, _edit_info.maxnum, _edit_info.image, 16, _window_size.width, _window_size.width)
	
	local function keyboard_show( eventType,arg )
		local temparg = Utils:Split(arg,":");
        local keyboard_width = tonumber(temparg[1])
        local keyboard_height = tonumber(temparg[2])
        
        if self.editbox_attach then
			FriendModel:keyboard_show(keyboard_width,keyboard_height)
		end
	end
	local function keyboard_hide( eventType,arg )
		local temparg = Utils:Split(arg,":");
        local keyboard_width = tonumber(temparg[1])
        local keyboard_height = tonumber(temparg[2])
		FriendModel:keyboard_hide()
				
	end
	local function keyboard_attach(  )
		self.editbox_attach = true;
	end
	local function keyboard_finish(  )
		self.editbox.view:detachWithIME()
		self.editbox_attach = false
	end
	
	self.editbox:setKeyBoardShowFunction(keyboard_show)
	self.editbox:setKeyBoardHideFunction(keyboard_hide)
	self.editbox:setKeyBoardAttachFunction(keyboard_attach)
	self.editbox:setKeyBoardFinishFunction(keyboard_finish)

	-----------
	--拉黑按钮
	self.add_backlist_btn = ZTextButton:create( nil, _add_backlist_info.text, _add_backlist_info.image, nil, _edit_info.x + _edit_info.width -2, 41, _add_backlist_info.width, _add_backlist_info.height, nil, _window_size.width, _window_size.width)
	self.add_backlist_btn:setTouchClickFun(FriendModel.blacklist_add_backlist_btn_click_fun)
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
	self.view:addChild(self.title_bg)
	-- self.view:addChild(self.line.view)
	self.view:addChild(self.title.view)
	self.view:addChild(self.scroll.view)
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	self.view:addChild(self.editbox.view)
	self.view:addChild(self.add_backlist_btn.view)
	
	local function self_view_func( eventType )
		if eventType == TOUCH_BEGAN then
			if self.editBox then
				self.editBox.view:detachWithIME();
			end
		end
		return true
	end
	self.view:registerScriptHandler(self_view_func)
end
-----------
-----------
function BlackList:__init(windowName, texture_name, is_grid, width, height)
	self:createBlackList(nil, width, height)
end
-----------
function BlackList:clear_scroll_item()
	self.scroll:clear()
end
-----------
function BlackList:refresh_scroll_item()
	self:update_title_info()
	self.scroll:refresh()
end
-----------
function BlackList:get_scroll_info()
	if self.scroll ~= nil then
		local size = self.scroll:getSize()
		return {width = size.width, height = size.height, num = _scroll_info.page_num, cur_max_num = self.scroll.view:getMaxNum()}
	end
end
-- -----------
-- function BlackList:update_tip_info()
-- 	local item = self.title:getIndexItem(1)
-- 	if item ~= nil then
-- 		local curOnlineNum = FriendModel:get_blacklist_online_num()
-- 		local curMaxNum = FriendModel:get_blacklist_info_num()
-- 		item:setText(string.format("我的黑名单(%d/%d)",curOnlineNum,curMaxNum))
-- 	end
-- end
----------
function BlackList:update_title_info()
	if self.title ~= nil then
		local templabel = self.title:getIndexItem(1)
		--require "model/FriendModel/FriendModel"
		local online_num = FriendModel:get_blacklist_online_num()
		local max_num = FriendModel:get_blacklist_info_num()
		templabel:setText( string.format(Lang.friend.blacklist[5],online_num, max_num) ) -- [5]="我的黑名单(%d/%d)"
	end
end
-- ----------
-- function BlackList:update_notic_info(num)
-- 	if self._notic_info ~= nil then
-- 		self._notic_info:setText( string.format("#c00c0ff一键征友：每天%d次，快速向12个在线仙友发送申请",FriendModel:get_get_times_num() )
-- 	end
-- end

