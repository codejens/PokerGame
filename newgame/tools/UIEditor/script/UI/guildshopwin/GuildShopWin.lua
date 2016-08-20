-- GuildShopWin.lua  
-- created by lyl on 2012-3-1
-- 仙宗商店主窗口  guild_shop_win

require "UI/component/Window"
super_class.GuildShopWin(NormalStyleWindow)


function GuildShopWin:__init( window_name, texture_name )
    
    local bgPanel = self.view  
    self.sell_panel_t   = {}           -- 存储所有出售面板对象

    --背景色
    -- local shop_bg = ZImage:create( self.view,  UIPIC_GRID_nine_grid_bg3 , 8, 8, 372, 380 , 0, 500 ,500)   
    local shop_bg = CCBasePanel:panelWithFile(22, 15, 400, 550, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(shop_bg)

    -- local shop_bg2 = CCBasePanel:panelWithFile(10, 10, 380, 550, UIPIC_FAMILY_011, 500, 500)
    -- shop_bg:addChild(shop_bg2)

    -- 物品列表
    local item_date_t = GuildModel:get_guild_item_list(  )
    self.item_list_scroll = self:create_scroll_area( item_date_t , 2, 13, 380, 525, 2, 4, "")
    local arrow_up = CCZXImage:imageWithFile(382 , 527, 10, -1 , UILH_COMMON.scrollbar_up)
    local arrow_down = CCZXImage:imageWithFile(382, 12, 10, -1, UILH_COMMON.scrollbar_down)
    shop_bg:addChild( self.item_list_scroll )
    shop_bg:addChild( arrow_up )
    shop_bg:addChild( arrow_down )
    --最上层的贴图
    -- local bgPanel_2 = CCZXImage:imageWithFile( 80 - 5, 388, -1, -1, UIResourcePath.FileLocate.common .. "win_title1.png");  --头部
    -- bgPanel:addChild( bgPanel_2, 10 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 165 - 33, 400, -1, -1, UIResourcePath.FileLocate.guild .. "xianzongshangdian.png");  --标题名称
    -- bgPanel:addChild( bgPanel_3, 10 )

    -- 关闭按钮
    -- local function close_but_CB( )
	   --  require "UI/UIManager"
    --     UIManager:hide_window( "guild_shop_win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 340 , 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = bgPanel:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- bgPanel:addChild( close_but )
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function GuildShopWin:create_scroll_area( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    if row_num < 4 then
        row_num = 4
    end
    -- local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL, 500,500)
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    scroll:setScrollLump( UILH_COMMON.up_progress,UILH_COMMON.down_progress, 10, 10, size_h / row_num)
    scroll:setScrollLumpPos(size_w)
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
            local index = x * colu_num 
            local row_h = size_h / sight_num
            local function panel_fun(eventType,args,msgid)
                if eventType == ITEM_DELETE then
                    print("ITEM_DELETE",ITEM_DELETE)
                    for i=1,colu_num do
                        -- print("x,i,colu_num,index",x,i,colu_num,index)
                        -- print("#panel_table_para,index + i",#panel_table_para,index + i)
                        if index+i <= #panel_table_para then
                            local item_id = panel_table_para[index+i].itemid;
                            self.sell_panel_t[ item_id ] = nil;
                        end
                    end
                end
                return true;
            end
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, size_w, row_h, "")
            bg_vertical:registerScriptHandler(panel_fun);
            local colu_with = size_w / colu_num
            for i = 1, colu_num do
                local bg = self:create_scroll_cell( panel_table_para[index+i], (i - 1) * colu_with, 4, 181, 117 )
                bg_vertical:addChild(bg)
            end

            scroll:addItem(bg_vertical)
            scroll:refresh()
            return true
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个scroll中的每个出售面板
function GuildShopWin:create_scroll_cell( panel_table_para, x, y, w, h )
    local bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if panel_table_para == nil then
        return bg
    end
    local sellPanel = self:create_sell_panel( panel_table_para.itemid, panel_table_para.level, panel_table_para.contrib )
    if sellPanel then
        bg:addChild(sellPanel.view)
    end
    return bg
end

-- 创建单个出售面板
function GuildShopWin:create_sell_panel( item_id, level, price )
	local sell_panel = {}         -- 出售面板对象

	sell_panel.view = CCBasePanel:panelWithFile(4, 0, 186, 125, UILH_COMMON.bg_11, 500, 500 )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return sell_panel
    end

    -- 横线
    -- local line = CCZXImage:imageWithFile( 2, 55, 177, 6, "ui/common/coner1.png", 500, 500 )
    -- sell_panel.view:addChild( line )

    -- slot
    sell_panel.slot = SlotItem( 56, 56 )
    sell_panel.slot:set_icon_bg_texture(UILH_COMMON.slot_bg, -8, -8, 72, 72 )   -- 背框
    sell_panel.slot:setPosition( 12, 14 )
    sell_panel.slot:set_icon( item_id )
    sell_panel.view:addChild( sell_panel.slot.view )
    sell_panel.slot:set_gem_level( item_id ) 

    -- slot单击
    local function item_click_fun ()
        GuildModel:show_shop_tips( item_id )
    end
    sell_panel.slot:set_click_event(item_click_fun)

    -- 百宝奇阁 级数
    -- local level_bg = ZImage.new(UIPIC_FAMILY_051)
    -- level_bg:setPosition(3, 84)
    -- level_bg:setSize(120, 27)
    -- sell_panel.view:addChild(level_bg.view)

    local color_value = GuildModel:get_shop_baibao_color_by_level( level )
    sell_panel.baibao_level = UILabel:create_lable_2( color_value..level..LangGameString[1232], 43, 84, 16, ALIGN_LEFT ) -- [1232]="级百宝奇阁"
    sell_panel.view:addChild( sell_panel.baibao_level )

    -- 道具名称
    -- sell_panel.name = UILabel:create_lable_2( "#cffff00"..item_base.name, 65, 40, 14, ALIGN_LEFT )
    -- sell_panel.view:addChild( sell_panel.name )

    -- 价格
    sell_panel.price = UILabel:create_lable_2( price..LangGameString[1233], 85, 60, 16, ALIGN_LEFT ) -- [1233]="贡献"
    sell_panel.view:addChild( sell_panel.price )

    -- 购买按钮
    local function buy_but_callback()
        GuildModel:buy_guild_shop_item( item_id, level )
     end
    -- sell_panel.buy_but = UIButton:create_button_with_name( 88, 10, 74, 37, LH_UI_EXCHANGE_002, LH_UI_EXCHANGE_002, nil, "购买", buy_but_callback )
    -- sell_panel.view:addChild( sell_panel.buy_but.view )
    sell_panel.buy_but = ZTextButton:create( sell_panel.view,Lang.mall_info[8], LH_UI_EXCHANGE_002, buy_but_callback, 88, 16 )
       sell_panel.buy_but.view:addTexWithFile(CLICK_STATE_DISABLE, LH_UI_EXCHANGE_009)

    -- 行对象的方法
    -- 更新百宝奇阁提示
    sell_panel.set_baibao_level = function()
        local color_value = GuildModel:get_shop_baibao_color_by_level( level )
        sell_panel.baibao_level:setString( color_value..level..LangGameString[1232] ) -- [1232]="级百宝奇阁"
    end

    self.sell_panel_t[ item_id ] = sell_panel
    return sell_panel
end

-- 刷新百宝奇阁等级要求提示
function GuildShopWin:update_baibao_level(  )
    for key, sell_panel in pairs( self.sell_panel_t ) do
        print("sell_panel",sell_panel);
        sell_panel.set_baibao_level()
    end
end

-- 激活
function GuildShopWin:active( if_active )
    if if_active then
        self:update_baibao_level(  )
    end
end
