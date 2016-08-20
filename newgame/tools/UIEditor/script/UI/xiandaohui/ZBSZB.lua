-- ZBSZB.lua
-- create by hcl on 2013-8-17
-- 争霸赛准备

super_class.ZBSZB(NormalStyleWindow)

function ZBSZB:show()
    local win = UIManager:show_window("zbszb")
    if ( win ) then
        win:update_view();
    end
end

local title_x = 184.5;
local title_y = 186;

function ZBSZB:__init( window_name, texture_name, is_grid, width, height,title_text )

    --盖住父类bg
    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

    -- 背景
    MUtils:create_zximg(self.view,UILH_COMMON.bottom_bg,12,60,410,273,500,500);
    -- 
    -- self.zbsjc_bg = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_bg.png",194.5, 280)
    -- self.zbsjc_title = MUtils:create_sprite(self.zbsjc_bg,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_zb_t1.png",title_x,title_y);
    
    self.title_text = {Lang.xiandaohui[58],Lang.xiandaohui[59],Lang.xiandaohui[60],Lang.xiandaohui[61]}
    self.zbsjc_title = MUtils:create_zxfont(self.view,self.title_text[1],435/2,340,2,18);    -- [58] = "十六强争霸赛准备",

    self.title_text2 = {Lang.xiandaohui[62],Lang.xiandaohui[63],Lang.xiandaohui[64]}
    self.title1 = MUtils:create_zxfont(self.view,self.title_text2[1],21,310,1,16);  -- [62] = "#cfff000第一轮参赛者名单如下：",
    self.title2 = MUtils:create_zxfont(self.view,self.title_text2[2],21,180,1,16);  -- [63] = "#cfff000第二轮参赛者名单如下：",
    self.title2:setIsVisible(false)

    -- 线
    -- ZImage:create(self.view,UILH_COMMON.split_line,32,325,322,3);
    -- ZImage:create(self.view,UILH_COMMON.split_line,32,195,322,3);
    -- 标签一的背景
    -- local img = ZImage:create(self.view,UILH_COMMON.bottom_bg,194.5,310,240,12,0,500,500)
    -- img:setAnchorPoint(0.5,0.5);
    -- local function btn_close_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:hide_window("zbszb");
    --     end
    --     return true
    -- end
    -- local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,330,380,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    -- local spr_bg_size = self.view:getSize()
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )


    -- self.title1 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .."zbsjc_zb_tt1.png",125,300)
    -- self.title2 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .."zbsjc_zb_tt2.png",125,180)

    self.tab_lab_vs = {};
    local y = 285
    for i=1,8 do
        if ( i == 5) then
            y = 250
        end
        self.tab_lab_vs[i] = {};
        self.tab_lab_vs[i].name1 = MUtils:create_zxfont(self.view,"",197.5,y-(i-1)*25,3,15);
        self.tab_lab_vs[i].vs = MUtils:create_zxfont(self.view,"",217.5,y-(i-1)*25,2,15);
        self.tab_lab_vs[i].name2 = MUtils:create_zxfont(self.view,"",237.5,y-(i-1)*25,1,15);
    end

    local function xz_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            local win = UIManager:show_window("xiandaohui_win");
            if ( win ) then
                win:do_tab_button_method(2)
            end
            UIManager:hide_window("zbszb");
        end
        return true
    end
    self.btn1 = MUtils:create_btn(self.view,UILH_COMMON.lh_button_4_r, UILH_COMMON.lh_button_4_r,xz_fun,158,7,-1,-1);
    MUtils:create_zxfont(self.btn1,Lang.xiandaohui[51],121/2,20,2,16); -- [51] = "#cd0cda2下 注"
    -- MUtils:create_sprite(self.btn1,UIResourcePath.FileLocate.xiandaohui .. "xz_btn.png",55,20.5)


end

function ZBSZB:update_view(  )
    self.zbs_info = XDHModel:get_zbs_info()
    local turn = self.zbs_info.turn;
    -- self.zbsjc_title:removeFromParentAndCleanup(true);
    -- self.zbsjc_title = MUtils:create_sprite(self.zbsjc_bg,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_zb_t"..turn..".png",title_x,title_y);
    if self.title_text[turn] ~= nil then
        self.zbsjc_title:setText(self.title_text[turn]);
    end

    if ( turn == 1  ) then
        -- if ( self.title1 ) then
        --     self.title1:removeFromParentAndCleanup(true);
        -- end
        -- self.title1 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .."zbsjc_zb_tt1.png",194.5,310)
        self.title1:setText(self.title_text2[1]);
        self.title2:setIsVisible(true);
    else
        -- if ( self.title1 ) then
        --     self.title1:removeFromParentAndCleanup(true);
        --     self.title1 = nil;
        -- end
        -- if ( self.title2 ) then
        --     self.title2:removeFromParentAndCleanup(true);
        --     self.title2 = nil;
        -- end
        -- self.title1 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .."zbsjc_zb_tt3.png",194.5,310)
        self.title2:setIsVisible(false);
        self.title1:setText(self.title_text2[3]);   -- [64] = "#cfff000参赛者名单如下：",
    end

    -- 取得当前轮的擂台数
    local lt_count = self:get_lt_count( turn );
    for i=1,8 do
        if (  turn == 1 or i <= lt_count ) then
            local p1,p2 = self:get_players_by_le_index( turn,i )
            -- local str = string.format("#cfff000%-15svs%15s",p1.name,p2.name)
            self.tab_lab_vs[i].name1:setText(p1.name);
            self.tab_lab_vs[i].vs:setText("vs");
            self.tab_lab_vs[i].name2:setText(p2.name);
        else
            self.tab_lab_vs[i].name1:setText("")
            self.tab_lab_vs[i].vs:setText("")
            self.tab_lab_vs[i].name2:setText("")
        end
    end

    local left_time_info = Utils:format_time_to_info( self.zbs_info.state_left_time );
    local curr_time_info = os.date("*t",os.time());

    local second = (left_time_info.min-curr_time_info.min)*60 - curr_time_info.sec;
    print("下阶段剩余时间",second)
    if ( second > 0 ) then

        if ( self.timer_lab ) then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end

        local function end_call(  )
            UIManager:hide_window("zbszb");
        end
        self.timer_lab = TimerLabel:create_label(self.view, 30, 348, 15, second, "#cfff000",end_call );
    end

end

-- 根据擂台索引取得该擂台比赛的两个玩家数据
function ZBSZB:get_players_by_le_index( turn,lei_tai )
    local d = self:get_index_by_turn( turn )
    if ( turn == 1  ) then
        local player_struct_1 = self.zbs_info.xdhzbs_player_table[(lei_tai-1)*2+1+d];
        local player_struct_2 = self.zbs_info.xdhzbs_player_table[(lei_tai-1)*2+2+d];
        return player_struct_1,player_struct_2;
    else
        -- 从8强赛开始，取得上一轮 胜利的两个玩家，作为现在比赛的选手
        local d2 = self:get_index_by_turn( turn - 1 );
        print("turn = ",turn,"d2 = ",d2,"lei_tai",lei_tai );
        local win_index = self.zbs_info.pk_state_info[ d2 + (lei_tai-1)*2 + 1 ].player_index;
        local win_index2 = self.zbs_info.pk_state_info[ d2 + (lei_tai-1)*2+2].player_index;
        print( "win_index,win_index2",win_index,win_index2 )
        local player_struct_1 = self.zbs_info.xdhzbs_player_table[win_index];
        local player_struct_2 = self.zbs_info.xdhzbs_player_table[win_index2];
        return player_struct_1,player_struct_2;
    end
end

-- 
function ZBSZB:get_index_by_turn( turn )
    local d = 0;
    if ( turn == 1 ) then
        d = 0 
    elseif ( turn == 2 ) then
        d = 8
    elseif ( turn == 3 ) then 
        d = 12
    elseif ( turn == 4 ) then 
        d = 14
    end
    return d;
end

function ZBSZB:get_lt_count( turn )
    if ( turn == 3 ) then
        return 2;
    elseif ( turn == 4 ) then
        return 1;
    end
    return 4;
end

function ZBSZB:active( show )
    if ( show == false ) then
        if ( self.timer_lab ) then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end 
    end
end

function ZBSZB:destroy()
    if ( self.timer_lab ) then
        self.timer_lab:destroy();
        self.timer_lab = nil;
    end 
    Window.destroy(self);
end
