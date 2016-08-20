-- filename: WingModel.lua
-- author: created by fanglilian on 2012-12-14.
-- function: 该文件实现翅膀control

WingModel = {}


WingModel.OTHER_WING_INFO = 0 		-- 查看他人翅膀
WingModel.MINE_WING_INFO = 1 		-- 翅膀信息页面
WingModel.WING_LEVEL_UP = 2 		-- 翅膀升级页面
WingModel.WING_UPGRADE = 3 			-- 翅膀进阶页面
WingModel.WING_SHAPE = 4  			-- 翅膀化形页面
WingModel.WING_SKILL = 5 			-- 翅膀技能页面
WingModel.CURRENT_LEFT_PAGE = WingModel.MINE_WING_INFO
WingModel.IS_SHOW_OTHER_WING = false
WingModel.SELECTED_WING_SKILL_ID = 1
WingModel.CURRENT_RIGHT_PAGE = WingModel.MINE_WING_INFO
WingModel.PLAY_UPGRADE_EFFECT = false
WingModel.GOT_FREE_WING = false
WingModel.GOT_VIP_WING = false

local MAX_SKILL_LV = 10;

local _wing_is_testing=true;
-- 羽翼晶石各阶对应item_id , 50级-60级统一使用六阶羽翼晶石
local _yuyi_crystal_item_ids = {18627, 18628, 18629, 18630, 18631, 18632, 18632,18638,18639};

local _wing_item;				-- 服务器返回的翅膀数据
local _wing_item_id;			-- 当前翅膀item_id
local _curr_skill_index;		-- 当前翅膀技能索引
local _just_upgrade_ = false;	-- 用于标记翅膀技能是否刚刚升了级
local _otherWingData = nil
-- 
local _other_player_info = nil;	--在查看他人翅膀时，暂时保存人物信息资料

-- after 天将雄狮
WingModel.curShowStage = nil

-- added by aXing on 2013-5-25
function WingModel:fini( ... )
	_wing_is_testing = true;
	_wing_item = nil
	_wing_item_id = nil
	_curr_skill_index = nil
	_just_upgrade_ = false
	WingModel.CURRENT_LEFT_PAGE = WingModel.MINE_WING_INFO
	WingModel.IS_SHOW_OTHER_WING = false
	WingModel.SELECTED_WING_SKILL_ID = 1
	_otherWingData = nil
	WingModel.CURRENT_RIGHT_PAGE = WingModel.MINE_WING_INFO
	WingModel.PLAY_UPGRADE_EFFECT = false
	WingModel.GOT_FREE_WING = false
	WingModel.GOT_VIP_WING = false
end

function WingModel:start_wing_win()

end

-- 获取当前翅膀数据
function WingModel:get_wing_item_data()
	return _wing_item;
end

-- 设置当前翅膀数据
function WingModel:set_wing_item_data( wing_item )
	--xprint("run WingModel:set_wing_item_data")
	_wing_item = wing_item;
	-- 得到翅膀数据后更新界面显示信息
	-- WingUpgradeInfoRPanel:refresh_all_values();
end

-- 获取翅膀名称
function WingModel:get_wing_name()
	return WingConfig:get_wing_name(_wing_item.stage)
end

function WingModel:getOtherWingName( )
	local stage = _otherWingData.stage
	return WingConfig:get_wing_name(stage)
end

-- 获取当前翅膀等级
function WingModel:get_curr_wing_level()
	return _wing_item.level;
end

function WingModel:getOtherWingLevel( )
	return _otherWingData.level
end

-- 获取当前翅膀几阶
function WingModel:get_curr_wing_stage()
	return _wing_item.stage;
end

function WingModel:getOtherWingStage( )
	return _otherWingData.stage
end

--获取翅膀最高阶
function WingModel:get_max_win_stage(  )
	return #std_wing.stages;
end
--获取翅膀的最高级
function WingModel:get_max_win_level( )
	local max_stage = std_wing.stages[#std_wing.stages];
	return max_stage.maxLevel;
end
-- 获取当前翅膀下一阶值
function WingModel:get_wing_next_stage()
	local max_stage = #std_wing.stages;
	local next_stage = _wing_item.stage + 1;
	if (next_stage > max_stage) then
		next_stage = max_stage;
	end
	return next_stage;
end

-- 获取当前翅膀几星
function WingModel:get_curr_wing_star()
	return _wing_item.star;
end

function WingModel:getOtherWingStar( )
	return _otherWingData.star
end

-- 设置当前翅膀几星(递增1)
function WingModel:set_curr_wing_star(star_num)
	_wing_item.star = _wing_item.star+1;
	-- here, we should inform the server.

end

-- 获取当前翅膀“评分”
function WingModel:get_curr_wing_score()
	return _wing_item.score;
end

function WingModel:getOtherWingScore( )
	return _otherWingData.score
end

-- 获取当前翅膀“当前属性”
function WingModel:get_curr_attr( level )
	-- local curr_level_attr = {
	-- 		std_wing.levelUpBase[level][1], 
	-- 		std_wing.levelUpBase[level][2],
	-- 		std_wing.levelUpBase[level][3], 
	-- 		std_wing.levelUpBase[level][4]
	-- 	};
	local level = WingModel:get_curr_wing_level()
	local curr_level_attr = WingConfig:get_wing_attris_by_level( level )
	return curr_level_attr;
end

function WingModel:getOtherWingCurAttr( )
	local level = WingModel:getOtherWingLevel()
	local curr_level_attr = WingConfig:get_wing_attris_by_level( level )
	return curr_level_attr
end

-- 获取当前翅膀“下级属性”
function WingModel:get_next_attr( level )
	-- if level >= #std_wing.levelUpBase then
	-- 	local next_level_attr = {
	-- 		std_wing.levelUpBase[level][1], 
	-- 		std_wing.levelUpBase[level][2],
	-- 		std_wing.levelUpBase[level][3], 
	-- 		std_wing.levelUpBase[level][4]
	-- 	};
	-- 	return next_level_attr;
	-- else
	-- 	local next_level_attr = {
	-- 		std_wing.levelUpBase[level+1][1], 
	-- 		std_wing.levelUpBase[level+1][2],
	-- 		std_wing.levelUpBase[level+1][3], 
	-- 		std_wing.levelUpBase[level+1][4]
	-- 	};
	-- 	return next_level_attr;
	-- end
	local maxLevel = WingConfig:get_wing_max_level( )
	local level = WingModel:get_curr_wing_level()
	if level >= maxLevel then
		return WingConfig:get_wing_attris_by_level( maxLevel )
	else
		return WingConfig:get_wing_attris_by_level( level+1 )
	end
end

function WingModel:getOtherWingNexAttr( )
	local maxLevel = WingConfig:get_wing_max_level( )
	local level = WingModel:getOtherWingLevel()
	if level >= maxLevel then
		return WingConfig:get_wing_attris_by_level( maxLevel )
	else
		return WingConfig:get_wing_attris_by_level( level+1 )
	end
end

function WingModel:getAttrAdd( level, stage, star )
	local attr = WingConfig:get_wing_attris_by_level( level )
	local rate = WingConfig:get_addRate_by_jieji_star( stage, star )
	local attrAdd = {
		(attr[1]*rate)/100,
		(attr[2]*rate)/100,
		(attr[3]*rate)/100,
		(attr[4]*rate)/100,
	}

	return attrAdd
end

-- 获取当前翅膀“当前属性”附加属性
function WingModel:get_curr_attr_append(level, stage, star)
	-- local curr_level_attr_append = {
	-- 	(std_wing.levelUpBase[level][1] * std_wing.stages[stage].addRate[star+1])/100, 
	-- 	(std_wing.levelUpBase[level][2] * std_wing.stages[stage].addRate[star+1])/100,
	-- 	(std_wing.levelUpBase[level][3] * std_wing.stages[stage].addRate[star+1])/100, 
	-- 	(std_wing.levelUpBase[level][4] * std_wing.stages[stage].addRate[star+1])/100
	-- };
	local level = WingModel:get_curr_wing_level()
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	-- local attr = WingConfig:get_wing_attris_by_level( level )
	-- local rate = WingConfig:get_addRate_by_jieji_star( stage, star )
	-- local curr_level_attr_append = {
	-- 	(attr[1]*rate)/100,
	-- 	(attr[2]*rate)/100,
	-- 	(attr[3]*rate)/100,
	-- 	(attr[4]*rate)/100,
	-- }
	local curr_level_attr_append = WingModel:getAttrAdd(level, stage, star)

	return curr_level_attr_append;
end

function WingModel:getOtherWingCurAttrAppend( )
	local level = WingModel:getOtherWingLevel()
	local stage = WingModel:getOtherWingStage()
	local star = WingModel:getOtherWingStar()
	local curr_level_attr_append = WingModel:getAttrAdd(level, stage, star)

	return curr_level_attr_append
end

-- 获取当前翅膀“下级属性”附加属性
function WingModel:get_next_attr_append(level, stage, star )
	local level = WingModel:get_curr_wing_level()
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	local next_level = level+1;
	if (next_level > WingConfig:get_wing_max_level( )) then
		next_level = level;
	end
	-- local next_level_attr_append = {
	-- 	(std_wing.levelUpBase[next_level][1] * std_wing.stages[stage].addRate[star+1])/100, 
	-- 	(std_wing.levelUpBase[next_level][2] * std_wing.stages[stage].addRate[star+1])/100,
	-- 	(std_wing.levelUpBase[next_level][3] * std_wing.stages[stage].addRate[star+1])/100, 
	-- 	(std_wing.levelUpBase[next_level][4] * std_wing.stages[stage].addRate[star+1])/100
	-- };	
	-- local attr = WingConfig:get_wing_attris_by_level( next_level )
	-- local rate = WingConfig:get_addRate_by_jieji_star( stage, star )
	-- local next_level_attr_append = {
	-- 	(attr[1]*rate)/100,
	-- 	(attr[2]*rate)/100,
	-- 	(attr[3]*rate)/100,
	-- 	(attr[4]*rate)/100,
	-- }
	local next_level_attr_append = WingModel:getAttrAdd(next_level, stage, star)
	return next_level_attr_append;
end

function WingModel:getOtherWingNexAttrAppend( )
	local level = WingModel:getOtherWingLevel()
	local stage = WingModel:getOtherWingStage()
	local star = WingModel:getOtherWingStar()
	local next_level = level+1
	if (next_level > WingConfig:get_wing_max_level( )) then
		next_level = level
	end
	local next_level_attr_append = WingModel:getAttrAdd(next_level, stage, star)
	return next_level_attr_append
end

-- 获取当前翅膀“当前属性”加成
function WingModel:get_curr_attr_add()
	-- return std_wing.stages[_wing_item.stage].addRate[_wing_item.star+1];
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	local rate = WingConfig:get_addRate_by_jieji_star( stage, star )
	return rate
end
-- 获取当前翅膀“下级属性”加成
function WingModel:get_next_attr_add()
	-- return std_wing.stages[_wing_item.stage+1].addRate[_wing_item.star+1];
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	local rate = WingConfig:get_addRate_by_jieji_star( stage+1, star )
	return rate
end

-- 获取当前翅膀“当前属性”最高加成
function WingModel:get_curr_attr_add_limit()
	-- return std_wing.stages[_wing_item.stage].addRate[#std_wing.stages[_wing_item.stage].addRate];
	local stage = WingModel:get_curr_wing_stage()
	return WingConfig:getCurStageMaxAddAttr( stage )
end

-- 获取当前翅膀“下接属性”最高加成
function WingModel:get_next_attr_add_limit()
	-- local stage = _wing_item.stage;
	-- if (stage < #std_wing.stages) then
	-- 	stage = stage + 1;
	-- end
	-- return std_wing.stages[stage].addRate[#std_wing.stages[stage].addRate];
	local stage = WingModel:get_curr_wing_stage()
	local maxStage = WingConfig:getMaxStageLevel()
	if stage < maxStage then
		stage = stage + 1
	end
	return WingConfig:getCurStageMaxAddAttr( stage )
end

-- 获取翅膀“当前阶”最高等级
function WingModel:get_curr_stage_max_level()
	-- return std_wing.stages[_wing_item.stage].maxLevel;
	local stage = WingModel:get_curr_wing_stage()
	return WingConfig:getCurStageMaxLevel( stage )
end

-- 获取翅膀“下一阶”最高等级
function WingModel:get_next_stage_max_level()
	-- local stage = _wing_item.stage;
	-- if (stage < #std_wing.stages) then
	-- 	stage = stage + 1;
	-- end
	-- return std_wing.stages[stage].maxLevel;
	local stage = WingModel:get_curr_wing_stage()
	local maxStage = WingConfig:getMaxStageLevel()
	if stage < maxStage then
		stage = stage + 1
	end
	return WingConfig:getCurStageMaxLevel( stage )
end

-- 获取翅膀“当前等级”成功率
function WingModel:get_curr_level_success_rate()
	-- local level = _wing_item.level;
	-- if (level > #std_wing.levelUpRate) then
	-- 	level = #std_wing.levelUpRate
	-- end
	
	-- return std_wing.levelUpRate[level]/10;
	local level = WingModel:get_curr_wing_level()
	local maxLevel = WingConfig:get_wing_max_level()
	if level >= maxLevel then
		level = maxLevel - 1
	end
	return WingConfig:getSucRateByLevel( level )
end

-- 获取翅膀“当前等级”祝福值
function WingModel:get_curr_level_wishes()
	return _wing_item.wishes;
end

function WingModel:getOtherWingWishes( )
	return _otherWingData.wishes
end

-- 获取翅膀 “当前等级” 的
function WingModel:get_curr_bless_ratio()
	if (_wing_item.wishes == 0) then
		return 0;
	end
	return std_wing.bless[_wing_item.wishes];
end

-- 升星需要声望
function WingModel:need_renown_upgrade_star()
	-- return std_wing.stages[_wing_item.stage].renownCost[_wing_item.star+1];
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	return WingConfig:getUpgradeNeedShengWang( stage, star )
end

-- 升星需要仙币
function WingModel:need_xb_upgrade_star( ... )
	-- return std_wing.stages[_wing_item.stage].xbCost[_wing_item.star+1];
	local stage = WingModel:get_curr_wing_stage()
	local star = WingModel:get_curr_wing_star()
	return WingConfig:getUpgradeNeedMoney( stage, star )
end

-- 翅膀升级需要仙币
function WingModel:need_xb_levelup_wing( ... )
	-- if _wing_item.level > #std_wing.levelUpMoney then
	-- 	return std_wing.levelUpMoney[#std_wing.levelUpMoney];
	-- else
	-- 	return std_wing.levelUpMoney[_wing_item.level];
	-- end
	local level = WingModel:get_curr_wing_level()
	local maxLv = WingConfig:get_wing_max_level()
	if level >= maxLv-1 then
		level = maxLv-1
	end
	return WingConfig:getLvUpNeedMoney( level )
end

-- 获得用户当前仙币
function WingModel:get_user_xb( )
	local player = EntityManager:get_player_avatar();

	return player.bindYinliang;
end

-- 获得用户当前声望
function WingModel:get_user_renown( )
	local player = EntityManager:get_player_avatar();

	return player.renown;
end

-- 获取翅膀对应阶值名字,item_id
function WingModel:get_wing_info_with_stage(stage_value)
	return std_wing.stages[stage_value].name, std_wing.stages[stage_value].itemId;
end

-- 获取对应item_id物品图片
function WingModel:get_icon_by_itemid(item_id)
	if (_wing_is_testing == false) then
		return ItemConfig:get_item_icon(item_id);
	end
	if (item_id == 11400) then
		return "ui/wing/100/1001.png";
	elseif (item_id == 11402) then
		return "ui/wing/100/1002.png";
	elseif (item_id == 11403) then
		return "ui/wing/100/1003.png";
	elseif (item_id == 11404) then
		return "ui/wing/100/1004.png";
	elseif (item_id == 11405) then
		return "ui/wing/100/1005.png";
	else
		return "ui/wing/100/1006.png";
	end
	
end


-- 通过“技能索引”获取技能名字
function WingModel:get_skill_name_by_index(skill_index)
	-- return std_wing.skill[skill_index].name;
	return WingConfig:getSkillNameById(skill_index)
end

-- 通过“技能索引”获取翅膀效果值
function WingModel:get_effect_by_index(skill_index)

	local level = _wing_item.skills_level[skill_index];
	if level == 0 then
		level = 1;
	end

	local addRate = std_wing.skill[skill_index].addRate;
	local skill_desc = std_wing.skill[skill_index].des;
	local skill_desc1 = std_wing.skill[skill_index].des1;

	local ten_effect=addRate[#addRate];
	local next_effect = addRate[level];
	if (level < #addRate) then
	 	next_effect = addRate[level+1];
	end
	local curr_effect = addRate[level];

	return {skill_desc,skill_desc1},{ curr_effect, next_effect,ten_effect};
end

function WingModel:getSkillEffectById( skill_index )
	local level = 0
	if _wing_item then
		level = _wing_item.skills_level[skill_index];
	end

	if level == nil then
		level = 0
	end
	if level == 0 then
		level = 1;
	end

	local addRate = std_wing.skill[skill_index].addRate;
	local skill_desc = std_wing.skill[skill_index].des or "";
	local skill_desc1 = std_wing.skill[skill_index].des1 or "";
	local skill_desc2 = std_wing.skill[skill_index].des2 or ""

	local ten_effect=addRate[#addRate];
	local next_effect = addRate[level]
	
	if (level < #addRate) then
	 	next_effect = addRate[level+1];
	end
	local curr_effect = addRate[level] or 1;

	local skill_t1 = {[1] = true, [3] = true,[6] = true, [7] = true} -- *100+%
	local skill_t2 = {[2] = true, [4] = true, [5] = true} -- /100+%
	local skill_t3 = {[3] = true} -- *1+%
	local skill_t4 = {[8] = true} -- *1
	local skill_t5 = {[9] = true} -- ...

	local cur_other_effect = ""
	local next_other_effect = ""
	local lv10_other_effect = ""
	if skill_t1[skill_index] then
		curr_effect = curr_effect * 100
		next_effect = next_effect * 100
		ten_effect = ten_effect * 100
	elseif skill_t2[skill_index] then
		curr_effect = curr_effect / 100
		next_effect = next_effect / 100
		ten_effect = ten_effect / 100
	elseif skill_t3[skill_index] then
		--
	elseif skill_t4[skill_index] then
		-- *1
	elseif skill_t5[skill_index] then
		local triggerRate = spirits_skill.yhzc.triggerRate
		local effectTime = spirits_skill.yhzc.effectTime

		cur_other_effect = effectTime[curr_effect]
		next_other_effect = effectTime[next_effect]
		lv10_other_effect = effectTime[ten_effect]
		curr_effect = triggerRate[curr_effect]
		next_effect = triggerRate[next_effect]
		ten_effect = triggerRate[ten_effect]
	end

	local sign = ""
	if skill_t1[skill_index] or skill_t2[skill_index] or skill_t3[skill_index] then
		sign = "%"
	end

	return {skill_desc,skill_desc1,skill_desc2},
			{ curr_effect, next_effect,ten_effect}, 
			{cur_other_effect, next_other_effect, lv10_other_effect}, sign;
end

-- 通过“技能索引”获取翅膀熟练度
function WingModel:get_exp_values(skill_index)
	-- local level = _wing_item.skills_level[skill_index];
	local level = WingModel:getSkillLevelById(skill_index)
	-- local shuLianDu = std_wing.skill[skill_index].shuLianDu;
	local shuLianDu = WingConfig:getMaxShuLianDu(skill_index)
	if (level == 0) then
		level = level + 1;
	end

	-- local curr_exp = _wing_item.skills[skill_index].exp;
	local curr_exp = WingModel:getSkillExpById(skill_index)
	local curr_max_exp = shuLianDu[level];

	return {curr_exp, curr_max_exp};
end

-- 获取当前升级所需要的仙币数
function WingModel:get_xb_value_by_skill_index(skill_index)

	local level = _wing_item.skills_level[skill_index];
	if level == 0 or level == 10 then 
		return 0;
	else 
		local skillLevelUpCost = std_wing.skillLevelUpCost[level];
		return skillLevelUpCost;	
	end
	

end

-- 获取当前model_id
function WingModel:get_curr_modelId()
	return _wing_item.modelId;
end
-- 对应阶的模型id
function WingModel:get_modelId_by_stage( stage_index )
	return std_wing.stages[stage_index].modelId;
end

-- 从背包中获取当前阶的羽翼晶石数量
function WingModel:get_yuli_crystal_count()

	local item_id = WingModel:get_cur_level_crystal_item_id( );

	local count = ItemModel:get_item_count_by_id(item_id);	

	return count;
end

-- 取得当前等级对应的羽翼晶石 id
function WingModel:get_cur_level_crystal_item_id( )
	if _wing_item == nil then
		return ;
	end
	-- xprint("234234")
	-- if _wing_item.level >= WingModel:get_max_win_level() then
	-- 	-- 最高级
	-- 	return _yuyi_crystal_item_ids[#_yuyi_crystal_item_ids];
	-- end

	-- local index =  Utils:getIntPart(_wing_item.level/10)+1;
	-- return _yuyi_crystal_item_ids[index];
	local level = WingModel:get_curr_wing_level()
	local maxLevel = WingModel:get_max_win_level()
	if level >= maxLevel then
		level = level - 1
	end
	return WingConfig:getLvUpItem(level)
end
-- 取得当前阶对应的羽翼晶石 id
function WingModel:get_curr_stage_crystal_item_id()
	
	return _yuyi_crystal_item_ids[_wing_item.stage];

end

function WingModel:get_the_highest_level()
	return std_wing.stages[#std_wing.stages].maxLevel;
end

--获取翅膀技能的等级对应羽翼技能卷的item id
function WingModel:get_skill_book_id_by_skill_level( level )
	-- if (level <= 3) then        
 --        return 18633;
 --    elseif (level <= 6) then        
 --        return 18634;
 --    else
 --        return 18635;
 --    end
 	local items = WingConfig:getSkillLvUpItems()
 	if level <= 3 then
 		return items[1]
 	elseif level <= 6 then
 		return items[2]
 	else
 		return items[3]
 	end
end
-- 当技能升级到一定等级时不能自动购买所需物品
function WingModel:getCanAutoBuySkillItem( level )
	return level <= 6
end

--获取翅膀技能的等级对应羽翼技能卷的icon id
function WingModel:get_skill_book_icon_id_by_skill_level( level )
    if (level <= 3) then        
        return "00561";
    elseif (level <= 6) then        
        return "00562";
    else
        return "00563";
    end
end

-- 获得该技能对应羽翼技能卷数量
function WingModel:get_skill_book_count( skill_index  )
    --当前技能的等级
    local level = (WingModel:get_wing_item_data()).skills_level[skill_index];
    local book_id = WingModel:get_skill_book_id_by_skill_level(level);
    require "model/ItemModel"
    --羽翼卷的数量
    local count = ItemModel:get_item_count_by_id( book_id );
    return count;
end

-- 刷新翅膀进阶界面
function WingModel:update_wingStagePanel(  )
	WingStageRPanel:refresh_attr_value();
end

--更新技能熟练度
function WingModel:update_exp_progress( )
	--更新技能熟练度
	-- WingSkillUpgrade:set_exp_value();
	-- local win = UIManager:find_visible_window("wing_skill_win");
	-- if win ~= nil then
	-- 	win:update_skill_progress();
	-- end
	-- WingModel:updateWingLeftWin()
	-- WingModel:updateWingRightWin()
	local win = UIManager:find_visible_window("wing_skill_win")
	if win then
		win:update("skill_exp")
	end
end

-- 更新技能等级
function WingModel:update_skill_level(  )
	
	-- local win = UIManager:find_visible_window("wing_skill_win");
	-- if win ~= nil then
	-- 	win:update();
	-- end
	-- WingModel:updateWingLeftWin()
	-- WingModel:updateWingRightWin()
	local win = UIManager:find_visible_window("wing_skill_win")
	if win then
		win:update("all")
	end
end
-- 以下接口与WingCC交互，发送请求
-- 如果服务端有返回则新窗口界面

-- request提升阶值
function WingModel:req_upgrade_stage()
	if WingModel:is_max_stage_star() then
		GlobalFunc:create_screen_notic("翅膀等阶达到上限，期待更高阶翅膀")
		return true
	end

	-- 获取当前装备数组
	local wing_item_id;
	local equipments = UserInfoModel:get_equi_info();
	local wing_guid;

	-- 查询当前翅膀id
	for i=1, #equipments do
		if (ItemConfig:is_wing(equipments[i].item_id) == true) then
			wing_item_id = equipments[i].item_id;
			wing_guid = equipments[i].series;
			break;
		end 
	end

	if (WingModel:need_renown_upgrade_star() > WingModel:get_user_renown()) then
		print (LangGameString[2184]); -- [2184]="Error: 进阶信息, 声望不足."
		GlobalFunc:create_screen_notic(LangGameString[2184])
		return true;
	end
	if (WingModel:get_user_xb() <  WingModel:need_xb_upgrade_star()) then
		-- GlobalFunc:create_screen_notic(LangGameString[2185]) -- [2185]="Error: 进阶信息, 仙币不足."
		--天降雄狮修改 xiehande 如果是铜币不足/银两不足/经验不足 做我要变强处理
	   ConfirmWin2:show( nil, 13, LangGameString[2185],  need_money_callback, nil, nil )
		return true;
	end

	print("------------wing_guid:", wing_guid)
	WingCC:req_upgrade_stage(wing_guid);
end

-- return提升阶值
function WingModel:do_upgrade_stage(stage_value, star_value)
	-- print("stage_value=",stage_value,"star_value=",star_value);

	local old_stag = _wing_item.stage;
	_wing_item.stage = stage_value;
	_wing_item.star = star_value;

	WingModel:setIsPlayUpgradeEffect(true)
	local win = UIManager:find_visible_window("wing_win")
	if win then
		win:update("up_degree")
	end
	-- WingModel:updateWingLeftWin()
	-- WingModel:updateWingRightWin()
	-- WingModel:updateWingRightWin("UpgradeEffect")

	if old_stag < stage_value then
		--通知wingsyswin 改变avatar形象
		-- local win = UIManager:find_visible_window("wing_sys_win");
		-- if win then 
		-- 	--更新当阶翅膀和下阶翅膀
		-- 	win:update_curr_avatar();
		-- 	--更新技能item
		-- 	win:update_skill_item();
		-- end
		-- --更新进阶界面
		-- win = UIManager:find_visible_window("wing_jinjie_win");
		-- if win then
		-- 	win:update( true );
		-- end
	else
		-- 更新进阶界面的部分信息
		-- local win = UIManager:find_visible_window("wing_jinjie_win");
		-- if win then
		-- 	win:update_jinjie_info( false );
		-- end
	end

	-- local win2 = UIManager:find_visible_window("wing_sys_win")
	-- if win2 then 
	-- 	win2:update_tab_btns_tip(false)
	-- end
end
-- 请求化形
function WingModel:req_hua_xing(which_stage)
	WingCC:req_hua_xing(which_stage);
end

-- 化形结果
function WingModel:set_model_id(modelId)
	_wing_item.modelId = modelId;
	-- local win = UIManager:find_visible_window("wing_sys_win");
	-- if win ~= nil then
	-- 	win:update_main_avatar();
	-- end
	-- local win = UIManager:find_visible_window("wing_huaxing_win");
	-- if win ~= nil then
	-- 	win:update_show_avatar();
	-- end
	WingModel:updateWingLeftWin()
	-- WingModel:updateWingRightWin()
	-- WingWin:set_wing_model_img(modelId);
	-- WingHuaXingRPanel:refresh_all_values(1);
end

-- 请求升级翅膀技能的熟练度
function WingModel:req_upgrade_skill(which_skill,if_selected)
	-- print("which_skill",which_skill)
	local need_xb = WingModel:get_xb_value_by_skill_index(which_skill)
	 -- 判断仙币是否足够
    if (need_xb and WingModel:get_user_xb() < need_xb ) then
        -- GlobalFunc:create_screen_notic( LangModelString[147] ); -- [147]="仙币不足"
        --天降雄狮修改 xiehande 如果是铜币不足/银两不足/经验不足 做我要变强处理
	    ConfirmWin2:show( nil, 13, Lang.screen_notic[11],  need_money_callback, nil, nil )
        return ;
    end
    -- --羽翼技能卷
    -- local count = WingModel:get_skill_book_count(which_skill);
    -- if count <= 0 then
    --     GlobalFunc:create_screen_notic( LangModelString[479] ); -- [479]="没有羽翼技能卷,无法升级"
    --     return ;
    -- end
    local autobuy 
    if if_selected then
    	autobuy= 1
    else
    	autobuy=0
    end

    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local skillLevel = WingModel:getSkillLevelById(which_skill)
    local itemID = WingModel:get_skill_book_id_by_skill_level(skillLevel)
    local count = ItemModel:get_item_count_by_id( itemID )
    
    if count > 0 then	
	 	WingCC:req_wing_skill(which_skill, autobuy, money_type)
	elseif if_selected then
		--晶石不足时，如果勾选使用元宝
	 	local param = {which_skill, autobuy, money_type}
	 	local upgrade_func = function( param )
	 		WingCC:req_wing_skill(param[1], param[2], param[3])
	 	end
	 	MallModel:handle_shopping_1( itemID, 1, upgrade_func, param )
	else
		WingCC:req_wing_skill(which_skill, autobuy, money_type)
	end

	-- WingCC:req_wing_skill(which_skill,autobuy);
	_curr_skill_index = which_skill;
end



--每个技能的熟练度
function WingModel:do_skill_exp_changed( exps )
	for i,skill in ipairs(_wing_item.skills) do
		skill.exp = exps[i];
	end
	WingModel:update_exp_progress();
end


--升级翅膀的结果，主要用于显示浮动的tip，加了多少熟练度。
function WingModel:do_upgrade_wing_skill(is_attack, added_exp)
	-- WingSkillUpgrade:do_wing_skill_added_data(is_attack, added_exp);
	if ( is_attack == 1 ) then 
		-- local win = UIManager:find_visible_window("wing_skill_win");
		-- if ( win ) then
		-- 	-- 播放暴击特效
		-- 	win:play_cri_effect();
		-- end
		-- WingModel:updateWingLeftWin()
		-- WingModel:updateWingRightWin()
		-- WingModel:updateWingRightWin("LvUpSkillEffect")
		local win = UIManager:find_visible_window("wing_skill_win")
		if win then
			win:update("skill_info")
			win:play_cri_effect();
		end
	end
end

-- 将翅膀转化为声望 
function WingModel:req_wing_to_shengwang( wing_guid, wing_stage)

	local function wing_to_exp( ... )
		WingCC:req_wing_to_exp(wing_guid)
	end
	local shengwang = WingConfig:get_changeRenown_by_stage( wing_stage )
	NormalDialog:show(LangModelString[480]..shengwang..LangModelString[481],wing_to_exp,1); -- [480]="此翅膀阶数小于已装配翅膀，是否将此翅膀转化为" -- [481]="声望?"
	
end

-- 请求升级翅膀
function WingModel:req_up_wing_level(if_selected)
	print(" req_up_wing_level if_selected=",if_selected)
	if WingModel:get_curr_wing_level() >= WingModel:get_max_win_level() then
		GlobalFunc:create_screen_notic(LangGameString[2196])
		return
	end
	if (WingModel:get_user_xb() < WingModel:need_xb_levelup_wing()) then
        -- print ("Error: 翅膀升级，仙币不足");
        -- GlobalFunc:create_screen_notic(LangModelString[147]); -- [147]="仙币不足"
        --天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	ConfirmWin2:show( nil, 13, Lang.screen_notic[11],  need_money_callback, nil, nil )

        return;
    end
    if (WingModel:get_curr_stage_max_level() == WingModel:get_curr_wing_level()) then
        -- print ("Error: 翅膀升级，已达到本阶最高等级，请先提升阶值.");
        GlobalFunc:create_screen_notic(LangModelString[482]); -- [482]="已达到本阶最高等级，请先提升品阶"
        return ;
    end
    local AutoBuy
    if if_selected == true then
    	AutoBuy = 1
    else
    	AutoBuy = 0
    end

    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local needItemId = WingModel:get_cur_level_crystal_item_id()
    local count = ItemModel:get_item_count_by_id(needItemId)
	--优先使用晶石提升
	if count > 0 then	
	 	WingCC:req_upgrade_wing(AutoBuy, money_type)
	elseif if_selected then
		--晶石不足时，如果勾选使用元宝
	 	local param = {AutoBuy, money_type}
	 	local upgrade_func = function( param )
	 		WingCC:req_upgrade_wing(param[1], param[2])
	 	end
	 	-- MallModel:handle_auto_buy( need_yb, upgrade_func, param )
	 	MallModel:handle_shopping_1( needItemId, 1, upgrade_func, param )
	 else
	 	WingCC:req_upgrade_wing(AutoBuy, money_type)
	end
end

-- 升级翅膀的回调
function WingModel:do_up_wing_level( result )
	-- local win = UIManager:find_visible_window("wing_uplevel_win");
	-- if win ~= nil then
	-- 	win:do_wing_level( result );
	-- end
	-- WingModel:updateWingLeftWin()
	-- WingModel:updateWingRightWin()
	-- if result == 1 then
	-- 	WingModel:updateWingRightWin("lvup_effect")
	-- end
	local win = UIManager:find_visible_window("wing_win")
	if win then
		win:update("up_lv")
		if result == 1 then
			win:update("up_lv_effect")
		end
	end
end

-- 翅膀的战斗力（评分）
function WingModel:do_assess( score )
	if _wing_item then 
		_wing_item.score = score;
	end
	
	-- local win = UIManager:find_visible_window("wing_uplevel_win");
	-- if win ~= nil then
	-- 	win:update_wing_fight_value();
	-- end

	-- win = UIManager:find_visible_window("wing_jinjie_win");
	-- if win ~= nil then
	-- 	win:update_wing_fight_value();
	-- end
	-- WingModel:updateWingLeftWin()
	-- WingModel:updateWingRightWin("fight")
	local win = UIManager:find_visible_window("wing_win")
	if win then
		win:update("fight")
	end	
end

-- 展示翅膀
function WingModel:send_wing_to_char( )
	
	local spriteInfo = string.format("%d%s%d%s%d%s%s%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
		ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
		ChatConfig.ChatAdditionInfo.TYPE_WING, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		_wing_item.stage, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
		Hyperlink:get_first_view_target(), Hyperlink:get_second_wing_target(),
		_wing_item.player_id, _wing_item.level, _wing_item.stage, _wing_item.star, _wing_item.score, _wing_item.modelId,
		_wing_item.wishes, _wing_item.attack, _wing_item.outDefence, _wing_item.inDefence, _wing_item.hp, _wing_item.skills_level[1],
		_wing_item.skills_level[2], _wing_item.skills_level[3], _wing_item.skills_level[4], _wing_item.skills_level[5],
		_wing_item.skills_level[6], _wing_item.skills_level[7], _wing_item.skills_level[8], _wing_item.skills_level[9]);

	ChatCC:send_chat(ChatModel:get_cur_chanel_select(), 0, spriteInfo);

end


-- 查看他人的翅膀
function WingModel:observed_other_wing( other_player )
	
	_other_player_info = other_player
	WingCC:req_lookup_info( _other_player_info.roleId, _other_player_info.roleName );

end

-- 获取查看他人翅膀时人物body
function WingModel:get_other_player_info(  )
	return _other_player_info.job.._other_player_info.sex.."00";
end



----------------------UI消息通知-----------------
-- 打开升级界面面
function WingModel:open_uplevel_win(  )
	-- local win = UIManager:find_visible_window("wing_sys_win");
	-- if win then
	-- 	win:selected_tab_button( 2 );
	-- end
	WingModel:openWingWin(WingModel.MINE_WING_INFO)
end

-- 打开进阶界面
function WingModel:open_jinjie_win(  )
	-- local win = UIManager:find_visible_window("wing_sys_win");
	-- if win then
	-- 	win:selected_tab_button( 3 );
	-- end
	WingModel:openWingWin(WingModel.WING_UPGRADE)
end

-- 卸下翅膀
function WingModel:take_off_wing(  )
	
	-- local player = EntityManager:get_player_avatar();
	-- player:take_off_wing();

	_wing_item = nil;
	
	-- print("_wing_item.stage=",_wing_item.stage)

end

-- 进阶界面 判断翅膀 声望是否足以升星
function WingModel:if_wing_can_shengjie( )
	local player_xb = EntityManager:get_player_avatar().bindYinliang
	local need_xb = WingModel:need_xb_upgrade_star()
	local need_renown = WingModel:need_renown_upgrade_star()
    local curr_renown = WingModel:get_user_renown()
    if (curr_renown >= need_renown) and (player_xb>=need_xb) and (_wing_item.stage < #std_wing.stages) then
    	return true
    end
    return false
end
-- 判断 技能能否升级  / 1技能对应羽翼卷轴是否有 / 2技能是否开启，等级大于0 / 3仙币是否足够
function  WingModel:if_wing_skill_can_upgrade( )
	local skills_level_t = WingModel:get_wing_item_data().skills_level
    local player_xb = EntityManager:get_player_avatar().bindYinliang
    for key,value in ipairs(std_wing.skill) do
    	-- print(key,value)
        local curr_skill_lv = skills_level_t[key]
        local book_count = WingModel:get_skill_book_count(key)  -- 获得该技能对应羽翼技能卷数量
        local need_xb = WingModel:get_xb_value_by_skill_index(key)
        -- print(curr_skill_lv,book_count,need_xb)
        -- 
        if (curr_skill_lv > 0 ) and curr_skill_lv < MAX_SKILL_LV and (book_count > 0) and (player_xb >= need_xb)  then
            return true
        end
    end
    return false
end
function WingModel:get_skill_upgrade_by_id( index )
	local skills_level_t = WingModel:get_wing_item_data().skills_level
	local player_xb = EntityManager:get_player_avatar().bindYinliang
	local curr_skill_lv = skills_level_t[index]
	local book_count = WingModel:get_skill_book_count(index)  -- 获得该技能对应羽翼技能卷数量
	local need_xb = WingModel:get_xb_value_by_skill_index(index)
	if (curr_skill_lv > 0) and (curr_skill_lv < MAX_SKILL_LV) and (book_count > 0) and (player_xb >= need_xb) then
		return true
    else
		return false
    end
end
-- 翅膀升级界面 判断 翅膀是否可以升星
function WingModel:if_wing_can_upgrade( )
	local crystal_count = WingModel:get_yuli_crystal_count() --从背包中获取当前阶的羽翼晶石数量
	if crystal_count > 0 then
		local player_xb = EntityManager:get_player_avatar().bindYinliang
		local need_xb = WingModel:need_xb_levelup_wing()
		if player_xb >= need_xb then 
		    local curr_lv = WingModel:get_curr_wing_level()
		    local max_lv  = WingModel:get_curr_stage_max_level()
		    if curr_lv < max_lv then 
		        return true
		    end
		end
	end
	return false
end


-- add by yongrui.liang at 2014-8-18

-- 当前左边窗口显示的页面
function WingModel:setCurLeftPage( page )
	WingModel.CURRENT_LEFT_PAGE = page
end

function WingModel:getCurLeftPage( )
	return WingModel.CURRENT_LEFT_PAGE
end

-- 当前右边窗口显示的页面
function WingModel:setCurRightPage( page )
	WingModel.CURRENT_RIGHT_PAGE = page
end

function WingModel:getCurRightPage( )
	return WingModel.CURRENT_RIGHT_PAGE
end

function WingModel:initWingWinInfo( )
	WingModel.CURRENT_LEFT_PAGE = WingModel.MINE_WING_INFO
	-- WingModel.IS_SHOW_OTHER_WING = false
	WingModel.SELECTED_WING_SKILL_ID = 1
	WingModel.CURRENT_RIGHT_PAGE = WingModel.MINE_WING_INFO
	WingModel.PLAY_UPGRADE_EFFECT = false
end

function WingModel:openWingWin( pageIndex )
	WingModel:changeLeftPage(pageIndex)
end

function WingModel:changeLeftPage( pageIndex )
	local win = UIManager:find_window("wing_win")
	if not win then
		win = UIManager:show_window("wing_win")
	end

	if WingModel.OTHER_WING_INFO == pageIndex then
		if win and win.update then
			win:update("other")
		end
	else
		if win and win.update then
			win:update("init")
		end
	end
end

function WingModel:changeRightPage( pageIndex )
	local win = UIManager:find_visible_window("wing_right_win")
	if not win then
		win = UIManager:show_window("wing_right_win")
	end
	if win and win.update then
		win:update(pageIndex)
	end
end

function WingModel:updateWingLeftWin( updateType )
	local win = UIManager:find_visible_window("wing_left_win")
	if win and win.update then
		win:update(updateType or "all")
	end
end

function WingModel:updateWingRightWin( updateType )
	local win = UIManager:find_visible_window("wing_right_win")
	if win and win.update then
		win:update(updateType or "all")
	end
end

function WingModel:getIsShowOtherWing( )
	return WingModel.IS_SHOW_OTHER_WING
end

function WingModel:setIsShowOtherWing( showOther )
	WingModel.IS_SHOW_OTHER_WING = showOther
end

function WingModel:setSelectedWingSkill( skillId )
	WingModel.SELECTED_WING_SKILL_ID = skillId
end

function WingModel:getSelectedWingSkill( )
	return WingModel.SELECTED_WING_SKILL_ID
end

function WingModel:setOtherWingData( data )
	_otherWingData = data
end

function WingModel:getOtherWingData( )
	return _otherWingData
end

function WingModel:showOtherWing( )
	-- WingModel:changeLeftPage(WingModel.OTHER_WING_INFO)
	local win = UIManager:find_window("wing_other_win")
	if not win then
		win = UIManager:show_window("wing_other_win")
	end

	if WingModel.OTHER_WING_INFO == pageIndex then
		if win and win.update then
			win:update("all")
		end
	end
end

function WingModel:getSkillLevelById( skillID )
	local wingData = WingModel:get_wing_item_data()
	return wingData.skills_level[skillID]
end

function WingModel:getOpenSkillByStage( stage )
	local skill = {}
	local openSkill = WingConfig:getOpenSkillByStage(stage)
	if openSkill then
		for i,v in ipairs(openSkill) do
			skill[v] = true
		end
	end
	return skill
end

-- 获取翅膀熟练度
function WingModel:getSkillExpById( skillID )
	local wingData = WingModel:get_wing_item_data()
	return wingData.skills[skillID].exp
end

function WingModel:setIsPlayUpgradeEffect( play )
	WingModel.PLAY_UPGRADE_EFFECT = play
end

function WingModel:getIsPlayUpgradeEffect( )
	return WingModel.PLAY_UPGRADE_EFFECT
end

function WingModel:setGotWingStatus( gotFree, gotVip )
	print('-------WingModel:setGotWingStatus------------gotFree, gotVip: ', gotFree, gotVip)
	WingModel.GOT_FREE_WING = (gotFree == 1) and true or false
	WingModel.GOT_VIP_WING = (gotVip == 1) and true or false
	WingModel:updateGotWingBtn()
end

function WingModel:getGotWingStatus( )
	return WingModel.GOT_FREE_WING, WingModel.GOT_VIP_WING
end

function WingModel:updateGotWingBtn( )
	if WingModel.GOT_FREE_WING and WingModel.GOT_VIP_WING then
		local win = UIManager:find_window( "right_top_panel" )
		if win then
			win:remove_btn(10)
		end
		UIManager:destroy_window("wing_get_win")
	else
		local win = UIManager:find_window( "right_top_panel" )
		if win then
			win:insert_btn(10)
		end
	end
end

function WingModel:updateWingGetWin( updateType )
	local win = UIManager:find_visible_window("wing_get_win")
	if win then
		win:update(updateType or "all")
	end
end

function WingModel:closeWingWin( )
	UIManager:destroy_window("wing_left_win")
	UIManager:destroy_window("wing_right_win")
end

-- after 天将雄狮
-- 设置选择的翅膀（第几阶）
function WingModel:set_cur_show_stage( index )
	WingModel.curShowStage = index
end

function WingModel:get_cur_show_stage()
	return  WingModel.curShowStage
end

-- 判断翅膀时候最高阶，最高星
function WingModel:is_max_stage_star()
	local max_stage = WingConfig:getMaxStageLevel( )
	return (WingModel:get_curr_wing_stage() == max_stage and WingModel:get_curr_wing_star() == 10)
end

function WingModel:is_max_stage()
	local max_stage = WingConfig:getMaxStageLevel( )
	return WingModel:get_curr_wing_stage() == max_stage or WingModel:get_curr_wing_stage() > max_stage
end

function WingModel:is_max_wing_level()
	local max_stage = WingConfig:getMaxStageLevel( )
	local max_level_max = WingConfig:getCurStageMaxLevel( max_stage )
	return (WingModel:get_curr_wing_level() == max_level_max )
end