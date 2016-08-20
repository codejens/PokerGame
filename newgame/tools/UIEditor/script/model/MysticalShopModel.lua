-- MysticalShopModel.lua  
-- created by lyl on 2013-3-21
-- 神秘商店系统

-- super_class.MysticalShopModel( )
MysticalShopModel = {}

--镇妖塔用到神秘商店 所以加类型 add by tjh 
MysticalShopModel.OLD_SHOP = 1   --以前副本中的神秘商店
MysticalShopModel.ZYT_SHOP = 5   --镇妖塔中的神秘商店 --因为老配置已经有4 安全起见我从5开始

local _curr_shop_type = MysticalShopModel.OLD_SHOP

local _win_name = nil --前置窗口
-- added by aXing on 2013-5-25
function MysticalShopModel:fini( ... )
	_curr_shop_type = MysticalShopModel.OLD_SHOP
	_win_name = nil
end

-- 更新神秘商店数据
function MysticalShopModel:update_win( update_type )
	require "UI/mysticalshop/MysticalShopWin"
	MysticalShopWin:update_win( update_type )
end

-- 获取 神秘商店的出售道具信息列表
function MysticalShopModel:get_sell_item_info_list(  )
	require "config/LiuDaoShopConfig"
	local ret_item_info_list = LiuDaoShopConfig:get_shop_item_list( _curr_shop_type )
    return ret_item_info_list
end

-- 获取颜色
function MysticalShopModel:get_item_color( item_id )
    require "model/ItemModel"
    return ItemModel:get_item_color( item_id )
end

-- 获取元宝数
function MysticalShopModel:get_player_yuanbao(  )
	local player = EntityManager:get_player_avatar()
	return player.yuanbao
end

-- 获取绑定元宝
function MysticalShopModel:get_player_bind_yuanbao(  )
	local player = EntityManager:get_player_avatar()
	return player.bindYuanbao	
end

-- 打开购买面板
function MysticalShopModel:show_buy_panel( item_info )
	if item_info == nil or item_info.item == nil then
        return 
	end
	require "UI/common/BuyKeyboardWin"
	BuyKeyboardWin:show( item_info.item, nil, 9, item_info.singleBuyLimit, {item_info, _curr_shop_type} )      -- 心魔幻境 神秘商店号是1
end

-- 打开神秘商店
function MysticalShopModel:show_win_and_set_npc_id(  )
	MysticalShopModel:open_shop_win_by_type(MysticalShopModel.OLD_SHOP )
end

--设置当前类型
function MysticalShopModel:set_curr_shop_type( type )
	_curr_shop_type = type
end

-- 按类型打开神秘商店
function MysticalShopModel:open_shop_win_by_type(type,win_name)
	-- 已经打开的情况下，重复请求打开就不去管
	local win = UIManager:find_visible_window("mystical_Shop_win")
	if win == nil then
		_curr_shop_type = type
		_win_name = win_name
		UIManager:show_window("mystical_Shop_win")
	end
end

--关闭神秘商店
function MysticalShopModel:close_shop_win()
	if _curr_shop_type == MysticalShopModel.ZYT_SHOP  then
		if _win_name then
			if _win_name == "zhenyaota_win" then
				ZhenYaoTaModel:show_window()
			else
				UIManager:show_window(_win_name)
			end
		end
	end

	-- 关闭窗口，重置数据
	_curr_shop_type = MysticalShopModel.OLD_SHOP
	_win_name = nil
end