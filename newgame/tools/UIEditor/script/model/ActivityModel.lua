-- ActivityModel.lua
-- created by lyl on 2012-2-20
-- 活动

-- super_class.ActivityModel()
ActivityModel = {}

local _activity_target_times = {}            -- 各活跃目标的次数. 数组序列号对应目标id
local _if_get_activity_award_list = {}       -- 奖励领取情况列表  每个用0表示没有领取过，用1表示领取过(注意，是按配置表顺序而不是id顺序)
local _today_activity_point = 0              -- 今天总的活跃度

local _world_boss_killer_name_t = {}         -- 世界boss击杀者名称， key：boss id

local show_chongzhilibao = false
local show_chongzhilibao_money = 0
local show_chongzhilibao_time = 0
local show_chongzhilibao_state = 0
local show_chongzhilibao_level = 0
local is_refresh_default_page = false
------------活动通知
-- local _activity_notification_dict = {};

local _if_teleport = false                   -- 是否使用筋斗云传送   四个界面要统一显示是否传送
local activity_tips_t = {0,0,0,0,0}	 -- 表示是否有未完成的活动模块 依次对应 1副本挑战，2日常活动，3Boss挑战，4活跃奖励，5每日福利
local activity_intime_count = 0
local fuben_times_remain = 0

--分层关卡是否通关数组
local fenceng_fuben_pass = {}
-- added by aXing on 2013-5-25
function ActivityModel:fini( ... )
	_activity_target_times = {}            -- 各活跃目标的次数. 数组序列号对应目标id
	_if_get_activity_award_list = {}       -- 奖励领取情况列表  每个用0表示没有领取过，用1表示领取过(注意，是按配置表顺序而不是id顺序)
	_today_activity_point = 0              -- 今天总的活跃度
	_world_boss_killer_name_t = {}         -- 世界boss击杀者名称， key：boss id
	_if_teleport = false                   -- 是否使用筋斗云传送   四个界面要统一显示是否传送
	show_chongzhilibao = false
	show_chongzhilibao_money = 0
	show_chongzhilibao_time = 0
	show_chongzhilibao_state = 0
	show_chongzhilibao_level = 0
	is_refresh_default_page = true
	activity_tips_t = {0,0,0,0,0}	   -- 表示是否有未完成的活动模块 依次对应 1副本挑战，2日常活动，3Boss挑战，4活跃奖励，5每日福利
	activity_intime_count = 0

	fenceng_fuben_pass ={}
end

function  ActivityModel:get_fenceng_fuben_pass(  )
	return fenceng_fuben_pass
end

function  ActivityModel:set_fenceng_fuben_pass( array )
	fenceng_fuben_pass = array
end

function ActivityModel:get_refresh_default_page()
	return is_refresh_default_page
end
function ActivityModel:set_refresh_default_page(result)
	is_refresh_default_page = result
end
-- ================================
-- 更新
-- ================================
local function update_activity_win( update_type )
    ActivityWin:update_win( update_type )

    --战役副本页面
    local zhanyifuben_win = UIManager:find_window("zhanyifuben_win")
    if zhanyifuben_win then
    	zhanyifuben_win:update(update_type)
    end

    local win = UIManager:find_visible_window("entrust_Win")
    if win then
       win:update_win("fuben_times")
    end
end

-- 进入副本次数变化
function ActivityModel:enter_fuben_time_change(  )
	update_activity_win("fuben_times")
	-- 委托已变更
	-- EntrustWin:update_win( "fuben_times" )
	SecretaryModel:update_win( "fuben_times" )
	ActivityWin:update_page_tips()
	local win = UIManager:find_window("right_top_panel")
	if win then
		-- win:update_activity_remain_tips()
	    local num = ActivityModel:get_activity_fuben_total_remain_times()

		if num > 0 then
		    win:set_btntip_active_first(4)
		else
		    win:remove_btntip_first(4)
		end
	end
	
	-- 聚仙令副本次数刷新
	local win2 = UIManager:find_visible_window("juxianling_win")
	if win2 then 
		if win2:get_page_by_index(1) then
			win2:get_page_by_index(1):update("fuben_times")
		end
	end
end

-- 数据变化  cloud_num
function ActivityModel:date_change_update( update_type )
	update_activity_win( update_type )
end

-- 获取世界boss的时间  返回值： 1.bool 是否已出现  2、如果未出现，第二个返回就是剩余时间（秒）. 否则可以直接显示
function ActivityModel:get_world_boss_time( boss_id )
	local boss_info = WorldBossModel:get_boss_by_id( boss_id )
	if boss_info then
		if boss_info.status == 1 then
            return true, LH_COLOR[6] .. Lang.wanfadating[21] -- [1]="已出现"
        else
        	return false, boss_info.remainTime
		end
	end
	return true, ""
end

-- 设置活跃奖励相关  各活跃目标的次数  奖励领取情况列表 今天总的活跃度
function ActivityModel:set_activity_award_value( activity_times, get_award_list, today_point )
	_activity_target_times      = activity_times
    _if_get_activity_award_list = get_award_list
    _today_activity_point       = today_point

    BenefitModel:update_win("target_times")
    BenefitModel:update_win("current_point")
    BenefitModel:update_win("get_award")
    SecretaryModel:update_win( "current_point" )
    
    --福字 下发  added by xiehande
    if self:check_had_activity_award() then
        -- print("有活跃奖励未领取")
        BenefitModel:show_benefit_miniBtn()
	end

	    local a1,a2,a3,a4 = WelfareModel:get_exp_back_date_by_type(1)
        local b1,b2,b3,b4 = WelfareModel:get_exp_back_date_by_type(2)
        if a3 == 1 then
            print("副本累计有未领取")
        BenefitModel:show_benefit_miniBtn()
        elseif b3 == 1 then
            print("任务累计有未领取")
        BenefitModel:show_benefit_miniBtn()
        end


end

-- 根据活跃目标id，获取相应的次数
function ActivityModel:get_time_by_activity_target( target_id )
    local index = ActivityAwardConfig:get_index_by_target_id( target_id )
	return _activity_target_times[index] or 0
end

-- 服务器触发一个活跃目标事件
function ActivityModel:new_activity_event_happen( target_index, total_times, today_activity_point )
	if _activity_target_times[target_index] then
        _activity_target_times[target_index] = total_times
	end 
	_today_activity_point = today_activity_point

	BenefitModel:update_win( "target_times" )
	BenefitModel:update_win("current_point")
	SecretaryModel:update_win( "current_point" )
end

-- ================================
-- 数据操作
-- ================================
-- 获取某类活动的静态信息  daily  fuben    
function ActivityModel:get_activity_info_by_class( class_name )
	require "config/ActivityConfig"
	-- return ActivityConfig:get_activity_info_by_class( class_name ) or {}
	local activity_temp =  ActivityConfig:get_activity_info_by_class( class_name ) or {}
	-- local function camp_func( element_1, element_2 )
	-- 	if element_1.level < element_2.level then
 --            return true
	-- 	end
	-- 	return false
	-- end
 --    table.sort( activity_temp, camp_func )
    return activity_temp
end

--获取副本分层之后的静态信息
function ActivityModel:get_activity_info_by_id_fenceng( activity_id )
	require "config/ActivityConfig"
	local activity_temp =  ActivityConfig:get_activity_info_by_id_fenceng( activity_id )
    return activity_temp
end

-- 获取世界boss活动的信息
function ActivityModel:get_world_boss_activity_info(  )
	require "config/WorldBossConfig"
	local activity_temp =  WorldBossConfig:get_world_boss_info(  ) or {}

    -- 按是否是精英boss分类， 并且每个分类按等级排序
    for i = 1, #activity_temp do
        for j = i,  #activity_temp do
            if activity_temp[i].type > activity_temp[j].type then
                local activity = activity_temp[i]
                activity_temp[i] = activity_temp[j]
                activity_temp[j] = activity
            elseif activity_temp[i].type == activity_temp[j].type and activity_temp[i].level > activity_temp[j].level then
            	local activity = activity_temp[i]
                activity_temp[i] = activity_temp[j]
                activity_temp[j] = activity
            end
        end
    end

    return activity_temp
end

-- 获取副本活动的介绍
function ActivityModel:get_activity_introduce_by_id( activity_id )
	local activity_info = ActivityConfig:get_activity_info_by_id( activity_id )
	if activity_info then
        return activity_info.desc
	end
	return ""
end

-- 获取副本活动的时间
function ActivityModel:get_activity_time_by_id( activity_id )
	local activity_info = ActivityConfig:get_activity_info_by_id(activity_id)
	if activity_info then
		return activity_info.timeDesc
	end
	return ""
end

-- 获取副本活动的奖励星星表示 名称和数量
function ActivityModel:get_activity_star( activity_id )
	local stars_info_ret_t = {}        -- 返回的信息
	local name_t = Lang.wanfadating[27]
	local activity_info = ActivityConfig:get_activity_info_by_id( activity_id )
	if activity_info then
	    local stars_t = activity_info.stars
	    for i = 1, #stars_t do
	    	stars_info_ret_t[i] = {}
            stars_info_ret_t[i].name = name_t[ stars_t[i][1] ] or ""
            stars_info_ret_t[i].num  = stars_t[i][2] or 1
	    end
	end
	return stars_info_ret_t
end

-- 获取副本奖励道具列表
function ActivityModel:get_fuben_activity_award_items( activity_id )
	local ret_item_t = {}
	local activity_info = ActivityConfig:get_activity_info_by_id( activity_id )
	if activity_info then
        for key, item in pairs(activity_info.awards) do
            if ActivityModel:check_item_with_job( item.job ) then
                table.insert( ret_item_t, item )
            end
        end
	end
	return ret_item_t
end

-- 判断是否是玩家职业
function ActivityModel:check_item_with_job( job_need )
	local player = EntityManager:get_player_avatar()
	if player.job == job_need or job_need == -1 or job_need == nil then
        return true
    else
    	return false
	end
end

-- 显示商城tips
function ActivityModel:show_mall_tips( item_id,x,y)
	local auto_x = x or 420
	local auto_y = y or 255
    TipsModel:show_shop_tip( auto_x, auto_y, item_id )
end

-- 获取当天进入副本次数和 最大次数（包括用户用元宝增加的次数）
function ActivityModel:get_enter_fuben_count( fuben_id )
    local enter_count, vip_add = FuBenModel:get_enter_fuben_count( fuben_id)
    local default_max_count = ActivityModel:get_enter_fuben_max_count( fuben_id )
    return default_max_count + vip_add-enter_count, default_max_count + vip_add
end

function ActivityModel:get_parent_fuben_count(list_id)
	local enter_count, vip_add = FuBenModel:get_parent_fuben_count( list_id)
    local default_max_count = FuBenModel:get_parent_fuben_max_count(list_id)
    return enter_count, default_max_count + vip_add
end

-- 根据副本id， 获取该副本默认最大次数
function ActivityModel:get_enter_fuben_max_count( fuben_id )
    return FuBenModel:get_enter_fuben_max_count( fuben_id )
end

-- 获取跟斗云个数
function ActivityModel:get_cloud_num(  )
	return ItemModel:get_item_total_num_by_id( 18601 )
end

-- 获取boss活动的介绍
function ActivityModel:get_boss_activity_introduce( activity_id )
	require "config/WorldBossConfig"
	local activity_info = WorldBossConfig:get_activity_info_by_id( activity_id )
	if activity_info then
        return activity_info.desc
	end
	return ""
end

-- 获取boss活动的奖励星星表示 名称和数量
function ActivityModel:get_boss_activity_star( activity_id )
	local stars_info_ret_t = {}        -- 返回的信息
	local name_t = Lang.wanfadating[27]
	-- [2]="经验" -- [3]="灵气" -- [4]="历练" -- [5]="仙币" -- [6]="装备" -- [7]="道具" -- [8]="银两"
	require "config/WorldBossConfig"
	local activity_info = WorldBossConfig:get_activity_info_by_id( activity_id )
	if activity_info then
	    local stars_t = activity_info.stars
	    for i = 1, #stars_t do
	    	stars_info_ret_t[i] = {}
            stars_info_ret_t[i].name = name_t[ stars_t[i][1] ] or ""
            stars_info_ret_t[i].num  = stars_t[i][2] or 1
	    end
	end
	return stars_info_ret_t
end

-- 获取boss奖励道具列表
function ActivityModel:get_boss_activity_award_items( activity_id )
	local ret_item_t = {}
	require "config/WorldBossConfig"
	local activity_info = WorldBossConfig:get_activity_info_by_id( activity_id )
	if activity_info then
        for key, item in pairs(activity_info.awards) do
            if ActivityModel:check_item_with_job( item.job ) then
                table.insert( ret_item_t, item )
            end
        end
	end
	return ret_item_t
end

-- 获取boss名称
function ActivityModel:get_boss_name_by_id( entityid )
	require "config/MonsterConfig"
	local monster = MonsterConfig:get_monster_by_id( entityid )
	if monster then
	    return monster.name
	else
		return ""
	end
end

-- 获取场景
function ActivityModel:get_scene_name_by_id( scene_id )
	require "config/SceneConfig"
	local scene_info = SceneConfig:get_scene_by_id( scene_id )
	if scene_info then
        return scene_info.scencename
	end
	return ""
end

-- 获取活跃目标列表  根据id排序后的
function ActivityModel:get_activity_award_list(  )
	require "config/ActivityAwardConfig"
	local target_list = Utils:table_clone( ActivityAwardConfig:get_activity_target_range_list() )

 --    -- 暂时去掉  欢乐斗
	-- for i = #target_list, 1, -1 do 
 --        if target_list[i].id == 7 then
 --            table.remove( target_list, i )
 --        end
	-- end

	local function campare_func( element_1, element_2 )
		if element_1.id < element_2.id then
            return true
		end
		return false
	end
	table.sort(target_list, campare_func)
	return target_list
end

-- 获取活跃奖励， 每个元素都是  奖励道具id 和 相应的积分
function ActivityModel:get_award_item_point_list (  )
	local item_point_list = {}
	local item_list = ActivityAwardConfig:get_award_item_list(  )
	local point_list = ActivityAwardConfig:get_award_point_list(  )
	local count_list = ActivityAwardConfig:get_award_point_count_list(  )
	local point = nil
	local count = nil
    for i = 0, #item_list do
    	point = point_list[i] or 0
        count = count_list[i] or 0
        item_point_list[i] = { item_list[i], point, count}
    end
    return item_point_list
end

-- 根据道具id，获取序列号（发送获取协议的时候，需要这个序列号
function ActivityModel:get_index_by_award_item_id( item_id )
	local index_ret = 1
	local item_list = ActivityAwardConfig:get_award_item_list(  )
	for i = 1, #item_list do
        if item_list[i] == item_id then
            index_ret = i
        end
	end
	return index_ret
end

-- 获取当前累计积分
function ActivityModel:get_today_point(  )
	return _today_activity_point
end

-- 根据itemid，获取是否已经领取
function ActivityModel:get_if_get_item( item_id )
	local index = ActivityModel:get_index_by_award_item_id( item_id )
	if _if_get_activity_award_list[index] == 1 then
        return true
    else
    	return false
	end
end

-- 设置到世界boss击杀者名称
function ActivityModel:set_world_boss_killer_name( boss_id, player_name )
	_world_boss_killer_name_t[ boss_id ] = player_name
    update_activity_win("world_boss_killer")	
    -- local win = UIManager:find_visible_window("activity_dialog")
    -- if win then
    -- 	win:update_boss_killer()
    -- end
end

-- 获取世界boss击杀者名称
function ActivityModel:get_world_boss_killer_name( boss_id )
	return _world_boss_killer_name_t[ boss_id ] or ""
end

-- 获取是否传送
function ActivityModel:get_if_teleport(  )
	return _if_teleport
end

-- 设置是否传送
function ActivityModel:set_if_teleport( if_teleport )
	_if_teleport = if_teleport
end
-- ================================
-- 逻辑相关
-- ================================
-- 玩家自动到活动场景,  场景id， npc名称，  是否直接传送
function ActivityModel:go_to_activity( target_scene_id, npc_name, if_transmit )
	-- print("==========go_to_activity: ", target_scene_id, npc_name)
	if if_transmit then
	    GlobalFunc:teleport( target_scene_id,npc_name )
	else
        GlobalFunc:ask_npc( target_scene_id,npc_name  )
	end
end

-- 移动到某个场景的某个坐标  场景id， 坐标  是否直接传送
function ActivityModel:go_to_scene( target_scene_id, x, y, if_transmit )
	if if_transmit then
		GlobalFunc:teleport_to_target_scene( target_scene_id, x, y ) 
	else
	    GlobalFunc:move_to_target_scene( target_scene_id, x*32, y*32 ) 
	end
end

-- 打开仙尊充值界面
function ActivityModel:open_vipSys_win(  )
	UIManager:show_window("vipSys_win")
end

-- 每次登录，都弹出活动 每日福利 页
function ActivityModel:enter_game_open_activity_win(  )
	-- 玩家必须二级以上   vip已经初始化完毕  才弹出
	local player = EntityManager:get_player_avatar()
	local vip_info = VIPModel:get_vip_info( )
	if player and player.level >= 2 and vip_info then
        -- 每次上线，打开活动的每日福利界面
        WelfareModel:query_if_had_get_vip_award(  )
        --xiehande 暂时关闭美女助手
  --       local win = UIManager:find_window( "secretary_Win" )  
  --       if win == nil then 
		--     local activity_win = UIManager:show_window("secretary_Win")
		--     activity_win:change_page( 5 )
		-- end
	end
end

-- 打开副本委托
function ActivityModel:open_fuben_entrust( fuben_id )
	EntrustModel:open_entrust_page( fuben_id )
end

-- 活跃奖励， 计算当前可获取的物品个数
function ActivityModel:statistic_activity_award_can_get(  )
	local total = 0
	local item_list = ActivityModel:get_award_item_point_list (  )
	local today_point = ActivityModel:get_today_point(  )
	for key, award_info in pairs(item_list) do 
        local need_point = award_info[2]
        local item_id = award_info[1]
        -- print("item_id::::", need_point, today_point )
        if item_id and today_point >= need_point and not ActivityModel:get_if_get_item( item_id ) then
            total = total + 1
        end
	end
	-- print(total)
	return total
end

-- 自动领取活跃奖励   领取需要活跃度最小的道具
function ActivityModel:auto_get_activity_award(  )
	local get_item_id = nil
	local get_item_point = 999999
	local item_list = ActivityModel:get_award_item_point_list (  )
	local today_point = ActivityModel:get_today_point(  )

	for i = 1, #item_list do 
        local need_point = item_list[i][2]
        local item_id = item_list[i][1]
        if item_id and today_point >= need_point and not ActivityModel:get_if_get_item( item_id ) then
            if need_point < get_item_point then 
                get_item_id = item_id
                get_item_point = need_point
            end
        end
	end

	if get_item_id then
        ActivityModel:apply_get_activity_award( get_item_id )
	end
end

-- 统计总的副本挑战次数和已完成次数
function ActivityModel:statistic_fuben_total_end_curr_times(  )
    local total_enter_times = 0      -- 已经进入次数
    local total_times = 0            -- 可以进入的次数 
	local list_date = ActivityModel:get_activity_info_by_class( "fuben")
	local player = EntityManager:get_player_avatar()
	for key, fuben_info in pairs( list_date ) do 
		if player.level >= fuben_info.level then
	        local enter_times, max_tiems = ActivityModel:get_parent_fuben_count(key) 
	        total_enter_times = total_enter_times + enter_times
	        total_times = total_times + max_tiems
	    end
	end
	return total_enter_times, total_times
end

-- 统计活动副本的总剩余次数 ok tjxs
function ActivityModel:get_activity_fuben_total_remain_times()
    local total_remain_times = 0      -- 剩余次数
	local list_date = ActivityModel:get_activity_info_by_class( "fuben" )
	local player = EntityManager:get_player_avatar()
	for key, fuben_info in pairs( list_date ) do 
		if player.level >= fuben_info.level then
			-- local remain_times = FuBenModel:get_fuben_remain_count_by_listId(key-1)
			local remain_times = ActivityModel:get_enter_fuben_count( fuben_info.FBID ) 
	        -- print("ActivityModel:get_activity_fuben_total_remain_times(list_id,remain_times)",key-1,remain_times)
	        total_remain_times = total_remain_times + remain_times
	    end
	end
	return total_remain_times
end


-- 判断是否还有副本没有达到最大次数
function ActivityModel:check_fuben_not_arrive_max_times(  )
	local total_enter_times, total_times = ActivityModel:statistic_fuben_total_end_curr_times(  )
	-- print("判断是否还有副本没有达到最大次数-------------", total_enter_times, total_times )
	if total_enter_times < total_times then
        return true
	end
	return false
end

-- ================================
-- 与服务器通讯
-- ================================
-- 请求进入副本次数
function ActivityModel:request_enter_fuben_times(  )
	OthersCC:req_get_enter_fuben_count()
	-- print("!@##################################################################################ActivityModel:request_enter_fuben_times")
	-- MiscCC:req_get_enter_fuben_count()
end

-- 申请增加进入副本的次数
--添加字段判断 is_fc_flag  是否是分层副本 如果是分层副本 ，增加次数需要走另外的协议 139,133
function ActivityModel:apply_add_enter_fuben_count( fuben_id,is_fc_flag  )
    -- 如果不是仙尊3以上玩家，弹出提示
    local need_money = 100
    local play = EntityManager:get_player_avatar()
    --local qqvip_info = QQVIPName:get_user_qq_vip_info(play.QQVIP)
    --local qqvip_info = QQVipInterface:get_qq_vip_platform_info(play.QQVIP)
    local is_qqvip = QQVipInterface:fuben_count(play.QQVIP)
    -- if qqvip_info.is_vip == 1 or qqvip_info.is_super_vip == 1 then
    -- 	--need_money = need_money * 0.8
    -- 	is_qqvip = true
    -- end
    ----------------check qqvip first

    ----------------check game vip 
    local vip_info = VIPModel:get_vip_info();
    if vip_info and vip_info.level < 3 and is_qqvip == false then 
        local function confirm_func(  )
            ActivityModel:open_vipSys_win(  )
        end
        local confirm_word = Lang.wanfadating[28] -- [28]="仙尊3玩家副本挑战可增加1次"
        ConfirmWin2:show( 3, 3, confirm_word, confirm_func )
        return
    end
    
	-- 如果元宝不够，就弹出充值界面
	local player = EntityManager:get_player_avatar()
	if player.yuanbao < need_money then 
        local function confirm2_func()
            -- print("打开充值界面")
			GlobalFunc:chong_zhi_enter_fun()
            --UIManager:show_window( "chong_zhi_win" )
    	end
    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
        return 
	end

    local function confirm_fun(  )
    	if is_fc_flag then
    		--是分层副本
    		 MiscCC:req_add_fuben_count_2(fuben_id,3) --只能使用元宝购买
    	else
    		--不是分层副本
    		 OthersCC:request_add_enter_fuben_count( fuben_id )
    	end
       
    end
    local notice_words = string.format( Lang.wanfadating[29], need_money ) -- [29]="是否消费%d元宝增加1次副本挑战次数？"
    ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 250, 130)
end

-- 申请世界boss数据
function ActivityModel:apply_world_boss_date(  )
	WorldBossModel:apply_world_boss_date()
end

-- 请求下发活跃活动信息
function ActivityModel:apply_activity_award_info(  )
    OthersCC:request_activity_award_info(  )
end

-- 请求领取活跃奖励
function ActivityModel:apply_get_activity_award( item_id )
    -- 判断背包是否已经满
    if ItemModel:check_bag_if_full() and item_id > 100 then
	    GlobalFunc:create_screen_notic( Lang.wanfadating[30] ) -- [11]="背包已满,不能领取奖励"
	    return 
    end

	local index = ActivityModel:get_index_by_award_item_id( item_id )
	OthersCC:get_activity_award( index )
end

-- 领取活跃奖励的结果处理
function ActivityModel:do_get_award_result( index, result )
	if result == 0 then
        _if_get_activity_award_list[index] = 1    -- 每个用0表示没有领取过，用1表示领取过
        BenefitModel:update_win( "get_award" )
        -- ActivityWin:update_page_tips()
    elseif result == -1 then
        -- require "UI/common/NormalDialog"
        -- local explain_content = "已经领取过"
        -- NormalDialog:show(explain_content, nil, 2)
	    GlobalFunc:create_screen_notic( Lang.wanfadating[31] ) -- [12]="已经领取"
    elseif result == -2 then
        -- require "UI/common/NormalDialog"
        -- local explain_content = "还不能领取"
        -- NormalDialog:show(explain_content, nil, 2)
	    -- GlobalFunc:create_screen_notic( "活跃度不足,不能领取奖励" )
	end
end

-- 获取某个世界boss击杀者  boss_id  worldboss配置表中的bossid
function ActivityModel:request_world_boss_killer( boss_id )
	OthersCC:request_world_boss_killer( boss_id )
end

-- 活动时间的变化，服务器通知活动开启
function ActivityModel:do_activity_notification( activitys )
	-- xprint("==-==========ActivityModel:do_activity_notification( activitys )==================")
	for i,v in ipairs(activitys) do
		if v.id == 11 and v.status == 1 then
			WorldBossWin:show(5, v.time)
			WorldBossWin:show(6, v.time)
		end
		-- status: 1=活动准备中，2=活动进行中，3=活动结束；
		local win = UIManager:find_window("right_top_panel");
		-- print("ActivityModel:id",v.id)
		if v.status == 3 then
			if v.id == ActivityConfig.ACTIVITY_PANTAOSHENGYAN then
				-- 如果蟠桃盛宴结束
				FubenTongjiModel:close_tongji_panel();
			elseif v.id == ActivityConfig.ACTIVITY_ZHENYINGZHAN then
				-- 如果阵营战结束(服务器主动下发)
				-- CampBattleModel:req_camp_battle_result_rank(  )
			elseif v.id == ActivityConfig.ACTIVITY_QUESTION then
				-- 如果答题活动结束
				QuestionActivityModel:activity_over(  );
			elseif v.id ==  ActivityConfig.ACTIVITY_GUILD_FUBEN  then
				GuildModel:set_fuben_btn_status(v.status)
				--如果是仙宗副本
			end
			win:remove_activity_btn( v );
		else
			if v.status == 2 then
				if v.id == ActivityConfig.ACTIVITY_QUESTION then
					-- 如果答题活动开始
					if UIManager:find_visible_window("question_win") then
						QuestionActivityModel:req_all_question_info();
					end
					QuestionActivityModel:set_start_status( true );
					print("检验",QuestionActivityModel:get_start_status())
				elseif v.id ==  ActivityConfig.ACTIVITY_GUILD_FUBEN  then
					GuildModel:set_fuben_lave_times(v.time)

					GuildModel:set_fuben_btn_status(v.status)--btn
					GuildCC:req_fudizhizhan_data()  -- data  
													-- xiala 下拉控件 diff 在10-39更新
					if SceneManager:get_cur_fuben() == 0 then
						GuildModel:pop_notice()
					end
				end
			end

			if win then 
				win:show_activity_btn( v );
			end
		end
		
	end

end

function ActivityModel:get_activity_status(  )
	-- return _activity_notification_dict;
end

function ActivityModel:change_chongzhilibao_state(level, state, time, money)
	show_chongzhilibao_money = money
	show_chongzhilibao_time = os.time() + tonumber(time)
	show_chongzhilibao_state = state
	show_chongzhilibao_level = level
	show_chongzhilibao = ActivityModel:check_congzhilibao_open()
	local activity_win = UIManager:find_window("activity_Win")
	-- print("ActivityModel:change_chongzhilibao_state-----------------------show_chongzhibao",show_chongzhilibao,activity_win)
	if activity_win ~= nil then
		if activity_win.chongzhilibao_text == nil and activity_win.chongzhilibao_button == nil then
			activity_win:create_chongzhilibao_button()
		end
		if show_chongzhilibao then
			-- print("set visible true")
			activity_win.chongzhilibao_button:setIsVisible(true)
			activity_win.chongzhilibao_text:setIsVisible(true)
		else
			-- print("set visible false")
			activity_win.chongzhilibao_button:setIsVisible(false)
			activity_win.chongzhilibao_text:setIsVisible(false)
		end
		if activity_win.all_page_t[8] ~= nil and show_chongzhilibao then
			activity_win.all_page_t[8]:update("all")
		end
	end
	 --WelfareModel:set_recharge_award_date_ex( level, state, time )
end

function ActivityModel:get_chongzhilibao_state()
	return show_chongzhilibao
end

function ActivityModel:get_chongzhilibao_money()
	return show_chongzhilibao_money
end

function ActivityModel:get_chongzhilibao_info()
	return { level = show_chongzhilibao_level, state = show_chongzhilibao_state,
			time = show_chongzhilibao_time, money = show_chongzhilibao_money }
end

function ActivityModel:get_chongzhilibao_cur_level_max_money( level )
	return GlobalConfig:get_xiaofeilibao_money(level)--{ 888, 2188, 4888, 9888, 19888, 39888, 79888 }
	--return info[level]
end

function ActivityModel:get_chongzhilibao_index_price( index )
	return GlobalConfig:get_xiaofeilibao_value(index)
end
function ActivityModel:get_chongzhilibao_level_name( level )

end

function ActivityModel:get_chongzhilibao_index_state( index )
	--print("ActivityModel:get_chongzhilibao_index_state index,show_chongzhilibao_state",index,show_chongzhilibao_state)
	return Utils:get_bit_by_position( show_chongzhilibao_state, index )
end

function ActivityModel:check_congzhilibao_open( )
	local state_info = {}
	local item_info = GlobalConfig:get_xiaofeilibao_item_id()
	local cur_state = false
	for i = 1, #item_info do
		state_info[i] = Utils:get_bit_by_position(show_chongzhilibao_state, i)
		-- print("state_info[i]",state_info[i], show_chongzhilibao_level)
		if show_chongzhilibao_level >= i and state_info[i] <= 0 then
			cur_state = true
			break
		end
	end
	-- print("time",show_chongzhilibao_time - os.time())
	if show_chongzhilibao_time - os.time() > 0 or cur_state == true then
		return true
	else
		return false
	end
end


-- 询问是否有消费礼包活动，有则在活动面板增加一个消费礼包活动按钮
-- by fjh
function ActivityModel:check_if_show_spending_gift(  )
	
	local win = UIManager:get_win_obj("activity_menus_panel");
	if ActivityModel:check_congzhilibao_open() then
		if win then
			win:insert_btn(5);
		end
	else
		if win then
			win:remove_btn(5);
		end		
	end
end

-- 取得某个活动的数据  activity_type:活动类型(副本fuben，活动daily) activity_id 活动id
function ActivityModel:get_activity_info_by_id( activity_type,activity_id )
	local fuben_info = ActivityConfig:get_activity_info_by_class( activity_type )
	if activity_type =="fuben" then    --副本
	 	for k, v in pairs(fuben_info) do
	        if v.FBID == activity_id then
	            return v
	        end
	    end
	elseif activity_type == "daily" then  --活动
         	for k, v in pairs(fuben_info) do
	        if v.id == activity_id then
	            return v
	        end
	    end
	end
	return nil;
end

-- 开服时间是否已经超过delay期 
local function outof_delayDay( st, ot, de )
    -- MUtils:now_to_day(year,month,day)
    -- 计算与2013年1月1日的日期差
    local today_del   = MUtils:now_to_day(st.year,st.month,st.day)
    local openday_del = MUtils:now_to_day(ot.year,ot.month,ot.day)
    local delt        = today_del - openday_del --间隔天数
    local delt2       = nil                     --跨越的周末数
    if de[1] == 0 then          --延迟固定天数
        if delt >= de[2] then   --跨越的天数
            return true
        else
            return false
        end
    elseif de[1] == 1 then      --开服经过周数
        local openday_to_weekend = 7 - ot.weekday                      --开服日期距离最近的周日
        local open_weekend = openday_del +  openday_to_weekend         --开服周的周日距离原始时间（2013.1.1）
        delt2 = math.ceil((today_del - open_weekend)/7)
        if delt2 >= de[2] then
            return true
        else
            return false
        end
    end
    return false
end
-- 判断正在进行的活动个数
local function check_activity_intime(server_time ,server_open_time)
	local count = 0
	local icons_t = ActivityModel:get_activity_info_by_class( "daily" )
	local player_data = EntityManager:get_player_avatar()
    for key,value in ipairs(icons_t) do
        if player_data.level >= icons_t[key].level then --不小于开启等级才会显示 开放状态标签
            if Utils:match_weekday(server_time.weekday,icons_t[key].time) then --当前星期在配置中
                local s1 = Utils:Split(icons_t[key].time,"#")
                local s2 = Utils:Split(s1[#s1],"-")
                local start_time = Utils:Split(s2[1],":")
                local end_time   = Utils:Split(s2[2],":")

                local today_sec = server_time.hour*3600 + server_time.min*60 + server_time.sec --当天总秒数，用来比较开放时间
                local start_sec = start_time[1]*3600 + start_time[2]*60
                local end_sec   =   end_time[1]*3600 +   end_time[2]*60

                if (icons_t[key].delay == nil)or(icons_t[key].delay ~= nil and outof_delayDay(server_time, server_open_time,icons_t[key].delay)) then                        --判断是否有延迟日期的开启
                    if today_sec < start_sec then     --未开始
                            
                    elseif today_sec >= end_sec then  --time已结束,判断time2的时间段
                        
                    else--time进行中
                        count = count +1
                    end
                else -- 有delay且在delay期间,显示未开始
                   
                end
            else     --当前星期不在配置中，直接显示未开始
                
            end
        end
    end
    return count
end
-- 收到服务器时间
-- time             当前服务器时间
-- server_open_time 开服时间
function ActivityModel:get_server_time( time ,server_open_time)
	local win = UIManager:find_visible_window("activity_Win")
	local page = nil
	if win ~= nil then
		 page = win.all_page_t[2] --第二分页是日常
	end
	-- print("接受到服务器时间..."..time)
	-- print("接受到开服时间..."..server_open_time)
	local date_info = Utils:format_time_to_info(time) --计算年月日
	local week_day = MUtils:find_day_weekend(date_info.year,date_info.month,date_info.day) -- 计算今天的weekday
	local time_info = Utils:format_time(time) -- 计算当前时间

	local today_del = MUtils:now_to_day(date_info.year,date_info.month,date_info.day)
    local total_week = math.ceil((today_del+2)/7)

	local server_time_t = {
		totalSec = time,
		totalDay = today_del,
        totalWeek = total_week,
		year = date_info.year,
		month = date_info.month,
		day = date_info.day,
		weekday = week_day,
		hour = time_info.hour,
		min = time_info.min,
		sec = time_info.sec,
	}

	local date_info2 = Utils:format_time_to_info(server_open_time) --计算年月日
	local week_day2 = MUtils:find_day_weekend(date_info2.year,date_info2.month,date_info2.day) -- 计算今天的weekday
	local time_info2 = Utils:format_time(server_open_time) -- 计算当前时间

	local today_del2 = MUtils:now_to_day(date_info2.year,date_info2.month,date_info2.day)
    local total_week2 = math.ceil(today_del2+2)/7

	local server_open_time_t = {
		totalSec = server_open_time,
		totalDay = today_del2,
        totalWeek = total_week2,
		year = date_info2.year,
		month = date_info2.month,
		day = date_info2.day,
		weekday = week_day2,
		hour = time_info2.hour,
		min = time_info2.min,
		sec = time_info2.sec,
	}
	-- print("开服日期————  ".."总秒："..server_open_time.."    "
	-- 	..date_info2.year.."年"..date_info2.month.."月"..date_info2.day.."日，星期"..week_day2.."，"
	-- 	..time_info2.hour.."时"..time_info2.min.."分"..time_info2.sec.."秒")
 	activity_intime_count = check_activity_intime(server_time_t ,server_open_time_t)
 	if win then 
	 	win:update_page_tips()
	end
	if page then
		page:update_open_state(server_time_t,server_open_time_t)
	end
end

function ActivityModel:get_activity_tips_t()
	return activity_tips_t
end
--index 有效值为1-5
-- value有效值为 0和1
function ActivityModel:set_activity_tips_t(index,value)
	activity_tips_t[index] = value
end

--查询所有剩余副本次数
function ActivityModel:get_all_fuben_remain_times()
	local play = EntityManager:get_player_avatar()
	-- local qqvip_info = UserInfoModel:get_user_qq_vip_info(play.QQVIP) --貌似没有这方法了

	local data = ActivityModel:get_activity_info_by_class( "fuben" )
	local times_remain_count = 0
	for key,value in ipairs(data) do
		if play.level >= data[key].level then
			local enter_times = 0        -- 进入次数
	    	local max_times   = 0        -- 最大次数
	    	enter_times, max_times = ActivityModel:get_parent_fuben_count(key) 
			-- if qqvip_info.is_blue_vip == 1 or qqvip_info.is_super_blue_vip == 1 then
			--     max_times = max_times + 1
			-- end
			times_remain_count = max_times - enter_times + times_remain_count
		end
	end
	fuben_times_remain = times_remain_count
	return times_remain_count
end
function ActivityModel:get_fuben_times_remain(  )
	return fuben_times_remain
end
function ActivityModel:set_fuben_times_remain( num )
	fuben_times_remain = num
end
--查询处于“新”状态的活动总数
-- 先处理配置数据 删除重复id的活动
local function deal_cfg_data()
    local pdate = ActivityModel:get_activity_info_by_class( "daily" )
    local pdate2 = {} --最终要返回的对象
    local used_id = {} --已经出现过的id集合
    local added_count = 0 --已经添加的数据个数
    for key, value in ipairs(pdate) do
        if used_id[ pdate[key].id ] == nil then
            used_id[ pdate[key].id ] = true
            added_count = added_count + 1
            pdate2[added_count] = pdate[key]
        end
    end
    return pdate2
end

-- 返回正在进行的活动的个数
function ActivityModel:get_all_activities_intime()
	return activity_intime_count
end

--查询所有野外boss的存在数量（不包括世界boss）
function ActivityModel:get_field_boss_exist_count()
	local data = WorldBossConfig:get_world_boss_info(  )
	local exist_count = 0
	for key,value in ipairs(data) do
		if data[key].type == 1 then --不算世界boss
			local if_exist, remainTime = ActivityModel:get_world_boss_time( data[key].id )
			-- print("model打印野外boss存在....")
			-- print("data id  " ..data[key].id)
			-- print("存在?  "..tostring(if_exist))
			if if_exist == true then
				exist_count = exist_count + 1
			end
		end
	end
	return exist_count
end

--判断是否存在
function ActivityModel:check_had_activity_award( )
	if ActivityModel:statistic_activity_award_can_get(  ) > 0 then
		return  true
	end
	return false
end

--神龙密塔 请求奖励数据

function ActivityModel:req_tower_info( activityId )
	OnlineAwardCC:req_tower_info( activityId )
end

function ActivityModel:update_tower_win(awards_state, items_state)
	local win = UIManager:find_visible_window("dragon_tower")
	if win then
		win:update(awards_state, items_state)
	end
end

--神龙密塔 领取奖励
function ActivityModel:req_tower_award( activityId, index )
	OnlineAwardCC:req_tower_award(activityId, index)
end
