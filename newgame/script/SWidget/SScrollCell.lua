-- SScrollCell = {}

-- SScrollCell = simple_class(STouchBase)
super_class.SScrollCell(ZAbstractBasePanel)


local delayTime = 0.3



-- //////////////////////////////////////////////////////////////////////////////////////////:
-- self.itemState格式，state是标识为item的状态，view是cell控件（panel）,提供给外部去初始化每一个cell
-- self.itemState = {
-- 	[1] = {
--		localZOrder,
--      thisPageItemIndex,  
-- 		[1] = {state, view},
-- 		...
-- 		[10] = {state, view},
-- 	},

-- 	[2] = {
--		localZOrder,
--      thisPageItemIndex, 
-- 		[1] = {state, view},
-- 		...
-- 		[10] = {state, view},
-- 	},
-- 	...
-- }
-- //////////////////////////////////////////////////////////////////////////////////////////:


-- //////////////////////////////////////////////////////////////////////////////////////////:
-- self.accessoryPanelTable格式， 里面装载的若干个panel,每一个分页对应着一个panel
-- self.accessoryPanelTable = {
-- 	[1] = panel,
-- 	[2] = panel,
-- 	......
-- }
-- //////////////////////////////////////////////////////////////////////////////////////////:


-- 创建一个clipNode, 截屏的node节点
-- param:
-- tab:传进来的table格式为 tab = { [1] = {}, [2] = {}, [3] = {} }
-- cellNumEveryPage每一页的最大cell数量
-- initFunc用于初始化每一个cell内容的函数
-- initAccessoryFunc用于初始化附属panel的函数
-- pageObj用于作为参数传进initFunc内
function SScrollCell:create(tab, width, height, cellNumEveryPage, initFunc, initAccessoryFunc, pageObj)
	local view = CCTouchPanel:touchPanel(0, 0, width, height)
	local obj = self(view, tab, cellNumEveryPage, initFunc, initAccessoryFunc, pageObj)
	obj.width = width
	obj.height = height
	return obj
end

-- 根据传进来的table来创建若干个panel
function SScrollCell:changePageByIndex(pageIndex, tab)

	if not self.scrollPageTable[pageIndex] then
		-- 隐藏掉之前打开的页
		if self.scrollPageTable[self.curPageIndex] then
			self.scrollPageTable[self.curPageIndex]:setIsVisible(false)
		end

		-- 如果tab里面没有元素则return
		-- if not tab[(pageIndex - 1) * self.cellNumEveryPage + 1] then
		if not tab[pageIndex] then
			return
		end

		local Panel = nil
		local cellNum = 0
		--print("tab==================================", tab[pageIndex * self.cellNumEveryPage], pageIndex, self.cellNumEveryPage)
		-- if tab[pageIndex * self.cellNumEveryPage] then
		if tab[pageIndex] then
			Panel = CCBasePanel:panelWithFile(0, 0, self.width,90 * #tab[pageIndex] + 51, "", 500, 500)
			Panel:setPositionY(-(90 * #tab[pageIndex] + 51 - self.height + 2))
			self.view:addChild(Panel)
			-- cellNum = self.cellNumEveryPage
		else
			local tempNum = 0
			-- for k = (pageIndex -1 )* self.cellNumEveryPage, #tab do
			Panel = CCBasePanel:panelWithFile(0, 0, self.width, 90 * (#tab[pageIndex]) + 51, "", 500, 500)
			Panel:setPositionY(-( 90 * (#tab[pageIndex]) + 51 - self.height + 2))
			self.view:addChild(Panel)
			-- cellNum = #tab - (pageIndex - 1) * self.cellNumEveryPage
		end
		-- 记录着panel
		self.scrollPageTable[pageIndex] = Panel

		-- 生成附属的panel
		local accesstoryPanel = nil
		if not self.accessoryPanelTable[pageIndex] then
			-- accesstoryPanel = self:createAccessoryPanel()
			accesstoryPanel = CCBasePanel:panelWithFile(0, 0, self.width,53, "", 500, 500)
			self.accessoryPanelTable[pageIndex] = accesstoryPanel
			accesstoryPanel:setIsVisible(false)
			Panel:addChild(accesstoryPanel, 100)
			self:bindAccessoryInitFunc(pageIndex)
		end

		local scrollItem = nil
		
		-- for k = (pageIndex - 1) * self.cellNumEveryPage + 1, pageIndex * self.cellNumEveryPage do
		-- for k = 1, self.cellNumEveryPage do
		for k = 1, #tab[pageIndex] do
			--print("$$$$$$$$$$$$$$$$$$$$$$$$$", k)
			local function callback(eventType, x, y)
				-- if eventType == TOUCH_BEGAN then
				-- 	--print("began")
				-- 	self.click = true
				-- elseif eventType == TOUCH_MOVED then
				-- 	self.click = false
				-- 	-- --print("moved")
				-- elseif eventType == TOUCH_ENDED then
				-- 	--print("@@@@@@@@@@@@@@@@@@@@@", self.click, k)
				-- 	if self.click then
				-- 		self:managerFriendScroll(Panel, k, pageIndex)
				-- 	end
				-- end	
				if eventType == TOUCH_BEGAN then
					-- self.click = true
					self.num = 0

				elseif	eventType == TOUCH_MOVED then
					-- self.click = false
					self.num = self.num + 1

				elseif eventType == TOUCH_CLICK then
					-- print("self.num", self.num)
					if type(self.num) == "number" and self.num < 5 then
						self:managerFriendScroll(Panel, k, pageIndex)
					end
				end
			end

			if not self.itemState[pageIndex] then
				self.itemState[pageIndex] = {}
				-- 这个用于索引该页当中已经打开了的item
				self.itemState[pageIndex].thisPageItemIndex = nil
				self.itemState[pageIndex].localZOrder = 9999
			end


			scrollItem = CCBasePanel:panelWithFile(0, Panel:getSize().height - k * 90+1, 830, 90, "sui/common/unselected_panel_2.png", 500, 500)
			scrollItem:registerScriptHandler(callback)

			Panel:addChild(scrollItem, self.itemState[pageIndex].localZOrder)
			
			self.itemState[pageIndex].localZOrder = self.itemState[pageIndex].localZOrder - 1
			self.itemState[pageIndex][k] = {}
			self.itemState[pageIndex][k].state = false
			self.itemState[pageIndex][k].view = scrollItem
		end
		self.lastPageIndex = self.curPageIndex
		self.curPageIndex = pageIndex

		if self.maxPage > 1 then
			local pageLabel = SLabel:create(string.format("#c965a29%d/%d", self.curPageIndex, self.maxPage))
			pageLabel:setPosition(self.width/2, 19)
			Panel:addChild(pageLabel.view)
		end
		-- 创建上一页
		if tab[pageIndex - 1] then
			local function prePageCB()
				self:changePageByIndex(self.curPageIndex - 1, tab)
			end

			local prePageBtn = SButton:create("sui/common/btn_1.png", "sui/common/btn_1.png","sui/common/btn2_s.png")
			prePageBtn:setSize(103,40)
			prePageBtn:setPosition(10, 9)
			Panel:addChild(prePageBtn.view)
			prePageBtn:set_click_func(prePageCB)
			
			if not tab[pageIndex - 1] then
				prePageBtn:setCurState(CLICK_STATE_DISABLE)
			end

			local prePageLabel = SLabel:create("上一页")
			prePageLabel:setPosition(23, 10)
			prePageBtn:addChild(prePageLabel.view)
		end
		-- 下一页的按钮
		if tab[pageIndex + 1] then
			local function nextPageCB()
				self:changePageByIndex(self.curPageIndex + 1, tab)
			end

			local nextPageBtn = SButton:create("sui/common/btn_1.png", "sui/common/btn_1.png","sui/common/btn2_s.png")
			nextPageBtn:setSize(103,40)
			nextPageBtn:setPosition(self.width - 115, 9)
			Panel:addChild(nextPageBtn.view)
			nextPageBtn:set_click_func(nextPageCB)

			if not tab[pageIndex + 1] then
				nextPageBtn:setCurState(CLICK_STATE_DISABLE)
			end

			local nextPageLabel = SLabel:create("下一页")
			nextPageLabel:setPosition(23, 10)
			nextPageBtn:addChild(nextPageLabel.view)
		end
		-- 调回绑定的函数去初始化每一个CELL
		self.bindingInitFunc(self.pageObj, pageIndex)
	elseif pageIndex == self.curPageIndex and self.scrollPageTable[pageIndex] then
		return
	elseif pageIndex ~= self.curPageIndex and self.scrollPageTable[pageIndex] and self.scrollPageTable[self.curPageIndex] then
		self.scrollPageTable[pageIndex]:setIsVisible(true)
		self.scrollPageTable[self.curPageIndex]:setIsVisible(false)
		self.lastPageIndex = self.curPageIndex
		self.curPageIndex = pageIndex
	end
end

function SScrollCell:setPosition(x, y)
	self.view:setPosition(CCPointMake(x, y))
end

-- 根据触摸返回的字符串转换为x, y的坐标
function SScrollCell:getPos(y)
	local k =  string.find(y, ":")
	local yPos = string.sub(y,k + 1)
	local xPos = string.sub(y, 1, k - 1)

	return xPos, yPos
end

function SScrollCell:setForbidScrollItem(index, pageIndex)
	self.forbidIndex = index
	self.forbidPageIndex = pageIndex
end

-- 管理scrollCell的panel的大小和每个按钮的一些点击状态
function SScrollCell:managerFriendScroll(panel, index, pageIndex)
	if self.canMove == false then
		return
	end

	if index == self.forbidIndex and pageIndex == self.forbidPageIndex then
		return
	end

	local thisPageItemIndex = self.itemState[pageIndex].thisPageItemIndex
	-- pageIndex ~= self.lastPageIndex or
	-- if not self.friendPanelItemIndex or self.friendPanelItemIndex == index then

	if not thisPageItemIndex or thisPageItemIndex == index then
		-- 第一次点击的情况
		if self.itemState[self.curPageIndex][index].state == false then
					-- printc("第一次点击的情况", 13)

			for k2, v2 in pairs(self.itemState[self.curPageIndex]) do
				if type(v2) == "table" then
					v2.view:setPositionY(v2.view:getPositionY() + 54)
				end
			end	
			for k1, v1 in pairs(self.itemState[self.curPageIndex]) do
				if type(k1) ~= "string" and k1 > index and type(v1) == "table" then
					-- v1:setPositionY(v1:getPositionY() - 91)
					local moveBy = CCMoveBy:actionWithDuration(0.1, CCPointMake(0, -54))
					v1.view:runAction(moveBy)
				end
			end
			local size = panel:getSize()
			panel:setSize(size.width, size.height + 54)
			panel:setPositionY(panel:getPositionY() - 54)
			self.itemState[self.curPageIndex][index].state = true

			-- 计时是否可以触摸（原本打算放在判断语句外面的，但不知道为什么下面的运行不了，没时间优化，先简单粗暴）
			self.canMove = false
			local function recoverCanTouch()
				--print("做了回调")
				self.canMove = true
			end

			local callback = callback:new()
			callback:start(delayTime, recoverCanTouch)

			-- 记录当前的item索引
			-- self.friendPanelItemIndex = index
			self.itemState[pageIndex].thisPageItemIndex = index
			self:managerAccessoryPanel(pageIndex, index, 1)
		else
			-- printc("2222222222222", 13)
			for k2, v2 in pairs(self.itemState[self.curPageIndex]) do
				if type(k2) ~= "string"  then
					v2.view:setPositionY(v2.view:getPositionY() - 54)
				end
			end	
			for k1, v1 in pairs(self.itemState[self.curPageIndex]) do	
				if type(k1) ~= "string" and k1 ~= "thisPageItemIndex" and k1 > index then
					local moveBy = CCMoveBy:actionWithDuration(0.1, CCPointMake(0, 54))
					v1.view:runAction(moveBy)
					-- v1:setPositionY(v1:getPositionY() - 54)
				end
			end
			local size = panel:getSize()
			panel:setSize(size.width, size.height - 54)
			panel:setPositionY(panel:getPositionY() + 54)
			self.itemState[self.curPageIndex][index].state = false
			-- 如果点击的是同一个item则将该索引重置为Nil表示没有打开任何item
			-- self.friendPanelItemIndex = nil
			self.itemState[pageIndex].thisPageItemIndex = nil

			self:managerAccessoryPanel(pageIndex, nil, 3, nil)

			-- 计时是否可以触摸（原本打算放在判断语句外面的，但不知道为什么下面的运行不了，没时间优化，先简单粗暴）
			self.canMove = false
			local function recoverCanTouch()
				--print("做了回调")
				self.canMove = true
			end

			local callback = callback:new()
			callback:start(delayTime, recoverCanTouch)


		end
	-- elseif self.friendPanelItemIndex and self.friendPanelItemIndex ~= index then
	-- 点击的cell索引不一样
	elseif thisPageItemIndex and thisPageItemIndex ~= index then
		-- printc("333333333333333333", 13)
		-- 如果有别的好友Item打开了，则先关闭之前的item再打开当前item
		if self.itemState[self.curPageIndex][thisPageItemIndex].state == true then
			-- for k, v in pairs(self.itemState) do
			-- 	v.item:setPositionY(v.item:getPositionY() - 54)
			-- end

			-- -- 先关闭之前打开的Item
			local function closeItem()
				for k = thisPageItemIndex +1, #self.itemState[self.curPageIndex] do
					local moveBy = CCMoveBy:actionWithDuration(0.1, CCPointMake(0, 54))
					self.itemState[self.curPageIndex][k].view:runAction(moveBy)
				end
				-- 先设定位置
				self:managerAccessoryPanel(pageIndex, index, 2, thisPageItemIndex)
			end

			local callback1 = callback:new()
			callback1:start(0, closeItem)

			local function openItem()
				for k = index + 1, #self.itemState[self.curPageIndex] do
					local moveBy = CCMoveBy:actionWithDuration(0.1,  CCPointMake(0, -54))
					self.itemState[self.curPageIndex][k].view:runAction(moveBy)
				end
				self.itemState[self.curPageIndex][index].state = true
				self.itemState[self.curPageIndex][thisPageItemIndex].state = false
				self.itemState[pageIndex].thisPageItemIndex = index
			end

			local callback2 = callback:new()
			callback2:start(0.2, openItem)


			-- 计时是否可以触摸（原本打算放在判断语句外面的，但不知道为什么下面的运行不了，没时间优化，先简单粗暴）
			self.canMove = false
			local function recoverCanTouch()
				--print("做了回调")
				self.canMove = true
			end

			local callback = callback:new()
			callback:start(delayTime, recoverCanTouch)


		end
	end

	-- 测试数据
	self.testIndex = index
	--print("L$L$L$L$L$L$L$L$L$L$L$L$L$L$L$", tostring(self.testIndex), self.testIndex, pageIndex, index, x, y)
end

-- 管理附属accessoryPanel的位置和移动
function SScrollCell:managerAccessoryPanel(pageIndex, index, moveType, beforeClickIndex)
	-- local function setVisible()
		if self.accessoryPanelTable[pageIndex] then
			self.accessoryPanelTable[pageIndex]:setIsVisible(true)
		end
	-- end
	
	local count = self.accessoryPanelTable[pageIndex]:getChildrenCount()
	for i=0, count - 1 do
		local node = ZXLuaUtils:getCCNodeChildrenByIndex(self.accessoryPanelTable[pageIndex],i)
		node:setCurState(CLICK_STATE_DISABLE)
	end


	local function setTouchEnabled()
		local count = self.accessoryPanelTable[pageIndex]:getChildrenCount()
		for i=0, count - 1 do
			local node = ZXLuaUtils:getCCNodeChildrenByIndex(self.accessoryPanelTable[pageIndex],i)
			node:setCurState(CLICK_STATE_UP)
		end
	end
	local callback = callback:new()
	callback:start(0.3, setTouchEnabled)

	-- 第一次点击的情况
	if moveType == 1 then
		--print("moveType =======1")
		local scroll = self.itemState[pageIndex][index].view
		local x, y = scroll:getPosition()
		local worldPoint = scroll:convertToWorldSpace(CCPointMake(0, 0))
		local nodePoint = self.scrollPageTable[pageIndex]:convertToNodeSpace( CCPointMake(worldPoint.x, worldPoint.y));
		self.accessoryPanelTable[pageIndex]:setPosition(nodePoint.x, nodePoint.y)

		local moveBy = CCMoveBy:actionWithDuration(0.2, CCPointMake(0, -54))
		self.accessoryPanelTable[pageIndex]:runAction(moveBy)
	elseif moveType == 2 then
		-- 如果以前点击的索引大于当前点击的索引，则直接设置位置后下移
		if beforeClickIndex > index then
			--print("moveType =======2")
			local scroll = self.itemState[pageIndex][index].view
			local x, y = scroll:getPosition()
			local worldPoint = scroll:convertToWorldSpace(CCPointMake(0, 0))
			local nodePoint = self.scrollPageTable[pageIndex]:convertToNodeSpace( CCPointMake(worldPoint.x, worldPoint.y));
			self.accessoryPanelTable[pageIndex]:setPosition(nodePoint.x, nodePoint.y)

			local moveBy = CCMoveBy:actionWithDuration(0.2, CCPointMake(0, -54))
			self.accessoryPanelTable[pageIndex]:runAction(moveBy)
		else
			--print("moveType =======3")
			local scroll = self.itemState[pageIndex][index].view
			local x, y = scroll:getPosition()
			local worldPoint = scroll:convertToWorldSpace(CCPointMake(0, 0))
			local nodePoint = self.scrollPageTable[pageIndex]:convertToNodeSpace( CCPointMake(worldPoint.x, worldPoint.y));
			self.accessoryPanelTable[pageIndex]:setPosition(nodePoint.x, nodePoint.y)

			-- local moveBy = CCMoveBy:actionWithDuration(0.1, CCPointMake(0, -91 - 91))
			-- self.accessoryPanelTable[pageIndex]:runAction(moveBy)
		end
	elseif moveType == 3 then
		--print("moveType =======4")
		--print("隐藏了····························", pageIndex)
		self.accessoryPanelTable[pageIndex]:setIsVisible(false)
	end

	-- if self.accessoryPanelTable[pageIndex] then
	-- 	self.accessoryPanelTable[pageIndex]:setIsVisible(true)
	-- end

end


-- 点击回调
function SScrollCell:touchBegan(eventType, x, y)
	if x then
		self.touchX, self.beganY = self:getPos(x)
	end

	self.click = true
	--print("touchBegan", x, self.beganY)
	local time = 0
	-- -- 计算加速度
	local function calculateA()
		time = time + 0.016
		if time >= self.calculateATime then
			touchX, self.y2 = self:getPos(x)
			if self.y2 and self.y1 then
			   self.deltay = self.y1- self.y2
			   	-- print("***********************************", self.deltay, self.y1, self.y2)	
			   touchX ,self.y2 = self:getPos(x)
			   touchX ,self.y1 = self:getPos(x)
			end
			time = 0
		end		
	end
	self.touchBeganSchedule = timer()
	self.touchBeganSchedule:start(0.016,calculateA);
	return true
end

-- 拖动回调
function SScrollCell:touchMoved(eventType, x, y)
	if not self.scrollPageTable[self.curPageIndex] then
		return 
	end

	if self.canMove == false then
		return false
	end


	--print("touchMoved")
	self.click = false
	self.touchX ,self.moveY = self:getPos(x)
	self.touchX ,self.y1 = self:getPos(x)
	local deltaY = nil
	if self.moveY and self.beganY then
		deltaY = self.moveY - self.beganY
	end

	local pageIndex = self:getCurPageIndex()
	local cellTable = self:getScrollByIndex(pageIndex)
	-- print("pageIndex444", pageIndex, cellTable, self.curPageIndex)

	if cellTable[#cellTable].view:getPositionY() then
		-- print("888888888888888888888888888", cellTable[#cellTable].view:getPositionY())
		local worldPoint = cellTable[#cellTable].view:convertToWorldSpace(CCPointMake(0,0))
		local nodePoint = self.view:convertToNodeSpace(CCPointMake(worldPoint.x, worldPoint.y))
		-- print("nodePoint", nodePoint.y)
		if nodePoint.y > 70 then
			if deltaY > 0 then
				self.atLeastToMove = false


				if self.touchBeganSchedule then
					self.touchBeganSchedule:stop()
					self.touchBeganSchedule = nil
				end

				return false
			end
		end
	end

	-- -- --print("*********************************", deltaY, self.moveY, self.beganY)
	if deltaY then
		self.scrollPageTable[self.curPageIndex]:setPositionY(self.scrollPageTable[self.curPageIndex]:getPositionY() + tonumber(deltaY))
		self.beganY = self.moveY
	end
end

-- 触摸结束回调
function SScrollCell:touchEnded()
	if self.touchBeganSchedule then
		self.touchBeganSchedule:stop()
		self.touchBeganSchedule = nil
	end

	-- printc("self.atLeastToMove", self.atLeastToMove, self.canMove, 14)

	-- if not self.atLeastToMove then
	-- 	self.atLeastToMove = true
	-- 	-- print("self.scrollPageTable[self.curPageIndex]:getContentSize().height < self.height")
	-- 	if self.scrollPageTable[self.curPageIndex] and self.scrollPageTable[self.curPageIndex]:getContentSize().height < self.height then

	-- 		self.scrollPageTable[self.curPageIndex]:setPositionY(-(self.scrollPageTable[self.curPageIndex]:getSize().height - self.height + 2))
	-- 	end
	-- 	return false
	-- end

	-- 测试
	if self.canMove == false then
		return false
	end
	--print("ended")


	self.deltay = self.deltay / 3
	--print("^^^^^^^^^^^^^^^^^^^^^^^^^^", self.deltay)
	if self.deltay >= 25 then
		self.deltay = 25
	elseif self.deltay <= -25 then
		self.deltay = -25
	end
	local function runScroll()
		-- print("self.scrollPageTable", self.curPageIndex, self.scrollPageTable[self.curPageIndex])
		if not self.scrollPageTable[self.curPageIndex] then
			if self.touchEndedSchedule then
				self.touchEndedSchedule:stop()
				self.touchEndedSchedule = nil
			end
			return
		end
		self.scrollPageTable[self.curPageIndex]:setPositionY(self.scrollPageTable[self.curPageIndex]:getPositionY() + self.deltay)
		-- 这里是判断边界
		if self.scrollPageTable[self.curPageIndex]:getPositionY() <= -(self.scrollPageTable[self.curPageIndex]:getSize().height - self.height) then
			-- printc("做了上边界判断", 13)
			self.scrollPageTable[self.curPageIndex]:setPositionY(-(self.scrollPageTable[self.curPageIndex]:getSize().height - self.height + 2))

			self.touchEndedSchedule:stop()
			self.touchEndedSchedule = nil
			-- 这里添加一个self.num > 5防止真机点击的时候不知道为什么会移动
		-- elseif self.scrollPageTable[self.curPageIndex]:getPositionY() >= 0 and self.num > 5 then
		elseif self.scrollPageTable[self.curPageIndex]:getPositionY() >= -5 then
			-- printc("做了下边界判断", 14)
			self.scrollPageTable[self.curPageIndex]:setPositionY(0)
			self.touchEndedSchedule:stop()
			self.touchEndedSchedule = nil
		end

		-- self.scrollPageTable[self.curPageIndex]:setPositionY(self.scrollPageTable[self.curPageIndex]:getPositionY() + self.deltay)


		if self.deltay < 0 then
			-- print("++++++++++++++")
			self.deltay = self.deltay + 100 * 0.016
			if math.abs(self.deltay) <= 1 then
				if self.touchEndedSchedule then
					self.touchEndedSchedule:stop()
					self.touchEndedSchedule = nil
				end
				-- print("hhhhhhhhhgggggggggg", self.scrollPageTable[self.curPageIndex]:getPositionY(), self.deltay)
			end 
		else
			-- print("---------------")
			self.deltay = self.deltay - 100 * 0.016
			if math.abs(self.deltay) <= 1 then
				if self.touchEndedSchedule then
					self.touchEndedSchedule:stop()
					self.touchEndedSchedule = nil
					-- print("gggggggggggggggg", self.scrollPageTable[self.curPageIndex]:getPositionY(), self.deltay)
				end
			end 
		end
	end
	--print("******************************", self.touchEndedSchedule, self.click, self.deltay)
	if self.touchEndedSchedule == nil and not self.click then
		self.touchEndedSchedule = timer()
		self.touchEndedSchedule:start(0.016, runScroll) 
	end
	return true
end

-- 构造函数
function SScrollCell:__init(fatherPanel, tab, cellNumEveryPage, initFunc, initAccessoryFunc, pageObj)
	self.view = fatherPanel


	-- 这是计算加速度的时间间隔
	self.calculateATime = 0.03
	-- 
	self.deltay = 0
	-- y2表示点击的后滚动的采集点， 用于作差
	self.y2 = 0
	-- y1表示第一个点击的采集点，用于作差
	self.y1 = 0

	-- 记录着每个
	self.scrollPageTable = {}
	self.maxPage = 0
	self.cellNumEveryPage = 0

	-- 记录着touchBegan点击的Y轴坐标
	self.beganY = nil
	-- 记录着touchMoved点击的Y轴坐标
	self.movedY = nil
	-- 记录着X轴坐标,用于判断当触摸移除了panel之外则停掉调度器，不要再计算方向变量了
	self.touchX = nil

	-- touchBegan时的调度， 用于计算方向变量的变化值
	self.touchBeganSchedule = nil

	-- touchEnded时的调度，用于修正panel惯性滑动的距离
	self.touchEndedSchedule = nil

	--每一页的item的索引，用于控制Item的移动
	self.friendPanelItemIndex = nil

	-- 当前的页的索引，默认为1
	self.curPageIndex = 1
	-- 以前的页的索引, 默认为1
	self.lastPageIndex = 1

	-- 保存每个按钮的一些状态，即是否被按下弹出下方的小窗口
	self.itemState = {}

	-- 这两个暂时没用到
	self.touchTime = 0
	self.friendNum = 30
	
	-- 标识每一页最大的cell个数
	self.cellNumEveryPage = cellNumEveryPage

	-- 记录着每一个cell的初始化函数
	self.bindingInitFunc = initFunc
	-- 当作参数传进去bindingInitFunc内
	self.pageObj = pageObj

	-- 存储accessoryPanel的table
	self.accessoryPanelTable = {}
	--记录存储着初始化附属panel的函数
	self.initAccessoryFunc = initAccessoryFunc
	-- self:changePageByIndex(1, tab)

	-- 触摸的回调函数
	local function touchMove(eventType, x, y)
		if eventType == TOUCH_BEGAN then
			self:touchBegan(eventType, x, y)
			return true
		elseif eventType == TOUCH_MOVED then
			self:touchMoved(eventType, x, y)
			return true
		elseif eventType == TOUCH_ENDED then
			self:touchEnded()
			return true
		end
	end

	self.view:registerScriptHandler(touchMove)
	self.view:setEnableHitTest(false)
	self.view:setDefaultMessageReturn(true);

	--print("8888888888888888888888888888888", tostring(self.view), tostring(self))
	-- self:setMaxPage()
end

-- 设置每一页的cell个数
function SScrollCell:setCellNumEveryPage(num)
	--print("setCellNumEveryPage")
	self.cellNumEveryPage = num
end

-- 设置最大页数（页数应该会根据传进来的table和每一页的cell个数来进行计算，这个接口貌似没什么卵用，先留着）
function SScrollCell:setMaxPage()
	--print("setMaxPage==================")
end

-- 根据Index返回对应的scroll,返回的事装着scroll对象的table, 提供给外部去初始化对应页面的每一个cell
function SScrollCell:getScrollByIndex(index)
	if self.itemState[index] then
		return self.itemState[index]
	end
end

-- refresh函数，更新整个scroll
function SScrollCell:refreshScrollCell(tab)
-- function SScrollCell:refresh()
	-- 重置了self.itemState

	-- 先清除附属panel,然后再清除每个分页的panel，因为附属的panel是作为分页panel的子节点的，如果清除了分页panel,
	-- 会把附属panel给干掉，再移除附属panel就会报错
	for k, v in pairs(self.accessoryPanelTable) do
		--print("jjjjjjjjjjjjjjjjjjjjjjjjjjjj", k, v)
		if v then
			self.accessoryPanelTable[k]:removeFromParentAndCleanup(true)
			self.accessoryPanelTable[k] = nil
		end
	end

	for k, v in pairs(self.itemState) do
		for k1, v1 in pairs(v) do
			if k1 ~= "localZOrder" and k1 ~= "thisPageItemIndex" and v1.view then
				v1.view:removeFromParentAndCleanup(true)
				v1 = nil
			end
		end
		-- v = nil
		self.itemState[k] = nil
	end

	-- 重置self.scrollPageTable
	for k, v in pairs(self.scrollPageTable) do
		if v then
			v:removeFromParentAndCleanup(true)
			-- v = nil
			self.scrollPageTable[k] = nil
		end
	end

	-- self.bindingInitFunc(self.pageObj, index)
	self.maxPage = #tab
	self:changePageByIndex(1, tab)
end

-- 创建附属的panel(点击好友ITEM之后往下弹得panel)
function SScrollCell:createAccessoryPanel()
	--print("create  an  accessoryPanel", self.curPageIndex)
	local panel = CCBasePanel:panelWithFile(0, 0, self.width,90, "", 500, 500)
	return panel
end

-- 
function SScrollCell:bindAccessoryInitFunc(pageIndex, index)
	--print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$", self.accessoryPanelTable[pageIndex])
	if self.accessoryPanelTable[pageIndex] then
		self.initAccessoryFunc(self.pageObj, self.accessoryPanelTable[pageIndex], pageIndex, index)
	end
end

function SScrollCell:getPagaItemIndex(pageIndex)
	return self.itemState[pageIndex].thisPageItemIndex
end

function SScrollCell:getCurPageIndex()
	return self.curPageIndex
end

function SScrollCell:destroy()
	if self.touchEndedSchedule then
		self.touchEndedSchedule:stop()
		self.touchEndedSchedule = nil
	end
end


-- /////////////////////////////////////////////////////////////////
-- test模板

-- 参数说明 tab, width, height, cellNumEveryPage, initFunc, initAccessoryFunc, pageObj

-- 说明：tab的格式为 tab = {
-- 	[页数] = {[行数] = {...}， [行数] = {...}}
-- 	[1] = {[1] = {}, [2] = {}........},
-- 	[2] = {[1] = {}, [2] = {}........},
-- 	[3] = {[1] = {}, [2] = {}........},
-- 	......
-- }
-- width ：宽
-- height: 高
-- cellNumEveryPage :每一页有最多有多少个cell，（这个参数好像没用到）
-- initFunc:是初始化每一个cell的函数, 记得用点号（self.initFunc）
-- initAccessoryFunc:初始化附属面板的函数(即往下弹的那个面板), 记得用点号(self.initAccessoryFunc)
-- pageObj:对应页面的self（即调用initFunc和initAccessoryFunc的table对象）

--111111111111 -----------------------------------------------------
-- self.scrollCell = SScrollCell:create(friendTable, 836, 380, 20, self.initFriendScroll, self.initAccessory, self)
-- self.friendPanel:addChild(self.scrollCell)

--222222222222 -----------------------------------------------------
-- -- 初始每一个cell的函数，会传进来index, 记得这里是冒号
-- function SCTFriendPage:initFriendScroll(index)
-- 	-- local friendTable = FriendModel:get_my_frends()
-- 	local friendTable = FriendModel:get_sorted_my_friend()
-- 	-- 获得对应面板的所有cell对象
-- 	local cellTable = self.scrollCell:getScrollByIndex(index)
	
-- 	-- for循环这个cellTable来初始化每一个cell
-- 	for k, v in ipairs(cellTable) do
-- 		local name = SLabel:create(friendTable[index][k].roleName)
-- 		name.view:setPosition(CCPoint(100, 20))
-- 		v.view:addChild(name.view)
-- 	end
-- end

--333333333333 -------------------------------------------------
-- -- 初始附属面板的函数，accessoryPanel就是面板对象， 记得这里是冒号
-- function  SCTFriendPage:initAccessory(accessoryPanel)
-- 	-- local friendTable = FriendModel:get_my_frends()
-- 	local friendTable = FriendModel:get_sorted_my_friend()
-- 	-- 删除好友
-- 	local function deleteCB()
-- 		-- 获得页面的索引
-- 		local pageIndex = self.scrollCell:getCurPageIndex()
-- 		-- 获得具体某页的某一个cell的索引
-- 		local itemIndex = self.scrollCell:getPagaItemIndex(pageIndex)
-- 		-- 根据页面索引和cell索引来获得ID和其他发送协议需要的内容
-- 		local id = friendTable[pageIndex][itemIndex].roleId
-- 		-- 根据id发送协议
-- 		FriendCC:send_delete_friend_black_enemy(id, 1)
-- 	end

-- 	local deleteFriendBtn = SButton:create("sui/common/btn6.png")
-- 	deleteFriendBtn:set_click_func(deleteCB)
-- 	deleteFriendBtn:setPosition(-3 + 178 * 4, 22)
-- 	accessoryPanel:addChild(deleteFriendBtn.view)

-- 	local deleteLabel = SLabel:create("#c854d0d删除好友", 20)
-- 	deleteLabel:setPosition(18, 20)
-- 	deleteFriendBtn:addChild(deleteLabel.view)

-- end