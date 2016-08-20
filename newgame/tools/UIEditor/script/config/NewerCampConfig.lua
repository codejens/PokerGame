-- 新手体验副本配置读取文件
NewerCampConfig = {}

-- 根据进度值读取基本配置
function NewerCampConfig:get_progress_config(progress)
	require "../data/newercamp"
	return newercamp["progress"][progress]
end

-- 根据技能id,读取特效配置
function NewerCampConfig:get_effect_by_skill_id(skill_id)
	require "../data/newercamp"
	return newercamp["skill_effect"][skill_id]
end

function NewerCampConfig:get_pos_by_quest_id(quest_id)
	require "../data/newercamp"
	local quest = newercamp["quest"]

	for k,v in pairs(quest) do
		if k == quest_id then
			return v.mapx1, v.mapy1
		end
	end
end

function NewerCampConfig:get_pet_config_by_index(index)
	require "../data/newercamp"
	return newercamp["pet_list"][index]
end

function NewerCampConfig:get_pet_entity_by_index(index)
	require "../data/newercamp"
	return newercamp["pet_entity"][index]
end

function NewerCampConfig:get_pet_list()
	require "../data/newercamp"
	return newercamp["pet_list"]
end

-- 读取主角对怪物使用技能的伤害值
function NewerCampConfig:get_hero_damage_by_skill_id(skill_id)
	require "../data/newercamp"
	local hero_damage = newercamp["damage"].hero
	return hero_damage[skill_id] or 357
end

-- 读取宠物对怪物使用技能的伤害值
function NewerCampConfig:get_pet_damage_by_skill_id(skill_id)
	require "../data/newercamp"
	local pet_damage = newercamp["damage"].pet
	return pet_damage[skill_id]
end

-- 根据步骤id,获取需要在新手体验副本中播放的动画id
function NewerCampConfig:get_movie_id_by_progress(progress)
	require "../data/newercamp"
	local movie = newercamp["movie"][progress]
	if movie then
		return movie.id
	end
end

-- 读取式神翅膀配置
function NewerCampConfig:get_shishen_wing_value()
	require "../data/newercamp"
	return newercamp.shishen_wing_id or 0
end

-- 读取玩家在新手体验副本中的出生点坐标
function NewerCampConfig:get_born_position()
	require "../data/newercamp"
	return newercamp.born_position
end

-- 获取玩家在新手副本中,添加翅膀、宠物后,增加的攻击输出
function NewerCampConfig:get_extra_damage_by_wing()
	require "../data/newercamp"
	local damage = newercamp['damage']
	local result = 0
	if type(damage) == 'table' and type(damage.extra) == 'table' then
		result = damage.extra.wing or 0
	end
	return result
end

-- 获取玩家在新手副本中,添加翅膀、宠物后,增加的攻击输出
function NewerCampConfig:get_extra_damage_by_pet()
	require "../data/newercamp"
	local damage = newercamp['damage']
	local result = 0
	if type(damage) == 'table' and type(damage.extra) == 'table' then
		result = damage.extra.pet or 0
	end
	return result
end

-- 获取玩家在新手副本中每一步需要移动的点
function NewerCampConfig:get_move_pos_by_id(id)
	require "../data/newercamp"
	return newercamp['move_pos'][id]
end