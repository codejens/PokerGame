--CGotoActivityPage.lua
--内容：跳转活动活动页面基础类
--作者：肖进超
--修改：陈亮
--时间：2014.09.17

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/GotoActivityPageLayout"

--定义常量 
local _COLUMN_MAX_COUNT = 6   --kone 每行最多的奖励格数量

--创建通用信息活动页面基础类
super_class.GotoActivityPage(NormalInfoPage)

--功能：定义跳转活动活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：肖进超
--时间：2014.09.17
local function create_self_params(self)

end

--功能：查看活动按钮点击回调
--参数：self	页面对象
--返回：无
--作者：肖进超
--时间：2014.09.17
local function goto_button_click(self)
	self:gotoButtonAction()
end

--功能：创建每个奖励视图
--参数：1、self			活动页对象
--		2、awardIndex	奖励索引
--		3、awardData	奖励数据
--返回：无
--作者：肖进超
--时间：2014.09.17
local function create_award_view(self,awardIndex,awardData)
	--解析现在的行列位置
	local t_column = (awardIndex - 1) % _COLUMN_MAX_COUNT
	local t_row = (awardIndex - 1) / _COLUMN_MAX_COUNT
	--过滤行数
	t_row = t_row - t_row % 1

	--创建奖励
	local t_awardSlotLayout = GotoActivityPageLayout.awardSlot
	local t_awardX = t_awardSlotLayout.beginX + t_column * t_awardSlotLayout.differX
	local t_awardY = t_awardSlotLayout.beginY - t_row * t_awardSlotLayout.differY
	local t_awardId = awardData.awardId

	print("t_awardId",t_awardId)
	-- local t_awardSlot = ZSlotItem:create(self._pageView,t_awardSlotLayout.bgPath,t_awardX,t_awardY,t_awardSlotLayout.width,t_awardSlotLayout.height,t_awardId)

    local item = MUtils:create_slot_item2(self._pageView,t_awardSlotLayout.bgPath,t_awardX,t_awardY,t_awardSlotLayout.width,t_awardSlotLayout.height,t_awardId,nil,6);
    -- item:set_icon_texture( t_directlyData.iconPath,  -8, -8, 80, 80 )
	item:set_color_frame(t_awardId, -1, -1, 69, 69);
	--如果需要奖励道具特效，设置奖励道具特效
	local t_isEffect = awardData.isEffect
	if t_isEffect then 
		item.view:play_activity_effect()
	end
end

--功能：创建跳转活动活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.09.17
function GotoActivityPage:__init()
	--创建私有变量
	create_self_params(self)

	--创建分割线
	-- local t_dividingLineLayout = GotoActivityPageLayout.dividingLine
	-- ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_dividingLineLayout.y, t_dividingLineLayout.width, t_dividingLineLayout.height)
    
    --创建奖励预览标题
    local award_bg_layout = GotoActivityPageLayout.award_bg
     ZImage:create(self._pageView, award_bg_layout.path, award_bg_layout.x, award_bg_layout.y, award_bg_layout.width, award_bg_layout.height)
	--创建查看活动按钮
	local t_lookButtonLayout = GotoActivityPageLayout.lookButton
	local btn = ZImageButton:create(self._pageView, t_lookButtonLayout.bgPath, "", bind(goto_button_click,self), t_lookButtonLayout.x, t_lookButtonLayout.y, t_lookButtonLayout.width, t_lookButtonLayout.height, 0, 500, 500)
	local  btn_txt = UILabel:create_lable_2(LH_COLOR[2].."立即前往", 0, 0, 16, ALIGN_LEFT ) 
	btn:addChild(btn_txt)
	local btn_size = btn:getSize()
	local txt_size = btn_txt:getSize()
	btn_txt:setPosition(btn_size.width/2 - txt_size.width/2,btn_size.height/2 - txt_size.height/2+3)
end


--功能：创建奖励组视图
--参数：1、awawrdDataGroup	奖励组数据
--返回：无
--作者：肖进超
--时间：2014.09.17
function GotoActivityPage:createAwardGroupView(awawrdDataGroup)
	local t_awardCount = #awawrdDataGroup
	--遍历所有奖励，创建奖励组视图
	for t_awardIndex = 1,t_awardCount do
		local t_awardData = awawrdDataGroup[t_awardIndex]
		create_award_view(self,t_awardIndex,t_awardData)
	end
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.09.17
function GotoActivityPage:destroy()
	--获取父类
	local t_pageParent = GotoActivityPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：查看活动按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.09.17
function GotoActivityPage:gotoButtonAction()
	self:forwardButtonAction()
end