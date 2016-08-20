---------------------
---------------------
--------------HJH
--------------2013-1-21
--------------对应网络协议杂七杂八
-- super_class.OthersCC()
OthersCC = {}


------------------------查看玩家信息
function OthersCC:check_player_info(playerId, playerName)
	local pack = NetManager:get_socket():alloc(26, 1)
	pack:writeInt(tonumber(playerId))
	pack:writeString(playerName)
	NetManager:get_socket():SendToSrv(pack)
	--print("send check_player_info")
end
------------------------下发玩家信息
function OthersCC:receive_player_info(pack)
	local entitydata = OthersCC:init_entity_data(pack)
	require "UI/otherAttr/OtherAttrWin"
	-- local other_attr_win = UIManager:show_window("other_attr_win")
	OtherEquipWin:open_other_panel(entitydata[1], entitydata[2])
	-- local chat_win = UIManager:find_visible_window("chat_win")
	-- local friend_win = UIManager:find_visible_window("friend_win")
	-- if chat_win ~= nil then

	-- elseif friend_win ~= nil then
	-- 	--friend_win:show_other_data(entitydata)
	-- end
	-- local chat_win = UIManager:find_window("chat_win")
	-- local user_attr_win = UIManager:show_window("user_attr_win")
	-- if chat_win ~= nil and user_attr_win ~= nil and chat_win:get_private_chat_is_active() == true then
	-- 	local entitydata = OthersCC:init_entity_data(pack)
	-- 	user_attr_win:open_other_panel(entitydata[1], entitydata[2])
	-- end
end
-----HJH
----初始化ENTITY数据
----arg:参数 与
function OthersCC:init_entity_data(arg)
	local entity = Entity()
	local playerItemInfo = {}
	entity.id 							= arg:readUInt()
	entity.sex 							= arg:readByte()
	entity.job 							= arg:readByte()
	entity.camp 						= arg:readByte()
	entity.level 						= arg:readByte()
	entity.face 						= arg:readByte()
	entity.guildId 						= arg:readInt()
	entity.QQVIP						= arg:readInt()
	local itemNum 						= arg:readByte()
	for i = 1, itemNum do 
		playerItemInfo[i] 				= UserItem(arg)
	end
	entity.outAttack 					= arg:readInt()
	entity.innerAttack					= arg:readInt()
	entity.outDefence 					= arg:readInt()
	entity.innerDefence 				= arg:readInt()
	entity.hp 							= arg:readInt()
	entity.maxHp 						= arg:readInt()
	entity.mp 							= arg:readInt()
	entity.maxMp 						= arg:readInt()
	entity.hit 							= arg:readInt()
	entity.dodge						= arg:readInt()
	entity.criticalStrikes				= arg:readInt()
	entity.defCriticalStrikes 			= arg:readInt()
	entity.criticalStrikesDamage		= arg:readFloat()
	entity.attackAppend					= arg:readInt()
	entity.subDef						= arg:readInt()
	entity.outAttackDamageAdd			= arg:readInt()
	entity.inAttackDamageAdd			= arg:readInt()
	entity.moveSpeed 					= arg:readInt()
	entity.fightValue					= arg:readInt()
	entity.charm 						= arg:readInt()
	entity.body 						= arg:readInt()
	entity.weapon 						= arg:readInt()
	entity.wing 						= arg:readInt()
	entity.name 						= arg:readString()
	entity.guild_name 					= arg:readString()
	return {entity, playerItemInfo}
end

-- 播放全屏特效
function OthersCC:do_play_global_effect( pack )
	local effect_id = pack:readWord()
	local time 		= pack:readInt();
	if FlowerEffect then
		FlowerEffect.play(effect_id, time)
	end
	print("播放全屏特效,effect_id = ",effect_id,"time = ",time);
	-- ChatFlowerModel:exit_btn_fun()
end

function OthersCC:do_play_global_effect_local( pack)
	local effect_id = pack:readWord()
	local time 		= pack:readInt();
	print("播放本地全屏特效,effect_id = ",effect_id,"time = ",time);
	LuaEffectManager:showEffect(effect_id, time)
	-- ChatFlowerModel:exit_btn_fun()
end

-- 招财进宝系统
----获取今天已经招财的次数
--s->c ,26,25
function OthersCC:do_has_zc_num( pack )
	local num1 = pack:readInt()
	local num2 = pack:readInt()
	require "model/ZhaoCaiModel"
	ZhaoCaiModel:set_has_zc_num(num2)
	ZhaoCaiModel:set_has_jinbao_num(num1)
end


-- c->s 26,24 怪物handle,x,y,朝向
function OthersCC:req_collection( monster_handle,x,y,direction )
	-- ZXLog('----------------req_collection--------------------11111-------------------')
	local pack = NetManager:get_socket():alloc(26, 24);
	-- 如果monster_handle为0代表取消采集
	pack:writeInt64(monster_handle);
	-- ZXLog('----------------req_collection-------------------22222--------------------')
	if ( monster_handle ~= 0 ) then
		pack:writeInt(x);
		pack:writeInt(y);
		pack:writeInt(direction);
	end
	-- ZXLog('----------------req_collection------------------33333---------------------')
	NetManager:get_socket():SendToSrv(pack);
	-- ZXLog('----------------req_collection--------------------44444-------------------')
end

-- s->c 26,24 采集状态变更
function OthersCC:do_collection( pack )
	local collection_state = pack:readInt();
	-- print("-------------采集结果状态---------------",collection_state);
	if ( collection_state == 1 ) then

		ActionGather:do_secces_gather(  )

		local collection_time = pack:readInt();
		-- print("collection_time = ",collection_time);
		-- TODO 更新采集进度条
		ProcessBar:show(collection_time);
	elseif ( collection_state == 0 ) then
		ProcessBar:hide();
		-- 更新主界面的任务进度
		-- local win = UIManager:find_window("user_panel")
		-- if ( win ) then
		-- 	win:update(4,{task_id,task_index,task_percent});
		-- end
	end
end

--离开副本  立即退出副本
function OthersCC:req_exit_fuben()
	print("请求立即退出副本")
	local pack = NetManager:get_socket():alloc(26, 33);
	NetManager:get_socket():SendToSrv(pack);
end

-- 26,25获取今天进入各个副本的次数
function OthersCC:req_get_enter_fuben_count()
	print("c->s, (26,25)")
	local pack = NetManager:get_socket():alloc(26, 25);
	NetManager:get_socket():SendToSrv(pack);
end

-- 26,28 下发今天进入各个副本的次数
function OthersCC:do_get_enter_fuben_count( pack )
	print("s->c, (26,28)")
	require "struct/FuBenStruct"
	local info_count = pack:readInt();
	local fuben_info_table = {};
	for i=1,info_count do
		fuben_info_table[i] = FuBenStruct(pack);
		-- print("--------fuben_info_table[i]:", fuben_info_table[i].fuben_id, fuben_info_table[i].count, fuben_info_table[i].vip_add)
		-- debug.debug()
	end
	require "model/FubenModel/FuBenModel"
	FuBenModel:set_fuben_info_table( fuben_info_table );
	-- local info_count = pack:readInt()
	-- local fuben_info_table = {}

	-- for i=1,info_count do
	-- 	fuben_info_table[i] = {}
	-- 	fuben_info_table[i].list_id = pack:readInt()
	-- 	fuben_info_table[i].remain_count = pack:readInt()
	-- 	local fuben_list_data = ActivityModel:get_activity_info_by_class( "fuben" )
	-- 	fuben_info_table[i].fuben_id = fuben_list_data[i].id
	-- 	fuben_info_table[i].count = fuben_info_table[i].remain_count
	-- 	print("--------fuben_info_table[i].remain_count:", fuben_info_table[i].remain_count)
	-- 	fuben_info_table[i].vip_add = 0
	-- 	-- print("i,fuben_info_table[i].list_id,fuben_info_table[i].remain_count",i,fuben_info_table[i].list_id,fuben_info_table[i].remain_count)
	-- end

	-- require "model/FubenModel/FuBenModel"
	-- FuBenModel:set_fuben_info_table( fuben_info_table )
end

-- 26,38服务器下发 今日进入某个副本的次数信息
function OthersCC:do_update_enter_fuben_info( pack )
	local fuben_struct = FuBenStruct(pack);
	-- print("OthersCC:do_update_enter_fuben_info(fuben_struct.fuben_id,fuben_struct.count,fuben_vip_add)",fuben_struct.fuben_id,fuben_struct.count,fuben_struct.vip_add)
	require "model/FubenModel/FuBenModel"
	FuBenModel:add_fuben_info_in_table( fuben_struct );
end

-- 26,26 下发副本统计信息
function OthersCC:do_fuben_tongji( pack )
	local fbId = pack:readInt()
	local actId = pack:readByte()
	local count = pack:readByte()
	print("OthersCC:do_fuben_tongji(fbId,actId,count)",fbId,actId,count)
	local tongji_dict = {}
	for i=1,count do
		local _type = pack:readByte()
		local _value = pack:readInt()
		tongji_dict[_type] = _value
		print("统计数据(_type , _value)",_type , _value)
	end
	-- 历练副本特殊处理,在副本怪打完时需要播放退出副本指引
	local first_fuben = FuBenModel:get_first_fuben()
	if first_fuben and first_fuben == fbId and fbId == 4 then
		if tongji_dict[9] == 0 and tongji_dict[11] ~= 0 then
			AIManager:set_AIManager_idle()
			local function movie_callback()
				FuBenModel:play_fire_effect()
				Instruction:start(28)
			end
			Cinema:play('act48', movie_callback)
			FuBenModel:set_first_fuben( nil )
		end
	end
	FubenTongjiModel:update_tongji( fbId, actId, tongji_dict )


	-- local account_fuben_ids = {
	-- -- 历练副本
	-- -- 4,
	-- -- 9, 
	-- -- 一骑当千
	-- -- 11,
	-- --金窟宝穴
	-- -- ,8
	-- --马踏联营
	-- -- 66,
	-- --决战雁门关
	-- -- 60,
	-- --破狱之战
	-- 58,98,99,100,101,
	-- --皇陵秘境
	-- 65,84,85,86,87,88,
	-- --天魔塔
	-- 64,114,115,116,117,118
	-- }


 --    --打完最后一个怪的时候 加一层底板 当点击这层透明层的时候
	-- local ui_node = ZXLogicScene:sharedScene():getUINode();
	-- local base_panel = CCBasePanel:panelWithFile(0,0,GameScreenConfig.ui_screen_width,GameScreenConfig.ui_screen_height,"")
	-- ui_node:addChild(base_panel,99998);

 --    local function exit_fuben_fun(eventType,args,msgid)
 --        print("SceneManager:get_cur_fuben():", SceneManager:get_cur_fuben())
 --        local curSceneId = SceneManager:get_cur_scene()
 --        -- Instruction:handleUIComponentClick(instruct_comps.TOP_RIGHT_BUTTON_FBEXIT)
 --        if curSceneId == 27 then
 --            return NewerCampCC:request_exit_newercamp()
 --        end
         

 --        --判断某个值是否存在表中
 --        function  in_array(value,list)

 --            if not list then
 --               return false   
 --            end 

 --            if list then
 --               for k, v in pairs(list) do
 --                   if v==value then
 --                      return true
 --                   end
 --               end
 --            end

 --        end 

 --        local function cb_fun()
 --            if ( SceneManager:get_cur_scene() == 18 ) then 
 --                UIManager:hide_window("pipei_dialog");
 --                XianDaoHuiCC:req_exit_zys_scene( );
 --            elseif  in_array(SceneManager:get_cur_fuben(),account_fuben_ids) then
 --                print(SceneManager:get_cur_fuben())
 --                for i=1,#account_fuben_ids do
 --                   if account_fuben_ids[i] == SceneManager:get_cur_fuben() then
 --                    print("account_fuben_ids[i] ",account_fuben_ids[i] )
 --                     OthersCC:req_can_account_fuben_data();
 --                     break
 --                   end
 --                end

 --            else
 --                SceneManager:get_cur_fuben()
 --                OthersCC:req_exit_fuben();
 --                -- 如果斗法台倒计时还存在，就清除倒计时
 --                local win = UIManager:find_visible_window("count_down_view");
 --                if ( win ) then
 --                    UIManager:destroy_window("count_down_view");
 --                end
 --                --销毁婚宴嬉戏win
 --                MarriageModel:did_exit_hunyan( );
 --            end
 --        end
 --        -- NormalDialog:show(Lang.activity.fuben[1],cb_fun) -- [1001]="是否离开副本?"
 --        cb_fun()
 --     end


     
	-- local function panel_fun(eventType,x,y)
	--     if  eventType == TOUCH_BEGAN then
	--         return true
	--     elseif eventType == TOUCH_CLICK then
 --            exit_fuben_fun()
	--     	base_panel:removeFromParentAndCleanup(true)
	--     	return true
	--     end
	--     return true
 --    end
 --    base_panel:registerScriptHandler(panel_fun);


end

-- 26,34 下发关闭统计窗口
function OthersCC:do_close_fuben_tongji(  )
	FubenTongjiModel:close_tongji_panel( )
end

-- c->s 26,38  申请用元宝增加进入副本的次数
function OthersCC:request_add_enter_fuben_count( fuben_id )
	local pack = NetManager:get_socket():alloc(26, 38)
	pack:writeWord(fuben_id);
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 26,35  申请世界boss数据
function OthersCC:request_world_boss_date( )
	local pack = NetManager:get_socket():alloc(26, 35)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c  26,35 服务器下发世界boss数据
function OthersCC:do_world_boss_date( pack )
	-- print("s->c  26,35 服务器下发世界boss数据~~~~~~~!!!!!!!!!~~~~~~~!!!!!!!")
	local count = pack:readInt()
    local boss_date_list = {}
    for i = 1, count do
    	require "struct/WorldBossStruct"
        table.insert( boss_date_list, WorldBossStruct(pack) ) 
    end
    require "model/WorldBossModel"
    -- print("服务器下发世界boss状态  ")
    WorldBossModel:set_world_boss_date( boss_date_list )
end

-- c->s 26,26 请求下发活跃奖励信息
function OthersCC:request_activity_award_info( )
	print("请求下发活跃奖励信息")
	local pack = NetManager:get_socket():alloc(26, 26)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c  26,29 服务器下发活跃奖励信息
function OthersCC:do_result_activity_award_info( pack )
	print("服务器下发活跃奖励信息")
	local activity_target_count = pack:readInt()
	local activity_times = {}                            -- 各活跃目标的次数
    for i = 1, activity_target_count do
        activity_times[i] = pack:readShort()
    end
    local award_count = pack:readInt()
    local get_award_list = {}                            -- 奖励领取情况列表
    for i = 1, award_count do
        get_award_list[i] = pack:readByte()
    end
    local today_point = pack:readInt()                   -- 今天总的活跃度

    require "model/ActivityModel"
    ActivityModel:set_activity_award_value( activity_times, get_award_list, today_point )
 --    		-- --xhd 2015-3-9
	if WelfareModel:get_daily_awrads_state() == 1 then
		BenefitModel:show_benefit_miniBtn()
	end

end

-- s->c  26,30 触发一个活跃目标事件
function OthersCC:do_activity_event( pack )
	local target_index = pack:readWord()              -- 活跃目标 配置文件的序列号
	local total_times = pack:readWord()               -- 总次数
	local today_activity_point = pack:readInt()       -- 今天总的活跃度
    target_index = target_index + 1                   -- 服务器默认从0开始，配置表从1开始，所以要加1
    
    require "model/ActivityModel"
	ActivityModel:new_activity_event_happen( target_index, total_times, today_activity_point )
end

-- c->s 26,27 请求领取活跃奖励
function OthersCC:get_activity_award( index )
	local pack = NetManager:get_socket():alloc(26, 27)
	pack:writeInt( index - 1 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c  26,31 领取活跃奖励的结果
function OthersCC:do_result_get_activity_award( pack )
	local index  =  pack:readInt()
	local result =  pack:readInt()

    require "model/ActivityModel"
	ActivityModel:do_get_award_result( index + 1, result )
end

-- c->s 26, 21 -----取得指定排行榜指定页信息
function OthersCC:send_top_list_data(id, pageIndex, pageNum)
	-- print("OthersCC:send_top_list_data id, pageIndex, pageNum",id, pageIndex, pageNum)
	local pack = NetManager:get_socket():alloc( 26, 21 )
	pack:writeInt(id)
	pack:writeInt(pageIndex)
	pack:writeInt(pageNum)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 26, 21 -----获取排行榜信息
function OthersCC:receive_top_list_data(pack)
	--print("OthersCC:receive_top_list_data")
	local topId = pack:readInt()
	local num = pack:readInt()
	local pageIndex = pack:readInt()
	local pageNum = pack:readInt()
	local pageInfo = {}
	--print( string.format( "topId=%d,num=%d, pageIndex=%d, pageNum=%d", topId, num, pageIndex, pageNum) )
	require "struct/TopListStruct"
	for i = 1, num do
		pageInfo[i] = TopListStruct(pack)
	end
	--require "model/TopListModel"
	if num > 0 then
		TopListModel:add_index_top_list_info( topId, pageIndex, pageInfo, pageNum )
		-- TopListModel:add_top_list_info( topId, pageIndex, pageInfo)
		-- TopListModel:update_index_scroll_max_num(topId, pageNum)
	end
end
-- s->c 26, 22 -----获取排行榜个人信息
function OthersCC:receive_personal_top_list_info(pack)
	-- print("run othersCC:receive_personal_top_list_info===========================================")
	require "struct/TopListPersonalStruct"
	local personal_info = TopListPersonalStruct(pack)
	require "modle/TopListModel"
	TopListModel:add_role_data_info( personal_info )
end

-- c->s 26, 23
function OthersCC:send_my_top_list_info()
	local pack = NetManager:get_socket():alloc( 26, 23 )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 26, 23
function OthersCC:receive_my_top_list_info(pack)
	--print("receive_my_top_list_info")
	local num = pack:readInt()
	local top_info = {}
	for i = 1, num do 
		top_info[i] = pack:readByte()
	end
	require "model/TopListModel"
	TopListModel:open_my_top_list(top_info)
end

-- c->s 26, 37   获取某个世界boss击杀者  boss_id  worldboss配置表中的bossid
function OthersCC:request_world_boss_killer( boss_id )
	local pack = NetManager:get_socket():alloc( 26, 37 )
	pack:writeInt( boss_id )
	NetManager:get_socket():SendToSrv(pack)
	-- print(" c->s 26, 37   获取某个世界boss击杀者  boss_id  worldboss配置表中的bossid(boss_id)",boss_id)
end

-- s->c 26, 37  某个世界boss击杀者
function OthersCC:do_result_boss_killer( pack )
	local boss_id = pack:readInt()
	local player_name = pack:readString()
	-- print("26, 37  某个世界boss击杀者(boss_id,player_name)",boss_id,player_name)
	ActivityModel:set_world_boss_killer_name( boss_id, player_name )
end

-- 各个活动定时通知
-- s->c 26,36
function OthersCC:do_activity_notification( pack )
	print("各个活动定时通知~~~~~!!!!!!!!~~~~~~~~!!!!!!!")
	
	local size = pack:readInt();
	
	local activity = {};

	for i=1,size do
		local _id = pack:readInt();
		local _status = pack:readInt();
		local _time = pack:readInt();		
		activity[i] = { id = _id, status = _status, time = _time};
		print("活动时间的变化,活动id",activity[i].id, activity[i].status, activity[i].time );
	end
	
	ActivityModel:do_activity_notification( activity )

end

---26-42 s->c
function OthersCC:server_send_clear_and_update_top_list()
	-- print("Run OthersCC:server_send_clear_and_update_top_list -----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	TopListModel:check_need_clear_all_top_list_info()
end

-- 显示天元城主装备
-- 26,40
function OthersCC:do_show_tycz( pack )
	local tycz = {};
	tycz.id = pack:readInt();
	tycz.level = pack:readInt();
	tycz.camp = pack:readInt();
	tycz.job = pack:readInt();
	tycz.sex = pack:readInt();
	tycz.fightValue = pack:readInt();
	tycz.huangzhuan = pack:readInt();         -- 黄钻信息
	tycz.body  = pack:readInt()               -- 身体模型
	tycz.weapon = pack:readInt()              -- 武器
	tycz.wing   = pack:readInt()              -- 翅膀 
	tycz.guild_name = SceneManager:get_cur_tyc_lord()
	local num = pack:readInt();
	local equip_list = {}
	for i=1,num do
		equip_list[i] = UserItem(pack);
		-- print("equip_list[i].item_id::::::", i, equip_list[i].item_id)
	end
	tycz.name = pack:readString();
	-- print()
	-- print("tycz.name = ",tycz.name, num);
	-- for key ,value in pairs(tycz) do 
 --        print(key, ":::", value )
	-- end
	OtherEquipWin:open_other_panel( tycz, equip_list, true );
end

-- 下发寻路卡住的原因
function OthersCC:do_log_move_error( pack )
	local scene	= pack:readInt()		-- 卡住的场景
	local pos_x	= pack:readInt()		-- 卡住的X
	local pos_y	= pack:readInt()		-- 卡住的Y
	local err 	= pack:readInt()		-- 卡住的原因
	-- print('do_log_move_error>>>>>', scene, pos_x, pos_y, err)
	 -- err = { 1 : 当前点是不可走动点, 
		--    	 2 : 当前位置和目标位置是直线不可以走通,
		-- 	}
	-- GlobalFunc:move_to_target_scene( scene, pos_x, pos_y ) 

	if AIManager:continue_quest() then
		--local notice_content = "您的角色被障碍卡住了，系统自动帮您再次寻路["..err.."]"
		--GlobalFunc:create_screen_notic( notice_content, nil, 400 )
		--
	end
	--assert(false)
end

-- 副本的数据结算请求协议（26，45）。
-- 此协议请求后，服务器下发结算数据时会设置定时器，20秒将用户踢出副本。 note by guozhinan
function OthersCC:req_can_account_fuben_data()
	print("fb_id",fb_id)
	local pack = NetManager:get_socket():alloc(26, 45);
	local fb_id = SceneManager:get_cur_fuben();
	pack:writeInt(fb_id)
	NetManager:get_socket():SendToSrv(pack);
end

-- 对于没有传送阵退出的副本，用来请求玩家“再来一次”。目前用于必杀技副本结算面板中。（26,46）
function OthersCC:req_fight_again()
	local pack = NetManager:get_socket():alloc(26, 46);
	local fb_id = SceneManager:get_cur_fuben();
	pack:writeInt(fb_id)
	NetManager:get_socket():SendToSrv(pack);
end