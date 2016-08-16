EventSystem = {}

EventActionSystem = {}

local _first = true

local function _movieActionHandler(subEvent_id, params)
	-- 这个是区分是接受任务，完成任务，还是任务进行中的字段
	local movie_type = params[1]

	-- print("&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%%%", subEvent_id, params, movie_type)
	Cinema:init()
	local function _endOfMovie()
		EventSystem.postEvent('endOfMovie', movie_type)
		--以后应该要在这里向服务器发送一条协议，接任务和完成任务应该都是在这里发送，先记录一下下 By FJH
		local tab = TaskModel:getTalkToNpcData()
		-- 传入handle, 内容
		-- tab[1] 是NPCID, tab[2] 是任务ID， tab[3]是只有和有任务相关联的NPC对话才会有的， tab[4]是对话类型
		-- 这里应该要判断一下，只有在   可接任务  和 完成任务 的情况下才继续发送消息
		-- printc("_endOfMovie,对话完后调用的回调判断", tab[3], tab[2], tab[5], tab[4],13)
	    
	    --是否能在这里关闭下界面
	           --如果页面没有被顶掉只是被其他页面盖住 move事件一直吃不掉 却又吃掉了end事件
        local  win = UIManager:find_visible_window("chat_win")
        if win then
        	local  input_panel = win.chat_input_edit
        	    input_panel:set_can_record(true)
        	    input_panel:clear_chat_time()
        	    if input_panel.hitPanel then
                	input_panel.hitPanel:setIsVisible(false)
                	input_panel.hitPanel2:setIsVisible(false)
                	input_panel.hitPanel3:setIsVisible(false)
                	input_panel.hitPanel4:setIsVisible(false)
                end
                input_panel:clear_chat_time()
                input_panel:set_cancel_isvisitable(false)
                --还原音量
                SoundManager:chat_back_effct(  )
        end


		--如果是组队状态按钮给其他页面顶掉
        local  win = UIManager:find_visible_window("menus_panel")
        if win then
        	    if win.hitPanel then
                	win.hitPanel:setIsVisible(false)
                	win.hitPanel2:setIsVisible(false)
                	win.hitPanel3:setIsVisible(false)
                	win.hitPanel4:setIsVisible(false)
                end
                win:clear_chat_time()
                win:set_can_record(true)
                win:set_cancel_isvisitable(false)
                -- --还原音量
                SoundManager:chat_back_effct(  )
        end


        -- 如果是捕抓任务，或者是护送任务，则对话完就销毁实体
		local taskId = tonumber(tab[2])
		if taskId then
			local task_info = TaskModel:get_info_by_task_id(tonumber(taskId))
			if TaskModel:is_BuZhua(taskId) or (task_info.playType and task_info.playType[1] == 9 and task_info.target[1].id == tonumber(tab[1])) then
				TaskModel:delete_model_tab(taskId)
			end
		end


		printc("taskId==========tab[3]=====>>>>>>", taskId, tab[3], 13)

		if tab[3] == "0" then
			GameLogicCC:req_talk_to_npc( tab[5], tab[4] )
			local quest_info = TaskModel:get_info_by_task_id(tonumber(tab[2] ))

			-- printc("EventSystem==========>>>>>>>>>>>>", quest_info, quest_info.type, tab[2], 14)
			-- 如果是跑环任务，接到任务之后自动做
			if quest_info and quest_info.type == 7 then
				AIManager:do_quest(tonumber(tab[2] ), 1, nil)
			-- 如果是黄榜任务，接到任务之后自动做
			elseif quest_info and quest_info.type == 8 then
				AIManager:do_quest(tonumber(tab[2] ), 1, nil)
					
			end
		elseif tab[3] == '1' then
--			print("做了tab[3] == '1111111111111111'")

			GameLogicCC:req_talk_to_npc(tab[5], tab[4])
		elseif tab[3] == '3' then
			-- 特殊玩法，中需要寻找多个目标的的任务在对话完之后自动寻路到下一个  By FJH
			local taskId = tonumber(tab[2])
			local npcId = tonumber(tab[1])
			-- 如果是悬赏任务，跟NPC对话完了并没有立即完成任务，所以tab[3]会有值，这时候不能继续do_quest
			-- 这里如果是悬赏任务，并且已经完成了，则直接返回
			local task_info = TaskModel:get_info_by_task_id(tonumber(taskId))
			if task_info.playType and task_info.playType[1] and task_info.playType[1] == 3 and task_info.type ~= 3 then
--				print("完成了悬赏任务中的对话任务，直接return掉")
				if task_info.target and #task_info.target > 1 then
                    local process = TaskModel:get_process_value(taskId, true, true);
                    -- printc("is_multiply_target_task_finish", TaskModel:is_multiply_target_task_finish(process, taskId), 14)
                    if TaskModel:is_multiply_target_task_finish(process, taskId) then
                        AIManager:do_quest( tonumber(taskId) , 1 , nil )
                        return
                    end
                    -- return
                else
                	-- printc("is_task_finished", TaskModel:is_task_finished(taskId), 14)
                    if TaskModel:is_task_finished(taskId) then
                    	AIManager:do_quest( tonumber(taskId) , 1 , nil )
                        return                   
                    end
                end
    			return
			end
--			print(" 特殊玩法，中需要寻找多个目标的的任务在对话完之后自动寻路到下一个", tab[2])
			-- 如果是特殊玩法追捕，并且对话的就是后端设定的NPC，则不继续寻路，而是直接去甘那只怪
			if task_info.playType and task_info.playType[1] == 6 then
				if TaskModel:is_zhuibu_npc(npcId, taskId) then
					local player = EntityManager:get_player_avatar()
					local handle = TaskModel:get_monster_handle_by_taskId(taskId)
					local entity = EntityManager:get_entity(handle)
					player:set_target(entity)
					AIManager:set_state( AIConfig.COMMAND_GUAJI )
					return
				end
			end

			if task_info.type == 4 then
				return
			end


			AIManager:do_quest( tonumber(taskId) , 1 , nil )
			printc("做了AIManager:do_quest=======>>>>", tonumber(taskId), 13)
		end
--		print( "---------_endOfMovie")
	
		
		-- 此方法，主要是重置会显示玩家和伙伴的显示状态(bug:伙伴不会显示)  by chj @2016-1-4 for shj
		-- 为什么伙伴不会显示，玩家会显示：玩家在创建的时候，多了一步系统设置检测，重现设置回显示状态
		movieEventGroup:movie_dialog_endcall()
	end 
	Cinema:play(movie_type,_endOfMovie,true, true)
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
	-- 	Cinema:play('act39', function() --print('the end') end)
	-- end
	-- Instruction:start( instruction_id, _endOfInstruction )
end

-- 开启新系统
local function _openSystemHandler( subEvent_id, params )
	local sys_id = params[1]
	-- Instruction:open_new_sys(sys_id)
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
		reload('../data/movieclient/movie_actors')
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

		--客户端自主剧情副本
		reload('model/SMovieClientModel')
		reload('movieclient/MovieClientDialog')

		-- 当前用于测试对话任务的对话内容，包括接受任务，未完成任务，和完成任务
		reload('../data/movie/get_task_dialog')
		reload('../data/movie/finish_task_dialog')
		reload('../data/movie/unfinished_task_dialog')
		reload('../data/movie/normal_talk_dialog')
		reload('../data/movie/fuben_dialog')



		EventSystem._eventHappened = {}
		EventActionSystem:init()
	end
	_first = false
end

function EventSystem.quit()
	EventSystem._eventHappened = {}
end


function EventSystem.setParam(key,value)
	--print('EventSystem.setParam',key,value)
	EventSystem[key] = value
end

function EventSystem.postEvent(event_id, event_sub_id,is_shj, severData)
--[[
	local listeners = EventSystem._listener[event_id]
	for i,handler in ipairs(listeners) do
		handler(event_id,event_sub_id)
	end
]]--
    --如果是山海经 需要对应的model层来对应处理
    if is_shj then 
    	
    else
    	--print('EventSystem.postEvent',event_id, event_sub_id)
    	-- severData包含NPC状态，任务ID等信息，具体看0, 5协议
--print( "------event_id-",event_id, event_sub_id,is_shj, severData)

	-- printc("EventSystem.postEvent", event_id, event_sub_id, 3)
    	local data = serverData
    	if data then
	    	EventActionSystem:onEvent(event_id, event_sub_id, data)
		else
			EventActionSystem:onEvent(event_id, event_sub_id)
		end
    end
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


function EventActionSystem:onEvent(event_id, event_sub_id, severData)
-- print( "======", event_id, event_sub_id, severData)
	event_sub_id = event_sub_id or 1
	-- for k, v in pairs(self._eventActions) do
	-- 	print( k, v, event[event_id])
	-- end
	local event = self._eventActions[event_id]
--	print( "====event====================================", event)

	if event then
		local actions  = event[event_sub_id]
		if actions then
			for i, act_func in ipairs(actions) do

				act_func()
			end
		end
	end
end