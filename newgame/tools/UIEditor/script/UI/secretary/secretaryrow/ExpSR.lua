-- ExpSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 离线经验


super_class.ExpSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function ExpSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = {  }

    WelfareModel:req_exp_back_date( 1 )       -- 请求经验找回系统数据  副本
    WelfareModel:req_exp_back_date( 2 )       -- 请求经验找回系统数据  日常任务
    WelfareModel:request_off_line_exp(  )    -- 请求服务器下发离线经验
end

function ExpSR:init_show(  )
    self:set_but_name( LangGameString[1842] ) -- [1842]="前往领取"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function ExpSR:but_callback_func(  )
    UIManager:show_window("benefit_win")
    -- SecretaryModel:open_activity_daily_welfare(  )
    -- SecretaryModel:open_activity_page( 2 )
end

-- 更新显示数据
function ExpSR:update_all(  )
    local off_time_hours = WelfareModel:get_off_line_hours(  )
    local total_count_1, total_exp_1, get_state_1 = WelfareModel:get_exp_back_date_by_type( 1 )  -- 副本经验
    local total_count_2, total_exp_2, get_state_2 = WelfareModel:get_exp_back_date_by_type( 2 )  -- 任务

    if off_time_hours > 0 or total_exp_2 > 0 or total_exp_2 > 0 then 
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    else
        self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
    end


	self:set_notice_words( Lang.secretary[7] ) -- #cd0cda2领取离线经验
end

-- 更新时间     子类需要重写
function ExpSR:update( update_type )
    -- print("ExpSR............update:::  ", update_type )
    if update_type == "all"  then 
        self:update_all( )
    elseif update_type == "" then
        
    end
end
