-- QiandaoSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 签到奖励

super_class.QiandaoSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function QiandaoSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "qiandao", "current_point" }

    self.goto_lable = nil            -- 连接
    ActivityModel:apply_activity_award_info(  )
end

function QiandaoSR:init_show(  )
    -- 立即前往的连接
    self.goto_lable = TextButton:create( nil, 240, 30, 130, 20, Lang.secretary[16], "") -- [16]="#cffff00#u1前往#u0"
        -- 前往挑战回调
    local function goto_click(  )
        -- 前往签到分页，目前签到已经由qiandao_win移到了benefit_win
        -- UIManager:show_window( "qiandao_win" )
        UIManager:show_window( "benefit_win" )
        BenefitWin:win_change_page( 3 )
    end
    self.goto_lable:setTouchClickFun(goto_click)
    self.view:addChild( self.goto_lable.view )

    self:set_but_name( Lang.secretary[17] ) -- [1850]="签  到"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function QiandaoSR:but_callback_func(  )
    local if_had_already_qiandao = QianDaoModel:is_today_qd()   -- 是否已经签到
    local if_need_bq = QianDaoModel:get_is_need_bq()            -- 是否需要补签

    if not if_had_already_qiandao then
        MiscCC:req_qd()                                         --  签到当天
    elseif if_need_bq then
        QianDaoModel:auto_bq()                                  -- 补签
    end
end

-- 更新显示数据
function QiandaoSR:update_all(  )
	local today_point = ActivityModel:get_today_point(  )       -- 当天活跃度
    local if_had_already_qiandao = QianDaoModel:is_today_qd()   -- 是否已经签到
    local if_need_bq = QianDaoModel:get_is_need_bq()            -- 是否需要补签
    local qd_info = QianDaoModel:get_qd_info()                  -- 签到信息
    local qd_days = qd_info.qd_days or 0                        -- 签到天数

    if not if_had_already_qiandao then    -- 没有签到
        self:set_but_name( Lang.secretary[17] ) -- [1850]="签  到"
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    elseif if_need_bq then
        self:set_but_name( Lang.secretary[18] ) -- [1851]="补  签"
        if today_point < 50 then
            self:set_but_state( false )
            self:change_state( SecretaryRow.ACTIVE )
        else 
            self:set_but_state( true )
            self:change_state( SecretaryRow.ACTIVE )
        end
    else
        self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
    end

    self:set_notice_words( string.format( Lang.secretary[19], qd_days )  ) -- [1852]="本月累计签到#cffff00%d#cffffff天"

end

-- 更新时间     子类需要重写
function QiandaoSR:update( update_type )
    -- print("QiandaoSR............update:::  ", update_type )
    if update_type == "qiandao" or update_type == "current_point"  then 
        self:update_all( )
    elseif update_type == "all" then
        ActivityModel:apply_activity_award_info(  )
    end
end
