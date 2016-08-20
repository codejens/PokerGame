 ------------------HJH
------------------2013－3－1
------------------私聊与仙宗聊天基类
super_class.ChatOther(Window)
------------------
require "model/ChatModel/ChatPrivateChatModel"
------------------
------------------
local function create_left_panel(self, x, y, width, height)
	------------------left panel
	local _window_size 		= {width = 800, height = 480}
	local _self_pos_info 	= {width = -1, height = -1, image = {UILH_CHATWIN.pos,UILH_CHATWIN.pos} }
	local _face_info		= {width = -1, height = -1, image = {UILH_CHATWIN.face,UILH_CHATWIN.face} }
	local _delete_info		= {width = -1, height = -1, image = {UILH_CHATWIN.bag,UILH_CHATWIN.bag} }
	--xiehande 通用按钮修改 btn_lv->button3
	local _send_button		= {width = 60, height = 40, text = Lang.chat.send, image = {UIPIC_COMMOM_002,UIPIC_COMMOM_002} } -- Lang.chat.send="发送"
	local _edit_box_info	= {height = 70, maxnum = 40, image = UILH_COMMON.bg_01, fontsize = 16 }
	local _insert_info 		= {height = height - _edit_box_info.height - 30, addType = ADD_LIST_DIR_UP, num = 10, fontsize = 16 }
	----------

	----------
	self.left_panel = CCBasePanel:panelWithFile( x, y, width, height, "", 500, 500)
	self.view:addChild(self.left_panel)

	----------旗子
	self.self_pos = ZButton:create( nil, _self_pos_info.image, nil, 14, 8, _self_pos_info.width, _self_pos_info.height)
	self.left_panel:addChild(self.self_pos.view)

	local temp_self_pos_size = self.self_pos:getSize()
	_self_pos_info.width = temp_self_pos_size.width
	_self_pos_info.height = temp_self_pos_size.height
	-- local function self_pos_function()
	-- 	local entity = EntityManager:get_player_avatar()
	-- 	local curSceneId = SceneManager:get_cur_scene()
	-- 	local curFubenId = SceneManager:get_cur_fuben()
	-- 	local locate = ""
	-- 	if curFubenId ~= nil and curFubenId > 0 then
	-- 		locate = SceneConfig:get_fuben_by_id(curFubenId).fbname
	-- 	else
	-- 		locate = SceneConfig:get_scene_by_id(curSceneId).scencename
	-- 	end
	-- 	local msginfo = locate .. "【" .. tostring(math.ceil(entity.x)) .. ":" .. tostring(math.ceil(entity.y)) .. "】"
	-- 	local lastinfo = self.editbox:getText()
	-- 	self.editbox:setText( lastinfo .. msginfo )
	-- end
	-- self.self_pos:setTouchClickFun(self_pos_function)

	----------表情按钮
	self.face = ZButton:create( nil, _face_info.image, nil, 9.5, 9.5, _face_info.width, _face_info.height)
	self.left_panel:addChild(self.face.view)

	-- local function face_btn_function()
	-- 	require "model/ChatModel/ChatFaceModel"
	-- 	ChatFaceModel:set_chat_face_type(1)
	-- 	local face_win = UIManager:show_window("chat_face_win")
	-- 	face_win:set_exit_btn_visible(true)
	-- 	face_win:clear_scroll()
	-- 	face_win:refresh_scroll()
	-- 	local face_win_pos = face_win:getPosition()
	-- 	face_win:setPosition( face_win_pos.x , 10)
	-- 	UIManager:show_window("chat_face_win")
	-- end
	-- self.face:setTouchClickFun(face_btn_function)

	local face_pos = self.face:getPosition()

	----------删除按钮
	self.delete = ZButton:create( nil, _delete_info.image, nil, 120 , 0, _delete_info.width, _delete_info.height)
	local function delete_btn_function()
		self.editbox:setText("")
	end
	self.delete:setTouchClickFun(delete_btn_function)

	----------发送按钮
	self.send = ZTextButton:create( nil, _send_button.text, _send_button.image, nil, 184 , 0, 126, 43)

	----------输入框
	-- ZImage:create(self.left_panel, _edit_box_info.image, 8, _self_pos_info.height - 15, width - 10, _edit_box_info.height + 10, nil, 600, 600 )
	self.editbox = CCZXEditBoxArea:editWithFile( 10, 10, width - 20, 88, UILH_COMMON.bg_02, _edit_box_info.maxnum, _edit_box_info.fontsize, _window_size.width, _window_size.width )

	local editbox_bg = CCBasePanel:panelWithFile(0, 58, width, 108, UILH_COMMON.bg_03, 500, 500)
	editbox_bg:addChild(self.editbox)
	self.left_panel:addChild(editbox_bg)

	--self.editbox = EditBox:create( nil, 0, _self_pos_info.height, width, _edit_box_info.height, _edit_box_info.maxnum, _edit_box_info.image, 16, 600, 600)
	local editbox_pos = self.editbox:getPositionS()

	----------信息栏
	self.inset_info = CCDialog:dialogWithFile(10, 10, width - 20, 326, 100, UILH_COMMON.bg_02, TYPE_HORIZONTAL, ADD_LIST_DIR_UP, _window_size.width, _window_size.width )
	self.inset_info:setAutoScroll(true)

	-- 信息栏底板
	local info_bg = CCBasePanel:panelWithFile(0, 170, width, 346, UILH_COMMON.bg_03, 500, 500)
	self.left_panel:addChild(info_bg)
	info_bg:addChild(self.inset_info)

	-- Dialog:create( nil, 0, editbox_pos.y + _edit_box_info.height + 10, width, _insert_info.height, _insert_info.addType, _insert_info.num)
	----------
	--self.inset_info_bg = Image:create( nil, 0, editbox_pos.y + _edit_box_info.height + 10, width, _insert_info.height, "ui/common/nine_grid_bg.png", 500, 500)
	----------
	--basepanel:addChild(self.inset_info_bg)
	-- self.left_panel:addChild(self.self_pos.view)
	-- self.left_panel:addChild(self.face.view)
	self.left_panel:addChild(self.delete.view)
	self.left_panel:addChild(self.send.view)
	-- self.left_panel:addChild(editbox_bg)
	-- self.left_panel:addChild(info_bg)
end
------------------
------------------ main info
local _exit_button_info				= {width = 62, height = 56, image = {UIPIC_COMMOM_008, UIPIC_COMMOM_008} }
local _min_button_info				= {width = 62, height = 56, image = {UIPIC_XZWIN_001, UIPIC_XZWIN_001} }
------------------
local function create_private_chat(self, width, height)
	----------
	-- require "UI/component/Button"
	-- require "UI/component/Label"
	----------
	self.title = ZLabel:create( nil, "", 0, 378 , 16)
	----------退出按钮
	self.exit_btn = ZButton:create( nil, _exit_button_info.image, nil, 0, 0, -1, -1)
	local exit_size = self.exit_btn:getSize()
	self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height )
	local exit_pos = self.exit_btn:getPosition()

	----------最小化按钮
	self.min_btn = ZButton:create( nil, _min_button_info.image, nil, 0, 0, -1, -1)
	local min_size = self.min_btn:getSize()
	self.min_btn:setPosition( 450, height - min_size.height )
	----------
	self.view:addChild(self.title.view)
	self.view:addChild(self.exit_btn.view)
	self.view:addChild(self.min_btn.view)
end
------------------
------------------
function ChatOther:__init(window_name, texture, isgrid, width, height)
	create_private_chat( self, width, height)

	-- 底板
	local bgPanel = CCBasePanel:panelWithFile(37, 18, 517, 536, UIPIC_GRID_nine_grid_bg3, 500, 500)
	self.view:addChild(bgPanel)

	-- local right_panel = right_panel_fun()
	-- self.view:addChild(right_panel)
	local left_panel = create_left_panel(self, 47, 28 ,310, 516)
	--local right_panel_size = {width = 132, height = 346}
	--local left_panel_size = { twidth = width - right_panel_size.width, theight = height - right_panel_size.height }
	-- if left_panel_size.twidth < 1 then
	-- 	left_panel_size.twidth = 1
	-- end
	-- if left_panel_size.theight < 1 then
	-- 	left_panel_size.theight = 1 
	-- end
	
	--self.view:addChild(left_panel)
end
------------------
------------------设置输入框内容
function ChatOther:set_insert_text(info)
	if self.editbox ~= nil then
		self.editbox:setText(info)
	end
end
------------------
------------------插入输入框内容
function ChatOther:set_insert_info(info)
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
function ChatOther:get_insert_info()
	if self.editbox ~= nil then
		return self.editbox:getText()
	end
end
------------------
------------------取得输入框发送内容 
function ChatOther:get_insert_text_info()
	if self.editbox ~= nil then
		return self.editbox:getTextInfo(ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
	end
end
------------------
------------------设置信息框内容
function ChatOther:set_dialog_info(info)
	print("self.inset_info", self.inset_info)
	if self.inset_info ~= nil then
		local hyperhead = UIManager:find_window("hyper_link"):get_script_head()
		self.inset_info:setText(info, hyperhead)
	end
end
------------------
------------------
-- function ChatOtherWin:set_send_function(userFunction)
-- 	if self.send ~= nil then
-- 		self.send:setTouchClickFun(userFunction)
-- 	end
-- end
-- ------------------
-- ------------------
-- function ChatOther
