-----HJH
-----2012-12-14
-----聊天频道选择
super_class.ChatChanelSelectWin(Window)
-----
function ChatChanelSelectWin:create_panel( width, height)
	----
	local button_info = {width = 80, height = 40, image = {
	UIPIC_COMMON_BUTTON_004,
	UIPIC_COMMON_BUTTON_004} ,
	 text = {Lang.chat.chanel_name[1], Lang.chat.chanel_name[2], Lang.chat.chanel_name[3], Lang.chat.chanel_name[4], Lang.chat.chanel_name[5]},
	}
	 -- [1]="世界" -- [2]="阵营" -- [3]="家族" -- [4]="队伍"-- [5]="附近" 
	local gapSize = 4 
	----
	--require "UI/component/TextButton"
	--require "model/ChatModel/ChatChanelSelectModel"
	----世界按钮
	self.world = ZTextButton:create(nil, button_info.text[1], button_info.image, nil, (width - button_info.width)/2, height - button_info.height, button_info.width, button_info.height, nil, 600, 600)
	local world_pos = self.world:getPosition()
	self.world:setTouchClickFun(ChatChanelSelectModel.chanel_select_world_fun)
	self:addChild(self.world)
	--阵营按钮
	self.camp = ZTextButton:create(nil, button_info.text[2], button_info.image, nil, (width - button_info.width) /2, world_pos.y - button_info.height - gapSize, button_info.width, button_info.height, nil, 600, 600)
	local camp_pos = self.camp:getPosition()
	self.camp:setTouchClickFun(ChatChanelSelectModel.chanel_select_camp_fun)
	self:addChild(self.camp)
	----家族按钮
	self.xz = ZTextButton:create(nil, button_info.text[3], button_info.image, nil, (width - button_info.width) / 2, camp_pos.y - button_info.height - gapSize, button_info.width, button_info.height, nil, 600, 600)
	local xz_pos = self.xz:getPosition()
	self.xz:setTouchClickFun(ChatChanelSelectModel.chanel_select_xz_fun)
	self:addChild(self.xz)
	----队伍按钮
	self.group = ZTextButton:create(nil, button_info.text[4], button_info.image, nil, (width - button_info.width)/2 , xz_pos.y - button_info.height - gapSize, button_info.width, button_info.height, nil, 600, 600)
	local group_pos = self.group:getPosition()
	self.group:setTouchClickFun(ChatChanelSelectModel.chanel_select_group_fun)
	self:addChild(self.group)
	----附近按钮
	self.near=ZTextButton:create(nil, button_info.text[5], button_info.image, nil, (width - button_info.width)/2 , group_pos.y - button_info.height - gapSize , button_info.width, button_info.height, nil, 600, 600)
	local near_pos = self.near:getPosition()
	self.near:setTouchClickFun(ChatChanelSelectModel.chanel_select_near_fun)
	self:addChild(self.near)
end
---------------------------------
---------------------------------
function ChatChanelSelectWin:__init( window_name, texture_name, is_grid, width, height)
	----
	self:create_panel( width, height)
end
