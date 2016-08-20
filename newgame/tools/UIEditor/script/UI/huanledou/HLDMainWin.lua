-- HLDMainWin.lua
-- created by hcl 2013-9-16 
-- 欢乐斗主界面

super_class.HLDMainWin(Window);

function HLDMainWin:active( show ) 
    if ( show ) then
        HuanLeDouCC:req_hld_info();
        -- 每次打开主界面时同时打开互动记录
        UIManager:show_window("hld_hudongjilu");
        self.child_win = "hld_hudongjilu"
    else
        UIManager:hide_window(self.child_win);
    end
end

function HLDMainWin:__init( )
	
    -- 背景
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,248,368,145,500,500);
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,12,368,234,500,500);

    -- 说明
    self.sm = MUtils:create_ccdialogEx(self.view,LangGameString[1236],30,390,345,0,50,14); -- [1236]="仙主说明:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    self.sm:setAnchorPoint(0,1.0);
    -- 解救次数
    self.user_info_lab_table = {};
    self.user_info_lab_table[1] = MUtils:create_zxfont(self.view,LangGameString[1237],30,290+15) -- [1237]="解救次数:0  雇佣次数:0"
    self.user_info_lab_table[2] = MUtils:create_zxfont(self.view,LangGameString[1238],30,260+20) -- [1238]="互动次数:0"
    self.user_info_lab_table[3] = MUtils:create_zxfont(self.view,LangGameString[1239],30,230+25) -- [1239]="累计经验:10000000"

    -- 购买次数按钮
    local function btn_buy_function( event_type,args,msgid )
    	if event_type == TOUCH_CLICK then
            local function cb()
                HuanLeDouCC:req_add_catch_num()
            end
            local yuanbao = HuanLeDouModel:get_my_hld_info().next_catch_need_money;
            if ( yuanbao~= 0 )then
                NormalDialog:show(LangGameString[1240]..yuanbao..LangGameString[1241],cb); -- [1240]="是否确认花费#cfff000" -- [1241]="元宝#cffffff增加一次雇佣机会"
            else
                GlobalFunc:create_screen_notic( LangGameString[1242] ); -- [1242]="您今天不能再增加雇佣次数了"
            end
    	end
    	return true;
    end
    self.buy_count_btn = MUtils:create_common_btn( self.view,LangGameString[1243],btn_buy_function,270,298 ) -- [1243]="购买次数"

    self.btn_tab = {};
    -- 下面的7个按钮
    for i=1,7 do
    	local function btn_function( event_type,args,msgid )
	    	if event_type == TOUCH_CLICK then
	    		if ( i == 1 ) then
                    UIManager:show_window("hld_zhuabuxianpu");
                    self.child_win = "hld_zhuabuxianpu"
                elseif ( i == 2 ) then
                    UIManager:show_window("hld_jiejiu");
                    self.child_win = "hld_jiejiu"
                elseif ( i == 3 ) then
                    local my_info = HuanLeDouModel:get_my_hld_info();
                    if ( my_info.state == HuanLeDouModel.STATE_DIZHU ) then 
                        UIManager:show_window("hld_zhupuhudong")
                        self.child_win = "hld_zhupuhudong"
                    elseif ( my_info.state == HuanLeDouModel.STATE_KUGONG ) then
                        local master_info = my_info.master_info
                        HLDZhuPuHuDongAction:show( master_info );
                    end
                elseif ( i == 4 ) then
                    UIManager:show_window("hld_yazhaxianpu")
                    self.child_win = "hld_yazhaxianpu"
                elseif ( i == 5 ) then
                    -- 赎身
                    local function cb()
                        HuanLeDouCC:req_shushen()
                    end
                    NormalDialog:show(LangGameString[1244],cb); -- [1244]="是否确认花费#cfff00050元宝#cffffff为自己赎身，重返自由身；同时保护你今天之内不被任何人雇佣。"
                elseif ( i == 6 ) then
                    -- 求救
                    UIManager:show_window("hld_qiujiu");
                    self.child_win = "hld_qiujiu"
                elseif ( i == 7 ) then
                    UIManager:hide_window("hld_main_win")
                    -- 反抗
                    HuanLeDouCC:req_fankang()

                end
	    	end
	    	return true;
	    end
        local pos_x ,pos_y = nil,nil;
        if (i == 5) then
            pos_x = 50;
            pos_y = 130;
        elseif( i== 6) then
            pos_x = 240;
            pos_y = 130;
        elseif ( i== 7) then 
            pos_x = 240;
            pos_y = 20;
        else
            pos_x = 50 + (i-1)%2*190;
            pos_y = 130 - math.floor((i-1)%4/2)*110;
        end
	    self.btn_tab[i] = MUtils:create_btn(self.view,UIResourcePath.FileLocate.huanledou .. "hld_btn_"..i..".png",UIResourcePath.FileLocate.huanledou .. "hld_btn_"..i..".png",btn_function,pos_x,pos_y,-1,-1);
    end
end

function HLDMainWin:update_my_info( hld_info )

    local title_path = "";

    if ( hld_info.state == HuanLeDouModel.STATE_FREE ) then
        self.sm:setText(Lang.huanledou.zysm);
        title_path = UIResourcePath.FileLocate.huanledou.."hld_t_zys.png";
        self.user_info_lab_table[1]:setText(LangGameString[1245]..hld_info.catch_num); -- [1245]="#c66ff66雇佣次数:"
        self.user_info_lab_table[2]:setText(LangGameString[1246]..hld_info.free_num); -- [1246]="#c66ff66解救次数:"
        self.user_info_lab_table[3]:setText("");
        self.btn_tab[1]:setIsVisible(true);
        self.btn_tab[2]:setIsVisible(true);
        self.btn_tab[3]:setIsVisible(false);
        self.btn_tab[4]:setIsVisible(false);
        self.btn_tab[5]:setIsVisible(false);
        self.btn_tab[6]:setIsVisible(false);
        self.btn_tab[7]:setIsVisible(false);

    elseif ( hld_info.state == HuanLeDouModel.STATE_SHUSHEN_FREE ) then
        self.sm:setText(Lang.huanledou.zysm);
        title_path = UIResourcePath.FileLocate.huanledou.."hld_t_zys.png";
        self.user_info_lab_table[1]:setText(LangGameString[1245]..hld_info.catch_num); -- [1245]="#c66ff66雇佣次数:"
        self.user_info_lab_table[2]:setText(LangGameString[1246]..hld_info.free_num); -- [1246]="#c66ff66解救次数:"
        self.user_info_lab_table[3]:setText("");
        self.btn_tab[1]:setIsVisible(true);
        self.btn_tab[2]:setIsVisible(true);
        self.btn_tab[3]:setIsVisible(false);
        self.btn_tab[4]:setIsVisible(false);
        self.btn_tab[5]:setIsVisible(false);
        self.btn_tab[6]:setIsVisible(false);
        self.btn_tab[7]:setIsVisible(false);

    elseif ( hld_info.state == HuanLeDouModel.STATE_DIZHU ) then
        self.sm:setText(Lang.huanledou.xzsm);
        title_path = UIResourcePath.FileLocate.huanledou.."hld_t_xz.png";
        self.user_info_lab_table[1]:setText(LangGameString[1246]..hld_info.free_num..LangGameString[1247]..hld_info.catch_num); -- [1246]="#c66ff66解救次数:" -- [1247]="    雇佣次数:"
        self.user_info_lab_table[2]:setText(LangGameString[1248]..hld_info.hudong_num); -- [1248]="#c66ff66互动次数:"
        self.user_info_lab_table[3]:setText(LangGameString[1249]..hld_info.get_exp); -- [1249]="#c66ff66累计经验:"
        self.btn_tab[1]:setIsVisible(true);
        self.btn_tab[2]:setIsVisible(true);
        self.btn_tab[3]:setIsVisible(true);
        self.btn_tab[4]:setIsVisible(true);
        self.btn_tab[5]:setIsVisible(false);
        self.btn_tab[6]:setIsVisible(false);
        self.btn_tab[7]:setIsVisible(false);

    elseif ( hld_info.state == HuanLeDouModel.STATE_KUGONG ) then
        self.sm:setText(Lang.huanledou.xpsm);
        title_path = UIResourcePath.FileLocate.huanledou.."hld_t_xp.png";
        self.user_info_lab_table[1]:setText(LangGameString[1250]..hld_info.help_num); -- [1250]="#c66ff66剩余反抗/求救次数:"
        self.user_info_lab_table[2]:setText(LangGameString[1248]..hld_info.hudong_num); -- [1248]="#c66ff66互动次数:"
        self.user_info_lab_table[3]:setText("");
        self.btn_tab[1]:setIsVisible(false);
        self.btn_tab[2]:setIsVisible(false);
        self.btn_tab[3]:setIsVisible(true);
        self.btn_tab[4]:setIsVisible(false);
        self.btn_tab[5]:setIsVisible(true);
        self.btn_tab[6]:setIsVisible(true);
        self.btn_tab[7]:setIsVisible(true);
        self.buy_count_btn:setIsVisible(false);
    end
    -- 因为标题的宽高都不同，只好重新创建了
    if self.title then
        self.title.view:removeFromParentAndCleanup(true);
        self.title = nil;
    end
    self.title = ZCCSprite:create(self.view,title_path,389/2,435-20,999)
end

