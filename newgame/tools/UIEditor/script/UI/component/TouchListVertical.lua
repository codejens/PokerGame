-- TouchList.lua

--!!!!!!!!!!!
-- 注意使用完毕必须调用destroy
--!!!!!!!!!!!

TouchItem = {}

super_class.TouchListVertical()

_max = math.max
_min = math.min

local TouchListCount = 0

function clamp(x,minVal,maxVal)
	return _min(_max(x,minVal),maxVal)
end

function smoothstep(edge0,edge1,x)
	-- body
	local t = clamp((x-edge0) / (edge1-edge0),0.0,1.0)
	return t * t * ( 3.0 - 2.0 * t)
end

--new函数
function TouchItem:new( ... )
    local i = {}
    setmetatable(i, self)
    self.__index = self
	i:__init( ... )
    return i
end

function TouchItem:__init( view )
	self.view = view
end


function TouchListVertical:__init( x, y, width, height,
						   --item高度，间隔
						   itemheight, gap )

	self.view = CCTouchPanel:touchPanel(x,y,width,height)
	self.list = CCBasePanel:panel()
	self.list:setEnableHitTest(false)
	--所有item可见
	self.items = {}
	--可回收item
	self.unuseditem = {}
	--list y pos
	self.top = 0
	--空间高度
	self.height = height
	--惯性模拟timer
	self.move_timer = timer()
	--需要恢复
	self.needrestore = false
	--是否正在移动
	self.TouchMoved = false
	--惯性模拟参数，速度mod
	self.speedmodifier = 1.0
	--惯性模拟参数，时间累积
	self.mt = 1.0
	--滚轴位置
	self.scroll_t = -1.0
	--脚本存储

	--在停下来的时候，自动
	self.auto_pos_onStop = false
	local function basePanelMessageFun(eventType, args, msgid, selfItem)
			-------
			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				x,y = string.match(args,"(-?%d+):(-?%d+)")
				self.TouchMoved = false
				return self:TouchBegin(x,y)

			elseif eventType == TOUCH_MOVED then
				x,y = string.match(args,"(-?%d+):(-?%d+)")
				------print(y)
				self.TouchMoved = true
				return self:TouchMove(x,y)

			elseif eventType == TOUCH_ENDED then
				x,y = string.match(args,"(-?%d+):(-?%d+)")
				self:TouchEnd(x,y)
				------print(self.TouchMoved)
				if self.TouchMoved then
					return true
				else
					return false
				end
			end

			return false
		end

	self.view:addChild(self.list,5)
	self.view:registerScriptHandler(basePanelMessageFun)

	safe_retain(self.view)

end

-- itemheight   每一行高
-- gap 		    空隙
-- visCount 	可见行数
-- datalist 	数据内容
-- resetfunc    重置函数，用于创建和重置内容
-- movefunc     当item被移动的时候回调，可为空，用于重置状态，如按钮处于按下时，此时如果正在移动应该将按钮重置为普通状态
function TouchListVertical:BuildList(itemheight, gap, visCount, datalist, resetfunc, movefunc)

	self.itemheight = itemheight
	self.gap = 0
	self.visCount = visCount
	self.data = datalist
	self.visible_height = self.height
	self.total_height = #datalist * itemheight
	self.scrollable_height = self.total_height - self.visible_height
	self.resetfunc = resetfunc
	self.movefunc = movefunc

	if self.scrollable_height <= 0 then
		self.scrollable_height = -1
	end

	local height = self.height

	for i,v in ipairs(datalist) do
		----print("TouchListVertical:BuildList(v)",v)
		local c = resetfunc(v,nil)
		self.list:addChild(c.view,5)
		height = height- itemheight
		c.view:setPositionY(height)
		self.items[i] = c
		if i == visCount then
			break
		end
	end
end

function TouchListVertical:TouchBegin(x,y)
	if not y then
		return false
	end
	self.touchbegin_x = x
	self.touchbegin_y = y
	self.last_x = x
	self.last_y = y
	self.move_timer:stop()
	--self.view:setEnableHitTest(true)
	return true
end


function TouchListVertical:TouchMove(x,y)
	if not y then
		return true
	end
	self:move(y-self.last_y)
	self.last_y = y
	--self.view:setEnableHitTest(false)
	return true
end

function TouchListVertical:TouchEnd(x,y)
	if not y or not self.touchbegin_y then
		return true
	end

	if not self:restorePos(true) then
		local dst = math.abs(y - self.touchbegin_y)
		if dst > 96 then
			--一秒移动距离为 半个行高的24分之一，也就是每秒24帧的移动动画，移动距离为半行
			dst = math.max(dst, self.itemheight * 0.5) / 24
			local dty = dst
			if y - self.touchbegin_y < 0 then
				dty = -dst
			end
			self.move_timer:stop()
			self.speedmodifier = 1.0
			self.mt = 1.0
			self.move_timer:start(0, function(t) self:timerMove(dty, t) end)
		else
			self.move_timer:stop()
			self:onStop()
		end
	end
	--self.view:setEnableHitTest(true)
	return true
end

function TouchListVertical:timerMove(dt,t)
	self.mt = self.mt - t
	dt = dt * smoothstep(0.1,0.9,self.mt)
	self:_move(dt)
	self:restorePos()
	self.speedmodifier = self.speedmodifier * 0.90
	if dt == 0 then
		self.move_timer:stop()
		self:onStop()
	end
end

--磁力感应，当行到最高或最低时反应
function TouchListVertical:restorePos(e)
	if self.needrestore or e then
		local py = self.list:getPositionY()
		if py < self.top then
			local move_to = CCMoveTo:actionWithDuration(0.1,CCPoint(0,self.top));
			self.list:stopAllActions()
			self.list:runAction(move_to)
			self.move_timer:stop()
			self.needrestore = false
			return true

		elseif py > self.scrollable_height then
			local ty = _max(0,self.scrollable_height)
			local move_to = CCMoveTo:actionWithDuration(0.1,CCPoint(0,ty));
			self.list:stopAllActions()
			self.list:runAction(move_to)
			self.move_timer:stop()
			self.needrestore = false
			return true
		end
		
	end
	return false
end

function TouchListVertical:move(dt)
	--if self.move_timer
	self.move_timer:stop()
	self:_move(dt)
end

function TouchListVertical:_move(d, force)
	if d == 0 and not force then
		return
	end
	local y = self.list:getPositionY()
	y = y + d
	--磁力上边下边
	local ma = self.itemheight / 4.0 
	if y < -ma then
		y = -ma
		self.needrestore = true
	end	
	if self.scrollable_height > 0 then
		if y > self.scrollable_height + ma then
			y = self.scrollable_height + ma
			self.needrestore = true
		end
	else
		if y > ma then
			y = ma
			self.needrestore = true
		end
	end

	if d ~= 0 then
		--减少像素抖动，pixel map
		self.list:setPositionY(math.ceil(y + 0.5))
	end
	
	if y < 0 then
		y = 0
	end	
	
	if y > self.scrollable_height then
		y = self.scrollable_height
	end
	
	if self.scrollable_height > 0  then
		self:updateList(y/self.scrollable_height)
	end
	------print('>>>>>',self.scrollable_height,self.list:getPositionY())
end

function TouchListVertical:updateList(clampt)
	self.scroll_t = clampt
	local t = (clampt) * (#self.data - self.visCount) 
	self.topitem = math.floor(t) + 1
	local bottom = math.ceil(t + self.visCount)
	self.bottomitem = bottom
	self.top = clampt * self.scrollable_height

	--回收不可见item
	for k,comp in pairs(self.items) do
		if k < self.topitem then
			comp.view:setIsVisible(false)
			self.items[k] = nil
			self.unuseditem[#self.unuseditem+1] = comp
			------print('可回收item', #self.unuseditem)

		elseif k > bottom then
			comp.view:setIsVisible(false)
			self.items[k] = nil
			self.unuseditem[#self.unuseditem+1] = comp
			------print('可回收item', #self.unuseditem)
		else
			if self.movefunc then
				self.movefunc(comp)
			end
		end
	end
	
	--创建可见item
	for i = self.topitem, self.bottomitem do
		local comp = self.items[i]
		local info = self.data[i]
		if not comp and info then
			local newcomp = nil
			if #self.unuseditem > 0 then
			--	问题的重点
				newcomp = table.remove(self.unuseditem)
				self.resetfunc(info,newcomp)
			else
				newcomp = self.resetfunc(info)
				self.list:addChild(newcomp.view)
			end
			local y = (i) * self.itemheight
			newcomp.view:setPositionY(self.height - y)
			newcomp.view:setIsVisible(true)
			self.items[i] = newcomp
			------print('>>>> visible items',y,i,self.topitem,self.bottomitem)
		end

	end
end

--刷新全部数据
function TouchListVertical:refresh(datalist)
	--if true then return end
	self.data = datalist or self.data
	local height = self.height
	--重算高度
	self.total_height = #self.data * self.itemheight
	self.scrollable_height = self.total_height - self.visible_height

	if self.scrollable_height <= 0 then
		self.scrollable_height = -1
	end

	for k,comp in pairs(self.items) do
		comp.view:setIsVisible(false)
		self.items[k] = nil
		self.unuseditem[#self.unuseditem+1] = comp
	end

	local y = self.list:getPositionY()

	local clampt = clamp(y/self.scrollable_height,0.0,1.0)

	self.list:setPositionY(clampt * self.scrollable_height)
	self:updateList(clampt)
end

--刷新某个数据
function TouchListVertical:refresh_item(i,info)
	if info then
		self.data[i] = info
	end

	local comp = self.items[i]
	if comp then
		self.resetfunc(self.data[i],comp)
	end
end

--销毁TouchList
function TouchListVertical:destroy()
	self.view:removeFromParentAndCleanup(true)
	--所有item可见
	self.items = {}
	--可回收item
	self.unuseditem = {}
	--删除
	safe_release(self.view)
	--清除
	self.view = nil

	self.move_timer:stop()
end

function TouchListVertical.CheckRetain()
	if TouchListCount > 0 then
		error('unreleased TouchListVertical')
	end
end

function TouchListVertical:setIndex(index)
	local move = (index - 1) * self.itemheight
	self.list:setPositionY(move)
	local t = clamp(move/self.scrollable_height,0.0,1.0)
	self:updateList(t)
end

function TouchListVertical:gotoPosition(y)
	self.list:setPositionY(y)
	local t = clamp(y/self.scrollable_height,0.0,1.0)
	self:updateList(t)
end

function TouchListVertical:_TimeLerpTick(dt)
	self.t_pass = self.t_pass + dt
	local t = self.t_pass / self.t_dur
	if t > 1.0 then
		self:gotoPosition(self.t_dy)
		self.move_timer:stop()
		return
	end

	local y = (self.t_dy - self.t_sy) * t + self.t_sy 
	self:gotoPosition(y)
end

function TouchListVertical:onStop()
	if self.auto_pos_onStop then
		local ma = self.itemheight / 2.0
		local item = nil
		local key = nil
		local y = nil
		for k, comp in pairs(self.items) do
			local topY = comp.view:getPositionY() - self.itemheight
			local ftop = topY + self.top
			if math.abs(ftop) < ma then
				item = comp
				key = k
				y = topY
				ma = math.abs(ftop)
			end
		end

		if item then
			self.t_pass = 0
			self.t_dur = 0.25
			self.t_dy = -y
			self.t_sy = self.list:getPositionY()
			self.move_timer:stop()
			self.move_timer:start(0, function(dt) self:_TimeLerpTick(dt) end)
		end
	end
end

function TouchListVertical:setIsVisible(state)
	self.view:setIsVisible(state)
end

function TouchListVertical:clear()
	self.list:setPositionY(0)
	for k,comp in pairs(self.items) do
		comp.view:setIsVisible(false)
		self.items[k] = nil
		self.unuseditem[#self.unuseditem+1] = comp
	end
end