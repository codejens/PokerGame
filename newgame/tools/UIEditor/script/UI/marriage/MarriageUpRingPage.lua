-- MarriageUpRingPage.lua
-- create by fjh 2013-8-15
-- 升级戒指分页

super_class.MarriageUpRingPage()

function MarriageUpRingPage:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	-- 底纹
	local img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."logo.png", 350/2-256/2, 380/2-247/2+15, 256, 247 );
	
	--终极戒指
	local final_ring = MUtils:create_one_slotItem( 11106, 148, 308-23+15, 48, 48 );
	final_ring:set_icon_bg_texture( UILH_NORMAL.special_grid, -12, -12, 110, 110 )
	final_ring:set_color_frame(nil);
	self.view:addChild(final_ring.view);
	local function show_final_ring_tip(  )
		TipsModel:show_marriage_ring( 11106, 10, TipsModel.LAYOUT_LEFT)
	end
	final_ring:set_click_event( show_final_ring_tip );
	-- 极品预览
	
	local lab = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."jipin.png", 131, 301-33, 80, 20 );
	-- self.view:addChild(lab);

	-- 当前戒指
	self.curr_ring = MUtils:create_one_slotItem( nil, 45, 186, 48, 48 );

	self.view:addChild(self.curr_ring.view);

	-- 箭头 arrow
	local arrow = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."arrow.png", 150-12, 186, 75, 45 );
	
	-- 下级戒指

	self.next_ring = MUtils:create_one_slotItem( nil, 265, 186, 48, 48 );
	self.view:addChild(self.next_ring.view);

	-- 需要情意
	self.need_qingyi_lab = UILabel:create_lable_2( LangGameString[1521], 110,144, 17, ALIGN_LEFT ); -- [1521]="#cfff000需要情意: #cffffff0"
    self.view:addChild( self.need_qingyi_lab );

    -- 提升
    local uplevel_btn = TextButton:create( nil, 350/2-87/2, 95, 87, 34, LangGameString[1522], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1522]="#cfafed0提升"
	self.view:addChild( uplevel_btn.view );
	local function up_level_ring(  )

		local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
		if ring_model then
			if ring_model.item_id == MarriageModel.MAX_RING_ITEM_ID and ring_model.strong == 10 then
				-- 最高阶最高级的婚戒不可升级
				GlobalFunc:create_screen_notic("您的婚戒已经升到最高级!"); -- [1523]="您的婚戒已经升到最高级!"
			else
				local need_qy = MarriageConfig:get_need_qy_for_uplevel( ring_model.item_id, ring_model.strong );
				local data = MarriageModel:get_marriage_data();

				if data.qingyi >= need_qy  then
					MarriageModel:req_up_level_ring(  )
					-- 播放特效
					self:play_xy_uplevel_effect();
				else
					GlobalFunc:create_screen_notic("您的情意值不足，不能升级戒指!") -- [1524]="您的情意值不足，不能升级戒指!"
				end
			end
		end
		

		

		local cb = callback:new()
		local function update_ui(  )
			
			-- 更新戒指
			self:update();
			--更新情意度
			local data = MarriageModel:get_marriage_data();
        	-- self.qingyuan_page:update_sweet_value( data.sweet );
        	self:update_curr_qingyi_value( data.qingyi );
    		cb:cancel();
		end
		cb:start( 0.5,update_ui )
		
	end
	uplevel_btn:setTouchClickFun(up_level_ring);


	--戒指获得
	local ring_help_btn = TextButton:create( nil, 15, 10, 87, 34, LangGameString[1525], nil ); -- [1525]="#cfff000#u1戒指获得#u0"
	self.view:addChild( ring_help_btn.view );
	local function ring_help_event(  )
		-- print("戒指获得");
		local str = LangGameString[1526] -- [1526]="1、通关深海之恋获得心之碎片8个可合成出求婚戒指深海之心(未激活)#r2、通过商城购买雪月情缘超值礼包或仙侣情缘超值礼包获得#r3、向心仪对象求婚成功，则未激活戒指则转变为结婚戒指佩戴在身上#r4、被求婚者也获得同样的结婚戒指佩戴在身上"
		HelpPanel:show( 3, UIResourcePath.FileLocate.marriage.."tip_title_4.png", str );
	end
	ring_help_btn:setTouchClickFun(ring_help_event);

	--情意获得
	local qingyi_help_btn = TextButton:create( nil, 15+245, 10, 87, 34, LangGameString[1527], nil ); -- [1527]="#cfff000#u1情意获得#u0"
	self.view:addChild( qingyi_help_btn.view );
	local function qingyi_help_event(  )
		local str = LangGameString[1528]; -- [1528]="1、每种戒指可以提升到10级，继续提升，可以升级为最高品质的戒指#r2、戒指提升需要情意，情意可以通过云车巡游获得#r3、婚姻关系解除，系统回收戒指，并且退还50%情意"
		HelpPanel:show( 3, UIResourcePath.FileLocate.marriage.."tip_title_3.png", str );
	end
	qingyi_help_btn:setTouchClickFun(qingyi_help_event);

	-- 当前情意
	self.curr_qingyi_lab = UILabel:create_lable_2(LangGameString[1529], 335,10+30, 17, ALIGN_RIGHT ) -- [1529]="#cff66cc当前情意: #cffffff0"
	self.view:addChild(self.curr_qingyi_lab);


	self.effect_view = CCBasePanel:panelWithFile( 0, 0, w, h,"");
	self.view:addChild(self.effect_view);

	-- 更新戒指信息
	self:update();

end

function MarriageUpRingPage:active( show )
	if show then
		self:update();
		local data = MarriageModel:get_marriage_data( );
	    if data.qingyi ~= nil then
	        self:update_curr_qingyi_value( data.qingyi )
	    end
	else
		self.effect_view:removeAllChildrenWithCleanup(true);
	end
end

--------------------界面更新

-- 更新整个界面
function MarriageUpRingPage:update(  )

	-- 当前戒指
	local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
	local ring_id = nil;
	if ring_model then
		-- 是否有佩戴结婚戒指(婚戒不可卸下，只有离婚才可卸下)
		ring_id = ring_model.item_id;
	end	
	if ring_id ~= nil then
		self.curr_ring:set_icon(ring_id);
		self.curr_ring:set_color_frame(ring_id);
	else
		self.curr_ring:set_icon_texture("");
	end

	local function show_curr_ring_tip(  )
		
		TipsModel:show_tip( 0,0, ring_model, nil, nil, true, nil, nil, TipsModel.LAYOUT_LEFT);
	end
	self.curr_ring:set_click_event(show_curr_ring_tip);


	--下级戒指
	local next_ring_id = nil;
	local next_level = 1;
	if ring_model then
		if ring_model.strong >= 10 then
			--  下一品阶的婚戒
			if ring_id ~= 11106 then
				--11106是天荒地老婚戒，为最高品阶
				next_ring_id = ring_id+1;
			else
				next_ring_id = ring_id;
				next_level = 10;
			end
		else
			-- 同一品阶的婚戒，下一等级
			next_ring_id = ring_id;
			next_level = ring_model.strong + 1;
		end
	end

	if next_ring_id then
		self.next_ring:set_icon(next_ring_id);
		self.next_ring:set_color_frame(next_ring_id);
	else
		self.next_ring:set_icon_texture("");
	end

	local function next_ring_event(  )
		if next_ring_id == 11106 and next_level == 10 then
			-- 最高阶最高等级不显示tip
		else
			TipsModel:show_marriage_ring( next_ring_id, next_level, TipsModel.LAYOUT_LEFT)
		end
	end
	self.next_ring:set_click_event(next_ring_event);
end
	

-- 更新情意值
function MarriageUpRingPage:update_curr_qingyi_value( qingyi_value )

	self.curr_qingyi_lab:setText("#cff66cc当前情意: #cffffff"..qingyi_value); -- [1530]="#cff66cc当前情意: #cffffff"

	local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
	if ring_model then
		local need_qy = MarriageConfig:get_need_qy_for_uplevel( ring_model.item_id, ring_model.strong );
		self.need_qingyi_lab:setText( "#cfff000需要情意: #cffffff"..need_qy ); -- [1531]="#cfff000需要情意: #cffffff"
	end

end

-- 播放戒指等级升级成功的特效
function MarriageUpRingPage:play_xy_uplevel_effect(  )

	LuaEffectManager:play_view_effect( 408, 174, 185, self.effect_view, false);

end

