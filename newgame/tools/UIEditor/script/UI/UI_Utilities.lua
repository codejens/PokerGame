
local STRING_AUTOFIX_DIALOG0       = '#c00ff00修复游戏'
local STRING_AUTOFIX_DIALOG1       = '#cffff00当您无法正常登录或进行游戏时'
local STRING_AUTOFIX_DIALOG2       = '#cffff00请尝试修复游戏，还原到原始版本'
local STRING_AUTOFIX_DIALOG3       = '#cffff00还原完成需重新启动游戏'
local STRING_AUTOFIX_DIALOG4       = '#cffff00重新更新后即可修复问题'
local STRING_CANCEL   =     '取消'
local STRING_QUIT     =     '退出'
local STRING_FIX      =     '修复'
local STRING_RECONNECT0 = '连接中断'
local STRING_RECONNECT1 = '与服务器失去连接，请检看你的网络'
local STRING_RECONNECT2 = '连接网络后重连。'
local DialogDepth = 1024

UI_Utilities = {}

function UI_Utilities.DestroyFixButton()
	if UI_Utilities.view then
		UI_Utilities.view:removeFromParentAndCleanup(true)
		UI_Utilities.view = nil
	end
end

function UI_Utilities.AutofixDialog()
    if UI_Utilities.popup ~= nil then
        return
    end
    local msglist = { STRING_AUTOFIX_DIALOG0, 
                      STRING_AUTOFIX_DIALOG1,
                      STRING_AUTOFIX_DIALOG2,
                      STRING_AUTOFIX_DIALOG3,
                      STRING_AUTOFIX_DIALOG4 }

    UI_Utilities.popup = PopupNotify( UI_Utilities.root,
                             DialogDepth, msglist,
                             STRING_FIX,STRING_CANCEL,POPUP_YES_NO,
                             function(s)
                                if s then
                                    UpdateManager:Autofix(true, true)
                                end
                                UI_Utilities.popup = nil
                                return false
                             end)
end

function UI_Utilities.CreateFixButton()
	UI_Utilities.DestroyFixButton()
	if UI_Utilities.root == nil then
        UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
    end

    local x = UIScreenPos.relativeWidth(0.85)
    local y = UIScreenPos.relativeHeight(0.91)
	UI_Utilities.view = UI_Utilities.create_button_with_name( x, y, 
											    -1, -1, 
												UILH_COMMON.btn4_task, UILH_COMMON.btn4_task, 
												nil, function()
												UI_Utilities.AutofixDialog()
											end)
    local btn_fix_txt = UILabel:create_lable_2( LH_COLOR[2] .. "修复游戏", 120*0.5, 20, 15, ALIGN_CENTER )
    UI_Utilities.view:addChild( btn_fix_txt )
    UI_Utilities.root:addChild( UI_Utilities.view,99999 )
    --91平台不给加修复按钮，故隐藏掉
    if Target_Platform == Platform_Type.Platform_91 then
        UI_Utilities.view:setIsVisible(false)
    end
end




------------------------
----HJH
----2015-4-13
----add clear resource function
function UI_Utilities.DestroyResourceButton()
    if UI_Utilities.view_res then
        UI_Utilities.view_res:removeFromParentAndCleanup(true)
        UI_Utilities.view_res = nil
    end
end

function UI_Utilities.AutoResourcefixDialog()
    if UI_Utilities.res_popup ~= nil then
        return
    end
    local msglist = { STRING_AUTOFIX_DIALOG0, 
                      STRING_AUTOFIX_DIALOG1,
                      STRING_AUTOFIX_DIALOG2,
                      STRING_AUTOFIX_DIALOG3,
                      STRING_AUTOFIX_DIALOG4 }

    UI_Utilities.res_popup = PopupNotify( UI_Utilities.root,
                             DialogDepth, msglist,
                             STRING_FIX,STRING_CANCEL,POPUP_YES_NO,
                             function(s)
                                if s then
                                    UpdateManager:AutofixResource(true, true)
                                end
                                UI_Utilities.res_popup = nil
                                return false
                             end)
end

function UI_Utilities.CreateResourceFixButton()
    UI_Utilities.DestroyResourceButton()
    if UI_Utilities.root == nil then
        UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
    end

    local x = UIScreenPos.relativeWidth(0.70)
    local y = UIScreenPos.relativeHeight(0.91)
    UI_Utilities.view_res = UI_Utilities.create_button_with_name( x, y, 
                                                -1, -1, 
                                                UILH_COMMON.btn4_task, UILH_COMMON.btn4_task, 
                                                nil, function()
                                                UI_Utilities.AutoResourcefixDialog()
                                            end)
    local btn_fix_txt = UILabel:create_lable_2( LH_COLOR[2] .. "修复资源", 120*0.5, 20, 15, ALIGN_CENTER )
    UI_Utilities.view_res:addChild( btn_fix_txt )
    UI_Utilities.root:addChild( UI_Utilities.view_res,99999 )
    --91平台不给加修复按钮，故隐藏掉
    if Target_Platform == Platform_Type.Platform_91 then
        UI_Utilities.view_res:setIsVisible(false)
    end
end




------------------------
-- 登录状态
-- =======================================
-- 创建一个带有自定义文字的按钮。 目前只支持中文  lyl
-- but_x, but_y, but_w, but_h: 按钮坐标和大小
-- image_n, image_s, image_d： 本别是常态、按下、无效状态下的图片路径,  image_s 和 image_d 可以是nil
-- but_name  字符串 按钮的名称  可以不填。如果不填，就显示 空字符串
-- callback_fun 回调函数        可以不填，不填就不回调
-- if_nine_grid： 是否使用九宫格创建
-- ========================================
function UI_Utilities.create_button_with_name( but_x, but_y, but_w, but_h, image_n, image_s, texturelabel, callback_fun, if_nine_grid )
    local but_1
    if if_nine_grid then
       but_1 = CCNGBtnMulTex:buttonWithFile( but_x, but_y, but_w, but_h, image_n, 500, 500 )
    else
       but_1 = CCNGBtnMulTex:buttonWithFile( but_x, but_y, but_w, but_h, image_n)
    end
    local btn_script = {}
    btn_script.double_click_func = nil     -- 双击事件
    if image_s then
        but_1:addTexWithFile( CLICK_STATE_DOWN, image_s )
    end
    if image_d then
        --but_1:addTexWithFile(CLICK_STATE_DISABLE, image_d )
    end
    local function but_1_fun(eventType, arg, msgid, selfItem)
        if eventType == nil or arg == nil or msgid == nil or selfItem == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return  true
        elseif eventType == TOUCH_CLICK then 
            if callback_fun then
                callback_fun()
            end
            return true
        elseif eventType == TOUCH_DOUBLE_CLICK then 
            if btn_script.double_click_func then
                btn_script.double_click_func()
            end
            return true
        end
    end
    local s = CCSprite:spriteWithFile(texturelabel);
    s:setPosition(CCPointMake(49,16))
    but_1:addChild(s)
    but_1:registerScriptHandler(but_1_fun)                  --注册
    return but_1 
end

function UI_Utilities.showReconnectDialog(state)
    if state then
        if UI_Utilities.reconnectDialog then
            return
        end
        if UI_Utilities.root == nil then
            UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
        end

        local ww = GameScreenConfig.ui_screen_width
        local hh = GameScreenConfig.ui_screen_height
        local dialog = CCBasePanel:panelWithFile( 0, 0, ww, hh, 'nopack/blocked.png')

        dialog:registerScriptHandler(function(...) return true end);
        
        local spr_bg = CCBasePanel:panelWithFile( ww * 0.5,  hh * 0.5 , 420, 240, UILH_COMMON.bg_04, 500, 500 )

        local s0 = CCScaleTo:actionWithDuration(0.2,1.1);
        local s1 = CCScaleTo:actionWithDuration(0.25,1.0);

        local array = CCArray:array();
        array:addObject(s0);
        array:addObject(s1);
        local seq = CCSequence:actionsWithArray(array);
        spr_bg:runAction( seq );
        spr_bg:setAnchorPoint(0.5,0.5)


        local t0 = CCZXLabel:labelWithText(0,0,STRING_RECONNECT0,24);
        local l0 = CCZXLabel:labelWithText(0,0,STRING_RECONNECT1,20);
        local l1 = CCZXLabel:labelWithText(0,0,STRING_RECONNECT2,20);

        t0:setPosition(210, 206)
        l0:setPosition(210, 168)
        l1:setPosition(210, 132)

        t0:setAnchorPoint(CCPointMake(0.5,0.5))
        l0:setAnchorPoint(CCPointMake(0.5,0.5))
        l1:setAnchorPoint(CCPointMake(0.5,0.5))
        --local line = CCSprite:spriteWithFile("ui/common/line.png")
        --line:setPosition(160,100)
        spr_bg:addChild(line)
        spr_bg:addChild(t0)
        spr_bg:addChild(l0)
        spr_bg:addChild(l1)

        local btn = CCNGBtnMulTex:buttonWithFile(60,38,312,53,UILH_COMMON.btn4_nor,TYPE_MUL_TEX,500,500);
        btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.btn4_nor )
        --btn_hui2
        btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis )
        local btnlabel = CCZXLabel:labelWithText(312/2,30,"#cffffcf重新连接服务器",20);
        btnlabel:setAnchorPoint(CCPointMake(0.5,0.5))
        btn:addChild(btnlabel,10)
        spr_bg:addChild(btn)
        dialog:addChild(spr_bg)
        UI_Utilities.root:addChild(dialog,Z_ABOVE_LOADING)
        UI_Utilities.reconnectDialog = dialog
        local func = function(eventType,x,y)
                if eventType == TOUCH_CLICK then
                    NetManager:reconnectSocket()
                    UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
                    UI_Utilities.reconnectDialog = nil
                    return true;
                end
            end
        btn:registerScriptHandler(func);
        UI_Utilities.reconnectDialogLastClick = os.clock()
    else
        if UI_Utilities.reconnectDialog then
            UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
            UI_Utilities.reconnectDialog = nil
        end
    end
end

--------------系统公告移到跟修复按钮一起了----------------
--------------adby by mwy on 2014-08-20-------------------

function UI_Utilities.DestroyAdButton()
    if ( UI_Utilities.xtgg_panel ) then
        UI_Utilities.xtgg_panel:removeFromParentAndCleanup(true);
        UI_Utilities.xtgg_panel = nil;
    end
    if UI_Utilities.whgg_btn then 
        UI_Utilities.whgg_btn:removeFromParentAndCleanup(true);
        UI_Utilities.whgg_btn = nil;
    end    
end

function UI_Utilities.CreateAdButton()
    UI_Utilities.DestroyAdButton()
    if UI_Utilities.root == nil then
        UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
    end

    local x = UIScreenPos.relativeWidth(0.70)
   -- local y = UIScreenPos.relativeHeight(0.788888)
     local y = UIScreenPos.relativeHeight(0.89)

    local function whgg_fun( eventType,msg_id,args)
        if eventType == TOUCH_CLICK then
            if ( UI_Utilities.xtgg_panel ) then
                UI_Utilities.xtgg_panel:removeFromParentAndCleanup(true);
                UI_Utilities.xtgg_panel = nil;
            else
                UI_Utilities.xtgg_panel = SelectServerPage:show_announcement()
                UI_Utilities.root:addChild(UI_Utilities.xtgg_panel,99);
            end
        end
        return true;
    end

    UI_Utilities.whgg_btn = MUtils:create_btn( UI_Utilities.root,"ui2/login/system_info_btn.png",
                                                 "ui2/login/system_info_btn.png",
                                                 whgg_fun,x,y,-1,-1,99999);
end
