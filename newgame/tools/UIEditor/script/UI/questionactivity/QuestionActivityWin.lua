-- QuestionActivityWin.lua
-- created by fjh on 2013-7-17
-- 答题活动窗口
super_class.QuestionActivityWin(NormalStyleWindow)


local num_array  = {}
function QuestionActivityWin:destroy(  )
    --timerlabel 已经挪到model层
    if self.timer_lab then
        self.timer_lab:destroy();
    end

    --如果倒计时过程中也要销毁掉
 
    if self.count_down_lab then
        self.count_down_lab = nil
    end
    if self.timer then
        self.timer:stop()
    end
    Window.destroy(self);
end

function QuestionActivityWin:__init(  )
    --背景图
    local panel_bg  = CCBasePanel:panelWithFile(8, 5, 885, 570-12, UILH_COMMON.normal_bg_v2, 500, 500)
    self.view:addChild(panel_bg)
    local height = 520
    local width_left = 461
    local width_right = 389
    --左背景图
     local left_panel_bg  = CCBasePanel:panelWithFile(23, 24, 461, height, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(left_panel_bg)

    --右背景图
         local right_panel_bg  = CCBasePanel:panelWithFile(487, 24, width_right, height, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(right_panel_bg)

    
    --左边页面的上中下大小
    


    -------------题目区域---------------------------------------
    local question_panel = MUtils:create_zximg(self.view, "", 36,373, width_right, 170);

        --分割线
    ZImage:create(question_panel, UILH_COMMON.split_line, -1, 0, 435,-1)


    self.question_dialog = MUtils:create_ccdialogEx( question_panel, "",8,150,420,25,5,16);
    self.question_dialog:setAnchorPoint(0,1);





    -------------回答区域 --------------------------------------  
    local answer_panel = CCBasePanel:panelWithFile( 35,190-11,441,205,"",500,500);
    self:addChild(answer_panel);
    self.selecte_btn = {};
    local pos = {{0,63},{0,0},{205,63},{205,0}};
    for i=1,4 do
        local function btn_fun() 
               self:selected_answer_btn( i );
            return true;
        end
        local btn = UIButton:create_switch_button( pos[i][1]+17, pos[i][2]+85, 188, 30, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, "", 40, 14, 37, 33, 37, 33, btn_fun, nil, true )

        answer_panel:addChild(btn.view);
        self.selecte_btn[i] = btn;
    end  

    -- 剩余时间 
    -- local img_1	= MUtils:create_zximg(answer_panel, UIResourcePath.FileLocate.common.."quan_bg.png", 35-7, 13, 107, 19);
    local lab_1 = UILabel:create_lable_2( LH_COLOR[2]..Lang.question[1], 16, 33, 14, ALIGN_LEFT ); -- [1804]="本题剩余时间 :"
    answer_panel:addChild(lab_1);

    self.timer_lab = TimerLabel:create_label(answer_panel, 195, 134, 14, 1, nil, nil, false, ALIGN_LEFT);
    -- local timer_lab = TimerLabel:create_label(answer_panel, 195, 134, 14, 1, nil, nil, false, ALIGN_LEFT);
    -- QuestionActivityModel:set_timer_lab(timer_lab)
    -- 剩余题目
    -- local img_2 = MUtils:create_zximg(answer_panel, UIResourcePath.FileLocate.common.."quan_bg.png", 35-7+200, 13, 107, 19);
	self.question_count = UILabel:create_lable_2( LH_COLOR[2]..Lang.question[2], 208, 33, 14, ALIGN_LEFT ); -- [1805]="剩余题目 : "
    answer_panel:addChild(self.question_count);
        --分割线
    ZImage:create(answer_panel, UILH_COMMON.split_line, -2, 0, 435,3)






    -------------协助区域---------------------------------------------
    local btn_pos_y = 38
    local assistant_panel = CCBasePanel:panelWithFile( 24,17,451,175,"",500,500);
    self:addChild(assistant_panel);

    -- 自动勾选选择人数最多项
    local function assistant_1_func( eventType )
    	if eventType == TOUCH_CLICK then
            QuestionActivityModel:req_use_assistant_system( 1 )
            local model = QuestionActivityModel:get_model(  );
            if model and model.ass_1 >=1 then
                self:update_assistant_panel(model.ass_1-1,model.ass_2,model.ass_3);
                self:set_assistan_enable( false );
            end
            
    	end
    end



   
    --选择 人数最多项 
    self.assistant_btn_1 = MUtils:create_btn(assistant_panel, UILH_QUESTION.assistant_btn, UILH_QUESTION.assistant_btn, assistant_1_func,5, btn_pos_y, -1,-1);
    self.assistant_btn_1:addTexWithFile(CLICK_STATE_DISABLE,UILH_QUESTION.assistant_btn_d);
    local assistant = MUtils:create_zximg(self.assistant_btn_1,UILH_QUESTION.assistant1,11,49,-1,-1)
    --剩余
    self.ass_1_count = MUtils:create_zximg(self.assistant_btn_1, UILH_QUESTION.remain3, 37, 21, -1, -1);
    

    -- 去除俩个错误答案
    local function assistant_2_func( eventType )
    	if eventType == TOUCH_CLICK then
    		QuestionActivityModel:req_use_assistant_system( 2 )
            local model = QuestionActivityModel:get_model(  );
            if model and model.ass_2 >=1 then
                self:update_assistant_panel(model.ass_1,model.ass_2-1,model.ass_3);
                self:set_assistan_enable( false );
            end
    	end
    end
    self.assistant_btn_2 = MUtils:create_btn(assistant_panel, UILH_QUESTION.assistant_btn,UILH_QUESTION.assistant_btn, assistant_2_func,155, btn_pos_y, -1, -1);
    self.assistant_btn_2:addTexWithFile(CLICK_STATE_DISABLE,UILH_QUESTION.assistant_btn_d);

    local assistant = MUtils:create_zximg(self.assistant_btn_2,UILH_QUESTION.assistant2,11,49,-1,-1)
    self.ass_2_count = MUtils:create_zximg(self.assistant_btn_2, UILH_QUESTION.remain3, 37, 21, -1, -1);

    -- 系统自动选择正确项
    local function assistant_3_func( eventType )
		if eventType == TOUCH_CLICK then
			QuestionActivityModel:req_use_assistant_system( 3 )
            local model = QuestionActivityModel:get_model(  );
            if model and model.ass_3 >=1 then
                self:update_assistant_panel(model.ass_1,model.ass_2,model.ass_3-1);
                self:set_assistan_enable( false );
            end
		end
    end
    self.assistant_btn_3 = MUtils:create_btn(assistant_panel, UILH_QUESTION.assistant_btn,UILH_QUESTION.assistant_btn, assistant_3_func,306, btn_pos_y, -1, -1);
    self.assistant_btn_3:addTexWithFile(CLICK_STATE_DISABLE,UILH_QUESTION.assistant_btn_d);

    local assistant = MUtils:create_zximg(self.assistant_btn_3,UILH_QUESTION.assistant3,11,49,-1,-1)
    self.ass_3_count = MUtils:create_zximg( self.assistant_btn_3, UILH_QUESTION.remain3, 37, 21, -1, -1);






    -------------排行榜区域----------------------------------------
    local rank_panel = CCBasePanel:panelWithFile( 482,191-12,width_right,372,"",500,500);
    self:addChild(rank_panel);
    
    local img_bg = MUtils:create_zximg( rank_panel, UILH_NORMAL.title_bg3, 24, 309, -1, -1);
    local img_1 = MUtils:create_zximg( img_bg, UILH_QUESTION.img, 140, 12, -1, -1);
    --------------
    local img_2 = MUtils:create_zximg( rank_panel, "", 8, 272, 370,36);

    local lab_2 = UILabel:create_lable_2( LH_COLOR[2]..Lang.question[3], 36, 12, 14, ALIGN_CENTER ); -- [1806]="#cffff00名次"
    img_2:addChild(lab_2);
    local lab_3 = UILabel:create_lable_2( LH_COLOR[2]..Lang.question[4], 175, 12, 14, ALIGN_CENTER ); -- [1807]="#cffff00角色名"
    img_2:addChild(lab_3);
    local lab_4 = UILabel:create_lable_2(  LH_COLOR[2]..Lang.question[5], 322, 12, 14, ALIGN_CENTER ); -- [1808]="#cffff00分数"
    img_2:addChild(lab_4);
    -- 
    -- local coner_img = MUtils:create_zximg( rank_panel, UIResourcePath.FileLocate.common.."coner1.png", 252/2-244/2, 200-51+7, 244, 26,500,500);
    -- for i=1,4 do
    --     local img = ZImage:create( rank_panel, UIResourcePath.FileLocate.common.."fenge_bg.png", 252/2-244/2, 36*i, 244, -1);
    -- end
    self.rank_dict = {};
    local imgs = {UILH_QUESTION.top_1,UILH_QUESTION.top_2,UILH_QUESTION.top_3};

    --前五名排名
    for i=1,5 do
        if i<=3 then
            local img = MUtils:create_zximg( rank_panel, imgs[i], 30, 220-(i-1)*48, -1, -1);
        else
        	local rank_lab = UILabel:create_lable_2( LH_COLOR[2]..i, 40, 220-(i-1)*46, 18, ALIGN_LEFT );
        	rank_panel:addChild(rank_lab);
        end
        local rank_name = UILabel:create_lable_2( LH_COLOR[2].."", 183, 233-(i-1)*49, 14, ALIGN_CENTER );
    	rank_panel:addChild(rank_name);

    	local rank_score = UILabel:create_lable_2( LH_COLOR[2].."", 331, 233-(i-1)*49, 14, ALIGN_LEFT );
    	rank_panel:addChild(rank_score);
    	self.rank_dict[i] = {name = rank_name, score = rank_score};
    end
        --分割线
    ZImage:create(rank_panel, UILH_COMMON.split_line, 20, 0, 360,3)
    

    -------------信息区域----------------------------------------------------
	local info_panel = CCBasePanel:panelWithFile( 462,17,width_right,175,"" ,500,500);
    self:addChild( info_panel );

    local infos ={Lang.question[6], Lang.question[7], Lang.question[8], Lang.question[9]};
    self.info_dict = {};
    for i=1,4 do

    	local lab = UILabel:create_lable_2( LH_COLOR[2]..infos[i], 60, 130-(i-1)*32, 14, ALIGN_LEFT );
    	info_panel:addChild(lab);

    	local number = UILabel:create_lable_2( " ", 219, 130-(i-1)*32, 14, ALIGN_LEFT );
    	info_panel:addChild(number);
    	self.info_dict[i] = number;
    end 

    self:set_answer_btn_enable( false );

    local is_start = QuestionActivityModel:get_start_status(  );
    if not is_start then
        self.start_flag = MUtils:create_zximg( self.view,UILH_QUESTION.start_flag, 108, 188,-1,-1 );
    end
end



function QuestionActivityWin:active( show )
    
    if show then
        QuestionActivityModel:req_all_question_info(  )

        if self.timer_lab then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end
        self.timer_lab = TimerLabel:create_label(self.view, 170,211, 14, 0, nil, nil, false, ALIGN_LEFT);
        --将Timelabel改到model中
        -- if QuestionActivityModel:get_timer_lab() then
        --      QuestionActivityModel.get_timer_lab():destroy()
        --      local time_label = QuestionActivityModel.get_timer_lab() 
        --      time_label  = nil
        -- end
        -- local timer_lab = TimerLabel:create_label(self.view, 195, 134, 14, 1, nil, nil, false, ALIGN_LEFT);
        -- QuestionActivityModel:set_timer_lab(timer_lab)
    else 
        if self.timer_lab then
            self.timer_lab:destroy();
            self.timer_lab = nil;
        end
        
                --将Timelabel改到model中
        -- if QuestionActivityModel:get_timer_lab() then
        --      QuestionActivityModel.get_timer_lab():destroy()
        --      -- QuestionActivityModel.get_timer_lab() = nil
        --                 local time_label = QuestionActivityModel.get_timer_lab() 
        --      time_label  = nil
        -- end
        -- 关闭面板，意味着离开答题活动
        QuestionActivityModel:req_leave_activity(  );
    end

end

-- 设置答题区的enable状态
function QuestionActivityWin:set_answer_btn_enable( bool )
    if #self.selecte_btn > 0 then
        for i,v in ipairs(self.selecte_btn) do
            v.set_state(false);
            if bool then
                v.set_enable(true);
            else
                v.set_enable(false);
                v.set_color("#ca7a7a6")
            end
        end
    end
end

-- 选中了选项
function QuestionActivityWin:selected_answer_btn( index, is_commint_answer )
    
    print("选择答案",index);
    self:set_assistan_enable(false);
    self:set_answer_btn_enable(false);

    self.selecte_btn[index].set_state(true);
    if is_commint_answer == nil or is_commint_answer == true then 
        -- 提交答案
        QuestionActivityModel:req_commit_answer( index );
    end

end

-----------------界面更新
function QuestionActivityWin:update( data )

    --更新协助系统面板
    self:update_assistant_panel(data.ass_1, data.ass_2, data.ass_3)
     --更新答题面板
    self:update_question_panel(data.self_answer, data.id, data.time, data.count);
    --更新排行榜
    self:update_rank_panel( data.rank )
    --更新自己的信息
    self:update_self_info_panel( data.score, data.self_rank, data.correct_count, data.fail_count )
end

-- 更新答题面板
function QuestionActivityWin:update_question_panel( self_answer, question_id, time, count )
    -- self_answer 为当前题目已经提交过的答案，当这个参数不为0时，意味着你已经答过了，面板将被锁定
    
    -- print("更新答题面板", self_answer, question_id, time, count);
    
    local is_start = QuestionActivityModel:get_start_status(  );
    if is_start and self.start_flag ~= nil then
        self.start_flag:removeFromParentAndCleanup(true);
        self.start_flag = nil;
    end

   local question = QuestionConfig:get_question_config_by_id( question_id )

    if self_answer == 0 then
        self:set_answer_btn_enable(true);

        --将题目全部可见
        if #self.selecte_btn > 0 then
            for i,v in ipairs(self.selecte_btn) do
              v.view:setIsVisible(true)
            end
        end
        
        -- if #self.selecte_btn > 0 then
        --     for i,v in ipairs(self.selecte_btn) do
        --         v.setString(question.choose[i]);
        --     end
        -- end


  
    else 
        --已答过 那也需要现在选项

        self:selected_answer_btn( self_answer, false );
        self:set_assistan_enable(false);
    end

    if #self.selecte_btn > 0 then
            for i,v in ipairs(self.selecte_btn) do
                v.setString(question.choose[i]);
            end
        end

      self.question_count:setText(LH_COLOR[2]..Lang.question[2]..count); -- [1805]="剩余题目 : "
    local question = QuestionConfig:get_question_config_by_id( question_id )
    self.question_dialog:setText(question.des);

            if self.timer_lab then
            self.timer_lab:setText(time);
        end
        

end

-- 设置答题面板为过渡时间
function QuestionActivityWin:set_transition_status( time, correct_answer )

    self:set_assistan_enable(false);

    if correct_answer ~= 0 then
        
        -- 显示正确答案
        self:set_answer_btn_enable(false);
        self.selecte_btn[correct_answer].set_color("#cffff00");
    end

    local question_count = QuestionActivityModel:get_model( ).count;
   -- local win = UIManager:find_visible_window("menus_panel");
    
    if question_count > 0 and self.count_down_lab == nil then
        local function callback(  )
            self.count_down_lab = nil;
        end
        local flag = true
        if time >=5 then
            flag = true
        else
            flag = false
        end
        self.count_down_lab,self.timer = MUtils:create_big_count_down( self.view, 760/2, 429/2, time, callback,flag )
    end

end


-- 设置协助系统的enble
function QuestionActivityWin:set_assistan_enable( bool )
    local state ;
    if bool then
        state = CLICK_STATE_UP;
    else
        state = CLICK_STATE_DISABLE;
    end
    self.assistant_btn_1:setCurState(state);
    -- self.ass_1_count:setCurState(state);
    self.assistant_btn_2:setCurState(state);
    -- self.ass_2_count:setCurState(state);
    self.assistant_btn_3:setCurState(state);
    -- self.ass_3_count:setCurState(state);
end
-- 更新协助系统面板
function QuestionActivityWin:update_assistant_panel( ass_1, ass_2, ass_3 )
    print("更新协助系统面板", ass_1, ass_2, ass_3);

    self:set_assistan_enable(true);
    num_array = {UILH_QUESTION.remain1,UILH_QUESTION.remain2,UILH_QUESTION.remain3,UILH_QUESTION.remain0}

    if ass_1 == 0 or ass_1 == -1 then
         self.ass_1_count:setTexture(num_array[4]);
    else
         self.ass_1_count:setTexture(num_array[ass_1]);

    end

    if ass_2 == 0 or ass_2 == -1 then
         self.ass_2_count:setTexture(num_array[4]);
    else
         self.ass_2_count:setTexture(num_array[ass_2]);

    end

    if ass_3 == 0 or ass_3 == -1 then
         self.ass_3_count:setTexture(num_array[4]);
    else
         self.ass_3_count:setTexture(num_array[ass_3]);

    end



    -- self.ass_1_count:setTexture(num_array[ass_1]);
    -- self.ass_2_count:setTexture(num_array[ass_2]);
    -- self.ass_3_count:setTexture(num_array[ass_3]);

    if ass_1 <= 0 then
        self.assistant_btn_1:setCurState(CLICK_STATE_DISABLE);
        -- self.ass_1_count:setCurState(CLICK_STATE_DISABLE);

    end
    if ass_2 <= 0 then
        self.assistant_btn_2:setCurState(CLICK_STATE_DISABLE);
        -- self.ass_2_count:setCurState(CLICK_STATE_DISABLE);

    end
    if ass_3 <= 0 then
        self.assistant_btn_3:setCurState(CLICK_STATE_DISABLE);
        -- self.ass_3_count:setCurState(CLICK_STATE_DISABLE);

    end

end
-- 去除俩项目错误的答案
function QuestionActivityWin:remove_double_fail_answer( index_1, index_2 )
    if #self.selecte_btn > 0 then
        for i,v in ipairs(self.selecte_btn) do
            if i == index_1 or i == index_2 then
                v.set_enable(false);
                v.set_color("#ca7a7a6")
                v.view:setIsVisible(false)

            end
        end

    end
end



-- 更新排行榜
function QuestionActivityWin:update_rank_panel( rank_dict )

    if #rank_dict == 0 then
        for i,v in ipairs(self.rank_dict) do
            v.name:setText("");
            v.score:setText("");
        end
    else
        -- print("更新排行榜",#rank_dict);
        for i,v in ipairs(rank_dict) do
        
            self.rank_dict[i].name:setText(v.name);
            self.rank_dict[i].score:setText(v.score);
        end
    end
    
end

-- 更新自己信息面板
function QuestionActivityWin:update_self_info_panel( score, rank, correct_count, fail_count )
    -- print("更新自己信息面板",score, rank, correct_count, fail_count);
    self.info_dict[1]:setText(LH_COLOR[15]..score);
    self.info_dict[2]:setText(LH_COLOR[15]..rank);
    self.info_dict[3]:setText(LH_COLOR[15]..correct_count);
    self.info_dict[4]:setText(LH_COLOR[15]..fail_count);

end
