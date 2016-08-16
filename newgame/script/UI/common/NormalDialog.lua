-- NormalDialog.lua
-- created by hcl on 2013/1/8
-- 通用的提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.NormalDialog(Window)

local _cb_fun = nil
local _cb_fun2 = nil -- 增加第二个回调方法，目前是为了秘籍塔副本创建“再来一次”按钮后记录响应方法

local _win_w = 516
local _btn1_x = 70
local panel = nil 

local update_view = {}

local _cancel_fun = nil
-- show_type 1 = 两个按钮的对话框 show_type 2 = 只有确定按钮的对话框 3= qq blue vip
function NormalDialog:show(str,cb_fun,show_type,cancel_cb,is_auto_hide,title_path,cb_fun2)
    if is_auto_hide == nil then 
        is_auto_hide = true
    end
    -- 创建通用购买面板
    local win = UIManager:show_window("normal_dialog",is_auto_hide)
    win:init_with_arg(str)
    _cb_fun = cb_fun
    _cb_fun2 = cb_fun2
    _cancel_fun = cancel_cb
    if win.again_btn then
        win.again_btn:setIsVisible(false)
    end
    if show_type and show_type == 2 then
        win.btn2.view:setIsVisible(false)
        win.btn1.view:setIsVisible( true )
       --  local win_w = win.view:getSize().width
       -- local btn1_w = win.btn1.view:getSize().width
        win.btn1.view:setPosition( win.btn1.x,win.btn1.y)
        -- win.btn3.view:setIsVisible( false )
    elseif show_type == 1 or show_type == nil then
        win.btn1.view:setIsVisible( true )
        win.btn1.view:setPosition( win.btn2.x, win.btn1.y )
        win.btn2.view:setIsVisible(true)
        win.btn2.view:setPosition(win.btn1.x-120,win.btn2.y)
        -- win.btn3.view:setIsVisible( false )
    elseif show_type == 3 then
        win.btn1.view:setIsVisible( false )
        win.btn2.view:setIsVisible( false )
        -- win.btn3.view:setIsVisible( true )
        -- win.btn3:setTouchClickFun(_cb_fun)
    elseif show_type == 4 then
        win.btn2.view:setIsVisible(false)
        win.btn1.view:setIsVisible( false )
        win.btn3.view:setIsVisible(true)
        local win_w = win.view:getSize().width
        local btn3_w = win.btn3.view:getSize().width
        win.btn3.view:setPosition( win.btn1.x ,win.btn1.y)
    elseif show_type == 5 then
        -- 镇妖塔副本创建“再来一次”按钮用到
        win.btn2.view:setIsVisible(false)
        win:create_again_btn()
    end 
    if title_path then
        win:reset_title(title_path)
    end
end

-- 
function NormalDialog:__init(window_name, texture_name)
	panel = self.view
    local h = 331
    local spr_bg = CCBasePanel:panelWithFile( -50, 0, _win_w,h, "sui/common/tipsPanel.png",500,500)
    panel:addChild( spr_bg )

    local bg_1 = CCBasePanel:panelWithFile(_win_w/2, h/2+20, 400, 190,"sui/common/panel2.png", 500, 500)
    spr_bg:addChild(bg_1)
    bg_1:setAnchorPoint(0.5,0.5)

    -- local bg_2 = CCBasePanel:panelWithFile(28, 82, 360, 180,UIPIC_ConfirmWin_009, 500, 500)
    -- panel:addChild(bg_2)

    --内容文本
    update_view[1] = MUtils:create_ccdialogEx(spr_bg,"",65,270,390,150,10,18)
    update_view[1]:setLineEmptySpace(6)
    update_view[1]:setAnchorPoint(0,1)

    local function btn_ok_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
     		UIManager:hide_window("normal_dialog")
            if _cb_fun then
                _cb_fun()
            end
        -- end
        return true
    end
    self.btn1=ZTextButton:create(panel,"","sui/common/btn_1.png", btn_ok_fun,  134,23,-1,-1, 1)
    self.btn1.x = 134
    self.btn1.y = 23
    MUtils:create_btn_name(self.btn1,"sui/btn_name/queding.png")

    -- 前往副本大厅时添加，需要优化，热更及时处理
    self.btn3=ZTextButton:create(panel, "","sui/common/btn_1.png", btn_ok_fun, 134,23,-1,-1, 1)
    self.btn3.view:setIsVisible(false)
    MUtils:create_btn_name(self.btn3,"sui/btn_name/lijiqianwang.png")



    local function btn_cancel_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
        	UIManager:hide_window("normal_dialog")
            if _cancel_fun then
                _cancel_fun()
            end
        -- end
        return true
    end
    self.btn2=ZTextButton:create(panel,"","sui/common/btn2_s.png", btn_cancel_fun, self.btn1.x+120,23,-1, -1,1)
    MUtils:create_btn_name(self.btn2,"sui/btn_name/quxiao.png")
    self.btn2.x = self.btn1.x + 120
    self.btn2.y = 23
    self.btn1:setFontSize(24)
    self.btn2:setFontSize(24)
    self.btn3:setFontSize(24)

    local spr_bg_size = self.view:getSize()
    ---qqvip 
    -- self.btn3 = ZButton:create( nil, UIResourcePath.FileLocate.qqvip .. "blue_btn.png", nil, 0, 0, -1, -1 ) --ImageButton:create( nil, 0, 0, 103, 38, UIResourcePath.FileLocate.common .. "common_big_btn_n.png", UIResourcePath.FileLocate.normal .. "get.png", 600, 600 )
    -- self.btn3:setTouchClickFun( QQVIPModel.qq_blue_vip_btn_fun )
    -- panel:addChild( self.btn3.view )
    -- self.btn3:setTouchClickFun(_cb_fun)
    -- local btn3_size = self.btn3:getSize()
    -- self.btn3.view:setPosition( ( spr_bg_size.widthA - btn3_size.width ) / 2, 40 )
    -- local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,0,0,-1,-1)
    -- local exit_btn_size = exit_btn:getSize()
    
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )

    -- title
    -- self:create_title()

    --标题背景
    self.title_bg = CCBasePanel:panelWithFile( _win_w/2, 7, -1, -1,"sui/common/little_win_title_bg.png")
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( ( panel:getSize().width - title_bg_size.width ) / 2, panel:getSize().height - title_bg_size.height/2-14)
    self.title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height/2, -1, -1,  "sui/tips/tishi.png"  )
    self.title:setAnchorPoint(0.5,0.5)
    self.title_bg:addChild( self.title )
    spr_bg:addChild( self.title_bg )
    self.title_bg:setAnchorPoint(0.5,0.5)

    self.title_bg:setPosition(_win_w/2,h - title_bg_size.height/2 + 7)

    self.view:setPosition(UIScreenPos.relativeWidth(1.0)/2,UIScreenPos.relativeHeight(1.0)/2)
end

function NormalDialog:create_title()
end

function NormalDialog:init_with_arg(str)
    update_view[1]:setText("")
	update_view[1]:setText("#c5f3406" .. str)
end

function NormalDialog:active(show)
    if show == false then
        -- if ( _cancel_fun ) then
        --      _cancel_fun()
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
            self.title:removeFromParentAndCleanup(true)
            self.title = nil
        end

        local title_bg_size = self.title_bg:getSize()
        self.title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  title_path  )
        self.title:setAnchorPoint(0.5,0.5)
        self.title_bg:addChild( self.title )
    end
end

--镇妖塔 要求取消按钮改为"再来一次"
function NormalDialog:create_again_btn()
    if self.again_btn then
        self.again_btn:setIsVisible(true)
        return
    end

    local function btn_cancel_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
            UIManager:hide_window("normal_dialog")
            if _cb_fun2 then
                _cb_fun2()
            end
        -- end
        return true
    end
    self.again_btn=ZTextButton:create(panel, Lang.common.confirm[19],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, btn_cancel_fun, _win_w-_btn1_x-121,14,-1,-1, 1)
end