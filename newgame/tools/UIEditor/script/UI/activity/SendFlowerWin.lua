--region SendFlowerWin.lua    --送花排行榜活动界面
--Author : 肖进超
--Date   : 2014/10/27

require "../data/layouts/Activity/SendFlowerWinLayout"
require "model/activity/SendFlowerModel"     	--送花排行榜活动逻辑

super_class.SendFlowerWin(NormalStyleWindow);

local _REWARD_FLAG_ = 1
local _ADDUP_FLAG_  = 2
local _RANKING_FLAG_  = 3

local _DQPM_TEXT = nil
local _SHSL_TEXT = nil


--构造函数
function SendFlowerWin:__init( window_name, window_info )
    self._ramianTimeLb = nil   --活动剩余时间

    self._rankingGroup = {}    --赠送鲜花排名榜
    self._rewardGrup = {}      --奖励排行
    self._addUpGroup = {}      --累计赠送鲜花奖励
 
    self._rewardScroll = nil
    self._addUpScroll = nil
    self._rankingScroll = nil 

    self._myRankingLb = nil  
    self._mySendNumLb = nil

    self._addUpGetImgGroup = {}
    self._rewardStateGroup = {}

    --初始化窗口控件
    self:createWin()
end

--
function SendFlowerWin:active(status)
	if status then
        --初始化窗口数据
        SendFlowerModel:initWinInfo()
    else
        
    end
end

--
function SendFlowerWin:destroy()
    self._ramianTimeLb:destroy()   --销毁定时器控件

    local t_pageParent = SendFlowerWin.super
	t_pageParent.destroy(self)

    self._ramianTimeLb = nil   --活动剩余时间

    self._rankingGroup = nil    --赠送鲜花排名榜
    self._rewardGrup = nil      --奖励排行
    self._addUpGroup = nil      --累计赠送鲜花奖励
 
    self._rewardScroll = nil
    self._addUpScroll = nil
    self._rankingScroll = nil 

    self._myRankingLb = nil  
    self._mySendNumLb = nil

    self._addUpGetImgGroup = nil
    self._rewardStateGroup = nil
end

--
local function item_view_action(self,itemIndex,eventType)
	--如果是删除事件，删除相对应滑动框按钮组的按钮
	if eventType == ITEM_DELETE then
		self._addUpGetImgGroup[itemIndex] = nil
	end
end

--创建一行奖励数据
local function create_scroll_item(self,itemIndex, flag)
    local t_titleText = nil
    local t_awardData = nil
    if flag == _REWARD_FLAG_ then 
        t_titleText = self._rewardGrup[itemIndex].title
        t_awardData = self._rewardGrup[itemIndex].awardData
    elseif flag == _ADDUP_FLAG_ then 
        t_titleText = self._addUpGroup[itemIndex].title
        t_awardData = self._addUpGroup[itemIndex].awardData
    end

    --创建视图背景
    local itemLayout = SendFlowerWinLayout.rewardItem
    local itemDk = ZBasePanel:create(nil, itemLayout.path, itemLayout.x, itemLayout.y, itemLayout.width, itemLayout.height, 0, 500, 500)
   
    --
    local titleDkLayout = itemLayout.titleDk
    local titleDk = ZImage:create(itemDk, titleDkLayout.path, titleDkLayout.x, titleDkLayout.y, titleDkLayout.width, titleDkLayout.height,0, 500, 500) 
    titleDk.view:setAnchorPoint(0, 1)
    --
    local titleLayout = titleDkLayout.title
    local titleLb = ZLabel:create(titleDk, t_titleText, titleLayout.x, titleLayout.y, titleLayout.fontSize)
    titleLb.view:setAnchorPoint(CCPointMake(0.5, 0.5))

    --创建奖励物品列表
    local awardCount = #t_awardData
    local awardLayout = itemLayout.itemSlot

    for awardIndex = 1, awardCount do
        --计算横坐标
        local awardX = awardLayout.beginX + (awardIndex - 1) * awardLayout.differX
        local award = t_awardData[awardIndex]
        local awardId = award.awardId
        local awardSlot = MUtils:create_slot_item2(itemDk,awardLayout.bgPath,awardX,awardLayout.y,awardLayout.width,awardLayout.height,awardId,nil,9.5)
        
        -- local function f1( arg )--设置回调单击函数
        --     local t_propId = sprite.view:getIconId()
        --     if  t_propId  then 
        --         local click_pos = Utils:Split(arg, ":")
        --         local world_pos = sprite.view.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        --         local flag = 0;
        --         if sprite.view:get_isLock() == true then
        --             flag = 1;
        --         end
        --         TipsModel:show_shop_tip( world_pos.x, world_pos.y, t_propId,nil,flag );
        --     end
        -- end
        -- sprite.view:set_click_event( f1 )

        --设置道具数量
        local awardCount = award.count
        awardSlot:set_count(awardCount)
    end

    if flag == _ADDUP_FLAG_ then 
        itemDk.view:registerScriptHandler(bind(item_view_action, self, itemIndex))
        local layout = itemLayout.getImg
        local getImg = ZImage:create(itemDk, layout.path, layout.x, layout.y, layout.width, layout.height,0, 500, 500)  --累计送花奖励领取状态     
        local state = self._rewardStateGroup[itemIndex]
        -- getImg.view:runAction(CCRotateTo:actionWithDuration(0, 90));
        if state == 2 then
            getImg.view:setIsVisible(true)
        else
            getImg.view:setIsVisible(false)
        end
        self._addUpGetImgGroup[itemIndex] = getImg
    end

    return itemDk
end

--创建一行排行榜记录
local function create_rankingScroll_item(self,itemIndex, flag)
    local t_data = {itemIndex, self._rankingGroup[itemIndex][1], self._rankingGroup[itemIndex][2]}

    --创建视图背景
    local itemLayout = SendFlowerWinLayout.rankingItem
    local itemDk = ZBasePanel:create(nil, itemLayout.path, itemLayout.x, itemLayout.y, itemLayout.width, itemLayout.height, 0, 500, 500)
    
    --排名,角色名，赠送数量
    local layout = itemLayout.text
    for i = 1, 3 do 
        local lb = ZLabel:create(itemDk, tostring(t_data[i]), layout.beginX + layout.differX * (i - 1), layout.y, layout.fontSize)
        lb.view:setAnchorPoint(CCPointMake(0.5, 1))
    end
    --分割线
    local layout = itemLayout.line
    ZImage:create(itemDk, layout.path, layout.x, layout.y, layout.width, layout.height)   

    return itemDk
end

--
local function scroll_action(self, flag, eventType,args,msgId)
    if eventType == nil or args == nil or msgId == nil then 
        return false
    end

    if eventType == SCROLL_CREATE_ITEM then
        -- 计算创建的 序列号
        local temparg = Utils:Split_old(args,":")
        local x = temparg[1]              -- 行
        local y = temparg[2]              -- 列
        local t_itemIndex = x + 1

        --创建每行子行
        local t_itemView = nil
        if flag == _REWARD_FLAG_ then
            t_itemView = create_scroll_item(self,t_itemIndex, flag)
            self._rewardScroll:addItem(t_itemView. view)
            self._rewardScroll:refresh()

        elseif flag == _ADDUP_FLAG_ then 
            t_itemView = create_scroll_item(self,t_itemIndex, flag)
            self._addUpScroll:addItem(t_itemView. view)
            self._addUpScroll:refresh()

        elseif flag == _RANKING_FLAG_ then
            t_itemView = create_rankingScroll_item(self,t_itemIndex, flag)
            self._rankingScroll:addItem(t_itemView. view)
            self._rankingScroll:refresh()

        end

        return false
    end
end

--初始化创建窗口
function SendFlowerWin:createWin()
    -- 大背景
    ZImage:create(self.view, UILH_COMMON.normal_bg_v2, 10, 10, 880, 560, 0, 500, 500)

    --左边的底框   
    -- local dkLayout = SendFlowerWinLayout.leftDk
    -- ZImage:create(self.view, dkLayout.path, dkLayout.x, dkLayout.y, dkLayout.width, dkLayout.height, 0, 500, 500)

    --右边的底框   
    local rightDkLayout = SendFlowerWinLayout.rightDk
    local leftDk = ZImage:create(self.view, rightDkLayout.path, rightDkLayout.x, rightDkLayout.y, rightDkLayout.width, rightDkLayout.height, 0, 500, 500)
    --奖励列表标题
    local dkLayout = rightDkLayout.rewardTitleDk
    local dk = ZImage:create(leftDk, dkLayout.path, dkLayout.x, dkLayout.y, dkLayout.width, dkLayout.height, 0, 500, 500) 
    dk.view:setAnchorPoint(0.5, 1)  
    --
    local layout = dkLayout.title
    local titleLb = ZLabel:create(dk, layout.text, layout.x, layout.y, layout.fontSize)
    titleLb.view:setAnchorPoint(CCPointMake(0.5, 0.5))

     --排行榜底框   
    local rankingLayout = SendFlowerWinLayout.rankingDk
    local rankingDk = ZImage:create(self.view, rankingLayout.path, rankingLayout.x, rankingLayout.y, rankingLayout.width, rankingLayout.height, 0, 500, 500)
    local dkLayout = rankingLayout.titleDk
    local dk = ZImage:create(rankingDk, dkLayout.path, dkLayout.x, dkLayout.y, dkLayout.width, dkLayout.height, 0, 500, 500)   
    --排名 , 角色名 , 赠送数量
    for i = 1, 3 do 
        local layout = dkLayout["subTitle" .. i]
        local titleLb = ZLabel:create(dk, layout.text, layout.x, layout.y, layout.fontSize)
        titleLb.view:setAnchorPoint(CCPointMake(0.5, 0.5))   
    end

    --排名榜滚动框
    local layout = SendFlowerWinLayout.rankingScroll
    local scroll = CCScroll:scrollWithFile(layout.x, layout.y, layout.width, layout.height, 0, "", TYPE_HORIZONTAL)
    self._rankingScroll = scroll
    scroll:registerScriptHandler(bind(scroll_action, self, _RANKING_FLAG_))
    scroll:refresh()
    self.view:addChild(scroll)  

    --我的当前排名 、 我赠送的花朵
    local dkLayout = SendFlowerWinLayout.myInfoDk
    local dk = ZImage:create(self.view, dkLayout.path, dkLayout.x, dkLayout.y, dkLayout.width, dkLayout.height, 0, 500, 500)
    --
    local layout = dkLayout.rankingText
    local titleLb = ZLabel:create(dk, layout.text, layout.x, layout.y, layout.fontSize)
    titleLb.view:setAnchorPoint(CCPointMake(0, 0.5))   
    _DQPM_TEXT = layout.text
    self._myRankingLb = titleLb
    --
    local layout = dkLayout.sendNumText
    local titleLb = ZLabel:create(dk, layout.text, layout.x, layout.y, layout.fontSize)
    titleLb.view:setAnchorPoint(CCPointMake(0, 0.5))  
    _SHSL_TEXT = layout.text
    self._mySendNumLb = titleLb

     --创建奖励列表滑动框
    local layout = SendFlowerWinLayout.rewardScroll
    local scroll = CCScroll:scrollWithFile(layout.x, layout.y, layout.width, layout.height, 0, "", TYPE_HORIZONTAL)
    -- local size = scroll:getSize();
    -- local color_rect =  CCArcRect:arcRectWithColor(0, 0, size.width, size.height, 0xffffffff);
    -- scroll:addChild(color_rect);

    self._rewardScroll = scroll
    scroll:registerScriptHandler(bind(scroll_action, self, _REWARD_FLAG_))
    scroll:refresh()
    self.view:addChild(scroll)  

    --  “上下滑动可查看更多排名奖励”
    local dkLayout = SendFlowerWinLayout.moreInfoDk
    local dk = ZImage:create(self.view, dkLayout.path, dkLayout.x, dkLayout.y, dkLayout.width, dkLayout.height, 0, 500, 500)   
    --
    local layout = dkLayout.title
    local titleLb = ZLabel:create(dk, layout.text, layout.x, layout.y, layout.fontSize)
    titleLb.view:setAnchorPoint(CCPointMake(0, 0.5))

    --创建累计送花奖励列表滑动框
    local layout = SendFlowerWinLayout.addUpRewardScroll
    local scroll = CCScroll:scrollWithFile(layout.x, layout.y, layout.width, layout.height, 0, "", TYPE_HORIZONTAL)
    -- local size = scroll:getSize();
    -- local color_rect =  CCArcRect:arcRectWithColor(0, 0, size.width, size.height, 0xffffffff);
    -- scroll:addChild(color_rect);
    self._addUpScroll = scroll
    scroll:registerScriptHandler(bind(scroll_action, self, _ADDUP_FLAG_))
    scroll:refresh()
    self.view:addChild(scroll)  
end

--
local function count_down_end_callback(self)
	self._ramianTimeLb:setString(SendFlowerWinLayout._TIME_OUT_CONTENT)
end

--创建剩余活动时间、活动说明
function SendFlowerWin:createActivityInfo(remainTime, desc)
     --创建剩余活动时间
    local dkLayout = SendFlowerWinLayout.timeDk
    local dk = ZImage:create(self.view, dkLayout.path, dkLayout.x, dkLayout.y, dkLayout.width, dkLayout.height, 0, 500, 500)
    --
    local layout = dkLayout.timeDesc
    local timeDescLb = ZLabel:create(dk, layout.text, layout.x, layout.y, layout.fontSize)
    timeDescLb.view:setAnchorPoint(CCPointMake(0, 0.5))
    --
    local layout = dkLayout.remainTime 
    self._ramianTimeLb = TimerLabel:create_label(dk, layout.x,layout.y,layout.fontSize, 0, "#c08d53d", bind(count_down_end_callback, self), false, ALIGN_LEFT,false)
    self._ramianTimeLb:setText(remainTime)

    --活动说明
    local layout = SendFlowerWinLayout.activityDesc
    local activityDescLb = MUtils:create_ccdialogEx(self.view, desc, layout.x, layout.y, layout.width, layout.height, 5, layout.fontSize)

     --帮助按钮
    local function onHelpClick()
        SendFlowerModel:openHelpDescWin()
    end
    local layout = SendFlowerWinLayout.helpBtn
	ZImageButton:create(self.view, layout.path, layout.path, bind(onHelpClick), layout.x, layout.y, layout.width, layout.height, 0, 500, 500)
end

--初始化填入奖励数据
function SendFlowerWin:resetRewardScroll(rewardGrup, addUpGroup)
    self._rewardGrup = rewardGrup or {}
    self._addUpGroup = addUpGroup or {}

    --送花排名奖励
    self._rewardScroll:clear()
    self._rewardScroll:setMaxNum(#self._rewardGrup)
    self._rewardScroll:refresh()

    --累计送花奖励
    self._addUpScroll:clear()
    self._addUpScroll:setMaxNum(#self._addUpGroup)
    self._addUpScroll:refresh()
end

--刷新送花排行榜
function SendFlowerWin:resetRankingScroll(rankingGroup)
    self._rankingGroup = rankingGroup

    --
    self._rankingScroll:clear()
    self._rankingScroll:setMaxNum(#self._rankingGroup)
    self._rankingScroll:refresh()
end

--设置我的排名，我的送花数量
function SendFlowerWin:setMySendFlowerInfo(myRanking, mySendNum)
    self._myRankingLb:setText(_DQPM_TEXT .. myRanking)
    self._mySendNumLb:setText(_SHSL_TEXT .. mySendNum)
end

--设置累计送花奖励领取状态
function SendFlowerWin:setaddUpGetImgStatus(rewardStateGroup)
    self._rewardStateGroup = rewardStateGroup or {}
    for k, v in ipairs(rewardStateGroup) do
        if self._addUpGetImgGroup[k] then
            if v == 2 then    --已经领取
                self._addUpGetImgGroup[k].view:setIsVisible(true)
            else
                self._addUpGetImgGroup[k].view:setIsVisible(false)
            end
        end
    end
end