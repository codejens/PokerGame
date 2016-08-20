-- PobingActivityWin
-- create by lxm on 2014.5.14
-- 消费返回活动
super_class.PobingActivityWin(NormalStyleWindow);
require "model/PobingModel"
local btn1_size = nil
local btn1_txt_size = nil

local btn2_size = nil
local btn2_txt_size = nil

local btn3_size = nil
local btn3_txt_size = nil

--构造函数
function PobingActivityWin:__init( window_name, window_info )
    self.panel = CCBasePanel:panelWithFile( 23, 18, 855, 540,UILH_COMMON.normal_bg_v2 , 600, 600)
    self.view:addChild(self.panel)
    local panel_img = ZImage:create(self.panel, UILH_MAINACTIVITY.pobing_bg, -53, 11, -1, -1, nil, 500, 500)
    --说明图片
    local panel_img = ZImage:create(self.panel, UILH_MAINACTIVITY.pobing_txt, 403, 343, -1, -1, nil, 500, 500)

    -- 活动剩余时间
    self.activity_time_title_lable = UILabel:create_lable_2( LH_COLOR[1]..Lang.mainActivity.pobing[1], 40, 20, 16, ALIGN_LEFT ) -- [634]="#c66ff66活动剩余时间："
    self.panel:addChild( self.activity_time_title_lable )

    --进度条底板
    -- local panel_up = ZImage:create(self.panel, UILH_COMMON.bottom_bg, 294, 181, 510, 155, nil, 500, 500)

    --     local bg_1 = CCBasePanel:panelWithFile(13, 62, 390, 221,UILH_COMMON.bottom_bg, 500, 500)
    -- panel:addChild(bg_1)

    -- local panel_bg = CCBasePanel:panelWithFile(0, 0,  510, 155, UILH_COMMON.normal_bg_v2, 500, 500)   --60 为分页栏高度
    -- panel:addChild(panel_bg)

    local panel_up = CCBasePanel:panelWithFile( 294, 181, 510, 155, UILH_COMMON.bottom_bg, 500, 500)
    self.panel:addChild(panel_up)
     --标题
    local title_bg = CCZXImage:imageWithFile( -2, 131, 510, 25, UILH_NORMAL.title_bg4, 500, 500 )
    local title_name =  UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[2], 67, 10, font_size, ALIGN_LEFT ) 
    local title_bg_size = title_bg:getSize()
    local title_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2+2)
    title_bg:addChild(title_name)
    panel_up:addChild(title_bg.view)


    --充值一百立即返回一百
    local lab_txt1 = UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[3], 34, 108, 14, ALIGN_LEFT ) 
    panel_up:addChild(lab_txt1)
    --进阶的进度背景
    local pro_left  =ZImage:create(panel_up,UILH_NORMAL.progress_left,28,80,-1,-1,888)
    local pro_right  =ZImage:create(panel_up,UILH_NORMAL.progress_left,337+8,80,-1,-1,888)
    pro_left.view:setScale(16/25)
    pro_right.view:setScale(16/25)
    pro_right.view:setFlipX(true)
    self.process_bar_1 = ZXProgress:createWithValueEx(0,100,320,16,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_yellow2,true);
    self.process_bar_1:setProgressValue( 0, 100 )
    self.process_bar_1:setPosition(CCPointMake(28+10,84));
    panel_up:addChild(self.process_bar_1)

    local function btn1_func(  )      -- 同意回调
        -- print("按钮1点击")
        PobingModel:request_lignqu( 1 )
    end

    self.btn1 = UIButton:create_button_with_name( 378 , 76, -1, -1, UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r,UILH_COMMON.btn4_dis, "", btn1_func )
    self.btn1.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    panel_up:addChild( self.btn1.view )
    self.btn1.btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[4], 23, 20, 16, ALIGN_LEFT ) 
    btn1_size = self.btn1.view:getSize()
    btn1_txt_size = self.btn1.btn_txt:getSize()
    self.btn1.btn_txt:setPosition(btn1_size.width/2 -btn1_txt_size.width/2, btn1_size.height/2 -btn1_txt_size.height/2+3)
    self.btn1.view:addChild(self.btn1.btn_txt)




    --充值500立即返回500
    local lab_txt2 = UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[5], 34, 36, 14, ALIGN_LEFT ) 
    panel_up:addChild(lab_txt2)
    --进阶的进度背景
    local pro_left  =ZImage:create(panel_up,UILH_NORMAL.progress_left,28,11,-1,-1,888)
    local pro_right  =ZImage:create(panel_up,UILH_NORMAL.progress_left,337+8,11,-1,-1,888)
    pro_left.view:setScale(16/25)
    pro_right.view:setScale(16/25)
    pro_right.view:setFlipX(true)

    self.process_bar_2 = ZXProgress:createWithValueEx(0,500,320,16,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_yellow2,true);
    self.process_bar_2:setProgressValue( 0, 500 )
    self.process_bar_2:setPosition(CCPointMake(28+10,15));
    panel_up:addChild(self.process_bar_2)

    local function btn2_func(  )      -- 同意回调
        -- print("按钮2点击")
        PobingModel:request_lignqu( 2 )

    end
    self.btn2 = UIButton:create_button_with_name( 378 , 6, -1, -1, UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r,UILH_COMMON.btn4_dis, "", btn2_func )
    self.btn2.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    panel_up:addChild( self.btn2.view )
    self.btn2.btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[4], 23, 20, 16, ALIGN_LEFT ) 
    self.btn2.view:addChild( self.btn2.btn_txt)
    btn2_size = self.btn2.view:getSize()
    btn2_txt_size = self.btn2.btn_txt:getSize()
    self.btn2.btn_txt:setPosition(btn2_size.width/2 -btn2_txt_size.width/2, btn2_size.height/2 -btn2_txt_size.height/2+3)

    --分割线
    local line = CCZXImage:imageWithFile( 10, 71, 490, 3, UILH_COMMON.split_line )
    panel_up:addChild(line)

    -- local panel_middle  = ZImage:create(self.panel, UILH_COMMON.bottom_bg, 294, 80, 510, 100, nil, 500, 500)
    -- local panel_up = CCBasePanel:panelWithFile( 294, 181, 510, 155, UILH_COMMON.bottom_bg, 500, 500)
    -- 
    local panel_middle = CCBasePanel:panelWithFile( 294, 80, 510, 100, UILH_COMMON.bottom_bg, 500, 500)
    self.panel:addChild(panel_middle)
     --标题
    local title_bg = CCZXImage:imageWithFile( -2, 71, 510, 25, UILH_NORMAL.title_bg4, 500, 500 )
    local title_name =  UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[6], 67, 10, 16, ALIGN_LEFT ) 
    local title_bg_size = title_bg:getSize()
    local title_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2+2)
    title_bg:addChild(title_name)
    panel_middle:addChild(title_bg)


    --充值500立即返回500
    local lab_txt3 = UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[7], 34, 36, 14, ALIGN_LEFT ) 
    panel_middle:addChild(lab_txt3)

    local pro_left  =ZImage:create(panel_middle,UILH_NORMAL.progress_left,28,11,-1,-1,888)
    local pro_right  =ZImage:create(panel_middle,UILH_NORMAL.progress_left,337+8,11,-1,-1,888)
    pro_left.view:setScale(16/25)
    pro_right.view:setScale(16/25)
    pro_right.view:setFlipX(true)

    self.process_bar_3 = ZXProgress:createWithValueEx(0,200,320,16,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_yellow2,true);
    self.process_bar_3:setProgressValue( 0, 1000 )
    self.process_bar_3:setPosition(CCPointMake(28+10,15));
    panel_middle:addChild(self.process_bar_3)


    local function btn3_func(  )      -- 同意回调
        -- print("按钮3点击")
        PobingModel:request_lignqu( 3 )
    end
    self.btn3 = UIButton:create_button_with_name( 378 , 6, -1, -1, UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r,UILH_COMMON.btn4_dis, "", btn3_func )
    self.btn3.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    panel_middle:addChild( self.btn3.view )
    self.btn3.btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.mainActivity.pobing[4], 23, 20, 16, ALIGN_LEFT ) 
    self.btn3.view:addChild(self.btn3.btn_txt)
    btn3_size = self.btn3.view:getSize()
    btn3_txt_size = self.btn3.btn_txt:getSize()
    self.btn3.btn_txt:setPosition(btn3_size.width/2 -btn3_txt_size.width/2, btn3_size.height/2 -btn3_txt_size.height/2+3)


    -- local panel_down  = ZImage:create(self.panel, "", 294, 6, 510, 80, nil, 500, 500)
    local panel_down = CCBasePanel:panelWithFile( 294, 6, 510, 80, nil)
    self.panel:addChild(panel_down)

    local limit_money = UILabel:create_lable_2( LH_COLOR[1]..Lang.mainActivity.pobing[8], 104, 44, 16, ALIGN_LEFT )
    self.limit_money_value = UILabel:create_lable_2("888", 234, 44, 16, ALIGN_LEFT )


    local count_money = UILabel:create_lable_2( LH_COLOR[1]..Lang.mainActivity.pobing[9], 104, 17, 16, ALIGN_LEFT )
    self.count_money_value=UILabel:create_lable_2("888", 269, 17, 16, ALIGN_LEFT )
    panel_down:addChild(limit_money)
    panel_down:addChild(count_money)
    panel_down:addChild(self.limit_money_value)
    panel_down:addChild(self.count_money_value)

    local function chongzhi_func(  )  
        UIManager:show_window("pay_win")
    end

    local accept_but = UIButton:create_button_with_name( 345 , 12, -1, -1, UILH_NORMAL.special_btn, UILH_NORMAL.special_btn, nil, "", chongzhi_func )
    panel_down:addChild( accept_but.view )
    --立即充值
    local btn_txt_img =ZImage:create(accept_but, UILH_MAINACTIVITY.chongzhi_now, 41, 13, -1, -1, nil, 500, 500)

end


--当界面被UIManager:show_window, hide_window的时候调用
function PobingActivityWin:active(show)
	if show then
        PobingModel:request_chongzhi_value()
	end
end

function PobingActivityWin:update( )
        self:update_remain_time()
        self:update_other_value()
end


--更新其他值
function PobingActivityWin:update_other_value(  )
   local pobing_value = PobingModel:get_Pobing_value(  )
   self.limit_money_value:setString(pobing_value.today_money)
   self.count_money_value:setString(pobing_value.count_money)
   

   self.process_bar_1:setProgressValue( pobing_value.today_money, 100 )
   if pobing_value.today_money >=100 then
   self.process_bar_2:setProgressValue( pobing_value.today_money-100, 500 )
   end
   self.process_bar_3:setProgressValue( pobing_value.count_money, 1000 )
   if pobing_value.first_flag == 1  then --可以领取
      self.btn1.view:setCurState(CLICK_STATE_UP)
   elseif pobing_value.first_flag ==2  then -- 已领取
      self.btn1.view:setCurState(CLICK_STATE_DISABLE)
      self.btn1.btn_txt:setString(LH_COLOR[2]..Lang.benefit.welfare[22])
      self.btn1.btn_txt:setPosition((btn1_size.width/2 - btn1_txt_size.width/2)+10,(btn1_size.height/2 - btn1_txt_size.height/2)+3)
      
   else   --不可领取
      self.btn1.view:setCurState(CLICK_STATE_DISABLE)

   end

   if pobing_value.second_flag == 1  then --可以领取
      self.btn2.view:setCurState(CLICK_STATE_UP)

   elseif pobing_value.second_flag ==2  then-- 已领取
      self.btn2.view:setCurState(CLICK_STATE_DISABLE)
      self.btn2.btn_txt:setString(LH_COLOR[2]..Lang.benefit.welfare[22])
      self.btn2.btn_txt:setPosition((btn2_size.width/2 - btn2_txt_size.width/2)+10,(btn2_size.height/2 - btn2_txt_size.height/2)+3)


    
   else 
      self.btn2.view:setCurState(CLICK_STATE_DISABLE)

   end


if pobing_value.third_flag == 1  then--可以领取
      self.btn3.view:setCurState(CLICK_STATE_UP)

   elseif pobing_value.third_flag ==2  then-- 已领取
      self.btn3.view:setCurState(CLICK_STATE_DISABLE)
      self.btn3.btn_txt:setString(LH_COLOR[2]..Lang.benefit.welfare[22])
      self.btn3.btn_txt:setPosition((btn3_size.width/2 - btn3_txt_size.width/2)+10,(btn3_size.height/2 - btn3_txt_size.height/2)+3)
   else 
      self.btn3.view:setCurState(CLICK_STATE_DISABLE)

   end

end



-- 更新剩余时间
function PobingActivityWin:update_remain_time(  )
    if self.time then 
        self.time:destroy();
        self.time = nil;
    end
    local the_time = SmallOperationModel:get_act_time( CommonActivityConfig.PoBing ); 
    --print("time=",time);
    local function finish_call(  )
        if self.time then
          self.time:setString(LH_COLOR[15].."0秒")
        end
    end
    self.time = TimerLabel:create_label( self.panel, 166,20 , 16, the_time,LH_COLOR[15], finish_call, false,ALIGN_LEFT);

    if the_time == nil or the_time <= 0 then
        finish_call();
    end 
end

--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function PobingActivityWin:destroy()
    if self.time then 
        self.time:destroy();
        self.time = nil;
    end


	Window.destroy(self);
end


