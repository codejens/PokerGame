-- UserPanel.lua
-- create by hcl on 2012-12-1
-- 用户头像面板

require "UI/main/MiniTaskPanel"
super_class.UserPanel(Window)


local _is_next_show_hp = false;      -- 血瓶 不够时，是否提示
local _is_next_show_mp = false;      -- 蓝瓶 不够时，是否提示
local _is_next_show_pet_hp = false;      -- 宠物粮 不够时，是否提示
local _is_next_show_bolanggu = false    -- 拨浪鼓不足时，是否提示
-- 任务栏是否隐藏
local is_hide = false;
-- 不能切换pk模式的副本列表 72,仙道会争霸赛
local NO_CHANGE_PK_MODE_FUBEN_TABLE = {59,72}
-- local TIME_INFO = { rect = {260,360,70,29} , texture = 'ui/main/time_bg.png'} --ZImage:create(self.view,"ui/main/time_bg.png",180,330,62,18,0,500,500);
-- local HP_INFO = { "nopack/main/16.png","nopack/main/16.png" } 
-- local MP_INFO = { "nopack/main/15.png" }
local FONT_SIZE = 14
local TIME_FONT_SIZE = 14

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local AUTO_X = 259
local AUTO_Y = 150

local AUTO_HIDE_X = 38
local AUTO_HIDE_Y = 150

local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

local function _autoActionEnable(view, state)
    if view:getIsVisible() == state then
        return
    end
    view:setIsVisible(state)
    if state then
        view:resumeSchedulerAndActions()
    else
        view:pauseSchedulerAndActions()
    end
end
function UserPanel:__init( window_name, texture_name)
    -- 设置面板可以点穿
    self.view:setDefaultMessageReturn(false)
    -- 使用血瓶和蓝品的回调
    self.use_blood_bottle_cb = callback:new()
    self.use_magic_bottle_cb = callback:new()
    -- 宠物使用宠物粮的回调
    self.pet_use_pet_food_cb = callback:new()
    -- 创建宠物面板
    self:create_pet_panel()
    -- 其他Entity的显示面板
    self:create_other_entity_panel();
    -- 快捷任务栏
    self.miniTaskPanel = MiniTaskPanel();
    self.view:addChild(self.miniTaskPanel.view);
    -- 私聊面板
    self.whisper_panel = CCBasePanel:panelWithFile( 270,175, 57, 44, "" )
    self.private_chat_btn = ZButton:create(self.whisper_panel,UILH_MAIN.m_chat, nil,0,0,57,44);
    -- self.private_chat_btn:setTouchBeganReturnValue(false)
    -- self.private_chat_btn:setTouchEndedReturnValue(false)
    -- self.private_chat_btn.view:unregisterScriptHandler()
    -- self.private_chat_btn.view:setDefaultMessageReturn(false)
    self.view:addChild(self.whisper_panel)
    self.private_chat_btn.view:setIsVisible(false)
    -- 隐藏任务栏按钮
    -- self.hide_task_panel_btn = ZButton:create(self.view,{UIResourcePath.FileLocate.normal .. "m_hide_l.png",UIResourcePath.FileLocate.normal .. "m_hide_l.png"},btn_hide_fun,5,50,38,37);
    --隐藏任务栏按钮函数 
    local function btn_hide_fun(eventType,args,msgid)
        -- --print("btn_hide_fun.....................")
        Analyze:parse_click_main_menu_info(130)
        -- 取得当前是否在做动作
        local panel = self.miniTaskPanel.view;
        local action_num = panel:numberOfRunningActions();
        if ( action_num > 0 ) then
            return;
        end
        self:toggle_show_minitask_panel(is_hide)
    end
    self.hide_task_panel_btn = FlipButton( 5,210,36,59,
                                             UILH_MAIN.m_mini_task,
                                             btn_hide_fun )
    self.hide_task_panel_btn:show_frame(1)
    self.view:addChild(self.hide_task_panel_btn.view)

    self:create_player_state_title();
    -- pk模式
    local function fun()
        -- 如果是在不能切换pk模式的副本中，直接返回
        local curr_fb_id = SceneManager:get_cur_fuben();
        for k,v in pairs(NO_CHANGE_PK_MODE_FUBEN_TABLE) do
            if v == curr_fb_id then
                return;
            end
        end
        Analyze:parse_click_main_menu_info(112)
        local player =  EntityManager:get_player_avatar(  );
        if ( player.pkMode == 4 ) then
            PKCC:req_set_pk_mode( 0);
        --屏敝阵营模式
        elseif(player.pkMode == 2) then
            PKCC:req_set_pk_mode (4)
        else
            PKCC:req_set_pk_mode( player.pkMode + 1 );
        end
    end
    self.pk_mode = ToggleView:create(2,self.view,42,266,56,32,fun,CCPoint(0.5,0.5),5,
        UILH_MAIN.m_mode_1,
        UILH_MAIN.m_mode_2,
        UILH_MAIN.m_mode_3,
        UILH_MAIN.m_mode_4,
        UILH_MAIN.m_mode_5,
        UILH_MAIN.m_mode_6)
    self.view:reorderChild(self.pk_mode.btn,99);
    self.pk_mode:setIsVisible( true );
    -- 时钟
    -- local clock_bg = ZImage:create(self.view,TIME_INFO.texture,
    --                                 TIME_INFO.rect[1],
    --                                 TIME_INFO.rect[2],
    --                                 TIME_INFO.rect[3],
    --                                 TIME_INFO.rect[4],
    --                                 0-1,-1);

    -- ZImage:create(clock_bg,"ui/main/clock.png",-1,0)
    -- local curr_time = os.date("%X", os.time())
    -- self.clock_label = ZLabel:create(clock_bg,curr_time,24,8,TIME_FONT_SIZE,1);
    -- local function clock_fun()
    --     local curr_time = os.date("%H:%M", os.time())

    --     self.clock_label:setText(string.format("#c0edc09%s",curr_time));
    -- end
    -- self.clock_timer = timer();
    -- self.clock_timer:start(1,clock_fun);

    -- 绑定所有按钮函数
    self:on_band()

    --self.signal_icon_bg = ZImage:create(self.view,'ui/main/signalGood.png',773,16);
    -- self.signal_icon_bg.view:setIsVisible(false)
    -- self.signal_icon = ZImage:create(self.view,'ui/main/signalGood.png',332,360);

    -- UserPanel.signal_icon = self.signal_icon
    -- ZImage:create(self.view, "ui/common/jishou_test_bg.png",300, 200, 200, 50, 1,500,500)
    -- ZImage:create(self.view, "ui/common/jishou_test_bg.png",300, 100)
    -- ZImage:create(self.view, "ui/common/z_test1.png",100, 150,180,180,9,500,500)
    -- ZImage:create(self.view, "ui/common/z_test2.png",300, 150,180,180,9,500,500)
    -- ZImage:create(self.view, "ui/common/z_test3.png",500, 150,180,180,9,500,500)
    -- ZImage:create(self.view, "ui/common/z_test4.png",100, -50,180,180,9,500,500)
    -- ZImage:create(self.view, "ui/common/z_test5.png",300, -50,180,180,9,500,500)
    -- ZImage:create(self.view, "ui/common/z_test6.png",500, -50,180,180,9,500,500)
    UIManager:setMainUI(1,self.view)

    self._instruction_components = {}
end

function UserPanel:toggle_show_minitask_panel( show )
    local panel = self.miniTaskPanel.view;
    panel:stopAllActions()
    local posx, posy = UIPOS_MiniTaskPanel_000[1], UIPOS_MiniTaskPanel_000[2]

    if ( show ) then
        panel:setIsVisible(true);
        local action = CCMoveTo:actionWithDuration(0.25,CCPoint(posx,posy));
        panel:runAction(action);

        local action_auto = CCMoveTo:actionWithDuration(0.25,CCPoint(AUTO_X,AUTO_Y))
        -- self.auto_panel:runAction(action_auto)
        self.hide_task_panel_btn:show_frame(1)
    else
        local action = CCMoveTo:actionWithDuration(0.25,CCPoint(posx-180,posy));
        -- panel:runAction(action);
        local array = CCArray:array();
        array:addObject(action)
        local hide = CCHide:action()
        array:addObject(hide);
        local seq = CCSequence:actionsWithArray(array)
        panel:runAction(seq)
        -- self.action_cb = callback:new();
        -- 0.4秒后隐藏

        local action_auto = CCMoveTo:actionWithDuration(0.25,CCPoint(AUTO_HIDE_X,AUTO_HIDE_Y))
        -- self.auto_panel:runAction(action_auto)

        -- local function cb_function ()
        --     panel:setIsVisible(false);  
        -- end
        -- self.action_cb:start(0.25,cb_function);
        self.hide_task_panel_btn:show_frame(2)
    end
    is_hide = not show
end

function UserPanel:toggle_show_minitask( show )
    local win = UIManager:find_visible_window("user_panel")
    if win and is_hide == show then
        win:toggle_show_minitask_panel(show)
    end
end


local auto_animation_pos = {
    [1] = {x = -115+38*1, y = 2+2},
    [2] = {x = -115+38*2-1, y = 2},
    [3] = {x = -115+38*3, y = 2},
    [4] = {x = -115+38*4-1, y = 2},
    [5] = {x = -115+38*5-1, y = 2-1},
    [6] = {x = -115+38*3, y = 2+2},
    [7] = {x = -115+38*4, y = 2+2},
    [8] = {x = -115+38*3-1, y = 2-1},
    [9] = {x = -115+38*4, y = 2},
}

function UserPanel:create_player_state_title()
    -- self.auto_panel = CCBasePanel:panelWithFile(AUTO_X,AUTO_Y, 42, 217, "" )
    -- self.auto_panel:setTag(1)
    -- self.view:addChild(self.auto_panel)
    -- -- 挂机的时候显示自动打怪中
    -- self.auto_kill_monster = EffectBuilder.createAnimationInterval(UIPIC_UserPanel_007,0.5,-1)
    -- self.auto_panel:addChild(self.auto_kill_monster,-1)
    -- _autoActionEnable(self.auto_kill_monster,false);

    -- -- 任务状态显示自动寻路中
    -- self.auto_move = EffectBuilder.createAnimationInterval(UIPIC_UserPanel_008,0.5,-1)
    -- self.auto_panel:addChild(self.auto_move,-1)
    -- _autoActionEnable(self.auto_move,false);
    -- -- 跟随状态显示自动跟随中
    -- self.auto_follow = EffectBuilder.createAnimationInterval(UIPIC_UserPanel_009,0.5,-1)
    -- self.auto_panel:addChild(self.auto_follow,-1)
    -- _autoActionEnable(self.auto_follow,false);

    self.auto_text_timer = timer()

    -- 文字的透明背景
    self.auto_panel = CCBasePanel:panelWithFile(_rx(480),280, 1, 1, "" )
    self.view:addChild(self.auto_panel)    

    -- 挂机的时候显示自动打怪中
    self.auto_kill_monster = MUtils:create_sprite(self.auto_panel,UILH_MAIN.auto_kill_monster_img,0,0);
    self.auto_kill_monster:setIsVisible(false);
    -- 任务状态显示自动寻路中
    self.auto_move = MUtils:create_sprite(self.auto_panel,UILH_MAIN.auto_move_img,0,0);
    self.auto_move:setIsVisible(false);
    -- 跟随状态显示自动跟随中
    self.auto_follow = MUtils:create_sprite(self.auto_panel,UILH_MAIN.auto_auto_follow_img,0,0);
    self.auto_follow:setIsVisible(false);

    self.fight_img = {}
    self.fight_img[1] = MUtils:create_sprite(self.auto_panel,UILH_MAIN.fight_img1,-115,0);
    self.fight_img[1]:setIsVisible(false)
    self.fight_img[2] = MUtils:create_sprite(self.auto_panel,UILH_MAIN.fight_img2,-115,0);
    self.fight_img[2]:setIsVisible(false)

    self.foot_img = {}
    self.foot_img[1] = MUtils:create_sprite(self.auto_panel,UILH_MAIN.foot_img1,-115,0);
    self.foot_img[1]:setIsVisible(false)
    self.foot_img[2] = MUtils:create_sprite(self.auto_panel,UILH_MAIN.foot_img2,-115,0);
    self.foot_img[2]:setIsVisible(false)

    -- 文字图片，有序保存
    self.auto_text = {}
    self.auto_text[1] = {}
    self.auto_text[2] = {}
    self.auto_text[3] = {}
    for i=1,9 do
        local img = MUtils:create_sprite(self.auto_panel,UIResourcePath.FileLocate.lh_main .. "m_auto_text".. i ..".png",auto_animation_pos[i].x,auto_animation_pos[i].y);
        img:setIsVisible(false)
        if i <= 5 then
            self.auto_text[1][i] = img
            self.auto_text[2][i] = self.auto_text[1][i]
            self.auto_text[3][i] = self.auto_text[1][i]
        elseif i == 6 then
            self.auto_text[2][3] = img
        elseif i == 7 then
            self.auto_text[2][4] = img
        elseif i == 8 then
            self.auto_text[3][3] = img
        elseif i == 9 then
            self.auto_text[3][4] = img        
        end
    end
end

-- 绑定所有按钮函数
function UserPanel:on_band(  )
    -- 点击宠物面版函数
    local function panel_pet_bg_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            Analyze:parse_click_main_menu_info(113)
            if ( XianYuModel:get_status(  ) == false ) then 
                -- 如果当前宠物没有出战，就出战宠物
                if ( PetModel:get_current_pet_is_fight() == false ) then
                    -- 宠物死亡后有20秒的cd时间，不能出战
                    if PetModel:get_current_fight_pet_cd(  ) == 0 then
                        -- 如果宠物的快乐度等于0，就要使用道具恢复快乐度
                        local pet_info = PetModel:get_current_pet_info(  );
                        if ( pet_info.tab_attr[5] == 0 ) then
                            local count = ItemModel:get_item_count_by_id( 28273 )
                            if ( count == 0 ) then
                                UserPanel:buy_bolanggu();
                            else
                                PetCC:req_add_live_play_feed(pet_info.tab_attr[1],2);
                            end
                        else
                            PetCC:req_fight( PetModel:get_current_pet_id(),1 );
                        end
                    else
                        GlobalFunc:create_screen_notic( LangGameString[1466] ); -- [1466]="您的宠物现在需要休息！"
                    end
                else
                    --print("申请切换宠物战斗模式")
                    -- 如果宠物出战，就是切换宠物战斗模式
                    print("goggogogo 8888888888888888888")
                    local pet_info = PetModel:get_current_pet_info(  );
                    local fight_type =  pet_info.tab_attr[7] + 1 ;
                    if ( fight_type == 4 ) then
                        fight_type = 1;
                    end
                    PetCC:req_change_pet_fight_type( PetModel:get_current_pet_id() , fight_type );
                end
            else
                GlobalFunc:create_screen_notic( LangGameString[1467] ) -- [1467]="灵泉仙浴中宠物不能出战"
            end
        end
        return true;
    end   
    self.spr_pet_bg:registerScriptHandler( panel_pet_bg_fun );

    -- 私聊按钮函数
    local function whisper_panel_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif  eventType == TOUCH_CLICK then
            -- Analyze:parse_click_main_menu_info(131)
            if ChatPrivateChatModel:get_private_is_active() == true then
                UIManager:show_window("chat_private_scroll")
                --ChatPrivateChatModel:open_private_chat()
                UserPanel:set_whisper_btn_visible(false)
                MenusPanel:set_chat_panel_visible(false)
                UserPanel:set_whisper_btn_timer(0)
            end
            return true;
        elseif eventType == TIMER then
                if UserPanel:get_whisper_btn_visible() == true then
                    UserPanel:set_whisper_btn_visible(false)
                else
                    UserPanel:set_whisper_btn_visible(true)
                end
            return true
        end
        return true
    end
    self.whisper_panel:registerScriptHandler(whisper_panel_fun)
    local function btn_private_chat_fun(eventType, arg, msgid, selfItem)
        if UserPanel:get_whisper_btn_visible() == true then
            UserPanel:set_whisper_btn_visible(false)
        else
            UserPanel:set_whisper_btn_visible(true)
        end
    end
    local function chat_private()
        -- Analyze:parse_click_main_menu_info(131)
        if ChatPrivateChatModel:get_private_is_active() == true then
            UIManager:show_window("chat_private_scroll")
            UserPanel:set_whisper_btn_visible(false)
            MenusPanel:set_chat_panel_visible(false)
            UserPanel:set_whisper_btn_timer(0)
        end
    end

    self.private_chat_btn:setTouchTimerFun(btn_private_chat_fun)
    self.private_chat_btn:setTouchClickFun(chat_private)
    -- self.hide_task_panel_btn:setTouchClickFun(btn_hide_fun);
    -- 其他人物面板函数
    local function other_entity_panel_fun (eventType,arg,msg_id)
        --print("other_entity_panel_fun")
        -- entity_type 0 代表选中的是玩家
        if ( self.target_entity ) then
            if ( self.target_entity.type == 0 ) then
                -- 先判断是不是我的好友
                local param = {roleId = self.target_entity.id,roleName = self.target_entity.name,level = self.target_entity.level,camp = self.target_entity.camp,
                            job = self.target_entity.job,sex = self.target_entity.sex,handle = self.target_entity.handle,qqvip = self.target_entity.QQVIP};
    
                if ( FriendModel:is_my_friend( self.target_entity.id )  ) then
                    -- 弹出右键菜单
                    param.ttype = 1;
                    if ( GuildModel:check_ask_join_right(  ) ) then
                        LeftClickMenuMgr:show_left_menu( "player_menu_guild",param, 530 );
                    else
                        LeftClickMenuMgr:show_left_menu( "player_menu",param, 530 );
                    end 
                else
                    if ( GuildModel:check_ask_join_right(  ) ) then
                        LeftClickMenuMgr:show_left_menu( "player_menu_not_friend_guild",param, 530 );
                    else
                        LeftClickMenuMgr:show_left_menu( "player_menu_not_friend",param, 530 );
                    end 
                end
            elseif ( self.target_entity.type == 4 ) then
                LeftClickMenuMgr:show_left_menu( "pet_menu",self.target_entity,361,480,false );
            end
        end
    end
    self.select_entity_panel:setTouchClickFun(other_entity_panel_fun);
end

-- 创建宠物面板
function UserPanel:create_pet_panel()
    -- 宠物面板
    self.spr_pet_bg =  CCBasePanel:panelWithFile( 178, 238,-1,-1,
                                                  UILH_MAIN.m_pet_bg);
    self.view:addChild(self.spr_pet_bg);
    self.spr_pet_bg:setIsVisible(false);    --默认隐藏

    -- 宠物头像
    self.pet_head = ZButton:create(self.spr_pet_bg,"",nil,9,11,50,50);
    self.pet_head:setTouchBeganReturnValue(false)
    self.pet_head:setTouchEndedReturnValue(false)
    self.pet_head:setTouchClickReturnValue(false)

    -- 宠物血条图片
    self.pet_hp_view = ZCCSprite:create(self.spr_pet_bg,"nopack/main/m_pet_bar.png",43,3)
    self.pet_hp_view.view:setAnchorPoint(CCPoint(0.5,0));   

    -- 宠物等级bg
    -- local spr_pet_lv_bg = ZCCSprite:create(self.spr_pet_bg,UIResourcePath.FileLocate.main .. "m_lv_bg.png",8,12);

    -- 宠物等级数值
    -- self.pet_lv = ZLabel:create(self.spr_pet_bg,"",10,5,FONT_SIZE,2);
    self.pet_hp_view.view:setTag(0)
end

-- 其他Entity的显示面板
function UserPanel:create_other_entity_panel()
    -- 防止重复创建
    if ( self.select_entity_panel ) then
        self.select_entity_panel.view:removeFromParentAndCleanup(true);
        self.select_entity_panel = nil;
    end
    -- 选中实体面板
    self.select_entity_panel = ZBasePanel:create( self.view, 
                                                  "", 
                                                  282,290, 190, 81); 
    self.select_entity_panel.view:setIsVisible(false);
    spr_bg = MUtils:create_zximg(self.select_entity_panel,UILH_MAIN.m_other_bg,0,0,-1,-1,500,500)
    spr_bg:setTag(0)
    -- 血条
    self.select_entity_hp = HPBar( spr_bg,
                                    "nopack/main/21.png",
                                    "nopack/main/21.png",
                                    87,42,89,13,nil,1 ); 
    -- 血条数值
    -- self.entity_hp_v = ZLabel:create(self.select_entity_hp.view,"",76,8,14,1);
    -- self.entity_hp_v.view:setAnchorPoint(CCPointMake(0.5,0.5))
    -- 蓝条
    self.select_entity_mp = MUtils:create_zximg(spr_bg,UILH_MAIN.m_other_blue,85,35,-1,-1,500,500)
    self.select_entity_mp:setAnchorPoint(0.0,0.5)
    self.select_entity_mp:setTag(0)

    -- self.select_entity_bg = ZCCSprite:create(self.select_entity_panel,"ui/main/user_head_bg.png",40,40)
    -- 头像
    self.select_entity_head = ZCCSprite:create(self.select_entity_panel,'',50,50)--ZImage:create(self.select_entity_panel,"",35,36,75,75,0,500,500);
    --self.select_entity_head.view:setScaleX(60/75)
    --self.select_entity_head.view:setScaleY(60/75)

    -- ZCCSprite:create(self.select_entity_panel,"ui/main/target_name_bg.png",38,-10)
    -- 等级bg
    local spr_pet_lv_bg = ZImage:create(self.select_entity_panel,
                                           UILH_MAIN.m_other_lv,-6,56);
    -- 选中实体等级
    self.select_entity_lv = ZLabel:create(spr_pet_lv_bg,"",15,10,FONT_SIZE,2);
    -- 名字
    self.select_entity_name = ZLabel:create( self.select_entity_panel,"", 135, 65, 16, 2 )
    -- self.select_entity_name.view:setAnchorPoint(0.5,0.5);
    -- self.select_entity_name:setPosition( 35, -3 )
    -- self.select_entity_panel:addChild(self.select_entity_name.view)

    -- 蓝条
    -- self.select_entity_mp = ZCCSprite:create(self.select_entity_panel,"nopack/main/15.png",69,23);
    -- self.select_entity_mp.view:setAnchorPoint(CCPoint(0,0));
    -- 选中实体的buff
   -- self.other_buff_view = BuffView(self.select_entity_panel,87,6);
end

-- 更新血条
function UserPanel:updateHp(current_hp_float,max_hp_float,change_hp)
    -- 更新view
    -- local rate = math.min(current_hp_float / max_hp_float,1)
    -- self.player_hp:setScaleX(rate);
    self.player_hp:update_hp( change_hp,current_hp_float,max_hp_float )
    -- self.player_hp_v:setText(current_hp_float.."/"..max_hp_float)

    local player = EntityManager:get_player_avatar();

    if player.level == 1 then
        return;
    end

    -- 取得系统设置，挂机设置里面的值
    -- 血少于多少百分比吃药
    local use_hp_bottle_rate = SetSystemModel:get_date_value_by_key( SetSystemModel.ASSIST_HP_ITEM )/100;

    -- 血不能为0 且血少于一半自动加血, 
    if ( current_hp_float ~= 0 and current_hp_float / max_hp_float <= use_hp_bottle_rate and player.is_use_blood_bottle == false) then
        -- --print("player.hpStore=....................................................",player.hpStore)
        -- 如果血包里面有血就使用血包
        if ( player.hpStore > 0 ) then
            ItemCC:req_use_hp_store(1);
        else
            local blood_bottle_series = ItemModel:get_bag_exist_blood_bottle();
            if ( blood_bottle_series ) then
                ItemModel:use_a_item( blood_bottle_series ,0)
            else
                -- 如果没有血瓶的话
                -- 取得系统设置,挂机设置里面的 -- /** 红蓝药耗尽停止打怪 （生命补给或法力补给耗尽停止打怪） **/
                local is_stop_guaji  = SetSystemModel:get_date_value_by_key( SetSystemModel.STOP_AUTO_FIGHTING );
                if ( is_stop_guaji ) then
                    -- 停止挂机
                    AIManager:set_state( AIConfig.COMMAND_IDLE )
                end
                -- 弹出提示字——》提示框
                if ( not _is_next_show_hp ) then
                    local function swith_but_func( is_next_show )
                        _is_next_show_hp = is_next_show
                    end
                    local function goto_qianqian_func(  )
                        GlobalFunc:ask_npc( SceneConfig.scenceid.MU_YE_CUN, LangGameString[1468] ) -- [1468]="芊芊"
                    end
                    local function open_shop_win(  )
                        UIManager:show_window( "shop_win" )
                        ShopWin:change_page( "drug" )
                    end
                    local function mini_but_func(  )
                        if VIPModel:is_vip_lv3() then 
                            ConfirmWin2:show( 1, 4, LangGameString[1469], open_shop_win, swith_but_func ) -- [1469]="背包中没有药品，不能自动加血，您可以:返回天元城找#cffff00芊芊#cffffff购买药品。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
                        else 
                            ConfirmWin2:show( 1, 1, LangGameString[1469], goto_qianqian_func, swith_but_func ) -- [1469]="背包中没有药品，不能自动加血，您可以:返回天元城找#cffff00芊芊#cffffff购买药品。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
                        end
                    end 
                    MiniBtnWin:show( 11 , mini_but_func ,nil )
                end
                
                return;
            end
        end 
        -- 开始计算cd
        player.is_use_blood_bottle = true;
        local function dismiss( dt )
            player.is_use_blood_bottle = false;
        end
        self.use_blood_bottle_cb:start(player.use_blood_bottle_cd, dismiss)
    end
    local hp_rate =  current_hp_float / max_hp_float;
    -- 人物血少于20%时播放闪烁的特效
    if ( self.hp_blink_effect_node == nil and hp_rate < 0.2 and hp_rate ~= 0 ) then 
        self.hp_blink_effect_node = LuaEffectManager:play_hp_blink_effect( self.player_hp );
    elseif ( self.hp_blink_effect_node and current_hp_float / max_hp_float > 0.2 ) then
        self.hp_blink_effect_node:removeFromParentAndCleanup(true);
        self.hp_blink_effect_node = nil;
    end

end


function UserPanel:updateMp(current_mp_float,max_mp_float)
    local rate = math.min(current_mp_float / max_mp_float,1)
    self.player_mp:setScaleX(rate);
    -- self.player_mp_v:setText(current_mp_float.."/"..max_mp_float)
    
    local player = EntityManager:get_player_avatar();

    if player.level == 1 then
        return;
    end

    -- 取得系统设置，挂机设置里面的值
    -- 蓝少于多少百分比吃药
    local use_mp_bottle_rate = SetSystemModel:get_date_value_by_key( SetSystemModel.ASSIST_MP_ITEM )/100;

    -- 蓝少于use_mp_bottle_rate自动加蓝,玩家的hp不能为0
    if ( player.hp ~= 0 and current_mp_float / max_mp_float <= use_mp_bottle_rate and player.is_use_magic_bottle == false) then 
        
        -- 如果蓝包里面有蓝就使用蓝包
        if ( player.mpStore > 0 ) then
            ItemCC:req_use_hp_store(2);
        else
            local magic_bottle_series = ItemModel:get_bag_exist_magic_bottle();
            if ( magic_bottle_series ) then
                ItemModel:use_a_item( magic_bottle_series,0 )
            else
                -- 如果没有蓝瓶的话
                -- 取得系统设置,挂机设置里面的 -- /** 红蓝药耗尽停止打怪 （生命补给或法力补给耗尽停止打怪） **/
                local is_stop_guaji  = SetSystemModel:get_date_value_by_key( SetSystemModel.STOP_AUTO_FIGHTING );
                if ( is_stop_guaji ) then
                    -- 停止挂机
                    AIManager:set_state( AIConfig.COMMAND_IDLE )
                end
                -- 弹出提示框
                if ( not _is_next_show_mp ) then
                    local function swith_but_func( is_next_show )
                        _is_next_show_mp = is_next_show
                    end
                    local function goto_qianqian_func(  )
                        GlobalFunc:ask_npc( SceneConfig.scenceid.MU_YE_CUN, LangGameString[1468] ) -- [1468]="芊芊"
                    end
                    local function open_shop_win(  )
                        UIManager:show_window( "shop_win" )
                        ShopWin:change_page( "drug" )
                    end
                    local function mini_but_func(  )
                        if VIPModel:is_vip_lv3() then 
                            ConfirmWin2:show( 1, 4, LangGameString[1470], open_shop_win, swith_but_func ) -- [1470]="背包中没有药品，不能自动加法力，您可以:返回天元城找#cffff00芊芊#cffffff购买药品。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
                        else
                            ConfirmWin2:show( 1, 1, LangGameString[1470], goto_qianqian_func, swith_but_func ) -- [1470]="背包中没有药品，不能自动加法力，您可以:返回天元城找#cffff00芊芊#cffffff购买药品。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
                        end
                    end 
                    MiniBtnWin:show( 11 , mini_but_func ,nil )
                end
                return;
            end
        end 
        -- 开始计算cd
        player.is_use_magic_bottle = true;
        local function dismiss( dt )
            player.is_use_magic_bottle = false;
        end

        self.use_magic_bottle_cb:start( player.use_magic_bottle_cd, dismiss )
    end
end

-- 更新宠物血条
function UserPanel:updatePetHp(current_hp_float,max_hp_float)
    local pet_hp_height = 41;
    local pet_hp_width = 59;
    local result_height = pet_hp_height * math.min(current_hp_float / max_hp_float,1);
    -- 宠物血条
    self.pet_hp_view.view:setTextureRect(CCRectMake(0,pet_hp_height-result_height,pet_hp_width,result_height));
    local pet = EntityManager:get_player_pet();

    if ( pet == nil ) then
        return;
    end
    -- 取得系统设置，挂机设置里面的值
    -- 宠物生命少于多少百分比吃药
    local use_hp_bottle_rate = SetSystemModel:get_date_value_by_key( SetSystemModel.ASSIST_HP_ITEM_PET )/100;

    -- 回血
    if ( current_hp_float / max_hp_float < use_hp_bottle_rate and pet.is_use_pet_food == false) then 
        -- 取得当前出战宠物的数据
        local pet_info = PetModel:get_current_pet_info();
        -- 如果血包里面有血就使用血包
        if ( pet_info.tab_attr[8] > 0 ) then
             PetCC:req_use_pet_hp_bottle( PetModel:get_current_pet_id() );
        else
            local pet_food_series = ItemModel:get_bag_exist_pet_food();
            -- 宠物喂食
            if ( pet_food_series ) then
                PetCC:req_add_live_play_feed( PetModel:get_current_pet_id(),3 )
            else
                -- 如果没有宠物粮就直接return
                if ( not _is_next_show_pet_hp ) then
                    local function swith_but_func( is_next_show )
                        _is_next_show_pet_hp = is_next_show
                    end
                    local function goto_qianqian_func(  )
                        GlobalFunc:ask_npc( SceneConfig.scenceid.MU_YE_CUN, LangGameString[1468] ) -- [1468]="静音"
                    end
                    local function open_shop_win(  )
                        UIManager:show_window( "shop_win" )
                        ShopWin:change_page( "pet" )
                    end
                    local function mini_but_func(  )
                        if VIPModel:is_vip_lv3() then 
                            ConfirmWin2:show( 1, 4, LangGameString[1471], open_shop_win, swith_but_func ) -- [1471]="背包已没有药品，宠物不能自动加血，您可以:返回天元城找#cffff00芊芊#cffffff购买药品。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
                        else
                            ConfirmWin2:show( 1, 1, LangGameString[1471], goto_qianqian_func, swith_but_func ) -- [1471]="背包已没有药品，宠物不能自动加血，您可以:返回天元城找#cffff00芊芊#cffffff购买药品。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
                        end
                    end 
                    MiniBtnWin:show( 11 , mini_but_func ,nil )
                end
                return;
            end
        end 
        -- 开始计算cd
        pet.is_use_pet_food = true;
        local function dismiss( dt )
            pet.is_use_pet_food = false;
        end
        self.pet_use_pet_food_cb:cancel();
        self.pet_use_pet_food_cb:start(pet.use_pet_food_cd,dismiss)
    end

end

-- 更新宠物蓝条
function UserPanel:updatePetMp(current_mp_float,max_mp_float)

end

function UserPanel:update(type,tab_arg)
    if ( type == 1 ) then
        self.miniTaskPanel:do_tab_button_method(1);
    elseif ( type == 2 ) then
        self:create_user_panel();
    elseif ( type == 3 ) then
        self:update_pet(1);
    -- 更新任务进度
    elseif ( type == 4 ) then
        self:update_task_process(tab_arg);
    -- 更新主角血量
    elseif ( type == 5 ) then
        self:updateHp(tab_arg[1],tab_arg[2],tab_arg[3]);
    -- 快捷任务栏更新队伍
    elseif ( type == 6 ) then 
        self.miniTaskPanel:do_tab_button_method(3)
    -- 更新队长标志
    elseif ( type == 7 ) then 
        self.miniTaskPanel:update_leader( tab_arg[1] )
    -- 更新蓝
    elseif ( type == 8 ) then
        self:updateMp(tab_arg[1],tab_arg[2]);
    -- 更新pk模式
    elseif ( type == 9) then
        self.pk_mode_value = tab_arg[1];
        self.pk_mode:show_frame( self.pk_mode_value + 1 );
    end
end

function UserPanel:update_task_process(tab_arg)
    self.miniTaskPanel:update(2);
end

-- 用户升级需要更新的数据
function UserPanel:update_lv_up()
    local player = EntityManager:get_player_avatar();
    -- 需要更新等级，最大生命值，最大蓝值
    self.player_lv:setText(tostring(player.level));
    -- 更新血
    self:updateHp( player.hp , player.maxHp ,0);
    -- 更新蓝
    self:updateMp( player.mp , player.maxMp ,0);
    if ( player.level == 25 ) then
        self.pk_mode:setIsVisible(true);
    elseif ( player.level == 18 ) then
        local win = UIManager:find_visible_window("menus_panel");
        if win then
            win:set_yp_and_xq_btn_visible(true);
        end
    end

end

-- 当玩家创建好以后创建主角面板
function UserPanel:create_user_panel()
    -- 1 头像，2职业，3等级，4角色名，5人物血条，6人物血条值,7人物蓝条，8人物蓝条值，9，宠物头像，10，宠物等级，11宠物名
    -- 12 宠物血条，13宠物血条值，14宠物蓝条，15宠物蓝条值 
    local player = EntityManager:get_player_avatar(  );
    -- 防止重复创建
    if ( self.spr_bg ) then
        self.spr_bg:removeFromParentAndCleanup(true);
        self.spr_bg = nil;
    end

    self:createRolePanel(player)
end

function UserPanel:update_fight_value( value )

    self.fight_value:set_number(value)
end

-- 更新整个宠物面板 type 1,全部,2血量,3快乐度,4等级,5名字
function UserPanel:update_pet( type ,param )
    local pet_info = PetModel:get_current_pet_info(  );
    if ( pet_info ) then
        
        if ( type == 1) then 
            -- --print( "UserPanel:update_pet" )
            local pet_path = PetConfig:get_pet_head( pet_info );
            self.pet_head.view:setTexture("");
            self.pet_head.view:setTexture(pet_path);
            self.pet_head.view:addTexWithFile(CLICK_STATE_DOWN,pet_path);
            self.pet_head.view:addTexWithFile(CLICK_STATE_UP,pet_path);
            -- 宠物等级数值
            -- self.pet_lv:setText(tostring(pet_info.tab_attr[6]));

            self:updatePetHp( pet_info.tab_attr[3] , pet_info.tab_attr[17] );
            self:updatePetMp( pet_info.tab_attr[5] , 100 );
            self.spr_pet_bg:setIsVisible(true);
        elseif ( type == 2 ) then
            self:updatePetHp( param[1] , param[2] );
        elseif ( type == 3 ) then
            self:updatePetMp( param[1] , param[2] );
        elseif ( type == 4 ) then
            -- self.pet_lv:setText( tostring(param[1]) );
        elseif ( type == 5 ) then
            --tab_update_view[11]:setText( param[1] );
        end

    end
end

-- 根据战斗类型取得对应的图片路径
function UserPanel:get_img_path_by_fight_type( fight_type )
    return UIResourcePath.FileLocate.lh_main .. "m_fight_type"..( fight_type-1 )..".png";
end

-- 更新宠物出战或休息状态
function UserPanel:update_pet_fight_state( is_fight )
    local pet_info = PetModel:get_current_pet_info(  );

    if ( pet_info ) then
         -- 更新宠物战斗类型
        if ( self.pet_fight_type ) then
            self.pet_fight_type.view:removeFromParentAndCleanup(true);
        end

        if ( is_fight ) then
            local path = UserPanel:get_img_path_by_fight_type( pet_info.tab_attr[7] );
            self.pet_fight_type = ZCCSprite:create( self.pet_head,path,0,0 );
        else
            self:updatePetHp( 0 , pet_info.tab_attr[17] );
            local path = UserPanel:get_img_path_by_fight_type( 4 );
            self.pet_fight_type = ZCCSprite:create( self.pet_head,path,0,0 );
        end
    end
end

function UserPanel:delete_pet(  )
    self.spr_pet_bg:setIsVisible(false);
end

-- 更新出战宠物的战斗类型
function UserPanel:set_pet_fight_type( fight_type )
   -- --print("fight_type=====================",fight_type);
    if ( self.pet_fight_type ) then
        self.pet_fight_type.view:removeFromParentAndCleanup(true);
    end
    local path = UserPanel:get_img_path_by_fight_type( fight_type );
    self.pet_fight_type = ZCCSprite:create( self.pet_head,path,0,0);
end

function UserPanel:update_other_entity(entity_info)
    -- print("entity_info.type = ",entity_info.type);
    -- print("entity_info.name = ",entity_info.name);
    self:set_select_entity_panel_visible(true);
    --     [-2] = "PlayerPet",             -- 玩家的宠物
    -- [-1] = "PlayerAvatar",          -- 主玩家
    -- [0] = "Avatar",                 -- 玩家
    -- "Monster",                      -- 怪物
    -- "NPC",                          -- npc
    -- "MovingNPC",                    -- 巡逻的npc
    -- "Pet",                          -- 宠物
    -- -- 非生物
    -- "Totem",                        -- 图腾
    -- "Mine",                         -- 矿物，采集对象
    -- "Defender",                     -- 防御措施
    -- "Plant",                        -- 植物，采集对象
    -- -- 特效类
    -- "Teleport",                     -- 传送门
    -- "Building",                     -- 建筑
    -- "Effect",                       -- 特效
    -- -- 其他
    -- "Collectable",                  -- 采集怪
    -- "DisplayMonster",               -- 显示怪，如炸药包
    local head_path = nil;
    local curr_hp = 0;
    local max_hp = 0;
    local curr_mp = 0;
    local max_mp = 0;
    local level = 99;
    local name = "";
    local curr_hp = 0;
    --print("entity_info.face",entity_info.face);
    if ( entity_info == nil ) then

    else
        curr_hp = entity_info.hp or 1;
        curr_mp = entity_info.mp or 1;
        max_mp = entity_info.maxMp or 1;
        if ( entity_info.level and entity_info.level ~= 0 ) then 
            level = entity_info.level;
        end
        name = entity_info.name
        realname = entity_info.name
            -- 0 其他玩家
        if ( entity_info.type == 0 or  entity_info.type == -1 ) then
            head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..entity_info.job..entity_info.sex..".png";
            max_hp = entity_info.maxHp or 1;
            self.select_entity_head:setPosition(44, 43)
            self.select_entity_head.view:setScale(0.9)
        -- -2 玩家宠物 怪物或宠物
        elseif ( entity_info.type == -2 or  entity_info.type ==1 or  entity_info.type ==4 or entity_info.type == 6
            or entity_info.type == 8 or entity_info.type == 12 ) then
            local body_id = entity_info.body;
            -- 宠物body_id要取低位
            if ( entity_info.type ~= 1 ) then
                body_id   = ZXLuaUtils:lowByte( entity_info.body );
            end
            max_hp = entity_info.maxHp or 1;
            head_path = string.format("icon/moster/%05d.pd", body_id);
            --head_path = string.format("icon/moster/%05d.png", body_id);
            self.select_entity_head:setPosition(45, 43)
            self.select_entity_head.view:setScale(1.0)
        -- 3 npc或移动的npc
        elseif ( entity_info.type == 2 or  entity_info.type ==3) then
            max_hp = 1;
            require "../data/npc"
            local tab_npc_info = npc_config[entity_info.face];
            head_path = string.format( "icon/npc/%s",tab_npc_info[1] );
            name = Utils:parseNPCName(name)
            self.select_entity_head:setPosition(45, 43)
            self.select_entity_head.view:setScale(1.0)
        end
    end

    if ( head_path ) then
        -- 选中实体的头像
        self.select_entity_head.view:setFlipX(false);
        self.select_entity_head:setTexture("")
        self.select_entity_head:setTexture(head_path)
        self.select_entity_head.view:setFlipX(true);
    else
        self.select_entity_head:setTexture("")
    end

    -- 选中实体等级
    self.select_entity_lv:setText(tostring(level));

    -- QQVipInterface:reinit_info( self.select_entity_name, entity_info.QQVIP, name)
    self.select_entity_name:setText(name)
    -- 更新血和蓝
    self.select_entity_hp:set_hp( curr_hp,max_hp );
    if max_hp < curr_hp then
        max_hp = curr_hp
    end
    -- self.entity_hp_v:setText(curr_hp.."/"..max_hp)
    if curr_mp > max_mp then max_mp = curr_mp end
    self.select_entity_mp:setScaleX(curr_mp/max_mp)
    -- 记录当前选中的
    self.target_entity = entity_info;

    -- self.other_buff_view:is_need_clear( self.target_entity.handle );
end

function UserPanel:update_other_entity_hp_and_mp( dhp,hp,max_hp)
   -- --print("UserPanel:688:更新选中实体的hp...................");
    self.select_entity_hp:update_hp( dhp,hp,max_hp )
    -- self.entity_hp_v:setText(hp.."/"..max_hp)

end

-- 设置私聊按钮隐藏
function UserPanel:set_whisper_btn_visible(is_visible)
    local win = UIManager:find_window("user_panel")
    if win then
        win.private_chat_btn.view:setIsVisible(is_visible);
    end
end

function UserPanel:get_whisper_btn_visible()
    local win = UIManager:find_window("user_panel")
    if win then
        return win.private_chat_btn.view:getIsVisible();
    end
end

function UserPanel:set_whisper_btn_timer(rate)
    local win = UIManager:find_window("user_panel")
    if win then
        return win.private_chat_btn:setTimer(rate);
    end
end

-- 设置提示字体显示隐藏 type 1:自动杀怪中2:自动寻路中3:自动跟随中4:隐藏掉所有
function UserPanel:set_title_visible(is_visible,_type)
    print('set_title_visible', is_visible,_type)
    local win = UIManager:find_visible_window("user_panel");
    -- if ( win ) then
    --     if ( _type == 1 ) then
    --         _autoActionEnable(win.auto_kill_monster,is_visible);
    --         if ( is_visible == true ) then
    --             --隐藏自动寻路和跟随
    --             _autoActionEnable(win.auto_move,false);
    --             _autoActionEnable(win.auto_follow,false);
    --         end
    --     elseif ( _type == 2 ) then
    --         _autoActionEnable(win.auto_move,is_visible);
    --         if ( is_visible == true ) then
    --             --隐藏自动杀怪和跟随
    --             _autoActionEnable(win.auto_kill_monster,false);
    --             _autoActionEnable(win.auto_follow,false);
    --         end
    --     elseif ( _type == 3 ) then
    --         _autoActionEnable(win.auto_follow,is_visible);
    --         if ( is_visible == true ) then
    --             --隐藏自动杀怪和自动寻路
    --             _autoActionEnable(win.auto_kill_monster,false);
    --             _autoActionEnable(win.auto_move,false);
    --         end
    --     elseif ( _type == 4 ) then
    --         _autoActionEnable(win.auto_follow,false);
    --         _autoActionEnable(win.auto_kill_monster,false);
    --         _autoActionEnable(win.auto_move,false);
    --     end
    -- end

    for i=1,3 do
        for j=1,5 do
            win.auto_text[i][j]:setIsVisible(false)
        end
    end

    for i=1,2 do
        win.fight_img[i]:setIsVisible(false)
        win.foot_img[i]:setIsVisible(false)
    end

    if ( win ) then
        if ( _type == 1 ) then
            win.auto_kill_monster:setIsVisible(is_visible);
            if ( is_visible == true ) then
                win.auto_move:setIsVisible(false);
                win.auto_follow:setIsVisible(false);

                win.auto_count = 1
                win.auto_text[1][1]:setIsVisible(true)
                win.img_state = true
                win.fight_img[1]:setIsVisible(true)
                win.auto_text_timer:stop();
                win.auto_text_timer:start(0.5, function(t) win:auto_text_animation(t, 1); end)
            end
        elseif ( _type == 2 ) then
            win.auto_move:setIsVisible(is_visible);
            if ( is_visible == true ) then
                win.auto_kill_monster:setIsVisible(false);
                win.auto_follow:setIsVisible(false);

                win.auto_count = 1
                win.auto_text[2][1]:setIsVisible(true)
                win.img_state = true
                win.foot_img[1]:setIsVisible(true)
                win.auto_text_timer:stop();
                win.auto_text_timer:start(0.5, function(t) win:auto_text_animation(t, 2); end)
            end
        elseif ( _type == 3 ) then
            win.auto_follow:setIsVisible(is_visible);
            if ( is_visible == true ) then
                win.auto_kill_monster:setIsVisible(false);
                win.auto_move:setIsVisible(false);

                win.auto_count = 1
                win.auto_text[3][1]:setIsVisible(true)
                win.img_state = true
                win.foot_img[1]:setIsVisible(true)
                win.auto_text_timer:stop();
                win.auto_text_timer:start(0.5, function(t) win:auto_text_animation(t, 3); end)
            end
        elseif ( _type == 4 ) then
            win.auto_follow:setIsVisible(false);
            win.auto_kill_monster:setIsVisible(false);
            win.auto_move:setIsVisible(false);

            win.auto_text_timer:stop();
        end
    end
end

function UserPanel:auto_text_animation(t, index)
    self.auto_text[index][self.auto_count]:setIsVisible(false)
    self.auto_count = (self.auto_count)%5+1
    self.auto_text[index][self.auto_count]:setIsVisible(true)

    self.img_state = not self.img_state
    if index == 1 then
        self.fight_img[1]:setIsVisible(self.img_state)
        self.fight_img[2]:setIsVisible(not self.img_state)
    else
        self.foot_img[1]:setIsVisible(self.img_state)
        self.foot_img[2]:setIsVisible(not self.img_state)
    end
end

-- 设置队长标志显示隐藏
function UserPanel:set_team_leader_spr_visible(is_visible)
    if ( self.leader_spr ) then
        self.leader_spr.view:setIsVisible(is_visible);
    end
end

-- 退出队伍和清除队长图标和退出队长按钮
function UserPanel:on_exit_team( )
    self.leader_spr.view:setIsVisible(false);
    UIManager:hide_window("team_btns_panel");
end

function UserPanel:is_selected_entity( handle )
    local win = UIManager:find_visible_window("user_panel");
    if ( win ) then
        if ( win.target_entity) then
            if( win.target_entity.handle == handle ) then
                local player = EntityManager:get_player_avatar();
                player:set_target(nil);
                local pet = EntityManager:get_player_pet();
                if ( pet ) then 
                    pet:set_target(nil);
                end
                win.target_entity = nil;
            end
        end   
    end
end

-- 判断给定的实体是否是当前选中的实体
function UserPanel:check_is_select_entity( entity_handle )
    local win = UIManager:find_visible_window("user_panel");
    if ( win ) then
        if ( win.target_entity) then
--            --print("win.target_entity.handle,entity_handle",win.target_entity.handle,entity_handle)
            if( win.target_entity.handle == entity_handle ) then
                return true;
            end
        end   
    end
    return false;
end

-- type 1 主角添加buff 2 选中实体添加buff
function UserPanel:add_buff( type ,buff_struct )
    -- 主角添加buff
    if ( type == 1 ) then
        self.user_buff_view:add_buff( buff_struct )
        local user_buff_win = UIManager:find_window("user_buff_win");
        if ( user_buff_win ) then
            user_buff_win:add_buff(buff_struct)
        end
    -- 选中实体添加buff
    else
        -- self.other_buff_view:add_buff( buff_struct )
    end
end
-- type 1 主角添加buff 2 选中实体添加buff
function UserPanel:remove_buff( type,buff_type, buff_group )
   -- --print("UserPanel:remove_buff....................",type,buff_type)
    -- 主角删除buff
    if ( type == 1 ) then
        self.user_buff_view:delete_buff( buff_type, buff_group )
        local user_buff_win = UIManager:find_window("user_buff_win");
        if ( user_buff_win ) then
            user_buff_win:remove_buff( buff_type, buff_group  )
        end
    -- 选中实体删除buff
    else
        -- self.other_buff_view:delete_buff( buff_type, buff_group  )
    end
end

-- 设置选中实体面板显示隐藏
function UserPanel:set_select_entity_panel_visible(is_visible)
    self.select_entity_panel.view:setIsVisible(is_visible);
end

-- 指向快捷任务栏的主线任务
function UserPanel:xszy_main_quest(  )
    self.miniTaskPanel:xszy_main_quest( 5 )
end

-- 更新vip等级
function UserPanel:update_vip_level( level )
    ----print("update_vip_level---------------------level = ",level)
    if ( self.vip_lv ) then
        local bx = level == 10 and 14 or 20
        self.vip_lv:removeFromParentAndCleanup(true)
        self.vip_lv = MUtils:create_num_img(level, bx, 11, self.vip_btn.view, 4)
    end
end

local PET_FIGHT_CD = 20;
-- 宠物死亡后更新cd动画
function UserPanel:play_pet_cd_animation( pet_cd )
    --print("播放宠物死亡后的动画")
    PetModel:set_current_fight_pet_cd( pet_cd )
    local progressTo_action  = CCProgressTo:actionWithDuration(pet_cd, 0);
    local progressTimer = CCProgressTimer:progressWithFile("nopack/skill_cd.png");
    progressTimer:setScaleX(50/60);
    progressTimer:setScaleY(50/60);
    progressTimer:setPercentage(99);
    progressTimer:setType( kCCProgressTimerTypeRadialCCW );
    self.pet_head:addChild(progressTimer,5);
    progressTimer:setPosition(CCPointMake(28-5, 20+2));
    progressTimer:runAction( progressTo_action );

    -- 预防万一
    if ( self.progressTimer_callback ) then
        self.progressTimer_callback:cancel();
    end
    self.progressTimer_callback = callback:new()
    local function dismiss( dt )
        progressTimer:removeFromParentAndCleanup(true);
        -- 置空宠物出战cd
        PetModel:set_current_fight_pet_cd( 0 );
        --新增，宠物死亡后自动出战
        -- self:set_fight_fun()
    end
    self.progressTimer_callback:start(pet_cd,dismiss)
    if pet_cd == 20 then
        -- 弹个提示字
        GlobalFunc:create_screen_notic( "您的伙伴被杀死了，20秒后才能再次出战" ); -- [1472]="您的宠物被杀死了，20秒后才能再次出战"
    else
        GlobalFunc:create_screen_notic( "您的伙伴被恐吓了，8秒后才能再次出战" );
    end
end

function UserPanel:set_fight_fun()
    -- 如果不在灵泉仙浴中...
    if ( XianYuModel:get_status(  ) == false ) then 
        --
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local _pet_id =PetModel:get_current_pet_id()

            -- 默认是出战
            local do_type = 1;
            -- 如果当前选中的宠物是正在出战的宠物
            if(_pet_id == PetModel:get_current_pet_id() ) then
                   -- 如果当前出战的宠物 出战状态
                if( PetModel:get_current_pet_is_fight()) then
                    -- 出战宠物休息
                    do_type = 0
                else
                    -- 宠物是否在死亡cd中
                    if ( PetModel:get_current_fight_pet_cd(  ) ~= 0 ) then
                        GlobalFunc:create_screen_notic( LangGameString[1466] ); -- [1466]="您的宠物现在需要休息！"
                        return ;
                    end
                end
            end
            PetCC:req_fight( _pet_id,do_type );
        end
    else
        -- GlobalFunc:create_screen_notic( LangGameString[1467] ) -- [1467]="灵泉仙浴中宠物不能出战"
    end
end


-- 提示购买宠物拨浪鼓
function UserPanel:buy_bolanggu()
    -- 弹出提示字——》提示框
    if ( not _is_next_show_bolanggu ) then
        local function swith_but_func( is_next_show )
            _is_next_show_bolanggu = is_next_show
        end
        local function goto_qianqian_func(  )
            GlobalFunc:ask_npc( SceneConfig.scenceid.MU_YE_CUN, LangGameString[1468]  ) -- [1468]="芊芊"
        end
        local function open_shop_win(  )
            UIManager:show_window( "shop_win" )
            ShopWin:change_page( "pet" )
        end
        local function mini_but_func(  )
            if VIPModel:is_vip_lv3() then 
                ConfirmWin2:show( 1, 4, LangGameString[1473], open_shop_win, swith_but_func ) -- [1473]="背包中没有拨浪鼓了，不能提高宠物快乐度，您可以:返回天元城找#cffff00芊芊#cffffff购买拨浪鼓。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
            else
                ConfirmWin2:show( 1, 1, LangGameString[1473], goto_qianqian_func, swith_but_func ) -- [1473]="背包中没有拨浪鼓了，不能提高宠物快乐度，您可以:返回天元城找#cffff00芊芊#cffffff购买拨浪鼓。(#cffff00仙尊用户可以快捷打开商店#cffffff)"
            end
        end 
        MiniBtnWin:show( 11 , mini_but_func ,nil )
    end
end

function UserPanel:active( show )
    if ( show ) then
        self.miniTaskPanel:active(show);
    end
end

function UserPanel:destroy(  )
    --print("UserPanel:destroy-------------------------------")
    -- 销毁主角和选中实体的血条
    -- self.signal_icon = nil
    UIManager:removeMainUI(1)

    -- self.clock_timer:stop();
    -- self.clock_timer = nil;
    self.player_hp:destroy()
    self.select_entity_hp:destroy()
    -- 销毁快捷任务栏
    self.miniTaskPanel:destroy();
    self.miniTaskPanel = nil;

    Window.destroy(self);
    _is_next_show_hp = false;      -- 血瓶 不够时，是否提示
    _is_next_show_mp = false;      -- 蓝瓶 不够时，是否提示
    _is_next_show_pet_hp = false;      -- 宠物粮 不够时，是否提示
    _is_next_show_bolanggu = false;

    is_hide = false;
    self.player_name = nil

    self.auto_text_timer:stop()
    self.auto_text_timer = nil;
end


-- 更新主屏幕上角色的头像
function UserPanel:update_head( sex )
    local player = EntityManager:get_player_avatar();
    
    if player.job ~= nil then
        local path = UIResourcePath.FileLocate.normal.. "head/head"..player.job..sex..".png";
        -- 头像
        self.player_head.view:setTexture(path);
    end
end
-- 更新qqvip数据
function UserPanel:update_my_qqvip_info()
    if self.player_name ~= nil and self.player_name.view ~= nil then
        local player = EntityManager:get_player_avatar()
        QQVipInterface:reinit_info( self.player_name, player.QQVIP, player.name )
    end
end

function UserPanel:createRolePanel(player)


    local function btn_vip_fun(eventType,arg,msg_id)
        --print('>>>>>>>>>>>>>>>>>>>>>>>>>>')
        Analyze:parse_click_main_menu_info(114)
        UIManager:show_window("vipSys_win");
        -- UIManager:show_window("ward_robe_win");
    end


    local function fun(eventType,x,y )
        if ( eventType == TOUCH_CLICK ) then
            local win = UIManager:show_window("user_equip_win");
            -- win:change_page(3)
        end
        return true
    end

    local sz = self.view:getSize()
    local panel = CCBasePanel:panelWithFile( 10 ,(sz.height - 128 - 10), 240, 128, "" )

    head_bg = ZCCSprite:create(panel,UILH_MAIN.user_head_bg,135,70);
    head_bg.view:setTag(0)

    self.view:addChild(panel)

    --panel:registerScriptHandler(fun);

    -- 血条
    player_hp = HPBar( head_bg,"nopack/main/16.png","nopack/main/16.png",102,84,99,13,nil,1);
    -- player_hp = MUtils:create_zximg( head_bg,UILH_MAIN.m_user_red,103,82,-1,-1,500,500);
    -- 血条数值
    -- self.player_hp_v = ZLabel:create(player_hp,string.format('%d/%d',player.hp,player.maxHp),76,8,8,1);
    -- self.player_hp_v.view:setAnchorPoint(CCPointMake(0.5,0.5))
    -- 蓝条
    -- player_mp = ZCCSprite:create(spr_bg,MP_INFO[1],150,8);
    player_mp = MUtils:create_zximg(head_bg,UILH_MAIN.m_user_blue,102,75,-1,-1,500,500)
    player_mp:setAnchorPoint(0.0,0.5)
    player_mp:setTag(0)
    -- 蓝条数值
    -- self.player_mp_v = ZLabel:create(player_mp,"",54,2,12,1);

    self.head_bg = panel
    self.head_bg = head_bg
    self.player_hp = player_hp
    self.player_mp = player_mp

    -- local z = ZCCSprite:create(self.head_bg,UILH_MAIN.m_name_bg,150,97,-1)
    -- z.view:setTag(0)
    ZImage:create(self.head_bg,UILH_MAIN.m_fight,94,106 )

    --根据获取数字图片名称
    local function get_num_ima( one_num )
        
        return string.format("ui/lh_main/fight_%d.png",one_num);
    end
    self.fight_value = ImageNumberEx:create(player.fightValue,get_num_ima,13)
    self.head_bg:addChild(self.fight_value.view)

    self.fight_value.view:setPosition(CCPointMake(180,116))

    self.fight_value.view:setAnchorPoint(CCPointMake(0.0,0.0))

    local function btn_head_fun()
        Analyze:parse_click_main_menu_info(111)
        UIManager:toggle_window("user_equip_win")
        UIManager:show_window("fight_value_win")
    end
    local path = UIResourcePath.FileLocate.lh_normal .. "head/head"..player.job..player.sex..".png";
    -- 头像
    self.player_head = ZButton:create( panel,
                                       path,
                                       btn_head_fun,
                                       60, 90,
                                       80, 80);

    self.player_head:setAnchorPoint(0.5,0.5)


    -- local path = UIResourcePath.FileLocate.main .. "job/job"..player.job..".png";
    -- -- 职业
    -- self.player_job = ZImage:create(self.view,path,0,290,31,51);
    -- 等级bg背景和值
    local spr_lv_bg = ZCCSprite:create(panel,UILH_MAIN.m_lv_bg,13,120,9);
    self.player_lv = ZLabel:create(spr_lv_bg,tostring(player.level),18,12,FONT_SIZE,2);
    spr_lv_bg.view:setTag(0)

    -- 队长标志
    self.leader_spr = ZCCSprite:create(panel,UILH_OTHER.flag_captain,270,86,10)
    self.leader_spr.view:setIsVisible(false);
    self.leader_spr.view:setTag(0)

    -- vip按钮
    local vip_info = VIPModel:get_vip_info();
    local vip_level = 0 ;
    if ( vip_info ) then
        vip_level = vip_info.level;
    end

    self.vip_btn = ZButton:create(panel,UILH_MAIN.vip_bg,
                                  btn_vip_fun,226,81)
    vip_bg = ZCCSprite:create(self.vip_btn.view,UILH_MAIN.vip,24,38);
    vip_bg.view:setTag(0)
    self.vip_lv = MUtils:create_num_img(vip_level, 16, 11, self.vip_btn.view, 4)
    self.vip_btn.view:setAnchorPoint(0.5,0.5);

    -- 名字 
    -- self.player_name = QQVipInterface:create_qq_vip_info( player.QQVIP, player.name )
    -- self.player_name:setPosition( 60, 55 )
    -- self.spr_bg:addChild( self.player_name.view )

    self.player_hp:set_hp( player.hp,player.maxHp );
    -- 更新蓝条
    self:updateMp(player.mp,player.maxMp);

    -- 判断必杀技是否开启
    if ( GameSysModel:isSysEnabled( GameSysModel.UNIQUE_SKILL, false) ) then
        local win = UIManager:find_window("menus_panel");
        if ( win ) then
            -- 每次创建好主角后检查主角是否开启必杀技
            win:check_anger_btn_show()
            win:updateAngerBar(player.anger);
        end 
    end

    -- 判断角色等级是否大于25，如果大于25才可以改变战斗模式
    -- --print("player_lv",player.level);
    if ( player.level >= 25 ) then
        -- --print("玩家等级大于25，显示pk模式")
        self.pk_mode:setIsVisible( true );
    end 
    -- 主角Buff控件
    self.user_buff_view = BuffView(panel,110,20);

    -- self:update_other_entity(player)
end

function UserPanel:showLantencyState(b)
    -- if self.signal_icon then
    --     self.signal_icon.view:setIsVisible(b)
    -- end
end

--设置电池状态
function UserPanel:setLantencyState(l)

    if latency == l then
        return
    end
    
    -- if not self.signal_icon then
    --     return
    -- end
    
    local state = 4
    if l > 10000 then
        state = 0
    elseif l > 2000 then
        state = 1
    elseif l > 650 then
        state = 2
    elseif l > 350 then
        state = 3
    end
    
    if signal_state == state then
        return 
    end

    local signal = 
    {
        [0] = 'ui/main/signalNone.png',
        [1] = 'ui/main/signalVeryBad.png',
        [2] = 'ui/main/signalBad.png',
        [3] = 'ui/main/signalNormal.png',
        [4] = 'ui/main/signalGood.png',
    }

    -- if state == 0 then
    --     self.signal_icon.view:setTexture(signal[0]);
    -- elseif state == 1 then
    --     self.signal_icon.view:setTexture(signal[1]);
    -- elseif state == 2 then   
    --     self.signal_icon.view:setTexture(signal[2]);
    -- elseif state == 3 then
    --     self.signal_icon.view:setTexture(signal[3]);
    -- else
    --     self.signal_icon.view:setTexture(signal[4]);
    -- end

    latency = l
    signal_state = state

--   local s0 = CCScaleTo:actionWithDuration(0.2,1.25);
--   local s1 = CCScaleTo:actionWithDuration(0.25,1.0);
--   local array = CCArray:array();
--   array:addObject(s0);
--   array:addObject(s1);
--   local seq = CCSequence:actionsWithArray(array);
--   signal_icon:runAction( seq );

end

function UserPanel:_set_component(id,comp)
    self._instruction_components[id] = comp
end

function UserPanel:find_component(id)
    -- body
    return self.miniTaskPanel._instruction_components[id]
end