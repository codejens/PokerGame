--CGroupBuyPage.lua
--内容：超级团购活动页面基础类
--作者：肖进超
--时间：2014.09.17

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/GroupBuyPageLayout"


--定义常量 
local _COLUMN_MAX_COUNT = 6
local t_awardTitle = {}

--创建移动位置活动页面基础类
super_class.GroupBuyPage(NormalInfoPage)

--功能：定义超级团购活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：肖进超
--时间：2014.11.04
local function create_self_params(self)
	self._scroll = nil
	self._awardDataGroup = nil
	self._itemTitleGroup = nil
end

--功能：“立即前往”按钮点击回调
--参数：1、self			页面对象
--		2、itemIndex	子项索引
--返回：无
--作者：肖进超
--时间：2014.11.04
local function goto_button_click(self)
	self:goGroupBuy()
end

--功能：创建滑动框子行
--参数：1、self			窗口对象
--		2、itemIndex	子行索引
--返回：无
--作者：肖进超
--时间：2014.11.04
local function create_scroll_item(self,itemIndex)
	--创建视图背景
	local t_itemBgLayout = CGroupBuyPageLayout.itemBg
	local t_itemBg = ZBasePanel:create(nil,t_itemBgLayout.path,t_itemBgLayout.x,t_itemBgLayout.y,t_itemBgLayout.width,t_itemBgLayout.height,0,500,500)
	
	--创建子项标题背景
	local t_itemTitleBgLayout = CGroupBuyPageLayout.itemTitleBg
	ZImage:create(t_itemBg,t_itemTitleBgLayout.path,t_itemTitleBgLayout.x,t_itemTitleBgLayout.y,t_itemTitleBgLayout.width,t_itemTitleBgLayout.height,0,500,500)

	--创建子项标题
	local t_titleContent = self._itemTitleGroup[itemIndex]
	local t_titleLayout = CGroupBuyPageLayout.itemTitle
	local t_titleLabel = ZLabel:create(t_itemBg,t_titleContent,t_titleLayout.x,t_titleLayout.y,t_titleLayout.fontSize)
	t_titleLabel.view:setAnchorPoint(CCPointMake(0.5,0))

	--创建道具列表
	local t_awardData = self._awardDataGroup[itemIndex]
	local t_awardCount = #t_awardData
	local t_awardGroupLayout = CGroupBuyPageLayout.itemAwardGroup

	for t_awardIndex = 1,t_awardCount do
		--计算横坐标
		local t_awardX = t_awardGroupLayout.beginX + (t_awardIndex - 1) * t_awardGroupLayout.differX

		local t_award = t_awardData[t_awardIndex]
		local t_awardId = t_award.awardId
		-- local t_awardSlot = ZSlotItem:create(t_itemBg,t_awardGroupLayout.bgPath,t_awardX,t_awardGroupLayout.y,t_awardGroupLayout.width,t_awardGroupLayout.height,t_awardId)
		local t_awardSlot = MUtils:create_slot_item2(t_itemBg,t_awardGroupLayout.bgPath,t_awardX,t_awardGroupLayout.y,t_awardGroupLayout.width,t_awardGroupLayout.height,t_awardId,nil,9.5);

		--设置道具数量
		local t_awardCount = t_award.count
		t_awardSlot:set_item_count(t_awardCount)
	end

	--创建“立即前往”按钮
	local t_gotoButtonLayout = CGroupBuyPageLayout.itemGotoButton
	local t_gotoButton = ZImageButton:create(t_itemBg, t_gotoButtonLayout.bgPath, t_gotoButtonLayout.imagePath,bind(goto_button_click,self), t_gotoButtonLayout.x, t_gotoButtonLayout.y, t_gotoButtonLayout.width, t_gotoButtonLayout.height, 0, 500, 500)
	-- t_gotoButton.btn:addImage(CLICK_STATE_UP, t_gotoButtonLayout.bgPath)

	--创建分割线
	-- local t_splitLineLayout = CGroupBuyPageLayout.splitLine
	-- ZImage:create(t_itemBg,t_splitLineLayout.path,t_splitLineLayout.x,t_splitLineLayout.y,t_splitLineLayout.width,t_splitLineLayout.height)

	return t_itemBg
end

--功能：滑动框动作
--参数：1、self			窗口对象
--		2、eventType	事件类型
--		3、args			参数
--		4、msgId		信息ID
--返回：无
--作者：肖进超
--时间：2014.11.04
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

--功能：创建超级团购活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.09.19
function GroupBuyPage:__init()
	--创建私有变量
	create_self_params(self)

	--创建分割线
	-- local t_dividingLineLayout = CGroupBuyPageLayout.dividingLine
	-- ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_dividingLineLayout.y, t_dividingLineLayout.width, t_dividingLineLayout.height)
   
    --创建奖励预览标题
    local award_bg_layout = MovePlacePageLayout.award_bg
     ZImage:create(self._pageView, award_bg_layout.path, award_bg_layout.x, award_bg_layout.y, award_bg_layout.width, award_bg_layout.height)
     
	--创建滑动框
	local t_scrollLayout = CGroupBuyPageLayout.scroll
	local t_scroll = CCScroll:scrollWithFile(t_scrollLayout.x,t_scrollLayout.y,t_scrollLayout.width,t_scrollLayout.height,0,"",TYPE_HORIZONTAL)
	self._scroll = t_scroll
	t_scroll:registerScriptHandler(bind(scroll_action,self))
    t_scroll:refresh()
    self._pageView:addChild(t_scroll)  
end

--功能：设置滑动框标题组
--参数：1、itemTitleGroup	滑动框标题组
--返回：无
--作者：肖进超
--时间：2014.11.04
function GroupBuyPage:setItemTitleGroup(itemTitleGroup)
	self._itemTitleGroup = itemTitleGroup
end

--功能：设置滑动框奖励组
--参数：1、awardDataGroup	滑动框奖励组
--返回：无
--作者：肖进超
--时间：2014.11.04
function GroupBuyPage:setAwardDataGroup(awardDataGroup)
	self._awardDataGroup = awardDataGroup
end

--功能：重置滑动框的内容
--参数：无
--返回：无
--作者：肖进超
--时间：2014.11.04
function GroupBuyPage:resetScroll()
	local t_scrollItemCount = #self._itemTitleGroup
	self._scroll:clear()
	self._scroll:setMaxNum(t_scrollItemCount)
	self._scroll:refresh()
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.09.19
function GroupBuyPage:destroy()
	--获取父类
	local t_pageParent = GroupBuyPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：超级团购的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.11.04
function GroupBuyPage:goGroupBuy()

end