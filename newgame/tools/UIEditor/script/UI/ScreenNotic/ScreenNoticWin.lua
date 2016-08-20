------------------------------
------------------------------
----HJH
----2013-2-27
----跑马灯
------------------------------
super_class.ScreenNoticWin(Window)
------------------------------

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

--local _window_size = { width = 800, height = 480 }
------------------------------
local _screen_notic_default_begin_pos_x = 600 - 40
local _screen_notic_default_begin_pos_y = 200 - 30
local _screen_notic_default_run_length = 150
local _screen_notic_default_mid_percent = 0.7
local _screen_notic_default_per_move = 3.5
local _screen_notic_default_wait_time = 0.45
------------------------------
local _default_font_size = 16
local _default_timer_stept = 0.002
------------------------------
local _run_self_timer = false
local _self_timer_rate = 0.01
local _next_target_delta_max_time = _screen_notic_default_wait_time
local _cur_target_delta_time = 0
local _screen_notic_data = {}
local _screen_center_target = nil
local _screen_notic_item_list = {}
local _screen_notic_item_list_max_num = 1
------------------------------
super_class.ScreenNoticItem()
------------------------------
local _calculateScreenPos = UIScreenPos.calculateScreenPos

function ScreenNoticItem:__init(info, fontSize)
	local temp_info = ChatModel:format_screen_and_center_notic_info( info )
	--xprint("ScreenNoticItem:__init info",temp_info)
	local x_border = 5
	local y_border = 3
	local label = CCZXLabel:labelWithText( x_border, y_border, temp_info, fontSize, ALIGN_LEFT )
	local label_size = label:getSize()
	local basepanel = CCBasePanel:panelWithFile( 0, 0, label_size.width+x_border*2, label_size.height+y_border*2,UILH_COMMON.paomadeng,500,500)
	basepanel:addChild(label)
	basepanel:setCurState(CLICK_STATE_DISABLE)
	self.view = basepanel
	self.label = label
	label:setAlpha( 0 )
	label:setColor(0x00f1e7d4)
	basepanel:setTimer(_default_timer_stept)
end
------------------------------
function ScreenNoticWin:create_notic_item()
	if type(_screen_notic_data) == 'table' and #_screen_notic_data > 0 then
		local temp_data_info = _screen_notic_data[1]
		table.remove(_screen_notic_data, 1)
		local tFontSize = temp_data_info.fontSize
		local tPosX = temp_data_info.x
		local tPosY = temp_data_info.y
		local tInfo = temp_data_info.info
		if temp_data_info.info == "" then
			return
		end
		if temp_data_info.fontSize == nil then
			tFontSize = _default_font_size
		end
		if temp_data_info.x == nil then
			tPosX = _screen_notic_default_begin_pos_x
		end
		if temp_data_info.y == nil then
			tPosY = _screen_notic_default_begin_pos_y
		end
		local notic_item = ScreenNoticItem(tInfo, tFontSize)
		local notic_item_size = notic_item.view:getSize()
		local win_size = { width = _refWidth(1), height = _refHeight(1) }
		if tPosX + notic_item_size.width / 2 > win_size.width then
			tPosX = win_size.width - notic_item_size.width / 2 - 10
		end
		notic_item.view:setPosition( tPosX - notic_item_size.width / 2, tPosY )
		notic_item.begin_pos_y = tPosY
		notic_item.end_pos_y = tPosY + _screen_notic_default_run_length
		notic_item.cur_wait_time = 0
		notic_item.mid_pos_y = notic_item.begin_pos_y + ( notic_item.end_pos_y - notic_item.begin_pos_y ) * _screen_notic_default_mid_percent
		notic_item.alpha_befoer_per_stept = ( 0xff - 0) / ( ( notic_item.mid_pos_y - notic_item.begin_pos_y ) / _screen_notic_default_per_move ) 
		notic_item.alpha_after_per_stept = ( 0 - 0xff ) / ( ( notic_item.end_pos_y - notic_item.mid_pos_y ) / _screen_notic_default_per_move )
		notic_item.cur_alpha = 0
		notic_item.hit_center = false
		local function timer_fun(eventType, arg, msgid, selfItem)
			-------------------------
			local temp_item = notic_item
			-------------------------
			if eventType == nil then
				return
			end
			-------------------------
			if eventType == TIMER then
				local cur_pos = temp_item.view:getPositionS()
				local cur_size = temp_item.view:getSize()
				-------------------------
				if cur_pos.y > temp_item.end_pos_y then
					temp_item.view:setTimer(0)
					local screen_notic_win = UIManager:find_window("screen_notic_win")
					if screen_notic_win ~= nil then
						for i = 1 , #_screen_notic_item_list do
							if _screen_notic_item_list[i].view == temp_item.view then
								table.remove( _screen_notic_item_list, i )
								break
							end
						end
						screen_notic_win.view:removeChild( temp_item.view, true )
						return
					end
				end
				-------------------------
				if temp_item.mid_pos_y - cur_pos.y <= cur_size.height * 1.5 and temp_item.mid_pos_y - cur_pos.y > 0 and
				 _screen_center_target ~= nil and _screen_center_target ~= temp_item then
					_screen_center_target.cur_wait_time = _screen_notic_default_wait_time + 10
					_screen_center_target = nil
				end
				-------------------------
				if math.abs(temp_item.mid_pos_y - cur_pos.y) < 1.5 and temp_item.cur_wait_time < _screen_notic_default_wait_time then
					temp_item.cur_wait_time = temp_item.cur_wait_time + _default_timer_stept
					if _screen_center_target == nil and temp_item.hit_center == false then
						_screen_center_target = temp_item
					end
					temp_item.hit_center = true
					return
				end
				-------------------------
				local cur_alpha_weaken = notic_item.alpha_befoer_per_stept
				if cur_pos.y > notic_item.mid_pos_y then
					cur_alpha_weaken = notic_item.alpha_after_per_stept
				end
				-------------------------
				temp_item.view:setPosition( cur_pos.x, cur_pos.y + _screen_notic_default_per_move )
				notic_item.cur_alpha = notic_item.cur_alpha + cur_alpha_weaken
				if notic_item.cur_alpha > 255 then
					notic_item.cur_alpha = 0
				end
				temp_item.label:setAlpha( notic_item.cur_alpha ) 
			end
		end
		notic_item.view:registerScriptHandler(timer_fun)
		local screen_notic_win = UIManager:find_window("screen_notic_win")
		if screen_notic_win ~= nil then
			screen_notic_win.view:addChild(notic_item.view)
		end
		table.insert(_screen_notic_item_list, notic_item)
		if #_screen_notic_item_list > _screen_notic_item_list_max_num then
			_screen_notic_item_list[1].cur_wait_time = _screen_notic_default_wait_time - 0.017
			table.remove(_screen_notic_item_list, 1)
		end
	end
end
------------------------------
--支持根据窗口锚点来偏移
--支持多种分辨率
function ScreenNoticWin:create_notic(tinfo, tfontSize, tx, ty, anchor)
	if anchor then
		tx,ty = _calculateScreenPos(tx,ty,anchor)
	end

	local temp_info = { x = tx, y = ty, info = tinfo, fontSize = tfontSize }
	table.insert( _screen_notic_data, temp_info )
	if #_screen_notic_data > 1 then
		local screennoticwin = UIManager:find_window("screen_notic_win")
		if screennoticwin ~= nil and _run_self_timer == false then
			_run_self_timer = true
			screennoticwin.view:setTimer(_self_timer_rate)
		end
	else
		ScreenNoticWin:create_notic_item()
	end
end
------------------------------
------------------------------
function ScreenNoticWin:__init(window_name, texture_name, pos_x, pos_y, width, height)
	self.view:setCurState(CLICK_STATE_DISABLE)
	local function screenNoticFunction(eventType, arg, msgid, selfItem)
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
			return 
		end
		if eventType == TIMER then
			if _cur_target_delta_time > _next_target_delta_max_time then
				_cur_target_delta_time = 0
				ScreenNoticWin:create_notic_item()
				if #_screen_notic_data <= 0 then
					local screennoticwin = UIManager:find_window("screen_notic_win")
					if screennoticwin ~= nil then
						_run_self_timer = false
						screennoticwin.view:setTimer(0)
					end
				end
			else
				_cur_target_delta_time = _cur_target_delta_time + _self_timer_rate
			end
		end
		return false
	end
	self.view:registerScriptHandler(screenNoticFunction)
end
------------------------------
------------------------------
function ScreenNoticWin:clear_all_item()
	local screen_notic_win = UIManager:find_window("screen_notic_win")
	if screen_notic_win ~= nil then
		for i = 1 , #_screen_notic_item_list do
			if _screen_notic_item_list[i].view ~= nil then
				_screen_notic_item_list[i].view:setTimer(0)
				screen_notic_win.view:removeChild( _screen_notic_item_list[i].view , true )				
			end
		end
		_screen_notic_item_list = nil
		_screen_notic_item_list = {}
	end
end