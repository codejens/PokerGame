--CGroupBuyPage.lua
--内容：团购窗口类
--作者：陈亮
--时间：2014.08.14

--加载布局文件
require "../data/layouts/Activity/SuperGroupBuy/GroupBuyPageLayout"

local panel_page_w = 412
local panel_page_h = 515

-- param 1
local panel_w = 385
local panel_up = 112
local panel_middle = 225
local panel_btm = 145
local panel_align_y = 7
local panel_align_x = 13

-- param 2
local panel_up_y = panel_middle + panel_btm + panel_align_y*3
local panel_middle_y = panel_btm + panel_align_y*3

--创建团购窗口类
super_class.GroupBuyPage()

--功能：定义团购窗口的属性
--参数：1、self		团购窗口对象
--返回：无
--作者：陈亮
--时间：2014.08.14
local function create_self_params(self)
	self._countDownLabel = nil				--活动时间倒计时
	-- self._moneyImage = nil					--团购提示花费图片
	self._progress = nil					--积分进度条
	self._cheapGift = nil					--实惠礼包
	self._cheapBuyButton = nil				--实惠礼包购买按钮
	self._cheapBuyLabel = nil				--实惠礼包购买文本
	self._superGift = nil					--超值礼包
	self._superBuyButton = nil				--超值礼包购买按钮
	self._superBuyLabel = nil				--超值礼包购买文本
	self._pointGift = nil					--积分礼包
	self._giftGainButton = nil				--积分礼包获取按钮
	self._giftGainLabel = nil				--积分礼包获取文本
	self._myPointLabel = nil				--我的积分文本
	self._crossTipLabel = nil				--提示文本
	self._openTipLabel = nil				--开放购买文本
end

--功能：剩余时间倒计时结束回调函数
--参数：1、self			团购窗口对象
--返回：无
--作者：陈亮
--时间：2014.08.19
local function count_down_end_callback(self)
	self._countDownLabel:setString(Lang.SuperGBuy[15])
end

--功能：礼包购买回调函数
--参数：1、giftIndex	礼包索引
--返回：无
--作者：陈亮
--时间：2014.08.19
local function buy_button_click_callback(giftIndex)
	SuperGroupBuyModel:buyGroupBuyGift(giftIndex)
end

--功能：积分礼包领取回调函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
local function gain_gift_click_callback()
	SuperGroupBuyModel:gainPointGift()
end

--功能：创建礼包组视图
--参数：1、self			团购窗口对象
--		2、panel		父节点
--		3、giftIndex	礼包索引
--返回：无
--作者：陈亮
--时间：2014.08.19
local btn_x = {36, 255}
local function create_gift_view_group(self,panel,giftIndex)

	local item_w = 125
	local item_h = 193
	local item_px = 20
	local item_py = 20
	local title_path = UILH_MAINACTIVITY.tg_shlb
	
	--判断左右礼包来获取对应的布局
	local t_giftViewGroupLayout = nil
	if giftIndex == 1 then
		t_giftViewGroupLayout = GroupBuyPageLayout.cheapGiftViewGroupLayout
	else
		t_giftViewGroupLayout = GroupBuyPageLayout.superGiftViewGroupLayout
		title_path = UILH_MAINACTIVITY.tg_czlb
		item_px = 240
	end

	-- 整个item
	local gift_item = CCBasePanel:panelWithFile( item_px, item_py, item_w, item_h, "")
	panel:addChild(gift_item)

	--background
	local item_bg = CCBasePanel:panelWithFile( 0, item_h, item_h, item_w, UILH_NORMAL.title_bg4, 500, 500 )
	item_bg:setRotation(90)
	gift_item:addChild(item_bg)

	--创建礼包标题背景
	local title_bg = ZImage:create(gift_item, UILH_NORMAL.level_bg, 20, 160, -1, -1 )

	--礼包标题
	local t_giftTitleLayout = t_giftViewGroupLayout.giftTitle
	ZImage:create( title_bg, title_path, 10, 7, -1, -1 )

	-- 超级礼包背景
	if giftIndex == 2 then
		ZImage:create(gift_item, UILH_NORMAL.light_grid, 17, 62, -1, -1 )
	end
	--创建礼包
	local t_gift = MUtils:create_slot_item( gift_item, UILH_COMMON.slot_bg, 25, 70, 83, 83)

	--创建礼包购买按钮
	local t_buyButton = ZButton:create( self.view, UILH_COMMON.lh_button_4_r, bind(buy_button_click_callback,giftIndex),
					btn_x[giftIndex], 180, -1, -1 )
	t_buyButton:addImage(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)

	--创建礼包购买文字
	-- local t_buyLabelLayout = t_giftViewGroupLayout.buyLabel
	local t_buyLabel = ZLabel:create(t_buyButton,"", 121*0.5, (53-16)*0.5, 16, ALIGN_CENTER)

	--判断如果是1，保存实惠礼包的视图，如果是2，保存超值礼包的视图
	if giftIndex == 1 then
		self._cheapGift = t_gift
		self._cheapBuyButton = t_buyButton
		self._cheapBuyLabel = t_buyLabel
	else
		self._superGift = t_gift
		self._superBuyButton = t_buyButton
		self._superBuyLabel = t_buyLabel
	end
end

--功能：创建团购窗口对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.14
function GroupBuyPage:__init()
	--声明成员变量
	create_self_params(self)

	-- 背景图
	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_page_w, panel_page_h).view

	-- up ====================================
	local pnl_up = ZImage:create(self.view, UILH_COMMON.bottom_bg, panel_align_x, panel_up_y, panel_w, panel_up, 0, 500, 500)
	self.pnl_up_ex = pnl_up
	--团购提示内容
	-- local main_tip = SuperGroupBuyModel:get_ui_main_tip()

	ZImage:create(pnl_up, UILH_MAINACTIVITY.everyday, 29, 55, -1, -1)
	ZImage:create(pnl_up, UILH_MAINACTIVITY.big_award, 185, 55, -1, -1)
	-- 更改，数字与元宝分开
	self.yb_num = ZXLabelAtlas:createWithString( 158, "ui/lh_other/number2_" )
    self.yb_num:setPosition(CCPointMake( 135, 55) )
    self.yb_num:setAnchorPoint( CCPointMake(1, 0) )
    pnl_up:addChild( self.yb_num)
    self.yb_text = ZImage:create(nil, UILH_PAY.yb_t, 135, 55, -1, -1)
	self.yb_text:setAnchorPoint(0, 0)
	pnl_up:addChild( self.yb_text)


	-- self._moneyImage = ZImage:create(pnl_up, UILH_MAINACTIVITY.tg_everyday, 29, 50, -1, -1)
	ZLabel:create(pnl_up, LH_COLOR[1] .. Lang.SuperGBuy[4], 30, 20, 16) 
	--活动倒计时
	-- local t_countDownLayout = GroupBuyPageLayout.countDown
	local t_countDownLabel = TimerLabel:create_label(pnl_up, 180, 20, 16, 0, "", bind(count_down_end_callback,self), false, ALIGN_LEFT,false)
	self._countDownLabel = t_countDownLabel

	-- Middle ===============================
	local pnl_middle = ZBasePanel:create(self.view, UILH_COMMON.bottom_bg, panel_align_x, panel_middle_y-2, panel_w, panel_middle, 0, 500, 500)
	-- 2个礼包
	for giftIndex = 1,2 do
		create_gift_view_group(self, pnl_middle, giftIndex)
	end
	-- 箭头
	ZImage:create( pnl_middle, UILH_COMMON.right_arrows, 170, 80, -1, -1)
	-- 文字
	-- local buy_txt = SuperGroupBuyModel:get_buy_txt( )
	local t_crossTipLabel = ZDialog:create( pnl_middle, LH_COLOR[2] .. "", 147, 170, 100, 60, 12, nil)
	t_crossTipLabel.view:setAnchorPoint(0,1)
	self._crossTipLabel = t_crossTipLabel

	-- bottom ==============================
	local pnl_btm = ZBasePanel:create(self.view, UILH_COMMON.bottom_bg, panel_align_x, panel_align_y+10, panel_w, panel_btm, 0, 500, 500)
	ZLabel:create(pnl_btm, LH_COLOR[1] .. Lang.SuperGBuy[5], 10, 100, 16) 
	--创建进度条
	local t_progress = MUtils:create_progress_bar( 23, 65, 215, 20, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_orange, 100, {14,nil}, {3,3,3,3}, false)
	pnl_btm:addChild(t_progress)
    t_progress.set_current_value(0)	--设置默认值
	self._progress = t_progress
	--创建我的积分
	self._openTipLabel = ZLabel:create(pnl_btm, LH_COLOR[2] .. Lang.SuperGBuy[6], 20, 30, 16)
	self._myPointLabel = ZLabel:create(pnl_btm,"0", 120, 30, 16) 

	-- 右侧
	local award_item = CCBasePanel:panelWithFile( 260, 20, 105, 125, "")
	pnl_btm:addChild(award_item)
	-- 背景
	-- local item_bg = CCBasePanel:panelWithFile( 0, 125, 105, 125, UILH_NORMAL.title_bg4, 500, 500 )
	-- item_bg:setRotation(90)
	-- award_item:addChild(item_bg)

	--创建积分的礼包
	-- self._pointGift = ZSlotItem:create(t_backGround,t_pointGiftLayout.bgPath,t_pointGiftLayout.x,t_pointGiftLayout.y,t_pointGiftLayout.width,t_pointGiftLayout.height)
	self._pointGift = MUtils:create_slot_item( award_item, UILH_COMMON.slot_bg, 18, 38, 83, 83)
	-- 需要2积分
	-- self._needPoint = ZLabel:create(award_item, LH_COLOR[15] .. "需要2积分", 15, -5, 16) 

	-- 创建需要领取按钮
	-- local t_pointButtonLayout = GroupBuyPageLayout.pointButton
	local t_giftGainButton = ZButton:create( self.view, UILH_COMMON.btn4_nor, gain_gift_click_callback, 270, 20,-1, -1 )
	t_giftGainButton:addImage(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
	self._giftGainButton = t_giftGainButton

	-- local t_giftGainLabelLayout = GroupBuyPageLayout.giftGainLabel
	self._giftGainLabel = ZLabel:create(t_giftGainButton, "", 121*0.5, (53-16)*0.5, 16, ALIGN_CENTER)
	-- self._giftGainButton.view:setIsVisible(false)
end

function GroupBuyPage:update( updateType )
	SuperGroupBuyModel:openGroupBuyWin()

end

--功能：根据实惠礼包ID设置实惠礼包
--参数：1、cheapGiftId	实惠礼包ID
--返回：无
--作者：陈亮
--时间：2014.08.18
function GroupBuyPage:setCheapGiftId(cheapGiftId)
	self._cheapGift:set_icon(cheapGiftId)
	self._cheapGift:set_color_frame(cheapGiftId, -4, -4, 66, 66);
	local function item_tips_fun(...)
		print("---------time", cheapGiftId)
		local a, b, arg = ...
		local click_pos = Utils:Split(arg, ":")
		local world_pos = self._pointGift.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		if cheapGiftId ~= 0 then
			TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, cheapGiftId )
		end
	end
	self._cheapGift:set_click_event(item_tips_fun)
end

--功能：根据超值礼包ID设置超值礼包
--参数：1、superGiftId	超值礼包ID
--返回：无
--作者：陈亮
--时间：2014.08.18
function GroupBuyPage:setSuperGiftId(superGiftId)
	self._superGift:set_icon(superGiftId)
	self._superGift:set_color_frame(superGiftId, -4, -4, 66, 66);
print("---------time:点击事件无效")
	local function item_tips_fun(...)
		local a, b, arg = ...
		local click_pos = Utils:Split(arg, ":")
		local world_pos =self._pointGift.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		if superGiftId ~= 0 then
			TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, superGiftId )
		end
	end
	self._superGift:set_click_event(item_tips_fun)
end

--功能：根据积分礼包ID设置积分礼包
--参数：1、pointGiftId	积分礼包ID
--返回：无
--作者：陈亮
--时间：2014.08.18
function GroupBuyPage:setPointGiftId(pointGiftId)
	self._pointGift:set_icon(pointGiftId)
	self._pointGift:set_color_frame(pointGiftId, -4, -4, 66, 66);
	local function item_tips_fun(...)
		print("------------------点击事件无效")
		local a, b, arg = ...
		local click_pos = Utils:Split(arg, ":")
		local world_pos = self._pointGift.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		if pointGiftId ~= 0 then
			TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, pointGiftId )
		end
	end
	self._pointGift:set_click_event(item_tips_fun)
end

--功能：设置实惠礼包购买内容
--参数：1、content	实惠礼包购买内容
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setCheapBuyContent(content)
	self._cheapBuyLabel:setText( LH_COLOR[2] .. content)
end

--功能：设置超值礼包购买内容
--参数：1、content	实惠礼包购买内容
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setSuperBuyContent(content)
	self._superBuyLabel:setText( LH_COLOR[2] .. content)
end

--功能：设置领取礼包内容
--参数：1、content	领取礼包内容
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setGiftGainContent(content)
	self._giftGainLabel:setText(content)
end

--功能：设置活动剩余时间
--参数：1、remainTime	活动剩余时间
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setRemainTime(remainTime)
	self._countDownLabel:setText(remainTime)
end

--功能：设置积分进度条最大值
--参数：1、max	积分进度条最大值
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setProgressMax(max)
	self._progress.set_max_value(max)
end

--功能：设置积分进度条当前值
--参数：1、current	积分进度条当前值
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setProgressCurrent(current)
	self._progress.set_current_value(current)
end

--功能：设置我的活动积分
--参数：1、point	我的活动积分
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setMyPoint(point)
	self._myPointLabel:setText(point)
end

--功能：设置元宝图片路径
--参数：1、moneyImagePath	元宝图片路径
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:setMoneyImagePath(moneyImagePath,imageSize, t_moneyNum)
	-- self._moneyImage.view:setTexture(moneyImagePath)
	-- self._moneyImage.view:setSize(imageSize.width,imageSize.height)

	if self.yb_num then
		self.yb_num:removeFromParentAndCleanup(true)
		self.yb_num = nil
	end
	self.yb_num = ZXLabelAtlas:createWithString( t_moneyNum, "ui/lh_other/number2_" )
    self.yb_num:setPosition(CCPointMake( 135, 55) )
    self.yb_num:setAnchorPoint( CCPointMake(1, 0) )
    self.pnl_up_ex:addChild( self.yb_num)
end

--功能：设置提示内容
--参数：1、tipContent	提示内容
--返回：无
--作者：陈亮
--时间：2014.12.30
function GroupBuyPage:setBuyTipContent(tipContent)
	-- self._crossTipLabel:setText(tipContent)
end

--功能：显示购买提示
--参数：无
--返回：无
--作者：陈亮
--时间：2014.12.31
function GroupBuyPage:showBuyTip()
	self._crossTipLabel.view:setIsVisible(true)
end

--功能：隐藏购买提示
--参数：无
--返回：无
--作者：陈亮
--时间：2014.12.31
function GroupBuyPage:hideBuyTip()
	-- self._crossTipLabel.view:setIsVisible(false)
end

--功能：显示开放提示
--参数：无
--返回：无
--作者：陈亮
--时间：2014.12.31
function GroupBuyPage:showOpenTip()
	self._openTipLabel.view:setIsVisible(true)
end

--功能：隐藏开放提示
--参数：无
--返回：无
--作者：陈亮
--时间：2014.12.31
function GroupBuyPage:hideOpenTip()
	self._openTipLabel.view:setIsVisible(true)
end


--功能：设置超值礼包购买按钮不可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:unclickedSuperBuyButton()
	self._superBuyButton.view:setCurState(CLICK_STATE_DISABLE)
end

--功能：设置超值礼包购买按钮可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:clickedSuperBuyButton()
	self._superBuyButton.view:setCurState(CLICK_STATE_UP)
end

--功能：设置实惠礼包购买按钮不可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:unclickedCheapBuyButton()
	self._cheapBuyButton.view:setCurState(CLICK_STATE_DISABLE)
end

--功能：设置实惠礼包购买按钮可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:clickedCheapBuyButton()
	print("-----------------clickedCheapBuyButton:", clickedCheapBuyButton)
	self._cheapBuyButton.view:setCurState(CLICK_STATE_UP)
end

--功能：设置积分礼包领取按钮不可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:unclickedGiftGainButton()
	self._giftGainButton.view:setCurState(CLICK_STATE_DISABLE)
end

--功能：设置积分礼包领取按钮可点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.19
function GroupBuyPage:clickedGiftGainButton()
	self._giftGainButton.view:setCurState(CLICK_STATE_UP)
end

--功能：窗口是否显示
--参数：1、status	窗口状态
--返回：无
--作者：陈亮
--时间：2014.08.18
function GroupBuyPage:active(status)
	--打开窗口
	-- if status then
	-- 	SuperGroupBuyModel:openGroupBuyPage()
	-- --关闭窗口
	-- else
	-- 	SuperGroupBuyModel:closeActivityWin()
	-- end
end

--功能：团购窗口对象的析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.14
function GroupBuyPage:destroy()
	--销毁时间控件
	if self._countDownLabel then
		self._countDownLabel:destroy()
	end
end

-- 设置团购中间描述的数量
function GroupBuyPage:set_buy_txt( txt )
	self._crossTipLabel:setText( txt)
end