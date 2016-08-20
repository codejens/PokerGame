-- LoginAwardWin.lua
-- create by hcl on 2013-10-28
-- 每日登录福利

require "UI/component/Window"
super_class.LoginAwardWin(Window)

function LoginAwardWin:show(  )

	local win = UIManager:find_visible_window("login_award_win")
	if win then
		return ;
	end

	ClosedBateActivityCC:req_fp_count(  )
	ClosedBateActivityCC:req_login_award_p( );
	ClosedBateActivityCC:req_accept_login_award( 0 )
end

function LoginAwardWin:__init( )

	-- 背景图片
	local bg_l = MUtils:create_sprite(self.view,"ui/loginaward/bg.png",270,214.5)
	bg_l:setAnchorPoint(CCPoint(1.0,0.5));
	local bg_r = MUtils:create_sprite(self.view,"ui/loginaward/bg.png",270,214.5)
	bg_r:setFlipX(true);
	bg_r:setAnchorPoint(CCPoint(0,0.5));
	local t1_bg = MUtils:create_sprite(self.view,"ui/loginaward/t_bg2.png",270,363);
	MUtils:create_sprite(t1_bg,"ui/loginaward/t_mtlxdl.png",114,15.5)
	local t2_bg = MUtils:create_sprite(self.view,"ui/loginaward/t_bg2.png",270,166);
	MUtils:create_sprite(t2_bg,"ui/loginaward/t_bzljdl.png",114,15.5)
	MUtils:create_sprite(self.view,"ui/loginaward/line.png",270,175);
	MUtils:create_sprite(self.view,"ui/loginaward/line.png",270,335);
	-- 9个道具
	self.item_tab = {};
	self.item_bg = {};
	
	for i=1,9 do
		local function slot_item_fun(  )
			print( "self.is_start_fp",self.is_start_fp ,LoginAwardModel:get_fp_count() );
			if ( self.is_start_fp  ) then
				if  LoginAwardModel:get_fp_count() > 0 then
					local item_tab = LoginAwardModel:get_login_award_item_tab();
					if ( item_tab[i].type == 1 ) then
						GlobalFunc:create_screen_notic( LangGameString[1415] ); -- [1415]="这张牌已经翻过了"
					else
						if ( self.is_fp_ing == false ) then
							self.is_fp_ing = true;
							ClosedBateActivityCC:req_start_fp(i)
							self.curr_select_index = i;
						end
					end
				end
			end
		end
		self.item_tab[i] = MUtils:create_slot_item(self.view,"ui/loginaward/item_bg.png",58 + (i-1)%3*54,288 - 50*math.floor((i-1)/3),48,48,nil,slot_item_fun);
	end
	-- 3个星星
	self.star_tab = {};
	for i=1,3 do
		self.star_tab[i] = MUtils:create_sprite(self.view,"ui/normal/star_big.png",345+(i-1)*28,327)
		self.star_tab[i]:setScale(0.7);
		self.star_tab[i]:setIsVisible(false);
		self.star_tab[i+3] = MUtils:create_sprite(self.view,"ui/normal/star_big2.png",345+(i-1)*28,327)
		self.star_tab[i+3]:setScale(0.7);
		self.star_tab[i+3]:setIsVisible(false);
	end

	MUtils:create_zxfont(self.view,"#cff66cc可翻牌次数",220,316,1,20);
	self.login_lab = MUtils:create_zxfont(self.view,"#c03a1b0已连续登录2天",220,293,1,16);
	self.week_login_lab = MUtils:create_zxfont(self.view,"#c03a1b0累计已登录2天",220,273,1,16);
	-- 开始翻牌按钮
    local function fp_fun(event_type,args,msgid )
        if event_type == TOUCH_CLICK then

        	if self.is_fp == false and LoginAwardModel:get_fp_count() > 0 then 
        		-- 申请洗牌
        		ClosedBateActivityCC:req_start_xp(  )
        		self.fp_btn:setCurState( CLICK_STATE_DISABLE )
        		print("self.is_fp,self.fp_btn:setCurState( CLICK_STATE_DISABLE )")
        	end
        end
        return true
    end
    self.fp_btn = MUtils:create_btn(self.view,"ui/common/button_red.png",nil,fp_fun,360,268,-1,-1)
    MUtils:create_sprite(self.fp_btn,"ui/loginaward/bt_ksfp.png",65.5,21)
    -- 4行字
   	MUtils:create_zxfont(self.view,"#ca7a7a61.连续登录1天,可获得1次翻牌机会;",220,250,1,14);
	MUtils:create_zxfont(self.view,"#ca7a7a62.连续登录2天,可获得2次翻牌机会;",220,230,1,14);
	MUtils:create_zxfont(self.view,"#ca7a7a63.连续登录≥3天,可获得3次翻牌机会;",220,210,1,14);
	MUtils:create_zxfont(self.view,"#ca7a7a64.如中途中断登录则重新开始计算。",220,190,1,14);
	-- 本周累计登录礼包标题
	local award_tab = OpenSerConfig:get_login_award(  )
	-- self.lq_spr_tab = {};
	for i=1,3 do
		local spr = MUtils:create_sprite(self.view,"ui/loginaward/t_bg.png",145 + (i-1)*125,141)
		MUtils:create_sprite(spr,"ui/loginaward/a"..i..".png",50,9.5)
		local slot_item = MUtils:create_slot_item(self.view,"ui/normal/item_bg01.png",119 + (i-1)*127,78 ,62,62,award_tab[i]);
		slot_item.view:setScale(48/62);
		-- self.lq_spr_tab[i] = MUtils:create_sprite(self.view,"ui/loginaward/wlq.png",119 + (i-1)*127,78);
		-- self.lq_spr_tab[i+3] = MUtils:create_sprite(self.view,"ui/loginaward/ylq.png",119 + (i-1)*127,78);
	end
	MUtils:create_sprite( self.view,"ui/loginaward/jt.png",216,105 )
	MUtils:create_sprite( self.view,"ui/loginaward/jt.png",340,105 )
    -- 领取奖励
    local function fp_fun(event_type,args,msgid )
        if event_type == TOUCH_CLICK then
        	ClosedBateActivityCC:req_accept_login_award( 1 )
        end
        return true
    end
    self.btn_lj = MUtils:create_btn(self.view,"ui/common/button_red.png",nil,fp_fun,217,35,-1,-1)
    MUtils:create_sprite(self.btn_lj,"ui/loginaward/bt_lqjl.png",65.5,21)

    self:create_close_btn_and_title();
end

function LoginAwardWin:create_close_btn_and_title()
    -- 标题
   	MUtils:create_sprite(self.view,"ui/loginaward/t_title.png",270,400)
    -- local function close_fun(event_type,args,msgid )
    --     if event_type == TOUCH_CLICK then
    --         UIManager:destroy_window("login_award_win");
    --     end
    --     return true
    -- end
    -- MUtils:create_btn(self.view,"ui/loginaward/b_close.png",nil,close_fun,480,388,-1,-1)
    -- self.exit_btn:setPosition(480,388)
    -- self.window_title_bg.view:removeFromParentAndCleanup(true);

end

function LoginAwardWin:start_fp_action()
	for i=1,9 do
		self.item_tab[i].view:setIsVisible(false);
		self.item_tab[i]:set_gem_level( nil )
	end
	for i=1,9 do
		local pos_x,pos_y = self.item_tab[i].view:getPosition();
		LuaEffectManager:play_view_effect( 11018,pos_x,pos_y,self.view,false,100 )
	end
	-- 0.12*7 = 0.84
	self.fp_timer = timer();
	local index = 1;
	local function fp_timer()
		if ( index == 1 ) then
			for i=1,9 do
				self.item_tab[i]:set_icon_bg_texture("ui/loginaward/award_bg.png");
				self.item_tab[i]:set_icon_ex(nil);
				self.item_tab[i].view:setIsVisible(true);
			end
			for i=1,9 do
				local moveto = CCMoveTo:actionWithDuration(0.8,CCPoint(112,238));
				self.item_tab[i].view:runAction(moveto);
			end
		elseif ( index == 2 ) then
			for i=1,9 do
				local pos_x = 58 + (i-1)%3*54;
				local pos_y = 288 - 50*math.floor((i-1)/3);
				local moveto = CCMoveTo:actionWithDuration(0.8,CCPoint(pos_x,pos_y));
				self.item_tab[i].view:runAction(moveto);
			end
		elseif ( index == 3 ) then
			self.fp_timer:stop();
			self.fp_timer = nil;
			self.is_start_fp = true;
		end
		index = index + 1;
	end
	self.fp_timer:start(0.85,fp_timer)
end

function LoginAwardWin:update_all( is_fp )
	self.is_fp = is_fp;
	self.is_fp_ing = false;
	local item_tab = LoginAwardModel:get_login_award_item_tab();
	if ( is_fp and LoginAwardModel:get_fp_count() > 0 ) then
		for i=1,9 do
			if ( item_tab[i].type == 1 ) then
				self.item_tab[i]:set_icon_bg_texture("ui/loginaward/item_bg.png");
				self.item_tab[i]:set_icon_ex( item_tab[i].item_id )
				self.item_tab[i]:set_gem_level( item_tab[i].item_id )
				self.is_start_fp = true;
			else
				self.item_tab[i]:set_icon_bg_texture("ui/loginaward/award_bg.png");
				self.item_tab[i]:set_icon_ex(nil);
			end
		end
		self.fp_btn:setCurState( CLICK_STATE_DISABLE )
	else
		for i=1,9 do
			self.item_tab[i]:set_icon_bg_texture("ui/loginaward/item_bg.png");
			self.item_tab[i]:set_icon_ex(item_tab[i].item_id);
			self.item_tab[i]:set_gem_level( item_tab[i].item_id )
		end
		self.fp_btn:setCurState( CLICK_STATE_UP )
		print("		self.fp_btn:setCurState( CLICK_STATE_UP )")
	end

end

function LoginAwardWin:update_fp_count( count,day,week_day ,is_fp )
	for i=1,3 do
		if ( i <= count ) then
			self.star_tab[i]:setIsVisible(true);
			self.star_tab[i+3]:setIsVisible(false);
		else
			self.star_tab[i]:setIsVisible(false);
			self.star_tab[i+3]:setIsVisible(true);
		end
	end
	if day then
		self.login_lab:setText("#c00c0ff已连续登录"..day.."天");
	end
	if week_day then
		self.week_login_lab:setText("#c00c0ff累计已登录"..week_day.."天");
	end

	if is_fp then
		if ( count == 0 ) then
			local item_tab = LoginAwardModel:get_login_award_item_tab();
			for i=1,9 do
				if ( item_tab[i].type == 0 ) then
					self.item_tab[i].view:setIsVisible(false);
					local pos_x,pos_y = self.item_tab[i].view:getPosition();
					LuaEffectManager:play_view_effect( 11019,pos_x,pos_y,self.view,false,100 )
				end
			end
			self.fp_cb = callback:new();
			local function cb_fun()
				for i=1,9 do
					if ( item_tab[i].type == 0 ) then
						print("item_tab[i].value",item_tab[i].item_id);
						self.item_tab[i]:set_icon_ex(item_tab[i].item_id);
						self.item_tab[i]:set_icon_bg_texture("ui/loginaward/item_bg.png");
						self.item_tab[i].view:setIsVisible(true);	
					end
				end
				self.fp_cb = nil;
			end
			self.fp_cb:start( 0.85,cb_fun );
		end
	end
end

--
function LoginAwardWin:on_fp_result( item_id )
	if self.curr_select_index then
		self.item_tab[self.curr_select_index].view:setIsVisible(false);
		local pos_x,pos_y = self.item_tab[self.curr_select_index].view:getPosition();
		LuaEffectManager:play_view_effect( 11019,pos_x,pos_y,self.view,false,100 )
	end
	self.fp_cb = callback:new();
	local function cb_fun()
		self.item_tab[self.curr_select_index]:set_icon_ex(item_id);
		self.item_tab[self.curr_select_index]:set_icon_bg_texture("ui/loginaward/item_bg.png");
		self.item_tab[self.curr_select_index].view:setIsVisible(true);
		self.item_tab[self.curr_select_index]:set_gem_level(item_id);
		LoginAwardModel:get_login_award_item_tab()[self.curr_select_index].type = 1;
		self.fp_cb = nil;
		self.curr_select_index = nil;
		self.is_fp_ing = false;
		LoginAwardModel:set_fp_count( LoginAwardModel:get_fp_count() -1 ,nil,nil, true );
	end
	self.fp_cb:start( 0.85,cb_fun );
	
end

function LoginAwardWin:update_lj_btn_state( show_or_disable )
	if show_or_disable then
		self.btn_lj:setCurState(CLICK_STATE_UP)
	else
		self.btn_lj:setCurState(CLICK_STATE_DISABLE)
	end
end

function LoginAwardWin:destroy()
	print("LoginAwardWin:destroy()")
	if 	self.fp_timer then
		self.fp_timer:stop();
		self.fp_timer = nil;
	end
	Window.destroy(self);
end
