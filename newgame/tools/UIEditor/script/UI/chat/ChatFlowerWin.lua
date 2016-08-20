----HJH
----2013-1-10
------------------鲜花界面
------------------
super_class.ChatFlowerWin(Window)
------------------
local window_size								= {width = 960, height = 640}
------------------
function ChatFlowerWin:create_chat_flower(width, height)
	------------------
	local _flower_num_info = {
		width = 32, 
		height = 32, 
		gapSize = 70, 
		color = {0xfffff000,0xff38ff33}, 
		text = { 
			"", -- Lang.chat.flowers[1], 
			"", -- Lang.chat.flowers[2], 
			"", -- Lang.chat.flowers[3], 
			"", -- Lang.chat.flowers[4]
		}, 
		text_image = {
			UIPIC_FLOWER_001, 
			UIPIC_FLOWER_002,
			UIPIC_FLOWER_003, 
			UIPIC_FLOWER_004
		},
		image = { 
			UILH_COMMON.fy_bg, 
			UILH_COMMON.fy_select
		}
	} -- [725]="1朵" -- [726]="9朵" -- [727]="99朵" -- [728]="999朵"

	local _send_type_info = {
		width = 32, 
		height = 32, 
		gapSize = 1, 
		color = {0xfffff000,0xff38ff33}, 
		text = {
			Lang.chat.flowers[5], --签名赠送
			Lang.chat.flowers[6]  --匿名赠送
		}, 
		image = {
			UILH_COMMON.fy_bg, 
			UILH_COMMON.fy_select
		} 
	} -- [729]="签名赠送" -- [730]="匿名赠送"

	local _send_info = {
		width = 122, 
		height = 49, 
		image = {
			UIPIC_FLOWER_007, 
			UIPIC_FLOWER_007
		} 
	}

	local _exit_info = {
		width = 43, 
		height = 42, 
		image = {
			UIPIC_FLOWER_008, 
			UIPIC_FLOWER_009
		} 
	}
	-------------------

	-------------------
	local one_flower = TextCheckBox:create( nil, 0, 0, _flower_num_info.width, _flower_num_info.height, _flower_num_info.image, "#c38ff33" .. _flower_num_info.text[1], _flower_num_info.gapSize)
	one_flower:setClickStateColor( _flower_num_info.color[1], _flower_num_info.color[2] )
	one_flower:setTouchClickFun(ChatFlowerModel.one_flower_fun)

	local text_image = ZImage.new(_flower_num_info.text_image[1])
	text_image:setPosition(35, 5)
	one_flower:addChild(text_image)
	-- 
	local two_flower = TextCheckBox:create( nil, 0, 0, _flower_num_info.width, _flower_num_info.height, _flower_num_info.image, "#cfff000"  .. _flower_num_info.text[2], _flower_num_info.gapSize)
	two_flower:setClickStateColor( _flower_num_info.color[1], _flower_num_info.color[2] )
	two_flower:setTouchClickFun(ChatFlowerModel.two_flower_fun)

	text_image = ZImage.new(_flower_num_info.text_image[2])
	text_image:setPosition(35, 5)
	two_flower:addChild(text_image)
	-- 
	local three_flower = TextCheckBox:create( nil, 0, 0, _flower_num_info.width, _flower_num_info.height, _flower_num_info.image, "#cfff000" ..  _flower_num_info.text[3], _flower_num_info.gapSize)
	three_flower:setClickStateColor( _flower_num_info.color[1], _flower_num_info.color[2] )
	three_flower:setTouchClickFun(ChatFlowerModel.three_flower_fun)

	text_image = ZImage.new(_flower_num_info.text_image[3])
	text_image:setPosition(35, 5)
	three_flower:addChild(text_image)
	-- 
	local four_flower = TextCheckBox:create( nil, 0, 0, _flower_num_info.width, _flower_num_info.height, _flower_num_info.image, "#cfff000" .. _flower_num_info.text[4], _flower_num_info.gapSize)
	four_flower:setClickStateColor( _flower_num_info.color[1], _flower_num_info.color[2] )
	four_flower:setTouchClickFun(ChatFlowerModel.four_flower_fun)

	text_image = ZImage.new(_flower_num_info.text_image[4])
	text_image:setPosition(35, 5)
	four_flower:addChild(text_image)
	-- 
	self.num_radio_button_group = RadioButton:create( nil, 126 , 300, 420, 36)
	self.num_radio_button_group:addItem(one_flower,10)
	self.num_radio_button_group:addItem(two_flower,10)
	self.num_radio_button_group:addItem(three_flower,10)
	self.num_radio_button_group:addItem(four_flower,10)

	---------------------
	local name_send = TextCheckBox:create( nil, 0, 0, _send_type_info.width, _send_type_info.height, _send_type_info.image, _send_type_info.text[1], _send_type_info.gapSize, 18)
	name_send:setClickStateColor( _send_type_info.color[1], _send_type_info.color[2] )
	name_send:setTouchEndedFun(ChatFlowerModel.name_send_fun)
	name_send:setClickStateColor(0xffffffff, 0xffffffff)

	local unname_send = TextCheckBox:create( nil, 0, 0, _send_type_info.width, _send_type_info.height, _send_type_info.image, _send_type_info.text[2], _send_type_info.gapSize, 18)
	unname_send:setClickStateColor( _send_type_info.color[1], _send_type_info.color[2] )
	unname_send:setTouchEndedFun(ChatFlowerModel.unname_send_fun)
	unname_send:setClickStateColor(0xffffffff, 0xffffffff)

	self.send_type_radio_button_group = RadioButton:create(nil, 210, 240, 300, 30 )
	self.send_type_radio_button_group:addItem(name_send,20)
	self.send_type_radio_button_group:addItem(unname_send,20)
	-------------------
	self.send_btn = ZButton:create( nil, _send_info.image, nil, 270, 150, _send_info.width, _send_info.height)
	self.send_btn:setTouchClickFun(ChatFlowerModel.send_btn_fun)
	-------------------
	self.name = ZLabel:create( nil, "#cffff00abc", 158/2, 8, 18, ALIGN_CENTER)
	-------------------
	if self.exit_btn then
		self.exit_btn.view:removeFromParentAndCleanup(true)
	end
	self.exit_btn = ZButton:create( nil, _exit_info.image, nil, width - _exit_info.width, height - _exit_info.height, _exit_info.width, _exit_info.height)
	self.exit_btn:setTouchClickFun(ChatFlowerModel.exit_btn_fun)
	-------------------
	self.insert_bg = ZImage:create( nil, UIPIC_FLOWER_010, 250, 360, 158, 33)
	self.insert_bg:addChild(self.name.view)
	-------------------
	self.view:addChild(self.insert_bg.view)
	self.view:addChild(self.num_radio_button_group.view)
	self.view:addChild(self.send_type_radio_button_group.view)
	self.view:addChild(self.send_btn.view)
	-- self.view:addChild(self.name.view)
	self.view:addChild(self.exit_btn.view)
end
-------------------
-------------------
function ChatFlowerWin:__init(window_name, texture_name, is_grid, width, height)
	self:create_chat_flower(width, height)
end
-------------------
-------------------
function ChatFlowerWin:get_send_name()
	if self.name ~= nil then
		return self.name:getText()
	else 
		return ""
	end
end
-------------------
-------------------
function ChatFlowerWin:set_num_index(index)
	print("self.num_radio_button_group ",self.num_radio_button_group )
	if self.num_radio_button_group ~= nil then
		self.num_radio_button_group:selectItem(index)
		if index == 0 then
			ChatFlowerModel:one_flower_fun()
		elseif index == 1 then
			ChatFlowerModel:two_flower_fun()
		elseif index == 2 then
			ChatFlowerModel:three_flower_fun()
		elseif index == 3 then
			ChatFlowerModel:four_flower_fun()
		end
	end
end
-------------------
-------------------
function ChatFlowerWin:set_send_type_index(index)
	if self.send_type_radio_button_group ~= nil then
		self.send_type_radio_button_group:selectItem(index)
		if index == 1 then
			ChatFlowerModel:name_send_fun()
		elseif index == 0 then
			ChatFlowerModel:unname_send_fun()
		end
	end
end
-------------------
-------------------
function ChatFlowerWin:reinit_info(name)
	if self.name ~= nil then
		self.name:setText("#cffff00" .. name)
		-- local selfSize = self.view:getSize()
		-- local nameSize = self.name:getSize()
		-- local namePos = self.name:getPosition()
		-- self.name:setPosition( (selfSize.width - nameSize.width) / 2, namePos.y )
	end
	print("ChatFlowerWin reinit_info")
	ChatFlowerWin:set_num_index(0)
	ChatFlowerWin:set_send_type_index(0)
end
