-- BenefitEXPPage.lua 
-- createed by LittleWhite @2014-7-23
-- 活跃奖励页面
--天降雄狮中不用
super_class.BenefitEXPPage()

function BenefitEXPPage:__init(x,y)
	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y,662,540, nil, 500, 500 )

	self:create_up_panel()
    self:create_down_panel()
end

function BenefitEXPPage:create_up_panel()
	local panel = CCBasePanel:panelWithFile( 0, 450, 655, 87,UIPIC_Benefit_003, 500, 500 )
	self.view:addChild( panel )

	MUtils:create_zximg(panel,UIPIC_Benefit_006,42,10,-1,-1)
end

function BenefitEXPPage:create_down_panel()

	self.down_panel = CCBasePanel:panelWithFile( 0, 0, 655, 447,UIPIC_Benefit_003, 500, 500 )
    self.view:addChild( self.down_panel )    

    local panel = self.down_panel

	local exp_title = ZImageImage:create(panel, UIPIC_Benefit_009, UIPIC_Benefit_008, 0, 416, -1, -1)

	-- 领取的时间
    local get_hours  = 999
    self.get_times_lable_1 = UILabel:create_lable_2( LangGameString[577], 18, 385, 17, ALIGN_LEFT ) -- [577]="#c66ff66领取离线时间:"
    panel:addChild( self.get_times_lable_1 )

    -- 领取时间，输入数字
    local function num_edit_callback( num )
        self:update_consume(  )
        self:update_get_but_state(  )
        self:update_can_get_exp()
    end
    self.get_hours_num_edit = MUtils:create_num_edit( 149, 382, 55, 20, 168, num_edit_callback )
    panel:addChild( self.get_hours_num_edit.view )

	local off_time_hours = 999
    self.off_time_lable = UILabel:create_lable_2( LangGameString[572]..off_time_hours..LangGameString[573], 210, 385, 17, ALIGN_LEFT ) 
    -- [572]="#c66ff66(积累:#cffff00" -- [573]="#c66ff66小时)"
    panel:addChild( self.off_time_lable )

    local can_get_exp = 99999999
    self.can_get_exp_lable = UILabel:create_lable_2( LangGameString[574]..can_get_exp, 18, 353, 17, ALIGN_LEFT ) 
    -- [574]="#c66ff66可获得经验:#cffff00"
    panel:addChild( self.can_get_exp_lable )

    self.switch_but_t = {}          -- 存储所有选择按钮
    self:create_one_rate_but( self.view, 24, 298, 100, 40, LangGameString[578], 1 ) -- [578]="#cffff000.5倍"
	self:create_one_rate_but( self.view, 124, 298, 100, 40, LangGameString[579], 2 ) -- [579]="#cffff00 1倍"
	self:create_one_rate_but( self.view, 224, 298, 100, 40, LangGameString[580], 3 ) -- [580]="#cffff00 2倍"
	self:create_one_rate_but( self.view, 324, 298, 100, 40, LangGameString[581], 4 ) -- [581]="#cffff00 3倍"

	local consume_money = 0
    self.consume_money_lable = UILabel:create_lable_2( LangGameString[576]..consume_money, 208, 272, 17, ALIGN_CENTER ) 
    -- [576]="#c66ff66消耗元宝:#cffff00"
    panel:addChild( self.consume_money_lable )

	self:choose_one_but( self.switch_but_t[ 1 ] )

	-- 领取按钮
    local function buy_but_callback()
        WelfareModel:request_get_off_line_exp( self.current_rate_index, self.get_hours_num_edit.get_num() )
    end
    --xiehande UIPIC_Secretary_011 ->UIPIC_COMMOM_002
    self.get_but = UIButton:create_button_with_name( 482, 321, -1, -1, UIPIC_COMMOM_002, UIPIC_COMMOM_002, nil, "", buy_but_callback )
    --UIPIC_Secretary_035
    self.get_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)
    
    panel:addChild( self.get_but.view )

    self.get_but_lable = UILabel:create_lable_2( "", 63, 22, 16, ALIGN_CENTER )
    self.get_but.view:addChild( self.get_but_lable )

    self.get_but_lable:setText( LangGameString[549] )

    WelfareModel:request_off_line_exp(  ) 

    --副本奖励
    local fb_title = ZImageImage:create(panel, UIPIC_Benefit_010, UIPIC_Benefit_008, 0, 235, -1, -1)

    --副本累积次数
    local accumulation_count = 0
    self.fb_accumulation_count_lable = UILabel:create_lable_2( LangGameString[600]..accumulation_count..LangGameString[601], 18, 203, 17,  ALIGN_LEFT ) 
    -- [600]="#c66ff66积累次数:#cffff00" -- [601]="#c66ff66次"
    panel:addChild( self.fb_accumulation_count_lable )

    --可获得经验
    local can_get_exp = 99999999
    self.fb_can_get_exp_lable = UILabel:create_lable_2( LangGameString[574]..can_get_exp, 191, 203, 17, ALIGN_LEFT ) 
    -- [574]="#c66ff66可获得经验:#cffff00"
    panel:addChild( self.fb_can_get_exp_lable )

    -- 创建选择按钮
    self.fb_switch_but_t = {}          -- 存储所有副本选择按钮
    self:fb_create_one_rate_but( self.view, 24, 149, 200, 40, LangGameString[602], 1 ) 
    -- [602]="#c66ff66免费领取#cffff0060%#c66ff66经验"
    self.fb_yuanbao_get_switch = self:fb_create_one_rate_but( self.view, 230, 149, 280, 40, LangGameString[603], 2 ) 
    -- [603]="#cffff0022元宝#c66ff66领取#cffff00100%#c66ff66经验"

    self:fb_choose_one_but( self.fb_switch_but_t[ 1 ] )

    -- 副本领取按钮
    local function fb_buy_but_callback()
        WelfareModel:req_get_exp_back_award(1, self.fb_get_way_index )
    end

    -- self.get_but = ZImageButton:create( panel,UIPIC_COMMOM_002,"ui/normal/get.png",buy_but_callback, 161, 10  ) 
    self.fb_get_but = UIButton:create_button_with_name( 482, 185, -1, -1, UIPIC_COMMOM_002, UIPIC_COMMOM_002, nil, "", fb_buy_but_callback )
    --UIPIC_Secretary_035
    self.fb_get_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)
    
    panel:addChild( self.fb_get_but.view )

    self.fb_get_but_lable = UILabel:create_lable_2( "", 63, 22, 17, ALIGN_CENTER )
    self.fb_get_but.view:addChild( self.fb_get_but_lable )

    self.fb_get_but_lable:setText( LangGameString[549] ) -- [549]="领取"

    WelfareModel:req_exp_back_date( 1 )       -- 请求经验找回系统数据  副本

    --任务奖励
    local rw_title = ZImageImage:create(panel, UIPIC_Benefit_011, UIPIC_Benefit_008, 0, 100, -1, -1)

    --任务累积次数
    local rw_accumulation_count = 0
    self.rw_accumulation_count_lable = UILabel:create_lable_2( LangGameString[600]..accumulation_count..LangGameString[601], 18, 70, 17,  ALIGN_LEFT ) 
    -- [600]="#c66ff66积累次数:#cffff00" -- [601]="#c66ff66次"
    panel:addChild( self.rw_accumulation_count_lable )

    --可获得经验
    local can_get_exp = 99999999
    self.rw_can_get_exp_lable = UILabel:create_lable_2( LangGameString[574]..can_get_exp, 191, 70, 17, ALIGN_LEFT ) 
    -- [574]="#c66ff66可获得经验:#cffff00"
    panel:addChild( self.rw_can_get_exp_lable )

    -- 创建选择按钮
    self.rw_switch_but_t = {}          -- 存储所有副本选择按钮
    self:rw_create_one_rate_but( self.view, 24, 15, 200, 40, LangGameString[602], 1 ) 
    -- [602]="#c66ff66免费领取#cffff0060%#c66ff66经验"
    self.rw_yuanbao_get_switch = self:rw_create_one_rate_but( self.view, 230, 15, 280, 40, LangGameString[603], 2 ) 
    -- [603]="#cffff0022元宝#c66ff66领取#cffff00100%#c66ff66经验"

    self:rw_choose_one_but( self.rw_switch_but_t[1])

    -- 领取按钮
    local function rw_buy_but_callback()
        WelfareModel:req_get_exp_back_award(2,self.rw_get_way_index)
    end

    -- self.get_but = ZImageButton:create( panel,UIPIC_Secretary_011,"ui/normal/get.png",buy_but_callback, 161, 10  ) 
    self.rw_get_but = UIButton:create_button_with_name( 482, 50, -1, -1, UIPIC_COMMOM_002, UIPIC_COMMOM_002, nil, "", rw_buy_but_callback )
    --UIPIC_Secretary_035
    self.rw_get_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)
    
    panel:addChild( self.rw_get_but.view )

    self.rw_get_but_lable = UILabel:create_lable_2( "", 63, 22, 17, ALIGN_CENTER )
    self.rw_get_but.view:addChild( self.rw_get_but_lable )

    self.rw_get_but_lable:setText( LangGameString[549] ) -- [549]="领取"

    WelfareModel:req_exp_back_date(2)       -- 请求经验找回系统数据  副本
end 

-- 创建单个倍数选择控件
function BenefitEXPPage:create_one_rate_but( panel, x, y, w, h, content,index )
	local switch_but = nil               -- 单个开关控件对象. 调用create_switch_button方法创建后才是对象
    
	local function callback_fun(  )
		self:choose_one_but( switch_but )
	end
    local font_x = 35
    if i == 1 then
        font_x =42
    end
	switch_but = UIButton:create_switch_button( x, y, w, h, UIPIC_Secretary_019, UIPIC_Secretary_020, content, font_x, 16, nil, nil, nil, nil, callback_fun )
    if switch_but.words and index==1 then
        switch_but.words:setPosition(45,10)
    end

    panel:addChild( switch_but.view )
    switch_but.index = index
    self.switch_but_t[index] = switch_but
	return switch_but
end

-- 创建获取方式选择控件
function BenefitEXPPage:fb_create_one_rate_but( panel, x, y, w, h, content, index )
    local switch_but = {}               -- 单个开关控件对象
    local function callback_fun(  )
        self:fb_choose_one_but( switch_but )
    end
    switch_but = UIButton:create_switch_button( x, y, w, h, UIPIC_Secretary_019, UIPIC_Secretary_020, content, 42, 16, nil, nil, nil, nil, callback_fun )

    switch_but.index = index
    panel:addChild( switch_but.view )
    self.fb_switch_but_t[ index ] = switch_but
    return switch_but
end

function BenefitEXPPage:rw_create_one_rate_but( panel, x, y, w, h, content, index )
    local switch_but = {}               -- 单个开关控件对象
    local function callback_fun(  )
        self:rw_choose_one_but( switch_but )
    end
    switch_but = UIButton:create_switch_button( x, y, w, h, UIPIC_Secretary_019, UIPIC_Secretary_020, content, 42, 16, nil, nil, nil, nil, callback_fun )

    switch_but.index = index
    panel:addChild( switch_but.view )
    self.rw_switch_but_t[ index ] = switch_but
    return switch_but
end

-- 实现倍率按钮的单选  参数：一个 按钮对象（由BenefitEXPPage:create_one_rate_but 创建的按钮）
function BenefitEXPPage:choose_one_but( switch_but )
	for key, but in pairs(self.switch_but_t) do
        but.set_state( false )
	end
    self.current_rate_index = switch_but.index    -- 当前选中的倍率序列号
	switch_but.set_state( true )
    self:update_consume(  )
    self:update_can_get_exp()
end

function BenefitEXPPage:fb_choose_one_but( switch_but )
    for key, but in pairs(self.fb_switch_but_t) do
        but.set_state( false )
    end
    self.fb_get_way_index = switch_but.index
    switch_but.set_state( true )
end

function BenefitEXPPage:rw_choose_one_but( switch_but )
    for key, but in pairs(self.rw_switch_but_t) do
        but.set_state( false )
    end
    switch_but.set_state( true )
    self.rw_get_way_index = switch_but.index
end

-- 更新消耗总量
function BenefitEXPPage:update_consume(  )
    local num = self.get_hours_num_edit.get_num()       -- 获取时间输入 框数字
    local total_price = WelfareModel:calculate_total_price( self.current_rate_index, num )   -- 获取总价格
    -- 不同的倍数消耗不同的货币
    if self.current_rate_index == 1 then
        self.consume_money_lable:setString( "#c66ff66(免费领取)" ) -- [582]=
    elseif self.current_rate_index == 2 then
        self.consume_money_lable:setString( "#c66ff66(消耗#cffff00"..total_price..LangGameString[584] .. ")" ) -- [583]="#c66ff66消耗#cffff00" -- [584]="#c66ff66仙币"
    else
        self.consume_money_lable:setString( "#c66ff66(消耗#cffff00"..total_price.."#c66ff66元宝/绑元)" ) -- [583]="#c66ff66消耗#cffff00" -- [585]="#c66ff66元宝"
    end
end

-- 计算获取的经验
function BenefitEXPPage:update_can_get_exp(  )
    local num = self.get_hours_num_edit.get_num()
   
    local get_exp = ActivityModel:calculate_off_line_exp( num, self.current_rate_index )
    self.can_get_exp_lable:setString( LangGameString[574]..get_exp ) -- [574]="#c66ff66可获得经验:#cffff00"
    
end

-- 更新离线经验值
function BenefitEXPPage:update_off_line_exp(  )
    local off_time_hours = WelfareModel:get_off_line_hours(  )
    self.off_time_lable:setString( LangGameString[572]..off_time_hours..LangGameString[573] ) 
    -- [572]="#c66ff66(积累:#cffff00" -- [573]="#c66ff66小时)"
    self.get_hours_num_edit.set_max_num( off_time_hours )
    self.get_hours_num_edit.set_num( off_time_hours )
    self:update_get_but_state(  )            -- 更新按钮状态
	self:update_can_get_exp()
end

-- 更新领取按钮状态
function BenefitEXPPage:update_get_but_state(  )
    local num = self.get_hours_num_edit.get_num()       -- 获取时间输入 框数字
    if num < 1 then
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
    else
        self.get_but.view:setCurState( CLICK_STATE_UP )
    end
end

function BenefitEXPPage:update(update_type)
	if update_type == "off_exp" then
		self:update_off_line_exp()
	elseif update_type == "off_line_exp_consume" then
        self:update_consume()
    elseif update_type == "exp_back" then
        self:update_exp_back_date(  )
    else 
        self:update_consume(  )
        self:update_get_but_state(  )
        self:update_can_get_exp()
        self:update_off_line_exp()
        self:update_exp_back_date()
    end
end

-- 更新经验返回数据
function BenefitEXPPage:update_exp_back_date(  )
    
    local total_count, total_exp, get_state, need_money = WelfareModel:get_exp_back_date_by_type(1)
    -- print("~~~~~~~~~~~~BenefitEXPPage:update_exp_back_date(total_count, total_exp, get_state, need_money)",total_count, total_exp, get_state, need_money)
    self.fb_accumulation_count_lable:setString(LangGameString[600]..total_count..LangGameString[601]) 
    -- [600]="#c66ff66积累次数:#cffff00" -- [601]="#c66ff66次"
    self.fb_can_get_exp_lable:setString( LangGameString[574]..total_exp ) -- [574]="#c66ff66可获得经验:#cffff00"
    self.fb_yuanbao_get_switch.setString( "#cffff00"..need_money..LangGameString[604] ) -- [604]="元宝#c66ff66领取#cffff00100%#c66ff66经验"
    -- 消耗元宝

    if get_state == 0 then                                --  0：没得领取
        self.fb_get_but.view:setCurState( CLICK_STATE_DISABLE )        
    else
        self.fb_get_but.view:setCurState( CLICK_STATE_UP )    -- 1: 可以领取
    end

    local total_count, total_exp, get_state, need_money = WelfareModel:get_exp_back_date_by_type(2)
    -- print("~~~~~~~~~~~~BenefitEXPPage:update_exp_back_date(total_count, total_exp, get_state, need_money)",total_count, total_exp, get_state, need_money)
    self.rw_accumulation_count_lable:setString(LangGameString[600]..total_count..LangGameString[601]) 
    -- [600]="#c66ff66积累次数:#cffff00" -- [601]="#c66ff66次"
    self.rw_can_get_exp_lable:setString( LangGameString[574]..total_exp ) -- [574]="#c66ff66可获得经验:#cffff00"
    self.rw_yuanbao_get_switch.setString( "#cffff00"..need_money..LangGameString[604] ) -- [604]="元宝#c66ff66领取#cffff00100%#c66ff66经验"

    if get_state == 0 then                                --  0：没得领取
        self.rw_get_but.view:setCurState( CLICK_STATE_DISABLE )        
    else
        self.rw_get_but.view:setCurState( CLICK_STATE_UP)   -- 1: 可以领取
    end
end

-- 销毁
function BenefitEXPPage:destroy(  )
   -- Window.destroy(self)
end