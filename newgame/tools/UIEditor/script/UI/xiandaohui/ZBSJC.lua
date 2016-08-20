-- ZBSJC.lua
-- create by hcl on 2013-8-17
-- 争霸赛进程

super_class.ZBSJC(NormalStyleWindow)

function ZBSJC:show()
    local win = UIManager:show_window("zbsjc")
    if ( win ) then
        win:update_view();
    end
end

local title_x = 184.5;
local title_y = 186;

function ZBSJC:__init( window_name, texture_name, is_grid, width, height,title_text )

    --盖住父类bg
    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

    -- --MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "bg01.png",194.5, 214.5)
    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "win_title1.png",194.5,405);
    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_title.png",194.5,405);

    -- local function btn_close_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:hide_window("zbsjc");
    --     end
    --     return true
    -- end
    -- local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,330,380,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    -- local spr_bg_size = self.view:getSize()
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )

    -- 背景
    MUtils:create_zximg(self.view,UILH_COMMON.bottom_bg,12,48,410,285,500,500);
    -- 
    -- self.zbsjc_bg = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_bg.png",194.5, 280)
    self.title_text = {Lang.xiandaohui[53],Lang.xiandaohui[55],Lang.xiandaohui[56],Lang.xiandaohui[57]}
    self.zbsjc_title = MUtils:create_zxfont(self.view,self.title_text[1],435/2,340,2,18);    -- [53] = "#cfff000十六强争霸赛第一轮",
    -- MUtils:create_sprite(self.zbsjc_bg,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_t1.png",title_x,title_y);
    -- 线
    -- for i=1,5 do
    --     local x = 32;
    --     local y = 325 - (i-1)*54;
    --     local width = 322;
    --     if i >3 then
    --         x = 10;
    --         width = 366;
    --     end
    --     ZImage:create(self.view,UILH_COMMON.split_line,x,y,width,3)   
    -- end
    

    self.tab_weiguan_views = {};
    for i=1,4 do
        self.tab_weiguan_views[i] = {};
        local y = 300-(i-1)*70;
        self.tab_weiguan_views[i].lab_vs = MUtils:create_zxfont(self.view,"",20,y,1,15); -- [2262]="#cfff000满身大汉    vs    小钢炮"
        self.tab_weiguan_views[i].lab_result = MUtils:create_zxfont(self.view,"",20,y-25,1,15); -- [2263]="比赛状态:#cfff000小钢炮胜利，晋级8强赛"
        local function btn_weiguan_fun(eventType,args,msg_id)
            if ( eventType == TOUCH_CLICK ) then
                -- TODO 
                XDHModel:move_to_letai( i )
            end
            return true
        end
        self.tab_weiguan_views[i].btn_wg = MUtils:create_btn_and_lab(self.view,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_weiguan_fun,317,y-30,-1,-1,Lang.xiandaohui[32],15); -- [2264]="围观"

    end

    self.lab_next_match = MUtils:create_zxfont(self.view,"",width/2,20,2,17); -- [2265]="#c35c3f7十六强争霸赛第二轮将于 #cfff00020:40 #c35c3f7开始"
end

function ZBSJC:update_view(  )
    self.zbs_info = XDHModel:get_zbs_info()
    local turn = self.zbs_info.turn;
    -- if ( self.zbsjc_title ) then 
    --     self.zbsjc_title:removeFromParentAndCleanup(true);
    -- end
    local match_index = XDHModel:get_xdh_state()
    print("ZBSJC:update_view,match_index ",match_index)
    if ( turn == 1 and match_index == 2 ) then

        self.zbsjc_title:setText(Lang.xiandaohui[54]); -- [54] = "#cfff000十六强争霸赛第二轮",
    else
        -- self.zbsjc_title = MUtils:create_sprite(self.zbsjc_bg,UIResourcePath.FileLocate.xiandaohui .. "zbsjc_t"..turn..".png",title_x,title_y);
        if self.title_text[turn] ~= nil then
            self.zbsjc_title:setText(self.title_text[turn]);
        end
    end
    
    -- 取得当前轮的擂台数
    local lt_count = self:get_lt_count( turn );
    for i=1,4 do
        if ( i <= lt_count ) then
            print("turn,i",turn,i);
            local p1,p2 = self:get_players_by_le_index( turn,i ,match_index)
            local str = self:get_result_str( turn,i ,match_index);
            print("str = ",str);
            self.tab_weiguan_views[i].lab_result:setText( str )
            -- str = string.format("#cfff000%-15svs%15s",p1.name,p2.name)
            str = string.format("#cfff000%s vs %s",p1.name,p2.name)
            self.tab_weiguan_views[i].lab_vs:setText(str);
            self.tab_weiguan_views[i].btn_wg:setIsVisible(true);
        else
            self.tab_weiguan_views[i].lab_result:setText( "" )
            self.tab_weiguan_views[i].lab_vs:setText("");
            self.tab_weiguan_views[i].btn_wg:setIsVisible(false);
        end
    end

    local left_time_info = Utils:format_time_to_info( self.zbs_info.state_left_time );
    local curr_time_info = os.date("*t",os.time());

    local second = (left_time_info.min-curr_time_info.min)*60 - curr_time_info.sec;
    if ( second > 0 ) then
        print("下阶段剩余时间",second)

        local time_str = Utils:format_time_to_time( self.zbs_info.state_left_time , ":")
        local str = self:get_next_str( time_str )
        -- 下场比赛时间
        self.lab_next_match:setText(str)

        if ( self.timer_lab ) then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end 

        local function end_call(  )
            UIManager:hide_window("zbsjc");
        end
        self.timer_lab = TimerLabel:create_label(self.view, 30, 348, 15, second, "#cfff000",end_call );
    end
end

-- 根据擂台索引取得该擂台比赛的两个玩家数据
function ZBSJC:get_players_by_le_index( turn,lei_tai ,match_index)
    local d = self:get_index_by_turn( turn )
    if ( turn == 1  ) then
        -- 第一轮第二场的特殊处理
        if ( match_index == 2 ) then
            d = 8
        end
        local player_struct_1 = self.zbs_info.xdhzbs_player_table[(lei_tai-1)*2+1+d];
        local player_struct_2 = self.zbs_info.xdhzbs_player_table[(lei_tai-1)*2+2+d];
        return player_struct_1,player_struct_2;
    else
        -- 从8强赛开始，取得上一轮 胜利的两个玩家，作为现在比赛的选手
        local d2 = self:get_index_by_turn( turn - 1 );
        local win_index = self.zbs_info.pk_state_info[ d2 + (lei_tai-1)*2 + 1 ].player_index;
        local win_index2 = self.zbs_info.pk_state_info[ d2 + (lei_tai-1)*2+2].player_index;
        print("win_index,win_index2",win_index,win_index2)
        local player_struct_1 = self.zbs_info.xdhzbs_player_table[win_index];
        local player_struct_2 = self.zbs_info.xdhzbs_player_table[win_index2];
        return player_struct_1,player_struct_2;
    end
end

function ZBSJC:get_lt_count( turn )
    if ( turn == 3 ) then
        return 2;
    elseif ( turn == 4 ) then
        return 1;
    end
    return 4;
end

function ZBSJC:get_index_by_turn( turn )
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

function ZBSJC:get_result_str( turn,lei_tai ,match_index)
    local turn_index = self:get_index_by_turn( turn )
    if turn == 1 and match_index == 2 then
        turn_index = turn_index + 4;
    end
    local win_index = self.zbs_info.pk_state_info[turn_index + lei_tai].player_index;
    local str = "";
    if ( win_index == 0 ) then
        str = Lang.xiandaohui[33]; -- [2266]="比赛状态:#cfff000比赛中"
    else
        local player_struct = self.zbs_info.xdhzbs_player_table[win_index];
        str = Lang.xiandaohui[34]..player_struct.name; -- [2267]="比赛状态:#cfff000"
        if ( turn == 1 ) then
            str = str.. Lang.xiandaohui[35] -- [2268]="胜利，晋级八强"
        elseif ( turn == 2 ) then
            str = str.. Lang.xiandaohui[36] -- [2269]="胜利，晋级四强"
        elseif ( turn == 3 ) then
            str = str.. Lang.xiandaohui[37] -- [2270]="胜利，晋级决赛"
        elseif ( turn == 4 ) then
            str = str.. Lang.xiandaohui[38] -- [2271]="胜利，获得冠军"
        end
    end

    return str;
end

function ZBSJC:active( show )
    if ( show == false ) then
        if ( self.timer_lab ) then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end 
    end
end

function ZBSJC:destroy()
    if ( self.timer_lab ) then
        self.timer_lab:destroy();
        self.timer_lab = nil;
    end 
    Window.destroy(self);
end

function ZBSJC:get_next_str( time_str )
    local match_index = XDHModel:get_xdh_state()
    local turn = self.zbs_info.turn;
    print("match_index = ",match_index);
    if ( turn == 1 ) then
        if ( match_index ~= 2 ) then
            return Lang.xiandaohui[39]..time_str..Lang.xiandaohui[40] -- [2272]="#c35c3f7十六强争霸赛第二轮将于 #cfff000" -- [2273]=" #c35c3f7开始"
        else
            return Lang.xiandaohui[39]..time_str..Lang.xiandaohui[41] -- [2272]="#c35c3f7十六强争霸赛第二轮将于 #cfff000" -- [2274]=" #c35c3f7结束"
        end
    elseif ( turn == 2 ) then
        return Lang.xiandaohui[42]..time_str..Lang.xiandaohui[41] -- [2275]="#c35c3f7八强争霸赛将于 #cfff000" -- [2274]=" #c35c3f7结束"
    elseif (turn == 3 ) then
        return Lang.xiandaohui[43]..time_str..Lang.xiandaohui[41] -- [2276]="#c35c3f7四强将于 #cfff000" -- [2274]=" #c35c3f7结束"
    elseif ( turn == 4 ) then
        return Lang.xiandaohui[44]..time_str..Lang.xiandaohui[41] -- [2277]="#c35c3f7决赛将于 #cfff000" -- [2274]=" #c35c3f7结束"
    end
end
