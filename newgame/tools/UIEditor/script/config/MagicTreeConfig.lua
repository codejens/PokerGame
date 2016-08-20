-- MagicTreeConfig.lua
-- created by chj on 2015-3-16
-- 昆仑神树配置

-- super_class.DjConfig()
MagicTreeConfig = {}


function MagicTreeConfig:get_conf( )
	require "../data/magictree_config"
	return magictree_config;
end

-- 获取果实位置
function MagicTreeConfig:get_fruit_position( )
	require "../data/magictree_config"
	return magictree_config.fruit_pos
end

-- 获取成熟度(总)
function MagicTreeConfig:get_magictree_maturity( )
	require "../data/magictree_config"
	return magictree_config.maturity
end

-- 获取宝箱图片
function MagicTreeConfig:get_magictree_boximg( )
	require "../data/magictree_config"
	return magictree_config.cangku_t.box_img
end

-- 获取宝箱道具展示图片
function MagicTreeConfig:get_magictree_itemimg( )
	require "../data/magictree_config"
	return magictree_config.cangku_t.item_img
end

-- 获取宝箱积分提示
function MagicTreeConfig:get_magictree_item_lable( )
	require "../data/magictree_config"
	return magictree_config.cangku_t.cost_point_lb
end

-- 获取宝箱名称
function MagicTreeConfig:get_magictree_box_name( )
	require "../data/magictree_config"
	return magictree_config.cangku_t.box_name
end

-- 获取宝箱ID
function MagicTreeConfig:get_magictree_box_id( )
	require "../data/magictree_config"
	return magictree_config.cangku_t.box_id
end

-- 获取一键成熟消耗元宝
function MagicTreeConfig:get_yb_mature_once( )
	require "../data/magictree_config"
	return magictree_config.yb_mature_once
end


-- ============================================
-- 客户端配置和服务器配置分割线 ------------
-- ============================================


function MagicTreeConfig:get_cost_type( cost_index)
	require "../data/magictreeconf"
	local _moneyType = magictreeconf.moneyType
	return _moneyType[cost_index]
end

-- 开启果实需要消耗的元宝
function MagicTreeConfig:get_cost_for_fruit( fruit_index) 
	require "../data/magictreeconf"
	local _useItemCost = magictreeconf.useItemCost
	local _fruitcost = _useItemCost[fruit_index]
	-- 铜币~元宝
	print("---------------------", _fruitcost[1])
	local _costtype = MagicTreeConfig:get_cost_type( _fruitcost[1])
	local _costnum = _fruitcost[2]
	return _costnum .. _costtype
end

-- 获取果实item_id 表(tabel)
function MagicTreeConfig:get_fruit_item_tabel()
	require "../data/magictreeconf"
	return magictreeconf.useItem
end