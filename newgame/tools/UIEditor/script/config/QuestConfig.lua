-- QuestConfig.lua
-- create by hcl on 2013-1-17
-- 任务系统 config

-- super_class.QuestConfig();

QuestConfig = {}

--记录所有quest，分类
local quest_table = {}
local prefix = "../data/"
local data_name = "std_quest"
--[[
 starid = 2, 就是护送任务
]]

QuestConfig.QUEST_PROTECTION = 2
--读取item表
local function load_quest_config( quest_id )
	--获取主index
	local index = math.floor(quest_id / 100)			-- 这个步长是根据拆分文件大小少于100kb来划分的，
														-- 如果需要改这个步长，则必须把打包文件也一齐修改了
	--检索读过没有
	local config = quest_table[index]
	--读取
	if not config then
		local config_index = data_name .. index
		local file = prefix .. config_index
		require(file)
		--从全局表检索
		config = _G[config_index]
		--记录
		quest_table[index] = config
	end
	return config[quest_id]
end

-- 根据id取得任务信息
function QuestConfig:get_quest_by_id(quest_id)
	return load_quest_config( quest_id )
end

-- 判断任务是否需要新手指引
function QuestConfig:get_is_need_xszy( quest_id )
	local quest_info = QuestConfig:get_quest_by_id(quest_id)
	--print("quest_info.xszy = ",tostring(quest_info.xszy));
	if ( quest_info.xszy ) then
		return true;
	end
	return false;
end

-- 取得任务类型
function QuestConfig:get_quest_type( quest_id )
	--print("quest_id = ",quest_id);
	local quest_info = QuestConfig:get_quest_by_id(quest_id)
	return quest_info.type ;
end
--取得可学习技能
function QuestConfig:get_can_learn_jineng( quest_id,job_id )
	local quest_info = QuestConfig:get_quest_by_id(quest_id)
	local can_learn_skill_info = {}
	if quest_info.skill then 
		--寻找对应职业可以学习的技能
		for i=1,#quest_info.skill do 
			if (quest_info.skill[i].job == job_id) and (quest_info.skill[i].skill_id ~= -1) then 
				can_learn_skill_info.skill_id = quest_info.skill[i].skill_id
				can_learn_skill_info.skill_icon = quest_info.skill[i].skill_icon
			end 
		end 
	end 
	return can_learn_skill_info
end