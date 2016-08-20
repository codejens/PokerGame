----HJH
----2013-4-12
------------------目标系统model
GoalModel = {}
------------------
GoalModel.UpdateType = {
	all = 1,
	scroll = 2,
	process = 3,
	reward_item = 4,
	notic = 5,
	page_index = 6,
}
------------------
local _cur_page_select = 1
local _cur_award_select = 1
--local _gola_page_info = { }
local _reinit = true
------------------
function GoalModel:fini()
	_reinit = false
	-- _gola_page_info = nil
	-- _gola_page_info = {}
end
------------------
function GoalModel:get_reinit()
	return _reinit
end
------------------
function GoalModel:reinit_panel_info()
	_reinit = true 
	_cur_page_select = 1
	_cur_award_select = 1
end
------------------
function GoalModel:set_cur_page_select(index)
	_cur_page_select = index
end
------------------
function GoalModel:get_cur_page_select()
	return _cur_page_select
end
------------------
function GoalModel:set_cur_award_select(index)
	_cur_award_select = index
end
------------------
function GoalModel:get_cur_award_select()
	return _cur_award_select 
end
------------------
function GoalModel:slot_btn_fun(index, world_pos)
	local temp_page_select = GoalModel:get_cur_page_select()
	local temp_award_select = GoalModel:get_cur_award_select()
	local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
	local curid = achieve_group[ temp_award_select ]
	local temp_award_index = GlobalConfig:get_begin_goal_target_index() + temp_page_select
	print("GoalModel:slot_btn_fun temp_page_select,temp_award_select,curid", temp_page_select,temp_award_select,curid)
	local std_achieve = AchieveConfig:get_achieve( temp_award_index )
	--local achieve = AchieveModel:getUserAchieve( curid )
	print("GoalModel:slot_btn_fun index,#std_achieve.awards", index, #std_achieve.awards)
	if index <= #std_achieve.awards then
		print("std_achieve.awards[index].type",std_achieve.awards[index].type, world_pos.x, world_pos.y)
		if std_achieve.awards[index].type == 0 then
			TipsModel:show_shop_tip( world_pos.x, world_pos.y, std_achieve.awards[index].id )
		else
			local temp_type = std_achieve.awards[index].type - 5
			local temp_data = { item_id = temp_type, item_count = std_achieve.awards[index].count }
			TipsModel:show_money_tip( world_pos.x, world_pos.y, temp_data )
		end
	end
end
------------------
function GoalModel:get_btn_fun()
	local temp_page_select = GoalModel:get_cur_page_select()
	-- local temp_award_select = GoalModel:get_cur_award_select()
	-- local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
	-- local curid = achieve_group[ temp_award_select ]
	-- local achieve = AchieveModel:getUserAchieve( curid )
	local temp_award_index = GlobalConfig:get_begin_goal_target_index() + temp_page_select
	--print("achieve.hasDone,achieve.hasGetAwards",achieve.hasDone,achieve.hasGetAwards)
	local page_award_state = GoalModel:check_cur_page_award_state()
	print("page_award_state",page_award_state)
	if page_award_state.finish == true and page_award_state.get_award == false then
		AchieveCC:get_award( temp_award_index )
	end
end
------------------
function GoalModel:check_cur_page_award_state(index)
	local temp_page_select = GoalModel:get_cur_page_select()
	if index ~= nil then
		temp_page_select = index
	end
	local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
	local temp_max_num = #achieve_group
	local cur_finish_num = 0
	local cur_get_award_num = 0
	for i = 1, temp_max_num do
		local curid = achieve_group[ i ]
		local achieve = AchieveModel:getUserAchieve( curid )
		--print("GoalModel:check_cur_page_award_state curid, achieve.hasDone, achieve.hasGetAwards",curid, achieve.hasDone, achieve.hasGetAwards)
		if achieve.hasDone > 0 then
			cur_finish_num = cur_finish_num + 1
		end
		if achieve.hasGetAwards > 0 then
			cur_get_award_num = cur_get_award_num + 1
		end
	end
	--print("GoalModel:check_cur_page_award_state cur_finish_num, cur_get_award_num", cur_finish_num, cur_get_award_num)
	local finish = false
	local get_award = false
	if cur_finish_num >= temp_max_num then
		finish = true
	end
	if cur_get_award_num >= temp_max_num then
		get_award = true
	end
	--print("GoalModel:check_cur_page_award_state finish, get_award", finish, get_award)
	return { finish = finish , get_award = get_award  }
end
------------------
function GoalModel:check_level(index)
	local player = EntityManager:get_player_avatar()
	if index == 1 and player.level >= 1 then
		return true
	elseif index == 2 and player.level >= 30 then
		return true
	elseif index == 3 and player.level >= 40 then
		return true
	elseif index == 4 and player.level >= 50 then
		return true
	elseif index == 5 and player.level >= 60 then
		return true
	end
	return false
end
------------------
function GoalModel:check_can_get_award_item()
	-- print("run GoalModel:check_can_get_award_item========================== ")
	for i = 1, 5 do
		local cur_page_award_info = GoalModel:check_cur_page_award_state(i)
		if cur_page_award_info.finish == true and cur_page_award_info.get_award == false then
			local function open_fun()
				UIManager:show_window("goal_win")
			end
			-- MiniBtnWin:show(21, open_fun)
			return
		end
	end
end

-- curstate, achieveid,
-- local _gola_page_info = { }
-- ------------------
-- -- page_item_cur_select
-- local _gola_page_item_select = { 1, 1, 1, 1, 1 }
-- ------------------
-- local _cur_left_page_lua_target = nil
-- local _cur_right_page_lua_target = nil
-- ------------------
-- -- added by aXing on 2013-5-25
-- function GoalModel:fini( ... )
-- 	_gola_page_info = { }
-- 	_gola_page_item_select = { 1, 1, 1, 1, 1 }
-- 	_cur_left_page_lua_target = nil
-- 	_cur_right_page_lua_target = nil
-- end
-- ------------------
-- function GoalModel:add_page_item_info(index, info)
-- 	_gola_page_item_select[index] = info
-- end
-- ------------------
-- function GoalModel:get_page_item_info(index)
-- 	return _gola_page_item_select[index]
-- end	
-- ------------------
-- function GoalModel:add_page_info(info)
-- 	for i = 1, #_gola_page_info do 
-- 		if _gola_page_info[i].achieveId == info.achieveId then
-- 			return
-- 		end
-- 	end
-- 	table.insert(_gola_page_info, info)
-- end
-- ------------------
-- function GoalModel:change_page_info(info)
-- 	for i = 1, #_gola_page_info do
-- 		if _gola_page_info[i].achieveId == info.achieveId then
-- 			_gola_page_info[i] = info
-- 			return
-- 		end
-- 	end
-- end
-- ------------------
-- function GoalModel:get_page_info(id)
-- 	for i = 1, #_gola_page_info do
-- 		if _gola_page_info[i].achieveId == id then
-- 			return _gola_page_info[i]
-- 		end
-- 	end	
-- 	return nil
-- end
-- ------------------
-- function GoalModel:exit_function()
-- 	UIManager:hide_window("goal_win")
-- end
-- ------------------
-- function GoalModel:scroll_page_create_function(index)
-- 	--profiler.start()
-- 	------------------
-- 	local player = EntityManager:get_player_avatar();
--     local page_num = 1;
--     if player.level > 60 then
--         page_num = 5;
--     elseif player.level > 50 then
--         page_num = 4;
--     elseif player.level > 40 then
--         page_num = 3;
--     elseif player.level > 30 then
--         page_num = 2;
--     end
-- 	------------------
-- 	local goal_win = UIManager:find_window("goal_win")
-- 	------------------
-- 	if goal_win ~= nil then 
-- 		goal_win:set_cur_page( index  )
-- 		goal_win:set_scroll_max(page_num)
-- 	end
-- 	------------------
-- 	local scroll_info = { width = 760 - 40, height = 429 - 60 }--goal_win:get_scroll_info()
-- 	local base_panel = List:create(nil, 0, 0, scroll_info.width, scroll_info.height, 1, 1)
-- 	------------------
-- 	local gap_size = 10
-- 	local groupId = index + 6 + 1
-- 	local group = AchieveConfig:get_achieve_group()[groupId]
-- 	local achieveiId = 100
-- 	------------------
-- 	local title = Image:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.achieveAndGoal .. "chapter_" .. index + 1 .. ".png" )
-- 	local title_size = title:getSize()
-- 	title:setPosition( gap_size, scroll_info.height - title_size.height )
-- 	local title_pos = title:getPosition()
-- 	------------------
-- 	local notic_info = Dialog:create( nil, 0, 0, scroll_info.width - gap_size * 2 - 20, 80, ADD_LIST_DIR_UP, 100 )
-- 	notic_info.view:setFontSize(12)
-- 	notic_info:setText(group.desc)
-- 	local notic_info_size = notic_info:getSize()
-- 	notic_info:setPosition( gap_size + 10, title_pos.y - notic_info_size.height	-10)
-- 	local notic_info_pos = notic_info:getPosition()
-- 	------------------
-- 	local notic_bg = Image:create( nil, gap_size, notic_info_pos.y, notic_info_size.width + 15, notic_info_size.height, UIResourcePath.FileLocate.common .. "nine_grid_bg.png", 600, 600 )
-- 	local notic_bg_pos = notic_bg:getPosition()
-- 	------------------
-- 	local right_page = GoalRightPage( "", UIResourcePath.FileLocate.common .. "nine_grid_bg.png", gap_size + 325 + 10, notic_bg_pos.y - 245 - 10, 360,245 )
-- 	------------------
-- 	local left_page = GoalLeftPage( "", UIResourcePath.FileLocate.common .. "nine_grid_bg.png", gap_size, notic_bg_pos.y - 245 - 10, 325, 245 , right_page )
-- 	------------------
-- 	base_panel:addChild(notic_bg)
-- 	base_panel:addChild(title)
-- 	base_panel:addChild(notic_info)
-- 	base_panel:addChild(left_page)
-- 	base_panel:addChild(right_page)
-- 	------------------
-- 	_cur_left_page_lua_target = left_page
-- 	_cur_right_page_lua_target = right_page
-- 	--profiler.stop()
-- 	return base_panel
-- end
-- ------------------
-- function GoalModel:update_cur_page_info()
-- 	print("_cur_left_page_lua_target",_cur_left_page_lua_target)
-- 	print("_cur_right_page_lua_target",_cur_right_page_lua_target)
-- 	if _cur_left_page_lua_target ~= nil and _cur_right_page_lua_target ~= nil then
-- 		_cur_left_page_lua_target.scroll:clear()
-- 		_cur_left_page_lua_target.scroll:refresh()
-- 	end
-- end