-- ActivityAwardPage.lua  
-- created by lyl on 2013-3-4
-- 活跃奖励页  天降雄狮使用
    
super_class.ActivityAwardPage(Window)

function ActivityAwardPage:create(  )
return ActivityAwardPage( "ActivityAwardPage", UILH_COMMON.normal_bg_v2 , true, 890, 520)

end

function ActivityAwardPage:__init( window_name, texture_name )
    ActivityModel:apply_activity_award_info(  )     -- 请求下发活跃活动信息
    self:create_left_table()
    self:create_right_panel(  )

    self:set_row_selected_by_index( 1 )
    self:update_cloud_num(  )

end

-- 左侧列表
function ActivityAwardPage:create_left_table(  )
	self.row_t   = {}                        -- 存储每一行的对象， 用来修改每行数据
	self.col_widthes = { 275-101, 384-275, 506-375 }       -- 列宽，用于计算下一列的坐标.
    self.current_select_activity_id  = nil   -- 当前选中活动id

	local panel = CCBasePanel:panelWithFile( 10, 10, 630, 500, UILH_COMMON.bottom_bg, 500, 500 )
	self.view:addChild( panel )

    ZImage:create(panel,UILH_NORMAL.title_bg4,-1,462,624,31,0,500,500);

	self:create_table_title( panel )

    -- 列表
    local list_date = ActivityModel:get_activity_award_list(  )
    self.activity_list_bg = CCBasePanel:panelWithFile( 2, 6, 624, 460, "", 500, 500 )
    panel:addChild( self.activity_list_bg )
    self.activity_list_scroll = self:create_scroll_area( list_date , 0, 10, 620, 440, 1, 6, "")
    
    --设置滚动条
    self.activity_list_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 208 )
    self.activity_list_scroll:setScrollLumpPos( 611 )
    local arrow_up = CCZXImage:imageWithFile(611 , 449, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(611, 0, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)

    self.activity_list_bg:addChild(arrow_up,1)
    self.activity_list_bg:addChild(arrow_down,1)
    self.activity_list_bg:addChild( self.activity_list_scroll )

    -- self:update_bufen_list(  )  -- 更新活动列表

    -- 自动传送选择
    -- local function switch_fun( if_selected  )
    --     ActivityModel:set_if_teleport( if_selected )
    -- end

    --选中框
    -- self.transmit_but_content = LangGameString[540] -- [540]="自动传送(筋斗云剩余0个)"
    -- self.transmit_but = UIButton:create_switch_button( 20, 10, 240, 30, UIPIC_Secretary_019, UIPIC_Secretary_020, self.transmit_but_content, 38, 18, nil, nil, nil, nil, switch_fun )
    -- panel:addChild( self.transmit_but.view )
end

-- 创建表头
function ActivityAwardPage:create_table_title( panel )
	-- 表头(列名)
    local title_x = 101            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
	local title_y = 471

    local label_temp = UILabel:create_lable_2(LH_COLOR[1]..Lang.benefit.welfare[36], title_x, title_y, 14, ALIGN_CENTER ) -- [541]="#cffff00活跃目标"
    panel:addChild( label_temp )

    title_x = title_x + self.col_widthes[1]     -- 计算下一列坐标
    local label_temp = UILabel:create_lable_2( LH_COLOR[1]..Lang.benefit.welfare[37], title_x, title_y, 14, ALIGN_CENTER ) -- [542]="#cffff00次数"
    panel:addChild( label_temp )

    title_x = title_x + self.col_widthes[2]     -- 计算下一列坐标
    local label_temp = UILabel:create_lable_2( LH_COLOR[1]..Lang.benefit.welfare[38], title_x, title_y, 14, ALIGN_CENTER ) -- [543]="#cffff00积分"
    panel:addChild( label_temp )

    title_x = title_x + self.col_widthes[3]     -- 计算下一列坐标
    local label_temp = UILabel:create_lable_2( LH_COLOR[1]..Lang.benefit.welfare[39], title_x-40, title_y, 14, ALIGN_LEFT ) -- [544]="#cffff00活跃参与"
    panel:addChild( label_temp )

end

-- 创建一行。 参数：坐标 宽高 背景图名称  标识序列号（数字） 该行的数据
function ActivityAwardPage:create_one_row( pos_x, pos_y, width, height, texture_name, index, row_date )
    local one_row = {}
    one_row.activity_id = row_date.id         -- 活动id

    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
    one_row.selected_frame = CCZXImage:imageWithFile( 3, 1, width - 3, height, UILH_COMMON.select_focus, 500, 500 )   -- 选中状态的框
    one_row.view:addChild( one_row.selected_frame )
    if self.current_select_activity_id ~= one_row.activity_id then
        one_row.selected_frame:setIsVisible( false )
    end
	local function f1(eventType, arg, imsgid, selfitem)
        if eventType == nil or arg == nil or imsgid == nil or selfitem == nil then
            return
        end

        if eventType == TOUCH_BEGAN then
            self:set_row_selected_by_index( index )
            return true
        elseif eventType == TOUCH_ENDED then
            self:set_row_selected_by_index( index )
            return true
        elseif eventType == ITEM_DELETE then           
            self.row_t[ one_row.index ] = nil       -- 拖动使行隐藏后，c++销毁panel，这时有 事件通知，就删除该行
        end
    end
    one_row.view:registerScriptHandler(f1)
	
    local title_x = 101                        -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 27
	-- 活跃目标
	local desc = row_date.desc or ""
	one_row.fuben_name = UILabel:create_lable_2( LH_COLOR[2]..desc, title_x, title_y, 14, ALIGN_CENTER )
    one_row.view:addChild( one_row.fuben_name )

    -- 次数
    title_x = title_x + self.col_widthes[1] 
    local time = ActivityModel:get_time_by_activity_target( one_row.activity_id )
    local  color_type = nil 
    if time == row_date.times then
       color_type = LH_COLOR[6]
    else
        color_type = LH_COLOR[15] 
    end
    one_row.times = UILabel:create_lable_2(color_type..time.."/"..row_date.times, title_x, title_y, 14, ALIGN_CENTER )
    one_row.view:addChild( one_row.times )

    -- 积分
    title_x = title_x + self.col_widthes[2] 
    one_row.integral = UILabel:create_lable_2( LH_COLOR[2]..row_date.point, title_x, title_y, 14, ALIGN_CENTER )
    one_row.view:addChild( one_row.integral )

    -- 快速参加
    title_x = title_x + self.col_widthes[3] 
    if row_date.location then
            local entityName = row_date.location.entityName or ""
            local see_name = row_date.location.seename or "" 
            --如果配置不配名字 则不让显示
            if see_name~=nil and see_name~="" then
            --文字按钮
                one_row.challenge = TextButton:create( nil, title_x - 50, title_y, 130, 20,"#cd0cda2#u1"..see_name.."#u0", "")
                one_row.challenge:setFontSize(14)
                -- 前往挑战回调
                local function challenge_click(  )
                    local openlevel = row_date.location.openlevel

                    --等级判断
                    local player = EntityManager:get_player_avatar()
                    if openlevel ~=nil then
                        if player.level < openlevel then
                            local txt = Lang.goal_info.notic_info..","..openlevel.."级之后可接"
                             GlobalFunc:create_screen_notic(txt)
                             return
                        end
                   end
                    
                    local  openwindow = row_date.location.openwindow
                    if openwindow then
                        --又是特殊处理  真心死板 应该添加配置字段
                       local win = UIManager:show_window(row_date.location.openwindow)
                       -- print("one_row.activity_id ",one_row.activity_id )
                       if one_row.activity_id == 11 or one_row.activity_id == 10 then
                             win:change_page(2)
                       end
                   
                       return
                    else
                    self:set_row_selected_by_index( index )
                    -- local if_transmit = self.transmit_but.if_selected     -- 是否选择了传送
                    -- ActivityModel:go_to_activity( row_date.location.sceneid, row_date.location.entityName, if_transmit )
                    ActivityModel:go_to_activity( row_date.location.sceneid, row_date.location.entityName, false )
                    end

                end
                one_row.challenge:setTouchClickFun(challenge_click)
                one_row.view:addChild( one_row.challenge.view )

            end  
    

            if row_date.location.sceneid~=nil and row_date.location.entityName~=nil then
                --小飞鞋
                local function teleport_fun(eventType, arg, msgid ,selfitem)
                -- print('前往挑战回调')
                    if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                        return
                    end

                    if eventType == TOUCH_BEGAN then
                        return true
                    elseif eventType == TOUCH_ENDED then
                        return true
                    elseif eventType == TOUCH_CLICK then 
                        self:set_row_selected_by_index( index )
                        local openlevel = row_date.location.openlevel

                            --等级判断
                            local player = EntityManager:get_player_avatar()
                            if openlevel ~=nil then
                                if player.level < openlevel then
                                    local txt = Lang.goal_info.notic_info..","..openlevel.."级之后可接"
                                     GlobalFunc:create_screen_notic(txt)
                                     return
                                end
                            end

                        local cloud_num = ActivityModel:get_cloud_num(  )
                        -- if cloud_num > 0 then
                        --      GlobalFunc:create_screen_notic( string.format(Lang.benefit.welfare[41],colu_num) ); --
                         ActivityModel:go_to_activity( row_date.location.sceneid, row_date.location.entityName, true )
                        -- else
                        --     GlobalFunc:create_screen_notic( Lang.benefit.welfare[40] ); --小飞鞋剩余0个，成为VIP可以免费速传
                        -- end
                    end
                    return true;
                end
                title_x = title_x + 30
                local teleport =  UIButton:create_button( title_x, title_y-20, -1, -1, UILH_MAIN.foot, UILH_MAIN.foot, UILH_MAIN.foot)
                teleport:registerScriptHandler(teleport_fun)    
                one_row.view:addChild(teleport)

            end


        -- end
  
    end

    -- 线
    ZImage:create(one_row.view, UI_WELFARE.split_line, 0, 0, width,3)

    -- 提供一些修改数据的函数


    one_row.change_times = function ( enter_times )
        local color_type = nil
          if time == row_date.times then
           color_type = LH_COLOR[6]
        else
            color_type = LH_COLOR[15] 
        end
        one_row.times:setString( color_type..enter_times.."/"..row_date.times )
    end

    one_row.index = index
    self.row_t[ one_row.index ] = one_row
	return one_row
end

-- 设置某行为选中状态
function ActivityAwardPage:set_row_selected_by_index( index )
	for key, row in  pairs( self.row_t ) do
		if row and row.selected_frame then
            row.selected_frame:setIsVisible( false )
        end
	end
	self.row_t[ index ].selected_frame:setIsVisible( true )
    self.current_select_activity_id = self.row_t[ index ].activity_id
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function ActivityAwardPage:create_scroll_area( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    --
    -- scroll:setScrollLump("","", 4, 20, 42)
     -- scroll:setEnableCut(true)
    local had_add_t = {}
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1

            if panel_table_para[index] then
                local row = self:create_one_row( 0, 0, size_w-10, 60, "", index, panel_table_para[index] )
                scroll:addItem( row.view )
            else
                local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
                scroll:addItem(bg)
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 更新筋斗云个数
function ActivityAwardPage:update_cloud_num(  )
    local cloud_num = ActivityModel:get_cloud_num(  )
    -- self.transmit_but.setString( LangGameString[545]..cloud_num..LangGameString[546] ) -- [545]="自动传送(筋斗云剩余" -- [546]="个)"
end

-- 更新次数
function ActivityAwardPage:update_activity_target_time(  )
    print("活动任务奖励，  更新次数   。。。。。。   ")
    local time = 0
    for key, one_row in pairs(self.row_t) do
        time = ActivityModel:get_time_by_activity_target( one_row.activity_id )
        one_row.change_times(time)
    end
end

-- =====================================================================================================================
-- =====================================================================================================================
-- 右侧
-- =====================================================================================================================
-- =====================================================================================================================
function ActivityAwardPage:create_right_panel(  )
    self.get_panel_t = {}                -- 存储获取面板

    self.left_panel = CCBasePanel:panelWithFile( 639, 10, 240, 500, UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild( self.left_panel )

    local panel = self.left_panel
    
    -- 背景
    -- ZImage:create( panel,UIPIC_Secretary_022,1,482,150,-1,0,500,500)
    -- 当前活跃度
    -- ZCCSprite:create( panel,UIPIC_Secretary_023,75,496)
    --标题
    local title_bg = CCZXImage:imageWithFile( -3, 464, 234, 31, UILH_NORMAL.title_bg4, 500, 500 )
    local title_name =  UILabel:create_lable_2(Lang.benefit.welfare[35], 67, 10, font_size, ALIGN_LEFT ) 

    local title_bg_size = title_bg:getSize()
    local title_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2)


    title_bg:addChild(title_name)
    panel:addChild(title_bg)


    local current_point = 90
    local total_point   = 100
    local lab_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.benefit.welfare[34],28, 15, 14,  ALIGN_LEFT )
    panel:addChild(lab_txt)
    self.point_lable = UILabel:create_lable_2( current_point.."/"..total_point, 127, 15, 14,  ALIGN_LEFT ) -- [547]="#cffff00当前活跃度:#c66ff66"
    panel:addChild( self.point_lable )

    -- 奖励物品列表
    local item_t = ActivityModel:get_award_item_point_list (  )
    self.award_item_list = self:create_item_scroll( item_t , 10, 25, 220, 430, 1, 5, "")
    panel:addChild( self.award_item_list )
end


-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function ActivityAwardPage:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    -- scroll:setEnableCut(true)
    local had_add_t = {}
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1

            if panel_table_para[index] then
                local get_award_panel = self:create_get_award_panel( panel_table_para[index][1], panel_table_para[index][2], panel_table_para[index][3], size_w, size_h / sight_num, index)
                scroll:addItem(get_award_panel.view)
            else
                local get_award_panel = self:create_get_award_panel(  )
                scroll:addItem(get_award_panel.view)
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个领取panel
function ActivityAwardPage:create_get_award_panel( item_id, integral_need, count, width, height, pIndex)
    -- print("创建一个领奖panel "..item_id)
    if self.get_panel_t[ item_id ] then
        return self.get_panel_t[ item_id ]
    end

	local award_panel = {}         -- 获取的对象

	award_panel.view = CCBasePanel:panelWithFile(0, 0, width, height, "", 500, 500 )
    safe_retain(award_panel.view)
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil and item_id > 100 then
        return award_panel
    end

    award_panel.slot = SlotItem( 60, 60 )
    award_panel.slot:set_icon_bg_texture( UILH_COMMON.slot_bg,  -11 ,  -10, 60+20, 60+20 )   -- 背框
    award_panel.slot:setPosition( 30, 20 )
    if item_id < 100 then
        local texture = "icon/money/" .. item_id .. ".pd"
        award_panel.slot:set_icon_texture(texture)
    else
        award_panel.slot:set_icon( item_id )
        award_panel.slot:set_gem_level( item_id ) 
    end
    award_panel.slot:set_count( count )
    award_panel.view:addChild( award_panel.slot.view )
    local function item_click_fun (...)
        if item_id > 100 then
            local a, b, arg = ...
            local position = Utils:Split(arg,":");
            local pos = award_panel.slot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(position[1]),tonumber(position[2]) ) )

            ActivityModel:show_mall_tips( item_id,pos.x,pos.y )
        end
    end
    award_panel.slot:set_click_event(item_click_fun)

    -- 活跃积分
    award_panel.integral_need_lable = UILabel:create_lable_2(LH_COLOR[2]..Lang.benefit.welfare[33]..integral_need, 119, 69, 14, ALIGN_LEFT ) -- [548]="#c66ff66活跃积分#cff0000"
    award_panel.view:addChild( award_panel.integral_need_lable )

    -- 线
    -- ZImage:create(award_panel.view, UIPIC_Secretary_010, 2, 0, width-4,2)

    -- 领取按钮
    -- count = 0
    local function buy_but_callback(eventType)
        if eventType == TOUCH_CLICK then
            ActivityModel:apply_get_activity_award( item_id )
        end
        return true;
        -- count = count + 1
        -- ActivityModel:new_activity_event_happen( count, 1, count + 20 )
    end
    local btn = CCNGBtnMulTex:buttonWithFile( 117, 15, -1, -1,UILH_COMMON.button4,TYPE_MUL_TEX);
    btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)
    
    if ( buy_but_callback ) then
        btn:registerScriptHandler(buy_but_callback);
    end

    award_panel.view:addChild(btn,0);

    -- local size = btn:getSize();
    -- local lab = MUtils:create_zxfont(btn,"三个字",size.width/2,size.height/2-7,2,20);
    local lab = UILabel:create_lable_2(Lang.benefit.welfare[8], 41, 15, 14, ALIGN_LEFT  ) 
    btn:addChild( lab)
    
    local btn_size = btn:getSize()
    local label_size = lab:getSize()
    lab:setPosition(btn_size.width/2 - label_size.width/2,btn_size.height/2 - label_size.height/2+3)

    award_panel.get_but,award_panel.get_but_lab = btn,lab;

    -- 一些操作领取panel的方法
    -- 根据是否已经领取，更新按钮状态
    award_panel.update_but_state = function()
        local current_point = ActivityModel:get_today_point(  )     --当前活跃点数

        if ActivityModel:get_if_get_item( item_id ) then
            award_panel.get_but_lab:setText( Lang.benefit.welfare[22] ) -- [550]="已领取"
            award_panel.get_but_lab:setPosition(btn_size.width/2 - label_size.width/2-8,btn_size.height/2 - label_size.height/2+3)

            award_panel.get_but:setCurState( CLICK_STATE_DISABLE )
        else
            award_panel.get_but_lab:setText( Lang.benefit.welfare[8]) -- [549]="领取"
            if current_point >= integral_need then
                award_panel.get_but:setCurState( CLICK_STATE_UP )
            else
                award_panel.get_but:setCurState( CLICK_STATE_DISABLE )
            end
        end
    end
    award_panel.update_but_state()

    self.get_panel_t[ item_id ] = award_panel
    return award_panel
end

-- 更新当前积分
function ActivityAwardPage:update_point(  )
    local current_point = ActivityModel:get_today_point(  )
    self.point_lable:setString(LH_COLOR[2]..current_point.."/"..100) -- [547]="#cffff00当前活跃度:#c66ff66"
end

-- 更新按钮状态
function ActivityAwardPage:update_get_panel_but(  )
    for key, get_panel in pairs( self.get_panel_t) do
        get_panel.update_but_state()
    end
end

-- 更新数据
function ActivityAwardPage:update( update_type )
    -- print("ActivityAwardPage:update( update_type )", update_type )
    if update_type == "cloud_num" then
        self:update_cloud_num()
    elseif update_type == "target_times" then
        self:update_activity_target_time(  )
    elseif update_type == "current_point" then
        self:update_point(  )
    elseif update_type == "get_award" then --更新领取按钮状态
        self:update_get_panel_but(  )
    else
        self:update_cloud_num()
        self:update_activity_target_time(  )
        self:update_point(  )
        self:update_get_panel_but(  )
        -- self.transmit_but.set_state( ActivityModel:get_if_teleport(  ) )
        self:update_tips_count()
    end
end

-- 销毁
function ActivityAwardPage:destroy(  )
    Window.destroy(self)
    for key, get_panel in pairs( self.get_panel_t ) do
        safe_release(get_panel.view)
    end
end

function ActivityAwardPage:active( if_active )
    if if_active then
        self:update("")
    end
end

-- 更新分页按钮上的提示标志
function ActivityAwardPage:update_tips_count()
    local x = ActivityModel:statistic_activity_award_can_get()
    print("当前未领取活跃奖励的个数:"..x)
end