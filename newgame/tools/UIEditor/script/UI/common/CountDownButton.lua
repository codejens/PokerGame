-- CountDownButton.lua
-- created by fjh on 2013/5/9
-- 倒计时按钮

super_class.CountDownButton()

function CountDownButton:destroy(  )
    if self.timer_lab then
        self.timer_lab:destroy();
    end
    self:remove_effect()
    if self.view then
        self.view:removeFromParentAndCleanup(true);
    end
	
end

function CountDownButton:__init( x, y, w, h, btn_img, btn_bg, click_func, time, end_func, not_hide_spr)
	
	self.h = h;
	self.w = w;
	self.img = btn_img;
	self.click_func = click_func;

    local function panel_click()
        return true
    end
	self.view = CCBasePanel:panelWithFile(x,y,w+4,h,"");
    self.view:registerScriptHandler(panel_click)
    if btn_bg then
        self.bt_bg = btn_bg
    	self.spr = MUtils:create_sprite(self.view, btn_bg, 0, 0,-1);
        self.spr:setScale(0.93)
    	self.spr:setAnchorPoint(CCPointMake(0,0));
    	--创建一个闪烁的效果
        local fade_out = CCFadeOut:actionWithDuration(0.5);
        local fade_in = CCFadeIn:actionWithDuration(0.5);
        local seq_act = CCSequence:actionOneTwo( fade_out, fade_in);
        local forever_act = CCRepeatForever:actionWithAction(seq_act);
        if not_hide_spr ~= true then
            self.spr:runAction( forever_act );
        end
    end

    local function click_event( eventType )
    	
    	if eventType == TOUCH_CLICK then
            if self.spr and not_hide_spr ~= true then
    		  -- self.spr:stopAllActions();
              self.spr:removeFromParentAndCleanup(true);
              self.spr = nil
            end
    		if click_func then
    			click_func(eventType);
    		end
    	end
    	return true;
    end

    MUtils:create_btn(self.view,self.img,self.img,click_event,2,2,w,h);
	-- self.view:registerScriptHandler(click_event);
	
    local function time_end(  )
        -- self.timer_lab的销毁放到destroy方法中
        -- if self.timer_lab then
    	   -- self.timer_lab:destroy();
        -- end
	    if end_func then
	        end_func()
	    end
    end
    if time then
    	-- parent, x, y, fontSize, time, color, end_call, brief, alignment
        local brief_flag = false
        if time > 3600 then
            brief_flag = true
        end
       self.timer_lab = TimerLabel:create_label(self.view, w/2, -13, 12, time, nil, time_end, brief_flag, ALIGN_CENTER);
    end
end

function CountDownButton:add_spr_bg()
    if self.spr == nil and self.btn_bg then
        self.spr = MUtils:create_sprite(self.view, btn_bg, -2, 3,-1);
        self.spr:setScale(0.805)
        self.spr:setAnchorPoint(CCPointMake(0,0));
        --创建一个闪烁的效果
        local fade_out = CCFadeOut:actionWithDuration(0.5);
        local fade_in = CCFadeIn:actionWithDuration(0.5);
        local seq_act = CCSequence:actionOneTwo( fade_out, fade_in);
        local forever_act = CCRepeatForever:actionWithAction(seq_act);
        self.spr:runAction( forever_act );
    end
end

function CountDownButton:add_effect(x, y)
    LuaEffectManager:stop_view_effect( 11041, self.view )
    LuaEffectManager:play_view_effect( 11041, x, y, self.view, true)
end

function  CountDownButton:remove_effect( )
    LuaEffectManager:stop_view_effect( 11041, self.view )
end
-- function CountDownButton:remove_timer_lable(  )
-- 	if self.timer_lab then
		
-- 	end
-- end
