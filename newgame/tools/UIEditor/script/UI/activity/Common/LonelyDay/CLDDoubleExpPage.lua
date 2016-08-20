--CLDDoubleExpPage.lua
--内容：光棍节-天降宝箱页面类
--作者：肖进超
--时间：2014.10.29

--加载移动位置页面类
require "UI/activity/Common/CNormalInfoPage"

--创建光棍节天降宝箱页面类
super_class.LDDoubleExpPage(NormalInfoPage)

--功能：定义光棍节天降宝箱页面的基础属性
--参数：self	光棍节天降宝箱页面对象
--返回：无
--作者：肖进超
--时间：2014.10.29
local function create_self_params(self)

end

--功能：创建光棍节天降宝箱页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDDoubleExpPage:__init()
	--创建私有变量
	create_self_params(self)

	-- 添加 (活动预览 & 道具框)
	ZImage:create(self._pageView, "ui/lh_openser/tips.png", 5, 272, -1, -1)
	self:create_describe( self._pageView )
end

function LDDoubleExpPage:create_describe( panel )
	self.panel_desc = CCBasePanel:panelWithFile( 10, 35, 580, 220, UILH_COMMON.bottom_bg, 500, 500 )
	panel:addChild(self.panel_desc)
	self.desc = CCDialogEx:dialogWithFile( 20, 200, 540, 200, 13, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.desc:setAnchorPoint(0,1);
    self.desc:setFontSize(16);
    self.desc:setText( LH_COLOR[2] .. LonelyDayModel:getDoubleExpDesc() );  -- "#cffff00当前效果:#cffffff:"
    self.desc:setTag(0)
    self.desc:setLineEmptySpace (15)
    self.panel_desc:addChild(self.desc)
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDDoubleExpPage:destroy()
	--获取父类
	local t_pageParent = LDDoubleExpPage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示页面的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDDoubleExpPage:showPageAction()
	LonelyDayModel:showLDDoubleExpPage(self._isInit)
end

--功能：前往按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDDoubleExpPage:forwardButtonAction()
    -- LonelyDayModel:forwardPlace()
end

--功能：传送按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function LDDoubleExpPage:transformButtonAction()
    -- LonelyDayModel:transformPlace()
end