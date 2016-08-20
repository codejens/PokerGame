---------hcl
---------2014-11-4
---------
---------带有通知功能的按钮(当按钮代表的系统有可操作项时，显示右上角的数字，或者显示特效)
---------当按钮可以点击时显示特效
super_class.ZNoticeButton(ZButton)
---------
---------

local EFFECT_TABLE = { 
	UISTYLE_ZIMAGEBUTTON_FOUR_WORD = 11036,

	UISTYLE_ZTEXTBUTTON_TWO_WORD = 11033,
	UISTYLE_ZTEXTBUTTON_THREE_WORD = 11034,
	UISTYLE_ZTEXTBUTTON_FOUR_WORD = 11035,
	UISTYLE_ZTEXTBUTTON_MARRIAGE = 11039,

	UISTYLE_ZBUTTON_CIRCLE = 11037,
	UISTYLE_ZBUTTON_MAINWIN = 11038,

}

function ZNoticeButton:createByStyle(style,fatherPanel, fun, layout )
	local _self = ZNoticeButton(style);
	local btn = nil;
	if style == UISTYLE_ZIMAGEBUTTON_TWO_WORD or 
		style == UISTYLE_ZIMAGEBUTTON_THREE_WORD or
		style == UISTYLE_ZIMAGEBUTTON_FOUR_WORD then 
		btn = ZImageButton:createByStyle( style,layout )
		_self.view = btn.view;
	elseif style == UISTYLE_ZTEXTBUTTON_TWO_WORD or
		    style == UISTYLE_ZTEXTBUTTON_THREE_WORD or
		    style == UISTYLE_ZTEXTBUTTON_FOUR_WORD or 
		    style == UISTYLE_ZTEXTBUTTON_MARRIAGE then
		btn = ZTextButton:createByStyle( style ,layout)
		_self.view = btn.view
	elseif style == UISTYLE_ZBUTTON_MAINWIN or 
		style == UISTYLE_ZBUTTON_CIRCLE then
		btn = ZButton:create(nil, layout.image, nil, layout.posX, layout.posY);
		_self.view = btn.view
	end
	local function btn_fun()
		_self:stopClickEffect( )
		fun();
	end
	btn:setTouchClickFun( btn_fun )
	_self.btn = btn;
	fatherPanel:addChild(_self.view);

	return _self
end

function ZNoticeButton:__init( style )
	self._style = style;
	self.isShowEffect = false;
	self.btn = nil;
end

-- 按钮可点击特效
function ZNoticeButton:showClickEffect( posx,posy )
	LuaEffectManager:stop_view_effect( EFFECT_TABLE[self._style],self.view )
	self.isShowEffect = true
	local _posx = posx;
	local _posy = posy;
	if _posx == nil or _posy == nil then
		local size = self.btn:getSize();
		_posx = size.width/2
		_posy = size.height/2
	end
	LuaEffectManager:play_view_effect( EFFECT_TABLE[self._style],
		_posx,_posy,self.view,true )
end

function ZNoticeButton:stopClickEffect()
	if self.isShowEffect then
		LuaEffectManager:stop_view_effect( EFFECT_TABLE[self._style],self.view )
		self.isShowEffect = nil;
	end
end

-- 按钮闪烁特效
function ZNoticeButton:showBlinkEffect( blink_path )
	if self.blinkSpr == nil then
		self.blinkSpr = MUtils:create_sprite(self.view, blink_path, 0,0,0);
		self.blinkSpr:setAnchorPoint(CCPointMake(0,0));
		--创建一个闪烁的效果
	    local fade_out = CCFadeOut:actionWithDuration(0.5);
	    local fade_in = CCFadeIn:actionWithDuration(0.5);
	    local seq_act = CCSequence:actionOneTwo( fade_out, fade_in);
	    local forever_act = CCRepeatForever:actionWithAction(seq_act);
	    self.blinkSpr:runAction( forever_act );
	end
end

function ZNoticeButton:stopBlinkEffect()
	if self.blinkSpr then
		self.blinkSpr:stopAllActions()
		self.blinkSpr:removeFromParentAndCleanup(true);
		self.blinkSpr = nil;
	end
end
-- 按钮增加倒计时
function ZNoticeButton:setTime( _time )
    if self.timer_lab then
        self.timer_lab:setText( _time )
    else
        self:create_time_lab( _time )
    end
end

function ZNoticeButton:getTime()
    if self.timer_lab then
        return self.timer_lab:getText()
    end
    return 0;
end

function ZNoticeButton:create_time_lab( time,end_func )
    local function time_end(  )
        if self.timer_lab then
           self.timer_lab:destroy();
           self.timer_lab = nil;
        end
        if end_func then
            end_func()
        end
    end
    if time then
        -- parent, x, y, fontSize, time, color, end_call, brief, alignment
        local size = self.view:getSize();
       self.timer_lab = TimerLabel:create_label(self.view, size.width/2, -13, 12, time, nil, time_end,false, ALIGN_CENTER);
    end
end

function ZNoticeButton:destroy()
    if self.timer_lab then
        self.timer_lab:stop_timer();
        self.timer_lab = nil 
    end
    if self.view then
        self.view:removeFromParentAndCleanup(true);
        self.view = nil
    end	
end

function ZNoticeButton:set_image_texture( path )
	self.btn:set_image_texture(path);
end

function ZNoticeButton:onActive()
	if self.isShowEffect then
		self:stopClickEffect()
		self:showClickEffect();
	end
	if self.blinkSpr then
		self:stopBlinkEffect();
		self:showBlinkEffect();
	end
end