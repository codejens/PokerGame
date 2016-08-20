-- GlobalFunc.lua
-- create by hcl on 2013-2-21
-- 全局函数

GlobalFunc = {}

-- 访问npc 
-- target_scene_id,目标场景id
-- npc_name,npc的名字
function GlobalFunc:ask_npc( target_scene_id,npc_name  )
	if  SceneManager:get_cur_fuben() > 0 then
		GlobalFunc:create_screen_notic(LangCommonString[18]); -- [18]="副本中不能自动寻路"
		return
	end
	AIManager:ask_npc( target_scene_id,npc_name )
end

-- 访问npc 
-- target_scene_name,目标场景名字
-- npc_name,npc的名字
function GlobalFunc:ask_npc_by_scene_name( target_scene_name,npc_name  )
	if  SceneManager:get_cur_fuben() > 0 then
		GlobalFunc:create_screen_notic(LangCommonString[18]); -- [18]="副本中不能自动寻路"
		return
	end
	local target_scene_id = SceneConfig:get_id_by_name( target_scene_name ) 
	AIManager:ask_npc( target_scene_id,npc_name )
end


-- 传送
-- target_scene_id,目标场景id
-- npc_name,npc的名字
function GlobalFunc:teleport( target_scene_id,npc_name )
print("function GlobalFunc:teleport( target_scene_id,npc_name )")
	local player = EntityManager:get_player_avatar();
	player:stop_all_action();
	-- 设置传送过去后的动作
	AIManager:set_after_pos_change_command( target_scene_id , AIConfig.COMMAND_ASK_NPC, npc_name  );
	local scene_name = SceneConfig:get_scene_name_by_id(target_scene_id);
	print("target_scene_id , npc_name",target_scene_id , npc_name)
	local scene_x,scene_y = SceneConfig:get_npc_pos( target_scene_id , npc_name );		
	MiscCC:req_teleport(target_scene_id,scene_name,scene_x,scene_y);
end

-- 根据场景名称和npc名称传送
function GlobalFunc:teleport_by_name( target_scene_name,npc_name )

	local target_scene_id = SceneConfig:get_id_by_name( target_scene_name ) 
	GlobalFunc:teleport( target_scene_id,npc_name )
end

-- 移动到某个场景的某个坐标 x,y 像素坐标(格子坐标*格子宽)
function GlobalFunc:move_to_target_scene( target_scene_id,x,y ) 
	if target_scene_id ~= SceneManager:get_cur_scene() and SceneManager:get_cur_fuben() > 0 then
		GlobalFunc:create_screen_notic(LangCommonString[18]); -- [18]="副本中不能自动寻路"
		return
	end
	AIManager:move_to_target_scene( target_scene_id,x,y );
end

-- 传送到某个场景的某个坐标 x,y 格子坐标
function GlobalFunc:teleport_to_target_scene( target_scene_id,x,y ) 

	local player = EntityManager:get_player_avatar();
	player:stop_all_action();
	AIManager:set_AIManager_idle(  );
	local scene_name = SceneConfig:get_scene_name_by_id(target_scene_id);	
	MiscCC:req_teleport(target_scene_id,scene_name,x,y);
end

-- 打开界面
-- window_id ,窗口id 0,背包1,人物属性2,任务3,技能4,炼器5,仙宗6,寄卖7,系统8,商城
--						13,普通对话框,15,欢迎界面,16,任务刷星界面17,购买速传道具对话框
--						18,仓库19,护送美女界面20,还可以护送仙女次数，是否返回去接21,玩法与规则界面
--						22,送花界面23,神秘商店24,消费引导25,打开仓库的提示界面26,打开十一抽奖界面
--						27,打开宠物界面,28,坐骑引导界面,29,渡劫30,灵根31,斗法台32,兑换
-- open_or_close,打开还是关闭
-- parma,参数
	
function GlobalFunc:open_or_close_window( window_id ,open_or_close ,param,open_or_close_window,is_mini_task_panel_click)

	--print("window_id = ",window_id);

	local window_name = "";
	if window_id == 0 then					
		window_name = "bag_win"				-- 背包
	elseif window_id == 1 then
		window_name = "user_equip_win"		-- 人物属性
	elseif window_id == 2 then				
		window_name = "task_win"			-- 任务
	elseif window_id == 3 then
		window_name = "user_skill_win"		-- 技能
	elseif window_id == 4 then
		window_name = "forge_win"			-- 炼器
	elseif window_id == 5 then
		window_name = "guild_win"			-- 仙宗
	elseif window_id == 6 then
		window_name = nil					-- 寄卖
	elseif window_id == 7 then
		window_name = nil					-- 系统
	elseif window_id == 8 then
		window_name = "mall_win" 			-- 商城
	elseif window_id == 9 then
		window_name = nil					-- 弃用
	elseif window_id == 10 then
		window_name = nil					-- 弃用
	elseif window_id == 11 then
		local item_id = param
		-- TODO:: 打开一个购买的小窗口
		--BuyItemBox.getInstance().showByItemId(id,null,true,1,0,1,true)
		BuyKeyboardWin:show(item_id,nil,1);
	elseif window_id == 12 then
		window_name = nil					-- 弃用
	elseif window_id == 13 then
		-- 显示一个dialog 参数类型 标题,内容  用逗号隔开
		window_name = nil
	elseif window_id == 14 then
		window_name = nil					-- 弃用
	elseif window_id == 15 then
		-- window_name = nil
		window_name = "welcome_win"			-- 欢迎界面
	elseif window_id == 16 then
		-- 48222
		local zycmb_info = ItemModel:get_item_info_by_id( 48222 );
		if ( zycmb_info ) then
			ItemModel:use_a_item( zycmb_info.series, 0 );
		end

		--ZYCMWin:show(param); 				-- 任务刷星界面
	elseif window_id == 17 then
		window_name = nil					-- 购买速传道具对话框
	elseif window_id == 18 then
		window_name = "cangku_win" 			-- 打开仓库
	elseif window_id == 19 then
		window_name = nil 					-- 护送美女界面
	elseif window_id == 20 then
		window_name = nil					-- 还可以护送仙女次数，是否返回去接
	elseif window_id == 21 then
		window_name = nil					-- 玩法与规则界面
	elseif window_id == 22 then
		window_name = nil					-- 送花界面
	elseif window_id == 23 then
		window_name = nil					-- 神秘商店
	elseif window_id == 24 then
		-- 泉亲要求接到任务不主动弹出窗口，避免我们游戏显得太坑钱（次奥，射雕又要求要主动弹出了！！）
		-- if is_mini_task_panel_click ~= nil and is_mini_task_panel_click == true then
			window_name = "jptz_dialog"			-- 消费引导
		-- end
	elseif window_id == 25 then
		window_name = nil					-- 打开仓库的提示界面
	elseif window_id == 26 then
		window_name = nil 					-- 打开十一抽奖界面
	elseif window_id == 27 then
		window_name = "pet_win"				-- 打开宠物界面
	elseif window_id == 28 then
		window_name = nil					-- 坐骑引导界面
	elseif window_id == 29 then
		if open_or_close_window then 
			window_name = "dujie_win"					-- 渡劫
		end
	elseif window_id == 30 then
		window_name = "linggen_win"			-- 30,灵根
	elseif window_id == 31 then
		window_name = "doufatai_win"		-- 31,斗法台
	elseif window_id == 32 then
		window_name = "exchange_win"		-- 兑换
	elseif window_id == 33 then 			-- 跑环
		window_name = "pao_huan_win"
	end

	if ( open_or_close == nil ) then
		open_or_close = 0;
	end

	--print("window_name = ",window_name);

	if window_name ~= nil then
		if open_or_close == 0 then
			UIManager:show_window(window_name)
		else
			UIManager:hide_window(window_name)
		end
	end
end

-- 根据字符串执行相应的操作 show_window(window_type):打开窗口 ask_npc(npc_name):访问npc
function GlobalFunc:parse_str( str, is_mini_task_panel_click )
	print("str = ",str);
	if ( str and str ~= "") then
		local str_table = Utils:Split( str, "/" );
		if ( str_table[2] ) then
			str_table = Utils:Split( str_table[2], "," );  
			if( str_table[1] == "@show_window" ) then
				-- 打开界面
				GlobalFunc:open_or_close_window( tonumber(str_table[2]) , 0 ,nil,nil,is_mini_task_panel_click);
			elseif ( str_table[1] == "@ask_npc" ) then
				local sceneid = SceneConfig:get_id_by_name( str_table[2] );
				GlobalFunc:ask_npc( sceneid,str_table[3]  )
			end
		end
	end
end

-- 根据字符串执行相应的操作 show_window(window_type):打开窗口 ask_npc(npc_name):访问npc
function GlobalFunc:parse_str2( str,open_or_close_window )
	local str_table = Utils:Split( str, "," );  
	if( str_table[1] == "@show_window" ) then
		-- 打开界面
		GlobalFunc:open_or_close_window( tonumber(str_table[2]) , 0,open_or_close_window );
	elseif ( str_table[1] == "@ask_npc" ) then
		local sceneid = SceneConfig:get_id_by_name( str_table[2] );
		GlobalFunc:ask_npc( sceneid,str_table[3]  )
	end
end

--跑马灯
--需要根据窗口锚点来处理
function GlobalFunc:create_screen_notic( info, fontSize, x, y , anchor)
	-- xprint("GlobalFunc:create_screen_notic( info, fontSize, x, y , anchor)")
	require "UI/ScreenNotic/ScreenNoticWin"
	
	ScreenNoticWin:create_notic(info, fontSize, x, y, anchor)
end 
--主屏公告
function GlobalFunc:create_center_notic( info, fontSize, x, y )
	require "UI/ScreenNotic/CenterNoticWin"
	CenterNoticWin:create_center_notic(info, fontSize, x, y)
end 
--
function GlobalFunc:create_screen_run_notic( info, fontsize )
	-- print("info,fontsize",info, fontsize)
 	require "UI/ScreenNotic/ScreenRunNoticWin"
 	ScreenRunNoticWin:create_run_notic( info, fontsize )
end
-----充值统一入口
function GlobalFunc:chong_zhi_enter_fun()
	if PlatformInterface.pay then
   	 	PlatformInterface:pay(0)
   	else
   		--if GlobalConfig:get_can_recharge(  ) then 
   			UIManager:show_window("pay_win")
        --else
        	--ConfirmWin2:show( 3, nil, "亲，封测期间不能充值",  nil, nil, nil )
        --end
    end
end
-----
----------------------这个是QQ平台值
function GlobalFunc:transform_target_index_platform_for_QQ(index, is_tablet)
    if index == CC_PLATFORM_IOS then
        if is_tablet then
            return 6
        else
            return 1
        end
    elseif index == CC_PLATFORM_ANDROID then
        if is_tablet then
            return 5
        else
            return 0
        end
    end
    return 0
end
----------------------根据对应平台转换对应数值
function GlobalFunc:transform_target_index_platform(index, is_tablet)

	if Target_Platform == Platform_Type.UNKNOW then
		return 4
	elseif Target_Platform == Platform_Type.YYB or Target_Platform == Platform_Type.QQHall then
		return GlobalFunc:transform_target_index_platform_for_QQ( index, is_tablet )
	end
end
----------------------
function GlobalFunc:get_phone_state_index()
    local is_tablet = phone_isTablet()
    local phone_sys = GetPlatform()
    local tt = GlobalFunc:transform_target_index_platform( phone_sys, is_tablet )
    require "platform/PlatformInterface"
    local open_id, token, pf, pf_key = PlatformInterface:getLoginRet()
    return { open_id, tt }
end
