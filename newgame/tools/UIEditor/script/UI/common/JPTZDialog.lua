-- JPTZDialog.lua
-- created by hcl on 2013/3/14
-- 用于创建多个对话框,有些对话框会同时存在多个

-- 3件极品套装的提示框 350,320

require "UI/component/Window"
require "utils/MUtils"
super_class.JPTZDialog(Window)

-- 记录当前显示的对话框数量

function JPTZDialog:show( )
    -- 创建通用购买面板
    local win = UIManager:show_window("jptz_dialog");
end


local function get_jptz_item_id_by_job( job )
    -- "天雷", "蜀山", "圆月", "云华"
    if ( job == 1 ) then
        return {7111, 8111, 6111};
    elseif ( job == 2 ) then
        return {7211, 8211, 6211};
    elseif ( job == 3 ) then
        return {7311 ,8311, 6311};
    elseif ( job == 4 ) then
        return {7411, 8411, 6411};
    end
end

--圆月：魔啸链：7311、魔啸佩：8311，魔啸戒 6311
--天雷：碧晶链 7111，碧晶佩：8111，碧晶戒 6111
--云华：摄魂链 7411 摄魂佩：8411，摄魂戒 6411
--蜀山：青灵链7211 青灵佩：8211 青灵戒：6211

-- 
function JPTZDialog:__init()
    -- 标题
    -- local title = MUtils:create_sprite(self.view, UI_JPTZDailog_001, 210, 494);
    -- title:setAnchorPoint(CCPointMake(0.5, 0.5))

    -- self.exit_btn:setPosition(375,412)

    local spr_bg = CCBasePanel:panelWithFile( 0, 80, 425, 372, UILH_COMMON.dialog_bg, 500, 500 );
    self.view:addChild( spr_bg);

    self:create_title()

    self.bottom_bg = CCBasePanel:panelWithFile(13,93,400,315,UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(self.bottom_bg)
    MUtils:create_zximg(self.bottom_bg,UILH_JPTZ.text1,38,265,-1,-1)
    MUtils:create_zximg(self.bottom_bg,UILH_JPTZ.text2,77,227,-1,-1)
    MUtils:create_zximg(self.bottom_bg,UILH_JPTZ.text3,11,95,-1,-1)
    MUtils:create_zximg(self.bottom_bg,UILH_JPTZ.text4,109,56,-1,-1)

    -- MUtils:create_zxfont(self.bottom_bg,Lang.tip[3],400/2,75,2,16);

    -- 装备背景
    ZImage:create(self.bottom_bg, UILH_NORMAL.title_bg4, 0, 131, 400, 100, 0, 500, 500)

    -- 说明
    -- self.explain_img = ZImage:create(spr_bg, UI_JPTZDailog_003, 16, 5, -1, -1)

    -- 中级强化石
    -- local qhz_slot_item = MUtils:create_slot_item(spr_bg, UIPIC_ITEMSLOT, 157, 350, 72, 72, 18711)
    -- self.qhz_tips = ZImage:create(spr_bg, UI_JPTZDailog_007, 148, 331, -1, -1);
    -- self.qhz_tips.view:setIsVisible( false )

    local player = EntityManager:get_player_avatar();
    local jptz_table = get_jptz_item_id_by_job( player.job );
    self.slot_item_table = {};
    self.slot_item_effect={}
    for i=1,3 do
        -- 道具icon
        self.slot_item_table[i] = MUtils:create_slot_item2( self.bottom_bg, UILH_COMMON.slot_bg, 65 + (i-1)* 100, 145, 72, 72, jptz_table[i],nil,5 );
        self.slot_item_table[i]:set_color_frame(jptz_table[i], 0, 0, 72, 72);
    end

    local function btn_event( eventType )
        -- if eventType == TOUCH_CLICK then
            -- local can_get, had_get = MallModel:get_taozhuang_info()
            -- if can_get then
            --     MiscCC:req_get_present( 1 )
            --     UIManager:hide_window("jptz_dialog");
            -- else
                -- 打开商城界面
                UIManager:hide_window("jptz_dialog");
                MallWin:show_xszy()
                -- MallModel:buy_jipinzhuangbei( 18711, "hot" )
            -- end
        -- end
        -- return true
    end
    self.get_btn = ZButton:create(self.view,UILH_NORMAL.special_btn,btn_event,140,100,-1,-1)
    self.get_btn:addImage(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    self.get_btn.view:setCurState(CLICK_STATE_UP)
    self.get_btn_lab = ZImage:create(self.get_btn.view,UILH_JPTZ.lijigoumai,112.5,30,-1,-1)
    self.get_btn_lab.view:setAnchorPoint(0.5, 0.5)
    self.get_btn_lab.view:setPosition(162/2,53/2)
end

function JPTZDialog:create_title(  )
    --标题背景
    self.title_bg = CCBasePanel:panelWithFile( 0, 0, -1, 60, UIPIC_COMMOM_title_bg )
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( 68, 407)
    self.title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  UILH_JPTZ.title  )
    self.title:setAnchorPoint(0.5,0.5)
    self.title_bg:addChild( self.title )
    self.view:addChild( self.title_bg )
end

function JPTZDialog:active( show )
    if ( show ) then
        self.exit_btn:setPosition(375,412)
        if ( #self.slot_item_table > 0 ) then
            for i=1,#self.slot_item_table do
                LuaEffectManager:stop_view_effect( 57,self.slot_item_table[i].icon )
                local spr = LuaEffectManager:play_view_effect( 57,0,0,self.slot_item_table[i].icon ,true);
                spr:setPosition(CCPointMake(33, 32))
                self.slot_item_effect[i]=spr
            end
        end

        -- local can_get, had_get = MallModel:get_taozhuang_info()
        -- if can_get then
        --     self.get_btn_lab:setTexture(UILH_BENEFIT.lingqujiangli)
        --     self.get_btn_lab:setSize(78, 24)
        --     -- self.explain_img:setTexture(UI_JPTZDailog_004)
        --     -- self.qhz_tips.view:setIsVisible( true )
        -- else
        --     self.get_btn_lab:setTexture(UILH_JPTZ.lijigoumai)
        --     self.get_btn_lab:setSize(79, 22)
        --     -- self.explain_img:setTexture(UI_JPTZDailog_003)
        --     -- self.qhz_tips.view:setIsVisible( false )
        -- end
    end
end

function JPTZDialog:destroy()
     for i=1,3 do
        LuaEffectManager:stop_view_effect( 57,self.slot_item_table[i].icon )
        self.slot_item_table[i]=nil
        self.slot_item_effect[i]=nil
    end
    self.slot_item_table=nil
    self.slot_item_effect=nil
    Window.destroy(self)
end

function JPTZDialog:update( can_get, had_get )
    -- if can_get then
    --    self.get_btn_lab:setTexture(UILH_BENEFIT.lingqujiangli)
    --    self.get_btn_lab:setSize(78, 24)
    --    -- self.explain_img:setTexture(UI_JPTZDailog_004)
    --    -- self.qhz_tips.view:setIsVisible( true )
    -- else
    --    self.get_btn_lab:setTexture(UILH_JPTZ.lijigoumai)
    --    self.get_btn_lab:setSize(79, 22)
    --    -- self.explain_img:setTexture(UI_JPTZDailog_003)
    --    -- self.qhz_tips.view:setIsVisible( false )
    -- end
end