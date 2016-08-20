-- DailyWelfareLD_exp.lua  
-- created by lyl on 2013-6-19
-- 日常福利页 左下面板   经验页  离线经验

super_class.DailyWelfareLD_exp()

local btn_pos_x = 0
local btn_pos_y = 0 

function DailyWelfareLD_exp:__init(  )
	self.current_rate_index = 1           -- 当前选择的倍率 1 ：0.5    2:1  3:1.5   4:2
    -- self.current_page_index = 1           -- 当前第几页，1：经验   2：灵气
    self.get_hours_num_edit = nil
    self.get_hours_num = 1
    local move_x = 100

    self.view = CCBasePanel:panelWithFile( 0, 0, 425, 478, "", 500, 500 )
    local panel = self.view
    
    --离线时间
    local off_time_hours = 999
    self.off_time_lable = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[15]..off_time_hours, 16, 407, 14, ALIGN_LEFT ) -- [572]="#c66ff66(积累:#cffff00" -- [573]="#c66ff66小时)"
    panel:addChild( self.off_time_lable )

    --离线经验
    local can_get_exp = 99999999
    self.can_get_exp_lable = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[3]..can_get_exp, 16, 382, 14, ALIGN_LEFT ) -- [574]="#c66ff66可获得经验:#cffff00"
    panel:addChild( self.can_get_exp_lable )


   local xuanzhe_bg = CCZXImage:imageWithFile( 62, 306, 300, 31, UILH_NORMAL.title_bg4, 500, 500 )
    local xuanzhe_name =  UILabel:create_lable_2("选择领取倍数", 67, 9, font_size, ALIGN_LEFT ) 

    local xuanzhe_bg_size = xuanzhe_bg:getSize()
    local xuanzhe_name_size = xuanzhe_name:getSize()
    xuanzhe_name:setPosition(xuanzhe_bg_size.width/2 - xuanzhe_name_size.width/2,xuanzhe_bg_size.height/2 - xuanzhe_name_size.height/2+3)

    xuanzhe_bg:addChild(xuanzhe_name)
    panel:addChild(xuanzhe_bg)

    --倍数
    local consume_money = 0
    self.consume_money_lable = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[16]..consume_money, 102+move_x, 68+30, 14, ALIGN_CENTER ) -- [576]="#c66ff66消耗元宝:#cffff00"
    panel:addChild( self.consume_money_lable )

    -- 领取离线时间

    local get_hours  = 999
    self.get_times_lable_1 = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[8], 6+move_x, 141, 14, ALIGN_LEFT ) -- [577]="#c66ff66领取离线时间:"
    panel:addChild( self.get_times_lable_1 )
    local get_times_lable_2 = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[17], 171+move_x, 141, 14, ALIGN_LEFT )
    panel:addChild( get_times_lable_2 )

    -- 领取时间，输入数字
    -- local function num_edit_callback( num )
    --     self:update_consume(  )
    --     self:update_get_but_state(  )
    --     self:update_can_get_exp()
    -- end
    -- self.get_hours_num_edit = MUtils:create_num_edit( 142, 121, 55, 20, 168, num_edit_callback )
    -- panel:addChild( self.get_hours_num_edit.view )
    
        --加减按钮背景
    local num_bg = CCZXImage:imageWithFile(46+move_x,126,120,40,UILH_COMMON.bg_07,500,500);
    panel:addChild(num_bg)

    self.get_hours_num = 1
    --数值
    self.get_hours_num_edit = UILabel:create_lable_2(LH_COLOR[2]..self.get_hours_num,44, 14, 14, ALIGN_CENTER)
    local  bg_size = num_bg:getSize()
    local  lab_size = self.get_hours_num_edit:getSize()
    self.get_hours_num_edit:setPosition(bg_size.width/2-lab_size.width/2+4,bg_size.height/2-lab_size.height/2+1)
     num_bg:addChild( self.get_hours_num_edit,1 )

    --减号的触发方法
    local function num_edit_callback_jian( eventType,arg,msgid,selfitem )

        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            if self.get_hours_num <1 then
             self.get_hours_num = 0 
            else
                 self.get_hours_num =  self.get_hours_num -1
            end
           print("self.get_hours_num",self.get_hours_num)
            self:update_time()
            self:update_consume(  )
            self:update_get_but_state(  )
            self:update_can_get_exp()
            return true;
        end
        return true;

    end

    --加号的触发方法
    local function num_edit_callback_jia( eventType,arg,msgid,selfitem )
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
                local off_time_hours = WelfareModel:get_off_line_hours(  )
                if self.get_hours_num >=off_time_hours then
                     self.get_hours_num = off_time_hours
                else
                     self.get_hours_num =  self.get_hours_num +1
                end
                 self:update_time()
                self:update_consume(  )
                self:update_get_but_state(  )
                self:update_can_get_exp()

            return true;
        end
        return true;

    
    end
    
    --减号
    local btn_jian = MUtils:create_btn(panel,UI_WELFARE.jianhao,UI_WELFARE.jianhao,num_edit_callback_jian,47+move_x,125,-1,-1)
    --加号
    local  btn_jia =  MUtils:create_btn(panel,UI_WELFARE.jiahao,UI_WELFARE.jiahao,num_edit_callback_jia,122+move_x,125,-1,-1,1)
  

   -- 创建倍数选择按钮
    self:create_all_rate_but(  )


    -- 领取按钮
    local function buy_but_callback()
        -- WelfareModel:request_get_off_line_exp( self.current_rate_index, self.get_hours_num_edit.get_num() )
        WelfareModel:request_get_off_line_exp( self.current_rate_index, self.get_hours_num)
        -- 自动切换到离线灵气
        -- local win = UIManager:find_visible_window("activity_Win")
        -- if win then
        --     win:update("change_to_lingqi");
        -- end
        --更新
    end
    
    --领取按钮

    self.get_but = UIButton:create_button_with_name( 65+move_x, 8+30, -1, -1, UILH_COMMON.button4, UILH_COMMON.button4, nil, "", buy_but_callback )
    self.get_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)
    panel:addChild( self.get_but.view )
    self.get_but_lable = UILabel:create_lable_2( "", 39, 15, 14, ALIGN_LEFT )
    self.get_but.view:addChild( self.get_but_lable )
    self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[8])

    local btn_size = self.get_but.view:getSize()
     local lab_size = self.get_but_lable:getSize()
    btn_pos_x = btn_size.width/2- lab_size.width/2
    btn_pos_y = btn_size.height/2-lab_size.height/2+3
     self.get_but_lable:setPosition(btn_pos_x,btn_pos_y)



    WelfareModel:request_off_line_exp(  )    -- 请求服务器下发离线经验
end

-- 创建所有倍数选择的控件
function DailyWelfareLD_exp:create_all_rate_but(  )
	self.switch_but_t = {}          -- 存储所有选择按钮
    local gas_x = 90
    local begin_x = 35
    self:create_one_rate_but( self.view, begin_x, 200, -1, -1, "", 1 ) -- [578]="#cffff000.5倍"
	self:create_one_rate_but( self.view, begin_x+gas_x, 200, -1, -1, "", 2 ) -- [579]="#cffff00 1倍"
	self:create_one_rate_but( self.view, begin_x+gas_x*2, 200, -1, -1, "", 3 ) -- [580]="#cffff00 2倍"
	self:create_one_rate_but( self.view, begin_x+gas_x*3, 200, -1, -1, "", 4 ) -- [581]="#cffff00 3倍"

	self:choose_one_but( self.switch_but_t[ 1 ] )
end


-- 创建单个倍数选择控件
function DailyWelfareLD_exp:create_one_rate_but( panel, x, y, w, h, content, index )
	local switch_but = nil               -- 单个开关控件对象. 调用create_switch_button方法创建后才是对象
    
	local function callback_fun(  )
		self:choose_one_but( switch_but )
	end
    --选择框
	-- switch_but = UIButton:create_switch_button( x, y, w, h, UIPIC_Secretary_019, UIPIC_Secretary_020, content, font_x, 16, nil, nil, nil, nil, callback_fun )
    if index==3 or index==4 then
        switch_but = UIButton:create_button_with_name( x, y, w, h,UI_WELFARE.btn_yellow, UI_WELFARE.btn_yellow, nil, "", callback_fun )

    else
        switch_but = UIButton:create_button_with_name( x, y, w, h,UI_WELFARE.btn_gray, UI_WELFARE.btn_gray, nil, "", callback_fun )
    end

     --选中框
    switch_but.select_frame = MUtils:create_zximg(switch_but.view, UI_WELFARE.again_select, -4, -5, -1, -1);
    switch_but.select_frame:setIsVisible(false)

    --倍数 
    if index == 1 then
        switch_but.rate_img = MUtils:create_zximg(switch_but.view, UI_WELFARE.half_again, 14,20, -1, -1);
    elseif index == 2 then
       switch_but.rate_img = MUtils:create_zximg(switch_but.view, UI_WELFARE.one_again, 14,20, -1, -1);
    elseif index == 3 then
       switch_but.rate_img = MUtils:create_zximg(switch_but.view, UI_WELFARE.two_again, 14,20, -1, -1);
    else
       switch_but.rate_img = MUtils:create_zximg(switch_but.view, UI_WELFARE.three_again, 14,20, -1, -1);
    end

    panel:addChild( switch_but.view )
    switch_but.index = index
    self.switch_but_t[index] = switch_but
	return switch_but
end



-- 实现倍率按钮的单选  参数：一个 按钮对象（由DailyWelfareLD:create_one_rate_but 创建的按钮）
function DailyWelfareLD_exp:choose_one_but( switch_but )
	for key, but in pairs(self.switch_but_t) do
        but.select_frame:setIsVisible(false)
	end
    self.current_rate_index = switch_but.index    -- 当前选中的倍率序列号
    switch_but.select_frame:setIsVisible(true)

    self:update_consume(  )
    self:update_can_get_exp()
end

-- 更新离线经验值
function DailyWelfareLD_exp:update_off_line_exp(  )
    --离线经验值
    local off_time_hours = WelfareModel:get_off_line_hours(  )
    -- if self.current_page_index == 2 then      -- 灵气页
    -- 	off_time_hours = WelfareModel:get_off_line_lingqi(  )
    -- end
    self.off_time_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[15]..off_time_hours ) -- [572]="#c66ff66(积累:#cffff00" -- [573]="#c66ff66小时)"
    -- self.get_hours_num_edit.set_max_num( off_time_hours )
    -- self.get_hours_num_edit.set_num( off_time_hours )
    self.get_hours_num = off_time_hours
    self.get_hours_num_edit:setText(LH_COLOR[2]..self.get_hours_num )
    self:update_get_but_state(  )            -- 更新按钮状态

	self:update_can_get_exp()
end

-- 更新消耗总量
function DailyWelfareLD_exp:update_consume(  )
    -- local num = self.get_hours_num_edit.get_num()       -- 获取时间输入 框数字
     local  num = self.get_hours_num
    local total_price = WelfareModel:calculate_total_price( self.current_rate_index, num )   -- 获取总价格
    -- 不同的倍数消耗不同的货币
    if self.current_rate_index == 1 then
        self.consume_money_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[4] ) -- [582]=
    elseif self.current_rate_index == 2 then
        self.consume_money_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[16]..total_price..Lang.normal[2]) -- [583]="#c66ff66消耗#cffff00" -- [584]="#c66ff66仙币"
    else
        self.consume_money_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[16]..total_price..Lang.normal[4] ) -- [583]="#c66ff66消耗#cffff00" -- [585]="#c66ff66元宝"
    end
end

-- 计算获取的经验
function DailyWelfareLD_exp:update_can_get_exp(  )

    -- local num = self.get_hours_num_edit.get_num()
     local  num = self.get_hours_num
    -- if self.current_page_index == 2 then 
    --     local get_lingqi = ActivityModel:calculate_off_line_lingqi( num, self.current_rate_index )
    --     self.can_get_exp_lable:setString( LangGameString[586]..get_lingqi ) -- [586]="#c66ff66可获得灵气:#cffff00"
    -- else
        local get_exp = ActivityModel:calculate_off_line_exp( num, self.current_rate_index )
        self.can_get_exp_lable:setString( LH_COLOR[2]..Lang.benefit.welfare[3]..get_exp ) -- [574]="#c66ff66可获得经验:#cffff00"
    -- end
end

-- 更新领取按钮状态
function DailyWelfareLD_exp:update_get_but_state(  )
    -- local num = self.get_hours_num_edit.get_num()       -- 获取时间输入 框数字
    local  num = self.get_hours_num
    if num < 1 then
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
        self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[22])
        self.get_but_lable:setPosition(btn_pos_x-8,btn_pos_y)
    else
        self.get_but.view:setCurState( CLICK_STATE_UP )
        self.get_but_lable:setText(LH_COLOR[2]..Lang.benefit.welfare[8])

    end
end

--更新小时
function  DailyWelfareLD_exp:update_time( ... )
    if self.get_hours_num_edit then
    self.get_hours_num_edit:setString(LH_COLOR[2]..self.get_hours_num)
    end
end

function DailyWelfareLD_exp:update( update_type )
    if update_type == "all" then 
        self:update_consume(  )
        self:update_get_but_state(  )
        self:update_can_get_exp()
        self:update_off_line_exp(  )
    end
end


--重写destroy
function DailyWelfareLD:destroy( ... )
     Window.destroy(self)
end