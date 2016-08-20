-----friendadd.lua
-----HJH
-----2013-2-17
-----------好友祝贺界面
super_class.FriendCelerbrateWin(NormalStyleWindow)
-----------
-----------
local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

-----------
local function createCelerbreate(self,width, height)
	-----------
	--xiehande 通用按钮  btn_lan.png ->button3  btn_lv ->button3
	local _window_size						= {width = 800, height = 480}
	local _btn_one_info						= {width = 260, height = 43, text = Lang.friend.celebrate[1], image = {UIPIC_COMMON_BUTTON_003,UIPIC_COMMON_BUTTON_003} } -- [1]="恭喜恭喜，请再接再厉！"
	local _btn_two_info						= {width = 260, height = 43, text = Lang.friend.celebrate[2], image = {UIPIC_COMMON_BUTTON_003,UIPIC_COMMON_BUTTON_003} } -- [2]="实在厉害，我会追上你的！"
	local _btn_three_info					= {width = 260, height = 43, text = Lang.friend.celebrate[3], image = {UIPIC_COMMON_BUTTON_003, UIPIC_COMMON_BUTTON_003} } -- [3]="恭喜道友修为精进"
	local _exit_info 						= {width = 62, height = 56, image = {UIPIC_COMMOM_008, UIPIC_COMMOM_008} }
	local _dialog_info						= {add_type = ADD_LIST_DIR_DOWN, maxnum = 50}
	-----------
	require "UI/component/Dialog"
	require "UI/component/TextButton"
	require "UI/component/Button"
	require "model/FriendModel/FriendCelerbrateModel"

	local bg_1 = CCBasePanel:panelWithFile(13, 26-8, 394, 240+14,UILH_COMMON.normal_bg_v2, 500, 500)
    self:addChild(bg_1)
    local bg = CCBasePanel:panelWithFile(25, 143, 370, 119,UILH_COMMON.bottom_bg, 500, 500)
    self:addChild(bg)
	-----------
	self.btn_three = ZTextButton:create( nil, _btn_three_info.text,_btn_three_info.image, nil, (width - _btn_three_info.width) / 2, 30, _btn_three_info.width, _btn_three_info.height, nil, _window_size.width, _window_size.width)
	self.btn_three:setTouchClickFun(FriendCelerbrateModel.btn_three_click_function)
	local btn_three_pos = self.btn_three:getPosition()
	self:addChild(self.btn_three)
	-----------
	self.btn_two = ZTextButton:create( nil, _btn_two_info.text, _btn_two_info.image, nil, (width - _btn_two_info.width) / 2, 90, _btn_two_info.width, _btn_two_info.height, nil, _window_size.width, _window_size.width)
	self.btn_two:setTouchClickFun(FriendCelerbrateModel.btn_two_click_function)
	local btn_two_pos = self.btn_two:getPosition()
	self:addChild(self.btn_two)
	-----------
	-- self.btn_one = TextButton:create( nil, (width - _btn_one_info.width) / 2, btn_two_pos.y + 10 + _btn_two_info.height, _btn_one_info.width, _btn_one_info.height, _btn_one_info.text, _btn_one_info.image, _window_size.width, _window_size.width)
	-- self.btn_one:setTouchClickFun(FriendCelerbrateModel.btn_one_click_function)
	-- local btn_one_pos = self.btn_one:getPosition()
	-- self:addChild(self.btn_one)
	-----------
	self.dialog = ZDialog:create( nil, nil, 30, 150 , width - 61, 100, nil, _dialog_info.add_type, _dialog_info.maxnum)
	self:addChild(self.dialog)
	-----------
	-- self.exit = ZButton:create( nil, _exit_info.image, nil, 0, 0, -1, -1)
	-- local exit_size = self.exit:getSize()
	-- self.exit:setPosition( 373, 288 )
	-- self.exit:setTouchClickFun(FriendCelerbrateModel.exit_click_fun)
	-- self:addChild(self.exit)
	self:setExitBtnFun(FriendCelerbrateModel.exit_click_fun)
	-- local spr_bg_size = self.view:getSize()
	-- self.window_title = ZImage:create( self.view, UIPIC_COMMON_TIPS, spr_bg_size.width/2,  spr_bg_size.height-29, -1,-1,999 );
	-- self.window_title.view:setAnchorPoint(0.5,0.5)
end
-----------
-----------
function FriendCelerbrateWin:__init(window_name, texture, is_grid, width, height)
	createCelerbreate(self, width, height)

	self.view:setAnchorPoint(0.5, 0.5)
	self.view:setPosition(_ui_width/2 , _ui_height/2)
end 
-----------
-----------
function FriendCelerbrateWin:init_info(info)
	if self.dialog ~= nil then
		self.dialog:setText(info)
	end
end
