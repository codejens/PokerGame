-- ShopItemList.lua
-- created by lyl on 2013-1-31
-- 商店，物品列表窗口 

super_class.ShopItemList( Window )

require "UI/shop/ShopSellPanel"

local _win_name = "shop_win"

function ShopItemList:create(  )
    -- local temp_panel_info = { texture = "", x = 88, y = 20, width = 335, height = 500 }
	return ShopItemList( "ShopItemList", "", false, 405, 495 )
end

function ShopItemList:__init( window_name, texture_name )
    self.sell_panel_t  = {}         -- 记录每个物品出售panel，刷新时修改panel上的显示数据
    self.list_scroll_t = {}         -- 记录每个列表，控制显示与隐藏

    -- 设置当前显示列表
    self:Choose_panel( "drug" )
    -- 在最上层覆盖一个看不见的slot, 响应拖动

    self.globle_slot = SlotItem( 385, 480 )
    self.view:addChild( self.globle_slot.view, 100 )
    local function drag_in( source_item )
        ShopModel:sell_user_item( source_item )
        -- self:udpate_sell_scroll(  )
    end
    self.globle_slot:set_drag_in_event(drag_in)
    self.globle_slot:set_if_not_through( false )
end


-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function ShopItemList:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    if row_num < 5 then
        row_num = 5
    end
    --local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL, 500,500)
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 20, size_h)
    --scroll:setEnableCut(true)
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
            --local index = y * colu_num + x + 1
            local index = x * colu_num--y * colu_num + x + 1
            local bg = CCBasePanel:panelWithFile(0, 0, 0, 0, "")
            local curx = 0
            local cury = 0
            for i = 1, colu_num do
                if panel_table_para[index + i] then
                   -- local bg = CCBasePanel:panelWithFile( 0, 0, 161, 83, "")
                    local shop_sell_panel = ShopSellPanel( panel_table_para[index + i], "shop_sell" )
                    bg:addChild( shop_sell_panel.view )
                    shop_sell_panel.view:setPosition( curx, 0)
                    curx = curx + shop_sell_panel.view:getSize().width
                    if cury < shop_sell_panel.view:getSize().height then
                        cury = shop_sell_panel.view:getSize().height
                    end
                    --scroll:addItem(bg)
                else
                    --local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
                    local shop_sell_panel = ShopSellPanel( nil )
                    bg:addChild( shop_sell_panel.view )
                    shop_sell_panel.view:setPosition( curx, 0)
                    curx = curx + shop_sell_panel.view:getSize().width
                    if cury < shop_sell_panel.view:getSize().height then
                        cury = shop_sell_panel.view:getSize().height
                    end
                    --scroll:addItem(bg)
                end
            end
            bg:setSize(curx, cury)
            scroll:addItem(bg)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建可拖动区域  这包含动态数据，另外弄一个创建scroll方法   参数：行数, 坐标， 区域大小，列数，可见行数， 背景名称.  
function ShopItemList:create_scroll_with_date( row_num ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name )
    local scroll = CCScroll:scrollWithFile( pos_x, pos_y, size_w, size_h, row_num, bg_name, TYPE_HORIZONTAL, 600, 600 )
    scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30,  size_h + 50)

    --local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num, bg_name, TYPE_VERTICAL, 500,500)
    --scroll:setEnableCut(true)
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
            --local index = y * colu_num + x + 1
            local index = x * colu_num--y * colu_num + x + 1
            local curx = 0
            local cury = 0
            local row_bg = CCBasePanel:panelWithFile( 0, 0, 0, 0, "" )
            for i = 1 , colu_num do
                local item_date = ShopModel:get_sell_item_by_index( index + i )
                if item_date then
                    local bg = CCBasePanel:panelWithFile( curx, 0, 200, 95, "")
                    local shop_sell_panel = self:create_sell_panel_by_date( item_date )
                    bg:addChild( shop_sell_panel.view )
                    shop_sell_panel.view:setPosition( 0, 0)
                    curx = curx + shop_sell_panel.view:getSize().width
                    if cury < shop_sell_panel.view:getSize().height then
                        cury = shop_sell_panel.view:getSize().height
                    end
                    --scroll:addItem(bg)
                    self.sell_panel_t[ index + i ] = {}
                    self.sell_panel_t[ index + i ].bg = bg
                    self.sell_panel_t[ index + i ].sell_panel = shop_sell_panel
                    row_bg:addChild( bg )
                else
                    local bg = CCBasePanel:panelWithFile( curx, 0, 200, 95, "")
                    local shop_sell_panel = ShopSellPanel( nil )
                    bg:addChild( shop_sell_panel.view )
                    shop_sell_panel.view:setPosition( 0, 0)
                    curx = curx + shop_sell_panel.view:getSize().width
                    if cury < shop_sell_panel.view:getSize().height then
                        cury = shop_sell_panel.view:getSize().height
                    end
                    --scroll:addItem(bg)
                    self.sell_panel_t[ index + i ] = {}
                    self.sell_panel_t[ index + i ].bg = bg
                    self.sell_panel_t[ index + i ].sell_panel = shop_sell_panel
                    row_bg:addChild( bg )
                end
            end
            row_bg:setSize(curx, cury)
            scroll:addItem(row_bg)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 选择显示的面板   drug   pet  tianlei shushan yuanyue yunhua  
function ShopItemList:Choose_panel( panel_type )
   -- print("改变列表 ~~!!~~  ", panel_type)
    for key, scroll_view in pairs(self.list_scroll_t) do
        scroll_view:setIsVisible( false )
    end

    local beg_x = 5
    local beg_y = 5
    local scroll_w = 390
    local scroll_h = 479

    if panel_type == "drug" then
        if self.drug_scroll == nil then
            -- 丹药
            self.drug_item_id_t = ShopModel:get_item_list( "drug" )
            self.drug_scroll = self:create_scroll_area( self.drug_item_id_t, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.drug_scroll )
            table.insert( self.list_scroll_t, self.drug_scroll )
        end
        self.drug_scroll:setIsVisible( true )
    elseif panel_type == "pet" then
        if self.pet_scroll == nil then
             -- 宠物
            self.pet_item_id_t = ShopModel:get_item_list( "pet" )
            self.pet_scroll = self:create_scroll_area( self.pet_item_id_t, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.pet_scroll )
            table.insert( self.list_scroll_t, self.pet_scroll )
        end
        self.pet_scroll:setIsVisible( true )
    elseif panel_type == "daoke" then
        -- 刀客装备
        if self.tianlei_scroll == nil then
            self.tianlei_item_id_t = ShopModel:get_equip_id_by_job( 1 )
            self.tianlei_scroll = self:create_scroll_area( self.tianlei_item_id_t, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.tianlei_scroll )
            table.insert( self.list_scroll_t, self.tianlei_scroll )
        end
        self.tianlei_scroll:setIsVisible( true )
    elseif panel_type == "gongshou" then
        if self.shushan_scroll == nil then
            -- 弓手装备
            self.shushan_item_id_t = ShopModel:get_equip_id_by_job( 2 )
            self.shushan_scroll = self:create_scroll_area( self.shushan_item_id_t, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.shushan_scroll )
            table.insert( self.list_scroll_t, self.shushan_scroll )
        end
        self.shushan_scroll:setIsVisible( true )
    elseif panel_type == "qiangshi" then
        if self.yuanyue_scroll == nil then
            -- 枪士装备
            self.yuanyue_item_id_t = ShopModel:get_equip_id_by_job( 3 )
            self.yuanyue_scroll = self:create_scroll_area( self.yuanyue_item_id_t, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.yuanyue_scroll )
            table.insert( self.list_scroll_t, self.yuanyue_scroll )
        end
        self.yuanyue_scroll:setIsVisible( true )
    elseif panel_type == "xianru" then
        if self.yunhua_scroll == nil then
            -- 贤儒装备
            self.yunhua_item_id_t = ShopModel:get_equip_id_by_job( 4 )
            self.yunhua_scroll = self:create_scroll_area( self.yunhua_item_id_t, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.yunhua_scroll )
            table.insert( self.list_scroll_t, self.yunhua_scroll )
        end
        self.yunhua_scroll:setIsVisible( true )
    elseif panel_type == "sell" then
        if self.sell_scroll == nil then
            -- 出售
            local row_num_temp = ShopModel:get_had_sell_max(  ) / 2
            self.sell_scroll = self:create_scroll_with_date( row_num_temp, beg_x, beg_y, scroll_w, scroll_h, 2, 5, "" )
            self.view:addChild( self.sell_scroll )
            table.insert( self.list_scroll_t, self.sell_scroll )
        end
        self.sell_scroll:setIsVisible( true )
    end
    local bar_up = CCZXImage:imageWithFile(scroll_w+5, scroll_h, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local bar_down = CCZXImage:imageWithFile(scroll_w+5, 0, 11, -1 , UILH_COMMON.scrollbar_down, 500, 500)
    self.view:addChild(bar_up)
    self.view:addChild(bar_down)
end

-- 使用道具动态数据，创建一个购买面板(  出售页  )
function ShopItemList:create_sell_panel_by_date( item_date )
    local shop_sell_panel = ShopSellPanel( item_date.item_id, "back_sell" )
    shop_sell_panel:set_date_tips( item_date )
    return shop_sell_panel
end

-- 刷新 出售 列表的所有出售面板
function ShopItemList:udpate_sell_scroll(  )
    --print("刷新 出售 列表的所有出售面板  ShopItemList:udpate_sell_scroll   ")
    self:Choose_panel( "sell" )
    local item_max = ShopModel:get_had_sell_max(  )
    for i = 1, item_max do
        local item_date_temp = ShopModel:get_sell_item_by_index( i )
        if item_date_temp then
            local shop_sell_panel = self:create_sell_panel_by_date( item_date_temp )
            self.sell_panel_t[ i ].bg:removeChild( self.sell_panel_t[ i ].sell_panel.view, true )
            self.sell_panel_t[ i ].sell_panel = shop_sell_panel
            self.sell_panel_t[ i ].bg:addChild( shop_sell_panel.view )
        else
            self.sell_panel_t[ i ].sell_panel:init_sell_panel(  )
        end
    end
end

-- 更新    drug   pet    sell
function ShopItemList:update( update_type )
    if update_type == "sell" then
        self:udpate_sell_scroll(  )
    end
end