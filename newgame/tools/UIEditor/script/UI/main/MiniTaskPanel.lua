-- MiniTaskPanel.lua
-- create by hcl on 2013-1-17
-- 任务快捷栏

require "utils/MUtils"
require "model/TaskModel"
require "model/TeamModel"
require "UI/main/TeamMemberView"

super_class.MiniTaskPanel()

local panel = nil;

local curr_selected_page = 0;

local _scroll = nil;

local _fuben_tongji_panel = nil; --统计面板

-- 显示主线任务特效的等级限制
local NEED_EFFECT_LEVEL = InstructionConfig:get_auto_quest_level( )
-- 是否有特效
local IF_NEED_EFFECT = false
-- 特效绑定的空间
local _effect_panel
-- 保存队伍scrollview的每一个子item
local team_item_table = {};

local buttonTextureLabel =
{
    { UILH_MAIN.m_task_yj_l, UILH_MAIN.m_task_yj },     -- 已接
    { UILH_MAIN.m_task_kj_l, UILH_MAIN.m_task_kj },     -- 可接
    { UILH_MAIN.m_task_dw_l, UILH_MAIN.m_task_dw },     -- 队伍
    { UILH_MAIN.m_task_cj_l, UILH_MAIN.m_task_cj },     -- 统计
}

local buttonTexture =
{
    { UILH_MAIN.task_tab_ovr, UILH_MAIN.task_tab },
    { UILH_MAIN.task_tab_ovr, UILH_MAIN.task_tab },
    { UILH_MAIN.task_tab_ovr, UILH_MAIN.task_tab },
    { UILH_MAIN.task_tab_ovr, UILH_MAIN.task_tab },
}
local TASK_LINE_WIDTH = 250
local TASK_SCROLL_WIDTH = 400
local TASK_SCROLL_HEIGHT = 150
local TASK_FONSIZE = 15
local panel_info =  { UIPOS_MiniTaskPanel_000[1], UIPOS_MiniTaskPanel_000[2] }
function MiniTaskPanel:get_miniTaskPanel()
    local win = UIManager:find_window("user_panel");
    if ( win ) then
        return win.miniTaskPanel;
    end
end

-- 是否卡级任务
function MiniTaskPanel:is_kaji_task( task_id )
    local task_id_t = { {188,31},{200,32}, {204,33}, {208,34}, {211,35}, {214,36},
                {217,37},{220,38},{223,39},{226,40},{229,41},{232,42},{234,43},
                {237,44},{240,45},{243,46},{246,47},{249,48},{252,49},{256,50},
                {260,51},{264,52},{267,53},{270,54},{273,55},{276,56},{279,57},
                {282,58},{286,59},{288,60},{292,61},{295,62},{298,63},{301,64},
                {305,65},{307,66},{311,67},{312,68},{315,69},{318,70}}
    local player = EntityManager:get_player_avatar()
    for i,v in pairs(task_id_t) do
        if (task_id == v[1]) and player.level < v[2] then
            return true
        end
    end
    return false
end

function MiniTaskPanel:__init()
    local temp_panel = BasePanel:create( nil, panel_info[1], panel_info[2], 368, TASK_LINE_WIDTH-40, "",22, 5, 74, 5, 22, 4, 74, 4)
    panel = temp_panel.view
    self.view = panel;

    temp_panel:setTouchBeganReturnValue(false)
    temp_panel:setTouchEndedReturnValue(false)

    self.xiannv_timerlable = nil  -- 仙女护送任务的倒计时  (timerlabel控件)
    -- self.zhuangbei_timerlabel = nil -- 三件20级紫装装备任务的倒计时（SB策划时隔三个月，取消这个功能）

    -- 创建导航栏,切换已接任务和未接任务
    self:create_radio_button_group();
    -- 创建任务内容滑动控件
    self:create_task_scroll();

    self._instruction_components = {}
    -- self:do_tab_button_method(1);

    -- 添加背景框
    -- local frame1 = CCZXImage:imageWithFile( 0, 140, -1, -1, UILH_MAIN.task_tab_bg)  -- (126,50)
    -- panel:addChild( frame1, -1 )   
    -- local frame2 = CCZXImage:imageWithFile( 126, 140, -1, -1, UILH_MAIN.m_task_frame)
    -- frame2:setFlipX(true)
    -- panel:addChild( frame2, -1 )   
end	

function MiniTaskPanel:create_radio_button_group()
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(28,180-25,TASK_LINE_WIDTH,35,nil);
    panel:addChild( self.raido_btn_group);

    -- MUtils:create_sprite(self.raido_btn_group,UIResourcePath.FileLocate.main .. "task_bg.png",90,22.5,-1);

        -- 任务面板
    --local base_path = UIResourcePath.FileLocate.main .. "m_task_";
    self.radio_button_spriteLabel = {}
    local temp_y = 74
    for i=1,4 do

        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
                --按钮抬起时处理事件.
                -- Instruction:handleUIComponentClick(instruct_comps.MINI_TASK_TABBASE + i)
                self:do_tab_button_method(i);
                return true;
            elseif eventType == TOUCH_BEGAN then
                
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
        end
        local x = (i-1) * temp_y;
        local y = 0;
        local btn = nil;
        if ( i == 4 ) then
            local picName = buttonTexture[i]
            local labelPicPath = buttonTextureLabel[i][1]
            btn = MUtils:create_radio_button( self.raido_btn_group,picName[2],picName[1],
                                              btn_fun, temp_y,y,-1,-1,false);

            local size = btn:getSize()
            local pic = MUtils:create_sprite(btn,labelPicPath,size.width* 0.5,size.height* 0.5);
            btn:setIsVisible(false);

            self.radio_button_spriteLabel[i] = pic
        else
            local picName = buttonTexture[i]
            local labelPicPath = buttonTextureLabel[i][1]
            btn = MUtils:create_radio_button( self.raido_btn_group,picName[2],picName[1],
                                              btn_fun,x,y,-1,-1,false);
            local size = btn:getSize()
            local pic = MUtils:create_sprite(btn,labelPicPath,size.width * 0.5,size.height* 0.5);

            self.radio_button_spriteLabel[i] = pic
        end

        if ( i == 2 ) then
            self.task_num_bg = MUtils:create_sprite(btn,UILH_TASK.num_bg,63,37);
            self.task_num_lab = MUtils:create_zxfont(self.task_num_bg,"",14,9.5,2,14);
        end
        
    end

end

function MiniTaskPanel:do_tab_button_method(index)
    -- if SceneManager:get_cur_fuben() > 0 and index ~= 4 then
    --     return
    -- end
    -- if ( curr_selected_page == index ) then 
    --     return;
    -- end
    if index == 2 then
       Analyze:parse_click_main_menu_info(133) 
    end
    self.raido_btn_group:selectItem( index - 1)

    for j=1,4 do 
        self.radio_button_spriteLabel[j]:replaceTexture(buttonTextureLabel[j][2])
    end
    self.radio_button_spriteLabel[index]:replaceTexture(buttonTextureLabel[index][1])
                
    local reinit = false
    if curr_selected_page ~= index then
        reinit = true
    end

    -- 因为用clear方法会导致任务栏不能滑动，所以就统一用reinitScroll方法，于是就将reinit设为true
    reinit = true

    print("curr_selected_page,index", curr_selected_page,index,reinit)
    curr_selected_page = index;
    self:update( 1,{ curr_selected_page }, reinit );
end

-- 当前正在显示的任务数据表(已接和可接)
local task_table = {};

function MiniTaskPanel:create_task_scroll()
    local row_num = 1;

    --_scroll = CCScroll:scrollWithFile(10,5,150,120,1,1,row_num,nil,TYPE_VERTICAL,500,500);
    -- local _scroll_info = { x = 5, y = 0, width = 164, height = 155, maxnum = row_num, stype = TYPE_HORIZONTAL, grapsize = 0 }
    -- _scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    --_scroll = CCScroll:scrollWithFile(10,5,150,120,1,1,row_num,nil,TYPE_VERTICAL,500,500);
    local _scroll_info = { x = 15, y = 17, width = TASK_SCROLL_WIDTH-3, height = TASK_SCROLL_HEIGHT, maxnum = row_num, stype = TYPE_HORIZONTAL, grapsize = 0 }
    _scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, 
                                                  _scroll_info.width, _scroll_info.height-5, 
                                                  _scroll_info.maxnum, 
                                                  "",
                                                   4,4,4,4,
                                                   4,4,4,4)
    _scroll:setGapSize(5);

    local scrollPanel = CCBasePanel:panelWithFile( 0, -20, TASK_LINE_WIDTH + 30, _scroll_info.height+30, UILH_MAIN.task_bg, 500, 500)

    panel:addChild(scrollPanel)
    scrollPanel:addChild(_scroll);
    -- _scroll:setEnableCut(true)
    -- _scroll:setEnableScroll(true)

    local tab_item_height = {};
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
         -- print("run touch_began msgid",msg_id)
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            --local row = temparg[2] +1             -- 行
            local row = temparg[1] + 1
            --print("row = " .. row);
            self:create_scroll_item_by_page_index( curr_selected_page,row );
            return true;
        end
    end
     _scroll:registerScriptHandler(scrollfun);
    -- _scroll:setChildScriptHadler(true)
    -- _scroll:setMessageIndex(2000)
    -- _scroll:reInitChildInfo()
    _scroll:refresh()


    local function finish_fun(eventType,x,y)
        if  eventType == TOUCH_CLICK then
            self:do_finish_btn_method()
            self:set_finish_quest_btn_visible(false);
        end
        return true
    end
    -- 立即完成任务按钮
    --xiehande UIPIC_MiniTaskPanel_010 ->UIPIC_COMMOM_002  UIPIC_MiniTaskPanel_011 ->UIPIC_COMMOM_004
    self.finish_quest_btn, self.lab_btn_name = MUtils:create_btn_and_lab(self.view,
        UILH_COMMON.btn4_nor,
        UILH_COMMON.btn4_sel,
        finish_fun,
        0, 0, 121, 53,
        LangGameString[830], 16); -- [830]="立即完成"
    self.finish_quest_btn:setIsVisible( false );
end

-- 更新界面
function MiniTaskPanel:update(type,tab_arg, reinit)
    -- 更新scrollview
    if ( type == 1 ) then
        self:update_dialog(tab_arg[1], reinit);
    -- 更新任务进度
    elseif ( type == 2) then 
        self:update_task_process(tab_arg);
    end
end

function MiniTaskPanel:update_dialog( page_index, reinit )
    --print ( "[MiniTaskPanel]:update_dialog" );
    self._instruction_components = {}
    local num = 0;
    if ( page_index == 1 ) then
        task_table,num = TaskModel:get_yijie_tasks_list();
        -- 策划需求，已接任务为0时自动切换到可接任务栏
      --  print("----------------update_dialog .num = ",num);
        if ( num == 0  ) then
            if _fuben_tongji_panel ~= nil then
                self:do_tab_button_method(4);
            else
                self:do_tab_button_method(2);
            end
        end
    elseif ( page_index == 2 ) then
        task_table,num = TaskModel:get_kejie_tasks_list();
        print("task_table,num",task_table,num)
        for i,v in ipairs(task_table) do
            print("当前的可接任务",i,v);
        end
    elseif ( page_index == 3 ) then
        num = #TeamModel:get_team_table();
        print("队伍Num = ",num);
        if ( num > 0 ) then
            -- 显示退出队伍的按钮
            UIManager:show_window("team_btns_panel");
        end
        team_item_table = nil;
        team_item_table = {};
    end
    -- 隐藏委任队伍和踢出队伍按钮
    self:update_btns(  )

    -- 清除计时器
    if ( self.xiannv_timerlable ) then
        self.xiannv_timerlable:destroy();
        self.xiannv_timerlable = nil;
    end
    -- if ( self.zhuangbei_timerlabel ) then
    --     self.zhuangbei_timerlabel:destroy();
    --     self.zhuangbei_timerlabel = nil;
    -- end
    -- 统计界面特殊处理
    if page_index ~= 4 then
        print("num",num)
        if ( num > 0 ) then 
            print("reinit",reinit)
            if page_index == 3 and TeamModel:get_team_id() ~= 0 then
                -- 玩家有队伍，且打开队伍分页，则加多一行显示“退伍”按钮，策划想的愚蠢改动
                num = num + 1
            end
            if reinit == true then
                _scroll:reinitScroll()
            else
                _scroll:clear();
            end
            _scroll:setMaxNum(num);
            _scroll:refresh();
        else
            -- 玩家自己在组队系统一个人组队，也会走入这个路径
            print("reinit",reinit)
            if reinit == true then
                _scroll:reinitScroll()
            else
                _scroll:clear();
            end

            if page_index == 3 and TeamModel:get_team_id() == 0 then
                -- 如果是队伍分页，而且当前没有队伍，那么设置成只有一行，显示“快速组队”按钮
                -- 不设置1行的话，切换分页时最大行数还是按前一个分页的数，会导致多个按钮出现
                _scroll:setMaxNum(1);
            end

            _scroll:refresh();
        end
    else
         _scroll:clear();
        _scroll:setMaxNum(1);
        _scroll:refresh();
    end

    -- if IF_NEED_EFFECT and _effect_panel then
    --     LuaEffectManager:stop_view_effect(11038, _effect_panel)
    -- end
    if ( page_index ~= 1 ) then
        self:set_finish_quest_btn_visible( false )
    end
--    print("XSZYManager:get_state():",XSZYManager:get_state())
    -- 如果是vip3体验卡任务中
    -- if ( XSZYManager:get_state() == XSZYConfig.VIP_ZY ) then
    --     if ( page_index == 1 ) then
    --         -- 播放新手指引action
    --         self:xszy_main_quest( 4 );
    --     else
    --         self:stop_xszy()
    --     end
    -- end

    -- -- 如果是待机新手指引中
    -- if ( PlayerAvatar:get_is_daiji_xszy() ) then
    --     if ( page_index == 1 ) then
    --         -- 播放新手指引action
    --         self:xszy_main_quest( 5 );
    --     else
    --         self:stop_xszy();
    --     end
    -- end
   
end

function MiniTaskPanel:update_task_process( tab_arg )
   print("更新任务栏进度curr_selected_page=",curr_selected_page);
    -- 如果当前显示的是已接任务
    if ( curr_selected_page == 1 ) then
        -- ccsroll没法只更新其中一项所有只能更新整个scrollview
        self:update_dialog(1);
    end
    
end
-- 创建scroll_item 根据页数
function MiniTaskPanel:create_scroll_item_by_page_index( page_index ,row)
print("MiniTaskPanel:create_scroll_item_by_page_index page_index,row",page_index,row)
    -- 1已接，2未接，3队伍,4统计
    if ( page_index == 1 or page_index == 2 ) then
        if task_table ~= nil and type(task_table) == 'table' then
            _scroll:setMaxNum(#task_table)
        end
        self:create_task_page_info(row);
        _scroll:setSize(TASK_SCROLL_WIDTH-3, TASK_SCROLL_HEIGHT-3)
    elseif (  page_index == 4 ) then
        _scroll:setMaxNum(1)
        self:init_tongji_panel( );
        _scroll:setSize(TASK_LINE_WIDTH-4+10, TASK_SCROLL_HEIGHT-7)
    elseif ( page_index == 3) then
        -- local team_member_table = TeamModel:get_team_table();
        -- if team_member_table ~= nil and type(team_member_table) == 'table' then
        --     _scroll:setMaxNum(#team_member_table)
        -- end
        self:create_team_page_info( row )
        _scroll:setSize(TASK_SCROLL_WIDTH-3, TASK_SCROLL_HEIGHT-7)
    end
end

local TIMER_LABEL_TAG = 9392
-- local TIMER_ZB_LABEL_TAG = 9393 -- 中级强化石获得三件紫装装备的任务的倒计时tag

-- 创建任务页的scroll_item
function MiniTaskPanel:create_task_page_info( row )
    --require "model/TaskModel"
    if ( task_table[row] == nil ) then
        return;
    end
    local player = EntityManager:get_player_avatar()
    local task_info = TaskModel:get_info_by_task_id(task_table[row]);
    if ( task_info ) then
        local task_type = "";
        if ( task_info.type == 0 ) then 
            task_type = LangGameString[1451]; -- [1451]="#cfff000[主]#c66ff66"
            if player.level < NEED_EFFECT_LEVEL then
                IF_NEED_EFFECT = true
            else
                IF_NEED_EFFECT = false
            end
        elseif ( task_info.type == 1 ) then
           task_type = LangGameString[1452]; -- [1452]="#c00c0ff[支]#c35c3f7"
           IF_NEED_EFFECT = false
        elseif ( task_info.type == 3 ) then 
           task_type = LangGameString[1453]; -- [1453]="#c00c0ff[日]#c35c3f7"
           IF_NEED_EFFECT = false
        end
        local task_content,is_finish,time = TaskModel:get_task_str_by_task_id( task_table[row] ,curr_selected_page,true);
        
        -- 已接任务栏才要显示人物进度字符串
        local process_str = "";
        if ( curr_selected_page == 1 ) then
            if ( is_finish ) then
                process_str = LangGameString[1454] .. "#r"; -- [1454]="#c66ff66(已完成)#cffffff"
                EventSystem.postEvent('completedQuest', task_table[row] )
            else
                process_str = LangGameString[1455]; -- [1455]="#c35c3f7(进行中)#cffffff"
            end
        end
        local task_name = task_info.name
        local percent = ""  --进度百分比
        local zx_height = 0
        local per_lab = nil
        if task_info.type == 0 then
            local zx_id = task_table[row]
            local chapter, chapter_tasks = TaskModel:get_chapter_info( zx_id )
            if chapter then
                local win = UIManager:find_visible_window("right_top_panel")
                if win then
                    win:show_chapter_visible(true)
                    win:show_chapter_effect(TaskModel:get_award_exist())
                    win:change_chapter_icon(chapter.cid)
                end
                task_type,task_name,process_str = "", "", ""
                local title = Lang.task[41+chapter.cid] .. chapter.title
                if #chapter_tasks ~= 0 then
    			local cur = 1
    	            for i, v in ipairs(chapter_tasks) do
    	                if v == zx_id then
    	                    cur = i
    	                    break
    	                end
    	            end
    	            local per = math.floor((cur-1)/#chapter_tasks * 100)
    	            percent = string.format("#cfff000%s #c66ff66进度:#cd0cda2%d%%", title, per)
    	            per_lab = ZLabel:create(nil, percent, 0, 0, 16)
    	            zx_height = 20
    			end
            end
        end

        local str = string.format("%s%s%s%s",task_type,task_name,process_str,task_content);
        -- 每行的背景panel
        local dialog_panel = CCBasePanel:panelWithFile(0, 0, TASK_LINE_WIDTH-40, 0, "");
        local dialog = CCDialogEx:dialogWithFile(2, 0, TASK_LINE_WIDTH-50, 0, 8,"",TYPE_VERTICAL,ADD_LIST_DIR_UP);
        dialog_panel:addChild(dialog)
        dialog:setMessageCut(true)
        dialog:setFontSize(TASK_FONSIZE);
        dialog:setText(str);
        dialog:setLineEmptySpace(8)
        local dialog_text_size = dialog:getInfoSize()
        local ds_h = dialog_text_size.height < 35 and 35 or dialog_text_size.height
        if per_lab ~= nil then
            dialog_panel:addChild(per_lab.view)
            per_lab:setPosition(0, ds_h+14)
            local line = CCZXImage:imageWithFile( 50, ds_h+9, 150, 2, UILH_MAIN.task_split_line )
            dialog_panel:addChild( line )       
        end
        dialog:setSize(205, ds_h+10)
        --UILH_COMMON.bg_06
        local dialog_bg = MUtils:create_zximg2(dialog,'',0 , 0, TASK_LINE_WIDTH-40, ds_h+16,3,3,3,3,3,3,3,3,-1)
        local sz = dialog:getSize()
        -- dialog:setSize(TASK_LINE_WIDTH+10,sz.height)
        dialog_panel:setSize(TASK_LINE_WIDTH+10,sz.height+5+zx_height)
        _scroll:addItem(dialog_panel);
        -- 分割线
        local seperate_line = CCZXImage:imageWithFile( 5, 0, 240, 2, UILH_MAIN.task_split_line )
        dialog:addChild( seperate_line )           -- 分割线

        -- 这是竖的分割线
        -- split_line_v = CCZXImage:imageWithFile( TASK_LINE_WIDTH-50, 6, 3, sz.height-10, UILH_COMMON.split_line_v )
        -- dialog_panel:addChild( split_line_v )
        local function tel()
            Instruction:handleUIComponentClick(instruct_comps.CLOSE_XSZY)
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            TaskModel:teleport_by_quest_id (task_table[row] ,curr_selected_page )
        end
        -- local teleport = ZImage:create(dialog, UILH_MAIN.foot, TASK_LINE_WIDTH-45, (sz.height - 52)/2, -1, -1, 99)
        local teleport = ZButton:create(dialog_panel, UILH_MAIN.foot, tel, TASK_LINE_WIDTH-45, (sz.height - 52)/2, -1, -1, 99)
        if IF_NEED_EFFECT then
            --任务特效边框
            local effect = LuaEffectManager:play_view_effect(11038, 127, 27+(sz.height - 36)/2, dialog_panel, true, 99999)
            effect:setScaleY(1.3)
            -- effect:setScaleX(0.95)
            _effect_panel = dialog
        end
        -- 如果需要计时，就加上计时的view
        print("time = ",time );
        -- if task_info.starid == 5 then
        --     if (is_finish == nil or is_finish == false) and time > 0 then
        --         local function end_call()
        --             -- NormalDialog:show(Lang.tip[2],nil,2); -- [2] = "已满足任务时间,点击左侧任务面板的神兵利器任务，可领取奖励!",
        --             if ( self.zhuangbei_timerlabel ) then
        --                 self.zhuangbei_timerlabel:destroy();
        --                 self.zhuangbei_timerlabel = nil;
        --             end
        --         end
        --         self.zhuangbei_timerlabel = TimerLabel:create_label(dialog, 88, 9, TASK_FONSIZE, time-1, "#cff0000", end_call,nil);
        --         self.zhuangbei_timerlabel.panel.view:setTag(TIMER_ZB_LABEL_TAG)
        --     end
        -- end
        if ( time ~= 0 and task_info.starid ~= 5 ) then
            local function end_call()
                -- NormalDialog:show(Lang.hsbc[21],nil,2); -- [1456]="护送仙女#r任务时间已到,失败!"
                self.xiannv_timerlable = nil;
            end
            self.xiannv_timerlable = TimerLabel:create_label(dialog, 88, 9, TASK_FONSIZE, time-1, "#cff0000", end_call,nil);
            self.xiannv_timerlable.panel.view:setTag(TIMER_LABEL_TAG)
        end
        local function task_dialog_fun(eventType,arg,msgid)
--            print("task_dialog_fun............",eventType);
            if eventType == nil or arg == nil or msgid == nil  then
                return false
            end
            if eventType == TOUCH_BEGAN then
               -- print("run task touch begin")
                dialog_bg:setColor(0x44f2f2f2);
                return true
            elseif  eventType == TOUCH_ENDED then
                Instruction:handleUIComponentClick(instruct_comps.CLOSE_XSZY)
                Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
                local task_id = task_table[row]

                -- 添加卡级提示
                local function tip_win()
                    UIManager:show_window("activity_Win")
                end
                if self:is_kaji_task(task_id) then
                    -- NormalDialog:show("提示", tip_win, 1,nil, UIHL_NORMAL.title_tips)
                    -- NormalDialog:show( LH_COLOR[2]..Lang.task[32]..LH_COLOR[11]..Lang.task[33]..LH_COLOR[2]..Lang.task[34]..LH_COLOR[11]..Lang.task[35]..LH_COLOR[2]..Lang.task[36]..LH_COLOR[11]..Lang.task[37]..LH_COLOR[2]..Lang.task[38]..LH_COLOR[11]..Lang.task[39]..LH_COLOR[2]..Lang.task[40], 
                    --     tip_win, 4, nil, true, UILH_NORMAL.title_tips)
                    need_exp_callback()
                end


                local dx,dy = dialog_panel:getPosition();
                dialog_bg:setColor(0xffffffff);
                -- 计数 added by aXing on 2013-6-4
                Analyze:parse_click_task_track_move(  )
                -- 显示对话框
                --QuestTeleportDialog:show(task_table[row],curr_selected_page );
            --    print("【快捷任务栏】当前点击的任务id = ",task_table[row]);
                local temp_result = AIManager:do_quest( task_table[row] ,curr_selected_page,true);
                if temp_result == false then
                    Analyze:parse_click_main_menu_info(135)
                end
                -- 如果玩家等级小于31而且
                -- local player = EntityManager:get_player_avatar();
                -- if ( player.level < 31 and player:get_is_daiji_xszy() ) then 
                --     self:stop_xszy(); 
                --     player:set_is_xszy_false()                  
                -- end
                -- 如果是日常任务的话弹出立即完成按钮
                if ( curr_selected_page == 1 and task_info.type == 3 and task_info.quickFinish) then
                    self:set_finish_quest_btn_visible( true,task_table[row],dx + 267,dy)
                end
                
                if TaskModel:is_task_finished(task_id) then
                    EventSystem.postEvent('miniFinishTaskClicked', task_id)
                else
                    EventSystem.postEvent('miniTaskClicked', task_id)
                end
                Instruction:onMiniTaskClick({ view = dialog }, task_id)
                return true;
            elseif eventType == TOUCH_CLICK then
                Instruction:handleUIComponentClick(instruct_comps.CLOSE_XSZY)
                Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
                local temparg = Utils:Split(arg,":")
                local tx = tonumber(temparg[1])
                local ty = tonumber(temparg[2])
            elseif eventType == TOUCH_DOUBLE_CLICK then
                dialog_bg:setColor(0xffffffff);

                -- print("双击任务栏..........................")
                -- 计数 added by aXing on 2013-6-4
                Analyze:parse_double_click_task_track_transport(  )
                -- 双击直接传送
                TaskModel:teleport_by_quest_id (task_table[row] ,curr_selected_page );
                -- 如果是在vip3新手指引中,
                -- if ( XSZYManager:get_state() == XSZYConfig.VIP_ZY ) then
                --     self:stop_xszy();  
                -- end
                return true;
            elseif eventType == DRAG_BEGIN then
                dialog_bg:setColor(0xffffffff);
                return true;
            elseif eventType == ITEM_DELETE then
                local timer_lab = dialog:getChildByTag(TIMER_LABEL_TAG)
                if timer_lab then 
                    self.xiannv_timerlable:destroy();
                    self.xiannv_timerlable = nil;
                end
                -- local timer_lab = dialog:getChildByTag(TIMER_ZB_LABEL_TAG)
                -- if timer_lab then 
                --     self.zhuangbei_timerlabel:destroy();
                --     self.zhuangbei_timerlabel = nil;
                -- end
            end
            return true;
        end
        -- dialog:registerScriptHandler(task_dialog_fun)
        -- dialog:setEnableDoubleClick(true)
        dialog:setDefaultMessageReturn(false)
        dialog_panel:registerScriptHandler(task_dialog_fun)
        dialog_panel:setEnableDoubleClick(true)
        _scroll:refresh();
        Instruction:onMiniTaskCreateTask({ view = dialog },task_table[row])
        --self._instruction_components[instruct_comps.MINI_TASK_BASE] = { view = dialog }
    end 
end



-- 函数：初始化统计面板
-- 参数：fb ,副本配置数据
function MiniTaskPanel:init_tongji_panel(  )
    _scroll:setMaxNum(1);
    -- _scroll:refresh();
   print("_fuben_tongji_panel",_fuben_tongji_panel)
    if _fuben_tongji_panel == nil then
        
        _fuben_tongji_panel = FubenTongjiModel:get_tongji_panel( );
        print("!!!_fuben_tongji_panel",_fuben_tongji_panel)
        if _fuben_tongji_panel~= nil then
            _scroll:addItem(_fuben_tongji_panel.view);
            _scroll:refresh()
        end
    else
        _scroll:addItem(_fuben_tongji_panel.view);
        _scroll:refresh()
    end
end

-- 函数：更新统计面板
function MiniTaskPanel:update_tongji_panel(fbId, data )
    print("_fuben_tongji_panel",_fuben_tongji_panel)
    if _fuben_tongji_panel ~= nil then
        print(" MiniTaskPanel:update_tongji_panel(fbId, data )",fbId,data)
        _fuben_tongji_panel:update(fbId, data);
    end
end
--更新一些特殊处理的状态
function MiniTaskPanel:update_special_status( fbId,data,status_code )

    print("MiniTaskPanel:更新一些特殊处理的状态", _fuben_tongji_panel);
    if fbId == 59 and _fuben_tongji_panel ~= nil then
        --更新联盟状态
        _fuben_tongji_panel:update_league_status(data);

    elseif fbId == 7 and _fuben_tongji_panel ~=nil then
        _fuben_tongji_panel:update_pink_gather_count(data);

    elseif fbId == 69 and _fuben_tongji_panel ~= nil then
        -- 更新八卦地宫的boss刷新时间
        _fuben_tongji_panel:update_boss_refresh_time(data);
    elseif fbId == 11 and _fuben_tongji_panel ~= nil then
        -- 更新必杀技副本的经验值
        _fuben_tongji_panel:update_bishaji_fuben_exp(data);
    end
end

function MiniTaskPanel:remove_tongji_panel( )

    -- 隐藏统计按钮，显示可接任务按钮
    self:change_tongji_kejie_state( true );

    if _fuben_tongji_panel then
        _fuben_tongji_panel:destroy();
        _fuben_tongji_panel = nil;
    end
    -- 切换到任务栏
    self:do_tab_button_method(1);
end

function MiniTaskPanel:change_tongji_kejie_state( show )
    self.raido_btn_group:getIndexItem( 1 ):setIsVisible( show );
    self.raido_btn_group:getIndexItem( 3 ):setIsVisible( not show);
    -- if ( show == false ) then
    --     self:update_kejie_task_num( 0 )
    -- else
    --     local task_table,num = TaskModel:get_kejie_tasks_list();
    --     self:update_kejie_task_num(num)
    -- end
end

-- ----------------------------------------------队伍-----------------------------------------

-- 创建队伍页
function MiniTaskPanel:create_team_page_info( row )
    print("row = .........................................",row)
    local team_member_table = TeamModel:get_team_table();
    if ( #team_member_table > 0 ) then

        local team_member_struct = team_member_table[row];
        --create by jiangjinhong
        --如果队伍中又玩家离线或者掉线,此时从服务器下发的血蓝 都是0，
        --但是客户端需要这些数据创建血蓝条，所以做假数据，1,1,1,1 无实际意义
        -- 现在最后一行显示的是退伍按钮，note by gzn
        if team_member_struct == nil then
            if TeamModel:get_team_id() ~= 0 then
                team_item_table[row] = TeamMemberView( 0,155 - row*80,nil,nil,nil,nil,nil,nil,nil,nil,row ,nil,nil);
            end
        elseif team_member_struct.handle == "0x0" then 
            team_item_table[row] = TeamMemberView( 0,155 - row*80,team_member_struct.lv,
            team_member_struct.name,1,1,1,1,team_member_struct.sex,team_member_struct.job ,row ,team_member_struct.actor_id,team_member_struct.handle);
            TeamModel:set_member_offline( team_member_struct.actor_id );
        else 
            team_item_table[row] = TeamMemberView( 0,155 - row*80,team_member_struct.lv,
            team_member_struct.name,team_member_struct.hp,team_member_struct.maxHp,team_member_struct.mp,
            team_member_struct.maxMp,team_member_struct.sex,team_member_struct.job ,row ,team_member_struct.actor_id,team_member_struct.handle);
        end 
        if team_item_table[row] ~= nil then
            _scroll:addItem( team_item_table[row].view );
        end
        _scroll:refresh();
    else
        if TeamModel:get_team_id() == 0 then
            -- 策划俊野要求，没有队伍时显示一个快速组队按钮  add by gzn 2015/4/24
            local panel = CCBasePanel:panelWithFile(0,155 - row*80,250,80,"",500,500);
            -- 快速组队按钮
            local function btn_join_team_fun(eventType,args,msgid)
                if ( eventType == TOUCH_BEGAN ) then
                    return true;
                elseif ( eventType == TOUCH_CLICK ) then
                    TeamWin:show(1);
                    return true;
                end
                return true
            end

            local btn_join_team = MUtils:create_btn(panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_join_team_fun,64,26,-1,-1);
            MUtils:create_zxfont(btn_join_team, Lang.team[29], 121/2, 20, 2, 16)   -- [29] = "快速组队",

            _scroll:addItem( panel );
            _scroll:refresh();
        else
            -- 这种情况是玩家自己在组队系统一个人组队，所以没有队友，但是有队伍
        end
    end 
end

function MiniTaskPanel:on_team_item_delete( index )
    team_item_table[ index ] = nil;
end

-- 更新队员的状态
function MiniTaskPanel:update_team_member_state( actor_id,state )
    local index = TeamModel:get_member_index_by_actor_id( actor_id )
    if team_item_table[index] then
        team_item_table[index]:update_state(state);
    end
end

-- 队伍页面选中一项时
function MiniTaskPanel:select_item( team_index )
    TeamBtnsPanel:set_select_index( team_index )
    
    for i=1,#team_item_table do
        if ( i ~= team_index and team_item_table[i]) then
          --  print("i = ",i)
            team_item_table[i]:set_select(false);
        end
    end

    -- 判断自己是不是队长
    if ( TeamModel:is_leader() ) then
        local win = UIManager:find_visible_window("team_btns_panel");
        if ( win ) then
            win:select_btn( true );
        end
    end
end
-- 队伍页面隐藏按钮
function MiniTaskPanel:update_btns(  )
    if ( curr_selected_page ~= 3 ) then
        UIManager:hide_window("team_btns_panel");
    end
end

-- 队伍界面更新队长标志
function MiniTaskPanel:update_leader( leader_actor_id )
    for i=1,#team_item_table do
        team_item_table[i]:set_leader_spr( leader_actor_id );
    end
end

-- 指向主线任务 str 新手指引文字
function MiniTaskPanel:xszy_main_quest( img_id )
    print("img_id = ",img_id);
    -- 如果选中的是已接任务
    if ( curr_selected_page == 1 and self.zximg_jt == nil ) then
        self.zximg_jt = MUtils:create_zximg2(self.view,"nopack/ani_xszy3.png",170, 115,117,39, 45,39,20,39,45,39,20,39,1);
        self.zximg_jt:setAnchorPoint(0,0.5);
        LuaEffectManager:run_move_animation( 1 ,self.zximg_jt);
        MUtils:create_sprite(self.zximg_jt,"nopack/xszy/"..img_id..".png",71,23);
    end
end
-- 停止指向主线任务
function MiniTaskPanel:stop_xszy()
    if ( self.zximg_jt ) then 
        self.zximg_jt:removeFromParentAndCleanup( true );
        self.zximg_jt = nil;
    end
end

-- 支线任务显示隐藏立即完成按钮
function MiniTaskPanel:set_finish_quest_btn_visible( is_visible,quest_id,pos_x,pos_y )
    if ( self.dismiss_btn_cb ) then
        self.dismiss_btn_cb:cancel();
    end
    if ( is_visible ) then
        -- 处理按钮是跑环任务还是普通任务
        local quest_info = QuestConfig:get_quest_by_id(quest_id)
        if ( quest_info.loopid ) then
            self.lab_btn_name:setText(LangGameString[829]) -- [829]="轻松解环"
        else
            self.lab_btn_name:setText(LangGameString[830]); -- [830]="立即完成"
        end

        local function cb()
            self.finish_quest_btn:setIsVisible(false);
        end
        self.dismiss_btn_cb = callback:new();
        self.dismiss_btn_cb:start(3,cb);
        if pos_y < 0 then
            pos_y = 0
        end
        self.finish_quest_btn:setPosition( pos_x,pos_y );
        self.quest_id = quest_id;
    end
    self.finish_quest_btn:setIsVisible( is_visible )
end

-- 更新队友数据
function MiniTaskPanel:update_team_attr( actor_id,data,update_type)
    for i=1,#team_item_table do
        if ( team_item_table[i].actor_id == actor_id ) then
            if ( update_type == 1 ) then
                team_item_table[i]:update_hp( data[1],data[2] );
            elseif ( update_type == 2 ) then
                team_item_table[i]:update_mp( data[1],data[2] );
            elseif (update_type == 3 ) then
                team_item_table[i]:update_lv( data[1] );
            end
            
            return;
        end
    end
end


function MiniTaskPanel:destroy()
    panel = nil;

    curr_selected_page = 0;

    -- if IF_NEED_EFFECT and _effect_panel then
    --     LuaEffectManager:stop_view_effect(11038, _effect_panel)
    --     _effect_panel = nil
    -- end

    IF_NEED_EFFECT = false
    _scroll = nil;

    -- 保存队伍scrollview的每一个子item
    team_item_table = {};
    task_table = {}

    -- 销毁Timerlable   lyl
    if self.xiannv_timerlable then 
        self.xiannv_timerlable:destroy()
    end
    -- if self.zhuangbei_timerlabel then 
    --     self.zhuangbei_timerlabel:destroy()
    -- end

    if _fuben_tongji_panel then
        _fuben_tongji_panel:destroy();
        _fuben_tongji_panel = nil;
    end

    _fuben_tongji_panel = nil; --统计面板

end

function MiniTaskPanel:active( show )
    if ( show ) then
        TaskModel:active( show )
    end
end

local ph_is_show_next = false

function MiniTaskPanel:do_finish_btn_method(  )
    if ( self.lab_btn_name:getText() == LangGameString[830] ) then -- [830]="立即完成"
        if ( self.quest_id and VIPModel:is_vip_lv3() ) then
            local money_type = MallModel:get_only_use_yb() and 3 or 2
            local price = 2
            local param = {self.quest_id, money_type}

            local finish_func = function( param )
                TaskCC:req_rapid_finish_task(param[1], param[2])
                self.quest_id = nil;
                self.finish_quest_btn:setIsVisible(false);
            end

            -- if ( PlayerAvatar:check_is_enough_money(4,2) ) then
            local function cb_fun()
                -- print("self.quest_id",self.quest_id);
                -- TaskCC:req_rapid_finish_task(self.quest_id)
                -- self.quest_id = nil;
                -- self.finish_quest_btn:setIsVisible(false);
                MallModel:handle_auto_buy( price, finish_func, param )
            end

            SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_QUEST_QUICK_FINISH ,cb_fun,LangGameString[1457] ); -- [1457]="是否使用2元宝立即完成任务"
        else
            MUtils:show_vip_dialog(LangGameString[1458])
        end
        -- else
        --     GlobalFunc:create_screen_notic( LangGameString[1458] ); -- [1458]="仙尊三才能使用立即完成功能"
        -- end
    elseif ( self.lab_btn_name:getText() == LangGameString[829]) then -- [829]="轻松解环"
        local jhs_num = ItemModel:get_item_count_by_id(48296);
        local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
        if ( jhs_num > 0 ) then
            PaoHuanCC:req_jiehuan(money_type)
        else
            local function cb_fun()
                local price = 5
                local param = {money_type}
                local func = function( param )
                    PaoHuanCC:req_jiehuan(param[1])
                end
                MallModel:handle_auto_buy( price, func, param )
            end
            if ( is_next_not_show == false ) then
                local function swith_but_func( is_select )
                    is_next_not_show = is_select;
                end
                ConfirmWin2:show( 1, 0, LangGameString[1459],  cb_fun, swith_but_func ) -- [1459]="你的背包没有解环石，是否确定消耗5元宝或者绑元轻松解环？"
            else
                cb_fun()
            end
        end
    end
end

function MiniTaskPanel:update_kejie_task_num( num )
    local win = MiniTaskPanel:get_miniTaskPanel()
    win.task_num_lab:setText(num);

    if ( num == 0 ) then
        win.task_num_bg:setIsVisible(false);
    else
        win.task_num_bg:setIsVisible(true);
    end
end
