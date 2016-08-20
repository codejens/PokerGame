-- ExploreBag.lua
-- created by yongrui.liang on 2014-8-25
-- 式神探险背包页面

super_class.ExploreBag()

function ExploreBag:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	local bagPanel = self:createItems(320, 545)
	bagPanel:setPosition(10, 10)
	panel:addChild(bagPanel)
end

function ExploreBag:createRowList( rowList, width, height )
	local parent = ZBasePanel.new(nil, width, height)

	parent.items = {}
	for i,v in ipairs(rowList) do
		local item = ElfinEquipItem()
		item:initItem()
		item:setIndex(v.index)
		item:setOpenStatus(true)
		item:setItemLocked(false)
		item.view:setPosition((i-1)*80+8, 6)
		parent.view:addChild(item.view)
		parent.items[i] = item
	end

	parent.update = function( data )
		for i,v in ipairs(data) do
			if parent.items[i] then
				parent.items[i]:update(v.item)
				parent.items[i]:setItemLocked(v.lock)
				if v and v.item then
					parent.items[i]:setDoubleClickFun(function( )
						ElfinModel:useBagItemByDbClick(v.item)
					end)
					parent.items[i]:setClickFun(function( )
						TipsModel:show_fabao_xianhun(480, 480/2, v.item)
					end)
					local higher = ElfinModel:checkItemHigherThanEquipment(v.item)
					if higher then
						parent.items[i]:setUpSignEnabled(true)
					else
						parent.items[i]:setUpSignEnabled(false)
					end
				else
					parent.items[i]:setDoubleClickFun(nil)
					parent.items[i]:setClickFun(nil)
					parent.items[i]:setUpSignEnabled(false)
				end
			end
		end
	end

	return parent
end

function ExploreBag:getItemList( )
	local bagData = ElfinModel:getExploreBag() or {}
	local bagNum = ElfinModel:getExploreBagNum()
	local colNum = 4
	local rowNum = bagNum / colNum
	local bagItems = {}
	for i=1,rowNum do
		local rowList = {}
		for j=1,colNum do
			local index = (i-1)*colNum+j
			local data = bagData[index]
			table.insert(rowList, {index = index, item = data})
		end
		table.insert(bagItems, rowList)
	end
	return bagItems
end

function ExploreBag:createItems( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	ZBasePanel:create(parent, "", 0, 65, width, height-64, 500, 500)

	local bagItems = self:getItemList()
	local createItem = function( data, newComp )
		if not newComp then
			newComp = self:createRowList(data, 80*4, 80)
			newComp.update(data)
		else
			newComp.update(data)
		end
		return newComp
	end
	self.bagList = TouchListVertical(0, 69, width, height-70, 78, 8)
	self.bagList:BuildList(75, 0, 7, bagItems, createItem)
	parent:addChild(self.bagList.view)

	self.bagNum = ZLabel:create(parent, "", 0, 20, 16, 1)

	local rerangeBtn = ZTextButton.new("ui/common/button3.png", nil, nil, "整理背包")
	rerangeBtn:setPosition(width-130, 2)
	parent:addChild(rerangeBtn.view)
	local rerangeFun = function( )
		print('-- rerangeBtn clicked --')
		ElfinModel:rerangeBag()
	end
	rerangeBtn:setTouchClickFun(rerangeFun)

	return parent
end

function ExploreBag:updateBagSpace( )
	local maxNum = ElfinModel:getExploreBagNum()
	local num = ElfinModel:getBagItemNum()
	self.bagNum:setText(string.format("背包容量：%d/%d", num, maxNum))
end

function ExploreBag:updateBag( )
	local bagItems = self:getItemList()
	self.bagList:refresh(bagItems)
end

function ExploreBag:updateItem( itemIndex, data )
	local bagData = ElfinModel:getExploreBag() or {}
	local row, beg, stop = self:getRowByIndex(itemIndex)
	local rowList = {}
	for i=beg,stop do
		table.insert(rowList, {index = i, item = bagData[i]})
	end
	self.bagList:refresh_item(row, rowList)
end

function ExploreBag:getRowByIndex( index )
	local bagData = ElfinModel:getExploreBag() or {}
	local colNum = 4
	local row = math.floor(index / colNum) + 1
	if index % colNum == 0 then
		row = row - 1
	end
	local beg = (row-1)*colNum + 1
	local stop = beg + colNum - 1
	return row, beg, stop
end

function ExploreBag:updateRowItems( row, rowData )
	self.bagList:refresh_item(row, rowData)
end

-- 打开黄金宝箱动画
function ExploreBag:playBronzeBoxEffect( item )
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

	awardItem.view:setScale(10)
    awardItem.view:setIsVisible(false)
    local array = CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(1.0))
    array:addObject(CCShow:action())
    local array2 = CCArray:array()
    array2:addObject(CCScaleTo:actionWithDuration(0.2, 1))
    array2:addObject(CCFadeIn:actionWithDuration(0.2))
    local action = CCSpawn:actionsWithArray(array2)
    array:addObject(action)
    awardItem.view:runAction(CCSequence:actionsWithArray(array))

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
	end
	getBtn:setTouchClickFun(callBoxFunc)
	local btnSize = getBtn.view:getSize()
	local txtImg = ZImage:create(getBtn.view, "ui/elfin/12.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	local arr = CCArray:array()
	arr:addObject(CCDelayTime:actionWithDuration(1.5))
	arr:addObject(CCShow:action())
	getBtn.view:runAction(CCSequence:actionsWithArray(arr))
end

function ExploreBag:lockSomeItems( )
	local bagData = ElfinModel:getExploreBag() or {}
	local items = ElfinModel:get_equip_data()
	local tmpRow = {}
	for k,v in pairs(items) do
		if v.if_select then
			local idx = ElfinModel:findBagItemByCDKey(v.equip.itemCDKey)
			if idx then
				local r, b, e = self:getRowByIndex(idx)
				if not tmpRow[r] then
					tmpRow[r] = {}
				end
				for j=1,4 do
					if not tmpRow[r][j] then
						table.insert(tmpRow[r], {index = b+j-1, item = bagData[b+j-1], lock = false})
					end
					if tmpRow[r][j].index == idx and not tmpRow[r][j].lock then
						tmpRow[r][j].lock = true
					end
				end
			end
		end
	end
	for k,v in pairs(tmpRow) do
		local row = k
		local rowList = v
		self:updateRowItems(row, rowList)
	end
end

function ExploreBag:update( updateType, param )
	print('-- ExploreBag:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateBag()
		self:updateBagSpace()
		self:lockSomeItems()
	elseif updateType == "removeBagItem" then
		self:updateItem(param[1], param[2])
		self:updateBagSpace()
		self:lockSomeItems()
	elseif updateType == "addBagItem" then
		self:updateItem(param[1], param[2])
		self:updateBagSpace()
		self:lockSomeItems()
	elseif updateType == "bagItemCount" then
		self:updateItem(param[1], param[2])
		self:lockSomeItems()
	elseif updateType == "openBronzeBox" then
		self:playBronzeBoxEffect(param[1])
	elseif updateType == "rerangeBag" then
		self:updateBag()
		self:lockSomeItems()
	elseif updateType == "selectSmeltItem" then
		self:updateBag()
		self:lockSomeItems()
	end
end

function ExploreBag:active( show )
	if show then
		
	end
end

function ExploreBag:destroy( )
	self.bagList:destroy()
end