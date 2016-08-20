-- XianDaoBaoHeWin.lua
-- create by hcl on 2013-8-31
-- 仙道宝盒

super_class.XianDaoBaoHeWin(NormalStyleWindow)

-- 是否使用黄金手
local is_use_hjs = false;
-- 是否在转盘中
local is_working = false;
-- 是否显示提示
local is_show_next = true;

function XianDaoBaoHeWin:show( item_series,items,award_item )
    local win = UIManager:show_window("xiandaobaohe_win");
    if ( win ) then
        win:init_with_args( item_series,items,award_item );
    end
end

local tab_item_pos = { 
    {206,467-13}, 
    {290,467-32},
    {335,355},
    {335,275},
    {290,200},
    {206,178},
    {122,200},
    {75,275},
    {75,355},
    {122,467-35},
};

local tab_item_pos2 = {
    {206,467-13},
    {290,467-32},
    {335,355},
    -- {167+80+45,303-28-69-78},
    -- {167+80,303-28-69-78-69},
    {206,178},
    -- {166-80,303-28-69-78-69},
    -- {166-80-45,303-28-69-78},
    -- {166-80-45,303-28-69},
    {122,467-35},
}

function XianDaoBaoHeWin:__init( )

    local bg = Image:create( nil, 7, 11, 423, 560, UILH_COMMON.normal_bg_v2, 600, 600 )
    self.view:addChild( bg.view )
    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "win_title1.png",194.5,405);
    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "xdbh_title.png",194.5,405);

    local chong_bg = ZImage:create(self.view, UILH_COMMON.bottom_bg, 28, 24, 380, 530, 0, 500, 500) 
    -- 抽奖背景
    MUtils:create_zximg(chong_bg,UILH_LUOPAN.luopan_bg,3,151,374, 374)

    local function xdbh_fun(eventtype,args,msgid)
    	if ( eventtype == TOUCH_CLICK ) then

            -- 判断仙道宝盒还在不在
            if ( ItemModel:get_item_by_series( self.item_series ) == nil ) then
                GlobalFunc:create_screen_notic(Lang.xiandaohui.baohe[1])   -- [1] = "仙道宝盒已用完"
                return;
            end

            local player = EntityManager:get_player_avatar();
            if is_use_hjs and player:check_is_enough_money(4,48) == false then
                return;
            end
            if ( is_working == false  ) then
                local function choujiang()
                    self.ksxq_btn:setCurState( CLICK_STATE_DISABLE )
                    is_working = true;
                    local param = 0;
                    if ( is_use_hjs ) then
                        param = 1;
                    end
                    OnlineAwardCC:req_choujiang( self.item_series,param );
                    self:start_choujiang_ani()
                end

                if ( is_show_next and is_use_hjs == false ) then
                    local function fun( _show_tip )
                        choujiang();
                    end
                    local function swith_but_func ( _show_tip )
                        is_show_next = not _show_tip;
                    end
                    --NormalDialog2:show("#c66ff66消耗#cfff000" ..fight_need_yuanbao.."元宝#c66ff66增加挑战次数",fun,true);
                    ConfirmWin2:show( 5, nil, Lang.xiandaohui.baohe[2],  fun, swith_but_func ) -- [2249]="使用黄金手能让您获得珍贵道具的概率更大哦！"
                else
                    choujiang();
                end
         
            else
                GlobalFunc:create_screen_notic( Lang.xiandaohui.baohe[3] ); -- [2250]="仙道宝盒使用中，请耐心等待。"
            end
            
    	end
    	return true;
    end

    self.ksxq_btn = MUtils:create_btn(self.view,UILH_LUOPAN.kaishichoujiang_bg,UILH_LUOPAN.kaishichoujiang_bg,xdbh_fun,222,359,-1,-1);
    self.ksxq_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_LUOPAN.kaishichoujiang_bg);
    self.ksxq_btn:setAnchorPoint(0.5,0.5);

    local ksxq_img = CCZXImage:imageWithFile( 66, 73, -1, -1, UILH_XIANDAOHUI.kaishixuanze )
    ksxq_img:setAnchorPoint(0.5,0.5);
    self.ksxq_btn:addChild(ksxq_img)

    self.tab_slot_item = {};
    self.items = XDHModel:get_xdbh_items();
    for i=1,10 do
        self.tab_slot_item[i] = MUtils:create_slot_item2(self.view ,UILH_COMMON.slot_bg2,tab_item_pos[i][1]+13,tab_item_pos[i][2]+44,60,60,self.items[i],nil,6);
        self.tab_slot_item[i]:set_color_frame(self.items[i],-1,-1,62,62);
        self.tab_slot_item[i].view:setAnchorPoint(0.5,0.5)
        -- self.tab_slot_item[i].view:setScaleX(45/63);
        -- self.tab_slot_item[i].view:setScaleY(45/63);
    end
    self.items2 = XDHModel:get_xdbh_hjs_items();


    -- 是否使用黄金手
    local function use_shield_fun(  )
        is_use_hjs = not is_use_hjs;
        self:set_drak_item_visible( not is_use_hjs )
    end
    self.toggle_view = ToggleView:create(1,self.view,38,120,170,38,use_shield_fun,CCPoint(0,0),nil,UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2);
    MUtils:create_zxfont(self.toggle_view,Lang.xiandaohui[65],40,12,1,15); -- [65] = "#cfff000黄金手#cffffff（48元宝）",

    local function btn_xdbh_fun( eventtype,args,msgid )
        if eventtype == TOUCH_CLICK then
            use_shield_fun();
        end
        return true;
    end
    -- MUtils:create_sprite(self.toggle_view,UIResourcePath.FileLocate.xiandaohui.."xdbh_hjs.png",58,13,10);
    MUtils:create_zxfont(self.view,Lang.xiandaohui[66],435/2,90,2,15); -- [66] = "使用黄金手可以在5个价值最高的道具中选取",

end

function XianDaoBaoHeWin:init_with_args(  item_series,items,award_item )
    self.item_series = item_series;
    self.slow_down_time = 999999 -- 先让它不停的旋转
    --self.items = items;
    -- for i=1,#items do
    --     self.tab_slot_item[i]:update( items[i] ,1);
    -- end
    self.result_item = award_item;
end

function XianDaoBaoHeWin:active( show )
    if ( show == false ) then
        --OnlineAwardCC:req_finish_choujiang( self.item_series );
        if ( self.ani_timer) then
            self.ani_timer:stop();
            self.ani_timer = nil;
        end
        if ( self.spr_select ) then
            self.spr_select:removeFromParentAndCleanup(true);
            self.spr_select = nil;
        end
        if ( is_working  ) then
            -- 申请领取奖品
            OnlineAwardCC:req_finish_choujiang( self.item_series )
            is_working = false;
            self.ksxq_btn:setCurState( CLICK_STATE_UP )
        end
    else
        LuaEffectManager:stop_view_effect( 11009,self.tab_slot_item[1].view )
        LuaEffectManager:stop_view_effect( 11009,self.tab_slot_item[6].view )
        -- 播放特效
        LuaEffectManager:play_view_effect( 11009,30,28,self.tab_slot_item[1].view,true )
        LuaEffectManager:play_view_effect( 11009,30,28,self.tab_slot_item[6].view,true )
    end
end

local SLOW_DOWN_TIME_RATE = 5;

function XianDaoBaoHeWin:update_result_item( result_item )
    self.result_item = result_item;

    local items = nil;
    local start_time = 40;
    if ( is_use_hjs ) then
        items = self.items2;
        start_time = start_time/2;
    else
        items = self.items;
    end

    local result_item_index = 1;
    -- for i=1,#items do
    --     if ( items[i] == self.result_item ) then
    --         result_item_index = i;
    --         break;
    --     end
    -- end
    for i=1,10 do
        if items[i] then 
            if ( items[i] == self.result_item ) then
                break;
            end
            result_item_index = result_item_index + 1;
        end
    end
    print("result_item_index = ",result_item_index,"#items = ",#items,"is_use_hjs",is_use_hjs);

    self.slow_down_time = start_time +  ( result_item_index - 5 );

    self.result_time_index = self.slow_down_time +  5*SLOW_DOWN_TIME_RATE
    print("self.slow_down_time,self.result_time_index",self.slow_down_time,self.result_time_index);
end

function XianDaoBaoHeWin:start_choujiang_ani()
    self.toggle_view:setIsVisible(false);

    if ( self.spr_select ) then
        self.spr_select:removeFromParentAndCleanup(true);
        self.spr_select = nil;
    end

    self.spr_select = MUtils:create_sprite(self.view,UILH_NORMAL.light_grid,-500,-500)
    self.spr_select:setScale(0.8)

    self.ani_timer = timer();
    local time_index = 0;       --当前时间
    local curr_select_index = 0;

    local item_count = 10;
    local tab_pos = tab_item_pos;
    if ( is_use_hjs ) then 
        item_count = 5;
        tab_pos = tab_item_pos2;
    end

    local function timer_fun()
        time_index = time_index+1;
        if ( time_index < self.slow_down_time ) then
            curr_select_index = curr_select_index%item_count + 1;
            self.spr_select:setPosition( tab_pos[curr_select_index][1]+13,tab_pos[curr_select_index][2]+44 );
        elseif ( time_index < self.result_time_index ) then
            if ( (time_index-self.slow_down_time) %SLOW_DOWN_TIME_RATE == 0 ) then
                curr_select_index = curr_select_index%item_count + 1;
                self.spr_select:setPosition( tab_pos[curr_select_index][1]+13,tab_pos[curr_select_index][2]+44 );
            end
        elseif ( time_index == self.result_time_index ) then
            curr_select_index = curr_select_index%item_count + 1;
            self.spr_select:setPosition( tab_pos[curr_select_index][1]+13,tab_pos[curr_select_index][2]+44 );
            self.ani_timer:stop();
            self.ani_timer = nil;
            -- 申请领取奖品
            OnlineAwardCC:req_finish_choujiang( self.item_series )
            is_working = false;
            self.ksxq_btn:setCurState( CLICK_STATE_UP )
            self.toggle_view:setIsVisible(true);
        end
    end

    self.ani_timer:start( 0.1,timer_fun );

end

function XianDaoBaoHeWin:set_drak_item_visible( visible  )
    local drak_items = XDHModel:get_xdbh_remove_items()
    for i=1,#drak_items do
        self.tab_slot_item[drak_items[i]+1].view:setIsVisible(visible);
    end
end

function XianDaoBaoHeWin:destroy()
    if ( self.ani_timer) then
        self.ani_timer:stop();
        self.ani_timer = nil;
    end
    if ( self.spr_select ) then
        self.spr_select:removeFromParentAndCleanup(true);
        self.spr_select = nil;
    end
    if ( is_working  ) then
        -- 申请领取奖品
        OnlineAwardCC:req_finish_choujiang( self.item_series )
        is_working = false;
        self.ksxq_btn:setCurState( CLICK_STATE_UP )
    end
    -- 是否使用黄金手
    is_use_hjs = false;
    -- 是否在转盘中
    is_working = false;
    -- 是否显示提示
    is_show_next = true;
    Window.destroy(self);
end
