-- LoginPage.lua 
-- created by aXing on 2013-2-26
-- 登录页

super_class.LoginPageIos()

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight


local DialogDepth = 1024
local _name = CCUserDefault:sharedUserDefault():getStringForKey("user_name")  --默认用户名。

local STRING_OK       = '确认'
local STRING_EMPTY_USR_PW = {'#cffff00账号或密码为空', '请重新输入'} -- [1339]='#cffff00账号或密码为空' -- [1340]='请重新输入'
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

local _bindRegistPanel = nil
local _bindGuestPanel  = nil


--登录也枚举
--addby mwy@2014.9.2 16:17
tLoginPage={
    eShowMainloginPanel =1,--主登录选择页面
    eShowloginPanel     =2,--登录页
    eShowRegistPanel    =3,--注册页
}

--切换登录框
--新版登录页，增加游客和Game Center登录
--原版登录顺序改变.
function LoginPageIos:change_login_page(page_index)
    if page_index==tLoginPage.eShowMainloginPanel then
        self.mainLoginPanel:setIsVisible(true)
        self.loginPanel:setIsVisible(false)
        self.registPanel:setIsVisible(false)
    elseif page_index==tLoginPage.eShowloginPanel then
        self.mainLoginPanel:setIsVisible(false)
        self.loginPanel:setIsVisible(true)
        self.registPanel:setIsVisible(false)
    elseif page_index==tLoginPage.eShowRegistPanel then
        self.mainLoginPanel:setIsVisible(false)
        self.loginPanel:setIsVisible(false)
        self.registPanel:setIsVisible(true)
    end
end

--游客进入游戏场景后提醒绑定账号
function LoginPageIos:ShowBindGuestPanel(isShow)
    local _root =GameStateManager:get_game_root():getUINode()

    if _bindGuestPanel  then
        _bindGuestPanel:removeFromParentAndCleanup(true) 
        _bindGuestPanel=nil
        if not isShow then
            return
        end
    end

    ------------------------游客提示页------------------------
    _bindGuestPanel = CCBasePanel:panelWithFile(_refWidth(0.5), _refHeight(0.5), 420, 320, "", 600, 600 )
    _bindGuestPanel:setAnchorPoint(0.5,0.5)
    --标题
    MUtils:create_zximg(_bindGuestPanel,"ui2/login/regist.png", 130,290,-1, -1,500,500);
    --星星
    -- MUtils:create_zximg(_bindGuestPanel,"ui2/login/kuwu.png", 284,299,-1, -1,500,500);
    -- --绑定提示文字
    -- MUtils:create_zximg(_bindGuestPanel,"ui2/login/reward.png", 32,215,-1, -1,500,500);
    

    local function close_fun( eventType )
         if eventType == TOUCH_CLICK then
            self:hide_keyboard(  )
            self:ShowBindGuestPanel(false)

         end
         return true;
    end
    --关闭按钮
    local close_btn = CCNGBtnMulTex:buttonWithFile(376, 277, 60, 60, "ui/lh_common/close_btn_z.png")
    close_btn:registerScriptHandler(close_fun) 
    _bindGuestPanel:addChild(close_btn)

    local function regist_acount_fun( eventType )
         if eventType == TOUCH_CLICK then
             self:ShowBindGuestPanel(false)
             self:ShowBindRegistPanel(true )
         end
         return true;
    end
    --游客注册账号按钮
    local regist_acount_btn = CCNGBtnMulTex:buttonWithFile(37, 123, 338, 70, "ui2/login/lh_ser_ios_bg.png", TYPE_MUL_TEX, 500, 500)
    regist_acount_btn:registerScriptHandler(regist_acount_fun) 
    _bindGuestPanel:addChild(regist_acount_btn)
    MUtils:create_zximg(regist_acount_btn,"ui2/login/regist.png", 120, 20, -1, -1,500,500);

    local function game_center_fun( eventType )
         if eventType == TOUCH_CLICK then
            --绑定
            -- PlatformInterface:gamecenter_Login( true )
         end
         return true;
    end
    --游客提示绑定gamecenter按钮
    local game_center_btn = CCNGBtnMulTex:buttonWithFile(37, 40, 338, 70, "ui2/login/lh_ser_ios_bg.png", TYPE_MUL_TEX, 500, 500)
    game_center_btn:registerScriptHandler(game_center_fun) 
    _bindGuestPanel:addChild(game_center_btn)
    MUtils:create_zximg(game_center_btn,"ui2/login/game_center.png", 40, 20, -1, -1,500,500);

    _root:addChild(_bindGuestPanel,9998)
end

function LoginPageIos:ShowBindRegistPanel( isShow )
    local _root =GameStateManager:get_game_root():getUINode()

    if _bindRegistPanel  then
        _bindRegistPanel:removeFromParentAndCleanup(true) 
        _bindRegistPanel=nil
        if not isShow then
            return
        end
    end
    
    _bindRegistPanel = CCBasePanel:panelWithFile(_refWidth(0.5), _refHeight(0.5), 420, 320, "", 600, 600 )
    _bindRegistPanel:setAnchorPoint(0.5,0.5)

    MUtils:create_zximg(_bindRegistPanel,"ui2/login/regist.png", 138,293,-1, -1,500,500);


    --4个输入框标题
    MUtils:create_zximg(_bindRegistPanel,"ui2/login/lh_acount.png", 36, 257, -1, -1,500,500);
    MUtils:create_zximg(_bindRegistPanel,"ui2/login/lh_pwd.png", 36, 257-50, -1, -1,500,500);
    MUtils:create_zximg(_bindRegistPanel,"ui2/login/check.png", 36, 257-50*2, -1, -1,500,500);
    MUtils:create_zximg(_bindRegistPanel,"ui2/login/tel_num.png", 36, 257-50*3, -1, -1,500,500);

    --4个输入框地板
    MUtils:create_zximg(_bindRegistPanel,UILH_COMMON.bg_03, 136, 250,230, 40,500,500);

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
            self:keyboard_will_show( keyboard_width, keyboard_height ,true); 
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height ,true);
        end
        return true
    end

    self.acont_text = CCZXEditBox:editWithFile( 136, 250, 230, 40, "", 26, 20, EDITBOX_TYPE_NORMAL )
    _bindRegistPanel:addChild( self.acont_text )
    self.acont_text:registerScriptHandler(edit_box_function)
    
    ------------------------
    MUtils:create_zximg(_bindRegistPanel, UILH_COMMON.bg_03, 136, 250-50,230, 40,500,500);

    self.psw_text = CCZXEditBox:editWithFile( 136, 250-50, 230, 40, "", 26, 20, EDITBOX_TYPE_NORMAL )
    _bindRegistPanel:addChild( self.psw_text )
    self.psw_text:registerScriptHandler(edit_box_function)

    ------------------------
    MUtils:create_zximg(_bindRegistPanel, UILH_COMMON.bg_03, 136, 250-50*2,230, 40,500,500);

    self.psw_ag_text = CCZXEditBox:editWithFile( 136, 250-50*2, 230, 40, "", 26, 20, EDITBOX_TYPE_NORMAL )
    _bindRegistPanel:addChild( self.psw_ag_text )
    self.psw_ag_text:registerScriptHandler(edit_box_function)

    ------------------------

    MUtils:create_zximg(_bindRegistPanel, UILH_COMMON.bg_03, 136, 250-50*3,230, 40,500,500);


    self.tel_text = CCZXEditBox:editWithFile( 136, 250-50*3, 230, 40, "", 26, 20, EDITBOX_TYPE_NORMAL )
    _bindRegistPanel:addChild( self.tel_text )
    self.tel_text:registerScriptHandler(edit_box_function)



    --密码验证结果显示
    self.check_lable = UILabel:create_lable_2("", 363, 92, 14, ALIGN_RIGHT)
    self.check_lable:setAnchorPoint(CCPoint( 0,0.5))
    _bindRegistPanel:addChild( self.check_lable);

    --返回登录按钮
    local function back_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
            self:hide_keyboard(  )
            self:ShowBindGuestPanel(true )
            self:ShowBindRegistPanel(false )
         end
         return true;
    end
    -- local back_btn = CCNGBtnMulTex:buttonWithFile(37, 231-70*3-3, -1, -1, "ui/common/btn_other.png")
    -- back_btn:registerScriptHandler(back_btn_fun) 
    -- _bindRegistPanel:addChild(back_btn)
    -- MUtils:create_zximg(back_btn,"ui2/login/back.png", 38, 13, -1, -1,500,500);

    --登录按钮
    local function registe_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
            self:hide_keyboard(  )

             local acount_lbl = self.acont_text:getText()
             local psw_lbl = self.psw_text:getText()
             local psw_ag_lbl = self.psw_ag_text:getText()
             local tel_lbl = self.tel_text:getText()
             if acount_lbl==nil or acount_lbl=='' then
                self.check_lable:setText("#cfffccc输入账号不能为空。")
                return
             end
             if psw_lbl==nil or psw_lbl=='' then
                self.check_lable:setText("#cfffccc输入密码不能为空。")
                return
             end
             if psw_ag_lbl==nil or psw_ag_lbl=='' then
                self.check_lable:setText("#cfffccc输入确认密码不能为空。")
                return
             end

             if psw_lbl==psw_ag_lbl then
                self.check_lable:setText("")
             else
                self.check_lable:setText("#cfffccc两次输入密码不一致")
                return
             end
             --游客转普通账号的绑定,需要绑定
             -- RoleModel:registe_and_get_server_list(true,acount_lbl,psw_lbl,psw_ag_lbl,tel_lbl,MSDK_TYPE.ePlatform_normal)
         end
         return true;
    end
    -- local regist_btn = CCNGBtnMulTex:buttonWithFile(227, 231-70*3-3, -1, -1, "ui/common/btn_other.png")
    -- regist_btn:registerScriptHandler(registe_btn_fun) 
    -- _bindRegistPanel:addChild(regist_btn)
    -- MUtils:create_zximg(regist_btn,"ui2/login/easy_reg.png", 38, 13, -1, -1,500,500);

    local function close_fun( eventType )
         if eventType == TOUCH_CLICK then

            self:ShowBindRegistPanel(false )

            self:hide_keyboard(  )

         end
         return true;
    end
    --关闭按钮
    local close_btn = CCNGBtnMulTex:buttonWithFile(376, 277, 60, 60, "ui/lh_common/close_btn_z.png")
    close_btn:registerScriptHandler(close_fun) 
    _bindRegistPanel:addChild(close_btn)

    _root:addChild(_bindRegistPanel,9999)
end

function LoginPageIos:__init( window_name, window_info )

    self.view = CCBasePanel:panelWithFile( window_info.x, window_info.y, window_info.width, window_info.height, "", 500, 500 )
    safe_retain(self.view)

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)

    ------------------------登录选择页面------------------------
    self.mainLoginPanel = CCBasePanel:panelWithFile(_refWidth(0.5), _refHeight(0.5), 420, 360, "ui/lh_common/dialog_bg.png", 600, 600 )
    self.mainLoginPanel:setAnchorPoint(0.5,0.5)
    --账号绑定图片
    local t_t = MUtils:create_zximg(self.mainLoginPanel, "ui/lh_common/title_bg.png", 420/2, 370, -1, -1 )
    t_t:setAnchorPoint(0.5,1)
    local t_i = MUtils:create_zximg(self.mainLoginPanel,"ui2/login/ios_title.png", 420/2,370,-1, -1,500,500);
    t_i:setAnchorPoint(0.5, 1)
    --游客登录按钮
    local function guest_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
            --游客登录
            RoleModel:guest_get_server_list( ) 
         end
         return true;
    end

    local guest_btn = CCNGBtnMulTex:buttonWithFile(37, 231, 338, 70, "ui2/login/lh_ser_ios_bg.png",TYPE_MUL_TEX, 600, 600)
    guest_btn:registerScriptHandler(guest_btn_fun) 
    self.mainLoginPanel:addChild(guest_btn)
    MUtils:create_zximg(guest_btn,"ui2/login/guest_try.png", 120, 20, -1, -1,500,500);

    --注册按钮
    local function regist_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
             self:change_login_page(tLoginPage.eShowRegistPanel)
         end
         return true;
    end
    local regist_btn = CCNGBtnMulTex:buttonWithFile(37, 231-70, 338, 70, "ui2/login/lh_ser_ios_bg.png",TYPE_MUL_TEX, 600, 600)
    regist_btn:registerScriptHandler(regist_btn_fun) 
    self.mainLoginPanel:addChild(regist_btn)
    MUtils:create_zximg(regist_btn,"ui2/login/regist_acount.png", 120, 20, -1, -1,500,500);

    -- --gamecenter按钮
    -- local function gameCenter_btn_fun( eventType )
    --      if eventType == TOUCH_CLICK then
    --          if PlatformInterface.gamecenter_Login then
    --             PlatformInterface:gamecenter_Login()
    --          end
    --      end
    --      return true;
    -- end
    -- local gameCenter_btn = CCNGBtnMulTex:buttonWithFile(37, 231-70*2, 338, 70, "ui2/login/lh_ser_ios_bg.png",TYPE_MUL_TEX, 600, 600)
    -- gameCenter_btn:registerScriptHandler(gameCenter_btn_fun) 
    -- self.mainLoginPanel:addChild(gameCenter_btn)
    -- MUtils:create_zximg(gameCenter_btn,"ui2/login/gc_login.png", 70, 20, -1, -1,500,500);

    --已有账号登录
    local function login_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
            self:change_login_page(tLoginPage.eShowloginPanel)
            -- IOSDispatcher:open_CYSDK_LoginPage()
         end
         return true;
    end
    local login_btn = CCNGBtnMulTex:buttonWithFile(37, 231-70*2, 338, 70, "ui2/login/lh_ser_ios_bg.png",TYPE_MUL_TEX, 600, 600)
    login_btn:registerScriptHandler(login_btn_fun) 
    self.mainLoginPanel:addChild(login_btn)
    MUtils:create_zximg(login_btn,"ui2/login/normal_login.png", 90, 20, -1, -1,500,500);

    ------------------------注册页面-----------------------

    self.registPanel = CCBasePanel:panelWithFile(_refWidth(0.5), _refHeight(0.5), 420, 360, "ui/lh_common/dialog_bg.png", 600, 600 )
    self.registPanel:setAnchorPoint(0.5,0.5)

    local t_r = MUtils:create_zximg(self.registPanel, "ui/lh_common/title_bg.png", 420/2, 370, -1, -1 )
    t_r:setAnchorPoint(0.5,1)
    local t_r_i = MUtils:create_zximg(self.registPanel,"ui2/login/regist.png", 420/2,370,-1, -1,500,500);
    t_r_i:setAnchorPoint(0.5, 1)
    --4个输入框标题
    MUtils:create_zximg(self.registPanel,"ui2/login/acount.png", 36, 257, -1, -1,500,500);
    MUtils:create_zximg(self.registPanel,"ui2/login/lh_pwd.png", 36, 257-50, -1, -1,500,500);
    MUtils:create_zximg(self.registPanel,"ui2/login/check.png", 36, 257-50*2, -1, -1,500,500);
    MUtils:create_zximg(self.registPanel,"ui2/login/tel_num.png", 36, 257-50*3, -1, -1,500,500);

    --4个输入框地板
    MUtils:create_zximg(self.registPanel,UILH_COMMON.bg_03, 136, 250,230, 40,500,500);

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
            self:keyboard_will_show( keyboard_width, keyboard_height ,true); 
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height ,true);
        end
        return true
    end

    self.acont_text = CCZXEditBox:editWithFile( 136, 250, 230, 40, "", 26, 20, EDITBOX_TYPE_NORMAL )
    self.registPanel:addChild( self.acont_text )
    self.acont_text:registerScriptHandler(edit_box_function)
    
    ------------------------
    MUtils:create_zximg(self.registPanel,UILH_COMMON.bg_03, 136, 250-50,230, 40,500,500);

    self.psw_text = CCZXEditBox:editWithFile( 136, 250-50, 230, 40, "", 26, 20, EDITBOX_TYPE_PASSWORD )
    self.registPanel:addChild( self.psw_text )
    self.psw_text:registerScriptHandler(edit_box_function)

    ------------------------
    MUtils:create_zximg(self.registPanel,UILH_COMMON.bg_03, 136, 250-50*2,230, 40,500,500);

    self.psw_ag_text = CCZXEditBox:editWithFile( 136, 250-50*2, 230, 40, "", 26, 20, EDITBOX_TYPE_PASSWORD )
    self.registPanel:addChild( self.psw_ag_text )
    self.psw_ag_text:registerScriptHandler(edit_box_function)

    ------------------------

    MUtils:create_zximg(self.registPanel,UILH_COMMON.bg_03, 136, 250-50*3,230, 40,500,500);


    self.tel_text = CCZXEditBox:editWithFile( 136, 250-50*3, 230, 40, "", 26, 20, EDITBOX_TYPE_NORMAL )
    self.registPanel:addChild( self.tel_text )
    self.tel_text:registerScriptHandler(edit_box_function)


    --密码验证结果显示
    self.check_lable = UILabel:create_lable_2("", 210, 85, 18, ALIGN_CENTER)
    self.check_lable:setAnchorPoint(CCPoint( 0,0.5))
    self.registPanel:addChild( self.check_lable);

    --返回登录按钮
    local function back_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
            self:hide_keyboard()
            self:change_login_page(tLoginPage.eShowMainloginPanel)
         end
         return true;
    end
    local back_btn = CCNGBtnMulTex:buttonWithFile(37, 231-70*3-3, -1, -1, "ui/lh_common/btn4_blue.png", TYPE_MUL_TEX, 600, 600)
    back_btn:registerScriptHandler(back_btn_fun) 
    self.registPanel:addChild(back_btn)
    local back_btn_lab = MUtils:create_zximg(back_btn,"ui2/login/back.png", 121/2, 53/2, -1, -1,500,500);
    back_btn_lab:setAnchorPoint(0.5,0.5)

    --注册按钮
    local function registe_btn_fun( eventType )
         if eventType == TOUCH_CLICK then
             local acount_lbl = self.acont_text:getText()
             local psw_lbl = self.psw_text:getText()
             local psw_ag_lbl = self.psw_ag_text:getText()
             local tel_lbl = self.tel_text:getText()
             if acount_lbl==nil or acount_lbl=='' then
                self.check_lable:setText("#cff0000输入账号不能为空。")
                return
             end
             if psw_lbl==nil or psw_lbl=='' then
                self.check_lable:setText("#cff0000输入密码不能为空。")
                return
             end
             if psw_ag_lbl==nil or psw_ag_lbl=='' then
                self.check_lable:setText("#cff0000输入确认密码不能为空。")
                return
             end
             if psw_lbl==psw_ag_lbl then
                self.check_lable:setText("")
             else
                self.check_lable:setText("#cff0000两次输入密码不一致")
                return
             end
             --普通账号注册登录
             RoleModel:registe_and_get_server_list(acount_lbl,psw_lbl,tel_lbl)
             self:hide_keyboard()

         end
         return true;
    end
    local regist_btn = CCNGBtnMulTex:buttonWithFile(227, 231-70*3-3, -1, -1, "ui/lh_common/btn4_blue.png", TYPE_MUL_TEX, 600, 600)
    regist_btn:registerScriptHandler(registe_btn_fun) 
    self.registPanel:addChild(regist_btn)
    local regist_btn_lab = MUtils:create_zximg(regist_btn, "ui2/login/easy_reg.png", 121/2, 53/2, -1, -1,500,500);
    regist_btn_lab:setAnchorPoint(0.5,0.5)

    ----------------------------------------------------------------------------------------

    -----------------------已经有账号-登录页------------------------
    self.loginPanel = CCBasePanel:panelWithFile(_refWidth(0.5), _refHeight(0.5), 420, 360, "ui/lh_common/dialog_bg.png", 600, 600 )
    self.loginPanel:setAnchorPoint(0.5,0.5)


    self.view:addChild(self.mainLoginPanel)
    self.view:addChild(self.registPanel)
    self.view:addChild(self.loginPanel)
    -- self.view:addChild(self.guestPanel)

    self:change_login_page(tLoginPage.eShowMainloginPanel)

    ------------------------
    ------------------------
    --local temp_bg = ZImage:create( temp_bg, "ui2/login/grid_15.png", 209, 149, 380, 240, nil, 600, 600 )
    --temp_bg.view:setAnchorPoint(0.5,0.5)
    ------------------------

    local t_l_l = MUtils:create_zximg(self.loginPanel, "ui/lh_common/title_bg.png", 420/2, 370, -1, -1 )
    t_l_l:setAnchorPoint(0.5,1)
    local t_l_l_i = MUtils:create_zximg(self.loginPanel,"ui2/login/ios_title.png", 420/2,370,-1, -1,500,500);
    t_l_l_i:setAnchorPoint(0.5, 1)

    -- local spr = CCSprite:spriteWithFile('ui2/login/reg_title.png')
    -- self.loginPanel:addChild(spr)
    -- spr:setPosition(221,305)
    -- spr:setTag(0)

    -- local spr = CCSprite:spriteWithFile('ui2/login/kuwu.png')
    -- self.loginPanel:addChild(spr)
    -- spr:setPosition(313,322)
    -- spr:setTag(0)

    -- 名称输入
    -- self.enter_name_lable = UILabel:create_lable_2( "用户名", 260 + 20, 235 - 30, 20, ALIGN_RIGHT )
    -- self.view:addChild( self.enter_name_lable )
    self.loginPanel:addChild( CCZXImage:imageWithFile( 18, 207, -1, -1, "ui2/login/acount.png" ) )
    self.loginPanel:addChild( CCZXImage:imageWithFile( 106, 196, 225, 47, UILH_COMMON.bg_03, 500, 500 ) )
    self.name_enter_frame = CCZXEditBox:editWithFile( 110, 196, 225 - 20, 47, "", 26, 20, EDITBOX_TYPE_NORMAL )
    self.loginPanel:addChild( self.name_enter_frame )
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

    ZImageButton:create( self.loginPanel, "ui/lh_common/button4.png", "ui2/login/switch.png", qiehuan_but_CB, 332, 205)
    -- ZButton:create( self.loginPanel, "ui2/login/switch.png", qiehuan_but_CB, 332, 202 )
    -- local qiehuan_but = UIButton:create_button_with_name( 513 + 20, 233 - 40, -1, -1, "ui2/login/qiehuan_but_bg.png", "ui2/login/qiehuan_but_bg.png", nil, "", qiehuan_but_CB )
    -- self.view:addChild( qiehuan_but )

    -- 密码输入
    -- local enter_password_lable = UILabel:create_lable_2( "密  码", 260 + 20, 185 - 3 - 30, 20, ALIGN_RIGHT )
    -- self.view:addChild( enter_password_lable )
    self.loginPanel:addChild( CCZXImage:imageWithFile( 15, 141, -1, -1, "ui2/login/lh_pwd.png" ) )
    self.loginPanel:addChild( CCZXImage:imageWithFile( 106, 131, 225, 47, UILH_COMMON.bg_03, 500, 500 ) )
    self.password_enter_frame = CCZXEditBox:editWithFile( 110, 131, 225 - 20, 47, "", 26, 20, EDITBOX_TYPE_PASSWORD, 500, 500)
    
    require "model/RoleModel"
    self.password_changed = false
    -------
    local function editBoxMessageFun(eventType, arg, msgid, selfItem)
        -- print(eventType, KEYBOARD_CLICK, KEYBOARD_BACKSPACE, KEYBOARD_ATTACH  )
        -------
        if eventType == nil then
            return 
        -------
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

    self.loginPanel:addChild( self.password_enter_frame )

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

    -- 快速注册
    local function quick_but_CB(  )
        -- 记录快速登录用户
        if BISystem.fat_register then
            BISystem:fat_register()
        end
         RoleModel:request_quick_play(  )         
    end
    --返回登录
    local function back_but_cb(  )
        self:hide_keyboard(  )
        self:change_login_page(tLoginPage.eShowMainloginPanel)
    end
    local _filePath1 = "ui2/login/back.png"
    local _filePath2 = "ui/lh_common/btn4_blue.png"
    local _cb_fun = back_but_cb

    if PlatformInterface.isNoPlatform then
        _filePath1="ui2/login/easy_reg.png"
        _cb_fun=quick_but_CB
        self:change_login_page(tLoginPage.eShowloginPanel)
    end
    ZImageButton:create( self.loginPanel,  _filePath2,_filePath1, _cb_fun ,  52, 35  )
    -- local quick_but = UIButton:create_button_with_name( 360, 30, -1, -1, "ui2/login/down_but.png", "ui2/login/down_but.png", nil, "", quick_but_CB )
    -- UIButton:set_button_image_name( quick_but, -35, -15, -1, -1, "ui2/login/but_kuaisuyouxi.png"  )
    -- self.view:addChild( quick_but )

    -- 登录
    local function login_but_CB(  )
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
            --普通账号登录
            PlatformInterface:onLoginResult(0, { ['uid'] = tmepinfo, 
                                                 ['pwd'] = tmppass,
                                                 ['password_changed'] = password_changed,
                                                 ['platformType'] = MSDK_TYPE.ePlatform_normal
                                                } 
                                            )
            -- self.password_changed = false
            self:hide_keyboard()
        end
    end

    self.login_func = login_but_CB;

    ZImageButton:create( self.loginPanel, "ui/lh_common/btn4_blue.png", 
                                          "ui2/login/login_btn_label.png", login_but_CB,219, 35)

    -- local login_but = UIButton:create_button_with_name( 665, 30, -1, -1, "ui2/login/enter_but.png", "ui2/login/enter_but.png", nil, "", login_but_CB )

    -- UIButton:set_button_image_name( login_but, -35, -15, -1, -1, "ui2/login/denglu.png"  )
    -- self.view:addChild( login_but )

    -- 声音
    -- self:sound_switch(  )

    --self.enter_name_lable = nil
end



-- 创建一个用户名称菜单
function LoginPageIos:create_user_list(  )
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
    end
    local dynamicMenu = DynamicMenu:create_menu( name_t, menu_top_x, menu_top_y, 
                                                 DynamicMenu.COORDINATE_TYPE_TOP, 220, 
                                                 'ui2/login/lh_ser_ios_bg.png', 
                                                 item_callback ,
                                                 UILH_COMMON.bg_03,
                                                 { 0xffb0b0b0, 0xffd0d0d0 } )
    dynamicMenu:setPosition(_rx(488),_ry(318))
    return dynamicMenu
end

-- 显示用户名菜单
function LoginPageIos:show_user_list(  )
    local menu_bg = CCBasePanel:panelWithFile( 0, 0, _refWidth(1.0), _refHeight(1.0), "", 500, 500 )
    local menu = self:create_user_list(  )
    menu:setAnchorPoint(0.5,0.5)
    menu_bg:addChild( menu )
    self.view:addChild( menu_bg )

    local function f1(eventType,x,y)
        if eventType == TOUCH_ENDED then                             
            self.view:removeChild( menu_bg, true )                                               -- 直接关闭alert
            return true
        elseif eventType then
            return true
        end
    end
    menu:registerScriptHandler(f1)

    local function f2(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            self.view:removeChild( menu_bg, true )
            return true
        end
        return true
    end
    menu_bg:registerScriptHandler(f2)
end

-- 声音控制
function LoginPageIos:sound_switch(  )
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
function LoginPageIos:update( update_type )
    if update_type == "all" then 
        _name = CCUserDefault:sharedUserDefault():getStringForKey("user_name")
        self.name_enter_frame:setText( _name )

        local pw = RoleModel:getPassword(_name)
        if pw  then
            self.password_enter_frame:setText(pw)
        end
    end
end

function LoginPageIos:RemoveBindPanel(  )

    if _bindRegistPanel then
        _bindRegistPanel:removeFromParentAndCleanup(true) 
        _bindRegistPanel=nil
    end
    if _bindGuestPanel then
        _bindGuestPanel:removeFromParentAndCleanup(true) 
        _bindGuestPanel=nil
    end

    self:hide_keyboard(  )
end

function LoginPageIos:destroy(  )
    self.view:release()
    self:hide_keyboard()
end

-- 隐藏  
function LoginPageIos:hide_to_left( page_name )
    if page_name == "register" then 
        self:hide_to_right(  )
    else
        local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( -_refWidth(1.0), 0 ));          -- 动画
        self.view:runAction( moveto );
    end
end

function LoginPageIos:hide_to_right(  )
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( _refWidth(1.0), 0 ));          -- 动画
    self.view:runAction( moveto );
end

-- 显示
function LoginPageIos:show_to_center( show_type )
    if show_type == "select_server" then 
        self.view:setPosition( -800, 0 )
    end
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( 0, 0 ));          -- 动画
    self.view:runAction( moveto );
end

-- 键盘事件
function LoginPageIos:keyboard_will_show( keyboard_w, keyboard_h ,is_registe_page)
    local _current_page =self.loginPanel
    if is_registe_page==true then
        _current_page=self.registPanel
    end
    self.is_keyboard_show=true
    if _current_page==nil then
        return
    end
    local move_call = callback:new()
    local function callback_func(  )
        if keyboard_h == 162 then--ip eg
            _current_page:setPosition(_refWidth(0.5),480);
        elseif keyboard_h == 198 then---ip cn
            _current_page:setPosition(_refWidth(0.5),530);
        elseif keyboard_h == 352 then --ipad eg
            _current_page:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 406 then --ipad cn
            _current_page:setPosition(_refWidth(0.5),480);
        end
    end
    move_call:start(0.3, callback_func)
end

function LoginPageIos:keyboard_will_hide( keyboard_w, keyboard_h,is_registe_page )
    local _current_page =self.loginPanel
    if is_registe_page==true then
        _current_page=self.registPanel
    end
    if _current_page==nil then
        return
    end
    self.is_keyboard_show=false
    -- self.input_bg:setPosition(self.input_ori_x,self.input_ori_y);
    _current_page:setPosition(_refWidth(0.5),_refHeight(0.5));

end

-------------------- 手动关闭键盘
function LoginPageIos:hide_keyboard(  )
    if self.name_enter_frame and self.is_keyboard_show then
        self.name_enter_frame:detachWithIME()
    end
    if self.password_enter_frame and self.is_keyboard_show then
        self.password_enter_frame:detachWithIME()
    end

    if self.acont_text and self.is_keyboard_show then
        self.acont_text:detachWithIME()
    end

    if self.psw_text and self.is_keyboard_show then
        self.psw_text:detachWithIME()
    end

    if self.psw_ag_text and self.is_keyboard_show then
        self.psw_ag_text:detachWithIME()
    end

    if self.tel_text and self.is_keyboard_show then
        self.tel_text:detachWithIME()
    end

end

