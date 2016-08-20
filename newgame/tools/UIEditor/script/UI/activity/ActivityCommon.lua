-- ActivityCommon.lua  
-- created by lyl on 2013-4-3
-- 活动 系统过的一些公用方法


super_class.ActivityCommon(Window)

-- 创建一个道具展示的 scroll panel_table_para: itemid 表 ， scroll的坐标和宽高， colu_num: 列数， sight_num:可见行数， bg_name:背景图片的名称
function ActivityCommon:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    if row_num < 2 then
        row_num = 2
    end
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
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
            local index = x * colu_num 
            local row_h = size_h / sight_num
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, size_w, row_h, "")
            local colu_with = size_w / colu_num
            for i = 1, colu_num do
                local bg = self:create_item_show_panel( panel_table_para[index + i], (i - 1) * colu_with, 0, colu_with, row_h )
                bg_vertical:addChild(bg)
            end

            scroll:addItem(bg_vertical)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个不带滚动的横向
function ActivityCommon:create_item_horizontal( panel_table_para, pos_x, pos_y, item_w, item_h, item_inter, img_bg )
    local item_num = #panel_table_para
    local base_bg = CCBasePanel:panelWithFile( pos_x, pos_y, (item_w+item_inter)*item_num, item_h, "")
    for i=1, item_num do 
        local panel_item = self:create_item_show_panel_2( panel_table_para[i], (i-1)*(item_w+item_inter), 0, item_w, item_h )
        base_bg:addChild(panel_item)
    end
    return base_bg
end

-- 创建一个不带滚动的多行多列的横向
function ActivityCommon:create_item_horizontal_two_row( panel_table_para, pos_x, pos_y, item_w, item_h, item_inter_x , item_inter_y, rows_num , column_num )
    local item_num = #panel_table_para
     local base_bg = CCBasePanel:panelWithFile( pos_x, pos_y, (5+item_inter_x)*column_num, (item_inter_y+5) * rows_num , "")
     local  count = 0
     local real_row_num = math.ceil((item_num)/5)
    for i = 1, real_row_num do --x
        for j = 1, column_num do --y
                if count < item_num then
                    local panel_item = self:create_item_show_panel_2( panel_table_para[(i - 1) *  column_num + j],  item_inter_x * ( j - 1), item_inter_y * ( rows_num - i ), item_w, item_h )
                    base_bg:addChild(panel_item)
                    count = count+1
                else
                    break
                end
        end
    end 
    return base_bg
end


-- 创建一个道具
function ActivityCommon:create_item_show_panel( panel_date, x, y, w, h )
    local bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if panel_date == nil then
        return bg
    end
    local slot_w, slot_h = 64, 64
    local slot = SlotItem( slot_w, slot_h )
    slot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -4, -4, 72, 72 )   -- 背框
    slot:set_icon( panel_date.id )
    slot:setPosition( 6, 6 )
    slot:set_gem_level( panel_date.id )      -- 宝石的等级
    slot:set_color_frame( panel_date.id, -2, -2, 68, 68 )    -- 边框颜色
    local function item_click_fun ()
        ActivityModel:show_mall_tips( panel_date.id )
    end
    slot:set_click_event(item_click_fun)

    bg:addChild( slot.view )
    return bg
end

-- 创建一个道具 2
function ActivityCommon:create_item_show_panel_2( panel_date, x, y, w, h )
    local bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if panel_date == nil then
        return bg
    end
    local slot_w, slot_h = w, h
    local slot = SlotItem( slot_w, slot_h )
    slot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -5, -5, w+10, h+10 )   -- 背框
    slot:set_icon( panel_date.id )
    slot:setPosition( 6, 6 )
    slot:set_gem_level( panel_date.id )      -- 宝石的等级
    slot:set_color_frame( panel_date.id, 0, 0, w, h )    -- 边框颜色
    local function item_click_fun (...)
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slot.view:getParent():convertToWorldSpace( CCPointMake(tonumber(position[1]),tonumber(position[2])) );
        ActivityModel:show_mall_tips( panel_date.id,pos.x,pos.y )
    end
    slot:set_click_event(item_click_fun)

    bg:addChild( slot.view )
    return bg
end