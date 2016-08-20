-----chat.lua
-----HJH
-----2012-12-3
-----聊天框
-----共分5个界面
-----第一个为聊天总信息显示界面
-----消息开始号为1000
-----第二个为聊天输入界面
-----消息开始号为2000
-----第三个为角色名字选择弹出界面
-----消息开始号为3000
-----第四个为鲜花界面
-----消息开始号为4000
-----第五个为私聊界面
-----消息开始号为5000
-----
-----
require "UI/component/Window"
require "utils/Utils"
require "UI/chat/ChatInfo"
require "UI/chat/ChatInput"
--require "UI/chat/ChatFace"
--require "UI/chat/ChatNameSelect"
--require "UI/chat/ChatChanelSelect"
-- require "UI/chat/ChatFlower"
-- require "UI/chat/ChatPrivateChat"
super_class.ChatWin(NormalStyleWindow)
------------------
------------------
local _visible					= false
local _window_size				= { width  = GameScreenConfig.ui_screen_height, 
									height = GameScreenConfig.ui_screen_height }

local _chatInputLayout = { 0,13,880,64 }
------------------
------------------主窗口消息函数
local function main_fun(eventType, arg, msgid, selfItem)
	if eventType == nil or arg == nil then
		return false
	end
	----------------------
	--print("run main_fun",eventType)
	if eventType == TOUCH_BEGAN then 
		--local chat_win = UIManager:find_window("chat_win")
		--ChatWin:setIndexPanelVisible(ChatConfig.WinType.TYPE_CHAT_NAME_SELECT,false)
		-- ChatWin:setChatInputInsertBoxIconHide(false)
		-- ChatWin:setPrivateChatInsertBoxIconHide(false)
		return false
	elseif eventType == TOUCH_MOVED then
		return false
	elseif eventType == TOUCH_ENDED then
		return false
	elseif eventType == TOUCH_CLICK then
		return false
		-- print("run touch click")
		-- _chat_info[4].view:setIsVisible(false)
		-- _chat_info[2]:setInsertBoxIconHide(false)
	end
end
------------------
------------------设置指定聊天栏、显隐
function ChatWin:set_index_info_scroll_visible(index)
	if self.chat_info ~= nil then
		self.chat_info:set_index_scroll_visible(index)
	end
end
------------------
------------------设置聊天显示栏定时器运行与关闭
function ChatWin:set_info_timer(rate)
	if self.chat_info ~= nil then
		self.chat_info:set_timer(rate)
	end
end
------------------
------------------取得聊天栏对象
function ChatWin:get_info_target()
	return self.chat_info
end
------------------
------------------取得聊天输入框对象
function ChatWin:get_insert_target()
	return self.chat_input_edit
end
------------------
------------------取得频道选择框对象（已废弃）
function ChatWin:get_chanel_select_target()
	return self.chanel_select
end
------------------
------------------创建聊天功能界面
function ChatWin:create_chat(width, height)
	--self.exit_btn:setTouchClickFun(ChatModel.info_exit_fun)
	------退出按钮
	-- local function exit_fun()
	-- 	UIManager:hide_window("chat_win")
	-- end
	-- self.exit_btn = ZButton:create( nil, {UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"}, exit_fun, 0, 0, -1, -1)
	-- local exit_size = self.exit_btn:getSize()
	-- self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height )
	-- local exit_pos = self.exit_btn:getPosition()
	-- --self.exit_btn:setTouchClickFun(exit_fun)
	-- self:addChild( self.exit_btn.view )

	--_chat_info[ChatConfig.WinType.TYPE_CHAT_INSERT] = chat_input_edit
	-- local chat_bg = ZImage:create(nil, UIPIC_ChatWin_01, 0, 0, -1, -1)
	-- local chat_bg2 = ZImage:create(nil, UIPOS_TopListWin_0018, 11, 10, 840, 442, 0, 500, 500)
	-- self.view:addChild(chat_bg.view)
	-- self.view:addChild(chat_bg2.view)
	----聊天信息
	local chat_info = ChatInfo( "", "", true, 850, 545)

	self.view:addChild(chat_info.view)
	chat_info.view:setPosition(20, 70)
	chat_info.view:setIsVisible(true)
	self.chat_info = chat_info	

	local bg = ZImage:create(self.view, UILH_COMMON.bottom_bg,15,18,870, 540, -1, 500, 500)
	------聊天输入
	local chat_input_edit = ChatInput("", "",true,
									  _chatInputLayout[3], 
									  _chatInputLayout[4])

	chat_input_edit.view:setPosition(_chatInputLayout[1], _chatInputLayout[2])
	self.view:addChild(chat_input_edit.view)
	--chat_input_edit.view:setIsVisible(false)
	self.chat_input_edit = chat_input_edit

    local function self_view_func( eventType )
	    if eventType == TOUCH_BEGAN then
	        chat_input_edit:hide_keyboard()
	        local face_win = UIManager:find_visible_window("chat_face_win")
	        local face_type = ChatFaceModel:get_chat_face_type()
	        if face_win and face_type ~= 3 then
	        	ChatFaceModel:set_chat_face_type(face_type == 1 and 3 or 4)
	        	UIManager:hide_window("chat_face_win")
	        else
				ChatFaceModel:set_chat_face_type(1)
	        end
	        local select_win = UIManager:find_visible_window("chat_chanel_select_win")
	        if select_win and input_cur_chanel_fun ~= 2 then
	        	ChatChanelSelectModel:set_show_type(2)
	        	UIManager:hide_window("chat_chanel_select_win")
	        else
	        	ChatChanelSelectModel:set_show_type(1)
	        end
	    end
	    return false
    end
    -- chat_input_edit.view:registerScriptHandler(self_view_func)
    -- chat_info.group_scroll:registerScriptHandler(self_view_func)

    -- 这里盖了一层用作回收键盘和表情框等
	local conten = self.view:getSize()
	local basepanel = CCBasePanel:panelWithFile( 0, 0, conten.width,conten.height,nil);
	basepanel:setAnchorPoint(0,0)
	self.view:addChild(basepanel,9999)
	basepanel:registerScriptHandler(self_view_func)

	--self.view:registerScriptHandler(main_fun)
	--注册主窗口消息函数
	--self.view:setDefaultMessageReturn(false)
	-- -----
	-- local temp_label = CCLabelTTF:labelWithString("韦盼烟赤脚灰烬大老粗偿", CCSizeMake(50, 50), CCTextAlignmentLeft, "", 16)
	-- self.border_label = ZXResMgr:sharedManager():createStroke(temp_label, 16)
	-- self.border_label:setPosition(CCPointMake(200, 100))
	-- temp_label:setPosition(CCPointMake(200, 100))
	-- self.view:addChild(self.border_label)
	-- self.view:addChild(temp_label)
	-- self.image_temp = CCSprite:spriteWithTexture(ZXResMgr:sharedManager():getIndex(0))
	-- self.image_temp:setPosition(CCPointMake(256,256))
	-- self.view:addChild(self.image_temp)
end
------------------
------------------
function ChatWin:__init(window_name, texture_name, is_grid, width, height)
	-- 初始化构建控件
     self:create_chat(width, height)
     self.is_show_window = false
     --self.view:registerScriptHandler(self:chat_win_function)
end

-- 摧毁窗口，被UIManager调用
function ChatWin:destroy(  )
    Window.destroy(self)
    if self.chat_info then
        self.chat_info:destroy()
    end

    if self.chat_input_edit then
        self.chat_input_edit:destroy()
    end

    UIManager:destroy_window("chat_face_win")
    UIManager:destroy_window("chat_flower_send_win")
end
----------------
function ChatWin:active(show)
	-- print("show",show)
	-- print("self.is_show_window ",self.is_show_window )
	-- if show == false and self.is_show_window == true then
	-- 	self.is_show_window  = false
	-- 	ChatModel:info_exit_fun()
	-- else
	-- 	self.is_show_window = true
	-- end
	-- if show == true then
	-- 	ChatModel:run_open_chat_win()
	-- else
	-- 	ChatModel:run_exit_chat_win()
	-- end

	-- 关闭聊天界面的时候要把聊天频道选择界面关闭
	if show == false then
		UIManager:hide_window("chat_face_win")
		UIManager:hide_window("chat_chanel_select_win")
	end

	self.chat_info:active(show)

end
----------------
----设置输入栏内容
function ChatWin:set_insert_info(info)
	if self.chat_input_edit ~= nil then
		self.chat_input_edit:inert_edit_box_info(info)
	end
end
--UIManager使用来创建ChatWin
-- function ChatWin:create()
-- 	return ChatWin( "", 0, 0, 800, 480)
-- end
----------------
----清空当前输入内容
function ChatWin:clear_chanel_info()
	if self.chat_info then
		self.chat_info:clear_chanel_info()
	end
end