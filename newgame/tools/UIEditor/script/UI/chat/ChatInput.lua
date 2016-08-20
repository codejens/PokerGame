----HJH
----2013-1-10
------------------聊天输入界面
super_class.ChatInput(Window)
------------------

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
function ChatInput:create_panel(width, height)
	------------------
	local _window_size						= { width  = GameScreenConfig.ui_screen_height, 
									    		height = GameScreenConfig.ui_screen_height }
--xiehande 通用按钮  btn_lan.png ->button3
	local _cur_chanel_info 	= { 40,12,78,45, -- pos size
							    text = Lang.chat.chanel_name[5], -- Lang.chat.chanel_name[5]="附近"
								image = { UIPIC_COMMON_BUTTON_004, 
										  UIPIC_COMMON_BUTTON_004} } 
	local chanel_text		= { [3] = Lang.chat.chanel_name[3], [4] = Lang.chat.chanel_name[4], [6] = Lang.chat.chanel_name[5], [7] = Lang.chat.chanel_name[1], [8] = Lang.chat.chanel_name[2]}
	-------------------------------------------------------------------------------------------------------------
	local _edit_box_info	= { 118,12,400,45, 
								maxnum = 41, 
								image = "" }

	local _edit_box_info_bg	= { 42,11,490,47, 
								maxnum = 41, 
								image = UILH_COMMON.bg_10 }
	-------------------------------------------------------------------------------------------------------------							
	local _delete_info		= { 516,11,55,50,  
								image = {	UILH_CHATWIN.delete,
											UILH_CHATWIN.delete} }
	-------------------------------------------------------------------------------------------------------------
	local _bag_info			= 	{ 580,11,50,50, 
								image_label = UILH_CHATWIN.bag,
								image = { "",
										  ""} }
	local _face_info 	= 	{ 640,11,50,50, 
								image_label = UILH_CHATWIN.face,
								image = { "",
										  ""} }
	-------------------------------------------------------------------------------------------------------------							
	local _self_pos_info 	= { 700,11,50,50, 
								image_label = UILH_CHATWIN.pos,
								image = { "",
										  ""} }
	-------------------------------------------------------------------------------------------------------------							
	--xiehande btn_lv.png ->button3
	local _send_info		= { 764,11,110,50, -- pos size
								text = Lang.chat.send, -- "发送"
								image = { UIPIC_COMMON_BUTTON_001, 
										  UIPIC_COMMON_BUTTON_001_DOWN} } 

	-- local _exit_info		= { width = 62, height = 56, image = {UIResourcePath.FileLocate.common .. "close_btn_z.png",UIResourcePath.FileLocate.common .. "close_btn_z.png"} }
	------------------
	-- require "UI/component/TextButton"
	-- require "UI/component/EditBox"
	-- require "UI/component/Button"
	-- require "UI/component/Image"
	-- require "model/ChatModel/ChatModel"
	self.keyboard_visible = false;

	------------------当前频道按钮
	self.cur_chanel = ZTextButton:create( nil, _cur_chanel_info.text, 
											   _cur_chanel_info.image, 
											   ChatModel.input_cur_chanel_fun, 
											   _cur_chanel_info[1],_cur_chanel_info[2], 
											   _cur_chanel_info[3],_cur_chanel_info[4], 
											   nil, 
											   _window_size.width, _window_size.width)

	self.cur_chanel:setText(chanel_text[ChatModel:get_cur_chanel_select()] or "")
	--local cur_chanel_pos = self.cur_chanel:getPosition()
	--cur_chanel_pos.y = cur_chanel_pos.y
	--local cur_chanel_size = self.cur_chanel:getSize()
	--self.cur_chanel:setTouchClickFun()
	------------------输入框底图
	self.edit_box_bg = ZImage:create( nil, _edit_box_info_bg.image, 
										   _edit_box_info_bg[1],_edit_box_info_bg[2], 
										   _edit_box_info_bg[3],_edit_box_info_bg[4],
										   nil, 
										   500, 
										   500 )

	local edit_box_bg_size = self.edit_box_bg:getSize()
	local edit_box_bg_pos = self.edit_box_bg:getPosition()
	local edit_box_gapsize = 10
	-------------------输入框对象
	self.edit_box = CCZXAnalyzeEditBox:editWithFile( _edit_box_info[1], _edit_box_info[2], 
													 _edit_box_info[3], _edit_box_info[4], 
													 "", _edit_box_info.maxnum, 18 )

	local function edit_box_function(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return true
		end
		if eventType == KEYBOARD_CONTENT_TEXT then
			
		elseif eventType == KEYBOARD_FINISH_INSERT then
			self:hide_keyboard()
		elseif eventType == TOUCH_BEGAN then
			-- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
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

	self.edit_box:registerScriptHandler(edit_box_function)
	--float posx, float posy, float width, float height, const char *file, unsigned short maxnum, unsigned char fontsize,
	--EditBox:create( nil, cur_chanel_pos.x + cur_chanel_size.width + 10, cur_chanel_pos.y , _edit_box_info.width, _edit_box_info.height, _edit_box_info.maxnum, _edit_box_info.image, _window_size.width, _window_size.width)
	local edit_box_pos = self.edit_box:getPositionS()
	local edit_box_size = self.edit_box:getSize()
	------------------删除按钮
	self.delete = ZButton:create( nil, _delete_info.image, ChatModel.input_delete_fun, 
										_delete_info[1],_delete_info[2], 
										_delete_info[3],_delete_info[4] )

	local delete_pos = self.delete:getPosition()
	local delete_size = self.delete:getSize()

	------------------当前位置按钮
	local itemPerStept = 15
	self.pos = ZImageButton:create( nil, 
									_self_pos_info.image, 
									_self_pos_info.image_label,
									ChatModel.input_pos_fun, 
									_self_pos_info[1],_self_pos_info[2], 
									_self_pos_info[3],_self_pos_info[4],
									nil, 
									_window_size.width, 
									_window_size.width)
	local pos_pos = self.pos:getPosition()
	local pos_size = self.pos:getSize()
	--self.pos:setTouchClickFun()
	------------------表情按钮
	self.face = ZImageButton:create( nil, 
									_face_info.image, 
									_face_info.image_label,
									ChatModel.input_face_fun, 
									_face_info[1],_face_info[2], 
									_face_info[3],_face_info[4],
									nil, 
									_window_size.width, 
									_window_size.width)

	local face_pos = self.face:getPosition()
	local face_size = self.face:getSize()
	local function input_face_func( )
		
		if self.keyboard_visible == false then
			ChatModel.input_face_fun()
		end
		self:hide_keyboard()
	end
	self.face:setTouchClickFun(input_face_func)
	------------------背包按钮
	self.bag = ZImageButton:create( nil, 
									_bag_info.image, 
									_bag_info.image_label,
									ChatModel.input_bag_fun, 
									_bag_info[1],_bag_info[2], 
									_bag_info[3],_bag_info[4],
									nil, 
									_window_size.width, 
									_window_size.width)
	local bag_pos = self.bag:getPosition()
	bag_pos.y = bag_pos.y + 2
	local bag_size = self.bag:getSize()
	local function input_bag_func( )
		
		if self.keyboard_visible == false then
			ChatModel.input_bag_fun()
		end
		self:hide_keyboard()
	end
	self.bag:setTouchClickFun(input_bag_func)
	------------------发送按钮
	self.send = ZTextButton:create( nil, _send_info.text, _send_info.image, 
										 ChatModel.input_send_fun, 
										 _send_info[1],_send_info[2], 
										 _send_info[3],_send_info[4], 
										 nil, 
										 _window_size.width, 
										 _window_size.width)
	-- self.send:setTouchClickFun()
	------------------输入栏底图
	--self.bg = Image:create( nil, 0, 0, width, 38, UIResourcePath.FileLocate.common .. "bg03.png", _window_size.width, _window_size.width)
	------------------退出按钮
	-- self.exit = Button:create( nil, 0, 0, -1, -1, _exit_info.image)
	-- local exit_size = self.exit:getSize()
	-- self.exit:setPosition( 0, height - exit_size.height )
	-- self.exit:setTouchClickFun(ChatModel.input_exit_fun)
	------------------
	--self.view:addChild(self.bg.view)
	self.view:addChild(self.edit_box_bg.view)
	self.view:addChild(self.cur_chanel.view)
	self.view:addChild(self.edit_box)
	self.view:addChild(self.delete.view)
	self.view:addChild(self.pos.view)
	self.view:addChild(self.face.view)
	self.view:addChild(self.bag.view)
	self.view:addChild(self.send.view)
	--self.view:addChild(self.exit.view)
	------------------
	self:setTouchTimerFun(ChatModel.input_timer_fun)
end
------------------
function ChatInput:__init(windowName, window_info)
	-- 初始化构建控件
    self:create_panel(window_info.width, window_info.height)
    --self:registerScriptFun()
end
------------------
------------------设置当前频道
function ChatInput:set_cur_chanel_info(text)
	if self.cur_chanel ~= nil then
		self.cur_chanel:setText(text)
	end
end
------------------
------------------取得当前输入框内容
function ChatInput:get_edit_box_info()
	if self.edit_box ~= nil then
		return self.edit_box:getText()
	else
		return ""
	end
end
------------------
------------------设置输入框内容
function ChatInput:set_edit_box_info(info)
	if self.edit_box ~= nil then
		self.edit_box:setText(info)
	end
end
------------------
------------------插入输入框内容
function ChatInput:inert_edit_box_info(info)
	if self.edit_box ~= nil then
		self.edit_box:insertText(info)
	end
end
------------------
------------------取得输入框发送信息
function ChatInput:get_edit_box_info_ex()
	if self.edit_box ~= nil then
		return self.edit_box:getTextInfo("~")
	end
end

function ChatInput:active( show )
	if show then
	else
	end
end

------------------
------------------弹出/关闭 键盘时将整个chatWin的y坐标的调整
function ChatInput:keyboard_will_show( keyboard_w, keyboard_h )
	self.keyboard_visible = true;
	local win = UIManager:find_visible_window("chat_win");
	-- local win_info = UIManager:get_win_info("chat_win")
	if win then
		if keyboard_h == 162 then--ip eg
			win:setPosition(_refWidth(0.5),620+15);
		elseif keyboard_h == 198 then---ip cn
			win:setPosition(_refWidth(0.5),650+15);
		elseif keyboard_h == 352 then --ipad eg
        	win:setPosition(_refWidth(0.5),620+15);
	    elseif keyboard_h == 406 then --ipad cn
        	win:setPosition(_refWidth(0.5),620+15);
		end
	end
end

function ChatInput:keyboard_will_hide(  )
	self.keyboard_visible = false;
	local win = UIManager:find_visible_window("chat_win");
	-- local win_info = UIManager:get_win_info("chat_win")
	if win then
		win:setPosition(_refWidth(0.5),_refHeight(0.5));
	end
end
--------------------
-------------------- 手动关闭键盘
function ChatInput:hide_keyboard(  )

	-- if self.edit_box and self.keyboard_visible then
		self.edit_box:detachWithIME();
	-- end
end
function ChatInput:destroy(  )
	self:hide_keyboard()
	Window.destroy(self)
end

