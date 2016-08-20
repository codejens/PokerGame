-- NormalDialog.lua
-- created by hcl on 2013/1/8
-- 通用的提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.NormalDialog(Window)

local _cb_fun = nil;
local _cb_fun2 = nil; -- 增加第二个回调方法，目前是为了秘籍塔副本创建“再来一次”按钮后记录响应方法

local _win_w = 416
local _btn1_x = 70
local panel = nil; 

local update_view = {};

local _cancel_fun = nil
-- show_type 1 = 两个按钮的对话框 show_type 2 = 只有确定按钮的对话框 3= qq blue vip
function NormalDialog:show(str,cb_fun,show_type,cancel_cb,is_auto_hide,title_path,cb_fun2)
    if ( is_auto_hide == nil ) then 
        is_auto_hide = true
    end
    -- 创建通用购买面板
    local win = UIManager:show_window("normal_dialog",is_auto_hide);
    win:init_with_arg(str);
    _cb_fun = cb_fun;
    _cb_fun2 = cb_fun2
    _cancel_fun = cancel_cb
    if win.again_btn then
        win.again_btn:setIsVisible(false)
    end
    if ( show_type  and show_type == 2 ) then
        win.btn2.view:setIsVisible(false);
        win.btn1.view:setIsVisible( true )
        local win_w = win.view:getSize().width
       local btn1_w = win.btn1.view:getSize().width
        win.btn1.view:setPosition( win_w/2 -btn1_w/2 ,17);
        -- win.btn3.view:setIsVisible( false )
    elseif show_type == 1 or show_type == nil then
        win.btn1.view:setIsVisible( true )
        win.btn1.view:setPosition( _btn1_x, 17 );
        win.btn2.view:setIsVisible(true);
        -- win.btn3.view:setIsVisible( false )
    elseif show_type == 3 then
        win.btn1.view:setIsVisible( false )
        win.btn2.view:setIsVisible( false )
        -- win.btn3.view:setIsVisible( true )
        -- win.btn3:setTouchClickFun(_cb_fun)
    elseif show_type == 4 then
        win.btn2.view:setIsVisible(false);
        win.btn1.view:setIsVisible( false )
        win.btn3.view:setIsVisible(true)
        local win_w = win.view:getSize().width
        local btn3_w = win.btn3.view:getSize().width
        win.btn3.view:setPosition( win_w/2 -btn3_w/2 ,17);
    elseif show_type == 5 then
        -- 镇妖塔副本创建“再来一次”按钮用到
        win.btn2.view:setIsVisible(false);
        win:create_again_btn()
    end 
    if title_path then
        win:reset_title(title_path);
    end
end

-- 
function NormalDialog:__init(window_name, texture_name)
	panel = self.view;

    local spr_bg = CCZXImage:imageWithFile( 0, 0, _win_w,331, UILH_COMMON.dialog_bg,500,500);
    panel:addChild( spr_bg );

    local bg_1 = CCBasePanel:panelWithFile(18, 71, 380, 214,UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(bg_1)

    -- local bg_2 = CCBasePanel:panelWithFile(28, 82, 360, 180,UIPIC_ConfirmWin_009, 500, 500)
    -- panel:addChild(bg_2)

    --内容文本
    update_view[1] = MUtils:create_ccdialogEx(panel,"",40,280,340,150,10,16);
    update_view[1]:setLineEmptySpace(6)
    update_view[1]:setAnchorPoint(0,1);

    local function btn_ok_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
     		UIManager:hide_window("normal_dialog");
            if ( _cb_fun ) then
                _cb_fun();
            end
        -- end
        return true
    end
    self.btn1=ZTextButton:create(panel, Lang.common.confirm[0],UILH_COMMON.lh_button2, btn_ok_fun, _btn1_x,14,-1,-1, 1)

    -- 前往副本大厅时添加，需要优化，热更及时处理
    self.btn3=ZTextButton:create(panel, Lang.task[41],UILH_COMMON.lh_button_4_r, btn_ok_fun, _btn1_x,14,-1,-1, 1)
    self.btn3.view:setIsVisible(false)



    local function btn_cancel_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
        	UIManager:hide_window("normal_dialog");
            if _cancel_fun then
                _cancel_fun()
            end
        -- end
        return true
    end
    self.btn2=ZTextButton:create(panel, Lang.common.confirm[9],UILH_COMMON.lh_button2, btn_cancel_fun, _win_w-_btn1_x-99,14,-1,-1, 1)

    local spr_bg_size = self.view:getSize()
    ---qqvip 
    -- self.btn3 = ZButton:create( nil, UIResourcePath.FileLocate.qqvip .. "blue_btn.png", nil, 0, 0, -1, -1 ) --ImageButton:create( nil, 0, 0, 103, 38, UIResourcePath.FileLocate.common .. "common_big_btn_n.png", UIResourcePath.FileLocate.normal .. "get.png", 600, 600 )
    -- self.btn3:setTouchClickFun( QQVIPModel.qq_blue_vip_btn_fun )
    -- panel:addChild( self.btn3.view )
    -- self.btn3:setTouchClickFun(_cb_fun)
    -- local btn3_size = self.btn3:getSize()
    -- self.btn3.view:setPosition( ( spr_bg_size.width - btn3_size.width ) / 2, 40 )
    -- local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,0,0,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )

    -- title
    self:create_title()
end

function NormalDialog:create_title(  )
    --标题背景
    self.title_bg = CCBasePanel:panelWithFile( 0, 0, -1, 60, UIPIC_COMMOM_title_bg )
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( ( panel:getSize().width - title_bg_size.width ) / 2, panel:getSize().height - title_bg_size.height/2-14)
    self.title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  UILH_NORMAL.title_tips  )
    self.title:setAnchorPoint(0.5,0.5)
    self.title_bg:addChild( self.title )
    self.view:addChild( self.title_bg )
end

function NormalDialog:init_with_arg(str)
    update_view[1]:setText("");
	update_view[1]:setText(str);
end

function NormalDialog:active(show)
    if ( show == false ) then
        -- if ( _cancel_fun ) then
        --      _cancel_fun();
        -- end
    end
    --这个exit_btn为父类的关闭按钮
    -- if self.exit_btn then
    --     self.exit_btn:setPosition(363,278)
    -- end 
end

function NormalDialog:reset_title(title_path)
    if title_path then
        if self.title then
            self.title:removeFromParentAndCleanup(true);
            self.title = nil;
        end

        local title_bg_size = self.title_bg:getSize()
        self.title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  title_path  )
        self.title:setAnchorPoint(0.5,0.5)
        self.title_bg:addChild( self.title )
    end
end

--镇妖塔 要求取消按钮改为"再来一次"
function NormalDialog:create_again_btn(  )
    if self.again_btn then
        self.again_btn:setIsVisible(true)
        return
    end

    local function btn_cancel_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
            UIManager:hide_window("normal_dialog");
            if _cb_fun2 then
                _cb_fun2()
            end
        -- end
        return true
    end
    self.again_btn=ZTextButton:create(panel, Lang.common.confirm[19],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, btn_cancel_fun, _win_w-_btn1_x-121,14,-1,-1, 1)
end