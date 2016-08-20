-- WelfareModel.lua
-- created by lyl on 2013-3-6
-- 福利

-- super_class.WelfareModel()
WelfareModel = {}


local _login_award_list = {}          -- 连续登录奖品    LoginAwardStruct 结构
local _login_award_list_vip = {}      -- vip连续登录奖品 LoginAwardStruct 结构
local _continuity_days = 1            -- 连续登录的天数
local _award_get_state_list = {}      -- 奖品获取的状态     0表示不可领取，1表示未领取，2表示已领取  
-- （手游版只有一列奖品，如果是vip，会同时领取两个，所以只设置这一列）
local __award_get_state_list_vip = {} -- 奖品获取的状态vip  0表示不可领取，1表示未领取，2表示已领取

local _off_line_hours      = 0        -- 离线小时数
local _off_line_exp        = 0        -- 离线经验
local _half_exp            = 0        -- 离线0.5经验 单价
local _one_exp             = 0        -- 离线1倍经验金钱单位 单价
local _one_point_five_exp  = 0        -- 离线1.5倍经验金钱单位  单价
local _two_exp             = 0        -- 离线2倍经验金钱单位  单价

local _lingqi_no_online_hours     = 0        -- 灵气离线小时数
local _lingqi_no_online_total     = 0        -- 灵气积累
local _lingqi_ratio_1_vip_level   = 0        -- 离线1倍灵气所需要仙尊等级
local _lingqi_ratio_2_vip_level   = 0        -- 离线2倍灵气所需要仙尊等级
local _lingqi_ratio_3_vip_level   = 0        -- 离线3倍灵气所需要仙尊等级

local _if_had_get_vip_award= 0       -- 是否已经领取vip每日登录奖励   1：已经领取   0：未领取   -1：不是VIP用户

local _exp_back_fuben_list = {}       -- 经验找回，副本的数据列表  元素结构： {id：副本id, times ：次数 }
local _get_exp_back_fuben_state = 0  -- 是否已经领取副本经验   0 不可领取 1可领取  2 已经领取
local _exp_back_fuben_total_exp = 0   -- 副本经验找回，总的经验
local _exp_back_fuben_need_money = 0  -- 副本经验找回，全部领取需要的金钱

local _exp_back_daily_list = {}       -- 经验找回，日常任务的数据列表  元素结构： {id：副本id, times ：次数 }
local _get_exp_back_daily_state = 0   -- 是否已经领取日常任务经验  0 不可领取 1可领取  2 已经领取
local _exp_back_daily_total_exp = 0   -- 日常任务经验找回，总的经验
local _exp_back_daily_need_money = 0  -- 日常任务经验找回，需要的金钱

local _max_award_level     = 0        -- 可获取的最大充值礼包等级
local _get_state           = 0        -- 礼包领取状态：用一个八位的二进制数据，每一位 0 或者 1 来表示。 1表示已领取，第一个礼包从第0位开始，第一个礼包是首充礼包
local _remain_time         = 0        -- 剩余时间

local _is_run_check_offline = false
-- added by aXIng on 2013-5-25
function WelfareModel:fini( ... )
	_login_award_list = {}
	_login_award_list_vip = {}
	_award_get_state_list = {}
	__award_get_state_list_vip = {}

	_off_line_hours      = 0
	_off_line_exp        = 0
	_half_exp            = 0
	_one_exp             = 0
	_one_point_five_exp  = 0
	_two_exp             = 0 

	_lingqi_no_online_hours     = 0
    _lingqi_no_online_total     = 0  
    _lingqi_ratio_1_vip_level   = 0  
    _lingqi_ratio_2_vip_level   = 0    
    _lingqi_ratio_3_vip_level   = 0   

	_if_had_get_vip_award= 0 

	_exp_back_fuben_list = {}
	_get_exp_back_fuben_state = 0
	_exp_back_fuben_total_exp = 0 

	_exp_back_daily_list = {}
	_get_exp_back_daily_state = 0
	_exp_back_daily_total_exp = 0 

	_max_award_level     = 0
	_get_state           = 0
	_remain_time         = 0 
	_is_run_check_offline = false
end

-- 每日福利，活跃奖励更新
-- 改到在美女助手下
function WelfareModel:update_activity_win( update_type )
    -- require "UI/activity/ActivityWin"
    -- ActivityWin:update_win( update_type )
    -- require "UI/secretary/SecretaryWin"
    -- SecretaryWin:update_win( update_type )
    --美女助手在火影中是登录服务端就下发更新的  注意
    --每日福利 活跃奖励 改为福利面板下
    require "UI/benefit/BenefitWin"
    local win  = UIManager:find_visible_window("benefit_win")
    if win then 
    	 if win.all_page_t[1] then
    	 	  win.all_page_t[1]:update(update_type)
    	 end
    end

end

--更新美女助手相关
function WelfareModel:update_secretary_win( update_type )
    require "UI/secretary/SecretaryWin"
    SecretaryWin:update_win( update_type )
end

-- ================================
-- 数据操作
-- ================================
-- 设置连续登录奖品
function WelfareModel:set_login_award_list( award_list, continuity_days )
	_login_award_list = award_list
	_continuity_days = continuity_days
	WelfareModel:update_activity_win( "award_list" )

	--刷新小秘书窗口
	SecretaryModel:update_win( "award_list" )

	WelfareModel:request_login_current_item(  )     -- 设置完物品后，设置领取状态
	SecretaryModel:update_win( "continuity_days" )
end

-- 获取连续登录奖品列表
function WelfareModel:get_login_award_list(  )
	return _login_award_list
end

-- 设置vip连续登录奖品
function WelfareModel:set_login_award_list_vip( award_list )
	_login_award_list_vip = award_list
end

-- 根据序列号获取奖品  VIP
function WelfareModel:get_vip_award_by_index( index )
	local ret = {}
	if index then
        ret = _login_award_list_vip[ index ] or {}
	end
    return ret
end



-- 根据序列号获取奖品
function WelfareModel:get_award_by_index( index )
	local ret = {}
	if index then
        ret = _login_award_list[ index ] or {}
	end
    return ret
end


-- 每日福利  根据序列号获取领取状态 
function WelfareModel:get_award_state_by_index( index )
	return _award_get_state_list[ index ] or 0
end

-- 每日福利  设置普通玩家的领取状态  与vip同用
function WelfareModel:set_award_get_state_list( award_get_state_list,vip_award_state_list)
	--xprint("这里是设置  ")

	_award_get_state_list = award_get_state_list
	__award_get_state_list_vip = vip_award_state_list
    
    -- print(#_award_get_state_list)
    -- print(#__award_get_state_list_vip)
    -- for i=1,#_award_get_state_list do
    -- 	print(WelfareModel:get_award_state_by_index( i ) )
    -- end
	WelfareModel:update_activity_win( "award_state_list" )
	SecretaryModel:update_win( "award_state_list" )
end

-- 每日福利  获取普通玩家的领取状态  与vip同用
function WelfareModel:get_award_get_state_list(  )
	return _award_get_state_list
end



function WelfareModel:get_vip_award_state_by_index( index )
	return __award_get_state_list_vip[ index ] or 0
end

-- 每日福利 判断是否有道具可以领取
function WelfareModel:get_longin_award_had_not_get(  )
	local total = 0
	for i = 1, #_award_get_state_list do 
	--	print(WelfareModel:get_award_state_by_index( i ) )
        if WelfareModel:get_award_state_by_index( i ) == 1 then
            total = total + 1
        end
	end
    
     local vipInfo = VIPModel:get_vip_info()
	-- if vipInfo.level > 0 then
		
		for i = 1, #__award_get_state_list_vip do 
		    if WelfareModel:get_vip_award_state_by_index( i ) == 1 then
		        total = total + 1
		    end
		end
	-- end
	return total
end

-- 获取连续登录的天数
function WelfareModel:get_continuity_login_days(  )
	return _continuity_days
end


-- 设置离线经验相关数据
function WelfareModel:set_off_line_exp_date( off_line_hours, off_line_exp, half_exp, one_exp, one_point_five_exp, two_exp )
	-- xprint("elfareModel:set_off_line_exp_date( off_line_hours, off_line_exp, half_exp, one_exp, one_point_five_exp, two_exp )")

	_off_line_hours = off_line_hours
	_off_line_exp = off_line_exp
	_half_exp = half_exp
	_one_exp = one_exp
	_one_point_five_exp = one_point_five_exp
	_two_exp = two_exp

	-- WelfareModel:update_activity_win( "off_exp" )
	-- WelfareModel:update_activity_win( "off_line_exp_consume" )
	WelfareModel:check_offer_line_time()
	BenefitModel:update_win("off_line_expxp")
	BenefitModel:update_win("off_line_exp_consume")

	--添加福字下发
	    require "model/WelfareModel"
    --added  by xiehande
    if WelfareModel:get_off_line_exp() > 0  then
    	print("离线经验有未领取")
    	BenefitModel:show_benefit_miniBtn()
    end


end

-- 获取离线小时数
function WelfareModel:get_off_line_hours(  )
	return _off_line_hours
end

-- 获取离线经验
function WelfareModel:get_off_line_exp(  )
	return _off_line_exp
end

-- 设置离线灵气数据
function WelfareModel:set_off_line_lingqi_date( not_online_hours, lingqi_total, ratio_1_vip_level, ratio_2_vip_level, ratio_3_vip_level )
	-- print("设置离线灵气数据   ", not_online_hours, lingqi_total, ratio_1_vip_level, ratio_2_vip_level, ratio_3_vip_level )
	_lingqi_no_online_hours = not_online_hours
	_lingqi_no_online_total = lingqi_total
	_lingqi_ratio_1_vip_level = ratio_1_vip_level
	_lingqi_ratio_2_vip_level = ratio_2_vip_level
	_lingqi_ratio_3_vip_level = ratio_3_vip_level

	WelfareModel:update_activity_win( "off_lingqi" )
	WelfareModel:check_offer_line_time()
end

-- 获取灵气离线奖励时间
function WelfareModel:get_off_line_lingqi(  )
	return _lingqi_no_online_hours
end

-- 设置是否已经领取vip每日登录奖励
function WelfareModel:set_if_had_get_vip_award( if_had_get )
	_if_had_get_vip_award = if_had_get
	WelfareModel:update_activity_win( "if_had_get_vip_award" )
	SecretaryModel:update_win( "if_had_get_vip_award" )

	--添加福字下发
	    require "model/WelfareModel"
    --added  by xiehande
    if WelfareModel:get_if_had_get_vip_award() == 0  then
    	print("vip有未领取")
    	BenefitModel:show_benefit_miniBtn()
    end

end

-- 获取vip每日奖励领取状态
function WelfareModel:get_if_had_get_vip_award(  )
	return _if_had_get_vip_award
end

-- 设置经验找回数据
function WelfareModel:set_exp_back_date( date_type, state, can_get_exp, need_money, list )
	print("WelfareModel:set_exp_back_date~~~!!!~~~", date_type, state, can_get_exp, need_money, list )
	if date_type == 1 then
        _get_exp_back_fuben_state = state
        _exp_back_fuben_total_exp = can_get_exp
        _exp_back_fuben_need_money = need_money
        _exp_back_fuben_list = list
	else
        _get_exp_back_daily_state = state
        _exp_back_daily_total_exp = can_get_exp
        _exp_back_daily_need_money = need_money
        _exp_back_daily_list = list
	end
	BenefitModel:update_win( "exp_back" )
end

-- 初始化经验找回数据（点击按钮后，调用）
function WelfareModel:init_exp_back_date( date_type )
	print("WelfareModel:init_exp_back_date( date_type )",date_type)
	if date_type == 1 then
        _get_exp_back_fuben_state = 0
        _exp_back_fuben_total_exp = 0
        for key, value in pairs(_exp_back_fuben_list) do
            value.times = 0
        end
    else
    	_get_exp_back_daily_state = 0
        _exp_back_daily_total_exp = 0
        for key, value in pairs(_exp_back_daily_list) do
            value.times = 0
        end
	end
	BenefitModel:update_win( "exp_back" )
end

--根据类型获取副本或者日常任务数据
function WelfareModel:get_list_date_by_type( date_type )
	print("WelfareModel:get_list_date_by_type( date_type )",date_type)
	    local list  = {}
	    if date_type == 1 then
        list = _exp_back_fuben_list
    else
    	list = _exp_back_daily_list
    end
    return list
end
-- 根据类型获取经验找回数据：任务累计次数， 可获得经验， 领取状态  1: 副本经验找回系统 2: 任务
function WelfareModel:get_exp_back_date_by_type( date_type )
    -- 计算累计次数
    local total_count = 0
    local total_exp   = 0
    local get_state   = 0
    local need_money  = 0
    local list = {}  
    if date_type == 1 then
        list = _exp_back_fuben_list
        total_exp = _exp_back_fuben_total_exp
        get_state = _get_exp_back_fuben_state
        need_money = _exp_back_fuben_need_money
    else
    	list = _exp_back_daily_list
    	total_exp = _exp_back_daily_total_exp
        get_state = _get_exp_back_daily_state
        need_money = _exp_back_daily_need_money
    end
    -- 计算总数
    for key, date in pairs(list) do 
        total_count = total_count + date.times
    end
    return total_count, total_exp, get_state, need_money
end

-- 获取充值礼包的奖励道具 index： 充值礼包的序列号
function WelfareModel:get_recharge_award_items( index )
	require "config/GlobalConfig"
	return GlobalConfig:get_recharge_award_items( index )
end

-- 设置充值礼包的领取情况和剩余时间
function WelfareModel:set_recharge_award_date( max_award_level, get_state, remain_time )
	_max_award_level = max_award_level
	_get_state       = get_state
	_remain_time	 = os.clock() + remain_time;
	-- _remain_time     = GameStateManager:get_total_seconds(  ) + remain_time ; -- model保存的是活动结束的时间点
	if _max_award_level == 1 then
		-- SCLBModel:update_is_get_item(_get_state)
	else
		WelfareModel:update_activity_win( "recharge_award" )
	end
end

-- 设置充值礼包的领取情况和剩余时间
function WelfareModel:set_recharge_award_date_ex( level, state, time, money )
	_max_award_level = level
	_get_state       = state
	_remain_time     = os.clock() + time ; -- model保存的是活动结束的时间点
	if _max_award_level == 1 then
		--SCLBModel:update_is_get_item(_get_state)
	else
		WelfareModel:update_activity_win( "recharge_award" )
	end
end

-- 获取剩余时间
function WelfareModel:get_remain_time(  )
	return _remain_time - os.clock(  ); -- 返回时，减去当前游戏时间，返回一个时间段
end

-- 获取可领取的最大礼包等级
function WelfareModel:get_max_award_level(  )
	local return_value = _max_award_level
	-- 对于没有充值情况下，服务器发来1，这时要判断是否充过值。没有充过，则可领取等级为0
	require "model/VIPModel"
	local vip_info = VIPModel:get_vip_info( )
	local had_recharge = vip_info.all_yuanbao_value or 0       -- 已充值数
	if had_recharge == 0 then
        return_value = 0
	end
	return return_value
end

-- 根据序列号，获取某个充值奖品等级的领取状态，第一个礼包是首充礼包
function WelfareModel:get_recharge_award_state( index )
	return Utils:get_bit_by_position( _get_state, index )
end

-- 获取当前充值数
function WelfareModel:get_current_rechange_value(  )
	require "model/VIPModel"
	local vip_info = VIPModel:get_vip_info( )
	local ret = vip_info.all_yuanbao_value or 0
	-- ret = 1000
	return ret
end

-- 每日福利： 根据等级 获取 仙尊返利 奖励信息
function WelfareModel:get_back_award_explain(  )
	require "model/VIPModel"
    local vip_info = VIPModel:get_vip_info( )
    local vip_level = vip_info.level

	require "config/VIPConfig"
	local vip_level_info = VIPConfig:get_vip_level_info( vip_level )

	local add_task = VIPConfig:get_vip_level_add_task( vip_level ) or ""

	return vip_level, vip_level_info, add_task
end
-- ================================
-- 逻辑相关
-- ================================
-- 根据当前选中的倍率和数字，计算需要花费的总价格  rate_type 1 ：0.5    2:1  3:1.5   4:2,  num 数量
function WelfareModel:calculate_total_price( rate_type, num )
	local price = 0
	if rate_type == 1 then
        price = _half_exp
    elseif rate_type == 2 then
        price = _one_exp
    elseif rate_type == 3 then
        price = _one_point_five_exp
    elseif rate_type == 4 then
        price = _two_exp
	end

	return  num * price
end

-- 离线经验  根据传入的时间(单位：小时)，倍率序列号 计算相应的的离线经验
function ActivityModel:calculate_off_line_exp( hours, rate_index )
	if _off_line_exp == 0 then
        return 0
	end
	local rate_t = { 0.5, 1, 2, 3 }
	local get_exp = _off_line_exp * ( hours / _off_line_hours ) * rate_t[ rate_index ]
	get_exp = math.floor( get_exp )
    return get_exp
end

-- 离线灵气  根据传入的时间(单位：小时)，倍率序列号 计算相应的的离线经验
function WelfareModel:calculate_off_line_lingqi( hours, rate_index )
	if _lingqi_no_online_total == 0 then 
        return 0
	end
	local rate_t = { 1, 1.5, 2 }
	local rate = rate_t[ rate_index ] or 1
	local get_lingqi = _lingqi_no_online_total * ( hours / _lingqi_no_online_hours ) * rate
	get_lingqi = math.floor( get_lingqi )
	return get_lingqi
end

-- 根据倍数， 判断是否可以领取离线灵气，
function WelfareModel:check_can_get_lingqi_by_rate( rate )
	-- print("根据倍数， 判断是否可以领取离线灵气，", rate )
	local check_ret = false
	local vip_info = VIPModel:get_vip_info()
	if rate == 1 then 
        check_ret = true
	elseif rate == 1.5 and vip_info and vip_info.level >= 5 then 
        check_ret = true
	elseif rate == 2 and vip_info and vip_info.level >= 10 then 
        check_ret = true
	end
	return check_ret
end

-- 获取下一个等级的充值要求
function ActivityModel:get_next_level_recharge(  )
	local level_to_nedd_recharge_t = { 1, 500, 2000, 5000, 10000, 20000, 30000 }
	local max_award_level = WelfareModel:get_max_award_level(  )
    return level_to_nedd_recharge_t[ max_award_level + 1 ] or 30000
end

-- 获取当前礼品的价值的图片
function ActivityModel:get_current_gift_value_image( index )
	local value_image_t = {
	 UIResourcePath.FileLocate.newactivity .. "888yuanbao.png",
	 UIResourcePath.FileLocate.newactivity .. "1088yuanbao.png",
	 UIResourcePath.FileLocate.newactivity .. "1288yuanbao.png",
	 UIResourcePath.FileLocate.newactivity .. "1888yuanbao.png",
	 UIResourcePath.FileLocate.newactivity .. "2888yuanbao.png",
	 UIResourcePath.FileLocate.newactivity .. "5888yuanbao.png",
	 UIResourcePath.FileLocate.newactivity .. "8888yuanbao.png" }
    return value_image_t[ index ]
end

-- 判断是否还有为领取的礼包
function ActivityModel:check_if_has_no_get_award(  )
	local max_award_level = WelfareModel:get_max_award_level()

	for i = 1, max_award_level do
        local state = WelfareModel:get_recharge_award_state( i )
        if state ~= 1 then           -- 有未领取的礼包，就返回true
            return true
        end
	end
	return false                     -- 全领取了
end

-- 判断是否显示充值礼包界面   在活动时间为0，并且可领取礼包等级小于2的情况下，不显示
function ActivityModel:check_if_show_recharge_gift(  )
	local max_award_level = WelfareModel:get_max_award_level()

    local if_had_award_get = ActivityModel:check_if_has_no_get_award(  )
	if _remain_time < 1 and max_award_level < 2  then
        return false          -- 不显示
    elseif _remain_time < 1 and ( not if_had_award_get )  then
        return false          -- 不显示 
	end
	return true
end
-- ================================
-- 与服务器通讯
-- ================================
-- 请求连续登录领奖列表
function WelfareModel:request_login_award_list(  )
	require "control/OnlineAwardCC"
	OnlineAwardCC:request_login_award_list()
end

-- 请求连续登录当前物品 的领奖情况
function WelfareModel:request_login_current_item(  )
	require "control/OnlineAwardCC"
	OnlineAwardCC:request_login_current_item(  )
end

-- 请求领取连续登录奖品 （非vip）  参数：第几个，从1开始 
function WelfareModel:request_get_award_by_index( index,get_type,if_be_vip )

   -- todo
	-- vip也同时领取
	-- local if_be_vip = true
	if if_be_vip then
		OnlineAwardCC:rquest_get_login_award_item( index )
	    OnlineAwardCC:rquest_get_login_award_vip_item( index )
	    return
	end


	require "control/OnlineAwardCC"
	if get_type ==1 then  --普通玩家
	OnlineAwardCC:rquest_get_login_award_item( index )
	elseif get_type==2 then    --vip玩家
		 
	   OnlineAwardCC:rquest_get_login_award_vip_item( index )
	end

 
end

-- 领取所有连续登录奖品
function WelfareModel:request_get_all_login_award(  )
	for i = 1, #_award_get_state_list do 
        if _award_get_state_list[ i ] == 1 then 
            WelfareModel:request_get_award_by_index( i, 1, false )
        end
	end 
	local vip_info = VIPModel:get_vip_info()
	if vip_info.level > 0 then
		for i = 1, #_award_get_state_list do 
	        if _award_get_state_list[ i ] == 2 then 
	            WelfareModel:request_get_award_by_index( i, 2, false )
	        end
		end 
	end
end

-- 查询有多少离线经验
function WelfareModel:request_off_line_exp(  )
	require "control/OnlineAwardCC"
	OnlineAwardCC:request_off_line_exp(  )
end

-- 查询有多少离线灵气
function WelfareModel:request_off_line_lingqi(  )
	OnlineAwardCC:request_lingqi_not_online(  )
end

-- 领取vip用户每天登录奖励
function WelfareModel:get_vip_day_login_award(  )
	require "control/OnlineAwardCC"
	OnlineAwardCC:get_vip_day_login_award(  )
end

-- 查询是否已经领取vip登录奖励
function WelfareModel:query_if_had_get_vip_award(  )
	require "control/OnlineAwardCC"
	OnlineAwardCC:query_if_had_get_vip_award(  )
end

-- 请求获取离线经验  rate 1: 0.5倍    2: 1倍     3: 1.5倍    4: 2倍   hours 小时数
function WelfareModel:request_get_off_line_exp( rate, hours )
	-- 元宝不够，给提示
    local total_price = WelfareModel:calculate_total_price( rate, hours )   -- 获取总价格
    if rate ~= 3 and rate ~= 4 then   -- 只有1.5倍和2倍是元宝
        total_price = 0
    end
    -- local player = EntityManager:get_player_avatar()
 --    print("total_price,,,,  ", total_price)
	-- if player.yuanbao < total_price then 
 --        local function confirm2_func()
 --            GlobalFunc:chong_zhi_enter_fun()
 --            --UIManager:show_window( "chong_zhi_win" )
 --    	end
 --    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
 --        return 
	-- end
	local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
	local param = {rate, hours, money_type}
	local get_func = function( param )
		require "control/OnlineAwardCC"
		OnlineAwardCC:request_get_off_line_exp( param[1], param[2], param[3] )
	end
	MallModel:handle_auto_buy( total_price, get_func, param )
    
end

-- 请求经验找回系统数据  date_type : 1是副本积累  2 是日常任务积累
function WelfareModel:req_exp_back_date( date_type )
	require "control/MiscCC"
	MiscCC:req_exp_back_date( date_type )
end

-- 领取经验找回系统奖励  类型(1 副本 2 日常任务 )  领取方式（免费， 元宝）
function WelfareModel:req_get_exp_back_award( get_type, get_way )
    -- 元宝不够，给提示
    -- print("WelfareModel:req_get_exp_back_award( get_type, get_way )",get_type,get_way)
    local total_count, total_exp, get_state, need_money = WelfareModel:get_exp_back_date_by_type( get_type )
    if get_way == 1 then   -- 免费领取不用弹出提示
        need_money = 0
    end
 --    local player = EntityManager:get_player_avatar()
	-- if player.yuanbao < need_money then 
 --        local function confirm2_func()
 --            -- print("打开充值界面")
 --            GlobalFunc:chong_zhi_enter_fun()
 --            --UIManager:show_window( "chong_zhi_win" )
 --    	end
 --    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
 --        return 
	-- end

 --    local player = EntityManager:get_player_avatar()
 --    if player.yuanbao >= 22 or get_way == 1 then
 --        require "control/MiscCC"
	--     MiscCC:req_get_exp_back_award( get_type, get_way )
	--     WelfareModel:init_exp_back_date( get_type )
	-- else
 --        GlobalFunc:create_screen_notic( "元宝不足" )
 --    end
 	local money_type = MallModel:get_only_use_yb() and 3 or 2
 	local param = {get_type, get_way, money_type}
	local get_func = function( param )
		MiscCC:req_get_exp_back_award( param[1], param[2], param[3] )
		WelfareModel:init_exp_back_date( param[1] )
	end
	MallModel:handle_auto_buy( need_money, get_func, param )
end

-- 领取充值礼包  从0开始
function WelfareModel:get_recharge_award( award_index )
	require "control/MiscCC"
	OnlineAwardCC:get_recharge_award( award_index )
end

-- 请求获取灵气  lingqi_type: 灵气类型。 1：1倍领取  2: 1.5倍领取  3: 2倍领取
function WelfareModel:request_obtain_lingqi( lingqi_type, hours )
	OnlineAwardCC:request_get_lingqi( lingqi_type, hours )
end

-- 初始化福利界面所有数据
function WelfareModel:request_all_welfare_date(  )
	WelfareModel:request_login_award_list(  )
	WelfareModel:request_off_line_exp(  )    -- 请求服务器下发离线经验
	WelfareModel:query_if_had_get_vip_award(  )     -- 申请服务器下发是否已经领取?

	WelfareModel:request_off_line_lingqi(  ) -- 请求离线灵气
	WelfareModel:req_exp_back_date( 1 )       -- 请求经验找回系统数据  副本
    WelfareModel:req_exp_back_date( 2 )       -- 请求经验找回系统数据  日常任务
end

function WelfareModel:get_daily_awrads_state()

	  --每日登陆
    if WelfareModel:get_longin_award_had_not_get() > 0 then
        -- print("每日登陆有未领取")
        return 1
    elseif ActivityModel:check_had_activity_award() then
    	return 1
     --vip返利
    elseif WelfareModel:get_if_had_get_vip_award() == 0 then  --0：未领取  1：已领取  -1：非vip
       -- print("vip有未领取")
        return 1
        --离线经验
    elseif WelfareModel:get_off_line_exp() > 0 then
        -- print("离线经验有未领取")
        return 1

    --灵气不在福利面板中
    -- elseif WelfareModel:get_off_line_lingqi() > 0 then
    --     -- print("离线灵气有未领取")
    --     return 1
    else
        local a1,a2,a3,a4 = WelfareModel:get_exp_back_date_by_type(1)
        local b1,b2,b3,b4 = WelfareModel:get_exp_back_date_by_type(2)

        if a3 == 1 then
           -- print("副本累计有未领取")
            return 1
        elseif b3 == 1 then
           -- print("任务累计有未领取")
            return 1
        end
    end
    -- print("没有未领取状态")
    return 0
end

function WelfareModel:set_is_check_off_line(result)
	_is_run_check_offline = result
end

function WelfareModel:check_offer_line_time()
	print("WelfareModel:check_offer_line_time()")
	if (_off_line_hours > 0) and _is_run_check_offline == false then
		--xprint("run check_offer_line_time")
		_is_run_check_offline = true

		-- local function temp_fun()
		-- 	local win = UIManager:show_window("benefit_win")
		-- 	if win~=nil then
		-- 		-- win:change_page(3)
		-- 		win:change_page(1)
		-- 	end 
		-- end
	else
		return false
	end
end

function WelfareModel:play_fu_li_index_effect(index)
	local activity_Win = UIManager:find_visible_window("activity_Win")
	if ( (index == 1 and _off_line_hours > 0) or (index == 2 and _lingqi_no_online_hours > 0) ) and activity_Win ~= nil then
		--xprint('run play_fu_li_index_effect')
		LuaEffectManager:play_view_effect( 9,225,73,activity_Win.view,false,9999)
	end
end