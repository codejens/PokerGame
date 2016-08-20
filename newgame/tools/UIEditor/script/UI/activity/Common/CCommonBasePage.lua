--CCommonBasePage.lua
--内容：通用活动页面基础类
--作者：陈亮
--时间：2014.08.28

--加载活动页面基础类
require "UI/activity/CActivityBasePage"

--加载布局文件
require "../data/layouts/Activity/Common/CommonBasePageLayout"

--创建通用活动页面基础类
super_class.CommonBasePage(ActivityBasePage)

--功能：定义通用活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.08.28
local function create_self_params(self)
	self._titleImage = nil
	self._titleImage_1 = nil
	self._pageType = nil					--页面类型,如果用到，需要在页面上赋值
end

--功能：创建通用活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonBasePage:__init()
	--创建私有变量
	create_self_params(self)

	--设置页面布局
	local t_pageViewLayout = CommonBasePageLayout.pageView
	self:setPageViewImage(t_pageViewLayout.path)
	self:setPagePosition(t_pageViewLayout.x,t_pageViewLayout.y)
	self:setPageSize(t_pageViewLayout.width,t_pageViewLayout.height)

    --标题背景左
    local t_layout = CommonBasePageLayout.leftFlower
    ZImage:create(self._pageView,t_layout.path,t_layout.x,t_layout.y,t_layout.width,t_layout.height,0,500,500)

    -- --标题背景右
    local t_layout = CommonBasePageLayout.rightFlower
    local right_pg = ZImage:create(self._pageView,t_layout.path,t_layout.x,t_layout.y,t_layout.width,t_layout.height,0,500,500)
    right_pg.view:setFlipX(true)


	--创建标题
	-- local t_titleBgLayout = CommonBasePageLayout.titleBg
	-- ZImage:create(self._pageView,t_titleBgLayout.path,t_titleBgLayout.x,t_titleBgLayout.y,t_titleBgLayout.width,t_titleBgLayout.height,0,500,500)
	
   local t_titleLayout = CommonBasePageLayout.title_1
	local t_titleIamge = ZImage:create(right_pg,t_titleLayout.path,t_titleLayout.x-91,t_titleLayout.y,t_titleLayout.width,t_titleLayout.height)
	t_titleIamge.view:setAnchorPoint(0.5,0)
	self._titleImage_1 = t_titleIamge

	local t_titleLayout = CommonBasePageLayout.title
	local t_titleIamge = ZImage:create(right_pg,t_titleLayout.path,t_titleLayout.x,t_titleLayout.y,t_titleLayout.width,t_titleLayout.height)
	t_titleIamge.view:setAnchorPoint(0.5,0)
	self._titleImage = t_titleIamge
end

--功能：设置标题图片路径
--参数：1、titleImagePath	标题图片路径
--		2、titleImageSize	图标大小
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonBasePage:setTitleImagePath(titleImagePath,titleImageSize)
	self._titleImage.view:setTexture(titleImagePath)
	self._titleImage.view:setSize(titleImageSize.width,titleImageSize.height)
end

function CommonBasePage:setTitleImagePath_1(titleImagePath,titleImageSize)
	self._titleImage_1.view:setTexture(titleImagePath)
	if titleImageSize ~=nil then
		self._titleImage_1.view:setSize(titleImageSize.width,titleImageSize.height)
	end
end


--功能：获取页面类型
--参数：无
--返回：1、self._pageType	页面类型
--作者：陈亮
--时间：2014.08.28
function CommonBasePage:getPageType()
	return self._pageType
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonBasePage:destroy()
	--获取父类
	local t_pageParent = CommonBasePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end