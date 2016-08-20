-- WholeModel.lua
-- created by lyl on 2012-6-18
-- 显示在整个UI上层的内容

WholeModel = {}

-- 延时检测
local _delay_checking_flag    = false      -- 标记是否正在检测
local _delay_check_begin_time = 0         -- 延时检查开始时间
local _net_delay              = 0         -- 网络延时
local _net_delay_t            = {}        -- 网络延时集合，每次获取到延时放入，当显示的时候计算平均值并清空
local _delay_check_timer      = nil       -- 定时回调
local _delay_display_timer    = nil
local _SHOW_DELAY_INTERVAL    = 1         -- 刷新显示延时到界面的时间间隔，一秒一次，
local _pre_show_time          = 0         -- 上一次刷新延时的时间

function WholeModel:fini( ... )
	_delay_check_begin_time = 0
	_net_delay            = 0
	_delay_checking_flag    = false

	if _delay_check_timer then
	    _delay_check_timer:stop()
	    _delay_check_timer = nil
	end

	if _delay_display_timer then
	    _delay_display_timer:stop()
	    _delay_display_timer = nil
	end
end

-- 获取网络延时
function WholeModel:get_net_delay(  )
	return _net_delay
end

-- 发送 网络检测包
function WholeModel:begin_check_daley(  )
	--WholeWin:update_win( "open_delay" )
	UserPanel:showLantencyState(true)
	_delay_checking_flag    = false
	local function delay_check_func(  )
		if not _delay_checking_flag then
			_delay_checking_flag = true
			_delay_check_begin_time = os.clock()
		    MiscCC:request_check_self_online(  )
		end
	end
    
    if _delay_check_timer == nil or _delay_check_timer.scheduler_id == nil then 
    	local delay = CCAppConfig:sharedAppConfig():getStringForKey('net_delay_check')
    	delay = tonumber( delay )           -- 采样时间间隔
        _delay_check_timer = timer()
	    _delay_check_timer:start( delay, delay_check_func )
    end


    if _delay_display_timer == nil or _delay_display_timer.scheduler_id == nil then 
        _delay_display_timer = timer()
	    _delay_display_timer:start( _SHOW_DELAY_INTERVAL, WholeModel.display_callback, WholeModel )
    end

end

-- 停止网络检测
function WholeModel:stop_net_delay_check(  )
	UserPanel:showLantencyState(false)
	_delay_checking_flag    = true
	if _delay_check_timer then 
	     _delay_check_timer:stop()
	 end
	_delay_check_timer = nil

	if _delay_display_timer then 
	     _delay_display_timer:stop()
	 end
	_delay_display_timer = nil
	--WholeWin:update_win( "close_delay" )
end

-- 网络检测包返回
function WholeModel:result_check_delay()
	local net_delay_temp = (os.clock() - _delay_check_begin_time) * 1000
	--table.insert( _net_delay_t, net_delay_temp )
	_net_delay = ( _net_delay + net_delay_temp ) / 2
	_delay_checking_flag = false
end

function WholeModel:display_callback()
    -- 计算平均值
    WholeModel:calculate_net_delay(  )
	UserPanel:setLantencyState(_net_delay)
	_pre_show_time = os.clock()
end

-- 计算网络延时
function WholeModel:calculate_net_delay(  )
	if _delay_checking_flag == true then
		_net_delay = (os.clock() - _delay_check_begin_time) * 1000
	end
	--local total_delay = 0
	--local count = #_net_delay_t
	--for i = 1, count do 
    --   total_delay = total_delay + _net_delay_t[i]
	--end
	--_net_delay = total_delay / count
	--_net_delay = math.floor( _net_delay )
	--_net_delay_t = {}
end