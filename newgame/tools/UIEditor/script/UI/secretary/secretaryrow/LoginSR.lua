-- LoginSR.lua   login secretary row
-- created by lyl on 2013-5-29
-- 登录奖励

super_class.LoginSR( SecretaryRow )  



-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function LoginSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
    SecretaryModel:request_login_award_list(  )

    -- 响应 的更新事件的配置
    self.update_type_t = { "award_list", "award_state_list", "continuity_days",  }
end

function LoginSR:init_show(  )
    self:set_but_name( Lang.secretary[14] ) -- [14]="全部领取"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function LoginSR:but_callback_func(  )
    print("全部领取")
    WelfareModel:request_get_all_login_award(  )
end

-- 更新显示数据
function LoginSR:update_all(  )
	local can_get_award_count = WelfareModel:get_longin_award_had_not_get(  )
    local continuity_days = WelfareModel:get_continuity_login_days(  ) or 1
	if can_get_award_count ~= 0 then
        -- self:set_notice_words( "连续登录奖励道具" )
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    else
    	self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
	end

    self:set_notice_words( string.format( Lang.secretary[15], continuity_days )  ) -- [15]="连续登录#cffff00%d#cffffff天"
end


-- 更新时间     子类需要重写
function LoginSR:update( update_type )
    -- print("LoginSR............update:::  ", update_type )
    if update_type == "award_list" or update_type == "award_state_list" or update_type == "all" or update_type == "continuity_days" then 
        self:update_all( )
    end
    -- print("call  LoginSR:update  ")
end
