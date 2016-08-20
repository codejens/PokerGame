-- ExchangePanel.lua
-- created by lyl on 2013-2-19
-- 兑换，出售单个道具面板 

super_class.ExchangePanel(  )


function ExchangePanel:__init( item_id, category, x, y )
    local pos_x = x or 0
    local pos_y = y or 0

    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 237, 139,UILH_COMMON.bg_11 , 500, 500 )

    --if true then return end

    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 
    end

    -- slot
    self.slot = SlotItem( 70, 70 )
    self.slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -7, -8, 84, 84 )   -- 背框
    self.slot:setPosition( 18, 18 )
    self.slot:set_icon( item_id )
    self.slot:set_color_frame( item_id, 1, 1, 68, 68 )    -- 边框颜色
    self.view:addChild( self.slot.view )
    --是装备才显示特效，天劫石等不是装备
    if category =="equipment" and item_id~=18800 then
        local _effect =self.slot:play_activity_effect(57)
        _effect:setScale(1.2)
        _effect:setPosition(35,32)
    end


    -- slot单击
    local function item_click_fun (slot_obj, eventType, arg, msgid)
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = self.slot.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
        ExchangeModel:show_mall_tips( item_id, pos.x , pos.y )

        
    end
    self.slot:set_click_event(item_click_fun)

    -- 道具名称
    local view_width = self.view:getSize()
    local name_color = ExchangeModel:get_item_color( item_id )

    --名字的底板
    local title_bg = CCZXImage:imageWithFile( 21, 103, 202, 31, UILH_NORMAL.title_bg4 )
    self.name = UILabel:create_lable_2( name_color..item_base.name, 202*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    title_bg:addChild( self.name )
    self.view:addChild(title_bg)

    -- 添加一条线
    -- line = ZImage:create(self.view,UILH_COMMON.split_line,99,16,3,75)

    -- local line = CCZXImage:imageWithFile( 99, 16, 3, 75, UILH_COMMON.split_line )     
    -- self.view:addChild( line )  

    -- 等级
    local color_1 = "#cF0A001"
    local color_2 = "#cffffff"
    if not ExchangeModel:check_level( item_id, category ) then
        color_1 = "#cff0000"
        color_2 = "#cff0000"
    end
    local level = ExchangeModel:get_item_need_level( item_id, category ) or ""
    self.level_lable = UILabel:create_lable_2( color_1..Lang.exchange.model[1]..color_2..level, 107, 77, 16, ALIGN_LEFT ) -- [940]="等级:"
    self.view:addChild( self.level_lable )

    -- 历练
    local price_name, price_value = ExchangeModel:get_item_need_money( item_id, category )
    local ll_text = nil
    if category =="glory" then
        ll_text = Lang.exchange.rongyu
    else
        ll_text = Lang.exchange.ll_text
    end
    self.lilian_lable = UILabel:create_lable_2( "#cF0A001"..ll_text.."#cffffff"..price_value, 107, 55, 16, ALIGN_LEFT )
    self.view:addChild( self.lilian_lable )

    -- 兑换按钮
    local function buy_but_callback( event_type )
        --if event_type == TOUCH_CLICK then
        -- if item_base.type and item_base.type == ItemConfig.ITEM_TYPE_WEAPON then
            Instruction:handleUIComponentClick( instruct_comps.EXCHANGE_WEAPON_BTN )
            Analyze:parse_click_main_menu_info(253)
        -- end
            ExchangeModel:show_buy_keyboard( item_id, level, price_value, category)
       -- end
        --return true;
    end

    --modified by zyz,old code
    -- self.buy_but = UIButton:create_button_with_name( 155, 7, 60, 31, UIResourcePath.FileLocate.common .. "button2_bg.png", UIResourcePath.FileLocate.common .. "button2_bg.png", nil, LangGameString[941], buy_but_callback ) -- [941]="兑换"
    --new code
        --self.buy_but = UIButton:create_button_with_name2(self.view, 153, 7, LangGameString[941], buy_but_callback ) -- [941]="兑换"
    local temp_button = ZTextButton:create( self.view,Lang.exchange.model[2] , UILH_COMMON.button4, buy_but_callback, 140, 13 )
    temp_button.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)
    
    if category == "equipment" then
        -- 检查是否已兑换过装备
        local if_be_equipment = ItemModel:check_if_body_use_item( item_id )     -- 是否是装备
       
        -- if ExchangeModel:chek_if_has_item( item_id ) and if_be_equipment then
        --     temp_button.view:setCurState(CLICK_STATE_DISABLE)
        --     return
        -- end

        temp_button:setCurState(CLICK_STATE_UP)
    end
end
