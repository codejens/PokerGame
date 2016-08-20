--SMGroupBuyPage.lua
--内容：超级团购活动页面类
--作者：肖进超
--时间：2014.10.29

--加载超级团购页面类
-- require "UI/activity/Common/CGroupBuyPage"
--加载跳转活动页面类
require "UI/activity/Common/CGotoActivityPage"

--创建超级团购活动页面类
super_class.SMGroupBuyPage(GotoActivityPage)

--功能：定义超级团购活动页面的基础属性
--参数：self	超级团购活动页面对象
--返回：无
--作者：肖进超
--时间：2014.10.29
local function create_self_params(self)

end

--功能：创建超级团购活动页面的基础初始化函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function SMGroupBuyPage:__init()
	--创建私有变量
	create_self_params(self)

	-- 团购界面(天将雄狮, 界面结构不符合规范，自行处理，在此处修改)
	self:create_panel_ud( self._pageView )
end

-- 团购自定义界面排版
function SMGroupBuyPage:create_panel_ud( panel )
	-- body
	self.panel_base = CCBasePanel:panelWithFile(0, 75, 580, 190, "")
	panel:addChild(self.panel_base)

	-- 当前积分
	ZLabel:create( self.panel_base, LH_COLOR[2] .. "当前积分:", 500, 230, 16, ALIGN_RIGHT )
	self.point_mine = ZLabel:create( self.panel_base, LH_COLOR[2] .. "0", 510, 230, 16, ALIGN_LEFT )

	-- 展示item
	local items_conf = SuperGroupBuyConfig:getConfigNewYear(CommonActivityConfig.SummerDay)
	for i=1, 2 do
		local panel_item = self:create_slot_items(i, items_conf[i])
		panel_item:setPosition( 20+275*(i-1), 0 )
		self.panel_base:addChild(panel_item)
	end
end

-- 团购自定义界面排版item
function SMGroupBuyPage:create_slot_items(giftIndex, items_conf)
	local title_path = UILH_MAINACTIVITY.tg_shlb
	if giftIndex == 2 then
		title_path = UILH_MAINACTIVITY.tg_czlb
	end

	local items_bg = CCBasePanel:panelWithFile(0, 0, 290, 190, "")
		
	--background
	local item_bg = CCBasePanel:panelWithFile( 65, 205, 130, 150, UILH_NORMAL.title_bg4 )
	item_bg:setRotation(90)
	items_bg:addChild(item_bg)

	-- 礼包
	local t_gift = MUtils:create_slot_item2( items_bg, UILH_COMMON.slot_bg, 105, 120, 67, 67, items_conf[1].id, nil, 6)
	t_gift:set_color_frame(items_conf[1].id, -1, -1, 69, 69 )
	t_gift:set_item_count(items_conf[1].count)

	-- 超级礼包背景
	if giftIndex == 2 then
		ZImage:create(t_gift, UILH_NORMAL.light_grid, -13, -13, -1, -1 )
	end

	--创建礼包标题背景
	local title_bg = ZImage:create(items_bg, UILH_NORMAL.level_bg, 95, 75, -1, -1 )

	-- --礼包标题
	ZImage:create( title_bg, title_path, 10, 7, -1, -1 )

	for i=2, 3 do
		local item_lttl = MUtils:create_slot_item2( items_bg, UILH_COMMON.slot_bg, 48+115*(i-2), 5, 67, 67, items_conf[i].id, nil, 6)
		item_lttl:set_color_frame(items_conf[i].id, -1, -1, 69, 69 )
		item_lttl:set_item_count(items_conf[i].count)
	end

	return items_bg
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function SMGroupBuyPage:destroy()
	--获取父类
	local t_pageParent = SMGroupBuyPage.super
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
function SMGroupBuyPage:showPageAction()
	SummerDayModel:showLDGroupBuyPage(self._isInit)
	--请求团购活动信息
	OnlineAwardCC:reqGroupBuyInfo()
end

--功能：实惠礼包前往按钮执行的行为动作
--参数：无
--返回：无
--作者：肖进超
--时间：2014.10.29
function SMGroupBuyPage:forwardButtonAction()
	ValentineWhiteDayModel:openGroupBuyActivityWin()
end

function SMGroupBuyPage:setMyPoint( point )
	self.point_mine.view:setText(LH_COLOR[2] .. point)
end