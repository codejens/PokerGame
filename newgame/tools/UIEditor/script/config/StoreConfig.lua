-- StoreConfig.lua
-- created by lyl on 2012-1-5
-- 商城配置

-- super_class.StoreConfig()
StoreConfig = {}

StoreConfig.money_type = _static_money_type

-- 根据物品id， 获取商城某个物品的商城信息
function StoreConfig:get_store_info_by_id( item_id )
    require "../data/store"
    for i, store_class in ipairs(store) do
        for j, item in ipairs(store_class.items) do
            if item.item == item_id then
                return item
            end
        end
    end
    return nil
end

-- 根据id获取商城物品表示
function StoreConfig:get_item_tag_by_id( item_id )
    require "../data/store"
    local ret = nil
    local store_item = StoreConfig:get_store_info_by_id( item_id )
    if store_item then
        ret = store_item.id
    end
    return ret
end

-- 根据分类名称获取商城出售物品列表   hot  common  individuality stone pet  binding_gold  hide  limit  huanqing
function StoreConfig:get_item_list_by_category( category )
    require "../data/store"
    local key_to_index_t = { hot = 1, common = 2, individuality = 3, stone = 4, pet = 5, binding_gold = 6, hide = 7, limit = 8, huanqing = 9 }
    local index = key_to_index_t[ category ]
    return store[ index ].items
end

-- 根据分类和id，获取道具出售信息
function StoreConfig:get_sell_info_by_cate_id( item_id, category )
    local items = StoreConfig:get_item_list_by_category( category )
    if items then
        for key, item_info in pairs(items) do
            if item_info.item == item_id then
                return item_info
            end
        end
    end
    return nil
end

-- 根据商城物品id 获取 道具的商城信息
function StoreConfig:get_item_id_by_mall_id( mall_item_id )
    require "../data/store"
    for i, store_class in ipairs(store) do
        for j, item in ipairs(store_class.items) do
            if item.id == mall_item_id then
                return item
            end
        end
    end
    return nil
end

-- 根据分类获取该分类所有数据 hot  common  individuality stone pet  binding_gold  hide  limit
function StoreConfig:get_category_all_date( category )
    require "../data/store"
    local key_to_index_t = { hot = 1, common = 2, individuality = 3, stone = 4, pet = 5, binding_gold = 6, hide = 7, limit = 8 }
    local index = key_to_index_t[ category ]
    return store[ index ]
end