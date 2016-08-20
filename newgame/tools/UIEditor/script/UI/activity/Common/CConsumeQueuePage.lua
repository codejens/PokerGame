--CConsumeQueuePage.lua
--内容：消费排行页面基础类
--作者：陈亮
--时间：2014.10.30

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/ConsumeQueuePageLayout"

--创建消费排行页面基础类
super_class.ConsumeQueuePage(NormalInfoPage)

--功能：定义消费排行页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.10.30
local function create_self_params(self)
	self._awardDataGroup 		= nil
	self._roleNameGroup 		= nil
	self._consumeGoldGroup 		= nil
	self._myQueueLabel 			= nil
	self._myConsumeGoldLabel 	= nil
	self._roleNameLabelGroup 	= {}
	self._consumeGoldLabelGroup = {}
end

--功能：创建滑动框子行
--参数：1、self			窗口对象
--		2、itemIndex	子行索引
--返回：无
--作者：陈亮
--时间：2014.10.30
local function create_scroll_item(self,itemIndex)
	--创建视图背景
	local t_itemBgLayout = ConsumeQueuePageLayout.itemBg
	local t_itemBg = ZBasePanel:create(nil,t_itemBgLayout.path,t_itemBgLayout.x,t_itemBgLayout.y,t_itemBgLayout.width,t_itemBgLayout.height,0,500,500)

	--创建名次文本
	local t_numberLabelLayout = ConsumeQueuePageLayout.numberLabel
	local t_numberContent = string.format(t_numberLabelLayout.content,itemIndex)
	local t_numberLabel = ZLabel:create(t_itemBg,t_numberContent,t_numberLabelLayout.x,t_numberLabelLayout.y,t_numberLabelLayout.fontSize)
	t_numberLabel.view:setAnchorPoint(CCPointMake(0.5,0))

	--创建角色名文本
	local t_roleNameLabelLayout = ConsumeQueuePageLayout.roleNameLabel
	local t_roleName = self._roleNameGroup[itemIndex]
	local t_roleNameLabel = ZLabel:create(t_itemBg,t_roleName,t_roleNameLabelLayout.x,t_roleNameLabelLayout.y,t_roleNameLabelLayout.fontSize)
	t_roleNameLabel.view:setAnchorPoint(CCPointMake(0.5,0))
	self._roleNameLabelGroup[itemIndex] = t_roleNameLabel

	--创建消费元宝文本
	local t_consumeGoldLabelLayout = ConsumeQueuePageLayout.consumeGoldLabel
	local t_consumeGold = self._consumeGoldGroup[itemIndex]
	local t_consumeGoldLabel = ZLabel:create(t_itemBg,t_consumeGold,t_consumeGoldLabelLayout.x,t_consumeGoldLabelLayout.y,t_consumeGoldLabelLayout.fontSize)
	t_consumeGoldLabel.view:setAnchorPoint(CCPointMake(0.5,0))
	self._consumeGoldLabelGroup[itemIndex] = t_consumeGoldLabel

	--创建道具列表
	local t_awardData = self._awardDataGroup[itemIndex]
	local t_awardCount = #t_awardData
	local t_awardGroupLayout = ConsumeQueuePageLayout.itemAwardGroup

	for t_awardIndex = 1,t_awardCount do
		--计算横坐标
		local t_awardX = t_awardGroupLayout.beginX + (t_awardIndex - 1) * t_awardGroupLayout.differX

		local t_award = t_awardData[t_awardIndex]
		local t_awardId = t_award.awardId
		local t_awardSlot = ZSlotItem:create(t_itemBg,t_awardGroupLayout.bgPath,t_awardX,t_awardGroupLayout.y,t_awardGroupLayout.width,t_awardGroupLayout.height,t_awardId)
		
		--设置道具数量
		local t_awardCount = t_award.count
		t_awardSlot.view:set_count(t_awardCount)
	end

	--创建分割线
	local t_splitLineLayout = ConsumeQueuePageLayout.splitLine
	ZImage:create(t_itemBg,t_splitLineLayout.path,t_splitLineLayout.x,t_splitLineLayout.y,t_splitLineLayout.width,t_splitLineLayout.height)

	return t_itemBg
end

--功能：滑动框动作
--参数：1、self			窗口对象
--		2、eventType	事件类型
--		3、args			参数
--		4、msgId		信息ID
--返回：无
--作者：陈亮
--时间：2014.10.30
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

--功能：创建消费排行页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.30
function ConsumeQueuePage:__init()
	--创建私有变量
	create_self_params(self)

	--赋值页面类型
	self._pageType = CommonActivityConfig.TypeConsumeQueue

	--创建排行信息标题
	local t_queueInfoTitleBgLayout = ConsumeQueuePageLayout.queueInfoTitleBg
	ZImage:create(self._pageView, t_queueInfoTitleBgLayout.path, t_queueInfoTitleBgLayout.x, t_queueInfoTitleBgLayout.y, t_queueInfoTitleBgLayout.width, t_queueInfoTitleBgLayout.height,0,500,500)
	local t_queueInfoTitleLayout = ConsumeQueuePageLayout.queueInfoTitle
	ZLabel:create(self._pageView,t_queueInfoTitleLayout.content,t_queueInfoTitleLayout.x,t_queueInfoTitleLayout.y,t_queueInfoTitleLayout.fontSize)

	--创建我的排行
	local t_myQueueTitleLayout = ConsumeQueuePageLayout.myQueueTitle
	ZLabel:create(self._pageView,t_myQueueTitleLayout.content,t_myQueueTitleLayout.x,t_myQueueTitleLayout.y,t_myQueueTitleLayout.fontSize)
	local t_myQueueLayout = ConsumeQueuePageLayout.myQueue
	self._myQueueLabel = ZLabel:create(self._pageView,t_myQueueLayout.content,t_myQueueLayout.x,t_myQueueLayout.y,t_myQueueLayout.fontSize)

	--创建我的消费元宝
	local t_myConsumeGoldTitleLayout = ConsumeQueuePageLayout.myConsumeGoldTitle
	ZLabel:create(self._pageView,t_myConsumeGoldTitleLayout.content,t_myConsumeGoldTitleLayout.x,t_myConsumeGoldTitleLayout.y,t_myConsumeGoldTitleLayout.fontSize)
	local t_myConsumeGoldLayout = ConsumeQueuePageLayout.myConsumeGold
	self._myConsumeGoldLabel = ZLabel:create(self._pageView,t_myConsumeGoldLayout.content,t_myConsumeGoldLayout.x,t_myConsumeGoldLayout.y,t_myConsumeGoldLayout.fontSize)

	--创建包含排行列表表头之间的两条分割线
	local t_dividingLineLayout = ConsumeQueuePageLayout.dividingLine
	ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_dividingLineLayout.y, t_dividingLineLayout.width, t_dividingLineLayout.height)
	local t_secDividingLineY = t_dividingLineLayout.y - t_dividingLineLayout.differY
	ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_secDividingLineY, t_dividingLineLayout.width, t_dividingLineLayout.height)

	--创建排名标题
	local t_queueTitleLayout = ConsumeQueuePageLayout.queueTitle
	ZLabel:create(self._pageView,t_queueTitleLayout.content,t_queueTitleLayout.x,t_queueTitleLayout.y,t_queueTitleLayout.fontSize)

	--创建角色名标题
	local t_roleNameTitleLayout = ConsumeQueuePageLayout.roleNameTitle
	ZLabel:create(self._pageView,t_roleNameTitleLayout.content,t_roleNameTitleLayout.x,t_roleNameTitleLayout.y,t_roleNameTitleLayout.fontSize)

	--创建消费元宝标题
	local t_consumeGoldTitleLayout = ConsumeQueuePageLayout.consumeGoldTitle
	ZLabel:create(self._pageView,t_consumeGoldTitleLayout.content,t_consumeGoldTitleLayout.x,t_consumeGoldTitleLayout.y,t_consumeGoldTitleLayout.fontSize)

	--创建奖励标题
	local t_awardTitleLayout = ConsumeQueuePageLayout.awardTitle
	ZLabel:create(self._pageView,t_awardTitleLayout.content,t_awardTitleLayout.x,t_awardTitleLayout.y,t_awardTitleLayout.fontSize)

	--创建排行滑动框
	local t_scrollLayout = ConsumeQueuePageLayout.scroll
	local t_scroll = CCScroll:scrollWithFile(t_scrollLayout.x,t_scrollLayout.y,t_scrollLayout.width,t_scrollLayout.height,0,"",TYPE_HORIZONTAL)
	self._scroll = t_scroll
	-- t_scroll:registerScriptHandler(bind(scroll_action,self))
    t_scroll:refresh()
    self._pageView:addChild(t_scroll)  
end

--功能：设置我的排行名次
--参数：1、myQueue	我的排行名次
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:setMyQueue(myQueue)
	self._myQueueLabel:setText(myQueue)
end

--功能：设置我的消费元宝
--参数：1、myConsumeGold	我的消费元宝
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:setMyConsumeGold(myConsumeGold)
	self._myConsumeGoldLabel:setText(myConsumeGold)
end

--功能：设置滑动框奖励组
--参数：1、awardDataGroup	滑动框奖励组
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:setAwardDataGroup(awardDataGroup)
	self._awardDataGroup = awardDataGroup
end

--功能：重置滑动框的内容
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:resetScroll()
	local t_scrollItemCount = #self._awardDataGroup
	self._scroll:clear()
	self._scroll:setMaxNum(t_scrollItemCount)
	self._scroll:refresh()
end

--功能：设置消费排行角色名字
--参数：1、roleNameGroup	角色名字组
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:setScrollRoleName(roleNameGroup)
	self._roleNameGroup = roleNameGroup
end

--功能：设置消费排行的消费元宝
--参数：1、roleNameGroup	消费元宝组
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:setScrollConsuemGold(consumeGoldGroup)
	self._consumeGoldGroup = consumeGoldGroup
end

--功能：刷新消费排行角色名字
--参数：1、count			上榜角色数量
--		2、roleNameGroup	角色名字组
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:refreshScrollRoleName(count,roleNameGroup)
	--遍历角色名字文本组，设置角色名字
	for t_index = 1,count do
		local t_roleNameLabel = self._roleNameLabelGroup[t_index]
		local t_roleName = roleNameGroup[t_index]
		t_roleNameLabel:setText(t_roleName)
	end

	self._roleNameGroup = roleNameGroup
end

--功能：刷新消费排行的消费元宝
--参数：1、count			上榜角色数量
--		2、roleNameGroup	消费元宝组
--返回：无
--作者：陈亮
--时间：2014.10.31
function ConsumeQueuePage:refreshScrollConsuemGold(count,consumeGoldGroup)
	--遍历消费元宝文本组，设置消费元宝
	for t_index = 1,count do
		local t_consumeGoldLabel = self._consumeGoldLabelGroup[t_index]
		local t_consumeGold = consumeGoldGroup[t_index]
		t_consumeGoldLabel:setText(t_consumeGold)
	end

	self._consumeGoldGroup = consumeGoldGroup
end
 
--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.30
function ConsumeQueuePage:destroy()
	--获取父类
	local t_pageParent = ConsumeQueuePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end