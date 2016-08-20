-- EntrustModel.lua
-- created by lyl on 2012-5-17
-- 委托系统

EntrustModel = {}

local _fuben_entrust_info_t = {}           -- 副本委托信息表  每个元素是 EntrustInfoStruct 结构， 使用fuben_id作为key存储

local _depot_item_list = {}                -- 委托仓库物品列表

local _entrust_restart_flag = {}           -- 标记某个副本是否从新上线后已经启动模拟

EntrustModel.DEPT_ITEM_GRID_COUNT = 30                -- 总共格子数

-- 个副本对应的 副本id
EntrustModel.lilianfuben    = 4
EntrustModel.shangjinfuben  = 8
EntrustModel.xinmohuanjing  = 58
EntrustModel.tianmota       = 64
EntrustModel.huantianmijing = 65
EntrustModel.xuantianfengyin= 66
EntrustModel.zhuxianzhen = 11
EntrustModel.mojierukou = 60

-- 个副本id对应的页号
EntrustModel.fuben_id_to_page = {
 [EntrustModel.lilianfuben] = 1,
 [EntrustModel.zhuxianzhen] = 2,
 [EntrustModel.shangjinfuben] = 3, 
 [EntrustModel.huantianmijing] = 4, 
 [EntrustModel.xinmohuanjing] = 5,
 [EntrustModel.mojierukou] = 6,
 [EntrustModel.xuantianfengyin] = 7,
 [EntrustModel.tianmota] = 8,
 }

local _entrust_result_str_t = {        -- 保存副本委托的结果
    
} 

local _entrusting_info_t = {        -- 委托中信息
    [EntrustModel.lilianfuben]     = {},
    [EntrustModel.zhuxianzhen]     = {},
    [EntrustModel.shangjinfuben]   = {},
    [EntrustModel.huantianmijing]  = {},
    [EntrustModel.xinmohuanjing]   = {},
    [EntrustModel.mojierukou]      = {},
    [EntrustModel.xuantianfengyin] = {},
    [EntrustModel.tianmota]        = {},
} 

-- local _fuben_strust_flag_t = {}       -- 副本委托中标记( 重登录情况下用 )

-- added by aXing on 2013-5-25
    function EntrustModel:fini( ... )
    _fuben_entrust_info_t = {}           -- 副本委托信息表  每个元素是 EntrustInfoStruct 结构， 使用fuben_id作为key存储
    _depot_item_list = {}                -- 委托仓库物品列表
    _entrusting_info_t = {        -- 委托中信息
        [EntrustModel.lilianfuben]     = {},
        [EntrustModel.zhuxianzhen]     = {},
        [EntrustModel.shangjinfuben]   = {},
        [EntrustModel.huantianmijing]  = {},
        [EntrustModel.xinmohuanjing]   = {},
        [EntrustModel.mojierukou]      = {},
        [EntrustModel.xuantianfengyin] = {},
        [EntrustModel.tianmota]        = {},
    } 
    -- _fuben_strust_flag_t = {}       -- 副本委托中标记( 重登录情况下用 )
end

-- ================================
-- 数据操作
-- ================================
-- 增加副本委托信息  ,  以 fuben_id 作为key存入表中
function EntrustModel:add_fuben_entrust_info( fuben_entrust_info )
	-- 测试用
	-- fuben_entrust_info.fuben_id = 65
	-- fuben_entrust_info.max_tier = 10
	-- fuben_entrust_info.entrust_times = 100
	-- fuben_entrust_info.state = 1
	-- fuben_entrust_info.repeat_online = 1
	-- fuben_entrust_info.remain_time = 100
	-- fuben_entrust_info.entrust_way = 1
	-- print("fuben_entrust_info....##########...  ", fuben_entrust_info.fuben_id, fuben_entrust_info.max_tier )
	if fuben_entrust_info and fuben_entrust_info.fuben_id then
        _fuben_entrust_info_t[ fuben_entrust_info.fuben_id ] = fuben_entrust_info
	end
    -- print( _fuben_entrust_info_t[ 4 ].max_tier )
    -- 如果有剩余时间，并且是重上线状态，  就开始显示委托，并且标记重上线为0
    if fuben_entrust_info.remain_time > 0 and fuben_entrust_info.repeat_online == 1 and 
        not _entrust_restart_flag[fuben_entrust_info.fuben_id] then
        EntrustModel:entrust_restart( fuben_entrust_info.fuben_id )
        fuben_entrust_info.repeat_online = 0
    end

	EntrustWin:update_win( "entrust_info" )
end

-- 副本最大通关层数变化
function EntrustModel:fuben_max_tier_change( fuben_id, max_tier )
    -- print("fuben_max_tier_change  副本最大通关层数变化")
    if _fuben_entrust_info_t[ fuben_id ] then
        _fuben_entrust_info_t[ fuben_id ].max_tier = max_tier
    end
	EntrustWin:update_win( "entrust_info" )
end

-- 根据 副本id获取副本委托信息
function EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    -- print("根据 副本id获取副本委托信息")
	return _fuben_entrust_info_t[ fuben_id ]
end

-- 根据副本id，获取副本委托基础信息
function EntrustModel:get_entrust_base_info( fuben_id )
	return EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
end

-- 设置委托仓库物品
function EntrustModel:set_depot_item_list( depot_item_list )
	print( "EntrustModel:set_depot_item_list~~~~!!!!~~~~~", #depot_item_list )
	_depot_item_list = depot_item_list
    -- local win = UIManager:show_window("fb_storage_win")
    -- if win then
    --     win:update(depot_item_list)
    -- end 
	EntrustWin:update_win( "depot_item" )
end

-- 根据副本id获取委托剩余时间
function EntrustModel:get_remain_time_by_fuben_id( fuben_id )
	local remain_time_ret = 0
	local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
	if entrust_info then
        remain_time_ret = entrust_info.remain_time
	end
	return remain_time_ret
end


-- 增加一个委托仓库物品
function EntrustModel:add_depot_item( new_item )
	-- local if_has_empty = false
	-- for i = 1, #_depot_item_list do 
 --        if _depot_item_list[i] == nil then
 --            _depot_item_list[i] = new_item
 --            if_has_empty = true
 --        end
	-- end
	-- if not if_has_empty then
           _depot_item_list[ #_depot_item_list + 1 ] = new_item   -- 利用“ # ”特性，取到的是第一个nil元素前的序号
	-- end

	EntrustWin:update_win( "depot_item" )
end

-- 获取委托仓库物品
function EntrustModel:get_depot_item_list(  )
	return _depot_item_list
end

-- 仓库物品数量变化
function EntrustModel:change_depot_item_count( series, count )
	for key, item in pairs(_depot_item_list) do 
		if item.series == series then
            item.count = count
        end
	end
    EntrustWin:update_win( "depot_item" )
end

-- 移除仓库中的物品  移到背包物品的GUID，如果为0表示要全部取出
function EntrustModel:remove_depot_item( series )
    -- print("EntrustModel:remove_depot_item( series )",series)
	if series == "0x0" then
        for i = 1, EntrustModel.DEPT_ITEM_GRID_COUNT do 
            _depot_item_list[i] = nil
        end
    else
    	for i = 1, EntrustModel.DEPT_ITEM_GRID_COUNT do 
            if _depot_item_list[i] == nil or _depot_item_list[i].series == series then
                _depot_item_list[i] = nil
            end
    	end
	end
	EntrustWin:update_win( "depot_item" )
    --火影代码
    -- local win = UIManager:find_visible_window("fb_storage_win")
    -- if win then
    --     win:update(_depot_item_list)
    -- end 
end

-- 判断仓库中是否 还有物品
function EntrustModel:check_depot_exist_item(  )
    for key, value in pairs( _depot_item_list ) do  
        return true
    end
    return false
end

-- 设置对应副本委托中信息  参数：副本idfuben_id, info:信息  if_cover_last：是否覆盖最后一个信息, if_add：是否跟重上线无关
function EntrustModel:add_entrusting_info( fuben_id, info, if_cover_last, if_add )
	-- print("EntrustModel:add_entrusting_info~~~~~!!!!!!~!!!", fuben_id, info, if_cover_last )
    -- 判断是否是重上线
    -- local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    local fuben_entrusting_info = _entrusting_info_t[ fuben_id ]
    local length = #fuben_entrusting_info

    -- if entrust_info and entrust_info.repeat_online == 1 then   -- 如果是重新上线, 不再显示第几层
    --     if if_add then
    --         fuben_entrusting_info[ length ] = "委托中..."
    --     else
    --         table.insert( fuben_entrusting_info, info )
    --     end
    -- else
        if _entrusting_info_t[ fuben_id ] then
            if if_cover_last then
                if length == 0 then 
                    length = 1 
                end
                fuben_entrusting_info[ length ] = info
            else
                table.insert( fuben_entrusting_info, info )
            end
        end
    -- end
	
	EntrustWin:update_win( "entrusting_info" )
end

-- 清空某个副本的委托中信息
function EntrustModel:clear_fuben_entrusting_info( fuben_id )
    _entrusting_info_t[ fuben_id ] = {}
end

-- 获取对应副本更新中信息
function EntrustModel:get_fuben_entrusting_info( fuben_id )
	-- print("EntrustModel:get_fuben_entrusting_info~~~~~!!!!!!~!!!", fuben_id, _entrusting_info_t[ fuben_id ], _entrusting_info_t[ fuben_id ].max_tier )
	local entrusting_info = _entrusting_info_t[ fuben_id ]
    if entrusting_info then
        return entrusting_info
    else
    	return nil
    end
end

-- 显示道具tips
function EntrustModel:show_tips( item_date )
    -- TipsModel:show_shop_tip( 200, 255, item_id, TipsModel.LAYOUT_CENTER)
    if item_date == nil then 
        return
    end
    local function get_out_func(  )
        EntrustCC:request_depot_item_move_to_bag( item_date.series )
    end
    TipsModel:show_tip( 200, 255, item_date, get_out_func, nil, false, Lang.entrust[21], nil, TipsModel.LAYOUT_LEFT, nil, nil) -- [26]="取出"
end

-- 获取某个副本的名称
function EntrustModel:get_fuben_name( fuben_id )
    local fuben_name = ""
    local fuben_info = FubenConfig:get_fuben_info_by_id( fuben_id )
    if fuben_info then
        fuben_name = fuben_info.fbname
    end
    return fuben_name
end

-- 设置某个副本委托的剩余时间
function EntrustModel:set_entrust_remain_time( fuben_id, remain_time )
    local fuben_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    if fuben_info then
        fuben_info.remain_time = remain_time or 0
    end
    -- print("副本的剩余时间",remain_time,fuben_info.remain_time)
end

-- 获取摸个副本剩余委托时间
function EntrustModel:get_entrust_remain_time( fuben_id )
    local fuben_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    if fuben_info then
        return fuben_info.remain_time
    end
    return 0
end

-- ================================
-- 逻辑相关
-- ================================
-- 打开副本委托窗口
function EntrustModel:open_entrust_page( fuben_id )
	local win = UIManager:show_window( "entrust_Win" )
	if win then
        win:change_page( fuben_id )
	end
end

-- 根据副本id，计算该副本委托需要的时间 
function EntrustModel:calculate_need_time( fuben_id )
	-- print("根据副本id，计算该副本委托需要的时间......", fuben_id)
	local need_time = 0
	local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
	if entrust_info then
        local max_tier = entrust_info.max_tier
        need_time = EntrustConfig:calculate_total_time( fuben_id, max_tier )
	end
	return need_time
end

-- 根据副本id，计算该副本委托能够获取的经验值
function EntrustModel:calculate_total_exp( fuben_id )
	local total_exp = 0
	local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
	if entrust_info then
		-- print("根据副本......", entrust_info, entrust_info.max_tier)
        local max_tier = entrust_info.max_tier
        total_exp = EntrustConfig:calculate_total_exp( fuben_id, max_tier )
	end
	return total_exp
end

-- 获取指定奖励类型的可获得数量  1: 经验  2：历练 3：仙币  4：银两
function EntrustModel:calculate_total_award_by_type( fuben_id, award_type )
    local max_tier = EntrustModel:get_max_entrust_tier( fuben_id )
    local total_award = EntrustConfig:calculate_total_award_by_type( fuben_id, max_tier, award_type )
    return total_award
end

-- 获取最大委托层数
function EntrustModel:get_max_entrust_tier( fuben_id )
	local max_tier_ret = 0
	local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
	if entrust_info then
        max_tier_ret = entrust_info.max_tier
	end
	return max_tier_ret
end

-- 获取某个副本剩余进入次数
function EntrustModel:get_fuben_remain_times( fuben_id )
	local enter_times, max_tiems = ActivityModel:get_enter_fuben_count( fuben_id ) 
	return max_tiems - enter_times
end

-- 打开神秘商店
function EntrustModel:open_mystical_shop(  )
    MysticalShopModel:open_shop_win_by_type(MysticalShopModel.OLD_SHOP)
end

-- 关闭委托窗口
function EntrustModel:close_entrust_win(  )
	UIManager:hide_window( "entrust_Win" )
	UIManager:show_window("activity_Win")
end

-- 重新上线的情况下，开始委托
function EntrustModel:entrust_restart( fuben_id )
    -- if _fuben_strust_flag_t[ fuben_id ] then
    --     return 
    -- end
    -- _fuben_strust_flag_t[ fuben_id ] = true                            -- 标记已经开始
    _entrust_restart_flag[ fuben_id ] = true

    local timer_temp = timer()                                         -- 定时回调
    local entrust_pre_time = os.clock()                                -- 上次记录剩余时间
    local remain_time = EntrustModel:get_entrust_remain_time( fuben_id )


    local function time_callback()
        remain_time = EntrustModel:get_entrust_remain_time( fuben_id )     -- 剩余时间
        if remain_time > 0 then
            local interval = os.clock() - entrust_pre_time
            local now_remain_time = remain_time - interval
            if now_remain_time < 0 then
                now_remain_time = 0
            end
            EntrustModel:set_entrust_remain_time( fuben_id, now_remain_time )  -- 刷新时间
            EntrustWin:update_win( "entrust_remain_time" )
            entrust_pre_time = os.clock()
        else
            EntrustModel:set_entrust_remain_time( fuben_id, 0 )
            EntrustWin:update_win( "entrust_remain_time" )
            EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[22]), true ) -- [110]="委托结束"

            local entrust_way = _fuben_entrust_info_t[fuben_id].entrust_way or 1
            local curr_max_times = _fuben_entrust_info_t[fuben_id].entrust_times or 1     -- 当前选择的挑战次数
            local notice_word = EntrustModel:entrust_result_str( fuben_id, entrust_way, curr_max_times )
            EntrustModel:add_entrusting_info( fuben_id, notice_word, false)
            timer_temp:stop()
        end
    end

    local fuben_name = EntrustModel:get_fuben_name( fuben_id )
    EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[23], fuben_name ), false ) -- [111]="#cffff00%s挑战中..."
    timer_temp:start( t_mmdl_, time_callback )                         -- 每秒钟判断一次
end

-- 委托开始，客户端根据副本时间来计算当前进行的层数,  curr_times: 当前第几次数
function EntrustModel:entrust_start( fuben_id, curr_times )
    -- print(" 委托开始，客户端根据副本时间来计算当前进行的层数,  curr_times: 当前第几次数")
    EntrustModel:clear_fuben_entrusting_info( fuben_id )
    local max_tier = EntrustModel:get_max_entrust_tier( fuben_id )    -- 最大层数
    local current_tier  = 1                                           -- 当前层数
    local curr_max_times = _fuben_entrust_info_t[fuben_id].entrust_times or 1     -- 当前选择的挑战次数
    local curr_times_temp = curr_times                                -- 当前第几次

    -- 设置初始时间
    local once_need_time = EntrustModel:calculate_need_time( fuben_id )                 -- 一次委托需要的时间
    local remain_times = curr_max_times -  curr_times_temp + 1                          -- 剩余自动委托的次数
    EntrustModel:set_entrust_remain_time( fuben_id, once_need_time * remain_times )     -- 设计当前剩余时间
    
    -- 委托中信息显示
    local fuben_name = EntrustModel:get_fuben_name( fuben_id )
    EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[24], fuben_name, curr_times_temp ), false ) -- [112]="#cffff00%s第%d次挑战中"
    EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[25], current_tier), false ) -- [113]="第%s层        战斗中..."

    -- 进行中。。。
    local tier_info = EntrustConfig:get_tier_info_by_id( fuben_id, current_tier )   -- 该层的委托配置信息
    local current_tier_need_time = 0                                  -- 当前层需要的时间
    if tier_info then
        current_tier_need_time = tier_info.time
    end
    local initial_remain_time = EntrustModel:get_entrust_remain_time( fuben_id )  -- 记录开始的时候委托时间，每轮结束，用这个来计算剩余时间，而不是置为0
    local one_time_need_time = EntrustModel:calculate_need_time( fuben_id )  -- 一轮委托需要的时间
    -- print("~开始~~~~~~~！！！！！！！！！！！！！！", initial_remain_time , one_time_need_time)
    local end_remain_time = initial_remain_time - one_time_need_time              -- 结束时，应该的剩余时间
    local entrust_pre_time = os.clock()                                           -- 委托时间 的上一次记录。使用这个来计算每次刷新剩余时间
    local tier_begin_time = entrust_pre_time                                      -- 一层的开始时间 
    EntrustWin:update_win( "entrust_remain_time" )                                -- 界面开始显示倒计时
    
    local timer_temp = timer()                                         -- 定时回调
    local function time_callback()
        local remain_time = EntrustModel:get_entrust_remain_time( fuben_id )
        -- print("剩余时间remain_time",remain_time)
        -- 如果因为外部原因结束，把时间设置为0
        if remain_time <= 0 then
            end_remain_time = 0
        end
        -- 层数还没超过最大可委托成，  距离上次委托时间已经超过该层的时间  或者剩余时间已经零 
        if (current_tier >= max_tier and os.clock() - tier_begin_time >= current_tier_need_time) or remain_time <= 0 then

            EntrustModel:set_entrust_remain_time( fuben_id, end_remain_time )          -- 重置剩余时间
            EntrustWin:update_win( "entrust_remain_time" )
            EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[26], current_tier), true ) -- [114]="第%s层:         #c66ff66胜利"

            if curr_times_temp < curr_max_times and remain_time > 0 then                   -- 如果还没到选择次数，重新开始
                curr_times_temp = curr_times_temp + 1
                end_remain_time = end_remain_time - one_time_need_time
                current_tier = 1
                tier_begin_time = os.clock()
                tier_info = EntrustConfig:get_tier_info_by_id( fuben_id, current_tier )
                if tier_info then
                    current_tier_need_time = tier_info.time            -- 当前层需要的时间
                end
                EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[24], fuben_name, curr_times_temp ), false ) -- [112]="#cffff00%s第%d次挑战中"
                EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[26], current_tier), false ) -- [115]="第%s层:        战斗中..."
                time_callback()
                return     -------//////////////
            end

            -- 显示委托奖励
            local entrust_way = _fuben_entrust_info_t[fuben_id].entrust_way or 1
            local notice_word = EntrustModel:entrust_result_str( fuben_id, entrust_way, curr_max_times )
            EntrustModel:add_entrusting_info( fuben_id, notice_word, false)
            timer_temp:stop()
            return
        else
            local time_interval = os.clock() - entrust_pre_time          -- 距离上次刷新的时间间隔
            local now_remain_time = remain_time - time_interval          -- 计算后的剩余时间
            if now_remain_time < end_remain_time then                    -- 如果小于结束时应该的时间，就设置为结束时间
                now_remain_time = end_remain_time
            end
            EntrustModel:set_entrust_remain_time( fuben_id, now_remain_time )  -- 刷新时间
            EntrustWin:update_win( "entrust_remain_time" )
            entrust_pre_time = os.clock()
        end
        if current_tier < max_tier and os.clock() - tier_begin_time >= current_tier_need_time then -- 如果距离该层开始时间大于 该层需要的时间，就开始下一层
            tier_begin_time = os.clock()                       -- 重置层的开始时间
            EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[26], current_tier), true ) -- [114]="第%s层:         #c66ff66胜利"
            current_tier = current_tier + 1
            EntrustModel:add_entrusting_info( fuben_id, string.format(Lang.entrust[27], current_tier), false ) -- [115]="第%s层:        战斗中..."

            tier_info = EntrustConfig:get_tier_info_by_id( fuben_id, current_tier )
            if tier_info then
                current_tier_need_time = tier_info.time       -- 这个时间以后，表示一层完成
            end
        end
    end
    
    timer_temp:start( t_mmdl_, time_callback )   -- 每秒钟判断一次

end

-- 委托结束
function EntrustModel:entrust_end( fuben_id, entrust_way )
print("EntrustModel:entrust_end@@@@@@@@@@EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE", fuben_id, entrust_way)
    -- _fuben_strust_way_t[ fuben_id ] = entrust_way
    local fuben_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    if fuben_info then
        fuben_info.entrust_way = entrust_way
    end

    EntrustModel:set_entrust_remain_time( fuben_id, 0 )          -- 重置剩余时间
    EntrustWin:update_win( "entrust_remain_time" )

    -- 弹出个 “委” 字迷你按钮， 点击会切换对应页
    local function mini_but_func(  )
        local win = UIManager:show_window( "entrust_Win" )
        if win then 
            win:change_page( fuben_id )
        end
    end
    MiniBtnWin:show( 17 , mini_but_func ,nil )

    -- 保存结果字符串
    if _fuben_entrust_info_t[fuben_id] then 
        local times = _fuben_entrust_info_t[fuben_id].entrust_times or 1
        local result_str = EntrustModel:entrust_result_str( fuben_id, entrust_way, times )
        _entrust_result_str_t[ fuben_id ] = result_str
        EntrustWin:update_win( "entrust_result" )
    end
end

-- 获取委托结果字符串
function EntrustModel:get_entrust_result_str( fuben_id )
    local ret_str = _entrust_result_str_t[ fuben_id ] or ""
    return ret_str
end

-- 置空委托结果字符串
function EntrustModel:set_entrust_result_str( fuben_id, str  )
    _entrust_result_str_t[ fuben_id ] = str or ""
    EntrustWin:update_win( "entrust_result" )
end

-- 获取某个副本委托得到的奖励提示字符串
function EntrustModel:entrust_result_str( fuben_id, entrust_way, times )
    -- 计算副本获得的各种奖励, 把信息加入到委托信息尾部
    local notice_word = Lang.entrust[28] --委托完毕,获得： " -- [116]="获得："
    local exp_type, lilian_type, xianbi_type, yingliang_type = EntrustModel:check_fuben_award_type( fuben_id )
    local max_tier = EntrustModel:get_max_entrust_tier( fuben_id )
    if exp_type then
        local exp_total = EntrustConfig:calculate_total_award_by_type( fuben_id, max_tier, 1 )
        if entrust_way == 1 then  -- 元宝委托
            local entrust_base_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
            local ybExpRate = entrust_base_info.ybExpRate or 1
            notice_word = notice_word.."#c66ff66"..(exp_total * times )..Lang.entrust[29]..(exp_total * (ybExpRate - 1 ) * times )..Lang.entrust[30]..(exp_total * ybExpRate * times )..Lang.entrust[31] -- [117]="经验#cffffff, 元宝加成 #c66ff66" -- [118]="经验#cffffff, 合计#c66ff66" -- [119]="经验#cffffff"
        else
            notice_word = notice_word.."#c66ff66"..exp_total * times..Lang.entrust[32] -- [120]="经验#cffffff   "
        end
    end
    if lilian_type then
        local exp_lilian = EntrustConfig:calculate_total_award_by_type( fuben_id, max_tier, 2 )
        notice_word = notice_word.."#c66ff66"..exp_lilian * times..Lang.entrust[33] -- [121]="历练#cffffff   "
    end
    if xianbi_type then
        local exp_xianbi = EntrustConfig:calculate_total_award_by_type( fuben_id, max_tier, 3 )
        notice_word = notice_word.."#c66ff66"..exp_xianbi * times..Lang.entrust[34] -- [122]="仙币#cffffff   "
    end
    if yingliang_type then
        local exp_yingliang = EntrustConfig:calculate_total_award_by_type( fuben_id, max_tier, 4 )
        notice_word = notice_word.."#c66ff66"..exp_yingliang * times..Lang.entrust[35] -- [123]="银两#cffffff   "
    end
    
    return notice_word
end

-- 判断某个副本，奖励类型：经验，历练，仙币等.  对应类型返回true
function EntrustModel:check_fuben_award_type( fuben_id )
	local award_type_t = EntrustConfig:get_award_type_by_fuben_id( fuben_id )
	local exp_type       = false
	local lilian_type    = false
	local xianbi_type    = false
	local yingliang_type = false
	for key, award_type in pairs( award_type_t ) do 
        if award_type == 1 then
            exp_type = true
        elseif award_type == 2 then
            lilian_type = true
        elseif award_type == 3 then
            xianbi_type = true
        elseif award_type == 4 then
            yingliang_type = true
        end
	end
	return exp_type, lilian_type, xianbi_type, yingliang_type
end

-- 检查副本达到的层数是否可以委托
function EntrustModel:check_if_can_entrust_with_tier( fuben_id )
	local check_ret = false
	local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
	local entrust_base_info = EntrustModel:get_entrust_base_info( fuben_id )
	if entrust_info and entrust_base_info then
        if entrust_info.max_tier >= entrust_base_info.floor then
            check_ret = true
        end
	end
	return check_ret
end

-- 检查副本是否只有一层. 
function EntrustModel:check_fuben_is_one_floor( fuben_id )
    local check_ret = false
    local entrust_base_info = EntrustModel:get_entrust_base_info( fuben_id )
    if entrust_base_info.floors and #entrust_base_info.floors == 1 then 
        check_ret = true
    end
    return check_ret
end

-- 检查玩家等级，是否达到可委托
function EntrustModel:check_player_level_if_can_entrust( fuben_id )
	local check_ret = false
	local entrust_base_info = EntrustModel:get_entrust_base_info( fuben_id )
	local player = EntityManager:get_player_avatar()
    if entrust_base_info then
        if entrust_base_info.level <= player.level then
            check_ret = true
        end
    end
    return check_ret
end

-- 检查玩家仙币是否达到委托需要
function EntrustModel:check_player_xianbi_if_can_entrust( fuben_id, times )
	local check_ret = false
	local entrust_base_info = EntrustModel:get_entrust_base_info( fuben_id )
	local player = EntityManager:get_player_avatar()
    if entrust_base_info then
        if entrust_base_info.xb * times <= player.bindYinliang then
            check_ret = true
        end
    end
    return check_ret
end

-- 检查玩家元宝是否达到委托需要
function EntrustModel:check_player_yuanbao_if_can_entrust( fuben_id, times)
	local check_ret = false
	local entrust_base_info = EntrustModel:get_entrust_base_info( fuben_id )
	local player = EntityManager:get_player_avatar()
    if entrust_base_info then
        if entrust_base_info.yb * times <= player.yuanbao then
            check_ret = true
        end
    end
    return check_ret
end

-- 判断是否完成了但 未领取奖励
function EntrustModel:check_if_had_not_get_award( fuben_id )
    -- print( "判断是否完成了但 未领取奖励/.......211",  fuben_id)
    local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_info then
        -- print( "判断是否完成了但 未领取奖励/.......211",  entrust_info.state)
        if entrust_info.state == 2 then
            return true
        end
    end
    return false
end

-- 设置某个副本的领取状态  0：未开始   1：开始了   2：完成未领取奖励
function EntrustModel:set_fuben_state( fuben_id, state  )
    print("EntrustModel:set_fuben_state fuben_id,state",fuben_id,state)
    local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_info then
        entrust_info.state = state
    end
    EntrustWin:update_win( "entrust_info" )
end

-- 获取委托副本的某个配置信息  
function EntrustModel:get_entrust_base_info_sub_info( fuben_id, info_type )
	local info_ret = ""
	local entrust_base_info = EntrustModel:get_entrust_base_info( fuben_id )
	if entrust_base_info then
        info_ret = entrust_base_info[info_type] or 0
	end
	return info_ret
end

-- 判断心魔幻境是否可以显示神秘商店  最大层数大于六级， 并且正在委托中或者已完成但未领取奖励
function EntrustModel:check_if_can_show_mystical_shop(  )
    local entrust_info = EntrustModel:get_entrust_info_by_fuben_id( EntrustModel.xinmohuanjing )
    if EntrustModel:get_max_entrust_tier( EntrustModel.xinmohuanjing ) >= 6 and
        entrust_info and entrust_info.state ~= 0 then
        return true
    end
    return false
end

-- ================================
-- 与服务器通讯
-- ================================
-- 获取委托副本信息
function EntrustModel:request_entrust_fuben_info( fuben_id )
	EntrustCC:request_entrust_fuben_info( fuben_id )
end 

-- 请求委托  entrust_way: 0:仙币 1：元宝     times: 次数
function EntrustModel:request_entrust( fuben_id, entrust_way, times )
	-- EntrustCC:request_entrust( fuben_id, entrust_way, times )
    -- 判断委托条件
    local if_can_entrust = true
    local notice_word = ""
    if not EntrustModel:check_player_level_if_can_entrust( fuben_id ) then               -- 玩家等级判断
        if_can_entrust = false
        local level_need = EntrustModel:get_entrust_base_info_sub_info( fuben_id, "level" )
        notice_word = string.format( Lang.entrust[36], level_need ) -- [124]="玩家达到%d级才可以委托!"

    elseif not EntrustModel:check_if_can_entrust_with_tier( fuben_id ) then                      -- 通关层数判断
    	if_can_entrust = false
    	local tier_need = EntrustModel:get_entrust_base_info_sub_info( fuben_id, "floor" )
        notice_word = ""
        if EntrustModel:check_fuben_is_one_floor( fuben_id ) then 
            notice_word = string.format(Lang.entrust[37] ) -- [125]="通关副本方可委托"
        else  
            notice_word = string.format( Lang.entrust[38], tier_need ) -- [126]="通过关第%d层才可以委托!"
        end

    elseif entrust_way == 0 then
        if not EntrustModel:check_player_xianbi_if_can_entrust( fuben_id, times ) then        -- 消耗仙币判断
        	if_can_entrust = false
        	local xianbi_need = EntrustModel:get_entrust_base_info_sub_info( fuben_id, "xb" )
        	notice_word = string.format( Lang.entrust[39], xianbi_need * times ) -- [127]="委托需要%d仙币!"
        end

    elseif entrust_way == 1 then
        if not EntrustModel:check_player_yuanbao_if_can_entrust( fuben_id, times ) then        -- 消耗元宝判断
        	if_can_entrust = false
        	local yuanbao_need = EntrustModel:get_entrust_base_info_sub_info( fuben_id, "yb" )
        	notice_word = string.format( Lang.entrust[40], yuanbao_need * times ) -- [128]="委托需要%d元宝!"
        end
    end

    -- 如果可以委托，就弹出确认框
    if if_can_entrust then
        local function confirm_func()                                                           -- 确认框回调
            _fuben_entrust_info_t[fuben_id].entrust_times = times
            -- local once_need_time = EntrustModel:calculate_need_time( fuben_id )                 -- 一次委托需要的时间
            -- EntrustModel:set_entrust_remain_time( fuben_id, once_need_time * times )
            EntrustCC:request_entrust( fuben_id, entrust_way, times )
        end

        local money_need  = 0         -- 需要的钱数
        local confirm_word = ""       -- 提示信息
        if entrust_way == 0  then
            local xianbi_need = EntrustModel:get_entrust_base_info_sub_info( fuben_id, "xb" )
            money_need = xianbi_need * times
            confirm_word = string.format( Lang.entrust[41], money_need ) -- [129]="仙币委托, 需要%d仙币"
        else
            local yuanbao_need = EntrustModel:get_entrust_base_info_sub_info( fuben_id, "yb" )
            money_need = yuanbao_need * times
            confirm_word = string.format( Lang.entrust[42], money_need ) -- [130]="元宝委托, 需要%d元宝"
        end
	    ConfirmWin2:show( 4, 1, confirm_word,   confirm_func, nil )
	else
        GlobalFunc:create_screen_notic( notice_word, 20, 240, 250 )
    end
end

-- 立即完成
function EntrustModel:request_complete_immediately( fuben_id )
    -- 计算立即完成消耗的元宝
    local remain_time = EntrustModel:get_entrust_remain_time( fuben_id )
    local yuanbao_per_20second = 0
    local entrust_base_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_base_info then
        yuanbao_per_20second = entrust_base_info.ljyb         -- 立即完成每剩余20秒需要的元宝
    end
    
    local function confirm_func(  )
        EntrustCC:request_complete_immediately( fuben_id )
    end
    local consume_yuanbao = math.floor(  ( remain_time / 360 ) * yuanbao_per_20second )
    if consume_yuanbao == 0 and remain_time > 0 then 
        consume_yuanbao = 1
    end
    local confirm_word = string.format( Lang.entrust[43], consume_yuanbao ) -- [131]="立即完成, 需要%d元宝"
    ConfirmWin2:show( 4, 1, confirm_word,  confirm_func, nil )
end

--  获取经验
function EntrustModel:request_get_exp( fuben_id )
	EntrustCC:request_get_exp( fuben_id )
end 

-- 获取委托仓库物品列表
function EntrustModel:request_depot_item_list()
	EntrustCC:request_depot_item_list()
end 

-- c->s 42,2  委托仓库物品移动到背包   series:移到背包物品的GUID，如果为0表示要全部取出
function EntrustModel:request_depot_item_move_to_bag( series )
	EntrustCC:request_depot_item_move_to_bag( series )
end 
