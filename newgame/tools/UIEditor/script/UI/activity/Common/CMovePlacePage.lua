--CMovePlacePage.lua
--内容：移动位置活动页面基础类
--作者：陈亮
--时间：2014.08.28

--加载常用信息活动页面基础类
require "UI/activity/Common/CNormalInfoPage"

--加载布局文件
require "../data/layouts/Activity/Common/MovePlacePageLayout"

--定义常量
local _COLUMN_MAX_COUNT = 6

--创建移动位置活动页面基础类
super_class.MovePlacePage(NormalInfoPage)

--功能：定义移动位置活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function create_self_params(self)

end

--功能：前往按钮点击回调
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function forward_button_click(self)
	self:forwardButtonAction()
end

--功能：传送按钮点击回调
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function transform_button_click(self)
	self:transformButtonAction()
end

--功能：创建每个奖励视图
--参数：1、self			活动页对象
--		2、awardIndex	奖励索引
--		3、awardData	奖励数据
--返回：无
--作者：陈亮
--时间：2014.08.28
local function create_award_view(self,awardIndex,awardData)
	--解析现在的行列位置
	local t_column = (awardIndex - 1) % _COLUMN_MAX_COUNT
	local t_row = (awardIndex - 1) / _COLUMN_MAX_COUNT
	--过滤行数
	t_row = t_row - t_row % 1

	-- --创建奖励
	local t_awardSlotLayout = MovePlacePageLayout.awardSlot
	local t_awardX = t_awardSlotLayout.beginX + t_column * t_awardSlotLayout.differX
	local t_awardY = t_awardSlotLayout.beginY - t_row * t_awardSlotLayout.differY
	local t_awardId = awardData.awardId
    local t_awardSlot = MUtils:create_slot_item2(self._pageView,t_awardSlotLayout.bgPath,t_awardX,t_awardY,t_awardSlotLayout.width,t_awardSlotLayout.height,t_awardId,nil,6);
    t_awardSlot:set_color_frame(t_awardId, -1, -1, 69, 69);
	--如果需要奖励道具特效，设置奖励道具特效
	local t_isEffect = awardData.isEffect
	if t_isEffect then 
		t_awardSlot.view:play_activity_effect()
	end
end

--功能：创建移动位置活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function MovePlacePage:__init()
	--创建私有变量
	create_self_params(self)

	--创建分割线
	-- local t_dividingLineLayout = MovePlacePageLayout.dividingLine
	-- ZImage:create(self._pageView, t_dividingLineLayout.path, t_dividingLineLayout.x, t_dividingLineLayout.y, t_dividingLineLayout.width, t_dividingLineLayout.height)

    --创建奖励预览标题
    local award_bg_layout = MovePlacePageLayout.award_bg
     ZImage:create(self._pageView, award_bg_layout.path, award_bg_layout.x, award_bg_layout.y, award_bg_layout.width, award_bg_layout.height)
     
	--创建前往按钮
	local t_forwardButtonLayout = MovePlacePageLayout.forwardButton
    self.forwardbtn = ZImageButton:create(self._pageView, t_forwardButtonLayout.bgPath, t_forwardButtonLayout.imagePath, bind(forward_button_click,self), t_forwardButtonLayout.x, t_forwardButtonLayout.y, t_forwardButtonLayout.width, t_forwardButtonLayout.height, 0, 500, 500)
    local forward_label_layout = MovePlacePageLayout.gotolabel
    local goto_label = UILabel:create_lable_2( LH_COLOR[2]..forward_label_layout.txt, forward_label_layout.x, forward_label_layout.y, 16, ALIGN_LEFT ) -- [544]="#cffff00活跃参与"
    self.forwardbtn:addChild( goto_label )
	--创建传送按钮
	local t_transformButtonLayout = MovePlacePageLayout.transformButton
	self.transformbtn = ZImageButton:create(self._pageView, t_transformButtonLayout.bgPath, t_transformButtonLayout.imagePath, bind(transform_button_click,self), t_transformButtonLayout.x, t_transformButtonLayout.y, t_transformButtonLayout.width, t_transformButtonLayout.height, 0, 500, 500)
    local transform_label_layout = MovePlacePageLayout.transformlabel
    local transform_label = UILabel:create_lable_2( LH_COLOR[2]..transform_label_layout.txt, transform_label_layout.x, transform_label_layout.y, 16, ALIGN_LEFT ) -- [544]="#cffff00活跃参与"
    self.transformbtn:addChild( transform_label )
end

--功能：创建奖励组视图
--参数：1、awawrdDataGroup	奖励组数据
--返回：无
--作者：陈亮
--时间：2014.08.28
function MovePlacePage:createAwardGroupView(awawrdDataGroup)
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
--作者：陈亮
--时间：2014.08.28
function MovePlacePage:destroy()
	--获取父类
	local t_pageParent = MovePlacePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：前往按钮执行的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function MovePlacePage:forwardButtonAction()

end

--功能：传送按钮执行的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function MovePlacePage:transformButtonAction()

end