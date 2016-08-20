-- LoopTaskActivityPage.lua  
-- created by mwy on 2014-08-15
-- 跑环页  

super_class.LoopTaskActivityPage(Window)

local is_next_not_show = false;

local btn_state = {
	accept_task =1,--接受任务状态
	open_ring   =2,--解环状态
	deliver_task=3,--交付任务状态
}

function LoopTaskActivityPage:create(  )
	return LoopTaskActivityPage( "LoopTaskActivityPage", nil , true, 860, 500 )
end

function LoopTaskActivityPage:__init( window_name, texture_name )
	self.btn_state=0
	self:create_left_panel()
	self:create_right_panel()
	self:update_view()
end

--创建右面板
function LoopTaskActivityPage:create_right_panel()
	-- 上底
    local up_panel= CCBasePanel:panelWithFile( 584, 357+25, 260, 145,UIPIC_LoopTask_0010, 500, 500 )
    self.view:addChild(up_panel ,1)   
    --说明文字
    self.notice_dialog = CCDialogEx:dialogWithFile(8, 142, 260, 170, 1000, "", 1, ADD_LIST_DIR_UP)
    self.notice_dialog:setLineEmptySpace(6)
    self.notice_dialog:setAnchorPoint( 0, 1)
    self.notice_dialog:setText( PaoHuanModel.get_task_explain() )
    up_panel:addChild( self.notice_dialog )

    --中底
    local mid_panel= CCBasePanel:panelWithFile( 584, 150, 260, 230,UIPIC_LoopTask_0011, 500, 500 )
    self.view:addChild(mid_panel ,1)  
    -- 当前任务
    local lab_task = UILabel:create_lable_2("当前进度:", 55, 196, 18, ALIGN_CENTER)
    mid_panel:addChild(lab_task)
    --当前环数
    self.curr_huan = UILabel:create_lable_2("#cfff00010环", 130, 196, 18, ALIGN_CENTER)
    mid_panel:addChild(self.curr_huan)

    -- 任务目标
     local lab_task_point = UILabel:create_lable_2("#cfff000任务目标:", 55, 166, 18, ALIGN_CENTER)
    mid_panel:addChild(lab_task_point)
    --目标值
    self.quest_target = CCDialogEx:dialogWithFile(8, 165, 245, 52, 1000, "", 1, ADD_LIST_DIR_UP)
    self.quest_target:setLineEmptySpace(5)
    self.quest_target:setAnchorPoint( 0, 1)
    self.quest_target:setText( "")
    mid_panel:addChild( self.quest_target )

	--任务奖励 
     local lab_task_award= UILabel:create_lable_2("#cfff000任务奖励:", 55, 86, 18, ALIGN_CENTER)
    mid_panel:addChild(lab_task_award)
    --奖励制值
    self.exp_award = CCDialogEx:dialogWithFile(8, 80, 245, 52, 1000, "", 1, ADD_LIST_DIR_UP)
    self.exp_award:setLineEmptySpace(5)
    self.exp_award:setAnchorPoint( 0, 1)
    self.exp_award:setText( "经验:1000")
    mid_panel:addChild( self.exp_award )

    --传送按钮
     local function but_fun()
    	if ( self.ph_info.curr_quest_id ) then
            TaskModel:teleport_by_quest_id ( self.ph_info.curr_quest_id ,1);
        end
    end
    --UIPIC_LoopTask_009
    self.teleporte_btn=ZTextButton:create(mid_panel,"传送",UIPIC_COMMOM_001, but_fun, 155, 11,-1,-1, 1)

    --下底
    local down_panel= CCBasePanel:panelWithFile( 584, 357-230-120, 260, 142,UIPIC_LoopTask_008, 500, 500 )
    self.view:addChild(down_panel ,1)  

     local lab_desc= UILabel:create_lable_2("#cfff000可用解环石轻松轻松完成任务", 130, 91+20, 15, ALIGN_CENTER)
    down_panel:addChild(lab_desc)

    --解环石数量
	local item_id=PaoHuanModel:get_jiehuanshi_id()
    local count = ItemModel:get_item_count_by_id(item_id)
    local jhs_num = LangGameString[1935]..count..LangGameString[1936]
    self.txt_count= UILabel:create_lable_2(jhs_num, 100, 64+20, 15, ALIGN_CENTER)
    down_panel:addChild(self.txt_count)

    --领取任务、解环按钮
    local function open_fun( eventType )
        if eventType == TOUCH_CLICK then
            -- if self.state==btn_state.accept_task then
            	--接受任务状态
            	if ( self.ph_info.curr_huan_num == 0 ) then
                	PaoHuanCC:req_receive_quest();
	            else
					self:req_jiehuan();
	                
	            end
    --         elseif self.state==btn.open_ring then
    --         	--解环状态

 			-- elseif self.state==btn.deliver_task then
 			-- 	--交付任务状态

 			-- end
        end
        return true;
    end
    self.btn_jsrw = MUtils:create_btn( down_panel, UIPIC_LoopTask_002, UIPIC_LoopTask_002, open_fun,  60, 12, -1, -1)
    self.btn_lab = MUtils:create_zximg( self.btn_jsrw, UIPIC_LoopTask_003, 20,15, -1, -1)

end

-- 创建左面板
function LoopTaskActivityPage:create_left_panel()
    -- 背景容器黄底
    self.left_panel= CCBasePanel:panelWithFile( 5, 7, 580, 520,UIPIC_LoopTask_001, 500, 500 )
    self.view:addChild( self.left_panel ,1)   
     -- 背景容器黑底
	self.awards_panel = CCBasePanel:panelWithFile( 12, 132-24, 565, 388+24,UIPIC_Benefit_003, 500, 500 )
    self.awards_panel:setEnableHitTest(false)
    self.view:addChild( self.awards_panel ,2)  
    local panel = self.awards_panel

    -- 滑动图片
    -- local  scroll_pic_1 = MUtils:create_sprite(panel,UIPIC_Benefit_023,500,330)
    -- scroll_pic_1:setRotation(270)

    -- local  scroll_pic_2 = MUtils:create_sprite(panel,UIPIC_Benefit_023,500,50)
    -- scroll_pic_2:setRotation(90)

    local cell_height = 93;
    local max_number = PaoHuanModel:get_max_awards_number()
    local function createBenefitLoginCell(index,newComp)
    	local awards = {}
        local data =  PaoHuanModel:get_award_data_by_index(index)
        local net_data=nil
        if self.ph_info then
        	net_data = self.ph_info.award_state_table[index]
        end
		if not newComp then
			newComp = LoopTaskActivityCell(0, 0, 550, cell_height, data,net_data ,index)
        else
        	newComp:update(data,index,net_data)
		end
		return newComp
	end

    local function generate_num_list(max_num)
       local num_list = {}
       for i=1,max_num do
           table.insert(num_list,i)
       end
       return num_list
    end 
    local num_list = generate_num_list(max_number)

	self.scroll = TouchListVertical(5,8,610,370+24,103,3)
    self.scroll:BuildList(98,0,4,num_list,createBenefitLoginCell)
	panel:addChild(self.scroll.view);

	------------------------------------------------------------------------
	--领取按钮
	local function get_btn_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then 
            for i=1,self.ph_info.award_state_num do
                -- 如果有一个奖励可领                
                if ( self.ph_info.award_state_table[i].state == 1 ) then
                    PaoHuanCC:req_award( self.ph_info.award_state_table[i].huan_num )
                end
            end
        end
        return true
    end
	self.btn_lq=CCNGBtnMulTex:buttonWithFile(173,33,-1,-1,UIPIC_LoopTask_006)
	self.view:addChild(self.btn_lq,3)
    self.btn_lq:registerScriptHandler(get_btn_fun)
end 

--设置奖励领取状态按钮显示
function LoopTaskActivityPage:set_jl_btn_state( b )
	if b then
		self.btn_lq:addTexWithFile(CLICK_STATE_UP,UIPIC_LoopTask_006);
		self.btn_lq:setCurState(CLICK_STATE_UP)
	else
		self.btn_lq:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_LoopTask_007);
		self.btn_lq:setCurState(CLICK_STATE_DISABLE)
	end
end

--设置领取按钮状态
function LoopTaskActivityPage:set_lq_btn_state(state)
	self.btn_state=state
	if self.btn_state==btn_state.accept_task then
		--领取任务
		self.btn_lab:setTexture(UIPIC_LoopTask_003)

	elseif self.btn_state==btn_state.open_ring then
		--解环
		self.btn_lab:setTexture(UIPIC_LoopTask_004)
	elseif self.btn_state==btn_state.deliver_task then
		--交付任务	
		self.btn_lab:setTexture(UIPIC_LoopTask_005)
	end
end

--设置解环石数量
function LoopTaskActivityPage:set_jiehuanshi_count( )
    local item_id=PaoHuanModel:get_jiehuanshi_id()
    local jhs_num = ItemModel:get_item_count_by_id(item_id)
    local text = LangGameString[1935]..jhs_num..LangGameString[1936]
    self.txt_count:setText(text)
end

function LoopTaskActivityPage:update(  )
	self:update_view()
end	

function LoopTaskActivityPage:update_view(  )
	local ph_info = PaoHuanModel:get_ph_info();
    self.ph_info = ph_info;
    --背包剩余解环石
	self:set_jiehuanshi_count()
	--刷新table
	self.scroll:refresh()

	--按钮状态设置
	if ( self.ph_info.finish_huan_num ~= 200 ) then
        local  current_progress= "#cfff000"..self.ph_info.finish_huan_num..LangGameString[1938] -- [1937]="#cfff000当前进度:#c66ff66" -- [1938]="环"
        --当前环数
        self.curr_huan:setText(current_progress)
        --任务说明
        local target_str,content_str,exp_table = TaskModel:get_task_str_by_task_id( self.ph_info.curr_quest_id ,1,false)
        self.quest_target:setText(target_str)
        --奖励
        self.exp_award:setText( exp_table[1].str )
        if ( self.ph_info.curr_huan_num > 0 ) then
        	--已经接受到任务，进入解环状态
            self:set_lq_btn_state(btn_state.open_ring)
        else
        	--进入接受任务状态
        	self:set_lq_btn_state(btn_state.accept_task)
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
    for i=1,self.ph_info.award_state_num do
        -- 如果有一个奖励可领
        if ( self.ph_info.award_state_table[i].state == 1 ) then
            self:set_jl_btn_state(true)
            return;
        end
    end
    self:set_jl_btn_state(false)
end	

-- 只更新任务进度
function LoopTaskActivityPage:update_quest()
    local target_str,content_str,exp_table = TaskModel:get_task_str_by_task_id( self.ph_info.curr_quest_id ,1,false);
    self.quest_target:setText(target_str)
end
--解环请求
function LoopTaskActivityPage:req_jiehuan()
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

-- 销毁
function LoopTaskActivityPage:destroy()
    -- print("BenefitLoginPage:destroy()")
	self.scroll:destroy()
end