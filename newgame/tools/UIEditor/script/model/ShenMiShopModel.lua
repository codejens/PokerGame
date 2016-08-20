-- ZiZiZhuJiModel.lua
-- created by liuguowang on 2014-4-10
-- 招财进宝信息模型 动态数据

-- super_class.ZiZiZhuJiModel()
ShenMiShopModel = {}

local _remain_time  -- 活动剩下的时间
local _next_shua_time   -- 下一次刷新的时间
local _remain_shua_count   -- 剩余刷新次数
local _item_count   -- 物品数量
local _item_list    --物品列表
local _xiaohao_yuanbao  --消费元宝
local _select = false

-- added by aXIng on 2013-5-25
function ShenMiShopModel:fini( ... )
	_remain_time = 0
	_next_shua_time = 0
	_remain_shua_count = 0
	_item_count = 0
	_item_list={}
end
-- 设置商店信息
function ShenMiShopModel:set_shop_data( remain_time,next_shua_time,remain_shua_count,item_count)
	_remain_time = remain_time
	_next_shua_time = next_shua_time
	if remain_shua_count<0 then
		_remain_shua_count = 0 
	else
		_remain_shua_count = remain_shua_count
	end
	_item_count = item_count
end

-- 获取商店信息
function ShenMiShopModel:get_shop_data()
	return _remain_time,_next_shua_time,_remain_shua_count,_item_count
end

function ShenMiShopModel:set_item_list( item_list )
	_item_list = item_list
end

function ShenMiShopModel:get_item_list(  )
	return _item_list
end

function ShenMiShopModel:set_next_shua_time( next_shua_time )
	_next_shua_time = next_shua_time
end

function ShenMiShopModel:get_next_shua_time(  )
	return _next_shua_time
end

function ShenMiShopModel:get_remain_shua_count(  )
	return _remain_shua_count
end

function ShenMiShopModel:set_xiaohao_yuanbao( xiaohao_yuanbao )
	_xiaohao_yuanbao = xiaohao_yuanbao
end

function ShenMiShopModel:get_xiaohao_yuanbao(  )
	return _xiaohao_yuanbao
end

-- 提供外部静态调用的更新窗口方法
function ShenMiShopModel:update_yuanbao(  )
    local win = UIManager:find_visible_window("shenmi_shop_win")
    if win then
    	win:update_yuanbao()
        
    end
end

function ShenMiShopModel:set_select( select )
	_select = select
end

function ShenMiShopModel:get_select(  )
	return _select
end



