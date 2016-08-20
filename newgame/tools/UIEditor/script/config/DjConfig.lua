-- DjConfig.lua
-- created by hcl on 2013-1-25
-- 渡劫配置

-- super_class.DjConfig()
DjConfig = {}

------------例子
-- {
-- 	fbId = 9,	--副本id
-- 	scene = 1001,	--场景id
-- 	name = Lang.Title.name001,  --显示信息
-- 	posX = 21, --出生点坐标
-- 	posY = 13, --出生点坐标
-- 	level = 20,	--需要玩家等级
-- 	propertyId = 17, --奖励增加那个属性值(根据代码的PROP_CREATURE_BASE_MAXHP类型配置,策划需要和程序商量)
-- 	propertyValue = 180,--奖励属性值多少
-- 	titleId = 1,--奖励称号id
-- 	attackPower = 500, --推荐战斗力
-- 	gameTime = 600,	--游戏时间，单位S
-- 	fubenTime = 0, --副本结束时间 ，单位S
-- 	noStarTime = 0, --无评价剩余时间，单位S
-- 	oneStarTime = 30,--1星剩余时间，单位S
-- 	twoStarTime = 60, --2星剩余时间,单位S
-- 	threeStarTime = 90, --3星剩余时间，单位S
-- 	achieveEventId = 83, --获取成就事件ID
-- },



function DjConfig:get_dj_config_by_index( index )
	require "../data/djConfig"
	return djConfig[index];
end