--UI_Utilities.lua
--UI工具

UI_Utilities = {}

local STRING_AUTOFIX_DIALOG0 = "#c00ff00修复游戏"
local STRING_AUTOFIX_DIALOG1 = "#c4d2308当您无法正常登录或进行游戏时"
local STRING_AUTOFIX_DIALOG2 = "#c4d2308请尝试修复游戏，还原到原始版本"
local STRING_AUTOFIX_DIALOG3 = "#c4d2308还原完成需重新启动游戏"
local STRING_AUTOFIX_DIALOG4 = "#c4d2308重新更新后即可修复问题"
local STRING_CANCEL          = "取消"
local STRING_QUIT            = "退出"
local STRING_FIX             = "修复"
local STRING_RECONNECT0      = "#c854c0f网络状态不是很好哦，请重连试试吧~"
local STRING_RECONNECT1      = "#c854c0f与服务器失去连接，请检看你的网络"
local STRING_RECONNECT2      = "#c854c0f连接网络后重连。"
local STRING_RECONNECT3      = "#c854c0f昵称更改成功，需要重新登录游戏哦!"
local STRING_RECONNECT4      = "#c854c0f您的角色已在另一处登录，如非本人操作请尽快修改密码或联系客服哟！"
local DialogDepth            = 1024

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
    local msglist = {STRING_AUTOFIX_DIALOG0, 
                    STRING_AUTOFIX_DIALOG1,
                    STRING_AUTOFIX_DIALOG2,
                    STRING_AUTOFIX_DIALOG3,
                    STRING_AUTOFIX_DIALOG4}
    UI_Utilities.popup = PopupNotify(UI_Utilities.root, DialogDepth, msglist, STRING_FIX,STRING_CANCEL,
                                    POPUP_YES_NO, function(s)
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
	UI_Utilities.view = UI_Utilities.create_button_with_name(x, y, -1, -1, "sui/common/btn_1.png",
                                                            "sui/common/btn_1.png", 
                												nil, function()
                												UI_Utilities.AutofixDialog()
                											end)
    local btn_fix_txt = UILabel:create_lable_2(LH_COLOR[2].."修复游戏", 120*0.5, 20, 15, ALIGN_CENTER)
    UI_Utilities.view:addChild(btn_fix_txt)
    UI_Utilities.root:addChild(UI_Utilities.view, 99999)
    --91平台不给加修复按钮，故隐藏掉
    if Target_Platform == Platform_Type.Platform_91 then
        UI_Utilities.view:setIsVisible(false)
    end
    UI_Utilities.view:setIsVisible(false)
end

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
    local msglist = {STRING_AUTOFIX_DIALOG0, 
                    STRING_AUTOFIX_DIALOG1,
                    STRING_AUTOFIX_DIALOG2,
                    STRING_AUTOFIX_DIALOG3,
                    STRING_AUTOFIX_DIALOG4}
    UI_Utilities.res_popup = PopupNotify(UI_Utilities.root, DialogDepth, msglist, STRING_FIX,STRING_CANCEL,
                                        POPUP_YES_NO, function(s)
                                            if s then
                                                UpdateManager:AutofixResource()
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
    UI_Utilities.view_res = UI_Utilities.create_button_with_name(x, y, -1, -1, "sui/common/btn_1.png", "sui/common/btn_1.png", 
                                                                    nil, function()
                                                                    UI_Utilities.AutoResourcefixDialog()
                                                                end)
    local btn_fix_txt = UILabel:create_lable_2(LH_COLOR[2].."修复资源", 120*0.5, 20, 15, ALIGN_CENTER)
    UI_Utilities.view_res:addChild(btn_fix_txt)
    UI_Utilities.root:addChild(UI_Utilities.view_res, 99999)
    --91平台不给加修复按钮，故隐藏掉
    if Target_Platform == Platform_Type.Platform_91 then
        UI_Utilities.view_res:setIsVisible(false)
    end
    UI_Utilities.view_res:setIsVisible(false)
end

function UI_Utilities.create_button_with_name(but_x, but_y, but_w, but_h, image_n, image_s, texturelabel, callback_fun, if_nine_grid)
    local but_1
    if if_nine_grid then
       but_1 = CCNGBtnMulTex:buttonWithFile(but_x, but_y, but_w, but_h, image_n, 500, 500)
    else
       but_1 = CCNGBtnMulTex:buttonWithFile(but_x, but_y, but_w, but_h, image_n)
    end
    local btn_script = {}
    btn_script.double_click_func = nil     --双击事件
    if image_s then
        but_1:addTexWithFile(CLICK_STATE_DOWN, image_s)
    end
    if image_d then
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
    local s = CCSprite:spriteWithFile(texturelabel)
    s:setPosition(CCPointMake(49, 16))
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
        local dialog = CCBasePanel:panelWithFile(0, 0, ww, hh, "nopack/blocked.png")
        dialog:registerScriptHandler(function(...) return true end)

        local spr_bg = CCBasePanel:panelWithFile(ww/2, hh*0.528, 438, 270, "sui/common/tipsPanel.png", 500, 500)
        spr_bg:setAnchorPoint(0.5, 0.5)
        spr_bg:setDefaultMessageReturn(true)

        local title_bg = CCBasePanel:panelWithFile(219, 272, 484, -1, "sui/common/little_win_title_bg.png", 500, 500)
        title_bg:setAnchorPoint(0.5, 1)
        spr_bg:addChild(title_bg, 1)

        local title_bg1 = CCBasePanel:panelWithFile(219, 264, 444, -1, "sui/common/title_panel.png", 500, 500)
        title_bg1:setAnchorPoint(0.5, 1)
        spr_bg:addChild(title_bg1)

        local title_label = CCZXLabel:labelWithText(222, 12, "#cf3e2c5提示", 26)
        title_label:setAnchorPoint(CCPointMake(0.5, 0))
        title_bg1:addChild(title_label)

        local down_bg = CCBasePanel:panelWithFile(219, 0, 458, -1, "sui/common/win_down.png", 500, 500)
        down_bg:setAnchorPoint(0.5, 0)
        spr_bg:addChild(down_bg, 1)

        local text = CCZXLabel:labelWithText(219, 133, STRING_RECONNECT0, 18)
        text:setAnchorPoint(CCPointMake(0.5, 0))
        spr_bg:addChild(text)

        local btn = CCNGBtnMulTex:buttonWithFile(219, 22, -1, -1, "sui/common/btn_1.png", TYPE_MUL_TEX, 500, 500)
        btn:setAnchorPoint(0.5, 0)
        spr_bg:addChild(btn)
        local func = function(eventType, x, y)
            if eventType == TOUCH_CLICK then
                NetManager:reconnectSocket()
                UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
                UI_Utilities.reconnectDialog = nil
                return true
            end
        end
        btn:registerScriptHandler(func)

        local btnlabel = CCZXLabel:labelWithText(139/2, 57/2, "重连", 24)
        btnlabel:setAnchorPoint(CCPointMake(0.5, 0.5))
        btn:addChild(btnlabel, 10)


        dialog:addChild(spr_bg)
        UI_Utilities.root:addChild(dialog, Z_ABOVE_LOADING)
        UI_Utilities.reconnectDialog = dialog

        local s0 = CCScaleTo:actionWithDuration(0.2, 1.1)
        local s1 = CCScaleTo:actionWithDuration(0.25, 1.0)
        local array = CCArray:array()
        array:addObject(s0)
        array:addObject(s1)
        local seq = CCSequence:actionsWithArray(array)
        spr_bg:runAction(seq)
    else
        if UI_Utilities.reconnectDialog then
            UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
            UI_Utilities.reconnectDialog = nil
        end
    end
end

-- 改名成功后调用
function UI_Utilities.showReLoginDialog(state)
    if state then
        if UI_Utilities.reconnectDialog then
            return
        end
        if UI_Utilities.root == nil then
            UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
        end
        local ww = GameScreenConfig.ui_screen_width
        local hh = GameScreenConfig.ui_screen_height
        local dialog = CCBasePanel:panelWithFile(0, 0, ww, hh, "nopack/blocked.png")
        dialog:registerScriptHandler(function(...) return true end)

        local spr_bg = CCBasePanel:panelWithFile(ww/2, hh*0.528, 438, 270, "sui/common/tipsPanel.png", 500, 500)
        spr_bg:setAnchorPoint(0.5, 0.5)
        spr_bg:setDefaultMessageReturn(true)

        local title_bg = CCBasePanel:panelWithFile(219, 272, 484, -1, "sui/common/little_win_title_bg.png", 500, 500)
        title_bg:setAnchorPoint(0.5, 1)
        spr_bg:addChild(title_bg, 1)

        local title_bg1 = CCBasePanel:panelWithFile(219, 264, 444, -1, "sui/common/title_panel.png", 500, 500)
        title_bg1:setAnchorPoint(0.5, 1)
        spr_bg:addChild(title_bg1)

        local title_label = CCZXLabel:labelWithText(222, 12, "#cf3e2c5提示", 26)
        title_label:setAnchorPoint(CCPointMake(0.5, 0))
        title_bg1:addChild(title_label)

        local down_bg = CCBasePanel:panelWithFile(219, 0, 458, -1, "sui/common/win_down.png", 500, 500)
        down_bg:setAnchorPoint(0.5, 0)
        spr_bg:addChild(down_bg, 1)

        local text = CCZXLabel:labelWithText(219, 133, STRING_RECONNECT3, 18)
        text:setAnchorPoint(CCPointMake(0.5, 0))
        spr_bg:addChild(text)

        local btn = CCNGBtnMulTex:buttonWithFile(219, 22, -1, -1, "sui/common/btn_1.png", TYPE_MUL_TEX, 500, 500)
        btn:setAnchorPoint(0.5, 0)
        spr_bg:addChild(btn)
        local func = function(eventType, x, y)
            if eventType == TOUCH_CLICK then
                NetManager:reconnectSocket()
                UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
                UI_Utilities.reconnectDialog = nil
                return true
            end
        end
        btn:registerScriptHandler(func)

        local btnlabel = CCZXLabel:labelWithText(139/2, 57/2, "重新登录", 24)
        btnlabel:setAnchorPoint(CCPointMake(0.5, 0.5))
        btn:addChild(btnlabel, 10)


        dialog:addChild(spr_bg)
        UI_Utilities.root:addChild(dialog, Z_ABOVE_LOADING)
        UI_Utilities.reconnectDialog = dialog

        local s0 = CCScaleTo:actionWithDuration(0.2, 1.1)
        local s1 = CCScaleTo:actionWithDuration(0.25, 1.0)
        local array = CCArray:array()
        array:addObject(s0)
        array:addObject(s1)
        local seq = CCSequence:actionsWithArray(array)
        spr_bg:runAction(seq)
    else
        if UI_Utilities.reconnectDialog then
            UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
            UI_Utilities.reconnectDialog = nil
        end
    end
end

-- 被顶号后调用的
function UI_Utilities.showReplaceDialog(state)
    if state then
        if UI_Utilities.reconnectDialog then
            return
        end
        if UI_Utilities.root == nil then
            UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
        end
        local ww = GameScreenConfig.ui_screen_width
        local hh = GameScreenConfig.ui_screen_height
        local dialog = CCBasePanel:panelWithFile(0, 0, ww, hh, "nopack/blocked.png")
        dialog:registerScriptHandler(function(...) return true end)

        local spr_bg = CCBasePanel:panelWithFile(ww/2, hh*0.528, 438, 270, "sui/common/tipsPanel.png", 500, 500)
        spr_bg:setAnchorPoint(0.5, 0.5)
        spr_bg:setDefaultMessageReturn(true)

        local title_bg = CCBasePanel:panelWithFile(219, 272, 484, -1, "sui/common/little_win_title_bg.png", 500, 500)
        title_bg:setAnchorPoint(0.5, 1)
        spr_bg:addChild(title_bg, 1)

        local title_bg1 = CCBasePanel:panelWithFile(219, 264, 444, -1, "sui/common/title_panel.png", 500, 500)
        title_bg1:setAnchorPoint(0.5, 1)
        spr_bg:addChild(title_bg1)

        local title_label = CCZXLabel:labelWithText(222, 12, "#cf3e2c5提示", 26)
        title_label:setAnchorPoint(CCPointMake(0.5, 0))
        title_bg1:addChild(title_label)

        local down_bg = CCBasePanel:panelWithFile(219, 0, 458, -1, "sui/common/win_down.png", 500, 500)
        down_bg:setAnchorPoint(0.5, 0)
        spr_bg:addChild(down_bg, 1)

        -- local text = CCZXLabel:labelWithText(219, 133, STRING_RECONNECT4, 18)
        local text = CCDialogEx:dialogWithFile(219, 160, 360, 60, 10, "", TYPE_VERTICAL, ADD_LIST_DIR_UP)
        text:setAnchorPoint(0.5, 1)
        text:setFontSize(18);
        text:setText(STRING_RECONNECT4);  -- "#c4d2308当前效果:#cffffff:"
        text:setTag(0)
        text:setLineEmptySpace (5)
        spr_bg:addChild(text)

        local btn = CCNGBtnMulTex:buttonWithFile(219, 22, -1, -1, "sui/common/btn_1.png", TYPE_MUL_TEX, 500, 500)
        btn:setAnchorPoint(0.5, 0)
        spr_bg:addChild(btn)
        local func = function(eventType, x, y)
            if eventType == TOUCH_CLICK then
                NetManager:reconnectSocket()
                UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
                UI_Utilities.reconnectDialog = nil
                return true
            end
        end
        btn:registerScriptHandler(func)

        local btnlabel = CCZXLabel:labelWithText(139/2, 57/2, "重连", 24)
        btnlabel:setAnchorPoint(CCPointMake(0.5, 0.5))
        btn:addChild(btnlabel, 10)


        dialog:addChild(spr_bg)
        UI_Utilities.root:addChild(dialog, Z_ABOVE_LOADING)
        UI_Utilities.reconnectDialog = dialog

        local s0 = CCScaleTo:actionWithDuration(0.2, 1.1)
        local s1 = CCScaleTo:actionWithDuration(0.25, 1.0)
        local array = CCArray:array()
        array:addObject(s0)
        array:addObject(s1)
        local seq = CCSequence:actionsWithArray(array)
        spr_bg:runAction(seq)
    else
        if UI_Utilities.reconnectDialog then
            UI_Utilities.reconnectDialog:removeFromParentAndCleanup(true)
            UI_Utilities.reconnectDialog = nil
        end
    end
end

function UI_Utilities.DestroyAdButton()
    if UI_Utilities.xtgg_panel then
        UI_Utilities.xtgg_panel:removeFromParentAndCleanup(true)
        UI_Utilities.xtgg_panel = nil
    end
    if UI_Utilities.whgg_btn then
        UI_Utilities.whgg_btn:removeFromParentAndCleanup(true)
        UI_Utilities.whgg_btn = nil
    end
end

function UI_Utilities.CreateAdButton()
    UI_Utilities.DestroyAdButton()
    if UI_Utilities.root == nil then
        UI_Utilities.root = ZXLogicScene:sharedScene():getUINode()
    end
    local x = UIScreenPos.relativeWidth(0.70)
    local y = UIScreenPos.relativeHeight(0.89)
    local function whgg_fun(eventType, msg_id, args)
        if eventType == TOUCH_CLICK then
            if UI_Utilities.xtgg_panel then
                UI_Utilities.xtgg_panel:removeFromParentAndCleanup(true)
                UI_Utilities.xtgg_panel = nil
            else
                UI_Utilities.xtgg_panel = SelectServerPage:show_announcement()
                UI_Utilities.root:addChild(UI_Utilities.xtgg_panel, 99)
            end
        end
        return true
    end
    UI_Utilities.whgg_btn = MUtils:create_btn(UI_Utilities.root, "ui2/login/system_info_btn.png",
                                              "ui2/login/system_info_btn.png",
                                              whgg_fun, x, y, -1, -1, 99999)
end
