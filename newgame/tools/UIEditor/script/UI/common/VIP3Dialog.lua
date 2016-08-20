-- VIP3Dialog.lua
-- created by hcl on 2013/3/19
-- VIP3体验卡

require "UI/component/Window"
require "utils/MUtils"
super_class.VIP3Dialog(Window)

-- 250,310
function VIP3Dialog:__init()
    local panel = self.view;

    MUtils:create_sprite(panel,UIResourcePath.FileLocate.other .. "vip3_title.png",212 ,340 );

    -- 九宫格背景
    -- MUtils:create_zximg(panel,UIResourcePath.FileLocate.common .. "nine_grid_bg.png", 20,50,230,225,500,500);

    -- 关闭按钮
    local function btn_close_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            UIManager:hide_window("vip3_dialog");
        end
        return true
    end
    local exit_btn = MUtils:create_btn(panel,UIResourcePath.FileLocate.common .. "close_btn_z.png",UIResourcePath.FileLocate.common .. "close_btn_z.png",btn_close_fun,0,0,-1,-1);
    local exit_btn_size = exit_btn:getSize()
    local spr_bg_size = panel:getSize()
    exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width +20, spr_bg_size.height - exit_btn_size.height +20)
    MUtils:create_slot_item(panel,UIPIC_ITEMSLOT,182,237,60,60,48200);

    -- MUtils:create_zxfont(panel,LangGameString[847],125,180,2,15); -- [847]="#c35c3f7可以免费享受"
    -- MUtils:create_zxfont(panel,LangGameString[848],125,150,2,18); -- [848]="#cfff00030分钟仙尊3特权"
    -- -- 线
    -- MUtils:create_zximg(panel,"ui/common/coner2.png", 25 ,140,200,2,10,2);
    -- MUtils:create_zxfont(panel,LangGameString[849],40,110,1,14); -- [849]="#cfff000·免费无限速传"
    -- MUtils:create_zxfont(panel,LangGameString[850],40,90,1,14); -- [850]="#cfff000·每日免费领取15礼券"
    -- MUtils:create_zxfont(panel,LangGameString[851],40,70,1,14); -- [851]="#cfff000·开启随身商店和仓库"
    ZCCSprite:create(panel,"ui/other/vip3_bg.png",212-5,210)
    ZCCSprite:create(panel,"ui/other/vip3.png",212,150)
    -- 
    local function btn_ok_fun(eventType,x,y)
        UIManager:hide_window("vip3_dialog");
        local _use_item = ItemModel:get_item_info_by_id( 48200 )
        -- 使用
        ItemModel:use_one_item( _use_item );
    end
    local btn = ZImageButton:create(panel,UIResourcePath.FileLocate.common .. "button_red.png","ui/other/t_lqsy.png",btn_ok_fun,212,10); -- [852]="领取使用"
    btn.view:setAnchorPoint(0.5,0);
    return self;
end

function VIP3Dialog:active( show )
    if ( show == false ) then
        -- local quest_id = XSZYManager:get_data();
        AIManager:do_quest( TaskModel:get_zhuxian_quest() );
    end
end
