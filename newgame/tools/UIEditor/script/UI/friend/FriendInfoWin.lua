-----personalset.lua
-----HJH
-----2013-2-17
-----------查找好友打开界面
super_class.FriendInfoWin(NormalStyleWindow)

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

-----------
local function create_friend_info(self, width, height)
	-----------
	-- local _exit_info 			= {width = 60, height = 60, image = {UIPIC_COMMOM_008, UIPIC_COMMOM_008} }
	--xiehande 通用按钮  btn_lan ->button3
	local _button_info			= {width = 128, height = 43, text = {Lang.chat.private[2], Lang.friend.infowin[1], Lang.friend.infowin[2]}, image = {UIPIC_COMMON_BUTTON_001, UIPIC_COMMON_BUTTON_001} } -- chat.private[2]="查看资料" -- infowin[1]="添加好友" -- infowin[2]="黑名单"
	local _label_info			= {fontsize = 18, text = {Lang.friend.infowin[3],Lang.friend.infowin[4], Lang.friend.infowin[5],Lang.friend.infowin[6], Lang.friend.infowin[7], Lang.friend.infowin[8]} } -- infowin[3]="玩家名:" -- infowin[4]="阵营:" -- infowin[5]="性别:" -- infowin[6]="等级:" -- infowin[7]="职业:" -- infowin[8]="仙宗:"
	-----------
	-- require "UI/component/Button"
	-- require "UI/component/TextButton"
	-- require "UI/component/Label"
	-- require "UI/component/Image"
	-- require "model/FriendModel/FriendInfoModel"
	-----------
	--self.title_bg = ZImage:create( nil, UIResourcePath.FileLocate.common .. "explain_bg.png", 0, height - 42 - 15 , width, 32)
	self:setTouchClickFun(FriendModel.exit_btn_click_fun)
	self.title = ZImage:create( nil, UILH_FRIEND.find_title, (width)/2+3, height-43 , -1, -1)
	self.title.view:setAnchorPoint(0.5, 0)
	-----------
	-- self.exit_btn = ZButton:create( nil, _exit_info.image, nil, 0, 0, 60, 60)
	-- local exit_size = self.exit_btn:getSize()
	-- self.exit_btn:setPosition(363,278)
	-- self:setTouchClickFun(FriendInfoModel.exit_btn_click_function)
	-----------
	local label_one_begin_pos_x = 40
	local label_two_begin_pos_x = 240
	local label_begin_pos_y = 230
	local label_gap_size = 30
	-----------
	-- 名字
	self.name = ZLabel:create( nil, _label_info.text[1], label_one_begin_pos_x, label_begin_pos_y, _label_info.fontsize)

	-- 阵营
	local name_pos = self.name:getPosition()
	self.camp = ZLabel:create( nil, _label_info.text[2], label_one_begin_pos_x, name_pos.y - _label_info.fontsize - label_gap_size, _label_info.fontsize)

	-- 性别
	local camp_pos = self.camp:getPosition()
	self.sex = ZLabel:create( nil, _label_info.text[3], label_one_begin_pos_x, camp_pos.y - _label_info.fontsize - label_gap_size, _label_info.fontsize)

	-----------
	-- 等级
	self.level = ZLabel:create( nil, _label_info.text[4], label_two_begin_pos_x, label_begin_pos_y, _label_info.fontsize)

	-- 职业
	local level_pos = self.level:getPosition()
	self.job = ZLabel:create( nil, _label_info.text[5], label_two_begin_pos_x, level_pos.y - _label_info.fontsize - label_gap_size, _label_info.fontsize)

	-- 家族
	local job_pos = self.job:getPosition()
	self.xz = ZLabel:create( nil, _label_info.text[6], label_two_begin_pos_x, job_pos.y - _label_info.fontsize - label_gap_size, _label_info.fontsize)

	-- local job_pos = self.job:getPosition()
	-- self.xz = ZLabel:create( nil, _label_info.text[6], label_two_begin_pos_x, job_pos.y - _label_info.fontsize - label_gap_size, _label_info.fontsize)

	-----------
	local button_begin_pos_y = 17
	local btn_beg_x = 23
    --xiehande 通用按钮修改 btn_lan->button3 btn_lv ->button3
	-- 查看资料
	self.check_data = ZTextButton:create( nil, _button_info.text[1], UILH_COMMON.btn4_nor, nil, btn_beg_x, button_begin_pos_y, -1, -1, nil, 600, 600)
	self.check_data:setTouchClickFun(FriendInfoModel.check_data_fun)

	-- 添加好友
	self.add_friend = ZTextButton:create( nil, _button_info.text[2], UILH_COMMON.btn4_nor, nil, btn_beg_x + _button_info.width, button_begin_pos_y, -1,-1, nil, 600, 600)
	self.add_friend:setTouchClickFun(FriendInfoModel.add_friend_fun)

	-- 添加黑名单
	--xiehande 通用按钮  btn_hong.png ->button3
	self.black_list = ZTextButton:create( nil, _button_info.text[3], UILH_COMMON.btn4_nor, nil, btn_beg_x + _button_info.width * 2, button_begin_pos_y, -1, -1, nil, 600, 600)
	self.black_list:setTouchClickFun(FriendInfoModel.black_list_fun)

	-----------
	self.view:addChild(self.name.view)
	self.view:addChild(self.level.view)
	self.view:addChild(self.camp.view)
	self.view:addChild(self.job.view)
	self.view:addChild(self.sex.view)
	self.view:addChild(self.xz.view)
	self.view:addChild(self.check_data.view)
	self.view:addChild(self.add_friend.view)
	self.view:addChild(self.black_list.view)
	--self.view:addChild(self.title_bg.view)
	self.view:addChild(self.title.view)
	-- self.view:addChild(self.exit_btn.view)
end
-----------
-----------
function FriendInfoWin:__init( window_name, texture_name, is_grid, width, height )

	local bg_1 = CCBasePanel:panelWithFile(12, 71, 408, 200,UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(bg_1)

	create_friend_info(self, width, height)
	self.view:setAnchorPoint(0.5, 0.5)
	self.view:setPosition(_ui_width/2 , _ui_height/2)
end
-----------
-----------
function FriendInfoWin:init_info(name, level, camp, job, sex, xz)
	--print("name, level, camp, job, sex, xz",name, level, camp, job, sex, xz)
	self.name:setText( string.format(Lang.friend.infowin[9],name) ) -- [9]="#c38ff33玩家名:#cffffff%s"
	self.level:setText( string.format(Lang.friend.infowin[10],level) ) -- [10]="#c38ff33等级:#cffffff%d"
	self.camp:setText( string.format(Lang.friend.infowin[11],Lang.camp_info_ex[camp].name[2]) ) -- [11]="#c38ff33阵 营:#cffffff%s"
	self.job:setText( string.format(Lang.friend.infowin[12],Lang.job_info[job]) ) -- [12]="#c38ff33职 业:#cffffff%s"
	self.sex:setText( string.format(Lang.friend.infowin[13],Lang.sex_info_ex[sex+1]) ) -- [13]="#c38ff33性 别:#cffffff%s"
	self.xz:setText( string.format(Lang.friend.infowin[14],xz) ) -- [14]="#c38ff33仙 宗:#cffffff%s"
end
