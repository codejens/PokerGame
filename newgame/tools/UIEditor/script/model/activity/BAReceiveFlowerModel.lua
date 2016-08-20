--region BAReceiveFlowerModel.lua
--Author : guozhinan
--Date   : 2015/2/7
--收花活动model，BA是big activity之意，这是大活动下的收花活动小分页用的model，
--以后如果做独立的收花活动，可以考虑另开一个model

BAReceiveFlowerModel = {}
local _receive_flower_info = {}

function BAReceiveFlowerModel:get_receive_flower_info()
    return _receive_flower_info;
end

function BAReceiveFlowerModel:set_receive_flower_info(t_myRanking,t_myNum,t_allRankingNum,t_rankingGroup,t_activityId)
    _receive_flower_info.myRank = t_myRanking
    _receive_flower_info.my_num = t_myNum
    _receive_flower_info.all_rank_num = t_allRankingNum
    _receive_flower_info.RankData = t_rankingGroup
    _receive_flower_info.activity_id = t_activityId
    -- _receive_flower_info.award_num = t_award_num
    -- _receive_flower_info.award_state_table = {}
    -- _receive_flower_info.award_state_table = t_award_state_table

    -- 情人节活动数据刷新
    ValentineDayModel:refreshPageInfo(CommonActivityConfig.TypeReceiveFlowerQueue)
    -- 白色情人节活动数据刷新
    ValentineWhiteDayModel:refreshPageInfo(CommonActivityConfig.TypeReceiveFlowerQueue)
end

-- 获取某行是否奖励已经领取了。0未领取、1可领取、2已领取、nil无数据
-- function BAReceiveFlowerModel:get_receive_flower_award_state(index)
--     if _receive_flower_info.award_num == nil or _receive_flower_info.award_state_table == nil 
--         or _receive_flower_info.award_state_table[index] == nil then
--         print("查询数据位置是空值",index)
--         return nil;
--     end

--     return _receive_flower_info.award_state_table[index]
-- end

--
function BAReceiveFlowerModel:fini()
    _receive_flower_info = {}
end