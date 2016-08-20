--region DailyQuatoBuyModel.lua    --每日限购活动逻辑
--Author : 肖进超
--Date   : 2015/1/6

require "config/activity/DailyQuotaBuyConfig"

DailyQuatoBuyModel = {}
local _activityId = nil   --活动id，用于区别新老服
local activity_type  = nil  --可能是春节或者情人节活动

function  DailyQuatoBuyModel:setActivityType( type)
    activity_type = type
end


function  DailyQuatoBuyModel:getActivityType( type)
    return  activity_type
end

function DailyQuatoBuyModel:showDailyQuotaBuyWin()
    local t_win = UIManager:find_visible_window("dailyQuotaBuyWin")
    --设置活动倒计时
    -- local t_remainTime = SmallOperationModel:getActivityRemainTime(_activityId) 
    --现在每日限购属于春节活动或者情人节活动 属于小型活动中的子活动 与之前为单个活动不一样
     local t_remainTime = SmallOperationModel:getActivityRemainTime(DailyQuatoBuyModel:getActivityType())
     print('t_remainTime:', t_remainTime)
    -- print("每日限购的活动剩余时间",t_remainTime)
    if t_remainTime == 0 then
        t_win:remainTimeOut()
        return
    end
    t_win:setRemainTime(t_remainTime)

    --设置活动说明
    local desc = DailyQuotaBuyConfig:getDesc()
    t_win:setActivityDescText(desc)

    --请求活动标签
    OnlineAwardCC:reqActivityTag(_activityId) 
    --请求限购剩余物品数量
    OnlineAwardCC:reqLimitBuyCount(_activityId)
end

--更具活动标签读取相应配置，填入相应的限购无凭
function DailyQuatoBuyModel:updateActivityTag(tag,day)
    local t_win = UIManager:find_visible_window("dailyQuotaBuyWin")
    if t_win == nil then
        return
    end

    --设置限购物品展示
    local items = DailyQuotaBuyConfig:getQuotaItems2(tag,day)
    if items then
        t_win:resetQuotaItemsScroll(items)
    end
end

--更新限购数量
function DailyQuatoBuyModel:updateQuatoInfo(limitBuyCountGroup)
    local t_win = UIManager:find_visible_window("dailyQuotaBuyWin")
    if t_win == nil then
        return
    end
    t_win:setQuatoItemRemainNum(limitBuyCountGroup)
end

--请求购买限购物品
function DailyQuatoBuyModel:sendBuyItem(itemId, newPrice)
    local player = EntityManager:get_player_avatar()
    if player.yuanbao < newPrice then     --元宝不足
        local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
        end
        ConfirmWin2:show( 2, 2, "",  confirm2_func)

    else
        OnlineAwardCC:reqBuyLimitProp(_activityId, itemId)
    end    
end

--
function DailyQuatoBuyModel:fini()
    UIManager:destroy_window("dailyQuotaBuyWin")
end

--
function DailyQuatoBuyModel:onHideWin()

end

--刷新活动ID，用于区别新老服
function DailyQuatoBuyModel:refreshActivityId(activityId)
    --如果刷新的活动ID和当前活动ID一样，不需执行动作
    if _activityId == activityId then
        return
    end

    --保存活动ID
    _activityId = activityId
    --刷新活动配置参数
    DailyQuotaBuyConfig:refreshActivityParam(_activityId)
end