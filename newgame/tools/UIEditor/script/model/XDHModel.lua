-- XDHModel.lua
-- create by hcl on 2013-8-10
-- 仙道会Model

XDHModel = {}

local my_xdh_info = {}; -- 我的仙道会信息
local zys_top_info = {};-- 自由赛排行信息
local slq_info = {};	-- 十六强信息
local ljxw_info = {};	-- 历届仙王信息
local zbs_info = {};	-- 争霸赛信息
local _xh_count = 0;
local _jd_count = 0;

local curr_match_index = 0; --当前争霸赛第几场

-- added by aXing on 2013-5-25
function XDHModel:fini( ... )
	print("XDHModel:fini( ... )")
	my_xdh_info = {};
	zys_top_info = {};
	slq_info = {};
	ljxw_info = {};
	zbs_info = {};
	_xh_count = 0;
	_jd_count = 0
	curr_match_index = 0;
end

function XDHModel:get_my_xdh_info()
	return my_xdh_info;
end

function XDHModel:set_my_xdh_info( info )
	my_xdh_info = info;
	-- 每次取得仙道会信息后就更新界面
	local win = UIManager:find_visible_window("xiandaohui_win");
	if ( win ) then
		win:update("bjzys_my_info");
	end
end

function XDHModel:get_zys_top_info()
	return zys_top_info;
end

function XDHModel:set_zys_top_info( page, info )
	print("XDHModel:curr_page,",page, #info)
	if page == 1 then 
		zys_top_info = info;
	else
		for i=1,#info do
			table.insert(zys_top_info,info[i])
		end
	end
	-- 每次取得仙道会信息后就更新界面
	local win = UIManager:find_visible_window("xiandaohui_win");
	if ( win ) then
		win:update("bjzys_top");
	end
end

function XDHModel:get_slq_info()
	return slq_info;
end

function XDHModel:set_slq_info( info )
	slq_info = info;
	-- 每次取得仙道会信息后就更新界面
	local win = UIManager:find_visible_window("xiandaohui_win");
	if ( win ) then
		win:update("sjslq");
	end
end

function XDHModel:get_ljxw_info()
	return ljxw_info;
end

function XDHModel:set_ljxw_info( info )
	ljxw_info = info;
	-- 每次取得仙道会信息后就更新界面
	local win = UIManager:find_visible_window("xiandaohui_win");
	if ( win ) then
		win:update("ljxw");
	end
end

-- 保存仙道会争霸赛信息
function XDHModel:set_zbs_info( _zbs_info )
	zbs_info = _zbs_info
	-- -- 每次取得仙道会信息后就更新界面
	local win = UIManager:find_visible_window("xiandaohui_win");
	if ( win ) then
		win:update("zbs_info",zbs_info);
	end
	-- for i=1,16 do
	-- 	print(zbs_info.xdhzbs_player_table[i].name)
	-- end
end

function XDHModel:get_zbs_info()
	return zbs_info;
end

function XDHModel:set_xh_and_jd_count( xh_count,jd_count )
	_xh_count = xh_count;
	_jd_count = jd_count;
end

function XDHModel:get_xh_and_jd_count()
	return _xh_count,_jd_count;
end

-- 更新争霸赛pk结果
function XDHModel:update_zbs_pk_result( turn,group,index )

    local turn_index = self:get_index_by_turn( turn )
    -- 16强第二轮特殊处理
    if turn == 1 and curr_match_index == 2 then
        turn_index = turn_index + 4;
    end
    -- 当前要保存到的Pk状态类表的索引
    local pk_state_index = turn_index + group;
    
    --取得上轮赢家的玩家索引
   	local old_turn = turn - 1;
   	local old_offset = self:get_index_by_turn( old_turn );
   	local win_index = old_offset + (group-1)*2 + index;
   	local win_player_index = 0 ; 
   	if old_turn == 0 then
   		win_player_index = win_index;
   		if curr_match_index == 2 then
   			win_player_index = win_index + 8 ;
   		end
   	else
   		win_player_index = zbs_info.pk_state_info[ win_index ].player_index;
   	end
   	print("turn,group,index",turn,group,index,"pk_state_index,win_player_index",pk_state_index,win_index,win_player_index)
   	zbs_info.pk_state_info[ pk_state_index ].player_index = win_player_index;


	-- local turn_index = self:get_turn_index( turn-1 );
	-- local curr_turn_index = self:get_turn_index(turn);
	-- local win_index = turn_index + (group-1)*2 + index;
	-- zbs_info.pk_state_info[ curr_turn_index + group ] = zbs_info.pk_state_info[ win_index ];
	local win = UIManager:find_visible_window("zbsjc")
	if win then
		win:update_view(  );
	end
end
-- 取得 比赛结果表 指定轮数的偏移索引
function XDHModel:get_index_by_turn( turn )
    local d = 0;
    if ( turn == 1 ) then
        d = 0 
    elseif ( turn == 2 ) then
        d = 8
    elseif ( turn == 3 ) then
        d = 12
    elseif ( turn == 4 ) then 
        d = 14
    end
    return d;
end

-- 取得每轮的比赛场数
function XDHModel:get_match_num_by_turn( turn )
	if ( turn == 1 ) then
		return 8;
	elseif ( turn == 2 ) then
		return 4;
	elseif ( turn == 3 ) then
		return 2;
	elseif ( turn == 4 ) then
		return 1;
	end
end

-- 设置仙道会状态 turn,当前轮数  match_index，第几场
function XDHModel:set_xdh_state( turn,match_index )
	curr_match_index = match_index;

	zbs_info.turn = turn;
	-- zbs_info.lt_state = 1
end

-- 设置擂台状态
function XDHModel:set_xdh_lt_state( turn,lt_state ,time)

	zbs_info.turn = turn;
	zbs_info.lt_state = lt_state;
	zbs_info.state_left_time = time;
end

function XDHModel:get_xdh_state()
	return curr_match_index;
end

-- 更新玩家的身价
function XDHModel:update_player_value( index , value )
	-- 做一下出错的预防处理
	if zbs_info.xdhzbs_player_table ~= nil and zbs_info.xdhzbs_player_table[index] ~= nil then
		zbs_info.xdhzbs_player_table[index].value = value;
	end
end

zbsPos = {	-- 争霸赛4个擂台的位置
	-- { {43, 27}, {55, 27} },
	-- { {10, 9}, {23, 9} },
	-- { {76, 9}, {89, 9} },
	-- { {10, 37}, {23, 37} },
	-- { {76, 37}, {89, 37} },
	{ 63,47 },	-- 决赛擂台
	{ 43,25 },	-- 擂台二
	{ 109, 55 },	-- 擂台三
	{ 80, 71 },	-- 擂台四
	{ 17, 40},	-- 擂台五
}

function XDHModel:move_to_letai( letai_index )
	local turn = zbs_info.turn;
	local pos_tab = {};
	if ( turn == 4 ) then
		pos_tab = zbsPos[1];
	else
		pos_tab = zbsPos[letai_index + 1];
	end
	local target_x = pos_tab[1] * SceneConfig.LOGIC_TILE_WIDTH;
	local target_y = pos_tab[2] * SceneConfig.LOGIC_TILE_HEIGHT;
	print("pos_tab[1],pos_tab[2]",pos_tab[1],pos_tab[2],target_x,target_y);
	CommandManager:move( target_x, target_y , true ,nil,EntityManager:get_player_avatar());
end

function XDHModel:update_xiazhu_info( pk_state_index, player_index )
	zbs_info.pk_state_info[pk_state_index].my_bet = player_index;
end  

-- 取得仙道宝盒的抽奖道具
function XDHModel:get_xdbh_items()
	require "../data/client_global_config"
	return client_global_config.matchLotteryWheelItems
end

-- 取得仙道宝盒要过滤的道具
function XDHModel:get_xdbh_remove_items()
	require "../data/client_global_config" -- 从0开始
	return client_global_config.matchLotteryWheelItemDark
end

-- 取得仙道宝盒过滤后的道具
function XDHModel:get_xdbh_hjs_items()
	local items = XDHModel:get_xdbh_items()
	local items_drak = XDHModel:get_xdbh_remove_items()
	local new_items = {};
	local index = 1;
	for i=1,10 do
		new_items[i] = items[i];
	end
	local index = 1;
	for i=1,#items_drak do
		new_items[items_drak[i]+1] = nil;
	end
	print("new_items_count = ",#new_items,#items_drak);
	return new_items;
end

function XDHModel:get_zys_time()
	require "../data/client_global_config" -- 从0开始
	return client_global_config.zysPkTime,client_global_config.zysCountDown;
end

function XDHModel:get_zbs_time()
	require "../data/client_global_config" -- 从0开始
	return client_global_config.zbsPkTime,client_global_config.zbsCountDown;
end