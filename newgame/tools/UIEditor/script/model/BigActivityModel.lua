-- BigActivityModel.lua
-- created by lyl on 2013-10-26
-- 大型活动 通用

BigActivityModel = {}

local _activity_data = {}       -- 保存活动的相关数据。 使用活动id作为key. 元素为 BigActivityStruct 类型 的 table

local _activity_rank_data = {}  -- 排行榜数据,  使用活动id作为key， 元素为 BigActivityRankStruct 结构


function BigActivityModel:fini( ... ) 
    _activity_data = {}
    _activity_rank_data = {}
end

-- 设置 活动奖励数据
function BigActivityModel:set_activity_data( activity_id, activity_data )
    print("设置 活动奖励数据!!!!!!!", activity_id, activity_data, activity_data.activity_child_id, #activity_data)
    -- print("activity_data>>", activity_data)
    -- print("activity_data >>", activity_data.had_get_record )
    if _activity_data[ activity_id ] == nil then 
        _activity_data[ activity_id ] = {}
    end

    -- 如果已经有子活动的数据，先清空
    local exist_data_key = false     
    for key, child_activity_data in pairs( _activity_data[ activity_id ] ) do 
        if child_activity_data.activity_child_id == activity_data.activity_child_id then 
            exist_data_key = key
            break
        end
    end
    _activity_data[ activity_id ][ exist_data_key ] = nil
    table.insert( _activity_data[ activity_id ], activity_data )

    SmallOperationModel:update_win( activity_id,activity_data )

    --为兼容旧的通用活动，新的通用活动更新信息写在这里
    require "config/activity/CommonActivityConfig"
    if activity_id == CommonActivityConfig.OldLonelyDay then
        LonelyDayModel:flushPageInfo(activity_data)
    -- 累积登录按钮状态更新处
    --春节活动
    elseif activity_id == CommonActivityConfig.NewLonelyDay then
        LonelyDayModel:flushPageInfo(activity_data)
    -- 情人节活动
    elseif activity_id == CommonActivityConfig.ValentineDay then
        ValentineDayModel:flushPageInfo(activity_data)
    --元宵节
    elseif activity_id == CommonActivityConfig.LanternDay then
        LanternDayModel:flushPageInfo(activity_data)
    -- 妇女节
    elseif activity_id == CommonActivityConfig.WomensDay then
        WomensDayModel:flushPageInfo(activity_data)
    elseif activity_id == CommonActivityConfig.ValentineWhiteDay then
        ValentineWhiteDayModel:flushPageInfo(activity_data)
    elseif activity_id == DayChongZhiModel.ACTIVITY_ID then
        DayChongZhiModel:set_data( activity_data)
    elseif activity_id == DayChongZhiMultiModel.ACTIVITY_ID then
        DayChongZhiMultiModel:set_data( activity_data)
    elseif activity_id == CommonActivityConfig.QingmingDay then
        -- 2015清明节活动
        QingmingDayModel:flushPageInfo(activity_data)
    elseif activity_id == CommonActivityConfig.VersionCelebration then
        VersionCelebrationModel:flushPageInfo(activity_data)
    elseif activity_id == CommonActivityConfig.SummerDay then
        -- 2015清凉一夏
        SummerDayModel:flushPageInfo(activity_data)
    elseif activity_id == CommonActivityConfig.WorkDay then
        -- 劳动节
        WorkDayModel:flushPageInfo(activity_data)
    end
end

-- 获取某个活动数据
function BigActivityModel:get_activity_data( activity_id )
    -- for key, value in pairs(_activity_data) do 
    --     print("value:::", key,value, value[1] )
    -- end

	local activity_data = _activity_data[ activity_id ] 
	return activity_data
end

-- 设置排行数据 新版 添加排行类型
function BigActivityModel:set_rank_date( activity_id, paihang_id, rand_data_t )
    --_activity_rank_data[ activity_id ] = rand_data_t
    if _activity_rank_data[activity_id] == nil then
        _activity_rank_data[activity_id] = {}
    end
     _activity_rank_data[activity_id][paihang_id] = rand_data_t
    -- 通知更新
    if ServerActivityConfig.CURR_USE_ACTIVITY_IDS[activity_id]  then
        local win = UIManager:find_visible_window("big_activity_win")
        if win then
            win:update_get_award_btn_state(rand_data_t);
        end
    end
end

-- 获取某活动排行数据 新版 添加排行类型
function BigActivityModel:get_rank_data( activity_id ,paihang_id)
    local activity_rank_data = {}
    if _activity_rank_data[ activity_id ] then
	   activity_rank_data = _activity_rank_data[ activity_id ][paihang_id] or {}
    end
	return activity_rank_data
end

function BigActivityModel:create_rank_str( data )
    local str = "";
    for i=1,#data do
        if i< 4 then 
            str = str..string.format("#c66ff66第%d名:#cffffff%s#r",i,data[i].player_name);
        elseif i == 4 then
            str = str..string.format("#c66ff66第4~6名:#r#cffffff%s",data[i].player_name);
        elseif i == 5 then
            str = str.." "..data[i].player_name;
        elseif i == 6 then
            str = str.." "..data[i].player_name.."#r";
        elseif i == 7 then
            str = str..string.format("#c66ff66第7~10名:#r#cffffff%s",data[i].player_name);
        elseif i == 8 then
            str = str.." "..data[i].player_name;
        elseif i == 9 then
            str = str.." "..data[i].player_name.."#r";
        elseif i == 10 then
            str = str..data[i].player_name;
        end
    end
    return str;
end



--- ======================================
--  与服务器通讯
--- ======================================
-- 请求活动数据
function BigActivityModel:req_activity_data( activity_id, activity_child_id )
	OnlineAwardCC:req_activity_data_com( activity_id, activity_child_id )
end

-- 请求排行数据
function BigActivityModel:req_rank_data( activity_id,paihang_id )
    OnlineAwardCC:req_get_activity_rank_com( activity_id ,paihang_id)
end

--向服务器获取奖励
function BigActivityModel:req_get_award( activity_id, activity_childid, award_index,paihang_id)
    OnlineAwardCC:req_get_activity_award_com( activity_id , activity_childid, award_index, paihang_id )
end

-- 请求圣诞送礼信息
function BigActivityModel:req_sdsl_data(  )
    OnlineAwardCC:req_sdsl_data()
end

--功能：更新活动的兑换信息
--参数：1、activityId    活动ID
--      2、infoGroup     兑换信息组
--返回：无
--作者：陈亮
--时间：2014.09.16
function BigActivityModel:updateExchangeInfo(infoGroup)
    -- 春节兑换活动
    LonelyDayModel:refreshTGExchangeInfo(infoGroup)
end


--功能：更新通用的限制购买信息
--参数：1、activityId           活动ID
--      2、limitPropCount       可以限购的道具种数
--      3、limitBuyCountGroup   限制购买数量组    
--返回：无
--作者：陈亮
--时间：2014.10.31
function BigActivityModel:updateCommonLimitBuyInfo(activityId,limitPropCount,limitBuyCountGroup)
    --宝石合成活动
    if activityId == SpecialActivityConfig.GemFestival then
        GemFestivalModel:updateLimitInfo(limitPropCount,limitBuyCountGroup)
    --每日限购活动
    -- elseif activityId == SpecialActivityConfig.OldDailyQuatoBuy or 
    -- activityId == SpecialActivityConfig.NewDailyQuatoBuy or  activityId == SpecialActivityConfig.WomanQuatoBuy then
    else
        DailyQuatoBuyModel:updateQuatoInfo(limitBuyCountGroup)

    end
end

--功能：更新活动标签
--参数：1、activityId           活动ID
--      2、t_tag                活动标签  
--返回：无
--作者：肖进超
--时间：2015.1.7
function BigActivityModel:updateActivityTag(activityId,tag,day)
    --每日限购活动
    -- if activityId == SpecialActivityConfig.OldDailyQuatoBuy or 
    -- activityId == SpecialActivityConfig.NewDailyQuatoBuy then
        DailyQuatoBuyModel:updateActivityTag(tag,day)
    -- end
end

