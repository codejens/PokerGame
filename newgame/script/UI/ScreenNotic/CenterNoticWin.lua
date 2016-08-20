-----------------HJH
-----------------2013-3-14
-----------------主屏公告
super_class.CenterNoticWin(Window)
------------------------------

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

--local _window_size = { width = _refWidth(1.0), height = _refWidth(1.0) }

local _half_window_width = _refWidth(0.5)
------------------------------
local _center_notic_item_list = {}
local _center_notic_item_list_max_num = 3
------------------------------
local _center_notic_default_begin_pos_y = _refHeight(0.75)
local _center_notic_default_run_length = 90
local _center_notic_end_font_size = 18
local _center_notic_begin_font_size = 35
local _center_notic_max_wait_time = 1
local _center_notic_max_run_time = 2
------------------------------
local _default_font_size = 18
local _default_timer_stept = 0.002

local _messageTimer = timer()
local _messageQueue = {}
local _maxMessage  = 8 --最多是 8 + 1条

------------------------------
super_class.CenterNoticItem()
------------------------------
local _CenterNoticItemPool = {}
local _CenterNoticItemPoolSize = 10
local _center_notic_check_timer = timer()
local _message_gap = 20
local t_remove = table.remove
local t_insert = table.insert

-- 检查消息是否已经超过显示时间 5 秒跳
local function CheckShowingMsgTimeout(dt)
	local cc = tonumber(os.time())
	
	if #_center_notic_item_list > 0 then
		local i = 0
		while(#_center_notic_item_list > 0) do
			local last = _center_notic_item_list[1]
			----print("检查消息是否已经超过显示时间 5 秒跳",cc,last.starttime , _center_notic_max_run_time)		
			if cc - last.starttime > _center_notic_max_run_time then
				t_remove( _center_notic_item_list, 1)
				last:fadeout()
			else
				break
			end
			i = i + 1
			if i > _center_notic_item_list_max_num then
				break
			end
		end
	else
		_center_notic_check_timer:stop()
	end
end


function CenterNoticItem:__init(info, fontSize)
	local temp_info = SharedTools:format_screen_and_center_notic_info( info )
	local label = CCZXLabel:labelWithText( 0, 0, temp_info, fontSize, ALIGN_LEFT )
	local label_size = label:getSize()
	local basepanel = CCBasePanel:panelWithFile( 0, 0, 1, 1, "")

	basepanel:addChild(label)
	basepanel:setCurState(CLICK_STATE_DISABLE)
	self.view = basepanel
	self.label = label

	--初始化actions
	local scaleIn = CCScaleTo:actionWithDuration(0.2,1,1);
	local moveby = CCMoveBy:actionWithDuration(1.0,CCPointMake(0,200))
	local moveIn = CCEaseOut:actionWithAction(moveby,0.5);
	
	local remove = CCRemove:action()
	local array = CCArray:array();
	array:addObject(moveIn)
	array:addObject(remove)
	local seq = CCSequence:actionsWithArray(array);

	--两个阶段动作，进场和离场
	self.scaleIn = scaleIn
	self.moveout_action = seq

	--获取引用
	safe_retain(self.scaleIn)
	safe_retain(self.moveout_action)
	safe_retain(self.view)

	self.fadeout_timer = timer()
end

function CenterNoticItem:setInfo(info, fontSize, tPosY)
	----print("CenterNoticItem:setInfo info = ",info)
	local temp_info = SharedTools:format_screen_and_center_notic_info(info)
	--清空
	local label = self.label
	label:setText('')
	--仅仅改变属性
	label:setFontSize(fontSize)
	--重新设置值
	label:setText(temp_info)
	local label_size = label:getSize()
	self.view:setSize(label_size.width, label_size.height)
	local view = self.view
	view:setPosition( _half_window_width, tPosY )
	view:setAnchorPoint(0.5,0.0)
	label:setAlpha( 255 )
	view:setScale(2.5)
	view:stopAllActions()
	view:runAction(self.scaleIn)
end

--销毁
function CenterNoticItem:destory()
	safe_release(self.view)
	safe_release(self.moveout_action)
	safe_release(self.scaleIn)

	self.view = nil
	self.label = nil
	self.moveout_action = nil
	self.scaleIn = nil

	--self.fadeout_delay:cancel()
	self.fadeout_timer:stop()
end

--停止所有动作，从列表移除
function CenterNoticItem:stop()
	--self.view:stopAllActions()
	self.view:removeFromParentAndCleanup(true)
	--self.fadeout_delay:cancel()
	self.fadeout_timer:stop()
	--self.view:setIsVisible(false)
end

--淡出入口
function CenterNoticItem:fadeout()
	self.view:runAction(self.moveout_action)
	self.fadeout_t = 0
	self.fadeout_timer:stop()
	self.fadeout_timer:start(0, bind(self.dofadeout, self))
end

--通过timer做淡出
function CenterNoticItem:dofadeout(dt)
	self.fadeout_t = self.fadeout_t + dt
	local t = self.fadeout_t / 0.75 --淡出时间
	if t > 1.0 then
		self.fadeout_timer:stop()
		t = 1.0
	end
	self.label:setAlpha(255 - t * 255)
end

--初始化对象池
function CenterNoticItem_initPool()
	for i=1,_CenterNoticItemPoolSize do
		local item = CenterNoticItem('',_default_font_size)
		_CenterNoticItemPool[#_CenterNoticItemPool+1] = item
	end
end

--从对象池取出一个item
function CenterNoticItem_getitem()
	local item = t_remove(_CenterNoticItemPool,1)
	_CenterNoticItemPool[#_CenterNoticItemPool+1] = item 
	return item
end


--离开游戏场景，停止对象池
function CenterNoticItem_stopall()
	for i, item in ipairs(_center_notic_item_list) do
		item:stop()
	end
	_center_notic_item_list = {}
end

--退出游戏，清空对象池
function CenterNoticItem_OnQuit()
	for i,item in ipairs(_CenterNoticItemPool) do
		item:destory()
	end
	_CenterNoticItemPool = {}
	_center_notic_item_list = {}
end

------------------------------
local function doTick( dt )
	-- body
	if #_messageQueue == 0 then
		_messageTimer:stop()
	else
		local _job = table.remove(_messageQueue, 1)
		_job()
	end
end

function CenterNoticWin:create_center_notic(info, fontSize, x, y)
	if _messageTimer:isIdle() then
		_messageTimer:start(0.5,doTick)
	end
	--如果超过_maxMessage条，删除多余条目
	local n = #_messageQueue - _maxMessage
	if  n > 0 then
		for i=1, n do
			table.remove(_messageQueue, 1)
		end
	end
	_messageQueue[#_messageQueue+1] = function(...) self:__create_center_notic(info, fontSize, x, y) end
end

function CenterNoticWin:__create_center_notic(info, fontSize, x, y)
	local tFontSize = fontSize
	local tPosX = x
	local tPosY = y
	local tInfo = info
	if info == "" then
		return
	end
	if fontSize == nil then
		tFontSize = _center_notic_end_font_size
	end
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = _center_notic_default_begin_pos_y
	end

	--所有已有的item向上移动
	for i, item in ipairs(_center_notic_item_list) do
		local view = item.view
		if view:getParent() == nil then
		else
			local y = view:getPositionY()
			y = y + _message_gap
			view:setPositionY(y)
		end
	end

	--从对象池里面拿一个出来
	local item = CenterNoticItem_getitem()

	--如果显示列表超过3个，让最早的一个消失
	t_insert( _center_notic_item_list, item)
	if #_center_notic_item_list > _center_notic_item_list_max_num then
		local last = t_remove( _center_notic_item_list, 1)
		--向上移动并消失
		last:fadeout()
	end	

	--重新设置消息
	item:stop()
	item:setInfo(info,tFontSize,tPosY)
	item.starttime = tonumber(os.time())
	
	--添加到屏幕
	local center_notic_win = UIManager:find_window("center_notic_win")
	center_notic_win.view:addChild(item.view)

	--初始化检查 timer ，每5秒检查一次显示列表，让最早的一条消失
	if _center_notic_check_timer:isIdle() then
		_center_notic_check_timer:start(_center_notic_max_run_time, CheckShowingMsgTimeout)
	end
end
------------------------------
------------------------------
function CenterNoticWin:__init(window_name, texture_name, pos_x, pos_y, width, height)
	self.view:setCurState(CLICK_STATE_DISABLE)
	CenterNoticItem_initPool()
end
------------------------------
------------------------------
function CenterNoticWin:clear_all_item()
	CenterNoticItem_stopall()		
end


function CenterNoticWin.scene_leave()
	_messageTimer:stop()
	_messageQueue = {}
end

function CenterNoticWin.onPause()
	_messageTimer:stop()
	_messageQueue = {}
end