-- FubenSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 经验


super_class.FubenSR( SecretaryRow )  

-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function FubenSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "fuben_times" }

    ActivityModel:request_enter_fuben_times(  )
end

function FubenSR:init_show(  )
    self:set_but_name( Lang.secretary[8] ) -- [1839]="前往挑战"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function FubenSR:but_callback_func(  )
    SecretaryModel:open_dailywillplay_page(1)
end

-- 更新显示数据
function FubenSR:update_all(  )
    local total_remain_times = ActivityModel:get_activity_fuben_total_remain_times()

    if total_remain_times > 0 then
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    else
        self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
    end
    
	self:set_notice_words( string.format( Lang.secretary[9], total_remain_times )  ) -- [9]="副本挑战剩余#cffff00%d#cffffff次"
end

-- 更新时间     子类需要重写
function FubenSR:update( update_type )
    -- print("FubenSR............update:::  ", update_type )
    if update_type == "all" or update_type ==  "fuben_times"  then 
        self:update_all( )
    elseif update_type == "" then
        
    end
end
