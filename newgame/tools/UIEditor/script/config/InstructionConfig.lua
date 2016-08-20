-- InstructionConfig.lua
-- created by aXing on 2014-5-28
-- 新手引导客户端配置
require "../data/instructions_config"
InstructionConfig = {}
local _quest_to_instruction = nil

function InstructionConfig:get_auto_quest_time( )
	return instructions_config.auto_quest_time or 10
end

function InstructionConfig:get_auto_quest_level( )
	return instructions_config.auto_quest_level or 32
end

-- 第一次进入副本
function InstructionConfig:get_first_fuben_instruct( fuben_id )
	for k,v in pairs(first_fuben_instruct) do
		if v.fuben_id == fuben_id then
			return v.instruct_id
		end
	end
	return nil
end

function InstructionConfig:get_bisha_instruct( fuben_id )
	for k,v in pairs(bi_sha_instruct) do
		if v.fuben_id == fuben_id then
			return v
		end
	end
	return nil
end

-- 由于新手引导有任务选项，所以需要用任务id作为可选项进行搜索
local function sort_by_quest(  )
	if _quest_to_instruction ~= nil then
		return
	end
	_quest_to_instruction = {}

	for instruction_id,item in ipairs(instructions_config) do
		if item.quest_id ~= nil and item.quest_state ~= nil then
			local key = item.quest_id .. "," .. item.quest_state
			_quest_to_instruction[key] = instruction_id
		end
	end
end

-- 根据引导id获取引导配置
-- @param id 引导id
function InstructionConfig:get_instruction_by_id( id )
	local config = instructions_config[id]
	return config
end

-- 根据任务id获取引导配置 （配置可选项）
-- @param quest_id 任务id
-- @param quest_state 任务状态 (1=接任务后, 2=完成任务后)
function InstructionConfig:get_instruction_by_quest( quest_id, quest_state )
	if _quest_to_instruction == nil then
		sort_by_quest()
	end

	local key = quest_id .. "," .. quest_state
	local instruction_id = _quest_to_instruction[key]
	if instruction_id ~= nil then
		-- local config = self:get_instruction_by_id(instruction_id)
		return instruction_id
	end

	return nil
end

-- 根据引导id获取引导配置
-- @param id 引导id
function InstructionConfig:get_mini_task_instruction_by_task_id( qid )
	local _type = TaskModel:get_task_acceptType(qid)
	if _type == TYPE_YIJIE then
		local config = mini_task_instruction.acceptQuest[qid]
		return config
	elseif _type == TYPE_KEJIE then
		--local config = mini_task_instruction.acceptQuest[id]
		return nil
	end
end

function InstructionConfig:get_terminal_position_by_sys_id(sys_id)
	for k,v in pairs(instructions_config) do
		-- print(k,v,sys_id)
		if type(v) == 'table' and v[1] then
			for i, tab in ipairs(v) do 
				if tab.new_system then
					if tab.new_system == sys_id then
						-- print("v[1].mbx,v[1].mby",v[1].mbx,v[1].mby)
						return tab.mbx,tab.mby
					end 
				end
			end
		end
	end
	return nil
end