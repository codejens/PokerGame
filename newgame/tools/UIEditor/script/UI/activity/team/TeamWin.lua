-- filename: TeamWin.lua
-- function: 该文件用于显示便捷组队界面
super_class.TeamWin(NormalStyleWindow);

-- 副本类型 1 2 3 聚贤令副本 4 深海之恋
function TeamWin:show(num_fuben , ex_params, is_active_zero )
    
    local win = UIManager:show_window("team_win");
    win.selected_team_id = 0 

    win.cur_page = 1; --当前页数

    win.selected_captain_name = "" --当前选中队长

    TeamActivityCC:req_get_recruit_info(1,1) 
    win.num_fuben = num_fuben
    win.ex_params = ex_params or {}                      -- 附加参数 
end

function TeamWin:active(show)
    if show then

    else

    end
end

function TeamWin:__init( window_name, window_info )
	local bgPanel = self.view
    self.row_t   = {}                  -- 存储每一行的对象， 用来修改每行数据

    -- 记录当前选中的队伍索引
    self.select_team_index = 1;
    -- 保存所有队伍按钮
    self.team_btn_tab = {};
    -- 当前选中队伍ID
    self.selected_team_id = 0 

    self.cur_page = 1; --当前页数

    self.selected_captain_name= "" --当前选中队长


    self.base_panel = CCBasePanel:panelWithFile(4, 5, 890, 565,UILH_COMMON.normal_bg_v2,500,500);
    self.view:addChild(self.base_panel );

    self.left_panel = CCBasePanel:panelWithFile(12, 12, 280, 542,UILH_COMMON.bottom_bg,500,500);
    self.base_panel:addChild(self.left_panel);

    local left_title_bg = CCBasePanel:panelWithFile( 0, 504, 280, 35, UILH_NORMAL.title_bg4, 500, 500 )
    self.left_panel:addChild(left_title_bg)
    MUtils:create_zxfont(left_title_bg,Lang.team[1],280/2,11,2,15);

    -- 分割线
    local line = CCZXImage:imageWithFile( 3, 65, 273, 3, UILH_COMMON.split_line )
    self.left_panel:addChild(line)

    --队伍列表标题
    -- local pic = TeamActivityMode:get_zudui_title(  )
    -- self.duiwu_title = CCZXImage:imageWithFile(42, 13, -1, -1,pic)
    -- left_title_bg:addChild(self.duiwu_title)

    self.right_panel = CCBasePanel:panelWithFile(294, 12, 583, 542,UILH_COMMON.bottom_bg,500,500);
    self.base_panel:addChild(self.right_panel);

    local right_title_bg = CCBasePanel:panelWithFile(0, 504, 583, 35,UILH_NORMAL.title_bg4, 500, 500);
    self.right_panel:addChild(right_title_bg)
    MUtils:create_zxfont(right_title_bg,Lang.team[2],583/2,11,2,15);

    self:create_below_btn()
end

--创建底层按钮
function TeamWin:create_below_btn()

    local function make_btn_fun()
        local function make_btn_callback_fun(selected_state_table)
            local fuben_type = 0;
            for i=1,5 do
                if selected_state_table[i] == true then
                    fuben_type = i;
                    break;
                end
            end

            if fuben_type ~= 0 then
                --创建队伍
                self.recruit_timer:setText(10)
                self.make_team_btn:setCurState(CLICK_STATE_DISABLE)
                self.recruit_btn:setCurState(CLICK_STATE_DISABLE)
                
                TeamActivityMode:req_make_team( self.num_fuben, fuben_type )
                TeamActivityCC:req_get_recruit_info(self.num_fuben,1)
            end
        end
        CreateTeamDialog:show(make_btn_callback_fun)
    end

    local function release_recruit( )
        --发布招募
        self.recruit_timer:setText(10)
        self.make_team_btn:setCurState(CLICK_STATE_DISABLE)
        self.recruit_btn:setCurState(CLICK_STATE_DISABLE)

        TeamActivityCC:req_release_recruit(self.num_fuben)
        TeamActivityCC:req_get_recruit_info(self.num_fuben,1)

    end

    local function enter_btn_fun()
        -- 聚仙令请求进入副本
        -- self.enter_game_timer:setText(10)
        -- self.enter_game_btn:setCurState(CLICK_STATE_DISABLE)
        -- TeamActivityCC:req_enter_fuben(self.num_fuben)
        UIManager:show_window("activity_Win")
    end

    --申请入队
    local function apply_btn_fun()
        if self.selected_team_id ~= 0 and self.selected_team_id ~= nil then
            TeamActivityCC:req_apply_team(self.selected_team_id)
            TeamActivityCC:req_team_info(self.selected_team_id)
        end
    end
    local function dismiss_team_fun()
        --退出队伍
        self.recruit_timer:setString("")
        self.recruit_btn.view:setCurState(CLICK_STATE_UP)
        self.make_team_btn.view:setCurState(CLICK_STATE_UP)
        TeamCC:req_exit_team()
        TeamActivityCC:req_get_recruit_info(self.num_fuben,1) 
    end
    --刷新
    local function refresh()
         TeamActivityCC:req_get_recruit_info(self.num_fuben,1)
    end

    local function filter_fun()
        local function after_filter_callback_fun(selected_state_table)
            -- 先将筛选表记录到model层
            TeamActivityMode:set_team_display_filter(selected_state_table)
            -- 然后刷新window
            TeamActivityMode:update_win_with_filter()
        end
        TeamFilterDialog:show(after_filter_callback_fun)
    end

    -- Lang.team[3] = "创建队伍"
    self.make_team_btn = ZTextButton:create(self.base_panel,Lang.team[3],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},make_btn_fun, 20, 20, -1, -1)
    self.make_team_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    -- Lang.team[4] = "发布招募"
    self.recruit_btn = ZTextButton:create(self.base_panel,Lang.team[4],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},release_recruit, 20, 20, -1, -1)
    self.recruit_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)

    local function timer_callback()
        self.recruit_timer:setString("")
        self.recruit_btn.view:setCurState(CLICK_STATE_UP)
        self.make_team_btn.view:setCurState(CLICK_STATE_UP)
    end
    self.recruit_timer = TimerLabel:create_label(self.base_panel, 70, 70, 15, 0, "#cd5c241", timer_callback,nil,nil,nil,"")
    local time_tmp = TeamModel:get_recruit_time()
    if time_tmp > 0 then
        TeamModel:set_recruit_time(0)
        self.make_team_btn:setCurState(CLICK_STATE_DISABLE)
        self.recruit_btn:setCurState(CLICK_STATE_DISABLE)
        self.recruit_timer:setText(time_tmp)
    else
        self.recruit_timer:setString("")
    end
    -- [5] = "申请加入"
    self.apply_team_btn = ZTextButton:create(self.base_panel,Lang.team[5],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},apply_btn_fun, 161, 20, -1, -1)
    -- self.apply_team_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    -- [16] = "#cd0cda2退出队伍"
    self.btn_dismiss_team = ZTextButton:create(self.base_panel,Lang.team[16],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},dismiss_team_fun, 161, 20, -1, -1)
    -- self.btn_dismiss_team.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    -- [6] = "多人副本"
    self.enter_game_btn = ZTextButton:create(self.base_panel,Lang.team[6],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},enter_btn_fun, 525, 16, -1, -1)
    self.enter_game_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)

    -- local function call_back(  )
    --     self.enter_game_btn:setCurState(CLICK_STATE_UP)
    -- end 
    -- self.enter_game_timer = TimerLabel:create_label( self.base_panel, 510, 61, 15, 0, "#cd5c241",call_back,nil,nil,nil,"CD：");
    -- self.enter_game_timer:setString("")
    -- [7] = "刷新"
    self.refresh_btn = ZTextButton:create(self.base_panel,Lang.team[7],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},refresh, 725, 16, -1, -1)

    -- [28] = "队伍筛选",
    self.filter_btn = ZTextButton:create(self.base_panel,Lang.team[28],{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},filter_fun, 325, 16, -1, -1)

    -- 创建按钮时手动获取是否有队伍，更新队伍状态
    local team_id = TeamModel:get_team_id()
    self:update_btn(team_id)
end

--创建右边队伍列表
function TeamWin:create_right_team_view(team_info)
    local isCaptain = false --是否队长
    local name = EntityManager:get_player_avatar().name
    if self.selected_captain_name == name then
        isCaptain = true
    end
    if self.team_text then 
        self.team_text:setText("");
    end 

    self:clear_team_list(  )

    local team_count = team_info.count
    local _scroll_info = { x = 3 , y = 55 , width = 570, height = 453, maxnum = team_count, stype = TYPE_HORIZONTAL }
    self.right_scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    self.right_panel:addChild(self.right_scroll);

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
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local row = x +1             -- 行

            local tBg = CCBasePanel:panelWithFile(0,0,570,89,"", 600, 600);
            self:create_right_scroll_item(tBg,team_info[row],row,isCaptain )

            self.right_scroll:addItem(tBg);
            self.right_scroll:refresh();
            self:change_uptate_status( ); -- 更新准备状态

            return false
        end
    end
    self.right_scroll:registerScriptHandler(scrollfun);
    self.right_scroll:refresh()
    -----------------
end 

-- 创建一行队伍成员。 参数：坐标 宽高 背景图名称 该行的数据
function TeamWin:create_right_scroll_item( tBg,row_date,index ,isCaptain)
    local one_row = {}
    local player_btn_state = 0
   
    one_row.view = CCBasePanel:panelWithFile(0,0 ,570,90,"", 600, 600);
    tBg:addChild( one_row.view )

    local head_bg = CCZXImage:imageWithFile(3,5,82,82 ,UILH_NORMAL.item_bg3)
    one_row.view:addChild(head_bg)
    if row_date.job == 0 and row_date.sex == 0 then
        --队员掉线
    elseif row_date.job < 0 or row_date.job > 4 or row_date.sex < 0 or row_date.sex > 1 then
        -- 好像有时候会有异常数据下发，这里预防一下
        print("右侧队员数据职业和性别异常",row_date.job,row_date.sex)
    else
        --基本信息
        local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..row_date.job..row_date.sex..".png";
        ZImage:create(head_bg,head_path,6,6,70,70,1)
    end
    if row_date.userName == nil then 
       row_date.userName = Lang.team[13]  -- [13] = "玩家离线"
    end
    ZLabel:create(one_row.view,LH_COLOR[1]..row_date.userName,94,54,18,ALIGN_LEFT,1)
    if row_date.job == 0 then
        ZLabel:create(one_row.view,Lang.team[15]..Lang.team[13],220,55,16,ALIGN_LEFT,1)  -- [15] = "#cd0cda2职业：#cffffff",[13] = "玩家离线"
    else
        ZLabel:create(one_row.view,Lang.team[15]..Lang.job_info[row_date.job],220,55,16,ALIGN_LEFT,1) -- [15] = "#cd0cda2职业：#cffffff",
    end
    ZLabel:create(one_row.view,Lang.team[14]..row_date.level,370,55,16,ALIGN_LEFT,1) -- [14] = "#cd0cda2等级："
    ZLabel:create(one_row.view,Lang.team[12]..row_date.fight,94,21,16,ALIGN_LEFT,1) -- [12] = "#cd0cda2战斗力: "

    -- 分割线
    local line = CCZXImage:imageWithFile( 5, 0, 565, 3, UILH_COMMON.split_line )
    one_row.view:addChild(line)

    local function btn_fun(  )
        if player_btn_state ==1 then
            --解散队伍
            TeamCC:req_disable_team()
            TeamActivityCC:req_get_recruit_info(self.num_fuben,1)
        elseif player_btn_state ==2 then 
            --踢出队伍
            TeamCC:req_kick_player( row_date.userId )
            TeamActivityCC:req_get_recruit_info(self.num_fuben,1)
        elseif player_btn_state == 3 then 
            --离开队伍
            TeamCC:req_exit_team()
            TeamActivityCC:req_get_recruit_info(self.num_fuben,1) 
        end 
    end

    local team_btn = ZButton:create( one_row.view, UILH_COMMON.button6_4,btn_fun, 470,25,-1,-1);
    local player_btn_lab = CCZXLabel:labelWithText( 10, 17, Lang.team[8], 14, ALIGN_LEFT) -- [8] = "解散队伍"
    team_btn:addChild( player_btn_lab );

    local name = EntityManager:get_player_avatar().name
    if not isCaptain and name ~= row_date.userName  then 
        team_btn.view:setIsVisible(false)
    else 
        team_btn.view:setIsVisible(true)
    end 
    if isCaptain  then
       player_btn_lab:setText(Lang.team[8])   -- [8] = "解散队伍"
       player_btn_state = 1 
    end
    if isCaptain  and name ~= row_date.userName  then 
        player_btn_lab:setText(Lang.team[9])  -- [9] = "踢出队伍"
        player_btn_state= 2
    end
    if not isCaptain and name ==row_date.userName  then 
        player_btn_lab:setText(Lang.team[10])  -- [10] = "离开队伍"
        player_btn_state=3
    end
    -- 如果这行显示的用户是队长，而且不是当前玩家，就显示一个旗帜
    if self.selected_captain_name == row_date.userName and not isCaptain then
        local flag_captain = CCZXImage:imageWithFile(495,21,-1,-1, UILH_OTHER.flag_captain);
        one_row.view:addChild(flag_captain)
    end
 
    one_row.status = ZImage:create(one_row.view,nil,245,0,108,87,1)
    one_row.id = row_date.userId                -- 队员ID
    self.row_t[ index ] = one_row
    return one_row.view
end

--刷新队伍成员列表
function TeamWin:refresh_team_list(team_info)
    if team_info.count>0 then
        self:create_right_team_view(team_info)
    end
end

--更新招募副本列表
function TeamWin:update_self_info(recruit_info)
    -- 当返回招募副本有数据处理
    print("recruit_info.team_info_list[1]",recruit_info.team_info_list[1])
    if recruit_info.team_info_list[1] ~= nil and recruit_info.team_info_list[1].captain_name ~= "" then
        print("recruit_info.team_info_list[1].captain_name",recruit_info.team_info_list[1].captain_name)
        self:clear_team_list()
        TeamActivityCC:req_team_info( recruit_info.team_info_list[1].team_id )
        self.selected_team_id = recruit_info.team_info_list[1].team_id
        self.selected_captain_name = recruit_info.team_info_list[1].captain_name

        --更新左边队伍信息列表
        self.cur_page = recruit_info.num_page

        if self.left_scroll then
            self.left_panel:removeChild( self.left_scroll, true );
            self.left_scroll = nil
            if self.arrow_up and self.arrow_down then
                self.left_panel:removeChild( self.arrow_up, true );
                self.arrow_up = nil
                self.left_panel:removeChild( self.arrow_down, true );
                self.arrow_down = nil
            end
        end
        
        self.left_scroll = CCScroll:scrollWithFile( 1, 75, 265, 430, recruit_info.team_count, "", TYPE_HORIZONTAL, 600, 600 )
        self.left_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, 95 )
        self.left_scroll:setScrollLumpPos(266)

        -- 选中框
        self.select_team_index = 1
        self.scroll_item_select_table = {}
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
                local x = temparg[1]              -- 行
                local y = temparg[2]              -- 列
                local index = x + 1
                local bg = CCBasePanel:panelWithFile( 0, 0, 260, 105, UILH_COMMON.bg_05, 500, 500 )
                local select_focus = CCZXImage:imageWithFile(1,0,265,105, UILH_COMMON.select_focus,500,500);
                self.scroll_item_select_table[index] = select_focus
                bg:addChild(select_focus)
                if index == self.select_team_index then
                    select_focus:setIsVisible(true)
                else
                    select_focus:setIsVisible(false)
                end

                local function panel_fun(eventType,arg,msgid,selfitem)
                    if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                        return
                    end
                    if  eventType == TOUCH_BEGAN then
                        return true;
                    elseif eventType == TOUCH_CLICK then
                        local team_info = recruit_info.team_info_list[index]
                        TeamActivityCC:req_team_info(team_info.team_id)
                        self.selected_captain_name = team_info.captain_name
                        self.selected_team_id = team_info.team_id

                        -- 重置选中框位置，注意scroll会回收item，有可能之前的选中框item已经被销毁
                        if self.scroll_item_select_table[self.select_team_index] ~= nil then
                            self.scroll_item_select_table[self.select_team_index]:setIsVisible(false)
                        end
                        self.select_team_index = index
                        select_focus:setIsVisible(true)
                        return true;
                    elseif eventType == TOUCH_ENDED then
                        return true;
                    elseif eventType == ITEM_DELETE then
                        -- scroll不会发送销毁事件，反而是scroll中的item会给自己发送一个销毁事件....note by guozhinan
                        self.scroll_item_select_table[index] = nil
                    end
                    return true;
                end
                bg:registerScriptHandler(panel_fun)
                local team_info = recruit_info.team_info_list[index]
                if team_info ~= nil and team_info.captain_name~="" then
                    local name = team_info.captain_name
                    local num = team_info.count
                    local zhanli = team_info.zhanli

                    local head_bg = CCZXImage:imageWithFile(8,6,-1,-1 ,UILH_NORMAL.item_bg)
                    bg:addChild(head_bg)
                    if team_info.captain_job < 0 or team_info.captain_job > 4 or team_info.captain_sex < 0 or team_info.captain_sex > 1 then
                        -- 好像有时候会有异常数据下发，这里预防一下
                        print("左侧队长数据中职业和性别出错",team_info.captain_job,team_info.captain_sex)
                    else 
                        local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..team_info.captain_job..team_info.captain_sex..".png";
                        ZImage:create(head_bg,head_path,11,10,72,72,1)
                    end
                   
                    ZLabel:create(bg,LH_COLOR[1]..name,105,69,18,ALIGN_LEFT,1)
                    if num < 5 then
                        ZLabel:create(bg,Lang.team[11]..LH_COLOR[6]..num.."/5",105,15,16,ALIGN_LEFT,1) -- [11] = "#cd0cda2人数:",
                    else
                        ZLabel:create(bg,Lang.team[11]..LH_COLOR[7]..num.."/5",105,15,16,ALIGN_LEFT,1) -- [11] = "#cd0cda2人数:",
                    end
                    ZLabel:create(bg,Lang.team[12]..LH_COLOR[15]..zhanli,105,40,16,ALIGN_LEFT,1)  --[12] = "#cd0cda2总战力:"
                
                    -- 在队伍上增加副本标志
                    local fuben_type = TeamActivityMode:get_team_fuben_type(team_info.team_fuben_id);
                    if fuben_type > 0 and fuben_type < 5 then
                        local fuben_img = CCZXImage:imageWithFile(162,35,-1,-1, UIResourcePath.FileLocate.lh_juxianling .. "fuben"..fuben_type..".png",500,500);
                        fuben_img:setScale(0.9)
                        bg:addChild(fuben_img,5);
                    end
                end

                self.left_scroll:addItem( bg )

                self.left_scroll:refresh()
                return false
            end
        end
        self.left_scroll:registerScriptHandler(scrollfun)
        self.left_scroll:refresh()

        self.left_panel:addChild(self.left_scroll)
        self.arrow_up = CCZXImage:imageWithFile(267 , 495, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
        self.arrow_down = CCZXImage:imageWithFile(267, 74, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
        self.left_panel:addChild(self.arrow_up,1)
        self.left_panel:addChild(self.arrow_down,1)

    --没有数据的时候处理
    else
        --没有数据的时候处理
       self:clear_team_list()
       self.select_team_index = 1

       if self.left_scroll then
            self.left_panel:removeChild( self.left_scroll, true );
            self.left_scroll =nil
            if self.arrow_up and self.arrow_down then
                self.left_panel:removeChild( self.arrow_up, true );
                self.arrow_up = nil
                self.left_panel:removeChild( self.arrow_down, true );
                self.arrow_down =nil
            end
        end
        self.scroll_item_select_table = {}

        self.cur_page = 0
        self.selected_captain_name=""
        if self.right_label  then
            self.right_label:setIsVisible(true);
            self.team_text:setText(Lang.team.shuoming)
        else
            self:set_right_label()
        end
    end
end

function TeamWin:clear_team_list( ... )
    if self.right_label  then
        self.right_label:setIsVisible(false);
    end
    if self.right_scroll then 
        self.right_panel:removeChild( self.right_scroll, true );
        self.right_scroll = nil
    end 
    self.row_t= {}
end

function TeamWin:join_req(player_info)
    TeamCC:req_leader_replay(player_info.userId,1)
    TeamActivityCC:req_get_recruit_info(self.num_fuben,1)
end
function TeamWin:get_recruit_info( )
    TeamActivityCC:req_get_recruit_info(self.num_fuben,1)
end

-- 根据玩家是否有队伍更新按钮状态
function TeamWin:update_btn( team_id )
    if team_id == 0 then
        --没有队伍
        self.current_btn = 2
        self.make_team_btn.view:setIsVisible(true); -- 创建队伍按钮显示
        self.recruit_btn.view:setIsVisible(false)   -- 发布招募按钮不显示
        self.btn_dismiss_team.view:setIsVisible(false)   -- 解散队伍按钮不显示
        self.apply_team_btn.view:setIsVisible(true)    -- 申请入队按钮显示
    else
        --有队伍
        self.current_btn = 1
        self.make_team_btn.view:setIsVisible(false);
        self.recruit_btn.view:setIsVisible(true)
        self.btn_dismiss_team.view:setIsVisible(true)
        self.apply_team_btn.view:setIsVisible(false)
    end
end

function TeamWin:set_right_label( )
    --创建右边的label
    self.right_label = CCBasePanel:panelWithFile( 210, 40, 562,355, nil, 500, 500 )
    --当没队伍的时候提示
   --提示信息
    self.team_text = CCDialogEx:dialogWithFile(25, 210, 520, 100, 15, "" , TYPE_VERTICAL,ADD_LIST_DIR_UP);
    self.team_text:setAnchorPoint(0, 0)
    self.team_text:setFontSize(18);
    self.team_text:setLineEmptySpace(6)
    self.right_panel:addChild(self.team_text);
    self.team_text:setText(Lang.team.shuoming);
    self.view:addChild(self.right_label)

end
-- 更新队员状态
-- 由于天将项目中队长要求进入副本时不会打开teamwin，所以在这个页面设置队友状态没什么意义，在此注释掉   note by gzn
function TeamWin:update_status(actor_id,status )
    ZXLog("更新队员状态")
     for i = 1, 10 do
        if self.row_t[i]~=nil and self.row_t[i].id == actor_id then
            ZXLog("更新队员状态----------------i,status:",i,status)
            -- if status == 0 then
            --     self.row_t[i].status:setImage(UIPIC_TeamActivity_021)
            -- else
            --     self.row_t[i].status:setImage(UIPIC_TeamActivity_022)
            -- end
        end
    end
end
-- 切换队员列表的时候更新队员状态
function TeamWin:change_uptate_status( )
    local status = TeamActivityMode:get_status( )
    for i=1,#status do
        if status[i]~=nil and status[i].id~=nil and status[i].type~=nil then
            self:update_status(status[i].id,status[i].type)
        end
    end
end

function TeamWin:destroy(  )
    TeamActivityMode:reset_team_display_filter();
    if self.recruit_timer then 
        TeamModel:set_recruit_time(self.recruit_timer:getRemainTime());
        self.recruit_timer:destroy()
        self.recruit_timer = nil 
    end
    -- if self.enter_game_timer then 
    --     self.enter_game_timer:destroy()
    --     self.enter_game_timer = nil
    -- end
    Window.destroy(self)
end 

function TeamWin:destroy_new(  )
    TeamActivityMode:reset_team_display_filter();
    if self.recruit_timer then 
        TeamModel:set_recruit_time(self.recruit_timer:getRemainTime());
        self.recruit_timer:destroy()
        self.recruit_timer = nil 
    end
    -- if self.enter_game_timer then 
    --     self.enter_game_timer:destroy()
    --     self.enter_game_timer = nil
    -- end 
    Window.destroy(self)
end