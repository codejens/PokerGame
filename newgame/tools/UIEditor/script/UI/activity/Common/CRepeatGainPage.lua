 --CRepeatGainPage.lua
--内容：重复获取活动页面基础类
--作者：陈亮
--时间：2014.08.29

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/RepeatGainPageLayout"

--创建重复获取活动页面基础类
super_class.RepeatGainPage(NormalInfoPage)

--功能：定义重复获取活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.29
local function create_self_params(self)
	self._countLabel = nil
	self._gainAllAwardButton = nil 
	self._gainAwardButton = nil
end

--功能：领取全部奖励按钮点击函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
local function gain_all_award_button_click(self)
	self:gainAllAward()
end

--功能：领取奖励按钮点击函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
local function gain_award_button_click(self)
	self:gainAward()
end

--功能：创建每个奖励视图
--参数：1、self			活动页对象
--		2、awardIndex	奖励索引
--		3、awardData	奖励数据
--返回：无
--作者：陈亮
--时间：2014.08.29
local function create_award_view(self,awardIndex,awardData)
	--创建奖励
	local t_awardSlotLayout = RepeatGainPageLayout.awardSlot
	local t_awardX = t_awardSlotLayout.beginX + (awardIndex - 1) * t_awardSlotLayout.differX
	local t_awardId = awardData.awardId
	local t_awardSlot = ZSlotItem:create(self._pageView,t_awardSlotLayout.bgPath,t_awardX,t_awardSlotLayout.y,t_awardSlotLayout.width,t_awardSlotLayout.height,t_awardId)

	--如果需要奖励道具特效，设置奖励道具特效
	local t_isEffect = awardData.isEffect
	if t_isEffect then 
		t_awardSlot.view:play_activity_effect()
	end

	--设置数量
	local t_count = awardData.count
	t_awardSlot.view:set_item_count(t_count)
end

--功能：创建重复获取活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:__init()
	--创建私有变量
	create_self_params(self)

	--创建活动预览标题
	local t_previewBgLayout = RepeatGainPageLayout.previewBg
	ZImage:create(self._pageView, t_previewBgLayout.path, t_previewBgLayout.x, t_previewBgLayout.y, t_previewBgLayout.width, t_previewBgLayout.height,0,500,500)
	local t_previewTitleLayout = RepeatGainPageLayout.previewTitle
	ZImage:create(self._pageView, t_previewTitleLayout.path, t_previewTitleLayout.x, t_previewTitleLayout.y, t_previewTitleLayout.width, t_previewTitleLayout.height,0,500,500)

	--创建全部领取按钮
	local t_gainAllAwardButtonLayout = RepeatGainPageLayout.gainAllAwardButton
	local t_gainAllAwardButton = ZImageButton:create(self._pageView, t_gainAllAwardButtonLayout.bgPath, t_gainAllAwardButtonLayout.imagePath,bind(gain_all_award_button_click,self), t_gainAllAwardButtonLayout.x, t_gainAllAwardButtonLayout.y, t_gainAllAwardButtonLayout.width, t_gainAllAwardButtonLayout.height, 0, 500, 500)
	t_gainAllAwardButton.btn:addImage(CLICK_STATE_DISABLE,t_gainAllAwardButtonLayout.disPath)
	self._gainAllAwardButton = t_gainAllAwardButton

	--创建分割线
	local t_dividingLineLayout = RepeatGainPageLayout.dividingLine
	ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_dividingLineLayout.y, t_dividingLineLayout.width, t_dividingLineLayout.height)

	--创建数量标题
	local t_countTitleLayout = RepeatGainPageLayout.countTitle
	ZLabel:create(self._pageView,t_countTitleLayout.content, t_countTitleLayout.x, t_countTitleLayout.y, t_countTitleLayout.fontSize)

	--创建数量文本
	local t_countLayout = RepeatGainPageLayout.count
	self._countLabel = ZLabel:create(self._pageView,t_countLayout.content, t_countLayout.x, t_countLayout.y, t_countLayout.fontSize)

	--创建领取按钮
	local t_gainAwardButtonLayout = RepeatGainPageLayout.gainAwardButton
	local t_gainAwardButton = ZImageButton:create(self._pageView, t_gainAwardButtonLayout.bgPath, t_gainAwardButtonLayout.imagePath,bind(gain_award_button_click,self), t_gainAwardButtonLayout.x, t_gainAwardButtonLayout.y, t_gainAwardButtonLayout.width, t_gainAwardButtonLayout.height, 0, 500, 500)
	t_gainAwardButton.btn:addImage(CLICK_STATE_DISABLE,t_gainAwardButtonLayout.disPath)
	self._gainAwardButton = t_gainAwardButton
end

--功能：创建奖励组视图
--参数：1、awawrdDataGroup	奖励组数据
--返回：无
--作者：陈亮
--时间：2014.08.28
function RepeatGainPage:createAwardGroupView(awawrdDataGroup)
	local t_awardCount = #awawrdDataGroup
	--遍历所有奖励，创建奖励组视图
	for t_awardIndex = 1,t_awardCount do
		local t_awardData = awawrdDataGroup[t_awardIndex]
		create_award_view(self,t_awardIndex,t_awardData)
	end
end

--功能：设置获取全部奖励按钮不可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:unclickedGainAllAwardButton()
	self._gainAllAwardButton.view:setCurState(CLICK_STATE_DISABLE)
end

--功能：设置获取全部奖励按钮可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:clickedGainAllAwardButton()
	self._gainAllAwardButton.view:setCurState(CLICK_STATE_UP)
end

--功能：设置获取奖励按钮不可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:unclickedGainAwardButton()
	self._gainAwardButton.view:setCurState(CLICK_STATE_DISABLE)
end

--功能：设置获取奖励按钮可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:clickedGainAwardButton()
	self._gainAwardButton.view:setCurState(CLICK_STATE_UP)
end

--功能：设置可领取数量
--参数：1、count	可领取数量
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:setGainAwardCount(count)
	self._countLabel:setText(count)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:destroy()
	--获取父类
	local t_pageParent = RepeatGainPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：获取全部奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:gainAllAward()

end

--功能：获取奖励的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function RepeatGainPage:gainAward()

end