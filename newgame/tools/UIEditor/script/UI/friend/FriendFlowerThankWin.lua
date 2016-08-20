-----friendadd.lua
-----HJH
-----2013-2-17
-----------鲜花感谢接收界面
super_class.FriendFlowerThankWin(Window)
-----------
-----------
local _window_size								= {width = 800, height = 480}
local _exit_info 								= {width = 60, height = 60, image = {UIPIC_COMMOM_008,UIPIC_COMMOM_008} }
local _accept_info								= {width = 96, height = 43, text = Lang.friend.friendadd[1], image = UIPIC_COMMON_BUTTON_001 } -- Lang.friend.friendadd[1]="接受"
local _ok_info									= {width = 126, height = 43, text = Lang.friend.common[3], image = {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel} } -- Lang.friend.common[3]="全部感谢"

local _reject_info								= {width = 126, height = 43, text = Lang.chat.private[7], image = {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel} } -- Lang.chat.private[7]="全部忽略"
local _scroll_info								= {width = 320, height = 160, maxnum = 1, ttype = TYPE_HORIZONTAL_EX, gapSize = 0}
local _reinit_info								= nil
-----------
function FriendFlowerThankWin:createAdd(width, height)
	-----------
	-- require "model/FriendModel/FriendFlowerThankModel"
	-- require "UI/component/TextButton"
	-- require "UI/component/Scroll"
	-- require "UI/component/Button"
	-- require "UI/component/Image"
	-----------
	self.ok_button = ZTextButton:create( nil, _ok_info.text, _ok_info.image, nil, 50, 23, -1, -1, nil, _window_size.width, _window_size.width)
	self.ok_button:setTouchClickFun(FriendFlowerThankModel.ok_btn_click_function)
	-----------
	self.reject_button = ZTextButton:create( nil, _reject_info.text, _reject_info.image, nil, width - 50 - _reject_info.width, 23, -1, -1, nil, _window_size.width, _window_size.width)
	self.reject_button:setTouchClickFun(FriendFlowerThankModel.reject_btn_click_function)
	-----------
	self.scroll = ZScroll:create( nil, nil, 50, 95, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum)
	local scroll_pos = self.scroll:getPosition()
	local scroll_size = self.scroll:getSize()
	self.scroll:setScrollCreatFunction(FriendFlowerThankModel.scroll_create_function)
	-----------
	self.exit_button = ZButton:create( nil, _exit_info.image, nil, 0, 0, 60, 60)
	local exit_size = self.exit_button:getSize()
	self.exit_button:setPosition(363,278)
	_exit_info.width = exit_size.width
	_exit_info.height = exit_size.height
	self.exit_button:setTouchClickFun(FriendFlowerThankModel.exit_btn_click_function)
	-----------
	local bg2 = ZImage:create( nil, UILH_COMMON.bottom_bg, 28, 82, 360, 180, nil, _window_size.width, _window_size.width)
	-----------
	self.view:addChild(bg2.view)
	self.view:addChild(self.scroll.view)
	self.view:addChild(self.reject_button.view)
	self.view:addChild(self.ok_button.view)
	self.view:addChild(self.exit_button.view)
	-----------
	-----------
	self.view:setPosition(270,160);
    self:create_title()
end

function FriendFlowerThankWin:create_title(  )
    --标题背景
    local title_bg = CCBasePanel:panelWithFile( 0, 0, -1, 60, UIPIC_COMMOM_title_bg )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( self.view:getSize().width - title_bg_size.width ) / 2, self.view:getSize().height - title_bg_size.height/2-14)
    local title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  UILH_NORMAL.title_tips  )
    title:setAnchorPoint(0.5,0.5)
    title_bg:addChild( title )
   	self.view:addChild( title_bg )
end
-----------
-----------
-- function FriendFlowerThankWin:model_function(eventType)
-- 	if eventType == FriendConfig.EventType.SCROLL_CLEAR then
-- 		self.scroll:clear()
-- 	elseif eventType == FriendConfig.EventType.SCROLL_ADD_ITEM then
-- 		self.scroll:refresh()
-- 	elseif eventType == FriendConfig.EventType.SCROLL_INFO then
-- 		local scrollSize = self.scroll:getSize()
-- 		local scrollMaxNum = self.scroll:getMaxNum()
-- 		return { width = scrollSize.width, height = scrollSize.height, maxnum = scrollMaxNum}
-- 	end
-- end
-----------
-----------
function FriendFlowerThankWin:__init(window_name, texture_name, is_grid, width, height)
	self:createAdd(width, height)
end
