---------------------------------------
---------------HJH 2013-6-24
super_class.ScreenRunNoticWin(Window)
---------------------------------------
local _window_size = { width = GameScreenConfig.ui_screen_width, 
					   height = GameScreenConfig.ui_screen_height }

---------------------------------------
local _screen_run_notic_item_list = {}
local _screen_run_notic_create_new_notic = true
local _screen_run_notic_cur_item = nil
local _screen_run_notic_running_components = {}

local _screen_run_notic_last_item = nil
local _run_self_timer = false
local _run_item = false
---------------------------------------
local _default_font_size = 20
local _default_timer_stept = 0.002
local _self_timer_rate = 0.01
local _run_per_dis = 1.8
local item_dis = 80
local _bg_item = nil
local _relativeWidth  = UIScreenPos.relativeWidth
local _relativeHeight = UIScreenPos.relativeHeight
---------------------------------------
local _screen_run_notic_size =  {  _relativeWidth(0.5), 35 }
local _screen_run_notic_default_begin_pos_x = _screen_run_notic_size[1]
-- local _screen_run_notic_default_begin_pos_y = _relativeHeight(0.8)

---------------------------------------
super_class.ScreenRunNoticItem()
---------------------------------------
function ScreenRunNoticItem:__init(info, fontsize)
	local temp_info = ChatModel:format_screen_and_center_notic_info( info )
	temp_info = "#cffecba公告：" .. temp_info -- [1825]="#cff0000公告："
	-- ----print("run screenrunnoticitem temp_info",temp_info)
	local label = CCZXLabel:labelWithText( 0, 0, temp_info, fontsize, ALIGN_LEFT )
	local label_size = label:getSize()
	local basepanel = CCBasePanel:panelWithFile( 0, 0, label_size.width, label_size.height, "" )
	basepanel:addChild(label)
	basepanel:setCurState(CLICK_STATE_DISABLE)
	self.view = basepanel
	self.label = label
	basepanel:setTimer(_default_timer_stept)
end

function ScreenRunNoticWin:fini(  )
	_window_size = { width = GameScreenConfig.ui_screen_width, 
						   height = GameScreenConfig.ui_screen_height }

	---------------------------------------
	_screen_run_notic_item_list = {}
	_screen_run_notic_create_new_notic = true
	_screen_run_notic_cur_item = nil
	_screen_run_notic_running_components = {}

	_screen_run_notic_last_item = nil
	_run_self_timer = false
	_run_item = false
	---------------------------------------
	_default_font_size = 20
	_default_timer_stept = 0.002
	_self_timer_rate = 0.01
	_run_per_dis = 1.8
	item_dis = 80
	_bg_item = nil
	_relativeWidth  = UIScreenPos.relativeWidth
	_relativeHeight = UIScreenPos.relativeHeight
	---------------------------------------
	_screen_run_notic_size =  {  _relativeWidth(0.5), 35 }
	_screen_run_notic_default_begin_pos_x = _screen_run_notic_size[1]
end
---------------------------------------
function ScreenRunNoticWin:create_run_notic( tinfo, tfontsize )
	if tfontsize == nil then
		tfontsize = _default_font_size
	end
	local temp_info = { info = tinfo, fontsize = tfontsize }
	table.insert( _screen_run_notic_item_list, temp_info )
	local screen_run_notic_win = UIManager:find_window("screen_run_notic_win")
	-- ----print("screen_run_notic_win,_run_self_timer,tinfo",screen_run_notic_win,_run_self_timer,tinfo)
	if screen_run_notic_win ~= nil and _run_self_timer == false then
		_run_self_timer = true
		screen_run_notic_win.view:setTimer(_self_timer_rate)
		screen_run_notic_win:startEffect()
	end
end
---------------------------------------
function ScreenRunNoticWin:create_run_item()
	if type(_screen_run_notic_item_list) == 'table' and #_screen_run_notic_item_list > 0 then
		local temp_data_info = _screen_run_notic_item_list[1]
		table.remove( _screen_run_notic_item_list, 1 )
		local notic_run_item = ScreenRunNoticItem( temp_data_info.info, temp_data_info.fontsize )
		-- ----print("ScreenRunNoticWin:create_run_item temp_data_info.info,temp_data_info.fontsize",temp_data_info.info, temp_data_info.fontsize)
		_screen_run_notic_cur_item = notic_run_item

		local cur_size = notic_run_item.view:getSize()
		notic_run_item.view:setPosition( _screen_run_notic_default_begin_pos_x + item_dis, 
									     cur_size.height*0.2 )
		local function item_function(eventType, arg, msgid, selfItem)
			local temp_item = notic_run_item
			if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
				return
			end
			if eventType == TIMER then
				local cur_pos = temp_item.view:getPositionS()
				local cur_size = temp_item.view:getSize()
				if cur_pos.x + cur_size.width < _window_size.width - item_dis and 
					_screen_run_notic_cur_item == temp_item then
					-- _screen_run_notic_create_new_notic = true
					_screen_run_notic_cur_item = nil
				end

				if cur_pos.x + cur_size.width < 0 then
					_screen_run_notic_create_new_notic = true
					local screen_run_notic_win = UIManager:find_window("screen_run_notic_win")
					if screen_run_notic_win ~= nil then
						-- ----print("ScreenRunNoticWin run kill self")
						temp_item.view:setTimer(0)
						screen_run_notic_win.view:removeChild( temp_item.view , true )
						_screen_run_notic_running_components[temp_item] = nil

						if #_screen_run_notic_item_list <= 0 and 
							_screen_run_notic_cur_item == nil and 
							next(_screen_run_notic_running_components) == nil then
							_run_item = false
						end
						return
					end
				end
				temp_item.view:setPosition( cur_pos.x - _run_per_dis, cur_pos.y )
			end
			return false
		end
		notic_run_item.view:registerScriptHandler(item_function)
		local screen_run_notic_win = UIManager:find_window("screen_run_notic_win")
		if screen_run_notic_win ~= nil then
			screen_run_notic_win.view:addChild( notic_run_item.view )
			_screen_run_notic_running_components[notic_run_item] = true
		end
	end
end
------------------------------
------------------------------
function ScreenRunNoticWin:__init( window_name, textureName )
	safe_release(self.view)
	local temp_bg = Image:create( nil, 0, 0, 
								  _screen_run_notic_size[1], 
								  _screen_run_notic_size[2], 
								  "sui/mainUI/system_msgBg.png", 
								  600, 600 )

	local x = (_relativeWidth(1.0) - _screen_run_notic_size[1]) * 0.5
	self.view =  CCTouchPanel:touchPanel( x, _relativeHeight(0.76), 
										  _screen_run_notic_size[1], 
										  _screen_run_notic_size[2] )

	self.view:setAnchorPoint(0.0,0.0)

	safe_retain(self.view)
	self.view:addChild(temp_bg.view)
	_bg_item = temp_bg.view
	self.view:setCurState(CLICK_STATE_DISABLE)
	self._running_items = {}
	local function screenRunFunction(eventType, arg, msgid, selfItem)
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
			return
		end
		if eventType == TIMER then
			if _screen_run_notic_create_new_notic and #_screen_run_notic_item_list > 0 then
				_screen_run_notic_create_new_notic = false
				ScreenRunNoticWin:create_run_item()
				_run_item = true
			end
			if #_screen_run_notic_item_list <= 0 and _run_item == false then
				self.view:setTimer(0)
				_run_self_timer = false
				self:endEffect()
			end
		end
		return false
	end

	self._bg_item = _bg_item
	self.view:registerScriptHandler(screenRunFunction)
	self._bg_item:setIsVisible(false)
end
------------------------------
------------------------------
function ScreenRunNoticWin:clear_all_item()
	local screen_run_notic_win = UIManager:find_window("screen_run_notic_win")
	if screen_run_notic_win ~= nil then
		_screen_run_notic_running_components = {}

		if _screen_run_notic_cur_item ~= nil then
			screen_run_notic_win.view:removeChild( _screen_run_notic_cur_item.view, true )
		end
		_screen_run_notic_item_list = nil
		_screen_run_notic_item_list = {}

		self._bg_item:setIsVisible(false)
		--self.effect:removeFromParentAndCleanup(true)
		self.effect = nil
	end
end

function ScreenRunNoticWin:startEffect()
	self._bg_item:setIsVisible(true)
	self._bg_item:setScaleY(0.0)
	local scale = CCScaleTo:actionWithDuration(0.25,1.0,1.0);
	self._bg_item:runAction(scale)

	local cb = callback:new() 
	local function callback_function()
		self.effect = SEffectBuilder:create_a_effect(51 ,1, 0 )
		self.effect:setAnchorPoint(CCPoint(0.5,0.5))
		self.effect:setPosition(_screen_run_notic_size[1]/2,_screen_run_notic_size[2]/2 - 2)
		self.view:addChild(self.effect)
	end 
	cb:start(2.5,callback_function)

end

function ScreenRunNoticWin:endEffect()
	local scale = CCScaleTo:actionWithDuration(0.25,1.0,0.0);
	local array = CCArray:array();
	array:addObject(scale);
	array:addObject(CCHide:action());
	local seq = CCSequence:actionsWithArray(array);
	self._bg_item:runAction(seq)

	--self.effect:removeFromParentAndCleanup(true)
	self.effect = nil
end