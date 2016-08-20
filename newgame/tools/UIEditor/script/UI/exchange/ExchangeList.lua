-- ExchangeList.lua
-- created by lyl on 2013-2-19
-- 兑换，物品列表

super_class.ExchangeList( Window )

require "UI/exchange/ExchangePanel"
-- 测试
--local drug_item_id_t = { 18711, 18712, 6231, 11400, 28223, 18909, 3221, 1131,  }

function ExchangeList:create(  )
    -- local temp_panel_info = { texture = UI_EXCHANGE_011, x = 7, y = 50, width = 796, height = 470 }
	return ExchangeList( "exchange_list", "", true, 730, 420 )
end

function ExchangeList:__init( window_name, texture_name )

    self.table_loaded = {}


    require "config/ItemConfig"
    require "config/StaticAttriType"

    self.list_creator = {}
    -- 装备
    self.list_creator['equipment'] = function()
        self.equip_item_id_t = ExchangeModel:get_category_items( "equipment" )
        self.equip_sell_scroll = self:create_scroll_area( self.equip_item_id_t, 0, 10, 723, 420, 3, 4, "","equipment" )
        self.view:addChild( self.equip_sell_scroll )
        return self.equip_sell_scroll
    end

    --  材料
    self.list_creator['material'] = function()
        self.material_item_id_t = ExchangeModel:get_category_items( "material" )
        self.material_sell_scroll = self:create_scroll_area( self.material_item_id_t, 0, 10, 723, 420, 3, 4, "", "material" )
        self.view:addChild( self.material_sell_scroll )
        return self.material_sell_scroll
    end

    --  荣誉
   -- self.glory_item_id_t = ExchangeModel:get_category_items( "glory" )
   -- self.glory_sell_scroll = self:create_scroll_area( self.glory_item_id_t, 0, 0, 796, 470, 3, 3, "", "glory"  )
   -- self.view:addChild( self.glory_sell_scroll )
   -- table.insert( self.list_scroll_t, self.glory_sell_scroll )
    self.list_creator['glory'] = function()
        self.material_item_id_t = ExchangeModel:get_category_items( "glory" )
        self.material_sell_scroll = self:create_scroll_area( self.material_item_id_t, 0, 10, 723, 420, 3, 4, "", "glory" )
        self.view:addChild( self.material_sell_scroll )
        return self.material_sell_scroll
    end


    self:Choose_panel( "equipment" )
end

-- 创建一个 scroll 中的  出售panel
function ExchangeList:create_one_scroll_sell_panel( item_id, x, y, w, h, category  )
    -- print("ExchangeList:create_one_scroll_sell_panel   ", panel_date, x, y, w, h)
    local sell_panel_bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if item_id == nil then
        return sell_panel_bg
    end
    
    local exchangePanel = ExchangePanel( item_id, 0, 5, category )
    sell_panel_bg:addChild( exchangePanel.view )
    
    return sell_panel_bg
end

-- 选择显示的面板   equipment,  material 
function ExchangeList:Choose_panel( panel_type )
    for key, scroll_view in pairs(self.table_loaded) do
        scroll_view:setIsVisible( false )
    end

    local view = self.table_loaded[panel_type]
    if not view then
        view = self.list_creator[panel_type]()
        self.table_loaded[panel_type] = view
    end
    view:setIsVisible( true )
    --[[
    ]]--
    --[[
    if panel_type == "equipment" then
        self.equip_sell_scroll:setIsVisible( true )
    elseif panel_type == "material" then
        self.material_sell_scroll:setIsVisible( true )
--    elseif panel_type == "glory" then 
--        self.glory_sell_scroll:setIsVisible( true )
    end
    ]]--
end

function ExchangeList:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name, category)
    -- 总行数(总物品数除以每行放置的物品数,得到一共需要多少行)
    local total_row_num = math.ceil( #panel_table_para / colu_num )
    
    -- 如果总行数小于4,将总行数置为4
    -- if total_row_num < 4 then
    --     total_row_num = 4
    -- end

    -- 创建scroll区域
    local scroll = CCScroll:scrollWithFile( pos_x, pos_y, size_w, size_h, total_row_num, bg_name, 
       TYPE_HORIZONTAL,600, 600 )
    -- 设置滑动条滑块
    scroll:setScrollLump( UIPIC_COMMON_PROGESS_UP,UIPIC_COMMON_PROGESS_BG,10, 30, size_h)

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
            local index = x * colu_num
            local bg = CCBasePanel:panelWithFile( 0, 0, 0, 0, "")
            local curx = 10
            local cury = 0

            for i = 1 , colu_num do
                if panel_table_para[index + i] then
                    local exchangePanel = ExchangePanel( panel_table_para[index + i], category )
                    bg:addChild( exchangePanel.view )
                    exchangePanel.view:setPosition( curx, 1)
                    curx = curx + exchangePanel.view:getSize().width+1    --有商品的列表间距
                    if cury < exchangePanel.view:getSize().height+1  then
                        cury = exchangePanel.view:getSize().height+1 
                    end
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