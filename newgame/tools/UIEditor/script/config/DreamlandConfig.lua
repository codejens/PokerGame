-- DreamlandConfig.lua
-- created by fjh on 2013-4-28
-- 梦境的配置

DreamlandConfig = {}


function DreamlandConfig:get_dreamland_items(  )
	require "../data/lottery"

	return lottery.displayItemList;
end

function DreamlandConfig:get_xy_big_items(  )
	require "../data/lottery"
	return {(lottery.displayItemList[1])[17],(lottery.displayItemList[1])[18]};
end

function DreamlandConfig:get_yh_big_items(  )
	require "../data/lottery"
	return {(lottery.displayItemList[2])[17],(lottery.displayItemList[2])[18]};
end

function DreamlandConfig:get_ry_big_items(  )
	require "../data/lottery"
	return {(lottery.displayItemList[3])[17],(lottery.displayItemList[3])[18]}
end

function DreamlandConfig:get_open_lv()
	require "../data/lottery"
	return lottery.openLevel
end

-- 获取淘宝树的配置
function DreamlandConfig:get_taobao_tree_items(  )
	require "../data/taobao_tree"
	return taobao_tree.displayItemList[1];
end

function DreamlandConfig:get_taobao_tree_big_items(  )
	require "../data/taobao_tree"
	return {taobao_tree.displayItemList[1][17],taobao_tree.displayItemList[1][18] }
end