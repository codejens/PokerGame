-- AchieveModel.lua
-- created by charles on 2012-12-31
-- 成就数据模型

-- super_class.AchieveModel()
AchieveModel = {}
-- require "../data/achieve_group"
-- require "../data/std_achieves"
-- require "struct/UserAchieve"

local _user_achieve_list = {};			-- 玩家成就数据列表
local _config_point_total = 0;			-- 配置成就点总计
local _config_achieve_total = 0;		-- 配置成就数量统计
local _config_num_group = {};			-- 配置数量分组统计
local _user_point_group = {};			-- 玩家成就点分组统计
local _user_point_total = 0;			-- 玩家成就点总计
local _user_finish_group = {};			-- 玩家完成成就分组总计
local _user_finish_total = 0;			-- 玩家完成成就总计

-- 公有函数
-- added by aXing on 2013-5-25
function AchieveModel:fini( ... )
	_user_achieve_list = {};			-- 玩家成就数据列表
	_config_point_total = 0;			-- 配置成就点总计
	_config_achieve_total = 0;			-- 配置成就数量统计
	_config_num_group = {};				-- 配置数量分组统计
	_user_point_group = {};				-- 玩家成就点分组统计
	_user_point_total = 0;				-- 玩家成就点总计
	_user_finish_group = {};			-- 玩家完成成就分组总计
	_user_finish_total = 0;				-- 玩家完成成就总计
end

-- 设置成就数据
function AchieveModel:getAwardPoint( stdAchieve )
	for i,award in ipairs(stdAchieve.awards) do
		if award.type == 11 then
			return award.count;
		end
	end
	return 0;
end

-- 公有函数
-- 设置成就数据
function AchieveModel:init_achieve_info( pack )
	-- print("run init_achieve_info")
	local data = {};
	-- 初始化成就事件
	for i=1,256 do
		data[i] = pack:readByte();
	end
	local achieveEvent = {}
	local len = pack:readInt();
	for i=1,len do
		local eveid = pack:readWord()
		local num = pack:readInt()
		-- print("eveid,num", eveid, num)
		achieveEvent[eveid] = num
		--achieveEvent[pack:readWord()] = pack:readInt()
	end
	local configTotal = #AchieveConfig:get_achieve_total()
	-- print("成就配置长度", configTotal)
	len = math.ceil((configTotal+1) / 4)
	--print("len",len)
	local bt = 0
	local achieveNum = 0
	for i=1,len do
		bt = data[i];
		-- print("bt = ",bt)
		for j=0,3 do
			if achieveNum > 0 then
				if(achieveNum > configTotal) then
					break;
				end
				local userAchieve = UserAchieve();
				userAchieve.hasDone = ZXLuaUtils:band(ZXLuaUtils:rshift(bt, j * 2), 0x01);
				userAchieve.hasGetAwards = ZXLuaUtils:band(ZXLuaUtils:rshift(bt, j * 2 + 1), 0x01);
				-- print("userAchieve.hasDone",userAchieve.hasDone)
				-- print("userAchieve.hasGetAwards",userAchieve.hasGetAwards)
				local stdAchieve = AchieveConfig:get_achieve( achieveNum ) -- std_achieves[achieveNum];
				-- print("userAchieve.hasDone",userAchieve.hasDone)
				-- print("userAchieve.hasGetAwards",userAchieve.hasGetAwards)
				local condLen = #stdAchieve.conds;
				for k=1,condLen do
					userAchieve.condProgress[k] = achieveEvent[stdAchieve.conds[k].eventId] or 0;
				end
				-- print("achieveNum",achieveNum)
				_user_achieve_list[achieveNum] = userAchieve;
				-- print("achieveNum",achieveNum)
			end
			achieveNum = achieveNum + 1;
		end
	end
	---------
	---------
	local achieve_group = AchieveConfig:get_achieve_group(  )
	for i,group in ipairs(achieve_group) do
		_user_point_group[i] = 0;
		_user_finish_group[i] = 0;
		_config_num_group[i] = 0;
	end
	for i,userAchieve in ipairs(_user_achieve_list) do
		local groupId = AchieveConfig:get_achieve(i).groupId + 1 -- std_achieves[i].groupId + 1;
		--print("groupId",groupId)
		if groupId < 7 then
			_config_achieve_total = _config_achieve_total + 1;
			_config_num_group[groupId] = _config_num_group[groupId] + 1;
			local point = self:getAwardPoint(AchieveConfig:get_achieve(i));
			_config_point_total = _config_point_total + point;
			--print("_config_point_total",_config_point_total)
			--print("userAchieve.hasDone",userAchieve.hasDone)
			if userAchieve.hasDone > 0 then
				_user_finish_total = _user_finish_total + 1;
				_user_finish_group[groupId] = _user_finish_group[groupId] + 1;
				--print("userAchieve.hasGetAwards",userAchieve.hasGetAwards)
				if userAchieve.hasGetAwards > 0 then
					_user_point_group[groupId] = _user_point_group[groupId] + point;
					_user_point_total = _user_point_total + point;
				end
			end
		end
	end
	GoalModel:check_can_get_award_item()
end

local function dispatchEvent( event, achieveId )
	local win;
	if AchieveConfig:get_achieve(achieveId).groupId < 6 then
		-- print("run if ")
		win = UIManager:find_visible_window("achieve_win");
		if win then
			win:update( event );
		end
	else
		-- print("run else")
		win = UIManager:find_window("goal_win");
		if win then
			win:update_function(GoalModel.UpdateType.all)
			local goal_win = UIManager:find_visible_window("goal_win")
			if goal_win == nil then
				GoalModel:check_can_get_award_item()
			end
		end
	end
	-- print("win",win)
	-- if win then
	-- 	win:update( event );
	-- end
end

-- 公有函数
-- 完成一个成就
function AchieveModel:finish_achieve( achieveId )
	if achieveId >  GlobalConfig:get_begin_goal_target_index() and achieveId < GlobalConfig:get_begin_goal_target_index() + 7 then
		return
	end
	_user_achieve_list[achieveId].hasDone = 1;
	local groupId = AchieveConfig:get_achieve(achieveId).groupId + 1;
	-- TODO 更新统计信息
	if groupId < 7 then
		_user_finish_total = _user_finish_total + 1;
		_user_finish_group[groupId] = _user_finish_group[groupId] + 1;
	end
	dispatchEvent( "finishAchieve", achieveId );
	-- TODO 导航按钮显示


   --添加迷你按钮
    local achieveNum = AchieveModel:getAchieveExistNum()
    if achieveNum > 0 and EntityManager:get_player_avatar().level > 31 then
        local function openfun()
            UIManager:show_window("achieve_win")
        end
        MiniBtnWin:show(18, openfun, achieveNum )
    end

        
	--显示主界面完成成就提示框
	MenusPanel:setAchieveInfo(achieveId)
end

-- 公有函数
-- 成就事件触发
function AchieveModel:update_progress( achieveId, eventId, progress )
	print("achieveId, eventId, progress",achieveId, eventId, progress)
	if achieveId > GlobalConfig:get_begin_goal_target_index() and achieveId < GlobalConfig:get_begin_goal_target_index() + 7 then
		return
	end
	local index = -1
	local std_achieve = AchieveConfig:get_achieve(achieveId)
	for i, cond in ipairs(std_achieve.conds) do
		if cond.eventId == eventId then
			local max = std_achieve.conds[i].count;
			-- print("_user_achieve_list[achieveId].condProgress[i]",_user_achieve_list[achieveId].condProgress[i])			
			if progress > max then
				_user_achieve_list[achieveId].condProgress[i] = max;
			else
				_user_achieve_list[achieveId].condProgress[i] = progress;
			end
			dispatchEvent( "updateProgress", achieveId );
			break
		end
	end
end


function AchieveModel:get_award_item(achieveId)
	_user_achieve_list[achieveId].hasGetAwards = 1;
	local std_achieve = AchieveConfig:get_achieve(achieveId)
	local groupId = std_achieve.groupId + 1;
	-- print("groupId",groupId)
	-- print("achieveId",achieveId)
	if groupId < 7 then
		local point = self:getAwardPoint(std_achieve);
		_user_point_total = _user_point_total + point;
		_user_point_group[groupId] = _user_point_group[groupId] + point;
		dispatchEvent( "getAward", achieveId );
	else
		local win = UIManager:find_visible_window("goal_win");
		if win then
			win:update_function( GoalModel.UpdateType.all );
		end
	end
end
-- 公有函数
-- 领取成就奖励
function AchieveModel:get_award( achieveId )
	print("AchieveModel:get_award achieveId",achieveId)
	local goal_page_award_index = GlobalConfig:get_begin_goal_target_index()
	if achieveId > goal_page_award_index and achieveId < goal_page_award_index + 7 then
		local temp_page_select = achieveId - goal_page_award_index
		local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
		local temp_max_num = #achieve_group
		for i = 1, temp_max_num do
			local curid = achieve_group[ i ]
			AchieveModel:get_award_item(curid)
		end	
	else
		AchieveModel:get_award_item(achieveId)
	end
end

-- 公有函数
function AchieveModel:getUserAchieve( achieveId )
	return _user_achieve_list[achieveId];
end

-- 公有函数
function AchieveModel:getConfigAchievePoint()
	return _config_point_total;
end

-- 公有函数
function AchieveModel:getUserAchievePoint( groupId )
	if groupId then
		return _user_point_group[groupId];
	else
		return _user_point_total;
	end
end

-- 公有函数
function AchieveModel:getUserFinishNum( groupId )
	if groupId then
		return _user_finish_group[groupId];
	else
		return _user_finish_total;
	end
end

-- 公有函数
function AchieveModel:getConfigAchieveNum( groupId )
	if groupId then
		return _config_num_group[groupId];
	else
		return _config_achieve_total;
	end
end

-- 公有函数
function AchieveModel:getUserAchieveProgress( achieveId )
	return _user_achieve_list[achieveId].condProgress[1];
end

-- 公有函数
function AchieveModel:getAchieveTargetCount( achieveId )
	return AchieveConfig:get_achieve(achieveId).conds[1].count;
end

------------------
function AchieveModel:isExistGetAward()
	for i,userAchieve in ipairs(_user_achieve_list) do
		local groupId = AchieveConfig:get_achieve(i).groupId + 1
		if groupId < 7 then
			if userAchieve.hasDone >= 1 and userAchieve.hasGetAwards <= 0 then
				return true
			end
		end
	end
	return false
end
------------------
function AchieveModel:getAchieveExistNum()
	local curNum = 0
	for i,userAchieve in ipairs(_user_achieve_list) do
		local groupId = AchieveConfig:get_achieve(i).groupId + 1
		if groupId < 7 then
			if userAchieve.hasDone >= 1 and userAchieve.hasGetAwards <= 0 then
				curNum = curNum + 1
			end
		end
	end
	return curNum
end
--可领取的成就组数
function AchieveModel:getAchieveExistGroup()
	local group = {}
	for i,userAchieve in ipairs(_user_achieve_list) do
		local groupId = AchieveConfig:get_achieve(i).groupId + 1
		if groupId < 7 then
			if userAchieve.hasDone >= 1 and userAchieve.hasGetAwards <= 0 then
				group[groupId] = true
			end
		end
	end
	return group
end