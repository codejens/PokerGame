-- ActivityPointSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 活跃度奖励

super_class.ActivityPointSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function ActivityPointSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "current_point", "get_award" }

    ActivityModel:apply_activity_award_info(  )
end

function ActivityPointSR:init_show(  )
    -- -- 立即前往的连接
    self.goto_lable = TextButton:create( nil, 240, 20, 130, 20, LangGameString[1834], "") -- [1834]="#cffff00#u1前往#u0"
        -- 前往挑战回调
    local function goto_click(  )
        UIManager:show_window( "benefit_win" )
        BenefitWin:win_change_page( 2 )
        -- SecretaryModel:open_activity_page(3)
    end
    self.goto_lable:setTouchClickFun(goto_click)
    self.view:addChild( self.goto_lable.view )

    self:set_but_name( Lang.secretary[20] ) -- [20]="领  取"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function ActivityPointSR:but_callback_func(  )
    ActivityModel:auto_get_activity_award(  )
end

-- 更新显示数据
function ActivityPointSR:update_all(  )
    local award_can_get = ActivityModel:statistic_activity_award_can_get(  )     -- 可领取的活跃奖励数
    local today_point = ActivityModel:get_today_point(  )                        -- 当天活跃度

    if award_can_get > 0 then
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    elseif today_point < 100 then 
        self:set_but_state( false )
        self:change_state( SecretaryRow.ACTIVE )
    elseif today_point >= 100 then
        -- self:hide_row(  )
        self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
    end

    self:set_notice_words( string.format( Lang.secretary[3], today_point )  ) -- [3]="活跃度: #cffff00%d#cffffff"
end

-- 更新时间     子类需要重写
function ActivityPointSR:update( update_type )
    -- print("ActivityPointSR............update:::  ", update_type )
    if update_type == "all" or update_type == "current_point" or update_type == "get_award" then 
        self:update_all( )
    elseif update_type == "" then
        
    end
end
