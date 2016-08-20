-----chatprivatescroll.lua
-----HJH
-----2013-8-13
-----------
super_class.ChatPrivateScroll(NormalStyleWindow)
---------------------------------
local function scroll_create_fun(self, index)
	local temp_info = ChatPrivateChatModel:get_private_chat_info()
	local cur_info = temp_info[index + 1]

	local base_panel = ZBasePanel:create( nil, nil, 0, 0, 295, 180 / 3 )
	local base_panel_size = base_panel:getSize()

	local label = ZLabel:create( nil, string.format( Lang.chat.private[4], cur_info.name), 15, 23 ) -- Lang.chat.private[4]="与#cfff000%s#cffffff聊天"
	local num = ZLabel:create( nil, string.format(Lang.chat.private[5], cur_info.new_message_num), 15, 0 ) -- Lang.chat.private[5]="新信息#c38ff33%d#cffffff条"

	local button = ZTextButton:create( nil, Lang.chat.private[6], UIPIC_COMMON_BUTTON_001, nil, 0, 0, -1,-1 ) -- Lang.chat.private[6]="查看"
	local button_size = button:getSize()
	button:setPosition( base_panel_size.width - button_size.width +25, ( base_panel_size.height - button_size.height ) / 2-14 )

	local line = ZImage:create( nil, UILH_COMMON.split_line, 20, -14, 295, 2)

	base_panel.view:addChild(label.view)
	base_panel.view:addChild(num.view)
	base_panel.view:addChild(button.view)
	base_panel.view:addChild(line.view)

	local function check_fun()
		local id = cur_info.id
		ChatPrivateChatModel:set_cur_chat_info(id)
		ChatPrivateChatModel:reinit_title_info()
		ChatPrivateChatModel:open_private_chat()
		UIManager:hide_window("chat_private_scroll")
	end
	button:setTouchClickFun(check_fun)
	return base_panel
end
---------------------------------
local function create_page( self, width, height )
	---------------------------------
	-- local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "min_btn_n.png", UIResourcePath.FileLocate.common .. "min_btn_s.png" } , nil, 0, 0, -1, -1)
	-- local exit_btn_size = exit_btn:getSize()
	-- exit_btn:setPosition( width - exit_btn_size.width, height - exit_btn_size.height )
	-- self:addChild( exit_btn.view )
	-- local function exit_fun()
	-- 	UIManager:hide_window("chat_private_scroll")
	-- 	local temp_info = ChatPrivateChatModel:get_private_chat_info() 
	-- 	if #temp_info > 0 then
	-- 		local userpanel = UIManager:find_window("user_panel")
	-- 		userpanel:set_whisper_btn_visible( true )
	-- 	end
	-- end
	-- exit_btn:setTouchClickFun(exit_fun)
	---------------------------------
	-- local accept_all = TextButton:create( nil, 25, 20, -1, -1, "全部祝贺", UIResourcePath.FileLocate.common .. "button4.png" )
	-- self:addChild( accept_all.view )

	-- title_text = UIResourcePath.FileLocate.common .. "title_tips.png" 

	--暂时去掉,等有可用标题再打开
	-- local win_title = ZImage:create( self.view, UIPIC_COMMON_TIPS , 190, 294, -1, -1)
	-- self.view:addChild(win_title.view, 1010)
	local bg = ZImage:create( nil, UILH_COMMON.bottom_bg, 18, 71, 380, 190, nil, 500, 500)
	-- local bg2 = ZImage:create( nil, UILH_COMMON.bottom_bg, 28, 82, 360, 180, nil, 500, 500)
	self.view:addChild(bg.view)
	-- self.view:addChild(bg2.view)
-- xiehande UI_ChatPrivate_013 ->UIPIC_COMMOM_002
	local cancel_all = ZTextButton:create( nil, Lang.chat.private[7], UILH_COMMON.btn4_nor, ChatPrivateChatModel.cancell_all_fun, 0, 30, -1, -1) -- Lang.chat.private[7]="全部忽略"
	self:addChild( cancel_all.view )
	local cancel_all_size = cancel_all.view:getSize()
	cancel_all.view:setPosition( ( width - cancel_all_size.width ) / 2, 17 )
	--cancel_all:setTouchClickFun(  )
	---------------------------------
	self.scroll = ZScroll:create( nil, nil, 40, 90 , width - 80, height - 130-40, 45, TYPE_HORIZONTAL )
	self.scroll:setScrollCreatFunction( scroll_create_fun )
	self:addChild( self.scroll.view )
end
---------------------------------
function ChatPrivateScroll:__init( window_name, texture_name, is_grid, width, height )
	--第一层背景 
	-- ZImage:create( self.view, UIPIC_GRID_BOTTOM_BG, 0, 0, width, height, -1 )
	--第二层背景
	-- local bg = ZImage:create( self.view, UILH_COMMON.style_bg, 0, 0, width, height, -1 )
	-- local out_grid = ZImage:create( self.view, UIPIC_COMMOM_006, 0, 0, width, height, nil, 600, 600 )
	create_page(self, width, height)
end
---------------------------------
function ChatPrivateScroll:active(show)
	if show == true then
		local temp_info = ChatPrivateChatModel:get_private_chat_info()
		self.scroll:setMaxNum( #temp_info )
		self.scroll:clear()
		self.scroll:refresh()
	else
		local temp_info = ChatPrivateChatModel:get_private_chat_info() 
		if #temp_info > 0 then
			local userpanel = UIManager:find_window("user_panel")
			userpanel:set_whisper_btn_visible( true )
		end
	end
	if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end
---------------------------------
function ChatPrivateScroll:update_scroll()
	local temp_info = ChatPrivateChatModel:get_private_chat_info()
	self.scroll:setMaxNum( #temp_info )
	self.scroll:clear()
	self.scroll:refresh()
end
