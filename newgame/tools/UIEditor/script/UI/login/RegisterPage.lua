-- RegisterPage.lua
-- created by lyl on 2013-2-26
-- 注册窗口  

super_class.RegisterPage()

function RegisterPage:__init( window_name,window_info )
    self.view = CCBasePanel:panelWithFile( window_info.x, window_info.y, window_info.width, window_info.height, window_info.texture, 500, 500 )
    safe_retain(self.view)

    -- 用户名
    local function user_edit_func( eventType )
        -- print("user_edit_func", eventType, KEYBOARD_ATTACH )
        if eventType == KEYBOARD_ATTACH then
            self:check_enter_string(  )
        end 
        return true
    end
    self.view:addChild( CCZXImage:imageWithFile( 145, 196, -1, -1, "ui2/login/yonghuming.png" ) )
    self.view:addChild( CCZXImage:imageWithFile( 270 + 20, 233 - 40, 225, 47, "ui2/login/bg_06.png", 500, 500 ) )
    self.name_enter_frame = CCZXEditBox:editWithFile( 270 + 30, 233 - 40, 225 - 20, 47, "", 26, 16, EDITBOX_TYPE_NORMAL )
    self.view:addChild( self.name_enter_frame )
    self.name_enter_frame:registerScriptHandler( user_edit_func )
    -- 提示
    self.notice_1 = UILabel:create_lable_2( LangGameString[1341], 523, 209, 16, ALIGN_LEFT ) -- [1341]="5-20字符,可输入数字和字母"
    self.view:addChild( self.notice_1 )

    -- 密码
    local function password_edit_func( eventType )
        -- print("password_edit_func", eventType, KEYBOARD_ATTACH )
        if eventType == KEYBOARD_ATTACH then
            self:check_enter_string(  )
        end 
        return true
    end
    self.view:addChild( CCZXImage:imageWithFile( 145, 143, -1, -1, "ui2/login/mima.png" ) )
    self.view:addChild( CCZXImage:imageWithFile( 270 + 20, 185 - 15 - 30, 225, 47, "ui2/login/bg_06.png", 500, 500 ) )
    self.password_enter_frame = CCZXEditBox:editWithFile( 270 + 30, 185 - 15 - 30, 225 - 20, 47, "", 26, 16, EDITBOX_TYPE_PASSWORD, 500, 500)
    self.view:addChild( self.password_enter_frame )
    self.password_enter_frame:registerScriptHandler( password_edit_func )
    -- self.view:addChild( UILabel:create_lable_2( "5-20字符,可输入数字和字母", 523, 156, 16, ALIGN_LEFT ) )
    -- 提示
    self.notice_2 = UILabel:create_lable_2( LangGameString[1341], 523, 156, 16, ALIGN_LEFT ) -- [1341]="5-20字符,可输入数字和字母"
    self.view:addChild( self.notice_2 )

    -- 确认密码
    local function password_edit2_func( eventType )
        -- print("password_edit2_func", eventType, KEYBOARD_ATTACH )
        if eventType == KEYBOARD_ATTACH then
            self:check_enter_string(  )
        end 
        return true
    end
    self.view:addChild( CCZXImage:imageWithFile( 145, 90, -1, -1, "ui2/login/querenmima.png" ) )
    self.view:addChild( CCZXImage:imageWithFile( 270 + 20, 87, 225, 47, "ui2/login/bg_06.png", 500, 500 ) )
    self.password_enter_frame2 = CCZXEditBox:editWithFile( 270 + 30, 87, 225 - 20, 47, "", 26, 16, EDITBOX_TYPE_PASSWORD, 500, 500)
    self.view:addChild( self.password_enter_frame2 )
    self.password_enter_frame2:registerScriptHandler( password_edit2_func )
    -- self.view:addChild( UILabel:create_lable_2( "5-20字符,可输入数字和字母", 523, 103, 16, ALIGN_LEFT ) )
    -- 提示
    self.notice_3 = UILabel:create_lable_2( "", 523, 103, 16, ALIGN_LEFT )
    self.view:addChild( self.notice_3 )
    
    -- 返回登录
    local function back_but_CB(  )
        -- print("注册")
        RoleModel:change_login_page( "login" )
    end
    local back_but = UIButton:create_button_with_name( 65, 30, -1, -1, "ui2/login/back_but.png", "ui2/login/back_but.png", nil, "", back_but_CB )
    UIButton:set_button_image_name( back_but.view, -35, -15, -1, -1, "ui2/login/fanhuidenglu.png"  )
    self.view:addChild( back_but.view )

    -- 创建 确定 继续
    local function create_user(  )
        -- 记录玩家发送登录请求
        if BISystem.register then
            BISystem:register()
        end

        if self:check_enter_string(  ) then
            local account  = self.name_enter_frame:getText()
            local password = self.password_enter_frame:getText()
            RoleModel:request_create_account( account, password )
        end
    end
    local create_but = UIButton:create_button_with_name( 665, 30, -1, -1, "ui2/login/enter_but.png", "ui2/login/enter_but.png", nil, "", create_user )
    UIButton:set_button_image_name( create_but.view, -35, -15, -1, -1, "ui2/login/chuangjianzhanghao.png"  )
    self.view:addChild( create_but.view )
end

-- 检查输入是否合法  ( 当前没有离开编辑框事件，有进入事件。所以每个进入的时候都做一次判断)
function RegisterPage:check_enter_string(  )
    -- 用户名验证
    local user_name = self.name_enter_frame:getText()
    local check_ret, false_word = RoleModel:check_user_name_str( user_name )
    if not check_ret then 
        self.notice_1:setString( false_word )
        return false
    else
        self.notice_1:setString( "" )
    end

    -- 密码1
    local password_1 = self.password_enter_frame:getText()
    check_ret, false_word = RoleModel:check_password_right( password_1 )
    -- print(check_ret, false_word, password_1, "password_1")
    if not check_ret then 
        self.notice_2:setString( false_word )
        return false
    else
        self.notice_2:setString( "" )
    end

    -- 密码2
    local password_2 = self.password_enter_frame2:getText()
    if password_1 ~= password_2 then 
        self.notice_3:setString( LangGameString[1342] ) -- [1342]="#cff0000密码不一致"
        return false
    else
        self.notice_3:setString( "" )
    end

    check_ret, false_word = RoleModel:check_password_right( password_2 )
    -- print(check_ret, false_word, password_2, "password_2")
    if not check_ret then 
        self.notice_3:setString( false_word )
        return false
    else
        self.notice_3:setString( "" )
    end

    return true
end

-- 更新
function RegisterPage:update( update_type )
    if update_type == "create_result_account" then
        local result_str = RoleModel:get_create_result_str(  )
        self.notice_1:setString( result_str )
    elseif update_type == "create_error_account" then 
        local result_str = RoleModel:get_create_result_str(  )
        self.notice_1:setString( result_str )
    end
end


function RegisterPage:destroy(  )
    safe_release(self.view)
end

-- 隐藏  
function RegisterPage:hide_to_left(  )
    -- print("隐藏 RegisterPage:hide_to_life")
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( -800, 0 ));          -- 动画
    self.view:runAction( moveto );
end

-- 显示
function RegisterPage:show_to_center(  )
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( 0, 0 ));          -- 动画
    self.view:runAction( moveto );
end
