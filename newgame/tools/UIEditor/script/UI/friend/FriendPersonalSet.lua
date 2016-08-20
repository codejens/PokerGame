-----personalset.lua
-----HJH
-----2013-2-17
-----------好友个人设置界面
super_class.FriendPersonalSet(NormalStyleWindow)
-----------
-----------
local _window_size 								= {width = 800, height = 480}
-----------
-----------
local _title_info								= {x = 10, y = 378, width = 108, height = 21,
												 image = UILH_FRIEND.personal_set}
--local _title_info								= {x = 10, y = 380, width = 107, height = 19, text = "个人设置", image = "ui/common/title_bg_01_s.png"}
local _auto_reply_info							= {x = 30, y = 480, width = 45, height = 45, gapSize = 4, color ={0xffd0cda2,0xfffff000},
												 image = {UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2}, text = Lang.friend.perset[1] } -- [1]="开启自动回复"
local _select_btn_info							= {width = 30, height = 30, gapSize = 5, font_size = 16,
												 image = {UILH_COMMON.fy_bg, UILH_COMMON.fy_select2}, info_text = {Lang.friend.perset[2],Lang.friend.perset[3],Lang.friend.perset[4],Lang.friend.perset[5],Lang.friend.perset[7]}} -- [2]="我去吃饭了，一会再联系" -- [3]="练级中，请勿打扰" -- [4]="挂机中" -- [5]="你好，我现在有事不在，一会再和你联系"
local _reject_info								= {x = 30, y = 52, width = 45, height = 45, gapSize = 2, color ={0xffd0cda2,0xfffff000},
												 image = {UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2}, text = Lang.friend.perset[6]} -- [6]="拒绝陌生人消息"
local _text_button								= {x = 284, y = 50, width = -1, height = -1, text = Lang.common.confirm[0], -- confirm[0]="确定"
--UILH_FRIEND012 ->UIPIC_COMMOM_002
												 image = UILH_COMMON.lh_button2,UILH_COMMON.lh_button2}
local _exit_info								= {width = 62, height = 56,
 												 image = {UILH_COMMON.close_btn_z,UILH_COMMON.close_btn_z}}
local _radio_info								= {x = 35, y = 155, width = 338, height = 299, addType = 1, gapSize = 38}
-----------
function FriendPersonalSet:CreateSet(width, height)
	-----------
	-- require "utils/Controls"
	-- require "model/FriendModel/FriendPersonalSetModel"
	-- require "UI/component/TextCheckBox"
	-- require "UI/component/Image"
	-- require "UI/component/Button"
	-- require "UI/component/RadioButtonGroup"
	-- require "UI/component/TextButton"
	-----------底色
	local shezhi_bg = ZImage:create(self, UILH_COMMON.normal_bg_v2, 10, 16, 415, 550, 0, 500, 500)	
	-- self.title = ZImage:create( nil, _title_info.image, _title_info.x, _title_info.y, _title_info.width, _title_info.height)
	--TextImage:create(self, _title_info.x, _title_info.y, _title_info.width, _title_info.height, _title_info.text, _title_info.image)
	-----------
	self.open_auto_reply = TextCheckBox:create(self, _auto_reply_info.x, _auto_reply_info.y, _auto_reply_info.width, _auto_reply_info.height, _auto_reply_info.image, "#cd0cda2".._auto_reply_info.text, _auto_reply_info.gapSize)
	self.open_auto_reply:setClickStateColor(_auto_reply_info.color[1], _auto_reply_info.color[2])
	self.open_auto_reply:setTouchEndedFun(FriendPersonalSetModel.open_auto_click_fun)
	-----------
	self.reject_other_msg = TextCheckBox:create(self, _reject_info.x, _reject_info.y, _reject_info.width, _reject_info.height, _reject_info.image, "#cd0cda2".._reject_info.text, _reject_info.gapSize)
	self.reject_other_msg:setClickStateColor(_reject_info.color[1], _reject_info.color[2])
	self.reject_other_msg:setTouchEndedFun(FriendPersonalSetModel.reject_other_click_fun)
	-----------
	self.ok_button = ZTextButton:create(nil, _text_button.text, _text_button.image, nil, _text_button.x, _text_button.y, _text_button.width, _text_button.height, nil, _window_size.width, _window_size.width)
	self.ok_button:setTouchClickFun(FriendPersonalSetModel.ok_click_fun)
	-----------
	-- self.exit_btn = ZButton:create(nil, _exit_info.image, nil, 0, 0, -1, -1)
	-- local exit_size = self.exit_btn:getSize()
	-- self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height )
	-- self.exit_btn:setTouchClickFun(FriendPersonalSetModel.exit_click_fun)
	-----------
	local checkbox1 = TextCheckBox:create(self, 30, 0, _select_btn_info.width, _select_btn_info.height, _select_btn_info.image, _select_btn_info.info_text[1], _select_btn_info.gapSize, _select_btn_info.font_size)
	local checkbox2 = TextCheckBox:create(self, 30, 0, _select_btn_info.width, _select_btn_info.height, _select_btn_info.image, _select_btn_info.info_text[2], _select_btn_info.gapSize, _select_btn_info.font_size)
	local checkbox3 = TextCheckBox:create(self, 30, 0, _select_btn_info.width, _select_btn_info.height, _select_btn_info.image, _select_btn_info.info_text[3], _select_btn_info.gapSize, _select_btn_info.font_size)
	local checkbox4 = TextCheckBox:create(self, 30, 0, _select_btn_info.width, _select_btn_info.height, _select_btn_info.image, _select_btn_info.info_text[4], _select_btn_info.gapSize, _select_btn_info.font_size)
	local checkbox5 = TextCheckBox:create(self, 30, 0, _select_btn_info.width, _select_btn_info.height, _select_btn_info.image, _select_btn_info.info_text[5], _select_btn_info.gapSize, _select_btn_info.font_size)
	self.radiobutton = RadioButton:create(self, _radio_info.x, _radio_info.y, _radio_info.width, _radio_info.height, _radio_info.addType)
	self.radiobutton:addItem(checkbox1, _radio_info.gapSize)
	self.radiobutton:addItem(checkbox2, _radio_info.gapSize)
	self.radiobutton:addItem(checkbox3, _radio_info.gapSize)
	self.radiobutton:addItem(checkbox4, _radio_info.gapSize)
	self.radiobutton:addItem(checkbox5, _radio_info.gapSize)
	-----------
	--self.view:addChild(self.title.view)
	self.view:addChild(self.open_auto_reply.view)
	self.view:addChild(self.reject_other_msg.view)
	self.view:addChild(self.ok_button.view)
	--self.view:addChild(self.exit_btn.view)
	self.view:addChild(self.radiobutton.view)
end
-----------
-----------
function FriendPersonalSet:__init(window_name, texture_name, is_grid, width, height)
	self:CreateSet( width, height)
end
-----------
-----------
function FriendPersonalSet:active(show)
	if show == false then
		FriendPersonalSetModel:exit_click_fun()
	else
		local reject_other = FriendPersonalSetModel:get_reject_other()
		if reject_other then
			self.reject_other_msg:setCurState(CLICK_STATE_DOWN)
		else
			self.reject_other_msg:setCurState(CLICK_STATE_UP)
		end

		local auto_reply = FriendPersonalSetModel:get_auto_chat()
		if auto_reply then
			self.open_auto_reply:setCurState(CLICK_STATE_DOWN)

			local auto_index = FriendPersonalSetModel:get_auto_chat_index(  )
			self.radiobutton:selectItem(auto_index)
		else
			self.open_auto_reply:setCurState(CLICK_STATE_UP)
		end
	end
end