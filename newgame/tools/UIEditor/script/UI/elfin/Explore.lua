-- Explore.lua
-- created by yongrui.liang on 2014-8-25
-- 式神探险页面

super_class.Explore()

local _getAwardTimer = nil

function Explore:__init( )
	_getAwardTimer = callback:new()

	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	-- 上面板
    local upPanel = self:createUpPanel(320, 340)
    upPanel:setPosition(10, 215)
    panel:addChild(upPanel)

    -- 下面板
    local dwnPanel = self:createDwnPanel(320, 200)
    dwnPanel:setPosition(10, 0)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function Explore:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	self.explore = {}
	-- 普通探险
	self.easyExplore = self:createExplorePanel(1, "ui/elfin/29.png", "ui/elfin/30.png", "ui/elfin/21.png", 160, 170)
	self.easyExplore.view:setPosition(2, 168)
	parent:addChild(self.easyExplore.view)
	self.explore[1] = self.easyExplore
	-- 精英探险
	self.normalExplore = self:createExplorePanel(2, "ui/elfin/31.png", "ui/elfin/32.png", "ui/elfin/22.png", 160, 170)
	self.normalExplore.view:setPosition(159, 168)
	parent:addChild(self.normalExplore.view)
	self.explore[2] = self.normalExplore
	-- 英雄探险
	self.hardExplore = self:createExplorePanel(3, "ui/elfin/33.png", "ui/elfin/34.png", "ui/elfin/23.png", 160, 170)
	self.hardExplore.view:setPosition(2, 2)
	parent:addChild(self.hardExplore.view)
	self.explore[3] = self.hardExplore
	-- 炼狱探险
	self.crazyExplore = self:createExplorePanel(4, "ui/elfin/35.png", "ui/elfin/36.png", "ui/elfin/24.png", 160, 170)
	self.crazyExplore.view:setPosition(159, 2)
	parent:addChild(self.crazyExplore.view)
	self.explore[4] = self.crazyExplore


	self.easyExplore.setEnable(true)
	self.normalExplore.setEnable(false)
	self.hardExplore.setEnable(false)
	self.crazyExplore.setEnable(false)

	return parent
end

-- 探险面板
function Explore:createExplorePanel( exploreType, enabledImg, disabledImg, titleImg, width, height )
	local parent = ZBasePanel.new(nil, width, height)
	-- 探险底图
	local mapImg = ZImage:create(parent.view, enabledImg, 0, 0, width, height, 0).view
	-- 探险标题
	local title = ZImage:create(parent.view, titleImg, width/2, height-20, -1, -1, 1).view
	title:setAnchorPoint(0.5, 0.5)
	-- “满”标志
	local fullSign = ZImage:create(parent.view, "ui/elfin/25.png", width-5, height-5, -1, -1, 1).view
	fullSign:setAnchorPoint(1.0, 1.0)
	fullSign:setIsVisible(false)
	parent.setFull = function( state )
		if state then
			fullSign:setIsVisible(true)
		else
			fullSign:setIsVisible(false)
		end
	end
	-- 禁止标志
	local banSign = ZImage:create(parent.view, "ui/elfin/28.png", width/2, height/2, -1, -1, 10).view
	banSign:setAnchorPoint(0.5, 0.5)
	banSign:setIsVisible(false)
	-- 战斗力限制
	local value = ElfinConfig:getExploreFightLimit(exploreType)
	local fightLimit = ZLabel:create(parent.view, string.format("#cf1e7d4人物战力%d开启", value), width/2, 10, 14, 2)
	fightLimit.view:setIsVisible(false)

	-- 领取奖励
	local getAwardBtn = ZButton.new("ui/elfin/26.png")
	getAwardBtn.view:setAnchorPoint(0.5, 0.5)
	getAwardBtn.view:setIsVisible(false)
	getAwardBtn.view:setPosition(width/2, height/2)
	parent.view:addChild(getAwardBtn.view, 9)
	parent.setAwardEnable = function( state )
		if state then
			getAwardBtn.view:setIsVisible(true)
		else
			getAwardBtn.view:setIsVisible(false)
		end
	end
	parent.getAwardFun = function( )
		if _getAwardTimer then
			_getAwardTimer:cancel()
		end
		parent.setAwardEnable(false)
		parent.setTimerVisible(false)
		parent.stopTimer()
		parent.setSpeedVisible(false)
		-- ElfinModel:setCurLeftPage(ElfinModel.EXPLORE_STORAGE_PAGE)
		ElfinModel:changeLeftPage(ElfinModel.EXPLORE_STORAGE_PAGE)
		-- ElfinModel:setExploreType(0)
		ElfinCC:req_get_explore_award()
	end
	getAwardBtn:setTouchClickFun(function( )
		parent.getAwardFun()
	end)

	-- 计时
	local timer = TimerLabel:create_label( parent.view, 5, 10, 14, 0, "#cf1e7d4历时#cffffff", nil, 1, ALIGN_LEFT, true)
	timer.panel.view:setIsVisible(false)
	parent.timer = timer
	parent.setTimerVisible = function( state )
		if state then
			timer.panel.view:setIsVisible(true)
		else
			timer.panel.view:setIsVisible(false)
		end
	end
	parent.setTimer = function( sec )
		timer:setText(sec)
	end
	parent.stopTimer = function( )
		timer:stop_timer()
	end

	-- 快进按钮
	local speedBtn = ZButton.new("ui/elfin/27.png")
	speedBtn.view:setAnchorPoint(1.0, 0)
	speedBtn.view:setIsVisible(false)
	speedBtn.view:setPosition(width-5, 3)
	speedBtn.view:setScale(0.8)
	parent.view:addChild(speedBtn.view)
	parent.setSpeedVisible = function( state )
		if state then
			speedBtn.view:setIsVisible(true)
		else
			speedBtn.view:setIsVisible(false)
		end
	end
	speedBtn:setTouchClickFun(function( )
		ElfinModel:reqExtendExploreDt(exploreType)
	end)

	-- 点击开始探险
	local beginSign = ZImage:create(parent.view, "ui/elfin/43.png", width/2, height/2, -1, -1, 9).view
	beginSign:setAnchorPoint(0.5, 0.5)
	beginSign:setIsVisible(false)
	parent.setBeginSign = function( state )
		if state then
			beginSign:setIsVisible(true)
		else
			beginSign:setIsVisible(false)
		end
	end

	-- 点击切换探险
	local exchangeSign = ZImage:create(parent.view, "ui/elfin/44.png", width/2, height/2, -1, -1, 9).view
	exchangeSign:setAnchorPoint(0.5, 0.5)
	exchangeSign:setIsVisible(false)
	parent.setExchange = function( state )
		if state then
			exchangeSign:setIsVisible(true)
		else
			exchangeSign:setIsVisible(false)
		end
	end

	-- 是否开启
	parent.setEnable = function( state )
		if state then
			parent.open = true
			mapImg:setTexture(enabledImg)
			banSign:setIsVisible(false)
			fightLimit.view:setIsVisible(false)
		else
			parent.open = false
			mapImg:setTexture(disabledImg)
			banSign:setIsVisible(true)
			fightLimit.view:setIsVisible(true)
			beginSign:setIsVisible(false)
			exchangeSign:setIsVisible(false)
		end
	end

	parent.setExploreEffect = function( state )
		if state then
			LuaEffectManager:play_view_effect(409, width/2-5, height/2+5, parent.view, true, 8)
		else
			LuaEffectManager:stop_view_effect(409, parent.view)
		end
	end

	parent:setTouchClickFun(function( )
		if parent.open then
			local curType = ElfinModel:getExploreType()
			if curType ~= exploreType then
				ElfinModel:reqExplore(exploreType)
			end
		end
	end)

	return parent
end

-- 更新上面板
function Explore:updateUpPanel( )
	local exploreLevel = ElfinModel:getExploreLevel()
	self:openExploreLevel(exploreLevel)
end

-- 探险开启数量
function Explore:openExploreLevel( exploreLevel )
	for i=1,exploreLevel do
		self.explore[i].setEnable(true)
		self.explore[i].setBeginSign(false)
		self.explore[i].setExchange(true)
	end

	local exploreType = ElfinModel:getExploreType()

	if self.explore[exploreType] then
		self.explore[exploreType].setBeginSign(false)
		self.explore[exploreType].setExchange(false)
	else
		for i=1,exploreLevel do
			self.explore[i].setBeginSign(true)
			self.explore[i].setExchange(false)
		end
	end
end

function Explore:setFullSign( exploreType, isFull )
	if self.explore[exploreType] then
		self.explore[exploreType].setFull(isFull)
	end
end

function Explore:updateExploreTimer( exploreType, duration )
	for i,v in ipairs(self.explore) do
		v.stopTimer()
		v.setTimerVisible(false)
		v.setSpeedVisible(false)
		v.setAwardEnable(false)
		v.setExploreEffect(false)
	end

	if duration == 0 then
		duration = 1 	-- 时长为0，时间控件不会计时，故设为1
	end

	if _getAwardTimer then
		_getAwardTimer:cancel()
	end

	if self.explore[exploreType] then
		local awardTime = ElfinConfig:getEquipAwardTime(exploreType)
		if awardTime - duration > 0 then
			self.explore[exploreType].setAwardEnable(false)
			_getAwardTimer:start(awardTime-duration-1, function( )
				self.explore[exploreType].setAwardEnable(true)
			end)
		else
			self.explore[exploreType].setAwardEnable(true)
		end
	end

	local exploreLevel = ElfinModel:getExploreLevel()

	if self.explore[exploreType] then
		self.explore[exploreType].setTimerVisible(true)
		self.explore[exploreType].setTimer(duration)
		self.explore[exploreType].setSpeedVisible(true)
		-- self.explore[exploreType].setAwardEnable(true)
		self.explore[exploreType].setExploreEffect(true)
		for i=1,exploreLevel do
			self.explore[i].setBeginSign(false)
			self.explore[i].setExchange(true)
		end
		self.explore[exploreType].setBeginSign(false)
		self.explore[exploreType].setExchange(false)
	else
		for i=1,exploreLevel do
			self.explore[i].setBeginSign(true)
			self.explore[i].setExchange(false)
		end
	end

	local maxExploreTime = ElfinConfig:getMaxExploreTime()
	if duration >= maxExploreTime then
		self.explore[exploreType].stopTimer()
	end
end

function Explore:updateStorageFull( exploreType, duration )
	if self.explore[exploreType] then
		if ElfinModel:checkExploreStorageFull(exploreType, duration) then
			self:setFullSign(exploreType, true)
		else
			self:setFullSign(exploreType, false)
		end
	end
end

-- 创建下面板
function Explore:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "", 0, 10, width, height, 500, 500)

	-- 标题
	local titleBg = ZImage:create(parent, "ui/transform/new24.png", width/2, height-8, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)
	-- local title = ZImage:create(parent, "ui/elfin/38.png", width/2, height-8, -1, -1, 0, 500, 500)
	-- title.view:setAnchorPoint(0.5, 0.5)
	ZLabel:create(parent, "#cfff000召唤宝箱", width/2, height-15, 16, 2)

    self.goldBoxItem = MUtils:create_slot_item(parent, UIPIC_ITEMSLOT, 35, 77+10, 72, 72, nil)
    self.goldBoxItem:set_icon_texture("ui/elfin/goldbox.png")
    local spr = self.goldBoxItem:play_activity_effect()
    if spr then
		spr:setAnchorPoint(CCPointMake(0.5,0.5))
		spr:setScale(64/48)
		spr:setPosition(32,32)
	end

    ZLabel:create(parent, "#cfff000黄金宝箱", 72, 48+10, 16, 2, 0)

    -- 召唤宝箱按钮
	local callBoxBtn = ZTextButton.new("ui/common/button3.png", nil, nil, "召唤宝箱")
	callBoxBtn:setPosition(160, 90+10)
	parent:addChild(callBoxBtn.view)
	local callBoxFunc = function( )
		print('-- callBoxBtn clicked --')
		ElfinModel:reqCallGoldBox()
	end
	callBoxBtn:setTouchClickFun(callBoxFunc)

	self.needMoney = ZLabel:create(parent, "", 223, 70+10, 15, 2, 0)
	self.callNum = ZLabel:create(parent, "", 223, 48+10, 15, 2, 0)

	ZLabel:create(parent, "#ce519cb有概率开出紫色或橙色装备", width/2, 20, 17, 2)

	return parent
end

-- 更新下面板
function Explore:updateDwnPanel( )
	local money = ElfinConfig:getGoldBoxOpenCost()
	self.needMoney:setText(string.format("#cfe8300%d#cffffff元宝/绑元", money))

	self:updateGoldBoxNum()
end

function Explore:updateGoldBoxNum( )
	local maxTimes = ElfinConfig:getGoldBoxMaxOpenTimes()
	local boxNum = ElfinModel:getGoldBoxNum()
	self.callNum:setText(string.format("今天召唤次数：%d/%d", boxNum, maxTimes))
end

-- 打开黄金宝箱动画
function Explore:playGotGoldBoxEffect( item )
	local uiWidth = GameScreenConfig.ui_screen_width 
	local uiHeight = GameScreenConfig.ui_screen_height
	local uiNode = ZXLogicScene:sharedScene():getUINode()
	local lockPanel = CCArcRect:arcRectWithColor(0,0, uiWidth, uiHeight, 0x000000dd)
	lockPanel:setDefaultMessageReturn(true)
	uiNode:addChild(lockPanel, 10000)
	local box = LuaEffectManager:play_view_effect(410, uiWidth/2, uiHeight+100, uiNode, false, 10001)

	local array = CCArray:array()
	local move 	= CCMoveTo:actionWithDuration(0.3, CCPoint(uiWidth/2, uiHeight-200))
	local ease = CCEaseOut:actionWithAction(move, 1.5)
	local jump1 = CCJumpTo:actionWithDuration( 0.4, CCPoint(uiWidth/2, uiHeight-200), 40, 1)
	local jump2 = CCJumpTo:actionWithDuration( 0.2, CCPoint(uiWidth/2, uiHeight-200), 20, 1)
	local jump3 = CCJumpTo:actionWithDuration( 0.1, CCPoint(uiWidth/2, uiHeight-200), 10, 1)
	array:addObject(ease)
    array:addObject(jump1)
    array:addObject(jump2)
    array:addObject(jump3)
    box:runAction(CCSequence:actionsWithArray(array))

	local back = callback:new()
	back:start(1.0, function( )
		LuaEffectManager:stop_view_effect(410, uiNode)
		LuaEffectManager:play_view_effect(416, uiWidth/2, uiHeight-200, uiNode, true, 10001)
	end)

	local awardItem = ElfinEquipItem()
	awardItem:update(item)
	awardItem.view:setAnchorPoint(0.5, 0.5)
	awardItem.view:setPosition(uiWidth/2, 220)
	uiNode:addChild(awardItem.view, 10003)

	local name = ElfinConfig:getEquipNameByType(item.itemType)
	local itemName = ZLabel:create(uiNode, string.format("#cf1e7d4%s", name), uiWidth/2, 160, 16, 2, 10003)
	itemName.view:setIsVisible(false)

	awardItem.view:setScale(10)
    awardItem.view:setIsVisible(false)
    local array = CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(1.0))
    array:addObject(CCShow:action())
    local array2 = CCArray:array()
    array2:addObject(CCScaleTo:actionWithDuration(0.4, 1))
    array2:addObject(CCFadeIn:actionWithDuration(0.4))
    local action = CCSpawn:actionsWithArray(array2)
    array:addObject(action)
    awardItem.view:runAction(CCSequence:actionsWithArray(array))

    local arr = CCArray:array()
	arr:addObject(CCDelayTime:actionWithDuration(1.4))
	arr:addObject(CCShow:action())
	itemName.view:runAction(CCSequence:actionsWithArray(arr))

	local getBtn = ZButton.new("ui/common/dan.png")
	getBtn.view:setAnchorPoint(0.5, 0.5)
	getBtn.view:setIsVisible(false)
	getBtn:setPosition(uiWidth/2, 100)
	uiNode:addChild(getBtn.view, 10002)
	local callBoxFunc = function( )
		print('-- getBtn clicked --')
		back:cancel()
		LuaEffectManager:stop_view_effect(410, uiNode)
		LuaEffectManager:stop_view_effect(416, uiNode)
		lockPanel:removeFromParentAndCleanup(true)
		getBtn.view:removeFromParentAndCleanup(true)
		awardItem.view:removeFromParentAndCleanup(true)
		itemName.view:removeFromParentAndCleanup(true)
	end
	getBtn:setTouchClickFun(callBoxFunc)
	local btnSize = getBtn.view:getSize()
	local txtImg = ZImage:create(getBtn.view, "ui/elfin/12.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	local arr = CCArray:array()
	arr:addObject(CCDelayTime:actionWithDuration(1.6))
	arr:addObject(CCShow:action())
	getBtn.view:runAction(CCSequence:actionsWithArray(arr))
end

function Explore:update( updateType, param )
	print('-- Explore:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "goldBoxNum" then
		self:updateGoldBoxNum()
	elseif updateType == "openGoldBox" then
		self:playGotGoldBoxEffect(param[1])
	elseif updateType == "timer" then
		self:updateExploreTimer(param[1], param[2])
		self:updateStorageFull(param[1], param[2])
	elseif updateType == "openExploreLevel" then
		self.openExploreLevel(param[1])
	elseif updateType == "storageFull" then
		self:setFullSign(param[1], param[2])
	elseif updateType == "removeStorageItem" then
	elseif updateType == "addStorageItem" then
	elseif updateType == "getAward" then
		local exploreType = ElfinModel:getExploreType()
		if self.explore[exploreType] then
			self.explore[exploreType].getAwardFun()
		end
	end
end

function Explore:destroy( )
	if _getAwardTimer then
		_getAwardTimer:cancel()
	end
	for i,v in ipairs(self.explore) do
		v.timer:destroy()
	end
end