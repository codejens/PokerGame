-- VIPDialog.lua
-- created by hcl on 2013/3/28
-- vip提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.VIPDialog(Window)

function VIPDialog:show()
    UIManager:show_window("vip_dialog",true);
end

-- 
function VIPDialog:__init()
	local panel = self.view;
	local spr_bg = CCZXImage:imageWithFile( 0, 0, 300, 135, UIResourcePath.FileLocate.common .. "common_tip_bg.png", 500, 500 );
    panel:addChild( spr_bg );

    -- 九宫格背景
    MUtils:create_zximg(panel,UIPIC_GRID_nine_grid_bg3, 12,45,276,76,500,500);

    local dialog = MUtils:create_ccdialogEx(panel,LangGameString[853],15,115,270,65,255,10); -- [853]="成为#cfff000仙尊3#cffffff级玩家,每日免费#cfff000无限速传#r#cffffff成为#cfff000仙尊2#cffffff级玩家,每日免费速传#cfff00020#cffffff次#r#cffffff成为#cfff000仙尊1#cffffff级玩家,每日免费速传#cfff00010#cffffff次"
    
    dialog:setAnchorPoint(0,1);

    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
     		UIManager:hide_window("vip_dialog");
     	    -- 打开vip界面
            UIManager:show_window("vipSys_win");
        end
        return true
    end
    MUtils:create_btn_and_lab(panel,UIResourcePath.FileLocate.common .. "button2_bg.png",UIResourcePath.FileLocate.common .. "button2_bg.png",btn_ok_fun,110,10,80,31,LangGameString[611]); -- [611]="成为仙尊"

    -- local function btn_close_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:hide_window("vip_dialog");
    --     end
    --     return true
    -- end

    -- local exit_btn = MUtils:create_btn(panel,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,0,0,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    -- local spr_bg_size = panel:getSize()
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )

end
