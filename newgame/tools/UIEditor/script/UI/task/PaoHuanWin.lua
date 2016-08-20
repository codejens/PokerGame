-- PaoHuanWin.lua
-- create by hcl on 2013-4-8
-- 跑环界面

super_class.PaoHuanWin(NormalStyleWindow)

-- icon_state 图标状态
-- total_huan_num 总环数   
-- finish_huan_num 已完成环数
-- curr_huan_num 当前环数
-- curr_quest_id 当前环任务id
-- curr_award_huan_num 当前可领奖的最高环数
-- award_table 领奖情况

local is_next_not_show = false;

-- local btn_state = {
--     accept_task =1,--接受任务状态
--     open_ring   =2,--解环状态
--     deliver_task=3,--交付任务状态
-- }

function PaoHuanWin:show(  )
    local win = UIManager:show_window("pao_huan_win");
    if ( win ) then
  
        win:update_view(  );
    end
end

function PaoHuanWin:__init()
    -- 大背景
    local bg = CCZXImage:imageWithFile(5,5,889,568,UILH_COMMON.normal_bg_v2,500,500)
    self.view:addChild(bg)

    -- self.btn_state=0
    self:create_left_panel()
    self:create_right_panel()
    self:update_view()
end

--创建右面板
function PaoHuanWin:create_right_panel()
    -- 背景容器
    self.right_panel = CCBasePanel:panelWithFile( 635, 16, 247, 545,UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild( self.right_panel ,1)   

    --说明文字
    self.notice_dialog = CCDialogEx:dialogWithFile(8, 543, 235, 170, 1000, "", 1, ADD_LIST_DIR_UP)
    self.notice_dialog:setFontSize(14)
    self.notice_dialog:setLineEmptySpace(6)
    self.notice_dialog:setAnchorPoint( 0, 1)
    self.notice_dialog:setText( PaoHuanModel.get_task_explain() )
    self.right_panel:addChild( self.notice_dialog )

    -- 当前任务
    local title_bg = CCZXImage:imageWithFile( 0, 350, 247, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.right_panel:addChild(title_bg)
    MUtils:create_zxfont(title_bg,Lang.paohuan[17],247/2,12,2,16)    -- [17] = #cfff000当前进度

    --当前环数
    self.curr_huan = UILabel:create_lable_2("", 8, 330, 15, ALIGN_LEFT)
    self.right_panel:addChild(self.curr_huan)

    -- 任务目标
    local title_bg = CCZXImage:imageWithFile( 0, 260, 247, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.right_panel:addChild(title_bg)
    MUtils:create_zxfont(title_bg,Lang.paohuan[16],247/2,12,2,16)    -- [16] = #cfff000任务目标

    --目标值
    self.quest_target = CCDialogEx:dialogWithFile(8, 260, 237, 52, 1000, "", 1, ADD_LIST_DIR_UP)
    self.quest_target:setLineEmptySpace(5)
    self.quest_target:setAnchorPoint( 0, 1)
    self.quest_target:setText( "")
    self.right_panel:addChild( self.quest_target )

    --任务奖励 
    local title_bg = CCZXImage:imageWithFile( 0, 140, 247, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.right_panel:addChild(title_bg)
    MUtils:create_zxfont(title_bg,Lang.paohuan[15],247/2,12,2,16)    -- [15] = #cfff000任务奖励

    --奖励制值
    self.exp_award = CCDialogEx:dialogWithFile(8, 143, 245, 52, 1000, "", 1, ADD_LIST_DIR_UP)
    self.exp_award:setLineEmptySpace(5)
    self.exp_award:setAnchorPoint( 0, 1)
    self.exp_award:setText(Lang.paohuan[14])    --[14] = "#cd0cda2经验:#cffffff"
    self.right_panel:addChild( self.exp_award )

    --传送按钮
     local function but_fun()
        if ( self.ph_info.curr_quest_id ) then
            TaskModel:teleport_by_quest_id ( self.ph_info.curr_quest_id ,1);
        end
    end
    self.teleporte_btn = ZButton:create(self.right_panel, UILH_MAIN.foot, but_fun, 197, 178);
    -- 分割线
    local line = CCZXImage:imageWithFile( 5, 90, 240, 3, UILH_COMMON.split_line )
    self.right_panel:addChild(line)

    --解环石数量
    local item_id=PaoHuanModel:get_jiehuanshi_id()
    local count = ItemModel:get_item_count_by_id(item_id)
    local jhs_num = string.format(Lang.paohuan[12],count)   -- [12] = "#cd0cda2背包剩余解环石#cffffff%d#cd0cda2个"
    self.txt_count= UILabel:create_lable_2(jhs_num, 247/2, 68, 15, ALIGN_CENTER)
    self.right_panel:addChild(self.txt_count)

    --领取任务、解环按钮
    local function open_fun( eventType )
        if eventType == TOUCH_CLICK then
            if ( self.ph_info.curr_huan_num == 0 ) then
                PaoHuanCC:req_receive_quest();
            else
                self:req_jiehuan();
            end
        end
        return true;
    end
    self.btn_jsrw = MUtils:create_btn( self.right_panel, UILH_COMMON.btn4_nor, UILH_COMMON.btn4_sel, open_fun,  63, 7, -1, -1)
    self.label_jsrw = MUtils:create_zxfont(self.btn_jsrw,Lang.paohuan[10],121/2,21,2,15)  -- [10]=接受任务
    -- self.btn_lab = MUtils:create_zximg( self.btn_jsrw, UIPIC_LoopTask_003, 20,15, -1, -1)
end

-- 创建左面板
function PaoHuanWin:create_left_panel()
    -- 背景容器
    self.left_panel = CCBasePanel:panelWithFile( 16, 16, 617, 545,UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild( self.left_panel ,1)   

    -- 改为不滑动式了
    local top_y = 548
    local row_space = 77
    local left_x = 10 
    local item_x = left_x + 175
    local btn_x = left_x + 540
    local title_text = {Lang.paohuan[1],Lang.paohuan[2],Lang.paohuan[3],Lang.paohuan[4],Lang.paohuan[5],Lang.paohuan[6],Lang.paohuan[7],}
    self.btn_lq = {}
    self.label_lq = {}
    for t=1,7 do
        -- 标题
        MUtils:create_zxfont(self.left_panel,title_text[t],left_x,top_y - row_space*t + 23,1,15);
        -- 奖励item部分
        local data = PaoHuanModel:get_award_data_by_index(t)
        local  data_num = #data
        for i=1,data_num do
            local award = data[i]
            local slot  = SlotItem(60, 60) 
            slot:set_icon_bg_texture( UILH_COMMON.slot_bg2 , -1, -1, 62, 62 )     
            slot:set_lock( false )

            if award then
                slot:set_icon_ex( award.id )
                slot:set_color_frame( award.id, -1, -1, 62, 62 )    -- 边框颜色
                slot:set_item_count(award.count)
                if award.effect==1 then
                    --播放特效
                    local _effect =slot:play_activity_effect(award.effectId)
                    _effect:setScale(0.9)
                    _effect:setPosition(30,30)
                end
                if ( award.bind == 1 ) then
                    slot:set_lock( true )
                else
                    slot:set_lock( false )
                end
            end

            local function fun(...)
                local a, b, args = ...
                local click_pos = Utils:Split(args, ":")
                local world_pos = slot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                
                if award and award.id  then
                    TipsModel:show_shop_tip( world_pos.x, world_pos.y, award.id )
                    -- TipsModel:show_shop_tip( 400, 240, award.id )
                end
            end
            slot:set_click_event( fun )
            self.left_panel:addChild(slot.view)
            slot:setPosition( 70*(i-1)+item_x, top_y - row_space*t)
        end

        -- 领取按钮
        local function get_btn_fun( eventType, x, y )
            if eventType == TOUCH_CLICK then 
                if self.ph_info.award_state_table[t] and self.ph_info.award_state_table[t].state == 1 then
                    PaoHuanCC:req_award( self.ph_info.award_state_table[t].huan_num )
                end
                -- for i=1,self.ph_info.award_state_num do
                --     -- 如果有一个奖励可领                
                --     if ( self.ph_info.award_state_table[i].state == 1 ) then
                --         PaoHuanCC:req_award( self.ph_info.award_state_table[i].huan_num )
                --     end
                -- end
            end
            return true
        end
        self.btn_lq[t]=CCNGBtnMulTex:buttonWithFile(btn_x,top_y - row_space*t+25,-1,-1,UILH_COMMON.button4)
        self.btn_lq[t]:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis);
        self.btn_lq[t]:setCurState(CLICK_STATE_UP)
        self.view:addChild(self.btn_lq[t],3)
        self.btn_lq[t]:registerScriptHandler(get_btn_fun)
        -- 按钮上文字
        self.label_lq[t] = MUtils:create_zxfont(self.btn_lq[t],Lang.paohuan[8],77/2,13,2,15);   -- [8]=领取

        -- 分割线
        if t < 7 then
            local line = CCZXImage:imageWithFile( left_x, top_y - row_space*t - 10, 600, 3, UILH_COMMON.split_line )
            self.left_panel:addChild(line)
        end
    end


    -- local cell_height = 93;
    -- local max_number = PaoHuanModel:get_max_awards_number()
    -- local function createBenefitLoginCell(index,newComp)
    --     local awards = {}
    --     local data =  PaoHuanModel:get_award_data_by_index(index)
    --     local net_data=nil
    --     if self.ph_info then
    --         net_data = self.ph_info.award_state_table[index]
    --     end
    --     if not newComp then
    --         newComp = LoopTaskActivityCell(0, 0, 550, cell_height, data,net_data ,index)
    --     else
    --         newComp:update(data,index,net_data)
    --     end
    --     return newComp
    -- end

    -- local function generate_num_list(max_num)
    --    local num_list = {}
    --    for i=1,max_num do
    --        table.insert(num_list,i)
    --    end
    --    return num_list
    -- end 
    -- local num_list = generate_num_list(max_number)

    -- self.scroll = TouchListVertical(5,8,610,520,103,3)
    -- self.scroll:BuildList(98,0,6,num_list,createBenefitLoginCell)
    -- self.left_panel:addChild(self.scroll.view);

    -- ------------------------------------------------------------------------
    -- --领取按钮
    -- local function get_btn_fun( eventType, x, y )
    --     if eventType == TOUCH_CLICK then 
    --         for i=1,self.ph_info.award_state_num do
    --             -- 如果有一个奖励可领                
    --             if ( self.ph_info.award_state_table[i].state == 1 ) then
    --                 PaoHuanCC:req_award( self.ph_info.award_state_table[i].huan_num )
    --             end
    --         end
    --     end
    --     return true
    -- end
    -- self.btn_lq=CCNGBtnMulTex:buttonWithFile(173,33,-1,-1,UIPIC_LoopTask_006)
    -- self.btn_lq:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_LoopTask_007);
    -- self.btn_lq:setCurState(CLICK_STATE_UP)
    -- self.view:addChild(self.btn_lq,3)
    -- self.btn_lq:registerScriptHandler(get_btn_fun)
end 

--设置奖励领取状态按钮显示
-- function PaoHuanWin:set_jl_btn_state( b )
    -- if b then
        -- self.btn_lq:setCurState(CLICK_STATE_UP)
    -- else
        -- self.btn_lq:setCurState(CLICK_STATE_DISABLE)
    -- end
-- end

--设置领取按钮状态
-- function PaoHuanWin:set_lq_btn_state(state)
--     self.btn_state=state
--     if self.btn_state==btn_state.accept_task then
--         --领取任务
--         self.btn_lab:setTexture(UIPIC_LoopTask_003)

--     elseif self.btn_state==btn_state.open_ring then
--         --解环
--         self.btn_lab:setTexture(UIPIC_LoopTask_004)
--     elseif self.btn_state==btn_state.deliver_task then
--         --交付任务  
--         self.btn_lab:setTexture(UIPIC_LoopTask_005)
--     end
-- end

--设置解环石数量
function PaoHuanWin:set_jiehuanshi_count( )
    local item_id=PaoHuanModel:get_jiehuanshi_id()
    local jhs_num = ItemModel:get_item_count_by_id(item_id)
    local text = string.format(Lang.paohuan[12],jhs_num)   -- [12] = "#cd0cda2背包剩余解环石#cffffff%d#cd0cda2个"
    self.txt_count:setText(text)
end

function PaoHuanWin:update(  )
    self:update_view()
end

function PaoHuanWin:update_view(  )
    local ph_info = PaoHuanModel:get_ph_info();
    self.ph_info = ph_info;
    --背包剩余解环石
    self:set_jiehuanshi_count()
    --刷新table
    -- self.scroll:refresh();

    --按钮状态设置
    if ( self.ph_info.finish_huan_num ~= 200 ) then
        local current_progress = string.format(Lang.paohuan[18],self.ph_info.finish_huan_num,self.ph_info.finish_huan_num)  -- [18]="#cd0cda2当前进度：#cffffff第%d环#c00ff12(%d/200)"
        --当前环数
        self.curr_huan:setText(current_progress); 
        --任务说明
        local target_str,content_str,exp_table = TaskModel:get_task_str_by_task_id( self.ph_info.curr_quest_id ,1,false);
        self.quest_target:setText(target_str)

        --奖励
        local info = TaskModel:get_info_by_task_id( self.ph_info.curr_quest_id );
        self.exp_award:setText(Lang.paohuan[14]..info.awards[1].count)
        -- self.exp_award:setText( exp_table[1].str );
        if ( self.ph_info.curr_huan_num > 0 ) then
            --已经接受到任务，进入解环状态
            self.label_jsrw:setText(Lang.paohuan[11])   -- [11]="轻松解环"
            -- self:set_lq_btn_state(btn_state.open_ring)
        else
            --进入接受任务状态
            self.label_jsrw:setText(Lang.paohuan[10])   -- [10]="接受任务"
            -- self:set_lq_btn_state(btn_state.accept_task)
        end

        self.btn_jsrw:setIsVisible(true);
        self.teleporte_btn.view:setIsVisible(true);
    else
        self.curr_huan:setText("");
        self.quest_target:setText("")
        self.exp_award:setText( "" );
        self.btn_jsrw:setIsVisible(false);
        self.teleporte_btn.view:setIsVisible(false);
    end
    -- for i=1,self.ph_info.award_state_num do
    --     -- 如果有一个奖励可领
    --     if ( self.ph_info.award_state_table[i].state == 1 ) then
    --         self:set_jl_btn_state(true)
    --         return;
    --     end
    -- end
    -- self:set_jl_btn_state(false)
    for i=1,self.ph_info.award_state_num do
        if (self.ph_info.award_state_table[i].state == 0) then -- 不可领取
            self.btn_lq[i]:setCurState(CLICK_STATE_DISABLE)
            self.label_lq[i]:setText(Lang.paohuan[8])   --[8]="领取"
        elseif (self.ph_info.award_state_table[i].state == 1) then
            self.btn_lq[i]:setCurState(CLICK_STATE_UP)  -- 可以领取
            self.label_lq[i]:setText(Lang.paohuan[8])   --[8]="领取"
        elseif (self.ph_info.award_state_table[i].state == 2) then
            self.btn_lq[i]:setCurState(CLICK_STATE_DISABLE) -- 已经领取
            self.label_lq[i]:setText(Lang.paohuan[9])   --[9]="已领取"
        end
    end
end
-- 只更新任务进度
function PaoHuanWin:update_quest()
    local target_str,content_str,exp_table = TaskModel:get_task_str_by_task_id( self.ph_info.curr_quest_id ,1,false);
    self.quest_target:setText(target_str)
end

--
function PaoHuanWin:active( show )
    if show then

    else

    end
end

function PaoHuanWin:req_jiehuan()
    local jhs_num = ItemModel:get_item_count_by_id(48296);
    if ( jhs_num > 0 ) then
        PaoHuanCC:req_jiehuan()
    else
        if ( PlayerAvatar:check_is_enough_money(4,5) ) then
            if ( is_next_not_show == false ) then
                local function cb_fun()
                    PaoHuanCC:req_jiehuan()
                end
                local function swith_but_func( is_select )
                    is_next_not_show = is_select;
                end
                ConfirmWin2:show( 1, 0, Lang.paohuan[19],  cb_fun, swith_but_func ) -- [1459]="你的背包没有解环石，是否确定消耗5元宝轻松解环？"
            else
                PaoHuanCC:req_jiehuan()
            end
        end
    end
end

function PaoHuanWin:destroy()
    -- self.scroll:destroy()
end