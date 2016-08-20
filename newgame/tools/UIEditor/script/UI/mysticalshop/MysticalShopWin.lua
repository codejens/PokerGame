-- MysticalShopWin.lua  
-- created by lyl on 2013-3.21
-- 神秘商店主窗口  mystical_Shop_win


super_class.MysticalShopWin(NormalStyleWindow)

require "model/MysticalShopModel"


function MysticalShopWin:__init( window_name, texture_name )
    local bgPanel = self.view

    -- local bgPanel_2 = CCZXImage:imageWithFile( 280, 388, -1, -1, UIResourcePath.FileLocate.common .. "win_title1.png");  --头部
    -- bgPanel:addChild( bgPanel_2 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 370 - 35, 401, -1, -1, UIResourcePath.FileLocate.shop .. "shop_title.png");        --标题名称
    -- bgPanel:addChild( bgPanel_3 )

    -- 妹子
    -- local beauty = CCZXImage:imageWithFile(-21, -12, -1, -1, UIResourcePath.FileLocate.mall .. "16.png")
    -- self.view:addChild(beauty)
    if Target_Platform == Platform_Type.Platform_91 or Target_Platform == Platform_Type.Platform_ap then
        -- local beauty = CCZXImage:imageWithFile(-50, 120, -1, -1, "nopack/body/11.png")
        -- self.view:addChild(beauty)
      else
        -- local beauty = CCZXImage:imageWithFile(-50, -12, -1, -1, UIResourcePath.FileLocate.mall .. "16.png")
        -- self.view:addChild(beauty)
    end


    --大背景底图
    -- local com_bg = ZImage:create(bgPanel, UIPIC_GRID_nine_grid_bg3, 100, 22, 788, 492+40, 0 ,500 ,500)   
    ZImage:create(bgPanel, UILH_COMMON.normal_bg_v2, 113, 11, 775, 550, 0 ,500 ,500)  

    --第二层底图
    local bgPanel_1 = CCBasePanel:panelWithFile( 124,72-5, 742+10, 452+35, UILH_COMMON.bottom_bg,500, 500);
    bgPanel:addChild( bgPanel_1 )

    --下方文字条底色
    -- local test_bg = ZImage:create(com_bg, UIResourcePath.FileLocate.common.."quan_bg.png", 4, 4, 746, -1 ,0 ,500 ,500)
    local sell_area = self:create_sell_area(  )
    bgPanel:addChild( sell_area )
    

    --元宝 礼券 背景
    ZImage:create(bgPanel,"",113,12,775,60,0,500,500)

    -- local bangding_gold_bg = CCBasePanel:panelWithFile( 350 + 118-4+57, 21, 110, 30, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)  
    -- bgPanel:addChild( bangding_gold_bg )
    -- 元宝
    self.yuanbao_lable = UILabel:create_lable_2( LH_COLOR[15]..Lang.bagInfo.yuanbao, 559,31 , 16, ALIGN_LEFT ) -- [1624]="#cffff00元宝：999"
    bgPanel:addChild( self.yuanbao_lable )

    -- local bangding_gold_bg = CCBasePanel:panelWithFile( 300+40-4+12, 30+3+10-3, 110, 30, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)  
    -- bgPanel:addChild( bangding_gold_bg )
    -- 绑定元宝
    self.bind_yuanbao_lable = UILabel:create_lable_2(LH_COLOR[15]..Lang.bagInfo.bindYuanbao, 236, 31, 16, ALIGN_LEFT ) -- [1625]="#cffff00礼券：999"
    bgPanel:addChild( self.bind_yuanbao_lable )    

    self:update( "all" )               -- 更新数据
end

-- 创建购买区域
function MysticalShopWin:create_sell_area(  )
	local panel = CCBasePanel:panelWithFile( 104, 52, 764, 464, "", 500, 500 )

    -- 列表
	self.item_t = MysticalShopModel:get_sell_item_info_list(  )
    self.sell_scroll = self:create_scroll_area( self.item_t, 10+15, 24, 754-13, 472, 3, 3, "" )
    panel:addChild( self.sell_scroll )

	return panel
end


-- 创建一个出售面板
function MysticalShopWin:create_one_sell_panel( item_info, x, y )
	local sell_panel = {}                  -- 出售面板对象

	local item_id = item_info.item or 0

	local pos_x = x or 0
    local pos_y = y or 0
    -- sell_panel.view = CCBasePanel:panelWithFile( pos_x, pos_y, 240, 131, UIResourcePath.FileLocate.mall .. "item_bg.png", 500, 500 )
    sell_panel.view = CCBasePanel:panelWithFile( pos_x, pos_y, 240, 131, "", 500, 500 )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return sell_panel
    end

    -- 道具slot
    sell_panel.slot = SlotItem( 64, 64 )
    sell_panel.slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -4, -4, 72, 72 )   -- 背框
    sell_panel.slot:setPosition( 16, 28 )
    sell_panel.slot:set_icon( item_id )
    sell_panel.slot:set_gem_level( item_id ) 
    local function item_click_fun( ... )
        local x, y, arg = ...
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = sell_panel.slot.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
        MallModel:show_mall_tips( item_id, pos.x, pos.y)
    end
    sell_panel.slot:set_click_event(item_click_fun)
    sell_panel.view:addChild( sell_panel.slot.view )

    -- 购买按钮
    local function buy_but_callback(eventType)
        if eventType == TOUCH_CLICK then
            MysticalShopModel:show_buy_panel( item_info )
            return true
        end
        return true
    end
    sell_panel.buy_but  = MUtils:create_btn( sell_panel.view, 
       UILH_COMMON.button5_nor,
        UILH_COMMON.button5_nor,
        buy_but_callback, 
        146, 14, 74, 37)
    local buy_but_lab = UILabel:create_lable_2( Lang.forge.synth[17], 37, 12, 16, ALIGN_CENTER )
    sell_panel.buy_but:addChild(buy_but_lab)

    -- 道具名称
    local title_bg = CCZXImage:imageWithFile( 21, 103, 202, 31, UILH_NORMAL.title_bg4 )
    local name_color = MysticalShopModel:get_item_color( item_id )
    sell_panel.name = UILabel:create_lable_2( name_color..item_base.name, 97, 8, 16, ALIGN_CENTER )
    title_bg:addChild( sell_panel.name )
    sell_panel.view:addChild( title_bg)

    --sell_panel.view:addChild( CCZXImage:imageWithFile( 70, 76, 140, 1, UIResourcePath.FileLocate.common .. "explain_bg.png" ) )                             -- 分割线

    -- 原价
    sell_panel.prince_name = _static_money_type[ item_info.price[1].type ] or ""  -- 金钱类型
    sell_panel.prime_cost_value = item_info.price[1].oldPrice or ""
    sell_panel.prime_cost_lable = UILabel:create_lable_2( "#c35c3f7"..Lang.mall_info[15]..sell_panel.prince_name..""..sell_panel.prime_cost_value, 95-7, 79, 14, ALIGN_LEFT ) -- [1626]="#c35c3f7原价"
    sell_panel.view:addChild( sell_panel.prime_cost_lable )
    -- 划线
    local line = CCZXImage:imageWithFile( 88, 84, 130+10, 1, UILH_MALL.split_line_y)
    sell_panel.view:addChild( line )

    -- 现价
    sell_panel.now_cost_value = item_info.price[1].price or ""                          -- 现价 
    sell_panel.now_cost_lable = UILabel:create_lable_2( "#c66ff66"..Lang.mall_info[16]..sell_panel.prince_name..""..sell_panel.now_cost_value, 95-7, 59, 14, ALIGN_LEFT ) -- [1627]="#c66ff66现价"
    sell_panel.view:addChild( sell_panel.now_cost_lable )

    -- 限购
    sell_panel.buy_limit_value = item_info.singleBuyLimit or ""
    sell_panel.buy_limit_lable = UILabel:create_lable_2( "#cffff00"..Lang.mall_info[23]..sell_panel.buy_limit_value, 120, 35-50, 16, ALIGN_CENTER ) -- [1628]="#cffff00限购:  "
    sell_panel.view:addChild( sell_panel.buy_limit_lable )    

    -- local line1 = CCZXImage:imageWithFile( 0, -30, 240, 2, UIResourcePath.FileLocate.common .. "jgt_line.png" )
    -- sell_panel.view:addChild( line1 )

    return sell_panel
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function MysticalShopWin:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    local all_info_num = #panel_table_para
    local create_flag = 0
    -- if row_num < 3 then
    --     row_num = 3
    -- end
    -- local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL, 500,500)
    -- scroll:setEnableCut(true)
    local scroll = CCScroll:scrollWithFile( pos_x, pos_y, size_w, size_h, row_num, bg_name, TYPE_HORIZONTAL, 600, 600 )
    scroll:setScrollLump( UIPIC_COMMON_PROGESS_UP,UIPIC_COMMON_PROGESS_BG,10, 30, size_h)
    scroll:setScrollLumpPos( 728 )
    local arrow_up = CCZXImage:imageWithFile(745-17 , 460, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(745-17, 0, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)

    scroll:addChild(arrow_up,1)
    scroll:addChild(arrow_down,1)
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
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, size_w-30, row_h, "")
            local colu_with = size_w / colu_num-4
            for i = 1, colu_num do
                create_flag = create_flag+1
                    if (create_flag <= all_info_num) then
                    local bg = self:create_sell_bg_panel( panel_table_para[index + i], (i - 1) * colu_with, 15, 240, 136 )
                    bg_vertical:addChild(bg)
                end
            end
            scroll:addItem(bg_vertical)




            -- local temparg = Utils:Split(args,":")
            -- local x = temparg[1]              -- 行
            -- local y = temparg[2]              -- 列
            -- local index = y * colu_num + x + 1

            -- if panel_table_para[index] then
	           --  local bg = CCBasePanel:panelWithFile( 0, 0, 161, 83, "")
	           --  local sellPanel = self:create_one_sell_panel( panel_table_para[index] )
	           --  bg:addChild( sellPanel.view )
	           --  scroll:addItem(bg)
            -- else
            --     local bg = CCBasePanel:panelWithFile( 0, 0, 161, 83, "")
	           --  -- local sellPanel = self:create_one_sell_panel( {} )
	           --  -- bg:addChild( sellPanel.view )
	           --  scroll:addItem(bg)
            -- end
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个购买面板, scroll用
function MysticalShopWin:create_sell_bg_panel( panel_date, x, y, w, h )
    -- print("创建一个购买面板 MysticalShopWin  ", panel_date)
    local bg = CCBasePanel:panelWithFile( x, y , w, h , UILH_COMMON.bg_11,500,500 )
    if panel_date == nil then
        return bg
    end

    local sellPanel = self:create_one_sell_panel( panel_date )
    bg:addChild( sellPanel.view )
    return bg
end

-- 提供外部静态调用的更新窗口方法
function MysticalShopWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_visible_window("mystical_Shop_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

-- 更新元宝数  yuanbao  bindYuanbao
function MysticalShopWin:update_yuanbao( money_type )
	if money_type == "yuanbao" then
	    local yuanbao = MysticalShopModel:get_player_yuanbao(  )
	    self.yuanbao_lable:setString( LH_COLOR[2]..Lang.mall_info[4]..LH_COLOR[15]..yuanbao ) -- [1481]="#cffff00元宝："
    elseif money_type == "bindYuanbao" then
    	local bind_yuanbao = MysticalShopModel:get_player_bind_yuanbao(  )
	    self.bind_yuanbao_lable:setString( LH_COLOR[2]..Lang.mall_info[7]..LH_COLOR[15]..bind_yuanbao ) -- [1482]="#cffff00礼券："
	end
end

-- 更新数据
function MysticalShopWin:update( update_type )
    if update_type == "yuanbao" then
        self:update_yuanbao( "yuanbao" )
    elseif update_type == "bindYuanbao" then
        self:update_yuanbao( "bindYuanbao" )
    elseif update_type == "all" then
        self:update_yuanbao( "yuanbao" )
        self:update_yuanbao( "bindYuanbao" )
    end
end

function MysticalShopWin:active( )
    self:update("all")
end

function MysticalShopWin:destroy()
    Window.destroy(self)

    -- 窗口关闭时通知model进行特殊操作，由于这窗口不是hide类型，所以在active不需要进行操作
    MysticalShopModel:close_shop_win()
end

