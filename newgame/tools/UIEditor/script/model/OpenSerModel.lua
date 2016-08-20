-- OpenSerModel.lua
-- created by fjh on 2013-5-31
-- 开服活动model

OpenSerModel = {}

---------- 活动类型枚举
OpenSerModel.ACTIVITY_TYPE_OPEN = 1;		--开服活动
OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST = 2;	--封测活动

-- 活动类型
local _activity_type = OpenSerModel.ACTIVITY_TYPE_OPEN;

-- 离开服七天的剩余活动时间
local _seven_day_activity_time = 0;
-- 离开服七天的剩余活动时间
local _ten_day_activity_time = 0;
-- 排行榜的领奖状态
local _rank_has_award = nil;
local _rank_award_status = nil;
local _rank_award_dict = {};

-- 修仙初成活动数据
local _xiuxian_activity_time = 0;
local _xiuxian_award_list = nil;

-- 仙宗活动奖励数据
local _guild_award_status = nil;
local _guild_cur_lv = 0;

-- 套装活动奖励数据
local _suit_has_award = nil;
local _suit_award_status = nil;

--渡劫活动奖励
local _dujie_has_award = nil;
local _dujie_award_status = nil;


function OpenSerModel:fini(  )
	-- 析构函数
	_seven_day_activity_time = 0;
	-- 排行榜的领奖状态
	_rank_has_award = nil;
	_rank_award_status = nil;
	_rank_award_dict = {};

	-- 修仙初成活动数据
	_xiuxian_activity_time = 0;
	_xiuxian_award_list = nil;

	-- 仙宗活动奖励数据
	_guild_award_status = nil;
	_guild_cur_lv = 0;

	-- 套装活动奖励数据
	_suit_has_award = nil;
	_suit_award_status = nil;

	--渡劫活动奖励
	_dujie_has_award = nil;
	_dujie_award_status = nil;
end

-- 设置当前的活动类型
function OpenSerModel:set_activity_type( type )
	_activity_type = type;
end
function OpenSerModel:get_activity_type(  )
	return _activity_type;
end



-- 获得每一个cel活动奖励数据
-- 数据很乱，策划配好后，重新调整
function OpenSerModel:get_activity_config( act_index, cell_index )
	
	local award;	
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		-- 开服活动 -- 找不到匹配，暂时用登陆
		if act_index == 1 then
		--  print("----------cell_index:", act_index, cell_index)
			award = OpenSerConfig:get_recharge_award_config( cell_index + 1 );

		elseif act_index == 2 then

			-- award = OpenSerConfig:get_dujie_award_config( cell_index );
			-- 找不到匹配，暂时用登陆
			award = OpenSerConfig:get_junior_award_config( cell_index );
		elseif act_index == 3 then

			-- award = OpenSerConfig:get_guild_award_config( cell_index );
			-- award = OpenSerConfig:get_zhanli_award_config( cell_index );
			award = OpenSerConfig:get_rank_award_config( 1, cell_index );
			-- OpenSerConfig:get_zhanli_award_config

		elseif act_index == 4 then

			-- award = OpenSerConfig:get_rank_award_config( 2, cell_index );
			award = OpenSerConfig:get_rank_award_config( 2, cell_index )

		elseif act_index == 5 then

			-- award = OpenSerConfig:get_lg_award_config( cell_index )
			award = OpenSerConfig:get_rank_award_config( 3, cell_index )
		elseif act_index == 6 then

			-- award = OpenSerConfig:get_lg_award_config( cell_index )
			award = OpenSerConfig:get_rank_award_config( 4, cell_index )
		elseif act_index == 7 then

			-- award = OpenSerConfig:get_lg_award_config( cell_index )
			award = OpenSerConfig:get_rank_award_config( 5, cell_index )
		elseif act_index == 8 then

			-- award = OpenSerConfig:get_lg_award_config( cell_index )
			award = OpenSerConfig:get_rank_award_config( 6, cell_index )
		elseif act_index == 9 then
			-- 仙盟奖励特殊，award是一个table，award[1]=盟主奖励，award[2]=成员奖励
			award = OpenSerConfig:get_guild_award_config( cell_index );

		elseif act_index == 10 then

			award = OpenSerConfig:get_siut_award_config( cell_index );

		elseif act_index == 11 then
			award = OpenSerConfig:get_dujie_award_config( cell_index );
		end
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		-- 封测活动

		award = OpenSerConfig:get_fc_activity_cofnig(act_index, cell_index);

	end

	return award;

end

-- 获取充值反馈的动态数据
function OpenSerModel:get_recharge_activity_time(  )
	-- 剩余时间
	return WelfareModel:get_remain_time(  );
end

-- 获取充值反馈的领取状态
function OpenSerModel:get_recharge_award_status( cell_index )
	
	-- 最高可领的礼包，
	local max_lv = WelfareModel:get_max_award_level(  );
	local status = WelfareModel:get_recharge_award_state( cell_index );
	return max_lv, status;

end

-------------------------------------------
-- 获取为期7天的活动剩余时间
function OpenSerModel:get_seven_day_act_time(  )
	
	local time = _seven_day_activity_time - os.clock();
	if time > 0 then
		return time;
	end
	return 0;
end


-- 设置是否上了排行榜状态
function OpenSerModel:set_rank_has_award( has_award )
	_rank_has_award = has_award;
end
-- 获取是否上了排行榜状态
function OpenSerModel:get_rank_has_award(  )
	return _rank_has_award;
end
-- 设置排行榜的领奖状态
function OpenSerModel:set_rank_award_status( award_status )
	_rank_award_status = award_status;
end
-- 获取排行榜的领奖状态
function OpenSerModel:get_rank_award_status(  )
	return _rank_award_status;
end
-- 获取排行榜的奖励排行数据
function OpenSerModel:get_rank_award_dict(  )
	return _rank_award_dict;
end

-------------------------------------------
-- 修仙初成的领奖状态
function OpenSerModel:get_xiuxian_award_list(  )
	return _xiuxian_award_list;
end

-- 仙宗活动奖励数据
function OpenSerModel:get_guild_award(  )
	return _guild_cur_lv,_guild_award_status;
end

-- 套装奖励状态
function OpenSerModel:get_suit_award(  )
	return _suit_has_award, _suit_award_status;
end

-- 渡劫奖励状态
function OpenSerModel:get_dujie_award(  )
	return _dujie_has_award, _dujie_award_status;
end


-- 开关开服活动图标
-- true为开，false为关
function OpenSerModel:swicth_open_server_icon( bool )
	-- 开服活动图标按钮的控制,放到ActivityMenusPanel中,此处不再使用
	local win = UIManager:find_window("right_top_panel");	
	if bool then
		if win then
			win:insert_btn(3);
		end
	else
		if win then
			win:remove_btn(3);
		end
	end
end

--
function OpenSerModel:check_op_server_active(  )
-- OpenSerModel:swicth_open_server_icon( true );
	if GameSysModel:isSysEnabled(GameSysModel.NEW_SERVER, false) and _ten_day_activity_time > 0 then
		-- 如果开服活动系统开启了，以及距离开服10日的时间还有大于0，则开启开服活动
		OpenSerModel:swicth_open_server_icon( true );
	else 
		OpenSerModel:swicth_open_server_icon( false );
	end

end

----------------------------------网络协议请求

-- 请求开服奖励所有的奖励数据
function OpenSerModel:req_all_active_award(  )
	--修仙初成
	OpenSerModel:req_xiuxian_award_data(  );
	-- 仙宗奖励
	OpenSerModel:req_guild_award_data(  )
	-- 排行榜奖励
	for i=1,6 do
	   OpenSerModel:req_someone_rank_data( i );
	end
	-- 套装奖励
	OpenSerModel:req_suit_award_data(  )
	-- 渡劫奖励
	OpenSerModel:req_dujie_award_data(  )

end


-- 服务器下发开服的活动时间和排行榜大概的领奖数据
function OpenSerModel:do_rank_list_award_data( ten_time, seven_time, is_has_award, award_status )
	
	-- print("下发开服的活动时间",ten_time,seven_time);

	_ten_day_activity_time = ten_time;
	_seven_day_activity_time = os.clock() + seven_time;
	_rank_has_award = is_has_award;
	_rank_award_status = award_status;

    OpenSerModel:check_op_server_active(  )

	
	for i=1,6 do 
		local has_award = Utils:get_bit_by_position( _rank_has_award, i );
		if has_award == 1 then
			-- 状态为1 = 上榜
			local status = Utils:get_bit_by_position( _rank_award_status, i )
			if status ~= 1 then
				-- status = 1 为已领取,
				-- 如果未领取，把时间延长
				_ten_day_activity_time = 10;
				OpenSerModel:swicth_open_server_icon( true );
			end
		end
	end

	OpenSerModel:req_all_active_award(  )

end


-------------修仙初成奖励相关
function OpenSerModel:req_xiuxian_award_data(  )
	OnlineAwardCC:req_xiuxian_award_info(  );
end

function OpenSerModel:do_xiuxian_award_data( act_time, xiuxian_award_dict )
	-- print("下发修仙初成数据",act_time,#xiuxian_award_dict);
	-- 活动时间, act_time
	_xiuxian_activity_time = os.clock(  ) + act_time; 

	-- 奖励列表
	_xiuxian_award_list = xiuxian_award_dict;

	-- 先判断一下是否还有奖励可领取
	for i,v in ipairs(_xiuxian_award_list) do
		-- print("修仙初成",i,v.status);
		if v.status == 1 then
			-- 如果未领取，把时间延长
			_ten_day_activity_time = 10;
			OpenSerModel:swicth_open_server_icon( true );
			break;
		end
	end

end
-- 领取修仙初成奖励
function OpenSerModel:req_get_xiuxian_award( award_id )

	-- award_id 1 人物等级 2 人物战斗力 3 宠物战斗力 4 坐骑战斗力 5 翅膀战斗力 6 法宝战斗力 7 成就 8 灵根 9 渡劫 10 斗法台
	OnlineAwardCC:req_get_xiuxian_award( award_id );

end


-------------排行榜相关

-- 请求具体的排行榜领奖情况
function OpenSerModel:req_someone_rank_data( rank_id )
	OnlineAwardCC:req_someone_rank_data( rank_id );
end
-- 返回具体的排行榜领奖情况
function OpenSerModel:do_someone_rank_data( is_has_award, rank_id, rank_list )
	-- print("排行榜数据",rank_id,#rank_list);
	-- for i,v in ipairs(rank_list) do
	-- 	print(i,v.player_id, v.player_name);
	-- end
	_rank_has_award = is_has_award;
	_rank_award_dict[rank_id] = rank_list;

end
-- 领取排行榜奖励
function OpenSerModel:req_get_rank_award( rank_id )
	OnlineAwardCC:req_get_rank_award( rank_id )
end
-- 排行榜领奖之后的回调
function OpenSerModel:do_get_rank_award( award_status )
	_rank_award_status = award_status;
end


------------仙宗奖励相关
-- 请求仙宗奖励的数据
function OpenSerModel:req_guild_award_data(  )
	OnlineAwardCC:req_guild_award_info(  )
end
-- 获取仙宗奖励的数据
function OpenSerModel:do_guild_award_data( is_has_award, guild_lv  )
	-- is_has_award   int型，第一位为1时表示有会员奖励，第二位为1时表示有宗主奖励,
					--第三位为1表示已经领过会员奖励，第4位为1表示已经领过宗主奖励
	-- guild_lv 	当前的仙宗等级
	_guild_award_status = is_has_award;
	_guild_cur_lv = guild_lv;

	for i=1,2 do
		local has_award = Utils:get_bit_by_position( _guild_award_status, i )
		if has_award == 1 then
			local status = Utils:get_bit_by_position( _guild_award_status, i+2 )
			if status ~= 1 then
				-- 如果未领取，把时间延长
				_ten_day_activity_time = 10;
				OpenSerModel:swicth_open_server_icon( true );
			end
		end
	end

end

function OpenSerModel:req_get_guild_award( award_type )
	--award_type 0表示成员奖励，1表示宗主奖励
	OnlineAwardCC:req_get_guild_award( award_type );

end

------------套装奖励相关
-- 请求套装奖励的数据
function OpenSerModel:req_suit_award_data(  )
	OnlineAwardCC:req_suit_award_info(  )
end
-- 下发套装奖励的数据
function OpenSerModel:do_suit_award_data( is_has_award, award_status )
	-- print("下发套装奖励的数据");
	--3个位分别标记3种奖励，如000是指没有奖励，第一位表示有4套装收集奖励，111表示有3个奖励
	--is_has_award
	_suit_has_award = is_has_award;
	_suit_award_status = award_status;

	for i=1,3 do
		local has_award = Utils:get_bit_by_position(_suit_has_award,i);
		if has_award == 1 then
			local status = Utils:get_bit_by_position(_suit_award_status,i);
			if status ~= 1 then
				-- 如果未领取，把时间延长
				_ten_day_activity_time = 10;
				OpenSerModel:swicth_open_server_icon( true );
			end
		end
	end

end
-- 领取套装奖励
function OpenSerModel:req_get_suit_award( index )
	--index 0-2，分别表示3种奖励
	OnlineAwardCC:req_get_suit_award( index )
end

-------------渡劫奖励相关
function OpenSerModel:req_dujie_award_data(  )
	OnlineAwardCC:req_dujie_award_info(  );
end
function OpenSerModel:do_dujie_award_data( is_has_award, award_status  )
	-- print("下发渡劫奖励的数据");
	_dujie_has_award = is_has_award;
	_dujie_award_status = award_status;

	for i=1,12 do
		local has_award = Utils:get_bit_by_position(_dujie_has_award,i);
		if has_award == 1 then
			local status = Utils:get_bit_by_position(_dujie_award_status,i);
			if status ~= 1 then
				-- 如果未领取，把时间延长
				_ten_day_activity_time = 10;
				OpenSerModel:swicth_open_server_icon( true );
			end
		end
	end
end

function OpenSerModel:req_get_dujie_award( index )
	OnlineAwardCC:req_get_dujie_award( index );
end




