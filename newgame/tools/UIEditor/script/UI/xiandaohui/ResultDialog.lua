-- ResultDialog.lua
-- create by hcl on 2013-8-15
-- 比赛结果窗口

super_class.ResultDialog(Window)


local attr_table = {Lang.xiandaohui[30],LangGameString[2240],LangGameString[2241],LangGameString[2242],LangGameString[2243] }; -- [2239]="战      力:" -- [2240]="剩余血量:" -- [2241]="获得积分:" -- [2242]="总  积  分:" -- [2243]="获得荣誉:"

-- pk_type,result,my_info,other_player_info
function ResultDialog:show( args )
    local win = UIManager:show_window("result_dialog");
	if ( win ) then
		win:init_with_arg(  args )
	end
end

function ResultDialog:__init( window_name, texture_name, is_grid, width, height,title_text )
    --遮罩层阻挡一切点击事件
    self.lock_panel = CCArcRect:arcRectWithColor(0,0,width,height, 0x0000009c);
    local function panel_fun(eventType,arg,msgid,selfitem)
        return true;
    end
    self.lock_panel:registerScriptHandler(panel_fun);
    self.view:addChild(self.lock_panel,-1);

    -- 背景bg，是比赛结果窗口的真正背景
    local bg = CCBasePanel:panelWithFile(width/2-560/2,height/2-465/2,560,465 - 25,UILH_COMMON.dialog_bg,500,500)
    self.view_bg = bg
    self.view:addChild(bg)

    --标题背景
    local title_bg = ZImage:create( bg,UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( 560 - title_bg_size.width ) / 2, 465 - title_bg_size.height-10 )
    
    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    self.window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
    self.window_title.view:setAnchorPoint(0.5,0.5)

    -- 内部背景
    local spr_bg = CCZXImage:imageWithFile( 12, 65, 535, 325, UILH_COMMON.bottom_bg,  500,500);
    bg:addChild( spr_bg );

    -- 两个人物的背景
    -- local bg1 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "result_p_bg.png",109,220)
    -- local bg2 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "result_p_bg.png",338,220)

    -- vs
    MUtils:create_sprite(bg,UILH_XIANDAOHUI.vs,560/2,300)

    -- 离开战场按钮
    local function btn_fun( eventType,msg_id,args)
    	if ( eventType == TOUCH_CLICK ) then
            UIManager:hide_window("result_dialog");
    	end
    	return true;
    end
    local btn1 = MUtils:create_btn(bg,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_fun,212,10,-1,-1,1);
    MUtils:create_zxfont(btn1,Lang.xiandaohui[52],121/2,20,2,16)  -- "#cd0cda2离开战场",
    -- MUtils:create_sprite(btn1,UIResourcePath.FileLocate.xiandaohui .. "result_exit_zc.png",55 ,20.5 );

    self.win_spr = MUtils:create_sprite(bg,UILH_XIANDAOHUI.shengli,130,275,2)
    self.lost_spr = MUtils:create_sprite(bg,UILH_XIANDAOHUI.shibai,409,260,2)

    self.p1_view_table = {};
    self.p2_view_table = {};
    -- 头像
    self.p1_view_table[1] = MUtils:create_zximg(bg,"scene/npc_half/2/00001.png",22,225,-1,-1);    
    self.p1_view_table[1]:setScale(0.7)
   	self.p2_view_table[1] = MUtils:create_zximg(bg,"scene/npc_half/2/00002.png",335,225,-1,-1);
    self.p2_view_table[1]:setScale(0.7)
    self.p1_view_table[2] = MUtils:create_zxfont(bg,LangGameString[2244],122,205,2,16) -- [2244]="名字"
    self.p2_view_table[2] = MUtils:create_zxfont(bg,LangGameString[2244],435,205,2,16) -- [2244]="名字"
    -- MUtils:create_sprite( self.p1_view_table[2],UIResourcePath.FileLocate.xiandaohui .."result_name_bg.png",58,9,-1 )
    -- MUtils:create_sprite( self.p2_view_table[2],UIResourcePath.FileLocate.xiandaohui .."result_name_bg.png",58,9,-1 )
    
    for i=1,5 do
    	self.p1_view_table[i+2] = MUtils:create_zxfont(bg,attr_table[i],41,182-(i-1)*25,1,15)
    	self.p2_view_table[i+2] = MUtils:create_zxfont(bg,attr_table[i],350,182-(i-1)*25,1,15)
    end

    -- 多少秒后离开
    self.exit_lab = MUtils:create_zxfont(bg,Lang.xiandaohui[31],375,29); -- [2245]="#c35c3f7秒后离开"
end

function ResultDialog:init_with_arg(  args )
    self:update_result( args[1],args[2],args[3],args[4])
end

function ResultDialog:update_result( pk_type,result,my_info,other_player_info )
    self.pk_type = pk_type;
    if self.pk_type == 0 then
        local function end_call()
            if ( self.pk_type == 0 ) then
               OthersCC:req_exit_fuben();
            end
            self.timer_lab:destroy();
            self.timer_lab = nil;
            UIManager:hide_window("result_dialog");
        end
        self.timer_lab = TimerLabel:create_label(self.view_bg, 345, 29, 16, 9, "#cfff000",end_call );
        self.exit_lab:setIsVisible(true);
    else
        self.exit_lab:setIsVisible(false);
    end
    print("result = ",result);
	-- 胜负
	if ( result == 1 ) then
		self.win_spr:setPosition(130,275)
		self.lost_spr:setPosition(409,260)
	else
		self.win_spr:setPosition(444,275)
		self.lost_spr:setPosition(100,260)
	end
	-- 更新头像和名字
	local player = EntityManager:get_player_avatar();
    -- UIResourcePath.FileLocate.xiandaohui .."r_"..player.job..player.sex..".png"
	self.p1_view_table[1]:setTexture( string.format("scene/npc_half/2/%05d.png",player.job) )
    -- UIResourcePath.FileLocate.xiandaohui .."r_"..other_player_info.job..other_player_info.sex..".png"
	self.p2_view_table[1]:setTexture( string.format("scene/npc_half/2/%05d.png",other_player_info.job) )

	self.p1_view_table[2]:setText(Lang.camp_name_ex[player.camp]..player.name);
	self.p2_view_table[2]:setText(Lang.camp_name_ex[other_player_info.camp]..other_player_info.name);

	-- 更新主角和对手的信息
	self.p1_view_table[3]:setText(attr_table[1]..player.fightValue)
	self.p2_view_table[3]:setText(attr_table[1]..other_player_info.fight_value)
	
	self.p1_view_table[4]:setText(attr_table[2]..(my_info.left_hp/100).."%")
	self.p2_view_table[4]:setText(attr_table[2]..(other_player_info.left_hp/100).."%")
	if ( pk_type == 0 ) then
    	self.p1_view_table[5]:setText(attr_table[3]..my_info.score)
    	self.p2_view_table[5]:setText(attr_table[3]..other_player_info.score)
    	
    	self.p1_view_table[6]:setText(attr_table[4]..my_info.total_score)
    	self.p2_view_table[6]:setText(attr_table[4]..other_player_info.total_score)
    	
    	self.p1_view_table[7]:setText(attr_table[5]..my_info.ry)
    	self.p2_view_table[7]:setText(attr_table[5]..other_player_info.ry)
    elseif ( pk_type == 1 ) then
        self.p1_view_table[5]:setText("")
        self.p2_view_table[5]:setText("")
        
        self.p1_view_table[6]:setText("")
        self.p2_view_table[6]:setText("")
        
        self.p1_view_table[7]:setText("")
        self.p2_view_table[7]:setText("")
    end
end

function ResultDialog:active( show )
    if show == false then 
        print("离开战场按钮............")
        if ( self.timer_lab ) then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end
        if ( self.pk_type == 0 ) then
           OthersCC:req_exit_fuben();
        end
    end
end

function ResultDialog:destroy( )
    print("离开战场按钮............")
    if ( self.timer_lab ) then
        self.timer_lab:destroy();
        self.timer_lab = nil;
    end
    if ( self.pk_type == 0 ) then
       OthersCC:req_exit_fuben();
    end
    Window.destroy(self);
end