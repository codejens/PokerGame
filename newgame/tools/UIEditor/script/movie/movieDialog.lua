movieDialog = {}

movieScreenText = {}

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local HEAD_RIGHT_POS_X = _refWidth(1.0) 
local HEAD_LEFT_POS_X = 0

local animBack  = "nopack/ani_bottom.png"
local hand_pos_x_1 = 830;
local hand_pos_x_2 = 640;
local _MOVIE_DIALOG_IDLE = 0
local _MOVIE_DIALOG_SHOW = 1
local _MOVIE_DIALOG_CLOSE = 2
local _SCREEN_TEXT_FONTSIZE = 20
local _SCREEN_TEXT_LINE_HEIGHT = 20
local _SCREEN_END_DELAY = 3.0
local dialog_left_x = 290
local dialog_right_x = 200
local dialog_beg_y = 0
local dialog_y = 90
-- 半身像坐标
local head_left_x = 0
local head_right_x = _refWidth(1.0) - 200
local name_pos_y = 90
-- 对话内容阴湿怀
local title_bg_left_x = 125
local title_bg_right_x = _refWidth(1.0) - 830
local _backHeight = 960
local _dialog_time = 999
-- aligntype 
--    ALIGN_LEFT = 1,
--    ALIGN_CENTER = 2,
--    ALIGN_RIGHT = 3,
LabelFader = simple_class()

function LabelFader:__init(view)
	self.fader = TimeLerp()
	self.view = view
	--
end

function LabelFader:fade()
	self.view:setAlpha(0)
	local function _fader(t)
		self.view:setAlpha(t * 255)
	end
	self.fader:start(0.05, 0.5, _fader)
end

function LabelFader:show()
	self.fader:stop()
	self.view:setAlpha(255)
end

function LabelFader:destroy()
	self.fader:stop()
	self.view:setAlpha(255)
	self.view = nil
end

local function create_zxfont(parent,str,pos_x,pos_y,aligntype,fontsize,z)
	print('create_zxfont', aligntype,fontsize)
    local lab = nil;
    if ( aligntype == nil or fontsize == nil) then
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str);
    else
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str, fontsize,aligntype);
    end
    if(z == nil) then 
        z = 0;
    end
    parent:addChild(lab,z);
    return LabelFader(lab);
end

local function createSprite(root, path, x, y)
	--[[
	local sprite = CCSprite:spriteWithFile(path);
	sprite:setPosition(CCPointMake(x,y))
	sprite:setAnchorPoint(CCPointMake(0,0))
	root:addChild(sprite)
	]]--
	local sprite = EntityPortrait()
	root:addChild(sprite.view)
	return sprite
end

function movieDialog:init()

	local view = CCBasePanel:panelWithFile(0,0,_refWidth(1.0),_refWidth(1.0),nil,0,0);
	view:setAnchorPoint(0.0,0.0)

	local function panel_fun(eventType,x,y)
		-- print("panel_fun",eventType)
        if	eventType == TOUCH_CLICK then
	        movieDialog:next()
        end
        return true;
    end
    view:registerScriptHandler(panel_fun);

	local dialog = MUtils:create_ccdialogEx(view,"",320,100,550,10,30,18);
	dialog:setAnchorPoint(0, 1);
	dialog:setCurState(CLICK_STATE_DISABLE)

	-- 背景，不同的阵营需要翻转x
	self.ui_node = ZXLogicScene:sharedScene():getUINode();
	self.view = view
	-- self.bottom_bg = MUtils:create_sprite(view,animBack,100,0,-1);
	self.bottom_bg = CCZXImage:imageWithFile(100,0,786,-1,animBack, 500, 500)
	self.view:addChild(self.bottom_bg, -1)
	self.bottom_bg:setAnchorPoint(0.0,0.0)
	self.bottom_bg:setScaleX(GameScreenConfig.ui_screen_width / _backHeight)
	self.name_bg = MUtils:create_zximg(self.view, "nopack/npc_name_bg.png", head_left_x+100, 0, 250, -1)
    self.name_lab = ZLabel:create(self.name_bg, name, 22, 10, 16, ALIGN_RIGHT)
	self.dialogView = dialog
	self.head_table = {}
	self.cur_head_id = nil
	self.hand = LuaEffectManager:playAniWithArgs(view,{"nopack/ani/hand1.png","nopack/ani/hand2.png"},90,50,0.5,10000000 )
	self.text_play_timer = nil
	self.ui_node:addChild(self.view,Z_MOVIE+5);
	self.state = _MOVIE_DIALOG_IDLE
end

function movieDialog:play(dialog_data, finish_cb)
	self:stop()
	self:init()
	self.dialog_data_index = 0
	self.dialog_data = dialog_data
	self.finish_cb = finish_cb

	self.state = _MOVIE_DIALOG_SHOW
	self:next()
	self:show_panel_action(true)
end

local function headFadeIn(head, delaytime)
   	local fade = CCFadeTo:actionWithDuration(0.5,255)
   	head:stopAllActions()
   	if delaytime then
	   	local delay = CCDelayTime:actionWithDuration(delaytime)
	   	local seq = CCSequence:actionOneTwo(delay,fade)
	   	head:setOpacity(0)
	   	head:runAction(seq)
	else
	   	head:setOpacity(0)
	   	head:runAction(fade)
	end
end

function movieDialog:show_panel_action( is_ani )
	if is_ani then
		self.view:setPosition(0,-300);
		local move_by = CCMoveTo:actionWithDuration(1.0,CCPoint(0,0));
	   	local move_ease_in = CCEaseIn:actionWithAction(move_by,5.0);
	   	self.view:runAction(move_ease_in);
	else
		self.view:setPosition(0,0);
	end
end

function movieDialog:moveOut()
	print('moveOut:')
	local move_by = CCMoveTo:actionWithDuration(1.0,CCPoint(0,-300));
	local move_ease_in = CCEaseIn:actionWithAction(move_by,5.0);
	self.view:runAction(move_ease_in);

	if self.dismiss_callback then
		self.dismiss_callback:cancel()
	else
		self.dismiss_callback = callback:new()
	end
	self.dismiss_callback:start(1.0, function() movieDialog:stop() end)
end

function movieDialog:clean()

	if self.next_callback then
		self.next_callback:cancel()
		self.next_callback = nil
	end

	if self.text_play_timer then
		self.text_play_timer:stop()
		self.text_play_timer = nil;
	end

	if self.delaySetText then
		self.delaySetText:cancel()
	end

	if self.dismiss_callback then
		self.dismiss_callback:cancel()
	end

	if self.head_table then
		for k, v in pairs(self.head_table) do
			v = nil
		end
	end
	self.head_table = {}
	self.cur_head_id = nil
end

function movieDialog:stop()
	self:clean()
	if self.view then
		self.view:removeFromParentAndCleanup(true)
	end
	self.view = nil
	self.bottom_bg = nil
	self.dialogView = nil
	self.hand = nil
	self.ui_node = nil
end

function movieDialog:next()
	if self.next_callback then
		self.next_callback:cancel()
	end

	if self.state == _MOVIE_DIALOG_CLOSE then
		return
	end

	if self.view == nil then
		return
	end

	if not self.next_callback then
		self.next_callback = callback:new()
	end
	self.next_callback:start(_dialog_time, function() movieDialog:next() end)

	self.dialog_data_index = self.dialog_data_index + 1
	
	if self.dialog_data_index > #self.dialog_data then
		if self.next_callback then
			self.next_callback:cancel()
		end
		self.state = _MOVIE_DIALOG_CLOSE
		self:moveOut()
		self.finish_cb()
		return
	end
	local dialog_info = self.dialog_data[self.dialog_data_index]
	-- 先隐藏旧的头像
	for k, v in pairs(self.head_table) do
		v:setIsVisible(false)
	end
--	if self.cur_head_id then
--		self.head_table[self.cur_head_id]:setIsVisible(false);
--	end

	local delay_time = 0.0

	-- 头像id
	local head_id = dialog_info.face;
	local name = dialog_info.name or ""
	local player = EntityManager:get_player_avatar()
	if name == "player" then
		name = player.name
	end
	self.name_lab:setText(name)
	-- 如果这个头像不存在就创建它
	if ( self.head_table[head_id] == nil ) then
		require '../data/npc'
		-- local tab_npc_info = npc_config[head_id];
		local head_path = ""
		if head_id == 0 then
			local tab_npc_info = player_half[player.job]
			head_path = string.format( "scene/npc_half/2/%s.png", tab_npc_info );
		else
			local tab_npc_info = npc_dialog_config[head_id]
			head_path = string.format( "scene/npc_half/1/%s.png", tab_npc_info );
		end
		
        -- local name = Utils:parseNPCName(name)
        -- local spr_bg = MUtils:create_zximg(self.view,UILH_PRIVATE.head_bg,head_left_x,0,-1,-1,500,500)
        local spr_bg = CCZXImage:imageWithFile(0,-50,-1, -1,head_path)
        self.view:addChild(spr_bg)
    	-- spr_bg:setTag(0)
    	-- self.select_entity_head = ZCCSprite:create(spr_bg,head_path,47,52)
    	self.head_table[head_id] = spr_bg
		-- if head_id == 0 then
		-- 	local player = EntityManager:get_player_avatar()
		-- 	local player_id = -(player.job * 10 + player.sex)
		-- 	local head = createSprite(self.view,head_id,0,0)
		-- 	self.head_table[head_id] = head
		-- 	head:setPortrait(player_id,false,bind(headFadeIn,head.half_body,delay_time))
		-- else
		-- 	local head = createSprite(self.view,head_id,0,0)
		-- 	self.head_table[head_id] = head
		-- 	head:setPortrait(head_id,false,bind(headFadeIn,head.half_body,delay_time))
		-- end
	else
		local head = self.head_table[head_id]
		head:setIsVisible(true);
		-- headFadeIn(head.half_body)
	end
	-- 保存旧头像
	-- self.cur_head_id = head_id;

	-- local half_body = self.head_table[head_id].half_body
	-- local default_view = self.head_table[head_id].default_view

	if dialog_info.dir > 0 then
		self.bottom_bg:setFlipX(true);
		self.bottom_bg:setPosition(title_bg_right_x, dialog_beg_y)
		self.name_bg:setFlipX(true);
		self.name_lab:setPosition(70, 19)
		self.hand:setPosition(CCPoint(hand_pos_x_2,dialog_beg_y));
		self.dialogView:setPosition(title_bg_right_x+150,dialog_beg_y+dialog_y);
		self.head_table[head_id]:setPosition(head_right_x, dialog_beg_y)
		self.head_table[head_id]:setFlipX(true);
		self.name_bg:setPosition(head_right_x - 175, dialog_beg_y+name_pos_y)
		-- half_body:setPosition(CCPointMake(HEAD_RIGHT_POS_X,0))
		-- half_body:setAnchorPoint(CCPointMake(1,0))
		-- half_body:setFlipX(true);

		-- default_view:setPosition(CCPointMake(HEAD_RIGHT_POS_X,0))
		-- default_view:setAnchorPoint(CCPointMake(1,0))
		-- default_view:setFlipX(true);
	else
		self.bottom_bg:setFlipX(false);
		self.bottom_bg:setPosition(title_bg_left_x, dialog_beg_y)
		self.name_bg:setFlipX(false)
		self.name_lab:setPosition(175, 18)
		self.hand:setPosition(CCPoint(hand_pos_x_1,dialog_beg_y));
		self.dialogView:setPosition(dialog_left_x,dialog_beg_y+dialog_y);
		self.head_table[head_id]:setPosition(head_left_x, dialog_beg_y)
		self.head_table[head_id]:setFlipX(false);
		self.name_bg:setPosition(head_left_x + 150, dialog_beg_y + name_pos_y)
		-- self.head_table[head_id]:setFlipX(false)
		-- half_body:setPosition(CCPointMake(HEAD_LEFT_POS_X,0))
		-- half_body:setAnchorPoint(CCPointMake(0,0))
		-- half_body:setFlipX(false);

		-- default_view:setPosition(CCPointMake(HEAD_LEFT_POS_X,0))
		-- default_view:setAnchorPoint(CCPointMake(0,0))
		-- default_view:setFlipX(false);
	end
	--print('>>>>>>>>>>>>>>>>>>>>>>>>>', head:getPosition())


	--self:headFadeIn(head,delay_time)
	-- 播放文字动画
	local text = dialog_info.talk;

	--替换表情
	-- text = movieParseDialogText(text,dialog_info.emote)
	if self.delaySetText then
		self.delaySetText:cancel()
	else
		self.delaySetText = callback:new()
	end

	local func = function() self:setText(text) end
	if self.dialog_data_index == 1 then
		self.delaySetText:start(1.5,func)
	else
		func()
	end
end
-- 播放文字动画
function movieDialog:setText( str )
	
	self.dialogView:setText('')
	if ( self.text_play_timer ) then
		self.text_play_timer:stop();
		self.text_play_timer = nil;
	end

	self.text_play_timer = timer();

	local dialogList = splitDialogText(str)	
	local index = 1
	local function text_cb()
		-- 如果读完所有字符串，结束文字动画
		result_str = dialogList[index]
		if result_str then
			self.dialogView:insertText(result_str);
			index = index + 1	
		end
	end
	self.text_play_timer:start(0.05,text_cb);
end

----------------------------------------------------------
--
----------------------------------------------------------
function movieScreenText:init()

	local view = CCBasePanel:panelWithFile(0,0,_refWidth(1.0),_refHeight(1.0),'nopack/black.png',0,0);
	view:setAnchorPoint(0.0,0.0)
	view:setTag(0)
	local function panel_fun(eventType,x,y)
		-- print("panel_fun",eventType)
        if	eventType == TOUCH_CLICK then
	        self:next()
        end
        return true;
    end
    view:registerScriptHandler(panel_fun);

	local dialog = MUtils:create_ccdialogEx(view,"",245,65,400,10,30,_SCREEN_TEXT_FONTSIZE);
	dialog:setAnchorPoint(0, 1);
	dialog:setCurState(CLICK_STATE_DISABLE)

	-- 背景，不同的阵营需要翻转x
	self.ui_node = ZXLogicScene:sharedScene():getUINode();
	self.view = view
	self.hand = LuaEffectManager:playAniWithArgs(view,{"nopack/ani/hand1.png",
													   "nopack/ani/hand2.png"},90,50,0.5,10000000 )
	self.hand:setPosition(_refWidth(1.0) - 180,90)
	self.text_play_timer = nil
	self.ui_node:addChild(self.view,Z_MOVIE+5);
	self.state = _MOVIE_DIALOG_IDLE
	self.dismiss_callback = callback:new()
	self.fadoutTimeLerp = TimeLerp()
	--print('>>>>>>>>>>>>>>>',self.bottom_bg)
end

function movieScreenText:clean()
	if self.text_play_timer then
		self.text_play_timer:stop()
		self.text_play_timer = nil;
	end

	if self.fadoutTimeLerp then
		self.fadoutTimeLerp:stop()
	end

	if self.dismiss_callback then
		self.dismiss_callback:cancel()
	end
end

function movieScreenText:stop()
	self:clean()
	if self.labelList then
		for i,v in ipairs(self.labelList) do
			v:destroy()
		end
		self.labelList = nil
	end
	if self.view then
		self.view:removeFromParentAndCleanup(true)
	end
	self.view = nil
	self.hand = nil
	self.ui_node = nil
end

function movieScreenText:screenText(dialog_data, finish_cb)
	movieScreenText:stop()
	movieScreenText:init()
	self.dialog_data_index = 1
	self.step = 1
	self.dialog_data = dialog_data
	self.finish_cb = finish_cb
	self.state = _MOVIE_DIALOG_SHOW

	local textHeight = _SCREEN_TEXT_LINE_HEIGHT * #dialog_data
	self.posY = GameScreenConfig.ui_screen_height * 0.5 + textHeight * 0.5

	self:playText()
end

function movieScreenText:finish()
	self.state = _MOVIE_DIALOG_CLOSE
	self:stop()
	self.finish_cb()
end

function movieScreenText:next()
	if self.step == 1 then
		self:skipText()
	else
		self:finish()
	end
	self.step = self.step + 1
end

local function _fadeout(t)
	if t == 1.0 then
		movieScreenText:finish()
		return
	end
	t = 1.0 - t
	movieScreenText.view:setOpacity(t)
	local _list = movieScreenText.labelList
	for i, lab in ipairs(_list) do
		lab.view:setAlpha(t*255)
	end
end

function movieScreenText:fadout()
	self.fadoutTimeLerp:start(0.05,0.5,_fadeout)
end

function movieScreenText:playText()
	--[[
	if self.dialog_data_index > #self.dialog_data then
		self.state = _MOVIE_DIALOG_CLOSE
		self:stop()
		self.finish_cb()
		return
	end
	]]--
	self.labelList = {}
	local y = self.posY
	local sw = _refWidth(1.0)
	for i,v in ipairs(self.dialog_data) do
		v = movieParseDialogText(v,{})
		local lab = create_zxfont(self.view,v,0,0,1,_SCREEN_TEXT_FONTSIZE)
		local view = lab.view
		local sz = view:getContentSize()
		view:setPosition( (sw - sz.width) * 0.5 ,y)
		y = y - _SCREEN_TEXT_LINE_HEIGHT
		self.labelList[#self.labelList+1] = lab
		view:setAlpha(0)
	end

	self.dialog_data_index = 1
	local function text_cb()
		if self.dialog_data_index > #self.labelList then
			self:_endOfLineEffects()
			return
		end
		local lab = self.labelList[self.dialog_data_index]
		lab:fade()
		self.dialog_data_index = self.dialog_data_index + 1
	end

	self.text_play_timer = timer();
	self.text_play_timer:start(0.5,text_cb);

end

function movieScreenText:_endOfLineEffects()
	self.text_play_timer:stop()
	self.dismiss_callback:start(_SCREEN_END_DELAY,bind(self.fadout,self))
end

function movieScreenText:skipText()
	for i,lab in ipairs(self.labelList) do
		lab:show()
	end
	self:_endOfLineEffects()
end