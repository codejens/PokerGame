-- ModifyPasswordWin.lua  
-- created by lyl on 2013-6-5
-- 委托主窗口  modify_password_win

super_class.ModifyPasswordWin(Window)

function ModifyPasswordWin:__init( window_name, texture_name )

    local bgPanel = CCBasePanel:panelWithFile( 400 - 389 / 2 - 35, 0, 389, 429, UIResourcePath.FileLocate.common .. "bg_blue.png");                     --背景
    self.view:addChild( bgPanel )

    -- local bgPanel_2 = CCZXImage:imageWithFile( 80, 388, -1, -1, UIResourcePath.FileLocate.common .. "win_title1.png");             --头部
    -- bgPanel:addChild( bgPanel_2 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 144 - 10, 400, -1, -1, UIResourcePath.FileLocate.passwordSet .. "title_xiugaimima.png");        --标题名称
    -- bgPanel:addChild( bgPanel_3 )

    local login_info = RoleModel:get_login_info(  )
    local user_name = login_info.user_name
    self.notice_1 = UILabel:create_lable_2( LangGameString[1647]..user_name..LangGameString[1648], 389 / 2, 348, 20, ALIGN_CENTER ) -- [1647]="正在修改#cffff00【" -- [1648]="】#cffffff的密码："
    bgPanel:addChild( self.notice_1 )

    -- 原密码
    local function password_edit_func( eventType )
        if eventType == KEYBOARD_ATTACH then
            -- self:check_enter_string(  )
        end 
        return true
    end
    bgPanel:addChild( CCZXImage:imageWithFile( 24, 268, -1, -1, UIResourcePath.FileLocate.passwordSet .. "word_yuanmima.png" ) )
    bgPanel:addChild( CCZXImage:imageWithFile( 169, 265, 225 - 50, 47, UIResourcePath.FileLocate.common .. "bg_06.png", 500, 500 ) )
    self.password_enter_frame = CCZXEditBox:editWithFile( 179, 265, 225 - 20 - 50, 47, "", 26, 16, EDITBOX_TYPE_PASSWORD, 500, 500)
    bgPanel:addChild( self.password_enter_frame )
    self.password_enter_frame:registerScriptHandler( password_edit_func )

    -- 新密码
    local function new_password_edit_func( eventType )
        if eventType == KEYBOARD_ATTACH then
            -- self:check_enter_string(  )
        end 
        return true
    end
    bgPanel:addChild( CCZXImage:imageWithFile( 24, 215, -1, -1, UIResourcePath.FileLocate.passwordSet .. "word_xinmima.png" ) )
    bgPanel:addChild( CCZXImage:imageWithFile( 169, 212, 225 - 50, 47, UIResourcePath.FileLocate.common .. "bg_06.png", 500, 500 ) )
    self.new_password_enter_frame = CCZXEditBox:editWithFile( 179, 212, 225 - 20 - 50, 47, "", 26, 16, EDITBOX_TYPE_PASSWORD, 500, 500)
    bgPanel:addChild( self.new_password_enter_frame )
    self.new_password_enter_frame:registerScriptHandler( new_password_edit_func )

    -- 确认密码
    local function re_password_edit_func( eventType )
        if eventType == KEYBOARD_ATTACH then
            -- self:check_enter_string(  )
        end 
        return true
    end
    bgPanel:addChild( CCZXImage:imageWithFile( 24, 162, -1, -1, UIResourcePath.FileLocate.passwordSet .. "word_chongfumima.png" ) )
    bgPanel:addChild( CCZXImage:imageWithFile( 169, 159, 225 - 50, 47, UIResourcePath.FileLocate.common .. "bg_06.png", 500, 500 ) )
    self.re_password_enter_frame = CCZXEditBox:editWithFile( 179, 159, 225 - 20 - 50, 47, "", 26, 16, EDITBOX_TYPE_PASSWORD, 500, 500)
    bgPanel:addChild( self.re_password_enter_frame )
    self.re_password_enter_frame:registerScriptHandler( re_password_edit_func )

    -- 提示信息
    self.notice_2 = UILabel:create_lable_2( LangGameString[1649], 389 / 2, 119, 16, ALIGN_CENTER ) -- [1649]="密码5-20字符,可输入数字和字母"
    bgPanel:addChild( self.notice_2 )

    -- 确定按钮
    local function apply_but_CB(  )
    	if self:check_enter_string(  ) then
            local pre_password = self.password_enter_frame:getText()
            local new_password = self.new_password_enter_frame:getText()
            PasswordModel:request_modify_password( pre_password, new_password )
        end
    end
    self.apply_but = UIButton:create_button_with_name( 80, 50, -1, -1, UIResourcePath.FileLocate.common .. "tishi_button.png", UIResourcePath.FileLocate.common .. "tishi_button.png", nil, "", apply_but_CB )
    self.apply_but:addChild( CCZXImage:imageWithFile( 33, 10, -1, -1, UIResourcePath.FileLocate.normal .. "queding.png" ) )
    bgPanel:addChild( self.apply_but )

    -- 取消
    local function cancel_but_CB(  )
    	UIManager:hide_window( "modify_password_win" )
    end
    self.cancel_but = UIButton:create_button_with_name( 223, 50, -1, -1, UIResourcePath.FileLocate.common .. "tishi_button.png", UIResourcePath.FileLocate.common .. "tishi_button.png", nil, "", cancel_but_CB )
    self.cancel_but:addChild( CCZXImage:imageWithFile( 33, 10, -1, -1, UIResourcePath.FileLocate.normal .. "quxiao.png" ) )
    bgPanel:addChild( self.cancel_but )

    -- 关闭按钮
    -- local function close_but_CB( )
    --     UIManager:hide_window( "modify_password_win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = bgPanel:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- bgPanel:addChild( close_but )
end

-- 检查输入是否合法  ( 当前没有离开编辑框事件，有进入事件。所以每个进入的时候都做一次判断)
function ModifyPasswordWin:check_enter_string(  )
    -- 原密码验证
    local pre_password = self.password_enter_frame:getText()
    if pre_password == "" then 
        self.notice_2:setString( LangGameString[1650] ) -- [1650]="#cff0000原密码错误"
        return false
    end
    local check_ret, false_word = PasswordModel:check_pre_password( pre_password )
    if not check_ret or pre_password == "" then 
        self.notice_2:setString( LangGameString[1651]..false_word ) -- [1651]="#cff0000原密码错误："
        return false
    else
        self.notice_2:setString( "" )
    end

    -- 新密码1
    local new_password_1 = self.new_password_enter_frame:getText()
    check_ret, false_word = PasswordModel:check_password_right( new_password_1 )
    if not check_ret then 
        self.notice_2:setString( LangGameString[1652]..false_word ) -- [1652]="#cff0000新密码错误："
        return false
    else
        self.notice_2:setString( "" )
    end

    -- 新密码2
    local new_password_2 = self.re_password_enter_frame:getText()
    if new_password_1 ~= new_password_2 then 
        self.notice_2:setString( LangGameString[1653] ) -- [1653]="#cff0000新密码不一致"
        return false
    else
        self.notice_2:setString( "" )
    end

    check_ret, false_word = PasswordModel:check_password_right( new_password_2 )
    if not check_ret then 
        self.notice_2:setString( LangGameString[1654]..false_word ) -- [1654]="#cff0000重复确认密码错误："
        return false
    else
        self.notice_2:setString( "" )
    end

    return true
end


-- 外部静态调用
function ModifyPasswordWin:update_win( update_type )
    local win = UIManager:find_visible_window("modify_password_win")
    if win then 
        win:update( update_type )
    end
end

function ModifyPasswordWin:update( update_type )
    if update_type == "modify_result" then 
        local modify_word = PasswordModel:get_modify_result_word(  )
        self.notice_2:setString( modify_word )
    elseif update_type == "all" then 
        self.notice_2:setString( LangGameString[1649] ) -- [1649]="密码5-20字符,可输入数字和字母"
        self.password_enter_frame:setText( "" )
        self.new_password_enter_frame:setText( "" )
        self.re_password_enter_frame:setText( "" )
    end
end

function ModifyPasswordWin:active( if_active )
    if if_active then
        self:update( "all" ) 
    end
end

function ModifyPasswordWin:destroy()
    Window.destroy(self)
end
