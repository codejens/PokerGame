
-- aligntype 
--    ALIGN_LEFT = 1,
--    ALIGN_CENTER = 2,
--    ALIGN_RIGHT = 3,
local _fontSize = 20
local _btnLabelOffset = 4
local function create_zxfont(parent,str,pos_x,pos_y,aligntype,fontsize,z)
    local lab = nil
    fontsize = fontsize or _fontSize
    if ( aligntype == nil or fontsize == nil) then
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str)
    else
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str, fontsize,aligntype)
    end
    if(z == nil) then 
        z = 0
    end
    parent:addChild(lab,z)
    return lab
end

local function create_btn_label(parent,str,pos_x,pos_y,aligntype,fontsize,z)
    local lab = nil
    fontsize = fontsize or _fontSize
    if ( aligntype == nil or fontsize == nil) then
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str)
    else
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str, fontsize,aligntype)
    end
    if(z == nil) then 
        z = 0
    end

    lab:setAnchorPoint(CCPointMake(0.5,0.5))
    local sz = parent:getSize()
    lab:setPosition(sz.width*0.5, _btnLabelOffset + sz.height*0.5)
    parent:addChild(lab,z)
    return lab
end



-- 创建sprite
local function create_sprite(parent,filepath,pos_x,pos_y,z)
    local spr = CCSprite:spriteWithFile(filepath)
    spr:setPosition(pos_x,pos_y)
    if( z == nil ) then 
        z = 0
    end
    parent:addChild(spr,z)
    spr:setTag(0)
    return spr
end

-- 创建按钮
local function create_btn(parent,filepath,selectedpath,func,pos_x,pos_y,width,height,z,lb_w,lb_h,rb_w,rb_h,lt_w,lt_h,rt_w,rt_h)
    local btn = nil
    if lb_w==nil or lb_h == nil then
        btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath)
    else
        btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath,TYPE_MUL_TEX,lb_w,lb_h,rb_w,rb_h,lt_w,lt_h,rt_w,rt_h)
    end
    
    if selectedpath then
        btn:addTexWithFile(CLICK_STATE_DOWN,selectedpath)
    end
    if(func == nil) then
        func = function(eventType,x,y)
            if eventType == TOUCH_CLICK then
                --按钮抬起时处理事件.
                return true
            end
        end
    end
    if btn and btn.registerScriptHandler then btn:registerScriptHandler(func) end

    if not z then z = 1 end

    parent:addChild(btn, z)

    return btn
end

POPUP_OK = 1
POPUP_YES_NO = 2

POPUPSIZE_NORMAL = 1
POPUPSIZE_512 = 2
POPUPSIZE_3_512 = 3
POPUPSIZE_EXIT_DIALOG = 4

POPUP_BTN_OFFSET = 5

local PopSet = 
{
    [POPUPSIZE_NORMAL] = 
    {
        bg       = {w=420,h=331},
        title_bg = {x=162,y=229},
        title    = {x=212,y=302},
        ok       = {x=57,y=17,scale=1},
        cancel   = {x=238,y=17,scale=1},
        ok2      = {x=146,y=17,scale=1},
        text     = {x=41,y=225},
        grid_bg  = {x=17,y=63,w=380, h=200}
    },
    [POPUPSIZE_EXIT_DIALOG] = 
    {
        bg       = {w=420,h=331},
        title_bg = {x=162,y=229},
        title    = {x=212,y=302},
        ok       = {x=57,y=17,scale=1},
        cancel   = {x=238,y=17,scale=1},
        ok2      = {x=146,y=17,scale=1},
        text     = {x=41,y=225},
        grid_bg  = {x=17,y=63,w=380, h=200},
        swap_button_tex = true
    },
    [POPUPSIZE_512] = 
    {
        bg       = {w=512,h=331},
        title_bg = {x=265,y=256},
        title    = {x=257,y=302},
        ok       = {x=58,y=20,scale=1.0},
        cancel   = {x=318,y=20,scale=1.0},
        ok2      = {x=202,y=20,scale=1.0},
        text     = {x=34,y=215},
        grid_bg  = {x=21,y=69,w=470, h=180}
    },

    [POPUPSIZE_3_512] = 
    {
        bg       = {w=512,h=512},
        title_bg = {x=255,y=485},
        title    = {x=256,y=484},
        ok       = {x=38,y=17,scale=1.0},
        cancel   = {x=344,y=17,scale=1.0},
        neutral  = {x=190,y=17,scale=1.0},
        ok2      = {x=190,y=17,scale=1.0},
        text     = {x=34,y=398},
        grid_bg  = {x=18,y=71,w=380, h=200}
    }
}
local _buttonWidth = 126
local _buttonHeight = 43
local _bg_path            = "ui2/update/dialog_bg1.png"
local _bg_top_path        = "ui2/update/dialog_bg2.png"
local _bg_down_path       = "ui2/update/dialog_bg3.png"
local _button_path        = "ui2/update/button1.png"
local _button_path_close  = "ui2/update/close_btn_z.png"
local _button_path_ok     = "ui2/update/button1.png"


function PopupNotify3Btn(root, z, lines, oktext, canceltext, nutext, result_callback, sizeConfig)
    local size = sizeConfig or 1
    local config = PopSet[POPUPSIZE_3_512]
    local winSize = CCDirector:sharedDirector():getWinSize()
    local spr_bg = CCBasePanel:panelWithFile(0, 0, config.bg.w, config.bg.h, _bg_path, 500, 500)
    root:addChild( spr_bg, z)
    -- 标题背景
    --create_sprite(spr_bg,"ui2/update/dialog_title_bg.png",config.title_bg.x ,config.title_bg.y )
    -- create_sprite(spr_bg,_title_path, config.title.x ,   config.title.y )

    local grid_bg = CCBasePanel:panelWithFile(config.grid_bg.x, config.grid_bg.y, config.grid_bg.w, config.grid_bg.h, _bg2_path, 500, 500)
    spr_bg:addChild(grid_bg)

    --if type == POPUP_YES_NO then
        local function btn_ok_fun(eventType,x,y)
            
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if notresult_callback(1) then
                    spr_bg:removeFromParentAndCleanup(true)
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end
        local btn1 = create_btn(spr_bg, _button_path_ok, _button_path_ok, btn_ok_fun, config.ok.x, config.ok.y, -1, -1)
        btn1:setScale(config.ok.scale)
        create_btn_label(btn1, oktext, 40 ,14, 1, _fontSize)

        -- 关闭按钮
        local function btn_cancel_fun(eventType,x,y)
            
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if result_callback(0) then
                    spr_bg:removeFromParentAndCleanup(true)
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end

        -- 关闭按钮
        local function nu_cancel_fun(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if result_callback(2) then
                    spr_bg:removeFromParentAndCleanup(true)
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end

        local cancelbtn = create_btn(
            spr_bg, _button_path_ok, _button_path_ok, btn_cancel_fun,
            config.cancel.x, config.cancel.y, _buttonWidth, _buttonHeight
        )
        cancelbtn:setScale(config.cancel.scale)
        create_btn_label(cancelbtn, canceltext, 18 ,8 ,1)

        local neutralbtn = create_btn(
            spr_bg, _button_path_ok, _button_path_ok,
            nu_cancel_fun, config.neutral.x, config.neutral.y, _buttonWidth, _buttonHeight
        )
        neutralbtn:setScale(config.neutral.scale)
        create_btn_label(neutralbtn,nutext,18 ,8 ,1)

        --右上角关闭
        local close_btn = create_btn(spr_bg, _button_path_close, _button_path_close, btn_cancel_fun, 0, 0, 60, 60)
        local bg_size = spr_bg:getSize()
        local close_size = close_btn:getSize()
        close_btn:setPosition(bg_size.width - close_size.width+11 , bg_size.height - close_size.height-20)
    --end

    -- 标题
    local x = config.text.x
    local y = config.text.y
    for i in ipairs(lines) do
        create_zxfont(spr_bg,lines[i],x,y,0,16)
        y = y - 22
    end

    UIScreenPos.screen9GridPosWithAction({ view = spr_bg},5)
    --spr_bg:setPosition( (800 - 291) / 2 + 291 / 2, (480 - 199) / 2 + 199 / 2)

    spr_bg:setScale(0.0)
    return spr_bg
end

function PopupNotify(root, z,  lines, oktext, canceltext, type, result_callback, sizeConfig)
    local size = sizeConfig or 1
    local config = PopSet[size]
    local winSize = CCDirector:sharedDirector():getWinSize()
    local spr_bg = CCBasePanel:panelWithFile(0, 0, config.bg.w , config.bg.h+25, "")
    spr_bg:setDefaultMessageReturn(true)   -- 设置不可穿透
    root:addChild(spr_bg, z)
    local bg = CCBasePanel:panelWithFile(0, 0, config.bg.w , config.bg.h, _bg_path, 500, 500)
    spr_bg:addChild(bg)

    -- local bg_1 = CCBasePanel:panelWithFile(config.grid_bg.x, config.grid_bg.y, 
    --                                        config.grid_bg.w, config.grid_bg.h,
    --                                        _grid_bg_path, 500, 500)
    -- spr_bg:addChild(bg_1)
    -- local bg_1 = CCBasePanel:panelWithFile(0, 0, config.bg.w , config.bg.h, _bg2_path, 500, 500)
    -- spr_bg:addChild(bg_1)
    local bg_2 = CCBasePanel:panelWithFile(18, 80, 385, 210,_grid_bg_path, 500, 500)
    spr_bg:addChild(bg_2)
    -- 标题背景
    require "UI/commonwidge/ZImage"
    local title_bg = ZImage:create( spr_bg, _title_bg, 0, -30, -1, 60 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( config.bg.w - title_bg_size.width ) / 2, config.bg.h - title_bg_size.height+15 )
    create_sprite(spr_bg,_title_path, config.title.x , config.title.y + 15 )

    if type == POPUP_YES_NO then 
	    local function btn_ok_fun(eventType,x,y)
            
	        if eventType == TOUCH_BEGAN then
	            return true
	        elseif eventType == TOUCH_CLICK then
                if not result_callback(true) then
	               spr_bg:removeFromParentAndCleanup(true)
	            end
	            return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
	    end
        local _ok_path = _button_path_ok
        -- if config.swap_button_tex then
        --     _ok_path = _button_path_cancel
        -- end
	    local btn1 = create_btn(spr_bg, _ok_path, _ok_path, btn_ok_fun, config.ok.x, config.ok.y, -1, -1)
        local cs = btn1:getSize()

        --btn1:setScale(config.ok.scale)
    	local lab = create_zxfont(btn1,oktext, cs.width * 0.5 ,cs.height * 0.5 + POPUP_BTN_OFFSET,1,18)
        lab:setAnchorPoint(CCPointMake(0.5,0.5))
                -- 关闭按钮
        local function btn_cancel_fun(eventType,x,y)
            
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if not result_callback(false) then
                    spr_bg:removeFromParentAndCleanup(true)
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end

        local _cancel_path = _button_path_close
        if config.swap_button_tex then
            _cancel_path = _button_path_ok
        end

        local cancelbtn = create_btn( spr_bg,_cancel_path,_cancel_path,btn_cancel_fun,config.cancel.x,config.cancel.y,-1,-1)
        local cs = cancelbtn:getSize()
        --cancelbtn:setScale(config.cancel.scale)
        local lab = create_zxfont(cancelbtn,canceltext,
                                  cs.width * 0.5 ,cs.height * 0.5 + POPUP_BTN_OFFSET,1,18)
        lab:setAnchorPoint(CCPointMake(0.5,0.5))

        --右上角关闭
        local close_btn = create_btn(spr_bg, _button_path_close,_button_path_close,btn_cancel_fun,0,0,60,60)
        local bg_size = spr_bg:getSize()
        local close_size = close_btn:getSize()
        close_btn:setPosition(bg_size.width - close_size.width+11 , bg_size.height - close_size.height-20)

	else
        local function btn_ok_fun(eventType,x,y)
            
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                if not result_callback() then
                    spr_bg:removeFromParentAndCleanup(true)
                end
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end
        local btn1 = create_btn(spr_bg,_button_path_ok, _button_path_ok, btn_ok_fun, config.ok2.x, config.ok2.y, -1, -1)
        btn1:setScale(config.ok2.scale)
        create_zxfont(btn1,oktext, 25 ,20,1,18)

        --右上角关闭
        local close_btn = create_btn(spr_bg, _button_path_close,_button_path_close,btn_ok_fun,0,0,60,60)
        local bg_size = spr_bg:getSize()
        local close_size = close_btn:getSize()
        close_btn:setPosition(bg_size.width - close_size.width+11 , bg_size.height - close_size.height-20)
    end
-- 标题
    local x = config.text.x
    local y = config.text.y
    for i in ipairs(lines) do
        create_zxfont(spr_bg,lines[i],x,y,0,_fontSize)
        y = y - 27
    end

    --spr_bg:setPosition( (800 - 416) / 2 + 416 / 2, (480 - 331) / 2 + 331 / 2)
    UIScreenPos.screen9GridPosWithAction({view = spr_bg},5)
    return spr_bg
end