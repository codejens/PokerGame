-- ExploreStorage.lua
-- created by yongrui.liang on 2014-8-25
-- 探险仓库页面

super_class.ExploreStorage()

function ExploreStorage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

	-- 上面板
    local upPanel = self:createUpPanel(373, 395-12)
    upPanel:setPosition(10, 160+12)
    panel:addChild(upPanel)

    -- 下面板
    local dwnPanel = self:createDwnPanel(373, 145+12)
    dwnPanel:setPosition(10, 10)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function ExploreStorage:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	
	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	local bagPanel = self:createItems(width, height)
	bagPanel:setPosition(0, 0)
	parent:addChild(bagPanel)

	return parent
end

function ExploreStorage:createRowList( rowList, width, height )
	local parent = ZBasePanel.new(nil, width, height)

	parent.items = {}
	for i,v in ipairs(rowList) do
		local item = ElfinEquipItem()
		item:setIndex(v)
		item:setOpenStatus(true)
		item.view:setPosition((i-1)*74+4, 4)
		parent.view:addChild(item.view)
		parent.items[i] = item
	end

	parent.update = function( data )
		for i,v in ipairs(data) do
			if parent.items[i] then
				parent.items[i]:update(v.item)
				if v and v.item then
					parent.items[i]:setDoubleClickFun(function( )
						ElfinModel:getOutStorageItemByDbClick(v.item)
					end)
					parent.items[i]:setClickFun(function( )
						TipsModel:show_fabao_xianhun(480, 480/2, v.item)
					end)
				else
					parent.items[i]:setDoubleClickFun(nil)
					parent.items[i]:setClickFun(nil)
				end
			end
		end
	end

	return parent
end

function ExploreStorage:getItemList( )
	local storageData = ElfinModel:getExploreStorage() or {}
	local bagNum = ElfinModel:getExploreStorageNum()
	local colNum = 5
	local rowNum = bagNum / colNum
	local bagItems = {}
	for i=1,rowNum do
		local rowList = {}
		for j=1,colNum do
			local index = (i-1)*colNum+j
			local data = storageData[index]
			table.insert(rowList, {index = index, item = data})
		end
		table.insert(bagItems, rowList)
	end
	return bagItems
end

function ExploreStorage:createItems( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	local bagItems = self:getItemList()
	local createItem = function( data, newComp )
		if not newComp then
			newComp = self:createRowList(data, 74*5, 74)
			newComp.update(data)
		else
			newComp.update(data)
		end
		return newComp
	end
	self.bagList = TouchListVertical(2, 2, width-4, height-4, 74, 8)
	self.bagList:BuildList(72, 0, 6, bagItems, createItem)
	parent:addChild(self.bagList.view)

	return parent
end

function ExploreStorage:updateStorage( )
	local bagItems = self:getItemList()
	self.bagList:refresh(bagItems)
end

function ExploreStorage:updateItem( index, data )
	local storageData = ElfinModel:getExploreStorage() or {}
	local colNum = 5
	local row = math.floor(index / colNum) + 1
	if index%colNum == 0 then
		row = row - 1
	end
	local beg = (row-1)*colNum + 1
	local stop = beg + colNum
	local rowList = {}
	for i=beg,stop do
		table.insert(rowList, {index = i, item = storageData[i]})
	end
	self.bagList:refresh_item(row, rowList)
end


-- 更新上面板
function ExploreStorage:updateUpPanel( )
	
end

-- 创建下面板
function ExploreStorage:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	self.exploreDt = ZLabel:create(parent, "", 10, height-26, 16, 1)
	self.smeltVal = ZLabel:create(parent, "", width-10, height-26, 16, 3)
	self.storageNum = ZLabel:create(parent, "", 10, height-55, 16, 1)

	-- 领取奖励按钮
	local getAwardBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	getAwardBtn.view:setAnchorPoint(0.5, 0.5)
	getAwardBtn:setPosition(width/2, 45)
	parent:addChild(getAwardBtn.view)
	local getAwardFunc = function( )
		print('-- getAwardBtn clicked --')
		ElfinModel:getOutAllStorageItem()
	end
	getAwardBtn:setTouchClickFun(getAwardFunc)
	local btnSize = getAwardBtn.view:getSize()
	local txtImg = ZImage:create(getAwardBtn.view, "ui/elfin/12.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	return parent
end

-- 更新下面板
function ExploreStorage:updateDwnPanel( duration, smelt )
	local dt = Utils:formatTime(duration or 0, 1)
	self.exploreDt:setText(string.format("探险历时：%s", dt))
	self.smeltVal:setText(string.format("熔炼值：%d", smelt or 0))
	self:updateStorageSpace()
end

function ExploreStorage:updateStorageSpace( )
	local maxNum = ElfinModel:getExploreStorageNum()
	local num = ElfinModel:getStorageItemNum()
	self.storageNum:setText(string.format("仓库容量：%d/%d", num, maxNum))
end

function ExploreStorage:update( updateType, param )
	print('-- ExploreStorage:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateStorage()
		self:updateDwnPanel()
	elseif updateType == "removeStorageItem" then
		-- self:updateItem(param[1], param[2])
		self:updateStorage()
		self:updateStorageSpace()
	elseif updateType == "addStorageItem" then
		self:updateItem(param[1], param[2])
		self:updateStorageSpace()
	elseif updateType == "storageItemCount" then
		self:updateItem(param[1], param[2])
		self:updateStorageSpace()
	elseif updateType == "getExploreAward" then
		self:updateDwnPanel(param[1], param[2])
		self:updateStorageSpace()
	elseif updateType == "removeAllStorageItems" then
		self:updateStorage()
		self:updateStorageSpace()
	end
end

function ExploreStorage:active( show )
	if show then
		ElfinCC:req_bag_or_storage(2)
	end
end

function ExploreStorage:destroy( )
	self.bagList:destroy()
end