-- BagModel.lua 
-- created by lyl on 2015-4-28
-- 背包数据存储


BagModel = {}

-- 存储背包道具数据.  中间可能有nil (table类型, list结构)
local _item_list_t = nil 

function BagModel:init(  )
	
end

function BagModel:fini(  )
	
end

-- 获取背包道具列表
function BagModel:get_item_list_t(  )
 	return _item_list_t
end 

--- 根据序号获取道具   item_index: 道具序号
function BagModel:get_item_by_index( item_index )
	local userItem = _item_list_t[ item_index ]
	return userItem
end

function BagModel:get_item_list_t_by_index( index )
    local element = _item_list_t[ index ]
    return element
end

-- 设置道具列表
function BagModel:set_item_list_t( item_list_t )
	_item_list_t = item_list_t
end

function BagModel:set_item_list_t_by_index( index, value )
    _item_list_t[ index ] = value
end

function BagModel:add_item_list_t_element( value, index )
    if index then 
        table.insert( _item_list_t, value, index )
    else 
        table.insert( _item_list_t, value ) 
    end 
end

function BagModel:remove_item_list_t_by_index( index )
    table.remove( _item_list_t, index )
end