-- ElfinConfig.lua
-- create by yongrui.liang at 2014-8-29
-- 式神配置

require "../data/spirits"

ElfinConfig = {}

-- 式神开启等级
function ElfinConfig:getElfinOpenLevel( )
	return spirits.levelLimit
end

-- 式神
function ElfinConfig:getElfinModel( modelID )
	local model = spirits.model
	for k,v in pairs(model) do
		if v.modelId == modelID then
			return v
		end
	end
end

-- 式神名称
function ElfinConfig:getModelNameById( modelID )
	local model = spirits.model
	for k,v in pairs(model) do
		if v.modelId == modelID then
			return v.name
		end
	end
	return ""
end

-- 式神最低等级
function ElfinConfig:getModelMinLevelById( modelID )
	local model = ElfinConfig:getElfinModel(modelID)
	return model.minlevel
end

-- 式神最高等级
function ElfinConfig:getModelMaxLevelById( modelID )
	local model = ElfinConfig:getElfinModel(modelID)
	return model.maxlevel
end

-- 式神个数
function ElfinConfig:getElfinModelNum( )
	local models = spirits.model
	return #models
end

-- 式神属性
function ElfinConfig:getElfinBaseAttrs( level )
	return spirits.baseAttrs[level]
end

-- 升级所需经验
function ElfinConfig:getLevelUpExp( level )
	return spirits.levelUpExp[level]
end

-- 升级物品
function ElfinConfig:getLevelUpNeedItems( )
	local itemIds = {}
	local items = spirits.levelUpItem
	for i,v in ipairs(items) do
		itemIds[i] = v.itemId
	end
	return itemIds
end

-- 式神装备框开启等级（式神等级）
function ElfinConfig:getEquipSlotOpenLevel( )
	return spirits.equipSlotLevelLimit
end

-- 装备属性类型
function ElfinConfig:getEquipAttrsType( )
	return spirits.equipAttrsType
end

-- 装备
function ElfinConfig:getEquipItems( )
	return spirits.equipItem
end

-- 装备
function ElfinConfig:getEquipItemByType( typeID )
	local items = ElfinConfig:getEquipItems()
	for k,v in pairs(items) do
		if v.type == typeID then
			return v
		end
	end
	return nil
end

-- 装备属性名称
function ElfinConfig:getEquipAttrName( typeID )
	local item = ElfinConfig:getEquipItemByType(typeID)
	return item.Attrsname
end

-- 装备是否可穿戴
function ElfinConfig:getEquipmentCanEquipByType( typeID )
	local item = ElfinConfig:getEquipItemByType(typeID)
	return item.isEquip
end

-- 装备图标
function ElfinConfig:getEquipIconByType( typeID )
	local item = ElfinConfig:getEquipItemByType(typeID)
	return item.icon
end

-- 装备名称
function ElfinConfig:getEquipNameByType( typeID )
	local item = ElfinConfig:getEquipItemByType(typeID)
	return item.name
end

function ElfinConfig:getEquipDesByType( typeID )
	local item = ElfinConfig:getEquipItemByType(typeID)
	return item.des
end

function ElfinConfig:getEquipItemsType( )
	local itemsType = {}
	local items = ElfinConfig:getEquipItems()
	for i,v in ipairs(items) do
		itemsType[i] = v.type
	end
	return itemsType
end

-- 某件装备
function ElfinConfig:getEquip( typeID, qlty )
	return spirits.equip[typeID][qlty]
end

-- 某件装备最大等级
function ElfinConfig:getEquipMaxLevel( typeID, qlty )
	local equip = ElfinConfig:getEquip(typeID, qlty)
	return #equip.levelUpExp + 1
end

-- 式件装备初始熔炼值
function ElfinConfig:getEquipBaseSmelt( typeID, qlty )

	local equip = ElfinConfig:getEquip(typeID, qlty)
	
	return equip.baseExp
end

-- 某件装备升级所需熔炼值
function ElfinConfig:getEquipLvUpSmelt( typeID, qlty, level )
	local equip = ElfinConfig:getEquip(typeID, qlty)
	return equip.levelUpExp[level]
end

-- 根据某件装备等级获取熔炼值
function ElfinConfig:getEquipSmeltByLevel( typeID, qlty, level )
	local equip = ElfinConfig:getEquip(typeID, qlty)
	local baseSmelt = ElfinConfig:getEquipBaseSmelt(typeID, qlty)
	local smelt = baseSmelt
	for i=1,level-1 do
		smelt = smelt + equip.levelUpExp[i]
	end
	return smelt
end

-- 某件装备升级所需忍币
function ElfinConfig:getEquipLvUpMoney( typeID, qlty, level )
	local equip = ElfinConfig:getEquip(typeID, qlty)
	return equip.levelUpMoney[level]
end

-- 装备属性值
function ElfinConfig:getEquipAttrVal( typeID, qlty, level )
	local equip = ElfinConfig:getEquip(typeID, qlty)
	return equip.levelAttrs[level]
end

-- 黄金宝箱VIP等级
function ElfinConfig:getGoldBoxVipLimit( )
	return spirits.hjbxVipLimit
end

-- 黄金宝箱费用(元宝/绑元)
function ElfinConfig:getGoldBoxOpenCost( )
	return spirits.hjbxOpenCost
end

-- 黄金宝箱每天召唤次数上限
function ElfinConfig:getGoldBoxMaxOpenTimes( )
	return spirits.hjbxOpenTimes
end

-- 青铜秘匙物品id
function ElfinConfig:getBronzeKeyItemId( )
	return spirits.qtbxKeyItem
end

-- 探险
function ElfinConfig:getExploreByType( exploreType )
	return spirits.explore[exploreType]
end

-- 战力开启限制
function ElfinConfig:getExploreFightLimit( exploreType )
	return spirits.exploreFightLimit[exploreType]
end

-- 增加探险时间所需元宝(第几次)
function ElfinConfig:getExpendExploreTimeCost( times )
	if times > #spirits.addExploreTimeMoney then
		times = #spirits.addExploreTimeMoney
	end
	return spirits.addExploreTimeMoney[times]
end

-- 增加一次多少时间
function ElfinConfig:getAddExploreTimeOnce( )
	return spirits.addExploreTime
end

-- 品质对应颜色框
function ElfinConfig:getColorFrameImgByQlty( qlty )
	local texture_t = {UIResourcePath.FileLocate.lh_normal .. "item_frame_1.png",
    				 UIResourcePath.FileLocate.lh_normal .. "item_frame_2.png",
    				 UIResourcePath.FileLocate.lh_normal .. "item_frame_3.png", 
                     UIResourcePath.FileLocate.lh_normal .. "item_frame_4.png",
                     UIResourcePath.FileLocate.lh_normal .. "item_frame_5.png",
                     UIResourcePath.FileLocate.lh_normal .. "item_frame_6.png"}
    return texture_t[qlty]
end
--获取百年玄晶的熔炼值
function ElfinConfig:get_bnxj_equip_smelt(  )
	return spirits.bnxjExp
end

-- 装备奖励频率：秒/次	
function ElfinConfig:getEquipAwardTime( exploreType )
	local explore = ElfinConfig:getExploreByType(exploreType)
	return explore.equipAwardTime
end

-- 最大探险时间
function ElfinConfig:getMaxExploreTime( )
	return spirits.maxExploreTime
end

-- 探险奖励时长
function ElfinConfig:getExpAwardTime( exploreType )
	local explore = ElfinConfig:getExploreByType(exploreType)
	return explore.expAwardTime
end
