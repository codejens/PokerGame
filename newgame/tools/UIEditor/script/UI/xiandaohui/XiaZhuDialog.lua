-- XiaZhuDialog.lua
-- create by hcl on 2013-8-16
-- 下注窗口

super_class.XiaZhuDialog(NormalStyleWindow)


local attr_table = {Lang.xiandaohui.xiazhu[1],Lang.xiandaohui.xiazhu[2],Lang.xiandaohui.xiazhu[3] }; -- [2239]="战      力:" -- [2253]="身      价:" -- [2254]="需要仙币:"
local XZ_NEED_MONEY_TABLE = {2500,5000,7500,10000,10000,30000,60000,120000};
-- lei_tai擂台
-- xdh_zbs_user_struct 数据
function XiaZhuDialog:show( lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 ,xiazhu_index,pk_state_index)
    local win = UIManager:show_window("xiazhu_dialog");
    if ( win ) then
        win:init_with_arg(  lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2 ,player_index1,player_index2,xiazhu_index,pk_state_index)
    end
end

function XiaZhuDialog:__init( window_name, texture_name, is_grid, width, height,title_text )

    -- hcl
    -- self.window_title_bg.view:removeFromParentAndCleanup(true);

    --盖住父类bg
    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

    local spr_bg = CCZXImage:imageWithFile( 15, 120, 535, 275, UILH_COMMON.bottom_bg,  500,500);
    self.view:addChild( spr_bg );

    -- 两个人物的背景
    -- local bg1 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "result_p_bg.png",109,220)
    -- local bg2 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "result_p_bg.png",338,220)

    -- vs
    MUtils:create_sprite(self.view,UILH_XIANDAOHUI.vs,width/2,300)

    self.p1_view_table = {};
    self.p2_view_table = {};
    -- 头像
    self.p1_view_table[1] = MUtils:create_zximg(self.view,"scene/npc_half/2/00001.png",22,225,-1,-1);    
    self.p1_view_table[1]:setScale(0.7)
    self.p2_view_table[1] = MUtils:create_zximg(self.view,"scene/npc_half/2/00002.png",335,225,-1,-1);
    self.p2_view_table[1]:setScale(0.7)
    self.p1_view_table[2] = MUtils:create_zxfont(self.view,LangGameString[2244],122,205,2,16) -- [2244]="名字"
    self.p2_view_table[2] = MUtils:create_zxfont(self.view,LangGameString[2244],435,205,2,16) -- [2244]="名字"
    
    for i=1,3 do
        self.p1_view_table[i+2] = MUtils:create_zxfont(self.view,attr_table[i],41,182-(i-1)*25,1,15)
        self.p2_view_table[i+2] = MUtils:create_zxfont(self.view,attr_table[i],350,182-(i-1)*25,1,15)
    end

    local function xiazhu_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            local zbs_info =  XDHModel:get_zbs_info();
            if ( zbs_info.lt_state == 1 ) then 
                local turn = zbs_info.turn;
                if ( PlayerAvatar:check_is_enough_money( 1,XZ_NEED_MONEY_TABLE[turn]) ) then
                    self.btn1:setCurState(CLICK_STATE_DISABLE)
                    self.btn2:setCurState(CLICK_STATE_DISABLE)
                    XianDaoHuiCC:req_xz( turn,self.player_index1 )
                    XDHModel:update_xiazhu_info(self.pk_state_index,self.player_index1);
                end
            else
                GlobalFunc:create_screen_notic( LangGameString[2255] ); -- [2255]="比赛已经开始，不能下注"
            end
        end
        return true
    end
    self.btn1 = MUtils:create_btn(self.view,UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor,xiazhu_1_fun,71,66,-1,-1);
    self.btn1:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.btn4_dis);
    MUtils:create_zxfont(self.btn1,Lang.xiandaohui[51],121/2,20,2,16)  -- "#cffffff下注",

    local function xiazhu_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            local zbs_info =  XDHModel:get_zbs_info();
            if ( zbs_info.lt_state == 1 ) then
                local turn = zbs_info.turn;
                if ( PlayerAvatar:check_is_enough_money( 1,XZ_NEED_MONEY_TABLE[turn]) ) then
                    self.btn1:setCurState(CLICK_STATE_DISABLE)
                    self.btn2:setCurState(CLICK_STATE_DISABLE) 
                    local turn = zbs_info.turn;
                    XianDaoHuiCC:req_xz( turn,self.player_index2 )
                    XDHModel:update_xiazhu_info(self.pk_state_index,self.player_index2);
                end
            else
                GlobalFunc:create_screen_notic( LangGameString[2255] ); -- [2255]="比赛已经开始，不能下注"
            end 
        end
        return true
    end
    self.btn2 = MUtils:create_btn(self.view,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor,xiazhu_2_fun,373,66,-1,-1);
    self.btn2:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.btn4_dis);
    MUtils:create_zxfont(self.btn2,Lang.xiandaohui[51],121/2,20,2,16)  -- "#cffffff下注",

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 62, 535, 3, UILH_COMMON.split_line )
    self.view:addChild(line)

    -- 多少秒后离开
    self.lab_win_money = MUtils:create_zxfont(self.view,LangGameString[2256],16,38,1,16); -- [2256]="支持的玩家胜利可获得#cfff0003333万#cffffff仙币"
    self.lab_lt = MUtils:create_zxfont(self.view,"",16,15,1,16); -- [2257]="比赛将于20:50在第一擂台举行"

    -- 寻路
    local function xl_fun( eventType,msg_id,arg )
        if ( eventType == TOUCH_CLICK ) then
            XDHModel:move_to_letai( self.lei_tai )
        end
        return true
    end
    local btn_xl = MUtils:create_btn(self.view,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,xl_fun,422,6,-1,-1);
    MUtils:create_zxfont(btn_xl,Lang.xiandaohui.xiazhu[4],121/2,20,2,16)  -- [2258]="#c35c3f7寻路"

    -- MUtils:create_text_btn(self.view,Lang.xiandaohui.xiazhu[4],380,25,100,30,xl_fun,16); -- [2258]="#c35c3f7寻路"

end

function XiaZhuDialog:init_with_arg( lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2 ,player_index1,player_index2,xiazhu_index,pk_state_index)
    self.player_index1 = player_index1;
    self.player_index2 = player_index2;
    self.lei_tai = lei_tai;
    self.pk_state_index = pk_state_index;
    self:update_result( lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2 ,xiazhu_index)
end



function XiaZhuDialog:update_result( lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2 ,xiazhu_index)
    print("xiazhu_index",xiazhu_index);
    -- 更新头像和名字
    -- UIResourcePath.FileLocate.xiandaohui .."r_"..(xdh_zbs_user_struct1.head+1)..xdh_zbs_user_struct1.sex..".png" 
    self.p1_view_table[1]:setTexture( string.format("scene/npc_half/2/%05d.png",(xdh_zbs_user_struct1.head+1)) );
    -- UIResourcePath.FileLocate.xiandaohui .."r_"..(xdh_zbs_user_struct2.head+1)..xdh_zbs_user_struct2.sex..".png"
    self.p2_view_table[1]:setTexture( string.format("scene/npc_half/2/%05d.png",(xdh_zbs_user_struct2.head+1)) )
    self.p1_view_table[2]:setText(xdh_zbs_user_struct1.name);
    self.p2_view_table[2]:setText(xdh_zbs_user_struct2.name);

    -- 更新主角和对手的信息
    self.p1_view_table[3]:setText(attr_table[1].."#cfff000"..xdh_zbs_user_struct1.fight_value)
    self.p2_view_table[3]:setText(attr_table[1].."#cfff000"..xdh_zbs_user_struct2.fight_value)
    
    self.p1_view_table[4]:setText(attr_table[2].."#c66ff66"..xdh_zbs_user_struct1.value)
    self.p2_view_table[4]:setText(attr_table[2].."#c66ff66"..xdh_zbs_user_struct2.value)

    local turn = XDHModel:get_zbs_info().turn;

    self.p1_view_table[5]:setText(attr_table[3].."#cfff000"..XZ_NEED_MONEY_TABLE[turn])
    self.p2_view_table[5]:setText(attr_table[3].."#cfff000"..XZ_NEED_MONEY_TABLE[turn])
    self.lab_win_money:setText(LangGameString[2259]..XZ_NEED_MONEY_TABLE[4+turn]..LangGameString[2260]); -- [2259]="支持的玩家胜利可获得#cfff000" -- [2260]="#cffffff仙币"

    if ( xiazhu_index ~= 0 ) then
        self.btn1:setCurState(CLICK_STATE_DISABLE)
        self.btn2:setCurState(CLICK_STATE_DISABLE)
    else
        self.btn1:setCurState(CLICK_STATE_UP)
        self.btn2:setCurState(CLICK_STATE_UP)    
    end
    -- 擂台举行
    local time_str = XiaZhuDialog:get_time_str_by_pk_state( self.pk_state_index )
    local leitai_str = nil;

    local zbs_info = XDHModel:get_zbs_info()
    local turn = zbs_info.turn;
    if turn == 4 then
        leitai_str = "一" 
    elseif lei_tai == 1 then
        leitai_str = "二"
    elseif lei_tai == 2 then
        leitai_str = "三"
    elseif lei_tai == 3 then
        leitai_str = "四"
    elseif lei_tai == 4 then
        leitai_str = "五"
    end 
    self.lab_lt:setText(string.format(Lang.xiandaohui.xiazhu[5],time_str,leitai_str))   -- [5] = "比赛将于%s在第%s擂台举行",
end

function XiaZhuDialog:update_money( index,money )
    if ( self.player_index1 == index ) then
        self.p1_view_table[4]:setText(attr_table[2].."#c66ff66"..money)
    elseif ( self.player_index2 == index ) then
        self.p2_view_table[4]:setText(attr_table[2].."#c66ff66"..money)
    end

end

function XiaZhuDialog:get_time_str_by_pk_state( pk_state_index )
    if pk_state_index < 5 then
        return "20:15";
    elseif pk_state_index < 9 then
        return "20:18"
    elseif pk_state_index < 13 then
        return "20:23"
    elseif pk_state_index < 15 then
        return "20:28"
    elseif pk_state_index < 16 then
        return "20:33"
    end
end