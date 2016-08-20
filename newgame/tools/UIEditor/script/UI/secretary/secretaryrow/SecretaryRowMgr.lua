-- SecretaryRowMgr.lua  
-- created by lyl on 2013-5-28
-- 游戏助手页 中的 行的管理器  负责显示、排序、创建等

-- ************************************************
-- 使用说明：
-- 1、直接使用  SecretaryRowMgr 构造函数，可显示指定区域的 scroll，并管理行
-- 2、如果要加入新行， 继承 SecretaryRow 类，并实现（重写）相关方法做特殊功能处理
-- 3、_row_info表中加入 配置
-- 4、SecretaryRow 中的 update_type_t 记得加入该行要响应的 更新事件


super_class.SecretaryRowMgr()

-- 显示的行对象配置。 遍历这个表来创建
-- row_key：作为一行的索引，如果按照 row_key 能找到一行的对象，就返回，不创建新的
-- class  : 对应行的类
-- priority: 优先级， 直接根据 _row_info 表的位置序号， 不用配了
local _row_info= {
	{ row_class = LoginSR, row_key = "LoginSR_1",  },           -- 1
    { row_class = VipSR, row_key = "VipSR_1",   },
     { row_class = QiandaoSR, row_key = "QiandaoSR_1",},       --签到
    { row_class = ActivityPointSR, row_key = "ActivityPointSR_1",  },--活跃度奖励,这里需要改，链接到最新的奖励界面
     { row_class = ExpSR, row_key = "ExpSR_1",   },            --离线经验
    
    { row_class = ZhaocaiSR, row_key = "ZhaocaiSR_1",   },           -- 6
    { row_class = DoufataiSR, row_key = "DoufataiSR_1",   },
    { row_class = HuanleSR, row_key = "HuanleSR_1",   },
    { row_class = FubenSR, row_key = "FubenSR_1",    },
    { row_class = ActivitySR, row_key = "ActivitySR_1",   },
    { row_class = BossSR, row_key = "BossSR_1",   },         -- 11
    { row_class = ZhanyaoSR, row_key = "ZhanyaoSR_1",   },
    { row_class = YinliangSR, row_key = "YinliangSR_1",   },
    { row_class = XianzongSR, row_key = "XianzongSR_1",   },
}


-- -- 更新事件配置, 配置行要响应那些事件 update_type ---->  row_key 映射
-- local _udpate_config = {
--     award_list = "LoginSR_1", s
-- }

local AREA_WIDTH = 505
local AREA_HEIGHT = 465
-- local SCROLL_MAX = #_row_info
local SCROLL_MAX = 1

local ROW_WIDTH  = 505
local ROW_HEIGHT = 78

local _create_scroll_cb = callback:new()    -- 为保证不会短时间内多次刷新（重创建scroll），用callback做控制


function SecretaryRowMgr:__init( fath_panel, pos_x, pos_y )
    self.secretaryRow_t = {}               -- 存储每一行的对象
    self.key_range_t    = {}               -- 存储行的 key ，排序的时候，只对这个表排序. 
    self.update_type_to_row_kye_t = {}     -- 更新事件到行的key的映射. 
    self.fath_panel = fath_panel           -- 父结点
    self.rows_bg_panel = nil               -- 所有行的背景
    self.pos_x = pos_x
    self.pos_y = pos_y
    self:create_scroll_area(  )
end


-- 创建滚动区域
function SecretaryRowMgr:create_scroll_area(  )
    -- print("创建滚动SecretaryRowMgr:create_scroll_area区域=======================================")
    local function create_func( panel_index )
        -- local row_key = self.key_range_t[ panel_index ]
        -- if row_key then
        --     -- print( panel_index, row_key, self.secretaryRow_t, self.secretaryRow_t[ row_key ], "=======+++++++++", self.secretaryRow_t[ row_key ].view )
        --     return self.secretaryRow_t[ row_key ].view
        -- end
        -- return nil
        -- print( "scroll..............==================..........+====================......==================.........", panel_index )
        local rows_bg_panel = self:create_all_rows_bg(  )
        return rows_bg_panel
    end
    self.row_scroll = MUtils:create_one_scroll( self.pos_x+10, self.pos_y+25, AREA_WIDTH, AREA_HEIGHT, SCROLL_MAX, "", TYPE_HORIZONTAL, create_func )
    self.row_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, AREA_HEIGHT)
    self.row_scroll:setScrollLumpPos(495)
    local arrow_up = CCZXImage:imageWithFile(AREA_WIDTH, self.pos_y+15 + AREA_HEIGHT, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(AREA_WIDTH, self.pos_y+25, 10, -1 , UILH_COMMON.scrollbar_down, 500, 500)
    self.fath_panel:addChild( self.row_scroll )
    self.fath_panel:addChild(arrow_up,500)
    self.fath_panel:addChild(arrow_down,500)
end

-- 创建所有行的bg
function SecretaryRowMgr:create_all_rows_bg(  )
    local row_total = #_row_info
    local bg_height = row_total * ROW_HEIGHT

    self.rows_bg_panel = CCBasePanel:panelWithFile(self.pos_x+10, self.pos_y+20, ROW_WIDTH, bg_height, "" )
    -- print( "self.rows_bg_panel..........******", ROW_WIDTH, bg_height )
    -- self.fath_panel:addChild( self.rows_bg_panel )

    -- self.rows_bg_panel:addChild( CCZXImage:imageWithFile( 10, 10, -1, -1, "ui/common/win_title1.png") )

    -- 创建所有 行对象
    for i = 1, #_row_info do 
        local row_info_temp = _row_info[i]
        table.insert( self.key_range_t, row_info_temp.row_key )      -- 存储每行的索引
        local row_temp = row_info_temp.row_class( self, row_info_temp.row_key, i, 0, 0, ROW_WIDTH, ROW_HEIGHT ) -- 创建一行对象

        self.secretaryRow_t[ row_info_temp.row_key ] = row_temp      -- 存储行对象
        self.rows_bg_panel:addChild( self.secretaryRow_t[ row_info_temp.row_key ].view )
    end

    -- 初始化更新事件映射
    for k, row_obj in pairs( self.secretaryRow_t ) do 
        local update_type_t = row_obj.update_type_t or {}            -- 行的更新事件配置表
        for key, update_type in pairs( update_type_t ) do 
            if update_type and row_obj.row_key then 
                if self.update_type_to_row_kye_t[ update_type ] == nil then
                    self.update_type_to_row_kye_t[ update_type ] = {}
                end
                table.insert( self.update_type_to_row_kye_t[ update_type ], row_obj.row_key )
                -- self.update_type_to_row_kye_t[ update_type ] = row_obj.row_key -- 使用的时候，用update_type 找到行
            end
        end
    end

    self:reset_all_row_position(  )

    return self.rows_bg_panel
end

-- 根据key的排序，重新设置坐标
function SecretaryRowMgr:reset_all_row_position(  )
    -- 如果行的位置超过面板，会导致scroll自动返回位置的问题，这里先设置位置，确保不会超过
    for key, row_obj in pairs( self.secretaryRow_t ) do 
        if row_obj then 
            row_obj.view:setPosition( 0, 30 )
            row_obj.view:setIsVisible( false )
        end
    end

    -- 重设置背景面板的大小  （根据key重设高）
    local bg_height = #self.key_range_t * ROW_HEIGHT
    -- print("重设&&…………***", ROW_WIDTH, bg_height )
    self.rows_bg_panel:setSize( ROW_WIDTH, bg_height )

    -- print( "根据key的排序，重新设置坐标", bg_height, #self.key_range_t )

    for i = 1, #self.key_range_t  do 
        local row_key = self.key_range_t[ i ]
        local row_obj = self.secretaryRow_t[ row_key ]
        if row_obj then 
            local pos_x = 0
            local pos_y = bg_height - i * ROW_HEIGHT
            row_obj.view:setPosition( pos_x, pos_y )
            row_obj.view:setIsVisible( true )
            -- print("行的位置。。。。。。。。。。。", pos_x, pos_y, i, bg_height)
        end
    end
end

-- 行的状态改变，重新排序
function SecretaryRowMgr:row_state_change(  )
	self:range_by_state(  )       -- 重排

    -- self:ready_create_scroll(  )
end

-- 可能更新会瞬间爆发，为保证不会短时间内多次刷新（重创建scroll），这里做控制
function SecretaryRowMgr:ready_create_scroll(  )
    self:reset_all_row_position(  )



    -- _create_scroll_cb:cancel()
    -- _create_scroll_cb = callback:new()
    -- local function callback_func(  )
    --     -- print("callback_func 回调~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

    --     self.fath_panel:removeChild( self.row_scroll, true )
    --     self:create_scroll_area(  )        -- 通知管理器状态改变
        
    -- end
    -- _create_scroll_cb:start( 0.1, callback_func ) 
end

-- 影藏某一行
function SecretaryRowMgr:hide_row( row_key )
    -- print( self.key_range_t, row_key, "kkk" )
    for i = 1, #self.key_range_t do 
        if self.key_range_t[i] == row_key then 
            table.remove( self.key_range_t, i )
            break
        end
    end

    self:ready_create_scroll(  )
end

-- 显示某行
function SecretaryRowMgr:show_row( row_key )
    -- print("显示行：：", row_key)
    -- 判断是否已经有
    local if_exist = false
    for i = 1, #self.key_range_t do 
        if self.key_range_t[i] == row_key then
            if_exist = true
        end
    end
    if not if_exist then
        table.insert( self.key_range_t, row_key )
        self:range_by_state(  )       -- 重排
        self:ready_create_scroll(  )
    end
end

-- 排序： 把非激活状态的放在最后面
function SecretaryRowMgr:range_by_state(  )
    local length = #self.key_range_t
    for i = 1, length do 
        for j = i, length do
            if self:check_if_insert_front( i, j ) then
                local later_key = self.key_range_t[ j ]
                table.remove( self.key_range_t, j  )
                table.insert( self.key_range_t, i, later_key  )
            end
        end
    end
end

-- 判断是否需要让后面行 的插入到前面, 
function SecretaryRowMgr:check_if_insert_front( front_index, later_index )
	local check_ret = false
	local front_key = self.key_range_t[front_index]
	local later_key = self.key_range_t[later_index]
	local front_row = nil
	local later_row = nil
	if front_key and later_key then
        front_row = self.secretaryRow_t[ front_key ]
        later_row = self.secretaryRow_t[ later_key ]
	end

	if front_row == nil or later_row == nil then
        return false
	end
-- print("判断1", front_index, later_index,  "state:", front_row.state, later_row.state, "priority:", later_row.priority , front_row.priority)
    if front_row.state == SecretaryRow.INACTIVE and later_row.state == SecretaryRow.ACTIVE then
        check_ret = true
    elseif front_row.state == later_row.state and later_row.priority < front_row.priority then
        check_ret = true
    end
    return check_ret
end

function SecretaryRowMgr:update( update_type )
    -- print("SecretaryRowMgr:update.... ", update_type)
    local row_key_t = self.update_type_to_row_kye_t[ update_type ] or {}    -- 找到行的key
    for key, row_key in pairs( row_key_t ) do 
        if row_key then
            local row_obj = self.secretaryRow_t[ row_key ]              -- 找到行对象
            if row_obj then
                row_obj:update( update_type )
            end
        end
    end
    if update_type == "all" then
        for key, row_obj in pairs( self.secretaryRow_t ) do
            row_obj:update( "all" )
        end
    end
end

-- 销毁
function SecretaryRowMgr:destroy(  )
    for key, row in pairs( self.secretaryRow_t ) do 
    end
end
