-- ShangJinBuffView.lua
-- created by fjh on 2013-3-13
-- 赏金的buff视图


super_class.ShangJinBuffView(Window)

local buff_dismiss_callback  = callback:new()
function ShangJinBuffView:show_buff( buff )

	self.buff = buff;
	
	self:destroy_buff();
	UIManager:show_window("shangjin_buff");

end

--从外部调用，减少一次cancel，同时减少犯错机会
function ShangJinBuffView:destroy_buff(  )
	buff_dismiss_callback:cancel()
	self:__destroy_buff()
end

--给回调调用的
function ShangJinBuffView:__destroy_buff(  )
	UIManager:destroy_window("shangjin_buff");
end

function ShangJinBuffView:__init(  )
	
	--倒计时背景
	local progress_bg = CCZXImage:imageWithFile(635,430,249,70,UI_ShangJinBuff_001);
	self:addChild(progress_bg);

	--倒计时
	local progressTo_action  = CCProgressTo:actionWithDuration(self.buff.alive_time, 0);
  	local progressTimer = CCProgressTimer:progressWithFile( UI_ShangJinBuff_002 );
  	progressTimer:setPercentage(99);
  	progressTimer:setType( kCCProgressTimerTypeHorizontalBarLR );
  	progressTimer:setPosition(CCPointMake(249/2, 70/2));
  	progressTimer:runAction( progressTo_action );
  	progress_bg:addChild(progressTimer);

  	--计时销毁
  	local function dismiss( dt )
	    self:__destroy_buff();
	    FuBenModel:clear_shangjin_money( );
 	end

 	buff_dismiss_callback:start(self.buff.alive_time, dismiss)

  	--赏金图片
  	local lab_img = CCZXImage:imageWithFile(664,460,80,44,UI_ShangJinBuff_003);
	self:addChild(lab_img);

	
	local money = FuBenModel:get_shangjin_money();
	
	local money_lab = UILabel:create_lable_2( "+"..tostring(money), 739,460 , 22, ALIGN_LEFT )
	self:addChild(money_lab);

	self.view:setDefaultMessageReturn(false)
	
end