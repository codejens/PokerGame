-- LoginPage.lua 
-- created by aXing on 2013-2-26
-- 登录页

super_class.LoginPage()

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight


local DialogDepth = 1024
local _name = CCUserDefault:sharedUserDefault():getStringForKey("user_name")  --默认用户名。

local STRING_OK       = LangGameString[479] -- [479]='确认'
local STRING_EMPTY_USR_PW = {LangGameString[1339], LangGameString[1340] } -- [1339]='#cffff00账号或密码为空' -- [1340]='请重新输入'
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight
function LoginPage:__init( window_name, window_info )

    self.view = CCBasePanel:panelWithFile( window_info.x, window_info.y, window_info.width, window_info.height, window_info.texture_name, 500, 500 )
    safe_retain(self.view)

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)

    self.dialogBack_bg = CCBasePanel:panelWithFile(_refWidth(0.5), _refHeight(0.5)-25, 420, 275, "")
    self.dialogBack_bg:setAnchorPoint(0.5,0.5)
    self.view:addChild(self.dialogBack_bg)

    ------------------------
    self.dialogBack = CCBasePanel:panelWithFile(0, 20, 420, 255, UILH_COMMON.style_bg, 600, 600 )
    -- self.dialogBack:setAnchorPoint(0.5,0.5)
    self.dialogBack_bg:addChild(self.dialogBack)
    ------------------------
    ------------------------
    --local temp_bg = ZImage:create( temp_bg, "ui2/login/grid_15.png", 209, 149, 380, 240, nil, 600, 600 )
    --temp_bg.view:setAnchorPoint(0.5,0.5)
    ------------------------

    -- local spr = CCSprite:spriteWithFile('ui2/login/reg_title.png')
    -- self.dialogBack:addChild(spr)
    -- spr:setPosition(221,305)
    -- spr:setTag(0)

    -- local spr = CCSprite:spriteWithFile('ui2/login/kuwu.png')
    -- self.dialogBack:addChild(spr)
    -- spr:setPosition(313,322)
    -- spr:setTag(0)

    -- 名称输入
    -- self.enter_name_lable = UILabel:create_lable_2( "用户名", 260 + 20, 235 - 30, 20, ALIGN_RIGHT )
    -- self.view:addChild( self.enter_name_lable )
    self.dialogBack:addChild( CCZXImage:imageWithFile( 40, 155, -1, -1, "ui2/login/lh_accout.png" ) )
    self.dialogBack:addChild( CCZXImage:imageWithFile( 110, 150, 190, 40, UILH_COMMON.bg_03, 500, 500 ) )
    self.name_enter_frame = CCZXEditBox:editWithFile( 120, 153, 190 - 25, 38, "", 26, 16, EDITBOX_TYPE_NORMAL )
    self.dialogBack:addChild( self.name_enter_frame )
    self.name_enter_frame:setText( _name )

    self.is_keyboard_show=false

    -- 账号输入框的事件
    local function account_editBox_msg_func( eventType, arg, msgid, selfItem )
        if eventType == nil then
            return
        elseif eventType == KEYBOARD_FINISH_INSERT then
            -- 密码输入框成为第一事件响应
            self:hide_keyboard()
        elseif  eventType == KEYBOARD_WILL_SHOW then 
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height )

        elseif  eventType == KEYBOARD_WILL_HIDE then 
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height )
        end
        return true
    end
    self.name_enter_frame:registerScriptHandler(account_editBox_msg_func)


    -- 切换账号
    local function qiehuan_but_CB(  )
        -- self.name_enter_frame:setText( "" )
        self:show_user_list(  )
    end
    local switch_btn = ZButton:create( self.dialogBack, UILH_COMMON.button6_4, qiehuan_but_CB, 305, 150 )
    local switch_txt = UILabel:create_lable_2( LH_COLOR[2].."切换账号", 10, 15, 14, ALIGN_LEFT )
    switch_btn.view:addChild(switch_txt)
    -- local qiehuan_but = UIButton:create_button_with_name( 513 + 20, 233 - 40, -1, -1, "ui2/login/qiehuan_but_bg.png", "ui2/login/qiehuan_but_bg.png", nil, "", qiehuan_but_CB )
    -- self.view:addChild( qiehuan_but )

    -- 密码输入
    -- local enter_password_lable = UILabel:create_lable_2( "密  码", 260 + 20, 185 - 3 - 30, 20, ALIGN_RIGHT )
    -- self.view:addChild( enter_password_lable )
    self.dialogBack:addChild( CCZXImage:imageWithFile( 40, 87, -1, -1, "ui2/login/lh_pwd.png" ) )
    self.dialogBack:addChild( CCZXImage:imageWithFile( 110, 84, 190, 40, UILH_COMMON.bg_03, 500, 500 ) )
    self.password_enter_frame = CCZXEditBox:editWithFile( 120, 87, 190 - 25, 38, "", 26, 16, EDITBOX_TYPE_PASSWORD, 500, 500)
    
    require "model/RoleModel"
    self.password_changed = false

    local function editBoxMessageFun(eventType, arg, msgid, selfItem)
        if eventType == nil then
            return 
        elseif eventType == KEYBOARD_FINISH_INSERT then
            self:hide_keyboard()
            if self.login_func ~= nil then
                self.login_func();
            end
        elseif  eventType == KEYBOARD_ATTACH then 
            self.password_changed = true
        elseif  eventType == KEYBOARD_CLICK then 
            self.password_changed = true
            -- self.password_enter_frame:setText( "" )
        elseif  eventType == KEYBOARD_BACKSPACE then
            self.password_changed = true
        elseif  eventType == KEYBOARD_WILL_SHOW then 
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height )
        elseif  eventType == KEYBOARD_WILL_HIDE then 
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height )
        end
        return true
    end
    self.password_enter_frame:registerScriptHandler(editBoxMessageFun)

    self.dialogBack:addChild( self.password_enter_frame )

    -- -- 注册
    -- local function register_but_CB(  )
    --     RoleModel:change_login_page( "register" )
    -- end
    -- ZImageButton:create( self.view, "ui/common/button_bg3_s.png", "ui2/login/zhuce.png", register_but_CB, 65, 30 )
    -- local register_but = UIButton:create_button_with_name( 65, 30, -1, -1, "ui2/login/back_but.png", "ui2/login/back_but.png", nil, "", register_but_CB )
    -- UIButton:set_button_image_name( register_but, -35, -15, -1, -1, "ui2/login/zhuce.png"  )
    -- self.view:addChild( register_but )

    local pw = RoleModel:getPassword( _name )
    if pw then
        self.password_enter_frame:setText(pw)
    end

    -- 快速游戏
    local function quick_but_CB(  )
        -- 如果点击菜单存在，则删掉
        if self.menu then
            self.menu:removeFromParentAndCleanup(true)
            self.menu = nil
        end
        -- 记录快速登录用户
        if BISystem.fat_register then
            BISystem:fat_register()
        end
         RoleModel:request_quick_play(  )
        
    end
    -- ZImageButton:create( self.dialogBack,  UILH_COMMON.btn4_nor, 
    --                                        "ui2/login/easy_reg.png", quick_but_CB, 52, 35 )   --219, 35 
    local quick_btn = ZTextButton:create(self.dialogBack_bg, LH_COLOR[2].."一键注册", UILH_COMMON.btn4_nor, quick_but_CB, 65, 40, -1, -1, 1) --"一键注册"
    quick_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    -- quick_btn.view:setCurState( CLICK_STATE_DISABLE )
    -- local quick_but = UIButton:create_button_with_name( 360, 30, -1, -1, "ui2/login/down_but.png", "ui2/login/down_but.png", nil, "", quick_but_CB )
    -- UIButton:set_button_image_name( quick_but, -35, -15, -1, -1, "ui2/login/but_kuaisuyouxi.png"  )
    -- self.view:addChild( quick_but )

    -- 登录
    local function login_but_CB(  )
        -- 如果点击菜单存在，则删掉
        if self.menu then
            self.menu:removeFromParentAndCleanup(true)
            self.menu = nil
        end

        -- 记录登录
        if BISystem.login then
            BISystem:login()
        end
        local tmepinfo = self.name_enter_frame:getText()
        local tmppass  = self.password_enter_frame:getText()

        if tmepinfo == '' or tmppass == '' then
            if self.inputErrorPop == nil then
                local root = ZXLogicScene:sharedScene()
                self.inputErrorPop =   PopupNotify( root:getUINode(),
                                                    DialogDepth, STRING_EMPTY_USR_PW,
                                                    STRING_OK,nil,
                                                    POPUP_OK,
                                                    function(...) self.inputErrorPop = nil end )
            end

        else
            PlatformInterface:onLoginResult(0, { ['uid'] = tmepinfo, 
                                                 ['pwd'] = tmppass,
                                                 ['password_changed'] = self.password_changed
                                                } 
                                            )
            -- self.password_changed = false
            self:hide_keyboard()

        end
    end

    self.login_func = login_but_CB;

    -- ZImageButton:create( self.dialogBack, "ui/common/btn_other.png", 
    --                                       "ui2/login/login_btn_label.png", login_but_CB, 219, 35 )  -- 52, 35

    ZTextButton:create(self.dialogBack_bg, LH_COLOR[2] .. "登  录", UILH_COMMON.btn4_blue, login_but_CB, 230, 40, -1, -1, 1) --"一键注册"
    -- local login_but = UIButton:create_button_with_name( 665, 30, -1, -1, "ui2/login/enter_but.png", "ui2/login/enter_but.png", nil, "", login_but_CB )

    -- UIButton:set_button_image_name( login_but, -35, -15, -1, -1, "ui2/login/denglu.png"  )
    -- self.view:addChild( login_but )

    -- 声音
    -- self:sound_switch(  )

    --self.enter_name_lable = nil
end



-- 创建一个用户名称菜单
function LoginPage:create_user_list(  )
    require "UI/component/DynamicMenu"
    local menu_top_x       = 373
    local menu_top_y       = 190
    local name_t = RoleModel:get_user_name_list(  )
    local function item_callback( index )
        local name_str = name_t[ index ] or ""
        self.name_enter_frame:setText( name_str )
        -- 密码  -- 每次重选账号，都重置密码，并且标识为密码从保存列表获取
        local pw = RoleModel:getPassword( name_str )
        if pw  then
            self.password_enter_frame:setText(pw)
        end
        self.password_changed = false        
        if self.menu_bg then
            self.view:removeChild( self.menu_bg, true )  
            self.menu_bg = nil
        end
        if self.menu then
            self.menu:removeFromParentAndCleanup(true)    
            self.menu = nil
        end
    end
    local dynamicMenu = DynamicMenu:create_menu( name_t, menu_top_x, menu_top_y, 
                                                 DynamicMenu.COORDINATE_TYPE_TOP, 190, 
                                                 UILH_COMMON.bg_07, -- list背景
                                                 item_callback ,
                                                 "",    -- ITEM背景
                                                 { 0xffb0b0b0, 0xffd0d0d0 } )
    -- dynamicMenu:setPosition(_rx(475),_ry(271))
    dynamicMenu:setPosition(205, 170)
    return dynamicMenu
end

-- 显示用户名菜单
function LoginPage:show_user_list(  )
    -- 如果点击菜单存在，则删掉
    if self.menu then
        self.menu:removeFromParentAndCleanup(true)
        self.menu = nil
    end

    -- 添加点击菜单
    self.menu = self:create_user_list(  )
    self.menu:setAnchorPoint(0.5,1.0)
    self.dialogBack_bg:addChild( self.menu, 1 )
    local function f1(eventType,x,y)
        if eventType == TOUCH_ENDED then                             
            self.view:removeChild( self.menu_bg, true )  
            self.menu_bg = nil
            if self.menu then
                self.menu:removeFromParentAndCleanup(true)    
                self.menu = nil
            end
            return true
        elseif eventType then
            return true
        end
    end
    self.menu:registerScriptHandler(f1)

    -- 添加背景点击层
    self.menu_bg = CCBasePanel:panelWithFile( 0, 0, _refWidth(1.0), _refHeight(1.0), "", 500, 500 )
    self.view:addChild( self.menu_bg, -1 )
    local function f2(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            self.view:removeChild( self.menu_bg, true )
            self.menu_bg = nil
            if self.menu then
                self.menu:removeFromParentAndCleanup(true)
                self.menu = nil
            end
            return true
        end
        return true
    end
    self.menu_bg:registerScriptHandler(f2)
end

-- 声音控制
function LoginPage:sound_switch(  )
    local open_sourd = CCBasePanel:panelWithFile( 730, 420, -1, -1, "ui2/login/sound_on.png" )   -- 注意是反的
    local close_sourd = CCBasePanel:panelWithFile( 730, 420, -1, -1, "ui2/login/sound_off.png" )
    close_sourd:setIsVisible( false )
    local function open_sound_func( eventType )     -- 打开图标按下，变成关闭
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_CLICK then 
            SoundManager:pauseBackgroundMusic()
            open_sourd:setIsVisible( false )
            close_sourd:setIsVisible( true )
            return true
        end
        return true
    end
    local function close_sourd_func( eventType )     -- 关闭图标安息啊，变成打开
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_CLICK then 
            SoundManager:playMusic( 'login' , true);
            open_sourd:setIsVisible( true )
            close_sourd:setIsVisible( false )
            return true
        end
    end
    open_sourd:registerScriptHandler(open_sound_func)
    close_sourd:registerScriptHandler(close_sourd_func)
    self.view:addChild( open_sourd, 1000 )
    self.view:addChild( close_sourd, 1000 )
end

-- 更新
function LoginPage:update( update_type )
    if update_type == "all" then 
        _name = CCUserDefault:sharedUserDefault():getStringForKey("user_name")
        self.name_enter_frame:setText( _name )

        local pw = RoleModel:getPassword(_name)
        if pw  then
            self.password_enter_frame:setText(pw)
        end
    end
end

function LoginPage:destroy(  )
    safe_release(self.view)
    self:hide_keyboard()
end

-- 隐藏  
function LoginPage:hide_to_left( page_name )
    if page_name == "register" then 
        self:hide_to_right(  )
    else
        local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( -_refWidth(1.0), 0 ));          -- 动画
        self.view:runAction( moveto );
    end
end

function LoginPage:hide_to_right(  )
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( _refWidth(1.0), 0 ));          -- 动画
    self.view:runAction( moveto );
end

-- 显示
function LoginPage:show_to_center( show_type )
    if show_type == "select_server" then 
        self.view:setPosition( -800, 0 )
    end
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( 0, 0 ));          -- 动画
    self.view:runAction( moveto );
end

-- 键盘事件
function LoginPage:keyboard_will_show( keyboard_w, keyboard_h )
    self.is_keyboard_show=true
    local move_call = callback:new()
    local function callback_func(  )
        if keyboard_h == 162 then--ip eg
        -- self.dialogBack:setPosition(_refWidth(0.5),480);
            self.dialogBack_bg:setPosition(_refWidth(0.5),480);
        elseif keyboard_h == 198 then---ip cn
            -- self.dialogBack:setPosition(_refWidth(0.5),530);
            self.dialogBack_bg:setPosition(_refWidth(0.5),530);
        elseif keyboard_h == 352 then --ipad eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 406 then --ipad cn
            -- self.dialogBack:setPosition(_refWidth(0.5),480);
            self.dialogBack_bg:setPosition(_refWidth(0.5),530);
        end
    end
    move_call:start(0.3, callback_func)
end

function LoginPage:keyboard_will_hide( keyboard_w, keyboard_h )
    self.is_keyboard_show=false
    -- self.input_bg:setPosition(self.input_ori_x,self.input_ori_y);
    self.dialogBack_bg:setPosition(_refWidth(0.5),_refHeight(0.5));

end

-------------------- 手动关闭键盘
function LoginPage:hide_keyboard(  )
    if self.name_enter_frame and self.is_keyboard_show then
        self.name_enter_frame:detachWithIME()
    end
    if self.password_enter_frame and self.is_keyboard_show then
        self.password_enter_frame:detachWithIME()
    end
end

