-- FBChallengePage.lua  
-- created by Little White on 2014-8-19
-- 新版副本挑战页  

super_class.FBChallengePage(Window)

-- 增加挑战次数是否不再提示
local show_tip = true

local panel_w = 860
local panel_h = 500

function FBChallengePage:create(  )
	return FBChallengePage( "FBChallengePage", "", false, panel_w, panel_h )
end

function FBChallengePage:__init( window_name, window_info )
	-- 所有副本节点数据
	self.node_tab = {}

    -- 左边按钮数组
    self.btn_tab = {}

    -- 保存副本连线数组
    self.line_tab ={}

	-- 副本配置数据
    local fuben_config = FBChallengeConfig:get_challenge_fuben_info()
    self.fuben_config = fuben_config

	-- 左列表
    self:create_left_panel()
    -- 右面板
    self:create_right_panel()

    self:change_page(1)
end 

function FBChallengePage:create_left_panel()
    -- 副本列表
    local list_panel = CCBasePanel:panelWithFile(108, 8, 162, 515,UIPIC_ACTIVITY_019, 500, 500);
    self.view:addChild(list_panel);

    local btn_num = #self.fuben_config

    self.bufen_scroll = CCScroll:scrollWithFile( 0, 5, 162, 505, 1, "", TYPE_HORIZONTAL, 600, 600 )

    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0 ,5, 154, 108 * btn_num, nil)

    for i=1,btn_num do
        local require_level = self.fuben_config[i].level
        local player_level = EntityManager:get_player_avatar().level
        if require_level <= player_level then
            local function did_selected_act(  )
                self:change_page(i)
            end
            local list_id = self.fuben_config[i].list_id
            local pic_selected = UIPIC_ACTIVITY_041
            local pic_unSelected = UIPIC_ACTIVITY_040

            local act_button = self:create_a_button(3, 108 * (btn_num-i), -1, -1, pic_unSelected, pic_selected, i, did_selected_act)
            self.btn_tab[i] = act_button
            self.raido_btn_group:addGroup(act_button.view)
        end
    end

    self.bufen_scroll:addItem(self.raido_btn_group)
    self.bufen_scroll:refresh()
    list_panel:addChild(self.bufen_scroll)
end

function FBChallengePage:create_a_button(pos_x, pos_y, size_w, size_h, image_n, image_s, index, func)
    local one_btn = {}
    one_btn.view =  CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    one_btn.view:addTexWithFile(CLICK_STATE_DOWN, image_s)
    -- one_btn.view:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_ACTIVITY_075)
    one_btn.index = index

    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            return true
        elseif eventType == TOUCH_CLICK then
            if index == 2 then
                -- Instruction:handleUIComponentClick(instruct_comps.HUOZHIYIZHI)
            elseif index == 3 then
                -- Instruction:handleUIComponentClick(instruct_comps.CONGWUDAO)
            end
            func(index)
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        end
    end
    one_btn.view:registerScriptHandler(but_1_fun)    --注册

    -- 按钮标题
    local list_id = self.fuben_config[index].list_id
    local list_title_pic = "ui/activity/btn_list_"..list_id..".png"
    local btn_text = ZImage.new(list_title_pic)
    btn_text:setPosition(21, 41)
    one_btn.view:addChild(btn_text.view)
    
    -- [27] = 等级
    local str = Lang.activity.fuben[27]..self.fuben_config[index].level
    local level_label = UILabel:create_lable_2(str, 77, 20, 16, ALIGN_CENTER)
    one_btn.view:addChild(level_label)

    -- local selected_frame = ZImageButton:create(one_btn.view,"", UIPIC_ACTIVITY_063, nil, -5, -5,163,96)
    -- selected_frame.view:setIsVisible(false)
    -- one_btn.selected_frame = selected_frame

    local times_bg  = CCZXImage:imageWithFile(120, 58, -1, -1,UIPIC_ACTIVITY_062)
    one_btn.view:addChild(times_bg)
    local times_label = UILabel:create_lable_2(0, 20, 11, 16, ALIGN_CENTER)
    times_bg:addChild( times_label )

    one_btn.times_label = times_label
    one_btn.times_bg = times_bg
    return one_btn
end

function FBChallengePage:create_right_panel()

	self.right_panel = CCBasePanel:panelWithFile(173, 8, 669, 515,nil, 500, 500)
    self.view:addChild(self.right_panel)

    local right_up_panel = CCBasePanel:panelWithFile(0, 78, 669, 437,UIPIC_ACTIVITY_019, 500, 500)
    self.right_panel:addChild(right_up_panel)

    local right_down_panel = CCBasePanel:panelWithFile(0,0, 669, 75,UIPIC_ACTIVITY_019, 500, 500)
    self.right_panel:addChild(right_down_panel)

    self.map_bg = CCZXImage:imageWithFile(5, 86, 658, 421,nil)
    self.right_panel:addChild(self.map_bg)

    self.award_list_bg = CCZXImage:imageWithFile(10, 415, 310, 85,UIPIC_ACTIVITY_073,500,500)
    self.right_panel:addChild(self.award_list_bg)

    -- 扫荡背景
    self.sweep_bg = CCBasePanel:panelWithFile(5, 86, 658, 40,UIPIC_ACTIVITY_073,500,500)
    self.right_panel:addChild( self.sweep_bg,9998 )
    self.sweep_bg:setIsVisible( false )

    -- 扫荡时间
    self.sweep_time_label = TimerLabel:create_label( self.sweep_bg, 45, 11, 17, 60 * 60 * 24, "#cffff00" )
    -- 扫荡说明
    -- Lang.activity.fuben[2] = "#cfff000正在扫荡%s中..."
    self.sweep_desc_label = MUtils:create_zxfont(self.sweep_bg,Lang.activity.fuben[2],411,11,1,18)

    -- 立即完成扫荡
    local function btn_immediately_fun()
        if self.fuben_info == nil then
            return 
        end    
        self:show_immediately_dialog()
    end
    self.btn_immediately = ZTextButton:create(self.sweep_bg,"",UIPIC_ACTIVITY_052,btn_immediately_fun, 185, 2, -1, -1,99999)

    -- 重置副本
    local function req_reset_fun()
        local  str = string.format("resetFubenList,%d",self.fuben_info.fbListId)
        GameLogicCC:req_talk_to_npc( 0, str)
    end


    local function btn_reset_fun()
        if self.fuben_info == nil then
            return 
        end    
        --Lang.activity.fuben[3]= "是否重置%s副本?#r重置后可以从新闯关。"
        local fuben_name = self.fuben_config[self.btn_index].fuben_name
        NormalDialog:show(string.format(Lang.activity.fuben[3],fuben_name), req_reset_fun, 1 )
    end

    --Lang.activity.fuben[4]="重置副本",
    self.btn_reset = ZTextButton:create(self.right_panel,Lang.activity.fuben[4],UIPIC_COMMOM_002,btn_reset_fun, 530, 450, -1, -1)
    self.btn_reset.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

    -- 扫荡副本
    local function btn_sweep_fun()
        if self.fuben_info == nil then
            return 
        end
        if self.fuben_info.fuben_flag == 1 then
            NormalDialog:show("当前没有可扫荡的副本",nil,2)
            return
        end
        FBSweepDialog:show(self.fuben_info,self.fuben_config[self.btn_index])
    end

    --Lang.activity.fuben[5]="扫    荡",
    self.btn_sweep = ZTextButton:create(self.right_panel,Lang.activity.fuben[5],UIPIC_COMMOM_002,btn_sweep_fun, 11, 10, -1, -1)
    self.btn_sweep.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

    --领取奖励
    local function btn_get_award_fun()
        if self.fuben_info == nil then
            return 
        end
        EntrustCC:request_get_fuben_award(self.fuben_info.fbListId)
    end

    --Lang.activity.fuben[6]="领取奖励",
    self.btn_get_award = ZTextButton:create(self.right_panel,Lang.activity.fuben[6],UIPIC_COMMOM_002,btn_get_award_fun, 11, 10, -1, -1)
    self.btn_get_award.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

    -- 副本仓库
    local function btn_sweep_storage_fun()
        if self.fuben_info == nil then
            return 
        end 
        EntrustCC:request_depot_item_list()
    end
    --Lang.activity.fuben[7]="扫荡仓库",
    self.btn_sweep_storage = ZTextButton:create(self.right_panel,Lang.activity.fuben[7],UIPIC_COMMOM_002,btn_sweep_storage_fun, 150, 10, -1, -1)
    self.btn_sweep_storage.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

    -- 增加次数
    local function btn_add_count_fun()
        if self.fuben_info == nil then
            return 
        end    

        if self.fuben_info.add_fuben_flag == 1 then
            NormalDialog:show("今天购买次数已达上限",nil,2)
            return
        end 

        local vip_info = VIPModel:get_vip_info()
        if vip_info.level>=3 then
            self:show_increase_dialog()
        else
            NormalDialog:show("VIP3以上才可以增加副本次数",nil,2)
        end 
    end
    --Lang.activity.fuben[8]="增加次数",
    self.btn_add_count = ZTextButton:create(self.right_panel,Lang.activity.fuben[8],UIPIC_COMMOM_002,btn_add_count_fun, 390, 10, -1, -1)
    self.btn_add_count.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

    -- 用来测试
    local function btn_test_fun()
        if self.fuben_info == nil then
            return 
        end    
        local fuben_result = {}
        fuben_result.grade = 3
        fuben_result.fubenId =4 
        fuben_result.elapsed_time = 45
        fuben_result.extra_param = 10
        fuben_result.award_count = 6
        fuben_result.award_list = {}

        local item_t = {[1] = {itemId=5411,count=1,binding=1},
                        [2] = {itemId=1311,count=1,binding=1},
                        [3] = {itemId=1411,count=1,binding=1},
                        [4] = {itemId=1411,count=1,binding=1},
                        [5] = {itemId=1411,count=1,binding=1},
                        [6] = {itemId=1411,count=1,binding=1},
                       }

        for i=1,fuben_result.award_count do
            fuben_result.award_list[i] = {}
            fuben_result.award_list[i].itemId = item_t[i].itemId
            fuben_result.award_list[i].count = item_t[i].count       
            fuben_result.award_list[i].binding = item_t[i].binding   
        end

        UIManager:hide_window("activity_Win")
        local win = UIManager:show_window("fb_result_win")
        if win then
            win:create_succss_panel(fuben_result)
        end 
    end
    -- self.btn_test = ZTextButton:create(self.right_panel,"测试",UIPIC_COMMOM_002,btn_test_fun, 270, 10, -1, -1)
    -- self.btn_test.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

    -- 挑战副本
    local function btn_challenge_fun()
        Instruction:handleUIComponentClick(instruct_comps.TIAOZHANG)
        if self.fuben_info == nil then
            return 
        end    

        local exp_medicine_info = { [3]={ itemId = 18210, count = 0}, -- 低级经验丹
                                    [2]={ itemId = 18211, count = 0}, -- 中级经验丹
                                    [1]={ itemId = 18219, count = 0}, -- 高级经验丹
                                    }
        local total_count = 0

        for i=1,#exp_medicine_info do
            local medicine_count = ItemModel:get_item_count_by_id(exp_medicine_info[i].itemId)
            exp_medicine_info[i].count = medicine_count
            total_count = total_count + medicine_count
        end

        -- 保存当前的切页位置，用于结算后再次打开
        FuBenModel:set_current_list_id(self.fbListId)

        if self.selected_fbid == nil then
            return
        end

        -- 背包有经验丹打开使用窗口
        if total_count>0 and self.fuben_config[self.btn_index].useAddExpItem == true then
            print("exp_medicine_info,self.selected_fbid",exp_medicine_info,self.selected_fbid)
            FBExpDialog:show(exp_medicine_info,self.selected_fbid)            
        else
            print("gggggggggggggggg1111111111111111111self.selected_fbid",self.selected_fbid)
            local  str = string.format("OnEnterFubenFunc,%d",self.selected_fbid)
            GameLogicCC:req_talk_to_npc( 0, str)
        end  
    end
    --Lang.activity.fuben[9]="   挑战",
    self.btn_challenge = ZTextButton:create(self.right_panel,Lang.activity.fuben[9],UIPIC_ACTIVITY_072,btn_challenge_fun, 530, 13, -1, -1)
    self.btn_challenge.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_ACTIVITY_074)

end 

-- 创建一子副本节点  参数：坐标   宽高   标识序列号（数字） 节点的数据
function FBChallengePage:create_fuben_node( pos_x, pos_y, width, height, index)

	local node = {} --保存生成的节点

	local node_panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, "")
	self.right_panel:addChild(node_panel)

	local function btn_node_fun(eventType,x,y)
        if  eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.FUBEN_CHALLENGE_BASE + index)
            self:update_selected(index)
            return true
        end
        return true       
    end

    local node_bottem_bg = ZImageButton:create(node_panel, "", UIPIC_ACTIVITY_066, nil, -15, -15, 108, 70)

    local selected_frame = ZImageButton:create(node_panel, "", UIPIC_ACTIVITY_030, nil, -25, -35, 127, 127)
    selected_frame.view:setIsVisible(false)

    local node_light_pic = "ui/activity/node_list_"..self.fuben_list_id..".png"
    local node_gray_pic = "ui/activity/node_list_d_"..self.fuben_list_id..".png"

	local btn_node = ZImageButton:create(node_panel, "", node_light_pic, btn_node_fun, 0, 0, width, height)
    btn_node.view:registerScriptHandler(btn_node_fun)
    btn_node.view:addTexWithFile(CLICK_STATE_DISABLE, node_gray_pic)

    local node_mark = CCZXImage:imageWithFile(12,0,-1,-1,UIPIC_ACTIVITY_070)
    node_panel:addChild(node_mark)

    local node_data = FubenConfig:get_fuben_info_by_id(self.sub_list[index].fuben_id)

   	-- 子副本名称
    -- local node_name = UILabel:create_lable_2("#cfff000"..node_data.fbname, 38, -23, 17, ALIGN_CENTER )
   	-- local node_name = Image:create( nil, -10,-30, -1, -1, UIPIC_ACTIVITY_016, 500, 500)
   	-- node_panel:addChild(node_name)

   	-- 层数
    -- local layer_text = UILabel:create_lable_2("1-3层", 52, 46, 18, ALIGN_CENTER )
	-- node_panel:addChild(layer_text)

	-- 次数
	-- local remain_text = UILabel:create_lable_2("#cfff000次数:3/3", 9, 23, 18, ALIGN_LEFT )
	-- node_panel:addChild(remain_text)

    node.index = index
    node.node_panel = node_panel
    node.node_mark = node_mark
	node.btn_node = btn_node
    node.selected_frame = selected_frame
    -- node.node_name = node_name
    node.layer_text = layer_text
    node.remain_text = remain_text
    node.node_data = node_data

    table.insert(self.node_tab,node)
    return node
end

-- 显示增加次数对话框
function FBChallengePage:show_increase_dialog()
    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local param = { [1]= self.fuben_info.fbListId ,[2] = money_type}

    local cost = FubenConfig:get_cost_by_listId(self.fuben_info.fbListId)
    local fuben_name = self.fuben_config[self.btn_index].fuben_name

    local increase_func = function( param )
        MiscCC:req_add_fuben_count(param[1],param[2])
    end

    if ( show_tip ) then
        local function fun( _show_tip )
            MallModel:handle_auto_buy(cost, increase_func, param )
        end
        local function swith_but_func ( _show_tip )
            show_tip = not _show_tip;
        end
        --Lang.activity.fuben[10]="是否消耗%d元宝/绑元增加1次%s副本的挑战?",
        local str = string.format(Lang.activity.fuben[10],cost,fuben_name)
        ConfirmWin2:show( 4, nil, str, fun, swith_but_func ) 
    else
        MallModel:handle_auto_buy( cost, increase_func, param )
    end
end

function FBChallengePage:show_immediately_dialog()
    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local param = { [1]= self.fuben_info.fbListId ,[2] = money_type}

    print("self.sweep_time_label:getRemainTime()",self.sweep_time_label:getRemainTime())

    local remain_time = self.sweep_time_label:getRemainTime()
    local cost = math.ceil(remain_time / ( 5 * 60 )) * 2
    local fuben_name = self.fuben_config[self.btn_index].fuben_name

    local immediately_func = function( param )
        EntrustCC:request_immediately_sweep(param[1],param[2])
    end

    if ( show_tip ) then
        local function fun( _show_tip )
            MallModel:handle_auto_buy(cost, immediately_func, param )
        end
        local function swith_but_func ( _show_tip )
            show_tip = not _show_tip
        end
        --Lang.activity.fuben[11]= "是否消耗%d元宝/绑元立即完成%s副本的挑战?"
        local str = string.format(Lang.activity.fuben[11],cost,fuben_name)
        ConfirmWin2:show( 4, nil, str, fun, swith_but_func ) 
    else
        MallModel:handle_auto_buy(cost,immediately_func, param )
    end
end

-- 根据给出的两个点计算两个点之间的长度和角度
function FBChallengePage:calculate_angle_and_lenght(p1,p2,radius)
    local v1 = (p1.x - p2.x) * (p1.x - p2.x) + (p1.y-p2.y) * (p1.y-p2.y)
    local lenght = math.sqrt(v1)
    local v = (math.abs(p1.x - p2.x)) / lenght
    -- local v = (-(p1.x - p2.x)) / lenght;
    local angle = math.deg(math.acos(v))
    
    if( p2.y > p1.y) then
        angle = 360 - angle
    end
    -- 因为p1,p2，是两个圆的中心点，lenght是两个中心点的长度，然后需求是求两个圆边角连线的长度，所以要减去圆的半径乘于2
    lenght = lenght - radius * 2
    return lenght,angle
end

-- 根据圆的中心点坐标，半径，和角度，计算圆边线上的坐标
function FBChallengePage:calculate_ccp_by_radius_and_angle(p1,p2,radius,angle)

    local result_x,result_y = 0
    if( angle <= 90) then
        -- 角度转弧度
        local rad = math.rad(angle);
        -- 半径12.5
        result_x = math.cos(rad) * radius;
        result_y = math.sin(rad) * radius;
        result_y = - result_y;

    elseif ( angle <= 180) then 
        angle = angle - 90;
        -- 角度转弧度
        local rad = math.rad(angle);
        result_y = math.cos(rad) * radius;
        result_x = math.sin(rad) * radius;
        result_y = - result_y;
        result_x = - result_x;

    elseif (angle <= 270) then
        angle = angle - 180;
        -- 角度转弧度
        local rad = math.rad(angle);
        result_x = math.cos(rad) * radius;
        result_y = math.sin(rad) * radius;
        result_x = - result_x;

    elseif (angle <= 360) then
        angle = 360 - angle;
        -- 角度转弧度
        local rad = math.rad(angle);
        result_x = math.cos(rad) * radius;
        result_y = math.sin(rad) * radius;
    end

    --print("result_x = ".. result_x.."  result_y= "..result_y);
    local result_p1 = CCPoint(p1.x + result_x,p1.y + result_y);
    -- result_x = math.cos(360-90-angle) * radius;
    -- result_y = math.sin(360-90-angle) * radius;
    -- local result_p2 = CCPoint(p2.x + result_x)
    return result_p1;
end

function FBChallengePage:update( update_type ,data)
    print("FBChallengePage:update(update_type,data)",update_type,data)
    if update_type == "fuben_times" then
        self:update_fuben_times()
    elseif update_type == "fuben_data" then
        self:update_fuben_data(data)
    elseif update_type == "change_page" then
        self:change_page(data)
    elseif update_type == "fuben_status" then
        self:update_fuben_status()
    end 
end 

function FBChallengePage:update_fuben_status()
    for i=1,#self.btn_tab do
        if i~= self.btn_index then
            local require_level = self.fuben_config[i].level
            local player_level = EntityManager:get_player_avatar().level
            if player_level<require_level then
                self.btn_tab[i].times_bg:setIsVisible(false)
                self.btn_tab[i].view:setCurState(CLICK_STATE_DISABLE)
            else
                self.btn_tab[i].times_bg:setIsVisible(true)
                self.btn_tab[i].view:setCurState(CLICK_STATE_UP)
            end 
        else
            self.btn_tab[i].view:setCurState(CLICK_STATE_DOWN)
        end 
    end
end

function FBChallengePage:update_fuben_times()
    print("FBChallengePage:update_fuben_times()")
    local x = 1
    for i=1,#self.btn_tab do
        local list_id = fuben_challenge_config[i].list_id
        local remain_count = FuBenModel:get_fuben_remain_count_by_listId(list_id)
        self.btn_tab[i].times_label:setText(remain_count)
    end
end

function FBChallengePage:update_fuben_data( fuben_info )
	-- 服务下发副本数据
    print("!!!!!FBChallengePage:update( update_type )",fuben_info)
    self.fuben_info = fuben_info
    if self.fuben_info then
        self.fbListId = self.fuben_info.fbListId

        for i=1,#self.node_tab do
            if i < self.fuben_info.progress + 1 then
                self.node_tab[i].btn_node:setCurState(CLICK_STATE_UP)
                self.node_tab[i].node_mark:setTexture(UIPIC_ACTIVITY_071)
            else
                if  i <= self.fuben_info.available_progress or i == self.fuben_info.progress+1 then
                    self.node_tab[i].btn_node:setCurState(CLICK_STATE_UP)
                    self.node_tab[i].node_mark:setTexture("")
                else
                    self.node_tab[i].btn_node:setCurState(CLICK_STATE_DISABLE)
                    self.node_tab[i].node_mark:setTexture(UIPIC_ACTIVITY_070)
                end 
            end
        end

        for i=1,#self.line_tab do
            if i < self.fuben_info.available_progress+1 then
                for j=1,#self.line_tab[i].dot_tab do 
                    self.line_tab[i].dot_tab[j]:setTexture(UIPIC_ACTIVITY_064)
                end    
            else
                for j=1,#self.line_tab[i].dot_tab do 
                    self.line_tab[i].dot_tab[j]:setTexture(UIPIC_ACTIVITY_065)
                end  
            end 
        end 
    
        if self.fuben_info.progress + 1 <= self.fuben_info.count then
            self:update_selected(self.fuben_info.progress + 1)
        -- else
        --     self:update_selected(self.fuben_info.count)
        end 

        if self.fuben_info.sweep_flag == 0 then
            --0：不在扫荡
            self.btn_sweep.view:setIsVisible(true)
            self.btn_get_award.view:setIsVisible(false)
            self.sweep_bg:setIsVisible(false)
        elseif self.fuben_info.sweep_flag == 1 then
            --1：正在扫荡中
            self.btn_sweep.view:setIsVisible(true)
            self.btn_get_award.view:setIsVisible(false)
            self.sweep_bg:setIsVisible(true)

            if self.sweep_time_label then 
                self.sweep_time_label:destroy()
                self.sweep_time_label = nil
            end

            -- 扫荡时间
            local remain_time = self.fuben_info.sweep_remain_time
            if remain_time > 0 then                     
                self.sweep_time_label = TimerLabel:create_label( self.sweep_bg, 45, 11, 17,remain_time, "#cffff00" )
            end

            -- 扫荡说明        
            local fuben_name = self.fuben_config[self.btn_index].fuben_name
            local sweep_count = self.fuben_info.sub_list[1].remainCount  
            local str = string.format("#cfff000"..Lang.activity.fuben[2],fuben_name)
            self.sweep_desc_label:setText(str)

        else
            --2：可领取扫荡奖励
            self.btn_sweep.view:setIsVisible(false)
            self.btn_get_award.view:setIsVisible(true)
            self.sweep_bg:setIsVisible(false)
        end

        -- 1表示不可操作
        if self.fuben_info.fuben_flag == 1 then
            self.btn_challenge:setCurState(CLICK_STATE_DISABLE)
            -- self.btn_sweep:setCurState(CLICK_STATE_DISABLE)
            -- self.btn_sweep_storage:setCurState(CLICK_STATE_DISABLE)
            self.btn_reset:setCurState(CLICK_STATE_DISABLE)
        else
            self.btn_challenge:setCurState(CLICK_STATE_UP)
            -- self.btn_sweep:setCurState(CLICK_STATE_UP)
            -- self.btn_sweep_storage:setCurState(CLICK_STATE_UP)
            self.btn_reset:setCurState(CLICK_STATE_UP)
        end

        if self.fuben_info.available_progress == 0 then
            self.btn_sweep:setCurState(CLICK_STATE_DISABLE)
        end 

    end
end

-- 切副本
function FBChallengePage:change_page( btn_index )
	self.btn_index = btn_index

	self:initialize_by_list_id(btn_index)

	-- 请求数据
	local  str = string.format("ShowFubenList,%d",self.fuben_config[btn_index].list_id)
    GameLogicCC:req_talk_to_npc( 0, str)

    -- 选中显示选中框
    -- for key,value in ipairs(self.btn_tab) do 
    --     if self.btn_tab[key].index == btn_index then
    --         self.btn_tab[key].selected_frame.view:setIsVisible(true)
    --     else
    --         self.btn_tab[key].selected_frame.view:setIsVisible(false)
    --     end
    -- end
    self.raido_btn_group:selectItem(btn_index-1)
    -- self:update_fuben_status()
end

-- 更新选择状态
function FBChallengePage:update_selected(selected_index)
    for key,value in ipairs(self.node_tab) do
        if self.node_tab[key].index == selected_index then
            -- print(" %%%%%%%%%%%%%%%FBChallengePage:update_selected(selected_index)", selected_index)
            self.selected_index = selected_index
            self.selected_fbid = self.node_tab[key].node_data.fbid
            self.selected_node = self.node_tab[key]
            -- self.node_tab[key].selected_frame.view:setIsVisible(true)
            self.node_tab[key].node_mark:setTexture(UIPIC_ACTIVITY_069)
            self.node_tab[key].node_mark:setPosition(18,80)
            LuaEffectManager:run_move_animation(3, self.node_tab[key].node_mark)
        else
            self.node_tab[key].node_mark:setPosition(18,3)
            self.node_tab[key].node_mark:stopAllActions()
            -- self.node_tab[key].selected_frame.view:setIsVisible(false)
        end
    end
end

-- 读配置初始化界面
function FBChallengePage:initialize_by_list_id( btn_index )
    print("FBChallengePage:initialize_by_list_id( btn_index )",btn_index)
    if btn_index then
        self.fuben_list_id = self.fuben_config[btn_index].list_id
        self.sub_list = self.fuben_config[btn_index].sub_list
        self.line_list = self.fuben_config[btn_index].line_list

        -- 创建关卡路径
        for i=1,#self.line_tab do 
            for j=1,#self.line_tab[i].dot_tab do
                self.line_tab[i].dot_tab[j]:removeFromParentAndCleanup(true)
            end
            self.line_tab[i].line:removeFromParentAndCleanup(true)
        end

        self.line_tab = {}
        if self.line_list then
            for i=1,#self.line_list do
                self.line_tab[i] = {}
                local line_path = "ui/activity/line_list_"..self.fuben_list_id.."_"..i..".png"
                local line = CCZXImage:imageWithFile(self.line_list[i].x, self.line_list[i].y,-1,-1,line_path)
                self.right_panel:addChild(line)
                self.line_tab[i].line = line 
                self.line_tab[i].dot_tab = {}
                if self.line_list[i].dot_list then
                    for j=1,#self.line_list[i].dot_list do
                        local dot = CCZXImage:imageWithFile(self.line_list[i].dot_list[j].x, self.line_list[i].dot_list[j].y,-1,-1,UIPIC_ACTIVITY_064)
                        self.right_panel:addChild(dot)
                        self.line_tab[i].dot_tab[j] = dot
                    end  
                end  
            end
        end 
     
        for i=1,#self.node_tab do
            self.node_tab[i].node_panel:removeFromParentAndCleanup(true)
        end

        self.node_tab = {}

        local node_width = 80
        local node_height = 80

        -- 创建关卡关点
        for i=1,#self.sub_list do
            local node = self:create_fuben_node(self.sub_list[i].x,self.sub_list[i].y,node_width,node_height,i)
            node.node_panel:setCurState(CLICK_STATE_DISABLE)
        end

        --地图背景图
        local mag_bg_path = "ui/activity/fuben_bg_"..self.fuben_list_id..".png"
	    self.map_bg:setTexture(mag_bg_path)

	    -- 奖励列表
	    self.right_panel:removeChild( self.award_item_list, true)
        local item_t = ActivityModel:get_fuben_activity_award_items( self.fuben_config[self.btn_index].activity_id )
        if #item_t > 0 then
            self.award_item_list = self:create_item_scroll( item_t , 15, 420, 300, 75, 4,1,"")
            self.right_panel:addChild( self.award_item_list )
            self.award_list_bg:setIsVisible(true)
        else
            self.award_list_bg:setIsVisible(false)
        end

        self.selected_index = 1 
        self.selected_fbid = nil
   end
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function FBChallengePage:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    require "UI/activity/ActivityCommon"
    local scroll = ActivityCommon:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    return scroll
end

-- 销毁
function FBChallengePage:destroy(  )
    if self.sweep_time_label then 
        self.sweep_time_label:destroy()
        self.sweep_time_label = nil 
    end
    Window.destroy(self)
    UIManager:destroy_window("fb_storage_win")
end