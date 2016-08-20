-- GuildModel.lua
-- created by lyl on 2013-2-1
-- 仙宗管理器

-- super_class.ShopModel()
ShopModel = {}

local _had_sell_items_t = {}           -- 已出售给商店的物品集合。  一个元素是一个 动态数据  UserItem
local _had_sell_max     = 10            -- 最多存储几个（最多显示，可以回购的物品数）

local _sell_item_date_temp = nil       -- 记录当前出售的商品的数据， 因为出后以后不能在背包中找到，所以先记录。如果成功再放入_had_sell_items_t

-- added by aXing on 2013-5-25
function ShopModel:fini( ... )
    _had_sell_items_t = {}
    _had_sell_max     = 10 
end

-- =================================
-- 更新界面
-- ==================================
-- 更新商店
local function update_shop_win( update_type )
    require "UI/shop/ShopWin"
    ShopWin:update_shop_win( update_type )
end

-- 选择商店页面
local function change_shop_page( page_name )
    require "UI/shop/ShopWin"
    ShopWin:change_page( page_name )
end

-- =================================
-- 数据操作
-- =================================
-- 增加 刚出售到商店的物品  参数：一个动态数据
function ShopModel:add_sell_item( item_date )
	table.insert( _had_sell_items_t, 1, item_date )
	if #_had_sell_items_t > _had_sell_max then
        table.remove( _had_sell_items_t)
	end
    update_shop_win( "sell" )
end

-- 删除一件 刚出售到商店的物品。 
function ShopModel:remove_sell_item( item_series )
    for i = 1, #_had_sell_items_t do
        if _had_sell_items_t[i] and _had_sell_items_t[i].series == item_series then
            table.remove( _had_sell_items_t, i)
            break 
        end
    end
    update_shop_win( "sell" )
end

-- 获取  刚出售到商店的物品
function ShopModel:get_sell_item(  )
	return _had_sell_items_t
end

-- 通过排号，获取数据
function ShopModel:get_sell_item_by_index( index )
	return _had_sell_items_t[ index ]
end

-- 获取  刚出售到商店的物品  最大数
function ShopModel:get_had_sell_max(  )
	return _had_sell_max
end

-- 获取根据id，获取道具的基础价格
function ShopModel:get_item_base_price( item_id )
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 0
    end
    return item_base.dealPrice
end

-- 获取相应职业的出售物品  1:天雷  2:蜀山  3:圆月  4:云华  
function ShopModel:get_equip_id_by_job( job_index )
    require "config/NPCStoreConfig"
    local item_t = NPCStoreConfig:NPC_store_by_type( 2 )
    if item_t and item_t[job_index] then
        return item_t[job_index].items
    else
        return {}
    end
end

-- 获取玩家的职业  标签的关键字
function ShopModel:get_player_job(  )
    local player = EntityManager:get_player_avatar()
    local job_key = { "daoke", "gongshou", "qiangshi", "xianru" }
    if player and job_key[player.job] then
        return job_key[player.job]
    else
        return "daoke"
    end
end

-- =================================
-- 混合逻辑
-- =================================
-- 显示商店tips
function ShopModel:show_shop_tips( item_id )
    require "model/TipsModel"
    TipsModel:show_shop_tip( 200, 255, item_id, TipsModel.LAYOUT_RIGHT)
end

-- 显示包含动态数据的item的tips
function ShopModel:show_shop_tips_with_date( item_date )
    require "model/TipsModel"
    TipsModel:show_tip( 200, 255, item_date, nil, nil, false, "", "", TipsModel.LAYOUT_RIGHT)
end

-- 从商店购买
function ShopModel:buy_item_from_shop( item_id )
	require "UI/common/BuyKeyboardWin"
	-- local function cb_fun( num )
	-- 	require "control/NPCTradeCC"
	-- 	NPCTradeCC:req_buy_from_npc(item_id, num, 0)
	-- end
	BuyKeyboardWin:show( item_id, nil, 5, 99 )
end

-- 获取出售物品列表  drug 丹药   pet 宠物道具 
function ShopModel:get_item_list( item_type )
	require "config/NPCStoreConfig"
	local item_t = NPCStoreConfig:NPC_store_by_type( 1 )
	if item_type == "drug" then
		if item_t then
            return item_t[1].items
        else
        	return {}
        end
    elseif item_type == "pet" then
        if item_t then
            return item_t[2].items
        else
        	return {}
        end
	end
end

-- 背包拖动物品进入， 出售物品.  参数：拖动信息
function ShopModel:sell_user_item( source_item )
    local source_win = source_item.win      -- 源窗口的名称
    if source_win == "bag_win" then
    	if source_item.obj_data and source_item.obj_data.series then
            local item_base = ItemConfig:get_item_by_id( source_item.obj_data.item_id )
            -- print( "该物品不能出售。。。。。。。。。", item_base.flags.denySell )
    	    if not item_base.flags.denySell then
                _sell_item_date_temp = source_item.obj_data
                NPCTradeCC:req_sell_res_to_shop( source_item.obj_data.series )
            else 
                local show_content = Lang.shop[3] -- [3]="该物品不能出售"
                GlobalFunc:create_screen_notic( show_content, 20, 250, 230 )
            end
        end
        change_shop_page( "sell" )
    end

end

-- 出售物品
function ShopModel:request_sell_item( item_data )
    if item_data and item_data.series then
        require "control/NPCTradeCC"
        local item_base = ItemConfig:get_item_by_id( item_data.item_id )
        if not item_base.flags.denySell then
            _sell_item_date_temp = item_data
            NPCTradeCC:req_sell_res_to_shop( item_data.series )
        else 
            local show_content = Lang.shop[3] -- [3]="该物品不能出售"
            GlobalFunc:create_screen_notic( show_content, 20, 250, 230 )
        end
        -- ShopModel:add_sell_item( item_data )
    end
    change_shop_page( "sell" )
end

-- 出售物品成功
function ShopModel:sell_item_success( series )
    print( "出售物品成功。。。。",  series )
    local item_data = ItemModel:get_item_by_series( series )
    if series == _sell_item_date_temp.series then
        ShopModel:add_sell_item( _sell_item_date_temp )
    end
end

-- 回购刚出售的物品.  参数： _had_sell_items_t中的序列号
function ShopModel:sell_back_item( item_series )
    if item_series then
        require "control/NPCTradeCC"
        NPCTradeCC:req_buy_res_from_shop( item_series, 0 )
        ShopModel:remove_sell_item( item_series )
    end
end

-- 创建商店确认窗口的按钮
-- function ShopModel:create_shop_confirm_button( but_type , confirmWin)
--     if but_type == "close_comfirm" then
--         local but_1 = CCNGBtnMulTex:buttonWithFile( 45, 30, 60, 31, "ui/common/button2_bg.png", 500, 500)
--         but_1:addTexWithFile(CLICK_STATE_DOWN, "ui/common/button2_bg.png")
--         local function but_1_fun(eventType,x,y)
--             if eventType == TOUCH_CLICK then 
--                 confirmWin:close_win()
--             end
--         end
--         but_1:registerScriptHandler(but_1_fun) 
--         --按钮显示的名称
--         local label_but_1 = UILabel:create_label_1("关闭", CCSize(100,15), 64 , 18, 14, CCTextAlignmentLeft, 255, 255, 0)
--         but_1:addChild( label_but_1 ) 
--         return but_1
--     elseif but_type == "goto_vip" then
--         local but_1 = CCNGBtnMulTex:buttonWithFile( 150, 30, 90, 31, "ui/common/button2_bg.png", 500, 500)
--         but_1:addTexWithFile(CLICK_STATE_DOWN, "ui/common/button2_bg.png")
--         local function but_1_fun(eventType,x,y)
--             if eventType == TOUCH_CLICK then 
--                 print("  成为VIP  ")
--             end
--         end
--         but_1:registerScriptHandler(but_1_fun) 
--         --按钮显示的名称
--         local label_but_1 = UILabel:create_label_1("成为VIP", CCSize(100,15), 58 , 18, 14, CCTextAlignmentLeft, 255, 255, 0)
--         but_1:addChild( label_but_1 ) 
--         return but_1
--     end
-- end

-- 打开商店窗口  参数：打开的方式   bag  npc
function ShopModel:open_shop_win( open_place )
    if open_place == "bag" then
        require "model/VIPModel"
        local vip_info = VIPModel:get_vip_info()
        local expe_vip_time = VIPModel:get_expe_vip_time(  )
        if (vip_info and vip_info.level > 0) or expe_vip_time > 0 then
            UIManager:hide_window( "cangku_win" )
            UIManager:show_window( "shop_win")
        else
            confirm_word = Lang.bagInfo.vipshop --#cffff00VIP#cffffff玩家可立即打开商店
            local function confirm_func(  )
                --print("成为VIP")
                ActivityModel:open_vipSys_win(  )
            end
            ConfirmWin2:show( 3, 3, confirm_word, confirm_func )

            -- require "UI/common/ConfirmWin"
            -- local confirmWin = ConfirmWin( "", nil, notice_content, nil, nil, 450, nil)
            -- confirmWin.view:addChild( ShopModel:create_shop_confirm_button( "close_comfirm" , confirmWin) )
            -- confirmWin.view:addChild( ShopModel:create_shop_confirm_button( "goto_vip" , confirmWin) )

            local function btn_fun1()
                GlobalFunc:ask_npc( 11, Lang.shop[2] )
            end
            local function btn_fun2()
                GlobalFunc:teleport( 11, Lang.shop[2] ) -- [2] = "静音""
            end
            local dialog = ConfirmWin2:show( 6, nil, Lang.shop[4],  btn_fun1 )  -- [4] = "找到药品商店#r#cfff000VIP玩家可以使用远程商店功能"
            dialog:set_yes_but_func_2( btn_fun2 );
        end
    elseif open_place == "npc" then
        UIManager:hide_window( "shop_win" )
        UIManager:show_window( "cangku_win")
    end
end

-- 获取颜色
function ShopModel:get_item_color( item_id )
    require "model/ItemModel"
    return ItemModel:get_item_color( item_id )
end

-- 根据npc编号，显示商店（ 一般道具或者 武器）
function ShopModel:open_shop_by_npc_id( sold_id )
    -- print("  ShopModel:open_shop_by_npc_id````  ", sold_id )
    if sold_id == 12 then                        -- 药品商店
        UIManager:show_window( "shop_win" )
        change_shop_page( "drug" )
    elseif sold_id == 6 then                     -- 武器商店
        UIManager:show_window( "shop_win" )
        change_shop_page( ShopModel:get_player_job(  ) )
    else                 -- 神秘商店
        MysticalShopModel:open_shop_win_by_type(MysticalShopModel.OLD_SHOP)
    end
    EventSystem.postEvent('openNPCShop', sold_id)
end
