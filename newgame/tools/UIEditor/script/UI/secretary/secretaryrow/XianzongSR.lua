-- XianzongSR.lua    secretary row
-- created by lyl on 2013-5-29
-- 家族任务


super_class.XianzongSR( SecretaryRow )  


-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function XianzongSR:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	-- 响应 的更新事件的配置
    self.update_type_t = { "HZYX_count" }

    SecretaryModel:request_HZYX_count(  )
end

function XianzongSR:init_show(  )
    -- 连接
    self.goto_lable = TextButton:create( nil, 240, 30, 130, 20, Lang.secretary[10], "") -- [10]="#cffff00#u1传送#u0"
    local function goto_click(  )
        GlobalFunc:teleport(SceneConfig.scenceid.MU_YE_CUN,Lang.secretary[22] ) -- [20]="家族管理员"
    end
    self.goto_lable:setTouchClickFun(goto_click)
    self.view:addChild( self.goto_lable.view )

    self:set_but_name( Lang.secretary[23] ) -- [21]="领取任务"
    self:update_all(  )
end

-- 按钮的回调事件， 子类根据自身需要重写
function XianzongSR:but_callback_func(  )
    GlobalFunc:ask_npc(SceneConfig.scenceid.MU_YE_CUN, Lang.secretary[22] ) -- [22]="家族管理员"
end

-- 更新显示数据
function XianzongSR:update_all(  )
	local remain_count = SecretaryModel:get_xianzong_count(  )
    
    if remain_count > 0 then
        self:set_but_state( true )
        self:change_state( SecretaryRow.ACTIVE )
    else
        self:set_but_state( false )
        self:change_state( SecretaryRow.INACTIVE )
    end

    self:set_notice_words( string.format( Lang.secretary[24], remain_count )  ) -- [1855]="仙宗任务剩余#cffff00%d#cffffff次"
end

-- 更新时间     子类需要重写
function XianzongSR:update( update_type )
    -- print("XianzongSR............update:::  ", update_type )
    if update_type == "HZYX_count"  then 
        self:update_all( )
    elseif update_type == "all" then
        SecretaryModel:request_HZYX_count(  )
    end
end
