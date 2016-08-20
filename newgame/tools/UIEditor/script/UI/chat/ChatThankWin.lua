-----friendadd.lua
-----HJH
-----2013-2-17
-----------鲜花感谢界面
super_class.ChatThankWin(Window)
-----------
-----------
local window_size								= {width = 960, height = 640}
------------------
function ChatThankWin:create_chat_flower(width, height)
	------------------
	--local _flower_num_info 		= {width = 22, height = 22, gapSize = 1, text = {"1朵", "9朵", "99朵", "999朵"}, image = {"ui/common/common_toggle_n.png", "ui/common/common_toggle_s.png"}}
	--local _send_type_info		= {width = 22, height = 22, gapSize = 1, text = {"签名赠送", "匿名赠送"}, image = {"ui/common/common_toggle_n.png", "ui/common/common_toggle_s.png"} }
	--local _send_info 			= {width = 87, height = 38, image = {"ui/chat/send_flower_normal.png", "ui/chat/send_flower_select.png"} }
	--local _exit_info			= {width = 43, height = 42, image = {"ui/chat/send_flower_close_normal.png", "ui/chat/send_flower_close_select.png"} }
	--xiehande  通用按钮修改  --btn_lv2.png ->button2.png
	local _thank_info			= { width = 99, height = 53, text = Lang.chat.private[8], image = {UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s} } -- Lang.chat.private[8]="谢谢"
	local _resend_flower		= { width = 99, height = 53, text = Lang.chat.private[9], image = {UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s} } -- Lang.chat.private[9]="回赠"
	local _mul_text_info		= { width = 190, height = 86}
	local _exit_info			= { width = 43, height = 42, image = {UIPIC_COMMOM_008, UIPIC_COMMOM_008} }
	-------------------
	-- require "UI/component/TextCheckBox"
	-- require "UI/component/RadioButtonGroup"
	-- require "UI/component/Button"
	-- require "UI/component/Label"
	-- require "UI/component/Image"
	-- require "UI/component/Dialog"
	-- require "model/ChatModel/ChatThankModel"
	-------------------对话框
	self.show_info = Dialog:create( nil, 45, 240, 320, 100, ADD_LIST_DIR_UP, 200)
	self.show_info.view:setLineEmptySpace(6)
	self.show_info:setAnchorPoint(0, 1)
	-------------------退出按钮
	self.exit_btn = ZButton:create( nil, _exit_info.image, nil, 0, 0,-1, -1)
	self.exit_btn:setPosition(363,278)
	self.exit_btn:setTouchClickFun(ChatThankModel.exit_btn_fun)
	-------------------感谢按钮
	self.thank_btn = ZTextButton:create( nil, _thank_info.text, _thank_info.image, nil, 60, 23, _thank_info.width, _thank_info.height )
	self.thank_btn:setTouchClickFun(ChatThankModel.thank_btn_fun)
	-------------------回赠按钮
	self.resend_btn = ZTextButton:create( nil, _resend_flower.text, _resend_flower.image, nil, 254, 23, _resend_flower.width, _resend_flower.height )
	self.resend_btn:setTouchClickFun(ChatThankModel.resend_btn_fun)
	-------------------
	local bg2 = ZImage:create( nil, UILH_COMMON.bottom_bg, 28, 82, 360, 180, nil, window_size.width, window_size.width)

	self.view:addChild(bg2.view)
	self.view:addChild(self.show_info.view)
	self.view:addChild(self.thank_btn.view)
	self.view:addChild(self.resend_btn.view)
	self.view:addChild(self.exit_btn.view)
	-------------------
	self.view:setPosition(270,160);
    self:create_title()
end

function ChatThankWin:create_title(  )
    --标题背景
    local title_bg = CCBasePanel:panelWithFile( 0, 0, -1, 60, UIPIC_COMMOM_title_bg )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( self.view:getSize().width - title_bg_size.width ) / 2, self.view:getSize().height - title_bg_size.height/2-14)
    local title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  UILH_NORMAL.title_tips  )
    title:setAnchorPoint(0.5,0.5)
    title_bg:addChild( title )
   	self.view:addChild( title_bg )
end
-------------------
-------------------
function ChatThankWin:__init(window_name, texture_name, is_grid, width, height)
	self:create_chat_flower(width, height)
end
-------------------
-------------------初始化感谢界面
function ChatThankWin:reinit_info(name, number)
	if self.show_info ~= nil then
		local tempinfo = string.format( Lang.chat.private[10],name, number)  -- Lang.chat.private[10]="【#cffd700%s#cffffff】被你的魅力所倾到,送上【%s朵玫瑰】,无比幸福的你要怎样答谢呢?"
		self.show_info:setText("")
		self.show_info:setText(tempinfo)
	end
end
