-- MarriageCC.lua 
-- created by fjh 2013-8-17
-- 结婚系统

MarriageCC = {}

-- 148,1下发结婚数据
function MarriageCC:do_wedding_info( pack )
	-- 亲密度
	local sweet_value = pack:readInt();
	-- 情意度
	local qingyi_value = pack:readInt();
	-- 仙侣的id
	local lover_id = pack:readInt();
	-- 仙侣的名字
	local lover_name = pack:readString();

	MarriageModel:do_wedding_info( sweet_value, qingyi_value, lover_id, lover_name )

end

-- 148,2 戒指升级
function MarriageCC:req_uplevel_ring(  )
	local pack = NetManager:get_socket():alloc( 148, 2 )
	NetManager:get_socket():SendToSrv(pack)
end

-- 148,3 请求举办婚宴
function MarriageCC:req_wedding( wedding_type, time )
	-- 类型1为普通婚宴，2为豪华婚宴
	-- time为0意味着；立即举行
	local pack = NetManager:get_socket():alloc( 148, 3 )
	pack:writeInt(wedding_type);
	pack:writeInt(time);
	NetManager:get_socket():SendToSrv(pack)
	
end

-- 148,3 新增预约婚礼(请求举办婚宴)
function MarriageCC:do_wedding( pack )
	
	local count = pack:readInt();
	local wedding_list = {};
	
		--婚礼id
	local wedding_id = pack:readInt();
	--婚礼时间
	local time = pack:readInt();
	--婚礼类型: 1-普通, 2-豪华
	local wedding_type = pack:readInt(); 
	local player_1_id = pack:readInt();
	local player_1_sex = pack:readByte();
	local player_1_job = pack:readByte();
	local player_1_camp = pack:readByte();
	local player_1_level = pack:readByte();

	local player_2_id = pack:readInt();
	local player_2_sex = pack:readByte();
	local player_2_job = pack:readByte();
	local player_2_camp = pack:readByte();
	local player_2_level = pack:readByte();

	local player_1_name = pack:readString();
	local player_2_name = pack:readString();

	local lovers = {{id = player_1_id, name = player_1_name, sex = player_1_sex, job = player_1_job, camp = player_1_camp, level = player_1_level},
					{id = player_2_id, name = player_2_name, sex = player_2_sex, job = player_2_job, camp = player_2_camp, level = player_2_level}
					};
	
	wedding_list = { id = wedding_id, time = time, type = wedding_type,lovers = lovers };
		

	MarriageModel:do_add_wedding_to_list( wedding_list )
end


-- 148,4 获取本服结婚记录
function MarriageCC:req_marriage_record_list( count, page )
	print("获取本服结婚记录",count,page);
	-- count 每页的个数 , page 当前第几页
	local pack = NetManager:get_socket():alloc( 148, 4 )
	pack:writeInt(count);
	pack:writeInt(page-1);
	NetManager:get_socket():SendToSrv(pack)

end

-- 148,4 返回本服结婚记录
function MarriageCC:do_marriage_record_list( pack )	
	
	local count = pack:readInt();
	local current_page = pack:readInt();
	current_page = current_page + 1;
	local all_page = pack:readInt();
	local record_list = {};
	for i=1,count do
		
		local marriage_time = pack:readUInt();
		local player_1_id = pack:readInt();
		local player_2_id = pack:readInt();
		local player_1_name = pack:readString();
		local player_2_name = pack:readString();	

		record_list[i] = {time = marriage_time, player_1_id = player_1_id, player_2_id = player_2_id,
							player_1_name = player_1_name, player_2_name = player_2_name};

	end

	
	local data = {curr_page = current_page, sum_page = all_page, record_list = record_list};
	print("返回本服结婚记录",current_page, all_page, count );
	MarriageModel:do_marriage_record_list( data );

end


-- 148,5求婚
function MarriageCC:req_get_marriage( ring_serise, player_id, player_name )
	
	local pack = NetManager:get_socket():alloc( 148, 5 )
	
	pack:writeInt64( ring_serise );
	pack:writeInt( player_id );
	pack:writeString( player_name );
	NetManager:get_socket():SendToSrv(pack)

end

-- 148,5 弹出求婚界面
function MarriageCC:do_get_marriage( pack )
	-- 求婚人的id
	local player_id = pack:readInt();
	-- 戒指序列号
	local ring_serise = pack:readInt64();
	-- 戒指的item id
	local ring_id = pack:readInt();
	-- 性别
	local sex = pack:readByte();
	-- 职业
	local job = pack:readByte();
	-- 阵营
	local camp = pack:readByte();
	-- 等级
	local level = pack:readByte();
	-- 名字
	local name = pack:readString();

	local data = { player_id = player_id, ring_serise = ring_serise, ring_id = ring_id, name = name };

	MarriageModel:do_other_get_marrage_to_me( data );

end

-- 148,6 同意或拒绝
function MarriageCC:req_response_marriage( accept_state, player_id, ring_serise )
	--1：同意，2：拒绝
	local pack = NetManager:get_socket():alloc( 148, 6 )
	pack:writeInt( accept_state );
	pack:writeInt( player_id );
	pack:writeInt64( ring_serise );
	NetManager:get_socket():SendToSrv(pack)

end

--148,7 查看仙缘  
function MarriageCC:req_observor_xianyuan( )

	local pack = NetManager:get_socket():alloc( 148, 7 )
	NetManager:get_socket():SendToSrv(pack)
	
end

-- 148,7 仙缘信息
function MarriageCC:do_observor_xianyuan( pack )
	
	local data = pack:readInt();
	--高2位是仙缘的等级，低2位是开启仙缘的个数
	local count = Utils:low_word( data );
	local lv = Utils:high_word( data ) - 1;
	MarriageModel:do_observor_xianyuan( count, lv )
end

-- 148,8 升级仙缘 升级成功下发 1和 7协议
function MarriageCC:req_uplevel_xianyuan(  )

	local pack = NetManager:get_socket():alloc( 148, 8 )
	NetManager:get_socket():SendToSrv(pack)

end

-- 148,9 参加婚礼
function MarriageCC:req_join_wedding( wedding_id )

	local pack = NetManager:get_socket():alloc( 148, 9 )
	pack:writeInt(wedding_id);
	NetManager:get_socket():SendToSrv(pack)

end

-- 148，9 成功进入了婚礼，下发婚礼各项数据
function MarriageCC:do_join_wedding( pack )

	-- 敬酒次数
	local jingjiu_count = pack:readInt();
	-- 祝福次数
	local zhufu_count = pack:readInt();
	-- 扮鬼脸次数
	local guilian_count = pack:readInt();
	-- 撒喜糖次数
	local xitang_count = pack:readInt();
	-- 新娘
	local woman_id = pack:readInt();
	-- 新郎
	local male_id = pack:readInt();

	print("婚礼数据,", jingjiu_count, zhufu_count, guilian_count, xitang_count, woman_id, male_id);

	local data = {jingjiu = jingjiu_count, zhufu = zhufu_count,guilian = guilian_count, xitang = xitang_count, woman_id = woman_id, male_id = male_id};
	MarriageModel:do_join_wedding( data );

end

-- 148,10 婚礼互动， 成功后下发协议9
function MarriageCC:req_wedding_play( play_id )
	-- 1：敬酒，2：祝福，3：扮鬼脸，4：撒喜糖
	local pack = NetManager:get_socket():alloc( 148, 10 )
	pack:writeInt(play_id);
	NetManager:get_socket():SendToSrv(pack)
end


-- 148,11 增加撒喜糖次数 成功后下发协议 9，11
function MarriageCC:req_add_xitang_count( )
	local pack = NetManager:get_socket():alloc( 148, 11 )
	NetManager:get_socket():SendToSrv(pack)
end

-- 148,11 婚礼互动，用于服务器广播
function MarriageCC:do_wedding_play( pack )
	-- 1：敬酒，2：祝福，3：扮鬼脸，4：撒喜糖
	local play_id = pack:readInt();

	MarriageModel:do_wedding_play( play_id );
end

-- 148,12 请求云车巡游
function MarriageCC:req_yunche_xunyou( type )
	-- 1：普通，2：浪漫，3：豪华
	local pack = NetManager:get_socket():alloc( 148, 12 )
	pack:writeInt(type);
	NetManager:get_socket():SendToSrv(pack)
end

-- 148,13 获取婚礼列表，
function MarriageCC:req_get_wedding_list(  )
	
	local pack = NetManager:get_socket():alloc( 148, 13 )
	NetManager:get_socket():SendToSrv(pack)

end

-- 148,13 婚礼列表
function MarriageCC:do_get_wedding_list( pack )

	local count = pack:readInt();
	local wedding_list = {};

	for i=1,count do
		--婚礼id
		local wedding_id = pack:readInt();
		--婚礼时间
		local time = pack:readInt();
		--婚礼类型: 1-普通, 2-豪华
		local wedding_type = pack:readInt(); 

		local player_1_id = pack:readInt();
		local player_1_sex = pack:readByte();
		local player_1_job = pack:readByte();
		local player_1_camp = pack:readByte();
		local player_1_level = pack:readByte();

		local player_2_id = pack:readInt();
		local player_2_sex = pack:readByte();
		local player_2_job = pack:readByte();
		local player_2_camp = pack:readByte();
		local player_2_level = pack:readByte();

		local player_1_name = pack:readString();
		local player_2_name = pack:readString();
		
		local lovers = {{id = player_1_id, name = player_1_name, sex = player_1_sex, camp = player_1_camp, level = player_1_level},
						{id = player_2_id, name = player_2_name, sex = player_2_sex, camp = player_2_camp, level = player_2_level}
						};
		
		wedding_list[i] = { id = wedding_id, time = time, type = wedding_type,lovers = lovers };
		print("婚礼列表", count, wedding_id , time, wedding_type, player_1_id, player_1_sex, player_2_sex,player_1_level,player_1_name, player_2_name );
	end

	MarriageModel:do_get_wedding_list( wedding_list );

end


-- 148,14 新增仙侣记录
function MarriageCC:do_new_marriage_record( pack )
	local marriage_time = pack:readByte();
	local player_1_id = pack:readInt();
	local player_2_id = pack:readInt();
	local player_1_name = pack:readString();
	local player_2_name = pack:readString();

end

-- 148,15 婚礼结束，
function MarriageCC:do_wedding_over( pack )
	local wedding_id = pack:readInt();
	MarriageModel:do_wedding_over( wedding_id )
end

-- 148,16 使用背包的戒指
function MarriageCC:req_use_ring( ring_series )
	local pack = NetManager:get_socket():alloc( 148, 16 )
	pack:writeInt64( ring_series );
	NetManager:get_socket():SendToSrv(pack)
end