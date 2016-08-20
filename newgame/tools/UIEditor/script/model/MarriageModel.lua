-- MarriageModel.lua
-- create by fjh 2013-8-15
-- 结婚model

MarriageModel = {};

MarriageModel.MAX_RING_ITEM_ID 		= 11106	-- 最高级的婚戒id

MarriageModel.PAGE_TYPE_QINGYUAN 	= 1;	--仙侣情缘
MarriageModel.PAGE_TYPE_HUNYAN 		= 2;	--婚宴
MarriageModel.PAGE_TYPE_YUNCHE 		= 3;	--云车
MarriageModel.RECORD_PAGE_SIZE 		= 7;	--结婚记录列表的页容量

MarriageModel.WEDDING_TYPE_NULL		= 0;
MarriageModel.WEDDING_TYPE_PUTONG	= 1;	--普通婚宴
MarriageModel.WEDDING_TYPE_HAOHUA	= 2;	--豪华婚宴

local _page_type = MarriageModel.PAGE_TYPE_QINGYUAN;



local play_string = {LangModelString[375],LangModelString[376],LangModelString[377],LangModelString[378]}; -- [375]="举起酒杯，大吼一声，干了！" -- [376]="满脸微笑，送上了自己最真诚的祝福！" -- [377]="也不管眼前是谁，直接把自己的吻丢了出来！" -- [378]="很感谢诸位仙友的到来，抛撒一把喜糖表达谢意！"

-- 他人向自己求婚的数据
local _other_marriage_data = nil;

-- 自己的仙侣数据 结构：{level=, count=, sweet=, qingyi=, lover_id=, lover_name=,}
--						仙缘等级，点亮红心的个数, 亲密度, 情意度, 仙侣id，仙侣名字
local _marriage_data = {};
 
-- 婚宴列表
local _wedding_list = {};

-- 结婚记录列表
local _marriage_record_list = nil;

-- 参加婚宴的数据，
local _wedding_data = nil;

-- 婚宴里的cd时间记录
local _wedding_cd_dict = nil;--{cd_time,cd_time,cd_time，cd_time}；

-- 是否点击了升级仙缘
local _has_uplevel = false;

function MarriageModel:fini(  )

	_page_type = MarriageModel.PAGE_TYPE_QINGYUAN;		
	_other_marriage_data = nil;
	_marriage_data = {};
	_wedding_list = {};
	_marriage_record_list = nil;
	_wedding_data = nil;
	_wedding_cd_dict = nil;
	_has_uplevel = false;
	
end


-- 设置当前分页类别(旧版MarriageWin页面调用)
function MarriageModel:changed_page_type( page_type )
	-- _page_type = page_type;
		
	-- -- 更新结婚主窗口
	-- local win = UIManager:find_visible_window("marriage_win");
	-- if win then
	-- 	win:selected_tab_btn( _page_type );
	-- end
	-- -- 更新结婚右窗口
	-- local win = UIManager:find_visible_window("marriage_right_win"); 
	-- if win then
	-- 	win:change_page( _page_type );
	-- end
end

-- 获取当前分页类别
function MarriageModel:get_page_type( )
	return page_type;
end

-- 获取仙缘数据
function MarriageModel:get_marriage_data(  )
	return _marriage_data;
end
-- 获取婚宴列表
function MarriageModel:get_wedding_list(  )
	return _wedding_list;
end

-- 获取结婚记录
function MarriageModel:get_marriage_record_list(  )
	return _marriage_record_list;
end

-- 获取从选择开始到晚上23点59分前可以预约的婚宴时间（整点时间）
function MarriageModel:get_yuyue_time_list(  )
	local time = tonumber( os.date("%H", os.time()) );
	
	local count = 23 - time ;

	local time_list = {};
	for i=1,count do
		table.insert( time_list, time + i );
	end
	return time_list;
end

-- 获取婚宴中嬉戏的次数
function MarriageModel:get_wedding_data(  )
	return _wedding_data;

end

-- 婚宴中的嬉戏cd时间
function MarriageModel:set_wedding_cd_time( index )
	
	local curr_time = math.floor(GameStateManager:get_total_seconds())+60;

	if _wedding_cd_dict == nil then

		_wedding_cd_dict = { { k = index, v = curr_time}, };
		print("存储cd时间", curr_time);
	else
		for i,v in ipairs(_wedding_cd_dict) do
			if v.k == index then
				_wedding_cd_dict[i].v = curr_time;
				print("存储cd时间", curr_time);
				return ;
			end
		end
		
		table.insert(_wedding_cd_dict, { k = index, v = curr_time});
		print("存储cd时间", curr_time);

	end
end

function MarriageModel:get_wedding_cd_time( index )
	if _wedding_cd_dict ~= nil  then
		for i,v in ipairs(_wedding_cd_dict) do
			if v.k == index then
				local curr_time = math.floor(GameStateManager:get_total_seconds());
				local cd_time = v.v - curr_time;
				if cd_time > 0 then
					print("获取到cd时间", cd_time, v.v, curr_time);
					return cd_time;
				end
			end
		end
	end
	return nil;
end

------------------------ 网络协议
-- 他人向自己求婚
function MarriageModel:do_other_get_marrage_to_me( data )
	_other_marriage_data = data;
	local win = UIManager:show_window("get_marriage_win");
	if win then
		win:update( _other_marriage_data.ring_id, _other_marriage_data.name );
	end

end
-- 同意他人的求婚
function MarriageModel:req_agree_other_get_marriage(  )
	MarriageCC:req_response_marriage( 1, _other_marriage_data.player_id, _other_marriage_data.ring_serise )
end
-- 拒绝他人的求婚
function MarriageModel:req_reject_other_get_marriage(  )
	MarriageCC:req_response_marriage( 2, _other_marriage_data.player_id, _other_marriage_data.ring_serise )
end

--自己向他人求婚
function MarriageModel:req_mine_get_marriage_other( param )

	local ring_series = ItemModel:find_max_lv_ring_series();
	if ring_series ~= nil then

		local target_player = EntityManager:get_entity(param.handle);
		local self_player = EntityManager:get_player_avatar();
		if target_player.sex == self_player.sex then
			
			-- 性别相同无法结婚
			local item = ItemModel:get_item_info_by_id(14456); -- 获取阴阳轮回珠,
			if item == nil then
				-- --如果没有戒指则前往购买	
				-- local function buy_lunhuizhu(  )
				-- 	BuyKeyboardWin:show( 14456, nil, 1);
				-- end
				-- ConfirmWin2:show( 3, 7, "同性不可以在一起，如果你们无视世俗，请购买#cfff000阴阳轮回珠#cffffff转性吧！",  buy_lunhuizhu);
				GlobalFunc:create_screen_notic("同性不可以在一起!")
			else
				ItemModel:use_one_item( item );
			end
		else
			MarriageCC:req_get_marriage( ring_series, param.roleId, param.roleName );
		end
	else
	
		local win = UIManager:show_window("yuyue_wedding_win");
		win:init_ring_panel();
	end

end

-- 服务器下发仙侣信息
function MarriageModel:do_wedding_info( sweet, qingyi, lover_id, lover_name )

	-- print("仙侣信息", sweet, qingyi, lover_id, lover_name );
	_marriage_data.sweet = sweet;
	_marriage_data.qingyi = qingyi;
	_marriage_data.lover_id = lover_id;
	_marriage_data.lover_name = lover_name;

	local win = UIManager:find_window("marriage_win_new");
	if win then
		-- 更新亲密度
		win:update_sweet_value();
	end
	-- local win = UIManager:find_window("marriage_right_win");
	if win then
		win:update_curr_qingyi_value()
	end

end

-- 查看仙缘
function MarriageModel:req_observor_xianyuan(  )
	MarriageCC:req_observor_xianyuan( );
end

-- 下发仙缘数据
function MarriageModel:do_observor_xianyuan( count, level )
	print("下发仙缘数据",count, level);

	local win = UIManager:find_visible_window("marriage_win_new");

	if _has_uplevel and win then
		if level > _marriage_data.level then
			win:play_uplevel_effect( 2 );
		else
			_marriage_data.count = count;
			win:play_uplevel_effect( 1 );
		end

	end
	_marriage_data.count = count;
	_marriage_data.level = level;
	
	--更新数据
	if win then

		win:update_xianyuan_level();
	end

	_has_uplevel = false;
end

-- 升级仙缘
function MarriageModel:req_uplevel_xianyuan(  )
	if _marriage_data.level == 8 and _marriage_data.count == 10 then
		GlobalFunc:create_screen_notic(LangModelString[380]); -- [380]="仙缘已经升到了最高级"
	else
		_has_uplevel = true;
		MarriageCC:req_uplevel_xianyuan(  )
	end

end

---------------婚宴相关
-- 进入婚宴副本
function MarriageModel:did_enter_hunyan( wedding_type )
	print("婚礼类型",wedding_type, MarriageModel.WEDDING_TYPE_HAOHUA );
	if wedding_type == MarriageModel.WEDDING_TYPE_HAOHUA then
		UIManager:show_window("marriage_play_win");
	end
end
-- 退出婚宴副本
function MarriageModel:did_exit_hunyan( wedding_type )
	-- if wedding_type == MarriageModel.WEDDING_TYPE_HAOHUA then
		UIManager:destroy_window("marriage_play_win");
	-- end
end


--举行婚宴
function MarriageModel:req_make_wedding( wedding_type, time )
	
	MarriageCC:req_wedding( wedding_type, time )

end

-- 新增正在举行的婚宴
function MarriageModel:do_add_wedding_to_list( data )
	print("新增正在举行的婚宴", #_wedding_list);
	if #_wedding_list == 2 then
		-- 列表不为空，插入新婚礼
		if data.type == 1 then
			--普通婚礼
			table.insert(_wedding_list[1], data);
		else
			-- 豪华婚礼
			table.insert(_wedding_list[2], data);
		end

	else
		local putong_weddings = {};
		local haohua_weddings = {};
	
		if data.type == 1 then
			-- 普通婚礼
			table.insert(putong_weddings, data);
		elseif data.type == 2 then
			-- 豪华婚礼
			table.insert(haohua_weddings, data);
		end
	
		table.insert( _wedding_list, putong_weddings );
		table.insert( _wedding_list, haohua_weddings );
	end

	local win = UIManager:find_visible_window("marriage_win_new");
	if win then
		win:selected_wedding_list( data.type );
	end
end

-- 请求正在进行的婚宴列表
function MarriageModel:req_get_wedding_list(  )
	MarriageCC:req_get_wedding_list(  )
end

-- 获取在进行的婚宴列表
function MarriageModel:do_get_wedding_list( data )
	
	if #_wedding_list ~= 0 then
		for k in pairs(_wedding_list) do
			_wedding_list[k] = nil;
		end
	end

	local putong_weddings = {};
	local haohua_weddings = {};
	for i,v in ipairs(data) do
		if v.type == 1 then
			-- 普通婚礼
			print("插入一个普通婚礼")
			table.insert(putong_weddings, v);

		elseif v.type == 2 then
			-- 豪华婚礼
			print("插入一个豪华婚礼")
			table.insert(haohua_weddings, v);
		end
	end
	
	table.insert( _wedding_list, putong_weddings );
	table.insert( _wedding_list, haohua_weddings );

	local win = UIManager:find_visible_window("marriage_win_new");
	if win then
		win:update_wedding_list()
	end

end

-- 参加婚礼
function MarriageModel:req_join_wedding( wedding_id )

	MarriageCC:req_join_wedding( wedding_id );
end

-- 成功参加了婚礼，下发数据
function MarriageModel:do_join_wedding( data )
	_wedding_data = data;
	local win = UIManager:find_visible_window("marriage_play_win");
	if win then
		win:update();
	end
end


-- 婚礼互动
function MarriageModel:req_wedding_play( play_id )
	-- 1：敬酒，2：祝福，3：扮鬼脸，4：撒喜糖
	MarriageCC:req_wedding_play( play_id );
	MarriageModel:set_wedding_cd_time(play_id);
end

-- 婚礼互动的广播
function MarriageModel:do_wedding_play( play_id )
	
	print("婚礼互动的广播", play_id );
	local str = "";
	if play_string[play_id] ~= nil then
		local player = EntityManager:get_player_avatar();
		str = player.name .. play_string[play_id];
	end

	ChatCC:sent_happy_hour_chat( str );

end



-- 增加撒喜糖次数
function MarriageModel:add_sa_xitang_count(  )
	MarriageCC:req_add_xitang_count( )
end

-- 婚礼结束，从列表从删除
function MarriageModel:do_wedding_over( wedding_id )
	
	local has_find = false;
	-- 先遍历普通婚礼
	if _wedding_list[1] ~= nil then
		for i,wedding in ipairs(_wedding_list[1]) do
			if wedding.id == wedding_id then
				table.remove( _wedding_list[1], i);
				has_find = true;
			end
		end
	end

	if not has_find and _wedding_list[2] ~= nil then
		-- 豪华婚礼
		for i,wedding in ipairs(_wedding_list[2]) do
			if wedding.id == wedding_id then
				table.remove( _wedding_list[2], i);
			end
		end
	end

	local win = UIManager:find_visible_window("marriage_win_new");
	if win then
		win:update_wedding_list()
	end


	MarriageModel:did_exit_hunyan();

	_wedding_cd_dict = nil;

end




--------------------云车巡游相关
-- 发起巡游
function MarriageModel:req_yunche_xunyou( type )
	-- 1：普通，2：浪漫，3：豪华
	MarriageCC:req_yunche_xunyou( type )
end

-- 请求结婚记录列表
function MarriageModel:req_marriage_record_list( curr_page )
	-- print("请求结婚记录列表");
	MarriageCC:req_marriage_record_list( MarriageModel.RECORD_PAGE_SIZE, curr_page )
	
end

-- 结婚记录列表返回
function MarriageModel:do_marriage_record_list( data )
	
	_marriage_record_list = data;

	local win = UIManager:find_visible_window("marriage_win_new");
	if win then
		win:update_marriage_record_list()
	end
	
end

---------------------戒指相关

-- 升级戒指
function MarriageModel:req_up_level_ring(  )
	MarriageCC:req_uplevel_ring();
end

-- 使用戒指(吞噬戒指,转化为情意值)
function MarriageModel:req_swallow_ring( ring_model )

	if ring_model.item_id ==  11101 then
		-- 如果是深海之恋，则可以吞噬
		MarriageCC:req_use_ring( ring_model.series )
	else
		-- 如果是其他婚戒的话，则不处理
        GlobalFunc:create_screen_notic( LangModelString[326] ) -- [326]="该道具在背包中无法直接使用"
	end
	return;
end

