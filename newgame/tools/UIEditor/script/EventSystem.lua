EventSystem = {}

EventActionSystem = {}

local _first = true

local function _movieActionHandler(subEvent_id, params)
	local movie_id = params[1]
	Cinema:init()
	local function _endOfMovie()
		EventSystem.postEvent('endOfMovie', movie_id)
	end 
	Cinema:play(movie_id,_endOfMovie,true)
end

local function _showUIActionHandler(subEvent_id,params)
	UIManager:show_window(params[1])
end

-- 执行任务 quest_type 1 = 已接任务，quest_type 2= 可接任务
local function _doQuestActionHandler(subEvent_id,params)
	AIManager:do_quest( params[1], params[2] );
end

local function _finishLoadingActionHandler(subEvent_id,params)
    if EventSystem.newGame then 
        EventSystem.postEvent('newGame', nil )
        EventSystem.newGame = false
    end
    if EventSystem.sceneInfo then
    	local _info = EventSystem.sceneInfo
    	if _info.fb_id == 0 then
    		EventSystem.postEvent('enterScene', _info.scene_id )
    	else
    		EventSystem.postEvent('enterFB', _info.fb_id )
    	end
    end
    EventSystem.sceneInfo = nil

    if EventSystem.firstFubenInfo then
    	local _info = EventSystem.firstFubenInfo
    	EventSystem.postEvent('firstEnterFB', _info.fuben_id )
    end
    EventSystem.firstFubenInfo = nil
end

-- 进入新手引导
local function _instructionActionHandler( subEvent_id, params )
	local instruction_id = params[1]
	local function _endOfInstruction()
		EventSystem.postEvent('endOfInstruction', instruction_id)
	end
	--梦境指引特殊处理
	if instruction_id == 11 then
		local vip_info = VIPModel:get_vip_info()
		if vip_info.level >= 6 then
			instruction_id = 31
		elseif vip_info.level >= 4 then
			instruction_id = 19
		end
	--翅膀指引特殊处理(已开启后不弹指引)
	elseif instruction_id == 25 and GameSysModel:isSysEnabled( GameSysModel.WING, false ) then
		return 
	end
	-- 美人图谱指引特殊处理 和压屏剧情一起出现
	-- if instruction_id == 33 then
	-- 	Cinema:play('act39', function() print('the end') end)
	-- end
	Instruction:start( instruction_id, _endOfInstruction )
end

-- 开启新系统
local function _openSystemHandler( subEvent_id, params )
	local sys_id = params[1]
	Instruction:open_new_sys(sys_id)
end

local function _askNpc(subEvent_id, params)
	local scene_name, npc_name, quest_id = params[1], params[2], params[3]
	local quest_info = TaskModel:get_info_by_task_id( quest_id );
	local tab_target = quest_info.target;
	-- 在寻找副本NPC时,只有在任务已接且未完成才会去寻找NPC
	if #tab_target == 0 then return end
	-- 判断任务是否已完成
	local curr_process_value = TaskModel:get_process_value(quest_id );
	if ( curr_process_value == nil ) then
        curr_process_value = 0;
    end
    if curr_process_value >= tab_target[1].count then return end
	local scene_id = SceneConfig:get_id_by_name(scene_name)
	GlobalFunc:ask_npc(scene_id, npc_name)
end

local _EVENT_ACTION_MAP =
{
	['movie'] 	= _movieActionHandler,
	['showUI'] 	= _showUIActionHandler,
	['doQuest'] = _doQuestActionHandler,
	['finishLoading'] = _finishLoadingActionHandler,
	["instruction"] = _instructionActionHandler,
	["openSystem"] = _openSystemHandler,
	['askNpc']	= _askNpc
}

--事件系统，用于通知
function EventSystem.init()
	if _first then

--		reload('../data/movie/movie_actors')
		reload('../data/movie/movie_dialogs')
		reload('../data/movie/movie_scenes')
		reload('../data/movie/movie_config')
		
		reload('movie/movieUtils')
		reload('movie/movieDialog')
		reload('movie/movieActions')
		reload('movie/movieActors')
		reload('movie/movieActorManager')
		reload('movie/movieEvent')
		reload('movie/cinema')

		EventSystem._eventHappened = {}
		EventActionSystem:init()
	end
	_first = false
end

function EventSystem.quit()
	EventSystem._eventHappened = {}
end


function EventSystem.setParam(key,value)
	print('EventSystem.setParam',key,value)
	EventSystem[key] = value
end

function EventSystem.postEvent(event_id, event_sub_id)
--[[
	local listeners = EventSystem._listener[event_id]
	for i,handler in ipairs(listeners) do
		handler(event_id,event_sub_id)
	end
]]--
	print('EventSystem.postEvent',event_id, event_sub_id)
	EventActionSystem:onEvent(event_id, event_sub_id)
end

function EventSystem.addListener(event_id, event_handler)
--[[	local listeners = EventSystem._listener[event_id]
	if not listeners then
		listeners = { event_handler }
	else
		listeners[#listeners+1] = event_handler
	end
	EventSystem._listener[event_id] = listeners
	]]--
end

function EventSystem.removeListener(event_id, event_handler)


end


function EventActionSystem:init()
	require '../data/event_config'
	self._eventActions = {}
	self._happened = {}

	for k, event in pairs(event_config) do
		--抽取事件的subEvent
		local subEventActions = {}

		self._happened[k] = {}
		for event_sub_id, subEvents  in pairs(event) do
			local actionFuncs = {}
			for i, act in ipairs(subEvents) do
				--指定函数
				actionFuncs[i] = bind(_EVENT_ACTION_MAP[act.action],event_sub_id,act.params)
			end
			subEventActions[event_sub_id] = actionFuncs

			--只触发一次
			self._happened[k][event_sub_id] = true
		end
		self._eventActions[k] = subEventActions
	end

end


function EventActionSystem:onEvent(event_id, event_sub_id)
	print('EventActionSystem:onEvent',event_id,event_sub_id)
	event_sub_id = event_sub_id or 1
	local event = self._eventActions[event_id]
	if event then
		local actions  = event[event_sub_id]
		if actions then
			for i, act_func in ipairs(actions) do
				act_func()
			end
		end
	end
end