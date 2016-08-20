--SuperGroupBuyConfig.lua
--作者：陈亮
--内容：超级团购活动的单体配置类
--时间：2014.08.15

--加载活动数据配置文件
require "../data/activity_config/GroupBuyGiftConfig"

--创建团购活动的配置对象
SuperGroupBuyConfig = {}

--功能：根据配置ID获取实惠礼包ID
--参数：configType		配置类型
--返回：t_cheapGiftId	实惠礼包ID
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getCheapGiftId(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取实惠礼包ID
	local t_cheapGiftId = t_dataConfig.cheapGiftId
	return t_cheapGiftId
end

--功能：根据配置ID获取超值礼包ID
--参数：configType		配置类型
--返回：t_superGiftId	超值礼包ID
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getSuperGiftId(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取超值礼包ID
	local t_superGiftId = t_dataConfig.superGiftId
	return t_superGiftId
end

--功能：根据配置ID获取积分礼包ID
--参数：configType		配置类型
--返回：t_pointGiftId	积分礼包ID
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getPointGiftId(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取积分礼包ID
	local t_pointGiftId = t_dataConfig.pointGiftId
	return t_pointGiftId
end

--功能：根据配置ID获取排行奖励组
--参数：configType		配置类型
--返回：t_awardGroup	排行奖励组
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getAwardGroup(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取排行奖励组
	local t_awardGroup = t_dataConfig.awardGroup
	return t_awardGroup
end

--功能：根据配置ID获取最大积分
--参数：configType		配置类型
--返回：t_maxPoint		最大积分
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getMaxPoint(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取最大积分
	local t_maxPoint = t_dataConfig.maxPoint
	return t_maxPoint
end

--功能：根据配置ID获取实惠礼包最大数量
--参数：configType		配置类型
--返回：t_cheapGiftMax	实惠礼包最大数量
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getCheapGiftMax(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取实惠礼包最大数量
	local t_cheapGiftMax = t_dataConfig.cheapGiftMax
	return t_cheapGiftMax
end

--功能：根据配置ID获取开启超值礼包购买的实惠礼包购买数
--参数：configType				配置类型
--返回：t_consumeCheapCount		开启超值礼包购买的实惠礼包购买数
--作者：陈亮
--时间：2014.09.09
function SuperGroupBuyConfig:getConsumeCheapCount(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取实惠礼包最大数量
	local t_consumeCheapCount = t_dataConfig.consumeCheapCount
	return t_consumeCheapCount
end

--功能：根据配置ID获取实惠礼包的单价元宝数量
--参数：configType		配置类型
--返回：t_cheapGold		实惠礼包的单价元宝数量
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getCheapGold(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取实惠礼包的单价元宝数量
	local t_cheapGold = t_dataConfig.cheapGold
	return t_cheapGold
end

--功能：根据配置ID获取超值礼包的单价元宝数量
--参数：configType		配置类型
--返回：t_superGold		超值礼包的单价元宝数量
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getSuperGold(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取超值礼包的单价元宝数量
	local t_superGold = t_dataConfig.superGold
	return t_superGold
end

--功能：根据配置ID获取实惠礼包购买内容
--参数：configType		配置类型
--返回：t_cheapContent	实惠礼包购买内容
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getCheapContent(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取实惠礼包购买内容
	local t_cheapContent = t_dataConfig.cheapContent
	return t_cheapContent
end

--功能：根据配置ID获取超值礼包购买内容
--参数：configType		配置类型
--返回：t_superContent	超值礼包购买内容
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getSuperContent(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取超值礼包购买内容
	local t_superContent = t_dataConfig.superContent
	return t_superContent
end

--功能：根据配置ID获取领取礼包内容
--参数：configType		配置类型
--返回：t_gainContent	领取礼包内容
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getGainContent(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取领取礼包内容
	local t_gainContent = t_dataConfig.gainContent
	return t_gainContent
end

--功能：根据配置ID获取元宝图片路径
--参数：configType			配置类型
--返回：t_moneyImagePath	元宝图片路径
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getMoneyImagePath(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取元宝图片路径
	local t_moneyImagePath = t_dataConfig.moneyImagePath
	return t_moneyImagePath
end

--功能：根据配置ID获取元宝图片大小
--参数：configType			配置类型
--返回：t_moneyImageSize	元宝图片大小
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyConfig:getMoneyImageSize(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取元宝图片大小
	local t_moneyImageSize = t_dataConfig.moneyImageSize
	return t_moneyImageSize
end

function SuperGroupBuyConfig:getMoneyNum(configType)
	--根据配置类型获取配置数据
	local t_dataConfig = GroupBuyGiftConfig[configType]
	--获取元宝图片大小
	local t_moneyNum = t_dataConfig.moneyNum
	return t_moneyNum
end

function SuperGroupBuyConfig:getConfigNewYear( act_id)
	return itemConfigNewYear[act_id]
end