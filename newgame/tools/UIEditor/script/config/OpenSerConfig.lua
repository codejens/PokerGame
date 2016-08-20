-- OpenSerConfig.lua
-- created by fjh on 2013-5-30
-- 开服活动配置

OpenSerConfig = {}


-- 开服活动
local activity_title_up = Lang.openser.activity_title_up
-- 封测活动
local ct_activity_title_up = Lang.openser.ct_activity_title_up -- [117]="修仙初成" -- [127]="封测礼包" -- [128]="等级礼包" -- [129]="登录基金" -- [130]="时段礼包" -- [131]="活跃礼包" -- [132]="在线有礼"

--开服活动
local activity_title_down = Lang.openser.activity_title_down 
--封测活动
local ct_activity_title_down = Lang.openser.ct_activity_title_down  -- [134]="小有成就" -- [144]="感恩回馈" -- [145]="升级送豪礼" -- [146]="登录送豪礼" -- [147]="喜迎封测日" -- [148]="欢庆封测日" -- [149]="在线送豪礼"

-- 开服活动时间
 local activity_time = Lang.openser.activity_time  -- [150]="开服当天--第七天的22:00" -- [150]="开服当天--第七天的22:00" -- [150]="开服当天--第七天的22:00"
-- 封测活动时间
local ct_activity_time = Lang.openser.ct_activity_time -- [151]="9月16日-9月20日"

local activity_desc = Lang.openser.activity_desc  -- [162]="在活动期间，渡劫提升至指定境界，就能领取大奖礼包"
local ct_activity_desc = Lang.openser.ct_activity_desc  -- [169]="在活动期间，在线时长达到指定的数值，即可领取元宝奖励"

local recharge_award = Lang.openser.recharge_award  -- [175]="充值累计达到三万元宝"

local growup_award = Lang.openser.growup_award  -- [185]="斗法台排名500"

local fight_rank = Lang.openser.fight_rank -- [195]="战力排行榜第10名"

local level_rank = Lang.openser.level_rank  -- [205]="等级排行榜第10名"

local linggen_rank = Lang.openser.linggen_rank  -- [215]="灵根排行榜第10名"

local achieve_rank = Lang.openser.achieve_rank  -- [225]="成就排行榜第10名"

local mount_rank = Lang.openser.mount_rank  -- [235]="坐骑排行榜第10名"

local fabao_rank = Lang.openser.fabao_rank  -- [245]="法宝排行榜第10名"

local guild_award = Lang.openser.guild_award  -- [248]="所在仙宗达到4级或以上"

local suit_award = Lang.openser.suit_award  -- [251]="收集到40级紫色套装8件或以上"

local dujie_award = Lang.openser.dujie_award  -- [254]="渡劫提升境界到达元婴一阶或以上"

local plantform_award = Lang.openser.plantform_award 

local level_award = Lang.openser.level_award 

local daily_login_award = Lang.openser.daily_login_award 

local beauty_award = Lang.openser.beauty_award -- 美人榜战斗力

-- 每日特殊时段在线奖励
local online_1_award = Lang.openser.online_1_award  -- [267]="每日20：00-20：30在线"
-- 累计在线
local online_2_award = Lang.openser.online_2_award  -- [273]="累计在线6小时"
-- 活跃度奖励
local active_award = Lang.openser.active_award  -- [277]="活跃度达到100"

-- local all_activity_title = {recharge_award,growup_award,fight_rank,level_rank,linggen_rank,achieve_rank,mount_rank,fabao_rank,guild_award,suit_award,dujie_award};

local all_activity_title = { recharge_award, growup_award, fight_rank, level_rank, linggen_rank, 
	achieve_rank, mount_rank, beauty_award, guild_award, suit_award, dujie_award }

local ct_all_activity_title = {growup_award, plantform_award, level_award, daily_login_award, online_1_award, active_award, online_2_award};

-- 获取活动图片标题
function OpenSerConfig:get_activity_img_title( index )
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		return UILH_OPENSER.title_path..index..".png";
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		return UIResourcePath.FileLocate.openSer .. "ct_title"..index..".png";
	end
end

-- 获取子活动图标
function OpenSerConfig:get_activity_icon( index )
	
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		-- 开服活动
		return UILH_OPENSER.icon_path .. index .. ".png";

	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		-- 封测活动
		local icon_dict = {"icon_2.png","icon_11.png","icon_4.png","icon_5.png","icon_3.png","icon_6.png","icon_10.png",};
		return UIResourcePath.FileLocate.openSer .. icon_dict[index];
	end

end

-- 获取活动的主副文字标题
function OpenSerConfig:get_activity_title( index )
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		-- 开服活动
		return activity_title_up[index], activity_title_down[index];

	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		-- 封测活动
		return ct_activity_title_up[index], ct_activity_title_down[index];
	end
end

-- 获取活动的个数
function OpenSerConfig:get_activity_count(  )
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		-- 开服活动
		return #activity_title_up;
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		-- 封测活动
		return #ct_activity_title_up;
	end
	
end

-- 获取活动的描述
function OpenSerConfig:get_activity_desc( index )
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		return activity_desc[index];
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		return ct_activity_desc[index];
	end
end

-- 获取活动的周期时间
function OpenSerConfig:get_activity_time( index )
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
		return activity_time[index];
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		return ct_activity_time[1];
	end
end

-- 获取某个活动详细的具体cell的title
function OpenSerConfig:get_detail_cell_title( act_index, cell_index )
	
	--充值回馈
	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
	
		return all_activity_title[act_index][cell_index];
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		
		return ct_all_activity_title[act_index][cell_index];
	end
	
end

-- 获取某个活动的cell数量
function OpenSerConfig:get_activity_cell_count( act_index )

	if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then

		return #all_activity_title[act_index];
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then

		return #ct_all_activity_title[act_index];
	end

end


-- 获取充值奖励的数据
function OpenSerConfig:get_recharge_award_config( cell_index )
	
	require "../data/newseraward_config"
	local recharg_award = newseraward_config.rechargeAwardItems[cell_index];
	return recharg_award;

end


-- 获取修仙初成奖励数据
function OpenSerConfig:get_junior_award_config( cell_index )
	
	require "../data/newseraward_config"
	local junior_award = newseraward_config.JuniorEffort[cell_index].award;
	return junior_award;

end

-- 战力排行奖励 tjxs
function OpenSerConfig:get_zhanli_award_config( cell_index )
	require "../data/newseraward_config"
	local zhanli_award = newseraward_config.RankActivityAwardItemsZL[cell_index]
	return zhanli_award
end

-- 等级排行奖励 tjxs
function OpenSerConfig:get_level_award_config( cell_index )
	require "../data/newseraward_config"
	local level_award = newseraward_config.RankActivityAwardItemsDJ[cell_index]
	return level_award
end


-- 灵根排行奖励 tjxs(奇经八脉)
function OpenSerConfig:get_lg_award_config( cell_index )
	require "../data/newseraward_config"
	local lg_award = newseraward_config.RankActivityAwardItemsLG[cell_index]
	return lg_award
end


-- 获得排行榜奖励的数据
function OpenSerConfig:get_rank_award_config( act_index, cell_index )
	require "../data/newseraward_config"

	local rank_award = newseraward_config.RankActivityAward[act_index];
	return rank_award[cell_index];

end

-- 获得仙宗奖励的数据
function OpenSerConfig:get_guild_award_config( cell_index )
	require "../data/newseraward_config"

	local member_award = newseraward_config.memberAwardItems[cell_index];
	local president_award = newseraward_config.presidentAwardItems[cell_index][1];

	return { president_award, member_award };
end

--获得套装奖励的数据
function OpenSerConfig:get_siut_award_config( cell_index )
	local suit_award = newseraward_config.suitAwardItems[cell_index];
	return suit_award;
end

-- 获得境界奖励的数据
function OpenSerConfig:get_dujie_award_config( cell_index )
	
	local dujie_award = newseraward_config.djAwardItems[cell_index];
	return dujie_award ;

end


-----------------------------封测活动

function OpenSerConfig:get_fc_activity_cofnig( index, cell_index)
	require "../data/fcactivityconf"

	local award = {};
	if index == 1 then
		-- 修仙初成
		local gold = fcactivityconf.JuniorEffort[cell_index].gold;
		award[1] = {id = 3, count = gold};

	elseif index == 2 then
		-- 平台礼包
		award = fcactivityconf.platformaward[cell_index];
	elseif index == 3 then
		-- 等级奖励
		local gold = fcactivityconf.uplevelReward[cell_index];
		award[1] = {id = 3, count = gold};
		
	elseif index == 4 then
		-- 登录奖励
		local gold = fcactivityconf.dailyReward[cell_index];
		award[1] = {id = 3, count = gold};
		
	elseif index == 5 then
		-- 时段奖励
		local gold = fcactivityconf.onlineRewardTime[cell_index].award;
		award[1] = {id = 3, count = gold};
		
	elseif index == 6 then
		-- 活跃度奖励
		local gold = fcactivityconf.activityReward[cell_index];
		award[1] = {id = 3, count = gold};
	
	elseif index == 7 then
		-- 在线时长
		local gold = fcactivityconf.keeptimeaward[cell_index];
		award[1] = {id = 3, count = gold};
		
	end

	return award;
end

-- 取得每日登录礼包
function OpenSerConfig:get_login_award(  )
	require "../data/fcactivityconf"
	return fcactivityconf.denglulibao
end
