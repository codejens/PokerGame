-- WelcomeWin.lua
-- created by aXing on 2013-1-23
-- 欢迎界面

require "UI/component/Window"
super_class.WelcomeWin(Window)

_bg_panel = nil

--求相对屏幕大小的函数
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local target_arr = {
    
}
function WelcomeWin:__init( window_name, texture_name, pos_x, pos_y, width, height )
    UIManager:showMainUI(false)
    print("============WelcomeWin:__init( window_name, texture_name, pos_x, pos_y, width, height )================")
    -- 欢迎按钮点击事件
    local function welcome_btn_on_click( eventType, x, y )
        if eventType == TOUCH_BEGAN  then
            if BISystem.click_welcome_win then
                BISystem:click_welcome_win()
            end
            require "control/GameLogicCC"
            LuaEffectManager:stop_view_effect( 11028,_bg_panel );
            LuaEffectManager:stop_view_effect( 11036, self.view );
            Instruction:clear_jt_animation()
            GameLogicCC:req_talk_to_npc(0, "startPlay")     -- 这是跟服务器约定的
            UIManager:destroy_window("welcome_win")
            UIManager:showMainUI(true)
            return true
        end
        return true
    end
    -- 点击任何地方，都开始游戏
    self.view:registerScriptHandler(welcome_btn_on_click)

    local is_hoolai = Target_Platform == Platform_Type.Platform_Hoolai or Target_Platform == Platform_Type.Platform_Hoolai2

    -- 背景图
    -- local bg_1 = CCZXImage:imageWithFile( _refWidth(0.5555), 283, -1, -1, "ui2/welcome/welcome_bg.png" )
    -- bg_1:setAnchorPoint(0.5, 0.5)
    -- self.view:addChild( bg_1 )

    -- local welcome_btn = ZImage:create( bg_1, "ui2/welcome/welcome_btn.png", 170, 40 )
    
    -- 妹子(appstore审核版暂时去掉妹子 )
    -- local gril = ZImage:create( bg_1, "nopack/npc_1_full.png", -81, -90 )
    -- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
    -- if is_ckeck_version then

    --     local bg_1 = CCZXImage:imageWithFile( _refWidth(0.5555), 283, -1, -1, "ui2/welcome/welcome_bg1.png" )
    --     bg_1:setAnchorPoint(0.5, 0.5)
    --     self.view:addChild( bg_1 )

    --     local beauty = CCZXImage:imageWithFile(70, 120, -1, -1, "nopack/body/10.png")
    --     self.view:addChild(beauty)
    -- else
        local bg_1 = CCBasePanel:panelWithFile(_refWidth(0.55), _refHeight(0.47), 603, 340, "ui2/welcome/welcome_bg.png", 600, 600)
        -- local bg_1 = CCZXImage:imageWithFile( _refWidth(0.5), _refHeight(0.55), -1, -1, "ui2/welcome/welcome_bg.png" )
        bg_1:setAnchorPoint(0.5, 0.5)
        self.view:addChild( bg_1 )
        _bg_panel = bg_1
        local lion_bg = CCZXImage:imageWithFile(120, 255, -1, -1, "ui2/welcome/lion.png")
        if not is_hoolai then
            --如果是生菜  不需要添加狮子背景图
            if Target_Platform ==Platform_Type.Platform_SC or Target_Platform == Platform_Type.Platform_Any
             or Target_Platform == Platform_Type.Platform_SD or Target_Platform ==Platform_Type.Platform_sy 
             or Target_Platform == Platform_Type.Platform_Sogou or Target_Platform == Platform_Type.Platform_ZS 
             or Target_Platform == Platform_Type.Platform_YXD or Target_Platform == Platform_Type.Platform_YL 
             or Target_Platform == Platform_Type.Platform_DY then
            else
               bg_1:addChild(lion_bg)
            end
         
        end
        local gril = CCZXImage:imageWithFile(-144, 1, -1, -1, "ui2/welcome/welcome_cool.png")
        bg_1:addChild(gril)

        local is_test_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_test_version")
        if is_test_version then
            local title = CCZXImage:imageWithFile(153, 195, -1, -1, "nopack/login_logo_test.png")
            bg_1:addChild(title)
        elseif is_hoolai then
            local img_path = "nopack/login_logo5.png"
            if Target_Platform == Platform_Type.Platform_Hoolai2 then
                img_path = "nopack/login_logo7.png"
            end
            local title = CCZXImage:imageWithFile(131, 256, 450, 200, img_path)
            bg_1:addChild(title)
        --如果是生菜  需要另换logo图
        elseif  Target_Platform ==Platform_Type.Platform_SC or Target_Platform == Platform_Type.Platform_SD 
            or Target_Platform == Platform_Type.Platform_Any or Target_Platform ==Platform_Type.Platform_sy 
            or  Target_Platform ==Platform_Type.Platform_Sogou or  Target_Platform == Platform_Type.Platform_ZS 
              or Target_Platform == Platform_Type.Platform_YXD or Target_Platform == Platform_Type.Platform_YL 
              or Target_Platform == Platform_Type.Platform_DY then 
            local title = CCZXImage:imageWithFile(131, 256, 450, 200, "nopack/login_logo6.png")
            bg_1:addChild(title)
        else
            local title = CCZXImage:imageWithFile(131, 251, 400, 176, "nopack/login_logo.png")
            bg_1:addChild(title)
        end

        local light = CCZXImage:imageWithFile(80, 269, -1, -1, "ui2/welcome/light.png")
        if not is_hoolai then
             if Target_Platform ==Platform_Type.Platform_SC or Target_Platform == Platform_Type.Platform_Any
             or Target_Platform == Platform_Type.Platform_ZS or Target_Platform == Platform_Type.Platform_sy 
             or Target_Platform == Platform_Type.Platform_SD or Target_Platform == Platform_Type.Platform_Sogou 
               or Target_Platform == Platform_Type.Platform_YXD then
            else
                 bg_1:addChild(light)
            end
        end
        local text1 = CCZXImage:imageWithFile(174, 180, -1, -1, "ui2/welcome/text1.png")
        local text2 = CCZXImage:imageWithFile(193, 112, -1, -1, "ui2/welcome/text2.png")
        local text3 = CCZXImage:imageWithFile(357, 84, -1, -1, "ui2/welcome/text3.png")
        bg_1:addChild(text1)
        bg_1:addChild(text2)
        bg_1:addChild(text3)
        local px, py = UIScreenPos.calculateScreenPos(627, 145, 5)
        -- local btn_bg = CCZXImage:imageWithFile(px-5, py-4, -1, -1, "ui2/welcome/btn_light.png")
        -- self.view:addChild(btn_bg)

        local function btn_fun()
            if BISystem.click_welcome_win then
                BISystem:click_welcome_win()
            end
            require "control/GameLogicCC"
            Instruction:clear_jt_animation()
            -- LuaEffectManager:stop_view_effect( 11028, _bg_panel );
            -- LuaEffectManager:stop_view_effect( 11036, self.view );
            GameLogicCC:req_talk_to_npc(0, "startPlay")     -- 这是跟服务器约定的
            UIManager:destroy_window("welcome_win")
            UIManager:showMainUI(true)
        end
        Instruction:play_jt_animation(627, 145, 162, 53, 3, 5, "nopack/ani_xszy2.png", "nopack/xszy/5.png")
        local btn = ZImageButton:create(self.view, UILH_NORMAL.special_btn, "ui2/welcome/start.png", btn_fun, px, py, -1, -1)
        -- btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn)
        -- btn.view:setCurState(CLICK_STATE_DISABLE)
        -- local eff = LuaEffectManager:play_view_effect(11028, 349, 301, _bg_panel, true)
        -- eff:setScale(1.2)
        local lx, ly = UIScreenPos.calculateScreenPos(709, 170, 5)
        -- LuaEffectManager:play_view_effect(11036, lx, ly, self.view, true)
        -- if Target_Platform == Platform_Type.Platform_91 or Target_Platform == Platform_Type.Platform_ap  then
        --     local beauty = CCZXImage:imageWithFile(70, 120, -1, -1, "nopack/body/10.png")
        --     self.view:addChild(beauty)
        -- else
        --     local gril = ZImage:create( bg_1, "nopack/npc_1_full.png", -81, -90 )
        -- end

    -- end   

        if BISystem.enter_welcome_win then
            BISystem:enter_welcome_win()
        end


 --    -- 欢迎语
 --    local welcome_world_lable = CCDialogEx:dialogWithFile( 160, 120, 370, 50, 1000, nil, 1, ADD_LIST_DIR_UP)
 --    local content = "      千年的宿命恩怨,让我们在此相遇.踏歌屠魔."
 --    welcome_world_lable:setText( content )
 --    bg_1:addChild( welcome_world_lable )

 --    local welcome_world_lable_2 = CCDialogEx:dialogWithFile( 160, 92, 370, 50, 1000, nil, 1, ADD_LIST_DIR_UP)
 --    content = "斩道问仙,上古,因你而改变."
 --    welcome_world_lable_2:setText( content )
 --    bg_1:addChild( welcome_world_lable_2 )

	-- local welcome_btn = CCTextButton:textButtonWithFile(128 + 427, 96 + 14, 122, 41, "", "ui2/welcome/start_but.png");
 --    welcome_btn:registerScriptHandler(welcome_btn_on_click)
	-- self:addChild(welcome_btn)

    ----------------------------------------新手指引--------------------------------------------------
    -- XSZYManager:play_jt_and_kuang_animation( 387,164, 5,3,172+38,68,XSZYConfig.OTHER_SELECT_TAG )

end
