-- MallItemList.lua
-- created by lyl on 2013-2-17
-- 商城，物品列表窗口 

super_class.MallItemList( Window )

require "UI/mall/MallSellPanel"

local panel_beg_x = 155
local _left_bg_h = 424
local _left_bg_w_1 = 455
local _left_bg_w_2 = 766
local _left_scroll_w_1 = 460
local _left_scroll_w_2 = 695

local _limit_item_y_1 = 243
local _limit_item_y_2 = 52
local _limit_item_x_1 = 10
local panel_limit_w = 240

-- Lang
local txt_lang_info = Lang.mall_info

function MallItemList:create(  )
	return MallItemList( "MallItemList", "", false, 770+80, 437+60  )
end

function MallItemList:__init( window_name, window_info )
    self.list_scroll_t = {}         -- 记录每个列表，控制显示与隐藏

    self.left_bg = CCBasePanel:panelWithFile( panel_beg_x-25, 65, 500, _left_bg_h, "", 500, 500)  -- 名称
     self.view:addChild(  self.left_bg )

    self:Choose_panel( "hot" )
end


-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function MallItemList:create_scroll_area( panel_table_para , category, pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    print("----------row_num", row_num)
    if row_num < 3 then
        row_num = 3
    end
    -- local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL, 500,500)
    -- scroll:setEnableCut(true)
    print("MallItemList maxnum", row_num)
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    -- scroll:setupGradientFront(UIPIC_SCROLL_GRADIENT_FRONT)
    -- scroll:setScrollLump(UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 10, 4, 122)
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
            local index = x * colu_num
            local bg = CCBasePanel:panelWithFile( 0, 0, 0, 0, "")
            local curx = 6
            local cury = 0
            local offset_x = 10
            -- if "hot" == category then
            --     curx = 0
            --     offset_x = 0
            -- end
            print("-----------------------odkjldj ", x, y)
            for i = 1 , colu_num do
                if panel_table_para[index + i] then
                    --local bg = CCBasePanel:panelWithFile( 0, 0, 161, 83, "")
                    local mallSellPanel = MallSellPanel( panel_table_para[index + i], category )
                    bg:addChild( mallSellPanel.view )
                    mallSellPanel.view:setPosition( curx, 10)
                    curx = curx + mallSellPanel.view:getSize().width+offset_x    --有商品的列表间距
                    if cury < mallSellPanel.view:getSize().height+10   then
                        cury = mallSellPanel.view:getSize().height+10 
                    end
                    --scroll:addItem(bg)
                else
                    -- --local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
                    -- local mallSellPanel = MallSellPanel( nil )
                    -- bg:addChild( mallSellPanel.view )
                    -- mallSellPanel.view:setPosition( curx, 0)
                    -- curx = curx + mallSellPanel.view:getSize().width+10     --没有商品的列表间距
                    -- if cury < mallSellPanel.view:getSize().height+10   then
                    --     cury = mallSellPanel.view:getSize().height+10 
                    -- end
                    -- --scroll:addItem(bg)
                end
            end
            bg:setSize(curx, cury)
            scroll:addItem(bg)
            scroll:refresh()
            return false
        end
    end
 
    scroll:registerScriptHandler(scrollfun)
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)
    scroll:refresh()

    return scroll
end 

-- 创建限时抢购面板
function MallItemList:create_item_limit(  )

    local time_limit_panel = CCBasePanel:panelWithFile( panel_beg_x+450, 70, panel_limit_w, _left_bg_h, UILH_MALL.frame_horn, 500, 500 )

    -- 右底板背景
    local right_bg = CCBasePanel:panelWithFile( 0, 0, panel_limit_w, _left_bg_h, UILH_MALL.frame_horn, 500, 500)  -- 名称
    time_limit_panel:addChild( right_bg, 1 )

    -- 添加面板背景
    local panel_bg_left = CCBasePanel:panelWithFile( 5, 0, panel_limit_w*0.5-4.5, -1, "nopack/BigImage/mall_bg.png")  
    time_limit_panel:addChild( panel_bg_left )
    local panel_bg_right = CCBasePanel:panelWithFile( panel_limit_w*0.5, 0, panel_limit_w*0.5-5, -1, "nopack/BigImage/mall_bg.png")  
    panel_bg_right:setFlipX(true)
    time_limit_panel:addChild( panel_bg_right )

    -- 标题背景(左右拼接)
    local title_bg_left = CCBasePanel:panelWithFile( 16, 387, 120, -1, UILH_MALL.top_bg, 500, 500)  
    time_limit_panel:addChild( title_bg_left )
    local title_bg_right = CCBasePanel:panelWithFile( panel_limit_w*0.5-15, 387, 120, -1, UILH_MALL.top_bg, 500, 500)  
    title_bg_right:setFlipX(true)
    time_limit_panel:addChild( title_bg_right )

    -- local bg = CCBasePanel:panelWithFile( -5, 0, 250, 405, UIResourcePath.FileLocate.mall .. "17.png", 500, 500)  -- 名称
    -- time_limit_panel:addChild( bg )

    MUtils:create_zximg(title_bg_right, UILH_MALL.limit_sell, -50, 7, -1, -1);

    -------------------------------1-------------------------
    local beg_x = 8
    local font_size = 16

    -- 优惠道具
    self.limit_SellPanel_1 = MallSellPanel( 18600, "limit", _limit_item_x_1, _limit_item_y_1 )  
    time_limit_panel:addChild( self.limit_SellPanel_1.view )

    self.limit_num_lable_1 = UILabel:create_lable_2( txt_lang_info[9]..txt_lang_info[13], panel_limit_w*0.5, 225, font_size, ALIGN_CENTER ) -- [1003]="#cffff00数量:"
    time_limit_panel:addChild( self.limit_num_lable_1 )

    self.limit_time_lable_1 = UILabel:create_lable_2( txt_lang_info[10]..txt_lang_info[14], panel_limit_w*0.5, 205, font_size, ALIGN_CENTER ) -- [1474]="#cffff00时间:"
    time_limit_panel:addChild( self.limit_time_lable_1 )

    local line1 = CCZXImage:imageWithFile( -10, 195, panel_limit_w, 4, UILH_MALL.split_line_shade )
    time_limit_panel:addChild( line1 )

    -----------------------------2---------------------------

    self.limit_SellPane_2 = MallSellPanel( 18210, "limit", _limit_item_x_1, _limit_item_y_2 )
    time_limit_panel:addChild( self.limit_SellPane_2.view )

    self.limit_num_lable_2 = UILabel:create_lable_2( txt_lang_info[9]..txt_lang_info[13],  panel_limit_w*0.5, 34, font_size, ALIGN_CENTER ) -- [1003]="#cffff00数量:"
    time_limit_panel:addChild( self.limit_num_lable_2 )

    self.limit_time_lable_2 = UILabel:create_lable_2( txt_lang_info[10]..txt_lang_info[14], panel_limit_w*0.5, 15, font_size, ALIGN_CENTER ) -- [1474]="#cffff00时间:"
    time_limit_panel:addChild( self.limit_time_lable_2 )

    -- local line = CCZXImage:imageWithFile( beg_x, 40-5, 255, 2, UIPIC_MALLWIN_008 )
    -- time_limit_panel:addChild( line )

    --  local notice_lable = UILabel:create_lable_2( txt_lang_info[11], 256/2, 12, font_size, ALIGN_CENTER ) -- [1475]="#c66ff66限时优惠商品购买后绑定"
    -- time_limit_panel:addChild( notice_lable )

    -- MUtils:create_zximg(title_bg, UIResourcePath.FileLocate.mall.."xianshiyouhui.png", 20,13, 130, 35);

    return time_limit_panel 
end

-- 选择显示的面板   hot  common  pet  individuality  binding_gold 
function MallItemList:Choose_panel( panel_type )
    for key, scroll_view in pairs(self.list_scroll_t) do
        scroll_view:setIsVisible( false )
    end
    local p_offset_x = 2
    local p_offset_y = 2
    local scroll_h = 430
    if panel_type == "hot" then
        self.left_bg:setSize( _left_bg_w_1, _left_bg_h)
        if self.hot_sell_scroll == nil then
            -- 热销
            self.hot_item_id_t = MallModel:get_sell_list( "hot" )
            self.hot_sell_scroll = self:create_scroll_area( self.hot_item_id_t, "hot", p_offset_x, p_offset_y, _left_scroll_w_1, scroll_h, 2, 3, "" )
            self.left_bg:addChild( self.hot_sell_scroll )
            table.insert( self.list_scroll_t, self.hot_sell_scroll )

            -- 添加滚动条上下箭头
            self.scroll_up = CCZXImage:imageWithFile(_left_scroll_w_1+2, scroll_h-8, -1, -1, UILH_COMMON.scrollbar_up)
            self.left_bg:addChild(self.scroll_up, 1)
            self.scroll_down = CCZXImage:imageWithFile(_left_scroll_w_1+2, 3, -1, -1, UILH_COMMON.scrollbar_down)
            self.left_bg:addChild(self.scroll_down, 1)

            -- 竖直分割线
            -- self.split_line_v = CCZXImage:imageWithFile( panel_beg_x+485, 80, 4, 422, UILH_COMMON.split_line_v )
            -- self.view:addChild( self.split_line_v )
            -- table.insert( self.list_scroll_t, self.split_line_v )

            -- 热销右侧，限时道具
            self.time_limit_panel = MallItemList:create_item_limit(  )
            self.view:addChild( self.time_limit_panel )
            table.insert( self.list_scroll_t, self.time_limit_panel )
        end
        self.hot_sell_scroll:setIsVisible( true )
        self.time_limit_panel:setIsVisible( true )
        -- self.split_line_v:setIsVisible(true)
        self.scroll_up:setPositionX(_left_scroll_w_1+2)
        self.scroll_down:setPositionX(_left_scroll_w_1+2)
        
    elseif panel_type == "common" then
        self .left_bg:setSize(_left_bg_w_2, _left_bg_h)
        if self.common_sell_scroll == nil then
            -- 常用
            self.common_item_id_t = MallModel:get_sell_list( "common" )
            self.common_sell_scroll = self:create_scroll_area( self.common_item_id_t, "common", p_offset_x, p_offset_y , _left_scroll_w_2, scroll_h, 3, 3, "" )
            self.left_bg:addChild( self.common_sell_scroll )
            table.insert( self.list_scroll_t, self.common_sell_scroll )
        end
        self.common_sell_scroll:setIsVisible( true )
        self.scroll_up:setPositionX(_left_scroll_w_2+2)
        self.scroll_down:setPositionX(_left_scroll_w_2+2)
    elseif panel_type == "individuality" then
         self .left_bg:setSize(_left_bg_w_2, _left_bg_h)
        if self.individuality_sell_scroll == nil then
            -- 个性装扮
            self.individuality_item_id_t = MallModel:get_sell_list( "individuality" )
            self.individuality_sell_scroll = self:create_scroll_area( self.individuality_item_id_t, "individuality", p_offset_x, p_offset_y, _left_scroll_w_2, scroll_h, 3, 3, "" )
            self.left_bg:addChild( self.individuality_sell_scroll )
            table.insert( self.list_scroll_t, self.individuality_sell_scroll )
        end
        self.individuality_sell_scroll:setIsVisible( true )
        self.scroll_up:setPositionX(_left_scroll_w_2+2)
        self.scroll_down:setPositionX(_left_scroll_w_2+2)

    elseif panel_type == "stone" then
         self .left_bg:setSize(_left_bg_w_2, _left_bg_h)
        if self.stone_sell_scroll == nil then
            -- 宝石强化
            self.stone_item_id_t = MallModel:get_sell_list( "stone" )
            self.stone_sell_scroll = self:create_scroll_area( self.stone_item_id_t, "stone", p_offset_x, p_offset_y, _left_scroll_w_2, scroll_h, 3, 3, "" )
            self.left_bg:addChild( self.stone_sell_scroll )
            table.insert( self.list_scroll_t, self.stone_sell_scroll )
        end
        self.stone_sell_scroll:setIsVisible( true )
        self.scroll_up:setPositionX(_left_scroll_w_2+2)
        self.scroll_down:setPositionX(_left_scroll_w_2+2)
    elseif panel_type == "pet" then
         self .left_bg:setSize(_left_bg_w_2, _left_bg_h)
        if self.pet_sell_scroll == nil then
            -- 宠物道具
            self.pet_item_id_t = MallModel:get_sell_list( "pet" )
            self.pet_sell_scroll = self:create_scroll_area( self.pet_item_id_t, "pet", p_offset_x, p_offset_y, _left_scroll_w_2, scroll_h, 3, 3, "" )
            self.left_bg:addChild( self.pet_sell_scroll )
            table.insert( self.list_scroll_t, self.pet_sell_scroll )
        end
        self.pet_sell_scroll:setIsVisible( true )
        self.scroll_up:setPositionX(_left_scroll_w_2+2)
        self.scroll_down:setPositionX(_left_scroll_w_2+2)
    elseif panel_type == "binding_gold" then
         self .left_bg:setSize(_left_bg_w_2, _left_bg_h)
        if self.binding_gold_sell_scroll == nil then
            -- 礼券商品
            self.binding_gold_item_id_t = MallModel:get_sell_list( "binding_gold" )
            self.binding_gold_sell_scroll = self:create_scroll_area( self.binding_gold_item_id_t, "binding_gold", p_offset_x, p_offset_y, _left_scroll_w_2, scroll_h, 3, 3, "" )
            self.left_bg:addChild( self.binding_gold_sell_scroll )
            table.insert( self.list_scroll_t, self.binding_gold_sell_scroll )
        end
        self.binding_gold_sell_scroll:setIsVisible( true )
        self.scroll_up:setPositionX(_left_scroll_w_2+2)
        self.scroll_down:setPositionX(_left_scroll_w_2+2)
    elseif panel_type == "huanqing" then
         self .left_bg:setSize(_left_bg_w_2, _left_bg_h)
        if self.huanqing_sell_scroll == nil then
            -- 欢庆道具
            self.huanqing_item_id_t = MallModel:get_sell_list( "huanqing" )
            self.huanqing_sell_scroll = self:create_scroll_area( self.huanqing_item_id_t, "huanqing", p_offset_x, p_offset_y, _left_scroll_w_2, scroll_h, 3, 3, "" )
            self.left_bg:addChild( self.huanqing_sell_scroll )
            table.insert( self.list_scroll_t, self.huanqing_sell_scroll )
        end
        self.huanqing_sell_scroll:setIsVisible( true )
        self.scroll_up:setPositionX(_left_scroll_w_2+2)
        self.scroll_down:setPositionX(_left_scroll_w_2+2)
    end
end

function MallItemList:update( update_type )
    if update_type == "limit" then
        self:update_limit_panel(  )
    elseif update_type == "limit_time" then
        self:update_limit_panel_time(  )
    else
        
    end
end

-- 更新抢购面板  出售信息
function MallItemList:update_limit_panel(  )
    local beg_x = 8

    local item_list = MallModel:get_limit_sell_item_list(  )
-- print("抢购面板道具id：：： 第一个：", item_list[1].mall_item_id,  " 第二个：s", item_list[2].mall_item_id )

    if item_list[1] then
        local item_id_temp = MallModel:get_item_id_by_mall_id( item_list[1].mall_item_id )
        self.time_limit_panel:removeChild( self.limit_SellPanel_1.view,true);
        self.limit_SellPanel_1 = MallSellPanel( item_id_temp, "limit", _limit_item_x_1, _limit_item_y_1 )  
        self.time_limit_panel:addChild( self.limit_SellPanel_1.view )

        local  time_str = MallModel:get_limit_time_str(  )
        self.limit_time_lable_1:setString( txt_lang_info[10]..time_str ) -- [1474]="#cffff00时间:"

        self.limit_num_lable_1:setString( txt_lang_info[9]..item_list[1].uCount ) -- [1003]="#cffff00数量:"
    end

    if item_list[2] then
        local item_id_temp = MallModel:get_item_id_by_mall_id( item_list[2].mall_item_id )
        self.time_limit_panel:removeChild( self.limit_SellPane_2.view, true )
        self.limit_SellPane_2 = MallSellPanel( item_id_temp, "limit", _limit_item_x_1, _limit_item_y_2 )  
        self.time_limit_panel:addChild( self.limit_SellPane_2.view )

        local  time_str = MallModel:get_limit_time_str(  )
        self.limit_time_lable_2:setString( txt_lang_info[10]..time_str ) -- [1474]="#cffff00时间:"

        self.limit_num_lable_2:setString( txt_lang_info[9]..item_list[2].uCount ) -- [1003]="#cffff00数量:"
    end
    
end

-- 更新抢购面板  时间信息
function MallItemList:update_limit_panel_time(  )
    local  time_str = MallModel:get_limit_time_str(  )
    self.limit_time_lable_1:setString( txt_lang_info[10]..time_str ) -- [1474]="#cffff00时间:"
    self.limit_time_lable_2:setString( txt_lang_info[10]..time_str ) -- [1474]="#cffff00时间:"
end
