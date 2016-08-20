-- FightValueWin.lua
-- create by hcl on 2013-1-9
-- refactored by guozhinan on 2014-10-20
-- 战斗力界面

super_class.FightValueWin(NormalStyleWindow)

local panel = nil;
local title_num = 4

-- 处理配表信息，把配表中已开放的项目信息提取出来
local function get_curr_page_info( pram_t)
   local t = {}
   for i, tab in ipairs(pram_t) do
        local e_t = {}
        for _, item in ipairs(tab or {}) do
            if item.openType == 0 then 
                table.insert(e_t,item)
            elseif item.openType == 1 then 
                if GameSysModel:isSysEnabled( item.value, false) then
                    table.insert(e_t,item)
                end
            elseif item.openType == 2 then 
                if EntityManager:get_player_avatar().level >= item.value then 
                    table.insert(e_t,item)
                end
            end
        end
        table.insert(t, e_t)
   end
   return t
end

function FightValueWin:__init( window_name, texture_name )
	panel = self.view;

    -- 背景
    local bg = CCBasePanel:panelWithFile( 10, 10, 415, 562, UILH_COMMON.normal_bg_v2, 500, 500);
    panel:addChild(bg)

    -- -- 战斗力背景
    -- local fight_value_bg_l = ZImage:create( panel, UILH_ROLE.fight_win_bg, 18,470,202,84,0,0)
    -- local fight_value_bg_r = ZImage:create( panel, UILH_ROLE.fight_win_bg, 218,470,202,84,0,0)
    -- fight_value_bg_r.view:setFlipX(true)
    
    -- -- 战斗力图片和值
    -- local player = EntityManager:get_player_avatar();
    -- MUtils:create_zximg(panel,UILH_ROLE.text_zonghezhandouli,92,498,-1,-1);
    -- local function get_num_ima( one_num )
    --     return string.format("ui/lh_other/number2_%d.png",one_num);
    -- end
    -- self.sum_fight_value = ImageNumberEx:create( player.fightValue, get_num_ima, 16)
    -- self.sum_fight_value.view:setPosition( 240, 512 )
    -- panel:addChild(self.sum_fight_value.view)

    -- self:create_expandable_area()
    require "../data/menus_grow"
    self.grow_config = get_curr_page_info(grow_config)
    -- 战力提升（成长之路）页面所有按钮的表
    -- self.btns_config = {
    --     [1] = {[1] = UILH_MAINMENU.dujie, [2] = UILH_MAINMENU.doufatai, [3] = UILH_MAINMENU.paohuan,[4] = UILH_MAINMENU.zhenyaota},
    --     [2] = {[1] = UILH_MAINMENU.linggen, [2] = UILH_MAINMENU.duihuan, [3] = UILH_MAINMENU.zhaocai, [4] = UILH_MAINMENU.fabao, [5] = UILH_MAINMENU.marriage},
    --     [3] = {[1] = UILH_MAINMENU.bangdan, [2] = UILH_MAINMENU.chengjiu, [3] = UILH_MAINMENU.xiandaohui},
    -- }

     -- 创建滚动条
    local _scroll_info = { x = 18, y = 25, width = 400, height = 535, maxnum = 3, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    panel:addChild(self.scroll);

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

            self:create_scroll_item(row,self.scroll);

            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
end

-- 可怜我做的这段动画，最后居然重写方案
-- function FightValueWin:create_expandable_area()
--     local sub_title_x = 18
--     local label_x = 110
--     local top_y = 434
--     local bottom_y = 66

--     self.fight_value_label = {}
--     self.fight_title_bg = {}
--     self.fight_panel = {}
--     self.clip_panel = {}
--     local expandable_area_config = {
--         [1] = 3,
--         [2] = 2,
--         [3] = 3,
--         [4] = 2,
--     }
--     local btn_name_pic_path = 
--     {
--         [1] = {UILH_MAIN[4],UILH_NORMAL.skill_bg1,UILH_NORMAL.skill_bg1,},
--         [2] = {UILH_MAIN[2],UILH_MAIN[2],},
--         [3] = {UILH_MAIN[3],UILH_MAIN[3],UILH_MAIN[3],},
--         [4] = {UILH_NORMAL.skill_bg1,UILH_NORMAL.skill_bg1,},
--     }
--     for i=1,title_num do
--         local function change_panel_func(eventType,arg,msgid,selfitem)
--             if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
--                 return
--             end
--             if eventType == TOUCH_CLICK then
--                 if not self.is_palying_animation then
--                     -- 切换 
--                     self:change_expandable_area_state(i)
--                 end
--                 return true;
--             end
--             return true;
--         end
--         -- 标题区域
--         local tmp_y;
--         if i == 1 then
--             tmp_y = top_y-(i-1)*35
--         else
--             tmp_y = bottom_y+(title_num-i)*35
--         end
--         self.fight_title_bg[i] = CCBasePanel:panelWithFile( sub_title_x, tmp_y, 398, 35, UILH_COMMON.title_bg3, 0, 0);
--         self.fight_title_bg[i]:registerScriptHandler(change_panel_func);
--         self.view:addChild(self.fight_title_bg[i])
--         self.fight_value_label[i] = MUtils:create_zxfont(self.fight_title_bg[i],Lang.role_info.fight_value_win.title[i],label_x,10,ALIGN_LEFT,17);           
--         -- 内容区域
--         self.clip_panel[i] = CCTouchPanel:touchPanel(20, 0, 390, 260)
--         self.clip_panel[i]:setIsVisible(false)
--         self.view:addChild(self.clip_panel[i])
--         -- self.fight_panel[i] = CCBasePanel:panelWithFile( 20, 0, 390, 260, nil, 0, 0);
--         -- self.fight_panel[i]:setIsVisible(false)
--         -- self.view:addChild(self.fight_panel[i])

--         -- 创建滚动条
--         local length = math.ceil(expandable_area_config[i]/2);
--         local _scroll_info = { x = 0, y = 10, width = 390, height = 260, maxnum = length, stype = TYPE_HORIZONTAL }
--         local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
--         self.fight_panel[i] = scroll;   

--         self.clip_panel[i]:addChild(scroll);

--         local function scrollfun(eventType, args, msg_id)
--             if eventType == nil or args == nil or msg_id == nil then 
--                 return
--             end
--             if eventType == TOUCH_BEGAN then
--                 return true
--             elseif eventType == TOUCH_MOVED then
--                 return true
--             elseif eventType == TOUCH_ENDED then
--                 return true
--             elseif eventType == SCROLL_CREATE_ITEM then

--                 local temparg = Utils:Split(args,":")
--                 local row = temparg[1] +1             -- 行

--                 local item_panel = CCBasePanel:panelWithFile( 0, 0, 390, 130, "");               

--                 for t=1,2 do
--                     if (row-1)*2+t <= expandable_area_config[i] then
--                         local function btn_fun(eventType,args,msg_id)
--                             if eventType == TOUCH_CLICK then
--                                 self:do_btn_method2(i,(row-1)*2+t);
--                             end
--                             return true
--                         end           
--                         --  icon按钮和标题
--                         local tishen_btn = CCNGBtnMulTex:buttonWithFile(50+(t-1)*170,40,80,80,btn_name_pic_path[i][(row-1)*2+t]);
--                         tishen_btn:addTexWithFile(CLICK_STATE_DOWN,btn_name_pic_path[i][(row-1)*2+t]);
--                         tishen_btn:registerScriptHandler(btn_fun);
--                         item_panel:addChild(tishen_btn,100);
--                         MUtils:create_zxfont(tishen_btn,Lang.role_info.fight_value_win.sub_title[i][(row-1)*2+t],82/2,-25,ALIGN_CENTER,17);
--                     end
--                 end
                
--                 scroll:addItem( item_panel )
--                 scroll:refresh();
--                 return false
--             end
--         end
--         scroll:registerScriptHandler(scrollfun);
--         scroll:refresh()

--         -- for k=1,3 do
--         --      local function btn_fun(eventType,args,msg_id)
--         --         if eventType == TOUCH_CLICK then
--         --             self:do_btn_method((i-1)*3 + k);
--         --         end
--         --         return true
--         --     end

--         --     local row = math.ceil(k/2); -- 从1开始
--         --     local column = (k-1)%2;     -- 从0开始
--         --     local btn = MUtils:create_btn(self.fight_panel[i],UILH_NORMAL.skill_bg1,UILH_NORMAL.skill_bg1,btn_fun,70+column*170,135-(row-1)*110,-1,-1);
--         --     -- MUtils:create_zximg(btn,btn_name_pic_path[(i-1)*3+k],14,-15,-1,-1); 
--         -- end
--     end

--     self.is_palying_animation = false 
--     self.display_panel_index = -1
--     self.display_timer = timer()
--     self:change_expandable_area_state(1)
-- end

-- function FightValueWin:change_expandable_area_state(index)
--     if self.display_panel_index == index and self.is_palying_animation == false then
--         -- 重复点击不去管
--         return
--     end

--     local sub_title_x = 18
--     local top_y = 434
--     local bottom_y = 66
--     local old_index = self.display_panel_index
--     local animation_duration = 0.2

--     -- 隐藏原来的
--     if self.display_panel_index > 0 then
--         self.clip_panel[self.display_panel_index]:setIsVisible(false)
--     end
--     -- 显示当前的
--     self.display_panel_index = index;
--     self.clip_panel[self.display_panel_index]:setIsVisible(true)
--     -- 设置panel位置
--     self.clip_panel[self.display_panel_index]:setPosition(20,bottom_y+(title_num-index)*35)

--     -- 对于不是刚进入这个界面时候调用change_expandable_area_state的情况，做一下动画
--     if old_index ~= -1 then
--         if self.display_panel_index > old_index then
--             self.fight_panel[self.display_panel_index]:setPosition(0,-260)
--         else
--             self.fight_panel[self.display_panel_index]:setPosition(0,260)
--         end
--         local moveto = CCMoveTo:actionWithDuration(animation_duration,CCPoint(0,0));
--         self.fight_panel[self.display_panel_index]:runAction(moveto)

--         -- 重设标题栏位置
--         for i=1,title_num do
--             if i <= index then
--                 local moveto = CCMoveTo:actionWithDuration(animation_duration,CCPoint(sub_title_x,top_y-(i-1)*35));
--                 self.fight_title_bg[i]:runAction(moveto)
--             else
--                 local moveto = CCMoveTo:actionWithDuration(animation_duration,CCPoint(sub_title_x,bottom_y+(title_num-i)*35));
--                 self.fight_title_bg[i]:runAction(moveto)
--             end
--         end

--         -- 目前这动画仅是为了设置标志位，防止标题区域在动画期间被点击
--         self.is_palying_animation = true
--         local function display_timer_function()
--             self.is_palying_animation = false
--             self.display_timer:stop()
--         end
--         self.display_timer:start(animation_duration,display_timer_function)
--     else
--         self.fight_panel[self.display_panel_index]:setPosition(0,0)

--         -- 重设标题栏位置
--         for i=1,title_num do
--             if i <= index then
--                 self.fight_title_bg[i]:setPosition(sub_title_x, top_y-(i-1)*35)
--             else
--                 self.fight_title_bg[i]:setPosition(sub_title_x, bottom_y+(title_num-i)*35)
--             end
--         end
--     end
-- end

-- local title_tab = { Lang.fight_vale_info.role_fight_value, 
--                     Lang.fight_vale_info.equip_fight_value, 
--                     Lang.fight_vale_info.mount_fight_value };

function FightValueWin:create_scroll_item(index,scroll)
    local btns_table = self.grow_config[index]
    -- local img_path_table = self.btns_config[index];
    local btn_num = #btns_table
    local row = math.ceil(btn_num/4)
    -- 每行的背景panel
    local sub_panel = CCBasePanel:panelWithFile(0,0,400,55+90*row,nil,0,0);
    scroll:addItem(sub_panel);

    -- 底图
    local bottom_bg = CCZXImage:imageWithFile(8,20,382,18+90*row,UILH_COMMON.bottom_bg,500,500)
    sub_panel:addChild(bottom_bg)

    -- 标题栏
    local title_bg = CCZXImage:imageWithFile( 22, 9+90*row, 356, 49, UILH_NORMAL.title_bg3,0,0)
    sub_panel:addChild(title_bg)
    local title = CCZXImage:imageWithFile( 179, 24, -1, -1, UIResourcePath.FileLocate.lh_role.."subtitle"..index..".png")
    title:setAnchorPoint(0.5,0.5)
    title_bg:addChild(title)

    --战力标签
    for i=1,btn_num do
        local btn_info = btns_table[i]
        local function btn_fun(eventType,args,msg_id)
            if eventType == TOUCH_CLICK then
                -- self:do_btn_method((index-1)*3 + i);
                self:do_btn_method2(btn_info.name)
            end
            return true
        end
        print('index---------:', index, btn_info.idx)
        --战斗力的值
        --MUtils:create_lab_with_bg(sub_panel,title_tab[index] .. tab_fight_value[index],140,14,5,85);
        local x = 22+((i-1)%4)*95
        local y = 20+(row - math.ceil(i/4))*90 + 10
        local img_path = UIResourcePath.FileLocate.lh_mainmenu ..btn_info.name..".png";
        local btn = MUtils:create_btn(sub_panel,img_path,img_path,btn_fun,x,y,-1,-1);
    end
end


function FightValueWin:do_btn_method(index)
  --  print("do_btn_method")
    require "model/UserInfoModel"
    --判断
    local player = EntityManager:get_player_avatar()
    local user_lv = player.level;
    UIManager:hide_window("fight_value_win");
    -- print("do_btn_method1")
    if ( index == 1 ) then
        UIManager:show_window("user_skill_win");
    elseif ( index == 2) then
        if ( GameSysModel:isSysEnabled(GameSysModel.DJ) ) then
            UIManager:show_window("dujie_win");
        end
    elseif ( index == 3) then
         if ( GameSysModel:isSysEnabled(GameSysModel.ROOTS) ) then
            UIManager:show_window("linggen_win");
        end
    elseif ( index == 4) then
        if ( GameSysModel:isSysEnabled(GameSysModel.WING) ) then
            -- UIManager:show_window("wing_sys_win");
            WingModel:openWingWin(MINE_WING_INFO)
        end
    elseif ( index == 5) then       
        if ( GameSysModel:isSysEnabled(GameSysModel.ENHANCED) ) then
            require "UI/forge/ForgeWin"
            ForgeWin:goto_page( "strengthen" );
        end
    elseif ( index == 6) then
        if ( GameSysModel:isSysEnabled(GameSysModel.ENHANCED) ) then
            require "UI/forge/ForgeWin"
            ForgeWin:goto_page( "set" );
        end
    elseif ( index == 7) then
        if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT) ) then
            local win = UIManager:show_window("mounts_win_new")
            if win then
                win:change_page( 1 );
            end
        end
    elseif ( index == 8) then
        if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT) ) then
            local win = UIManager:show_window("mounts_win_new")
            if win then
                win:change_page( 1 );
            end
        end
    elseif ( index == 9) then
        if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT_REFRESH) ) then
            local win = UIManager:show_window("mounts_win_new")
            if win then
                win:change_page( 3 );
            end
        end
    end
        -- print("do_btn_method2")
end

function FightValueWin:do_btn_method2(menus_name)
    UIManager:hide_window("fight_value_win");

    if(menus_name == "duihuan") then
        UIManager:show_window("exchange_win");
    elseif(menus_name == "meirenchouka") then
        UIManager:show_window("beauty_card_win");
    elseif(menus_name == "linggen") then 
        LingGen:show();
    elseif(menus_name == "chengjiu") then
        UIManager:show_window("achieve_win"); 
    elseif(menus_name == "zhaocai") then   
        Analyze:parse_click_main_menu_info(260)  
        -- 招财进宝
        UIManager:show_window("zhaocai_win")
    elseif(menus_name == "dujie") then 
        --DouFaTaiWin:show();
        Analyze:parse_click_main_menu_info(254)
        if ( GameSysModel:isSysEnabled(GameSysModel.DJ) ) then 
            UIManager:show_window("dujie_win");
        end
    elseif(menus_name == "bangdan") then
        UIManager:show_window("top_list_win")
    elseif menus_name == "fabao" then
       if (GameSysModel:isSysEnabled(GameSysModel.GEM)) then
           UIManager:show_window("lingqi_win");
       end
    elseif menus_name == "doufatai" then
        Analyze:parse_click_main_menu_info(258)
        DouFaTaiWin:show();
    elseif menus_name == "paohuan" then
        PaoHuanWin:show();
    elseif menus_name == "marriage" then
        if (GameSysModel:isSysEnabled(GameSysModel.MARRY)) then
            UIManager:show_window("marriage_win_new");
        end
    elseif menus_name == "xiandaohui" then
        local player = EntityManager:get_player_avatar();
        if(player ~= nil and player.level ~= nil and player.level >= 40 ) then
            XianDaoHuiWin:show();
        else
            NormalDialog:show(Lang.xiandaohui[45]); -- [45] = "群雄争霸必须达到40级才可以参与！",
        end
    elseif menus_name == "zhenyaota" then
        --镇妖塔
        ZhenYaoTaModel:show_window(  )
    elseif menus_name == "juxianling" then
        UIManager:show_window("juxianling_win")
    end
    -- NormalDialog:show("结婚系统暂未开放",nil,2);    
end

function FightValueWin:active( show )
    if ( show ) then
        -- local fight_value = {}
        -- for i=1,title_num do
        --     fight_value[i] = 0
        -- end

        -- -- 5法宝
        -- local fabao_info = FabaoModel:get_fabao_info()
        -- if fabao_info and fabao_info.fight then
        --     fight_value[5] = fabao_info.fight;
        -- end
        -- self.fight_value_label[5]:setText(Lang.role_info.fight_value_win.title[5].." "..fight_value[5])

        -- -- 4坐骑
        -- if ( GameSysModel:isSysEnabled( 0 ,false) )  then
        --     -- 取得坐骑战斗力数据
        --     fight_value[4] = MountsModel:get_mounts_info().fight;
        -- end
        -- self.fight_value_label[4]:setText(Lang.role_info.fight_value_win.title[4].." "..fight_value[4])
        
        -- local player = EntityManager:get_player_avatar();
        -- self.sum_fight_value:set_number(player.fightValue)

        -- -- 3装备
        -- fight_value[3] = player.equipScore;
        -- self.fight_value_label[3]:setText(Lang.role_info.fight_value_win.title[3].." "..fight_value[3])

        -- -- 2翅膀
        -- if ( GameSysModel:isSysEnabled( 35 ,false) )  then
        --     -- 取得翅膀战斗力数据
        --     local data = WingModel:get_wing_item_data()
        --     if data and data.score then
        --         fight_value[2] = data.score;
        --     end
        -- end
        -- self.fight_value_label[2]:setText(Lang.role_info.fight_value_win.title[2].." "..fight_value[2])

        -- -- 1人物
        -- fight_value[1] =  player.fightValue - fight_value[5] - fight_value[4] - fight_value[3] - fight_value[2];
        -- self.fight_value_label[1]:setText(Lang.role_info.fight_value_win.title[1].." "..fight_value[1])

        -- 目前没有刷新数据的需求，所以屏蔽重刷
        -- self.scroll:clear();
        -- self.scroll:setMaxNum(3);
        -- self.scroll:refresh();   
    end
end

function FightValueWin:destroy()
    Window.destroy(self)
    -- self.display_timer:stop()
    -- self.display_timer = nil;
    -- self.is_palying_animation = false
end