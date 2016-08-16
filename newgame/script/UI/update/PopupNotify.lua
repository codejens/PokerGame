
POPUP_OK     = 1
POPUP_YES_NO = 2

POPUPSIZE_EXIT_DIALOG = 1

local _fontSize = 26
local PopSet    = 
{
    [POPUPSIZE_EXIT_DIALOG] = 
    {
        bg       = {w=440,h=272},
        ok       = {x=36,y=25},
        cancel   = {x=265,y=25},
        ok2      = {x=150,y=25},
    },
}

local _bg_path            = "ui2/update/dialog_bg1.png"
local _bg_top_path        = "ui2/update/dialog_bg2.png"
local _bg_down_path       = "ui2/update/dialog_bg3.png"
local _button_path        = "ui2/update/button1.png"
local _button_path_close  = "ui2/update/close_btn_z.png"

local function create_zxfont(parent, str, pos_x, pos_y, aligntype, fontsize, z)
    local lab = nil
    fontsize  = fontsize or _fontSize
    if not aligntype then
        lab = CCZXLabel:labelWithText(pos_x, pos_y, str)
    else
        lab = CCZXLabel:labelWithText(pos_x, pos_y, str, fontsize, aligntype)
    end
    if not z then 
        z = 0
    end
    parent:addChild(lab, z)
    return lab
end

local function create_btn_label(parent, str, aligntype, fontsize, z)
    local lab = nil
    fontsize  = fontsize or _fontSize
    if not aligntype then
        lab = CCZXLabel:labelWithText(0, 0, str)
    else
        lab = CCZXLabel:labelWithText(0, 0, str, fontsize, aligntype)
    end
    if not z then
        z = 0
    end
    local parent_size = parent:getSize()
    lab:setPosition(parent_size.width*0.5-1, parent_size.height*0.5-13)
    parent:addChild(lab, z)
    return lab
end

local function create_btn(parent, filepath, selectedpath, func, pos_x, pos_y, width, height, z, lb_w, lb_h, rb_w, rb_h, lt_w, lt_h, rt_w, rt_h)
    local btn = nil
    if lb_w == nil or lb_h == nil then
        btn = CCNGBtnMulTex:buttonWithFile(pos_x, pos_y, width, height, filepath)
    else
        btn = CCNGBtnMulTex:buttonWithFile(pos_x, pos_y, width, height, filepath, TYPE_MUL_TEX, lb_w, lb_h, rb_w, rb_h, lt_w, lt_h, rt_w, rt_h)
    end
    if selectedpath then
        btn:addTexWithFile(CLICK_STATE_DOWN, selectedpath)
    end

    if not func then
        func = function(eventType, x, y)
            if eventType == TOUCH_CLICK then
                return true
            end
        end
    end
    btn:registerScriptHandler(func)
    if not z then 
        z = 0
    end
    parent:addChild(btn, z)
    return btn
end

function PopupNotify(root, z, lines, oktext, canceltext, type, result_callback, sizeConfig, hide_close)
    local view_width  = UIScreenPos.relativeWidth(1.0)
    local view_height = UIScreenPos.relativeHeight(1.0)
    local view_bg     = CCBasePanel:panelWithFile(0, 0, view_width, view_height, "nopack/blocked.png")
    view_bg:setDefaultMessageReturn(true)
    root:addChild(view_bg, z)

    local size    = sizeConfig or 1
    local config  = PopSet[size]
    local spr_bg  = CCBasePanel:panelWithFile((view_width-config.bg.w)/2, (view_height-config.bg.h)/2, config.bg.w, config.bg.h, "")
    view_bg:addChild(spr_bg)
    local bg_1    = CCBasePanel:panelWithFile(0, 0, config.bg.w, config.bg.h, _bg_path, 500, 500)
    spr_bg:addChild(bg_1)
    local bg_2    = CCBasePanel:panelWithFile(-20, config.bg.h-23, config.bg.w+40, 25, _bg_top_path, 500, 500)
    spr_bg:addChild(bg_2)
    local bg_3    = CCBasePanel:panelWithFile(-10, -1, config.bg.w+20, 10, _bg_down_path, 500, 500)
    spr_bg:addChild(bg_3)

    if type == POPUP_YES_NO then
	    local function btn_ok_fun(eventType, x, y)
	        if eventType == TOUCH_BEGAN then
	            return true
	        elseif eventType == TOUCH_CLICK then
                if SMovieClientModel then
                    if SMovieClientModel:get_isMove() then
                        SMovieClientModel:end_movie()
                        SMovieClientModel:set_isMove(false)
                    end
                end
                local cb = callback:new()
                local function cb_func()
                    if not result_callback(true) then
                        if view_bg then
                            view_bg:removeFromParentAndCleanup(true)
                            view_bg = nil
                        end
                        if cb then
                            cb:cancel()
                            cb = nil
                        end
                        return true
                    end
                end
                cb:start(0.2, cb_func)
            elseif eventType == TOUCH_ENDED then
                return true
            end
	    end

        local function btn_cancel_fun(eventType, x, y)
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if not result_callback(false) then
                    if view_bg then
                        view_bg:removeFromParentAndCleanup(true)
                        view_bg = nil
                    end
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end
        local function btn_close_fun(eventType, x, y)
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if not result_callback() then
                    if view_bg then
                        view_bg:removeFromParentAndCleanup(true)
                        view_bg = nil
                    end
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end

        local callback1 = btn_ok_fun
        local text1     = oktext
        if config.swap_button_tex then
            callback1 = btn_cancel_fun
            text1     = canceltext
        end
        local btn1    = create_btn(spr_bg, _button_path, _button_path, callback1, config.ok.x, config.ok.y, -1, -1)
        create_btn_label(btn1, text1, 2)

        local callback2 = btn_cancel_fun
        local text2     = canceltext
        if config.swap_button_tex then
            callback2 = btn_ok_fun
            text2      = oktext
        end
        local cancelbtn = create_btn(spr_bg, _button_path, _button_path, callback2, config.cancel.x, config.cancel.y, -1, -1)
        create_btn_label(cancelbtn, text2, 2)

        local close_btn  = create_btn(spr_bg, _button_path_close, _button_path_close, btn_close_fun, 0, 0, -1, -1)
        local close_size = close_btn:getSize()
        close_btn:setPosition(config.bg.w-close_size.width-8, config.bg.h-close_size.height+8)
        if not hide_close then
            close_btn:setIsVisible(false)
        end
	else
        local function btn_ok_fun(eventType, x, y)
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if SMovieClientModel then
                    if  SMovieClientModel:get_isMove() then
                        SMovieClientModel:end_movie()
                        SMovieClientModel:set_isMove(false)
                    end
                end

                local cb = callback:new()
                local function cb_func()
                    if not result_callback() then
                        if view_bg then
                            view_bg:removeFromParentAndCleanup(true)
                            view_bg = nil
                        end
                        if cb then
                            cb:cancel()
                            cb = nil
                        end
                    end
                    return true
                end
                cb:start(0.2, cb_func)
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end

        local btn1 = create_btn(spr_bg, _button_path, _button_path, btn_ok_fun, config.ok2.x, config.ok2.y, -1, -1)
        create_btn_label(btn1, oktext, 2)

        local close_btn  = create_btn(spr_bg, _button_path_close, _button_path_close, btn_ok_fun, 0, 0, -1, -1)
        local close_size = close_btn:getSize()
        close_btn:setPosition(config.bg.w-close_size.width-8, config.bg.h-close_size.height+8)
        if not hide_close then
            close_btn:setIsVisible(false)
        end
    end

    local text_panel = CCBasePanel:panelWithFile(0, 0, 0, 0, "")
    spr_bg:addChild(text_panel)

    local y = 0
    for i=#lines,1,-1 do
        local text = create_zxfont(text_panel, lines[i], 0, y, 2, 20)
        local size = text:getSize()
        y = y + size.height
    end
    text_panel:setSize(0, y)
    text_panel:setPosition(config.bg.w/2, config.bg.h/2-y/2+25)

    UIScreenPos.screen9GridPosWithAction({view = view_bg}, 10)

    return view_bg
end