-- DoufataiSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 斗法台


super_class.DoufataiSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function DoufataiSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "doufatai_remain", }

     SecretaryModel:request_doufatai_date(  )      -- 请求斗法台数据
end

function DoufataiSR:init_show(  )
    self:set_but_name( Lang.secretary[32] ) -- [32]="前往挑战"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function DoufataiSR:but_callback_func(  )
    UIManager:show_window( "doufatai_win" )
end

-- 更新显示数据
function DoufataiSR:update_all(  )
    local remain_count = DFTModel:get_dft_tz_count( )
    
    -- 如果低于25级，就隐藏
    local player = EntityManager:get_player_avatar()
    if player.level < 25 then
        self:hide_row(  )
        return
    end

    if remain_count > 0 then
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    else 
        self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
    end
    self:show_row(  )

    self:set_notice_words( string.format( Lang.secretary[6], remain_count )  ) -- [6]="斗法台挑战次数剩余#cffff00%d#cffffff次"
end

-- 更新时间     子类需要重写
function DoufataiSR:update( update_type )
    -- print("DoufataiSR............update:::  ", update_type )
    if update_type == "doufatai_remain"  then 
        self:update_all( )
    elseif update_type == "all" then
         SecretaryModel:request_doufatai_date(  )      -- 请求斗法台数据
    end
end
