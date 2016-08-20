--CGainAwardPage.lua
--内容：获取奖励活动页面基础类
--作者：陈亮
--时间：2014.09.22

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/GainAwardPageLayout"

--创建获取奖励活动页面基础类
super_class.GainAwardPage(NormalInfoPage)
-- 分割线1
local divid_line = {path = UILH_COMMON.split_line, x = 5, y = 267, width = 570, height = 1}
-- 滑动条
local scroll_info = {6,5,598,257, t_type = TYPE_HORIZONTAL}
-- 滑动框子项
local scroll_panel = {x = 0, y = 0, width = 588, height = 131}
--滑动框子项标题背景
local itemTitleBg = { path = UILH_NORMAL.title_bg4, x = 30, y = 95, width = 300, height = -1}
--滑动框子项标题
local itemTitle = {x = 175, y = 103, fontSize = 16}
--领取奖励 按钮
local reward_btn = {x = 458, y = 28, width = -1, height = -1}
--功能：定义获取奖励活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.09.22
local function create_self_params(self)
	self._scroll = nil
	self._awardDataGroup = nil
	self._itemTitleGroup = nil
	self._gainStatusGroup = nil
	self._gainButtonGroup = {}

	self._yuanbaoLb = nil    --我的消费元宝数描述
end

--功能：领取按钮点击回调
--参数：1、self			页面对象
--		2、itemIndex	子项索引
--返回：无
--作者：陈亮
--时间：2014.09.22
local function gain_button_click(self,itemIndex)
	self:gainAward(itemIndex)
end

--功能：刷新领取按钮状态
--参数：1、self			窗口对象
--		2、itemIndex	子项索引
--返回：无
--作者：陈亮
--时间：2014.09.22
local function flush_gain_button_status(self,itemIndex)
	--获取按钮不存在，不进行操作
	local t_gainButton = self._gainButtonGroup[itemIndex]
	if (not t_gainButton) then
		return 
	end

	local t_gainButtonStatus = self._gainStatusGroup[itemIndex]
	--刷新当前领取按钮状态
    local t_itemGainButtonStatus = t_gainButtonStatus.status
    if t_itemGainButtonStatus then
        t_gainButton.view:setCurState(CLICK_STATE_UP)
    else
        t_gainButton.view:setCurState(CLICK_STATE_DISABLE)
    end

    --设置按钮图片路径
    local t_imagePath = t_gainButtonStatus.imagePath 
    t_gainButton:set_image_texture(t_imagePath)
end


--功能：滑动框的子项视图动作
--参数：1、self			窗口对象
--		2、itemIndex	子项索引
--		3、eventType	事件类型
--返回：无
--作者：陈亮
--时间：2014.09.22
local function item_view_action(self,itemIndex,eventType)
	--如果是删除事件，删除相对应滑动框按钮组的按钮
	if eventType == ITEM_DELETE then
		self._gainButtonGroup[itemIndex] = nil
	end
end


--功能：创建滑动框子行
--参数：1、self			窗口对象
--		2、itemIndex	子行索引
--返回：无
--作者：陈亮
--时间：2014.09.22
local function create_scroll_item(self,itemIndex)
	local t_num = #self._awardDataGroup
    local each_h = scroll_panel.height
    local p_height = each_h * t_num
    local panel = ZBasePanel:create(nil,"",0,0,548,p_height,0,500,500)
	for i = 1, t_num do
		local bg_y = p_height - each_h*i
		--创建视图背景
		local t_itemBg = ZBasePanel:create(nil,"",scroll_panel.x,bg_y,scroll_panel.width,scroll_panel.height,0,500,500)
		-- t_itemBg.view:registerScriptHandler(bind(item_view_action,self,i))
		
		--创建子项标题背景
		ZImage:create(t_itemBg,itemTitleBg.path,itemTitleBg.x,itemTitleBg.y,itemTitleBg.width,itemTitleBg.height,0,500,500)

		--创建子项标题
		local t_titleContent = self._itemTitleGroup[i]
		local t_titleLabel = ZLabel:create(t_itemBg,t_titleContent,itemTitle.x,itemTitle.y,itemTitle.fontSize)
		t_titleLabel.view:setAnchorPoint(CCPointMake(0.5,0))

		--创建道具列表
		local t_awardData = self._awardDataGroup[i]
		local t_awardCount = #t_awardData
		local t_awardGroupLayout = GainAwardPageLayout.itemAwardGroup

		for t_awardIndex = 1,t_awardCount do
			--计算横坐标
			local t_awardX = 10 + (t_awardIndex - 1) * 80

			local t_award = t_awardData[t_awardIndex]
			local t_awardId = t_award.awardId
			local slot_width  = 67
		    local slot_height = 67
		    local t_awardSlot = SlotItem(slot_width, slot_height)               --创建slotitem	
			t_awardSlot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -6, -6, 79, 79 )
			t_awardSlot:setPosition(t_awardX, 20)
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
			local t_awardCount = t_award.count
			t_awardSlot:set_item_count(t_awardCount)
			t_itemBg:addChild(t_awardSlot.view)
		end

		--创建领取按钮
		local t_gainButtonLayout = GainAwardPageLayout.itemGainButton
		local t_gainButton = ZImageButton:create(t_itemBg, UILH_COMMON.lh_button_4_r, UILH_ACHIEVE.reward,bind(gain_button_click,self,i), reward_btn.x, reward_btn.y, reward_btn.width, reward_btn.height, 0, 500, 500)
		t_gainButton.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.btn4_dis)
		self._gainButtonGroup[i] = t_gainButton
		--刷新创建的领取按钮状态
		flush_gain_button_status(self,i)

		--创建分割线
		local t_splitLineLayout = GainAwardPageLayout.splitLine
		ZImage:create(t_itemBg,UILH_COMMON.split_line, 0, 4, 570, 1)
		panel:addChild(t_itemBg.view)
    end

	return panel
end

--功能：滑动框动作
--参数：1、self			窗口对象
--		2、eventType	事件类型
--		3、args			参数
--		4、msgId		信息ID
--返回：无
--作者：陈亮
--时间：2014.09.22
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

--功能：创建获取奖励活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function GainAwardPage:__init()
	--创建私有变量
	create_self_params(self)

	-- 活动奖励
	ZImage:create(self._pageView, UILH_OPENSER.tips, divid_line.x, divid_line.y + 5, -1, -1)
	--创建分割线
	ZImage:create(self._pageView, divid_line.path, divid_line.x, divid_line.y, divid_line.width, divid_line.height)

	--创建滑动框
	local t_scrollLayout = GainAwardPageLayout.scroll
	local t_scroll = CCScroll:scrollWithFile(scroll_info[1],scroll_info[2],scroll_info[3],scroll_info[4],0,"",scroll_info.t_type)
	self._scroll = t_scroll
	t_scroll:registerScriptHandler(bind(scroll_action,self))
    t_scroll:refresh()
    self._pageView:addChild(t_scroll) 

    --"我已消费元宝" (累计消费页才有的)
    local t_layout = GainAwardPageLayout.consumeYuanbaoLabel
	self._yuanbaoLb = ZLabel:create(self._pageView, "", 350, 282, 16)
    
    --我已充值元宝：（累计充值页才有的）
    self.chongzhi_num = ZLabel:create(self._pageView, "", 350, 282, 16)

end

--功能：设置滑动框标题组
--参数：1、itemTitleGroup	滑动框标题组
--返回：无
--作者：陈亮
--时间：2014.09.22
function GainAwardPage:setItemTitleGroup(itemTitleGroup)
	self._itemTitleGroup = itemTitleGroup
end

--功能：设置滑动框奖励组
--参数：1、awardDataGroup	滑动框奖励组
--返回：无
--作者：陈亮
--时间：2014.09.22
function GainAwardPage:setAwardDataGroup(awardDataGroup)
	self._awardDataGroup = awardDataGroup
end

--功能：设置滑动框获取状态组
--参数：1、gainStatusGroup	滑动框获取状态组
--返回：无
--作者：陈亮
--时间：2014.09.22
function GainAwardPage:setGainStatusGroup(gainStatusGroup)
	self._gainStatusGroup = gainStatusGroup
end

--功能：重置滑动框的内容
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function GainAwardPage:resetScroll()
	local t_scrollItemCount = #self._itemTitleGroup
	self._scroll:clear()
	self._scroll:setMaxNum(1)
	self._scroll:refresh()
end

--功能：刷新全部领取按钮状态
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function GainAwardPage:flushAllGainStatus()
	local t_gainStatusCount = #self._gainStatusGroup
	for t_itemIndex = 1,t_gainStatusCount do
		--刷新创建的领取按钮状态
		flush_gain_button_status(self,t_itemIndex)
	end
end

--功能：刷新我的消费元宝数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.12.24
function GainAwardPage:setConsumeYuanbao(yuanbao)
	local desc = Lang.chunjie[4]
	self._yuanbaoLb.view:setText(desc .. yuanbao)
end


function GainAwardPage:setChongzhiYuanbao(yuanbao)
	if yuanbao == nil then
		yuanbao = 0
	end
	local desc = Lang.chunjie[5]
	self.chongzhi_num.view:setText(desc .. yuanbao)
end



--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.19
function GainAwardPage:destroy()
	--获取父类
	local t_pageParent = GainAwardPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.22
function GainAwardPage:gainAward(itemIndex)

end