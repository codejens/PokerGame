-- ZhanyaoSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 经验


super_class.ZhanyaoSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function ZhanyaoSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "HZYX_count" }

    SecretaryModel:request_HZYX_count(  )
end

function ZhanyaoSR:init_show(  )
    self:set_but_name( Lang.secretary[27] ) -- [1858]="斩妖除魔"
    self:set_notice_words( string.format( Lang.secretary[27] )  ) -- [1858]="斩妖除魔"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function ZhanyaoSR:but_callback_func(  )
    GlobalFunc:open_or_close_window( 16, nil, nil )
end

-- 更新显示数据
function ZhanyaoSR:update_all(  )
	local remain_count = SecretaryModel:get_zhanyao_count(  )
    local zycmb_info = ItemModel:get_item_info_by_id( 48222 );  -- 斩妖除魔令
-- print("斩妖除魔。。。。。。==========。========== ========== ========== ==========。", remain_count, zycmb_info )
    if zycmb_info == nil then
        self:hide_row(  )
        -- self:set_but_state( false )
        -- self:change_state( SecretaryRow.INACTIVE )
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

    self:set_notice_words( string.format( Lang.secretary[28], remain_count )  ) -- [28]="斩妖除魔剩余#cffff00%d#cffffff次"
end

-- 更新时间     子类需要重写
function ZhanyaoSR:update( update_type )
    -- print("ZhanyaoSR............update:::  ", update_type )
    if update_type == "HZYX_count"  then 
        self:update_all( )
    elseif update_type == "all" then
        SecretaryModel:request_HZYX_count(  )
    end
end
