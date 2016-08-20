-- DailyWelfareLD_lq.lua  
-- created by lyl on 2013-6-19
-- 日常福利页 左下面板   灵气页

super_class.DailyWelfareLD_lq()

local _rate_but_index_to_rate_t = { [1] = 1, [2] = 1.5, [3] = 2 }   -- 倍数选择按钮序号对应的倍数
local _rate_to_can_not_get_word = {
    [1.5] = LangGameString[587], -- [587]="#cff0000仙尊5免费领取"
    [2]   = LangGameString[588], -- [588]="#cff0000仙尊10免费领取"
}


function DailyWelfareLD_lq:__init(  )
	self.current_rate_index = 1           -- 当前选择的倍率 1 ：0.5    2:1  3:1.5   4:2
    self.get_hours_num_edit = nil
    self.page_info_t        = {}          -- key: exp：经验    lingqi：灵气

    self.view = CCBasePanel:panelWithFile( 0, 0, 353, 170, "", 500, 500 )
    local panel = self.view

    local off_time_hours = 999
    self.off_time_lable = UILabel:create_lable_2( LangGameString[572]..off_time_hours..LangGameString[573], 18 + 150 + 40, 129, 16, ALIGN_LEFT ) -- [572]="#c66ff66(积累:#cffff00" -- [573]="#c66ff66小时)"
    panel:addChild( self.off_time_lable )

    local can_get_exp = 99999999
    self.can_get_exp_lable = UILabel:create_lable_2( LangGameString[586]..can_get_exp, 18, 105, 16, ALIGN_LEFT ) -- [586]="#c66ff66可获得灵气:#cffff00"
    panel:addChild( self.can_get_exp_lable )

    panel:addChild( UILabel:create_lable_2( LangGameString[589], 18, 80, 16, ALIGN_LEFT ) ) -- [589]="#c66ff66灵气倍数:"

    local consume_money = 0
    self.consume_money_lable = UILabel:create_lable_2( LangGameString[576]..consume_money, 210, 15, 16, ALIGN_CENTER ) -- [576]="#c66ff66消耗元宝:#cffff00"
    panel:addChild( self.consume_money_lable )

    -- 领取的时间
    local get_hours  = 999
    self.get_times_lable_1 = UILabel:create_lable_2( LangGameString[590], 215 - 197, 129, 16, ALIGN_LEFT ) -- [590]="#c66ff66领取离线灵气:"
    panel:addChild( self.get_times_lable_1 )
    -- local get_times_lable_2 = UILabel:create_lable_2( "#c66ff66小时", 315 - 197, 114, 16, ALIGN_LEFT )
    -- panel:addChild( get_times_lable_2 )

    -- 领取时间，输入数字
    local function num_edit_callback( num )
        self:check_can_get(  )
        self:update_get_but_state(  )
        self:update_can_get_exp()
    end
    self.get_hours_num_edit = MUtils:create_num_edit( 257 - 197 + 80, 127, 55, 20, 168, num_edit_callback )
    panel:addChild( self.get_hours_num_edit.view )

    -- 领取按钮
    local function buy_but_callback()
        local obtain_hours = self.get_hours_num_edit.get_num()
        WelfareModel:request_obtain_lingqi( self.current_rate_index, obtain_hours )
    end
    self.get_but = ZImageButton:create( panel,"ui/common/button2_red.png","ui/normal/get.png",buy_but_callback, 167, 30  ) 
    
    -- 创建倍数选择按钮
    self:create_all_rate_but(  )

    WelfareModel:request_off_line_lingqi(  ) -- 请求离线灵气
end

-- 创建所有倍数选择的控件
function DailyWelfareLD_lq:create_all_rate_but(  )
	self.switch_but_t = {}          -- 存储所有选择按钮
    self:create_one_rate_but( self.view, 100, 74, 65, 40, LangGameString[591], 1 ) -- [591]="#cffff001倍"
	self:create_one_rate_but( self.view, 175, 74, 65, 40, LangGameString[592], 2 ) -- [592]="#cffff001.5倍"
	self:create_one_rate_but( self.view, 250, 74, 65, 40, LangGameString[593], 3 ) -- [593]="#cffff002倍"
	-- self:create_one_rate_but( self.view, 180 + 35, 35, 65, 20, "#cffff00 3倍", 4 )

	self:choose_one_but( self.switch_but_t[ 1 ] )
end

-- 创建单个倍数选择控件
function DailyWelfareLD_lq:create_one_rate_but( panel, x, y, w, h, content, index )
	local switch_but = nil               -- 单个开关控件对象. 调用create_switch_button方法创建后才是对象
    
	local function callback_fun(  )
		self:choose_one_but( switch_but )
	end
	switch_but = UIButton:create_switch_button( x, y, w, h, UIResourcePath.FileLocate.common .. "common_toggle_n.png", UIResourcePath.FileLocate.common .. "common_toggle_s.png", content, 24 + 5, 16, nil, nil, nil, nil, callback_fun )

    panel:addChild( switch_but.view )
    switch_but.index = index
    self.switch_but_t[index] = switch_but
	return switch_but
end

-- 实现倍率按钮的单选  参数：一个 按钮对象（由DailyWelfareLD:create_one_rate_but 创建的按钮）
function DailyWelfareLD_lq:choose_one_but( switch_but )
	for key, but in pairs(self.switch_but_t) do
        but.set_state( false )
	end
    self.current_rate_index = switch_but.index    -- 当前选中的倍率序列号
	switch_but.set_state( true )
    self:check_can_get(  )
    self:update_can_get_exp()
    self:update_get_but_state(  )            -- 更新按钮状态
end

-- 更新离线灵气值
function DailyWelfareLD_lq:update_off_line_lingqi(  )
    local off_time_hours = WelfareModel:get_off_line_lingqi(  )
    self.off_time_lable:setString( LangGameString[572]..off_time_hours..LangGameString[573] ) -- [572]="#c66ff66(积累:#cffff00" -- [573]="#c66ff66小时)"
    self.get_hours_num_edit.set_max_num( off_time_hours )
    self.get_hours_num_edit.set_num( off_time_hours )
    self:update_get_but_state(  )            -- 更新按钮状态

	self:update_can_get_exp()
end

-- 更新消耗总量
function DailyWelfareLD_lq:check_can_get(  )
    local rate = _rate_but_index_to_rate_t[ self.current_rate_index ]

    local if_can_get = WelfareModel:check_can_get_lingqi_by_rate( rate )

    if if_can_get then 
        self.consume_money_lable:setString( "#c66ff66(免费领取)" ) -- [582]="#c66ff66免费领取#cffff00"
    else
        local notice_word = _rate_to_can_not_get_word[ rate ] or ""
        self.consume_money_lable:setString( notice_word )
    end
end

-- 计算获取的灵气
function DailyWelfareLD_lq:update_can_get_exp(  )
    local num = self.get_hours_num_edit.get_num()
    local get_lingqi = WelfareModel:calculate_off_line_lingqi( num, self.current_rate_index )
    self.can_get_exp_lable:setString( "#c66ff66(可获得灵气:#cffff00"..get_lingqi..")" ) -- [586]="#c66ff66可获得灵气:#cffff00"
end

-- 更新领取按钮状态
function DailyWelfareLD_lq:update_get_but_state(  )
    local rate = _rate_but_index_to_rate_t[ self.current_rate_index ]

    local if_can_get = WelfareModel:check_can_get_lingqi_by_rate( rate )

    local num = self.get_hours_num_edit.get_num()       -- 获取时间输入 框数字
    if num < 1 or (not if_can_get) then
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
    else
        self.get_but.view:setCurState( CLICK_STATE_UP )
    end
end

function DailyWelfareLD_lq:update( update_type )
    if update_type == "all" then 
        self:update_get_but_state(  )
        self:update_can_get_exp()
        self:check_can_get(  )
        self:update_off_line_lingqi(  )
    end
end
