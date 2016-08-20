-- DailyWelfareRD.lua  
-- created by lyl on 2013-3-5
-- 副本累积页 右下面板

super_class.DailyWelfareRD(Window)

function DailyWelfareRD:create( width, height )
    return DailyWelfareRD( "DailyWelfareRD", UILH_COMMON.bottom_bg , true, width, height)
end

local  move_x = 30
local btn_pos_x = 0
local btn_pos_y = 0 

local btn_pos_x2 = 0
local btn_pos_y2 = 0 

function DailyWelfareRD:__init( window_name, texture_name )
    self.current_page_index = 1         -- 当前页数。 1 副本经验  2： 日常任务经验
    self.get_way_index      = 1         --副本累积 获取方式   1：免费  2：元宝
    self.rc_get_way_index   = 1         --日常累积 获取方式  1 ：免费  2 元宝

    local panel = self.view
    

    --标题
    local title_bg = CCZXImage:imageWithFile( 33, 444, -1, -1, UILH_NORMAL.title_bg3, 500, 500 )
    -- local title_name =  UILabel:create_lable_2(Lang.benefit.welfare[23], 67, 9, font_size, ALIGN_LEFT ) 
    -- title_bg:addChild(title_name)
    local title_bg_size = title_bg:getSize()
    local title_name = CCZXImage:imageWithFile( 0, 0, -1, -1, UI_WELFARE.fuben_leiji_title, 500, 500 )
    local title_name_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_name_size.width/2,title_bg_size.height/2 - title_name_size.height/2)
    title_bg:addChild(title_name)
    panel:addChild(title_bg)

   --上面板
   self:create_panel_up(panel)

    --分割线
    ZImage:create(panel, UI_WELFARE.split_line,10, 225, 203*2,3)

    self:create_panel_dwon(panel)
end


--创建上方的面板
function DailyWelfareRD:create_panel_up( panel )  

 --副本累积panel
    local panel1 = CCBasePanel:panelWithFile(0, 220, 425, 225, "", 500, 500)
    panel:addChild(panel1)
    
    --副本累积title
    local text_bg =  ZImageImage:create( panel1,UI_WELFARE.fubenleiji,UI_WELFARE.text_bg,116, 184 , 190, -1,500,500 )

    --累积次数
    local accumulation_count = 0
    self.accumulation_count_lable = UILabel:create_lable_2( Lang.benefit.welfare[2]..accumulation_count..LangGameString[601], 13+move_x, 158, 14,  ALIGN_LEFT ) -- [600]="#c66ff66积累次数:#cffff00" -- [601]="#c66ff66次"
    panel1:addChild( self.accumulation_count_lable )

    --可获得经验
    local can_get_exp = 99999999
    self.can_get_exp_lable = UILabel:create_lable_2( Lang.benefit.welfare[3]..can_get_exp, 13+move_x, 134, 14, ALIGN_LEFT ) -- [574]="#c66ff66可获得经验:#cffff00"
    panel1:addChild( self.can_get_exp_lable )
    
    --tip
    local function tip_but_fun1( eventType,x,y )
            if eventType == TOUCH_CLICK then
           self.current_page_index = 1
           local tip_data = WelfareModel:get_list_date_by_type(1) 
           -- if self.tipWin == nil then
           self:create_tips(tip_data,self.current_page_index )
           -- else
             self.tipWin:setIsVisible(true)
            local win = UIManager:find_visible_window("benefit_win")
            if win then
                if win.all_page_t[BENEFIT_OFFLINE_TAG].basepanel then   
                    win.all_page_t[BENEFIT_OFFLINE_TAG].basepanel:setIsVisible(true)
                end
            end

           -- end
        end
        return true
        
    end 

    local question_tip = MUtils:create_btn(panel1,
        UILH_NORMAL.wenhao,
        UILH_NORMAL.wenhao,
        tip_but_fun1,
        311, 147, -1, -1)
    
    --领取方式
    self.get_way = {}
    for i = 1,2 do 
        --选中面板的触发方法
        local function selected_get_way( eventType )
            if eventType == TOUCH_CLICK then
                self:selected_get_way(i)
            end
            return true
        end

        local panel =  CCBasePanel:panelWithFile(14+move_x*3+(i-1)*110,41,110,90,"")
        panel:registerScriptHandler(selected_get_way)
        panel1:addChild(panel)

        local item = MUtils:create_slot_item2(panel,UILH_COMMON.bg_05,0, 5,60,50,nil,nil,9.5);
        item:set_icon_bg_texture( UILH_COMMON.bg_05, 9.5, 9.5, 80, 65 )
        --选中框
        item.select_frame = MUtils:create_zximg(item.view, "ui2/login/lh_ser_bg.png", 7, 6, 89, 74);
        item.select_frame:setIsVisible(false)

        local function selected_change( eventType )
            self:selected_get_way(i);   
            return true;
        end 

        item:set_click_event(selected_change);
        self.get_way[i] = item
          local text ;
          local text2 ;
        if i == 1 then
            text = Lang.benefit.welfare[4] -- 免费领取
            text2 = Lang.benefit.welfare[5]
        elseif i == 2 then
            text = Lang.benefit.welfare[6]-- 元宝领取
             text2 = Lang.benefit.welfare[7]
        end
        local lab = UILabel:create_lable_2(LH_COLOR[2]..text, 15, 52, 14, ALIGN_LEFT );
        panel:addChild(lab);

        local lab2 = UILabel:create_lable_2(LH_COLOR[5]..text2, 15, 32, 14, ALIGN_LEFT );
        panel:addChild(lab2);
    end
    self.get_way_index = 1
    --副本累积
    self.current_page_index = 1

    self.yuanbao_consume = UILabel:create_lable_2( LH_COLOR[2].."", 50+move_x, 27, 14, ALIGN_CENTER )
    panel1:addChild(self.yuanbao_consume)
   

    -- 领取按钮
    local function buy_but_callback()
        self.current_page_index = 1
        WelfareModel:req_get_exp_back_award( self.current_page_index, self.get_way_index )
        self:update_exp_back_date(  )           
    end
    
    --领取按钮
    self.get_but = UIButton:create_button_with_name( 118+50, 10, -1, -1, UILH_COMMON.button4, UILH_COMMON.button4, nil, "", buy_but_callback )
    self.get_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)
    panel1:addChild( self.get_but.view )
    self.get_but_lable = UILabel:create_lable_2(LH_COLOR[2].."", 38, 17, 14, ALIGN_CENTER )
    self.get_but.view:addChild( self.get_but_lable )

     local btn_size = self.get_but.view:getSize()
     local lab_size = self.get_but_lable:getSize()
     btn_pos_x = btn_size.width/2- lab_size.width/2
     btn_pos_y = btn_size.height/2-lab_size.height/2+3
     self.get_but_lable:setPosition(btn_pos_x,btn_pos_y)


    self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[8]) -- [549]="领取"
   
    WelfareModel:req_exp_back_date( 1 )       -- 请求经验找回系统数据  副本

        --默认 为 免费的选中
    self:selected_get_way(1); 

end



--创建下面的面板
function DailyWelfareRD:create_panel_dwon( panel )  
    
    -- 日常任务积累
    local panel2 = CCBasePanel:panelWithFile(0, 0, 425, 225, "", 500, 500)
    panel:addChild(panel2)

    --日常任务积累
    local text_bg_down=  ZImageImage:create( panel2,UI_WELFARE.renwu_leiji,UI_WELFARE.text_bg,116, 184 , 190, -1,500,500 )  

    --累积次数
    local accumulation_count2 = 0
    self.accumulation_count_lable2 = UILabel:create_lable_2( Lang.benefit.welfare[2]..accumulation_count2, 13+move_x, 158, 14,  ALIGN_LEFT ) -- [600]="#c66ff66积累次数:#cffff00" -- [601]="#c66ff66次"
    panel2:addChild( self.accumulation_count_lable2 )


    --可获得经验
    local can_get_exp2 = 99999999
    self.can_get_exp_lable2 = UILabel:create_lable_2( Lang.benefit.welfare[3]..can_get_exp2, 13+move_x, 134, 14, ALIGN_LEFT ) -- [574]="#c66ff66可获得经验:#cffff00"
    panel2:addChild( self.can_get_exp_lable2 )


        --tip
    local function tip_but_fun2( eventType,x,y )
        self.current_page_index = 2
            if eventType == TOUCH_CLICK then
            local tip_data = WelfareModel:get_list_date_by_type(2 ) 
           -- if self.tipWin == nil then
           self:create_tips(tip_data,self.current_page_index )
           -- else
             self.tipWin:setIsVisible(true)
            local win = UIManager:find_visible_window("benefit_win")
            if win then
                if win.all_page_t[BENEFIT_OFFLINE_TAG].basepanel then   
                    win.all_page_t[BENEFIT_OFFLINE_TAG].basepanel:setIsVisible(true)
                end
            end

           -- end

           -- self:create_tips(tip_data, self.current_page_index)
        end
        return true
        
    end 
    local question_tip = MUtils:create_btn(panel2,
        UILH_NORMAL.wenhao,
        UILH_NORMAL.wenhao,
        tip_but_fun2,
       311, 147, -1, -1)

    
    --日常任务领取方式
    self.rc_get_way = {}

    for i = 1,2 do 

        --选中面板的触发方法
        local function selected_get_way( eventType )
            if eventType == TOUCH_CLICK then
                self:rc_selected_get_way(i)
            end
            return true
        end

        local panel =  CCBasePanel:panelWithFile(14+move_x*3+(i-1)*110,41,100,110,"")
        panel:registerScriptHandler(selected_get_way)
        panel2:addChild(panel)

        local item = MUtils:create_slot_item2(panel,UILH_COMMON.bg_05,0, 5,60,50,nil,nil,9.5);
        item:set_icon_bg_texture( UILH_COMMON.bg_05, 9.5, 9.5, 80, 65 )
        --选中框
        item.select_frame = MUtils:create_zximg(item.view, "ui2/login/lh_ser_bg.png", 7, 6, 89, 74);
        item.select_frame:setIsVisible(false)

         local function selected_change( eventType )
            self:rc_selected_get_way(i);   
            return true;
        end 

        item:set_click_event(selected_change);


        self.rc_get_way[i] = item
          local text ;
          local text2 ;
        if i == 1 then
            text = Lang.benefit.welfare[4] -- 免费领取
            text2 = Lang.benefit.welfare[5]
        elseif i == 2 then
            text = Lang.benefit.welfare[6]-- 元宝领取
             text2 = Lang.benefit.welfare[7]
        end
        local lab = UILabel:create_lable_2(LH_COLOR[2]..text, 15, 52, 14, ALIGN_LEFT );
        panel:addChild(lab);

        local lab2 = UILabel:create_lable_2(LH_COLOR[5]..text2, 15, 32, 14, ALIGN_LEFT );
        panel:addChild(lab2);
        
        self.rc_get_way_index = 1
        --副本累积
        self.current_page_index = 2
        
    end


    self.yuanbao_consume2 = UILabel:create_lable_2( LH_COLOR[2].."", 50+move_x, 27, 14, ALIGN_CENTER )
    panel2:addChild(self.yuanbao_consume2)
   

    -- 日常任务累积按钮
    local function buy_but_callback()
        self.current_page_index = 2
        WelfareModel:req_get_exp_back_award( self.current_page_index, self.rc_get_way_index )
        self:update_exp_back_date(  )           
    end
    
    --领取按钮
    self.get_but2 = UIButton:create_button_with_name( 118+50, 8, -1, -1, UILH_COMMON.button4, UILH_COMMON.button4, nil, "", buy_but_callback )
    self.get_but2.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)
    panel:addChild( self.get_but2.view )
    self.get_but_lable2 = UILabel:create_lable_2(LH_COLOR[2].."", 38, 17, 14, ALIGN_LEFT )
    self.get_but2.view:addChild( self.get_but_lable2 )
    self.get_but_lable2:setText( LH_COLOR[2]..Lang.benefit.welfare[8]) -- [549]="领取"
    
     local btn_size = self.get_but2.view:getSize()
     local lab_size = self.get_but_lable2:getSize()
     btn_pos_x2 = btn_size.width/2- lab_size.width/2
     btn_pos_y2 = btn_size.height/2-lab_size.height/2+3
     self.get_but_lable2:setPosition(btn_pos_x2,btn_pos_y2)


    --默认选中免费
    self:rc_selected_get_way(1)
    WelfareModel:req_exp_back_date( 2 )       -- 请求经验找回系统数据  日常任务
end


--离线积累选中
function DailyWelfareRD:selected_get_way( i )  
      self.get_way_index = i
      --更新可积累经验
    local total_count, total_exp, get_state, need_money = WelfareModel:get_exp_back_date_by_type( 1)    --可获得经验
    if self.get_way_index ==1 then
        self.can_get_exp_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[3]..total_exp*0.6 ) 
    else
         self.can_get_exp_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[3]..total_exp ) 
    end

      for j=1,2 do
        if i == j then
            self.get_way[j].select_frame:setIsVisible(true)
        else
             self.get_way[j].select_frame:setIsVisible(false)
        end
        
        if self.yuanbao_consume then
            if i ==2 then
                 self.yuanbao_consume:setText(LH_COLOR[2]..Lang.benefit.welfare[9]..self.need_money..Lang.benefit.welfare[10])
            else
                self.yuanbao_consume:setText(LH_COLOR[2]..Lang.benefit.welfare[4])
            end
        end
         
      end
end

--日常任务选中
function DailyWelfareRD:rc_selected_get_way( i )  
      self.rc_get_way_index = i

    --更新可积累经验
    local rc_total_count, rc_total_exp, rc_get_state, rc_need_money = WelfareModel:get_exp_back_date_by_type( 2 )
    if self.rc_get_way_index ==1 then
        self.can_get_exp_lable2:setString( LH_COLOR[2]..Lang.benefit.welfare[3]..rc_total_exp*0.6 ) 
    else
         self.can_get_exp_lable2:setString( LH_COLOR[2]..Lang.benefit.welfare[3]..rc_total_exp ) 
    end

      for j=1,2 do
        if i == j then
            self.rc_get_way[j].select_frame:setIsVisible(true)
        else
             self.rc_get_way[j].select_frame:setIsVisible(false)
        end
        
        if self.yuanbao_consume2 then
            if i ==2 then
                 self.yuanbao_consume2:setText(LH_COLOR[2]..Lang.benefit.welfare[9]..self.rc_need_money..Lang.benefit.welfare[10])
            else
                self.yuanbao_consume2:setText(LH_COLOR[2]..Lang.benefit.welfare[4])
            end
        end
         
      end
end


function DailyWelfareRD:create_tips( param,index )
    local win = UIManager:find_visible_window("benefit_win")
    if win then
        if win.all_page_t[BENEFIT_OFFLINE_TAG].basepanel then
            win.all_page_t[BENEFIT_OFFLINE_TAG].basepanel:setIsVisible(true)
        else
            win.all_page_t[BENEFIT_OFFLINE_TAG]:create_bg_win()
        end
    end

    self.tipWin = CCBasePanel:panelWithFile( 221, 112, 200, 257, UILH_COMMON.bg_03, 500, 500 )
    self.view:addChild(self.tipWin)
    local tip_title = UILabel:create_lable_2("",9,233,14,ALIGN_LEFT)

    if index ==1 then   --副本累积经验
     tip_title:setString(LH_COLOR[2]..Lang.benefit.welfare[12])
    elseif index ==2 then  --日常任务经验
     tip_title:setString(LH_COLOR[2]..Lang.benefit.welfare[13])
     end
     self.tipWin:addChild(tip_title)
    local tip_info = param
   
    for k,v in pairs(tip_info) do
        local fuben_info =nil
        local fuben_name = ""
          if index == 1 then --
        --获取副本名字 (取得某个活动的数据  activity_type:活动类型(副本fuben，活动daily) activity_id 活动id)
            fuben_info = ActivityModel:get_activity_info_by_id( "fuben",v.id )
           if fuben_info then 
                fuben_name =  fuben_info.location.entityName
           else
               fuben_name  = "";
           end
          
         elseif index ==2 then
            --在天降雄狮中 不可从活动配置中读取 
            -- fuben_info =   ActivityModel:get_activity_info_by_id( "daily",v.id )
            require "../data/refresh_quests"
            fuben_info  = refresh_quests[v.id]
            fuben_name =   fuben_info.name
         end

        local name =  UILabel:create_lable_2(LH_COLOR[2]..fuben_name,9,208-(k-1)*20,14,ALIGN_LEFT)
        local num  =  UILabel:create_lable_2(LH_COLOR[2]..""..v.times..Lang.benefit.welfare[14],100,208-(k-1)*20,14,ALIGN_LEFT)

        self.tipWin:addChild(name)
        self.tipWin:addChild(num)
      
    end
    
end

--隐藏方法
function  DailyWelfareRD:hide_tip_win(  )
     if self.tipWin then
            self.tipWin:setIsVisible(false)
    end
end


-- 更新经验返回数据
function DailyWelfareRD:update_exp_back_date(  )
    --副本累积
    local total_count, total_exp, get_state, need_money = WelfareModel:get_exp_back_date_by_type( 1)
    print("total_count, total_exp, get_state, need_money",total_count, total_exp, get_state, need_money)
    
    --累积次数
    self.accumulation_count_lable:setString(LH_COLOR[2]..Lang.benefit.welfare[2]..total_count) -- ="#c66ff66积累次数 "
    --可获得经验
    self.can_get_exp_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[3]..total_exp*0.6 ) 
    self.need_money = need_money

    --日常任务累积
    local rc_total_count, rc_total_exp, rc_get_state, rc_need_money = WelfareModel:get_exp_back_date_by_type( 2 )
     print("rc_total_count, rc_total_exp, rc_get_state, rc_need_money",rc_total_count, rc_total_exp, rc_get_state, rc_need_money)
    self.accumulation_count_lable2:setString(LH_COLOR[2]..Lang.benefit.welfare[2]..rc_total_count) -- 
    self.can_get_exp_lable2:setString(LH_COLOR[2]..Lang.benefit.welfare[3]..rc_total_exp*0.6 ) -- 
    self.rc_need_money = rc_need_money


    -- 消耗元宝
    if get_state == 0 then                                --  0：全部都没得领取
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
        self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[22]) -- 已领取
    elseif get_state == 1 then                            --  1：副本可领取
        self.get_but.view:setCurState( CLICK_STATE_UP )
        self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[8]) -- 领取
    elseif get_state == 2 then                            --  2：日常任务可领取
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
        self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[22]) -- 已领取
    elseif get_state == 3 then                            -- 3：全部都可领取 
        self.get_but.view:setCurState( CLICK_STATE_UP )
        self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[8]) -- 已领取
    end

    if rc_get_state == 0 then                                --  0：全部都没得领取
        self.get_but2.view:setCurState( CLICK_STATE_DISABLE )
        self.get_but_lable2:setText(LH_COLOR[2]..Lang.benefit.welfare[22]) -- 已领取
        self.get_but_lable2:setPosition(btn_pos_x2-8,btn_pos_y2)
    elseif rc_get_state == 1 then                            --  1：副本可领取
        self.get_but2.view:setCurState( CLICK_STATE_UP )
        self.get_but_lable2:setText(LH_COLOR[2]..Lang.benefit.welfare[8]) 
    elseif rc_get_state == 2 then                            --  2：日常任务可领取
        self.get_but2.view:setCurState( CLICK_STATE_UP )
        self.get_but_lable2:setText(LH_COLOR[2]..Lang.benefit.welfare[22]) 
        self.get_but_lable2:setPosition(btn_pos_x2-8,btn_pos_y2)

    elseif rc_get_state == 3 then                            -- 3：全部都可领取 
        self.get_but2.view:setCurState( CLICK_STATE_UP )
        self.get_but_lable2:setText(LH_COLOR[2]..Lang.benefit.welfare[8]) -- 已领取
    end

end

