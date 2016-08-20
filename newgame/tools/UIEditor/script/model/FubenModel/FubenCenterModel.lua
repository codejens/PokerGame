-- FubenCenterModel.lua
-- create by fjh on 2013-3-7
-- 副本第三方模型类

-- super_class.FubenCenterModel()
FubenCenterModel = {}

---------------------------------------------------
-- added by aXing on 2013-5-25
function FubenCenterModel:fini( ... )
	
end
---------------------------------------------------
--已经进入灵泉仙浴
function FubenCenterModel:did_enetr_xianyu_scene(  )
	
	XianYuModel:enter_scene_callback(  )
end
--退出灵泉仙浴
function FubenCenterModel:did_exit_xianyu_scene(  )
	
	XianYuModel:exit_xianyu_fuben(  )
end
---------------------------------------------------

---------------------------------------------------
-- 退出天元之战
local _tianyuan_timer = timer()
function FubenCenterModel:did_exit_tianyuan_battle(  )
	_tianyuan_timer:stop()
end 

--进入天元之战
function FubenCenterModel:did_enter_tianyuan_battle(  )

	FubenTongjiModel:req_tianyuan_battle_tongji( );

	local function tianyu_battle_tongji_tick(  )
		
		
		FubenTongjiModel:req_tianyuan_battle_tongji( );
	end
	_tianyuan_timer:start(10, tianyu_battle_tongji_tick)
end
---------------------------------------------------

---------------------------------------------------
--退出赏金副本
function FubenCenterModel:did_exit_shangjin_fuben(  )
	
	ShangJinBuffView:destroy_buff( )
	FuBenModel:clear_shangjin_money( );
end
---------------------------------------------------

---------------------------------------------------
-- 进入了渡劫副本
function FubenCenterModel:did_enter_dujie_fuben(  )
	DujieModel:did_enter_dujie_scene();
end
---------------------------------------------------

---------------------------------------------------
-- 进入普通婚宴副本
function FubenCenterModel:did_enter_putong_hunyan(  )
	MarriageModel:did_enter_hunyan( MarriageModel.WEDDING_TYPE_PUTONG )
end
-- 退出普通婚宴副本
function FubenCenterModel:did_exit_putong_hunyan(  )
	MarriageModel:did_exit_hunyan( MarriageModel.WEDDING_TYPE_PUTONG )
end
function FubenCenterModel:did_enter_haohua_hunyan(  )
	MarriageModel:did_enter_hunyan( MarriageModel.WEDDING_TYPE_HAOHUA )
end
function FubenCenterModel:did_exit_haohua_hunyan(  )
	MarriageModel:did_exit_hunyan( MarriageModel.WEDDING_TYPE_HAOHUA )
end

---------------------------------------------------

-------------------------------------------------------
function FubenCenterModel:did_enter_ziyousai()
	FubenTongjiModel:update_tongji( 998, 1 );
end
function FubenCenterModel:did_enter_zhengbasai()
	FubenTongjiModel:update_tongji( 998, 2 );
end
-------------------------------------------------------
-- 进入体验变身副本
function FubenCenterModel:did_enter_tiyanbianshen_scene()
	-- 请求副本体验变身
	local cb = callback:new();
	local function func()
		TransformCC:request_experience_transform( 1 )
	end
	cb:start( 2, func );
end
-------------------------------------------------------
function FubenCenterModel:did_exit_tiyanbianshen_scene()
	-- TransformCC:request_over_transform_experience()
	-- TransformCC:request_begin_count_down( 1 );
end

-- 场景字典
local scene_dict ={
	
	[1077] 	= FubenCenterModel.did_enetr_xianyu_scene;
	[28]	= FubenCenterModel.did_enter_tianyuan_battle;
	[1001]  = FubenCenterModel.did_enter_dujie_fuben;
	[1136]	= FubenCenterModel.did_enter_putong_hunyan;
	[1137]	= FubenCenterModel.did_enter_haohua_hunyan;
	[18] 	= FubenCenterModel.did_enter_ziyousai;
	[1135]  = FubenCenterModel.did_enter_zhengbasai;
	[1050]  = FubenCenterModel.did_enter_tiyanbianshen_scene;
};
-- 副本字典
local fuben_dict ={
	[5]		= FubenCenterModel.did_exit_tiyanbianshen_scene;
	[8]		= FubenCenterModel.did_exit_shangjin_fuben;
	[61] 	= FubenCenterModel.did_exit_xianyu_scene;
	[999] 	= FubenCenterModel.did_exit_tianyuan_battle;
	[73]	= FubenCenterModel.did_exit_putong_hunyan;
	[74]	= FubenCenterModel.did_exit_haohua_hunyan;
}

-- 副本id的缓存
local _fuben_id = nil;

-- 进入场景的统一入口
function FubenCenterModel:did_eneter_scene(fb_id, scene_id, old_scene_id)
	
	_fuben_id = fb_id;

	-- 凡是进入副本，统一下坐骑，但是副本有特殊的是，天元之战、八卦地宫不用下坐骑
	if _fuben_id ~= 0 then 
		if _fuben_id == 69 or _fuben_id == 59 or _fuben_id == 61 then
			-- 天元之战、八卦地宫不用下坐骑，轮空
			-- fuben id 61是仙浴副本，这个副本也需要下坐骑，但是由XianyuModel特殊处理
		else 
			--------- 收起坐骑
			
			--先判断是否坐上了坐骑
			local _player_is_ride_mount = MountsModel:get_is_shangma( );
			if _player_is_ride_mount == true then
				--下坐骑
				MountsModel:ride_a_mount( );
			end
		end

		if scene_id >= 1001 and scene_id <= 1045 then
			-- 场景1001到1045为渡劫场景
			scene_id = 1001;
		end
		-- -- 场景 1132-1134 为自由赛pk场景
		-- if scene_id >= 1132 and scene_id <= 1134 then
		-- 	scene_id = 1132;
		-- end
	else
		-- 对于副本id=0的情况下，还有些场景(自由赛报名场景18、)是要下坐骑的，这里处理一下
		if scene_id == 18 then
			--------- 收起坐骑
			--先判断是否坐上了坐骑
			local _player_is_ride_mount = MountsModel:get_is_shangma( );
			if _player_is_ride_mount == true then
				--下坐骑
				MountsModel:ride_a_mount( );
			end
		end

		-- 进入的不是副本,玩家进入新手体验副本(不是真正的副本),或者从新手体验副本中出来
		if old_scene_id == 27 and scene_id ~= 0 then
			-- 显示其他玩家
			EntityManager:restore_show_entity_from_newercamp()
			-- 重新申请技能列表
			UserSkillCC:request_skill_list(false)
			-- 请求服务器端下发玩家设置信息
			SetSystemModel:request_set_date()
			-- 请求服务器下发玩家宠物列表
			-- PetCC:req_get_pet_list()
			-- 请求服务器下发玩家任务信息
			TaskCC:req_task_list()
			-- 以防万一,清楚新手副本的怪物和选中
			local player = EntityManager:get_player_avatar();
			local win = UIManager:find_window("menus_panel");
		    if ( win ) then
		        win:updateAngerBar(player.anger or 0);
		    end
			player:set_target(nil);
			DummyControlCC:ClearMonster()
		end
	end

	--拆分
	local enter_scene = scene_dict[scene_id];
	--进入场景
	if enter_scene ~=nil then
		enter_scene();
	end

end

-- 退出副本的统一出口
function FubenCenterModel:did_exit_fuben( fuben_id )
	
	local exit_fuben = fuben_dict[fuben_id];
	--退出副本
	if exit_fuben ~= nil then
		exit_fuben();
	end

end

-- 获取当前场景的副本id
function FubenCenterModel:get_current_fb_id(  )
	return _fuben_id;
end

-- 副本中弹出一些对话框
--local _message_dialog_scheduler_id = 0;
function FubenCenterModel:show_message_dialog( data )

	-- 预防一下连续弹出系统对话框
	local win = UIManager:find_visible_window("sysmsg_dialog")
	if win then
		print("已经有系统对话框了，不再继续弹出！忽略后面要求打开的")
		return;
	end

	SysMsgDialog:show_dialog(data);

	--自动计时关闭
    if data.alive_time > 0  and data.unkown~=-1 then
    	-- 连续打开count_down_view好像有报错，这里预防一下
    	UIManager:destroy_window("count_down_view")

        -- print("!!!!!!!!!!!!!!!!!!!!!data.alive_time,data.unkown",data.alive_time,data.unkown)
        -- 对于倒计时为10，而且是系统对话框的倒计时的情况，会重置一下CountDownView的number_img位置，如果倒计时大于10，会出现适配问题
        local countTimeWin = CountDownView:show(0,data.alive_time,true)

        countTimeWin.view:setPosition(UIScreenPos.relativeWidth(0.5),UIScreenPos.relativeHeight(0.4))
    end

	local function destroy_dialog(  )
		
		FubenCenterModel:destory_message_dialog( )
	end

end
-- 销毁对话框
function FubenCenterModel:destory_message_dialog(  )
	
	
	SysMsgDialog:destory_dialog()
	--[[貌似什么都没做
	if _message_dialog_scheduler_id ~= 0 then
		CCScheduler:sharedScheduler():unscheduleScriptEntry(_message_dialog_scheduler_id);
		_message_dialog_scheduler_id = 0;
	end
	]]--
end
-- 操作了对话框，给服务放回操作消息
function FubenCenterModel:req_message_dialog(npc_handle, btn_index,message_id )
	print("npc_handle, btn_index,message_id",npc_handle, btn_index,message_id )
	GameLogicCC:req_message_dialog( npc_handle, btn_index, message_id );
	FubenCenterModel:destory_message_dialog();
end


-- 在赏金副本场景里面，显示赏金buff(倒计时)
function FubenCenterModel:show_shangjin_buff(buff)	
	print("显示赏金buff");
	ShangJinBuffView:show_buff(buff);
end