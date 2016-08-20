-- BJZYS.lua
-- create by hcl on 2013-8-9
-- 本届自由赛

super_class.BJZYS()

function BJZYS:__init()
	
	local panel = CCBasePanel:panelWithFile(12,12,724,340,nil,0,0);
	self.view = panel;
	local left_panel = MUtils:create_zximg(panel,UILH_COMMON.bottom_bg,8,10,330,492,500,500);
    local right_panel = MUtils:create_zximg(panel,UILH_COMMON.bottom_bg,338,10,515,492,500,500);

    -- 左标题
    local subtitle1 = CCBasePanel:panelWithFile( -5, 453, 356, 49, UILH_NORMAL.title_bg7 )
    self.view:addChild( subtitle1 )
    MUtils:create_zxfont(subtitle1,Lang.xiandaohui[18],356/2,18,2,16);  -- [18]="我的自由赛信息"

    -- 右标题
    local subtitle2 = CCBasePanel:panelWithFile( 80, 443, 356, 49, UILH_NORMAL.title_bg7 )
    right_panel:addChild( subtitle2 )
    MUtils:create_zxfont(subtitle2,Lang.xiandaohui[48],356/2,18,2,16);  -- [48]="自由竞技赛积分榜",

    self.top = MUtils:create_zxfont(panel,"",96,430,1,16); -- [2218]="名      次：1"
    self.score = MUtils:create_zxfont(panel,"",96,430-25,1,16); -- [2219]="积      分：9999"
    self.match_num = MUtils:create_zxfont(panel,"",96,430-25*2,1,16); -- [2220]="积累比赛：0次"
    self.victory_num = MUtils:create_zxfont(panel,"",96,430-25*3,1,16); -- [2221]="积累胜利：0次"
    self.rate =  MUtils:create_zxfont(panel,"",96,430-25*4,1,16); -- [2222]="胜      率：0%"
    local player = EntityManager:get_player_avatar();
    self.ry = MUtils:create_zxfont(panel,Lang.xiandaohui[19]..player.honor,96,430-25*5,1,16); -- [2223]="荣      誉："

    -- 兑换按钮
    local function btn_dh_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            local win = UIManager:show_window("exchange_win")
            if win then
                win:change_page( 3 )
            end
        end
        return true
    end
    -- MUtils:create_btn_and_lab(panel,UILH_NORMAL.special_btn,UILH_NORMAL.special_btn,btn_dh_fun,81,232,-1,-1,Lang.xiandaohui[20],16); -- [941]="兑换"
    local btn_duihuan = MUtils:create_btn(panel,UILH_NORMAL.special_btn,UILH_NORMAL.special_btn,btn_dh_fun,81,232,-1,-1)
    MUtils:create_zximg(btn_duihuan,UILH_XIANDAOHUI.rongyuduihuan,40,13,82,27)

    MUtils:create_zxfont(left_panel,Lang.xiandaohui[46],330/2,190,2,16); -- [46] = "每天前10场战斗可获得荣誉值",
    -- MUtils:create_zxfont(left_panel,Lang.xiandaohui[47],210/2,180,2,16); -- [47] = "可获得荣誉值",

    -- 分隔线
    --MUtils:create_zximg(panel,UIResourcePath.FileLocate.common .. "fenge_bg.png",2,141,206,1,500,500);
    -- local fenge = ZImage:create(panel, UILH_COMMON.split_line,14,173,318,3)    

    ZImage:create(panel, UILH_COMMON.bg_10,23,21,300,150,0,500,500)    

	MUtils:create_ccdialogEx( panel,Lang.xiandaohui.xdh_shuoming,33,33,280,130,15,16 );

	-- 滑动条
	self:create_scroll(  );

	return panel;
end

function BJZYS:create_scroll(  )

    -- 
    MUtils:create_zximg(self.view,UILH_NORMAL.title_bg5,345,417,501,36,500,500);

	-- scroll上面的标题
	MUtils:create_zxfont(self.view,Lang.xiandaohui[6],380,428,2,16); -- [864]="#cfff000排名"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[7],370+100,428,2,16); -- [1904]="#cfff000姓名"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[8],370+100*2,428,2,16); -- [867]="#cfff000阵营"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[9],630,428,2,16); -- [2224]="#cfff000积分"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[10],700,428,2,16); -- [2225]="#cfff000战力"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[11],805,428,2,16); -- [2226]="#cfff000胜率"

    local _scroll_info = { x = 345 , y = 45 , width = 505, height = 370, maxnum = 0, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, nil, _scroll_info.stype )
    self.view:addChild(self.scroll);

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local row = temparg[1] +1             -- 行

            local function panel_fun( eventType,args,msgid )
                if eventType == TOUCH_CLICK then
                    -- local info = self.top_info[row]
                    -- local param = {roleId = info.id,roleName = self.target_entity.name,level = self.target_entity.level,camp = self.target_entity.camp,
                    --     job = self.target_entity.job,sex = self.target_entity.sex,handle = self.target_entity.handle,qqvip = self.target_entity.QQVIP};
    
                    -- LeftClickMenuMgr:show_left_menu( "chat_other_list_menu",param );
                end
                return true;
            end
            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,285 - row * 40,502,40,nil,0,0);
            panel:registerScriptHandler(panel_fun)
            self.scroll:addItem(panel);
            self:create_scroll_item( panel ,row )
            self.scroll:refresh();
            return false 
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()

    MUtils:create_zxfont(self.view,Lang.xiandaohui[17],649,23,1,16); -- [2227]="#c35c3f7排行榜数据每分钟更新"
end

function BJZYS:create_scroll_item( parent ,index )
	MUtils:create_zxfont(parent,self.top_info[index].top,35,10,2,16);
    MUtils:create_zxfont(parent,self.top_info[index].name,125,10,2,16);
    local camp_info = Lang.camp_info_ex[self.top_info[index].camp];
    MUtils:create_zxfont(parent,camp_info.color..camp_info.name[2],225,10,2,16);
    MUtils:create_zxfont(parent,self.top_info[index].score,285,10,2,16);
    MUtils:create_zxfont(parent,self.top_info[index].fight_value,355,10,2,16);
    local rate = 0;
    if ( self.top_info[index].match_num~=0 ) then
        rate = math.floor(self.top_info[index].victory_num/self.top_info[index].match_num*10000)/100;
    end
    MUtils:create_zxfont(parent,"#cd58a08"..rate.."%",460,10,2,16);
    -- local line = MUtils:create_sprite(parent, UIResourcePath.FileLocate.common .. "line.png",235,0);
    -- line:setScaleX(1.8);
    ZImage:create(parent,UILH_COMMON.split_line,0,0,502,3)   
end

function BJZYS:update( _type )
    if ( _type == "bjzys_my_info" ) then
        self:update_my_info();
    elseif ( _type == "bjzys_top") then
        self:update_top_info();
    elseif ( _type == "sub_panel") then
        XianDaoHuiCC:req_match_info()
        self:req_rank_top_info_30()

        ---------测试代码begin-----------
        -- self:update_top_info()
        ---------测试代码end-----------
    end
end

function BJZYS:active(  )
    XianDaoHuiCC:req_match_info()
    self:req_rank_top_info_30()
end

function BJZYS:update_my_info()
    local my_info = XDHModel:get_my_xdh_info()
    self.top:setText(Lang.xiandaohui[21]..my_info.rank); -- [2228]="名      次：#cfff000"
    self.score:setText(Lang.xiandaohui[22]..my_info.score); -- [2229]="积      分：#cfff000"
    self.match_num:setText(Lang.xiandaohui[23]..my_info.match_num..Lang.xiandaohui[27]); -- [2230]="积累比赛：#cfff000" -- [618]="次"
    self.victory_num:setText(Lang.xiandaohui[24]..my_info.victory_num..Lang.xiandaohui[27]); -- [2231]="积累胜利：#cfff000" -- [618]="次"
    local rate = 0;
    if ( my_info.match_num~=0 ) then
        print("my_info.victory_num,my_info.match_num",my_info.victory_num,my_info.match_num)
        rate = math.floor(my_info.victory_num/my_info.match_num*10000)/100;
    end
    self.rate:setText(Lang.xiandaohui[25]..rate.."%"); -- [2232]="胜      率：#cfff000"
    local player = EntityManager:get_player_avatar();
    self.ry:setText(Lang.xiandaohui[26]..player.honor); -- [2233]="荣      誉：#cfff000"
end

function BJZYS:update_top_info()
    local zys_top_info = XDHModel:get_zys_top_info();
    self.top_info = zys_top_info;

    ---------测试代码begin-----------
    -- self.top_info = {}
    -- for i=1,30 do
    --     self.top_info[i] = {}
    --     self.top_info[i].top = i
    --     self.top_info[i].name = "无线无线无线"
    --     self.top_info[i].camp = 2
    --     self.top_info[i].score = i
    --     self.top_info[i].fight_value = i*100000
    --     self.top_info[i].match_num = i
    --     self.top_info[i].victory_num = i-1
    --     self.top_info[i].guild_name = "无"
    -- end
    ---------测试代码end-----------

    self.scroll:clear();
    self.scroll:setMaxNum(#self.top_info);
    self.scroll:refresh();
end

function BJZYS:req_rank_top_info_30()
    XianDaoHuiCC:req_rank_top_info( 1 )
    XianDaoHuiCC:req_rank_top_info( 2 )
    XianDaoHuiCC:req_rank_top_info( 3 )
end
