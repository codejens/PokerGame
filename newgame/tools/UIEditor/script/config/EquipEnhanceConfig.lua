-- EquipEnhanceConfig.lua
-- created by lyl on 2012-12-19
-- 物品炼制配置

-- super_class.EquipEnhanceConfig()

EquipEnhanceConfig = {}


-- 根据装备等级，获取强化需要的强化石id. 
function EquipEnhanceConfig:get_gem_id_for_forge( item_level )
	require "../data/equip_enhance_config"
	if equip_enhance_config.strengthenUseStone[ item_level + 1 ] == nil then
        print("there is no item for the level: " .. tostring(item_level))
	end
	return equip_enhance_config.strengthenUseStone[ item_level + 1 ]
end

-- 根据装备等级，获取强化需要的保护符id. 
function EquipEnhanceConfig:get_prot_id_for_forge( item_level )
	require "../data/equip_enhance_config"
	if equip_enhance_config["strengthenUseRune"][ item_level + 1 ] == nil then
        print("there is no item for the level: " .. tostring(item_level))
	end
	return equip_enhance_config["strengthenUseRune"][ item_level + 1 ]
end

-- 根据装备等级，获取装备强化需要的消耗
function EquipEnhanceConfig:get_forge_need_cost( item_level )
	require "../data/equip_enhance_config"
	if equip_enhance_config["strengthenCost"][ item_level + 1 ] == nil then
        print("there is no item for the level: " .. tostring(item_level))
	end
	return equip_enhance_config["strengthenCost"][ item_level + 1 ]
end

-- 根据装备等级，获取装备强化的成功率
function EquipEnhanceConfig:get_forge_succ_per( item_level )
	require "../data/equip_enhance_config"
	if equip_enhance_config["strengthenRate"][ item_level + 1 ] == nil then
        print("there is no item for the level: " .. tostring(item_level))
	end
	return equip_enhance_config["strengthenRate"][ item_level + 1 ]
end

-- 获取装备每个孔可镶嵌宝石的id表
function EquipEnhanceConfig:get_item_can_set_stone(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config["gemStones"]
end

-- 获取可以合成的道具id表
function EquipEnhanceConfig:get_can_mix_item_id(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config["mixItemId"]
end

-- 获取道具合成后的id表
function EquipEnhanceConfig:get_mix_result_item_id(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config["mixItemId2"]
end

-- 获取合成物品需要的金钱表
function EquipEnhanceConfig:get_mix_need_money(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config["mixMoney"]
end

-- 获取合成物品需要的数量表
function EquipEnhanceConfig:get_mix_need_num(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config["mixCount"]
end

-- 获取强化转移需要的金钱表
function EquipEnhanceConfig:get_shift_need_money(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config["strengthenShiftMoney"]
end

-- 获取升级表：子表包括需要等级，可升级物品id表，升级后物品id表，需要材料id表等
function EquipEnhanceConfig:get_upgrade_table( )
	require "../data/equip_enhance_config"
	return equip_enhance_config["upgrade"]
end


-- 获取强化等级加成 的最小强化等级
function EquipEnhanceConfig:get_strongLevels_min_level(  )
	require "../data/equip_enhance_config"
	local strongLevels = equip_enhance_config.strongLevels;
	local min_level = strongLevels[1].value;
	return min_level;
end
-- 获取强化等级加成 的最大强化等级
function EquipEnhanceConfig:get_strongLevels_max_level(  )
	require "../data/equip_enhance_config"
	local strongLevels = equip_enhance_config.strongLevels;
	local max_level = strongLevels[#strongLevels].value;
	return max_level;
end

-- 获得对应 职业，对应强化等级的强化加成
function EquipEnhanceConfig:get_strongLevels_by_level( strong_lv, job )
	
	local min_lv = EquipEnhanceConfig:get_strongLevels_min_level();
	
	if strong_lv >= min_lv then 
		print("EquipEnhanceConfig:get_strongLevels_by_level ",min_lv, strong_lv)
		local strongLevels = equip_enhance_config.strongLevels;
		
		local index = strong_lv - min_lv + 1;
		
		local strong = strongLevels[index];

		if strong.value == strong_lv then 
			
			local strong_attris = {};

			for i,attri in ipairs(strong.awards) do
				if attri.job == job then 
					strong_attris[attri.type] = attri.value;
				end	
			end

			return strong_attris;
		end
	end
	
end

-- 获取宝石等级加成 的最小宝石等级
function EquipEnhanceConfig:get_stoneLevels_min_level(  )
	require "../data/equip_enhance_config"
	local stoneLevels = equip_enhance_config.stoneLevels;
	local min_level = stoneLevels[1].value;
	return min_level;
end

-- 获取宝石等级加成 的最大宝石等级
function EquipEnhanceConfig:get_stoneLevels_max_level(  )
	require "../data/equip_enhance_config"
	local stoneLevels = equip_enhance_config.stoneLevels;
	local max_level = stoneLevels[#stoneLevels].value;
	return max_level;
end


-- 获取对应职业，对应宝石等级的宝石加成
function EquipEnhanceConfig:get_stoneLevels_by_level( stone_lv, job )
	
	local min_lv = EquipEnhanceConfig:get_stoneLevels_min_level();
	
	if stone_lv >= min_lv then
		local stoneLevels = equip_enhance_config.stoneLevels;
		
		local index = 1;
		if ( stone_lv - min_lv ) >= 100 then 
			index = 6;
		else
			index = Utils:getIntPart(( stone_lv - min_lv ) / 20) + 1;
		end
		print("宝石等级",stone_lv,index);

		local stone = stoneLevels[index];
		
		local stone_attris = {};
		
		for i,attri in ipairs(stone.awards) do
			if attri.job == job then 
				stone_attris[attri.type] = attri.value;
			end	
		end

		return stone.value, stone.effectName, stone_attris;
	end

	return nil; 

end

-- 取得可以提品的Items
function EquipEnhanceConfig:get_can_tp_items(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config.qualityEquipItem;
end

-- 取得提品需要的数据
function EquipEnhanceConfig:get_tp_info( item_type,item_pz_lv )
	-- 如果是武器
	if ( item_type == 1 or item_type == 4 or item_type == 6 or item_type == 7 or item_type == 8 ) then
		return equip_enhance_config.qualityAttackId,equip_enhance_config.qualityAttackMoney[item_pz_lv],equip_enhance_config.qualityAttackCount[item_pz_lv];
	else
		return equip_enhance_config.qualityDefenceId,equip_enhance_config.qualityDefenceMoney[item_pz_lv],equip_enhance_config.qualityDefenceCount[item_pz_lv]
	end
end

-- 取得可以升阶的items
function EquipEnhanceConfig:get_can_sj_items( item_config_index )
	require "../data/equip_enhance_config"
	return equip_enhance_config.stageEquipItem;
end

-- 取得提品需要的数据
function EquipEnhanceConfig:get_sj_info( item_config_index  )
	return equip_enhance_config.stageEquipItem2[item_config_index],
		equip_enhance_config.stageItemId[item_config_index],
		equip_enhance_config.stageCount[item_config_index],
		equip_enhance_config.stageMoney[item_config_index]

end

-- 获取 品质对强化数值加成的系数
function EquipEnhanceConfig:get_quality_addition_valua( quality )
	
	require "../data/equip_enhance_config"
	return equip_enhance_config.qualityStrengthenRate[quality];
	
end

-- 获取洗练的属性颜色
function EquipEnhanceConfig:get_attr_color( attr_type ,attr_value )
	require "../data/equip_enhance_config"
	local attr_table = equip_enhance_config.refreshAttrs;
	for i,v in ipairs(attr_table) do
		if ( v.type == attr_type ) then
			if ( attr_value > 0 ) then
				if ( attr_value > v.values[3][#v.values[3]] ) then
					return _static_quantity_color[5],true;
				elseif ( attr_value > v.values[2][#v.values[2]] ) then
					return _static_quantity_color[4],false
				elseif ( attr_value > v.values[1][#v.values[1]] ) then
					return _static_quantity_color[3],false
				else
					return _static_quantity_color[2],false
				end
			else
				if ( attr_value < v.values[3][#v.values[3]] ) then
					return _static_quantity_color[5],true
				elseif ( attr_value < v.values[2][#v.values[2]] ) then
					return _static_quantity_color[4],false
				elseif ( attr_value < v.values[1][#v.values[1]] ) then
					return _static_quantity_color[3],false
				else
					return _static_quantity_color[2],false
				end
			end
			break;
		end
	end
end

-- 获取洗练需要的金钱
function EquipEnhanceConfig:get_xl_need_money( lock_num )
	require "../data/equip_enhance_config"
	local lock_money = 0;
	if ( lock_num > 0 ) then
		lock_money = equip_enhance_config.lockMoney[lock_num]; 
	end
	return equip_enhance_config.refreshMoney + lock_money;
end

-- 获取洗练最大值
function EquipEnhanceConfig:get_xl_max_value( attr_type )
	require "../data/equip_enhance_config"
	for i, v in ipairs(equip_enhance_config.refreshAttrs) do
		if v.type == attr_type then
			return math.abs( v.values[4][1] );
		end
	end
	
end

-- 获取一级攻击宝石id
function EquipEnhanceConfig:get_1_level_atta_gem_id(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config.gemStones[1][1]
end

-- 获取一级防御（物防、法防）宝石id
function EquipEnhanceConfig:get_1_level_prot_gem_id(  )
	require "../data/equip_enhance_config"
	return {equip_enhance_config.gemStones[2][1], equip_enhance_config.gemStones[2][11]}
end

-- 获取一级生命宝石id
function EquipEnhanceConfig:get_1_level_life_gem_id(  )
	require "../data/equip_enhance_config"
	return equip_enhance_config.gemStones[3][1]
end

-- 根据宝石类型（1、2、3、4）和宝石等级获取镶嵌或升级宝石消耗的材料
function EquipEnhanceConfig:get_gem_meta_cost( type, level )
	require "../data/equip_enhance_config"
	return equip_enhance_config.gemConsumeMaterial[type][level]
end

-- 获取镶嵌或升级宝石消耗的金钱
function EquipEnhanceConfig:get_gem_money_cost( ... )
	require "../data/equip_enhance_config"
	return equip_enhance_config.insertMoney
end

-- 获取下一级宝石
function EquipEnhanceConfig:get_next_level_gem( gem_type, gem_level )
	require "../data/equip_enhance_config"
	if gem_level >= 10 then return nil end
	return equip_enhance_config.stoneLevelId[gem_type][gem_level+1]
end

-- 装备强化的最大祝福值
function EquipEnhanceConfig:get_max_wish_val( streng_level )
	-- require "../data/equip_enhance_config"
	-- return equip_enhance_config.strengMagicMax[streng_level] or 0
end

-- 祝福值倒计时
function EquipEnhanceConfig:get_wish_val_time(  )
	-- require "../data/equip_enhance_config"
	-- return equip_enhance_config.strengMagicClearTime
end