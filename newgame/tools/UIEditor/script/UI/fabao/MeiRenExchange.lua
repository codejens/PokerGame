-- MeiRenExchange.lua  
-- created by xiehande on 2015-3-9
-- 美人兑换窗口

super_class.MeiRenExchange(NormalStyleWindow);

function MeiRenExchange:__init( window_name, texture_name )
    local bgPanel = self.view
    --来点福利
    ZImage:create(self.view,"nopack/girl.png",-183,-16,-1,-1)
    local but_beg_x = 193            -- 按钮起始x坐标
    local but_beg_y = 522           -- 按钮起始y坐标

    --------------------------------------------------------------------------------------------
    local panel_width = 700
    local panel = CCBasePanel:panelWithFile( 130+42,8, panel_width+20, 520, UILH_COMMON.normal_bg_v2,500, 500);
    bgPanel:addChild(panel)

    --第二层底图
    local bgPanel_1 = CCBasePanel:panelWithFile( 0,0, panel_width, 452, UILH_COMMON.bottom_bg,500, 500);
    local bgPanel_h = bgPanel_1:getSize().height
    bgPanel_1:setPosition(but_beg_x-12,but_beg_y-bgPanel_h+5-10)
    bgPanel:addChild( bgPanel_1 )

    --滑块上 
    local scrollbar_up = ZImage:create(bgPanel_1,UIPIC_DREAMLAND.scrollbar_up,724-42,434,-1,-1)
    --获取某个兑换组
    local group = HeLuoConfig.getCardDuiHuanGroup(  )

    --获取美人某个目录下的所有卡牌
    --谢汉德  这里写死  还需要修改
    local card = HeLuoConfig.getCardDuiHuanCardByGroup( 1 )

    self.equip_item_id_t = card
    
    for i=1,#self.equip_item_id_t do
        print(self.equip_item_id_t[i])
    end

    self.equip_sell_scroll = self:create_scroll_area( self.equip_item_id_t, 140+42, 80, 723-42, 420, 3, 4, "")
    self.view:addChild( self.equip_sell_scroll )
    local scrollbar_down = ZImage:create(bgPanel_1,UIPIC_DREAMLAND.scrollbar_down,724-42,6,-1,-1)

    --文字底图
    local text_panel  = CCBasePanel:panelWithFile(but_beg_x-8,15,panel_width,60,"",500,500)
    bgPanel:addChild(text_panel)

    -- 玉魄
    local yupo_lab = UILabel:create_lable_2(LH_COLOR[13]..Lang.lingqi.hougong[8], 90, 20, 16, ALIGN_RIGHT )
    text_panel:addChild( yupo_lab )
    self.yupo = UILabel:create_lable_2( LH_COLOR[2].."0", 90, 20, 14, ALIGN_LEFT )
    text_panel:addChild( self.yupo )   


    -- 魂魄
    -- local hunpo_lab = UILabel:create_lable_2(LH_COLOR[13]..Lang.lingqi.hougong[9], 356, 36, 16, ALIGN_LEFT )
    -- bgPanel:addChild( hunpo_lab )
    -- self.hunpo = UILabel:create_lable_2( LH_COLOR[2].."0", 223, 20, 16, ALIGN_LEFT )
    -- text_panel:addChild( self.hunpo )


    -- 神魄
    -- local shenpo = UILabel:create_lable_2(LH_COLOR[13]..Lang.lingqi.hougong[10], 482, 36, 16, ALIGN_LEFT )
    -- bgPanel:addChild( shenpo )
    -- self.shenpo = UILabel:create_lable_2( LH_COLOR[2].."0", 350, 20, 16, ALIGN_LEFT )
    -- text_panel:addChild( self.shenpo )

    -- 获取说明
    local function explain_but_fun( eventType,x,y )
    	if eventType == TOUCH_CLICK then 
            self:show_get_explain(  )
        end
        return true
    end
   --问题图片
   local wenhao = MUtils:create_btn(bgPanel,LH_UI_EXCHANGE_003,LH_UI_EXCHANGE_003,explain_but_fun,691,24,-1,-1)
   --获取说明
   local explain_but = UIButton:create_button( 596-42, 16, -1, -1, LH_UI_EXCHANGE_004, LH_UI_EXCHANGE_004, LH_UI_EXCHANGE_004)
   explain_but:registerScriptHandler( explain_but_fun )
   text_panel:addChild( explain_but )
end


function MeiRenExchange:show_get_explain(  )
    local explain_content =Lang.lingqi.hougong[11]
                        
    local help_win = UIManager:find_visible_window("help_panel")
    if help_win ~= nil then
        UIManager:hide_window("help_panel")
        HelpPanel:show( 3, UIPIC_COMMON_TIPS, explain_content )
    else
       HelpPanel:show( 3, UIPIC_COMMON_TIPS, explain_content )
    end 
end


function MeiRenExchange:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    -- 总行数(总物品数除以每行放置的物品数,得到一共需要多少行)
    local total_row_num = math.ceil( #panel_table_para / colu_num )
    
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
            local curx = 8
            local cury = 0

            for i = 1 , colu_num do
                if panel_table_para[index + i] then
                    local card = HeLuoConfig.getCardConfig( panel_table_para[index + i] )
                    local exchangePanel = self:create_item_panel(card)
                    bg:addChild( exchangePanel )
                    exchangePanel:setPosition( curx, 1)
                    curx = curx + exchangePanel:getSize().width+1    --有商品的列表间距
                    if cury < exchangePanel:getSize().height+1  then
                        cury = exchangePanel:getSize().height+1 
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

--创建单个选项
function MeiRenExchange:create_item_panel(card, x, y )
    local item_id = card.itemId
    -- print("道具ID",item_id)
    local pos_x = x or 0
    local pos_y = y or 0
    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, 237-15, 139,UILH_COMMON.bg_11 , 500, 500 )

    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 
    end
    -- slot
    local slot = SlotItem( 70, 70 )
    slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -7, -8, 84, 84 )   -- 背框
    slot:setPosition( 18, 18 )
    slot:set_icon( item_id )
    slot:set_color_frame( item_id, 1, 1, 68, 68 )    -- 边框颜色
    panel:addChild(slot.view )

    -- slot单击
    local function item_click_fun (slot_obj, eventType, arg, msgid)
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slot.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
        TipsModel:show_shop_tip( pos.x , pos.y, item_id )
    end
    slot:set_click_event(item_click_fun)

    -- 道具名称
    local view_width = panel:getSize()
    local name_color = ItemModel:get_item_color( item_id )
    -- local name = string.sub(item_base.name, 9,#item_base.name) --手动减去前面星级

    --名字的底板
    local title_bg = CCZXImage:imageWithFile( 21, 103, 202, 31, UILH_NORMAL.title_bg4 )
    local name_lab = UILabel:create_lable_2( name_color..item_base.name, 202*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    title_bg:addChild( name_lab )
    panel:addChild(title_bg)
    
    --需要的某种魄条件
    local po_txt = nil
    local mtype = HeLuoConfig.getDuihuanConfig(card.id).mtype
    if mtype == 1 then
        po_txt = Lang.lingqi.hougong[8]
    elseif  mtype ==2 then
        po_txt =Lang.lingqi.hougong[9]
    elseif mtype==3 then
        po_txt =Lang.lingqi.hougong[10]
    end
    local cost_val = HeLuoConfig.getDuihuanConfig(card.id).value
    self.need_yupo_lable = UILabel:create_lable_2( "#c66ff66"..po_txt .."#cffff00"..cost_val , 99, 67, 16, ALIGN_LEFT  )
    panel:addChild( self.need_yupo_lable )

    -- 兑换按钮
    local function buy_but_callback( event_type )
        --兑换美人
        if card.id then
            -- local need_vip = HeLuoConfig.getVipLevel( card.quality )
            -- print(VIPModel:get_vip_info().level ,need_vip, card.quality)
            -- if VIPModel:get_vip_info().level >= need_vip then
            --这个版本还不需要做美人兑换限制
                HeLuoBooksCC:req_duihuan_card( card.id, 1 )
            -- else
                -- GlobalFunc:create_screen_notic( "VIP用户" .. need_vip .. "以上可兑换该卡牌" )
            -- end
        end
    end

    local temp_button = ZTextButton:create( panel,Lang.exchange.model[2] , UILH_COMMON.button4, buy_but_callback, 118, 13 )
    temp_button.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)
    
    return panel
end


-- 提供外部静态调用的更新窗口方法
function MeiRenExchange:update_win( update_type )
    local win = UIManager:find_visible_window("meiren_exchange_win")
    if win then
        win:update( update_type );   
    end
end

-- 更新数据
function MeiRenExchange:update( update_type )
    if update_type == "duihuan_count" then
        self:update_duihuan_count(  )
    elseif update_type == "meiren_po" then 
        self:update_meiren_po( )    
    elseif update_type == "all" then
          self:update_duihuan_count(  )
          self:update_meiren_po( )  
    end
end

--更新兑换次数
function MeiRenExchange:update_duihuan_count( data )
    if not data then
        return
    end
    --更新仙券
    if data ~= nil then
        -- self.xianquan:setText( "#cf6f6f6持有仙券:" .. data.xianquan )
        -- print("更新兑换次数 update_duihuan_count",data)
    end
end


--更新美人所需的玉魄 魂魄 
function MeiRenExchange:update_meiren_po( data )
    if data ~= nil then
        self.yupo:setText(data[1])
        -- self.hunpo:setText(data[2])
        -- self.shenpo:setText(data[3])
        
    end
end

-- 激活时更新数据
function MeiRenExchange:active( show )
    -- self:update("all")
    if show then
        -- HeLuoBooksCC:req_duihuan_count()
        HeluoBooksModel.update_meiren_po_count( )
    end
end

function MeiRenExchange:destroy()
    Window.destroy(self)
end


