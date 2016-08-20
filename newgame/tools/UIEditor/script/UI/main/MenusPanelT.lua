-- MenusPanelT.lua
-- create by hcl on 2012-12-26
-- 功能菜单弹出来的窗口

-- require "UI/component/Window"
-- require "utils/MUtils"
super_class.MenusPanelT(NormalStyleWindow)

-- 功能按钮的数量
-- local _button_count = 18

-- 改为读取配置表显示按钮了，步骤如下
-- 1,在data目录下的menus_conf文件中添加 按钮名 到最后   例:添加一个新系统  mubiao 
-- 2,在resourceTree/ui/mainmenu/文件下面添加图标和文字,图标命名为第一步的按钮名,文字命名为按钮名+"_t"; 例:图标命名为mubiao,文字命名为mubiao_t
-- 3,在MenusPanelT:do_btn_function(menus_name)方法中添加对应的点击按钮的响应函数,注:menus_name为步骤一的按钮名; 例:

-- 部分坐标设置
local locked_img_x = -3
local locked_img_y = 53
local remain_times_bg_x = 57
local remain_times_bg_y = 56
local remain_times_txt_x = 69
local remain_times_txt_y = 60
local _is_insert = false
-- local _is_first_load_config =true



-- 处理陪标信息，把配表中已开放的项目信息提取出来
local  function get_curr_page_info( pram_t,pram_index)
   local t = {}
   for i=1,#pram_t do
       if pram_t[i].sysType == pram_index then 
            if pram_t[i].openType == 0 then 
                table.insert(t,pram_t[i])
            elseif pram_t[i].openType == 1 then 
                if GameSysModel:isSysEnabled( pram_t[i].value, false) then
                    table.insert(t,pram_t[i])
                end
            elseif pram_t[i].openType == 2 then 
                if EntityManager:get_player_avatar().level >= pram_t[i].value then 
                    table.insert(t,pram_t[i])
                end
            end
       end
   end
   return t
end
function MenusPanelT:__init( window_name, texture_name)
    self.radio_but_t = {}
    self.menus_config_info = {}
    -- 分页：1=系统，2=功能
    self.curr_page = 1

    require "../data/menus_conf"
    self.menus_conf = menus_config
    ------Ewan SDK, SDK中的SDK 2B 猿类为难猿类的行为
    if _is_insert == false then
        if Target_Platform == Platform_Type.Platform_ewan then
            local t_user_center = { name="usercenter",   index=19,  sysType=1,   openType=0,   value=0, }
            local t_switch_account = { name="switch_account",   index=30,  sysType=1,   openType=0,   value=0, }
            local t_user_info = { name="user_info",   index=31,  sysType=1,   openType=0,   value=0, }
            table.insert( self.menus_conf, t_user_center )
            if PlatformInterface.is_show_btn and PlatformInterface:is_show_btn() == 1 then
                table.insert( self.menus_conf, t_switch_account )
            end    
            -- table.insert( self.menus_conf, t_user_info )
            _is_insert = true
        elseif Target_Platform == Platform_Type.Platform_SD then
            local t_switch_account = { name="switch_account",   index=30,  sysType=1,   openType=0,   value=0, }
            table.insert( self.menus_conf, t_switch_account )
            _is_insert = true
        elseif Target_Platform == Platform_Type.Platform_SC then
            local t_switch_account = { name="switch_account",   index=30,  sysType=1,   openType=0,   value=0, }
            table.insert( self.menus_conf, t_switch_account )
            _is_insert = true
        elseif PlatformInterface.show_user_center ~= nil and PlatformInterface:show_user_center() == true and PlatformInterface.open_user_center ~= nil then
            local t_user_center = { name="usercenter",   index=19,  sysType=1,   openType=0,   value=0, }
            table.insert( self.menus_conf, t_user_center )
            _is_insert = true
        elseif Target_Platform == Platform_Type.Platform_Any then
            local t_user_center = { name="usercenter",   index=19,  sysType=1,   openType=0,   value=0, }
            local t_switch_account = { name="switch_account",   index=30,  sysType=1,   openType=0,   value=0, }
            table.insert( self.menus_conf, t_user_center )
            table.insert( self.menus_conf, t_switch_account )
            _is_insert = true
        elseif Target_Platform == Platform_Type.Platform_LJ then
            if PlatformInterface:get_show_center() == 1 then
                local t_user_center = { name="usercenter",   index=19,  sysType=1,   openType=0,   value=0, }
                table.insert( self.menus_conf, t_user_center )
            end
            local t_switch_account = { name="switch_account",   index=30,  sysType=1,   openType=0,   value=0, }
            table.insert( self.menus_conf, t_switch_account )
            _is_insert = true
        end
    end

    --正版和无平台版不需要显示用户中心，配置配置表的时候需要把平台按钮配置在最后一个索引
    -- if Target_Platform==Platform_Type.Platform_ap or Target_Platform==Platform_Type.NOPLATFORM and _is_first_load_config then
    --     _is_first_load_config=false
    --     self.menus_conf[#self.menus_conf]=nil
    -- end

    ZImage:create(self.view,UILH_COMMON.normal_bg_v2,10,10,882, 550,0,500,500);
    -- ZImage:create(self.view,UI_MenusPanelT_0004,41,31,835, 510+50,0,500,500);

    -- 创建滑动条
    self:create_scroll();

    -- 切换页面按钮

    -- local but_beg_x  = 20            -- 按钮起始x坐标
    -- local but_beg_y  = 300            -- 按钮起始y坐标
    -- local but_int_y  = 119           -- 按钮y坐标间隔
    -- local btn_with   = 57
    -- local btn_height = 118

    -- self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , 50, but_int_y * 2,nil)
    -- self.view:addChild(self.raido_btn_group)

    -- self:create_a_button(self.raido_btn_group, 8, 1 + but_int_y * (2 - 1), btn_with, btn_height, UI_MenusPanelT_0001,
    --     UI_MenusPanelT_0002, UIResourcePath.FileLocate.mainMenu .. "page_labe_xitong.png",-1, -1, 1,5,-2)

    -- self:create_a_button(self.raido_btn_group, 8, 1 + but_int_y * (1 - 1), btn_with, btn_height,UI_MenusPanelT_0001,
    --     UI_MenusPanelT_0002, UIResourcePath.FileLocate.mainMenu .. "page_labe_gongneng.png",-1, -1, 2,5,-2)

    -- --隐藏分页--
    -- self.raido_btn_group:setIsVisible(false)

end
-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function MenusPanelT:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            --根据序列号来调用方法
            -- self:change_page( but_index )
            return true
        elseif eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)
    --按钮显示的名称
    local name_image = CCZXImage:imageWithFile( 35/2, 83/2, but_name_siz_w, but_name_siz_h, but_name ); 
    name_image:setAnchorPoint(0.5,0.5)
    radio_button:addChild( name_image )
    self.radio_but_t[but_index] = radio_button
end
-- 切换当前页
function MenusPanelT:change_page( pram )
    self.curr_page = pram
    print("切换到第"..tostring(pram).."页")
    self.menus_config_info = get_curr_page_info(self.menus_conf,self.curr_page);
    self.scroll:clear()
    self.scroll:autoAdjustItemPos(true)
    self.scroll:setMaxNum(math.ceil(#self.menus_config_info/6))
    self.scroll:refresh()
end

function MenusPanelT:do_btn_function( menus_name )
	
    Instruction:handleUIComponentClick(menus_name)

	UIManager:hide_window("menus_panel_t");
	--  1兑换2灵根3翅膀4成就5任务6招财进宝7斗法台8榜单9设置
	if(menus_name == "duihuan") then
        UIManager:show_window("exchange_win");
	elseif(menus_name == "linggen") then 
        LingGen:show();        
	elseif(menus_name == "chibang") then 
    
        if WingModel:get_wing_item_data() then
            UIManager:show_window("wing_win");
            -- WingSysWin:show_other_wing(WingModel:get_wing_item_data());
        else 
            GlobalFunc:create_screen_notic( LangGameString[1450] ); -- [1450]="您现在还没有翅膀！"
        end
	elseif(menus_name == "chengjiu") then
        UIManager:show_window("achieve_win"); 
        
	elseif(menus_name == "renwu") then 
        UIManager:show_window("task_win");
        
	elseif(menus_name == "zhaocai") then     
        -- 招财进宝
       -- if (GameSysModel:isSysEnabled(GameSysModel.MONEY_TREE)) then
       -- if EntityManager:get_player_avatar().level >= 22 then
           UIManager:show_window("zhaocai_win")
       -- end
     --       UIManager:show_window("miyou_win")
      --[[
              local win = UIManager:find_window( "miyou_win" )  
        if win == nil then 
            local activity_win = UIManager:show_window("miyou_win")
            activity_win:change_page( 5 )
        end

      ]]

        
	elseif(menus_name == "dujie") then 
        --DouFaTaiWin:show();
        if ( GameSysModel:isSysEnabled(GameSysModel.DJ) ) then 
            UIManager:show_window("dujie_win");
        end
	elseif(menus_name == "bangdan") then
        --UIManager:show_window("plant_win")
        UIManager:show_window("top_list_win")
        --TopListModel:open_top_list()
       --UIManager:show_window("goal_win");
	elseif(menus_name == "shezhi") then 
        -- 设置
        UIManager:show_window("set_system_win");

	elseif(menus_name == "youjian") then 
        UIManager:show_window("mail_win");

    elseif menus_name == "fabao" then
       if (GameSysModel:isSysEnabled(GameSysModel.GEM)) then
           --UIManager:show_window("fabao_win");
           UIManager:show_window("lingqi_win");
       end
    elseif menus_name == "qiandao" then
        -- 签到
        -- QianDaoWin:show()
    elseif menus_name == "doufatai" then
        DouFaTaiWin:show();
    elseif menus_name == "jishou" then
        UIManager:show_window("ji_shou_win")
        --lushan删除修改密码
    elseif menus_name == "xianlv" then 
        if (GameSysModel:isSysEnabled(GameSysModel.MARRY)) then
            UIManager:show_window("marriage_win_new");
        end
    elseif menus_name == "xiandaohui" then
        XianDaoHuiWin:show()
    elseif menus_name == "dongfu" then
        PlantModel:show_plant_win()
    elseif menus_name == "zhanbu" then
        ZhanBuModel:open_zhan_bu_win()
    elseif menus_name == "huanledou" then
        if GameSysModel:isSysEnabled(GameSysModel.DDZ,true) then 
            UIManager:show_window("hld_main_win");
        end
    elseif menus_name == "kefu" then
        UIManager:show_window("kefu_win");
    elseif menus_name == "mubiao" then
        UIManager:show_window("goal_win")
    --xiehande 暂时屏蔽美女助手
    elseif menus_name == "meinvzhushou" then
        UIManager:show_window("secretary_Win")
    elseif menus_name == "usercenter" then 
        PlatformInterface:open_user_center()
    elseif menus_name == "lilian" then
        -- local  str = string.format("OnEnterFubenFunc,%d",4)
        GameLogicCC:req_talk_to_npc( 0, "OnEnterFubenFunc,12")
    elseif menus_name == "yijidangqian" then
        -- local  str = string.format("OnEnterFubenFunc,%d",4)
        GameLogicCC:req_talk_to_npc( 0, "OnEnterFubenFunc,11")
    elseif menus_name == "paohuan" then
        PaoHuanWin:show();
    elseif menus_name == "zudui" then
        TeamWin:show(1);
    elseif menus_name =="thehelper" then
        UIManager:show_window("theHelper_Win")
    elseif menus_name == "switch_account" then
        UIManager:hide_window("menus_panel_t")
        if PlatformInterface.switch_account then
            PlatformInterface:switch_account()
        end
    elseif menus_name == "user_info" then
        if PlatformInterface.is_enter_platform then
            PlatformInterface:is_enter_platform()
        end
    elseif menus_name == "marriage" then
        if (GameSysModel:isSysEnabled(GameSysModel.MARRY)) then
            UIManager:show_window("marriage_win_new");
        end
    end
    
end

function MenusPanelT:active( show ) 
    -- if ( show == false ) then
    --     if ( XSZYManager:get_state() == XSZYConfig.DUI_HUAN_ZY or XSZYManager:get_state() == XSZYConfig.LINGGEN_ZY) then
    --         XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
    --     end
    -- else
    --     if ( XSZYManager:get_state() == XSZYConfig.LINGGEN_ZY ) then
    --         XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
    --         -- 指向灵根按钮 49,289，100,98
    --         XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.LINGGEN_ZY,4, XSZYConfig.OTHER_SELECT_TAG );
    --     end
    --     -- self.raido_btn_group:selectItem(0)
    --     -- self:change_page(1)
    -- end
end

-- 创建滑动条
function MenusPanelT:create_scroll()
    self.menus_config_info = get_curr_page_info(self.menus_conf,self.curr_page);

    local maxnum = math.ceil((#self.menus_config_info+1)/5);

    -- maxnum 等于所有功能按钮再额外加一个退出按钮
    local _scroll_info = { x = 41, y = 31, width = 835, height = 510+35, maxnum = maxnum, stype = TYPE_HORIZONTAL }
    self.scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    self.view:addChild(self.scroll);

    -- self.scroll:setScrollLump( UI_MenusPanelT_0005, UI_MenusPanelT_0006, 4, 20, _scroll_info.height )

    -- self.scroll:setScrollLumpPos( _scroll_info.width - 10 )
  

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
            local sub_panel = CCBasePanel:panelWithFile(0,510 - (row-1)*121,835,130,nil,0,0);
            self.scroll:addItem(sub_panel);
            self:create_scroll_item(row,sub_panel);

            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
end
-- 更新个图标按钮的角标提示状态
local function update_icon(p_bt_t)
    local key = p_bt_t.index
    local value = p_bt_t
    local player_lv = EntityManager:get_player_avatar().level
    if key == 1 then -- 兑换
        -- pram = ExchangeModel:get_player_lilian()
        -- if pram >= 10000 then 
        --     value.remain_times_bg.view:setIsVisible(false)
        --     value.remain_times.view:setIsVisible(false)
        --     value.exc_mark.view:setIsVisible(true)
        -- else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        -- end
    elseif key == 2 then -- 灵根
        pram = LinggenModel:get_if_can_lv_up()
        if pram == true then 
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(true)
        elseif pram == false then 
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 3 then --翅膀
        if WingModel:get_wing_item_data() ~= nil then
            local if_show_wing_tip = false
            -- 1.判断背包是否有对应的羽晶石可以升级翅膀，且是否达到当前阶的限制等级
            if WingModel:if_wing_can_upgrade( ) ==true then 
                if_show_wing_tip = true
            end
            -- 2.判断是否可以进行技能提升
            if if_show_wing_tip == false then 
                if WingModel:if_wing_skill_can_upgrade()==true then
                    if_show_wing_tip = true
                end
            end
            -- 3.判断声望是否达到进阶要求
            if if_show_wing_tip == false then 
                if WingModel:if_wing_can_shengjie( ) == true then 
                    if_show_wing_tip = true
                end
            end
            -- 
            if if_show_wing_tip == true then 
                value.remain_times_bg.view:setIsVisible(false)
                value.remain_times.view:setIsVisible(false)
                value.exc_mark.view:setIsVisible(true)
            elseif if_show_wing_tip == false then 
                value.remain_times_bg.view:setIsVisible(false)
                value.remain_times.view:setIsVisible(false)
                value.exc_mark.view:setIsVisible(false)
            end
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 4 then --法宝
        -- print("打开功能，打印法宝等级.......................",FabaoModel:get_fabao_info().level)
        -- local temp_count = 0
        -- temp_count = ItemModel:get_item_count_by_id(18603)
        -- if temp_count <= 0 then
        --     temp_count = ItemModel:get_item_count_by_id(18604)
        -- end
        -- if temp_count <= 0 then
        --     temp_count = ItemModel:get_item_count_by_id(18605)
        -- end
        -- if temp_count > 0 and 1 then
        if FabaoModel:if_can_upgrade( ) then 
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(true)
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 13 then -- 榜单
        value.remain_times_bg.view:setIsVisible(false)
        value.remain_times.view:setIsVisible(false)
        value.exc_mark.view:setIsVisible(false)
    elseif key == 5 then -- 签到
        local if_show_sign_tip = false
        --今天是否签到
        if QianDaoModel:is_today_qd() == false then           
            if_show_sign_tip = true
        end
        --今天是否需要补签
        if if_show_sign_tip == false then
            local is_need_bq = QianDaoModel:get_is_need_bq2()                        --当月是否需要补签
            local if_replenish_qd_doday = QianDaoModel:get_if_replenish_qd_doday()  -- 今日是否已补签
            local today_point = ActivityModel:get_today_point()                       -- 活跃度是否>50
            if (is_need_bq ==true) and (if_replenish_qd_doday == false) and (today_point >=50) then 
                if_show_sign_tip = true
            end
        end
        --是否有签到奖励未领取
        if if_show_sign_tip == false then
            local qd_award_info = QianDaoModel:get_qd_award_info() --签到奖励领取状况
            local qd_days = QianDaoModel:get_qd_info().qd_days
            local qd_day_cfg  = QianDaoModel:get_qd_day_cfg()         --签到累计日期配置信息
            for key2,value2 in ipairs(qd_award_info) do
                if value2 == 0 then  --有未领取的奖励
                    if qd_days >= qd_day_cfg[key2] then
                        if_show_sign_tip = true
                        break
                    end
                end
            end
        end
        --
        if if_show_sign_tip == true then 
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(true)
        elseif if_show_sign_tip == false then 
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 6 then -- 渡劫 
        local curr_index = DujieModel:get_current_jingjie_index( )
        if player_lv >= 23 and curr_index > 0 and curr_index <= DujieModel.get_floor_max() then 
            local fightValue = EntityManager:get_player_avatar().fightValue
            local need_power = DjConfig:get_dj_config_by_index(curr_index).attackPower
            local need_level = DjConfig:get_dj_config_by_index(curr_index).level
            if (fightValue >= need_power) and (player_lv >= need_level) then 
                value.remain_times_bg.view:setIsVisible(false)
                value.remain_times.view:setIsVisible(false)
                value.exc_mark.view:setIsVisible(true)
            else
                value.remain_times_bg.view:setIsVisible(false)
                value.remain_times.view:setIsVisible(false)
                value.exc_mark.view:setIsVisible(false)
            end
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 7 then -- 斗法台
        if player_lv >= 30 then 
            local tz_count = DFTModel:get_dft_tz_count()
            if tz_count > 0 then
                value.remain_times_bg.view:setIsVisible(true)
                value.remain_times.view:setIsVisible(true)
                value.remain_times:setText(tostring(tz_count))
                value.exc_mark.view:setIsVisible(false)
            else
                value.remain_times_bg.view:setIsVisible(false)
                value.remain_times.view:setIsVisible(false)
                value.exc_mark.view:setIsVisible(false)
            end
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 8 then --仙道会
        value.remain_times_bg.view:setIsVisible(false)
        value.remain_times.view:setIsVisible(false)
        value.exc_mark.view:setIsVisible(false)
    elseif key == 14 then --寄售
        -- print("寄售 信息..............................................",JiShouShangJiaModel:get__page_three_info_len())
        local temp_count = JiShouShangJiaModel:get__page_three_info_len()
        if temp_count > 0 then 
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(true)
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 9 then --仙侣情缘
        value.remain_times_bg.view:setIsVisible(false)
        value.remain_times.view:setIsVisible(false)
        value.exc_mark.view:setIsVisible(false)
    elseif key == 16 then --邮件
        local unread_count = MailModel:get_unread_mail_count()
        if unread_count > 0 then 
            value.remain_times_bg.view:setIsVisible(true)
            value.remain_times.view:setIsVisible(true)
            value.remain_times:setText(tostring(unread_count))
            value.exc_mark.view:setIsVisible(false)
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    -- elseif key == 10 then --招财
    --     if player_lv >= 22 then 
    --         local zc_remain_times = ZhaoCaiModel:get_can_zhaocai_count()
    --         if zc_remain_times > 0 then 
    --             value.remain_times_bg.view:setIsVisible(false)
    --             value.remain_times.view:setIsVisible(false)
    --             -- value.remain_times:setText(tostring(zc_remain_times))
    --             value.exc_mark.view:setIsVisible(false)
    --         else
    --             value.remain_times_bg.view:setIsVisible(false)
    --             value.remain_times.view:setIsVisible(false)
    --             value.exc_mark.view:setIsVisible(false)
    --         end
    --     else
    --         value.remain_times_bg.view:setIsVisible(false)
    --         value.remain_times.view:setIsVisible(false)
    --         value.exc_mark.view:setIsVisible(false)
    --     end
    elseif key == 11 then --成就
        if AchieveModel:isExistGetAward() == true then
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(true)
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
    elseif key == 15 then -- 任务
        local task_t,count = TaskModel:get_kejie_tasks_list()
        if count > 0 then
            value.remain_times_bg.view:setIsVisible(true)
            value.remain_times.view:setIsVisible(true)
            value.remain_times:setText(tostring(count))  
            value.exc_mark.view:setIsVisible(false)
        else
            value.remain_times_bg.view:setIsVisible(false)
            value.remain_times.view:setIsVisible(false)
            value.exc_mark.view:setIsVisible(false)
        end
      elseif key == 24 then -- 小助手
        local task_t,count = TaskModel:get_kejie_tasks_list()
        value.remain_times_bg.view:setIsVisible(false)
        value.remain_times.view:setIsVisible(false)
        value.exc_mark.view:setIsVisible(false)
    elseif key == 25 then    --客服
        value.remain_times_bg.view:setIsVisible(false)
        value.remain_times.view:setIsVisible(false)
        value.exc_mark.view:setIsVisible(false)
    -- elseif (key == 17) or (key == 12) or (key == 18) or (key == 19) then  -- 设置/助手/客服/欢乐斗
    else
        value.remain_times_bg.view:setIsVisible(false)
        value.remain_times.view:setIsVisible(false)
        value.exc_mark.view:setIsVisible(false)
    end
end
function MenusPanelT:create_scroll_item( row ,parent)

    for i=1,6 do
        local index = (row-1)*6 + i;
        local btn_t = {}

        --有些平台需要添加用户中心，加多一个按钮
        -- if Target_Platform==Platform_Type.NOPLATFORM and index == #self.menus_config_info +1 and self.curr_page==1 then
        --     local function exit( eventType,arg,msg_id)
        --         if eventType == TOUCH_CLICK then
        --             PlatformInterface:open_user_center()
        --         end
        --         return true
        --     end
        --     local btn = MUtils:create_btn(parent,UI_MenusPanelT_0007,UI_MenusPanelT_0007,exit,#self.menus_config_info % 6 * 133+30, ( 121 - 86 ) / 2 ,86,86);
        --     MUtils:create_sprite(btn,UI_MenusPanelT_0009,43,43);
        --     MUtils:create_sprite(btn,UI_MenusPanelT_0008,43,-4)
        --     MUtils:create_sprite(btn,UI_MenusPanelT_0010,43,-10);

        -- end

        -- 最后一个是退出按钮
        if index == #self.menus_config_info + 1 and self.curr_page==1 then
           
            local function exit( eventType,arg,msg_id)
                if eventType == TOUCH_CLICK then
                    if Target_Platform == Platform_Type.Platform_ewan then
                        UIManager:hide_window("menus_panel_t");
                    end
                    GameStateManager:back_to_login()
                end
                return true
            end
            local btn = MUtils:create_btn(parent,UILH_MAINMENU.bg,UILH_MAINMENU.bg,exit,#self.menus_config_info % 6 * 133+30, ( 121 - 86 ) / 2 ,70,70);
            MUtils:create_sprite(btn,UILH_MAINMENU.exit,35,35);
            -- MUtils:create_sprite(btn,UI_MenusPanelT_0008,43,-4)
            -- MUtils:create_sprite(btn,UI_MenusPanelT_0010,43,-10);
            
        elseif ( index <= #self.menus_config_info ) then
            local menus_name = self.menus_config_info[index].name;
            -- if menus_name ~="meinvzhushou" then
                
                local function btn_fun(eventType,x,y)
                    if eventType == TOUCH_CLICK then
                         self:do_btn_function( menus_name );
                    end
                    return true
                end
                local  pos_x = (i-1) * 133+30
                local  pos_y = ( 121 - 86 ) / 2

                local str = string.format(UIResourcePath.FileLocate.lh_mainmenu ..menus_name..".png",index);
                local btn = MUtils:create_btn(parent,UILH_MAINMENU.bg,UILH_MAINMENU.bg,btn_fun,pos_x, pos_y,70,70)
            
                MUtils:create_sprite(btn,str,35,35)

                -- str = string.format(UIResourcePath.FileLocate.lh_mainmenu ..menus_name.."_t.png",index);
                -- MUtils:create_sprite(btn,str,43,-10);

                btn_t.index           = self.menus_config_info[index].index
                btn_t.name            = menus_name
                btn_t.btn             = btn
                -- btn_t.locked_img      = ZImage:create(btn, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"locked.png"),locked_img_x, locked_img_y, 24, 25, 2)
                -- btn_t.remain_times_bg = ZImage:create(btn, string.format("%s%s",UIResourcePath.FileLocate.main,         "task_num_bg.png"),remain_times_bg_x,remain_times_bg_y,24,25,1)
                -- btn_t.remain_times    = ZLabel:create(btn, "", remain_times_txt_x-1, remain_times_txt_y+2, 14, ALIGN_CENTER, 1)
                -- btn_t.exc_mark        = ZImage:create(btn, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),remain_times_bg_x,remain_times_bg_y,24,25,2)
                -- btn_t.open_lv         = 0

                -- update_icon(btn_t)
            -- end
        end

    end
end
