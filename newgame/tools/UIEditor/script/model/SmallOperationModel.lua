-- SmallOperationModel.lua
-- 小型运营活动面板 model 

SmallOperationModel = {}


-- 子活动id 
SmallOperationModel.SUB_ACTIVITY_1 = 1-- 1.登陆活动
SmallOperationModel.SUB_ACTIVITY_2 = 2-- 2.充值活动,多礼包
SmallOperationModel.SUB_ACTIVITY_3 = 3-- 3.消费活动,多礼包
SmallOperationModel.SUB_ACTIVITY_4 = 4-- 4.每日充值,单礼包
SmallOperationModel.SUB_ACTIVITY_5 = 5-- 5.每日消费,单礼包
SmallOperationModel.SUB_ACTIVITY_6 = 6-- 
SmallOperationModel.SUB_ACTIVITY_7 = 7-- 7.充值活动,重复单礼包
SmallOperationModel.SUB_ACTIVITY_8 = 8-- 8.消费活动,重复单礼包
SmallOperationModel.SUB_ACTIVITY_9 = 9-- 9.每日充值,多礼包
SmallOperationModel.SUB_ACTIVITY_10 = 10-- 10.每日消费,多礼包

-- 活动类型
local _operation_act_type = SmallOperationModel.ACT_TYPE_NULL;
local _operation_act_sub_type = SmallOperationModel.ACT_TYPE_NULL;
local _current_act_data = nil;		--当前活动数据，每个活动时间必须是互斥的。
local _act_time_dict = {};				--活动剩余时间
local _activity_start_end_time_t = {}   -- 活动的开始和结束时间  以 "start_time"  "end_time" 作为key获取  -- by lyl
local _act_time_id = {};

function SmallOperationModel:fini(  )
	_operation_act_type = SmallOperationModel.ACT_TYPE_NULL;
	_operation_act_sub_type = SmallOperationModel.ACT_TYPE_NULL;
	_current_act_data = nil;
	_act_time_dict = {};
	_act_time_id = {};
end

------------------------------
-- 活动类型
function SmallOperationModel:set_operation_act_type( type,sub_type )
	_operation_act_type = type;
	_operation_act_sub_type = sub_type;
end

function SmallOperationModel:get_operation_act_type(  )
	return _operation_act_type;
end

function SmallOperationModel:get_operation_act_sub_type()
	return _operation_act_sub_type;
end

-- 活动数据
function SmallOperationModel:get_current_act_data( )
	return _current_act_data ;
end

-- 插入活动时间
function SmallOperationModel:add_act_time( act_id, act_end_time )
	local time = act_end_time + MINI_DATE_TIME_BASE - os.time();
	-- print("插入活动时间",time,act_end_time,MINI_DATE_TIME_BASE,os.time(),act_id);
	-- print(time)
	if time < 0 then
		time = 0;
	end
	_act_time_dict[act_id] = time;

	-- 如果是中秋活动，更新中秋节活动系统
	if act_id == SmallOperationModel.ACT_TYPE_ZHONGQIU then 
	    ZhongqiuModel:update_win( "remain_time" )
	end
end
function SmallOperationModel:remove_act_time( act_id )
	_act_time_dict[act_id] = nil;
end
function SmallOperationModel:get_act_time( act_id )
	return _act_time_dict[act_id];
end

-- 保存活动开始和结束时间   -- by lyl
function SmallOperationModel:save_start_end_time( activity_id, start_time, end_time )
	local activity_time = {}   -- _active_start_end_time_t  的 元素
	activity_time.start_time = start_time + MINI_DATE_TIME_BASE
	activity_time.end_time   = end_time + MINI_DATE_TIME_BASE
	_activity_start_end_time_t[ activity_id ] = activity_time

	if activity_id == SmallOperationModel.ACT_TYPE_ZHONGQIU then
        ZhongqiuModel:update_win( "start_end_time" )
	end
end

-- 获取开始和结束时间  -- lyl
function SmallOperationModel:get_start_end_time( activity_id )
    local start_time = 0
    local end_time = 0
    print("----activity_id:", activity_id, _activity_start_end_time_t[ activity_id ] )
	if _activity_start_end_time_t[ activity_id ] then 
        start_time = _activity_start_end_time_t[ activity_id ].start_time
        end_time = _activity_start_end_time_t[ activity_id ].end_time
    end
    return start_time, end_time
end

--功能：根据活动ID获取活动剩余时间
--参数：1、activityId	活动ID
--返回：1、t_remainTime	活动剩余时间
--作者：陈亮
--时间：2014.08.30
function SmallOperationModel:getActivityRemainTime(activityId)
	-- print("小型活动的剩余时间",activityId)
	--获取活动开始时间和结束时间组
	local t_timeGroup = _activity_start_end_time_t[activityId]
	--如果不存在，马上返回
	if t_timeGroup == nil then
		return 0
	end

	--获取结束时间
	local t_endTime = t_timeGroup.end_time
	local t_remainTime = t_endTime - os.time()

	--如果剩余时间小于0,剩余时间等于0
	if t_remainTime < 0 then
		t_remainTime = 0
	end
	return t_remainTime
end

--功能：根据活动ID获取活动“起始时间-结束时间”描述字符串
--作者：郭志楠
--时间：2015.02.09
function SmallOperationModel:getActivityTimeDescEx(activityId)
    local t_timeGroup = _activity_start_end_time_t[activityId]
    if t_timeGroup == nil then
		return
	end

	-- [1]="%Y年%m月%d日%H时%M分"
    local startStr = Utils:get_custom_format_time( Lang.mainActivity.common[1], t_timeGroup.start_time-MINI_DATE_TIME_BASE)
    local endStr = Utils:get_custom_format_time( Lang.mainActivity.common[1], t_timeGroup.end_time-MINI_DATE_TIME_BASE)
    local str = startStr .. '--' .. endStr

    return str
end

--功能：根据活动ID获取活动“起始时间-结束时间”描述字符串（无时分秒）
--作者：chj
--时间：2015.02.09
function SmallOperationModel:getActivityTimeDescEx_2(activityId)
    local t_timeGroup = _activity_start_end_time_t[activityId]
    if t_timeGroup == nil then
		return
	end

	-- [1]="%Y年%m月%d日%H时%M分"
    local startStr = Utils:get_custom_format_time( Lang.mainActivity.common[2], t_timeGroup.start_time-MINI_DATE_TIME_BASE)
    local endStr = Utils:get_custom_format_time( Lang.mainActivity.common[2], t_timeGroup.end_time-MINI_DATE_TIME_BASE)
    local str = startStr .. '-' .. endStr

    return str
end

-- 小型活动配置
function SmallOperationModel:get_act_award_config( index )

	local award_dict;
	if _operation_act_type == ServerActivityConfig.ACT_TYPE_STRONG_HERO then
		award_dict = OperationActivityConfig:get_strong_hero_award_config( index );
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_POWER_PET then
		award_dict = OperationActivityConfig:get_power_pet_award_config( index );
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_POWER_FABAO then
		award_dict = OperationActivityConfig:get_power_fabao_award_config( index );
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_GUOQING then
		award_dict = OperationActivityConfig:get_guoqing_award_config( index )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
		award_dict = OperationActivityConfig:get_qianglilaixi_config( index );
	else
		award_dict = ServerActivityConfig:get_conf( _operation_act_type )[index];
	end
	return award_dict;
end

-- 获取当前活动的数据
function SmallOperationModel:req_get_current_act_data(  )
	-- 旧的活动服务端没有使用统一的模板
	if _operation_act_type == ServerActivityConfig.ACT_TYPE_STRONG_HERO then
		-- 强者之路活动
		SmallOperationModel:req_strong_hero(  )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_POWER_PET then
		-- 至强伙伴活动
		SmallOperationModel:req_get_power_pet(  )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_POWER_FABAO then
		-- 至强法宝活动
		SmallOperationModel:req_get_power_fabao(  )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_GUOQING then
		-- 国庆活动
		SmallOperationModel:req_get_guoqing_activity(  ) 
	else
		-- 新的活动服务端使用统一的模板
		-- 遍历当前的可用活动，请求数据
		if ServerActivityConfig.CURR_USE_ACTIVITY_IDS[ _operation_act_type ] then
			BigActivityModel:req_activity_data( _operation_act_type ,_operation_act_sub_type );
		end
	end
end

-- 统一的领取接口
function SmallOperationModel:req_get_act_award( index )
	if _operation_act_type == ServerActivityConfig.ACT_TYPE_STRONG_HERO then
		SmallOperationModel:req_get_strong_hero_award( index )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_POWER_PET then
		SmallOperationModel:req_get_power_pet_award( index )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_POWER_FABAO then
		SmallOperationModel:req_get_power_fabao_award( index )
	elseif _operation_act_type == ServerActivityConfig.ACT_TYPE_GUOQING then
		OnlineAwardCC:req_accept_gq_award( index )
	else
		-- 遍历当前的可用活动，领取奖励
		if ServerActivityConfig.CURR_USE_ACTIVITY_IDS[ _operation_act_type ] then
			OnlineAwardCC:req_get_activity_award_com( _operation_act_type, _operation_act_sub_type, index )
		end
	end
end

-- 更新相关的界面
function SmallOperationModel:update_win( activity_id,activity_award_data )  
	print("SmallOperationModel:update_winSmallOperationModel:update_win")
	if activity_id == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI or 
	   activity_id == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI2 or 
		activity_id == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
		local win = UIManager:find_visible_window("small_operation_act_win")
		if win then
			_current_act_data = activity_award_data
			win:update( activity_award_data );
		end
	elseif activity_id == ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN then
		local win = UIManager:find_visible_window("xiaofei_return_win")
		if win then
			win:update_xiaofei_data( activity_award_data );
		end
    elseif activity_id == ServerActivityConfig.ACT_TYPE_YUANBAOFANLI then
		local win = UIManager:find_visible_window("xiaofei_return_win")
		if win then
			win:update_xiaofei_data( activity_award_data );
		end

	else
		-- 更新界面
		if ServerActivityConfig.CURR_USE_ACTIVITY_IDS[activity_id] then
			print("更新大活动页面数据 ",activity_id)
			local win = UIManager:find_visible_window("big_activity_win");
			if win then
				win:update_get_award_btn_state( activity_award_data )
			end
		end
	end

end

-- 取得相关活动的配置表数据
function SmallOperationModel:get_data( activity_id )
	local data = nil;
	-- 先查看是否有这个配置
	local data = ServerActivityConfig:get_conf(activity_id);
	if data == nil then
		print("未配置配置文件",activity_id)
	end
    return data; 	
end

------------------------------网络协议

-- 获取强者之路的数据
function SmallOperationModel:req_strong_hero(  )
	OnlineAwardCC:req_get_strong_hero(  )
end

-- 下发强者之路数据
function SmallOperationModel:do_strong_hero( data )
	print("强者之路，全身强化", data.level );
	local count = OperationActivityConfig:get_award_cell_count( ServerActivityConfig.ACT_TYPE_STRONG_HERO );
	for i=1,count do
		local can_get_record = Utils:get_bit_by_position( data.can_get_record, i );
		print("强者之路, 是否达成", i, can_get_record);
		local had_get_record = Utils:get_bit_by_position(data.had_get_record,i);
		print("强者之路, 是否已领取", i, had_get_record);
	end

	_current_act_data = data;

	local win = UIManager:find_visible_window("small_operation_act_win");
	if win then
		win:update(data);
	end

end
-- 领取强者之路奖励
function SmallOperationModel:req_get_strong_hero_award( index )
	OnlineAwardCC:req_get_strong_hero_award( index )  
end

-- 获取至强伙伴的数据
function SmallOperationModel:req_get_power_pet(  )
	OnlineAwardCC:req_get_power_pet(  );
end
-- 下发至强伙伴的数据
function SmallOperationModel:do_get_power_pet( data )
	local count = OperationActivityConfig:get_award_cell_count( ServerActivityConfig.ACT_TYPE_POWER_PET );
	for i=1,count do
		print("至强伙伴，宠物成长等级", data.pet_value );
		local can_get_record = Utils:get_bit_by_position( data.can_get_record, i );
		print("至强伙伴, 是否达成", i, can_get_record);
		local had_get_record = Utils:get_bit_by_position(data.had_get_record,i);
		print("至强伙伴, 是否已领取", i, had_get_record);
	end

	_current_act_data = data;

	local win = UIManager:find_visible_window("small_operation_act_win");
	if win then
		win:update(data);
	end
end
-- 领取至强宠物奖励
function SmallOperationModel:req_get_power_pet_award( index )
	OnlineAwardCC:req_get_power_pet_award( index )
end

-- 获取至强法宝的数据
function SmallOperationModel:req_get_power_fabao(  )
	OnlineAwardCC:req_get_power_fabao(  )
end

-- 获取国庆活动的数据
function SmallOperationModel:req_get_guoqing_activity(  )
	OnlineAwardCC:req_open_guoqing_activity_win()
end


-- 下发至强法宝的数据
function SmallOperationModel:do_get_power_fabao( data )
	
	local count = OperationActivityConfig:get_award_cell_count( ServerActivityConfig.ACT_TYPE_POWER_FABAO );
	for i=1,count do
		local can_get_record = Utils:get_bit_by_position( data.can_get_record, i );
		print("至强法宝, 是否达成", i, can_get_record);
		local had_get_record = Utils:get_bit_by_position(data.had_get_record,i);
		print("至强法宝, 是否已领取", i, had_get_record);
	end

	_current_act_data = data;

	local win = UIManager:find_visible_window("small_operation_act_win");
	if win then
		win:update(data);
	end

end
-- 领取至强法宝奖励
function SmallOperationModel:req_get_power_fabao_award( index )
	
	OnlineAwardCC:req_get_power_fabao_award( index );

end

-- 下发国庆活动的数据
function SmallOperationModel:do_open_guoqing_activity_win( data )
	local count = OperationActivityConfig:get_award_cell_count( ServerActivityConfig.ACT_TYPE_GUOQING );
	for i=1,count do
		local can_get_record = Utils:get_bit_by_position( data.can_get_record, i );
		print("国庆活动, 是否达成", i, can_get_record);
		local had_get_record = Utils:get_bit_by_position(data.had_get_record,i);
		print("国庆活动, 是否已领取", i, had_get_record);
	end

	_current_act_data = data;

	local win = UIManager:find_visible_window("small_operation_act_win");
	if win then
		win:update(data);
	end
end

-- add by chj @2015-4-2
function SmallOperationModel:add_act_id(i, act_id )
	_act_time_id[i] = act_id
end

function SmallOperationModel:get_act_id( )
	return _act_time_id
end

----------------------------------------------------------------------------------------------------------