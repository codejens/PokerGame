--region DailyQuotaBuyWin.lua    --每日限购活动界面
--Author : 肖进超
--Date   : 2015/1/6

require "../data/layouts/Activity/DailyQuotaBuyWinLayout"
require "UI/activity/CCountDownWin"
super_class.DailyQuotaBuyWin(CountDownWin);

--功能：定义目标奖励窗口的属性
--参数：1、self     目标奖励窗口对象
--返回：无
local function create_self_params(self)
    self._desc = nil
    self._quotaScroll = nil 
    self._quotaItems = nil
    self._remainNumLbGroup = {}
    self._numGroup = nil
end

--购买限购物品
local function buy_btn_click(itemId, newPrice)
    -- print("购买限购物品")
    DailyQuatoBuyModel:sendBuyItem(itemId, newPrice)
end

--
local function item_view_action(self,itemIndex,eventType)
    --如果是删除事件，删除相对应滑动框按钮组的按钮
    if eventType == ITEM_DELETE then
        self._remainNumLbGroup[itemIndex] = nil
    end
end

--创建一个限购物品展示
local function createOneItem(self, itemInfo, tag)
    local itemLayout = DailyQuotaBuyWinLayout.oneItemDk
    -- local itemDk = ZBasePanel:create(nil, itemLayout.path, 0, 0, itemLayout.width, itemLayout.height, 0, 500, 500)
    local itemDk = ZBasePanel:create(nil, UILH_COMMON.bg_11, 0, 0, 237, 145, 0, 500, 500)
    itemDk.view:registerScriptHandler(bind(item_view_action, self, tag))

    --标题
    local title_bg = ZImage:create(itemDk.view, UILH_NORMAL.title_bg4, 5,112,230,31, nil, 500, 500 )

    local layout = itemLayout.title
    local name = ItemConfig:get_item_name_by_item_id( itemInfo.itemId )
    local title = ZLabel:create(itemDk, name, layout.x, layout.y+16, layout.fontSize)
    title.view:setAnchorPoint(CCPointMake(0.5, 1))

    --限购图标
    local layout = itemLayout.quota
    -- local quota = ZImage:create(itemDk, layout.path, layout.x, layout.y, layout.width, layout.height, nil, 500, 500 )
    local quota = ZImage:create(itemDk, layout.path, 235, 147, layout.width, layout.height, nil, 500, 500 )
    quota:setAnchorPoint(1, 1);

    --物品展示
    local layout = itemLayout.slotItem
    -- local awardSlot = ZSlotItem:create(itemDk, layout.bgPath, layout.x, layout.y, layout.width, layout.height, itemInfo.itemId)  
    local awardSlot = MUtils:create_slot_item2(itemDk,layout.bgPath, layout.x+7, layout.y, layout.width, layout.height, itemInfo.itemId,nil,9.5);
    -- awardSlot:set_icon(t_awardId)
    awardSlot:set_color_frame(itemInfo.itemId, -4, -4, 66, 66);
    --购买按钮
    local layout = itemLayout.buyBtn
    local buy_btn = ZButton:create(itemDk, layout.bgPath, bind(buy_btn_click, itemInfo.itemId, itemInfo.newPrice), layout.x, layout.y-4, layout.width, layout.height)
    local buy_lab = UILabel:create_lable_2( LH_COLOR[2].."购买", 0, 0, 16, ALIGN_LEFT)
    local buy_btn_size = buy_btn:getSize()
    local buy_lab_size = buy_lab:getSize()
    buy_lab:setPosition(buy_btn_size.width/2 - buy_lab_size.width/2,buy_btn_size.height/2 - buy_lab_size.height/2+3)
    buy_btn:addChild(buy_lab)
    --原价
    local layout = itemLayout.oldPrice
    ZLabel:create(itemDk,layout.text .. itemInfo.oldPrice, 93,89, layout.fontSize)
    --原价划线
    local layout = itemLayout.oldLine
    ZImage:create(itemDk, layout.path, 95, 93,layout.width, layout.height)
    --现价
    local layout = itemLayout.newPrice
    ZLabel:create(itemDk,layout.text .. itemInfo.newPrice, 93,66, layout.fontSize)
    --剩余数量
    local layout = itemLayout.remainNum
    self._remainNumLbGroup[tag] = ZLabel:create(itemDk, DailyQuotaBuyWinLayout.TEXT_NUM, 93,43, layout.fontSize)
    if self._numGroup then
        self._remainNumLbGroup[tag]:setText(LH_COLOR[2]..DailyQuotaBuyWinLayout.TEXT_NUM .. self._numGroup[tag])
    end


    return itemDk
end

--
local function create_scroll_item(self,itemIndex)
    --创建视图背景
    local itemLayout = DailyQuotaBuyWinLayout.itemDk
    -- local itemDk = ZBasePanel:create(nil, itemLayout.path, 0, 0, itemLayout.width, itemLayout.height, 0, 500, 500)
    local itemDk = ZBasePanel:create(nil, itemLayout.path, 0, 0, 230 * 2 , 155, 0, 500, 500)

    --
    local tag = (itemIndex - 1) * 2
    local layout = itemLayout.itemLine
    for idx = 1, layout.maxNum do
        local itemInfo = self._quotaItems[itemIndex][idx]
        if itemInfo then 
            tag = tag + 1
            local item = createOneItem(self, itemInfo, tag)
            item.view:setPosition(layout.beginX + (idx-1) * 242, layout.y)
            itemDk.view:addChild(item.view)
        end
    end

    return itemDk
end
--
local function scroll_action(self, eventType,args,msgId)
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
        local t_itemView = create_scroll_item(self, t_itemIndex)
        self._quotaScroll:addItem(t_itemView.view)
        self._quotaScroll:refresh()
        return false
    end
end

--构造函数
function DailyQuotaBuyWin:__init( window_name, texture, grid, width,  height,title_text )
    create_self_params(self)
   
   --第一张背景图
    local layout = DailyQuotaBuyWinLayout.bigBackground
    ZImage:create(self.view, layout.path, layout.x, layout.y, layout.width, layout.height, 0, 500, 500 )

   -- 灰色大底框
    local layout = DailyQuotaBuyWinLayout.bigDk
    ZImage:create(self.view, layout.path, layout.x, layout.y, layout.width, layout.height, 0, 500, 500 )

    --创建倒计时标题和设置倒计时位置
    local layout = DailyQuotaBuyWinLayout.remainTime
    ZLabel:create(self.view, layout.title, layout.titleX, layout.titleY, layout.fontSize)
    self:setRemainPosition(layout.timeX, layout.timeY)
    
    --活动说明
    local layout = DailyQuotaBuyWinLayout.desc
     self._desc = ZLabel:create(self.view, "", layout.x, layout.y, layout.fontSize)

    --限购物品展示滑动框
    local layout = DailyQuotaBuyWinLayout.scroll
    -- local scroll = CCScroll:scrollWithFile(layout.x, layout.y, layout.width, layout.height, 0, "", TYPE_HORIZONTAL)
    local scroll = CCScroll:scrollWithFile(layout.x-4, layout.y-2, 238 * 2 + 5, 284+20, 0, "", TYPE_HORIZONTAL)
    scroll:registerScriptHandler(bind(scroll_action, self))
    scroll:refresh()
    self.view:addChild(scroll)  
    self._quotaScroll = scroll

     --滑动框金边
    -- local layout = DailyQuotaBuyWinLayout.goldDk
    -- ZImage:create(self.view, layout.path, layout.x, layout.y, layout.width, layout.height, 0, 500, 500 )
end

--设置活动说明
function DailyQuotaBuyWin:setActivityDescText(desc)
     self._desc:setText(LH_COLOR[2]..desc)
end

--
function DailyQuotaBuyWin:setQuatoItemRemainNum(numGroup)
    self._numGroup = numGroup
    for tag, num in ipairs(numGroup) do 
        if self._remainNumLbGroup[tag] then
            self._remainNumLbGroup[tag]:setText(DailyQuotaBuyWinLayout.TEXT_NUM .. num)
        end
    end
end

--
function DailyQuotaBuyWin:resetQuotaItemsScroll(items)
    print("#items",#items)
    self._quotaItems = items
    self._quotaScroll:clear()
    self._quotaScroll:setMaxNum(#self._quotaItems)
    self._quotaScroll:refresh()
end

--
function DailyQuotaBuyWin:destroy()
    local t_pageParent = DailyQuotaBuyWin.super
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示窗口时候的行为（kone：每次玩家将该ui从隐藏状态变到显示状态）
--参数：无
--返回：无
function DailyQuotaBuyWin:showWinAction()
    DailyQuatoBuyModel:showDailyQuotaBuyWin()
end

--功能：关闭窗口时候的行为 (kone：点击了ui的close button)
--参数：无
--返回：无
function DailyQuotaBuyWin:hideWinAction()
    DailyQuatoBuyModel:onHideWin()
end