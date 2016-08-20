-- LoginWin.lua
-- created by aXing on 2012-11-15
-- 登录窗口

require "UI/component/Window"
super_class.LoginWin(Window)

require "utils/UI/UIButton"
require "UI/login/LoginPage"
require "UI/login/NewSelectServerPage"
require "UI/login/SelectAliveRole"
require "UI/login/SelectRolePage"
require "UI/login/SelectServerPage"
require "UI/login/RegisterPage"

local _Z_NO_OPERATE = 1001
local _Z_NOTICE     = 1000

-- local _locl_callback = nil     -- 锁操作 遮罩的定时回调

-- 创建游戏登录界面
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _create2Flow = effectCreator.create2Flow
local _create4Flow = effectCreator.create4Flow

local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)
local FONT_SIZE = 20
function LoginWin:create_login_win(  )
    
    return LoginWin("login",'',false,panelWidth,panelHeight);

end

function LoginWin:__init( window_name, texture_name, is_grid, width, height  )

    self.page_t = {}                -- 存储已创建的每页的对象
    self.current_page = nil         -- 当前页
    self.old_page_name = ""         -- 原来的页的字符串(登录页返回动画的时候，要根据这个来设置初始位置)

    self.select_role_page = nil     -- 选择角色
    self.login_page = nil           -- 登录界面
    self.select_server_page = nil   -- 选择服务器

    SoundManager:playMusic('login',true)
    -- self:show_notice( "#cffff00测试测试测试测试测试测试测试测试测试", 275, 190 )

    -- _locl_callback = callback:new()
    self.no_operate_image = CCBasePanel:panelWithFile( 0, 0, panelWidth, panelHeight, "", 500, 500 )
    self.no_operate_image:setDefaultMessageReturn(true)
    self.view:addChild( self.no_operate_image, _Z_NO_OPERATE )
    self:lock_operate( false )

    self:BuildAnimation()
    self.view:setTag(500)

    local function enter_btn_fun()
        --MUtils:toast('通过sdk登录',2048,5,true)
         UI_Utilities.view:setIsVisible(false)
        PlatformInterface:doLogin()
    end

    local enter_btn = ZButton:create( self.view, "ui2/login/lh_enter3.png",  
                                                  enter_btn_fun,
                                                  _refWidth(0.52), 
                                                  _ry(100))
    local scaleIn = CCScaleTo:actionWithDuration(1.0,1);
    local scaleOut = CCScaleTo:actionWithDuration(1.0,1.2);
    local array = CCArray:array();
    array:addObject(scaleIn);
    array:addObject(scaleOut);
    local seq = CCSequence:actionsWithArray(array);
    local action = CCRepeatForever:actionWithAction(seq);

    enter_btn.view:runAction(action)
    enter_btn:setAnchorPoint( 0.5, 0.5 )

    self.loginBtn = enter_btn

    local function qq_enter_btn_fun()
        if Target_Platform == Platform_Type.Platform_MSDK or Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2 then
            PlatformInterface:set_login_type("qq")
            PlatformInterface:doLogin()
        end
    end
    self.Platform_MSDK_qq_enter_btn = ZButton:create(self.view, "nopack/login_qq.png", qq_enter_btn_fun, panelWidth * 3 / 11, panelHeight * 3 / 11, -1, -1 )
 
    local function wx_enter_btn_fun()
        if Target_Platform == Platform_Type.Platform_MSDK or Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2 then
            PlatformInterface:set_login_type("wx")
            PlatformInterface:doLogin()
        end
    end
    self.Platform_MSDK_wx_enter_btn = ZButton:create(self.view, "nopack/login_wx.png", wx_enter_btn_fun, panelWidth * 6 / 11, panelHeight * 3 / 11, -1 , -1 )

    self.Platform_MSDK_qq_enter_btn.view:setIsVisible(false)
    self.Platform_MSDK_wx_enter_btn.view:setIsVisible(false)

    -- =====================================================
    -- 创建公告面板 begin
    local width = _rx(770)
    if width > 770 then
        width = 770
    end
    local height = _ry(530)
    if height > 530 then
        height = 530
    end
    self.notice_window_panel = CCBasePanel:panelWithFile( _refWidth(0.5), _refHeight(0.5), width, height, "")
    self.notice_window_panel:setAnchorPoint(0.5,0.5)
    self.view:addChild(self.notice_window_panel)

    local bg = ZImage:create( self.notice_window_panel, UILH_COMMON.style_bg, 0, 0, width, height - 25, -1,500,500 )

    --标题背景
    local title_bg = ZImage:create( self.notice_window_panel,UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    
    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    local window_title = ZImage:create(title_bg, "nopack/notice_win_title.png" , t_width/2,  t_height-27, -1,-1 );
    window_title.view:setAnchorPoint(0.5,0.5)

    --关闭公告面板方法
    local function tmp_close_btn_fun()
        -- 重置掉状态，下次登录不再显示更新公告
        UpdateManager:set_after_update_first("false")

        self.notice_window_panel:setIsVisible(false);
        if Target_Platform == Platform_Type.Platform_MSDK or Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2 then
            -- MSDK和Hoolai都是腾讯平台，显示的是QQ和微信登录按钮。就不用去显示常规登录按钮了，避免登录按钮闪一下又消失很碍眼。
        else
            self.loginBtn.view:setIsVisible(true)
        end
        -- 关闭面板后，进入正常的登录流程
        PlatformInterface:onEnterLoginState(true)
    end

    local exit_btn = ZButton:create(self.notice_window_panel, UILH_COMMON.close_btn_z, tmp_close_btn_fun,0,0,60,60,1000);
    local exit_btn_size = exit_btn:getSize()
    exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height-20)

    -- 底层背景
    local bottom_bg = CCBasePanel:panelWithFile(15, 62, width - 30, height - 25 - 95, UILH_COMMON.normal_bg_v2,500,500)
    self.notice_window_panel:addChild(bottom_bg)

    -- 内容滑动区域
    self:create_notice_window_scroll(bottom_bg,width - 30,height - 25 - 95);

    -- 确定按钮（其实就是关闭按钮）
    local btn = ZButton:create( self.notice_window_panel, {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, tmp_close_btn_fun, (width-121)/2,10, 121, 53 )
    MUtils:create_zxfont(btn,Lang.common.confirm[0],121/2,21,2,16); -- "#cd0cda2确定"

    -- 一开始先隐藏
    self.notice_window_panel:setIsVisible(false);
    -- 创建公告面板 end
    -- =====================================================

    -- local function whgg_fun( eventType,msg_id,args)
    --     if eventType == TOUCH_CLICK then
    --         if ( self.xtgg_panel ) then
    --             self.xtgg_panel:removeFromParentAndCleanup(true);
    --             self.xtgg_panel = nil;
    --         else
    --             self.xtgg_panel = SelectServerPage:show_announcement()
    --             self.view:addChild(self.xtgg_panel,99);
    --         end
    --     end
    --     return true;
    -- end
    -- -- 维护公告按钮
    -- self.whgg_btn = MUtils:create_btn(self.view,"ui2/login/system_info_btn.png",
    --                                              "ui2/login/system_info_btn.png",
    --                                              whgg_fun,_rx(816),_ry(496),-1,-1);

end

function LoginWin:create_notice_window_scroll(father_panel,panel_width,panel_height)
    -- 预防一下
    if Lang.notice_window == nil or Lang.notice_window.notice_text == nil then
        return;
    end

    local notice_window_scroll = CCDialog:dialogWithFile(10,10, 
                                                 panel_width-20,panel_height-23, 
                                                 99, "", 
                                                 TYPE_HORIZONTAL, 
                                                 ADD_LIST_DIR_UP)

    for i = 1, #Lang.notice_window.notice_text do
        notice_window_scroll:setText( Lang.notice_window.notice_text[i] )
    end

    -- notice_window_scroll:setText(Lang.notice_window.notice_text)
    father_panel:addChild(notice_window_scroll);
end

-- 加最上层遮罩阻止操作
function LoginWin:lock_operate( if_show )
    -- print("加最上层遮罩阻止操作........", if_show)
    self.no_operate_image:setIsVisible( if_show )
end

-- 定时遮罩  按指定的时间阻止操作
-- function LoginWin:lock_operate_by_time( time )
--     self.no_operate_image:setIsVisible( true )
--     local function callback_func(  )
--         self.no_operate_image:setIsVisible( false )
--     end
--     _locl_callback:cancel()
--     _locl_callback:start( time, callback_func )
-- end

-- 摧毁窗口，被UIManager调用
function LoginWin:destroy(  )
    -- print('LoginWin')
    Window.destroy(self)
    if self.select_role_page then
        self.select_role_page:destroy()
    end

    if self.login_page then
        self.login_page:destroy()
    end

    if self.select_server_page then
        self.select_server_page:destroy()
    end

    if self.register_page then 
        self.register_page:destroy()
    end

    if self.new_select_server_page then
        self.new_select_server_page:destroy()
    end
end

-- 外部静态调用  login  select_role   select_server  
function LoginWin:change_login_page( page_name )
    self:change_page( page_name )   
end

-- 改变页  login  select_role   select_server
function LoginWin:change_page( page_name )
    if page_name==nil then
        return
    end

    -- print("===LoginWin:change_page--", page_name, self.current_page, self)
    -- for key, page in pairs(self.page_t) do
    --     page.view:setIsVisible(false)
    -- end
    -- local lock_time = RoleModel:get_move_rate(  )
    RoleModel:lock_operate_by_time( 1 )

    if self.current_page  then
        self.current_page:hide_to_left( page_name )
    end

    self.loginBtn.view:setIsVisible(false)
    self.Platform_MSDK_qq_enter_btn.view:setIsVisible(false)
    self.Platform_MSDK_wx_enter_btn.view:setIsVisible(false)
    self.notice_window_panel:setIsVisible(false);
    if page_name == "notice_window" then

        -- print("change page  notice window")
        -- 更换背景图
        self.animation_panel:setTexture("nopack/login_back.jpg")
        self.animation_panel:setIsVisible(true)

        -- 显示更新公告
        self.notice_window_panel:setIsVisible(true);

        self.current_page = nil
    elseif page_name == "loginSDK" then
        -- print("change page  loginSDK")

        -- 更换背景图
        self.animation_panel:setTexture("nopack/login_back.jpg")
        self.animation_panel:setIsVisible(true)
        self.text_img:setIsVisible(true)
        -- self.login_panel:setIsVisible(true)
        if Target_Platform == Platform_Type.Platform_MSDK or Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2 then
            self.loginBtn.view:setIsVisible(false)
            self.Platform_MSDK_qq_enter_btn.view:setIsVisible(true)
            self.Platform_MSDK_wx_enter_btn.view:setIsVisible(true)
        else
            self.loginBtn.view:setIsVisible(true)
        end
        self.current_page = nil

    elseif page_name == "loginIOS" then
        -- print("change page  loginIOS")

        if self.login_page == nil then
            require "UI/login/LoginPageIos"
            self.login_page = LoginPageIos( "", {texture = "ui/lh_common/style_bg.png", x = 0, y = 0, width = panelWidth, height = panelHeight } )    -- 登录页
            self.view:addChild( self.login_page.view )
            table.insert( self.page_t, self.login_page )
        end
        self.current_page = self.login_page
        self.current_page:change_login_page(tLoginPage.eShowMainloginPanel)
        self.loginBtn.view:setIsVisible(true) 
        self.text_img:setIsVisible(true)
    elseif page_name == "login" then
        -- print("change page  login")

        self.logo:setIsVisible(true)
        if self.login_page == nil then
            self.login_page = LoginPage( "", {texture = "", x = 0, y = 0, width = panelWidth, height = panelHeight } )    -- 登录页
            self.view:addChild( self.login_page.view )
            table.insert( self.page_t, self.login_page )
        end
        self.current_page = self.login_page
        self.loginBtn.view:setIsVisible(false)
        -- 更换背景图
        self.animation_panel:setIsVisible(true)
        self.text_img:setIsVisible(true)
        -- self.login_panel:setIsVisible(true)
    elseif page_name == "select_alive_role_page" then
        print("change page  select_alive_role_page")
    
        if self.select_alive_role_page == nil then
            print("页面不存在 则创建")
            self.select_alive_role_page = SelectAliveRole( "", "", panelWidth, 0, panelWidth, panelHeight )
            self.view:addChild( self.select_alive_role_page.view )
            table.insert( self.page_t, self.select_alive_role_page )
        end
        self.current_page = self.select_alive_role_page
        self.current_page:active()
        UI_Utilities.DestroyResourceButton()
        -- 更换背景图
            self.animation_panel:setIsVisible(true)
            self.animation_panel:setTexture("nopack/lh_select_role_bg.jpg")
            self.logo:setIsVisible(false)
            self.text_img:setIsVisible(false)
        -- self.login_panel:setIsVisible(false)
    elseif page_name == "new_select_server_page" then
        -- print("change page  new_select_server_page")
    
        if self.new_select_server_page == nil then
            self.new_select_server_page = NewSelectServerPage( "", "", 0, 0, panelWidth, panelHeight )
            self.view:addChild( self.new_select_server_page.view )
            table.insert( self.page_t, self.new_select_server_page )
        end
        self.current_page = self.new_select_server_page
        -- 更换背景图
        self.animation_panel:setTexture("nopack/login_back.jpg")
        self.animation_panel:setIsVisible(true)
        self.text_img:setIsVisible(true)
        -- self.login_panel:setIsVisible(true)
    elseif page_name == "select_role" then
        -- print("change page  select_role")

                     --xiehande  去掉系統公告/修復遊戲按鈕
        require 'UI/UI_Utilities'
        UI_Utilities.DestroyAdButton()
        UI_Utilities.DestroyFixButton()
        UI_Utilities.DestroyResourceButton()

        self.logo:setIsVisible(false)
        if self.select_role_page == nil then
            self.select_role_page = SelectRolePage( "SelectRolePage", '', false, panelWidth, panelHeight)    -- 登录页
            self.view:addChild( self.select_role_page.view )
            table.insert( self.page_t, self.select_role_page )
        end
        self.current_page = self.select_role_page
        self.text_img:setIsVisible(false)
        -- self.current_page.view:setIsVisible(true)
        -- 更换背景图
        self.enter_role_callback = callback:new()
        local function enter_role_func()
            self.animation_panel:setIsVisible(true)
            self.animation_panel:setTexture("nopack/lh_select_role_bg.jpg")
            -- self.login_panel:setIsVisible(false)
            self.enter_role_callback:cancel()
            self.enter_role_callback = nil
        end
        self.enter_role_callback:start(0.5, enter_role_func)
        
    elseif page_name == "select_server" then
        -- print("change page  select_server")

        --xiehande  添加系統公告/修復遊戲按鈕
        require 'UI/UI_Utilities'
        -- UI_Utilities.CreateAdButton()
        UI_Utilities.CreateFixButton()
        UI_Utilities.CreateResourceFixButton()
        self.logo:setIsVisible(false)
        if self.select_server_page == nil then
            self.select_server_page = SelectServerPage( "SelectServerPage",nil,true,panelWidth,panelHeight)    -- 选择服务器页
            self.view:addChild( self.select_server_page.view )
            table.insert( self.page_t, self.select_server_page )
        end
        self.current_page = self.select_server_page
        -- self.current_page.view:setIsVisible(true)
        -- 更换背景图
        self.animation_panel:setTexture("nopack/login_back.jpg")
        self.animation_panel:setIsVisible(true)
        self.text_img:setIsVisible(true)
        -- self.login_panel:setIsVisible(true)
    elseif page_name == "register" then
        if self.register_page == nil then
            self.register_page = RegisterPage( "", {texture ="", x =-panelWidth,y = 0, width = panelWidth,height = panelHeight} )    -- 选择服务器页
            self.view:addChild( self.register_page.view )
            table.insert( self.page_t, self.register_page )
        end
        self.logo:setIsVisible(true)
        self.current_page = self.register_page
        -- self.current_page.view:setIsVisible(true)
    end
    if self.current_page then
        self.current_page:show_to_center( self.old_page_name )
    end
    if self.current_page and self.current_page.update then 
        self.current_page:update( "all" )
    end
    -- self.animation_panel:setTexture("nopack/login_back.jpg")
    self.old_page_name = page_name
end

-- 显示滚动文字提示
function LoginWin:show_notice( notice_content, x, y, yes_callback )
    self.notice_panel_cb_func = yes_callback
    -- print("显示。。。。。。", notice_content, x, y)
    local ltt_win_w = 360
    local ltt_win_h = 280
    if self.notice_panel == nil then
        self.notice_panel = CCBasePanel:panelWithFile( 0, 0, panelWidth, panelHeight, "", 500, 500 )
        -- 窗口背景  和 台头
        self.words_bg = CCBasePanel:panelWithFile( _refWidth(0.5) , _refHeight(0.5), ltt_win_w, ltt_win_h, UILH_COMMON.dialog_bg, 500, 500 )
        self.words_bg:setAnchorPoint(0.5,0.5)
        -- local temp_bg = ZImage:create( self.words_bg, "ui2/login/grid_15.png", 238,170, 420, 140, nil, 600, 600 )
        -- temp_bg.view:setAnchorPoint(0.5,0.5)
        local title_bg = CCZXImage:imageWithFile( ltt_win_w*0.5, ltt_win_h-10, -1, -1, UILH_COMMON.title_bg )  -- 307, 60
        title_bg:setAnchorPoint( 0.5, 0.5 )
        self.words_bg:addChild( title_bg )
        local title    = CCZXImage:imageWithFile( 307*0.5, 60*0.5, -1, -1, UILH_NORMAL.title_tips  )
        title:setAnchorPoint(0.5,0.5)
        title_bg:addChild( title )

        -- 内容
        self.content_dialog = CCDialogEx:dialogWithFile( 34, 214, ltt_win_w-60, 130, 50, nil, 1 ,ADD_LIST_DIR_UP)
        self.content_dialog:setFontSize(FONT_SIZE)
        self.content_dialog:setText( notice_content )
        self.content_dialog:setAnchorPoint( 0, 1)
        self.words_bg:addChild( self.content_dialog )

        -- 确定按钮
        local function apply_but_CB(  )
            self.notice_panel:setIsVisible( false )
            if self.notice_panel_cb_func then 
                self.notice_panel_cb_func()
            end
        end
        -- self.apply_but = UIButton:create_button_with_name( 170, 26, -1, -1, UILH_COMMON.lh_button2, UILH_COMMON.lh_button2, nil, "", apply_but_CB )
        self.apply_but = ZTextButton:create(self.words_bg, "确定",UILH_COMMON.lh_button2, apply_but_CB, ltt_win_w*0.5-99*0.5,26,-1,-1)

        -- self.close_but = UIButton:create_button_with_name( ltt_win_w-60, ltt_win_h, -1, -1, UILH_COMMON.close_btn_z, UILH_COMMON.close_btn_z, nil, "", apply_but_CB )

        -- local font = CCZXImage:imageWithFile( 74, 28, -1, -1, "ui2/login/login_btn_label.png" );
        -- font:setAnchorPoint(0.5,0.5)
        -- self.apply_but.view:addChild( font )


        -- self.words_bg:addChild( self.apply_but.view )
        -- self.words_bg:addChild( self.close_but.view )
        self.notice_panel:addChild( self.words_bg )
        self.view:addChild( self.notice_panel, _Z_NOTICE )

        -- 点击任何地方，都关闭
        local function f1(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                self.notice_panel:setIsVisible( false )
                return true
            elseif eventType == TOUCH_CLICK then
                return false
            elseif eventType == TOUCH_ENDED then
                return false
            end
        end
        self.notice_panel:registerScriptHandler(f1)
    end 

    self.notice_panel:setIsVisible( true )
    self.content_dialog:setText("")
    self.content_dialog:setText( notice_content )
end

function LoginWin:show_notice_register( count, password, yes_callback )
    self.notice_panel_cb_func = yes_callback
    -- print("显示。。。。。。", notice_content, x, y)
    local ltt_win_w = 360
    local ltt_win_h = 280
    if self.notice_reg_panel == nil then
        self.notice_reg_panel = CCBasePanel:panelWithFile( 0, 0, panelWidth, panelHeight, "" )

        -- 窗口背景  和 台头
        self.words_bg = CCBasePanel:panelWithFile( _refWidth(0.5) , _refHeight(0.5), ltt_win_w, ltt_win_h, UILH_COMMON.dialog_bg, 500, 500 )
        self.words_bg:setAnchorPoint(0.5,0.5)
        -- local temp_bg = ZImage:create( self.words_bg, "ui2/login/grid_15.png", 238,170, 420, 140, nil, 600, 600 )
        -- temp_bg.view:setAnchorPoint(0.5,0.5)
        -- 内框
        self.panel_inside = CCBasePanel:panelWithFile(15, 15, 332, 238, UILH_COMMON.bottom_bg, 500, 500 )
        self.words_bg:addChild( self.panel_inside )

        local title_bg = CCZXImage:imageWithFile( ltt_win_w*0.5, ltt_win_h-10, -1, -1, UILH_COMMON.title_bg )  -- 307, 60
        title_bg:setAnchorPoint( 0.5, 0.5 )
        self.words_bg:addChild( title_bg )
        local title    = CCZXImage:imageWithFile( 307*0.5, 60*0.5, -1, -1, UILH_NORMAL.title_tips  )
        title:setAnchorPoint(0.5,0.5)
        title_bg:addChild( title )

        -- 提示
        local tip_1 = UILabel:create_lable_2( LH_COLOR[2].. "使用以下账号密码进入游戏：", ltt_win_w*0.5, 195, 14, ALIGN_CENTER )
        self.words_bg:addChild( tip_1 )

        -- 账号
        local count_title    = CCZXImage:imageWithFile( 100, 155, -1, -1, "ui2/login/lh_accout.png"  )
        self.words_bg:addChild( count_title )
        print("-----count", count)
        self.count_value = UILabel:create_lable_2( count, ltt_win_w*0.5, 160, 14, ALIGN_LEFT )
        self.words_bg:addChild( self.count_value )

        -- 密码
        local pwd_title    = CCZXImage:imageWithFile( 100, 125, -1, -1, "ui2/login/lh_pwd.png"  )
        self.words_bg:addChild( pwd_title )
        self.pass_value = UILabel:create_lable_2( password, ltt_win_w*0.5, 130, 14, ALIGN_LEFT )
        self.words_bg:addChild( self.pass_value )

        -- 分割线
        local line = CCZXImage:imageWithFile( 25, 100, 310, 3, UILH_COMMON.split_line)
        self.words_bg:addChild( line )

        -- 内容
        -- self.content_dialog = CCDialogEx:dialogWithFile( 34, 214, ltt_win_w-60, 130, 50, nil, 1 ,ADD_LIST_DIR_UP)
        -- self.content_dialog:setFontSize(FONT_SIZE)
        -- self.content_dialog:setText( notice_content )
        -- self.content_dialog:setAnchorPoint( 0, 1)
        -- self.words_bg:addChild( self.content_dialog )

        -- 确定按钮
        local function apply_but_CB(  )
            self.notice_reg_panel:setIsVisible( false )
            if self.notice_panel_cb_func then 
                self.notice_panel_cb_func()
            end
        end
        -- self.apply_but = UIButton:create_button_with_name( 170, 26, -1, -1, UILH_COMMON.lh_button2, UILH_COMMON.lh_button2, nil, "", apply_but_CB )
        self.apply_but = ZTextButton:create(self.words_bg, "确定",UILH_COMMON.lh_button2, apply_but_CB, ltt_win_w*0.5-99*0.5,26,-1,-1)

        -- self.close_but = UIButton:create_button_with_name( ltt_win_w-60, ltt_win_h, -1, -1, UILH_COMMON.close_btn_z, UILH_COMMON.close_btn_z, nil, "", apply_but_CB )

        -- local font = CCZXImage:imageWithFile( 74, 28, -1, -1, "ui2/login/login_btn_label.png" );
        -- font:setAnchorPoint(0.5,0.5)
        -- self.apply_but.view:addChild( font )


        -- self.words_bg:addChild( self.apply_but.view )
        -- self.words_bg:addChild( self.close_but.view )
        self.notice_reg_panel:addChild( self.words_bg )
        self.view:addChild( self.notice_reg_panel, _Z_NOTICE )

        -- 点击任何地方，都关闭
        local function f1(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                self.notice_reg_panel:setIsVisible( false )
                return true
            elseif eventType == TOUCH_CLICK then
                return false
            elseif eventType == TOUCH_ENDED then
                return false
            end
        end
        self.notice_reg_panel:registerScriptHandler(f1)
    end 

    self.notice_reg_panel:setIsVisible( true )
    self.count_value:setText(count)
    self.pass_value:setText(password)
    -- self.content_dialog:setText("")
    -- self.content_dialog:setText( notice_content )
end

-- 提供外部静态调用的更新窗口方法
function LoginWin:update_win( update_type )
    -- require "UI/UIManager"
    -- local win = UIManager:find_visible_window("login")
    -- if win then
        self:update( update_type )
    -- end
end

-- 更新
function LoginWin:update( update_type )
    if update_type == "all" then
        
    else
        -- print('LoginWin:update',self.current_page.__classname)
        self.current_page:update( update_type )
    end
end


function LoginWin.whiteSpotAnimation(view)
    local spot = CCSprite:spriteWithFile('nopack/white_spot.png')
    spot:setPosition(CCPointMake(_refWidth(0.5),_refHeight(0.5)))
    spot:setScale(0.01)
    local scaleOut = CCScaleTo:actionWithDuration(1.0,20.0);
    local fade_out = CCFadeOut:actionWithDuration(0.25); 
    local remove = CCRemove:action()
    local array = CCArray:array();
    array:addObject(scaleOut);
    array:addObject(fade_out);
    array:addObject(remove);
    local seq = CCSequence:actionsWithArray(array);
    local action = CCRepeatForever:actionWithAction(seq);
    spot:runAction(action)
    view:addChild(spot,1000)
end


function LoginWin:BuildAnimation()
    local base_panel = CCBasePanel:panelWithFile(0, 0, 960, panelHeight, "")
    base_panel:setPosition(0, panelHeight/2)
    base_panel:setAnchorPoint(0, 0.5)
    -- base_panel:setTexture("nopack/lh_select_role_bg.png")
    local bg_size = base_panel:getSize()

    if bg_size.width < panelWidth then
        base_panel:setSize(panelWidth, bg_size.height)
        -- base_panel:setAnchorPoint(0.5, 0.5)
    else
        local move_dx = bg_size.width - panelWidth
        if move_dx > 50 then
            local repeat_time = move_dx/10
            -- local function bg_move_repeat( )
            local moveto1 = CCMoveBy:actionWithDuration(repeat_time,CCPoint(-move_dx,0))
            local moveto2 = CCMoveBy:actionWithDuration(repeat_time,CCPoint(move_dx,0))
            local _array = CCArray:array();
            _array:addObject(moveto1)
            _array:addObject(moveto2);

            local sequence = CCSequence:actionsWithArray(_array);
            local repeatForever = CCRepeatForever:actionWithAction(sequence)
            base_panel:runAction(repeatForever)
        end
    end
    self.animation_panel = base_panel
    self.animation_panel:setIsVisible(false)
    -- base_panel:addChild(panel)
    self.view:addChild(base_panel)
    -- 登陆界面
    local lace_height = (panelHeight - bg_size.height)/2
    -- 分栏(上下)
    -- self.bg_up = CCBasePanel:panelWithFile( _refWidth(0.5), panelHeight, _refWidth(1), -1, "nopack/lh_subfild.png" )
    -- self.bg_up:setAnchorPoint( 0.5, 1 )
    -- self.bg_up:setFlipY(true)
    -- self.view:addChild( self.bg_up )
    -- self.bg_down = CCBasePanel:panelWithFile( _refWidth(0.5), 0, _refWidth(1), -1, "nopack/lh_subfild.png" )
    -- self.bg_down:setAnchorPoint( 0.5, 0 )
    -- self.view:addChild( self.bg_down )

    -- self.login_panel = CCBasePanel:panelWithFile(0, 0, panelWidth, panelHeight, "nopack/login_back.jpg")
    -- self.view:addChild(self.login_panel)
    self.logo = nil
    local pf =  GetPlatform()
    local is_test_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_test_version")
    if is_test_version then
        self.logo = CCSprite:spriteWithFile('nopack/login_logo_test.png')
    elseif GetPlatform() == CC_PLATFORM_IOS or Target_Platform == Platform_Type.Platform_MSDK then
        self.logo = CCSprite:spriteWithFile('nopack/login_logo4.png')
    elseif Target_Platform == Platform_Type.Platform_Hoolai then
        self.logo = CCSprite:spriteWithFile('nopack/login_logo5.png')
    elseif Target_Platform == Platform_Type.Platform_Hoolai2 then
        self.logo = CCSprite:spriteWithFile('nopack/login_logo7.png')
    elseif Target_Platform == Platform_Type.Platform_SC or Target_Platform == Platform_Type.Platform_Any 
        or Target_Platform == Platform_Type.Platform_ZS or Target_Platform == Platform_Type.Platform_sy 
        or Target_Platform == Platform_Type.Platform_SD or Target_Platform == Platform_Type.Platform_Sogou 
        or Target_Platform == Platform_Type.Platform_YXD or Target_Platform == Platform_Type.Platform_YL
        or Target_Platform == Platform_Type.Platform_DY then
        self.logo = CCSprite:spriteWithFile('nopack/login_logo6.png')
    else
        self.logo = CCSprite:spriteWithFile('nopack/login_logo3.png')
    end
    self.view:addChild(self.logo)
    self.logo:setPosition(CCPointMake(_rx(495),_ry(515)))

    self.text_img = CCSprite:spriteWithFile('ui2/login/logo_text.png')
    self.text_img:setPosition(CCPointMake(_rx(495),_ry(400)))
    self.view:addChild(self.text_img)
end