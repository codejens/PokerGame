--region SendFlowerModel.lua    --送花排行榜活动逻辑
--Author : 肖进超
--Date   : 2014/10/27

require "config/activity/SendFlowerConfig"

SendFlowerModel = {}
local _activityId = nil   --活动id，用于区别新老服
local _send_flower_info = {}

--显示送花排行榜活动窗口
function SendFlowerModel:initWinInfo()
    --
    local t_win = UIManager:find_visible_window("sendFlowerWin")
    local rewardGrup = SendFlowerConfig:getRewardGrup()
    local addUpGroup = SendFlowerConfig:getAddUpGroup()
    t_win:resetRewardScroll(rewardGrup, addUpGroup)

    --
    local desc = SendFlowerConfig:getActivityDesc()
    local remainTime = SmallOperationModel:getActivityRemainTime(_activityId)
    t_win:createActivityInfo(remainTime, desc)

    --
    OnlineAwardCC:req_get_sendFlowerRanking()
end

function SendFlowerModel:get_send_flower_info()
    return _send_flower_info;
end

--更新送花排行榜
function SendFlowerModel:updateRanking(rankingGroup)
    _send_flower_info.RankData = {}
    _send_flower_info.RankData = rankingGroup;
    local t_win = UIManager:find_visible_window("sendFlowerWin")
    if t_win then
        t_win:resetRankingScroll(rankingGroup)
    end
end

--更新我的送花排名,我的送花数量
function SendFlowerModel:updateMySendFlowerInfo(myRanking, mySendNum)
    _send_flower_info.myRank = myRanking;
    _send_flower_info.myNum = mySendNum;
    local t_win = UIManager:find_visible_window("sendFlowerWin")
    if t_win then
        t_win:setMySendFlowerInfo(myRanking, mySendNum)
    end
end

--更新累计送花奖励领取状态
function SendFlowerModel:updateRewardState(rewardStateGroup)
    _send_flower_info.rewardStateData = {}
    _send_flower_info.rewardStateData = rewardStateGroup;
    local t_win = UIManager:find_visible_window("sendFlowerWin")
    if t_win then
        t_win:setaddUpGetImgStatus(rewardStateGroup)
    end
end

--打开帮助窗口
function SendFlowerModel:openHelpDescWin()
   helpContent =  SendFlowerConfig:getHelpContent()
   HelpPanel:show( 3, UILH_NORMAL.title_tips, helpContent ) 
end

--刷新活动ID，用于区别新老服
function SendFlowerModel:refreshActivityId(activityId)
    --如果刷新的活动ID和当前活动ID一样，不需执行动作
    if _activityId == activityId then
        return
    end
    
    --保存活动ID
    _activityId = activityId
    --刷新活动配置参数
    SendFlowerConfig:refreshActivityParam(_activityId)
end

--
function SendFlowerModel:fini()
    _activityId = nil
    _send_flower_info = {}
    UIManager:destroy_window("sendFlowerWin")
end