-- ZYCMWin.lua
-- create by hcl on 2013-2-21
-- modify by chj on 2014.11.12
-- 斩妖除魔(征伐令)窗口

super_class.ZYCMWin(NormalStyleWindow)

local exp_table = { }
-- local color_yellow = "#cfff000"
-- local color_gray = "#c929292"
local exp_str_t = {LangGameString[2436], LangGameString[2435], LangGameString[2434], LangGameString[2433], LangGameString[2432],}
local exp_color = { LH_COLOR[15], LH_COLOR[6], LH_COLOR[4], LH_COLOR[11], LH_COLOR[13]}

-- 是否提示一件满星
local yijianmanxing_alert = true
is_max_star_finished = false

-- 创建窗口
function ZYCMWin:__init( window_name, texture_name, is_grid, width, height )

    -- 背景图 -------------------------------------
    self.bgPanel = CCBasePanel:panelWithFile( 10, 10, 415, 555, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( self.bgPanel )

    -- 规则说明 -------------------------------------
    -- 背景框
    self.bg_01 = CCBasePanel:panelWithFile( 15, 14, 385, 145, UILH_COMMON.bottom_bg, 500, 500 )
    self.bgPanel:addChild(self.bg_01)
    --title
    self.rule_title_bg = CCBasePanel:panelWithFile( 28, 133, -1, -1, UILH_NORMAL.title_bg7 )
    self.bgPanel:addChild( self.rule_title_bg )
    -- ZLabel:create(self.rule_title_bg, Lang.zycm[1], 111, 17, 16)
    ZImage:create(self.rule_title_bg, UILH_OTHER.zycm_rule, 112, (44-22)*0.5, -1, -1)

    -- 5 条规则
    ZLabel:create(self.bgPanel, Lang.zycm[2], 20, 97, 14)
    ZLabel:create(self.bgPanel, Lang.zycm[3], 20, 69, 14)
    ZLabel:create(self.bgPanel, Lang.zycm[4], 20, 41, 14)
    -- ZLabel:create(self.bgPanel, LH_COLOR[2] .. Lang.zycm[5][1] .. LH_COLOR[1] .. Lang.zycm[5][2] .. LH_COLOR[2].. Lang.zycm[5][3] .. LH_COLOR[1] .. Lang.zycm[5][4] .. LH_COLOR[2] .. Lang.zycm[5][5], 20, 393, 14)
    -- ZLabel:create(self.bgPanel, LH_COLOR[2] .. Lang.zycm[6][1] .. LH_COLOR[1] .. Lang.zycm[6][2]  ..LH_COLOR[2].. Lang.zycm[6][3] , 20, 365, 14)


    -- 任务说明 ------------------------------------
    -- -- 背景框
    -- self.bg_02 = CCBasePanel:panelWithFile( 15, 213, 385, 120, UILH_COMMON.bottom_bg, 500, 500 )
    -- self.bgPanel:addChild(self.bg_02)
    -- title
    -- self.task_title_bg = CCBasePanel:panelWithFile( 28, 305, -1, -1, UILH_NORMAL.title_bg7 )
    -- self.bgPanel:addChild( self.task_title_bg )
    -- -- ZLabel:create( self.task_title_bg, Lang.zycm[7], 140, 17, 16 )
    -- ZImage:create(self.task_title_bg, UILH_OTHER.zycm_intro, 140, (44-22)*0.5, -1, -1)



    -- 星级title ----------------------------------
    -- 背景框
    self.bg_03 = CCBasePanel:panelWithFile( 15, 182, 385, 345, UILH_COMMON.bottom_bg, 500, 500 )
    self.bgPanel:addChild(self.bg_03)
    -- title
    self.star_title_bg = CCBasePanel:panelWithFile( 28, 500, -1, -1, UILH_NORMAL.title_bg7 )
    self.bgPanel:addChild( self.star_title_bg )
    ZImage:create(self.star_title_bg, UILH_OTHER.zycm_intro, 140, 12, -1, -1)
    -- ZLabel:create( self.star_title_bg, Lang.zycm[14], 97, 17, 16 )
    -- ZImage:create(self.view, UILH_OTHER.zycm_sl, 97, 475, -1, -1)


    self.starLayer = CCBasePanel:panelWithFile( 126, 468, 460, 30, "" )
    self.view:addChild(self.starLayer)
    self:drawStart(self.starLayer, 1, false)
    self.old_star_lv = 1


    ZLabel:create( self.bgPanel, Lang.zycm[8], 20, 434, 14 )
    self.target_content_zxf = ZLabel:create( self.bgPanel, Lang.zycm[9], 100, 434, 14 )
    ZLabel:create( self.bgPanel, Lang.zycm[10], 20, 402, 14 )
    self.left_task_count_zxf = ZLabel:create( self.bgPanel, Lang.zycm[11], 100, 402, 14 )
    ZLabel:create( self.bgPanel, Lang.zycm[12], 20, 370, 14 )
    self.quest_reward_zxf = ZLabel:create( self.bgPanel, Lang.zycm[13], 100, 370, 14 )

    -- =============================================================================================
    -- 添加九宫格底板


    -- 添加星级背景图
    -- local starBg = CCZXImage:imageWithFile( 31,323, -1, -1, UI_ZYCMWin_009, 500, 500 )
    -- self.view:addChild( starBg )

    -- 星星
    -- local star_bg = CCZXImage:imageWithFile(159, 536,150,-1,UI_ZYCMWin_023,500,500)
    -- self.view:addChild(star_bg)

    -- -- 当前级别选中框
    -- self.curr_level_frame = CCZXImage:imageWithFile(31, 325,392,-1,UI_ZYCMWin_029,500,500)
    -- self.view:addChild(self.curr_level_frame)

    -- if #exp_table == 0 then
    --     exp_table = RefreshQuestConfig:get_refresh_award_by_user_level( EntityManager:get_player_avatar().level,1)
    -- end
    
    self.level_panel_table={}

    -- 传送按钮
    local function btn_teleport_fun()
        Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        TaskModel:teleport_by_quest_id ( self.star_quest_id ,1);
        UIManager:hide_window("zycm_win");
        return true
    end
    --xiehande UI_ZYCMWin_002 ->UIPIC_COMMOM_004
    local chuansong_btn = ZButton:create( self.bgPanel, UILH_MAIN.foot, btn_teleport_fun, 290, 411,-1,-1)
    -- local chuansong_txt = CCZXLabel:labelWithText( 93/2, 53/2-6, LH_COLOR[2] .. Lang.zycm[15], 18, ALIGN_CENTER )
    -- chuansong_btn:addChild( chuansong_txt )

    -- -- 底下区背景图
    -- local down_panel_bg = CCZXImage:imageWithFile( 35, 25, 384, 173, UI_ZYCMWin_015, 500, 500 )
    -- self.view:addChild( down_panel_bg )

    -- 免费刷新次数
    -- [1948]="#cff49f4免费刷新次数:3/3"
    self.refresh_zxf    = MUtils:create_zxfont(self.bgPanel, Lang.zycm[16], 37, 336, 1, 14);

    ZLabel:create(self.bgPanel, Lang.zycm[5], 240, 336, 14)
    -- 背包剩余除魔令
    -- [1949]="#c66ff66背包剩余除魔令:99"
    self.bg_left_cml_zxf= MUtils:create_zxfont(self.bgPanel, Lang.zycm[17], 37, 261, 1, 14);
 
    -- 刷星
    local function shuaxing_fun()
        --print("self.star_quest_id = ",self.star_quest_id);
        Instruction:handleUIComponentClick(instruct_comps.ZHANYAO_REFRESH)
        if ( self.star_quest_id ) then
            local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
            if ( self.free_refresh_count > 0 or self.cml_count > 0) then
                MiscCC:req_refresh_quest_star(self.star_quest_type,0, money_type);
                -- if ( XSZYManager:get_state() == XSZYConfig.ZYCM_ZY and self.star_lv >= 3 ) then
                --     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
                --         -- 指向接受任务按钮 
                --     XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.ZYCM_ZY,2, XSZYConfig.OTHER_SELECT_TAG );
                -- end
            else
                self:create_dialog( false )
            end
        end
        return true
    end
    --UI_ZYCMWin_006 ->UIPIC_COMMOM_002
    -- ZButton:create( self.view, UILH_COMMON.btn4_nor, shuaxing_fun, 68, 91)
    self.refresh_star = ZTextButton:create(self.view, 
        LH_COLOR[2] .. Lang.zycm[18], UILH_COMMON.button6_4, 
        shuaxing_fun, 93, 293, -1, -1)
    --UI_ZYCMWin_020
    self.refresh_star:addImage( CLICK_STATE_DISABLE, UILH_COMMON.button4_dis )
    -- local shuaxing_txt = CCZXLabel:labelWithText( 126/2, 53/2-6, LH_COLOR[2] .. Lang.zycm[18], 16, ALIGN_CENTER )
    -- -- local eryuanbao    = CCZXLabel:labelWithText( 106, 93, "#cfff000(2元宝)", 16, ALIGN_LEFT )
    -- self.refresh_star:addChild( shuaxing_txt )
    -- self:addChild( eryuanbao )
    -- 一键满星
    local function yijianmanxing_fun()
        Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        self:create_dialog( true )
        return true
    end
    --xiehande   UI_ZYCMWin_007 ->UIPIC_COMMOM_002
    -- self.refresh_max_star = ZButton:create( self.view, UILH_COMMON.lh_button_4_r, yijianmanxing_fun, 238, 91);
    self.refresh_max_star = ZTextButton:create(self.view, 
        LH_COLOR[2] .. Lang.zycm[19], UILH_COMMON.button6_4, 
        yijianmanxing_fun, 268, 293, -1, -1)
    --UI_ZYCMWin_020
    self.refresh_max_star:addImage( CLICK_STATE_DISABLE, UILH_COMMON.button4_dis )
    -- local yjmx_txt = CCZXLabel:labelWithText( 126/2, 53/2-6, LH_COLOR[2] .. Lang.zycm[19], 16, ALIGN_CENTER )
    -- -- local syuanbao = CCZXLabel:labelWithText( 285, 93, "#cfff000(10元宝)", 16, ALIGN_LEFT )
    -- self.refresh_max_star:addChild( yjmx_txt )
    -- self:addChild( syuanbao )

 
    -- 完成任务按钮
    local function btn_receive_fun()
        Instruction:handleUIComponentClick(instruct_comps.ZHANYAO_GET_TASK)
        if ( self.star_quest_state == 0 ) then
            MiscCC:req_receive_quest( self.star_quest_type );
        elseif ( self.star_quest_state == 1 ) then
        -- 完成任务
            local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
            MiscCC:req_finish_quest_star( self.star_quest_type,0, money_type)
    -- if ( self.today_zycm_count == 1 ) then
    --     UIManager:hide_window("zycm_win");
    -- end
            UIManager:hide_window("zycm_win");
        elseif ( self.star_quest_state == 2 ) then
            if ( VIPModel:get_expe_vip_time() > 0 or VIPModel:get_vip_info().level >=3 ) then 
                -- if ( PlayerAvatar:check_is_enough_money( 4,2 ) ) then
                    -- 立即完成任务
                    self:create_quick_finish_quest_dialog(  )
                -- end
            else
                -- GlobalFunc:create_screen_notic( LangGameString[1458] ); -- [1458]="VIP3才能使用立即完成功能"
                MUtils:show_vip_dialog("#cfff000VIP3#cffffff才能使用#cfff000立即完成#cffffff功能")
            end
        end

        -- if ( XSZYManager:get_state() == XSZYConfig.ZYCM_ZY  ) then
        --     XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );       
        -- end
        return true
    end
    -- 立即完成
    -- self.complete_btn = ZButton:create( self.view, UILH_COMMON.btn4_nor, btn_receive_fun, 68, 38)
    self.complete_btn = ZTextButton:create(self.view, 
        "", UILH_NORMAL.special_btn, 
        btn_receive_fun, 53, 207, -1, -1, 1)
    -- self.liji_jieshou = ZBasePanel:create(self.complete_btn, UILH_OTHER.rec_task,  )
    self.liji_jieshou = CCBasePanel:panelWithFile((165-79)*0.5, 15, -1, -1, UILH_OTHER.rec_task )
    self.complete_btn.view:addChild(self.liji_jieshou)
    -- self.complete_btn:addImage( CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis )
    -- self.btn_text = ZLabel:create( self.complete_btn, LH_COLOR[2] .. Lang.zycm[20], 20, 20, 16 )

    -- 满星完成事件
    local function btn_allstart_complete()
        if ( VIPModel:get_expe_vip_time() > 0 or VIPModel:get_vip_info().level >=3 ) then 
            local cost_yuanbao = 12
            if EntityManager:get_player_avatar().yuanbao < cost_yuanbao then
                local function confirm2_func()
                    GlobalFunc:chong_zhi_enter_fun()
                end
                ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
            else
                local function req_max_star_finished()
                    MiscCC:req_finish_quest_full_star()
                    -- UIManager:hide_window("zycm_win");
                end

                local function switch_func( if_selected )
                    is_max_star_finished = if_selected
                end

                if is_max_star_finished == false then
                    local get_exp = exp_table[5]
                    local str = string.format( Lang.zycm[21],cost_yuanbao,get_exp )
                    ConfirmWin2:show( 1, nil, str, req_max_star_finished, switch_func)
                elseif is_max_star_finished == true then
                    req_max_star_finished()
                end
            end
        else
            MUtils:show_vip_dialog("#cfff000VIP3#cffffff才能使用#cfff000满星完成#cffffff功能")
        end
        return true
    end
    -- 满星完成
    -- self.complete_allstart_btn = ZButton:create( self.view, UILH_COMMON.lh_button_4_r, btn_allstart_complete, 238, 38)
    self.complete_allstart_btn = ZTextButton:create(self.view, 
        "", UILH_NORMAL.special_btn, 
        btn_allstart_complete, 235, 207, -1, -1)
    local comlete_lbl = CCBasePanel:panelWithFile((165-79)*0.5, 15, -1, -1, UILH_OTHER.full_start_finished )
    self.complete_allstart_btn:addChild( comlete_lbl )
    self.complete_allstart_btn:addImage( CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d )
    -- ZLabel:create( self.complete_allstart_btn, LH_COLOR[2] .. Lang.zycm[22], 20, 20, 16 )

end

-- 绘制星星
function ZYCMWin:drawStart(start_layer,start_count, show_effect)
    -- 清除所有星星
    start_layer:removeAllChildrenWithCleanup(true);
    for i=0,4 do
        local star = CCZXImage:imageWithFile(36*i,8,35,35, UILH_NORMAL.star)
        star:setTag(i);
        start_layer:addChild(star);
        if i>(start_count-1) then 
            star:setCurState(CLICK_STATE_DISABLE);
        end
    end

    if show_effect then
        start_layer:removeChildByTag(16,true);
        local ef1 = LuaEffectManager:play_view_effect( 16,0, 50, start_layer,false )
        if ef1 then
            ef1:setPosition(60,20)
        end
    end
end

function ZYCMWin:update_exp( star_lv )
    for i=#self.exp_t,1,-1 do
        -- self.exp_lv_t[i]:setText(string.format(s_t[i],color_gray))
        self.exp_t[i]:setText(string.format( Lang.zycm[23], LH_COLOR[2], exp_table[i]))
    end
    -- self.exp_lv_t[star_lv]:setText(string.format(s_t[star_lv], color_yellow))
    self.exp_t[star_lv]:setText(string.format(Lang.zycm[23], LH_COLOR[1], exp_table[star_lv]))
end

function ZYCMWin:update_str( star_lv,left_refresh_star_count )
    
    local target_str = TaskModel:get_task_str_by_task_id( self.star_quest_id ,1,true)
    -- print("self.star_quest_id = ",self.star_quest_id,"target_str = ",target_str)
    -- 任务目标
    self.target_content_zxf:setText(target_str)
    -- 保存任务字符串和杀怪数量 去南蛮荒击杀黄野狼(0/35)
    -- local sub_str_table =  Utils:Split(target_str, "(")
    -- self.quest_str = sub_str_table[1];
    -- self.quest_max_num = string.sub(sub_str_table[2],1,-2);
    local max_count = self:get_max_quest_num()
    -- 今日剩余次数
    self.left_task_count_zxf:setText( LH_COLOR[6] ..self.today_zycm_count.."/"..max_count)
    -- [1953]="#c66ff66今日次数:"
    -- [2459]="#cfff000(VIP等级越高,奖励越多)"
    -- 任务奖励
    local reward_str = exp_color[star_lv]..exp_table[star_lv].. Lang.zycm[25]
    self.quest_reward_zxf:setText(reward_str)

    -- 任务品质
    -- self.pinzhi_zxf:setText(LangGameString[708]..exp_table[star_lv]); -- [708]="经验:"
    -- self:update_exp(star_lv)
    -- print("------------", star_lv, self.old_star_lv)
    self:drawStart(self.starLayer, star_lv, (star_lv > self.old_star_lv))
    self.old_star_lv = star_lv
    -- 免费刷星次数
    self.refresh_zxf:setText( string.format(Lang.zycm[16], left_refresh_star_count)); -- [1954]="#cff49f4免费刷新次数:"
    self.cml_count = ItemModel:get_item_count_by_id( 18613 )
    -- 背包剩余除魔令数量
    self.bg_left_cml_zxf:setText( string.format(Lang.zycm[17], self.cml_count)); -- [1955]="#c66ff66背包剩余除魔令:"

    
    if self.star_quest_state == 0 then   -- 接取任务(未接)
        tex = UILH_OTHER.rec_task;
    elseif self.star_quest_state == 1 then -- (完成)
        tex = UILH_OTHER.finish_task; 
    elseif self.star_quest_state == 2 then  -- (立即完成)
        tex = UILH_OTHER.lijiwancheng;
    end

    -- self.complete_btn:setText( LH_COLOR[2] .. tex);
    self.liji_jieshou:setTexture(tex)
    -- 根据当前任务状态更新ui
    self:on_state_change( self.star_quest_state )
end

function ZYCMWin:set_zycm_count(zycm_count)
    self.today_zycm_count = zycm_count;
    --完成最后一个任务直接关闭界面
    if ( self.today_zycm_count == 0 ) then
        UIManager:hide_window("zycm_win"); 
    end
end

-- 只有接取任务成功的时候才会被调用到
function ZYCMWin:on_receive_quest()
    -- print("----------star_quest_state", self.star_quest_state)
    -- 任务状态为已接
    self.star_quest_state = 2;
    -- 任务刷星类型为:斩妖除魔(不知道为何要这个字段,斩妖除魔窗口的任务刷星类型自然是斩妖除魔了)
    self.star_quest_type  = 1;
    -- 切换任务状态按钮(接取任务?立即完成?完成任务?)
    self:change_complete_btn_text( 2 );
    local max_count = self:get_max_quest_num();
    -- 今日剩余次数 [1953]="#c66ff66今日次数:"
    self.left_task_count_zxf:setText( LH_COLOR[15] .. self.today_zycm_count.."/"..max_count)
    -- 当状态改变时，按钮的状态也要跟着改变
    self:on_state_change( self.star_quest_state ); 
    -- local win = UIManager:find_window("zycm_win");
    -- if ( win ) then
    --     -- win.star_quest_state = 2;
    --     -- win.btn_text:setTexture( UI_ZYCMWin_018 );

    --     win:change_complete_btn_text( star_quest_type );
    --     self.star_quest_type = star_quest_type;
    --     -- win.star_quest_id = star_quest_id;
    --     -- local target_str = TaskModel:get_task_str_by_task_id( win.star_quest_id ,1,true);
    --     -- -- 任务目标
    --     -- win.target_content_zxf:setText(target_str)
    --     -- 更新今日次数
    --     -- self.today_zycm_count = self.today_zycm_count - 1;
    --     -- --完成最后一个任务直接关闭界面
    --     -- if ( self.today_zycm_count == 0 ) then
    --     --     UIManager:hide_window("zycm_win"); 
    --     -- end
   
    --     local max_count = self:get_max_quest_num();
    --     -- 今日剩余次数
    --     win.left_task_count_zxf:setText(LangGameString[1953]..self.today_zycm_count.."/"..max_count); -- [1953]="#c66ff66今日次数:"
    --     -- 当状态改变时，按钮的状态也要跟着改变
    --     win:on_state_change( win.star_quest_state );    
    -- end
end

function ZYCMWin:on_state_change( state )
    -- print("--state:", state)
    if ( state ~= 0 or  self.star_lv >= 5) then
        self.refresh_star:setCurState( CLICK_STATE_DISABLE )
        self.refresh_max_star:setCurState( CLICK_STATE_DISABLE )
        self.complete_allstart_btn:setCurState(CLICK_STATE_DISABLE)
    else
        self.refresh_star:setCurState( CLICK_STATE_UP )
        self.refresh_max_star:setCurState( CLICK_STATE_UP )
        self.complete_allstart_btn:setCurState(CLICK_STATE_UP)
    end
end


-- 1npc名字,2刷星任务类型(1,斩妖除魔,2护送仙女)，3刷星任务适用等级段，4当前刷星任务星级，5被抽选到的任务id，6任务状态(0,未接,2已接,1,完成)，7任务剩余次数,8剩余免费刷星次数
--
--

function ZYCMWin:show(param)
    local str_table = Utils:Split(param, ",") 
    self.today_zycm_count = tonumber(str_table[7]);

    if ( self.today_zycm_count > 0 ) then 
        local win = UIManager:show_window("zycm_win");
        if ( win ) then
            win.star_quest_type = tonumber(str_table[2]);
            win.star_quest_state = tonumber(str_table[6]);
           -- print("star_quest_state=" ,win.star_quest_state )
            win.star_quest_id = tonumber( str_table[5] );
            win.star_lv = tonumber(str_table[4]);
            win.free_refresh_count = tonumber(str_table[8]);
            win:update_str(   tonumber(str_table[4]) ,str_table[8] )
        end
        SecretaryModel:set_zycm_count( self.today_zycm_count ) 
    end
  
end
-- star_quest_type,刷星任务类型 1
--level, 等级段
--star_lv, 星级
--quest_id,任务id
--left_refresh_star_count,剩余免费刷星次数
function ZYCMWin:on_refresh_quest_star( star_quest_type,level,star_lv,quest_id,left_refresh_star_count )
    local win = UIManager:find_visible_window("zycm_win");
    if ( win ) then
        -- print("star_quest_type,level,star_lv,quest_id,left_refresh_star_count",star_quest_type,level,star_lv,quest_id,left_refresh_star_count)
        win.star_quest_type = star_quest_type;
        win.star_quest_id = quest_id;
        win.star_lv = star_lv;
        win.free_refresh_count = tonumber(left_refresh_star_count);
        win:update_str(  star_lv  ,left_refresh_star_count )
    end  
end

--
function ZYCMWin:active( show )
    if ( show ) then
        -- if ( XSZYManager:get_state() == XSZYConfig.ZYCM_ZY ) then
        --     -- 指向刷星按钮  63-6,480-326-51,50,27
        --     XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.ZYCM_ZY,1 , XSZYConfig.OTHER_SELECT_TAG );
        -- end
        exp_table = RefreshQuestConfig:get_refresh_award_by_user_level( EntityManager:get_player_avatar().level ,1)
    else
        -- if ( XSZYManager:get_state() == XSZYConfig.ZYCM_ZY ) then
        --     XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG )            
        -- end
    end
end

-- 更新任务进度
function ZYCMWin:update_quest_process( )
    local target_str = TaskModel:get_task_str_by_task_id( self.star_quest_id ,1,true);
    -- 任务目标
    self.target_content_zxf:setText(target_str)
    -- 判断是否完成
end

-- 取得最大任务次数
function ZYCMWin:get_max_quest_num()
    local vip_level = 0 ;
    if ( VIPModel:get_expe_vip_time() > 0 ) then
        vip_level = 3;
    else
        local vip_info = VIPModel:get_vip_info();
        if ( vip_info ) then
            vip_level = vip_info.level;
        end
    end
    return 20 + vip_level;
end

-- 添加一个参数，识别是否满星完成提示
function ZYCMWin:create_dialog( is_max_star, is_max_star_finished )

    local yuanbao = 2;
    local str = LangGameString[1921]; -- [1921]="元宝#c66ff66刷星"
    if ( is_max_star ) then
        yuanbao = 10;
        str = LangGameString[1922]; -- [1922]="元宝#c66ff66满星"
        -- if ( PlayerAvatar:check_is_enough_money(4,10) == false ) then
        --     return;
        -- end
    else
        -- print("self.free_refresh_count",self.free_refresh_count,"self.cml_count",self.cml_count);
        if ( self.free_refresh_count == 0 and self.cml_count == 0 ) then
            -- if ( PlayerAvatar:check_is_enough_money(4,2) == false ) then
            --     return;
            -- end
            yuanbao = 2
        end
    end

    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local param = {self.star_quest_type, (is_max_star and 1 or 0), money_type}
    local function quest_star( param )
        MiscCC:req_refresh_quest_star(param[1], param[2], param[3]);
    end

    local function cb_fun()
        -- if ( is_max_star ) then
        --     MiscCC:req_refresh_quest_star(self.star_quest_type,1 );
        -- else
        --     MiscCC:req_refresh_quest_star(self.star_quest_type,0 );
        -- end
        MallModel:handle_auto_buy( yuanbao, quest_star, param )
    end
    str = LangGameString[876]..yuanbao..str; -- [876]="#c66ff66是否消费#cfff000"
    SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_QUEST_REFRESH_STAR ,cb_fun,str )
end

-- 
function ZYCMWin:create_quick_finish_quest_dialog(  )
    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local price = 2
    local param = {self.star_quest_type, 1, money_type}
    local function quest_star( param )
        MiscCC:req_finish_quest_star(param[1], param[2], param[3]);
    end
    -- if ( PlayerAvatar:check_is_enough_money(4,2) ) then
        local function cb_fun()
            -- MiscCC:req_finish_quest_star( self.star_quest_type,1 )
            MallModel:handle_auto_buy( price, quest_star, param )
            UIManager:hide_window("zycm_win");
        end
        SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_QUEST_QUICK_FINISH ,cb_fun, Lang.zycm[31] ) -- [1956]="#c66ff66是否消费2元宝立即完成任务?"
    -- end
end

function ZYCMWin:create_max_star_finished_dialog(  )
    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local price = 2
    local param = {self.star_quest_type, 1, money_type}
    local function quest_star( param )
        MiscCC:req_finish_quest_star(param[1], param[2], param[3]);
    end
    -- if ( PlayerAvatar:check_is_enough_money(4,2) ) then
        local function cb_fun()
            -- MiscCC:req_finish_quest_star( self.star_quest_type,1 )
            MallModel:handle_auto_buy( price, quest_star, param )
            UIManager:hide_window("zycm_win");
        end
        SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_QUEST_QUICK_FINISH ,cb_fun, Lang.zycm[31] ) -- [1956]="#c66ff66是否消费2元宝立即完成任务?"
    -- end
end

function ZYCMWin:change_complete_btn_text( quest_state )

    if quest_state == 0 then
        -- self.complete_btn:setText( LH_COLOR[2] .. Lang.zycm[28] )
        self.liji_jieshou:setTexture(UILH_OTHER.rec_task)
    elseif quest_state == 1 then
        -- self.complete_btn:setText( LH_COLOR[2] .. Lang.zycm[29] )
        self.liji_jieshou:setTexture(UILH_OTHER.finish_task)
    elseif quest_state == 2 then
        -- self.complete_btn:setText( LH_COLOR[2] .. Lang.zycm[30] )
        self.liji_jieshou:setTexture(UILH_OTHER.lijiwancheng)
    end
    
end

function ZYCMWin:destroy()
    -- for i=1,5 do
    --     if self.level_panel_table[i].expEffect then
    --         self.level_panel_table[i].expEffect:destroy()
    --     end 
    -- end
    Window.destroy(self)
end

function testZYCWin(v1,v2)
    local self = UIManager:find_window('zycm_win')
    self.expEffect:start(v1,v2)
end