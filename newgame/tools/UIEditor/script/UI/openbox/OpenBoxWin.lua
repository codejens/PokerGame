-- OpenBoxWin.lua
-- create by hcl on 2013-11-22
-- 开箱子

super_class.OpenBoxWin(NormalStyleWindow)

local NORMAL_SPEED = 15;
local SECOND_SPEED = 10;

-- _type,1 = 砸开箱子 2,钥匙打开 3,神秘礼包打开
function OpenBoxWin:show( _type,item_series )
	self._type = _type
	self.item_series = item_series
	local player = EntityManager:get_player_avatar();
	player:stop_all_action();

		--保存道具ID
	local item =  ItemModel:get_item_by_series( self.item_series )
	if item then
		self.item_id = item.item_id
	end


	local win = UIManager:show_window("openbox_win")
	if win then
		require "../data/meirixiangouconf"
		win.tab_item = {}
		local copy_tab = nil;
		if _type == 1 then
			copy_tab = meirixiangouconf.shenmibaibaoxiangconf.zaikaiconf
			win.tab_dajiang = meirixiangouconf.shenmibaibaoxiangconf.zakaijianglixianshi
		elseif _type == 2 then
			copy_tab = meirixiangouconf.shenmibaibaoxiangconf.yaoshiconf
			win.tab_dajiang = meirixiangouconf.shenmibaibaoxiangconf.yaoshijianglixianshi
		elseif _type == 3 then
			copy_tab = meirixiangouconf.shenmilibaoconf
			win.tab_dajiang = meirixiangouconf.shenmilibaojianglixianshi
		end
		for i=1,#copy_tab do
			win.tab_item[i] = copy_tab[i];
		end
		win:init_with_args(item_series,_type);
	end
end

function OpenBoxWin:__init( )	

	--总底图
	local bg = CCZXImage:imageWithFile(11, 12, 880, 555, UILH_COMMON.normal_bg_v2, 500, 500 );
	self.view:addChild(bg)
    
    --右上底图
	self.right_bg = ZImage:create(self.view,UILH_COMMON.bottom_bg,277,180,600,360,0,44,37,44,37,44,37,44,37);



	--右上 四个角纹装饰
	local edge_pattern = CCZXImage:imageWithFile(8, 300,-1,-1,UILH_OPENBOX.huawen);
	self.right_bg:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(8, 8,-1,-1,UILH_OPENBOX.huawen);
	edge_pattern:setFlipY(true)	
	self.right_bg:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(540, 300,-1,-1,UILH_OPENBOX.huawen);
	edge_pattern:setFlipX(true)	
	self.right_bg:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(540, 8,-1,-1,UILH_OPENBOX.huawen);
	edge_pattern:setFlipX(true)
	edge_pattern:setFlipY(true)
	self.right_bg:addChild(edge_pattern)


    
    --右下底图
    local bg = CCZXImage:imageWithFile(277, 25, 600, 135, UILH_COMMON.bottom_bg, 500, 500 );
	self.view:addChild(bg)
	self.tab_dajiang_slotitem = {};
	for i=1,6 do
		self.tab_dajiang_slotitem[i] = MUtils:create_slot_item(self.view,UILH_COMMON.slot_bg,299+(i-1)*95,42,84,84)
	end

    --左上页面
	self:create_left_panel();
	-- 幸运大奖文字
	-- ZImage:create(self.view,UILH_OPENBOX.t_xydj,277,95,-1,-1);
	  local title_bg = CCZXImage:imageWithFile(379, 134, -1, -1,UILH_NORMAL.title_bg3, 500, 500 )
    local title = CCZXImage:imageWithFile(140, 12, -1, -1, UILH_OPENBOX.t_xydj)
    title_bg:addChild(title)
    self.view:addChild(title_bg)

	--点击砸开宝箱
	ZImage:create(self.view,UILH_OPENBOX.t_djzkbx,506,504,-1,-1);


	-- 宝箱按钮
	local function cj( event_type )
		print("设置速度。。。。。。。。。。。。")
		--存在该格子道具
        local item_count = ItemModel:get_item_count_by_series(self.item_series)
		if item_count <=0 then --该格子的道具已经用完
			local series_arr =  ItemModel:get_card_series_by_id( self.item_id)
			if #series_arr >0 then
		    	self.item_series =  series_arr[1]
	     	end
		end

		if self._type ~= 3 then
			OnlineAwardCC:req_smbbcj( self.item_series,self._type-1 )
		else
			OnlineAwardCC:req_smlbcj( self.item_series);
		end
		self.bx_btn.view:setIsVisible(false);
		LuaEffectManager:play_view_effect( 11026,569,351,self.view,true,5 )
	end
	self.bx_btn = ZButton:create( self.view,UILH_AWARD.baoxiang,cj,468,273,-1,-1);

	self.lab_2 = ZLabel:create(self.right_bg,"#cd0cda2神秘百宝箱:9999",560,40,16,3)
	self.lab_1 = ZLabel:create(self.right_bg,"#cd0cda2神秘钥匙:9999",560,60,16,3)


end


local slot_item_height = 100;

function OpenBoxWin:create_left_panel()
	local panel = ZBasePanel:create(self.view,UILH_COMMON.bottom_bg,25,25,250,515,500,500);
	local touch_panel = CCTouchPanel:touchPanel(10, 10, 230, 500);
	panel:addChild(touch_panel);
	ZImage:create(panel,UILH_OPENBOX.select_bg,9,206,235,100,5,500,500);

	self.tab_slot_item = {};
	-- 最多显示5个道具
	self.max_show_item = math.ceil(515/slot_item_height)
	for i=1,self.max_show_item do
		local item_panel = ZImage:create(touch_panel,UILH_COMMON.bg_11,230/2+1,(i-1)*slot_item_height,229,slot_item_height-5,0,500,500)
		item_panel.view:setAnchorPoint(0.5,0);
		local slot_item = MUtils:create_slot_item(item_panel,UILH_COMMON.slot_bg,10,8,84,84);
		slot_item:set_item_count(i);
		-- local item_name = ItemConfig:get_item_by_id( test_item_id[(i-1)*15+i] ).name;
		local item_name = "道具"..i;
		local lab_item_name = ZLabel:create(slot_item.view,"#cd0cda2" .. item_name,73,35,16,1);
		-- slot_item.view:setScale(78/84);
		item_panel.slot_item = slot_item;
		item_panel.item_name = lab_item_name;
		self.tab_slot_item[i] = item_panel;		
	end
end

-- 动画结束后,判断是否还能重开宝箱
function OpenBoxWin:movie_end_func( )
	local function rest_box_fun()
		local can_reset = false
		if self._type == 1 then 
			if ItemModel:get_item_total_num_by_id(64712)>0 then
				can_reset = true
			end 
		elseif self._type == 2 then 
			if (ItemModel:get_item_total_num_by_id(64712)>0) and (ItemModel:get_item_total_num_by_id(64713)>0) then
				can_reset = true
			end
		end
		if can_reset == true then 
		-- 	self.reset_box_open_timer:stop()
		-- 	-- 宝箱变回原来状态
		-- 	self.bx_btn.view:setIsVisible(true)
		-- 	LuaEffectManager:stop_view_effect( 11026,self.view )
		-- 	LuaEffectManager:stop_view_effect( 11025,self.view )
		-- 	LuaEffectManager:stop_view_effect( 11047,self.view )
		-- 	--
		-- 	self.is_ready = nil
		-- 	self.loop_num = nil
		-- 	self.speed    = nil
		-- 	self.speed_rate = nil
		-- 	self:init_with_args(self.item_series,self._type);
			ItemModel:open_box_show(self.item_series,self._type )
		end
	end
	if self.reset_box_open_timer == nil then
		self.reset_box_open_timer = timer()
	end
	self.reset_box_open_timer:start(4,rest_box_fun)
end

function OpenBoxWin:init_with_args( item_series,_type )
	self._type = _type;
	if _type == 3 then
		local smlibao_id = meirixiangouconf.shenmilibaoid;
		self.lab_1:setText("")
		self.smlibao_count = ItemModel:get_item_count_by_id( smlibao_id )
		self.lab_2:setText("#cd0cda2神秘礼包:"..self.smlibao_count)
	elseif _type == 1 then  --砸开
		self.lab_1:setText("")
		local smbbx_id = meirixiangouconf.baibaoxiangid;
		self.smbbx_count = ItemModel:get_item_count_by_id( smbbx_id )
		self.lab_2:setText("#cd0cda2神秘百宝箱:"..self.smbbx_count)
	elseif _type == 2 then	--钥匙开
		local ys_id = meirixiangouconf.keyitemid;
		self.ys_count = ItemModel:get_item_count_by_id( ys_id )
		self.lab_1:setText("#cd0cda2神秘钥匙:"..self.ys_count)
		local smbbx_id = meirixiangouconf.baibaoxiangid;
		self.smbbx_count = ItemModel:get_item_count_by_id( smbbx_id )
		self.lab_2:setText("#cd0cda2神秘百宝箱:"..self.smbbx_count)
	end

	self.item_series = item_series;

	self.speed = 15;
	local items_count = #self.tab_item;
	self.speed_rate = 90/items_count*0.95;

	for i=1,self.max_show_item do
		local item_id = self.tab_item[ i ][1]
		local item_count = self.tab_item[i][2]
		local item_name = ItemConfig:get_item_by_id( item_id ).name;
		self.tab_slot_item[i].slot_item:set_icon_ex(item_id)
		self.tab_slot_item[i].slot_item:set_item_count(item_count)
		self.tab_slot_item[i].item_name:setText("#cd0cda2"..item_name);
	end

	local dajiang_count = #self.tab_dajiang
	for i=1,6 do
		if i <= dajiang_count then
			local item_id = self.tab_dajiang[ i ][1]
			local item_count = self.tab_dajiang[i][2]
			self.tab_dajiang_slotitem[i]:update(item_id,item_count);
		else
			self.tab_dajiang_slotitem[i].view:setIsVisible(false);
		end
	end

	-- 每帧移动5个道具的坐标
	local curr_bottom_index = 1; 		--当前最下面的item的index;
	local function timer_fun(  )
		local is_bottom_index_change = false;
		for i=1,self.max_show_item do
			local pos_x,pos_y = self.tab_slot_item[i].view:getPosition();

			pos_y = pos_y - self.speed;
			if pos_y < -slot_item_height then
				local y = pos_y + slot_item_height;
				-- -- 计算取得道具的索引
				local item_index = (curr_bottom_index-1 + 8)%items_count+1
				--- new code -- 
				local new_index = nil;
				if self.loop_num then
					self.loop_num = math.floor(self.loop_num);
				end

				if self.loop_num == items_count-5 then 
					new_index = item_index
				else
					new_index = math.random(1,items_count);
				end
	
				--- new code --
				local item_id = self.tab_item[ new_index ][1]
				local item_count = self.tab_item[new_index][2]
				local item_info = ItemConfig:get_item_by_id( item_id )
				local item_name = _static_quantity_color[ item_info.color + 1 ] .. item_info.name;
				self.tab_slot_item[i].slot_item:update(item_id,item_count)
				self.tab_slot_item[i].view:setPosition(pos_x,slot_item_height*(self.max_show_item-1)+y);
				self.tab_slot_item[i].item_name:setText(item_name);
				curr_bottom_index = (curr_bottom_index-1 + 1)%items_count+1;
				is_bottom_index_change = true;
				-- if self.is_ready and curr_bottom_index == 1 then
				-- 	self.loop_num = self.loop_num + 1;
				-- 	if self.loop_num == 3 then
				-- 		self.is_ready = false;
				-- 	end
				-- 	print("self.is_ready",self.is_ready,self.loop_num)
				-- end

				if self.is_ready == false then
					-- self.loop_num = math.floor(self.loop_num);
					-- print("self.loop_num",self.loop_num,item_index);
					self.loop_num = self.loop_num + 1;
					-- 
					--循环了30次之后停止
					if self.loop_num >= items_count-1 then
						self.speed = 0;
						self.box_action_timer:stop();
						self.result_item_index = nil;
						self.box_action_timer = nil;
						self.start_slow_down_index = nil;
						self.stop_slow_down_index = nil;
						if self._type ~= 3 then
							-- OnlineAwardCC:req_finish_cj( self.item_series )
							if self._type == 2 then
								self.lab_1:setText("#cd0cda2神秘钥匙:"..self.ys_count-1)
							end
							self.lab_2:setText("#cd0cda2神秘百宝箱:"..self.smbbx_count-1)
						else
							-- OnlineAwardCC:req_finish_smlb_cj(self.item_series);
							self.lab_2:setText("#cd0cda2神秘礼包:"..self.smlibao_count-1)
						end
						print("self.result_item_id,self.result_item_count",self.result_item_id,self.result_item_count)
						LuaEffectManager:play_get_items_effect( {1,self.result_item_id,self.result_item_count} )
						local item_name = ItemConfig:get_item_by_id( self.result_item_id ).name;
						GlobalFunc:create_screen_notic( string.format("获得%s x %d",item_name,self.result_item_count) )
						print("动画结束.....")
						self:movie_end_func()
						LuaEffectManager:stop_view_effect( 11026,self.view )
						LuaEffectManager:play_view_effect( 11047,569,351,self.view,false,5 )
						self.ani_cb = callback:new();
						local function cb_fun()
							LuaEffectManager:play_view_effect( 11025,569,351,self.view,true,5 )
							self.ani_cb = nil;
						end
						self.ani_cb:start(0.48,cb_fun)
						return;	
					end
				end

				-- 交换位置
				if self.result_item_index and self.is_ready then
					local target_id = self.tab_item[ self.result_item_index ][1]
					local target_count = self.tab_item[ self.result_item_index ][2]
					print("item_index",item_index)
					local center_index = item_index - 5;
					if center_index <= 0 then
						center_index = center_index + items_count;
					end
					local curr_id = self.tab_item[center_index][1]
					local curr_count = self.tab_item[center_index][2]
					print("center_index",center_index,"result_item_index",self.result_item_index);
					self.tab_item[ self.result_item_index ] = {curr_id,curr_count}
					self.tab_item[ center_index ] = {target_id,target_count}
					self.is_ready = false;
					self.loop_num = 1;
				end

			else
				self.tab_slot_item[i].view:setPosition(pos_x,pos_y);
			end
		end

		if self.is_ready == false then
			self.loop_num = self.loop_num + 0.005
			self.speed = SECOND_SPEED * math.cos(math.rad( self.loop_num*self.speed_rate ))
			print("self.loop_num,self.speed",self.loop_num,self.speed)
		end

		-- if self.is_ready == false and self.result_item_index and is_bottom_index_change then
		-- 	-- print("curr_bottom_index,self.result_item_index",curr_bottom_index,self.result_item_index,is_bottom_index_change)
		-- 	if curr_bottom_index >= self.start_slow_down_index and curr_bottom_index < self.stop_slow_down_index then
		-- 		self.speed = self.speed - 0.8;
		-- 		-- print("curr_bottom_index,self.result_item_index",curr_bottom_index,self.result_item_index)
		-- 	elseif curr_bottom_index == self.stop_slow_down_index then
		-- 		self.speed = 0;
		-- 		self.box_action_timer:stop();
		-- 		self.result_item_index = nil;
		-- 		self.box_action_timer = nil;
		-- 		self.start_slow_down_index = nil;
		-- 		self.stop_slow_down_index = nil;
		-- 		OnlineAwardCC:req_finish_cj( self.item_series )
		-- 		print("动画结束.....")
		-- 		LuaEffectManager:stop_view_effect( 11026,self.view )
		-- 		LuaEffectManager:play_view_effect( 11047,430,160,self.view,false,5 )
		-- 		self.ani_cb = callback:new();
		-- 		local function cb_fun()
		-- 			LuaEffectManager:play_view_effect( 11025,430,160,self.view,true,5 )
		-- 		end
		-- 		self.ani_cb:start(0.48,cb_fun)
		-- 		return;
		-- 	end
		-- end
	end
	self.box_action_timer = timer();
	self.box_action_timer:start(0,timer_fun);
end

function OpenBoxWin:do_scale_items( parent,parent_pos_y,slot_item_height )
	-- local start_index = math.floor( math.abs(parent_pos_y)/slot_item_height ) + 1;
	-- local start_y = parent_pos_y%-slot_item_height;
	-- print("OpenBoxWin:do_scale_items----",parent_pos_y,start_index);
	-- for i=start_index,start_index+7 do
	-- 	local scale_rate = 0.8 + ( math.cos(math.rad(math.abs(170+24-start_y)/3)) )*0.2;
	-- 	print("start_y,scale_rate",start_y,scale_rate,i);
	-- 	if parent.items_panel[i] then 
	-- 		parent.items_panel[i].view:setScale( scale_rate )
	-- 	end
	-- 	start_y = start_y + slot_item_height;
	-- end
end

function OpenBoxWin:update_result( result_item_id ,count )
	-- print("打印收到百宝箱请求回调.......................",result_item_id,count)
	local win = UIManager:find_visible_window("openbox_win")
	if win then
		win.result_item_id = result_item_id;
		win.result_item_count = count;
		for i=1,#win.tab_item do
			if win.tab_item[i][1] == result_item_id then
				win.result_item_index = i;
				self.is_ready = true;
				local item_name = ItemConfig:get_item_by_id( result_item_id ).name;
				-- local items_count = #win.tab_item;
				-- win.start_slow_down_index = win.result_item_index-13;
				-- win.stop_slow_down_index = win.result_item_index-3
				-- if win.start_slow_down_index <= 0 then
				-- 	win.start_slow_down_index = items_count + win.start_slow_down_index;
				-- end
				-- if win.stop_slow_down_index <= 0 then
				-- 	win.stop_slow_down_index = items_count + win.stop_slow_down_index;
				-- end
				-- self.loop_num = 1;
				print("win.result_item_index = ",win.result_item_index,item_name,win.start_slow_down_index,win.stop_slow_down_index);
				break;
			end
		end
	end
end

function OpenBoxWin:destroy()
	if self.box_action_timer then
		self.box_action_timer:stop();
	end
	if self.reset_box_open_timer then 
		self.reset_box_open_timer:stop()
	end
	if self.ani_cb then
		self.ani_cb:cancel();
	end
	LuaEffectManager:stop_view_effect( 11026,self.view )
	LuaEffectManager:stop_view_effect( 11025,self.view )
	LuaEffectManager:stop_view_effect( 11047,self.view )
	Window.destroy(self);
end
