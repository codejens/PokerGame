----HJH
----2013-1-12
------------------仙宗聊天
------------------
------------------
------------------
super_class.ChatXZWin(Window)
------------------
local _window_size 								= {width = 800, height = 480}
------------------
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local function create_left_panel(self, x, y, width, height)
	------------------left panel

	----------底板
	self.left_panel = CCBasePanel:panelWithFile( x, y, width, height, "", 500, 500)
	self.view:addChild(self.left_panel)

	----------旗子
	self.self_pos = ZButton:create( nil, {UILH_CHATWIN.pos, UILH_CHATWIN.pos}, nil, 301,0 , -1, -1)
	self.left_panel:addChild(self.self_pos.view)

	----------表情按钮
	self.face = ZButton:create( nil, {UILH_CHATWIN.face,UILH_CHATWIN.face}, nil, 8, 0, -1, -1)
	self.left_panel:addChild(self.face.view)

	----------删除按钮
	self.delete = ZButton:create( nil, {UILH_CHATWIN.delete,UILH_CHATWIN.delete}, nil, 244 , 0, -1, -1)
	self.left_panel:addChild(self.delete.view)

	local function delete_btn_function()
		self.editbox:setText("")
	end
	self.delete:setTouchClickFun(delete_btn_function)

	-- ----------发送按钮
	-- self.send = ZTextButton:create( nil, Lang.chat.send, {UIPIC_COMMON_BUTTON_001_DOWN,UIPIC_COMMON_BUTTON_001_DOWN}, nil, 184 , 0, 126, 43)
	-- self.left_panel:addChild(self.send.view)
   
   --输入框位置
   local editbox_bg_size = {x= 0, y = 60, e_width =width, e_height = 155}
   local editbox_size ={x= editbox_bg_size.x+10,y = editbox_bg_size.y-50,width = editbox_bg_size.e_width-20,height = editbox_bg_size.e_height-20}


	----------输入框   左下
	self.editbox = CCZXEditBoxArea:editWithFile( editbox_size.x, editbox_size.y, editbox_size.width, editbox_size.height, "", 40, 16, 960, 640 )

	local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            
        elseif eventType == KEYBOARD_FINISH_INSERT then
            self:hide_keyboard()
            return true
        elseif eventType == TOUCH_BEGAN then
            -- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
            local face_win = UIManager:find_visible_window("chat_face_win")
            if face_win then
            	UIManager:hide_window("chat_face_win")
            end
        elseif eventType == KEYBOARD_WILL_SHOW then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height ); 
            return true
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height );
            return true
        end
        return true
    end
    self.editbox:registerScriptHandler(edit_box_function)

    --聊天框底框  左下底板
	local editbox_bg = CCBasePanel:panelWithFile(editbox_bg_size.x,editbox_bg_size.y,editbox_bg_size.e_width,editbox_bg_size.e_height, UILH_COMMON.bottom_bg, 500, 500)
	editbox_bg:addChild(self.editbox)
	self.left_panel:addChild(editbox_bg)


   --信息栏位置
 local inset_bg_size = {x= 0, y = 217, i_width =width, i_height = 260}
   local inset_size ={x= inset_bg_size.x+10,y = 10,width = inset_bg_size.i_width-20,height = inset_bg_size.i_height-20}


	----------信息栏  左上
	self.inset_info = CCDialog:dialogWithFile(inset_size.x, inset_size.y, inset_size.width, inset_size.height, 100, "", TYPE_HORIZONTAL, ADD_LIST_DIR_UP, 960, 640 )
	self.inset_info:setAutoScroll(true)

	-- 信息栏底板   左上底板
	local info_bg = CCBasePanel:panelWithFile(inset_bg_size.x, inset_bg_size.y, inset_bg_size.i_width, inset_bg_size.i_height, UILH_COMMON.bottom_bg, 500, 500)
	self.left_panel:addChild(info_bg)
	info_bg:addChild(self.inset_info)

end



local _exit_button_info				= {width = 62, height = 56, image = {UIPIC_COMMOM_008, UIPIC_COMMOM_008} }
local _min_button_info				= {width = 62, height = 56, image = {UILH_NORMAL.small_btn, UILH_NORMAL.small_btn} }



local function create_private_chat(self, width, height)
	----------退出按钮
	self.exit_btn = ZButton:create( nil, _exit_button_info.image, nil, 0, 0, -1, -1)
	local exit_size = self.exit_btn:getSize()
	local wind_size = self.view:getSize()
	self.exit_btn:setPosition( wind_size.width - exit_size.width , wind_size.height - exit_size.height+15  )
	self.view:addChild(self.exit_btn.view)

	----------最小化按钮
	self.min_btn = ZButton:create( nil, _min_button_info.image, nil, 0, 0, -1, -1)
	local min_size = self.min_btn:getSize()
	self.min_btn:setPosition(  wind_size.width - min_size.width-50, height - min_size.height+15 )
	self.view:addChild(self.min_btn.view)
end



local function right_panel_create(self, x, y, width ,height)
	-- local _bottom_title_info = { x = 2, y = 165, width = 131, height = 19, image = nil, text = nil, fontsize = 16 }
	-- local _scroll_info = { x = 0, y = 10, width = 182, height = 164, maxnum = 1, scrolltype = TYPE_HORIZONTAL_EX }
	-- local _dialog_info = { x = 5, y = 230, width = 165 + 30, height = 115, addtype = ADD_LIST_DIR_UP, maxnum = 100 }

	------------底板
	local panel = ZBasePanel:create( nil, nil, x, y, width, height, 900, 900)
	self.view:addChild(panel.view)
	self.rightpanel = panel

	--仙宗公告标题栏
	local gonggao_bg = CCBasePanel:panelWithFile(0, 242+60, width, 175, UILH_COMMON.bottom_bg, 500, 500)
	panel:addChild(gonggao_bg)

	local title_bg = CCZXImage:imageWithFile(8, 132, 210, 35, UILH_COMMON.title_bg2)
	gonggao_bg:addChild(title_bg)
	-- local title_img = CCZXImage:imageWithFile(21, 4, -1, -1, UIPIC_XZWIN_003)
	-- title_bg:addChild(title_img)
	    local title_name =  UILabel:create_lable_2(LH_COLOR[5]..Lang.guild[30], 67, 10, font_size, ALIGN_LEFT ) 
    title_bg:addChild(title_name)

	------------ 公告
	self.notic_dialog = ZDialog:create( nil, nil, 10, 130, width-20, 120, nil, 100 )
	self.notic_dialog.view:setAnchorPoint( 0, 1 )
	gonggao_bg:addChild(self.notic_dialog.view)
	-- local dialog_size = self.notic_dialog:getSize()
	-- local dialog_pos = self.notic_dialog:getPosition()

	-----仙宗好友  军团好友
	local friend_xianzong_bg = CCBasePanel:panelWithFile(0, 60, width, 240, UILH_COMMON.bottom_bg, 500, 500)
	panel:addChild(friend_xianzong_bg)

	local title_bg = CCZXImage:imageWithFile(8, 197, 210, 35, UILH_COMMON.title_bg2)
	friend_xianzong_bg:addChild(title_bg)
	-- local title_img = CCZXImage:imageWithFile(21, 4, -1, -1, UIPIC_XZWIN_004)
	-- title_bg:addChild(title_img)
	local title_name2 =  UILabel:create_lable_2(LH_COLOR[5]..Lang.guild[37], 67, 10, font_size, ALIGN_LEFT ) 
    title_bg:addChild(title_name2)


	-- local scroll_reserve_size = 5
	local scrollbar_up = ZImage:create(friend_xianzong_bg,UIPIC_DREAMLAND.scrollbar_up,209,186,-1,-1)
	self.scroll = ZScroll:create( nil, nil, 12, 17, width-30, 170, 1, TYPE_HORIZONTAL_EX )
	friend_xianzong_bg:addChild(self.scroll.view)
	self.scroll:setScrollCreatFunction(ChatXZModel.scroll_create_fun)
	self.scroll:setScrollLump( 11, 10, 10 )
	local scrollbar_down = ZImage:create(friend_xianzong_bg,UIPIC_DREAMLAND.scrollbar_down,210,8,-1,-1)
	-- local scroll_size = self.scroll:getSize()
	-- local scroll_pos = self.scroll:getPosition()


	-- self.bottom_title = ZTextImage:create( nil, _bottom_title_info.text, _bottom_title_info.image, nil, _bottom_title_info.x, scroll_pos.y + scroll_size.height + 5, _bottom_title_info.width, _bottom_title_info.height )
	-- panel:addChild(self.bottom_title)
	-- local bottom_title_size = self.bottom_title:getSize()
	-- local bottom_title_pos = self.bottom_title:getPosition()	

	------------
	-- self.notic_scroll = ZScroll:create( nil, nil, _dialog_info.x + 10, bottom_title_pos.y + bottom_title_size.height + 20, _dialog_info.width - 20 , _dialog_info.height, 1, TYPE_HORIZONTAL )
	-- self.notic_scroll.view:addItem( self.notic_dialog.view )
	-- panel:addChild( self.notic_scroll )


    ----------发送按钮
	self.send = ZTextButton:create( nil, Lang.chat.send, {UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s}, nil, 60 , 0, -1, -1)
	self.rightpanel:addChild(self.send.view)


end


function ChatXZWin:__init(window_name, texture, isgrid, width, height)
	--第二层底图框
	-- local bgPanel = CCBasePanel:panelWithFile(0, 0, 600, 530	, UILH_COMMON.lh_bg_03, 500, 500)
	-- self.view:addChild(bgPanel)

	--聊天框左边
	create_left_panel(self, 10, 15 ,358, 480)
	--聊天框右边
	right_panel_create(self, 365, 15, 227, 480)
	create_private_chat( self, width, height)
	local left_panel_size = self.left_panel:getSize()

	self.send:setTouchClickFun(ChatXZModel.send_btn_fun)
	self.exit_btn:setTouchClickFun(ChatXZModel.exit_btn_fun)
	self.min_btn:setTouchClickFun(ChatXZModel.min_btn_fun)
	self.self_pos:setTouchClickFun(ChatXZModel.self_pos_fun)
	self.face:setTouchClickFun(ChatXZModel.face_btn_fun)

	local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
            local face_win = UIManager:find_visible_window("chat_face_win")
            if face_win then
            	UIManager:hide_window("chat_face_win")
            end
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)
    self.rightpanel.view:registerScriptHandler(self_view_func)
    -- self.inset_info:setMessageCut(true)
    -- self.inset_info:registerScriptHandler(self_view_func)
    self.notic_dialog.view:setMessageCut(true)
    self.notic_dialog.view:registerScriptHandler(self_view_func)
end

------------------取得滑动条信息
function ChatXZWin:get_scroll_info()
	if self.scroll ~= nil then
		local scroll_size = self.scroll:getSize()
		local temp_info = {width = scroll_size.width, height = scroll_size.height}
		return temp_info
	end
end
------------------设置对话框信息
function ChatXZWin:set_notic_info(info)
	-- print("run ChatXZWin:set_notic_info ", info, self.notic_dialog )
	if self.notic_dialog ~= nil then
		self.notic_dialog:setText(info)
		-- local scroll_size = self.notic_scroll.view:getSize()
		-- local notic_size = self.notic_dialog.view:getSize()
		-- if scroll_size.height < notic_size.height then
		-- 	self.notic_dialog.view:setPosition( 0, scroll_size.height - notic_size.height )
		-- end
	end
end
------------------设置输入框内容
function ChatXZWin:set_insert_text(info)
	if self.editbox ~= nil then
		self.editbox:setText(info)
	end
end
------------------
------------------插入输入框内容
function ChatXZWin:set_insert_info(info)
	if self.editbox ~= nil then
		self.editbox:insertText(info,0)
		local chat_face = UIManager:find_visible_window("chat_face_win")
		if chat_face ~= nil then
			ChatFaceModel:hide_face_fun()
		end
	end
end
------------------
------------------取得输入框内容
function ChatXZWin:get_insert_info()
	if self.editbox ~= nil then
		return self.editbox:getText()
	end
end
------------------
------------------取得输入框发送内容 
function ChatXZWin:get_insert_text_info()
	if self.editbox ~= nil then
		return self.editbox:getTextInfo(ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
	end
end
------------------
------------------设置信息框内容
function ChatXZWin:set_dialog_info(info)
	-- print("self.inset_info", self.inset_info)
	if self.inset_info ~= nil then
		require "model/Hyperlink"
		local hyperhead = Hyperlink:get_script_head()
		--local hyperhead = UIManager:find_window("hyper_link"):get_script_head()
		self.inset_info:setText(info, hyperhead)
	end
end



------------------弹出/关闭 键盘时将整个ChatXZWin的y坐标的调整
function ChatXZWin:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible = true;
    local win = UIManager:find_visible_window("chat_xz_win");
    -- local win_info = UIManager:get_win_info("chat_xz_win")
    if win then
        if keyboard_h == 162 then--ip eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 198 then---ip cn
            win:setPosition(_refWidth(0.5),650);
        elseif keyboard_h == 352 then --ipad eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 406 then --ipad cn
            win:setPosition(_refWidth(0.5),620);
        end
    end
end
function ChatXZWin:keyboard_will_hide(  )
    self.keyboard_visible = false;
    local win = UIManager:find_visible_window("chat_xz_win");
    -- local win_info = UIManager:get_win_info("chat_xz_win")
    if win then
        win:setPosition(_refWidth(0.5),_refHeight(0.5));
    end
end

-------------------- 手动关闭键盘
function ChatXZWin:hide_keyboard(  )
    if self.editbox then
        self.editbox:detachWithIME();
    end
end

function ChatXZWin:destroy(  )
	self:hide_keyboard()
end

