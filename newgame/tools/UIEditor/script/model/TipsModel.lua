-- TipsModel.lua
-- created by fjh on 2013-1-23
-- TiPsModel模型 动态数据

TipsModel = {}

TipsModel.LAYOUT_LEFT = 1;
TipsModel.LAYOUT_CENTER = 2;
TipsModel.LAYOUT_RIGHT = 3;

-- added by aXIng on 2013-5-25
function TipsModel:fini( ... )
	-- body
end

-- 根据布局方式返回相应的坐标
function TipsModel:get_position_by_layout( layout )
	local x ,y ;
	if layout == TipsModel.LAYOUT_LEFT then
		-- x=游戏屏幕大小-右窗口大小425-偏差值25-tip大小的一半（因为tip的锚点在中心）
		x = GameScreenConfig.ui_screen_width - 450 - UI_TOOLTIPS_RECT_WIDTH/2  --332;

	elseif layout == TipsModel.LAYOUT_CENTER then
		-- 目前没有CENTER需求，就先不做适配了
		x = 400;
	elseif layout == TipsModel.LAYOUT_RIGHT then
		x = 628;
	end
	y = 323;
	return x,y;
end

-- 根据坐标在屏幕位置返回一个自适应的坐标
function TipsModel:auto_position( x, y, w, h )
	local _screenWidth = GameScreenConfig.ui_screen_width
	local _screenHeight = GameScreenConfig.ui_screen_height
	local auto_x = x
	local auto_y = y
	if y + h * 0.5 > _screenHeight then
		auto_y = _screenHeight - h * 0.5 - 25
	end
	if y - h * 0.5 < 0 then
		auto_y = ( h * 0.5 ) + 25
	end
	local final_x = auto_x + w * 0.5 + 32
	if auto_x + w * 0.5 > _screenHeight then
		final_x =  auto_x - w * 0.5 - 32
	end
	auto_x = final_x
	return auto_x, auto_y;
end

-- 根据坐标在屏幕位置返回一个自适应的坐标，依天降雄师策划需求改写。note by guozhinan
function TipsModel:auto_position_lh( x, y, w, h )
	print("开始自动适配",x, y, w, h)
	local auto_x = x
	local auto_y = y
	local _screenWidth = GameScreenConfig.ui_screen_width
	local _screenHeight = GameScreenConfig.ui_screen_height

	-- 先校正x方向，优先右边显示
	if x + w < _screenWidth then
		auto_x = x + w*0.5
	elseif x - w > 0 then
		auto_x = x - w*0.5
	else
		-- 都不够显示，只能盖住点击处了。
		if x <= _screenWidth/2 then
			auto_x = _screenWidth - w*0.5 - 5
		else
			auto_x = 0 + w*0.5 + 5
		end
	end

	-- 校正y方向，优先下方显示
	if y - h > 0 then
		auto_y = y - h*0.5
	elseif y + h < _screenHeight then
		auto_y = y + h*0.5
	else
		-- 都不够显示，只能盖住点击处了。
		if y >= _screenHeight/2 then
			auto_y = 0 + h*0.5 + 5
		else
			auto_y = _screenHeight - h*0.5 - 5
		end
	end
	print("适配结果",auto_x, auto_y)
	return auto_x, auto_y;
end

--显示商店里的tip
function TipsModel:show_shop_tip( x, y, item_id ,layout)
	require "struct/UserItem"
	local data = UserItem(nil);
	data.item_id = item_id;
	data.flag = 0;
	data.strong = 0;
	data.holes = {0,0,0};
	data.void_bytes_tab = {1};
	
	TipsModel:show_tip( x,y,data,nil,nil,nil,nil,nil, layout,nil,nil)
	
end


--显示背包里的tip
function TipsModel:show_tip( x,y,data,use_func,split_func,fromPersonWin,left_name,reight_name, layout, quick_func,center_name)
	
	if data == nil then
		return;
	end

	if layout then
		x,y = TipsModel:get_position_by_layout( layout )
	end

	-- ZXLog('-----------show_tip-----------',data.item_id)

	local tip_win = TipsWin:showTip(x,y,data,use_func,split_func,quick_func,fromPersonWin,left_name,reight_name,center_name);
	
	if layout == nil then
		-- 如果不是有默认布局，则对传进来的坐标进行自适应
		local scaleX = GameScaleFactors.screen_to_ui_factorX
		local scaleY = GameScaleFactors.screen_to_ui_factorY

		local auto_x, auto_y;
		-- if is_lh_tip == true then
		-- 	auto_x, auto_y = TipsModel:auto_position_lh( x * scaleX, y * scaleY, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
		-- else
			auto_x, auto_y = TipsModel:auto_position( x * scaleX, y * scaleY, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
		-- end
		-- ZXLog('-----------show_tip-----------',data.item_id,auto_x,auto_y,x,y)
		tip_win.tip_bg:setPosition(auto_x, auto_y);
	end
	--print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
end

--显示人物技能tip
function TipsModel:show_user_skill_tip( x, y, data,use_func,btn_name)

	x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT )
	
	TipsWin:showUserSkillTip( x,y,data,use_func,btn_name );
end
--显示宠物技能tip
function TipsModel:show_pet_skill_tip( x,y,data )
	print("宠物技能tip",x,y);
	local tip_win = TipsWin:showPetSkillTip(x,y,data);
	local scale = GameScaleFactors.ui_scale_factor
	local auto_x, auto_y = TipsModel:auto_position( x/scale, y/scale, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
	tip_win.tip_bg:setPosition(auto_x, auto_y);

end

--显示美人卡牌tip
function TipsModel:show_meiren_tip( x,y,data )
	-- x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT )
	print("x y  坐标",x,y)
	local tip_win = TipsWin:showMeirenTip(x,y,data);
	local scale = GameScaleFactors.ui_scale_factor
	local auto_x, auto_y = TipsModel:auto_position_lh( x/scale, y/scale, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
	tip_win.tip_bg:setPosition(auto_x, auto_y);
end

--显示翅膀技能tip
function TipsModel:show_wing_skill_tip( x,y,data )
	-- x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT )
	local tip_win = TipsWin:showWingSkillTip(x,y,data);
	local scale = GameScaleFactors.ui_scale_factor
	local auto_x, auto_y = TipsModel:auto_position( x/scale, y/scale, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
	tip_win.tip_bg:setPosition(auto_x, auto_y);
end


--全身宝石 data: { 满装等级，个数， 职业 }
function TipsModel:show_stone_levels_tip( x, y, data )
	
	x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT )
 	TipsWin:showStoneLevelsTip( x, y, data);

end

--全身强化  data:{ 强化总数， 职业 }
function TipsModel:show_strong_levels_tip( x, y, data )

	x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT )
	TipsWin:showStrongLevelsTip( x,y,data );

end

--神兽赐福
function TipsModel:show_shenshou_cifu_tip( x, y, data )

	x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT )
	TipsWin:showShenShouTip( x,y,data );

end


-- 根据翅膀的id显示tip
-- 
function TipsModel:show_wing_tip_by_item_id( x, y, item_id )
	local wing = {};

	if item_id == 11400 then
		wing.level = 1
		wing.stage = 1;
		wing.skill1_level = 0;
	elseif item_id == 11401 then
		wing.level = 10
		wing.stage = 2
		wing.skill1_level = 1
	elseif item_id == 11402 then
		wing.level = 10
		wing.stage = 2;
		wing.skill1_level = 1;
	end
	wing.item_id = item_id;

	wing.star = 0;
	wing.skill2_level = 0;
	wing.skill3_level = 0;
	wing.skill4_level = 0;
	wing.skill5_level = 0;
	wing.skill6_level = 0;
	wing.skill7_level = 0;
	wing.skill8_level = 0;
	wing.skill9_level = 0;
	wing.is_hyperlink = true;
	TipsModel:show_tip( x,y,wing,nil,nil,nil,nil,nil,nil )
	
end

-- 显示法宝器魂tip
function TipsModel:show_fabao_xianhun( x,y,xianhun_data,layout )
	if layout then
		x,y = TipsModel:get_position_by_layout( layout );
	end
	TipsWin:showXianhunTip( x,y,xianhun_data );

end

-- 显示货币的tip
function TipsModel:show_money_tip( x, y,data, layout )
	
	if layout then
		x,y = TipsModel:get_position_by_layout( layout );
	end

	local tip_win = TipsWin:showMoneyTip( x,y,data );

	local scale = GameScaleFactors.ui_scale_factor
	x, y = TipsModel:auto_position( x/scale, y/scale, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
	tip_win.tip_bg:setPosition(x, y);
	
end

-- 显示指定id，指定等级的结婚戒指
function TipsModel:show_marriage_ring( item_id, level, layout, x, y)
	-- body
	local data = UserItem(nil);
	data.series = 1;	--serise不为空即可
	data.item_id = item_id;
	data.flag = 1;
	data.strong = level;
	data.holes = {0,0,0};
	data.void_bytes_tab = {1};

	TipsModel:show_tip( x,y,data,nil,nil,nil,nil,nil, layout,nil,nil );
	
end

-- 显示结婚系统的红心tip
function TipsModel:show_heart_tip( data )
	print("显示结婚系统的红心tip");
	local x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT );

	local tip_win = TipsWin:showHeartTip( x,y,data );
end
-- 显示结婚系统的仙缘等级tip
function TipsModel:show_XY_tip( data )
	
	local x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT );
	
	TipsWin:showXYTip(x,y,data);
end
-- 显示结婚系统的详细信息tip
function TipsModel:show_XY_detail_tip( data )
	local x,y = TipsModel:get_position_by_layout( TipsModel.LAYOUT_RIGHT );
	
	TipsWin:showXYDetailTip(x,y,data);
	
end

--显示特殊坐骑tip
function TipsModel:show_special_mount_tip( x,y,data )
	local tip_win = TipsWin:showSpecialMountTip(x,y,data);
	local scale = GameScaleFactors.ui_scale_factor
	local auto_x, auto_y = TipsModel:auto_position( x/scale, y/scale, tip_win.tip_bg:getSize().width, tip_win.tip_bg:getSize().height);
	tip_win.tip_bg:setPosition(auto_x, auto_y);
end