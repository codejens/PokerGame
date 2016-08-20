-- PiPeiDialog.lua
-- created by hcl on 2013/8/8
-- 匹配对话框

require "UI/component/Window"
require "utils/MUtils"
super_class.PiPeiDialog(NormalStyleWindow)

-- 
function PiPeiDialog:show(is_auto_hide)
    if ( is_auto_hide == nil ) then 
        is_auto_hide = false
    end
    -- 创建通用购买面板
    local win = UIManager:show_window("pipei_dialog",is_auto_hide);
    win:init_with_arg();
end

-- 
function PiPeiDialog:__init( window_name, texture_name, is_grid, width, height,title_text )
	local panel = self.view;

    --盖住父类bg
    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

	local spr_bg = CCZXImage:imageWithFile( 10, 80, width-20, 140, UILH_COMMON.bottom_bg,  120,88,120,88,120,74,120,74 );
    panel:addChild( spr_bg );

    -- -- 标题
    -- local title_bg = CCZXImage:imageWithFile( 330 / 2 - 81, 200 - 35, -1, -1, UIResourcePath.FileLocate.common .. "dialog_title_bg.png"  )
    -- MUtils:create_sprite(title_bg,UIResourcePath.FileLocate.xiandaohui .. "pp_title.png",81,23)
    -- spr_bg:addChild(title_bg,2);

    MUtils:create_zxfont(panel,Lang.xiandaohui[67],width/2,165,2,16); -- [67] = "匹配中...",
    -- MUtils:create_sprite(panel,UIResourcePath.FileLocate.xiandaohui.."pp_t1.png",165,140)
    self.time_view = MUtils:create_zxfont(panel,LangGameString[825],width/2,125,2,16); -- [825]="已等待:"

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            UIManager:hide_window("pipei_dialog");
        end
        return true
    end
    self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_cancel_fun,140,18,-1,-1);
    MUtils:create_zxfont(self.btn2,Lang.common.confirm[9],99/2,20,2,16); -- [9] = "#cd0cda2取消", 
    -- MUtils:create_sprite(self.btn2,UIResourcePath.FileLocate.normal .. "quxiao.png",55,20.5)

    -- 去除关闭按钮
    self._exit_btn.view:setIsVisible(false)
end

function PiPeiDialog:init_with_arg()
    self.time_view:setText(LangGameString[826]..LangGameString[827]); -- [826]="#cfff000已等待:#c66ff661" -- [827]="#cfff000秒"
    self.time = 1;
    if ( self.timer ) then
        self.timer:stop();
        self.timer = nil;
    end
    self.timer = timer();
    local function timer_fun()
        self.time = self.time + 1;
        print("self.time = ",self.time);
        self.time_view:setText(LangGameString[828]..self.time..LangGameString[827]) -- [828]="#cfff000已等待:#c66ff66" -- [827]="#cfff000秒"
    end
    self.timer:start(1,timer_fun)
end

function PiPeiDialog:destroy()
    XianDaoHuiCC:cancel_matching()
    if ( self.timer ) then
        self.timer:stop();
        self.timer = nil;
    end
    Window.destroy(self);
end

function PiPeiDialog:active( show )
    if ( show == false ) then
        if ( self.timer ) then
            self.timer:stop();
            self.timer = nil;
        end
        XianDaoHuiCC:cancel_matching()
    end
end
