-- WingConfig.lua
-- created by fjh on 2013-1-26
-- 翅膀的属性配置

require "../data/std_wing"

WingConfig = {}


--获取翅膀的静态属性
function WingConfig:get_wing_attris_by_level( level )
	return std_wing.levelUpBase[level];
end

--获取翅膀的属性加成率
function WingConfig:get_addRate_by_jieji_star( jieji, star_level )
	return std_wing.stages[jieji].addRate[star_level+1];
end

--翅膀所有技能
function WingConfig:get_wing_skills( )
	return std_wing.skill;
end

function WingConfig:get_index_wing_skills(index)
	local temp_info = {}
	temp_info = std_wing.skill[index]
	return temp_info
end

--获取翅膀技能icon
function WingConfig:get_wing_skill_icon_by_id( skill_id )
    return std_wing.skill[skill_id].skill_icon
end

--当前阶级对应拥有的技能
function WingConfig:get_wing_skill_by_jieji( jieji )
	local skills = {};
	-- if jieji < 3 then
	-- 	skills[1] = std_wing.skill[1];
	-- elseif jieji == 3 then
	-- 	skills[1] = std_wing.skill[1];
	-- 	skills[2] = std_wing.skill[2];
	-- elseif jieji == 4 then
	-- 	skills[1] = std_wing.skill[1];
	-- 	skills[2] = std_wing.skill[2];
	-- 	skills[3] = std_wing.skill[3];
	-- elseif jieji == 5 then
	-- 	skills[1] = std_wing.skill[1];
	-- 	skills[2] = std_wing.skill[2];
	-- 	skills[3] = std_wing.skill[3];
	-- 	skills[4] = std_wing.skill[4];
	-- elseif jieji == 6 then
	-- 	skills[1] = std_wing.skill[1];
	-- 	skills[2] = std_wing.skill[2];
	-- 	skills[3] = std_wing.skill[3];
	-- 	skills[4] = std_wing.skill[4];		
	-- 	skills[5] = std_wing.skill[5];		
	-- elseif jieji == 7 then
	-- 	skills[1] = std_wing.skill[1];
	-- 	skills[2] = std_wing.skill[2];
	-- 	skills[3] = std_wing.skill[3];
	-- 	skills[4] = std_wing.skill[4];		
	-- 	skills[5] = std_wing.skill[5];	
	-- 	skills[6] = std_wing.skill[6];	
	-- elseif jieji > 7 then
	-- 	skills = std_wing.skill;
	-- end
	return skills;
end

--获取翅膀的最大等级
function WingConfig:get_wing_max_level(  )
	return #std_wing.levelUpBase;
end

-- 获取翅膀的名字
function WingConfig:get_wing_name( stages )

	return std_wing.stages[stages].name;
end

-- 根据翅膀的阶级返回对应的item_id
function WingConfig:get_wing_item_id_by_stage( stage )
	return std_wing.stages[stage].itemId
end

-- 获得祝福值对应的成功率加成
function WingConfig:get_zhufu_add_rate( zhufu_value )
	if zhufu_value > 0 then 
		return std_wing.bless[zhufu_value] * 0.1;
	end
	return 0;
end

-- 获得翅膀转化为声望的数值
function WingConfig:get_changeRenown_by_stage( stage )
	print("stage",stage);
	return std_wing.stages[stage].changeRenown;

end


-- add by yongrui.liang at 2014-8-19
-- 翅膀升级需要仙币
function WingConfig:getLvUpNeedMoney( level )
	return std_wing.levelUpMoney[level]
end

-- 升星需要仙币
function WingConfig:getUpgradeNeedMoney( stage, star )
	return std_wing.stages[stage].xbCost[star+1]
end

-- 升星需要声望
function WingConfig:getUpgradeNeedShengWang( stage, star )
	return std_wing.stages[stage].renownCost[star+1]
end

-- 获取当前翅膀“当前属性”最高加成
function WingConfig:getCurStageMaxAddAttr( stage )
	return std_wing.stages[stage].addRate[#std_wing.stages[stage].addRate]
end

-- 获取最高阶数
function WingConfig:getMaxStageLevel( )
	return #std_wing.stages
end

-- 获取翅膀“当前阶”最高等级
function WingConfig:getCurStageMaxLevel( stage )
	return std_wing.stages[stage].maxLevel
end

-- 获取翅膀“当前等级”成功率
function WingConfig:getSucRateByLevel( level )
	return std_wing.levelUpRate[level]/10
end

-- 获取翅膀所有技能的id
function WingConfig:getWingSkillIds( )
	local IDs = {}
	local skills = std_wing.skill
	for i,v in ipairs(skills) do
		IDs[i] = i
	end
	return IDs
end

-- 获取翅膀技能总数
function WingConfig:getWingSkillNum( )
	return #std_wing.skill
	-- return 7
end

-- 获取翅膀技能最大等级
function WingConfig:getSkillMaxLevelById( skillID )
	return #std_wing.skill[skillID].addRate
end

-- 获取开启的技能
function WingConfig:getOpenSkillByStage( stage )
	return std_wing.stages[stage].openSkill or {}
end

-- 获取技能升级所需Item
function WingConfig:getSkillLvUpItems( )
	return std_wing.skillItem
end

-- 获取技能的熟练度
function WingConfig:getMaxShuLianDu( skillID )
	return std_wing.skill[skillID].shuLianDu
end

-- 获取技能名字
function WingConfig:getSkillNameById( skillID )
	return std_wing.skill[skillID].name
end

-- 领取充值元宝的翅膀的等级
function WingConfig:getYbWingLevel( )
	return std_wing.ybWingLevel
end

-- 领取充值元宝的翅膀的品阶
function WingConfig:getYbWingStage( )
	return std_wing.ybWingStage
end

-- 领取充值元宝的翅膀的星级
function WingConfig:getYbWingStar( )
	return std_wing.ybWingStar
end

-- 获取翅膀升级所需的物品
function WingConfig:getLvUpItem( level )
	return std_wing.levelUpItem[level]
end

function WingConfig:get8thSkillAddFightPower( level )
	return std_wing.hbhd.addFightPower[level]
end

function WingConfig:get9thSkillAddFightPower( level )
	return std_wing.yhzc.addFightPower[level]
end
