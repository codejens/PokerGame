
----HJH
----2013-1-10
------------------聊天信息栏
--require "model/ChatMode/ChatInfoMode"
super_class.ChatInfo(Window)
------------------

local _COMMON_INDEX = 0
local _WORLD_INDEX = 1
local _FAMILY_INDEX = 2
local _TEAM_INDEX = 3
local _NEAR_INDEX = 4

local _radioSize = { 154 ,45, 31 } 
local _radioGroupHeight = _radioSize[2] * 6 + _radioSize[3] * 5
local _chanel_info 		= {width = 101, height = 45, image = { "", "" }, 
						select_texture = UILH_BENEFIT.month_bg,
						-- image_text = { Lang.chat.chanel_name[6], Lang.chat.chanel_name[1], Lang.chat.chanel_name[2], Lang.chat.chanel_name[3], Lang.chat.chanel_name[4], Lang.chat.chanel_name[5]} 
						image_texture = {
							[1] = {UILH_CHATWIN.zonghe, UILH_CHATWIN.zonghe_d},
							[2] = {UILH_CHATWIN.shijie, UILH_CHATWIN.shijie_d},
							[3] = {UILH_CHATWIN.zhenying, UILH_CHATWIN.zhenying_d},
							[4] = {UILH_CHATWIN.xianzong, UILH_CHATWIN.xianzong_d},
							[5] = {UILH_CHATWIN.duiwu, UILH_CHATWIN.duiwu_d},
							[6] = {UILH_CHATWIN.fujin, UILH_CHATWIN.fujin_d},
						}}
local function ChatModel_info_common_fun()
	ChatModel.info_common_fun()
	-- ChatChanelSelectModel.chanel_select_world_fun()
end

local function ChatModel_info_world_fun()
	ChatModel.info_world_fun()
	ChatChanelSelectModel.chanel_select_world_fun()
end

local function ChatModel_info_camp_fun()
	ChatModel.info_camp_fun()
	ChatChanelSelectModel.chanel_select_camp_fun()
end

local function ChatModel_info_zx_fun()
	ChatModel.info_zx_fun()
	ChatChanelSelectModel.chanel_select_xz_fun()
end

local function ChatModel_info_group_fun()
	ChatModel.info_group_fun()
	ChatChanelSelectModel.chanel_select_group_fun()
end

local function ChatModel_info_near_fun()
	ChatModel.info_near_fun()
	ChatChanelSelectModel.chanel_select_near_fun()
end


function ChatInfo:create_panel(width, height)
	------------------
	self.cur_select = 1 			--记录当前选中的按钮,默认为1
	local _window_size				= { width  = GameScreenConfig.ui_screen_width, 
									    height = GameScreenConfig.ui_screen_height }

	local _chanel_bg_info			= { -4, 0, 125, 492, texture =  UILH_COMMON.bottom_bg }
									   --text = {"综合", "世界", "阵营", "仙宗", "队伍", "附近"} } 
	-- local _chat_info 				= {width = 50, height = 56, image = {UIResourcePath.FileLocate.common .. "chat_btn_normal.png", UIResourcePath.FileLocate.common .. "chat_btn_select.png"},
	-- 									 image_text = UIResourcePath.FileLocate.chat .. "chat_bg.png" }
	--对话框
	local _dialog_info				= { 127, 10, 725, 462, 
										texture =  UILH_COMMON.bg_10 }
	--对话款scroll
	local _scroll_info				= { 0, 0, 0, 492, 
                                        texture = 
                                        { 
                                        	UILH_COMMON.up_progress,
                                        	UILH_COMMON.down_progress,
                                      	}
                                      }
	------------------
	-- require "UI/component/ImageButton"
	-- require "UI/component/Scroll"
	-- require "UI/component/RadioButtonGroup"
	-- require "model/ChatModel/ChatModel"
	-- require "UI/component/Image"
	local panel_bg = CCBasePanel:panelWithFile(  _chanel_bg_info[1], _chanel_bg_info[2], _chanel_bg_info[3], _chanel_bg_info[4], nil)
	self.view:addChild(panel_bg)
	-- local chanel_bg = ZImage:create(nil, _chanel_bg_info.texture, _chanel_bg_info[1], _chanel_bg_info[2], _chanel_bg_info[3], _chanel_bg_info[4], -1)
	-- self.view:addChild(chanel_bg.view)
	------------------综合按钮
	self.sel_img = ZImage:create(nil, _chanel_info.select_texture, -2, 36+76*5,-1, -1)
	self.sel_img.view:setFlipX(true)
	local common = ZImageButton:create(nil, _chanel_info.image, _chanel_info.image_texture[1][2], ChatModel_info_common_fun, 0, 0, _chanel_info.width, _chanel_info.height)
	------------------世界按钮
	local world = ZImageButton:create(nil, _chanel_info.image, _chanel_info.image_texture[2][1], ChatModel_info_world_fun, 0, 0, _chanel_info.width, _chanel_info.height)
	------------------阵营按钮
	local camp = ZImageButton:create(nil, _chanel_info.image, _chanel_info.image_texture[3][1], ChatModel_info_camp_fun, 0, 0, _chanel_info.width, _chanel_info.height)
	------------------仙宗按钮
	local zx = ZImageButton:create(nil, _chanel_info.image, _chanel_info.image_texture[4][1], ChatModel_info_zx_fun, 0, 0, _chanel_info.width, _chanel_info.height)
	------------------队伍按钮
	local group = ZImageButton:create(nil, _chanel_info.image, _chanel_info.image_texture[5][1], ChatModel_info_group_fun, 0, 0, _chanel_info.width, _chanel_info.height)
	------------------附近按钮
	local near = ZImageButton:create(nil, _chanel_info.image, _chanel_info.image_texture[6][1], ChatModel_info_near_fun, 0, 0, _chanel_info.width, _chanel_info.height)
	------------------
	local itemgapSize = _radioSize[3]
	self.chanel_radio_button = ZRadioButtonGroup:create( nil, 17, 8, 124, 450, 1 )
	self.chanel_radio_button:addItem(common,itemgapSize)
	self.chanel_radio_button:addItem(world,itemgapSize)
	self.chanel_radio_button:addItem(camp,itemgapSize)
	self.chanel_radio_button:addItem(zx,itemgapSize)
	self.chanel_radio_button:addItem(group,itemgapSize)
	self.chanel_radio_button:addItem(near,itemgapSize)
	local chanel_radio_button_pos = self.chanel_radio_button:getPosition()
	local chanel_radio_button_size = self.chanel_radio_button:getSize()
	------------------发言按钮
	-- self.chat = ImageButton:create( nil, width - _chat_info.width - 20, 20, _chat_info.width, _chat_info.height, _chat_info.image, _chat_info.image_text)
	-- self.chat:set_image_gapsize(0, -4)
	-- self.chat:setTouchClickFun(ChatModel.info_chat_fun)
	------------------
	local scroll_pos_y = 50
	local scroll_pos_x = 130
	local scroll_gap_size = 10
	--float posx, float posy, float width, float height, unsigned long maxnum, const char *file, SCROLL_TYPE type, ADDLISTDIR adddir 
	self.common_scroll = CCDialog:dialogWithFile(_dialog_info[1],_dialog_info[2], 
												 _dialog_info[3],_dialog_info[4], 
												 50, _dialog_info.texture, 
												 TYPE_HORIZONTAL, 
												 ADD_LIST_DIR_DOWN, 
												 _window_size.width, 
												 _window_size.height)

	self.common_scroll:setGapSize(scroll_gap_size)
	self.common_scroll:setLineOffsetY(4)
	self.common_scroll:setScrollLump( _scroll_info.texture[1], 
									  _scroll_info.texture[2], 10, 40, 
									  _scroll_info[4] )
	self.common_scroll:setFontSize( 20 )
	self.common_scroll:setIsVisible(true)
	------------------世界信息栏
	self.world_scroll = CCDialog:dialogWithFile(_dialog_info[1],_dialog_info[2], 
												 _dialog_info[3],_dialog_info[4], 
												 50, _dialog_info.texture, 
												 TYPE_HORIZONTAL, 
												 ADD_LIST_DIR_DOWN, 
												 _window_size.width, 
												 _window_size.height)
	self.world_scroll:setGapSize(scroll_gap_size)
	self.world_scroll:setLineOffsetY(4)
	self.world_scroll:setScrollLump( _scroll_info.texture[1], 
									  _scroll_info.texture[2], 10, 40, 
									  _scroll_info[4] )
	-- self.world_scroll:addChild(CCZXImage:imageWithFile(_dialog_info[3]-15, _dialog_info[4]-15, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500))
	-- self.world_scroll:addChild(CCZXImage:imageWithFile(_dialog_info[3]-15, 3, 11, -1 , UILH_COMMON.scrollbar_down, 500, 500))
	self.world_scroll:setFontSize( 20)
	self.world_scroll:setIsVisible(false)
	------------------阵营信息栏
	self.camp_scroll = CCDialog:dialogWithFile(_dialog_info[1],_dialog_info[2], 
												 _dialog_info[3],_dialog_info[4], 
												 50, _dialog_info.texture, 
												 TYPE_HORIZONTAL, 
												 ADD_LIST_DIR_DOWN, 
												 _window_size.width, 
												 _window_size.height)
	self.camp_scroll:setGapSize(scroll_gap_size)
	self.camp_scroll:setLineOffsetY(4)
	self.camp_scroll:setScrollLump( _scroll_info.texture[1], 
									_scroll_info.texture[2], 10, 40, 
									_scroll_info[4] )
	-- self.camp_scroll:addChild(CCZXImage:imageWithFile(_dialog_info[3]-15, _dialog_info[4]-15, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500))
	-- self.camp_scroll:addChild(CCZXImage:imageWithFile(_dialog_info[3]-15, 3, 11, -1 , UILH_COMMON.scrollbar_down, 500, 500))
	self.camp_scroll:setFontSize(20)
	self.camp_scroll:setIsVisible(false)
	------------------仙宗信息栏
	self.zx_scroll = CCDialog:dialogWithFile(_dialog_info[1],_dialog_info[2], 
												 _dialog_info[3],_dialog_info[4], 
												 50, _dialog_info.texture, 
												 TYPE_HORIZONTAL, 
												 ADD_LIST_DIR_DOWN, 
												 _window_size.width, 
												 _window_size.height)
	self.zx_scroll:setGapSize(scroll_gap_size)
	self.zx_scroll:setLineOffsetY(4)
	self.zx_scroll:setScrollLump( _scroll_info.texture[1], 
									_scroll_info.texture[2], 10, 40, 
									_scroll_info[4] )
	self.zx_scroll:setFontSize( 20)
	--Scroll:create( nil, scroll_pos_x, scroll_pos_y, _scroll_info.width, _scroll_info.height, 3)
	self.zx_scroll:setIsVisible(false)
	--self.zx_scroll:setScrollCreatFunction(ChatModel.info_zx_scroll_create_fun)
	--self.zx_scroll:setAnchorPoint(0, 1)
	------------------队伍息栏
	self.group_scroll = CCDialog:dialogWithFile(_dialog_info[1],_dialog_info[2], 
												 _dialog_info[3],_dialog_info[4], 
												 50, _dialog_info.texture, 
												 TYPE_HORIZONTAL, 
												 ADD_LIST_DIR_DOWN, 
												 _window_size.width, 
												 _window_size.height)
	self.group_scroll:setGapSize(scroll_gap_size)
	self.group_scroll:setLineOffsetY(4)
	self.group_scroll:setScrollLump( _scroll_info.texture[1], 
									_scroll_info.texture[2], 10, 40, 
									_scroll_info[4] )
	self.group_scroll:setFontSize( 20)
	--Scroll:create( nil, scroll_pos_x, scroll_pos_y, _scroll_info.width, _scroll_info.height, 3)
	self.group_scroll:setIsVisible(false)
	--self.group_scroll:setScrollCreatFunction(ChatModel.info_group_scroll_create_fun)
	--self.group_scroll:setAnchorPoint(0, 1)
	------------------附近信息栏
	self.near_scroll = CCDialog:dialogWithFile(_dialog_info[1],_dialog_info[2], 
												 _dialog_info[3],_dialog_info[4], 
												 50, _dialog_info.texture, 
												 TYPE_HORIZONTAL, 
												 ADD_LIST_DIR_DOWN, 
												 _window_size.width, 
												 _window_size.height)
	self.near_scroll:setGapSize(scroll_gap_size)
	self.near_scroll:setLineOffsetY(4)
	self.near_scroll:setScrollLump( _scroll_info.texture[1], 
									_scroll_info.texture[2], 10, 40, 
									_scroll_info[4] )
	self.near_scroll:setFontSize( 20)
	--Scroll:create( nil, scroll_pos_x, scroll_pos_y, _scroll_info.width, _scroll_info.height, 3)
	self.near_scroll:setIsVisible(false)
	local arrow_up = CCZXImage:imageWithFile(_dialog_info[1] + _dialog_info[3]-15, _dialog_info[4]-5, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(_dialog_info[1] + _dialog_info[3]-15, 13, 10, -1 , UILH_COMMON.scrollbar_down, 500, 500)

	-- self.view:addChild(radioBg.view)
	self.view:addChild(self.common_scroll)
	self.view:addChild(self.world_scroll)
	self.view:addChild(self.camp_scroll)
	self.view:addChild(self.zx_scroll)
	self.view:addChild(self.group_scroll)
	self.view:addChild(self.near_scroll)
	self.view:addChild(self.sel_img.view)
	self.view:addChild(self.chanel_radio_button.view)
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	local chanel_msgs = ChatModel:get_all_msg()
	local hyperScriptHeader = Hyperlink:get_script_head()
	for idx, tab in ipairs(chanel_msgs) do
		for key, val in ipairs(tab or {}) do
			if idx == 1 then
				self.common_scroll:setText(val, hyperScriptHeader)
			elseif idx == 2 then
				self.world_scroll:setText(val, hyperScriptHeader)
			elseif idx == 3 then
				self.camp_scroll:setText(val, hyperScriptHeader)
			elseif idx == 4 then
				self.zx_scroll:setText(val, hyperScriptHeader)
			elseif idx == 5 then
				self.group_scroll:setText(val, hyperScriptHeader)
			elseif idx == 6 then
				self.near_scroll:setText(val, hyperScriptHeader)
			end
		end
	end
end
------------------
------------------
function ChatInfo:__init(window_name, texture_name, is_grid, width, height)
	-- 初始化构建控件
    self:create_panel(width, height)
    --self:registerScriptFun()
end
------------------
function ChatInfo:clear_chanel_info()
	require "model/Hyperlink"
	-- local link = --UIManager:find_window("hyper_link")
	-- print("run chatinfo clear chanel info 1",link)
	-- if not link then
	-- 	return
	-- end
	local hyperScriptHeader = Hyperlink:get_script_head()
	self.common_scroll:setText("", hyperScriptHeader)
	self.world_scroll:setText("", hyperScriptHeader)
	self.camp_scroll:setText("", hyperScriptHeader)
	self.zx_scroll:setText("", hyperScriptHeader)
	self.group_scroll:setText("", hyperScriptHeader)
	self.near_scroll:setText("", hyperScriptHeader)
end
------------------
------------------设置指定信息栏信息
function ChatInfo:set_index_info(index, info)
	-- print("set_index_info:",index, info)
	self:set_index_scroll_visible(index)
	require "model/Hyperlink"
	ChatModel:save_msg(index, info)
	local hyperScriptHeader = Hyperlink:get_script_head()
	if index == 1 then
		self.common_scroll:setText(info, hyperScriptHeader)
	elseif index == 2 then
		self.world_scroll:setText(info, hyperScriptHeader)
	elseif index == 3 then
		self.camp_scroll:setText(info, hyperScriptHeader)
	elseif index == 4 then
		self.zx_scroll:setText(info, hyperScriptHeader)
	elseif index == 5 then
		self.group_scroll:setText(info, hyperScriptHeader)
	elseif index == 6 then
		self.near_scroll:setText(info, hyperScriptHeader)
	end
end
------------------
------------------设置指定信息栏显隐
function ChatInfo:set_index_scroll_visible(index)
	local scroll_index = {self.common_scroll, self.world_scroll, self.camp_scroll, self.zx_scroll, self.group_scroll, self.near_scroll}
	for i = 1, #scroll_index do
		if index == i then
			scroll_index[i]:setIsVisible(true)
		else
			scroll_index[i]:setIsVisible(false)
		end
	end
	if index ~= self.cur_select then
		local chanel_item = self.chanel_radio_button:getIndexItem(self.cur_select-1)
		local cur_item = self.chanel_radio_button:getIndexItem(index-1)
		chanel_item:set_image_texture(_chanel_info.image_texture[self.cur_select][1])
		cur_item:set_image_texture(_chanel_info.image_texture[index][2])
		self.sel_img.view:setPosition(-2, 36 + 76 * (6 - index))
		self.cur_select = index
	end
end
------------------
------------------设置发言按钮显隐
function ChatInfo:set_chat_to_chat_visible(visible)
	if self.chat ~= nil then
		self.chat.view:setIsVisible(visible)
	end
end
------------------
------------------设置当前面板定时器开启与关闭
function ChatInfo:set_timer(rate)
	if self.view ~= nil then
		self.view:setTimer(rate)
	end
end
------------------
------------------定时器函数
function ChatInfo:adjustPos(x,y)
	local exitpos = self.exit:getPosition()
	self.exit:setPosition(exitpos.x , exitpos.y + y)
	local scroll_index = {self.common_scroll, self.world_scroll, self.camp_scroll, self.zx_scroll, self.group_scroll, self.near_scroll}
	for i = 1 , #scroll_index  do	
		local messagepos = scroll_index[i]:getPositionS()
		local messagesize = scroll_index[i]:getSize()
		--print( string.format("run ChatInfo:adjustPos i=%d,messagepos.y=%f,messagesize.height=%f",i,messagepos.y,messagesize.height) )
		messagepos.y = messagepos.y + y
		messagesize.height = messagesize.height + y
		scroll_index[i]:setPosition(messagepos.x, messagepos.y)
		scroll_index[i]:setSize(messagesize.width, messagesize.height)
	end
	-- local bg_pos = self.bg:getPosition()
	-- local bg_size = self.bg:getSize()
	-- self.bg:setPosition(bg_pos.x, bg_pos.y + y)
	-- self.bg:setSize(bg_size.width, bg_size.height + y)
end

function ChatInfo:active( show )
	-- if show then
	-- 	local chanel = ChatModel:get_cur_chanel_select()
	-- 	if chanel == ChatConfig.Chat_chanel.CHANNEL_WORLD then
	-- 		self.chanel_radio_button:selectItem(_WORLD_INDEX)
	-- 	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_GUILD then
	-- 		self.chanel_radio_button:selectItem(_FAMILY_INDEX)
	-- 	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_TEAM then
	-- 		self.chanel_radio_button:selectItem(_TEAM_INDEX)
	-- 	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_ALL then
	-- 		self.chanel_radio_button:selectItem(_COMMON_INDEX)
	-- 	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_MAP then
	-- 		self.chanel_radio_button:selectItem(_NEAR_INDEX)
	-- 	end
	-- end
end
