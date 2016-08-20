---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------滑动条
super_class.ScrollPage(AbstractBasePanel)
---------
---------
local function ScrollPageCreateFunction(self, width, height, x, y, maxnum, scrollType, gapSize)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tMaxNum = maxnum
	local tType = scrollType
	local tGapSize = gapSize
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = 0
	end
	if height == nil then
		tHeight = 0
	end
	if maxnum == nil then
		tMaxNum = 1 
	end
	if scrollType == nil then
		tType = TYPE_VERTICAL_EX
	end
	if gapSize == nil then
		tGapSize = 0
	end
	---------
	self.view = CCScrollEx:scrollWithFile( tPosX, tPosY, tWidth, tHeight, tMaxNum, tType, tGapSize)
end
---------
---------
function ScrollPage:registerScriptFun()
	if self.view ~= nil then
		local function scrollMessageFun(eventType, arg, msgid, selfItem)
			-------
			if eventType == nil or arg == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				if self.touch_begin_fun ~= nil then
					self.touch_begin_fun()
				end
				return self.touch_begin_return
			elseif eventType == TOUCH_MOVED then
				if self.touch_move_fun ~= nil then
					self.touch_move_fun()
				end
				return self.touch_move_return
			elseif eventType == TOUCH_ENDED then
				if self.touch_end_fun ~= nil then
					self.touch_end_fun()
				end
				return self.touch_end_return
			elseif eventType == TOUCH_CLICK then
				if self.touch_click_fun ~= nil then
					self.touch_click_fun()
				end
				return self.touch_click_return
			elseif eventType == TOUCH_DOUBLE_CLICK then
				if self.touch_double_click_fun ~= nil then
					self.touch_double_click_fun()
				end
				return self.touch_double_click_return
			elseif eventType == TIMER then
				if self.touch_timer_fun ~= nil then
					self.touch_timer_fun()
				end
				return true
			elseif eventType == SCROLL_CREATE_ITEM then
				require "utils/Utils"
				local temp = Utils:Split(arg, ":")
				local xOrder = temp[1]
				local yOrder = temp[2]
				if self.scrollCreateFun ~= nil then
					local item = self.scrollCreateFun(nil,tonumber(xOrder))
					if item ~= nil then
						self:addItem(item)
						----print("self.auto_refresh",self.auto_refresh)
						--if self.auto_refresh == true then
							self:refresh()
						--end
					end
				end
				return true
			end
		end
		-------
		self.view:registerScriptHandler(scrollMessageFun)
	end
end
---------
---------
function ScrollPage:__init(fatherPanel)
	self.scrollImage = nil
	self.scrollCreateFun = nil
	self.scrollLocatePoint = nil
	self.selectImage = nil
	self.normalImage = nil
	self.locatePointWidth = nil
	self.locatePointHeight = nil
	self.locatePointGapSize = nil
end
---------
---------
function ScrollPage:create(fatherPanel, x, y, width, height, maxnum, type, gapSize)
	local sprite = ScrollPage(fatherPanel)
	ScrollPageCreateFunction( sprite, width, height, x, y, maxnum, type, gapSize)
	sprite:registerScriptFun()
	return sprite
end
---------
---------
function ScrollPage:setScrollCreatFunction(userFunction)
	self.scrollCreateFun = userFunction
end
---------
---------
function ScrollPage:setScrollImagePos(pos)
	if self.view ~= nil then
		self.view:setScrollImagePos(pos)
	end
end
---------
---------
function ScrollPage:setScrollImageFile(image, width, height)
	if self.view ~= nil then
		self.view:setScrollLump(image, width, height)
	end
end
---------
---------
function ScrollPage:setCurIndexPage(index)
	if self.view ~= nil then
		self.view:setCurIndexPage(index)
	end
end
---------
---------
function ScrollPage:getMaxNum()
	if self.view ~= nil then
		return self.view:getMaxNum()
	else
		return 0
	end
end
---------
---------
function ScrollPage:getCurIndexPage()
	if self.view ~= nil then
		return self.view:getCurIndexPage()
	else
		return 0
	end
end
---------
---------
function ScrollPage:refresh()
	if self.view ~= nil then
		self.view:refresh()
	end
end
---------
---------
function ScrollPage:addItem(item)
	if self.view ~= nil then
		self.view:addItem(item.view)
	end
end
---------
---------
function ScrollPage:clear()
	if self.view ~= nil then
		self.view:clear()
	end
end
---------
---------
function ScrollPage:setMaxNum(num)	
	if self.view ~= nil then
		self.view:setMaxNum(num)
		if self.scrollLocatePoint ~= nil then
			local locatePointNum = #self.scrollLocatePoint
			if num > locatePointNum then
				for i = 1, locatePointNum - num do
					local temp = CheckBox:create( nil, 0, 0, self.locatePointWidth, self.locatePointHeight, {self.normalImage, self.selectImage} )
					table.insert( self.scrollLocatePoint, temp )
				end
			elseif num < locatePointNum then
				for i = 1 , locatePointNum - num do
					table.remove( self.scrollLocatePoint )
				end
			end
		end
		-- self:reinitScrollLocatePos()
		-- local curPage = self.view:getCurPageNum()
		-- self:updateScrollLocateState(curPage + 1)
	end
end
---------
---------
function ScrollPage:getCurPageNum()
	if self.view ~= nil then
		return self.view:getCurPageNum()
	else
		return 0
	end
end
---------
---------
function ScrollPage:initLocatePoint(normalImage, selectImage, width, height, gapSize)
	self.scrollLocatePoint = {}
	self.selectImage = selectImage
	self.normalImage = normalImage
	self.locatePointWidth = width
	self.locatePointHeight = height
	self.locatePointGapSize  = gapSize
	local scrollMaxNum = self.view:getMaxNum()
	for i = 1 , scrollMaxNum do
		local temp = CheckBox:create( nil, 0, 0, width, height, {normalImage, selectImage} )
		table.insert( self.scrollLocatePoint, temp )
		self.view:addChild( temp.view )
	end
	self:reinitScrollLocatePos()
	local curPage = self.view:getCurPageNum()
	self:updateScrollLocateState(curPage + 1)
end
---------
---------
function ScrollPage:updateScrollLocateState(index)
	for i = 1, #self.scrollLocatePoint do
		if i == index then
			self.scrollLocatePoint[i]:setCurState(CLICK_STATE_DOWN)
		else
			self.scrollLocatePoint[i]:setCurState(CLICK_STATE_UP)
		end
	end
end
---------
---------
function ScrollPage:reinitScrollLocatePos()
	local scrollMaxNum = self.view:getMaxNum()
	local beginPosX , beginPosY
	local scrollType = self.view:getScrollType()
	local scrollSize = self.view:getSize()
	if scrollType == TYPE_VERTICAL_EX then
		beginPosX = ( scrollSize.width - self.locatePointWidth * scrollMaxNum - self.locatePointGapSize * ( scrollMaxNum - 1 ) ) * 0.5
		beginPosY = - self.locatePointHeight
	else
		beginPosX = scrollSize.width + self.locatePointWidth
		beginPosY = ( scrollSize.height - self.locatePointHeight * scrollMaxNum - self.locatePointGapSize * ( scrollMaxNum - 1 ) ) * 0.5
	end
	for i = 1 , #self.scrollLocatePoint do
		self.scrollLocatePoint[i].view:setPosition( beginPosX, beginPosY )
		if scrollType == TYPE_VERTICAL_EX then
			beginPosX = beginPosX - self.locatePointGapSize - self.locatePointWidth
		else
			beginPosY = beginPosY + self.locatePointGapSize + self.locatePointHeight
		end
	end
end
---------
---------
function ScrollPage:setAutoRefresh(result)
	self.auto_refresh = result
end