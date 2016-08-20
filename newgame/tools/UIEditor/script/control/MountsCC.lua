-- MountsCC.lua
-- created by fjh on 2012-12-14
-- 坐骑系统

-- super_class.MountsCC()
MountsCC = {}


--获取坐骑信息  s->c 19,1
function MountsCC:do_mounts_info(pack)
	-- body
	local hasMounts = pack:readChar(); --是否有坐骑
	---modify by hjh 
	----用于查看他人坐骑功能
	local player_id = pack:readInt();
	local self_id = EntityManager:get_player_avatar()--.id
	if self_id ~= nil then
		self_id = self_id.id
	end
	local top_list_win = UIManager:find_visible_window("top_list_win")
	-- print("self_id,player_id,top_list_win",self_id,player_id,top_list_win)
	if self_id ~= nil and self_id ~= player_id and top_list_win ~= nil then
		local mount_info = MountsStruct(player_id, pack);
		MountsModel:show_other_mounts_by_info(mount_info)
	else
		if hasMounts == 1 then
			--解析坐骑信息结构
			local mounts_info = MountsStruct(self_id, pack);
			--填充到model里去
			MountsModel:set_has_mounts(true);
			MountsModel:set_mounts_info(mounts_info);
		else
			MountsModel:set_has_mounts(false);
		end
	end
end

--切换上马下马的状态，true是上马，false下马  c->s 19,1
function MountsCC:request_shangma( shangme_state )
	local pack = NetManager:get_socket():alloc(19, 1);
	if shangme_state == true then 
		pack:writeByte(1);
	else
		pack:writeByte(0);
	end
	NetManager:get_socket():SendToSrv(pack);
end

--坐骑升级  c->s 19,2
function MountsCC:rquest_up_level()
	print("请求升级")
	local pack = NetManager:get_socket():alloc(19, 2);
	NetManager:get_socket():SendToSrv(pack);
end
--坐骑升级callback s->c 19,2
function MountsCC:do_up_level( pack )
	
	local currentLevel = pack:readInt();
	local CDTime_s = pack:readUInt(); 
	print("升级成功最新等级",currentLevel,CDTime_s);
	if currentLevel > 0 then
		--cd时间的单位为秒
		
		if CDTime_s == 0 and currentLevel ~= MountsConfig:get_mount_max_level() then 
			--如果cd时间为0，则是清除cd的回调
			MountsModel:get_mounts_info().uplevel_cdtime = 0;
			
			if UIManager:find_visible_window("mounts_win_new") then
				UIManager:find_visible_window("mounts_win_new"):clear_cd_callback();
			end

		else	--cd时间不为0，则是升级的回调

			MountsModel:get_mounts_info().level = currentLevel;
			MountsModel:get_mounts_info().uplevel_cdtime = CDTime_s;
			-- cd的终止时间点
			MountsModel:get_mounts_info().cd_endTime = GameStateManager:get_total_seconds() + CDTime_s;
			-- 更新回调
			MountsModel:set_uplevel_cdtime_callback(CDTime_s)

			if UIManager:find_visible_window("mounts_win_new") then
				UIManager:find_visible_window("mounts_win_new"):up_level_callback(MountsModel:get_mounts_info());
			end
		end
	else
		print("up level failed!");
	end
end

--消除cd时间 ,手游版 option_id只能为2，清除所有cd时间
-- c->s 19,3
function MountsCC:request_clear_cd(option_id)
	if option_id == 2 then 
		
		local pack = NetManager:get_socket():alloc(19, 3);
		pack:writeInt(option_id);
		NetManager:get_socket():SendToSrv(pack);
	else
		print("MountsCC clear_all_cd is not this option id");
	end
end

--战斗力的更变	 s->c 19,3
function MountsCC:do_fight_value_change( pack )
	local current_fight_var = pack:readInt();
	
	MountsModel:change_mount_fight_value(current_fight_var);

end

--提升品阶，option_id:1为使用仙币，2为使用元宝 c->s 19,4
function MountsCC:request_up_pinjie(option_id, money_type)
	print("提升品阶,option id ", option_id);
	local pack = NetManager:get_socket():alloc(19, 4);
	pack:writeInt(option_id);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);

end

--提升品阶callback   s->c 19,4
function MountsCC:do_up_pinjie(pack)
	local mounts_model = MountsModel:get_mounts_info();
	if not mounts_model then
		return;
	end
	
	local old_jieji = mounts_model.jieji;
	mounts_model.jieji = pack:readInt();	--当前品阶
	mounts_model.jiezhi = pack:readInt();	--当前阶值

	local win=UIManager:find_visible_window("mounts_win_new")

	-- 之后品阶提升了，才通知 mounts_win
	if old_jieji < mounts_model.jieji then
		-- 升阶之后才变幻当前的坐骑形象
		mounts_model.model_id = mounts_model.jieji;
		-- 提升了品阶之后，默认化形到当前阶的形象
		MountsModel:req_mount_huaxing( mounts_model.jieji )
		-- 升阶成功
		-- if win and win.current_page == "jinjie" then
		-- 	win.jinjie_panel:shengjie_callback( mounts_model.jieji );
		-- end
	end
	
	if win and win.current_page == "jinjie" then
	    -- 调用提升后的回调函数
		win.jinjie_panel:jinjie_tisheng_callback( mounts_model );
	end
end

-- 洗练操作，option_id:1为洗练，
-- c->s 19,5
function MountsCC:rquest_xiliang_option(xiliang_type, money_type)

	local pack = NetManager:get_socket():alloc(19, 5);

	pack:writeInt(xiliang_type);
	pack:writeByte(money_type)

	-- xiliang_type 加多了4:免费

	NetManager:get_socket():SendToSrv(pack);

end

--洗练操作callback s->c 19,5
function MountsCC:do_xiliang_option(pack)
	print("洗练返回");
	local mounts_model = MountsModel:get_mounts_info();
	
	mounts_model.zizhi_hp_exten = pack:readInt();
	mounts_model.zizhi_attack_exten = pack:readInt();
	mounts_model.zizhi_md_exten = pack:readInt();
	mounts_model.zizhi_wd_exten = pack:readInt();
	mounts_model.zizhi_bj_exten = pack:readInt();

	-- 洗炼结果
	local xilian_result_dict = {};
	-- 	int 生命
	-- 	int 攻击
	-- 	int 法 防
	-- 	int 物防
	-- 	int 暴击
	-- 	int 灵气1
	-- 	int 灵气2
	-- 	int 仙币
	-- 	int 元宝
	-- 	int 银两

	-- 	新增两个(此两项现已拆分到协议12、13)
	--  int 当天剩余免费洗练次数
	--  int 下次免费洗练CD时间
	
	for i=1,10 do
		local value = pack:readInt();

		-- if value ~= 0 then
			xilian_result_dict[i] = value;
		-- end
		
		
		-- ZXLog("----洗练属性---", i, value);
	-- end
	-- for i=11,12 do
	-- 	local value = pack:readInt();

	-- 	xilian_result_dict[i] = value;
		
	-- 	ZXLog("------洗练 CD------", i, value);
	end


	MountsModel:do_mount_xilian( xilian_result_dict );
end

--基础属性的改变，原因：升级，资质改变，装备改变    s->c 19,7
function MountsCC:do_base_attribute_change(pack)
	local model = MountsModel:get_mounts_info();
	if model ~= nil then
		model.att_hp = pack:readInt();
		model.att_attack = pack:readInt();
		model.att_md = pack:readInt();
		model.att_wd = pack:readInt();
		model.att_bj = pack:readInt();

		local win = UIManager:find_visible_window("mounts_win_new")
		local is_show_other = MountsModel:is_show_other_mounts(  )
		if win and is_show_other == false then
			local curPage = win.current_page;
			if curPage == "info" or curPage == "xilian" then
				local curPanel = win:getPage( curPage );
				if curPanel then
					curPanel:update_base_att( model );
				end
			elseif curPage == "jinjie" then
				local curPanel = win:getPage( curPage );
				if curPanel then
					curPanel:update();
				end				
			end
		end
	end
end

--提升灵犀	c->s 19,8
function MountsCC:request_up_lingxi()
	-- 玩家背包中拥有的灵犀丹数量
	local lingxidan_num = ItemModel:get_item_count_by_id( MountsConfig:getLingXiItemId() );
	if lingxidan_num < 1 then
		local function confirm2_func()
	        -- 打开梦境窗口
	        local mengjingWin = UIManager:show_window("new_dreamland_win")
	        if mengjingWin then
	        	mengjingWin:choose_yhmj_tab();
	        end
	    end
	    NormalDialog:show( Lang.mounts.common[1], confirm2_func, 1 )
		return;
	end

	local pack = NetManager:get_socket():alloc(19,8);
	NetManager:get_socket():SendToSrv(pack);
end

--灵犀提升callback 	s->c 19,8
function MountsCC:do_up_lingxi( pack )
	
	local new_lingxi =  pack:readInt();
	print("当前的灵犀值",new_lingxi);
	MountsModel:do_up_lingxi(new_lingxi);
end

--化形，model_id 哪一阶的外观 	c->s 19,9
function MountsCC:request_huaxing(model_id)
	-- body
	-- print("-------------request log:request_huaxing ");
	local pack = NetManager:get_socket():alloc(19,9);
	pack:writeInt(model_id);
	NetManager:get_socket():SendToSrv(pack);
end

--化形callback 化形成功后返回	s->c 19,9
function MountsCC:do_huaxing( pack )
	local m_id = pack:readInt();
	local spc_id = pack:readInt() --特殊坐骑外观id
	local model = MountsModel:get_mounts_info();
	if model ~= nil then
	 	model.model_id = m_id;
		model.show_id = spc_id
	 	-- if UIManager:find_window("mounts_huaxing_win") then
	 	-- 	UIManager:find_window("mounts_huaxing_win"):change_waiguan_event_callback(model.model_id);
	 	-- end 
		
		-- 天将雄师选中哪个坐骑就显示哪个坐骑形象，不需要回调修改窗口中的坐骑形象
		-- if UIManager:find_visible_window("mounts_win") then
		-- 	UIManager:find_visible_window("mounts_win"):change_mounts_avatar(model.model_id);
		-- end
		local win = UIManager:find_visible_window("mounts_win_new")
		if win and win.current_page == "info" then
			win.info_panel:play_success_effect()
		end

		-- 通知MountsModel
		if model.show_id ~= nil and model.show_id ~= 0 then
			MountsModel:change_avatar_mount( model.show_id )
		else
			MountsModel:change_avatar_mount( model.model_id )
		end
	end
end

-- check other mount info c->s 19,12
--查看他人坐骑
function MountsCC:send_check_other_mount( id, name )
	local pack = NetManager:get_socket():alloc(19,12);
	pack:writeInt(id)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack);	
end

-- s->c 19,12 更新玩家免费升阶次数和CD时间
-- 天降雄师没有了免费升阶次数，所以屏蔽掉。note by guozhinan
function MountsCC:do_update_free_shengjie_times( pack )
	-- 第一个字段：剩余次数
	-- 第二个字段：CD时间
	-- local remain_times = pack:readInt();
	-- local cd_times = pack:readInt();

	-- -- 获取当前坐骑信息
	-- local mounts_other_info = MountsModel:get_mounts_other_info();
	-- if mounts_other_info then
	-- 	mounts_other_info.sj_left_times   = remain_times;
	-- 	mounts_other_info.sj_next_cdtimes = cd_times;
	-- 	mounts_other_info.sj_start_time   = os.time()
	-- 	mounts_other_info.sj_next_cdtimes_endtime = cd_times + os.clock();

	-- 	local mounts_win = UIManager:find_visible_window("mounts_win_new")
	-- 	if mounts_win then
	-- 		-- 获取进阶子页面
	-- 		local jinjie_panel = mounts_win:getPage("jinjie");
	-- 		if jinjie_panel then
	-- 			jinjie_panel:update_cd_time();
	-- 		end
	-- 	end
	-- end
end

-- s-> 19,13 更新玩家免费洗炼次数和CD时间
function MountsCC:do_update_free_xilian_times( pack )
	-- 第一个字段：剩余次数
	-- 第二个字段：CD时间
	-- local remain_times = pack:readInt();
	-- local cd_times = pack:readInt();

	-- -- 获取当前坐骑信息
	-- local mounts_other_info = MountsModel:get_mounts_other_info();
	-- if mounts_other_info then
	-- 	mounts_other_info.xl_left_times   = remain_times
	-- 	mounts_other_info.xl_next_cdtimes = cd_times
	-- 	mounts_other_info.xl_start_time	  = os.time()
		
	-- 	local mounts_win = UIManager:find_visible_window("mounts_win_new")
	-- 	if mounts_win then
	-- 		-- 获取洗炼子页面
	-- 		local xilian_panel = mounts_win:getPage("xilian");
	-- 		if xilian_panel then
	-- 			xilian_panel:update_cd_time();
	-- 		end
	-- 	end
	-- end
end

-- c-s 19,13 特殊坐骑化形 
function MountsCC:req_spe_huaxing( id )
	local pack = NetManager:get_socket():alloc(19,13)
	pack:writeInt(id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s-c 19,14 服务器下发激活特殊坐骑
function MountsCC:do_active_spe_mounts( pack )
	local new_spe_mount = {}
	new_spe_mount.id = pack:readInt() --特殊坐骑外观id
	new_spe_mount.dead_line = pack:readUInt()--特殊坐骑激活结束时间
	local deal = pack:readChar() --1=激活坐骑 0=坐骑到期
	local spe_mounts_list = MountsModel:get_mounts_info().spc_mounts
	if deal == 1 then --激活坐骑
		local has_act = false
		for i=1,#spe_mounts_list do
			if spe_mounts_list[i].id == new_spe_mount.id then   -- 如果该特殊坐骑已激活，则替换数据
				spe_mounts_list[i] = new_spe_mount
				has_act = true
				break
			end
		end
		if has_act == false then								-- 如果该特殊坐骑未激活，则加入队列
			table.insert( spe_mounts_list,new_spe_mount )
		end
		--do sth
	elseif deal == 0 then
		for i=1,#spe_mounts_list do
			if spe_mounts_list[i].id == new_spe_mount.id then
				table.remove( spe_mounts_list,i )
				break
			end
		end
		MountsModel:get_mounts_info().show_id = 0
		if MountsModel:get_is_shangma() then
			MountsModel:ride_a_mount()
		end
		--do sth
	end
end