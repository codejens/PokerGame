-- MarriagePageQingMi.lua
-- create by guozhinan on 2015-2-3
-- 结婚系统的第一个分页

super_class.MarriagePageQingMi()

local pos_dict = {
{179,365},
{279,397},
{360,325},
{340,231},
{278,145},
{179,68},
{78,145},
{15,231},
{0,325},
{70,397},};


function MarriagePageQingMi:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	local heart_human = CCZXImage:imageWithFile( 20, 85, -1, -1, UILH_MARRIAGE.heart_human)
	self.view:addChild(heart_human,-1)

	self.btn_dict = {};

	for i=1,10 do
		local function click_event(  )
			local marriage_data = MarriageModel:get_marriage_data();
			local level = marriage_data.level;
			if i <= marriage_data.count then
				level = level + 1;
			end
			local data = { index = i, level = level };
			TipsModel:show_heart_tip( data );
		end
		local btn = TextButton:create( nil, pos_dict[i][1], pos_dict[i][2], 81, 69, "#cfff0000", UILH_MARRIAGE.heart_gray );
		self.view:addChild( btn.view );
		btn:setTouchClickFun(click_event);
		self.btn_dict[i] = btn;
	end

	-- 倾注按钮
	local function qingzhu_btn_event()
		MarriageModel:req_uplevel_xianyuan(  )
	end
	self.qingzhu_btn = ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.qinzhu,qingzhu_btn_event,161, 9);
	self.qingzhu_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_MARRIAGE.btn1_d)
	self.qingzhu_btn.view:setCurState(CLICK_STATE_UP);
	-- self.qingzhu_btn = TextButton:create( nil, 130, 7, 123, 58, LangGameString[1509], UILH_MARRIAGE.btn1 ); -- [1509]="#cfafed0倾注"
	-- self.view:addChild( self.qingzhu_btn.view );
	-- self.qingzhu_btn:setTouchClickFun(qingzhu_btn_event);

	-- 帮助说明
	local help_btn = TextButton:create( nil, 33, 25, 87, 34, LangGameString[1510], nil); -- [1510]="#cfff000#u1帮助说明#u0"
	self.view:addChild( help_btn.view );
	local function help_btn_event(  )
		local str = LangGameString[1511]; -- [1511]="1、仙缘只有已婚玩家才能修炼，仙缘只对自己有效，仙侣修炼不会影响到自己#r2、仙缘修炼需要消耗与仙侣的亲密度#r3、亲密度可通过举办婚宴、情侣间的互赠鲜花和双修打坐、使用结婚戒指获得#r4、离婚之后，仙缘修炼效果保留，但是不能继续修炼#r5、离婚之后再婚，仙缘才可以继续修炼"
		HelpPanel:show( 3, UILH_NORMAL.title_tips, str );
	end
	help_btn:setTouchClickFun( help_btn_event );

	--详细信息
	local info_btn = TextButton:create( nil, 335, 25, 87, 34, LangGameString[1512], nil); -- [1512]="#cfff000#u1详细信息#u0"
	self.view:addChild( info_btn.view );
	local function info_btn_event(  )
		local marriage_data = MarriageModel:get_marriage_data();
	
		TipsModel:show_XY_detail_tip( marriage_data );
	end
	info_btn:setTouchClickFun( info_btn_event );


	-- 亲密度背景
	local sweet_value_bg = CCZXImage:imageWithFile( 102, 172, -1, -1, UILH_MARRIAGE.bg3)
	self.view:addChild(sweet_value_bg,-1)

	-- 当前亲密度
	-- local lab = UILabel:create_lable_2( LangGameString[1513], 215, 210, 16, ALIGN_CENTER ); -- [1513]="#cff00ff当前亲密度"
	-- self.view:addChild(lab);
	local lab = CCZXImage:imageWithFile(159,207,-1,-1,UILH_MARRIAGE.qinmidu)
	self.view:addChild(lab);

	self.sweet_value = UILabel:create_lable_2( "0", 213, 183, 16, ALIGN_CENTER );
	self.view:addChild(self.sweet_value);

	-- 仙缘级别
	local function xianyuan_event( eventType )
		if eventType == TOUCH_CLICK then

			local data = MarriageModel:get_marriage_data(  );
			TipsModel:show_XY_tip( data );

		end
	end
	self.xianyuan_btn = MUtils:create_btn(self.view, UIResourcePath.FileLocate.lh_marriage.."xianyuan_0.png", UIResourcePath.FileLocate.lh_marriage.."xianyuan_0.png",
											xianyuan_event, 165, 259, 101, 80);

	-- 特效层
	self.effect_view = CCBasePanel:panelWithFile( 0, 0, w, h,"");
	self.view:addChild(self.effect_view);

	-- 分割线
	local line = CCZXImage:imageWithFile( 438, 10, 4, 480, UILH_MARRIAGE.split_line_v)
	self.view:addChild(line)

    -- 右半边
    -- 背景
	local flower_bg = CCZXImage:imageWithFile( 523, 173, -1, -1, UILH_MARRIAGE.flower_bg)
	self.view:addChild(flower_bg)

	--终极戒指
	local final_ring = MUtils:create_one_slotItem( 11106, 619, 392, 67, 67 );
	final_ring:set_icon_bg_texture( UILH_MARRIAGE.item_bg, -3, -3, 73, 73 )
	final_ring:set_color_frame(nil);
	self.view:addChild(final_ring.view);
	local function show_final_ring_tip(  )
		TipsModel:show_marriage_ring( 11106, 10, TipsModel.LAYOUT_LEFT)
	end
	final_ring:set_click_event( show_final_ring_tip );
	-- 极品预览
	local lab_bg = MUtils:create_zximg( self.view, UILH_NORMAL.level_bg, 610, 347, -1, -1 );
	MUtils:create_zximg( lab_bg, UILH_MARRIAGE.jipinyulan, 9, 9, -1, -1 );

	-- 当前戒指
	self.curr_ring = MUtils:create_one_slotItem( nil, 510, 258, 67, 67 );
	self.curr_ring:set_icon_bg_texture( UILH_MARRIAGE.item_bg, -3, -3, 73, 73)
	self.view:addChild(self.curr_ring.view);

	-- 箭头 arrow
	local arrow = MUtils:create_zximg( self.view, UILH_MARRIAGE.arrow, 617, 274, -1, -1 );
	
	-- 下级戒指
	self.next_ring = MUtils:create_one_slotItem( nil, 510+220, 258, 67, 67 );
	self.next_ring:set_icon_bg_texture( UILH_MARRIAGE.item_bg, -3, -3, 73, 73)
	self.view:addChild(self.next_ring.view);

	-- 需要情意
	self.need_qingyi_lab = UILabel:create_lable_2( LangGameString[1521], 600,202, 17, ALIGN_LEFT ); -- [1521]="#cfff000需要情意: #cffffff0"
    self.view:addChild( self.need_qingyi_lab );

   	-- 提升
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
					self:play_xy_uplevel_effect2();
				else
					GlobalFunc:create_screen_notic("您的情意值不足，不能升级戒指!") -- [1524]="您的情意值不足，不能升级戒指!"
				end
			end
		end

		local cb = callback:new()
		local function update_ui(  )
			-- 更新戒指
			self:update_ring();
			--更新情意度
			local data = MarriageModel:get_marriage_data();
        	-- self.qingyuan_page:update_sweet_value( data.sweet );
        	self:update_curr_qingyi_value( data.qingyi );
    		cb:cancel();
		end
		cb:start( 0.5,update_ui )
	end
   	self.uplevel_btn = ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.qinzhu,up_level_ring,594, 124);
	self.uplevel_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_MARRIAGE.btn1_d)
	self.uplevel_btn.view:setCurState(CLICK_STATE_UP);
    -- local uplevel_btn = TextButton:create( nil, 350/2-87/2, 95, 87, 34, LangGameString[1522], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1522]="#cfafed0提升"
	-- self.view:addChild( uplevel_btn.view );
	-- uplevel_btn:setTouchClickFun(up_level_ring);

	--戒指获得
	local ring_help_btn = TextButton:create( nil, 460, 25, 87, 34, LangGameString[1525], nil ); -- [1525]="#cfff000#u1戒指获得#u0"
	self.view:addChild( ring_help_btn.view );
	local function ring_help_event(  )
		-- print("戒指获得");
		local str = LangGameString[1526] -- [1526]="1、通关深海之恋获得心之碎片8个可合成出求婚戒指深海之心(未激活)#r2、通过商城购买雪月情缘超值礼包或仙侣情缘超值礼包获得#r3、向心仪对象求婚成功，则未激活戒指则转变为结婚戒指佩戴在身上#r4、被求婚者也获得同样的结婚戒指佩戴在身上"
		HelpPanel:show( 3, UILH_NORMAL.title_tips, str );
	end
	ring_help_btn:setTouchClickFun(ring_help_event);

	--情意获得
	local qingyi_help_btn = TextButton:create( nil, 765, 25, 87, 34, LangGameString[1527], nil ); -- [1527]="#cfff000#u1情意获得#u0"
	self.view:addChild( qingyi_help_btn.view );
	local function qingyi_help_event(  )
		local str = LangGameString[1528]; -- [1528]="1、每种戒指可以提升到10级，继续提升，可以升级为最高品质的戒指#r2、戒指提升需要情意，情意可以通过云车巡游获得#r3、婚姻关系解除，系统回收戒指，并且退还50%情意"
		HelpPanel:show( 3, UILH_NORMAL.title_tips, str );
	end
	qingyi_help_btn:setTouchClickFun(qingyi_help_event);

	-- 当前情意
	self.curr_qingyi_lab = UILabel:create_lable_2(LangGameString[1529], 839,67, 17, ALIGN_RIGHT ) -- [1529]="#cff66cc当前情意: #cffffff0"
	self.view:addChild(self.curr_qingyi_lab);

	self.effect_view2 = CCBasePanel:panelWithFile( 0, 0, w, h,"");
	self.view:addChild(self.effect_view2);

	-- 更新戒指信息
	-- self:update_ring()
end


------------------------------界面更新

function MarriagePageQingMi:active( show )
	if show == true then
		-- 切换该分页时需要请求更新数据
		MarriageCC:req_observor_xianyuan( )
        self:update_sweet_value(  )
        self:update_ring()
		local data = MarriageModel:get_marriage_data( );
	    if data.qingyi ~= nil then
	        self:update_curr_qingyi_value( data.qingyi )
	    end
	else
		self.effect_view:removeAllChildrenWithCleanup(true);
		self.effect_view2:removeAllChildrenWithCleanup(true);
	end
end

function MarriagePageQingMi:update_ring(  )

	-- 当前戒指
	local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
	local ring_id = nil;
	if ring_model then
		-- 是否有佩戴结婚戒指(婚戒不可卸下，只有离婚才可卸下)
		ring_id = ring_model.item_id;
	end	
	if ring_id ~= nil then
		self.curr_ring:set_icon(ring_id);
		self.curr_ring:set_color_frame(ring_id,0,0,67,67);
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
		self.next_ring:set_color_frame(next_ring_id,0,0,67,67);
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

-- 更新亲密度
function MarriagePageQingMi:update_sweet_value(  )
    local data = MarriageModel:get_marriage_data();
    if data.sweet ~= nil then
        -- print( "更新亲密度", data.sweet);
        self.sweet_value:setText(tostring(data.sweet));
    end
end

-- 更新情意值
function MarriagePageQingMi:update_curr_qingyi_value( qingyi_value )
	self.curr_qingyi_lab:setText("#cff66cc当前情意: #cffffff"..qingyi_value); -- [1530]="#cff66cc当前情意: #cffffff"
	local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
	if ring_model then
		local need_qy = MarriageConfig:get_need_qy_for_uplevel( ring_model.item_id, ring_model.strong );
		self.need_qingyi_lab:setText( "#cfff000需要情意: #cffffff"..need_qy ); -- [1531]="#cfff000需要情意: #cffffff"
	end
end

function MarriagePageQingMi:destroy()
	if self.effect_view then
		self.effect_view:removeAllChildrenWithCleanup(true);
	end
	if self.effect_view2 then
		self.effect_view2:removeAllChildrenWithCleanup(true);
	end
end

-- 更新仙缘等级
function MarriagePageQingMi:update_xianyuan_level( count, level )
	
	local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
	if ring_model ~= nil then
		self.qingzhu_btn.view:setCurState(CLICK_STATE_UP);
		self.uplevel_btn.view:setCurState(CLICK_STATE_UP);
		-- self.qingzhu_btn.view:setIsVisible(true)
	else
		self.qingzhu_btn.view:setCurState(CLICK_STATE_DISABLE);
		self.uplevel_btn.view:setCurState(CLICK_STATE_DISABLE);
		-- self.qingzhu_btn.view:setIsVisible(false)
	end

	for i,v in ipairs(self.btn_dict) do
		v:setText( ""..level );
		v.view:addTexWithFile(CLICK_STATE_UP, UILH_MARRIAGE.heart_gray)
		v.view:setCurState(CLICK_STATE_UP);

		if i <= count then
			
			v:setText( ""..(level+1) );
			v.view:addTexWithFile( CLICK_STATE_UP, UILH_MARRIAGE.heart_light)
			v.view:setCurState(CLICK_STATE_UP);
		end
	end


	if level == 8 and count == 10 then
		-- 当然等级为8，且点亮的红心数为10，这时为满级，没有下发9级的，这时候做9级处理
		level = 9;
	end
	local str = string.format("xianyuan_%d.png",level);
	self.xianyuan_btn:addTexWithFile( CLICK_STATE_UP, UIResourcePath.FileLocate.lh_marriage .. str )
	self.xianyuan_btn:addTexWithFile( CLICK_STATE_DOWN, UIResourcePath.FileLocate.lh_marriage .. str )
	self.xianyuan_btn:setCurState( CLICK_STATE_UP );

end	

-- 播放红心点亮成功的特效
function MarriagePageQingMi:play_heart_effect( heart_index )

	local effectManager = ZXEffectManager:sharedZXEffectManager();

    effectManager:run_mount_xilian_action("frame/effect/jm/11016", "frame/effect/jm/11016", self.effect_view, pos_dict[heart_index][1]+62/2, pos_dict[heart_index][2]+58/2,
                                            165+101/2, 259+80/2,0.5);

end

-- 播放仙缘等级升级成功的特效
function MarriagePageQingMi:play_xy_uplevel_effect(  )
	LuaEffectManager:play_view_effect( 408, 210, 280, self.effect_view, false);
end

-- 播放戒指等级升级成功的特效
function MarriagePageQingMi:play_xy_uplevel_effect2(  )
	LuaEffectManager:play_view_effect( 408, 650, 300, self.effect_view2, false);
end