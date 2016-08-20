-- RightTopPanel.lua
-- create by hcl on 2012-12-3
-- 主界面-右上角的按钮


super_class.RightTopPanel(Window)

-- 测试显示地图逻辑格子
local _show_tiles = false
local _dont_open = true
------------------所有按钮的相关坐标-------
local first_row_pos_y = 155;        --第一行的按钮的y坐标
local second_row_pos_y = 75;        --第二行的按钮的y坐标
local three_row_pos_y = 0;          --第三行的按钮的y坐标
local second_start_x = 370          --第二行最右边按钮的起始x坐标
local btn_width = 74;               --每个按钮的宽度
local btn_w, btn_h = 70, 70
local screen_width = 0
local screen_height = 0
------------------------------------------
-- 第一排的按钮 从右到左 1-6的开启等级
local first_row_open_lv = {1,1,1,1,1,1}
--需要结算的副本ID
local account_fuben_ids = {
-- 历练副本
-- 4,
-- 9, 
-- 一骑当千
-- 11,
--金窟宝穴
-- ,8
--马踏联营
-- 66,
--决战雁门关
-- 60,
--破狱之战
58,98,99,100,101,
--皇陵秘境
65,84,85,86,87,88,
--天魔塔
64,114,115,116,117,118
}
-- 第二排当前按钮的数量
-- local second_row_curr_btn_num = 0;
-- local second_row_btn_table = {};
-- 第三排临时活动
-- local _activity_btn_dict = {};
local _activity_icons = { "nopack/main/pantao_icon.png",
                          "nopack/main/xianling_icon.png",
                          "nopack/main/tianyuan_icon.png",
                          "nopack/main/camp_icon.png",
                          "nopack/main/husong_icon.png",
                          "",
                          "nopack/main/baguadigong_icon.png",
                          "nopack/main/question_icon.png",
                          "nopack/main/zys_icon.png",
                          "nopack/main/zbs_icon.png" };
 
 local _activity_bg_icons = { "nopack/main/pantao_icon_bg.png",
                          "nopack/main/xianling_icon_bg.png",
                          "nopack/main/tianyuan_icon_bg.png",
                          "nopack/main/camp_icon_bg.png",
                          "nopack/main/husong_icon_bg.png",
                          "",
                          "nopack/main/baguadigong_icon_bg.png",
                          "nopack/main/question_icon_bg.png",
                          "nopack/main/zys_icon_bg.png",
                          "nopack/main/zbs_icon_bg.png" };
local daily_activity_tip_t = {}

-- 运营活动按钮共有多少种形态！
local YUNYINHUODONG_BTN_MAX_STATE = 2;
-- 第一排的按钮数量
---------------------------
---HJH 2014-11-5 moidfy begin
--local _frist_row_btn_info = { 1, 2, 3, 4, 5, 6 }
---HJH 2014-11-5 modify end
---------------------------
local FIRST_ROW_BTN_NUM = 6
--设置按钮的位置，重新设置action
local function btnSetPosition(btn,x,y)
    btn._x = x
    btn._y = y
    if btn.showAction then
        --safe_release(btn.showAction)
        btn.showAction = nil
    end
    if btn.hideAction then
        --safe_release(btn.hideAction)
        btn.hideAction = nil
    end   
    btn.view:setPosition(x,y);
end

--删除btn，清除action,如果是countDownButton的话，调用destory
local function btnRelease(btn)
    if btn.showAction then
        --safe_release(btn.showAction)
        btn.showAction = nil
    end
    if btn.hideAction then
        --safe_release(btn.hideAction)
        btn.hideAction = nil
    end  
    if btn.destroy then
        btn:destroy()
    end
end

--销毁函数
function RightTopPanel:destroy(  )
    UIManager:removeMainUI(2)
    
    print('RightTopPanel:destroy')

    -- 停止变身倒计时按钮上面的特效
    if self.second_row_btn_table[12] then
        LuaEffectManager:stop_view_effect(26, self.second_row_btn_table[12].view)
    end

    -- 删除必杀技文字特效
    if self.bsj_text_img ~= nil then
        self.bsj_text_img:removeFromParentAndCleanup(true);
        self.bsj_text_img = nil
    end
    
    for i,v in ipairs(self.first_row_btns_table) do
        btnRelease(v)
    end

    for k,v in pairs(self.second_row_btn_table) do
        btnRelease(v)
    end

    for k,v in pairs(self._activity_btn_dict) do
        btnRelease(v)
    end
    
    -- btnRelease(self.sys_open_btn)
    Window.destroy(self);
end


-- 更新AOI内的entity
function RightTopPanel:update_AOI_entity( status, handler, entity )
    -- if self.map then
    --     self.map:update_AOI_entity( status, handler, entity );
    -- end
end

-- 更新小地图场景
function RightTopPanel:update_mini_map(  )
    
    -- if self.map then
    --     self.map:update_map();
    -- end
    if self.scene_name then

        local scene_name_str = SceneConfig:get_scene_name_by_id(SceneManager:get_cur_scene(), SceneManager:get_cur_fuben())
         -- print(" 更新小地图场景",scene_name_str,SceneManager:get_cur_scene(),SceneManager:get_cur_fuben());
        self.scene_name:setText( scene_name_str );
    end
    
end

-- 同步小地图坐标
function RightTopPanel:sync_avatar_point( w_pos_x, w_pos_y )

    -- if self.w_pos_x == w_pos_x and self.w_pos_y == w_pos_y then
    --     -- 如果坐标没有发生位移，则什么都不做
    -- else 
    --     -- if self.map then
    --     --     self.map:sync_avatar_point( w_pos_x, w_pos_y );
    --     -- end
    --     local tile_x,tile_y = SceneManager:pixels_to_tile( w_pos_x, w_pos_y );
    --     self.coordinate:setText(string.format("(%d,%d)",tile_x,tile_y));
    -- end
end

function RightTopPanel:__init( window_name, texture_name)
    -- 空面板
    local basePanel = self.view;
    basePanel:setDefaultMessageReturn(false)
    self.first_row_btns_table = {};--保存第一行所有图标按钮
    self.first_row_opened_btns_t = {} --引用第一行已开放的图标按钮
    self.second_row_btn_table = {};
    self.second_row_curr_btn_num = 0;
    self._activity_btn_dict = {};
    self.is_show = true;
    -- 记录当前仙道會的荣誉奖励按钮是否应该在斗法台奖励按钮消失后创建。true的时候说明仙道會奖励按钮等待创建。
    -- 由于第二行放不下太多按钮，所以斗法台奖励按钮优先出现，被点击消失后再出现仙道會奖励按钮。
    self.xdh_reward_btn_hiding = false; 
    -- 首冲礼包状态
    self.yunyinghuodong_btn_index = 1;

    self._instruction_components = {}


    -- add by chj @2015-4-1
    self.btns_tip_fst = {}
    self.btns_tip_scd = {}

    -- local function open_mini_map(eventType)
    --     Analyze:parse_click_main_menu_info(134)
    --     UIManager:show_window("mini_map_win");
    -- end

    -- local map_btn = ZButton:create(basePanel,{UIResourcePath.FileLocate.main .. "m_map_bg.png", UIResourcePath.FileLocate.main .. "m_map_bg.png"},open_mini_map,220+5,120+10,110,46);
    
    -- local scene_name_str = SceneConfig:get_scene_name_by_id( SceneManager:get_cur_scene(), SceneManager:get_cur_fuben())
    -- self.scene_name = ZLabel:create(map_btn.view,"",110/2,25,14,2);
    -- self.coordinate = ZLabel:create(map_btn.view,"",110/2,10,14,2);

    -- local base_path = UIResourcePath.FileLocate.main .. "right_top/m_top_menu_";
    -- for i=1,3 do
    --     local function btn_fun(eventType,arg,msgid)
    --         self:doMenuFunction(i);   
    --     end
    --     local btn = ZButton:create( basePanel, base_path .. i .. ".png",
    --                                         btn_fun, pos_tab[i*2+1], pos_tab[i*2+2], 70, 60);
    --     -- 活动按钮，随着活动时间的变化，会出现闪烁提示
    --     if (i == 3) then
    --         self.activity_btn = btn;
    --     end
    -- end

    local function exit_fuben_fun(eventType,args,msgid)
        -- print("SceneManager:get_cur_fuben():", SceneManager:get_cur_fuben())
        local curSceneId = SceneManager:get_cur_scene()
        Instruction:handleUIComponentClick(instruct_comps.TOP_RIGHT_BUTTON_FBEXIT)
        if curSceneId == 27 then
            return NewerCampCC:request_exit_newercamp()
        end
         
        --判断某个值是否存在表中
        function  in_array(value,list)

            if not list then
               return false   
            end 

            if list then
               for k, v in pairs(list) do
                   if v==value then
                      return true
                   end
               end
            end

        end 

        local function cb_fun()
            --如果是自由赛或争霸赛的话
            local curr_fuben_id = SceneManager:get_cur_fuben();
            if curr_fuben_id == 71 or curr_fuben_id == 72  then
                local win = UIManager:find_visible_window("result_dialog")
                if ( win ) then
                    UIManager:destroy_window("result_dialog");
                end
            end  

            if ( SceneManager:get_cur_scene() == 18 ) then 
                UIManager:hide_window("pipei_dialog");
                XianDaoHuiCC:req_exit_zys_scene( );
            elseif  in_array(SceneManager:get_cur_fuben(),account_fuben_ids) then
                print(SceneManager:get_cur_fuben())
                for i=1,#account_fuben_ids do
                   if account_fuben_ids[i] == SceneManager:get_cur_fuben() then
                    print("account_fuben_ids[i] ",account_fuben_ids[i] )
                     OthersCC:req_can_account_fuben_data();
                     break
                   end
                end

            else
                SceneManager:get_cur_fuben()
                OthersCC:req_exit_fuben();
                -- 如果斗法台倒计时还存在，就清除倒计时
                local win = UIManager:find_visible_window("count_down_view");
                if ( win ) then
                    UIManager:destroy_window("count_down_view");
                end
                --销毁婚宴嬉戏win
                MarriageModel:did_exit_hunyan( );
            end
        end
        if SceneManager:get_cur_fuben() == 119 then --镇妖塔副本 添加再来一次功能 add by tjh
            local function btn3_cb_func(  )
               ZhenYaoTaModel:req_again_challenge(  )
            end
            NormalDialog:show(Lang.activity.fuben[1],cb_fun,5,nil,false,nil,btn3_cb_func)-- [1001]="是否离开副本?"
        else
            NormalDialog:show(Lang.activity.fuben[1],cb_fun) -- [1001]="是否离开副本?"
        end
     end
     -- 退出副本按钮
    self.fuben_exit_btn = ZButton:create(basePanel, UILH_MAIN.fuben_exit,exit_fuben_fun,second_start_x,second_row_pos_y,-1,-1,1) 
    self.fuben_exit_btn.view:setIsVisible(false);

    self._instruction_components[instruct_comps.TOP_RIGHT_BUTTON_FBEXIT] = self.fuben_exit_btn

    --章节入口按钮
    local function chapter_click()
        UIManager:show_window("task_win")
    end
    local icon = "ui/lh_chapter/icon1.png"
    self.chapter_btn = ZButton:create(basePanel, icon, chapter_click, second_start_x, three_row_pos_y, 70, 70)
    btnSetPosition(self.chapter_btn, second_start_x, three_row_pos_y)
    local t_bg = ZImage:create(self.chapter_btn.view, UILH_NORMAL.level_bg, -5, -23, 80, 35)
    ZLabel:create(t_bg.view, Lang.task[54], 40, 12, 14, 2)
    self.chapter_btn.view:setIsVisible(false)
    self.is_chapter_show = false
    -- 创建第一排的按钮
    self:create_first_row_btns()
    --------HJH 2013-9-16
    --------QQVIP
    QQVipInterface:insert_qqvip_icon_fun(self)

    screen_width = GameScreenConfig.ui_screen_height
    screen_height = GameScreenConfig.ui_screen_height

    UIManager:setMainUI(2,self.view)
end

-- 创建第一排的图标 按钮从右往左创建分别是 1:功能菜单 2:活动 3:副本 4:奖励领取 5:每周跑环
function RightTopPanel:create_first_row_btns()
    local prefix = UIResourcePath.FileLocate.lh_righttop
    local lpath = "first_row_"
    local bpath = "bg_"
    for i=1,FIRST_ROW_BTN_NUM do
        local function first_row_btn_fun()
            self:do_first_row_btn_method(i);
        end
        local x = second_start_x-(i-1)*(btn_width)
        -- local btn = {}
        -- btn.view = CCBasePanel:panelWithFile(x-2,first_row_pos_y-7,75,75, "")
        -- self.view:addChild(btn.view)
        -- local bg = ZImage:create(btn.view, string.format("%s%s%d.png",prefix,bpath,i), 0, 0, 74, 74)
        -- local newBtn = ZButton:create( btn.view,
        --                                string.format("%s%s%d%s",prefix,lpath,i,".png"),
        --                                first_row_btn_fun,
        --                                2, 2,
        --                                btn_w, btn_h);
        local btn_bg = string.format("%s%s%d.png",prefix,bpath,i)
        local btn_img = string.format("%s%s%d%s",prefix,lpath,i,".png")
        local btn = CountDownButton(x, first_row_pos_y-2, 70, 70, btn_img, btn_bg, first_row_btn_fun, nil, nil, true)
        self.view:addChild(btn.view)
        btn._x = x
        btn.openLv = first_row_open_lv[i]
        btn._y = first_row_pos_y-7
        self.first_row_btns_table[i] = btn
    end
    --地图按钮
    -- local function map_btn_fun()
    --     UIManager:show_window("mini_map_win");
    -- end
    -- self.map_btn = ZButton:create(self.view, UILH_RIGHTTOP.first_row_map, map_btn_fun, 393, 143, -1, -1)

    -- local function first_recharge_btn_fun()
    --     if self.yunyinghuodong_btn_index == 1 then
    --         -- 首冲礼包
    --         Analyze:parse_click_main_menu_info(67)
    --         UIManager:show_window("sclb_win");
    --     -- 暂不开放，需要再开
    --     -- elseif self.yunyinghuodong_btn_index == 2 then
    --     --     -- 投资返利
    --     --     TZFLModel:open_win(  )            
    --     end
    -- end
    -- local btn_img = "ui/main/right_top/first_row_7.png"
    -- local btn_bg  = "ui/main/right_top/first_row_7_bg.png"
    -- self.yunyinhuodong_btn = CountDownButton(350-5*btn_w, first_row_pos_y-2, 65, 65, btn_img, btn_bg, first_recharge_btn_fun)
    -- self.view:addChild(self.yunyinhuodong_btn.view)
    -- self.yunyinhuodong_btn.view:setIsVisible(false);

    -- 按照策划要求,在首充完成后,首充按钮消失,如果此时基金活动还有效的话,在原首充的位置上,显示基金按钮
    -- local jijin_img = "ui/main/right_top/first_row_99.png"
    -- local jijin_bg  = "ui/main/right_top/first_row_99_bg.png"
    -- local function renzhejijin_btn_fun()
    --     UIManager:show_window("renzhe_jijin_win")
    -- end
    -- self.renzhejijin_btn = CountDownButton(350-5*btn_w, first_row_pos_y-2, 65, 65, jijin_img, jijin_bg, renzhejijin_btn_fun)
    -- self.view:addChild(self.renzhejijin_btn.view)
    -- self.renzhejijin_btn.view:setIsVisible(false)

    -- 创建活动按钮的提示标签容器
    -- daily_activity_tip_t.countainer = CCNode:node()
    -- daily_activity_tip_t.countainer.x = self.first_row_btns_table[4].view.x
    -- daily_activity_tip_t.countainer.y = self.first_row_btns_table[4].view.y    
    -- self.view:addChild(daily_activity_tip_t.countainer)
    -- daily_activity_tip_t.countainer.x = 0
    -- daily_activity_tip_t.countainer.y = 0
    -- self.first_row_btns_table[4].view:addChild(daily_activity_tip_t.countainer)
    -- daily_activity_tip_t.round_bg = ZImage:create(daily_activity_tip_t.countainer, string.format("%s%s",UIResourcePath.FileLocate.main,"task_num_bg.png"),45,45,22,22,1)
    -- daily_activity_tip_t.img_num = ZLabel:create(daily_activity_tip_t.round_bg, "", 10, 5, 12, ALIGN_CENTER,2)
    -- daily_activity_tip_t.round_bg.view:setIsVisible(false)
    -- daily_activity_tip_t.img_num.view:setIsVisible(false)
    -- 显示隐藏右上角的按钮
    local function hide_menus_fun(eventType,args,msgid)
        self:do_hide_menus_fun();
    end
    self.hide_btn = FlipButton(442,first_row_pos_y,38,70,UILH_MAIN.m_mini_task,hide_menus_fun)
    -- self.hide_btn:show_frame(1) 
    self.view:addChild(self.hide_btn.view)

end
-- 重排第一行按钮的位置，未到开放等级的隐藏掉
function RightTopPanel:reset_first_row_btns_pos( )
    --print("RightTopPanel:reset_first_row_btns_pos( )")
    local player_lv = EntityManager:get_player_avatar().level
    self.first_row_opened_btns_t = {}
    for i=1,#self.first_row_btns_table do
        --从右往左 1地图2功能3活动4日常5蓝钻|6福利7首充,不处理
        if player_lv >= self.first_row_btns_table[i].openLv then
            table.insert(self.first_row_opened_btns_t,self.first_row_btns_table[i])
            -- local len = #self.first_row_opened_btns_t
            -- self.first_row_btns_table[i]._x = 350-(len-1)*(btn_width-15)
            -- self.first_row_btns_table[i]:setPosition(350-(len-1)*(btn_width-15),first_row_pos_y)
            if self.is_show then
                self:menusShowActions(self.first_row_btns_table[i])
            else
                self:menusHideActions(self.first_row_btns_table[i])
            end
        else
            self:menusHideActions(self.first_row_btns_table[i])
        end
    end
end
-- 获取活动按钮
function RightTopPanel:get_activity_btn()
    return self.first_row_btns_table[4]
end

function RightTopPanel:do_hide_menus_fun( force_state )
    if force_state == nil then
        self.is_show = not self.is_show
    else
        self.is_show = force_state
    end
  
    if not self.is_show then
        for k,v in pairs(self.first_row_opened_btns_t) do
            --v.view:setIsVisible(self.is_show)
            -- 首冲礼包不隐藏
            if k ~= 7 then 
                self:menusHideActions(v)
            end
        end
        for k,v in pairs(self.second_row_btn_table) do
            -- print("第二排按钮隐藏")
            --v.view:setIsVisible(self.is_show)
            self:menusHideActions(v)
        end
        for k,v in pairs(self._activity_btn_dict) do
            --v.view:setIsVisible(self.is_show);
            self:menusHideActions(v)
        end
        -- 在副本中，系统开启按钮
        -- self:menusHideActions(self.sys_open_btn)
        -- 等级礼包隐藏
        XSZYManager:set_dqmb_visible( false )
        self.hide_btn:show_frame(1) 
        if self.is_chapter_show then
            self:menusHideActions(self.chapter_btn)
        end
    else
        for k,v in pairs(self.first_row_opened_btns_t) do
            --v.view:setIsVisible(self.is_show)
             -- 首冲礼包不隐藏
            if k~= 7 then
                self:menusShowActions(v)
            end
        end
        for k,v in pairs(self.second_row_btn_table) do
            -- print("第二排按钮隐藏")
            --v.view:setIsVisible(self.is_show)

            self:menusShowActions(v)
        end
        for k,v in pairs(self._activity_btn_dict) do
            --v.view:setIsVisible(self.is_show);
            self:menusShowActions(v)
         
        end
        -- self:menusShowActions(self.sys_open_btn)
        if self.fuben_exit_btn and self.fuben_exit_btn.view:getIsVisible() and self.sys_open_btn then
            self.sys_open_btn.view:setIsVisible(false);
        end

        if self.is_chapter_show then
            self:menusShowActions(self.chapter_btn)
        end
        -- 等级礼包显示
        XSZYManager:set_dqmb_visible( true )
        self.hide_btn:show_frame(2) 
    end
    -- self.sys_open_btn.view:setIsVisible(self.is_show);
end

-- 设置副本按钮显示隐藏
function RightTopPanel:set_fuben_exit_ben_visible( visible )
    self.fuben_exit_btn.view:setIsVisible(visible);
    if ( self.sys_open_btn ) then
        -- self.sys_open_btn.view:setIsVisible(not visible);
        self.sys_open_btn.view:setIsVisible(false)
    end
    if visible then
        self:do_hide_menus_fun(false);
        self.hide_btn:show_frame(1)
    else
        self:do_hide_menus_fun(true)
        self.hide_btn:show_frame(2)
    end
end

local MAX_SYS_LV = SysTipDialog:get_max_level()

-- 系统开启按钮
function RightTopPanel:create_sys_open_btn(  )
    self:check_sys_open_state( false );
    local icon_path = nil;
    local player_lv = EntityManager:get_player_avatar().level;
    if player_lv > MAX_SYS_LV then
        icon_path = SysTipDialog:get_default_icon_path();
    else
        icon_path = SysTipDialog:get_icon_path( self.curr_sys_index )
    end    
    
    local px = 388
    local py = second_row_pos_y

    if icon_path then
        if player_lv > MAX_SYS_LV then
            self.sys_open_btn = ZButton:create( self.view,icon_path ,nil, px,py , btn_w, btn_h);
            self.sys_open_btn.view:setIsVisible(false)
            local spr = ZCCSprite:create(self.sys_open_btn,UIPIC_RightTop_022,35,60);
        else
            local function btn_fun( eventType)
                SysTipDialog:show( self.curr_sys_index )
                -- Instruction:_fly_to_main_menus(GameSysModel.GENIUS)
                -- Instruction:play_new_jineng_effect( 1, 150, 20, nil)
            end
            self.sys_open_btn = ZButton:create( self.view,icon_path ,btn_fun, px,py , btn_w, btn_h);
            self.sys_open_btn.view:setIsVisible(false)
            self.image_num = ImageNumber:create( self.next_sys_lv )
            self.sys_open_btn.view:addChild(self.image_num.view,5);
            self.image_num.view:setPosition(CCPointMake(10,80));
            -- self.sys_open_title = ZCCSprite:create(self.sys_open_btn,UIPIC_RightTop_023,45,60);
        end

        btnSetPosition(self.sys_open_btn,px,py)
    end
    -- -- 如果退出副本存在的话就隐藏掉
    if self.fuben_exit_btn.view:getIsVisible() then 
        self.sys_open_btn.view:setIsVisible(false);
    end
end

function RightTopPanel:check_sys_open_state( is_need_ani )

    if ( self.curr_sys_index == nil ) then
        self.curr_sys_index = 0;
    end
    local old_sys_index = self.curr_sys_index;
    local player_lv = EntityManager:get_player_avatar().level;
    if player_lv > MAX_SYS_LV then
        if self.sys_open_btn then
            if self.image_num then
                self.sys_open_btn.view:removeChild(self.image_num.view,true)
            end
            if self.sys_open_btn and self.sys_open_title then
                self.sys_open_btn.view:removeChild(self.sys_open_title.view,true)
            end
            self.sys_open_btn:setImage(SysTipDialog:get_default_icon_path());
            self.sys_open_btn:setTouchClickFun(nil);
            ZCCSprite:create(self.sys_open_btn,UIPIC_RightTop_022,45,60);
        end
    else
        require "../data/client_global_config"
        local info = client_global_config.functionOpenLevel;
        self.curr_sys_index = 0;
        self.next_sys_lv = 0 
        for i,v in ipairs(info) do
            --print(v.level,player_lv);
            if ( v.level > player_lv ) then
                self.curr_sys_index = i;
                self.next_sys_lv = v.level;
                break;
            end
        end

        if ( self.curr_sys_index ~= old_sys_index and self.sys_open_btn ) then
            if ( self.curr_sys_index ~= 0 ) then
                local icon_path = SysTipDialog:get_icon_path( self.curr_sys_index );
                -- self.sys_open_btn:setTexture("");
                self.sys_open_btn:setImage(icon_path);
                if self.image_num then
                    self.image_num:set_number(self.next_sys_lv)
                end
            else
                self.sys_open_btn.view:removeFromParentAndCleanup(true);
                self.sys_open_btn = nil;
            end
        end
        -- if is_need_ani then 
        --     -- 如果玩家等级达到20级就飘签到按钮 22级招财 30级斗法台 43法宝
        --     if player_lv == 20 then
        --         XSZYManager:open_menus_panel_sys( GameSysModel.QianDao );
        --     elseif player_lv == 22 then
        --         XSZYManager:open_menus_panel_sys( GameSysModel.MONEY_TREE );
        --     elseif player_lv == 30 then
        --         XSZYManager:open_menus_panel_sys( GameSysModel.FIGHTSYS );
        --     elseif player_lv == 43 then
        --         XSZYManager:open_menus_panel_sys( GameSysModel.GEM )
        --     end
        -- end
    end
end
-- 按钮从右往左创建分别是1,地图2,功能菜单3, 成长之路4，活动5，奖励6，遗迹寻宝
function RightTopPanel:do_first_row_btn_method(index)
    Analyze:parse_click_main_menu_info(index + 60)
    --Analyze:parse_click_acitvity_panel_info(index)
    Instruction:handleUIComponentClick(instruct_comps.TOP_RIGHT_BUTTON_BASE_ROW_0 + index)
    if index == 1 then
        UIManager:show_window("mini_map_win")
    elseif (index == 2) then
        --功能菜单
        UIManager:show_window("menus_panel_t")
    elseif (index == 3) then
        UIManager:show_window("menus_grow")
    elseif (index == 4) then
        -- 活动
        UIManager:show_window("activity_Win")
        --副本大厅
        -- UIManager:show_window("activity_menus_panel");
    elseif (index == 5) then
        --奖励领取
        UIManager:show_window("benefit_win")
    elseif index == 6 then
        local player = EntityManager:get_player_avatar()
        if player.level < 26 then
            return GlobalFunc:create_screen_notic( Lang.dreamland.open_level_tips )
        end
        -- 遗迹寻宝
        DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_XY)
        local win = UIManager:show_window("new_dreamland_win");
        win:choose_xymj_tab()

    -- elseif index == 6 then
    --      -- 开服活动
    -- elseif index == 7 then
    end

end

-- 当有排行榜奖励时要显示按钮
function RightTopPanel:show_dft_award_btn()
--    print("排行奖励............................................................")
    self:insert_btn(6);
end
-- 显示vip体验按钮
function RightTopPanel:show_vip_expe_btn( vip_time )
    self:insert_btn( 4 ,vip_time)
end
-- 显示隐藏首冲礼包
function RightTopPanel:set_yunyinhuodong_btn_visible( is_visible )
    print('set_yunyinhuodong_btn_visible:',is_visible)
    if is_visible then
        self:insert_btn(1)
    else
        self:remove_btn(1)
    end
end

function RightTopPanel:set_renzhejijin_btn_visible( is_visible )
    -- self.renzhejijin_btn.view:setIsVisible( is_visible )
end

-- 显示首冲礼包按钮显示哪个按钮 btn_type 0 代表不显示按钮 1,首冲 2,投资返利
function RightTopPanel:set_operation_activity_btn( btn_type )
    -- xprint("RightTopPanel:set_operation_activity_btn( btn_type )",btn_type)
    -- if btn_type == self.yunyinghuodong_btn_index + 1 then 
    --     if btn_type == 2 then
    --         local sclb_state = SCLBModel:get_item_state();
    --         print("sclb_state",sclb_state)
    --         if sclb_state then
    --             local tzfl_state = TZFLModel:get_buy_icon_state();
    --             -- print("RightTopPanel:set_operation_activity_btn:tzfl_state",tzfl_state)
    --             if tzfl_state ~= 0 then
    --                 self.yunyinhuodong_btn:setImage("ui/main/right_top/tz.png")
    --                 self.yunyinghuodong_btn_index = btn_type;
    --                 self.yunyinhuodong_btn.view:setIsVisible(true);
    --                 return;
    --             else
    --                 self.yunyinhuodong_btn.view:setIsVisible(false); 
    --             end
    --         else 
    --             return;
    --         end
    --     end
    -- end
    
end

-- 自动排版活动按钮
function RightTopPanel:auto_layout_activity_btn(  )
    local i = 1;
    local begin_x = second_start_x
    if self.is_chapter_show then
        begin_x = begin_x - btn_width
    end
    for k,activity_btn in pairs(self._activity_btn_dict) do
        local x = begin_x-btn_width*(i-1)
        local y = three_row_pos_y
        btnSetPosition(activity_btn,x,y)
        i = i+1;
    end
end

-- 显示定时活动按钮 第三排
function RightTopPanel:show_activity_btn( activity )
    
    print(" -----------------显示定时活动按钮",activity.id);
    -- 温泉 争霸赛和自由赛暂时不显示
    if activity.id == 6 then
        return
    end
    -- local _INSERT_BTN = false
    -- if not _INSERT_BTN then return end
    local function open_activity_subview( eventType )
        if eventType == TOUCH_CLICK then
            local player = EntityManager:get_player_avatar();

            if activity.id == ActivityConfig.ACTIVITY_ZHENYINGZHAN then
                UIManager:show_window("camp_win");
            elseif activity.id == ActivityConfig.ACTIVITY_FREE_MATCH and player.level < 40 then
                GlobalFunc:create_screen_notic(string.format(Lang.screen_notic[9], 40)); -- [40000]="此活动需要%d级以上才可参加"
                return true;
            else 
                -- UIManager:show_window("activity_sub_win")
                local config = ActivityConfig:get_activity_info_by_id( activity.id );
                if activity.id == ActivityConfig.ACTIVITY_LINGQUANXIANYU then
                --灵泉仙浴
                    if SceneManager:get_cur_scene() ~= 1077 then
                        -- 场景id 1077为仙浴场景，在仙浴场景内不能立即参加入灵泉仙浴
                        local player = EntityManager:get_player_avatar();
                        -- 25级开放
                        if player.level >= ActivityConfig.LEVEL_WENQUAN then
                            XianYuModel:enter_xianyu_scene( );
                        else
                            GlobalFunc:create_screen_notic( LangGameString[551] ); -- [551]="人物等级需要达到25级"
                        end
                    end
                elseif activity.id == ActivityConfig.ACTIVITY_BAGUADIGONG then
                    -- 八卦地宫活动
                    local player = EntityManager:get_player_avatar();
                    -- 38级开放
                    if player.level >= ActivityConfig.LEVEL_BAGUADIGONG then


                    if ( SceneManager:get_cur_fuben() ~=0 ) then
                        print("副本中不能自动寻路");
                        ScreenNoticWin:create_notic("副本中不能参与活动") -- [2]="副本中不能自动寻路"
                        return;
                    end

                                
                        BaguadigongModel:enter_digong_fuben();
                    else
                        GlobalFunc:create_screen_notic( LangGameString[552] ); -- [552]="人物等级需要达到38级"
                    end
                elseif activity.id == ActivityConfig.ACTIVITY_QUESTION then
                    -- 答题活动
                    local player = EntityManager:get_player_avatar();
                    if player.level >= 30 then
                        local jion_times = QuestionActivityModel:get_jion_times( );
                        if jion_times < 1 then
                            GlobalFunc:create_screen_notic( LangGameString[553] ); -- [553]="此活动每日只能参加一次"
                        else

                                if ( SceneManager:get_cur_fuben() ~=0 ) then
                                    print("副本中不能自动寻路");
                                    ScreenNoticWin:create_notic("副本中不能参与活动") -- [2]="副本中不能自动寻路"
                                    return;
                                end

                            UIManager:show_window("question_win");
                        end
                    else
                        GlobalFunc:create_screen_notic( LangGameString[554] ); -- [554]="人物等级需要达到30级"
                    end
                elseif activity.id == ActivityConfig.ACTIVITY_FREE_MATCH then
                    -- 进入自由赛报名场景
                    -- XianDaoHuiCC:req_enter_zys_scene()
                    -- UIManager:hide_window("activity_sub_win")
                    local win = UIManager:show_window("activity_sub_win");
                    if win ~= nil then
                        win:update(activity.id);
                    end
                elseif activity.id == ActivityConfig.ACTIVITY_DOMINATION_MATCH then
                    -- 进入争霸赛副本
                    -- XianDaoHuiCC:req_enter_zbs_scene()
                    local win = UIManager:show_window("activity_sub_win");
                    if win ~= nil then
                        win:update(activity.id);
                    end
                elseif activity.id == ActivityConfig.ACTIVITY_HUANLEHUSONG and player.level < 26 then
                    GlobalFunc:create_screen_notic(LangGameString[1463])    --护送公主
                elseif activity.id == ActivityConfig.ACTIVITY_SHOULINGFENGYIN and player.level< 25 then 
                    GlobalFunc:create_screen_notic(LangGameString[1462])    --家族叛徒
                elseif activity.id == ActivityConfig.ACTIVITY_PANTAOSHENGYAN and player.level< 25 then 
                    GlobalFunc:create_screen_notic(LangGameString[1462])    --家族酒会
                else
                    --找NPC寻路时加上确认速传
      
                     if ( _dont_open ) then

                        local function confirm2_func()
                              ActivityModel:go_to_activity( config.location.sceneid, config.location.entityName, true );
                        end

                        local function swith_but_func ( flag )
                            _dont_open = not flag;
                        end
                         ConfirmWin2:show( 5, nil, Lang.common.confirm[18],  confirm2_func,swith_but_func)
                    else
                         ActivityModel:go_to_activity( config.location.sceneid, config.location.entityName, true );
                    end

                    --确定窗口的同时  人物也需要同时跑
                    ActivityModel:go_to_activity( config.location.sceneid, config.location.entityName, false );
                end
            end
        end
        return true;
    end

    if self._activity_btn_dict[activity.id] ~= nil then
        activity.status = 3;
        self:remove_activity_btn( activity )
    end
    
    -- print("_activity_icons[activity.id]",_activity_icons[activity.id])
    if _activity_icons[activity.id] then
        -- 活动图标
        local icon = _activity_icons[activity.id];
        local bg = _activity_bg_icons[activity.id];
        
        local activity_btn = CountDownButton( 0, 0, btn_w, btn_h, icon, bg, open_activity_subview, activity.time );            
        self.view:addChild(activity_btn.view);
        self._activity_btn_dict[activity.id] = activity_btn;
        
    end
    
    self:auto_layout_activity_btn();
    -- print("self.is_show,self._activity_btn_dict[activity.id])",self.is_show,self._activity_btn_dict[activity.id])
    if ( self.is_show == false and self._activity_btn_dict[activity.id]) then
        self._activity_btn_dict[activity.id].view:setIsVisible(false);
        self._activity_btn_dict[activity.id].view:setPosition(screen_width,self._activity_btn_dict[activity.id]._y)
    end
end

-- 移除活动按钮
function RightTopPanel:remove_activity_btn( activity )
    local actBtn = self._activity_btn_dict[activity.id]
    if activity.status == 3 and actBtn then
        self._activity_btn_dict[activity.id] = nil;
        btnRelease(actBtn)
    end
    self:auto_layout_activity_btn();
end

function  RightTopPanel:show_chapter_visible( flag )
    if flag == self.is_chapter_show then return end
    if self.chapter_btn then
        self.is_chapter_show = flag
        self.chapter_btn.view:setIsVisible(flag)
    end
    if flag then
        LuaEffectManager:play_view_effect( 11041, 38, 35, self.chapter_btn.view, true)
        self:auto_layout_activity_btn()
    else
        LuaEffectManager:stop_view_effect( 11041, self.chapter_btn.view )
    end
end

-- chj 更改后icon重叠，回滚版本，添加此方法
function RightTopPanel:show_chapter_effect(flag)
    if not self.chapter_btn then
        return
    end
    if flag then
        LuaEffectManager:stop_view_effect( 11041, self.chapter_btn.view )
        LuaEffectManager:play_view_effect( 11041, 38, 35, self.chapter_btn.view, true)
    else
        LuaEffectManager:stop_view_effect( 11041, self.chapter_btn.view )
    end
end

-- 改变章节按钮图标
function RightTopPanel:change_chapter_icon(cid)
    local icon = string.format("ui/lh_chapter/icon%d.png", cid)
    if icon then
        self.chapter_btn:setImage(icon)
    end
end
------------------第二排按钮-------------------------------
-- 插入一个按钮在第二排
-- btn_index : 1,斗法台排行奖励 2,仙尊三vip卡 3,遗迹寻宝 4,首冲礼包 5、seven day award 6 每日福利 7 幸运猜猜 8 自由赛奖励 9蓝钻贵族 10式神领取 11极品套装领取, 12变身倒计时按钮  13投资返利
-- 新inddex:  1,首冲礼包 2,开服活动 3,VIP3体验卡
function RightTopPanel:insert_btn( btn_index ,param)
    if ( self.second_row_btn_table[btn_index]== nil )  then 
        local btn_cloumn_index = #self.second_row_btn_table+1;
        local function btn_function( eventType,args,msgid)
            if eventType == TOUCH_CLICK then
                -- Instruction:handleUIComponentClick(instruct_comps.TOP_RIGHT_BUTTON_BASE_ROW_1 + btn_index)
                Analyze:parse_click_main_menu_info(btn_index + 80)
                self:do_btns_menthod(btn_index);
            end
            return true
        end
        if btn_index == 1 then
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local function first_recharge_btn_fun()
                -- 首冲礼包
                Analyze:parse_click_main_menu_info(67)
                UIManager:show_window("sclb_win");
            end
            local yunyinhuodong_btn = CountDownButton( px, py, btn_w, btn_h, 
                                             UILH_RIGHTTOP.second_row_1, 
                                             UILH_RIGHTTOP.second_row_1_bg,
                                             first_recharge_btn_fun, nil, nil);

            self.view:addChild(yunyinhuodong_btn.view);
            self.second_row_btn_table[ btn_index ] = yunyinhuodong_btn;
         
            btnSetPosition(yunyinhuodong_btn,px,py)
        elseif btn_index == 3 then
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local function open_ser_fun()
                -- 删除闪烁效果
                self:shanshuo_btn( 3, false )
                UIManager:show_window("open_ser_win");
            end
            local yunyinhuodong_btn = CountDownButton( px, py, btn_w, btn_h, 
                                             UILH_RIGHTTOP.second_row_2, 
                                             "",
                                             open_ser_fun, nil, nil);
            local player = EntityManager:get_player_avatar();
            if player ~= nil and player.level ~= nil and player.level >= 22 then 
                yunyinhuodong_btn:add_effect(38, 38);
            end

            self.view:addChild(yunyinhuodong_btn.view);
            self.second_row_btn_table[ btn_index ] = yunyinhuodong_btn;
         
            btnSetPosition(yunyinhuodong_btn,px,py)
        elseif btn_index == 4 then
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local function show_vip_expe( eventType )
                if eventType == TOUCH_CLICK then
                    UIManager:show_window("vip_card_win");
                end
                return true;
            end
            
            local function did_finish_expe_vip(  )
                VIPModel:did_finish_expe_vip(  );
                self:remove_btn( 4 ) 
            end
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local vip_btn = CountDownButton( px, py, btn_w, btn_h, 
                                             "nopack/main/vip_icon.png"
                                             ,nil,show_vip_expe, param, 
                                             did_finish_expe_vip);
            self.view:addChild(vip_btn.view);
            self.second_row_btn_table[ btn_index ] = vip_btn;
            ----------------------------
            btnSetPosition(vip_btn,px,py)

        --xiehande  添加七日狂欢
        elseif btn_index == 5 then
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local function temp_func()
                -- UIManager:show_window("seven_day_award")
                Instruction:handleUIComponentClick(instruct_comps.TOP_RIGHT_BUTTON_LINGJIANG)
                UIManager:show_window("award_win")
            end
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local award_btn = CountDownButton( px,py, btn_w, btn_h, 
                                             "nopack/main/sevenday_icon.png", 
                                             "",
                                             temp_func, nil, nil);
            local award_index, count_time, remain_num = OnlineAwardModel:get_data()
            if count_time == 0 and remain_num > 0 then
                award_btn:add_effect(35, 38)
            end
            self.view:addChild(award_btn.view);
            self.second_row_btn_table[ btn_index ] = award_btn;
            ----------------------------
            btnSetPosition(award_btn,px,py)
        elseif btn_index == 6 then
            -- 斗法台奖励按钮存在时，仙道會按钮先销毁，等待创建
            if self.second_row_btn_table[ 8 ] ~= nil then
                self:remove_btn( 8 );
                self.xdh_reward_btn_hiding = true
            end

            -- 点将台排名奖励按钮
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local function duofatai_btn_fun()
                -- 领取斗法台排行奖励 
                DouFaTaiCC:req_get_reward_info( );
                self:remove_btn( 6 );
                if self.xdh_reward_btn_hiding == true then
                    self.xdh_reward_btn_hiding = false;
                    self:insert_btn(8);
                end
            end
            local duofatai_btn = CountDownButton( px, py, btn_w, btn_h, 
                                             "nopack/main/dft_reward_icon.png", 
                                             "nopack/main/dft_reward_icon_bg.png",
                                             duofatai_btn_fun, nil, nil);

            self.view:addChild(duofatai_btn.view);
            self.second_row_btn_table[ btn_index ] = duofatai_btn;
         
            btnSetPosition(duofatai_btn,px,py)
        elseif btn_index == 8 then
            -- 斗法台奖励按钮存在时，仙道會按钮等待创建
            if self.second_row_btn_table[ 6 ] ~= nil then
                self.xdh_reward_btn_hiding = true
            else
                -- 仙道會自由赛排名的荣誉奖励按钮
                self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
                local px = second_start_x-self.second_row_curr_btn_num*btn_width
                local py = second_row_pos_y
                local function xiandaohui_btn_fun()
                    -- 领取仙道會自由赛排行奖励 
                    self.xdh_reward_btn_hiding = false; -- 预防一下
                    XianDaoHuiCC:req_ry_award( )
                    self:remove_btn( 8 );
                end
                local xiandaohui_btn = CountDownButton( px, py, btn_w, btn_h, 
                                                 "nopack/main/xdh_reward_icon.png", 
                                                 "nopack/main/xdh_reward_icon_bg.png",
                                                 xiandaohui_btn_fun, nil, nil);

                self.view:addChild(xiandaohui_btn.view);
                self.second_row_btn_table[ btn_index ] = xiandaohui_btn;
             
                btnSetPosition(xiandaohui_btn,px,py)
            end
        elseif btn_index == 13 then
            --投资返利
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local function tzfl_btn_fun()
                TZFLModel:open_win()
            end
            local tzfl_btn = CountDownButton( px, py, btn_w, btn_h, 
                                             "nopack/main/tzlc_icon.png", 
                                             "nopack/main/tzlc_icon_bg.png",
                                             tzfl_btn_fun, nil, nil);

            self.view:addChild(tzfl_btn.view);
            self.second_row_btn_table[ btn_index ] = tzfl_btn;
         
            btnSetPosition(tzfl_btn,px,py)

        elseif btn_index == 14 then
            --活动入口
            self.second_row_curr_btn_num = self.second_row_curr_btn_num + 1
            local px = second_start_x-self.second_row_curr_btn_num*btn_width
            local py = second_row_pos_y
            local function activity_btn_fun()
               local win = UIManager:show_window("activity_menus_panel");
               -- win:init_with_params(param)
            end
            local activity_btn = CountDownButton( px, py, btn_w, btn_h, 
                                             UILH_MAINACTIVITY.main_activity_icon, 
                                             UILH_MAINACTIVITY.main_activity_icon,
                                             activity_btn_fun, nil, nil);

            self.view:addChild(activity_btn.view);
            self.second_row_btn_table[ btn_index ] = activity_btn;
         
            btnSetPosition(activity_btn,px,py)

            -- 设置 该活动按钮 有活动提醒
            self:update_activity_show_mark( )
        end
		-- if ( self.is_show == false and self.second_row_btn_table[ btn_index ] and self.second_row_btn_table[ btn_index ].view ) then
		-- 	self.second_row_btn_table[ btn_index ].view:setIsVisible(false);
  --           self.second_row_btn_table[ btn_index ].view:setPosition(screen_width,self.second_row_btn_table[ btn_index ]._y)
  --       end
        if self.second_row_btn_table[ btn_index ] then
            self:repos_second_row_btn10(5)
            self:repos_second_row_btn10(1)

            -- 有可能创建时就需要隐藏，这里补充处理一下
            if self.is_show == false then
                self:menusHideActions(self.second_row_btn_table[ btn_index ])
            end
        end
        -- self:repos_second_row_btn1()
    end
end
-- 删除按钮
function RightTopPanel:remove_btn( btn_index ) 
    print('remove_btn--------------------------------------------------')
    local tempbtn = self.second_row_btn_table[btn_index]
    if tempbtn then
        local curr_x = tempbtn.view:getPosition();
        for k,v in pairs(self.second_row_btn_table) do
            local pos_x,pos_y = self.second_row_btn_table[k].view:getPosition();

            if ( pos_x < curr_x ) then
                pos_x = pos_x + 70
                local tbtn = self.second_row_btn_table[k]
                btnSetPosition(tbtn,pos_x,pos_y)
            end
        end
        self.second_row_btn_table[btn_index] = nil;
        self.second_row_curr_btn_num = self.second_row_curr_btn_num - 1;
        btnRelease(tempbtn)
    end
end
-- 按钮闪烁控制
function RightTopPanel:shanshuo_btn( index, flag )
    if not index then return end
    local tempbtn = self.second_row_btn_table[index]
    if tempbtn then
        if flag then
            tempbtn:add_spr_bg()
            tempbtn:add_effect(38, 35)
        else
            tempbtn:remove_effect()
        end
    end
end
-- 重排第二排按钮（指定按钮永远在最右）
function RightTopPanel:repos_second_row_btn10( idx )
    local btn1 = self.second_row_btn_table[idx]
    if btn1 then
        local curr_x = btn1.view:getPosition();
        if curr_x == second_start_x-btn_width then
            return
        end
        for k,v in pairs(self.second_row_btn_table) do
            local pos_x,pos_y = self.second_row_btn_table[k].view:getPosition();

            if ( pos_x > curr_x ) then
                pos_x = pos_x - btn_width
                local tbtn = self.second_row_btn_table[k]
                btnSetPosition(tbtn,pos_x,pos_y)
            end
        end
        btnSetPosition(btn1, second_start_x-btn_width, second_row_pos_y)
    end
end

-- 重排第二排按钮（斗法台永远在最左）
function RightTopPanel:repos_second_row_btn1(  )
    local btn1 = self.second_row_btn_table[1]
    if btn1 then
        local cnt = 0
        local curr_x = btn1.view:getPosition();
        for k,v in pairs(self.second_row_btn_table) do
            local pos_x,pos_y = self.second_row_btn_table[k].view:getPosition();
            cnt = cnt + 1
            if ( pos_x < curr_x ) then
                pos_x = pos_x + btn_width
                local tbtn = self.second_row_btn_table[k]
                btnSetPosition(tbtn,pos_x,pos_y)
            end
        end
        btnSetPosition(btn1, second_start_x-btn_width*cnt, second_row_pos_y)
    end
end

-- 执行按钮方法
function RightTopPanel:do_btns_menthod( btn_index )
    -- btn_index : 1,斗法台排行奖励 2,仙尊三vip卡
    if btn_index == 1 then
        -- 领取斗法台排行奖励 
        DouFaTaiCC:req_get_reward_info( );
        self:remove_btn( 1 );
    elseif btn_index == 2 then

    elseif btn_index == 6 then
        LoginAwardWin:show();
    elseif btn_index == 7 then
        -- LuckGuestWin:show()
    elseif btn_index == 8 then
        XianDaoHuiCC:req_ry_award( )
        self:remove_btn( 8 );
    elseif btn_index == 9 then
        QQBlueDiamonTimeAwardModel:open_win()
    end
end

--设置隐藏动画
function RightTopPanel:menusHideActions(btn)

    if not btn then return end
    
    local _action = btn.hideAction
    --看看有没缓存，有缓存用缓存的
    --if not _action then
        local array = CCArray:array();
        local c   = CCMoveTo:actionWithDuration(0.15,CCPoint(second_start_x,btn._y));
        array:addObject(c)
        array:addObject(CCHide:action());
        _action = CCSequence:actionsWithArray(array)
        --safe_retain(_action)
        btn.hideAction = _action
        --print('***Create RightTopPanel:menusHideActions')
    --end
    -------------------------
    btn.view:stopAllActions()
    btn.view:runAction(_action)
end

--设置显示动画
function RightTopPanel:menusShowActions(btn)

    if not btn then return end

    local _action = btn.showAction
    --看看有没缓存，有缓存用缓存的
    --if not _action then
        _action = CCMoveTo:actionWithDuration(0.15,CCPoint(btn._x,btn._y));
        --safe_retain(_action)
        btn.showAction = _action
        --print('***Create RightTopPanel:menusShowActions')
    --end
    btn.view:setIsVisible(true)
    ---------------------------
    btn.view:stopAllActions()
    btn.view:runAction(_action)
end

-- 更换新活动按钮的角标数据
function RightTopPanel:update_activity_remain_tips(  )
    -- local num = ActivityModel:get_activity_fuben_total_remain_times()
    -- if num > 0 then
    --     daily_activity_tip_t.round_bg.view:setIsVisible(true)
    --     daily_activity_tip_t.img_num.view:setIsVisible(true)
    --     daily_activity_tip_t.img_num:setText(tostring(num))
    -- else
    --     daily_activity_tip_t.round_bg.view:setIsVisible(false)
    --     daily_activity_tip_t.img_num.view:setIsVisible(false)
    -- end
end

-- 更换活动要不要感叹号
function RightTopPanel:update_activity_show_mark( )
    require "../data/activity_config/show_mark_actives_id"
    local flag = false

    local act_time_id =  SmallOperationModel:get_act_id()

    for i=1,#_show_mark_actives_id do
        -- print("_show_mark_actives_id[i]=",_show_mark_actives_id[i])
        for j=1,#act_time_id do
            print("act_time_id[j]=",act_time_id[j])
            if _show_mark_actives_id[i] == act_time_id[j] then
                flag = true
                break
            end
        end
    end

    local flag_light = false
    for i=1,#_show_light_actives_id do
        -- print("_show_mark_actives_id[i]=",_show_mark_actives_id[i])
        for j=1,#act_time_id do
            print("act_time_id[j]=",act_time_id[j])
            if _show_light_actives_id[i] == act_time_id[j] then
                flag_light = true
                break
            end
        end
    end

    -- local show_act_btn = ActivityModel:get_act_min_btn_show()
    -- if flag == true and show_act_btn == true then
    --     local function open_act_fun( )
    --         UIManager:show_window("activity_menus_panel")
    --     end
    --     MiniBtnWin:show(23,open_act_fun)
    --     ActivityModel:set_act_min_btn_show(false) --避免打开活动拉去时，再弹出minibtn
    --     -- 当有新活动时，活动按钮显示特效
    --     self.first_row_btns_table[3]:showClickEffect();
    -- end
    if flag then
        self:set_btntip_active_second( 14)
    end
    if flag_light then
        LuaEffectManager:play_view_effect( 11041, 38, 35, self.second_row_btn_table[14].view, true)
        -- self.second_row_btn_table[14].view:add_effect(35, 38)
    end
end

function RightTopPanel:active( show )
    if show then
        local player = EntityManager:get_player_avatar();
        -- 如果玩家创建了
        if player then 
            self:reset_first_row_btns_pos( )
        end

        -- add by chj @2015-4-1
        -- 添加按钮提示
        DreamlandCC:req_free_count()                -- 遗迹寻宝
        OthersCC:req_get_enter_fuben_count()        -- 玩法大厅副本
        DouFaTaiCC:req_get_info()                   -- 成长之路点将台
    end
end

-- 显示变身倒计时按钮
function RightTopPanel:show_expe_transform_btn( transform_time )
    if transform_time >= 0 then
        -- 更新倒计时时间值
        local bianshen_btn = self.second_row_btn_table[12]
        if bianshen_btn then
            local timer_lab = bianshen_btn.timer_lab
            if timer_lab then
                if transform_time > 0 then
                    timer_lab:setText(transform_time)
                else
                    timer_lab:setString("可领取")
                end
            end
        else
            -- self:insert_btn(12, transform_time)
        end
    else
        -- self:remove_btn(12)
    end
end

-- 获取变身倒计时剩余时间
function RightTopPanel:getTransformTime()
    local bianshen_btn = self.second_row_btn_table[12]
    if bianshen_btn then
        local TimerLabelObj = bianshen_btn.timer_lab
        if TimerLabelObj then
            -- 获取剩余倒计时时间
            return TimerLabelObj:getRemainTime()
        end
    end
end

function RightTopPanel:find_component(id)
    -- body
    return self._instruction_components[id]
end

-- 检查系统开启按钮是否已经被创建
function RightTopPanel:isSysOpenBtnExist()
    return self.sys_open_btn
end

-- 显示必杀技文字
function RightTopPanel:show_bsj_animation()
    if self.bsj_text_img ~= nil then
        self.bsj_text_img:removeFromParentAndCleanup(true);
        self.bsj_text_img = nil
    end
    local cb1 = callback:new()
    local function callback_func1()
        if self.bsj_text_img ~= nil then
            self.bsj_text_img:removeFromParentAndCleanup(true);
            self.bsj_text_img = nil
        end
        local player = EntityManager:get_player_avatar()
        if player and player.job then
            local path = "nopack/skill_text/bsj_" .. player.job .. ".png";
            self.bsj_text_img = CCZXImage:imageWithFile( 94, -81, -1, -1, path )
            self.view:addChild(self.bsj_text_img)
        end

        local cb2 = callback:new()
        local function callback_func2()
            if self.bsj_text_img ~= nil then
                self.bsj_text_img:removeFromParentAndCleanup(true);
                self.bsj_text_img = nil
            end
        end
        cb2:start(2.3,callback_func2);
    end
    cb1:start(0.2,callback_func1);
end

-- 6: 遗迹寻宝, 4: 玩法大厅, 3: 成长之路
-- 给第一行btn添加角标提示
function RightTopPanel:set_btntip_active_first( index)
    -- body
    if self.btns_tip_fst[index] == nil then
        self.btns_tip_fst[index] = CCBasePanel:panelWithFile(45, 45, -1, -1, UILH_MAIN.remain_bg)
        self.btns_tip_fst[index]:setScale(0.6)
        self.first_row_btns_table[index].view:addChild(self.btns_tip_fst[index])
    end
end

-- 移除按钮提示
function RightTopPanel:remove_btntip_first( index)
    if self.btns_tip_fst[index] then
        self.btns_tip_fst[index]:removeFromParentAndCleanup(true);
        self.btns_tip_fst[index] = nil
    end
end

-- 给第二行btn添加角标提示 
-- 14: 活动大厅
function RightTopPanel:set_btntip_active_second( index)
    -- body
    if self.btns_tip_scd[index] == nil then
        self.btns_tip_scd[index] = CCBasePanel:panelWithFile(35, 35, -1, -1, UILH_MAIN.remain_bg)
        self.btns_tip_scd[index]:setScale(0.8)
        self.second_row_btn_table[index].view:addChild(self.btns_tip_scd[index])
    end
end

-- 移除按钮提示
function RightTopPanel:remove_btntip_second( index)
    if self.btns_tip_scd[index] then
        self.btns_tip_scd[index]:removeFromParentAndCleanup(true);
        self.btns_tip_scd[index] = nil
    end
end