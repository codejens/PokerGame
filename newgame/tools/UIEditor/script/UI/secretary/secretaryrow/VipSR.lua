-- VipSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 仙尊登录奖励


super_class.VipSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function VipSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "vip_info", "if_had_get_vip_award",  }

    
end

function VipSR:init_show(  )
    self:set_but_name( Lang.secretary[20] ) -- [1835]="领  取"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function VipSR:but_callback_func(  )
    WelfareModel:get_vip_day_login_award(  )
end

-- 更新显示数据
function VipSR:update_all(  )
	local vip_level, vip_info, add_task = WelfareModel:get_back_award_explain(  )
	if vip_level and vip_level > 0 then
	    self:set_notice_words( string.format( Lang.secretary[21], vip_level ) ) -- [21]="仙尊#cffff00%d#cffffff级奖励"
	else
        self:hide_row(  )
        return                 -- 如果已经影藏，后面就不用做按钮的处理了。 再次显示的时候，会调用方法处理按钮的
	end

    -- 是否已经领取
	local if_had_get_vip_award = WelfareModel:get_if_had_get_vip_award(  )
	if if_had_get_vip_award  == 0 then 
		self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    else
    	self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
	end
end

-- 更新时间     子类需要重写
function VipSR:update( update_type )
    -- print("VipSR............update:::  ", update_type )
    if update_type == "all" or update_type == "vip_info"  then 
        self:update_all( )
    elseif update_type == "if_had_get_vip_award" then
        self:update_all( )
    end
end
