-- ShopSellPanel.lua
-- created by lyl on 2013-1-31
-- 出售一件物品的panel区域


super_class.ShopSellPanel(  ) 

require "config/StaticAttriType"

local _price_rate = 3    -- 价格倍数   写死
local _item_count = 1    -- 数量
local _width    = 195
local _height   = 96

-- sell_type : 商店出售shop_sell   回购back_sell,  
function ShopSellPanel:__init( item_id, sell_type )
    self.item_date = nil                  -- 本面板对应的动态数据。 如果是商店出售，可以为nil

    self.view = CCBasePanel:panelWithFile(0, 0, _width, _height, "")
    ZImage:create( self.view, UILH_COMMON.bg_10, 0, 0, _width-3, _height, nil, 500, 500 )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 
    end
    
    -- slot
    self.slot = SlotItem( 55, 55 )
    self.slot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -8, -8, 70, 70 )   -- 背框
    self.slot:setPosition( 15, 22 )
    self.slot:set_icon( item_id )
    self.view:addChild( self.slot.view )

    -- slot单击
    local function item_click_fun ()
        if sell_type == "shop_sell" then
            ShopModel:show_shop_tips( item_id )
        elseif sell_type == "back_sell" and self.item_date then
            ShopModel:show_shop_tips_with_date( self.item_date )
        end
    end
    self.slot:set_click_event(item_click_fun)

    -- 道具名称
    -- local name_bg = CCBasePanel:panelWithFile(86, _height - 26, _width, 23, UIResourcePath.FileLocate.common .. "chongzhi_bg.png", 500, 500)
    -- self.view:addChild( name_bg )

    local name_color = ShopModel:get_item_color( item_id )
    self.name = UILabel:create_lable_2( name_color..item_base.name, 84, 71, 14, ALIGN_LEFT )
    self.view:addChild( self.name )

    -- 价格
    if sell_type == "shop_sell" then
        _price_rate = 3
    elseif sell_type == "back_sell" then
        _price_rate = 1
    else
        _price_rate = 3
    end

    self.gold_bg = ZImage:create(self.view, "nopack/task/gold.png", 80, 40, 32, 32)
    self.prince_name = _static_money_type[ item_base.dealType ] or ""
    self.prince_value = item_base.dealPrice and  item_base.dealPrice * _price_rate  or ""
    self.price_lable = UILabel:create_lable_2( "#c00c0ff"..self.prince_value, 111, 49, 14, ALIGN_LEFT )
    self.view:addChild( self.price_lable )

    -- 购买按钮
    local function buy_but_callback( event_type )
        -- print("run buy_but_callback")
        -- if event_type == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            ShopModel:buy_item_from_shop( item_id )
        -- end
        return true;
    end
    -- 回购
    local function back_buy_but_callback( event_type )
        -- if event_type == TOUCH_CLICK then
            if self.item_date then
                ShopModel:sell_back_item( self.item_date.series )
            end
        -- end
        return true;
    end

    local image = UILH_COMMON.button5_nor
    if sell_type == "shop_sell" then
        -- self.buy_but = MUtils:create_common_btn( self.view,"购买",buy_but_callback, 80, 6 )
        self.buy_but = ZButton:create(self.view, image, buy_but_callback, 117, 10, 70, 32)
        local size = self.buy_but:getSize()
        MUtils:create_zxfont(self.buy_but, Lang.shop[23], size.width/2, size.height/2 - 6, 2, 16);
    elseif sell_type == "back_sell" then
        -- self.buy_but = MUtils:create_common_btn( self.view,"回购", back_buy_but_callback, 80, 6 )
        self.buy_but = ZButton:create(self.view, image, back_buy_but_callback, 117, 10, 70, 32)
        local size = self.buy_but:getSize()
        MUtils:create_zxfont(self.buy_but, Lang.shop[24], size.width/2, size.height/2 - 6, 2, 16);
    else
        -- self.buy_but = MUtils:create_common_btn( self.view,"购买",buy_but_callback, 80, 6 )
        self.buy_but = ZButton:create(self.view, image, buy_but_callback, 117, 10, 70, 32)
        local size = self.buy_but:getSize()
        MUtils:create_zxfont(self.buy_but, Lang.shop[23], size.width/2, size.height/2 - 6, 2, 16);
    end

end

-- 设置动态数据显示
function ShopSellPanel:set_date_tips( item_date )
    if item_date == nil then
        return 
    end
    -- self.icon_bg:setTexture( "ui/common/item_bg01.png" )   -- 背框
    self.slot:set_icon( item_date.item_id )
    self.slot:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
    self.slot:set_color_frame( item_date.item_id, -4, -4, 63, 63 )    -- 边框颜色
    self.slot:set_item_count( item_date.count )       -- 数量
    self.slot:set_strong_level( item_date.strong )    -- 强化等级
    self.slot:set_gem_level( item_date.item_id )      -- 宝石的等级

    local base_price = ShopModel:get_item_base_price( item_date.item_id )
    self.prince_value = base_price and  base_price * _price_rate * item_date.count or ""
    self.price_lable:setString( "#c66ff66"..self.prince_name ..":#c00c0ff"..self.prince_value )   

    self.item_date = item_date
end

-- 重置面板
function ShopSellPanel:init_sell_panel(  )
    if self.slot then
        self.slot:set_icon_texture("")
        self.slot.icon_bg:setTexture("")
        self.slot:set_lock( false )
        self.slot:set_color_frame( nil )
        self.slot:set_item_count( 0 )
        self.slot:set_strong_level( 0 ) 
        self.slot:set_gem_level( nil )

        self.name:setString("")
        self.price_lable:setString("")
        self.buy_but.view:setIsVisible( false )
        self.gold_bg.view:setIsVisible( false )
    end
    self.item_date = nil
end
