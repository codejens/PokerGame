---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------滑动条
super_class.ZScroll(ZAbstractBasePanel)
---------
---------
local function ScrollCreateFunction(self, width, height, x, y, maxnum, scrollType)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tMaxNum = maxnum
	local tType = scrollType
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
		tType = TYPE_HORIZONTAL
	end
	---------
	self.view = CCScroll:scrollWithFile( tPosX, tPosY, tWidth, tHeight, tMaxNum, "", tType )
	--self.view = CCScroll:scrollWithFile( tPosX, tPosY, tWidth, tHeight, tMaxNum, "ui/common/nine_grid_bg.png", tType, 600, 600)
end
---------
---------
function ZScroll:registerScriptFun()
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
			elseif eventType == SCROLL_FINISH_SCROLL then
				if self.finish_scroll_fun ~= nil then
					self.finish_scroll_fun()
				end
			elseif eventType == SCROLL_CREATE_ITEM then
				require "utils/Utils"
				local temp = Utils:Split(arg, ":")
				local xOrder = temp[1]
				local yOrder = temp[2]
				--print("self.scrollCreateFun ",self.scrollCreateFun )
				if self.scrollCreateFun ~= nil then
					local item = self:scrollCreateFun( tonumber(xOrder), self.scroll_create_info)
					if item ~= nil then
						self:addItem(item)
						self:refresh()
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
function ZScroll:__init(fatherPanel)
	self.father_panel = fatherPanel
	self.scrollImage = nil
	self.scrollCreateFun = nil
end
---------
---------
function ZScroll:create(fatherPanel, fun, x, y, width, height, maxnum, type, z)
	local sprite = ZScroll(fatherPanel)
	ScrollCreateFunction( sprite, width, height, x, y, maxnum, type)
	sprite:registerScriptFun()
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			if z ~= nil then 
				fatherPanel.view:addChild( sprite.view, z )
			else
				fatherPanel.view:addChild( sprite.view )
			end
		else
			if z ~= nil then
				fatherPanel:addChild( sprite.view, z )
			else
				fatherPanel:addChild( sprite.view )
			end
		end
	end
	if fun ~= nil then
		sprite:setScrollCreatFunction( fun )
	end
	return sprite
end
---------
---------
function ZScroll:setScrollCreatFunction(userFunction)
	self.scrollCreateFun = userFunction
end
---------
---------
function ZScroll:setScrollImagePos(pos)
	if self.view ~= nil then
		self.view:setScrollLumpPos(pos)
	end
end
---------
function ZScroll:setScrollLumpPos(pos)
	if self.view ~= nil then
		self.view:setScrollLumpPos(pos)
	end
end
---------
---------
function ZScroll:getMaxNum()
	if self.view ~= nil then
		return self.view:getMaxNum()
	else
		return 0
	end
end
---------
---------
function ZScroll:refresh()
	if self.view ~= nil then
		self.view:refresh()
	end
end
---------
---------
function ZScroll:addItem(item)
	if item.view ~= nil then
		self.view:addItem(item.view)
	else
		self.view:addItem( item )
	end
end
---------
---------
function ZScroll:clear()
	if self.view ~= nil then
		self.view:clear()
	end
end
---------
---------
function ZScroll:setMaxNum(num)	
	if self.view ~= nil then
		self.view:setMaxNum(num)
	end
end
---------
---------
function ZScroll:setScrollCreateInfo(info)
	self.scroll_create_info = info
end
---------
---------
function ZScroll:setFinishScrollFunction(fun)
	self.finish_scroll_fun = fun
end
---------
---------
function ZScroll:setScrollLump( width, height, itemsize )
	--打开滚动条 by HWL
	self.view:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, width, height, itemsize)
	-- self.view:setScrollLump("","", 4, height, itemsize)
end