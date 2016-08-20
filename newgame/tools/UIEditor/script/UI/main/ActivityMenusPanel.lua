-- ActivityMenusPanel.lua
-- create by hcl on 2013-5-30
-- 活动菜单弹出来的窗口

super_class.ActivityMenusPanel(NormalStyleWindow)
require "config/activity/SpecialActivityConfig"
require "UI/operateActivity/ServerActivityConfig"
require "config/activity/CommonActivityConfig"
local _curr_btn_num = 0;
local _btn_table = {};


-- 活动面板比较混乱，分为两类，第一类是自己控制显示隐藏，第二类是服务器控制显示隐藏
local server_btn_table = {};

local no_show_activity_id_table = { 24 };

-- 忍者基金活动是否还存在
ActivityMenusPanel.is_renzhejijin_exist = false
function ActivityMenusPanel.Get_RenZheJiJin_exist()
    return ActivityMenusPanel.is_renzhejijin_exist
end

function ActivityMenusPanel.Set_RenZheJiJin_exist(exist)
    ActivityMenusPanel.is_renzhejijin_exist = exist
end

function ActivityMenusPanel:init_with_params( params )

    -- 密友抽奖
    local activity_time = FriendsDrawModel:get_activity_time_remain()
    if activity_time > 0 then
        self:insert_btn(5,false);
    end
    for i=1,#params do
        print("ActivityMenusPanel:init_with_params params[i].id", params[i].id)
        -- 2是登陆送元宝活动，在领奖界面第3个分页（活动开启式显示）, 不在活动大厅显示
        if params[i].id ~= 2 then
            self:insert_btn( params[i].id ,true);
        end
        -- 忍者基金
        -- if params[i].id == 2 then
        --     RenZheJiJinModel:set_start_time( params[i].start_time );
        --     RenZheJiJinModel:set_end_time( params[i].end_time );
        -- end
    end
    
    local platform_test_version = nil
    local target_platform_test_version = ""
    if PlatformInterface.get_ios_version then
        platform_test_version = PlatformInterface:get_ios_version()
        target_platform_test_version = UpdateManager._ios_check_version
    end

    -- 激活礼包永远存在
    -- 投资返利已经不算活动 但是，需要从外部插入投资返利图标
    if TZFLModel:get_buy_icon_state() == 1 or TZFLModel:get_buy_icon_state() == 2  then
       if platform_test_version ~= target_platform_test_version then
            self:insert_btn(998,false);
        end
    end
    if not TZFLModel:get_is_show_tzfl_icon() then
       self:remove_btn(998);

    end
    if platform_test_version ~= target_platform_test_version then
        self:insert_btn(999,true);
    end
end

function ActivityMenusPanel:active( show )
    if show then
        for k,v in pairs(server_btn_table) do
            v:removeFromParentAndCleanup(true);
            v = nil
            _curr_btn_num = _curr_btn_num - 1;
        end
        -- print("_curr_btn_num",_curr_btn_num);
        server_btn_table = nil;
        server_btn_table = {};
        --每次打开活动面板时，先询问一下是否有开服活动
        OpenSerModel:check_op_server_active(  );
        --每次打开活动面板时，先询问一下是否有封测活动
        -- ClosedBateActivityModel:check_fc_activity(  )
        --每次打开活动面板时，先询问一下是否有消费礼包活动
        ActivityModel:check_if_show_spending_gift(  )
        --每次打开活动面板是，先询问活动列表
        OnlineAwardCC:req_get_activitys_list()

    else
        --[[if XSZYManager:get_state() == XSZYConfig.PAOHUAN_ZY then 
            XSZYManager:destroy_jt(XSZYConfig.OTHER_SELECT_TAG);
        end--]]
    end
end

function ActivityMenusPanel:__init( window_name, texture_name)
	local basePanel = self.view;
    ZImage:create(self.view,UILH_COMMON.normal_bg_v2 ,10 ,10,882,550,0,500,500);
    self._instruction_components = {}
end

function ActivityMenusPanel:do_btn_function(index)
	-- print("ActivityMenusPanel:do_btn_function(index)",index)
	UIManager:hide_window("activity_menus_panel");
    

    --报错，暂时注释
    Analyze:parse_click_acitvity_panel_info(index)
	
     if (index == 1) then 
        TZFLModel:open_win()
    elseif(index == 2) then 
        SCLBModel:open_sclb_win()   
    elseif(index == 3) then
        -- 开服活动
        -- OpenSerModel:set_activity_type( OpenSerModel.ACTIVITY_TYPE_OPEN );
        -- UIManager:show_window("open_ser_win");

        --晶矿
        UIManager:show_window("jing_kuang_win");

    elseif(index == 4) then 
        --黄金罗盘（幸运转盘）
        UIManager:show_window("luopan_win")
    elseif(index == 5) then 
        --消费礼包
        -- ActivityWin:win_change_page( 8 );
        -- 密友抽奖活动
        Instruction:handleUIComponentClick(instruct_comps.FRIENDS_MIYOU_AWARD1)
        UIManager:show_window("friends_draw_win")
    elseif(index == 6) then 
        --破冰活动
        require "config/activity/CommonActivityConfig"
        CommonActivityConfig.PoBing = index
        UIManager:show_window("po_bing_win")
        
    elseif(index == 7) then

    elseif(index == 8) then 
        --情人节活动
        require "config/activity/CommonActivityConfig"  
        ValentineDayModel:refreshActivityId(CommonActivityConfig.ValentineDay)
        UIManager:show_window("valentineDayWin")  
    elseif(index == 9) then 
        --春节活动
        require "config/activity/CommonActivityConfig"     
        LonelyDayModel:refreshActivityId(CommonActivityConfig.NewLonelyDay)
        UIManager:show_window("lonelyDayWin")  

    elseif index == 10 then
        -- 跑环
        -- PaoHuanWin:show( );

        --元宵活动
        require "config/activity/CommonActivityConfig"     
        LanternDayModel:refreshActivityId(CommonActivityConfig.LanternDay)
        UIManager:show_window("lanternDayWin")  

    elseif index == 11 then
        --妇女节活动
        require "config/activity/CommonActivityConfig"  
        WomensDayModel:refreshActivityId(CommonActivityConfig.WomensDay)
        UIManager:show_window("womens_day_win")
    elseif index == 12 then
        -- SmallOperationModel:set_operation_act_type( ServerActivityConfig.ACT_TYPE_POWER_PET ,SmallOperationModel.SUB_ACTIVITY_2);
        -- UIManager:show_window("small_operation_act_win")
        -- 白色情人节活动
        require "config/activity/CommonActivityConfig"  
        ValentineWhiteDayModel:refreshActivityId(CommonActivityConfig.ValentineWhiteDay)
        UIManager:show_window("valentineWhiteDayWin")  
    elseif index == 13 then
        -- SmallOperationModel:set_operation_act_type( ServerActivityConfig.ACT_TYPE_POWER_FABAO ,SmallOperationModel.SUB_ACTIVITY_2);
        -- UIManager:show_window("small_operation_act_win")
        UIManager:show_window("day_chongzhi")
    elseif index == 14 then 
        UIManager:show_window("series_chongzhi")
    elseif index == 15 then 
        UIManager:show_window("dragon_tower")
    elseif index == 16 then
        UIManager:show_window("magictree_win")
    elseif index == 17 then
        -- 清明节活动
        require "config/activity/CommonActivityConfig"  
        QingmingDayModel:refreshActivityId(CommonActivityConfig.QingmingDay)
        UIManager:show_window("QingmingDay_win");
    elseif index == 18 then
        -- 国庆活动
        UIManager:show_window("beauty_card_win");
    elseif index == 19 then
        -- 清凉一夏活动
        require "config/activity/CommonActivityConfig"  
        SummerDayModel:refreshActivityId(CommonActivityConfig.SummerDay)
        UIManager:show_window("summerDayWin")  
    elseif index == 20 then     --劳动节活动
        require "config/activity/CommonActivityConfig"  
        WorkDayModel:refreshActivityId(CommonActivityConfig.WorkDay)
        UIManager:show_window("workDayWin")  
    elseif index == 21 then     --开服活动
        -- 2015.4.22版本庆典活动
        require "config/activity/CommonActivityConfig"  
        VersionCelebrationModel:refreshActivityId(CommonActivityConfig.VersionCelebration)
        UIManager:show_window("VersionCelebration_win");
    elseif index == 22 then
        -- 乾坤兑换活动
        UIManager:show_window("qian_kun_win");
    -- elseif index == 28 then     --合服狂欢活动
    --     -- require "config/activity/CommonActivityConfig"  
    --     -- heFuKHModel:refreshActivityId(CommonActivityConfig.heFuKH)
    --     -- UIManager:show_window("heFuKHWin");
    --       -- BigActivityWin:show( index );  
    elseif index == 23 then
        UIManager:show_window("taobao_win")
    elseif index == 25 then
        UIManager:show_window("day_cz_multi_win")
    elseif index == 29 then
        --神秘宝箱
        UIManager:show_window("shenmi_shop_win");
    -- 强礼来袭,每日消费
    elseif index == 31 then --QQ浏览器安装
        UIManager:show_window("qq_browser_dialog");
    elseif index == 32 then --微信安装
        UIManager:show_window("qq_weixin_dialog");
    elseif index == 36 then --字字珠玑
        UIManager:show_window("zizizhuji_win");
    elseif index == 38 then --转盘
        UIManager:show_window("wuyi_zhuanpan_win");
    elseif index == 39 then --翻牌
        UIManager:show_window("open_card_win");
    elseif index == 43 then --消费返回
        local win = UIManager:show_window("xiaofei_return_win");
        win:setActivity_type(ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN)        
    elseif index == 44 then --神秘商店
        -- UIManager:show_window("shenmi_shop_win");
    elseif index == 46 then --聚宝袋
        DreamlandModel:set_dreamland_type( DreamlandModel.DREAMLAND_TYPE_JBD)
        UIManager:show_window("jubao_bag_left_win");
    elseif index == 47 then
        
    elseif index == 51 then --特惠狂欢
        UIManager:show_window("tehui_win")
    elseif index == 53 then
        local win = UIManager:show_window("xiaofei_return_win")
        win:setActivity_type(ServerActivityConfig.ACT_TYPE_YUANBAOFANLI)

    elseif index == 58 then --世界杯
        UIManager:show_window("world_cup_win");
    elseif index == 68 then --绚丽翅膀
        UIManager:show_window("get_wing_act_win");
    elseif index == 70 then --晶矿
        UIManager:show_window("jing_kuang_win");
    elseif index == 74 then --九宫神藏
        UIManager:show_window("jiu_gong_left_win");
        UIManager:show_window("jiu_gong_right_win");
    elseif index == 77 then --藏宝阁
        UIManager:show_window("cang_bao_left_win");
    elseif index == 60 then --珍宝轩
        DreamlandModel:set_dreamland_type( DreamlandModel.DREAMLAND_TYPE_ZBX )
        UIManager:show_window("jubao_bag_left_win");
    elseif index == 81 then --世界杯
        UIManager:show_window("super_tuangou_win")
    elseif index == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI or 
        index == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI2 or 
           index == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then 
        local sub_type = nil;
        if index == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
            sub_type = SmallOperationModel.SUB_ACTIVITY_2;
        elseif index == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI2 then
            sub_type = SmallOperationModel.SUB_ACTIVITY_2;
        elseif index == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
            sub_type = SmallOperationModel.SUB_ACTIVITY_10;
        end
        SmallOperationModel:set_operation_act_type( index,sub_type );
        UIManager:show_window("small_operation_act_win");
    elseif index == 99 then      --老服送花排行榜活动
        SendFlowerModel:refreshActivityId(99)
        UIManager:show_window("sendFlowerWin")
        --新服送花排行榜活动
        -- SendFlowerModel:refreshActivityId(SpecialActivityConfig.NewSendFlower)
        -- UIManager:show_window("sendFlowerWin")
    elseif index == 998 then
        TZFLModel:open_win()
    elseif index == 999 then
        -- 激活码活动
        UIManager:show_window("code_gift_win");
    elseif index == SpecialActivityConfig.OldSendFlower then      --老服送花排行榜活动
        SendFlowerModel:refreshActivityId(SpecialActivityConfig.OldSendFlower)
        UIManager:show_window("sendFlowerWin")
    elseif index == SpecialActivityConfig.NewSendFlower then      --新服送花排行榜活动
        SendFlowerModel:refreshActivityId(SpecialActivityConfig.NewSendFlower)
        UIManager:show_window("sendFlowerWin")
    elseif index == CommonActivityConfig.NewLonelyDay then --新服光棍节活动
        LonelyDayModel:refreshActivityId(CommonActivityConfig.NewLonelyDay)
        UIManager:show_window("lonelyDayWin")  

    else
        -- 大型运营活动
        if ServerActivityConfig.CURR_USE_ACTIVITY_IDS[index] then
            BigActivityWin:show( index );  
        end
    end

    -- 1: 开服活动 2: 火影基金 999：激活码活动
    -- if index == 1 then
    --     OpenSerModel:set_activity_type( OpenSerModel.ACTIVITY_TYPE_OPEN );
    --     UIManager:show_window( "open_ser_win" );
    -- elseif index == 2 then
    --     UIManager:show_window( "renzhe_jijin_win" );
    -- elseif index == 998 then
    --     UIManager:show_window( "wei_xin_win" );
    -- elseif index == 999 then
    --     UIManager:show_window( "code_gift_win" );
    -- end
end


-- btn_index 1,开服活动 2,火影基金
function ActivityMenusPanel:insert_btn( btn_index ,is_server )
    -- print("活动菜单添加按钮.........................",is_server)

    -- for i,v in ipairs(no_show_activity_id_table) do
    --     if v == btn_index  then
    --         return;
    --     end
    -- end
    
    if ( is_server ) then 
        if ( server_btn_table[ btn_index ] == nil ) then 
            _curr_btn_num = _curr_btn_num + 1;
            server_btn_table[ btn_index ] = self:create_a_btn( _curr_btn_num,btn_index )

            -- 清凉一夏，添加特效
            print("--------btn_index:", btn_index)
            if btn_index == 19 then
                print("-------------")
                LuaEffectManager:play_view_effect( 11041, 45, 43, server_btn_table[btn_index], true)
            end
        end
    else
        if ( _btn_table[ btn_index ] == nil ) then 
            print("btn_index:", btn_index)
            _curr_btn_num = _curr_btn_num + 1;
            _btn_table[ btn_index ] = self:create_a_btn( _curr_btn_num,btn_index )
        end
    end

end

-- 删除按钮
function ActivityMenusPanel:remove_btn( btn_index ) 
    if ( _btn_table[btn_index] ) then
        local curr_x = _btn_table[btn_index]:getPosition();
 --       print("curr_x = ",curr_x);
        for k,v in pairs(_btn_table) do
            local pos_x,pos_y = _btn_table[k]:getPosition();
    --        print("pos_x = ",pos_x);
            if ( pos_x > curr_x ) then
                _btn_table[k]:setPosition( pos_x - 138,pos_y );
     --           print("设置坐标......",pos_x-138,pos_y)
            end
        end
        _btn_table[btn_index]:removeFromParentAndCleanup(true);
        _btn_table[btn_index] = nil;
        _curr_btn_num = _curr_btn_num - 1;
        
        -- if ( _curr_btn_num == 0 ) then
        --     local win = UIManager:find_visible_window("right_top_panel");
        --     if ( win ) then
        --         win:hide_activity_menus_btn()
        --     end
        -- end
    end

end

function ActivityMenusPanel:create_a_btn( i,btn_index )
    local y = 450 - math.floor((i-1)/6)*121
    local function btn_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
             self:do_btn_function(btn_index);
        end
        return true
    end
    
    local btn = MUtils:create_btn( self.view, UILH_MAINMENU.bg, UILH_MAINMENU.bg, btn_fun,60 + (i-1) % 6 * 138,y,86,86);
    local str = string.format("ui/lh_mainActivity/%d.png", btn_index );
    MUtils:create_sprite(btn,str,43,43);

    -- MUtils:create_sprite( btn, UI_ActMenus_004, 43, -4 )

    -- str = string.format( "ui/lh_mainActivity/%d_t.png", btn_index );
    -- MUtils:create_sprite(btn,str,43,-10);
    return btn;
end

function ActivityMenusPanel:destroy()
    for k,v in pairs(server_btn_table) do
        v:removeFromParentAndCleanup(true);
        v = nil
        _curr_btn_num = _curr_btn_num - 1;
    end
    _curr_btn_num = 0;
    _btn_table = {};
    server_btn_table = {};
    self._instruction_components = {}
    Window.destroy(self)
end

