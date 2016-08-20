-- filename: ShopWin.lua
-- author: created by fanglilian on 2012-12-22
-- function: 该文件用于显示商店界面

super_class.ShopWin(NormalStyleWindow);

require "UI/shop/ShopItemList"

local _sell_list_pnale = nil    -- 右侧物品列表面板

-- 提供外部更新商店窗口
function ShopWin:update_shop_win( update_type )
    local win = UIManager:find_visible_window( "shop_win" )
    if win ~= nil then
        win:update( update_type )
    end
end

-- 更新
function ShopWin:update( update_type )
    if update_type == "sell" then
        self:update_list( update_type )
    end
end

-- 更新列表
function ShopWin:update_list( update_type )
    _sell_list_pnale:update( update_type )
end

-- 切换列表 drug   pet    sell  tianlei shushan yuanyue yunhua    外部调用
function ShopWin:change_page( page_name )
    -- print("  ShopWin:change_page ....  ", page_name)
    local win = UIManager:find_visible_window( "shop_win" )
    if win == nil then
        return
    end

    --出售情况下，两个都有，这里两个都切换。 具体显示哪个看是否显示
    if page_name == "sell" then
        if win.raido_btn_group_item then
            win.raido_btn_group_item:selectItem( 2 )
        end
        if win.raido_btn_group_equip then
            win.raido_btn_group_equip:selectItem( 1 ) 
        end
    end

    -- 设置选中标签
    if page_name == "drug" or page_name == "pet" then
        local page_index_t = { drug = 1, pet = 2, sell = 3 }      -- 每个名称对应的页号
        win:change_to_item_store(  )
        win.raido_btn_group_item:selectItem( page_index_t[page_name] - 1)
    end
	--暂时屏蔽装备shop的标签 by hwl
    if page_name == "daoke" or page_name == "gongshou" or page_name == "qiangshi" or page_name == "xianru" then
        win:change_to_equip_store(  )
        local page_index_t = { daoke = 1, gongshou = 1, qiangshi = 1, xianru = 1, sell = 2 }      -- 每个名称对应的页号
        win.raido_btn_group_equip:selectItem( page_index_t[page_name] - 1) 
    end

    _sell_list_pnale:Choose_panel( page_name )
end

-- 普通商店
function ShopWin:change_to_item_store(  )
    -- print("ShopWin:change_to_item_store  ````````` ")
    if self.raido_btn_group_equip then
        self.raido_btn_group_equip:setIsVisible(false)
    end

    if self.raido_btn_group_item == nil then
        -- 侧面所有按钮
        local but_beg_x = 15          --按钮起始x坐标
        local but_beg_y = 513         --按钮起始y坐标
        local but_int_x = 103         --按钮x坐标间隔

        self.raido_btn_group_item = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, but_beg_y, but_int_x*3, 45,nil)
        self.view:addChild( self.raido_btn_group_item )

        self:create_a_button(self.raido_btn_group_item, 2, 1, 101, 45, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light,
            Lang.shop[25],
            25, 19, -1, -1, "drug")

        self:create_a_button(self.raido_btn_group_item, 2 + but_int_x,  0, 101, 45, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light, 
            Lang.shop[26], 
            25, 19, -1, -1, "pet")

        -- 不需要回购
        self:create_a_button(self.raido_btn_group_item, 2 + but_int_x * 2, 0, 101, 45, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light, 
            Lang.shop[27], 
            8, 8, 23, 70, "sell")
    end
    self.raido_btn_group_item:setIsVisible(true)

    _sell_list_pnale:Choose_panel( "drug" )
end

-- 转成武器商店 
function ShopWin:change_to_equip_store(  )
    -- print("ShopWin:change_to_equip_store  ````````` ")
    if self.raido_btn_group_item then
        self.raido_btn_group_item:setIsVisible(false)
    end

    local job_type = ShopModel:get_player_job(  )   -- tianlei shushan yuanyue yunhua  

    if self.raido_btn_group_equip == nil then
        -- 侧面所有按钮
        local but_beg_x = 10           --按钮起始x坐标
        local but_beg_y = 513         --按钮起始y坐标
        local but_int_x = 103         --按钮y坐标间隔

        self.raido_btn_group_equip = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, but_beg_y, but_int_x*3, 45,nil)
        self.view:addChild( self.raido_btn_group_equip )

        self:create_a_button(self.raido_btn_group_equip, 2, 1, 101, 45, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light,
            Lang.shop[28],
            25, 19, -1, -1, job_type)

        self:create_a_button(self.raido_btn_group_equip, 2 + but_int_x, 0, 101, 45, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light, 
            Lang.shop[27], 
            8, 8, 23, 70, "sell")
    end
    
    self.raido_btn_group_equip:setIsVisible(true)
    -- parent:addChild(child)
    _sell_list_pnale:Choose_panel( job_type )  -- 默认列表

end

-- 标签选项
function ShopWin:create_a_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_x, but_name_y, but_name_siz_w, but_name_siz_h, index )
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            -- 根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)

    --按钮显示的名称
    -- local name_image = CCZXImage:imageWithFile( but_name_x, but_name_y, but_name_siz_w, but_name_siz_h, but_name ); 
    -- radio_button:addChild( name_image )
    local label_temp = UILabel:create_lable_2( but_name, 15, 12, 16 )
    radio_button:addChild(label_temp)

end
-- 商店界面初始化ShopItemList
function ShopWin:__init( window_name, texture_name )

    --商品列表底色
    local bg_liebiao = ZImage:create(self.view, 
        UILH_COMMON.normal_bg_v2, 
        8, 15, 425, 505, 1, 500, 500)
 
    -- 创建出售商品列表
    _sell_list_pnale = ShopItemList:create(  )
    _sell_list_pnale:setPosition(15, 22)
    self.view:addChild( _sell_list_pnale.view,2 )

end
function ShopWin:active( show )
    --137,345
    -- 新手指引 商店指引代码 -- 如果当前是在进行商店指引
    if ( XSZYManager:get_state() == XSZYConfig.SHANG_DIAN_ZY ) then
        if ( show ) then
            -- 箭头指向 中级仙露的购买按钮处
            XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.SHANG_DIAN_ZY,1 ,XSZYConfig.OTHER_SELECT_TAG);
        else
            XSZYManager:destroy(XSZYConfig.OTHER_SELECT_TAG);
            -- 显示药品提示对话框
            --UIManager:show_window("yp_dialog");
        end
    end
end
    
function ShopWin:destroy(  )
    -----------HJH
    -----------2013-3-18
    -----------补上DESTROY方法
    Window.destroy(self)
    if _sell_list_pnale then
        _sell_list_pnale:destroy()
    end
end