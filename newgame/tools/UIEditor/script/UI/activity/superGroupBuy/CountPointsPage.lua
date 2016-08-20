--CCountPointsPage.lua
--内容：团购积分窗口类
--作者：陈亮
--时间：2014.08.14

--加载布局文件
require "../data/layouts/Activity/SuperGroupBuy/CountPointsPageLayout"

--创建团购积分窗口类
super_class.CountPointsPage()

local panel_page_w = 412
local panel_page_h = 515

-- param 1
local panel_w = 385
local panel_align_y = 7
local panel_align_x = 13

-- 字体大小
local fontSize_1 = 16
local btm_word_y = 30

--定义常量
local _QUEUE_MAX_COUNT = 3 									--排行榜最大数量

--功能：定义团购积分窗口的属性
--参数：1、self		团购积分窗口对象
--返回：无
--作者：陈亮
--时间：2014.08.14
local function create_self_params(self)
	self._guildNameLabelGroup = {nil,nil,nil}				--排行榜的仙宗名称文本组
	self._guildPointsLabelGroup = {nil,nil,nil}				--排行榜的仙宗积分文本组
	self._awardGroup = {nil,nil,nil}						--排行榜的奖励组
	self._myGuildPointLabel = nil							--我的仙宗积分文本
	self._myGuildQueueLabel = nil							--我的仙宗排行文本
end

--功能：弹出描述按钮的点击回调
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.14
local function describe_button_click_callback()
	SuperGroupBuyModel:showQueueDescirbe()
end

--功能：创建排行行组视图
--参数：1、self			积分窗口对象
--		2、panel		父节点
--		3、index		行索引
--返回：无
--作者：陈亮
--时间：2014.08.19
local function create_queue_item(self,panel,index)
	local x = 9
	local beginY = 325
	local differY = 130
	local width = 53
	local height = 48
	--创建排名
	local t_queueLayout = CountPointsPageLayout.queue
	--计算Y纵坐标
	local t_queueY = beginY - differY * (index - 1)

	local panel_base = ZBasePanel:create(self.view, "", panel_align_x, t_queueY, panel_w, 130)

	-- 获取图片路径
	self.indexLbl = ZXLabelAtlas:createWithString( index, "ui/lh_other/number2_" )
	self.indexLbl:setPosition(CCPointMake( 20, 55) )
    self.indexLbl:setAnchorPoint( CCPointMake(0, 0) )
    panel_base:addChild( self.indexLbl )

	-- 公会名称
	self._guildNameLabelGroup[index] = ZLabel:create(panel_base, Lang.SuperGBuy[7], 55, 60, 16) 
 
	-- 公会积分
	self._guildPointsLabelGroup[index] = ZLabel:create(panel_base, Lang.SuperGBuy[8], 200, 60, 16) 

	-- 奖励背景框 && 奖励
	ZBasePanel:create(panel_base, UILH_NORMAL.light_grid, 272, 17, -1, -1 )
	self._awardGroup[index] = MUtils:create_slot_item(panel_base, UILH_COMMON.slot_bg, 280, 25, 83, 83)

	--创建分割线
	ZImage:create(panel_base, UILH_COMMON.split_line, 10, 1, panel_w-20, 3, 0)
end

--功能：创建团购积分窗口对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.14
function CountPointsPage:__init()
	--声明成员变量
	create_self_params(self)

	-- 背景图
	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_page_w, panel_page_h).view
	--创建背景图
	-- local self.viewLayout = CountPointsPageLayout.backGround
	ZBasePanel:create(self.view, UILH_COMMON.bottom_bg, panel_align_x, 60, panel_w, 440, 0,500,500)

	--创建排行标题
	-- local t_queueTitleLayout = CountPointsPageLayout.t_queueTitle
	local title_bg = ZBasePanel:create(self.view, UILH_NORMAL.title_bg4, 10, panel_page_h-55, panel_w, -1 )
	ZLabel:create( title_bg, LH_COLOR[1] .. Lang.SuperGBuy[9], panel_w*0.5, 10, fontSize_1, ALIGN_CENTER)

	-- --创建排行列表
	for index = 1,3 do
		create_queue_item(self, self.view, index)
	end

	--创建我的公会积分标题
	ZLabel:create(self.view, LH_COLOR[2] .. Lang.SuperGBuy[10], 190, btm_word_y, fontSize_1, ALIGN_RIGHT)
	-- 我的公会积分
	self._myGuildPointLabel = ZLabel:create(self.view, "0", 190, btm_word_y, fontSize_1, ALIGN_LEFT)

	--创建当前排名标题
	ZLabel:create(self.view, LH_COLOR[2] .. Lang.SuperGBuy[11], panel_w*0.88 , btm_word_y, fontSize_1, ALIGN_RIGHT)

	--创建当前排名
	self._myGuildQueueLabel = ZLabel:create(self.view,"0", panel_w*0.9, btm_word_y, fontSize_1, ALIGN_LEFT)

	--创建排行描述按钮(团购说明)
	-- ZButton:create(self.view, UILH_NORMAL.wenhao, describe_button_click_callback, panel_w*0.9, btm_word_y-10, -1, -1 )
end

--功能：设置我的仙宗排名
--参数：1、myGuildQueue		我的仙宗排名
--返回：无
--作者：陈亮
--时间：2014.08.18
function CountPointsPage:setMyGuildQueue(myGuildQueue)
	print("--------myGuildQueue:", myGuildQueue)
	self._myGuildQueueLabel:setText(myGuildQueue)
end

--功能：设置我的仙宗积分
--参数：1、myGuildPoint	我的仙宗积分
--返回：无
--作者：陈亮
--时间：2014.08.18
function CountPointsPage:setMyGuildPoint(myGuildPoint)
	self._myGuildPointLabel:setText(myGuildPoint .. Lang.SuperGBuy[12])
end

--功能：根据排行索引和数据更新积分排行榜
--参数：1、queueIndex		排行索引
--		2、queueItemData	排行数据
--返回：无
--作者：陈亮
--时间：2014.08.18
function CountPointsPage:setPointQueueInfo(queueIndex,queueItemData)
	--设置仙宗名称
	local t_guildNameLabel = self._guildNameLabelGroup[queueIndex]
	local t_guildName = queueItemData.guildName
	t_guildNameLabel:setText(t_guildName)
	--设置仙宗积分
	local t_guildPointLabel = self._guildPointsLabelGroup[queueIndex]
	local t_guildPoint = queueItemData.guildPoint
	t_guildPointLabel:setText(t_guildPoint)
end

--功能：根据排行索引和数据更新积分排行榜
--参数：1、queueIndex	排行索引
--		2、queueData	排行数据
--返回：无
--作者：陈亮
--时间：2014.08.18
function CountPointsPage:setQueueAwardInfo(queueIndex,awardId)
	--设置奖励ID
	local t_award = self._awardGroup[queueIndex]
	t_award:set_icon(awardId)
	t_award:set_color_frame(awardId, -4, -4, 66, 66);
	local function item_tips_fun(...)
		local a, b, arg = ...
		local click_pos = Utils:Split(arg, ":")
		local world_pos = t_award.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		if awardId ~= 0 then
			TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, awardId )
		end
	end
	t_award:set_click_event(item_tips_fun)
end

--功能：清除排行榜数据
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.20
function CountPointsPage:clearQueueData()
	--遍历排行榜视图，清楚公会名称和公会积分的数据
	for t_index = 1,_QUEUE_MAX_COUNT do
		local t_guildName = self._guildNameLabelGroup[t_index]
		t_guildName:setText("")
		local t_guildPoints = self._guildPointsLabelGroup[t_index]
		t_guildPoints:setText("")
	end
end

-- update更新界面
function CountPointsPage:update( updateType )
	SuperGroupBuyModel:openCountPointWin()
end

--功能：窗口是否显示
--参数：1、status	窗口状态
--返回：无
--作者：陈亮
--时间：2014.08.18
function CountPointsPage:active(status)
	--打开窗口
	-- if status then
	-- 	SuperGroupBuyModel:openCountPointWin()
	-- --关闭窗口
	-- else
	-- 	SuperGroupBuyModel:closeActivityWin()
	-- end
end

--功能：团购积分窗口对象的析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.14
function CountPointsPage:destroy()
	
end
