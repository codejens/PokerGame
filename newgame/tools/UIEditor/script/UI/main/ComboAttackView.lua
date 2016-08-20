-- ComboAttackView.lua
-- created by guozhinan on 2014-12-23
-- 连斩效果的视图


super_class.ComboAttackView(Window)

local buff_dismiss_callback  = callback:new()
function ComboAttackView:show()
	-- 只有副本才会出现连斩效果，而且赏金副本（副本id为8）不需要连斩效果
	if ((SceneManager:get_cur_fuben() == 0 and SceneManager:get_cur_scene() ~= 28) or SceneManager:get_cur_fuben() == 8) then
		UIManager:destroy_window("combo_attack_win");
		return;
	end

	local times = 1
	local win = UIManager:find_visible_window("combo_attack_win");
	if win then
		times = win.combo_attack_times + 1
		UIManager:destroy_window("combo_attack_win");
	end

	local win = UIManager:show_window("combo_attack_win");
	if win then
		win:begin(times);
	else
		-- 这步或许多余
		UIManager:destroy_window("combo_attack_win");
	end
end

--从外部调用，减少一次cancel，同时减少犯错机会
function ComboAttackView:destroy_buff(  )
	buff_dismiss_callback:cancel()
	UIManager:destroy_window("combo_attack_win");
end

function ComboAttackView:__init(  )
	self.combo_attack_times = 0
	self.alive_time = 10
	--倒计时背景
	-- self.progress_bg = CCZXImage:imageWithFile(635,430,226,51,UILH_CAttack.sword_bg);
	self.progress_bg = MUtils:create_sprite( self, UILH_CAttack.sword_bg, UIScreenPos.designToRelativeWidth(780), 430, 226, 51);
	-- self:addChild(self.progress_bg);

	--倒计时
  	self.progressTimer = CCProgressTimer:progressWithFile( "nopack/sword.png" );
  	self.progressTimer:setPercentage(99);
  	self.progressTimer:setType( kCCProgressTimerTypeHorizontalBarLR );
  	self.progressTimer:setPosition(CCPointMake(226/2, 51/2));
  	self.progress_bg:addChild(self.progressTimer);

  	-- local act_fade = CCFadeOut:actionWithDuration(self.alive_time)
  	-- self.progress_bg:runAction(act_fade)

	-- 不拦截点击事件
	self.view:setDefaultMessageReturn(false)
end

function ComboAttackView:begin(times)
	self.combo_attack_times = times;

	-- 赏金图片（斩）
  	-- self.lab_img = CCZXImage:imageWithFile(675,414,-1,-1,UILH_CAttack.zhan);
  	-- self:addChild(self.lab_img);
  	self.lab_img = MUtils:create_sprite( self.progress_bg, UILH_CAttack.zhan, 100, 30, 79, 89);


	-- 数字图片
	-- self.counter = NumView:create(times,self.view,690,424,10 )
    local function get_num_ima( one_num )
        return string.format("ui/lh_ComboAttack/CA%d.png",one_num);
    end
    self.image_num_obj = ImageNumberEx:create(times,get_num_ima,30)
    self.lab_img:addChild( self.image_num_obj.view)
    self.image_num_obj.view:setPosition(CCPointMake(100, 50))

    -- 数字附加动作
 --    local array = CCArray:array();
	-- array:addObject(CCScaleTo:actionWithDuration(0.05, 5.0));
	-- array:addObject(CCScaleTo:actionWithDuration(0.05, 6.0));
	-- array:addObject(CCScaleTo:actionWithDuration(0.05, 0.5));
	-- array:addObject(CCScaleTo:actionWithDuration(0.07, 1.0));
	-- array:addObject(CCScaleTo:actionWithDuration(0.05, 0.8));
	self.image_num_obj:runAction( ImageNumberEx.action_1 )

	-- cd 进度条(剑)
	local progressTo_action  = CCProgressTo:actionWithDuration(self.alive_time, 0);
  	self.progressTimer:runAction( progressTo_action );

  	-- 淡出
  	-- local act_fade_2 = CCFadeOut:actionWithDuration(self.alive_time)
  	-- self.lab_img:runAction(act_fade_2)
  	-- local act_fade_3 = CCFadeOut:actionWithDuration(self.alive_time)
  	-- self.image_num_obj:runAction(act_fade_3)

    -- local array = CCArray:array()
    -- array:addObject(CCDelayTime:actionWithDuration(0.3))
    -- array:addObject(CCRemove:action())
    -- self.blink_img:runAction(CCSequence:actionsWithArray(array))

  	--计时销毁
  	local function dismiss( dt )
	    UIManager:destroy_window("combo_attack_win");
 	end
 	buff_dismiss_callback:start(self.alive_time, dismiss)
end

function ComboAttackView:destroy()
	-- if self.counter then
	-- 	self.counter:destroy()
	-- end
	buff_dismiss_callback:cancel()
    Window.destroy(self)
end