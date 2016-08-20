-- ActivitySR.lua    secretary row
-- created by lyl on 2013-5-29
-- 日常活动


super_class.ActivitySR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function ActivitySR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = {  }

end

function ActivitySR:init_show(  )
    self:set_but_name( Lang.secretary[31] ) -- [31]="前往参加"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function ActivitySR:but_callback_func(  )
    SecretaryModel:open_dailywillplay_page( 2 )
end

-- 更新显示数据
function ActivitySR:update_all(  )
	self:set_notice_words( Lang.secretary[4] ) -- [1838]="日常活动"
end

-- 更新时间     子类需要重写
function ActivitySR:update( update_type )
    -- print("ActivitySR............update:::  ", update_type )
    if update_type == "all"  then 
        self:update_all( )
    elseif update_type == "" then
        
    end
end
