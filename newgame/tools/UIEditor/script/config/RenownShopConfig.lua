-- RenownShopConfig.lua
-- created by lyl on 2013-2-19
-- 兑换配置

-- super_class.RenownShopConfig()

RenownShopConfig = {}

-- 获取兑换，某个分类的信息  equipment,  material  glory
function RenownShopConfig:get_category_info( category )
	require "../data/renown_shop_config"
	-- local key_to_index_t = { equipment = 1,  material = 2, glory = 3 }
	local index = ExchangeModel.category_to_group_id[ category ]
	if index then
        return renown_shop_config[ index ]
	end
	return nil
end

-- 获取兑换，某个分类的道具信息  equipment,  material  glory
function RenownShopConfig:get_category_item( category )
	local category_info = RenownShopConfig:get_category_info( category )
	if category_info then
        return category_info.secClasses[1].items
	end
	return {}
end

-- 根据id获取某个道具的兑换信息
function RenownShopConfig:get_item_info_by_id( item_id, category )
	require "../data/renown_shop_config"
	category = category or ""
	local category_info_temp = RenownShopConfig:get_category_info( category )
    if category_info_temp then 
    	for k, item in pairs(category_info_temp.secClasses[1].items) do
            if item.itemID == item_id then
                return item
            end
        end
        return nil
    end

    -- 在没有传入category情况下，遍历所有类
	for key1, category in pairs(renown_shop_config) do
        for key2, item in pairs(category.secClasses[1].items) do
            if item.itemID == item_id then
                return item
            end
        end
	end
	return nil
end

-- 根据道具id，获取道具的组号id
function RenownShopConfig:get_groud_id_by_item_id( item_id )
	require "../data/renown_shop_config"
	for i = 1, #renown_shop_config do
        for key, item in pairs(renown_shop_config[i].secClasses[1].items) do
            if item.itemID == item_id then
                return i
            end
        end
	end
	return 0
end