-----friendadd.lua
-----HJH
-----2013-2-17
-----------好友祝贺界面
super_class.FriendCelerbrate(Window)
-----------
-----------
local _window_size						= {width = 800, height = 480}
local _btn_one_info						= {width = 80, height = 38, text = Lang.friend.celebrate[1], image = {UIPIC_COMMON_BUTTON_001,UIPIC_COMMON_BUTTON_001_DOWN} } -- [1]="恭喜恭喜，请再接再厉！"
local _btn_two_info						= {width = 80, height = 38, text = Lang.friend.celebrate[2], image = {UIPIC_COMMON_BUTTON_001,UIPIC_COMMON_BUTTON_001_DOWN} } -- [2]="实在厉害，我会追上你的！"
local _btn_three_info					= {width = 80, heigth = 38, text = Lang.friend.celebrate[3], image = {UIPIC_COMMON_BUTTON_001, UIPIC_COMMON_BUTTON_001_DOWN} } -- [3]="恭喜道友修为精进"
-----------
function FriendCelerbrate:createCelerbreate(width, height)
	-----------
	require "model/FriendModel/FriendCelerbrateModel"
	-----------
	local dialog = Dialog:create( self, width - 20, height - _btn_one_info.height - 30 , width - 40, 100)
	-----------
	local btn_three = TextButton:create( self, (width - _btn_three_info.width) / 2, 10, _btn_three_info.width, _btn_three_info.height, _btn_three_info.text,_btn_three_info.image, _window_size.width, _window_size.width)
	btn_three:setTouchClickFun(FriendCelerbrateModel.btn_three_click_function)
	local btn_three_pos = btn_three:getPosition()
	-----------
	local btn_two = TextButton:create( self, btn_three_pos.x, btn_three_pos.y + 10 + _btn_three_info.height, _btn_two_info.width, _btn_two_info.height, _btn_two_info.text, _btn_two_info.image, _window_size.width, _window_size.width)
	btn_two:setTouchClickFun(FriendCelerbrateModel.btn_two_click_function)
	local btn_two_pos = btn_two:getPosition()
	-----------
	-- local btn_one = TextButton:create( self, btn_three_pos.x, btn_two_pos.y + 10 + _btn_two_info.width, _btn_one_info.width, _btn_one_info.height, _btn_one_info.text, _btn_one_info.image, _window_size.width, _window_size.width)
	-- btn_ond:setTouchClickFun(FriendCelerbrateModel.btn_one_click_function)
end
-----------
-----------
function FriendCelerbrate:__init(window_name, texture, is_grid, width, height)
	self:createCelerbreate(width, height)
end 
	
