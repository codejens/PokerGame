-- MountsModel.lua
-- created by fjh on 2012-12-14
-- 坐骑信息模型 动态数据

-- super_class.MountsModel()
MountsModel = {}

local _has_mounts 	= false;	 --是否有坐骑
local _is_shangma 	= false;	 --是否在马上
local _mounts_info 	= nil;		 --坐骑信息
local _is_show_clear_cd_cost_tip = true; --是否显示消费提示（清除坐骑升级cd时间的）
local uplevel_cdtime_callback = callback:new()

-- added by aXing on 2013-5-25
function MountsModel:fini( ... )
	uplevel_cdtime_callback:cancel()
	_has_mounts 	= false;
	_is_shangma 	= false;
	_mounts_info 	= nil;
end

function MountsModel:set_uplevel_cdtime_callback(time)
	print("设置坐骑按钮出现的回调时间：",time)
	uplevel_cdtime_callback:cancel()
	if time > 0 and _mounts_info.level > 1
		and _mounts_info.level < MountsConfig:get_mount_max_level(  ) and EntityManager:get_player_avatar().level ~= _mounts_info.level then
		local function cd_callback()
			local cd_time = _mounts_info.cd_endTime - GameStateManager:get_total_seconds();
			if cd_time < 0 then
				_mounts_info.uplevel_cdtime = 0
			end

			local win = UIManager:find_window("mounts_win_new");
			if win == nil then
				if _mounts_info.level > 1 and _mounts_info.level < MountsConfig:get_mount_max_level(  ) and EntityManager:get_player_avatar().level ~= _mounts_info.level then
					-- 如果升级cd时间为0、且不为第一级、且不为最高级，则弹出 提示按钮
					local function open_mount_sys(  )
						UIManager:show_window("mounts_win_new");
					end
					MiniBtnWin:show( 9 , open_mount_sys );
				end
			end
		end
		uplevel_cdtime_callback:start(time,cd_callback)
	end
end

-- 设置用户坐骑信息
function MountsModel:set_mounts_info(mounts_struct)
	-- body
	_mounts_info = mounts_struct;

	local win = UIManager:find_window("mounts_win_new");
	if win == nil and _mounts_info.uplevel_cdtime == 0 and _mounts_info.level > 1 
		and _mounts_info.level < MountsConfig:get_mount_max_level(  ) and EntityManager:get_player_avatar().level ~= _mounts_info.level then
		-- 如果升级cd时间为0、且不为第一级、且不为最高级，则弹出 提示按钮
		local function open_mount_sys(  )
			UIManager:show_window("mounts_win_new");
		end
		MiniBtnWin:show( 9 , open_mount_sys );
	end
	MountsModel:set_uplevel_cdtime_callback(_mounts_info.uplevel_cdtime)
end

-- 获取用户坐骑信息
function MountsModel:get_mounts_info()
	-- body
	return _mounts_info;
end

-- 设置是否有坐骑
function MountsModel:set_has_mounts( bool_var)
	_has_mounts = bool_var;
end
-- 获取是否有坐骑
function MountsModel:get_has_mounts( bool_var)
	return _has_mounts;
end

--乘骑
function MountsModel:ride_a_mount( )
	print("切换坐骑状态",_is_shangma,"to",not _is_shangma);
	local player = EntityManager:get_player_avatar( );
	if _is_shangma == true then
		--下坐骑
		_is_shangma = false;
		player:client_get_down_mount(  )
		MountsCC:request_shangma( false );	
	else
		--上马
		local scene_id = SceneManager:get_cur_scene();
		local fuben_id = SceneManager:get_cur_fuben();
		--data/common_config.lua
		local isProtectionQuest = TaskModel:has_star_task_accepted(QuestConfig.QUEST_PROTECTION)
		print("isProtectionQuest",isProtectionQuest);
		-- 陈晔说秦皇地宫和阵营之战 暂时不允许上坐骑
		-- if fuben_id == 0 or fuben_id == 69 or fuben_id == 59  then
		-- 自由赛报名场景副本id为0，场景id为18，也是不可以上坐骑
		if (fuben_id == 0 and scene_id ~= 18) then
			-- pk状态下不能上坐骑
			if ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_PK_STATE) == 0 and 
				ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_PROTECTION) == 0  and 
				not  isProtectionQuest then
				--上坐骑
					_is_shangma = true;
					-- 主角当前是否在打坐，如果打坐就取消打坐
					player:stop_dazuo();
					local mount_id = MountsModel:get_mounts_info().model_id;
					-- 如果有特殊坐骑的化形，则上特殊坐骑
					if MountsModel:get_mounts_info().show_id ~= nil and MountsModel:get_mounts_info().show_id ~= 0 then
						mount_id = MountsModel:get_mounts_info().show_id
					end
					-- 上坐骑
					player:client_ride_a_mount( mount_id )
					MountsCC:request_shangma( true );
			else
				--判断提示 不应该放在状态切换时 注释掉 换到scenemanager  added by xiehande 2015-1-31
				-- GlobalFunc:create_screen_notic( LangModelString[381] ) -- [381]="PK或护送状态下无法骑乘!"
			end
		
		else
			require "GlobalFunc"
			GlobalFunc:create_screen_notic( LangModelString[382] ) -- [382]="副本内不能上坐骑!"
		end
		
	end
end

-- 获取是否正在乘骑的状态，这个状态其实是冗余的，在playerAvatar的属性也有一条乘骑状态
function MountsModel:get_is_shangma(  )
	return _is_shangma;
end


--  mountmodel模型层的上马状态应提供属性设置  added by xiehande on 2015-1-30
function MountsModel:set_is_shangma( is_shangma  )
	 _is_shangma = is_shangma
end



-- 修改场景上坐骑外观
function MountsModel:change_avatar_mount( mounts_id )
	local player = EntityManager:get_player_avatar();
	player:change_mount( mounts_id );
	
end


-- 显示他人的坐骑详情

function MountsModel:show_other_mounts_info( other_mount )

	local function mount_dict_to_mount_model( info_dict )

		local mount_model = {};
		mount_model.player_id = tonumber(info_dict[2]);
		mount_model.level = tonumber(info_dict[3]);
		mount_model.jieji = tonumber(info_dict[4]);
		mount_model.jiezhi = tonumber(info_dict[5]);
		mount_model.fight = tonumber(info_dict[6]);
		mount_model.lingxi = tonumber(info_dict[7]);
		mount_model.model_id = tonumber(info_dict[8]);
		mount_model.uplevel_cdtime = tonumber(info_dict[9]);
		mount_model.cd_endTime = tonumber(info_dict[10]);
		mount_model.att_hp = tonumber(info_dict[11]);
		mount_model.att_attack = tonumber(info_dict[12]);
		mount_model.att_md = tonumber(info_dict[13]);
		mount_model.att_wd = tonumber(info_dict[14]);
		mount_model.att_bj = tonumber(info_dict[15]);
		mount_model.zizhi_hp_exten = tonumber(info_dict[16]);
		mount_model.zizhi_attack_exten = tonumber(info_dict[17]);
		mount_model.zizhi_md_exten = tonumber(info_dict[18]);
		mount_model.zizhi_wd_exten = tonumber(info_dict[19]);
		mount_model.zizhi_bj_exten = tonumber(info_dict[20]);

		return mount_model;
	end
	
	MountsModel:set_show_other_mounts(true)
	local win = UIManager:show_window("other_mounts_win");
	win:show_other_mounts( mount_dict_to_mount_model(other_mount) );
	-- local win = UIManager:show_window("mounts_win_new");
	-- -- 显示他人坐骑信息
	-- win:show_other_mounts( mount_dict_to_mount_model(other_mount) );
	
end

------------------ 网络协议交互---------------

-- 服务器下发 战斗力改变
function MountsModel:change_mount_fight_value( fight_value )
	if _mounts_info then
		_mounts_info.fight = fight_value;
	end
	
	local win = UIManager:find_visible_window("mounts_win_new");
	if win ~= nil then
		win:change_mount_fight_value(fight_value);
	end
end

-- 提升坐骑等级
function MountsModel:req_up_level(  )
	--坐骑当前等级
	local mounts_current_level = MountsModel:get_mounts_info().level;
	local need_xb = MountsConfig:get_uplevel_cost_by_level(mounts_current_level);
 
	--人物当前拥有的仙币
	local current_xb = EntityManager:get_player_avatar().bindYinliang;
	--人物当前的等级
	local avatar_level = EntityManager:get_player_avatar().level;

	--升级的条件是：有足够的仙币，以及人物等级大于坐骑等级
	if (current_xb >= need_xb) and (avatar_level > mounts_current_level) then 
		if MountsModel:get_mounts_info().uplevel_cdtime == 0 then
			--升级事件	 
			MountsCC:rquest_up_level();
		end
	else
		if current_xb < need_xb then
			-- GlobalFunc:create_screen_notic( LangModelString[147] ); -- [147]="仙币不足"
			--天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	    ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )

		elseif avatar_level <= mounts_current_level then
			GlobalFunc:create_screen_notic( LangModelString[383] ); -- [383]="坐骑等级不能超过人物等级"
		end
	end
end

-- 清楚坐骑升级的cd时间
function MountsModel:req_clear_cd_time(  )
	local current_yb = EntityManager:get_player_avatar().yuanbao;
	local need_yb = MountsConfig:get_clear_cd_cost_by_level(_mounts_info.level);

	local function local_callback_function()
		if current_yb < need_yb then
			-- GlobalFunc:create_screen_notic( "元宝不足" );
			local function confirm2_func()
	            UIManager:show_window( "chong_zhi_win" )
	    	end
	    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
			return;
		end 
		MountsCC:request_clear_cd(2);		
	end

    --确定按钮回调
    local function yes_but_back( ) 
        local_callback_function()
    end 
    --勾选按钮回调
    local function swith_but_back( is_show)
        _is_show_clear_cd_cost_tip = not is_show
    end
    --如果显示提示框
    if _is_show_clear_cd_cost_tip then 
        local content = Lang.mounts.common[2]..need_yb..Lang.mounts.common[3] -- [1598]="是否花费" [453]="元宝" [1358]="立即完成"
        ConfirmWin2:show(5,nil,content,yes_but_back,swith_but_back)
    else
        local_callback_function()
    end	
end

-- 提升灵犀
function MountsModel:do_up_lingxi( new_lingxi )
    --xiehande
	local mountsWin=UIManager:find_visible_window("mounts_win_new");
    local lingXiWin;
    if mountsWin then
		lingXiWin = mountsWin:getPage("info");
	end
	if new_lingxi > _mounts_info.lingxi then
		-- 提升灵犀成功
		--GlobalFunc:create_screen_notic( LangModelString[384] ); -- [384]="提升灵犀成功"
        if lingXiWin then 
        	lingXiWin:play_lingxi_success_effect()
        end	
	else
		-- 提升灵犀失败
		GlobalFunc:create_screen_notic( LangModelString[385] ); -- [385]="提升灵犀失败"
	end

	-- 更新坐骑的灵犀属性
	_mounts_info.lingxi = new_lingxi;
	

--	if UIManager:find_visible_window("mounts_win_new") then 
		--更新坐骑灵犀界面
	--	local mountsWin = UIManager:find_visible_window("mounts_win_new");
	--	local lingXiWin = mountsWin:getPage("lingxi")
		
		if lingXiWin then
			lingXiWin:lxts_callback(MountsModel:get_mounts_info());
		end
	--end
end

-- 炫耀坐骑
function MountsModel:req_xuanyao_event(  )
	local mount_info = MountsModel:get_mounts_info()
	if not mount_info then
		return
	end
	
	local temp_info = string.format( "%s%d%s%d%s%d%s%s%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s%s",
		ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
		ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		ChatConfig.ChatAdditionInfo.TYPE_MOUNT, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		mount_info.model_id, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		Hyperlink:get_first_function_target(), Hyperlink:get_third_open_sys_win_target(),11,
		mount_info.player_id, mount_info.level, mount_info.jieji, mount_info.jiezhi, mount_info.fight,
		mount_info.lingxi, mount_info.model_id, mount_info.uplevel_cdtime, mount_info.cd_endTime, mount_info.att_hp,
		mount_info.att_attack, mount_info.att_md, mount_info.att_wd, mount_info.att_bj, mount_info.zizhi_hp_exten,
		mount_info.zizhi_attack_exten, mount_info.zizhi_md_exten, mount_info.zizhi_wd_exten, mount_info.zizhi_bj_exten,
		ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)

	ChatCC:send_chat(ChatModel:get_cur_chanel_select(), 0, temp_info)
end

-- 坐骑化形
function MountsModel:req_mount_huaxing( mounts_model_id )
	if mounts_model_id <= MountsModel:get_mounts_info().jieji then
		MountsCC:request_huaxing(mounts_model_id);
	else
		local stagesOther_config = MountsConfig:get_stagesOther_config()
		local mounts_ex_max_jieji = #stagesOther_config
		if mounts_model_id > 100 and mounts_model_id <= mounts_ex_max_jieji + 100 then
			MountsCC:req_spe_huaxing( mounts_model_id )
		end
	end
end

-- xiliang_type:1为仙币洗练，2为20元宝洗练，3为200元宝洗练 4为免费洗炼(新增协议)
function MountsModel:req_mount_xilian( xiliang_type )
	local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
	local xilianfu_num = ItemModel:get_item_count_by_id( 64700 );

	local param = {xiliang_type, money_type}
	local upgrade_func = function( param )
		MountsCC:rquest_xiliang_option(param[1], param[2])
	end

	if xiliang_type == 1 then
		-- 普通洗练，花费仙币
		--人物当前拥有的仙币
		local current_xb = EntityManager:get_player_avatar().bindYinliang;
		if current_xb < 30000 then
			-- GlobalFunc:create_screen_notic( LangModelString[147] ); -- [147]="仙币不足"
			--天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	    ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )
			return;
		else
			MountsCC:rquest_xiliang_option( xiliang_type, money_type );
		end
	elseif xiliang_type == 2 then

		-- 元宝洗练，需要仙尊等级超过1， 花费20元宝
		-- local current_yb = EntityManager:get_player_avatar().yuanbao;
		if xilianfu_num < 1 then
			-- -- GlobalFunc:create_screen_notic( "元宝不足" );
			-- local function confirm2_func()
	  --           GlobalFunc:chong_zhi_enter_fun()
	  --           --UIManager:show_window( "chong_zhi_win" )
	  --   	end
	  --   	ConfirmWin2:show( 2, 2, "",  confirm2_func)
			-- return;
			local price = 20
			MallModel:handle_auto_buy( price, upgrade_func, param )

		elseif xilianfu_num >= 1 then
			GlobalFunc:create_screen_notic( Lang.mounts.common[4] );
			MountsCC:rquest_xiliang_option( xiliang_type, money_type );
		else
			MountsCC:rquest_xiliang_option( xiliang_type, money_type );
		end
		
	elseif xiliang_type == 3 then
		-- 元宝洗练，需要仙尊等级超过5， 花费200元宝
		local str = ""
		local price = 0
		local current_yb = EntityManager:get_player_avatar().yuanbao;
		if  xilianfu_num >= 10 then
			str = Lang.mounts.common[5];	-- "是否消耗10个洗炼符洗炼10次?"
			local function sure_fun()
				MountsCC:rquest_xiliang_option( xiliang_type, money_type);
			end
			SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_MOUNT_XILIAN ,sure_fun,str )
		elseif xilianfu_num < 10 and xilianfu_num > 0 then
			local yb_cost = 200 - xilianfu_num*20;
			str = string.format(Lang.mounts.common[6],xilianfu_num, yb_cost);	-- 是否消耗%d个洗炼符%d元宝洗炼10次？
			local function sure_fun()
				MallModel:handle_auto_buy( yb_cost, upgrade_func, param )
			end
			SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_MOUNT_XILIAN ,sure_fun,str )
		else
			local price = 200
			local function sure_fun()
				MallModel:handle_auto_buy( price, upgrade_func, param )
			end
			str = Lang.mounts.common[7] --"是否消耗0个洗炼符和200元宝洗炼10次？"
			SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_MOUNT_XILIAN ,sure_fun,str )
		end
	elseif xiliang_type == 4 then
		-- 免费洗炼.新增一天可以免费洗炼3次
		MountsCC:rquest_xiliang_option( xiliang_type, money_type);
	end

	-- MountsCC:rquest_xiliang_option( xiliang_type);
end

-- 洗练返回
function MountsModel:do_mount_xilian( xiliang_result )

	local win = UIManager:find_visible_window( "mounts_win_new" );
	if win then
		win.xilian_panel:xianlin_event_callback( xiliang_result );
	end

end


-- 提升坐骑阶级
-- option_id: 1 == 仙币提升一次, 2 == 元宝提升一次, 3 == 仙币提升50次, 4 == 元宝提升50次 
function MountsModel:req_mount_up_stage( option_id )
	
	local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
	local user_yb = EntityManager:get_player_avatar().yuanbao;

	local param = {option_id, money_type}
	local upgrade_func = function( param )
		MountsCC:request_up_pinjie(param[1], param[2])
	end

	if option_id == 2 then
		
		local jinjiefu_num = ItemModel:get_item_count_by_id( 18612 );
		local price = 30
		-- if jinjiefu_num <= 0 and user_yb < 30 then
		-- 	-- GlobalFunc:create_screen_notic( "元宝不足" );
		-- 	local function confirm2_func()
	 --            GlobalFunc:chong_zhi_enter_fun()
	 --            --UIManager:show_window( "chong_zhi_win" )
	 --    	end
	 --    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
		-- 	return;
		-- end
		if jinjiefu_num <=0 then
			if jinjiefu_num <= 0 then
				MallModel:handle_auto_buy( price, upgrade_func, param )
			end
			return
		end
	elseif option_id == 4 then
		local str = "";
		local jinjiefu_num = ItemModel:get_item_count_by_id( 18612 );
		local price = 0
		print("坐骑进阶符，",jinjiefu_num);
		if jinjiefu_num >= 50 then
			str = Lang.mounts.common[8] -- "是否消耗50个进阶符提升50次";
		else
			local count = 50 - jinjiefu_num;
			local yb_cost = count * 30;
			price = yb_cost
			-- if yb_cost > EntityManager:get_player_avatar().yuanbao then
			-- 	-- 如果需要的元宝大于拥有的元宝
			-- 	local function confirm2_func()
		 --            UIManager:show_window( "ios_win" )
		 --    	end
		 --    		ConfirmWin2:show( 2, 2, "",  confirm2_func)
		 --    	return true;
	  --   	end

			str = string.format(Lang.mounts.common[9],jinjiefu_num, yb_cost); -- "是否消耗%d个进阶符%d元宝提升50次"
		end

		local function sure_fun()
			MallModel:handle_auto_buy( price, upgrade_func, param )
		end
		
	    SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_MOUNT ,sure_fun,str )	
	    return
	end

	MountsCC:request_up_pinjie(option_id, money_type);

end

-- 如果当前是上坐骑状态就下坐骑
function MountsModel:dismount(  )
	local player = EntityManager:get_player_avatar();
 	if ( ZXLuaUtils:band( player.state , EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
    	-- 下坐骑
    	MountsModel:ride_a_mount( )
    end
end

--查看他人坐骑
function MountsModel:show_other_mounts_by_info(info)
	MountsModel:set_show_other_mounts(true)
	local win = UIManager:show_window("other_mounts_win");
	win:show_other_mounts( info );
end

local _is_show_other_mounts = false	-- 这个标志位已经废弃，显示其他人坐骑不再重用MountsWinNew窗口
function MountsModel:is_show_other_mounts(  )
	return _is_show_other_mounts
end

function MountsModel:set_show_other_mounts( is_show )
	-- 这个标志位已经废弃，显示其他人坐骑不再重用MountsWinNew窗口
	_is_show_other_mounts = is_show
end

-- 根据道具id获得特殊坐骑的模型id
function MountsModel:get_spe_mounts_model_id_by_item_id( item_id )
	local cfg = MountsConfig:get_config().stagesOther
	for i,v in ipairs(cfg) do
		local t = v.openItemId
		for j,e in ipairs(t) do
			if e == item_id then 
				return v.modelId
			end
		end
	end
	return nil
end
-- 根据道具id获得坐骑信息
function MountsModel:get_spe_mounts_info_by_item_id( item_id )
	local cfg = MountsConfig:get_config().stagesOther
	for i,v in ipairs(cfg) do
		local t = v.openItemId
		for j,e in ipairs(t) do
			if e == item_id then 
				return v
			end
		end
	end
end