----HJH
----2013-1-12
------------------私聊界面
------------------

------------------
-- require "UI/chat/ChatOther"
------------------
super_class.ChatPrivateChatWin(Window)
------------------
local _window_size = {width = 960, height = 640}


local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

------------------
local function right_panel_create(self)
	------------
	local panel = ZBasePanel:create( nil, UILH_COMMON.bottom_bg, 370, 15, 200, 505, 500, 500 );
	self.view:addChild(panel.view)
	
	--邀请按钮
	-- xiehande UI_ChatPrivate_004 ->UIPIC_COMMON_BUTTON_001
	self.invote_btn = ZImageButton:create( nil, UILH_COMMON.btn4_nor, UILH_PRIVATE.team_text, ChatPrivateChatModel.invote_btn_fun, 39, 13, -1, -1 )	--Lang.chat.private[1] = "邀请组队"
	panel:addChild(self.invote_btn)
	
	--查看信息按钮
	local check_data_btn_fun = function(  )
		self:hide_keyboard()
		ChatPrivateChatModel:check_data_btn_fun()
	end
	--xiehande UI_ChatPrivate_003 ->UIPIC_COMMON_BUTTON_001
	self.check_data_btn = ZImageButton:create( nil, UILH_COMMON.btn4_nor, UILH_PRIVATE.info_text, check_data_btn_fun, 39, 75, -1, -1 )	--Lang.chat.private[2] = "查看资料"
	panel:addChild(self.check_data_btn)
	
	--添加好友按钮
	self.add_friend_btn = ZImageButton:create( nil, UILH_COMMON.btn4_nor, UILH_PRIVATE.add_text, ChatPrivateChatModel.add_friend_btn_fun, 39, 137, -1, -1 )	--Lang.chat.private[3] = "加为好友"
	panel:addChild(self.add_friend_btn)
	
	--职业
	self.job_label = ZLabel:create( nil, "aa", 60, 220, 16 )
	panel:addChild(self.job_label)
	
	--阵营
	self.camp_label = ZLabel:create( nil, "bb", 60, 252, 16 )
	panel:addChild(self.camp_label)
	
	--等级
	self.level_label = ZLabel:create( nil, "cc", 60, 284, 16 )
	panel:addChild(self.level_label)

	local name_bg = ZImage:create(panel, UILH_BENEFIT.pattern1, 10, 340, -1, -1)
	--角色名
	self.role_name = ZLabel:create( nil, "dd", 91, 10, 16, 2 )
	name_bg:addChild(self.role_name)
	local line = ZImage:create(panel, UILH_COMMON.split_line, 10, 197, 180, 3, 500)
	
	--角色头像底图
	-- local laceLU = CCBasePanel:panelWithFile(5, 460, -1, -1, UILH_PRIVATE.head_lace)
	-- laceLU:setFlipX(true)
	-- local laceRU = CCBasePanel:panelWithFile(95, 460, -1, -1, UILH_PRIVATE.head_lace)
	-- local laceLD = CCBasePanel:panelWithFile(5, 360, -1, -1, UILH_PRIVATE.head_lace)
	-- laceLD:setFlipX(true)
	-- laceLD:setFlipY(true)
	-- local laceRD = CCBasePanel:panelWithFile(95, 360, -1, -1, UILH_PRIVATE.head_lace)
	-- laceRD:setFlipY(true)
	-- panel:addChild(laceLU)
	-- panel:addChild(laceRU)
	-- panel:addChild(laceLD)
	-- panel:addChild(laceRD)
	local role_bg = ZImage:create( nil, UILH_PRIVATE.head_bg, 41, 379, -1, -1)
	panel:addChild(role_bg)
	
	--角色头像
	self.role_icon = ZImage:create( nil, "", 58, 395, 80, 80 )
	panel:addChild(self.role_icon)
	------------
	return panel
end

function ChatPrivateChatWin:__init(window_name, texture, grid, width, height)
	-- 背景框
	local bg_panel = CCBasePanel:panelWithFile( 0, 0, width, height, "", 500 )
	self.view:addChild( bg_panel )

	ZImage:create( bg_panel, UILH_COMMON.dialog_bg, 0, 0, width-25, height-25, nil, 500, 500)
	ZImage:create( bg_panel, UILH_COMMON.bottom_bg, 11, 15, 357, 505, nil, 600, 600)
	local title_bg = ZImage:create( bg_panel, UILH_NORMAL.title_bg4, 3, height-65, width-55, -1, nil, 600, 600)

	-- 与某某人聊天
	self.title = ZLabel:create( title_bg, "", 200,  10 , 16, 1)

	-- 发送按钮  UI_ChatPrivate_003
	self.send = ZTextButton:create( nil, Lang.chat.send, UILH_COMMON.lh_button2, nil, 253, 23, -1, -1) -- Lang.chat.send="发送"
	bg_panel:addChild( self.send.view )
	self.send:setTouchClickFun(ChatPrivateChatModel.send_btn_fun)

	self.self_pos = ZButton:create( nil, UILH_CHATWIN.pos, nil, 20 , 25, -1, -1 )
	self.self_pos:setTouchClickFun(ChatPrivateChatModel.self_pos_fun)
	bg_panel:addChild( self.self_pos.view )

	self.face = ZButton:create( nil, UILH_CHATWIN.face, nil, 80 , 25, -1, -1 )
	self.face:setTouchClickFun(ChatPrivateChatModel.face_btn_fun)
	bg_panel:addChild( self.face.view )

	-- 删除按钮
	self.delete = ZButton:create( nil, UILH_CHATWIN.delete, nil, 170 , 25, -1, -1 )
	local function delete_btn_function()
		self.editbox:setText("")
	end
	self.delete:setTouchClickFun(delete_btn_function)
	bg_panel:addChild( self.delete.view )

	self.editbox = CCZXEditBoxArea:editWithFile( 8, 5, 325, 110, nil, 100, 16, 800, 800 );
	local editbox_bg = CCBasePanel:panelWithFile(20, 86, 340, 121, UILH_COMMON.bg_10, 500, 500)
	editbox_bg:addChild(self.editbox)
	bg_panel:addChild(editbox_bg)

	local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            
        elseif eventType == KEYBOARD_FINISH_INSERT then
            -- ZXLog('-----------detachWithIME---------')
            self:hide_keyboard()
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
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height );
        end
        return true
    end
    self.editbox:registerScriptHandler( edit_box_function )

	-- 信息栏(聊天信息板)
	self.inset_info = CCDialog:dialogWithFile(5, 5, 330, 310, 120, "", TYPE_HORIZONTAL, ADD_LIST_DIR_UP, 800, 800 )
	self.inset_info:setAutoScroll(true)
	self.inset_info:setGapSize(18)
	self.inset_info:setFontSize( 20 )
	
	-- 信息栏底板(聊天信息记录板)
	local info_bg = CCBasePanel:panelWithFile(15, 206, 339, 295, "")
	bg_panel:addChild(info_bg)
	info_bg:addChild(self.inset_info)
	--缩小按钮
	local spr_bg_size   = self.view:getSize();
	local min_btn = ZButton:create(nil, UILH_NORMAL.small_btn, ChatPrivateChatModel.min_btn_fun, spr_bg_size.width - 120, spr_bg_size.height - 60, -1, -1)
	bg_panel:addChild(min_btn.view, 1002)
	-- 关闭按钮
	self.exit_btn = ZButton:create( nil, UIPIC_COMMOM_008, nil, 0, 0, -1, -1, 999 )
	local exit_btn_size = self.exit_btn:getSize();
	self.exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
	-- -- 设置关闭按钮回调函数
	if self.exit_btn then
		self.exit_btn:setTouchClickFun(ChatPrivateChatModel.exit_btn_fun);
	end
	bg_panel:addChild(self.exit_btn.view, 1002)
	self.rightpanel = right_panel_create(self)
	-- self.min_btn:setTouchClickFun(ChatPrivateChatModel.min_btn_fun)

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
end

--取得输入框信息
function ChatPrivateChatWin:get_insert_info()
	if self.editbox ~= nil then
		return self.editbox:getText()
	else
		return ""
	end
end

--初始化私聊信息
function ChatPrivateChatWin:reinit_info(title, name, level, camp, job, icon)
	self.title.view:setText( title )
	local rightsize = self.rightpanel.view:getSize()
	self.role_name:setText(name)
	-- local role_pos = self.role_name:getPosition()
	-- local name_size = self.role_name.view:getSize()
	-- self.role_name.view:setPosition( (rightsize.width - name_size.width) * 0.5,  role_pos.y)
	self.level_label:setText(level)
	self.camp_label:setText(camp)
	self.job_label:setText(job)
	self.role_icon:setImage(icon)
end

function ChatPrivateChatWin:active(show)
	if show == true then
		ChatFaceModel:set_cur_atcive_win(self)
	end
end

--设置输入框内容
function ChatPrivateChatWin:set_insert_text(info)
	if self.editbox ~= nil then
		self.editbox:setText(info)
	end
end

--插入输入框内容
function ChatPrivateChatWin:set_insert_info(info)
	if self.editbox ~= nil then
		self.editbox:insertText(info,0)
		local chat_face = UIManager:find_visible_window("chat_face_win")
		if chat_face ~= nil then
			ChatFaceModel:hide_face_fun()
		end
	end
end

--取得输入框内容
function ChatPrivateChatWin:get_insert_info()
	if self.editbox ~= nil then
		return self.editbox:getText()
	end
end

-- 取得输入框发送的内容
function ChatPrivateChatWin:get_insert_text_info()
	if self.editbox ~= nil then
		return self.editbox:getTextInfo(ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
	end
end

-- 设置信息框内容
function ChatPrivateChatWin:set_dialog_info(info)
	print("self.inset_info", self.inset_info)
	if self.inset_info ~= nil then
		require "model/Hyperlink"
		local hyperhead = Hyperlink:get_script_head()
		--UIManager:find_window("hyper_link"):get_script_head()
		self.inset_info:setText(info, hyperhead)
	end
end

------------------弹出/关闭 键盘时将整个ChatPrivateChatWin的y坐标的调整
function ChatPrivateChatWin:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible = true;
    local win = UIManager:find_visible_window("chat_private_win");
    -- local win_info = UIManager:get_win_info("chat_private_win")
    if win then
        if keyboard_h == 162 then--ip eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 198 then---ip cn
            win:setPosition(_refWidth(0.5),223);
        elseif keyboard_h == 352 then --ipad eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 406 then --ipad cn
            win:setPosition(_refWidth(0.5),620);
        end
    end
end
function ChatPrivateChatWin:keyboard_will_hide(  )
    self.keyboard_visible = false;
    local win = UIManager:find_visible_window("chat_private_win");
    -- local win_info = UIManager:get_win_info("chat_private_win")
    if win then
        win:setPosition(_refWidth(0.5),_refHeight(0.5));
    end
end

-------------------- 手动关闭键盘
function ChatPrivateChatWin:hide_keyboard(  )

    if self.editbox then
        self.editbox:detachWithIME();
    end
end
