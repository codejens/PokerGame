-- LuoPanPage.lua
-- created by lyl 2013-9-3
-- 罗盘区域  

super_class.LuoPanPage()

local _layout_info = nil                                -- 布局信息临时变量

local _BEGIN_ANGLE = 90     -- 选中效果的开始角度
local _BEGIN_ANGLE_ZHIZHEN = -105  -- 指针的开始角度
local _ONE_GRID_ANGLE = 30   -- 一格的角度
local _ROTATE_RATE_1 = 3 / 360 -- 旋转速度  转一度需要的时间
LuoPanPage.EXPECT_LUOPAN_ROTATE_TIME = 5  -- 预期罗盘旋转最大时间

local _luopan_running = false     -- 标记罗盘是否正在转动

function LuoPanPage:__init()
    reload("UI/luopan/luo_pan_win_config")
    self.page_info = luo_pan_win_config.luopan_page
    self.curr_select_index = 1    -- 当前选中

    -- 背景
    _layout_info = self.page_info.luopan_area_bg
    self.view = CCBasePanel:panelWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
   
    -- 罗盘背景1
    _layout_info = self.page_info.luopan_bg_1
    local luopan_bg_1 = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
    self.view:addChild( luopan_bg_1 )

    -- 罗盘背景2
    -- _layout_info = self.page_info.luopan_bg_2
    -- local luopan_bg_2 = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )
    -- self.view:addChild( luopan_bg_2 )

    -- 选中背景
    _layout_info = self.page_info.selected_bg
    self.selected_bg = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img)
    self.selected_bg:setAnchorPoint(0,1);
    self.view:addChild( self.selected_bg )

    -- 创建所有道具
    self:create_all_item(  )


    -- 罗盘指针
    _layout_info = self.page_info.luopan_zhizhen
    self.luopan_zhizhen = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )
    self.luopan_zhizhen:setAnchorPoint(0.5,0);
    self.view:addChild( self.luopan_zhizhen )
    self:update_select_position(  )
    -- 使用88元宝抽奖的不再提示
    self.is_show_next = true;
    -- 开始抽奖按钮
    local test_t = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
    local r_b = 1
    _layout_info = self.page_info.begin_but
    local function but_func()
        if _luopan_running == true then
            return;
        end

        -- 一键一次
        if LuopanModel:get_is_key_to_ten() == false then
            local function cb()
                LuopanModel:req_luopan_get_award( 1 )
                _luopan_running = true
            end
            if LuopanModel:get_remain_times(  ) < 1 then
                local function cb2()
                    if PlayerAvatar:check_is_enough_money( 4,LuopanModel:get_need_gold_per_time() ) then
                        cb();
                    end
                end
                if self.is_show_next then
                    local function swith_but_func ( _show_tip )
                        self.is_show_next = not _show_tip;
                    end
                    ConfirmWin2:show( 5, nil, Lang.luopan[5],  cb2, swith_but_func )    -- [5] = "是否使用20元宝抽奖一次？",
                else
                    cb2();
                end
            else
                cb();
            end
        else
            --一键十次
            if LuopanModel:check_can_ten() then
                local win = UIManager:find_visible_window("luopan_win")
                if win then
                    win:set_skip_animation(true)
                    LuopanModel:key_to_ten(  )
                end
            end
        end
    end
    self.begin_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img_n, _layout_info.img_s, nil, nil, but_func )
    self.view:addChild( self.begin_but.view );

    -- 抽奖按钮上的文字图片：点击抽奖
    _layout_info = self.page_info.begin_img
    local begin_img = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
    self.begin_but.view:addChild( begin_img )

    self.callback_temp = nil
end

-- 创建一个slot
function LuoPanPage:create_one_slot_item( x, y, w, h, item_info )
    local slot_item = MUtils:create_one_slotItem( nil, x, y, w, h )   -- 先创建一个空的

    if item_info == nil then 
        return slot_item
    end
    if item_info.itemid == nil then 
        return slot_item
    end

    local item_id = item_info.itemid
    slot_item.set_base_date( item_id )                -- 设置具体显示
    slot_item:set_item_count( item_info.count )       -- 设置数量
    -- slot_item:set_color_frame( item_id, -5, -5, 74, 74 )
    slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -10, -10, 84, 84)

    -- 单击 回调函数
    local function item_click_fun(obj, eventType, arg,msgid)
        local click_pos = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local world_pos = slot_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        LuopanModel:show_tips( item_id, world_pos.x, world_pos.y )
    end
    slot_item:set_click_event(item_click_fun)

    return slot_item
end

-- 根据选择的序号，获取角度
function LuoPanPage:calculate_angle( index )
    local angle = _BEGIN_ANGLE + _ONE_GRID_ANGLE * index 
    return angle
end

-- 计算指针的角度  (由于指正资源和选中图的锚点不一样，角度也不同)
function LuoPanPage:calculate_angle_zhizhen( index )
    local angle = _BEGIN_ANGLE_ZHIZHEN + _ONE_GRID_ANGLE * index
    return angle
end


-- 计算目标到达目标需要转的角度
function LuoPanPage:goal_select_angle( select_index )
    local angle_old = self:calculate_angle_zhizhen( self.curr_select_index )
    local angle_end = self:calculate_angle_zhizhen( select_index )
    local angle_need = angle_end - angle_old
    if angle_need < 0 then              -- 使其不超过一圈
        angle_need = angle_need + 360
    elseif angle_need > 360 then 
        angle_need = angle_need - 360
    end
    return angle_need
end

-- 创建罗盘上的所有道具
function LuoPanPage:create_all_item(  )
    local luopan_item_infos = LuopanModel:get_luopan_awards(  )
    local pos_t = self.page_info.item_pos_t
    for i = 1, #luopan_item_infos do 
        local pos_info = pos_t[ i ]
        local item_x = pos_info.x
        local item_y = pos_info.y
        local slot_item_config = self.page_info.slot_item
        local slot_item = self:create_one_slot_item( item_x, item_y, slot_item_config.w, slot_item_config.h, luopan_item_infos[i] )
        self.view:addChild( slot_item.view )
    end
end

-- 设置选中位置
function LuoPanPage:update_select_position(  )
    local result_index = LuopanModel:get_luopan_result(  )

    self.selected_bg:setIsVisible( true )
    -- local angle = self:calculate_angle( result_index )
    -- self.selected_bg:setRotation( angle )
    -- 设置选中框位置
    local pos_t = self.page_info.item_pos_t
    local pos_info = pos_t[result_index]
    self.selected_bg:setPosition(pos_info.x-12,pos_info.y+54)

    local angle_zhizhen = self:calculate_angle_zhizhen( result_index )
    self.luopan_zhizhen:setRotation( angle_zhizhen )

    self.curr_select_index = result_index
end

-- 开始播动画
function LuoPanPage:begin_luopan(  )
    if LuopanModel:get_is_pass_ani() then 
        self:syn_luopan(  )
        return 
    end 

    -- 影藏格子选择背景
    self.selected_bg:setIsVisible( false )
    -- 纠正位置
    local old_angle = self:calculate_angle_zhizhen( self.curr_select_index )
    self.luopan_zhizhen:setRotation( old_angle )

    -- 计算需要旋转的角度
    local result_index = LuopanModel:get_luopan_result(  )
    local angle_need = self:goal_select_angle( result_index )        

    -- 运行动画
    local all_need_time = 0
    local during = _ROTATE_RATE_1 * angle_need
    local array = CCArray:array();
    local rotate_action_1 = CCRotateBy:actionWithDuration( 0.5, 270 )
    local rotate_action_2 = CCRotateBy:actionWithDuration( 0.5, 225 )
    local rotate_action_3 = CCRotateBy:actionWithDuration( 0.5, 135 )
    local rotate_action_4 = CCRotateBy:actionWithDuration( 0.5, 90 )
    local rotate_action_last = CCRotateBy:actionWithDuration( during, angle_need ) 

    array:addObject( rotate_action_1 ) 
    array:addObject( rotate_action_2 ) 
    array:addObject( rotate_action_3 ) 
    array:addObject( rotate_action_4 ) 
    array:addObject( rotate_action_last ) 
    local seq = CCSequence:actionsWithArray(array);


    -- 动画结束后选择格子
    all_need_time = during + 2
    local function callback_func(  )
        self:update_select_position()
        _luopan_running = false
        LuopanModel:luopan_end(  )
        self.callback_temp = nil
    end
    self.callback_temp = callback:new()
    print("回调时间,,,,", during, all_need_time )
    self.luopan_zhizhen:stopAllActions()
    self.luopan_zhizhen:runAction( seq )
    self.callback_temp:start( all_need_time, callback_func )
end

-- 同步罗盘状态  例如正在旋转，关掉，回来， 要设置结果状态，并且静止
function LuoPanPage:syn_luopan(  )
    if _luopan_running then 
        LuopanModel:luopan_end(  )
    end
    self:update_select_position()
    _luopan_running = false
end

function LuoPanPage:destroy(  )
    if self.callback_temp ~= nil then
        -- 转盘还在转的时候关闭窗口，就立即停止转，并处理奖励下发
        self.callback_temp:cancel()
        self.callback_temp = nil
        -- 预防未结束罗盘动画就关闭窗口
        self:update_select_position()
        _luopan_running = false
        LuopanModel:luopan_end(  )
    end
end