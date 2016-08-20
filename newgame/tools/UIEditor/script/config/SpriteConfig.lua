-- SpriteConfig.lua
-- created by mwy on 2014-5-13
-- 精灵配置
require "../data/spirits_equip"
require "../data/spirits_lv"
require "../data/spirits_skill"
require "../data/spirits_stages"
require "../data/spirits_rebirth"

SpriteConfig = {};

-- 根据轮回等级获取相关信息
function SpriteConfig:get_sprite_data_by_rebirthLv(rebirth_level)
	-- print("SpriteConfig:get_sprite_data_by_rebirthLv(rebirth_level)",rebirth_level)
	local sprite =spirits_rebirth[tonumber(rebirth_level)];
	if sprite == nil then
		print("There is not this sprite: " .. rebirth_level);
	end
	return sprite;
end

-- 获取精灵等阶信息配置
-- stage:		精灵的等阶
-- star_level:	精灵升星等级
function SpriteConfig:get_spirits_stages( stage, star_level )
	-- ZXLog("-------------get_spirits_stages---------------",stage,star_level)
	local stage_model = spirits_stages.stages[stage];
	local sprite = {baseAttrs = stage_model.starAttrs[star_level] };
	return sprite;
end

-- 获取装备属性配置
-- equip_id:	 装备id
-- avatar_level：装备等级
function SpriteConfig:get_spirits_equip( equip_id,equip_level )
	local equip = spirits_equip.equip[equip_id];
	local equip_model = {name = equip.name,type=equip.type, addRate = equip.addRate[avatar_level] };
	return equip_model;
end

-- 按精灵等级获取升级属性
function SpriteConfig:get_spirits_level( sprite_level )
	local level = spirits_lv.level[sprite_level];
	local level_model = {upExp = level.upExp, baseAttrs = level.baseAttrs};
	return level_model;
end
-- 精灵轮回
-- 第N转的配置
function SpriteConfig:get_spirits_rebirth( rebirth_level ,star_level)
	local rebirth = spirits_rebirth.rebirth[rebirth_level];
	local rebirth_model = {maxEquipLevel = rebirth.maxEquipLevel, xbCost = rebirth.xbCost[star_level] ,openEquip=rebirth.openEquip,addRate=rebirth.addRate};
	return rebirth_model;
end

-- 精灵装备
function SpriteConfig:get_spirits_skill( skill_id)
	local skill = spirits_skill.skill[skill_id];
	local skill_model = {type = skill.type, name = skill.name ,addRate=skill.addRate,shuLianDu=skill.shuLianDu};
	return rebirth_model;
end
-- 精灵装备
function SpriteConfig:get_spirits_skillLevelUp( skillLevelUp_id)
	local skillLevelUp = spirits_skill.skillLevelUp[skillLevelUp_id];
	local skillLevelUp_model = {skillLevelUp = skillLevelUp.itemId, xbCost = skillLevelUp.xbCost,ybCost=skillLevelUp.ybCost};
	return skillLevelUp_model;
end

-- 获取精灵当前级别升一级加成的属性
-- @param:精灵当前的等级、轮回等阶、当前轮回星级
--等级升级增长属性=（下级等级属性-当前等级属性)*(当前轮回百分比+1)
function SpriteConfig:get_spirits_attr_add(sprite_level,lunhui_level,lunhui_star_level)

	if sprite_level>=#spirits_lv.level then
		-- ZXLog("-----最大等级后无升级加成------")
		local ret_t = {life_add = 0, attack_add = 0 ,w_defence_add=0,m_defence_add=0};
		return ret_t
	end

	local  spirits_lv_t = spirits_lv.level[sprite_level].baseAttrs
	local  spirits_up_lv_t = spirits_lv.level[sprite_level+1].baseAttrs
	local  lunhui_percent = spirits_rebirth[lunhui_level].addRate[lunhui_star_level+1]/100
	-- ZXLog("-----------（下级等级属性-当前等级属性)*当前轮回百分比-------------",spirits_up_lv_t[1],spirits_lv_t[1],lunhui_percent)

	-- 加成
	-- local life_add 		= math.floor( (spirits_up_lv_t[1]-spirits_lv_t[1])*(lunhui_percent+1) )
	-- local attack_add 	= math.floor( (spirits_up_lv_t[2]-spirits_lv_t[2])*(lunhui_percent+1) )
	-- local w_defence_add = math.floor( (spirits_up_lv_t[3]-spirits_lv_t[3])*(lunhui_percent+1) )
	-- local m_defence_add = math.floor( (spirits_up_lv_t[4]-spirits_lv_t[4])*(lunhui_percent+1) )
	local life_add 		= math.floor(spirits_up_lv_t[1]-spirits_lv_t[1])
	local attack_add 	= math.floor(spirits_up_lv_t[2]-spirits_lv_t[2])
	local w_defence_add = math.floor(spirits_up_lv_t[3]-spirits_lv_t[3])
	local m_defence_add = math.floor(spirits_up_lv_t[4]-spirits_lv_t[4])
	-- 返回一个table
	local ret_t = {life_add = life_add, attack_add = attack_add ,w_defence_add=w_defence_add,m_defence_add=m_defence_add};
	return ret_t
end

-- 获取等阶升级加成
-- @param:精灵当前等阶、当前等阶星级、当前轮回等级、当前轮回星级
-- （下阶等阶属性-当前等阶属性））*(当前轮回百分比+1)
function SpriteConfig:get_stage_attr_add(stage_level,stage_star_level,lunhui_level,lunhui_star_level)
	-- print("SpriteConfig:get_stage_attr_add(stage_level,stage_star_level,lunhui_level,lunhui_star_level)",stage_level,stage_star_level,lunhui_level,lunhui_star_level)
	local cur_stage_star_level =stage_star_level+1
	local next_stage_star_level =stage_star_level+2
	local lunhui_level_ = lunhui_level
	local lunhui_star_level_ = lunhui_star_level+1

	--当前阶段和下阶
	local  cur_stage_t = spirits_stages.stages[stage_level].starAttrs[cur_stage_star_level]
	local  next_stage_t    = spirits_stages.stages[stage_level].starAttrs[next_stage_star_level] or spirits_stages.stages[stage_level+1].starAttrs[1]
	if next_stage_t == nil then
		next_stage_t = (spirits_stages.stages[stage_level+1] ~= nil) and spirits_stages.stages[stage_level+1].starAttrs[1] or cur_stage_t
	end
	--等阶0星时当前加成值为0
	local cur_life	= 0
	local cur_attack_add 	= 0
	local cur_w_defence_add = 0
	local cur_m_defence_add = 0
	--等阶非0星时当前加成值为
	if  cur_stage_t then
		cur_life	= cur_stage_t[1]
		cur_attack_add 	= cur_stage_t[2]
		cur_w_defence_add = cur_stage_t[3]
		cur_m_defence_add = cur_stage_t[4]
	end
	-- 当前轮回百分比
	local  lunhui_percent  = spirits_rebirth[lunhui_level_].addRate[lunhui_star_level_]/100

	-- 加成
	local life_add 		= math.floor( (next_stage_t[1]-cur_life)*(lunhui_percent+1))
	local attack_add 	= math.floor( (next_stage_t[2]-cur_attack_add)*(lunhui_percent+1))
	local w_defence_add = math.floor( (next_stage_t[3]-cur_w_defence_add)*(lunhui_percent+1))
	local m_defence_add = math.floor( (next_stage_t[4]-cur_m_defence_add)*(lunhui_percent+1))
	-- 返回一个table
	local ret_t = {life_add = life_add, attack_add = attack_add ,w_defence_add=w_defence_add,m_defence_add=m_defence_add};
	return ret_t
end

-- 获取轮回升阶加成
-- @param:精灵当前等级,当前等阶、当前等阶星级、当前轮回等级、当前轮回星级

-- 公式：(当前等级属性+当前等阶星级属性）*(下星轮回百分比- 当前轮回百分比)

function SpriteConfig:get_lunhui_attr_add(level,stage_level,star_level,lunhui_level,lunhui_star_level)
	-- print("SpriteConfig:get_lunhui_attr_add(level,stage_level,star_level,lunhui_level,lunhui_star_level)",level,stage_level,star_level,lunhui_level,lunhui_star_level)
	local cur_level_attr_t = spirits_lv.level[level].baseAttrs	                                         --当前等级属性
	local cur_stage_attr_t = spirits_stages.stages[stage_level].starAttrs[star_level+1]                  --当前等阶属性
	local cur_lunhui_level =lunhui_level
	local cur_lunhui_start_level  = lunhui_star_level + 1
	local next_linhui_start_level = lunhui_star_level + 2

	-- if next_linhui_start_level>=#spirits_rebirth[cur_lunhui_level].addRate then
	-- 	next_linhui_start_level=#spirits_rebirth[cur_lunhui_level].addRate-1
	-- end	
	
	local next_lunhui_percent = spirits_rebirth[cur_lunhui_level].addRate[next_linhui_start_level]        --下星轮回值
	local cur_lunhui_percent =  spirits_rebirth[cur_lunhui_level].addRate[cur_lunhui_start_level]	      --当前轮回值
	next_lunhui_percent = next_lunhui_percent or (spirits_rebirth[cur_lunhui_level+1] and spirits_rebirth[cur_lunhui_level+1].addRate[1] or 0)
	local lunhui_percent =(next_lunhui_percent-cur_lunhui_percent)/100									  --加成百分比
	-- 加成
	-- local life_add 		= math.floor( (cur_level_attr_t[1]+cur_stage_attr_t[1])*lunhui_percent)
	-- local attack_add 	= math.floor( (cur_level_attr_t[2]+cur_stage_attr_t[2])*lunhui_percent)
	-- local w_defence_add = math.floor( (cur_level_attr_t[3]+cur_stage_attr_t[3])*lunhui_percent)
	-- local m_defence_add = math.floor( (cur_level_attr_t[4]+cur_stage_attr_t[4])*lunhui_percent)
	local life_add 		= math.floor(cur_stage_attr_t[1]*lunhui_percent)
	local attack_add 	= math.floor(cur_stage_attr_t[2]*lunhui_percent)
	local w_defence_add = math.floor(cur_stage_attr_t[3]*lunhui_percent)
	local m_defence_add = math.floor(cur_stage_attr_t[4]*lunhui_percent)
	-- 返回一个table
	local ret_t = {life_add = life_add, attack_add = attack_add ,w_defence_add=w_defence_add,m_defence_add=m_defence_add};
	return ret_t
end

-- 获取精灵升级消耗的元宝和属性加成
-- 装备次序id
function SpriteConfig:get_sprite_level_up_item( level_id )
	local  spirits_lv_item = spirits_lv.levelUpItem[level_id]
	local ret_t = {ybCost = spirits_lv_item.ybCost, baojiRate = spirits_lv_item.baojiRate ,baojiValue=spirits_lv_item.baojiValue,addExp=spirits_lv_item.addExp};
	return ret_t
end

-- 获取某个等级精灵的等级基础属性和升级经验
-- 参数：精灵等级
function SpriteConfig:get_sprite_up_level_exp( level )
	local  spirits_lv_item = spirits_lv.level[level]
	local ret_t = {upExp = spirits_lv_item.upExp, life = spirits_lv_item.baseAttrs[1] ,baoji=spirits_lv_item.baseAttrs[2],w_defence=spirits_lv_item.baseAttrs[3],m_defence=spirits_lv_item.baseAttrs[4]};
	return ret_t
end

-- 精灵的最高级
function SpriteConfig:get_sprite_max_level(  )

	return #spirits_lv.level;
end

-- 获取所有类型的精灵
function SpriteConfig:get_all_sprite_model(  )
	local sprite_models = {}
	for i=1, #spirits_rebirth do
		local model_id =spirits_rebirth[i].modelId
		-- print("SpriteConfig:get_all_sprite_model(model_id)",model_id)
		sprite_models[i]=SpriteConfig:get_sprite_data_by_rebirthLv(model_id)
	end
	return sprite_models
end

-- 获取所有类型的精灵
function SpriteConfig:get_max_win_level(  )
	local max_stage = #spirits_stages.stageUpItem
	return max_stage;
end
-- 获取最大等级升阶晶片id
function SpriteConfig:get_max_stageUpItem_id(  )
	local _crystal_id = spirits_stages.stageUpItem[#spirits_stages.stageUpItem].itemId
	return _crystal_id;
end

-- 更具精灵等级获取升阶晶片id
function SpriteConfig:get_item_id_by_level(stage_level)
	local _crystal_id = spirits_stages.stageUpItem[stage_level].itemId
	return _crystal_id;
end

--获取升阶信息
function SpriteConfig:get_UpItemInfo_by_stage(stage_level)
	return spirits_stages.stageUpItem[stage_level]
end

--------------------------------技能------------------------------------------
--获取技能icon
function SpriteConfig:get_skill_icon_by_id( skill_id )
	local skill_icons = {  
		"icon/interface/others/00191.pd", 
        "icon/interface/others/00192.pd",
        "icon/interface/others/00193.pd",
        "icon/interface/others/00194.pd",
        "icon/interface/others/00195.pd",
        "icon/interface/others/00196.pd",
        "icon/interface/others/00197.pd",
        "icon/interface/others/00198.pd",
        "icon/interface/others/00199.pd"
        -- "icon/interface/others/00197.pd"
     };
      return skill_icons[skill_id];
end
-- 通过索引获取精灵技能等级
function SpriteConfig:get_skill_by_index(skill_index)
	local t = spirits_skill.skill[skill_index]
	return  {name=t.name,type=t.type,addRate=t.addRate,shuLianDu=t.shuLianDu,des=t.des}
end

-- 通过索引获取精灵技能等级
function SpriteConfig:get_max_skill_level()
	local t = #spirits_skill.skill
	return t
end

--------------------------------装备------------------------------------------
--获取装备icon
function SpriteConfig:get_equip_icon_by_id( skill_id )
	local equip_icons = {  
		"icon/interface/others/00291.pd", 
        "icon/interface/others/00292.pd",
        "icon/interface/others/00293.pd",
        "icon/interface/others/00294.pd",
        "icon/interface/others/00295.pd",
        "icon/interface/others/00296.pd",
        "icon/interface/others/00297.pd",
        "icon/interface/others/00298.pd",
     };
      return equip_icons[skill_id];
end
-- 根据技能索引获取技能信息
function SpriteConfig:get_equip_by_index(equip_index)
	local t = spirits_equip.equip[equip_index]
	return  {name=t.name,type=t.type,addRate=t.addRate}
end

--式神领取条件
function SpriteConfig:get_sprite_default_condition()
	return spirits_lv.default
end

--式神vip领取条件
function SpriteConfig:get_sprite_vip_condition()
	return spirits_lv.ybDefault
end

--领取式神声望转换
function SpriteConfig:get_renown_by_lunhui_level(lunhui_level)
	if spirits_rebirth[lunhui_level] then
		return spirits_rebirth[lunhui_level].toRenown
	else
		return 0
	end
end

function SpriteConfig:get_max_model_id()
	return spirits_rebirth[#spirits_rebirth].modelId
end

function SpriteConfig:get_max_lunhui()
	return #spirits_rebirth
end