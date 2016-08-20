LingQiLingQuConfig = { expExplain = "1.仙术查克拉修炼是自动的;#r" .. "2.每次最大修炼上限为6小时;#r" .. "3.玩家可以通过不同方式来奖励;#r" .. "4.VIP玩家领取可以获得额外加成;" }

function LingQiLingQuConfig:get_info()
	require "../data/rootexp"
	return rootexp;
end

-- 获取灵气领取的道具ID(仙术丸、高级仙术丸)
function LingQiLingQuConfig:get_item_id_by_index( index )
	require "../data/rootexp"
	if rootexp.getType[index] then
		return rootexp.getType[index].itemId;
	end
end

-- 获取灵气领取说明
function LingQiLingQuConfig:get_ling_qu_explain()
	require "../data/rootexp"
	return LingQiLingQuConfig.expExplain;
end

-- 获取累计仙术查克拉丹计算系数
function LingQiLingQuConfig:getExpPerSecond()
	require "../data/rootexp"
	return rootexp.expPerSecond;
end

-- 获取最大累计修炼时长
function LingQiLingQuConfig:getMaxPracticeTime()
	require "../data/rootexp"
	return rootexp.maxPracticeTime;
end

-- 获取领取灵气需要消耗的忍币数
function LingQiLingQuConfig:getCostByIndex(index)
	require "../data/rootexp"
	if index >=1 and index <= 3 then
		return rootexp.getType[index].xbCost
	end
end

-- 获取灵气领取获得基本查克拉数
function LingQiLingQuConfig:getBaseChakelaNum()
	require "../data/rootexp"
	return rootexp.expPerTimes
end