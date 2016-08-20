-- Instruction.lua
-- created by aXing on 2014-5-27
-- 新手引导管理类
-- @ 主要实现某一时间触发必须点击指引框
-- @ 根据配置实现 step by step

Instruction = { _mini_task_quests = {} }

_convertWidth = UIScreenPos.designToRelativeWidth
_convertHeight = UIScreenPos.designToRelativeHeight

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

local _SCALE_RECT_ACTION_TAG = 1
local _MAX_CLICK_UNLOCK_SCREEN = 5 			-- edited by aXing on 2014-7-17 改为5次容忍

local XSZY_STATE = XSZYConfig.NONE	-- 结合新手指引的状态
local CUSTOM_FUNC_T = {}

local _screenOffsetX = (GameScreenConfig.ui_screen_width - GameScreenConfig.ui_design_width ) * 0.5
local _screenOffsetY = (GameScreenConfig.ui_screen_height - GameScreenConfig.ui_design_height ) * 0.5
local _windowAnchors = 
{
	[5] = { 0.5 , 0.5 }	
}

local CORNER = 500

local _relativeWidth = UIScreenPos.relativeWidth
local _relativeHeight = UIScreenPos.relativeHeight
local _safeRemoveFromParentAndCleanup = CocosUtils.safeRemoveFromParentAndCleanup
-- 新手引导里面根据方向决定箭头的资源
local _dir_to_img = {
	-- {箭头资源, 字牌资源},
	{"nopack/ani_xszy.png", "nopack/xszy/1.png", },
	{"nopack/ani_xszy.png", "nopack/xszy/1.png", },
	{"nopack/ani_xszy2.png", "nopack/xszy/1.png", },
	{"nopack/ani_xszy2.png", "nopack/xszy/1.png", },
}

local _calculateCenterScreenPos = UIScreenPos.calculateCenterScreenPos
local _calculateScreenPos = UIScreenPos.calculateScreenPos
local _delayKill_NPCTalks = {}

InstructionNPCTalk = simple_class()

local function _clearLocalInstruction(comp)
	comp.view:removeChildByTag(UI_TAG_INSTRUCTION_POINTER,true)
	comp.view:removeChildByTag(UI_TAG_INSTRUCTION_BLINK,true)
	comp.view:removeChildByTag(UI_TAG_INSTRUCTION_RECT,true)
end

local function _colorTint(comp)
	local dur = 0.75
	local passTime = 0.0
	local flip = false
	local dt = 0.05

	local function _timerFunc()
		local t = passTime / dur
		if t > 1 then
			flip = not flip
			passTime = 0
			t = 0
		end
		if flip then
			local c = 0xffff0000 + ( 0xffffffff -  0xffff0000) * t
			comp:setColor(c)
		else
			local c = 0xffffffff + ( 0xffff0000 -  0xffffffff) * t
			comp:setColor(c)
		end
		passTime = passTime + dt 
	end

	local function _scriptHandler(eventType)
		if eventType == TIMER then
			_timerFunc()
		end
		return false
	end

	comp:registerScriptHandler(_scriptHandler)
	comp:setTimer(dt)
end
	

function InstructionNPCTalk:__init(view)
	self.view = view

	self.npc_id = nil

	self.npc_portrait = nil

	self.dialog_node = nil

	self.dialog_dir = nil

	self.dialog_pos = nil

	self.keep 		= nil

	self.setDialogMessage = nil

	self.setNPCPortrait = nil

	self.xMoveout = nil

	self.delayKill = nil

	
end

function InstructionNPCTalk:setDialogMessage(_new_msg)
	if self.isReleased then
		return 
	end

	_safeRemoveFromParentAndCleanup(self.dialog_node,true)
	local node = InstructionNpcDialog( self.npc_portrait.view, 
									   _new_msg, 
									   self.dialog_dir, 
									   self.dialog_pos[1], self.dialog_pos[2], 
									   0.1);
end

function InstructionNPCTalk:setNPCPortrait(_npc_id)
	if self.isReleased then
		return 
	end

	if self.npc_id ~= _npc_id then
		self.npc_portrait:setPortrait(_npc_id,false)
	end
end

function InstructionNPCTalk:killself()
	if self.npc_portrait then
		self.npc_portrait:destroy()
		self.npc_portrait = nil
	end
	if self.view then
		_safeRemoveFromParentAndCleanup(self.view,true)
		self.view = nil
	end
	_delayKill_NPCTalks[self] = nil
end

function InstructionNPCTalk:delayRemove(delay)
	if self.isReleased then
		return 
	end
	self.isReleased = true
	self.delayKill = callback:new()
	_delayKill_NPCTalks[self] = true
	self.delayKill:start(delay, function()
		self:killself()
	end)
	
end

function InstructionNPCTalk:delayMoveRemove(delay)
	if self.isReleased then
		return 
	end
	delay = delay or 0.25
	--obj.isReleased = true
	local basePanel = self.view
	local xMoveout  = self.xMoveout

	basePanel:stopAllActions()
	local move_out_act2 = CCMoveBy:actionWithDuration(0.25,CCPoint(xMoveout,0));
	basePanel:runAction(move_out_act2)
	basePanel:setCurState(CLICK_STATE_DISABLE)
	self:delayRemove(delay)
end

-- 初始化
function Instruction:init(debug)
	if GetPlatform() == CC_PLATFORM_WIN32 then
		debug = true
	end
	-- 当前正在进行的引导
	self.current_config = nil		
	-- 是否在中断AI
	self.pauseAI 		= false
	-- 从大到小的框
	self.zximg_corner 	= nil
	-- 计时器
	self.time 			= 0
	self.new_sys_cb 	= callback:new()
	-- 箭头
	self.zximg_jt 		= nil
	-- 闪烁框
	self.blink_view 	= nil
	-- 拖动框
	self.drag_out_spr	= nil
	-- 特效id
	self.effect_id		= nil
	-- 无特效无锁屏指引
	self.unlock 		= nil
	-- 锁操作的面板
	self.lock_panel 	= nil
	-- 无锁屏的指引
	self.is_need_lock	= nil
	-- 是否正在执行新手指引
	self.is_instruct = false

	self.ui_node = ZXLogicScene:sharedScene():getUINode()

	self:_init_menus_config()

	self._debug = debug

	self._talking_npcs = {}

	self._instructionPlayed = {}

	self._instruction_components = {}

	self.step = 0
end

-- 析构
function Instruction:fini(quiting)
	Instruction:interrupt(quiting)

	if _delayKill_NPCTalks then
		for npc, v in pairs(_delayKill_NPCTalks) do
			npc:killself()
		end
	end
	_delayKill_NPCTalks = {}
	-- 当前正在进行的引导
	self.current_config = nil		
	-- 是否在中断AI
	self.pauseAI 		= false
	-- 从大到小的框
	self:clear_select_rect_animation()
	self.time 			= 0
	self.new_sys_cb 	= nil
	self.is_instruct 	= false
	-- 箭头
	self:clear_jt_animation()
	-- 闪烁框
	self:clear_blink_animation()
	-- 拖动条
	self:destroy_drag_out_animation()
	-- 解锁屏幕
	self:unlock_screen()

	
end

function Instruction:scene_leave(quiting)
	Instruction:fini(quiting)
	self._instructionPlayed = {}

	self._instruction_components = {}
	self._mini_task_quests = {}
end

function Instruction:onQuit()
	Instruction:scene_leave(true)
end
-------------------------------------------------------
--
--	私有方法
-- 
-------------------------------------------------------

function Instruction:clear_select_rect_animation(  )
	-- 如果有之前的动画，则清除掉
	if self.zximg_corner ~= nil then
		--dismiss_scheduler_cb:cancel()
		-- self.zximg_corner:removeFromParentAndCleanup(true)
		self.zximg_corner = nil
	end
end

-- 框的从大到小的动画
function Instruction:play_select_rect_animation(rect_x, rect_y, rect_width, rect_height, anchor)

	self:clear_select_rect_animation()

	local scale_x = GameScreenConfig.ui_screen_width / rect_width
	local scale_y = GameScreenConfig.ui_screen_height / rect_height
	
	--运算rect距离窗口中心点,设计大小距离
	windowAnchor = _windowAnchors[anchor_id]

	local scale = math.min( scale_x, scale_y)

	local px,py = _calculateCenterScreenPos(rect_x, rect_y, rect_width, rect_height, anchor)

	self.zximg_corner = MUtils:create_zximg( self.ui_node, "nopack/ani_corner.png", 
											 px, py, rect_width, rect_height, CORNER,CORNER, JT_ZORDER)

	self.zximg_corner:setAnchorPoint(0.5,0.5)
	self.zximg_corner:setScale(scale)
	local action = CCScaleTo:actionWithDuration(0.2,1.0,1.0);
	local remove = CCRemove:action()

	local array = CCArray:array();
	array:addObject(action);
	array:addObject(remove);
	local seq = CCSequence:actionsWithArray(array)
	action:setTag(_SCALE_RECT_ACTION_TAG)
	self.zximg_corner:runAction(seq)
end

function Instruction:clear_jt_animation(  )
	if self.zximg_jt then
		_safeRemoveFromParentAndCleanup(self.zximg_jt,true)
		self.zximg_jt = nil
	end
end

-- 箭头动画		direction 1 = 左 ,direction 2 = 右,direction 3 = 上,direction 4 = 下
function Instruction:play_jt_animation( x, y, width, height, dir , anchor, jt_image, label_image)
	
	self:clear_jt_animation()
	--_calculateScreenPos
	-- 如果是左或者右
	local pos_x 		= 0
	local pos_y 		= 0
	local zximg_jt 		= nil
	local jt_image 		= jt_image or _dir_to_img[dir][1]			-- 箭头资源
	local label_image 	= label_image or _dir_to_img[dir][2]			-- 字牌资源
	local px, py 		= _calculateScreenPos(x, y, anchor)

	if dir == 1 then
		zximg_jt = MUtils:create_sprite(self.ui_node, jt_image, px, py, JT_ZORDER)
		zximg_jt:setAnchorPoint(CCPointMake(0, 0.5))
		local sz = zximg_jt:getContentSize()
		zximg_jt:setPosition(CCPointMake(px + width,py + height * 0.5))

		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0)
		label:setAnchorPoint(CCPointMake(0.5,0.5))
		label:setPosition(90,35)

	elseif dir == 2 then
		zximg_jt = MUtils:create_sprite(self.ui_node, jt_image, 0, 0, JT_ZORDER)
		zximg_jt:setFlipX(true)
		zximg_jt:setAnchorPoint(CCPointMake(0, 0.5))
		local sz = zximg_jt:getContentSize()
		zximg_jt:setPosition(CCPointMake(px - sz.width, py + height * 0.5))

		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0)
		label:setAnchorPoint(CCPointMake(0.5,0.5))
		label:setPosition(70,35)

	elseif dir == 3 then
		zximg_jt = MUtils:create_sprite(self.ui_node, jt_image, px, py, JT_ZORDER);
		zximg_jt:setAnchorPoint(CCPointMake(0.5, 0))
		local sz = zximg_jt:getContentSize()
		zximg_jt:setPosition(CCPointMake(px + width / 2, py - sz.height))

		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0)
		label:setAnchorPoint(CCPointMake(0.5,0.5))
		label:setPosition(72,35)

	elseif dir == 4 then
		zximg_jt = MUtils:create_sprite(self.ui_node, jt_image, px, py, JT_ZORDER);
		zximg_jt:setFlipY(true);
		zximg_jt:setAnchorPoint(CCPointMake(0.5, 0))
		zximg_jt:setPosition(CCPointMake(px + width / 2, py + height))

		local sz = zximg_jt:getContentSize()
		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0);
		label:setPosition(72,55)

	end

	LuaEffectManager:run_move_animation( dir, zximg_jt )

	self.zximg_jt = zximg_jt
end

-- 清除闪烁框
function Instruction:clear_blink_animation(  )

	if self.blink_view ~= nil then
		_safeRemoveFromParentAndCleanup(self.blink_view,true)
		self.blink_view = nil
	end
end

local msin = math.sin
-- 闪烁框的列表
function Instruction:play_blink_animation( x, y, width, height , anchor)

	self:clear_blink_animation()

	local px,py = _calculateScreenPos(x, y, anchor)
	local fwidth 	= width
	local fheight 	= height

	-- 显示一个不停闪烁的框
	self.blink_view = MUtils:create_zximg(self.ui_node,"nopack/ani_corner.png",
		px, py, fwidth, fheight, CORNER,CORNER, JT_ZORDER)

	_colorTint(self.blink_view)
	-- self.blink_view:runAction(action)

	-- 显示一个不停闪烁的框
	local pointer = MUtils:create_zximg(self.blink_view,"nopack/ani_corner.png",
										fwidth*0.5, fheight*0.5, fwidth, fheight, CORNER,CORNER, -1)
	pointer:setAnchorPoint(0.5,0.5)

	local _out = CCScaleTo:actionWithDuration(1.0,1.085)
	local _in = CCScaleTo:actionWithDuration(1.0,0.925)
	local array = CCArray:array();
	array:addObject(_out);
	array:addObject(_in);
	local seq = CCSequence:actionsWithArray(array);
	local action = CCRepeatForever:actionWithAction(seq);
	pointer:runAction(action)
end

-- 锁定屏幕某一块区域
-- @param x 锁屏后，可以点击区域开始坐标
-- @param y 锁屏后，可以点击区域开始坐标
-- @param width 锁屏后，可以点击区域宽度
-- @param height 锁屏后，可以点击区域高度
-- 这个就作废了吧。斩仙新手指引遗留
-- 修改为提供外部调用的锁屏	by hwl
function Instruction:lock_screen1( x, y, width, height, is_double_click , anchor, is_lock, hollow_click)
	
	if self:is_locking_screen() then 
		Instruction:unlock_screen()
	end
	if self.pauseAI then
		-- 先停止玩家的所有动作
		local player = EntityManager:get_player_avatar()
		player:stop_all_action()
	end

	local unlock_panel_func = nil
	if hollow_click then
		unlock_panel_func =  function (eventType,x,y)
			if  eventType == TOUCH_BEGAN then
				return true
			elseif eventType == TOUCH_ENDED then
				return false
			elseif eventType == TOUCH_CLICK then
				if not is_double_click then
					self:unlock_screen() 
				end
				return false
			elseif eventType == TOUCH_DOUBLE_CLICK then
				self:unlock_screen()
				return false
			end
			return false
		end
	end

	local function click_lock_panel_func( eventType )
		if eventType == TOUCH_CLICK then
			return true
		end
		return true
	end

	local px, py 		= _calculateScreenPos(x, y, anchor)
	--锁定层
	self.lock_panel = FullScreenPanel(px, py, width, height,unlock_panel_func, nil, is_lock, click_lock_panel_func).view
	self.ui_node:addChild(self.lock_panel, JT_ZORDER - 1)
end

-- 锁定屏幕某一块区域
-- @param x 锁屏后，可以点击区域开始坐标
-- @param y 锁屏后，可以点击区域开始坐标
-- @param width 锁屏后，可以点击区域宽度
-- @param height 锁屏后，可以点击区域高度
-- added by mwy on 2013-6-11
function Instruction:lock_screen( x, y, width, height, is_double_click , anchor, is_lock, hollow_click)
	if self:is_locking_screen() then 
		Instruction:unlock_screen()
	end
	if self.pauseAI then
		-- 先停止玩家的所有动作
		local player = EntityManager:get_player_avatar()
		player:stop_all_action()
	end
	-- 关闭玩家对话框
	UIManager:hide_window("npc_dialog")
	local unlock_panel_func = nil
	if hollow_click then
		unlock_panel_func =  function (eventType,x,y)
			if  eventType == TOUCH_BEGAN then
					-- self:unlock_screen()
					-- self:next()
					-- return false
				return true
			elseif eventType == TOUCH_ENDED then
				return false
			elseif eventType == TOUCH_CLICK then
				if not is_double_click then
					self:unlock_screen() 
					self:next()
				end
				return false
			elseif eventType == TOUCH_DOUBLE_CLICK then
				-- if is_double_click then
					self:unlock_screen()
					self:next()
				-- end
				return false
			end
			return false
		end
	end

	local function click_lock_panel_func( eventType )

		if eventType == TOUCH_CLICK then
			self.miss_clicks = self.miss_clicks - 1
			if self.miss_clicks < 1 then
				self:interrupt()
				return true
			end
			-- local now_step = self.current_config[self.step]
			self:play_select_rect_animation(x, y, width, height, anchor)
			return true
		end
		return true
	end

	local px, py 		= _calculateScreenPos(x, y, anchor)
	--锁定层
	self.lock_panel = FullScreenPanel(px, py, width, height,unlock_panel_func, nil, is_lock, click_lock_panel_func).view
	self.ui_node:addChild(self.lock_panel, JT_ZORDER - 1)

end

-- 解除屏幕锁定
function Instruction:unlock_screen(  )
	if self.lock_panel ~= nil then 
		--self.lock_panel:autorelease()
		_safeRemoveFromParentAndCleanup(self.lock_panel,true)
		self.lock_panel = nil
		self:clear_blink_animation()
		self:clear_jt_animation()
		if self.effect_id then
			LuaEffectManager:stop_view_effect(self.effect_id, Instruction.ui_node)
			self.effect_id	= nil
		end
	elseif self.effect_id then
		self:clear_blink_animation()
		self:clear_jt_animation()
		LuaEffectManager:stop_view_effect(self.effect_id, Instruction.ui_node)
		self.effect_id	= nil
	elseif self.unlock then
		self:clear_blink_animation()
		self:clear_jt_animation()
		self.unlock = nil
	end
end

-- 取得当前是否已经锁定屏幕
function Instruction:is_locking_screen()
	if self.lock_panel ~= nil then
		return true
	end
	return false
end

-- 播放指引
function Instruction:play_jt_and_kuang_animation( config, x, y )
	local x 		= x or config.x
	local y 		= y or config.y
	local dir 		= config.dir
	local width		= config.width
	local height 	= config.height
	local jt_image = config.jt_image
	local label_image = config.label_image
	local is_lock 	= config.lock_screen == nil and true or false	-- 默认根据component_id锁屏幕
	local is_need_lock = config.is_need_lock == nil and true or false	--默认锁屏
	local is_double_click = config.double_click or false 	-- 默认单击下一步
	local effect_id = config.effect
	local anchor 	= config.anchor
	local component_id = config.component_id
	local unlock 	= config.unlock
	self.unlock = unlock
	if config.show_top_banner ~= nil then
		local win = UIManager:find_window("right_top_panel")
		win:do_hide_menus_fun(config.show_top_banner)
	end
	if config.show_main_banner ~= nil then
		local win = UIManager:find_window("menus_panel")
		win:show_or_hide_panel(config.show_main_banner)	
	end
	if config.talk then
		self:npc_talk(config.talk)
	end
	if not x or not y or not width or not height then
		self:finish()
		return
	end
	local gap = 3
	if effect_id then
		self.effect_id = effect_id
		local dx, dy = 0, 0
		if effect_id == 11035 or effect_id == 11036 then
			dx, dy = 83, 25
		elseif effect_id == 11034 then
			dx, dy = 23, 17
		end
		local px, py 		= _calculateScreenPos(x+dx, y+dy, anchor)
		LuaEffectManager:play_view_effect(effect_id, px, py, Instruction.ui_node, true, 99999)
	elseif not unlock then
		self:play_select_rect_animation(x, y, width, height, anchor)
		self:play_blink_animation(x - gap, y - gap, width + gap * 2, height + gap * 2, anchor)
	end
	self:play_jt_animation(x, y, width, height, dir, anchor, jt_image, label_image)

	if is_need_lock then
		if component_id then
			self:lock_screen(x, y, width, height, is_double_click, anchor, is_lock, false)
		else
			self:lock_screen(x, y, width, height, is_double_click, anchor, is_lock, true)
		end
	else
		-- self.waiting_next = true
		self.is_need_lock = is_need_lock
		local player = EntityManager:get_player_avatar()
		player:stop_all_action()
		UIManager:hide_window("npc_dialog")
	end
	self.component_id = component_id
end



-------------------------------------------------------
--
--	公有方法
-- 
-------------------------------------------------------

-- 引导开始
function Instruction:start( id, callback, click_nums )

	local config = InstructionConfig:get_instruction_by_id(id)
	if not config or not Instruction:checkCondition(config) then
		return 
	end
	_MAX_CLICK_UNLOCK_SCREEN = click_nums or 5
	-- 特殊处理33的指引
	if id == 33 then
		_MAX_CLICK_UNLOCK_SCREEN = 999999
	end
	-- print('>>>>','Instruction:start',id)
	-- 如果正在做其他的引导
	self.miss_clicks = _MAX_CLICK_UNLOCK_SCREEN

	if self.current_config ~= nil then
		self:finish()
	end

	
	--关闭小秘书
	UIManager:hide_window('secretary_Win')


	if config ~= nil then

		self.current_id		= id
		self.current_config = config
		self.step			= 0			-- 起始0, next() 首先加一
		self.callback		= callback
		self.custom_action  = config.custom_action

		if config.pauseAI~=nil then
			self.pauseAI 	= config.pauseAI
		else
			--默认为打断
			self.pauseAI 	= true
		end
		if self.pauseAI then
			-- self.old_ai_state = AIManager:get_state()
			AIManager:pause()
		end

		if config.close_all_ui then
			UIManager:close_all_window()
			UIManager:close_all_dialog()
		end

		self.is_instruct = true

		Instruction:setInstructionPlayed(id,true)
		self:next()
	end
end

function Instruction:clear_rect()
	self:clear_jt_animation()
	self:clear_blink_animation()
end

function Instruction:cleanNextStepNPCTalks()
	print('Instruction:cleanNextStepNPCTalks()')
	if self._talking_npcs then
		for k, npc in pairs(self._talking_npcs) do
			if not npc.keep then
				npc:delayMoveRemove()
				self._talking_npcs[k] = nil
			end
		end
	end
end

function Instruction:cleanNPCTalks()
	print('Instruction:cleanNPCTalks()')
	if self._talking_npcs then
		for k, npc in pairs(self._talking_npcs) do
			npc:delayMoveRemove()
		end
		self._talking_npcs = {}
	end
end

function Instruction:interrupt(quiting)
	self.component_id = nil
	self:cleanNPCTalks()
	self.is_instruct = false
	if not quiting then
		if self.current_config then
			if self.current_config.skip then
				local _delay = self.current_config.skip.delay
				self.current_config.skip.delay = _delay or 5
				self:npc_talk(self.current_config.skip)
			end
			self.current_config = nil
		end
		self:do_custom_action()
	end
	self:unlock_screen()
end
-- 下一步
function Instruction:next()
	self.waiting_next = false
	if self.current_config and self.current_config[self.step] and self.current_config[self.step].next_id then
		Instruction:start( self.current_config[self.step].next_id, nil )
		return
	end
	local old_step = self.current_config[self.step]
	--防止系统动画过后手贱玩家点击过快,强制关闭所有窗口
	local need_close = false
	if old_step and old_step.new_system then
		need_close = true
	end
	self.component_id = nil
	self.miss_clicks = _MAX_CLICK_UNLOCK_SCREEN
	--self:clear_rect()
	self.step = self.step + 1
	print('########### Instruction:next()', self.step)
	if self.current_config == nil then
		self:finish()
		return
	end

	local now_step = self.current_config[self.step]
	if now_step == nil then
		self:finish()
		return
	end
	
	local close_ui_step = false

	if now_step.close_all_ui then
		UIManager:close_all_window()
		UIManager:close_all_dialog()
		close_ui_step = true
		
	elseif now_step.close_windows then
		for k,v in pairs(now_step.close_windows) do
			UIManager:hide_window(v)
		end
		close_ui_step = true
	end
	if now_step.open_window then
		-- 征伐榜特殊处理
		if now_step.open_window == 'zycm_win' then
			GlobalFunc:open_or_close_window( 16 ,0 ,nil);
		else
			UIManager:show_window(now_step.open_window)
		end
		close_ui_step = true
	end
	
	self:cleanNextStepNPCTalks()

	-- 急着出包，暂时增加self.current_config的判断，避免一个费解问题，之后最好去掉，来重新发现并解决self.current_config为nil的报错
	if close_ui_step then
		if now_step.talk then
			local _delay = now_step.talk.delay
			now_step.talk.delay = _delay or 5
			now_step.keep = false
			self:npc_talk(now_step.talk)
		end

		self.step = self.step + 1
		now_step = self.current_config[self.step]
		if now_step == nil then
			self:finish()
			return
		end
	end

	local delay = 0
	if now_step.show_top_banner ~= nil then
		local win = UIManager:find_window("right_top_panel")
		win:do_hide_menus_fun(now_step.show_top_banner)
		delay = 0.2
	end
	if now_step.show_main_banner ~= nil then
		local win = UIManager:find_window("menus_panel")
		win:show_or_hide_panel(now_step.show_main_banner)	
		delay = 0.4
	end

	callback:new():start(delay, function()
		-- 这里开始做这一步
		if now_step.new_system ~= nil then
			-- 如果是打开新系统，则调用新系统
			local new_system_id = now_step.new_system
			-- 如果是坐骑系统，就让玩家先下坐骑
			if new_system_id == 0 then
				if GameSysModel:isSysEnabled(GameSysModel.MOUNT) and MountsModel:get_is_shangma( ) then
					MountsModel:ride_a_mount( )
				end
			end

			self:open_new_sys(new_system_id)
		
		elseif now_step.new_drag then
			self:create_drag_out_animation(now_step)
		--如果是写死的
		elseif now_step.component_ui then
			self:onComponentInstruction(now_step)
			if need_close then
				need_close = false
				UIManager:close_all_dialog()
				UIManager:close_all_window()
			end
		elseif now_step.use_item then
			local px,py = MUtils:cal_bag_win_item_position(now_step.use_item)
			self:play_jt_and_kuang_animation(now_step, px,py)
		elseif now_step.waiting_next then
			-- 增加一种等待类型，避免指引完成后玩家去和npc对话导致窗口被销毁
			self.waiting_next = true
		else
			-- 默认是指引框
			self:play_jt_and_kuang_animation(now_step)
		end
		need_close = false
	end)
end

-- 中断引导
function Instruction:finish()
	print('Instruction:finish()')
	local need_resume = true
	-- if self.current_id == 9 then
	-- 	need_resume = false
	-- end
	self.component_id = nil
	self:cleanNPCTalks()
	if self.current_config ~= nil then
		if self.pauseAI and not self.custom_action and need_resume then
			AIManager:resume()
			-- if self.old_ai_state then
			-- 	AIManager:set_state(self.old_ai_state)
			-- end
		end

		self.old_ai_state = nil
		self.is_instruct = false
		self.pauseAI = false
		self.current_config = nil
		self.step = 0
		if self.callback ~= nil then
			self.callback()
			self.callback = nil
		end

		self:do_custom_action()
	end
end

function Instruction:do_custom_action( )
	local custom_info = self.custom_action
	self.custom_action = nil
	if custom_info then
		local action_id = custom_info.action_id
		CUSTOM_FUNC_T[action_id](custom_info)
	end
end

-- 获取是否正在新手指引
function Instruction:get_is_instruct(  )
	return self.is_instruct
end

function Instruction:set_is_instruct( state )
	self.is_instruct = state
end


function Instruction:test()

end


-------------------------------------------------------
--
--	以下是会飞的图标代码
-- 
-------------------------------------------------------
-- 因为引用顺序问题，所以改为成员变量，以便在模块初始化的时候，才开始初始化配置
function Instruction:_init_menus_config(  )
	-- 系统功能对应的图标
	self._SYSTEM_ICON_PATH = {
		[GameSysModel.MOUNT]		= UILH_MAIN[3],			-- 坐骑
		[GameSysModel.ENHANCED]		= UILH_MAIN[2],			-- 炼器
		[GameSysModel.GUILD]		= UILH_MAIN[6],			-- 公会
		[GameSysModel.PET]			= UILH_MAIN[9],			-- 伙伴
		[GameSysModel.GENIUS] 		= "ui/main/menus/9.png",			-- 式神
		[GameSysModel.LOTTERY]		= "ui/main/menus/8.png",			-- 梦境
		[GameSysModel.WING]			= UILH_MAINMENU.chibang,			-- 翅膀

		[GameSysModel.GEM] 			= UIResourcePath.FileLocate.lh_mainmenu .. "fabao.png", 	-- 法宝
		[GameSysModel.QianDao] 		= UIResourcePath.FileLocate.lh_mainmenu .. "qiandao.png", 	-- 
		[GameSysModel.MONEY_TREE]	= UIResourcePath.FileLocate.lh_mainmenu .. "zhaocai.png",	-- 招财
		[GameSysModel.JJC]		 	= UIResourcePath.FileLocate.lh_mainmenu .. "doufatai.png",
		[GameSysModel.DJ] 			= UIResourcePath.FileLocate.lh_mainmenu .. "dujie.png", -- 渡劫
		[GameSysModel.RANKLIST] 	= UIResourcePath.FileLocate.lh_mainmenu .. "bangdan.png",
		[GameSysModel.ROOTS]		= UILH_MAINMENU.linggen
	}

	-- 系统功能放置的主界面菜单index
	self._SYSTEM_TO_MENU_INDEX = {
		[GameSysModel.MOUNT]		= MenusPanel.MENU_MOUNT,
		[GameSysModel.ENHANCED] 	= MenusPanel.MENU_FORGE,
		[GameSysModel.GUILD]		= MenusPanel.MENU_GUILD,
		[GameSysModel.PET]			= MenusPanel.MENU_PET,
		[GameSysModel.TRANSFORM]	= MenusPanel.MENU_TRANSFORM,
		[GameSysModel.GENIUS] 		= MenusPanel.MENU_GENIUS,
		[GameSysModel.LOTTERY] 		= MenusPanel.MENU_DREAMLAND,
		[GameSysModel.JJC]			= MenusPanel.MENU_RENDOUTAI,
		[GameSysModel.DJ] 			= MenusPanel.MENU_NINJAEXAM,
		[GameSysModel.RANKLIST] 	= MenusPanel.MENU_RANKLIST,
		[GameSysModel.WING]			= MenusPanel.MENU_WING,
	}
end

-- create by jiangjinhong 
-- 创建一个学习新技能后播放道具特效
function Instruction:play_new_jineng_effect( skill_id,to_pos_x,to_pos_y,call_back)

	local texture = SkillConfig:get_skill_icon( skill_id )	
	local pos_x = GameScreenConfig.ui_screen_width*0.5
	local pos_y = GameScreenConfig.ui_screen_height*0.5 
	to_pos_x = -pos_x+to_pos_x
	to_pos_y = -pos_y+to_pos_y
	LuaEffectManager:play_jineng_effect(self.ui_node,pos_x,pos_y,
										to_pos_x,to_pos_y,texture,99999,call_back)

	UIManager:close_all_dialog()

end

-- 系统开启飞向主界面菜单栏
function Instruction:_fly_to_main_menus( sys_id, callback_fun )

	local path 	= self._SYSTEM_ICON_PATH[sys_id]
	local index = self._SYSTEM_TO_MENU_INDEX[sys_id]
	local pos_x = GameScreenConfig.ui_screen_width*0.5
	local pos_y = GameScreenConfig.ui_screen_height*0.5 - 65 

	-- 收起菜单
	local win = UIManager:find_window("menus_panel")
	win:show_or_hide_panel(true)

	-- 系统开启面板
	self.new_sys_panel = CCArcRect:arcRectWithColor(0,0,
		GameScreenConfig.ui_screen_width, GameScreenConfig.ui_screen_height, 0x00000199)
	self.ui_node:addChild(self.new_sys_panel,99998)
	self.new_sys_panel:setDefaultMessageReturn(true)
	UIManager:showMainUI(false)

	local icon_effect;
	local dismiss_func = {}

	local function btn_fun( eventType,msg_id,args)
		if icon_effect then
			icon_effect.rootNode:stopAllActions()
			icon_effect.fly_and_fade()
			dismiss_func.func()
		end 
	end

	-- local open_sys_panel = ZTextButton:create(self.ui_node,"",UIPIC_OpenSys_006,btn_fun,pos_x,GameScreenConfig.ui_screen_height,-1,-1,99999)
	-- open_sys_panel.view:setAnchorPoint(0.5,0)
	-- open_sys_panel.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_OpenSys_006)
	-- open_sys_panel.view:setCurState(CLICK_STATE_DISABLE)

	local icon_bg = CCZXImage:imageWithFile(pos_x,GameScreenConfig.ui_screen_height, -1, -1, UILH_SYSOPEN.sysopen_bg)
	icon_bg:setAnchorPoint(0.5,0)
	self.ui_node:addChild(icon_bg, 99999)
	local icon_title = MUtils:create_sprite(icon_bg, UILH_SYSOPEN.sysopen_title,185,185)
	local icon = MUtils:create_sprite(icon_bg,path,186,55)
	icon:setAnchorPoint(CCPoint(0.5,0))

	local array = CCArray:array()
	local move_to 	= CCMoveTo:actionWithDuration(0.3,CCPoint(pos_x,pos_y))
	local move_ease_in = CCEaseIn:actionWithAction(move_to,1)
	local jump_1 = CCJumpTo:actionWithDuration( 0.7, CCPoint(pos_x,pos_y),40,1)
	local jump_2 = CCJumpTo:actionWithDuration( 0.4, CCPoint(pos_x,pos_y),20,1)
	local jump_3 = CCJumpTo:actionWithDuration( 0.2, CCPoint(pos_x,pos_y),10,1)

	array:addObject(move_ease_in)
	array:addObject(jump_1)
	array:addObject(jump_2)
	array:addObject(jump_3)
	-- array:addObject(CCRemove:action())
	local seq = CCSequence:actionsWithArray(array)
	icon_bg:runAction(seq)

	local to_pos_x,to_pos_y = InstructionConfig:get_terminal_position_by_sys_id(sys_id) or  GameScreenConfig.ui_screen_width*0.1,35

	-- print("to_pos_x,to_pos_y",to_pos_x,to_pos_y)
	local function play_oenSys_effect()
		-- open_sys_panel.view:setCurState(CLICK_STATE_UP)
		_safeRemoveFromParentAndCleanup(icon,true)
		icon_effect = LuaEffectManager:openSysEffect(self.ui_node,pos_x+3,pos_y+90,to_pos_x,to_pos_y,480,path,99999)
	end

	local cb = callback:new()
	cb:start(2,play_oenSys_effect)
	
	local function dismiss( dt )
		-- 为了处理翅膀系统飘落动画后，翅膀按钮和商城按钮重叠的问题加的代码。
		win:sort_btns()

		if icon_bg then
			_safeRemoveFromParentAndCleanup(icon_bg,true)
			icon_bg = nil
		end
		win:insert_btn( index )
		UIManager:close_all_window()
		UIManager:close_all_dialog()
		UIManager:showMainUI(true)
		local function show_mainUI_func()
			if callback_fun ~= nil then
				callback_fun()
				UIManager:close_all_dialog()
				UIManager:close_all_window()
			end		
			if self.new_sys_panel then
				_safeRemoveFromParentAndCleanup(self.new_sys_panel,true)
				self.new_sys_panel = nil
			end 
		end
		local cb = callback:new()
		cb:start(1.5,show_mainUI_func)	
	end
	dismiss_func.func = dismiss

	UIManager:close_all_window()
	UIManager:close_all_dialog()
	self.new_sys_cb:cancel()
	self.new_sys_cb:start(3.5,dismiss)
end

-- 飞向功能菜单栏
function Instruction:_fly_to_function_button( sys_id, callback )

	local path = self._SYSTEM_ICON_PATH[sys_id]

	if path ~= nil then
		self.new_sys_panel = CCArcRect:arcRectWithColor( 0, 0,
			GameScreenConfig.ui_screen_width, GameScreenConfig.ui_screen_height, 0x00000055)
		self.ui_node:addChild(self.new_sys_panel,99998)

		local function panel_func(eventType,x,y)
			if  eventType == TOUCH_BEGAN then
				return true;
			elseif eventType == TOUCH_CLICK then
				return true;
			end
			return true
		end
		self.new_sys_panel:registerScriptHandler(panel_func);

		local to_pos_x = GameScreenConfig.ui_screen_width  - 210
		local to_pos_y = GameScreenConfig.ui_screen_height - 30

		local spr = MUtils:create_sprite(self.ui_node,path,UIScreenPos.relativeWidth(0.5),370,99999)
		-- 创建闪烁特效
		LuaEffectManager:play_view_effect( 30002,51,47,spr,true,-1 )

		-- 创建加速移动动画
		local move_to = CCMoveTo:actionWithDuration(2.0,CCPoint(to_pos_x,to_pos_y))
		local move_ease_in = CCEaseIn:actionWithAction(move_to,4.0);
		
		local function dismiss( dt )
			spr:stopAllActions();
			_safeRemoveFromParentAndCleanup(spr,true)
			if self.new_sys_panel ~= nil then
				_safeRemoveFromParentAndCleanup(self.new_sys_panel,true)
				self.new_sys_panel = nil;
			end

			if callback ~= nil then
				callback()
			end
		end
		UIManager:close_all_window()
		UIManager:close_all_dialog( )
		self.new_sys_cb:cancel()
		self.new_sys_cb:start( 3,dismiss)
		spr:runAction( move_ease_in )
	end
end

-- 开启新系统动画， 飞向主界面菜单栏
function Instruction:open_new_sys( sys_id, if_next )
	if_next = (if_next ~= false and true or false)
	if self._SYSTEM_TO_MENU_INDEX[sys_id] ~= nil then
		self:_fly_to_main_menus(sys_id, if_next and bind(self.next, self) or nil)
	else
		self:_fly_to_function_button(sys_id, if_next and bind(self.next, self) or nil)
	end
end


function InstructionNpcDialog( parent, str , dir, posX, posY, delayInTime)

	local dialog_node = parent:getChildByTag( UI_TAG_INSTRUCT_ENTITY_DIALOG );

	if ( dialog_node ) then
		dialog_node:removeAllChildrenWithCleanup(true);
	else
		dialog_node = CCNode:node();
		parent:addChild( dialog_node,10,UI_TAG_INSTRUCT_ENTITY_DIALOG );
	end

	str = ChatModel:AnalyzeInfo(str)
	local dialog_content = MUtils:create_ccdialogEx( dialog_node,
													str,10,35,
													320,0,
													15,18,
													2,ADD_LIST_DIR_DOWN);
	local size = dialog_content:getInfoSize();
	--print("str = ",str,"size.width = ",size.width,"size.height",size.height);
	local half_width = (size.width + 20) / 2;
	dialog_content:setPosition(10 -half_width,35);
	

	dialog_top = MUtils:create_zximg( dialog_node,UILH_COMMON.bottom_bg,0-half_width,25,size.width+20,size.height+25,7,16);
	
	local curr_width = (size.width+20 - 18 - 14) /2; 
	-- dialog_bottom1 = MUtils:create_zximg( dialog_node,UIResourcePath.FileLocate.common .. "dialog_bottom.png",7-half_width,24,curr_width,6,1,6);
	-- dialog_bottom2 = MUtils:create_sprite( dialog_node,UIResourcePath.FileLocate.common .. "dialog_bottom2.png",(size.width+20)/2-half_width,24);
	-- dialog_bottom3 = MUtils:create_zximg( dialog_node,UIResourcePath.FileLocate.common .. "dialog_bottom.png",curr_width+7+18-half_width,24,curr_width,6,1,6);

	-- if dir < 0 then
	-- 	dialog_bottom2:setScaleX(-1)
	-- end
	dialog_node:setScale(0)
	local scale = CCScaleTo:actionWithDuration(0.25,1.0)
	local delay  = CCDelayTime:actionWithDuration(delayInTime);
	local array = CCArray:array();
	array:addObject(delay)
	array:addObject(scale);
	local sequence = CCSequence:actionsWithArray(array);
	dialog_node:runAction(sequence)
	dialog_node:setPosition(CCPointMake(posX,posY))
	return dialog_node
end


function Instruction:npc_talk(info)
	local _dir = info.pos or 'r'
	local npc_id = info.npc
	local _keep = info.keep
	local msg = Hyperlink.parse_face(info.msg)

	if _dir then
		local _talking_npcsObject = self._talking_npcs[_dir]
		if _talking_npcsObject then
			_talking_npcsObject:setNPCPortrait(npc_id)
			_talking_npcsObject:setDialogMessage(msg)
			_talking_npcsObject.keep = _keep
			return
		end
	end

	local npc_helper = EntityPortrait()
	local basePanel = CCBasePanel:panelWithFile(0, 0, 250, 320, nil, 0, 0)
	local _scriptObject = InstructionNPCTalk(basePanel)

	local _delay = info.delay or -1


	self.ui_node:addChild(basePanel,JT_ZORDER_NPC)
	basePanel:addChild(npc_helper.view)
	npc_helper:setPortrait(npc_id,false)

	local xMoveout = nil
	local dX = -150
	local dY = 250
	local _d_dir = 1
	if _dir == 'r' then
		UIScreenPos.screen9GridPos(_scriptObject,3)
		xMoveout = 400
		npc_helper.view:setPosition(CCPointMake(125,0))
		npc_helper.half_body:setFlipX(true)
	else
		UIScreenPos.screen9GridPos(_scriptObject,1)
		xMoveout = -400
		npc_helper.view:setPosition(CCPointMake(140,0))
		dX = 150
		_d_dir = -1
	end

	_scriptObject.xMoveout = xMoveout

	local x,y = basePanel:getPosition()
	local node = InstructionNpcDialog( npc_helper.view, 
									   msg,_d_dir, 
									   dX, dY,
									   0.5);

	basePanel:setPosition(CCPointMake(x,y-400))
	if _delay > 0 then
		local action = CCMoveBy:actionWithDuration(0.5,CCPoint(0,400));
		local delay  = CCDelayTime:actionWithDuration(info.delay);
		local move_out_act = CCMoveBy:actionWithDuration(0.5,CCPoint(xMoveout,0));
		--local remove_act = CCRemove:action()

		local array = CCArray:array();
		array:addObject(action);
		array:addObject(delay)
		array:addObject(move_out_act)
		--array:addObject(remove_act);
		local sequence = CCSequence:actionsWithArray(array);
		basePanel:runAction(sequence)

		local function basePanelMessageFun(eventType, args, msgid, selfItem)
			if eventType == TOUCH_BEGAN then
				_scriptObject:delayMoveRemove()
				return true
			end
			return true
		end
		basePanel:registerScriptHandler(basePanelMessageFun)
		_scriptObject:delayRemove(0.5 + info.delay + 0.5)
	else

		local action = CCMoveBy:actionWithDuration(0.5,CCPoint(0,400));
		basePanel:runAction(action)
		local function basePanelMessageFun(eventType, args, msgid, selfItem)
			return true
		end
		basePanel:registerScriptHandler(basePanelMessageFun)
	end

	if _delay < 0 then

		-- setup 
		_scriptObject.npc_id = npc_id

		_scriptObject.npc_portrait = npc_helper

		_scriptObject.dialog_node = node

		_scriptObject.dialog_dir = _d_dir

		_scriptObject.dialog_pos = { dX, dY }

		_scriptObject.keep 		= _keep

		self._talking_npcs[_dir] = _scriptObject
	end
end

function Instruction:handleUIComponentClick(id)
	print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Instruction:handleUIComponentClick',id)
	print(self.current_config == nil, self.component_id)

	if self.current_config and self.component_id == id then
		print("gogoggo1111111111111111111")
		-- 在坐骑开启的指引中保证玩家是上马状态
		if id == instruct_comps.MOUNT_WIN_RIDE_BTN and not MountsModel:get_is_shangma() then
			MountsModel:ride_a_mount()
		end
		self.component_id = nil
		self:unlock_screen() 
		self:next()
	elseif self.is_need_lock == false then
		Instruction:clear_blink_animation()
		Instruction:clear_jt_animation()
		self.is_need_lock	= nil 
	end

	if not self._instruction_components then self._instruction_components = {} end
	local comp_info = self._instruction_components[id]
	self._instruction_components[id] = nil
	if comp_info then
		if comp_info.next_id then
			print("gogoggo 22222222222")
			Instruction:start( comp_info.next_id, nil )
		end
	end
end

function Instruction:checkCondition(config)
	--遍历条件
	if config.has_quest then
		local has_quest = config.has_quest
		if has_quest then
			-- for k, q in ipairs(has_quest) do
			local q = has_quest
				if not TaskModel:if_task_accpet(q.id) then
					print('>>>>>跳过instruction 任务条件, 没有任务',q.id)
					return false
				end
				if q.state ~= nil then
					if TaskModel:is_task_finished(q.id) ~= q.state then
						print('>>>>>跳过instruction 任务条件，完成度不对',q.id)
						return false
					end
				end
				--
			-- end
		end
	end

	local vipInfo = VIPModel:get_vip_info()
	if config.vip and vipInfo then
		if vipInfo.level >= config.vip[1] and vipInfo.level <= config.vip[2] then
			return true
		else
			print('skip _instructionActionHandler vip',config.vip[1],config.vip[2],vipInfo.level)
			return false
		end
	end

	return true
end

--获取指引是否已经被播放了
function Instruction:isInstructionPlayed(id)
	return self._instructionPlayed[id]
end

--设置指引已经被播放了
function Instruction:setInstructionPlayed(id, state)
	self._instructionPlayed[id] = state
end


function Instruction:onComponentInstruction(info, which_component)
	local comp = nil
	if not which_component then
		local win = UIManager:find_window(info.component_ui)
		if not win.find_component then
	--@debug_begin
			assert(false,'界面没有实现find_component函数')
	--@debug_end
			return
		end
		comp = win:find_component(info.component_id)
	else
		comp = which_component
		local cs = comp.view:getSize()
		info.width = cs.width
		info.height = cs.height
	end
	if not comp then
		return
	end
	if info.uncertain_menu_pos then
		-- 找到控件在世界在坐标，直接调用原来的指引方法来调用指引，可以锁屏
		local x, y = comp.view:getPosition()
		local pos = comp.view:getParent():convertToWorldSpace(CCPoint(0,0))
		if info.component_ui == "menus_grow" then
			y = y + pos.y
		end
		self:play_jt_and_kuang_animation(info, pos.x+x, y)
		return
	end

	_clearLocalInstruction(comp)

	local scale_x = GameScreenConfig.ui_screen_width / info.width
	local scale_y = GameScreenConfig.ui_screen_height / info.height
	local scale = math.min( scale_x, scale_y)

	local x = info.width * 0.5
	local y = info.height * 0.5
	local width = info.width
	local height = info.height
	local dir = info.dir
	local zximg_corner = MUtils:create_zximg( comp.view, 
											  "nopack/ani_corner.png", 
											  x, y, 
											  width, height,
											  CORNER,CORNER, JT_ZORDER)

	zximg_corner:setAnchorPoint(0.5,0.5)
	zximg_corner:setScale(scale)
	local action = CCScaleTo:actionWithDuration(0.2,1.0,1.0);
	local remove = CCRemove:action()
	local array = CCArray:array();
	array:addObject(action);
	array:addObject(remove);
	local seq = CCSequence:actionsWithArray(array)
	action:setTag(_SCALE_RECT_ACTION_TAG)
	zximg_corner:runAction(seq)


	zximg_corner:setTag(UI_TAG_INSTRUCTION_RECT)

	----------------------------------------
	local blink_view_ropt = MUtils:create_zximg(comp.view,"nopack/ani_corner.png",
										   x, y, 
										   width, height, CORNER,CORNER, JT_ZORDER)
	blink_view_ropt:setAnchorPoint(0.5,0.5)
	_colorTint(blink_view_ropt)
	blink_view_ropt:setTag(UI_TAG_INSTRUCTION_BLINK)
	----------------------------------------
	local px 			= info.jt_x or 0
	local py 			= info.jt_y or 0
	local zximg_jt 		= nil
	local jt_image 		= info.jt_image or _dir_to_img[dir][1]			-- 箭头资源
	local label_image 	= info.label_image or _dir_to_img[dir][2]			-- 字牌资源
	if dir == 1 then
		zximg_jt = MUtils:create_sprite(comp.view, jt_image, px, py, JT_ZORDER)
		zximg_jt:setAnchorPoint(CCPointMake(0, 0.5))
		local sz = zximg_jt:getContentSize()
		zximg_jt:setPosition(CCPointMake(px + sz.width,py + height * 0.5))

		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0)
		label:setPosition(71,23)

	elseif dir == 2 then
		zximg_jt = MUtils:create_sprite(comp.view, jt_image, 0, 0, JT_ZORDER)
		zximg_jt:setFlipX(true)
		zximg_jt:setAnchorPoint(CCPointMake(0, 0.5))
		local sz = zximg_jt:getContentSize()
		zximg_jt:setPosition(CCPointMake(px -sz.width, height * 0.5))

		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0)
		label:setPosition(45,23)

	elseif dir == 3 then
		zximg_jt = MUtils:create_sprite(comp.view, jt_image, px, py, JT_ZORDER);
		zximg_jt:setAnchorPoint(CCPointMake(0.5, 0))
		local sz = zximg_jt:getContentSize()
		zximg_jt:setPosition(CCPointMake(px + width / 2,- sz.height))

		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0)
		label:setAnchorPoint(CCPointMake(0.5,0.5))
		label:setPosition(44,17)

	elseif dir == 4 then
		zximg_jt = MUtils:create_sprite(comp.view, jt_image, px, py, JT_ZORDER);
		zximg_jt:setFlipY(true);
		zximg_jt:setAnchorPoint(CCPointMake(0.5, 0))
		zximg_jt:setPosition(CCPointMake(px + width / 2, height))

		local sz = zximg_jt:getContentSize()
		local label = MUtils:create_sprite(zximg_jt, label_image, 0, 0);
		label:setPosition(44,52)
	end
	LuaEffectManager:run_move_animation( dir, zximg_jt )

	zximg_jt:setTag(UI_TAG_INSTRUCTION_POINTER)
	----------------------------------------

	if not which_component then
		local comp_id = info.component_id
		local comp_info = self._instruction_components[comp_id]
		if comp_info then
			if comp_info.next_id then
				Instruction:start( comp_info.next_id, nil )
			end
		end
		----------------------------------------
		self._instruction_components[comp_id] = { next_id = info.next_id }
	end

	self:cleanNextStepNPCTalks()


	if info.talk then
		self:npc_talk(info.talk)
	end
	
	if not info.next_id then
		self:next()
	else
		self:finish()
	end
end

function Instruction:onMiniTaskCreateTask(comp,task_id)
	
	if self._mini_task_quests[task_id] == false then
		return
	end

	local config = InstructionConfig:get_mini_task_instruction_by_task_id(task_id)
	if config then
		local count = self._mini_task_quests[task_id] or 0
		local talk = config.talk
		if count > 0 then
			config.talk = nil
		end
		self:onComponentInstruction(config,comp)
		config.talk = talk
		count = count + 1
		self._mini_task_quests[task_id] = count
	end
end


function Instruction:onMiniTaskClick(comp,task_id)
	-- body
	local n = tonumber(self._mini_task_quests[task_id])
	if n then
		_clearLocalInstruction(comp)
		self._mini_task_quests[task_id] = false
	end
end

function Instruction:set_state(state)
	XSZY_STATE = state
end

function Instruction:get_state()
	return XSZY_STATE
end

-- 上坐骑指引
function Instruction:ride_mount_drag( param )
	if GameSysModel:isSysEnabled(GameSysModel.MOUNT) and MountsModel:get_is_shangma( ) then
		MountsModel:ride_a_mount( )
	end

	Instruction:set_is_instruct(true)

	-- if param.talk then
	-- 	Instruction:npc_talk(param.talk)
	-- end

	local ui_node = Instruction.ui_node
	local lock_panel = CCArcRect:arcRectWithColor(0,0, _ui_width, _ui_height, 0x00000055);

	self.drag_out_bg = CCProgressTimer:progressWithFile("nopack/up.png");
	self.drag_out_bg:setAnchorPoint(CCPoint(0.5,0));
	self.drag_out_bg:setType( kCCProgressTimerTypeVerticalBarBT );
	self.drag_out_bg:setPosition(CCPoint(_ui_width/2,200));

	self.spr_hand = CCSprite:spriteWithFile("nopack/ani/hand1.png");
	self.spr_hand:setAnchorPoint(CCPoint(0.5,0))
	self.spr_hand:setPosition(CCPoint(_ui_width/2+100,160));

	local label_img = CCSprite:spriteWithFile(param.label_image)
	label_img:setAnchorPoint(CCPoint(0, 0))
	label_img:setPosition(CCPoint(80, 20))
	self.spr_hand:addChild(label_img)

	ui_node:addChild(self.spr_hand,99999);
	ui_node:addChild(self.drag_out_bg,99999);

	local start_x,start_y = 0,0;

	local function panel_fun(eventType,arg,msgid,selfitem)
		if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
			return
		end
		if  eventType == TOUCH_BEGAN then
			local click_pos = Utils:Split(arg, ":")
			start_x = click_pos[1];
			start_y = click_pos[2];
			return true;
		elseif eventType == TOUCH_CLICK then
			return true;
		elseif eventType == TOUCH_ENDED then
			local click_pos = Utils:Split(arg, ":")
			local end_x = click_pos[1];
			local end_y = click_pos[2];
			if ( end_y - start_y > 100 ) then
				-- 上坐骑
				MountsModel:ride_a_mount( )
				_safeRemoveFromParentAndCleanup(lock_panel,true)
				lock_panel = nil;
				_safeRemoveFromParentAndCleanup(self.drag_out_bg,true)
				self.drag_out_bg = nil
				_safeRemoveFromParentAndCleanup(self.spr_hand,true)
				self.spr_hand = nil
				Instruction:cleanNPCTalks()
				Instruction:set_is_instruct(false)

				-- 继续做任务
				AIManager:continue_quest()
			end
			return true;
		end
		return true;
	end
	lock_panel:registerScriptHandler(panel_fun);
	ui_node:addChild(lock_panel,JT_ZORDER-1);

	local moveto1 = CCMoveTo:actionWithDuration(1.2,CCPoint(_ui_width/2+100,460))
	local delay_time = CCDelayTime:actionWithDuration(0.49);
	local moveto   = CCMoveTo:actionWithDuration(0.01,CCPoint(_ui_width/2+100,160));
	
	local _array = CCArray:array();
	_array:addObject(moveto1)
	_array:addObject(delay_time)
	_array:addObject(moveto);

	local sequence = CCSequence:actionsWithArray(_array);
	local repeatForever = CCRepeatForever:actionWithAction(sequence);

	local progressTo_action  = CCProgressTo:actionWithDuration(1.2, 100);
	local delay_time2 = CCDelayTime:actionWithDuration(0.5);
	local _array2 = CCArray:array();
	_array2:addObject(progressTo_action)
	_array2:addObject(delay_time2)

	local sequence2 = CCSequence:actionsWithArray(_array2);
	local repeatForever2 = CCRepeatForever:actionWithAction(sequence2);
	
	self.drag_out_bg:runAction(repeatForever2);
	self.spr_hand:runAction(repeatForever);
end

function Instruction:drag_skill_zy( param )
	Instruction:set_is_instruct(true)
	local anchor = param.anchor or 5
	local px, py = _calculateScreenPos(param.x, param.y, anchor)
	-- if param.talk then
	-- 	Instruction:npc_talk(param.talk)
	-- end

	local ui_node = Instruction.ui_node
	-- local lock_panel = CCArcRect:arcRectWithColor(0,0, _ui_width, _ui_height, 0x00000055);

	self.drag_out_bg = CCProgressTimer:progressWithFile("nopack/drag_out_help2.png");
	self.drag_out_bg:setAnchorPoint(CCPoint(0.5,0));
	self.drag_out_bg:setType( kCCProgressTimerTypeVerticalBarTB );
	self.drag_out_bg:setPosition(CCPoint(px,py));

	self.spr_hand = CCSprite:spriteWithFile("nopack/ani/hand1.png");
	self.spr_hand:setAnchorPoint(CCPoint(0.5,0))
	self.spr_hand:setPosition(CCPoint(px+40,py+ 343));

	local label_img = CCSprite:spriteWithFile(param.label_image)
	label_img:setAnchorPoint(CCPoint(0, 0))
	label_img:setPosition(CCPoint(80, 20))
	self.spr_hand:addChild(label_img)

	ui_node:addChild(self.drag_out_bg,99999);
	ui_node:addChild(self.spr_hand,99999);

	-- lock_panel:registerScriptHandler(panel_fun);
	-- ui_node:addChild(lock_panel,JT_ZORDER-1);

	local moveto1 = CCMoveTo:actionWithDuration(1,CCPoint(px+10,py-50))
	local delay_time = CCDelayTime:actionWithDuration(0.49);
	local moveto   = CCMoveTo:actionWithDuration(0.01,CCPoint(px+40,py+343));
	
	local _array = CCArray:array();
	_array:addObject(moveto1)
	_array:addObject(delay_time)
	_array:addObject(moveto);

	local sequence = CCSequence:actionsWithArray(_array);
	local repeatForever = CCRepeatForever:actionWithAction(sequence);

	local progressTo_action  = CCProgressTo:actionWithDuration(1, 100);
	local delay_time2 = CCDelayTime:actionWithDuration(0.5);
	local _array2 = CCArray:array();
	_array2:addObject(progressTo_action)
	_array2:addObject(delay_time2)

	local sequence2 = CCSequence:actionsWithArray(_array2);
	local repeatForever2 = CCRepeatForever:actionWithAction(sequence2);
	
	self.drag_out_bg:runAction(repeatForever2);
	self.spr_hand:runAction(repeatForever);
end

-- 显示拖动帮助动画
function Instruction:create_drag_out_animation( config)
	Instruction:destroy_drag_out_animation()
	-- local config = { component_id = 401, x = 411, y = 220, dir = 3, width = 80, height = 79, anchor = 5, jt_image = nil, label_image = "nopack/xszy/5.png",label_index=5, },	
	local px, py 		= _calculateScreenPos(config.x, config.y, config.anchor)
	if ( config.new_drag == 1 ) then
		self.drag_out_spr = ZXEffectManager:sharedZXEffectManager():run_bezier_action("nopack/drag_out_help.png","nopack/ani/hand1.png", px+100, py,CCPoint(100, 0),CCPoint(190, -30),CCPoint(303,-75),CCPoint(17,70));
		-- Instruction:play_jt_and_kuang_animation( config );
	elseif ( config.new_drag == 2 ) then
		self:ride_mount_drag(config)
	-- 	-- Instruction:play_jt_and_kuang_animation( config );
	elseif ( config.new_drag == 3 ) then
		self:drag_skill_zy(config)
	end
	if self.drag_out_spr ~= nil then
		self.ui_node:addChild(self.drag_out_spr,JT_ZORDER)
	end
end

-- 清除拖动帮助
function Instruction:destroy_drag_out_animation()
	local need_next = false
	if ( self.drag_out_spr ) then 
		_safeRemoveFromParentAndCleanup(self.drag_out_spr,true)
		self.drag_out_spr = nil;
		need_next = true
	end
	if (self.drag_out_bg) then
		_safeRemoveFromParentAndCleanup(self.drag_out_bg,true)
		self.drag_out_bg = nil;
		need_next = true
	end
	if (self.spr_hand) then
		_safeRemoveFromParentAndCleanup(self.spr_hand,true)
		self.spr_hand = nil;
		need_next = true
	end
	if need_next then self:next() end
end

-- 增加一种等待类型，避免指引完成后玩家去和npc对话导致窗口被销毁
function Instruction:continue_next()

	if self.waiting_next ~= nil and self.waiting_next == true then
		self.waiting_next = false
		self:next()
	end
end

-- 获取是否在无锁屏状态下
function Instruction:get_is_unlock()
	return self.unlock
end