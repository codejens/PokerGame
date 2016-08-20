-- InputDialog.lua
-- created by hcl on 2013/1/8
-- 通用的消耗道具提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.InputDialog(Window)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _cb_fun = nil;

local  editbox =nil;

local panel = nil; 

local update_view = {};

local MAX_FONT_NUM = 10

function InputDialog:show(cb_fun, title_img_path, tip_text)
    -- 创建通用购买面板
    local win = UIManager:show_window("input_dialog",true);
    if win then
        if tip_text then
            win:add_tip_dialog(tip_text)
        end
        if title_img_path then
            win:set_title(title_img_path)
        end
    end

    _cb_fun = cb_fun;
end

-- 关闭按钮
local function close_but_CB( )
    local win = UIManager:find_visible_window("input_dialog")
    if win then
        win:hide_keyboard()
    end
    UIManager:hide_window( "input_dialog" )
end

-- function InputDialog:create(texture_name)
--     --return BuyKeyboardWin("ui/common/bg01.png",152,114,529,269);
--     return InputDialog(nil,260,160,280,160);
-- end

-- 
function InputDialog:__init( window_name, texture_name, is_grid, width, height,title_text )
    panel = self.view;

    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

    --标题背景
    local title_bg = ZImage:create( self.view,UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )
    
    local bg = CCZXImage:imageWithFile( 12, 79, 416, 195, UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(bg)

    -- local spr_bg = CCZXImage:imageWithFile( 0, 0, 416, 331, UIPIC_ConfirmWin_001, 120,88,120,88,120,74,120,74 );
    -- panel:addChild( spr_bg );

    editbox = CCZXEditBox:editWithFile(64, 110, 316, 50, UILH_COMMON.bg_03, MAX_FONT_NUM, 18,  EDITBOX_TYPE_NORMAL ,500,500);

    -- editbox = CCZXEditBoxArea:editWithFile( 54, 154,316, 50, "", 40, 18, 960, 640 )


    panel:addChild(editbox);


    local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            
        elseif eventType == KEYBOARD_FINISH_INSERT then
            self:hide_keyboard()
            return true
        elseif eventType == TOUCH_BEGAN then
            -- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
        elseif eventType == KEYBOARD_WILL_SHOW then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height ); 
            return true
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height );
            return true
        end
        return true
    end

    editbox:registerScriptHandler(edit_box_function)


    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            if ( _cb_fun ) then
                 _cb_fun(editbox:getText());
            end
            UIManager:hide_window("input_dialog");
        end
        return true
    end

    self.btn1 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_ok_fun,85,18,-1,-1)
    MUtils:create_zxfont(self.btn1, Lang.common.confirm[0], 99/2, 20, 2, 18)   --[0]=确定

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
           UIManager:hide_window("input_dialog");
        end
        return true
    end
    self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_cancel_fun,260,18,-1,-1)
    MUtils:create_zxfont(self.btn2, Lang.common.confirm[9], 99/2, 20, 2, 18)   --[9]=取消

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)

    --关闭按钮
    local function _close_btn_fun()
        UIManager:hide_window(window_name)
    end

    local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }
    self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    local exit_btn_size = self._exit_btn:getSize()
    self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height-20)
end

function InputDialog:active( show )
    if ( editbox) then 
            print("InputDialog:64: 字符串置空")
            editbox:setText("");
    end
end

function InputDialog:destroy(  )
    self:hide_keyboard()
    Window.destroy(self)
end

------------------弹出/关闭 键盘时将整个InputDialog的y坐标的调整
function InputDialog:keyboard_will_show( keyboard_w, keyboard_h )
    self.delay_cb = callback:new();
    local function cb()
         self.keyboard_visible = true;
        local win = UIManager:find_visible_window("input_dialog");
        -- local win_info = UIManager:get_win_info("input_dialog")
        if win then
            -- local win_pos = win:getPosition()
            -- ZXLog('=====win_pos: ', win_pos.x, win_pos.y)
            if keyboard_h == 162 then--ip eg
                win:setPosition(_refWidth(0.5),480);
            elseif keyboard_h == 198 then---ip cn
                win:setPosition(_refWidth(0.5),480);
            elseif keyboard_h == 352 then --ipad eg
                win:setPosition(_refWidth(0.5),520);
            elseif keyboard_h == 406 then --ipad cn
                win:setPosition(_refWidth(0.5),550);
            end

            -- local win_pos = win:getPosition()
            -- ZXLog('=====win_pos: ', win_pos.x, win_pos.y)
        end
        self.delay_cb = nil
    end
    self.delay_cb:start(0.2,cb);
end

function InputDialog:keyboard_will_hide(  )
     self.delay_cb = callback:new();
    local function cb()
        self.keyboard_visible = false;
        local win = UIManager:find_visible_window("input_dialog");
        -- local win_info = UIManager:get_win_info("input_dialog")
        if win then
            win:setPosition(_refWidth(0.5),_refHeight(0.5));
        end
    end
    self.delay_cb:start(0.1,cb);
    
end

-------------------- 手动关闭键盘
function InputDialog:hide_keyboard(  )

    -- if self.edit_box and self.keyboard_visible then
        editbox:detachWithIME();
    -- end
end

-- 增加提示文本，如果位置、大小不合要求，可以再开几个参数去自定义设置。 note by guozhinan
function InputDialog:add_tip_dialog(tip_text)
    if self.tip_dialog == nil then
        self.tip_dialog = ZDialog:create(self.view, "",65,180,350,50,16)
        self.tip_dialog.view:setLineEmptySpace(5)
        self.tip_dialog:setText(tip_text)
    else
        self.tip_dialog:setText(tip_text)
    end
end

function InputDialog:set_title(title_img_path)
    if self.img_title == nil then
        self.img_title = ZImage:create(self.view, title_img_path , 220,  311, -1,-1,999 );
        self.img_title.view:setAnchorPoint(0.5,0.5)
    end
end
