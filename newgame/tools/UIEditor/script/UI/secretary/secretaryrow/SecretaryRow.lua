-- SecretaryRow.lua  
-- created by lyl on 2013-5-28
-- 游戏助手页 中的 每行的基类。  

super_class.SecretaryRow()

SecretaryRow.ACTIVE   = 1            --  活动状态，这时要排在前面
SecretaryRow.INACTIVE = 2            --  非活动状态， 往后面排

-- 参数：  row_mgr： 行的管理器 SecretaryRowMgr 类型,    
--         row_key: 该行的key。管理器一般以它作为索引找到该行
--         priority: 排序使用
function SecretaryRow:__init( row_mgr, row_key, priority, pos_x, pos_y, width, height )
	self.view = nil                             -- 
    self.notice_words = nil                     -- 提示内容
    self.apply_but  = nil                       -- 功能按钮
    self.but_name_lable = nil                   -- 按钮名称
    self.state = SecretaryRow.ACTIVE            -- 是否活动状态
    self.update_type_t = {}                     -- 配置本行需要响应的更新事件

	self.class_name = "SecretaryRow"            -- 类名，管理器中，保证每行都是继承这个对象的
    self.row_mgr = row_mgr                      -- 行的管理器，当行的状态发生改变，要通知管理器
    self.row_key = row_key                      -- 该行的key。管理器一般以它作为索引找到该行
    self.priority = priority                    -- 排序优先级

    self.pos_x = pos_x
    self.pos_y = pos_y
    self.width = width
    self.height = height


    self:create_show(  )                 -- 显示信息
    self:init_show(  )
    -- print("SecretaryRow:__init")

end

-- 创建显示   如果子类有特殊显示要求，可重写这个方法
function SecretaryRow:create_show(  )
	-- 显示
    self.view = CCBasePanel:panelWithFile( self.pos_x, self.pos_y, self.width, self.height, "", 500, 500 )

    -- 线
    local seperate_line = CCZXImage:imageWithFile( 25, 0, self.width-50, 2, UILH_COMMON.split_line )
    self.view:addChild( seperate_line )            -- 分割线

    -- 文字
    self.notice_words = UILabel:create_lable_2( "", 15, 30, 16, ALIGN_LEFT )
    self.view:addChild( self.notice_words )

    -- 测试按钮，改变状态，触发通知管理器
    -- 领取
    local function but_callback()
        self:but_callback_func(  )
    end
    --xiehande UIPIC_Secretary_011 ->UIPIC_COMMOM_002
    self.apply_but = UIButton:create_button_with_name( self.width - 135, 12, -1, -1, UILH_COMMON.btn4_nor, UILH_COMMON.btn4_nor, nil, "", but_callback )
    --UIPIC_Secretary_035
    self.apply_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    
    self.view:addChild( self.apply_but.view)
    self.but_name_lable = UILabel:create_lable_2( "", 59, 21, 16, ALIGN_CENTER )
    self.apply_but.view:addChild( self.but_name_lable )

end

-- 状态改变，通知监听者.  （通知重新根据行的状态排序）
function SecretaryRow:change_state( state )
    local old_state = self.state
    if SecretaryRow.ACTIVE == state then 
        self.state = SecretaryRow.ACTIVE
    elseif SecretaryRow.INACTIVE == state then 
        self.state = SecretaryRow.INACTIVE
    end

    if old_state ~= self.state then
        -- local callback_temp = callback:new()         -- 使用callback是为了规避同一帧创建的问题
        -- local function callback_func(  )
            print('row_state_change')
            self.row_mgr:row_state_change(  )        -- 通知管理器状态改变
            -- callback_temp:cancel()
        -- end
        -- callback_temp:start( 0.001, callback_func ) 
    end
end

-- 通知管理器影藏自己
function SecretaryRow:hide_row(  )
    -- local callback_temp = callback:new()         -- 使用callback是为了规避同一帧创建的问题
    -- local function callback_func(  )
        self.row_mgr:hide_row( self.row_key )
    --     callback_temp:cancel()
    -- end
    -- callback_temp:start( 0.001, callback_func ) 
end

-- 显示
function SecretaryRow:show_row(  )
    self.row_mgr:show_row( self.row_key )
end

-- 改变文字显示
function SecretaryRow:set_notice_words( notice_words )
    -- print( "SecretaryRow:set_notice_words,,,,", self.row_key, self.notice_words, notice_words )
    notice_words = notice_words or ""
    self.notice_words:setString( notice_words )
end

-- 按钮名称, 和位置
function SecretaryRow:set_but_name( but_name, x, y )
    if but_name then
        self.but_name_lable:setString( LH_COLOR[1] .. but_name )
    end
    if type(x) == "number" and type(y) == "number" then
        self.but_name_lable:setPosition( x, y )
    end
end

-- 设置按钮状态
function SecretaryRow:set_but_state( is_enable )
    if is_enable then 
        self.apply_but.view:setCurState( CLICK_STATE_UP )
    else
        self.apply_but.view:setCurState( CLICK_STATE_DISABLE )  
    end
end


-- **************需要子类重写的方法**************
-- 初始化信息显示， 一般情况，布局没有特殊要求情况下，子类可以 不重写create_show， 只重写这个方法
function SecretaryRow:init_show(  )
    -- todo 设置文字
    -- todo 设置按钮名称和位置
end

-- 按钮的回调事件， 子类根据自身需要重写
function SecretaryRow:but_callback_func(  )
    -- print("按钮回调事件  测试。。。")
    -- self.apply_but:setCurState( CLICK_STATE_DISABLE )  
    -- self:change_state( SecretaryRow.INACTIVE )
    -- self:hide_row(  )
end

-- 更新    子类需要重写
function SecretaryRow:update( update_type )
     
end

-- 激活或者退出
function SecretaryRow:active(  )
    -- body
end