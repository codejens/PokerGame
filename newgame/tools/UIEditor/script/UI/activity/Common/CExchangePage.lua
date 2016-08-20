--CExchangePage.lua
--内容：兑换奖励活动页面基础类
--作者：陈亮
--时间：2014.09.23

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/ExchangePageLayout"

--创建兑换奖励活动页面基础类
super_class.ExchangePage(NormalInfoPage)

--功能：定义兑换奖励活动页面的基础属性
--参数：self   页面对象
--返回：无
--作者：陈亮
--时间：2014.09.23
local function create_self_params(self)
    self._scroll = nil
    self._awardDataGroup = nil
    self._itemTitleGroup = nil
    self._exchangeTitleGroup = nil
    self._exchangeContentGroup = nil
    self._exchangeStatusGroup = nil
    self._exchangeButtonGroup = {}
    self._exchangeLabelGroup = {}
end

--功能：兑换按钮点击回调
--参数：1、self         页面对象
--      2、itemIndex 子项索引
--返回：无
--作者：陈亮
--时间：2014.09.23
local function exchange_button_click(self,itemIndex)
    self:exchangeAward(itemIndex)
end

--功能：刷新领取按钮状态
--参数：1、self         窗口对象
--      2、itemIndex 子项索引
--返回：无
--作者：陈亮
--时间：2014.09.23
local function flush_exchange_button_status(self,itemIndex)
    --获取按钮不存在，不进行操作
    local t_exchangeButton = self._exchangeButtonGroup[itemIndex]
    if (not t_exchangeButton) then
        return 
    end

    local t_exchangeButtonStatus = self._exchangeStatusGroup[itemIndex]
    --刷新当前领取按钮状态
    local t_itemExchangeButtonStatus = t_exchangeButtonStatus.status
    if t_itemExchangeButtonStatus then
        t_exchangeButton.view:setCurState(CLICK_STATE_UP)
    else
        t_exchangeButton.view:setCurState(CLICK_STATE_DISABLE)
    end

    --设置按钮图片路径
    -- local t_imagePath = UILH_ACHIEVE.reward
    -- t_exchangeButton:set_image_texture(t_imagePath)
end


--功能：滑动框的子项视图动作
--参数：1、self         窗口对象
--      2、itemIndex 子项索引
--      3、eventType 事件类型
--返回：无
--作者：陈亮
--时间：2014.09.23
local function item_view_action(self,itemIndex,eventType)
    --如果是删除事件，删除相对应滑动框按钮组的按钮、兑换文本
    if eventType == ITEM_DELETE then
        self._exchangeButtonGroup[itemIndex] = nil
        self._exchangeLabelGroup[itemIndex] = nil
    end
end


--功能：创建滑动框子行
--参数：1、self         窗口对象
--      2、itemIndex 子行索引
--返回：无
--作者：陈亮
--时间：2014.09.23
local function create_scroll_item(self,itemIndex)
    local t_num = #self._awardDataGroup
    local each_h = 90
    local p_height = each_h * t_num
    local panel = ZBasePanel:create(nil,"",0,0,548,p_height,0,500,500)
    for i = 1, t_num do
        --创建视图背景
        local t_itemBgLayout = ExchangePageLayout.itemBg
        local bg_y = p_height - each_h*i
        local t_itemBg = ZBasePanel:create(nil,"",0,bg_y,548, each_h,0,500,500)

        --创建道具
        local t_awardData = self._awardDataGroup[i]

        local t_awardX = 115
        local t_awardId = t_awardData.awardId
        local slot_width  = 67
        local slot_height = 67
        local t_awardSlot = SlotItem(slot_width, slot_height)               --创建slotitem    
        t_awardSlot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -6, -6, 79, 79 )
        t_awardSlot:setPosition(t_awardX, 15)
        t_awardSlot:set_icon(t_awardId)
        t_awardSlot:set_color_frame(t_awardId, -1, -1, 69, 69);
        --设置回调单击函数
        local function f1( ... )
            if ( t_awardId ) then 
                local a, b, arg = ...
                local click_pos = Utils:Split(arg, ":")
                local world_pos = t_awardSlot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_shop_tip( world_pos.x, world_pos.y, t_awardId );
            end
            
        end
        t_awardSlot:set_click_event( f1 )
        --设置道具数量
        local t_awardCount = t_awardData.count
        t_awardSlot:set_item_count(t_awardCount)
        t_itemBg:addChild(t_awardSlot.view)

        --创建子项兑换内容
        local t_exchangeContent = self._exchangeContentGroup[i]
        local t_exchangeLabelLayout = ExchangePageLayout.exchangeLabel
        local t_exchangeLabel = ZLabel:create(t_itemBg,t_exchangeContent,336,40,18)
        t_exchangeLabel.view:setAnchorPoint(CCPointMake(0.5,0))
        self._exchangeLabelGroup[i] = t_exchangeLabel

        --创建领取按钮
        local t_exchangeButtonLayout = ExchangePageLayout.itemExchangeButton
        local t_exchangeButton = ZButton:create(t_itemBg, UILH_COMMON.lh_button2,bind(exchange_button_click,self,i), 448, 28, -1, -1, 0, 500, 500)
        t_exchangeButton.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.lh_button2_disable)
        ZLabel:create(t_exchangeButton.view, Lang.exchange.model[2], 50, 19, 16, 2)
        self._exchangeButtonGroup[i] = t_exchangeButton

        --刷新创建的领取按钮状态
        -- flush_exchange_button_status(self,i)

        --创建分割线
        local t_splitLineLayout = ExchangePageLayout.splitLine
        ZImage:create(t_itemBg,UILH_COMMON.split_line,0, 4, 570, 1)
        panel:addChild(t_itemBg.view)
    end

    return panel
end

--功能：滑动框动作
--参数：1、self         窗口对象
--      2、eventType 事件类型
--      3、args          参数
--      4、msgId     信息ID
--返回：无
--作者：陈亮
--时间：2014.09.23
local function scroll_action(self,eventType,args,msgId)
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
        local t_itemView = create_scroll_item(self,t_itemIndex)
        self._scroll:addItem(t_itemView.view)
        self._scroll:refresh()

        return false
    end
end

--功能：创建兑换奖励活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:__init()
    --创建私有变量
    create_self_params(self)

    --赋值页面类型
    self._pageType = CommonActivityConfig.TypeExchange
    -- 活动奖励
    ZImage:create(self._pageView, UILH_OPENSER.tips, 5, 272, -1, -1)
    -- 标题背景
    local title_bg = ZImage:create(self._pageView, UILH_NORMAL.title_bg5, 5, 235, 603, -1, 0, 500, 500)
    ZLabel:create(title_bg.view, Lang.chunjie[1], 150, 10, 16, 2)
    self.cost_item = ZLabel:create(title_bg.view, Lang.chunjie[2], 336, 10, 16, 2)
    self.item_num = ZLabel:create(self._pageView, "", 350, 282, 16)
    --创建分割线
    -- local t_dividingLineLayout = ExchangePageLayout.dividingLine
    -- ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_dividingLineLayout.y, t_dividingLineLayout.width, t_dividingLineLayout.height)

    --创建滑动框
    local t_scrollLayout = ExchangePageLayout.scroll
    local t_scroll = CCScroll:scrollWithFile(6,5,598,225,0,"",TYPE_HORIZONTAL)
    self._scroll = t_scroll
    t_scroll:registerScriptHandler(bind(scroll_action,self))
    t_scroll:refresh()
    self._pageView:addChild(t_scroll)  
end

--功能：设置滑动框标题组
--参数：1、itemTitleGroup   滑动框标题组
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:setItemTitleGroup(itemTitleGroup)
    self._itemTitleGroup = itemTitleGroup
end

--功能：设置滑动框奖励组
--参数：1、awardDataGroup   滑动框奖励组
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:setAwardDataGroup(awardDataGroup)
    self._awardDataGroup = awardDataGroup
end

--功能：设置滑动框获取状态组
--参数：1、cur_item_num  当前所需道具数量
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:setExchangeStatusGroup(cur_item_num)
    self._cur_item_num = cur_item_num
end

--功能：设置滑动框兑换标题组
--参数：1、exchangeTitleGroup   滑动框兑换标题组
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:setExchangeTitleGroup(exchangeTitleGroup)
    self._exchangeTitleGroup = exchangeTitleGroup
end

--功能：设置滑动框兑换内容组
--参数：1、exchangeContentGroup   滑动框兑换内容组
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:setExchangeContentGroup(exchangeContentGroup)
    self._exchangeContentGroup = exchangeContentGroup
end

--功能：重置滑动框的内容
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:resetScroll()
    local t_scrollItemCount = #self._itemTitleGroup
    self._scroll:clear()
    self._scroll:setMaxNum(1)
    self._scroll:refresh()
end

--功能：刷新全部领取按钮状态
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:flushAllExchangeStatus()
    local t_exchangeStatusCount = #self._exchangeStatusGroup
    for t_itemIndex = 1,t_exchangeStatusCount do
        --刷新创建的领取按钮状态
        -- flush_exchange_button_status(self,t_itemIndex)
    end
end

--功能：刷新全部兑换内容
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:flushAllExchangeContent()
    local t_exchangeContentCount = #self._exchangeContentGroup
    for t_itemIndex = 1,t_exchangeContentCount do
        local t_exchangeLabel = self._exchangeLabelGroup[t_itemIndex]
        --如果兑换文本存在，进行操作
        if t_exchangeLabel then
            local t_exchangeContent = self._exchangeContentGroup[t_itemIndex]
            t_exchangeLabel:setText(t_exchangeContent)
        end
    end
    -- 所需物品信息
    local item_info = ItemConfig:get_item_by_id(self._exchangeContentGroup.itemId)
    if item_info then
        self.cost_item:setText(string.format(Lang.chunjie[2], item_info.name))
        self.item_num:setText(string.format(Lang.chunjie[3], item_info.name) .. tostring(self._cur_item_num))
    end
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:destroy()
    --获取父类
    local t_pageParent = ExchangePage.super
    --调用父类的析构函数
    t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：兑换奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function ExchangePage:exchangeAward(itemIndex)

end