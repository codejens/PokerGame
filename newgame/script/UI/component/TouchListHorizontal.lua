------------------------------------------------------------
--require 'UI/component/TouchList'
super_class.TouchListHorizontal()

local TouchListCount = 0
--!!!!!!!!!!!
-- 注意使用完毕必须调用destroy
--!!!!!!!!!!!
function TouchListHorizontal:__init( x, y, width, height,
						   --item高度，间隔
						   itemheight, gap )

	self.view = CCTouchPanel:touchPanel(x,y,width,height)
	self.list = CCBasePanel:panel()
	self.list:setEnableHitTest(false)
	--self.view:setScrollWithoutHittest(true)
	--所有item可见
	self.items = {}
	--可回收item
	self.unuseditem = {}
	--list y pos
	self.top = 0

	self.width = width
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

	local function basePanelMessageFun(eventType, args, msgid, selfItem)
			-------
			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				x,y = string.match(args,"(%d+):(%d+)")
				self.TouchMoved = false
				return self:TouchBegin(x,y)

			elseif eventType == TOUCH_MOVED then
				x,y = string.match(args,"(%d+):(%d+)")
				------print(y)
				self.TouchMoved = true
				return self:TouchMove(x,y)

			elseif eventType == TOUCH_ENDED then
				x,y = string.match(args,"(%d+):(%d+)")
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
function TouchListHorizontal:BuildList(itemheight, gap, visCount, datalist, resetfunc, movefunc)

	self.itemheight = itemheight
	self.gap = 0
	self.visCount = visCount
	self.data = datalist
	self.visible_height = visCount * itemheight
	self.total_height = #datalist * itemheight
	self.scrollable_height = self.total_height - self.visible_height
	self.resetfunc = resetfunc
	self.movefunc = movefunc

	if self.scrollable_height <= 0 then
		self.scrollable_height = -1
	end

	local x = 0

	for i,v in ipairs(datalist) do
		local c = resetfunc(v,nil)
		self.list:addChild(c.view,5)
		c.view:setPositionX(x)
		x = x + self.itemheight
		self.items[i] = c
		if i == visCount then
			break
		end
	end
end

function TouchListHorizontal:TouchBegin(x,y)
	if not x then
		return false
	end
	self.touchbegin_x = x
	self.last_x = x
	self.move_timer:stop()
	--self.view:setEnableHitTest(true)
	return true
end


function TouchListHorizontal:TouchMove(x,y)
	if not x then
		return true
	end
	self:move(x-self.last_x)
	self.last_x = x
	--self.view:setEnableHitTest(false)
	return true
end

function TouchListHorizontal:TouchEnd(x,y)
	if not x or not self.touchbegin_x then
		return true
	end

	if not self:restorePos(true) then
		local dst = math.abs(x - self.touchbegin_x)
		if dst > 128 then
			--一秒移动距离为 半个行高的24分之一，也就是每秒24帧的移动动画，移动距离为半行
			dst = math.max(dst, self.itemheight * 0.5) / 24
			local dtx = dst
			if x - self.touchbegin_x < 0 then
				dtx = -dst
			end
			self.move_timer:stop()
			self.speedmodifier = 1.0
			self.mt = 1.0
			self.move_timer:start(0, function(t) self:timerMove(dtx, t) end)
		else
			self.move_timer:stop()
			self:onStop()
		end
	end
	--self.view:setEnableHitTest(true)
	return true
end

function TouchListHorizontal:timerMove(dt,t)
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
function TouchListHorizontal:restorePos(e)

	if self.needrestore or e then
		local px = self.list:getPositionX()
		if px > 0 then
			local move_to = CCMoveTo:actionWithDuration(0.1,CCPoint(0,0));
			self.list:stopAllActions()
			self.list:runAction(move_to)
			self.move_timer:stop()
			self.needrestore = false
			return true
		elseif px < -self.scrollable_height then
			local tx = -self.scrollable_height
			local move_to = CCMoveTo:actionWithDuration(0.1,CCPoint(tx,0));
			self.list:stopAllActions()
			self.list:runAction(move_to)
			self.move_timer:stop()
			self.needrestore = false
			return true
		end
	end
	return false
end

function TouchListHorizontal:move(dt)
	self.move_timer:stop()
	self:_move(dt)
end

function TouchListHorizontal:_move(d, force)
	if d == 0 and not force then
		return
	end
	local x = self.list:getPositionX()
	x = x + d
	--磁力上边下边
	local ma = self.itemheight / 4.0 
	if x > ma then
		x = ma
		self.needrestore = true
	else
		if self.scrollable_height > 0 then
			if x < - (self.scrollable_height + ma) then
				x = - (self.scrollable_height + ma)
				self.needrestore = true
			end
		end
	end
	if d ~= 0 then
		--减少像素抖动，pixel map
		self.list:setPositionX(math.ceil(x + 0.5))
	end
	if self.scrollable_height > 0  then
		self:updateList(-x/self.scrollable_height)
	end
end

function TouchListHorizontal:updateList(clampt)
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
				newcomp = table.remove(self.unuseditem)
				self.resetfunc(info,newcomp)
			else
				newcomp = self.resetfunc(info)
				self.list:addChild(newcomp.view)
			end
			local x = (i - 1) * self.itemheight
			newcomp.view:setPositionX(x)
			newcomp.view:setIsVisible(true)
			self.items[i] = newcomp
			------print('>>>> visible items',y,i,self.topitem,self.bottomitem)
		end

	end
end

--刷新全部数据
function TouchListHorizontal:refresh(datalist)
	
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

	local x = self.list:getPositionX()

	local clampt = clamp(x/self.scrollable_height,0.0,1.0)

	self.list:setPositionX(clampt * self.scrollable_height)
	self:updateList(clampt)
end


--刷新某个数据
function TouchListHorizontal:refresh_item(i,info)
	if info then
		self.data[i] = info
	end

	local comp = self.items[i]
	if comp then
		self.resetfunc(self.data[i],comp)
	end
end

--销毁TouchList
function TouchListHorizontal:destroy()
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

function TouchListHorizontal.CheckRetain()
	if TouchListCount > 0 then
		error('unreleased TouchListHorizontal')
	end
end

function TouchListHorizontal:setIndex(index)
	local move = (index - 1) * self.itemheight
	self.list:setPositionX(-move)
	local t = clamp(move/self.scrollable_height,0.0,1.0)
	self:updateList(t)
end

function TouchListHorizontal:getLeftIndex( )
	if not self.topitem then
		self.topitem = 1
	end
	return self.topitem < 1 and 1 or self.topitem
end

function TouchListHorizontal:gotoPosition(x)
	self.list:setPositionX(-x)
	local t = clamp(x/self.scrollable_height,0.0,1.0)
	self:updateList(t)
end

function TouchListHorizontal:_TimeLerpTick(dt)
	self.t_pass = self.t_pass + dt
	local t = self.t_pass / self.t_dur
	if t > 1.0 then
		self:gotoPosition(self.t_dx)
		self.move_timer:stop()
		return
	end

	local x = (self.t_dx - self.t_sx) * t + self.t_sx 
	self:gotoPosition(x)
end

function TouchListHorizontal:onStop()
	local ma = self.itemheight / 2.0
	local item = nil
	local key = nil
	local x = nil
	for k, comp in pairs(self.items) do
		local topX = comp.view:getPositionX()
		local ftop = topX - self.top
		if math.abs(ftop) < ma then
			item = comp
			key = k
			x = topX
			ma = math.abs(ftop)
		end
	end
	if item then
		self.t_pass = 0
		self.t_dur = 0.25
		self.t_dx = x
		self.t_sx = -self.list:getPositionX()
		self.move_timer:stop()
		self.move_timer:start(0, function(dt) self:_TimeLerpTick(dt) end)
	end
end