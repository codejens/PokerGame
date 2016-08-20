-- LuckGuestWin.lua
-- create by hcl on 2013-10-29
-- 幸运猜猜

super_class.LuckGuestWin(Window)

function LuckGuestWin:__init( )	

	self.is_lj = false;
	self.is_start_game = false;

	local _right_up_panel = ZBasePanel.new(UI_MountsWinNew_003, 840, 530)
	_right_up_panel:setPosition(38,20)
    self.view:addChild(_right_up_panel.view)

	-- -20,-30
	local panel = CCArcRect:arcRectWithColor(48,30,820,510, 0x00000099);
	self.view:addChild(panel);

	self:create_close_btn_and_title();
	self.tip = MUtils:create_sprite(self.view,"ui/loginaward/t_xzryygjl.png",400,440)
	self.tip:setIsVisible(false);
	MUtils:create_zxfont(self.view,LangGameString[1426],483,50,2,15); -- [1426]="#c35C3F7温馨提示:连续登录,每日可增加一次次数哦！(至多3次)"
	-- 开始游戏按钮
	local function start_game_fun( event_type,args,msgid)
		if event_type == TOUCH_CLICK then
			if ( self.is_start_game == false ) then
				ClosedBateActivityCC:req_start_guess()
				self.start_game_btn:setCurState( CLICK_STATE_DISABLE )
			end
		end
		return true;
	end
	self.start_game_btn = MUtils:create_btn(self.view,UI_GeniusWin_0027,nil,start_game_fun,350,60+20,130,40)
	MUtils:create_sprite(self.start_game_btn,"ui/loginaward/start_game.png",65.5,21)
	self.guest_count = MUtils:create_zxfont(self.view,LangGameString[1427],480,70+20,1,20); -- [1427]="剩余次数:3"

	self.gaizi_tab = {};
	self.slot_item_tab = {};
	for i=1,3 do
		local function btn_fun(event_type,msgid,args)
			if event_type == TOUCH_CLICK then
				if self.is_start_game and self.is_lj == false then
					self.is_lj = true;
					local pos_x = self.gaizi_tab[i]:getPosition();
					local index = (pos_x - 150)/250 + 1;
					ClosedBateActivityCC:req_open_b( index )
					self.curr_select_index = i;
				end 
			end
			return true
		end
		--	parent,filepath,selectedpath,func,pos_x,pos_y,width,height
		self.gaizi_tab[i] = MUtils:create_btn(self.view,"ui/loginaward/gaizi.png",nil,btn_fun,200 + (i-1)*250,370,-1,-1,5);
		self.gaizi_tab[i]:setAnchorPoint(0.5,0.5);
		self.slot_item_tab[i] = MUtils:create_slot_item(self.view,"ui/normal/item_bg01.png",170 + (i-1)*250,150,72,72);
	end
end

function LuckGuestWin:create_close_btn_and_title()
	-- self.window_title_bg.view:removeFromParentAndCleanup(true);
    -- local function close_fun(event_type,args,msgid )
    --     if event_type == TOUCH_CLICK then
    --         UIManager:destroy_window("luck_guest_win");
    --     end
    --     return true
    -- end
    -- MUtils:create_btn(self.view,"ui/loginaward/b_close.png",nil,close_fun,720,430,-1,-1)

end

function LuckGuestWin:play_animation( item_tab )

	
	for i=1,3 do
		local move_by = CCMoveBy:actionWithDuration(0.7,CCPoint(0,-60));
		self.gaizi_tab[i]:runAction(move_by);
	end

	self.ani_timer = timer();
	local index = 1;
	local function ani_timer_cb()

		if ( index == 1 ) then 
			for i=1,3 do
				self.slot_item_tab[i].view:setIsVisible(false);
			end
		end

		if index == 6 then
			for i=1,3 do
				local pos_x = self.gaizi_tab[i]:getPosition();
				print("gaizi_pos_x",pos_x);
			end
			local target_id = item_tab[1];
			local start_index = 1;
			for i=1,3 do
				local pos_x = self.gaizi_tab[i]:getPosition();
				if ( pos_x == 150 ) then
					start_index = i;
				end
			end
			local end_index = 0;
			for j=1,3 do
				if self.slot_item_tab[j].item_id == target_id then
					-- local pos_x = self.gaizi_tab[j]:getPosition();
					-- local index = (pos_x - 150)/250 + 1
					end_index = j;
					print(self.slot_item_tab[j].item_id, target_id,j)
					break;
				end
			end
			print("index == 6",start_index,end_index)
			if ( start_index == end_index ) then
				local old_start_index = start_index;
				for i=1,3 do
					local pos_x = self.gaizi_tab[i]:getPosition();
					if ( pos_x == 400 ) then
						-- print("start_index",start_index)
						start_index = i;
					end
				end
				print(item_tab[2],self.slot_item_tab[start_index].item_id,start_index)
				if ( item_tab[2] ~= self.slot_item_tab[start_index].item_id ) then
					if ( old_start_index == 1 ) then
						start_index = 2;
						end_index = 3;
					elseif old_start_index == 2 then
						start_index = 1;
						end_index = 3;
					elseif old_start_index == 3 then
						start_index = 1;
						end_index = 2;
					end
					print("index == 6",start_index,end_index);
					self:create_bezier_ani( start_index,end_index )
				else
					self:layout_item(item_tab)
				end
			else
				self:create_bezier_ani( start_index,end_index )
			end
			
		elseif index == 7 then
			local target_id = item_tab[2];
			local start_index = 2;
			for i=1,3 do
				local pos_x = self.gaizi_tab[i]:getPosition();
				if ( pos_x == 400 ) then
					start_index = i;
				end
			end
			local end_index = 0;
			for j=1,3 do
				print(self.slot_item_tab[j].item_id, target_id)
				if self.slot_item_tab[j].item_id == target_id then
					-- local pos_x = self.gaizi_tab[j]:getPosition();
					-- local index = (pos_x - 150)/250+1
					end_index = j;
					break;
				end
			end
			print("index == 7",start_index,end_index)
			if ( start_index ~= end_index ) then
				self:create_bezier_ani( start_index,end_index )
			else
				self:layout_item(item_tab)
			end
		elseif index == 8 then
			print("index == 8")
			self:layout_item(item_tab)
		else
			local random_num = MUtils:get_random_num( 1,3 );
			local random_num2 = 0;
			for i=1,10 do
				random_num2 = MUtils:get_random_num(1,3);
				print("random_num2",random_num2)
				if ( random_num2~=random_num ) then
					break;
				end
			end
			self:create_bezier_ani( random_num,random_num2 )
		end
		index = index + 1;

	end
	self.ani_timer:start(0.8,ani_timer_cb);
end

function LuckGuestWin:layout_item( item_tab )

	for i=1,3 do
		print(self.gaizi_tab[i]:getPosition(),self.slot_item_tab[i].item_id,item_tab[i]);
	end

	self.ani_timer:stop();
	self.ani_timer = nil;
	self.is_start_game = true;
	-- 调整所有的位置
	for i=1,3 do
		local item_id = item_tab[i]; 
		print("---------------item_id",item_id);
		self.slot_item_tab[i]:set_icon_ex( item_id,1 );
	end
	self.tip:setIsVisible(true);
end

function LuckGuestWin:create_bezier_ani( index_1,index_2 )
	print("index_1,index_2",index_1,index_2)
	local pos_x_1,pos_y_1 = self.gaizi_tab[index_1]:getPosition();
	local pos_x_2,pos_y_2 = self.gaizi_tab[index_2]:getPosition();
	local half_p = math.abs(pos_x_2-pos_x_1)/2;

	local bezier1 = ccBezierConfig();
	bezier1.controlPoint_1 = CCPoint( pos_x_1,pos_y_1 );
	bezier1.controlPoint_2 = CCPoint( half_p, pos_y_1 + half_p/2 );
	bezier1.endPosition = CCPoint(pos_x_2,pos_y_2);
	local bezierTo1 = CCBezierTo:actionWithDuration(0.5, bezier1 );

	local bezier2 = ccBezierConfig();
	bezier2.controlPoint_1 = CCPoint( pos_x_2,pos_y_2 );
	bezier2.controlPoint_2 = CCPoint( half_p, pos_y_2 - half_p/2 );
	bezier2.endPosition = CCPoint(pos_x_1,pos_y_1);
	local bezierTo2 = CCBezierTo:actionWithDuration(0.5, bezier2 );

	self.gaizi_tab[index_1]:runAction(bezierTo1)
	self.gaizi_tab[index_2]:runAction(bezierTo2)

end

function LuckGuestWin:update_guest_count( count )
	print("LuckGuestWin:update_guest_count( count )",count)
	self.guest_count:setText(LangGameString[1428]..count); -- [1428]="剩余次数:"
	if ( count > 0 ) then
		self.start_game_btn:setCurState( CLICK_STATE_UP )
	else
		self.start_game_btn:setCurState( CLICK_STATE_DISABLE )
	end
end

function LuckGuestWin:update_all( item_tab )
	for i=1,3 do
		print("item_tab[i]",item_tab[i])
		self.slot_item_tab[i]:set_icon_ex( item_tab[i] );
		self.slot_item_tab[i] = MUtils:create_slot_item(self.view,"ui/normal/item_bg01.png",170 + (i-1)*250,150,72,72);
	end
end

function LuckGuestWin:destroy(  )
	if 	self.ani_timer then
		self.ani_timer:stop();
		self.ani_timer = nil;
	end
	if 	self.open_timer then
		self.open_timer:stop();
		self.open_timer = nil;
	end
	Window.destroy(self);
end

function LuckGuestWin:show()

	local win = UIManager:find_visible_window("luck_guest_win")
	if win then
		return;
	end

	ClosedBateActivityCC:req_luck_guess_count()
	ClosedBateActivityCC:req_luck_guess_p()
end

function LuckGuestWin:on_open_b( item_id )

	self.tip:setIsVisible(false);

	LoginAwardModel:set_guest_count( LoginAwardModel:get_guest_count()-1 )

	print(" self.curr_select_index ", self.curr_select_index );
	for i=1,3 do
		self.slot_item_tab[i].view:setIsVisible(true);
	end
	local move_by = CCMoveBy:actionWithDuration(0.8,CCPoint(0,60));
	self.gaizi_tab[ self.curr_select_index ]:runAction(move_by);

	self.open_timer = timer();
	local index = 1;
	local function timer_fun()
		if ( index == 1 ) then
			for i=1,3 do
				if ( i ~= self.curr_select_index ) then
					local move_by = CCMoveBy:actionWithDuration(0.8,CCPoint(0,60));
					self.gaizi_tab[ i ]:runAction(move_by);
				end
			end
		elseif index == 2 then
			GlobalFunc:create_screen_notic(LangGameString[1429]) -- [1429]="3秒后游戏重新开始"
			CountDownView:show( 0, 3 )
		elseif index == 4 then
			if LoginAwardModel:get_guest_count() > 0 then
				ClosedBateActivityCC:req_luck_guess_p()
			end
			self.open_timer:stop();
			self.open_timer = nil;
			self.is_start_game =false;
			self.is_lj = false
			self.start_game_btn:setCurState( CLICK_STATE_UP )
		end
		index = index + 1
		
	end
	self.open_timer:start( 1.5,timer_fun );
end
