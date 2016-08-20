-- WriteMailPage.lua  
-- created by lyl on 2013-3-12
-- 邮件系统 读取邮件页 

super_class.WriteMailPage(Window)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

function WriteMailPage:create(  )
    local temp_panel_info = { texture = "", x = 46, y = 22, width = 322, height = 358 }
	return WriteMailPage( "WriteMailPage", "", true, 420, 520 )
end

function WriteMailPage:__init( window_name, texture_name )
    local panel = self.view

    -- 背景
    local bg = CCZXImage:imageWithFile( 0, 3, 420, 520-1, UILH_COMMON.normal_bg_v2, 500, 500 )
    panel:addChild(bg)

    panel:addChild( UILabel:create_lable_2( Lang.mail[10], 16, 480, 18, ALIGN_LEFT ) ) -- [1443]="收件人: "

    -- 收件人输入
    local edit_bg_config = {x = 100, y = 469, w = 250, h = 36}
    local edit_bg = CCZXImage:imageWithFile( edit_bg_config.x, edit_bg_config.y, edit_bg_config.w, edit_bg_config.h, UILH_COMMON.bg_02, 500, 500 )
    panel:addChild( edit_bg )
    self.addressee_edit = CCZXEditBox:editWithFile( edit_bg_config.x+4, edit_bg_config.y+5, edit_bg_config.w-10, edit_bg_config.h-8, nil, 10, 16, EDITBOX_TYPE_NORMAL, 500, 500)
    panel:addChild( self.addressee_edit )

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
    self.addressee_edit:registerScriptHandler( edit_box_function )

    self.pay_mail_lable = UILabel:create_lable_2(Lang.mail[11], 16, 440, 16, ALIGN_LEFT ) -- [1444]="邮资: #cffff00200仙币"
    panel:addChild( self.pay_mail_lable )

    -- 导入好友按钮
    -- local function friend_but_CB( )
	   --  
    -- end
    -- local friend_but = UIButton:create_button_with_name( 192 , 267, 113, 35, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "", friend_but_CB )
    -- friend_but:addChild( UILabel:create_lable_2( "导入好友", 56, 12, 16, ALIGN_CENTER ) )
    -- panel:addChild( friend_but )

    -- 内容输入区域的背景
    local content_edit_bg = CCZXImage:imageWithFile( 13, 78, 390, 345, UILH_COMMON.bottom_bg, 500, 500 )
    panel:addChild(content_edit_bg)

    -- self.content_edit = CCZXEditBox:editWithFile( 0, 40, 315, 215, "", 100, 16, EDITBOX_TYPE_NORMAL, 500, 500)
    self.content_edit = CCZXEditBoxArea:editWithFile( 18, 83, 380, 335, "", 100, 16 )
    panel:addChild( self.content_edit )
    self.content_edit:registerScriptHandler( edit_box_function )

    -- 清空按钮
    local function clear_but_CB()
        self.content_edit:setText( "" )
    end
    local clear_btn = ZButton:create(panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, clear_but_CB, 53, 18,-1,-1, 1)
    MUtils:create_zxfont(clear_btn,Lang.mail[12],121/2,20,2,16);     --Lang.mail[12]= 清空
--    MUtils:create_common_btn( panel, LangGameString[1445], clear_but_CB, 4 , -6 ) -- [1445]="清空"
    -- local clear_but = UIButton:create_button_with_name( 2 , 0, 73, 35, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "", clear_but_CB )
    -- clear_but:addChild( UILabel:create_lable_2( "清空", 36, 12, 16, ALIGN_CENTER ) )
    -- panel:addChild( clear_but )

    -- 发送按钮
    local function send_but_CB()
        local mail_content = self.content_edit:getText()
        print("mail_content:::", mail_content )
        MailModel:send_mail( self.addressee_edit:getText(), mail_content, 0, {} )
    end
    local send_btn = ZButton:create(panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, send_but_CB, 243, 18,-1,-1, 1)
    MUtils:create_zxfont(send_btn,Lang.mail[13],121/2,20,2,16);     --Lang.mail[13]= 发送
--    MUtils:create_common_btn( panel, LangGameString[732], send_but_CB, 255 , -6 ) -- [732]="发送"
    -- local send_but = UIButton:create_button_with_name( 234 , 0, 73, 35, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "", send_but_CB )
    -- send_but:addChild( UILabel:create_lable_2( "发送", 36, 12, 16, ALIGN_CENTER ) )
    -- panel:addChild( send_but )

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)
end

-- 更新收件人名称为当前打开邮件发件人
function WriteMailPage:update_addressee(  )
    local current_mail = MailModel:get_current_mail(  )
    self.addressee_edit:setText( current_mail.addressor_name )
end

-- 清空所有可输入区域
function WriteMailPage:clear_all(  )
    self.content_edit:setText( "" )
    self.addressee_edit:setText( "" )
end

function WriteMailPage:update( update_type )
    if update_type == "reply" then
        self:update_addressee(  )
    elseif update_type == "clear_all" then
        self:clear_all(  )
    end
end


------------------弹出/关闭 键盘时将整个WriteMailPage的y坐标的调整
function WriteMailPage:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible = true;
    local win = UIManager:find_visible_window("mail_win");
    -- local win_info = UIManager:get_win_info("mail_win")
    if win then
        if keyboard_h == 162 then--ip eg
            win:setPosition(_refWidth(0), 360);
        elseif keyboard_h == 198 then---ip cn
            win:setPosition(_refWidth(0),360+40);
        elseif keyboard_h == 352 then --ipad eg
            win:setPosition(_refWidth(0), 360);
        elseif keyboard_h == 406 then --ipad cn
            win:setPosition(_refWidth(0), 360);
        end
    end
end
function WriteMailPage:keyboard_will_hide(  )
    self.keyboard_visible = false;
    local win = UIManager:find_visible_window("mail_win");
    -- local win_info = UIManager:get_win_info("mail_win")
    if win then
        win:setPosition(_refWidth(0),_refHeight(0.5));
    end
end

-------------------- 手动关闭键盘
function WriteMailPage:hide_keyboard(  )

    if self.addressee_edit then
        self.addressee_edit:detachWithIME();
    end
    if self.content_edit then
        self.content_edit:detachWithIME();
    end
end

function WriteMailPage:destroy(  )
    self:hide_keyboard()
    Window.destroy(self)
end

