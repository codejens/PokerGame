-- LiuDaoShopConfig.lua
-- created by lyl on 2013-3-21
-- 神秘商店配置


-- super_class.LiuDaoShopConfig()
LiuDaoShopConfig = {}


-- 根据序好获取神秘商店信息
function LiuDaoShopConfig:get_shop_info_by_index( index )
	require "../data/liudaoshop"
	local shop_info = {}
	if liudaoshop[ index ] then
        shop_info = liudaoshop[ index ]
	end
	return shop_info
end

-- 根据序号获取神秘商店出售的物品信息列表
function LiuDaoShopConfig:get_shop_item_list( index )
	local ret_item_info_list = {}
	local shop_info = LiuDaoShopConfig:get_shop_info_by_index( index ) 
	if shop_info.items then
        ret_item_info_list = shop_info.items
	end
	return ret_item_info_list
end